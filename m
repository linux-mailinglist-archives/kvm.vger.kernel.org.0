Return-Path: <kvm+bounces-49817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E693ADE3C2
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 08:34:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFD493AC249
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5F1A207A32;
	Wed, 18 Jun 2025 06:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kl8ApStk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4404645C14;
	Wed, 18 Jun 2025 06:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750228480; cv=fail; b=Jjndtm+OQQKo1wCrprr2NM4mnQ0OMZi4ARuJiaLzAEa6xO5gJjapz+ZTyE7faTYlNIij+j0VxbS6eNmIofKjWu9EjrcA/kXEnOQqFXXAlGHnsH3l1DhjBt+zqPUNCGmaKcjkwmUVAnJ0o1URAYjTr+LGhlbtJveTynpyMBwE5nY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750228480; c=relaxed/simple;
	bh=u5nQYxTdbDOmEObycPXjp5DWQVAZsROUdwfvC1h6deo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=U3/Yb+Eaf/Ue7xVQ9ae9sQIV6WjPqD45NhgtwvJ3hY0oGm2mAfeWPIzOA/6WegMIiJ/aV59yl7rFr18e4oEt8PtSGFlC4iD1zJZG+P6EbX+aaEZbgJxKyESxbnM3KjckIJ9oiNHJMiHbTrc7ad8Au3NAmIrj4U5B+e4W4GYgknY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kl8ApStk; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750228479; x=1781764479;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=u5nQYxTdbDOmEObycPXjp5DWQVAZsROUdwfvC1h6deo=;
  b=Kl8ApStkLCUO0EH44YXcMKfAXQhoIKSs4sElEPy8FZ7gbBpMW3x2rBhH
   nXh6oVmpo8X+n8klfi6y8TaL36O7FTLtOvaWmTQcBs4FQrxe9b6sfh6xx
   KAFkDDPC9zQIUWTNbWeGKc0mwU6Cs+iiwaKnlQjjt81KyKGwrBvo71Bzc
   Pwwvmklo8DKQH6ZBX9OR+5xkZdELgK3xLUseBzNxuVgfjd8ip2JDjFrS0
   cibUkEId/IPeYqr7bA0Hd3UcW1uwNhHyz/TKCGcPjB6CUsXEj58uIneHf
   ELra0LNOYwZX09yMYyUOwzv/n3a1WS8uzszLNLPMY0T8RN7KOnbDuK9I2
   w==;
