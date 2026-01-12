Return-Path: <kvm+bounces-67684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C85D5D1052B
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 03:15:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B10D23051AD2
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 02:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C5B7207DF7;
	Mon, 12 Jan 2026 02:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jCsgq6o0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3552D2F5328;
	Mon, 12 Jan 2026 02:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768184100; cv=fail; b=lhCrW+mp7jvP9K2Yan0IjJhmFcHA0OTAtqBunnFjepjV3H8vDGV3LFc/QvhYLEa874BHbsimLXwgMbMk87Hx+wj0lpzxz50wc8/Hn0BOe9jO/rcKCCwW083CO+OQlFlW2vaf8CVmqCd3C4rNqRrfTnIFCnyzVwHSOJ+iZhqTCkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768184100; c=relaxed/simple;
	bh=W2KiConG4SANcgkuOyVIs4TPakyPsMSLtrv3Q3Y60TQ=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=N/ruNzTUcARn/k5buIYFlM5hiACJwbbdbXcjsV3S5GO8T25+uLjpmpPe+isQbvivix+JuVLSsQ/vSpGGIELezHy6f64GMC9Zr+cqHCCNZevof0Bn7n9J4P1h34v1Zn5k3589Z+/Z/ECyueNrF0qFde5mJfCAVrVHlvk+TJpiPzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jCsgq6o0; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768184098; x=1799720098;
  h=date:from:to:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=W2KiConG4SANcgkuOyVIs4TPakyPsMSLtrv3Q3Y60TQ=;
  b=jCsgq6o0KvoBOMRNAXyXjP34IXIyGDcpHjHh1/5ZLJ6K2b8xjqygfUeC
   zAWULNdpPagoifkC0OvGWPHDvtdw/XXhGuseITuXytTXk9/UPUu0q9RC2
   iWM7tR3BwmV2wTIcw9F7lcssi4BrVEh7mDMLw8dM57Iap/jEVRZyTc+rT
   8SOsCXrWUTisUq3yqXkEGRFGcN219AsuAdUFuZfb8kJpSbjlc2NfVz1+B
   aFZOTV3w7DYh2YKIR0l3GX5dfcnSexCqCio+v+zJUlH+DZBTudZP+y/7I
   x6TDmt7Hmhf3ZUs5mpxNyikZhUlg0UqLNazHX63QPSK8KyNWRON4EGPJI
   g==;
