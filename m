Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541F1257676
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 11:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgHaJ0i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 05:26:38 -0400
Received: from mail.skyhub.de ([5.9.137.197]:56944 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgHaJ0h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 05:26:37 -0400
Received: from zn.tnic (p200300ec2f085000329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:5000:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D21AA1EC02F2;
        Mon, 31 Aug 2020 11:26:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598865996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=bkH0aO/ZfQAZod0rKlEgN7OneBXcRRDyR+pUyRzivKo=;
        b=FJDbz9lEh1zXMH9SuolXDEyOJLBgYu6lNb9+4vgBZzO3pPzaoLgn9AG+P59Ea19DsPLfmZ
        gnK7VJHd8oCnQ+zcxuwRuihoF3LB6D74Zx4iPRiyjfYy+xn2/jSFXtsJWA50ElTOJhAAaA
        s54ZF/V0naGLK4KY11I7DaaRg0fInJk=
Date:   Mon, 31 Aug 2020 11:26:30 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 38/76] x86/head/64: Set CR4.FSGSBASE early
Message-ID: <20200831092630.GC27517@zn.tnic>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-39-joro@8bytes.org>
 <20200829155525.GB29091@zn.tnic>
 <20200831085810.GA13507@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200831085810.GA13507@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 31, 2020 at 10:58:10AM +0200, Joerg Roedel wrote:
> This is not needed on the boot CPU, but only on secondary CPUs. When
> those are brought up the alternatives have been patches already. The
> commit message should probably be more clear about that, I will fix
> that.

Hell yeah - you need to talk more in those commit messages sir! See,
we're not in your head... :-)))

And pls put that as a comment over the code - the commit message will
not be that easily accessible in years.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
