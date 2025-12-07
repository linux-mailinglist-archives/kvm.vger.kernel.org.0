Return-Path: <kvm+bounces-65470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 841C6CAB275
	for <lists+kvm@lfdr.de>; Sun, 07 Dec 2025 08:25:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 149D8302EF4E
	for <lists+kvm@lfdr.de>; Sun,  7 Dec 2025 07:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 377AA2D7DF2;
	Sun,  7 Dec 2025 07:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HxFmX/nj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C8C2D0C8B;
	Sun,  7 Dec 2025 07:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765092314; cv=fail; b=iAWR7oTgYwgUZEQEgQSZyB3Q913s2itmEbSfKrirT46I5mIYF5TkO588gxTa1MxoApcvk3Pia7Y8fiYtPo/DfHv1UdeqhoS62Yo6boCGcMgNIzCEqJd/HbHkxrZ2hbK20OLAv0Ml6dydlt2QQbC5Qfvn1tKJt7UBe7GOArxz0M4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765092314; c=relaxed/simple;
	bh=lYrN+4/7F8lt29R23dBL7o/h3WO/Ts08hsl0UFx9qpo=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=KNJLiY10NpKIBjra/iaWbqWlfOU1rmxP3tLW/k3TfopAOmBIR7+wtoPpzNV5QhJ0GI84QX6IgM517ICagfAsCT1m9lBEFwuG6C299c5xNY31l5mXMdWAajQgtRFGY3Sj7hqrnaZbnBEiFJDR9Yw8efAydF/7cVgasVyJpX1zlNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HxFmX/nj; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765092313; x=1796628313;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=lYrN+4/7F8lt29R23dBL7o/h3WO/Ts08hsl0UFx9qpo=;
  b=HxFmX/njvvBi2UmsQRaxSzVqOQHZTkbZ9TVsb9b5Ve4O5H2WHsv2IqIw
   7xp3znRHpL4U+41wydFq9CTozxd7tyUJuKckM/8S/Q5jO7iPE7tKusxUT
   /nFrL9lnLotVo9/aGTh+u/6B2WgCb1zX3wAshG1JragYJ2RujpAOwrrYW
   Gfu7YLHpRljeiDu8fDrD76aVDjvqjdq0WmvDNLhFWGU+UJjtpCDuS5BEA
   JrUSni7D8kuTGi6vXsBgL9tgmKOAioWaArL2y3vDW/KTZXx9TFX9KKuR6
   gPyovyy7fDqjRNFu4Sm03B7IrrPZw5WQER1mJKGRAqDk3t39O4Cr0UmKn
   w==;
