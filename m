Return-Path: <kvm+bounces-54377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C3FFB20178
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 10:13:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC2933A1B59
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 08:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E2002DA75B;
	Mon, 11 Aug 2025 08:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E1BQS2fz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F0B72624
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 08:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754900000; cv=fail; b=Nxae7fqsB1z2qDvzPj/shzNQw107ETWzEqjr1YV5tzyVNb8yAXr3kpjtqsnqjvwA8EcrKZbbS+Dpn6IfPsn/lsEj6aCSVFgbPhimgp5KH52rktvPE9GhQLcelgaUhYQuNUq0IWLMjs8pa5DB75lH8hV3Rsa4za/oXpAJqak+r3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754900000; c=relaxed/simple;
	bh=J/ye84kyC8dmoLW6mBug1Mn57g6TeQk6EE56DeHSorc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BbitVzAQCJlsdz+RhVgsw6sBVyaxcPBwIq2ZSBoFjHknJNA55pvT7mrhNlWxc+Qr+dF+P8FcgT+dmPWAliT5XLnOHNoAxkkkStulJsMgPuUvC0G2p6GalKBs8j5RjlE5kf5U8JLfm27zk438m2/1K1qsmktcRsW78aDEPBGWwsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E1BQS2fz; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754899999; x=1786435999;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J/ye84kyC8dmoLW6mBug1Mn57g6TeQk6EE56DeHSorc=;
  b=E1BQS2fz5uBIXVHgUmBA9zN0/E3oMEd+ofTOdOHDUJ7Us9gS8zxG+15y
   8hNaB/TVNbagPV7tsiS0ruQvYN0aRR1HC58BYdnSAty6hmeFR53vKk9A+
   nvv0PdkzpNc+DopnT61SAScbbnS8JxWS0i2bvyCPiliXDuodgACNH3S7I
   QT3GEaAgrWi9XpJidR8Ub3teKP3y14RGMEzV/pJXOM28+/ks+iBiwAT/N
   JCXJTQCoyeJisI9Appq7KuLN73QEyFNmCEmC+2kYIhQAjeW+gTJCShh7C
   fNCDNSPobMs4SBtBdPJL6dT5JyXBlgqYXbxFl6lc0v/RtLrNP7Ene+nfq
   Q==;
X-CSE-ConnectionGUID: ypRb8MsgS+ml9+5gx7cmxA==
X-CSE-MsgGUID: 9clzMy1hSbmpqE0CskHwag==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57289155"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="57289155"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 01:13:04 -0700
X-CSE-ConnectionGUID: ebeRtDc2QtGBZz9eaPPCYg==
X-CSE-MsgGUID: LBkPpJDwQHuIVmydyIMzsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165348683"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 01:12:59 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 01:12:58 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 01:12:58 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.61)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 01:12:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Or3lXvaaRs4n7vPRoqyIDpHr0bunKy2vvTpR1qNYBACRmz+dIMW1TEAfOZg8eIHdPlEw9c04sPYchqDEBQrXccvmMQCe7zWmrz4P3sWnx/eaV4DMGSGd/R9/+8Gm9auFlcuf+ZeY9UFWN12YVd+BBVWZI+c/G1kBAOwwjhpLuIBYfDXvd0U7mg4/SZizepZ7sbLMOfHgf8OpZEJot8fTOcS5RuLXsRorMXiFCaUREx8ZQDOPG8CYArO9TdEvhEZXjvLWhzcB6iySmUyYIPZXkTjPQRO+Yt5gNP9mb0PziKjeF5HvtDx5Ha6h0ZJiAEquBq/Q5FJVZsOcu+Nw/y5+/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ow68z3WT06wdFGQ7d2apNd4YaH8lGN55QpV4bz7CSjU=;
 b=xn0GmPV43ZGh+pav3vf/EKLWwR3jqnBbjnlCSDZC5MT8ZH3qQcN30ZelgyN2u2cDQCQn4KSDtgEf3qyzsJBIR34fXxKHc9GCdsWxJg3FMajt7EIIfDG9l45AfkXHQxpLNoA/i3AsvzelFLpX5RlmryO3T6iV6sXkK0a+VmT2n83YrDUAeAkdI7YCt1p5Rq5b1WVR77g9LnnBuVD/C3OaNg63ZJ4M19eI30mPCWkHAEBpyHKPJB/1pfZ8gwkPLxTU0mj6JvQjTlBsIsJFjBEW3OWdegU0pVURWZlS/Sprr1orsPjgBngR3Erhy27Swu2pcwt7QH/2J+D8h9rpOL68Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 CYYPR11MB8429.namprd11.prod.outlook.com (2603:10b6:930:c2::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.18; Mon, 11 Aug 2025 08:12:56 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 08:12:56 +0000
Message-ID: <d6d3eb1b-e045-40be-aef3-32b00d0d66ce@intel.com>
Date: Mon, 11 Aug 2025 16:12:50 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 1/2] nVMX: Remove the IA32_DEBUGCTLMSR
 access in debugctls test
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>
References: <20250811063035.12626-1-chenyi.qiang@intel.com>
 <20250811063035.12626-2-chenyi.qiang@intel.com>
 <6c5efe8d-317e-46ad-94d9-a36adb076936@intel.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <6c5efe8d-317e-46ad-94d9-a36adb076936@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0029.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::8) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|CYYPR11MB8429:EE_
