Return-Path: <kvm+bounces-35694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 455E5A143B1
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 22:00:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19050165D7D
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 21:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21EB019CC05;
	Thu, 16 Jan 2025 21:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="krLzUDGJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EA11991BB;
	Thu, 16 Jan 2025 21:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737061239; cv=none; b=MsGjdWpShChGnAb6aCPGT6RJzbejxR90pe3kleVJ4pZwIv5gon+MU8CZd+/13AaFfEnQ5K+IOuOUGQYYF0bsufZtgJNd6+V2xKY6mC/zgmWtjUXuiW8N2D6zSuT66evOqdKNzxKWZptyG77VeSIEX65Il/nPfdoZAmMD2ULQy5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737061239; c=relaxed/simple;
	bh=ei48WzDzQXjwdLn3xeNuV6Y9soa7jumN+VhYVf6oIbQ=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=scstilmMavMSoDRO3WtUaIh/93y6SgZX1cpqtw+OLNPuLjV5MAZvJQ5Crc8NBD5XhEoJUlJ7u+or1+XNG/sLANmIvf5I8LgMoN+6C/72ts02l4Lw8Gf4pF52pu7v9sELlF+4VQOprB2ZlGxCJWxd90phkX2W97xSaoA9jskpQdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=krLzUDGJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159CDC4CEE3;
	Thu, 16 Jan 2025 21:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737061238;
	bh=ei48WzDzQXjwdLn3xeNuV6Y9soa7jumN+VhYVf6oIbQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=krLzUDGJpvLy/t9Kt5pMwTh4Uez1IeaoqrxvB8XYpPZgBiTnhXx4WRFQUowinmlzn
	 mRd7JZZtv/4faOqBd3sx4rT9ZKwaCYL17MWmvA3cPeiZ4C/X3JDh5iIhEbfp2u6hEE
	 tMcHiOKCOMg0c+f9JGDQQeZMo2Hy0tiwzByswP6RQJZ2BrF7RRLWOnhFVxFdXbWaR1
	 4YHKEEvilbrEG2rQafVavGW3VRP7kyVKE4Mw287KtrZwmyrHbWfMS4c5J3qeE9EMZ5
	 NEqrqzzZ/4AzOrS8iZWTVjTXJxC+6RLJ+os16QqA8uukEZGLCxL9bltC9YfSkGdtKl
	 Gy0sHHYDs+8bg==
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id DAAFD1200083;
	Thu, 16 Jan 2025 16:00:36 -0500 (EST)
Received: from phl-imap-12 ([10.202.2.86])
  by phl-compute-03.internal (MEProxy); Thu, 16 Jan 2025 16:00:36 -0500
X-ME-Sender: <xms:dHOJZ_8hnrsy-ECJdAOQhqbieHNitsZTUyWxpffUhYWXpC0s_BRHQQ>
    <xme:dHOJZ7uv6bWKUdrSLNYRkQNUnErbS8jLliX3TjOn9CZwxad3Qot1cG_Imf2F-tjUu
    I2mXftxq5MS6uIf3J0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudeiuddgudegtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthejredtredt
    tdenucfhrhhomhepfdfnvghonhcutfhomhgrnhhovhhskhihfdcuoehlvghonheskhgvrh
    hnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpeejvefflefgledvgfevvdetleehhfdv
    ffehgeffkeevleeiveefjeetieelueeuvdenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehlvghonhdomhgvshhmthhprghuthhhphgvrhhsohhn
    rghlihhthidquddvfedtheefleekgedqvdejjeeljeejvdekqdhlvghonheppehkvghrnh
    gvlhdrohhrgheslhgvohhnrdhnuhdpnhgspghrtghpthhtohepvdekpdhmohguvgepshhm
    thhpohhuthdprhgtphhtthhopehjohhroheskegshihtvghsrdhorhhgpdhrtghpthhtoh
    eprhhosghinhdrmhhurhhphhihsegrrhhmrdgtohhmpdhrtghpthhtoheplhhoghgrnhhg
    seguvghlthgrthgvvgdrtghomhdprhgtphhtthhopegshhgvlhhgrggrshesghhoohhglh
    gvrdgtohhmpdhrtghpthhtohepshgrghhisehgrhhimhgsvghrghdrmhgvpdhrtghpthht
    ohepshhhrghmvggvrhgrlhhirdhkohhlohhthhhumhdrthhhohguiheshhhurgifvghird
    gtohhmpdhrtghpthhtoheprhguuhhnlhgrphesihhnfhhrrgguvggrugdrohhrghdprhgt
    phhtthhopehkvghvihhnrdhtihgrnhesihhnthgvlhdrtghomhdprhgtphhtthhopegrgi
    gsohgvsehkvghrnhgvlhdrughk
