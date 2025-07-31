Return-Path: <kvm+bounces-53787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60238B16E09
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 11:00:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 564D93B69CC
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 08:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB52A2BD011;
	Thu, 31 Jul 2025 08:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QoR9rO5K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C557218E99
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 08:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753952392; cv=fail; b=T6kcfOHakiTjc20k+2UXt3NM64o2WHplXiyFwXL1C5ryUF6H1dOtT7KXZkorme19URvxH23YwJAX3jcn6hAG2nAsEV1IfRHV69CTsSCKFAulMsOdCmYHnFipwlWFgvdIbs06dQKQDcaPfEALMKvM5vVMEG5p74450pY0zGgeOmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753952392; c=relaxed/simple;
	bh=i0fJSdcaCoHxdYDB3NUZrI3o1LVNCaXRv9F2NTTeQmg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O3DPHQQsdJBvO9mQ7tzvLzxeiNwsFTtFus+I3DgCjdJOgim6kEQti2fW9R6yYVZZJD9oHeYXuShpY0MnHA1PFU+ki+lWJDCysF6pKGIyJ0rGjYYd7qBsoTRh1mfxdib26DWnAULFqOUV6gPQmEkY/AST/DvFdUjDkjKzg5CzyuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QoR9rO5K; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753952390; x=1785488390;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i0fJSdcaCoHxdYDB3NUZrI3o1LVNCaXRv9F2NTTeQmg=;
  b=QoR9rO5K3T3bOCBYiyF20jxk4Zcm9SWqEyv6iVVANkCB2eFiUx5pRjEQ
   9JVX9G6qBWknAQ44Dd199mv3TDSl7IeVyx5Ci8VgnJnJe/AUFb42PQHyl
   EQSPVsJG6lmbCufZjZOS7+itaINN7Q8tFKmoswc/YgDLVrRXRnxWhIVjb
   A2ubOpYUX9K1+CP5rIRuCtoj4/eDu3xufu4V1/K7zDDxtMz2Cd4Ak3b/n
   lgGoKVu4iEHhrajzvlwkaBsuS8KDZLj0Dv4aQs/BufyZ2YN8BsxIycaLH
   kbIfPGQhJt4QWMNaV5FkSGHFFn9HqQTPP7Qz8HOtzlS5aAjI4NtR/C1Ah
   w==;
