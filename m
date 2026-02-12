Return-Path: <kvm+bounces-70953-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QEJgMT7QjWnw7QAAu9opvQ
	(envelope-from <kvm+bounces-70953-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:06:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E43412DB7E
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:06:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D2E1D303100B
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 13:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BB5235B631;
	Thu, 12 Feb 2026 13:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CRSfO8oC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mwRf3Cc6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA05A3EBF24
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 13:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770901557; cv=none; b=FMjpz0BnhJqLZZYWdjWbkwcgRG3Jcnrz+Eu75+AUceQYA3KhIcYEqDKsxouUdyyhYuEZPkMWoNIM0sAHSrgGBaR6VZrLh2aikNIBoA6/dIHGyNHLv3Ajf0iSMzqXYwOxwJ0UHuA6i/KcEIMUYyjmT83bbSQn1kQh//+W8dNpDh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770901557; c=relaxed/simple;
	bh=fubshRHZOK3xcw1lnexFbYnDXHYBcCIwqojSGjudTdg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nBbGNRnjcC5pVDaqg8bJmTAOGCVdv+PoQ2ge0wu/lYwcn3SG0eyWqza6GCdg0sZW+R9iA8rFZZSq6DIwvxYHm3Bp6MQrBwL09xWszyojvdm5hwQ+QZXa7+WDT1hy4Yv2xU1sfSByhhEVUFMCdL+G+OYi6uwAUjupk+UR13El+80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CRSfO8oC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mwRf3Cc6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770901554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fAwi/lFTFJWF8aYR9HamB7ruEzLXva1BZO763+SUKAI=;
	b=CRSfO8oCiNA7tsrpUp8c83Zsgd4oRyFYrrb6emn14Rddw3UQ6ru+WyQtQcisPaAcaphXrH
	iTTxSavHCWvPItyBgnnGcfeaAfQjX5CcvIBZ74ltBSL0XjbK6P22jpEAl/vGdWm9fwagJK
	zDchiko3hfw0U1reLNS8gMZqvxaKoIY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-ARXEWuohNC-UpDNG7Fye6Q-1; Thu, 12 Feb 2026 08:05:53 -0500
X-MC-Unique: ARXEWuohNC-UpDNG7Fye6Q-1
X-Mimecast-MFC-AGG-ID: ARXEWuohNC-UpDNG7Fye6Q_1770901552
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4803e8b6007so28594035e9.0
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 05:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770901552; x=1771506352; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fAwi/lFTFJWF8aYR9HamB7ruEzLXva1BZO763+SUKAI=;
        b=mwRf3Cc6iWRUG+N8VN114AYMDprcEVmzkdLBljH0nLfXPLlgLoRM9R8KqiVtM+NXSy
         GASI8i5vbVZcprp7OSYKYdrabwb+izvESRs42C+QWjwDszgaWlx/r/WPBRaw8QwsEjbG
         JJx9JGScmG9E8SAwzjdS9AZyrCosPYZdzwwTrq37S74NHdUwqNPB5C1hZ0we5ioFHHk+
         JuqpvB3dNb5Dw7DHdFenPgQYHhaWbtWe9Xi+KOfwn8f7rIT5UAAlJIqquDEEALaLijVO
         b7EaJo+twHvPOYuiEDesBL8PWtmIjcxvhJZxXKQ7sUF/DAH1/et5RbAjJJbx++uJQF1r
         3rpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770901552; x=1771506352;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fAwi/lFTFJWF8aYR9HamB7ruEzLXva1BZO763+SUKAI=;
        b=odNR/58qHWGaELoQ9vbf0YAfSU5873N3nUyuGXwqjo+1MM2iMWSldEccr2Z2qLB4lQ
         ugDuVPbBbb3hwXCiPHF7VPOWlquFifwUg2tH0nhAR/7+IrOt1GdNOeSpLwcP4kWWjU2I
         3z8qClRs9UjmqtT+390jOn29SAHOoXEBR2pc99hSA1oGyk5XACy9zz7SS146qVTF6/OO
         LRiKaj/o0Ri4d7wIwOZGaiiNrKYFQX2qFA1TYGJxa2QNBpQ4Xuy3u9bEpvs/ihlfIi1c
         yVsgSEZPF4wcbQCWftlc+Yrr+86/aG2BT2HvDbxTQlMMVoA3mqM/B6VA+ubGAoZ6/sEh
         Escg==
X-Forwarded-Encrypted: i=1; AJvYcCUgT3uVWOrq+WvOF+Y7imoKp3FUl8T76ICxAD0TnrOGIe/KHIumrd3NIHHPT1IWLhPnjnI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPVgybxqQyCW56hn7veLYBFTfEmwrKZm4ALVQKeRIS42ffVtYq
	XkbzZsjx/zfrMzMjx0HKdG2r6hB8T15ZYW6r6NpMFd3z+x0sxcvIvZ+UhMbYeBO74ZQpMdrrkGb
	PoxPF0RKEwhdM9wxYRf3bxrqTPVRT84FOVC9VXceZGld/Tbp9jc6Mkg==
X-Gm-Gg: AZuq6aKdQyRRcp4E0CCs34O1NKwJNQlWXveExW39Czyl6ldEtNGMnX9hLriwefzfQCx
	eSS2QsrHQ0NCi7Xe0v6fGqNguU4Rdl//Q7qSBaJlA7fODo3gL0N+N/Glgmu7dF+gPh2EzKfrj3G
	kD5TcxipE1Ad0Rz0jopLPrsL+Hm+dwm4/nCnqeIR+G3dT5Rwrn8VCQCvMRPJdqf9rmoAnPFDYh9
	X7OYWUrMzy91SeuXgvdx9d+lTfW7L1dBET6pW8zu1ibmP332PNLd+IfP1A5tRJt2CqmXuiSo43r
	7RJuQheKQQ0ijVqCiz8i318Xrcre+LApqqcwGryEgTu7fUlFRfvlJMq4B66vtcFWRlvpo7HNyhk
	5AeFnfEjYhYdYxmZBTf0ePVOCU1vYKE167/vBjkiHobSIaNi85v5sehADGQWOIF/olw2jF17pk/
	f1Fu/pboDLf1+oUJAYf1BV1/YQvT5cmQwSBa0iaOB9yNwS0zvn9FFgDWjWhQ==
X-Received: by 2002:a05:600c:154a:b0:483:348a:d3f3 with SMTP id 5b1f17b1804b1-48367165b8emr29244085e9.18.1770901552252;
        Thu, 12 Feb 2026 05:05:52 -0800 (PST)
X-Received: by 2002:a05:600c:154a:b0:483:348a:d3f3 with SMTP id 5b1f17b1804b1-48367165b8emr29243495e9.18.1770901551816;
        Thu, 12 Feb 2026 05:05:51 -0800 (PST)
Received: from [10.60.241.123] (93-38-190-72.ip72.fastwebnet.it. [93.38.190.72])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4835a627c96sm68629315e9.2.2026.02.12.05.05.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 05:05:51 -0800 (PST)
Message-ID: <0a1ad845-a15b-4901-a65c-2668580751ed@redhat.com>
Date: Thu, 12 Feb 2026 14:05:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Fix incorrect memory constraint for FXSAVE in
 emulator
To: Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org, x86@kernel.org,
 linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20260212102854.15790-1-ubizjak@gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
In-Reply-To: <20260212102854.15790-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70953-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org,kernel.org];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,zytor.com:email]
X-Rspamd-Queue-Id: 3E43412DB7E
X-Rspamd-Action: no action

