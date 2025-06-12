Return-Path: <kvm+bounces-49211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DDC6AD65A0
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 04:25:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACC293AE857
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 02:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7BA31C1F12;
	Thu, 12 Jun 2025 02:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n2dOJp9U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2CE22094;
	Thu, 12 Jun 2025 02:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749695092; cv=fail; b=nh7X+KSCQxefYOXRW+jfDT9eEl3kSJJqPh7wNgEghcwJldBMmISBUB6GXDhFDt5hPR744VC+DZMjJTbcPUOvWaJuHPcEzGaPP12ol45h3rWnsr++Lxe4x1rMKuGjLTfT9k2AzhzhP7iyb4kNGstc0KQfTA56hMlIc/oq+P2pdU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749695092; c=relaxed/simple;
	bh=K1/LgM/ucAeR7JTVYInsE6PY3nC+hOSbN/j9AuTVb2c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hb4KDgEz1Sm/onAcS3U6j1CIoP3UZpNiloDwXGkBfSkIwt1gzuNyhC2bT9jRLxpUrYxGTcrgHlKC3T5dGGGQP9DLw2dWPdrOT/zRNb5x/b9lgimwcxWjDvtXArx7FzDHVxKuAxwVXZ0z7RVZfmsKc3tArOvZ6KabmYdH4nHYylw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n2dOJp9U; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749695091; x=1781231091;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=K1/LgM/ucAeR7JTVYInsE6PY3nC+hOSbN/j9AuTVb2c=;
  b=n2dOJp9UXZS+uMIhZDmWCCe400BdIiUJrGA8sBDX2sMSGKKWdqdK8RYS
   oPuZY0GebMuC85eNIMxHbBmgRpjEods8sFKt2JKV40NmmXFB2UnA7y7x0
   IBLIQ/6mTQjhth8oWgEO4Pz1DxP8B2tdrQDFVKlG6f2vkljU+qyx67w/n
   cUEFVWBM3tcrAzKUNMPZQRn90jvRBH4RV0LChXDCfvXHX4k7e/wpftVqT
   enqrqgXbzGenb6d/GbQXc3UYhOXc88uq+Y4C7LfbnfPAbd6n1DSJ7zIK1
   y6tugcaLk4x9/DyatFA5wfR02CLzNngaMnoTSqgJu6+PKP1ttwcZ1ndyG
   Q==;
X-CSE-ConnectionGUID: 4vUfSXOmSIG7mPozC82feQ==
X-CSE-MsgGUID: k3gRaHJERBuaDkQhm91A8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="62893748"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="62893748"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 19:24:50 -0700
X-CSE-ConnectionGUID: g+BMq3qGQMKEF8uJFLHhzA==
X-CSE-MsgGUID: FOSEnPhhTqWk/6xEIqd+cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="147865077"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 19:24:49 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 19:24:48 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 19:24:48 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.83)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 19:24:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pLut+EEsikp4+m69fnmqhhYL0vQENKSmlpzBMmCLidlf2TPtgtIwcHCxEEhBt6mfXxhW3ut15dr+t3NkGDAecTys8/jTyh0BIFFXgZ2Ys+3wkwfCIZ7IOx7jbXtHBigFvl3EV9rnHCPc3vCPLdVQbesvVG3OgPY7FDhzLSAJ/OHR/DIt+gBAYw74yw2rjC4iGz81ayi1RgJj0raRbLhT4XSxwnZXGONcDcNrH4uIkP2AVIrkFBkzqsU0ITMYVKwKeOvyLYIlzGZJzsZNDdVk0661gMBczSzRBvRvUVb5glUo1VmrNHY+l1u6Q38jW002Gw+2Z0u4Z2177KRdr12LKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1/LgM/ucAeR7JTVYInsE6PY3nC+hOSbN/j9AuTVb2c=;
 b=lcKJDSjp+6j2gkJaMGYLTTnvMackrrjP646AyHLgg3rUUNwaaq6AgWROTjSHE5IigPPbcP9noZMltD1AS1+GDqUy06bTI/BMYTZi0WU+JkOGXrqrfOUQTkLxlx9QxwHdle4QIShahX9xlGK9SkJw3de37MSYK/OEFPTg8XU4pewVGmqtEfN2tnaU9Vy4s6oD1B1CB7gQniFDA8srZjrlBmC7tnyLu/lQ7Ez/OQt/5C9rPJgY6YQxiCaHY1nxPwf4BpT4apw+EYfiRuCattwMI+jdJuSUbwVATNuwwkuP+LoZoMOq0CVBr3QCDx4XShxQh1qeWTYtvnvA9sDyKxR5dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM4PR11MB5969.namprd11.prod.outlook.com (2603:10b6:8:5c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8813.31; Thu, 12 Jun 2025 02:24:32 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 02:24:32 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 07/18] KVM: x86: Rename irqchip_kernel() to
 irqchip_full()
