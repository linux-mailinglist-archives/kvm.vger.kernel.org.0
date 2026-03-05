Return-Path: <kvm+bounces-72955-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YPhVKcL5qWncIwEAu9opvQ
	(envelope-from <kvm+bounces-72955-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 22:46:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 52952218986
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 22:46:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5870F30D912A
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 21:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9CEA26738C;
	Thu,  5 Mar 2026 21:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kSnYiLGc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA68217A309
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 21:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772747161; cv=pass; b=nR8o9CPpNaAnCLlGALBeMTNpFU3SVTdFrOINbZqVulAnT8ETt42a6BoPdeRkbCCK1bXeHjq5XwsUwAn6pLlCKF0lveLrPAiNojpVHowJ8e+zvqdlVHqkfMG3Jvc6vOsbTo6i9q9URRpKe1MdiqNAc8P19Gg903t3MlIOv7+FoNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772747161; c=relaxed/simple;
	bh=YaKdltjClbHEuMpp++nhAUrSVkcQl2PfYPwNfsXp0Ac=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=NPs7+tjCJHzUBZtPnx7VDQdjXI0xhM4DFE79AKJ6+9hN2RNAYHh5ZSpJ27ATjMHIAzc1UZ2PSLKJPUGbuB7Ymjn3qBQiaZQggCtyk7ixLZ9fEl6ocbn7S9arZQRZozvPXsgzJPnQ4YGakxCZUsEjKw6M6xalLSaBpPqk84+4vEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kSnYiLGc; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6615c766e60so1694992a12.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 13:45:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772747158; cv=none;
        d=google.com; s=arc-20240605;
        b=Z2/mH3fL71loYR+O0lHbV9ZpLM2K9JDBzcV3gZVSPzL2xqhyUpGsyoLThoJSLHmeK+
         ECoaQ/d40h/TZbxZPdyNVifoAQVLeKGf+SMAyTvY6Kw5UaouJwt9PlFoYHh8cBDHLZ7k
         ADpVIjlXuHo8eFPoPTFVl9d/hynmAGQJ7SXPpcxWzCfWAqaSMSxxHvz9naQGjMwldQlh
         EA7mptgiMbCqvuFfCjCYW2ydcCV9CYeMsflZ3N2IEAsx7tknLrxhQo80FiO+MBxiKSN3
         URYLgE91/Ag5GMRYNNEbQAY+K+VQuy/NkUYOQ1oOqMWAXa8Bm3te2nN/FXNOMTtpkg3Y
         bxPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:mime-version:dkim-signature;
        bh=1eq0dg8P0oei05O91XHenAKQcQm+LgczGfG7JGvn2bI=;
        fh=QLl0JjLs9menGLp2t4mpy5t2PJir1BvBv3KZgPJ5mjc=;
        b=PzT+lIKVHHvCI918/BtstL4xr1UhFpdaTpMZSADvdruAx1kD5jhZDCI6iSJLDzY0td
         P5LlRKJA4IAA7gL2GxwYhy4S6dBvp9E0vxOALDipXAn0JfrVc2z2fTlr0TmegRS3bgmV
         BwYHZ9YeBI05hzpGn6sUheurmzuRHJWfWH/kzeTIi2WWMsUH8OPRygmu8XjEs9XkU/j2
         eTRcdOYkzmYK3LXzJbaqVdyIzwHmekfdO/wD9NX0VX79PDOq5GYJlzKQALy0NDtRVYoW
         L99X27UcOzFmGE+F5H6f9cGWC9077I1pzKo2wabH3VD+MWsO0iUQ+sFkLUvbm1GIKmR2
         SQ/A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772747158; x=1773351958; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1eq0dg8P0oei05O91XHenAKQcQm+LgczGfG7JGvn2bI=;
        b=kSnYiLGcmMKi9O+QYebG8JGfPsV9xf6ZY2x5sHt3INYyJHPHNPjy8SgpYUuufBA7j7
         gY31eK8j2AZ4Omnslg25Qt9MMQ9DSb5Hv7bHnf07aHWsBj4f9PedJla7b+pXExs+81IN
         iK/Veqsg1bot2jgmhItyWX8v8QFSty233UCFng2V3MTlr2GvuZXxWkFtT0AXRfDQYNKX
         T82dHOzYMLIafWIWnN9INMLFKMaKHmsKROPbQNDj80a+boX1NMNGxi2GCK/J5iJFNQRh
         8Jeb2aPt2b4ruhAH8KAr+miqu2USvev0rRXDse30iZVFfQ+AVrQU0XOAlCCfpBiPTiVS
         WX8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772747158; x=1773351958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1eq0dg8P0oei05O91XHenAKQcQm+LgczGfG7JGvn2bI=;
        b=KfI0QQEUCrSTPDzeUW0p6nSgs2QIBD045WLq65doV5JRPthY/tuJyB+MzT588kaJZu
         oe6NUuLr9wVEkUvdHaVRK0QNBzA35bGitIUAKP+4teAYdEI7LhJs3j2qlSUx3Q+ieWEi
         CdYhVi8jKW3N9p+YI9nLcW9f8VhKI2vB1kQyf2ShO1L+gOi+ZaH8iu+0XuHcitgApnT/
         zcPCfmA3XE+ZlV6UlkX167EWwoThlHTld2z78BQMt6NUOQvVSrF2NB3Fpa75yfaQC4Z5
         4xwX3raTQvR36qUIVRaPrw/00wwol5s/ZAuCY/vBadmkDWq0wtxBm5ll5g2zjcOvcueZ
         GgHQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5+s01WKkpdd5VzRHqvTk4eEuuTpOKn64GcslVj4Vup6e7eE0QN4GC/bhYq8ydaalfiRw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFhTowoDNWqmJ18e04ThN3+bA8K2QrSvMRdwxoyGFsuU0ptoFP
	oIOQPQ3a9AZXAWlYZhqzrqpNFUdrwd0sMIFvxzMb/KcZjvtMKq1B+ExuyToIY3UPSiocYOx5m51
	cbjieXQZCcBax4212K0l2oqeiONHXpRnrzuzushg=
X-Gm-Gg: ATEYQzx1ySgJKrHT/xKb7l09hdGANyrKRAkFAM5dxXMZuXE8OZJK2t+eR630lUqDK+j
	IIQRNuZFNgoD6xxmUqZi7RAGBcbve9KhwnIIUXQitp56iof5QchyvB81PmsrTBE4Le9cmm+VGVv
	Ti4vwpn0G28yeWas4aML/vsHwNgT4HoHnCF12lVKuNLDLD27aBdce6bmBjKoSzWwOzONZcrRTkN
	WsAQAGORaHAycHFObiJn2FNK7YywocteuW83ODPe9G9Dp50urtV5KoKV4b5R+tuNZZGgbE6C4QK
	u/k6LEC5nOwvHLWLGCn1RX1rP/5tDP/JryJghMA=
X-Received: by 2002:a05:6402:3641:b0:65c:23f0:a7f7 with SMTP id
 4fb4d7f45d1cf-660efebf25dmr3182637a12.20.1772747156850; Thu, 05 Mar 2026
 13:45:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Reply-To: ludloff@gmail.com
From: Christian Ludloff <ludloff@gmail.com>
Date: Thu, 5 Mar 2026 13:45:45 -0800
X-Gm-Features: AaiRm512QXk1wltt0Dt_oHKudpKgCcvUpl_lamDScmc4Z14WjF8bP5lQX_6oAoY
Message-ID: <CAKSQd8UCruu_gj=E18z2zEFAGT=CN07dPoUEWuC5RE8aRO35zA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Add KVM-only CPUID.0xC0000001:EDX feature bits
To: Sean Christopherson <seanjc@google.com>
Cc: Ewan Hai <ewanhai-oc@zhaoxin.com>, pbonzini@redhat.com, tglx@kernel.org, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	cobechen@zhaoxin.com, tonywwang@zhaoxin.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 52952218986
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	FAKE_REPLY(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72955-lists,kvm=lfdr.de];
	FREEMAIL_REPLYTO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	HAS_REPLYTO(0.00)[ludloff@gmail.com];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ludloff@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

> There needs to be a _lot_ more documentation [...]

The docs for GMI, Padlock, and PAUSEOPT are available
from the Zhaoxin website. A bit cumbersome to download,
but copies can be found at kib's site here:

    https://kib.kiev.ua/x86docs/Zhaoxin/

The details for TM3 and PARALLAX are harder to find =E2=80=93 it
would be good if Zhaoxin can point to pdf files.

--
C.

