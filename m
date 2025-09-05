Return-Path: <kvm+bounces-56894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 80C8DB45CBE
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 17:41:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 397611C8360E
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 15:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 685A2302143;
	Fri,  5 Sep 2025 15:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NenMDOR/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C48AB640;
	Fri,  5 Sep 2025 15:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757086907; cv=fail; b=AKkk6PwyQe01vVUmjpAVAooQk5tm8b9PJ+Mk4gvtFRQWW/mYeFUXA4XvAyPnGhnWBSuNUFo55oelP4GSae3x8WH6OCe6HO7l/vnvYVh+sK2uVvkcfkDFnnFs8Eqff73DH41kjpadU1gVI2Gi/oOv4HhctUdEL8VSp90g96wAgiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757086907; c=relaxed/simple;
	bh=oFKCLPMShFJb0f9CFVkqFvL3kkwHL7VY3I/yjWnqC94=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h3U0vi/7OqUx/DZYJsqzm/ju8KprP70tbjySvuIhbgjFBwYxqoxuIw2wsoiEpx3DpGjvS4LZZ9DwyjlRk5WsyJDhVKJqmTkx7BgReua3pcA+O5stXUga4Sg0bPiA2xN3kmuLfrtvqkplcHWQBLfY2fpp8kzZJlI3q/QbdHlkb5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NenMDOR/; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757086906; x=1788622906;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oFKCLPMShFJb0f9CFVkqFvL3kkwHL7VY3I/yjWnqC94=;
  b=NenMDOR/ewmqaDcHBhVXmB+WFU4bREiE3bZ9lZqTS0+nZzSZ1rTvRTFa
   xBTKNt2cHw/PNOgDdcvkrhzIqZmKLtz79aGoUzdNRsr9Fqq9ZzPTo2tbU
   muB+91Hn7jfoZQUoGRwezUxLXnmBiN2cgqipEyeQBDC7tvU3CGSCcFRU1
   U0MHNVhYaGb1TcD3rBgoZPFHIHvIae61dh0KjJiM98Z2/wvOhIF509Ui0
   K716/x5WF4tDfKvZoH02WHwunObxh16RKOCpolK83wEkEUn5tEnDfqwHd
   2Na7PxeTTjERDtDqphxpcrIJHoFEIEFpPhAXkEBOUsXJB99DBHv4wgp3B
   g==;
X-CSE-ConnectionGUID: t7d422i5QzakHrzPdawqCw==
X-CSE-MsgGUID: mkjsC+UdQtOZ0zW6PAR4aw==
X-IronPort-AV: E=McAfee;i="6800,10657,11544"; a="59583412"
X-IronPort-AV: E=Sophos;i="6.18,241,1751266800"; 
   d="scan'208";a="59583412"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 08:41:45 -0700
X-CSE-ConnectionGUID: rMCnzZXZRS+9DMt+ubrfAw==
X-CSE-MsgGUID: aGFLpM5yQwqtSWpRGsnCRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,241,1751266800"; 
   d="scan'208";a="172993564"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 08:41:45 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 08:41:44 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 5 Sep 2025 08:41:44 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.59)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 08:41:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KpWeQCdBlFythVXF/NL5mSoJs9Iwi+iMQObTyKQZXGrOeOQkJgY1rplpmZZHkhgEvDIJcz4Xujqj1pfkEuK9AOAt7WE6ZvwwmM77nzBPTbVU2cfexfWyZ6NhSGbY9qQJhVz2RdlufETwfOkomf0mZzLRGd32P+daNxlPLjUJtK3Z/U4RR6BG+ATrrRsj/w06BXcCCoYStA4EEIMxLQ1noLU1/kamFj9CBVVbrhRrrm+uJdwV14EDoY4tTmfoD5rPZVX2C/g05DR7xpubfo/SlLC/j8LtC1qCstYzBz6d2YumWB3TQ775t2O7QYddFuMOxLWqESz/T86qrM8l8Sd4+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oFKCLPMShFJb0f9CFVkqFvL3kkwHL7VY3I/yjWnqC94=;
 b=Wn4XpsD3cuM7gRqBHEuKKNTJZqhbwiYJtLpWnuXxE9VFCaPg2vF22FJjKWtdTzmdDtQ8d4NeYTZUK6ZF6+4ggLxmI9f4Sqsr1pfsciPROz0PLrcXjp4Gg5oWaxgZ1+yZJwP0y+HruPoQ10U33v26UB7M81BvHmxjsdqYo9JcPShjmh57SLWo35hJICs2jnAiLW+GdUUgd/zSPFwP0NWWgQHG3JF8i6yiOumUuS0mOEMbvvzXp2WVD95+z6qlzIej/0ZvS+Y6d72C8ybt2NhYTTFyl5mvqOkhtyPnwmepyU1oRcthTsvnPo4Wd9TobkkWq5IWX5I/+ZP8qNUNOWw/og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB6191.namprd11.prod.outlook.com (2603:10b6:8:ac::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Fri, 5 Sep
 2025 15:41:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9094.015; Fri, 5 Sep 2025
 15:41:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "zhiquan1.li@intel.com"
	<zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>, "Miao,
 Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v2 18/23] x86/virt/tdx: Do not perform cache flushes
 unless CLFLUSH_BEFORE_ALLOC is set
