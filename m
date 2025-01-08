Return-Path: <kvm+bounces-34719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B96A04FCE
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 02:44:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C04451883B64
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 01:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24F0D13C8E2;
	Wed,  8 Jan 2025 01:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iLBVVpWN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BB32C80;
	Wed,  8 Jan 2025 01:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736300633; cv=fail; b=GsSWbzstg+OVHdwn4N0WP27ziNOAhYmkNCfT+ED6/idsRpWUi8oI4uVr3PbrrdeRN8ECIZsBLCCKPmLqZzhPr3TwgGiq1PeH0PAq7QY7yvJxQdj77NJuKZN5lwXlM2CWyNUXsXfnkss5Q0X3yXux+7w0QfXJHAlUoA3XbhO8LQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736300633; c=relaxed/simple;
	bh=/7uH7Yx9ift0cS6qB2hjT9egkTTX6bhiSmoNIoSyk60=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZGG0yB9K3esFny1M2tRdcrdwYWv0pAwlbGTTLmuBvLAIcm6UwWsLjVOzQad0v++vfhxssrLP8DgEpfJ1QcPRCvrBRvhcowbr6a6At2YzDop1SOejVoTYjV0SW4PaQYuk7Sy7EDXxx4Q3ls1KO4A9bUV3Fbc0XEUEDQvZI1IdFzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iLBVVpWN; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736300632; x=1767836632;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/7uH7Yx9ift0cS6qB2hjT9egkTTX6bhiSmoNIoSyk60=;
  b=iLBVVpWNdSyrXLlBplvxIxYVA6PyX//rnMHQUzC+/op8RUL8IHdNqhLz
   4en9MUo5McmRzGNHBOsSo1tSxGd4G52+qKrSYzL3t5n8ZvoV5jMjWSDca
   UlC4ctuG3EIkaxYXabn2rIsFKFLT56sU7xchlpI2X+zYHXI8Kq5r2aCk+
   C1Nc5SamMv4m9jYAL0+rH+3A8oguC0gT+0t244FJXsl66jEIFiofcC2nT
   xdSgPciE946BNR9KJ+hLu0oKmSAw//KBKwKNVRm6qaCt1FFRFIjLMvzV4
   Ir3pMH8eFth2KJLSqlBKRIS6myDT1+zYB2IwsHnhJUe/a7AiTy7a+dZ4c
   g==;
X-CSE-ConnectionGUID: tzgW/2+/SkWiZLMFsZaxFA==
X-CSE-MsgGUID: AUFfkrRfQLCYGy7ON158vw==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="54053900"
X-IronPort-AV: E=Sophos;i="6.12,296,1728975600"; 
   d="scan'208";a="54053900"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 17:43:51 -0800
