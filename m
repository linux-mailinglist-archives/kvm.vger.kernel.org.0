Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE9A48AE2F
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 14:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240304AbiAKNLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 08:11:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40922 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239945AbiAKNLS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 08:11:18 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BCMobh011933;
        Tue, 11 Jan 2022 13:11:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=smASBEjI1Gw58vkrxT6xikgiDa9lF4FXddr9MMZS24Y=;
 b=qtOhOndnUybPGr9oYhuUplMJX6o8XIj8qKnVNgVqFKhH1Ybe+e56lWu5qLU3wnjbO64k
 uoWO/5xNrP5yCzJ7nG5rtTXMXBmKSphTGOBTnkrWtX5BhIKp2ioIvrmpoNmevC5tKPy/
 dRMp9FE9SjVF4dKQyTei5ADgH41xEkPG9QWYpGWEcvumXX9qpKvMHg537z6XvcKO3zXL
 D+M/KkcYOiJQ29y4bnK8tBj08NwzUfnGb3T3R6QxoNKMV3zMNsxRyS1iVkl0RctCLHUt
 9zubDH5UHe8rrHU9o9CWPppks8t7mzbqqFweAcKZOsR+A7NN2CBcZq+w+bWWmkqNT4kZ fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dh37nt7s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 13:11:17 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BCtZ3M022502;
        Tue, 11 Jan 2022 13:11:17 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dh37nt7rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 13:11:17 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BD8fdG016364;
        Tue, 11 Jan 2022 13:11:15 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3df288y8w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 13:11:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BDBCIH41550216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 13:11:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFFB811C05B;
        Tue, 11 Jan 2022 13:11:11 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 895F611C04A;
        Tue, 11 Jan 2022 13:11:11 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.78])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 13:11:11 +0000 (GMT)
Date:   Tue, 11 Jan 2022 14:08:11 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 2/4] s390x: stsi: Define vm_is_kvm to
 be used in different tests
Message-ID: <20220111140811.2a7f49c2@p-imbrenda>
In-Reply-To: <20220110133755.22238-3-pmorel@linux.ibm.com>
References: <20220110133755.22238-1-pmorel@linux.ibm.com>
 <20220110133755.22238-3-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OrSAhFpyD_NnnHSuJlQRbyCd3UdlYO0N
X-Proofpoint-ORIG-GUID: 5mSMA-hqwCKQIYSXmQQ-kkIDPMRJV55E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 impostorscore=0 phishscore=0 mlxlogscore=999 clxscore=1011 adultscore=0
 bulkscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Jan 2022 14:37:53 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We need in several tests to check if the VM we are running in
> is KVM.
> Let's add the test.
> 
> To check the VM type we use the STSI 3.2.2 instruction, let's
> define it's response structure in a central header.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/stsi.h | 32 ++++++++++++++++++++++++++++++++
>  lib/s390x/vm.c   | 39 +++++++++++++++++++++++++++++++++++++++
>  lib/s390x/vm.h   |  1 +
>  s390x/stsi.c     | 23 ++---------------------
>  4 files changed, 74 insertions(+), 21 deletions(-)
>  create mode 100644 lib/s390x/stsi.h
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

Copyright IBM Corp. 2021

> + */
> +
> +#ifndef _S390X_STSI_H_
> +#define _S390X_STSI_H_

[...]

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

I don't like returning false if the allocation fails.
The allocation should not fail: assert(stsi_322);

> +
> +	if (stsi(stsi_322, 3, 2, 2))
> +		goto out;
> +
> +	/*
> +	 * If the manufacturer string is "KVM/" in EBCDIC, then we
> +	 * are on KVM (otherwise the string is "IBM" in EBCDIC)
> +	 */
> +	is_kvm = !memcmp(&stsi_322->vm[0].cpi, kvm_ebcdic, sizeof(kvm_ebcdic));
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
>  #define _S390X_VM_H_
>  
>  bool vm_is_tcg(void);
> +bool vm_is_kvm(void);
>  
>  #endif  /* _S390X_VM_H_ */
> diff --git a/s390x/stsi.c b/s390x/stsi.c
> index 391f8849..1ed045e2 100644
> --- a/s390x/stsi.c
> +++ b/s390x/stsi.c
> @@ -13,27 +13,8 @@
>  #include <asm/asm-offsets.h>
>  #include <asm/interrupt.h>
>  #include <smp.h>
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

