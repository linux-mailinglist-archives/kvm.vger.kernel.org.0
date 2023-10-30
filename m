Return-Path: <kvm+bounces-70-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F32A07DBC6C
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:11:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68414B20E28
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 15:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FF4116408;
	Mon, 30 Oct 2023 15:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uPZVEJqv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BD3182B0
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 15:10:51 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68925A9
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 08:10:50 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc42d3f61eso11470095ad.3
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 08:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698678650; x=1699283450; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KOZvdXx7B3Ln4TkuYLwgyefo4h1Hfhkns40zUU/7nr4=;
        b=uPZVEJqvYTlbJNowv0ebR9yoZfdXIugjWiTmeaNxbHvGx0qXaDcGFrTK8WUWwp8s5I
         Up2s9kPpNxaD75CahH2x+zK8MgkRTOqTeUcZs9HXxhBUvTv5GCu0S62d79PFB22h9/w9
         zP/WGsZYeotC/Q9HLd6jxLcY5KLz2nq8FGAbXdskon3lFbphsS/WCKMNpPPmHvlM7Lhl
         06jjVLQ2is3t9DhKewwoaOrTDa2+d+4vLviK51O7PbWLsLgvVL+5D7f6wrif0Ae58nlX
         hVRyPBFGHMgEyR2vDHzKPAO/CvqYjUTfIiAv+sSo81lssY4RP9J4zubY5Kt4JSyN37eu
         8u7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698678650; x=1699283450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KOZvdXx7B3Ln4TkuYLwgyefo4h1Hfhkns40zUU/7nr4=;
        b=PbLt9xQWtD9d//XHKaB0pDncoBlu7fXaPlBExbc211rQXjtAvYZoddG8qmNepXVmdQ
         Xe7YR8fis3VF1etxOyHuIEa2G+Q1HWuWB27D75tR2tqjEnp43mZTrvlK2kce956rNHsn
         440689Lianix2wVdbkuC8KvygfNNnvfZ+5+2vjfayGPOivhHPy/SX6QQVjSYdh7x//uc
         eahHqs8VzDCwfoWaIzWQhE5M06LVC0xDsnmnMcLhagbA4pNtbI24LVWbXh1eGqMi6c2R
         AuXX0sMEgwcZ2DeMJDtxjpkDlQsNlbjmQ34uT20yvH9Td1YE6j3/7n9NmIQIE/6CPot7
         +adQ==
X-Gm-Message-State: AOJu0Yxk9xTg25KuW1t3yHfyGhrUx3c4UplzqYhpQAcWyJ/xPGadf1KK
	5z6OOn8nqjBRr6p8OtbPCiaQxBNobrg=
X-Google-Smtp-Source: AGHT+IGKxEV3Zm0LHm49D00vu0SroYxPWHJAglB5Z25j3orkER7wqfALY8RDBDcQE47ypqJuytd6ByhoLOc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f7c3:b0:1cc:29fb:f398 with SMTP id
 h3-20020a170902f7c300b001cc29fbf398mr148282plw.10.1698678649839; Mon, 30 Oct
 2023 08:10:49 -0700 (PDT)
Date: Mon, 30 Oct 2023 15:10:48 +0000
In-Reply-To: <CAE8KmOw1DzOr-GvQ9E+Y5RCX1GQ1h1Bumk5pB++9=SjMUPHxBg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAE8KmOw1DzOr-GvQ9E+Y5RCX1GQ1h1Bumk5pB++9=SjMUPHxBg@mail.gmail.com>
Message-ID: <ZT_HeK7GXdY-6L3t@google.com>
Subject: Re: About patch bdedff263132 - KVM: x86: Route pending NMIs
From: Sean Christopherson <seanjc@google.com>
To: Prasad Pandit <ppandit@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

+KVM and LKML

https://people.kernel.org/tglx/notes-about-netiquette

On Mon, Oct 30, 2023, Prasad Pandit wrote:
> Hello Sean,
> 
> Please see:
>     -> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bdedff263132c862924f5cad96f0e82eeeb4e2e6
> 
> * While testing a real-time host/guest setup, the above patch is
> causing a strange regression wherien guest boot delays by indefinite
> time. Sometimes it boots within a minute, sometimes it takes much
> longer. Maybe the guest VM is waiting for a NMI event.
> 
> * Reverting the above patch helps to fix this issue. I'm wondering if
> a fix patch like below would be acceptable OR reverting above patch is
> more reasonable?

No, a revert would break AMD's vNMI.

> ===
> # cat ~test/rpmbuild/SOURCES/linux-kernel-test.patch
> +++ linux-5.14.0-372.el9/arch/x86/kvm/x86.c     2023-10-30
> 09:05:05.172815973 -0400
> @@ -5277,7 +5277,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_e
>         if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
>                 vcpu->arch.nmi_pending = 0;
>                 atomic_set(&vcpu->arch.nmi_queued, events->nmi.pending);
> -               kvm_make_request(KVM_REQ_NMI, vcpu);
> +               if (events->nmi.pending)
> +                       kvm_make_request(KVM_REQ_NMI, vcpu);

This looks sane, but it should be unnecessary as KVM_REQ_NMI nmi_queued=0 should
be a (costly) nop.  Hrm, unless the vCPU is in HLT, in which case KVM will treat
a spurious KVM_REQ_NMI as a wake event.  When I made this change, my assumption
was that userspace would set KVM_VCPUEVENT_VALID_NMI_PENDING iff there was
relevant information to process.  But if I'm reading the code correctly, QEMU
invokes KVM_SET_VCPU_EVENTS with KVM_VCPUEVENT_VALID_NMI_PENDING at the end of
machine creation.

Hmm, but even that should be benign unless userspace is stuffing other guest
state.  E.g. KVM will spuriously exit to userspace with -EAGAIN while the vCPU
is in KVM_MP_STATE_UNINITIALIZED, and I don't see a way for the vCPU to be put
into a blocking state after transitioning out of UNINITIATED via INIT+SIPI without
processing KVM_REQ_NMI.

>         }
>         static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
> ===
> 
> * Could you please have a look and suggest what could be a better fix?

Please provide more information on what is breaking and/or how to reproduce the
issue.  E.g. at the very least, a trace of KVM_{G,S}ET_VCPU_EVENTS.   There's not
even enough info here to write a changelog.

