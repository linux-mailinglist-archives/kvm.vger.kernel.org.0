Return-Path: <kvm+bounces-63839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 34CAFC74000
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 13:38:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1C4564EA6FD
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 12:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45347339707;
	Thu, 20 Nov 2025 12:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iR7rKf5V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700A8339704;
	Thu, 20 Nov 2025 12:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763642251; cv=fail; b=jOFT802Ksb7W9PZfFfd8mA3emBeAT2N/OxO55o8RdgNlpOobc2Xlr00LvqGpD9s6QqpROPyZDHYVP6PpNwMyAnJWPMlqpld3coYiTeDqruO7IW4SBsDMmJReV+ztTIYRFubqX/vMZzHI5THnrmMrmZg1wEQaqhw0TjHvQwWHtCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763642251; c=relaxed/simple;
	bh=K/EkXuscocY0qgPuuCGp142l8bLU3QQHdE9PaBYRDJI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E8vdS6VctZQqeexbOtvfAnNnLTvjIHdTxFMsOyBsuVBPqQA+KQROQViIaOcdnNAiV9BDpOh7N4F3uwr4nclfNvIUvi6gevVb2x9Sm25Ma4VyiAAYgQRccQt4bJBefc82pqzYNRE1SpugVlwXNZUFcjWoW91vrb/vbd6W7GZcQeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iR7rKf5V; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763642250; x=1795178250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=K/EkXuscocY0qgPuuCGp142l8bLU3QQHdE9PaBYRDJI=;
  b=iR7rKf5VIsyB/dXDhJhpGkUDVf35x2LCDXa+WE+2Vwu2Xb2IHRvb8v7X
   VQHkC7+0WktfJCQelotBgCVMQy/JubrpLZlcDxJnIkSbRzJcFEfpWbp8F
   Z+Mxynj6xLdkzKKMMDL2613YE4Tjnx+IblhN3p/h794cpP53TubB/x1m3
   4NDi9fguj+7p/I6Tcn1E4CyJClk1JFYmDbaXHDG4Vu41SzSEey/RbG5F/
   8jkFuXIlQpsffMUprvWBXCQltmx7wo4+Msq5Bow9TCZFwd6L4VUkSzcyT
   sxalveF2FC2HZaVY7yLt4Jp2objL1M32oU+cGwn9SMY1zO6p/WvwiCvC6
   w==;
X-CSE-ConnectionGUID: Kn0i/9EmQQ2UBohUfmz27Q==
X-CSE-MsgGUID: wYGYws63Rce+8lA7tNDLGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="76037914"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="76037914"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 04:37:29 -0800
X-CSE-ConnectionGUID: acRXMfIPRJ6h0v+nE9o6pQ==
X-CSE-MsgGUID: TrmbzVilS0K1Zo4HOtaoaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="190633977"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 04:37:29 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 04:37:28 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 04:37:28 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.23) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 04:37:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g+0lrLP7bVlNfPMYJQh/GT58hEEgZwjbTJ+aZnm7UZcm+fapy26S8Vj9AjrqMNP+Ycbg4Pk5qE6RLSmBOCG2R8qQnFaX0fi5AVV3Jt2In0ckaiMYMCcy8d6EC94ZPEnx+edpXB/uoVaE5EEvNwruQk64yImCB3e4PAYm5Ft4jHXAQIwip1IlJ+IHVm9JW8wIppnQVJPjpzn2lFLcKG0EfDECaTgY9hQYws71pYAZ2yegvl2JkiyvmK5IN5wI5fw+xr/hMx7+eNHU8TWx0oabvsTXphoS43vFcy+IY7QrEmurcX5C6wW5MaO14YvWkyJjeRjT+Zax+AGvUzqSCBn3RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVWrO7eAv8uA8ZmIB3RTXasCD9+WcBvhwiRp9i7B6w0=;
 b=RBQFUH/bwQOFZxFCvJjfqI2QzqS9UcyloLLm8euScMz71V9c0aOvejL7F/7oJ2R4zQbsqPxMb/bxI9bmkhZsBwo9jhIprJYARH5WxcbayH/XaCu+WMeNDW/yd5mVmDwX1lEuk59oZ3k1qyg1KntJN4K6qqcYK4bWGh/RFAc9ie5+0itgxxOf3+zb0X/xP9kYdo3pt+XMg0s4xOqZiNOndXEDz9KP5x5Dk52dAY1FFz5sXLadnHooi3cJleGPr/jE2SfsogXGPoaFdndCXA7VHrAk3CoJKz4IrKLbBBbgh0zpMxZBYcSS7k/cVaFHkFnf+dDv6NhkjOkAW+FrktveBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 DM3PPFC3B7BD011.namprd11.prod.outlook.com (2603:10b6:f:fc00::f49) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Thu, 20 Nov
 2025 12:37:26 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9343.011; Thu, 20 Nov 2025
 12:37:26 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Alex Williamson <alex@shazbot.org>, "Kevin
 Tian" <kevin.tian@intel.com>, Yishai Hadas <yishaih@nvidia.com>, Longfang Liu
	<liulongfang@huawei.com>, Shameer Kolothum <skolothumtho@nvidia.com>, "Brett
 Creeley" <brett.creeley@amd.com>, Giovanni Cabiddu
	<giovanni.cabiddu@intel.com>, <kvm@vger.kernel.org>, <qat-linux@intel.com>,
	<virtualization@lists.linux.dev>, <linux-kernel@vger.kernel.org>
