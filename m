Return-Path: <kvm+bounces-67701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 61123D111C2
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 09:12:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0451E30735EA
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 08:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEFF533D6CE;
	Mon, 12 Jan 2026 08:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b="r9W8gKqH";
	dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b="rPDEkkl6"
X-Original-To: kvm@vger.kernel.org
Received: from mail8.us4.mandrillapp.com (mail8.us4.mandrillapp.com [205.201.136.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB9D33C18C
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 08:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.201.136.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768205544; cv=none; b=fSF4hbuhRIsLwry3OINzNj9tT7guT6/0XdK8Ek0C977iIfFeTwDGgyYcNh//+DrC0XMJsXANeVlhqlYcKRpQVhj8dNkYrjT10A7bwzxvEbfZN8fBtL56iI4JRj4a//Vx0tDb+cfoAgp7ir/FKJesnEPg4D8BBebIaj9irvjHOE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768205544; c=relaxed/simple;
	bh=keYa/bbbVNIONFLF2/By6XeO0uZvqCHaw1BMj3KZd3I=;
	h=From:Subject:To:Cc:Message-Id:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Qd6noOTN0vdembQwznwr1QjSiYRMGpa9zy0+1iah5G7UbE51j/OWwZdggMVvtC83u5RoWAWAjF+usnCl/v4fK94hqbuiN5OUpoCZoNMNo1y8EIuTrrVSlGoyfD8jVCoL3kAGMsjL9LIV7K+HC2tWFbPnhUc0MGyiEsa8oYMTVmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vates.tech; spf=pass smtp.mailfrom=bounce.vates.tech; dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b=r9W8gKqH; dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b=rPDEkkl6; arc=none smtp.client-ip=205.201.136.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vates.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.vates.tech
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com;
	s=mte1; t=1768205542; x=1768475542;
	bh=keYa/bbbVNIONFLF2/By6XeO0uZvqCHaw1BMj3KZd3I=;
	h=From:Subject:To:Cc:Message-Id:In-Reply-To:References:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=r9W8gKqHnrAjQP/asRZz+U7gzkju2tWRA7z8P/toMi3S4ioHOijfbsiVfF5dTzBp2
	 fdDwELeSQ/AMkJc62SrFZfS/ua77X14aRSnb4xMS/b4khbL6RrdnkiyyZOkScMt2VK
	 ClS10ARqARdEsC30Nn9HwaCsfknFYen5iby2OZrRI+IykNmzS9QDBg0AG+GpMK1Ws/
	 NdmWQmFgLaGkT3CVmTyYqZTy8u43m7Ny7Ko0sU6q6lDdLI8mxFcTW1l8UTRIIlT9pO
	 myORWvqNekTCldRow4JSSordbxvI1xGs6SkqMQL2i+9Zd1ST4x6HR19mnsdNhVd8H0
	 cwGuibZYIYurw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech; s=mte1;
	t=1768205542; x=1768466042; i=thomas.courrege@vates.tech;
	bh=keYa/bbbVNIONFLF2/By6XeO0uZvqCHaw1BMj3KZd3I=;
	h=From:Subject:To:Cc:Message-Id:In-Reply-To:References:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=rPDEkkl6sGec8BTvEzekSsFMhdF1cgu5gebvWEowBfqBXGQ1CU0UaKWlVBb6b0z5i
	 250U564fnlUSvaLIHWPqF7A5o+z1UQnVIuJKuU6/ZzTYIctOvRN/LpB9JkPnMScX4K
	 q3OulRJCQKsDxeb/sw5CXTYkc0JyiASdKp41r0VSDSNHEEKqzdwTKxIe1Vmu1YF3nJ
	 C8H1RR4HgNlmLKdBRyJ58YvTVMAchhVpqpUBTpoVijpi8RPIkE5sFqFdv61ALSb9rz
	 yO6153vOTlqRC7DR5tvXc78pw67KDFNho9EwK49NpwgSziCSb44IX34X73MPU5PcaD
	 D3bEqrAfCj2zg==
Received: from pmta15.mandrill.prod.suw01.rsglab.com (localhost [127.0.0.1])
	by mail8.us4.mandrillapp.com (Mailchimp) with ESMTP id 4dqQ8k3GfKz2K1rjw
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 08:12:22 +0000 (GMT)
From: "Thomas Courrege" <thomas.courrege@vates.tech>
Subject: =?utf-8?Q?Re:=20[PATCH=20v3]=20KVM:=20SEV:=20Add=20KVM=5FSEV=5FSNP=5FHV=5FREPORT=5FREQ=20command?=
Received: from [37.26.189.201] by mandrillapp.com id 994276116e0c41d4a6e12c1fe3ad1ff5; Mon, 12 Jan 2026 08:12:22 +0000
X-Mailer: git-send-email 2.52.0
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1768205539240
To: thomas.courrege@vates.tech
Cc: ashish.kalra@amd.com, corbet@lwn.net, herbert@gondor.apana.org.au, john.allen@amd.com, kvm@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, nikunj@amd.com, pbonzini@redhat.com, seanjc@google.com, thomas.lendacky@amd.com, x86@kernel.org
Message-Id: <20260112081204.20368-1-thomas.courrege@vates.tech>
In-Reply-To: <20251215141417.2821412-1-thomas.courrege@vates.tech>
References: <20251215141417.2821412-1-thomas.courrege@vates.tech>
X-Native-Encoded: 1
X-Report-Abuse: =?UTF-8?Q?Please=20forward=20a=20copy=20of=20this=20message,=20including=20all=20headers,=20to=20abuse@mandrill.com.=20You=20can=20also=20report=20abuse=20here:=20https://mandrillapp.com/contact/abuse=3Fid=3D30504962.994276116e0c41d4a6e12c1fe3ad1ff5?=
X-Mandrill-User: md_30504962
Feedback-ID: 30504962:30504962.20260112:md
Date: Mon, 12 Jan 2026 08:12:22 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Gentle ping.

Thanks,
Thomas

