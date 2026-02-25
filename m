Return-Path: <kvm+bounces-71797-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SC+BFhyYnmnXWQQAu9opvQ
	(envelope-from <kvm+bounces-71797-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 07:35:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B9F0719266A
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 07:35:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 770BC305F4D5
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4496A2C08AB;
	Wed, 25 Feb 2026 06:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fX5DBgqr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1282C029D;
	Wed, 25 Feb 2026 06:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772001245; cv=fail; b=LdFCXvbaM82nW6ASVxkGUPy1Wh5vRuLFs10ztUQa2LSB/eCn4PgtjA4zJml+LaC1fYUEf2OBURVJWcUaIgt2XM6aJKIbI+aKAIYQTowrWTVPKT70a6Ck53n1Hxe+vf7zfYIMo00DpiuIywCPvS6Dd5FnmUPGE2zO997Hj9RObQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772001245; c=relaxed/simple;
	bh=59xdTgg/eG0KpfZswkihOpxyVDsSHylsPBbfn+sr/SI=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=sMlOwAw4y+FeX+/eev0j6DqLFxKD3uQbpLHET2klguZRKa4TWbDpzz9ZccUMWSBpTBN+/pi9xmXzdFFLxlsMXMlzuaZknbMoVPjPflqLjR1WEB+vgzmAdjLLaurJR/yLlVA/GUkUnldRN/BSus2s20hw8KAWnGqGC29QmQncxEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fX5DBgqr; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772001245; x=1803537245;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=59xdTgg/eG0KpfZswkihOpxyVDsSHylsPBbfn+sr/SI=;
  b=fX5DBgqrywtdssWrUJnMF921s8mdPW2mgpq46TJ1vNDpTdr8AEqst2Dh
   z3hNOLd3ydAw2M40bG2ilbe7batKOi5+JvJbo6CFSsFO3D6ujnvzarj8c
   DcrHlwmF9iavY1vqNazME1lRpDc2m9JnDpz4gmOzaDig8STlo72uFeKDN
   ykXJ5iQLwLIbdgsXqUWp3yY2WjspE7wSkF8yesAqkXi+3qW3NKUL2fD4d
   q+wAK2Bb78Aei45Vn12StKzQfIU4e66sCt0jZAEJ/+RHA8SQahHUd4Cp8
   iDM9gtVWoZKz9el+d8G5n34meAI0slcb8AmkrX6gF3QNFFBdWC3OaWSKF
   Q==;
X-CSE-ConnectionGUID: jOSB3LlPR7qabmes0nHLZQ==
X-CSE-MsgGUID: oF0o+lz0RKWFIb2Xz6H7Tg==
X-IronPort-AV: E=McAfee;i="6800,10657,11711"; a="95646986"
X-IronPort-AV: E=Sophos;i="6.21,310,1763452800"; 
   d="scan'208";a="95646986"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 22:34:04 -0800
X-CSE-ConnectionGUID: 1n3CEozTQkiFbwF5siRYiw==
X-CSE-MsgGUID: UNblV44KRGaMpxrIYUIS3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,310,1763452800"; 
   d="scan'208";a="213862897"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 22:34:03 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 22:34:02 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 24 Feb 2026 22:34:02 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.1) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 22:34:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vSP3/J84MYxeUHP1k0KNzyOWlo70AmxdalGHZC4av6wJbt7b6AtzO0OavOYyatWd23PZYQTQK/CknDHzeG86fKb9anvbZCz5UMvmtOwB5XqroBMAb8JN1EHFmGmmamq6jfVG9uElJKVEAUIAjwos/KRC4IPa55qWA/eFIBBjSOjRtSAox2vGhU6J177iylD9JeErAwCkeG9zIzspd9MShOmYF2UdHL7uD92InINbU0k/bwOcx7B38nF94rn20LpmKuki9+xPab8KreR9rSACOW9p6jrxlHaE0oJKraLXuBnMJ6Zlhm4BDQz7Xz7US/FZkrU711NwhpBKgUULXeo49A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k9nVs8oQlv/h3M9gGGOmK4wlNugTp/KD5GMFI4OzTLY=;
 b=eYNmizxyJvx2YBL/F0c5UNc8IdDjERy3orRV7OmAeqyihQDZztntrsyk5OkavYUEEJZOdjMYnGQ2J4SbaNBY2Qin9a0zpRSkkrBUu+SHQeVULKdvXB+pb8j/QLbr5Fq20bpAkOd3t1lB+AFH6qHVHm+NcrcXTba5zHaiuljO3u4ty3BJt1YUyxD+flbU8AsAsCZjt9Ca/RY8ECDNBjviU0KIZxVBoUa67kg9VhmcXLYku8ZY+KW7ZT5jkm8JCXar8L/2ogK63soWiG11S2rHThPD2iD5qQNmgh/i0jyFKa+jnb9KvDO+iQOL+XtYd++A8HanCP5rMXMQag1ww/JgsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB9477.namprd11.prod.outlook.com (2603:10b6:8:290::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 06:34:01 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%5]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 06:34:00 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 24 Feb 2026 22:33:58 -0800
