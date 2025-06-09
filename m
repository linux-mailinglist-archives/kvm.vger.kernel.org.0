Return-Path: <kvm+bounces-48712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 30CFFAD1780
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 05:24:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20D967A3E30
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 03:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE97D27F75A;
	Mon,  9 Jun 2025 03:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LD6xCdjo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99A425C813
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 03:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749439434; cv=fail; b=bO1+R8VLP4ntPuLcH2jZgh0Y2rkw7qNSTjz8nPIuZ1coNSAgi00hET+qC8vbdKQH0EOZj2cCjUKOxhC1WATJNlkaesMN3oDEOlJBKkjQ0DLj/L/yIr9cmxo5NzmtPQK/pd5HXl5QMPOMNrKLDteLXYyw8At1WLZMywZUzn/de6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749439434; c=relaxed/simple;
	bh=M/BaNv6IXttF0Oape6DS04/aTOAyiIbLJ9WcC5xbV7s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OwJu+ZZR2CkuzyasRGbJRA7vDEIhe6+a9SrRVB+uHWDgWS3Ozsb3MgXpTeLC6c3ui7ZQatzJt93Y57XI6kr/UlfihldoXIDWIb8CWLX07uC7h+yuiD6FWR51PUgHucpGebjnVVB0cY22TvIiDAENXCtF2vkJXvUBtjhM2kVaWSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LD6xCdjo; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749439432; x=1780975432;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=M/BaNv6IXttF0Oape6DS04/aTOAyiIbLJ9WcC5xbV7s=;
  b=LD6xCdjojX035/dpcO5YaI8l6yVb97IzN1tL/0Q5MkoahzGGj4avRbH0
   HocO063am7fMXIknPl1UgYBGxL24CebLdFsjQFAXKng1+k5q3qoaHrqHp
   VTiKsIeZ0kO23FtxX6BcvE6gAUGopWb1yvMGHb71iNOXXYC0v6DkvJiHd
   a5vJKxMopBjz3GjF+sZxvWUu4t4QhFTUiXgoR6fWgSh27bHMv5DvKWlpB
   4Uni65OamTHFAb8jLDQKToQlpkib5JZd8bGhslR42NAduKG/aWCktXXYZ
   tGAi2ktdc7QI4VbWjf4sgBbjYXUdIxjkjH3oMucRiRqVdA86d4FkvWwRC
   w==;