X-CSE-ConnectionGUID: j/5LjvF7SsqR4lRFmTD1hA==
X-CSE-MsgGUID: NEsxTeFkQc6bBGkU9U2jIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="55966450"
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="55966450"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 01:59:49 -0700
X-CSE-ConnectionGUID: 034zio1cTPe8DtXD0xrx3Q==
X-CSE-MsgGUID: rJruvB8PRHm/TFAw8tNeFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="162798661"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 01:59:49 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 31 Jul 2025 01:59:48 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 31 Jul 2025 01:59:48 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.55)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 31 Jul 2025 01:59:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r34o8hAh8TL2S2fxlLCMDJVXdpkL7PU57F8uSylDvKC9BANtXTjyFlWbJmqy+8Yg0xFlvsljD46Y4b16WSZdeOYO8BD1zvhytJxB+HeS/sWfXX+oQq0KTbHRzqcMajHo7dhJWU+EZ+NPm0aYcULZ4i0/gNIvbg1X8kCvxtCabZu84CvrPIkyZ7lJEMkWRL29HApfs6grhKd/5MpbfqMbJCrBpmN/T0pnb7RSS3KlyXn8kn3kBpH6bcCgNolqkumGHhkw06hE8O2JDRhMns81QT7thfxHdjKSX5llY8m+yzNoFE8B9isYJ3ymYrKO06Wa6L+dCI+J/Wgl5fGMI0Qe2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n9fRhsm1lsaKLZt65MqaNg5CtxpYcF5gupHukTqEtCc=;
 b=nSNbGrjxkE8yVRIBTVZsjcrSdwhtTImx1TR1dBEwNyGcqsgrNGVONB89L7BkW0kNfNRhBqyo/cbe6tegh9lYyAJxXDgaF56kP4CNPz0eost92G5B4Bx1Ugur5y5o/do8bWUWVuSJgLmUhHEGbda9gRGdQyS+zhPSSArgtB7viH/3z8QVBfRpkZOsh9oOyNR6t/NE8dWPrwNTHnelkIw4kiBtyWynRw5hEEYh+V8JZXnHA4moVGIH8LWVqs7IbHlz7N5T5tKGPLfrVGWCHhTH4dVmjJIoPBq68a5RIZw/MaN2gMThGDbIqOAvbz9W89s0gD2PrLpzksQkyPrf6p9iCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SJ2PR11MB8538.namprd11.prod.outlook.com (2603:10b6:a03:578::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.13; Thu, 31 Jul
 2025 08:59:46 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8989.011; Thu, 31 Jul 2025
 08:59:46 +0000
Message-ID: <7b03e7b9-6afa-4a91-8790-b6c61f54a0e2@intel.com>
Date: Thu, 31 Jul 2025 16:59:39 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug 218792] New: Guest call trace with mwait enabled
To: Sean Christopherson <seanjc@google.com>, <bugzilla-daemon@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>
CC: <kvm@vger.kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>
References: <bug-218792-28872@https.bugzilla.kernel.org/>
 <ZjEfVNwRnE1GUd1T@google.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <ZjEfVNwRnE1GUd1T@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0046.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::15)
 To DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SJ2PR11MB8538:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f794601-845e-43cc-7442-08ddd01098d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cGJQUUNPQVo4dHhiSDRqUktKQ25ZYW44VkUzc0pHbnlleXA2eDhPbW43cHA2?=
 =?utf-8?B?US9aU3Fwek5KR3BLSXVqOVJkWkNsZ3hJenJ6VEJTNis2dW5VY2E2Wk9MTGM1?=
 =?utf-8?B?R2NUSlFrbUxUQjhpdjdCaE5VS1NIZ1hnQjFmRDBSODBhQVRXYkFuRU1Bb0RX?=
 =?utf-8?B?SlNGRlNxRUQ4NndWcE4yNk91ZTVoQmNpT1NhMXdQeVhOcUNlTG52TTA3YjFm?=
 =?utf-8?B?ODlDT1FNYndjQ2o5cXFrcnp3bkFzTTFDeWNURm4xM045SnE5S094N256a2ho?=
 =?utf-8?B?VXdSeTkrVDBYVlc0bWZHejZjSHArQmRZcUd3V3dFY0tRbVYxdlFucDVKSndB?=
 =?utf-8?B?RGhBdGpndE1ZQ3o3UUIrbGJyU09OMFZPbERlbEM4bjFnRW9PeXQ5QSt2UmF6?=
 =?utf-8?B?NHVwd1BKRjhFVFptQVI0U2d3aGR4UkFNTm5QQis0bmlZWVpDaUF5dHBscEFG?=
 =?utf-8?B?ck5vZXJmTmkxbU1SNDdlbGhCV2RNMVRHaVdDRVdIODZwdmJFakFOSXAyeGdi?=
 =?utf-8?B?OTRhMFBCSnMyem5iV3RsVUo0dWdmTnllbkY0K3dzTnNmbmZWK05OWmdUMTNJ?=
 =?utf-8?B?T2tDUkNPcXdBMjc0enA0cGFhMVV2MHcwNk95aUVPSVpwMEcyc1BlM0FrWkxI?=
 =?utf-8?B?TGhHY2hCZk9WWHczbWtuZVhPZFpqY0pSRy8zQmpTdWtaeVJObHNkRC93ZW1M?=
 =?utf-8?B?Y3BReTZPaEhKYWRUNlRXd2hRcWdFdENuc3JCRlh3QlFwTEJ4YkRsbmgvdlMy?=
 =?utf-8?B?K3BPUlpwczlCbWlCMGJQR3ZTTWdLM3VPS3dVRWxqaGdXaGpqZ2NVVld3U1o3?=
 =?utf-8?B?eDlQQmpuZGhURURwQkJTMk4xb1JIQzFScGpxdGNHNTVWejNQOW9Sa09JM3BM?=
 =?utf-8?B?L241d1ZmaXNacUk0WWkzakpydkIwa0s4ZHIraFZ1RTJwRjRRNzNEbFU4TFRt?=
 =?utf-8?B?VjhDMUc1MlZpYlM0ZUxFRm1iTWRJcWE1QUFvL0FYNzNJaHYwMHI3QkNHVkFO?=
 =?utf-8?B?dEN2RDUwVkRuWHd6dGo0TmpSbjMvc09BRExIOVFSVGowdTUrV3B0eUFxTVlB?=
 =?utf-8?B?d0FXSkNDT0JERFhac3hKdUpMTHNQSTZwbzBjY3MrLzBrSjcrYnF3d3F4OXpG?=
 =?utf-8?B?dGtMM2RJOFpwbnZnNk5MY21QcnlyeFdjdndXY2l3TWxaSFpHRlJBRm9QcGt4?=
 =?utf-8?B?RllxaHVqYUxabWQ1WjlPWVBoai9wWHdraWY5eXFGSTBhd0ZFQjFTWnhvTFQ1?=
 =?utf-8?B?bzRQY1QrK1M0N2xoMmVPcVExbW9Pbis0bTY3OFJuWW91dVd3U3FDclREZWc0?=
 =?utf-8?B?N21QQVlzUnc0NjZMcFNpM2M5U3F4TnNIUW50VFAwMzc5L1VsZVEvbkZMUFFX?=
 =?utf-8?B?RXc5NUo1Q0RjOFBoMkV3NXA5MWtoN25ldlNVdmJyb1BkZjdheXc2R21VRFJP?=
 =?utf-8?B?K3B3dk9NamZJdG1SNlpCdzZSNEx1cFB3ZkVKT1h6L2gzdHJLdlJzcFl6Q3VS?=
 =?utf-8?B?Y1I2RS9KRWdHUnE0OStBVEViTjdIY2tkRzJ0UVhrQUdFRmdEbjJ3dmU2VS9W?=
 =?utf-8?B?VytZTHpsWFFqeFd3aHloVkZtQW8zVzBnQXdHOXA0NHg2UHJRQW9rWVVKUzZs?=
 =?utf-8?B?K3hSUHN0QUFQbU5EZHpOZkdHUXh4M0sxMS82azZodmdYOTB2cWEzK0F6Y1hF?=
 =?utf-8?B?bDIvNEQ1WEFHdzJNL3I3RWJlczI2OVVSa1FjNlF3dGhiczgyQnRvd1A5N2pr?=
 =?utf-8?B?aTFpb1VXNUlmL1ZDRXhlNFZpaGVXUXp0aTBYOUw2V0N6Y1hJRDVPby83QlhM?=
 =?utf-8?B?REFIaDNZOUhCTnordjE1OW1FNEFQM1FNZ09wZzBjQ1hjdTNEeC9yUkc4OUha?=
 =?utf-8?B?SVpXdU9GeUJVdWh5Y0luWVdZbjZZT1JNa2ttYkhmMUxzNTgyMldQYmovN2pC?=
 =?utf-8?Q?hBrT9oQ0GSg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnB4UUhQSjgxRkZNRG9pQnIzQWhFL0ZQMjVEdTJDaVdCZW9KUUw0TTNkTTYz?=
 =?utf-8?B?NEVrVTgwalBRMDNjSjhVVW1ZVFNaVlFUTmF6RllqWk5DRHVyNDNyZW9tZlNl?=
 =?utf-8?B?ZTg0MXFJY2V6Z2t6ZlgrWkdzWEc1TWNHbGRWejdtdlA3U0pxK2ZSak16WmNI?=
 =?utf-8?B?NFY0TlF1NzFuVXVNbC9HUTBCNVNVUENSZ3ZvZEVTTFEwbnZncTYrS1ZPaXZx?=
 =?utf-8?B?N1c1ZnAzRFgxbkZVcTVYcG9TU0pRcDBJdkpTaEhQbmFwVWlLeFdISHNab2dn?=
 =?utf-8?B?YjNjOGRNa2t5YjBsbVh1dUsyZGxJUzlkMWwzVlVQdXo5ZW1mR0ZxSUR5QUR5?=
 =?utf-8?B?UnJ2SGxaZm9RdzYvRXJ6WHp2U0VtQW1rU0MwMExlc0JlRU1WQWNOd0FHSUFm?=
 =?utf-8?B?R0psNDBYSDdTQjR2UmRIeFQrb1EyUkxOT1RZYmFXUlBCMGpzUGlsSllROVFO?=
 =?utf-8?B?Z2ZhcEtXMSs3OGdTUExYbzIyUFczQ2RFZCs0NU9vSldPTEl2NVVvUEMzaytx?=
 =?utf-8?B?amNkU1hLNkY3SXEwRTgyZW1iZmFWay9naGk3WGJSdmpJUi9NTUd5UXdYMEpW?=
 =?utf-8?B?Yzc5RSsrWEl2VExkcDlvRE84TG1ueGRjbkg5YytTclMzRm9mWThwMFdCc3g1?=
 =?utf-8?B?Vmp4M1BJTFRXNlo0UVhKNkUwWnZFNjNUandQUFh3ZXBVQ2xZd0pDUWxqSlUy?=
 =?utf-8?B?QmNHWFpLRHlId3dpbHFDaHpDY3VWTUJCTERDZGs0TmdzUk1pRlVDVFBlcVd2?=
 =?utf-8?B?SHFaZUwrSy9reUJDVEE5bjkrS1N0dmNPVVdnYUVPblZoRThIQVgyTERkME1Z?=
 =?utf-8?B?S2ZDa3h3YktwK2czaU9xYW4wbnJzMTFndWVHblVHRkxYalJPTERRVEJnVWE0?=
 =?utf-8?B?Q3RzTXdabEg4WmpzM0pRWnNvcEt5bURucFhTS3FMem95K2NDMmJjRzliWGtj?=
 =?utf-8?B?OTdPMm56U3lKMFVFUVhJUkF6enVCUUY5SVVYY2JuWWpMOXVZUFUzQTkzaCsr?=
 =?utf-8?B?Qmh5ZUNzSjJ0anFsd0Jxckk4bE1YZmhrbE1NUkxHeHN0eVlYZWY1QXJaNXo4?=
 =?utf-8?B?dnlnMjh3ZWdDV3NtQnRkbkZNak5xZ05zdWhOcG5ma1VFdE9DS2pvd0V3V2di?=
 =?utf-8?B?UTNvb0Z4Sk1JRVc1WEtrN3Z4YWpkd3JMOWJpV2hPQWNYalQwckJqazV4dTNw?=
 =?utf-8?B?Nno0c1BWQkVyMnJWY1cyQU40QVV5aHBzRWdNU2JtQTlwbzd3elg1UncwRExQ?=
 =?utf-8?B?MEIzRE9scm8rMlVDNElOTWY1dWRoZ1Q3cythK2h6Z21vRkEzZE9lZ2s2OEMr?=
 =?utf-8?B?dnJScWtYSnhyY0hMeFRFOVBJWTR6TnVTeEdUaCs2cDF3Z2Y2MGdmZHNHMTc3?=
 =?utf-8?B?TXNXWWFqZWs0dmNzRWdzN3dpOXhpTFk4Zm5YNmtONDRhcE5OKzZoM1BWdm9N?=
 =?utf-8?B?bnM1Wk9KTGJvNnY3aU9wc0ZvUmtCSEJIQThSWWluRHBBcUtuYWxiOTViTDVl?=
 =?utf-8?B?WVh5T2tXUUpQa0E0YndySU1ZUkpIN2FwVk8xMXMwKyt5OFhwN29VcFhXUkZR?=
 =?utf-8?B?VnpCQTdtdC9EN3M1TWFwVDRXTCtHZ1B5MzdRVExpL3pMN3NXaUhUcXpkRXlG?=
 =?utf-8?B?Sm8rUTNXSjJNY3F1dld5Umh3VHVmZDZ5eTlYOW5QV2I3a0R5M0FVUUt2ZXVy?=
 =?utf-8?B?OG1va1pyT2pkaHNzTzZwVVkyc05FZnNKWlFqU1IzeG1WWTdsSEZvMDN2REdh?=
 =?utf-8?B?VVdnT2EyVjJIRitJZzRnMjVMeGJzWDd0dld5SU9zQWlmQmJlc2h2a284eFdr?=
 =?utf-8?B?UzBobmVKSkF2NkdzNStmK1FBNTQrblpmNXUzYytBUW1lQ0JDMDJWNXo5L2RG?=
 =?utf-8?B?NnFacEg3ZXlGR1lSeEJiMUd0MmJmRWJ4Z3NKblh3ckU4ODZFWjhNcHFzVUlW?=
 =?utf-8?B?T0krZWtaK1hzOFpiTk9VS3dqU1lUSmEvK2hKQXpuOGoxeVJpVGJ6R2VhS1Rj?=
 =?utf-8?B?VnpsRUova0pnZGZUTlNQbFVzb1NySTFqQjBodmNadk5UQ1RwTkVEU05XWmtz?=
 =?utf-8?B?bjNBUXJxcWQrQTljS0xSK0FwSHU5RVZyU3A4Z3BrVWxyMlduWlNtcWVoYUUz?=
 =?utf-8?B?eFI4Qm16L1ZMa0I1U3R0SGYza1plM2wxRzRMcjBWdWViOHlRZlc1djduL1BB?=
 =?utf-8?B?QWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f794601-845e-43cc-7442-08ddd01098d4
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 08:59:46.0162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oFvEWn6PyfIO6fW6skS+DDcvr6JciNErTE7Cy/yoL4tPjhFXbOMZdxGHwEc1ml+8p51z/vk8jxhD2FztWMxx+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8538
X-OriginatorOrg: intel.com



