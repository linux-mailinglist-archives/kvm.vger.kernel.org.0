Return-Path: <kvm+bounces-29029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A9EA9A12EB
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 21:49:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CAA01C229B9
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 19:49:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FA15215F79;
	Wed, 16 Oct 2024 19:49:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6949A210C38;
	Wed, 16 Oct 2024 19:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729108167; cv=none; b=Hiz8s5/ICdMMxDk6V9ri3x90i1jf3rs5l48LYJvNoweU44gB7kNo//tjdsCl3uRsm1lY2bQhJMT5dXtdO/NyNfQIwwN9fOLMTXOYp6goPPaOlW2Ciw063vuRSFUyy1nH/YaEfHUdejrxYViIDLiRngaOSByTXAv952wTmc8TJg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729108167; c=relaxed/simple;
	bh=+hjBrFzvOL6xiMBUlSJ3Kdsp5Thqjo/zuLD5y0FAQBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MfJiEO57BgMH1vOP9kbkhdyE6wVYRNA0EAChCwmOrJMsesA+1rN+3V/ISIlkVSX+qX2yhT6qRUwVfbAgxBZhTSman6HK2653d4D5eE5WuU0Qx1a4txdWdMmFVEKnywr2j889Wy5NJUUN+mc29A8ewGg4UplwNz4eg3oFXaRkjzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from [192.168.2.102] (213.87.153.89) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Wed, 16 Oct
 2024 22:49:04 +0300
Message-ID: <a32f0891-936b-4cce-a874-78b1865717ae@omp.ru>
Date: Wed, 16 Oct 2024 22:49:02 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/13] ata: Use always-managed version of pci_intx()
To: Philipp Stanner <pstanner@redhat.com>, Damien Le Moal
	<dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, Basavaraj Natikar
	<basavaraj.natikar@amd.com>, Jiri Kosina <jikos@kernel.org>, Benjamin
 Tissoires <bentiss@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Alex Dubov <oakad@yahoo.com>,
	Sudarsana Kalluru <skalluru@marvell.com>, Manish Chopra
	<manishc@marvell.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Rasesh Mody <rmody@marvell.com>,
	<GR-Linux-NIC-Dev@marvell.com>, Igor Mitsyanko <imitsyanko@quantenna.com>,
	Sergey Matyukevich <geomatsi@gmail.com>, Kalle Valo <kvalo@kernel.org>,
	Sanjay R Mehta <sanju.mehta@amd.com>, Shyam Sundar S K
	<Shyam-sundar.S-k@amd.com>, Jon Mason <jdmason@kudzu.us>, Dave Jiang
	<dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>, Bjorn Helgaas
	<bhelgaas@google.com>, Alex Williamson <alex.williamson@redhat.com>, Juergen
 Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Jaroslav Kysela
	<perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Chen Ni
	<nichen@iscas.ac.cn>, Mario Limonciello <mario.limonciello@amd.com>, Ricky Wu
	<ricky_wu@realtek.com>, Al Viro <viro@zeniv.linux.org.uk>, Breno Leitao
	<leitao@debian.org>, Kevin Tian <kevin.tian@intel.com>, Thomas Gleixner
	<tglx@linutronix.de>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?=
	<ilpo.jarvinen@linux.intel.com>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Mostafa Saleh <smostafa@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>, Christian
 Brauner <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>, Eric Auger
	<eric.auger@redhat.com>, Reinette Chatre <reinette.chatre@intel.com>, Ye Bin
	<yebin10@huawei.com>, =?UTF-8?Q?Marek_Marczykowski-G=C3=B3recki?=
	<marmarek@invisiblethingslab.com>, Pierre-Louis Bossart
	<pierre-louis.bossart@linux.dev>, Peter Ujfalusi
	<peter.ujfalusi@linux.intel.com>, Maarten Lankhorst
	<maarten.lankhorst@linux.intel.com>, Kai Vehmanen
	<kai.vehmanen@linux.intel.com>, Rui Salvaterra <rsalvaterra@gmail.com>
CC: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-input@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <ntb@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<xen-devel@lists.xenproject.org>, <linux-sound@vger.kernel.org>
References: <20241015185124.64726-1-pstanner@redhat.com>
 <20241015185124.64726-10-pstanner@redhat.com>
Content-Language: en-US
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
In-Reply-To: <20241015185124.64726-10-pstanner@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.0, Database issued on: 10/16/2024 19:30:03
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 19
X-KSE-AntiSpam-Info: Lua profiles 188488 [Oct 16 2024]
X-KSE-AntiSpam-Info: Version: 6.1.0.4
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 39 0.3.39
 e168d0b3ce73b485ab2648dd465313add1404cce
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 213.87.153.89 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info: {Found in DNSBL: 213.87.153.89 in (user)
 dbl.spamhaus.org}
X-KSE-AntiSpam-Info:
	omp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: ApMailHostAddress: 213.87.153.89
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 19
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 10/16/2024 19:34:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 10/16/2024 5:04:00 PM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

On 10/15/24 9:51 PM, Philipp Stanner wrote:

> pci_intx() is a hybrid function which can sometimes be managed through
> devres. To remove this hybrid nature from pci_intx(), it is necessary to
> port users to either an always-managed or a never-managed version.
> 
> All users in ata enable their PCI-Device with pcim_enable_device(). Thus,
> they need the always-managed version.
> 
> Replace pci_intx() with pcim_intx().
> 
> Signed-off-by: Philipp Stanner <pstanner@redhat.com>

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

[...]

MBR, Sergey


