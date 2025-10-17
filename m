Return-Path: <kvm+bounces-60431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E382BEC5D8
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 04:46:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id ACAEC4E0578
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 02:46:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FEC726E6F5;
	Sat, 18 Oct 2025 02:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JIMP85e+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F112421FF26;
	Sat, 18 Oct 2025 02:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760755601; cv=fail; b=DFtd7uPkwms0TDtpipJ+aQwmDWSzhqP+kWjHo9ynYnDyaZq2m7KvpKDMeirqxf8OMzLGEXjoZiJc+2ZdYiyX8q2x3mAb2rTvbF1IAwsMmWFQ0LxbLmvIQXiSFvISpwCohNitm1N5RcKY6UhYjbblvCco2HUg6uwEbyeAOBocmzU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760755601; c=relaxed/simple;
	bh=H44YqcQ1o8il82T5IS12Iv+0s2ZJKXHE2Qg0cy24V50=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FP+VC2pkYLBc0t+o5kpOkSExqR2YcK7gtROW7xMqnXT3GFUB7W0qkEDGDVdf8MvVmUmaLZjMRCtp338vcTTUfJJ2IYHzznww7O7Gz0zOdyM/e0EBxXfy6WFQWGnoQimXGUbQ1kFqhWA42qQHkopc8XIBddTuhbGzAWn/i1aV9xs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JIMP85e+; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760755600; x=1792291600;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=H44YqcQ1o8il82T5IS12Iv+0s2ZJKXHE2Qg0cy24V50=;
  b=JIMP85e+cE+g8LhPhGhv9fIRP31opiKr9V96O7TwFZX4ST29lnA+DxKR
   KTBIBGxL3TW1PY/AKSx73XfWF+OX9fdxwbRkTs1vo+XFtmRgsnoVwBMaZ
   zLsv1WB7r33ivCNrgmuRu0e7vo3DW8Ijogk+xR0jSN+CRDaPdHKzEQyQT
   RyC3Ywa6zPn28bz9fGOYc3e4xImLpXFd60KjJ0HGf0H10Hdf8sshelwtA
   oMx2h0xYB0e1NzcffoNBFh3n11fH8//qqzcjeV5ydznErMv8Euw9xLmPg
   HDR3RlAOrNxuVpOw+eiKXptHOay4kFRIRywGvImPDSh6KjTH1QUtDrsbx
   A==;
X-CSE-ConnectionGUID: PKGtWvS3SwyIxPIzbpOyDw==
X-CSE-MsgGUID: rLRDiyozTUqOtQwmRY8isw==
X-IronPort-AV: E=McAfee;i="6800,10657,11585"; a="66837846"
X-IronPort-AV: E=Sophos;i="6.19,238,1754982000"; 
   d="scan'208";a="66837846"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 19:46:33 -0700