CC: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
Subject: [PATCH 5/6] vfio/mlx5: Use .migration_reset_state() callback
Date: Thu, 20 Nov 2025 13:36:46 +0100
Message-ID: <20251120123647.3522082-6-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251120123647.3522082-1-michal.winiarski@intel.com>
References: <20251120123647.3522082-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0283.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:84::9) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|DM3PPFC3B7BD011:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e2cb308-f2e9-4022-05d5-08de28318fe4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YUkwZWM2NUJQY2IrdkJGLzA5TkNzeHlIeVp6c2hobTBMTmwwcHUwWTRkbkhi?=
 =?utf-8?B?QXM4L2Y3dGFySlJwK3pMNGJIaFNvdlR3dkpZSGZEYWRtbzhDMjZyRVlFVmpC?=
 =?utf-8?B?NDh3dmZaajZwTE1tSlJNZVpaTmdKbS9tTUhyOGRNOEk5QXJGT3k1dFVuMXlj?=
 =?utf-8?B?dVZ5YWpZeVRvRkpWT2J2M0dZY2ZXZkIxMGl6UXpHQnV4VTNxODRhNkRITFNt?=
 =?utf-8?B?TGcwWEU2NDhPYW12UTRyLzFOcDl2NXJvb3N2VGdoemNGaktoNTUvZUhFNnF4?=
 =?utf-8?B?N0Ztc2xBRnJ6bUFkWStlWjNWUjNUSWR4TkRSaC9ZRTNXNmJ0aDdZZHpEcGJD?=
 =?utf-8?B?RnBpWStqQnhxSW5QbTBmWDg4Q2dUNkd1Wko1VmFLUDRpUmpWQllRU3g2dG5u?=
 =?utf-8?B?Tkdsc3VzQ3RUcmgyaG0vMU00TVZrRitVMjhqdUFkc3B1Vkg3QkFwOUlpc0Fl?=
 =?utf-8?B?K2pyRWdLbGpaNXRHbmsrVmlnVzRjZFFrcnRMZDhzV2xaUmcvZ1VzKzVlWW1W?=
 =?utf-8?B?YXZjbFI2ZUw1VWYvVGJXK21rSWNoQzhzSTEwcjhDemNyMDZxa1JVZEdsQTFu?=
 =?utf-8?B?Wk1DR1RIdGpFTDZ6SzVHd0JEaFhmM0JGOUpaOW9GRFNDSkI2aGdPZmZHVDBY?=
 =?utf-8?B?bFZlVUk3Ynd4anFrUmMreDViL0tHcmdvTGhOY2w0RGlEd2N5K3lpVEE2Snlp?=
 =?utf-8?B?MWpLYWt2b25iMUxZYm4xMXdydC9sUjZvdHY1Z0srWDQyYjZJL0RoRld3eTk3?=
 =?utf-8?B?T21WNHhyclJ5WGhQTWplalIwczdMdTlLSWg2UFhKVlhDMHR0OUtuUEF3UTdK?=
 =?utf-8?B?a21ZWjZCNS9qb1ZnbWFnR29UN1FkZWdPc2FiWVdWQmFWckRNWDh0S0ZuM3hK?=
 =?utf-8?B?N1BmUUZNVmNBdml1Tjhvb09FUUhYV0I2K2pHQ2FnK1o1eU5hem1XYXE2WjAr?=
 =?utf-8?B?TGk3VmNHY2MrczJacW9mTjVhcWNoOWtBYW1wbG0yMGVNS2JmZUpvRHlFZG5l?=
 =?utf-8?B?akwxY2Z0bTFqSEV5bVF1RG83d2NQRHJ3U2hmYzVabDZEcG1CdlhBMEhuaGdS?=
 =?utf-8?B?YmJLNjkydHgzZVB2UzQ0SExqc2h0SVgrTWdrUUhicXlkNVAxeUNmL3gvbTNF?=
 =?utf-8?B?NlRYNi9ISkZONGJhOHVicnh2ZzBzNXA5Z3N5UGV6ZVdXaXZhN1lQb2pxaVdw?=
 =?utf-8?B?S3BIbC9VSlZhMDFKZ2s3dUhTc09aQTZ3SDdsbkp5aW5aVitEQjBtdlV0N1lV?=
 =?utf-8?B?S0FWSGQ0UVRGdWptY0NCVk9iRUY0eWNyc05Qcm5TLzFFem5mU21pa0U2VTlC?=
 =?utf-8?B?K3ppRmtoNUd0Y2xWMWJhc1RIdVJ6YnJnb00vOGJFcWlzSnpCUk1pMzNwRXg3?=
 =?utf-8?B?UU5ES0tmR2tuTEh0ekdPS1ZOWDNVTkVVUW40WWFqaHVRQ05zS1IxM21sdzdQ?=
 =?utf-8?B?T1FmckJJWktZYXR1NnVCdlk5dHVPRSswbmVPSWxnd2tIV1o4eXBCNUZJNDhm?=
 =?utf-8?B?eWFhRk1FbUgyZ096LzMrakNNblk5RVRqUEVrdFdmc3BQNmJRQXhhTEFtbnIy?=
 =?utf-8?B?Y1MxYU1YMmpOY0NUTnNva1dWTlNMQk12TVpFUzRycVVWZ0plYlBQYnJNdkNr?=
 =?utf-8?B?OTJDSU4vcHE2NDFqVGZWN05hb3pwSGJYaGVwMjJpTmtnUDh0amhhRVRHNlpr?=
 =?utf-8?B?T3I0SXZ2ODk3VnRQcWU0RWxGQmJBZ2IydlN6bWNGZkJNQWpQaEdGc1hsNi9y?=
 =?utf-8?B?aVBKRVNicVhyOEgzOWEwOTNJSGNTdEV4cnUvbUdRREVtcE1LM3p4Z0xXZmp5?=
 =?utf-8?B?eFpOcE9kVWt1YnYyYzlhTVlKbDhyVTl4V2xabEdhblR3ek1sUkkrWWV3KzFR?=
 =?utf-8?B?enZtd0Z4b2JqMStGT0xSYTk4YzBOdVl0L2NocDdmajJoU3UxRThzc29VcWt4?=
 =?utf-8?B?SDNZQzBGVUpKRGlpb1hGTmdHL09vMGJkUEdGTjFGNXZ1a3pncnVQU2ZkSFBN?=
 =?utf-8?B?VHZ3WnIwQlBzMmhRZGo2KzBJa3J2cWFyZzNxK0h5NWRGTUR0Qll0U29FWU1C?=
 =?utf-8?Q?Yhr0nf?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1F2VERTNm9jbnczY2M1enh6N0tUekNxdGllR3lLZGtnTXg0T1pneVNBSkp4?=
 =?utf-8?B?aVUrLzJuR21PWEVTQnFBRXlLemdJcllmb2Q1U29TMk02TW9jTVJ6K2o4TVg4?=
 =?utf-8?B?YWxtNWtRelBWY25YYWVGUzVRVHJlNVlSaitrbVZMKzBsUzFZSjM0RHZ2S1BM?=
 =?utf-8?B?YVo0UFBKcE5LbFE4anAyYWZlMmJWb2lXMXN2aUVUY3lmQ1ZBd2FHYk9kZWRw?=
 =?utf-8?B?V3A1Q3NNMEhuUGxaU2x1alVCcXFPYVpjeWpya01CREJ5Z2VsZTRmWmI2TXVp?=
 =?utf-8?B?OGMyaVR5MTBLMU1zQ0VvMGNwVXFTY2hpY2FMcmNLNUFxbUNxOWZnL3l6bVYx?=
 =?utf-8?B?OThNZ1BLTzJxOFp0MDdWRmxvR3J3MWRxNnpBSWlOU055ZlFwaC9PZjhnMHpH?=
 =?utf-8?B?R2J5RExBQ3V6ZXhFUVlqUmtlMlZwR1Nrc2FHR2czUnZHMGt0ek5nVXNORGZ4?=
 =?utf-8?B?TEc3VDg5a2RyQnFvVWZVbUZqdGl5L0djYzJUVjRXbXIvK0dnUlp1VjR0TDI0?=
 =?utf-8?B?T0c2c04vTUEvTUlHYkNHUHhFUGl0QmNmdFRHUERFNUVFWWZua0JRQ0lZSldG?=
 =?utf-8?B?WFZBOGNveThNWnNqZ1JDbmFGbFMybExkZm1tWGtGZCtXNnlYMDh1MTk2WFZx?=
 =?utf-8?B?clVPOFZxOGdaaTMzQzRqbDJ6SHZXZUtKaldQL00rRmxaWmd0UWQzZnVHTG5T?=
 =?utf-8?B?UjlUdzRoOE0rSnZud0RQK3JlZWt6SFdxQitKWUtUWUFZMVVNcERVOWFjZjNw?=
 =?utf-8?B?Z0lrYm01OGZyMWpGNW5HaFg5VDkzdW9Ham5xQklVZk4wVTlLZkFPWENKQm9i?=
 =?utf-8?B?ZFdIbFhtSkRFVXppSG4weW01Y3o5QXlWcGgrREtKQXBQTnU3SUxVUlpmUmFu?=
 =?utf-8?B?SlBUSVNNSisrY21vc05lUUFNaXRCTERJVGs2UjllaVlqeWJrSVEwQUtvbC9X?=
 =?utf-8?B?MUhpZHVNTnhoSm0wMm9LVXRPUFdoSXMzSWNEQWR4U1YyK0tveTRRMTJYZUpK?=
 =?utf-8?B?SldjWU1iSUVzckxkNWhreWZYdHJMZ3N3QmVTcFJOV0UvbmwranphVmU4Qmhk?=
 =?utf-8?B?OWpLYi9JTFNSNHhpY0s1RnBKdHdYOUNPUHJrTE5mRnI3RUVNL1FTRlVYakhS?=
 =?utf-8?B?emd5b0ZtRFltdlNtOThwUnd6RnkxaFArVmlHMzJsSXdqQ0lGMlF1b250ZzN2?=
 =?utf-8?B?VmgwVGxyZW5mRVhLQTM1Q2M1QTdHR3dNd0V4Q1JpQjlTK1Q5NzBZbXphM1hN?=
 =?utf-8?B?b1o4NHZhODA3bDZibTZCZ29DNGRaU1c5NVkzWEpTNkhlNEgyZTladEpFOVpH?=
 =?utf-8?B?OTEreUZyVGdnK0lsNTlmRTBiNVBQTUs4ZzI1ckdIR0NsMHJOakRZYVJ3MjAv?=
 =?utf-8?B?UnMvWUdTSDZJc3JrZ2ZHd2RydnhNa2xhQ2syUEgrazI2czhlWVlyRXVQWkZH?=
 =?utf-8?B?N0hrNGNtN3Qwb09DQzhGaGdoek9RaUFUM2dSa3IxaUVDVy8zKy9mZjRnNUpv?=
 =?utf-8?B?bVFZOTNrUXY2V0Y4MG5WQ3lvUENsVndGOUN4M0ZlMUtOMEZyYldhUVpDd09j?=
 =?utf-8?B?MUlBcTAyMTE5VGJjS1drckVqYUM1cmkxYkhMZmdqZ0g4RE9TNFpvTCtiMmVI?=
 =?utf-8?B?NU4yTWw3NHVaek9aM3VxZmVOTFR2dGtxQlJ1TUxGUWRVS1JqRjkySHEzTlJI?=
 =?utf-8?B?dlNUVXRvNHpZQ21MNkR5WFdBNTBIUnZMcjdsWUk4YkNyVWdEcnppTGhubXNs?=
 =?utf-8?B?MmRtakp3aGpVSkZPeStoMldBeThVRWRZN2ZFWTRGNEwyNFFEQzEwNytNdEpM?=
 =?utf-8?B?RStXN25pc29iaUxxbmd2RnJHNU9QeHVicVdXU3NxZUV2Z01TUU0wR1JNQVBV?=
 =?utf-8?B?dktpVmZ0RHpqSGdRYmRRV01JcC9sV0hvODVWSEVQUmdyUlA4NWpjRXB2dVZ1?=
 =?utf-8?B?MzZMWkNrTHBOdVFNRk9HdXVYT2phOWVMZFgzVmUzaG5QR05XcUw0U2p6VlB3?=
 =?utf-8?B?MHpGYzVmUkRFY1UwaGNLT0VROUg2c09neGhVTlUyN1EzRDZlNWZqNUR4L2R1?=
 =?utf-8?B?dkd0Y3N0a1kxY2taa25hcDVGTytPWmJtVTFvbTlPbUVGc0FEQzQ0SWV5MmEy?=
 =?utf-8?B?UjhkditMeGtTNlBnRmJzSlNodlBzWmJYdUxBdmhYL1RkdDNycEpEdnZrSjNJ?=
 =?utf-8?B?b2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e2cb308-f2e9-4022-05d5-08de28318fe4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 12:37:26.7354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xy/cGXs/Tpi3g0l8tBX203q+1hr4xGcG4qBrMSi948dLU0pL2N6V+OgihcgkBpYPP2NaF5eXPnt3XuL50ebKSJsFTHcQZKoCe5TIaQTR7PA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFC3B7BD011
