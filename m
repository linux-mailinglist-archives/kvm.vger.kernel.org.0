Return-Path: <kvm+bounces-52926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 06594B0AA47
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 20:41:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38A3816F2BC
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 18:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8944A2E7F31;
	Fri, 18 Jul 2025 18:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gq4HN+jL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948A81C5D53;
	Fri, 18 Jul 2025 18:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752864070; cv=fail; b=IkHKpZf7gpToIpibMlM5jvLb/G8DfMQmvlpB2BJdDcJglflHwSuzurLG/iS/uaMAhkIXd27Vy8sWG72mHPfzz/pLX6dvMI6+mrk+Rs5dUOehfqcCl8BrjHpu7PTLuBSfzlBF/5G8xq/DIuI8H5Yzb2nC9PsEEikJ+xaqy+BEemo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752864070; c=relaxed/simple;
	bh=a+rrCcALltv/efFUGPyNQxmRN8QrTMmyapZpTQnbcOM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mx6rU8uT96nymctgbJVH55fYRvp0llLn3JSuNxlTc05PYZjxicDgoL9Cvc9VO9HLINAdf6DFhN+5OCOKkPNEeQncw6azR3BllrZkGyTuAkRRL+S7xlGMzKWIl0oC61VikZIG6qc/CAr0DvaVjZXlrqqTvudnmlP++AJ+O4RZdBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gq4HN+jL; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752864069; x=1784400069;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=a+rrCcALltv/efFUGPyNQxmRN8QrTMmyapZpTQnbcOM=;
  b=Gq4HN+jLRgUaaHeNIF8H8CzSKzqq4dHWM4eves93ZUDEUakQ0OtDswRE
   Q4uj9I7GxyCuYxFWGvtpqS5ReOeix81nlaiu3VrkND1m8pmAKu8mDqojT
   3bbzwX1+/9h7BrYHH9JoJqnD/n3xJFzlqRNVQ7hvv5Yz9/byZBmKiYF4O
   Rv9gKqdMGpT3cxiNn8hDROofZJvlOKK13uxM3aGyKhcp4z1SYTAC0aKpN
   tg4Vvw4ZQhzuUt9SHFbavK5gLATRui4mNjJgT/Gvozrl9MRggWR3hVWAV
   LuGQ4xtaAgq3Mg8yk/AOrl5lXN4fPswIqCTqz1qtbGjwNidlY8jx4U6d1
   w==;
X-CSE-ConnectionGUID: sKIWlJ/RTqmdcKAvfpRXRA==
X-CSE-MsgGUID: EgLWsL0oSV+VpJYHHA/PgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11496"; a="55285626"
X-IronPort-AV: E=Sophos;i="6.16,322,1744095600"; 
   d="scan'208";a="55285626"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2025 11:41:08 -0700
X-CSE-ConnectionGUID: uD6ottUKSSiXMTHTC+Qgqw==
X-CSE-MsgGUID: 3tcM06EKQoC15vUa1xvpyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,322,1744095600"; 
   d="scan'208";a="181819988"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2025 11:41:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 18 Jul 2025 11:41:07 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 18 Jul 2025 11:41:07 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.58) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 18 Jul 2025 11:41:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zPld/8HL+jTKmUUynsaalCaU7H81qwibVQrmqmxLyCt6KAXVy22F+3Z+h56NcNMB5c/JpGp1NfLDLHrTN0iq9Tiki62x/eywSVHKrrzUSmZ5QC2JoCDZUAzX49A3ZxtXIudABek/mSEfzMFOsvVruKGkXheNiJq1YZudheqMjATDG9uv1qMxZkoPzWEH6AmDS3qSPtURw+L0wHCH6kCAbwWmz8nS/VhGMxEswtnzXbc/zy4UV/hm23fBx/PbCJr90pISoCYT8j1oB5TbEid3xsJbC0ieg+K907rnup974RHcK7vCZ37ZwgskXUG7HuW2ytAfZa04k+8+3ctsJLQQUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+tHGN71zpOGe6ZNUbX6ByHLP9J/Wd2DAHudl/KbMLRI=;
 b=VTrGd8QGtIHV5499RUfHVGhHMkJsxUBv+wLF+b8sE+xE0cMxQJEz8i5fr9Ygirjs77qZ50w2gOuxHcZRcK9F5/xmOZE3t03tOmf2DdMnbrd3Rjp9qaER6ps+6eAzeho4xCjZ9LXqIKfvdFmPw38HHwINZMHILDPo1u012/CFZz22lgxUbm10wG+rCFonn2hhOvoxU4alM8d2AxSWqO0JsvC4F8i3gRmOcIIrXz3mAsuL4q2tNIZyKwAGpWzW/Bd3dc/Yjyu2rKUndt/hJNVwvXS/m0AZHiWd19vwM0UEB3EtnaEy+JLn/ac2U934ckKPW8KOFjfYX36V1RdLS1TQkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by SA2PR11MB4844.namprd11.prod.outlook.com
 (2603:10b6:806:f9::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Fri, 18 Jul
 2025 18:41:00 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f%5]) with mapi id 15.20.8835.018; Fri, 18 Jul 2025
 18:41:00 +0000
