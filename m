Return-Path: <kvm+bounces-72539-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iBUuG1MDp2k7bgAAu9opvQ
	(envelope-from <kvm+bounces-72539-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 16:50:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2311A1F2F19
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 16:50:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E7CA63086A7D
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 15:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 795D1494A14;
	Tue,  3 Mar 2026 15:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="veD5TKQw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4117288D6
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 15:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552837; cv=pass; b=j7kjCuYR/K0ExQ607qYgzU/c1wsp8AOke7qU1DS036muzI3DJMmOe/xvfGUoCxguVWLJb7OxOZWGBdHstOKApRkRc4+ycptr/9VJJUd9g2yWDCQO1qMtPMhNaOl0xiHWr1QPQ1Nv5KVhAPhRhJ0IgCTNWKYGB9utn7Bar2hTbrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552837; c=relaxed/simple;
	bh=d5TMbgs1WSF4231wsXXSJxU6n6VNWCH0FsfNgQ8mBQc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IF6HTWzQqhK1qjCpbI9smPZxIpVm55q8vVkdgr5b4usUJfVNEOBOJr5sekxaRtW3BKLL27sbFKsEr+GPmRHQ695DN3ivmK6stE/enCoCTjxR9RPKkn/Al52Vw2a9kVx+ly1C4hF9ZHNqcYzTk8kQm4cXoNTzexorx9zEUdtTBEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=veD5TKQw; arc=pass smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-677bb1c3a9dso2021124eaf.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 07:47:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772552835; cv=none;
        d=google.com; s=arc-20240605;
        b=SpJBloINgRLA4nIub97ityFv84KhHrzxNv3HWwq/XyW/KhP8XtAgQFoDiP6myrjhRr
         IVm9Dot4JE2Kl781wsL91hEpySd1nr9teCBvyvbbmJfOrpNMwIlTR2Up2W2IuoMkeF24
         WLLgwxksebKlTgPFUh9C0idQ8q8qS10w5V37Koayju+WmT5nM4ItrwGDfqvSNiWF725g
         rt749V2HwX8bf1hD0eJJLAbZ1HLJZIOojbeWlV/r66sH+RA3cDIp3GbWyql5seAclYGR
         xER4pIQSIAo2OlBLdG3cg1Jvmaxy04y1Tlm6M6puix/UjLXPy0VK9yy9bbbqKHm+W+qC
         g+IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rP5o/eMOPhz1A5eUQwkaAxR1nnewuBUqV7uC86UfM1k=;
        fh=4xCZx9eV17YgRwBdp77uYRK5In+2e0Zockop5e3D/3U=;
        b=i94rUIhKr30LrOHb7BbnUKMbFqlbXezv5fXURaZACEYgsvP5TcHCx2n2MZJnKnl4X0
         U9pweScvHGNN18tldSmVLzo4cCCpooUqwMdwsnktyPOhuOo4kvczUmiBN0TWKkyLNHAz
         j5udMmZo/eHc/+MDUY8eq/EfO6JlSYRnf5LnidGRaLKUZti/rsmQSoCtGN5fhzbIIdW9
         XtslIHntFTwzoAy7K6lkZpYGxW1twkDFpR5qRg/Cfod+8GyaOx3jdbj7H3QWS9sBsWmW
         +PaAxgEkHM2J0Im/WDqnBhg7MbcqJbiaiiIkT2TFUc0y2B9YkhHWXSGSNzaPPycA36Zm
         0eNQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772552835; x=1773157635; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rP5o/eMOPhz1A5eUQwkaAxR1nnewuBUqV7uC86UfM1k=;
        b=veD5TKQwGJgmKvhdR4mtmw83WwdV7fD7STfLwemHWNEdKV8tggi1041rlPSwE1snsn
         H5/nZ+ngbIMOB15ZK4+MNdiTSqyBZetzoaHPrm8q0h0BeqOHsmp7O2Zyux/YzaJY0Huw
         Yz8NqP7CEea5NvwXz7kVxjNUzQZhnRXaN3+OlrXVwtT5mmGQA+SYDc4FFFPfrK8d/532
         1fMRX9WSunf2mHpW6ups0TX6ErtTrWUwvNGzNgVvidMi8IxvsU1ieDMe2y6gGf7kXL1K
         x4N3Au9tVwhx329F9lL8fZvVz256aF1dPLKpyqytKiN+irRcG9tB4ZczfwsUpz7EY5vt
         F3eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772552835; x=1773157635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rP5o/eMOPhz1A5eUQwkaAxR1nnewuBUqV7uC86UfM1k=;
        b=kosPTb73L3MWi0lZRGkoowVy07WzJRGJTW4vi/x4h49DuPNNPMtecfmzPOjXSol8tA
         wBg+O2lJWxu4Gbb7S7jorjb7I1ljkccnEoMmB7CIyUm5FpYIgOOJJkAndpP3QKp/i+Oj
         JyLFm9RqPAktmKn4Z6odYW5ybRslj5hNuYC99AuFMTGiFcE31U4SRcGO/jmm+FhOU6b4
         SIuzmmumSj3uyLa5d8+ghD7GXJemNvH2cT4iJJBazEzrhZrSQ3ni08O3VROs0h6Wr5KL
         dm9NEfsod7jCvk/BgoKKaMSxHxQzPET1aIufq4WQQD6v348aUdpNa7fm7Fa2OdaJktIq
         wEzw==
X-Forwarded-Encrypted: i=1; AJvYcCXEWtcBj8iDP/T6NcciDAuIV7/LgGS2kyDRHayFb+HITB/2FlIlUxAAb7j7MpWPwxamwnw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8MzjtqDGs1/FyyBrmzPP7VCQRUSyRsfzliRRdG4jXPqY2rHdK
	r4j5nOcNAeUctnOmgSOvjEVaDGq4tj1uf5aHSRvJeWoXg6I4rCLmvkSRrTxKCUFKe3nK9i17lhR
	+PFqLkWDXeZBgtuPcsVXnICakGgNUG4mdC2Pc2i1Fvg==
X-Gm-Gg: ATEYQzzEfI+rLzgLhcdUO1zSRphDuDOOUmA0EcahrckWL7FDCjFFZyNtfc3Gpv4XlK7
	Xab9xCshS3n9r2u7jM8d2672IGoYMghT0vDxvKLoeladxdMawvSM6w4h8qt7fY3d8UsMXf1SbHa
	BO7k0+dzhChIv5c6EMd14UeCGJHsUcp03O918cS1qn31DOy8rhQhJQQv3Ffls/b3VIoub2yfces
	eOkqNiPOtTffgfxcX/wfn4O5h47b0ue1o3Pibr8snq4+zLfHL17MQj2YpJI7Rj10UdpRxdEHYPG
	ujPvxSmJ8LCykYuc0NVCNny4Eg4wPWadASEsQN53KNWD3n/aNi2oEBGq8kdtQPNgVWnApsasAc2
	g/BL8Ujh4tnW0a06EAern+fhWsw==
X-Received: by 2002:a05:6820:e03:b0:67a:2e3:2236 with SMTP id
 006d021491bc7-67a02e33328mr4850345eaf.23.1772552834606; Tue, 03 Mar 2026
 07:47:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226191231140_X1Juus7s2kgVlc0ZyW_K@zte.com.cn>
In-Reply-To: <20260226191231140_X1Juus7s2kgVlc0ZyW_K@zte.com.cn>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 3 Mar 2026 21:17:00 +0530
X-Gm-Features: AaiRm53Tv0HzLC60XnuOQhFibZnnDvaLlp6Dmpq9sGHC5_WRwzY-t4oW2N6N_TA
Message-ID: <CAAhSdy1Z_rWHW6ra3DTR1h2NeVJoM72SZ85ph-TKWRQqYzrEmA@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Skip THP support check during dirty logging
To: wang.yechao255@zte.com.cn
Cc: atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, liu.xuemei1@zte.com.cn, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2311A1F2F19
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[brainfault-org.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-72539-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[brainfault.org];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,brainfault-org.20230601.gappssmtp.com:dkim,zte.com.cn:email,brainfault.org:email]
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 4:42=E2=80=AFPM <wang.yechao255@zte.com.cn> wrote:
>
> From: Wang Yechao <wang.yechao255@zte.com.cn>
>
> When dirty logging is enabled, guest stage mappings are forced to
> PAGE_SIZE granularity. Changing the mapping page size at this point
> is incorrect.
>
> Fixes: ed7ae7a34bea ("RISC-V: KVM: Transparent huge page support")
> Signed-off-by: Wang Yechao <wang.yechao255@zte.com.cn>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch as fix for Linux-7.0-rcX

Thanks,
Anup


> ---
>  arch/riscv/kvm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 0b75eb2a1820..c3539f660142 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -535,7 +535,7 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct k=
vm_memory_slot *memslot,
>                 goto out_unlock;
>
>         /* Check if we are backed by a THP and thus use block mapping if =
possible */
> -       if (vma_pagesize =3D=3D PAGE_SIZE)
> +       if (!logging && (vma_pagesize =3D=3D PAGE_SIZE))
>                 vma_pagesize =3D transparent_hugepage_adjust(kvm, memslot=
, hva, &hfn, &gpa);
>
>         if (writable) {
> --
> 2.27.0