X-CSE-ConnectionGUID: K0FTICrSTXqRq4aCnwh6PA==
X-CSE-MsgGUID: OR+4oj9/Qc6p9qEUVMlYoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="51656320"
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="51656320"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 23:34:38 -0700
X-CSE-ConnectionGUID: EwuCx+fxQx2EPhgi1r7ePA==
X-CSE-MsgGUID: Tl7WKZglQV2jwOtN07edZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="149258011"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 23:34:37 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 23:34:35 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 17 Jun 2025 23:34:35 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.61)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 23:34:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bOUq0NASNo/HuVdVQ4W7QF4AkDES0WsZGmrG/pXNTY2Z5RYMqddnjbPxM4zTwP93RgISPne4OCw/N21t9fEd2tr2D9IWw6pXyeF1numBkmoA+9QX5rApbLAM2c+pmwlIhHEjD3vN2ptr5zQ3GncXk+g19ChuxfK1H6A/35Wv7GAkiGl/9bWJp1rnq9HHjmug0qjRiWy6PQVPEdsRzMxBkryrdiAkiQ/+BncgLciuPhFdbH5mK06f9Q8LpDvbkSSGm8cpmXN7x6bW9nRfVXiymtkoRhBtGStHbW6seIUC1pcbnlx4PXqaQb9iZceSaSlUpTjiRstpH4dZ3wbNg0/33Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C8URqHNd0ewPiIft/8GJThFjxIPgB/v4fmL6TSCSTmM=;
 b=bQz7LLePYd9dxJfIaeBOjxhlZauBa/ZvgXelG59y5aOmitMbtytK3x+euiBjUJLZkXBQTCo6kVYe2VRip26NvK5qlC7CahcAQkJxbvDeoVeNDhGCfDb10tyA40GjmMwZKsZsHhk3ss7h5tmsZcJkzI/sOVGb0XUO/8Rl6KSK1y5bwGCU8AKehHozbW9vl1nmeT3r+kZffTBOQMn26RxpaSuWP3KN60tb4E7fozDv6nlx+7bgzm93cvsQC/8DtFXJ+YYrCfqiCf5LDj5TSLUCUXP+AbHPqN8Bq8qrpDVsiAapgWwxHfBeaLppgHlo/6OaZ9EiWEFQSrkkeHppNIfRuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB6863.namprd11.prod.outlook.com (2603:10b6:303:222::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 06:34:32 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 06:34:32 +0000
Date: Wed, 18 Jun 2025 14:32:02 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
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
Message-ID: <aFJdYqN3QHQzMrVM@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
 <CAGtprH_SKJ4hbQ4aSxxybcsD=eSQraP7a4AkQ3SKuMm2=Oyp+A@mail.gmail.com>
 <aFEQy4g4Y2Rod5GV@yzhao56-desk.sh.intel.com>
 <CAGtprH_ypohFy9TOJ8Emm_roT4XbQUtLKZNFcM6Fr+fhTFkE0Q@mail.gmail.com>
 <8f686932b23ccdf34888db3dc5a8874666f1f89f.camel@intel.com>
 <aFIMbt7ZwrJmPs4y@yzhao56-desk.sh.intel.com>
 <CAGtprH9Wj7YW-_sfGQfwKHRXL-7fFStXiHn2O32ptXAFbFB8Tw@mail.gmail.com>
 <aFJY/b0QijjzC10a@yzhao56-desk.sh.intel.com>
 <CAGtprH9WLRNcXWr1tK6MmatoSun9fdSg5QUj1q=gETPmRX_rsQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9WLRNcXWr1tK6MmatoSun9fdSg5QUj1q=gETPmRX_rsQ@mail.gmail.com>
X-ClientProxiedBy: SI2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:194::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB6863:EE_
X-MS-Office365-Filtering-Correlation-Id: a72358b0-8dc4-4523-b697-08ddae322f35
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T2U1dHY2SFR1OU9PbHdsY2srU2NEaTMzTmhPcGlvT0tvQyt4RkowOHJVcmZN?=
 =?utf-8?B?SFNyYnhQMUMvYUEzYzJzc3Vma0ljWGtGb0hoZDRIZDJpbjk3S20yeWtaMHE2?=
 =?utf-8?B?ZS9XRG9wWkJidlEzdStBTk40WjY5dEJIMXRrVU4rZ0ttbytMdnZyQTlFQWtm?=
 =?utf-8?B?WDZQZlRvZ1RyNjJOK29VaDZZZElab1IwZHc0bWZZRjlwMkY5NFRzZ1dzaGJq?=
 =?utf-8?B?L1R1dXNGRm1vVFlvVWtkUFFIc1V6NEsxcVY2Qk53NDNSVmRWSWlnRnhyNWZX?=
 =?utf-8?B?eGMybitxSlU5MUYyMSsvZXdHc09YcnBtaks2RFdqZmVkSGJ4UEljMzlQSmpa?=
 =?utf-8?B?QlRTWnQ1ZVVIOGJrcFBHVEw0aE90ZDhZbEJNbFlZNWpWalhXckhPMWk0cm0x?=
 =?utf-8?B?ZldUb016UlNwYm1Mb0NBYS9NVHpBZ3JDLzgwQ1l6NHNETEtHdWVMZlErc2hD?=
 =?utf-8?B?RzZBOGR4bWdFS29IR2JVR3ZNU21vS09GMllqRUlyWmN5a0tXREhnaXhydW1o?=
 =?utf-8?B?MjZvNndMWXdrSlJ5SGg3SU5VdkUxWkRzcVdwRjBab2tIbDJTWE5uV1Nma0RV?=
 =?utf-8?B?YkdaZjFmRXUwL3hoblNxQlhTVXZSYmphc0tNM3NTT1dWQk12UmlrbnFIQ2wy?=
 =?utf-8?B?TVRNQ3R2WmFaRy9lbGxzNXhRVG1VOU5oenJ2VFZkVXF5QU5HL0huL3RDN1ZD?=
 =?utf-8?B?cFhvM2hTOHljYkhUZjFPY1Qvb0o5eG9tOE9OZnJpaWxDRmVmMWI3aDJScVlZ?=
 =?utf-8?B?am5xNUhlbXhnN2VxUENrbll1emRrdXljcFJEUysxc3FiSXBncXQ1Q1Z5eDlw?=
 =?utf-8?B?ZFVjSjEyVldhTkRsaWdpZ1gvbVdzTk4yQ202YW1vZERjS1lJQmJMdjVXbUVY?=
 =?utf-8?B?MzZaLzEyWEZJZFl4TUFSRVpCMWhvSEtkV0oxT2JYODMzcjR5blVFQ0VHSHgr?=
 =?utf-8?B?ckw5cS9Db29aUE5YSlM5aHlpM2ZDVkljc0lwZE10Y01yRFMxTnVESUc2QjF5?=
 =?utf-8?B?MmdqcmRpeHhjMEQ4WERGYmlDTjJML3QwdVdycWtjV3lmWXoyakEzdlRtZ1ZS?=
 =?utf-8?B?VVdDVVhrMjZ6RzFzYnc4SmwxL2Rqb3RBZDB4clRlZXRGTGZNMTF2YTRESUFG?=
 =?utf-8?B?TmovUkpZMk95dUs4QjlEaTMvWGphRHpSeVRjWE9oaDVCRU9vcFJSc3RKZzNL?=
 =?utf-8?B?dy9qZUxGR0w3WWg2R1V1SGoyTDBBamFhaGFOZmVQdlNhRklmQjl0VGVqZ0Nw?=
 =?utf-8?B?cnF3cTlFQU1YQzNxc1ExejlzV2JaSzhSNjN5bzJuaVR4SmFCR0pCZlRCRE1S?=
 =?utf-8?B?YXcwVjllV1pOOTByVXI5RmVxdFhJVXBITzk1aVQxQU5iaGFqeFY0bXhSOGJC?=
 =?utf-8?B?TjNUN2dZT3d3MWFVdlgwUWNvRUdZd0lQelgyNkZ2MWpDMnRIRGtWS0pRUnhS?=
 =?utf-8?B?TEdlM0xtNldsaDR5VlRGdURSR3FlczN2by9LRlprY1d3cnVGQTZESTVoL2xy?=
 =?utf-8?B?T2tMa3V5RFBlcGhmMkJxSXZaeXlnVGlGcU0wVVYwM3ZRY1FNRnB0b3FaQjVG?=
 =?utf-8?B?QnJ1YXlOUFF4ZlhBb2JsMExWS243YjJzd0trR3AyWDdBQUQ5Q1MvQkFMSFA2?=
 =?utf-8?B?THJ6Z3g0VUtwTEE3cGVUSkhxZDFkMHczT2tudU1qNmVGRjJWMUJZdWJjblZJ?=
 =?utf-8?B?WDdpTlhxMGg0bzNPaTJQOVBKUUViY3hrL3VrUE95NlNoa2h4bUNtdnZTK0VJ?=
 =?utf-8?B?ZUVueDd1Q2hpcndvcEM4WTA4K2Y0WmtUYW9wd1d4N0ZQM3laUHlzV3I0LzBa?=
 =?utf-8?B?azYwWmJSTkN5SlFGcXloSEd4MmxqZWZIblEyTENRNnkyc3BaQ3hSZVhXdjhJ?=
 =?utf-8?Q?HBV2CVMXZ4ul1?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEhHaGhZak01UzV3bWdGWDdvWnQ2YXliK2tWVyt3M0xrQ3FxR2NseUx1MnlJ?=
 =?utf-8?B?N1NiUEZpVlUvaEVOWmx6eWliTHZjSnIwdkN0YS9ab0oxaE1pSTkyQzNlNnpp?=
 =?utf-8?B?Vzgwa1NQZFhjMjR4Z1dGb1ZyeGFCY011Y3JUdm14U2oyM0I3blpPYWE0N3o0?=
 =?utf-8?B?S1VNRmdXeTBaV3pBOWZ4L3hXMmZuTDhrUlNmYmlONTl3UlFjemhLN0l3cUFu?=
 =?utf-8?B?TE5HV2xjWkpJMnI3R2R2NG91SEFLNEJlVjJ1eDZTMUs0YkZtem1UMkkxNDBh?=
 =?utf-8?B?L1c1cytyYUQ5Y1VsWk5rUVFXRlBTQkJYZUVLdzd2QTNmdU5Rc3pINldjRHFw?=
 =?utf-8?B?cU5LY2k1eGVuaE5sZlp4Q3Zzd29pWmhPUXNqNDJaSVpzTCtYay9ZZjZNaUkx?=
 =?utf-8?B?Z1lwdnQ4NDRSbGhzcFkySFRYZmVYblhIVXVOTEY5VUcvOG1oM1BKZFg2WXRa?=
 =?utf-8?B?K0FDMXZKVnEzd0JmZm5DdnJGRUZhZTFJbHlpUGdqUlI0bnh1T1hkV3ZPd0pB?=
 =?utf-8?B?S29TdDhMdGQ1OGJGempqOUc5SEx4NmZJeW1JNUVrREowQVg4dHI2WUd6VG5j?=
 =?utf-8?B?cjNQcngrdUxVenRYQkRXZVlKM3VKVGExRUNsRTJFUmpveWtnUTIwM1ViOWNX?=
 =?utf-8?B?UldJWVlqcWtZRjhJa2xwUlI2NUhuM1JYYnZFSUFBd2dwRFJQeW1tRUZTeGdk?=
 =?utf-8?B?RWQ5N250ZHJNWTBRQU5jTDlFYTNmNlMrWmdWNDFaL2lsN2ZMZ25RaUdVL0NB?=
 =?utf-8?B?eHdBM0JMSWgyTkJoWGhNcVh5Q25mVHhLZk5LWEJ2OFBvYnhqaTd4d3QxVSt1?=
 =?utf-8?B?VWdSWHptSVJwNmlaTFNreU5VWTVNU3huNFJmL0N6SjRxWmpjSTl6bHhkelhB?=
 =?utf-8?B?VkppQUQ5aTVzRFVJVTczckNQemNoR2J6ZkZiVEsxV2RUQ3VOa29IcjRIZnBy?=
 =?utf-8?B?NFZQVU9OQVJuOUd3QkhIOUpRbWhhOWVFQXRaZzU3THZVelJEQUk2UTRpS1I1?=
 =?utf-8?B?aDBUT2d2TTVhK3FSaGxoNzZzZUxqM1hEbzRRZVVNOUN1UG1jamdXYlZkOE9H?=
 =?utf-8?B?Z0J3UVhEa1o4UjRBZlNVSXpJeTVoVi8rVk9TaHdES2lkTjZNeGYxRGp1WGxr?=
 =?utf-8?B?VVBJa3ZNZTFibEg1MDB5TVZTc0hibVF2czNGUmVHY2RNL0pGbGFWTWNOK1lC?=
 =?utf-8?B?V1N0cWVtZGZTdEVseG1tYUprUVhiY1UxRW1CZTZJQStsU1NITTlNZmRJSThz?=
 =?utf-8?B?dFRxTDEybzZWNEdoVHZLRVlxeXJNZHY1WTRNdFRBMHk0MEVmaE9PUkE4anVh?=
 =?utf-8?B?NkZVVWpXQ0U4VnUvNm1pbVhraHRtaEZBMTdFTFgvekJYVXhuZG9tYXVCUTZ0?=
 =?utf-8?B?MmdpNlU0djJrV25XNXhRWjlmY3FyUFJsMkhuRlhGU2hhUis2ZzEyaTN5TE4w?=
 =?utf-8?B?SWxMalRVNXZVVWRaMGVra01RVTByTXFqM2RYWGo0UDRTd2lBZkhGRzExUmpE?=
 =?utf-8?B?OGh5QnpWZjlMaGxZM3ZqODJlVmZGMFE1UkJLTGJCdVU0SzQ0d25lYms5NTJh?=
 =?utf-8?B?Q0RDaHFmZmdtMUp4aGhralVFZW5BeXVuYy8vakcwWU56UnpKWDQ4bUx4T1JF?=
 =?utf-8?B?aFRFemJRRERpZm02WUJwOWpjWTFOYm8xbU1henpNd3pncjlDTnc3dHR6RGpz?=
 =?utf-8?B?YkRwWkZwRzJlbktLSlM3dXdnMFpXT2hPQ3lIandLVmMreURGdTlOd3IxNDRl?=
 =?utf-8?B?SWh5a0NmbFYyWWRXZVN6SHUrMXpkaHBHdHJtYytXZ2RiUnYzNGxZclV1d2Zw?=
 =?utf-8?B?eU5TWGI3RTJLallwazBGZ1lTUHZaeVlNNW10NUg2bEJ0VFh6amkvVWhzZnlV?=
 =?utf-8?B?bzBrWE90QkMwOXp0VG5SakY3ZXZvT1ZuM2x4ejFyTlMvaWpOdjJVYWlnZHlw?=
 =?utf-8?B?ZGltdjh0cU9zTmxJUm55Ky9haVdTNU9VQXU0MitRaGlyakJnVFIvb0YybkZQ?=
 =?utf-8?B?TUFvUFFYTjN1aDJpZHBubzYrUXFwQjVUbnRFUnMwQVlWbER6anh1RlIyYzNH?=
 =?utf-8?B?bXhPSkRpQnRVaWRFT3ZzYnVmTFJPWjdqM0pLZmVBalVlL0Q3NVhaQTkxQ2Nx?=
 =?utf-8?Q?mcBxgQOLiNZVI5zfbaGJgGJEr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a72358b0-8dc4-4523-b697-08ddae322f35
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 06:34:32.1311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cE4PoEVA6uomMRQpoQQn5tqp6rfhVV9i6RxdmfvJYIH33v6jmrcH+KjjEbUlpPvWI4IMeEh+EZygh2aYXHrN0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6863
X-OriginatorOrg: intel.com

On Tue, Jun 17, 2025 at 11:21:41PM -0700, Vishal Annapurve wrote:
> On Tue, Jun 17, 2025 at 11:15 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Tue, Jun 17, 2025 at 09:33:02PM -0700, Vishal Annapurve wrote:
> > > On Tue, Jun 17, 2025 at 5:49 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >
> > > > On Wed, Jun 18, 2025 at 08:34:24AM +0800, Edgecombe, Rick P wrote:
> > > > > On Tue, 2025-06-17 at 01:09 -0700, Vishal Annapurve wrote:
> > > > > > Sorry I quoted Ackerley's response wrongly. Here is the correct reference [1].
> > > > >
> > > > > I'm confused...
> > > > >
> > > > > >
> > > > > > Speculative/transient refcounts came up a few times In the context of
> > > > > > guest_memfd discussions, some examples include: pagetable walkers,
> > > > > > page migration, speculative pagecache lookups, GUP-fast etc. David H
> > > > > > can provide more context here as needed.
> > > > > >
> > > > > > Effectively some core-mm features that are present today or might land
> > > > > > in the future can cause folio refcounts to be grabbed for short
> > > > > > durations without actual access to underlying physical memory. These
> > > > > > scenarios are unlikely to happen for private memory but can't be
> > > > > > discounted completely.
> > > > >
> > > > > This means the refcount could be increased for other reasons, and so guestmemfd
> > > > > shouldn't rely on refcounts for it's purposes? So, it is not a problem for other
> > > > > components handling the page elevate the refcount?
> > > > Besides that, in [3], when kvm_gmem_convert_should_proceed() determines whether
> > > > to convert to private, why is it allowed to just invoke
> > > > kvm_gmem_has_safe_refcount() without taking speculative/transient refcounts into
> > > > account? Isn't it more easier for shared pages to have speculative/transient
> > > > refcounts?
> > >
> > > These speculative refcounts are taken into account, in case of unsafe
> > > refcounts, conversion operation immediately exits to userspace with
> > > EAGAIN and userspace is supposed to retry conversion.
> > Hmm, so why can't private-to-shared conversion also exit to userspace with
> > EAGAIN?
> 
> How would userspace/guest_memfd differentiate between
> speculative/transient refcounts and extra refcounts due to TDX unmap
> failures?
Hmm, it also can't differentiate between speculative/transient refcounts and
extra refcounts on shared folios due to other reasons.

> 
> >
> > In the POC
> > https://lore.kernel.org/lkml/aE%2Fq9VKkmaCcuwpU@yzhao56-desk.sh.intel.com,
> > kvm_gmem_convert_should_proceed() just returns EFAULT (can be modified to
> > EAGAIN) to userspace instead.
> >
> > >
> > > Yes, it's more easier for shared pages to have speculative/transient refcounts.
> > >
> > > >
> > > > [3] https://lore.kernel.org/lkml/d3832fd95a03aad562705872cbda5b3d248ca321.1747264138.git.ackerleytng@google.com/
> > > >
> > > > > >
> > > > > > Another reason to avoid relying on refcounts is to not block usage of
> > > > > > raw physical memory unmanaged by kernel (without page structs) to back
> > > > > > guest private memory as we had discussed previously. This will help
> > > > > > simplify merge/split operations during conversions and help usecases
> > > > > > like guest memory persistence [2] and non-confidential VMs.
> > > > >
> > > > > If this becomes a thing for private memory (which it isn't yet), then couldn't
> > > > > we just change things at that point?
> > > > >
> > > > > Is the only issue with TDX taking refcounts that it won't work with future code
> > > > > changes?
> > > > >
> > > > > >
> > > > > > [1] https://lore.kernel.org/lkml/diqz7c2lr6wg.fsf@ackerleytng-ctop.c.googlers.com/
> > > > > > [2] https://lore.kernel.org/lkml/20240805093245.889357-1-jgowans@amazon.com/
> > > > >