X-OriginatorOrg: intel.com

Move the migration device state reset code from .reset_done() to
dedicated callback.
Remove the deferred reset mechanism, as it's no longer needed.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 15 +++++----
 drivers/vfio/pci/mlx5/cmd.h  |  3 --
 drivers/vfio/pci/mlx5/main.c | 59 +++++++++---------------------------
 3 files changed, 22 insertions(+), 55 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index a92b095b90f6a..de6d786ce7ed1 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -178,13 +178,13 @@ static int mlx5fv_vf_event(struct notifier_block *nb,
 	case MLX5_PF_NOTIFY_ENABLE_VF:
 		mutex_lock(&mvdev->state_mutex);
 		mvdev->mdev_detach = false;
-		mlx5vf_state_mutex_unlock(mvdev);
+		mutex_unlock(&mvdev->state_mutex);
 		break;
 	case MLX5_PF_NOTIFY_DISABLE_VF:
 		mlx5vf_cmd_close_migratable(mvdev);
 		mutex_lock(&mvdev->state_mutex);
 		mvdev->mdev_detach = true;
-		mlx5vf_state_mutex_unlock(mvdev);
+		mutex_unlock(&mvdev->state_mutex);
 		break;
 	default:
 		break;
@@ -203,7 +203,7 @@ void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev)
 	mutex_lock(&mvdev->state_mutex);
 	mlx5vf_disable_fds(mvdev, NULL);
 	_mlx5vf_free_page_tracker_resources(mvdev);
