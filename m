Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D181DADB7
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 10:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgETIjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 04:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgETIjY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 04:39:24 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483ABC061A0E;
        Wed, 20 May 2020 01:39:24 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0bab00d907527c3c1e360d.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:ab00:d907:527c:3c1e:360d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9037A1EC0338;
        Wed, 20 May 2020 10:39:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1589963962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=YX9Pp+HGX2R8KL/HZG2RZHgK1Ctz9Fvmsyms+8ol70E=;
        b=qLA4joqtuBMCHg5cXvQ4cREAOohc95SEb+ExpzLag8qTlOve3Dm8KYCQpqSmvzx71S1cU7
        QOV8tPBXUKpSYUvUiVqTauAxE/EA921kK8zsjJIsWSdFUH7uOZ3xM/aeCzlTRcyXUlBlN9
        Tj4O6kdPTUIWncMNmZFRye/GrgHjwiY=
Date:   Wed, 20 May 2020 10:39:16 +0200
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
Subject: Re: [PATCH v3 38/75] x86/sev-es: Add SEV-ES Feature Detection
Message-ID: <20200520083916.GB1457@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-39-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-39-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:48PM +0200, Joerg Roedel wrote:
> +bool sev_es_active(void)
> +{
> +	return !!(sev_status & MSR_AMD64_SEV_ES_ENABLED);
> +}
> +EXPORT_SYMBOL_GPL(sev_es_active);

I don't see this being used in modules anywhere in the patchset. Or am I
missing something?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
