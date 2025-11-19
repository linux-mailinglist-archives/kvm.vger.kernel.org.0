Return-Path: <kvm+bounces-63676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 91CC7C6CF1B
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 07:33:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 9530F2CFB0
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 06:33:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA35318125;
	Wed, 19 Nov 2025 06:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X1/CAq/F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6F8317707;
	Wed, 19 Nov 2025 06:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763534016; cv=fail; b=WUgt3XHB4UNoNQTQPSd/1qdbcJ5CW3PFqvRgnO0wsyu069T7bVDsNClfh2omfmacz/WBh32JDQ31bFdFDce8og5pz93QXfgWec+AEeyU5534or2vIM0+nSDmnvrdNbttQdqu6LeJyJA0WuvTgWdUh0ri65OGbE7j5vbLY7TfQLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763534016; c=relaxed/simple;
	bh=AXlQB4148Qfg/h9WGjcQP0iODqxPEWV3SPs2dUB1eZE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cqjbDObx9SO+k56dIfAgqjTrErXLYLfTD6zNWEaraRFDX1AFxHLMp/LVPGR84k23/08Vt43I32Wa8m9YFf2nESt7LMlCfc3s9Sl7estUKjoWCxekRwnM3sJF1eX7oO+WI3YFDsMz2lKvK+fSzAnP+YUAclVHegYy+L44KjDS+ao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X1/CAq/F; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763534016; x=1795070016;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=AXlQB4148Qfg/h9WGjcQP0iODqxPEWV3SPs2dUB1eZE=;
  b=X1/CAq/F5j/tu+3onXbJPafWD623fAc7QuXjcxuepevDU3KQE06YElLN
   D8vJ7xkPCG6ES8QtEaTO7bE/1llHbdoOmv6ued+QYOOpz2EpsEOkjvFYk
   JN3cBFi5mCkB3f3qNu3MotJfPvWuNbICDL6JL5WWxpdUg1nxm5FG2428/
   oG2ELiPc26aFKm0aV8K6J1Fst12l79QmTHaQGU2K7wSK7rW9OS2Dq0y2L
   9LbpvU/IY1BUfACnilgyFyo3nYe/GqWHRDnEm9SCpkrC5rdQr16v9DGRy
   4lJ5ysKdL5sSAKIaxr5oT9sVunlUFjnn+nNbU/PbE1s208VDmh4EA/m0x
   Q==;
