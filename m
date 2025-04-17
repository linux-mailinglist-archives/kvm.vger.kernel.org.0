Return-Path: <kvm+bounces-43533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ABDE7A911C2
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 04:47:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BAEB446B7E
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 02:47:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB9261C460A;
	Thu, 17 Apr 2025 02:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kC3ZByCN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5688248C
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 02:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744858025; cv=fail; b=ZDX0CaDUHnuH4DyENLqGVSEb5wEyX/EHsaDfBZX2MmCp31f0T9EOvryq9J44Cqe4dmZttwAQ/JwIb23FwVejJsfgFph5XqEtHvwEoXW2AyUS+oWzw2NpS8uITL/VX6qM3R5/jd9e48hh1cp0yOCJmB0eWa2ph5y2n3zORRbY56E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744858025; c=relaxed/simple;
	bh=3RGK9GaUsMxTUcz3B7wBNFX5ROQdvIwFMFaP9wwfQ24=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kyyx6ogOLbVi0mCVTWrax1Oa1OOKoisuTvQN6QqMxYXnJWwpmcNv12dCdIHatZYb7U5s92FnOFtEArTRd0emP3O4hrgzs+tLfRN7V7tfRRkm+hlCwfdjJ3wbzjnU/JWLJ7ZAcZLrWGINj1N3P5TzpjLK5VcWII1pKqiKZ6nx2TQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kC3ZByCN; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744858023; x=1776394023;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=3RGK9GaUsMxTUcz3B7wBNFX5ROQdvIwFMFaP9wwfQ24=;
  b=kC3ZByCNfou++fyn0onUuPTPxvKEHI+5rje5/mzGsAXxKVS9PQp2Lrkp
   AVkEljjQub8dD3tmz4wP1ggTX5cNA1EKzWEJ+LVrHUL9spDZC2yuj8vup
   Nk1icG4pgVSk70+tBJ/hdEqgYVtaCnk9TaUlqwREWvzi0uPZTVWdw6OIF
   oV6pJyOjMW77xf8tzlO6ymITBKlGlQ7aqtLiV2wF3qLb/py4rXsZMi0mh
   YIfxl14Qoqah5umaD+1P03KxGhccaV0ZmVji1TyDnGfAv0f7fAMaIDSh8
   1Hyj8FuHPiZdeYYSuWcJlYo+H5Q8FCbAbB+wO8k3PikU9RZEwgX/A57k+
   A==;
X-CSE-ConnectionGUID: W4axpl7qQdqgvLei2ml8OQ==
X-CSE-MsgGUID: ekK4gfp1QmmjV5fW+r8Wpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11405"; a="50239482"
X-IronPort-AV: E=Sophos;i="6.15,217,1739865600"; 
   d="scan'208";a="50239482"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2025 19:47:03 -0700
