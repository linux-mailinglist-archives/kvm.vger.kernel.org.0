Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0161EE7C5
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 17:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgFDPaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 11:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729035AbgFDPaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 11:30:35 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D679BC08C5C0;
        Thu,  4 Jun 2020 08:30:34 -0700 (PDT)
Received: from zn.tnic (p200300ec2f112d0035262982e5edc845.dip0.t-ipconnect.de [IPv6:2003:ec:2f11:2d00:3526:2982:e5ed:c845])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3817D1EC0118;
        Thu,  4 Jun 2020 17:30:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1591284633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=dgOFdDW+wev1gcsAysq51nTpw31Zuln3/0Xnz7fwqtE=;
        b=lY1y2A+1RzmtxBuefUaVNKu/Y1Wj+Nvw4Y9pBw79JG/+MQBzPlnZkr2uFIyLIkrGlRb4iB
        eZMF4rQHg/FKxFGQd6yAn+xN5lvToN5VcyMpqXNH3MT4NvtumJjwozsbFNTSnB9ZJhLOnC
        47J+naxjkG0RfuLl25dliKfHi+8JGD8=
Date:   Thu, 4 Jun 2020 17:30:27 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 42/75] x86/sev-es: Setup GHCB based boot #VC handler
Message-ID: <20200604153021.GC2246@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-43-joro@8bytes.org>
 <20200520192230.GK1457@zn.tnic>
 <20200604120749.GC30945@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200604120749.GC30945@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 04, 2020 at 02:07:49PM +0200, Joerg Roedel wrote:
> This are IDT entry points and the names above follow the convention for
> them, like e.g. 'page_fault', 'nmi' or 'general_protection'. Should I
> still add the verbs or just add a comment explaining what those symbols
> are?

Hmmkay, I see vc_no_ghcb doing

call    do_vc_no_ghcb

and that's setup in early_idt_setup().

vc_boot_ghcb(), OTOH, is called by do_early_exception() only so that one
could be called handle_vc_boot_ghcb(), no? I.e., I don't see it being an
IDT entry point.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
