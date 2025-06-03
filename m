Return-Path: <kvm+bounces-48241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6533ACBE30
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 03:34:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12BD5188E852
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 01:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B4D046447;
	Tue,  3 Jun 2025 01:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R+6bwIN6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFED13FD86;
	Tue,  3 Jun 2025 01:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748914459; cv=fail; b=ThRn9r17KKbbAUmR7u8HFSgjqoI1TtZrThE44U+RMEMnr4bTgHgQjVySWxLvExFeTArM33JzspyJ0r1lb2pmbYxHZ2yWomqqZwWamz9SFfRIF2zqeie3aku+OeJeAIwXayHbS8A/Q6gH80iHHpRWFmRy1n7SQzgLsw8YjoXGtkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748914459; c=relaxed/simple;
	bh=KAktbjNerjcD5Nf+DD4PD+Qg0s6UJH8VA03Rmjepz8k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cXMHriLr0zlSWZGBXCDjR0H2vbyVyhkiI9EgkS5BqzX5AnL/6Edr831Qtj4EQspaLhQichiGcLn73Z5VtVxRDY7B2pi5DihVA5QCFiidGhDf73TRuHGprqBuI0Xky3lFfc1y15peM5s5reiQhhuccQDlj95eaDW2mhEAqNrhTRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R+6bwIN6; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748914458; x=1780450458;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=KAktbjNerjcD5Nf+DD4PD+Qg0s6UJH8VA03Rmjepz8k=;
  b=R+6bwIN6yMX+x6mJHrM1RPJgcod1FEwEnj8nxE0PqRgyj0ooeeNME2Dj
   l2cFfDJ450LkLZKxX8HuL4eMRzrFbFAx67f8kvO29NsGV57IgkgK9zR1a
   NFl3H9mVCuUiek6611lrt8uBhwepRQKbZfEUrh8ZP+kPjxggH3/ApxZGe
   Wk/esF9rbL+1j6VK5/WYORCM412NagKi1hkD21i9IunqYZvUcWp6XUI2c
   VRdktphyW3JOf+rXJMLyu/ZHYxQQdW+ne0JdsEvKn5Uw6ZoIbQonxDoFH
   s6kYl91z4fFpC/bYDevZlbc4RaiWGWlKI6y1dhknDEdyYBwd9aRFc8wZS
   A==;
