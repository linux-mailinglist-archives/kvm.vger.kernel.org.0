Return-Path: <kvm+bounces-49340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A14BAD7FB9
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 02:48:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C8DE3B5F55
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 00:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A6851A2391;
	Fri, 13 Jun 2025 00:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fSaLVQtv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07128F7D;
	Fri, 13 Jun 2025 00:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749775682; cv=fail; b=P9jdqGZRvQDTNGTr/A8wCDWxZ32o4BkjMYlbQoJYtBveu7KW5PN5J69DkmZIB1R+WiocO/w6i2fXXtVkn+boGdI9z8JMhzOivlFfmEE9gb3pxeV2QY/22cqqJwkXxBZuo5ypGLVH8rH6dolpYmliI+G+Rgws6WuyMBxlKrMVCYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749775682; c=relaxed/simple;
	bh=hgA+qvrmK4cQ3Pnv/0o3rAk/eUrqO0ihvRSe3v6yTM4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pS917uqZ4oFqLCheiED0MFFh6dYQ9EZ2AciyaydZ8sWAjRx2A6AGbwF/ki7kud0HuyKcVXiCOleKONF1u6VBvxF0dR4dt6+jvRUsYvcbSyNYZ2fl48z3EYMy2PeacrOqxI6sCh5/f4H3TzRzkH+S4iRXhhrz86EkV1MsMCSlAjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fSaLVQtv; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749775681; x=1781311681;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hgA+qvrmK4cQ3Pnv/0o3rAk/eUrqO0ihvRSe3v6yTM4=;
  b=fSaLVQtv28y+UQIj3X0StS8NwkTZutcHwRQHvS+npCVXWyzIX2A+bVjh
   QN97fPrkZV8ueeSAl3D7AZXl4KfZEzlfV9/gvUYC0ubJafLi8JQIv1lZj
   A26e3Pn+AUvXHFLQzQJJU2RdFeovR6QJSrNiiOoj0ND4cAFYplZOQqHlT
   nfSwSWiEHdTrhbg2yxK40aGF1azj8m59wYEm1CQr8n1S+zN6TDkndjdCd
   C3OlnIzdqyYNeB+E7OFCCduE3waRHSuMR2GUVANhKuvcXF12tUvJ/Ftbl
   pLV2qrEHo5qWMBDz8KISlpMY60vp8o3V8BdEcd4c+XgCZ3wh/gjjlRyqD
   Q==;
