Return-Path: <kvm+bounces-57646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AE5B5B588C7
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 02:03:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 941C54E1811
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82483824A3;
	Tue, 16 Sep 2025 00:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uu6paY2G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FA7F507;
	Tue, 16 Sep 2025 00:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757981012; cv=fail; b=K7I9E98Qy6+XwLly9Y/01vqXVpdZ8Bi6heEiQ6aK6Iq2GwjwL0sLwUcxCITbTxoqja2Tf+Uyc7oeTJ7ecxvaMYwV71jxYZ0ZejJzyW/1de0lYruY8cg3lTVP3d8i+qeAGam39SbGuOfhnVjns9KN+V0DraPXn6j3LkcJuolsWLU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757981012; c=relaxed/simple;
	bh=OkhujHa3uJgupvMGLEcoYJ9jr39sJlD0hk5vQValkY4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KrecSs2o8xrsFYgFAoK2FnYuUSql+DBjiRtXvVKfYb5EgnnXuBwu5UWJx9b736hIB9gl2NIgE3wqZUzY2sxMBgoqceimjSC0DDtjVm25td2W2gJtTCvyjVFo5+4M/nsq7tT0rEuokPdcuYJmOrb9LXTeR+PSfC/CRMY5p4ASD9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uu6paY2G; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757981011; x=1789517011;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OkhujHa3uJgupvMGLEcoYJ9jr39sJlD0hk5vQValkY4=;
  b=Uu6paY2GIEWZUNfXpSzWPRJawnFyT8utAAtLQHCEukyNlCEZuXtFahjM
   AxSLsacN025y0sGc9HrbvPQXNJNo50HST8HgwzfAKOqqDIzB6ERm15kSs
   3YvMaJvR8tLs/0V+KwE/3jP0KN35SJQtxMBiJM30y0020/GGPsOD3oJzf
   C6dJEIDt6juCsTPd+X4mZvNIVK8l00/LOM90m+J9HbE7986fLYTCYF83r
   ucvHHDBNr3B1tvI0MM088BNx4DAnGIlXv7u6h2J4uw6q58ArVGj5HxbUD
   8ZMI4lrzByR2PNV6DG1m80mVEqWcOJrsRYRyQeAm1VugZwDq0U/VEF0LF
   A==;
X-CSE-ConnectionGUID: B56sLPLPQlmt4MYFezIYrw==
X-CSE-MsgGUID: GWyjpIowQcOior3dmNBwBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64060959"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64060959"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 17:03:30 -0700
X-CSE-ConnectionGUID: nL/rMfx4S2yuibE/lURCZQ==
X-CSE-MsgGUID: BtEGQBrXQk6rLO5xYi9Pww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,267,1751266800"; 
   d="scan'208";a="180022873"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 17:03:30 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 15 Sep 2025 17:03:29 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 15 Sep 2025 17:03:29 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.34) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 15 Sep 2025 17:03:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T2HnmD2oTbmqC+U29XXafQJoG9VQD6Ch8FC2JCk2Cx8HU2vvzgLzc+5FWk7+lmN4WNxgYSIWU9CvSUIaDIyKpnndyTIohy9wQapPvLgDjy/8X1MjlkWRKa2MBeMPSYhcfd6TZ/579U1jKjyiER71a8bH6HYEMarNrMpyS7A2CV6zCmuv7htXfyapHqqw1gMZMzWJYlNKEIYWrLhqKd+70XXyaz5Ewvj6aDB2+8EaR186PNeSeCIvzJTEVMXgeNqmSElthTlLLCvpOMJJ7nqpBOV/LcuyAwKZl9ErwM6st2rhn3/ceMR33qQPCiljeRz4sORmcikiH+SHhNM0n4Bwiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OkhujHa3uJgupvMGLEcoYJ9jr39sJlD0hk5vQValkY4=;
 b=p1FZBvNnIW43n66OEZgbz6QTtGymZGw10WX5vxs48bt0XrsOrFN8bJ2NamxifqXWDpr718fZl64BphDeTpwT4OATVxtqWpcWTMJMvdrBu3bcsS7L5LrhcmkimFaWBIPnYa94neC4WFgm/r7uLIqCNUsKlHHfjM4QiGgfb4R+JvkOhpDNopAwvbOnGhBajCnXPFkLVf6km4YEA4DymPZuoNhp9HaOx86TPtQJEF9puCJa4lzFMDIRGLYri8k5llUdpPi0kdVZWlRYU16j6InT29Ih1laGNmesLB4+zv7EJRoF5SVZkqj95B3Yqg/UNci8q2KNw5+rvirdhPmhLas4kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Tue, 16 Sep
 2025 00:03:26 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 00:03:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Huang,
 Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 04/12] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCHv2 04/12] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHb2XK3Zzo+5cyiVkKYUJ8ur2xfN7SVh7+A
