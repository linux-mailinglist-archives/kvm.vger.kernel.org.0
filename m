Return-Path: <kvm+bounces-68496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B5E39D3A5E7
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 11:53:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 22D73305B6FB
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 10:52:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D5B33587C9;
	Mon, 19 Jan 2026 10:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eX6FOZEw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CAB2DB796;
	Mon, 19 Jan 2026 10:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768819974; cv=fail; b=NnT16K8pRAkBZa+d9LAVHA574EsKu/Tw1VADUNcSdVSU1sFyPFyPidVejK4k6d0QI2Yy1WVvItXNlORHSpyVpCoIhIQnV4zK0oIZTLvlZRicJYhzn+l18jKzzUWIuLba12rSplYlyvC5bUYTAVKR1lWmdLRcrMrnMXoJ9ztkWeg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768819974; c=relaxed/simple;
	bh=AgNIhBupoa6bZTD4KvodZmAu5i7BHLZFvcJdjkRQC+c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S1oxXxeUN4dMB/Lt1iz2U5vFGvlIAVx2aWgxi/rPCj+LUTEyJgJSi899GjaqeVyNBpjHMhaAq3rQMhVGELVuTa3OqsaSB1z8ec64kiV6EMsHamXhPgphHhk1zoFZA8lTkc6mxQ5fexlKI0mpXeijhpHyE2cx2TwlI8qv9STHhCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eX6FOZEw; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768819972; x=1800355972;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AgNIhBupoa6bZTD4KvodZmAu5i7BHLZFvcJdjkRQC+c=;
  b=eX6FOZEwh9U29ViMq8Ts8+2+etPxDqFMjzXbE/kQp4xmJCXxQnU/IaSe
   s1la6mUAIK4h61VlqM8lAMt7UkZNVS5O0F8VyBXDPO5lPtTJNzQplmOn5
   XZw864jy8gOX0BHLW6o5VkJODTFTmo7YTqcr+sLSqedKecQTuoWluzZ0c
   5vT7PSEyva757ObjCBqOyQMUKjV4GrcODo1cjxEOetJYJ8BM9pVxm2OAz
   jWcCnnQxXPS43xPwtYH7GMStupiD4xGk+f8vClEHhM0BIk2n0jYoPm44b
   PdHikUWgrdTcRV8v7x+Qq3ThM//xaidJd1ijAOajae1IN7CpZZaBDFgyw
   A==;
