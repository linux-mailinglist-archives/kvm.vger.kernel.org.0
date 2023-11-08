Return-Path: <kvm+bounces-1198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 549F47E5664
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 13:37:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85EE81C20A98
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2164F101D2;
	Wed,  8 Nov 2023 12:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="TvJ0WBDn"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629C228F9;
	Wed,  8 Nov 2023 12:37:21 +0000 (UTC)
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F72B1BF1;
	Wed,  8 Nov 2023 04:37:20 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3A29040E014B;
	Wed,  8 Nov 2023 12:37:18 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ylmaVhlMjPnP; Wed,  8 Nov 2023 12:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1699447035; bh=JGXN64F+EUfo32di/qzr7XJX6YhtI0kCKBdmlkk0BD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TvJ0WBDn88XZJSOLPKeBzSaIg4ZPz1IduqLQr53XH3ovVo/hZmQ/7qnmiswO7BGtx
	 PMCIoJ9WO6nDiyOoV/02KzCX7x1Q0/crkvUE7T1VRyZPIeDgVlwG5/yNhE8kbjOjSh
	 7YDP4FcWDCaCLP368K++Tc4DVUfAc8/ffhEyDp4cjDx7tiEGmplWqUT5viSviZKOpt
	 XpkoDDXjdUu8/LvFpKPzbUljp1FrwuFV9MIjmXD7X+ePTvaWXU8bkdtkjs+TNo5+5l
	 +qK+kMmFvo80J94vCmGjAff4kKG9bGyib+5sSirNQZHKKeoKY/RjVWOAjh0BIcqWRi
	 b5t+bmnFsOhw6MfZxre9u7/yNmNIEBRbFxetQsXqI2NIgToEIMlLwpWwx5Fs3pVc16
	 j/h/DqBPvi1p/I1ogjoiFljq/w/BKBx+JlwsRlWuhff58qS68dmQemA8xadsZ7rB//
	 kgcM9kzbjOjVwqT71Z0F3DllCOlZJ902Ql3HPIQaG/Fb+e3XPqqbzu69KJ5ZGsS+eE
	 dpsW8IQpabr8hL1zD9ChK+gb2V4dZG7RzK5NHSZi6dF6JnBXV5eZB/gysZW1mjy2Y6
	 /5wqnnIVI6bDU93P9+RGZ6da6x+ciyDbamihhSLWCGr7q/fpqQCm6Wa4aj7HSuZkG3
	 DoN6cZcFKtxhzRrn+xkPfql4=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 31DC540E0032;
	Wed,  8 Nov 2023 12:36:53 +0000 (UTC)
Date: Wed, 8 Nov 2023 13:36:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Xin Li <xin3.li@intel.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org, pbonzini@redhat.com,
	seanjc@google.com, peterz@infradead.org, jgross@suse.com,
	ravi.v.shankar@intel.com, mhiramat@kernel.org,
	andrew.cooper3@citrix.com, jiangshanlai@gmail.com,
	nik.borisov@suse.com
Subject: Re: [PATCH v12 01/37] x86/cpufeatures: Add the cpu feature bit for
 WRMSRNS
Message-ID: <20231108123647.GBZUuA31zntox0W0gu@fat_crate.local>
References: <20231003062458.23552-1-xin3.li@intel.com>
 <20231003062458.23552-2-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231003062458.23552-2-xin3.li@intel.com>

On Mon, Oct 02, 2023 at 11:24:22PM -0700, Xin Li wrote:
> Subject: Re: [PATCH v12 01/37] x86/cpufeatures: Add the cpu feature bit for WRMSRNS
							  ^^^^

For all your text:

s/cpu/CPU/g

> WRMSRNS is an instruction that behaves exactly like WRMSR, with
> the only difference being that it is not a serializing instruction
> by default. Under certain conditions, WRMSRNS may replace WRMSR to
> improve performance.
> 
> Add the CPU feature bit for WRMSRNS.
> 
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
>  arch/x86/include/asm/cpufeatures.h       | 1 +
>  tools/arch/x86/include/asm/cpufeatures.h | 1 +
>  2 files changed, 2 insertions(+)

It looks to me like you can merge the first three patches into one as
all they do is add that insn support.

Then, further down in the patchset, it says:

+	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
+		/* WRMSRNS is a baseline feature for FRED. */

but WRMSRNS is not mentioned in the FRED spec "Document Number:
346446-005US, Revision: 5.0" which, according to

https://www.intel.com/content/www/us/en/content-details/780121/flexible-return-and-event-delivery-fred-specification.html

is the latest.

Am I looking at the wrong one?

> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 58cb9495e40f..330876d34b68 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -322,6 +322,7 @@
>  #define X86_FEATURE_FSRS		(12*32+11) /* "" Fast short REP STOSB */
>  #define X86_FEATURE_FSRC		(12*32+12) /* "" Fast short REP {CMPSB,SCASB} */
>  #define X86_FEATURE_LKGS		(12*32+18) /* "" Load "kernel" (userspace) GS */
> +#define X86_FEATURE_WRMSRNS		(12*32+19) /* "" Non-Serializing Write to Model Specific Register instruction */

						  /* "" Non-serializing WRMSR */

is more than enough.

And now I'm wondering: when you're adding a separate CPUID bit, then the
above should be

+       if (cpu_feature_enabled(X86_FEATURE_WRMSRNS)) {
+               /* WRMSRNS is a baseline feature for FRED. */

I see that you're adding a dependency:

+	{ X86_FEATURE_FRED,			X86_FEATURE_WRMSRNS   },

which then means you don't need the X86_FEATURE_WRMSRNS definition at
all and can use X86_FEATURE_FRED only.

So, what's up?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

