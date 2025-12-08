Return-Path: <kvm+bounces-65481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B053CAC197
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 06:51:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A92D030281A1
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 05:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D982517A5;
	Mon,  8 Dec 2025 05:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M7gQJYz+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C444C81;
	Mon,  8 Dec 2025 05:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765173080; cv=fail; b=ZNj27CUxneN/g5CKrry/uNI7wz+2QmsZMNfl6cjigF8tLAEIw1jw1txCLsnO9gUDjO7vWiHRMRnGitXWahnYTPqL2IkVnd1huiLyHZCgpzwItJLNLTEXTaBcO6/qJ/5esjfRFcgGGxULGb3rTImwL/RBhUg6c7f9wDuKQmUdJYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765173080; c=relaxed/simple;
	bh=NtBaw220iz1OorZ1EYlXKsfdzWeIWOdS6+lhteE2pNA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iYQ8wM6hhVhX5WAfmNz0xwQzkHXoFH2ei2dmqtzPccev9pM231YtUhUkY0S8Y2yi7Wkx5iRnbSGk3pNOEWAF33NIPiS5LBIi7oiBz+4lao+inXkA8jYHJ8OXPNWXFnHzNRsn0mKe27iV+ENPWGNLajxh7dxXzZvAHgg3Fb8WlCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M7gQJYz+; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765173079; x=1796709079;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=NtBaw220iz1OorZ1EYlXKsfdzWeIWOdS6+lhteE2pNA=;
  b=M7gQJYz+ZDdKpGfJEThPb5E6k/LVnpdckgrZPtPE5174C+Jn1YqFk5LS
   wT5e/rFtRRBDqYRm4VywQq9zE55tFAS5jq1e35Uu1lsAk6jOkubro0edE
   CTEJIKKLaVSRVmBvS0hj8uRyvFDptWo6dZECVEszTSAI0tysbBjjrnueC
   E3MF9Q64UpfvvcCj4s8cHkhzGc5NT96WfWR+dgmBY5MdJm/pKYc33OWL+
   J+5Zt+NHzWLtcaVPcyjmTq2rQ3lTayiViOytdKigIF1uGowF99GMUH2lu
   HXtLayk/Gve1BZR40fxtcljkQHzEOXsLZfXfGN3t0k+9WOg16WkJdg2Sx
   w==;
X-CSE-ConnectionGUID: jcaqZU5HSjqr8BWaJgf85w==
X-CSE-MsgGUID: /nWPUVIxTTu8BnoVwVTXaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="66111670"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="66111670"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2025 21:51:17 -0800
X-CSE-ConnectionGUID: dK7V9fzuRR+MOu/R3xfyHA==
X-CSE-MsgGUID: rAOW7+S/T+Kau+MdVS8BAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="196309153"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2025 21:51:16 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 7 Dec 2025 21:51:15 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 7 Dec 2025 21:51:15 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.24) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 7 Dec 2025 21:51:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dc8ZLx6O8eGwkfu0uewoYyAK2p0OvQ2O97wFTDlCpbNcrZWMJfs7s3pvfjDFnIHg1y8FXH6Ib66GAteVvKo8sJhrlWanzmEB3QAPi8qMChez72/kR3bi1w4y2PomTxaw+mjTqydLmuRIJJ/PiPViEeFhQyZIuWgJdNfVAaTNIM7An9SKp4U92gfyNKqvBRh/oRDAtZpd5zGTqpRZWEmUeV5m1vLiuf9jVkME9hcMT0fUHW6/tuBVIN6aheLSaOoon3sXF/UvRFPnDpuzjMwvvIPdqqpiegyXVBYFEMVR0oF30HdBj4sTS9P1KW6K4TAHuJo6ZyLMz5dL6qGyu15NXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OlKwgRSmZP1Il9LXessw6isl5vNjxQTcQABKOkkf5AQ=;
 b=uIe1L1ZPnHp7Nv6tbHO72QI4smKLUj99C+GlFOQWiQuGog6dGvr8a6GLANRrkuthZZ23uZb+z6hrZ8PYw/RYj1t1EwhH/ie7f7u11ymL+uTmVv/1TDDnOloYJlVYeG91aFbHu+g/fvk4GJ7vtkpoYT9SiHXwIQVf7FB4m16CShmCMUjUmVUgueEZvqzSue44J0ZlKJ3ha3MJG8Rly8DDVG+UZPWwESTnNFk0cR9JPCdtGrf4TCUsKb5JyeWBzD9bGmGJd6gex+f06HyKz7i+O0TUr3hoTiTH5NFWVmMlYrLqxng41dQeyN/saD+1QI1dUjWshnHhjBli13thk3mawQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY5PR11MB6281.namprd11.prod.outlook.com (2603:10b6:930:23::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.14; Mon, 8 Dec 2025 05:51:13 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9388.013; Mon, 8 Dec 2025
 05:51:13 +0000
Date: Mon, 8 Dec 2025 13:49:15 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sagi Shahar <sagis@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vannapurve@google.com>,
	<vbabka@suse.cz>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 21/23] KVM: TDX: Preallocate PAMT pages to be used
 in split path
