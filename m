Return-Path: <kvm+bounces-65046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0344FC995BA
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 23:16:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 35362346562
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 22:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9153C292918;
	Mon,  1 Dec 2025 22:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J9MHk8EX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCF72877E8;
	Mon,  1 Dec 2025 22:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764627287; cv=fail; b=PNzmNx9YBkfX3HwHKg5WmiHLeJzkS8c/1fAJ7OMMqe2TmdFs5LVn8VaKGfRfJhfnbwQFKQXA24jEQY2u/a4fYhzpGsjOwprB7M50Cfkk9MB2zEugFCtQmvquxO9H7KPr7LBmcvuLpAqwtIwjA5kObomBKw0CP6I8bsJdhWb0ZF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764627287; c=relaxed/simple;
	bh=wendVXdQgn1xrBuX1hoaCODKqJYyUb46Elm3JGGSQaY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P0PQDJ8FXOsqFlSvzA+9g8GqN1oHTeaM8/Vlbk7Tdu4I1pE8fZPb0kr+h+Ap0HtOUWFt/2d/Lvgpub0jn8gb5aP/bgElN8+1tXtiTtAAedg1nLkp4N+S5XuUnxHkdGwRaYEOC/Fe6qvHPoK8mu+0Y/KhrItxc6h9pvkSoqSpfFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J9MHk8EX; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764627286; x=1796163286;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wendVXdQgn1xrBuX1hoaCODKqJYyUb46Elm3JGGSQaY=;
  b=J9MHk8EXfPTf2rkHP/vppeHd3Sz7lI5P+RtI9+hQctwtlEiIMisGNk+I
   TAL3z89AzG1rAbb5NIDFwDNspwOgjENB1j5Tg1EkZip+s8weWwyAewCOb
   PdGJE+EaWgzKZkDObEiHBtF1soy03Nkay5CdW3pqaLG3XyjVwAG/Mvu9j
   CQQ0UI2fYw+Av/TQqqGjeOu7nDWQQk3rWjRfDuRW5OHKrs8Gu8rikQ/sP
   R3leRu9Wi8QBA68eJmtiayUNsmsBB54SPGnr7verjY9ptP9CwwtdTUjtW
   O3+wEbgkgZ0jNUvx1Do8by5GwNmgWx83s0RALXmElwd1l+cpiWGnNAMUN
   A==;
X-CSE-ConnectionGUID: j9yfw8ZWTVy6XrjyPBRzYA==
X-CSE-MsgGUID: Bz5ItCTvQJCs8HwE8lHnhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="69175175"
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="69175175"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 14:14:46 -0800
X-CSE-ConnectionGUID: irEbnL6DRFmlJwmRZXf4vA==
X-CSE-MsgGUID: bHZ7zLloRO+rLNXI0WC5dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="193313244"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 14:14:45 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 14:14:45 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 1 Dec 2025 14:14:45 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.71) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 14:14:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nChdMsnFS8Zs01FYfW9UNf8NAIJmHZf3xKYtDO4a1fXQzqWbrU+yOrTJ9pBBnmD19bQM+yl2OFVGFYs+xdCvym0RZcq1jN7OErLA8rLxe2ST/I1DAkybrYtmWweYtboYE9f1YfsVD9pRh8U0MvzcrzHYGVOUvbHH8ObrfuG1CLENWgUMq5w7jok3Pppb0JYS1hRbGKxm2AyzGNuY1Q58RHr0OeLj0/ieRiEa5+XHcc8h/8/gWXxqXm2kvYqZ+9llISonR6wJs8+faT0qPEQfbzcHGdsFWav6MPf+avDijkjPO1plray8Z9H+WM4fYFPv0Lh3+PP/C9q8RWzs1fbi5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wendVXdQgn1xrBuX1hoaCODKqJYyUb46Elm3JGGSQaY=;
 b=DIOyQd5YbXKH7vzQSK85mgJz9cFntPHu3rsn9fec5gxXJ39cS2vDUISNYO7Or8aW9yw1p7TBdI66Z/0I+ppU8Qg62zefT2Xk2d2vQbDZFG8cdGuj3TAgnnEopgfS5zSSM7M/kM1MuQLTahXMFdtJ8ZF2SikVicy6YAWlno56lUZFfy/H9mw4v+Yfe+UeRpuTAEW30DIFWJELadPCQuP2rbQ9f7k5M//l55xWfZ/xCrBG/IyxLHNWICsG+UyEXO6Bz2OOqCbLPHX/l9CqRtNH8NMlUqNqZ7Ba7eej/8PDDvFjbHRoXrB35kABAHpsl06s2HfLElXLC4JNEbMiDDnlhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM6PR11MB4708.namprd11.prod.outlook.com (2603:10b6:5:28f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 22:14:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 22:14:41 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kas@kernel.org" <kas@kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v4 06/16] x86/virt/tdx: Improve PAMT refcounts allocation
 for sparse memory
