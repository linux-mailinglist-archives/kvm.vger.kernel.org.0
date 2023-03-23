Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B776C72AD
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 22:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjCWV76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 17:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbjCWV7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 17:59:55 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E221418AB1
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:59:53 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id q102so8196178pjq.3
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679608793;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kBrPAsOPLA5SHIhVYbiPO9xPAXdatozqf1Me6tgID0s=;
        b=K78rBeJU2xxEG+YystW3iiMULXg1fV6+fr73nqJbl1TNP1j6ur4vBJujIeqq8892AT
         GIzt8YbORoR8k9CrFSlMV0QSvTYrs71zpuh87dSGeybHnxBcvOA10FX0U5GqIkToee5O
         jZAy1tb/rofMRZDXlJsYNu30wy9lIWCdMBoONqcMldXhdBjuyoy+7B91W1BWuU15/StE
         zwyaRcf8EYol9sOhMT59zP5il5iWFKQVMDVu9kj+csmKea74+PoM54gF/DayV9USQ8uj
         KMzdKbVePN5/w2QOaQnWdYq95bdh/9w31/l/5GChT5iztIBXW6ZpzFiohBJJqqngARbj
         xsVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679608793;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kBrPAsOPLA5SHIhVYbiPO9xPAXdatozqf1Me6tgID0s=;
        b=EFAn0/ugX8bZet2vnTqIX1jGiakiQWNEiPihjEcJQ1mkOGWairrSEr1C9SW1KI+E+L
         kiBptT7BVOQVVp5lH87wqLZPyz8zc2vB+pmSKxki0Us5o5R9gPT+n05p2cMnYcokzlNk
         DUnMwJ1Nror8jDh7umjGwOXeCzizTzxG2uj/9yNuEcgcCTM2Qs/0TdyTByjjmZJahSFA
         Yea9YfHvIE6wTuUB0fqRuWX/AeQJ1G0+6Fouxcj1ysNM/k2bHUeR9VSWBh2w6vqowTI4
         KXgQTIddKZtAzMzFeKi9MQ5K9SjLKyFYKeMKZRqWkvVthgD3H65eyzP/ryUgP68g821d
         VV4w==
X-Gm-Message-State: AAQBX9dZS+rjSElMzb6Q/NMICCflb/rPEyFxyUiEmSs57/BhNE84Y5RK
        B0g7XoEWuBeAvv3IbvLEmS29saz2uWTsY2mc4Ks62g==
X-Google-Smtp-Source: AKy350YzVRVvcpp8D3CuzT1j94gNIfxCDTvQ6bNJTpCyd7aDek9aQq3yYiNBLy7HqI6QK3JfdK2nKQ==
X-Received: by 2002:a17:902:e80f:b0:19d:af20:3fe8 with SMTP id u15-20020a170902e80f00b0019daf203fe8mr501695plg.21.1679608793077;
        Thu, 23 Mar 2023 14:59:53 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id jj2-20020a170903048200b0019fea4bb887sm12868896plb.157.2023.03.23.14.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 14:59:52 -0700 (PDT)
Date:   Thu, 23 Mar 2023 14:59:48 -0700
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 11/18] KVM: x86/mmu: Add documentation of NUMA aware
 page table capability
