Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266473AD425
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 23:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbhFRVJg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 17:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbhFRVJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 17:09:34 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDE7C061574
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 14:07:24 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id f3-20020a0568301c23b029044ce5da4794so4404884ote.11
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 14:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QNkaHDH32oYI708qLthG4HDZlL9eGq69aiXkDfmun5Q=;
        b=LKCisxPE+/DVsZJOMvyzKKINOp8W9MJwuUOkGqRMUucc83d1kwUvSPNma16mlY/bGI
         0GN03hEKPlgscJHfuOzGdy8cDlmOG67qXugyF5v7vgFhOguZJDMe3JZwlTHggoJRWRTK
         oUTNpekMa9dbylC26woGc2rJTo9LNSzhINAki57r82nciUWYddrKoM82Oe8WtGoPXKQB
         J/RmiZVKq1q2Y8gi6EgbIBAHohg18oFkMK2eVVmtkB+eMJeM9yK02aBoANFQSqZ7Cym6
         WemosPTprnBxSR/HnwQIejtqffhaiNBlE42UyoVHb15t2OJj+jB3zYsWJ0SKMAtGOImF
         1GSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QNkaHDH32oYI708qLthG4HDZlL9eGq69aiXkDfmun5Q=;
        b=nD72h1X/xhRU+TWM4TNYK6AzR99x2RwLoakGSiBxzZvFLaXq1y1FT4sYNDH3onxF4s
         za/R3axUOAjRXM9E+t1s/fd4gLOzPIz44aNe9lpNzLW1/bvXkZlj8e3cqtAwtnuZ04/w
         CFtsMFGqZpaaHnDuNnNYw9r1gZZ6/y11LN1lKY1pBJdSVxjnNkAHBqEGDyDyXrFK1V8P
         sX6r4tOUlq519GefR2Dazzh0x2Sy9R1OE4ijiSD4NozpOZXVHxkOU8f94gTEj0LFxaLg
         qJHMHHKAfGwGwRM48i/OD8JzSwebTl1unRwg3NC2fZR8yDD0WCeB8OuHPC3KMrqOFeqI
         beqQ==
X-Gm-Message-State: AOAM530UCSptYTirSdREL7z4AQbie9Lnr6QRj9Bj/sjr57nGo9lMrfxs
        dl7lT7OWpvwEbPJcetyHay9wYmWeur5wUmC/1jRdp3XtsIRujQ==
X-Google-Smtp-Source: ABdhPJwh0gnkR946CivQy1rW/wX7+a+j7Jejq1aBygROQP3piBA8FWdotfJvdT5CIT2e7UUaibluArsVjR3slqPVyeE=
X-Received: by 2002:a05:6830:912:: with SMTP id v18mr11302763ott.241.1624050443399;
 Fri, 18 Jun 2021 14:07:23 -0700 (PDT)
MIME-Version: 1.0
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com> <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com> <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
In-Reply-To: <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 18 Jun 2021 14:07:12 -0700
Message-ID: <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
Subject: Re: guest/host mem out of sync on core2duo?
To:     stsp <stsp2@yandex.ru>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 18, 2021 at 9:02 AM stsp <stsp2@yandex.ru> wrote:

> Here it goes.
> But I studied it quite thoroughly
> and can't see anything obviously
> wrong.
>
>
> [7011807.029737] *** Guest State ***
> [7011807.029742] CR0: actual=0x0000000080000031,
> shadow=0x00000000e0000031, gh_mask=fffffffffffffff7
> [7011807.029743] CR4: actual=0x0000000000002041,
> shadow=0x0000000000000001, gh_mask=ffffffffffffe871
> [7011807.029744] CR3 = 0x000000000a709000
> [7011807.029745] RSP = 0x000000000000eff0  RIP = 0x000000000000017c
> [7011807.029746] RFLAGS=0x00080202         DR7 = 0x0000000000000400
> [7011807.029747] Sysenter RSP=0000000000000000 CS:RIP=0000:0000000000000000
> [7011807.029749] CS:   sel=0x0097, attr=0x040fb, limit=0x000001a0,
> base=0x0000000002110000
> [7011807.029751] DS:   sel=0x00f7, attr=0x0c0f2, limit=0xffffffff,
> base=0x0000000000000000

I believe DS is illegal. Per the SDM, Checks on Guest Segment Registers:

* If the guest will not be virtual-8086, the different sub-fields are
considered separately:
  - Bits 3:0 (Type).
    * DS, ES, FS, GS. The following checks apply if the register is usable:
      - Bit 0 of the Type must be 1 (accessed).

> [7011807.029752] SS:   sel=0x009f, attr=0x040f3, limit=0x0000efff,
> base=0x0000000002111000
> [7011807.029753] ES:   sel=0x00f7, attr=0x0c0f2, limit=0xffffffff,
> base=0x0000000000000000

And I believe ES is also illegal, for the same reason.

> [7011807.029764] FS:   sel=0x0000, attr=0x10000, limit=0x00000000,
> base=0x0000000000000000
> [7011807.029765] GS:   sel=0x0000, attr=0x10000, limit=0x00000000,
> base=0x0000000000000000
> [7011807.029767] GDTR:                           limit=0x00000017,
> base=0x000000000a708100
> [7011807.029768] LDTR: sel=0x0010, attr=0x00082, limit=0x0000ffff,
> base=0x000000000ab0a000
> [7011807.029769] IDTR:                           limit=0x000007ff,
> base=0x000000000a708200
> [7011807.029770] TR:   sel=0x0010, attr=0x0008b, limit=0x00002088,
> base=0x000000000a706000

It seems a bit odd that TR and LDTR are both 0x10,  but that's perfectly legal.
