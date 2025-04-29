Return-Path: <kvm+bounces-44625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61AFFA9FE9A
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 02:52:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52400189EF77
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 00:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 387FB13C9B3;
	Tue, 29 Apr 2025 00:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jArnGSCL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C698837;
	Tue, 29 Apr 2025 00:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745887925; cv=fail; b=jjAoinynt3hdbDaSinhyXhsPo+t0QTP2yORnkNYPdA2WaH4YGNX9UnnQByl5lMiVDWAJNsLtPAGcdp1UkL7Vtu3YSrJPUHUpq/D3NfcGRwIENH6P+UmAAC0zhFevFP5r1Bof4KBN5dIM0EL3gDQcX+ST0MCG/LHhVnaxvMIgfo8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745887925; c=relaxed/simple;
	bh=x+wWWgG1PiuNNmj53BYlUtZMuGVBc8Y0EmtgumU9jn4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qrQRYY/wnkMk5wqm8vr2nohAOEn3LJpWrEa7hMxdricjx5AMST3afrjRgWLJnfWA7HQ4RTs+GFm2uE6gW9N6ki5V5Dh+U0EgrhgL+1yVL1607MzUhEW7TML9xTzSDNjfqnA/DVlsL5NXjWHcqsN5Gu/NMsTJifHclpHaFhEZE5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jArnGSCL; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745887923; x=1777423923;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=x+wWWgG1PiuNNmj53BYlUtZMuGVBc8Y0EmtgumU9jn4=;
  b=jArnGSCLsPLjWesIzLK/AKG3E9YuTaSGYe72mvsTIq+5WRIir1UjG3J+
   7nc/bTx9xcFCRHPWN5CZoOdzB73oftKI8EqoXp71wG/g2TKqP7Oh7epUG
   0bdxCJvyoYyncv3QI3zNj3jRJIn9/RmTZ3Jc0RKwi9ytdvtxUxVDZUq67
   sKKe8kujISF+qhUIyj/IqXudX/jvS8u02uUHl/eMG+cLVNbXvZSAZYKa8
   RSiiJIzAq4r2IKD/bzVhDpT/mi3XHoVPGrrRZDJUBt7SMEPUQbYPtVFrG
   9vaLccS495c2Pj6fpNkjUz4fQTjLOkfFS9SR2/z0Z3f7ZwRolVoqHRq6R
   g==;