Message-ID: <aTZmY1P6uq8KWwKr@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094604.4762-1-yan.y.zhao@intel.com>
 <CAAhR5DF=Yzb6ThiLDtktiOnAG3n+u9jZZahJiuUFR9JFCsDw0A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhR5DF=Yzb6ThiLDtktiOnAG3n+u9jZZahJiuUFR9JFCsDw0A@mail.gmail.com>
X-ClientProxiedBy: KUZPR04CA0022.apcprd04.prod.outlook.com
 (2603:1096:d10:25::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY5PR11MB6281:EE_
X-MS-Office365-Filtering-Correlation-Id: ef202598-8a0c-493c-455d-08de361dcb79
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TDJGaGg0bWNYU1A5aENFRGJtWmw1ZHVjMEV1cG0ybW1vWVFDU3IxMXFDMmll?=
 =?utf-8?B?ZUpNdzZpc0xNVURLSE5uQUtFNFVRZHRtZmVpTThRaCtVblp2YWxuWjdKMm1p?=
 =?utf-8?B?Ukc0b1I3ZHV5cHUvU2ZLd3FvLzFRd1E0dUNaRzFVS0tHTzhmWkQ4OEFuY21G?=
 =?utf-8?B?UjdiVHRPSmd2RHpjdXlnaHJIejJ4MXR4c3F0YzU1eVMwWTN4bmo5Q0l1QTFS?=
 =?utf-8?B?WXB5NWY0WTF2SDJRdFR5bnptWVRyR28vZUV4LzdGQ1dkV3JocTQ0UHMvNlFN?=
 =?utf-8?B?YldvT3hTNlFzQ1hXUkUvbDBROXZIV3hXK0xkN3p6Tit0N3lYU2VSMk5VQ0JO?=
 =?utf-8?B?TG45STNKYWxDbUdCVm9iY0wvVzAxSUFsalBTS1h4WDhkM0gzWHR1bnZUdU9n?=
 =?utf-8?B?UGl5dkZabEs1OUd2dEdKYUE5VnJMNFA1S0VzZWxJamsxb1gvNjcvYnNZU1R5?=
 =?utf-8?B?S2pkRlppbE5sVVFWdzJ2cXpDSnd0am9BU3VZb1NMVG8ra2xpektDcHBlMHpX?=
 =?utf-8?B?Ny9sSU8yUzB6MU1iMXpMaE5GWFlUQ2JNbXFsWDV5YU5PMks1SWpLRVJjS2hl?=
 =?utf-8?B?ZUxWZlB5UnNiOXRPb0FjdzdMRy9HbG9xQ2ZoVU5xc3VPSlZiUUpranY0RldS?=
 =?utf-8?B?WTE3L3FBWUlwTTI4dm9sN3E2eVVXT2NxdDgxamlDN05xazNoMGFRbUd1Mkc4?=
 =?utf-8?B?cGY3OGFmQy9TYWt1VjdxdC82NC8yVS8zNHhocHRMWDd4WW5oT2N3cnVzSExG?=
 =?utf-8?B?Z2pJZEZyYy9wZ3B1MTFnSmhmaWhwQTFHMHIxSUJIaEpnVVE5VHZReW5tc3F0?=
 =?utf-8?B?Tm9wQ3JFTG8wSnA3Si9WVEQzRkxmeDZZL0RMZHIrUVZLaXA2V3Rmb0lQME9k?=
 =?utf-8?B?VG10YUw2STNPYUJsNWU0cGZiL0NMSU1TeklUVWlxZGVWSHhIaDZZbDR4M0o3?=
 =?utf-8?B?cXYxRmM2TENCZ3BZUnVsbnJ1b09wS1lyQkJhaDlZeGhkYXh5anVhVEFmTkRO?=
 =?utf-8?B?NmZkQys2aTBFQndiSFM3R3lMU1AvMU8zblQ1dUlwM0hrMGpUQmpVS2FwR3Zs?=
 =?utf-8?B?a1V4dzVUK3FsZnpxM0lSenk4SzJEaWdubThVSWtEWkVNMHJTSmhScDE0dy9N?=
 =?utf-8?B?WGlNMW9XQkgzd3FJdFdzamIwaFlYY2JaeFl1c1R3OVgwRk44NzdoaG0wMW1M?=
 =?utf-8?B?elh5cktFeE5kWm1hM0diTTJ2WG1CUXpyaHo5cVZjdGNrYThvaWoyWG9kSnpR?=
 =?utf-8?B?Q1F5K25qOXhiM2w1eldUblNQR1ByUmMyL1B3QkEyWXJLTGpTakJiQ1Jpb1M1?=
 =?utf-8?B?V0tpaUpRN0FvK25YZ0lPd0RFN1FQQU80MlBjalk3K3lQTFpIWVZHOFlSMkJk?=
 =?utf-8?B?SmV0ZkVwbW1xeVdibFloTmdUYzhmbS9xb3o4enpBL250eE0waldzUkNjc0xv?=
 =?utf-8?B?bmJkekpxZm5IWmFoekFldEpGbnNBWkw0OEhvL3RNTGpjVVhoTVRZUjE2bElZ?=
 =?utf-8?B?eUNDSVVnNmNuVkZsREpWV3J5SVY5dTI4eWdBR21icXJpUHJUTXlmc254aU81?=
 =?utf-8?B?Y3JGem1KaktyTWI0bnB5RVZOcFJtYzBWR0k1SnJCTjAzWWovYTV3Y014YlQ3?=
 =?utf-8?B?Z2lFOGxWYW1oektZVEJ4UkJLVUNBbHhzZFh4bFlianc3aXIxejBzdkJJeUxT?=
 =?utf-8?B?MDluS2RZbm9OVG1zeURwalRzRHdIMVF1aHFiV1lqV2wwdHB5TDlUUU5waUQ4?=
 =?utf-8?B?eEFybTVmb0xFeXRSRjdYSVB0N05Oa2xaamVDRlppWjZiRTdSQ3Vxdy9wYWJo?=
 =?utf-8?B?SVlybWRFaEdyaDR1ZkdveXhjYldxVTRYY0VuSlZqcGtpY2VvZHZndkVLYWtj?=
 =?utf-8?B?c2JRNERhUTlVY1RYa3hyRktvYW5COTNzMXhUZmJyeWRJeFovOVNjMmI1YVpy?=
 =?utf-8?Q?kIrtwet54O7qFyk+87NGHWfHioV9DBe+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Znpad0NqaGNHYm1HZUpIbTFBOUM1d0tFV2U4N2tpbGVFeEl5N3UwVlJBd2c0?=
 =?utf-8?B?NGJEb0F3N2c2cmw0ZmM0b25kc1dUL0pOQnFYaUNpZk4ydXIvZHlQbHp5dHBm?=
 =?utf-8?B?TTRjdVN5RGRRR29vdnRndUxIR1kycTcxUEZvV2VvNnJrUnJWMWpteHpGL1NG?=
 =?utf-8?B?L0RKRVlGTWZON0g4ekZaT3ZyaHlMbkdma1ljNUYreEZCNlN5OW9TUTRhbmtJ?=
 =?utf-8?B?L0FUazhNeDltZGxmWTRnUDVmZmwxTFIrYXZ2MkFWZjZ4MWs2R2t5TjZBK2Fj?=
 =?utf-8?B?WStGM09jdjRKOGhjcTZ2di9NZUptc2tqbHZwSjhiSWk5dHRQNjBEd21SMWl1?=
 =?utf-8?B?Q1ZrL3V0YXdSYUFtQU1ad2VXaUl6Q2F1RjRySTdBaUpmcERPTUpMVDQ5NFRJ?=
 =?utf-8?B?L0N4TWR6L25paEtjM3Vub0RXaG5JTWovRjBBYzJWQ1RBVDhjSlh5SzY5eEdx?=
 =?utf-8?B?d3JwMFJ0S1lqeTkyRGtUeThycjhodjJKRjJySHZUck9DbHhJemYxMW9FRGNk?=
 =?utf-8?B?TTdBK0ZCem1UeFRsaTJEdjJoWGY1VE0yeVE2Qy92MXc0Y0RpU0dIRllFUklZ?=
 =?utf-8?B?eFQyUDNxaGZDaDhxZE90NExDakpMVnJjTEJnTERIc0R5RFZZa0NRbUVKbnNm?=
 =?utf-8?B?S0g3MVlDaFBjdjh6d1ZvOGNlQnpVM0FEcGZWM0p3dFJyZTdJeXl2NmdRTnBF?=
 =?utf-8?B?Rnp0TGZnbmREMVhRK1RKazNROWEycDV4VjdaendOUS9pekZPUjJsWGVxQ3kr?=
 =?utf-8?B?ZzhqRGcwNW1qU09jaG9FZjdsU0tpZUIvVUk1b2FuOW9wci9laUx2TTBjeFpC?=
 =?utf-8?B?Nm9OYkJQOFRnMy9vaVdBWEhNaWhVYnRCSUo3bjF4cElmZVNYeWR2dDdFVEVi?=
 =?utf-8?B?Nkp6djJOdTJ2d1ZmNDRkcEF0MW82dzV5S3dBMVpCcFlzWCt6RkQ3bThaU3FV?=
 =?utf-8?B?UzZ3UEwwcnl1bzRyUFNGUUNoTVgwS1JBYUxaRXJQcEMrU3F6dHhNRUI4N2do?=
 =?utf-8?B?eTRFQVNhenZsazJSUjcvaDQ1L3k1K3RKNnVXZUtZcnlIQk9zcVNrc2RXVndn?=
 =?utf-8?B?NDNUV0U0WDY3bVR4WHQ2OXZlcUhPV0VwT2NQcGIzWHp1N2l6NVppRnIwaGdG?=
 =?utf-8?B?YXhraHpJNU44ZFhndTdKSHN2WVdJYXd4R25kY2gxc09NM2o2Ump1MlR4dEFU?=
 =?utf-8?B?ZzdVMTg5bDhyTndHSDQ2bUNCdmdJTDRWNHJFSHQwNkYvZ0h3ZUg5RThodFJD?=
 =?utf-8?B?UDhSK1RiVWhCOXdDcGV6eXNVcjJManRHTXozWXRIUXppeEFGS08vd2xsbHQ5?=
 =?utf-8?B?b1NaRHdudEUvbjlya21zT0lKamVLZnljWXRLUjRNa25Vd0o1Q0VwbDhhYzgv?=
 =?utf-8?B?dWxrU09KS1lsV3Q3RW1ULyttQXk3ZXhDc1kvZVNTNSthcm9hdVMzUjVvYzYr?=
 =?utf-8?B?cWNiRmlkSmNYUXJ4UDdOWk5RNkJrWm9GcWhhMDMvUEdaNVNpTWxETXc1djE0?=
 =?utf-8?B?WStKN2wrWnVoc1ZReEdiYWJDYXpOTzJrZG1xcGRHdFJ4Q29PdkwrZ25lbVRZ?=
 =?utf-8?B?Q3FpaGlKVGNqR3EwRFVUT0JQUjZKTUpzVDBaWExHcjhMb2ZFSUgxZHZlaUxi?=
 =?utf-8?B?aXdTakdFNjZJUnN5eFh1MWw1bk5NZnlTTlkwUnhPOWFkS3l0dUI5dGdlYitU?=
 =?utf-8?B?eEcxOGRaQWZMQjhWM2JEU0dHVHp3K0cxeElxRFo1R3g3NFIwWHA1VlFqTzZj?=
 =?utf-8?B?UThwTHFic2JiT0JCRXF2MmM2RzRnd3BFOUN5bkZRUWlKUnZYYUR0Tjc2TkdY?=
 =?utf-8?B?aEFsT1dUSHhVWFRJelZhdXk1NE50b0krZUpHclNYVU1POWdOajBCVkl2ZFVx?=
 =?utf-8?B?N3VrdFlQR3NBWFhwSmFDM2pYMEdSNlpZZko0cERHRXUrRGl5cGVVOHlMVytX?=
 =?utf-8?B?TFpBNVdOY253bEJQNXg5R1k0Y1hrVk9aQWI3T1JXZW5ickdlc2J4eEp3WXpi?=
 =?utf-8?B?NWNHZlU2aFpVZzhSbERxditLbFJiV093ZGZyS3k2MElJdTZxa29CT2ZrRERS?=
 =?utf-8?B?eGtjTDYrcG9DV2szUnAzN0MwUStNMmNlSlZnUUg5RFBzazdVaExxeXNpelNa?=
 =?utf-8?Q?KIf3rwYrlVHFUX37NvJoJwoYk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ef202598-8a0c-493c-455d-08de361dcb79
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2025 05:51:13.1054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DcPalGhduETq/nqOrMQvul5/hoMxnA2gT+VIJpCGE8pkycfX16qb+p187uBKqBWz4h/V2oWEoq8E7YQ81OlOtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6281
X-OriginatorOrg: intel.com

On Fri, Dec 05, 2025 at 12:14:46AM -0600, Sagi Shahar wrote:
> On Thu, Aug 7, 2025 at 4:48 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >
> > Preallocate a page to be used in the split_external_spt() path.
> >
> > Kernel needs one PAMT page pair for external_spt and one that provided
> > directly to the TDH.MEM.PAGE.DEMOTE SEAMCALL.
> >
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> > RFC v2:
> > - Pulled from
> >   git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git tdx/dpamt-huge.
> > - Implemented the flow of topup pamt_page_cache in
> >   tdp_mmu_split_huge_pages_root() (Yan)
> > ---
> >  arch/x86/include/asm/kvm_host.h |  2 ++
> >  arch/x86/kvm/mmu/mmu.c          |  1 +
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 51 +++++++++++++++++++++++++++++++++
> >  3 files changed, 54 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 6b6c46c27390..508b133df903 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1591,6 +1591,8 @@ struct kvm_arch {
> >  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
> >         struct kvm_mmu_memory_cache split_desc_cache;
> >
> > +       struct kvm_mmu_memory_cache pamt_page_cache;
> > +
> 
> The latest DPAMT patches use a per-vcpu tdx_prealloc struct to handle
> preallocating pages for pamt. I'm wondering if you've considered how
> this would work here since some of the calls requiring pamt originate
> from user space ioctls and therefore are not associated with a vcpu.
I'll use a per-VM tdx_prealloc struct for splitting here, similar to the
per-VM pamt_page_cache.

diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 43dd295b7fd6..91bea25da528 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -48,6 +48,9 @@ struct kvm_tdx {
         * Set/unset is protected with kvm->mmu_lock.
         */
        bool wait_for_sept_zap;
+
+       spinlock_t external_kvm_split_cache_lock;
+       struct tdx_prealloc prealloc_split_cache;
 };

> Since the tdx_prealloc is a per vcpu struct there are no race issues
> when multiple vcpus need to add pamt pages but here it would be
> trickier here because theoretically, multiple threads could split
> different pages simultaneously.
A spin lock external_kvm_split_cache_lock is introduced to protect the cache
enqueue and dequeue.
(a) When tdp_mmu_split_huge_pages_root() is invoked under write mmu_lock:
    - Since cache dequeue is already under write mmu_lock in
      tdp_mmu_split_huge_page()-->tdx_sept_split_private_spte(), acquiring/
      releasing another spin lock doesn't matter.
    - Though the cache enqueue in topup_external_split_cache() is not protected
      by mmu_lock, protecting enqueue with a spinlock should not reduce
      concurrency.

(b) When tdp_mmu_split_huge_pages_root() is invoked under read mmu_lock: 
    Introducing a new spinlock may hurt concurrency for a brief duration (which
    is necessary).
    However, there's no known (future) use case for multiple threads invoking
    tdp_mmu_split_huge_pages_root() on mirror root under shared mmu_lock.

    For future splitting under shared mmu_lock in the fault path, we'll use
    the per-vCPU tdx_prealloc instead of the per-VM cache. TDX can leverage
    kvm_get_running_vcpu() to differentiate between the two caches.


Here's the new diff in TDP MMU rebased to Dynamic PAMT v4.

+/*
+ * Check the per-VM external split cache under write mmu_lock or read mmu_lock
+ * in tdp_mmu_split_huge_pages_root().
+ *
+ * When need_topup_external_split_cache() returns true, the mmu_lock is held
+ * throughout
+ * (a) need_topup_external_split_cache(), and
+ * (b) the cache consumption (in tdx_sept_split_private_spte() called by
+ *     tdp_mmu_split_huge_page()).
+ *
+ * Throughout the execution from (a) to (b):
+ * - With write mmu_lock, the per-VM external split cache is exclusively
+ *   accessed by a single user. Therefore, the result returned from
+ *   need_topup_external_split_cache() is accurate.
+ *
+ * - With read mmu_lock, the per-VM external split cache can be shared among
+ *   multiple users. Cache consumption in tdx_sept_split_private_spte() thus
+ *   needs to check again of the cache page count after acquiring its internal
+ *   split cache lock and return an error if the cache page count is not
+ *   sufficient.
+ */
+static bool need_topup_external_split_cache(struct kvm *kvm, int level)
+{
+       return kvm_x86_call(need_topup_external_per_vm_split_cache)(kvm, level);
+}
+static int topup_external_split_cache(struct kvm *kvm, int level, bool shared)
+{
+       int r;
+
+       rcu_read_unlock();
+
+       if (shared)
+               read_unlock(&kvm->mmu_lock);
+       else
+               write_unlock(&kvm->mmu_lock);
+
+       r = kvm_x86_call(topup_external_per_vm_split_cache)(kvm, level);
+
+       if (shared)
+               read_lock(&kvm->mmu_lock);
+       else
+               write_lock(&kvm->mmu_lock);
+
+       if (!r)
+               rcu_read_lock();
+
+       return r;
+}
 static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
                                         struct kvm_mmu_page *root,
                                         gfn_t start, gfn_t end,
@@ -1673,6 +1723,23 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
                        continue;
                }
 
+               if (is_mirror_sp(root) &&
+                   need_topup_external_split_cache(kvm, iter.level)) {
+                       int r;
+
+                       r = topup_external_split_cache(kvm, iter.level, shared);
+
+                       if (r) {
+                               trace_kvm_mmu_split_huge_page(iter.gfn,
+                                                             iter.old_spte,
+                                                             iter.level, r);
+                               return r;
+                       }
+
+                       iter.yielded = true;
+                       continue;
+               }
+
                tdp_mmu_init_child_sp(sp, &iter);
 
                if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))




