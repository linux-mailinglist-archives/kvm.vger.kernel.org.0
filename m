Return-Path: <kvm+bounces-4653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F929815EE2
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 13:12:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57F021C210C7
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 12:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 427F532C6C;
	Sun, 17 Dec 2023 12:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="eP3BeQVb"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B61937145;
	Sun, 17 Dec 2023 12:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8957940E00C9;
	Sun, 17 Dec 2023 12:11:57 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id zwAyTYBxkQRn; Sun, 17 Dec 2023 12:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1702815114; bh=mLfN4NEWJqNi5nAYfcVnzvmiFagMhLexPTmW8qdptp8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eP3BeQVbeImjnosYYfbsIxST9GnyJcB9uZT7l9+TvQnq4GC1jAQs2N0FvQal4mu+X
	 nqrfWVmQCo+JsQ9EkESLIJtc9d41cIcB6ZwH5FTkT/LA41+mxqyhrJzknd3hGqQGKR
	 2oB8Ifk3NdNLnmBwl69Ua0/Lfp4Q7re6jJok9EfPzzHjX0IKhzQQzt0p7N9lHIAeZR
	 gkCucFenksLGliII2bxYcHpqczZV5nMHcGSuxCtEJoJQy7NfBWq8oOwtIpi88CYh2q
	 e/rMAKDKjPeuvhIWT91WOl3bEzjuTT303pBIneYoy4H7u2TdqskLJymgbZ9xHMe6kz
	 KTpGXnMpMvBUTxXJZqPDbcGo1Smkf0Sw2gMSvRCnv5z//FW+HGdVbwmIQ92P7R3zQr
	 p0pfbV3cTve95dimTUAwBNuPBfjXEF/dBXEX4rUw4qKvUL0BRq7Jz3mj+iWBnfrix+
	 SBrHn5xN3cUxmNt2nf04+V4tWKIvARFuQ1/SawP6AgRhmp1P6p+VpOStq4apFig/1r
	 Ul69vE06EIvnTf+R6p7BfOXtPvHAR9BOIXC7928Se3EUYwIsZOsSyqOcyOsvqh16fH
	 E3jJKxKafuDOg7hOdlgW2sAWUvJBtVFz3pdRHbXY1UvfIegls3RdcLIBZKjAN1HD13
	 Sj99rwFRbn31C7U/KvrHAZ0c=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8E58540E00CD;
	Sun, 17 Dec 2023 12:11:43 +0000 (UTC)
Date: Sun, 17 Dec 2023 13:11:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Julian Stecklina <julian.stecklina@cyberus-technology.de>
Cc: kvm@vger.kernel.org,
	Thomas Prescher <thomas.prescher@cyberus-technology.de>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/emulator: emulate movbe with operand-size prefix
Message-ID: <20231217121136.GAZX7leKpfy+tSO0Tz@fat_crate.local>
References: <20231212095938.26731-1-julian.stecklina@cyberus-technology.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231212095938.26731-1-julian.stecklina@cyberus-technology.de>

On Tue, Dec 12, 2023 at 10:59:37AM +0100, Julian Stecklina wrote:
> From: Thomas Prescher <thomas.prescher@cyberus-technology.de>
> 
> The MOVBE instruction can come with an operand-size prefix (66h). In
> this, case the x86 emulation code returns EMULATION_FAILED.
> 
> It turns out that em_movbe can already handle this case and all that
> is missing is an entry in respective opcode tables to populate
> gprefix->pfx_66.
> 
> Signed-off-by: Thomas Prescher <thomas.prescher@cyberus-technology.de>
> Signed-off-by: Julian Stecklina <julian.stecklina@cyberus-technology.de>
> ---
>  arch/x86/kvm/emulate.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 2673cd5c46cb..08013e158b2d 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4502,11 +4502,11 @@ static const struct instr_dual instr_dual_0f_38_f1 = {
>  };
>  
>  static const struct gprefix three_byte_0f_38_f0 = {
> -	ID(0, &instr_dual_0f_38_f0), N, N, N
> +	ID(0, &instr_dual_0f_38_f0), ID(0, &instr_dual_0f_38_f0), N, N
>  };
>  
>  static const struct gprefix three_byte_0f_38_f1 = {
> -	ID(0, &instr_dual_0f_38_f1), N, N, N
> +	ID(0, &instr_dual_0f_38_f1), ID(0, &instr_dual_0f_38_f1), N, N
>  };
>  
>  /*
> -- 

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

