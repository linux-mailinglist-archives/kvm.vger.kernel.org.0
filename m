Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266AC3D187A
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 23:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhGUUUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 16:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhGUUUV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 16:20:21 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70239C061575
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 14:00:57 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gx2so2911199pjb.5
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 14:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6I5eiKz5LAQKzf8N+kryXVb/CNI9CVp9Q8lPmoR5Lz4=;
        b=i9o71rvDTCCzPsaaON5fGSVCSnVCFl1Vdr+IV1L4Cr8GZzTps7Yun21O0Co9SK8spB
         pSiwUN5FaksWku9iCFTusHBmiVeiymNCUnDEjvu38GhcKq2P6ZofbDNLvRBq1zdxZ4UU
         CDNWhKejD4whsJpqem1krybCTAEBmtku3cM61D+NoOu4o1Gi5cY0QLyR2uZpPQqEpl+r
         1t5tx/LLPlUeeHzF5zzYwkvhNBuwZ3q7DH598/xBJ9FsMvmWsQ+Amn/0KoxgBGx0QTx2
         rPP134JqP+2uGzvWnsFcnivFperrPjvUEaY+NUbwJb8/Uwm+hq16LiMufjLS3wK2IwFd
         uWRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6I5eiKz5LAQKzf8N+kryXVb/CNI9CVp9Q8lPmoR5Lz4=;
        b=sPUtKbftAptfPfSVZ4P16JqkPT4Zw1tW5CSCMVSvfvCOVHAdrVu5eAlOoX33rMM0mZ
         4AfpDA8vMkgc3z9260NYZblgTQUJE90JIcXz+PUAjdZspcE3031JweY4VWi/N/MVu0nc
         qYwNRaTxCktxxxyebWl979GLloh4UCNnxLi23TgWRsGE3fmawdsrZHBTV2egpwl/5IXg
         cZysjmMlklw1Hq3OLPN45ozJFG2rzFMcqCUfpeYwfgog3xGYaOp3qB8cmfn92t5dIyIo
         Z/hx4LMDGHjkpIiPwwZBRhI0oPIPBUkrNYuKZI8nV8zfR88YCOv8SBDOHQmmFUo2RuiK
         y+/A==
X-Gm-Message-State: AOAM531lH3tmpFTGS6c8KOJqEXihydUWV3vgO3DetaoZZmpLk3u/7zwa
        nG79L37nERd4dP0dHMGS6bEkCA==
X-Google-Smtp-Source: ABdhPJwTCs1d5J7wRhGKPUQ54pjj0xJ1Xw2lMyhxxlaxbwFgYvvm9uDOXGyA0h/hW+m/zWJxMO5YpQ==
X-Received: by 2002:a17:90a:4d04:: with SMTP id c4mr5488398pjg.148.1626901256629;
        Wed, 21 Jul 2021 14:00:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g2sm23561340pjt.51.2021.07.21.14.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 14:00:55 -0700 (PDT)
Date:   Wed, 21 Jul 2021 21:00:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     harry harry <hiharryharryharry@gmail.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stefanha@redhat.com,
        mathieu.tarral@protonmail.com
Subject: Re: About two-dimensional page translation (e.g., Intel EPT) and
 shadow page table in Linux QEMU/KVM
Message-ID: <YPiLBLA2IjwovNCP@google.com>
References: <CA+-xGqNUX4dpzFV7coJSoJnPz6cE5gdPy1kzRKsQtGD371hyEg@mail.gmail.com>
 <d79db3d7c443f392f5a8b3cf631e5607b72b6208.camel@redhat.com>
 <CA+-xGqOdu1rjhkG0FhxfzF1N1Uiq+z0b3MBJ=sjuVStHP5TBKg@mail.gmail.com>
 <d95d40428ec07ee07e7c583a383d5f324f89686a.camel@redhat.com>
 <YOxYM+8qCIyV+rTJ@google.com>
 <CA+-xGqOSd0yhU4fEcobf3tW0mLb0TmLGycTwXNVUteyvvnXjdw@mail.gmail.com>
 <YO8jPvScgCmtj0JP@google.com>
 <CA+-xGqOkH-hU1guGx=t-qtjsRdO92oX+8HhcO1eXnCigMc+NPw@mail.gmail.com>
 <YPC1lgV5dZC0CyG0@google.com>
 <CA+-xGqN75O37cr9uh++dyPj57tKcYm0fD=+-GBErki8nGNcemQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+-xGqN75O37cr9uh++dyPj57tKcYm0fD=+-GBErki8nGNcemQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021, harry harry wrote:
> Hi Sean,
> 
> Thanks for the explanations. Please see my comments below. Thanks!
> 
> >  When TDP (EPT) is used, the hardware MMU has two parts: the TDP PTEs that
> >  are controlled by KVM, and the IA32 PTEs that are controlled by the guest.
> >  And there's still a KVM MMU for the guest; the KVM MMU in that case knows
> >  how to connfigure the TDP PTEs in hardware _and_ walk the guest IA32 PTEs,
> >  e.g. to handle memory accesses during emulation.
> 
> Sorry, I could not understand why the emulated MMU is still needed
> when TDP (e.g., Intel EPT) is used?
> In particular, in what situations, we need the emulated MMU to
> configure the TDP PTEs in hardware and walk the guest IA32 PTEs?

Ignoring some weird corner cases that blur the lines between emulation and
hardware configuration, the emulated IA32 MMU isn't used to configure TDP PTEs in
hardware, it's only used to walk the the guest page tables.

> Why do we need the emulated MMU in these situations?

For emulation of any instruction/flow that starts with a guest virtual address.
On Intel CPUs, that includes quite literally any "full" instruction emulation,
since KVM needs to translate CS:RIP to a guest physical address in order to fetch
the guest's code stream.  KVM can't avoid "full" emulation unless the guest is
heavily enlightened, e.g. to avoid string I/O, among many other things.
