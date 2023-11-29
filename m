Return-Path: <kvm+bounces-2787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DF617FDF53
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 19:31:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDFA01C20A7E
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 18:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 787C85D48B;
	Wed, 29 Nov 2023 18:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aZjQIFaA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988CFE6
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 10:31:05 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5d1b431fa7bso1079527b3.1
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 10:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701282665; x=1701887465; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c1rLIdwfJP37garEzWHrWFHBXDQvp3tQ1Ff7Pa+0bvQ=;
        b=aZjQIFaAz+hL1UECI9sA960h4RGvBRpm7txjmGuxFqlLTwg78W0ITMv5GDXYR0NHIl
         1NTgmovmjliqaJdwmiwqB+xIU7Ucs8VGir/rMvbZIoBMZMVNIBDOTOBh40qFzlid6QA6
         TzVGDnjVnIHUVNKwnLb5JVODBA3MakyGifaEYMRbsXLtTU94xCUroLbhieBeb5gwsg9f
         BL2JLzZwf62ib7XRezkypErwhfoDY9DHpzyxtf+v+R4HH0p+On8dBn1F3NuKGHRvTyiM
         sxpNxTjSLposoh7llk9ylW4+KTGJg2/Yrf8rsaNRDGgukzQqx5wfzsQkbGsnYiw9dpqy
         4lOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701282665; x=1701887465;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c1rLIdwfJP37garEzWHrWFHBXDQvp3tQ1Ff7Pa+0bvQ=;
        b=i/tdxALoIPDlp6XTx+2nG7QaCfxSxI1ii3wYri/bVoi3bwyAI3sL1xY4SMpy75ZFK9
         Z29rYYjs/N9yHkUXDCkqhmGPTx9Gb2N2YIw71cjzzZmjNVViRgwZPEOFMExwKCddBQnA
         FLMrbSvoYVEFzpdA+YfHyyYKoOYHx6PBNK7vi+MuO9Q5JkTdUpoRq7Z8JBMWL0rRWSWF
         T7zGnTXzhimt/ZlanP11HyFFydjyI7VhB1Mr82G1O70EO7HXcaSHOMKfwMs3NDbs+SHt
         nI2Si35WDxIEa9VE6ciC2ug3p7xvLAfgIRMoKCto8kH4OVHsLmW9n2A/vCB9MO85KqMN
         p3eg==
X-Gm-Message-State: AOJu0YwgS3LHtVCBLGL26CER4ovPXdmKBMLNbRh7K5CDzbJwwHwEHCFF
	dUwHRYp0IjOFd3wEma6tgNdd1cm189g=
X-Google-Smtp-Source: AGHT+IHxpKv+Onni3jsljSwKzH8uXIhuxnoTBESUxuFhb+PRCSSwYQqIrFh/Htrp8TEW9pXbXT6mJDicqaY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:480d:b0:5ce:a88:8436 with SMTP id
 hc13-20020a05690c480d00b005ce0a888436mr522497ywb.10.1701282664859; Wed, 29
 Nov 2023 10:31:04 -0800 (PST)
Date: Wed, 29 Nov 2023 10:31:03 -0800
In-Reply-To: <20231129124821.GU436702@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <0-v1-08396538817d+13c5-vfio_kvm_kconfig_jgg@nvidia.com>
 <87edgy87ig.fsf@mail.lhotse> <ZWagNsu1XQIqk5z9@google.com> <20231129124821.GU436702@nvidia.com>
Message-ID: <ZWeDZ76VkRMbHEGl@google.com>
Subject: Re: Ping? Re: [PATCH rc] kvm: Prevent compiling virt/kvm/vfio.c
 unless VFIO is selected
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@redhat.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, James Morse <james.morse@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	Marc Zyngier <maz@kernel.org>, Ingo Molnar <mingo@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>, 
	x86@kernel.org, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 29, 2023, Jason Gunthorpe wrote:
> On Tue, Nov 28, 2023 at 06:21:42PM -0800, Sean Christopherson wrote:
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index 454e9295970c..a65b2513f8cd 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -289,16 +289,12 @@ void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
> >  /*
> >   * External user API
> >   */
> > -#if IS_ENABLED(CONFIG_VFIO_GROUP)
> >  struct iommu_group *vfio_file_iommu_group(struct file *file);
> > +
> > +#if IS_ENABLED(CONFIG_VFIO_GROUP)
> >  bool vfio_file_is_group(struct file *file);
> >  bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
> >  #else
> > -static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
> > -{
> > -       return NULL;
> > -}
> > -
> >  static inline bool vfio_file_is_group(struct file *file)
> >  {
> >         return false;
> > 
> 
> So you symbol get on a symbol that can never be defined? Still says to
> me the kconfig needs fixing :|

Yeah, I completely agree, and if KVM didn't already rely on this horrific
behavior and there wasn't a more complete overhaul in-flight, I wouldn't suggest
this.

I'll send the KVM Kconfig/Makefile cleanups from my "Hide KVM internals from others"
series separately (which is still the bulk of the series) so as to prioritize
getting the cleanups landed.

