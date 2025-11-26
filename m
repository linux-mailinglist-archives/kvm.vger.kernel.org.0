Return-Path: <kvm+bounces-64776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3231AC8C4DD
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 00:15:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id ABB8034FF64
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D172308F1A;
	Wed, 26 Nov 2025 23:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JyLJylvt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E04278E53;
	Wed, 26 Nov 2025 23:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764198919; cv=fail; b=PtSAQb7sRbtYbp0/ghEcWM+/JeVdRBN1RACRqK5xQAldU6C/eDz9MZF9SZ8aKRoW1Ab6717737oursc+CzSmbCg/k5Fd8c8fDBhW6fZ8kR/3dPxUe9Cchf01buNSAgR6AJ7IXRBOJeLjoA93bTL82A+WrzL61hTdJuM5ISOnkLQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764198919; c=relaxed/simple;
	bh=ZrMZ9SJfhLpANeEy6nqhyiKqGeKcYig6djU7V8Q+JqE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=occnjmOwynZlPq8Sa9mhQg0DDg0u09Hlp0KgGVCz1eFIY5UtYRDgwhEBohULMCLI+OCgx/Kp4eCTPDbbsaxQtgKznX4vi3wA3jL9skH2FLfoJcScThUDuYXSgip+y9WmI/5zdxR+8VO8Ljsff1py/m5p9qW66VYioLRjMEB/gfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JyLJylvt; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764198918; x=1795734918;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZrMZ9SJfhLpANeEy6nqhyiKqGeKcYig6djU7V8Q+JqE=;
  b=JyLJylvt9GgTMBb4JMW0OIxn3mTHSJgj7n4kPHswkMOFKeCz3p8mNsTj
   yjND7HfXhlSaO8cLEJ/n1p4+JDTfKdZmjybAm/Eqeg+aJhHx/MRYYYKO9
   cbkEfJc41zLxSYP5RfF1T4Jxh2B+ra35f5Qgp3VO0xDgoEAFbQATZJQM/
   wwwle+Jx2thUSgx++ss88gYqwpXefeCJLMy4MRTsb5YYKYSX+aLPM89m6
   oBJ1BnnWvooffUN6H9tQPvkgf5eoePJ5l57vIub36ifES6qGh6fjSKKzo
   +bIFPSzsGX/I5fKDuyv7F3yXoDycPTLkdEkM2sdRSez6E7wRgseRxoyYP
   w==;