Thread-Topic: [PATCH v4 06/16] x86/virt/tdx: Improve PAMT refcounts allocation
 for sparse memory
Thread-Index: AQHcWoEIX9Tgaj6+NEu+xgbyqcurk7UCvnYAgAK4PQCAAUFtAIAGsqWA
Date: Mon, 1 Dec 2025 22:14:41 +0000
Message-ID: <73a0ed8b993478b0854747853508f2d9b3b975db.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-7-rick.p.edgecombe@intel.com>
	 <468165b7-46aa-4321-a47f-a97befaa993f@linux.intel.com>
	 <21a759efdcfb4429ed952303f7d7143263220b22.camel@intel.com>
	 <irqkfods52iut7se552qo6b5o4qidtmghcdosdxmbytvpyphpi@ol5wuaoydaab>
In-Reply-To: <irqkfods52iut7se552qo6b5o4qidtmghcdosdxmbytvpyphpi@ol5wuaoydaab>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM6PR11MB4708:EE_
x-ms-office365-filtering-correlation-id: 9b9ff61a-0749-42ba-a23c-08de312706b0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?eHprT1RnRG93RDQwSmhJdHFSTUU2Vm9jSDFmalFYVE1zalNIZUwxK1hURXJ3?=
 =?utf-8?B?Mzc5VGZXeC9qSzBEeHBEYStmcThqcVprSXY0SVpRRGRMWklibnFONk1EcUsy?=
 =?utf-8?B?dXUvcXBYM0JsMmlBdGk3UGVubXJqTGRtL2xyMjdnY2dmNm5FZEZMT3ZvYXox?=
 =?utf-8?B?ZWltOTBKSElPS2ZUYXEwVFZpR29XaTZmM0w4L0xnZnZpV09YdlQ3OUFTVyta?=
 =?utf-8?B?QTdLVW95MnErUEdJVW9rZjlFV2RVanVxTzhKUlZGM3JMUmEyNExBQmJLa1Za?=
 =?utf-8?B?bmd1cE9vdEpTMXNQWlZaTXlLVmcrL1B6VDNiL3dSMnVNVk1ob0pYa0t5d1lK?=
 =?utf-8?B?R29oYXJkVEx6VVBVODNudDdTNStUajJ0MkIxeEhob0RsbXlleVJ0TnNJcUN0?=
 =?utf-8?B?NURMVXM4MStBSVFub1pyQ3FIMkFPbU4xbW1rQ0UyQjhnV1hnMjlSdUhSODJK?=
 =?utf-8?B?WGYrdmVvMXhjWFFoVTFIVTRBN05ab3A5WUpIZVlkdENVK1BLbktwOHgvZXdR?=
 =?utf-8?B?VTJLOUd6V2oxTkxDMkxZNVc3ZThPbGNwclBxR09hRnIrcnZ4WDA0dmt5dm1X?=
 =?utf-8?B?aGZDQ2JvakZwdGZ5V3VXU2NmK2ZqZHg0Q1craGYrTHYvdTNMQ1NrR25nSUVl?=
 =?utf-8?B?b1pVeE9EYUNzY1ZhSDZSY3ZnRStiRXNPWmNScXZkV0hUWnptdzBCVzVkTGxv?=
 =?utf-8?B?eTgxNGE3bG1Ydy9mbHJ6K1IySFlReVkrR0FDS0hjTUZiQnlMbjdVZHN3NnVm?=
 =?utf-8?B?OUx1czlUbTlVQnFGRDRsTy90VXFRZlBQY2xMSDVmRTZvejhFZDl5N0ZNOTZK?=
 =?utf-8?B?aDZ4L2VMOHpEb2JCczFIb2JYWmt1c0FlQ3ZGOUZzb0dFTFZMSU9zSXVzRHVD?=
 =?utf-8?B?d1RyWmJHYk5pb3R1Qmw3UGFRRld1M21tZURDN3kwNDZOdTRhcGlnQkkwcll6?=
 =?utf-8?B?L3BMMmg1VGdQZE1uUFFWeW85ZjYwOWZEM014Ky9ZajdqV0hWd2thbDRnTGRQ?=
 =?utf-8?B?ZkpZSjBMOFBocW9BRXpIcEpzM012Z2hpWUR0ZVV3RnF2ajFvVHJ0K1JxdHBr?=
 =?utf-8?B?NTQ1Qk9VNjFWbmJ5cm1tTUp2UklMcGJicGl4aFZmTHpFRVhGcExwa1N2RUpv?=
 =?utf-8?B?cW5OWkpUTWU3WG5sUnAwSkxvckxxV1F6dFRSdkNjNjFObm5ReVNjZDdVcms0?=
 =?utf-8?B?alJMM1BvRW1MTkVmTjRVdTVrSHFHVmg3NXdUVnRJQkJoSE9YZ2tuS0tHQ1BT?=
 =?utf-8?B?V2kyUmVuU3VmQWxBOXVWcUFpQllqK0o0RnZjWjJsd1duVjNzS29ab2N0K2hE?=
 =?utf-8?B?VkRtNGFxUGJyOHRGZHhmbk1saEdheHdZQlM4a1o3cDdpNHUvamVoNVVWRHRJ?=
 =?utf-8?B?SEp0NWg0SzJtQ3ZEV1NOZW0yY2pva29BU3RDRzdOcUMwbWFudjA2aEVBRmY3?=
 =?utf-8?B?dzdVMm1PYjhMNzZKcGdXWkxZdGpxUzJSeGJWVXJodUZCVEczUmY3OHByLysy?=
 =?utf-8?B?VlRoQXFnSmxha2ZiY01tVVk5bldCRGRTREN3bVdObVV2Q1BiekEveUR6Vzhy?=
 =?utf-8?B?MXBJMmk5eXYrNmx1TW1telF6OWw3dFRjUDRmVnFlaFd3QmlxQk5SenZ5alpY?=
 =?utf-8?B?czl3bytFK0hLLzR3YmpxcWR6OFBydDI1SUZZTHViSVVBTnZ0NktFby81UFYw?=
 =?utf-8?B?UzdPdmlhQUh5UlZKQzZCdzBYaW13S29xNjZtQUZ0YkdhRXRReU1YOGttZFFS?=
 =?utf-8?B?UXRiRURtT0kxZzR5RFJNTzB0Wm8zTHRTYk1JUmo4ZGhENG9MVnpuNlFONmdp?=
 =?utf-8?B?NldpUXlhcFd5SWs3Tm8ySWExWmhSMkVxc3dqOFk0MzFxV0s1cjV1OExZOUNX?=
 =?utf-8?B?RUNYWEhmdEZyUTJrTUFGcTAraHNCclhaeE1mOWlIbUhndmI4U3NyNnBONkgw?=
 =?utf-8?B?VzdOOHMybnh6MWlHdVY0WlluKzFSMENVSHVxenlUd0dUSmxaVWgreWx5b0ZS?=
 =?utf-8?B?S1phZ2IrNmo2M0t2ZGRBVHRoRCtCOWl2OCtyVERRZmhVNmZoN2Y4NjRQOGZp?=
 =?utf-8?Q?lOLqLT?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aXhxcTFWZm9POUI3Mmx4UXE2Q1N0SlFXRjdRdFYyanZWWFdPVnNuMmFEMEFj?=
 =?utf-8?B?dDBkZ1hYV1VuTzVuWGdQQTY3Y1A3MWIzNnVYTktTT1RHYXRoeGx5TnArWjRn?=
 =?utf-8?B?eENQb2VDdURXVllhTlozUnpoMUhrS3UxWU45TzNyVHdVT0VrSGpLK3lncGRW?=
 =?utf-8?B?WDhDdFRWYi9hbk5CZm5TV250VlVlNWdrTTBsNTVhd0lmU1lJMUpNU2dQbjFS?=
 =?utf-8?B?V1pwUzZIdTR6Z1BmR0tmNkEyY0xYNzdvWlB4a3BUSEFYYnE5aU5jMmVOdzM0?=
 =?utf-8?B?aHR3SEdIbTBlbFdXNHE1WUlWOG9wNUlwNmpJbmphMUdWdEZJUUtkRjk5TXlj?=
 =?utf-8?B?TWxHYVB4S29PelpTbzIrcFFXR3BXWDV1a2I0TmUxbjNoa3dWNUZNbEs1UkZ3?=
 =?utf-8?B?cDkvZTJkekNYbVkyTWg0UnBUWGF1cHRMNFhPMHNzeEZ1Z1JpUGxCM0lzTWtj?=
 =?utf-8?B?NEh2ZW50K3l6ekdRMWptc0x1eVFUUmprazJHektiT3Btcm44MWh3RlpoQ1pE?=
 =?utf-8?B?MW1LaUxEb0ZVNGJybjdXUEMzZnNkSGQyUGZYVVZodmVUYnNJdmhSQVM4RWJH?=
 =?utf-8?B?ZCtyMXdVajFjcFR2U29tWm1TSWFvdk9idk5qU294L0dSd3JEZm5lYzVnTEk5?=
 =?utf-8?B?bWczSEFsU1QxMkdabEZjL3kyZ3AzZy9UQitUZmVZTW9RaHBnNEZ4U1p2TmVW?=
 =?utf-8?B?emw0S3hPWG9KYVpkcktQdWpPZTdad3ZoMXpob3VPWCtMNFBsK1RuK2JMbjg2?=
 =?utf-8?B?cmZQdnJUWmd3bUt6NlJXQUU3TFA2NTNVbzFieEJKNVlhYUpyQWpkYTFHNE5w?=
 =?utf-8?B?UXJBRmoxL1dxR2xIUjZWS2RYTEdCSnpiZmVGT0NXaS9GNkI5N2kwTjJHblJK?=
 =?utf-8?B?dlBTd0wxQy8rdW1TODRvQVlqb0JFcUY4dStYQXFaNFJIRE9CSHFYTUE0SUdq?=
 =?utf-8?B?dzhqcTNNajhrUmNVbEh6NGNPclNGRkJpRUVDVDJ3Z3IvQ2Y2Um8xb0NaSk1q?=
 =?utf-8?B?d2NoMVJHZnpIU213N2lnZTJjU2VDUlI1d2dBdW9yRnZpbzUrQ0ptcGNRb20r?=
 =?utf-8?B?U3JPUC9vWjY2WkI5eUdnRHVjLy9FS1NUUGlJOTkveUlRMHU1NlIvcW5Jb25q?=
 =?utf-8?B?ZjdPZDVyeEh4d0pQcW9ZVjY2WThaYmZqeVRobjNRekV0ZXY1aU90YlE4VmdS?=
 =?utf-8?B?THJWSG80WFU0U1czVy9WWjF3bEhhMkE1Z3pCRUN5cHFFMTY2WHR6Ly9oRmZ0?=
 =?utf-8?B?RS9nT1R5WFdTZldKeDl2RjVMZkhVay9ETW5naFRGQ2pIUFY1ZlNSWkxCMy9j?=
 =?utf-8?B?VTBmRFNaZUJnQmZvdnlnRGhDQXMvSEdQOFY2dVoxVkRMMEUydmhsdHU0dXFp?=
 =?utf-8?B?ZlQzbjVuenZKODNkRVdoeGFWdm1MblpYbUVpM1NRQnNmMjFubGtMMnYxTnBm?=
 =?utf-8?B?dmppclY2WlVxZjhYYjdTakdnNURNTXNyZTdnNGJtQWEvRmNEUzRQeUMwSUZH?=
 =?utf-8?B?Sld4b0NxZVl6bHpjb3lZVXRXTXdMZTU4YzAxdktDMk5adkVLOFF2VEcrcU9y?=
 =?utf-8?B?TmdIM2g3NFkxa2RHQndRUHg1VThhR2FKVkloQzd6N1c5RFkzd2VOR2JOR3dv?=
 =?utf-8?B?Z2FpdU5jUG1EKzdFWitDWDRsYWRRR1dyR3d6Ylp6STNwOFRmcEQ3NzYvVlE1?=
 =?utf-8?B?REpqblh1U1JEYlVZWDVUM01seUJ6VVNFaEVBS3AzV2Z4TE44SXpuZjlNeGRx?=
 =?utf-8?B?bFdjWWgyZmdzUlNnd1dXRVlVN3J0NHBaM0g0TGlyUFJWOC9HUVBUZ3ZXY3Q4?=
 =?utf-8?B?S25yQUh5MUFnTjcrOGJwZEt4QWNYd1IvcDFHb09SSnFvdnFQRDZqYWZSNXpD?=
 =?utf-8?B?TjlhNllwUjJCTnkyc2xPMUxQV2VwaW5jM1g0YnNUYm4yd2xrQXErV3MrM2Fp?=
 =?utf-8?B?TXZyYk1BdFNqK1ZCenZiREVQMldmOGo1SEFsVE9rMENYejVDb1dFSG5vVzNv?=
 =?utf-8?B?ZklxakhsUDRYdXZZVHZ1bVpyS3RtQkhIT2VXcFNkRDd6aE1SVFNoRitNbnZH?=
 =?utf-8?B?eDkvQmFUTktic2hNNWtoYW9CYldXdEZ1MjREVUFrN1hTSWYyN2Y0SGpzQTg0?=
 =?utf-8?B?Vi9SeDJkNUtGMTQ4a3FlR0RsY0hjakV6alR3YzZodHZwOFl4dVZXWThFZklY?=
 =?utf-8?B?RGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F068ACFE93005C4184898ED4BF2105CE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b9ff61a-0749-42ba-a23c-08de312706b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2025 22:14:41.8341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: udLGNUo/UkOEaOsUjF0BoDDaPkXXI4derbZpIOWF7iaeiCRP9gvafgBCxP8VVb4H0zImJpR35qYbfU+sI/iBv8UcwTJ6/tjTNicmWU1NPSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4708
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTExLTI3IGF0IDE1OjU3ICswMDAwLCBLaXJ5bCBTaHV0c2VtYXUgd3JvdGU6
DQo+ID4gWWVzLCBJIGRvbid0IHNlZSB3aGF0IHRoYXQgY29tbWVudCBpcyByZWZlcnJpbmcgdG8u
IEJ1dCB3ZSBkbyBuZWVkIGl0LA0KPiA+IGJlY2F1c2UgaHlwb3RoZXRpY2FsbHkgdGhlIHJlZmNv
dW50IG1hcHBpbmcgY291bGQgaGF2ZSBmYWlsZWQgaGFsZndheS4gU28gd2UNCj4gPiB3aWxsIGhh
dmUgcHRlX25vbmUoKXMgZm9yIHRoZSByYW5nZXMgdGhhdCBkaWRuJ3QgZ2V0IHBvcHVsYXRlZC4g
SSdsbCB1c2U6DQo+ID4gDQo+ID4gLyogUmVmY291bnQgbWFwcGluZyBjb3VsZCBoYXZlIGZhaWxl
ZCBwYXJ0IHdheSwgaGFuZGxlIGFib3J0ZWQgbWFwcGluZ3MuICovDQo+IA0KPiBJdCBpcyBwb3Nz
aWJsZSB0aGF0IHdlIGNhbiBoYXZlIGhvbGVzIGluIHBoeXNpY2FsIGFkZHJlc3Mgc3BhY2UgYmV0
d2Vlbg0KPiAwIGFuZCBtYXhfcGZuLiBZb3UgbmVlZCB0aGUgY2hlY2sgZXZlbiBvdXRzaWRlIG9m
ICJmYWlsZWQgaGFsZndheSINCj4gc2NlbmFyaW8uDQoNCkVyci4gcmlnaHQuIFdhcyB0aGlua2lu
ZyBvZiBmb3JfZWFjaF9tZW1fcGZuX3JhbmdlKCkgb24gdGhlIHBvcHVsYXRlIHNpZGUuDQpwYW10
X3JlZmNvdW50X2RlcG9wdWxhdGUoKSBpcyBqdXN0IGNhbGxlZCB3aXRoIHRoZSB3aG9sZSByZWZj
b3VudCB2aXJ0dWFsDQphZGRyZXNzIHJhbmdlLiBJJ2xsIGFkZCBib3RoIHJlYXNvbnMgdG8gdGhl
IGNvbW1lbnQuDQo=