X-CSE-ConnectionGUID: wbctP6yuS2aP4T+sUHgDlw==
X-CSE-MsgGUID: J8zPIa8ERj6MemqvF30P7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="69444097"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="69444097"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 18:14:58 -0800
X-CSE-ConnectionGUID: 9H3SyGrlTjWypkDE0fy5VQ==
X-CSE-MsgGUID: c6SzQaCaQX+ziqod6z3dHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="235198889"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 18:14:57 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 18:14:56 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 11 Jan 2026 18:14:56 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.59) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 18:14:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mDfn0PisLUzm/o7eHump2pY0KEdE85l6i2xMV1MXwbn40SYgW0BPzD/p9uLvMBNP+lEvyO3y20BxZq752+bhEl7jXxt/7lacs1Zi7FTRQ6Huwtby9CMV/2i/xte3Ng/sPzrUVDaR/R9OkNgRT2O893P9veDyncF3aY358uUCGTXh8zMRUxJLPDOvylDynB8pgaCPMf90wmTsAa+7ZKahTslJ9d2gqAZaFogPfKVIEx8vkA+bqKNkpXFF2wMb3U2VStijJwsSy+kbccEsEmyTISHQEMjy0LJVXZ3PKnBPazBFw9UsBxoOOGK5VkW1B0NnNHCQrBdXosYtJz5oaAfhuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y4vHSFNXVMZdQlkUEZ+oSSQ3badDH3QEjWbx2kbgqjo=;
 b=kNxIrVUCftoogVbor/QrIra+Bg2eP1lRCfM+7Ld0P/IXjbZP2v7GhoMRxahw/E9cYYo5y+jd9tTvKudRDkMR1fh3OYgYO8R9IiOTg9gvspuGQArPQbtrX1n+dnAfduiq72DWisG7EqwL6Ah/e9NEfWv7OSWX2h9xjnocQEHByrO0xG3yLzsbLzUyW35Z2gWaYlFBDsbgWjSUAceN69nJVic69JgPsHxNyOxOz2ihin+zVV8xmGSoucIM+u0kz1oZ8kra90Y5qwRg9b5Obrr7fWwkfuTqADTFRbmv606wJv1FHMIZg864yAT0XeTrhIrAspkQgRfitBcNFvyRttWTKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7097.namprd11.prod.outlook.com (2603:10b6:510:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.7; Mon, 12 Jan 2026 02:14:53 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 02:14:53 +0000
Date: Mon, 12 Jan 2026 10:12:11 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>, Vishal Annapurve
	<vannapurve@google.com>, Sean Christopherson <seanjc@google.com>,
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<x86@kernel.org>, <rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kas@kernel.org>, <tabba@google.com>, <michael.roth@amd.com>,
	<david@kernel.org>, <sagis@google.com>, <vbabka@suse.cz>,
	<thomas.lendacky@amd.com>, <nik.borisov@suse.com>, <pgonda@google.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <francescolavra.fl@gmail.com>,
	<jgross@suse.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <kai.huang@intel.com>, <binbin.wu@linux.intel.com>,
	<chao.p.peng@intel.com>, <chao.gao@intel.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Message-ID: <aWRW51ckW2pxmAlK@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com>
 <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com>
 <aV4hAfPZXfKKB+7i@yzhao56-desk.sh.intel.com>
 <diqzqzrzdfvh.fsf@google.com>
 <aWDH3Z/bjA9unACB@yzhao56-desk.sh.intel.com>
 <CAGtprH-E1iizdDE5PD9E3UHXJHNiiu2H4du9NkVt6vNAhV=O4g@mail.gmail.com>
 <CAEvNRgGk73cNFSTBB2p4Jbc-KS6YhU0WSd0pv9JVDArvRd=v4g@mail.gmail.com>
 <aWRQ2xyc9coA6aCg@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aWRQ2xyc9coA6aCg@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SI2PR01CA0008.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cfbe66d-a609-4273-0081-08de51805fa4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NWlRUVFoSk5zb1lZQkVyMjZaMW1GWFB2L2hQNFBhWVMwVkludllORUwzS3o2?=
 =?utf-8?B?V1ZlSFJZOURPcVY2QlQ3OGI0bkRwNmJwTVAxMHFlSkxIRHpORWxMdWdrNFFT?=
 =?utf-8?B?WGpIMDR4cWdyVDUzMlN0ZVpucGRzTHM0UWhTaGNzaHZjNlFiSVdtZjdjS1gw?=
 =?utf-8?B?RS9XUHZ3QkY2Wmx6VEFtZENrSzFhajFtWWRiQUtZK0ZzSGxzYXRBdklUaE1D?=
 =?utf-8?B?TklER2svdkdxdGZVWHZlWmpkSjdjaVEwVGs5b2lGeWN2NU5vV3MrM3o2cHVM?=
 =?utf-8?B?YmFhL3NEU3pqSkVWWjYwbTczYzV2K1VZRjBBNEZZRHllYjRLTzVLSjNGckx1?=
 =?utf-8?B?cE5EZitRTkZrYVRWdU41UVlIMzlsMFhnWjEyZ1U1eUk2ZE5GNmJVMmlScXV3?=
 =?utf-8?B?ZXpPRDlvYWxzWHBkUGlocmlTT2xDK3lqaENnS3A3WExCK1NrWWRDRVVPdEJr?=
 =?utf-8?B?am5wOVlKSGhQcG5mbWpEdkRiMDRHaDBkazRwWUlRT21qQXdTVi9BQjV6Kzhi?=
 =?utf-8?B?aE5udVMwb3pIWmtJWWdFbkg5aDZWMU9PV3NSMU94bHhjeDdjVDZJWHNKUVZW?=
 =?utf-8?B?aWhSblYyaWlIY3ZMNmtSRmtZa1YzUWptelRoWnRWbjJkUE9waWxvcXM3ZDYx?=
 =?utf-8?B?RFJBY3ZVM1BOK0t2MklVMmQ1eE1aUENnZGs2d3Jucy9rUlhxK240V0o0RWNY?=
 =?utf-8?B?UnhoRGlsYUxFelhxSWY4ZDJSUmV3NTdxaG1GZFNIbit4NTBDY2l4eWdCdlZu?=
 =?utf-8?B?TDdhenZJNHR5K1d0eVV2SGVSQ0QvUFFiSGxTMmdEOFRvejlqeW1uTVQwZC9p?=
 =?utf-8?B?bDJ0MXN1OWRKbFp2eklkMDh3UjcrUEg4TlVYWHNXSHNoNE1EL3Z2U0wyWUoy?=
 =?utf-8?B?MGxFdUhTWnlNaEowR3pnR3FzRHF0eGEvcmJkRzd0VGtBQk8wRURIdTN0Zk40?=
 =?utf-8?B?SFlxV3VxMUpxRTU1WkoxNENVU1lNZzlUWjJwR0QzT0xQOHJiV3JmZDNxVHZa?=
 =?utf-8?B?Z1pxcVkzSC91NlpyYlVIL2IzTlA0blhoMTdGMFFqQW5Ndis0ZHYxV3JvQmRX?=
 =?utf-8?B?K2p2L2grekFaUnJDbE9tNE9VNGdnMGJaTzBUWE9ZU2Z1eUFiVmcybEZrWkZ0?=
 =?utf-8?B?YVAyOUFGU1ppc0ZjYkNKa21nNkdzanhONS9GOFJUaHcveUxhRVEwY2lCVW9x?=
 =?utf-8?B?QUtnQUE5Z3grM2xHRHlvOHVwcnZ2QTlqRjZZNUJRZENoNmRLNThkVmpDMTFt?=
 =?utf-8?B?bUdEL3BycnZGdEdTQjBMNXZIaVdWcnJFSGpueUpMMkpHSmRSMXFpdERLNFFS?=
 =?utf-8?B?VnZjSm8zcllEeFJRUGVaMFYzRVoybC9lTVhvcFY5Z0ZuRzBHR2YrNFRhUUNp?=
 =?utf-8?B?WC9KU241SXFnVTlYN2dybUM3Ulhlem4wSEJNYjdYak04SkR0amp6d05OOTFZ?=
 =?utf-8?B?cW5YQ2NDb2FaUEpOWElHUS9sb2paMHA2RkJGcExmOTZJblp4cU5SdjV6bTNG?=
 =?utf-8?B?STFwTnlnWXFnaXhWYm91L3hqRG9KaHlVYVR4WW9tSnpidlBsdDJBbDVVTmlx?=
 =?utf-8?B?T1loVVNTeEh0SzlpaXdiclBHVllMTFZtMGJzV1BUWkx4Z0hpRjVmS0RWK2Z2?=
 =?utf-8?B?T1hjZU4yTkNRQUErY2pXOUJIek5lV1E3ckZObUYxL2pWTXBsMUR5L0JJN0JZ?=
 =?utf-8?B?eE9ja3ZnT3NnSkJqdzF2c09DY1FrNWNHZnlsZm9mdzVXUTdqVG1TNkVXVVpL?=
 =?utf-8?B?T1c4Z1NJVXJzclBuanI4bGxEd2FmYisxcnlNL3VPa3QrTERLdEZqZUpCMEhq?=
 =?utf-8?B?eEM0QU8vM1FFMUJZTFo2R0dzTmxKSk9BOFFaNUVNNzZlbDliRk1KcEpONTBw?=
 =?utf-8?B?MW1qWWdNU2Z4MW0vdTVDK1ZWSnpWQ3pSVXlFemczVVRId09qMFdqTlNvMCtU?=
 =?utf-8?B?ZCtsMHN1dnBZSDgrZnUyK3o5VUI5Z2thS1lkUEhpU1didDg0bzk5K2ErRkN4?=
 =?utf-8?Q?3A/XBt2faXiua2sZgrE58ov5qs9MrM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzhJcFpvajRHQjVmU3RZTVo0ZDBTbDNKbHgvcmtQTjdRU0t3TGR3TThvUHdv?=
 =?utf-8?B?d01kOFl3NFhpTDF6SHhjNUo0WHJvWEdEQUt2SmplaXBnUlhnQTZBLy9aT3Rn?=
 =?utf-8?B?am9EWi9MVDV1b0w0ZGRwWC9HVWIvZWNEQ3AzcE93YTBzNWF2TXAwaUF3eGhR?=
 =?utf-8?B?cXZ1NzlFMXE3blhQQWpZOHBHcVJmM2tEemFockFDMlBUT1JkRTRhd3NSN3Np?=
 =?utf-8?B?cjVUS3Fma0RKbjZ4RmYxbW9Kc1ozRjhkMmpnd29va0lpU3hwQUJDR3c0c1px?=
 =?utf-8?B?bGdRS2pFNzJncGxaQUV3d2hudXlEdnpjY29Ma2p3YVN2Y0hWWXY3dHNPYzEv?=
 =?utf-8?B?Y2dyVDY5Q2ZxWE1UTW5NZlYvYnNWa1dDaGhuaWpHeDV2YmoveTUxNVJZS3lL?=
 =?utf-8?B?OFExdEh6Z0picWptQjBnTmZ5ZTZRaWpzUnB4QVRjTTZvUGV4OG1UY0pOTHEx?=
 =?utf-8?B?V1RWem5YV1p2ZGgza0YzL2dBdEtocDU4a1RXbUUvbU5MaDhmRU0vNmpkeGZM?=
 =?utf-8?B?eUhUUlpKS2lNcW93YmgrdGkyc1VvanZlZ1EvdktZVzZqbmd2S0FjMVMvQnhE?=
 =?utf-8?B?NDJuQ3BRT3hpWWFVbmNoZS9NUkhKWUZHblNTcUoyd3ZIR090Q0JkWm0reHBP?=
 =?utf-8?B?cWROSW1KM3lsVVQ5ZUlVcmZFbjZwOCszcDhPMS9GRUovaVBhc2NTR2ZnVENU?=
 =?utf-8?B?SThFRHd6M0dtUWkwUENmRmFSbmNMekVqNUtnZFpZb2VQN0toczhxY2R3SVJo?=
 =?utf-8?B?VjRDUGpiS2ZWOU9jN1piOUtYRGQ1dkdiZVhZMzNTbENnUzhCMW1KY3NMSVA5?=
 =?utf-8?B?RDllYVZhalZGUWYwNDViSXRFSUZIMDAvOURpdUJUc0R2NFkrQ01CYllaNWdn?=
 =?utf-8?B?VjRIWnNBd1dtL2E3YUVBWDRoeXFWYjBzWXhTdzQyY2lPNC94VTNTNWFCaDVk?=
 =?utf-8?B?QjYvRmtYdjBjck9FTEhGanh3TncvWUlZUTgrb3lJREpvNWJrTFhwKzJ2Rno3?=
 =?utf-8?B?ZGFEc2phM0VFUDJ3MDNJVThTODFIbDNQbUtBcnhSd3BTbkYrekdoWVFnK2FT?=
 =?utf-8?B?ZkVBRG4waVVaMVFKVnBFZ1FtN1lESnJoVEZ5eTlwVFFjeTd3bklXZGVZMkFq?=
 =?utf-8?B?Um9uckE0YnQwSk5JQyt6cWdqcGhXRUNUeXlRVURHQUVPOTVWYjFMOGJ0UDBi?=
 =?utf-8?B?S2MxbzF4QWtycjc5UTdELyt1elJnTktBY2pMUGVZV2NGU1NMb2RNRGt6NEx6?=
 =?utf-8?B?WGk2TVdJdnlhYmg1dXNmLzZDVWk2VktiQWdvc20wQU1GaW43dE9DRkFULzRR?=
 =?utf-8?B?YVlvYmZwVDAwbXc4SkpqTFhMY1VqOSs3WXJDeGgvV0gvRmNQOW1QSEozZ2Y1?=
 =?utf-8?B?Mnh6Zm04K0tPUGFwcXNiSVg5SUJGWFRoZU9FLy84OUZITUw4dklqS2t3Q2ll?=
 =?utf-8?B?QjFBdGE3OTllZDhEMllrSDJJSnNEQmdXZUw4ckNkc2RyaUVTK1FLV1B3OVQ2?=
 =?utf-8?B?TUtaSTRJOFlYTkMyUGwzOVFHZDg1ZW15VHpTQ1dSY3hUd1RCSFVreDdVeDNt?=
 =?utf-8?B?VFA2TXdacnZheG9xdHRxZGdVQXMxaFRXVVBSMzVHZ1c2eTc5K0J0RUhESXJt?=
 =?utf-8?B?NEUyL09GUXg4cHVYbE80TlRjdFdnQjhWVWpwUHErYmg5OTQrekpYOW5BNDF6?=
 =?utf-8?B?ZzJuOVYxNVhCUE0zNFBmeU1DTzVDbTVwQlZDZkJkMjg3MzlmYUpqVFVHcDl3?=
 =?utf-8?B?RmVyUXI4WVhhOERJdythTU15ZHhSckRqdHc4U05BOU9yUm1PTXZHd3dQWnFQ?=
 =?utf-8?B?YytjT3VNMFRIVEltNXlKZDJuWk9uOXo0Mk9kYUtpNm5CTmx0L0lpb3lCRHBX?=
 =?utf-8?B?a0t0Z1E3bFBuSmZ2VzNJMXdvL1ZKVGxGdUljb3N3U1pNU3h2WFEwV0dOa3VS?=
 =?utf-8?B?ZTNDTjJDakcvQXgrV3lDb3ZXclBvc2t2cDA2cG9wcXFHZ2ViMEU5enp2N29s?=
 =?utf-8?B?R3N0RytLdGZ1dUZPT3ZYelFOdWl0YUJFeGxEUDA3N2tFRVV4YlpnV2RzejFh?=
 =?utf-8?B?em91ejVCcGNJRkc2SWtZTXhGWGhHampTYUpQNVRveWU4elZDaDE0MWxzMEho?=
 =?utf-8?B?SzJUaGpGUmZwTEdza0dBOW9CcnBXRnVYOUdqL2RXQk85d1ZIMitJeFFRby9v?=
 =?utf-8?B?a2c2SDdrcjZqc2VzbkNTVUpJUk96YVpETmNoSk8vcU1xa21GQml3WUt3cGJt?=
 =?utf-8?B?QzRBY1BUMjd6NjFQd2RlVlJuTW1YYzFYUUtrTmdLdVdMcnhDUnp1S0VZVnJv?=
 =?utf-8?B?dllNNXpkZVVHR1hJSmlDQ3ZuWGNJQW1rZzQ3UjlwS3ErZ0VrYkZKQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cfbe66d-a609-4273-0081-08de51805fa4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 02:14:53.6771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M0QREYnDbJW3FYEi8XtV25lCXfXG3Rc6z97OX5ed14gHC9z08NQMAKAC9fC5e4DaTR4X8PyaIKU46wWbbZjPQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7097
X-OriginatorOrg: intel.com

On Mon, Jan 12, 2026 at 09:39:39AM +0800, Yan Zhao wrote:
> On Fri, Jan 09, 2026 at 10:07:00AM -0800, Ackerley Tng wrote:
> > Vishal Annapurve <vannapurve@google.com> writes:
> > 
> > > On Fri, Jan 9, 2026 at 1:21 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >>
> > >> On Thu, Jan 08, 2026 at 12:11:14PM -0800, Ackerley Tng wrote:
> > >> > Yan Zhao <yan.y.zhao@intel.com> writes:
> > >> >
> > >> > > On Tue, Jan 06, 2026 at 03:43:29PM -0800, Sean Christopherson wrote:
> > >> > >> On Tue, Jan 06, 2026, Ackerley Tng wrote:
> > >> > >> > Sean Christopherson <seanjc@google.com> writes:
> > >> > >> >
> > >> > >> > > On Tue, Jan 06, 2026, Ackerley Tng wrote:
> > >> > >> > >> Vishal Annapurve <vannapurve@google.com> writes:
> > >> > >> > >>
> > >> > >> > >> > On Tue, Jan 6, 2026 at 2:19 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >> > >> > >> >>
> > >> > >> > >> >> - EPT mapping size and folio size
> > >> > >> > >> >>
> > >> > >> > >> >>   This series is built upon the rule in KVM that the mapping size in the
> > >> > >> > >> >>   KVM-managed secondary MMU is no larger than the backend folio size.
> > >> > >> > >> >>
> > >> > >> > >>
> > >> > >> > >> I'm not familiar with this rule and would like to find out more. Why is
> > >> > >> > >> this rule imposed?
> > >> > >> > >
> > >> > >> > > Because it's the only sane way to safely map memory into the guest? :-D
> > >> > >> > >
> > >> > >> > >> Is this rule there just because traditionally folio sizes also define the
> > >> > >> > >> limit of contiguity, and so the mapping size must not be greater than folio
> > >> > >> > >> size in case the block of memory represented by the folio is not contiguous?
> > >> > >> > >
> > >> > >> > > Pre-guest_memfd, KVM didn't care about folios.  KVM's mapping size was (and still
> > >> > >> > > is) strictly bound by the host mapping size.  That's handles contiguous addresses,
> > >> > >> > > but it _also_ handles contiguous protections (e.g. RWX) and other attributes.
> > >> > >> > >
> > >> > >> > >> In guest_memfd's case, even if the folio is split (just for refcount
> > >> > >> > >> tracking purposese on private to shared conversion), the memory is still
> > >> > >> > >> contiguous up to the original folio's size. Will the contiguity address
> > >> > >> > >> the concerns?
> > >> > >> > >
> > >> > >> > > Not really?  Why would the folio be split if the memory _and its attributes_ are
> > >> > >> > > fully contiguous?  If the attributes are mixed, KVM must not create a mapping
> > >> > >> > > spanning mixed ranges, i.e. with multiple folios.
> > >> > >> >
> > >> > >> > The folio can be split if any (or all) of the pages in a huge page range
> > >> > >> > are shared (in the CoCo sense). So in a 1G block of memory, even if the
> > >> > >> > attributes all read 0 (!KVM_MEMORY_ATTRIBUTE_PRIVATE), the folio
> > >> > >> > would be split, and the split folios are necessary for tracking users of
> > >> > >> > shared pages using struct page refcounts.
> > >> > >>
> > >> > >> Ahh, that's what the refcounting was referring to.  Gotcha.
> > >> > >>
> > >> > >> > However the split folios in that 1G range are still fully contiguous.
> > >> > >> >
> > >> > >> > The process of conversion will split the EPT entries soon after the
> > >> > >> > folios are split so the rule remains upheld.
> > >> >
> > >> > Correction here: If we go with splitting from 1G to 4K uniformly on
> > >> > sharing, only the EPT entries around the shared 4K folio will have their
> > >> > page table entries split, so many of the EPT entries will be at 2M level
> > >> > though the folios are 4K sized. This would be last beyond the conversion
> > >> > process.
> > >> >
> > >> > > Overall, I don't think allowing folios smaller than the mappings while
> > >> > > conversion is in progress brings enough benefit.
> > >> > >
> > >> >
> > >> > I'll look into making the restructuring process always succeed, but off
> > >> > the top of my head that's hard because
> > >> >
> > >> > 1. HugeTLB Vmemmap Optimization code would have to be refactored to
> > >> >    use pre-allocated pages, which is refactoring deep in HugeTLB code
> > >> >
> > >> > 2. If we want to split non-uniformly such that only the folios that are
> > >> >    shared are 4K, and the remaining folios are as large as possible (PMD
> > >> >    sized as much as possible), it gets complex to figure out how many
> > >> >    pages to allocate ahead of time.
> > >> >
> > >> > So it's complex and will probably delay HugeTLB+conversion support even
> > >> > more!
> > >> >
> > >> > > Cons:
> > >> > > (1) TDX's zapping callback has no idea whether the zapping is caused by an
> > >> > >     in-progress private-to-shared conversion or other reasons. It also has no
> > >> > >     idea if the attributes of the underlying folios remain unchanged during an
> > >> > >     in-progress private-to-shared conversion. Even if the assertion Ackerley
> > >> > >     mentioned is true, it's not easy to drop the sanity checks in TDX's zapping
> > >> > >     callback for in-progress private-to-shared conversion alone (which would
> > >> > >     increase TDX's dependency on guest_memfd's specific implementation even if
> > >> > >     it's feasible).
> > >> > >
> > >> > >     Removing the sanity checks entirely in TDX's zapping callback is confusing
> > >> > >     and would show a bad/false expectation from KVM -- what if a huge folio is
> > >> > >     incorrectly split while it's still mapped in KVM (by a buggy guest_memfd or
> > >> > >     others) in other conditions? And then do we still need the check in TDX's
> > >> > >     mapping callback? If not, does it mean TDX huge pages can stop relying on
> > >> > >     guest_memfd's ability to allocate huge folios, as KVM could still create
> > >> > >     huge mappings as long as small folios are physically contiguous with
> > >> > >     homogeneous memory attributes?
> > >> > >
> > >> > > (2) Allowing folios smaller than the mapping would require splitting S-EPT in
> > >> > >     kvm_gmem_error_folio() before kvm_gmem_zap(). Though one may argue that the
> > >> > >     invalidate lock held in __kvm_gmem_set_attributes() could guard against
> > >> > >     concurrent kvm_gmem_error_folio(), it still doesn't seem clean and looks
> > >> > >     error-prone. (This may also apply to kvm_gmem_migrate_folio() potentially).
> > >> > >
> > >> >
> > >> > I think the central question I have among all the above is what TDX
> > >> > needs to actually care about (putting aside what KVM's folio size/memory
> > >> > contiguity vs mapping level rule for a while).
> > >> >
> > >> > I think TDX code can check what it cares about (if required to aid
> > >> > debugging, as Dave suggested). Does TDX actually care about folio sizes,
> > >> > or does it actually care about memory contiguity and alignment?
> > >> TDX cares about memory contiguity. A single folio ensures memory contiguity.
> > >
> > > In this slightly unusual case, I think the guarantee needed here is
> > > that as long as a range is mapped into SEPT entries, guest_memfd
> > > ensures that the complete range stays private.
> > >
> > > i.e. I think it should be safe to rely on guest_memfd here,
> > > irrespective of the folio sizes:
> > > 1) KVM TDX stack should be able to reclaim the complete range when unmapping.
> > > 2) KVM TDX stack can assume that as long as memory is mapped in SEPT
> > > entries, guest_memfd will not let host userspace mappings to access
> > > guest private memory.
> > >
> > >>
> > >> Allowing one S-EPT mapping to cover multiple folios may also mean it's no longer
> > >> reasonable to pass "struct page" to tdh_phymem_page_wbinvd_hkid() for a
> > >> contiguous range larger than the page's folio range.
> > >
> > > What's the issue with passing the (struct page*, unsigned long nr_pages) pair?
> > >
> > >>
> > >> Additionally, we don't split private mappings in kvm_gmem_error_folio().
> > >> If smaller folios are allowed, splitting private mapping is required there.
> > 
> > It was discussed before that for memory failure handling, we will want
> > to split huge pages, we will get to it! The trouble is that guest_memfd
> > took the page from HugeTLB (unlike buddy or HugeTLB which manages memory
> > from the ground up), so we'll still need to figure out it's okay to let
> > HugeTLB deal with it when freeing, and when I last looked, HugeTLB
> > doesn't actually deal with poisoned folios on freeing, so there's more
> > work to do on the HugeTLB side.
> > 
> > This is a good point, although IIUC it is a separate issue. The need to
> > split private mappings on memory failure is not for confidentiality in
> > the TDX sense but to ensure that the guest doesn't use the failed
> > memory. In that case, contiguity is broken by the failed memory. The
> > folio is split, the private EPTs are split. The folio size should still
> > not be checked in TDX code. guest_memfd knows contiguity got broken, so
> > guest_memfd calls TDX code to split the EPTs.
> 
> Hmm, maybe the key is that we need to split S-EPT first before allowing
> guest_memfd to split the backend folio. If splitting S-EPT fails, don't do the
> folio splitting.
> 
> This is better than performing folio splitting while it's mapped as huge in
> S-EPT, since in the latter case, kvm_gmem_error_folio() needs to try to split
> S-EPT. If the S-EPT splitting fails, falling back to zapping the huge mapping in
> kvm_gmem_error_folio() would still trigger the over-zapping issue.
> 
> In the primary MMU, it follows the rule of unmapping a folio before splitting,
> truncating, or migrating a folio. For S-EPT, considering the cost of zapping
> more ranges than necessary, maybe a trade-off is to always split S-EPT before
> allowing backend folio splitting.
> 
> Does this look good to you?
So, the flow of converting 0-4KB from private to shared in a 1GB folio in
guest_memfd is:

