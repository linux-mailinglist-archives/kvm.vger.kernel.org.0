Return-Path: <kvm+bounces-34744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A0C52A052B6
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 06:41:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EACA1888D06
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 05:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 140331A23B9;
	Wed,  8 Jan 2025 05:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eecjOxTj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7217810E4;
	Wed,  8 Jan 2025 05:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736314904; cv=fail; b=p0rloLQfepYwL8NPrxdAPU7UW0cIVGqLg/pzoPcmuGYWV/U8WqNrcOyPF8n4k2UDP0ko8Lhh9phkLYgNAGbCZamGb+Hr0FAp9NfC4wJk8WOftLZAxQTrSCcd86FpCGQiysJqVw0R6iWdWou5bt18IOw74e1iz5CkXTUZ/21ovqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736314904; c=relaxed/simple;
	bh=jkw5tRebh8+HVdtO2GJybm2/pxRUKsATwggtozKsFYg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FJ5Oe1xd5N+TX+VTpJBKp7MVPGb6u1xgJ6J5GtYdsMKLkG2c+MNdzQDEhx5JJCD0NlNVF/PIRKkgXMTP+Uds0rsXTFbADYu9JoKFJpxcOuqYXX2SSww2rpOofbXI487Xy/2ayyFqIAzjXjDGFEAvwaVyevXjkbj2ZyeUs2nDBYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eecjOxTj; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736314902; x=1767850902;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jkw5tRebh8+HVdtO2GJybm2/pxRUKsATwggtozKsFYg=;
  b=eecjOxTjitD5eXMvWCXNifkSrC0p/9LoCSkgSzMROv7qAKYMGNfr51Zw
   41ZfmT24l3MSnj3VqNMFCnTvlen9cQpjUb3ugI9rPxEk5If89fMCdxkF8
   DypmxqXNGml3PTz2QyaboFMOCHWq0Vn/zhMU2GmrW73BUePtFGmt//cPJ
   VGEzrDaghmMgsQp0iuWssOx3VcGukPouEqwHm66CpTQzQKCAiDw2dTzbK
   2l3PWLeAQe7g4ILJopqZz6I0P7x8otCcyLDkpXEPLjmolCPe7W5YxnvER
   HuHhopJeX6Ok/Lz9Cldrk8Xpb8E73+KfOLL8icGzlbR9pA0v5z3OHtYHc
   g==;
X-CSE-ConnectionGUID: REBEKOY6TR+iJfI2t4gFqA==
X-CSE-MsgGUID: Z3wUA2RLS9+IyMyFQEzyeQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="61903060"
X-IronPort-AV: E=Sophos;i="6.12,297,1728975600"; 
   d="scan'208";a="61903060"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 21:41:41 -0800