X-CSE-ConnectionGUID: JaduOqkXRsak1nrEIlIHQw==
X-CSE-MsgGUID: dsPJi00yQyqb7Cwxy9kp3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,296,1728975600"; 
   d="scan'208";a="133788046"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jan 2025 17:43:44 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 7 Jan 2025 17:43:43 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 7 Jan 2025 17:43:43 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 7 Jan 2025 17:43:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j49s3yBzSGrA2beIpQPZ/PBf8ULYFj93NfxaZvJe/JYmcYvvEtWMyRWxaBZOyxHFzhix3iE64v5JRpci6b1UfRnSUIi9ZwF64Y11oKYkNp5sLkqDK6FeSRHWfW5vagmZkcQ1pYlmInPYmC8Jo5hAWTLUaR7bWjxwdB6K3DF/iE85vUG6Evk9r8zaIQ3uh8T9YDAP9K7w65S2zuEP5QYyILNeQAIteAiwG6DrGmJG+d7+HRxQQD3xLKiiRkMMQ+izpSsDvNu80o1olwQ9Pxton/X9JpaoPIZiDL4k3G4p5MTy+nADkxtJ+YzgUvIpTD3UxLbbU1dt4vN7if+qRyDvsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7uH7Yx9ift0cS6qB2hjT9egkTTX6bhiSmoNIoSyk60=;
 b=XE+INjdBvh1F8B2gYslHpQaUJX+OtzcnLIxKsAtENG8/jHRNW7KNxIb+KDNryTgKQczpXXBR9ILOCFHIhNilmfQGnC2EeyIWI7DLcq+/vWijLTCE71c++/DQOdhseJ6O3HaIWfhNQgLgAxwVOwY5tlI0Z+kdXuk41BIzc4+qRXHfcMxP/jqVyMj8GxeQu3KiKwMdBtNIOH0/A+hwvhY1O4G7np/b8N08bmcLwWGMpECrfJ1427lgFMPafLsxBr7iz8lPfbdCEvRhhaVyFu4TiT1y1Qy07hZg8nrpSrE5/ZTIIrkvt7T28mhWHYmt2s0alhMEPVmIOy94rhoxbIA2kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB6121.namprd11.prod.outlook.com (2603:10b6:208:3ef::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Wed, 8 Jan
 2025 01:43:37 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8314.015; Wed, 8 Jan 2025
 01:43:37 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
Subject: Re: [PATCH 07/13] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_sept_add() to add SEPT pages
Thread-Topic: [PATCH 07/13] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_sept_add() to add SEPT pages
Thread-Index: AQHbXCHXCEDEN07XLUqfjiTjMhw/abMECw6AgAe22QCAAFqdgIAAAlUAgAAGWYA=
Date: Wed, 8 Jan 2025 01:43:37 +0000
Message-ID: <f92121f411209152f2ab22b5c8dfa9ec74831499.camel@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
	 <20250101074959.412696-8-pbonzini@redhat.com>
	 <b27448f5fc3bc96ae4c166e6eb4886e2ff8b4f90.camel@intel.com>
	 <753cd9f1-5eb7-480f-ae4f-d263aaecdd6c@intel.com>
	 <Z33Q/4piC/QMdPFQ@yzhao56-desk.sh.intel.com>
	 <5907bad4-5b92-40e2-b39e-6b80b7db80d8@intel.com>
In-Reply-To: <5907bad4-5b92-40e2-b39e-6b80b7db80d8@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB6121:EE_
x-ms-office365-filtering-correlation-id: f8e1def8-c7f8-4e1c-4c75-08dd2f85ded6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QWo4U1JyWWo5dVhzZWNGOTBvU0dTeUxTTFpFeVJ1dFhhRGZacWpSUjNCMmZw?=
 =?utf-8?B?M2VFaVIzc2VGbkFNaWJTTnB6T0kyUkdUYjBFeS9QelVLZjBnVmlDQm5pRVh4?=
 =?utf-8?B?U0N2dERtZVJCaitsVnlMblFHVUxianMvOE00a2IvUjFUaHA2MXQ5clg4NzdL?=
 =?utf-8?B?OGIzbUl1WWY5T2lrTURKdFVuVS96dlhmeCtOeGJiQW5EOVdFd0Znd01DbWxM?=
 =?utf-8?B?cFFMNDJxM1VrVStQenlqMW40WVJtcytsamFTL1BHUzdObWx0aXdqU3JBd1My?=
 =?utf-8?B?MG8xbnR5UXJOT0hyUWQ1NnZIbFR5T0QwajN0Z3dDZ1F5VDU1UUV0ZlA3bmJJ?=
 =?utf-8?B?cHA1YmZOcm1oVUpaV1F0c2Ntdmo0MU9UeVpmd25GODZKNE1zUW1RQ3lSTDZ4?=
 =?utf-8?B?ellJQk5ycTNldWo3cWl4MysyK0xCYXJiSytnWHF4SHhHU3pjYy9rM0luRVJY?=
 =?utf-8?B?ejBnNENpMFF1ai81MklHRHQzeVFlbWUvUDBSSDljRm05TkQzM25CYWNpYjlZ?=
 =?utf-8?B?U2FQWEF6OTlzekttWlprQk9SbXZwOXNyY1dQdS9lS0FFcVZpN0Z0bHhsb2VG?=
 =?utf-8?B?Z1J0bEV6K01JVTdPMXcwaUVXQ211dkVMd0JRV3JZWHFFWlVub0J5VFFseC94?=
 =?utf-8?B?Y21ianRyY0pGRGRjNk9zMUpLZ1BqV29oWXRueDJTTXcydjVYeE5HTzZsTUlZ?=
 =?utf-8?B?M2x3dHVuVG1TYmMzZTlneVdTaTM3Ymd6Zjd6bS9QcmZ6cUhlWjEwa09RZHZ2?=
 =?utf-8?B?Y0hPcU1VNnRsN1BQM0NjbzRvZ01ndWk0TkxBZCtlV1k4dkcxeU1lcHk3U2ds?=
 =?utf-8?B?RUVDOVc2VGMwczRweFhGYm8wOWx2eHNmSVFOdlRlRWZIOXRsc1k2TEd1L1BU?=
 =?utf-8?B?WjdvYzZyTlR3TDNITTZxRkRLcDhyNVZ3WC8yQ0w5Z3NVWmJtaWpmZ090UEkz?=
 =?utf-8?B?azFZamlLYXUyYU9ieGJkL2RwWFFoT0hOWU94eG41dEFHOE5raTZ2cEdHdEtF?=
 =?utf-8?B?RXBLQ1ZFYWR6a2IrbHVkRi9VZXA4aEdMdWxhaFl4QnRzaXc4Tm4rRklPb2lV?=
 =?utf-8?B?U3krQzBwZVpZMUtBY2htTk93bXBGK3Y3MFZpa0dvTlliYXVCYjRBZzg5MlJw?=
 =?utf-8?B?K0xpTHMvTHpoRDZ1V0ZkNVlpMXBqaUhGOFp1VlhwR0xGTEt1d2xlcUhwcEFG?=
 =?utf-8?B?ajUvWTVMd1dyNTQrWXZlc1hpSGlJY0JKWXM0RjhyMjR5aVkrTUViMGp1YWl3?=
 =?utf-8?B?am1pNGFvSyt5MHhSZWVjU2g3T3BuYXlIeXIwaUtnN1lMZkk4WHEzWEJiempY?=
 =?utf-8?B?Qk0reEJXMmhqQVkrU3FpOWQreVNVblNFTE1mOGtJdUpySjFpMFFrMmk5TkRT?=
 =?utf-8?B?cmlvbFdXSk5RTVNBeHhaVFJZTEl3MjRRa3N5OWlNSGJESkVCZ0JoSEhQMVpP?=
 =?utf-8?B?clNySjFWRmhEV2tka25Xb2N6TWlEaENEWkxrN05OajN5Rm9UWlJENG5jU293?=
 =?utf-8?B?aWdjTm4zQlNUWmhvN09NeUxvZGo2MnNNVnBPVXRnR3ZFSmI4QzdWNUsrWHpC?=
 =?utf-8?B?NVFWZ0lZZ2t6NDEzTzNIcys4UFZpMFo5KzU0b1N6dDBVVmRqdG0xSTRnK2tJ?=
 =?utf-8?B?RUZZZGFaVythU3lmR1lzNkJaQTJobm9oVDZyaVVhbmh6NzF4akxONTNPYXZU?=
 =?utf-8?B?cDF4Uk90ZXo0UEhVczE2S1o5Tnl3ZmorUSs5NnViYXptUnRaSnZWYkgvUmw2?=
 =?utf-8?B?YUkyckMxMFFTVU9Rb1I5RjJIT2NsTUxMZk9tSzI0elk3ODBtV09zdWpoNXBQ?=
 =?utf-8?B?aWJwdU5ZNzVEZW54OG1zTXBma2VCUE1OMUVjUkZ3SzBGMHdEL3pSWFdKbmts?=
 =?utf-8?B?TlJTL0pvc1BUMlZ1MnRSTjROTk5MbnB5V3cxVG5HQ2FXYmlTZVY5bndEUjMw?=
 =?utf-8?Q?NB2Rt8xG1oV34URe7j2xlxoMGt5HPMow?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OTdLZlVSaVE4ancwU1NYWjFEYmpBMkZKWlpxUlJuL3ZVaStEVW9rRktLbCtR?=
 =?utf-8?B?MkhNM3lRT0VmVi8vWWlVK0gzNTBaMzJVZTVqU0hudm9PSVp6NU5ucXFPUHlR?=
 =?utf-8?B?YnQ1MzFxS0lJeVI4RTZ5Z2R2Z0NDR1lwUCtzTldRYlBaaGFJRHovdUFNa2ND?=
 =?utf-8?B?djVxeWdadGlxMkFKYUFDRlZHVFJKZVNOMUkrYXZHMjFMbEdWMGhQTll1V1h3?=
 =?utf-8?B?dU9WbVZqTEVWUzdZQnl4UzZSdjE2cXFmYnV4bmRMZm8yQ0p4anJocVlwdjZ4?=
 =?utf-8?B?dk9zZUo3SkpTNFpxWkZ4eUZOMjNFaXhPRWRIdVc1Qjc0MHF4LzkvTmtjY2hW?=
 =?utf-8?B?TWJxYS9Ja05YQ1l2MnQ5enBLYmZtWEVxNXR6VERDZ1BoQXlFUVMvQVpIVHkw?=
 =?utf-8?B?ejFZMzdCeGFDS01UbGoyb0JrL01XckcrMEFVMVRha3RkTE1JakhQeU14L3RT?=
 =?utf-8?B?RFByVHZtYTdpdDdzaVJ5SUNhTEptR09IRmkxQXBENkt6blJWYk13ZlZaMnE1?=
 =?utf-8?B?aXpXOG5HeENyUEdPQm5WLzA4Qi92eEp2RkFCVzlSUUZSUnV2Mk1FTDdPY3M4?=
 =?utf-8?B?aTluTXJNY0hCL0o0L2I1Y2txWC9oR0VUeEF6VlNGZVUwQnliUWxndWRHK0F2?=
 =?utf-8?B?WVpzbDBvMlF3eUQ3WEhraWFKWDZZVUNjMXVYTXNIQWFDY2I5R1NJcUhpZUd5?=
 =?utf-8?B?QnRIU2RiazBYcXJIaG43SGhDZkRYQ3ZPWFhIeDdMK2xUNDRFeTRDVEMvVWZy?=
 =?utf-8?B?eWVpdWZvV2pLZXlXMmNDMzk5VExVSVBiYTlYZHI1VjZkbGNlbkRyTTRKNjRC?=
 =?utf-8?B?MlFKVVg0cWxmbTAvMEF0Z0pXbFVhNTg2RGVwWWhXaFkrRWtpaCtUemRtLy9Z?=
 =?utf-8?B?cmVLeWZOWFhuQWtnWlk4ZjJId1Y1QzZUTmkzdU1GWWpqVTBBYXMwcTBoU3FJ?=
 =?utf-8?B?cTFJMHdEQ3hJbUpuRm52d0R0M1g3RVRNWExNenA0SkI5T1FNN0NuVXZrTkpH?=
 =?utf-8?B?TSsrNEFKTHVKUGhUSmZLYnc1TlZoMkNkV2t0Y2FUL2lHWEVvbjlTMU5nbXBr?=
 =?utf-8?B?TllqQkloeDM2UXVPTXZVOE5rZTZQYURGQlBwQmZtQkdlTGt0RWlRbXUvdnlY?=
 =?utf-8?B?VEF4ek9GeDFYSER5S28rdlc0d3AxMVl5NDhJU21nRkxCMUh1ODBMaHJUTkhz?=
 =?utf-8?B?MCtFU0FFd2dFeVBLOGFvZk5Mb1ljcnhQZkRpNHdtYjlpZ2VSaTZiQVR2RHlD?=
 =?utf-8?B?amlpRzUrY092ZGRvN1A4U0pRNTdMVjdIWkNLVERxbUk3Y1o3RlZkaCtGdXkw?=
 =?utf-8?B?bnU1cHJOamZqRUZsWXA5N1U1aVRtWWczYmFIMmVxMFdSYTVYbG9MNVp5bjRa?=
 =?utf-8?B?TURXVG8zYWp2eDBnaG5ZLzZZTVZjbGEvVk1HTEIyOEJPRXIwbmlCQVVnb1BO?=
 =?utf-8?B?TkZ2UXhWN2kzaGJMcTltYm1HQSsvbjRHbS9YemJEK3pxZ2o1RmdqMWQyR29L?=
 =?utf-8?B?WGhRMmx0MHVseTh5VURKcEpaclRvT1MrYktETlJReWRMckpNQ1AwVzN4ZHF0?=
 =?utf-8?B?djN2Yjhnc2g5bVROVVQ1NFNZZllFZ1VESmpRYUNLOXBzaWJRVklOMnJpRzdQ?=
 =?utf-8?B?MllwT3YydHJ6ZWw3OHUwVlpKSlRmZXRBdjFIUEQrTWhPVEtJVm9UUC9lM3N1?=
 =?utf-8?B?L1g3YzVSUGFLbUYrQXlaRG9EMlZRMEdNR1JRdUN1TEk5azBIVjNUdHBYamNV?=
 =?utf-8?B?dzJLSUtDV3g2TzJBdTVISjlvL2c2bFRFMGY2VzF3dzlJcjhwdXpGL2dOU1Bv?=
 =?utf-8?B?cTkyaWRDSHJ6YlNRTVZKNDhqejcvRnFZMUxSYUZROEdmMlMrSEpNU05vN2ov?=
 =?utf-8?B?Z0xYeDhuSk5iMGpaM3VJbFFaRENKdmFheHIveXJpWjFqWWVIbTNtdkl2Q0dB?=
 =?utf-8?B?Q3IycEVhUk5vZnl3NW1JcDhFRUhuNCtyZkJJZG1ONzFRSmlVMmEzNzhuVGQ4?=
 =?utf-8?B?OVhMa3g0T09rOThYb0xLK3FnS3V3UGlpV0ZwT3VEZVE4Mnk2SExiOWtIWWlW?=
 =?utf-8?B?N25BS0ZSaHdueS8xMkU5VkEyc1VNaFlCcWxSVGRtRkJMcG0weWxVQkUxNGZE?=
 =?utf-8?B?ZGlWL2wxRzlUMUxUYVpHRnpvUWdhTHpRckROOTlzMlYrNnZmMmg1UGtManQy?=
 =?utf-8?B?NWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E90DEC18DB1BF3478E4C3C94F5EF9940@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8e1def8-c7f8-4e1c-4c75-08dd2f85ded6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2025 01:43:37.1782
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zzhOCmr9WPr6CkYOaBYzBrKM5SY4Xo+DVXjN+AJIkjBkRBc3NuJNnyLAqhwJsSKbeR6GF0iUkoWTMvG+UiYtwJi+ODLJ6oWng5U87e7mHj0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6121
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTAxLTA3IGF0IDE3OjIwIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMS83LzI1IDE3OjEyLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBTbywgd2h5IGRvZXMgdGhpcyBi
aXRmaWVsZHMgZGVmaW5pdGlvbiBtYWtlIHRoaW5ncyB3b3JzZT8NCj4gDQo+IExvb2sgYXQgdGhl
IGtlcm5lbCBwYWdlIHRhYmxlIG1hbmFnZW1lbnQuIFdoeSBkb24ndCB3ZSB1c2UgYml0ZmllbGRz
IGZvcg0KPiBfdGhhdF8/IExvb2sgYXQgdGhlIGxpbmsgSSBzZW50LiBCaXRmaWVsZHMgY2FuIGNh
dXNlIHNvbWUgcmVhbGx5IGdvb2Z5DQo+IHVuZXhwZWN0ZWQgYmVoYXZpb3IgaWYgeW91IHBhc3Mg
dGhlbSBhcm91bmQgbGlrZSB0aGV5IHdlcmUgYSBmdWxsIHR5cGUuDQoNCkh1aCwgc28gdGhpcyBl
bnVtIGlzIHVuc2FmZSBmb3IgcmVhZGluZyBvdXQgdGhlIGluZGl2aWR1YWwgZmllbGRzIGJlY2F1
c2UgaWYNCnNoaWZ0aW5nIHRoZW0sIGl0IHdpbGwgcGVyZm9ybSB0aGUgc2hpZnQgd2l0aCB0aGUg
c2l6ZSBvZiB0aGUgc291cmNlIGJpdCBmaWVsZA0Kc2l6ZS4gSXQgaXMgc2FmZSBpbiB0aGUgd2F5
IGl0IGlzIGJlaW5nIHVzZWQgaW4gdGhlc2UgcGF0Y2hlcywgd2hpY2ggaXMgdG8NCmVuY29kZSBh
IHU2NC4gQnV0IGlmIHdlIGV2ZXIgc3RhcnRlZCB0byB1c2UgdGR4X3NlcHRfZ3BhX21hcHBpbmdf
aW5mbyB0byBwcm9jZXNzDQpvdXRwdXQgZnJvbSBhIFNFQU1DQUxMLCBvciBzb21ldGhpbmcsIHdl
IGNvdWxkIHNldCBvdXJzZWx2ZXMgdXAgZm9yIHRoZSBzYW1lDQpwcm9ibGVtIGFzIHRoZSBTRVYg
YnVnLg0KDQpMZXQncyBub3Qgb3BlbiBjb2RlIHRoZSBlbmNvZGluZyBpbiBlYWNoIFNFQU1DQUxM
IHRob3VnaC4gV2hhdCBhYm91dCByZXBsYWNpbmcNCml0IHdpdGgganVzdCBhIGhlbHBlciB0aGF0
IGVuY29kZXMgdGhlIHU2NCBncGEgZnJvbSB0d28gYXJnczogZ2ZuIGFuZCB0ZHhfbGV2ZWwuDQpX
ZSBjb3VsZCBhZGQgc29tZSBzcGVjaWZpYyBvdmVyLXNpemUgYmVoYXZpb3IgZm9yIHRoZSBmaWVs
ZHMsIGJ1dCBJJ2QgdGhpbmsgaXQNCndvdWxkIGJlIG9rIHRvIGtlZXAgaXQgc2ltcGxlLiBNYXli
ZSBzb21ldGhpbmcgbGlrZSB0aGlzOg0KDQpzdGF0aWMgdTY0IGVuY29kZV9ncGFfbWFwcGluZ19p
bmZvKGdmbl90IGdmbiwgdW5zaWduZWQgaW50IHRkeF9sZXZlbCkNCnsNCgl1NjQgdmFsID0gMDsN
Cg0KCXZhbCB8PSBsZXZlbDsNCgl2YWwgfD0gZ2ZuIDw8IFREWF9NQVBQSU5HX0lORk9fR0ZOX1NI
SUZUOw0KDQoJcmV0dXJuIHZhbDsNCn0NCg==

