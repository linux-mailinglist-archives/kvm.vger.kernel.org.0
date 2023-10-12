Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEB47C6EAD
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 14:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378687AbjJLM7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 08:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378591AbjJLM7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 08:59:50 -0400
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBDE91
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 05:59:46 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 02FAD40E01AA;
        Thu, 12 Oct 2023 12:59:41 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tT6wuOmSQBx8; Thu, 12 Oct 2023 12:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1697115578; bh=HBdHp5UwkW1aA9cF+N8u4mhQLoD6K3rEW45TWjWa/qE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HzlPlEUGzAVzeghIMcSZsA6bM8jMKqVxOirrwzAPjAk9fU7MbJnp/DHq1aKT9Tnj/
         LYErF9cO5KkeNPOXNhCjx5BegkzrmE82ZmY+Ptn10tLZejk0BElLYbyPEe0/a81X3/
         Tf4LQHJq436aZoS1lAHD+A37gFFtPoDzBootwM0+0mUFLp4WVwGkiHILSroFn2nEQm
         W5QfVikLBxe5xwIoxCAgZw+EAu4e+NVEjeI7q0092i+dhmv5wszDuvglWpXEaGw1HB
         pDdnN14/vhHiaTkUxB2Ul5+DgbV7zPxR1fVM53Ys0GjNi4NdyorfrYYFX/CzYd/COu
         bvL9GVjYR/kGrgD1NvGmP9+C8t3wWoKyiVmTocw7hAxXjJTrcXzmRO19VdcSIrdtP8
         W28S1fCbyiMLcHd2KeF3yeGfiRy8vTkituFBpjOIbadH92CdK/34yuESopvd1gCad8
         4UHU1MNxoPTeL6nMzrsY55iAc1pl9LeLBU8S4Lxe2nhuSxySGUfIcl8lXcOgpcxmmI
         XeaNvJR7RdIKJV0XJgNDeRSbt05hOuKvrlqZBjkt3p3uZxSatKHxzbY2wzS4KQEHOL
         uHNt+Rar17nxoayMfrDvDbsFYA/j1m7jQKG0CgvBHA3CK53D7+302Hx1hOvVrxRGgw
         1ODc9/+1EyWIMj3gXmUoolXI=
Received: from zn.tnic (pd953036a.dip0.t-ipconnect.de [217.83.3.106])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9C32340E0196;
        Thu, 12 Oct 2023 12:59:29 +0000 (UTC)
Date:   Thu, 12 Oct 2023 14:59:24 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     John Allen <john.allen@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, seanjc@google.com, x86@kernel.org,
        thomas.lendacky@amd.com
Subject: Re: [PATCH 7/9] x86/sev-es: Include XSS value in GHCB CPUID request
Message-ID: <20231012125924.GFZSftrGx43ALVCtfS@fat_crate.local>
References: <20231010200220.897953-1-john.allen@amd.com>
 <20231010200220.897953-8-john.allen@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231010200220.897953-8-john.allen@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 08:02:18PM +0000, John Allen wrote:
> When a guest issues a cpuid instruction for Fn0000000D_x0B (CetUserOffset), the
> hypervisor may intercept and access the guest XSS value. For SEV-ES, this is
> encrypted and needs to be included in the GHCB to be visible to the hypervisor.
> The rdmsr instruction needs to be called directly as the code may be used in
> early boot in which case the rdmsr wrappers should be avoided as they are
> incompatible with the decompression boot phase.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  arch/x86/kernel/sev-shared.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 2eabccde94fb..e38a1d049bc1 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -890,6 +890,21 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
>  		/* xgetbv will cause #GP - use reset value for xcr0 */
>  		ghcb_set_xcr0(ghcb, 1);
>  
> +	if (has_cpuflag(X86_FEATURE_SHSTK) && regs->ax == 0xd && regs->cx <= 1) {
> +		unsigned long lo, hi;
> +		u64 xss;
> +
> +		/*
> +		 * Since vc_handle_cpuid may be used during early boot, the
> +		 * rdmsr wrappers are incompatible and should not be used.
> +		 * Invoke the instruction directly.
> +		 */
> +		asm volatile("rdmsr" : "=a" (lo), "=d" (hi)
> +			     : "c" (MSR_IA32_XSS));

Does __rdmsr() work too?

I know it has exception handling but a SEV-ES guest should not fault
when accessing MSR_IA32_XSS anyway, especially if it has shadow stack
enabled. And if it does fault, your version would explode too but
__rdmsr() would be at least less code. :)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
