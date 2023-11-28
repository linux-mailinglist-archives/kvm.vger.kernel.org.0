Return-Path: <kvm+bounces-2596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B13267FB6C2
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 11:09:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51D25B2182B
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 10:09:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B904D594;
	Tue, 28 Nov 2023 10:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="WqvcBgi4"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D418DC;
	Tue, 28 Nov 2023 02:09:39 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 882A740E01B1;
	Tue, 28 Nov 2023 10:09:36 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id n6vaYX6mQPGx; Tue, 28 Nov 2023 10:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1701166173; bh=ZbOAIQjytTHlygvBJZdtmYHZgd+py/hKn6bkyMaazjs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WqvcBgi4X9QIQCMq9rbbSQ5yckzcUFi2nYsW5MeInmATYRTahKqBugagSn2r6mcCf
	 0OKLl1fUw7IGcqogaH5K60o9MnxTMAwqVZcoLJj+TMs/KT0za6Zq7t1tW2/Ky9ATC4
	 pMaezQt2tstNf5o+V8MgG9hsMUIkDdRe8+AHDweomKer8/hpIZOyUDVdCsCvQm3EJp
	 R8fH+CyGxdZZedQ8ges+Y8u0LMmQYV3AqbrSkYKdbd1u6YGggNSvJV8KIpYwS/MrtT
	 8NLKg58ZHCK194AabA4fUcsX2l5x6TPCAG6E8WunhkXo7OyDI18O5HIsYKRlEnF2xz
	 DK+vBY+Etna4jLAt3huPcAlHSrV/TsprLkW+MM74k+XziphA6FKIN0HOJarlWLhol2
	 K0F1NhYJ5bIokwuhXGJqZ0FXH/v94Ul/8v435Jva0XF3m/skw6ISeuyDuv7kpDbOhT
	 fXNefHnI2Dc5iXbQpfiCXIb74g9FH7zPTXzsEMG2ez0G3YN8cMrrFRtDqZT7WQJUuc
	 CX3jZGcfJrp5UiW8OoFEM4FajOlEuVTcNzPYei0+052dHmkxO7AbDriA2oZOklc953
	 dej16pz5yYo1mdKVZaGNo/ODqFn8nXdYtyFEtOfQEi8eCl0wau/qz0RlzdveGBe5Mv
	 d2OWeQiMp1IFOzr8SWk0eIUk=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8B4B840E01A5;
	Tue, 28 Nov 2023 10:09:11 +0000 (UTC)
Date: Tue, 28 Nov 2023 11:09:10 +0100
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
Subject: Re: [PATCH v12 24/37] x86/idtentry: Incorporate
 definitions/declarations of the FRED entries
Message-ID: <20231128100910.GSZWW8RnyhX0YQjwDm@fat_crate.local>
References: <20231003062458.23552-1-xin3.li@intel.com>
 <20231003062458.23552-25-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231003062458.23552-25-xin3.li@intel.com>

On Mon, Oct 02, 2023 at 11:24:45PM -0700, Xin Li wrote:
> FRED and IDT can share most of the definitions and declarations so
> that in the majority of cases the actual handler implementation is the
> same.
> 
> The differences are the exceptions where FRED stores exception related
> information on the stack and the sysvec implementations as FRED can
> handle irqentry/exit() in the dispatcher instead of having it in each
> handler.
> 
> Also add stub defines for vectors which are not used due to Kconfig
> decisions to spare the ifdeffery in the actual FRED dispatch code.
> 
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Xin Li <xin3.li@intel.com>

This makes me wonder too who the author is. The commit message text
sounds like tglx. :)

> @@ -137,6 +141,17 @@ static __always_inline void __##func(struct pt_regs *regs,		\
>  #define DEFINE_IDTENTRY_RAW(func)					\
>  __visible noinstr void func(struct pt_regs *regs)
>  
> +/**
> + * DEFINE_FREDENTRY_RAW - Emit code for raw FRED entry points

LOL, "FREDENTRY"

...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

