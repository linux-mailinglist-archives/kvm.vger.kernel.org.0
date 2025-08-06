Return-Path: <kvm+bounces-54084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B99AB1C0B2
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 08:53:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6B0804E0388
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 06:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE09C213E6A;
	Wed,  6 Aug 2025 06:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U3fxoUJH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9548E3FC7;
	Wed,  6 Aug 2025 06:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754463213; cv=fail; b=FT99JLTyMI7lheRMxto58/XNiRLJUOAfXfvUY0Z0XDdCyWtwpm+VYmTvvbYs3ktWQgzWD8USTRLJmw8f55iQ5lvSUWqBeTjpbrzenOdFmTDkLkbOb3u3FngF8PxTzlwuoiaBTgbdjwj9jK2kWV9nYZPO/iDa2DEsQ4cjFYRby5s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754463213; c=relaxed/simple;
	bh=vqh6/nmLffQL0Cidq/7pu+uSMtLcE8DqVv/GEbelsic=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R16YVvuHKzlOGgowbiJG9sg4WsrPWv2GrdHlKC3emGOTdfAm+XuTeUMUaYEuNoftb5dABnvtxqfqt5KZxXhE8vLM81GZ3VDFJn3DUibZZA1OjJIL69ntQbMfqtt0Z7D9Ukf6vquw39fSfa4JuSa2uWN5jhRJKLZ+0Ielk4WQx6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U3fxoUJH; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754463211; x=1785999211;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vqh6/nmLffQL0Cidq/7pu+uSMtLcE8DqVv/GEbelsic=;
  b=U3fxoUJHKnDRiLa/easKXZhHToMjOnSW8J1793icYbhQOxEMnQr49zmI
   ntSjJzUm7/9Q0LZsLXt3UP1RY+OhoX964PR/hXK1YbO+VU0J/UVcTeKsE
   HA1mTtC9euhq9AaP2x8G6CCsRMVnmoymOGowdf/WzCdI+FRxuHT6V/a0k
   Fr0vzNb5oH22fbXlIQN/sVRJlkzfoFmj28z0UjSkr2qiIvVMMxvjrW7HL
   XVY/HmyqM7iPbw/xMg6CS4JI4nWgxuIoOyES1OoBu37Sy16wfesr+HUPF
   zQXSzMTUUYjTjhPxRMv8CJJv8MZAxqUX+R68HohM/SYmNtWpK3HQGk1RK
   A==;
