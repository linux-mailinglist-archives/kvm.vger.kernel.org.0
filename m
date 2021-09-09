Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE4A405B1B
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239044AbhIIQoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239381AbhIIQnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 12:43:37 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275FFC061762
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 09:42:28 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id z18so5117836ybg.8
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 09:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BrZuPjCWVQei2hd5TDze97f6NPaJL6ui4tNC7eiVKwg=;
        b=jGcmb5hbR4l+02tTppChZrB5upTNg//Nka7dpsrOEijk0J1X2X+D/NqH66FmMzewXT
         OJWjExeSkG1Hy6H9vzjhlErhjmpKe4y83gbr20jwrR6r7dlISolwMNML2hd5PNE1uBuD
         bQ4X3mgbfSsVUu8/hAY3BY6plretWRWi7U8EzbkxjEC+BZ6Yr5GDLDGi4OEYBQkj0fxZ
         WhBGCoX3mtKxn8yDhth/YJVISfiBUVOBHrSiZWG8RLsb64wBybXnoEzboBQ+fkNngvZZ
         s7kq04sSh9lLJpbBWPoRRkuIDnniaDVgXZQEP7A5TwEimgeeRN6ZIhq1ZhRK61BwF1lK
         sZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BrZuPjCWVQei2hd5TDze97f6NPaJL6ui4tNC7eiVKwg=;
        b=zjh9O+VpWMnQZ+O+9EHi1JzkDnnnGVwZnOs7BsCsf/EjFEh9RHfLgSq2/ZHa0b/kUu
         0vT/VELph9EDHgqAl2f73mV/FKsI5BjpkqgjBvsJdPGL+ndMjjoXLVG/EBE7xEQ2WvP/
         vPlUCUYFmhePSXI9dG0vLU50cEmnI5QW45T7xyLCr4aDE+SobbPXsCC9QCmSgnx0Top4
         1gOLXORmMoFZBMOtlKk7KvOT1cFvqDPaC8IcumMIHtisqUMhwesNAKdDwLcUsWe/GjIH
         A5JbVIk7fIyme6H+cVmUF3bSl8RlhzTV+zWFOjEsXXtUjTaEvFqgEIw/tNJiUNGJhw1J
         +oaw==
X-Gm-Message-State: AOAM5310nP+2IUl8PYABp393eTrFWY1LWuSAL0XKpeGeBHmrT+aH7uTI
        9XNQie/USiDWs1mvVZXgH/bljyRLNIr3lFyyzezjSg==
X-Google-Smtp-Source: ABdhPJxUfv2OiYmJzLbjvFvpiM3on92xSiPiWN63qMNZXpuT/lL9Yvzo1kzzotX3Jfc71OoRLpnPsZqr+apdMwCxiAk=
X-Received: by 2002:a25:424a:: with SMTP id p71mr5281009yba.243.1631205747023;
 Thu, 09 Sep 2021 09:42:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com> <20210909013818.1191270-3-rananta@google.com>
 <CAOQ_Qsh=F-tTre_ojiLXUfAriH-coTF_gXCcLyRb3kKM+LLhQA@mail.gmail.com> <20210909065338.ulh32fqi4e6gnh2o@gator>
In-Reply-To: <20210909065338.ulh32fqi4e6gnh2o@gator>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 9 Sep 2021 09:42:15 -0700
Message-ID: <CAJHc60zoCVpG+zx_G8fSCcg+wXaigFZFGA=wLZCAsETag+YJfA@mail.gmail.com>
Subject: Re: [PATCH v4 02/18] KVM: arm64: selftests: Add sysreg.h
To:     Andrew Jones <drjones@redhat.com>
Cc:     Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 8, 2021 at 11:53 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Wed, Sep 08, 2021 at 10:47:31PM -0400, Oliver Upton wrote:
> > Hi Raghu,
> >
> > On Wed, Sep 8, 2021 at 9:38 PM Raghavendra Rao Ananta
> > <rananta@google.com> wrote:
> > >
> > > Bring-in the kernel's arch/arm64/include/asm/sysreg.h
> > > into selftests to make use of all the standard
> > > register definitions in consistence with the kernel.
> > >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > ---
> > >  .../selftests/kvm/include/aarch64/sysreg.h    | 1278 +++++++++++++++++
> > >  1 file changed, 1278 insertions(+)
> > >  create mode 100644 tools/testing/selftests/kvm/include/aarch64/sysreg.h
> >
> > This belongs in tools/arch/arm64/include/asm/sysreg.h, I believe.
> >
>
> Yes, that's also where I expected it to land.
>
Sure, that makes sense. I'll move it there.

Regards,
Raghavendra
> Thanks,
> drew
>
