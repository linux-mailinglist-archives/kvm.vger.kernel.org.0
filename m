Return-Path: <kvm+bounces-69524-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mHW1N24ke2kaBwIAu9opvQ
	(envelope-from <kvm+bounces-69524-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 10:12:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 39A17ADFEF
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 10:12:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8950E3001183
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 09:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4D33329E5E;
	Thu, 29 Jan 2026 09:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trivon.pl header.i=@trivon.pl header.b="lRb3Fjj2"
X-Original-To: kvm@vger.kernel.org
Received: from mail.trivon.pl (mail.trivon.pl [162.19.75.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E52237713
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 09:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.19.75.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769677447; cv=none; b=aN8SKfo1v9ZZC2kmgA2hkDnDgjVc2jnWTiU6AX4zk4u+GFEYSxdTsTT3Koc2sr4h6otPe3k764IOXv5lmHXajtLnh7WRkJRnIEvvZkleH6Lmi3WDKv0ZbJjaA+izcX309PrrAaoOTjWroU1jOICbUkBvKygIo40MB3LON+ez2xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769677447; c=relaxed/simple;
	bh=q6E6cDv1uM5zkCneIiADerBHy5PHXWo3+b/ZdQb9LnY=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=K8GQMI2SBkln4iNlKyTLcKmG4uVgGQJZ/oCE3pKjwF8MVpGADORxrT/8VmGnly5okZOjGnu0q1tMYeZRaYdkTpT8U7oRjkB29RgV+HoRK+jOdFiBaOK3DQrUOglO7YCR722nfFpQstLT9hHF5FKP7OonEhhbspEaIy7jeG91zfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trivon.pl; spf=pass smtp.mailfrom=trivon.pl; dkim=pass (2048-bit key) header.d=trivon.pl header.i=@trivon.pl header.b=lRb3Fjj2; arc=none smtp.client-ip=162.19.75.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trivon.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trivon.pl
Received: by mail.trivon.pl (Postfix, from userid 1002)
	id 17CDE4BCEC; Thu, 29 Jan 2026 09:56:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=trivon.pl; s=mail;
	t=1769676988; bh=q6E6cDv1uM5zkCneIiADerBHy5PHXWo3+b/ZdQb9LnY=;
	h=Date:From:To:Subject:From;
	b=lRb3Fjj27AD00AozjklE8n9+xsSFS1mqNj3aS1jx4ZpXvV06E9wvjjwI4eKvsICe0
	 n4OxKR0JcRKODIW5kyUTaEqqvCOs/f5m+5bqpKVdVHfzMrfxDrwvQJU3Y9rfWEG/Wo
	 fpExD2GcMcgaepyX2oJeNNFmQtUwYEa1YER9Be7Kzvwn+WikIdndf0VfH6pBzfjnnb
	 9YI5NoTLGQ7yZ+/ZeyhKk5mk7nuOKvhuf+kCu+qF6n8m/Fz8u6LdZ5vR6/yMiNOJR+
	 xn5ASp94WEa+DH7nBIkBU+518m/kafeD2IPybYjsG4/tbJQuJVp6LYxmlMKQZSKpi4
	 +XUNez10qIr0w==
Received: by mail.trivon.pl for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 08:56:10 GMT
Message-ID: <20260129084500-0.1.df.34d8n.0.kpmgxg4e9y@trivon.pl>
Date: Thu, 29 Jan 2026 08:56:10 GMT
From: "Damian Sumera" <damian.sumera@trivon.pl>
To: <kvm@vger.kernel.org>
Subject: Restrukturyzacja
X-Mailer: mail.trivon.pl
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.15 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[trivon.pl,reject];
	R_DKIM_ALLOW(-0.20)[trivon.pl:s=mail];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	DKIM_TRACE(0.00)[trivon.pl:+];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	TAGGED_FROM(0.00)[bounces-69524-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[damian.sumera@trivon.pl,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,trivon.pl:mid,trivon.pl:dkim]
X-Rspamd-Queue-Id: 39A17ADFEF
X-Rspamd-Action: no action

Szanowni Pa=C5=84stwo,

jestem radc=C4=85 prawnym i prowadz=C4=99 kancelari=C4=99, kt=C3=B3ra spe=
cjalizuje si=C4=99 we wspieraniu przedsi=C4=99biorc=C3=B3w.

Jako lokalny ekspert oferuj=C4=99 efektywne dzia=C5=82ania umo=C5=BCliwia=
j=C4=85ce wstrzymanie post=C4=99powa=C5=84 egzekucyjnych, uporz=C4=85dkow=
anie zad=C5=82u=C5=BCenia, ochron=C4=99 maj=C4=85tku przedsi=C4=99biorstw=
a oraz popraw=C4=99 jego sytuacji finansowej.

Czy mog=C4=99 zaprezentowa=C4=87 mo=C5=BCliwo=C5=9Bci wsp=C3=B3=C5=82prac=
y?


Pozdrawiam
Damian Sumera