X-MS-Office365-Filtering-Correlation-Id: c71a7cd3-f7e2-487b-8df1-08ddd8aee0b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UHgvcDZVRE1xWWtabVlvK3FWZmRsWkR4ckNKZlUvQkc3UzZrejVGVkx0Y2Vu?=
 =?utf-8?B?VG9lSTJxdzQrellKMlRaQlJGTjZBZzBOVWxWOG9vWnZlQ0ozRUVOS0c0bjBq?=
 =?utf-8?B?S1hha2lxUmZJQ1Q5WlVUeWpRa0MxalY3YlFBdk9PS28vNGl3S0ltODRVTElM?=
 =?utf-8?B?SFAzMjZsUXR1NUJxYlNESG9zZ2hmWldJTTI2NXFaMjh4UEh2cVRPNDNsU24v?=
 =?utf-8?B?ZmtvNStHcDliNGg3d0tOcGFFN094QUFPVitvWlhZWWh6M21MZE5OaFgvbWdB?=
 =?utf-8?B?V2xrOUpISFNXNVBSTWdRelliMmVLaytrNkJDT21oR2R4YzhWMkhZTHpVQTdm?=
 =?utf-8?B?SFVxZlpvOXpzeVp1YW11UDFRQnhRa2NNZ3BSQlFlc2s4ck1pcG9iOUtsckNF?=
 =?utf-8?B?Sm4yR1EycHhFWU52VzJnelFSUzV1SnhZNFdFRDdTYktlallNYUpNOVpMVFdp?=
 =?utf-8?B?VjRGTXlTTlk3N01zWkNCTmpnVFA2UW1Qd1pWeHorYW5lWGN5eUM3ZWJ3cEZG?=
 =?utf-8?B?aDZ1TUp2b000Mk9QV1RCTUw4SGhLcXRDdVpQTnkxTmpHcGxIUklsd1lLRndF?=
 =?utf-8?B?V2hBalNXYkw5a1ZLM3M4d0dtazJPZDVKNys0TDFmdFdWUHA5KzdtNkZBM0hx?=
 =?utf-8?B?RjlTUXZTY3g2ZTdQL01oRE1EQ3RBTjlIWVJrSG00Q3k3VDdIeVNzQjFmcm1a?=
 =?utf-8?B?a0tQNWlpd0JxVWw5akFOQkw0b0tVSFhMMUFoR1R4bmtHRi9KRUROdlFhbWgr?=
 =?utf-8?B?dGQvKzVYTDdoOVBGM3lLZ3FLZVdsSlg1b3pQTmdTZmNaWGJhZGtZaGdBWTRI?=
 =?utf-8?B?UEdjY2hGeTEvM1Zqd0NYU0xCLzd5T0VIQXRZYUpCdTJ1VUNGbldCMW5GRTMx?=
 =?utf-8?B?RHpsM2lPSEF1Q2laMmRodVpHRlAvUWxpVVVpMGhLWVJVSExOMzVOMEtQMzBr?=
 =?utf-8?B?RDVmVFpHWHRkYmZSOWNQSkpTWVN2R2cvKy9xVGtBOU5oWEQvZHYzVVZSL0JT?=
 =?utf-8?B?Wmg2SitISmEveWF5c2xwM1ljT3c0dmtDd3pMTWJWTU1XT3RuOUVTTUxzWnU3?=
 =?utf-8?B?aUV1MHNTdUpHaExUL3FXRmZ1UkVLVVFUNTQzSzhsa3U1QjN4R0JYSzZjNWwy?=
 =?utf-8?B?NmMwSDErQk1yRXJEcHpkQ3JoYk9meTY2cW15aG9TaEtDT25LWEdQTTJISnl2?=
 =?utf-8?B?a0RBZW1EMjRpV0JWSTcwT0Fmelg3a2hSczlrbTh4b2xzYjVpRHA4dGZXWEhr?=
 =?utf-8?B?bkNyVDBHSzJkZmJKSHVscGxqUDFrOE1GSDM3aWhjb3VuNlVDTDdCZUFIbEds?=
 =?utf-8?B?UFQvbkw4QkUwVExudXduc2JHSWdZWmgrb0NBQkgwR0RCb2R5SXNLSzB2K0ZR?=
 =?utf-8?B?ckUxeE93NnpJV3hQaG9ZUitBWHd0dzNWSEF5Y1NtcnBDZlhzOUVLMVExNGhR?=
 =?utf-8?B?ZzZqUHBJZzVLZFFhcVBWSGlFZGNkOFNHOU1jaDU5Zmh5RDB1Z0RucDB4MUZi?=
 =?utf-8?B?aGNiZ1l6cEVWeHowUEgwUFRENE5sZHBqa21pZU5nL1BVdE5sYnVWdkhMYlM0?=
 =?utf-8?B?NHJjVktJeFNiNnQvbVlXMUpDZEN5ZFRJYlNHVldZUk8xT1d3K0R4aERnUnE5?=
 =?utf-8?B?WUs2dGFHeHp6OElWTlRqZStJT3MrakVTZmdob3JleDZvbktYQkZIWWhGaFRH?=
 =?utf-8?B?SlF3a0t2QW1MaEQwS0N6c1NoKzFyVVBWaS9WTnh2aGxpVVlYVHZIQnFHVHBs?=
 =?utf-8?B?clZxeGZVMVBiMGJRWEMrd2M2VUMxY0VoKzdTZUsxQUxCT0hXMVlBVDgveEJq?=
 =?utf-8?B?dGQ1MzY1MkkydkUxZjQ5clNnTHAxV1BRMTZKeERaUzZBcHkwZG54b3J3dFpv?=
 =?utf-8?B?M0tpNXMvYlFNcVI0Ykg0bzQvU20zbjkyeDFSSC9Gcnk4dWhLSXdsc0pLbGVv?=
 =?utf-8?Q?k2LLYogXIEQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUdPcnE0TWZQTGpzRExsWGkvcDEvUkhQQ2s0L1daVkhuYWV1SDlQRFhEV2ps?=
 =?utf-8?B?V1dFc1VZMTV2aWp3ZkRRNVNDcVVNNHJ0andMRkl5UlErbnhKeEEyRG9yK0NE?=
 =?utf-8?B?d1BzUUFpMStldnJMbjUxcjhrZlVZNHQwZVNJaVRPMlRoMHNDenpzbWVmWng5?=
 =?utf-8?B?MzFiSFNTQ3pSVGk0a1M4c3dIRW1scy9sOENKdXdBL0dUOEE0M0lzNGJ2RW45?=
 =?utf-8?B?djNqbHJVbGUwUU54dmFha1ZzR3JXL2ZwTnQrczlGMFhHdEY2ZmxmbVgrdVVq?=
 =?utf-8?B?dUtRbURSbGJwOXFDTHk5TmNGcFIwaUNKcFQ3Zklsem84VDNkYlJlc2JiK29F?=
 =?utf-8?B?YU4wM3JiTEUwTjBiZzFwcC9Cbk1seTl4UjlXYTdORVFJUGxOdmVBMEJKakVX?=
 =?utf-8?B?S0R4elkrZmphNFRKMmRGTXRXRVg1WDdFZmcxQWtFN2dYajdBa2xwL3RIMmR1?=
 =?utf-8?B?OGpIMTFZM2lOak5XbTVUVXVrdGk2UHBia0swTDU0Wi9HRWJRN0ZaRHBmQXBT?=
 =?utf-8?B?cGFtRG5KNHFOZVhzcDhvYXJFTWlnUVpIaHRDSVcwbUhrUysyeTg2cWh1c1pB?=
 =?utf-8?B?YnV2NVhhcTE2VVlzZTlvQ0cwL3Z1WTZrNE5TOUd1TnNFQXdlNkVIbVhSUit2?=
 =?utf-8?B?RXFuL0w2MmZrTXhIb0F4N1MrM0FxZVJUdFdzWU4vZnIxS2RkL0hzVG5hV1ps?=
 =?utf-8?B?aUVvM2lES2tHWGxtYTdGMnRJRCtPTlVCTHQwZGVOOXowZGFUVE9XSXlkVU02?=
 =?utf-8?B?UThFb3FDelpRV2QwWCtoUlkyQ3BaNWNnZ0Q0aDhmcnFLSEFudDF5cHRpMk1U?=
 =?utf-8?B?VVJJdnl4dGd6cWt0dWpvdnluNEU0TFdnK1IwbDFQc1ZXUU9JcHVWekdHcFE4?=
 =?utf-8?B?L3RQNE00djN1ZHNxdGZVaWJRRit3U1dqMEgrQ25XNUJwTWI5WDM2TXUvdnVM?=
 =?utf-8?B?cklEdGVBODBqNG5YSzdBd3VRVHAxZnZDSlZUUlkxOFRVcXp2MUR4Q0tYcEdh?=
 =?utf-8?B?NnE3WmJuVlU5dGJJTlJTa0dvTlRac2s5L0FtZElrOWJ4NGZ4OUF0bW5lNUth?=
 =?utf-8?B?cHp6ZFNMSElJdXhRajc3K0RIQWJZdmYxVjJ2c09qMkJOeWhQTktYK2ZUd2tP?=
 =?utf-8?B?RytSOENkNGVvbHhzNTFTL1JGQkRVQjFCRjVFdjVuWVQwTGU3aXpueDZxcmQz?=
 =?utf-8?B?SERxTW91MDArQUg4RXNjbVQwSHIyN2lPVm1BNENOQU5UYVJMc2QvTnJqZ01U?=
 =?utf-8?B?Uk0yQnZ2OXlBSlZHWTVudTVZbXVEWGJDcHpRdjFYR1RXbGMzTzFGOHZ0WHBO?=
 =?utf-8?B?VFpOMEo4bXVZMmYyZ0VVZnU4NFY1ZmcvVUsvbE1PK1R4ZHliSDhnYjE5bkts?=
 =?utf-8?B?Y01rcVRZQTVFWEdKREs5NXdYMTQ1U1lWd1pHZjQ1bkJpblNiNU15b0xqN1Bm?=
 =?utf-8?B?TlRWNjhjRkNoWit0SEdCUWRTUTVyYlAzWXlVUWRsUEFKRWgyQ055WWlObDUv?=
 =?utf-8?B?R0llNWhtY3RBV3RjS2hvVnJuU0VySk5kM3JVRlJ3T0o4OWdUSG1uTTZJdlo0?=
 =?utf-8?B?UFhmcmFlTHJiRjBTTnJYaHQ1c0NlQ1VLZWRqalhjNnRaMTUwei9kUWk2UE1I?=
 =?utf-8?B?Wm1kcWxuODBzS1ZnVy9RUGhlUDY1NThsM25FRm1HcVhUa2RTU1dtOFBMQmEx?=
 =?utf-8?B?c2I3ekdCUlIzQU9jTjhPUFg2bFlzaU9JVFp2eG84bGRsS24yRitjdG02eGZn?=
 =?utf-8?B?bHRIWlJ3MFR2Snk2dUt1S0h0ZUVxOEhmY1hTTlVYanVxQU84UGVzcm5idEZI?=
 =?utf-8?B?UFA0UjFCWFMyYWtLcGlpaDJ2SGpaM09FNDRkL3FaWUIvbVVyTEl3K3QrejVM?=
 =?utf-8?B?UG1WOVhoQUZRQ2JxRk16WmFMVDRvY1NDam9ISFc1c243TFprRHdLVVl4KzR4?=
 =?utf-8?B?RXlKbzhSR1B3dnZhY3hCYWladWF5aEZzeVd0Ni8wdnlpd2ljdUNxWW92eG9n?=
 =?utf-8?B?djlFMS9BVjhNMkUrNTByeXN1UC9MOGh6WkZjajg4NnZSdWF5OWJqdmdwbmsx?=
 =?utf-8?B?a2U4aFFZR0JzYUs1dWxvMFcySS9MelVQTUN6TTdGWnFCUGxUcWpzSldzSTVh?=
 =?utf-8?B?REhrRC9NbE1vNzU3b25pa2wyeDc5dUZ5VUFZVFR3NnRmNXViekg1VVVIVzhq?=
 =?utf-8?B?cXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c71a7cd3-f7e2-487b-8df1-08ddd8aee0b5
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 08:12:56.5439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hkLL4p32XPKEE9//K3T7iMVRkw6Lmu2YkUFNbTJxAEP0JpOU5IH9lTB6YAwDpna5Axq+CgTtKPpaNPL4e2wBjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8429
X-OriginatorOrg: intel.com