Message-ID: <ZBzL1Awe7S00dPUP@google.com>
References: <20230306224127.1689967-1-vipinsh@google.com>
 <20230306224127.1689967-12-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306224127.1689967-12-vipinsh@google.com>
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023 at 02:41:20PM -0800, Vipin Sharma wrote:
> Add documentation for KVM_CAP_NUMA_AWARE_PAGE_TABLE capability and
> explain why it is needed.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 62de0768d6aa..7e3a1299ca8e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7669,6 +7669,35 @@ This capability is aimed to mitigate the threat that malicious VMs can
>  cause CPU stuck (due to event windows don't open up) and make the CPU
>  unavailable to host or other VMs.
>  
> +7.34 KVM_CAP_NUMA_AWARE_PAGE_TABLE
> +------------------------------
> +
> +:Architectures: x86
> +:Target: VM
> +:Returns: 0 on success, -EINVAL if vCPUs are already created.
> +
> +This capability allows userspace to enable NUMA aware page tables allocations.

Call out that this capability overrides task mempolicies. e.g.

  This capability causes KVM to use a custom NUMA memory policy when
  allocating page tables. Specifically, KVM will attempt to co-locate
  page tables pages with the memory that they map, rather than following
  the mempolicy of the current task.

> +NUMA aware page tables are disabled by default. Once enabled, prior to vCPU
> +creation, any page table allocated during the life of a VM will be allocated

The "prior to vCPU creation" part here is confusing because it sounds
like you're talking about any page tables allocated before vCPU
creation. Just delete that part and put it in a separate paragraph.

 KVM_CAP_NUMA_AWARE_PAGE_TABLE must be enabled before any vCPU is
 created, otherwise KVM will return -EINVAL.

> +preferably from the NUMA node of the leaf page.
> +
> +Without this capability, default feature is to use current thread mempolicy and

s/default feature is to/KVM will/

> +allocate page table based on that.

s/and allocate page table based on that./to allocate page tables./

> +
> +This capability is useful to improve page accesses by a guest. For example, an

nit: Be more specific about how.

 This capability aims to minimize the cost of TLB misses when a vCPU is
 accessing NUMA-local memory, by reducing the number of remote memory
 accesses needed to walk KVM's page tables.

> +initialization thread which access lots of remote memory and ends up creating
> +page tables on local NUMA node, or some service thread allocates memory on
> +remote NUMA nodes and later worker/background threads accessing that memory
> +will end up accessing remote NUMA node page tables.

It's not clear if these examples are talking about what happens when
KVM_CAP_NUMA_AWARE_PAGE_TABLE is enabled or disabled.

Also it's important to distinguish virtual NUMA nodes from physical NUMA
nodes and where these "threads" are running. How about this:

 For example, when KVM_CAP_NUMA_AWARE_PAGE_TABLE is disabled and a vCPU
 accesses memory on a remote NUMA node and triggers a KVM page fault,
 KVM will allocate page tables to handle that fault on the node where
 the vCPU is running rather than the node where the memory is allocated.
 When KVM_CAP_NUMA_AWARE_PAGE_TABLE is enabled, KVM will allocate the
 page tables on the node where the memory is located.

 This is intended to be used in VM configurations that properly
 virtualize NUMA. i.e. VMs with one or more virtual NUMA nodes, each of
 which is mapped to a physical NUMA node. With this capability enabled
 on such VMs, any guest memory access to virtually-local memory will be
 translated through mostly[*] physically-local page tables, regardless
 of how the memory was faulted in.

 [*] KVM will fallback to allocating from remote NUMA nodes if the
 preferred node is out of memory. Also, in VMs with 2 or more NUMA
 nodes, higher level page tables will necessarily map memory across
 multiple physical nodes.

> So, a multi NUMA node
> +guest, can with high confidence access local memory faster instead of going
> +through remote page tables first.
> +
> +This capability is also helpful for host to reduce live migration impact when
> +splitting huge pages during dirty log operations. If the thread splitting huge
> +page is on remote NUMA node it will create page tables on remote node. Even if
> +guest is careful in making sure that it only access local memory they will end
> +up accessing remote page tables.

Please also cover the limitations of this feature:

 - Impact on remote memory accesses (more expensive).
 - How KVM handles NUMA node exhaustion.
 - How high-level page tables can span multiple nodes.
 - What KVM does if it can't determine the NUMA node of the pfn.
 - What KVM does for faults on GPAs that aren't backed by a pfn.

> +
>  8. Other capabilities.
>  ======================
>  
> -- 
> 2.40.0.rc0.216.gc4246ad0f0-goog
> 
