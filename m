Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECCA3DFBA5
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 08:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235714AbhHDHAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 03:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbhHDHAE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 03:00:04 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AD7C0613D5
        for <kvm@vger.kernel.org>; Tue,  3 Aug 2021 23:59:50 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id u3so2722053lff.9
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 23:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FyMnszXXyHK4JDa0x/iclyGuG1G0X7e/HsoyPTG9034=;
        b=O4ScIbiiu9dQgWr9MYBsJ7D7L5y53rgIr6rBY0Al0x6bLaD/QC54vpgVaAnYS29zlG
         wkTjmNUfxliTIQ0aQU0OZEKx3pSAgIwaYbrBd1b1EdRvMIRH/oScbeKx6KYqu9swRn2z
         AZxgEa8Lx7vQXXGr8x6tIAiHo+Z7DH/t638EfZLab02YuiXMkqPWdCqWjfTQi3GF7qc2
         2aPloOXQpeBfUEMuah/ScHkmRqOGL7yVTNpRmH80JSlRIDGcHGk3W53rikKcZOO4W5AF
         BrdYfrxYYa6MBdMuPOubwecXugERvoLpUwVVLNrk/9pAsbsWG8GIQ1HzzXBMUjA62zoJ
         RdMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FyMnszXXyHK4JDa0x/iclyGuG1G0X7e/HsoyPTG9034=;
        b=mfgfZb7XTo8tZUSMjkw1xXYa9B1mwjm0w2fZJe4JpSFMCzRCA1pNi/WFfd23ln+E+p
         i/1X40fwXxyAr3ZMaAd3P9Zf13R1ntkNj9xzyOk1Y00vUvr9jpJUg/fI6Yhafmt/6kFD
         md3BPc+IkoFNZQrstUpSwaDgjnt1DgLV3pArTq9tiTrFzNj3qaBPzst7VTuNmMvSIZop
         eD7jjTYIOkcaLtGYSaCWrxEcpLZlxeT+Ie0I1w3iFaJVZdbqbPEeVG1B8buwaFWtdom5
         fQ7IoWW1y7xcEU34/F0mnCrZOyP3wQQJhcOsmVhhBJAeLAaJIBuVt6JnlLUvys0E3tM1
         YCkw==
X-Gm-Message-State: AOAM53296VUK1kES+yur1LRJn+EwuCsUn2rAZPuiNx4mwEAZ+6SjpDAz
        Be2kyzMPHzAlVTr+jliBfScSAH89ak0opS0Iv+tSZA==
X-Google-Smtp-Source: ABdhPJw2rUXELmIWFkaMKtzqgTKfHrd105kgYzO8xlzBjLxsLAtt/jBBP3NH6qpDRWX+ZhCBAP9JdOZwYa8M2d7kCpc=
X-Received: by 2002:a05:6512:314a:: with SMTP id s10mr1127161lfi.57.1628060388794;
 Tue, 03 Aug 2021 23:59:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com> <20210729173300.181775-12-oupton@google.com>
 <875yws2h5w.wl-maz@kernel.org> <CAOQ_QsgCrEWQqakicR3Peu_c8oCMeq8Cok+CK8vJVURUwAdG0A@mail.gmail.com>
 <87wnp722tm.wl-maz@kernel.org> <CAOQ_QsiwuancUsFEVr3TBeP6yLZMfAqNRv3ww2H+hcUGfxs9LA@mail.gmail.com>
In-Reply-To: <CAOQ_QsiwuancUsFEVr3TBeP6yLZMfAqNRv3ww2H+hcUGfxs9LA@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 3 Aug 2021 23:59:37 -0700
Message-ID: <CAOQ_QsiChO1mGGOFL96d35bbLaUBXyYf9cZw1h-Cf3G4P=1YXg@mail.gmail.com>
Subject: Re: [PATCH v5 11/13] KVM: arm64: Provide userspace access to the
 physical counter offset
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Jul 30, 2021 at 9:48 AM Oliver Upton <oupton@google.com> wrote:
>
> On Fri, Jul 30, 2021 at 9:18 AM Marc Zyngier <maz@kernel.org> wrote:
> > You want the ARM FVP model, or maybe even the Foundation model. It has
> > support all the way to ARMv8.7 apparently. I personally use the FVP,
> > get in touch offline and I'll help you with the setup.
> >
> > In general, I tend to trust the ARM models a lot more than QEMU for
> > the quality of the emulation. You can tune it in some bizarre way
> > (the cache modelling is terrifying), and it will definitely do all
> > kind of crazy reordering and speculation.
>
> Awesome, thanks. I'll give this a try.
>

I have another spin of this series ready to kick out the door that
implements ECV support but ran into some issues testing it... Seems
that the ARM Foundation model only implements ECV=0x01, when we need
ECV=0x02 for CNTPOFF_EL2 to be valid. Any thoughts, or shall I just
send out the series and stare at it long enough to make sure the ECV
parts look right ;-)

--
Thanks,
Oliver