-	mlx5vf_state_mutex_unlock(mvdev);
+	mutex_unlock(&mvdev->state_mutex);
 }
 
 void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
@@ -254,7 +254,6 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
 		goto end;
 
 	mutex_init(&mvdev->state_mutex);
-	spin_lock_init(&mvdev->reset_lock);
 	mvdev->nb.notifier_call = mlx5fv_vf_event;
 	ret = mlx5_sriov_blocking_notifier_register(mvdev->mdev, mvdev->vf_id,
 						    &mvdev->nb);
@@ -1487,7 +1486,7 @@ int mlx5vf_stop_page_tracker(struct vfio_device *vdev)
 	_mlx5vf_free_page_tracker_resources(mvdev);
 	mvdev->log_active = false;
 end:
-	mlx5vf_state_mutex_unlock(mvdev);
+	mutex_unlock(&mvdev->state_mutex);
 	return 0;
 }
 
@@ -1589,7 +1588,7 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 	mlx5_eq_notifier_register(mdev, &tracker->nb);
 	*page_size = host_qp->tracked_page_size;
 	mvdev->log_active = true;
-	mlx5vf_state_mutex_unlock(mvdev);
+	mutex_unlock(&mvdev->state_mutex);
 	return 0;
 
 err_activate:
@@ -1605,7 +1604,7 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 err_uar:
 	mlx5_put_uars_page(mdev, tracker->uar);
 end:
