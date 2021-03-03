Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE3A32C63C
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238080AbhCDA2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:28:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53080 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242486AbhCCOI5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 09:08:57 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 123E38Jd021322;
        Wed, 3 Mar 2021 09:07:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=b1Eil9MDUxhdYNA6OorS+IFTSjRbNFBSRjLKeiOk0KE=;
 b=rw5abHo3xhuNsc5IT00HVzzlmjjaR4uoNHmJ/itP40bigjgAgVPNCEedDf6nyCGXh8XD
 Y1iD+obRUlP0Z3iUKEGgqAel/OsC4J4/cBMBXEEd2JeBLwMMqed+8XwBbUw76EgBEV95
 mBqhbKw6gpiG0qmnlxXXQQkQiRphfIsqcEF26FBJpMcmMbN7KFZgH2qhtx0OQfj6Uayu
 M/n1IITerLX01AMSqz9OLXthbZ+MVIPTAPBvMLgOSIxzhgX36HFHrjVydvlAjE/wL9Rb
 fFE4qrpGrzw+E1l785XvquJBoO6aMT3XciCHNpoymQympwOxsbzXmJbqYd1vOx3pWYG7 KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 372ap3bda5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 09:07:18 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 123E3Emb021993;
        Wed, 3 Mar 2021 09:07:18 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 372ap3bd4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 09:07:18 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 123E4kIF028060;
        Wed, 3 Mar 2021 14:07:13 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 371162hw15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 14:07:13 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 123E7B9R39649696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Mar 2021 14:07:11 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23E254C046;
        Wed,  3 Mar 2021 14:07:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58BC94C04A;
        Wed,  3 Mar 2021 14:07:10 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.85.32])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Mar 2021 14:07:10 +0000 (GMT)
Subject: Re: [PATCH v1 1/2] s390x/kvm: Get rid of legacy_s390_alloc()
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Peter Xu <peterx@redhat.com>
References: <20210303130916.22553-1-david@redhat.com>
 <20210303130916.22553-2-david@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <ffb3c5f5-03bc-c8f8-b414-0556cbdbc101@de.ibm.com>
Date:   Wed, 3 Mar 2021 15:07:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210303130916.22553-2-david@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-03_04:2021-03-03,2021-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 clxscore=1011 impostorscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103030107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 03.03.21 14:09, David Hildenbrand wrote:
> legacy_s390_alloc() was required for dealing with the absence of the ESOP
> feature -- on old HW (< gen 10) and old z/VM versions (< 6.3).
> 
> As z/VM v6.2 (and even v6.3) is no longer supported since 2017 [1]
> and we don't expect to have real users on such old hardware, let's drop
> legacy_s390_alloc().
> 
> Still check+report an error just in case someone still runs on
> such old z/VM environments, or someone runs under weird nested KVM
> setups (where we can manually disable ESOP via the CPU model).
> 
> No need to check for KVM_CAP_GMAP - that should always be around on
> kernels that also have KVM_CAP_DEVICE_CTRL (>= v3.15).
> 
> [1] https://www.ibm.com/support/lifecycle/search?q=z%2FVM
> 
> Suggested-by: Cornelia Huck <cohuck@redhat.com>
> Suggested-by: Thomas Huth <thuth@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Igor Mammedov <imammedo@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

I agree, this should now be a corner case that we do not necessarily have to care about.

> ---
>   target/s390x/kvm.c | 43 +++++--------------------------------------
>   1 file changed, 5 insertions(+), 38 deletions(-)
> 
> diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
> index 7a892d663d..84b40572f2 100644
> --- a/target/s390x/kvm.c
> +++ b/target/s390x/kvm.c
> @@ -161,8 +161,6 @@ static int cap_protected;
>   
>   static int active_cmma;
>   
> -static void *legacy_s390_alloc(size_t size, uint64_t *align, bool shared);
> -
>   static int kvm_s390_query_mem_limit(uint64_t *memory_limit)
>   {
>       struct kvm_device_attr attr = {
> @@ -349,6 +347,11 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>                        "please use kernel 3.15 or newer");
>           return -1;
>       }
> +    if (!kvm_check_extension(s, KVM_CAP_S390_COW)) {
> +        error_report("KVM is missing capability KVM_CAP_S390_COW - "
> +                     "unsupported environment");
> +        return -1;
> +    }
>   
>       cap_sync_regs = kvm_check_extension(s, KVM_CAP_SYNC_REGS);
>       cap_async_pf = kvm_check_extension(s, KVM_CAP_ASYNC_PF);
> @@ -357,11 +360,6 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>       cap_vcpu_resets = kvm_check_extension(s, KVM_CAP_S390_VCPU_RESETS);
>       cap_protected = kvm_check_extension(s, KVM_CAP_S390_PROTECTED);
>   
> -    if (!kvm_check_extension(s, KVM_CAP_S390_GMAP)
> -        || !kvm_check_extension(s, KVM_CAP_S390_COW)) {
> -        phys_mem_set_alloc(legacy_s390_alloc);
> -    }
> -
>       kvm_vm_enable_cap(s, KVM_CAP_S390_USER_SIGP, 0);
>       kvm_vm_enable_cap(s, KVM_CAP_S390_VECTOR_REGISTERS, 0);
>       kvm_vm_enable_cap(s, KVM_CAP_S390_USER_STSI, 0);
> @@ -889,37 +887,6 @@ int kvm_s390_mem_op_pv(S390CPU *cpu, uint64_t offset, void *hostbuf,
>       return ret;
>   }
>   
> -/*
> - * Legacy layout for s390:
> - * Older S390 KVM requires the topmost vma of the RAM to be
> - * smaller than an system defined value, which is at least 256GB.
> - * Larger systems have larger values. We put the guest between
> - * the end of data segment (system break) and this value. We
> - * use 32GB as a base to have enough room for the system break
> - * to grow. We also have to use MAP parameters that avoid
> - * read-only mapping of guest pages.
> - */
> -static void *legacy_s390_alloc(size_t size, uint64_t *align, bool shared)
> -{
> -    static void *mem;
> -
> -    if (mem) {
> -        /* we only support one allocation, which is enough for initial ram */
> -        return NULL;
> -    }
> -
> -    mem = mmap((void *) 0x800000000ULL, size,
> -               PROT_EXEC|PROT_READ|PROT_WRITE,
> -               MAP_SHARED | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
> -    if (mem == MAP_FAILED) {
> -        mem = NULL;
> -    }
> -    if (mem && align) {
> -        *align = QEMU_VMALLOC_ALIGN;
> -    }
> -    return mem;
> -}
> -
>   static uint8_t const *sw_bp_inst;
>   static uint8_t sw_bp_ilen;
>   
> 