X-CSE-ConnectionGUID: xUVlNZqGTj68hBFG3U7J4w==
X-CSE-MsgGUID: 0X/rJvOGQj+M7nR8NAn2oA==
X-IronPort-AV: E=McAfee;i="6800,10657,11634"; a="77688405"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="77688405"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2025 23:25:12 -0800
X-CSE-ConnectionGUID: 0Zx3NGR+TQWYg2hMmP56+g==
X-CSE-MsgGUID: Oy2jpm+nTmWVqeUkLvL8nA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="196109154"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2025 23:25:11 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sat, 6 Dec 2025 23:25:11 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sat, 6 Dec 2025 23:25:11 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.53) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sat, 6 Dec 2025 23:25:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IkWmmoi2Z72qj0RFpDYVDGflITWMFeK/k5/bcC7tdLRNzCHeeE8T6uAp0WyRYiFmgC07DU3FXyiSf1NmbuTJp3Qen5wuh5wAkYGWdyxWhmnnjG1ldBE7M1gZBMm1px2b58pOcocsLyqOrSm3pIC2tH9IeGCp8zr/Zzybtv5JI/R2yc7RXE+RL3lcrOmVzANeQm1Gg9NLkKAuj9VvIcmEXCObQSKNWLtng4hZznq+DYMw1LdZZneHxAOLr1VtVoP73Jg9FPzbvtLpbZhISHfQTZFIWMirYF+eNwujJeSUFnpoIBBeQlTeUa6WuUfZ6D4MQztyQG7T5+g8w1jhCiUrPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fL8HJvv6PzhvXwgL2NsfYIXUMZPrBxuV5lyYHgE1Y+U=;
 b=bFUjiS0zMeVKSnfPvxf/oRsITLFtnomxngSD7BCsN480h4+zxmq+axnmrhXsH1EegxWJ0sdVCypxOmCJl+/F4/VsnDaPUjg3ieEJrdu5MAHXfzXj1N+Le8PZR+fcPjg/CUXzPf4vC0i21Sjv79yn1Tj/rvhvf1Xot2CiJeDCyTZdGiE/qDUK/qjVWNrDb2OO6ST8KQcmlXO9zhSoyYA4ok6hx95KCbKUK7Q3dkoF7ykHrxjUR6hwAzqT37WxQH44aixUon1ekd0F+1X/H70T8+LVjQ4ou/SaQO9fu+Wp5WFy3DCmK6GUn7jMua2JPalrGuVpkrXVev1fqF4TYokJlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MN0PR11MB6207.namprd11.prod.outlook.com (2603:10b6:208:3c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Sun, 7 Dec
 2025 07:25:08 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9388.012; Sun, 7 Dec 2025
 07:25:08 +0000
From: <dan.j.williams@intel.com>
Date: Sat, 6 Dec 2025 23:25:04 -0800
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, Chao Gao <chao.gao@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
Message-ID: <69352bd044fdb_1b2e10033@dwillia2-mobl4.notmuch>
In-Reply-To: <20251206011054.494190-4-seanjc@google.com>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-4-seanjc@google.com>
Subject: Re: [PATCH v2 3/7] KVM: x86/tdx: Do VMXON and TDX-Module
 initialization during subsys init
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:a03:180::18) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MN0PR11MB6207:EE_
X-MS-Office365-Filtering-Correlation-Id: 09a37529-bf12-453b-7a88-08de3561bfcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R1ZmaUprWFJCRWY1VE05Y3Ztd1JVcjdITnU3Vm9jbi9Ec2tpVUpIaFhoWHdm?=
 =?utf-8?B?RHArQ2pYK1gvcjd2dFRJQVhkbGhOOUpKK1VObUJSMHlGdVk2WUNwUWF3Y2x1?=
 =?utf-8?B?Skt1UGdpQlRKZkcwSkZ4STlYNGZrcVBZZ2xIT0VOSy9qeWY4QUpmVVFtRVFZ?=
 =?utf-8?B?OUhMQTgyTWh3ejZzZ3dyZGRicGpiVnk5TFIwd0MxdzEzNTgremdQTndHTE4y?=
 =?utf-8?B?MXJCak1yODd1N0c2ZUc0TzJleWl0OS9LUTNyYnFHTTBGb0dWYXZBa0FHVDM3?=
 =?utf-8?B?K0ZYaFdnaEljRlJMeU5BZmd1MGZVQi9zWHZraWl2M1F0WmRDUGVDd3EyWHpN?=
 =?utf-8?B?aGFPN0o5TUVWaUNpeG1kYW8wVitGVkZkblpUcE9Yd1lDa3hBazB5N05oOWw4?=
 =?utf-8?B?R2ZNb2piSkQ3K1NRZDFvaGVUMmhudWVTTVMxdmtDaGRiUFkwN3Vhb1lPRlhW?=
 =?utf-8?B?b2xWQ1NSQjNiMTZxWDlBK0l4RnZyRFNibHlrYng3RGJSR1ZlcmRmaDlpcGRC?=
 =?utf-8?B?b2QvNDhrRFBEWEJpaEpwK1dOMVhXYWJCRDY5QTQvN1RGbHZPMDFwUDJUQ0Uv?=
 =?utf-8?B?RGtTYUNIbkgwWEIydUI2YkQwRmJ4WnVtV1l5U3JoMUVhL0FaZGdLN0p5ZlVZ?=
 =?utf-8?B?ejRpOWtHdWNLK05MTGh4OEp1cENSRGcwamFpL2pkZHlTc0lObkdVOTF5bDEr?=
 =?utf-8?B?TmxGRmE5Y3UwVDJ0K0FvWEJ3MmxtUzNIelBpSWlIc3YzQWxzYUVRNExqMFRB?=
 =?utf-8?B?NkFGaFkyOXVMUDZVU0ZLRXVhRnJDcyswSFR6eUtFV2JoRU9UTTRyNHR5Ryt2?=
 =?utf-8?B?eXJkQVdVNmh2ZmVBRW5qSWg4dWZBM2FxUkNjUzVxcnlucklDdXpNUWJPZEFn?=
 =?utf-8?B?anpoVUhhemU2MUZ3dEgzUmI1Q1pzN08wUlk3cnRkdWR6R1lyRElmaURPUGxo?=
 =?utf-8?B?TDQwOFpFQ3NYUWh5T1RjaHhwNlQ4NWJKcDZqRmh0dU92L0tZWFF5OVVoMDhw?=
 =?utf-8?B?Z2pIdzVnVzEzMS9tNDBFMFNRbHZXOWNyR1ZmejBKRmorNlNybHZxcFpYZjRp?=
 =?utf-8?B?MmF2bG9mb1lTOGdXRngxMFhOOU0vYzVYdjRaMEkwVXlUblVMYXExb2Z2eGtQ?=
 =?utf-8?B?NUczS2FRRkZKWlFGOXVsMWdsM3dja2JQS3dKQyswdkJpV3grRFF4L2p2eWRr?=
 =?utf-8?B?QTRDU3BsVVBwd2I2NDlkUFNBZFAwajBqRUF3SWMwMzJKUTlUNC8rWGxHTUxO?=
 =?utf-8?B?RWZ0RDlYUllNL3hYeWh1U1ZwdExCNkM0bjI5R1RreDBZQkRlN1Q4S3NmM25Z?=
 =?utf-8?B?T1k0MWNVU2RHeGw2Q3cybmh2UDJFakVEVWxJVVFGWnl3bXNNa3FGdkVCMEJu?=
 =?utf-8?B?YXBXTy9wUHpuVkpZSTladnFMazhmMWVPN3JjZFMxejUrL0xBK2RDMHpOVThr?=
 =?utf-8?B?alVqMVlvcmQ3Q3Jkc0xuQWlEeXA2dUdFeFBLUGx5MXByckFzTnYzaUtnMkhW?=
 =?utf-8?B?ei9GL2tjclRCNlRhRHhVM3Ixd2NnZDE1QTRjQisyOWV1RGVIZEVBVkwraEVx?=
 =?utf-8?B?QmRJQVZUR2dBZ0t2T3Jma2wxSHEvV0l3ZTgxQURkTytaOHpvdzQ1bXlTZHB6?=
 =?utf-8?B?ekVmMGs3MGM1SGgrYlgrQkpPUWllWll2YXkyd01DVWpSaXROdkgxTmhZU0pa?=
 =?utf-8?B?M1VTWWFnVm8reGREUWFKK0U1akhBaHZVR09ZM2ozZVhCSmpKYjNTckNmMU9r?=
 =?utf-8?B?VHdmRkhvdW1mbmdoTnFmSlNXTVEyNXc4R25CT000TUNnVkZqUjZZRlI4K0FR?=
 =?utf-8?B?UXlqc0EyQzhrTkRCLzhvMnUzYzIrdVBybVBwR0RwVG9udHF6eUx6T0grek5s?=
 =?utf-8?B?bkxzS3BjdTcvU2F3SktZWEF0Zk1kbDRjekd6YWQvTU01SWlhVExJTWtNN1J2?=
 =?utf-8?Q?3Ji2kp1V+WPCxfDWIIiDwG9cTSW6842P?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3JGbGFmWVFnVDVWbk4zb1d2YXp6QS9FZWRjQ05NYWcvMnRLV3dwZFZmc1Fw?=
 =?utf-8?B?bUdLRmJmZlFxQTZNajJFcVZEZ2lOOElOQXhCeWJ4MCtrdFd0WGxVL1kzWW9v?=
 =?utf-8?B?bUxwOFNXOGxYNXFqekpKS29iZHdNVm1jNW1NTTY0NUV1QVR1REw5Rkg5ZWZR?=
 =?utf-8?B?REpkeHl0azJNdHdwN28xbVhaTXR6Vjh4Q0FuSWZndkVzWlF3L0d5T0wzS0ho?=
 =?utf-8?B?M2IrNEtyTlk2ZXRmYVN4VnVoVG5TRVpScFE0Z3ZyV2MvOVRPOGdmNCtDeUxI?=
 =?utf-8?B?TG9zV3VTd0h3cFRoK2p5Y0Q2ZGEzMW9HNWFIM1NWWnRwU0lBQkJ0c2VlVUZq?=
 =?utf-8?B?enZVaFpWU0RKSzBDVVRMSHRXMTVLbEthSE0zdE5hdmRTeE5pdzdGb1haTE9z?=
 =?utf-8?B?KzkxVnJyWi9sTk8wOEQwZDhIZU5QY3h5NHFYS0tvVy9YeUdsNU9ZTEdMM3hl?=
 =?utf-8?B?cURUMDFaT1RSbmhmUUV0d3o0TTRLWGV0YlkrNEdEOWY2VWxzcExKRjBxRnAv?=
 =?utf-8?B?M2w1SmZkQlBGTUZzRHBhSmhaU29ZZ0JtS25OQWdudFJwRUdXUWg0TWJUZTYr?=
 =?utf-8?B?NHdVUFNTQjVGTGFZVXBjTWt1ZGl4UU4vc1VPSGpkeVA5U1hqcjVYajRpemR1?=
 =?utf-8?B?cU4yL09KRUtLVEx5U0doZUpydVBoaTJ0ZGNKTC96emRXdkFuaTllQmxLNjFN?=
 =?utf-8?B?YitRMUF5dlNSQkR5QUx3UCtweVhzd2pFRTRBL3loa2FCNS84SGw0TUI0MGNj?=
 =?utf-8?B?cEE5cnB2SU9oZ3FNS1UrUit4NFhjUHBZaXNQZlhLS01LMWluRVladXhINDF0?=
 =?utf-8?B?Y0d1ZHJWNVRBU1JHRVY3Y1dxekt3R3Z6OTJlM2ZLM3MwV0hpYTFPMThFUEZP?=
 =?utf-8?B?NjFGQStQRnZqNndrbUx5SzB4R0F3MDlESVQvVzd4QkM0NGFlcnJvenNHb1Va?=
 =?utf-8?B?OVFNRG56bm51NjZUSW5sSUliWkVOYkRHUi9jbFM3RU4xNmNaUkZOTGdXRnRm?=
 =?utf-8?B?bVJ2SmpUbW1VNGtsUlplRkJ2ZkFvVUlLaERrNERWYjBRbHBCdHR6b05MSXZP?=
 =?utf-8?B?bFFMeFhpRk9pSHdtYU1Ta3NlcnpJQm9YSUJ6dVhNN1dyeWlYY2FweUE0K05Z?=
 =?utf-8?B?SkR4WEdPYUtuR2hhMjFsR1p0Skk0cjBFd1hVQWk5R3RiWnd6bEtTOVNSd3o5?=
 =?utf-8?B?eVR0QVM2RFkxQm40YmFBM0VaU1A5aHZGL2NiNGJsaHkvOWhQRDZNRFprN1Zt?=
 =?utf-8?B?ZTRMRno0SlZyMW9sRStza3Jqc1orVmp5dTYrdjhwZEpTNm0yTmdhZzljeWlF?=
 =?utf-8?B?bHFRdVB1VU1jWE5YdFJjSTUwYjQ5c1M2NWtNZG9ubytVbURQdWtXaHpGQ21H?=
 =?utf-8?B?ZmhBc3NSYWdIbE40STZIM2g4eDEzZGhacEhrV3JLWTlBdU5VbXM4UjB2TjNM?=
 =?utf-8?B?dm55ZnN1VDdnVWVMT0RNUis2Yk12SnJTbWNwQ01nQWFqODdLN2U3Snh6bXdU?=
 =?utf-8?B?eC82NllwdWtGbUVZR21tcXh2KzA0Z1ZtRmcwQ0RGNFN1QmJkdTNqWktGTy9x?=
 =?utf-8?B?eDg2V2xSbVFVL3JIWHdkVEx4MDdPUWZmeGRGZmtJcGRsdHpWa1hSQUl5UzVH?=
 =?utf-8?B?MzFUU0xDMTdFdXJTUlhEL0dqemU1MmZycTJ0QUNtbnpKWFg5N0d6VlE1dFhN?=
 =?utf-8?B?SlAyMndnSFhkVHZ5Zmlac0NYOW1JWCtPdFE0VzY5d3BkVkJuRlpMQi9LVzJF?=
 =?utf-8?B?dkxwekIzVW8vaWtQUy9tSXNtSCs2VHRIYUs3bjRGb21zOE1remtqcThxRS9X?=
 =?utf-8?B?OU9MaXRYWUltMEZZbXdTWHpaSVNoYXRLNG1CN1FjdDgrSXhWK1M5eWpjNFVw?=
 =?utf-8?B?VTNRZFlmWEdZNmhzQXdBMk5QdzVlbHhkbjB2dnNoUm80ckdleUZvSGlqZVZj?=
 =?utf-8?B?QTlFS3gvYmczZkUvT0txa200K3IvWW1lZTg2U2tpK3pua3VhdER0eHhpNGo3?=
 =?utf-8?B?VGk3UkNYbTNVanJ1blZ5aFMwRWJUQytSUnh3MVVMc283c1IvS3VDZTlEbDVS?=
 =?utf-8?B?SlNCYzJ4TmZSY2R4OWc2WjlWZnNaZlRzcEMwc3c5TVNHRzBpL3Nvd1owRW9a?=
 =?utf-8?B?cE9ac1Z2WjRNWWRxWENZbU44NHZvTnJadTM0TlRuKzN5M1RxNkx2aWNzOHhI?=
 =?utf-8?B?NlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 09a37529-bf12-453b-7a88-08de3561bfcf
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2025 07:25:08.0775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJCVSUFlW6y7YTqtOPDiSlzbzvqtzfBgzCk9rfyYydPXHbtrzXUqYisRhzi1PywLklMvUQar+NV2ANzhwwUqrJcYMh8/T7xs8P5GKY/4SAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6207
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> Now that VMXON can be done without bouncing through KVM, do TDX-Module
> initialization during subsys init (specifically before module_init() so
> that it runs before KVM when both are built-in).  Aside from the obvious
> benefits of separating core TDX code from KVM, this will allow tagging a
> pile of TDX functions and globals as being __init and __ro_after_init.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  Documentation/arch/x86/tdx.rst |  26 -----
>  arch/x86/include/asm/tdx.h     |   4 -
>  arch/x86/kvm/vmx/tdx.c         | 169 ++++++--------------------------
>  arch/x86/virt/vmx/tdx/tdx.c    | 170 ++++++++++++++++++---------------
>  arch/x86/virt/vmx/tdx/tdx.h    |   8 --
>  5 files changed, 124 insertions(+), 253 deletions(-)

