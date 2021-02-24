Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF51324357
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 18:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhBXRu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 12:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhBXRuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 12:50:25 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E42FC061786;
        Wed, 24 Feb 2021 09:49:45 -0800 (PST)
Received: from zn.tnic (p200300ec2f0d18008c044bec5d14e7fe.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:1800:8c04:4bec:5d14:e7fe])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6A99C1EC0531;
        Wed, 24 Feb 2021 18:49:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1614188981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=UnSGBFPmpQGqlrhDmBc2nnYtZYpR52FfmiTAsW6NcAQ=;
        b=D4lTT1hsfeIzIWYgO4MpDODdZ65bEVmsbDLPCzfmXS5nQt5MeHGGfmF34wEoTJkZWEHTqY
        FUGRlY+2bH6Pq753tiPOh7qFVa0AsgpJ1FFwctpwaC2by/MbxgY2ychRmLKXOAat7sWlYt
        GBqtFb5Ii9JBcNcc3lfMIdF+igj5pm8=
Date:   Wed, 24 Feb 2021 18:49:36 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+42a71c84ef04577f1aef@syzkaller.appspotmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, wanpengli@tencent.com,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: general protection fault in vmx_vcpu_run (2)
Message-ID: <20210224174936.GG20344@zn.tnic>
References: <0000000000007ff56205ba985b60@google.com>
 <00000000000004e7d105bc091e06@google.com>
 <20210224122710.GB20344@zn.tnic>
 <CACT4Y+ZaGOpJ1+dxfTVWhNuV5hFJmx=HgPqVf6bqWE==7PeFFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZaGOpJ1+dxfTVWhNuV5hFJmx=HgPqVf6bqWE==7PeFFQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dmitry,

On Wed, Feb 24, 2021 at 06:12:57PM +0100, Dmitry Vyukov wrote:
> Looking at the bisection log, the bisection was distracted by something else.

Meaning the bisection result:

167dcfc08b0b ("x86/mm: Increase pgt_buf size for 5-level page tables")

is bogus?

> You can always find the original reported issue over the dashboard link:
> https://syzkaller.appspot.com/bug?extid=42a71c84ef04577f1aef
> or on lore:
> https://lore.kernel.org/lkml/0000000000007ff56205ba985b60@google.com/

Ok, so this looks like this is trying to run kvm ioctls *in* a guest,
i.e., nested. Right?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