a. If guest_memfd splits 1GB to 2MB first:
   1. split S-EPT to 4KB for 0-2MB range, split S-EPT to 2MB for the rest range.
   2. split folio
   3. zap the 0-4KB mapping.

b. If guest_memfd splits 1GB to 4KB directly:
   1. split S-EPT to 4KB for 0-2MB range, split S-EPT to 4KB for the rest range.
   2. split folio
   3. zap the 0-4KB mapping.

The flow of converting 0-2MB from private to shared in a 1GB folio in
guest_memfd is:

a. If guest_memfd splits 1GB to 2MB first:
   1. split S-EPT to 4KB for 0-2MB range, split S-EPT to 2MB for the rest range.
   2. split folio
   3. zap the 0-2MB mapping.

b. If guest_memfd splits 1GB to 4KB directly:
   1. split S-EPT to 4KB for 0-2MB range, split S-EPT to 4KB for the rest range.
   2. split folio
   3. zap the 0-2MB mapping.

> So, to convert a 2MB range from private to shared, even though guest_memfd will
> eventually zap the entire 2MB range, do the S-EPT splitting first! If it fails,
> don't split the backend folio.
> 
> Even if folio splitting may fail later, it just leaves split S-EPT mappings,
> which matters little, especially after we support S-EPT promotion later.
> 
> The benefit is that we don't need to worry even in the case when guest_memfd
> splits a 1GB folio directly to 4KB granularity, potentially introducing the
> over-zapping issue later.
> 
> > > Yes, I believe splitting private mappings will be invoked to ensure
> > > that the whole huge folio is not unmapped from KVM due to an error on
> > > just a 4K page. Is that a problem?
> > >
> > > If splitting fails, the implementation can fall back to completely
> > > zapping the folio range.
> > >
> > >> (e.g., after splitting a 1GB folio to 4KB folios with 2MB mappings. Also, is it
> > >> possible for splitting a huge folio to fail partially, without merging the huge
> > >> folio back or further zapping?).
> > 
> > The current stance is to allow splitting failures and not undo that
> > splitting failure, so there's no merge back to fix the splitting
> > failure. (Not set in stone yet, I think merging back could turn out to
> > be a requirement from the mm side, which comes with more complexity in
> > restructuring logic.)
> > 
> > If it is not merged back on a split failure, the pages are still
> > contiguous, the pages are guaranteed contiguous while they are owned by
> > guest_memfd (even in the case of memory failure, if I get my way :P) so
> > TDX can still trust that.
> > 
> > I think you're worried that on split failure some folios are split, but
> > the private EPTs for those are not split, but the memory for those
> > unsplit private EPTs are still contiguous, and on split failure we quit
> > early so guest_memfd still tracks the ranges as private.
> > 
> > Privateness and contiguity are preserved so I think TDX should be good
> > with that? The TD can still run. IIUC it is part of the plan that on
> > splitting failure, conversion ioctl returns failure, guest is informed
> > of conversion failure so that it can do whatever it should do to clean
> > up.
> As above, what about the idea of always requesting KVM to split S-EPT before
> guest_memfd splits a folio?
> 
> I think splitting S-EPT first is already required for all cases anyway, except
> for the private-to-shared conversion of a full 2MB or 1GB range.
> 
> Requesting S-EPT splitting when it's about to do folio splitting is better than
> leaving huge mappings with split folios and having to patch things up here and
> there, just to make the single case of private-to-shared conversion easier.
> 
> > > Yes, splitting can fail partially, but guest_memfd will not make the
> > > ranges available to host userspace and derivatives until:
> > > 1) The complete range to be converted is split to 4K granularity.
> > > 2) The complete range to be converted is zapped from KVM EPT mappings.
> > >
> > >> Not sure if there're other edge cases we're still missing.
> > >>
> > 
> > As you said, at the core TDX is concerned about contiguity of the memory
> > ranges (start_addr, length) that it was given. Contiguity is guaranteed
> > by guest_memfd while the folio is in guest_memfd ownership up to the
> > boundaries of the original folio, before any restructuring. So if we're
> > looking for edge cases, I think they would be around
> > truncation. Can't think of anything now.
> Potentially, folio migration, if we support it in the future.
> 
> > (guest_memfd will also ensure truncation of anything less than the
> > original size of the folio before restructuring is blocked, regardless
> > of the current size of the folio)
> > >> > Separately, KVM could also enforce the folio size/memory contiguity vs
> > >> > mapping level rule, but TDX code shouldn't enforce KVM's rules. So if
> > >> > the check is deemed necessary, it still shouldn't be in TDX code, I
> > >> > think.
> > >> >
> > >> > > Pro: Preventing zapping private memory until conversion is successful is good.
> > >> > >
> > >> > > However, could we achieve this benefit in other ways? For example, is it
> > >> > > possible to ensure hugetlb_restructuring_split_folio() can't fail by ensuring
> > >> > > split_entries() can't fail (via pre-allocation?) and disabling hugetlb_vmemmap
> > >> > > optimization? (hugetlb_vmemmap conversion is super slow according to my
> > >> > > observation and I always disable it).
> > >> >
> > >> > HugeTLB vmemmap optimization gives us 1.6% of memory in savings. For a
> > >> > huge VM, multiplied by a large number of hosts, this is not a trivial
> > >> > amount of memory. It's one of the key reasons why we are using HugeTLB
> > >> > in guest_memfd in the first place, other than to be able to get high
> > >> > level page table mappings. We want this in production.
> > >> >
> > >> > > Or pre-allocation for
> > >> > > vmemmap_remap_alloc()?
> > >> > >
> > >> >
> > >> > Will investigate if this is possible as mentioned above. Thanks for the
> > >> > suggestion again!
> > >> >
> > >> > > Dropping TDX's sanity check may only serve as our last resort. IMHO, zapping
> > >> > > private memory before conversion succeeds is still better than introducing the
> > >> > > mess between folio size and mapping size.
> > >> > >
> > >> > >> > I guess perhaps the question is, is it okay if the folios are smaller
> > >> > >> > than the mapping while conversion is in progress? Does the order matter
> > >> > >> > (split page table entries first vs split folios first)?
> > >> > >>
> > >> > >> Mapping a hugepage for memory that KVM _knows_ is contiguous and homogenous is
> > >> > >> conceptually totally fine, i.e. I'm not totally opposed to adding support for
> > >> > >> mapping multiple guest_memfd folios with a single hugepage.   As to whether we
> > >> > >> do (a) nothing, (b) change the refcounting, or (c) add support for mapping
> > >> > >> multiple folios in one page, probably comes down to which option provides "good
> > >> > >> enough" performance without incurring too much complexity.
> > >> >
> > 

