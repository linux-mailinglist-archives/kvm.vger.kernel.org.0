Return-Path: <kvm+bounces-67194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E6AACFB7D3
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 01:37:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B6918302A12B
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 00:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652D81E376C;
	Wed,  7 Jan 2026 00:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NPyUWG2D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCE94C97;
	Wed,  7 Jan 2026 00:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767746207; cv=fail; b=X+Z5xzxg2xul7SHLFR3YXFdqbLc1/dOd5Hi+iZOJ18fkxhhrq34O/uS3Lh0nq8UjHE7zLLYQDg2W6VzEH4hJxWY0htfHWFIcI/tTEx/3rulwsZmPeG36wD6aDt/F1LWIs6m0pvfluNBdJ2tYsAEIQU6d0m1JMvaJLzIjqO1NYpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767746207; c=relaxed/simple;
	bh=I7+YRNyEgDfVAmw9a0m+xSisK8OhDFtVc5W65eC6xOA=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=ohvX2z+8lo/O43s8PNjhWPW7Ow6t8evhLvnJudig8h76UblgKNJDzCxRv8iYpRUf2CcDjen8cmnAAWE5yLsp2eX7+EmwZuiKcO750sEIqvGHHL3zdxFNyqFAcNiuRSucYk97qz5uYiAM5mURde5z4GpZCCWvNLGccbyIX1mTv/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NPyUWG2D; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767746206; x=1799282206;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=I7+YRNyEgDfVAmw9a0m+xSisK8OhDFtVc5W65eC6xOA=;
  b=NPyUWG2DcJ/X7qHU72HjqHeqgOmgTo9hWiB8JOUbqM7APVJuF2UksKFy
   iZ75Xtg7cZPsD22LZ6e25cMLUazjUQa1+aQyJV719AHXmbguvttrArEyy
   lAn/qZquIMvyxJ+FgJk3+/XkyehvQbdkrl08e3YJiAKsCgUGiuJ3HECtW
   J89cjbdcEvWFvtMo/Am9C6wgQlGSkg1rB8OW0+nDff0imXfj5LBQDyu8S
   PPto+P2JM7doAfHd1+4dchp2dNmHZclWxcdmxyd3w6S8PUxeskTLnbpc6
   OPvbV/SfAiX4Vo2IPmCjadsHhIbcQVSS9/1XlCvc68ArNVCWLlLYSlIbW
   w==;