-	mlx5vf_state_mutex_unlock(mvdev);
+	mutex_unlock(&mvdev->state_mutex);
 	return err;
 }
 
@@ -1787,6 +1786,6 @@ int mlx5vf_tracker_read_and_clear(struct vfio_device *vdev, unsigned long iova,
 	if (tracker->is_err)
 		err = -EIO;
 end:
-	mlx5vf_state_mutex_unlock(mvdev);
+	mutex_unlock(&mvdev->state_mutex);
 	return err;
 }
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index d7821b5ca7729..e36df1052cf5e 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -170,7 +170,6 @@ struct mlx5vf_pci_core_device {
 	int vf_id;
 	u16 vhca_id;
 	u8 migrate_cap:1;
-	u8 deferred_reset:1;
 	u8 mdev_detach:1;
 	u8 log_active:1;
 	u8 chunk_mode:1;
@@ -178,8 +177,6 @@ struct mlx5vf_pci_core_device {
 	/* protect migration state */
 	struct mutex state_mutex;
 	enum vfio_device_mig_state mig_state;
-	/* protect the reset_done flow */
-	spinlock_t reset_lock;
 	struct mlx5_vf_migration_file *resuming_migf;
 	struct mlx5_vf_migration_file *saving_migf;
 	struct mlx5_vhca_page_tracker tracker;
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 7ec47e736a8e5..ddc6fa346f37c 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -325,7 +325,7 @@ static void mlx5vf_mig_file_save_work(struct work_struct *_work)
 err:
 	mlx5vf_mark_err(migf);
 end:
-	mlx5vf_state_mutex_unlock(mvdev);
+	mutex_unlock(&mvdev->state_mutex);
 	fput(migf->filp);
 }
 
@@ -544,7 +544,7 @@ static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
 	}
 
 done:
