Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54574ADCAC
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 16:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380423AbiBHPb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 10:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235109AbiBHPbY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 10:31:24 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF6CC061576;
        Tue,  8 Feb 2022 07:31:23 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218EqCUJ030346;
        Tue, 8 Feb 2022 15:31:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gvyyKINqaBLLp5K2CamjLGmegRgbUw6aN1ff8DA3jAg=;
 b=l1/W7uGbFCsVuWJ1Omsz+cbRsecG384U+3fXiccDlUYUURu1hI+xQgheJ2FtrTzVJP7R
 fTVRU3kBonErm8ELnl++CWRV0M1mA5IOUOjVNGxy2mBzUQ4AdwUIiCdtuZz/IGHvjiY2
 LuvEllvZ3wfatQVYRdOC7DdhcO3tA1s8xt1XCEqvHldPiwImZpW4RqDfU+jGEJ/zdmMV
 PXkHk8o3sNiXaj9nULofELH3IVr652y+PTMrLH/U9R0SKgSEGCqwGQRPlUG5lVAYuBUq
 pvpgp318ivgjjKZ2Kf7ngfAZaOptH8jKumRVNzYzFDZU+3vb3ByEMgKIUs7S/XNnKoFj zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22kqvubb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 15:31:22 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 218Eqeml010614;
        Tue, 8 Feb 2022 15:31:21 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22kqvuax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 15:31:21 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218FJ6en005541;
        Tue, 8 Feb 2022 15:31:20 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3e1gva62dt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 15:31:19 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218FVGxV30212496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 15:31:16 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A91942054;
        Tue,  8 Feb 2022 15:31:16 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E393C4204B;
        Tue,  8 Feb 2022 15:31:15 +0000 (GMT)
Received: from [9.145.76.86] (unknown [9.145.76.86])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 15:31:15 +0000 (GMT)
Message-ID: <62c23e3a-8cc9-2072-6022-cb23dfa08ce7@linux.ibm.com>
Date:   Tue, 8 Feb 2022 16:31:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com
References: <20220208132709.48291-1-pmorel@linux.ibm.com>
 <20220208132709.48291-3-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 2/4] s390x: stsi: Define vm_is_kvm to be
 used in different tests
In-Reply-To: <20220208132709.48291-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6fn6_kY5vmsV8KUBtkpRiCI4dMQQnq8K
X-Proofpoint-ORIG-GUID: RY-IneJsww8Z8fhUvakcvhuNHRhzRm83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_05,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/8/22 14:27, Pierre Morel wrote:
> We need in several tests to check if the VM we are running in
> is KVM.
> Let's add the test.

Several tests are in need of a way to check on which hypervisor and 
virtualization level they are running on to be able to fence certain 
tests. This patch adds functions that return true if a vm is running 
under KVM, LPAR or generally as a level 2 guest.

> 
> To check the VM type we use the STSI 3.2.2 instruction, let's

To check if we're running under KVM we...

> define it's response structure in a central header.

