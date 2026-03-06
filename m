Return-Path: <kvm+bounces-73158-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0OfODzImq2n6aAEAu9opvQ
	(envelope-from <kvm+bounces-73158-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 20:08:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A44A226EF5
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 20:08:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 272B530216E0
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 19:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF95423162;
	Fri,  6 Mar 2026 19:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kfgg2jmc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1489B347BAF
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 19:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772824083; cv=pass; b=R6IYnXBciAIGvFahC4fDZYOrr4P5M6Da2v3g5AmAsx/T5UxVscYrqivri9fpnzw25EwzEK8skdNHv29auesq7Qp4BXIHZcOMoz19Mjrbw4zDdndD3hMXll8kPVmBRoT7sYESfkvfqXUgPmhBxEbOrjk2yJ4KrXA1nOxjqNmPA3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772824083; c=relaxed/simple;
	bh=hv+SWkBMfIM6h8iDTigeVxF28D0lz3mAr6Bq3vfGF7s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l9d2xkVjLhuDqdIou2K/VBL+tbZ43jqSJ6LGouxl26+V+bsyQGNdRtp5/nnAt47CeKADEuAiVE4niBOvpsGF+9ta+fCozmwfeN3MSehA5hGFeHUcF26YOuWaQtndjXzIpGzyMX9WS5GDivVmvhIikBSzbLskkD3x+u6Ink2ZXUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kfgg2jmc; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6614615fde6so895a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 11:08:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772824080; cv=none;
        d=google.com; s=arc-20240605;
        b=TgULx3dgKt2ov1DrNaw4+hLx7Lsv9CBsXa1fc3zog+AH921VwyjyCf0BDYTM8c7yRo
         +Ps/J0ztE/C3x82Tmsu7Hzlcap8XuGflxDPcjHfr6jfo8mez8nYNzznp2Yxi4bV+AAB1
         37UrmlcYMr7aFQeX/0PW6sbUDFmxg6EwaLicztyB4MjC5Rb+ViiiRpXshXqzyK/iH9aL
         ULBrdKbYVNuTIrrR0oCpf43tCzq6+BeVvAVFRCehLx4Z+rjbCZcL1t23Q34Id1AHzN/x
         ini9+1Im2JUP4qafPHqeEmoVfFGBAXAB9ELZpfFAjvExtOhIIqWNxFMsvXUVlLVLUqBR
         6olA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hWFuVHqrWQdkCIi56/8SDxmqtQ2+h2nV2TP+vRSYYmE=;
        fh=HTSvFTH596v7HYIuuGEKM2TpHIWc7i8mb5bM7dKxni4=;
        b=Ryh4H8U6EKEImLJbzaZqBABKoNSkxkOxp0whubIZYkJgEkxSTFERkS6hGlmO1j44DJ
         M3YwAD6KI4SkjxTRwqDr4TYhmWMqbGwv2zXv2SF2MDv56LFtumi4JRtseEkGd+jPXPwc
         9oQjTByEwV6rZM2K3vWsCMhZwGcgNeFfKCzvGwdLp01bkSMCZcWrFziHN0dA4ptdE5Dm
         4oqg4H924vU6q4H0QKrT48qo4R22BlDy9dQ5uluZGk/6SrbgoDGb6dP7Ary7ABwyXdS9
         zhCgnStcChBB7fsTOLnIdWsymJoQdvYC7zlGys3cL+LQZhyalLMmmOLRVGGdIZ6P2+/u
         5Q3Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772824080; x=1773428880; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hWFuVHqrWQdkCIi56/8SDxmqtQ2+h2nV2TP+vRSYYmE=;
        b=kfgg2jmcVyvyW60a/Z2yFvtuZoF6gkaZsQwpmHsn6Y4h8NRyP7SeOgUWUadt/5kO9U
         ZCsa8fTYKyyFT7ISD+kS1alpoa9Gzib7ktSwHlG7DcJKopbSmV053WvIpdCeEpX02WLH
         P+hYfHWIvKSz5GMc3LukgbETNj1i52HWNlT8lTScG564PZcQrMIe8f38pHv806Qsul1/
         f0f8s8euw2lKaiDDbvfR9bU7Rr9ReLdsnKJ33mk9D87X2Z+xJ42WdQsgt+Ynv0dnR5Xr
         dz+Gvk3gko36rUW8p3hcmUY30tW5CGkkQu6fqURXOOQb4goWJb0auyzrn2RDq1clQcuJ
         j1zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772824080; x=1773428880;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hWFuVHqrWQdkCIi56/8SDxmqtQ2+h2nV2TP+vRSYYmE=;
        b=v7+SdppaR/F/N4ur/aq8KnXC1PbdwtYadon9d9ksx/C3Ng2LN5WTigMCkrMqwcOHtz
         SH8XFGv9hi0j48ny0pgTxjiINq2vJrKOG/ULmyH5EydPkhiCWrBxS3i+BpMtku3LkeQs
         TCJlAttEbq0hbZWMKV9qkKeNz3VtZsnqou9xkl6nTOG+TDfCMrNGps4bh2xRYRnt97b0
         s9niMZ6qo0QFqayPMCCe4X9zG1SfR1TrRslfAI72m7srMdCCcBTwLw0KRt3DJNR3w471
         J+h2Ych3eYkgIHwmogIrd+YmRYF4uwR/j6qC1kuNUEL5On03/fqXgVIQgF9KCnjF8pAT
         spYg==
X-Forwarded-Encrypted: i=1; AJvYcCV34lCIB2FJPRpsLiAYWBQ4BB8YhaWemGuaEvFdgMwtPT7uqiLbM1dHzOYrbs/SPktmm0k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjhbu7ktQS3z+kY2MK6BEqNlNXF8BdXaEla10YP6/GemA4p9Ok
	HHsSul2XT6E5RSIIfUGkX8Mos/pi1cyfh//UYaNQHDFEAHqa0fdj9XkxuvwJLm0Snu5Qcvft5RN
	a4VLh5b2U6zLrYe2tU7M5NOA7mLttyQVga4bTag2F
X-Gm-Gg: ATEYQzxQpA3hSFbgDEtjpqRSU6Ag0OefFYDTNKEaWkpWWMsp/dwTS9kdS7xN5UxqTIr
	pnJpOFakY0SCDmV91SdRXLflw3KH9lXcoBS1NFn9iKeJ3TLKV3DOjJ0/Pszb7aGc/VAY+5Jxc58
	UhOrGmisFAVSZVhJHT3nFKity8lN+bR+x0YgqkGoS8OIwsucAqG9KPUXhQ5Vwx/TTcfsGiTD7YD
	xNt2+xbtj7TEa7G45MhvTeqy5lG8QCtH6W6GzbrrpgCVIfLIlRU1wTjWMTHSI/vs/RRXW82bk0G
	eJiovhQ=
X-Received: by 2002:a05:6402:518e:b0:65f:76c8:b92f with SMTP id
 4fb4d7f45d1cf-661e54e38d4mr6063a12.0.1772824079683; Fri, 06 Mar 2026 11:07:59
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9d50fc3ca9e8e58f551d015f95d51a3c29ce6ccc.camel@infradead.org>
In-Reply-To: <9d50fc3ca9e8e58f551d015f95d51a3c29ce6ccc.camel@infradead.org>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 6 Mar 2026 11:07:47 -0800
X-Gm-Features: AaiRm50fknlEJTPW8I89EMRLqWq6HVWfF8qp41dFSrcgmj0ubMWR1goK0SnrdV0
Message-ID: <CALMp9eSvMnc7kd19rTqLgcVNQd8_y8vp98JASYtPQMfuCObtKQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Fix array_index_nospec protection in __pv_send_ipi
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>, Thijs Raymakers <thijs@raymakers.nl>, kvm@vger.kernel.org, 
	Anel Orazgaliyeva <anelkz@amazon.de>, stable <stable@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4A44A226EF5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73158-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.954];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,amazon.de:email,amazon.co.uk:email,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Thu, Mar 5, 2026 at 11:59=E2=80=AFPM David Woodhouse <dwmw2@infradead.or=
