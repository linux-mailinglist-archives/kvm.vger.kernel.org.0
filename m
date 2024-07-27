Return-Path: <kvm+bounces-22460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FB5493E0BD
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 21:53:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98F521C20D4C
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 19:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 680BE28E0F;
	Sat, 27 Jul 2024 19:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hfel.co.uk header.i=@hfel.co.uk header.b="yOAtsOhE"
X-Original-To: kvm@vger.kernel.org
Received: from imx.hfel.co.uk (imx.hfel.co.uk [185.209.160.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9900E1D69E
	for <kvm@vger.kernel.org>; Sat, 27 Jul 2024 19:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.209.160.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722110026; cv=none; b=kBXANTyH4p5iEDkLXlxV9x85/TcoPOiEUp/kEOzobERt7S/uqPZyJaqmTmeijGYL1xGF2ypKdgpRI7cdVpTsVNO0Cw/lugDsyXKxRjsaZTW71Fmd5pdglE08rQYnneLrl0EmwN4KcsCHneOHcmzoBQC7D/5/aU8hljEwWC4pMg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722110026; c=relaxed/simple;
	bh=QpGUXo1p/U7TCvHhofv2wP5mWlKUkFjERkTq/aN26cY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Zv0a9C7jFRjcG0FAwx6SsiAq2v5is/pJE0lE+DhOU///f5sywfCUv6y2BiFVWZz/9y3VPsVv1SlGLJ9pX1GReaOo4NlgrIWg3j6OZ6Hd0kViDG6uy5DGFJ8/YzsRs1GY2iBEsRPlETPna+XTtTqsJjZRUB1zg74kKSfdg45bQms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hfel.co.uk; spf=pass smtp.mailfrom=hfel.co.uk; dkim=pass (2048-bit key) header.d=hfel.co.uk header.i=@hfel.co.uk header.b=yOAtsOhE; arc=none smtp.client-ip=185.209.160.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hfel.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hfel.co.uk
Received: from [45.145.42.199] (unknown [45.145.42.199])
	by imx.hfel.co.uk (Postfix) with ESMTPA id E6F8099CF6
	for <kvm@vger.kernel.org>; Sat, 27 Jul 2024 17:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hfel.co.uk;
	s=default; t=1722101155;
	bh=QpGUXo1p/U7TCvHhofv2wP5mWlKUkFjERkTq/aN26cY=; h=From:To:Subject;
	b=yOAtsOhEAtMjssTuYWbe/AS6aO/NIioe/6hXjKfrVh/FoE5NF3St9pD1J6Oq+mj7W
	 6n6maYau0nK1oZn/rcleoOiHtHbtEk28/y70PTPzwg3eh3UH8rw9ujj1RTr+I3mZ2E
	 O/FIqCBso0OVYhEyAOy0DvXDLfnlt7dFFKr76nDCsMj9HBYcA1MmUUuSebAg8686kQ
	 qF9IokTOYV2qN0eOOCuo05+pdy+cqVOv5St8MCMLko5sP13+xoc9cI9BgF7V7RpxH3
	 3m1uax9seyUz3Sx5n3hKTBziViK8kG4KUXDg2B5HhDp3OySbgjW3YJweHCHzDGoQiP
	 vkhNpJdTQtZ+A==
Authentication-Results: imx.hfel.co.uk;
	spf=pass (sender IP is 45.145.42.199) smtp.mailfrom=newman@hfel.co.uk smtp.helo=[45.145.42.199]
Received-SPF: pass (imx.hfel.co.uk: connection is authenticated)
Reply-To: officeinfo@capitalsforce.com
From: Arthur Wilson<newman@hfel.co.uk>
To: kvm@vger.kernel.org
Subject: Collateral-Free Loan.
Date: 27 Jul 2024 19:25:53 +0200
Message-ID: <20240727192553.D8A4CC69C1C6D4EC@hfel.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Greetings!

We offer quick, collateral-free financing for economically viable=20
projects and/or businesses of all sizes, including startups and=20
existing businesses.
If you are seeking funding for a specific shovel-ready project,=20
you will be funded at 2% principal annual interest.
If you would like to collaborate with us as a middleman/
facilitator, you will earn 2% of the total project cost or loan=20
as your commission for every successful loan or project funding=20
deal facilitated by you.
Please get in touch if this is of interest to you.

Regards,
Arthur Wilson.

