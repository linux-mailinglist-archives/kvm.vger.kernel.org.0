Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE64D3978A5
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 19:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbhFAREk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 13:04:40 -0400
Received: from mail.skyhub.de ([5.9.137.197]:41618 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234388AbhFAREh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 13:04:37 -0400
Received: from zn.tnic (p200300ec2f111d00a3e97a9775243981.dip0.t-ipconnect.de [IPv6:2003:ec:2f11:1d00:a3e9:7a97:7524:3981])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 364261EC0288;
        Tue,  1 Jun 2021 19:02:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1622566974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=dIdCWzqgU6kcRDTdTE0n9okx57SCKfxWQpZpdqAC19k=;
        b=avCcUpsSY5P7Qted1BZrbeOJlTsVvz32We/YD4oBuQ8ERSItO2tXwJwanqayk+jETqUJn9
        hQ/ATfINA0OUit10cikpLQ8GycTkq3AerqwJsoAD8f1UXy2wdu0xWDMtXlVJqe/VmHUapM
        rm27ZU4Zh//kt6LoTKRW3dcA2INPkG8=
Date:   Tue, 1 Jun 2021 19:02:53 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Varad Gautam <varad.gautam@suse.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v2] x86: Add a test for AMD SEV-ES #VC handling
Message-ID: <YLZoPTQxQKWcWZOC@zn.tnic>
References: <20210531125035.21105-1-varad.gautam@suse.com>
 <20210531172707.7909-1-varad.gautam@suse.com>
 <fdc55029-bbb5-6d3e-5523-cada1aae8ddc@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fdc55029-bbb5-6d3e-5523-cada1aae8ddc@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 01, 2021 at 11:41:31AM -0500, Tom Lendacky wrote:
> > +ifdef CONFIG_AMD_MEM_ENCRYPT_TEST_VC
> > +CFLAGS_sev.o	+= -fno-ipa-sra
> > +endif
> 
> Maybe add something in the commit message as to why this is needed.

Or even better - in a comment above it. Commit messages are harder to
find when time passes and other commits touch this line and you have to
go and do git archeology just to figure out why this was done...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
