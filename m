Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EABE86E7B73
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 16:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjDSOA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 10:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjDSOAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 10:00:55 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542B81BC1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 07:00:53 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1a516fb6523so38536335ad.3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 07:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681912853; x=1684504853;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Teim5QMQaf+JnjzEfVq7NUW8hUFyxjJEdz/TIgEl4tw=;
        b=JwvpbuPlosz3Pj9hr2eQ/w/Cqsjdr3cBS9rNqZPDaINav5yA50hVOxsgojGf9T4KKb
         KszVm1TnvOmEFyXsxceNMQHVXzrZxogZQzmGsWlg30c1aGpLTArMgVxPOVob1qpWRbeP
         wilqxt7SagOL+tkafwCtOUxx1aKFfhwZbrV1bgOcE7CfvYeM0A4CBtEOS6/RPoCElKlj
         BmvmfsHa2bVcv/3S7nTZW4HpIMmytaT2B9WS45fB7oTMHQ/VyDxRYVa4HknGCA1KFFPv
         lpKykE7gnbPZhyVF+Ri71CXlKKlzvlHPQJx2liQO1NyTVSdvnbkIWXHCopJBmsLxHffN
         Q8Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681912853; x=1684504853;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Teim5QMQaf+JnjzEfVq7NUW8hUFyxjJEdz/TIgEl4tw=;
        b=fH6hguDwS7ne057VotSexKwXfwYO67SVVFU+pdnNxwJVrhNOy3PJCUpTmLXOokMGzF
         jdtJ2CDyHJ2UxvB991ureEvK015tubpb7fML6mllweJH1NOAgaV/HUOFo2r95odzf4YP
         MaLGaU/mwaAjtQq+p9q/S1R91mbX0AbY8PPxognvqee3SUtxv0bXL5Tb7VDb/6ay8IU/
         H8aoSP323sqGcOSeO7XjFCzAdm8CazZ26MIC1u67pitroQdJa6/Va1Cq8kEnad6awsNm
         aMdvKgyGG5z9rOxEWnsAlg05T0g3/zasAqMG2MdJm95lNWGlcyocKVenoIECppA7sUaU
         0QAg==
X-Gm-Message-State: AAQBX9fg+xQhg/U9AohzBgp9YxQRQ9SoZ+nKnWS4NMnrWQIHduyFSGg+
        13WkvbB0osUln9NW2L6Lhio=
X-Google-Smtp-Source: AKy350bp6ZxSY3jOiTj29f3n74xYQNL54xavhXjhlX+yn6+YH1OEmbRwZHwy8NXIDqP+oni+7IcbuA==
X-Received: by 2002:a17:902:7049:b0:1a3:d392:2f29 with SMTP id h9-20020a170902704900b001a3d3922f29mr5216156plt.20.1681912852781;
        Wed, 19 Apr 2023 07:00:52 -0700 (PDT)
Received: from [172.27.232.10] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id jf1-20020a170903268100b001a1ccb37847sm11491428plb.146.2023.04.19.07.00.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 07:00:52 -0700 (PDT)
Message-ID: <8d974125-163c-f61c-a988-5e5e6d762d73@gmail.com>
Date:   Wed, 19 Apr 2023 22:00:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 17/22] KVM: Introduce KVM_CAP_ABSENT_MAPPING_FAULT
 without implementation
Content-Language: en-US
To:     Anish Moorthy <amoorthy@google.com>, pbonzini@redhat.com,
        maz@kernel.org
Cc:     oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
References: <20230412213510.1220557-1-amoorthy@google.com>
 <20230412213510.1220557-18-amoorthy@google.com>
