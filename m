Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A43138E05D
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 06:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhEXEbc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 00:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhEXEba (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 00:31:30 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862FEC061574
        for <kvm@vger.kernel.org>; Sun, 23 May 2021 21:30:02 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so10406289pjv.1
        for <kvm@vger.kernel.org>; Sun, 23 May 2021 21:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gKlhqQXM4UBJP6nopL7HhB9INiyQffua7cr3HwkBZ3Y=;
        b=YIz1361Haj6fycLVqZNIpw9DVTZefr/Q0N9dFydkS+BcaySvcHUBsAxRb99Ra8r8X2
         Z2hSQOJwy1CLpffwFcDKg2Ybi2ZXkYC3oahSiJZt2x6I4Ah2vq0Kho7ENY1iz4z6dXX/
         jzd8k9zDZZVXESgmnbPqsTX5kTfu6U+hSPwTG0b3thkA/VPjoTvndHO45r/LGEAO+U4E
         GnD0jmeY+cbeV0G04z08HaOP93bU5isTzdtY7uBWfudreyIomSbBM2bpJvJ9Zrhh98we
         HMy2mVoBmlCZqmbkP1o+daVVJPgGog2789RAaD4VOTWvKpgNCcZRSe82UpuMSPmpDd/x
         4gAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gKlhqQXM4UBJP6nopL7HhB9INiyQffua7cr3HwkBZ3Y=;
        b=hYaU2+5ebiAM37hPIoNIfpwYySf2KJB5/q5ph5Wd+lTef5K/odIg8x3fc01Oepl8G/
         lx9y1n33LIjUlFsNX+rHOO4DMFQN2E7+tsui0rOjtfdGBCO01jaNdO59EmbLLQzvULhM
         HNZ+rppKJVwtpawFniYOokB3U+Vhz8h6GqvAgEv8DVcm5nW3N1ZGzegSOurrY1TvuCHM
         QnqakXOBuB1TDeD1A/YscAgUbg0yGGljWHxFMwPsPkPzO5jr99tAGwy3n56IzDIQO+b9
         VGB8puY/cjA6G2wA5lw2Mvn8y9AwIr4VRLSYbn/GfB89gWmrPAg3oaTA0Rw/BA3rf3aH
         5fCw==
X-Gm-Message-State: AOAM532R791qedhRVgFOtqXajiMVBJyff0njB/e8yDoRiKYj9CzEGtwA
        0VzmReBhxuiDmeFxD9g2wVBpwjXYd3CBn++d4C5nmA==
X-Google-Smtp-Source: ABdhPJzgYSfiFrtDLI8M3DaRA9/D7QjOG52lRd7C4La+BN0h68YjrvOXospjM2pYNI1FocKlwXWfikb3csO4MybtZ/0=
X-Received: by 2002:a17:902:f20c:b029:f0:af3d:c5d8 with SMTP id
 m12-20020a170902f20cb02900f0af3dc5d8mr23344483plc.23.1621830601820; Sun, 23
 May 2021 21:30:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-3-seanjc@google.com>
 <CAAeT=FyNo1CGvnamc3_J9EEQUn6WcdkMp50-QgmLYYVCFA2fZA@mail.gmail.com>
 <YKVdUtvSg7/I7Ses@google.com> <CAAeT=FxvS_hzcZbZQ_jQnWwX+xDT0SqQoHKELeviqu_QvvnbYg@mail.gmail.com>
 <YKfRj+I2Wa+t//lb@google.com>
In-Reply-To: <YKfRj+I2Wa+t//lb@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sun, 23 May 2021 21:29:46 -0700
Message-ID: <CAAeT=FxuBEY1C7MMQ5f34-AbQjtDRAgVeR88LkS9=763dCjb=A@mail.gmail.com>
Subject: Re: [PATCH 02/43] KVM: VMX: Set EDX at INIT with CPUID.0x1, Family-Model-Stepping
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > On Tue, May 18, 2021, Reiji Watanabe wrote:
> > > > BTW, I would think having a default CPUID for CPUID.(EAX=3D0x1) wou=
ld be better
> > > > for consistency of a vCPU state for RESET.  I would think it doesn'=
t matter
> > > > practically anyway though.
> > >
> > > Probably, but that would require defining default values for all of C=
PUID.0x0 and
> > > CPUID.0x1, which is a can of worms I'd rather not open.  E.g. vendor =
info, basic
> > > feature set, APIC ID, etc... would all need default values.  On the o=
ther hand,
> > > the EDX value stuffing predates CPUID, so using 0x600 isn't provably =
wrong, just
> > > a bit anachronistic. :-)
> >
> > I see... Then I don't think it's worth doing...
> > Just out of curiosity, can't we simply use a vcpu_id for the APIC ID ?
>
> That would mostly work, but theoretically we could overflow the 8 bit fie=
ld
> because max vCPUs is 288.  Thanks Larrabee.
>
>   commit 682f732ecf7396e9d6fe24d44738966699fae6c0
>   Author: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
>   Date:   Tue Jul 12 22:09:29 2016 +0200
>
>     KVM: x86: bump MAX_VCPUS to 288
>
>     288 is in high demand because of Knights Landing CPU.
>     We cannot set the limit to 640k, because that would be wasting space.
>
> > Also, can't we simply use the same values that KVM_GET_SUPPORTED_CPUID
> > provides for other CPUID fields ?
>
> Yes, that would mostly work.  It's certainly possible to have a moderatel=
y sane
> default, but there's essentially zero benefit in doing so since practical=
ly
> speaking all userspace VMMs will override CPUID anyways.  KVM could compl=
etely
> default to the host CPUID, but again, it wouldn't provide any meaningful =
benefit,
> while doing so would step on userspace's toes since KVM's approach is tha=
t KVM is
> "just" an accelerator, while userspace defines the CPU model, devices, et=
c...
> And it would also mean KVM has to start worrying about silly corner cases=
 like
> the max vCPUs thing.  That's why I say it's a can of worms :-)

Ah, I see.  Thank you for the answer and the helpful information !

Regards,
Reiji
