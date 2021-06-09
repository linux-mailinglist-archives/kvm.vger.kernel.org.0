Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1969A3A17DE
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238249AbhFIOwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:52:31 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:42626 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238229AbhFIOw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 10:52:26 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7475D1FD5F;
        Wed,  9 Jun 2021 14:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623250230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bfjFCPehMo1dyNPOnDLbyFFsGSL83cnl+X5eXtIrdMo=;
        b=BmwR7ybJEQTIkO2dHxeC8RucevhwFNqF5glMJdWb8NS5t4xsTPaoMlrYtvQQQvLgiosSzU
        vKY81XNPyQpFno1hE62xVlkHiGpCSmopP5c3wioB9niwn6i0djX/lZHy7+HWwBkld7I6DT
        ZZoO5rVE/JZDsZe3zs8etR7QSDhQ1Yk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623250230;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bfjFCPehMo1dyNPOnDLbyFFsGSL83cnl+X5eXtIrdMo=;
        b=DZbZ5Blb/fF29l+3M+5ErblsWt+rGhhgXR/PRrYnbG6Q5YGQCEXoNrOaBbyWA90Cas+Fs1
        miO/AthFhYrHk1Aw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 34138118DD;
        Wed,  9 Jun 2021 14:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623250230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bfjFCPehMo1dyNPOnDLbyFFsGSL83cnl+X5eXtIrdMo=;
        b=BmwR7ybJEQTIkO2dHxeC8RucevhwFNqF5glMJdWb8NS5t4xsTPaoMlrYtvQQQvLgiosSzU
        vKY81XNPyQpFno1hE62xVlkHiGpCSmopP5c3wioB9niwn6i0djX/lZHy7+HWwBkld7I6DT
        ZZoO5rVE/JZDsZe3zs8etR7QSDhQ1Yk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623250230;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bfjFCPehMo1dyNPOnDLbyFFsGSL83cnl+X5eXtIrdMo=;
        b=DZbZ5Blb/fF29l+3M+5ErblsWt+rGhhgXR/PRrYnbG6Q5YGQCEXoNrOaBbyWA90Cas+Fs1
        miO/AthFhYrHk1Aw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id yJIXCzbVwGBcXAAALh3uQQ
        (envelope-from <jroedel@suse.de>); Wed, 09 Jun 2021 14:50:30 +0000
Date:   Wed, 9 Jun 2021 16:50:28 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Varad Gautam <varadgautam@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Varad Gautam <varad.gautam@suse.com>,
        kvm@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3] x86: Add a test for AMD SEV-ES guest #VC handling
Message-ID: <YMDVNHh9KHsha4a+@suse.de>
References: <20210531125035.21105-1-varad.gautam@suse.com>
 <20210602141447.18629-1-varadgautam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602141447.18629-1-varadgautam@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 04:14:47PM +0200, Varad Gautam wrote:
> From: Varad Gautam <varad.gautam@suse.com>
> 
> Some vmexits on a SEV-ES guest need special handling within the guest
> before exiting to the hypervisor. This must happen within the guest's
> \#VC exception handler, triggered on every non automatic exit.
> 
> Add a KUnit based test to validate Linux's VC handling. The test:
> 1. installs a kretprobe on the #VC handler (sev_es_ghcb_hv_call, to
>    access GHCB before/after the resulting VMGEXIT).
> 2. tiggers an NAE.
> 3. checks that the kretprobe was hit with the right exit_code available
>    in GHCB.
> 
> Since relying on kprobes, the test does not cover NMI contexts.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  arch/x86/Kconfig                 |   9 ++
>  arch/x86/kernel/Makefile         |   8 ++
>  arch/x86/kernel/sev-es-test-vc.c | 155 +++++++++++++++++++++++++++++++

This looks good to me except for the small comment below, thanks Varad.
I ran it in an SEV-ES guest and I am seeing the test results in dmesg.
Only thing I am missing is a 'rep movs' test for MMIO, but that can be
added later, so

Tested-by: Joerg Roedel <jroedel@suse.de>

Btw, should we create a separate directory for such tests like
/arch/x86/tests/ or something along those lines?

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 0045e1b441902..85b8ac450ba56 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1543,6 +1543,15 @@ config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
>  	  If set to N, then the encryption of system memory can be
>  	  activated with the mem_encrypt=on command line option.
>  
> +config AMD_SEV_ES_TEST_VC
> +	bool "Test for AMD SEV-ES VC exception handling."
> +	depends on AMD_MEM_ENCRYPT
> +	select FUNCTION_TRACER
> +	select KPROBES
> +	select KUNIT
> +	help
> +	  Enable KUnit-based testing for AMD SEV-ES #VC exception handling.
> +

I think this should be in arch/x86/Kconfig.debug.