X-CSE-ConnectionGUID: JWWwtpvqQRmUhlzndpAnFQ==
X-CSE-MsgGUID: NmPFxipTTPe+pGESaqS2Xw==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="50180551"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="50180551"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 18:34:17 -0700
X-CSE-ConnectionGUID: xx6QsN5MTjKH4zmdieLdIA==
X-CSE-MsgGUID: AwBnsjBbRMia1bbMZf1L0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="145643250"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 18:34:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 2 Jun 2025 18:34:04 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 2 Jun 2025 18:34:04 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.82)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 2 Jun 2025 18:33:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uqagZRnMU94ncNpoheAvdXTv4NtQoqvg+c65RCzoOrzWegDfNTmU+JtQusicwn9YQkni6tCwVS2Zz2fP5iIBGyCbN5M2qgtirBXD9TlazLSoa29DFx/y+fdd9Pz9U+ablUFWjQEh6cet/4Wi68/V9lOjRDB3PRx811KOGVfgkxGuVtcZUjDcObqx4a1Tz8zKN95XT0zxv2yh9tOccsO6XtqpNBzb36PoY1K3mZfr5JTfcpTfIhVjhQJ6NTszvHdEEzGZUxhJq53TGGgjP+OXUZI4uMiXxS4WLDcDY+VgqKk2FFFXuWnrn/nODt2bxPuCRObpqqWWEpBeg3nArz9Awg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TWrw0eGhFNHI5K3W3NRiCPaydesVz5Jblfyzd2+4zPs=;
 b=tbUWBIPUIDiCVetxe1vvwxp1upR1M2HU/8BkM/zWmkx+BFCZYvZnKi+GruQIydAAEfaccYu8F08yDagUQES5VgwJqMYlAOCgwh27D+cbREfQ5IHndQ2YeVZj5Us97dTQrZpG6dpzEvBU2dGCv+v+tUBbzP11GEXu+irCYAJTkLO5Fca/VTK9l4Sle17vz0YOnlKNChvwDg5QV+SnePmmQCAwTQQT8W+Z5OW2rBM1BNk20pF+48mlVC1v56gegJQQZxj1DEagSE9lkp28dibefXX+P/tClOtBN0pK781d2eTxWptO7TloqwbtPDcV8mU2mLRYh1GLH21VpWZaOPys8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA3PR11MB8920.namprd11.prod.outlook.com (2603:10b6:208:578::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.33; Tue, 3 Jun
 2025 01:33:20 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8769.037; Tue, 3 Jun 2025
 01:33:20 +0000
Date: Tue, 3 Jun 2025 09:31:01 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, <michael.roth@amd.com>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<amit.shah@amd.com>, <pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <quic_eberman@quicinc.com>
Subject: Re: [PATCH 3/5] KVM: gmem: Hold filemap invalidate lock while
 allocating/preparing folios
Message-ID: <aD5QVdH0pJeAn3+r@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <diqzjz7azkmf.fsf@ackerleytng-ctop.c.googlers.com>
 <diqz8qmsfs5u.fsf@ackerleytng-ctop.c.googlers.com>
 <aC1221wU6Mby3Lo3@yzhao56-desk.sh.intel.com>
 <CAGtprH_chB5_D3ba=yqgg-ZGGE2ONpoMdB=4_O4S6k7jXcoHHw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH_chB5_D3ba=yqgg-ZGGE2ONpoMdB=4_O4S6k7jXcoHHw@mail.gmail.com>
X-ClientProxiedBy: SG3P274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::31)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA3PR11MB8920:EE_
X-MS-Office365-Filtering-Correlation-Id: ff606536-6c55-44ca-165b-08dda23e9f38
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N0RSK2RHekRTUENZSDFzYkFZZEhnTkpkUndkZWJUWU5SSDN4L2dBWTZWNWQ3?=
 =?utf-8?B?VnNOcmRzRG1KVWxVU29Hc2JFazdwRHZTNjNWYU5mdUpPUmlCZkNGamtvbDNo?=
 =?utf-8?B?Mk9zYjJ6SVdHbVYvbVRxUHpDMGlITGtjUk1xUGdxM0h2V2k3Y2NFdzM5UDc0?=
 =?utf-8?B?dDlseHRKR2VDOGdUaDdnYjNKYWVRWTI0TkxTamVjV2txamZGZGFacnYzcEcv?=
 =?utf-8?B?aVllMnNMWFlJUnV1NDlQektKYmhiSzlsVmJZOVlleUFCL3h4cXVCL1JuMThO?=
 =?utf-8?B?MjBvdEdhRmp4NkpodkxXWEJacjdWdkhrOGttRDZrOUNkZlowVUVzVGIxc0VU?=
 =?utf-8?B?Qi9NS2s5SnFZakFSakZiczJ2T3ZlQVpZdFp5K09heXlPUjI2aml0N0ZIT2ZE?=
 =?utf-8?B?cUZHQ3RjYXN5eTVLUjdMNmNlU3N3U3k3VUs5RUVuRkhzUUtSQldwWDdBZjRH?=
 =?utf-8?B?ZHhNUk80NlNpeStvaUdoWERxM0d5ZFZOVnkrWDVIdytRNDNQek93YWxKR2d0?=
 =?utf-8?B?NnpnRHhib2llclE5QUZ4aVY1eGZFT2diZlBGcU5jdXFGeTJIRjlzQitrYVNQ?=
 =?utf-8?B?Vk9VS2xFdFBUVGVsZUlkZXRLZzZVNGh2R2NPOTlwc2hVZ1JrSVlzb0grTmc4?=
 =?utf-8?B?Yy9rb0FYYmlrM1JMYTZma3BFSEJyKzY1Ym8zSk1tcmFCZCtCVkcvT001eXR0?=
 =?utf-8?B?UVU5VmpQNHhiOU9zZDFpRWdzTm43ZjFkT3VHSHU1dXFGTkdBbzRFTkR4YU02?=
 =?utf-8?B?ZUNHcklsY2FDanI4bWRvamFiMEZsd1NBaFJzZnZCaHhzdGd6MWE1U3BWWmdu?=
 =?utf-8?B?aW0xZTc0RnF1Y0xNVk1TMWpEczBqV0thSEJvRDRiMTY0aWYza2QwbitCVzVJ?=
 =?utf-8?B?RXIxRHhjNEZCbkFGcFJwYVgzejc1WUdMaXFFZWZYUG9iS3grcEp4ZVZJODZU?=
 =?utf-8?B?RlZQemFRU2h3bDdZTGlaMGNXS29IZ0syYWdNQmloK0dlY29OL0ZBN0g2czhI?=
 =?utf-8?B?V3doWnY4QWQwem5Sd25EQnFVNW5NOGtBa1B2VzAyMG8xRXJnR1VMcVZaRWlK?=
 =?utf-8?B?WnRJR3FrQklsWXBaaTNnRE9VUHcvTzNoL0JyOHJ5OXF0YTUzQzF4R1V1Z0pU?=
 =?utf-8?B?VVZxQUttdkF1Zm4zUU1YZjBldWdCY3VkQ3YzcGJGWDl5V1V5SDM5d2JYVEIr?=
 =?utf-8?B?clZ0TjZ2eUZBelVheThvRnJwS090RkxvOE1rOVdRSUxWaFEvVXhqQ1ZCUU91?=
 =?utf-8?B?NmpZTlVlV3MxYXlaQ1N2SUE3QUN6dnQ5KzFJeGg2YnNjN2pua0FjQ0RiaVJK?=
 =?utf-8?B?cEVqQ0ZUUnBBU3p5cDVBQnp4VDZ4VDhLTWlVZVpMY0xoTURSNVBJZFZGc2VJ?=
 =?utf-8?B?YjBXa1dCc1FUcEozZmJmY05QZnYzaU5sL3dXSkw4NW1jYWhQelJVNGNHRDk0?=
 =?utf-8?B?VVhLTXZXaXlmbGxMYnNVczRNVEJRV3pqVGNQdkVBa0owdk14UmlxMlNva2Yr?=
 =?utf-8?B?RzBDYlFPTURndFovSDNQeEsyYnp4Z0o3cUhONEhhTlhLUWZwd2l2b3lrcjVa?=
 =?utf-8?B?Sm43aW1PcXZZejBvWlI4cDNLVDF5L2dVTWRsZmhIR1ZjcDJkdzJRS2dyU0cr?=
 =?utf-8?B?RHJNbkFsMS92bnBwVzZnQWNCODMvVzhIcjMzN2ZaWGw3NEs0YmNxL0s1Q3RI?=
 =?utf-8?B?aWNPZ0tRSFRKOTFIeUN1czZQMk9yQU45R2R5Q3cyQmlHV1VMZnIvVjhXVW9h?=
 =?utf-8?B?UEI5M0dUeSt0Q0svQml6NkVHdVZ2TnE1YmVCc1BpcDZwRlhDVU9EVmQ5eWZw?=
 =?utf-8?B?c05YQUl4Z3ZPenVVWThQVi9rcnRLT3NGZUV4ZGoxL29HQTVRaFVBZnZyQWNp?=
 =?utf-8?Q?M4hPa/oxf0Mvb?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dy95eXc5b3NoZlJqdHM2TVZBOG5HMDNyTHVaLzYwaEFTNW1nM3RISWlHbksv?=
 =?utf-8?B?VWxLSXpjUnRycEFCTzdudElYRlRPUGpkQWQvSk5qc2xXQm4wMkc2YTNsR0dD?=
 =?utf-8?B?T2pMZVRQZE1VbFVUMlg4cWlKQ05ydVZ4YU15U1VMTndsWjlhbHhhR1A2Y1lx?=
 =?utf-8?B?c1B3ZlZCWkhYeWhOTVdPem01ZVdMS0JZaCtsK05HRWdTSkU0VW15djQ5TTJj?=
 =?utf-8?B?Wis1V1RqS3NFcWQ5VlFGTERpOFliRUk3d2VHVG5JcXlmbm5jYktqT0xUbXNT?=
 =?utf-8?B?Rk0vaGc4czc5bVByMFovOEdtNnVVQVVMOVR4RTByMmNpa0E0bENJZHJ4OEVP?=
 =?utf-8?B?WkxQNU94aHdPOXpQRUJ2N0VMc2NwK3Ayc1RkRHZDTVR1NmlZalZDNlFEM0xL?=
 =?utf-8?B?cFJLdnkzK2xUN05QQXFKMkFYczhwL3VhMFJjRElwVm1FUnJlSy9kb0tjSUpZ?=
 =?utf-8?B?enRVbTdQbTEwempTMUFYNWVSY3I2YXlpaVZ2bUhzMHJkbTVpcW9MOUw2cDl4?=
 =?utf-8?B?akVqUDRrdE5FaENHNzZKd29PRjZ4YXRlZXJYQzNkbmltYWlUNXl6bzJHRTJr?=
 =?utf-8?B?bGhqanFwWnBBY0h2VldLMnV1OVBKSUtYZnRsMFZaU1BPZzluR3p3TVN1cFo3?=
 =?utf-8?B?Yk9GeldNc3pnOG84K0NIbDJKTGdvMGdRSjdVRW8wK1dISVFnRG5YaWpiNHE2?=
 =?utf-8?B?S2RwcW1KUFpsbmlsNmMzUWsyTi9odjhlZlgxemVzL0JLS09OSHB6LzEyelc1?=
 =?utf-8?B?b3o1TDQvQ2VCTmJyYUF2c0V6dnNpOXovU0ZIUUVwL2VOdUxWaHVLK1JIUDNO?=
 =?utf-8?B?dFdsMTdIV1lMSjdOMGlqRUdwWSsrVEV3REs3TlhBc3dDUzA5ZTQ3SlFIeGFG?=
 =?utf-8?B?dmtPbnI3UzhsZTVYelJVd1NrUkUvT1RrblM0ajIveTlOanJwVXdCcDlzNFE0?=
 =?utf-8?B?bEE5WFpBQWREY2JLMHlGWEx5MEVOT1ZPQUtTbXlpY1V4Wk1SMElhRmdaU0FS?=
 =?utf-8?B?cDR6aFYwSFd4QjJnWHpBbDIzZm1ETnN6VWNzZ3d6OTBsSy85ZE1wRjZmaUZT?=
 =?utf-8?B?SHFVNXg2eHIyWjdrY3MzM0RYTGVPRnlSZnZ5a0JQT3NQUFVwK2JjNkUzV2VZ?=
 =?utf-8?B?UEVxSDlDQ3pseUIrdzVLTEp6blIxbW0zdXhUUUI0ZFVCRTFFOUk4VmdHdDVB?=
 =?utf-8?B?ZEFmQXMzQXloSXhIRWpnQStwL1pqbk9sMG1hUFhzcnI1WVVnYzFQQWxyOGxP?=
 =?utf-8?B?eGZucjRoVEN3UnNJcVRjY0FDSlNvWUFXQmlwa0x5UlFWQ25ZWjBMYzE4STZY?=
 =?utf-8?B?RzBJRHVkUlB4b1lrMDR5MHc3OGZRRWdSTG5RRFZQNzVRaDUyT21ZQXU5Z01i?=
 =?utf-8?B?dVZVa1FnM1NEQ2R6WHd0ZTVzeE5BRzM2KzhzMzFlUlFRR1NmdWtUaFdNRnJq?=
 =?utf-8?B?cUt2WUtLbWVEaG1sKy8yMXpKcGRtc1BLQzZuRURVRnVwNnY4ZENjdTBwT096?=
 =?utf-8?B?MVQ5M0k2ZGtHcGZEZHBndUZrSERteFVadnQ4RFNsc1Nmb2YxZW4xR2R5a2U5?=
 =?utf-8?B?YnFXT3JIeS9wNFRqaW8yVGNuRDBMRWczb3Fvd0R2TUV6YnBtNmxtN21nMkEy?=
 =?utf-8?B?c3d4Qjg2Z2QyZ2I4OHJyclJvd282S3ZlUG1uMmJUdk5nSzVPMFpUYzZSK0NI?=
 =?utf-8?B?Si9WRGNHd1NCVkRHRSthTDRDTTNBQURGQ1pFYTVGcWZ1MTlidFREOVlmYjVQ?=
 =?utf-8?B?SjVKTG5Ybm5CZ3ZQekUvZXJKK2JUOFFvYU9DeUtON0hzR09yc3QwWmxuNHJX?=
 =?utf-8?B?Vm1xMFFNZ0JTUWpZY3VMSWdLRVRZRTcyOHU5SmZTR0d0dFdvbEc5cXJ1RE16?=
 =?utf-8?B?OUZWbjBaT21ML3Q5aklIMlpQdWEwZ0Z2ZitSZCtOZUdwcHlxTUdpaHlmcXlz?=
 =?utf-8?B?dFVlQ2dsaTkxL1BpNFdkQUJMZ0tYWkw4eU4rVWEzK3I3N2xDcGVabjVISTBj?=
 =?utf-8?B?RGlISGI3Si9rNko2Q2pLYlJOdnd3UC9BSUF6MDBVZUx1RXp6Tk5uZGdtdFdW?=
 =?utf-8?B?R0VtOUN5a0FQU2dCZHhlTDVxUkk2WUFqb0JFOGQ2OGcvb01kc2l3ekJwS0Zw?=
 =?utf-8?Q?PBCbjNJR52BAMT9tn+XXodXeL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ff606536-6c55-44ca-165b-08dda23e9f38
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 01:33:20.0794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d7L5Gf6Ct22rgL4StS85E2D32AD7WjT3uqN78Op6g4pbOKKMOI9h2rmfnbXoWt91XsKpNLxEtz7lIOdYLPMq+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8920
X-OriginatorOrg: intel.com

