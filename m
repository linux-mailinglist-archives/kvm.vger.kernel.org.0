Return-Path: <kvm+bounces-73272-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yNYqLJGMrmnlFwIAu9opvQ
	(envelope-from <kvm+bounces-73272-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 10:02:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 659C9235CD5
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 10:02:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6241530233DA
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 09:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6447C37475A;
	Mon,  9 Mar 2026 09:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HZ+OBMvu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D646372B27
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 09:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773046916; cv=pass; b=G75hh1N8F6AmjHBsNUkQZwwEhTlT8Gqg22WxSkuWrDosPjDvGb2JCt1iI95VvODw9WFbccFL2pSAovE417stj5p5LjjFerb5BcMs0G+DYoYcY/fyKpO7vIimiZGOwvt31LjJPmwtCtj8Q9R362Aotghrk15Cng34kfgqBnMkVuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773046916; c=relaxed/simple;
	bh=PNkPX25Cp7e7Iwb2dKtnjzov9RP8heUl93T4iWLshSg=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YfLtLR/gQ3dBuZNFlKEjo1HCfyNEav3ELgUirzd5ztJSWCLqEZk5L2Sj6QnAbF6nOeJFG83yryHsYhff65shoJfYw6+SXEFUiRQg9Jc0JMg+8piRKSNobEq5BO2s8bS9vd2f3kaMEXvExxS6G4YwCWHm1dikkCoNfitZT7Amd9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HZ+OBMvu; arc=pass smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-5ff05af29b4so3855642137.1
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 02:01:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773046914; cv=none;
        d=google.com; s=arc-20240605;
        b=NFss7kUyG0VGr0+4L+naT52j38YUK3QMs9vV53eWi1Axm6fDJsIl3P22IklKvPZzhB
         dAgws92nDt2dbKSe0fsmXX5AHx3GY4Dokmd66cY81yP5mWYTmQMwMq0ZVMelYKUFCXRL
         i926bvN/ZtUEXqus8EBCUtNr2FXWlxrR6omM6SvBQRcAaE2c9Fz3y8h0686fvjAN8ncA
         KE+lRqpvqfz5gHI/NBBG+4X1mKe/PcdWEwhLB0/W/CgJIHf4vb+0nDPFfRo2NZSUS0Dv
         oKWtB4FBMO5/+R+K7fKO1dz8Ttg3l5BKBT2iax2KauVCk/zdr995Geyc/j97hz1z52WN
         gj0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=RFQA1zNrgYGwPSpxXXkSccQrNeC8DGePNpNQ4Qq3K74=;
        fh=0YZpqzuIHlIF/LubTgwDB4Z7kIZDvesGVMRIPXOVVDQ=;
        b=FQj6n8rv3rlf0scUgaySngY+IgDkJwwbjrZTtF5/Y21wp07fuXKoZUHF/V5PbumuuB
         yUBjYRRxHA/OCMY+xVSge+bJ1clRyR2AJbuLtdFQgC9wYB9RtyN3xFx2pQ1uEX3C4Bjf
         9itlxYowoNdCaOWmvrcwwAYQz8aModNaQNWdOUqMfnBbLB4ihWSKylGni8OtPvhHxuol
         YKfpHFHNnMoOfseNtnjQCmTy6wACSEaM1Ca+ndinbSj152WgJE3ekcIil7dvrjCZC0rL
         cH5LON3+0XmXceKYApEMdisyQusw/8OpHxH5f5wA9fmlnl0Ncdqji8VxJ/EbzLLsqj6F
         x17Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773046914; x=1773651714; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=RFQA1zNrgYGwPSpxXXkSccQrNeC8DGePNpNQ4Qq3K74=;
        b=HZ+OBMvu14mLMWV7Hizzd6RlJU+TG+l5CUyuTPiK3a8leO1gHkq9AhhkKPdYyvVTgl
         O7BRrxwbVPMIMuA0zGsbKSSw3GeoElrAvB3jEhKS9fyofkrGPKBcYRGf7CTrjvAPHrB6
         awiWYKqFZ/l8b39F0Qjoxd4KBA7QDMCZPVRgni3XLyZa30ARiMoLr6u9pA14p7Ki/8I6
         D+moV25McBJrtzIfddwO0l1/HtDYCxK4oTbmbDrWkJ8kokCBVwObC0wJ8k1YQ4XXAA80
         +ReTAkQREhJLLpKKquQvXk8ddfJitPFLRwVpnK+wqXLwC5RLgMlnZc0eYIMI+YkMrxk3
         EZSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773046914; x=1773651714;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RFQA1zNrgYGwPSpxXXkSccQrNeC8DGePNpNQ4Qq3K74=;
        b=vHXtU2tkfKZwcLw/+h3EU6wH9JZftKbOHQpHl47eme76klkQtnjWyiQIixzkUgO7NG
         nyEhaFXLFPp4+kmfaUwld93TCkzNrlG9kMZz/8bHgVXmyEK7XbM7W5kg/cDW2rNzbCPQ
         rW3yz98MGru9xSKhSSN4ruDl/GI82y7kESdrs3+rxuJHT1m+8MW1I6WQt9/HTDcorl/Y
         DxSCWminUXAPyKNyQjXub2wP0MautnLMSm1aVIj4PeZhtrzN2dDGn4cwJgDAk4EG01DV
         G9QYK20yVdCamXKPhEa1OwqtcUk8C7s/BOGCVQocOiY1p1F9c0y0zT1CWl/P9QY1cArL
         h8Xw==
X-Forwarded-Encrypted: i=1; AJvYcCXxtjfHIysZ+am9CedE/hZ2KZNeK3H8UFRhQl3DuDYdNBJHANGAyX+qYlPUB6jLDZPkBHM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCF3raJx2f+r3612s6hVSfiSmdcjrmSdKg4xLwvITu/r3ELEFl
	JavSYW/c0pfYJffwtlFV6bWv0yu6tHAKwy4URnfH0S96vhu5QIz7+7XbEmpmHq2FrmojziwJyrv
	tejb4UjIOWlGGHjKsCJ5BriDR9FSxiPj0yMroagQr
X-Gm-Gg: ATEYQzyNO5AbfjLbLJ2hJD5GevnXBbFfy6tpDZ/SfPCNGz66i5Dj6yUIqkF2UiAhfkV
	oApp+6Kndp16/uW3ufggapL0woq0h608ybC7vRNk0i/bWskiO5pp2bGPkiJ41/2BUKVq8embQQK
	KtCBKujBw+gZi7YISFAkaYIPSe5HFeOcIyhTsnub+MWKf+eyd77ZJNRbalx81GtMXXjXGKesTw4
	uAxCQioDq7yzaEpJIYggheFU65olYN47BX8P5kn1nxOaDqixRuH77nXlkEkY44a/Sxc7q5SCrS0
	i9ixaPcctEUBa+xF9degWkwryqzWG/8jAOw4sPoNbxXDmtZglALk2kXjPzR7GaQtDZwyGg==
X-Received: by 2002:a05:6102:3f0b:b0:5ef:a644:ca4 with SMTP id
 ada2fe7eead31-5ffe6134835mr3557573137.23.1773046913874; Mon, 09 Mar 2026
 02:01:53 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Mar 2026 02:01:53 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Mar 2026 02:01:53 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ce99dc548000b5a1f4486cdd3efe510b3874684b.1772486459.git.ashish.kalra@amd.com>
References: <cover.1772486459.git.ashish.kalra@amd.com> <ce99dc548000b5a1f4486cdd3efe510b3874684b.1772486459.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 9 Mar 2026 02:01:53 -0700
X-Gm-Features: AaiRm523pnGIGt0JrK2mF_UJQjN59ASDAQJnNicAgeYGdxK3jDgLfp_34dMqkIY
Message-ID: <CAEvNRgFCTNr=LUR_RM7+A4z+qHCWBZOYKe_Cbokwx0UsCtzaVw@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] KVM: guest_memfd: Add cleanup interface for guest teardown
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com, 
	peterz@infradead.org, thomas.lendacky@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com, 
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, 
	jackyli@google.com, pgonda@google.com, rientjes@google.com, 
	jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com, 
	babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com, 
	darwi@linutronix.de, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 659C9235CD5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73272-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.946];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,amd.com:email]
