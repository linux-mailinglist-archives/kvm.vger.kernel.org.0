Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2DC4A6692
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 21:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiBAU40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 15:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiBAU4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 15:56:25 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C47C061714
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 12:56:25 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id i65so16949662pfc.9
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 12:56:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/K6CrouqNGPSnRyT1f52nHMQEEea+SOxraNSciufZcQ=;
        b=L9q2IpeiXJQDBJSV9DS3cKiVk1tVp+zkdvqw3ehFZvdheg7PcUbCDRZBPhIyk71rtV
         LgksLrzm4pydIz/Fseu/imUdzljxVgvdkVfj82Sd3r8xv9COxCiJMoq2nxn6rzvnFHMd
         wZkiY6iCrOzr5vI0m78Qg7BCkNUD5fLKTPIfj031sIfzRYhme9BtS5u2ayojPEdik5p8
         txNvz8+inM0BOrE+lPfj1KMaB+GyyEPRiWeG8U/s3FvZwG/3HYBgr0cgx4oqFS2/NfmI
         vQMD3QDSzXIxHEA/TP9jLwIYHFQaaDCKnZHqrqpRVaKpaNAcIUxDdvI5w2Mtwb+EmGDM
         6ykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/K6CrouqNGPSnRyT1f52nHMQEEea+SOxraNSciufZcQ=;
        b=k1lU2PG6iSrqsZPGkQQh1xAnCCaFz4CjzE1ubcwlNi1fxwbOt0vE7Kds9AaK0x4KIM
         XEWQxP+zL+GTWoIy2+guzjIfY8fVJ/wedJcb+CTsmkdpNj5NX1dbKPkzhjks8MtL/k06
         C6fnrXZwqV6SNC/uq7sJtvsosdIx3p5D/4hMH5xxE373XvdgA+AhCR6Nbpm9dojXTJS3
         8/Pyez726MU1bOri7pH+FHVNmgOyyqNsfZD7rP10D6fMH7ZN++VnvOaQg0+hNVK21peL
         g03vj0iDdsVG8vc3kcnsCYTSroqPWO/8TAOw7yNIuQ9YUXrPE8e2woOR0bTeKQn0hPpI
         IhgQ==
X-Gm-Message-State: AOAM532NcYiVkSv4NE4haMhwmb17y8Mj+guc/pQG0P6vuukUSsMFf29o
        zVw4o/pTm+cIqrifvSrveNKaYE018oPvXg==
X-Google-Smtp-Source: ABdhPJxt4c+g37LTztBQFLWT1J7bKlvLTzRanguek+vZD5dt6E6xBhxeHWepA0+xUSAy5RHKLZPfYg==
X-Received: by 2002:a63:ed10:: with SMTP id d16mr21961918pgi.17.1643748984764;
        Tue, 01 Feb 2022 12:56:24 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u19sm23445170pfi.150.2022.02.01.12.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 12:56:24 -0800 (PST)
Date:   Tue, 1 Feb 2022 20:56:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/5] Kconfig: Add option for asm goto w/ tied outputs to
 workaround clang-13 bug
Message-ID: <YfmedCAn8pK//I2R@google.com>
References: <20220201010838.1494405-1-seanjc@google.com>
 <20220201010838.1494405-2-seanjc@google.com>
 <CAKwvOd=9nwR7z7wn50SU=mf5AywFLd95ZMH-EbYdHfbeHVvq1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=9nwR7z7wn50SU=mf5AywFLd95ZMH-EbYdHfbeHVvq1A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 01, 2022, Nick Desaulniers wrote:
> On Mon, Jan 31, 2022 at 5:08 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Add a config option to guard (future) usage of asm_volatile_goto() that
> > includes "tied outputs", i.e. "+" constraints that specify both an input
> > and output parameter.  clang-13 has a bug[1] that causes compilation of
> > such inline asm to fail, and KVM wants to use a "+m" constraint to
> > implement a uaccess form of CMPXCHG[2].  E.g. the test code fails with
> >
> >   <stdin>:1:29: error: invalid operand in inline asm: '.long (${1:l}) - .'
> >   int foo(int *x) { asm goto (".long (%l[bar]) - .\n": "+m"(*x) ::: bar); return *x; bar: return 0; }
> >                             ^
> >   <stdin>:1:29: error: unknown token in expression
> >   <inline asm>:1:9: note: instantiated into assembly here
> >           .long () - .
> >                  ^
> >   2 errors generated.
> >
> > on clang-13, but passes on gcc (with appropriate asm goto support).  The
> > bug is fixed in clang-14, but won't be backported to clang-13 as the
> > changes are too invasive/risky.
> 
> LGTM.
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> 
> If you're going to respin the series, consider adding a comment in the
> source along the lines of:
> ```
> clang-14 and gcc-11 fixed this.
> ```
> or w/e. This helps us find (via grep) and remove cruft when the
> minimum supported compiler versions are updated.

Will do, a new version is definitely needed.

> Note: gcc-10 had a bug with the symbolic references to labels when
> using tied constraints.
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=98096
> 
> Both compilers had bugs here, and it may be worth mentioning that in
> the commit message.

Is this wording accurate?

  gcc also had a similar bug[3], fixed in gcc-11, where gcc failed to
  account for its behavior of assigning two numbers to tied outputs (one
  for input, one for output) when evaluating symbolic references. 
