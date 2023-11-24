Return-Path: <kvm+bounces-2440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 189CE7F76DF
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 15:50:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 975551F20613
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 14:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58FF82D632;
	Fri, 24 Nov 2023 14:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fCLFbn2U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661F710CA
	for <kvm@vger.kernel.org>; Fri, 24 Nov 2023 06:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700837445; x=1732373445;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=0OCYNxHgTBVdKxjcL9mTeare1C4AZThgMhDrViuacmM=;
  b=fCLFbn2U+m4V+O3DwgQv/XNwv/l9EAd31o2o8mNPe2SQYqWtF9tmLadb
   uf84deLfZS4ZvC3RbCaq/+GaUHGReU6wFDWlS9Mh46bcG3TKegEvj0zCf
   RbGp43l1blhT2NAAuv2yn1vpD56RCE0RK+3u55qTNXGJ2jc0N8pq1oHRj
   2d2ESeaBO1VfusunEsBzsDWdc07GDnpeEkxk9119RctSLNgoIhwV5BY0D
   8boyVdXKgXvp8+X1taPaXH7ZfjT2s1Tpp3+Kx/rUG+JvruVquPnXxj1zd
   DCEAa9hFXqp4ZBIzOXS5xWdoOI1nyNYCo+iYVglJiHtGSlItwwuc18HZc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10904"; a="456778078"
X-IronPort-AV: E=Sophos;i="6.04,224,1695711600"; 
   d="scan'208";a="456778078"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2023 06:50:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10904"; a="940942849"
X-IronPort-AV: E=Sophos;i="6.04,224,1695711600"; 
   d="scan'208";a="940942849"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 24 Nov 2023 06:50:30 -0800
Date: Fri, 24 Nov 2023 23:02:45 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Ewan Hai <ewanhai-oc@zhaoxin.com>
Cc: pbonzini@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, ewanhai@zhaoxin.com, cobechen@zhaoxin.com
Subject: Re: PING: VMX controls setting patch for backward compatibility
Message-ID: <ZWC7FSY8ilN1SdoV@intel.com>
References: <20230925071453.14908-1-ewanhai-oc@zhaoxin.com>
 <ZTnbFJrHeKhoUA6F@intel.com>
 <eb9a08b2-a7c4-c45c-edd8-0585037194aa@zhaoxin.com>
 <a75f0b92-4894-bee9-ecbd-78b849702f61@zhaoxin.com>
 <0dbf5f15-8165-420e-ae0e-5d7aac7053ff@zhaoxin.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0dbf5f15-8165-420e-ae0e-5d7aac7053ff@zhaoxin.com>

Hi Ewan,

On Thu, Nov 23, 2023 at 10:01:42PM -0500, Ewan Hai wrote:
> Date: Thu, 23 Nov 2023 22:01:42 -0500
> From: Ewan Hai <ewanhai-oc@zhaoxin.com>
> Subject: PING: VMX controls setting patch for backward compatibility
> 
> Hi Zhao Liu and QEMU/KVM Community,
> 
> I hope this email finds you well. I am writing to follow up on the
> conversation we had a month ago regarding my patch submission for
> refining the VMX controls setting for backward compatibility on
> QEMU-KVM.
> 
> On October 27, I responded to the feedback and suggestions provided
> by Zhao Liu, making necessary corrections and improvements to the
> patch. However, since then, I haven't received any further responses
> or reviews.
> 
> I understand that everyone is busy, and I appreciate the time and
> effort that goes into reviewing these submissions. I just wanted to
> check if there are any updates, additional feedback, or steps I should
> take next. I am more than willing to make further changes if needed.
> 
> Please let me know if there is anything else required from my side for
> this patch to move forward. Thank you for your time and attention. I
> look forward to hearing from you.

I think you could refresh a new version and wait for more reviews.

Regards,
Zhao