X-CSE-ConnectionGUID: NrDDqbpPRSern/+f7xmFaw==
X-CSE-MsgGUID: 6xaE2qdWR2uS3bdOir6JZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="69164766"
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="69164766"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 16:36:45 -0800
X-CSE-ConnectionGUID: sgBTcPPoTvKw/uXlpJWUVw==
X-CSE-MsgGUID: yQhZsTzuQ6qbwJTY/BAWlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="207663780"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 16:36:45 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 16:36:44 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 6 Jan 2026 16:36:44 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.24) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 16:36:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rhdcKJ/DSISWoRxEKLqZ03k75b+9X48+Jzfw0zXHfJrVWURLZEM0F+3FruyGxg9SF9JeYr8FBd8PqKJ9ujEH3dibAsl4vuGIh6q3qWPcljPqB//XRBrgqcsx4abpph6T55XulTkWrZdWipJ2nq49JQNy9wrT0sBtRlWB9bVyY7Zv05VN/FAWk7js1ssAEsL2H51eKnC9/dH/Czw7YQsY1yc61MlXq6lkUeGLHjbLRyOrtNoMUlgKMe+WFVr6mJyM91w0ujbcRT8mP5fw3UJqvuqruZEDe8Hjcc+Hy28FUSQiQ0lQZgdK6MtwTaH7zhhYIt8ZXayDvIwgx894tMSJgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I7+YRNyEgDfVAmw9a0m+xSisK8OhDFtVc5W65eC6xOA=;
 b=wsB4SEx2xmVmY1pPGxCdRGzidtEo5MAHOE45w4F+Eee2WQPlqLhV+YllRT0e3UhHSKRfcHAVApCIXEZR/IfJCXU310wtA/9a/mfyeQT6bEiSLavOf1trbD1fMaMHfQsF7UJYvn5Lc2LlnBzGDvvWmTDrJy72yZfng2e4iSIPJMl6N1S0MRobrUATmKevR9JkDgTbI9zP7ZYjPOtMqFksiIlF0SVSyPA0ag9Ho1elk6B+XHhf1pRcZtt6ON8ge2GyAIWvq85jpgKcGQN2AvkVnRdk4oAC1O8V03afXMCUdfswaBMnr31Ty/AyKDrOOK+a1/rP6Ho1RSKGHy8B6Db3Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by LV1PR11MB8818.namprd11.prod.outlook.com (2603:10b6:408:2b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 00:36:40 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 00:36:37 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 6 Jan 2026 16:36:34 -0800
To: Chao Gao <chao.gao@intel.com>, Kiryl Shutsemau <kas@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <vishal.l.verma@intel.com>,
	<kai.huang@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@linux.intel.com>, <vannapurve@google.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Message-ID: <695daa92c40fc_4b7a1002f@dwillia2-mobl4.notmuch>
In-Reply-To: <aVywHbHlcRw2tM/X@intel.com>
References: <20260105074350.98564-1-chao.gao@intel.com>
 <dfb66mcbxqw2a6qjyg74jqp7aucmnkztl224rj3u6znrcr7ukw@yy65kqagdsoh>
 <aVywHbHlcRw2tM/X@intel.com>
Subject: Re: [PATCH v2 0/3] Expose TDX Module version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::11) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|LV1PR11MB8818:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a578173-ed04-41ec-b3e2-08de4d84d0b5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U3Q1VlFUMVNyZCs5MlFrVXhFYWdGMlVzZlJXelNYajhMU1I0TXplNDlSbUdN?=
 =?utf-8?B?UURSMlFSbFA0V040ZmY5Z0lHMUEwOTJzNXVNdVNMeGk2UkVaK2pDVnpVTnY2?=
 =?utf-8?B?Rm5oR0tMNG1SVFVWRERrTlJaWFYyQnhVTFd4Qy9DRWdGeEd0bUgxMmhlMk43?=
 =?utf-8?B?TFVoSHNlMUJSTHhRY2I3MXlvRFloL2xmcnI4NFZJdXFDRkRjTU9HWklJTnJy?=
 =?utf-8?B?RWlhQVlZRkR5ZjlERnNHQ1NPY0o2OUpSTWtwRUJXRXZudWtuREpHdnZNdW11?=
 =?utf-8?B?eWdxUWZjUklBelRvZXN0RGx2VkFZVVpRYk9XeGxqT0FqOTZjUU95ZzZBdE1J?=
 =?utf-8?B?Y0VLSVAvL1JGSUFGMnAzTEs1NGdIY1NzU1ZyZTFUOEcwUi9Ld3gxeFV3Mmt5?=
 =?utf-8?B?S1VtQWtiQnFaSHRjaEhTdGNqejNUZjMxdERqSzBWTHVCNGE2QzNFOFMzTi9s?=
 =?utf-8?B?VTlxTGtpZzFrME1LVmpKT001UldXZWlJNFlZM1R1bFlqOWdYOFdCWjRoZWJs?=
 =?utf-8?B?SlJVbFRRN2F0c3JGNi83K2w0TzlTeGxCNTV0d2FQUE4xbDc5RXp0ZmNxT1Uy?=
 =?utf-8?B?Szg1RkcvQVhWNThNOW9WN1NISnZkaFdVTFNLamRPNENCREc4VWJZa25ZWjlF?=
 =?utf-8?B?NE1TaTB6aFExc3BTdVpnS0V1VGZ4Y25zaFNxdElnc29hNDNOcWhvdjlUeTl0?=
 =?utf-8?B?OTRqTEZEdVBrQkkyMHNNekZRZ3E2QU5RNnBKU3dLaThaREhMbjd0NkRXYzMy?=
 =?utf-8?B?TUVicVl5VVVZUW8zSnNBOUFNUHlNYmNXcXNnd0RhS05JSzhEeTAvOEF4aFIv?=
 =?utf-8?B?RXpiTGtWbUt5RDU1NGhUYWd5SFRTRkFXNGxwL2RsSE5oYkJoaFlsUTBqTEdk?=
 =?utf-8?B?MFJSNjdhWTdhYVU2SFFhOEgxSGFkWEE5YWMyQlFLVG12VVp5K1Q2QU0reTV5?=
 =?utf-8?B?QnNtcDlUcXBza1NHTkdRYmR0MFhTZExUSW1RWGhvOXgyUDd4TWZtQjZmL0dI?=
 =?utf-8?B?dFIvL0RsZFUzekNEbXI5YXhPQVpBcE96UkZueTlVTkc1bjZZcWV6Rk9kWTBE?=
 =?utf-8?B?dlAvMXg3MGR3UndGcm9OQ3ltNmxrTVIwb3JQNUVKQkJTT0xsZ1oxTjdrdkZw?=
 =?utf-8?B?OVBPUWZ1d0JKbHJQWFA2YWFDWjVVNEg3ak5pNktQMWtPV1ppV2swQkhGaWZv?=
 =?utf-8?B?K2JYYnduZldkTjlSODhjT1BoRWpjdDhneFU4L2dHTXJ1Zy9EVDc0TlM3Nklv?=
 =?utf-8?B?ZitKRE5DbU0vNWpoZlhZSDV5T2gwNFFmV29HdWVFQnpsdmVTRko2TzVZWXlL?=
 =?utf-8?B?clFYeXRQOUtldks3c2RGUll0cXh4TUpoSXIxUUxSdTRSS0JMWUkvV0xSWis5?=
 =?utf-8?B?QlBZYW9TY1pVeWlPa3R2V2NmUzgwOVRhUU1QWlZ5azkxM3E3YWsybGdKbTE4?=
 =?utf-8?B?SkE0ck0yZ2tiM0ZGNkI0dElUaTlweWwrS29tNE15dDQyV2xsOHpjekVmM2JD?=
 =?utf-8?B?bXZhTzFsSU9qcGowaWRlMHF2SVc5TmRKVk40aHNNYU5kRVR2YmZUbDdHeUw3?=
 =?utf-8?B?ZUd2M2xZMHJyVUFaZUgvWFZqNng3WEQyeVFrNE4vNW1UUjFZZEhDalpKZnNG?=
 =?utf-8?B?aUdhQ3BrOVpHSU1CaE9OL0l6UVA2WkNobHc0Vm83S25RZjZZVWpVWDlkTVN0?=
 =?utf-8?B?eGxNamZ2OUtjdDZSdWUzbDJlZGJDQklEVVVkdExmYTRYdkYvYVQ4cDg5UVQ2?=
 =?utf-8?B?WnRJejNZNjdaUzRRd0NxSE05MlJ2NUdVOHlXZ3BLQW8zeVRkTnVSZm9pZXJY?=
 =?utf-8?B?cm5VeTgrM2ZXNVFDYTViOWV4OTFZam44YjRUSU90RkU3T1lrbGk3VXROdkNo?=
 =?utf-8?B?SURmaVhITTZLK3FqOUc0SHRzTHdEVWJOYXcvVHorU3FqcnF1NlhveGJlcGtm?=
 =?utf-8?Q?dmfb/nhU+0U6yT4TP6Ug2ljNnr8FThuO?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3JjdFljV0hTaEJZekhJdGJpUUxMMkkybGsyeWVEdGN6MXg0N2lSQ3dFeHl3?=
 =?utf-8?B?ZC82YXRmSC94ZlEzTVdJQWNtWnhHU09LWHJqWHVibjBLVUh3ZHVhTzRhWUxZ?=
 =?utf-8?B?VE1IU2g3ODFWbHQ4S0owaWZ6aGJZOW5xckRUaHFQanRRNVhjOXlSUFRrRHV4?=
 =?utf-8?B?Y3k2bHVRUEtjN1NVdUVhTGFpNldabHplTi9ZMG55WHdveWs5Mnl2VUtDaDF4?=
 =?utf-8?B?NitrMHZkQnNrMFRkWnJLQVhocWJRTlN4b3NQek1MMHF5WGVaakE2Zk9OUUEv?=
 =?utf-8?B?YlpGa3dieVF0YWZYSTRPWmpUaHV0aFp1M3FENm5id1FZMys1WWFlTDBsNy9I?=
 =?utf-8?B?eThXOHVrSkp4Z3JkSk55eW55T2FtYStwR3RYOVdLczZNZHNHVkxpQk5iczAr?=
 =?utf-8?B?NzlUWkp5aDU5KzNrQkRXYzNIZit4aG5Zc3ViSDYzKzZNU1lETjRGVjcvVVM0?=
 =?utf-8?B?M3RQZnhuZUlrVVhlenpBNnBqcHdhN21DcnlBYTJUdVNEMmQwYzkxRmhhL2lz?=
 =?utf-8?B?VWVkR21XMXpOVzNGV1ZVWFJHaVJncnRiZkFaSUkxdk1xOGJOY1pEL2Ivc2Q5?=
 =?utf-8?B?NTZGSkQ5ZVhnajV5UWpqd095Q1lVeU1ML2ljT2FkVE9FM1dtOEdJQkx1UnRV?=
 =?utf-8?B?aE5SbjUwZXo3UkNJc01Najc2RHpIeTBDTEV1dUcwZ0hYYW84a08xQ1V1TDNw?=
 =?utf-8?B?c0NxNWpRQVhFcDNubys2NzN2QXFqQkE1SkVUc21sNnpMRkhtdWMzeE1aQy9z?=
 =?utf-8?B?RTduMDVML0FIbGI3b3ovckNMcDRkcGhKOURrcnh1WDhWLzZ1ZGRWMjA0U2kv?=
 =?utf-8?B?Y3NKWjZMV1YwU3RYZUNQY1MwMi9wczg0L2tnZ2RwdlFuRHdIQUJDSUNXSXhm?=
 =?utf-8?B?SnA4aFArQm9xYkw5amZud2d3YU93aW9VUlQ0YjZyejkyRldZWG9jSUlSTXAr?=
 =?utf-8?B?MlJZSFN0ak0wL1pSaXAxRExndEtVb2psZ2l1OHZlelBKT1kvc0dqR0xoSFBR?=
 =?utf-8?B?UzlNQjlyZk1uZERHdk9VdEF0dEtsMU1vTWN6VS9IcEcrWmVvLzlJZjE4WTFJ?=
 =?utf-8?B?VFV2b1lVaFJtOUxOOFRJNHRCMXdaTldqT0M0SXl5OFVBS1hhMURBTEwrUUtB?=
 =?utf-8?B?aTRiN3U5a1hHczFOcCtleWlGUjRubE54SzNGRTlzcU1hTTYwanFsd3hjdTBh?=
 =?utf-8?B?ODJxK2xkcFpFaGtVRm9oaEtGU28za1dOSU5SY3hra0NqaWdXQU5VRzVld1Fs?=
 =?utf-8?B?U1JiRkhrbjZGSWtnNytjYUJZSW5KNjVhejY4Tm0yYWUrdDdzeE5mQkQ2THlB?=
 =?utf-8?B?N3RoU1FSZVErZ3VWeUxCY28vYzdpVnFLMmFZcVVLdVNpeHpLVjdwUWE5ZTR5?=
 =?utf-8?B?a0JnWnhpeWo5SnBTMVM2ajJBSEtabElNQmUyNm1MZTMxbHBrRmRqY2FsQUsr?=
 =?utf-8?B?emdrYXpjbDRyZWtLb1lneUFHdUx5WkdiQ0o5NFN1a3FrOW54czR6TjlkTk9C?=
 =?utf-8?B?cVE3ZlNEQkpoMkhHelNiUnpIQTZBU3E1WXJsNGtackQrMTdFVEJ4dmVpbkhi?=
 =?utf-8?B?UTU4NUd5TDFVQkN0cTlaWUNuQ0tLenVhYzh3T0hIcU5md0ZqWW41Tm1zTmU5?=
 =?utf-8?B?STFhMmNPNmJpNEJjaFFPWCttbUFTYUNvMDFNTk5MVi9vSGZ3UytnRFVaYlZH?=
 =?utf-8?B?Vm5Bd1lFOXJ3U2lXRnVBK3NZTnpFaUVjSWM2L1JLWG41Wi9DcFJjcXI2WUJv?=
 =?utf-8?B?N09OZDFsOFZTbkNqcXkyeEgxeDdYUk40OW16SG5KaFViNnpDR2xPeGJINTFj?=
 =?utf-8?B?bWRSc2FOTVdHOVovRzdVWlZ0emkvSWNxcnlENXRJZUtIZXl2OVpIZ09TcGYv?=
 =?utf-8?B?YkcvTnRmdXdzMjR1b0FFR29xV0ZpTFpIOGdQOHQrcTZhcWpPeWkxTGc0VWQ3?=
 =?utf-8?B?dm41K2pDaUFzVTJPQ1BEYmx4aWRoc2JTQmhBWmVRaEpzQXoxZ3ptOHVOVFZS?=
 =?utf-8?B?VktQMDdUM2JLeU03OWJZUWlRQUw1d3o3UnhOV05nZW5GYktUdWNRU3NWS2di?=
 =?utf-8?B?bkUzUWRBZW81aTBtRjh1bW1sT0JuRStlMjBoalBrM09hMFdlc25HS1NSdFJW?=
 =?utf-8?B?cks5NTVKYmd3R1ZEMFFKaHB2OVdMcytkWWtKd29zSVNLTW84dFVHcTh3R3RF?=
 =?utf-8?B?OFUvRkF2OENmQmZSR2tBcXA3bHJKbUI3bERHdjBYZmJKZXV3cDhxWHViNXlu?=
 =?utf-8?B?cDMwMko1aDZBelhBNy9GZHJwa0g2bHZkcnNOTW9XdHlGSnBKcCt0RXVZUEpz?=
 =?utf-8?B?eWJDeExtY3AwQ1IrbElYMksrMGNoZWxmSWtXd0JPZTI4UFFyRC9MaUhSaXZJ?=
 =?utf-8?Q?bMTPcuHZ9N+W6bnk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a578173-ed04-41ec-b3e2-08de4d84d0b5
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 00:36:37.1129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L6+U4Q7Oc5o03E0PJDG0+KFYuFZedktNs30Fn3a/mdmD6ZR1wGY7OBMn09JUwbjNM0vauFNMpCWTKOS77Lk4y/DYLt9qFFrXgi6SxEdhnNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR11MB8818
X-OriginatorOrg: intel.com

Chao Gao wrote:
[..]
> And in my opinion, exposing version information to guests is also unnecessary
> since the module version can already be read from the host with this series.
> In debugging scenarios, I'm not sure why the TDX module would be so special
> that guests should know its version but not other host information, such as
> host kernel version, microcode version, etc. None of these are exposed to guest
> kernel (not to mention guest userspace).

Agree, and note that the guest already has full launch attestation
details available via the common
Documentation/ABI/testing/configfs-tsm-report transport.

I assume the primary need for version information is debug, but if you
are debugging a guest problem might as well get the entire launch
attestation with the version of "all the things" included.

