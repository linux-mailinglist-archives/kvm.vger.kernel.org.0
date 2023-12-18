Return-Path: <kvm+bounces-4729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D78988174D3
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 16:09:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7ED8D2838BE
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 15:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23DFE1D137;
	Mon, 18 Dec 2023 15:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rgRJQN9/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675503A1C0
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 15:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbce2a8d700so3220632276.1
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702912133; x=1703516933; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DFsibCzDQe/Rw1aQWfU7E5RwiUby8fkVdnpwwig3Neo=;
        b=rgRJQN9/V+Wc307v3B1NYvLRPOF5BlrsTs9E6QRfpcK3ivpr+nO4CNJcgykRkyCobb
         eUgYNCwZrKDX48PeHr4+n6CS7tM877q/a0HpF2WDKaUj9kl4BxqskL112kc89qqy1tJI
         VTdFI3n76dWxwJeT50j/UHNz7wxa0bn4fv/681/i2D2UygN8lVjPVVMBO5lU5ywxtqqd
         i+i9l/w5R0fzYu/uBPNVEnJoFnI3++mpTWv0e6N+qix+17ymBqAZMhycPnVPnVV4zNQH
         ZtFM2tGWsaa2j+Ez9NKXlXmlwfIk18Rtp533k+vdV7p9C+qFbNV9TtyTbWLMyMwbQysO
         mPGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702912133; x=1703516933;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DFsibCzDQe/Rw1aQWfU7E5RwiUby8fkVdnpwwig3Neo=;
        b=bcsPP8Sdd8TftpxrF9KAisUCCdzJiGWO4dbxVPEPvIqixm7u6tGDKIi5/PKP3cSr1L
         XY87xnA2VHlMr96sTcWmK5aZGXymsGM61ph5PEUcQzHz8UGmEAouOc5izrXvezn+pwqE
         9e/OszG7Uoss+z/1R+Z3tMr1bsuT3sVZ9qZ408QFb7z1WvX4tFM9XxKsAtpk4lc+1q00
         2HOKn2lCI9/h9o3l9yNTJ0AhqJHchBFN7d/yFOcVL5lQrl9LLgQXPBFkL2KElL2KfUSG
         CDp+ERiDC4a9eiCNM2MS1/UNVdS7kXhs6I2cxgONGjvvqxlHESCcpgl4OIV1tGFHbfqv
         3I/g==
X-Gm-Message-State: AOJu0Yx7F9oSK08IUXvTzcgarC4d2b+XB+SUkl1uZqu3hRRcQq80EX/m
	rzbikaRZUZSbEZI3FBaW7P+eoYKJLeQ=
X-Google-Smtp-Source: AGHT+IErN8oaxnfxd6s8AsjE60wGoecL/+mAArNG26vHfMWK2rkKF0GaAYihSK2tj6xiOJsmkfCGALdlXpo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:cce:0:b0:dbc:b62a:98c4 with SMTP id
 e14-20020a5b0cce000000b00dbcb62a98c4mr207688ybr.7.1702912133436; Mon, 18 Dec
 2023 07:08:53 -0800 (PST)
Date: Mon, 18 Dec 2023 07:08:51 -0800
In-Reply-To: <BN9PR11MB5276BE04CBB6D07039086D658C93A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231214103520.7198-1-yan.y.zhao@intel.com> <BN9PR11MB5276BE04CBB6D07039086D658C93A@BN9PR11MB5276.namprd11.prod.outlook.com>
Message-ID: <ZXzx1zXfZ6GV9TgI@google.com>
Subject: Re: [RFC PATCH] KVM: Introduce KVM VIRTIO device
From: Sean Christopherson <seanjc@google.com>
To: Kevin Tian <kevin.tian@intel.com>
Cc: Yan Y Zhao <yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "olvaffe@gmail.com" <olvaffe@gmail.com>, 
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Zhenyu Z Wang <zhenyu.z.wang@intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, 
	"wanpengli@tencent.com" <wanpengli@tencent.com>, "jmattson@google.com" <jmattson@google.com>, 
	"joro@8bytes.org" <joro@8bytes.org>, 
	"gurchetansingh@chromium.org" <gurchetansingh@chromium.org>, "kraxel@redhat.com" <kraxel@redhat.com>, 
	Yiwei Zhang <zzyiwei@google.com>
