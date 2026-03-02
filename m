Return-Path: <kvm+bounces-72445-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CBvCOCQjpmkiLAAAu9opvQ
	(envelope-from <kvm+bounces-72445-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:54:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 67CAA1E6DC8
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:54:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1007130A08B7
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 23:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE72F358393;
	Mon,  2 Mar 2026 23:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gzNwcMy6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC8C320A24;
	Mon,  2 Mar 2026 23:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772495604; cv=fail; b=N2eTj6uBnrwMuzm46mHJaYyTE2ZpcuZPjEuyhJVahfO3mM1TDNN5DS7JupW/NBF3qx3F7y6UtQHW3swzmQpfg82M4S25OsNFBrP+QDr4NBBvQNQQuppB67xG5tpRdVva4ybTlUumNok4NzHlTwa2ZKOA70e9MMFhTkGFFrZB9Y8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772495604; c=relaxed/simple;
	bh=I/5UKrfPMQr52Iu1IIR1L9+lYV5NXTvKyhpK3x0tPgM=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=dzYA0BIY3ydKmXULWrfJzkH/cBpWLtM3bI2cY+bjJxQdZCMgy1ulzxfhQJI8oQLj15/AEy25EvysCCsBnxMX0afJtxY+v5v5SO7C+pDLNpHCt/EU4OPylLWWQoKg9ZTneTztvBicjI9qxuIG/hFzRonfB1b03jgfmnz0g4Z3Cp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gzNwcMy6; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772495602; x=1804031602;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=I/5UKrfPMQr52Iu1IIR1L9+lYV5NXTvKyhpK3x0tPgM=;
  b=gzNwcMy6s61A7O5x3zqDIyyIO3E1f5umgmE1kUZhl7C3EyHItlGOEZul
   Xo6g4tdoMxwGEvzSaCmReVZhtvJXDIf5NHEA1oit+EkYn1gyqSRBjh/yn
   B/rXOUGtqPeYfgkVtxl6gvt9TLh4hmTUvvmZjAOBnTgyiV+kYPb12LGHC
   Uw6cMe4J1B8pOeHe3G4I4aswETlmgQ3ni1qMAF+H1jgrlZXPO1gWXvMkp
   mwr1KUSFo1/aHMvyiLOolgyBCG6FI7YzJPIhRsKSZHfFYho9IT3CrdeRS
   7MhEZzZLpKXqUgR/JeRrCPB3lv7RjOxD5c+GXuqT/zD/Z3WKuq75StgOB
   g==;
X-CSE-ConnectionGUID: zAZeSavCRymIdcBlDdaykw==
X-CSE-MsgGUID: cG+yfNqvQSSwlr1WzVb0+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="73706049"
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="73706049"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 15:53:21 -0800
X-CSE-ConnectionGUID: NgTK/TwXTWmdPuGyBpLwwg==
X-CSE-MsgGUID: oZ9rFPILTkupQilwPEuxrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="220847277"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 15:53:20 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 2 Mar 2026 15:53:20 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 2 Mar 2026 15:53:20 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.20) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 2 Mar 2026 15:53:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HvbMX12AbXnmxMagpQQYRZQUEDkAERkxMRamUlUH/C/M8vqW5iB48tstsDu+zgHgwuZmfQZJpYEHH5oKtEVgQhFuziiYuWhCmUSC3wuVaVyGOXrdlHWFNC2+Wmpb2SdbX3+qc9XjhgS9p7sHdniGYLIBNZHduh0aAGrFvJYgXvm2ovff662M+YPClllxY4VLXSYYdr09FsHzEymqzGMN/J62gpBpwlM6AlCOvrHBF7p+ATgrdp5EigrVN2ztlA3FBRBlX49Qqk9X9l2o2AG0kQzKL8qj5WIGUIIUgyyQKN4ffBmQf65eciIEkCTFRunJdWHtRS1a90LQT5KbF11UxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Pm5ph9+anNugRvt4ZICqI+/gl18Sx4ilL7/l3LemUQ=;
 b=FPKn+UNAkpRYftyLNGSxfrPebZgxxbhT53sXXGLCf404BOAV0GX5edIK6P5rBmrkAkdHOhUysQ1gG6d0weraMsARqiZ7+hbuNME5VnUCDC4eacDd2mU/91bQ0IJ4nCVviOpx0MB2gBxKiCVqcVpCGASC4KNO1kOS/nMKBq4bZxwuRdx3g+x39DzqupXTcF2cyxHPa/wUAZZDEHJ4uZU++jTjuftX4iUW0VsQGg9NtIXtpqQZp0IQjqL0w3vCsDShx7UQvBGcpMkoLCVU7NfivJKuMT/BhB/hVJ3nFwc4lbq1iLCvlfouYK4pbBqtRovD18h08QxCUaH636cpbI7/RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB5941.namprd11.prod.outlook.com (2603:10b6:510:13d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 23:53:15 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 23:53:14 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 2 Mar 2026 15:53:13 -0800
To: Jason Gunthorpe <jgg@ziepe.ca>, <dan.j.williams@intel.com>
CC: Robin Murphy <robin.murphy@arm.com>, Alexey Kardashevskiy <aik@amd.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Andy Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"Bjorn Helgaas" <bhelgaas@google.com>, Marek Szyprowski
	<m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>, Michael Ellerman
	<mpe@ellerman.id.au>, "Mike Rapoport" <rppt@kernel.org>, Tom Lendacky
	<thomas.lendacky@amd.com>, "Ard Biesheuvel" <ardb@kernel.org>, Neeraj
 Upadhyay <Neeraj.Upadhyay@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
	Stefano Garzarella <sgarzare@redhat.com>, Melody Wang <huibo.wang@amd.com>,
	Seongman Lee <augustus92@kaist.ac.kr>, Joerg Roedel <joerg.roedel@amd.com>,
	"Nikunj A Dadhania" <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
	"Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>, Andi Kleen
	<ak@linux.intel.com>, Kuppuswamy Sathyanarayanan
	<sathyanarayanan.kuppuswamy@linux.intel.com>, Tony Luck
	<tony.luck@intel.com>, David Woodhouse <dwmw@amazon.co.uk>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Denis Efremov
	<efremov@linux.com>, Geliang Tang <geliang@kernel.org>, Piotr Gregor
	<piotrgregor@rsyncme.org>, "Michael S. Tsirkin" <mst@redhat.com>, "Alex
 Williamson" <alex@shazbot.org>, Arnd Bergmann <arnd@arndb.de>, Jesse Barnes
	<jbarnes@virtuousgeek.org>, Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, "Aneesh Kumar K.V (Arm)"
	<aneesh.kumar@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Kim Phillips <kim.phillips@amd.com>, "Konrad
 Rzeszutek Wilk" <konrad.wilk@oracle.com>, Stefano Stabellini
	<sstabellini@kernel.org>, Claire Chang <tientzu@chromium.org>,
	<linux-coco@lists.linux.dev>, <iommu@lists.linux.dev>
Message-ID: <69a622e92cccf_6423c10092@dwillia2-mobl4.notmuch>
In-Reply-To: <20260228002808.GO44359@ziepe.ca>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-5-aik@amd.com>
 <699f238873ae7_1cc5100b6@dwillia2-mobl4.notmuch>
 <04b06a53-769c-44f1-a157-34591b9f8439@arm.com>
 <699f621daab02_2f4a1008f@dwillia2-mobl4.notmuch>
 <20260228002808.GO44359@ziepe.ca>
Subject: Re: [PATCH kernel 4/9] dma/swiotlb: Stop forcing SWIOTLB for TDISP
 devices
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0065.namprd03.prod.outlook.com
 (2603:10b6:a03:331::10) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB5941:EE_
X-MS-Office365-Filtering-Correlation-Id: 87bd3eb9-23e4-45ba-aa3e-08de78b6de81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: uAxQTPx7LPtMGhugIBuuQFg3WR1boqpXsvswqdYo12HOUUd7JqTpCh7BqxRiTCE/m4K50mZMXJ+NyD+Gg8pGhfzyeEsebu6TSc04WqGDlyFTBDrBxKHlVfFw7T7BzvLV+27CI/EaJ67Jstwbsp9JLJ8R4R+igk48yTbgp7cIo3r1k7UwQBybT31u2BTF/fraU/Vulagake5qOpGS9nTkoeHBx513SqhDmubLJzJTB7wQgHKCdRmRoVWGJ/pt00M1FmKX7ERVWGkFiBiwaxB6lTxluddgIaqTLtPcguvn4d19N/Wjd/acRxOAtzJm8t3hzr25DOAvoKggy5p39451IoaXxpW/MRJtoH2078UFX3/t8rSKHr6bzs2N4ZEmjtJORzDWOoHq3YZASPJeTIiCyvUQk7L66AWpaAxVllJkWuTozVfae+rPGkSiyXlp6bFMHbHyEtFeRfhcgje4MQUaibG/O6kmtrnk2BpTDO6l/1d+KViO2FoOgg9aZG4lb0qpP9WVzRNRMNxlNWbSy4jfxi7dvDggqtacOf/yowV0OSEysKlLFwyTFXjhIeHD90pjtZ/sZ5kbQv2KJ+didNk0zyRmTuhlzBp6MRyFjOi+5OcbpJhEiBAF+DRlfkC25Xn51PyDGmmYg8mZ0GYdL0X9QUF5iA491DpYrOpO8u5aaMQ8x7wwdQOnXPMsZhXKXKwsVa8Nmnu9G3h9VdK9v9vcBvD6S3nMTa165tDau0um2R8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHV5TUFQWXBnam9uaUZLeHkrd3RNVHlSZkFac2laSjRZNi9yS1F5bjZBcmp6?=
 =?utf-8?B?WlozUmFIcGdZSGdnWlY5YjMrNlJUbjkxUzRVaTlLOFN5NThoSTlGZFpIYXQ1?=
 =?utf-8?B?R1VuOG9wQXB0aklGNFZoVWQvLzFSSUpQY2wwUmFFSlplb21DVGhFcldJOWxj?=
 =?utf-8?B?U1ZycjRzM3lmV2x4K3JCZzZ5WXY0Kzh2dGtXOS9sYm8wYmo5OEdYVU5Wa3lB?=
 =?utf-8?B?TzlGM3Q2RXFocjYzVHFhL1dHbENGSGZpWHRYcGJYOTZYenErVDFMQS9pUUdY?=
 =?utf-8?B?bVlBSnNsSTFHTFdMZ2VndURRaHF1WHZjdDBKMWFrbUdjT0l6SDJkU3BFTll5?=
 =?utf-8?B?K1lJTGVyczNvU1dvSGFSZU9nM3k4Tm93QUNzUng1NGo5YkVqMGFQY3JhdFN2?=
 =?utf-8?B?RTl3RmdvZzFRN3JsVThFU0Ixdk1kQ2NQYStQZU9EVzdJZXRsNDJxTFh2T3ho?=
 =?utf-8?B?RTJkUWtjd2V6OTRlekFLdGczRE9BbzdXQjVyK3FXK1I1eEZiRlZ3VUgwOHgx?=
 =?utf-8?B?NXc0QS9JZDAycHFPWWFKT0FZd0NEYngrWDF4Q2xDQWZ5M01RNEZIZ0Z2TnYw?=
 =?utf-8?B?ditLQ2kraldaSXZ1c1RjejdLZTRaWjRaQ2tSWHQveXh4UXBhTlB1MEFHNDBZ?=
 =?utf-8?B?cERhUXpHWE9GQVpqeXljcURPZnpkZktmYk5rY0NpNDY5bFhNcGhoMkYxeUFz?=
 =?utf-8?B?RlVVOVptK1ZQbHM5dmdXazNmb2RrR2lkYjBhWVpkZWhscnU2Z2YyWDIxbDUz?=
 =?utf-8?B?RHVLYkRwTVpHbGZYQkVZMDlyMXI1ZDdyb3JsTnpBNzI1aG1RN2w0R3VhU1pD?=
 =?utf-8?B?clBoU2FMejBseFNZZWRLaExNaXZPZG5LL3lNU2pNT0tBVmNmblV3Mmo4bFkx?=
 =?utf-8?B?TXBLTE9LcUFMV2JUVGFkSS9yVGxrQndFUXNKTFJlOGhiYTEzcXlQRndxNW5o?=
 =?utf-8?B?ekxjNms0K0lIdGpTS1c5UnN3Z2U5RXFCbWNTcTg0a2F4S3dQdUh1Q25OTE11?=
 =?utf-8?B?OGJiNDBSUElmS1E1aE1KcHdGaElGSCtRSnc2WjlJN2o3amhzaE1iOUNyZEZ4?=
 =?utf-8?B?YTVNZlEvbEg2bkxqdUd3VmZVRTYxVW0rYVkyeU1aWktyL0RUZ0NIdFRxYTFw?=
 =?utf-8?B?anIyaVRVRHZjc1hqdk1pUWwrU2dqZENiMG92VmRxNTVHbmpLZzRCT3pNMXdx?=
 =?utf-8?B?Qmt5ZlhBS2RoWnpMWXdYS3FtS1ZXbllyYkFvbDdaZ3NKWXRWWkxEZ0VUbUFi?=
 =?utf-8?B?ZEYxejhpcmxidzUxZFN0ckM5dWhubjFsSE11U3F2NHpCeThWWG9lTHdVYmxB?=
 =?utf-8?B?emhRN00yaE9SM3pHR1R3dVpPcmNhNm5Ud1B3enNwa0tPLzZjSXphZTcxeG9S?=
 =?utf-8?B?eGpBdUtmK1M3bmI1R1FrSTZjTVc1L051a1dZSVB0YUppajZRbTE5WEpRYzNk?=
 =?utf-8?B?S2lxeG00NnZDSTZpWDYvbEZrMkFBREpLR2lXelRlWTdqekZ6YTNHUEVsOE1t?=
 =?utf-8?B?Mzd5bXdBVTA0SWkvNlZPTis4THRoM0tUSCt2a2N0NHhmMWlRLzBkVkpOdGty?=
 =?utf-8?B?Um4zNTkrd0F5UnA5bWFSSmtZaWtoeGNmUEx0Y3RERW9yb1haeXR4WlFKZUNC?=
 =?utf-8?B?NHB1N2c1SW4rdjZHVUpDYlFJbDdNbCtzY05uQ1ZWRVRxZGlCVE5tbnllenBR?=
 =?utf-8?B?L05FYXgvMzVTUFgvNXFReThVaDBsSDVmUzdKRXdlMlNDQ2hpa1I2UERRelNq?=
 =?utf-8?B?N2thNFdaTFFvVU1XRVQzdXRqVUw3WDMvWUIranJESDJJajk2dmo5MWhEdXV4?=
 =?utf-8?B?WmFUaEM2SDZna1Y3c1BkUFpkN1NER014cFdPTTZ2aEpuT1ZrZXJNVmN2Wm1J?=
 =?utf-8?B?dDUyZUNRdVgxOUs0cFRIclJoZ2l4U2FiN2NndzJiUVVjR0tPMzVnNDJKaHQy?=
 =?utf-8?B?Zml3MG00UFFMWWhKRWRwbVhuejcvUUN1b1hwNENoODc5dkozL3F5NFhNOW9U?=
 =?utf-8?B?OUxEQXhGWStwb0xTMFBoUkk3SDNQak9WSkwxNkZYRXVNVDVtVEh1dllERm13?=
 =?utf-8?B?MFpmbXN6SFR4NDRqOWh2UTY4VW5Ob2l3ZnQxZjZCRWlNOGpRVC9RdWJubkVI?=
 =?utf-8?B?dVFpeUpxYmtxQzNRdVdDSUFiSjBCNjFROVhydkVEa1labVMvN0VxNFJYdmtX?=
 =?utf-8?B?STJjdkxiZFRGZjdoaG5UNnJhQmRWZVA5TDNtNVdrTEtyQWUwaFFKb05jeE1t?=
 =?utf-8?B?TGlKQXl4K0g4NGZRS0tKQmlUTng3R2lJSFR1VCtrTkNxcmhuV2JDZkdpZlJa?=
 =?utf-8?B?QmZJYk8yVk5YdjljZzMxRG5RaC93R3VjeFl6WXh4TDhmZGtXellJZWJtWnZu?=
 =?utf-8?Q?9cRz15RxrLhbOLzU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 87bd3eb9-23e4-45ba-aa3e-08de78b6de81
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 23:53:14.7728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SvGIee861E4OfdeOQKVqQfSXuvan3I4JqPQ1RU2uGqNvQfxT2ei1/dqJbPgXbNam3nMfJeSqoGYSI5GJ/Oa8KXowzKURUGYMDNWmZi7wUn4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5941
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 67CAA1E6DC8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72445-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:email,dwillia2-mobl4.notmuch:mid];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dan.j.williams@intel.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_GT_50(0.00)[59];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

