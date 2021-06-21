Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE1A3AE940
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 14:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhFUMnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 08:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhFUMnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 08:43:02 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949C2C061574;
        Mon, 21 Jun 2021 05:40:48 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0aba0093154f80778061c9.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:ba00:9315:4f80:7780:61c9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 91EDE1EC058C;
        Mon, 21 Jun 2021 14:40:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1624279245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=vxv+Cb6FghH+Ce7UyXbZ9MQhB51hjGkjpNSgjCGcHF0=;
        b=q2tertqrWuoJH4HUUxbXX4JflnrZ0vNnsMxW6BnpwI1Go30/kEYLB5JWnx3vFWvTh8Fj0h
        FeiZQ9RU9/jvZG+ICKskzWaMIGyTXpHKJ/C8a6AO2SJr56GTu0Yhrco32rPYQ7u1HVowpE
        7TJZX8NWNokO8uKzcBaKkwDspZxUul8=
Date:   Mon, 21 Jun 2021 14:40:40 +0200
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v7 1/2] x86/sev: Make sure IRQs are disabled while GHCB
 is active
Message-ID: <YNCIyFltNGzLWuk5@zn.tnic>
References: <20210618115409.22735-1-joro@8bytes.org>
 <20210618115409.22735-2-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210618115409.22735-2-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 18, 2021 at 01:54:08PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The #VC handler only cares about IRQs being disabled while the GHCB is
> active, as it must not be interrupted by something which could cause
> another #VC while it holds the GHCB (NMI is the exception for which the
> backup GHCB exits).
> 
> Make sure nothing interrupts the code path while the GHCB is active by
> disabling IRQs in sev_es_get_ghcb() and restoring the previous irq state
> in sev_es_put_ghcb().

Note for committer: update those function names.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
