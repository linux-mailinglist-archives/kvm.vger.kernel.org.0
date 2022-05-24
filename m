Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0B253241A
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 09:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbiEXHcL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 03:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbiEXHcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 03:32:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F048427D8;
        Tue, 24 May 2022 00:32:08 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24O7Qkj1026220;
        Tue, 24 May 2022 07:32:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=dbcco9b4afmBIadJtS0axk0Xbd+5kbnjUW/4xNsftKU=;
 b=Q6gT7QqjBKqUmz0fkaOP2sYAvtMxomCJsAe1Tr1GKYu17G/dazCI6w7lDXxscbu4ldDG
 X4P1slp7BQX2drSW0vSN2tEWJuxdbjLM7DO4kDN4rqeKru35pH3up8GGbFFf4PLmhLm9
 v3qQTV72T1kIepdSFCW1tQ8OdLbk5p3O2pTPZAolliaJ1WU9P3OjJCUUaFtrbau86IYX
 1FLnmMT+g26bTYM+XfpXcFc0wrLkNE0vggwKEfvbv7k9Kuze8LyJDavtDtxG8D1NczGs
 ayUjg2PGBXNTkTQSEGytaRisSLw0TE/FSygu4yDTRwkbetGCUxCaS1LZnyBK+62MKLJp Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8tyvr2ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 07:32:07 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24O7UGng035706;
        Tue, 24 May 2022 07:32:07 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8tyvr2w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 07:32:07 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24O7VuMR011694;
        Tue, 24 May 2022 07:32:05 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3g6qq9ba6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 07:32:04 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24O7W1RK51380546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 07:32:01 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3AFA42042;
        Tue, 24 May 2022 07:32:01 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37AE84203F;
        Tue, 24 May 2022 07:32:01 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.98])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 07:32:01 +0000 (GMT)
Date:   Tue, 24 May 2022 09:31:58 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: Fix gcc 12 warning about
 array bounds
Message-ID: <20220524093158.6404a633@p-imbrenda>
In-Reply-To: <20220520140546.311193-3-scgl@linux.ibm.com>
References: <20220520140546.311193-1-scgl@linux.ibm.com>
        <20220520140546.311193-3-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QT7VIH0tz3N8t-tw6U2kxi4Wz7iKA9Nw
X-Proofpoint-ORIG-GUID: HQL8dFidxf-JOaanB2wILj8UQn91_Unj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_05,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 impostorscore=0 phishscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205240041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 May 2022 16:05:46 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> gcc 12 warns about pointer constant <4k dereference.
> Silence the warning by using the extern lowcore symbol to derive the
> pointers. This way gcc cannot conclude that the pointer is <4k.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  lib/s390x/asm/mem.h | 4 ++++
>  s390x/emulator.c    | 5 +++--
>  s390x/skey.c        | 2 +-
>  3 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
> index 845c00cc..e7901fe0 100644
> --- a/lib/s390x/asm/mem.h
> +++ b/lib/s390x/asm/mem.h
> @@ -7,6 +7,10 @@
>   */
>  #ifndef _ASMS390X_MEM_H_
>  #define _ASMS390X_MEM_H_
> +#include <asm/arch_def.h>
> +
> +/* pointer to 0 used to avoid compiler warnings */
> +uint8_t *mem_all = (uint8_t *)&lowcore;

this is defined in a .h, so maybe it's better to declare it static?


although maybe you can simply declare a macro like this:

#define MEM(x) ((void *)((uint8_t *)&lowcore + (x)))

and then just use MEM(x)...

(please find a less generic name for MEM, though)

>  
>  #define SKEY_ACC	0xf0
>  #define SKEY_FP		0x08
> diff --git a/s390x/emulator.c b/s390x/emulator.c
> index c9182ea4..afc3c213 100644
> --- a/s390x/emulator.c
> +++ b/s390x/emulator.c
> @@ -12,6 +12,7 @@
>  #include <asm/cpacf.h>
>  #include <asm/interrupt.h>
>  #include <asm/float.h>
> +#include <asm/mem.h>
>  #include <linux/compiler.h>
>  
>  static inline void __test_spm_ipm(uint8_t cc, uint8_t key)
> @@ -138,7 +139,7 @@ static __always_inline void __test_cpacf_invalid_parm(unsigned int opcode)
>  {
>  	report_prefix_push("invalid parm address");
>  	expect_pgm_int();
> -	__cpacf_query(opcode, (void *) -1);
> +	__cpacf_query(opcode, (cpacf_mask_t *)&mem_all[-1]);

...for example here MEM(-1)

>  	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
>  	report_prefix_pop();
>  }
> @@ -148,7 +149,7 @@ static __always_inline void __test_cpacf_protected_parm(unsigned int opcode)
>  	report_prefix_push("protected parm address");
>  	expect_pgm_int();
>  	low_prot_enable();
> -	__cpacf_query(opcode, (void *) 8);
> +	__cpacf_query(opcode, (cpacf_mask_t *)&mem_all[8]);

... MEM(8)

>  	low_prot_disable();
>  	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>  	report_prefix_pop();
> diff --git a/s390x/skey.c b/s390x/skey.c
> index 32bf1070..42bf598c 100644
> --- a/s390x/skey.c
> +++ b/s390x/skey.c
> @@ -349,7 +349,7 @@ static void test_set_prefix(void)
>  	set_storage_key(pagebuf, 0x28, 0);
>  	expect_pgm_int();
>  	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
> -	set_prefix_key_1((uint32_t *)2048);
> +	set_prefix_key_1((uint32_t *)&mem_all[2048]);

... MEM(2048)

>  	install_page(root, 0, 0);
>  	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>  	report(get_prefix() == old_prefix, "did not set prefix");