X-CSE-ConnectionGUID: wNk5qBO5RlWrlh/nODJukQ==
X-CSE-MsgGUID: or2fEuTjS8KS12+f28awNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="51850519"
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="51850519"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 17:47:49 -0700
X-CSE-ConnectionGUID: EXHaLmx+QRWYQb9ZdmgUFA==
X-CSE-MsgGUID: 9TVYTrz6QsaUN62mRBgEDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="178573955"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 17:47:48 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 17:47:47 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 17:47:47 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.59)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 17:47:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JODc5TCtV+SUCDYkj3OUcQPA2f4oLVKUP+eUJXvSnekV2+QSjYryC2U6i7BWhev8NV67vT9L32AicFKv1MtmbTpMpM+iWHaVN3D1hxvbSwa/9Rz7mvfZuu5WrHw8GGW9/0xKHdIdkpHoYjI4zE6hRXOczj2EZ+TB5pdiaxWU/3QUZlI/nW99w4L3PZF2waN6Khk4bQ7na8txxuRchAnJkV3AzX8Eu64VBat8ujHfJYvnpqhikNHUCZ+JORs8Y0mIb6M06dThnuXAp/eNd6p+icYnZsumld2Enq+Zpa91iZ6LpX8Ltm/ro2+jW38Gbp+EJveWV/prbY1H0LB6VGTL9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hgA+qvrmK4cQ3Pnv/0o3rAk/eUrqO0ihvRSe3v6yTM4=;
 b=tOmmTmQAKsE+rR/qCy3WS5/VMLGCpIW89UYDN/4NMJTUVke5cIw23zDEnsx2vwsAKmsFMgc90DhEw/Y8RN16v1KjOzTVqCU04LuxfiUYbL5y96NqOreeDqjoWX2xtnByaJ0d9cb2Xwad9TsMcGMrqftFtviMFHIg8V9uvctp58l7bCFWWGEyLoNTosMTTe/jTHR5BlQCw14Vl8IkUVDDNHDr5ncB4Qe4PE8d8hNTv+Am30H/WKkFO+3RWfetUbXw+eyhuGQov5JUXAkAlYEXnE6ce4L1bGENWemDF1jM0TDlb5vNnJl2RGAh47wGRRajWrT94a/f0lUWGr7+9D87nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB7718.namprd11.prod.outlook.com (2603:10b6:510:2b6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.26; Fri, 13 Jun
 2025 00:47:29 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Fri, 13 Jun 2025
 00:47:29 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "tabba@google.com" <tabba@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAIABF74AgADuIICAIfsagIACKESAgAALWQCAAAHGgIAABSeAgAAA3AA=
Date: Fri, 13 Jun 2025 00:47:28 +0000
Message-ID: <4737093ef45856b7c1c36398ee3d417d2a636c0c.camel@intel.com>
References: <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
	 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
	 <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
	 <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
	 <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
	 <119e40ecb68a55bdf210377d98021683b7bda8e3.camel@intel.com>
	 <aEmVa0YjUIRKvyNy@google.com>
	 <f001881a152772b623ff9d3bb6ca5b2f72034db9.camel@intel.com>
	 <aEtumIYPJSV49_jL@google.com>
	 <d9bf81fc03cb0d92fc0956c6a49ff695d6b2d1ad.camel@intel.com>
	 <aEt0ZxzvXngfplmN@google.com>
In-Reply-To: <aEt0ZxzvXngfplmN@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB7718:EE_
x-ms-office365-filtering-correlation-id: 14252540-6f03-45fa-2a99-08ddaa13dfab
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TE5WWFZOOFBLVDFEMlkycEMvQTBNQ1grMVJIQUxHYUdNSmduR2dNcG56aEFF?=
 =?utf-8?B?eWtqVUF2ei9UeGQ5NG5YeFAvZmFCUkNIdnJkN0cwaWFRT1BpYzI3WW5FK3dC?=
 =?utf-8?B?UHU5dGhOWlluYWM3ZmJmU2ppTDdGOU9KWWVyb0R1NE90ZHhaRmtPeTBaeFk2?=
 =?utf-8?B?MmRKTzFPbUNuWWNpZGxsSm9SUTRpcDlrQnQyMSs1UmtINUY5Qk5PcnRGbVJr?=
 =?utf-8?B?WDdIaHlIQWk3dXpENHo0YnNKck5Md3hvdnpHRGM5d0FWTWtjSkNsSStOWUlI?=
 =?utf-8?B?M2dqVzBHazlxTVVHYlZGQnY0bUI3NFRpTUdUS3Q5ejNteVkveEZnSUN4MXRw?=
 =?utf-8?B?ajdkL1pQSHNKSEtiak1UTVBmWlorYjl0Vm1FM0RpTVAwY0xBbVBWbVJtNXYw?=
 =?utf-8?B?dXB2SkIrM2Mra0hoS1l1eGtLbDEvRkt2cGkwRGx6cEVENFE4OE5VQnY4aUU2?=
 =?utf-8?B?Mjd4Q1VraDZETVdEOHdWdDBUSEJ3bW1jNmtJd2tTTkk0VlB1ZzVad3hqSmVn?=
 =?utf-8?B?dUNZb2I0M1hpMEdUenlpNmpKaDRreWNGb2twRVVLYkVaZVowUlJqWVFZMVdi?=
 =?utf-8?B?UnFWR2d4Uk9CR2w5SFN2T0NVNlRoTzFDY01vSnl0OTYvUXRXaHgzelBpVFpK?=
 =?utf-8?B?UFh5S0FRWjBqNDZTWFBtVEk3S2krUkFnSG5nRG5GRXFqYTJHOUJ1eHB1MXly?=
 =?utf-8?B?eGdPMElOMTg5Slo0RUNvRERFRnVoWXIrdE5ZY2NZcVZGL3duSnQ3Y1UxZGRM?=
 =?utf-8?B?YUZzRHJURkRFdmNVL2RLWnF4Q05aU0RMeUlrVDZpbDA5RHNsdEYxc3J5eFBs?=
 =?utf-8?B?ZGdpV2VZUzVHV0dKMVJ3am4xSEVIbFNsUFlGc2FPbWpQVkZ3cHVkSlNJSmJa?=
 =?utf-8?B?eHRVR3VDZS91OFFoWFU5bzFDcHF0OVlxU2t0eUVTUU9NTTNsbjhYdFRDN25F?=
 =?utf-8?B?azhsUGNuSFM0OW1HZE02dDYwRlZZdW1qTFdXRklZelR6b3BzSWh3NlVpdnV2?=
 =?utf-8?B?YlJZaURBQjNQYkhRZXpHNUhaci92aFZvalpCSGo1YkhRaU4yVGMxeGR3RW1Y?=
 =?utf-8?B?K3UyeENJemQ2RGlFY3NjTGJrbCtRQnpzTVZiK3NuUk50V3pZVUppY3VHeGkr?=
 =?utf-8?B?MEJEK2lJVytxMU9WSlRFME9kakJrRGNxdU9JTjFHZjE0MHpJQ2FjNDBWRDlU?=
 =?utf-8?B?RE9NbG5qdmQ3NnBQYXZaRGo3VGVFeEJma0NEeWt5U2pVdGk4UFI1dmdJaDN2?=
 =?utf-8?B?N01XWnBaZ3BGV0hpK3ArdmZvVmxjQ2h4NmxhTjVTdGdxMmRTWEJWMGxwWUU4?=
 =?utf-8?B?Mk10dGJEdmdhMGd3RnBBWEF6RjR1eXBtTXVlREpob2N2RjEwQ1Jtd0JSRzRl?=
 =?utf-8?B?VGhkWjFFV1BBaGV2cWVRZXdnZlVMR3lFdGpQak9kMERWa2VKUmZ5OXByaWJn?=
 =?utf-8?B?cWFkUTBIRnMxOVI4NkwrUm5qS0xmMHBXRXVuT1doUXJ1bkYwMUFmemlpb3BK?=
 =?utf-8?B?VmpZa2lod2lFR1BoeEx0T09hYks4bkFYU1ExRE5TMW00K2lHZ1g3LzVYeHdk?=
 =?utf-8?B?dWE2ZGpaYTlWOFJKWVo1MUJnNzd2MTUzWmFnNWd0MVRlOEM4RXE4cjF6cmw3?=
 =?utf-8?B?Y3FGWnhva01manFMcmRrcE5kN0dqa1Qxa0NnMmhZa2VHalJEZmdLaEtrUHd2?=
 =?utf-8?B?QllIK29ob1hYTzBZSVJHVTBMUnNOd1JUYzc2ODlCRysvbzR0Q0F3RHl6N0lu?=
 =?utf-8?B?MDIwMFh3ZDM4MHpOS0hNU2hRVlhhL001Y3lLRVgzbzJpYVNEN29PS2RRL1J1?=
 =?utf-8?B?eFlBOW1Tc1pVczFqYzhFS1o2RFdOV3d3YlFSRWhxMWs5MkszQUFOclBaVWMz?=
 =?utf-8?B?aGd1a0N4Y0lGcGtseC85TTViYklra01NaXljQml0MVp3bi90MXJIVDZWa29F?=
 =?utf-8?B?bUc5dGpxajRybzRNYjcxNmRCcDVZT3BoOHBoU3pYeEp0Y1AvZkNmMnBOSEFj?=
 =?utf-8?Q?XD3OEgXT5JqF81QGGfE64xkTl0rYSM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDNKNENDeVZsejBwMjZ1cTdtWHVZMmMvSmRVZFNyN2dQbW4yWjN3ay9QZ3pZ?=
 =?utf-8?B?S1ZzZ2pDa1RpTUF4bU53SzlzU0tDcUtkVEpuY3JqbkExUExESUZ0R1cxRllR?=
 =?utf-8?B?TGgwYlhGRDJxRHJ3d0trZWtSMGxOcUxXWWdTOHMvUXo2bUVjZkp0b2Z1cC80?=
 =?utf-8?B?UnBsZGFpc0d2cEJHV1lTRUhUZytuZWhPZXpIS05mRWduVjg4TlJxT2xwSnJl?=
 =?utf-8?B?WW5pdnQvWWVKTS9GbHhRQWdROUNaVlVyZVFMS3VzUnlUc2Rxa1NYWnpYRXNN?=
 =?utf-8?B?c2pTWTQvVlhiVHY4Y1NvTGZwYUJIMjlueXpYVHJwd25kcC91WFQ3SCthaTBs?=
 =?utf-8?B?S2JxTkI0Y1ZJWXdLamd6cEhiQU5CeXJJUjVqdXUyZ0d3emU1dXlhTnpMWElX?=
 =?utf-8?B?YTFnNUFYTkFuS2RTTmRsb0lDeURUV1VaV2h5MUxKdW80dzQ3OE1FSlJCRk1K?=
 =?utf-8?B?RGpqdzd6YzhjMFVtVUNWQTVvRG5yVHFuSnFBN2QrNWl6aG5XK0VTNWhSbThh?=
 =?utf-8?B?QzlHWCt5Rngxckd2TkloZ09KdDg5L1dLT0NscENneDh5K0RiRUpmQlVkMnB5?=
 =?utf-8?B?bnBiY2YxSDc0MW5CVTlKeUtGSkpzd2xXcThRRmE1YzBjNFdPWUZtR2Y0U3lv?=
 =?utf-8?B?RjZWRmlQdjlsbEd0NGkvOTlSVTR5a2FobG9WcjN5THNSTlluRXZPYy9VWDRi?=
 =?utf-8?B?SXpXK1VKdTU2VTJ6RUtZQUY4aXFVbjhLdlRTTGNNZTl2c2NGRHFiRzBzNVhz?=
 =?utf-8?B?R1FYaWxUc21lV3N5amhwQUJKcms2bDlhR3VxbEFHQmxldFNiejZId0g3RWQ1?=
 =?utf-8?B?N2tHNHdmTnUrK1NxU0lZWjhPSWVKT3pxUldYTjJCYUtVUXdZYlA4QmJlV05C?=
 =?utf-8?B?RHZNektueHVNZThjcm5FRG5TYjhDVFB4MDlYOUZTcjVONHpJU01wNUhzdkhK?=
 =?utf-8?B?RCtmOFpXTHZGVzc4M0ppSTFvVVEwZTk5N3JWa29LOWpOOUQxTzZOWnNycjM1?=
 =?utf-8?B?YmFWSFNpR21DUnpySDRFeGNETWoxUXF1dkg3SExmMDlmM2wySnF4MHFQZ25m?=
 =?utf-8?B?TzNyVXB5U0o4K3BKbXNpaXlxOUpoaXAzN2ovSml4Nmg4YU5JeCswSThKNk1p?=
 =?utf-8?B?U01HWXB5SDZxeGZUNjVONExDWng1ZDVqK3ZaU2xuWTNLR0dvSTl4Z2RMK3V2?=
 =?utf-8?B?TThFdWNBN2RHYm9HSmJuR2J1STJuWkdzWk5nWEd5MGp3VmRwZXV5TEZHZUpS?=
 =?utf-8?B?ck0vcGlHREJ4Y0l1Uzhnd1VRajBHNHRQL2JmaXdqdVZNYU1JK1lFaiswQzJr?=
 =?utf-8?B?aGdxdDA1WnpiZzNTYXZ2ZjFwQzhjRjNKajdxVVB1NUJuRzV6c25xSHN6SnpV?=
 =?utf-8?B?NHVlNnBoYkMyWDUyY3VkdHR4djM2dHNNRm8wQjcyUll3Qlp0NzBuUFZycVkr?=
 =?utf-8?B?WHZMemZ6WFlyNkNLSWpDRTE5R2pqRmU1QTlXQUxUTlFwTkRMT1VwTHFxREJr?=
 =?utf-8?B?bStpUVozcXRwMWE3WGlBTmVsVzd6Rlk1VldNVjdEYWZsNGdQR3dUREtwVmRN?=
 =?utf-8?B?WmdGMVJYUy9QakdCYmlUWXErRVNHbFVsc3lrcytwekJ6ZExVeDFlcHJLQkVF?=
 =?utf-8?B?WG9Fek5GRlhIQVp6N01DWFF0MDlqK2xRaHpxVDNFMUJXZHZsbUNBRlFKNVhX?=
 =?utf-8?B?azVYeWZVMElTY0VWQ05XTVc5Z0IwRUwwWEhmMXMreW4yUktidWc3S1hSVFg4?=
 =?utf-8?B?NFI4allySWplbGFWMlBpcStHczlNZWtNT1dRZXp2eWs2b3RJR2Uzby9VQmw0?=
 =?utf-8?B?dHdpd3dTdmxEY1Frb2NrVGtVUnhpRXJaWmVFS1cvUUIvcGRZR1RLeGJHVklp?=
 =?utf-8?B?S090VHJhZkFSdjVnVi9uanNyRGlUV3N2R1RHU0JYK2tEZWY0aGNyYUpBenRL?=
 =?utf-8?B?UVVnZTNVb3E2aHNCRjJaekpHSTExK0tCRDluRk1EMklSRnBxNFNPYzJtMW9n?=
 =?utf-8?B?WXpUZ0NXL2tXUmE1R2JmNHJFd0pxc2xWZXU3TWVTZW5ONEhQbkN0c0NnR0xG?=
 =?utf-8?B?endPSTI2SUdvY3BmYm1URzlOcDZSTEdpSzdMWWhacWdmY1JYRnlpWWsvMnRS?=
 =?utf-8?B?WUs5NEt6ZktDR3BKWnpmbUl4emFWdnc0TzlKNm5vVlZSa203MC9LMWpUdEd4?=
 =?utf-8?Q?YWokFYpHIueHGCY7Zdp/+i0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CFDEE7C76F1B724FADC3C466BE0872BE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14252540-6f03-45fa-2a99-08ddaa13dfab
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2025 00:47:28.9580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ABXnUEX/CceQauAR5Txvw8rkWq19rtPtrKHYZ2/flYldLpM+6LZjxNwDSWs7F4SHBut7R8lnIQ1yTsBmuxtW4e6TwTb6TVsprTVQqVQkYUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7718
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTEyIGF0IDE3OjQ0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IE1heWJlIGFuICJJIGNhbiBoYW5kbGUgaXQiIGFjY2VwdCBzaXplIGJpdCB0aGF0
IGNvbWVzIGluIHRoZSBleGl0DQo+ID4gcXVhbGlmaWNhdGlvbj8NCj4gDQo+IEV3dywgbm8uwqAg
SGF2aW5nIHRvIHJlYWN0IG9uIF9ldmVyeV8gRVBUIHZpb2xhdGlvbiB3b3VsZCBiZSBhbm5veWlu
ZywgYW5kDQo+IHRyeWluZw0KPiB0byBkZWJ1ZyBpc3N1ZXMgd2hlcmUgdGhlIGd1ZXN0IGlzIG1p
eGluZyBvcHRpb25zIHdvdWxkIHByb2JhYmx5IGJlIGENCj4gbmlnaHRtYXJlLg0KPiANCj4gSSB3
YXMgdGhpbmtpbmcgb2Ygc29tZXRoaW5nIGFsb25nIHRoZSBsaW5lcyBvZiBhbiBpbml0LXRpbWUg
b3IgYm9vdC10aW1lIG9wdC0NCj4gaW4uDQoNCkZhaXIuDQo=

