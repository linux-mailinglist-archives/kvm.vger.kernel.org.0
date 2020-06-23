Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085CE2056D8
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 18:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732533AbgFWQOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 12:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728916AbgFWQOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 12:14:00 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB55CC061573;
        Tue, 23 Jun 2020 09:13:59 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0d47007938aef930b6c4fb.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:4700:7938:aef9:30b6:c4fb])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 768C01EC0318;
        Tue, 23 Jun 2020 18:13:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1592928838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=3hydVVgqDlrgbEgBTFy7VUDI9fCz0nmR1nF+TA1bYQw=;
        b=AR8Cmxfvj2g5TZiJF22qVNjyxrjEzi3qfokFyvjRPZq+FHX1ONnQ12Y6ioP86xvNIHjtpg
        gOafUnBClkDXUL9gFcNJbChJb5NJxzTl5Zu/LFrlT4AOc2DvxW0JNlKjsJmB/sKD0V4kPs
        hmqNU/N1ePn0BbF1IV0jxu/Bj1GQ9R0=
Date:   Tue, 23 Jun 2020 18:13:55 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Mike Stunes <mstunes@vmware.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Juergen Gross <JGross@suse.com>,
        Jiri Slaby <jslaby@suse.cz>, Kees Cook <keescook@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: Should SEV-ES #VC use IST? (Re: [PATCH] Allow RDTSC and RDTSCP
 from userspace)
Message-ID: <20200623161355.GF32590@zn.tnic>
References: <20200623113007.GH31822@suse.de>
 <20200623114818.GD4817@hirez.programming.kicks-ass.net>
 <20200623120433.GB14101@suse.de>
 <20200623125201.GG4817@hirez.programming.kicks-ass.net>
 <20200623134003.GD14101@suse.de>
 <20200623135916.GI4817@hirez.programming.kicks-ass.net>
 <20200623145344.GA117543@hirez.programming.kicks-ass.net>
 <20200623145914.GF14101@suse.de>
 <20200623152326.GL4817@hirez.programming.kicks-ass.net>
 <56af2f70-a1c6-aa64-006e-23f2f3880887@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <56af2f70-a1c6-aa64-006e-23f2f3880887@citrix.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 04:39:26PM +0100, Andrew Cooper wrote:
> P.S. did you also hear that with Rowhammer, userspace has a nonzero
> quantity of control over generating #MC, depending on how ECC is
> configured on the platform.

Where does that #MC point to? Can it control for which address to flip
the bits for, i.e., make the #MC appear it has been generated for an
address in kernel space?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
