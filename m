Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90FE2FDC3A
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 23:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731302AbhATVwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 16:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388275AbhATVPL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 16:15:11 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8A0C0613D3
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 13:14:30 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id v1so6714310ott.10
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 13:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yEkUpjuUk+6RvwFY/bU3gV3b0FLwS6IRTzESJ9aPwIY=;
        b=KnjZZzxfVrWLF4nHoY1hwoo0B/5QYXtUetFrZwE0BUGMi+HeT39vkey3wNNpQmUSOi
         MC4Mlg1aWdGEkQSC421ZkcNLSyf4m1zSCvyrhEO3nUGNNgCRJGQXCheg5UdArPyAwTlD
         6sjn6VHJOQAkIGbZxCgKXCZop6CZLRctv21O+uNpf/MIHDKwZrtnoM4GTzj63h5WPVok
         VVwB/rs9XhZqnAS3IDexnIF2LuqNgVY60BXlDUHjwREHyRz+Hxc1kNewjfX5s0b52OdA
         sz2I0gS1iLtibhrTbOzPsqEV6s1hjY4sDRKbigkICAB83YFzSvCae+lBbrQ4cWRXQhYS
         1Z7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yEkUpjuUk+6RvwFY/bU3gV3b0FLwS6IRTzESJ9aPwIY=;
        b=KFAGTX9jKPpCfpTe37MIThaBzOCU55jtBMCxelNUd4edkAVvTTaFrnf2EmHNqmVQK0
         R8io9SB/S7DLvxlo9C1VHLuY/o9aExns7uqv0j+8T1XBoC1mHmUahgJ0IplZHo3intgb
         Qbk4IAzx7B9Ri6qAgf0xEA2CmzrNqS+RTZK/6kUTkqPxSlWkqrTzjGmfiHluE5HGwArw
         8bJHJssjtLtBSd5rAcr+/DM1LKntF92k76HQ7PflcuHY9asKK2CUmbUsSL5NaSO73emC
         fWVFKS5i+tmVLiWKIVkjLYuz3ju0W2WYA3y+TrjnssLo4bWij7FMVK3L7kRT/TIiY59N
         cXIw==
X-Gm-Message-State: AOAM532I6rktFu9Xplvlqq5mT4BMSguujRShuHEnYWfPAdBE8ZxYcbdk
        ILHxUsc10ulaWJZFqN9gLvAZIAhKHIwqp55BpxZfqDBP1+o=
X-Google-Smtp-Source: ABdhPJwZJIQYQQlTR+gr34xTpqov/GqHEuPA4quEUqWdYPej8xqqkJIm1sVeKmiOJ/CC1lQu4CDiLBU1aVBFLeh6FYY=
X-Received: by 2002:a05:6830:1da4:: with SMTP id z4mr8172697oti.295.1611177268815;
 Wed, 20 Jan 2021 13:14:28 -0800 (PST)
MIME-Version: 1.0
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
 <83a96ca9-0810-6c07-2e45-5aa2da9b1ab0@redhat.com> <5df9b517-448f-d631-2222-6e78d6395ed9@amd.com>
 <CALMp9eRDSW66+XvbHVF4ohL7XhThoPoT0BrB0TcS0cgk=dkcBg@mail.gmail.com> <bb2315e3-1c24-c5ae-3947-27c5169a9d47@amd.com>
In-Reply-To: <bb2315e3-1c24-c5ae-3947-27c5169a9d47@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 20 Jan 2021 13:14:17 -0800
Message-ID: <CALMp9eQBY50kZT6WdM-D2gmUgDZmCYTn+kxcxk8EQTg=SygLKA@mail.gmail.com>
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 19, 2021 at 3:45 PM Babu Moger <babu.moger@amd.com> wrote:
>
>
>
> On 1/19/21 5:01 PM, Jim Mattson wrote:
> > On Mon, Sep 14, 2020 at 11:33 AM Babu Moger <babu.moger@amd.com> wrote:
> >
> >> Thanks Paolo. Tested Guest/nested guest/kvm units tests. Everything works
> >> as expected.
> >
> > Debian 9 does not like this patch set. As a kvm guest, it panics on a
> > Milan CPU unless booted with 'nopcid'. Gmail mangles long lines, so
> > please see the attached kernel log snippet. Debian 10 is fine, so I
> > assume this is a guest bug.
> >
>
> We had an issue with PCID feature earlier. This was showing only with SEV
> guests. It is resolved recently. Do you think it is not related that?
> Here are the patch set.
> https://lore.kernel.org/kvm/160521930597.32054.4906933314022910996.stgit@bmoger-ubuntu/

The Debian 9 release we tested is not an SEV guest.
