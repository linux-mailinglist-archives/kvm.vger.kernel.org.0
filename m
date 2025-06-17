Return-Path: <kvm+bounces-49647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B4CADBE16
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 02:25:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31BD2168DCA
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 00:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A52E51494D8;
	Tue, 17 Jun 2025 00:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hzNJPtNR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0074DC147;
	Tue, 17 Jun 2025 00:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750119940; cv=fail; b=MMSvfIV+RUm7J7nhWHa+TkJV1rOcAMxCnkWJcuOZmmZLXNBhKk66vASeVwxMSZs31mEzCyCPzTqSZhPm05BgqhTEZP8LjKjgQhovb8g0xEmuKQIKJVrLRPAo2yPjf0xJHYsu3KXieEIDIQWVXMpJ6G3C1P71mrwSwl69gpD3Cs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750119940; c=relaxed/simple;
	bh=ZCLmlUXAo9RXpF6rAiY6c/XV4uIFEH994NJHuE59NwA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Dh8fYb0dLw8BXD/Nzj+lARxXpf21hYXfwJ+qY5vFJ4JzEaMMCEpDcyc63ZViEiXWmIfepeCHropTxbngxfyF/n3gqeLNQ9zqxbnzWtuVwmqqA0QwuReW2Vb8OQn/P4IB0/pBE7FIjHyi6OPp9A8ZNyoERFgbCI3B7C+N2vBxWxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hzNJPtNR; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750119939; x=1781655939;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZCLmlUXAo9RXpF6rAiY6c/XV4uIFEH994NJHuE59NwA=;
  b=hzNJPtNRB4H3Sh7gjVKzQHuCUNhsH3IuN3fL5rjFaVCZaWTsYxp0srUR
   bPtP6f0AtvrGaSY2UDf7BF4a4ywS8BNIob9h2C+3bMX5ekw/6orpBx9cZ
   xqDrgEuR7lT0VNEQOzmDrga1SswTpD6FVUZi8no+kcPdrblqPtSOYWnh4
   3crhSl6yk2sGG1LXHH5DDkti2JNk1ywSc5bmJ687ViT8wHTggj/q5/FxP
   at7+R7EHUrsndeZMW/sH+GaKv6qwkuI5KRE9iOWN8xPu5lEE435UB1OfT
   Hhn78KxAKyDshHeZcUB10x8Cwdq94mP/v9QlsV0fI5252iVRGycgaV2hy
   g==;