yes!

> 
> @@ -3304,17 +3304,7 @@ int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
>  
>  static int tdx_online_cpu(unsigned int cpu)
>  {
> -	unsigned long flags;
> -	int r;
> -
> -	/* Sanity check CPU is already in post-VMXON */
> -	WARN_ON_ONCE(!(cr4_read_shadow() & X86_CR4_VMXE));
> -
> -	local_irq_save(flags);
> -	r = tdx_cpu_enable();
> -	local_irq_restore(flags);
> -
> -	return r;
> +	return 0;
>  }

Given this routine now has nothing to do...

> +	 * TDX-specific cpuhp callback to disallow offlining the last CPU in a
> +	 * packing while KVM is running one or more TDs.  Reclaiming HKIDs
> +	 * requires doing PAGE.WBINVD on every package, i.e. offlining all CPUs
> +	 * of a package would prevent reclaiming the HKID.
>  	 */
> +	r = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "kvm/cpu/tdx:online",
> +			      tdx_online_cpu, tdx_offline_cpu);

...the @startup param can be NULL. That also saves some grep pain no
more multiple implementations of a "tdx_online_cpu".

Along those lines, should tdx_offline_cpu() become
kvm_tdx_offline_cpu()?

[..]
>  /*
>   * Add a memory region as a TDX memory block.  The caller must make sure
> @@ -1156,67 +1194,50 @@ static int init_tdx_module(void)
>  	goto out_put_tdxmem;
>  }
>  
> -static int __tdx_enable(void)
> +static int tdx_enable(void)

Almost commented about this being able to be __init now, but then I see
you have a combo patch for that later.

With or without the additional tdx_{on,off}line_cpu fixups:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