X-CSE-ConnectionGUID: +VLq5cTQT0iStE+gC4M/sg==
X-CSE-MsgGUID: BIYIYxbVTeipo2HaJLqeLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="76672296"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="76672296"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 22:33:31 -0800
X-CSE-ConnectionGUID: TD1AWKlAQle4xxt8zJD0Sg==
X-CSE-MsgGUID: FdWw9l/ZReuhszYnumQCow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="191755810"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 22:33:18 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 22:33:18 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 22:33:18 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.50) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 22:33:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=inFYGi+6pNcp6gXhudk5GVJTb8pywzuU1hO2GmZhrrYY4NsE/aTgtAYdxc60g0nboKm+yCLfyD2chLaG9FYi4a7i2bCWc9IPR/MtRtCZxFGg5iGO4PO+jPvyk3XzZjg6sc+vlU/72ePB+znSXa8C6BFN47jk2K7837xd0K9uzd1RjWGbXnquC2OkDKyArWkarPdOjiPginNbjd5iJ8LJkvF9Z2UsQZHMUuzs9fsjtXMHaBHF/EhfqGpqaAZbBsAIMsANMPTqd5KwmgHu3xJbhOurqz9bPX1Zba0FRgkt9v0wUYLnHUWJATQmy3wdxWyqBn+CxN3AFmEwG8BRR4ZdkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qInQry/anaixCkPUEOPd20hCsGE/QYd1ig0yofax9iI=;
 b=rIj8PibGkExqeLnSxQKXGSxBmTlbze5zZWbKQv4byEUFMif+Gqx2yl4Y2RhDrxGNmdrYACo7jMmsyfmkZPpoqiOXhtZqJv5u/rJPQUi4+TFAwzo9I6zGtU4s666YdhWkYjklgIyvnSZTopG79jS7MeR0DWcIKeSZuvkr2c34LWkhJOpVJA8t8jQZo7YufsaM5378wJOxONlSk9mYUslD0cUtP6o4oXth6aQjFHciqySo7OSGqPFSo/dINrrFSsyUOLo38iQklrgXGdH2o/N3V8MhzCOiEFAT4JbqQaaDrphgFDcqHfMLU2fxPLY++aca94o4/QzxKRUUYdwNp5tzdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB8853.namprd11.prod.outlook.com (2603:10b6:8:255::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.10; Wed, 19 Nov 2025 06:33:15 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9320.013; Wed, 19 Nov 2025
 06:33:15 +0000
Date: Wed, 19 Nov 2025 14:31:34 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: <pbonzini@redhat.com>, <seanjc@google.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <michael.roth@amd.com>,
	<david@redhat.com>, <vannapurve@google.com>, <vbabka@suse.cz>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <fan.du@intel.com>,
	<jun.miao@intel.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Message-ID: <aR1kRmOrSK0Jrp3I@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094358.4607-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250807094358.4607-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: SG2PR01CA0193.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB8853:EE_
X-MS-Office365-Filtering-Correlation-Id: 34c825d5-6a91-46cd-71f2-08de273584f5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?UL+IL0uN82bwZODupxqM8yNftEuVvtKNuai9VoTn4vTriSwALZUQhJ6bVwc0?=
 =?us-ascii?Q?chz8GpUKdG2moTBa9BCd/rt2/r64HCPkIVjgpg+dpaRF0z9fFQDPNFagO4bB?=
 =?us-ascii?Q?oVBv5hdhDk8OT1QcBzyr0qnOtwhGXCuOu/PbMNFAnG3mn/xGfXNXfSV4j0hP?=
 =?us-ascii?Q?DDZR0NETijDttNRmIGUqlfyXkqa+XppDi7F+4ZvJqgub/9hWJF/fUR3W8oJA?=
 =?us-ascii?Q?CO2XQO6GTaUebj8kXRj+KbI5ET4P04dLWGbqLX4tlg5yyaUEKqplGHm0SbGF?=
 =?us-ascii?Q?ONzuF/Za+J3E+PaAKFQN51xLlq0sb+TENeet/XEccWc7p1Anfi7D2/9uJIho?=
 =?us-ascii?Q?pPFvXGviaGcLzYZS+xVLtVvW25Rbw5qs3ivQdIZcRVCL5JcbElpnCei2QTIT?=
 =?us-ascii?Q?v98bF0RcjZXt41dZyjG7E+443wYpEYMmnmmbP66hfXAQyw7yXwWdhAHo/LJ0?=
 =?us-ascii?Q?rrlQHrZ/fAMO+vXni9cRFeo0z6NRggSK4+YBwPxrzr5/wNFMHkf+4juIFYRq?=
 =?us-ascii?Q?+/fksTE6+CGZs8Jj5kwCcUGRuY4e95Cnc9eGB+LJ5h52JlkqcCwUBnbmzMmh?=
 =?us-ascii?Q?NEFcyV1Jxx38UccVnRa5G4DMqrfUpmuNSe/D0psrpKlsEoPzqkSGNPzLIS+U?=
 =?us-ascii?Q?Aj3Dp9MOARMZDmEjjaeHe43GbSjHmjUGyfAqLJipVogNRVYyb1IPUSeFdVP+?=
 =?us-ascii?Q?g+eGV8S216I6sJkm5yvo1hUI4Ob/oe0gQrKE5azvEbXTsUPpSZukjSEOAPTj?=
 =?us-ascii?Q?bBwft6eBotKQPoZX/S2cspyyQK+e9MIkU0X/ZwY3FhFtnpI9BVGRn3OK84bg?=
 =?us-ascii?Q?KF3iOR+qxYYPw6IR17Tlvaq+JqkPY/dqluMe8ncplfMRDmsbqBYgU36giIlQ?=
 =?us-ascii?Q?p6zrnbxlKm/1Usvyk7cZx14VhD1fVmuSJiOE8us4dJgm9bB19E10Q+MqOk0Z?=
 =?us-ascii?Q?gqHkUvZyguE2JWGr24KgoAHUEc+i4nYGSP9QfvY8pG7anGV9kmlNKoQ36o78?=
 =?us-ascii?Q?ofS/2q/zwnL5o1dFJSwHf0PR9Qh0aoYXcInCDaNVb0TUchDyEpveWXwOZZoH?=
 =?us-ascii?Q?V+VCmhQrZ/UZxULY5JQvLGdYIkn1qtuVUOywrnp8totarqq9aDX+xPCd67Vx?=
 =?us-ascii?Q?2908IzY3qFfAAy3hkLxyRiyOIPlfqBGsJfIckccTh7KMsjhji+dJ4SAupVmH?=
 =?us-ascii?Q?4p/V/Ofree/yobQKgfKVJJD2Ur+HHA7DOjYxDHm9pOWK/X4Q3OiTKCDGGzl4?=
 =?us-ascii?Q?j69IeFNu2IAvr08Kd7gP+K/6x9pZOya+DJpfdehJVyRCcmaInLGCLvcB3YeV?=
 =?us-ascii?Q?d4XvTTkpI/8VEhs1u33AlQ3mxfr3aCz/zmUoV8ksy1BkfEhvPGZE5tNroPrO?=
 =?us-ascii?Q?LYqN0OUvZbWb5+W8LyHQgLdiE9S94xMhmViRXMCb9m7kuvJTBcZf3nNMnTKT?=
 =?us-ascii?Q?q5fFpzg3tiiBAYqcRtGRVqEnTDXgVPGA?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wog2v32o5AOTw9iCVOFwkaLLdAYx1B/gTwoXC0dP8lVR8YdGPXWqIYWKEuzJ?=
 =?us-ascii?Q?5+kJoLotRQ4JIdDORHrHi+ajYRsnc1hKgjjWm0LVeES/35ujKVLulXVocTeP?=
 =?us-ascii?Q?WL+ql4fILd/JIieBbK2R//7EzuRYCSY+8C5lDT78bxd4kG3LN//qs9iq8Ljz?=
 =?us-ascii?Q?TeKUwpnuEtDW/dv/eblu2TwACR6v0PQ1lW1EqtfEeRJZg2+hwdC9q4q4C1OZ?=
 =?us-ascii?Q?Wh4qLmeWPJdpmC+FbEn22i7DEqnxgLqQIz5KKayhGmYvyoaFK3sBoRocA/40?=
 =?us-ascii?Q?VS9ebF2cT2yzOENrKYwRIiIOE+GP2bKqD9uNI9bYiH4f7gP0DlEQ/InKZ7Fd?=
 =?us-ascii?Q?aZIhUE2NXZ092WIaDruIrXecK8PzKIDO31HNQyYkTJ5oewcdiGqIXERgdq6J?=
 =?us-ascii?Q?+Ny6vH+PsOtoO4VflItaSYxM57dIyWaRwWcnE4G4EtUldqSmSzcS9xsmKMlE?=
 =?us-ascii?Q?9rDBjGfN7bbtrKb0Kg0kl2kZUyl9iRXREdX7QA1PVpL4I+QxuG4Rk1WrOGLR?=
 =?us-ascii?Q?PNP4dXBHMpGbDvagb9ICzKiFDiBx9wuNJUcVVUgjnD3dIaMU/4GdV55API0l?=
 =?us-ascii?Q?ilQ1nGew8glv7f8fv67jYJKAJCeuODJdcGl19EQDTr3IKVuIQjO8E88BiQEM?=
 =?us-ascii?Q?9WFPFs7EGBoE6ULI18x5lDh8h6MRrvkmzhJOWtblNBkJGTukovJa4IAxq3aq?=
 =?us-ascii?Q?GSvuUFhAe/ZBiZ1O7dhPIHRj4y1TIgPKdEQGelyduml52ENGNSAA5QbW0GMV?=
 =?us-ascii?Q?vcLtFBP3aU5ZHAJVmzntVkhMfgdM0f8hVWvgYGYSfVZqGja7O3ljewPMngtH?=
 =?us-ascii?Q?zAi9LjbYl/1oT/Sd3HyR/qob6re3XcQqEJ/hcsqODbblzxqW4tiTLtiJJb2n?=
 =?us-ascii?Q?zHI7i/niOk7pHRa8JBW5z61nYEat6ZsjkvjO5gz91eQ3KggbQ8xi08WBxJqe?=
 =?us-ascii?Q?s1gFNORkKUFe3C4gDAwE13FVSRpuJYqeutIXDJfwvu/rMpXfH/VEaYgj7tOz?=
 =?us-ascii?Q?2DKj6oixKxnSKxLJsR1uhzc0Mbngj5XI2G4M3tDPTNrX/K4gTusV9/jZum/+?=
 =?us-ascii?Q?G0MZw73gy9Tvg3LbQ7vr135cE6MVli2enIAWmUKwnyCMWMfjzcquSZgRu9dA?=
 =?us-ascii?Q?6EHi6BOkw2dEck3CkOoyo5DxfupMV52Zn8j7payUfaOG6kd/8kujrie4PQZ0?=
 =?us-ascii?Q?2WKkz3EtFnGep4noAsppMm1kejU0eM2vGMP2F7+uZFTSm2GW2k2dtxnG+qfe?=
 =?us-ascii?Q?5JQBuAdwgvkjU3wiXAcvNDC7t9du6Jp/tIKvLH7FdlLaAG30aYxe+Z2ti2A/?=
 =?us-ascii?Q?JIsK3gvc0inmsgkCvrVzaorvGtqSxNsObH7Kw0YtaW7CyB/iA0xJ3zUzpMoC?=
 =?us-ascii?Q?kBCZektxoN9WDIvA3pHuAdb1Oq2flqW89hVx8uJ6/qjdFh0V4m/JY31bHNd7?=
 =?us-ascii?Q?8y8x2tmn9EvYJz+kv4njBBjPCflKw45BB6JzIzAqEtPDL41+ITwv85hdUYQ/?=
 =?us-ascii?Q?2eigyYYfgV8W5yFdp9F5k6HPSjXjFH52D0/v/XywXspudMi6KuEx8fyN5VJp?=
 =?us-ascii?Q?+AZMRFHPLrbAq3QAdkiwp9J5ZTPH2imie3s/iaXs?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34c825d5-6a91-46cd-71f2-08de273584f5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 06:33:15.1897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vN43+0Xo40E2O5rG4sPK+eyfH+q6WhycL/Y/QRBwwcZEQLZRT4FRanp2zKfz1aqCkOdKVFgtlYXSXusRxBS6HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8853
X-OriginatorOrg: intel.com

On Thu, Aug 07, 2025 at 05:43:58PM +0800, Yan Zhao wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 9182192daa3a..13910ae05f76 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1647,6 +1647,33 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
>  				 start, end - 1, can_yield, true, flush);
>  }
>  
> +/*
> + * Split large leafs crossing the boundary of the specified range
> + *
> + * Return value:
> + * 0 : success, no flush is required;
> + * 1 : success, flush is required;
> + * <0: failure.
> + */
> +int kvm_split_cross_boundary_leafs(struct kvm *kvm, struct kvm_gfn_range *range,
> +				   bool shared)
> +{
> +	bool ret = 0;
> +
> +	lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
> +			    lockdep_is_held(&kvm->slots_lock) ||
> +			    srcu_read_lock_held(&kvm->srcu));
> +
> +	if (!range->may_block)
> +		return -EOPNOTSUPP;
> +
> +	if (tdp_mmu_enabled)
> +		ret = kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs(kvm, range, shared);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(kvm_split_cross_boundary_leafs);
  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index fb79d2b7decd..6137b76341e1 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -273,6 +273,8 @@ struct kvm_gfn_range {
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
>  bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
> +int kvm_split_cross_boundary_leafs(struct kvm *kvm, struct kvm_gfn_range *range,
> +				   bool shared);
Note to myself: Provide a default implementation for non-x86 platforms.

