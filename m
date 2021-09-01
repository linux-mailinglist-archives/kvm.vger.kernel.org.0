Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9F33FDF69
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 18:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245080AbhIAQKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 12:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245060AbhIAQKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 12:10:11 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B5FC061764
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 09:09:14 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 7so170931pfl.10
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 09:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FB3R6LeGmuXIo5hb7U8C3iodva/c8R+NqVfhGgpP4U0=;
        b=s6xT8b9Z5MvXugh9aE3DH7QviFfmTsm+/948fGHfnT/mxvPoY35pWzy8+Nntmc8vGo
         j4mblX+ULT64l4hiDNIOv++Vip0QN/JubwFNtkFgY/Px0wrggu7hLqttAQJmAbYcS+xd
         SFlvZdaw/VW/WKp60BgUJ0pUIMD7cUwaxFYfwicMx3B67b2sQXKqdVCfA3Khi1+Galcn
         nfGsJkjlTvv/b+jcENcBfs+qUOgdgJcTVf2N2jHJ2h2MtI33N8e3teUaTqp863Yshi9U
         n+bKbyi/1HJH+hxR4rvibLjMsprRp9QNvrLhIMXEDsolU7Sll3aow9Xd1nf0tVSMZaH2
         f7Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FB3R6LeGmuXIo5hb7U8C3iodva/c8R+NqVfhGgpP4U0=;
        b=nAlXrmwXNvvWAh7KNPlAkG4BJiAmfmrFhrzqFGf9yeRw8w3Irey5CAAPLGngY5EXjT
         8Kx8mcdvliA5WU8v9VizXxC6lGT246vji9JTt0Omy0mdRE5Hn6cRuyecdO7uasKZZGP3
         SoAr/L1cXrczk0ChDtGV0YPMIwVfRTcxFQfUW/GadJKqk1gulLSavbIrQyH+P9m6Lek6
         KcBLhIHHer66UKLFRsP8HxgqheSTqTCO0Oz4YPJIU6QrsLs2MCY/NAjj2+7bR1HMOBf4
         wWbvi0plBrcYh3cjPvKnqdLJxjaa+P/b1Cgzo9OxrYFRHSp8D7TZlXJAQdqX3/6KRk1v
         3/6g==
X-Gm-Message-State: AOAM531nLQ+43nyDV1XVFk+k90Cli0K2AN4DQxvsAG4e/zawPn2oR0JY
        suMcK83azUqBOYvcPlaC7JVxaw==
X-Google-Smtp-Source: ABdhPJxmvrUQTF6cUfVAdaaPU2mA6Fq+mBMHqFjB1d+G1mMoFmXqzvvBPt3F0qi34nZxQ/5t0yJd8Q==
X-Received: by 2002:a63:784d:: with SMTP id t74mr218780pgc.112.1630512553446;
        Wed, 01 Sep 2021 09:09:13 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a10sm1021pfg.20.2021.09.01.09.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 09:09:12 -0700 (PDT)
Date:   Wed, 1 Sep 2021 16:09:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+200c08e88ae818f849ce@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/3] Revert "KVM: x86: mmu: Add guest physical address
 check in translate_gpa()"
Message-ID: <YS+lpeqHHgoA6W8A@google.com>
References: <20210831164224.1119728-1-seanjc@google.com>
 <20210831164224.1119728-2-seanjc@google.com>
 <87pmtsog4c.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmtsog4c.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > Revert a misguided illegal GPA check when "translating" a non-nested GPA.
> > The check is woefully incomplete as it does not fill in @exception as
> > expected by all callers, which leads to KVM attempting to inject a bogus
> > exception, potentially exposing kernel stack information in the process.
> >
> >  WARNING: CPU: 0 PID: 8469 at arch/x86/kvm/x86.c:525 exception_type+0x98/0xb0 arch/x86/kvm/x86.c:525
> >  CPU: 1 PID: 8469 Comm: syz-executor531 Not tainted 5.14.0-rc7-syzkaller #0
> >  RIP: 0010:exception_type+0x98/0xb0 arch/x86/kvm/x86.c:525
> >  Call Trace:
> >   x86_emulate_instruction+0xef6/0x1460 arch/x86/kvm/x86.c:7853
> >   kvm_mmu_page_fault+0x2f0/0x1810 arch/x86/kvm/mmu/mmu.c:5199
> >   handle_ept_misconfig+0xdf/0x3e0 arch/x86/kvm/vmx/vmx.c:5336
> >   __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6021 [inline]
> >   vmx_handle_exit+0x336/0x1800 arch/x86/kvm/vmx/vmx.c:6038
> >   vcpu_enter_guest+0x2a1c/0x4430 arch/x86/kvm/x86.c:9712
> >   vcpu_run arch/x86/kvm/x86.c:9779 [inline]
> >   kvm_arch_vcpu_ioctl_run+0x47d/0x1b20 arch/x86/kvm/x86.c:10010
> >   kvm_vcpu_ioctl+0x49e/0xe50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3652
> >
> > The bug has escaped notice because practically speaking the GPA check is
> > useless.  The GPA check in question only comes into play when KVM is
> > walking guest page tables (or "translating" CR3), and KVM already handles
> > illegal GPA checks by setting reserved bits in rsvd_bits_mask for each
> > PxE, or in the case of CR3 for loading PTDPTRs, manually checks for an
> > illegal CR3.  This particular failure doesn't hit the existing reserved
> > bits checks because syzbot sets guest.MAXPHYADDR=1, and IA32 architecture
> > simply doesn't allow for such an absurd MAXPHADDR, e.g. 32-bit paging
> 
> "MAXPHYADDR"

Gah, I'm pretty sure I mistype that 50% of the time.

> I'm, however, wondering if it would also make sense to forbid setting
> nonsensical MAXPHYADDR, something like (compile-only tested):

That crossed my mind as well, but I actually think letting userspace provide
garbage is a good thing in this case.  From a kernel-safety perspective, KVM
does not and _should_ not make any assumptions about guest.MAXPHYADDR.  IMO, the
added test coverage gaind by allowing truly outrageous values outweighs the
potential danger, e.g. this bogus code would likely have gone unnoticed forever.