X-CSE-ConnectionGUID: MPhEpjQhQ0GyMxWONcdbqw==
X-CSE-MsgGUID: BjYKKqrKQCu05ELswetUfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="66137937"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="66137937"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 15:15:17 -0800
X-CSE-ConnectionGUID: G9xXC/4tTeSxCLjvRMloHQ==
X-CSE-MsgGUID: SHum1aLSQgSDQsfL05EFZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="198189584"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 15:15:16 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 15:15:16 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 26 Nov 2025 15:15:16 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.17) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 15:15:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PNd6Ml+VgMUpxXxvkhZcJPjut8qimxXQmzQ3+Xhp7Es616x3sUyHBrHr+J0tiBdpr6Of/hHRK7cBvpPozEKoVM/BMehkqM5NHK3CYyRy8DWk9V0VIfzcyJr7+ZR7KJmN+68+Y1M9nckQos0XvMuHOb8+Nwj9+cDvZL5ciX9e9ps955g2oqYoSmDaMILrvZ2+HEVmSV0K0TXD3sVVAL8+WuP0lTVyuEzjLFtGmXsti3Uyk4p7CQpiLpslorNtQwkWH7MXiia8f6DMGZTK+5jaeUDQAFMwYEJ7vOe0orRuNzFUf8+A+5f8xva7LXnRvhR27caMgXkWiOr4oN+GVgQJcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZrMZ9SJfhLpANeEy6nqhyiKqGeKcYig6djU7V8Q+JqE=;
 b=fAnmYJ2Y9dR+knwtR8nGZxMmyhnAv16rhQ+IgOGEiu44vLoyyg9pLuRec3pohca2fpXUi+tXzZxFoJPMuI017nQsF+BSgHxwamcXLZsjCnzLYIGubU19Wce8cimwZj98FIENOjR2dVBrwQ0tOxvvJfBQEmCMVtuAu5QNWcT2grQS1QvlLzQ4EKDUTmA2GVDgUqOB7yhwfrmG2KLIaQfVtWknIyMBGRWW1GS+AtcmOGSa/1CEom7euJlLuu0UpDh2nEkYjLIe/OKyzpOjS+mO+mR7ac9qzvaGpWlC+nf7A7MWc3tLSNo3ZE5pcB/H2Xj96maBFT4yiVpsBrT5AgKj5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB8522.namprd11.prod.outlook.com (2603:10b6:806:3b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.13; Wed, 26 Nov
 2025 23:15:13 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 23:15:13 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v4 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Topic: [PATCH v4 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Index: AQHcWoEIto+2L4vuwUu4TSstnaj7zrUEARkAgAAD6QCAAZsDAA==
Date: Wed, 26 Nov 2025 23:15:12 +0000
Message-ID: <0072213d499f3921c7df662bb10f29409ad9832d.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-2-rick.p.edgecombe@intel.com>
	 <6968dcb446fb857b3f254030e487d889b464d7ce.camel@intel.com>
	 <af7c8f3ec86688709cce550a2fc17110e3fd12b7.camel@intel.com>
In-Reply-To: <af7c8f3ec86688709cce550a2fc17110e3fd12b7.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB8522:EE_
x-ms-office365-filtering-correlation-id: 3f8cff6f-9491-4a31-756a-08de2d41a6eb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cjJMcnFKbkxIUjhxbCtsVzFDbUhKbnJISGtOVlpEaFI0M2hyQytST1NpWUdT?=
 =?utf-8?B?TTgzMC9QSEpYVnR5MFdLeGpMSkpvT0R2NVJZenBvY3gzQ1hzNFdsMmJaaDJk?=
 =?utf-8?B?ZndhN2dmczd5S1FvVFVsdTZrVThubEsyQUV4a1lZUXN3Z1dEMzdFbVF2YkE1?=
 =?utf-8?B?YUZmOGo1dFo0NXdNemJ3QWN5a1RCSTEwNC9HR2lhZ3U3Uk9hYzRIa1ZIY3Iw?=
 =?utf-8?B?L0ZxczVGSlVOeVZka2VyR0VyTGpPN3JPRDBqZjliVnZ1NXJ0OWFtMVIrMTNI?=
 =?utf-8?B?cStvcXdZVnNhYkhGVzhCS1RqVEE2ZVZjcXViWUlNN3V6dERSR2M4bE55a21N?=
 =?utf-8?B?bDZ1TC93d2wyUVJCYmVrSHI0SnFmdWlpK1Q5Z1hmRmI4dld1RzFnVU5jQ3JE?=
 =?utf-8?B?R3NxQXJjQ0dHUnd0ckNIK0J0ckpwYVU3WTlPRnY5alFRQkRxUnlJcTJkeXBq?=
 =?utf-8?B?WXY1bGxuVGY0SFp5MDd3S3RIbmJ0VFF2VEE0SUFRd0VTaHRZM3BuenVXdVBv?=
 =?utf-8?B?NUxqTHJWMkhzd2xzV0tnQmxOei8xaFh5QzNpODFSZnZsSnpITDNlR1lNdUNY?=
 =?utf-8?B?a1hSZENRY1hSRThCaEVNNysxRFJsUGVDb2xhVUo5NHBzczRIdDZIYlM3cExw?=
 =?utf-8?B?VUM3WEoxNVZnZ3QwaDVadmt0eVlYT1Q0VCtNYy9XakUxZmZGMUpLQnZkTGJw?=
 =?utf-8?B?YnRCeXVWZTJ3K1pHTU95OG5xQ2RSS0VseFZkMVNKb0d6a3FVRTd0WXp0VXVG?=
 =?utf-8?B?eDUvbkp0TWZjcnpma2xtSXRjTHkrbWlGcHFSUFVxMVVQaXkwU0FPNjV0Y1BR?=
 =?utf-8?B?SFNJVHh0LzNNUXVPUkw3Y3NnUGx0Rkh3U3NvSis3SVFveitSMCtyaVd0bTJY?=
 =?utf-8?B?TmRwSHNvQUk2OTB5SXBhcy9kQ01ML21jZ1dTU3owa09iNGMvZ2ZxS3FpanBZ?=
 =?utf-8?B?Z1V4YytaWVpRejZ1QUUyWDlaMHdwL2VOR0x2N3pCUVM2R0E2THVKTzRMcitO?=
 =?utf-8?B?bytRR0p1Y09MN2ZWbHptR1BBTFFnOTYwYmZNUXNtUlkzYTA2elFydmJEMFJ0?=
 =?utf-8?B?YzNxZDNzcXAzQ1BkK215OTBzREc3bWJiMDQxWUh1K0VTOS82L0J3V2ZiTldy?=
 =?utf-8?B?VG9PYnZJb01aSlBZZERiQ3JReXMwVm1oLzBNQ3pFR3JBRzlYOTlza0l6Qk8w?=
 =?utf-8?B?NitHOWdnbUpTSWErZzlsUXRyZEpNeG9ia2VBSFZiQ2w4NWRmQzZVNDVTV1Uv?=
 =?utf-8?B?NnF6VTFPZTAveXR2cWpYVWFZUG1TbjNUWVhGNzJ3bElIdE5mZEg2b1FFZElG?=
 =?utf-8?B?QVFyZXROUW84WFJpQ3NoOEt6ZjZuaDgxSXpBaS9ab05pT3JVU3ozeXVNdFBJ?=
 =?utf-8?B?MmxmTGwxNm1Hb2wwMTc0YlVxWmN6a2pwejBONWEvTkxRcURCaytkVmNma0Qz?=
 =?utf-8?B?MFhvR0FsSlF4aVdJV1VxcG5ONjhod3RmVGdsbkZkQnJSUVNmZlNpVS9jTnJV?=
 =?utf-8?B?RDBTb1VCMjZYMGRPUUpaR01FNGplODhSZTFuOVFuam1YNW1keUdiTE5oVzZz?=
 =?utf-8?B?UmpQbzZlYzhMcG8xTVh6dmJsYVJ1RCtRbXMzQWVmVnFNY0lTWGhmMWtsMDlO?=
 =?utf-8?B?VjVpSmU5cXU4UzhoNzI4NnhyYnRzbTNFb0Uxc3hRUEkycXo5R2szanhUdktU?=
 =?utf-8?B?Q1RDRVVlT3ZWMDI2MjB4aTJQTHh1ZU1pK0JtWm1EMDRxM2lEZzlIOW5KWFlJ?=
 =?utf-8?B?STlkVlRtcHpraUJITWxBYmlxYUVWbkt2ZU1nSDQrY2ljUGNBSlN5b1BFZ3Bh?=
 =?utf-8?B?SmgzcUVQMjNWbGk1TjRQM2ZOUkMwREJFSXI3bjZPckNvaGxxZi9RQTJNR2dP?=
 =?utf-8?B?NVVCZnNQeGt2U3pIS1VqdW9OMzBRalk3VUdSTThnU0xoemJCOTZwc0didlYv?=
 =?utf-8?B?YStQZjI0b3Iyek53Nzd4MUJGYStSOUt6Y3k5TFU0OE9ZdmZOVHN5THpaRjJP?=
 =?utf-8?B?UVRBbmEySTlxRzJLayt6NThXOWZQc2pQNG9LVmZBMGFwUTRwWlgvYmdnOWt2?=
 =?utf-8?B?bTZzNXhkWTByVHIvM3RZRzM2V0hiWGxKRSszQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXNOSklNblVVRGFYbHJZWTUwNlNNdjhXQ2s3WEZyc1lrNkRnaTFjTy9nY2p6?=
 =?utf-8?B?MWk1aStBWGV5cDhReHV5Qk9SVU1CQTc0czUyTXoyMWNBQm5CckI2MHoxMU1u?=
 =?utf-8?B?MnZqYzVYYXQrZlpEdmVGMnE1NVdtdC8wVW9rUkNBYmFtZE8yc3c4alZ3VFRk?=
 =?utf-8?B?TzdUcENXMDZBZzJpOXVzbVhFcHlrOHJlbCt6U1E1Z09rZmFzUnJrOU9SbUcv?=
 =?utf-8?B?S0FuTEVwaExKYWJ1RVhCbVpkcVRKbDFrQk1rZG1CMUYrNnhGajhlejZSc2Yy?=
 =?utf-8?B?YlJiTjM4RUo2M0xQVEZvRkJqemlMTVhTYjRvVWN2UkcwSTNCT0U4YjlqNk1N?=
 =?utf-8?B?Tzl2cUtlUDY2UzJXQUw5dU9YdE5uM0RCaFlZYVVURksrQmRYdzlFWFJPVytx?=
 =?utf-8?B?WUdsVDBPYlpmWkVjRE91cXh2YWtGeUpONFR2Y0FGTVRMOWYxcW5hblpFRDNB?=
 =?utf-8?B?OGE2VGF6c0E1c2NkaTQ3cTR2bGN1b1pJOW9WbUlpdHVCNGxmOWh4R2p4d3FM?=
 =?utf-8?B?S3JORkZDbzBVS3VVc2xLcENBTng0WEg3U0NCbGxEN3dDOWkybUdONVNKNzhV?=
 =?utf-8?B?czVMRmhQVUN5MDBUQ0lqdTJvWnJ6UlN3djE5djhuZ0hheHh3UVRLdE1MSldG?=
 =?utf-8?B?WHB4bWN6SlgzaDgyOWVNVTZrTFlxZk5XdFVlTWVpUC9BcFpyY3pxYnJ3Z3kz?=
 =?utf-8?B?M2J4a0toM3BjckpWSm5yQTlodDAyelNZdDY2OWlzWTJ0Zy95Mm9GUUZBTndT?=
 =?utf-8?B?VTlKVUtGZmpsSGpZVndMUUpRZ1dDVUNVaU5WNnVxUnVUVUZ2TlVKSDBGVndN?=
 =?utf-8?B?U3lOdDhWZnRGaWs5TnhSb0NISFhROG5md0xkR01QUUdLeXZWcGtrOGp1K1Ux?=
 =?utf-8?B?cGVNMzMvRkFMNmFVRlJnVks4dGtkdW9vNHZUMjE5ZTVRMU9HVDIramdPdTJX?=
 =?utf-8?B?VVpCbmFtenJuM2VBN1FCOHZHTjMwazVOaVI0dGFaeDFkYnVSc3dValJEWCtO?=
 =?utf-8?B?cnRobGN2b0V0YlhCRng3YUd3czZTU1NTTUNyUmU5bHVUamxWRVlWb0cyRHZn?=
 =?utf-8?B?ZHlOWFhFc0U3ZlZvODRobzQ0ajdVblY0a0xPbmwxUlc0ZVVCME5HWTdqcmdW?=
 =?utf-8?B?RWhmS2dJNUt3U1BxbUY1NjBKaDUzbWRtRlBrcTNLblRQcExEcmZMMXZZZHRU?=
 =?utf-8?B?a3pVdDN3bW1uM0tLVTBYTTlJOUdoWUs4bTZoMXRiNHJmenRjUnNPb21IWEZQ?=
 =?utf-8?B?Zkh6NWtmR1dpU1FvWlFMbDVaWEU3RjRncVlwK2NWRXZ6VkN3T2xYUm1UcXFy?=
 =?utf-8?B?ZjRKVXRYTEV6ZFhDb0FOeFZnbUdONU5sMnpFMWtUc0YxbkxJZ1JUZm52N2w3?=
 =?utf-8?B?Z1hvN0dHWmx6eVpKeTdweitYTU5GUXJzdU1CNFhBZit6S2V5SThrYmRBREZk?=
 =?utf-8?B?U2RsTXY1d3l2TS9BN1lKSWNaZmlEaFNEaDAvcDdaVjlCa1g3akJBNjF6RFRQ?=
 =?utf-8?B?Vk5laHFqbHhaOFJVUTd3L0NOK0hYbHRXYWJKbmhzbHVnRHIvQVZlTDRFeW9O?=
 =?utf-8?B?ZkN3ek1mMk41VlFVQkNxTUZmOVRvcGdvRW1Ed0NaaWtOcjJqcU1WWi9jNXI2?=
 =?utf-8?B?bGp2L21IaTFMaE0yVjNtUk40UHg3VnZJYXRjSEU3Lys5bmNza2xqcW9IMmpK?=
 =?utf-8?B?RGVkeVE1b3ZKOFZaQWJLNTF1c2lreHppRVNXMVhVV2VzbEpSVkdnNEhRaHZI?=
 =?utf-8?B?OTFSTFpNWGhRMHQrQlVYK3MwRHZ4RlhJTWtlMGRrVGRBTzdGVUo3ZnVJYmlh?=
 =?utf-8?B?aW9XajJvYmVpMmVGVXZRQXRZbkxVTUc3REQ0Zjk2c0E0ZlVUSm9OUGd5Znky?=
 =?utf-8?B?alBwNmdpczlraWlaa2V6QzlyWmgrYzZhMW5BM0ZMTFBUaEs0NkN0dDVaN3FE?=
 =?utf-8?B?MStFM014TnoxM1M1cWpPNmxsMEY2UzBrK2JsUUVxUTZZc05tTU0yaUovdnNm?=
 =?utf-8?B?WnFrcElYa3BxbFlOaG8zL0ZpdjFPcHYrTDZqVit2NDlDRWFHcWt6OERWWDh5?=
 =?utf-8?B?VUR3elR1cTdBclNOUGI5THFLeHRyY0lpMXVsWFFTYUxQMVNjUTk3VitwK1Bh?=
 =?utf-8?B?WTVqV0lwZnRUYkpQWHZQKzNBdHArR1VkRWhpdVN1Y1RVeDZPM29CbTNRYTVP?=
 =?utf-8?B?aFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1AC453678D458E4286C9BEA9682C66EF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f8cff6f-9491-4a31-756a-08de2d41a6eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 23:15:12.9471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JZEXIZnCsDLSW4z3F4OAMQnawMdrV8RmxoE8CAZgEyiAqUmScZrnCYAw/U5+lX+9fKR8SXY5oSVIpe1si2jEb2RQrGWRZd6LXsWUbPYjyrY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8522
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTExLTI1IGF0IDIyOjQ0ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBB
bHNvIGZvcmdvdCB0byBzYXksIEFGQUlDVCB0aGVzZSBlcnJvciBjb2RlcyB3aWxsIGFsc28gYmUg
dXNlZCBieSBURFggZ3Vlc3QsDQo+IHRoZXJlZm9yZSB5b3UgbWlnaHQgd2FudCB0byBkcm9wIHRo
ZSAiU0VBTUNBTEwiIHBhcnQgZnJvbSB0aGUgc3RhdHVzIGNvZGVzLg0KDQpPaCwgeWVzLiBUaGF0
IGNvbW1lbnQgdHdlYWsgaXMgYWN0dWFsbHkgcmVsZXZlbnQgdG8gdGhpcyBwYXRjaC4NCg==

