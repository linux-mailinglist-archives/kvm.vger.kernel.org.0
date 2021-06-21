Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00063AF51D
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 20:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhFUSdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 14:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbhFUSdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 14:33:43 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2B1C061574
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 11:31:27 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id h9so8413402oih.4
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 11:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b0z3SnOjdByYCusiaWRhpgFnNMjGbloRor2UMReTdAU=;
        b=ezyiwYDIXMixTaiQx7t705ryBmU7uwaEQzIsQNfCkLbZV6ik1qIZWt15dL1TQpxMvf
         I4H6GCKhWKkEamKg6ndsSVwrHyWMpwZv/yw1luaOBTRdN8M3Mo18k+CCHEPLD3RgQKoH
         SOrqouMW9fGsNHZwDNYUojMehuU6Gt6cBWaOQSqfybc7uCQp0O733s+z0wfrHSr1a4+6
         Ow1NtF6aZFGLrxbt/1Uvm19K1degpP/qrPTZA7SZAehaUVjO1mgktgXUKVYwXD8jJgej
         ph+OX5ELY6HphXYK0siyK+3NG/vXe/Cy7mDTmLRavF0dVrSJBsfUrK325RT+sXSm7078
         JjtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b0z3SnOjdByYCusiaWRhpgFnNMjGbloRor2UMReTdAU=;
        b=UQKmg4Mhy/1GnQB4laAVkhBOrDWfQvCSjp/Ec6KdJElXVNc05zhV4yr+A6lP1cXe+F
         daoh8F433Ob9ImOllph4vcnrGbNAwa12XGa9+49yZadvd9lTcSvXPyURTmMtpLpgtUO3
         khT4GjJ6XZUBgzlD5cDEuhBXyhwzLWwNUbhY1wTsuUL+9H5SHQ6+RSc3BrzVTW1A4x2C
         +DXb8J5P8F8mCJV0rc55tBgv9evVTBD3gk1EHhzHMoAq45O5QKclCtzoBAQHRAaj9ncf
         gdK7ul+M8wvCay+SHNX2mBrPfkBIAlgv8jZc/ksFQgQd6JcrPwNAmkpMzjA+LSK2/et9
         KsFw==
X-Gm-Message-State: AOAM532c+bb2RyV77BEfdpFLxZwmkuXPuR/nWqvl0CkWhJQqDdgOWINP
        i62QptyrWPS/fV9p7WCz0bs/1IDmSL4ulqVx0vkB+LeGFoTflw==
X-Google-Smtp-Source: ABdhPJzGBk3QK4lBtkFUIMORjH1rTbcYNoX0RRkQY8p0IsllSOu2o5t/q5HUij6VJ3MmTtLq0x+8yo+3+yURiXAuu2Q=
X-Received: by 2002:aca:a983:: with SMTP id s125mr26065600oie.13.1624300286696;
 Mon, 21 Jun 2021 11:31:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200710154811.418214-1-mgamal@redhat.com> <20200710154811.418214-8-mgamal@redhat.com>
 <CALMp9eSbY6FjZAXt7ojQrX_SC_Lyg24dTGFZdKZK7fARGA=3hg@mail.gmail.com>
 <CALMp9eTFzQMpsrGhN4uJxyUHMKd5=yFwxLoBy==2BTHwmv_UGQ@mail.gmail.com>
 <20201023031433.GF23681@linux.intel.com> <498cfe12-f3e4-c4a2-f36b-159ccc10cdc4@redhat.com>
 <CALMp9eQ8C0pp5yP4tLsckVWq=j3Xb=e4M7UVZz67+pngaXJJUw@mail.gmail.com>
 <f40e5d23-88b6-01c0-60f9-5419dac703a2@redhat.com> <CALMp9eRGBiQDPr1wpAY34V=T6Jjij_iuHOX+_-QQPP=5SEw3GQ@mail.gmail.com>
 <4463f391-0a25-017e-f913-69c297e13c5e@redhat.com> <CALMp9eRnjdJtmU9bBosGNAxa2pvMzB8mHjtbYa-yb2uNoAkgdA@mail.gmail.com>
 <CALMp9eR2ONSpz__H2+ZpM4qqT7FNowNwOfe4x9o-ocfhwRnEhw@mail.gmail.com> <CALMp9eTyoVwvkc6YH9oBPP74dABJmUsA0Gz98+O+5kANHobWbQ@mail.gmail.com>
In-Reply-To: <CALMp9eTyoVwvkc6YH9oBPP74dABJmUsA0Gz98+O+5kANHobWbQ@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 21 Jun 2021 11:31:15 -0700
Message-ID: <CALMp9eRWa+SryhQUzSzjiN=PPwtd8JWheYJU67JUQLMcBY9UMQ@mail.gmail.com>
Subject: Re: [PATCH v3 7/9] KVM: VMX: Add guest physical address check in EPT
 violation and misconfig
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mohammed Gamal <mgamal@redhat.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 27, 2021 at 12:57 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Wed, Jan 20, 2021 at 1:16 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Fri, Jan 15, 2021 at 11:35 AM Jim Mattson <jmattson@google.com> wrote:
> > >
> > > On Fri, Oct 23, 2020 at 10:43 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > >
> > > > On 23/10/20 19:23, Jim Mattson wrote:
> > > > >> The information that we need is _not_ that provided by the advanced
> > > > >> VM-exit information (or by a page walk).  If a page is neither writable
> > > > >> nor executable, the advanced information doesn't say if the injected #PF
> > > > >> should be a W=1 or a F=1 fault.  We need the information in bits 0..2 of
> > > > >> the exit qualification for the final access, which however is not
> > > > >> available for the paging-structure access.
> > > > >>
> > > > > Are you planning to extend the emulator, then, to support all
> > > > > instructions? I'm not sure where you are going with this.
> > > >
> > > > I'm going to fix the bit 8=1 case, but for bit 8=0 there's not much that
> > > > you can do.  In all likelihood the guest is buggy anyway.
> > >
> > > Did this drop off your radar? Are you still planning to fix the bit8=1
> > > case to use advanced EPT exit qualification information? Or did I just
> > > miss it?
> >
> > Paolo,
> > If you're not working on this, do you mind if I ask Aaron to take a look at it?
>
> Ugh. The advanced EPT exit qualification contains nothing useful here,
> AFAICT. It only contains x86 page protection information--nothing
> about the access itself.

BTW, I don't think this patch is complete. In particular, L0 needs to
take first crack at any L2 #PF intercepts for present, not-reserved
faults, to see if it needs to set the RSVD flag in the error code.