Thread-Topic: [PATCH v2 07/18] KVM: x86: Rename irqchip_kernel() to
 irqchip_full()
Thread-Index: AQHb2xjm+TuTHanE0ka6xARLoZ/hNLP+zAuA
Date: Thu, 12 Jun 2025 02:24:32 +0000
Message-ID: <dd5fbd5bcc0e7ae9ac60a39a93ca8b747e5daeac.camel@intel.com>
References: <20250611213557.294358-1-seanjc@google.com>
	 <20250611213557.294358-8-seanjc@google.com>
In-Reply-To: <20250611213557.294358-8-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM4PR11MB5969:EE_
x-ms-office365-filtering-correlation-id: 0fd0e13e-0e81-41d9-ca6f-08dda9584459
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RkhsVVNnSTVGU093Zm1tREM5cjAvQm1BR1ZvS0grVFhoVFJlMnlkZ28yVytB?=
 =?utf-8?B?dUlDTmZRU0tjZmtsZFJITFcxSTlOUjdNdWM0S1g5Q0xURkxmV1lLSVdXY3hI?=
 =?utf-8?B?UCtIWEJmSTlXQ2FVSitRZlMzTVBUNkRTa1owMEJNdUVRZExzZUx0NVNmckx5?=
 =?utf-8?B?eWlKaTZGdG9ac09La1YrS3o5VWlwaGRjalJlb3ZjcHpubnpEQ2FnQlhoK0hT?=
 =?utf-8?B?MEpVRXE3aFR3dlhmL0hpNGRFWFAvVmN1R0VvWWJ2UGVjWllGaXpLZC95citt?=
 =?utf-8?B?NkRDakgwMHBYMENmMXcrZGRBU1hnRXl1QnI5K0FPT1dDNTZSZi9LTnpsNHYx?=
 =?utf-8?B?eVU2bmlPai9qcXJhZ2JZajFmK010ekY3Vm9VZlZPckdkbitnUDFEMkNNcjlr?=
 =?utf-8?B?L3FZb24wQVg4UWxPZDRuNnRVeEUvNi9xWU1mbEhzKzhoL1c5MXAxSUcrcFVz?=
 =?utf-8?B?TFRVdWF1cUY3UWhad05KVXZqTEd1cUJLc3B3TkloVXRlQlhLNUpydkdFZFBQ?=
 =?utf-8?B?enZGNEFPYnRMWHdkYWRyKy8wY29WQml4K1l0bmV5TXNPbVBxL2NMZzVFTXBy?=
 =?utf-8?B?dXdJZWNFSm8zOHo1YjBsY3pJN0pTMXhsMTgrWGhOOUE5UUhLMW84MTlsb3JW?=
 =?utf-8?B?N0cralNudmVOY2V6TjV5WG9PTFU3NkRVaEh4Q1hyZGs3WjJiTkMzSU9KN3Jo?=
 =?utf-8?B?dkQ2Qmk2Qytma0UyYkVxNVc2Q0ZCclltRTgvMDlrWDRtMXh4a045WVhaZjBS?=
 =?utf-8?B?YnFUckthTkE3RHkzbXRyWjZyRnhuVjdNVjNYZUcyUE9rOHlZc1NVbnFQa1dC?=
 =?utf-8?B?VGRZaUEzN0dwZ2tWdG1CTTFlUm8zcUdLa3kzYmkyOEMzV2xMUEN4SU5GS1Vj?=
 =?utf-8?B?SW5CN1c4dk5USlc3QzFCY2pYZ05sUHdzcmJIMTc5NkpjOUxjR1RSNmlkTkdN?=
 =?utf-8?B?VlorV3VCZnhLS0ZSV3pjUWJveEtxbE9pRnBHTk8vWFMrQk1hMWZSOWQ3NmFF?=
 =?utf-8?B?aGg3QlBLQktFRG1ncmVPRHc3VVlvUmQ5RWdnMkpnUzFvZkRZZVpObnJsbTNQ?=
 =?utf-8?B?SU8wc1dtRUVZbEE3K2E5OUhXWXZuVFJSakVyWXdTN3pPdWpJeXM0Zmt6bHp0?=
 =?utf-8?B?ZkwxR3U2S3RHNVFpSFZpSHZjUlJmY3I5ejFTRi94eCtEQ0cxdlYvcHY4QWtI?=
 =?utf-8?B?YmdVOEVqaGdKSkRGTFhkYU1uN3NicUFkOWx4MmpCZTRMNWcwbTFlVUduWGNP?=
 =?utf-8?B?UkhTYUhpY2hJdXRuTkFTa0JKeFN5ZEYySWZrNHMzQWJBakpveG5VODBReVB5?=
 =?utf-8?B?TEFRT29Ea29tTW55ZERpOFBsK0hSakt6enhMNHdCdTRKNTVCUlorT2E5WS94?=
 =?utf-8?B?Zkd6dVFHcHJlMm1hdlowZkpYNFJndjhaYmxlNnc3cWt4WE04U1NnSGVQQkIw?=
 =?utf-8?B?UmtveHZDYU5HN0gvY1AwamNSOTBlejFpQUtBYi9hanMrSlc0bkJiQVQwM1Ur?=
 =?utf-8?B?RU5meDAxZnBNSWRzc3VxZWZvSW5GdW1MZndWUFFwTmxXQ21VeGtjalRnaWJD?=
 =?utf-8?B?dWx2M2FFUXRZaERhQXFkVGZNTk9SWjA2MkpCc2pxNEJZUVRyRFl1SU9zeWx3?=
 =?utf-8?B?NXBTd0Uzb0NmUi80SDRKNVJucnZKcVZ0bUV1STlhQWVyY2ZxdFhzTTFnUVI2?=
 =?utf-8?B?NmVMcmVDLzNUV0t5eURZc3ZUd1AxbDQyVlFkVmFSUWpJVmczQjlQSWg1YWw1?=
 =?utf-8?B?VVorVFQ4UzVuWjIrT2FOOU93d2xTTGFlU1VWYmJkQWFEbTAybzZtMEZWU0Vx?=
 =?utf-8?B?d1JRd3hwSzFwK1VuY0M4UWNtaTRVYVVRTjJrQVpHVHFCelJHWldpTHNoOUZZ?=
 =?utf-8?B?QVpwY0xSdnErTUFuQXc1dnFpSGl0WlVxcGUxWjFUZGlWdUxWOXNpMG1DRlAr?=
 =?utf-8?B?L3RMR1NrUW1iUnlhNlRGQVNmdkpMWlJ5TDI2a3pzUmYrUTJDUjgxaUhiUVky?=
 =?utf-8?Q?I2KPFfShY4mEGS864n7r3zIQSNMH9U=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVJHQkpBZG54K1F4NjVzeEQwUlZzS29HRlFxY0lkWlpPUnZWSGtCeXl0NFhN?=
 =?utf-8?B?WEx4WVcrNjRISmlUMjhMS200SzRjQkM2ZDdBeFR0UzNRVGxhcHYxaG5oMzBL?=
 =?utf-8?B?Y0RiUFBlb2FzcCsyemIwSFZNUEJzZXJkVlByMHhsbm1QOXVVbzFoTkNPK1Rj?=
 =?utf-8?B?amhJSlpCb1o4MkVtSUY4dStZd2FkUXY3b0pRcE9XTkJXd0djS2paZk4rZ1lL?=
 =?utf-8?B?Y3VpQVkwYzY1ZjVETTV3c2hZTHFycHM0SUJBbDZ6OHhtaU5YVlN5T0xVM2Rk?=
 =?utf-8?B?QUwvM3Q3MFFvQUlsanpSZm5aZ05QdVh1RVl2NzhxUStaU2hIWDFEaEYyVTc5?=
 =?utf-8?B?RlJxbkJmanU5MjhFRWlkOFNmUU1Kb2U1dS8yWUJsaXdZWTBOa0x1OGkxZWFz?=
 =?utf-8?B?bm9iNDJuNGl6Q0dCRVdLUEoyYk5KN0lodG1Ud0t3V1NVZ2tIcmNQbWloYzF4?=
 =?utf-8?B?QUFDall2U2xaSktkOFRIVy9xNU1UeklOMVhmc3FwZHE2cHF4ZDVoMXpocWNm?=
 =?utf-8?B?ZGs5Z21aYUN4QnFOZjBGWk5vcXpuT2x6VEh6Q3p4b05EOVoyaVpabjJraEw3?=
 =?utf-8?B?dU9vckJjeWI4YkE5VzJqd0NSaW1PNmF4NEphWXA0cTdlSnFacnBsRFRIS1NS?=
 =?utf-8?B?OHNJVXVBV2wwSVYwb2NLTTc2bE9aeGdPZi9JbFYwUHlrMFRFMUNQUVIvTE92?=
 =?utf-8?B?ak1pTU8wY3AyRmdtZGhYVFZFSGRMdXorMlIwWGcxd3lLVHBJV2pZcjgxOFZO?=
 =?utf-8?B?UW5FSi96Y2ZWSDIxK1FaY0h5RURIaUM3S20zcVRzbEx0ZUo5azdzOC9FRS92?=
 =?utf-8?B?ZHBXVGUrTjM1ZW1kWk43cEZNYzM5Q0hzVmdDbGs2VzkweFZmNzc1ZmYvdlBa?=
 =?utf-8?B?RFUvWmNlMlgvM3VCb0ZqUkxGeXZNNnZxQ3RBcmltR1dGM0duNnRGd216V2px?=
 =?utf-8?B?QnpJRUlyNHVhY1JJVEZmY2lkb0dsMFBLbnE3andKUVBWdnFKKzdhZFg4ekhX?=
 =?utf-8?B?ME82VmswWkxMWFB3d25tMklTaXFvcGZzQXl1MWVrUzJGUXRnWFRxZXppK3Bw?=
 =?utf-8?B?eDlaYzZramFVU3ZhL1VxYzV6SjJDcWU0T1RuVjBqWVVnUE1KTVhjQnM5c0ZU?=
 =?utf-8?B?VVZEZ0thZW9FSEU3U1ZmRm1aMzRDV2hoQW1qQndEUWZtU3NNaXZkOWZTUHl4?=
 =?utf-8?B?Q1VKbzdIL2QvcFhLODVxaUZFTEkyc3BJenBnb1pnNCt2VVlQRXdXTDhjT3Vh?=
 =?utf-8?B?MUpTd1V6eGVhQW92M0V4Yy8vYUwrU3NyVkxJSUFwZ0dqRzJ0MjFtRkdCZjUy?=
 =?utf-8?B?V2dON1ROQnFVZTJYUDdFSm1wbUxPek02TG8vK2kxZjJWdmhaWm9oYkFXWHRa?=
 =?utf-8?B?dGM2Q29SZGIrQjFkNXFIVzNYS2Q0aWlRcHlrNVE4YWtDS2ZCeGZiM2hTYjBT?=
 =?utf-8?B?WXBMZ0hhWnZ3SEpHcFdZckx5N0tRd2tzeUNyeHl1N2lsZnIyV21xT0xkTFN3?=
 =?utf-8?B?MXYzdWdrb25mZlhVeG1YZDdZSUFXNHgyaSsxai9GQTl2NGtzWTBMR3dyZkh1?=
 =?utf-8?B?ZHZ4T3NPUkZBMGlIZUVIVnN4S3czaVNCUk9BeVcxdHdjVDAzNWhkVzNvZktm?=
 =?utf-8?B?OEJOeGY0K0diZGtjcHM4eUFEMW5iZTA5V09NamMvQjlteXZob0hQRmdRTVhS?=
 =?utf-8?B?d2t3VVBIWUE3TytScUJpREw1VzJGRmZMVWdMZFZ6Qzl0OGtnOWUwS3dFdHhN?=
 =?utf-8?B?Uy8vY0JxRk1ad0NuRWNUM0o3SnlTWlMyaHNDSFFCWmRwcnlSOFRLZFR4bGkx?=
 =?utf-8?B?OXBqSDJiS3RqVUYyZVE4ejE3MXRzeTZZT295dVlLdXlwalBnekIrL1JWbUV4?=
 =?utf-8?B?UGtZc01rSlB2M2o4d0s2a0p1WmJjYkhvNmEwMFNxaHArNlozUmFQVkwxdzVD?=
 =?utf-8?B?TXlkNkhqUml2d0xEQnJMNTdLM1VXN1JYOFRadWluWkJzNHZsVUw0Y3JGTW11?=
 =?utf-8?B?YWM2ankvSUI1R3U3aFZESjNqd0JFMUR4R2ZZWXpNOEpBcmd0bDNwblZaWDl5?=
 =?utf-8?B?YndjRWhEN0lxM1Zaa2MzSGJhQms0ZjhobnM0QUV1ZllwZ2pXWjNPanEwS3Zk?=
 =?utf-8?Q?knNFn2BK81W1JyBWCfM8sBK7q?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3BD67997A43ADC448DF70024A8FBF60F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fd0e13e-0e81-41d9-ca6f-08dda9584459
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 02:24:32.4986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PGRc+HGexLExRUNHzUDvWXztyg7Qqd210ekvKpx3WOA3y1/T8niJKgCtkcom4vheC7kaIXWv+coLtVw7qpvbHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5969
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTExIGF0IDE0OjM1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZW5hbWUgaXJxY2hpcF9rZXJuZWwoKSB0byBpcnFjaGlwX2Z1bGwoKSwgYXMgImtl
cm5lbCIgaXMgdmVyeSBhbWJpZ3VvdXMNCj4gZHVlIHRvIHRoZSBleGlzdGVuY2Ugb2Ygc3BsaXQg
SVJRIGNoaXAgc3VwcG9ydCwgd2hlcmUgb25seSBzb21lIG9mIHRoZQ0KPiAiaXJxY2hpcCIgaXMg
aW4gZW11bGF0ZWQgYnkgdGhlIGtlcm5lbC9LVk0uICBFLmcuIGlycWNoaXBfa2VybmVsKCkgb2Z0
ZW4NCg0KImlzIGluIGVtdWxhdGVkIiAtPiAiaXMgZW11bGF0ZWQiLg0KDQpPciBkaWQgeW91IG1l
YW46DQoNCiJpcyBlbXVsYXRlZCBpbiB0aGUga2VybmVsL0tWTSI/DQoNCj4gZ2V0cyBjb25mdXNl
ZCB3aXRoIGlycWNoaXBfaW5fa2VybmVsKCkuDQo+IA0KPiBPcHBvcnR1bmlzdGljYWxseSBob2lz
dCB0aGUgZGVmaW5pdGlvbiB1cCBpbiBpcnEuaCBzbyB0aGF0IGl0J3MNCj4gY28tbG9jYXRlZCB3
aXRoIG90aGVyICJmdWxsIiBpcnFjaGlwIGNvZGUgaW4gYW50aWNpcGF0aW9uIG9mIHdyYXBwaW5n
IGl0DQo+IGFsbCB3aXRoIGEgS2NvbmZpZy8jaWZkZWYuDQo+IA0KPiBObyBmdW5jdGlvbmFsIGNo
YW5nZSBpbnRlbmRlZC4NCj4gDQo+IFN1Z2dlc3RlZC1ieTogUGFvbG8gQm9uemluaSA8cGJvbnpp
bmlAcmVkaGF0LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vh
bmpjQGdvb2dsZS5jb20+DQoNCkFja2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5j
b20+DQo=

