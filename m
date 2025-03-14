Return-Path: <kvm+bounces-41108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 192D2A61979
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 19:34:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D5F03A46CA
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1282A1F3BAE;
	Fri, 14 Mar 2025 18:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b="VFPmIy0B";
	dkim=pass (2048-bit key) header.d=vates.tech header.i=anthony.perard@vates.tech header.b="Y+WzDB6P"
X-Original-To: kvm@vger.kernel.org
Received: from mail177-1.suw61.mandrillapp.com (mail177-1.suw61.mandrillapp.com [198.2.177.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9227C2E3389
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 18:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.2.177.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741977246; cv=none; b=Ei9G0kDL9eREduWGj1JuHgvffxC58OA9TR7qpJDv/4QXOPJRKdGseSCHNmIV3/Vzo1rfmV97E4u4ry/R/O51NmxfeT8kp7PSJdg7n/geQBIksSudbDL2fn/Odr0OGT9FCvx5Z7jvlr7je3OMFoaLcmliQnvPvFzui1AXkDC+oq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741977246; c=relaxed/simple;
	bh=d6JQfKuH+LyvpNpVEYGMFG9ev0mNIXWnQvIxBE8GUbM=;
	h=From:Subject:To:Cc:Message-Id:References:In-Reply-To:Date:
	 MIME-Version:Content-Type; b=fHKaNgsKgBj7KlLtuQNsc/QIwxlNDdhqXQfmqh/RKb2es8I6+MLbBs339KR0YFO9OHfLmIhTwB1gInMZjKs0KyJO8zrxLbjZauJYCI3o2BjALgonOMi4hbXQ6V99eOC+ubFnOgFLNfOtKU+3fsiX5z5yaaOuRJ/wW0xrMTiHyRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vates.tech; spf=pass smtp.mailfrom=bounce.vates.tech; dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b=VFPmIy0B; dkim=pass (2048-bit key) header.d=vates.tech header.i=anthony.perard@vates.tech header.b=Y+WzDB6P; arc=none smtp.client-ip=198.2.177.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vates.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.vates.tech
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com;
	s=mte1; t=1741977243; x=1742247243;
	bh=XJ3a24qpetFIlkUTjB8MUIt/veN1MpcWIkxiqMq1Nms=;
	h=From:Subject:To:Cc:Message-Id:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=VFPmIy0B+1Zh/NxNSDjMOqoY3tX/C07aLHxG/iNg5P5XQyOTemgC86CpjWEekmOcs
	 5JSqcPV4o4ybWFmaqTGbVCu40kcdugt32ie1Os9b8iCrRDfh+1omQY2mbsHahmxVaV
	 Rg5l0DvmD7wGfwrD8RSSHTu/izKvr/lIGb7WTu19cv7xL2IexihTA9UuvQT4jZFooT
	 TkTAb9jrK2OFdSaybWkH6elDSnM/kjYz5WYw8rNKLK7kZTwEVQjUspcLPQOqi6zPsz
	 aZJ0vAQJppKVGNPs6Tfp38PUKuhBH47WghriA+knuYC8Cumf4I14H2qqgVUrPWnFqQ
	 H/3dIiB6CGMeQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech; s=mte1;
	t=1741977243; x=1742237743; i=anthony.perard@vates.tech;
	bh=XJ3a24qpetFIlkUTjB8MUIt/veN1MpcWIkxiqMq1Nms=;
	h=From:Subject:To:Cc:Message-Id:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=Y+WzDB6PbY50wkAz19NptjKyO7QzSp2Q7XlSmzT//jNwcTDHNOAmUr/Lloi38DCku
	 Jeee+1HQ2DmSc8N6JKhLBI7s0CvfPZaMTnLCf7WR4Ma7MIEyS7Gi1/HppNG4FRIZH3
	 etDok8acjHs/ivTDFlOZyNQ9MUhgtOInRtesgYcnU8i2SyPzo6ldCSTBqioUdujMSg
	 G61rEqoQTJoFxSdLKHY0V4lbBGww9zsPVyJGMiivimlfFvTgDwBplFTM2FgQi63l1W
	 zTakUh2OwxQDiBZOpu5s7I6/9jgfbu6B4qYSv9yYh3KgMA13b6ezEU5uZ7bIvCWOd8
	 dgjNrGNUl/+aA==
Received: from pmta14.mandrill.prod.suw01.rsglab.com (localhost [127.0.0.1])
	by mail177-1.suw61.mandrillapp.com (Mailchimp) with ESMTP id 4ZDtLM4SKFzBsV1Vt
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 18:34:03 +0000 (GMT)
From: "Anthony PERARD" <anthony.perard@vates.tech>
Subject: =?utf-8?Q?Re:=20[PATCH=20v5=2000/17]=20make=20system=20memory=20API=20available=20for=20common=20code?=
Received: from [37.26.189.201] by mandrillapp.com id 61b5423fce6a4440b6f4867f8b792f0f; Fri, 14 Mar 2025 18:34:03 +0000
X-Bm-Disclaimer: Yes
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1741977242834
To: "Pierrick Bouvier" <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-ppc@nongnu.org, "Yoshinori Sato" <ysato@users.sourceforge.jp>, "Paul Durrant" <paul@xen.org>, "Peter Xu" <peterx@redhat.com>, alex.bennee@linaro.org, "Harsh Prateek Bora" <harshpb@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>, "Alistair Francis" <alistair.francis@wdc.com>, "=?utf-8?Q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, "Richard Henderson" <richard.henderson@linaro.org>, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>, "Liu Zhiwei" <zhiwei_liu@linux.alibaba.com>, "Nicholas Piggin" <npiggin@gmail.com>, "Daniel Henrique Barboza" <danielhb413@gmail.com>, qemu-riscv@nongnu.org, manos.pitsidianakis@linaro.org, "Palmer Dabbelt" <palmer@dabbelt.com>, kvm@vger.kernel.org, xen-devel@lists.xenproject.org, "Stefano Stabellini" <sstabellini@kernel.org>, "Paolo Bonzini" <pbonzini@redhat.com>, "Weiwei Li" <liwei1518@gmail.com>
Message-Id: <Z9R2mjfaNcsSuQWq@l14>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org> <5951f731-b936-42eb-b3ff-bc66ef9c9414@linaro.org>
In-Reply-To: <5951f731-b936-42eb-b3ff-bc66ef9c9414@linaro.org>
X-Native-Encoded: 1
X-Report-Abuse: =?UTF-8?Q?Please=20forward=20a=20copy=20of=20this=20message,=20including=20all=20headers,=20to=20abuse@mandrill.com.=20You=20can=20also=20report=20abuse=20here:=20https://mandrillapp.com/contact/abuse=3Fid=3D30504962.61b5423fce6a4440b6f4867f8b792f0f?=
X-Mandrill-User: md_30504962
Feedback-ID: 30504962:30504962.20250314:md
Date: Fri, 14 Mar 2025 18:34:03 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On Fri, Mar 14, 2025 at 10:33:08AM -0700, Pierrick Bouvier wrote:
> Hi,
> 
> one patch is missing review:
> [PATCH v5 12/17] hw/xen: add stubs for various functions.

My "Acked-by" wasn't enough? Feel free try change it to "Reviewed-by"
instead.

Cheers,

-- 

Anthony Perard | Vates XCP-ng Developer

XCP-ng & Xen Orchestra - Vates solutions

web: https://vates.tech

