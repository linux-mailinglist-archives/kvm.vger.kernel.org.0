Return-Path: <kvm+bounces-72508-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IAz+Fi+XpmnmRQAAu9opvQ
	(envelope-from <kvm+bounces-72508-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 09:09:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 08E771EA947
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 09:09:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0553C3041B0C
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 08:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C1E8388387;
	Tue,  3 Mar 2026 08:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="NBFLvGiC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295B6386C39
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 08:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772525256; cv=pass; b=ucewC6MQMaxomE7YaXG+nXHHn7CC5A1Y0GoT2uy6JwiBHD8WvZdRYy/WDnaxaaXqzW5RLqh1LDE5IRDCbaaodMBk076CVu0ATuu2zJq46mv9nrWyVqYq7yRzm6Odn3tC3w9OzIjnIxQhQC6jr43TAVIq8hiVce1S+c3OmZJEc8M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772525256; c=relaxed/simple;
	bh=eQddYmpe7KLa+sjIHDOmTwVWBwEEy/PjaUMH+rk3nC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KYOY4z9oHPxvj6vNQvfvgPIEG28FA6lnPRTNBtm/v4srb9xM/t5Mc7htLObdpLGIg01uj1hHPb6Y01IYyYKp8jYmi1qU3Y6giU9w+NNBUsi8T64IM+S24j/kVZURQ9PrRXKRHHOoK/jUi+/Jx76ftAP6v3AG0Ssr4biehfOjloY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=NBFLvGiC; arc=pass smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-679501fac3cso3618498eaf.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 00:07:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772525254; cv=none;
        d=google.com; s=arc-20240605;
        b=CO0dDH8Y0zz/5ZBzAYBY+5aFtlyDU6q2W7V03XTy8Ix7X/i2Obl7jBO4fEish8/lB0
         KwCwd2N1EgW8K9N/RUc9P9orrLmxNDoukakQ9n7yWf4cBz/J1xvb1o1dXhETfbeaFgBt
         YYsnbS4k4zNkIoOriKopT2BXNOV+5GuqfPcRdVWT2tKBLErN+AxYVjm0ZikxBuXMRSHf
         HwhC12G2vOD3AHyVJYSI5ahJRQ5+w9tbTTHYJN5oVmfIIYNxZ5erv8LFDOClRfKPMoIB
         n47ZPDbcndEc0Q19EHhJ3lS7hmakQ2Mr6CRATPpnQpU1+ehw4iKxbhn6gAr8lCgPvAj2
         KBVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GuqFHghzfd5h3VXh4yNDT2Yb5ts6QshO2bl6Hh7Yh40=;
        fh=OVGdWdWQGLQmT7YlagK0eL6pe4zdy82gkRsE2fob2PA=;
        b=KMM5YQ3j8m4Ave3cvMIeYSqi9sfq5hCo4CaS+8NnSnyqX1rO2/SabjH9zsahEJ1wuW
         Ic508bYZv4VXHjRu83A/HyY9U4TwzdT1KLk6PDsw66P0zWvTGiOTdllqY2Emd/tUpe6f
         ELZ8U18laauZBWP8mZNgr4LjUaqDvMm+KjxDfcp7vIeAX+42Jm5ngJxYj9o2z9PzcAJ/
         YKwnz9ys2pC+x6yKgHm32uycNqyHZFFIJ8WVB3Y+3zPdF0K1oSA/PEzsKEXPzFyke/S5
         bmOclARml78VluznuavKzy6SiUzcFJk0u9jWelM9IqWr7bfv+zrybE3If6LTAsHNVCO/
         sDFA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1772525254; x=1773130054; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GuqFHghzfd5h3VXh4yNDT2Yb5ts6QshO2bl6Hh7Yh40=;
        b=NBFLvGiC6O94APVvINuZEb+qFUj+pPWdaTRd74+Hcdv+nTeGgkRgAmcKHvckz3Zz6c
         Tf68qa9tI8VfrH63rWR6bXdYbL2RcB8i+WapBtWQ9rs7DiUUKqaxhGWLzy66m94Nl9IV
         DVePKnip5bvsDhe+yEBCBEfy1Sxzk6yYRrEIzUeEn6doCU39wrMJgB6mSkfVi7FTzlp+
         Dnto8o6KrlGQo+ItvM/3/l9EdLdSsw4R0VLnC2gTcm7fhB6ubr4FKteNpf4gikUzlccO
         GHogg09+21EYIKJVNVGsxO+pIG221PDCkbsRoiQ9F/T5TyEN4ikXDXmd93xGKjBl5xQN
         oCAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772525254; x=1773130054;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GuqFHghzfd5h3VXh4yNDT2Yb5ts6QshO2bl6Hh7Yh40=;
        b=RVRc2/BDQiq3Qt8cKBaPLELaJlHP9XZu7klXqPXBUBFY10rH3JUGKT/dFzV9jv7VeR
         K+h9rRJbPCRmOCYkRfdVMwNGc+jgyQhz3kdv0c2EwJtUau7clGGfLelLJmF7nob5e+r2
         mdLaTSRB7zR2x63wpC1qr/RBb2Ju5NdWyi+QlTov/xjrVZvwmf+jXoOWDuYY/J8nKyZS
         22HxAWIByZaRxj6qTTA9V8eqXvRgI53NIcUtkHqgYIU3ssrYhw6vwYl2yFsUqCfUh4/s
         I5kn56JMbsFotdCzkb3ZZMLI6fihYcdwDfazXOPoFP++raY6B2mXSW3qrsyNwIlOMWr+
         1x5A==
X-Forwarded-Encrypted: i=1; AJvYcCV28q4G5YSfHPW6Aqi6OME+A5yWvGHjYxkwkzPYPWGnFBGLIadABdOkSUnwvqY/+gjy9+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUqQgNKnlmBmWcUqEyXD2aM9iL9EdVj7v76FcSVskoW1GmeYua
	/5QGWcm36yZ0w5MkC0rDoZmryHXD8C9vDb8gGDkTVB8usr7DLvmHUgk7bjguS/iUzDfPRKc89uy
	U1D2mc0FYFZyKxyA+bmS7Gc0F64MjuSTtuCgfD6eaWg==
X-Gm-Gg: ATEYQzwnNg7Wdid2MY0424fPsYkW1BSBEk37ZDzAmeHgAG8QsXe33KtDvno0IeSYjXY
	v3zlkX7CvGXgQM5ypr31Cibv1ulyCZCqIRaa4N1/BXCQZVCd/CUu6szBvpeoAWnjI3nLjtuF3Ny
	UIOgDiukZ0ieKfbV87bxxSMW3WOtq5/lMwhxv9BcqvaccFfp8557nC6lgv/NLFq1QoMQpgjjEuw
	l76SpMvzm3hVGymL+CBRTr0haq6a9qFyrd5vNKNIVglFNUrv+muRzp9Ew91l8mVTwVscCre7pPh
	bscVPCeHgmrqiUoQ8jn51D4k8u0PHdijD0qRfilZaT5KnbxzRW1KCp7b4meS+6n/KxtbHSIfIlb
	4nhATRH6jn0BB4oSODSEASg2rPA==
X-Received: by 2002:a05:6820:201c:b0:662:f74d:69f5 with SMTP id
 006d021491bc7-679fae7d3dfmr8743971eaf.31.1772525253820; Tue, 03 Mar 2026
 00:07:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226172245358qVZavIykLL2QC0KoqTO-I@zte.com.cn>
In-Reply-To: <20260226172245358qVZavIykLL2QC0KoqTO-I@zte.com.cn>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 3 Mar 2026 13:37:22 +0530
X-Gm-Features: AaiRm51tbzRHHGrkI3BQgXsKymJuy3CHgi-XuP_FlIJWr5ikP6Oe5JI6W0vZKCk
Message-ID: <CAAhSdy2uJxYX6r1K=EWEqqYoZ1BjJDqkYC+Byv_3Wy65xDyCaw@mail.gmail.com>
Subject: Re: RISC-V: KVM: Fix hugepage mapping handling during dirty logging
To: wang.yechao255@zte.com.cn
Cc: atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 08E771EA947
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[brainfault-org.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[brainfault-org.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-72508-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[brainfault.org];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anup@brainfault.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,mail.gmail.com:mid,zte.com.cn:email,brainfault-org.20230601.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 2:52=E2=80=AFPM <wang.yechao255@zte.com.cn> wrote:
>
> From: Wang Yechao <wang.yechao255@zte.com.cn>
>
> When dirty logging is enabled, the gstage page tables must be mapped
> at PAGE_SIZE granularity to track dirty pages accurately. Currently,
> if a huge PTE is encountered during the write-protect fault, the code
> returns -EEXIST, which breaks VM migration.
>
> Instead of returning an error, drop the huge PTE and map only the page
> that is currently being accessed. This on=E2=80=91demand approach avoids =
the
> overhead of splitting the entire huge page into small pages upfront.
>
> Signed-off-by: Wang Yechao <wang.yechao255@zte.com.cn>
> ---
>  arch/riscv/kvm/gstage.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
> index b67d60d722c2..16c8afdafbfb 100644
> --- a/arch/riscv/kvm/gstage.c
> +++ b/arch/riscv/kvm/gstage.c
> @@ -134,7 +134,7 @@ int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstag=
e,
>
>         while (current_level !=3D map->level) {
>                 if (gstage_pte_leaf(ptep))
> -                       return -EEXIST;
> +                       set_pte(ptep, __pte(0));

Making a leaf PTE invalid mut be followed by TLB invalidation
using gstage_tlb_flush().

I think returning -EEXIST is the right thing to do here because
caller has to split a huge PTE with proper TLB invalidation.

Regards,
Anup

