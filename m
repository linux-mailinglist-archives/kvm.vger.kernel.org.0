Return-Path: <kvm+bounces-28981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E9B59A05B0
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 11:37:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 988EEB25264
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 09:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E3ED206078;
	Wed, 16 Oct 2024 09:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TKOX9/0G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F6F205E05;
	Wed, 16 Oct 2024 09:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729071432; cv=none; b=tMUv6aUC8PIdhk+1ZEkqzFNMbxjkAYK92e8rEkrxRAsAh8pqGy3tiPGc92oHPhDrmtZGo/urrewcAA5wSvD5wVFvFV8LVSwilyITZ2WJkYSLp7GwkgNDexnDllcOOOqGqQK9dQ3AR0NqQ35lnnb/P7O78WHtgmtmI0Z+fMN6Y1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729071432; c=relaxed/simple;
	bh=3qs9RCIcBMaiRaaQowBtUAYRplzqstMrihAHPPNLmDY=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=Cnc8wtkcZW4olhmy2rYsWJnD/QgVO9gh2vUVBSkOn67kPDmY099bhEA8vV66VwO97rNkYvxIM3kXWhNUrdu/pbB7gXJTcsJqQdGPIPjm4g3/vevlGgQ40ytb1ARV34FsVdK9InA5uAqNp79NI27YxaJ6uee+i65AQPJYPQSmYKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TKOX9/0G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83DEC4CECF;
	Wed, 16 Oct 2024 09:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729071431;
	bh=3qs9RCIcBMaiRaaQowBtUAYRplzqstMrihAHPPNLmDY=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=TKOX9/0GP1+lza5sQLTeaGorlh3MWnyZcXGq05D/f/GBd2opmS8ChUbAgJdPb/CZ1
	 yn5rFWuoHPLLh+d3Tn7faqhBzYHFIRUNCjskSa+aHE7Hk+eHTbbOc5TCSh9q9iJ3uy
	 ecD+a1d8UI2TkI22bqwo5dXLynEXWBDFQZqY5PiV0eO3UFpqqqMhVJV65YiRQTDMNj
	 WP2usCFu0zlWexw7EVaqgNj9e/FFPneDaR8h9YjjAPmN4hPc1uAoQejPiORMJPvOU5
	 CWaLZFgGsjhgxS13aQ+7ta5bJuOGaob/3dXOYCK3/wDOU6szpcWpgz4jJlrkWESsRr
	 s45FfeYSH4aKw==
From: Kalle Valo <kvalo@kernel.org>
To: Philipp Stanner <pstanner@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,  Niklas Cassel <cassel@kernel.org>,
  Sergey Shtylyov <s.shtylyov@omp.ru>,  Basavaraj Natikar
 <basavaraj.natikar@amd.com>,  Jiri Kosina <jikos@kernel.org>,  Benjamin
 Tissoires <bentiss@kernel.org>,  Arnd Bergmann <arnd@arndb.de>,  Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>,  Alex Dubov <oakad@yahoo.com>,
  Sudarsana Kalluru <skalluru@marvell.com>,  Manish Chopra
 <manishc@marvell.com>,  "David S. Miller" <davem@davemloft.net>,  Eric
 Dumazet <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,  Paolo
 Abeni <pabeni@redhat.com>,  Rasesh Mody <rmody@marvell.com>,
  GR-Linux-NIC-Dev@marvell.com,  Igor Mitsyanko <imitsyanko@quantenna.com>,
  Sergey Matyukevich <geomatsi@gmail.com>,  Sanjay R Mehta
 <sanju.mehta@amd.com>,  Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,  Jon
 Mason <jdmason@kudzu.us>,  Dave Jiang <dave.jiang@intel.com>,  Allen Hubbe
 <allenbh@gmail.com>,  Bjorn Helgaas <bhelgaas@google.com>,  Alex
 Williamson <alex.williamson@redhat.com>,  Juergen Gross <jgross@suse.com>,
  Stefano Stabellini <sstabellini@kernel.org>,  Oleksandr Tyshchenko
 <oleksandr_tyshchenko@epam.com>,  Jaroslav Kysela <perex@perex.cz>,
  Takashi Iwai <tiwai@suse.com>,  Chen Ni <nichen@iscas.ac.cn>,  Mario
 Limonciello <mario.limonciello@amd.com>,  Ricky Wu <ricky_wu@realtek.com>,
  Al Viro <viro@zeniv.linux.org.uk>,  Breno Leitao <leitao@debian.org>,
  Kevin Tian <kevin.tian@intel.com>,  Thomas Gleixner <tglx@linutronix.de>,
  Ilpo =?utf-8?Q?J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,  Andy
 Shevchenko
 <andriy.shevchenko@linux.intel.com>,  Mostafa Saleh <smostafa@google.com>,
  Jason Gunthorpe <jgg@ziepe.ca>,  Yi Liu <yi.l.liu@intel.com>,  Christian
 Brauner <brauner@kernel.org>,  Ankit Agrawal <ankita@nvidia.com>,  Eric
 Auger <eric.auger@redhat.com>,  Reinette Chatre
 <reinette.chatre@intel.com>,  Ye Bin <yebin10@huawei.com>,  Marek
 =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
  Pierre-Louis
 Bossart <pierre-louis.bossart@linux.dev>,  Peter Ujfalusi
 <peter.ujfalusi@linux.intel.com>,  Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>,  Kai Vehmanen
 <kai.vehmanen@linux.intel.com>,  Rui Salvaterra <rsalvaterra@gmail.com>,
  linux-ide@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-input@vger.kernel.org,  netdev@vger.kernel.org,
  linux-wireless@vger.kernel.org,  ntb@lists.linux.dev,
  linux-pci@vger.kernel.org,  kvm@vger.kernel.org,
  xen-devel@lists.xenproject.org,  linux-sound@vger.kernel.org
Subject: Re: [PATCH 10/13] wifi: qtnfmac: use always-managed version of
 pcim_intx()
References: <20241015185124.64726-1-pstanner@redhat.com>
	<20241015185124.64726-11-pstanner@redhat.com>
Date: Wed, 16 Oct 2024 12:36:58 +0300
In-Reply-To: <20241015185124.64726-11-pstanner@redhat.com> (Philipp Stanner's
	message of "Tue, 15 Oct 2024 20:51:20 +0200")
Message-ID: <87y12o4ced.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Philipp Stanner <pstanner@redhat.com> writes:

> pci_intx() is a hybrid function which can sometimes be managed through
> devres. To remove this hybrid nature from pci_intx(), it is necessary to
> port users to either an always-managed or a never-managed version.
>
> qtnfmac enables its PCI-Device with pcim_enable_device(). Thus, it needs
> the always-managed version.
>
> Replace pci_intx() with pcim_intx().
>
> Signed-off-by: Philipp Stanner <pstanner@redhat.com>

Feel free to take this via the PCI tree:

Acked-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

