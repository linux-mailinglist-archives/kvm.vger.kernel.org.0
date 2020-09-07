Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651B3260602
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 23:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgIGVC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 17:02:59 -0400
Received: from mail.skyhub.de ([5.9.137.197]:42472 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbgIGVC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 17:02:58 -0400
Received: from zn.tnic (p200300ec2f0909008054e7a53e29f06e.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:900:8054:e7a5:3e29:f06e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4644F1EC0212;
        Mon,  7 Sep 2020 23:02:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1599512577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=C07RKJGN+hcvDzBdFNGPR9nFrixvo0q7M59F2sq3pp0=;
        b=NRKZlmQJaDFFKHX86WYVKOykATlMGpNqdsJ7O+L/V0XtwaNjazffNem3ANfzikwkIovhuc
        ACtBQNX1pZKD+H0SCkzTrSdd5AFXbeKr0nhMwX80VrHWII0yNVB6qK7Xs46lEEzR7aWCqy
        rSff/HIMYq4cUSnTQczhGperAZ5hjo0=
Date:   Mon, 7 Sep 2020 23:02:46 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v7 36/72] x86/sev-es: Add SEV-ES Feature Detection
Message-ID: <20200907210246.GG16029@zn.tnic>
References: <20200907131613.12703-1-joro@8bytes.org>
 <20200907131613.12703-37-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200907131613.12703-37-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 07, 2020 at 03:15:37PM +0200, Joerg Roedel wrote:
> @@ -347,7 +348,13 @@ bool sme_active(void)
>  
>  bool sev_active(void)
>  {
> -	return sme_me_mask && sev_enabled;
> +	return !!(sev_status & MSR_AMD64_SEV_ENABLED);

Dropped those "!!" here too while applying.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
