Return-Path: <kvm+bounces-38106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC52FA35361
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 02:01:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DAFB23ABEDF
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 01:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DFA376C61;
	Fri, 14 Feb 2025 01:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G8eKVm5f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2B07346D;
	Fri, 14 Feb 2025 01:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739494881; cv=fail; b=tzzonkiqXV9ymmtGTD8CWQ+EatQxnPDtESowu/z597bJX5kUXbc4NGa0lMoIfOnz8esTONnGli92pEmOFt273tEEtBSLsaLAzb2fwi3WghwH5tZEP6DAyVsd3+xty8EWkFON3ih3vVH/wzqKaK7q8fnOctMNnctH9c53qstL0xI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739494881; c=relaxed/simple;
	bh=DeMS7SluieBfYdAXg4ZS9dEbvZD7/gh1uVPrwupr4T0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uOXvhlGRxtxsiQv9jg/xTuPfo7iaG2cnT0LBPZ+zV3t2+CdD1/hiCNL9emaKWycOID0kM5mTVAbSw3ucM+8dSDdJXa4lSYMxKI+0tv3Q/R9ncAwAqmq+K9MnwIBGs+4XcP/wqfU7CjZpgcf9rLhcsUrw8xhffvbdY9WxmtKyxIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G8eKVm5f; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739494880; x=1771030880;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DeMS7SluieBfYdAXg4ZS9dEbvZD7/gh1uVPrwupr4T0=;
  b=G8eKVm5fH8zzJZ0cNeUWpKC3xX3sU49uPH67PSiDA07EWPV/Bf4ryOwj
   GW8CitQlrGs4B8IMQI7NaZn+ynMMS3KSV7BLha1bioygOve2YLJaGxUdd
   c5Tz/T52fk3nTlfZ03hONjy37iemHm1ldxaW0BMRcZBLQo8ffKP+RuL1n
   Cbk9RZ6t5RUMJyEAE6sVh/qDih7c0M8i2RcXIu+Bho/phCyJwGxzdAsX5
   eERpW0/5vLJqxQeMsLBwKw6/xkFIPCv+FOwHK86dn70RwpY3RKprUSk5W
   yWCKdn8/ssAYyynMNKO6vTnJ9Wmo47RwpVH7B/n6MPyLAkRJl8smvEGHV
   A==;
X-CSE-ConnectionGUID: RmoSIQLWQBSM7LMZUVSS9g==
X-CSE-MsgGUID: 54G/srJ6QoSgEtrx420ujg==
X-IronPort-AV: E=McAfee;i="6700,10204,11344"; a="57632205"
X-IronPort-AV: E=Sophos;i="6.13,284,1732608000"; 
   d="scan'208";a="57632205"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 17:01:16 -0800
X-CSE-ConnectionGUID: uQLqY1tKTlufvqS7nN+Uaw==
X-CSE-MsgGUID: hiAU9cbBSdybCIyb5+egug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="117931876"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Feb 2025 17:01:14 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 13 Feb 2025 17:01:13 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 13 Feb 2025 17:01:13 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 13 Feb 2025 17:01:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m/nCIAfweoAF2CVThjxqpnosl+ASxHdWlQhn9/NyZftb4c3iwjk245uhczELbmkuQgIm0uuaFXKjiqozTLYNz67BvhRso2XE43qjvkK8zGRrNC9IHbhHNqBHh7wo15+vbZKIJRPVg05g6jXKiNDPENIUepGePT7K5Z40zZtWV4ZWL3XnUMrqp301VxtDXJ+XbUe8JWhQtC/E2ikLiG1QmjJ5Tt6IJhko8PDf236UgYwZGGc7vGxwCAi5ba37eXbrN2/7ADpzZxPbPi13krsCZr0RcBTuSz0L/UrnhoBIRYNFh0DQOBlnU3IcaGp4DtDfUQA5DSAK0IrXe/yy7SuBTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DeMS7SluieBfYdAXg4ZS9dEbvZD7/gh1uVPrwupr4T0=;
 b=OaERag6AthrUsIC5h0WpY4JJEcNIAT8WDw37GJcZBdSK21F67HQipzmUph+9r8occ4s/RTH5yLMQFcHzH2ZWNjVhUhDMhbu+pKsPj2j1ml28fwKu2547juRWFVGz7JOBJSbqPW5cawOhDp6mpJ4MWJOLp3gPovwejWImB+HiF3qyvJc2KCfPb5+cPQhRL2B/N7F0o4AT5NT1Jtqj5BNAhr6olu7KdBKKqTfG2snN2LdRAIOSVO/X/tDg0yTsVlmoRgZvXYBnVmyS3s1HmPJzVlysIVZqW0S2cPXVWrpQzxWsMC0NDlJXUW8DQckrpIOHf7tbmA6I6pxTOAIA3HvS4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CYYPR11MB8387.namprd11.prod.outlook.com (2603:10b6:930:c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Fri, 14 Feb
 2025 01:01:10 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 01:01:09 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Gao, Chao"
	<chao.gao@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Lindgren, Tony"
	<tony.lindgren@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v2 8/8] KVM: TDX: Handle TDX PV MMIO hypercall
