Return-Path: <kvm+bounces-34507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EA85A000F5
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 23:00:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB889163037
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 22:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 698891BD01F;
	Thu,  2 Jan 2025 22:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g+FqqnjJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC171F5FD;
	Thu,  2 Jan 2025 22:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735855209; cv=fail; b=M5uiZYLxq6THELG2pM7XrWTeIqTuA9UpfUIsYE1ZUhaqlAavIODs23cU7pQm4pELESD8cr+a+NedRqIcAgPSA0oby0Xg8e2E1zX9H7vHHf95BHLgw06ctpG3D46z2CYpgZcUdu41pKi1mScdmxHPn0YJzhxCMFnC/hQAP3TkCyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735855209; c=relaxed/simple;
	bh=HVEdbXlMn+t3wglnACjEy0z5/2b6UyqCHHR4cdXE1HE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uVm6Gn7KA9xC24uAlJEgtdZZkW8zmzMSOZXBZIGwGe7WyrFn9fyHyrRu1bYoajjEVjwA8shDZHH+L4eavi67Dxt8yX6LDUCkeAMkw+LaQ9qbzxul6PmHoAKfZGu+9xoDsP4G6V7dnmMIYB4h/sVgcXSjaLWbwx6Guk2v6a76KcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g+FqqnjJ; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735855207; x=1767391207;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HVEdbXlMn+t3wglnACjEy0z5/2b6UyqCHHR4cdXE1HE=;
  b=g+FqqnjJu+GjAsm4ZX+JdIqFHZmWQevKNsA6GHpT8Ul4bhWw9CX+NIUB
   cUTeZdCeqb4gW0vxuw4CROxtblfwC7RYRYZ/biXlcc6uupkKZdApK+7kc
   QcgvKY/RXT06o9brey42QOUNn4TyCdoFXAubQ8HoHkZWdvuBXX/txboUM
   UNHKVGEG5JytNVmacMOBH1KdR1zYOGVqLDYJdRFLcZEMTmyZZHOSW7gGS
   sOSimNanIp7V22mBxMCf5qxphjCLtTftihgnoFFS+WyFUqVh7CJPOOMc9
   SuJUBYapupCbZshX3eBsgePW4l5gpvelSuN6+rQZqL5fgNdHCJtqwOr8w
   Q==;
X-CSE-ConnectionGUID: Ynv7r3hbQfOpGqBWKu3Pqw==
X-CSE-MsgGUID: p/rXHH3jTga1opzCvBezFw==
X-IronPort-AV: E=McAfee;i="6700,10204,11303"; a="35806860"
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="35806860"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2025 14:00:06 -0800
X-CSE-ConnectionGUID: QgIe1dvHSPqaq4I077euUQ==
X-CSE-MsgGUID: JY1yVI1eSc22v3+ixB56mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="101472989"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Jan 2025 14:00:05 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 2 Jan 2025 14:00:04 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 2 Jan 2025 14:00:04 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 2 Jan 2025 14:00:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MAE+Pn5/ON3mGkIFvnLdLdCgS4rFDVUtETWIBHI4D5SFRL2WA6yGleJ+BBzM1IbaqfsiVN5SJ7dAABJMs/qWRrgwxzXyYSiJIks0qHaiTawn5tV8Tn1XMmI5mT2M/4yaUBhUVCpsW9ol5TLhhYU2KmZYc2cEX+R7MT02fvKlEeWAOVd0CZPElorEqmAy2HUeaR/V6qlU09h+KaQ1xYjPyFQlK/cw2Wb2G1V2Afb6eEzBYP1tRs3Ki/o5jrz0XSaFCINxLFYZT+pYz8naMHaXtGLn89dnotyzF1goE9N7zpPdghgDVpwor09txMbJ0Gy6Q3qOYyJubwnNB9Q9QPy8Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVEdbXlMn+t3wglnACjEy0z5/2b6UyqCHHR4cdXE1HE=;
 b=qQZQ0PB2XkmiGITTxl57KOrUy0Qt9ScejFBbRpGIjBy2tnqLQlWirHwTNtaUouJM76wWkzjCQAxDIlsYeT367NJkahybYiQMZeclyK6FrZ+uaSuJU7trH5uTjpNMeEE3DaHIrWWFmztSxxsymst54W+uUq8xYOxvsJHnWY+i/v94r5NdQ3mfYFFhyOHqn6IsP18JMGYUqp4wXvdrpuELIOcAdbFQgf/Kywjm4WZP0+/zULAxr1CoNrDTuQ4R9DSocK+/VDZqoim9lNp1wbuVdKzzNAnLexo0X5wO3E63Bru6ZHkuoQWtDFzM+k9xqHgFcc8ciVLXPKzHZdWmCZTzHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7845.namprd11.prod.outlook.com (2603:10b6:930:72::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.13; Thu, 2 Jan
 2025 21:59:59 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 21:59:59 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 07/13] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_sept_add() to add SEPT pages