> 
> Best regards,
> Ewan Hai
> 
> On 10/27/23 02:08, Ewan Hai wrote:
> > Hi Zhao,
> > 
> > since I found last email contains non-plain-text content,
> > andkvm@vger.kernel.org
> > rejected to receive my mail, so just re-send last mail here, to follow
> > the rule of qemu
> > /kvm community.
> > 
> > On 10/25/23 23:20, Zhao Liu wrote:
> > > On Mon, Sep 25, 2023 at 03:14:53AM -0400, EwanHai wrote:
> > > > Date: Mon, 25 Sep 2023 03:14:53 -0400
> > > > From: EwanHai<ewanhai-oc@zhaoxin.com>
> > > > Subject: [PATCH] target/i386/kvm: Refine VMX controls setting
> > > > for backward
> > > >   compatibility
> > > > X-Mailer: git-send-email 2.34.1
> > > > 
> > > > Commit 4a910e1 ("target/i386: do not set unsupported VMX secondary
> > > > execution controls") implemented a workaround for hosts that have
> > > > specific CPUID features but do not support the corresponding VMX
> > > > controls, e.g., hosts support RDSEED but do not support RDSEED-Exiting.
> > > > 
> > > > In detail, commit 4a910e1 introduced a flag
> > > > `has_msr_vmx_procbased_clts2`.
> > > > If KVM has `MSR_IA32_VMX_PROCBASED_CTLS2` in its msr list, QEMU would
> > > > use KVM's settings, avoiding any modifications to this MSR.
> > > > 
> > > > However, this commit (4a910e1) didn’t account for cases in older Linux
> > > s/didn’t/didn't/
> > 
> > I'll fix it.
> > 
> > > > kernels(e.g., linux-4.19.90) where `MSR_IA32_VMX_PROCBASED_CTLS2` is
> > > For this old kernel, it's better to add the brief lifecycle note (e.g.,
> > > lts, EOL) to illustrate the value of considering such compatibility
> > > fixes.
> > 
> > I've checked the linux-stable repo, found that
> > MSR_IA32_VMX_PROCBASED_CTLS2 is not included in kvm regular msr list
> > until linux-5.3, and in linux-4.19.x(EOL:Dec,2024), there is also no
> > MSR_IA32_VMX_PROCBASED_CTLS2 in kvm regular msr list.
> > 
> > So maybe this is an important compatibility fix for kernel < 5.3.
> > 
> > > > in `kvm_feature_msrs`—obtained by
> > > > ioctl(KVM_GET_MSR_FEATURE_INDEX_LIST),
> > > s/—obtained/-obtained/
> > 
> > I'll fix it.
> > 
> > > > but not in `kvm_msr_list`—obtained by ioctl(KVM_GET_MSR_INDEX_LIST).
> > > s/—obtained/-obtained/
> > 
> > I'll fix it.
> > 
> > > > As a result,it did not set the `has_msr_vmx_procbased_clts2` flag based
> > > > on `kvm_msr_list` alone, even though KVM maintains the value of
> > > > this MSR.
> > > > 
> > > > This patch supplements the above logic, ensuring that
> > > > `has_msr_vmx_procbased_clts2` is correctly set by checking both MSR
> > > > lists, thus maintaining compatibility with older kernels.
> > > > 
> > > > Signed-off-by: EwanHai<ewanhai-oc@zhaoxin.com>
> > > > ---
> > > >   target/i386/kvm/kvm.c | 6 ++++++
> > > >   1 file changed, 6 insertions(+)
> > > > 
> > > > diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> > > > index af101fcdf6..6299284de4 100644
> > > > --- a/target/i386/kvm/kvm.c
> > > > +++ b/target/i386/kvm/kvm.c
> > > > @@ -2343,6 +2343,7 @@ void kvm_arch_do_init_vcpu(X86CPU *cpu)
> > > >   static int kvm_get_supported_feature_msrs(KVMState *s)
> > > >   {
> > > >       int ret = 0;
> > > > +    int i;
> > > >         if (kvm_feature_msrs != NULL) {
> > > >           return 0;
> > > > @@ -2377,6 +2378,11 @@ static int
> > > > kvm_get_supported_feature_msrs(KVMState *s)
> > > >           return ret;
> > > >       }
> > > It's worth adding a comment here to indicate that this is a
> > > compatibility fix.
> > > 
> > > -Zhao
> > > 
> > > >   +    for (i = 0; i < kvm_feature_msrs->nmsrs; i++) {
> > > > +        if (kvm_feature_msrs->indices[i] ==
> > > > MSR_IA32_VMX_PROCBASED_CTLS2) {
> > > > +            has_msr_vmx_procbased_ctls2 = true;
> > > > +        }
> > > > +    }
> > > >       return 0;
> > > >   }
> > > >   --
> > > > 2.34.1
> > > > 
> > Plan to use patch bellow, any more suggestion?
> > 
> > >  From a3006fcec3615d98ac1eb252a61952d44aa5029b Mon Sep 17 00:00:00 2001
> > > From: EwanHai<ewanhai-oc@zhaoxin.com>
> > > Date: Mon, 25 Sep 2023 02:11:59 -0400
> > > Subject: [PATCH] target/i386/kvm: Refine VMX controls setting for
> > > backward
> > >   compatibility
> > > 
> > > Commit 4a910e1 ("target/i386: do not set unsupported VMX secondary
> > > execution controls") implemented a workaround for hosts that have
> > > specific CPUID features but do not support the corresponding VMX
> > > controls, e.g., hosts support RDSEED but do not support RDSEED-Exiting.
> > > 
> > > In detail, commit 4a910e1 introduced a flag
> > > `has_msr_vmx_procbased_clts2`.
> > > If KVM has `MSR_IA32_VMX_PROCBASED_CTLS2` in its msr list, QEMU would
> > > use KVM's settings, avoiding any modifications to this MSR.
> > > 
> > > However, this commit (4a910e1) didn't account for cases in older Linux
> > > kernels(<5.3) where `MSR_IA32_VMX_PROCBASED_CTLS2` is in
> > > `kvm_feature_msrs`-obtained by ioctl(KVM_GET_MSR_FEATURE_INDEX_LIST),
> > > but not in `kvm_msr_list`-obtained by ioctl(KVM_GET_MSR_INDEX_LIST).
> > > As a result,it did not set the `has_msr_vmx_procbased_clts2` flag based
> > > on `kvm_msr_list` alone, even though KVM maintains the value of this
> > > MSR.
> > > 
> > > This patch supplements the above logic, ensuring that
> > > `has_msr_vmx_procbased_clts2` is correctly set by checking both MSR
> > > lists, thus maintaining compatibility with older kernels.
> > > 
> > > Signed-off-by: EwanHai<ewanhai-oc@zhaoxin.com>
> > > ---
> > >   target/i386/kvm/kvm.c | 14 ++++++++++++++
> > >   1 file changed, 14 insertions(+)
> > > 
> > > diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> > > index af101fcdf6..3cf95f8579 100644
> > > --- a/target/i386/kvm/kvm.c
> > > +++ b/target/i386/kvm/kvm.c
> > > @@ -2343,6 +2343,7 @@ void kvm_arch_do_init_vcpu(X86CPU *cpu)
> > >   static int kvm_get_supported_feature_msrs(KVMState *s)
> > >   {
> > >       int ret = 0;
> > > +    int i;
> > > 
> > >       if (kvm_feature_msrs != NULL) {
> > >           return 0;
> > > @@ -2377,6 +2378,19 @@ static int
> > > kvm_get_supported_feature_msrs(KVMState *s)
> > >           return ret;
> > >       }
> > > 
> > > +    /*
> > > +     * Compatibility fix:
> > > +     * Older Linux kernels(<5.3) include the
> > > MSR_IA32_VMX_PROCBASED_CTLS2
> > > +     * only in feature msr list, but not in regular msr list. This
> > > lead to
> > > +     * an issue in older kernel versions where QEMU, through the
> > > regular
> > > +     * MSR list check, assumes the kernel doesn't maintain this msr,
> > > +     * resulting in incorrect settings by QEMU for this msr.
> > > +     */
> > > +    for (i = 0; i < kvm_feature_msrs->nmsrs; i++) {
> > > +        if (kvm_feature_msrs->indices[i] ==
> > > MSR_IA32_VMX_PROCBASED_CTLS2) {
> > > +            has_msr_vmx_procbased_ctls2 = true;
> > > +        }
> > > +    }
> > >       return 0;
> > >   }
> > > 
> > > -- 
> > > 2.34.1
> > 
> > Best regards.
> > 