X-CSE-ConnectionGUID: rvKQNbpJRKKWLroBt1GmpQ==
X-CSE-MsgGUID: 2zW7oanDS0OJHCBy5GRCtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,238,1754982000"; 
   d="scan'208";a="187289258"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 19:45:41 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 17 Oct 2025 13:34:14 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 17 Oct 2025 13:34:14 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.18) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 17 Oct 2025 13:34:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bDarnffVvXv4gNEiSOTmh4nRDTh70ccHsCRId8dKAItXTm34DgO1Dp4iLnHSLTovPzNPhhWKLgM2mQz4N2MWNauxWvSQrKjHJtRWuuvvGPc21jVao8TkKV0hHp91teGR++DRaiSjECuNniwHjW0Ui6utfWlHPyR+GtYZukINUx6917yVj79Mc4Eb7iPmQTxVNyHsd7OJFRPyslMChKne5v8Z8Ovtjd0azmHTP/+9jZqkNUKNMD+1CcYOW7xYzxL5jru3crPRqTNLgbNbU4I4/0FIHMB/7Wi4sI9uGgD6SCQP9VljGJ+0mmPtNLW3F1UnKGn/DF70CTo+SorRt/GJ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H44YqcQ1o8il82T5IS12Iv+0s2ZJKXHE2Qg0cy24V50=;
 b=VBWiJfQFTpWF3sjOweWkqN66Lqc7oqqdF20iaDsK09OcWlW1VOLsxU1898Gww/kl7Akg4cr63Hm4EP4LcU+hr+dlt6hlbl6zUoaGWz1jToJBgBVjDmbUAs8bJ6Rx/uNmJJhuCk+JjZi8vUqF78onYCwefOK2enHPGcQg8aCj0starvfZxsAQ5H2A2wIwWZ+iSGGFCZHY+AepLKxC99GG3otL2YJbdFunFIlWagtVScWSue0kOPagyRnc9nH1GsAWCLV9M4qzz21yRji7qsZzwP8bQ2VGYCcM+RaOxr4211hyJ7cLe6Ejk9dpJNh98h0f99Mzmn/IciuM/dp5lkYjSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY8PR11MB6892.namprd11.prod.outlook.com (2603:10b6:930:5b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 20:34:11 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 20:34:11 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [PATCH v2 1/2] KVM: VMX: Inject #UD if guest tries to execute
 SEAMCALL or TDCALL
Thread-Topic: [PATCH v2 1/2] KVM: VMX: Inject #UD if guest tries to execute
 SEAMCALL or TDCALL
Thread-Index: AQHcPsnIDCY4Nspo7E6rq2esTUoC+bTGKtiAgAAjfwCAAH7bAA==
Date: Fri, 17 Oct 2025 20:34:11 +0000
Message-ID: <f4509334310ab347d49a1fc45df5053050b70a3f.camel@intel.com>
References: <20251016182148.69085-1-seanjc@google.com>
	 <20251016182148.69085-2-seanjc@google.com>
	 <2d00cefad4a5316357e76db7292e8d7ac2793eb1.camel@intel.com>
	 <aPI91kOhPAK_Bkla@google.com>
In-Reply-To: <aPI91kOhPAK_Bkla@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY8PR11MB6892:EE_
x-ms-office365-filtering-correlation-id: 2c9662a7-28dd-44ed-9654-08de0dbc878f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?aktPV01PUGF3cmQ0c1JkS0phaDE3QXovS1JRakpNakNkeUM5L0tMc1c3dUth?=
 =?utf-8?B?b29SSFR6Y1NqS0JIL2RsMjVVaGVuTjFSRXZrOE9rbHJRaExmMVlkSFlBMzRn?=
 =?utf-8?B?cVB5K0ZQN3J6aWxkSVRsaWlqMG5Ua0w0Mys4OHAzRVdENmxnSno5MzFIQTZi?=
 =?utf-8?B?ZkdseWVWYkNkLzNDODVsZVdTRmxYa0dTd3JsdEMxcVVpK0dxS1VHd2JkTmc2?=
 =?utf-8?B?b0dBUExIQmZMcE42NTcyL1UreXRJMWcrcm5zVFhNTTdMN2grNEFxdXJKYkNX?=
 =?utf-8?B?T28weW1DWm9pdTFuWDFpN1piNHBnYnFYdzVRNTQvUDh3d1VSUlF5OXNScHA2?=
 =?utf-8?B?dEtLeXVGNnpzUFdZOVF6RjZoRUpRSDVkMnhHbk1ZS2daSE5TdVZ2QUN6eS9K?=
 =?utf-8?B?MWsyQ2ZXeFBWbWVyMU9TT2VmVEpaM1luM0JJOWd1T0ZlNVhtTEU0cWpFalJ6?=
 =?utf-8?B?Z3pRcXFsanJLV3p5MTlZR1ZyWWNSRmQxMDJKanlPanlXOXdwM0lRWjl4eEo4?=
 =?utf-8?B?ajJ4RVhaaU5CNENiYkhJZ2puN0E5QmNMOFhoT01IUzJ0T2RTR2JKR01adG1R?=
 =?utf-8?B?TldlbWRjYTc3SkozSnlCSkxjR2NVN3gzbjhJWWo0aFRQYU52T2duVDlWSXBN?=
 =?utf-8?B?WnVWSDBBYWdZTDlFNGUvQkE3Z3FXN21uV01oOHZqejVvMUxvYUJBVE5rM2N6?=
 =?utf-8?B?L1h4ZTN4bGUyUmRBcy9LZk5vNjA5QWJGNG1aaEtoUWRaeVpIMEVKY0VyK3BS?=
 =?utf-8?B?dFJmdDhjWXFMRmZkeU5vR05POGFGYVF5SmdPSm1zZVhlbzFhUHJidkRsM25N?=
 =?utf-8?B?T2NKNVh6aWNYbVZSZE5SaTUyQU1VUEtLdUorZnkvUXFTMzlzRWplOHVQdURK?=
 =?utf-8?B?eUVzY1JyMjBEcENaTFdITVBydng1bFM3WFdhR3VINTF1TnNUaFJmd3djYSth?=
 =?utf-8?B?aUZyK280b01NVUtJT3ZOczhvTlF3NkpBbnFoNVZFMWRPQWdKRHVWWG5hU2lV?=
 =?utf-8?B?ZEt1TUZITzdnZXB3ajlvYVR5eHBNYWYvRExDNXpUYmRtdU1Vdml6QzgxVkMy?=
 =?utf-8?B?WjR1Y1A5dGR6TG1iN0lXdGVaaGtRbENLMnA4VE5VZE9VdHMvaURRYUJpS2oy?=
 =?utf-8?B?cnROMlZ4cVIrbW1PaXZoRVpFUk1qTkR6RkRGZGU5UzdwR2ljbVpWU1EwQm1L?=
 =?utf-8?B?N21NSGJEKzMwR1pjZDZqeG1lNGFGL3JUUVFib29iUTJadCt3WGVOSW03TmZ5?=
 =?utf-8?B?bHN0ZHdnclh6R3VrZDYrZ2E5SHdKSzJiaDNRN2tCeFVrdTBaZzhvd1JvYWIv?=
 =?utf-8?B?cUI5TlNMdjBtOHFYa3pJNTAyVmhoaTNpek9JOE5ERDRCR1YrS2NuT3NUTlNr?=
 =?utf-8?B?M3FLQWNZbElWZkRlUUdCRjl4dHI4SFM5cmR1RVJwYkFIc0g2ZG9CRGRUeHBj?=
 =?utf-8?B?TXpLTDhGTGNaaFl4enNFMU0zbXRTSG1mQzFsQmdHV2oyVmpWd2gxSGdUNVpo?=
 =?utf-8?B?dE4wR2YzbEpmVTdQck04YzZxU0ZsZ0J4S3hBMlB3QmN1dW1yNVN1eC8xK1FE?=
 =?utf-8?B?Y0dvaE9BOGpHZGlHTDlyeFcvM3JjdnVuLzVuRk5qc1dCR0pUSWNJaSt3UnBB?=
 =?utf-8?B?bnd1bUxuc1owQ2NDVWFWN0FhSWhubGNMMjJBcUZhd0RtTjdVeGVVWk9zMWR6?=
 =?utf-8?B?Z1dQYjhwL29ya3pnSXV6NTk3VThCR0RHbUJNWGNoQ29HVTc5MVNrY0JiYyt0?=
 =?utf-8?B?VG40UFVxRWU5M1JJWnNJeWhKZ2JpS0NYK0ZqUGgwSHFVenRmNE9RbjhkdUFu?=
 =?utf-8?B?NElRNGo5NUZnSnNFTWpaV09xQi9SNkM0Vkl1OC85VjFJb3hQMmp5dnQyRnhS?=
 =?utf-8?B?cHVQYVZ3ZFB5MmlUNU9Ob05nc21IclRhWWVjaW51bU8zdk5YNFBEKzFqaVVi?=
 =?utf-8?B?RzJjUFdCZ3IzYzltVVhvYVd5OGhRQXFNZ01RdUlmb3B5aWJVdUJYOHkwSWU0?=
 =?utf-8?B?T1ROZUIrZ3EzM2lxa2Nuc2lxSjltVDF1aUNmWUxTVjJaMEt0ZzZ2Q1Jyb29W?=
 =?utf-8?Q?jYbfgG?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1pVVG1zN3k5K1R5UU5lVHJnNGMvY0ZJSmdNbFRmZmFGVXQzaVd5cGNwNFZ2?=
 =?utf-8?B?LzgraW9obkN5ZldoWkZvcU1kV1hlYnJCWUQ5VHlsdyt5UlpuNWdqUExWWG5Y?=
 =?utf-8?B?OERkUXdhb1l1ZTVPZUxlYVdWdDU4UWdMckNuejNVTkRya1lnN01CZjV0NG50?=
 =?utf-8?B?R2puS2NiNmZrUTd6RW5RZlVEWHpxak9aZEVNelljYjdacUpqREJ4VHhUVTM2?=
 =?utf-8?B?SDMyeEdsTmRieWF5NUJuSXVobEpaL2NZdFZsUVloY21NSXlKU1Q5dS9RTDR6?=
 =?utf-8?B?U2MwcnQ5NFNaUURDWWsyT0ZEaUlVNnB6dzNMWW9Fc2lkSXB1TmovVVVzRW5s?=
 =?utf-8?B?UDA2WTF6TWwzcnlweEsyRG9TZDFLdkJDS2p5aTFaRnRkdTc1MmJURWttM0c5?=
 =?utf-8?B?VWc4dE40bDI3eU43ZUhQMm90RzMzYTkxblVjQ0RPd2lZRlU4TlhGQlFhck9o?=
 =?utf-8?B?cDdhME9LaDQxNy96b1dRdFZJR09jaVJIRmVTMGJDSG5icXA2SjNRTTFZTzlB?=
 =?utf-8?B?QnhwWFJwWDR2MThtbk5GUXk3QndMYW92QU5HOVNIb0hjdXVmSHQ3SmZxcXZK?=
 =?utf-8?B?eUZ5V3IzQThCcDBSUHZITU9ZL3RaKzZZdmF2WjYwV1dMV3dORXZ6UWRYS1dz?=
 =?utf-8?B?SUY2TDlzZDdNcTBUWGYzaUFJdFpkYm9yczAyNDdieFoxcVZWaU1QRWVEcVUr?=
 =?utf-8?B?RzlwcVpsSFk1MllhNFlvUzUwalhrMEZDNHI5a3ZpbmQvamdTN2hVY0dDNjQ1?=
 =?utf-8?B?ZXVOQ1JCS1RLVTdZOVAzL3FPMmdMMjBYQjZiOEhRNENtcGlKS3JaU1pmMlRT?=
 =?utf-8?B?bEo3OCtQTzdBdDcyR0x5QjJyL3VqYXR5SU9WaFhxaVJiK09FSFEwNmM5ZmJI?=
 =?utf-8?B?UzVjdzVnb0RhTUpjcFV6NVJZcVR0aXNoQVp0bFl3dmpHM2R3RlZZcnJrUkpX?=
 =?utf-8?B?dVdXUUNYMU03QVU3dTdzUUVHMGlISmlZOXYwZTZ0WmYrbmU1KzQ1cHc3UGc5?=
 =?utf-8?B?TzdUOUZ4ZWk0blZNOGtDNTJ5cE1Pc0NVWWprdlUwUkxhQUpJSGt4VzI5Mlhm?=
 =?utf-8?B?VEEzNTJYRVZwNHY4dlc2UDlqQ3RYbThvNUZpeWZQWHVCaGFZcG1IcDVEVDl2?=
 =?utf-8?B?c002c1FndTB6Z2ptWFE5VitiVUJMUy9tWG9IaG9pRHJsUllSc3crblRJVXFR?=
 =?utf-8?B?WHFjenRhaDh6WW9YV2I2dG5hOTJRblhWOHVMZHFLL2ZxbDhMYi9KZ0VISlNW?=
 =?utf-8?B?QVMwb2ZVU0VkZTA0bEs1NjhNTFY5bG40cTJobjQ2M3BLZUhuRVFCTU1lNml5?=
 =?utf-8?B?VGR5Y1VNckRhd3Fqd0FnU2UwSlBIUDBxRkVaeTlxTHU4d0JET25qSFJzM0VN?=
 =?utf-8?B?aGIrVDgxcGZwOXQrUEZyRVNnSWtwNDBGaVBhUXZDc24vblk2NUF2MEVNYVVW?=
 =?utf-8?B?ZzFuVmNtZThYTEZLN3BCWHE5SGRzRjFPaXh1WGErdHlGNWxvMnc1ZTA3OWFr?=
 =?utf-8?B?SFYwSDFUTWpyR3FpYzRrdjRhMnRjMzRJRTVBeW9ueXpCWm1EVElNb2YyVjdj?=
 =?utf-8?B?ODhPT1Y1MUQ5K3JsakJab1ROc09sOXJWalIvTCs3RVY2L3ZZaWw4UldtRUdo?=
 =?utf-8?B?bmJHWEYwWDNGNm1DWWZhckFvcUFuRlRRaFc2OXpLa2pWWTFvTmpCMVE2aXJi?=
 =?utf-8?B?NjMwVHdKOUhkUkxBajkyYktEbk45ZXdiSmc4cTVwd09NL0k2TGtSa2FMNFBz?=
 =?utf-8?B?MmhobmFHSTJTdFh6OFhqdm1HZitqZkJtWWJFNzFPUGVDRDZRWjJTa3NUZ3d1?=
 =?utf-8?B?dXR1YURDZ29vSFJnKzFqR0kxSkdEaVkyVzFkVTNPTno3TUg4R3Y4ZHZmbEh0?=
 =?utf-8?B?OTFZY0JybzNUY3IxbXpjWWVtNjJiWFZzZ3EwZktOL2RyMmVWMGV4UFlJdUto?=
 =?utf-8?B?akJYY1JUV3dpdVJDeVNrbGpwRnZMdWdudm1PRnk5NmU5emw4NnoxUjVZdmt0?=
 =?utf-8?B?ZjNudUpDclpwMEV5R1FmeGl0VUJPemg2eEQ4ZUdJSXdMNGh4S05WblhxWkFY?=
 =?utf-8?B?VVJtQllnbTRzT3g5SVVvMEZEbHJiY05xQVlJcFNLMnYza2czQWVuMTJrOFlI?=
 =?utf-8?Q?O9XrzBsj5yhTcm3W/27OQKtvh?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4855FAE7074F0145AA9B089E588C58F8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c9662a7-28dd-44ed-9654-08de0dbc878f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 20:34:11.2459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bCuekncCBft7LJOhQyfaJWZrlD1LPEXDOWnVKNxI5vOpemBvOp0/Igyl/OPWmHka8Rv0y3yZ6hbHCr3l2i6leQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6892
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTEwLTE3IGF0IDA2OjAwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBGcmksIE9jdCAxNywgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IA0KPiA+
ID4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC9uZXN0ZWQuYw0KPiA+ID4gKysrIGIvYXJjaC94ODYv
a3ZtL3ZteC9uZXN0ZWQuYw0KPiA+ID4gQEAgLTY3MjgsNiArNjcyOCwxNCBAQCBzdGF0aWMgYm9v
bCBuZXN0ZWRfdm14X2wxX3dhbnRzX2V4aXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiA+ID4g
IAljYXNlIEVYSVRfUkVBU09OX05PVElGWToNCj4gPiA+ICAJCS8qIE5vdGlmeSBWTSBleGl0IGlz
IG5vdCBleHBvc2VkIHRvIEwxICovDQo+ID4gPiAgCQlyZXR1cm4gZmFsc2U7DQo+ID4gPiArCWNh
c2UgRVhJVF9SRUFTT05fU0VBTUNBTEw6DQo+ID4gPiArCWNhc2UgRVhJVF9SRUFTT05fVERDQUxM
Og0KPiA+ID4gKwkJLyoNCj4gPiA+ICsJCSAqIFNFQU1DQUxMIGFuZCBURENBTEwgdW5jb25kaXRp
b25hbGx5IFZNLUV4aXQsIGJ1dCBhcmVuJ3QNCj4gPiA+ICsJCSAqIHZpcnR1YWxpemVkIGJ5IEtW
TSBmb3IgTDEgaHlwZXJ2aXNvcnMsIGkuZS4gTDEgc2hvdWxkDQo+ID4gPiArCQkgKiBuZXZlciB3
YW50IG9yIGV4cGVjdCBzdWNoIGFuIGV4aXQuDQo+ID4gPiArCQkgKi8NCj4gPiA+ICsJCXJldHVy
biBmYWxzZTsNCj4gPiANCj4gPiBTb3JyeSBmb3IgY29tbWVudGluZyBsYXRlLg0KPiA+IA0KPiA+
IEkgdGhpbmsgZnJvbSBlbXVsYXRpbmcgaGFyZHdhcmUgYmVoYXZpb3VyJ3MgcGVyc3BlY3RpdmUs
IGlmIEwxIGRvZXNuJ3QNCj4gPiBzdXBwb3J0IFREWCAob2J2aW91c2x5IHRydWUpLCBTRUFNQ0FM
TC9URENBTEwgaW4gTDIgc2hvdWxkIGNhdXNlIFZNRVhJVCB0bw0KPiA+IEwxLiAgSW4gb3RoZXIg
d29yZHMsIEwxIGlzIGV4cGVjdGluZyBhIFZNRVhJVCBpbiBzdWNoIGNhc2UuDQo+IA0KPiBObywg
YmVjYXVzZSBmcm9tIEwxJ3MgcGVyc3BlY3RpdmUsIHRoZSBvcGNvZGVzIG1hcCB0byB1bmRlZmlu
ZWQgaW5zdHJ1Y3Rpb25zIGFuZA0KPiB0aHVzIHNob3VsZCAjVUQgaW4gTDIuICBUaGVyZSdzIG5v
IHN1cGVyIGV4cGxpY2l0IGVudW1lcmF0aW9uLCBidXQgSU1PIGl0J3MgZmFpcg0KPiB0byBzYXkg
dGhhdCBmb3IgTDEgdG8gdGhpbmsgdGhlIGluc3RydWN0aW9ucyBleGlzdHMsIGl0IHdvdWxkIG5l
ZWQgdG8gb2JzZXJ2ZQ0KPiBJQTMyX1NFQU1SUl9QSFlTX3tCQVNFLE1BU0t9IGZvciBTRUFNQ0FM
TCwgYW5kIE1TUl9JQTMyX01LVE1FX0tFWUlEX1BBUlRJVElPTklORw0KPiBhcyB3ZWxsIGZvciBU
RENBTEwuICBLVk0gZG9lc24ndCBlbXVsYXRlIGFueSBvZiB0aG9zZSBpbnN0cnVjdGlvbnMsIGFu
ZCBzbyBMMQ0KPiBzaG91bGQgbmV2ZXIgZXhwZWN0IFNFQU1DQUxMIG9yIFREQ0FMTCB0byBkbyBh
bnl0aGluZyBvdGhlciB0aGFuICNVRC4NCj4gDQoNCk9oIHJpZ2h0LiAgSSBmb3Jnb3QgdGhlIFNF
QU1DQUxML1REQ0FMTCBWTUVYSVQgb25seSBoYXBwZW5zIG9uIFREWC1jYXBhYmxlDQptYWNoaW5l
LiAgOi0pDQo+IA0K