X-CSE-ConnectionGUID: mvcOOMrpQZm0Zbnhb7QAiA==
X-CSE-MsgGUID: eAxUxwdTRIy6pnQiPIdukQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="52193203"
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="52193203"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 17:25:38 -0700
X-CSE-ConnectionGUID: EsZUfdPZRy6VQqWpSenqBQ==
X-CSE-MsgGUID: Xa8u79xERaKBMXJvXGt/cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="148508758"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 17:25:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 17:25:37 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 16 Jun 2025 17:25:37 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.61)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 17:25:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YSofTP9Ld4Y/bZet0bUedSoBmqMIp2AU82ba6+6PNYRhyvlJ0xe6Jc/0h4+MX5/MA0OEIAJJkvIjD1kTFcAnAtlQteaKypVk9ViaBoA/iTTF7so7MDvFCXgigP4Kp5D5+8kGrhpUlIlSkVJ7Kmp8VGAtp2QMF0jqsE2wOigZGaTR1hrHnawOdCBCuHmzVVuxi4mbfBzY/hgit479YsMiRjEMO+1nQe+Qg6UQ2zSe8zIHCag6RVlJ66gmsbB61381MxoMuXIHhZnZvPELS6QV/6z88U03Yhjif9Aj9t8MBWjSnCbUoxNFKihtCycoO0XEDv+qpWa33AaVsMFiuVXong==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCLmlUXAo9RXpF6rAiY6c/XV4uIFEH994NJHuE59NwA=;
 b=s/Imkt7AXt4YaPTpyxGHjrF1Ij49jvEoEXmyKK4666+/xTR/x2vG7WNHrddlO8b/+tiLuGBCbdOUrm+Fdlip7Kt5cxZ4PO9dh+NXB/RUSYA8bc1MXA4bp64x6lazs1yCZypO6dCBzkMiCRQ1tAEdBg7IsGZnsB/NzHMwxTRfif3k8VN1Wl6JC2Kae9j7WR2vOi948WBIqKoVkWdFKVizm6BCUH38P4Qn6mNf+SCBRVs3jOfihwBzipVrk6o1SmdIpJ4fS8WAgmzahe67dskjSCmd4xSf4HRsTeiNH1vwi47AYYko0djdiU7IhONqY8ib14333n+giXyq0sTac4X/zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB7429.namprd11.prod.outlook.com (2603:10b6:510:270::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Tue, 17 Jun
 2025 00:25:20 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.018; Tue, 17 Jun 2025
 00:25:20 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Du, Fan" <fan.du@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA8feA
Date: Tue, 17 Jun 2025 00:25:20 +0000
Message-ID: <6afc4b972858db7c98f682ec9f7975e2ca38db31.camel@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
	 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
	 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
	 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
	 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
In-Reply-To: <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB7429:EE_
x-ms-office365-filtering-correlation-id: 0d2c61a5-42d7-49c4-3fce-08ddad35719c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Y0NBVTVTZnJWRnBIYmtXcXJueC9vczJ5VUw1clcvNE1FeElxcDAwY0hvMTJl?=
 =?utf-8?B?VEZpbWtWcWxQQ2VzRlBoSTBFak5CeHcyWEsxU01zSFNualQ0K0VUUmJmdHNC?=
 =?utf-8?B?ajdZUkQ4M3dVdndZZ1VJdjZKVmV3RXd4L1Vnb2w4c0R1STBaRkkvWHdFQ2VZ?=
 =?utf-8?B?NGtmWEExRktNU2gvZndLcHR3OWNzYmlIUnBjSE41anVTRGc3MTJIcktPRmgv?=
 =?utf-8?B?c2wxQjhtZHE3ak93VmN3WDhPZE1TRCs3UnlOY0VYcFNPQnhXQ0VoWUl5dWFL?=
 =?utf-8?B?RUxDT3RBTUczc0hMQTN6NGw2MlhTL1ZRcHNKR2VkbWlmVGM4NXgraWFNTnN0?=
 =?utf-8?B?S0FGUjBQVjJvSUhpT0QvQkRHQTlVT05qL29mSDZwSmlpWVllYi9ybEtEcERy?=
 =?utf-8?B?TDlsOVZsN3A0ZnVCKyswclhkS1FGeFZ4cDREb1Rma202OWRLNHBFK0xBWXV4?=
 =?utf-8?B?Ty9aMU85Y29jbi9Oc2lNYm1oSmE2WnVtUnlQbytsMTd2SWpnUjNCNzZtZlhp?=
 =?utf-8?B?VmdTWjJNRGU2c1QwZmJhQks4K2xvSUp6cDFlV25WVkdwNnBmSnN5Q1pWQ2gv?=
 =?utf-8?B?VzIrR1ZHR0NCVGI4ZE5VVG5Scmp1MGZaYytHK042aURoa0IxZkJYeHRGRzd2?=
 =?utf-8?B?bUpYdHRRa1JWcVFvdC9OYUs4ZEZGOW82QVlhbmxUV0RKSHF3VFgzeWpPTzFG?=
 =?utf-8?B?cXBpc2hBQjZ2OXpkamNuNEJ1TmNKUXFJd3VhcFowTmpVOG5pTHdIcjQvbTR4?=
 =?utf-8?B?QlozbEVxT3RNVktmMmNJcU02VVhBUTkrMVhoRnhKZUp3dnRGcmg2SHpqc0Nt?=
 =?utf-8?B?VWh1REF6NEhBUG1zL0MzdDRSL05nblpwelN0Qy9COVkzcUR0RTFnVnovYkp5?=
 =?utf-8?B?Mmx5ZE9reHFHbjRHZDRmK0lCTUtUcXpGUkhXdnRLZlNtRUZoY1d3bTVaY1Br?=
 =?utf-8?B?clF6UkprdjVYUTg0TUNta3RxYUM4UFdENmxtdWVwK29xSyswSGpEUmdTdTRV?=
 =?utf-8?B?WWlmakJzaW5TWDJuaEZCWC9GQUk0SFBiTXdUUzRqcDZZc2svWDNYdDRTeHd3?=
 =?utf-8?B?ak8wemRuUmd5UlI4L2VNbXkvS0VrTjJERjdMMkRDUlhMLzh6ZG5aT3QvWXQ4?=
 =?utf-8?B?L25kTU8yUkEvdlZ1dkwreTYxTHdmcFV4OFRqOWI4Q0VHYjZUV1dZYnMrOURT?=
 =?utf-8?B?bjR5aFo0YVFwYVdRS3NwdkJzc2J1RHJzZUpGRlo3RmN3djYzT1B5eFBOTU0y?=
 =?utf-8?B?czQ3UXFFQ1FDTkpoOW5XKzREQmhCaFpaR3dLZVVOV01zWHZiMkUxZHNxN3l0?=
 =?utf-8?B?WHp0T1JUZm02ZUdZRDR1UWIxT0d1T1oyaWcxcWhhM0o0L2xuc1J5bzJOVjAv?=
 =?utf-8?B?REUzRzBqTjZaK1haMm9qUDhVQ2xGdS9vOTlIZURmVkM3ZjNlWTBpeWl4am5u?=
 =?utf-8?B?SFp3UU5ON05wcFkyUG1xTU9vaERRYmRoTW9ud3VNUlk0YzBEdHNhdUxnb3Iw?=
 =?utf-8?B?cW82dUlzVFRlYmhQWDAyYkdpT0FDZEhFelp6eDlUNTQyaC90MWdpOHFGRDln?=
 =?utf-8?B?ejZBUGZXQlZnU3ZFb29ObW0wQ3d5cjNwRlNLQlk3Mml6bUdwWERPSkpoTlg4?=
 =?utf-8?B?VFJpL1d2WkJsVGFobzE3SlhHK2hWYjIraEJrWmNCQnlpYVZjT0gvekNGSGhQ?=
 =?utf-8?B?MDdnc2svY1ZTOHBEeldkZ2FZRy9peThiU25TcWtsZzJBL0h0MEJTNytWVjBI?=
 =?utf-8?B?Z3Npc1gwa1Uva09WQ3BVUkU3YVdPdkYxdmFQREtEak9tdERtVkRjdGJjZ0w4?=
 =?utf-8?B?eDZ2QzZXVUxNZnlqQnlDNlJDbUpEMW05d2tKbXU3YldIZExHVUUrL25NbzV3?=
 =?utf-8?B?UisrMkNoWTVDUGJLVHlVU3QvUDJYYldueVdjUE9VZFdISFhxc0Mzb1MvUnVq?=
 =?utf-8?B?eUc2eXlpYUpVVUZOdUxkdUNFL01KWHBiZlEvNjdQdnc2M0xmMGV4L2ZmdFBJ?=
 =?utf-8?B?eEpra3M3NUZBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NTNXakx0alVkMnhrS3JNRkZQeXlMZW03eHBzVzNYdmFrUm9RWHRabmNrMkc2?=
 =?utf-8?B?aDMxM0VqV1JXdmRVSVFrenB3d01kTzBsK3JJQjZjVUo2Rkt3WjI3bU9UVVU4?=
 =?utf-8?B?SXJHME01OHlON0ZsMm9XZDYxcmNvcnRlU0lETDJaVExsTnVMN0JjblM5ZkRl?=
 =?utf-8?B?ZUlVYzd1UlNHY3d6VWtjRzA3dGRML3RVb1dGbEl6VUJabTdORzYrRlVnZ3Jr?=
 =?utf-8?B?Y244M0RtMmJ6RHlnVHBkZDlzalZPdnlLOEN4OUlWUFQ4MjVyTHNsVERvMkF0?=
 =?utf-8?B?NWtUalZFaU84eXF5SklIOTFZUUpLbkhlb1pNNWREYjNzeDJiaU9DTnRBMTFx?=
 =?utf-8?B?L3ljSDhPQmFLaXh1QUEvT1hrbGZrZ3loQ1JkNUJPQTZKRmRTTkhXdXRCQWQr?=
 =?utf-8?B?aTVqYmlJeWs4bkoxbTdkbEVhUm5TTVcxU051SXp3Q1VLYnpVTlNRTGk0ZzZw?=
 =?utf-8?B?QW02MDNMK2pCcjlnbFR5aFdtb0lTYjVpQmJ6NVhpNzJ3MlFEOEcyV3MvZjNL?=
 =?utf-8?B?SHZwT2NIaS8yZXk1c3VPQXJ5TWE5SVV6cFNwOXM3U1VYRGRMK0Nrdk90LzJF?=
 =?utf-8?B?UUZicjZFYkVvTlUwU0wxeU5QY1djQVdOM3BGeTNpblJnYU5wbXhTcEM4SHQ3?=
 =?utf-8?B?ZEh1b0k0dnRqQVVWV3VMWEhCdmlHV2tEVlRHSnRlQkNPZngwa3VKalFKcnds?=
 =?utf-8?B?WFZxQzVsRTJUN3loOUlYajZpSWtNR0VodnNvamRlK0k0emxhLzkzeFU5ajBl?=
 =?utf-8?B?YkVQTkYwMG1Vd1R6NExFSWFkSFF2M2RRMGljT3Frd1MyZVZlQ0syMEFYZ3g4?=
 =?utf-8?B?K1hEOUV4YW5LUUgzdE4wV1RicC9NNzdsODRpNUhES1NCMDlZYW5LQVJnbVF5?=
 =?utf-8?B?NndFdW9wN3l1eldlRmxKWUZZSFNEZzZjQzY5Z0NSZm5Fa3RMRVlIUE1TaTJ2?=
 =?utf-8?B?MHJHRllXS3MyL0RpN003czlHUERTNExFa1l2RGdZZjB5UXdHU09qeUNqYXlo?=
 =?utf-8?B?THIybndRT2NNM0hHTGI4Z0l2MHI3b2xrUmlIUWMxQ3BmekZPVEdQcjZ4dXd5?=
 =?utf-8?B?dGVPbHZ2TWNJSGtvSW44dXJRdldTNXpTOWd4SEhVK3EzUXFvSUo1WHU5SWtG?=
 =?utf-8?B?STNNN2k5c2d1VGh3QytCeGp3dHI2UkRtVExjZGw5UWJGTHhIdzh2QitsVzhl?=
 =?utf-8?B?MGtnbFhjcEpaN1hHL0Y0T2o0bTJldk44MHJ0NGpidnd0Y1gzMnpEUjgxTnJ4?=
 =?utf-8?B?bFA2MXhxRzNvRzNTWmo4cW9mUW1EVGNERzRhcS9rcDB5S3NWTHI3WktGL005?=
 =?utf-8?B?eE9rbndKUmlac3hyYi9FQVdhTzFHOHduczFZR1FmR3pVUkxKcmRQOEVCcGoy?=
 =?utf-8?B?U29LaXByQ3hKckJTWEFsZFpIODNzcXBHRTdWSWhuRkN2VUNBSG9vdDdBamEw?=
 =?utf-8?B?WXdWU2Z2UkIzYzBERit6dW1rTWRYV2NQdUllbmJ2SUdsYThMY1IvQnBHNEtY?=
 =?utf-8?B?d24vdnB5VHYvYkdBaHd3ZXZvaHJGQTJLbHRrZTBPUXJhcDdwNk5TcWIwQnFV?=
 =?utf-8?B?M29QT1gxUEFHMlBoaW5sYVdrdE9Yem9oOEJQamFlUGFzUlJsVUdISmU4czlB?=
 =?utf-8?B?WWFhQ0FNa0V5UU91ZFU5bXczdFJDVVYyOGdDdmlFOG1Bb2h0WGxLOXZCeWY4?=
 =?utf-8?B?LzZQV0Q3ZmpTZDZQQWJlc0plU1R5eitMNEYvLytQQmJ2NkVPZlVsaUxyYW41?=
 =?utf-8?B?cE44TUNHckxXYno1Z2JsbnNPVVd4eVkxQWRYak9wMVZjdGRnU1hRUlYvTVdR?=
 =?utf-8?B?bmtLVk5ZaTNiWW5WeFh5V29lKzBhTXh5TitHR3BVQ1E2REVCMWRlbE1DYlJq?=
 =?utf-8?B?ZkdRTzBHYmJUbTVLcVNPbUE4ei9BYXVSYjhnVE9IUmFDS0pINEVoZzM3TCtH?=
 =?utf-8?B?UVpBb2hjdlRjMUpaUHlKWEIySTdZWTZlM2FnQzdub1h3NWIwUElIQ3ZwbUR1?=
 =?utf-8?B?N2I1K2tsU1VpNStJNXRodWZwSWE0VUwzU2k1OEJSN1p1YnpFMmZ4ZWZVK0VL?=
 =?utf-8?B?OWU2RnRaYkg5eFBuckp2SlN4VXE5YU5JRG1RSlUrL2I5R21ld3JsaGlqd2Rl?=
 =?utf-8?B?OVVCVit1YXV1eVJUYXBoRklUWlYycExPSW9XeElNOUdxenVGRmErYkxOdWJN?=
 =?utf-8?Q?4Fp7cdzkfEIoNrf/LVPF7CE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <461D018C2C283A40AAE7F9E48A36D730@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d2c61a5-42d7-49c4-3fce-08ddad35719c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2025 00:25:20.6836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2P+klTg5MEoWQbP02139CCrn3z3+SH9yr+VVdKyT04TnW72cELt7zIzD28w+1bmlwBHvU4FJACo4ofx6VQcUKBdjkjGIjfXdvhSooJKcauU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7429
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTE2IGF0IDE3OjU5ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBG
ZXcgcXVlc3Rpb25zIGhlcmU6DQo+ID4gMSkgSXQgc291bmRzIGxpa2UgdGhlIGZhaWx1cmUgdG8g
cmVtb3ZlIGVudHJpZXMgZnJvbSBTRVBUIGNvdWxkIG9ubHkNCj4gPiBiZSBkdWUgdG8gYnVncyBp
biB0aGUgS1ZNL1REWCBtb2R1bGUsDQo+IFllcy4NCg0KQSBURFggbW9kdWxlIGJ1ZyBjb3VsZCBo
eXBvdGhldGljYWxseSBjYXVzZSBtYW55IHR5cGVzIG9mIGhvc3QgaW5zdGFiaWxpdHkuIFdlDQpz
aG91bGQgY29uc2lkZXIgYSBsaXR0bGUgbW9yZSBvbiB0aGUgY29udGV4dCBmb3IgdGhlIHJpc2sg
YmVmb3JlIHdlIG1ha2UgVERYIGENCnNwZWNpYWwgY2FzZSBvciBhZGQgbXVjaCBlcnJvciBoYW5k
bGluZyBjb2RlIGFyb3VuZCBpdC4gSWYgd2UgZW5kIHVwIHdpdGggYQ0KYnVuY2ggb2YgcGFyYW5v
aWQgZXJyb3IgaGFuZGxpbmcgY29kZSBhcm91bmQgVERYIG1vZHVsZSBiZWhhdmlvciwgdGhhdCBp
cyBnb2luZw0KdG8gYmUgYSBwYWluIHRvIG1haW50YWluLiBBbmQgZXJyb3IgaGFuZGxpbmcgY29k
ZSBmb3IgcmFyZSBjYXNlcyB3aWxsIGJlIGhhcmQgdG8NCnJlbW92ZS4NCg0KV2UndmUgaGFkIGEg
aGlzdG9yeSBvZiB1bnJlbGlhYmxlIHBhZ2UgcmVtb3ZhbCBkdXJpbmcgdGhlIGJhc2Ugc2VyaWVz
DQpkZXZlbG9wbWVudC4gV2hlbiB3ZSBzb2x2ZWQgdGhlIHByb2JsZW0sIGl0IHdhcyBub3QgY29t
cGxldGVseSBjbGVhbiAodGhvdWdoDQptb3JlIG9uIHRoZSBndWVzdCBhZmZlY3Rpbmcgc2lkZSku
IFNvIEkgdGhpbmsgdGhlcmUgaXMgcmVhc29uIHRvIGJlIGNvbmNlcm5lZC4NCkJ1dCB0aGlzIHNo
b3VsZCB3b3JrIHJlbGlhYmx5IGluIHRoZW9yeS4gU28gSSdtIG5vdCBzdXJlIHdlIHNob3VsZCB1
c2UgdGhlIGVycm9yDQpjYXNlIGFzIGEgaGFyZCByZWFzb24uIEluc3RlYWQgbWF5YmUgd2Ugc2hv
dWxkIGZvY3VzIG9uIGhvdyB0byBtYWtlIGl0IGxlc3MNCmxpa2VseSB0byBoYXZlIGFuIGVycm9y
LiBVbmxlc3MgdGhlcmUgaXMgYSBzcGVjaWZpYyBjYXNlIHlvdSBhcmUgY29uc2lkZXJpbmcsDQpZ
YW4/DQoNClRoYXQgc2FpZCwgSSB0aGluayB0aGUgcmVmY291bnRpbmcgb24gZXJyb3IgKG9yIHJh
dGhlciwgbm90aWZ5aW5nIGd1ZXN0bWVtZmQgb24NCmVycm9yIGRvIGxldCBpdCBoYW5kbGUgdGhl
IGVycm9yIGhvdyBpdCB3YW50cykgaXMgYSBmaW5lIHNvbHV0aW9uLiBBcyBsb25nIGFzIGl0DQpk
b2Vzbid0IHRha2UgbXVjaCBjb2RlIChhcyBpcyB0aGUgY2FzZSBmb3IgWWFuJ3MgUE9DKS4NCg0K
PiANCj4gPiBob3cgcmVsaWFibGUgd291bGQgaXQgYmUgdG8NCj4gPiBjb250aW51ZSBleGVjdXRp
bmcgVERYIFZNcyBvbiB0aGUgaG9zdCBvbmNlIHN1Y2ggYnVncyBhcmUgaGl0Pw0KPiBUaGUgVERY
IFZNcyB3aWxsIGJlIGtpbGxlZC4gSG93ZXZlciwgdGhlIHByaXZhdGUgcGFnZXMgYXJlIHN0aWxs
IG1hcHBlZCBpbiB0aGUNCj4gU0VQVCAoYWZ0ZXIgdGhlIHVubWFwcGluZyBmYWlsdXJlKS4NCj4g
VGhlIHRlYXJkb3duIGZsb3cgZm9yIFREWCBWTSBpczoNCj4gDQo+IGRvX2V4aXQNCj4gwqAgfC0+
ZXhpdF9maWxlcw0KPiDCoMKgwqDCoCB8LT5rdm1fZ21lbV9yZWxlYXNlID09PiAoMSkgVW5tYXAg
Z3Vlc3QgcGFnZXMgDQo+IMKgwqDCoMKgIHwtPnJlbGVhc2Uga3ZtZmQNCj4gwqDCoMKgwqDCoMKg
wqAgfC0+a3ZtX2Rlc3Ryb3lfdm3CoCAoMikgUmVjbGFpbWluZyByZXNvdXJjZXMNCj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqAgfC0+a3ZtX2FyY2hfcHJlX2Rlc3Ryb3lfdm3CoCA9PT4gUmVsZWFzZSBo
a2lkDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwtPmt2bV9hcmNoX2Rlc3Ryb3lfdm3CoCA9PT4g
UmVjbGFpbSBTRVBUIHBhZ2UgdGFibGUgcGFnZXMNCj4gDQo+IFdpdGhvdXQgaG9sZGluZyBwYWdl
IHJlZmVyZW5jZSBhZnRlciAoMSkgZmFpbHMsIHRoZSBndWVzdCBwYWdlcyBtYXkgaGF2ZSBiZWVu
DQo+IHJlLWFzc2lnbmVkIGJ5IHRoZSBob3N0IE9TIHdoaWxlIHRoZXkgYXJlIHN0aWxsIHN0aWxs
IHRyYWNrZWQgaW4gdGhlIFREWA0KPiBtb2R1bGUuDQo+IA0KPiANCj4gPiAyKSBJcyBpdCByZWxp
YWJsZSB0byBjb250aW51ZSBleGVjdXRpbmcgdGhlIGhvc3Qga2VybmVsIGFuZCBvdGhlcg0KPiA+
IG5vcm1hbCBWTXMgb25jZSBzdWNoIGJ1Z3MgYXJlIGhpdD8NCj4gSWYgd2l0aCBURFggaG9sZGlu
ZyB0aGUgcGFnZSByZWYgY291bnQsIHRoZSBpbXBhY3Qgb2YgdW5tYXBwaW5nIGZhaWx1cmUgb2YN
Cj4gZ3Vlc3QNCj4gcGFnZXMgaXMganVzdCB0byBsZWFrIHRob3NlIHBhZ2VzLg0KDQpJZiB0aGUg
a2VybmVsIG1pZ2h0IGJlIGFibGUgdG8gY29udGludWUgd29ya2luZywgaXQgc2hvdWxkIHRyeS4g
SXQgc2hvdWxkIHdhcm4NCmlmIHRoZXJlIGlzIGEgcmlzaywgc28gcGVvcGxlIGNhbiB1c2UgcGFu
aWNfb25fd2FybiBpZiB0aGV5IHdhbnQgdG8gc3RvcCB0aGUNCmtlcm5lbC4NCg0KPiANCj4gPiAz
KSBDYW4gdGhlIG1lbW9yeSBiZSByZWNsYWltZWQgcmVsaWFibHkgaWYgdGhlIFZNIGlzIG1hcmtl
ZCBhcyBkZWFkDQo+ID4gYW5kIGNsZWFuZWQgdXAgcmlnaHQgYXdheT8NCj4gQXMgaW4gdGhlIGFi
b3ZlIGZsb3csIFREWCBuZWVkcyB0byBob2xkIHRoZSBwYWdlIHJlZmVyZW5jZSBvbiB1bm1hcHBp
bmcNCj4gZmFpbHVyZQ0KPiB1bnRpbCBhZnRlciByZWNsYWltaW5nIGlzIHN1Y2Nlc3NmdWwuIFdl
bGwsIHJlY2xhaW1pbmcgaXRzZWxmIGlzIHBvc3NpYmxlIHRvDQo+IGZhaWwgZWl0aGVyLg0KDQpX
ZSBjb3VsZCBhc2sgVERYIG1vZHVsZSBmb2xrcyBpZiB0aGVyZSBpcyBhbnl0aGluZyB0aGV5IGNv
dWxkIGd1YXJhbnRlZS4NCg0K