X-CSE-ConnectionGUID: FjFzpNbWSV6tqhI+RDUkIQ==
X-CSE-MsgGUID: VG9t5bnzRI+9fxWf/QP7xw==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="47630947"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="47630947"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:52:02 -0700
X-CSE-ConnectionGUID: EtebI/oPRfWMDPyfG3Mbwg==
X-CSE-MsgGUID: bmnAV9MxQdKTltbj8+ZNXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="138762885"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:51:48 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 28 Apr 2025 17:51:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 28 Apr 2025 17:51:45 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 28 Apr 2025 17:51:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DVai0JMF9Qd7vW30RmxZeGROuBuOfWm5mKa18VN0KuqUvvfoj+Xz1/zOazUjL6sL5lSSo2XE/CXdHYpqg7sWrjIN8y3f/DQxRzKF6kUl4bLYzxxtXozmxpKWeKuDcNnFq3AxJMTtaot/mrLBjSXLvtFw2vggF9QU0hwodI9tH8Ys8cx+HX8tyYANDDXXWcoI8JDemq3kdGwGq2lywtfTh2plDX6iWf/dI/GuOloIjr35qllNZ/qN+rzV4ncIL+Jy19/2x7fqWNVDAIPzX+B6YXayqlHKMYdXFKO9BIAhXrfP+7mXIma0omLUYX+2XJdp0hedDSo4h02QiEvTftdn6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kOGoba2dVYKVNL9lq1vqydaQWPSz2QGx/TiL+d9seM=;
 b=e+AoRp3vNoiH8zSuEyrjy72ooyh/1Ddqe0m+z+8Ocwb4U8s5GDGmV9TgX0NQe2sTb+Fj+l1jyx6h+RoaC9eAAWxEdP7TTsCrGPlzATIbANK7oiVTFm96npEXkt6O2iXrU7O8zXZr7EnKZbcZHrDjfFzkGCYnJHRRkeoLslpVNn3S0xxjOjdWUZRez83re+ENl+rjEMMuXJJneJ523Ol+0EwF0F2vsmskksfuz8IR+AbXWSJZ9GCbuo11Jc5fuEgpd1tRxzJbUy1sct2X8lk7hqv2syxuy9WROBpQh8r6uPBX2tRfA2whBC12bjm/zYz36hA4lWyUcIxCuVaw4ZXe7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB7659.namprd11.prod.outlook.com (2603:10b6:510:28e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.29; Tue, 29 Apr
 2025 00:51:12 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 00:51:12 +0000
Date: Tue, 29 Apr 2025 08:49:12 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vbabka@suse.cz>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pgonda@google.com>, <zhiquan1.li@intel.com>, <fan.du@intel.com>,
	<jun.miao@intel.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aBAiCBmON0g0Qro1@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030603.329-1-yan.y.zhao@intel.com>
 <CAGtprH9_McMDepbuvWMLRvHooPdtE4RHog=Dgr_zFXT5s49nXA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9_McMDepbuvWMLRvHooPdtE4RHog=Dgr_zFXT5s49nXA@mail.gmail.com>
X-ClientProxiedBy: SI2PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:194::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB7659:EE_
X-MS-Office365-Filtering-Correlation-Id: a2904e58-a65c-4d57-9691-08dd86b7efce
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VG5lMUswRU1NL21HU3ZkUy9ha2lBVUxLVGdsUEV1dE05c29MMWRUSUFuOWVh?=
 =?utf-8?B?bGsreGIvYmFvbUN6NmQ1MVIzN0w5YjJTc04vN0ZrazZvZ0FpWTRYTmJVYzNY?=
 =?utf-8?B?SThoUFNrTjU0cHJhbCt3OWhjL2hYTlVabWo0NjNPQUN1MFVwajM2cC9UREJR?=
 =?utf-8?B?Y0pNOWNEQWhMT3BTR0VVM0RyemJMbzZXWjgrV0hHRTl2NWpidy9HdjhISW9w?=
 =?utf-8?B?MGlYUHZuemtMdUVtK0FTcHhpRmdqNk03d3hpdHNsMXJDS2dqZ0wvR0cvYXc0?=
 =?utf-8?B?ci94enZoakFsM1A3aU5WL2dRZ29Ra2FQdUNRSXdFRTVRUDAvZDViV3pucXRm?=
 =?utf-8?B?dzJhaWQ3V1BzUVpHdzhLSW9aNHJVdCtUcjYrWnZ5TUQxU2tNaCtpNzV2Q3Y5?=
 =?utf-8?B?OFVuSTYycjd2ek1PMVoweXdGTWJJKzRqZTBWRHZHanZHRENLckhkT28vUS9H?=
 =?utf-8?B?T1IyZE9BS20vUlBXR2E5SEZ4dGxXRkErQVdQdzFtT1RYUk5uR3lnMlRJV3Z0?=
 =?utf-8?B?K0I5U2MxeGNzVUhuWjM0QjMzdXpBVFdDS3ZFQVBMRlZDVWtTWGpZaW00VXZC?=
 =?utf-8?B?VDZad292amFrcmNCQTdCMEFLSlFsS0UzTlk2RFpqSjUzS2lPRzI5V2VyV1NX?=
 =?utf-8?B?Und2aGYzVzYwTDFZOU10QWtVNmNWeXpLdVg2UDV1WDUvQ0srN2lxdWxNRG4v?=
 =?utf-8?B?ZjRNSlFQS21ZS0N0SHkyQ3hGUWc1Y2FLM1ArNkNzTHU2M3llT2w5bFVRQnNy?=
 =?utf-8?B?MUVlUGx0cnB0UUx6Z0lNaHRDQXNZK0ZTVDdwV3lMVS9FM3FzVkJiVy9kcmhr?=
 =?utf-8?B?ZU93VTJoT3FhMlZMbWlUb2VOaHd4Y2JCL3FXVy9sdncvSDd2ejRsc2p3MmUx?=
 =?utf-8?B?Y25ieWtuUG9lcUQ4ZkxQSXZjckVLa2picW0rVjNOSmFKL1VqNndJRWl3Qmhh?=
 =?utf-8?B?dE1XcmYxYSsvb2FRRXV3NS9GUnpySVlTUFptdFJ2QlI2ZEpKS1U5NXZicEoy?=
 =?utf-8?B?Q2VTY2k3c3JHWTZmNUw2TCttS3B6WTNpV2RlODNPd3dteWNoYXFTVng0aThL?=
 =?utf-8?B?dTlYTlJSQmpXTUdPSkk3YnN3ODV1SlIyWmJNRnc0dEI4cFNwbDFqMTVCRG5F?=
 =?utf-8?B?eW5hWER2c1pxenhYa2duQWVJanRUWEREZ1RWaVhSK2ZWMFZPdjFVc25adXNX?=
 =?utf-8?B?ZDhtcHZRSHpucm5oMUttZjYyZWt4UlM4b0Z5WncycDE5VnJLU0lXRFJEZmg0?=
 =?utf-8?B?WmZOeFlvNTUrK29wTDM5Uy82YjUzVUdVUWh1NENSaEx1VFduRExGR1diYjdU?=
 =?utf-8?B?eTduckZVZkVxcHFJOHhPL2NoR1BrSWtzZERxaXJYVWRCYmlrREV1bFFyWmZm?=
 =?utf-8?B?Wm54aURKNjd4cXY1ejM1Z2h6ZThVVjZZVDNRcXZaWDRERWhPdkoxZGVBbHI3?=
 =?utf-8?B?WnhodzkrT0Z6ZmlHRDMxSHZyMVBGYUIxdHpGSzRoNnNHdWhqY3dTNkFMcE5h?=
 =?utf-8?B?d20zbnJLTVdkYVpxcWRiTlMzSnN3Qlk2ekt5bXFUeWpuckdhUzZ0MGVIY3ZO?=
 =?utf-8?B?c1pjL2hhRGx2cWFGL0gyYkZXZy8vYWgyS3ZrQndEUUhrbTY0VmlVdHhqdlUr?=
 =?utf-8?B?YytxSjM2d1FtOURWNmNxZEdKcGhYSi9aRm50UjZFQjJReG1QMEFzbkw5bFh6?=
 =?utf-8?B?bXJ1SDRqMThwOVNYUjB0NHFnZWsxRElUU2FYRy9qaWhMMHlkblI4ZE9GUjRQ?=
 =?utf-8?B?OHBhYXFUMTQ2aVZCOHYrcWZGY0xpNUw4Mnkwdk9qU1hvU0VaL3ZJTzNCKzFH?=
 =?utf-8?B?cW9pdlczTXoyNk5ocjVZc3dtMzkvVm0zVWU1TXpzQ0Fkb0IwWHlDbDgzU0dx?=
 =?utf-8?B?OXY4VWpVT1BubTFDejFRSmxlM0tUeTZFSVQ5d0JsWTB0WmxyZ2EzT29LK011?=
 =?utf-8?Q?MAZxKrNUkv0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vkg1cUtIaWtINW52OSt5eDZucit2bWMyQ0c3T1hQaHhMMzd4NjZ1aUJXMUpN?=
 =?utf-8?B?UkhoT0lENGFwb2VNOGZyTTdZMHIweitkcDl2cURLWHg1dFp2Y3lNR3dhem5Q?=
 =?utf-8?B?Ui9BTzlEMHVHL0RkUEhBYXB6MzhoWnUrZXZnT3dNczk2K0NYcGRyNWJIL1hK?=
 =?utf-8?B?S0Q4ZEljS2E3NjNwZ2U2MjIrWDhpRWxVMEJOTkVGMnEyVC8yK2JySFlvVi95?=
 =?utf-8?B?OVNSTmhGaHBUV1lzUjFDU254TDE3ZlRrYlZpdjlVb2VBS25oOGhMYVViNTVj?=
 =?utf-8?B?N2s2OHNmOTJPM0Z1WFdCOUcxQ0kwY0pGMzlyREtpWFlyaytWRVhCcFdaTkxQ?=
 =?utf-8?B?R0psMFE4NkFpa01iR3k3K2xWQlUrQzRtVFZDdEM2bm45MzloVW1qTmJQckg1?=
 =?utf-8?B?RHJ6WHZLZXFQT1ZFWTk2SG92SktOYTlROWE5SHAzNTBUbTRSQUhNOEViNXFG?=
 =?utf-8?B?bENzYmp5NGFIZnJrb0U4dHpuNWJnQU9kdnZaanpRV1E5RzdnUlNWcFFxM2Ns?=
 =?utf-8?B?ZnZRdk9kT045d0twQVFWU2tlSGwwRTF0RTNndllxVTM0aDRPOGZMYXcrY21N?=
 =?utf-8?B?aFRpaUt3K2NLUjdoQlJTK1lBcWpvMTBKTkhPbmFMb0FrLy8vV2hmT1EwSEdk?=
 =?utf-8?B?cnJJbkxyRDA2NWI0ZlUzbEx0a0ZmT2drSXZReGdKT2R4UVlMYzE0TnQwWFZ2?=
 =?utf-8?B?clhTSDQ4THMzMk5uKzJwZjlGVHh2MUxpZUtoV1VsWHlPVm1xeHVwZGJrcjhy?=
 =?utf-8?B?M2ZSMFNQU0k4d3NxZEwwWm85ZWdZR3RLK1NJcDRab0R0MUUxYkNRUTJRZUJN?=
 =?utf-8?B?NDNzdXJIS1FGTWY2TzBRWEh2YjMzNG9tWWxXOE1iNEwwZ0haTmx6YkRvK2xm?=
 =?utf-8?B?MXRrKzZIcElQanZ4aDNtMjRyaUlBUTNjQ3dWRHVOTm9Yb0hqa1pDTWVORDZt?=
 =?utf-8?B?clBzSVp1aWhBaDRNb0crRERJWkIrdlB2MWhmdU5EdlFDTTEvK05ZSjIxdWxH?=
 =?utf-8?B?TnBCbTd0alRBNkV6TXhNc3N3NkRmOEZDQ2JYcDBhZ1YrRk51WTlhdEpjcE9M?=
 =?utf-8?B?M1Vqd1BMcmVXaEhhQ29lY2p1d0xVaWFEbDNZUWlyc2ZYNHVDWC9aTmM0ME5o?=
 =?utf-8?B?UkpsKzlyd0pwYUM0S1FPaDc2bWJvKy91R2xodURpelk1QWFrblhoVHF5cDZU?=
 =?utf-8?B?MUgrS21yVyt3aFpQdTdmWHhuMXJVYnRWck9FUVAvQ3JZRU0zMVFQSTEzQkgv?=
 =?utf-8?B?ZFBrWGhPdVV3ZUdTWDRTQkpBR0hKaWVMekxlRytOZ2dMZ29heTNWRXd6ZzZD?=
 =?utf-8?B?ZjlCbnQxYXJSU2owM1Q2aDhDZDBVcTNLWVJkWnptR2N4NGRVcitjSzRSWlJI?=
 =?utf-8?B?Ym03am9TTEoyYjVDL3Y4OFZydlZqZEt4Nmg1UWM1OTdESTBKTCtHaG15R3JP?=
 =?utf-8?B?VHAxOU43bGZpejduWHhmRzRQYWhCLy9pcnFiMnpDZ3V4L3lSMG4vYVdOZnpL?=
 =?utf-8?B?NWcyTDVhbWR2Z2Z6TlhBSkZrZGNTNVVzcENxcTdxeVViTU5SKzJtT0l6QSt1?=
 =?utf-8?B?b0xYYWRDQ25MSXJwYStRSllEdkswUCtraVhpSXZDY1BYRGhuLzRRL3VVQVds?=
 =?utf-8?B?Zkc0cjB3QVlZWXlWcDN5NzAwOFBRTDNHcEhrZk9rVEVBTyszQ1hXOFhuMEM0?=
 =?utf-8?B?Z1hBUjdqaENsMXdHVnh1WGZnWWoxdTh2eFZlbUZNSytST0JPZWxBcG1xS1pZ?=
 =?utf-8?B?NEtJUmU5cVkxYzRPZCtBaktoRCtiWEsrVXlGRkhqMFJsUDY5VGg1RzRnb1ZI?=
 =?utf-8?B?TWhJeFdmRFJ4bXViY09XTlpsRVRJTG1lWmljM3VTQkJoUEtsOGo4Z1FjenVs?=
 =?utf-8?B?cXQrcTFodWNGeTArb0RTNTd5aVR6cmxrUmdYSmszMDV1SFZvaXBWQVZ4ZVZD?=
 =?utf-8?B?K3gySmVQdXdnT0RWQ2lUMUNTNFpQanpUSVJsV1B5RmhTSWNBMjVCMk0rNE1D?=
 =?utf-8?B?Ty8wd2x5UlF1QkN3V3JOM2VvWXZjTGtyWklGNkZQYjJPc0JyWTZZVzd1Y1B0?=
 =?utf-8?B?WjNoZDFicUt4eitNVEVycWo0SG1CcFNKQkwxSEw5UGp1UzRVWE1Eb1VCMUhK?=
 =?utf-8?Q?C5XuBjCJFaieWGDiSJwSgKoc8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a2904e58-a65c-4d57-9691-08dd86b7efce
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 00:51:11.8792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QWAjQVOb0DXMdvsTIDEE/KdaYw67Q64v8M2ZilvpyAJRPE2o9diYjr0T5txB32Lu9zADtomKh6fwkJ/D/7JAQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7659
X-OriginatorOrg: intel.com

On Mon, Apr 28, 2025 at 05:17:16PM -0700, Vishal Annapurve wrote:
> On Wed, Apr 23, 2025 at 8:07 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > Increase folio ref count before mapping a private page, and decrease
> > folio ref count after a mapping failure or successfully removing a private
> > page.
> >
> > The folio ref count to inc/dec corresponds to the mapping/unmapping level,
> > ensuring the folio ref count remains balanced after entry splitting or
> > merging.
> >
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/kvm/vmx/tdx.c | 19 ++++++++++---------
> >  1 file changed, 10 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 355b21fc169f..e23dce59fc72 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1501,9 +1501,9 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
> >         td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
> >  }
> >
> > -static void tdx_unpin(struct kvm *kvm, struct page *page)
> > +static void tdx_unpin(struct kvm *kvm, struct page *page, int level)
> >  {
> > -       put_page(page);
> > +       folio_put_refs(page_folio(page), KVM_PAGES_PER_HPAGE(level));
> >  }
> >
> >  static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> > @@ -1517,13 +1517,13 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> >
> >         err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, page, &entry, &level_state);
> >         if (unlikely(tdx_operand_busy(err))) {
> > -               tdx_unpin(kvm, page);
> > +               tdx_unpin(kvm, page, level);
> >                 return -EBUSY;
> >         }
> >
> >         if (KVM_BUG_ON(err, kvm)) {
> >                 pr_tdx_error_2(TDH_MEM_PAGE_AUG, err, entry, level_state);
> > -               tdx_unpin(kvm, page);
> > +               tdx_unpin(kvm, page, level);
> >                 return -EIO;
> >         }
> >
> > @@ -1570,10 +1570,11 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> >          * a_ops->migrate_folio (yet), no callback is triggered for KVM on page
> >          * migration.  Until guest_memfd supports page migration, prevent page
> >          * migration.
> > -        * TODO: Once guest_memfd introduces callback on page migration,
> > -        * implement it and remove get_page/put_page().
> > +        * TODO: To support in-place-conversion in gmem in futre, remove
> > +        * folio_ref_add()/folio_put_refs().
> 
> With necessary infrastructure in guest_memfd [1] to prevent page
> migration, is it necessary to acquire extra folio refcounts? If not,
> why not just cleanup this logic now?
Though the old comment says acquiring the lock is for page migration, the other
reason is to prevent the folio from being returned to the OS until it has been
successfully removed from TDX.

