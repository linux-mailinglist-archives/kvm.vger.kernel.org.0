Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3E5323BDF
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 13:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhBXM15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 07:27:57 -0500
Received: from mail.skyhub.de ([5.9.137.197]:54080 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233576AbhBXM1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 07:27:55 -0500
Received: from zn.tnic (p200300ec2f0d18008b247b078bad9a72.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:1800:8b24:7b07:8bad:9a72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C29331EC026D;
        Wed, 24 Feb 2021 13:27:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1614169632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=M5+WPT6nlnouK7l+/mNJ2w4w6/uAxYuT5kmxmJdTrr8=;
        b=Bh9v/pSs45AhY7FHbXtE6kMBWaXUyiyLPh6m+VmffZT9J/uY1S3B8646j7EZh3TCT/nqif
        o9qnHs0SEoo0N6ezBOCq1jupROaDgALvEViKXWMWpBkFtM09TyANDkym0h76IGNNvIFM8T
        Flc9DrovFcGIpMmR9lY37tnfodMsVL0=
Date:   Wed, 24 Feb 2021 13:27:10 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     syzbot <syzbot+42a71c84ef04577f1aef@syzkaller.appspotmail.com>
Cc:     dave.hansen@intel.com, hpa@zytor.com, jmattson@google.com,
        joro@8bytes.org, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lstoakes@gmail.com, mingo@redhat.com, pbonzini@redhat.com,
        seanjc@google.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Subject: Re: general protection fault in vmx_vcpu_run (2)
Message-ID: <20210224122710.GB20344@zn.tnic>
References: <0000000000007ff56205ba985b60@google.com>
 <00000000000004e7d105bc091e06@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <00000000000004e7d105bc091e06@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 23, 2021 at 03:17:07PM -0800, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 167dcfc08b0b1f964ea95d410aa496fd78adf475
> Author: Lorenzo Stoakes <lstoakes@gmail.com>
> Date:   Tue Dec 15 20:56:41 2020 +0000
> 
>     x86/mm: Increase pgt_buf size for 5-level page tables
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13fe3ea8d00000
> start commit:   a99163e9 Merge tag 'devicetree-for-5.12' of git://git.kern..
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10013ea8d00000

No oops here.

> console output: https://syzkaller.appspot.com/x/log.txt?x=17fe3ea8d00000

Nothing special here too.

> kernel config:  https://syzkaller.appspot.com/x/.config?x=49116074dd53b631

Tried this on two boxes, the Intel one doesn't even boot with that
config - and it is pretty standard one - and on the AMD one the
reproducer doesn't trigger anything. It probably won't because the GP
is in vmx_vcpu_run() but since the ioctls were doing something with
IRQCHIP, I thought it is probably vendor-agnostic.

So, all in all, I could use some more info on how you're reproducing and
maybe you could show the oops too.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