-	mlx5vf_state_mutex_unlock(mvdev);
+	mutex_unlock(&mvdev->state_mutex);
 	if (copy_to_user((void __user *)arg, &info, minsz))
 		return -EFAULT;
 	return 0;
@@ -552,7 +552,7 @@ static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
 err_migf_unlock:
 	mutex_unlock(&migf->lock);
 err_state_unlock:
-	mlx5vf_state_mutex_unlock(mvdev);
+	mutex_unlock(&mvdev->state_mutex);
 	return ret;
 }
 
@@ -972,7 +972,7 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 	if (ret)
 		migf->state = MLX5_MIGF_STATE_ERROR;
 	mutex_unlock(&migf->lock);
-	mlx5vf_state_mutex_unlock(migf->mvdev);
+	mutex_unlock(&migf->mvdev->state_mutex);
 	return ret ? ret : done;
 }
 
@@ -1191,25 +1191,6 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 	return ERR_PTR(-EINVAL);
 }
 
-/*
- * This function is called in all state_mutex unlock cases to
- * handle a 'deferred_reset' if exists.
- */
-void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev)
-{
-again:
-	spin_lock(&mvdev->reset_lock);
-	if (mvdev->deferred_reset) {
-		mvdev->deferred_reset = false;
-		spin_unlock(&mvdev->reset_lock);
-		mvdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
-		mlx5vf_disable_fds(mvdev, NULL);
-		goto again;
-	}
-	mutex_unlock(&mvdev->state_mutex);
-	spin_unlock(&mvdev->reset_lock);
-}
-
 static struct file *
 mlx5vf_pci_set_device_state(struct vfio_device *vdev,
 			    enum vfio_device_mig_state new_state)