X-CSE-ConnectionGUID: SAkHWVgwQkyWBd9ZOdVuDg==
X-CSE-MsgGUID: w16hxNcRSX+u9VpBl4He0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11458"; a="74039874"
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="74039874"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 20:23:51 -0700
X-CSE-ConnectionGUID: sT69WmYYSu+ANq05YN1mSA==
X-CSE-MsgGUID: 9IDLvjYrQbyxkioJNbRdTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="147361901"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 20:23:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 8 Jun 2025 20:23:50 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 8 Jun 2025 20:23:50 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.80)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Sun, 8 Jun 2025 20:23:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SGYAf9YbKXUmaXX6wlWFnvjU8rSFGBlCohSaLvXWCRpDr462ZTvalgbqc7vdxIxA4M+337Xb60Xf3+L/JfXFuQ3jxEfwZXwuVjVxTwjlWpL68Z/n5dy6zLOXiZDX9tVu0Wddner2KX1BvEDdA63RypGiOZ6bR0WjfnW8t3YWPLqd6KuXU1HaDNBgaYqRqpGVPg5H/NW1JpFSLazw6Wvoq+bjggMb/daXrbiqNVpao5TzajHCqKgwxj3JcYj+uNN9SqvaGMoI6Q7TyXJrAwYMXN5KgwLVgl5dJsjlAva2BSmU54306xy66GSDjdeeDp+yvy/wk2wESTmRzEtMFKf94A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JYgyDxGqxtCGFd++6sYGpd91wGowBv1HRWbG5zrsBtQ=;
 b=QTWs/Xsoxzslxl/Ip6VDC508bmk5fMayVa0CSxY4K7T4JBAe1vM2lUlk2y0cy+Oj4oqJvISlUdHQCSQ8a88bt3poUEHbnFY8Glj9Sq98zITLX91uaPZ+kRRxW0YauYCp31J44GfKpTHndG+ghF+T3nVAPGL/JZL2EH5Ru/5+ehgRzT9LOdHi7kuWudXb3Jdt7r2AmYBq7CXv5RwxbQcdMIsNZJcf7pUXj+iAoU9Mn7ABFlGOc+qOHfxIBhkSE/sAW7ldVNZBW3kfYdolkJSOSmH7XKwp+L3ZxiJ5aioJo1zigzp4ASptOfE9CJ8exTljgRiV0Sk8XlPV6AykjI79Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 DM3PR11MB8684.namprd11.prod.outlook.com (2603:10b6:0:4a::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8813.27; Mon, 9 Jun 2025 03:23:45 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8813.024; Mon, 9 Jun 2025
 03:23:45 +0000
Message-ID: <c2474abf-bf90-4908-a2a7-04e4eb9ee821@intel.com>
Date: Mon, 9 Jun 2025 11:23:30 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/5] Enable shared device assignment
To: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Baolu Lu
	<baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, Alex Williamson
	<alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <20250530083256.105186-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0003.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::16) To CYXPR11MB8729.namprd11.prod.outlook.com
 (2603:10b6:930:dc::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|DM3PR11MB8684:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b4ab085-43f5-432f-1ef5-08dda7050a67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aXRocWZHMHRyV0NQbnZrOVU3aFUrNE8yZm1LdEEzdVA1VlRaVHVZakpFK1kr?=
 =?utf-8?B?VDBLOTBWY1NYVlpBUFNVazJsQWpDeDJnQ29VS3Q4Sy83Zms1Q0VFM2pwcWRa?=
 =?utf-8?B?b0xVMjFWOS9QUE5tZnRpd25xN2VCWTg2V3JVbHNGY0c2bHJTT0lNempXcGVa?=
 =?utf-8?B?MlJTL0FWMWlKemRUUmpsQ0kyTk5yVUM5R2FOKytNTm9QNlRTOWxEbTh2REoy?=
 =?utf-8?B?TzlmVHdFVW9YQUQveldwMkFTU1djZHhNYW9TZFpyK1d4Sm1CdTkvN2FKWkx6?=
 =?utf-8?B?YUNxVThHNlVNb05EbG1kTVZObXM5cDJzSGlGd2cyL3lnWkhxWTdEM1QvcDI2?=
 =?utf-8?B?Smd2bkR2Vzcya2lYRDJsTEF0T1ROcndRdzEvNmVidzVzemo1Ulo1OHRiSUZz?=
 =?utf-8?B?cE5sNEJUdHFVdDZZYzk4dnhXVkFWUmw3NGprWWg5N1VURzc4UU83TDExV1lR?=
 =?utf-8?B?SUU5R2Y4MTg4MkpPQ0xXbW1FMXdYK2ptc1RhSXM5cDBhMVFGZ0tXSm5LN252?=
 =?utf-8?B?MDRGb1dVNmZ1Mk9kWm05NWZkR0o5T0hvZDlOMG5SVFRWYklBMWlkU2ZYM2xx?=
 =?utf-8?B?S0Z6NHB1ZXVnYitrbWJBeVgxOWF3K1hNd1FkRG1pa3MwQzFuV0pHbk9yVnhK?=
 =?utf-8?B?YlJUZ2ZQMEhkbzVKSjV0cVZTN2Y5K3hLc2NoRHU1SXRnbEYybmJDYW00MnRk?=
 =?utf-8?B?eXVlVEpvR3ljYURPSVJ4Y042U1NTanNhM2tjYWxNOWRwWms4cXlBekVJUjF3?=
 =?utf-8?B?TCtUWmgwcVFocUNPWnQ4TDdPTlUvYzNXM3FKTFhiemV5OUtQVDRybFZuMkxG?=
 =?utf-8?B?NGRPZitqSmNZMlh4OEpJU3g0YnV4RldweUpkcklGVzlEQVlRekdKSFFneTJo?=
 =?utf-8?B?dTYvL1FYUjROSzUrc0hmYjM0UDF6VUo1Vm16K2JaUWMySVl1SGhTU01GTko1?=
 =?utf-8?B?VytBa05ZNi9weU1BdDJrTkZVRlNvMzJsMVViSFhDNFBFY0I4emtMRzVIZUFY?=
 =?utf-8?B?eG1NdDFyTldwdXF3S2xON3JTcmdJeGtNTFdURUtXcVFSK0pHeW16NzBXak8r?=
 =?utf-8?B?ai9kUGZVYTFCMnZHbTlyVEp5VnMxWHpaeUFFYXhLaHJpT3l5Z0l4d3pkQUpa?=
 =?utf-8?B?MnVORndEYjlFVUx3VjNVNWlybmJPQWx5T054T2FyY3hqd2t6NG53Q1U2UkRE?=
 =?utf-8?B?bEVUMHk3VTYzaUJjbFNlSVBKTjhPbmNMTW9JeTRxLzZiZXRCWC9mdWVrdXJi?=
 =?utf-8?B?Nm0vL0Z2Z0NqTUppQms3L0VXcXdlZVpDMHJDMUVVZERyaHlCUWNYN3lham1n?=
 =?utf-8?B?eE9QS0tGSWZyMlM1anpCMzRLMDJOZnFkNUZFdHA1eUQ4UGNkbnpVYStRa0tB?=
 =?utf-8?B?Rm9SSjVxVzZpTkdQVGlIb1NLRWdJSkJwaDQ5V3lzSmVVYytsUGV0alh0Y0dS?=
 =?utf-8?B?TjBpdVNFS3hvbjRTTmNLV3EvZ2NqaUVBQWp0YlpySnNmVUhUYlNja2ZOMjBk?=
 =?utf-8?B?T0l2ZHhpdVRkV2xrcUUydnJpTFVVS0ltazVmUDZsODNzazBXZFkrZWt1ZGJ3?=
 =?utf-8?B?Q3lidk5RamRtT09nL2pmVjVPQS96TzBrTlFMT29zQlFJQ0FCdUJIb3dhUmpR?=
 =?utf-8?B?Y1NaTVphVERXK2pMZDNpbVdGZkRWYWNyNGx4MkJON015Tms2OGhaWW1Oejdn?=
 =?utf-8?B?NW1KRXo5S3BybnUzQy9YUVhwTWk0RHU5YTU5T0U2YjM1WlpYSTZlUXMxK0Vj?=
 =?utf-8?B?dURHM0ZBbjlQd1dBTUN2bWtkN1VLaEk2U2VZcGRuUEhmUkMvcElxdWl2eGZS?=
 =?utf-8?B?UGhiN1ZCWEdMcmUvSXdTTGtUeldtQWJRcjVNcFFGT0Q2dlRvVC9VS0tUNnRF?=
 =?utf-8?B?dHk3ZXRRSytPbFRFWm5SSXJhT2pZWGx2SDRMT3VscXRDSmhHRlY5RGRCU1lm?=
 =?utf-8?Q?4pYNI/VxsXQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmQ5cUpIZFJueStQQ29sVHRSQU44R3V6MlhHbm5GUHVBOTBNSFR6UlZNQmVl?=
 =?utf-8?B?T2FFWFM0dCtTcC9USkF2N3ZManF3ME05bVJtb2V3Q2FNWkZ5ZUlRVDFEWkJj?=
 =?utf-8?B?TWhXZjNSdjdKc1pIRmg2QmxIQnZOYm5jSG1PcTZzak4zUXpDTElqbmRTNHdw?=
 =?utf-8?B?andCQ3RoS0ZjNVg0dnJNWVd6YVpWeFRkTlR5STNCRVU4RGpLWnVmZmRhZHVD?=
 =?utf-8?B?RUNDMXN4Vk5JOEpvNTVmWU90NVRpTmJwWFNFbUd1NDZVdndUTHRlVHB2NTJI?=
 =?utf-8?B?NFVXKzg0OW9yUDZZbHo4cDZpMDc5Z2JwSEU2TEVDYTNoN29NZnNZdlFpSXlp?=
 =?utf-8?B?QkVZcWo3N0xFdjlPRHNjeUVCZ3hPTzhzRGV5RU4xbDhycUxLNXFVM3c1bWMr?=
 =?utf-8?B?eGlGNXpaK3FaQ3VZZit6dDNXbytJdVNBaCsrUmhzNVh3cEtNQkU5M1NKMS9n?=
 =?utf-8?B?QlRjSFllTU9qSmE1Q2x5TTRvWTJwWVM5UDlNWVdOUUwxYTZnbTlldldOZGI4?=
 =?utf-8?B?dDc4SnJoRUw0Ykx2bmFzdWF2YVpBUnc5NHo4Vnl2RmxzWnZuWmp2bUNKOWlL?=
 =?utf-8?B?cWkxSEl0Qk1CYUlWOUEwRmlOaDhBa3dzRWNVcUhrdGtML0NxLzdLQkNEcGlE?=
 =?utf-8?B?WGE0dnpVMkljS29xczAwR1NteStKblZMbEtlN0QvTHE4dmpHYWtiUnBrZmwx?=
 =?utf-8?B?ZlRNalZUNm9hb1EzWElYT3gwVnoybG1wYk0wUHZ5REpLSFNkZkRlWWZlY0Jj?=
 =?utf-8?B?QXJyUlJLald2dWd3aklwRVlUc2FQb0hJQ3Rqb3lNOHl1dzZnSlNVaEhYbEUx?=
 =?utf-8?B?OW9UV3BMeHgwbTFMR3lFcTI1ckhjTG9FU2hJbVFHa25DS28zT1ZTMTgrTWxN?=
 =?utf-8?B?eTRTdFhSajc4b0p2cHZUUEdwU1ExeHMxaFJIUllqbVl4RVhUWlAzYWw4Lzl6?=
 =?utf-8?B?WEE3MTNjOFJhY0gxcjN0cVBuTlVFTG1HOW9oU2wvcW53NGt6aFFBOEdGWGVt?=
 =?utf-8?B?YVR0RkJCenlWZWdad29BZjFMNGRGRjBCSlEwaTdkZDUwZ3RxTC9qWWVjRllO?=
 =?utf-8?B?Y0VrV2V6WUxhR082ZTVENmRkclFoT2dTaktLVWM4UHYvVS9RSCs4SC9wZ2NF?=
 =?utf-8?B?WUpIVldNTzB0UUNxeEJjb0QzenNwUGhxRGtVU0YrSFBMNkNvNWVCUzVPVGp0?=
 =?utf-8?B?OGhEOFJXdlYvN1ZVM3p5bTJUVmcwT3lIQURvN25YR2ovdjdkUnIwWGFFQm9O?=
 =?utf-8?B?dHJrRzVZVGQ3eXF5aVlpbTAzUVM5NkpibjFSVit1cDZxZkUwWFViRTRpZTU4?=
 =?utf-8?B?RnJ0YmJ6b3BqR1lQbGNBcndPZ0RyS3pGZU96ZVIyR2J3TStlMzQ2ZG9wQW8y?=
 =?utf-8?B?SHU0Q2V2bk1mbGoyK0FBSEhSNDhCZmliZCt0YjFpZDhIOUw4ZmNMejN1VklS?=
 =?utf-8?B?SitDTWcxSHJ2WncycVNpM1Q3WGxvZlBTWFdzanhsMHVWWFEwVjlYcnNudUhG?=
 =?utf-8?B?bTRVd2ZQWEt5MVBDYVYzdExEL0NYL0g0UXlybVZVQytVOTNWTjRLeHhzT1Aw?=
 =?utf-8?B?WmcrUVIrTFlmMTZBRjVEejhmMmtFa0p4N1BJTE5IR0JxNGVnTzh6bUg1RWUy?=
 =?utf-8?B?M3NlSSthRHdlWGRTNFl1WHIvS0VOaHJEYXlZQlk4clJvQk1JYVdidDNsTE10?=
 =?utf-8?B?Z04yMXJIQXFLUHNMeTRyTGlSM1RsSFlnbGtseHVNVHlmMHVoOUhsNWgxZHVI?=
 =?utf-8?B?R000NEhnYm12WE5XZXVXUDloOFdwVzlkSnRRaDNjbDVLT0dNMEtJRnRQMlZL?=
 =?utf-8?B?VFV5OTk4NS9kOFBMWU1CdVczQzcvRWhDZWNoZTliNURSVXpTQWY0STBaUkZ3?=
 =?utf-8?B?UzNnM01ndUpYNnQxSDFXdUZNVk1SakxpekNpYWdIQis3RVZXZmpyQ0FPc29v?=
 =?utf-8?B?THV1cHdwWkh6bHNxYTNjZTZSTDlFQlF0VnV5T0xHSjl6cEVUeXdMZVBFK3VN?=
 =?utf-8?B?b2FHSDlpZk4zQzA2SDBJOFZ1WHI3SUhXeDZlSTZBNVZDVXA5SmZtK3prckVm?=
 =?utf-8?B?eXdnbGc5YTJRMHJIWExxenhjYXRvQmx6VE16a2FObkQrMWkwZFMycnNMMnl0?=
 =?utf-8?B?VlJrVmlMdFk1cUxVdXIzbi9NbUd6TWFzY0hhYmN4UTVOcWpxL1NXd2h3WVhs?=
 =?utf-8?B?Z1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b4ab085-43f5-432f-1ef5-08dda7050a67
X-MS-Exchange-CrossTenant-AuthSource: CYXPR11MB8729.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 03:23:45.3921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kXD6CAh20yEcKFbdIWiZzD28C0KX7DY3MsazGuc8Usu9Ea8TSokBDQeCOm6+yxCwqMPi2VZhh9w+ojN4WljcwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8684
X-OriginatorOrg: intel.com

Hi Paolo,

Since this series has received Reviewed-by/Acked-by on all patches,
besides some coding style comments from Alexey and the suggestion to
document the bitmap consistency from David in patch #4, Any other
comments? Or I would send the next version to resolve them.

Thanks
Chenyi

On 5/30/2025 4:32 PM, Chenyi Qiang wrote:
> This is the v6 series of the shared device assignment support.
> 
> Compared with the last version [1], this series retains the basic support
> and removes the additional complex error handling, which can be added
> back when necessary. Meanwhile, the patchset has been re-organized to
> be clearer.
> 
> Overview of this series:
> 
> - Patch 1-3: Preparation patches. These include function exposure and
>   some function prototype changes.
> - Patch 4: Introduce a new object to implement RamDiscardManager
>   interface and a helper to notify the shared/private state change.
> - Patch 5: Enable coordinated discarding of RAM with guest_memfd through
>   the RamDiscardManager interface.
> 
> More small changes or details can be found in the individual patches.
> 
> ---
> 
> Background
> ==========
> Confidential VMs have two classes of memory: shared and private memory.
> Shared memory is accessible from the host/VMM while private memory is
> not. Confidential VMs can decide which memory is shared/private and
> convert memory between shared and private at runtime.
> 
> "guest_memfd" is a new kind of fd whose primary goal is to serve guest
> private memory. In current implementation, shared memory is allocated
> with normal methods (e.g. mmap or fallocate) while private memory is
> allocated from guest_memfd. When a VM performs memory conversions, QEMU
> frees pages via madvise or via PUNCH_HOLE on memfd or guest_memfd from
> one side, and allocates new pages from the other side. This will cause a
> stale IOMMU mapping issue mentioned in [2] when we try to enable shared
> device assignment in confidential VMs.
> 
> Solution
> ========
> The key to enable shared device assignment is to update the IOMMU mappings
> on page conversion. RamDiscardManager, an existing interface currently
> utilized by virtio-mem, offers a means to modify IOMMU mappings in
> accordance with VM page assignment. Page conversions is similar to
> hot-removing a page in one mode and adding it back in the other.
> 
> This series implements a RamDiscardmanager for confidential VMs and
> utilizes its infrastructure to notify VFIO of page conversions.
> 
> Limitation and future extension
> ===============================
> This series only supports the basic shared device assignment functionality.
> There are still some limitations and areas that can be extended and
> optimized in the future.
> 
> Relationship with in-place conversion
> -------------------------------------
> In-place page conversion is the ongoing work to allow mmap() of
> guest_memfd to userspace so that both private and shared memory can use
> the same physical memory as the backend. This new design eliminates the
> need to discard pages during shared/private conversions. When it is
> ready, shared device assignment needs be adjusted to achieve an
> unmap-before-conversion-to-private and map-after-conversion-to-shared
> sequence to be compatible with the change.
> 
> Partial unmap limitation
> ------------------------
> VFIO expects the DMA mapping for a specific IOVA to be mapped and
> unmapped with the same granularity. The guest may perform partial
> conversion, such as converting a small region within a larger one. To
> prevent such invalid cases, current operations are performed with 4K
> granularity. This could be optimized after DMA mapping cut operation
> [3] is introduced in the future. We can always perform a
> split-before-unmap if partial conversions happens. If the split
> succeeds, the unmap will succeed and be atomic. If the split fails, the
> unmap process fails.
> 
> More attributes management
> --------------------------
> Current RamDiscardManager can only manage a pair of opposite states like
> populated/discared or shared/private. If more states need to be
> considered, for example, support virtio-mem in confidential VMs, three
> states would be possible (shared populated/private populated/discard).
> Current framework cannot handle such scenario and we need to think of
> some new framework at that time [4].
> 
> Memory overhead optimization
> ----------------------------
> A comment from Baolu [5] suggests considering using Maple Tree or a generic
> interval tree to manage private/shared state instead of a bitmap, which
> can reduce memory consumption. This optmization can also be considered
> in other bitmap use cases like dirty bitmaps for guest RAM.
> 
> Testing
> =======
> This patch series is tested based on mainline kernel since TDX base
> support has been merged. The QEMU repo is available at
> QEMU: https://github.com/intel-staging/qemu-tdx/tree/tdx-upstream-snapshot-2025-05-30-v2
> 
> To facilitate shared device assignment with the NIC, employ the legacy
> type1 VFIO with the QEMU command:
> 
> qemu-system-x86_64 [...]
>     -device vfio-pci,host=XX:XX.X
> 
> The parameter of dma_entry_limit needs to be adjusted. For example, a
> 16GB guest needs to adjust the parameter like
> vfio_iommu_type1.dma_entry_limit=4194304.
> 
> If use the iommufd-backed VFIO with the qemu command:
> 
> qemu-system-x86_64 [...]
>     -object iommufd,id=iommufd0 \
>     -device vfio-pci,host=XX:XX.X,iommufd=iommufd0
> 
> 
> Because the new features like cut_mapping operation will only be support in iommufd.
> It is more recommended to use the iommufd-backed VFIO.
> 
> Related link
> ============
> [1] https://lore.kernel.org/qemu-devel/20250520102856.132417-1-chenyi.qiang@intel.com/
> [2] https://lore.kernel.org/qemu-devel/20240423150951.41600-54-pbonzini@redhat.com/
> [3] https://lore.kernel.org/linux-iommu/0-v2-5c26bde5c22d+58b-iommu_pt_jgg@nvidia.com/
> [4] https://lore.kernel.org/qemu-devel/d1a71e00-243b-4751-ab73-c05a4e090d58@redhat.com/
> [5] https://lore.kernel.org/qemu-devel/013b36a9-9310-4073-b54c-9c511f23decf@linux.intel.com/
> 
> Chenyi Qiang (5):
>   memory: Export a helper to get intersection of a MemoryRegionSection
>     with a given range
>   memory: Change memory_region_set_ram_discard_manager() to return the
>     result
>   memory: Unify the definiton of ReplayRamPopulate() and
>     ReplayRamDiscard()
>   ram-block-attributes: Introduce RamBlockAttributes to manage RAMBlock
>     with guest_memfd
>   physmem: Support coordinated discarding of RAM with guest_memfd
> 
>  MAINTAINERS                   |   1 +
>  accel/kvm/kvm-all.c           |   9 +
>  hw/virtio/virtio-mem.c        |  83 +++---
>  include/system/memory.h       | 100 +++++--
>  include/system/ramblock.h     |  22 ++
>  migration/ram.c               |   5 +-
>  system/memory.c               |  22 +-
>  system/meson.build            |   1 +
>  system/physmem.c              |  18 +-
>  system/ram-block-attributes.c | 480 ++++++++++++++++++++++++++++++++++
>  system/trace-events           |   3 +
>  11 files changed, 660 insertions(+), 84 deletions(-)
>  create mode 100644 system/ram-block-attributes.c
> 


