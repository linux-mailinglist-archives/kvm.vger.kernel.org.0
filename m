Return-Path: <kvm+bounces-41490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DCA4A68E8E
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 15:10:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 153F3188AC56
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 13:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59958158538;
	Wed, 19 Mar 2025 13:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b="Lex6L7WK";
	dkim=pass (2048-bit key) header.d=vates.tech header.i=anthony.perard@vates.tech header.b="IUSOiq60"
X-Original-To: kvm@vger.kernel.org
Received: from mail136-29.atl41.mandrillapp.com (mail136-29.atl41.mandrillapp.com [198.2.136.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6E21531E3
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 13:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.2.136.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742392585; cv=none; b=iiwScmn4EaHbR3xgKRDDrexiSkdqbOzM2qTwJqbZtA4O1VErFwXy+RBnx1DZXuhall+2Exb7tDOuqdQvgBaZLGEyQJob7ux95WS9BS6iKtAdnJ1nRyiU4be1DBKoOufUfB5NbUKp8N2VwONLnMi+6DSnBfiNLT2FWQKqHJnX3cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742392585; c=relaxed/simple;
	bh=ashTesIs+hv8VELJo825vq8O/d/D9sbuI01KvonTzgo=;
	h=From:Subject:To:Cc:Message-Id:References:In-Reply-To:Date:
	 MIME-Version:Content-Type; b=U0TjPnriuFHMS+CeEhN9PzSFCfiVQ+kPh83YDPo9b+A7Ew99wEhf4yZHJxLTQM6KXoPF96NwN4GnsxcL1Iw4vYZ8SZcqOsP7lgTWRO6He3LKz7YB6eW++bVOS/u2dGxTFy21gXE+iQbjDhhw1nEJqGtcr4Nc8qOC1zm+dLIQUtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vates.tech; spf=pass smtp.mailfrom=bounce.vates.tech; dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b=Lex6L7WK; dkim=pass (2048-bit key) header.d=vates.tech header.i=anthony.perard@vates.tech header.b=IUSOiq60; arc=none smtp.client-ip=198.2.136.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vates.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.vates.tech
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com;
	s=mte1; t=1742392582; x=1742662582;
	bh=S2HwWyjFnN9+yZcO348glRXKWzLF/ORVGltfzHFXYyc=;
	h=From:Subject:To:Cc:Message-Id:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=Lex6L7WK8EEbR6akLulITdTMm0D1b7Gm9EMi7jFmB2iADeLwcY9vhOi7cqs9BDQbI
	 vC5aHzf9Dy2tCvdRscoTXLGJBM92IiiB88Pt4pfdA16sqVrZrMjHu6dQoTbeH5TTqU
	 ze8XBb8jhC2jMulhuxYk5pfrY+73+fP7FViVt7zJmQM8nKYv6NXXlwLqBJ+So4WeRg
	 uPZIWXRs6KDCIa/xv/eg77rq59E/OlCXkLAbEvcaTTg3JDLDWAhYqT//fZeIi9RQsp
	 e6HgqHE7e2SvFFWh5uEuR+QRpmc9DSCWg2OUQBdku2bNPVwdV82ybYqTyPVt2jvtx/
	 TrC0zE8WNG0JA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech; s=mte1;
	t=1742392582; x=1742653082; i=anthony.perard@vates.tech;
	bh=S2HwWyjFnN9+yZcO348glRXKWzLF/ORVGltfzHFXYyc=;
	h=From:Subject:To:Cc:Message-Id:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=IUSOiq607XgXlY6pcpJNCwdlhwubCr1aBqiA1yLKgy4lB8sUXSe8y6U4LKPS9I2UX
	 7+P+s4pK5ewfPfnTu5L77uEqhim3y52j0FeocIsldb+H9hCknn6TNzj/D1u7coQbuC
	 DeMxACGuyUhM1ThfRDRrEGXcuoQGEvrzoHcvmrDlf7UwkBZhbMUmESqaYTGDJPDWg/
	 qTt9RfRlbZPrtw89CFZVV8UdrItMilc/QZALyJ8S8flmJhkASs9WpHMGGFtDaT19TI
	 yN01FvUae4qxg8pE6NQboxeylh1lI4vrYiL7n4I4wl6vg4A84ZDPCzEfjHRTVvmoWc
	 RisXW6TR680sw==
Received: from pmta11.mandrill.prod.atl01.rsglab.com (localhost [127.0.0.1])
	by mail136-29.atl41.mandrillapp.com (Mailchimp) with ESMTP id 4ZHqxf3dyPz6CPyHG
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 13:56:22 +0000 (GMT)
From: "Anthony PERARD" <anthony.perard@vates.tech>
Subject: =?utf-8?Q?Re:=20[PATCH=20v6=2013/18]=20system/xen:=20remove=20inline=20stubs?=
Received: from [37.26.189.201] by mandrillapp.com id d64b7c80b5cd4359a4eaef366b5cf870; Wed, 19 Mar 2025 13:56:22 +0000
X-Bm-Disclaimer: Yes
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1742392581417
To: "Pierrick Bouvier" <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org, "Paul Durrant" <paul@xen.org>, xen-devel@lists.xenproject.org, "David Hildenbrand" <david@redhat.com>, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>, qemu-riscv@nongnu.org, "Liu Zhiwei" <zhiwei_liu@linux.alibaba.com>, "Paolo Bonzini" <pbonzini@redhat.com>, "Harsh Prateek Bora" <harshpb@linux.ibm.com>, alex.bennee@linaro.org, manos.pitsidianakis@linaro.org, "Daniel Henrique Barboza" <danielhb413@gmail.com>, "Richard Henderson" <richard.henderson@linaro.org>, "Alistair Francis" <alistair.francis@wdc.com>, qemu-ppc@nongnu.org, "=?utf-8?Q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, "Weiwei Li" <liwei1518@gmail.com>, kvm@vger.kernel.org, "Palmer Dabbelt" <palmer@dabbelt.com>, "Peter Xu" <peterx@redhat.com>, "Yoshinori Sato" <ysato@users.sourceforge.jp>, "Stefano Stabellini" <sstabellini@kernel.org>, "Nicholas Piggin" <npiggin@gmail.com>
Message-Id: <Z9rNBFsWR39czUGQ@l14>
References: <20250317183417.285700-1-pierrick.bouvier@linaro.org> <20250317183417.285700-14-pierrick.bouvier@linaro.org>
In-Reply-To: <20250317183417.285700-14-pierrick.bouvier@linaro.org>
X-Native-Encoded: 1
X-Report-Abuse: =?UTF-8?Q?Please=20forward=20a=20copy=20of=20this=20message,=20including=20all=20headers,=20to=20abuse@mandrill.com.=20You=20can=20also=20report=20abuse=20here:=20https://mandrillapp.com/contact/abuse=3Fid=3D30504962.d64b7c80b5cd4359a4eaef366b5cf870?=
X-Mandrill-User: md_30504962
Feedback-ID: 30504962:30504962.20250319:md
Date: Wed, 19 Mar 2025 13:56:22 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 17, 2025 at 11:34:12AM -0700, Pierrick Bouvier wrote:
> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

Reviewed-by: Anthony PERARD <anthony.perard@vates.tech>

Thanks,

-- 

Anthony Perard | Vates XCP-ng Developer

XCP-ng & Xen Orchestra - Vates solutions

web: https://vates.tech