If there's an error during the removal or reclaiming of a folio from TDX, such
as a failure in tdh_mem_page_remove()/tdh_phymem_page_wbinvd_hkid() or
tdh_phymem_page_reclaim(), it is important to hold the page refcount within TDX.

So, we plan to remove folio_ref_add()/folio_put_refs() in future, only invoking
folio_ref_add() in the event of a removal failure.

> [1] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/tree/virt/kvm/guest_memfd.c?h=kvm-coco-queue#n441
> 
> > Only increase the folio ref count
> > +        * when there're errors during removing private pages.
> >          */
> > -       get_page(page);
> > +       folio_ref_add(page_folio(page), KVM_PAGES_PER_HPAGE(level));
> >
> >         /*
> >          * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
> > @@ -1647,7 +1648,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> >                 return -EIO;
> >
> >         tdx_clear_page(page, level);
> > -       tdx_unpin(kvm, page);
> > +       tdx_unpin(kvm, page, level);
> >         return 0;
> >  }
> >
> > @@ -1727,7 +1728,7 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
> >         if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
> >             !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
> >                 atomic64_dec(&kvm_tdx->nr_premapped);
> > -               tdx_unpin(kvm, page);
> > +               tdx_unpin(kvm, page, level);
> >                 return 0;
> >         }
> >
> > --
> > 2.43.2
> >