On 8/11/2025 3:29 PM, Xiaoyao Li wrote:
> On 8/11/2025 2:30 PM, Chenyi Qiang wrote:
>> Current debug controls test can pass but will trigger some error
>> messages because it tries to access LBR (bit 0) and BTF (bit 1) in
>> IA32_DEBUGCTLMSR:
>>
>>    kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x407de7 Unhandled WRMSR(0x1d9) = 0x1
>>    kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x0 Unhandled WRMSR(0x1d9) = 0x2
>>    kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x40936f Unhandled WRMSR(0x1d9) = 0x3
>>    kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x40cf09 Unhandled WRMSR(0x1d9) = 0x1
>>    kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x40940d Unhandled WRMSR(0x1d9) = 0x3
>>
>> The IA32_DEBUGCTLMSR value isn't used as a criterion for determining
>> whether the test is passed. It only provides some hints on the expected
>> values with the control of {ENT_LOAD, EXIT_SAVE}_DBGCTLS. The reality is
>> different because KVM only allows the guest to access the valid bits
>> depending on the supported features. Luckily, KVM will exempt BTF and
>> LBR from validity check which makes the test survive.
>>
>> Considering that IA32_DEBUGCTLMSR access is not practically effective
>> and will bring error messages, eliminate the related code and rename
>> the test to specifically address the DR7 check.
> 
> I would expect you explained it more clear, e.g.,
> 
> "debug controls" test was added by commit[0] to verify that "VM-Entry load debug controls" and "VM-Exit save debug controls" are correctly emulated by KVM for nested VMX. But due to the limitation that KVM didn't support MSR_IA32_DEBUGCTL for guest at that time, the test commented out all the value comparison of MSR_IA32_DEBUGCTL and leave it to future when KVM supports the MSR.
> 
> The test doesn't check the functionality of save/restore guest MSR_IA32_DEBUGCTL on vm-exit/-entry, but it keeps the write of MSR_IA32_DEBUGCTL. It leads to
> 
>   kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x407de7 Unhandled WRMSR(0x1d9) = 0x1
>   kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x0 Unhandled WRMSR(0x1d9) = 0x2
>   kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x40936f Unhandled WRMSR(0x1d9) = 0x3
>   kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x40cf09 Unhandled WRMSR(0x1d9) = 0x1
>   kvm_intel: kvm [18663]: vcpu0, guest rIP: 0x40940d Unhandled WRMSR(0x1d9) = 0x3
> 
> to the kernel log. Though it doesn't break the test, the log confuses people to think something wrong happened in the testcase.
> 
> Current KVM does support some bits of MSR_IA32_DEBUGCTL but they depend on the vcpu model exposed. To simplify the case and eliminate the confusing "Unhandled WRMSR(0x1d9)" log, remove the MSR_IA32_DEBUGCTL logic in the test and make it concentrate only on DR7. Following patch will bring back MSR_IA32_DEBUGCTL separately.
> 
> [0] dc5c01f17b1a ("VMX: Test behavior on set and cleared save/load debug controls")

It looks much clearer. Thanks for the rewrite!


