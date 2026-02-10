Return-Path: <kvm+bounces-70810-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AElsJx++i2n7aAAAu9opvQ
	(envelope-from <kvm+bounces-70810-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 00:24:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C6C1511FEE9
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 00:24:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DCAFD3009F3F
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 23:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76DDD3161B1;
	Tue, 10 Feb 2026 23:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hZw00thj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CE6314A67
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 23:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770765841; cv=pass; b=TnKXh4qLlKBraF89bAL+m/JX5qOB70NuTlPx6QEDDRFrcXBqSJ+vt9pBzpgiR4sdI1eepO19BQ7yCNbNDvtg9J4P8gTg/eINfbhS+2B7fc+wofoJ6mYgU0aCBn2Q8J82kjlcRJM3o+XOaRoMfMDzC7OOvzHKppODO8JrOwkJgzU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770765841; c=relaxed/simple;
	bh=jVee8sTZPOVyvV4NSVqulZm2D8qDg4uqjFiOubPIuO0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vCzCE82Rfp2tvyUTPTZWue7pj8i+HyRwv5zqq+T2oBY5WlK2aYyOHljnXDHT9tEP2UjwBTBOEqMStnd/O2Gb/zT1BAJiJOXQVQCHQIcb92j946tNlmLduU+zojGh7Cq9J9DDN6MG/pfnh8CO9y0rAk0596oCkZE9eEb4HsbV38E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hZw00thj; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso1611a12.1
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 15:24:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770765839; cv=none;
        d=google.com; s=arc-20240605;
        b=jdoFHET3FeNz71ZrA9FPOF4wp3WKvz8KF9O4nLMAdq41MB9T0uGXLTcLXJtwIlL1ne
         rGyOgjsm8UJEH7fJhS/UBimjFRdXLv0/0CZuoDsgUK7KM63N35a1NkC6kKg4dGYhfcOy
         dTibktldcD8kISAr7gRYtA2sY7/8eISrPQ65sfFa31hB+4w2NFJHDhWXM9ukM1fgUl1R
         AZ5WhCN9gbZFg2IhBs8p6VAmhsPUVbgK1ezwhRZMS2Nmhj47GZdNDPr5vlxz/KcT6qDG
         Zy/hynYjPwJdYPOs+Odd0EwbD8rT9xwu6qphOrWm49tyoJq+As68bkZqO/D33ccV8Hk4
         emtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ub1hWhOxc+s0xHxxEFMuWN/xFvdsaBHraLgoaLBm7ho=;
        fh=Qgbj5DttHQEY94DCJc2ZujPqJHUyskIlY7UxL4mVBEw=;
        b=Gm1emzzoYUNrpW3iSDGbDjmVdvNeDJ9I7c+t8X9qusRcQ4BWRA/UA94CbozqIa92Vm
         e9zkjR4KkaedlRMw61yPE5lALz5IsrJUN3yOJB33zFLr1rF/M6IeHvnzpbvIX1XNuDVd
         pIEF7Q1JTz9bBPqbkgYqNpGk9jx+dW52H3AoYom4X2lT8osPnNdkCfNrnNLE/2SU91tg
         ETxPV24wFmUBxXzwBqc//vfyjDFhIqrtSNiRAX3ao+04DabdULuYSw+gdemoPd6yE7FA
         E22kKJk2F0LpLo00XXQxxJAjjwwt7Hztfl62jU3dksTLQEhGibBBo+TdAzwftoGg7+xv
         Qutw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770765839; x=1771370639; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ub1hWhOxc+s0xHxxEFMuWN/xFvdsaBHraLgoaLBm7ho=;
        b=hZw00thjvyrzkwxAzvuO/WzENXHk6cfHn9MMmLNxUzM6illfXXESsgBRb1L6RgYdgd
         wtMP2tvMXxWkl8rXIF+mU+vpdQKPTj1/XrwYRQx5hLlYhrM+bHVUmLtemjfiYfLlot/i
         4Wsp/5kkmSlyTQnB7V+1qIsDcxi3oH04kEzBzOsxb2pYqjD7QP0PE1wBHYlBTOsutl6T
         pzn9g2pNCcVrcVMYZk0Z2HTK2hQhqbnuPMG08dS6TYuBNevqTXK+j7wpFCbX7vXAZsrR
         fC6ezNcMuPFsggwZkijUPOZ4W6pzQisYYDL4vDEu64GtEv7QpWlQwC7MOonwzpCHetjj
         9Ivw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770765839; x=1771370639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ub1hWhOxc+s0xHxxEFMuWN/xFvdsaBHraLgoaLBm7ho=;
        b=o5gFFS+WSHn94E4BrPV0SEXykhV+yWLvznapCl9LhOrJNhpJth8WZBQPuEJIhbVWv6
         86GA7ieN0QmaRdMvNVnuKHJ6X2keAajDTzLEdd6hIFFwfBWQ52utMY7edRzTSHnZDYcs
         wcTZv3SJRQqQTgxCPuBVWXctPMhxDTP1Awjiko5nKniqeRE66vT3RE7aJomSVU9U/O7n
         GaPdJy+PFUqCijiCVWzelW8FmXQbPs7GwtfWr3oAkOmHAazGSS5o88j/F2MqcYY/O7lY
         0940NqWK4ZxnbQM/6ikd9FYBSLiqU5YKXnkh6Sk3rWykG/guZRJSngxj2Wc2sYFXnaIP
         Gk0g==
X-Forwarded-Encrypted: i=1; AJvYcCWIfFZCSjQnxe00JvNmO1+Bz1Plw8zZtvRBFKW+WK2UpZqZ0SYh+3d9SqGTLwk2tbvvtOs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk1jZqwVnNYzzhT8A3vjVjebCbJRKTKgPm1wPcfW+kEA+zzibw
	n7xk9JNmWXDrflBUFodBnvwy163IfRTKmcKKwOlCg7Mrmc7a5ZRTeZG7uJKB9HFuMXvxGASHNtv
	jwS2dL7ypy1J0iCstfG/OTKNhpHYlSZC/72BtrXkU7xyixYopRnRVH0LVhc0=
X-Gm-Gg: AZuq6aLU/EliPTGA9T6jEFlmewkXjCRHxy1GAjNZ9ZKe08c42jrmojcmLmU/y78ImjI
	YbMRJYzDhFfwNE6MMIZs7Rx1/dTB390LSdwYAWrcg/VqAHGiQESuIE4ubueSbj9DkMq/uIc5OPl
	IQnyMEMnBEWUHKv0Fs1cApOyWPiYz+Q2g0t0QU+w0oFUyq2CKXxa3LfcojwLJNki20LBPvdnh/q
	SHvyc7UBEP9aW1mXV0lbNUpmd7m5pLTJFbUXEpjmbBUO/Aulq3fU95hE3syDH1/vQz2dOVaNKE2
	vrkWDWBuvpCjvF8wxw==
X-Received: by 2002:a05:6402:4508:b0:64b:2faa:d4e8 with SMTP id
 4fb4d7f45d1cf-65a3c6f53d2mr4531a12.1.1770765838634; Tue, 10 Feb 2026 15:23:58
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260210210911.1118316-1-jamieliu@google.com>
In-Reply-To: <20260210210911.1118316-1-jamieliu@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 10 Feb 2026 15:23:47 -0800
X-Gm-Features: AZwV_QhrVKxrrEOy6FOk_YOebRgSEeu8Y70mHDlDaRjUxa-9HZhmLsm7WH3bmgg
Message-ID: <CALMp9eRGVC-xtH1aVSVXwZZFskyWVNWzqcB2PHjM3qmbNK6m6w@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Virtualize AMD CPUID faulting
To: Jamie Liu <jamieliu@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70810-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+]
X-Rspamd-Queue-Id: C6C1511FEE9
X-Rspamd-Action: no action

On Tue, Feb 10, 2026 at 1:09=E2=80=AFPM Jamie Liu <jamieliu@google.com> wro=
te:
>
> CPUID faulting via MSR_MISC_FEATURES_ENABLES_CPUID_FAULT is only used on
> Intel CPUs. The mechanism virtualized by this change is used on AMD
> CPUs. See arch/x86/kernel/cpu/amd.c:bsp_init_amd(),
> arch/x86/kernel/process.c:set_cpuid_faulting().
>
> Signed-off-by: Jamie Liu <jamieliu@google.com>

You missed the cpuid faulting check in em_cpuid():

ctxt->ops->get_msr(ctxt, MSR_MISC_FEATURES_ENABLES, &msr);
if (msr & MSR_MISC_FEATURES_ENABLES_CPUID_FAULT &&
    ctxt->ops->cpl(ctxt)) {
return emulate_gp(ctxt, 0);
}