X-CSE-ConnectionGUID: uUEC+vqBQiGXeNXGx5cTaw==
X-CSE-MsgGUID: 7EAQCU8KQZqniTI3wsVTpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="56637830"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="56637830"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 23:53:29 -0700
X-CSE-ConnectionGUID: 1aux/4VZSVqCInOf/XRKQQ==
X-CSE-MsgGUID: IsxhFJ+zQpaMdg4k71hTtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="165460523"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 23:53:29 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 5 Aug 2025 23:53:28 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 5 Aug 2025 23:53:28 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.78) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 5 Aug 2025 23:53:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xy5/6jAVvyEV1tnqweaLjR/VPIzjGW3xn2AtOZAaGrSLtYGaBXM4mmJxVHv3z7oPuRcwJKW2frGQOce9jDGX4nH6XEZ8ngpjoQo/Rdk6eUwzHYyNCWLJTYWvyCmxRxfb2w1k6zP+WjdjD5vWGP5S7jGjN4BP6M0IFo45Gun9xjl9uUrJzKolDIWAaqgNvKnVk0BJ8nBevSnlrkZvFwkxzF+2Yjy9exFW3OK4sq+Tim2TDVozngFRXPJ4Da9jguKSYTRMyN3I7mSfwC2SGJa5QfGVFIXK8i206I6HiJRYgLfX2Png2rSRrWWJX07RUgGR3DcSH1mVplWmaG0pkqz8qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vqh6/nmLffQL0Cidq/7pu+uSMtLcE8DqVv/GEbelsic=;
 b=IXDA6EII0R1DTQLaZWkQKS/zgLdNQXttwkVp9I6pDBUSY6tDCNpTyGV796o5Fymc7zzrO61IIw9MCpVf8QfInbTKnJxWRNKRLA+JpBdpKO4ozNlbadYTyEa2lNqYwyFdPYx7gb+gPVCSN4quifZoUI1ZoWQuQ1O0zUZlIH6WYI6f3W4ruaJ9m1LPFGJJ3uH9ur9k5Pp7C9MMr66NTmkr7utRWjy8p31RON8OBNbKLciKlF77xv93q/HwWaM4Ii5x4vAIzYmlqn3pNjRbd1T6nZdezFM+Td8dAvTSuhSeRfyocJVET0Cv1mjh/oX8QZ+iTA9xHNx8KYVYE4InMZhJZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CO1PR11MB4772.namprd11.prod.outlook.com (2603:10b6:303:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Wed, 6 Aug
 2025 06:53:25 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8989.017; Wed, 6 Aug 2025
 06:53:25 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "tglx@linutronix.de" <tglx@linutronix.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "mingo@redhat.com" <mingo@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
CC: "ashish.kalra@amd.com" <ashish.kalra@amd.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>, "Gao,
 Chao" <chao.gao@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Williams, Dan
 J" <dan.j.williams@intel.com>, "sagis@google.com" <sagis@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>
Subject: Re: [PATCH v5 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Topic: [PATCH v5 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Index: AQHb/7MPM7l1KGi+i0Oo+RI0T45w3rRVPjSA
Date: Wed, 6 Aug 2025 06:53:25 +0000
Message-ID: <d3c5417d5aaf0b02fb67d834f457f21529296615.camel@intel.com>
References: <cover.1753679792.git.kai.huang@intel.com>
	 <48b3b8dc2ece4095d29f21a439664c0302f3c979.1753679792.git.kai.huang@intel.com>
In-Reply-To: <48b3b8dc2ece4095d29f21a439664c0302f3c979.1753679792.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CO1PR11MB4772:EE_
x-ms-office365-filtering-correlation-id: 9effa7d1-da68-49e0-9aa1-08ddd4b5f12a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?M2lLejNxd3dQWFB4Q3pGeHFTM0hEdkp3STE2ZW9OOGk1RlJBSldzTnNjTE9Y?=
 =?utf-8?B?NElaS2Y3YWJmRTVYdnlXbFVWbXFLK0M5NFNEalcxcEZNTUY4a2w5VGNycUR3?=
 =?utf-8?B?cXU3VTJPQVhmNVU5Y0kydHdxYWh3cytwaEJnYzdKVVE0TFllS2M3MS9mK1Ni?=
 =?utf-8?B?WWpnNUJ1R2R0eGlkeUp3cHZNN1VLQ3BmaWdGUTlSRUdUZ0oxdk4zQXhRRWVH?=
 =?utf-8?B?VGdTejJHMjJ3NXNMclJ0aDNYQXU3NmdmTXJNaVhTY0NSU0pPTlZGMUZtTmtN?=
 =?utf-8?B?b05paDhza0xZc3BsUTJoazBSbnQrOUJKVXZkMVlMRm9nUC93aGFlbzJDSzdD?=
 =?utf-8?B?c0lEaDFobWtGT09zV3Rlc3VEVEJJZVJYdDhtYU5JcGVhdG1GdFMwNHBnekJR?=
 =?utf-8?B?YVN3T3dUWU91K1RqR0ljaHEyR0JoOTQrQUU1WU1nSEZZTG0xNHZRNjVtalV2?=
 =?utf-8?B?WGNmdnRxUTZTcm5iZjJWK1ZPYVRMZGMwQUEzWFVPajgvM0NnVDZxZFdwckFt?=
 =?utf-8?B?R3UvQzM0SHZ5MmszcDN3Z09FSlZ5TGhnUS9tSWhhWnJNZE4rSVp0dldKZmJY?=
 =?utf-8?B?cCttU2V1dHdTTlRvclRTWVZ3WWpualMzRDl6Wk5YeFZzR2ljakQ4RXR3MTda?=
 =?utf-8?B?bXFpR3UwSE9NN1pIakQ0Vzc0a2RISlhNeitIODlPOHVhK3loZmZaaUlVMVp0?=
 =?utf-8?B?ejNoOU5FUFdNOVdxZUN6NjFqM0tGSXpXWC94N2h5aWRhbFdCWUczbmdBVFlx?=
 =?utf-8?B?Z3ZSVmt5ei8wYk5rV21hTFhidGw0Wk8xOW5YVVMyZ3h2YUlWMHlNR2JJa3JZ?=
 =?utf-8?B?MDJyYWFFVDIxT3dhZC8vdjhNeU1oc2huNFRPMVhkaytJTjdZcWV2RXJHZURE?=
 =?utf-8?B?dGcrMkFoZ3haYmhCOHRiYUp6Tm9aUGpvdCsrRXBHSXZHdzJxTGUxVGFKa0NL?=
 =?utf-8?B?bWZ0VXJGeDFjK3BFNlhvTzZsUStXNm04L3B0cU9yc29KaDg1aWRwMUxWQ2l0?=
 =?utf-8?B?UGNPbHQwSDB6MVFzZUk3MWN6OEg1RnRzbkdDUFMvYlpUdm4yU3Bhb1Z0ZlZE?=
 =?utf-8?B?UWF2UUlvK3k0VCtDaE9sSkRWbCtuM29zdlpHOG1sM1NLVnJpNEJtSyt3Zklr?=
 =?utf-8?B?cTFOUVRYVWFVNWZESnFnaHMxRmJ4dFNnMytQUUJRMUFQZzFyRHdIY3NVTmNI?=
 =?utf-8?B?Uzc4ZWVpMXlOcEJaYjRNYzFwRWUrS3RVLzNMTHNMMlBnVTkyakdxWjRmb2tU?=
 =?utf-8?B?NlFDNGtTdkpuSWgrTm9XWjltUUFjUmhla2twWVJwSGE2cTYzR0lad3JvaWVk?=
 =?utf-8?B?S3dINENYOUtNVXJlVlkyM3ZEUitkWU5ZNU04RGhHOW5SQmhsajdUZS9iTkhw?=
 =?utf-8?B?L2k5ZSt5bEN5SlYzZWtRaXlsTGgydVprc2VjZkE5WmVDRkpzYzZIRlI1N3hD?=
 =?utf-8?B?dyt6THBEZHdDTVU5cEN5Q09Kd3B0SjR1WVN3anh5akZoNjBnbFZOejQ1bm1j?=
 =?utf-8?B?TWNEZ24wUmNOdmVSOExaYjVCT1Uvc25sODFJaUVjaUdkUFYvS3JHWmt1Tm5t?=
 =?utf-8?B?RlpFd3VkUm5rcHFKYnhaOS85VldmY1Bjdzlkb0p0V0tQdFMyUlpCZzQvWit6?=
 =?utf-8?B?ODhBOFBpc1VBV0pwblQySHFGeDRaN1pEcVh0SGs3R3oxSU03Wnh5bk9WaHJ0?=
 =?utf-8?B?ZEVqdVkzelZSd0Rsbkx1bjZTVFNNQlNST09KN013c2YySHJhbDFUZFB3OExT?=
 =?utf-8?B?WjlWM3NENFA5V0dkNy9HajMwSzdvNDZNcDJYUXN4RmpjYkN1V0pHZkVLc3gr?=
 =?utf-8?B?R21FQlR1SFRCSUMxblFkZFBZSzFBWEFOdTNlcnh3VG9GS2hGamhScy9FdmE1?=
 =?utf-8?B?dEJ1MCtTNHp3VVk4SE0zTi9HakFJazV4VXVCcDJhWXNBZzBpaVFWaVAvM0p5?=
 =?utf-8?B?SllWMzhOM0M2R3A0V2FTNSsxazZ0UUF6c3dsN2ZiMjZadDB2NGdtOXpTTHJa?=
 =?utf-8?B?Z2NHdHY4Z2xnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2Nldk56aTFnaEs0RTc0WkV6bzBUWWVjVnhYOHNSMmdZU25odlkyMEFvWkFY?=
 =?utf-8?B?UTkzNy93Mm9uTkxKUG5xMzFlZCs5eEJQdkVTUzR5VnBaWFRUVWhrYm5CYUht?=
 =?utf-8?B?anVGcjJRV09OcFU2U1NvU2tSQVE1dWVOaFRiVXBLdEVXbGQ3WDYyQ3RVUURP?=
 =?utf-8?B?bUxpOHlxblpoMlh2RHZMUWFSVTBidjlISkFJZGY2K3ZUQkFBT0N0Y1h1RGFV?=
 =?utf-8?B?bXVOcVJFT2hnYjZOdExVaWVaMTZ0Y3I5NTFtWVdIQ1h6SVp3QVYxWWgrR0Zo?=
 =?utf-8?B?VjNSWHhDWUlxSHoxS2FzMnFnOHV2ampCeUpmSmNsbUN1Vk0wSWFqZ2hqTEZY?=
 =?utf-8?B?aVBycFdtMUYxZ25WajNqT0xlZGNUTU14SVJBMGFEZVp2K2NKMnJvTGI2Nytm?=
 =?utf-8?B?N3JBVDdwQkF4d0tSdE9OODdFTVhBN04xSmZlRkg5cWExaGpTL0p5Q3RSbml1?=
 =?utf-8?B?elFQZWN0V1RwK0hmblBXdGlhWWtDQ2s5WlBDQ3JuQzByYUEyWXZLRENqclF1?=
 =?utf-8?B?dm1jdmZRU0IzcjluR09oV2lZK0J1S1p0Ty9YUVNpRXkwRnZqdFdIcUlQcnFu?=
 =?utf-8?B?ekExazZ2OHJ1TTRLR0huTmRtaW5wMmlZdU8xVUlQMXdEK08xT2FycUlTb3Q1?=
 =?utf-8?B?R08rS2Q2OWk4aTdZMG05YktCUVlFYnVZVFhaWUQ0ejNON2lNRzRMcXNHMjlD?=
 =?utf-8?B?VE5JMjl1NVFuNG02L1dMdVdRaFIzdzZxZGV1RmVlQ3EyTW5QS0g5bnFqZU9l?=
 =?utf-8?B?Q0tqMmNOYUVKQmhFZ1BWTmwvS2lXdlZwVnlZM3Q1Ni9PMnp0R1ZHRFRYYzFr?=
 =?utf-8?B?Tm9qMEVZcWVkZGlRVmgzTnBSTVkxV0p5djNscmNsVHJXbUxOYzRLaUhxenZJ?=
 =?utf-8?B?ZGF3UGpxSXpTT0JrdjFUTU9RZitaZ1JicHlZWVJQajQ2dllxY0hXV1F3S3Fl?=
 =?utf-8?B?S3VpMUdVVy9iZkJnWXU0Z3Vvdy9wbzZReE51bExyYlZJQVoweFlCQVBpK3U1?=
 =?utf-8?B?UW1MZEd4bHcxcVJhM0FVY3lyK3NtbVdZWUhxVzhZdXUwZkRoMXQ2bFFvSlVU?=
 =?utf-8?B?WFBuT3RuVzg1bVdQamRvbUZ0QTAzRlBhbjRjYkdPbFlodXlLTFVOcXBFQjQ0?=
 =?utf-8?B?NGR2ZlRPUEZBNXNOdTVOcTNCME9ObWZJeWlzb256M1ZBWEdBSXcrZmMvTEh3?=
 =?utf-8?B?cWJaV0J0VDh2NUljbjBBTFN1NlBwUVlvTDZnOExBWklqNjY0RWN3bFVDTWRI?=
 =?utf-8?B?aTdrS2w2YlNHK0JoZWh3U0J4R05iWXBYZGxwcW03cGdveUZzYWtoRlFYbkY0?=
 =?utf-8?B?K2JPc3hqODRHUkx6QUVNU3RhR0dxUWtMZy9ndkdnYm5idmQxQVowWHdYM1Z1?=
 =?utf-8?B?MW9ZODUwU202dExRNUhZOER5MVpLNkpGVVhWb0krSWNXdEV2a3ZQUlBxUVhq?=
 =?utf-8?B?KzJVKzF1REZ0L1lJYVJSQUZHQXNRQ0RDc2xFVDdud0ZsdlNZRWFVTkFQZjQ2?=
 =?utf-8?B?VzF4RUplZmVIV250cHg2NVZHeG9nUjgzYnlmTmQ1QnFJL3lobm1MbEh3UkdV?=
 =?utf-8?B?UGttbkZyclNveUVRc1cxVWhVdS9odGxvcnJhL0hjL0twemg2M1FsTFREejRw?=
 =?utf-8?B?WFpyY2NWaTI3V0hWbkhMSkZWMDU1NExVRmlTMEhocHlLbWp4d2l5UVFqR3Nn?=
 =?utf-8?B?UStYOFpZWk9WUlp2WkZ3a1l6SHhuUktwdHh1ejdTOThpV3M5bm5uUlVWeGZJ?=
 =?utf-8?B?N0VxbGU5YWo2YkJ1ZDFmTEtRMGFtU2dyNTBUMEdJQUlndUtVREhzOWRBNTB4?=
 =?utf-8?B?QUo5MDZwTDdCN05LanpmQWVURlF6ck9QZnJjVmhlQTFMNmpoYkwrVkpLZnNn?=
 =?utf-8?B?Vldod1d3RCtEbzR3b0VQYXpkb1pNNDFrbm1WcmIrc2FoV0p4UjdqREUrUFd3?=
 =?utf-8?B?VTRZdHdqMXo3eTRyckpkNzVJY0N2bS80cTdiS2hNbVpsQk9GWHpZeG5sMFMy?=
 =?utf-8?B?TjBabEVmWWxSaTgyMHBnaXE0SkRFcHhZSWVTbGU0ZFZGVUNkdWRLSmlpQlg2?=
 =?utf-8?B?K1dNYWZSbWtiaVlLUnZxQkQwRDdmZ1ozMkZjZDBwNEZ3RDJBLzFLVXN1ZUh5?=
 =?utf-8?Q?RbVR9sMAJE190gu/iM3cFl57G?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFF326133BFF0A43879FFFF19A1C80EC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9effa7d1-da68-49e0-9aa1-08ddd4b5f12a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2025 06:53:25.6656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HEtr57rEaSKgvxIOkLA38gAj0gr4U6JzrT+9xJsAIbVIua23DtUqZrWJerpWcfHAh1eARpObnPRni3WlPdWMPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4772
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTI5IGF0IDAwOjI4ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IER1
cmluZyBrZXhlYywgdGhlIGtlcm5lbCBqdW1wcyB0byB0aGUgbmV3IGtlcm5lbCBpbiByZWxvY2F0
ZV9rZXJuZWwoKSwNCj4gd2hpY2ggaXMgaW1wbGVtZW50ZWQgaW4gYXNzZW1ibHkgYW5kIGJvdGgg
MzItYml0IGFuZCA2NC1iaXQgaGF2ZSB0aGVpcg0KPiBvd24gdmVyc2lvbi4NCj4gDQo+IEN1cnJl
bnRseSwgZm9yIGJvdGggMzItYml0IGFuZCA2NC1iaXQsIHRoZSBsYXN0IHR3byBwYXJhbWV0ZXJz
IG9mIHRoZQ0KPiByZWxvY2F0ZV9rZXJuZWwoKSBhcmUgYm90aCAndW5zaWduZWQgaW50JyBidXQg
YWN0dWFsbHkgdGhleSBvbmx5IGNvbnZleQ0KPiBhIGJvb2xlYW4sIGkuZS4sIG9uZSBiaXQgaW5m
b3JtYXRpb24uICBUaGUgJ3Vuc2lnbmVkIGludCcgaGFzIGVub3VnaA0KPiBzcGFjZSB0byBjYXJy
eSB0d28gYml0cyBpbmZvcm1hdGlvbiB0aGVyZWZvcmUgdGhlcmUncyBubyBuZWVkIHRvIHBhc3MN
Cj4gdGhlIHR3byBib29sZWFucyBpbiB0d28gc2VwYXJhdGUgJ3Vuc2lnbmVkIGludCcuDQo+IA0K
PiBDb25zb2xpZGF0ZSB0aGUgbGFzdCB0d28gZnVuY3Rpb24gcGFyYW1ldGVycyBvZiByZWxvY2F0
ZV9rZXJuZWwoKSBpbnRvIGENCj4gc2luZ2xlICd1bnNpZ25lZCBpbnQnIGFuZCBwYXNzIGZsYWdz
IGluc3RlYWQuDQo+IA0KPiBPbmx5IGNvbnNvbGlkYXRlIHRoZSA2NC1iaXQgdmVyc2lvbiBhbGJl
aXQgdGhlIHNpbWlsYXIgb3B0aW1pemF0aW9uIGNhbg0KPiBiZSBkb25lIGZvciB0aGUgMzItYml0
IHZlcnNpb24gdG9vLiAgRG9uJ3QgYm90aGVyIGNoYW5naW5nIHRoZSAzMi1iaXQNCj4gdmVyc2lv
biB3aGlsZSBpdCBpcyB3b3JraW5nIChzaW5jZSBhc3NlbWJseSBjb2RlIGNoYW5nZSBpcyByZXF1
aXJlZCkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5j
b20+DQo+IC0tLQ0KPiANCj4gIHY0IC0+IHY1Og0KPiAgIC0gUkVMT0NfS0VSTkVMX0hPU1RfTUVN
X0FDVElWRSAtPiBSRUxPQ19LRVJORUxfSE9TVF9NRU1fRU5DX0FDVElWRQ0KPiAgICAgKFRvbSkN
Cj4gICAtIEFkZCBhIGNvbW1lbnQgdG8gZXhwbGFpbiBvbmx5IFJFTE9DX0tFUk5FTF9QUkVTRVJW
RV9DT05URVhUIGlzDQo+ICAgICByZXN0b3JlZCBhZnRlciBqdW1waW5nIGJhY2sgZnJvbSBwZWVy
IGtlcm5lbCBmb3IgcHJlc2VydmVkX2NvbnRleHQNCj4gICAgIGtleGVjIChwb2ludGVkIG91dCBi
eSBUb20pLg0KPiAgIC0gVXNlIHRlc3RiIGluc3RlYWQgb2YgdGVzdHEgd2hlbiBjb21wYXJpbmcg
dGhlIGZsYWcgd2l0aCBSMTEgdG8gc2F2ZQ0KPiAgICAgMyBieXRlcyAoSHBhKS4NCj4gDQo+IA0K
DQpIaSBUb20sDQoNCldvbmRlcmluZyBkbyB5b3UgaGF2ZSBtb3JlIGNvbW1lbnRzPyAgVGhhbmtz
Lg0K

