Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8199E532C5C
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 16:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbiEXOkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 10:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235060AbiEXOko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 10:40:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC098FF90;
        Tue, 24 May 2022 07:40:43 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24ODnmK0004805;
        Tue, 24 May 2022 14:40:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Rqk5AZRuQUuDmqnFemaWHIYSCCaRwUJvoWUer3sBm7k=;
 b=IKeYAsCr5smOZjfcnZ/RZnuEgPjxok8ukGujR+XOnC+nhVG0SHHs44+v/NO+gGTJP02C
 mYqniAW/QTcBPyyjArd01lhPDS3jU0Vnxvlb/XKi9rpCc1PHvOrRHkZed7MsOuAelJqP
 a8EUKABpFEt314AtywROeN55zcZI01hmMrndbz0Vt54msjWEJUWKiLk0AAktSZ9zCGX9
 WKP0uxwqW3OMrLGQPgAdwPHfoGS2mOBe2TggrZCtHcDC3g9sE8L6cqeMDdxPEVaIyDuL
 fiEPCzEl9IwGFpdAWwSjQZI9YaPyeBV8ES+BmovIs9vna9Sv6IN13ogBuVhcM5C1bqXx ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8ypp2ueh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 14:40:42 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24ODtQTC002962;
        Tue, 24 May 2022 14:40:42 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8ypp2udq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 14:40:42 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OEYptE016945;
        Tue, 24 May 2022 14:40:40 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3g6qq9bsep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 14:40:39 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OEeaTh50528550
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 14:40:36 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78F9111C04C;
        Tue, 24 May 2022 14:40:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 158F811C058;
        Tue, 24 May 2022 14:40:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.98])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 14:40:36 +0000 (GMT)
Date:   Tue, 24 May 2022 16:40:30 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: Rework TEID decoding and
 usage
Message-ID: <20220524164030.6adb45bf@p-imbrenda>
In-Reply-To: <20220520190850.3445768-4-scgl@linux.ibm.com>
References: <20220520190850.3445768-1-scgl@linux.ibm.com>
        <20220520190850.3445768-4-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vKzIbRguzEjOrKAnR6_G_Y8AQ7u2gbWb
