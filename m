Return-Path: <kvm+bounces-57491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7433BB55F0E
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 09:01:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EE6D1C84EC6
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 07:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 804782E8B6A;
	Sat, 13 Sep 2025 07:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m4JfT/Ye"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972CF2DC787;
	Sat, 13 Sep 2025 07:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757746849; cv=none; b=miRSeE0tvCGTUKdbb4IUOKFrxsv87Zakg529Yj3g6IqWOLSUV8nwXpicI4fi9IR53sl3vsH0j5mcihr/CWn+JXE6y+ue2nSovJcx8QvpVWt1q5RCx9xjuuwiD3RWfbrpWUTKK8E999hO5pcICCDd9uBnnDhXbjrfbF1xRvFF4+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757746849; c=relaxed/simple;
	bh=6YzFyOOv4WRQ72+9SDNxAcsBvNgeOLTg4Z+Rr2GC6N4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bkMVXISH/rJo3uNpCmE/sRJD0zBI1sYNiSqeMc2rGYlBdH5dMeTd8nTNngAB+qr2OVt69PQTVfGHGHF5/IBXTwH7ehsc85SVTCIvXkNZ7Y41ej2midaw98SQ8RYErRxYJivy/F78KciE4kdQqP4wpPSND7TweXYQJHR47M48cu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m4JfT/Ye; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1B3C4CEEB;
	Sat, 13 Sep 2025 07:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757746849;
	bh=6YzFyOOv4WRQ72+9SDNxAcsBvNgeOLTg4Z+Rr2GC6N4=;
	h=Date:From:To:Cc:Subject:From;
	b=m4JfT/Yery3tyOZZsqO7+bgJA+5alwoaZi6nv77ZdYA5/I0CLhEBI5smGyEwcOJ/E
	 Yr/665Qr4JHiwyMAGU/hrDgPdk8jl8xl3B+4pXo5F2FUSACQo3wcf9K11l8kRC+4gB
	 3WzUsHUG81Fu2AknhVY1UjWXkt1ELLi6oP676qHUi422yLo431IqfEH64yjJfsvPE3
	 b2XR/UOlm6J3q+HTWiYlTW1fx51n3yPhv9lQ7G/GBQrFRMN5uP+DmgI7Fd2v4scKv9
	 Jw/p8UAa7ioelnZuXjAhjFkNzkWC2ahSWdL4+MnvriTBU2nk0fG7ZUg5ANymEn9juw
	 gtvfHC5HIWn/w==
Date: Sat, 13 Sep 2025 16:00:47 +0900
From: Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>
To: Linux PCI <linux-pci@vger.kernel.org>,
	Linux IOMMU <iommu@lists.linux.dev>,
	Linux KVM <kvm@vger.kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?utf-8?B?SsO2cmc=?= Roedel <joro@8bytes.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: The VFIO/IOMMU/PCI MC at LPC 2025 - Call for Papers reminder
Message-ID: <20250913070047.GA3309104@rocinante>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello everyone!

The registration for the Linux Plumbers Conference 2025 will be open soon.

That said, there are still two weeks, or so, before the Call for Papers
submission deadline (which is the 30th of September; 2025-09-30) for the
MC.  The deadline is more of an advisory one, rather than a hard deadline,
as we will accept some late submissions, too.  However, the sooner the
better, as it makes it easier for us to review submissions, and plan the
future scheduled ahead of time.

As such, while there is still time, and if you had planned to speak at the
MC this year, please do not hesitate to send us your proposal.  Even a draft
would be fine, as we can refine it later.

As always, please get in touch with me directly, or with any other
questions organisers, if you need any assistance or have any questions.

Looking forward to seeing you all there, either in Tokyo in-person or
virtually!

For mode information and updates, please keep an eye on the conference web
page at https://lpc.events.

Previous posts about the MC:

- https://lore.kernel.org/linux-pci/20250812174506.GA3633156@rocinante

Thank you!

	Alex, Bjorn, Jörg, Lorenzo and Krzysztof

