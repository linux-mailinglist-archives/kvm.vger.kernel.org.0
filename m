Return-Path: <kvm+bounces-29910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6FF09B3E60
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 00:23:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EEB6FB21C0B
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 23:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F8C91FAC47;
	Mon, 28 Oct 2024 23:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QhkTfwxw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AC21865E3;
	Mon, 28 Oct 2024 23:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730157787; cv=fail; b=T8vDgGx+01xGEObzvLwvpTiZMvsjfqLwkQm/4tQW2Ip3bjtdP31qbzOfTiKYUgMBW05+6oQwgIuwap9s6HCKf2Wyppjrgm+fZebC2gtucIwo7YP5c8wIJyI38vnxF0TUgiBDT11cTFbjdO5lfkZr13XllfgIxc1aIUcMR4Kq0q4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730157787; c=relaxed/simple;
	bh=ZzV/gYDovRCzjPd/ekq3WMNfSe3hFEOcklwFQienERs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UEvUm0NNEp6Ly77SuoHfjkwor8Whcpo9KnN6eQsLf5MITM5DNY488s+nTMxu9q55Lfdfd98R2aVAuEnXcX7QqKYBPcctZxO6Rf4r+Pf6xzyoZ+NbWzjTx+SJsrHA9KuTbAf6fGuJOhWeq2lnuCawnlc/Xx0ZrsuxPDi8UhpWjLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QhkTfwxw; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730157786; x=1761693786;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZzV/gYDovRCzjPd/ekq3WMNfSe3hFEOcklwFQienERs=;
  b=QhkTfwxwX+Qf9MBRnZvrk043uxzgCkRo0l+Zdo5efH7geSoTKofD5AtG
   dJ+dBZ4JQznDiPRJC3kC9qw4TS7x1L4SYDqSzGXtCsHmeDdnkjA245XxE
   2lf7SKrHgp/dj27pRhkmt9NLkJzAEeW/JvaDHrKMQmu7cbpvRtQ2iOkDg
   Omcxi+cnCC9QnUkrZ6gJjJE8R3NUxs7PmEbxsk1DOjzbgNYbvCIRV+TUa
   rO80Udzhzr/RM0t88gYB1DRFnEMeEcFbknVSgYkZrNLZOau74aeZQxxD7
   Tc/OXiVoN46FKqRp1aU3eAL5m+ujd1TzjSQFK15dKzNJMEUFFwsAATKXt
   A==;
X-CSE-ConnectionGUID: NCoVGSw5QVaDH1viZBZLBQ==
X-CSE-MsgGUID: b9vIdwaUQoaW0d/UwuHRgQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11239"; a="55178149"
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="55178149"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 16:23:05 -0700
X-CSE-ConnectionGUID: MWA5wPObRNScTFBxhun/SQ==
X-CSE-MsgGUID: OBM2oZEUSGOflhCvZNNhmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="81335365"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 16:23:04 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 16:23:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 16:23:04 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 16:22:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C8v+WSwjT5UBSAFq4jrRm1KjND2cGDBc82cb8Mj56Yx5sT8JPpgygz/G+fgvHSCpvWcO6mE0fxVX4a0xGx/Z2lKS38ob6ZGQ6gvWX5pYtTF2bjxG+6adZRxpmoMI7hrP6t5ljJa54DVMecrWywAsjN8kBNjGaSGvAmNm+/9J/eQHbftYTgp//6dO7pONOVKIP6RX5pKzE3Fq/PUShvdOLQ/svJvekpX8pq1Tfjt7YGZAnJLCN0/wFm+NA90tcYn7WSqP0XCRyKaNY/deZnbq+7aPGE04cEBPVBkvWGxGqCchzuv3XgeIIxVyIEz3hwQN4KWmpRaHrKI7wVpQ8zWqAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bVtevW1VdP/PZAn6x7HEFOJcgd2uICc22eUokdzxk18=;
 b=pqvLWeZ3agIBKQKvJaaBG70ZAgJH5YpGl1WmIkd3oV0+SnGYfljZY7pShKepT8oj/CRms6hkyk1hNLO5bGZr5GJHkJvbc63Z+LhHFWKZLmCW9C5IP2uJs/Am5O6aSZJMnDpCSDVmnuH1maL7D9QMkmyCwh2YuJS1I1y2EJIxA0VpSaw7UqaY2hrx4W0EDQxJDOFk4jbqZhRqQKjaY1C7aidV+zlx79IjP5wLqcoFJ4Zy7RDR0wXJ2DSxDV5wLnyAQ8fTKidjARL9WO+tPzrE8SiyBEQU2uFr2398QXZ2OUFVCamUVjS5Rcbkz9AP0LbEmCRoQdi5oY8c/gTFlQU6GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7712.namprd11.prod.outlook.com (2603:10b6:510:290::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Mon, 28 Oct
 2024 23:22:41 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8093.023; Mon, 28 Oct 2024
 23:22:41 +0000
Message-ID: <64eaba98-e1c9-4667-9825-a64e157d4dfb@intel.com>
Date: Tue, 29 Oct 2024 12:22:31 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/10] x86/virt/tdx: Reduce TDMR's reserved areas by
 using CMRs to find memory holes