g> wrote:
>
> From: Anel Orazgaliyeva <anelkz@amazon.de>
>
> The __pv_send_ipi() function iterates over up to BITS_PER_LONG vCPUs
> starting from the APIC ID specified in its 'min' argument, which is
> provided by the guest.
>
> Commit c87bd4dd43a6 used array_index_nospec() to clamp the value of 'min'
> but then the for_each_set_bit() loop dereferences higher indices without
> further protection. Theoretically, a guest can trigger speculative access
> to up to BITS_PER_LONG elements off the end of the phys_map[] array.
>
> (In practice it would probably need aggressive loop unrolling by the
> compiler to go more than one element off the end, and even that seems
> unlikely, but the theoretical possibility exists.)
>
> Move the array_index_nospec() inside the loop to protect the [map + i]
> index which is actually being used each time.
>
> Fixes: c87bd4dd43a6 ("KVM: x86: use array_index_nospec with indices that =
come from guest")
> Fixes: bdf7ffc89922 ("KVM: LAPIC: Fix pv ipis out-of-bounds access")
> Fixes: 4180bf1b655a ("KVM: X86: Implement "send IPI" hypercall")
>
> Signed-off-by: Anel Orazgaliyeva <anelkz@amazon.de>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/x86/kvm/lapic.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 1597dd0b0cc6..6eff9a7b1009 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -810,16 +810,16 @@ static int __pv_send_ipi(unsigned long *ipi_bitmap,=
 struct kvm_apic_map *map,
>  {
>         int i, count =3D 0;
>         struct kvm_vcpu *vcpu;
> +       size_t map_index;
>
>         if (min > map->max_apic_id)
>                 return 0;
>
> -       min =3D array_index_nospec(min, map->max_apic_id + 1);
> -
>         for_each_set_bit(i, ipi_bitmap,
> -               min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))) {
> -               if (map->phys_map[min + i]) {
> -                       vcpu =3D map->phys_map[min + i]->vcpu;
> +                        min((u32)BITS_PER_LONG, (map->max_apic_id - min =
+ 1))) {
> +               map_index =3D array_index_nospec(min + i, map->max_apic_i=
d + 1);
> +               if (map->phys_map[map_index]) {
> +                       vcpu =3D map->phys_map[map_index]->vcpu;
>                         count +=3D kvm_apic_set_irq(vcpu, irq, NULL);
>                 }
>         }
> --
Reviewed-by: Jim Mattson <jmattson@google.com>

