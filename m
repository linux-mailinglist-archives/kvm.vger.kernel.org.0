Return-Path: <kvm+bounces-69990-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eLYrD8PRgWl1JwMAu9opvQ
	(envelope-from <kvm+bounces-69990-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 11:45:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C9898D7E7A
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 11:45:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 657FC305A39C
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 10:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD106322B77;
	Tue,  3 Feb 2026 10:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mg8NdNfZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CF930BF70;
	Tue,  3 Feb 2026 10:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770115499; cv=fail; b=InfroLrP6y9HVx2ue5E+umRVbEV2nnZWjYbe6pyXnpVIMzb8cd6Cf4tOPK5AVyOJ04mmPT5aEBisZnUfUf3pqhzLLqywHK3HC9im7m7r8BLHyUVpllNL6oTPppmOg/xRoqn+RCMKAdgKENjSCB/kNgw1AgboagvJls8r5AvqYEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770115499; c=relaxed/simple;
	bh=kQfOamBScIbsPO+3Kq2rTgYGeH9znReiFm9IXaiKJtM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Kfg7JEJIih0r323N0rYA+lWP+/hBSGT3xpTlBjT8pJ0CkKsYyAlbAKSorNxltOLOZVGBaj6btuibQ6roH9jwACqUqsatNJFR3htZ8JagRp/YXXfL7TtFbsn1UYSM/AL5hXqC8L4tURncqZ8FK0nQEvevYoNkF1Gvc0ALPaxu6T8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mg8NdNfZ; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770115498; x=1801651498;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kQfOamBScIbsPO+3Kq2rTgYGeH9znReiFm9IXaiKJtM=;
  b=mg8NdNfZvCyBjS3DfcL1hysbvUV9QhdKqciixUcUw0WRY40j8WFCnVuD
   br/hyMv+R8DvMBQYSorHLZFpNqddeyIvtTrloNNyz1sKbmp8roWn8pxtD
   iDB71QGC1pEKQSdcfKLeuO+1t0MbVSoP+gkmmPJhHr4EAHytmmZj0cdF3
   USpCBqxHEejOk6rCo+veQfz44lP4ASaGkkNDoUJsWVuoWFZq8xEva6YyA
   fVCf7gVTamjQod6Ck151T7Na7KJh0cZ6Evfw/M3H2V3msaafcaA1y4Rgy
   atF1u74ob087NxX5EcmIYnz4pP2Je34IPCIoRW2d25iMAfOJgaYks536v
   Q==;
X-CSE-ConnectionGUID: 62n6Skl3R0e9QmrzXdVVWA==
X-CSE-MsgGUID: zSLkRtSFSCuZkQTQj7mMsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="82391029"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="82391029"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 02:44:57 -0800
X-CSE-ConnectionGUID: QVlQq1LiR9ulVLDwA8nnwQ==
X-CSE-MsgGUID: oD8QV2Y2SBOv7xH/aqwcmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="209903064"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 02:44:56 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 02:44:56 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 02:44:56 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.22) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 02:44:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YqH+/qHfLr9QLRu+Q9WhXYtX1cJ5Jg68hykUna7HzmNZAZ5+7arWZHagY1wHVzfm15+RYuAntnqIl+4tC9W2wFTxua/LSZDy9sfvbG2cL6F9kV1l2D+8gOeO/zRJhqW+eYk4tW92Gq5I4wpKO1kqAmbAC/k5HwBY9+Ju1Zs87tNEF2xczsEwyvMPGyd+hPTFfQuA3QymCflXNvM1hXniMDhBkU4oaok4djP2UzEe68s87Gz+MKDJPT3XsAHmiHUtQeNHpaywGQW12McK9GVVpB5Omkv3Q3/YnuY3wchJ3tznJzRevlKiNAZE2LJz65P8ohbzy2QNFkzYLwRHUS6PAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kQfOamBScIbsPO+3Kq2rTgYGeH9znReiFm9IXaiKJtM=;
 b=Izk24GoqCd6+Xox8nzdxhduEmkNuEexy9fHnKukXALqQk5CnHhlK2oUebBmhwtXhzXPP79lJkdHMvigR8trocOgxtVaLQjp/qqw0kpicZkIZGfwp3QIBP+D3k+tji+4IE+Kb7TJvAUGEyZQbQTRQjRlhcFtVovAzh83HYPEr2Zzc/ELyIvIexV+6kO1zGBZEgPevHh8y0hXFyASfjcXlf0UyEzCi5VtYtUNRLzFMTmLXxVcgcbZCf5ieV6gzlBLl31NLsSoUWpRDQ2x4AEYyDFL5pNw6zv4IXQKByaDTqhAtw7dksTlIIdUWyo6HdTPZKa9j0oI2FRuqhUtIGh2low==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by PH7PR11MB6955.namprd11.prod.outlook.com (2603:10b6:510:206::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 10:44:53 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9587.010; Tue, 3 Feb 2026
 10:44:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "tglx@kernel.org" <tglx@kernel.org>, "Annapurve,
 Vishal" <vannapurve@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"sagis@google.com" <sagis@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v5 04/45] KVM: x86: Make "external SPTE" ops that can
 fail RET0 static calls
Thread-Topic: [RFC PATCH v5 04/45] KVM: x86: Make "external SPTE" ops that can
 fail RET0 static calls
Thread-Index: AQHckLzT8/BuXpPg6UCd9uBcZ2GO7rVpuWwAgAA0cwCAAQ1jAIAF14OA
Date: Tue, 3 Feb 2026 10:44:53 +0000
Message-ID: <024d685f022684d909e3111874b906e03aa28225.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
		 <20260129011517.3545883-5-seanjc@google.com>
		 <f9f65b0fad57db12e21d2168d02bac036615fb7f.camel@intel.com>
		 <aXwJIkFJw_4mRl70@google.com>
	 <e3feb0224cf2665a71ba6147e4e3e3bb30f96760.camel@intel.com>
In-Reply-To: <e3feb0224cf2665a71ba6147e4e3e3bb30f96760.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|PH7PR11MB6955:EE_
x-ms-office365-filtering-correlation-id: bda8b4fd-f987-47a9-6e86-08de631143a1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VEMzdzdsN1ZuaFNEYnVld2FsYi9zM1ZDQWp3K3cwaVJieEM2SkJYaEY2U2lZ?=
 =?utf-8?B?c0J6VSszckdvaGljM0YwS0xlM29EdU5hblg5L3o1aS84a0dSaHJNb1NSREpL?=
 =?utf-8?B?K2kwZjRRKysvL2EzeS8wQnhpUy84amd1QllsTHV6aTNzZkozTTJhZ1FDUkhx?=
 =?utf-8?B?NkdQYmNNSzVTdTZVd0xGQThKMDVNa0hTMWFPdWNYdk4wYXUrOUtVREw3enZE?=
 =?utf-8?B?OEYzRnQzeUc3YjZ6ZHROd1dZTG11Qm1xeE9xOGk5TUN1UDVOcmY5TnBvb2ZG?=
 =?utf-8?B?OVpkQWVwc1FlWU55cjBUNTVIZVA3Sm1xNEk4WHE3MHBhTVhPNmFybTRrTStI?=
 =?utf-8?B?bFdyQTlJVDhUOWFKVjlkZksvRUNLN3JwRFFHTlZqS0NhbXBaSmw1MWVLZFcx?=
 =?utf-8?B?U1J0TGlTQ05lU3h1RWlHNlVhUnBvdWFnRnd5OHNuWUZBeXBxVi9VbVB2NFlq?=
 =?utf-8?B?Sjl6eGN2WGVMZHdiOUVuTnhTbEFncmFTQXRZSEdmKzlVQWdvTG1aM2U1bCtK?=
 =?utf-8?B?NmsrdXpnMnhpR2h1Ynl3SURsRkxNclFDN0ZEMGI5UG9VdGpZU1ExOUMwRlg5?=
 =?utf-8?B?cHh0NkNGczJLN2xYTTcvcTRmZ0xWcVl3Z3YzdVJNclVRZEluT3NCNGtOU1hV?=
 =?utf-8?B?TUl0NUhaRU5Oei90T0NrSEMzUnBFQ3N5RnBKbVRVRVNDNG5GaTRJcGlXQXZv?=
 =?utf-8?B?dWY1RERNcFpJS25CTUwyNmd4a2lQN25CMk9tL0R1dXlYVUo1dm81SWFKVXU4?=
 =?utf-8?B?YnRMOC9lSVdiOXV3RUkrNEw0enc5VFZHNUc5MS8zU2tZYkp2UCtUNkdGclMz?=
 =?utf-8?B?TFNnOGtRdDFCczA3OG9kVi9nRHR4RlJidllhZmE4eEVjdjB6dlA0aE1sbHBC?=
 =?utf-8?B?QXVzNzhWVktQZ2szSlovTjhydnl1SFJwRXhidkZ3dFBnWElRNkhCYlVFKzZM?=
 =?utf-8?B?enExMy82ZVVTcHhVSmtxRC9kL3IrZzRqY1dtSDhqYy9UbWM5NTllcXBHeUoz?=
 =?utf-8?B?ckhRSFpVYnYvQ2R2UE5mQnhPVGxjOGEyUzdlbjYxcnM3Q3M2UGFZVWNGTDJ6?=
 =?utf-8?B?SG5Db1IxejNOQkZNc1JiZTY4WTNNL2Y1aXhjVklZZ0dvVjFyZUp2OXFUZmZv?=
 =?utf-8?B?V3l0UGt4RmlmSHFubkY4TDEyN3pBbG41MFlKYTYvK20rRmxuOXZjNS9ZcHZB?=
 =?utf-8?B?VXpReHFFRDhybzAzYnZFM0YzdDdtYmR2RlZkcGllSEU2TWU2MU9Ob3M3eDA2?=
 =?utf-8?B?T0ZDbHJOY0F5cDlzenM2NmVEdXA0WktHeGlQdThkWEplZlFrODBxSDA3WEZY?=
 =?utf-8?B?MDJwSXBQN1ZaUWNYbHQ5RnkvTDhCU0JIQmcrU2lqQ09YQS8ya1VLeUR0Q1Y0?=
 =?utf-8?B?bUxVSS9lcXJpRkxtdU1jYUw2NW9Vd3oxcFBZN1BmY1AwNVdnZFJ3OWx6ZVVR?=
 =?utf-8?B?UEcvSXdqbDJmeklkSU80S2RVSUpraDdHb0Yxek5vSTFNSEtZNW1CKzJmOGYv?=
 =?utf-8?B?V0ZLb0ZtQk80YlFhRmZtMTVwTlVYRWZrZlFuc2NWZFB1dHRKdG44bUJtaGFS?=
 =?utf-8?B?UUY5cURZc3ArdGtqODRPUnBxeUwxTWNGZ1NNUXh1TmZGV2E5ZFA4WGlpVWNY?=
 =?utf-8?B?OEVRaG5DQjNOYUp2K0EzdURObWJVMFBQWXBlQmROR1ltckRwdjF2ckpLbDMy?=
 =?utf-8?B?Unl4NERSU2xRbVA1NXdaNG12dlBKSkI2WGhvOW5Eem0rYmdlUVdDTVZHKzEy?=
 =?utf-8?B?N29Ta01OSUR5dkhCODFmTURqdFpIRGRZeFNMR2gzdHUzclNicXB2c0pFQVRN?=
 =?utf-8?B?c1B1b2oyYm1nMXdhT0RsMU03d0R2Vk1VRlJPRUQ4U1lDZVJkUzMrblJjd1M3?=
 =?utf-8?B?RnpNMm9LeXdETnNqTFEyb28wQ1JwMkVsOXZablNaY1RvUHNYQ1JtM1g0c2Jv?=
 =?utf-8?B?Z2tPOHEyVXB1VnJSQ1laSEI1cEsrWU03K3VjU09ndFRudlhSM3M2S3I1dXZP?=
 =?utf-8?B?RnhQQnNIMi9pTnRvRldLbjFQWWpZbEFpS1RCL0RBZ29DVzBnMnNSUHdXUEdD?=
 =?utf-8?B?L2dpOGl5MTllS0hCcHRCOXlaUDE5SHYvOVRHU3lLNzBnak9Fd3Rad3hSOTBv?=
 =?utf-8?B?U0RZZjh2SVlhR050ZDdaUnBOZlZPbFdRODluMXVFUU81V241aTl4TG5vaE90?=
 =?utf-8?Q?bVoPamgSe6n2f1uxvj5ejF8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXpndnNuUTl0Tlo0SVVoNktLazVWSy95ZU9QazFXSlBCd3lvYjZtVDBNZkQr?=
 =?utf-8?B?bWNzbjdjL1c3dnp1THJXeUJ0OEF3U01sNDZscEVrM3RXRm45eFVHZVNJd3lK?=
 =?utf-8?B?VVM2SmQxM3ZyN2Z3dUdLWFRVS29EVWpleko2eFVZTlRGUmQyTE5POHR1WU5M?=
 =?utf-8?B?Z2xSR0xvQkNPYTRSVHJLK2s5SEE1d1JLSXlLODhLREVCOEZBVzBveTgzSytF?=
 =?utf-8?B?T1dpSm9ibU9CMHhwWVptbTdNVEVaVzI4UFIwWEtaSDJaOHp1eFUyOE1lNkN4?=
 =?utf-8?B?VGY3cW9uN09zNUU0T0NSQy83T0hIRGRacjJIMnRmeXpNQTBaYUd3d3dQVVFj?=
 =?utf-8?B?eW5vVzBqSHpMKzg3cXFTTUJnNk5IQ1QxS1ZZVHd5bEVjUXhscENEaTRwcWFG?=
 =?utf-8?B?QVJnOW15SVZ6SkszVnBncHpZb0VGKy9PK05MNXJ2Tm1WVDVXSUJKaUZYUWE4?=
 =?utf-8?B?NHMrNU05MW1BNUlqVUxvSDVGcEFtQUpzZmUrVms1UXNUZUlpRm1XKzJJbzdM?=
 =?utf-8?B?TlVSWGN5QlFFQmRjRnRxTCtMWUdGRkRFRDBGb0s4by8yTzI3VzZWTlM5QlBi?=
 =?utf-8?B?TThpUDNOQ3Z3MmN5a1o1dER6dXI3K0V4WEZwZWttU2dJMDBZTk1OLzhuRlIv?=
 =?utf-8?B?WldoQlJnY1RnQTdBQzdOd1hIZ1ZEaHBudGlndHVhME9vczIzaTNNRXhqNWxr?=
 =?utf-8?B?UGZPc1BmNU4vTFRoME5iODk5dWdQUzkyaDRZV2x5Qm9wWUNpQ0FIVURtQ1F6?=
 =?utf-8?B?bEJYa1E4SExOQjJCc2hxOE4wZ3EzZFJUQTF6R2NIQTRkeTJoTjI0SVlaODhG?=
 =?utf-8?B?THJLU2hLWFJqQUhvakdOQTJzS3JvUXI3UGFQZW05aUNnaCt0ZmNQditSTHhz?=
 =?utf-8?B?ZnBDQ3I2cmlWTmRqMTF5d0s0cWhnamYrK0Y0UDYyTTV0SXhiQjFWQ09wTzJo?=
 =?utf-8?B?UjMyT3crK1E2RUNpYUtaS0UvS05CeTRPMkhkSTA4L2FKT1hOYm9uSHY1ci8y?=
 =?utf-8?B?VEhWcjE3UzNoUmgyaGVra291UUkxcGpueTVoVldBbWZ6VE9yOGwwR24xNmUw?=
 =?utf-8?B?cE5Da1VwaENMTG5UNytpdmVNYzk3RWJGMmVLSzZOR09PMlYxV0pvSjRJanVu?=
 =?utf-8?B?NnZNeGlabjFuc0l6ZUJyRlU2LzBYSFhpYkQwUGZvSW9JSCtXdURicmx1UVdD?=
 =?utf-8?B?bnFvQ29vdTJUdnFHZE5UUzU3dVNxSWdGRzc3Vk9wbkwxT0pOYy9nUlBSZXYx?=
 =?utf-8?B?YldZV2hjNkNVNTdwWGZHV2RaM2FZa05zbkZDZjJ0SmtTZGZpeWswWWJwTHNj?=
 =?utf-8?B?QmNnWG52bEt5MGEyUVF3b0FlRjI3QUI0RlZ0c0VtVlRNNlBXQzFFdFE0WjMx?=
 =?utf-8?B?V1pudEpvbmFjdGRjK01wRDlNL01JdEs0VDFGdDN6YjgxZzhhTGF2eGRheXFX?=
 =?utf-8?B?TDNncEdhWXlSNGZoNk10WHJZTWVpNllXaks2bURXSDB5U0psS0VxdXY2N21o?=
 =?utf-8?B?bGFzdTBJRWh1M3RWUVRyYWZScnc1RG1JejNQZFQxd1N6Z2xmRERKTmI0ZEF6?=
 =?utf-8?B?VzFmQU16enBBUmZRZ0trWTZUNXRDTE92UHFVVklnUjhJTjdwekozc01kbDJm?=
 =?utf-8?B?TitIQi9taFlpeHY3TDNJM2ZvQm5na3RlbVM2S1ptRStXVUZ1VzJQQTluNTkv?=
 =?utf-8?B?Ni9hdVltSTRZczUrcXNVRlM1enUwMkw3QWtSOElmU21zREMrRHVTclJvSmRU?=
 =?utf-8?B?M01vbGpDMDZzdVZ0K1ovTWZjaGxMMHdBajJDb1dCRExiR2tzTFlrWHM1WXlB?=
 =?utf-8?B?bHVQcWVOU1FvWlAyYnRkR1VPMFMrQUw3a1BVQmdnS2lGTjZyVldQVVZsUGZV?=
 =?utf-8?B?N1JpdE1WYkJWNkZJbHcrdlpHV0dLQWZPbkE0VG1yYndvUG5peE8zSExoVUkx?=
 =?utf-8?B?ZlF3R2NJWmZiYlFFc1ZPelBoNWdwODA2OEhvbHBENUxEUHhTOGwyYTFvT2lK?=
 =?utf-8?B?VmJKR3hZMGZtdTVDVjg0U3NEYW5BdWRVTkdYdnFtLzkwYk9yb1lXeXF6dk91?=
 =?utf-8?B?UDJEVFd4NFpDdjlwbTVPOWxGZnFwZFlyTE50YnZ5cjFSZnVhSytTMUdEZjdE?=
 =?utf-8?B?NDJuQ3hQdERBTm5ERnNXYWFQL3JwTjM3ZmZlYVo2Qnp6TTdlS0Z2UWRrNXZ4?=
 =?utf-8?B?UVBQRkZSYUUvb2dKejhNWU11dGp5UjZHeWwyZlhNT0MvUWh3a2VtUE9Xb3Z5?=
 =?utf-8?B?TEhjZzI5cUdvN0NHTUVWeFl0RllRalp6blFKSFhXVzlTZy9BRmF6VnVidDgw?=
 =?utf-8?B?VllLbSt2ODlXWEI5aW1oajl6RFpLRThrZWxQWldDdExVT3FZaEoxZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4EEADF94C585104E9349BC35B6E1AF00@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bda8b4fd-f987-47a9-6e86-08de631143a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2026 10:44:53.2669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h0kpARsbqbTBScuFfTBulIIZlubWhsQW9LrR3MQ/3YyuRPqUSxrvM5YZAToG1J4DeQZaAHIVzg2si2pOYYpJ1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6955
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69990-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: C9898D7E7A
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAxLTMwIGF0IDE3OjMyICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gVGh1LCAyMDI2LTAxLTI5IGF0IDE3OjI4IC0wODAwLCBTZWFuIENocmlzdG9waGVy
c29uIHdyb3RlOg0KPiA+IA0KPiA+IEhtbSwgdGhhdCdzIHByb2JhYmx5IGRvYWJsZSwgYnV0IGRl
ZmluaXRlbHkgaW4gYSBzZXBhcmF0ZSBwYXRjaC7CoA0KPiA+IEUuZy4gc29tZXRoaW5nDQo+ID4g
bGlrZToNCj4gDQo+IEkgdGhpbmsgaXQgd291bGQgYmUgYSBnb29kIGNoYW5nZS4gQnV0IGFmdGVy
IG1vcmUgY29uc2lkZXJhdGlvbiwgSQ0KPiB0aGluayB0aGUgb3JpZ2luYWwgcGF0Y2ggaXMgZ29v
ZCBvbiBpdHMgb3duLiBCZXR0ZXIgdG8gdHVybiBhIGJ1ZyBpbnRvDQo+IGEgZGV0ZXJtaW5pc3Rp
YyB0aGluZywgdGhhbiBhbiBvcHBvcnR1bml0eSB0byBjb25zdW1lIHN0YWNrLiBTZWVtcyB0bw0K
PiBiZSB3aGF0IHlvdSBpbnRlbmRlZC4NCj4gDQo+IEFub3RoZXIgaWRlYSB3b3VsZCBiZSB0byBo
YXZlIGEgdmFyaWFudCB0aGF0IHJldHVybnMgYW4gZXJyb3IgaW5zdGVhZA0KPiBvZiAwIHNvIHRo
ZSBjYWxsZXJzIGNhbiBoYXZlIHRoZXJlIGVycm9yIGxvZ2ljIHRyaWdnZXJlZCwgYnV0IGl0J3Mg
YWxsDQo+IGluY3JlbWVudGFsIHZhbHVlIG9uIHRvcCBvZiB0aGlzLg0KPiANCj4gUmV2aWV3ZWQt
Ynk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCg0KTWFrZXMg
c2Vuc2UuDQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=