To: Dan Williams <dan.j.williams@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<adrian.hunter@intel.com>, <nik.borisov@suse.com>
References: <cover.1730118186.git.kai.huang@intel.com>
 <b152bd39f9b235d5b20b8579a058a7f2bdbc111d.1730118186.git.kai.huang@intel.com>
 <67200f7c12a55_bc69d29456@dwillia2-xfh.jf.intel.com.notmuch>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <67200f7c12a55_bc69d29456@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:a03:217::20) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB7712:EE_
X-MS-Office365-Filtering-Correlation-Id: df29b984-9fc9-4349-8cdc-08dcf7a76b16
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QmU1a0JYcDRhVTFDc3p3QmNOM05JRkVLSE8wUlBnRG92bldyZWx5L2o3TDFw?=
 =?utf-8?B?d1pEcDNHc0s5WmZEcFg0MTdmTXpua3VIb1RpQ05TUkhtY3JyMHNaa2pIVHJF?=
 =?utf-8?B?M2hQZmsrRlBhT1Y0RG9JUGQ4OVNsVU5QWnpNaTRNQnFhSTBlVGJKMXYxY2d4?=
 =?utf-8?B?WHd2MGRzN0lmRi9VSDBLYThwbDRRWXZpQ3p3Q3JrT0drTWRqRXpLQWZhTFJw?=
 =?utf-8?B?Q1RBeUtGbnQ5Y2NRdmtxTkZYdjhpUWw3VitVcEp0WXJobk1wYUJodFEvSFRp?=
 =?utf-8?B?ZWNCVUo2ZW9vd05aUWkxQ3ZJY1RBY3FDSnVNS3l1c1M5Uy82VkV0U0E3dEJ6?=
 =?utf-8?B?NUlmT1A5K3A1V0wxNWdpaTJpOWRWRkU2MENlU09MdVNLUUp5SG15azQ0bUEw?=
 =?utf-8?B?WUdxRUFpckwvanN5Qkc5Y0JvMUhHeGhCL2VJdEI0OWxHRThFeE9XSlBmTHNl?=
 =?utf-8?B?TFMvbUlEeU54bmtZdzhCakhOZTdrZ2ozTGkzZ0pKTWpWbXFkOUdLYS9HYkJQ?=
 =?utf-8?B?NHI5QUVzaFo0R2RsZEFnam9LZGVvdElvUmE2SWExNklKcnc3WkkzVGoyYzhs?=
 =?utf-8?B?L25GOUM1MmliaEw5V08vU2prUStraDcraDJybm92TGdINlZYeit6YVVzSXVh?=
 =?utf-8?B?Y0lOTDJueFlVaE5DQzZKV2VLdy84U1d0UUhGelU3eVFqWGpKYzNaeVZjOFZZ?=
 =?utf-8?B?SGN5U0JZby9KSVJBQVhXUFZ6QWZQU0pJa0hvdXVZb3JqR0UwejVIUFRvNG1U?=
 =?utf-8?B?anBkQm1vbVhmbWpiMnpvMDZiQmZKVGJQSEJlbmxGcCtDd3N5R0UxLzQvcXMz?=
 =?utf-8?B?NHBOL05KeUgxWnVCaXdyU3VVNTFDRW5UbzUrL2tpTm9yUWQzZ0tObzBoMFY4?=
 =?utf-8?B?TGVicXFDYWV3Nm1MVktjZ2c0MjVmdGVsNSs2d3h5YWRkb3dZeFhGM3k0SXhZ?=
 =?utf-8?B?UXl3WGEzRmRWang5dWMyWlNibTRwSlNNYTRldHdFMUlreTNOc2VvUzVYYnd4?=
 =?utf-8?B?ZzZCaWk0cEJVaGpQaUxUdUtmQ1lGL1hPditnM0VaNEFsZWVWVFQvWndwdU5H?=
 =?utf-8?B?U0huVkJTdndKTmowZXJ6QWw2bzNiZXEvamswbE15S3oxa3U3V3diaXpYQldE?=
 =?utf-8?B?MitFT1NDdVNRV1VQdDBJSGdvazNEdTcwRjZmQ04vZzRqVzhGcUpsZHZoa1pp?=
 =?utf-8?B?ZDlYVnNmMEFxNmJtZkVrbnhWR2tPS0pDNTZ4WmdzeTNCV2VCb2tVL09DZG9j?=
 =?utf-8?B?TVFHcTIvN1F5RmNwQ203ZUdlTFZJV1VpWFA1YlNzUERKRW53NGd3Nkl0YVdO?=
 =?utf-8?B?ZWxrNkNsK0lQWEtvS2RacEtEbVhLSUwvNjJ6enlJb0ROaWZsYVd2TytJZFVh?=
 =?utf-8?B?UmZ3YmNzU2I2WmNQamNVQ1hyYkVOYnBpVDVFQ1FpNHdXUWxiSTlibmwxT1lT?=
 =?utf-8?B?Qi9rWERDNEVKbEkxVDZrSXlzQ0RWdWg1ZS9CQXpMMUVwcTJ2REVwMXl0Tnox?=
 =?utf-8?B?bElWTmphZW9XS3dQMlN2M1hhWmZzZlY5MlJzWVFYcW5lZ3Ezb00yVVlaSHVW?=
 =?utf-8?B?Z2ZVaGwrVWpwc0pMN3ZQMjhMcTJHM0UvN3ZkcUhyK3hpeDFHZUpYeFh6Ni9h?=
 =?utf-8?B?WjV5a0c2ZFpraWZjd1prMCt0V0VrcmRzMmZWbzl3ZlFlWENCMFlER0FZTWM0?=
 =?utf-8?B?UEVSNzF5YXVQa29PNSt5WnNvQmNxTTRvM1JrU29FTkQ0cDRHTi9ORVhaKzhR?=
 =?utf-8?B?cHZmdXBVZ0x3YzRpcXhYT3VaUW5qeFIyRWpnSGhJcEJpcEVTdXVZTVVnOEhX?=
 =?utf-8?Q?oS7tr+HSI6iIvsa8jKRKkx6/Id2lGcqgDUV4E=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGVHdUhHb3ZvcjNjV2p1RXdvaFNtTG5ldTQzTktBb0x1WVRXWi83Q3EwL0Zs?=
 =?utf-8?B?NXpkWS9nVURNdWVqaDgvUGtoZWFzckN2STdZMTd3R3VQbVFGRWVZRE1BVWtB?=
 =?utf-8?B?TFFOSURaZ2NzQnNxcnl3QW5LNURrUGpZczlPS2VTak85Vm00VXJTQ0pkQjhZ?=
 =?utf-8?B?UldYNzNHczUxRjRiT1VLcVdqK3BMTFNJVUdTZFAvM2JucGhPNnpVVkwreHZy?=
 =?utf-8?B?dXkwZ3pkZHc1WGVrV0JabndtZmd1UnBvY1BoUnRRa2llcTBQOUVKcmpQaUVC?=
 =?utf-8?B?Z0tMY3NHand4RXFWbW1oMmt6aklvcklTdDU4OGp5RkZ6SHh4TEJCREdLZnZ1?=
 =?utf-8?B?UHdIT1M2VXV2RExCLzhyYWp6dUVGaFVoU2lyM3FUK3FDVEJsUVZqY1I4ejZt?=
 =?utf-8?B?cmRqSzVqNTJxYVZ0KzZ0UFhKd0NJa00xUUJhcEQ1ZDJVVUIvSmNwZ09KTHZa?=
 =?utf-8?B?OHZmVmlRdFAxOXVvdDVRYm5YWlg2b0l6T1dpbWR2b0tNVG1DcEZ1dmg4Wjdu?=
 =?utf-8?B?bzZmd2J3ZzF6dFJwb0x3a2d2SGs1VkJBL0MrNER5Zk1qSWpWVnlqcUwvTWty?=
 =?utf-8?B?cEh2OEY3bFRLcDdtMmZPQy9kYUV6WmpOcXJzc1E0ZDU2RzZjYUc3Ym5aNXNt?=
 =?utf-8?B?bzAxV3NsWU5WaG44ZFk0T2E5bnBVeVk1MWZHQmtDL0ZwZDhmaDhOdXlmLzVv?=
 =?utf-8?B?VGZLMVluRUdMNW9Lc0d4SUluT25RejMveXYyWStDUENON3I3TTlka05DZG52?=
 =?utf-8?B?aVhRQ2txMzVZK29ZOUNMcjFaNWlvbE1TcWlJdTlUOWJpeTNFTmpVOXNkSm5Z?=
 =?utf-8?B?MUh6ZE45TXc0ZVFNMWFzZ01kTSsxUnh0aFh6SDVmK0VkeVdOQkFKV1g2YlhE?=
 =?utf-8?B?M0wxMUJWanE4WHd4ZTJpampmQkxXS3k4UDYvR0VjYldSK2QzTEEzVXNRd3Z4?=
 =?utf-8?B?c0ZCVGJ5VGJUTFdMZzdGNlIxc0RzVG9vazd1U0NPeUtyN0RpcmxiWVQ1YzBK?=
 =?utf-8?B?VS9oVm5yZGVpRGQ5cUYxNFliVmE4KzdISUxaVWlYcUErclVGVXZSejMyQ2lm?=
 =?utf-8?B?Ui9TOWl6SHNYdjlwMEVORkJPSUw5UE03OVFWcEdLR0ZrWFlIT1prTEYrR0pv?=
 =?utf-8?B?aW5zTDdWQ3ZKM2tZckQ0OGplT0Jkc0RhMGh5SlFCd1A5bEx1bFovOS9PUXNs?=
 =?utf-8?B?dUYweTg2U2VDZGNBcDVUVitIMWFCemRQbmNTWkNPVWIzeGNHZ2NLZkl2Q2Y4?=
 =?utf-8?B?UkVkZHk4bkR1SFRMNVJ3U0l4bmJXbnlDaTdyVEwweFFzWVBKdFlRWW95OExv?=
 =?utf-8?B?TXZ6dXp0Qi85TlFFanpVMURvd21zYmJRUUR6Wms1QlRwbjY0YUpzdVRpVlNt?=
 =?utf-8?B?TDJlcU15Yy8rQnltZ2RLVFo1R2lKdktHNmt6ZVVBZFNGUERiYXcyZnorUEtN?=
 =?utf-8?B?SjR4VFFGNGk1ZmhLbkZWem1idmN5MlZ0Y1NZNDZVNlpiMWZ0bTFDVXpVaS9s?=
 =?utf-8?B?OXVDazlEbVhrQWlGV3Azd1hadHYvWHB4WHNBTk5SckVkQXF0QUFZS1laTkVH?=
 =?utf-8?B?RnlhWkE3U0NOaXVRVlJla3ZVb3drcU4wMjllQWRLQlM0b1FMZXkvMU40bmJv?=
 =?utf-8?B?L2lZU0tnSWVKTFMyTEhEa1RZYmREU1ZwUGZQSDJ2SGNMTlV5dTdiWmtCTHRH?=
 =?utf-8?B?RWJsVTV6dTJlUTY3VW5VOFdvbW1WT08yMGlUY3h2d0YrTkIwRFBHR0ZQd3JW?=
 =?utf-8?B?OFMzejdaUE1RZXM0UThwRVlSV293RFN0RVlnSDRYa1p4MGJSeG1DTkRFNDQ0?=
 =?utf-8?B?aHRwK1V3c3NqUktKYktEU2o2U0FCNWIvSDEwNmhtOEJsRFQvS3BCMDVMUGFS?=
 =?utf-8?B?c0VtMWtLUjY2eDdrcE12OTRJSHA2amRpU3dsRlNLVCtmTnByenprUGFCMlZi?=
 =?utf-8?B?Q0xsWnQxbXVhV3g4aG1aa0U5dXg4L3hWT3ZVRmFYaUhTL3I4VXNWWlRUbVRB?=
 =?utf-8?B?WHR6N0h2M3VEbWZBRFI0Q1pnZkhNMDd0M1M4ME13a0VNYnN2WGp3Ti9VemZY?=
 =?utf-8?B?YStDcE9lOU83YTJnSXQyWGZxTWxQQnU1OUJSeTk1U1V3c0xhNVhMY25WODJB?=
 =?utf-8?Q?dCPRAyQ+ssKtzYn9Pgt6XRhyc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df29b984-9fc9-4349-8cdc-08dcf7a76b16
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 23:22:41.0050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SGtT5b3T7BlTrJt7sjm5d7yG1e61yIigKl+RQ6TIPrdS9ZSeTbhkAJv5yvfSRJQnu2+kQrxMn9dmJnEh/XIp6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7712
X-OriginatorOrg: intel.com