X-CSE-ConnectionGUID: YathsGKKQjSS6LyfWLDqRg==
X-CSE-MsgGUID: fVot/GTwQvC/8G8n/jzdRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="80750921"
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="80750921"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 02:52:52 -0800
X-CSE-ConnectionGUID: DFCnukEUQcW8HLzpEgSJrA==
X-CSE-MsgGUID: +N6AhBUsRf65Jw/QQsoWVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="205741905"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 02:52:51 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 02:52:51 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 19 Jan 2026 02:52:51 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.33) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 02:52:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oHLpfT14Q46f4zebIeK8TNQdql0XcFXaZykMf+QJDtkthIZfIJ6vKRQ1quxxGSmP2Amxz3KMSpG6aAfG7XKEf4Vqi+LxIjmFhWDVVryxagSVQAL0pFANn9s6EiEp86rL02OUFe8D+lzwgsR72Um/pVAguvzAiUga7yFxgSyjJsh4AderJBMWjr198PV83f0yIp9hVRWvokmMG/J8iRzpcwF29/rjT6lOZLcD19oQjzyb6wra8mJXRFL4e1VeGH2xNw51xP5vg+L+D8o97/qfNV0V5GjKjQtOX/tMMO/OotLaUjhNcQkZUzOvErVb2eVm4EQIEMUADAhVHWFmBAc1ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AgNIhBupoa6bZTD4KvodZmAu5i7BHLZFvcJdjkRQC+c=;
 b=IQrBBKJywNtzxB/QgqQ4bcH5Zg10c5BhChwSp76vA8wmXpsBhHbMVBnpcojr5xSMMNBwWC5pmE06SKE4MHvtbMtZ3AOKRw2W1AtVPM8+FZovUpAbvnyyfF2qCgatIeytwoejEY9MNLwE/3As7/FQNQQV5qHtKIK2LrvM1HTcMj8MOYv6Zs9VNz/EQ6ZGMqH/j2YcxxafEeVgTVutveyYY8KpQwZsshZ6E67u8YiZRA7YgtVMuNo5qovfcU/V+PbIbeEtkZZJ0+h8AcNSm/sTHZ529s/adNKX8BfMFKglAJUL9TOLK7obGj8QnZzKBw1ICWcMXEgNl/nZ+jgGK93mVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MN0PR11MB6206.namprd11.prod.outlook.com (2603:10b6:208:3c6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 10:52:47 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 10:52:47 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Du, Fan" <fan.du@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "david@kernel.org" <david@kernel.org>,
	"kas@kernel.org" <kas@kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "sagis@google.com" <sagis@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Miao, Jun" <jun.miao@intel.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 22/24] x86/tdx: Add/Remove DPAMT pages for guest
 private memory to demote
Thread-Topic: [PATCH v3 22/24] x86/tdx: Add/Remove DPAMT pages for guest
 private memory to demote
Thread-Index: AQHcfvbrG83ObSiIwUe3ESYAX8MhhbVZZY0A
Date: Mon, 19 Jan 2026 10:52:46 +0000
Message-ID: <2b9d6a33629b40c92ecf1d9ed5d75e2158528721.camel@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
	 <20260106102413.25294-1-yan.y.zhao@intel.com>
In-Reply-To: <20260106102413.25294-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MN0PR11MB6206:EE_
x-ms-office365-filtering-correlation-id: 068b9008-1d30-4e3c-af53-08de5748e1c9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?b29xTlZRamxPcXdrenRLQXhXLzh0dGU5d09vQmcwYkswOXJoRkJJOXI1cklS?=
 =?utf-8?B?eC9wYVlMR2tlMGhsWUQ3RWJZUUE1UnQwWTF5QTNDRVoySDZWSEY1bXZ2ZTU1?=
 =?utf-8?B?ak1JQVk3TjM3SVp1NVBUN1lCUVM5N0x3OXdVZFg3WlNEQ2MrRm5sWUE1WlhE?=
 =?utf-8?B?RlhuRTA1UUUraHFEUURjN3BVMjN1UjdJY0UwNDl2WlphdFNCNTMrUHl4WXB2?=
 =?utf-8?B?YjQrVmdCRUxubEw1UWViVE5nMW0rSmVxT09iNkxLK09kdzNLcTkySzVMV0xl?=
 =?utf-8?B?YUk5K3FtS2VaNFJ5dXV4ZHJpMk9KTjBOb0VBOUxmeWZKYnVEMUpNMnErMzVB?=
 =?utf-8?B?YVdhVE5lUVJ0TzR4dWw3Nm9KVkc1WGRNWnZvaXNmcjV0TFNzT0NXT2tWZGNu?=
 =?utf-8?B?MDJaTGtYQlRCUFczeXZwelB0UkF1Z1Q3Y1hEdmxqZWtaMHlhRWZBcjM5OUtr?=
 =?utf-8?B?Y2hSZ1ZpZFRQbkRSelZXQ2puWXcxQVlwdzUxMExpTnJ3dlVJR2QyKzNJWDhP?=
 =?utf-8?B?c251WjYwMmgyUDlCM0tsWFpvVE5YZDY5U3cwYnZEZUNsYmxBVkljai92NDRz?=
 =?utf-8?B?QnQzUEYzWkdPcGFaQkx2RFUvRSsxTDA0VmZiMzllVHpsODZQcVRab1BNRjVz?=
 =?utf-8?B?UjVGZ3lxNTdLOEI4eE83QW14TmdXazBMNDNoTkxMZ3MyUXB1VkVUSStpM3hC?=
 =?utf-8?B?YzNVVk9GN0pQTE1JcWJ4dHo3RFZOZHpJRk9kWVpuS2daMTIxdERoUEpZL2Yw?=
 =?utf-8?B?dVR6cDJFRkdISVRhOEtCazV1K0R2TEtTeUlkby9vV2pHZTFpYitwOG9sMUFr?=
 =?utf-8?B?VEF2ZVhPSkM4bDBVQjh1Qzc2TzRkMHRWYzM2bm8rYnFtSzl4SXVweTAzZXFC?=
 =?utf-8?B?dlBDbjVXbk8rOFc4THdhQ0Z4MGJkUFRQc3BGSVZFTUdJMlhRaGJjdEQ2SlJ4?=
 =?utf-8?B?dWRHTEFuRno1TW05anh1UVZLYzh2bklzQUVpYTZwTHpmbXh1V0pIM1VnUFFu?=
 =?utf-8?B?cE1zdnF1cUcveWxONkZOYXRNMDR2NXhvTENPZ0NZVWpHdXptTkE4cndldmF1?=
 =?utf-8?B?KzNjTHZveW1iOTYwVkduQVNFek9RM1hzdWpGUlVuTVRIVmdwRVZHZ0FQcE5B?=
 =?utf-8?B?RG1RZ3RqMDVzMHNEMTE5SzJTVWVMY1FmQ2dzMDJQU0dxNEJ1VW5rdWdjU2kv?=
 =?utf-8?B?dzh5c1NYaHdvQ00rbExBenVPZG1UR3ExeUU1RXk3amhLeERBZG5HcGpJVEZ1?=
 =?utf-8?B?Y3JwaCtDTEl2cWZqQWpPdm90S3ZRN3YwVDdIb04ydnMxNS9ldDFIS3lJQ2xC?=
 =?utf-8?B?OGtVak1MaUkrZE9tUXVhTjFXQkhGSHdrWllhK1RSck9BbFM4bVRlc1ZKeEJz?=
 =?utf-8?B?dEZqRE9QaFF0NUFUcTB5c0U2cFc0WXYyUHE4ZDlHVVRQTENTMEp3ZnlWQWQy?=
 =?utf-8?B?SUk2OWRiSkcxaFUzS0Z6SXhsZFJGT3dUeTNaZk1HK0pOV1ExYXdvMndtbDdi?=
 =?utf-8?B?TU5VMDRMYTN4QytIOWo3dWFmWGRsOWxKZExFTXpzdWloQ3FpazB1NlFNNzJU?=
 =?utf-8?B?enNLU0xPNDdDOTlDODdIVnhhd1FBMk5tc1p3OGhEUGtlcEpLWGkyR0hzdHUx?=
 =?utf-8?B?dGhtZUQyS3V2VGphMndESWtXcTRLajRvUk5Cck5jUDZWb0JwRmhZUmdvUFB0?=
 =?utf-8?B?L0NIQjhsRWhLZVJuL3NlVk8wT2lIemdydDYzMVFRclJ1cHU5VElSYzZYVGIv?=
 =?utf-8?B?R1NOdE5CVjBtWDBCa2xCaTB3VmN3YjhVQnE2QTFpUDN6Y3RadHFoMFFkL3RU?=
 =?utf-8?B?S0YwQktadjJkTzIxdWNES1BLQzZTQ3BMSG5QWmtjbllYSUw4M0laZVlVTzh5?=
 =?utf-8?B?c3pCZkFIenFSUTl6MHBVTm9QaVVXS1p2SGd6Mk5ST2RzZnJoRTMyQUtnYmM3?=
 =?utf-8?B?enBOdWVjN3JmcW9wck5PK254RFVickIxZXA1YkNnY2FmejBiay91QlNiTE9s?=
 =?utf-8?B?cEJ5OGpCQ2lRNzVxV1M0YTdQODE1Q0tDU0haNGhQbUt3Q1dqb2FRcS80dmFG?=
 =?utf-8?B?dERrSFpRNVAzblliUmNaVmdEMjFnM0pjcUtRVDl6OE8xSXJLaGpmUHNaUXNi?=
 =?utf-8?B?UFRjcUlITktnYitrUnhvZEpRdXNtWW9NYkRqVWFuaDJWVkVTRDRzUXVPVFFz?=
 =?utf-8?Q?vyQGLSP4Gvi4S2RJYPszxLE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VVNhK2kzbVF3TUNpMEl0UXYraURmMnlnS1FOajR1cTUwV0tsajRlaERlZE9K?=
 =?utf-8?B?bllxdUNMNVFrSGVFdVMwNStXTngvRlBJbE5IcnA1blNXUjI4bHRSOFpoVFhm?=
 =?utf-8?B?dzZObm9XMy9zcU1XcHFVTnlvUitjV2ZKSXU1enQ0QmUrK2hIelRHZ3lSeGps?=
 =?utf-8?B?UGRZZk1kT3JoYTV2Rk1UaEZTSDg4MnZDTDZRRU1IOVRJSnd2QWx4R2VmNDRD?=
 =?utf-8?B?YTI2bDBKRy9vOUxZZFBFRnZhRU9jK1VPaWlpWm9udkZRZUVVVXEwc1d2a0oz?=
 =?utf-8?B?ZGY0Y1hiaVRsc2Q5dklNRkV4UWFYcU5ENDl5dXdWdi9TOWFNT0xTa2lnQWpH?=
 =?utf-8?B?SlJ0U2c0Q09JNmVmU3BsVi94SUg2a1FNSWdzVkF4OXNGNHFqbDBFQzBaeGVj?=
 =?utf-8?B?TCtZSnVnOGtTZkI0M3dCNllqVEZTakJQN3hZdFBPZFZYeEJwejNDMmpDcHh3?=
 =?utf-8?B?ODlyVEJqaHpJMVg4SWxmcGdxcEZUMlZkR25kRlJtU0pRQVVueG9xVXM0SGpv?=
 =?utf-8?B?Y3Zya1pqcDdkNGoyUGJwS1hWWUx6MmpyV3ZsL2w2N242Vmlhb2UvZFlCSXVK?=
 =?utf-8?B?dUxuTkk1VGlOUjNsNzFVNERldDQyVVN4bzdGenZZSGw1YkRySFNtTVFwVnVE?=
 =?utf-8?B?dHkzMWYwSk9WL2FrcHZaTU5va3Q4bEN1MWdVS2svOStDNUhJRWJCOEphYS9y?=
 =?utf-8?B?QlprRlcrcVdhNUVPbG1VdEp3cnpLTU9sczBET3JneXF4cStYMUNES0s3bFJp?=
 =?utf-8?B?VTAvTFcwbmpNQlI2THVKNnhCbVNzYWFkb3NWTC9Kc1lpZVFkWG9wbWpaQ2Nw?=
 =?utf-8?B?U1A2ak80OUYrTHFzVENGRFRVaWNBTHk3S3VrTloyRVhaWStwcjJiYURDa3Q0?=
 =?utf-8?B?Z0Q1M0pjb1IydDFpWnBGakNwR1NHY3ZDQ0NmZ1lsSlF2MWxYTUxlZmI2MjlK?=
 =?utf-8?B?dHQvU1ZXVlYwbHVRdXlRS0srbVZsd1ZDVTRlN0VVRkhTeGZILys2eGxYMEc3?=
 =?utf-8?B?Ykh1dWJYcjNpZjBodlc3MnNUMXBxdGNBM0FmaVByUDFmdDArMHNBSzFYQlc4?=
 =?utf-8?B?Z0xvZmZONktJS1p5S2d2RjlmSXdiSWovaFJoeTJQUGFuRVhpWjJXclpDTkRP?=
 =?utf-8?B?Y3BwT0J2TEp3SFBOTFAzVGhjUlhXSGNrVDZDeU5TOERkVDNIK2h5ejd1U01o?=
 =?utf-8?B?cnFFb3RlMnB5M1JlM2FSUEZnUlZGT1ZUbHdEeG5PZWVURUo0alRPbHd4U1pJ?=
 =?utf-8?B?cFJCM0lMTEtCbEVtb3Qya2k5VGM0eXhEZWh5SS8waXl1N2ZhSG1VRmNFZ2Qv?=
 =?utf-8?B?VmVqeWgyYzh6UFN5dEVuRkxGcUpoYVFNTWF2Z01Sc2dueVAvUSs1M1prTkxZ?=
 =?utf-8?B?VmFyaUpKL3ZSVS9RMUYxMXF6YVIwK3VQT3p3RnlpQXFsbXdCMWNqKzZTQTN1?=
 =?utf-8?B?a1c3UklqNUFkSTBhUVQrRHplcldKMXBwTTBxYlRPUG93UlVmVmJHMWRieVQw?=
 =?utf-8?B?YzZDTHpCNWcrQ0lta0Z5RzhkciszUUc5ZjdDVlFPeFFOb1NhaTB1MDdnNitQ?=
 =?utf-8?B?bkN6RllVc2RJZ2lHaFlVOXJHMXozRzRqSzNZbUxkcTcyUzMxalo1VUgvcTMw?=
 =?utf-8?B?ck50NUl6ZUdCTWRYc0RGcmNRYmpYMXhWMmdqeWJscEF3YlFTZ3BwdEJOVmt3?=
 =?utf-8?B?Y1RFajlqa290aGVyMjYvYVl5TmxwT3k1OG1pWGlDaTlDRE9nK2hmbXdwK2Nr?=
 =?utf-8?B?U0NJWWNWWGd0cU0vNWlybHJ4SEpkL0plbUxQbWVLNFcvTmQwQ2ZoVGh2ZXRn?=
 =?utf-8?B?cys2YW84QmZWeDdvUEdOcWxXVi9yQ0hrbEZiSElYVm5iZXQ2UFJzYnBldjJI?=
 =?utf-8?B?VWVKOFVJaUFMV3hXbUc4MGhhSXAyMGo4TE5abmVoOC9ia0RTS1Uyd1k4WWVD?=
 =?utf-8?B?RmxBQ3A3Q3VUN05kS1ZwbmlITVNUcG0zMjNDRUZNVlp0OWlGc2hKbktNVzhm?=
 =?utf-8?B?bFEyUVR5dGVPZUlySndNRGtWbXFnSTRWVys3SzQ2cktwcUljR1NxczlnL2cw?=
 =?utf-8?B?R1lHNGFsNlgvNjBkV0pwSWhyZzcweEdPVWFNSzJ1QnZWLytGdnhuVG16REps?=
 =?utf-8?B?Nnh1aHpvc2NzVEN0N3NZYnd0UERBaWhxa0N1VHNSNGN6bU1kQTdJay9vL0Rt?=
 =?utf-8?B?a1crVTBYV015WWlVN1pabUJrVGFuQjgvcHpIZ2RxRDVQR3RKR0tmU2JzaGUx?=
 =?utf-8?B?aldYRG9lS0t3c2lTVWcyaGt0dHFTMHRrMlNJcDFySHgrVjdQbWhpTzNWMEtu?=
 =?utf-8?B?UGdEcGZ3UExaY0pNOXk5bEE3MEN5aVM5Tk9yaDhiem4zWDA5RzVzZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <01817DBB438F1149AF4F5750DEDE7AC0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 068b9008-1d30-4e3c-af53-08de5748e1c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2026 10:52:46.9965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YjMuXKpTMuObIVxz7g1G7+D/RuH4VFx7yp/SSU/WUQ95b3o4Sq5mEsyfPEdMy+Bs1J/UeCH1FsUsfhdI02j5WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6206
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI2LTAxLTA2IGF0IDE4OjI0ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gwqB1
NjQgdGRoX21lbV9wYWdlX2RlbW90ZShzdHJ1Y3QgdGR4X3RkICp0ZCwgdTY0IGdwYSwgaW50IGxl
dmVsLCBzdHJ1Y3QgcGFnZSAqbmV3X3NlcHRfcGFnZSwNCj4gKwkJCXN0cnVjdCB0ZHhfcHJlYWxs
b2MgKnByZWFsbG9jLA0KPiDCoAkJCXU2NCAqZXh0X2VycjEsIHU2NCAqZXh0X2VycjIpDQo+IMKg
ew0KPiAtCXN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgYXJncyA9IHsNCj4gLQkJLnJjeCA9IGdwYSB8
IGxldmVsLA0KPiAtCQkucmR4ID0gdGR4X3Rkcl9wYSh0ZCksDQo+IC0JCS5yOCA9IHBhZ2VfdG9f
cGh5cyhuZXdfc2VwdF9wYWdlKSwNCj4gKwlib29sIGRwYW10ID0gdGR4X3N1cHBvcnRzX2R5bmFt
aWNfcGFtdCgmdGR4X3N5c2luZm8pICYmIGxldmVsID09IFREWF9QU18yTTsNCg0KVGhlIHNwZWMg
b2YgVERILk1FTS5QQUdFLkRFTU9URSBzYXlzOg0KDQogIElmIHRoZSBURFggTW9kdWxlIGlzIGNv
bmZpZ3VyZWQgdG8gdXNlIER5bmFtaWMgUEFNVCBhbmQgdGhlIGxhcmdlIHBhZ2UNCiAgbGV2ZWwg
aXMgMSAoMk1CKSwgUjEyIGNvbnRhaW5zIHRoZSBob3N0IHBoeXNpY2FsIGFkZHJlc3Mgb2YgYSBu
ZXfCoA0KICBQQU1UwqBwYWdlIChIS0lEIGJpdHMgbXVzdCBiZSAwKS4NCg0KSXQgc2F5cyAiLi4u
IGlzIGNvbmZpZ3VyZWQgdG8gdXNlIER5bmFtaWMgUEFNVCAuLi4iLCBidXQgbm90ICIuLiBEeW5h
bWljDQpQQU1UIGlzIHN1cHBvcnRlZCAuLiIuDQoNCnRkeF9zdXBwb3J0c19keW5hbWljX3BhbXQo
KSBvbmx5IHJlcG9ydHMgd2hldGhlciB0aGUgbW9kdWxlICJzdXBwb3J0cyINCkRQQU1ULiAgQWx0
aG91Z2ggaW4gdGhlIERQQU1UIHNlcmllcyB0aGUga2VybmVsIGFsd2F5cyBlbmFibGVzIERQQU1U
IHdoZW4NCml0IGlzIHN1cHBvcnRlZCwgSSB0aGluayBpdCdzIGJldHRlciB0byBoYXZlIGEgY29t
bWVudCBwb2ludCBvdXQgdGhpcyBmYWN0DQpzbyB3ZSBkb24ndCBuZWVkIHRvIGdvIHRvIHRoYXQg
c2VyaWVzIHRvIGZpZ3VyZSBvdXQuDQoNCj4gKwl1NjQgZ3Vlc3RfbWVtb3J5X3BhbXRfcGFnZVtN
QVhfVERYX0FSR19TSVpFKHIxMildOw0KPiArCXN0cnVjdCB0ZHhfbW9kdWxlX2FycmF5X2FyZ3Mg
YXJncyA9IHsNCj4gKwkJLmFyZ3MucmN4ID0gZ3BhIHwgbGV2ZWwsDQo+ICsJCS5hcmdzLnJkeCA9
IHRkeF90ZHJfcGEodGQpLA0KPiArCQkuYXJncy5yOCA9IHBhZ2VfdG9fcGh5cyhuZXdfc2VwdF9w
YWdlKSwNCj4gwqAJfTsNCj4gwqAJdTY0IHJldDsNCj4gwqANCj4gwqAJaWYgKCF0ZHhfc3VwcG9y
dHNfZGVtb3RlX25vaW50ZXJydXB0KCZ0ZHhfc3lzaW5mbykpDQo+IMKgCQlyZXR1cm4gVERYX1NX
X0VSUk9SOw0KPiDCoA0KPiArCWlmIChkcGFtdCkgew0KPiArCQl1NjQgKmFyZ3NfYXJyYXkgPSBk
cGFtdF9hcmdzX2FycmF5X3B0cl9yMTIoJmFyZ3MpOw0KPiArDQo+ICsJCWlmIChhbGxvY19wYW10
X2FycmF5KGd1ZXN0X21lbW9yeV9wYW10X3BhZ2UsIHByZWFsbG9jKSkNCj4gKwkJCXJldHVybiBU
RFhfU1dfRVJST1I7DQo+ICsNCj4gKwkJLyoNCj4gKwkJICogQ29weSBQQU1UIHBhZ2UgUEFzIG9m
IHRoZSBndWVzdCBtZW1vcnkgaW50byB0aGUgc3RydWN0IHBlciB0aGUNCj4gKwkJICogVERYIEFC
SQ0KPiArCQkgKi8NCj4gKwkJbWVtY3B5KGFyZ3NfYXJyYXksIGd1ZXN0X21lbW9yeV9wYW10X3Bh
Z2UsDQo+ICsJCcKgwqDCoMKgwqDCoCB0ZHhfZHBhbXRfZW50cnlfcGFnZXMoKSAqIHNpemVvZigq
YXJnc19hcnJheSkpOw0KPiArCX0NCg==

