Return-Path: <kvm+bounces-71656-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MCvQEObxnWk2SwQAu9opvQ
	(envelope-from <kvm+bounces-71656-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:45:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CC9CD18B8B9
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:45:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7F5B53058450
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E24922D877D;
	Tue, 24 Feb 2026 18:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z4kXzl+q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6322F239E80;
	Tue, 24 Feb 2026 18:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771958747; cv=fail; b=d3Wk5bCNr2AoPoG5ditIUC+Ku+PMXdOwe2h4bfgHVcU137FelMUSGqxHbrs0ZvHjDFn1lecXui/asCZDIoL3mDhMdB9t5bRZiez2EKTocKO5W8Y1HYeFCfwwJ7s9yJApAkhNKAaYWdW8FJaN0vpee4DZMfiCjuJmwqloQ19mZ/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771958747; c=relaxed/simple;
	bh=jb4i8CjEZpEp5od6ugWtzBg09dMoLxpmSKBlp1lUchg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WayAMBh8pmlDdZ2Hv2tlDiAohxasNnliCmh+rL0R638VD4/qkyA9MKWJUB1OYWM4vHnem1m2NsngmSxUrys5wh1vTP3q+gi6v/Mc7GCW2DxKzeuqklVDkmfsXtquux7pCZm6ZAbRAXG1/2OcaAAuPL3xDzj3ia70bqZAnIjWauM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z4kXzl+q; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771958745; x=1803494745;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jb4i8CjEZpEp5od6ugWtzBg09dMoLxpmSKBlp1lUchg=;
  b=Z4kXzl+qs4yP/mL2TvD67cd1fmAj+TJXRuv9Tw0hhDFTZO3lncd9xZ+E
   TgVc8gYk7XY9DbsxnoR9QtQlqOvvWHqRRfk8XxCARHxIO/XvE3S6a0dCV
   VWhb2QkltsHwfdAI2ibVLjmgEK/cpyl7o1K536PhUIJqfsdxzpyq7+/9o
   fUSQqOH39MjhhBg32c5kxrrpeN7u0SStPSORtaITURUvwQuumlhpp654o
   c+db6v+UZ/Vfe1aHDPZkAkz2Q/gNlm4RG7jxoPX6NVtJrfMXocHWCi1+y
   jVuWB21XUUqOtT/TZSkef4C5fBQZb6oHXrsuhdB84WC7g78Cr4vLVY70C
   w==;
X-CSE-ConnectionGUID: fhfOTc7rSkaX+SlezyQnPQ==
X-CSE-MsgGUID: /tu6w5m7SYm1HYjnzJI52g==
X-IronPort-AV: E=McAfee;i="6800,10657,11711"; a="72194035"
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="72194035"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 10:45:44 -0800
X-CSE-ConnectionGUID: QgONDhJ4Q2SRm/bcPPb8aA==
X-CSE-MsgGUID: JmrmZHd2QUiL5htdqtR6+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="220104202"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 10:45:44 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 10:45:43 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 24 Feb 2026 10:45:43 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.61) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 10:45:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EeyPUyG2SoSN5d32S1OsKUElD6Jt6Aq4i4oJy/1ON/Ddqlmnr/9pL/Q2hiln/EcDTYGnbIR0yHUBKfvDjmNwQBYUNtGLPYNcq7Ghcg/Wwkdv2Z3eSu2BV3HI/OGZqidNCImUjgnYckS+XuhUePT2KD1oL2PGdhrSLfzusgskBnotsr5ZIoC8hXqIYMovpYuyruAY5Qfuc6iuVk7QT2ty5yGA6QpH68v9DaQlEhHDkxHQITLJHJ1tgFxxdioSRFdmzRUd23URULJMHU3Luf9kX26S/O6qRKYMGxShIucWMUVNKUDt6R0K3/Gavv3mNApb/uc/QUtN/vPSBJrE/BW5hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jb4i8CjEZpEp5od6ugWtzBg09dMoLxpmSKBlp1lUchg=;
 b=Oo4W8F/Z/re04hhAxkoeWo2fIt6wrfEH+vCWQ70gI+YXj/q8pri8bdqbxaaXwZlhLnF+Ttm5voFXYij2NKO2kPjSPCYt4F8++2PEKtiKPjgX++sUbyUj4pxaB26XzwxYaT8JLuLmwqqQlRiFolA/FM399pyIGX5macVVbN0b1v8s97DY9wPx/dKCMAoX+4V9bOwhROFDK5Ij1M9xnmOZvdIllv6DLIcuCNyoe9vsWufbxeg1RiYybMU2DyHqclXxUjjf6Qvk+z5OYTkX5CWL/376+aRdILGcprDphmGxkvURHm+PhsJ/Ilq02G6rvZpZCGvScr6BzPcDPNgRcGpYmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DSVPR11MB9555.namprd11.prod.outlook.com (2603:10b6:8:388::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 18:45:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9632.010; Tue, 24 Feb 2026
 18:45:41 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "changyuanl@google.com"
	<changyuanl@google.com>, "Wu, Binbin" <binbin.wu@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@kernel.org" <tglx@kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
Subject: Re: [PATCH] KVM: TDX: Set SIGNIFCANT_INDEX flag for supported CPUIDs
Thread-Topic: [PATCH] KVM: TDX: Set SIGNIFCANT_INDEX flag for supported CPUIDs
Thread-Index: AQHcpQ2GOhqLqfK3/0a3C1hWKddGMrWRGDiAgABzA4CAAHjVAIAALWAA
Date: Tue, 24 Feb 2026 18:45:41 +0000
Message-ID: <d6820308325d5f8fee7918996ef98ab3f7b6ce6d.camel@intel.com>
References: <20260223214336.722463-1-changyuanl@google.com>
	 <213d614fe73e183a230c8f4e0c8fa1cc3d45df39.camel@intel.com>
	 <fd3b58fd-a450-471a-89a3-541c3f88c874@linux.intel.com>
	 <aZ3LxD5XMepnU8jh@google.com>
In-Reply-To: <aZ3LxD5XMepnU8jh@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DSVPR11MB9555:EE_
x-ms-office365-filtering-correlation-id: 80f30d36-2af8-43c2-11d0-08de73d4e945
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?emNJYWd1ajJtamNsRkJFNElqVFd0WGpPc3AzOGFNSFNlRU5ObHY5d3dWQy9u?=
 =?utf-8?B?UlJ5RDV0UzFtSkl2UzY3RWRZbm5BUDlZcTB5ZnJISEdOVXhvdFZGa1dnSzF3?=
 =?utf-8?B?Y2QxVjY0Szk3Q1dEMkhBVDJRQS9ZKy9qdHpZbnNldlBwaTdheTMzdjk5SGFB?=
 =?utf-8?B?TGZqbkJyeE9ramo0dENuRTErT1gzQkM0SjZlajNMYVg2eERqL2daZWV1dDUy?=
 =?utf-8?B?YUUyNHVjTTY1TDF1ZUp0ZCtpSHk4SGpVZW14VTV2ejIrcEwyRWZlWXAvVGFr?=
 =?utf-8?B?TGxUTU1aTFRkWDBqSk4zblMveE9yVnNqdjlNUEM4QUxOMGFoN0lhQVl0WG1v?=
 =?utf-8?B?MEFMZVRDM1h4dlVSUnVmRzRrQ0hvWGZNcTFKL3VrMjRwZXZjNkszZ291ME1B?=
 =?utf-8?B?cXFTUis1SEdVSUdSTk9lV2JyZE5yZkVJRHJQT0RjeGtXVld3TDlPK3V6dFFV?=
 =?utf-8?B?ZnM3MXIxY1ZqaHg1UDdWeG5aRVdrd1FVZkhEejhxdWhCeHBpcWp2Nk5MNERk?=
 =?utf-8?B?bGp4U0VYQlBpZmdPWnhHZzJxT3RLZEVjY2xTKzE3akk5MFhsdEhIb3JsUUV6?=
 =?utf-8?B?WUpHb2FlWjR0aFZaeVJmQXJEMWJ2c0lkUVZXMDFqMTQ2YS9aR1FKYzVRUG4z?=
 =?utf-8?B?VnM1NGRkQ2hXTlVQamRzODF1eGpuTE5vQ2FueFhXZmFSU0k5VzBkL25Ya1I1?=
 =?utf-8?B?WlFTNGJzbUNHbjA4Q01oWDhUYXplamRHU09KdnM3QXZUTjZ3cDh2VHNoOEJX?=
 =?utf-8?B?TjY4ZllSV0hud3ZwSDZEeWN2UzcyYjVTVFN4czBQbi81SmFtSisvK0NoYzRm?=
 =?utf-8?B?OVlDMGlPcmFMSnVYODlaTmNiRU8weU91VjFRN2FOa0xxVkZTTVo1L3Zmd1RP?=
 =?utf-8?B?ZzdWc1BxbVpGaytsQWFNRzF6TlpYY1l6elhxZHRxbjk4bjhBRFlFTWVIdmRw?=
 =?utf-8?B?aW1PbC9CQ05BRHBIY09ibWV5UU5QaVVETUlRL2dEOG12NnVuVTY5akdrNWEx?=
 =?utf-8?B?Y01nOGJLd0JPOW1zMnBUUlpoS0tRMkM0bG1uTVl3cTdpb3FHbjBLMU1oS3F4?=
 =?utf-8?B?SUhCNW9Od3NOdEd5VUdTTHJnWGFZamIwdE92ZzBqRGhOY2dLZDA1OVZ1Unlz?=
 =?utf-8?B?RnNZVjFHT0twQ3ZJY0pUaHBRcTRtRTcyb1hrdnJ0SEFQLzhzZmppRTAxZ3h1?=
 =?utf-8?B?R3h2eTQ5RDJpdTdUR3ZxdS9kZVN6QnFYRG85QVBIZStIb3pIS2tyQ0VWUnly?=
 =?utf-8?B?V1hjbWtOSHNpeVRsM2ZTaXR6cWF3UHpRYnZaRlBDVkZNL0hJUkx4eWhsOG9Q?=
 =?utf-8?B?ZWdXZzRFcEVqQXNKVS9BaWlHd2JGOEJVWmVwZVoyYTJ1U0xYZ1UvL1NudVNj?=
 =?utf-8?B?UTFqb2dIVDBEMDhBamJDdjc1YWRPeEZyZHEyUFVnOFgwQk0wY2JWR0QxWitV?=
 =?utf-8?B?eG1mZDZGQmJqeDIyb2t0N3BMdzFHRUdLZ3U1UmdvZFJOZTM3S3RlU1dweTZz?=
 =?utf-8?B?Wmx2U01lMUQrSmZTQ3hxdVNXcnRIMU1yaWsyQ1Y0MHlMeHpCVEpkWjhMQ3dX?=
 =?utf-8?B?UTNVUHI3c0w5Rk1GTzVwWjRjR1BoN3Yybit6MERGRlBZSTZsV2x3SEtwaS9h?=
 =?utf-8?B?OFhST1Y2Z3hXQ1JQWDAvNmRRQTJ0U3IyaWFpOFFjQW9CdC9XSzkzek1zaFJK?=
 =?utf-8?B?RnJQbjlNaFlUb0hWOUVwbE1XcE9idit5ZkZtUVE5V1d2WXZhQTlMSURtRGk2?=
 =?utf-8?B?eXY1ZGMyaEpuUDVHY20yT2FueC9tOXpNOTR5S0V0dlZGK1hFMFdpWlpxb3Zz?=
 =?utf-8?B?Q004bWFsSHF6WXVXdjVHSjNseUgxWjRuekxNdVl5bjE3TUZPRU5nV3J2SFc4?=
 =?utf-8?B?dWU2SGd1blovNzlORGNDM29nY1dJYktZNm9IdUV0V0hTZnVXUFRtd3FBd3hU?=
 =?utf-8?B?SzFGaXVoTDQ4N1R5RG14aE16NGpZZ01LcjZaeTllUTBJeWJUTXV1SzcvT21z?=
 =?utf-8?B?emtvWlNhQjFMUlBFWE84bUlaUG5kSTBVWXZMc2QxK3pRMGh6Y3d2NjM5eERU?=
 =?utf-8?B?b1BsNjhnaWlyUHMvZWZEUVY4UThFUFZROW13QTI0SzRpVUN4YW13cnFhWGx0?=
 =?utf-8?B?bmJKcTBnNHR1bDhaUUVKUUlyQzhRaStSdFBKZVE2N2NDUXFlaUhGNmhFdE5M?=
 =?utf-8?Q?ftNxWD1bv0b4W4Ohvw/bRFw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VVhsdlVNTFVOZ3J4T2thTXlHUmpqeEY4ZVRob2Q5WUUwT2xTV3BlN3R2T1lI?=
 =?utf-8?B?UWRLN3MxNHZsU2xWdys3WTY5YXdBTnFkdjBKTTN4bTE1L1BUby9JYmZueVQv?=
 =?utf-8?B?N1UvVjFGcm5TNUh2cUJ6eExtR0hMZVZBcXhtQ01VUnR3TXlrd0RXek5HWDln?=
 =?utf-8?B?ckw5UkVTM08ydXgyeTdPbkVtNDVrbzhJdHBQSDRiRVBLNlFsNUpNbHNBV2RC?=
 =?utf-8?B?WEVaY0k3THkyWlNKL3d0MU5aQ3p0QURoekp0WWs4OG9zaXk2MHh1QmZWQ0lT?=
 =?utf-8?B?WEhrZXVrSXVqVndZZXk0b1lMbkhuUWZDQXhZZFArM2xncnc0dThNYnYwRXkz?=
 =?utf-8?B?K3BnUGNaSHM0VXVsWmFXejJGdHBDMFVjR2xPM0lpYWtNQlhCdTJGN2FOak1t?=
 =?utf-8?B?QVVCbFhveVFTbU52OGJWR3FpaXJpdldqTnF4V2cwaUQ5QTBFL3JMTDkrdVRO?=
 =?utf-8?B?R0RqRTllUUVSSGtRdHBuTUZUZ3FjV0dseTh2LzN2WCs5OUFXS2FlMWZzME95?=
 =?utf-8?B?cHY1RmltdEFuS1owZ1NqOStjYTdHdExSMlE5d0dFeWM4anVPYkdsdytpSTBm?=
 =?utf-8?B?cFZjbUNYZCtpYk9jbHpNcDQyckNZYjkxaVhtbzZHa1lxaWZUSjJjalZGZ3Ay?=
 =?utf-8?B?S0hSRFpMNXA3cG05N1J6cng0ZFZGWTNlYU1jVlM2b0hvalpTaW1YeWZQNHZa?=
 =?utf-8?B?YVIrOHoybXVmaUE3TGEya1VzdXJIbWhDMlJUUFB3UDRFelZ2N2Y0aTVkeGV5?=
 =?utf-8?B?dnFUeEFncG1kQzNUcVViR1NsWTJFMThINS9NekxVYmxjWlFsZUVkNjBNayts?=
 =?utf-8?B?aGFUWWgvWjFFdXVTVXJvMFBkaWVPN29KdUppMnJQZ1RoaFE1SG5TcXBBRTh6?=
 =?utf-8?B?TTMzVDd3WSszYkZCOHRLVEhvUkRhS0FQM2xqODBiR24yb1hBSzR5aWl3cisr?=
 =?utf-8?B?a0JINnl1bXF4dExEcHowSXRCWWljNkoySWxETk9mSXNpTkluU05HL3FSczRs?=
 =?utf-8?B?TE82bXVJYktXZUpwSjJJTEtYcUlIcURINDdCbUR6cnRvOWxZZ3dacXBaLzNm?=
 =?utf-8?B?ZXk2T0d5VDlHRTVYVHovMTdhSlNkNnVJOXVBSDhHWjdOZ3FDRitBOHNxTnNq?=
 =?utf-8?B?eFU2TlRLYUVyanNWa3N2T2pYbG1nK3pzUlhmT1RIUCtkL0NIWlRaOFlxRUNw?=
 =?utf-8?B?M2JVaHJ5N2ZlUWtXYitGQjBMU1BmL3cxN3BVbWxyYzd1NkY2alJlUjlmRWV3?=
 =?utf-8?B?cUhTTm1UWFNpT2FNa2ljZHIrMkFkcVBpaE8xcnFWaGczSTBsYW45Y3laL0JB?=
 =?utf-8?B?dEhLTnZWVkFXeWN5aC93bkFjallabURQQWFJMHFYTTFSTWlQeVpYaGM2YXJn?=
 =?utf-8?B?MTNZVENMR2FWR2RvZ3E2RER4SjhlbEpRMzk3TUZRNVRTaEVXaTVoSGprUmN2?=
 =?utf-8?B?dXdlLzN5NTVSOVQvNURqbGNVSU9lZ0diMmh5ZWxGMkVEQksrUGYzUGY0bVlK?=
 =?utf-8?B?MTJXbEs2SGtJc1pDOTBDbHVZU2d0Mm92bmxLeldJd3VhQ1dQZktIK21qdVln?=
 =?utf-8?B?REZjSnpHenBwOUZRU0VHd0YyTVFGb2lTeGlvc0ZPN3I2ZXlaeStLcVdtdEpz?=
 =?utf-8?B?a2VseEI1WjhkR3hYQWE5cmw1bnF4cU9BZEloTWhlZWFac21PbmtFOWJxeUtT?=
 =?utf-8?B?bUl5anREUDVRTTRHOWl5R3lPcDdPMlRjSWROd1c0UHgraTF3OUtTbjYxZmpO?=
 =?utf-8?B?RVpNaExxQWR5K2QxMDZQWm1zNDRKb3c1enUwaWJVc1lzdnMyc3l3QitqdWxl?=
 =?utf-8?B?QWwxaHBJOEwrVHJvOStldzA4d3FWRjVlQ3RvRXJvQ3UwREZNa1IrR3BleVlq?=
 =?utf-8?B?dTZyeU8xNGUxQWYwYmw1TU4xY0JIYXFjVm9zTXRiN1FXZjV6VWlPa0RlMnZN?=
 =?utf-8?B?bXhodDhUeW5DMXZLNUhhNExtK2E1VnpnblBuMEFnT0RsTERxTER5NWVyQklz?=
 =?utf-8?B?YllZaTVBL3JNVnlHTGRha0RUNDUrRzA5OGVDM0JUVllFUUd1Ty9Gdk4rZk5u?=
 =?utf-8?B?MFdLc3NaRXBSSDhjTnFaK0RiQm9NOXl5MXdrb2MwK1hIQUczK1JSQVFCeDA5?=
 =?utf-8?B?bHVMeGJuOGsycURta2ZaWTFKNlVqelhJUkNmOEZXYW92ZkgwZFhLdE5XQW5D?=
 =?utf-8?B?SnU0c0xLWVpzWXVYS2Zxbkw0a0M0K0Z4K2ZJZTVqdlU1eEhmdGhhanU5MEht?=
 =?utf-8?B?T0NoY0J0T3YvbDJRcjVXOGhHMmZOMUlsZ21yaXYydHM2VnNRUnpnMEtjaUZ6?=
 =?utf-8?B?UWhpSmRVckpnSTEzRFZQajhSNDV0Und5WDZ2a1pZcmN6ZTZ0bkZQbHBFcTdD?=
 =?utf-8?Q?OyrjJeQNPWklN+7c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8D538040EF1B844B5DD570D187F4866@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f30d36-2af8-43c2-11d0-08de73d4e945
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 18:45:41.6652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NDnLOmPTXR4W62Snuowzhba3gEWIdm30YG3UpOkGeWJXcLq6t+j5s9ADSU0BlnXAbWmX1VhMDqn87lDHKngDfiZktgl6vsgaPaDZFe/q0Cs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR11MB9555
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71656-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: CC9CD18B8B9
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTI0IGF0IDA4OjAzIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEJ1dCBhZGRpbmcgdGhlIGNvbnNpc3RlbmN5IGNoZWNrIGhlcmUgd291bGQgY2F1
c2UgY29tcGF0aWJpbGl0eSBpc3N1ZS4NCj4gPiBHZW5lcmFsbHksIGlmIGEgbmV3IENQVUlEIGlu
ZGV4ZWQgZnVuY3Rpb24gaXMgYWRkZWQgZm9yIHNvbWUgbmV3IENQVSBhbmQNCj4gPiB0aGUgVERY
IG1vZHVsZSByZXBvcnRzIGl0LCBLVk0gdmVyc2lvbnMgd2l0aG91dCB0aGUgQ1BVSUQgZnVuY3Rp
b24gaW4NCj4gPiB0aGUgbGlzdCB3aWxsIHRyaWdnZXIgdGhlIHdhcm5pbmcuDQo+IA0KPiBJTU8s
IHRoYXQncyBhIGdvb2QgdGhpbmcgYW5kIHdvcmtpbmcgYXMgaW50ZW5kZWQuwqAgV0FSTnMgYXJl
bid0IGluaGVyZW50bHkNCj4gZXZpbC4gV2hpbGUgdGhlIGdvYWwgaXMgdG8gYmUgV0FSTi1mcmVl
LCBpbiB0aGlzIGNhc2UgdHJpZ2dlcmluZyB0aGUgV0FSTiBpZg0KPiB0aGUgVERYIE1vZHVsZSBp
cyB1cGRhdGVkIChvciBuZXcgc2lsaWNvbiBhcnJpdmVzKSBpcyBkZXNpcmFibGUsIGJlY2F1c2Ug
aXQNCj4gYWxlcnRzIHVzIHRvIHRoYXQgbmV3IGJlaGF2aW9yLCBzbyB0aGF0IHdlIGNhbiBnbyB1
cGRhdGUgS1ZNLg0KPiANCj4gQnV0IHdlIHNob3VsZCAiZml4IiAweDIzIGFuZCAweDI0IGJlZm9y
ZSBsYW5kaW5nIHRoaXMgcGF0Y2guDQoNCldvdWxkIHdlIGJhY2twb3J0IHRob3NlIGNoYW5nZXMg
dGhlbj8gSSB3b3VsZCB1c3VhbGx5IHRoaW5rIHRoYXQgaWYgdGhlIFREWA0KbW9kdWxlIHVwZGF0
ZXMgaW4gc3VjaCBhIHdheSB0aGF0IHRyaWdnZXJzIGEgd2FybmluZyBpbiB0aGUga2VybmVsIHRo
ZW4gaXQncyBhDQpURFggbW9kdWxlIGJ1Zy4NCg0KSSdtIHN0aWxsIG5vdCBjbGVhciBvbiB0aGUg
aW1wYWN0IG9mIHRoaXMgb25lLCBidXQgYXNzdW1pbmcgaXQncyBub3QgdG9vDQpzZXJpb3VzLCBj
b3VsZCB3ZSBkaXNjdXNzIHRoZSBXSVAgQ1BVSUQgYml0IFREWCBhcmNoIHN0dWZmIGluIFBVQ0sg
YmVmb3JlIGRvaW5nDQp0aGUgY2hhbmdlPw0KDQpXZSB3ZXJlIGluaXRpYWxseSBmb2N1c2luZyBv
biB0aGUgcHJvYmxlbSBvZiBDUFVJRCBiaXRzIHRoYXQgYWZmZWN0IGhvc3Qgc3RhdGUsDQpidXQg
dGhlbiByZWNlbnRseSB3ZXJlIGRpc2N1c3NpbmcgaG93IG1hbnkgb3RoZXIgY2F0ZWdvcmllcyBv
ZiBwb3RlbnRpYWwNCnByb2JsZW1zIHdlIHNob3VsZCB3b3JyeSBhYm91dCBhdCB0aGlzIHBvaW50
LiBTbyBpdCB3b3VsZCBiZSBnb29kIHRvIHVuZGVyc3RhbmQNCnRoZSBpbXBhY3QgaGVyZS4NCg0K
SWYgdGhpcyB3YXJuIGlzIGEgdHJlbmQgdG93YXJkcyBkb3VibGluZyBiYWNrIG9uIHRoZSBpbml0
aWFsIGRlY2lzaW9uIHRvIGV4cG9zZQ0KdGhlIENQVUlEIGludGVyZmFjZSB0byB1c2Vyc3BhY2Us
IHdoaWNoIEkgdGhpbmsgaXMgc3RpbGwgZG9hYmxlIGFuZCB3b3J0aA0KY29uc2lkZXJpbmcgYXMg
YW4gYWx0ZXJuYXRpdmUsIHRoZW4gdGhpcyBhbHNvIGFmZmVjdHMgaG93IHdlIHdvdWxkIHdhbnQg
dGhlIFREWA0KbW9kdWxlIGNoYW5nZXMgdG8gd29yay4NCg==

