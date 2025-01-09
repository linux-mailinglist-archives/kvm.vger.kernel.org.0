Return-Path: <kvm+bounces-34864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A5654A06D9E
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 06:35:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41743188A4E7
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 05:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C59EC21421B;
	Thu,  9 Jan 2025 05:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bE5gGgk1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3C533C9
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 05:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736400896; cv=fail; b=H96kIS5F0KScTdlSsBkBzWERIMeJbuUHv11PeWmGLZg5ZG4W8xavWf47MOt+5f/eb4qBRrPstgu4aOthwPqAlMaAIwgI0hydLxl53lDwA2JjWy8euuFeQwxQnhHDMT7KfV0NrJfr1A95hLe4hzN4U2tlM51fPkurmrrOSgSaJT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736400896; c=relaxed/simple;
	bh=QGhP52wDPn2VTbQTHAf4sYBei9RIGvg+H9ghy4y68bY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BoSDE7iGD+b94jLI4oon+VPv0PmgoXdakEA6pNFnLGDrOMTFUSHeahKIVC4F2rTDE6ZKuCJCuvrXPxxqxU0xIEoexqUKUVNFsij6ITyXTFv3pG00MuzbGKam1YPFu39KxPo4kLZ+2BYaD4rBUv0QbfVklYZjp5BbMzspGV+4mJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bE5gGgk1; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736400895; x=1767936895;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QGhP52wDPn2VTbQTHAf4sYBei9RIGvg+H9ghy4y68bY=;
  b=bE5gGgk1cbkK92v1Lq8iLhPKTrGDGckv7a2MEZD5f/MNUGQKIqcAYlBj
   fJnF3vo+zuP7Yzw6IzHHrWKJjh0kyvNjgoO8HoJyKnLsIpGYhwGRMUmoz
   iGAN4sXapVWbvMh9yjtGyONOrBaT0GmZJ67F3C9ySzaailxQ+FqmqCm+m
   TAgJzGR43pEm78z1v/lB4A+XTdOmU9ImpFfvb4PBO0SJG1wMTRgYBfx+B
   g4OWNjOgKOoJaWS6CQT5ogwtVhkRSrIhJfDaNMEV1DFFvK34Ha69Pm1Mu
   BKz3edwVbBy8r+bZPU1PzdXSGj6Wg+Mubq+L7YGtmGh+mkRAdGhXebbsw
   g==;
X-CSE-ConnectionGUID: oEB+JLahSBeCNNfVg4XoHg==
X-CSE-MsgGUID: yrGh/P8HSGek6PtzzWQb8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="47314088"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="47314088"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 21:34:54 -0800
X-CSE-ConnectionGUID: +4u8D417Ti2zMKgnyFaj1A==
X-CSE-MsgGUID: w/ndsXdxQf+fwXZI0ySfig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="107347363"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Jan 2025 21:34:53 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 8 Jan 2025 21:34:52 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 8 Jan 2025 21:34:52 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 8 Jan 2025 21:34:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c8uNJ1xbZvXpTwWcxw59fIuRgR+I1LH/FWzAmwC2axLlmwuuS8RVpkjGjJ5g5IR65z0boc6J57Q9t6FQu/dkUHghy1ZMsAamJEsUJNFccp7nieLcW6Fy6tXlBYzzGaudRBBEHXsRpjQykVahhGlEjJZ+eolLGqz1cLgDmSGrvpRs8/Kt1wezjPakSOm38X+CKnbXGM0S58JujFQ0DZWtPHC3uJ5re4vOm0ccljWhLyczEnnWHdnH4vBeKai2jALvMDZxspTTXkVNA69T42Vsz18ku8pUNyWDZ7236MrLA/ACg8SVpZxKZLzdTUIWgsT58gmjjtjYreoJKQ9NbQ+ELQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iy86oUWo7KDFU5c6weYJ0HzCw++J5Ib5hFgfFURnK0g=;
 b=xhPHZLNpGYZSWkGfPwmNRGdV+uGUR7uDoqGXiaAENMZGZofIGZOYYei+cB/jccaUMPVr3O9DjbUp1DN3brG1Efk1UPHwRJUkg+4M4AqcFGskZEtMNN4NGLERr+BQsdMCz2BUJOal4hIZiIh3H4EP48fqgRV/LXhUugksE9H3/R2NVeZcycb1Z8e9yprqbx1Sg39il3EIoQfcmtn6XpL+0VutGS1ERqoJP7shQ3D+WHxGgypPyczVbA6RvRtHmiLL4Rc9vLXdpKvo1faPCDXj5Fa6PjFwx4c6Vr0OoZsZoyQ1hSxcswjqGWysAEpyNBWhmuwm5mxYNMXGQBoRj/PNnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SA3PR11MB7609.namprd11.prod.outlook.com (2603:10b6:806:319::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Thu, 9 Jan
 2025 05:34:51 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.8314.018; Thu, 9 Jan 2025
 05:34:51 +0000
Message-ID: <5c999e10-772b-4ece-9eed-4d082712b570@intel.com>
Date: Thu, 9 Jan 2025 13:34:42 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] memory: Register the RamDiscardManager instance upon
 guest_memfd creation
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-6-chenyi.qiang@intel.com>
 <2582a187-fa16-427b-a925-2ac564848a69@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <2582a187-fa16-427b-a925-2ac564848a69@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0017.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::19) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SA3PR11MB7609:EE_
