Return-Path: <kvm+bounces-32816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52F569DFFB8
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 12:07:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 186D8280ED1
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 11:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A45551FCFF0;
	Mon,  2 Dec 2024 11:07:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mediconcil.de (mail.mediconcil.de [91.107.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7252F1FCFDC
	for <kvm@vger.kernel.org>; Mon,  2 Dec 2024 11:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.107.198.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733137660; cv=none; b=RQxB8h5lqAn/Mdj+6MtC7vWE211285Abtvy22yDJmQSetJdOj4gB2S+sF0cxP5SQDxzJ1xZGRm3TwKMxqErH7VdFl1OaFrKsaa7tPZaUB2hA+aYoeRoVX77kL3mrH8bCSTHuWbFycLiytkAtGg+9yBAN8rjGutFWSinENFYnvuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733137660; c=relaxed/simple;
	bh=NSv94Q3NgoPW6iPLAGxSedxVS1PNbGz5W9Pl5vsDpUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dhk1y4+NzdG3RbNeGuQpF2MAhTFixoa3aZvSHc3n63RnsDgSI9MVaqkPSWVM8FRpspkQ5s0zMjx8x78fupGXjtpR5hFTZeUGMmenUv44ozYzCVblDsIrLGRtGcdLfSIAaNOT/q3qub2Xat4cZUVJUllbtEo3kA45NbwOt/XhRrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io; spf=pass smtp.mailfrom=mias.mediconcil.de; arc=none smtp.client-ip=91.107.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mias.mediconcil.de
Received: from bernie by mediconcil.de with local (Exim 4.96)
	(envelope-from <bernie@mias.mediconcil.de>)
	id 1tI4Gx-00Dxkg-34;
	Mon, 02 Dec 2024 12:07:23 +0100
Date: Mon, 2 Dec 2024 12:07:23 +0100
From: Bernhard Kauer <bk@alpico.io>
To: Marc Zyngier <maz@kernel.org>
Cc: Bernhard Kauer <bk@alpico.io>, Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2] KVM: make uevents configurable
Message-ID: <Z02U64ebpuvFGnhe@mias.mediconcil.de>
References: <20241202090628.67919-1-bk@alpico.io>
 <86wmgitlkv.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86wmgitlkv.wl-maz@kernel.org>

On Mon, Dec 02, 2024 at 10:40:00AM +0000, Marc Zyngier wrote:
> > +bool disable_uevent_notify;
> 
> static?

Yes.

> <bikeshed-time>
> I'd rather have a positive logic. Something like:
> 
> +static bool uevent_notify = true;
> +module_param(uevent_notify, bool, 0644);

Choosing readability vs one byte in the data-section seems to be a good
tradeoff.


> </bikeshed-time>
> 
> I would also expect some form of documentation in
> Documentation/admin-guide/kernel-parameters.txt.

Good point. I will add this in v3.


Thanks,

	Bernhard