To: Alexey Kardashevskiy <aik@amd.com>, <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Andy Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"Bjorn Helgaas" <bhelgaas@google.com>, Dan Williams
	<dan.j.williams@intel.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>, "Mike Rapoport" <rppt@kernel.org>, Tom
 Lendacky <thomas.lendacky@amd.com>, "Ard Biesheuvel" <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>, Stefano Garzarella <sgarzare@redhat.com>, Melody Wang
	<huibo.wang@amd.com>, Seongman Lee <augustus92@kaist.ac.kr>, Joerg Roedel
	<joerg.roedel@amd.com>, "Nikunj A Dadhania" <nikunj@amd.com>, Michael Roth
	<michael.roth@amd.com>, "Suravee Suthikulpanit"
	<suravee.suthikulpanit@amd.com>, Andi Kleen <ak@linux.intel.com>, Kuppuswamy
 Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, Tony Luck
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
	<linux-coco@lists.linux.dev>, <iommu@lists.linux.dev>, Alexey Kardashevskiy
	<aik@amd.com>
Message-ID: <699e97d6e8be7_1cc51003c@dwillia2-mobl4.notmuch>
In-Reply-To: <20260225053806.3311234-3-aik@amd.com>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-3-aik@amd.com>
Subject: Re: [PATCH kernel 2/9] pci/tsm: Add tsm_tdi_status
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0079.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::20) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB9477:EE_
X-MS-Office365-Filtering-Correlation-Id: f3ac4276-0b49-445c-1d38-08de7437dcb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SWNEak9OTXlydEFsLytjLzFvVHJhbFpZSWR1ZDhUR3RpbmExME1XN3B6SjNy?=
 =?utf-8?B?NjlGa2JFRDV2dEdReVhrQkJPWU91eGJIZG9oakdWUWthQUVTWUZPUFViZUhn?=
 =?utf-8?B?elRUb2lVUVhpVit4NWdCU2JMSkgxVkpnZDVTTDRoeUJydEJGL1dHdktoMWhF?=
 =?utf-8?B?dnpCRFVjbUR3VzBibmJrY1lVTDlaVGZ1bmphWjF1L0MyZWRJY21WZ2JYSXdy?=
 =?utf-8?B?RzIvM0Y4ZjNNelRKc0RSWlNtbEhIVnpKaHl3QXRyaGVJWmg5cGovK2d6R2Jv?=
 =?utf-8?B?WExaa01HOTBZbSsxWThva1BldDZiKzgvY2RRMGR6R25OelNZc3U5cTR6eWNz?=
 =?utf-8?B?dmYvQWdnUTVlUzlrb21KRGp4N2FKRUVMUlEwMjh3YWdEQjJJR1ZuWkxsbkow?=
 =?utf-8?B?NVZUR3FqQmxzZngwZUFiUGJMRjE1Tmo5NFYyeFRibnFQZFAzK2RaQ0NrMVFv?=
 =?utf-8?B?Y0RoL1lsN3F2VFMrTjVhdk9UMVVJQkFsanRZUlFkc2x6YnduZENTKzFtWUhk?=
 =?utf-8?B?bkxwNHR0K3hxdXZMNzgyN2VEUTEvcE1GVUQrazJQZFZJNklwK2RDbEFueGsv?=
 =?utf-8?B?T1pTRHdRM25WdFByRDFMcUx3S0NDdDB6OVZxWUdHWjlVc1d3VXVmc3ZSelVh?=
 =?utf-8?B?MDh3cnlCbzdDM2h6T2hWZWJIQjdRSitMN0pDaGY3UTZBdTJZY2JYVmtHVGJl?=
 =?utf-8?B?NEMrSVJmaENqMzBwSUxmdTNHbDBmcjZNQnNUZzArN2FQZWttZFZ0VmYxdHRB?=
 =?utf-8?B?YzhZMy9Za3BMbFg5VTYzSDN6a2NJbk9qbnJxUnk4ekxHYnJMQmUwL0huSEVo?=
 =?utf-8?B?MzMxa3R4T2pDdFlHUEwwMTNoRTZDMHJ4Zkc5MUhqOWlSUFZUQkpzdHk2c0xa?=
 =?utf-8?B?ZVdkcjV3Z1hMQiszSXlmN2tRS2JDNGR5cnUxVmFRcGk1UTUvUkhXaEtDaGRr?=
 =?utf-8?B?dlJoSGpuSUdOT3hmMTlFcHd5ZVFhVWkwSENUNjZONGx1djJveTVwejVpTkFF?=
 =?utf-8?B?dzBoMk1NNVdDL0JsYWpBKzlzaWVkWHFTMUZmS3hHeDBOQW9mdmJiYjlIeUZm?=
 =?utf-8?B?YmNTeDdvbk40dGE3T2NWbmtnWTlVNWk3cWZha1V0VXJEYmNyL0ptTElSdldo?=
 =?utf-8?B?RlJMeW4wMnRqODhrMVJJVDh6cUo1bUVsMlVmWk14Tm81SC9NRmcvcTNoUXkv?=
 =?utf-8?B?ZWZEQ2JvTmhCQ2RpUGpPRC91UmZTQXBjWkE2ZldSVGtNTEljUTU5SFNXUDlk?=
 =?utf-8?B?NE1mN05NcmR0RTdvQlBEZ284QTdWdUdzdEJPZVM3YlR3MHByRHAxUnVza1VR?=
 =?utf-8?B?NVVoZWxPMjZSdTZydkR3Zm1aUWhOdUNydE16cHZVakx3Mkp3dE1OQzM4TkpE?=
 =?utf-8?B?a1ZnVWt6NlpPQkNVUnpDa2c5cTFOM0lveGZidG9Ld3dzNlg0SVN3VmJ3Z0Zz?=
 =?utf-8?B?VU9sMlZOWmZRaUdxY0NINGdMWjFYV1k5dHdFYlRFWW44NmUwZHJYN21mSE5m?=
 =?utf-8?B?S1draHdia0hRWlB6cjdTUjg3QXhlTk56R1M3am5ZMzFZZW00T3VPeHlybEtQ?=
 =?utf-8?B?aFRLVWpYOUNUNE0vRHFRa1hqUVdCNmt5eFdBQnlYdUVxQzJveS9GdkcyZXk4?=
 =?utf-8?B?R2tnd2xNZGlpOU9iUGI4a2tmejJuL2RRcTdNZDNNRFRhYVRUVFZHaks3MndR?=
 =?utf-8?B?czR3eTZSTkdWU1czUjJDa2NYR1F2bFJQYUEyemt6ajBLMTJXWWFUNTNSL3NU?=
 =?utf-8?B?K3ZKOUlkVVNHOHo1R0dUbnpzbmRlNlF0dkVJbTRiWnRPaHVmS0ZEL0k3amN5?=
 =?utf-8?B?SE1YeVBaYVpSR0I5b3JITGtHOXpzWmdJU0JOdWZuTFRHZ1FqQVFyVmlnd3lU?=
 =?utf-8?B?cVgrS2dkb09ia3R3UXIrbWxKdVd0TUhQcUVmY2dsT1lxYjlhVjlicnBHMWFG?=
 =?utf-8?B?TTY3SmtBRk5lbGZ4Z3V4TUU4ZGhtTCtvMk91ZEVpOTJIWVhBRWZqdXVjVlZu?=
 =?utf-8?B?S1RQb1l4MjI0b2hCa1lxb2ZUV0hoNVg2YnhOM3VyMGMrcUdPVFN0SkliMlRO?=
 =?utf-8?B?VkFheEZacytEUU5tRU9GVkp5KzJvR1huVEExU1N4a0VYTUhFVmNjeGlPeWJi?=
 =?utf-8?Q?DRNM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVozTnhNRDdQbVk1TWl6L3ZLN2hOVTFwbVZZQkJVK0NwTFFpVjVTOVpMSWx6?=
 =?utf-8?B?aHZhY2lvWU9MM1lCSkVjbmxZaWlvdFpGdmRodTBScjB0YjdpbUhobUUvTzNm?=
 =?utf-8?B?bkRkeWYvd083b2kycm5sVklJN0FTd0V5T1hQZjhBWHVkWWxOdHBJK01SUEQv?=
 =?utf-8?B?djJZWU0zU1lLU2laM2NTcEc4L2t4WTdMeng3OWVuWWpzQVhLWWE2UzhoT0g0?=
 =?utf-8?B?SExlbXpGRm1TTDNUaVlLaTF6YW9tejg1ZHJMNWNSa0NEOUc2UDBjK3lYb3lB?=
 =?utf-8?B?SWlMSG13NGF3M3NaQ2RZaFdEQTZQeGxYUVNZY1VkbGxPSUJ2R1ArazFzd1VQ?=
 =?utf-8?B?NlRkUlROelYrbUtWSmpjRzhXSGlobHhYZTFTeUphak1KaFZ4cDR1T1ErY2NN?=
 =?utf-8?B?Q083LzYxZ0FVbmxXbWNDbXlIQk96Uk5sNjlCK0NTdmJaMzVVSi9pb1Vwd0gy?=
 =?utf-8?B?UEtWTlgzRmVpZlkwR0p3UGtTZTlMdEtuakJXdVkvWXBwMEhpeU8wcG5pNmNq?=
 =?utf-8?B?dXphRXluSEZWSWEvVW1VVUVUV3FmazNUb0MyZUY4VGF0aWN4UFJMb3dRSjlm?=
 =?utf-8?B?UDVVVnhkWXlSV3Bld1VlSHZiNVVqd2hjRXZtd285MHA5SmwvSklpQXJzTE51?=
 =?utf-8?B?SERTNmZrNmplWDcwcFdiY0dZNGV2T01yRlBqRDlFQ1l0ckpuWVdxbjFPYzBk?=
 =?utf-8?B?cS9OdHRPMnRqekdTV0hKNHlacnFXRzkzb2RUMFlkOHYrU2ZRNUdtYXJiTmk5?=
 =?utf-8?B?c0ZFZWh6TzVyTlJ3eFBLQTZJZnhTMHhXbnN1NUcvSnlvckYrZ2FodHo0bkZw?=
 =?utf-8?B?VDFZczNKMnVXN2xmbmhHczllVmxZWFZpVXM1dGVzSTl0czFXQndEVUluaU9W?=
 =?utf-8?B?RmFFeEczYno4bEZWdXBaSjNYMHdPYmdQZTRLdkx6VjF3U1IzN2huUnVjV3pJ?=
 =?utf-8?B?dnlnaWh5Nk8ralFGeDA3bTk2MXJZNFY3REo1cjNYSEt3TGJTNnRNMWJMb3Fw?=
 =?utf-8?B?alJ1Mk96bnN3d2IyREY5WTJjS3N4ZTZJUHIreHRyYUhwb0NVQkR5eGE1R25p?=
 =?utf-8?B?QmhuM0FUR2toZTFxbTVrd0VXcTRQaDluTmJzL0xEd3NtNW5uOGJidUE3T0Jn?=
 =?utf-8?B?anBkUXFJa0thZWJOY3hTd3NpOFhZdWE2YTEvT2ZNRnFHMEt5RHRvTnEwZzZF?=
 =?utf-8?B?TmROWkVmZ0pMNnU1d1d3M3E1N2I3K05iU3hFSWsvVVN4dS9nV3dWblViMmV0?=
 =?utf-8?B?VHVSSmhWOUFrMldzNHZUOFVlVzNVWUFnaTh1eWRkbjI0bVBCbWlDNUFpT0Rk?=
 =?utf-8?B?VS9wSEx6RHB3b0xEUjR1blBrR2xWOG9QbGt0bGlkcEJrbzNhVzB4elpWWG5q?=
 =?utf-8?B?dWI4R1ZtWm5HeTcwWENJRWNSaHpRNUJTU2RBQVhROFl2cUhySEpCWTAwcVMr?=
 =?utf-8?B?bDJIVUZLZWsxcWk5QzZWL3RKd3ZiZUFwTi9zSjBwSEo1ZmJud2ZJdFk3RVNo?=
 =?utf-8?B?bjlxekpPV0luNkdob3p1NmYyU3c5Rzl5YnRNT0R4ZHZFZzZHa0laUGZpMXFl?=
 =?utf-8?B?YnM0d3JxK0lVVWpnNWNreER3NmkxVnZSMlB0RDNock5DeXdhVUdBUDBzWDY5?=
 =?utf-8?B?b0x3SUE0TStLYXA3a0R4NkZxcXUwQWp0NXdLdG51dXlhdkFNTHI5TWtHNldn?=
 =?utf-8?B?Y0wvS3pucHAzL21ESk0zL0pzMi8wTk1ZdkJuZGEwbkFrZGNZR3lrcTg3Q216?=
 =?utf-8?B?MjM1OVdkV3JvVEU5bzFpRHBmbXNZaVc0TGljQmV3Z3lKakZ4Q2dTYWMyOGhW?=
 =?utf-8?B?NTgyK1ViU3MyNUdkSFBZakN3ZkExbk9JNXlwb3JlRlNQVXMyVHNNWE9Pdk5o?=
 =?utf-8?B?bHRKZFdScHhaemxPSkw2ZE5FL3Y3dkdXNlhiUVN6clhoMkVIRm1HWktDaVhi?=
 =?utf-8?B?aUlqcHdCVkxjdGdMKzRobzEyRC91VDdHTnM5UnZSODJEWUFBUktPVGdTdmJS?=
 =?utf-8?B?YzVZbzB4T0RGb3RzRlNoM3hjSTlJYllqUDY4MGo4cm55Z2pyR1V1MDk2R0FY?=
 =?utf-8?B?eEk4Ym9NdjJhUkppakFxMmp4VkZYMG5mMVlkTnAwZGdMMGROemdxbFpTUVVY?=
 =?utf-8?B?ak9BSVNmWlpHQzJhTzFzOUNhMHVHVTZCdW03LzdqOWxEOThKcVV4QkUwN3hx?=
 =?utf-8?B?WkYvdDhlS2REeDNjLzZQeStlYmEvMUV6eW9UZFZLcFoxdlV0OGUyaFF0ak1t?=
 =?utf-8?B?ZWZ1d2JtRDRNU3Y1UWs4bDQ0Mk1obmVGbVZIQW9MZ29BaVR3Mmtyckc2Y2dY?=
 =?utf-8?B?bW84bFFiOTk3alB3K1dzVXdjeU04cUpPM3NhYTFLZ0FzU2FxRGY3RWt2NkF0?=
 =?utf-8?Q?0Vc7bjADwL3djHEY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f3ac4276-0b49-445c-1d38-08de7437dcb0
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 06:34:00.8947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F+sWmcRc0+MWalM66uik7wEtDnOdpeBEXus9GMA6XRKwbxixFKXLdk0Ef61i3h6ys0cyhto66SLieUx/CJManYFKqYy6MnpuqGPS2gfS6Ww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB9477
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71797-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,dwillia2-mobl4.notmuch:mid,amd.com:email,intel.com:dkim];
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
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: B9F0719266A
X-Rspamd-Action: no action

Alexey Kardashevskiy wrote:
> Define a structure with all info about a TDI such as TDISP status,
> bind state, used START_INTERFACE options and the report digest.
> 
> This will be extended and shared to the userspace.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
> 
> Make it uapi? We might want a sysfs node per a field so probably not.
> For now its only user is AMD SEV TIO with a plan to expose this struct
> as a whole via sysfs.

Say more about what this uapi when sysfs already has lock+accept
indications?

Or are you just talking about exporting the TDISP report as a binary
blob?

I think the kernel probably wants a generic abstraction for asserting
that the tsm layer believes the report remains valid between fetch and
run. In other words I am not sure arch features like intf_report_counter
ever show up anywhere in uapi outside of debugfs.

