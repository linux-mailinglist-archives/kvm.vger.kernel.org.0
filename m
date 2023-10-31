Return-Path: <kvm+bounces-189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0BFF7DCCA3
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 13:13:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AABBD2817D2
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 12:13:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0041E1DA45;
	Tue, 31 Oct 2023 12:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f0a8nDEP"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5971A1DA30
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 12:12:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D4497
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 05:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698754371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bGV25K3nUnQ+2KxGVOhDHO+SWa9Obf8EAYV7RnLmQDU=;
	b=f0a8nDEPX0EAbp6IMH+d8YQ2Tm5u//JmYO1GbxRFR4kOV4jvRGddfgut0SkAz0jzpwBlvN
	uB2aSXhY/qGYqExfkrDeX2EthJ+herw2jK/oVWgyEfxus0/cr7Hp2pjpx8sXWCMxzBWOmb
	8YVOcP7UHkUOuOusXO8wbB2jrIVDSsg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-OE_HtfAdP5CiLwSKrhFQKg-1; Tue, 31 Oct 2023 08:12:44 -0400
X-MC-Unique: OE_HtfAdP5CiLwSKrhFQKg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4094cc441baso7338085e9.1
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 05:12:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698754363; x=1699359163;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bGV25K3nUnQ+2KxGVOhDHO+SWa9Obf8EAYV7RnLmQDU=;
        b=YMWkxmK67fnDC8Q61wfPSvWjXk28I365YsP+ZJE3xXzuI6fsXZKG0HtggHrP+m02Dc
         zPqLJiQkDSSCTJd4KH6N2kYy0cl49ehdRZEAc035+9b67oddhPQF+anns7vKnm0fMIqI
         YJ2hLuWUyHO3XejrwSm+cJSEejehpssq2ZLtcA2W/0F2vYxB0mHov7fTE9GiriA8PDjb
         V1Q3bHKfj1B+zXeE29K7HJeNOVlBg1I1MREhKlZKCH8FDCvSdXv08t9k5Ke0D1boWqTp
         1mSBPr0C9BZW7bZdlk89CUlB3RcY1s7nj3fb9NrgGfk86HIRIKPkcmO9WYYvsmznKsz3
         3ImQ==
X-Gm-Message-State: AOJu0YxErCHDQgTdZe34faoF2ygkS9O1/RnmW1dY0f7k8jML8HTk14pY
	IpsEAi1hFYHwMR/gJlWzPg7tgVAy17SSNxcZk1V+x5MqRm42iP4RCLq4OYMAWknQEd3mNoEOtUt
	Pw0Bs35VL3UBmse598M5lH7qb/W6DvSwSE1ge
X-Received: by 2002:a05:600c:35c9:b0:407:3b6d:b561 with SMTP id r9-20020a05600c35c900b004073b6db561mr10853434wmq.9.1698754362829;
        Tue, 31 Oct 2023 05:12:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIXLDnDne2ryAOzcO1wdHSl4RB/oKVIMQikIcfIJxAKfx07OeucoM5k7KMFboLCviAMlkUfGNEBEfrrFED8Qc=
X-Received: by 2002:a05:600c:35c9:b0:407:3b6d:b561 with SMTP id
 r9-20020a05600c35c900b004073b6db561mr10853418wmq.9.1698754362417; Tue, 31 Oct
 2023 05:12:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAE8KmOw1DzOr-GvQ9E+Y5RCX1GQ1h1Bumk5pB++9=SjMUPHxBg@mail.gmail.com>
 <ZT_HeK7GXdY-6L3t@google.com>
In-Reply-To: <ZT_HeK7GXdY-6L3t@google.com>
From: Prasad Pandit <ppandit@redhat.com>
Date: Tue, 31 Oct 2023 17:45:28 +0530
Message-ID: <CAE8KmOxKkojqrqWE1RMa4YY3=of1AEFcDth_6b2ZCHJHzb8nng@mail.gmail.com>
Subject: Re: About patch bdedff263132 - KVM: x86: Route pending NMIs
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello Sean,

On Mon, 30 Oct 2023 at 20:41, Sean Christopherson <seanjc@google.com> wrote:
>> if a fix patch like below would be acceptable OR reverting above patch is
>> more reasonable?
>
> No, a revert would break AMD's vNMI.

* Okay, that confirmation helps.

>> -               kvm_make_request(KVM_REQ_NMI, vcpu);
>> +               if (events->nmi.pending)
>> +                       kvm_make_request(KVM_REQ_NMI, vcpu);
>
> This looks sane, but it should be unnecessary as KVM_REQ_NMI nmi_queued=0 should
> be a (costly) nop.  Hrm, unless the vCPU is in HLT, in which case KVM will treat
> a spurious KVM_REQ_NMI as a wake event.  When I made this change, my assumption
> was that userspace would set KVM_VCPUEVENT_VALID_NMI_PENDING iff there was
> relevant information to process.  But if I'm reading the code correctly, QEMU
> invokes KVM_SET_VCPU_EVENTS with KVM_VCPUEVENT_VALID_NMI_PENDING at the end of
> machine creation.
>
> Hmm, but even that should be benign unless userspace is stuffing other guest
> state.  E.g. KVM will spuriously exit to userspace with -EAGAIN while the vCPU
> is in KVM_MP_STATE_UNINITIALIZED, and I don't see a way for the vCPU to be put
> into a blocking state after transitioning out of UNINITIATED via INIT+SIPI without
> processing KVM_REQ_NMI.
>
> Please provide more information on what is breaking and/or how to reproduce the
> issue.  E.g. at the very least, a trace of KVM_{G,S}ET_VCPU_EVENTS.   There's not
> even enough info here to write a changelog.
>

* I see, I'll try to understand in more detail about what's really
happening and will get back asap.

Thank you.
---
  - Prasad


