Return-Path: <kvm+bounces-35738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 73F78A14C84
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 10:53:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD1EC3A2B36
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 09:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9311FBC96;
	Fri, 17 Jan 2025 09:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gtMJmUUc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6CA1F9413;
	Fri, 17 Jan 2025 09:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737107623; cv=fail; b=QcKUXj7MlieeeOvUoSn+9MZGJNRxaPKaWTIQTYlNsPbRd21MBw0WwVPH6I52WB/UjdvDk9FHXlEuIpW2xh9YkId9S3/i+o+gVjbCdJUmzt+f52N7lUqT7tto+JKKu9vHKy6GB63DsrbV/toftN0vivHMXyhBVO/zRrEvJQChICI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737107623; c=relaxed/simple;
	bh=jpd7x8A70ga+mlAk+Ukaf1bMNgwx6pID+9UC1ejrZTs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nzpIq6JeYFCzb+IVu/hXFklkJ/TMcsvaK/zQp7SsQ5O3jMNtBH2D2mA5dl/gLfzyolMqyTc/GaSc5YcIEMRFw1/KHzjMsDhRoWeSQJn+9W1KaPC87PbMjeN+vqOyzGRstbnvTp6JMdyayf6xBoAyWCIonVPkFaBdmHP7zZYr5zQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gtMJmUUc; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737107623; x=1768643623;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=jpd7x8A70ga+mlAk+Ukaf1bMNgwx6pID+9UC1ejrZTs=;
  b=gtMJmUUcFdTEZnIpSR2L3U5Uu5O1TS24+uRsoO8FEY+SWPU3ht3VoEY+
   lBdljtNlsQIyVAQwoQ1AAgqEq5w9oKmaC7U8ncKRDSl0VvitBkH4IpKEs
   ZmT5sJ4QV+sAuEOYtywJte0i9dS370XRpJZHYamJlfXcgebFuhCHuv1jP
   F0i8uUi1B/oGTyGM3kOlmWBeKfIxmXGlKOYd15L5G/4lgTWyML/ttIX2O
   bhVehuVAqIaA0/4XTEVl9+VqPjdeYLrDVsdcNyEar+yu7EYwbDRcaojeJ
   FFFuRsne6FRmIzlc+MfKFBoOu6yGtPTs+y1V7HIlM3GC0ChaA9YirDyxX
   w==;
X-CSE-ConnectionGUID: 8g7ypSj7TlinhpLaEw77Vw==
X-CSE-MsgGUID: /4UEBEGTQxG3ohVD16kTCw==
X-IronPort-AV: E=McAfee;i="6700,10204,11317"; a="54945985"
X-IronPort-AV: E=Sophos;i="6.13,211,1732608000"; 
   d="scan'208";a="54945985"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2025 01:53:41 -0800
X-CSE-ConnectionGUID: ewOdEkobSlqtmzVezK3How==
X-CSE-MsgGUID: h9losi2iR4SIFEOh3CBLvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="143046012"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jan 2025 01:53:41 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 17 Jan 2025 01:53:39 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 17 Jan 2025 01:53:39 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 17 Jan 2025 01:53:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QW1JlC82Ftiz9HzaCWXjZ6L64opBqPjEierOsgO7BXq1wr04axWuwxGW5xOxQSKQK5T3zScerqFnVZPI+ZqkuiYAShLPIVZWSzDqm5Y61KOguqhQk+Y39Yb+BLlQEv5MIGNtN55F5ip/jhO26hHUNgPKf643ZBkWwEh02wtaZL82myfPi4eFiaodggJDhBiHSpuH60SwmD7lK8nOJbIGC13h4c43VwtiOV/y6lTjedZfthM+LCOkI/DOlWutWY59Ssd4eShBVS8e5/ZRMb5XMoqEOU3CjUbnj4tmhKb2dty32VoBAxVGAolu7TYEFEPIytRYV/4GqWCreYXGe42Q+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xHauSP+jC72PHBS84W57uk+Q1UBVXeAu+5pdDSoaq2M=;
 b=x3lMvsFGDQkOk3804nw6FG0QfhdKQG2/2zY90oAGnXcvaLv3FYTeHZ8n1Hwy3POsBEWeDcz4+pm93CkuZjm5rswBVYpsMRqbI0GFprm11MoKJFtjqYjbZG92zfhTyb036ItUs0zLtnGc2BaAUuot4CNOXMqXAd4MQ31C1X/gAvH3D6UdI6hBS1isg9/EnlhDGt1SC2Emnw4Q01t1s9r84ynwy44WOJ6QLtxCYQe63grJoWrv1KZ1LoH1pwTdeA91gWNQSG/MfoRzB2M9s0uMY+/aZORBmCr6yviIDMcNky/5m2ZIS0C7RyqAsSfa02DIhEihOXiShKoY2YTT7AdDFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7903.namprd11.prod.outlook.com (2603:10b6:8:f7::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.15; Fri, 17 Jan 2025 09:53:37 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8356.010; Fri, 17 Jan 2025
 09:53:37 +0000
Date: Fri, 17 Jan 2025 17:52:38 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <seanjc@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 0/7] KVM: TDX SEPT SEAMCALL retry
Message-ID: <Z4ooZmdcf7O0SNve@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
 <cd099216-5fc7-4a79-8d35-b87c356e122b@redhat.com>
 <Z4hYOviOCaOcpxsw@yzhao56-desk.sh.intel.com>
 <CABgObfYpyUT=HubreEO1=HzSdsCwnJs6QTj6weibJ4wqYZ_W3g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfYpyUT=HubreEO1=HzSdsCwnJs6QTj6weibJ4wqYZ_W3g@mail.gmail.com>
