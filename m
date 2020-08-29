Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77762566CF
	for <lists+kvm@lfdr.de>; Sat, 29 Aug 2020 12:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgH2KYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Aug 2020 06:24:10 -0400
Received: from mail.skyhub.de ([5.9.137.197]:44544 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726912AbgH2KYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Aug 2020 06:24:09 -0400
Received: from zn.tnic (p200300ec2f204500b1cc6302500d80e4.dip0.t-ipconnect.de [IPv6:2003:ec:2f20:4500:b1cc:6302:500d:80e4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 349451EC037C;
        Sat, 29 Aug 2020 12:24:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598696648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=0e5Zbp/QkxjL0piLwdEzEuIspUR8YR+mw+xt+CuGFbo=;
        b=cemrkeOyYLobGkpBpqH7LcdLGijcZM4qMxp+8Y6iPmt4RQgrJ+w3QjurTadaKt4T5PAHpr
        AbBGZpfJ7E8D4qmUFDX4fvOJwOCBbarzWB3DpSUuIsgZKFjF8xQI+8k1TTHdvwPm0DdpfY
        KCpf/sXGQEtE7nPpk4DEzijdYUnvtvM=
Date:   Sat, 29 Aug 2020 12:24:05 +0200
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
Subject: Re: [PATCH v6 36/76] x86/head/64: Load IDT earlier
Message-ID: <20200829102405.GA29091@zn.tnic>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-37-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200824085511.7553-37-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 10:54:31AM +0200, Joerg Roedel wrote:
> @@ -385,3 +386,25 @@ void __init alloc_intr_gate(unsigned int n, const void *addr)
>  	if (!WARN_ON(test_and_set_bit(n, system_vectors)))
>  		set_intr_gate(n, addr);
>  }
> +
> +void __init early_idt_setup_early_handler(unsigned long physaddr)

I wonder if you could drop one of the "early"es:

idt_setup_early_handler()

for example looks ok to me. Or

early_setup_idt_handler()

if you wanna have "early" as prefix...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
