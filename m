Return-Path: <kvm+bounces-2439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8DDE7F76D6
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 15:48:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 073821C211EF
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 14:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F532D635;
	Fri, 24 Nov 2023 14:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BLJ8TtdY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5211701
	for <kvm@vger.kernel.org>; Fri, 24 Nov 2023 06:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700837312; x=1732373312;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=mJlP42EwFBc16ghLQRRkc5r9YjcPw5oEp6hAtSa1ZHU=;
  b=BLJ8TtdYBNZ5cKPLpeSlu6ZroFSYmx0tiI2wt7eT44Pff7xLrtrLImxr
   VV7nEMKpq3rk8ZQut/02ZOQiNmxYDHG6x2EJJ70eci8Sa2FtO/P9AaUD4
   DIU9ODhwqT6+LUIQXo1VuEUhtuivyxiuHYvJOdfSjJ4nPlCnIn4VDxs/X
   fpAk/ecaXt13AXF8R2rHP0r9ybOWLWSolDgfULbInRO4LSPO5jtzpdhNT
   R+tHp6+33EvoGXmd+29Jz1IhTzUcXscSP5moLbwYHv0dK/jL6nu810i5h
   SK4cJRA6ESHkmrkbP5MZ53xRRohw/VtR3Z4VfVdDPrT/xbIRS9K3IZ+5f
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10904"; a="395249869"
X-IronPort-AV: E=Sophos;i="6.04,224,1695711600"; 
   d="scan'208";a="395249869"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2023 06:48:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10904"; a="767501974"
X-IronPort-AV: E=Sophos;i="6.04,224,1695711600"; 
   d="scan'208";a="767501974"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga002.jf.intel.com with ESMTP; 24 Nov 2023 06:48:29 -0800
Date: Fri, 24 Nov 2023 23:00:44 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Ewan Hai <ewanhai-oc@zhaoxin.com>
Cc: pbonzini@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, ewanhai@zhaoxin.com, cobechen@zhaoxin.com
Subject: Re: [PATCH] target/i386/kvm: Refine VMX controls setting for
 backward compatibility
Message-ID: <ZWC6nOF43KUghl6K@intel.com>
References: <20230925071453.14908-1-ewanhai-oc@zhaoxin.com>
 <ZTnbFJrHeKhoUA6F@intel.com>
 <eb9a08b2-a7c4-c45c-edd8-0585037194aa@zhaoxin.com>
 <a75f0b92-4894-bee9-ecbd-78b849702f61@zhaoxin.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a75f0b92-4894-bee9-ecbd-78b849702f61@zhaoxin.com>

Hi Ewan,

Look good to me. No other comments.

Regards,
Zhao

