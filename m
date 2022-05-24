Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9C5532455
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 09:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbiEXHm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 03:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiEXHmy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 03:42:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745316EC58;
        Tue, 24 May 2022 00:42:52 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24O5grJr027232;
        Tue, 24 May 2022 07:42:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=d2tR0YIHR3Zivg6NDJcx6LfX1W1c2zfy07akTVWP2Bw=;
 b=f3TXbDowL4i1KrIBJjuUxrHDF3z0RSA2+um3YYpywm3CD0dN26pZjfayuFxe0Z3dp9OZ
 vQdudykiT6W46GbgQrAj1zdH6Be/lHFFDwwihwrM55VMDCDxk942ImfWDbGniXsAEHFF
 vEl9oW9nsMM8bWNkKXchI1HeOfBaJvW5+Wn4ynlUqBav5M5/RLxCYReCibh/+5/ouxb7
 RhMiDIT12VIAKoKleUV7rVNzMGy/NcdtWicbUsJvKxDXxaw+f7Ku/21sr5kYzcnNmsZ5
 USxwvGqCUhmju3ISpKRJGUSZ/gO+C9EOHV2M7W/O979HwBpUhGRPUbg/GqMOkdUxqaPo XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8sf22a77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 07:42:51 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24O6RuWt003292;
        Tue, 24 May 2022 07:42:50 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8sf22a6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 07:42:50 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24O7gnYD017933;
        Tue, 24 May 2022 07:42:49 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3g6qq94ech-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 07:42:48 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24O7fuw333358140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 07:41:56 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FBCF11C04C;
        Tue, 24 May 2022 07:42:45 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C515011C052;
        Tue, 24 May 2022 07:42:44 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.98])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 07:42:44 +0000 (GMT)
Date:   Tue, 24 May 2022 09:42:42 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/2] s390x: Introduce symbol for
 lowcore and use it
Message-ID: <20220524094242.6eead3e7@p-imbrenda>
In-Reply-To: <20220520140546.311193-2-scgl@linux.ibm.com>
References: <20220520140546.311193-1-scgl@linux.ibm.com>
        <20220520140546.311193-2-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yGDWCLCpJnru3yfrtnE-bIcjPFv20MiG
X-Proofpoint-ORIG-GUID: y96-DglbDmS8hR4t-Mn1PkGG4m1cSfGX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_05,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 phishscore=0 adultscore=0 bulkscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205240041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 May 2022 16:05:45 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> This gets rid of bunch of pointers pointing to the lowcore used in
> various places and replaces it with a unified way of addressing the
> lowcore.
> The new symbol is not a pointer. While this will lead to worse code
> generation (cannot use register 0 for addressing), that should not
> matter too much for kvm unit tests.
> The symbol also will be used to create pointers that the compiler cannot
> warn about as being outside the bounds of an array.

please also briefly explain that you are achieving all this with a small
change in the linker script

> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h   |  2 ++
>  lib/s390x/asm/facility.h   |  4 +--
>  lib/s390x/css.h            |  2 --
>  lib/s390x/css_lib.c        | 12 ++++----
>  lib/s390x/fault.c          | 10 +++----
>  lib/s390x/interrupt.c      | 61 +++++++++++++++++++-------------------
>  lib/s390x/mmu.c            |  3 +-
>  s390x/flat.lds             |  1 +
>  s390x/snippets/c/flat.lds  |  1 +
>  s390x/css.c                |  4 +--
>  s390x/diag288.c            |  4 +--
>  s390x/edat.c               |  5 ++--
>  s390x/emulator.c           | 10 +++----
>  s390x/mvpg.c               |  7 ++---
>  s390x/sclp.c               |  3 +-
>  s390x/skrf.c               | 11 +++----
>  s390x/smp.c                | 23 +++++++-------
>  s390x/snippets/c/spec_ex.c |  5 ++--
>  18 files changed, 75 insertions(+), 93 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 72553819..78b257b7 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -145,6 +145,8 @@ struct lowcore {
>  } __attribute__ ((__packed__));
>  _Static_assert(sizeof(struct lowcore) == 0x1900, "Lowcore size");
>  
> +extern struct lowcore lowcore;
> +
>  #define PGM_INT_CODE_OPERATION			0x01
>  #define PGM_INT_CODE_PRIVILEGED_OPERATION	0x02
>  #define PGM_INT_CODE_EXECUTE			0x03
> diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
> index ef0fd037..49380203 100644
> --- a/lib/s390x/asm/facility.h
> +++ b/lib/s390x/asm/facility.h
> @@ -36,10 +36,8 @@ static inline void stfle(uint64_t *fac, unsigned int nb_doublewords)
>  
>  static inline void setup_facilities(void)
>  {
> -	struct lowcore *lc = NULL;
> -
>  	stfl();
> -	memcpy(stfl_doublewords, &lc->stfl, sizeof(lc->stfl));
> +	memcpy(stfl_doublewords, &lowcore.stfl, sizeof(lowcore.stfl));
>  	if (test_facility(7))
>  		stfle(stfl_doublewords, NB_STFL_DOUBLEWORDS);
>  }
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index a6a68577..0a19324b 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -9,8 +9,6 @@
>  #ifndef _S390X_CSS_H_
>  #define _S390X_CSS_H_
>  
> -#define lowcore_ptr ((struct lowcore *)0x0)
> -
>  /* subchannel ID bit 16 must always be one */
>  #define SCHID_ONE	0x00010000
>  
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index a9f5097f..b4d1f086 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -357,11 +357,11 @@ void css_irq_io(void)
>  	int sid;
>  
>  	report_prefix_push("Interrupt");
> -	sid = lowcore_ptr->subsys_id_word;
> +	sid = lowcore.subsys_id_word;
>  	/* Lowlevel set the SID as interrupt parameter. */
> -	if (lowcore_ptr->io_int_param != sid) {
> +	if (lowcore.io_int_param != sid) {
>  		report_fail("io_int_param: %x differs from subsys_id_word: %x",
> -			    lowcore_ptr->io_int_param, sid);
> +			    lowcore.io_int_param, sid);
>  		goto pop;
>  	}
>  	report_prefix_pop();
> @@ -387,7 +387,7 @@ void css_irq_io(void)
>  	}
>  pop:
>  	report_prefix_pop();
> -	lowcore_ptr->io_old_psw.mask &= ~PSW_MASK_WAIT;
> +	lowcore.io_old_psw.mask &= ~PSW_MASK_WAIT;
>  }
>  
>  int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw)
> @@ -432,9 +432,9 @@ int wait_and_check_io_completion(int schid)
>  
>  	report_prefix_push("check I/O completion");
>  
> -	if (lowcore_ptr->io_int_param != schid) {
> +	if (lowcore.io_int_param != schid) {
>  		report_fail("interrupt parameter: expected %08x got %08x",
> -			    schid, lowcore_ptr->io_int_param);
> +			    schid, lowcore.io_int_param);
>  		ret = -1;
>  		goto end;
>  	}
> diff --git a/lib/s390x/fault.c b/lib/s390x/fault.c
> index d3ef00e4..efa62fcb 100644
> --- a/lib/s390x/fault.c
> +++ b/lib/s390x/fault.c
> @@ -13,8 +13,6 @@
>  #include <asm/page.h>
>  #include <fault.h>
>  
> -static struct lowcore *lc = (struct lowcore *)0x0;
> -
>  /* Decodes the protection exceptions we'll most likely see */
>  static void print_decode_pgm_prot(uint64_t teid)
>  {
> @@ -37,7 +35,7 @@ static void print_decode_pgm_prot(uint64_t teid)
>  void print_decode_teid(uint64_t teid)
>  {
>  	int asce_id = teid & 3;
> -	bool dat = lc->pgm_old_psw.mask & PSW_MASK_DAT;
> +	bool dat = lowcore.pgm_old_psw.mask & PSW_MASK_DAT;
>  
>  	printf("Memory exception information:\n");
>  	printf("DAT: %s\n", dat ? "on" : "off");
> @@ -58,15 +56,15 @@ void print_decode_teid(uint64_t teid)
>  		break;
>  	}
>  
> -	if (lc->pgm_int_code == PGM_INT_CODE_PROTECTION)
> +	if (lowcore.pgm_int_code == PGM_INT_CODE_PROTECTION)
>  		print_decode_pgm_prot(teid);
>  
>  	/*
>  	 * If teid bit 61 is off for these two exception the reported
>  	 * address is unpredictable.
>  	 */
> -	if ((lc->pgm_int_code == PGM_INT_CODE_SECURE_STOR_ACCESS ||
> -	     lc->pgm_int_code == PGM_INT_CODE_SECURE_STOR_VIOLATION) &&
> +	if ((lowcore.pgm_int_code == PGM_INT_CODE_SECURE_STOR_ACCESS ||
> +	     lowcore.pgm_int_code == PGM_INT_CODE_SECURE_STOR_VIOLATION) &&
>  	    !test_bit_inv(61, &teid)) {
>  		printf("Address: %lx, unpredictable\n ", teid & PAGE_MASK);
>  		return;
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 27d3b767..6da20c44 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -18,20 +18,19 @@
>  static bool pgm_int_expected;
>  static bool ext_int_expected;
>  static void (*pgm_cleanup_func)(void);
> -static struct lowcore *lc;
>  
>  void expect_pgm_int(void)
>  {
>  	pgm_int_expected = true;
> -	lc->pgm_int_code = 0;
> -	lc->trans_exc_id = 0;
> +	lowcore.pgm_int_code = 0;
> +	lowcore.trans_exc_id = 0;
>  	mb();
>  }
>  
>  void expect_ext_int(void)
>  {
>  	ext_int_expected = true;
> -	lc->ext_int_code = 0;
> +	lowcore.ext_int_code = 0;
>  	mb();
>  }
>  
> @@ -40,9 +39,9 @@ uint16_t clear_pgm_int(void)
>  	uint16_t code;
>  
>  	mb();
> -	code = lc->pgm_int_code;
> -	lc->pgm_int_code = 0;
> -	lc->trans_exc_id = 0;
> +	code = lowcore.pgm_int_code;
> +	lowcore.pgm_int_code = 0;
> +	lowcore.trans_exc_id = 0;
>  	pgm_int_expected = false;
>  	return code;
>  }
> @@ -50,9 +49,9 @@ uint16_t clear_pgm_int(void)
>  void check_pgm_int_code(uint16_t code)
>  {
>  	mb();
> -	report(code == lc->pgm_int_code,
> +	report(code == lowcore.pgm_int_code,
>  	       "Program interrupt: expected(%d) == received(%d)", code,
> -	       lc->pgm_int_code);
> +	       lowcore.pgm_int_code);
>  }
>  
>  void register_pgm_cleanup_func(void (*f)(void))
> @@ -63,29 +62,29 @@ void register_pgm_cleanup_func(void (*f)(void))
>  static void fixup_pgm_int(struct stack_frame_int *stack)
>  {
>  	/* If we have an error on SIE we directly move to sie_exit */
> -	if (lc->pgm_old_psw.addr >= (uint64_t)&sie_entry &&
> -	    lc->pgm_old_psw.addr <= (uint64_t)&sie_exit) {
> -		lc->pgm_old_psw.addr = (uint64_t)&sie_exit;
> +	if (lowcore.pgm_old_psw.addr >= (uint64_t)&sie_entry &&
> +	    lowcore.pgm_old_psw.addr <= (uint64_t)&sie_exit) {
> +		lowcore.pgm_old_psw.addr = (uint64_t)&sie_exit;
>  	}
>  
> -	switch (lc->pgm_int_code) {
> +	switch (lowcore.pgm_int_code) {
>  	case PGM_INT_CODE_PRIVILEGED_OPERATION:
>  		/* Normal operation is in supervisor state, so this exception
>  		 * was produced intentionally and we should return to the
>  		 * supervisor state.
>  		 */
> -		lc->pgm_old_psw.mask &= ~PSW_MASK_PSTATE;
> +		lowcore.pgm_old_psw.mask &= ~PSW_MASK_PSTATE;
>  		break;
>  	case PGM_INT_CODE_PROTECTION:
>  		/* Handling for iep.c test case. */
> -		if (prot_is_iep(lc->trans_exc_id))
> +		if (prot_is_iep(lowcore.trans_exc_id))
>  			/*
>  			 * We branched to the instruction that caused
>  			 * the exception so we can use the return
>  			 * address in GR14 to jump back and continue
>  			 * executing test code.
>  			 */
> -			lc->pgm_old_psw.addr = stack->grs0[12];
> +			lowcore.pgm_old_psw.addr = stack->grs0[12];
>  		break;
>  	case PGM_INT_CODE_SEGMENT_TRANSLATION:
>  	case PGM_INT_CODE_PAGE_TRANSLATION:
> @@ -122,14 +121,14 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
>  		/* The interrupt was nullified, the old PSW points at the
>  		 * responsible instruction. Forward the PSW so we don't loop.
>  		 */
> -		lc->pgm_old_psw.addr += lc->pgm_int_id;
> +		lowcore.pgm_old_psw.addr += lowcore.pgm_int_id;
>  	}
>  	/* suppressed/terminated/completed point already at the next address */
>  }
>  
>  static void print_storage_exception_information(void)
>  {
> -	switch (lc->pgm_int_code) {
> +	switch (lowcore.pgm_int_code) {
>  	case PGM_INT_CODE_PROTECTION:
>  	case PGM_INT_CODE_PAGE_TRANSLATION:
>  	case PGM_INT_CODE_SEGMENT_TRANSLATION:
> @@ -140,7 +139,7 @@ static void print_storage_exception_information(void)
>  	case PGM_INT_CODE_SECURE_STOR_ACCESS:
>  	case PGM_INT_CODE_NON_SECURE_STOR_ACCESS:
>  	case PGM_INT_CODE_SECURE_STOR_VIOLATION:
> -		print_decode_teid(lc->trans_exc_id);
> +		print_decode_teid(lowcore.trans_exc_id);
>  		break;
>  	}
>  }
> @@ -165,13 +164,13 @@ static void print_pgm_info(struct stack_frame_int *stack)
>  {
>  	bool in_sie;
>  
> -	in_sie = (lc->pgm_old_psw.addr >= (uintptr_t)sie_entry &&
> -		  lc->pgm_old_psw.addr <= (uintptr_t)sie_exit);
> +	in_sie = (lowcore.pgm_old_psw.addr >= (uintptr_t)sie_entry &&
> +		  lowcore.pgm_old_psw.addr <= (uintptr_t)sie_exit);
>  
>  	printf("\n");
>  	printf("Unexpected program interrupt %s: %#x on cpu %d at %#lx, ilen %d\n",
>  	       in_sie ? "in SIE" : "",
> -	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr, lc->pgm_int_id);
> +	       lowcore.pgm_int_code, stap(), lowcore.pgm_old_psw.addr, lowcore.pgm_int_id);
>  	print_int_regs(stack);
>  	dump_stack();
>  
> @@ -201,13 +200,13 @@ void handle_pgm_int(struct stack_frame_int *stack)
>  void handle_ext_int(struct stack_frame_int *stack)
>  {
>  	if (!ext_int_expected &&
> -	    lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
> +	    lowcore.ext_int_code != EXT_IRQ_SERVICE_SIG) {
>  		report_abort("Unexpected external call interrupt (code %#x): on cpu %d at %#lx",
> -			     lc->ext_int_code, stap(), lc->ext_old_psw.addr);
> +			     lowcore.ext_int_code, stap(), lowcore.ext_old_psw.addr);
>  		return;
>  	}
>  
> -	if (lc->ext_int_code == EXT_IRQ_SERVICE_SIG) {
> +	if (lowcore.ext_int_code == EXT_IRQ_SERVICE_SIG) {
>  		stack->crs[0] &= ~(1UL << 9);
>  		sclp_handle_ext();
>  	} else {
> @@ -215,13 +214,13 @@ void handle_ext_int(struct stack_frame_int *stack)
>  	}
>  
>  	if (!(stack->crs[0] & CR0_EXTM_MASK))
> -		lc->ext_old_psw.mask &= ~PSW_MASK_EXT;
> +		lowcore.ext_old_psw.mask &= ~PSW_MASK_EXT;
>  }
>  
>  void handle_mcck_int(void)
>  {
>  	report_abort("Unexpected machine check interrupt: on cpu %d at %#lx",
> -		     stap(), lc->mcck_old_psw.addr);
> +		     stap(), lowcore.mcck_old_psw.addr);
>  }
>  
>  static void (*io_int_func)(void);
> @@ -232,7 +231,7 @@ void handle_io_int(void)
>  		return io_int_func();
>  
>  	report_abort("Unexpected io interrupt: on cpu %d at %#lx",
> -		     stap(), lc->io_old_psw.addr);
> +		     stap(), lowcore.io_old_psw.addr);
>  }
>  
>  int register_io_int_func(void (*f)(void))
> @@ -253,14 +252,14 @@ int unregister_io_int_func(void (*f)(void))
>  
>  void handle_svc_int(void)
>  {
> -	uint16_t code = lc->svc_int_code;
> +	uint16_t code = lowcore.svc_int_code;
>  
>  	switch (code) {
>  	case SVC_LEAVE_PSTATE:
> -		lc->svc_old_psw.mask &= ~PSW_MASK_PSTATE;
> +		lowcore.svc_old_psw.mask &= ~PSW_MASK_PSTATE;
>  		break;
>  	default:
>  		report_abort("Unexpected supervisor call interrupt: code %#x on cpu %d at %#lx",
> -			      code, stap(), lc->svc_old_psw.addr);
> +			      code, stap(), lowcore.svc_old_psw.addr);
>  	}
>  }
> diff --git a/lib/s390x/mmu.c b/lib/s390x/mmu.c
> index 6f9e6502..c9f8754c 100644
> --- a/lib/s390x/mmu.c
> +++ b/lib/s390x/mmu.c
> @@ -43,7 +43,6 @@ void configure_dat(int enable)
>  
>  static void mmu_enable(pgd_t *pgtable)
>  {
> -	struct lowcore *lc = NULL;
>  	const uint64_t asce = __pa(pgtable) | ASCE_DT_REGION1 |
>  			      REGION_TABLE_LENGTH;
>  
> @@ -55,7 +54,7 @@ static void mmu_enable(pgd_t *pgtable)
>  	configure_dat(1);
>  
>  	/* we can now also use DAT unconditionally in our PGM handler */
> -	lc->pgm_new_psw.mask |= PSW_MASK_DAT;
> +	lowcore.pgm_new_psw.mask |= PSW_MASK_DAT;
>  }
>  
>  /*
> diff --git a/s390x/flat.lds b/s390x/flat.lds
> index 86dffacd..de9da1a8 100644
> --- a/s390x/flat.lds
> +++ b/s390x/flat.lds
> @@ -7,6 +7,7 @@ SECTIONS
>  		 * address 0x10000 (cstart64.S .init).
>  		 */
>  		. = 0;
> +		lowcore = .;
>  		 LONG(0x00080000)
>  		 LONG(0x80010000)
>  		 /* Restart new PSW for booting via PSW restart. */
> diff --git a/s390x/snippets/c/flat.lds b/s390x/snippets/c/flat.lds
> index 59974b38..260ab1c4 100644
> --- a/s390x/snippets/c/flat.lds
> +++ b/s390x/snippets/c/flat.lds
> @@ -7,6 +7,7 @@ SECTIONS
>  		 * address 0x4000 (cstart.S .init).
>  		 */
>  		. = 0;
> +		lowcore = .;
>  		 LONG(0x00080000)
>  		 LONG(0x80004000)
>  		 /* Restart new PSW for booting via PSW restart. */
> diff --git a/s390x/css.c b/s390x/css.c
> index fabe5237..4b6e31b3 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -74,7 +74,7 @@ static void test_sense(void)
>  		return;
>  	}
>  
> -	lowcore_ptr->io_int_param = 0;
> +	lowcore.io_int_param = 0;
>  
>  	senseid = alloc_io_mem(sizeof(*senseid), 0);
>  	if (!senseid) {
> @@ -143,7 +143,7 @@ static void sense_id(void)
>  static void css_init(void)
>  {
>  	assert(register_io_int_func(css_irq_io) == 0);
> -	lowcore_ptr->io_int_param = 0;
> +	lowcore.io_int_param = 0;
>  
>  	report(get_chsc_scsc(), "Store Channel Characteristics");
>  }
> diff --git a/s390x/diag288.c b/s390x/diag288.c
> index 072c04a5..e414865b 100644
> --- a/s390x/diag288.c
> +++ b/s390x/diag288.c
> @@ -12,8 +12,6 @@
>  #include <asm/asm-offsets.h>
>  #include <asm/interrupt.h>
>  
> -struct lowcore *lc = (struct lowcore *)0x0;
> -
>  #define CODE_INIT	0
>  #define CODE_CHANGE	1
>  #define CODE_CANCEL	2
> @@ -92,7 +90,7 @@ static void test_bite(void)
>  	load_psw_mask(mask);
>  
>  	/* Arm watchdog */
> -	lc->restart_new_psw.mask = extract_psw_mask() & ~PSW_MASK_EXT;
> +	lowcore.restart_new_psw.mask = extract_psw_mask() & ~PSW_MASK_EXT;
>  	diag288(CODE_INIT, 15, ACTION_RESTART);
>  	asm volatile("		larl	%r0, 1f\n"
>  		     "		stg	%r0, 424\n"
> diff --git a/s390x/edat.c b/s390x/edat.c
> index c3bee0c8..c6c25042 100644
> --- a/s390x/edat.c
> +++ b/s390x/edat.c
> @@ -23,7 +23,6 @@
>  static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)));
>  static unsigned int tmp[1024] __attribute__((aligned(PAGE_SIZE)));
>  static void *root, *mem, *m;
> -static struct lowcore *lc;
>  volatile unsigned int *p;
>  
>  /*
> @@ -34,10 +33,10 @@ static bool check_pgm_prot(void *ptr)
>  {
>  	union teid teid;
>  
> -	if (lc->pgm_int_code != PGM_INT_CODE_PROTECTION)
> +	if (lowcore.pgm_int_code != PGM_INT_CODE_PROTECTION)
>  		return false;
>  
> -	teid.val = lc->trans_exc_id;
> +	teid.val = lowcore.trans_exc_id;
>  
>  	/*
>  	 * depending on the presence of the ESOP feature, the rest of the
> diff --git a/s390x/emulator.c b/s390x/emulator.c
> index b2787a55..c9182ea4 100644
> --- a/s390x/emulator.c
> +++ b/s390x/emulator.c
> @@ -14,8 +14,6 @@
>  #include <asm/float.h>
>  #include <linux/compiler.h>
>  
> -struct lowcore *lc = NULL;
> -
>  static inline void __test_spm_ipm(uint8_t cc, uint8_t key)
>  {
>  	uint64_t in = (cc << 28) | (key << 24);
> @@ -262,7 +260,7 @@ static void test_prno(void)
>  static void test_dxc(void)
>  {
>  	/* DXC (0xff) is to be stored in LC and FPC on a trap (CRT) with AFP */
> -	lc->dxc_vxc = 0x12345678;
> +	lowcore.dxc_vxc = 0x12345678;
>  	set_fpc_dxc(0);
>  
>  	report_prefix_push("afp");
> @@ -271,12 +269,12 @@ static void test_dxc(void)
>  		     : : "r"(0) : "memory");
>  	check_pgm_int_code(PGM_INT_CODE_DATA);
>  
> -	report(lc->dxc_vxc == 0xff, "dxc in LC");
> +	report(lowcore.dxc_vxc == 0xff, "dxc in LC");
>  	report(get_fpc_dxc() == 0xff, "dxc in FPC");
>  	report_prefix_pop();
>  
>  	/* DXC (0xff) is to be stored in LC only on a trap (CRT) without AFP */
> -	lc->dxc_vxc = 0x12345678;
> +	lowcore.dxc_vxc = 0x12345678;
>  	set_fpc_dxc(0);
>  
>  	report_prefix_push("no-afp");
> @@ -288,7 +286,7 @@ static void test_dxc(void)
>  	afp_enable();
>  	check_pgm_int_code(PGM_INT_CODE_DATA);
>  
> -	report(lc->dxc_vxc == 0xff, "dxc in LC");
> +	report(lowcore.dxc_vxc == 0xff, "dxc in LC");
>  	report(get_fpc_dxc() == 0, "dxc not in FPC");
>  	report_prefix_pop();
>  }
> diff --git a/s390x/mvpg.c b/s390x/mvpg.c
> index 04e5218f..296338d4 100644
> --- a/s390x/mvpg.c
> +++ b/s390x/mvpg.c
> @@ -33,7 +33,6 @@
>  
>  static uint8_t source[PAGE_SIZE]  __attribute__((aligned(PAGE_SIZE)));
>  static uint8_t buffer[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> -static struct lowcore * const lc;
>  
>  /* Keep track of fresh memory */
>  static uint8_t *fresh;
> @@ -87,7 +86,7 @@ static int page_ok(const uint8_t *p)
>   */
>  static inline bool check_oai(void)
>  {
> -	return *(uint8_t *)(lc->pgm_old_psw.addr - 1) == lc->op_acc_id;
> +	return *(uint8_t *)(lowcore.pgm_old_psw.addr - 1) == lowcore.op_acc_id;
>  }
>  
>  static void test_exceptions(void)
> @@ -216,7 +215,7 @@ static void test_mmu_prot(void)
>  
>  	report_prefix_push("source invalid");
>  	protect_page(source, PAGE_ENTRY_I);
> -	lc->op_acc_id = 0;
> +	lowcore.op_acc_id = 0;
>  	expect_pgm_int();
>  	mvpg(0, fresh, source);
>  	report(clear_pgm_int() == PGM_INT_CODE_PAGE_TRANSLATION, "exception");
> @@ -227,7 +226,7 @@ static void test_mmu_prot(void)
>  
>  	report_prefix_push("destination invalid");
>  	protect_page(fresh, PAGE_ENTRY_I);
> -	lc->op_acc_id = 0;
> +	lowcore.op_acc_id = 0;
>  	expect_pgm_int();
>  	mvpg(0, fresh, source);
>  	report(clear_pgm_int() == PGM_INT_CODE_PAGE_TRANSLATION, "exception");
> diff --git a/s390x/sclp.c b/s390x/sclp.c
> index 73d722fb..1abb9029 100644
> --- a/s390x/sclp.c
> +++ b/s390x/sclp.c
> @@ -31,7 +31,6 @@ static union {
>  	WriteEventData data;
>  } sccb_template;
>  static uint32_t valid_code;						/* valid command code for READ SCP INFO */
> -static struct lowcore *lc;
>  
>  /**
>   * Perform one service call, handling exceptions and interrupts.
> @@ -43,7 +42,7 @@ static int sclp_service_call_test(unsigned int command, void *sccb)
>  	sclp_mark_busy();
>  	sclp_setup_int();
>  	cc = servc(command, __pa(sccb));
> -	if (lc->pgm_int_code) {
> +	if (lowcore.pgm_int_code) {
>  		sclp_handle_ext();
>  		return 0;
>  	}
> diff --git a/s390x/skrf.c b/s390x/skrf.c
> index b9a2e902..1a811894 100644
> --- a/s390x/skrf.c
> +++ b/s390x/skrf.c
> @@ -123,17 +123,15 @@ static void set_flag(int val)
>  
>  static void ecall_cleanup(void)
>  {
> -	struct lowcore *lc = (void *)0x0;
> -
> -	lc->ext_new_psw.mask = PSW_MASK_64;
> -	lc->sw_int_crs[0] = BIT_ULL(CTL0_AFP);
> +	lowcore.ext_new_psw.mask = PSW_MASK_64;
> +	lowcore.sw_int_crs[0] = BIT_ULL(CTL0_AFP);
>  
>  	/*
>  	 * PGM old contains the ext new PSW, we need to clean it up,
>  	 * so we don't get a special operation exception on the lpswe
>  	 * of pgm old.
>  	 */
> -	lc->pgm_old_psw.mask = PSW_MASK_64;
> +	lowcore.pgm_old_psw.mask = PSW_MASK_64;
>  
>  	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>  	set_flag(1);
> @@ -142,13 +140,12 @@ static void ecall_cleanup(void)
>  /* Set a key into the external new psw mask and open external call masks */
>  static void ecall_setup(void)
>  {
> -	struct lowcore *lc = (void *)0x0;
>  	uint64_t mask;
>  
>  	register_pgm_cleanup_func(ecall_cleanup);
>  	expect_pgm_int();
>  	/* Put a skey into the ext new psw */
> -	lc->ext_new_psw.mask = 0x00F0000000000000UL | PSW_MASK_64;
> +	lowcore.ext_new_psw.mask = 0x00F0000000000000UL | PSW_MASK_64;
>  	/* Open up ext masks */
>  	ctl_set_bit(0, CTL0_EXTERNAL_CALL);
>  	mask = extract_psw_mask();
> diff --git a/s390x/smp.c b/s390x/smp.c
> index de3aba71..6d474d0d 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -155,28 +155,27 @@ static void test_stop(void)
>  static void test_stop_store_status(void)
>  {
>  	struct cpu *cpu = smp_cpu_from_idx(1);
> -	struct lowcore *lc = (void *)0x0;
>  
>  	report_prefix_push("stop store status");
>  	report_prefix_push("running");
>  	smp_cpu_restart(1);
> -	lc->prefix_sa = 0;
> -	lc->grs_sa[15] = 0;
> +	lowcore.prefix_sa = 0;
> +	lowcore.grs_sa[15] = 0;
>  	smp_cpu_stop_store_status(1);
>  	mb();
>  	report(smp_cpu_stopped(1), "cpu stopped");
> -	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
> -	report(lc->grs_sa[15], "stack");
> +	report(lowcore.prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
> +	report(lowcore.grs_sa[15], "stack");
>  	report_prefix_pop();
>  
>  	report_prefix_push("stopped");
> -	lc->prefix_sa = 0;
> -	lc->grs_sa[15] = 0;
> +	lowcore.prefix_sa = 0;
> +	lowcore.grs_sa[15] = 0;
>  	smp_cpu_stop_store_status(1);
>  	mb();
>  	report(smp_cpu_stopped(1), "cpu stopped");
> -	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
> -	report(lc->grs_sa[15], "stack");
> +	report(lowcore.prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
> +	report(lowcore.grs_sa[15], "stack");
>  	report_prefix_pop();
>  
>  	report_prefix_pop();
> @@ -290,7 +289,6 @@ static void test_set_prefix(void)
>  static void ecall(void)
>  {
>  	unsigned long mask;
> -	struct lowcore *lc = (void *)0x0;
>  
>  	expect_ext_int();
>  	ctl_set_bit(0, CTL0_EXTERNAL_CALL);
> @@ -298,7 +296,7 @@ static void ecall(void)
>  	mask |= PSW_MASK_EXT;
>  	load_psw_mask(mask);
>  	set_flag(1);
> -	while (lc->ext_int_code != 0x1202) { mb(); }
> +	while (lowcore.ext_int_code != 0x1202) { mb(); }
>  	report_pass("received");
>  	set_flag(1);
>  }
> @@ -324,7 +322,6 @@ static void test_ecall(void)
>  static void emcall(void)
>  {
>  	unsigned long mask;
> -	struct lowcore *lc = (void *)0x0;
>  
>  	expect_ext_int();
>  	ctl_set_bit(0, CTL0_EMERGENCY_SIGNAL);
> @@ -332,7 +329,7 @@ static void emcall(void)
>  	mask |= PSW_MASK_EXT;
>  	load_psw_mask(mask);
>  	set_flag(1);
> -	while (lc->ext_int_code != 0x1201) { mb(); }
> +	while (lowcore.ext_int_code != 0x1201) { mb(); }
>  	report_pass("received");
>  	set_flag(1);
>  }
> diff --git a/s390x/snippets/c/spec_ex.c b/s390x/snippets/c/spec_ex.c
> index 71655ddb..40c170e6 100644
> --- a/s390x/snippets/c/spec_ex.c
> +++ b/s390x/snippets/c/spec_ex.c
> @@ -10,12 +10,11 @@
>  
>  __attribute__((section(".text"))) int main(void)
>  {
> -	struct lowcore *lowcore = (struct lowcore *) 0;
>  	uint64_t bad_psw = 0;
>  
>  	/* PSW bit 12 has no name or meaning and must be 0 */
> -	lowcore->pgm_new_psw.mask = BIT(63 - 12);
> -	lowcore->pgm_new_psw.addr = 0xdeadbeee;
> +	lowcore.pgm_new_psw.mask = BIT(63 - 12);
> +	lowcore.pgm_new_psw.addr = 0xdeadbeee;
>  	asm volatile ("lpsw %0" :: "Q"(bad_psw));
>  	return 0;
>  }