Thread-Topic: [PATCH v2 8/8] KVM: TDX: Handle TDX PV MMIO hypercall
Thread-Index: AQHbfDApdlf/cGS1Jk+r9GVy/r2ODbNC81aAgAADFwCAAtFqgIAAM+qAgAADuwA=
Date: Fri, 14 Feb 2025 01:01:09 +0000
Message-ID: <d79ebae6825071201f38bbae4af4df05d84c7ab5.camel@intel.com>
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
	 <20250211025442.3071607-9-binbin.wu@linux.intel.com>
	 <Z6wHZdQ3YtVhmrZs@intel.com>
	 <fd496d85-b24f-4c6f-a6c9-3c0bd6784a1d@linux.intel.com>
	 <da350e731810aa6726ff7f5dfc489e1969a85afb.camel@intel.com>
	 <aa6a2af0-fa4b-42a7-98d6-d295efbb2732@linux.intel.com>
In-Reply-To: <aa6a2af0-fa4b-42a7-98d6-d295efbb2732@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CYYPR11MB8387:EE_
x-ms-office365-filtering-correlation-id: c7794b8f-9956-4790-6a5b-08dd4c9311c2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UmZ5SVJBeEQxVUZDOVVEQmxpb0J1eTVrb2pDMkFzb0tRdHpYOTA0Q3BFdG9m?=
 =?utf-8?B?THpUVHNSZmt0VUcrL0xzWnBGNmg3cWFLQm9OdExxMTYwTmdIaXoycHRLSG9E?=
 =?utf-8?B?K1FZdWdFV1lNMVBLaHBxNzFqTmxvZE9mLzUzaDNYV0FldXhSdmdNbXBiLzc5?=
 =?utf-8?B?VzJsYnJMMExXODVvYmVYMEovZHN1NXJ1U1NDQjJzTVk1Q3ZTdVdlM1ByM0pV?=
 =?utf-8?B?NDh5VXMvRVRDZWhHOEd3cTBBNTZPRU5hSTlHQ3I3NDhKNmZZeEJOcFhVMVc1?=
 =?utf-8?B?Q1FHa0kvcE1XUzJCOW5mK1hlbXFKbkRzL2RaWDVsZ2VaTFF0RWFnNDZrYy9J?=
 =?utf-8?B?UFZwbDFMRzIxc0VqMy9MUzBtVm1idW1UMFNDSEhMYnI2aUVwZ3NjcmdNeXgv?=
 =?utf-8?B?YVp3Y0FXN2xQSlUrdXp1REEwS2hkR25kNjhIeWFPeDVQY3VoRERyWUZVS0V1?=
 =?utf-8?B?SHQ4ekVXTFUrTTdaT3J3a1N6dnBkZVZBeTBSTmV6M0pBR2pUazU1YnpkaVJM?=
 =?utf-8?B?ZTROYStDQUhUaHU1d0pIY1ZrYmF2LzMvbVMyTjUvLzJJdUVFblkxcDdPMGhm?=
 =?utf-8?B?WFhUWHFseGR2cHVwOTdnL2tla1VVTzR0czVvTlZ2Y1pPMGgzUklPZDBzMXVE?=
 =?utf-8?B?aUpRbDYxUUEyejdsaGVGallTazZUaXd4RWNiZ2FPTU9wVDVseC9OOFBnZkNm?=
 =?utf-8?B?SmdobVRJUlo2S2VzVW1yQ2RxVFU2VGgyVzBma3hmQ2pSTFhiUm8yaUhXSkhE?=
 =?utf-8?B?bFFaOEtheVF5TU1yVjduRmZ3cEFVVk9FVDNoRk16MG5CM25kWXErdjBnTWor?=
 =?utf-8?B?S3huZnVwL2M0OVphQTVmYzZjQWFTZkIyTlN4K1ZIRnR6bkpidEVTSExBYUhr?=
 =?utf-8?B?WE1DSFR4RDJTaWsyOW40a2R6cXArVjlWYWFQTHJzZURvVWczV05UUDdwbU5C?=
 =?utf-8?B?YkhOM04xU3kzTHdKUlYvVFlPUFBFdGFjNDJ4dk5wR0podlVCb1dUdHllaXV5?=
 =?utf-8?B?MTh2cEMwdmNheEJ3dWRqd1JQMXc2TGFsVjVhTFIyN2ZUZHZmZHVLbzZ2QVh3?=
 =?utf-8?B?MDhMcjgwRU5DRXIwQ2JScC9UL1ZoOWwxb3FsWlQyTkJzeXd0K0hFS3hGSDJP?=
 =?utf-8?B?bE5qeWg2emdpdmRwdnNLc09yaXFmUzBhY1VEVS8yOFRpQ2NpSS9OL0hBc3ZE?=
 =?utf-8?B?Q2Z4djlPK2o1WFRLcEs4blpUaWdLZlFJZEZKNmo0bVplVXJibmVNT0dUVHc0?=
 =?utf-8?B?ZDBRTTFuQWVjdXFnaS9MaklocTVjSzRETmVTQUVaUWV3UzhEcVRQUGdSd2xh?=
 =?utf-8?B?Q2xWMzZ2UkNoSlF0V0tpdjg1Uzh1S0J0RWV6T2NtQzNxdkdpMnIxQ1JEanBr?=
 =?utf-8?B?cnlLUlExUmJTbkpGVEk4NjRocHpTMDJ5Z3RYek9iVEQ2TkVYd0VJbzZ3aXJK?=
 =?utf-8?B?SHEvMTkxeWs2V2xESlYwQU1tYlJpNXc5VmI5V1F6TlB6SXYzOW5pK1VYWHpE?=
 =?utf-8?B?bHk0d3ZSaXVKWjYzVmRXNjFLdUlEUXZwbHc1WVRmeXBPdDNrRmFRSEYrcjA4?=
 =?utf-8?B?UGFLVXd6RWhkTWRmV2YxVXZVU0dqNUFDOSs0T3ZhSEtiMEpwaEl3d0hON2dq?=
 =?utf-8?B?emhnZ1MybzJpY2d5SlJRTXRKWFRsd255b1J6WHJjVVFJVEVhcVU3NW1xNkw5?=
 =?utf-8?B?cm90Lzh5MldQTVc0SnFCVXN3d2dFQkRWK3ZIenBIYVRkZlhIK3FvZU9IT3VR?=
 =?utf-8?B?R2xLeWkxV1RWUXlsRTBHNGxvZGpqYjNlSFVzblB6VU55dW9jUTg4QWVTcUgv?=
 =?utf-8?B?WXMwUTRhTFd4cWgzVW9RY2VkL1FTMjE2MXdlMmZENTVvQk5aM0ZQa2llUkdi?=
 =?utf-8?B?ckc2ZlN2UUJLUll4U1Y1WlpaUDdMQTJWZmd0Sk9Zb1NsMVloakNKNlVHLy9B?=
 =?utf-8?B?S1V5K0syVEdjKzZUWVNSWWY4UTNZSVhvcUxuajlPaTlwaGZ5NEt5bXlHa28x?=
 =?utf-8?B?cW5SNnJFMjJBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGNKNmN3OWRSaWROb0QvUWtEZS8xaFplUXErdUNRRHNuUWM2RWprdGpXcC8r?=
 =?utf-8?B?QTcwRDBzUWZEWmxtMllLNmpMR0k2R1A2WU1MeGNXci9LZlFtNkMxcWtucnpt?=
 =?utf-8?B?aWVURTdYT2pyN3hiNllYdFE2eXF0VUxJNVNMNVJYckV0TTcxTzBiUkUrenY4?=
 =?utf-8?B?REIzamdUK3ZxcUs4QkM0d01MYVFWaU9nR2JTSDBISEt5ZGVBenRNUW9vbXY5?=
 =?utf-8?B?eWpmZ3B2ZXcwaktKVm1rZkQzcmYzZ3pwMkk1amQyb01sV2M2V0N1ZDVzeklR?=
 =?utf-8?B?K01xWUxob2ZDbVFtazBxVU94SVRzNVB0YU1SOU5ZYkhobS9zOEJZdlJoeWZQ?=
 =?utf-8?B?SS9zanlkb1hqTm15OHNUYVQwdFViWFgzSTluOXJ0VWZ6eXgzY2FxSGZVT0tY?=
 =?utf-8?B?SUlvSWtkcHNqSFhXQzlLVzAveVFodStxYTRTUU9RU2l4Z2dQeithb25KSGJT?=
 =?utf-8?B?YzBnN3dhYmR2Um5SRnhSdmhPUUlaRTUva043SHlDSGR1QzdXTksvTFVrSTRV?=
 =?utf-8?B?Vk5vQUdoOTV1dHhha1Blb1hwVGJZSTBqZXpRNXJpV3crQVB3bGZ2MmVpaE1n?=
 =?utf-8?B?eEwwN0xMTG9oMFd2MVE1N2JxNEZxd0JiT3FZVlRXVlpHODZieEsyS3pIZjlM?=
 =?utf-8?B?M0RwM0xHRUZXT2xGbnZtN2tjVCtTUEUyaS9qc1VMaHN6SjcyNGtqaDlHUGlW?=
 =?utf-8?B?YnBsa3YwQmU2Y21PVk1KRWU3dTBvYmt6cWpnNFZrTVA0VWFya0FZRXNVVkpq?=
 =?utf-8?B?QnFwT2xPNk53TzUrRThlRXNkRzFsQW9jOVlpUnFjWkZPTDZXa05RMnBMM2ZD?=
 =?utf-8?B?ZEs0THpoa1dNdnBGNlhISHVqSURGTksxTVNQM05kNlFNV1FLMFIvamNuUjZP?=
 =?utf-8?B?YkVHY0JQZ1M0MU5ucE9CTTRoUVBMTjFJckp2RlN3dmp1b2thVEFzb01mY1NL?=
 =?utf-8?B?VjhyTTBaM2hjUld3RnB1c09mNklDT2UzM2o0SkdnMlExS2gyUmd5Q3N6N0Ex?=
 =?utf-8?B?Z0l5Q0loSG9TVHBmY2lwNnpvTEZITi9qYUhPM3RaMndmL01HWXpqUElNdjBZ?=
 =?utf-8?B?cDZVelk5QzllY04wMWtaYUV2QUVKM2tMaDBzVVN3S2JYeDcxZWtTbUtGYk1J?=
 =?utf-8?B?amNMS2JGc0s4Q0ZsaklyT2prRzdGU21pR0VCcFhLblM5NWdxR21tbVlkKzJJ?=
 =?utf-8?B?d3dYc2huRTZucnE2eit4TnpRVVRzcmtQakVHVVl5d1UxTmxHQ1lNZFA0Yjc5?=
 =?utf-8?B?RktJUnlZcUdidlc1S1hkdVpvQ0xRRUF2YVdRQzdTSGRRZUFaSEREVnhId1A5?=
 =?utf-8?B?VVE4UGFLM0xzUDBJcS82VE96Qk5Nc0tNbFdoRTJGVzZGVXpPUFd3R3pXQSth?=
 =?utf-8?B?R1hLTlQwOUtnL3M2bEVKRDJOUzU1UkRVUjE1T1laV29vR0ZlcENuMHZFaGRE?=
 =?utf-8?B?TkN4WVBXeGVkL1lsRXZzbVN3Uy81VWVaNno4T2NJTzluL09HS0xHSlR6V0Zp?=
 =?utf-8?B?Z3czb2dicG9sZ3BLZHFMeGZ5b3UzOU9XZmJBWGNNbEd1OXpuSkZWbDJIVjFK?=
 =?utf-8?B?MGUwdGdIWWZ0d0lMZFhoSmhaZlQrVGx6NGpmWC9RSnViV0MwQUZGTUQ1VlZO?=
 =?utf-8?B?WFA0YnlVOXU3VkUyNWdEZWZFeHhBQndqeW9aOGtQdS96WldsMTVhRmFkRnBE?=
 =?utf-8?B?VEdyYUY5UVNCNUZ5eG1zT3E4K2gxRzhxT0JVRFdUTUxQUThlRTFoaUMvMXM3?=
 =?utf-8?B?S0lkRTEvTjMybkNSYkdaamZOK3g0WDJLT2Q4d2czMWhVMm9vLzVrVSt3cWtX?=
 =?utf-8?B?L0MycEpEWDI0bTBLWnp2MVpPQ2FBN0w3ZVcwbGlsdXMrYm9SRkpVSTlhSk92?=
 =?utf-8?B?MW0yNzVKSjZndUlkd3Zvd0dvTFVDWGp1MXN3NW5WUXZpOWdYeGN3cFkrQU0v?=
 =?utf-8?B?K2lCRERYRnNTcVkweit5Tzg0VVRMNHJMMjA5UzVCcHNwOHdqY1BFZHRNL1E3?=
 =?utf-8?B?eFkzMmN6ZDJHWHJ4M0oycXdUODNNYXhSU1hhYWRReEYwMEtaMXltc3FWbm5W?=
 =?utf-8?B?UXgybzh3RDRGU0pyaERBdnhFYlpSejZVS3lBL0Y0Rkg3TEI0b3YwbU1FbXZp?=
 =?utf-8?B?ZGFUQXZVOWh0ZVVING1ZbzFRTXVNU1ZncHQvaHVzT2srdEhRNFR0ZzVpUGZB?=
 =?utf-8?B?Q3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <89CC3FF9B2EC6D4E92E8F8D47BEDB196@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7794b8f-9956-4790-6a5b-08dd4c9311c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2025 01:01:09.7959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9s8Yp1IQzzfwYA/pd7L5cdPOQ5JkaDNiH4KGciYOvhPDn2+LhPL+BFEAL38OL9xO6EAVpEsJ3Clzr1nILJQeBaN4rlr0HMABdZ18nbygrZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8387
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTAyLTE0IGF0IDA4OjQ3ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IA0K
PiBPbiAyLzE0LzIwMjUgNTo0MSBBTSwgRWRnZWNvbWJlLCBSaWNrIFAgd3JvdGU6DQo+ID4gT24g
V2VkLCAyMDI1LTAyLTEyIGF0IDEwOjM5ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4gPiA+
IElJUkMsIGEgVEQtZXhpdCBtYXkgb2NjdXIgZHVlIHRvIGFuIEVQVCBNSVNDT05GSUcuIERvIHlv
dSBuZWVkIHRvDQo+ID4gPiA+IGRpc3Rpbmd1aXNoDQo+ID4gPiA+IGJldHdlZW4gYSBnZW51aW5l
IEVQVCBNSVNDT05GSUcgYW5kIGEgbW9ycGhlZCBvbmUsIGFuZCBoYW5kbGUgdGhlbQ0KPiA+ID4g
PiBkaWZmZXJlbnRseT8NCj4gPiA+IEl0IHdpbGwgYmUgaGFuZGxlZCBzZXBhcmF0ZWx5LCB3aGlj
aCB3aWxsIGJlIGluIHRoZSBsYXN0IHNlY3Rpb24gb2YgdGhlIEtWTQ0KPiA+ID4gYmFzaWMgc3Vw
cG9ydC7CoCBCdXQgdGhlIHYyIG9mICJ0aGUgcmVzdCIgc2VjdGlvbiBpcyBvbiBob2xkIGJlY2F1
c2UgdGhlcmUgaXMNCj4gPiA+IGEgZGlzY3Vzc2lvbiByZWxhdGVkIHRvIE1UUlIgTVNSIGhhbmRs
aW5nOg0KPiA+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjUwMjAxMDA1MDQ4LjY1
NzQ3MC0xLXNlYW5qY0Bnb29nbGUuY29tLw0KPiA+ID4gV2FudCB0byBzZW5kIHRoZSB2MiBvZiAi
dGhlIHJlc3QiIHNlY3Rpb24gYWZ0ZXIgdGhlIE1UUlIgZGlzY3Vzc2lvbiBpcw0KPiA+ID4gZmlu
YWxpemVkLg0KPiA+IEkgdGhpbmsgd2UgY2FuIGp1c3QgcHV0IGJhY2sgdGhlIG9yaWdpbmFsIE1U
UlIgY29kZSAocG9zdCBLVk0gTVRSUiByZW1vdmFsDQo+ID4gdmVyc2lvbikgZm9yIHRoZSBuZXh0
IHBvc3Rpbmcgb2YgdGhlIHJlc3QuIFRoZSByZWFzb24gYmVpbmcgU2VhbiB3YXMgcG9pbnRpbmcN
Cj4gPiB0aGF0IGl0IGlzIG1vcmUgYXJjaGl0ZWN0dXJhbGx5IGNvcnJlY3QgZ2l2ZW4gdGhhdCB0
aGUgQ1BVSUQgYml0IGlzIGV4cG9zZWQuIFNvDQo+ID4gd2Ugd2lsbCBuZWVkIHRoYXQgcmVnYXJk
bGVzcyBvZiB0aGUgZ3Vlc3Qgc29sdXRpb24uDQo+IFRoZSBvcmlnaW5hbCBNVFJSIGNvZGUgYmVm
b3JlIHJlbW92aW5nIGlzOg0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vODExMTlkNjYz
OTJiYzk0NDYzNDBhMTZmOGE1MzJjN2UxYjI2NjVhMi4xNzA4OTMzNDk4LmdpdC5pc2FrdS55YW1h
aGF0YUBpbnRlbC5jb20vDQo+IA0KPiBJdCBlbmZvcmNlcyBXQiBhcyBkZWZhdWx0IG1lbXR5cGUg
YW5kIGRpc2FibGVzIGZpeGVkL3ZhcmlhYmxlIHJhbmdlIE1UUlJzLg0KPiBUaGF0IG1lYW5zIHRo
aXMgc29sdXRpb24gZG9lc24ndCBhbGxvdyBndWVzdCB0byB1c2UgTVRSUnMgYXMgYSBjb21tdW5p
Y2F0aW9uDQo+IGNoYW5uZWwgaWYgdGhlIGd1ZXN0IGZpcm13YXJlIHdhbnRzIHRvIHByb2dyYW0g
c29tZSByYW5nZXMgdG8gVUMgZm9yIGxlZ2FjeQ0KPiBkZXZpY2VzLg0KDQpJJ20gdGFsa2luZyBh
Ym91dCB0aGUgaW50ZXJuYWwgdmVyc2lvbiB0aGF0IGV4aXN0ZWQgYWZ0ZXIgS1ZNIHJlbW92ZWQg
TVRSUnMgZm9yDQpub3JtYWwgVk1zLiBXZSBhcmUgbm90IHRhbGtpbmcgYWJvdXQgYWRkaW5nIGJh
Y2sgS1ZNIE1UUlJzLg0KDQo+IA0KPiANCj4gSG93IGFib3V0IHRvIGFsbG93IFREWCBndWVzdHMg
dG8gYWNjZXNzIE1UUlIgTVNScyBhcyB3aGF0IEtWTSBkb2VzIGZvcg0KPiBub3JtYWwgVk1zPw0K
PiANCj4gR3Vlc3Qga2VybmVscyBtYXkgdXNlIE1UUlJzIGFzIGEgY3J1dGNoIHRvIGdldCB0aGUg
ZGVzaXJlZCBtZW10eXBlIGZvciBkZXZpY2VzLg0KPiBFLmcuLCBpbiBtb3N0IEtWTS1iYXNlZCBz
ZXR1cHMsIGxlZ2FjeSBkZXZpY2VzIHN1Y2ggYXMgdGhlIEhQRVQgYW5kIFRQTSBhcmUNCj4gZW51
bWVyYXRlZCB2aWEgQUNQSS7CoCBBbmQgaW4gTGludXgga2VybmVsLCBmb3IgdW5rbm93biByZWFz
b25zLCBBQ1BJIGF1dG8tbWFwcw0KPiBzdWNoIGRldmljZXMgYXMgV0IsIHdoZXJlYXMgdGhlIGRl
ZGljYXRlZCBkZXZpY2UgZHJpdmVycyBtYXAgbWVtb3J5IGFzIFdDIG9yDQo+IFVDLsKgIFRoZSBB
Q1BJIG1hcHBpbmdzIHJlbHkgb24gZmlybXdhcmUgdG8gY29uZmlndXJlIFBDSSBob2xlIChhbmQg
b3RoZXIgZGV2aWNlDQo+IG1lbW9yeSkgdG8gYmUgVUMgaW4gdGhlIE1UUlJzIHRvIGVuZCB1cCBV
Qy0sIHdoaWNoIGlzIGNvbXBhdGlibGUgd2l0aCB0aGUNCj4gZHJpdmVycycgcmVxdWVzdGVkIFdD
L1VDLS4NCj4gDQo+IFNvIEtWTSBuZWVkcyB0byBhbGxvdyBndWVzdHMgdG8gcHJvZ3JhbSB0aGUg
ZGVzaXJlZCB2YWx1ZSBpbiBNVFJScyBpbiBjYXNlDQo+IGd1ZXN0cyB3YW50IHRvIHVzZSBNVFJS
cyBhcyBhIGNvbW11bmljYXRpb24gY2hhbm5lbCBiZXR3ZWVuIGd1ZXN0IGZpcm13YXJlDQo+IGFu
ZCB0aGUga2VybmVsLg0KPiANCj4gQWxsb3cgVERYIGd1ZXN0cyB0byBhY2Nlc3MgTVRSUiBNU1Jz
IGFzIHdoYXQgS1ZNIGRvZXMgZm9yIG5vcm1hbCBWTXMsIGkuZS4sDQo+IEtWTSBlbXVsYXRlcyBh
Y2Nlc3NlcyB0byBNVFJSIE1TUnMsIGJ1dCBkb2Vzbid0IHZpcnR1YWxpemUgZ3Vlc3QgTVRSUiBt
ZW1vcnkNCj4gdHlwZXMuwqAgT25lIG9wZW4gaXMgd2hldGhlciBlbmZvcmNlIHRoZSB2YWx1ZSBv
ZiBkZWZhdWx0IE1UUlIgbWVtdHlwZSBhcyBXQi4NCg0KVGhpcyBpcyBiYXNpY2FsbHkgd2hhdCB3
ZSBoYWQgcHJldmlvdXNseSAoaW50ZXJuYWxseSksIHJpZ2h0Pw0KDQo+IA0KPiBIb3dldmVyLCBU
RFggZGlzYWxsb3dzIHRvZ2dsaW5nIENSMC5DRC7CoCBJZiBhIFREWCBndWVzdCB3YW50cyB0byB1
c2UgTVRSUnMNCj4gYXMgdGhlIGNvbW11bmljYXRpb24gY2hhbm5lbCwgaXQgc2hvdWxkIHNraXAg
dG9nZ2xpbmcgQ1IwLkNEIHdoZW4gaXQNCj4gcHJvZ3JhbXMgTVRSUnMgYm90aCBpbiBndWVzdCBm
aXJtd2FyZSBhbmQgZ3Vlc3Qga2VybmVsLsKgIEZvciBhIGd1ZXN0LCB0aGVyZQ0KPiBpcyBubyBy
ZWFzb24gdG8gZGlzYWJsZSBjYWNoZXMgYmVjYXVzZSBpdCdzIGluIGEgdmlydHVhbCBlbnZpcm9u
bWVudC7CoCBJdA0KPiBtYWtlcyBzZW5zZSBmb3IgZ3Vlc3QgZmlybXdhcmUva2VybmVsIHRvIHNr
aXAgdG9nZ2xpbmcgQ1IwLkNEIHdoZW4gaXQNCj4gZGV0ZWN0cyBpdCdzIHJ1bm5pbmcgYXMgYSBU
RFggZ3Vlc3QuDQoNCkkgZG9uJ3Qgc2VlIHdoeSB3ZSBoYXZlIHRvIHRpZSBleHBvc2luZyBNVFJS
IHRvIGEgcGFydGljdWxhciBzb2x1dGlvbiBmb3IgdGhlDQpndWVzdCBhbmQgYmlvcy4gTGV0J3Mg
Zm9jdXMgb24gdGhlIHdvcmsgd2Uga25vdyB3ZSBuZWVkIHJlZ2FyZGxlc3MgZm9yIEtWTS4NCg==

