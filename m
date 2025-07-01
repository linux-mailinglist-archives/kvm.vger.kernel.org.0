Return-Path: <kvm+bounces-51195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CD43AEFBF6
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 16:20:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EA364E28FC
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 14:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2560278772;
	Tue,  1 Jul 2025 14:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hacE5f7a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7575A13C3F2;
	Tue,  1 Jul 2025 14:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751379354; cv=fail; b=VIjqOOPWpPLLZ8wqh+QBzmUDSegHMjfCiVBlfpzUmwY7xi1ouyb0kyfnJ/XdS9Mzh9up3jSwcxg0wQuex/RykHVLFdHtEnzoZvwghCaxIyCXG3V5ECvjSmoema9Pn2jiQ2t9RegyIoiO7NctMKhgCI1SVPHaUgMPg6IMJucHAQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751379354; c=relaxed/simple;
	bh=s2tVG0IAyf7fdMGbGK4W6zn2drvybrpY5mUTvoYXX54=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MOLab9lP2M9t4l2hXxkDY87BvN95xMM90DnEABwq0PSqgCuZ/nxFn/lc/cy/Y+IKyWgnFaFMK9zQwKOql5kss46dQPAdHasJsSjTlA+ElPe4NvWKaKR5tq0EeiuqiwC++fTjKfurber2V3N+tjiQb/eTRAj4f3UKCQW7523RIlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hacE5f7a; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751379353; x=1782915353;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=s2tVG0IAyf7fdMGbGK4W6zn2drvybrpY5mUTvoYXX54=;
  b=hacE5f7abbVr9EiuT9y2w4WPxM9pxDB6j7odVKx6+HijWtN7FLGq5J8Z
   +OuWt+h/A3m7FRd2+HTYFTS19+a0zuP0ZJD+Yy/XQuB1C65RETXcPlXja
   8c1Um8tHGQzvtkLZeFiJSIP3oroeAjvlE8RCykluwpZLydLVecDjuQTst
   FVbKvOoPXSFo1DcyAXWfxNgTLyluRMI/UGEIRaYYFldJWQ1BvUrNqJzmU
   ez2xwsaxYV4nGuyVGlDn5+F+04EqD4izIf46Il6dbpBV8gTYUXODlDmtP
   B/HGlmaK9hhciq4DQNsengiFr+CCZ0N/dJwihU2pgLLYNua9/CcMQBaZN
   g==;
