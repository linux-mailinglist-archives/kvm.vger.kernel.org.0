Return-Path: <kvm+bounces-43688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C91FAA940AF
	for <lists+kvm@lfdr.de>; Sat, 19 Apr 2025 03:02:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0D4F8A8172
	for <lists+kvm@lfdr.de>; Sat, 19 Apr 2025 01:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 455AF7080E;
	Sat, 19 Apr 2025 01:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bh222ofK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A8160B8A;
	Sat, 19 Apr 2025 01:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745024534; cv=fail; b=oMU8Q/DtteYc6BKcyT6AFnc1fk5CFirT8IlWWFUI95h8oRUrT+yhXVKeWM+J4O8rxmntwAM2QGaTWhUvplN0li0+F5xuQBrmiaBq/6lxQWhGxXjt19ijqCaapRlha3LVhPFP9ZPIkr2VkUJ9QgiNfuu2M0P/vGv+nt3Tp2fyWnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745024534; c=relaxed/simple;
	bh=CS0TeGJqNsDGS3gdVDRPetbTb9Nvd25wmjZm3BYYFbA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=p1qbBFmDW0fwFGnaqObcqrHtUl4ASeBQoUmrBiEqPSG151HGv2J3KYA5xGlxxal4P7y5JMIc5laHaxmgYh8DVhqeDzHIyCAtuKl8AQ3vdG4d3umg9jaVDBdY7QmILjZSUHj7L/NAk7MPu5uY97QXydFoQNP4WErJxdmBB+VzGjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bh222ofK; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745024533; x=1776560533;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=CS0TeGJqNsDGS3gdVDRPetbTb9Nvd25wmjZm3BYYFbA=;
  b=bh222ofKCH1tI33mGbRfz/jY6/7ZEmnpfF+NICss18H1Cx9P/7BGHGG/
   a0iHLwyRNXHsIIZEX/xmp9r9+YI8ZgWmZAWTNcmTw5LjUqsfFsVbKD2Yx
   20f+T43b6lI/KT2WM4T1kTydvVJKsjd1F8cyrUQSb0LIt1gxQZnu1N+4L
   p7vFvS4xz+/kD65D+IsW3ZIQTDFW3/17gdmVm9T+pL4sQkO9+WfN+4f/B
   LcXQqlTSs2Uom6tXt+olJhIabKLWOT31fEIdRTSvQpCOUeFUrdEeezJnd
   DaKw40gB1Wy2fubpox0M4MIZjSxBjX3A2uV7vuLTqOzLKHadijYyhBiMu
   Q==;