X-CSE-ConnectionGUID: 58nXsE/TS+aLM9crPUdKgg==
X-CSE-MsgGUID: ari1EjTCTlWyQNMzJKTCkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="107020096"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jan 2025 21:41:41 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 7 Jan 2025 21:41:40 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 7 Jan 2025 21:41:40 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 7 Jan 2025 21:41:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N/7YfdOuqaRORqdq1J6H3BPSiL+X3Tgetq+hVHAJ8vdYAvsZmUn36GI4gmgNgaLUn9mu6zirnHnACwBMZEB3OU/MuvkX0pDlfe/n03EDYCiPf4LroV5dGBuyNIBwtg0LiV2SERA2izO8NrEYL17oLiRjCZdAH4fMlCu+kdTRzwdkTa9pgJW8O+AkQZb+OCGIwb37okHpXpA+99BR8yCeFokJwJMKtNDbhoALsCmiO55aGM90L4czXV8u/2JbZ5J9Y1x18gf0a6urmk6akRWfDBv/rnEwXII/XlZ5C+OD20jD7QJwJ9Ye0DsCOIwcZpKgp/bI5UNtsqWkK8uWn+VmwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jkw5tRebh8+HVdtO2GJybm2/pxRUKsATwggtozKsFYg=;
 b=H2tmkgu7Iso3c9iz9rnUDucKtsIy4rMdCUfgADEA7Z94GOayY7omVn3nTSyzliJL13wZiseBHs0zg5npmxyfew2GC+ihrWXnTn3Sf2X0G7b/DwEpwpP1OIoIYvp5i6+wuhq3n0YF439dwDEef2xJiHktbTUiOrEcGawVM3DTqKnel3Lcjh+ajU0gYp8S0EzF/qia77b1dYtc6JzzXTotDBWSfMug8w/0Py51mEdI4JLxu+Xetos9C7ZgePZY3d31INBDVZWrmZccQt7rx/lCzFF3TAZnUK4YcYvbme5PPnaOqvW9j0g2vIBW6mCYVQlrBoI9ltU4Pvyk38ZmI0M9jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB8232.namprd11.prod.outlook.com (2603:10b6:8:15d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Wed, 8 Jan
 2025 05:41:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8314.015; Wed, 8 Jan 2025
 05:41:39 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
Subject: Re: [PATCH v2 16/25] KVM: TDX: Get system-wide info about TDX module
 on initialization
Thread-Topic: [PATCH v2 16/25] KVM: TDX: Get system-wide info about TDX module
 on initialization
Thread-Index: AQHbKv5Dxo2whyIlq0qY+Gnqn41gzbMMlZsAgAA0XgA=
Date: Wed, 8 Jan 2025 05:41:38 +0000
Message-ID: <4d4ae650a583dae843a12092e596e62e1e67bf46.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-17-rick.p.edgecombe@intel.com>
	 <Z33kIrc8/8WOn3sL@intel.com>
In-Reply-To: <Z33kIrc8/8WOn3sL@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.2 (3.54.2-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB8232:EE_
x-ms-office365-filtering-correlation-id: b1f8f582-d2d1-4d3e-5b53-08dd2fa71f6b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U1NVaGxkd1UzbFNWREJXUEVtMjhTZnBCaU5PV3gxc2ZFazZ1SXZ1Q2s2Nzdo?=
 =?utf-8?B?V0dYQVYvbDJLQzBub2NxOFRrN1RsSUVkblBYZi9OZTg3eWxZTDhDSXZnM05m?=
 =?utf-8?B?Sk5QbU1HdXJXQXo0S0h5UmJINW0rZG5ETGlHM1JIQVdvaWlqQVpDUnZHc0Fv?=
 =?utf-8?B?RmpvZEJOOHc1dFprVkYxMjFBYThRTXVITmY2Wkdjc2NwclFNcjlMSXExQisy?=
 =?utf-8?B?MGkwWFkvYmN0M2pXL1d5OFpmSVVUcmRiNmk3aGlDQ2ZhOEFvVnZrVEhhMHd3?=
 =?utf-8?B?dDVhNWF0RzByVU93L3BFYnV6ME5DNHhCeU5FYTlLZ05mbXFVbHUzL3lDZmJ6?=
 =?utf-8?B?RGdmUHJiQWtyR2grYmRYejFOTE9kS3RodVNZUVZMZ3Jtc0RKMVBCeWJTU1Zi?=
 =?utf-8?B?L0F3dWJPdGhSV2grRjdMQUkwaS9jalBzR2RCM3UxaDI5NVNPNGxwOWxjdFVw?=
 =?utf-8?B?OS9OUEJCQVlTQXhIR3V2YnlkU3BFeGl4bnZLZm9LUStSbUJ6cWFOWlUyWWlF?=
 =?utf-8?B?c0NrQ2sxMTNuYlZTNFNxLy8wN2J3VGZYbFdPSzdPL1AzZUhUWEFXNGJna25F?=
 =?utf-8?B?K0ovVHpNT3NvQzEzS3JjeVRVak1IMTloYituK04xL3BPeWJlZXE1NzFJQ3E2?=
 =?utf-8?B?S1dtNE9pWXVYRndmL2RuaG5jdnowaURMTnRrRGVBZWovTFcrWHdoTTRXY29K?=
 =?utf-8?B?bStNSUJaZnpPT1hZMjNiaU1EOFFVOEVFK0ZUTlFRWnZ1NUZTNWt4RFNHcVBr?=
 =?utf-8?B?MGJDSkdvWFdMVlJaaFBDWVZUazFMY1UwUlg4eUJlMVA0YTNRamc0RU8vQlMr?=
 =?utf-8?B?ckI4TzUvdEFHRzkwZURQcXdlR2dlSm1NWU00L0FLSW5jd3IyUUJrVjZRNUhw?=
 =?utf-8?B?Uk5hNVFnbXZmeEtheGFYamgvUS9OR0Q0Snp2YTJmT3YxQm9tVVc3WnREYU1O?=
 =?utf-8?B?Rlh1UzNDTU11V0Z0Y3FyU0kvdHJGWU0vUy92T0RLVHY0K0dLdWIrV0I0V0JN?=
 =?utf-8?B?OUUycEluaG5hZDFwL25xTzYvUTdZVm9XNExDOXdMdldRVUVlTFlHck5oWU9o?=
 =?utf-8?B?ZVFNWlF3S1B5ZHlENW1tZVkvb2c4T2ZId3RhYnVKSDk3QVpQM1JzMjJ4ajFI?=
 =?utf-8?B?enNLdVBkK0tTRTU4Tkh2ZTkzZjZacHFpSmM2T0djazhYaThwTFdwQzRQSUVk?=
 =?utf-8?B?UnkxcnJHTTBYRUNCMUlpVHFXSis0OXE3eGNpVFhnN0N3ZWllaXlpS2NycDEy?=
 =?utf-8?B?VFhVb2ovdTVQcmk5N0xXcVB0L3FiRy9YM0ZmTnNrWUVPS3IvSlR4eVppRElp?=
 =?utf-8?B?L2g5S0k5Z2gvSENHRDg1aUdXNWtTZlZpTVI2amlRWW1Teit0SkJ3SUlDendo?=
 =?utf-8?B?NXNkZDRjWEhBLzRpVmRhcGR1YklTWDA3NFpyS3ZtUXJtYjdYOFZmS29xaHhH?=
 =?utf-8?B?cEplYjEzY3NJM0lFUysvWURjTWZtZlY5QkttVTZyWFkzTUozVm5nMWhmZUxE?=
 =?utf-8?B?M0JNY0Y4bWtFZURzeHMzYzhhZzVuenl2ZzJGVUJ3ZFVORDNyUGQ2UTVaQkMx?=
 =?utf-8?B?OStEekh6L2pNVUJzTVRLSStyQmZmRXQ2V0g2VTRsNkxuQUdzT3BUYkhUNVpi?=
 =?utf-8?B?Z1kvR3htT09vL0NZVVRRWitteVM4eUdSUGFPL1l0NzZQbXM3dFhEcHNWYzFW?=
 =?utf-8?B?VGJrdnVVYnJUL1VPdWRCVkVVRGZwNlNEcmlGeXJKYlM3eE9LczZTdDFDSmJj?=
 =?utf-8?B?UlhlVGZrSXd6WWZrZ1pKTmpUU0dzL2I2UGt5K1p1NnRjcjJuVVloTFlQV1gr?=
 =?utf-8?B?L2tCTjZiand6U1FmTlo5a0xRQlRkd2U3WU1CWmlyR0YydE9aTzJ0aDFmQ2xl?=
 =?utf-8?B?dTV5WEQvWUwrVGNZQUdTRFR3bWhjM0VrVDl2eGJoTEtYVXZBVSsyWjZ2Q2Ju?=
 =?utf-8?Q?jGn43LsycnpNRFCxkIFcvHWu5cdmecpF?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkpveUNIVURHS3B2TEhnUnExc3hLUDVBczY0TzVqcXJxaXFvQzQ2M2J1bk9K?=
 =?utf-8?B?WGh1VWo2T3AzS014MHRKMEFXcFl5R01aMW9Wdmp4WXRwL2Q3R1RCbTVseUZ0?=
 =?utf-8?B?T1dDZlQzdnZUQVlDZG83K1VWUGVyR3JjUVRtcDlZamZEK2FLeFpXamdnYVJV?=
 =?utf-8?B?K3VoNXBuN2oyaysrRXRVdS93WDgyanhxSElTcVhGNkJ5UEFOQ1Q5alBsM1lM?=
 =?utf-8?B?anRoRHVnUFhwcGk3bkI2SmQwZi9mWUZLc2dwOUFCV21CRWdGdHEvU1lHSVl3?=
 =?utf-8?B?T1hpU2U0czBxTG1Ja0RHQnVacHVucU0ydTFGRERERTVHTVd6UmwvdlNEMGlU?=
 =?utf-8?B?UjdKWEFYakJTbU5xUlRrZk1rcUR3VHcvWHppamUyTWZNT0lWSVQvcncwTnVY?=
 =?utf-8?B?RDcrTDBkV3ZlRzJaVUY5VlQ0SndVNWZ2eVZvU3E0MVFGMktuZmVlOHFpYUxP?=
 =?utf-8?B?ZkxBdmNNRnUxY2NUYUJ2WHJENXdsSk9YNmFGUmdqTVJpZFNVcGdqeVk3ZnZ3?=
 =?utf-8?B?anE5d0RQRUsrenVFNlZnakt5YnYyc1dWM3h3eXhVckE1RVlrZHIzdmtOSmZo?=
 =?utf-8?B?bHc4N1V5RVlyZWtId2NkQzl4R0QxTlZYa0txc1ZMQVUxR2J0R0pCL3A5SjZY?=
 =?utf-8?B?allIemFOZHZVK1piUjdIV0NIaHZaUVFHTzkyOWtwd3BGWkwxRXNkSU5uZmtE?=
 =?utf-8?B?d290T0VBUnFpY2d0SFJhZ0Q3bHdxOWI0RFNobkZMYkl3NkFGRmN4QTZRclh3?=
 =?utf-8?B?dnYrcFBEaW12TWtONWg1ZW9NVGRCSEJiSUFKL3kxOElZWVlXaHJqaHo1RUFN?=
 =?utf-8?B?QmV0Y1JNRjJpeDE3SndqbkJLWFBDbHZaZHBsZldqWlVlb3I2WXIzVSs2U2hh?=
 =?utf-8?B?SUZnZlhxeEd5S0VmVUZsa21pK1RuVTNhUEhJR2JBWXJyRS9EVUNMUG53VWtK?=
 =?utf-8?B?QWo4U0lhaGxFVVhKcDNudDY5cnJaZm1uMXlWOTB3WGJMSUU0VXdFeEFNWTFj?=
 =?utf-8?B?dUtkcXJsa0krNFQ2ajBOZjdmOWlGdlhPS0ZFbytTUG8rQjlBYzQ2dWQyZDJy?=
 =?utf-8?B?bkdITmxLaEdWU0kyQU0zQXB3MCtGWkhtVWFPMW0vV0dlUW82WDR2emROUXBR?=
 =?utf-8?B?S3lhSGxCWEVlaC9EK0Vsa28xRC8yR1orb2NkRWxWOEZOS0owRmhQZVB4OHhO?=
 =?utf-8?B?TytKb0VTbVZHeGRLbGVhNjVWZzZCQzlxMk5acFJjQXJiK2t0SEsrYVdsdGFF?=
 =?utf-8?B?REJVdXJWTU85VmRqS2ljZklHZ0J1VmIvcldGTjA3V1dSZjdvU2dldGRGUCt5?=
 =?utf-8?B?cUVSdEt1ZlpvSkljdGdEYnozTml5SEVLcDNOZG51OVdJem1lanZybmJHTVR5?=
 =?utf-8?B?ekMyUE05NS9VMTdMK1pzM2dIRXVpTERaTWVlckFTSEpacVRnMFF4QVkvM2pt?=
 =?utf-8?B?S2I0WjBrdlpkTzExSERCNzRYOXpTUlRYczB4N20yN3J3c1BkcVNFdE4zRE9X?=
 =?utf-8?B?TVBPcUtFbHh0M2pIUE91QVZ6VjZmSlJKaUdaOGhCaDJhVHJjR25IOC9XZmRM?=
 =?utf-8?B?V3RkMVZuOU1CNDVBaUZOVitxY3M2eitTeEZvU3lGci94MmpqaExDRnl5WXo2?=
 =?utf-8?B?dGhwRWxRNjgveEppQ3c1UnZLb1NtdEh2SW5VbUR4U0grOHo2d2wzNm9FSFJE?=
 =?utf-8?B?cnpycGlnNjdkcVpUa0VFeHZyR3BPK2l1L3RZYzFoOFdEbTh3bm9oMjFqNi95?=
 =?utf-8?B?czQrUUpZVlJHeHozTUdLR0dRaGwvbTQxZmZYcnQ3dUJReTlMU3QwQnpaOWVO?=
 =?utf-8?B?UnJPRVBqaWZVVGlWMmlWY2VSVW52RkJ4ZXE4WklkMkZSS1FrazlNQkJCNXd2?=
 =?utf-8?B?bmVuSkxZdHJGOXVJUkJxWUFSS1gya0lib0J2Rnl4NGJ5U3VRV2xIdm1pMDlm?=
 =?utf-8?B?NExnRjRIQjlITWxYTGdDTnBpMUZydm5SWi9GWHBTMyt3MDhJVjkvaDcwb0lm?=
 =?utf-8?B?cFB4MlFMb0pGbE45Y0NURHdXUnptMjhlMlhWNnhWbnI2QmFrb2xBelQ1QmNs?=
 =?utf-8?B?Z1U5YldyYjJyQjlxMUhFcnpQZkVtQ0lsV0djNDhsR2gwbW9ONldEcVFhMVp5?=
 =?utf-8?B?RFpoWWZWd1c0OU5OTThMcWdWeWs1OUdQVnhUTlRFNDdtUzNuVm9idGp3c3BQ?=
 =?utf-8?B?bXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <316EB63D20B0984587E4B4D8E0F3EA22@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f8f582-d2d1-4d3e-5b53-08dd2fa71f6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2025 05:41:38.9259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: owrEr5hNc2LpBBbkZ66W7bMrJJkusys4xyWh+xl0y2KP06vkrAJDy9JjgvB93l1DUCh6o1kI7BksLodGOuENog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8232
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAxLTA4IGF0IDEwOjM0ICswODAwLCBHYW8sIENoYW8gd3JvdGU6DQo+ID4g
QEAgLTE0NywxMSArMjc4LDE3IEBAIHN0YXRpYyBpbnQgX19pbml0IF9fdGR4X2JyaW5ndXAodm9p
ZCkNCj4gPiAJCWdvdG8gZ2V0X3N5c2luZm9fZXJyOw0KPiA+IAl9DQo+ID4gDQo+ID4gKwkvKiBD
aGVjayBURFggbW9kdWxlIGFuZCBLVk0gY2FwYWJpbGl0aWVzICovDQo+ID4gKwlpZiAoIXRkeF9n
ZXRfc3VwcG9ydGVkX2F0dHJzKCZ0ZHhfc3lzaW5mby0+dGRfY29uZikgfHwNCj4gPiArCSAgICAh
dGR4X2dldF9zdXBwb3J0ZWRfeGZhbSgmdGR4X3N5c2luZm8tPnRkX2NvbmYpKQ0KPiA+ICsJCWdv
dG8gZ2V0X3N5c2luZm9fZXJyOw0KPiANCj4gVGhlIHJldHVybiB2YWx1ZSBzaG91bGQgYmUgc2V0
IHRvIC1FSU5WQUwgYmVmb3JlIHRoZSBnb3RvLg0KPiANCg0KWWVhaC4gIFNlYW4gYWN0dWFsbHkg
cG9pbnRlZCB0aGlzIG91dCBiZWZvcmUuICBJIHByb3Bvc2VkIGludGVybmFsbHkgdG8gZG8gYmVs
b3cNCmNoYW5nZSB0byB0aGUgcGF0Y2ggIltQQVRDSCB2MiAwMi8yNV0gS1ZNOiBURFg6IEdldCBU
RFggZ2xvYmFsIGluZm9ybWF0aW9uIjoNCg0KLS0tIGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0K
KysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KQEAgLTMyNzQsMTIgKzMyNzQsMTEgQEAgc3Rh
dGljIGludCBfX2luaXQgX190ZHhfYnJpbmd1cCh2b2lkKQ0KICAgICAgICBpZiAocikNCiAgICAg
ICAgICAgICAgICBnb3RvIHRkeF9icmluZ3VwX2VycjsNCiANCisgICAgICAgciA9IC1FSU5WQUw7
DQogICAgICAgIC8qIEdldCBURFggZ2xvYmFsIGluZm9ybWF0aW9uIGZvciBsYXRlciB1c2UgKi8N
CiAgICAgICAgdGR4X3N5c2luZm8gPSB0ZHhfZ2V0X3N5c2luZm8oKTsNCi0gICAgICAgaWYgKFdB
Uk5fT05fT05DRSghdGR4X3N5c2luZm8pKSB7DQotICAgICAgICAgICAgICAgciA9IC1FSU5WQUw7
DQorICAgICAgIGlmIChXQVJOX09OX09OQ0UoIXRkeF9zeXNpbmZvKSkNCiAgICAgICAgICAgICAg
ICBnb3RvIGdldF9zeXNpbmZvX2VycjsNCi0gICAgICAgfQ0KDQouLiBzbyB0aGF0IGZ1cnRoZXIg
ZmFpbHVyZXMgY2FuIGp1c3QgJ2dvdG8gPGVycl9sYWJlbD4nLiAgSS5lLiwgYmVsb3cgc2hvdWxk
IGJlDQpkb25lIHRvIHRoZSBwYXRjaCAiW1BBVENIIHYyIDE4LzI1XSBLVk06IFREWDogU3VwcG9y
dCBwZXItVk0gS1ZNX0NBUF9NQVhfVkNQVVMNCmV4dGVuc2lvbiBjaGVjayI6DQoNCiAgICAgICAg
LyogQ2hlY2sgVERYIG1vZHVsZSBhbmQgS1ZNIGNhcGFiaWxpdGllcyAqLw0KICAgICAgICBpZiAo
IXRkeF9nZXRfc3VwcG9ydGVkX2F0dHJzKCZ0ZHhfc3lzaW5mby0+dGRfY29uZikgfHwNCkBAIC0z
MzE5LDcgKzMzMTgsNiBAQCBzdGF0aWMgaW50IF9faW5pdCBfX3RkeF9icmluZ3VwKHZvaWQpDQog
ICAgICAgIGlmICh0ZF9jb25mLT5tYXhfdmNwdXNfcGVyX3RkIDwgbnVtX3ByZXNlbnRfY3B1cygp
KSB7DQogICAgICAgICAgICAgICAgcHJfZXJyKCJEaXNhYmxlIFREWDogTUFYX1ZDUFVfUEVSX1RE
ICgldSkgc21hbGxlciB0aGFuIG51bWJlciBvZg0KbG9naWNhbCBDUFVzICgldSkuXG4iLA0KICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB0ZF9jb25mLT5tYXhfdmNwdXNfcGVyX3RkLCBu
dW1fcHJlc2VudF9jcHVzKCkpOw0KLSAgICAgICAgICAgICAgIHIgPSAtRUlOVkFMOw0KICAgICAg
ICAgICAgICAgIGdvdG8gZ2V0X3N5c2luZm9fZXJyOw0KICAgICAgICB9DQoNCkFsdGVybmF0aXZl
bHksIHdlIGNhbiBqdXN0IHNldCByZXQgdG8gLUVJTlZBTCBiZWZvcmUgdGhlIGdvdG8gd2hpY2gg
aXMgYSBzaW1wbGUNCmZpeCB0byB0aGlzIHBhdGNoLCB3aGljaCBwcm9iYWJseSBpcyBlYXNpZXIg
Zm9yIFBhb2xvIHRvIGRvLg0K

