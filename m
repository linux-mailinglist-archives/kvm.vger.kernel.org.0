Return-Path: <kvm+bounces-5512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7486282294A
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 09:05:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8519F1C22FBD
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 08:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D0CF182A2;
	Wed,  3 Jan 2024 08:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DRSauTrh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3D61804E
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 08:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704269095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gYljcyaJYdFZwaWbn+pl2W1uV01ThCIQUmO2ZsphZZA=;
	b=DRSauTrh765feuLzfkClB2P4/DlK27hNFtd5UXE6OmeVhST/j+FtUk4DYqPmgVSbHhkIVm
	3k7etx0VsDkOvGsmmQ4G75GkbT3mYCOzgWC2aPJIgobHPyv8Kjom7g7HUlIN+wHmvhDBza
	ocNzWrV7PqmCjZdGfG2FwMTpOgxhGn4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-LlVBpGjzN5yU8bVKHf1IJQ-1; Wed, 03 Jan 2024 03:04:53 -0500
X-MC-Unique: LlVBpGjzN5yU8bVKHf1IJQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40d4a29dca7so79669475e9.0
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 00:04:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704269092; x=1704873892;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gYljcyaJYdFZwaWbn+pl2W1uV01ThCIQUmO2ZsphZZA=;
        b=xFXzVGD4Y6MehBnlh4puIBkBxwuAM1zu9EpWiFOmFK4rR0oe0aBbvl6bZC0jF3yYBp
         ZrQnKAv3/qegF9vQN4jUQ/f9Cr0UCEZVotmf+S1WzNFSehDMAgllA3+1KpsmkvuGTKTC
         yNDZLR8BuJaIKEM/TyBTmmcrvDdAHDLG3+6cfUJX5nOrQYgQGEgYdzUl0ojfImmN3Kt8
         MgcPq2mFqsxuh1poGPDHrPmIJQHoNLUGVuVJnyXki3+Tc/X8RDdfxYS10N13FWbpnx3d
         XIB/tVbH12LZgjPzDKuQJG113vHjbs+lKdSrFOyYH06B3bpYyuKcHafnV0/YZ7UwrrD+
         lpVQ==
X-Gm-Message-State: AOJu0YynU5f6z7fIhKXgZy9GqK9913PjrJDJTJS5J69Vg3cG/jk13MnH
	88iTUcfz7ni3nofynxkvo5/IIIbDMmgltThPd/VQgN6Z64UICf4gRRFQTL+B+BwUjtbjo7PtGNU
	K7IGssvv9bh27WJF/cXCgAzRhmlDKra4ckHHTnd6wWNzJ4Xg=
X-Received: by 2002:a05:600c:ad0:b0:40c:33be:d187 with SMTP id c16-20020a05600c0ad000b0040c33bed187mr9885588wmr.25.1704269092306;
        Wed, 03 Jan 2024 00:04:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEWYNgEexMUVb2s2vwCsNsuobQ3E/A2kRIlfi4BbZlrb3hn/aaRi6+/bhJ2Wxfbv4ZGXZq5UZfoRErnSdrbW+8=
X-Received: by 2002:a05:600c:ad0:b0:40c:33be:d187 with SMTP id
 c16-20020a05600c0ad000b0040c33bed187mr9885584wmr.25.1704269092036; Wed, 03
 Jan 2024 00:04:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAE8KmOw1DzOr-GvQ9E+Y5RCX1GQ1h1Bumk5pB++9=SjMUPHxBg@mail.gmail.com>
 <ZT_HeK7GXdY-6L3t@google.com> <CAE8KmOxKkojqrqWE1RMa4YY3=of1AEFcDth_6b2ZCHJHzb8nng@mail.gmail.com>
 <CAE8KmOxd-Xib+qfiiBepP-ydjSAn32gjOTdLLUqm-i5vgzTv8w@mail.gmail.com>
 <CAE8KmOyffXD4k69vRAFwesaqrBGzFY3i+kefbkHcQf4=jNYzOA@mail.gmail.com> <ZZSVnT0Ovk5QrasA@google.com>
In-Reply-To: <ZZSVnT0Ovk5QrasA@google.com>
From: Prasad Pandit <ppandit@redhat.com>
Date: Wed, 3 Jan 2024 13:34:35 +0530
Message-ID: <CAE8KmOyrBmUq-38aVig16mEc5h4jwaTYHRY2rRWvMAn6wmKkAg@mail.gmail.com>
Subject: Re: Fwd: About patch bdedff263132 - KVM: x86: Route pending NMIs
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello Sean,

On Wed, 3 Jan 2024 at 04:30, Sean Christopherson <seanjc@google.com> wrote:
> Heh, I don't know that I would describe "412 microseconds" as "indefinitely", but
> it's certainly a long time, especially during boot.

* Indefinitely because it does not come out of it. I've left the guest
overnight and still it did not boot.

> Piecing things together, the issue is I was wrong about the -EAGAIN exit being
> benign.
>
> QEMU responds to the spurious exit by bailing from the vCPU's inner runloop, and
> when that happens, the associated task (briefly) acquires a global mutex, the
> so called BQL (Big QEMU Lock).  I assumed that QEMU would eat the -EAGAIN and do
> nothing interesting, but QEMU interprets the -EAGAIN as "there might be a global
> state change the vCPU needs to handle".
>
> As you discovered, having 9 vCPUs constantly acquiring and releasing a single
> mutex makes for slow going when vCPU0 needs to acquire said mutex, e.g. to do
> emulated MMIO.
>
> Ah, and the other wrinkle is that KVM won't actually yield during KVM_RUN for
> UNINITIALIZED vCPUs, i.e. all those vCPU tasks will stay at 100% utilization even
> though there's nothing for them to do.  That may or may not matter in your case,
> but it would be awful behavior in a setup with oversubscribed vCPUs.
...
> Yeah, that's kinda sorta what's happening, although that comment is about requests
> that are never cleared in *any* path, e.g. violation of that rule causes a vCPU
> to be 100% stuck.

* I see, interesting.

> I'm not 100% confident there isn't something else going on, e.g. a 400+ microsecond
> wait time is a little odd,

* It could be vCPU thread's sched priority/policy.

> but this is inarguably a KVM regression and I doubt it's worth anyone's time to dig deeper.
> Can you give me a Signed-off-by for this?  I'll write a changelog and post a proper patch.

* I have sent a formal patch to you. Please feel free to edit the
commit/change log as you see fit. Thanks so much.

Thank you.
---
  - Prasad