X-CSE-ConnectionGUID: p7Xh6p++SVSolTPV1Ilipg==
X-CSE-MsgGUID: 21viV7x0S6C8Hz7hn9rq+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="46361810"
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="46361810"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 18:02:12 -0700
X-CSE-ConnectionGUID: aKqMqMTtSCWZhXpge3u2rQ==
X-CSE-MsgGUID: t6tuxpGnSt2lKKR9r0pXnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="154413971"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 18:02:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 18:02:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 18:02:10 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 18:02:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ck1plB5d7i06UbO5PWK1VmGfkQVXUn9YOuCMjJ1nCZxR5f75r8EjZtF7O6XSxjjWSoZz1kK9t0fTk1ugB7Xrrz+y+mXbk7xSiSiFqm03EG80tZaDp1866EpfNNOCEIstFxNLpJSueC+csSQ93ElELpvPB+PlRg1eh1FalgYfGcJMv+I9fGLrCWBCIpaNi2+h4ua3gtSp+E1k8dPrvplBujr3KXY03UqaCjZ5VZa5YhP6V4j9H3m6G4Ll5fCAWjyggKLJTThDLQH+CRg7VOhn8nMkLLIJgHui0ue7U9OImiP7e9l3lwGlwUU2NKqikz9LEzDbhHyQNOnZaZMjlcD//Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sG7/uiWqwQPgOv/3Y3s+UJqwmOLcavPM1Rf07gaITXE=;
 b=L+QjFoe4nUW2kHAu8RN5XoTMQWGj8J1G7UGlcT2EmOgvtaMTw1OuBtQCVsJWHsuepwnT5XgUhI1ig8Rr2hiE7ZKPze3vimgaRML+RLLpxKVyRvXqrwukU7wcuWCBHAauivgleEMJE+rpcsNJOa9+VQM7paQFDaIAlCN3M3qMXmKjQrg0ZbcCN9ucAKgMLlJQWnhsXWqwWJidYoTE465EQQL7UFo2GUMLQ8b9ZpE+KlBaQa4iH9WI2WY2ZUMhWzQM8nGubqq7Kqta9yioMWImPsvLUthbUVHsYbFduK+1ODMTFRbKXcVKLGJnnutYOzG88CfC3k285BRdNqVc4HS3Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB7490.namprd11.prod.outlook.com (2603:10b6:806:346::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.22; Sat, 19 Apr
 2025 01:01:59 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8632.025; Sat, 19 Apr 2025
 01:01:59 +0000
Date: Sat, 19 Apr 2025 09:01:44 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<tglx@linutronix.de>, <dave.hansen@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, Ingo Molnar
	<mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Samuel Holland <samuel.holland@sifive.com>, "Mitchell
 Levy" <levymitchell0@gmail.com>, Stanislav Spassov <stanspas@amazon.de>,
	"Eric Biggers" <ebiggers@google.com>
Subject: Re: [PATCH v5 2/7] x86/fpu: Drop @perm from guest pseudo FPU
 container
Message-ID: <aAL1+O1vKZSdbZji@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
 <20250410072605.2358393-3-chao.gao@intel.com>
 <cd14e94f-dbf8-4a2b-9e92-66dd23a3940b@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cd14e94f-dbf8-4a2b-9e92-66dd23a3940b@intel.com>
X-ClientProxiedBy: KL1PR01CA0152.apcprd01.prod.exchangelabs.com
 (2603:1096:820:149::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB7490:EE_
X-MS-Office365-Filtering-Correlation-Id: fe5513c3-7a4d-4a08-7b56-08dd7eddc931
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZVkvUExwLzRCT1BMYWVlc2VVcWV5VTlZa2xWYWFSZVh0a2ZGM2lpQS9HT3Bw?=
 =?utf-8?B?S2RIVXkyUVhZNFRpQVMzMDNWcEE1MUVnMjlVN0UrcmxQMXl4eitabnpIR1o5?=
 =?utf-8?B?UWVmTWtHNjNkcEFKTHZMM1RFZkpjU2F6Ulh2clBzaUNBNlhDdmNGWVByUHJV?=
 =?utf-8?B?MzhySWU2K1ViU294aEZra3FtSXNTTlJjS2w0ZDF2Rk1xUDA3ci9UeHdLbzdM?=
 =?utf-8?B?N3B1Y2d5Y2Zac2NzUldZZUcyRGJxaGNWbldOdmVuUnpHbFRlSkViNm9LUUcr?=
 =?utf-8?B?dzhYcDN3UzFTbUdGMDREQnU3WlhrU0MwMDdoQ09ibHhHMXhVVkQwclZKZk51?=
 =?utf-8?B?UjJVdkhPdE52R1JTaGJxcndEek1aVWN1MklsdHYxSzhmVyswUFFoRmNKbGg4?=
 =?utf-8?B?b1h6cHdtU2VsMFhtc3R0Y1RKUUZ3RWxmOTZqNXhkK0R5djdCdnhFdzA1TXAv?=
 =?utf-8?B?cmRiajQ0dDBoWWVpZDFteGNEdHJRTGhJRDlmVGk2ckFLdlZ1TWIyektwSjNm?=
 =?utf-8?B?VW42WGt4ZTZncHFTU1JYb0tXRXVyZXFRbTF3WCt3Q21aV1lLbitLVWZPZk1j?=
 =?utf-8?B?dGhYL1A2MEpiWTlkNFRTUXF3Snptc3hiZmhBdkV5aGhlRWEra2VmeGdGbE9E?=
 =?utf-8?B?ZXNhb0NzMGlUN1MwdmZJTStqbk0reU1zU3BSTE9WK2N4QXpmQ3hBWlBFZ3dk?=
 =?utf-8?B?emxTeSs3K1hJeHc0ckRlWmxIaDF4WEl5enJsMW55TURCcXFkTnJLajY3dzRD?=
 =?utf-8?B?UVg4WkhDTmQ0OXdta3FGdEN4R1grT1ROOC8wanJIV3hhSUxIcmsvZ3BpRDFw?=
 =?utf-8?B?Y1JsZ1ZWL3hXclFxWHNoTXE2RWdqeXVKbUEvOUVSVW9ubFlZOWpqVjhnRWpw?=
 =?utf-8?B?NlFJd1dGZnQ3SmZ0UUFHZmZtRHRGU3RMak1MZHF1VDNRK3BmNWJ3VHVqSkRK?=
 =?utf-8?B?OFUvMkpnMnlxWG4zTnBzQjdBWC9FV01ab2VQNTg0Z1V4Vy9DTE4yVUhpSVhn?=
 =?utf-8?B?ajJUa0dYYWJ3a1o4alkvbnIxNUdpcm85MjVSSEVZbTlzcTNjaGNSQkt3Umd2?=
 =?utf-8?B?RlZWcm9VY1BGL0RsaHVwL3IxVWwzNXhxV2F0M2xHL21qMGRJVExjbG0zdHMy?=
 =?utf-8?B?c0g1Q0pWeG4vMXV4NU9WZ2dYNW1oNmpSd3hyU2dZSGd2RldKdVpWeWFBcXlt?=
 =?utf-8?B?SFBKUXJtNDBoYzlJVGRESkFHYXhGcHpUbnowa0tIMXpxeS80MUhMZVBsM0VS?=
 =?utf-8?B?ZmlRVnRXVFF0NHhrSFo2NlREdXdObmMwem5wenZneldxcmgwUDM2d0prNEFt?=
 =?utf-8?B?Qkc2ZDZKaG40dmNyNDBPTVFtaXlGM0JDUkNmZUFxNlV3TGdVZDVLNnVEeG5m?=
 =?utf-8?B?TkZHRC83WDg0czZGV1dxUEo0ZTlIMnJ1VmIxOXVxUVcwcXBsRDZlRms0TVZJ?=
 =?utf-8?B?NGtYcHZLT24xOERoQkxYMVJQclc1aVlYRm9oTW5TT1psNmpJazMyeFR3VmtH?=
 =?utf-8?B?RTJLVGt3bTEzTy9CbXNrTjdoVTlFelZLak83RXk3Qm9uVHYxWFp6Q1QzMnJ6?=
 =?utf-8?B?cFFmUWRLaFdVRUNaaUZJbzlVL3BReVcrQTlGY1JZcHNmakpkaEJGZG1FdC9y?=
 =?utf-8?B?VkpsSkJ0YWdJRlU4WFU5b3dEeFlrVFhuN1d4SVBDUHU2dk9hM3lsTUJmYTgr?=
 =?utf-8?B?cDdUeGhRL05mdDhxdzRUanNYY1hwQnhrNEdFYlZtMzMrMnJSK0IxK21BWlY3?=
 =?utf-8?B?Sk5lVTVnYUtja0JFc0RHWG1SQ1FPamtOc1NTR1lhMFRQejhaZDNobmtFdmt5?=
 =?utf-8?B?MHNsNU9Jc2pxN053OXd1UGJjMXZVZFFCN0FreVMzTXJoZVAvYVB6UExHU05V?=
 =?utf-8?B?LzZ6MkY1ZmMvZWNVVDRRZzIxRXZPQUp5WC9GN1kvYkxhcXMxZFVrck5FQUdO?=
 =?utf-8?Q?gDujGsdPn1M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXNnMCs1eVdYR1ZUZHVHekZQMkJlV2xIZjN5TlpGZGNtaVprTjNZN3BsVjV0?=
 =?utf-8?B?VnFOQlBMOXdESlIrcnBpUER6YjR2UHdXWDA5cFlkM2w3ZG01TjE2dUJlNllT?=
 =?utf-8?B?QmRCLzZ5N21Rc3BPZzArR2s2NzFiT0Q3YkZ1ZWhxQ0dBK21pRE8wLy9FNDlR?=
 =?utf-8?B?K2tRNlFUYzF2bDc3Y3VGWUtPVUFOMDBLeFNZQUxFeWtiUUZFNXpkMWRxbEN5?=
 =?utf-8?B?T2pVTGphSVRPanBTdlI2YWhOd3VseEJobVdlMFBRSzV6NFlVK2c4ODVJakR3?=
 =?utf-8?B?WUNaT2l0a1RoVytMYXpUazI4U3hHQkdsa2VISHB0YVgrUUN5K1VMUEh3ZzZW?=
 =?utf-8?B?RlpUZmg3SlpPTmdlK2xld21sdDdrMDBYMEJPZHI5Yy9pakk1NitZb2I1TzdX?=
 =?utf-8?B?MHNicWJ5TDNGdnpZT1JxZWR4aWJlQURkUDFYSFpqYzRMM1VjcGhpS1lwN2pv?=
 =?utf-8?B?MFV3ckRvZXUrTC9rbG4ydlR2SStlUGp3NHlEazVkODdCUnVJZ0tqM3cxWkZK?=
 =?utf-8?B?OCtYVi9KSFFNNHBuUFkrWmNTRitvWkxXSTB5N0NSdUs3bjZ0dDJnSDgySlZ1?=
 =?utf-8?B?V0VXcy9TYVcrbGhEb3FhNEpWcXNwYkZxK3hxa1V4OVFQNUFvUGJMSWVheFk0?=
 =?utf-8?B?blZSYkV4ekJIY1FuZ3VXSllJUWM5ODBxZHBTbm9iWFZtQVZMc2dWK2cyZWVz?=
 =?utf-8?B?ZUx0cCt1Y2ZtUW5rd01rRE1lWFR3cXNzYTMzc3c3by85OW5EbStzZXhsaUxo?=
 =?utf-8?B?OFpmZ1o5VnYxckQ5Z0Q1YTRtSkFtTHArS0xiQnJNYllnY1pudXRxZFdXaXFL?=
 =?utf-8?B?bEdTQ2V3S1B0VjhXdWZEWUVSdXVCSWE5ZGNHSHJ2R0tBd1J2L1poL0J5Qjhr?=
 =?utf-8?B?YnhrdVh5c282N25MNzYwUWxPVituRWZnZ1NsNFZqUVB3NW5QZW1MMEozUzZT?=
 =?utf-8?B?UzJ1OVBGRlRVbHFuTGpFcXBRY25qSmZmdzJZWWRWbjlqMVNzWDVLWWY5NVJp?=
 =?utf-8?B?Rk9pR25wdUsrd3B4SXNmM3dMRFVka0xFWm9xUTJTS0pmM2RxbnUrUnFKcWcy?=
 =?utf-8?B?RnRuMTg4UXBFQnh6M25aVVpsL1p3MGUremhGWHN4My9xalJqTzNTd0dlZWV3?=
 =?utf-8?B?TmFMRVh3OFhsVW9OSldiYlp0YWE2enZONVFtV1lWSk9KOVBYSHVzRlFqdkRR?=
 =?utf-8?B?MW1oMjJQN1g2WE9iRllpWXFzN2dqeXJSK3VnNnZrWlhhSjhSYTRvcDJLWkh0?=
 =?utf-8?B?a01nbHllTE9DMElGcnQxYzlyM0ZZazJ6d3Vzbmp3ZzR4Q05EU3NSMmcxM2s4?=
 =?utf-8?B?aXVidjZRSU1wNHRhS1cvdXN4U3JqNmpIL0pUQkZrZmMrZjNkRWU2ZGc5QVA5?=
 =?utf-8?B?ZzhwTnFEOS8rVDNGbXI0VldqMWJIMENDMTlKN0lwUnI4Um5iS0NVVFQwdUVt?=
 =?utf-8?B?a2NWVGJJTmNOWVh5cldDQ0FNWU9TVG5KQUVZSTdJODBPTmlOdmpFTWJaS1BN?=
 =?utf-8?B?bVk2RU5wcm54dWpUTmRRL1M4L1hvQnk1QXAvczluOVBJOVNHUVJiMFQvTGhF?=
 =?utf-8?B?cGFJa1JNVG1aMFRTNnByWllNZG1BVEdLbFNHNXBwcVlScUtwSWoxVWVaRzJh?=
 =?utf-8?B?Z0pGYmhkWGdwNVpXSDR4MGVnZWZ3ZXhTVFcyYVoydkhkNTVaWFBkTWNXM3B0?=
 =?utf-8?B?dGdLRzNCODJvY3BBMHRvVHROMG4zRVg1S1NWWVlhR3VGbE03Umh2bTdXY2Z3?=
 =?utf-8?B?L2krQjZQd3VmNTUwb1dWZDlyNFNqeFhrQS9oQkg3aW1hbnBzYW5mYlR6ZFNh?=
 =?utf-8?B?U2IrRGxNTjE3L2VnS1RxdnA4VDdIa3lwYWo3THpjZGlmaDFkRzRaZjJiZ1hn?=
 =?utf-8?B?NFY4YWZJSEVQWE9hNTFvNWFlVFhMYVN5eXY1eHhSUmdSL0VqNEQ5SnhtT1cw?=
 =?utf-8?B?UENqazFvMERvR2JSTWQ0NWhWU2tycEhMZ2xxblY3MkJtbEpHMjRBQ1AxdUJr?=
 =?utf-8?B?R2JoOEVxV2oya2dTbHRNdDBvM2FnR3ZNcm1Oc1lnWVpNUElxQVB6RTBwVGJ6?=
 =?utf-8?B?TVZLUTNuOUdrSFBWRFRlWGZWMHFEcThseWpXd2xJNjlROXAwYWk3MWtiUmhZ?=
 =?utf-8?Q?q3eoI3XqQu4PAkigNW0kOcU7n?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe5513c3-7a4d-4a08-7b56-08dd7eddc931
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2025 01:01:58.8988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p9jJbza3KCO/ljQmDcZq8E8VQ74s+n5bCM5gvHoMyOOGv5c6ezZlsCBcacqX7XrdBLKLKLWm7x3HbONhVIkSHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7490
X-OriginatorOrg: intel.com

On Fri, Apr 18, 2025 at 01:51:02PM -0700, Chang S. Bae wrote:
>On 4/10/2025 12:24 AM, Chao Gao wrote:
>> Remove @perm from the guest pseudo FPU container. The field is
>> initialized during allocation and never used later.
>> 
>> Rename fpu_init_guest_permissions() to show that its sole purpose is to
>> lock down guest permissions.
>> 
>> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
>
>This patch appears to be new in V3, as I can see from the diff here:
>
>https://github.com/ChangSeokBae/kernel/compare/xstate-scet-chao-v2...xstate-scet-chao-v3
>
>However, I don’t see any relevant comment from Maxim on your V2 series.
>Unlike patch 1, this one doesn’t include a URL referencing the suggestion
>either -- so I suspect the Suggested-by tag might be incorrect.

v3 was the version where I truly began refining the patches based on my
understanding, the historical discussion, and feedback on v2 [*]. While
reviewing the historical discussion, I found Maxim's suggestion to be
valuable:

https://lore.kernel.org/kvm/af972fe5981b9e7101b64de43c7be0a8cc165323.camel@redhat.com/

So, I implemented it in v3, but I should have included the link.

[*] v2 was simply a resend of v1
    https://lore.kernel.org/kvm/20241126101710.62492-1-chao.gao@intel.com/

>> @@ -255,7 +252,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
>>   	if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
>>   		gfpu->uabi_size = fpu_user_cfg.default_size;
>> -	fpu_init_guest_permissions(gfpu);
>> +	fpu_lock_guest_permissions();
>
>As a future improvement, you might consider updating this to:
>
>    if (xstate_get_guest_group_perm() & FPU_GUEST_PERM_LOCKED)
>        fpu_lock_guest_permissions();
>
>Or, embed the check inside fpu_lock_guest_permissions():
>
>    if (xstate_get_guest_group_perm() & FPU_GUEST_PERM_LOCKED)
>        return;
>
>But for this patch itself, the change looks good to me. Please feel free to
>add my tag:
>
>    Reviewed-by: Chang S. Bae <chang.seok.bae@intel.com>

Thanks a lot.

