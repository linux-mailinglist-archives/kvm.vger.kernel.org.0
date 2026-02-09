Return-Path: <kvm+bounces-70601-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wLh1Je76iWkiFQAAu9opvQ
	(envelope-from <kvm+bounces-70601-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 16:19:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3123B111D3D
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 16:19:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C28D63020E96
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 15:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B7CA37D13B;
	Mon,  9 Feb 2026 15:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LKoGnH63"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465CA37E302
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 15:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770650337; cv=pass; b=CEM+HbolMYZGhTGIQieIsF5ipgeWpGkWrrpB50HM/YJwvk+SgijyjmmswCMkapnJHPh0DMxSpFBked3IovIHt5/31QXKPYJphaa+tMBfwrd+orLinbCbaSrS/NKS+DiSRDUMcwRTu63rn2ivz7w2S/JBjN4Dh9O5UoE0QfgO/vU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770650337; c=relaxed/simple;
	bh=e3bUDvDDCERCxLHccqCKh5cXslCrqGzgEb8uS+QsJ98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sLu5vUwsbyoH+rTqvPQ6N8CuoH9FM4eBR8Kkcm7XC0u94jjtuZ0IHoEYOUpvFXg1cr2LfYfyxdRG0FuBMHGL5KVdXOz/18V8jWlLHaqy09UHkMqmFrCyir8PbSf6V8TJCk3s7DSoWf0oVQi+LrKs+ReoDQ7SRCIDMTlVtJ6urXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LKoGnH63; arc=pass smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-7963aa14dbbso20832067b3.1
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 07:18:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770650336; cv=none;
        d=google.com; s=arc-20240605;
        b=C5BUQAeZS0sk7phOBhBipPCkFUQUM1z+S/hu+JO8B3sZvET4h2E00p5ochAfGAMPKb
         DuJbZpj/1ujrpvHqq091J6EQAYnq3wDsPG4KaMA1hPRxAaO8K6Uw7Bi3odNFGpcKQ/cR
         j8utwhG7rY9VYz4z9Bucngm/5Jv03oyBCyg263UbBZEjrXt/QxbgeCbV5WexjQMz1wZK
         PNsZA8t0NGYsTSBPTC/fxvli1UGkcQ8hqgA1XQOps2FN+sR5Q4iEQIopF2sdZJ68buaN
         koUu+od9MCnif25fp+8KTnW31QV4NKenJ4zdWKLqGnKWO0s1/ahLuorvAoM4LGavCqaH
         vIeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=e3bUDvDDCERCxLHccqCKh5cXslCrqGzgEb8uS+QsJ98=;
        fh=OCYfF5pv4FZb80V2VZ8dK283ODq3FfHJtetCXjxSq9k=;
        b=jnAem3tl2D6eUNCLrh/nRFUSg1aRk0/V85Ch93Ix0uzuZ26wPeqNykNDfhPn7jRsEW
         63mXgiTwMQ4Dva2crSNa/OX77kgvbLi+lw/RA+LkSYfQwMu4bkLdbo9rjVa8eYtb937q
         trkdIexEYOg8fcg0g7z/e0Vx3O1AUIkgM7uNxiQ7t3JsPbI+B5cKcx2oIfd8LDxtuxkQ
         oteoI+Kx4MR7Kav7bh1Jmh7DAWDL4K1DSbtTBf52iOgZf3tji794HGyM65D3PT8o27PQ
         GxR9vaT/q8UGrT4GtYFP+97i4/ZXKVFcQJ383y750oBc7UpBRdPcDTY3LPOJs79Ip4Nw
         nAzw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770650336; x=1771255136; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e3bUDvDDCERCxLHccqCKh5cXslCrqGzgEb8uS+QsJ98=;
        b=LKoGnH63YlYTTc2EIEVciBLSbEozVqYrEQBhkRJIkpiAtwcmgege5rWCHdYgIz6CZ/
         KLC73lgO1wpVMp19dGD4PfVCAYOqFQp2HSFIVPmRT8QvDvj7TyOx/yF6xGUATLAYJv+f
         Yp6XuheWTZhNVWe49qlpUGI7GTWmO0Xk1BFbILzHm2bwipWkLNrgoiQKQJumvOU5b6c9
         tkLIYzmYePQJL7+FxatCuXFWFpujuYzclSemiCpYhtI++E8QWZzWB9rn+yBWUw9aa2gN
         6GVNeQpMCdNB9i3So36vnniCPXmys1AjdIHqNp1BPExc8ojus28BCkacoD6wR+CUBb0P
         JtOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770650336; x=1771255136;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e3bUDvDDCERCxLHccqCKh5cXslCrqGzgEb8uS+QsJ98=;
        b=h5Su0BDQFu5NV21ed42mD1a9whKpIn8y460Is41KpRMVcPSz4ZcOw8rTWqVeiTo0I+
         IS7x3XeL/zVbWHlKIKSeLATbobPTCRDzS2X8ScW6QfEITIN6Rvjm6YCQMzB2Gufm5xfZ
         vY2O9metpmh/5gHzzsdYRblfCn6FfvoU28vVA5/8dWuRfVJ43F3ocdesv5fKcz0XkUNB
         pFzCgs9dkgg8o40LE1vkKRWA44SYLelX+Z4G4MYcIIyc2cjBeFppnGqCF4C4o/0k6YxV
         /LY24qZdqacXoFgq3WtPLTBnw13PpORxGwoMfVVCMhOEPL2qWTPon331XdBmLpX3IRhB
         wMDA==
X-Forwarded-Encrypted: i=1; AJvYcCWdhkCD0QtfLSaTWODZigfl4p6mSY2CuD9CGWs6urzyNe1l+ygrsVYb4xONUGP2Soy/2zI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrFqePr1401MFyFjpIKVhbBuhIB0ThwBbcyghX+/MtNXyFgRlu
	8wODn4Uzs9T7rJuTZxKzsrj9Sc7wCS88VE5Qy5vpCFtycXz0dic/8JEIKzmFbbSFpxMMRW3XblW
	L83y1BYkFOx+lxq8ZZP/rWryv+RrEUgIHNfzXh73bsA==
X-Gm-Gg: AZuq6aLtwOkp6GBko/EaJ7v7idnftgqZsE1y3H75fytRf8Ejpkyz5vE/Q7yAO9jeh8w
	Gx5yCFAa4mV8RRLKQ1LqC7f4kMzaSlFxEGWAFa7U7ZBiMETiVjdaTdvYE91KWZM86We+jmGiEnM
	GuihI0EursP7qUlOHQPJ1VHM2Z7TaVG6Xa95mdF13dlcqbm2L3vSxuXbSPRZ96COwUqlaov1wc9
	y5Bj0LCn/VG7y8xMrkIFNSwLMi0MHSpIN6zER6dm7u41uDy1x7JK0uY0wCditdDIBpJqvzrrdWz
	fZUdU9+eQKoMy/3bH+/AnjQ2GySeNxYy/5hZ8vRk29LFvSxPvvx3dSU=
X-Received: by 2002:a05:690c:e08:b0:794:87bf:76ef with SMTP id
 00721157ae682-7952a63ec7amr99106367b3.7.1770650335943; Mon, 09 Feb 2026
 07:18:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-10-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-10-8be3867cb883@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 9 Feb 2026 15:18:43 +0000
X-Gm-Features: AZwV_Qj3JfZxsU8iVNrT9S4IUwlHEkuMD3WG7W3HRrHxULDnwFPH-_uH0mM-meA
Message-ID: <CAFEAcA-nhHdwuQODmT4-dBCEuiut-jbHsCGVYByoMF77-UWbCg@mail.gmail.com>
Subject: Re: [PATCH v9 10/30] KVM: arm64: Document the KVM ABI for SME
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Fuad Tabba <tabba@google.com>, Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[21];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peter.maydell@linaro.org,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid,linaro.org:dkim];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70601-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[linaro.org:+]
X-Rspamd-Queue-Id: 3123B111D3D
X-Rspamd-Action: no action

On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:
>
> SME, the Scalable Matrix Extension, is an arm64 extension which adds
> support for matrix operations, with core concepts patterned after SVE.

A late reply, but I just noticed that the cover letter says:

> Userspace access to ZA and (if configured) ZT0 is always available, they
> will be zeroed when the guest runs if disabled in SVCR and the value
> read will be zero if the guest stops with them disabled. This mirrors
> the behaviour of the architecture, enabling access causes ZA and ZT0 to
> be zeroed, while allowing access to SVCR, ZA and ZT0 to be performed in
> any order.

but the doc patch itself says:

> +Access to the ZA and ZT0 registers is only available if SVCR.ZA is set
> +to 1.

Which one is the intention here ?

thanks
-- PMM