On Fri, Oct 27, 2023 at 02:08:57AM -0400, Ewan Hai wrote:
> Date: Fri, 27 Oct 2023 02:08:57 -0400
> From: Ewan Hai <ewanhai-oc@zhaoxin.com>
> Subject: Re: [PATCH] target/i386/kvm: Refine VMX controls setting for
>  backward compatibility
> 
> Hi Zhao,
> 
> since I found last email contains non-plain-text content, andkvm@vger.kernel.org
> rejected to receive my mail, so just re-send last mail here, to follow the rule of qemu
> /kvm community.
> 
> On 10/25/23 23:20, Zhao Liu wrote:
> > On Mon, Sep 25, 2023 at 03:14:53AM -0400, EwanHai wrote:
> > > Date: Mon, 25 Sep 2023 03:14:53 -0400
> > > From: EwanHai<ewanhai-oc@zhaoxin.com>
> > > Subject: [PATCH] target/i386/kvm: Refine VMX controls setting for backward
> > >   compatibility
> > > X-Mailer: git-send-email 2.34.1
> > > 
> > > Commit 4a910e1 ("target/i386: do not set unsupported VMX secondary
> > > execution controls") implemented a workaround for hosts that have
> > > specific CPUID features but do not support the corresponding VMX
> > > controls, e.g., hosts support RDSEED but do not support RDSEED-Exiting.
> > > 
> > > In detail, commit 4a910e1 introduced a flag `has_msr_vmx_procbased_clts2`.
> > > If KVM has `MSR_IA32_VMX_PROCBASED_CTLS2` in its msr list, QEMU would
> > > use KVM's settings, avoiding any modifications to this MSR.
> > > 
> > > However, this commit (4a910e1) didn’t account for cases in older Linux
> > s/didn’t/didn't/
> 
> I'll fix it.
> 
> > > kernels(e.g., linux-4.19.90) where `MSR_IA32_VMX_PROCBASED_CTLS2` is
> > For this old kernel, it's better to add the brief lifecycle note (e.g.,
> > lts, EOL) to illustrate the value of considering such compatibility
> > fixes.
> 
> I've checked the linux-stable repo, found that
> MSR_IA32_VMX_PROCBASED_CTLS2 is not included in kvm regular msr list
> until linux-5.3, and in linux-4.19.x(EOL:Dec,2024), there is also no
> MSR_IA32_VMX_PROCBASED_CTLS2 in kvm regular msr list.
> 
> So maybe this is an important compatibility fix for kernel < 5.3.
> 
> > > in `kvm_feature_msrs`—obtained by ioctl(KVM_GET_MSR_FEATURE_INDEX_LIST),
> > s/—obtained/-obtained/
> 
> I'll fix it.
> 
> > > but not in `kvm_msr_list`—obtained by ioctl(KVM_GET_MSR_INDEX_LIST).
> > s/—obtained/-obtained/
> 
> I'll fix it.
> 
> > > As a result,it did not set the `has_msr_vmx_procbased_clts2` flag based
> > > on `kvm_msr_list` alone, even though KVM maintains the value of this MSR.
> > > 
> > > This patch supplements the above logic, ensuring that
> > > `has_msr_vmx_procbased_clts2` is correctly set by checking both MSR
> > > lists, thus maintaining compatibility with older kernels.
> > > 
> > > Signed-off-by: EwanHai<ewanhai-oc@zhaoxin.com>
> > > ---
> > >   target/i386/kvm/kvm.c | 6 ++++++
> > >   1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> > > index af101fcdf6..6299284de4 100644
> > > --- a/target/i386/kvm/kvm.c
> > > +++ b/target/i386/kvm/kvm.c
> > > @@ -2343,6 +2343,7 @@ void kvm_arch_do_init_vcpu(X86CPU *cpu)
> > >   static int kvm_get_supported_feature_msrs(KVMState *s)
> > >   {
> > >       int ret = 0;
> > > +    int i;
> > >       if (kvm_feature_msrs != NULL) {
> > >           return 0;
> > > @@ -2377,6 +2378,11 @@ static int kvm_get_supported_feature_msrs(KVMState *s)
> > >           return ret;
> > >       }
> > It's worth adding a comment here to indicate that this is a
> > compatibility fix.
> > 
> > -Zhao
> > 
> > > +    for (i = 0; i < kvm_feature_msrs->nmsrs; i++) {
> > > +        if (kvm_feature_msrs->indices[i] == MSR_IA32_VMX_PROCBASED_CTLS2) {
> > > +            has_msr_vmx_procbased_ctls2 = true;
> > > +        }
> > > +    }
> > >       return 0;
> > >   }
> > > -- 
> > > 2.34.1
> > > 
> Plan to use patch bellow, any more suggestion?
> 
> >  From a3006fcec3615d98ac1eb252a61952d44aa5029b Mon Sep 17 00:00:00 2001
> > From: EwanHai<ewanhai-oc@zhaoxin.com>
> > Date: Mon, 25 Sep 2023 02:11:59 -0400
> > Subject: [PATCH] target/i386/kvm: Refine VMX controls setting for backward
> >   compatibility
> > 
> > Commit 4a910e1 ("target/i386: do not set unsupported VMX secondary
> > execution controls") implemented a workaround for hosts that have
> > specific CPUID features but do not support the corresponding VMX
> > controls, e.g., hosts support RDSEED but do not support RDSEED-Exiting.
> > 
> > In detail, commit 4a910e1 introduced a flag `has_msr_vmx_procbased_clts2`.
> > If KVM has `MSR_IA32_VMX_PROCBASED_CTLS2` in its msr list, QEMU would
> > use KVM's settings, avoiding any modifications to this MSR.
> > 
> > However, this commit (4a910e1) didn't account for cases in older Linux
> > kernels(<5.3) where `MSR_IA32_VMX_PROCBASED_CTLS2` is in
> > `kvm_feature_msrs`-obtained by ioctl(KVM_GET_MSR_FEATURE_INDEX_LIST),
> > but not in `kvm_msr_list`-obtained by ioctl(KVM_GET_MSR_INDEX_LIST).
> > As a result,it did not set the `has_msr_vmx_procbased_clts2` flag based
> > on `kvm_msr_list` alone, even though KVM maintains the value of this MSR.
> > 
> > This patch supplements the above logic, ensuring that
> > `has_msr_vmx_procbased_clts2` is correctly set by checking both MSR
> > lists, thus maintaining compatibility with older kernels.
> > 
> > Signed-off-by: EwanHai<ewanhai-oc@zhaoxin.com>
> > ---
> >   target/i386/kvm/kvm.c | 14 ++++++++++++++
> >   1 file changed, 14 insertions(+)
> > 
> > diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> > index af101fcdf6..3cf95f8579 100644
> > --- a/target/i386/kvm/kvm.c
> > +++ b/target/i386/kvm/kvm.c
> > @@ -2343,6 +2343,7 @@ void kvm_arch_do_init_vcpu(X86CPU *cpu)
> >   static int kvm_get_supported_feature_msrs(KVMState *s)
> >   {
> >       int ret = 0;
> > +    int i;
> > 
> >       if (kvm_feature_msrs != NULL) {
> >           return 0;
> > @@ -2377,6 +2378,19 @@ static int kvm_get_supported_feature_msrs(KVMState *s)
> >           return ret;
> >       }
> > 
> > +    /*
> > +     * Compatibility fix:
> > +     * Older Linux kernels(<5.3) include the MSR_IA32_VMX_PROCBASED_CTLS2
> > +     * only in feature msr list, but not in regular msr list. This lead to
> > +     * an issue in older kernel versions where QEMU, through the regular
> > +     * MSR list check, assumes the kernel doesn't maintain this msr,
> > +     * resulting in incorrect settings by QEMU for this msr.
> > +     */
> > +    for (i = 0; i < kvm_feature_msrs->nmsrs; i++) {
> > +        if (kvm_feature_msrs->indices[i] == MSR_IA32_VMX_PROCBASED_CTLS2) {
> > +            has_msr_vmx_procbased_ctls2 = true;
> > +        }
> > +    }
> >       return 0;
> >   }
> > 
> > -- 
> > 2.34.1
> 
> Best regards.
> 

