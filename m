Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1201C028D
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 18:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgD3QcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 12:32:06 -0400
Received: from mail.skyhub.de ([5.9.137.197]:57056 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgD3QcG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 12:32:06 -0400
Received: from zn.tnic (p200300EC2F0C30002976151CE84103F8.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:3000:2976:151c:e841:3f8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 65B371EC0CDD;
        Thu, 30 Apr 2020 18:32:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1588264322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xtrl8gxWZkJHYpJPr/Cwo7b9vip/S9DDjXd/Ww6io40=;
        b=f3DDPgJ1kb7J7H1s2FSo+CewgA8pebDywRzuhlHIbGoPeJfxOCoZPWUT+ddj94MkaVQxlQ
        4URcgx2vG/mZgL4VfGFpjsRWtkEb1XG8JwAu5rAjcmhGZfzgh28VgiyYLYxdqvX25H88lK
        rbvaFaro7cNsYsFFS5WTa0Uy8BMWKZI=
Date:   Thu, 30 Apr 2020 18:31:55 +0200
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
Subject: Re: [PATCH v3 08/75] x86/umip: Factor out instruction decoding
Message-ID: <20200430163155.GB3996@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-9-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-9-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:18PM +0200, Joerg Roedel wrote:
> +/**
> + * insn_decode() - Decode an instruction
> + * @regs:	Structure with register values as seen when entering kernel mode
> + * @insn:	Structure to store decoded instruction
> + * @buf:	Buffer containing the instruction bytes
> + * @buf_size:   Number of instruction bytes available in buf
> + *
> + * Decodes the instruction provided in buf and stores the decoding results in
> + * insn. Also determines the correct address and operand sizes.
> + *
> + * Returns:
> + *
> + * True if instruction was decoded, False otherwise.
> + */
> +bool insn_decode(struct pt_regs *regs, struct insn *insn,
> +		 unsigned char buf[MAX_INSN_SIZE], int buf_size)

Right, let's have @insn be the first function argument in all those
insn-handling functions.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