X-Rspamd-Action: no action

Ashish Kalra <Ashish.Kalra@amd.com> writes:

> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Introduce kvm_arch_gmem_cleanup() to perform architecture-specific
> cleanups when the last file descriptor for the guest_memfd inode is
> closed. This typically occurs during guest shutdown and termination
> and allows for final resource release.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>
> [...snip...]
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 017d84a7adf3..2724dd1099f2 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -955,6 +955,14 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
>
>  static void kvm_gmem_free_inode(struct inode *inode)
>  {
> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CLEANUP
> +	/*
> +	 * Finalize cleanup for the inode once the last guest_memfd
> +	 * reference is released. This usually occurs after guest
> +	 * termination.
> +	 */
> +	kvm_arch_gmem_cleanup();
> +#endif

Folks have already talked about the performance implications of doing
the scan and rmpopt, I just want to call out that one VM could have more
than one associated guest_memfd too.

I think the cleanup function should be thought of as cleanup for the
inode (even if it doesn't take an inode pointer since it's not (yet)
required).

So, the gmem cleanup function should not handle deduplicating cleanup
requests, but the arch function should, if the cleanup needs
deduplicating.

Also, .free_inode() is called through RCU, so it could be called after
some delay. Could it be possible that .free_inode() ends up being called
way after the associated VM gets torn down, or after KVM the module gets
unloaded?  Does rmpopt still work fine if KVM the module got unloaded?

IIUC the current kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
is fine because in kvm_gmem_exit(), there is a rcu_barrier() before
kmem_cache_destroy(kvm_gmem_inode_cachep);.

>  	kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
>  }
>
> --
> 2.43.0

