Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E144532D1F
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 17:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238845AbiEXPQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 11:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238821AbiEXPQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 11:16:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8251137;
        Tue, 24 May 2022 08:16:08 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OE4JRM028666;
        Tue, 24 May 2022 15:16:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=BAznk0CMIHfsfbOV26xcLraAe6Z/8x2GE9mW17k3ZUk=;
 b=NLOKvvnbhK+L0bXKb8ONkSG4hvuOriqa3a9fP+Br2FTegag43Q/gsIQLlH7Mk1aXRmu8
 sEDPA/k6Nm3WRNgJiKNirCHtB1VeoZM+tUZkEKzAyuUgzt86k3m/TepnF4KOcCHvb3H2
 J+12CQrnQGYy96JOjZRDiIhTr2AS6G6CPmfcXonyqAxlnVOc2oMf9ZgwScH6PctAJ/hH
 lr6hkqN7hXKMi1RdgFXG3xSkbhFvFuik6H5RdDyN20g1NKSX0zcXY4PNomlPGHKvoje/
 JXKjuPeXx3MCoTghAIQWOQOWg5nHJbBKyIaQNyDAvgfVf2cHeTsMyZU2Bw0HsZ1STfAh OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g904jakd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 15:16:06 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OF2fa0029656;
        Tue, 24 May 2022 15:16:06 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g904jakcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 15:16:06 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OFD93X009033;
        Tue, 24 May 2022 15:16:04 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3g6qq8w3gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 15:16:04 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OFG1lx7602516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 15:16:01 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A21CA4054;
        Tue, 24 May 2022 15:16:01 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBB38A405B;
        Tue, 24 May 2022 15:16:00 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.98])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 15:16:00 +0000 (GMT)
Date:   Tue, 24 May 2022 17:09:27 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 1/3] s390x: Test TEID values in
 storage key test
Message-ID: <20220524170927.46fbd24a@p-imbrenda>
In-Reply-To: <20220523132406.1820550-2-scgl@linux.ibm.com>
References: <20220523132406.1820550-1-scgl@linux.ibm.com>
        <20220523132406.1820550-2-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: K7IcRZ3SKSZfdKng46cXL35a-Epejb6z
X-Proofpoint-ORIG-GUID: H0d2nSVWaNCfW51UeTc35cBFMPBBQfBl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_07,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 adultscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205240077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 May 2022 15:24:04 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> On a protection exception, test that the Translation-Exception
> Identification (TEID) values are correct given the circumstances of the
> particular test.
> The meaning of the TEID values is dependent on the installed
> suppression-on-protection facility.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  s390x/skey.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 69 insertions(+), 6 deletions(-)
> 
> diff --git a/s390x/skey.c b/s390x/skey.c
> index 42bf598c..5e234cde 100644
> --- a/s390x/skey.c
> +++ b/s390x/skey.c
> @@ -8,6 +8,7 @@
>   *  Janosch Frank <frankja@linux.vnet.ibm.com>
>   */
>  #include <libcflat.h>
> +#include <asm/arch_def.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/interrupt.h>
>  #include <vmalloc.h>
> @@ -158,6 +159,68 @@ static void test_test_protection(void)
>  	report_prefix_pop();
>  }
>  
> +enum access {
> +	ACC_STORE = 1,
> +	ACC_FETCH = 2,
> +	ACC_UPDATE = 3,
> +};
> +
> +enum protection {
> +	PROT_STORE = 1,
> +	PROT_FETCH_STORE = 3,
> +};
> +
> +static void check_key_prot_exc(enum access access, enum protection prot)
> +{
> +	union teid teid;
> +	int access_code;
> +
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	report_prefix_push("TEID");
> +	teid.val = lowcore.trans_exc_id;
> +	switch (get_supp_on_prot_facility()) {
> +	case SOP_NONE:
> +	case SOP_BASIC:
> +		break;

for basic you should check for sop_teid_predictable and sop_acc_list

> +	case SOP_ENHANCED_1:
> +		report(!teid.esop1_acc_list_or_dat, "valid protection code");

actually, both values of esop1_acc_list_or_dat are wrong, since we're
expecting neither an access list nor a dat exception.

you need to check for esop1_teid_predictable instead (which you need to
add, see comment in that patchseries)

> +		break;
> +	case SOP_ENHANCED_2:
> +		switch (teid_esop2_prot_code(teid)) {
> +		case PROT_KEY:
> +			access_code = teid.acc_exc_f_s;

is the f/s feature guaranteed to be present when we have esop2?

can the f/s feature be present with esop1 or basic sop?

> +
> +			switch (access_code) {
> +			case 0:
> +				report_pass("valid access code");
> +				break;
> +			case 1:
> +			case 2:
> +				report((access & access_code) && (prot & access_code),
> +				       "valid access code");
> +				break;
> +			case 3:
> +				/*
> +				 * This is incorrect in that reserved values
> +				 * should be ignored, but kvm should not return
> +				 * a reserved value and having a test for that
> +				 * is more valuable.
> +				 */
> +				report_fail("valid access code");
> +				break;
> +			}
> +			/* fallthrough */
> +		case PROT_KEY_LAP:
> +			report_pass("valid protection code");
> +			break;
> +		default:
> +			report_fail("valid protection code");
> +		}
> +		break;
> +	}
> +	report_prefix_pop();
> +}
> +
>  /*
>   * Perform STORE CPU ADDRESS (STAP) instruction while temporarily executing
>   * with access key 1.
> @@ -199,7 +262,7 @@ static void test_store_cpu_address(void)
>  	expect_pgm_int();
>  	*out = 0xbeef;
>  	store_cpu_address_key_1(out);
> -	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	check_key_prot_exc(ACC_STORE, PROT_STORE);
>  	report(*out == 0xbeef, "no store occurred");
>  	report_prefix_pop();
>  
> @@ -210,7 +273,7 @@ static void test_store_cpu_address(void)
>  	expect_pgm_int();
>  	*out = 0xbeef;
>  	store_cpu_address_key_1(out);
> -	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	check_key_prot_exc(ACC_STORE, PROT_STORE);
>  	report(*out == 0xbeef, "no store occurred");
>  	report_prefix_pop();
>  
> @@ -228,7 +291,7 @@ static void test_store_cpu_address(void)
>  	expect_pgm_int();
>  	*out = 0xbeef;
>  	store_cpu_address_key_1(out);
> -	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	check_key_prot_exc(ACC_STORE, PROT_STORE);
>  	report(*out == 0xbeef, "no store occurred");
>  	report_prefix_pop();
>  
> @@ -314,7 +377,7 @@ static void test_set_prefix(void)
>  	set_storage_key(pagebuf, 0x28, 0);
>  	expect_pgm_int();
>  	set_prefix_key_1(prefix_ptr);
> -	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
>  	report(get_prefix() == old_prefix, "did not set prefix");
>  	report_prefix_pop();
>  
> @@ -327,7 +390,7 @@ static void test_set_prefix(void)
>  	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
>  	set_prefix_key_1((uint32_t *)0);
>  	install_page(root, 0, 0);
> -	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
>  	report(get_prefix() == old_prefix, "did not set prefix");
>  	report_prefix_pop();
>  
> @@ -351,7 +414,7 @@ static void test_set_prefix(void)
>  	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
>  	set_prefix_key_1((uint32_t *)&mem_all[2048]);
>  	install_page(root, 0, 0);
> -	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
>  	report(get_prefix() == old_prefix, "did not set prefix");
>  	report_prefix_pop();
>  

