Return-Path: <kvm+bounces-32562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C1959DA40C
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 09:39:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 114E8283FAE
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 08:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA93189919;
	Wed, 27 Nov 2024 08:39:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mediconcil.de (mail.mediconcil.de [91.107.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE081114
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 08:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.107.198.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732696757; cv=none; b=nzWodpVYZZDLOy9wTu7ehsERHetsZp0KwSgh4delOsvK2fo96eU/vbEPSK1yDuEHj/Bsi4LL7HRsHFfh+zNv4LWdYw9OKw8k4Pe5+2bGCiQeSZbOPlXFyeGORO9MNO12n8zh7gF70gC0VzSWylP64rI6zC0dEYQT95G2pmEYXuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732696757; c=relaxed/simple;
	bh=pKj2gbzhJIvORCFG+atX8uFQZ3fQPLBvZosjinODXRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=erSXSCeO2z8qu29IWuY7ykKmBQcRIoJweQd8fTU+JURhhbWOhHpGqlZ0FCRMoAng580RxhD8QT14CYU2WFfftn5V0WJ0z0N18/q3k8x10YZ+jYrN4wN4/nNEPJhZfUEZdHWzCB1VncCiOb1NyrpgzuKzAhkpGeZH1wUak5Bekds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io; spf=pass smtp.mailfrom=mias.mediconcil.de; arc=none smtp.client-ip=91.107.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mias.mediconcil.de
Received: from bernie by mediconcil.de with local (Exim 4.96)
	(envelope-from <bernie@mias.mediconcil.de>)
	id 1tGDZb-008K4B-1C;
	Wed, 27 Nov 2024 09:38:59 +0100
Date: Wed, 27 Nov 2024 09:38:59 +0100
From: Bernhard Kauer <bk@alpico.io>
To: Marc Zyngier <maz@kernel.org>
Cc: Bernhard Kauer <bk@alpico.io>, Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: make uevents configurable
Message-ID: <Z0bao0moyeDgqBDU@mias.mediconcil.de>
References: <20241122095806.4034415-1-bk@alpico.io>
 <86h67vusnf.wl-maz@kernel.org>
 <Z0Wg0jQLRuAQrl0j@mias.mediconcil.de>
 <86frneutlt.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86frneutlt.wl-maz@kernel.org>

On Tue, Nov 26, 2024 at 11:23:10AM +0000, Marc Zyngier wrote:
> > > I'm not overly keen on the command-line flag though, as this is the
> > > sort of things you'd like to be able to control more finely. Or at
> > > least without having to trigger a reboot.
> > 
> > I compile KVM as module, so I can reload it with different parameters
> > easily.
> 
> arm64 doesn't (and cannot) build KVM as a module. 

Ah, I didn't realize it.  But being able to patch EL2 from EL1 is probably
more complicated than what is gained with it.


> > But I can make the module parameter read-write so that it is modifiable
> > during runtime via /sys/module/kvm/parameters/ even when KVM is compiled
> > into the kernel.
> 
> I guess that'd be the next best thing.

Ok, I will do that in v2 of the patch to be sent next week.


	Bernhard

