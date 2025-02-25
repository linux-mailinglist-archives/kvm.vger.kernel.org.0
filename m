Return-Path: <kvm+bounces-39161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA6C7A44972
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 19:06:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B1B13B5F65
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 17:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA142156F3A;
	Tue, 25 Feb 2025 17:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HTqETPDh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C3F19EED7;
	Tue, 25 Feb 2025 17:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740506364; cv=none; b=U1WDZNmbdU1PISSqOdCYo/+nEDr9bs5s6Tc+A6UIEGzz++KiksJjh+m8plSRFGGeqBBNc0GCvj8+6V5GdSap0H/S7EmFDyM+Et0CX0Vupp+7OuCY1dky5rcwNYQzip1y16ioX2wgUm3ZAvtWTZIyNTODQmxGictbLp88GGhrvy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740506364; c=relaxed/simple;
	bh=Bc9bNYPj8tmaG3ScZCQNJLwNiDFq9wrrnUMkVEcbyBA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=QHwgc+B4KEshR+XTlyzRIWJhthXrzTNh9HImDZpLWxQHFEsV87kB7WGqym6cE2MYqgMOAfKW1izCucqfh9gmeZk+XnRPKnnCvmC2p93G4hxa1mjcjkGDetTZWilmG8kGELZQPtvPh4nxV815Qg2L7YQry9ItBZRSRLXrz/uiPqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HTqETPDh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC32C4CEE2;
	Tue, 25 Feb 2025 17:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740506363;
	bh=Bc9bNYPj8tmaG3ScZCQNJLwNiDFq9wrrnUMkVEcbyBA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=HTqETPDh780yct8+L4Jr9YB0BctNv2+9RaZJ1m6+daz+h7ikUGJq9j093GA8952MX
	 X5krnLjgfOE3VpTBXNAXXUu54EncW5ne5cm+1Dy3BchNW8pjjZUv9EoZ+ZalqpUfXU
	 VQL6JSGBxOyJFLP0RYy8HlyzT83y9jvEQNJ8zNpcOSx+sssTGNkdtnCd9ytjxlKqf0
	 uineQFgV3CDt+inex/zq3rNz/Qr5DZ3smd0hRsYXVKxCPJUuN01vx3a5dQkxYqJZpU
	 LQRZxA3TzeWkKNAtt1On/qrzolgSotaAgfn5fi31AuVX6rhw31UgtKKkC9DL4lShza
	 /DNJb+6pS7qWQ==
Date: Tue, 25 Feb 2025 11:59:21 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Peter Xu <peterx@redhat.com>, Precific <precification@posteo.de>,
	Athul Krishna <athul.krishna.kr@protonmail.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Linux PCI <linux-pci@vger.kernel.org>,
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: [bugzilla-daemon@kernel.org: [Bug 219619] New: vfio-pci: screen
 graphics artifacts after 6.12 kernel upgrade]
Message-ID: <20250225175921.GA511617@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250102113832.4d5c101a.alex.williamson@redhat.com>

On Thu, Jan 02, 2025 at 11:38:32AM -0700, Alex Williamson wrote:
> On Thu, 2 Jan 2025 10:04:02 -0700
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > On Thu, 2 Jan 2025 11:39:23 -0500
> > Peter Xu <peterx@redhat.com> wrote:
> > > OTOH, a pure question here is whether we should check pfn+pgoff instead of
> > > pgoff alone.  I have no idea how firmware would allocate BAR resources,
> > > especially on start address alignments.  I assume that needs to be somehow
> > > relevant to the max size of the bar, probably the start address should
> > > always be aligned to that max bar size?  If so, there should have no
> > > functional difference checking either pfn+pgoff or pgoff.  It could be a
> > > matter of readability in that case, saying that the limitation is about pfn
> > > (of pgtable) rather than directly relevant to the offset of the bar.  
> > 
> > Yes, I'm working on the proper patch now that we have a root cause and
> > I'm changing this to test alignment of pfn+pgoff.  The PCI BARs
> > themselves are required to have natural alignment, but the vma mapping
> > the BAR could be at an offset from the base of the BAR, which is
> > accounted for in our local vma_to_pfn() function.  So I agree that
> > pfn+pgoff is the more complete fix, which I'll post soon, and hope that
> > Precific can re-verify the fix.  Thanks,
> 
> The proposed fix is now posted here:
> 
> https://lore.kernel.org/all/20250102183416.1841878-1-alex.williamson@redhat.com
> 
> Please reply there with Tested-by and Reviewed-by as available.  Thanks,

#regzbot fix: 09dfc8a5f2ce ("vfio/pci: Fallback huge faults for unaligned pfn")

09dfc8a5f2ce appeared in v6.13-rc7.

