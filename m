Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9111C34CB
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 10:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgEDIrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 04:47:00 -0400
Received: from mail.skyhub.de ([5.9.137.197]:37724 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728092AbgEDIq7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 04:46:59 -0400
Received: from zn.tnic (p200300EC2F08AF00CCEA7D8403A9A735.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:af00:ccea:7d84:3a9:a735])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 686B11EC02EE;
        Mon,  4 May 2020 10:46:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1588582015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=pHvKEwruh17Jw9K+Etb8co9PWCGobmfUm7W8svxiY+g=;
        b=Mxnq5+iESIoNo365G6tHE/gSZMc38TxWJ4X8reE28/N0RytVxFYTBetKxNxhrOGn07Uq9e
        VR+X+ZXYLaGeLeYXSQTMHmUCjj9smkz85AGqaYm00twWirEqcpvAXAaei580Ap8u7eTRJe
        0RSVb995YGYQx446RG6LFGff4NWaVT4=
Date:   Mon, 4 May 2020 10:46:51 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
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
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 10/75] x86/insn: Add insn_rep_prefix() helper
Message-ID: <20200504084651.GC15046@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-11-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-11-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:20PM +0200, Joerg Roedel wrote:

> Subject: Re: [PATCH v3 10/75] x86/insn: Add insn_rep_prefix() helper

s/insn_rep_prefix/insn_has_rep_prefix/

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