On Mon, Jun 02, 2025 at 06:05:32PM -0700, Vishal Annapurve wrote:
> On Tue, May 20, 2025 at 11:49 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Mon, May 19, 2025 at 10:04:45AM -0700, Ackerley Tng wrote:
> > > Ackerley Tng <ackerleytng@google.com> writes:
> > >
> > > > Yan Zhao <yan.y.zhao@intel.com> writes:
> > > >
> > > >> On Fri, Mar 14, 2025 at 05:20:21PM +0800, Yan Zhao wrote:
> > > >>> This patch would cause host deadlock when booting up a TDX VM even if huge page
> > > >>> is turned off. I currently reverted this patch. No further debug yet.
> > > >> This is because kvm_gmem_populate() takes filemap invalidation lock, and for
> > > >> TDX, kvm_gmem_populate() further invokes kvm_gmem_get_pfn(), causing deadlock.
> > > >>
> > > >> kvm_gmem_populate
> > > >>   filemap_invalidate_lock
> > > >>   post_populate
> > > >>     tdx_gmem_post_populate
> > > >>       kvm_tdp_map_page
> > > >>        kvm_mmu_do_page_fault
> > > >>          kvm_tdp_page_fault
> > > >>       kvm_tdp_mmu_page_fault
> > > >>         kvm_mmu_faultin_pfn
> > > >>           __kvm_mmu_faultin_pfn
> > > >>             kvm_mmu_faultin_pfn_private
> > > >>               kvm_gmem_get_pfn
> > > >>                 filemap_invalidate_lock_shared
> > > >>
> > > >> Though, kvm_gmem_populate() is able to take shared filemap invalidation lock,
> > > >> (then no deadlock), lockdep would still warn "Possible unsafe locking scenario:
> > > >> ...DEADLOCK" due to the recursive shared lock, since commit e918188611f0
> > > >> ("locking: More accurate annotations for read_lock()").
> > > >>
> > > >
> > > > Thank you for investigating. This should be fixed in the next revision.
> > > >
> > >
> > > This was not fixed in v2 [1], I misunderstood this locking issue.
> > >
> > > IIUC kvm_gmem_populate() gets a pfn via __kvm_gmem_get_pfn(), then calls
> > > part of the KVM fault handler to map the pfn into secure EPTs, then
> > > calls the TDX module for the copy+encrypt.
> > >
> > > Regarding this lock, seems like KVM'S MMU lock is already held while TDX
> > > does the copy+encrypt. Why must the filemap_invalidate_lock() also be
> > > held throughout the process?
> > If kvm_gmem_populate() does not hold filemap invalidate lock around all
> > requested pages, what value should it return after kvm_gmem_punch_hole() zaps a
> > mapping it just successfully installed?
> >
> > TDX currently only holds the read kvm->mmu_lock in tdx_gmem_post_populate() when
> > CONFIG_KVM_PROVE_MMU is enabled, due to both slots_lock and the filemap
> > invalidate lock being taken in kvm_gmem_populate().
> 
> Does TDX need kvm_gmem_populate path just to ensure SEPT ranges are
> not zapped during tdh_mem_page_add and tdh_mr_extend operations? Would
> holding KVM MMU read lock during these operations sufficient to avoid
> having to do this back and forth between TDX and gmem layers?
I think the problem here is because in kvm_gmem_populate(),
"__kvm_gmem_get_pfn(), post_populate(), and kvm_gmem_mark_prepared()"
must be wrapped in filemap invalidate lock (shared or exclusive), right?