Since we already have a stsi test that defines the 3.2.2 structure let's 
move the struct from the test into a new library header.

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/stsi.h | 32 +++++++++++++++++++++++++++
>   lib/s390x/vm.c   | 56 ++++++++++++++++++++++++++++++++++++++++++++++--
>   lib/s390x/vm.h   |  3 +++
>   s390x/stsi.c     | 23 ++------------------
>   4 files changed, 91 insertions(+), 23 deletions(-)
>   create mode 100644 lib/s390x/stsi.h
> 
> diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
> new file mode 100644
> index 00000000..9b40664f
> --- /dev/null
> +++ b/lib/s390x/stsi.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Structures used to Store System Information
> + *
> + * Copyright IBM Corp. 2022
> + */
> +
> +#ifndef _S390X_STSI_H_
> +#define _S390X_STSI_H_
> +
> +struct sysinfo_3_2_2 {

Any particular reason why you renamed this?

> +	uint8_t reserved[31];
> +	uint8_t count;
> +	struct {
> +		uint8_t reserved2[4];
> +		uint16_t total_cpus;
> +		uint16_t conf_cpus;
> +		uint16_t standby_cpus;
> +		uint16_t reserved_cpus;
> +		uint8_t name[8];
> +		uint32_t caf;
> +		uint8_t cpi[16];
> +		uint8_t reserved5[3];
> +		uint8_t ext_name_encoding;
> +		uint32_t reserved3;
> +		uint8_t uuid[16];
> +	} vm[8];
> +	uint8_t reserved4[1504];
> +	uint8_t ext_names[8][256];
> +};
> +
> +#endif  /* _S390X_STSI_H_ */
> diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
> index a5b92863..38886b76 100644
> --- a/lib/s390x/vm.c
> +++ b/lib/s390x/vm.c
> @@ -12,6 +12,7 @@
>   #include <alloc_page.h>
>   #include <asm/arch_def.h>
>   #include "vm.h"
> +#include "stsi.h"
>   
>   /**
>    * Detect whether we are running with TCG (instead of KVM)
> @@ -26,9 +27,13 @@ bool vm_is_tcg(void)
>   	if (initialized)
>   		return is_tcg;
>   
> -	buf = alloc_page();
> -	if (!buf)
> +	if (!vm_is_vm()) {
> +		initialized = true;
>   		return false;
> +	}
> +
> +	buf = alloc_page();
> +	assert(buf);
>   
>   	if (stsi(buf, 1, 1, 1))
>   		goto out;
> @@ -43,3 +48,50 @@ out:
>   	free_page(buf);
>   	return is_tcg;
>   }
> +
> +/**
> + * Detect whether we are running with KVM
> + */
> +
> +bool vm_is_kvm(void)
> +{
> +	/* EBCDIC for "KVM/" */
> +	const uint8_t kvm_ebcdic[] = { 0xd2, 0xe5, 0xd4, 0x61 };
> +	static bool initialized;
> +	static bool is_kvm;
> +	struct sysinfo_3_2_2 *stsi_322;
> +
> +	if (initialized)
> +		return is_kvm;
> +
> +	if (!vm_is_vm() || vm_is_tcg()) {
> +		initialized = true;
> +		return is_kvm;
> +	}
> +
> +	stsi_322 = alloc_page();
> +	assert(stsi_322);
> +
> +	if (stsi(stsi_322, 3, 2, 2))
> +		goto out;
> +
> +	/*
> +	 * If the manufacturer string is "KVM/" in EBCDIC, then we
> +	 * are on KVM.
> +	 */
> +	is_kvm = !memcmp(&stsi_322->vm[0].cpi, kvm_ebcdic, sizeof(kvm_ebcdic));
> +	initialized = true;
> +out:
> +	free_page(stsi_322);
> +	return is_kvm;
> +}
> +
> +bool vm_is_lpar(void)
> +{
> +	return stsi_get_fc() == 2;
> +}
> +
> +bool vm_is_vm(void)
> +{
> +	return stsi_get_fc() == 3;

This would be true when running under z/VM, no?

I.e. what you're testing here is that we're a level 2 guest and hence 
the naming could be improved.

Also: what if we're under VSIE where we would be > 3?

> +}
> diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
> index 7abba0cc..3aaf76af 100644
> --- a/lib/s390x/vm.h
> +++ b/lib/s390x/vm.h
> @@ -9,5 +9,8 @@
>   #define _S390X_VM_H_
>   
>   bool vm_is_tcg(void);
> +bool vm_is_kvm(void);
> +bool vm_is_vm(void);
> +bool vm_is_lpar(void);
>   
>   #endif  /* _S390X_VM_H_ */
> diff --git a/s390x/stsi.c b/s390x/stsi.c
> index 391f8849..1ed045e2 100644
> --- a/s390x/stsi.c
> +++ b/s390x/stsi.c
> @@ -13,27 +13,8 @@
>   #include <asm/asm-offsets.h>
>   #include <asm/interrupt.h>
>   #include <smp.h>
> +#include "stsi.h"

#include <stsi.h>

We're not in the lib.

>   
> -struct stsi_322 {
> -	uint8_t reserved[31];
> -	uint8_t count;
> -	struct {
> -		uint8_t reserved2[4];
> -		uint16_t total_cpus;
> -		uint16_t conf_cpus;
> -		uint16_t standby_cpus;
> -		uint16_t reserved_cpus;
> -		uint8_t name[8];
> -		uint32_t caf;
> -		uint8_t cpi[16];
> -		uint8_t reserved5[3];
> -		uint8_t ext_name_encoding;
> -		uint32_t reserved3;
> -		uint8_t uuid[16];
> -	} vm[8];
> -	uint8_t reserved4[1504];
> -	uint8_t ext_names[8][256];
> -};
>   static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
>   
>   static void test_specs(void)
> @@ -91,7 +72,7 @@ static void test_3_2_2(void)
>   	/* EBCDIC for "KVM/" */
>   	const uint8_t cpi_kvm[] = { 0xd2, 0xe5, 0xd4, 0x61 };
>   	const char vm_name_ext[] = "kvm-unit-test";
> -	struct stsi_322 *data = (void *)pagebuf;
> +	struct sysinfo_3_2_2 *data = (void *)pagebuf;
>   
>   	report_prefix_push("3.2.2");
>   

