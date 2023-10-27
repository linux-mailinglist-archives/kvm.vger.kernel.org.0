Return-Path: <kvm+bounces-7-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 068287DA3FB
	for <lists+kvm@lfdr.de>; Sat, 28 Oct 2023 01:13:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 354BA1C211CD
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 23:13:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12E46405F9;
	Fri, 27 Oct 2023 23:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NmnYcyO0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EBF34CD1
	for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 23:13:40 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03F41AA
	for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 16:13:38 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7bbe0a453so23397407b3.0
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 16:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698448418; x=1699053218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vgWHFf/sTmE0jzl2ZFpQeNmlF1SdNE+E8UNhjraSUMg=;
        b=NmnYcyO0EH6SoXjci13FKaXUiTDBXSmTiR238Uutgzqd5LeuMuLewDIsoqn24smSV+
         U7s7AxGW4jSPYWK75KA9WB6ENMl+hvtxBcUgRnjIbwsIF1TPa2+KPKWXibdn7TSM/v5n
         E7H9IGP+MY8e4plM51BEVjPknlqdWt16o9qhwsgE64cZZb0Ru4YXlUmy0LNv72wHNhPr
         egt5PWXD8RwBPyJaNELaAzQmWRTHohxhi32efKlpMMfUtO0s0CQswe57GcPqLN0WzCKm
         bgaUKaMyjSmTpRglVRpmnkg7y/5LYFn3hXibhCrF1yyZDWazztB89a4+IHJ5ZYXeRbyI
         YdkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698448418; x=1699053218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vgWHFf/sTmE0jzl2ZFpQeNmlF1SdNE+E8UNhjraSUMg=;
        b=jQWC+/o9kCt15t+xTTxM19lHPQiLPSyt7C9B8YbscZrOmcLkIhCtpw9OvsGaRlVHAL
         hSN+zobhMpicsSeJC1MDaD79vbrp4Zsxv+Fc1I1wERlisyZP8nLuw1wM35YkAkLI5oEi
         Tvu3gF1jA9KRFv2VvN8dr6+4uUymiIexqIV4I73evzakdL5xq+5hTyY1EjtPHM3wg+fK
         NxK7xIjo3jJG1+9Z5ZMk/R5zXnLD7FfigHpbNMHwaFhiHUnyjLvX3StGfxRLcRZGUiUa
         ceqSrZNGeim/8A7z+Hc7fl+SzXQ6nk3+sKy+v0Ixj1cKeyNgwCbVvDZsMWntGom9aAeV
         VEvg==
X-Gm-Message-State: AOJu0YxSOHHHynhw/7j+LZgb3KVryhxYitfe5x04c28nOK4PJoJ5vpGp
	nmiZZvo50QsSEIyal5yWKaAilLmbGn8=
X-Google-Smtp-Source: AGHT+IGLsQewPYNpvgeQCgXoVMY5LIWZCXhPFnep2N1+lUsnYiPMD4rv1UJPA/hQpcVw+ni0kOqTGISFbO4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1788:b0:da0:c9a5:b529 with SMTP id
 ca8-20020a056902178800b00da0c9a5b529mr70202ybb.12.1698448418008; Fri, 27 Oct
 2023 16:13:38 -0700 (PDT)
Date: Fri, 27 Oct 2023 16:13:36 -0700
In-Reply-To: <2C868574-37F4-437D-8355-46A6D1615E51@cs.utexas.edu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <2C868574-37F4-437D-8355-46A6D1615E51@cs.utexas.edu>
Message-ID: <ZTxEIGmq69mUraOD@google.com>
Subject: Re: A question about how the KVM emulates the effect of guest MTRRs
 on AMD platforms
From: Sean Christopherson <seanjc@google.com>
To: Yibo Huang <ybhuang@cs.utexas.edu>
Cc: kvm@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"

+Yan

On Sat, Aug 12, 2023, Yibo Huang wrote:
> Hi the KVM community,
> 
> I am sending this email to ask about how the KVM emulates the effect of guest
> MTRRs on AMD platforms.
> 
> Since there is no hardware support for guest MTRRs, the VMM can simulate
> their effect by altering the memory types in the EPT/NPT. From my
> understanding, this is exactly what the KVM does for Intel platforms. More
> specifically, in arch/x86/kvm/mmu/spte.c #make_spte(), the KVM tries to
> respect the guest MTRRs by calling #kvm_x86_ops.get_mt_mask() to get the
> memory types indicated by the guest MTRRs and applying that to the EPT. For
> Intel platforms, the implementation of #kvm_x86_ops.get_mt_mask() is
> #vmx_get_mt_mask(), which calls the #kvm_mtrr_get_guest_memory_type() to get
> the memory types indicated by the guest MTRRs.

KVM doesn't always honor guest MTTRs, KVM only does all of this if there is a
passhtrough device with non-coherent DMA attached to the VM.  There's actually
an outstanding issue with virtio-gpu where non-coherent GPUs are flaky due to
KVM not stuffing the EPT memtype because KVM isn't aware of the non-coherent DMA.

> However, on AMD platforms, the KVM does not implement
> #kvm_x86_ops.get_mt_mask() at all, so it just returns zero. Does it mean that
> the KVM does not use the NPT to emulate the effect of guest MTRRs on AMD
> platforms? I tried but failed to find out how the KVM does for AMD platforms.

Correct.  The short answer is that SVM+NPT obviates the need to emulate guest
MTRRs for real world guest workloads.

The shortcomings of VMX+EPT are that (a) guest CR0.CD isn't virtualized by
hardware and (b) AFAIK, if the guest accesses memory with PAT=WC to memory that
the host has accessed with PAT=WB (and MTRR=WB), the CPU will *not* snoop caches
on the guest access.

SVM on the other hand fully virtualizes CR0.CD, and NPT is quite clever in how
it handles guest WC:

  A new memory type WC+ is introduced. WC+ is an uncacheable memory type, and
  combines writes in write-combining buffers like WC. Unlike WC (but like the CD
  memory type), accesses to WC+ memory also snoop the caches on all processors
  (including self-snooping the caches of the processor issuing the request) to
  maintain coherency. This ensures that cacheable writes are observed by WC+ accesses.

And VMRUN (and #VMEXIT) flush the WC buffers, e.g. if the guest is using WB and
the host is using WC, things will still work as expected (well, maybe not for
cases where the host is writing and the guest is reading from different CPUs).
Anyways, evidenced by the lack of bug reports over the last decade, for practical
purposes snooping the caches on guest WC accesses is sufficient.

Hrm, but typing all that out, I have absolutely no idea why VMX+EPT cares about
guest MTRRs.  Honoring guest PAT I totally get, but the guest MTRRs make no sense.
E.g. I have a very hard time believing a real world guest kernel mucks with the
MTRRs to setup DMA.  And again, this is supported by the absense of bug reports
on AMD.


Yan,

You've been digging into this code recently, am I forgetting something because
it's late on a Friday?  Or have we been making the very bad assumption that KVM
code from 10+ years ago actually makes sense?  I.e. for non-coherent DMA, can we
delete all of the MTRR insanity and simply clear IPAT?

