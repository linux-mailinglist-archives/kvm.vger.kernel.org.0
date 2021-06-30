Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0A23B7E3D
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 09:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhF3Hkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 03:40:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21326 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232785AbhF3Hkj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Jun 2021 03:40:39 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15U7ZHRT152265;
        Wed, 30 Jun 2021 03:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VQb3oXP7a/NtEgzrUvK9Rt998x3BEpLj4eKcKZN21Ss=;
 b=PSHdb3bqwlY2+ot7SImYFhR4ZU/CDVQxeBZHqpEXNozc5+5hjkVBECcS9KFOgcjMCCjI
 kZLiBnkj/7eEiMhYQ0VhBAiw651fKacOxO8jH7Ej3KSHCEnzp8yAaOfSupckNp70xE+a
 CiMxDtwOZWVHxuLPN7SiAehraK+mu98HCEpdYEUrD4eg0a9A6n33T47XrtXRMhXY1VRY
 AapJQTrGjB3NvfiThZMmuygM280fuxM8agsHArodoSEdmiad1yN8LojAnfCdTjfJLs/Q
 OndRbOrefFfATk0tJ7lAEQwrpfxjKJ6DVNXMm/4jw8FL+oe5jdAffdm7XSaxdnGmbFuK eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39gfv6xbmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 03:38:00 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15U7aDuu155690;
        Wed, 30 Jun 2021 03:38:00 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39gfv6xbkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 03:38:00 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15U7bwxu025284;
        Wed, 30 Jun 2021 07:37:58 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 39duv8gunp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 07:37:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15U7btqQ27001188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Jun 2021 07:37:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB38B4C063;
        Wed, 30 Jun 2021 07:37:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 690874C050;
        Wed, 30 Jun 2021 07:37:54 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.84.194])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Jun 2021 07:37:54 +0000 (GMT)
Subject: Re: [PATCH] KVM: selftests: Fix mapping length truncation in
 m{,un}map()
To:     Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com
Cc:     wanghaibin.wang@huawei.com
References: <20210624070931.565-1-yuzenghui@huawei.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <78f94832-4a87-91fa-77fc-6b32252664de@de.ibm.com>
Date:   Wed, 30 Jun 2021 09:37:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210624070931.565-1-yuzenghui@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cxGgkxEhtgaV2NwEC0fjTy3WHU2x36np
X-Proofpoint-GUID: VvwMi8GI9FhJEF1TPKmg3R4NCfNj6ptX
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-30_01:2021-06-29,2021-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 suspectscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 clxscore=1011
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106300049
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24.06.21 09:09, Zenghui Yu wrote:
> max_mem_slots is now declared as uint32_t. The result of (0x200000 * 32767)
> is unexpectedly truncated to be 0xffe00000, whilst we actually need to
> allocate about, 63GB. Cast max_mem_slots to size_t in both mmap() and
> munmap() to fix the length truncation.
> 
> We'll otherwise see the failure on arm64 thanks to the access_ok() checking
> in __kvm_set_memory_region(), as the unmapped VA happen to go beyond the
> task's allowed address space.
> 
>   # ./set_memory_region_test
> Allowed number of memory slots: 32767
> Adding slots 0..32766, each memory region with 2048K size
> ==== Test Assertion Failure ====
>    set_memory_region_test.c:391: ret == 0
>    pid=94861 tid=94861 errno=22 - Invalid argument
>       1	0x00000000004015a7: test_add_max_memory_regions at set_memory_region_test.c:389
>       2	 (inlined by) main at set_memory_region_test.c:426
>       3	0x0000ffffb8e67bdf: ?? ??:0
>       4	0x00000000004016db: _start at :?
>    KVM_SET_USER_MEMORY_REGION IOCTL failed,
>    rc: -1 errno: 22 slot: 2615
> 
> Fixes: 3bf0fcd75434 ("KVM: selftests: Speed up set_memory_region_test")
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>

While likely correct, this now breaks on many test systems in our CI that have less memory than 64GB.
(We do get ENOMEM). I have not seen the ENOMEM failures in earlier versions. Strange

> ---
>   tools/testing/selftests/kvm/set_memory_region_test.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
> index d79d58eada9f..85b18bb8f762 100644
> --- a/tools/testing/selftests/kvm/set_memory_region_test.c
> +++ b/tools/testing/selftests/kvm/set_memory_region_test.c
> @@ -376,7 +376,7 @@ static void test_add_max_memory_regions(void)
>   	pr_info("Adding slots 0..%i, each memory region with %dK size\n",
>   		(max_mem_slots - 1), MEM_REGION_SIZE >> 10);
> 
> -	mem = mmap(NULL, MEM_REGION_SIZE * max_mem_slots + alignment,
> +	mem = mmap(NULL, (size_t)max_mem_slots * MEM_REGION_SIZE + alignment,
>   		   PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>   	TEST_ASSERT(mem != MAP_FAILED, "Failed to mmap() host");
>   	mem_aligned = (void *)(((size_t) mem + alignment - 1) & ~(alignment - 1));
> @@ -401,7 +401,7 @@ static void test_add_max_memory_regions(void)
>   	TEST_ASSERT(ret == -1 && errno == EINVAL,
>   		    "Adding one more memory slot should fail with EINVAL");
> 
> -	munmap(mem, MEM_REGION_SIZE * max_mem_slots + alignment);
> +	munmap(mem, (size_t)max_mem_slots * MEM_REGION_SIZE + alignment);
>   	munmap(mem_extra, MEM_REGION_SIZE);
>   	kvm_vm_free(vm);
>   }
> 
