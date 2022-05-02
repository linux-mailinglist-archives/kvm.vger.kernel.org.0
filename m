Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CADDC516E08
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 12:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384455AbiEBKWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 06:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353808AbiEBKWF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 06:22:05 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32541DAF;
        Mon,  2 May 2022 03:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651486717; x=1683022717;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=40XRCuFqf9DIEV+ADubSNbv+BNliWy79WqN9dEr7Q54=;
  b=T0iqA0HszQjAM3PuFVifm/49z2WoLpHr7EEvjOXntxE0i7f6rgrBTuKe
   Ivs6pWyF/G+B0/N4Ltt8L9RaqLkE4cu7jcGZvhtI7SDgU3OCVtShDpyVt
   DLQOhuem2mRkfgtxXzOpvhGVcxznjGdQu/TUOuKGolKCcapCHxiSh76fF
   efNRuBdQnChRl7044R6n7Yz7zCBjqf0XS6PjvZ05S/naaGjUviLNITgZV
   pp4Xs4THNW2NGwOweanDRczX1uVk7QvTjmeNP8AsSXoPyaGd5g3jMm9hK
   D2C0ZkQ5zFhsaOBHvmJ2RJeXsWRTrgmkAjt0HHZ3rTnYqgDaV15M3AJ1c
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10334"; a="292352828"
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="292352828"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 03:18:36 -0700
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="733376340"
Received: from bwu50-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.2.219])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 03:18:33 -0700
Message-ID: <c393153f821d84d6c3745d76dd3f43a3ce3fc0a1.camel@intel.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        chao.p.peng@intel.com
Date:   Mon, 02 May 2022 22:18:30 +1200
In-Reply-To: <4d0c7316-3564-ef27-1113-042019d583dc@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
         <CAPcyv4g5E_TOow=3pFJXyFr=KLV9pTSnDthgz6TuXvru4xDzaQ@mail.gmail.com>
         <de9b8f4cef5da03226158492988956099199aa60.camel@intel.com>
         <CAPcyv4iGsXkHAVgf+JZ4Pah_fkCZ=VvUmj7s3C6Rkejtdw_sgQ@mail.gmail.com>
         <92af7b22-fa8a-5d42-ae15-8526abfd2622@intel.com>
         <CAPcyv4iG977DErCfYTqhVzuZqjtqFHK3smnaOpO3p+EbxfvXcQ@mail.gmail.com>
         <4a5143cc-3102-5e30-08b4-c07e44f1a2fc@intel.com>
         <CAPcyv4i6X6ODNbOnT7+NEzpicLS4m9bNDybZLvN3gqXFTTf=mg@mail.gmail.com>
         <4d0c7316-3564-ef27-1113-042019d583dc@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-04-29 at 11:34 -0700, Dave Hansen wrote:
> On 4/29/22 10:48, Dan Williams wrote:
> > > But, neither of those really help with, say, a device-DAX mapping of
> > > TDX-*IN*capable memory handed to KVM.  The "new syscall" would just
> > > throw up its hands and leave users with the same result: TDX can't be
> > > used.  The new sysfs ABI for NUMA nodes wouldn't clearly apply to
> > > device-DAX because they don't respect the NUMA policy ABI.
> > They do have "target_node" attributes to associate node specific
> > metadata, and could certainly express target_node capabilities in its
> > own ABI. Then it's just a matter of making pfn_to_nid() do the right
> > thing so KVM kernel side can validate the capabilities of all inbound
> > pfns.
> 
> Let's walk through how this would work with today's kernel on tomorrow's
> hardware, without KVM validating PFNs:
> 
> 1. daxaddr mmap("/dev/dax1234")
> 2. kvmfd = open("/dev/kvm")
> 3. ioctl(KVM_SET_USER_MEMORY_REGION, { daxaddr };
> 4. guest starts running
> 5. guest touches 'daxaddr'
> 6. Page fault handler maps 'daxaddr'
> 7. KVM finds new 'daxaddr' PTE
> 8. TDX code tries to add physical address to Secure-EPT
> 9. TDX "SEAMCALL" fails because page is not convertible
> 10. Guest dies
> 
> All we can do to improve on that is call something that pledges to only
> map convertible memory at 'daxaddr'.  We can't *actually* validate the
> physical addresses at mmap() time or even
> KVM_SET_USER_MEMORY_REGION-time because the memory might not have been
> allocated.
> 
> Those pledges are hard for anonymous memory though.  To fulfill the
> pledge, we not only have to validate that the NUMA policy is compatible
> at KVM_SET_USER_MEMORY_REGION, we also need to decline changes to the
> policy that might undermine the pledge.

Hi Dave,

There's another series done by Chao "KVM: mm: fd-based approach for supporting
KVM guest private memory" which essentially allows KVM to ask guest memory
backend to allocate page w/o having to mmap() to userspace.  Please see my reply
below:

https://lore.kernel.org/lkml/cover.1649219184.git.kai.huang@intel.com/T/#mf9bf10a63eaaf0968c46ab33bdaf06bd2cfdd948

My understanding is for TDX guest KVM will be enforced to use the new mechanism.
So when TDX supports NVDIMM in the future, dax can be extended to support the
new mechanism to support using it as TD guest backend.

Sean, Paolo, Isaku, Chao,

Please correct me if I am wrong?

-- 
Thanks,
-Kai


