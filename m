Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660F24B8839
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 13:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbiBPMx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 07:53:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiBPMwP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 07:52:15 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE0BFABC1;
        Wed, 16 Feb 2022 04:51:57 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21GC9llN011858;
        Wed, 16 Feb 2022 12:51:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=66QayVr0oxlidVNcICPqsKCZnjcQCSaSECWLx5goslE=;
 b=rk6Z+kB101ckTvHK9RHwu0pUbs6nXyS8+vCILC9E3sDRdK0rHeCftIDU0xvp71vmV+9l
 7HtzHErrdF5JJxPwqEpL6CG2ebj2MmoR9NeUTXUu2/0wTt3DUUrhCrTnjqftwM1IFITh
 RdzxGAkJYS9vDYEsUQ1MvyKoXTce5bbbez2iSJClTf2hGgHfntcbn2kPhnmwiSEmTE17
 XJSxZfLtLgZ6LFFwR4Z57x9OXPwbVEuw/bIHCN5yg4CGQNuOSHnZVcL/XGnuFnD1vc0u
 hxI4vBAFn0hrDJEZm4fUHj+XnaQAouKU38uHpk2Of0hE3lZJO8sE+3pCYnajQGMM+7T7 wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e90m89n90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 12:51:57 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21GCCRlB025586;
        Wed, 16 Feb 2022 12:51:57 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e90m89n88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 12:51:57 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21GCfuNU018998;
        Wed, 16 Feb 2022 12:51:54 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3e645jy0dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 12:51:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21GCpp6c41877782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 12:51:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F40452050;
        Wed, 16 Feb 2022 12:51:51 +0000 (GMT)
Received: from [9.145.84.167] (unknown [9.145.84.167])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E7C7252051;
        Wed, 16 Feb 2022 12:51:50 +0000 (GMT)
Message-ID: <97c1f8a3-b121-7b9b-68f4-57c04c36662d@linux.ibm.com>
Date:   Wed, 16 Feb 2022 13:51:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: stsi: Define vm_is_kvm to be
 used in different tests
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com
References: <20220216123402.86538-1-pmorel@linux.ibm.com>
 <20220216123402.86538-2-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220216123402.86538-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nsEDaurlJfyKj4Q682Yc7WT9lpWBvNQu
X-Proofpoint-GUID: 63cmKR6Tv0toP4TVmjch9tfaYjs6SOaj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_05,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 adultscore=0 phishscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202160072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/16/22 13:34, Pierre Morel wrote:
> Several tests are in need of a way to check on which hypervisor
> and virtualization level they are running on to be able to fence
> certain tests. This patch adds functions that return true if a
> vm is running under KVM, LPAR or generally as a level 2 guest.
> 
> To check if we're running under KVM we use the STSI 3.2.2
> instruction, let's define it's response structure in a central
> header.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Thanks for being so patient with us Pierre :-)

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   lib/s390x/stsi.h | 32 ++++++++++++++++++++++++++++++
>   lib/s390x/vm.c   | 51 ++++++++++++++++++++++++++++++++++++++++++++++--
>   lib/s390x/vm.h   |  2 ++
>   s390x/stsi.c     | 23 ++--------------------
>   4 files changed, 85 insertions(+), 23 deletions(-)
>   create mode 100644 lib/s390x/stsi.h
> 
> diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
> new file mode 100644
> index 00000000..bebc492d
> --- /dev/null
> +++ b/lib/s390x/stsi.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
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
> index a5b92863..33fb1c45 100644
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
> +	if (stsi_get_fc() != 3) {
> +		initialized = true;
> +		return is_tcg;
> +	}
> +
>   	buf = alloc_page();
> -	if (!buf)
> -		return false;
> +	assert(buf);
>   
>   	if (stsi(buf, 1, 1, 1))
>   		goto out;
> @@ -43,3 +48,45 @@ out:
>   	free_page(buf);
>   	return is_tcg;
>   }
> +
> +/**
> + * Detect whether we are running with KVM
> + */
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
> +	if (stsi_get_fc() != 3 || vm_is_tcg()) {
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
> diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
> index 7abba0cc..4456b48c 100644
> --- a/lib/s390x/vm.h
> +++ b/lib/s390x/vm.h
> @@ -9,5 +9,7 @@
>   #define _S390X_VM_H_
>   
>   bool vm_is_tcg(void);
> +bool vm_is_kvm(void);
> +bool vm_is_lpar(void);
>   
>   #endif  /* _S390X_VM_H_ */
> diff --git a/s390x/stsi.c b/s390x/stsi.c
> index 391f8849..dccc53e7 100644
> --- a/s390x/stsi.c
> +++ b/s390x/stsi.c
> @@ -13,27 +13,8 @@
>   #include <asm/asm-offsets.h>
>   #include <asm/interrupt.h>
>   #include <smp.h>
> +#include <stsi.h>
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

