Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CAB1C303F
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 01:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgECXI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 19:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725844AbgECXI6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 3 May 2020 19:08:58 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B7CC061A0E
        for <kvm@vger.kernel.org>; Sun,  3 May 2020 16:08:58 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id i19so10452857ioh.12
        for <kvm@vger.kernel.org>; Sun, 03 May 2020 16:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xmv52Nwfwd0x4xdIzVral8na1/YwJTOaWPbe9s+fhXY=;
        b=c7x24dYBuwuz4XZ1Qlim/1tNfcocvdFTJj+3ick3mabQH5ObOGlkVHjD+s9XDd+lQk
         mxMyHTHLNWUfmGn1KlnjJthqcyFHYUijkNnvjIXXG4zWhBQeqkMYjmF/TIde4rX/4lzr
         tYrTDbFe9myOBeMPa+RKcDBaOi/LApSIKOn/sNP+4OAIB8EW4wYs8ElEJWFlmLdZuxPS
         SSMfmW5uhRUUwvzGpQAlEcUIZzR3sbLtYid1EnQxkpxA4VPiOI8xvn6spelmPnhCorj4
         UsVd6EgskyGtq7bpcQoKSdx+b6TgycD64yfaUtZkKvJZ9W4t6eHRH1LWjm8metW2yQ+R
         hqCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xmv52Nwfwd0x4xdIzVral8na1/YwJTOaWPbe9s+fhXY=;
        b=J4VE5nimUE7wUfbhQrGM0DFGwmwCFDN30Uf8GbCuhn9Dm1S7qc9cPci664XeAdlrXk
         YF+utQj8eYCzdnbW5YuJi820P7DiS2RiRL1UolkbpNDKoNNqSoLNbRtVYpZ/aYOoDAYJ
         97+B1UeDJsf7EVrFQd12QY9kmgs3dOliGwdIghUNZd4omqj8Rhlio+KJyoIzJ64i6MWH
         H7FsIyszeQtkaanhfVDkLMBIW2iyVJ/t+14NRa0lBA73ksPXRSwpw6F3XeqEFCwZnJcx
         zAIX7IHgy2IJgKu4/0+ssuqlWEn19TZDyANRqoP+aCTr8k1WqMrbcI6pQa+P6onLACI+
         CRGg==
X-Gm-Message-State: AGi0PuZQhPsrIMMkj6PyTXQ6C7FNYXABl6PrgPY3q9o4Rtafk6cx57ww
        pe+Zp2k1VjQIoEeoeUjDuoJu4np00I3dGgVa0NU=
X-Google-Smtp-Source: APiQypJbaFRfKZ0/JV3OZUsrOR5L+J1CEhCn5OUAx6O6GFBOen5U+zy/jK1TIp8gsi1jF+pAQ5DtPh1nOEbFwpH3WF4=
X-Received: by 2002:a6b:14d0:: with SMTP id 199mr13245481iou.11.1588547337661;
 Sun, 03 May 2020 16:08:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200426115255.305060-1-ubizjak@gmail.com> <fcf019d2-0481-5d10-76fa-4d86e8b8c4e6@redhat.com>
 <CAFULd4aa56=bCrYx0-d3cwHt6C7b3GSenfkuuroV19ZZ880whw@mail.gmail.com>
In-Reply-To: <CAFULd4aa56=bCrYx0-d3cwHt6C7b3GSenfkuuroV19ZZ880whw@mail.gmail.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Mon, 4 May 2020 01:08:46 +0200
Message-ID: <CAFULd4aUo3SrmtgHLixXy96haTaUt_SydOuY28VfDLuEx8rceQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: VMX: Improve handle_external_interrupt_irqoff
 inline assembly
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 4, 2020 at 12:23 AM Uros Bizjak <ubizjak@gmail.com> wrote:
>
> On Tue, Apr 28, 2020 at 3:48 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 26/04/20 13:52, Uros Bizjak wrote:
> > > Improve handle_external_interrupt_irqoff inline assembly in several ways:
> > > - use "n" operand constraint instead of "i" and remove
> > >   unneeded %c operand modifiers and "$" prefixes
> > > - use %rsp instead of _ASM_SP, since we are in CONFIG_X86_64 part
> > > - use $-16 immediate to align %rsp
> > > - remove unneeded use of __ASM_SIZE macro
> > > - define "ss" named operand only for X86_64
> > >
> > > The patch introduces no functional changes.
> >
> > I think I agree with all of these, so the patch is okay!  Thanks,
>
> Actually, after some more thinking, neither "i", and neither "n" is
> correct for x86_64 as far as push is concerned. The correct constraint
> is "e", but in case the value doesn't fit this constraint, we have to
> allow "r" and eventually "m". Let's use "rme", which allows everything
> the insn is able to handle, and leave to the compiler to use the
> optimal one. GCC uses this constraint internally, and it also fits
> 32bit targets.

And yes... I forgot that "m" allows stack slots, which won't fly due
to clobbered stack pointer.

> V3 patch is in the works.

V4, actually. Sorry for the mess.

Uros.
