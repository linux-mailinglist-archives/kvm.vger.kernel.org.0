Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548A248AD96
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 13:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239904AbiAKM1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 07:27:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27782 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239846AbiAKM1O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 07:27:14 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BAwMYG022803;
        Tue, 11 Jan 2022 12:27:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vmDCe3jRYKbgTGE0LnL9ZZ+XpnzdvdngcGZhX40M+7c=;
 b=Z5u8V/UL7zJeqd4BnhUBk/usEtFbNgWkt+JRZl9NVjlgb8pzfWHArfh4vaIpKJWVtoqp
 Sv8T8r5CQ6neTLIdr0+vH43T8w+rhNgj9ZuD+kXS2p5gL62oVujMOqCdWESuLaYNK/T2
 KI3QBXVqC8UNkd6FcqAlQNeeZJwJxA8FxA6rz4NE7Zk4jx3G7lHml+5r+dMA2ERSmrJW
 LgU7Yvy4VHorZ1WzJDOKfASTzGADC7vlVFBni4B4yzJ2m+xqU2vPWNOxKxRUvvM2FhRj
 HfJIX5rWppoMDP+terXBmpKBrF48F2afV0ngzwUhSM2bMI3XmeaKIRXhAZM3fGPxpQIK +Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dh8m11svu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 12:27:13 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BCRDPJ030947;
        Tue, 11 Jan 2022 12:27:13 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dh8m11svb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 12:27:13 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BCC8bS020925;
        Tue, 11 Jan 2022 12:27:11 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3df2895k2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 12:27:11 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BCR8F039584090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 12:27:08 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 532E911C058;
        Tue, 11 Jan 2022 12:27:08 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F401311C05E;
        Tue, 11 Jan 2022 12:27:07 +0000 (GMT)
Received: from [9.145.189.100] (unknown [9.145.189.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 12:27:07 +0000 (GMT)
Message-ID: <75d4a897-55dd-5140-ac8b-638fa18d2e17@linux.ibm.com>
Date:   Tue, 11 Jan 2022 13:27:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <20220110133755.22238-1-pmorel@linux.ibm.com>
 <20220110133755.22238-3-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/4] s390x: stsi: Define vm_is_kvm to be
 used in different tests
In-Reply-To: <20220110133755.22238-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _5iuTYi6sxWoD5g-nM2Xz2fKQ0RJ71YG
X-Proofpoint-ORIG-GUID: YtTWjZjz6ox3teKv2k9vJ-8Qz7_ofp9K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/10/22 14:37, Pierre Morel wrote:
> We need in several tests to check if the VM we are running in
> is KVM.
> Let's add the test.
> 
> To check the VM type we use the STSI 3.2.2 instruction, let's
> define it's response structure in a central header.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/stsi.h | 32 ++++++++++++++++++++++++++++++++
>   lib/s390x/vm.c   | 39 +++++++++++++++++++++++++++++++++++++++
>   lib/s390x/vm.h   |  1 +
>   s390x/stsi.c     | 23 ++---------------------
>   4 files changed, 74 insertions(+), 21 deletions(-)
>   create mode 100644 lib/s390x/stsi.h
> 
> diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
> new file mode 100644
> index 00000000..02cc94a6
> --- /dev/null
> +++ b/lib/s390x/stsi.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Structures used to Store System Information
> + *
> + * Copyright (c) 2021 IBM Inc
> + */
> +
> +#ifndef _S390X_STSI_H_
> +#define _S390X_STSI_H_
> +
> +struct sysinfo_3_2_2 {
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
> index a5b92863..3e11401e 100644
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

We could add a fc < 3 check to the vm_is_tcg() function and add a 
vm_is_lpar() which does a simple fc ==1 check.

> @@ -43,3 +44,41 @@ out:
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
> +	if (stsi_get_fc() < 3) {
> +		initialized = true;
> +		return is_kvm;
> +	}
> +
> +	stsi_322 = alloc_page();
> +	if (!stsi_322)
> +		return false;
> +
> +	if (stsi(stsi_322, 3, 2, 2))
> +		goto out;
> +
> +	/*
> +	 * If the manufacturer string is "KVM/" in EBCDIC, then we
> +	 * are on KVM (otherwise the string is "IBM" in EBCDIC)
> +	 */
> +	is_kvm = !memcmp(&stsi_322->vm[0].cpi, kvm_ebcdic, sizeof(kvm_ebcdic));

So I had a look at this before Christmas and I think it's wrong.

QEMU will still set the cpi to KVM/LINUX if we are under tcg.
So we need to do add a !tcg check here and fix this comment.

I.e. we always have the KVM/LINUX cpi but if we're under TCG the 
manufacturer in fc == 1 is QEMU. I'm not sure if this is intentional and 
if we want to fix this at some point or not.

> +	initialized = true;
> +out:
> +	free_page(stsi_322);
> +	return is_kvm;
> +}
> diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
> index 7abba0cc..44097b4a 100644
> --- a/lib/s390x/vm.h
> +++ b/lib/s390x/vm.h
> @@ -9,5 +9,6 @@
>   #define _S390X_VM_H_
>   
>   bool vm_is_tcg(void);
> +bool vm_is_kvm(void);
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
> 