From:   Hoo Robert <robert.hoo.linux@gmail.com>
In-Reply-To: <20230412213510.1220557-18-amoorthy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/13/2023 5:35 AM, Anish Moorthy wrote:
> Add documentation, memslot flags, useful helper functions, and the
> actual new capability itself.
> 
> Memory fault exits on absent mappings are particularly useful for
> userfaultfd-based postcopy live migration. When many vCPUs fault on a
> single userfaultfd the faults can take a while to surface to userspace
> due to having to contend for uffd wait queue locks. Bypassing the uffd
> entirely by returning information directly to the vCPU exit avoids this
> contention and improves the fault rate.
> 
> Suggested-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>   Documentation/virt/kvm/api.rst | 31 ++++++++++++++++++++++++++++---
>   include/linux/kvm_host.h       |  7 +++++++
>   include/uapi/linux/kvm.h       |  2 ++
>   tools/include/uapi/linux/kvm.h |  1 +
>   virt/kvm/kvm_main.c            |  3 +++
>   5 files changed, 41 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index f174f43c38d45..7967b9909e28b 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1312,6 +1312,7 @@ yet and must be cleared on entry.
>     /* for kvm_userspace_memory_region::flags */
>     #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
>     #define KVM_MEM_READONLY	(1UL << 1)
> +  #define KVM_MEM_ABSENT_MAPPING_FAULT (1UL << 2)
>   
>   This ioctl allows the user to create, modify or delete a guest physical
>   memory slot.  Bits 0-15 of "slot" specify the slot id and this value
> @@ -1342,12 +1343,15 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
>   be identical.  This allows large pages in the guest to be backed by large
>   pages in the host.
>   
> -The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
> -KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
> +The flags field supports three flags
> +
> +1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of
>   writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
> -use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
> +use it.
> +2.  KVM_MEM_READONLY: can be set, if KVM_CAP_READONLY_MEM capability allows it,
>   to make a new slot read-only.  In this case, writes to this memory will be
>   posted to userspace as KVM_EXIT_MMIO exits.
> +3.  KVM_MEM_ABSENT_MAPPING_FAULT: see KVM_CAP_ABSENT_MAPPING_FAULT for details.
>   
>   When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
>   the memory region are automatically reflected into the guest.  For example, an
> @@ -7705,6 +7709,27 @@ userspace may receive "bare" EFAULTs (i.e. exit reason !=
>   KVM_EXIT_MEMORY_FAULT) from KVM_RUN. These should be considered bugs and
>   reported to the maintainers.
>   
> +7.35 KVM_CAP_ABSENT_MAPPING_FAULT
> +---------------------------------
> +
> +:Architectures: None
> +:Returns: -EINVAL.
> +
> +The presence of this capability indicates that userspace may pass the
> +KVM_MEM_ABSENT_MAPPING_FAULT flag to KVM_SET_USER_MEMORY_REGION to cause KVM_RUN
> +to fail (-EFAULT) in response to page faults for which the userspace page tables
> +do not contain present mappings. Attempting to enable the capability directly
> +will fail.
> +
> +The range of guest physical memory causing the fault is advertised to userspace
> +through KVM_CAP_MEMORY_FAULT_INFO (if it is enabled).
> +
> +Userspace should determine how best to make the mapping present, then take
> +appropriate action. For instance, in the case of absent mappings this might
> +involve establishing the mapping for the first time via UFFDIO_COPY/CONTINUE or
> +faulting the mapping in using MADV_POPULATE_READ/WRITE. After establishing the
> +mapping, userspace can return to KVM to retry the previous memory access.
> +
>   8. Other capabilities.
>   ======================
>   
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 776f9713f3921..2407fc1e52ab8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2289,4 +2289,11 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
>    */
>   inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
>   					uint64_t gpa, uint64_t len);
> +
> +static inline bool kvm_slot_fault_on_absent_mapping(
> +							const struct kvm_memory_slot *slot)

Strange line break.

> +{
> +	return slot->flags & KVM_MEM_ABSENT_MAPPING_FAULT;
> +}
> +
>   #endif
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index bc73e8381a2bb..21df449e74648 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -102,6 +102,7 @@ struct kvm_userspace_memory_region {
>    */
>   #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
>   #define KVM_MEM_READONLY	(1UL << 1)
> +#define KVM_MEM_ABSENT_MAPPING_FAULT	(1UL << 2)
>   
>   /* for KVM_IRQ_LINE */
>   struct kvm_irq_level {
> @@ -1196,6 +1197,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
>   #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
>   #define KVM_CAP_MEMORY_FAULT_INFO 227
> +#define KVM_CAP_ABSENT_MAPPING_FAULT 228
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index 5c57796364d65..59219da95634c 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -102,6 +102,7 @@ struct kvm_userspace_memory_region {
>    */
>   #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
>   #define KVM_MEM_READONLY	(1UL << 1)
> +#define KVM_MEM_ABSENT_MAPPING_FAULT (1UL << 2)
>   
>   /* for KVM_IRQ_LINE */
>   struct kvm_irq_level {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f3be5aa49829a..7cd0ad94726df 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1525,6 +1525,9 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
>   	valid_flags |= KVM_MEM_READONLY;

Is it better to also via kvm_vm_ioctl_check_extension() rather than
#ifdef __KVM_HAVE_READONLY_MEM?

>   #endif
>   
> +	if (kvm_vm_ioctl_check_extension(NULL, KVM_CAP_ABSENT_MAPPING_FAULT))
> +		valid_flags |= KVM_MEM_ABSENT_MAPPING_FAULT;
> +
>   	if (mem->flags & ~valid_flags)
>   		return -EINVAL;
>   

