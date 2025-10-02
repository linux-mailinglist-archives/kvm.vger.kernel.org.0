Return-Path: <kvm+bounces-59438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41283BB49C7
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 19:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6AD6321EDD
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 17:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E737226E153;
	Thu,  2 Oct 2025 17:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tfYrp3gD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B451419A9;
	Thu,  2 Oct 2025 17:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759424414; cv=none; b=tpy+LGvQHJ2ay5mNEJCUEiGQtUq+qBYK8zacJrq7hed8v1G0AFFqG/BdYDe39FT9TAD0Ov6PHa8Y7OYdlpVXcUoEdNXGjlSKP8LS/lQNzlCjPPZfJIpwT/p0NU7CxQm9yfYvpDBcZBfnLYk5kiusI/A40OaeSyqb57g01FcHgqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759424414; c=relaxed/simple;
	bh=JeDo0/gU/aESo9xjFaYoM9qP44UP1j9qzQZuprvxYBc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=au0+3Ugwvb1at0VENwkxMjh3nmtGDv0wrD1n1J6Ha6JHo17xgSqsz9xfTBhD9P9b7EaH73LPkuQJTMKxglOzX8hb0+Wzzau2kUGJpcfSPip1LIK5rwDLYV2hYOIxb/ZwGuiqXxnv1iZRqHSYrjwHdrLt9QuZuTdgszFHgVuUDgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tfYrp3gD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75414C4CEF4;
	Thu,  2 Oct 2025 17:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759424414;
	bh=JeDo0/gU/aESo9xjFaYoM9qP44UP1j9qzQZuprvxYBc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=tfYrp3gDrkm1utxo4ziuF3mm7o/zWzsSnOByeTqhVl2Z8gFpwqyj5Bhaf5nfQ5Tao
	 wxU0PkCLscfjB40FmXWgjsJipOSll3imjERGnUBvScnrDniapFuomAMA/Ru3PtSX1z
	 SZZLFC7ycSg7qMv6hmde4oNMp8AePiVz68I2Ca3nwF08dMUYpsTovXEhqmvh8ZrSEA
	 ds7nwIQEVMnbbyGowfMPme3HhOQxuCs7wv4etQCAHAqEga8uJUX08Ad3AfLi0qIOoH
	 rqjpd9hETAVn8khrUBKUz1sXmuhylGLB3x+S474ZpfzV2Hwbg1JksEp39XllqIxDyA
	 FD8Bw5/b7U/Bw==
Date: Thu, 2 Oct 2025 12:00:13 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
	alex.williamson@redhat.com, clg@redhat.com, mjrosato@linux.ibm.com,
	Farhan Ali <alifm@linux.ibm.com>, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v4 04/10] s390/pci: Add architecture specific
 resource/bus address translation
Message-ID: <20251002170013.GA278722@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5ab698977f724e9121f81b9cfec9503d9decc72.camel@linux.ibm.com>

On Thu, Oct 02, 2025 at 02:58:45PM +0200, Niklas Schnelle wrote:
> On Wed, 2025-09-24 at 10:16 -0700, Farhan Ali wrote:
> > On s390 today we overwrite the PCI BAR resource address to either an
> > artificial cookie address or MIO address. However this address is different
> > from the bus address of the BARs programmed by firmware. The artificial
> > cookie address was created to index into an array of function handles
> > (zpci_iomap_start). The MIO (mapped I/O) addresses are provided by firmware
> > but maybe different from the bus address. This creates an issue when trying
> > to convert the BAR resource address to bus address using the generic
> > pcibios_resource_to_bus().
> > 
> > Implement an architecture specific pcibios_resource_to_bus() function to
> > correctly translate PCI BAR resource addresses to bus addresses for s390.
> > Similarly add architecture specific pcibios_bus_to_resource function to do
> > the reverse translation.
> > 
> > Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> > ---
> >  arch/s390/pci/pci.c       | 74 +++++++++++++++++++++++++++++++++++++++
> >  drivers/pci/host-bridge.c |  4 +--
> >  2 files changed, 76 insertions(+), 2 deletions(-)
> > 
> 
> @Bjorn, interesting new development. This actually fixes a current
> linux-next breakage for us. In linux-next commit 06b77d5647a4 ("PCI:
> Mark resources IORESOURCE_UNSET when outside bridge windows") from Ilpo
> (added) breaks PCI on s390 because the check he added in
> __pci_read_base() doesn't find the resource because the BAR address
> does not match our MIO / address cookie addresses. With this patch
> added however the pcibios_bus_to_resource() in __pci_read_base()
> converts  the region correctly and then Ilpo's check works. I was
> looking at this code quite intensely today wondering about Benjamin's
> comment if we do need to check for containment rather than exact match.
> I concluded that I think it is fine as is and was about to give my R-b
> before Gerd had tracked down the linux-next issue and I found that this
> fixes it.
> 
> So now I wonder if we might want to pick this one already to fix the
> linux-next regression? Either way I'd like to add my:
> 
> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>

Hmmm, thanks for the report.  I'm about ready to send the pull
request, and I hate to include something that is known to break s390
and would require a fix before v6.18.  At the same time, I hate to add
non-trivial code, including more weak functions, this late in the
window.

06b77d5647a4 ("PCI: Mark resources IORESOURCE_UNSET when outside
bridge windows") fixes some bogus messages, but I'm not sure that it's
actually a functional change.  So maybe the simplest at this point
would be to defer that commit until we can do it and the s390 change
together.

Bjorn

