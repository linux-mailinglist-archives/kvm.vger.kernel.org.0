Return-Path: <kvm+bounces-70951-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8B2WLruyjWll6AAAu9opvQ
	(envelope-from <kvm+bounces-70951-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 12:00:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C9F412CC6D
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 12:00:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B2469306B2D2
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:59:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A4CC317709;
	Thu, 12 Feb 2026 10:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Fz2IVjqQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7727318BA2
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 10:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770893992; cv=pass; b=SYNCABa8y8TbHsJ/Iz5z0J5GKaiweMPLOZVftC7Ar4Jom1W33pM/P3cBrcs2vB3wjjbHgonf35kaAfQJT9QAv2y49Jl2rwWPGi7JvZBwOrbWIi8dpdwNBunYP3KdfOOw0sx0h5z8hBlhdaGHTT2kxtAtmLrQYhCSwVCXNlMVv1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770893992; c=relaxed/simple;
	bh=YPpGn2d1qR+JIFpcscGES2bIhxc/uHptd1hk5dk6r6o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bF4Bvv5MXntqb83kLHl9tOZQwvxOkIwHvs2wdby8h2QiPrhLFS6+VUdKhakz53htRdPUuoCqeXHklhpU90S4ubjz20j9XXBaUU5XIcUjV3RzXqb4UvCjvxyWtFFCXNici3AWmFVd9zWVjrNR3xlmEhqO4oyU8Lz8cgoZy1bm03c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Fz2IVjqQ; arc=pass smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-7963a209b97so30925087b3.2
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 02:59:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770893990; cv=none;
        d=google.com; s=arc-20240605;
        b=cvuNrXy8YR4xU50vTpMHvEyapCmHgnZ49ZJoLC11SWzcnvSMva7A5+EBI/XeqD/3DV
         CYa4Pe6o1n9/fJlXUuOSFjGLn2XXDPLaZvg0Kuevi1rFc+TKbo1xb4WES+9/yfs6phgP
         i+ry9+z5gQ6CrkfgPrRmkdwjJIG0cd9vbNNFGT/Yrjto/kZD9UWN/GNwW1onF7tRGIvN
         MFr2Tnem0lqXESYuAvNUbyG3yXDUPGo9yUPPsO7Yib0r3Bdh7npZtpI8Sw53oIVZm1q8
         yEQ3u8IuVYExT6AXKMilY2orWqmD9DFWEBng9ei4iqrWtY1427DSFlD2lUgNBrPX+6cu
         pjfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ZVrbCSZbccxq6FEVA4SqZs6DjR06QQJ13wdUUSd0D90=;
        fh=SfAHqvSCw2DBFIn93jo/x89gnOls6jyQakudGRY/bxk=;
        b=beart39586gcCLqsMUMDE+aVlT0D1fPb43BETxdorMCbvyUMemrWsN//6HdmNCysK4
         FFnuwKzpbJpAsMpn7q1kTM1UMJ5ldI3+akAft4h2yN5lxSnPHRHuPYgyqTqugxqWC6kh
         on5eQPWVGBByUaMn3OoR/m/NJpGtzNi6rDnCgSJkeeBC1m/ojqGieBMRXEVGNOj1oQUl
         VVi8adg1mKVOdH+z6vudDkijs3ocCJDINljcpMWwOqPiETGcjAXlgGt0YfyoKEEy4sON
         QMyqQutmvuR2prIaVpozw0rC/Dc0NHbkLmHoE2CuOxovQ2uA7htO9UFj5MBEZk4m2ilQ
         NmFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770893990; x=1771498790; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZVrbCSZbccxq6FEVA4SqZs6DjR06QQJ13wdUUSd0D90=;
        b=Fz2IVjqQLgkGh/29KpRHFPBCXGPLJkJ+dxsQZwJn0wlv/GpdDTprnN6+gby2TwunMv
         ppvJVLzieyr3uflTUk8UAPWWW1WI5l7BjIX386bnYfqX7VMAteXxVGjW3uON1zryK5MU
         NMVX4jqT2e7bz2qPt34HkX0hsVHXuoH0YYrtC9103mf9/amNQscJ1oOlpnr+3UvQwkE3
         mZQHO7Y9RN+badMkPVTx5sbqzXi6n27dzqA3WA9to7lS5KSVVdVEV+HtllKmPI88EUP0
         TnRlLDq0RDwqHsMKrwP7MCAOKsCZotpc6ZxLLg4sllbqdwasisrBnASYv4Ia5YtsWp2z
         S6fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770893990; x=1771498790;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZVrbCSZbccxq6FEVA4SqZs6DjR06QQJ13wdUUSd0D90=;
        b=mNpM97xZhUDlZuGF3B1gdMqS2+PqibWPvBjQ/+t6sl4lYThmtJbhHMOsEtD22PYfRz
         viiTpddltAh6GO+v9EQJmzD5aHfXchNOiKYMUVqdiAjGR7mpgwPhOi3n6W9yr2IGNc55
         MShZvLO++SI7yUdKj7NxNDuj/bD8cM1yeG9hfwNjeAnUKyO6RvweWrSIjuzKW/UGiEgw
         gV1exh9TL6+FWyw6iSS+0yD58+piZkiW+SBUwrxveZNtoMJEXHT6n+BhAxRU6OzOy22n
         pqCRdHpADmP9vtIgLgZPToK4PMSotr2ebwIbnp5aoMcjoPCnhu/WHaNjFQOo03qiPl9p
         7qOg==
X-Forwarded-Encrypted: i=1; AJvYcCVdnKZCw4LW/CLwIRVWWbEUH7+wCrw1M9w1sXpqt+WUGoPBB6rF3bUYeWrc2v/Z7MLh+oc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXK0YZNub7pK1ZtfHAwarCZCYpuWvRmxPlQfaVwRlV2edR4GU+
	ZMCAfYmex3hMda8pHOmPqJiZycjnNqVXFhX2AGb2loPqOLbTq954INrC4gbPBNTcTfM/VgGS1+7
	W/zGvF/L0Yxln7+gzx3CtANx3ZCw+j9nO8TOGUbJTPA==
X-Gm-Gg: AZuq6aImLm9KJ5+kx8SPrbWsEXmPQEiJ5Z2I1QbMIKF8a9946JfKi+Wtke60D9c+DJQ
	UdZfLr9xzUW4RWkUFDwznKY2hiALyFAV/DHprG6odKNedIHohfAdcgLkEtkjXqvw7MtuT/S1JcC
	RhbsjX74jgQxUWQabfEas8HWtMh24idFGohabqqRVlRFq/rT4xotlw1fN8N8XdGnfXEKKvvNwvn
	K4sir/xU0b3IeD3Nxk6RNBojSTtV//HSuqXxVqdSZzMb3SZXVSIN3oQMLZxW0UCPZbRSYQAJ1Os
	P7Zt+I0pma4rxfrSCDY8swsI7Q3TsxiAxaGfxqr7joL5HXajor6GZYTBWaHdCrDHunk=
X-Received: by 2002:a05:690c:4882:b0:795:1e5b:f72 with SMTP id
 00721157ae682-797931fa40fmr27576287b3.63.1770893989787; Thu, 12 Feb 2026
 02:59:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260210201540.1405424-1-pierrick.bouvier@linaro.org> <93f8f250-7899-4528-b277-1ddd469c192c@linaro.org>
In-Reply-To: <93f8f250-7899-4528-b277-1ddd469c192c@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 12 Feb 2026 10:59:38 +0000
X-Gm-Features: AZwV_QhUuW1l9Jivyr7kErjs0tzcoD9IRR_bK5Rkbo6Gtl-aCqdZBlAQHB1UJww
Message-ID: <CAFEAcA9YUOxko51ziY3yAOaDfTCEAwqmXnifF=q_mkyotFHTcg@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] target/arm: single-binary
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org, anjo@rev.ng, 
	Jim MacArthur <jim.macarthur@linaro.org>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	qemu-arm@nongnu.org, Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peter.maydell@linaro.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70951-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linaro.org:email,linaro.org:dkim,target-arm.next:url];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+]