Thread-Topic: [PATCH 07/13] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_sept_add() to add SEPT pages
Thread-Index: AQHbXCHXCEDEN07XLUqfjiTjMhw/abMECw6A
Date: Thu, 2 Jan 2025 21:59:59 +0000
Message-ID: <b27448f5fc3bc96ae4c166e6eb4886e2ff8b4f90.camel@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
	 <20250101074959.412696-8-pbonzini@redhat.com>
In-Reply-To: <20250101074959.412696-8-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7845:EE_
x-ms-office365-filtering-correlation-id: c970aa06-e581-46ec-3fa3-08dd2b78ccf0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RHlTWTBuU3RHSVMxVGlEdzhsNk1sVUM5YkVRdEd0MTZraGxKU2tLaVRzcGFR?=
 =?utf-8?B?MGFjaVF5b0hweWVKcXBQSzV0WXJhTm5JUEVDMGtyc1FrWkFNaDZLQmdSSWNG?=
 =?utf-8?B?NG4rMzc2R1czUWgzQlJkd0MvOTA4TzIvMmRBbjQyQUxoZFdob2ptQjJkYW1L?=
 =?utf-8?B?bjNvck1PU202RW9kd0hXeWgyeUhxZW1mVjhIc3JGdytTSk9OaGlZdUgxbDNx?=
 =?utf-8?B?S3N4Tll2UDk4SmJNc2djSEY5ZFFteXRPQitlNHNBMHpGdXIySE80WXdrZ2tt?=
 =?utf-8?B?RUtBeU16MnRQb2hLTkZSNlAxM1JjR2dWQlRCbEdnUzRUaE4wbkp6R3JZY3Zp?=
 =?utf-8?B?QTc4ZG9LL2ZOeEZTbU9zYlR2c3JkekppWHBsbktobWZjc3I3RXVibHFoamx5?=
 =?utf-8?B?WXM1T3N3eUlwSU9xazVJc0oxTVlYcFRXQzZ0a1ZwaEhvMmRSQnMzbk9BaVBo?=
 =?utf-8?B?QzN0QmlUWDhUbjAweHRZQ2h6c0FoKzNreEZXbEszVldMWW9YV3pPd3I4Y3NR?=
 =?utf-8?B?ZnhiRVZpYmNKdjhMeVZmblZPUGoxTEFqR1ppWUFSSzNTTTI3Rjc2VVJxdUFF?=
 =?utf-8?B?REQ0Q1VlMmZ4YmIxSjhtbndLMzN4ZGFWZnoxbzJYQTRxeFA4bjQydWhnQUps?=
 =?utf-8?B?ZUJBd0ZzOE9zbG8vUlNCL3U5SWlycHFRMk1VNmc4ZlJIV1AxZElYOTVTY29Z?=
 =?utf-8?B?cng5bnU3THJKNGx4clVDa1FMeFZKUWhVQ29PNkl2ak9xVklBck5pcFVtV0w1?=
 =?utf-8?B?MlFWZ1hZUWFleXBzeEFTTnFVOHliS2RkT1E4eW02aUlJcU9MY3A4SFhjdk5j?=
 =?utf-8?B?cFJrWnRTMFdCSFhKOHRON010OWZueVpNMUIyR3NMMDQwRUVQbUlpNEJlL2pB?=
 =?utf-8?B?d3NyU3lKVURBUVlDM0NKQlNzQ29OMVdrTXVMdFU4OXQ1aWl4cDVhL2NMS0pk?=
 =?utf-8?B?QkdZY2liYnJmQ3UyUjJPVy9jMkxvdkVjWGVKemtBZ0FweTNvczBVNExGT0RB?=
 =?utf-8?B?aEtUYjBtaVpYYmdrb29BWElWaVNMRzQ2OUdDaWpxNndSdnFFbEJscU95OWdv?=
 =?utf-8?B?QTV1NXpCek1YN1gwSTZKTGJoNUJNMlA5eVoyY2svU3FKNFFpZ2FVT2VsR0Y4?=
 =?utf-8?B?a0ZlajFIUXhvYzVRdmZVbjJkbG8xTW95VEpmKzJpM2FSZVFJTmh1U2dZREls?=
 =?utf-8?B?VWxTaGJlVnRiQ1hQbVU5eUVPY2hKbi9IdmZLSGtjN2Z0YTZqa1RYNHV3amJw?=
 =?utf-8?B?L3pReDk2L0hKZW1KRW1qRSs5R29FY1dkYkZKZEw2MmF4c3ZUWlNRNW9xdEFr?=
 =?utf-8?B?WDV4NTlGRlUzei9hSHVFcWhBbTd4akJkemI5UHRNVGxhSllXVjQ2eXI0L2t5?=
 =?utf-8?B?REpDTkhGdElxOW5hU1ZJQzF4WDFLQ1VkbVE5SFlKZm1hZmF6ci9RTnVZVVZY?=
 =?utf-8?B?VExndkxFd1hiNitDREtNYzNLMWRvL0VZa1kvYk1vQU5zaEVSM1JweWJRMEUr?=
 =?utf-8?B?S3lqemdkVFVBaVZZS3l5WW9PaUdwVkR3aFh1M0lISHhVQjF0dEl2YVF3TEFS?=
 =?utf-8?B?V3dBSm5XcGxza3NOckxCbUQ2eDFFRlFiRUpRcnQ3M2RPcUJHbENnS0J2RTVu?=
 =?utf-8?B?NkdsbEhtaEtZWUlWLy9wR0Y4OHB2Wm1oSXhZcFRWZkc0ZnZFeVIrU3FLeWtT?=
 =?utf-8?B?aUlHT0dCeXRMNVJzK1llM0tYbVlDMXgxa2VualdsL0kzVkdGdk9pQnE5ckFm?=
 =?utf-8?B?Zi8xcjl5cW4xQVhwczkzdmJrdkRYOFhCbWJXT1lFT2FtdHpFSVRmN0ZybXBS?=
 =?utf-8?B?bWZvY09VWXM4Qm5BaXJEeXl4S2dKdEtTK0drRnczZGg4ZTZsSk55RFNsZzRo?=
 =?utf-8?B?Q3NYMFRzSnY3bVBPSWRpVU94cmtNK3RqRUprSXZhd09FOHRFbGZ2bkFUN3hY?=
 =?utf-8?Q?FFcoNf0BG5bEYjmixhO4GEioZPFKnvUC?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkJORlRjVktVQkhqZjk3d09wcnlyOHpsdU5BYjRmb1FiTkgzY1VwU21Ld3FG?=
 =?utf-8?B?dkdlWUdCNUNSQkNFalEvOEVuU25sUDhxNGw0K28rejBneUo4SVZ3ZmkrTVZ4?=
 =?utf-8?B?a1dlbkNHcDA1QTAvcC9yd3FRRXFQZ096NHAzLzdrWjdSRFZ3UEtIUzBXSHFi?=
 =?utf-8?B?d0R6UHNmcS9jYW9DeEYxS0ZjUUFJWlRaQXJiMmRZZ0t1bVI2NkJiQk1LaDlC?=
 =?utf-8?B?TklMdkQxWGRhQittVnY5cnF4YUNtbEhJUlFuSmlGRWU4bDJtZW5mY2Jtc3ZF?=
 =?utf-8?B?UUNtaUJRK3gyRmxMZXJCblF4TXMzMUVQR0RXOTIveEVTYXpTSXFrQk5tUzNM?=
 =?utf-8?B?cm9MTFZlNFRTOWViY3Y0Y1BHUUtVYURheGdqd25KTVQrdWV3RFNFMmlnNWRw?=
 =?utf-8?B?U0g1ajE1VmhIdGc1d0krUW96VmFxdW1nSEU3ZXVlMjl2SisvK2M1emxIRnhI?=
 =?utf-8?B?M0s1eUNsbnlpaWdRK2tRd2RnYm5kZllYbGRYQ2dNS3M2QXhES3RNclM4cmRR?=
 =?utf-8?B?dC9MTHcwR3RnVDRSZUhTYk9hM0VOZ0dRSW5BQWNHdGpQTW9zYStEV2VMZGwx?=
 =?utf-8?B?UTdybFM4dEZuSXBmY1lMZTVtWHRuY0I3V0pVVElVcUF4Q0xYN1N2QWlyTHFq?=
 =?utf-8?B?SVEzS2c3N0JrT2grbHVncmlVa0dpQmFUaTFYNTVQN1J2UzhlejYrN1IvTXZX?=
 =?utf-8?B?WHdOa2RFTnpqemdieWtvZ2I3NzdVditEckYrVDl5SUZhWUFmbFh5VFdoUTk0?=
 =?utf-8?B?SmtxOGZvY2VTZnM4L3NBYjQzVHZ2bXRJdVNUWnU1NVMwN1FLNHRFQUMrTXli?=
 =?utf-8?B?N0NubUhCTXd0ZHdWYy80OUIvS2hJaTFFZHJlQXJhMDYyaDNDWm02Qm1Mc0xF?=
 =?utf-8?B?Tm1oOWwwM3lTNStwWGRHZ2EzSWtkZFduSm4wa2M4QkF4cWlCOTY5cDNZdTZE?=
 =?utf-8?B?dDVoZmR0SFBDRjVsRWV6QW52elJBcWgvZXl3alBPTFZ2MkY4citCQWp6TEN3?=
 =?utf-8?B?dkNRZWNjZ0Q5RllaNHB6aURvdWl2VDF4by80YnE0MjBzbnh0bk9ZS21UOXQz?=
 =?utf-8?B?ZExOSUN0Ti9KeUtHVlBLbjhFU29aR2ZpT09DUVRxT05ncHl5NVhtOXB1RURB?=
 =?utf-8?B?eDZuU3l4SnBEeHc4M3YzenkzRXM5RHdUT3RPN0p1MUJpdEV6eG10YTZtRW9V?=
 =?utf-8?B?eUczR3V0RmdwbHBxazBiTXdpUER5cXdGSFRWaENVRWx4K2pCaTlHOTBvT3By?=
 =?utf-8?B?UzNHbHMwQmMyNmVaVSttS2ttb3FEYTgycm5yN0hKelpOMUU0bmxwa24wRlpv?=
 =?utf-8?B?cG5PYVZWK1lCZnlkRVBLaFZJcmRNR2lHY3MrMGlrVStVeWgySXQycDBmUXpG?=
 =?utf-8?B?S3FjK0xuemVEdTRvV2pDUktkSXRTUmVFRk1odk1HR3hPUnI5NVNRZnRLMmhE?=
 =?utf-8?B?aDNna05pSDRsb2FPS1VnYUtQWEVDLzQxVTFtVFhkNXAvWjNvL1hvSlVRYXN0?=
 =?utf-8?B?WHlWZnhiV1J1VStDQUw1REphNVBaM1owR21veFA1a3F6WmE0N0tvRzRvdW1s?=
 =?utf-8?B?VWw0dG1PVDd4SDBHdmplV2FlK2xuTUJBMUVHRHEwaXNWb3ZjR2x2dG9hRU9i?=
 =?utf-8?B?WWhhYjk3ZmNPaGtSd1hlYVF1dUJ3N0txaDNHMytaK095bG9tbUVRUm80ZWRK?=
 =?utf-8?B?c3lNNnlxRXJEaSt2eUV6SHFQMEppVTFIUFU1L3d6TllEUVJVYXp0Z05VYmsx?=
 =?utf-8?B?dVVocEsvcC9lajFzOGVyS3EraWtxbGtpYjlUdXVLUWFvdXpnZVhYU241a2hw?=
 =?utf-8?B?Snowb1VGTzlIOUJ6QXVlMG9CSk5UNGJlZ1ZhZEJvNFFsL2gvOFdIN0hMU2gz?=
 =?utf-8?B?OGVycGlZdWQwZS9IN0RJSU1SbUZHbXZaaEdGZEsyOXg5SnlieURLQkRsM0Fh?=
 =?utf-8?B?OVgvOXhtK0h2UGJPOTVWd3F5ZzZ3dUxLT0QwY3k0bXdCU0VaREViM0Z3Q0pF?=
 =?utf-8?B?djdvOW96RW53ZFRsR1NiSjFDRy9ZWUkrMUcrbU1ybFJreVpEYUNiWGJObGwv?=
 =?utf-8?B?R1hHTkhPSVhFK2Jha29yejlXQUZMM2tpQnNEaGZLUUVIVTNuWGFhZE5RSWdv?=
 =?utf-8?B?R3VxQnNXeTBYQ1gwSXNGUS9zYkxsZVk1dXZqZVg1L0RZNWh3Nko2M0VvUHJX?=
 =?utf-8?B?VXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <06298F472920A84992C2BA3C55D1ECBB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c970aa06-e581-46ec-3fa3-08dd2b78ccf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jan 2025 21:59:59.0724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FSGww39FmZGAHt3UMEIP7I8gWNQSStDFiVz1PfBrQqEr8MpTsXqUXPeowhkTzrjwUuBh9Wjh0ZqqubLEa1KyJ5pFWEUO/p3jioRlLD8zDCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7845
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAxLTAxIGF0IDAyOjQ5IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiANCj4gK3U2NCB0ZGhfbWVtX3NlcHRfYWRkKHN0cnVjdCB0ZHhfdGQgKnRkLCB1NjQgZ3BhLCB1
NjQgbGV2ZWwsIHU2NCBocGEsIHU2NCAqcmN4LCB1NjQgKnJkeCkNCj4gK3sNCj4gKwlzdHJ1Y3Qg
dGR4X21vZHVsZV9hcmdzIGFyZ3MgPSB7DQo+ICsJCS5yY3ggPSBncGEgfCBsZXZlbCwNCg0KVGhl
IGJpdCBwYWNraW5nIGhlcmUgaXMgYSBiaXQgbWFnaWMuIFlhbiBoYWQgYmVlbiBsb29raW5nIGF0
IGFkZGluZyBhIHVuaW9uIGxpa2UNCmJlbG93IHRvIHVzZSBpbnRlcm5hbGx5IGluIHRkaF9tZW1f
c2VwdF9hZGQoKSB0byBwYWNrIHRoZSByY3ggcmVnaXN0ZXIuDQoNCnVuaW9uIHRkeF9zZXB0X2dw
YV9tYXBwaW5nX2luZm8gew0KCXN0cnVjdCB7DQoJCXU2NCBsZXZlbAk6IDM7DQoJCXU2NCByZXNl
cnZlZDEJOiA5Ow0KCQl1NjQgZ2ZuCQk6IDQwOw0KCQl1NjQgcmVzZXJ2ZWQyCTogMTI7DQoJfTsN
Cgl1NjQgZnVsbDsNCn07DQoNCkl0IG1pZ2h0IGJlIGEgYml0IHZlcmJvc2UsIGJ1dCBJIGFncmVl
IHNvbWV0aGluZyBzaG91bGQgYmUgZG9uZS4NCg0KDQo+ICsJCS5yZHggPSB0ZHhfdGRyX3BhKHRk
KSwNCj4gKwkJLnI4ID0gaHBhLA0KPiArCX07DQo+ICsJdTY0IHJldDsNCj4gKw0KPiArCWNsZmx1
c2hfY2FjaGVfcmFuZ2UoX192YShocGEpLCBQQUdFX1NJWkUpOw0KPiArCXJldCA9IHNlYW1jYWxs
X3JldChUREhfTUVNX1NFUFRfQURELCAmYXJncyk7DQo+ICsNCj4gKwkqcmN4ID0gYXJncy5yY3g7
DQo+ICsJKnJkeCA9IGFyZ3MucmR4Ow0KDQpUaGlzIHdhcyBjaGFuZ2VkIHRvIHRoaXM6DQoJKmV4
dGVuZGVkX2VycjEgPSBhcmdzLnJjeDsNCgkqZXh0ZW5kZWRfZXJyMiA9IGFyZ3MucmR4Ow0KDQpU
aGUgcmVhc29uaW5nIGlzIHJjeCBhbmQgcmR4IGFyZSBub3QgdmVyeSBjbGVhciBuYW1lcy4gVGhl
IGNhbGxlciBvbmx5IHVzZXMgdGhlbQ0KZm9yIHByaW50aW5nIHJhdyBlcnJvciBjb2Rlcywgc28g
ZG9uJ3QgYm90aGVyIGNyZWF0aW5nIGEgdW5pb24gb3IgYW55dGhpbmcNCmZhbmN5LiBUaGUgcHJp
bnQgc3RhdGVtZW50cyBzaG91bGQgcHJpbnQgdGhlIHJhdyBlcnJvciBjb2RlIHRvIGhlbHAgaW4g
ZGVidWdnaW5nDQpzaXR1YXRpb25zIHdoZXJlIG5ldyBiaXRzIGFyZSBkZWZpbmVkIGFuZCByZXR1
cm5lZCBieSBhIGZ1dHVyZSBidWdneSBURFggbW9kdWxlLg0KDQo+ICsNCj4gKwlyZXR1cm4gcmV0
Ow0KPiArfQ0KPiArRVhQT1JUX1NZTUJPTF9HUEwodGRoX21lbV9zZXB0X2FkZCk7DQo+ICsNCj4g
IHU2NCB0ZGhfdnBfYWRkY3goc3RydWN0IHRkeF92cCAqdnAsIHN0cnVjdCBwYWdlICp0ZGN4X3Bh
Z2UpDQo+ICB7DQo+ICAJc3RydWN0IHRkeF9tb2R1bGVfYXJncyBhcmdzID0gew0KPiBkaWZmIC0t
Z2l0IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5oIGIvYXJjaC94ODYvdmlydC92bXgvdGR4
L3RkeC5oDQo+IGluZGV4IDYyY2I3ODMyYzQyZC4uMzA4ZDNhYTU2NWQ3IDEwMDY0NA0KPiAtLS0g
YS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmgNCj4gKysrIGIvYXJjaC94ODYvdmlydC92bXgv
dGR4L3RkeC5oDQo+IEBAIC0xNiw2ICsxNiw3IEBADQo+ICAgKiBURFggbW9kdWxlIFNFQU1DQUxM
IGxlYWYgZnVuY3Rpb25zDQo+ICAgKi8NCj4gICNkZWZpbmUgVERIX01OR19BRERDWAkJCTENCj4g
KyNkZWZpbmUgVERIX01FTV9TRVBUX0FERAkJMw0KPiAgI2RlZmluZSBUREhfVlBfQUREQ1gJCQk0
DQo+ICAjZGVmaW5lIFRESF9NTkdfS0VZX0NPTkZJRwkJOA0KPiAgI2RlZmluZSBUREhfTU5HX0NS
RUFURQkJCTkNCg0K

