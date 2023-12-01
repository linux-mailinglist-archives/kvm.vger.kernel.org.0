Return-Path: <kvm+bounces-3182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E7508017C7
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:31:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFBF71C20BAF
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 23:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A4813F8F7;
	Fri,  1 Dec 2023 23:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3UQjXvMK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FEC10F4
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 15:31:18 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5d3cdd6f132so28519327b3.2
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 15:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701473477; x=1702078277; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IKTnMsXS7bfkUSzfnP9Xpe0AB/j3WnOgx9Hq4BWGDW0=;
        b=3UQjXvMKuwwfsdITeRV7UIBfbnpLDpC9/7ac5rRFqgN8Oi/3eH3+1ZrJplPkQvp/1h
         y4yic5SH3UxFZR3nZb6PXBN2u8vOZpC6j3/0XeFh4DRgVt2Uoj41DZJ4DDzLKPunEhMe
         /5DhYZOfs9JecEeJkE3xTn4QHcGXGQQwvTq3KhiI0XntryAIhPYcZmcNkGP74RVjE584
         MpvPbMqkvlD5HZh2nm4dJQ4TFepMb9bg9haaJcL32toGWFy0ijQSD7ZthkrFawz47ayq
         AUa55OXciZuRK0MDIMJZqj40YQnh89o9J3eM61EFH4ZyewTaZbwj8TxDB0ZA9j5QgggK
         ZW/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701473477; x=1702078277;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IKTnMsXS7bfkUSzfnP9Xpe0AB/j3WnOgx9Hq4BWGDW0=;
        b=dPcXcNo/s8nIOORudAMHVMGM9q1EOzCb0ynofdPmU/B5rK2LdYoy1kzHtFRI85noiH
         +5Y79CK6aBwHV19nf/jLgCKcxrqPCiCc8jXeiXg5xA8nvhBHjRs00g7+7e1EGKcXfibh
         L6lrxohu1wv2Do9DJv3suBcDfCYUzQTwtMdWGMUuB6YiDnODQbwggzm7LMhP17UFZXTf
         UKG3PUWixI8R8pah0Jk2zyPu6wc2DPL5eZaiaQDWLO2c83h5JWWsGXaIiPeHRyknA4YR
         xlv/wpGPyAClUEIhTvHyO/+7n3y9kaQ1tcT2289Lt9nS6oAwgo2L25D/LhQJCpsjfpwG
         SUFg==
X-Gm-Message-State: AOJu0YyvRK4YC7FmzJ6ZZ2JjQr/gzcDy1FRLeQXMKY6oU4g656dQFQm+
	VxOLuiQi8CmMEgzfXMovkWDMgEmZciA=
X-Google-Smtp-Source: AGHT+IFRQ4AylpcFdoV4eED2PVv6bLzSBS5jcJXcCPI5IxjYv4WYUfmMopGrsirh/5rxO3xVuRULjEACP9A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4704:b0:5d3:a348:b0b9 with SMTP id
 gz4-20020a05690c470400b005d3a348b0b9mr175514ywb.8.1701473477627; Fri, 01 Dec
 2023 15:31:17 -0800 (PST)
Date: Fri,  1 Dec 2023 15:30:35 -0800
In-Reply-To: <20231018204624.1905300-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231018204624.1905300-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <170144720127.838654.18038243366582421190.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: Fix KVM-owned file refcounting of KVM module(s)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 18 Oct 2023 13:46:21 -0700, Sean Christopherson wrote:
> Clean up a KVM module refcounting mess that Al pointed out in the context
> of the guest_memfd series.  The worst behavior was recently introduced by
> an ill-fated attempt to fix a bug in x86's async #PF code.  Instead of
> fixing the underlying bug of not flushing a workqueue (see patch 2), KVM
> fudged around the bug by gifting every VM a reference to the KVM module.
> 
> That made the reproducer happy (hopefully there was actually a reproducer
> at one point), but it didn't fully fix the use-after-free bug, it just made
> the bug harder to hit.  E.g. as pointed out by Al, if kvm_destroy_vm() is
> preempted after putting the last KVM module reference, KVM can be unloaded
> before kvm_destroy_vm() completes, and scheduling back in the associated
> task will explode (preemption isn't strictly required, it's just the most
> obvious path to failure).
> 
> [...]

Applied 1 and 3 (the .owner fixes) to kvm-x86 fixes.  I'll follow-up with a
separate series to tackle the async #PF mess.

[1/3] KVM: Set file_operations.owner appropriately for all such structures
      https://github.com/kvm-x86/linux/commit/087e15206d6a
[2/3] KVM: Always flush async #PF workqueue when vCPU is being destroyed
      (no commit info)
[3/3] Revert "KVM: Prevent module exit until all VMs are freed"
      https://github.com/kvm-x86/linux/commit/ea61294befd3

--
https://github.com/kvm-x86/linux/tree/next

