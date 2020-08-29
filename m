Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89F2256903
	for <lists+kvm@lfdr.de>; Sat, 29 Aug 2020 18:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgH2QZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Aug 2020 12:25:32 -0400
Received: from mail.skyhub.de ([5.9.137.197]:38512 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728310AbgH2QZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Aug 2020 12:25:29 -0400
Received: from zn.tnic (p200300ec2f20450061bc46564a6ab4aa.dip0.t-ipconnect.de [IPv6:2003:ec:2f20:4500:61bc:4656:4a6a:b4aa])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 21C2A1EC037C;
        Sat, 29 Aug 2020 18:25:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598718328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=HbySJQXChJDM0F+N38SDaiCS004SCJXnUJohWjFm+LA=;
        b=hhBQ51tBAWqqMqoOKI2QyX23xPRzrrwsfPexRWHbIbi5yqiaoW+rzJkT243eibJ9vM1Pi5
        6DoiGlyGJlC2nKrvRDlCGdOvjhr2xjCu9QyQ2Po3OzI9OwAe1/hlV/vaOWpqGSpb5JrXrm
        G8/dQNqZioDLvANtDHO37gbF7YoCOF4=
Date:   Sat, 29 Aug 2020 18:25:24 +0200
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
Subject: Re: [PATCH v6 39/76] x86/sev-es: Add SEV-ES Feature Detection
Message-ID: <20200829162524.GC29091@zn.tnic>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-40-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200824085511.7553-40-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 10:54:34AM +0200, Joerg Roedel wrote:
> +/* Needs to be called from non-instrumentable code */
> +bool noinstr sev_es_active(void)
> +{
> +	return !!(sev_status & MSR_AMD64_SEV_ES_ENABLED);

You don't need the "!!" since you're returning bool.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
