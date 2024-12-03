Return-Path: <kvm+bounces-32937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C1B4E9E2AF1
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 19:33:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4721FC0116F
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 16:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BB441F8AD4;
	Tue,  3 Dec 2024 16:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eQ796POB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30811F76A4;
	Tue,  3 Dec 2024 16:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242873; cv=none; b=Oqrs8jc5F1PiL5N28g3Rtf1Zzo3LjxRA/lKXj1YV2JwUn9PwRGNCqDJgxdkjW5lqNrA03py54HjObYjmlMOXunBv5u2kvsJDtYg0IgRgJZaipdCpjrhi+xTytPZ6uHzzdSWJP3ARFWeJo40wLznY5+wufZARo06HpGUU/kXxLo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242873; c=relaxed/simple;
	bh=/NcUnBYCseC1c5n4V7Yq6LjgKQASIenEHRjXnxEaO+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MaSFbt5Kp2irIosAaJRcqp343pswZhiiKg6CN27TkfO53oUcWhlmPdah503SbOuabVQeTLhciWefjpPgIxl//Yd/JsBCi2iRlGJuB1gnC+/7r6tV3Ui78l3/sDSpuDDyf6AXY2LFGaEBwQInCJo/4XGEMUAfec2gsK27MH1tISw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eQ796POB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C934C4CECF;
	Tue,  3 Dec 2024 16:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733242873;
	bh=/NcUnBYCseC1c5n4V7Yq6LjgKQASIenEHRjXnxEaO+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eQ796POBt2fYvbC3ysEMGNeA5CtoJzxBlDTX6eG+yK39IZOhTMotpSj5tnJk+vwiL
	 mNZ+IaWjfYhO/8bfOeVH1FjwZ7PuHcN+O3qEcx0evXBNxxHySYDQ/EeI/nmSNZNkwo
	 Hf4BPc87WAjCZUV6UIGe0wCrZ2xGUBROSyEI5RJchsUoPYnzrnvfkjLYqh0mHdSMdc
	 2ipa40ettnZd1j8piE131QCLLAalP0opU4TcHfIR7NmTO0k8jeDEDQh8wTfAz1qT2M
	 kOq6CcpskOJYZgFNos/WOC2f90YAqmD8e/CANI9UrSGok8Uq+xDHjK1aEi48DhKrkT
	 gMxlq6gF8gJSQ==
Date: Tue, 3 Dec 2024 16:21:07 +0000
From: Simon Horman <horms@kernel.org>
To: Michael Kelley <mhklinux@outlook.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Yury Norov <yury.norov@gmail.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Eric Dumazet <edumazet@google.com>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	Long Li <longli@microsoft.com>, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Leon Romanovsky <leon@kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: mana: Fix memory leak in mana_gd_setup_irqs
Message-ID: <20241203162107.GF9361@kernel.org>
References: <20241128194300.87605-1-mlevitsk@redhat.com>
 <SN6PR02MB4157DBBACA455AC00A24EA08D4292@SN6PR02MB4157.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR02MB4157DBBACA455AC00A24EA08D4292@SN6PR02MB4157.namprd02.prod.outlook.com>

On Thu, Nov 28, 2024 at 09:49:35PM +0000, Michael Kelley wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com> Sent: Thursday, November 28, 2024 11:43 AM
> > 
> > Commit 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
> > added memory allocation in mana_gd_setup_irqs of 'irqs' but the code
> > doesn't free this temporary array in the success path.
> > 
> > This was caught by kmemleak.
> > 
> > Fixes: 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  drivers/net/ethernet/microsoft/mana/gdma_main.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > index e97af7ac2bb2..aba188f9f10f 100644
> > --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > @@ -1375,6 +1375,7 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
> >  	gc->max_num_msix = nvec;
> >  	gc->num_msix_usable = nvec;
> >  	cpus_read_unlock();
> > +	kfree(irqs);
> >  	return 0;
> > 
> >  free_irq:
> 
> FWIW, there's a related error path leak. If the kcalloc() to populate
> gc->irq_contexts fails, the irqs array is not freed. Probably could
> extend this patch to fix that leak as well.

Yes, as that problem also appears to be introduced by the cited commit
I agree it would be good to fix them both in one patch.

