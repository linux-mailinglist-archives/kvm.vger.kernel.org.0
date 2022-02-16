Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C044B87F7
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 13:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbiBPMob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 07:44:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbiBPMoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 07:44:23 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A6A1F6BB9;
        Wed, 16 Feb 2022 04:44:11 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21GC84Fq015708;
        Wed, 16 Feb 2022 12:44:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Qi4bjD6VXj9gVN37gWFYXQOu3KVisX9MQLAx792Aqco=;
 b=gkRVQbQg4Fqsv1gbGGXBC4weHYKzjzn2s+GnOtQmzk+/RyC0N+WGy0bAT5y0HzdMz4fo
 4frjFNjd99yuUAW84RM33S7s6APryzBpMCVZ5S5pI9COXrmTBmoF8KFhwRQsA7EKjzuT
 uWH7GN48rD/RwhLXeLpkqhAfcayNegR6cHQGSJr35BMVVQMRxZ6HA6nm0pqWlZmpvWzU
 w385ildt2YVm6AXOUZ9FkC/Fw0PhFYh74/Qj5hq3U4tbG5zLzleOTeSI9YFzZPMqf1O/
 pPGS5Jj+SeUDwCsic3F/SiaUtzgPK4RQJAqLT/laeWkrdwwuMUaS1CyAAh4+R0txkfDD Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8usgysyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 12:44:09 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21GCfb9G033156;
        Wed, 16 Feb 2022 12:44:05 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8usgysx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 12:44:05 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21GCggUp027562;
        Wed, 16 Feb 2022 12:44:03 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3e645k0mmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 12:44:03 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21GCi0i343319658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 12:44:00 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 312C4A40B8;
        Wed, 16 Feb 2022 12:44:00 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5954A40BB;
        Wed, 16 Feb 2022 12:43:59 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.54])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Feb 2022 12:43:59 +0000 (GMT)
Date:   Wed, 16 Feb 2022 13:43:57 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        david@redhat.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: stsi: Define vm_is_kvm to
 be used in different tests
Message-ID: <20220216134357.3e59f209@p-imbrenda>
In-Reply-To: <20220216123402.86538-2-pmorel@linux.ibm.com>
References: <20220216123402.86538-1-pmorel@linux.ibm.com>
        <20220216123402.86538-2-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2VswalHI7KNHlaTU_z8zELMzDVS-YLuS
X-Proofpoint-GUID: 3rxMCgumVl3_WkyLJijr_Ci4NzSoDVA-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_05,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 spamscore=0 phishscore=0 clxscore=1015 malwarescore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202160072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Feb 2022 13:34:02 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

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

I will queue this, thanks

> ---
>  lib/s390x/stsi.h | 32 ++++++++++++++++++++++++++++++
>  lib/s390x/vm.c   | 51 ++++++++++++++++++++++++++++++++++++++++++++++--
>  lib/s390x/vm.h   |  2 ++
>  s390x/stsi.c     | 23 ++--------------------
>  4 files changed, 85 insertions(+), 23 deletions(-)
>  create mode 100644 lib/s390x/stsi.h
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
>  #include <alloc_page.h>
>  #include <asm/arch_def.h>
>  #include "vm.h"
> +#include "stsi.h"
>  
>  /**
>   * Detect whether we are running with TCG (instead of KVM)
> @@ -26,9 +27,13 @@ bool vm_is_tcg(void)
>  	if (initialized)
>  		return is_tcg;
>  
> +	if (stsi_get_fc() != 3) {
> +		initialized = true;
> +		return is_tcg;
> +	}
> +
>  	buf = alloc_page();
> -	if (!buf)
> -		return false;
> +	assert(buf);
>  
>  	if (stsi(buf, 1, 1, 1))
>  		goto out;
> @@ -43,3 +48,45 @@ out:
>  	free_page(buf);
>  	return is_tcg;
>  }
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
>  #define _S390X_VM_H_
>  
>  bool vm_is_tcg(void);
> +bool vm_is_kvm(void);
> +bool vm_is_lpar(void);
>  
>  #endif  /* _S390X_VM_H_ */
> diff --git a/s390x/stsi.c b/s390x/stsi.c
> index 391f8849..dccc53e7 100644
> --- a/s390x/stsi.c
> +++ b/s390x/stsi.c
> @@ -13,27 +13,8 @@
>  #include <asm/asm-offsets.h>
>  #include <asm/interrupt.h>
>  #include <smp.h>
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
>  static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
>  
>  static void test_specs(void)
> @@ -91,7 +72,7 @@ static void test_3_2_2(void)
>  	/* EBCDIC for "KVM/" */
>  	const uint8_t cpi_kvm[] = { 0xd2, 0xe5, 0xd4, 0x61 };
>  	const char vm_name_ext[] = "kvm-unit-test";
> -	struct stsi_322 *data = (void *)pagebuf;
> +	struct sysinfo_3_2_2 *data = (void *)pagebuf;
>  
>  	report_prefix_push("3.2.2");
>  