Date: Fri, 18 Jul 2025 13:42:34 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Vishal Annapurve <vannapurve@google.com>, Yan Zhao <yan.y.zhao@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Michael Roth
	<michael.roth@amd.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <ira.weiny@intel.com>,
	<david@redhat.com>, <ackerleytng@google.com>, <tabba@google.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <687a959ad915e_3c99a32942b@iweiny-mobl.notmuch>
References: <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com>
 <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com>
 <aHEwT4X0RcfZzHlt@google.com>
 <aHSgdEJpY/JF+a1f@yzhao56-desk>
 <aHUmcxuh0a6WfiVr@google.com>
 <aHWqkodwIDZZOtX8@yzhao56-desk>
 <aHoQa4dBSi877f1a@yzhao56-desk.sh.intel.com>
 <CAGtprH9kwV1RCu9j6LqToa5M97_aidGN2Lc2XveQdeR799SK6A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9kwV1RCu9j6LqToa5M97_aidGN2Lc2XveQdeR799SK6A@mail.gmail.com>
X-ClientProxiedBy: MW4PR03CA0288.namprd03.prod.outlook.com
 (2603:10b6:303:b5::23) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|SA2PR11MB4844:EE_
X-MS-Office365-Filtering-Correlation-Id: a2a4a1fc-b478-4daa-ea18-08ddc62aa3fb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?LzRWZ1FuSmNweWkvUHF2TGpCOHVBYlYxRkdwbW8rTWRIMyt6VEtGYU1wckFH?=
 =?utf-8?B?Z3BrNm5jZ1RDLzhibTdQMW4vUmYyR1QxQ1NvckRYeWFKTHVTUm92dUQ1WGkx?=
 =?utf-8?B?Ri9EQmk3eS9qTDJ2eElzdGZVa0RuYmlDTXcvb1lPbTdoZkJBYXhjLzJoa1Jk?=
 =?utf-8?B?Qi8vejVYYzFabFpMRWlFNGYyU2RtTUJHQ3k4RVlkSTdYc1RTZGRoaXFhdjR5?=
 =?utf-8?B?eGY4am1sT2hNZnJ1UVVXUUdDbGx4RHpyMDJ3US9PamJ0U0pxNnZwbGVvY0pV?=
 =?utf-8?B?WXBsdWFjVkZYUk45blEzWlhXRWhETFpjK0JOMnlvTnZoZGJ5MDJvMDhjMTFV?=
 =?utf-8?B?aG5yQ3lYeDR6MDVXUTVsUmFxZDdLa1h2cXF3QjlBaWpFcmVyQ3BKUm96RTJ4?=
 =?utf-8?B?Z08vbXBqd21CRW5hQ3NwQTZJcVlMSUw2dmRZbWdMU2Zuamk1K25DREtHOGpq?=
 =?utf-8?B?ME1ZTVJBM3hyWDFrcUxROXBDMFpsQUJqOVRWOWpqdFBlWjVWZHFBT2lBUzF5?=
 =?utf-8?B?RTBORFVZTlhpaG1EMm5iYzhGY3VWVW4yT2VPYkZlcWJqcVFhRDh6dUwxQWMw?=
 =?utf-8?B?ZC9NdVVSUHRoc2JHUHB6T3pXM0VHQWU1dnNWa1NGTVBveUdaRzRVQS9IWlBV?=
 =?utf-8?B?VE5zT0Z0WmJvRXZ6dXNiN2JHa1ZJOW1jWGtFT2hTMEIrVFdpa2VSQzlYaHp2?=
 =?utf-8?B?bTJrNUxnOURZUkNYdXRiNXZ2cG1aZllUTkwzSld4blhhcWJ4YlVTZmtGWnh4?=
 =?utf-8?B?SDE4VXVkcXRuWjYwczU4Zy9PY0dlTWhqbnRQWndqUE5zZGhQMUJDTTRlN0Rq?=
 =?utf-8?B?aVJ3RUhTTWZtL3ExZkYwbjYrdXRIKzdSY0ZQZGRYRUZsaTRkOU5hc2g2a0Ro?=
 =?utf-8?B?UDg3aDA3ak5LaWlQVkEzdkJnNW9YQ2xhRTRobFR4R3ErTkRZVnJkNm9zL1pX?=
 =?utf-8?B?aUxkTURmRjBSdnQ3V3FucG1JR2RXa3NkcnVCMjVDaGp6OVBxKzNObVVQbTNB?=
 =?utf-8?B?T2NVMlczcEhMOE1OUVk0M0Q1TkQ2QlBDaldZb3A3dWlRdVRpVUdzMnlmdXJD?=
 =?utf-8?B?N0MwRnRwRU1aRm1hSlJQdFhZeGZpemRLeUZCQlFnN0VQY3RSY3VNTG9UZWRj?=
 =?utf-8?B?dkJBQTYwcnpCdVlvRC81eTFUckc4VVArdTNUb2RrVm5vMmhtYzN5UmRwS1Mv?=
 =?utf-8?B?dzFmb0RoWlFJcnFOd3JsSDVmMDBnRU1weXlKNy9uakgxYW1qSWplUmpYZ21O?=
 =?utf-8?B?Q3pDWk9mMVBNbDBxdjhBY2NYV2huZlVOcFd6NU9INlA1aktCTWZRYjFQejFP?=
 =?utf-8?B?Vkg0amJZRDBsR1RBNmVvSzlKL0xPUDRzMEpHZDM4c0MvWTdtNzJQeEROTXo0?=
 =?utf-8?B?aW5BQzhQSXdDbnNGSWhORUhGRENCYnJNZzVMckVPeHJIQXcvazJLS3d1MHJ6?=
 =?utf-8?B?SzFGNnF2NnRzQ1VNUzhCQnZuRXg1MjJBSml5a2ZXejV2anRHbHpQaWcwUHJ0?=
 =?utf-8?B?ZEY2aVlLamJTTE8wci9JVW5WWDgyYkY4RVBWMys3Q01JRmMzdDltVDlualBU?=
 =?utf-8?B?c240Wm0rWVh2Q2d6RFE0UENvU3pFdzVCb2FKNUhvemxXQ0xlYlIvRlU4d3I0?=
 =?utf-8?B?alJtLy9qTkUyQWhZdS91S2pXZjVOR0RsZlVGd1NGL0FhMjVEaW9oL3pVTllh?=
 =?utf-8?B?MkJpd0VoUXByOVBQY0x2a2VYZkN5eXB3NU5qSTgwZTV0Y3ZPYStSM3JhNzYy?=
 =?utf-8?B?VnVNaVJyc1BJQlpCOEJVMGdBRExBdFlZcFEzYytTYmg1d2pRczN2K3QrWlNn?=
 =?utf-8?B?dU1PVkxuMCtuRW9COEhzMXl2TDVpZ0ZmenBzR2dTTU5KV2RxdTdSUzQyUlFF?=
 =?utf-8?B?TklzUG9Hck1PWjBnb1JLZXllUEh0UmZ0dmtWNWRUeXBEdEJuU3Y2U3NWMVFM?=
 =?utf-8?Q?HpoAcArJzbk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFcvTTZrZURSaCtubll0MWdMeGxjYmtyWjJkQ0FBY0FGVThUVklDTEZ3S2Iy?=
 =?utf-8?B?YjlQZmJXVFRzWWZhVUU4QlIrSFpySml3ZDJ5bDJ1dnd6dGt1MFRSdW5ZTXFj?=
 =?utf-8?B?QXBid2hLREpkM1hJbXAyMzJEMzJNN0JXQW9UcmEvNWdiUjdGWVVDSkYyUCtB?=
 =?utf-8?B?SDRtRE01Z3VRRHVzb21DOUlKRys0QTBuUEFnVmdzTHFLcDN3OXNXYTFsMi9x?=
 =?utf-8?B?T2ZZQ1hySjluTzhaL3l3cTBpVGMxcEdmbVpodDFrQ0ZIQ1dEQ3pSem5TZHkv?=
 =?utf-8?B?N1RPVER4QW9sQWRsTDVIY1cvZ0Q2WCtoNWFyMExNQlVqdlRvV2Y1L2o2Ty9W?=
 =?utf-8?B?VHI1RHJad0tvTFBFOElxUHpCTWhnenhuNGp6alQ4NTgrc3psTm1nT2RNTkVU?=
 =?utf-8?B?N3RpbTFFam43aVV3Tk5zNWFXVjFDUzU1cWh3bEM3Q2s1TmFwVmdzK1VVYll0?=
 =?utf-8?B?L0w3bC92WjF5ZXBtS3NPQm51b1Q1SG9vSHZLSzdKbFVxOVMvNngzdmk5M2FY?=
 =?utf-8?B?ZVBsRUhUaEx6dWMzSzljVDFBOGhGQXFnZDRaUTZhUjlIaGRUN0E3aWFJcXM0?=
 =?utf-8?B?dXRGS0RncDMyM1g4RUFENXpJb3AySGFkcVRkYlFMVlBnVS9IRjhZR2h6Vnpa?=
 =?utf-8?B?RFhVc2RGbk11TEhNYWIydlkyUm02YlFjTUQySVB0OGM4VlMvRXJ6VEFnZ3Ru?=
 =?utf-8?B?bWVuQ240OXRrRTd5YWR0dzE1UlorR041Vk96K0dIcTI4d3BWdjF3dW1Ha1Ex?=
 =?utf-8?B?bjB0YWErbXUwb0Y1bVAyMkxISWd4RzdEc2M3Sk1FeUVCUkRNYzZsUDhQZURW?=
 =?utf-8?B?bmpFOXNqV3l5WE9uR0FKQ1JweElPWDNpM2NCR2ZJa3NNVk03Ujh3Tzl6RVh3?=
 =?utf-8?B?cWl5T0lSdmoxa1NGUVRObEZERDg3UUhuN0tuS0hpay9UcUI2aXlpT3lJUG51?=
 =?utf-8?B?SFBLNUduekkwc2tSZVVLeWdZbWRCcldWSS9rb0tkS0Zyak1pQTlsZDhtaktU?=
 =?utf-8?B?ekVEVXFZcUU3Y3J4YWpOUzJqM2hEU0g0UXA4QjdLZ3FPWEM0eVRXV0V0MDIv?=
 =?utf-8?B?VFNSSHVVd2dWdTgwTVBoVzdqem9IczdaTXpXelN0ZW8yUXEwY2t6eFZCVm5p?=
 =?utf-8?B?R21aZ0p0MUw5M0JaZUVlUG5oN0dlck9YMWFZaEhtVEFhcjRkeklaN0N3SExB?=
 =?utf-8?B?M0l2MTE4QzRUMTFNUmw2WHRScXhHQU9KT1NnKy9xb1NyY0tqMUdNdVkxRmNs?=
 =?utf-8?B?QXB3eFhKSVRIZFNFL2JHY1NRM0JOVm9tMmJBbTBML0FNVVlLZHpGZTJ5UlIz?=
 =?utf-8?B?bUJFU1d3TFV6b21mRUhPdEFsWVZaSzRuVlFzRjRxdkdiWUJ3dUJyaG5ON3lJ?=
 =?utf-8?B?SnFPY094MnNSZndSZGZiQ3d0UlpPbi8rVGtKdTV6a0Npdkc1USswZkpWd1o2?=
 =?utf-8?B?VDZ4Nm1DME8zUStvZ0doMnM2eTg2WWpLU0JRRFBlL0c2M2QyMkJZb3BTMks5?=
 =?utf-8?B?ZUhJL2U4QnRHVmhibDRqY2RmY1F6cmdIZXE1clpTdGMrS0ZoUGdra0lwZWpl?=
 =?utf-8?B?aFlOdGFVWHlZZTdFSzNSZ2J1VUo3bWxXTVZPZ1p3T25zM0FvaUpTUkplcE8v?=
 =?utf-8?B?b1pKQ0hPUzBxTWNaWlRQSi9ja3lrcWFrdkZxWXM5R3krN2toM2lReFZually?=
 =?utf-8?B?STBYbHNzTitKeGp3NTB2TnlJcmxRZk9yMzFXRDI2cFpvanhneXM0a3c3VFoy?=
 =?utf-8?B?ZHpnQWRrbHBrcU9JMk9ETU05SlU2U01teGFDSzg3QklHbXF6MERxYXZKSVhM?=
 =?utf-8?B?RURadGxQOS9BMWxxNXI3bGNkbzZGOTlGanpzcnlrLzZkNUFqRjJnUDV3VHBH?=
 =?utf-8?B?cjlEbFpOVXh5TXF6ek8vdG0vNmc3NW11eUtYSzdDc0F6TGN0Y0FFbWJUTi9t?=
 =?utf-8?B?NUVTWjRqZURsNW9GdDdwVlE4dkd4MW1heVczeFBUTEF0V3dmTDlzOXVFeHRh?=
 =?utf-8?B?cVR1U05TYjZodnZIc096TmdYbjhTNUJqTUJ3UDZiZWg1ak1XN3VmaGFZa0Zs?=
 =?utf-8?B?bUV1ZFU5eUp0Qk4zb3Q0Y2pYZEdvR2pWb2gyQzlFQzhXY1RoYjAvUjQ1QzVP?=
 =?utf-8?Q?hVmLiNQuWEw7z2f8X7vmhHqFA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a4a1fc-b478-4daa-ea18-08ddc62aa3fb
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 18:40:59.9988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zH7E9Q1eyPOKzuYGTYuPdZ/NLEKC6fL1EAifnVu9ilOUiaqYq3zQl5LDy/LZxGx10k6giTaZvT0VhlwFbn/xWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4844
X-OriginatorOrg: intel.com

