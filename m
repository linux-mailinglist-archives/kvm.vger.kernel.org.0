Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4A0543227
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 16:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241154AbiFHOEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 10:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241119AbiFHOEI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 10:04:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7A3118027;
        Wed,  8 Jun 2022 07:04:06 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258DrjrZ003596;
        Wed, 8 Jun 2022 14:04:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=I98s4Zu+VkNg5w81ugmt9dGFgVjoPCoKXQKPC20pbPU=;
 b=YMBDLbat6xRbPx7usD5hypCd8c9vOhbMzAHfgm6FYWvtrqmXGIwDvXEn8CmRRG1DcRS+
 SvJiVSrvtsuHSBV+cRsjnomZuOW1SN/b2Ma4N+BAB/X8bMMXuyHkJijm4Z0B8fDS8weX
 MXV/dwhGFy021Cf33NK2MpSkbxoxvC1RrBeFAoIaSk6j1rEH2c1UC6X22x0eF5Ae6RzV
 /tLcJd9DVmoC1SRnd118ZrntiLbJ+RJ620FsbLVGdq4HiATD5PnQZ3UT4AqIkZdn8sAa
 2Zoiu6N41f+ixf6m/YQ7+X6blICPNFDC7ZYOBUuFnCHWIXE8bHc55Y5TCIMWQyv+OZhv DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjw2986xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 14:04:05 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258DvXKH025707;
        Wed, 8 Jun 2022 14:04:05 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjw2986wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 14:04:05 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258E2vJ3023120;
        Wed, 8 Jun 2022 14:04:03 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3gfy19dcb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 14:04:02 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258E3x6d17498520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 14:03:59 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEE0511C058;
        Wed,  8 Jun 2022 14:03:59 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79E7911C052;
        Wed,  8 Jun 2022 14:03:59 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jun 2022 14:03:59 +0000 (GMT)
Date:   Wed, 8 Jun 2022 16:03:57 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Rework TEID decoding and
 usage
Message-ID: <20220608160357.4fa94ecc@p-imbrenda>
In-Reply-To: <20220608133303.1532166-4-scgl@linux.ibm.com>
References: <20220608133303.1532166-1-scgl@linux.ibm.com>
        <20220608133303.1532166-4-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QRDIFGf50WNAwWnRimxwSSFmrkUR6dse
X-Proofpoint-ORIG-GUID: TBdb-U0BO86fOBtEQV9peCWvdYzU5Xdk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_04,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 bulkscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206080061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  8 Jun 2022 15:33:03 +0200
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
>  lib/s390x/asm/interrupt.h | 61 +++++++++++++++++++++++++++---------
>  lib/s390x/fault.h         | 30 +++++-------------
>  lib/s390x/fault.c         | 65 ++++++++++++++++++++++++++-------------
>  lib/s390x/interrupt.c     |  2 +-
>  s390x/edat.c              | 26 ++++++++++------
>  5 files changed, 115 insertions(+), 69 deletions(-)
> 
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index d9ab0bd7..3ca6bf76 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -20,23 +20,56 @@
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
> +			uint64_t /* reserved */		: 62 - 55;
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

add:
	PROT_CODE_SIZE,	/* Must always be the last one */

[...]

> +	case SOP_ENHANCED_2: {
> +		static const char * const prot_str[] = {

static const char * const prot_str[PROT_CODE_SIZE] = {

so you have the guarantee that this has the right size, and you will
get a compile error if a new value is added to the enum but not here

and at this point I think it might make more sense to move this right
after the enum itself

> +			"KEY or LAP",
> +			"DAT",
> +			"KEY",
> +			"ACC",
> +			"LAP",
> +			"IEP",
> +		};
> +		int prot_code = teid_esop2_prot_code(teid);

enum prot_code prot_code = teid_esop2_prot_code(teid);

>  
> -	if (prot_is_datp(teid)) {
> -		printf("Type: DAT\n");
> -		return;
> +		assert(0 <= prot_code && prot_code < ARRAY_SIZE(prot_str));

then you can remove this assert ^

> +		printf("Type: %s\n", prot_str[prot_code]);
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
> @@ -57,7 +78,7 @@ void print_decode_teid(uint64_t teid)
>  	}
>  
>  	if (lowcore.pgm_int_code == PGM_INT_CODE_PROTECTION)
> -		print_decode_pgm_prot(teid);
> +		print_decode_pgm_prot(teid, dat);
>  
>  	/*
>  	 * If teid bit 61 is off for these two exception the reported
> @@ -65,10 +86,10 @@ void print_decode_teid(uint64_t teid)
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
> index c6c25042..89ff4f51 100644
> --- a/s390x/edat.c
> +++ b/s390x/edat.c
> @@ -26,8 +26,8 @@ static void *root, *mem, *m;
>  volatile unsigned int *p;
>  
>  /*
> - * Check if a non-access-list protection exception happened for the given
> - * address, in the primary address space.
> + * Check if the exception is consistent with DAT protection and has the correct
> + * address and primary address space.
>   */
>  static bool check_pgm_prot(void *ptr)
>  {
> @@ -37,14 +37,22 @@ static bool check_pgm_prot(void *ptr)
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
> +		break;
> +	case SOP_ENHANCED_1:
> +		if (!teid.sop_teid_predictable) /* implies key or low addr */
> +			return false;
> +		break;
> +	case SOP_ENHANCED_2:
> +		if (teid_esop2_prot_code(teid) != PROT_DAT)
> +			return false;
> +	}
> +	return (!teid.sop_acc_list && !teid.asce_id &&
>  		(teid.addr == ((unsigned long)ptr >> PAGE_SHIFT)));
>  }
>  

