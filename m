Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689223B6A93
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 23:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbhF1Vtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 17:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhF1Vtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 17:49:43 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B12BC061574
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 14:47:15 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id 11so15588730oid.3
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 14:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E2UYFEJe1v1aoMMey8dUblXulL7Y8ToIspRDTLe9eQQ=;
        b=VpFfwQseQe68q7SaGYeN0w/v6vYvMpIgyRqaynS6iTv51bahlj/ao6LE2OwbvU/aiq
         zEmtHCsXNVbRnjH2/dLo60z4qFzhqY3h4XMc83TrFLr+fYJ+w//EvTPj6OO+smc3oC8+
         l6azIAaOGu4XuUuQLm82Znn+wri9uzKG76mwGdlz1OJ1bwW7dx0zKZpMIkhRL6HGLnID
         HkqSzn5ILq/pS8H4S8JbPXqAz14q+2vyTNDAkYgSGCNKFzZ1wew6o3A0SHWt6lXH1a7k
         Hr3ohs8Qci0uC6Wq1Gof3pMhRXBX9NIWTHxIXOUnwXfZWinLTJETyxSZ3CZP4M1mafFE
         SI6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E2UYFEJe1v1aoMMey8dUblXulL7Y8ToIspRDTLe9eQQ=;
        b=er2vR+HUu/3qnp+cXr/Q/uc8vVTWc+jfhbUPGq8ErCcnbQCJrKQp8Cr+/Q++/UzAVb
         Tke0n3xPDWwvHwoJh0UzrZk3wIMgYlE0Is1RI730GvnxBN+OZlH2YKlv7Jx+s7lH77py
         s1Rae8NGDuEzCqEOnrDgEPbEdaFaUNiesqpITkX1EvWR1QgegDpJ1kpA8FOS+cOOaRuv
         HqF3gEEsVL0WtlA11Ef1LcMD6Tvq0SueylBAtKjA/u/5sUmoUBXjamDIEvGKIjGhC9hp
         yiHvLxA6DMuPHmBh70x4Hxo4XSAWC2kznmE5krFZpCkZwUnKf3DzCmrqgOj4G6NZWqK5
         wt8w==
X-Gm-Message-State: AOAM531v3MFr35DjcmuoxkGypPBWQBe5Pr9K37Mgf8jc1vc7ImvUoTyw
        LvH83H2hJpEt9lwT8Qbp2ce5PZoMPqwyCltYnXzr6w==
X-Google-Smtp-Source: ABdhPJw4qvdrcBxOWtQH0S5cLBQapL0OvjOpNso2DDzUwwVveSOoueNUjFTx4YSN432fbuOjb4mr14DhniSgDHOAp4Y=
X-Received: by 2002:aca:1e07:: with SMTP id m7mr18431014oic.28.1624916834461;
 Mon, 28 Jun 2021 14:47:14 -0700 (PDT)
MIME-Version: 1.0
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com> <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com> <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
 <d5bf20f4-9aef-8e7e-8a8f-47d10510724e@yandex.ru> <CALMp9eQANi7SPAvue5VQazG7A0=b_2vkUxYK+GMLbzNkxbXM5w@mail.gmail.com>
 <bf512c29-e6e2-9609-52e5-549d80d865d0@yandex.ru>
In-Reply-To: <bf512c29-e6e2-9609-52e5-549d80d865d0@yandex.ru>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 28 Jun 2021 14:47:03 -0700
Message-ID: <CALMp9eSnUhE61VcS5tDfmJwKFO9_en5iQhFeakiJ54gnH3QRvg@mail.gmail.com>
Subject: Re: exception vs SIGALRM race (was: Re: guest/host mem out of sync on core2duo?)
To:     stsp <stsp2@yandex.ru>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 21, 2021 at 5:27 PM stsp <stsp2@yandex.ru> wrote:
>
> 22.06.2021 01:33, Jim Mattson =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > Maybe what you want is run->ready_for_interrupt_injection? And, if
> > that's not set, try KVM_RUN with run->request_interrupt_window set?
> static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
> {
>          return kvm_arch_interrupt_allowed(vcpu) &&
>                  !kvm_cpu_has_interrupt(vcpu) &&
>                  !kvm_event_needs_reinjection(vcpu) &&
>                  kvm_cpu_accept_dm_intr(vcpu);
>
> }
>
>
> So judging from this snippet,
> I wouldn't bet on the right indication
> from run->ready_for_interrupt_injection

In your case, vcpu->arch.exception.injected is true, so
kvm_event_needs_reinjection() returns true. Hence,
kvm_vcpu_ready_for_interrupt_injection() returns false.

Are you seeing that run->ready_for_interrupt_injection is true, or are
you just speculating?
