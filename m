Return-Path: <kvm+bounces-51742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72F3AAFC414
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 09:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B877D4A3712
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 07:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DAF629A9D2;
	Tue,  8 Jul 2025 07:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EL8lbHZR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424BE175D47;
	Tue,  8 Jul 2025 07:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751959862; cv=fail; b=t7K6DQ+GpnpsCP71DLhSS2UDrdFmU3Ke3EFwnHAaEIu4Txknvj6SWIWnT7oBL7DGpp0LLNLFXViq++GmIZB/ZmEkTmirxskP7L+/yheTnkgoToO6t2nk+GOKDqES9GpYpERToMgiR6fDqD2LNEso5TvOIbDa7Mvq2KFQr0v6yjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751959862; c=relaxed/simple;
	bh=SREgUhfJ+5aE7IdkVMD+3kcIUw4BgyMcEfAX9U1ALBs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fml0D2L5RS6wKcQIXSh+Y6Mc5sqSnjgZ5cqIkac+m7FDgBykt65lPJXd6Lc7jyqPgA3Vtzwnw1lEZEMCTdw5E9kJ41WmppWI5ZaRC9jxLz+X5QYSiqr1UD9U5rl9gGp2Wh849L24FaTykeceshWJpnZSyGPclD1P+3AhaGtR6aU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EL8lbHZR; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751959861; x=1783495861;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SREgUhfJ+5aE7IdkVMD+3kcIUw4BgyMcEfAX9U1ALBs=;
  b=EL8lbHZREmLyYqevzZkVV5zxc40xqcUhDsI9Q47tvMIuoOrdFB7nerYT
   LuJqACWnsOR0Qsul/bp4Cwwcnsh1WoT1jju6hZmRwariWPIuIhb2Nm0q7
   ZdczzbZnuIfmScAyT8mdlQyKGEkqlht5kzP/f2hoOQRY+eaWJXf5x2o0t
   g1QM+tn1j8bjFjlNHl9+bItKFDBusJpeW6acdAB2yrJv2kWBBDCjxGpRL
   goHF+BTOgkL5tn7WUN1HGojUClA0ngbVnmsydyaim1VOx+SYH/wUJ71Ci
   K0o5zI643xN2Ywox+xxF5mlFiYE8RCu8d5ousOo87Lg8jzT49ODAmNKhQ
   g==;
X-CSE-ConnectionGUID: +cYVozjySVmLoGUkijzAcQ==
X-CSE-MsgGUID: TJMphhMkR1CGhUgummW00g==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54074888"
X-IronPort-AV: E=Sophos;i="6.16,296,1744095600"; 
   d="scan'208";a="54074888"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 00:30:59 -0700