Jason Gunthorpe wrote:
> On Wed, Feb 25, 2026 at 12:57:01PM -0800, dan.j.williams@intel.com wrote:
> > > (since a device that's trusted to access private memory
> > > isn't necessarily prohibited from still also accessing shared memory as
> > > well), hmmm...
> > 
> > The specification allows it, but Linux DMA mapping core is not yet ready
> > for it. So the expectation to start is that the device loses access to
> > its original shared IOMMU mappings when converted to private operation.
> 
> Yes, the underlying translation changes, but no, it doesn't loose DMA
> access to any shared pages, it just goes through the T=1 IOMMU now.

Yes, what I meant to say is that Linux may need to be prepared for
implementations that do not copy over the shared mappings. At least for
early staging / minimum viable implementation for first merge.

> The T=1 IOMMU will still have them mapped on all three platforms
> AFAIK.

Oh, I thought SEV-TIO had trouble with this, if this is indeed the case,
great, ignore my first comment.

> On TDX/CCA the CPU and IOMMU S2 tables are identical, so of
> course the shared pages are mapped. On AMD there is only one IOMMU so
> the page must also be mapped or non-TDISP is broken.
> 
> When this TDISP awareness is put in the DMA API it needs to be done in
> a way that allows DMA_ATTR_CC_DECRYPTED to keep working for TDISP
> devices.
> 
> This is important because we are expecting these sorts of things to
> work as part of integrating non-TDISP RDMA devices into CC guests. We
> can't loose access to the shared pages that are shared with the
> non-TDISP devices...

Ok, I need to go look at this DMA_ATTR_CC_DECRYPTED proposal...

I have a v2 of a TEE I/O set going out shortly and sounds like it will
need a rethink for this attribute proposal for v3. I think it still helps to
have combo sets at this stage so the whole lifecycle is visible in one
set, but it is nearly at the point of being too big a set to consider in
one sitting.

> > So on ARM where shared addresses are high, it is future work to figure
> > out how an accepted device might also access shared mappings outside the
> > device's dma_mask.
> 
> ARM has a "solution" right now. The location of the high bit is
> controlled by the VMM and the VMM cannot create a CC VM where the IPA
> space exceeds the dma_mask of any assigned device.
> 
> Thus the VMM must limit the total available DRAM to fit within the HW
> restrictions.
> 
> Hopefully TDX can do the same.

TDX does not have the same problem, but the ARM "solution" seems
reasonable for now.