X-ClientProxiedBy: SI2P153CA0021.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7903:EE_
X-MS-Office365-Filtering-Correlation-Id: accdfd57-f47b-4d86-cc02-08dd36dcd060
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cFdOU3Q4MVRWRE1aNWpxa2Z4dndLUVVkSmNXY29lZ0hHMVVKVXgzS1h2dDVr?=
 =?utf-8?B?b1FJN2ZxNkJSdjAwR1I4b1NnbUxsaTRtbTdUMmcvMEU3OXlrb3NDaDFFTWNC?=
 =?utf-8?B?dEVvOFRWMWVuK1ZIU2tMQW5TUWtkajBBdXVRT04rRHBKQi9TblNBeTVzNnY3?=
 =?utf-8?B?bUdPZ0xTWU1lQ2kxcDdZS0JnMWZ2ZU4rRUxoT3BmTmxpMlpCb2swaGlueFln?=
 =?utf-8?B?MldPMXdhMmRqNXF0TFFjdkJtMnl5ellFMmRoS2I1dkdibklzZDBJZGh0OXZq?=
 =?utf-8?B?QmUzb05FVHJaaTZPN2NDUk44Umh3UmJ5b1dXMU1pSWtlb2V2NEVjektyVXR6?=
 =?utf-8?B?c3RvK2UweExpZVA4bDR5QWt2bUhjbWZXcjFxNm9kTkJUQlFTRzh1Q1pwUm9k?=
 =?utf-8?B?ckpSWCtadW1GK0wzNW41WDdJazRqRTlVQi9vTGZNZGNubzZ5a2ZGbkhXakUy?=
 =?utf-8?B?Q2NiSENLbkVwTlcveG00V2pqakRqY3BoNndDRjRQMWlTUmNNK1FBcnZEcS85?=
 =?utf-8?B?Nk1nS3AwemtodFhuTTQ4Vnd6R2xzdUoxNHJlQ0dpZmVhMUxXdDRLbk05Y3dq?=
 =?utf-8?B?MXBiTWRXclhaQ2Y4cTMxZFY5b1dFNVJnUWM5bWR6dzhNK3ltN001Wkh2MTQ2?=
 =?utf-8?B?RW81MDFFWEkxeXBVSTJMUTZiSFdoeXNzbDlKQVVPeTN5OWZmZnFXZEE2THJH?=
 =?utf-8?B?YzZXbllHb3JYcG9vUjB5UTdWVWdJMitIcGt3REZQSmVsek9GNE4rN0FpNmta?=
 =?utf-8?B?UHBDZFJyMGRCWHZNdGlOTk5FeTU2YXhrUG9HSUxnaWZJSkthbW01bmkxcExw?=
 =?utf-8?B?RlA2akdqcFRKVElyTjRDMjlXeFNpKzV1eVV4ejJwYlQ3N0YxMytrS3RGNzVO?=
 =?utf-8?B?UmZRU2JxYVVCSTZaRHJwQjh4WDhxdllFS2dJY1ZLRHNDeUhFU2J5WExaK1Fu?=
 =?utf-8?B?c2JkMS9QZDN1VDVtMS96WlRycXJjS2x3WXFuekI4WkpPbEo3R2FZeHdjSDgw?=
 =?utf-8?B?VEZpSFBsdGs4ZjgzZCtlS2JvczVoa2p4NVFxR3d6djFCeTY2dmZHUjIvaVVO?=
 =?utf-8?B?RGNvQlV1bnRGZHFheVdmZmJNUGZqaVJKc0hBcFQ1OW5PQXV3byszczF1dGtW?=
 =?utf-8?B?MnAvdVRrWDUwSldvbU9STjlMTkx5WWk5RkJiOVZFVlBMNU9lTlM5UGFnS2pG?=
 =?utf-8?B?cnZuTFBlaHlCVVlya0VXRjhzZU82MTVmdm1JcWJ4R082cm8vR1VLNThDeE5H?=
 =?utf-8?B?QVRoeWJmeDV3cGo1Q1p3R01mbUZlQW5rMDJxMithZlUxRnlmUTBqV1l5eXg1?=
 =?utf-8?B?Y1dqRlZHK05PRkpvalliQjc0SXN2bHRhUzg2SGpPb0k5U2ZrSjk0dXdDZmps?=
 =?utf-8?B?dmhPMDByMzB4L1dIMWxkVG0vRFlhMmtRRWpubjI2alNnWnhwU0x5YkNod1l6?=
 =?utf-8?B?eGYyQVdhVkwrWHZHRi9MaXFHQWo3TDNNckx4T2J4Nm83SGJQZGVlNU56UDZS?=
 =?utf-8?B?dlFNaWRuTjl1TGVyQ0N1MFRtZjI3bE1idHdGWnA1WGJERStLNkV5YVNpY1FY?=
 =?utf-8?B?UkY2MUtIYmIvZUFqdGZRSXUyWlhPam52Z1JjZ2tXQS9POTdKM0JIWmxTb255?=
 =?utf-8?B?ek1Xa1FrQnB4OFYwNU5hY01ucUpUdXllZFByTytJZTdQK09ZS3dxL0V6OVNN?=
 =?utf-8?B?ajhiS0RUNVlMZlJxcVAvNjRHcVBtdUpJaW82UTU0RmNpdVNqb01rbnl0UlZ3?=
 =?utf-8?B?Z1dTUXEzclBIZEkxYzdrQW0xZUNJTmM1dmdOeTdMQTlFOGxsQkRacEVKY2I4?=
 =?utf-8?B?c3R1Q2EwRWNZTmpTVHlzdlAzSXdvRzNHeTNEVVFud0FMWmhnZ1lVaWxmOWx0?=
 =?utf-8?Q?pUQyJ6mwsilfG?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUMxeldJbDVIU2JYMGlmeFFlbnh0dVNFVk9wNjZwM3AxUnNyWWRhZWJTTnBJ?=
 =?utf-8?B?cEg0K3BSRHhFYUxLUHZWSk9ITGI4UkRYNUI5VU1EOVpIZEtveVhUanlReFBw?=
 =?utf-8?B?RUVSMEdjbUxwY2xWam1WY3l3TzV2bjU2eUIwazd3MG9mSjZqdUlvczFjeW9w?=
 =?utf-8?B?NUZoWVpOdW80cG5YMzdUY0xsNTB2MG4rRG1HM3ZIRkRPRFBZTXJCYkVnSFM1?=
 =?utf-8?B?eFNNa0twb1lWTFN1L3drMUZxZFpqdExuZW9pR1p0NWtOTURObGdJdldNUzFZ?=
 =?utf-8?B?WXRqMjNOc2dMaWRjL2NHQW5FaUlJVkM1ejFwQmF6RmxLOTNUaCtGVGExQUpM?=
 =?utf-8?B?VFlsWENRYnpsMmU1dDZ0L2w1L1RsbThaeStmZVM2U0RWbzJBNC9JeHpZWUxa?=
 =?utf-8?B?c2V0TzRDYWs3UFJzVUpORHdzcTJqV2JVbnB0Y1YzVTk4L2Z2SDg2bWszanNp?=
 =?utf-8?B?SndKL0J1cWNTdkRYN0JNZFZveUYvQmE4dEc4OThMcTNYWFM2Qm9JNDV3MFp6?=
 =?utf-8?B?dTEwbnBwbm5JS2YrYzBvZDErcFRNUmluSFRPVlFxMlhrNXVpZXlwZzVnb0Vv?=
 =?utf-8?B?SlNtQ3ZlNWVMcmR6all5ZVFiK3Juei9jYkZkVUpyYVFnd0pSNEFhMW1GYUpH?=
 =?utf-8?B?dXhHTXhNWklvRmNNemJKU2lrUFVueDByWCswWXQ4RTlLdUppSXJQRXViMndr?=
 =?utf-8?B?emw2dlFjNzZjczY1WFAvbGVUbitQL1kxS2VwY1lXR21qOVkyUHZQQkN4T0FZ?=
 =?utf-8?B?WGRvSTBud1BNREZNZTJNcHh1ZzFjaUtPZ2Nyd21JUStYVTNMbDUwSTRtR1Fm?=
 =?utf-8?B?NDVZY0YvK2dSbEIyZGh5dUFsRDhhOVJ2cjJ6Tk04ZzB5TURHek1LYXBRTjMx?=
 =?utf-8?B?SGNNZmVrVDUyYnZkMzExZTh1RU5yUEpiZDM0RG9wdUdBSW11a1IvL0k2eE5U?=
 =?utf-8?B?T0RaeVNsYXlQUTZaWTNhVzN4MU1QNll4NVFIRHBXYnhzZzJyVzZaNVVuRGRL?=
 =?utf-8?B?YURxaWV0WE5NOXBqK05jUVZ6ems2OVdJeFhNL2RJUFBCY2FBUDNVOU1qaW5N?=
 =?utf-8?B?T3ozT0JSdDlJQmY5b21LYWtyVGZ4WGtRenRrV0RCa0tBa0VsSXlUVWMzQXFr?=
 =?utf-8?B?US9aSnFhL2Qwc1BXVXZKMURFb0k5ZlF5WGVsbi9YREtpY0J3b3E5TFMzbXpa?=
 =?utf-8?B?RlljWkZKZnRTQVh3VmRyU3FSSW1FOXFtNWRjdm5xU1BGUS9CYzZBOHRkWmZK?=
 =?utf-8?B?ZnJQay8zZGt0VjZNUmVPTXNEaWgyQ3F2NlZqbE5oV0FDRlQ4Y2RuUnJRbVhD?=
 =?utf-8?B?TFlhNEladWlpQi8xS25lVE1vN0tITi92MGN1MUdFRm51ekN2ODZsMGJDQis1?=
 =?utf-8?B?Yk5XdHRVS3FmTGh5OXpYQmFTMGRnWXI2Nnc0bll5NG9iQnNjYjY2enBZNFBi?=
 =?utf-8?B?ZFd5b2RJd2xqdi85MUhETVl5Q0dkeGFpYjF3ckNZLzBuUFlOaFpQekFLVU5Y?=
 =?utf-8?B?RWwxUUFPalNJUVhsRVFDSm00NWhmRXR5c3Y2NzBPeHQ0elVzeXowdUdzb08w?=
 =?utf-8?B?eTVzR3lhb3hUT2prakY0Mkw0UDRNSUdWc2ozT1liak40VDVMNHh1K2ZFYXpI?=
 =?utf-8?B?dEdWNmo1SU42L0wwMlBSZnA4Q0srM2hIanlQblB2Y1d6MUpoMndyVDIwSjZR?=
 =?utf-8?B?RUtUdHUzWSt4ZmlOSVlRM0tFWVkrODNJRGVXT081anJCMHBWajl4bU1ia2wz?=
 =?utf-8?B?amdGSUlBd1lqdDNRRjdPZUhMZ3l1cnJwSEFQKzZBRi9GOXdSSVpqTFY2Nndq?=
 =?utf-8?B?S1NLZEtRc0ptcG4yK0RYeTJob2F3cHlWcVRZWVBWQU5CT2R1ZGY2OUhHekZl?=
 =?utf-8?B?SE84RTM2SnM2elJPdkRKZUxrcU1IVWswSm16TVJEeDN4QlVoZVZIbUdrL1gw?=
 =?utf-8?B?QlZHVitYd252dnhyZG5BUzNpRytTMUI5REZIWVhIejc5SE1Wd1lRa1dtU1Ro?=
 =?utf-8?B?aE9iU3hxTkF1Tmw4bDF6RVNjdmkxQmZvU1FUTWtGZmlsbXpMdHVFRVFnaFky?=
 =?utf-8?B?NUl6V1J5anRwM2Q0d0JTV1BVOU5yV0V6WTBhN2dGaHJod3JieEZMSU5ZdXhp?=
 =?utf-8?Q?dLsCo0rNGBU5n4Pj0gN4lN/8g?=
X-MS-Exchange-CrossTenant-Network-Message-Id: accdfd57-f47b-4d86-cc02-08dd36dcd060
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2025 09:53:37.4502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 643+ME40aZKKoPLS5YFm0rPF5IzxFPi4zeXHCKsAIbScyVPTES5A/CNlSndek0lYPslQxg/RVGkQQt13sBMy5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7903
X-OriginatorOrg: intel.com

On Thu, Jan 16, 2025 at 12:07:00PM +0100, Paolo Bonzini wrote:
> On Thu, Jan 16, 2025 at 1:53 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > For the first, hmm, a bad thing is that though
> > tdh_mem_sept_add()/tdh_mem_page_aug()/tdh_mem_sept_add() all need to handle
> > TDX_OPERAND_BUSY, the one for tdh_mem_page_aug() has already been squashed
> > into the MMU part 2.
> >
> > If you like, maybe I can extract the one for tdh_mem_page_aug() and merge it
> > with 1+5.
> 
> That works for me, but if it's easier for you to merge the fixups in
> the respective base patches that's okay too.
Then I'll merge them into the respective base patches to save effort and make
the latter cleaner :)

Thank you, Paolo!