X-CSE-ConnectionGUID: utr/IvHORCOhOD8DbP8efA==
X-CSE-MsgGUID: /JKryDfSScaGQVVbmvqOUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,296,1744095600"; 
   d="scan'208";a="179097222"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 00:30:57 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 00:30:56 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 00:30:56 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.89)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 00:30:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=naOazC/d4vofQeIOAdujrE7yCb7inshmUmC+y4DMIEkaLnq8gdNL6wLrm0anrSh6RfMlcNff+NBQ7NI1r82hES+ynD9xv0jKqKHHob79CqTKu5Z1iBWlFOfOs7gOASZ+aS6WQeVtePBUVhVGJ49DBW3mhlfPIMzpDQ1v1azY35BSzq55A4sSHoSTTlkL2+PeJa0LfuoTOPxS6UbufAIcDFD7miseZLGTgLwhmoKu5rrfhtb+e0my1w/guQBlN2UMMXFwRdM7p1RKaybFQiUwBLnEbXBzb1TmybN1deyIUK1ICQAqIdmGSBHn4+N55H5XIOg4QTcrAbmnLjGSU7vbCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SREgUhfJ+5aE7IdkVMD+3kcIUw4BgyMcEfAX9U1ALBs=;
 b=FFEyHa3SqeSEgEe4p4jNaPwEvNFnbeLgAkVWz+buaDCVCmbKHsg7Z8tDWVylP0kO+z7EfOGvsgWprq9vXfOwSh6mFWr9jQManQ4LQO3OaGxxUlCPbkCLKP6XPcMgTu9i6XZFx9dOaA4WQdRlGxcO87ND9UxKNlpmBMr5DwdfpMLUoFbmVj7OdOvfc9J7LwyDMmeAwUzvZn6yJPIK1GTGywCBVvXlVM90UglM47FEadIo0vYex7N0R6pyi0LzbEPh52nTEl1eV0Xb/DD+rTWoMzT5N1I81TKT9zvu9LcUbK/rGbQajicNrBvh3F3DzFxcENUwsWX/zdt9OMqxSe+v2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY8PR11MB7134.namprd11.prod.outlook.com (2603:10b6:930:62::17)
 by CH3PR11MB7817.namprd11.prod.outlook.com (2603:10b6:610:123::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.34; Tue, 8 Jul
 2025 07:30:52 +0000
Received: from CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::cd87:9086:122c:be3d]) by CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::cd87:9086:122c:be3d%7]) with mapi id 15.20.8880.027; Tue, 8 Jul 2025
 07:30:52 +0000
From: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
To: "Mehta, Sohil" <sohil.mehta@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Xin Li <xin@zytor.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski
	<luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, "Sean
 Christopherson" <seanjc@google.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, Kan Liang <kan.liang@linux.intel.com>, "Luck,
 Tony" <tony.luck@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>, "Steven
 Rostedt" <rostedt@goodmis.org>, "andrew.cooper3@citrix.com"
	<andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>, Sandipan
 Das <sandipan.das@amd.com>, "linux-perf-users@vger.kernel.org"
	<linux-perf-users@vger.kernel.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>
Subject: RE: [PATCH v7 05/10] x86/nmi: Assign and register NMI-source vectors
Thread-Topic: [PATCH v7 05/10] x86/nmi: Assign and register NMI-source vectors
Thread-Index: AQHb2+RNN65/PxV/uEC8CYMFPk1A1LQmyF0AgABzkACAAL5UkA==
Date: Tue, 8 Jul 2025 07:30:52 +0000
Message-ID: <CY8PR11MB71344115BD680973922C3670894EA@CY8PR11MB7134.namprd11.prod.outlook.com>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-6-sohil.mehta@intel.com>
 <CY8PR11MB71349E0943913F8AE944B3EF894FA@CY8PR11MB7134.namprd11.prod.outlook.com>
 <9dd8771d-ce4f-4bfb-8fbd-571f3e188514@intel.com>
