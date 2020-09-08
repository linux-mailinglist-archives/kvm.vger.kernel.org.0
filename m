Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5064C261044
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 12:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbgIHKvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 06:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729278AbgIHKvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 06:51:41 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B54BC061573;
        Tue,  8 Sep 2020 03:51:39 -0700 (PDT)
Received: from zn.tnic (p200300ec2f10bf001d9dc88f64877132.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:bf00:1d9d:c88f:6487:7132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 234F51EC0269;
        Tue,  8 Sep 2020 12:51:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1599562298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=p5bHnx8cr1jLr7984pAVN0Olcl/KEzbBrEmY633CIzE=;
        b=STOQDTiMjoawmkJLXat74LxWVv6qUr6lSFN99dV4kRHQNz5HwQQ7IBy7ks5aMGAl6tl2zJ
        da0kmVwIdh40mdToy3UayMhoxc6p3I9C7sFAq9c75Om6vK5Qt+tZ3GDpVfZg/yq6M+ZmJO
        cbGpWbLe2rcvjhuP662fkZW40CtlXdU=
Date:   Tue, 8 Sep 2020 12:51:32 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
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
Subject: Re: [PATCH v7 41/72] x86/sev-es: Setup per-cpu GHCBs for the runtime
 handler
Message-ID: <20200908105132.GD25236@zn.tnic>
References: <20200907131613.12703-1-joro@8bytes.org>
 <20200907131613.12703-42-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200907131613.12703-42-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 07, 2020 at 03:15:42PM +0200, Joerg Roedel wrote:
> +void __init sev_es_init_vc_handling(void)
> +{
> +	int cpu;
> +
> +	BUILD_BUG_ON((offsetof(struct sev_es_runtime_data, ghcb_page) % PAGE_SIZE) != 0);

Simplified that to:

	BUILD_BUG_ON(offsetof(struct sev_es_runtime_data, ghcb_page) % PAGE_SIZE);

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