Vishal Annapurve wrote:
> On Fri, Jul 18, 2025 at 2:15 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Tue, Jul 15, 2025 at 09:10:42AM +0800, Yan Zhao wrote:
> > > On Mon, Jul 14, 2025 at 08:46:59AM -0700, Sean Christopherson wrote:
> > > > > >         folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> > > > > If max_order > 0 is returned, the next invocation of __kvm_gmem_populate() for
> > > > > GFN+1 will return is_prepared == true.
> > > >
> > > > I don't see any reason to try and make the current code truly work with hugepages.
> > > > Unless I've misundertood where we stand, the correctness of hugepage support is
> > > Hmm. I thought your stand was to address the AB-BA lock issue which will be
> > > introduced by huge pages, so you moved the get_user_pages() from vendor code to
> > > the common code in guest_memfd :)
> > >
> > > > going to depend heavily on the implementation for preparedness.  I.e. trying to
> > > > make this all work with per-folio granulartiy just isn't possible, no?
> > > Ah. I understand now. You mean the right implementation of __kvm_gmem_get_pfn()
> > > should return is_prepared at 4KB granularity rather than per-folio granularity.
> > >
> > > So, huge pages still has dependency on the implementation for preparedness.
> > Looks with [3], is_prepared will not be checked in kvm_gmem_populate().
> >
> > > Will you post code [1][2] to fix non-hugepages first? Or can I pull them to use
> > > as prerequisites for TDX huge page v2?
> > So, maybe I can use [1][2][3] as the base.
> >
> > > [1] https://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com/
> > > [2] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/
> 
> IMO, unless there is any objection to [1], it's un-necessary to
> maintain kvm_gmem_populate for any arch (even for SNP). All the
> initial memory population logic needs is the stable pfn for a given
> gfn, which ideally should be available using the standard mechanisms
> such as EPT/NPT page table walk within a read KVM mmu lock (This patch
> already demonstrates it to be working).
> 
> It will be hard to clean-up this logic once we have all the
> architectures using this path.

Did you mean to say 'not hard'?

Ira

> 
> [1] https://lore.kernel.org/lkml/CAGtprH8+x5Z=tPz=NcrQM6Dor2AYBu3jiZdo+Lg4NqAk0pUJ3w@mail.gmail.com/
> 
> > [3] https://lore.kernel.org/lkml/20250613005400.3694904-2-michael.roth@amd.com,