Then, in TDX's post_populate() callback, the filemap invalidate lock is held
again by kvm_tdp_map_page() --> ... ->kvm_gmem_get_pfn().


As in kvm_gmem_get_pfn(), the filemap invalidate lock also wraps both
__kvm_gmem_get_pfn() and kvm_gmem_prepare_folio():

filemap_invalidate_lock_shared();
__kvm_gmem_get_pfn();
kvm_gmem_prepare_folio();
filemap_invalidate_unlock_shared(),

I don't find a good reason for kvm_gmem_populate() to release filemap lock
before invoking post_populate().

Could we change the lock to filemap_invalidate_lock_shared() in
kvm_gmem_populate() and relax the warning in commit e918188611f0 ("locking: More
accurate annotations for read_lock()") ?


> > Looks sev_gmem_post_populate() does not take kvm->mmu_lock either.
> >
> > I think kvm_gmem_populate() needs to hold the filemap invalidate lock at least
> > around each __kvm_gmem_get_pfn(), post_populate() and kvm_gmem_mark_prepared().
> >
> > > If we don't have to hold the filemap_invalidate_lock() throughout,
> > >
> > > 1. Would it be possible to call kvm_gmem_get_pfn() to get the pfn
> > >    instead of calling __kvm_gmem_get_pfn() and managing the lock in a
> > >    loop?
> > >
> > > 2. Would it be possible to trigger the kvm fault path from
> > >    kvm_gmem_populate() so that we don't rebuild the get_pfn+mapping
> > >    logic and reuse the entire faulting code? That way the
> > >    filemap_invalidate_lock() will only be held while getting a pfn.
> > The kvm fault path is invoked in TDX's post_populate() callback.
> > I don't find a good way to move it to kvm_gmem_populate().
> >
> > > [1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/T/
> > >
> > > >>> > @@ -819,12 +827,16 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > >>> >         pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > > >>> >         struct file *file = kvm_gmem_get_file(slot);
> > > >>> >         int max_order_local;
> > > >>> > +       struct address_space *mapping;
> > > >>> >         struct folio *folio;
> > > >>> >         int r = 0;
> > > >>> >
> > > >>> >         if (!file)
> > > >>> >                 return -EFAULT;
> > > >>> >
> > > >>> > +       mapping = file->f_inode->i_mapping;
> > > >>> > +       filemap_invalidate_lock_shared(mapping);
> > > >>> > +
> > > >>> >         /*
> > > >>> >          * The caller might pass a NULL 'max_order', but internally this
> > > >>> >          * function needs to be aware of any order limitations set by
> > > >>> > @@ -838,6 +850,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > >>> >         folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &max_order_local);
> > > >>> >         if (IS_ERR(folio)) {
> > > >>> >                 r = PTR_ERR(folio);
> > > >>> > +               filemap_invalidate_unlock_shared(mapping);
> > > >>> >                 goto out;
> > > >>> >         }
> > > >>> >
> > > >>> > @@ -845,6 +858,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > >>> >                 r = kvm_gmem_prepare_folio(kvm, file, slot, gfn, folio, max_order_local);
> > > >>> >
> > > >>> >         folio_unlock(folio);
> > > >>> > +       filemap_invalidate_unlock_shared(mapping);
> > > >>> >
> > > >>> >         if (!r)
> > > >>> >                 *page = folio_file_page(folio, index);
> > > >>> > --
> > > >>> > 2.25.1
> > > >>> >
> > > >>> >
> > >
> 