On 5/1/2024 12:41 AM, Sean Christopherson wrote:
> On Tue, Apr 30, 2024, bugzilla-daemon@kernel.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=218792
>>
>>             Bug ID: 218792
>>            Summary: Guest call trace with mwait enabled
>>            Product: Virtualization
>>            Version: unspecified
>>           Hardware: Intel
>>                 OS: Linux
>>             Status: NEW
>>           Severity: normal
>>           Priority: P3
>>          Component: kvm
>>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>>           Reporter: farrah.chen@intel.com
>>         Regression: No
>>
>> Environment:
>> host/guest kernel:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>> e67572cd220(v6.9-rc6)
>> QEMU: https://gitlab.com/qemu-project/qemu.git master 5c6528dce86d
>> Host/Guest OS: Centos stream9/Ubuntu24.04
>>
>> Bug detail description: 
>> Boot Guest with mwait enabled(-overcommit cpu-pm=on), guest call trace
>> "unchecked MSR access error"
>>
>> Reproduce steps:
>> img=centos9.qcow2
>> qemu-system-x86_64 \
>>     -name legacy,debug-threads=on \
>>     -overcommit cpu-pm=on \
>>     -accel kvm -smp 8 -m 8G -cpu host \
>>     -drive file=${img},if=none,id=virtio-disk0 \
>>     -device virtio-blk-pci,drive=virtio-disk0 \
>>     -device virtio-net-pci,netdev=nic0 -netdev
>> user,id=nic0,hostfwd=tcp::10023-:22 \
>>     -vnc :1 -serial stdio
>>
>> Guest boot with call trace:
>> [ 0.475344] unchecked MSR access error: RDMSR from 0xe2 at rIP:
> 
> MSR 0xE2 is MSR_PKG_CST_CONFIG_CONTROL, which hpet_is_pc10_damaged() assumes
> exists if PC10 substates are supported. KVM doesn't emulate/support
> MSR_PKG_CST_CONFIG_CONTROL, i.e. injects a #GP on the guest RDMSR, hence the
> splat.  This isn't a KVM bug as KVM explicitly advertises all zeros for the
> MWAIT CPUID leaf, i.e. QEMU is effectively telling the guest that PC10 substates
> are support without KVM's explicit blessing.
> 
> That said, this is arguably a kernel bug (guest side), as I don't see anything
> in the SDM that _requires_ MSR_PKG_CST_CONFIG_CONTROL to exist if PC10 substates
> are supported.
> 
> The issue is likely benign, other that than obvious WARN.  The kernel gracefully
> handles the #GP and zeros the result, i.e. will always think PC10 is _disabled_,
> which may or may not be correct, but is functionally ok if the HPET is being
> emulated by the host, which it probably is.
> 
> 	rdmsrl(MSR_PKG_CST_CONFIG_CONTROL, pcfg);
> 	if ((pcfg & 0xF) < 8)
> 		return false;
> 
> The most straightforward fix, and probably the most correct all around, would be
> to use rdmsrl_safe() to suppress the WARN, i.e. have the kernel not yell if
> MSR_PKG_CST_CONFIG_CONTROL doesn't exist.  Unless HPET is also being passed
> through, that'll do the right thing when Linux is a guest.  And if a setup also
> passes through HPET, then the VMM can also trap-and-emulate MSR_PKG_CST_CONFIG_CONTROL
> as appropriate (doing so in QEMU without KVM support might be impossible, though
> again it's unnecessary if QEMU is emulating the HPET).
> 
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index c96ae8fee95e..2afafff18f92 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -980,7 +980,9 @@ static bool __init hpet_is_pc10_damaged(void)
>                 return false;
>  
>         /* Check whether PC10 is enabled in PKG C-state limit */
> -       rdmsrl(MSR_PKG_CST_CONFIG_CONTROL, pcfg);
> +       if (rdmsrl_safe(MSR_PKG_CST_CONFIG_CONTROL, pcfg))
> +               return false;
> +
>         if ((pcfg & 0xF) < 8)
>                 return false;

There are three places which could access MSR_PKG_CST_CONFIG_CONTROL.
1. hpet_is_pc10_damaged() in hpet.c
2. *_idle_state_table_update() in intel_idle.c (This BUG comes from this path in VMs)
3. auto_demotion_disable() in intel_idle.c

This MSR seems not architectural but CPU model specific.

Besides the case 1 as mentioned, the intel_idle driver also uses it to query the
lowest processor-specific C-state for the package (case 2) and to disable auto demotion
(case 3) based on the specific model.

I assume both case 2 and 3 are aimed to improve energy-efficiency. For example,
spr_idle_state_table_update() adjusts the exit_latency/target_residency to hardcoded ones based on
the package C-state limit. It seems unreasonable in VMs as the hardcoded values are measured in host
and the guest CPU model may not match the host one if we only pass-thru this MSR. Similarly,
for case 3, there is no guarantee that disabling auto demotion can improve energy efficiency in a
emulated CPU model.

Since there is no such fine-grained power management virtualization support yet. Can we change
all the rdmsr/wrmsr(MSR_PKG_CST_CONFIG_CONTROL) to the *_safe() variant to skip the related operation
in VMs?

> 
>> 0xffffffffb5a966b8 (native_read_msr+0x8/0x40)
>> [ 0.476465] Call Trace:
>> [ 0.476763] <TASK>
>> [ 0.477027] ? ex_handler_msr+0x128/0x140
>> [ 0.477460] ? fixup_exception+0x166/0x3c0
>> [ 0.477934] ? exc_general_protection+0xdc/0x3c0
>> [ 0.478481] ? asm_exc_general_protection+0x26/0x30
>> [ 0.479052] ? __pfx_intel_idle_init+0x10/0x10
>> [ 0.479587] ? native_read_msr+0x8/0x40
>> [ 0.480057] intel_idle_init_cstates_icpu.constprop.0+0x5e/0x560
>> [ 0.480747] ? __pfx_intel_idle_init+0x10/0x10
>> [ 0.481275] intel_idle_init+0x161/0x360
>> [ 0.481742] do_one_initcall+0x45/0x220
>> [ 0.482209] do_initcalls+0xac/0x130
>> [ 0.482643] kernel_init_freeable+0x134/0x1e0
>> [ 0.483159] ? __pfx_kernel_init+0x10/0x10
>> [ 0.483648] kernel_init+0x1a/0x1c0
>> [ 0.484087] ret_from_fork+0x31/0x50
>> [ 0.484541] ? __pfx_kernel_init+0x10/0x10
>> [ 0.485030] ret_from_fork_asm+0x1a/0x30
>> [ 0.485462] </TASK>
>>
>> -- 
>> You may reply to this email to add a comment.
>>
>> You are receiving this mail because:
>> You are watching the assignee of the bug.
> 


