Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9431648E913
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 12:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240782AbiANLUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 06:20:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25314 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240780AbiANLUK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 06:20:10 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EArGk2015577;
        Fri, 14 Jan 2022 11:20:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=qrZAzY3X3ZPjxD7I8yuaAZvKWAcH4GdnRWOEn8qSbaM=;
 b=B5xKHv83Zk2N5pI5pcP5Tpgsr+IgjzvUTJy33VeEvWwKnOPbaedTDaaEdaiiw4x6Ka+L
 zVi0lJ+PxnOwoJzxBJEofJVk7Ktt4PaivJtNNw9xseddLgYBOdsKwpra6gh/R60H1nVK
 rILtrpT7/31II1jK26J+KsTZOv4U3UGbq8bMvqHf4sAL7L9IXg78CindFH3tWhEP9+SG
 FDB0MDjn4LHJdAsFJK6pBtObvzv7nZd3rNdQFcD2QWXZ7sbc7Gdc6+zFYzd50C4AZ84U
 cwdG2C8wAU2FT+laaK5hgTMQpIbvxehPnnGUBK1PW1YWWrKKwwmqqsJxwMeUmyny+Sno jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk7tpgd0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 11:20:09 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EBAC9b007623;
        Fri, 14 Jan 2022 11:20:09 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk7tpgcyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 11:20:09 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EBDVRu015344;
        Fri, 14 Jan 2022 11:20:07 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3df28a2pm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 11:20:07 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EBK3LU42336668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 11:20:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C825D4C040;
        Fri, 14 Jan 2022 11:20:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D1734C058;
        Fri, 14 Jan 2022 11:20:03 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.156])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 11:20:03 +0000 (GMT)
Date:   Fri, 14 Jan 2022 12:18:30 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/5] lib: s390x: vm: Add kvm and lpar vm
 queries
Message-ID: <20220114121830.0f6c4908@p-imbrenda>
In-Reply-To: <20220114100245.8643-2-frankja@linux.ibm.com>
References: <20220114100245.8643-1-frankja@linux.ibm.com>
        <20220114100245.8643-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: A0canKlF1kYIWrtgtgUfe2ufC16vvdvu
X-Proofpoint-ORIG-GUID: 57QJkBm830SFJZ0yeVIFU8FzcxTkME4Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_04,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 impostorscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jan 2022 10:02:41 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> This patch will likely (in parts) be replaced by Pierre's patch from
> his topology test series.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

although I think there is some room for improvement, but nothing too
serious, I'll probably fix it myself later

> ---
>  lib/s390x/vm.c | 39 +++++++++++++++++++++++++++++++++++++++
>  lib/s390x/vm.h | 23 +++++++++++++++++++++++
>  s390x/stsi.c   | 21 +--------------------
>  3 files changed, 63 insertions(+), 20 deletions(-)
> 
> diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
> index a5b92863..266a81c1 100644
> --- a/lib/s390x/vm.c
> +++ b/lib/s390x/vm.c
> @@ -26,6 +26,11 @@ bool vm_is_tcg(void)
>  	if (initialized)
>  		return is_tcg;
>  
> +	if (stsi_get_fc() < 3) {
> +		initialized = true;
> +		return false;
> +	}
> +
>  	buf = alloc_page();
>  	if (!buf)
>  		return false;
> @@ -43,3 +48,37 @@ out:
>  	free_page(buf);
>  	return is_tcg;
>  }
> +
> +bool vm_is_kvm(void)
> +{
> +	const uint8_t cpi_kvm[] = { 0xd2, 0xe5, 0xd4, 0x61 };
> +	struct stsi_322 *buf;
> +	static bool initialized = false;
> +	static bool is_kvm = false;
> +
> +	if (initialized)
> +		return is_kvm;
> +
> +	if (stsi_get_fc() < 3) {
> +		initialized = true;
> +		return false;
> +	}
> +
> +	buf = alloc_page();
> +	if (!buf)
> +		return false;
> +
> +	if (stsi(buf, 3, 2, 2))
> +		goto out;
> +
> +	is_kvm = !(memcmp(&buf->vm[0].cpi, cpi_kvm, sizeof(cpi_kvm))) && !vm_is_tcg();
> +	initialized = true;
> +out:
> +	free_page(buf);
> +	return is_kvm;
> +}
> +
> +bool vm_is_lpar(void)
> +{
> +	return stsi_get_fc() == 1;
> +}
> diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
> index 7abba0cc..d4a82fc0 100644
> --- a/lib/s390x/vm.h
> +++ b/lib/s390x/vm.h
> @@ -8,6 +8,29 @@
>  #ifndef _S390X_VM_H_
>  #define _S390X_VM_H_
>  
> +struct stsi_322 {
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
>  bool vm_is_tcg(void);
> +bool vm_is_kvm(void);
> +bool vm_is_lpar(void);
>  
>  #endif  /* _S390X_VM_H_ */
> diff --git a/s390x/stsi.c b/s390x/stsi.c
> index 391f8849..e66d07a1 100644
> --- a/s390x/stsi.c
> +++ b/s390x/stsi.c
> @@ -13,27 +13,8 @@
>  #include <asm/asm-offsets.h>
>  #include <asm/interrupt.h>
>  #include <smp.h>
> +#include <vm.h>
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