@@ -1238,7 +1219,7 @@ mlx5vf_pci_set_device_state(struct vfio_device *vdev,
 			break;
 		}
 	}
-	mlx5vf_state_mutex_unlock(mvdev);
+	mutex_unlock(&mvdev->state_mutex);
 	return res;
 }
 
@@ -1256,7 +1237,7 @@ static int mlx5vf_pci_get_data_size(struct vfio_device *vdev,
 						    &total_size, 0);
 	if (!ret)
 		*stop_copy_length = total_size;
-	mlx5vf_state_mutex_unlock(mvdev);
+	mutex_unlock(&mvdev->state_mutex);
 	return ret;
 }
 
@@ -1268,32 +1249,22 @@ static int mlx5vf_pci_get_device_state(struct vfio_device *vdev,
 
 	mutex_lock(&mvdev->state_mutex);
 	*curr_state = mvdev->mig_state;
-	mlx5vf_state_mutex_unlock(mvdev);
+	mutex_unlock(&mvdev->state_mutex);
 	return 0;
 }
 
-static void mlx5vf_pci_aer_reset_done(struct pci_dev *pdev)
+static void mlx5vf_pci_reset_device_state(struct vfio_device *vdev)
 {
-	struct mlx5vf_pci_core_device *mvdev = mlx5vf_drvdata(pdev);
+	struct mlx5vf_pci_core_device *mvdev = container_of(
+		vdev, struct mlx5vf_pci_core_device, core_device.vdev);
 
 	if (!mvdev->migrate_cap)
 		return;
 
-	/*
-	 * As the higher VFIO layers are holding locks across reset and using
-	 * those same locks with the mm_lock we need to prevent ABBA deadlock
-	 * with the state_mutex and mm_lock.
-	 * In case the state_mutex was taken already we defer the cleanup work
-	 * to the unlock flow of the other running context.
-	 */
-	spin_lock(&mvdev->reset_lock);
-	mvdev->deferred_reset = true;
-	if (!mutex_trylock(&mvdev->state_mutex)) {
-		spin_unlock(&mvdev->reset_lock);
-		return;
-	}
-	spin_unlock(&mvdev->reset_lock);
-	mlx5vf_state_mutex_unlock(mvdev);
+	mutex_lock(&mvdev->state_mutex);
+	mvdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+	mlx5vf_disable_fds(mvdev, NULL);
+	mutex_unlock(&mvdev->state_mutex);
 }
 
 static int mlx5vf_pci_open_device(struct vfio_device *core_vdev)
@@ -1325,6 +1296,7 @@ static void mlx5vf_pci_close_device(struct vfio_device *core_vdev)
 static const struct vfio_migration_ops mlx5vf_pci_mig_ops = {
 	.migration_set_state = mlx5vf_pci_set_device_state,
 	.migration_get_state = mlx5vf_pci_get_device_state,
+	.migration_reset_state = mlx5vf_pci_reset_device_state,
 	.migration_get_data_size = mlx5vf_pci_get_data_size,
 };
 
@@ -1417,7 +1389,6 @@ static const struct pci_device_id mlx5vf_pci_table[] = {
 MODULE_DEVICE_TABLE(pci, mlx5vf_pci_table);
 
 static const struct pci_error_handlers mlx5vf_err_handlers = {
-	.reset_done = mlx5vf_pci_aer_reset_done,
 	.error_detected = vfio_pci_core_aer_err_detected,
 };
 
-- 
2.51.2


