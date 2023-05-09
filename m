Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5CD96FC714
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 14:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbjEIMwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 08:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234981AbjEIMwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 08:52:03 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727AA2694;
        Tue,  9 May 2023 05:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683636720; x=1715172720;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=rrSQ/FJcEqHkrsjB0HKViGMNUOtQomkux4NFU2fyLL0=;
  b=UQd+EizIVOZpQSRFB1ChVWrnDtLeMUmqaZsyXRzu8n5A1wMND7BGtcr9
   dCosj+p3HS3vxF1yS36bX+LDLCuYk4zjgBxN0lxh3oa9Yz2BLekLZKel4
   IBWohBrUsz+CyPxguby8SUTReCXjmV+Fgy6kdULuhJK4BMETaU5r8qM5z
   i7bAsRZ5/yBn/Ja+W4oit51fwHr711jbWjpwi8NvWUmZd5/HEsRyqSfuS
   gzR+v6b9syaG7Omf4Rz8aGo4tfuXNsYpOhPkUuw/S0ylczJakaSs2eiyv
   aMIqJxYQ6geE3dLEX1wgv8es5nqVUMqncM7cDKorYBapaNEv9NIFNfccp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="347373707"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="347373707"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 05:52:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="768484681"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="768484681"
Received: from chaop.bj.intel.com (HELO localhost) ([10.240.192.105])
  by fmsmga004.fm.intel.com with ESMTP; 09 May 2023 05:51:54 -0700
Date:   Tue, 9 May 2023 20:44:28 +0800
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     Ackerley Tng <ackerleytng@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, david@redhat.com,
        pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com,
        joro@8bytes.org, mail@maciej.szmigiero.name, vbabka@suse.cz,
        vannapurve@google.com, yu.c.zhang@linux.intel.com,
        kirill.shutemov@linux.intel.com, dhildenb@redhat.com,
        qperret@google.com, tabba@google.com, michael.roth@amd.com,
        wei.w.wang@intel.com, rppt@kernel.org, liam.merwick@oracle.com,
        isaku.yamahata@gmail.com, jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hughd@google.com, brauner@kernel.org
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
Message-ID: <20230509124428.GA217130@chaop.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <ZEM5Zq8oo+xnApW9@google.com>
 <diqz8re2ftzb.fsf@ackerleytng-ctop.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <diqz8re2ftzb.fsf@ackerleytng-ctop.c.googlers.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 05, 2023 at 07:39:36PM +0000, Ackerley Tng wrote:
> 
> Hi Sean,
> 
> Thanks for implementing this POC!
> 
> I¡¯ve started porting the selftests (both Chao¡¯s and those I added [1]).

Hi Sean/Ackerley,

Thanks for doing that. Overall making gmem a KVM ioctl() looks good to
me and it should also play nice with Intel TDX. Besides what Ackerley
mentioned below, I think we haven't discussed device assignment, which
will be supported in not too long distance. Current VFIO_IOMMU_MAP_DMA
consumes virtual address so that needs to be fixed for fd-based memory
anyway, and the fix looks not related to whether this being a syscall()
or a KVM ioctl(). There will be some initialization sequence dependency,
e.g. if gmem is finally a VM-scope ioctl() then we need VM created first
before can we map fd-based memory in VFIO, but that sounds not an issue
at all.

I also see Vlastimil/David expressed their preference on ioctl. So maybe
we can move forward on your current PoC. Do you already have a plan to
post a formal version?

Chao

> 
> guest mem seems to cover the use cases that have been discussed and
> proposed so far, but I still need to figure out how gmem can work with
> 
> + hugetlbfs
> + specification of/storing memory policy (for NUMA node bindings)
> + memory accounting - we may need to account for memory used separately,
>   so that guest mem shows up separately on /proc/meminfo and similar
>   places.
> 
> One issue I¡¯ve found so far is that the pointer to kvm (gmem->kvm) is
> not cleaned up, and hence it is possible to crash the host kernel in the
> following way
> 
> 1. Create a KVM VM
> 2. Create a guest mem fd on that VM
> 3. Create a memslot with the guest mem fd (hence binding the fd to the
>    VM)
> 4. Close/destroy the KVM VM
> 5. Call fallocate(PUNCH_HOLE) on the guest mem fd, which uses gmem->kvm
>    when it tries to do invalidation.
> 
> I then tried to clean up the gmem->kvm pointer during unbinding when the
> KVM VM is destroyed.
> 
> That works, but then I realized there¡¯s a simpler way to use the pointer
> after freeing:
> 
> 1. Create a KVM VM
> 2. Create a guest mem fd on that VM
> 3. Close/destroy the KVM VM
> 4. Call fallocate(PUNCH_HOLE) on the guest mem fd, which uses gmem->kvm
>    when it tries to do invalidation.
> 
> Perhaps binding should mean setting the gmem->kvm pointer in addition to
> gmem->bindings. This makes binding and unbinding symmetric and avoids
> the use-after-frees described above.
> 
> This also means that creating a guest mem fd is no longer dependent on
> the VM. Perhaps we can make creating a gmem fd a system ioctl (like
> KVM_GET_API_VERSION and KVM_CREATE_VM) instead of a vm ioctl?
> 
> [1]
> https://lore.kernel.org/all/cover.1678926164.git.ackerleytng@google.com/T/
> 
> Ackerley