X-ME-Proxy: <xmx:dHOJZ9AsJorCdvsMQoxKmdUUyLaDrarWg_hDv0lIk4UGGYNSNWOc2A>
    <xmx:dHOJZ7dgJxPeoxCqJDK6dxgG9pUYIr_52ACmcuhRIw1Qh9GaunCLwA>
    <xmx:dHOJZ0NcoJ96f9Cm3V1tQ5aoiCzNw33kuCzYomD4dLo444b1fpQ0Xw>
    <xmx:dHOJZ9kW1rLTlUibKKzm5XjNDGE7mt0S8k2egAdwWJej7fRDieXAPQ>
    <xmx:dHOJZ-tBWC5CFeUXfiLbOKYQdG4K_dodDJWtuk1DQC1UPn6t-RWZL1C7>
Feedback-ID: i927946fb:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A17001C20067; Thu, 16 Jan 2025 16:00:36 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 16 Jan 2025 23:00:14 +0200
From: "Leon Romanovsky" <leon@kernel.org>
To: "Jason Gunthorpe" <jgg@ziepe.ca>
Cc: "Robin Murphy" <robin.murphy@arm.com>, "Jens Axboe" <axboe@kernel.dk>,
 "Joerg Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>,
 "Christoph Hellwig" <hch@lst.de>, "Sagi Grimberg" <sagi@grimberg.me>,
 "Keith Busch" <kbusch@kernel.org>, "Bjorn Helgaas" <bhelgaas@google.com>,
 "Logan Gunthorpe" <logang@deltatee.com>,
 "Yishai Hadas" <yishaih@nvidia.com>,
 "Shameer Kolothum" <shameerali.kolothum.thodi@huawei.com>,
 "Kevin Tian" <kevin.tian@intel.com>,
 "Alex Williamson" <alex.williamson@redhat.com>,
 "Marek Szyprowski" <m.szyprowski@samsung.com>,
 =?UTF-8?Q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Jonathan Corbet" <corbet@lwn.net>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org,
 "Randy Dunlap" <rdunlap@infradead.org>
Message-Id: <45eee716-83fd-4b15-ae11-2414aa119db3@app.fastmail.com>
In-Reply-To: <20250116201853.GE674319@ziepe.ca>
References: <cover.1734436840.git.leon@kernel.org>
 <fa43307222f263e65ae0a84c303150def15e2c77.1734436840.git.leon@kernel.org>
 <ad2312e0-10d5-467a-be5e-75e80805b311@arm.com>
 <20250115083340.GL3146852@unreal> <20250116201853.GE674319@ziepe.ca>
Subject: Re: [PATCH v5 07/17] dma-mapping: Implement link/unlink ranges API
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, Jan 16, 2025, at 22:18, Jason Gunthorpe wrote:
> On Wed, Jan 15, 2025 at 10:33:40AM +0200, Leon Romanovsky wrote:
>> > > +	do {
>> > > +		phys_addr_t phys;
>> > > +		size_t len;
>> > > +
>> > > +		phys = iommu_iova_to_phys(domain, addr);
>> > > +		if (WARN_ON(!phys))
>> > > +			continue;
>> > 
>> > Infinite WARN_ON loop, nice.
>> 
>> No problem, will change it to WARN_ON_ONCE.
>
> I think the other point is that the addr doesn't increase, so this
> loop will lock up.

Yes, this is what I planned to do.

>
> Possibly just do return? I suppose something is hopelessly corrupted
> if we ever hit this..
>
> Jason