On 2/12/26 11:27, Uros Bizjak wrote:
> The inline asm used to invoke FXSAVE in em_fxsave() and fxregs_fixup()
> incorrectly specifies the memory operand as read-write ("+m"). FXSAVE
> does not read from the destination operand; it only writes the current
> FPU state to memory.
> 
> Using a read-write constraint is incorrect and misleading, as it tells
> the compiler that the previous contents of the buffer are consumed by
> the instruction. In both cases, the buffer passed to FXSAVE is
> uninitialized, and marking it as read-write can therefore create a
> false dependency on uninitialized memory.
> 
> Fix the constraint to write-only ("=m") to accurately describe the
> instruction’s behavior and avoid implying that the buffer is read.

IIRC FXSAVE/FXRSTOR may (at least on some microarchitectures?) leave 
reserved fields untouched.

Intel suggests writing zeros first, and then the "+m" constraint would 
be the right one because "=m" would cause the memset to be dead.

Paolo

> No functional change intended.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@kernel.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>   arch/x86/kvm/emulate.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index c8e292e9a24d..d60094080e3f 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3717,7 +3717,7 @@ static int em_fxsave(struct x86_emulate_ctxt *ctxt)
>   
>   	kvm_fpu_get();
>   
> -	rc = asm_safe("fxsave %[fx]", , [fx] "+m"(fx_state));
> +	rc = asm_safe("fxsave %[fx]", , [fx] "=m"(fx_state));
>   
>   	kvm_fpu_put();
>   
> @@ -3741,7 +3741,7 @@ static noinline int fxregs_fixup(struct fxregs_state *fx_state,
>   	struct fxregs_state fx_tmp;
>   	int rc;
>   
> -	rc = asm_safe("fxsave %[fx]", , [fx] "+m"(fx_tmp));
> +	rc = asm_safe("fxsave %[fx]", , [fx] "=m"(fx_tmp));
>   	memcpy((void *)fx_state + used_size, (void *)&fx_tmp + used_size,
>   	       __fxstate_size(16) - used_size);
>   