Content-Type: text/plain; charset="us-ascii"

+Yiwei

On Fri, Dec 15, 2023, Kevin Tian wrote:
> > From: Zhao, Yan Y <yan.y.zhao@intel.com>
> > Sent: Thursday, December 14, 2023 6:35 PM
> > 
> > - For host non-MMIO pages,
> >   * virtio guest frontend and host backend driver should be synced to use
> >     the same memory type to map a buffer. Otherwise, there will be
> >     potential problem for incorrect memory data. But this will only impact
> >     the buggy guest alone.
> >   * for live migration,
> >     as QEMU will read all guest memory during live migration, page aliasing
> >     could happen.
> >     Current thinking is to disable live migration if a virtio device has
> >     indicated its noncoherent state.
> >     As a follow-up, we can discuss other solutions. e.g.
> >     (a) switching back to coherent path before starting live migration.
> 
> both guest/host switching to coherent or host-only?
> 
> host-only certainly is problematic if guest is still using non-coherent.
> 
> on the other hand I'm not sure whether the host/guest gfx stack is
> capable of switching between coherent and non-coherent path in-fly
> when the buffer is right being rendered.
> 
> >     (b) read/write of guest memory with clflush during live migration.
> 
> write is irrelevant as it's only done in the resume path where the
> guest is not running.
> 
> > 
> > Implementation Consideration
> > ===
> > There is a previous series [1] from google to serve the same purpose to
> > let KVM be aware of virtio GPU's noncoherent DMA status. That series
> > requires a new memslot flag, and special memslots in user space.
> > 
> > We don't choose to use memslot flag to request honoring guest memory
> > type.
> 
> memslot flag has the potential to restrict the impact e.g. when using
> clflush-before-read in migration?

Yep, exactly.  E.g. if KVM needs to ensure coherency when freeing memory back to
the host kernel, then the memslot flag will allow for a much more targeted
operation.

> Of course the implication is to honor guest type only for the selected slot
> in KVM instead of applying to the entire guest memory as in previous series
> (which selects this way because vmx_get_mt_mask() is in perf-critical path
> hence not good to check memslot flag?)

Checking a memslot flag won't impact performance.  KVM already has the memslot
when creating SPTEs, e.g. the sole caller of vmx_get_mt_mask(), make_spte(), has
access to the memslot.

That isn't coincidental, KVM _must_ have the memslot to construct the SPTE, e.g.
to retrieve the associated PFN, update write-tracking for shadow pages, etc.

I added Yiwei, who I think is planning on posting another RFC for the memslot
idea (I actually completely forgot that the memslot idea had been thought of and
posted a few years back).

> > Instead we hope to make the honoring request to be explicit (not tied to a
> > memslot flag). This is because once guest memory type is honored, not only
> > memory used by guest virtio device, but all guest memory is facing page
> > aliasing issue potentially. KVM needs a generic solution to take care of
> > page aliasing issue rather than counting on memory type of a special
> > memslot being aligned in host and guest.
> > (we can discuss what a generic solution to handle page aliasing issue will
> > look like in later follow-up series).
> > 
> > On the other hand, we choose to introduce a KVM virtio device rather than
> > just provide an ioctl to wrap kvm_arch_[un]register_noncoherent_dma()
> > directly, which is based on considerations that
> 
> I wonder it's over-engineered for the purpose.
> 
> why not just introducing a KVM_CAP and allowing the VMM to enable?
> KVM doesn't need to know the exact source of requiring it...

Agreed.  If we end up needing to grant the whole VM access for some reason, just
give userspace a direct toggle.

