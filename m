Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7F424AD14
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 04:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgHTCrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 22:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgHTCri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 22:47:38 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFED4C061384
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 19:47:36 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id l204so818091oib.3
        for <kvm@vger.kernel.org>; Wed, 19 Aug 2020 19:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xfDH+S997URl4jyz8F0i4sHZ1MqQgFzjhRKMHTCjfHo=;
        b=gVPWYW+3j/AcWKLc3KV4NYbhQITuq5Q/GEeFgOh5PfQTlqj7vQvilcmgmIllA8t4eX
         Sdk3sdnbs60wBu1xObrnZoPB7l4CzCJ9mLg26fpDRUE8tY6w/epVGJ58psd2w/W+fMJt
         vAInXmH2HvOVw6c14vKndSF6OeLggz+nTgLjYCd8Z57kGr4hKZGSY9hwfTt9hS7QSobF
         dsWsM+vJmB9IYHksv/yd3Oo6Nzfr2Y+MUvYjyK0ubeJEaVueMZs5I1ww05HDqGaQTCLT
         ro4dG/4d/vEf4u+rd3siB8GN8oJp0QvBFeNI0xz+MT3l2aDpjkyamQ38OWv/Y49NTvyd
         rs1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xfDH+S997URl4jyz8F0i4sHZ1MqQgFzjhRKMHTCjfHo=;
        b=rLljHApRghKVauZnTNXxlbXoeCIa7XxJZIKOQwYGWohdTkylYIL42tfwWPX15S9vcg
         zeNHFxdq+jnp05kzs6317hyN4nh+1y1vp+OZkvV39AtYWC24jzi4qAbNdLn7ZofCiqUt
         GZqPrnyb13GR1BqdonLVkTHFJsWdELeVUZZOPwr4wIE7wJ+O62zS6smbB/rHj5+2hM2h
         USjqcVhtsnXwJOtTRCli0/Srdgv8Yg5jEveFc99HthLXK76BCEhZH9m1L4v7Mwp6n5eF
         cKPNpQlcmQjYwv0l69cEI9MO1c7XMUxF5cC1pu59kjPMnSHLXw7DcWe92Oyr5T5LVF+2
         Q4vA==
X-Gm-Message-State: AOAM5320HxBrOrdtzPG2d14aR9XaKY/ZVIf0RW4qEhlmkR1h/SPmCAoE
        lZbCtRCtde9iODkHkBAYzKqL+QO0+ueHITt2INXR7w==
X-Google-Smtp-Source: ABdhPJyh0hXm+lKNMNH5D6Pu1Tq7QjFjPmmIR6tcSPaTylPqNuKgpQjK0/iYSEFIqpyvSDC/lfaIvQwqqjAA+YaewVs=
X-Received: by 2002:aca:670b:: with SMTP id z11mr671653oix.6.1597891652183;
 Wed, 19 Aug 2020 19:47:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200803211423.29398-1-graf@amazon.com> <CALMp9eRHmhmKP21jmBr13n3DvttPg9OQEn5Zn0LxyiKiq2uTkA@mail.gmail.com>
 <B0FD5408-E2C1-444C-AFCE-7C622EA75F66@amazon.de> <CALMp9eS5+mV2SC-v4gusocrWtXpm-QzGoOTDGhFS9NEmuVNTDw@mail.gmail.com>
In-Reply-To: <CALMp9eS5+mV2SC-v4gusocrWtXpm-QzGoOTDGhFS9NEmuVNTDw@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 19 Aug 2020 19:47:21 -0700
Message-ID: <CALMp9eTDJx9PNDwi+O-_b9O6tBAWEvW-0RAoHYV7inEhw+b42Q@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] Allow user space to restrict and augment MSR emulation
To:     "Graf (AWS), Alexander" <graf@amazon.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 19, 2020 at 3:09 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Wed, Aug 19, 2020 at 2:46 PM Graf (AWS), Alexander <graf@amazon.de> wrote:
>
> > Special MSRs like EFER also irritate me a bit. We can't really trap on them - most code paths just know they're handled in kernel. Maybe I'll add some sanity checks as well...
>
> Why can't we intercept EFER?

Some MSRs (IA32_GSBASE comes to mind) can't be completely handled by
userspace, even if we do intercept RDMSR and WRMSR. The EFER.LMA bit
also falls into that category, though the rest of the register isn't a
problem (and EFER.LMA is always derivable). Is that what you meant?