X-Rspamd-Queue-Id: 1C9F412CC6D
X-Rspamd-Action: no action

On Tue, 10 Feb 2026 at 20:19, Pierrick Bouvier
<pierrick.bouvier@linaro.org> wrote:
>
> On 2/10/26 12:15 PM, Pierrick Bouvier wrote:
> > This series continues cleaning target/arm, especially tcg folder.
> >
> > For now, it contains some cleanups in headers, and it splits helpers per
> > category, thus removing several usage of TARGET_AARCH64.
> > First version was simply splitting 32 vs 64-bit helpers, and Richard asked
> > to split per sub category.
> >
> > v3
> > --
> >
> > - translate.h: missing vaddr replacement
> > - move tcg_use_softmmu to tcg/tcg-internal.h to avoid duplicating compilation
> >    units between system and user builds.
> > - eradicate TARGET_INSN_START_EXTRA_WORDS by calling tcg_gen_insn_start with
> >    additional 0 parameters if needed.
> >
> > v2
> > --
> >
> > - add missing kvm_enabled() in arm-qmp-cmds.c
> > - didn't extract arm_wfi for tcg/psci.c. If that's a hard requirement, I can do
> >    it in next version.
> > - restricted scope of series to helper headers, so we can validate things one
> >    step at a time. Series will keep on growing once all patches are reviewed.
> > - translate.h: use vaddr where appropriate, as asked by Richard.

> Patches 1-11 are reviewed and ready to be pulled.

Looks like patch 12 has also now been reviewed, so I've applied
the whole series to target-arm.next.

thanks
-- PMM