>>   	/*
>>   	 * Start looking for reserved blocks at the
>>   	 * beginning of the TDMR.
>>   	 */
>>   	prev_end = tdmr->base;
>> -	list_for_each_entry(tmb, tmb_list, list) {
>> +	for (i = 0; i < sysinfo_cmr->num_cmrs; i++) {
>>   		u64 start, end;
>>   
>> -		start = PFN_PHYS(tmb->start_pfn);
>> -		end   = PFN_PHYS(tmb->end_pfn);
>> +		start = sysinfo_cmr->cmr_base[i];
>> +		end   = start + sysinfo_cmr->cmr_size[i];
> 
> This had me go check the inclusive vs exclusive range comparisons. Even
> though it is not in this patch I think tdmr_populate_rsvd_holes() needs
> this fixup:
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 4e2b2e2ac9f9..b5026edf1eeb 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -776,7 +776,7 @@ static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
>                          break;
>   
>                  /* Exclude regions before this TDMR */
> -               if (end < tdmr->base)
> +               if (end <= tdmr->base)
>                          continue;
>   
>                  /*
> 
> ...because a CMR that ends at tdmr->base is still "before" the TDMR.

I think you are right.  Thanks for catching this.

But in practice this will not cause any problem because the check right 
after it:

                 /*
                  * Skip over memory areas that
                  * have already been dealt with.
                  */
                 if (start <= prev_end) {
                         prev_end = end;
                         continue;
                 }

.. will always be true and effectively skip this region.

So it is just a matter of 'skipping the region one step earlier or later'.

> 
> As that's a separate fixup you can add for this patch.

Yeah I agree logically this fixup is needed.  I'll send out as a 
separate patch and see.

> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Thanks!