X-MS-Office365-Filtering-Correlation-Id: d90fac2d-bfd6-4025-7a8c-08dd306f5677
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b1hWOGU5bTc5UGlHMHNZcGVyMmlVU3gvZmNXWEpibGEvZDk2YXBxWThEYkVU?=
 =?utf-8?B?T2dwNzZkNDRXbE9MeGdUUjdRdEZrWlN3dTFkRzRvNURRS3FwMDFoMUZmdDZn?=
 =?utf-8?B?dGFtWGZuTFdvSzZSZmM4MXE4YmwzWGZCOWp4ZlR5V0pHMnZVQnN5Y05ldC8z?=
 =?utf-8?B?RjZ2bDRjdytwLzU0SWtqWXgvUWtPUDVociszWXFlRk9xVGJyQ3ZRa0hsSWhm?=
 =?utf-8?B?QjhQWlpPdURFTEVhMU9qVzJHRjc0MWxkVThSdEVTU21ISzM3UldSVUF1Ri9v?=
 =?utf-8?B?Y1dnY21tN0F1NXFhNGtHNE9BUGVPZGJyTmord3ZBcUorTm5odUhvYUsrTUVw?=
 =?utf-8?B?djB2QWZDNXBhMjU3YzVQejhSanVHSk5jZ3RiR3hkbDlFN3VQaVZjeE5IYmdo?=
 =?utf-8?B?MkIrdUMxVlRwK1U2dlZkTnN6SUpNQy9OdmFCZGZDczBZc3ZXdzkwMjE2clpp?=
 =?utf-8?B?Q1NTakpaUHc2MG9PMDN5YjloOGlNdjdVWmNiWTRPcFdjQ3MySXVWWEJSOVI5?=
 =?utf-8?B?bmQ4RE5QWTlWTG94Vng4Mk1QNTJveWpIL2R5RlpNb1JtT0VrcURKYU9yNU1m?=
 =?utf-8?B?M3FuRlBkZmE4MkMzcHN5bGZXN21uSjlESE8xelNQaiszWlJhMXdsZjByWGR0?=
 =?utf-8?B?RFRHempCZUlKMzlQK3dGRzNzNlg4MFRrejFYNUxhSHd5dFBPTkVya1A2VktS?=
 =?utf-8?B?MUM5cGdVR1JvdHdZVkVsRGpPU0RsRmJnZng1R1U3c0tFRUY0dnpTWnpUSGlj?=
 =?utf-8?B?QzNLU01hdG03NXMvTFdUSHZvQThpdG9Ja0FkWlZRS1hYMTlVZ3JURWp2YTg2?=
 =?utf-8?B?V3k3cFM0LzJwQ0tYQ1NmclJvcXpRQ1FqbjdTY1EzVDdWbUUxUklwWFNRYU81?=
 =?utf-8?B?MGNMdU80Ym9PVHM5RXJPeGtzNXg0N0tFcUxEYTZQdE9SdkxOUmdDcjhwTEp1?=
 =?utf-8?B?TkYyMis4UFRuNTZoRzBMSlc0c0E1eXhLTTRuNDd3c1l4WDN4TVQvZlFOa2tF?=
 =?utf-8?B?bkkxd0svV3lKZzRwRW9zNDFEYWpuZG1hdmdYMzF6am5GM0wwNC9LSVdLRi9t?=
 =?utf-8?B?Y28xbmw5SFFBTkl1cVpncDVLdStLRGZuVFFKcFNqWGdLNklMRE12ajFmcEpO?=
 =?utf-8?B?OWxZbVpBbXZpTkkrbWc1cFNsYzUxYit6RkNRRytvcDNBb2NlcWIyaENQeER6?=
 =?utf-8?B?L0lVRW1OTGV6SWd0TlJjNUxPODluRUJBQ1U0cW14ZjVMcU5YamcxQXhQRUNw?=
 =?utf-8?B?aFV6RGl0SUNuc1JDdXJzWjNqdFB4MGpGNE1QelpHUXdTMXlYVHpPYWNKOWhv?=
 =?utf-8?B?MHZ4c3pQUlZ1VWtHMzlSdGlSamxEMktzSWFPZXZvSTUzdy9tbTJvZzFtY3hk?=
 =?utf-8?B?TktUaXBuSFBXQkhPL2NrdXYxQU1rZVAyanBUSWlDNjNoZkhnQXJBdXlBVUV0?=
 =?utf-8?B?ZzFsL3o4NjdTeXFsbjJOUytLWlVUbCtjWVBPN3M2a2x4ajVKSVlBNWZPNVZV?=
 =?utf-8?B?eFlCYTZuZEZjVVc1RkNreEVsQVVtMTAxNkprdis0MTU0ZXkvd04yWXpOZkVw?=
 =?utf-8?B?RVExRjh4a2NrY01WU04xanNJb0R0aEJCZmhTcThudmc4Z0lkcld4R3RHY1p3?=
 =?utf-8?B?L3J1OGVPKzI3T25nRVpaUVFrY29wNVNwYVdxOTM2NUVhODlQMG01dVUyeDQv?=
 =?utf-8?B?c2lBNmU2dGkzYzVJK05DMEFpMVJ2R0Y1TjM1am1jSG5ObWNZcFRnaGprMHRC?=
 =?utf-8?B?WFB3OE54TVVxbllxMmxRQXdaZ0gvcGV3aE1id3N1WFJKN0l0ZFRBRld5NzZ2?=
 =?utf-8?B?NktCYStJOXhwaitka3k3SEFSbXBVYmhYbDM1elZWWkt3UVlwNlBHc21ZT0pF?=
 =?utf-8?Q?0RBVHmf7RiEBf?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUs5bFh3ZmFjODgzTmx5ZndOakpqQzBVMW84TDg1MUlUaENPdVNzMlMyQUhG?=
 =?utf-8?B?bVJUUlFLRWRnNWdtZnhLTVNhdGwwWVJjNENBeHBscjVucDdHYURwZlFLL0w3?=
 =?utf-8?B?MkpqTEM2MDVKYWdoSS9vYkNZNDlOM3cvdERwOU9yZE5xT1B1c1liU0RzM3Bl?=
 =?utf-8?B?Wk5vNVVYMzhISEtuaUFzVnFpVkxUWjdwTWw5ZVlpQ1VmN2ZUWVVyRFFhRndH?=
 =?utf-8?B?TlhDV3Y3YjVLdVI2NmJnQmN5WHRvcHpONXdzd3BnMnRJVlNZNGxsSlpwVWR4?=
 =?utf-8?B?V2ZRamhwNGJ5M1l6djg4Vy9nMnYzYmtXL2lzRlQ5OWxTaUtUVnRCMFhrbzVa?=
 =?utf-8?B?UzZNZmxIRTlGWFVSQzZEUTNyQ1diVk9odmtRemV3OGdpaUtnajNPd2JvQk5m?=
 =?utf-8?B?cy8zaDZoRmNYbzZ5U2I0ZTNIeVhrRmhKdHNKcUJTWFNKSFJvejZLQzBLOUFH?=
 =?utf-8?B?VklQQnI3MWRmN01KM3lWNGxZQ0lpdzU4SGVpb2lUbjIrRHJMS1VuQWpxYTRQ?=
 =?utf-8?B?Q3ZvbmN4dUZ2QURoYzJnYlRzRDR5UGVONzNVWDhwbE5Qb2MvanQrR2d5SDho?=
 =?utf-8?B?SXB4Ym5YYlEwMU95YWFWU0N3YzVtWlQ4Mzc3cThzU2U4enlpcUFWemNxTHRo?=
 =?utf-8?B?ZlJFUUFmT2ZocVRRL1REejNHcS85VDdnM0pySEJ1QmJRNmRlOGljdHdieEkx?=
 =?utf-8?B?dWRGQ3FxcXRNeXV4bHdIdmZWdDBEdDQzc2xWelBMMGhoU3ZwL2paQTUySTU0?=
 =?utf-8?B?by9nSy9XSDhCSGVaZW5UUXd5UUxZUXg5Z0gyR04ySlNWWU10aGR4ZkV6dXcv?=
 =?utf-8?B?VXNsSlQ4OTJoZEpnNkVnUU1TSVlGRWVFQ1NoeTRkM2dnVG1kRXY4S0JlL3lN?=
 =?utf-8?B?eDdjQzg2eVNXOGtROGtNaXpBNmZVZCtBK3FzRi9SV0tBTGVzM3prcmdWS0ZS?=
 =?utf-8?B?UjMvb2RWeEdSdTNmY3ZHaWRWTkFTam1ZcVBaMFo4T0xJa3FuZ0lCaGdoVTNo?=
 =?utf-8?B?V0tucHdRUW1qcGpHWTZkOEpmcnBqS2NSSjFKZ3RQTmI0eUZMYkt5WjI1TUJt?=
 =?utf-8?B?Zjk2YmNXR2QrMGQrSEwxVUtHSmZYNjVzZ1lnQXZEYXk5bU8xOVhnSXZ4Y3M4?=
 =?utf-8?B?ZmIzOWxMM3ptbVZDMUt2WkZDRjRzbk5MNHFhQXFoME96OU8wbWZjNllHeVRD?=
 =?utf-8?B?MThPbmNuak90dS9yR2hFdThsRGdCMG9pdEJGUnZpelEvQjN4NEpuUVcvbDZk?=
 =?utf-8?B?aC9lR2pPZkRVMEFBYTBTRmZtM1FWUE1zSHVUbGJpUjYxNnNRa1ZVOElpcFhP?=
 =?utf-8?B?a2wzWCtUMWVHd0lKblBjU2kxNnB2cEpOOGs5aTJvOEk2cGdxOTBHSC9kOE81?=
 =?utf-8?B?RHY3Q01sc09RdFB4eHRLcW9Ya3YxQ2ZncHBobFRDM2liQUkzWm1SY0c2ODNO?=
 =?utf-8?B?ODd0c3RWL3k0NFBKR1d0WjZTSnJyWDRhcU1IM05EUGFYUEE5MjNqRW5NWXZk?=
 =?utf-8?B?QzhQSzZaRm9jUU1kclB5SU5PeUllWGNiWGxZRmFPcjZabjJPRWJVQjdkalFU?=
 =?utf-8?B?YVV3V2t2OHlnU28rY05QeXFwR0YwdDN3U1ZDbnFPcXpvSHNENmhUczY4akJJ?=
 =?utf-8?B?K0NPdG9INTUxcFVMelFYVmticXF0bzh1WDRzd0QrazkxNkUrSzRFTGpkVGdS?=
 =?utf-8?B?Q0pOOU5yc2xzZk81bElzZWNCWXJrY3l4cW04OVFNVU5XNjZINlg0Qksra0Jy?=
 =?utf-8?B?VDIxWmJOL3hnSDZib1hSckc4ZlFiZVBjQjl2SjlCWmM3alZ5S3l4NXJDRHRR?=
 =?utf-8?B?U3Q1YnVITWx4Wk0rR2Q5bWhvbGh2eEZJdGdwMU5rbk5vMm1TeHhlQXdranFW?=
 =?utf-8?B?RU52SENRTEp2MzZ1d1hDUjZVZzdsU1lVSXBQODg1TVFBdW9GR0ZjQXNCS05i?=
 =?utf-8?B?WVo0WTRaQ1JiemovLzFuYW9pRWkvelBQTjBMbzlvK2JvQVFvNEN3TU5ZbUox?=
 =?utf-8?B?NEVJcXN4bHp2d0tKR3ZhOE5PN0dvSlNqUjNteitKSTViLyt0MUVZTnRiS09q?=
 =?utf-8?B?cVQ4NmtRQjRoSmE0bW1TQjFoSTdVT252Qm83SVBoK1c2WXl5QUJ3djYrMGVw?=
 =?utf-8?B?VEhncVhpYWRMczdPRUg1NGloS2lEa3hvdjBNQ3ArMmlJSVExQlY1amNMbFRh?=
 =?utf-8?B?ZlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d90fac2d-bfd6-4025-7a8c-08dd306f5677
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 05:34:50.9857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /VjpPWN9969KOy6fotdidPEhkbcB1ChorJF4JZab4gumENjtb8g6ZFcmhZ2yNnrWhq3GkP7rPWwjVWqhz+NB5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7609
X-OriginatorOrg: intel.com