In-Reply-To: <9dd8771d-ce4f-4bfb-8fbd-571f3e188514@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR11MB7134:EE_|CH3PR11MB7817:EE_
x-ms-office365-filtering-correlation-id: 69127c65-b498-49f6-9bcc-08ddbdf15e35
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|13003099007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TWVGVFFLU2V6OXg0RWpLUFAxZnIxZEZlck1lamx2TStwOVFJK1pjbU43QnM3?=
 =?utf-8?B?R1lGSkhTSktFM1hxWUNHdTAzQUZUZi9XMHREeHR3RFdJU0NCVEVUR3JsdDNW?=
 =?utf-8?B?WTN4Z2U2a2JLTUd1TzJ3a0FlUWI2U1g0QW5zbzNXZGk3blhTci9EbHdhckdL?=
 =?utf-8?B?anpYcFNXZGlyYnFjMGZiK3lBTFYvNkYxbTJOMjA5dUZOOC9TYjRxNmUxemt4?=
 =?utf-8?B?OURYcFJoYUdTYVNJU0R3cG1Xa29rZDV0L1pXYVk4Zk9pVVo5dmVGSGhzUmlZ?=
 =?utf-8?B?QVAxRVJYVXplR3VzRVdPbXdzbXNEc3ZaOG1ZcUNERFBCY2gzajNPRlBSd1Nt?=
 =?utf-8?B?aHZ0OEFIdXhwVmlkbEM2RkNxSENrS1R4ZFRnTFlsdzFGTko0NGRHOW1DTzFt?=
 =?utf-8?B?aU5tTzJPZmI3c01aNWQ1NFliQzRmYXZtbG1CTm56MjFkR3dPTkxDRUZ3SU9J?=
 =?utf-8?B?eDhLZEFiWUUvbEt4NjA1NDcrblJkbkhJUGdzcUpvMEN2bk5TQitSRHhrbyti?=
 =?utf-8?B?QXVBNU9KM013ZDNsWEV3VUhDbWFQUGhyZ3ZISmF2Z0pqNDZkWDVoS1BvaHNz?=
 =?utf-8?B?akVyU1Y1NE82Y1BIRmNjZFBNSUpEM1M0eS9YamRKTjVicEVsTGVZb3dTc0RO?=
 =?utf-8?B?Y29kRXp1WXJhcFVHRUt6aW9TZE5SZW5hNjNKOVBETDZIUkxxSy82NFM1cWRv?=
 =?utf-8?B?WHllR2NHNW9xeENTNGNGaW1QYUxnR1FPOC9CUTg1VDlOT1BHVlhIV1hsQmo3?=
 =?utf-8?B?YkIzU29YeW1tdnl1ZjFSSUxQbno4dnhxajlVNlVLaWNWUUMzdWlmK1FzQldD?=
 =?utf-8?B?VXRjM29SU0dWclBXa1dBT2FOMG9FL1plNDR3REhCTjBhYzJEblhFNzM1MVBl?=
 =?utf-8?B?aDlBSk1FR2pRY0V1WXpWb2N2aEwxUkYzYUdwRVVYUjlOZDZnYm1hSUVxLzI1?=
 =?utf-8?B?Z1FwSGRzdW9hNEU5SHhUYlVjT0R4dlVGSnpzVWVWNjZkYittakZzQ1EvZWlh?=
 =?utf-8?B?WGhiejczK1RFOThKWXVocFFkVUwyWDBobU52dnhFMSthemR6QlVhYlpmTTdO?=
 =?utf-8?B?b1Q0UTNiVlh0WFN2Vk90MnB6YmpKL09seE9kQnFRSUJxQytGcmhMNDY2Mk4w?=
 =?utf-8?B?TXVidFFmRVFUcFF0Y3FFRFQ0TW9uaDk5YWNiclVSeGszWjIvUjNYRWhpenFk?=
 =?utf-8?B?SG1WTGZsaC9iUlBMWkxQSXN6dFY1ejB3Y3o5K0VUYTk4cWxiUGhJbnNZeDNH?=
 =?utf-8?B?OEVNdmZMcEMvMkdwRE05RWpQMWFpb0YxK1kwQmhiZGRiRUZuNk5WRk1EWVRn?=
 =?utf-8?B?Q29SaUNRUGloQU5RQ05wZ0U0QWRsR2F2MlNjZUxhcGF6NUJhc0IwY29Ja1Y0?=
 =?utf-8?B?cEMzQU95Z1Awc1YxVGZ0dHE5aWJGL1gyR3EzWC9EdThUeDNSZ3grcW5wMkZ3?=
 =?utf-8?B?RWtZUkl3NG1tRkJEVmNtOTRPbm5rUTdhMWtHb0l1UjRJckNvOEl0TWIwckVh?=
 =?utf-8?B?SnJtU2pEbTBNN1dGZ0tuanMweFRMa2xkak1ocDRiSHV6SmViZWU3c0JXOVZw?=
 =?utf-8?B?VTdzZVdFZzZkMlQ4SW1Oa0VGRm1BU2V6Wm9ZSW80QkN3KzFUUmpSUHBIYzZH?=
 =?utf-8?B?VzZUREFzbjlVRDkrZjdiRTVnamJaTE1KOWZ4OEg3NExMYk5VWGE5SHU0S1l4?=
 =?utf-8?B?YkJCRFFVbjRkZ1E1c2tkZTVZQzZSK3k4UjVOdUFUNmN1eE5CMU1SS2lCZTRm?=
 =?utf-8?B?dmtPSlN0c3QrSEJGNkZ2ZWFKNGptSnh4aUtnU1pNLzh4MEZKWjFiRzBkMXNL?=
 =?utf-8?B?WXFIa09hd0pNOW1sZmgwNFl0RkJoNXkzSnRCcUZsdXVpOTZ6aUhpWU1Ba0wz?=
 =?utf-8?B?K0R5a1FabnlXTzg3bHMrSXpRQWVhM2RFVUhyenVMTVVNcFZsTG5BdEhMTWo4?=
 =?utf-8?B?bTNSQjh1eXk0WWd6azMvYXBxNDQvYk1iUFYxeFN0L3dmeGhVcUZMcGV0bXVp?=
 =?utf-8?B?YnRTZlZrcU53PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7134.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(13003099007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SHQ2TVVKOXN2TjBFQVpLQVlNRjRKQXYyTGJUd0VJV2VnaUZXNG5FRExFOTJk?=
 =?utf-8?B?eERSdmkzUjlOMkU5M2lYSVBObW9TbXZHdmZVcGpkQ2hYZURJUXNHYnE2bnda?=
 =?utf-8?B?amRzYkJFNDB4QzdZZTBZVzIyVklYUWlLcWVQSVowdkhIN0duU05SeTN0NjJs?=
 =?utf-8?B?VlVPbm1QV09lZWlkbm0vSVcyTFhpWEc2WUdnUHJ1YmwzTTBQeVhhOSt1MWlt?=
 =?utf-8?B?VkZRWkxhVEVnZlBMN0hIMWRFL0pNT0FrblRURHNwZ21FU3plN0lCeG5uUFRE?=
 =?utf-8?B?NXlJVDcrL0JYbjMzTVMvb1JRaGJ4Y21BbzZVZjFsc1FjbHk4L0MrTXdReGpv?=
 =?utf-8?B?SU5GUWFZZjF3SGNVSXBBQmRGNDhubVRMUDR0VlJnZEhUVXpBL0VhTktjZ1Ew?=
 =?utf-8?B?OXdSOHRSMkoxREQ4V3VmRWM3MFBRSS9kZDF0dGVBenI2OEdkSzlYNU1BRmkx?=
 =?utf-8?B?ZHVSU0dZeExFZ0ptdHl1R2lUeUpPMUp5OXl1aG5JdU40eDU2enE2WVZmWWtl?=
 =?utf-8?B?VkFxT2M1ejArcXpoTnZOY0lDRHpXM040UVVOeUVTUG81TG1xd3Q1VlNvUC96?=
 =?utf-8?B?Yjlmck04MDd2ZklWaHhFWkZoS0czeGxLSzZYdWRnbDhSYi9VbWNvZnQrUFh0?=
 =?utf-8?B?L1c2MjQzWTZlWXNRaGlhZHo2bStsWDRNaVBhOHZGdHpvUy9CRnRzUWJLSnVJ?=
 =?utf-8?B?dk0yYlhPdDFOa0JXSE12d28xc2tld0ZFU05POXdnNFExRFo2czZTY3VrY2xI?=
 =?utf-8?B?SzdvcWY0RFR4RmNiYTZuYk40WkdVZGI4QU5Ca0lJQXJFZk1qb2dpdnh1UEVx?=
 =?utf-8?B?ZXBydTlDOEcyalFVWjRZRDNzeUgrK201UUQzeHNRdGRZVkJLRHRUc1VmYWU5?=
 =?utf-8?B?aHAyNm5mRUhON2VOekdBSS9IVG1wNzJvVVNQVWljQXNwNC9tajNvZlZNZmth?=
 =?utf-8?B?MDdHQTdtcmZQczExUmN0a09qL2FiZzFMdjcyVUowSkdrT3pwRW8zZTdSVFYr?=
 =?utf-8?B?UVVReXJrb3liYVlsVFdHUmRQOFREbGtvKzBISHRPelEzYXViWFljdk5Uczgv?=
 =?utf-8?B?WUNRYlc1eHJSdS80MnE0WHQ5R0lrY3U5R0RyZ3FTMWx2cmQzaVExTFRSWFdz?=
 =?utf-8?B?S3l5dTA5VlpGRDA1eVdoK1h1QkdJUFF3K0Z3WUZKZFp2RUFpVjN2R2JZQ1BQ?=
 =?utf-8?B?Rkc4d1ROT21wUkVMVkFsQ0hTS3g3cnd0SVNWUUtVbVpuTUtUS0RDVm9ESHZy?=
 =?utf-8?B?UEQza3B0VFJ1UnpzRkY2SjQyMTZRRURDeUp1UGZsdmJtMDA2SzdXRFdHUXRW?=
 =?utf-8?B?QWZ1dWsxWHd1NkFOUE1Td1pBbjlUT1JRb3c0clg4MHptRXRCTU5vUWN3bXZj?=
 =?utf-8?B?SHRENnRlakdBOVBOTEZ0QWE0UHhMem5RREliSGJ3Y1Zjd3NRblQvdmRvS29C?=
 =?utf-8?B?MWRhV1J5L2ZBaVdHWGJrby9yVmZFRWl2WTY4bmJLOGZUcFZwcjgyUlYrZXh6?=
 =?utf-8?B?czcvS0pDazJVdHlhZ29jWjcvM1ozWkhveDk3WG0rb0xMMDdVS25HdVhGcGdB?=
 =?utf-8?B?RmZUQUsrR0dVTzkwZXB2TENKd0ZrbkhQZUNyOFdteWlDYU5TYTdiMUJIQUlK?=
 =?utf-8?B?Mm5CYncyZ0lrcjVqRENIYXhGelNqR1RlMHdQTHhOa3ZTbVptWGtwV09kNlZn?=
 =?utf-8?B?MXF3eDI0bGg2WWV2Q2V5OGFPanNSNGI1dThaMFArN2VNTmVNN3krWHRqMW1r?=
 =?utf-8?B?Ny9QY3k2ZXYrUnlRaFpyNSs2M3dYanpiZTE3MFQ0b0RsQm8vcnNxcEs1TTUv?=
 =?utf-8?B?dlBUVmpaWWpOZUFVYXNORzBDRjI0UVMyNmdoYzZsS0UrNDEvV2w3eUJMUi9v?=
 =?utf-8?B?KzFqZitSR0YxSmJOVjlwVUFudG9QRzIwK2s1d2doTUlSMFM5V1RkczRqR0RB?=
 =?utf-8?B?V28yc0RPTWY0THYxeTVFd2VpQmNKV3l6TWlUVG5TaW5ldFloSi83aVY5YlNE?=
 =?utf-8?B?TXhTSkltZjcvREFqRFN5cU85QVUzaFVCWlZhU1JBN1hVQk12UlVjRFl2VWJI?=
 =?utf-8?B?UG50ZmNZSXBsbzdmS0swMzlpSlVxUlNZazRuUE1SV0I4ZGoyR3lWdm5BbGVa?=
 =?utf-8?Q?6qa4aAcaq5dFl6Kkkre5sic62?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7134.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69127c65-b498-49f6-9bcc-08ddbdf15e35
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2025 07:30:52.1420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kwdy/mNPvmeHj7aiyXN+dtxkeb5RXFVDaWJv0rqHUR1zV5t6cv8/K5Vml1zhvHtnHuIW64fv8Z9cAUL8SrDx1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7817
X-OriginatorOrg: intel.com

PiBGcm9tOiBNZWh0YSwgU29oaWwgPHNvaGlsLm1laHRhQGludGVsLmNvbT4NCj4gWy4uLl0NCj4g
Pj4gUGxhdGZvcm0gTk1JIGhhbmRsZXJzIGhhdmUgYSBzaW5nbGUgaGFuZGxlciByZWdpc3RlcmVk
IHBlciB0eXBlLiBUaGV5DQo+ID4+IGRvbid0DQo+ID4NCj4gPiBGcm9tIHRoZSBjdXJyZW50IE5N
SSBjb2RlIHBvaW50IG9mIHZpZXcgWzFdIG9yIFsyXSwgYSB0eXBlIG9mIHBsYXRmb3JtDQo+ID4g
Tk1JIGhhbmRsZXIgbWF5IGhhdmUgbXVsdGlwbGUgaGFuZGxlcnMgcmVnaXN0ZXJlZC4NCj4gPg0K
PiA+IFsxXQ0KPiA+IGh0dHBzOi8vd2ViLmdpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQNCj4gPiAvdHJlZS9hcmNoL3g4Ni9rZXJuZWwvbm1p
LmMjbjE5OSBbMl0NCj4gPiBodHRwczovL3dlYi5naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0DQo+ID4gL3RyZWUvYXJjaC94ODYva2VybmVs
L25taS5jI24yMDENCj4gPg0KPiANCj4gV2UgaGF2ZSB3YXJuaW5ncyB0aGF0IHNob3VsZCBmbGFn
IGFueSB0aW1lIG11bHRpcGxlIGhhbmRsZXJzIGFyZSByZWdpc3RlcmVkDQo+IGZvciBTRVJSIG9y
IElPX0NISzoNCj4gDQo+IAkvKg0KPiAJICogSW5kaWNhdGUgaWYgdGhlcmUgYXJlIG11bHRpcGxl
IHJlZ2lzdHJhdGlvbnMgb24gdGhlDQo+IAkgKiBpbnRlcm5hbCBOTUkgaGFuZGxlciBjYWxsIGNo
YWlucyAoU0VSUiBhbmQgSU9fQ0hFQ0spLg0KPiAJICovDQo+IAlXQVJOX09OX09OQ0UodHlwZSA9
PSBOTUlfU0VSUiAmJiAhbGlzdF9lbXB0eSgmZGVzYy0+aGVhZCkpOw0KPiAJV0FSTl9PTl9PTkNF
KHR5cGUgPT0gTk1JX0lPX0NIRUNLICYmICFsaXN0X2VtcHR5KCZkZXNjLQ0KPiA+aGVhZCkpOw0K
PiANCg0KVGhlIHdhcm5pbmcgZG9lc24ndCBpbXBseSB0aGF0IGl0IG11c3QgYmUgYSBzaW5nbGUg
Tk1JIGhhbmRsZXIuIA0KT3RoZXJ3aXNlLCB3aHkgbm90IHVzZSBhIHNpbmdsZSBOTUkgY2FsbGJh
Y2sgcG9pbnRlciBwZXIgcGxhdGZvcm0gTk1JIA0KdHlwZSBmb3IgcmVnaXN0cmF0aW9uIGluIHRo
ZSBjdXJyZW50IE5NSSBjb2RlPyANCg0KSSBqdXN0IGRvbid0IHdhbnQgeW91ciBjb21tZW50cyBv
ciBjb21taXQgbWVzc2FnZXMgdG8gDQptaXNtYXRjaCB0aGUgY3VycmVudCBjb2RlIGFzIGl0IHN0
YW5kcy4NCg0KLVFpdXh1DQo=