Date: Tue, 16 Sep 2025 00:03:26 +0000
Message-ID: <6c545c841afcd23e1b3a4fcb47573ee3a178d6e1.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <20250609191340.2051741-5-kirill.shutemov@linux.intel.com>
In-Reply-To: <20250609191340.2051741-5-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB7472:EE_
x-ms-office365-filtering-correlation-id: 1b18f9ac-ad0b-46d0-fb22-08ddf4b475d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?a0NVVzJ0enJqemFGeTY2ZXpaUytzaTN1ak5IQWwxYTZ1VTFFWDJCdXlsT0pS?=
 =?utf-8?B?TEZQSWxOd1B6SGFmVmd3dGhyaC9aUXFiYStnM3hwMWRjT05UYUxReXNUbUJT?=
 =?utf-8?B?THlpZmtvb25hN0M4TWVWOUpOTjl6UkF1Ykg3YkFiY21OWTRvTlpXWjZZVWVI?=
 =?utf-8?B?TG1ma2N0dmZCY0RFYUUxNzZ4eXFHcHhVZWFtRjI1WXFkemJnU2x2ZkhnWXh5?=
 =?utf-8?B?TjAzT3I0TGlKdGlUR3hmMlZOc1ZKdEFDbkJIQ1RHMnNhdEhibmQ3SzRCdE5H?=
 =?utf-8?B?bDdrUDd2bUxLeHNVTTR0M2JTYUQrM1hTUVNCMlU3QTBCWGJzdGFLUEo2TERQ?=
 =?utf-8?B?V0tJNm04YUllOHBuVHo2eXBtcmlyNWdiM2h2QjFESHpWNjlYdGFHaE1qcDFv?=
 =?utf-8?B?a2RCNlQ0SHpsWDBsOUk4aDMyMi8raGNwdlZkZExQVDFGai8vQnFHejFrSjQr?=
 =?utf-8?B?L1Jwd2pLSDZpZyswZjhKbHY2UXhHczZWM3Z5TCtpa1MzbnFBYUVqWTlqc3J1?=
 =?utf-8?B?WFV6OW9jdDVaWW85N1p5R3RFeTlQbERNbGF0ejZWZkZzc0dGVFltMUxPSG5N?=
 =?utf-8?B?Ymx2NWN0aE9PTStSb1hDdWpzOUZ2aHBDTlovN3RmK1JxVVVjUml5eE9Mdisy?=
 =?utf-8?B?NVZNMVBaQzR6VEhKcFF3K3Y1ZjJkZzBrb1NKOXFUMXZydEFXRzVhZHFPS0NL?=
 =?utf-8?B?K2VIR3VEOVBwRTJXVGpYTWxZQmFPbXhEaXpsdDExak1zTC9EblZzN2liclAy?=
 =?utf-8?B?d0MwajM1VkgrT1JQb0Y1R3RrbXlhTTA0U0ZPR0lubzJyaVlpNmtTbktMWVd1?=
 =?utf-8?B?eVkrc3I4MHFpWGVzOGN0VUJNN0hpQWt5SXk1dWUxbzdHVlQ5aUd3Yk9nR0cy?=
 =?utf-8?B?ZnAyb29OaXZieUhSdmRUQm8vK2NDM2Jrcm5rTjlGYlFpaTdMaEZCbnkwOEpP?=
 =?utf-8?B?RGZQZTNYL0tBWXpVK1VzdENMRG50YU4rNW8xNE5aU2Q4R2dudnA0VmljUC93?=
 =?utf-8?B?TVlWRCtMZzN6MFloZUN2SjZMSlAyNytOWFQ3bTFWVCtXM3RVLzhHdEpEa0Ro?=
 =?utf-8?B?bUFma1hkclJ6L3hNRVhMTnM5ckdyU1N1WnNKMWZZSmVocEZXRG1ZMStRT3NB?=
 =?utf-8?B?WnUvdmZoYVp6NEtHelhFSXpNM2M1MUVyNmxCaGc1R2phby9WNDhWWDFBbjBV?=
 =?utf-8?B?VHJ5Q0tnVytIY0dBQkViUWp2Y3NYaWptYVFDZHhPeWUzd2NiSWxKK3NFZkVW?=
 =?utf-8?B?WmhkN2hoNW9VZEdLUEorMS9sbVJNOURmWWJpZHlIY1BCME85M2FjL2VQcHhK?=
 =?utf-8?B?eDM1VkluM3ZtTkw3QzUxT3lvOC9vQW9BRm1sdmJoMWFMSndHejh2TEUyVWc3?=
 =?utf-8?B?bEliM3hLQ0FGU1ZGTGZQWU50aGpPUDZNbGNmSnNhcDFwa0N5WkhMcXFCTDhI?=
 =?utf-8?B?NWJRazVMNjRRdFc2VGVlMkV6V3Z2RHQrSHR5eU0remRJZ3hHS2ttd0VaVGJx?=
 =?utf-8?B?UjkrbE1EdVhaV0NMT0piQmlGbVJMc2ZPNllwd1l0d2JETUYrdEI5ZmxwSDNZ?=
 =?utf-8?B?NnZ6MDh6MVBDeEg1dXM2UnZTdk5ZdUZPYk1TR3o0K05PT0owb082UU9LVGhO?=
 =?utf-8?B?SDNndUlUeDZNV0h4MGlwTjNHS2dWajk5UktCOWVXY0w5d0JuMUFUR05DcUJ1?=
 =?utf-8?B?eXpGcnd6Lyt5bmYwMEROaDk2U2oyUlJ4OVFNeVZ6b290WFZaR1k3YlpOelk1?=
 =?utf-8?B?RzdUUmpxY0JWcG9hdkpNZzdaZXBQYkcra1d5QzB1SmVVR2hVazZIbkNFdmNt?=
 =?utf-8?B?c2Q3aFIvWFZxVVYvU3Y4UjZoQkoyekVaS3MwamlrRUQ0dDJiQ3lXS1Vaa2ZP?=
 =?utf-8?B?SzkwMG5COEVudXQrTTNTYXE1SnZnKzcvZTRXYmdjamNHS3BXSVpHRXFNdEdP?=
 =?utf-8?B?NjU1eStVK0k3NktjellIR2l4ZzMwMkxnUEpBWWRRT2FFTThzZlpNaU5BbjFa?=
 =?utf-8?B?TklCUGJWd2JRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N20zQXRhTHovK3cxWHg3TXFqRXpSWWJ3TXl4a1Q4d0JaMFY5dkYvcFJoQmlV?=
 =?utf-8?B?Vk5hdXNEN1d0N29JRE5vaXlqdmJEdDFDQUJ4MWozbEZZSk1abFVBcG1WWTY5?=
 =?utf-8?B?ZU94eGxuS1o0WDF2ZEtzWHhkdTBiS0llRzV3YjB1RHZIRFVnbkMrbDZYSmM2?=
 =?utf-8?B?ai9MeG8xN0RjY2NWQlVxUndBYTdXY1loN1lQN3R0RFNKYnNxWVNCR3FYYzRm?=
 =?utf-8?B?MUlJQjNlWUhFN3NvTEpMVkYyTGhhLzU2SXkzN21pOHhHRE45Uit2VjBBc1F4?=
 =?utf-8?B?R21rRFdVNE5WOWJ5MmppRFFyajhHL3lXNUJFN21DSkdGbFVYN3pWN2hFMElj?=
 =?utf-8?B?ZTBHcDJQMk9TRWVXVVV5Mmd2aDNWbjY3M3FaS09yUlYwanlKQVErTVRIeGNB?=
 =?utf-8?B?ZUw5UFdLRjdteVBRcDRZRCtzRFlGOGRZaThPcS83enA0SUp1SXVza2l1VEVJ?=
 =?utf-8?B?SVdTMCt1SG5sLzNmQys1Wm5DWDFKMm9URGd0eVlTcVE3eEg5M2MxWDdrMmgv?=
 =?utf-8?B?RGhTSUo5aXpQckVqRmwwbGJOai9hanFrM2NxSngrcGFBa3UzVk54RERPbVJt?=
 =?utf-8?B?ak04SzlZVjAvQTJtT2VibE5oZEN4QWVKT3ZtWGNXaEQxZWMrOWlrdUdhd1ZI?=
 =?utf-8?B?TlpyQlFIZXUrRHRnSGl4aStwem82ZDFVV2hlQnVGN2w5Z0l1L2JtZEkvOFd2?=
 =?utf-8?B?b29FcDBJbFN0bDI2ZEJoNXBaUlFWd0h3YUxvd2xLbzlVTHBRL2V5UzlGODBY?=
 =?utf-8?B?T3pWUE1KemhDeUYxeVJkNmJaN3hFczAxZDlxOXZZTjd6aVZFUVoxemFqbG10?=
 =?utf-8?B?R3diaktBR2djeTlvL2t2bnJwdDc1ekxwK2xQbmtlTDh0cW9iOTZqVzhpazZr?=
 =?utf-8?B?b1h4c0F3MkE2R2ZMbTRNTy8vZHRNRHZQOWlUdWpGMlFrakhMd1VhY0VOazVS?=
 =?utf-8?B?d0NDR2JiQ2lEbHd6a0ZYYjJsVFZ4QVExdWF0ZUlwTTQzb0x2YUloMTJyazNu?=
 =?utf-8?B?eVdOcEFyVC8xY3lvMjkveVpKanMvcTdYRW9tYUtML0MwejZYWDFyVmRpcm9L?=
 =?utf-8?B?ajRCbk9YUGNFbFk3bnZVelphR3Z5VFNLL2FVZkwvVWJNQmdqU1JuTllyaUY4?=
 =?utf-8?B?bjk2OStIVWIzZ29OdWo5Y3F4Mi9FeEZIUXVaN2x3Q25YMEwvbmtDZjJpVXM0?=
 =?utf-8?B?YW1SSHBWSldxUytQdTJBU083SkprS0N6TzdsT2RiUjZRZ1pDWlNLMGNwTndL?=
 =?utf-8?B?WG1sWXlQSEtDUzhZNFZoVFdMZVI2Y0UzeDdwVFFUUzZXSDNPSEY1dXdFVW9j?=
 =?utf-8?B?NVcxMkZVVllsa1B4aUM2MW5IOGJ6N1QydjdPQklhT3gzdGM2bGZZSEdHM1RM?=
 =?utf-8?B?aWdGL3VBdHZpTmVNWjBqTWhSazJGWUJuTDFRSUc4WHliUlhNT1FSUkFUUjJv?=
 =?utf-8?B?eUljQ1FrY0RwMHZpU0QyRDZITWtQeGtacWFKeCtxdlM0b3pWa2s5UXpLdDl6?=
 =?utf-8?B?OXBLRHVYV3F1L1lDUmwrQXNDR1plQmh2ZzVUTForM3pPTVNMdHRpRXY0cHFT?=
 =?utf-8?B?dzkyZEJrTU1PcHFRcWFmY1BMemxZZlpWaytFai9QbHFGYTRCRklkVkFxSkxn?=
 =?utf-8?B?RmR2M081WUpSY21ER20zS2laOEZUaFhrV1RDcWg1TTVSakpqcnIySm5CWk5R?=
 =?utf-8?B?a01NcDBaekV3OFBqRDBNYmx3NFVDM2FYaTNDeHB2bWJROVYyNTBBNm13Z201?=
 =?utf-8?B?WjF2RkJ3YitySWRrdHpHc1Z4UXNDU1drcUZ6NlREQ1pZeWFaR3U5SDNSOWNW?=
 =?utf-8?B?ODZkYlFpUCt2Rm5UK3lSWEJyZGMycGhMMlhuLzBBUHZVYXFqajdQS1NIaVpx?=
 =?utf-8?B?M3JwYWRHckFnVHZoOVl5aXZhaGtWUXpHeHFtMU5SSURXUTdNVlVJbHNoQXQw?=
 =?utf-8?B?ekJ6WDFwYkJnelRYWm94L1V1MTFCYnkzaG42R0pCUit1L20yMXVPODlZbm9S?=
 =?utf-8?B?eEYreUVnRzZEQmgwNUNZTEVnK1JtbytSeTdRMVB0SmNKV1dOSTlrUEpScVN0?=
 =?utf-8?B?RDJ0QTBqdUpDSDdpVlhoYWRvZ1ZLS1NtczRuUGtYamFMVzFwaFRDbkk4Slp4?=
 =?utf-8?B?Y0V1MFdkcUR2UEZhU0dwSWFDT3BxQmJOVFgyVkVYcjNpVlYzNUpvN1hza2w2?=
 =?utf-8?B?Umc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <42F1186E95537A40810C03E726A0508E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b18f9ac-ad0b-46d0-fb22-08ddf4b475d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2025 00:03:26.4198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0u/dyoKJzNnNYc3xiFG/aTwsQr2hSaDZyRPzHjmS7d87+NPUl+ypZhwMrDyH3TMQxxfyA9twhuGuCLi5fM81UNG/Er3aydX2I331CzNF0dk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7472
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTA5IGF0IDIyOjEzICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+ICsNCj4gK3N0YXRpYyBpbnQgdGR4X3BhbXRfYWRkKGF0b21pY190ICpwYW10X3JlZmNv
dW50LCB1bnNpZ25lZCBsb25nIGhwYSwNCj4gKwkJCXN0cnVjdCBsaXN0X2hlYWQgKnBhbXRfcGFn
ZXMpDQo+ICt7DQo+ICsJdTY0IGVycjsNCj4gKw0KPiArCWd1YXJkKHNwaW5sb2NrKSgmcGFtdF9s
b2NrKTsNCj4gKw0KPiArCWhwYSA9IEFMSUdOX0RPV04oaHBhLCBQTURfU0laRSk7DQo+ICsNCj4g
KwkvKiBMb3N0IHJhY2UgdG8gb3RoZXIgdGR4X3BhbXRfYWRkKCkgKi8NCj4gKwlpZiAoYXRvbWlj
X3JlYWQocGFtdF9yZWZjb3VudCkgIT0gMCkgew0KPiArCQlhdG9taWNfaW5jKHBhbXRfcmVmY291
bnQpOw0KPiArCQlyZXR1cm4gMTsNCj4gKwl9DQo+ICsNCj4gKwllcnIgPSB0ZGhfcGh5bWVtX3Bh
bXRfYWRkKGhwYSB8IFREWF9QU18yTSwgcGFtdF9wYWdlcyk7DQo+ICsNCj4gKwkvKg0KPiArCSAq
IHRkeF9ocGFfcmFuZ2Vfbm90X2ZyZWUoKSBpcyB0cnVlIGlmIGN1cnJlbnQgdGFzayB3b24gcmFj
ZQ0KPiArCSAqIGFnYWluc3QgdGR4X3BhbXRfcHV0KCkuDQo+ICsJICovDQo+ICsJaWYgKGVyciAm
JiAhdGR4X2hwYV9yYW5nZV9ub3RfZnJlZShlcnIpKSB7DQo+ICsJCXByX2VycigiVERIX1BIWU1F
TV9QQU1UX0FERCBmYWlsZWQ6ICUjbGx4XG4iLCBlcnIpOw0KPiArCQlyZXR1cm4gLUVJTzsNCj4g
Kwl9DQo+ICsNCj4gKwlhdG9taWNfc2V0KHBhbXRfcmVmY291bnQsIDEpOw0KPiArDQo+ICsJaWYg
KHRkeF9ocGFfcmFuZ2Vfbm90X2ZyZWUoZXJyKSkNCj4gKwkJcmV0dXJuIDE7DQoNCkhleSBLaXJp
bGwsDQoNCkkgY291bGRuJ3QgZmlndXJlIG91dCBob3cgdGhpcyB0ZHhfaHBhX3JhbmdlX25vdF9m
cmVlKCkgY2hlY2sgaGVscHMuIFdlIGFyZQ0KYWxyZWFkeSBpbnNpZGUgdGhlIGxvY2sgYWxzbyB0
YWtlbiBieSBhbnkgb3BlcmF0aW9uIHRoYXQgbWlnaHQgYWZmZWN0IFBBTVQNCnN0YXRlLiBDYW4g
eW91IGV4cGxhaW4gbW9yZSBhYm91dCB0aGlzPyBPdGhlcndpc2UgSSdtIGdvaW5nIHRvIGRyb3Ag
aXQgZm9yDQppbmFiaWxpdHkgdG8gZXhwbGFpbi4NCg0KUmljaw0KDQo+ICsNCj4gKwlyZXR1cm4g
MDsNCj4gK30NCg0K

