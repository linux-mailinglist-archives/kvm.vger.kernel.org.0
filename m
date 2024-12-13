Return-Path: <kvm+bounces-33706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 53DEE9F0657
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 09:28:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15D812820D7
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 08:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCFC51A8F81;
	Fri, 13 Dec 2024 08:28:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from arara2.ipen.br (arara2.ipen.br [200.136.52.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A09186607
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 08:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=200.136.52.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734078486; cv=none; b=DwrWlvM5mfY05w7szUmje6VBGDfQxwPIlUJqQnNsUI/QIgGEMM4uaRQ8Y8E718StkqzHqGyUeOhv4sncUZeh2TMez6ygZU5G7HtkNxC/XtSn3KbEN9e87c1EVHI+37OhpGFyXQBnjegTXbHo5Qigtmtk6c6wZhZME+rAx8zsQpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734078486; c=relaxed/simple;
	bh=Cgr97JBiSX1QIcd2ZZZsKVChGTY1ZlWJ/4AhaVFA7Wc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JqNkBd92AkPiKRBcJdN6qU6wSAMkMTWBM0as5MQxHF7AIX7/lN5TO7RfjVPCk1zlPeyxCUPt+2LthN0sR4GAso6A+uWDXSK803MNzDJeaY3tG6P7WH2QCtcG3wDM67VXGFA3/jPb8p0MdxGGygAPJcll87M+WpeRjGWB5bVXMDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ipen.br; spf=pass smtp.mailfrom=ipen.br; arc=none smtp.client-ip=200.136.52.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ipen.br
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ipen.br
X-ASG-Debug-ID: 1734078473-055fc729ec149a830007-HEqcsx
Received: from arara.ipen.br (webmail.ip.ipen.br [10.0.10.11]) by arara2.ipen.br with ESMTP id gFrepALdy9pZEiBA for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 05:28:01 -0300 (BRT)
X-Barracuda-Envelope-From: TCWM179282@ipen.br
X-Barracuda-RBL-Trusted-Forwarder: 10.0.10.11
Received: from ipen.br (unknown [102.129.145.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by arara.ipen.br (Postfix) with ESMTPSA id 2BD6EFBE588
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 01:25:24 -0300 (-03)
Reply-To: t.mazowieckie@mazowieckie.org
X-Barracuda-Effective-Source-IP: UNKNOWN[102.129.145.191]
X-Barracuda-Apparent-Source-IP: 102.129.145.191
X-Barracuda-RBL-IP: 102.129.145.191
From: <TCWM179282@ipen.br>
To: kvm@vger.kernel.org
Subject:  I urge you to understand my viewpoint accurately.
Date: 13 Dec 2024 12:25:24 +0800
X-ASG-Orig-Subj: I urge you to understand my viewpoint accurately.
Message-ID: <20241213122524.97006123C7CB9F2A@ipen.br>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Barracuda-Connect: webmail.ip.ipen.br[10.0.10.11]
X-Barracuda-Start-Time: 1734078481
X-Barracuda-URL: https://10.40.40.18:443/cgi-mod/mark.cgi
X-Barracuda-Scan-Msg-Size: 512
X-Barracuda-BRTS-Status: 1
X-Barracuda-BRTS-Evidence: 34fbb5788938ad5710ad28835fd12206-499-txt
X-Virus-Scanned: by bsmtpd at ipen.br
X-Barracuda-Spam-Score: 1.09
X-Barracuda-Spam-Status: No, SCORE=1.09 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 tests=DATE_IN_PAST_03_06, DATE_IN_PAST_03_06_2, NO_REAL_NAME
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.45577
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 NO_REAL_NAME           From: does not include a real name
	0.01 DATE_IN_PAST_03_06     Date: is 3 to 6 hours before Received: date
	1.08 DATE_IN_PAST_03_06_2   DATE_IN_PAST_03_06_2

I am Tomasz Chmielewski, a Portfolio Manager and Chartered=20
Financial Analyst affiliated with Iwoca Poland Sp. Z OO in=20
Poland. I have the privilege of working with distinguished=20
investors who are eager to support your company's current=20
initiatives, thereby broadening their investment portfolios. If=20
this proposal aligns with your interests, I invite you to=20
respond, and I will gladly share more information to assist you.

=20
Yours sincerely,=20
Tomasz Chmielewski Warsaw, Mazowieckie,
=20
Poland.

