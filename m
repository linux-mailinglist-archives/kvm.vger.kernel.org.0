Return-Path: <kvm+bounces-5747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C4F825B96
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 21:26:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9C7A2819DB
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 20:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA09F360A4;
	Fri,  5 Jan 2024 20:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WT1wnQAx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBA636090
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 20:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6d9b050e9a8so2242847b3a.1
        for <kvm@vger.kernel.org>; Fri, 05 Jan 2024 12:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704486370; x=1705091170; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CDuyIdb5G2yRxM3J1zcMQj66a8MGMrU6P63IWP3qvHc=;
        b=WT1wnQAxHtDuAzZtDwgve/L2BLnQ1Y4nI4khNSHt13PXlahtf8qSR6M2cC01NJQ0S1
         n6INwJRTxQslyZOmXyQQqvG+ewRkjU7U5LZP7xrUregXdlSgGZoM4mIQ26E+csV5U/+J
         RqHhSuJI5Z9io2a/4XFvMMr8McFGhreKeIlbBpZayBBu5YmUGvfCdSFWHSYw+bcFqR14
         yHSiX6abtMFafzj5Hqbz1K8EfIGe326VK57JO1bah/pAMt/J3FDoXDYY24DTonF0lte2
         saULhChZT+zk1aVygQjWjjfPXq6SiZmuocITfsnFCKmddPWWPRNmXE0V4bMmy1VPenit
         ULHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704486370; x=1705091170;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CDuyIdb5G2yRxM3J1zcMQj66a8MGMrU6P63IWP3qvHc=;
        b=TsBCi+zteXQFrl25bBIK69sbKC7IZX5z/OfCZx6IVmLPnJ0BzclGoL3iGlDkwaUDbj
         /i7XaFjnyilHxmT/j+6gZV8mSJLJ9vdixwrD71hYKrtabq8/lZ7gKgpT6R1OVIGjWcHF
         +Zvx9vEsd9Nhqh1rXoGh2aTmhs/YJ7YxArN0aR51IeCocP5mOabpRsTGFh7YwQmbllyn
         5jRPZFovbw11go5mCChOEOLjnqphd5GtoH6+TYIQiEqm8zjnkGCl+X3hHySrIs0cRrck
         eVUmEZLesVLH2VjyjGgNA3wrxfuLIGxknCtGbA/eyWK8ag1yCBiwu/pnZ+jufMOLZvAU
         uN3w==
X-Gm-Message-State: AOJu0YzIvY9Pw0NnydNwJ2bO6U1xZIERHDddHnAL1yWiflLmZPkcpikg
	xSST68W+VJnUUTudLxbpWbqb3paR2uflUQRNRg==
X-Google-Smtp-Source: AGHT+IGw2dHzFH/4iRH6EAFJmNj8lhfUuPF0TZY7IOd7uV2vpJmHj6OJwiwM8h5C0LEVqONAQPF86pVorLo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a11:b0:6d2:65c4:a441 with SMTP id
 p17-20020a056a000a1100b006d265c4a441mr384058pfh.3.1704486369718; Fri, 05 Jan
 2024 12:26:09 -0800 (PST)
Date: Fri, 5 Jan 2024 12:26:08 -0800
In-Reply-To: <CALMp9eTf=9VqM=xutOXmgRr+aFz-YhOz6h4B+uLgtFBXtHefPA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218140543.870234-2-tao1.su@linux.intel.com>
 <ZYMWFhVQ7dCjYegQ@google.com> <ZYP0/nK/WJgzO1yP@yilunxu-OptiPlex-7050>
 <ZZSbLUGNNBDjDRMB@google.com> <CALMp9eTutnTxCjQjs-nxP=XC345vTmJJODr+PcSOeaQpBW0Skw@mail.gmail.com>
 <ZZWhuW_hfpwAAgzX@google.com> <ZZYbzzDxPI8gjPu8@chao-email>
 <CALMp9eSg6No9L40kmo7n9BGOz4v1ThA7-e4gD4sgj3KGBJEUzA@mail.gmail.com>
 <ZZbJxgyYoEJy+bAj@chao-email> <CALMp9eTf=9VqM=xutOXmgRr+aFz-YhOz6h4B+uLgtFBXtHefPA@mail.gmail.com>
Message-ID: <ZZhl4FHcdrzMXoVy@google.com>
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Chao Gao <chao.gao@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Tao Su <tao1.su@linux.intel.com>, kvm@vger.kernel.org, pbonzini@redhat.com, 
	eddie.dong@intel.com, xiaoyao.li@intel.com, yuan.yao@linux.intel.com, 
	yi1.lai@intel.com, xudong.hao@intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 04, 2024, Jim Mattson wrote:
