Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F2B316F38
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 19:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbhBJSwH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 13:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbhBJSuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 13:50:01 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C9DC061756
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 10:49:21 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id x9so1715141plb.5
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 10:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PrXct6DxGDPic1inZjhVX9QRlhCGy/nKux4XIfvSnek=;
        b=M55pfGWTmTPwTfDb3YFKVtGAlSDZ7UyA7Tq59R2NqH5Im/dh3wW6+Cl6wqAaSuzS38
         SBxmHvZ6xRGyDs7ERzpJ+iiow1U7FkXRZUp/InDLKcsPdTwejem8hW+5VMb5njvc4zP7
         AAwrE6GKXSw35SDZqnDYjwTIz0iG0WDIY3BFVCtJHhDwzLU2wU1qd0lebl7klxT91jGE
         fMMCukQW0Ift+pEPk3Wj4NJuGObdSCs7YnnpYYjFvEiM1FG1RVfBNPwuOUI7tXHI+/c4
         trp09lxLIk1koB19hwJcAQ9yZ+M3M5r1ZGDo9mkzRcJak2ExE3oplSBIm6sxtcTgYqTq
         Bbdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PrXct6DxGDPic1inZjhVX9QRlhCGy/nKux4XIfvSnek=;
        b=PenCpiRnRiFFbWdf0WbDj8WuNOPTmu+NA+fYEMovlZBIxh+0c7KRpWJS7jfy2S3zPH
         e4v406GcrjCqTLJUP7lM0AxR6m+T9ZeQuCxqqDcea/txHzFjQl8z6fS4mKJ3CN02TAlZ
         zJGvvfKgMab9EtHG2g9Mb+ZPZ5jWOZ4IkO+rGsbKzZ4ybPd/rM8xLbJv5A9w3qQtQTsz
         viRwfFCpn/l8qJx/jnrW72c6rpZBexPQvNJDosKlJtpIa8CqoytkjsNPe9PeC1kF6wMX
         UcHrGPBljyNYQJ6AnTO+1+p/93qKwteoX/QLgywDrtrq10TJQd6bOSgv6ik0YbbDSPVW
         MPLQ==
X-Gm-Message-State: AOAM530ZrpZpCzm5pTtODZBAcY6UjT8IPVUk71cpwC/TGcqIccJhqifL
        ULiYru0tSeo9wCKPONoYlyyx8g==
X-Google-Smtp-Source: ABdhPJw+/7sKt0xWhmVIXrzmuSoyLfzq7RfJZa28JFTor1uXcVTj0aB9d246elg6jPgeDFHTbqKMcw==
X-Received: by 2002:a17:902:710a:b029:e3:858:8c91 with SMTP id a10-20020a170902710ab02900e308588c91mr2266454pll.75.1612982960683;
        Wed, 10 Feb 2021 10:49:20 -0800 (PST)
Received: from google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
        by smtp.gmail.com with ESMTPSA id i14sm3204390pfk.28.2021.02.10.10.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 10:49:20 -0800 (PST)
Date:   Wed, 10 Feb 2021 10:49:13 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH 0/5] KVM: x86/xen: Selftest fixes and a cleanup
Message-ID: <YCQqqb15kvdB81OC@google.com>
References: <20210210182609.435200-1-seanjc@google.com>
 <dc334fe4-0ddc-b991-ad76-1d70c065fc16@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc334fe4-0ddc-b991-ad76-1d70c065fc16@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021, Paolo Bonzini wrote:
> On 10/02/21 19:26, Sean Christopherson wrote:
> > Fix a '40' vs '0x40' bug in the new Xen shinfo selftest, and clean up some
> > other oddities that made root causing the problem far more painful than it
> > needed to be.
> > 
> > Note, Paolo already queued a patch from Vitaly that adds the tests to
> > .gitignore[*], i.e. patch 01 can likely be dropped.  I included it here
> > for completeness.
> > 
> > [*] https://lkml.kernel.org/r/20210129161821.74635-1-vkuznets@redhat.com
> > 
> > Sean Christopherson (5):
> >    KVM: selftests: Ignore recently added Xen tests' build output
> >    KVM: selftests: Fix size of memslots created by Xen tests
> >    KVM: selftests: Fix hex vs. decimal snafu in Xen test
> >    KVM: sefltests: Don't bother mapping GVA for Xen shinfo test
> >    KVM: x86/xen: Explicitly pad struct compat_vcpu_info to 64 bytes
> > 
> >   arch/x86/kvm/xen.h                                   | 11 ++++++-----
> >   tools/testing/selftests/kvm/.gitignore               |  2 ++
> >   tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 12 +++++-------
> >   tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c |  3 +--
> >   4 files changed, 14 insertions(+), 14 deletions(-)
> > 
> 
> Stupid question: how did you notice that?  In other words what broke for you
> and not for me?

I assume sheer dumb luck?  The test checks a single bit, so there's a 50/50
chance it will pass if whatever it's reading is non-zero.

If my math is correct (big if), the net effect is that the check was against
pvclock_vcpu_time_info.tsc_to_system_mul, which on my VM where I'm running the
test is always 0xcd4681c9.

==== Test Assertion Failure ====
  x86_64/xen_shinfo_test.c:161: ti->version && !(ti->version & 1)
  pid=1236 tid=1236 - Interrupted system call
     1	0x0000000000401623: main at xen_shinfo_test.c:160
     2	0x00007f303e261bf6: ?? ??:0
     3	0x00000000004016f9: _start at ??:?
  Bad time_info version cd4681c9
