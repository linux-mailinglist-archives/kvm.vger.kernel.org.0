Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C493F2AC8B0
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgKIWgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgKIWgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:36:42 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF11FC0613D4
        for <kvm@vger.kernel.org>; Mon,  9 Nov 2020 14:36:41 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id m17so12051974oie.4
        for <kvm@vger.kernel.org>; Mon, 09 Nov 2020 14:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CTh6EHdj/sEjVeEM7tTLdCGN17vFXhY30SLk5/K9tus=;
        b=DQepMCFhAe7e5wzfvOjHy+zSRqIgqviiVN86ZTuq+EjTL/Mjqv1OpUP/DhwbvqVXWt
         76jrPoQJBhQiAsIMEsumWsQ69zJmoKfDn+XzeIQbC7V9v/kcPPAOCAGzHdulH9SG77xX
         kA2zleK1xZmj/sADDwAzXXUeIL1Ht0tEFFO/RhzwcEs2ySi+sL23LWKiHjUJctMTcfZV
         zQf0bfsCwCfeP3brkU25GS2wehLX6WX52wLpctCDKAlLTgBX0yL0HpnPv9yZ94uvaqYy
         6a4TcSqhRT4gixWuZ4PA86TEB6/POnXjx8nx0X+PAfNhDQm071OPu9Iwx3qzuNL3G8jh
         9HlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CTh6EHdj/sEjVeEM7tTLdCGN17vFXhY30SLk5/K9tus=;
        b=lGTpgfnbTyF4Omy2Mhqs0DZjqX5pdVgwvtH/cCXE2zN/DQ42j1lN1qGNIOA4BRH33i
         39rf8TU6U2jV0UaEWmuC6pvl890rs/cUckm2XVuEgka6VQ3Ab9LhPNwgiiPZNVrE2w62
         6jfzoBoJlroOEKIILiobwg/Sa3oEXfyytFS9Vfh83XtlMv3VzFRnH/TT05Sx7vNeIW33
         bEvgIaRSPiWB+3+niYVudzlKN+hiLDzItO84iMu/AZvcE2RgQ3UIfjo9tphgz6N/Lbat
         nUEj3LOOzIbq0CFU4ZalGsnOedkF98YLHbpHd+AlcVpWETKDWp46GYEUIA07nn4gCTqt
         UNpQ==
X-Gm-Message-State: AOAM533JSKXitdhlTn+wyQ90yO5Qc4KkqQsfjxAZRHz/OwHUHQP8BWEc
        3QmNP66J4j+fH4JVPd22UsDKIRnBUTtIl9J0pwSlRA==
X-Google-Smtp-Source: ABdhPJyGsZp34bN65P+ZviA1hv7Uw0zaa+Kw38+E6oue4vDWjH3T/+uur8iehxwmbCi7dDf59M+lS1szSQhCxNuYQeo=
X-Received: by 2002:a54:4082:: with SMTP id i2mr969744oii.28.1604961400870;
 Mon, 09 Nov 2020 14:36:40 -0800 (PST)
MIME-Version: 1.0
References: <20201030190807.GA13884@agluck-desk2.amr.corp.intel.com>
 <160431588828.397.16468104725047768957.tip-bot2@tip-bot2> <3f863634cd75824907e8ccf8164548c2ef036f20.camel@redhat.com>
 <bfc274fc27724ea39ecac1e7ac834ed8@intel.com>
In-Reply-To: <bfc274fc27724ea39ecac1e7ac834ed8@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 9 Nov 2020 14:36:29 -0800
Message-ID: <CALMp9eTFaiYkTnVe8xKzg40E4nZ3rAOii0O06bTy0+oLNjyKhA@mail.gmail.com>
Subject: Re: [tip: ras/core] x86/mce: Enable additional error logging on
 certain Intel CPUs
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     Qian Cai <cai@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>, Boris Petkov <bp@alien8.de>,
        Borislav Petkov <bp@suse.de>, x86 <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 9, 2020 at 2:09 PM Luck, Tony <tony.luck@intel.com> wrote:
>
> What does KVM do with model specific MSRs?

"Model specific model-specific registers?" :-)

KVM only implements a small subset of MSRs. By default, any access to
the rest raises #GP.

> Looks like you let the guest believe it was running on one of Sandy Bridge, Ivy Bridge, Haswell (Xeon).
>
> So, the core MCE code tried to enable extended error reporting.
>
> If there is a mode to have KVM let the guest think that it read/wrote MSR 0x17F,
> but actually, doesn't do it ... that would seem to be a reasonable thing to do here.

There is an 'ignore_msrs' module parameter, to sink writes and return
zero on reads for unknown MSRs, but I don't think it's commonly used.

I thought Linux had long ago gone the route of turning rdmsr/wrmsr
into rdmsr_safe/wrmsr_safe, so that the guest would ignore the #GPs on
writes and return zero to the caller for #GPs on reads.
