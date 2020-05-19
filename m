Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773801D9310
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 11:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgESJPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 05:15:36 -0400
Received: from mail.skyhub.de ([5.9.137.197]:57080 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbgESJPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 05:15:36 -0400
Received: from zn.tnic (p200300ec2f0b87003113f65f16dcf690.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:8700:3113:f65f:16dc:f690])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 99A811EC0322;
        Tue, 19 May 2020 11:15:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1589879734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=3zIW0mscrSzBoJoj+N7Op6mZu6eLSey92yt+pTI7244=;
        b=UCHDF2ZgyRLRTP7XNdnuIZv4h2qPUWVp7D7heCzAdEWdt15yHiKvQO71Kib2dI9IztD8je
        0XrJlp8xpdDb5g8DZ7zW5IDgqVo7PX01g/D/UXElv00ZpVvJMc6eM9sQURxg+yMMLTb+Sd
        4Qav+EDQoW5GfHKrvicE0mYg0jJJncI=
Date:   Tue, 19 May 2020 11:15:26 +0200
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
Subject: Re: [PATCH v3 35/75] x86/head/64: Build k/head64.c with
 -fno-stack-protector
Message-ID: <20200519091526.GB444@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-36-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-36-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:45PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The code inserted by the stack protector does not work in the early
> boot environment because it uses the GS segment, at least with memory
> encryption enabled.

Can you elaborate on why is that a problem?

The stack cookie is not generated that early yet so it should be
comparing %gs:40 to 0.

Also, it generates the checking code here only with

CONFIG_STACKPROTECTOR_STRONG=y

> Make sure the early code is compiled without this feature enabled.

If so, then this should be with CONFIG_AMD_MEM_ENCRYPT ifdeffery around
it.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
