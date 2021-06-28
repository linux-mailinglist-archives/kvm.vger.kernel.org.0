Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBEF3B6AF2
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 00:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbhF1W36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 18:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbhF1W35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 18:29:57 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3376C061574
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 15:27:30 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id a133so21651663oib.13
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 15:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TgjFclLl3YiwZ1dvSuW0oahhgKHX84plROL9LLmzJUY=;
        b=E2jzXv9x2Xn5ysIZar9e7StLyhdDjER9sGF4aZY6o3ZeN0gbOGSRCC/qdoWK6PWu+a
         Q/bG6EODzIW9NRLyfB1UG0qUFH4Mdcgag7Ffii59TopoDKue5/hQu0fGFq1Iy1vGwioG
         s35vaAjIfd8sh95GdhkHe24Q+qF4zcTGNJbqNhyNGC6ZfPp3kzf5QFMeYml6w5XH0HT+
         FbHtcH2KY7uyfglrBJX9mYtI0gU4r96+kC6hqhqsNG2JIf6xdib+exukQhmjOVcPGkka
         /2VThAGGUXCRHWcfoOIWnKjb1gX3U0NdZHaZvSs7GbTd+xXwsoz3yalqUXaSeZksegxc
         SphQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TgjFclLl3YiwZ1dvSuW0oahhgKHX84plROL9LLmzJUY=;
        b=F1/F0zrUlPkRbyX7Mi+VbqZecXsVLo1qLlD4hiA4Bqnas6xvmK/hL+lp9ubkcFFa48
         iSlseUNWP3ZkKbGE33UX/nblWZmDQp5k9KxFJHDidZY2UMvsP2br5lS389NiA6iDuVGf
         +38IGaLkIty1DrZfiK8TOmzAnN4GOKyVa9IiNm0FyfEKDaHI51er3D0mBPVWEc4V3u7f
         xwNRFkeu5Vt6t0+zQ3DaaI4N2Qbbk5568bTh4PEkypmI8SO65lsYVE/v9R49gJZHM7pe
         JaVjhCEM5830t71izqKlZpMobsN9R4CciqRKZ3dSSlDBzQm4L3TCwp+8gY3ExfpgQ0CQ
         lJQQ==
X-Gm-Message-State: AOAM532KhBGK0NaUZ7v+6Kt76xJGfTOa+zT6AUgujLmrFPudLI583sCt
        1QrSQGTv0i/tccut6TqIgO0H+DZrsH7jJ4DV9H51FQ==
X-Google-Smtp-Source: ABdhPJw9ILZlrn6oZrvBbHKhe+MwhRs7HI7CVYCe3cSKnkyTeh5kAuQnVyh/K0VlOGQ63oQhAYpDzsudJZ8d6aoQ5H4=
X-Received: by 2002:aca:1e07:: with SMTP id m7mr18538259oic.28.1624919249454;
 Mon, 28 Jun 2021 15:27:29 -0700 (PDT)
MIME-Version: 1.0
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com> <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com> <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
 <d5bf20f4-9aef-8e7e-8a8f-47d10510724e@yandex.ru> <CALMp9eQANi7SPAvue5VQazG7A0=b_2vkUxYK+GMLbzNkxbXM5w@mail.gmail.com>
 <bf512c29-e6e2-9609-52e5-549d80d865d0@yandex.ru> <CALMp9eSnUhE61VcS5tDfmJwKFO9_en5iQhFeakiJ54gnH3QRvg@mail.gmail.com>
 <b15c78e6-4ae3-5825-50c2-396c4e600d02@yandex.ru>
In-Reply-To: <b15c78e6-4ae3-5825-50c2-396c4e600d02@yandex.ru>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 28 Jun 2021 15:27:18 -0700
Message-ID: <CALMp9eT9XSuk2=WuunKsLpUw8zbE1xtzRzHesN3MOJPYuh0KkQ@mail.gmail.com>
Subject: Re: exception vs SIGALRM race (was: Re: guest/host mem out of sync on core2duo?)
To:     stsp <stsp2@yandex.ru>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Woodhouse <dwmw@amazon.co.uk>,
        "ntsironis@arrikto.com" <ntsironis@arrikto.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 3:00 PM stsp <stsp2@yandex.ru> wrote:
>
> 29.06.2021 00:47, Jim Mattson =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On Mon, Jun 21, 2021 at 5:27 PM stsp <stsp2@yandex.ru> wrote:
> >> 22.06.2021 01:33, Jim Mattson =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>> Maybe what you want is run->ready_for_interrupt_injection? And, if
> >>> that's not set, try KVM_RUN with run->request_interrupt_window set?
> >> static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcp=
u)
> >> {
> >>           return kvm_arch_interrupt_allowed(vcpu) &&
> >>                   !kvm_cpu_has_interrupt(vcpu) &&
> >>                   !kvm_event_needs_reinjection(vcpu) &&
> >>                   kvm_cpu_accept_dm_intr(vcpu);
> >>
> >> }
> >>
> >>
> >> So judging from this snippet,
> >> I wouldn't bet on the right indication
> >> from run->ready_for_interrupt_injection
> > In your case, vcpu->arch.exception.injected is true, so
> > kvm_event_needs_reinjection() returns true. Hence,
> > kvm_vcpu_ready_for_interrupt_injection() returns false.
> >
> > Are you seeing that run->ready_for_interrupt_injection is true, or are
> > you just speculating?
>
> OK, please see this commit:
> https://www.lkml.org/lkml/2020/12/1/324
>
> There is simply no such code
> any longer. I don't know where
> I got the above snippet, but its
> not valid. The code is currently:
>
> ---
>
> static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
> {
>          return kvm_arch_interrupt_allowed(vcpu) &&
>                  kvm_cpu_accept_dm_intr(vcpu);
> }

 It looks like Paolo may have broken this in commit 71cc849b7093
("KVM: x86: Fix split-irqchip vs interrupt injection window request").
The commit message seems focused only on
vcpu->arch.interrupt.injected. Perhaps he overlooked
vcpu->arch.exception.injected.
