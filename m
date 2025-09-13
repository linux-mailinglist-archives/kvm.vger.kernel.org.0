Return-Path: <kvm+bounces-57492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64EA6B55F11
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 09:06:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F224E1B214AF
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 07:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C5372E8B70;
	Sat, 13 Sep 2025 07:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUA2Ofsh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605861DFD8F;
	Sat, 13 Sep 2025 07:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757747155; cv=none; b=W4KcQBCiS3oP8wR912mL7dwwc079G6mx5kc5fK8tP60D/3hFw0l3i6o1PLog5AmpUT6Edqm5F/xqA8QfXGbxuw+jph1o2jOFqTFi5ziXxC5z1B4GTEIw9UhrEMjX9TYn+ai+ZHjQyFP+wPPaPkpIfmiyhlKRSSOS6HElth7edzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757747155; c=relaxed/simple;
	bh=MsUJdJ2L6OQavPG8qjVYYVyO1M5fSnB00DvzO2eEaiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qNH516gYCQb1Ft9Lscii4zBq6e5YMurCQ/AvbyrW9OPdn1j5hcetCbOG1bkiIIzzcm0mk5vIIckETvb1xucvj+z+gHmOVYK5iuU+WPcPxmSfOkBacIFdlAHlxQmDU7KTY8pBiHKS3BP5J8oWHxQCvbAR2RUyxaR1OWZaDtwT9vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUA2Ofsh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FD9C4CEEB;
	Sat, 13 Sep 2025 07:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757747153;
	bh=MsUJdJ2L6OQavPG8qjVYYVyO1M5fSnB00DvzO2eEaiw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HUA2OfshwILs9aJY7GuSv6oQInzlTij96zoQ/XcqFy6qSdzRj/t9KqCmg10vWPo8w
	 28XSRfrDwT3NKf1haljgHUTCZhkqTL5LuXX4ktrpQDbuAupLSTV38GV4UuTp0ZmwZh
	 o1iJ0O9vUk53yWWXDYemI+QPKwmCsQrV5LhXGKjp1AXmFPsrEl5paINkm6F3Dd+GAa
	 AeT0hqx6P8XeWJ7sD8aVk2etFvIiQz/71E1lPGZR1Ev2d/pYa7LuVgvv/FpwK2dM3c
	 iFNrSDiKafs7sckW5Z4SbkA3CDpT5F5UVUEWhvr6iP83U+Foy490Bxulvb6q6X3Tox
	 2zHubxNrQ/Z9w==
Date: Sat, 13 Sep 2025 16:05:52 +0900
From: Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Linux PCI <linux-pci@vger.kernel.org>,
	Linux IOMMU <iommu@lists.linux.dev>,
	Linux KVM <kvm@vger.kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?utf-8?B?SsO2cmc=?= Roedel <joro@8bytes.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: The VFIO/IOMMU/PCI MC at LPC 2025 - Call for Papers reminder
Message-ID: <20250913070552.GA3436885@rocinante>
References: <20250913070047.GA3309104@rocinante>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250913070047.GA3309104@rocinante>

Hello,

Adding Dan, Jason and Logan for visibility. :)

> The registration for the Linux Plumbers Conference 2025 will be open soon.
> 
> That said, there are still two weeks, or so, before the Call for Papers
> submission deadline (which is the 30th of September; 2025-09-30) for the
> MC.  The deadline is more of an advisory one, rather than a hard deadline,
> as we will accept some late submissions, too.  However, the sooner the
> better, as it makes it easier for us to review submissions, and plan the
> future scheduled ahead of time.
> 
> As such, while there is still time, and if you had planned to speak at the
> MC this year, please do not hesitate to send us your proposal.  Even a draft
> would be fine, as we can refine it later.
> 
> As always, please get in touch with me directly, or with any other
> questions organisers, if you need any assistance or have any questions.
> 
> Looking forward to seeing you all there, either in Tokyo in-person or
> virtually!
> 
> For mode information and updates, please keep an eye on the conference web
> page at https://lpc.events.
> 
> Previous posts about the MC:
> 
> - https://lore.kernel.org/linux-pci/20250812174506.GA3633156@rocinante

Thank you,

	Krzysztof

