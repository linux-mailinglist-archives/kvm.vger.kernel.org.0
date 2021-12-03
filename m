Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9264D467D69
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 19:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbhLCSlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 13:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhLCSlo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 13:41:44 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6420AC061751
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 10:38:20 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id t23so7509329oiw.3
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 10:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=5DGGpyoDfeKbGgtFbHp886boDDAmT/SQ1D2+9fOeUw0=;
        b=QAlV3Hin9iUp0M1Y5+yLwYwHivg3+279b1H/IZu0KRuxomVe8tS8N8CO4bNZRwT/MZ
         /aMKNv/M7CpKXPkeJCLO8DK+qzDECKJzew2TLY8nI1/kdvrN8bIckgE1xT7H1pN60P8n
         GksqEp7J6HJfQB0QODWML54JUOdl7EihJ5aLxEOW4SyhpmjPHGwuJf/Ix5o4lPtzAMMn
         CAmCa9jXP1+oDXLh+uRpVhCC9b8EvdHkV3LtAaW/csHC5cVFFjymLPPL5rYbhTdCz7ou
         AMoAoHCAoEbI8UesQkeSosLgTGBStkOC4BtzLR1vSAt/OxtKJ/rQ1uc97TdLO3s63iuz
         uvfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=5DGGpyoDfeKbGgtFbHp886boDDAmT/SQ1D2+9fOeUw0=;
        b=gLhHA1Q+Y6I0q/SzVQs6ZLvteZpmSMAYDL7IrdzLFqKGnNMWSHN6FCV4Sw9KyGo6wP
         R9KF/oVnuLRbbE3K5nH10OzzxIo5lUR88kiL3ViDMMbGZH89imqmg4JYPv7wW0Y8Koq4
         RHeUHEi120Li49bzH9KbbddUibXaBpfdgnu31rmtQt64NNPG7YiHLhjy28HQPzuwlsAx
         rcOmWSPP98+7FEroCL30eU3dGcznO6s4fL+D/Nz5GYIltVRA+b/4eBVwrrALTc10GTBy
         EqonCUkRvQW2XmtmubWHHVhVsHueJHqgDjq7k7p7lO1OUncp0peXnCvaK4Ne4myb93US
         +kJQ==
X-Gm-Message-State: AOAM533FoHUib5Bb2n+/du5HUoBB92d0FQAt/JPUBgKOtYmTTnZSGSL8
        bcxd9wiuWMmOlDxUT+KXv5NQ22nTgLJFpKWbjfyTwA==
X-Google-Smtp-Source: ABdhPJy34WOY4pXb3ceO0PpR03Jx1gUOnUlDEPNUFPCbTsqtvC1LEOdqfBpYsiC6XMzKCw3jKDfkpstWgdlrJP8L3r4=
X-Received: by 2002:a05:6808:171c:: with SMTP id bc28mr11185631oib.102.1638556699471;
 Fri, 03 Dec 2021 10:38:19 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6838:1952:0:0:0:0 with HTTP; Fri, 3 Dec 2021 10:38:19
 -0800 (PST)
In-Reply-To: <87r1au6rfe.fsf@redhat.com>
References: <CA+qz5sqUKk46BcRKCyM1rdvtGL3QE7C8gDt0D7qx8_x_M8bKtQ@mail.gmail.com>
 <87r1au6rfe.fsf@redhat.com>
From:   Makarand Sonare <makarandsonare@google.com>
Date:   Fri, 3 Dec 2021 18:38:19 +0000
Message-ID: <CA+qz5sqrCYnqbfJ+-D_EFWG0XXZwP7wMh2uUb_3CsZK7Rdt2RA@mail.gmail.com>
Subject: Re: KVM patches for Hyper-V improvements
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,
             I am interested in patches since the 4.15 kernel that are
specific to nested Hyper-V and specific to non Hyper-V Windows guest.

Thanks,
Makarand.

On 12/3/21, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> Makarand Sonare <makarandsonare@google.com> writes:
>
>> Hello Vitaly,
>>                   I am interested in knowing the exact set of KVM
>> patches that were added for the Nested Hyper-V scenario. Could you
>> please point me to them?
>
> Hi Makarand,
>
> are you interested in patches since some upstream kernel version or
> since the beginning of time? Thing is, some Hyper-V enlightenments
> benefit both Windows and Hyper-V and some are specific to Hyper-V. Out
> of top of my head, 'direct synthetic timers', 'Enlightened VMCS', and
> 'Enlightened MSR-Bitmap' features are Hyper-V specific. Patch list is
> pretty long, see for example
>
> $ git log --author vkuznets@redhat.com --oneline -i --grep
> 'enlightened.*vmcs' arch/x86/kvm/
>
> and
>
> $ git log --author vkuznets@redhat.com --oneline -i --grep 'direct.*syn'
> arch/x86/kvm/
>
> Enlightened MSR-Bitmap is only in kvm/master:
> ceef7d10dfb6 KVM: x86: VMX: hyper-v: Enlightened MSR-Bitmap support
>
> The list is likely incomplete as there are pre-requisites for these
> patches which may not have the required keywords. There were fixes in
> other parts of KVM for nested Hyper-V as well but I don't know an easy
> way to find them (grepping for 'Hyper-V/hyperv' in the log would be a
> good start but we'll certainly miss something).
>
> Please let me know if that's what you're looking for and I'll try to
> give you more precise information.
>
> --
> Vitaly
>
>


-- 
Thanks,
Makarand Sonare
