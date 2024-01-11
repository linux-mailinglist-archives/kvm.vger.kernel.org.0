Return-Path: <kvm+bounces-6100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 83D2582B2E0
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 17:25:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E3D61F257F0
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 16:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BAE4F8A1;
	Thu, 11 Jan 2024 16:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e7eo2TNw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC878487BF
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 16:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cf2714e392so1247016a12.0
        for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 08:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704990303; x=1705595103; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7vbyXBr3P0E9528YW5LLlUgtQst+bQffN0BGFft0l8=;
        b=e7eo2TNwKpO/4ggF4GL2qCh2VuucIDO+uwbwyI4dsSGiGywoNdgYn5QiRgQ82f518U
         GvKh5tCx9+tnpJ1kmaqryP84bI846lYu8j4Lc8UngfIEEKBs0BK98N2y1J2Eo0f891zN
         x3hNS+wKL0iVCCHJA71MZQJHaFqH7KMFFfKqkin6f2UxbNURWzJOLxya6LRzgIlc7BXK
         l6UYlG39Wf7xK8Yy8soVXqLviv6HvdXcMTJk9K0QGzuet73xz17Obt8uedq1NSgM5T6b
         PzsE3SmUx+LQcUm6nFwR882TXvUKVvOhOzymdr5Z8luo9r56RfG2YugCn6PgE4ZQyGhS
         QFig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704990303; x=1705595103;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7vbyXBr3P0E9528YW5LLlUgtQst+bQffN0BGFft0l8=;
        b=ac5K3Ot9W0ekWXjozoMdAQJtFc3XzcZwskZ++jsLzYSBYbjyNHS1WlWzcwOI2LvSs5
         lDVJeDimjIji+ADyXQXYIe6N8swZ5POorurypvLjYppJRkLzMNWxYnDtmDxaV1Kzcepe
         M08llH5S8lKGIGQPKcugaieSztOaOw4cZuVNclOmnFIlesQDEyRDF74KfImp0UOAIzFG
         KLG53ll5Pq3IUn/Xdz0xwNKtt3/KJA4FWpfKv+vWDbZ13A1wBoKwbvSi7l6pzl+Zi+J8
         opRbGdOJKKHvNuec1wXQloT5dQCvnyz/Fa2hNseDZ7uY4/kXxq2JQT1kS3Y5uXWhrKO9
         FzOQ==
X-Gm-Message-State: AOJu0YzJaweZPD02qs2pTNof44POKR9YH1+mIsGeTlUMJxLZ56rwZMzY
	8ffEDBlv3Md9QEZ9lgMKrpjDszSlvVvM01v5Fg==
X-Google-Smtp-Source: AGHT+IHWrP9S3u1zxFmOqD1cNfHQ/2dd0lwBop3h+FWQZKNgm3pdcQrx0pMDzQTd+wPGu0bJwYj4qviImnU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:234f:b0:1d5:6a32:66f with SMTP id
 c15-20020a170903234f00b001d56a32066fmr188plh.4.1704990302913; Thu, 11 Jan
 2024 08:25:02 -0800 (PST)
Date: Thu, 11 Jan 2024 08:25:01 -0800
In-Reply-To: <ZZ9X5anB/HGS8JR6@linux.bj.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110002340.485595-1-seanjc@google.com> <ZZ42Vs3uAPwBmezn@chao-email>
 <ZZ7FMWuTHOV-_Gn7@google.com> <ZZ9X5anB/HGS8JR6@linux.bj.intel.com>
Message-ID: <ZaAWXSvMgIMkxr50@google.com>
Subject: Re: [PATCH] x86/cpu: Add a VMX flag to enumerate 5-level EPT support
 to userspace
From: Sean Christopherson <seanjc@google.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yi Lai <yi1.lai@intel.com>, 
	Xudong Hao <xudong.hao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 11, 2024, Tao Su wrote:
> On Wed, Jan 10, 2024 at 08:26:25AM -0800, Sean Christopherson wrote:
> > On Wed, Jan 10, 2024, Chao Gao wrote:
> > > On Tue, Jan 09, 2024 at 04:23:40PM -0800, Sean Christopherson wrote:
> > > >Add a VMX flag in /proc/cpuinfo, ept_5level, so that userspace can query
> > > >whether or not the CPU supports 5-level EPT paging.  EPT capabilities are
> > > >enumerated via MSR, i.e. aren't accessible to userspace without help from
> > > >the kernel, and knowing whether or not 5-level EPT is supported is sadly
> > > >necessary for userspace to correctly configure KVM VMs.
> > > 
> > > This assumes procfs is enabled in Kconfig and userspace has permission to
> > > access /proc/cpuinfo. But it isn't always true. So, I think it is better to
> > > advertise max addressable GPA via KVM ioctls.
> > 
> > Hrm, so the help for PROC_FS says:
> > 
> >   Several programs depend on this, so everyone should say Y here.
> > 
> > Given that this is working around something that is borderline an erratum, I'm
> > inclined to say that userspace shouldn't simply assume the worst if /proc isn't
> > available.  Practically speaking, I don't think a "real" VM is likely to be
> > affected; AFAIK, there's no reason for QEMU or any other VMM to _need_ to expose
> > a memslot at GPA[51:48] unless the VM really has however much memory that is
> > (hundreds of terabytes?).  And a if someone is trying to run such a massive VM on
> > such a goofy CPU...
> 
> It is unusual to assign a huge RAM to guest, but passthrough a device also may trigger
> this issue which we have met, i.e. alloc memslot for the 64bit BAR which can set
> bits[51:48]. BIOS can control the BAR address, e.g. seabios moved 64bit pci window
> to end of address space by using advertised physical bits[1].

Drat.  Do you know if these CPUs are going to be productized?  We'll still need
something in KVM either way, but whether or not the problems are more or less
limited to funky software setups might influence how we address this.