X-CSE-ConnectionGUID: qssulbhCRZuzN2Fn/RE6/g==
X-CSE-MsgGUID: 4CM2+kYMQtKNVjMcAL1ivg==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="57425003"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="57425003"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 07:15:52 -0700
X-CSE-ConnectionGUID: N4HpVZKxQ3Cpd2BVbV4wwA==
X-CSE-MsgGUID: zw8GwEi7SVu41721gvcXEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="154095522"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 07:15:51 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 07:15:51 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 07:15:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.86)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 07:15:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JFa064a8kFxTHXqXpRPx0ZmZwp/7GHBRqZNFfS/Fio4/iu1Fp/qdC5JUpENjRlpj+4dKVzGFKAzsRD8ZCaRPqDoMp4jqqiZfZL+sVR/1r7BlEnMkRGCI3Oc2jrUjBUMtSzOTxoFE5IvVKpG9c8rWlcsFjen9dO4CV+57zN2vDcyn6AJkNqJF1kDFCmhTIQ+jXKMOISlc1YmHYHfp+nRG5NH9SoCtddLog6pZBcIHthu5We/FBOwEnJynO90Hd0czjva7TtQZvBd1Ppuuj2TObUqX9JKavg8zhBCSPM/g0e3UuFQtUPgrD6InUK0VGtWM1DzWbxKKJsKMHyMagUCvjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s2tVG0IAyf7fdMGbGK4W6zn2drvybrpY5mUTvoYXX54=;
 b=RsDhTHnbjaOj7dQ2jC49TdYSy22ROHLfHKePGeJvqAowUE13zQAZZ6dhTsxtAL2ecpK6SLLJtnMRLevlsww1pEi4CvEpJ4FFjhOFc7Orxom37Vx3aYo0vTUPmx/CMdCWkU8xH+ukt6lxe7TsIcBQi8gk4PPDjc75qdLhHPah/5MGEse3PL0sLjVlI4IvPlg8fwk+xowuodmLNDw3mvgMjTFFdw/gvfz7jG7tCQg9OZ/K+Ey3BGg9BMWbtyCszMVhXqDsBN+MEV5x2Qt/NqiwabbPtiLtg+jkWxOKxkoN+DPk8bT4IYz5N/KBNEh6FP2/EpOUJhZZ2hV1GR9fyr1Rig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6451.namprd11.prod.outlook.com (2603:10b6:510:1f4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.21; Tue, 1 Jul
 2025 14:15:32 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.018; Tue, 1 Jul 2025
 14:15:32 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Peng, Chao P" <chao.p.peng@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGE44CAABkngIAACJUAgAGDrACAAALngIABC0kAgAB2RoCAAUnBgIAERXKAgABwaoCAABksgIAAJyQAgAB5m4CAAAXyAIAAC1sAgAATqQCAAHXtgA==
Date: Tue, 1 Jul 2025 14:15:32 +0000
Message-ID: <aa397b84e283d959cfef061ff1cf571dc39fede9.camel@intel.com>
References: <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
	 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
	 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
	 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
	 <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
	 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
	 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
	 <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
	 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com>
	 <CAGtprH-csoPxG0hCexCUg_n4hQpsss83inRUMPRqJSFdBN0yTQ@mail.gmail.com>
	 <aGN6GIFxh57ElHPA@yzhao56-desk.sh.intel.com>
	 <CAGtprH_GoFMCMWYgOBtmu_ZBbBJeUXXanjYhYg9ZwDPeDXOYXg@mail.gmail.com>
In-Reply-To: <CAGtprH_GoFMCMWYgOBtmu_ZBbBJeUXXanjYhYg9ZwDPeDXOYXg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6451:EE_
x-ms-office365-filtering-correlation-id: a2e98ba9-6658-4748-3fbe-08ddb8a9bda6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TlNtRmYvcVYwNXM0elhRankzMGMyUjRVdkxraG5MZytnWHhmVE0zOE1Bdkx5?=
 =?utf-8?B?RnBycGF1ZzFjMWVvbzdBamRON0JHeW85SENxM2xYcGZLMmViY0NkbnloRFhx?=
 =?utf-8?B?MEF5QUJ4ODFKbExPSGh5eS9EVVJHN0VVZ3gvamhjMkNOSUhsck5xcHM1ekZO?=
 =?utf-8?B?SDJJTGdqRUlqanFtalp0NzB3Y1p6WkNZRHVVUDk4VTZpTVdLOVZzMWdqbWdR?=
 =?utf-8?B?cXJnNXp5b2dLeUFGZUdhdVRJK3J5WDdJVlc3eE8vQ2RaRm91VlBGMnNkZHpu?=
 =?utf-8?B?OFlzejBUUmpCaGY3QnZnQjJPcmhib0YyZDJvVlAvbStxUEQyaHZJVDdOVWlK?=
 =?utf-8?B?ZFBVL0gyZ2ZzeVhvbVhpdzljaXRVejF0OTNXMlhZdlVWQU44bHBIbGtTTng4?=
 =?utf-8?B?Y1RBV0hpK0Y0endaandzc3BwWnkvQ0s1ckR6cSt5aERmcDlDaGthMktJa2Uz?=
 =?utf-8?B?RDcxMVdIOTRxY08xS3dDTnBFSXVLUnhkbnVHV0pqeXZOT0VsU1FPdVBpclkz?=
 =?utf-8?B?NEE4TExNT1F1WEpmQ3ZhSEVDWVJkT1lQZGR4bDcxdzJ0OUYwNnJWMTE0clZu?=
 =?utf-8?B?M3dCODNLNkJhd0NPeHc4Q3BOVStiMzNQTHNXcVJNRFVadlp2YXNWTnluZ0pu?=
 =?utf-8?B?dkFDVzREcHFOR0NnWGZDTWhOdEMxNkMxZEVsd204WUxBSFdKTzBvMXo3dzZR?=
 =?utf-8?B?Zit0bzkzN1pJQTlPb3hvNnJsaHVsZVI3bmhIRmpabURwUTRtV2RnN25Rb2FT?=
 =?utf-8?B?aG5wd0lVWlFHM2xOMGEzVVA4ZFk2MXJDU2RpRkZmMTVHZ2EvcFFibmNaSDd6?=
 =?utf-8?B?dFlqcHFGMm82QXAxY1AxYVdpOXk0a1YzU1pJMmpLSXRsTVYzUEpHWG8vTFMz?=
 =?utf-8?B?eCs1Q25iMEFXbFRXOWw4R3gyV1dmb0NkMFU4ZytiaEZQU3h1VW9tNXR1aGQx?=
 =?utf-8?B?d3hhZWlGY1R6SFhqKzJGM2FMNlhwY2E1N0RBU3hkTjFiVFNTQVZwektmbEZq?=
 =?utf-8?B?Rjlsc3N1bnZFRXN4dUdYYnozU045dVh6NHZFMitXdGxLcDZXeERxWXRDcXo1?=
 =?utf-8?B?OG1qYjJ2L3U0MGJzcXY3cENMWXJ1WFFjVXRjV2dvU29GVDl6MXlxeWdvS1kv?=
 =?utf-8?B?czd2Qi9WWHNUaGMvRkE1MTlIb3lsTEFVSkMxdVhIa2x4MmJPRlVsQ3ZvSitn?=
 =?utf-8?B?cFovOWJ5TkNGYzcvWEt1dnhYSnVyM2ttY2U5cTc1Z08zRnVoUW9zR3dpekFw?=
 =?utf-8?B?RmpMbGcvNjJkb3o3YVBRc3RUS3I2ZFUza3ZENkQ2OVIrNU5Ya25OdWQ1TkNp?=
 =?utf-8?B?eDRBL0VFS1Ruc2E4VGlhMUcyZ1Nma3dQc1MrbndpbXdYakVkRFFjZFFwekxt?=
 =?utf-8?B?SjRyQjR0VlZha2h0a09JUjVrQmxSc0d5d2VwZCs0MjNZQlhtckU1MDVpTGdp?=
 =?utf-8?B?K3E2THFKb3hJcitTbjduWlpKbGhReUdGMWpKZ3lyOTNOZi9oYU1EMFVqVHgy?=
 =?utf-8?B?a0JBQzZ2NVY1bGFQMyttU1A2UmdFMWp6QXEvYTd0OHpHZW5CRUM4RVZDYmY5?=
 =?utf-8?B?bk05NXFHcEIwQkJOMWlpOTMrdlpVcU5wVVE2OXNpYXpPekpwVFlhbURmOUFs?=
 =?utf-8?B?SmlVUDlEeVdaT2NualhiSjQreU9oQXhQM2lQSk9KK1dqTWF6VGhYKzVBNUNY?=
 =?utf-8?B?Y3d6dHp0VENBOEFHNG1zZ3BiVTE4Y0dqTEhMTWt3WTlxd093anA1SjNVQ3BJ?=
 =?utf-8?B?Smhnd1ZwVUxuaHJMMGxUWGtMZlB1elBZYUd6TG9pdURHQUFOYmcwdGRGa1lx?=
 =?utf-8?B?S3k3WDhZeEl4SjdoSnp6VEMrYWQwSEYxSHR2cllkZUNNYzduay8zQU9vUGow?=
 =?utf-8?B?eHdQUm81MzQ2LzhwOVhaOVZmWVdnREZPWjB0clltcTVqVVhZa2I0R1lDU1VJ?=
 =?utf-8?Q?Wco/dFkfdVQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVJDSVByem81b0IrZlJjZXdiOVZpbFdMTWtlNWFDTDE5aTg0dVlvQnUwVDdo?=
 =?utf-8?B?YlAyZjZFU1pCZFRBNlplMXN5bHlpM1I3Q254aVB1K1I0clA1NkFiWlJtV0gz?=
 =?utf-8?B?OEZtSVhtd2lsL09PWEI5ajdyeStxc1d5bzVSRkJIZi81OHM3WDFFRGgrSjZX?=
 =?utf-8?B?U0Y0RWpaTzdSNE9UU2ZlNlByeFNDRlphZHhpQlJmNjFxLzFOL2E5b0MyRlhp?=
 =?utf-8?B?RTNIcUVoVy9tL0M3ZkQ5Q0ZwcUNUclhESE8zR1ppc1FFL2pJMnI1a1lHdjRs?=
 =?utf-8?B?dVlYU21nRXJSSTBJYWdDYVk4b01aeUxKamxzRmlBVVRUOWU5cGZKUFprZjZh?=
 =?utf-8?B?cy8rS2JyaGVhdHBjK1dhdnNaR04ybUhENXAzNktlQ3FReVBXUk1Sc1J5R0FE?=
 =?utf-8?B?OER1MmkyTlhRdzJoRmttTWtHdm9KRTlzYytON1dLSmNKcHJaN2FRSlBKYnh2?=
 =?utf-8?B?UmxnUjA0WWVQRnZBbTAyTlRRZTRrSmxNSW53Q3hkdE9PN1BBY2h4MWZzRmtI?=
 =?utf-8?B?QnV5RUNLbGhwY2crcWdwa0Z4WDdxVzRBSTY1dzRiZllucjRHblFwRGFWSzU0?=
 =?utf-8?B?VEhoZTdJaUV3L2JGOTZmZmhaL2hCbGtXTFBEaGJBS3VJSUQwbTdKWktPU2Q0?=
 =?utf-8?B?RmVMNGZ0MDErdWl2ZTdEM1I4VjU2RjcxSlZ5QWtOa04zSG1MbWUrQzZZbGxk?=
 =?utf-8?B?OCtabFk4TC9KYXhBcUJmY2NpZVVhNTd1U2RmRzUvU0RTbXRoR2JuWmExRWd4?=
 =?utf-8?B?Z0o5d3R2QWhPTFdxZUFIVnBnUU1lN2dKWEZBQkNBSkowdU16TEtwUE1LZDhH?=
 =?utf-8?B?dm90NGtneFREYmNJSnJPUlZoMWVDWW0vV1hWN2wwNEZUWlRJcnhNRHpNbUJD?=
 =?utf-8?B?MlZSSHl5RlhoVEZGM2dSTFpwbzhjRUMvMUg4NkZYTWxxeVR6ZHVLTEMxU3A5?=
 =?utf-8?B?MlNJN2R2dmViWjdqN3gyNzVmSldBYm9FRWxkYWFPN2JITTVhYmd5N1BncHZG?=
 =?utf-8?B?b2NnU21TTzdnRmJjYmwyR3hDcWN5cmgvNENKTnNkTExaNXBheU5CSjVjMW05?=
 =?utf-8?B?d29Yd0x5TjQzUTh0R0NnT04xVHJIbzRKdUZielJockVpL0tVK0ZWMGIzQkhI?=
 =?utf-8?B?VE1jazhoWnlFcXozVmxaYVdFOW1ZcVNHTlpiZWZSRnNrWUY3NFJUZXJGRk1y?=
 =?utf-8?B?WUFyVkxzUzRhZXk4eXBIT1EvQ1U0ejlYN0FFTFJkc1lzMnVmekQ1c2FFYW9i?=
 =?utf-8?B?bUEycS9qeWFpOWZ6cEc3NVlXTDl5SWRhWVMwSHJpalpFVXZPdVEzWEtMS1Y4?=
 =?utf-8?B?LzJLZUhUNkFLc2tnQjVFWFFTWWJ6MEFEYk92REw2dEZ3U0dVMlAyc1BRbk8y?=
 =?utf-8?B?R0YrLzFjRWtpUFZwSHg4TkYwbXcvWGhRRUVwUTlzaXZFZXJGRlQraTJyWEN1?=
 =?utf-8?B?ZHJWR1JPMzlFNkpHQmIrRzVneWgwNUh0Zk1tQkVhMUwrUG5ralZqbUJ6eity?=
 =?utf-8?B?WHIyVEdpMDh0OHRXWGZuU3FRb1RPbE1nVllGZDUrdk5CZG56R3N3Z3RYT2xy?=
 =?utf-8?B?OVBNdXorMVR0aDVJWDVodktYYm9ZdVd6QlRIOEt5Zk9KVlIyRUNkaHMxSis2?=
 =?utf-8?B?RUo5WkpHUmlSV0s2cGNseFNCeWE0NTV2eTJwNHB5WkNMcFd1VVJvR29pbXN1?=
 =?utf-8?B?WXdZNVNmb1RQOWNmQ1E1WG1yT3l6VS9vTk5NeVIwdHlkUzdBSWdUa0RIVFox?=
 =?utf-8?B?WlV6NlZsU2ovcWlubzJHTGIyTXhwOENsVHVjbHFuZ2RnVmx4VVYyUklBMWVF?=
 =?utf-8?B?a1hhckxiOUlKekdSUGhQd3dlbkx5cXY2T091ZnMvenpGRm5mV2EyQSswbmN1?=
 =?utf-8?B?QWNKN2YzNVlJVXRNWnJDZnJTNXF4cFhHb1ovaEVnTkhMWkc0UlVXb0NNd2NH?=
 =?utf-8?B?aUNSVGlLNE1HTFNVQXVXT0I5YzZaQTUxaFJxdGowZDZYQklIeXpqSUJmdzNC?=
 =?utf-8?B?Z2oxK2RDWU9yRndvZ0l3REpQN01ZUFYwUHRZcWxCdEFMZWpuWk1Gc3pOMmNP?=
 =?utf-8?B?NCtVSzFHdW5weXMwQnY3U2dDRU9jb0ppakNMRnUyYVhyVGdRTkdEYnNvd3BK?=
 =?utf-8?B?ODd4QzdZWmcrK1hqeWhHTUxYbnc5TFhHWGlBZ0p6TURzdjZpS1Z5eldYcEVl?=
 =?utf-8?B?eGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC5BC0C5079B2544BE8193D40F3F809A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e98ba9-6658-4748-3fbe-08ddb8a9bda6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2025 14:15:32.6769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D+d74qKFF7TKvKb5JLDN09C7DgoluZ/5j3khGB+221/Y+v9M6tyFtlKonfANa7I/Vk8yReqM10IFn23OVoVUqqvVDuNx7yc28fDp8zhXdW4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6451
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTAxIGF0IDAwOjEzIC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiA+IE5vdCBzdXJlLiBBcyBLaXJpbGwgc2FpZCAiVERYIG1vZHVsZSBoYXMgY3JlYXRpdmUg
d2F5cyB0byBjb3JydXB0IGl0Ig0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC96bHhn
enVvcXdyYnVmNTR3ZnF5Y251eHp4ejJ5ZHVxdHNqaW5yNXVxNHNzN2l1azJydEBxYWFvbHp3c3k2
a2kvDQo+ID4gLg0KPiANCj4gSSB3b3VsZCBhc3N1bWUgdGhhdCB3b3VsZCBiZSB0cnVlIG9ubHkg
aWYgVERYIG1vZHVsZSBsb2dpYyBpcyBhbGxvd2VkDQo+IHRvIGV4ZWN1dGUuIE90aGVyd2lzZSBp
dCB3b3VsZCBiZSB1c2VmdWwgdG8gdW5kZXJzdGFuZCB0aGVzZQ0KPiAiY3JlYXRpdmUiIHdheXMg
YmV0dGVyLg0KDQpUaGUgbm8gbW9yZSBzZWFtY2FsbHMgPSBubyBtb3JlIGNvcnJ1cHRpb25zIGlz
IHdoYXQgdGhlIGhvc3Qga2V4ZWMgcGF0Y2hlcyBhcmUNCmJhc2VkIG9uLg0K