On 1/8/2025 12:47 PM, Alexey Kardashevskiy wrote:
> On 13/12/24 18:08, Chenyi Qiang wrote:
>> Introduce the realize()/unrealize() callbacks to initialize/uninitialize
>> the new guest_memfd_manager object and register/unregister it in the
>> target MemoryRegion.
>>
>> Guest_memfd was initially set to shared until the commit bd3bcf6962
>> ("kvm/memory: Make memory type private by default if it has guest memfd
>> backend"). To align with this change, the default state in
>> guest_memfd_manager is set to private. (The bitmap is cleared to 0).
>> Additionally, setting the default to private can also reduce the
>> overhead of mapping shared pages into IOMMU by VFIO during the bootup
>> stage.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>>   include/sysemu/guest-memfd-manager.h | 27 +++++++++++++++++++++++++++
>>   system/guest-memfd-manager.c         | 28 +++++++++++++++++++++++++++-
>>   system/physmem.c                     |  7 +++++++
>>   3 files changed, 61 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/
>> guest-memfd-manager.h
>> index 9dc4e0346d..d1e7f698e8 100644
>> --- a/include/sysemu/guest-memfd-manager.h
>> +++ b/include/sysemu/guest-memfd-manager.h
>> @@ -42,6 +42,8 @@ struct GuestMemfdManager {
>>   struct GuestMemfdManagerClass {
>>       ObjectClass parent_class;
>>   +    void (*realize)(GuestMemfdManager *gmm, MemoryRegion *mr,
>> uint64_t region_size);
>> +    void (*unrealize)(GuestMemfdManager *gmm);
>>       int (*state_change)(GuestMemfdManager *gmm, uint64_t offset,
>> uint64_t size,
>>                           bool shared_to_private);
>>   };
>> @@ -61,4 +63,29 @@ static inline int
>> guest_memfd_manager_state_change(GuestMemfdManager *gmm, uint6
>>       return 0;
>>   }
>>   +static inline void guest_memfd_manager_realize(GuestMemfdManager *gmm,
>> +                                              MemoryRegion *mr,
>> uint64_t region_size)
>> +{
>> +    GuestMemfdManagerClass *klass;
>> +
>> +    g_assert(gmm);
>> +    klass = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
>> +
>> +    if (klass->realize) {
>> +        klass->realize(gmm, mr, region_size);
> 
> Ditch realize() hook and call guest_memfd_manager_realizefn() directly?
> Not clear why these new hooks are needed.

> 
>> +    }
>> +}
>> +
>> +static inline void guest_memfd_manager_unrealize(GuestMemfdManager *gmm)
>> +{
>> +    GuestMemfdManagerClass *klass;
>> +
>> +    g_assert(gmm);
>> +    klass = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
>> +
>> +    if (klass->unrealize) {
>> +        klass->unrealize(gmm);
>> +    }
>> +}
> 
> guest_memfd_manager_unrealizefn()?

Agree. Adding these wrappers seem unnecessary.

> 
> 
>> +
>>   #endif
>> diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-manager.c
>> index 6601df5f3f..b6a32f0bfb 100644
>> --- a/system/guest-memfd-manager.c
>> +++ b/system/guest-memfd-manager.c
>> @@ -366,6 +366,31 @@ static int
>> guest_memfd_state_change(GuestMemfdManager *gmm, uint64_t offset,
>>       return ret;
>>   }
>>   +static void guest_memfd_manager_realizefn(GuestMemfdManager *gmm,
>> MemoryRegion *mr,
>> +                                          uint64_t region_size)
>> +{
>> +    uint64_t bitmap_size;
>> +
>> +    gmm->block_size = qemu_real_host_page_size();
>> +    bitmap_size = ROUND_UP(region_size, gmm->block_size) / gmm-
>> >block_size;
> 
> imho unaligned region_size should be an assert.

There's no guarantee the region_size of the MemoryRegion is PAGE_SIZE
aligned. So the ROUND_UP() is more appropriate.

> 
>> +
>> +    gmm->mr = mr;
>> +    gmm->bitmap_size = bitmap_size;
>> +    gmm->bitmap = bitmap_new(bitmap_size);
>> +
>> +    memory_region_set_ram_discard_manager(gmm->mr,
>> RAM_DISCARD_MANAGER(gmm));
>> +}
> 
> This belongs to 2/7.
> 
>> +
>> +static void guest_memfd_manager_unrealizefn(GuestMemfdManager *gmm)
>> +{
>> +    memory_region_set_ram_discard_manager(gmm->mr, NULL);
>> +
>> +    g_free(gmm->bitmap);
>> +    gmm->bitmap = NULL;
>> +    gmm->bitmap_size = 0;
>> +    gmm->mr = NULL;
> 
> @gmm is being destroyed here, why bother zeroing?

OK, will remove it.

> 
>> +}
>> +
> 
> This function belongs to 2/7.

Will move both realizefn() and unrealizefn().

> 
>>   static void guest_memfd_manager_init(Object *obj)
>>   {
>>       GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
>> @@ -375,7 +400,6 @@ static void guest_memfd_manager_init(Object *obj)
>>     static void guest_memfd_manager_finalize(Object *obj)
>>   {
>> -    g_free(GUEST_MEMFD_MANAGER(obj)->bitmap);
>>   }
>>     static void guest_memfd_manager_class_init(ObjectClass *oc, void
>> *data)
>> @@ -384,6 +408,8 @@ static void
>> guest_memfd_manager_class_init(ObjectClass *oc, void *data)
>>       RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>>         gmmc->state_change = guest_memfd_state_change;
>> +    gmmc->realize = guest_memfd_manager_realizefn;
>> +    gmmc->unrealize = guest_memfd_manager_unrealizefn;
>>         rdmc->get_min_granularity = guest_memfd_rdm_get_min_granularity;
>>       rdmc->register_listener = guest_memfd_rdm_register_listener;
>> diff --git a/system/physmem.c b/system/physmem.c
>> index dc1db3a384..532182a6dd 100644
>> --- a/system/physmem.c
>> +++ b/system/physmem.c
>> @@ -53,6 +53,7 @@
>>   #include "sysemu/hostmem.h"
>>   #include "sysemu/hw_accel.h"
>>   #include "sysemu/xen-mapcache.h"
>> +#include "sysemu/guest-memfd-manager.h"
>>   #include "trace.h"
>>     #ifdef CONFIG_FALLOCATE_PUNCH_HOLE
>> @@ -1885,6 +1886,9 @@ static void ram_block_add(RAMBlock *new_block,
>> Error **errp)
>>               qemu_mutex_unlock_ramlist();
>>               goto out_free;
>>           }
>> +
>> +        GuestMemfdManager *gmm =
>> GUEST_MEMFD_MANAGER(object_new(TYPE_GUEST_MEMFD_MANAGER));
>> +        guest_memfd_manager_realize(gmm, new_block->mr, new_block-
>> >mr->size);
> 
> Wow. Quite invasive.

Yeah... It creates a manager object no matter whether the user wants to
use shared passthru or not. We assume some fields like private/shared
bitmap may also be helpful in other scenario for future usage, and if no
passthru device, the listener would just return, so it is acceptable.

> 
>>       }
>>         ram_size = (new_block->offset + new_block->max_length) >>
>> TARGET_PAGE_BITS;
>> @@ -2139,6 +2143,9 @@ static void reclaim_ramblock(RAMBlock *block)
>>         if (block->guest_memfd >= 0) {
>>           close(block->guest_memfd);
>> +        GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(block->mr->rdm);
>> +        guest_memfd_manager_unrealize(gmm);
>> +        object_unref(OBJECT(gmm));
> 
> Likely don't matter but I'd do the cleanup before close() or do block-
>>guest_memfd=-1 before the cleanup. Thanks,
> 
> 
>>           ram_block_discard_require(false);
>>       }
>>   
> 