Thread-Topic: [RFC PATCH v2 18/23] x86/virt/tdx: Do not perform cache flushes
 unless CLFLUSH_BEFORE_ALLOC is set
Thread-Index: AQHcB4AWQr7scw9VN0WSW4Z+hOwkSbSE6CQA
Date: Fri, 5 Sep 2025 15:41:41 +0000
Message-ID: <b247407ec52d96a7fdec656c5e690297d4facde6.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094516.4705-1-yan.y.zhao@intel.com>
In-Reply-To: <20250807094516.4705-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB6191:EE_
x-ms-office365-filtering-correlation-id: 624e8388-9982-4d0b-cb4f-08ddec92b611
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RTExRkhzZXJ6YXNadHltejlxaThta2Z4MHYxMmllSUhrdTdqUGo0dzY5WUE3?=
 =?utf-8?B?VW40WUhVSzJxc0N4K1JlNmxaczQyYVBTUVFwSitYRThVQVBsM2dDTVVNTHF6?=
 =?utf-8?B?RHVNdkYxVlphSDlrdEljMUhwQUE2Vmlqb3diaFJQdC9CQmhLV0tEUm9BeHFr?=
 =?utf-8?B?Unkyb0J2cUczcWIxZzdUYjYrZ0VzNmlOY1pPK0ZEZmxJNkcrYVFQNHIxNjJM?=
 =?utf-8?B?UGV3dDR4ZEJOZEdXRlYycVUrVXBsUjlrTnF5cW5rZjVpSzFaR1J6WXlqck9F?=
 =?utf-8?B?WWNYU0h4bFRTdlRVQXZGT3BNRzIwOTBoc21EdE93SU1uSVFTRXNpdFZ0Zk9R?=
 =?utf-8?B?d1lKQkdodGpocGxwS21DU3JZdlVRNXJYcEd0NGxCVWpFS2VXeGxxeDM5Mjd0?=
 =?utf-8?B?WnBOajdXa0trd09pczZ0OWpSaG1GZnlRR3NybWk2RjlBdnJqOVJnMnJJMk11?=
 =?utf-8?B?WHhKQ21QRDh2Q3hWUFgvZnlySFVpU3hHTDJqL2JEV0tLa2lNeTF1TVZ4Smda?=
 =?utf-8?B?M0VuSmNBQmhOd05scmxQK2ZwbjVuekdzTzdRQVpPeUo4cVJPWHdhbkJEWjRN?=
 =?utf-8?B?SVVZZjBaR2pNcXFoZ1FrSU9XWWVpRmFsbkdtT1ZtYkloTFB1a0ZkZGJhNk5D?=
 =?utf-8?B?WXk4YVJIQUlEVko4RDFuYmx4WjJNa0lMSTMvaks0bExGaE1ZZ3M2bHVHZE5C?=
 =?utf-8?B?MmJMd0k2MjVWeHp3QTdIRnI3cWdZZVNUajNNV09ONGdqaGtiQWcrdUdrMDlT?=
 =?utf-8?B?cGF3QXpVNFJ1d0NNZWM0YXlrVEYyZy9oM01KeWZnK0hCMkdCRXdBZXZZdmxQ?=
 =?utf-8?B?NDZhMTlkR1E4YjF1RWZnVnk2eVlSaWNKL3FuTHRleGR4NnhXNTVUOFU2Sml0?=
 =?utf-8?B?NXk0dkp6UlNndXVaL0tUU0JuZ1ZyK3BJcjVNL1lQTi9nMWR4dkc3QjF3VkJm?=
 =?utf-8?B?NGx2L1R1OU9OTnk3ZjNVNUVMNXJzNjR4L25TSkEzS3RpU1RIOHFUaG94RmNR?=
 =?utf-8?B?d21yV2phNS9WbDZIcVRTQWpMZkNlaWlGQ1FBckhyZG1tdlY4eG4wRUw3NUZr?=
 =?utf-8?B?Sk02ZU4rZ3RwSG4rQnlocTBiNURjY1FSb2E5ZXQ4cDhJOFVETjg2NFZEb0Vj?=
 =?utf-8?B?TnFuNzViMFFjejZuaHN5N1QrYkhNY3RROVUrczNid1B3UkRUcWViaE1YdlFX?=
 =?utf-8?B?SzUwTnk1SC9NdUJsRHg3UWhPSmVZUnJUQXpqb213OFVpbHRXaFN0YUxRaDBC?=
 =?utf-8?B?eGMzYkVodVlMbS9jWEMrd0VLcEhwYXhubTRYM2lqRmZlbjhjTUlzbFgzbFB3?=
 =?utf-8?B?bFZ2eHBHdU5qTk1BNnRuQkZ1Qld3MU55UHE4bU5PZWgxeEhhY1dnTG9MZUgz?=
 =?utf-8?B?djhOMXlKYkM0MmNpNTNTVnB5WDlBclQwd2NMYjlkeEdxSzdOQ2Y5cEVqUGZY?=
 =?utf-8?B?cElkZnRnbXJrTlBCT1E5NjB2MUk4SlZpU3ZsVDJrbk9kTGxtMVpOcDI2UU1T?=
 =?utf-8?B?Q3VOcnNaSUVPdHVsdmEwUzBXb0RGRTIvVENsd0R0cHhkY3gwcllsaFJKdFp2?=
 =?utf-8?B?SW10Y2RuV2RwY01aWUFFeFFMTzVVRzdpM2FlMG9nZmxIZ0ExV3lhczIrZ1lY?=
 =?utf-8?B?L1VIb21jRzhhSkw0SVl1WU9qa0ZodVZ3VGNyWmRVNVp5MThjRGVIYmhtUkUw?=
 =?utf-8?B?bkFZYlhETjNNb2NBNU9GS1pacEJhNjYvUWlaTGwvemE3cWJ0QUNZVWY0Z0JQ?=
 =?utf-8?B?NS9NMEVkdHd6Zm1KampQR1phOHErcFM0L2kwdkdMS1JmcWl3SXBrT3cvRWVS?=
 =?utf-8?B?YnV0V1psWm9xN3ltdTQvdmlRT3RTd0JuZWVkRUhwekQvcHNMV0ZaVDRsUjlk?=
 =?utf-8?B?Z3JJUHZ5aXZFYkxpdG5ZRUJaZzFoNFowcCtLYXlBUmcwRDZsdGZ0Zm41Y0Zy?=
 =?utf-8?B?M0h2bjN5bzR5TVZZUFFib09uRWxGUDMxQlJaY0xJd3BQSUFYWTFsT2tVZjFm?=
 =?utf-8?B?TlZZaDdadlB3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0tpNjlPQy81YTRjdjBjMzRra0QyYkkxS0RKSkpZcXRoU0JwbjdpMmovRncy?=
 =?utf-8?B?UHQ2bU1va0xuSERDd0ZTZkd6bk9GVGs1bjNkRFovUUFMblhEbk15RW0yc1BS?=
 =?utf-8?B?cUtxVTltb3BUZzFab0grZFdSdWpnc0xhZHdqODRBVTdoMWd2OFZRTnoxc3V0?=
 =?utf-8?B?WGtLT3c5eHlrOTBuMkIxblpyc0dONHo2eEoyaTBTZzhCL0tDRnB0c0ZXdDhP?=
 =?utf-8?B?REVYRmZuNjRPYVFUNjBzU2l0OGpVWC96RFk5WEdJVkgrODZtUC9wYUQzKzRH?=
 =?utf-8?B?OW56eDFQYlg3OHZvSzZDakVaSEJIVUpFVnQ3a1VNOVBRNVdnZzZtSDFNKzlP?=
 =?utf-8?B?bjlPVHFXU2ZhNFRaeCtYZWxSb0I1VFd0TVg0ZzdwVmUvYi9meWh6dWZIRk9q?=
 =?utf-8?B?eUxmbDhFRFhmVkFNRE9CYWxETGJlNFpSRGYrMW5IbGxkQTI5YkRsejZ3bUZF?=
 =?utf-8?B?dVZndjloMDlxeDNHSzJueUZ0SFUwcTRiUG9WdUQ4clNaaDNCK0tYVWFBcDQr?=
 =?utf-8?B?RzhnN29GaEJRR09WQ1N3ZG1KY3QyNllDaWVTbEhUYTVxQnlyUG9Gb0MzUC8z?=
 =?utf-8?B?UTBMSUxEZG5nYkVZL09MYUk5Zi83RTZrZzF5Y1dCYUpOZFRLcXFYQ3MydjZN?=
 =?utf-8?B?dmdnS2NmVjFWNVErc09iQm9iNjN6NWlPSm5ZbGgvQUlqWkFjZHNFbUhyTDRn?=
 =?utf-8?B?TktZcmtCNDZTM2RyNnMwblhUS3ZvMG1YNnExd0o3VXIvbS9yby96MnFEaXFH?=
 =?utf-8?B?Rm1nQkxXcjBvNTQ3dUJkbTY2LzlJdTJaeENuTE05TGRpaEJ1UEVKYnpCS0lZ?=
 =?utf-8?B?QnVzclB6MHVHR3JuSFlYTm91cXhSOFlCNHVVd0ZEblVSekYxRTFKUmUvRVdY?=
 =?utf-8?B?aklpcE00SFRKaUhNWjE2UDdUZ3Q5SnJraHY0QjF3SlJUeUFYaVZQdUQ3Witx?=
 =?utf-8?B?dys1NzR1OHdIZUtzWDRWSFQ0RjVaZSt0elVlMnFDQjNaNVVoYkhvNzdWdmdY?=
 =?utf-8?B?TU9NdW5vMTNBWll3TWpWTGRETjEvZnhuMlM1RWJWWHdsSzJIRXBLTnlIbml4?=
 =?utf-8?B?bWhBMmdRWHZWUHhva2l4VDJpWnROcHpsWlhEaCtKMGg3U3YzNHNBVEF1U1Ns?=
 =?utf-8?B?THJyeldYblQ4RksvOGxTV0tkNjRNd2N3TDNpaXpUajVlN3NiWGJjQkhOVWU3?=
 =?utf-8?B?T3IvTUdYZnIrYTh6bkNldmVrdW1ZUnI5NzRFWWF4NGF4a1J6UHRoYnFSVHYw?=
 =?utf-8?B?R2YvU3ZkMjRsaVBxMGlIQmVkUzQ3WjlYdUxKU0wwZ01YeWNqL1BXb2RNbGpJ?=
 =?utf-8?B?elFZTHBIN09VK3YrVFVZR1RtL3E1WjVxUjl4ZGRGWkdHUjJWRW1oRjZRMUhX?=
 =?utf-8?B?NGllckd2MDNQbFFlMktuMnlhZjFZNUJoNU9iVm43TTNORERjeVhaNHp0UlY3?=
 =?utf-8?B?N2xUZHFualdGSnZFVExaRHVEaFh4a1hGelA0VU91T09jV2kwVUtQUi9ybit5?=
 =?utf-8?B?QnRFTk5VYjBJalhRaHN5THVwaDBhbWZMZzVNa2NNTnl4L1BiZmoyU2xTdzBm?=
 =?utf-8?B?aVdNTUR4Q2t3NnFCVy8zbEJyRmc5RUJrK3ZDR3lGL2tEMkdLbVhKUWYvdng0?=
 =?utf-8?B?VkpHZE53VjV4YnNjbStQbWlMenNDMGFVTkNaSFh1eFB5ZVNHVnA0U3ZKRXpZ?=
 =?utf-8?B?b09TeEt3cnNDbWFCc2NIRENRN0FQejlQelM1WCtWUzJETlRLbmpkdjBHZWYv?=
 =?utf-8?B?Nkg3M25yeHBYMGpNVjEybHM1VDhZSk0wUzlYb0VicjBwRzdjUzVidjVBeThC?=
 =?utf-8?B?RkQwbmE0QTl4aDYreGx0MDRTK1FqYlBCeFhSSkVMdUk3NEdyaWJWMXdLcGlk?=
 =?utf-8?B?ZWlBaVI1Y1JHVDh2V1Fldmp2WGZyUWFKVmpjdlZ2eGFtS2NZNEJ0UkRSVDl0?=
 =?utf-8?B?VS9FdXlNTzR3RWR0K3lYcEJDdVBTQmJJRGd4L2ZLRjAxMEc3eCs2alA0VlhL?=
 =?utf-8?B?NjJHMmRXZ3JpVVcwdXBseHg1VTgvcGhDSE05NWR5cVBvTWNsdm0vU0NJQ0xa?=
 =?utf-8?B?NFhHQ0Q4RjliZ0N1eDAzcHhwdnp3T29Pbyt6LzZ0eVQ2a2QwdkR6U1ZnOEMw?=
 =?utf-8?B?c0taTndxOHJaNzMvdk51ZGNnSVloZFAyY1AvY3ZDMTl5WVdvMVNOeE9sZ3Fq?=
 =?utf-8?Q?PYOcvgNRlALK8W8dOIWmZIU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1928B83B667DCA458CA811F5F6B7975C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 624e8388-9982-4d0b-cb4f-08ddec92b611
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2025 15:41:42.0234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TEyiSFW2qnyAVMLjEWIpIVzozmIATy9+psLq2MPmIZPFwG/RnsPo7BGf6qohdyYeCvhGYW0AukVBN4A5dkAC/iqt3+ZYRAG6HMUBJxwdMU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6191
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTA3IGF0IDE3OjQ1ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gRnJv
bTogIktpcmlsbCBBLiBTaHV0ZW1vdiIgPGtpcmlsbC5zaHV0ZW1vdkBsaW51eC5pbnRlbC5jb20+
DQo+IA0KPiBUaGUgVERYIG1vZHVsZSBlbnVtZXJhdGVzIHdpdGggYSBURFhfRkVBVFVSRVMwIGJp
dCBpZiBhbiBleHBsaWNpdCBjYWNoZQ0KPiBmbHVzaCBpcyBuZWNlc3Nhcnkgd2hlbiBzd2l0Y2hp
bmcgS2V5SUQgZm9yIGEgcGFnZSwgbGlrZSBiZWZvcmUNCj4gaGFuZGluZyB0aGUgcGFnZSBvdmVy
IHRvIGEgVEQuDQo+IA0KPiBDdXJyZW50bHksIG5vbmUgb2YgdGhlIFREWC1jYXBhYmxlIHBsYXRm
b3JtcyBoYXZlIHRoaXMgYml0IGVuYWJsZWQuDQo+IA0KPiBNb3Jlb3ZlciwgY2FjaGUgZmx1c2hp
bmcgd2l0aCBUREguUEhZTUVNLlBBR0UuV0JJTlZEIGZhaWxzIGlmDQo+IER5bmFtaWMgUEFNVCBp
cyBhY3RpdmUgYW5kIHRoZSB0YXJnZXQgcGFnZSBpcyBub3QgNGsuIFRoZSBTRUFNQ0FMTCBvbmx5
DQo+IHN1cHBvcnRzIDRrIHBhZ2VzIGFuZCB3aWxsIGZhaWwgaWYgdGhlcmUgaXMgbm8gUEFNVF80
SyBmb3IgdGhlIEhQQS4NCj4gDQo+IEF2b2lkIHBlcmZvcm1pbmcgdGhlc2UgY2FjaGUgZmx1c2hl
cyB1bmxlc3MgdGhlIENMRkxVU0hfQkVGT1JFX0FMTE9DIGJpdA0KPiBvZiBURFhfRkVBVFVSRVMw
IGlzIHNldC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEtpcmlsbCBBLiBTaHV0ZW1vdiA8a2lyaWxs
LnNodXRlbW92QGxpbnV4LmludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWWFuIFpoYW8gPHlh
bi55LnpoYW9AaW50ZWwuY29tPg0KDQpJIHRoaW5rIEkgbWVudGlvbmVkIHRoaXMgb24gc29tZSB2
ZXJzaW9uIG9mIHRoaXMgcGF0Y2ggYWxyZWFkeSwgYnV0IGR1cmluZyB0aGUNCmJhc2Ugc2VyaWVz
IHdlIGRlY2lkZWQgdG8gYXNzdW1lIENMRkxVU0hfQkVGT1JFX0FMTE9DIHdhcyBhbHdheXMgc2V0
IGZvcg0Kc2ltcGxpY2l0eS4gTGV0J3MgdHJ5IHRvIGJlIGNvbnNpc3RlbnQuDQoNCldoeSBwcmVw
YXJlIGZvciBzb21lIGZ1dHVyZSBURFggbW9kdWxlIHRoYXQgc2V0cyBDTEZMVVNIX0JFRk9SRV9B
TExPQyAqYW5kKiBhZGRzDQpuZXcgc3VwcG9ydCBmb3IgYXQgbGFyZ2VyIHBhZ2Ugc2l6ZXMgVERI
LlBIWU1FTS5QQUdFLldCSU5WRD8gSXQgYWxtb3N0IHNlZW1zDQpsaWtlIHRoaXMgaXMgd29ya2lu
ZyBhcm91bmQgYSBidWcuDQo=

