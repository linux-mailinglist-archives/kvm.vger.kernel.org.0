Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750E82FAB81
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 21:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389000AbhARUaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 15:30:23 -0500
Received: from mail.skyhub.de ([5.9.137.197]:50678 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394211AbhARUaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 15:30:12 -0500
Received: from zn.tnic (p200300ec2f069f0062c4736095b963a8.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:9f00:62c4:7360:95b9:63a8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 21BE01EC04F0;
        Mon, 18 Jan 2021 21:29:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1611001771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=cIG/RqO5JFDYb15YAf8/e61/XxXDZVIp5xUGVF2yUvY=;
        b=MpPyuIfc7DDypx2lEYCKWhuc3Wk1aGegxprSLXycDpMcX2hp6izTV9LoS+clIRpKKsTZLH
        xyiBE/lnlMo7KFz5WnoblI7J4pbcED0QXrZjZxJZ4p4vNbFbpnfs7/MExXFvnVmcP5p3X8
        DjotxmnRtecHYy5TcbMfYI1HhFMubAE=
Date:   Mon, 18 Jan 2021 21:29:31 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] x86/sev: Add AMD_SEV_ES_GUEST Kconfig for including
 SEV-ES support
Message-ID: <20210118202931.GI30090@zn.tnic>
References: <20210116002517.548769-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210116002517.548769-1-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021 at 04:25:17PM -0800, Sean Christopherson wrote:
> Introduce a new Kconfig, AMD_SEV_ES_GUEST, to control the inclusion of
> support for running as an SEV-ES guest.  Pivoting on AMD_MEM_ENCRYPT for
> guest SEV-ES support is undesirable for host-only kernel builds as
> AMD_MEM_ENCRYPT is also required to enable KVM/host support for SEV and
> SEV-ES.

Huh, what?

I'm not sure I understand what you're trying to say here and am not
convinced why yet another Kconfig symbol is needed?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
