Return-Path: <kvm+bounces-27179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C79497CB39
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 16:57:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF0BB1C22567
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 14:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92A701A00E7;
	Thu, 19 Sep 2024 14:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="52XyzH6X"
X-Original-To: kvm@vger.kernel.org
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C6519F475
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 14:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726757805; cv=none; b=JVo5AyvkF+gTJZNlNi2chCxUuWM9R2s+H8rtRvf5AP8CUlFqnIPS0pvbGqU+/HXSpa+P+GFEyBazUFek/gmMNiGdfey+lNnmcXzpBxNh0cPSSNt2EZ1AwdnvlQjyMsqKjwBEI/9rYjM1QBTox5XhNDDy/l3oRxp0elI/f+600Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726757805; c=relaxed/simple;
	bh=yFNpCSzRJjaDEBAYyjGhtEEDQg0/gBqha3U5WdgkESA=;
	h=From:Content-Type:Mime-Version:Subject:Date:References:To:
	 In-Reply-To:Message-Id; b=A8mEwhC6MaNzalkdDl0E44/QZiJ+Vb5/cDDHMJAv8Y9cbrkMSZfbdr+h96jbbE/A3OX1pgpQCzGcaaNgYNiLF7knF6o/0dT4W6Fqsqh18DKGkX104kixvLHMCSwJJHtTMaYCs7wwKNk6m/viIx6+GWKWt4n/RQIw7gU05lapXio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=52XyzH6X; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from smtpclient.apple (unknown [83.68.141.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id B32432A59AC;
	Thu, 19 Sep 2024 16:56:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1726757796;
	bh=yFNpCSzRJjaDEBAYyjGhtEEDQg0/gBqha3U5WdgkESA=;
	h=From:Subject:Date:References:To:In-Reply-To:From;
	b=52XyzH6XnL7hVT+kXbqTnXkGcSPEOYVfsC2sLNoknxq1JFaL+K+doGx5tnX35Vcr9
	 ZWc7cgg4X91XnX+tfAUPu2p3mpI4pd5U5xGXOqYab4Emhc7s41ECfHTT+eVmzSgJaB
	 FlTnt1iarAyO7FL+ZQHmHsPMbLBP0N7bzqEeuKdv61uCthX6fPDr+5d2Wz3mE5wzcB
	 5G5o/oZX/2wZPRQW2gp8v8FiR/tp6kJUbbwRc4AuI5WQ87AyYRtdnZL00WhGHsM3i2
	 X3UGXH8gJ7SH/TYk4FyHVMIgu7S5hyw5bsrIgPiqNBbwHIoGzUh4flKfQ92lOHexLj
	 vo9DQhA+9T6bg==
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: Invitation to COCONUT-SVSM BoF at Linux Plumbers Conference
Date: Thu, 19 Sep 2024 16:56:26 +0200
References: <ZuK30-Ug790Vbhck@8bytes.org>
To: svsm-devel@coconut-svsm.dev,
 linux-coco@lists.linux.dev,
 kvm@vger.kernel.org
In-Reply-To: <ZuK30-Ug790Vbhck@8bytes.org>
Message-Id: <FD656EE6-DC11-46E5-B9BE-7A7647316581@8bytes.org>
X-Mailer: Apple Mail (2.3818.100.11.1.3)

The session is broadcasted via LPC Hackroom #1.

> Am 12.09.2024 um 11:43 schrieb J=C3=B6rg R=C3=B6del <joro@8bytes.org>:
>=20
> Hi,
>=20
> The COCONUT-SVSM community wants to invite the Linux, virtualisation, =
and
> confidential computing communities to our BoF at the Linux Plumbers
> Conference next week in Vienna.
>=20
> We hope to gather ideas, discuss problems and get input for the next
> year of development. It is scheduled for Thursday, September 19th at =
5pm
> in Room 1.14. Details are at this link:
>=20
> https://lpc.events/event/18/contributions/1980/
>=20
> Hope to see you all there!
>=20
> Regards,
>=20
> J=C3=B6rg
>=20