X-CSE-ConnectionGUID: JVuMmH8kRSGiqJySOkrmxw==
X-CSE-MsgGUID: RhEBJLYySHWmRcFuc4F9IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,217,1739865600"; 
   d="scan'208";a="135486980"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2025 19:47:02 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 16 Apr 2025 19:47:01 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 16 Apr 2025 19:47:01 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 16 Apr 2025 19:47:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DVF0em5C/w9P6/gyJxcFf+H/jc105RIMGc+32LRu/ULjyJ790yXNWJ9H/IdddErxYL1JcBgyRs0Z9V59Lc+VSTt4whzYR64Yy4Gpc15NcIj1QkBkuSGa5BzEiel2ZVrLeSKYtARf3wl5+03HiDXDt5uHnb0gPEpZhZ864r0va37rAuI9Ko54aPwv6v+aigANRqdRMPCgF0a/5szVNZbqsILgwRerFHxUC4ob7VkJycGYs5sp+Ix1cCgPP63hPLNCFyiEAzKvD9fJk6FBxjyhal5NSq0xEklwea9QDOPrG1Ng8KVj7wFSpey9quv0oNhKTP+8BZI/8UZZQJKfgVC0rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BjHrfvKteg6WvGPxt3UH6/WKfGvWSmzBdv0kXKRAZTM=;
 b=b7SlbQ4tEsdIVYuztvWPzp++Cn0QNbRPbFT0TxX8hLiXw8Y4KbvZgcreP/TWPxiIvC0JEe0RViRuyNnxC3SEQcwh7rgqzCJanBahRtioFrZMTSAjZmx4eg7AXrq/V40B8pyfrJPTsC60xTzEpOp0zH1IH5RZp0aIaLVSCpUsgK56uj61K1U4Ssj04915eSBAnZ9cjLW4C6qckA3HUmFGdd7gv0qtHGNlOZQxTLen71dDEaqsTmMwnUW0AJ1EBqGY79MczjWB4Gv93T7wMZAASkssb4LbSvrNvM8FYnX1GudB8UWnRVZiw54O5+QIbo2xxjD0+eo7TandM8CTG5ExvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 LV2PR11MB6045.namprd11.prod.outlook.com (2603:10b6:408:17b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Thu, 17 Apr
 2025 02:46:46 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8632.030; Thu, 17 Apr 2025
 02:46:45 +0000
Message-ID: <a185919f-1567-47bd-946f-0a66486404db@intel.com>
Date: Thu, 17 Apr 2025 10:46:39 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2025-04-17
To: David Hildenbrand <david@redhat.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM
	<kvm@vger.kernel.org>
References: <971a3797-5fc4-4c7f-a856-dca05f9a874e@redhat.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <971a3797-5fc4-4c7f-a856-dca05f9a874e@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR0401CA0016.apcprd04.prod.outlook.com
 (2603:1096:820:f::21) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|LV2PR11MB6045:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e856319-cddd-4a24-6135-08dd7d5a179c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MEJqYVlqYm9nUVZuTktSWEluYitEVG5pSUhCblJ0eHoyL2JkU3lCOWFIY2s1?=
 =?utf-8?B?YWVBQTh0bDhzdzF4dm1LZmVSSHEydEk4czl1cUJvVXdFNm9jZWpkMnNKeVgy?=
 =?utf-8?B?NkJ5YlJGRW9iQkFQVnVIWFZJZmt6eWVWc0t1NHE0cGFoQTNyVFBZSnlsRHAr?=
 =?utf-8?B?ejM4Ri93aU11cEZ5anBLa0RucFBEaG9qWDF4dFJ2MHQ4N0Q2cTA3L0hBUEJJ?=
 =?utf-8?B?MnpwaWp2bHcxVEpkL3ZwNWJXMUw1U2haeE5Dbmc0Q25vTkd6bUVCUDNYY0Uv?=
 =?utf-8?B?anZlNFNESExiVE1wakhTaTJiNDZPRnZnNkVDUGg1RWZRWUxHemVkblBhbitz?=
 =?utf-8?B?WWF3VmkvUml5N0NVemxnZ2FKUU9jOXNRZXk5cHl0YXNsd2VLL1ZKbHc1d1Fl?=
 =?utf-8?B?Y3dGRnFOYzJKVWhQbE83YnZIYm5Kdzg2WmZVeDJsRlpqTE5JeDlIMUNaN1JC?=
 =?utf-8?B?RnZsVlprRTVYYWFCL3pPMDlNK1B3R3dMQXpOdHVXbjh3a0NBZ0ZiOWVsU0pJ?=
 =?utf-8?B?VVNDWG9jK3lQSC9haWZFUDV1a0pHa0p1UjV6bmhWY0ZCWEdMTCtkZHhIRWJO?=
 =?utf-8?B?czJ0V29XSTl0VDNXSFdSTzZUSEhhODlVZ1IrNDU1VEtrYXRTdE1lR0x1dEFM?=
 =?utf-8?B?ay82WE1wMGwwRXRWVVN4ZXY3N0VTVUpLL0lweTNMNmZ5YXVtcWNtSXBkV0px?=
 =?utf-8?B?TnB5TUdzc3NCODM1UFc1VUFsS3ZRNDFBTERSOW8rMHlFa3hQcW9Ydkd5dFRZ?=
 =?utf-8?B?WVVOL2NkUFRHLzRTVUtyRFIwVi9saXN5QzZlblROWFdOQXVwZXZ0S1U0ZkY0?=
 =?utf-8?B?SmM5WTJleGpNVjVKT1loRCtYWHJUL3Z0aVdEU0pwbldLem8xbFl5YlczdlQr?=
 =?utf-8?B?UnBCUjRTeTNVaW9MbDYzU3phMGZzNzRqaFIyUTFiTzIvZWFSZEhvOG5qVkpH?=
 =?utf-8?B?T0JYb2tJSXFsNWdBYXRrRlJwYlgzTzM2NVVoU1planpJNnNHY01RdUVyVHRy?=
 =?utf-8?B?TzRXLzE4K3JPSTFMN2RLalljWFNVNnEyUCt3QjFPYUcya1RjRWxvV1JLV2xP?=
 =?utf-8?B?WUZVRnpDMitVMFNhUjZjNTV4NWN6S0JadXRIMzlEaTJFaFpEUTJNZkROSWlx?=
 =?utf-8?B?RHZhdFV0aXAwU29mTE1xUmtxNms3eTgxeWZTSCtFaVQzSGdmT3EyV3RQWjE5?=
 =?utf-8?B?L0hHNkhhK2w1TVV3QkJ6RmRsRWJDelZtNWd6U2tOQ1pkRTlqcXZDZzlrVHoz?=
 =?utf-8?B?K2RQSG5rYjYwUmoxMFNhaEZlbXFDa1BzMEZ3cksvRU5KWVZhZi9FSmYzc0Zk?=
 =?utf-8?B?UUs5NHVlTVVhU0ZPR2tvNWwwV0ZLZlBYQldYM1l5ZGk4UlpDaWNHOUlsYlYx?=
 =?utf-8?B?WXVuQlF4UktRTnJtWGkrb0dqTFI0QVJic01KeXlyYmpOZExBWkFwR2Yvd0g3?=
 =?utf-8?B?ZS9hMWpoUnlIKy9QMEdONDBoYXZEZHhGa1VRZU1tZWx5MFRudWJBd2VXUC9m?=
 =?utf-8?B?V1pWVkpXdkVhTUtNUWc4bDVjUVc1Vk9IbFl0YUdTYVBVamp3NExpN1VUWHQ4?=
 =?utf-8?B?Q3orQm9Zb2t6Ym5HWitFS05xeVozVjdZRVlWdHdZOXZmNVFjMFpMTXBYbFc4?=
 =?utf-8?B?NHhiblNuYnN3TkJxbnR1cjZrV29zNVhuL3NBSUxub1ZSak5vbUE1dzlCeDRt?=
 =?utf-8?B?SDM1MUpnM29JTHk0dmdqT0pKeEw4NHJFK2dHL3Jmbkt6TXlPZStSeDNmTkpi?=
 =?utf-8?B?MnF3Q0xjMmJxcHFlOStFeXBQNXp5YVVJUDMzcWxlV0pkdTNtOWNTZWpzZXpB?=
 =?utf-8?B?SUE5QlMyekxOQkZkdjdDMVBDS2VDcGdML2ZYZ0Y0UnpEYWw4UGtEbTBWMncx?=
 =?utf-8?Q?O9lNKRnPCtw0c?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlZQczlZN2ladzB2b1NWTVJWa2Rmd2ZwSnZ5SkNIWXVnaVI3L0F0QWZMNy80?=
 =?utf-8?B?bjMrbUUyVy9FcUtXOGJoMUQwQWtvOENGMFZwQVp3d0RZRGR2ekovRlpUenk5?=
 =?utf-8?B?cXErUTRvM3lzenJ3QTNNOXQyOVdXeEhHZ3FSOU9jM2J3MlY4RExzVTVodEZY?=
 =?utf-8?B?MjZrdTM1aFM2VXRLSHJZM0cxbGc0cnRnUEhMMGlHQ0hBcHJDOFRWU3plWlNh?=
 =?utf-8?B?NnNlKzYwYmZyU05ob3NuZUFNdmpjSmo5RFNONHp0RGo5WURia3FDdE9xREgr?=
 =?utf-8?B?cnZsTG5heFg2TnJ0WVFWUk1yVmxxSDYzaERiOTd4Y1lhQ2pDR09sWW82cjI1?=
 =?utf-8?B?Z1JLZGlDSHFYL3BFTDZlN01lY3FtMXFoS1A0ajQ5aGY0bkVrSi9HQ2pvbHFm?=
 =?utf-8?B?ZmJxbEhlb0tVMlJ6bGF5TDBlT29aNDBLYkZxekozWmIyUkR4N2hoNDQxSUxH?=
 =?utf-8?B?OTB4VHlOR3c1WnFIdC8rTzFqeFd1ZnNVMEN3d0FFN0JTSGRFdFBiSFZjRHVl?=
 =?utf-8?B?blpnTWV2SmRFUHBreFN6blM3cmhzdjAyUEdnZ1l3ZGVsU1FwY09hWGFVS2dK?=
 =?utf-8?B?R0pab0picldxV1hlSndIdkNmY21yYXdHamwrQnJQdVNjelNkdHlvMFlLMXFm?=
 =?utf-8?B?dmZWS0xlakN2aHBzdFRpazV6anpuV2Nrd2hOT3RLSkpVUCtVejhFV3VXNWlI?=
 =?utf-8?B?NkZoeGU1YzFnbEpLdHpLbERyQ1VDcFUyWndDTHVjdlg2T29VVVhjSm9rUU9F?=
 =?utf-8?B?VVI4NHZzZ3NxV2pVMDUxanh2TmM2bkNZQWI3bktPUDl6K3JmYlM5ejl4RnFM?=
 =?utf-8?B?eG1zRUw1VS8zRFFOWFRicm85aFMzdW15TlF5Q0RJU1lsaS9VSkVxUWZxL3M2?=
 =?utf-8?B?VTNYcUw5N3dBTkxnUlRCRXlKR0RQZDloc2pudXUwQ1RiTVcrQTQ3aGN2YlYr?=
 =?utf-8?B?eFoyQ3dEcnA1UGFJbFV5TmtueHJkRmlEYy9uQVQ0ZERUODZhYnRVVHZNQkZl?=
 =?utf-8?B?YnMveW1LdlF1WndwVS91Q2pESFRhYVFjbEk1VlF2eklCb2ZWL1VPbmZFcm05?=
 =?utf-8?B?SS96MEVoL1FLcEdUV25KZDFlUE5hbGQvRlZudTg3djJnQUdGdk5iam04RmVy?=
 =?utf-8?B?THlKdU1PSDFzTlhNbWRpYkJ0T0crTEFyeno3WEE3UWhYUDYyaTdMa081M3lT?=
 =?utf-8?B?SzNnTnFHMkxURnlLN3prQUVUSmtQcTV3bkI3Rmp5VlVLdFFvdi9GSXZqQllE?=
 =?utf-8?B?ZlQ2dU1JR2kvZUxSYWVvbjBRdVllMzRiSTlXK2FBdkFEMnlhblg3aFBSN0hT?=
 =?utf-8?B?UHVJb3E3SlgzNjJSK3hMV0R5WGlRRWdHbjRJTExaOEEzYjRBVWxYdE05OFcy?=
 =?utf-8?B?aXdkUEhyVVRzUlhkNUdTTVlaSE4xKzNkMmtvN3FTcnRHeG5VZ25od21HOXk3?=
 =?utf-8?B?ZlNkK2Y4VE53cUdIc2pvK0R1TGllNWJMMkxvdTBnRzdoMzVmNDRsMFk5eDZH?=
 =?utf-8?B?ZW5CUW5qR3JKbWczSU56SHFMT2gzQW5FdlR6aGVGbUY0SXVWZUJNM2kyV24x?=
 =?utf-8?B?Q2ZZdzc0VWFRZWZ0U1FIOUFueWVpelIxQ1R2ZWZ2clRJU3hGQ01mUXE2ZkZm?=
 =?utf-8?B?Tnl4OTBDMnc4UmhyUEN6SStXTzZlK1ZYbmxueC9TS0p2aVNmNmRIaGZvdGR3?=
 =?utf-8?B?RVBGN2p1b0ZveWF4UHhqOEtpc0k5cWd6bXBDUlo1aGFyNkNKK0hkWnd1MUdG?=
 =?utf-8?B?bW1FWTVlNzFxcUNTSlJpd0ZBbHB4dExsaDFrZ2lmKzdpQm8vam8ybHZNejhB?=
 =?utf-8?B?Q3dSajFucVRoN3MzMnh2VnAwQ1BFRkZjTlFyRS80SElTUW8yU3I4aVdsbE1j?=
 =?utf-8?B?ZFpvTkYzYkJXOUdabjdkdDc0Vk5pSWNrZXlGYUsvRUloSVduVEQzWGZXUG9E?=
 =?utf-8?B?YjJlV3hwZUs1eXA2emhUUlVvMFJHZG91eFl5bEFHa1FHaTFGVlVPSjJRVG5B?=
 =?utf-8?B?MlRpL1NVL2pyREVYRGFyZHZ2WE1IVitGWUdMdldiTStDRituTVN1bWI1UXlY?=
 =?utf-8?B?aE1zVlM3Zi81TUp4Mk9pSUtRWjBva1BhQUV1eEZJYkdWaThTc0p0NUdPOUgz?=
 =?utf-8?B?Sy93cUZyK3ZKd1gxb29WdDVad3pBaTFkTm9yWm9oT0hSRDRnZjlOTEdISlY5?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e856319-cddd-4a24-6135-08dd7d5a179c
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 02:46:45.7394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wlXAQHRajg48u46zS2+h7AcG8of5bj/XQWOMBAKp5CxicNgab1ySjDI4EfFoFk+BqvvJFycYVyGJntrUeV2Znw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6045
X-OriginatorOrg: intel.com



On 4/16/2025 7:58 PM, David Hildenbrand wrote:
> Hi everybody,
> 
> our next guest_memfd upstream call is scheduled for Thursday,
> 2025-04-17 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.
> 
> We'll be using the following Google meet:
> http://meet.google.com/wxp-wtju-jzw
> 
> The meeting notes can be found at [1], where we also link recordings and
> collect current guest_memfd upstream proposals. If you want an google
> calendar invitation that also covers all future meetings, just write me
> a mail.
> 
> 
> If nothing else comes up, let's talk about the next steps to get basic
> mmap support [2] ready for upstream, to prepare for actual in-place
> conversion, direct-map removal and much more.
> 
> In particular, let's talk about what "basic mmap support" is, and what
> we can use it for without actual in-place conversion: IIUC "only shared
> memory in guest_memfd" use cases and some cases of software-protected
> VMs can use it.
> 
> Also, let's talk about the relationship/expectations between guest_memfd
> and the user (mmap) address when it comes to KVM memory slots that have
> a guest_memfd that supports "shared" memory.
> 
> 
> To put something to discuss onto the agenda, reply to this mail or add
> them to the "Topics/questions for next meeting(s)" section in the
> meeting notes as a comment.
> 
> [1]
> https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-
> cxTxOrAosPOk/edit?usp=sharing
> [2] https://lore.kernel.org/all/20250318161823.4005529-1-
> tabba@google.com/T/#u
> 

Hi David,

If we have time, I'd like to discuss about my v4 posting of shared
device assignment support
(https://lore.kernel.org/qemu-devel/20250407074939.18657-1-chenyi.qiang@intel.com/)
which introduces a new abstract parent class of RamDiscardManager, and a
new priority listener to apply to in-place conversion. Hope to get some
suggestion or confirmation if I'm in the correct direction.

Thanks
Chenyi