> On Thu, Jan 4, 2024 at 7:08=E2=80=AFAM Chao Gao <chao.gao@intel.com> wrot=
e:
> >
> > On Wed, Jan 03, 2024 at 07:40:02PM -0800, Jim Mattson wrote:
> > >On Wed, Jan 3, 2024 at 6:45=E2=80=AFPM Chao Gao <chao.gao@intel.com> w=
rote:
> > >>
> > >> On Wed, Jan 03, 2024 at 10:04:41AM -0800, Sean Christopherson wrote:
> > >> >On Tue, Jan 02, 2024, Jim Mattson wrote:
> > >> >> This is all just so broken and wrong. The only guest.MAXPHYADDR t=
hat
> > >> >> can be supported under TDP is the host.MAXPHYADDR. If KVM claims =
to
> > >> >> support a smaller guest.MAXPHYADDR, then KVM is obligated to inte=
rcept
> > >> >> every #PF,
> > >>
> > >> in this case (i.e., to support 48-bit guest.MAXPHYADDR when CPU supp=
orts only
> > >> 4-level EPT), KVM has no need to intercept #PF because accessing a G=
PA with
> > >> RSVD bits 51-48 set leads to EPT violation.
> > >
> > >At the completion of the page table walk, if there is a permission
> > >fault, the data address should not be accessed, so there should not be
> > >an EPT violation. Remember Meltdown?
> >
> > You are right. I missed this case. KVM needs to intercept #PF to set RS=
VD bit
> > in PFEC.
>=20
> I have no problem with a user deliberately choosing an unsupported
> configuration, but I do have a problem with KVM_GET_SUPPORTED_CPUID
> returning an unsupported configuration.

+1

Advertising guest.MAXPHYADDR < host.MAXPHYADDR in KVM_GET_SUPPORTED_CPUID s=
imply
isn't viable when TDP is enabled.  I suppose KVM do so when allow_smaller_m=
axphyaddr
is enabled, but that's just asking for confusion, e.g. if userspace reflect=
s the
CPUID back into the guest, it could unknowingly create a VM that depends on
allow_smaller_maxphyaddr.

I think the least awful option is to have the kernel expose whether or not =
the
CPU support 5-level EPT to userspace.  That doesn't even require new uAPI p=
er se,
just a new flag in /proc/cpuinfo.  It'll be a bit gross for userspace to pa=
rse,
but it's not the end of the world.  Alternatively, KVM could add a capabili=
ty to
enumerate the max *addressable* GPA, but userspace would still need to manu=
ally
take action when KVM can't address all of memory, i.e. a capability would b=
e less
ugly, but wouldn't meaningfully change userspace's responsibilities.

I.e.

diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxf=
eatures.h
index c6a7eed03914..266daf5b5b84 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -25,6 +25,7 @@
 #define VMX_FEATURE_EPT_EXECUTE_ONLY   ( 0*32+ 17) /* "ept_x_only" EPT ent=
ries can be execute only */
 #define VMX_FEATURE_EPT_AD             ( 0*32+ 18) /* EPT Accessed/Dirty b=
its */
 #define VMX_FEATURE_EPT_1GB            ( 0*32+ 19) /* 1GB EPT pages */
+#define VMX_FEATURE_EPT_5LEVEL         ( 0*32+ 20) /* 5-level EPT paging *=
/
=20
 /* Aggregated APIC features 24-27 */
 #define VMX_FEATURE_FLEXPRIORITY       ( 0*32+ 24) /* TPR shadow + virt AP=
IC */
diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.=
c
index 03851240c3e3..1640ae76548f 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -72,6 +72,8 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
                c->vmx_capability[MISC_FEATURES] |=3D VMX_F(EPT_AD);
        if (ept & VMX_EPT_1GB_PAGE_BIT)
                c->vmx_capability[MISC_FEATURES] |=3D VMX_F(EPT_1GB);
+       if (ept & VMX_EPT_PAGE_WALK_5_BIT)
+               c->vmx_capability[MISC_FEATURES] |=3D VMX_F(EPT_5LEVEL);
=20
        /* Synthetic APIC features that are aggregates of multiple features=
. */
        if ((c->vmx_capability[PRIMARY_CTLS] & VMX_F(VIRTUAL_TPR)) &&