X-Proofpoint-GUID: iwXSqBWbS-4IhrBHnofCO5BfB-ZcwQ_e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_07,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 mlxscore=0 clxscore=1015 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205240074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 May 2022 21:08:50 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> The translation-exception identification (TEID) contains information to
> identify the cause of certain program exceptions, including translation
> exceptions occurring during dynamic address translation, as well as
> protection exceptions.
> The meaning of fields in the TEID is complex, depending on the exception
> occurring and various potentially installed facilities.
> 
> Rework the type describing the TEID, in order to ease decoding.
> Change the existing code interpreting the TEID and extend it to take the
> installed suppression-on-protection facility into account.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  lib/s390x/asm/interrupt.h | 66 ++++++++++++++++++++++++++--------
>  lib/s390x/fault.h         | 30 ++++------------
>  lib/s390x/fault.c         | 74 +++++++++++++++++++++++++++------------
>  lib/s390x/interrupt.c     |  2 +-
>  s390x/edat.c              | 20 +++++++----
>  5 files changed, 124 insertions(+), 68 deletions(-)
> 
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index d9ab0bd7..8d5bfbf9 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -20,23 +20,61 @@
>  
>  union teid {
>  	unsigned long val;
> -	struct {
> -		unsigned long addr:52;
> -		unsigned long fetch:1;
> -		unsigned long store:1;
> -		unsigned long reserved:6;
> -		unsigned long acc_list_prot:1;
> -		/*
> -		 * depending on the exception and the installed facilities,
> -		 * the m field can indicate several different things,
> -		 * including whether the exception was triggered by a MVPG
> -		 * instruction, or whether the addr field is meaningful
> -		 */
> -		unsigned long m:1;
> -		unsigned long asce_id:2;
> +	union {
> +		/* common fields DAT exc & protection exc */
> +		struct {
> +			uint64_t addr			: 52 -  0;
> +			uint64_t acc_exc_f_s		: 54 - 52;
> +			uint64_t side_effect_acc	: 55 - 54;
> +			uint64_t /* reserved */		: 55 - 54;

shouldn't this ^ be 62 - 55 ?

> +			uint64_t asce_id		: 64 - 62;
> +		};
> +		/* DAT exc */
> +		struct {
> +			uint64_t /* pad */		: 61 -  0;
> +			uint64_t dat_move_page		: 62 - 61;
> +		};
> +		/* suppression on protection */
> +		struct {
> +			uint64_t /* pad */		: 60 -  0;
> +			uint64_t sop_acc_list		: 61 - 60;
> +			uint64_t sop_teid_predictable	: 62 - 61;
> +		};
> +		/* enhanced suppression on protection 1 */
> +		struct {
> +			uint64_t /* pad */		: 61 -  0;

60 - 0

> +			uint64_t esop1_acc_list_or_dat	: 62 - 61;

61 - 60

and then:

uint64_t esop1_teid_predictable : 62 - 61;

> +		};
> +		/* enhanced suppression on protection 2 */
> +		struct {
> +			uint64_t /* pad */		: 56 -  0;
> +			uint64_t esop2_prot_code_0	: 57 - 56;
> +			uint64_t /* pad */		: 60 - 57;
> +			uint64_t esop2_prot_code_1	: 61 - 60;
> +			uint64_t esop2_prot_code_2	: 62 - 61;
> +		};
>  	};
>  };
>  
> +enum prot_code {
> +	PROT_KEY_LAP,
> +	PROT_DAT,
> +	PROT_KEY,
> +	PROT_ACC_LIST,
> +	PROT_LAP,
> +	PROT_IEP,

I would still also define two PROT_INVALID or PROT_RESERVED

just to avoid surprises

> +};
> +
> +static inline enum prot_code teid_esop2_prot_code(union teid teid)
> +{
> +	int code = 0;
> +
> +	code = code << 1 | teid.esop2_prot_code_0;
> +	code = code << 1 | teid.esop2_prot_code_1;
> +	code = code << 1 | teid.esop2_prot_code_2;
> +	return (enum prot_code)code;

return (enum prot_code)(teid.esop2_prot_code_0 << 2 |
			teid.esop2_prot_code_1 << 1 |
			teid.esop2_prot_code_2);

> +}
> +
>  void register_pgm_cleanup_func(void (*f)(void));
>  void handle_pgm_int(struct stack_frame_int *stack);
>  void handle_ext_int(struct stack_frame_int *stack);
> diff --git a/lib/s390x/fault.h b/lib/s390x/fault.h
> index 726da2f0..867997f2 100644
> --- a/lib/s390x/fault.h
> +++ b/lib/s390x/fault.h
> @@ -11,32 +11,16 @@
>  #define _S390X_FAULT_H_
>  
>  #include <bitops.h>
> +#include <asm/facility.h>
> +#include <asm/interrupt.h>
>  
>  /* Instruction execution prevention, i.e. no-execute, 101 */
> -static inline bool prot_is_iep(uint64_t teid)
> +static inline bool prot_is_iep(union teid teid)
>  {
> -	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && test_bit_inv(61, &teid))
> -		return true;
> -
> -	return false;
> -}
> -
> -/* Standard DAT exception, 001 */
> -static inline bool prot_is_datp(uint64_t teid)
> -{
> -	if (!test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && test_bit_inv(61, &teid))
> -		return true;
> -
> -	return false;
> -}
> -
> -/* Low-address protection exception, 100 */
> -static inline bool prot_is_lap(uint64_t teid)
> -{
> -	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && !test_bit_inv(61, &teid))
> -		return true;
> -
> -	return false;
> +	if (!test_facility(130))
> +		return false;
> +	/* IEP installed -> ESOP2 installed */
> +	return teid_esop2_prot_code(teid) == PROT_IEP;
>  }
>  
>  void print_decode_teid(uint64_t teid);
> diff --git a/lib/s390x/fault.c b/lib/s390x/fault.c
> index efa62fcb..02b3c098 100644
> --- a/lib/s390x/fault.c
> +++ b/lib/s390x/fault.c
> @@ -13,35 +13,63 @@
>  #include <asm/page.h>
>  #include <fault.h>
>  
> -/* Decodes the protection exceptions we'll most likely see */
> -static void print_decode_pgm_prot(uint64_t teid)
> -{
> -	if (prot_is_lap(teid)) {
> -		printf("Type: LAP\n");
> -		return;
> -	}
> -
> -	if (prot_is_iep(teid)) {
> -		printf("Type: IEP\n");
> -		return;
> -	}
>  
> -	if (prot_is_datp(teid)) {
> -		printf("Type: DAT\n");
> -		return;
> +static void print_decode_pgm_prot(union teid teid, bool dat)
> +{
> +	switch (get_supp_on_prot_facility()) {
> +	case SOP_NONE:
> +		printf("Type: ?\n");
> +		break;
> +	case SOP_BASIC:
> +		if (teid.sop_teid_predictable && dat && teid.sop_acc_list)
> +			printf("Type: ACC\n");
> +		else
> +			printf("Type: ?\n");
> +		break;
> +	case SOP_ENHANCED_1:
> +		if (teid.esop1_acc_list_or_dat) {
> +			if (teid.sop_acc_list)
> +				printf("Type: ACC\n");
> +			else
> +				printf("Type: DAT\n");
> +		} else {
> +			printf("Type: KEY or LAP\n");
> +		}
> +		break;
> +	case SOP_ENHANCED_2:
> +		switch (teid_esop2_prot_code(teid)) {

I wonder if it weren't easier to do

static const char * const prot_strings[6] = {"KEY or LAP", "DAT", ...};
printf("Type: %s\n", prot_strings[teid_esop2_prot_code(teid)]);

> +		case PROT_KEY_LAP:
> +			printf("Type: KEY or LAP\n");
> +			break;
> +		case PROT_DAT:
> +			printf("Type: DAT\n");
> +			break;
> +		case PROT_KEY:
> +			printf("Type: KEY\n");
> +			break;
> +		case PROT_ACC_LIST:
> +			printf("Type: ACC\n");
> +			break;
> +		case PROT_LAP:
> +			printf("Type: LAP\n");
> +			break;
> +		case PROT_IEP:
> +			printf("Type: IEP\n");
> +			break;
> +		}
>  	}
>  }
>  
> -void print_decode_teid(uint64_t teid)
> +void print_decode_teid(uint64_t raw_teid)
>  {
> -	int asce_id = teid & 3;
> +	union teid teid = { .val = raw_teid };
>  	bool dat = lowcore.pgm_old_psw.mask & PSW_MASK_DAT;
>  
>  	printf("Memory exception information:\n");
>  	printf("DAT: %s\n", dat ? "on" : "off");
>  
>  	printf("AS: ");
> -	switch (asce_id) {
> +	switch (teid.asce_id) {
>  	case AS_PRIM:
>  		printf("Primary\n");
>  		break;
> @@ -57,7 +85,7 @@ void print_decode_teid(uint64_t teid)
>  	}
>  
>  	if (lowcore.pgm_int_code == PGM_INT_CODE_PROTECTION)
> -		print_decode_pgm_prot(teid);
> +		print_decode_pgm_prot(teid, dat);
>  
>  	/*
>  	 * If teid bit 61 is off for these two exception the reported
> @@ -65,10 +93,10 @@ void print_decode_teid(uint64_t teid)
>  	 */
>  	if ((lowcore.pgm_int_code == PGM_INT_CODE_SECURE_STOR_ACCESS ||
>  	     lowcore.pgm_int_code == PGM_INT_CODE_SECURE_STOR_VIOLATION) &&
> -	    !test_bit_inv(61, &teid)) {
> -		printf("Address: %lx, unpredictable\n ", teid & PAGE_MASK);
> +	    !teid.sop_teid_predictable) {
> +		printf("Address: %lx, unpredictable\n ", raw_teid & PAGE_MASK);
>  		return;
>  	}
> -	printf("TEID: %lx\n", teid);
> -	printf("Address: %lx\n\n", teid & PAGE_MASK);
> +	printf("TEID: %lx\n", raw_teid);
> +	printf("Address: %lx\n\n", raw_teid & PAGE_MASK);

teid.addr << PAGE_SHIFT ?

>  }
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 6da20c44..ac3d1ecd 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -77,7 +77,7 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
>  		break;
>  	case PGM_INT_CODE_PROTECTION:
>  		/* Handling for iep.c test case. */
> -		if (prot_is_iep(lowcore.trans_exc_id))
> +		if (prot_is_iep((union teid) { .val = lowcore.trans_exc_id }))
>  			/*
>  			 * We branched to the instruction that caused
>  			 * the exception so we can use the return
> diff --git a/s390x/edat.c b/s390x/edat.c
> index c6c25042..af442039 100644
> --- a/s390x/edat.c
> +++ b/s390x/edat.c
> @@ -37,14 +37,20 @@ static bool check_pgm_prot(void *ptr)
>  		return false;
>  
>  	teid.val = lowcore.trans_exc_id;
> -
> -	/*
> -	 * depending on the presence of the ESOP feature, the rest of the
> -	 * field might or might not be meaningful when the m field is 0.
> -	 */
> -	if (!teid.m)
> +	switch (get_supp_on_prot_facility()) {
> +	case SOP_NONE:
>  		return true;
> -	return (!teid.acc_list_prot && !teid.asce_id &&
> +	case SOP_BASIC:
> +		if (!teid.sop_teid_predictable)
> +			return true;

add:

if (teid.sop_acc_list)
	return false;

> +	case SOP_ENHANCED_1:

you need to handle the unpredictable case here too

> +		if (!teid.esop1_acc_list_or_dat)
> +			return false;

so you return false the it is DAT... but if it is not DAT, it's
access-control-list... 

you might want to replace this whole case with:

return !teid.esop1_teid_predictable;

(although I don't understand why you want to exclude DAT here)

> +	case SOP_ENHANCED_2:
> +		if (teid_esop2_prot_code(teid) != 1)

why not using the PROT_DAT enum?
also, handle the PROT_ACC_LIST too

also, add:

if (PROT_KEY_LAP)
	return true;

because in that case you don't have the address part.



but at this point I wonder if you can't just rewrite this function with
an additional enum prot_code parameter, to specify the exact type of
exception you're expecting

> +			return false;
> +	}
> +	return (!teid.sop_acc_list && !teid.asce_id &&
>  		(teid.addr == ((unsigned long)ptr >> PAGE_SHIFT)));
>  }
>  

