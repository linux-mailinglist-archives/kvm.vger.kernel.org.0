Return-Path: <kvm+bounces-24678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08EED9591A1
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 02:13:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D4ABB212C3
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 00:13:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD44290F;
	Wed, 21 Aug 2024 00:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PW1jFkBv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E46136A;
	Wed, 21 Aug 2024 00:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724199171; cv=fail; b=CW9q6tu2O0vV3bhSllGNSqGRJ2Kf231skI22RoBA23Dids+UYAzLhIpt9zOuvSe/UtV68yvH2btA3nvFcei7HlqcVDchcRU0+EN9zV0XMGUGbttgBx/H5xE4SxNJbnbCvQwKIxFvb7WUrZJImnUjIkfN/FFaPyFIwjpfULJsWLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724199171; c=relaxed/simple;
	bh=KEbUtpGHf94xAdzfwmrbv/RL23/nNn83NIkk32Sr/lE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i4YGAi7H09of7R+ToOggZun1sN7/btoZFXepRBvavQTUXIOBjsqXgr22BKo9dxI87VSOE5ZdJuW2plRz85GI/ME1h4rl9mg+5aS0MvbLucILcRWrvVMmRmqlXyxdDVCOfnZCcg9Pp8Yzau+SfVp+nZGfeiVlidokiLeT5CQYshM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PW1jFkBv; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724199169; x=1755735169;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KEbUtpGHf94xAdzfwmrbv/RL23/nNn83NIkk32Sr/lE=;
  b=PW1jFkBvsgcqng1XpcNWag3f9wtKc1X5mrdZLvXLejs9sTE0B3CoV0zK
   RwPqtOfWOYPPO1WTCa/E6OqNQWhQbJ+www+QFoNaXkmm5cWOxKcgggW0I
   gksjCIHG6nfCk7bNa9TeWV4PCYGPO55XJS3PnuTzsMIuPlwduwZIyD862
   UPnf/d7JkoMxyKO69OUiQF/XReB60gEjn/by2OuSaU2hRPjS/xs8qJzpE
   MAxZa0TlawPF7QDCzWKQlf9mSlbTxMC5Nf8XnjVjQChDLN9nlrJ7YS2SO
   bNiphWM4T6gLQGEcrnA5qrKcIIalh5L6K6cwN8FbHwC31XkESRmxqs2oR
   A==;
X-CSE-ConnectionGUID: mbkv1jOYQoyEgfWKIe7pbQ==
X-CSE-MsgGUID: YGFE66RtRJWrdEZMcnbAqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="33952047"
X-IronPort-AV: E=Sophos;i="6.10,163,1719903600"; 
   d="scan'208";a="33952047"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 17:12:48 -0700
X-CSE-ConnectionGUID: /bmSbmkgSj+EnRrT7TLZsw==
X-CSE-MsgGUID: Vwg6I7+tRCCv3Jok+bPO7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,163,1719903600"; 
   d="scan'208";a="61231735"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Aug 2024 17:12:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 17:12:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 17:12:47 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 20 Aug 2024 17:12:47 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 20 Aug 2024 17:12:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CkMYo1RcCy6tlbrQQUVn32LGACPzc0IA8Nc+BR+yQfdXsmFkHr2rF3bsHd/J0h0TPq+AaxWGIrrzQeys/KKaQY6KDQhfgVx+c4qWq66Xh/pZpwmkTXKCKXylWJMxhYVsx3Krz0xxUZmnehLOcdEAXGdcUTjwXMjRxkAhmyGOfv6DKzm3Rhzngw28czTsnvPjJcqaBZwyualKr8uGFTDjOscs7X+uFSO38+4tB/yzV+zbna7v1xR5iyH0Fspg/oumt0Lh7+IR0XzDQ2l/xG1RAOOai3Y1UaJoqAdAkxb3NsJyFBYi9ftlWZh89SiTH67gK7/Z5unCpvP39CTpZxw6Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KEbUtpGHf94xAdzfwmrbv/RL23/nNn83NIkk32Sr/lE=;
 b=E6EtQ2IX/AFL3y8pK5CZHCbDLbHKl1++qAvOdfsBlwqaNQBw7cMCIxf9EASSxZ8A6FhJ5rOMexU+niqbFPiz3TakJ/BFn1aV0JrQvzMJzFTnkXhy91apzJyCEjHz9JWtZIvY/ksKATX9MG0dRfWCNrhQJCdYOTmJS4wiGtGBMd1ZyhF66zOCDNXjhFr16BFwcxU+Btau5hvpb8HvAb4zZzSmUPnByXtrleJ5BR2Ur2TQcjWGGHLziiudhmFRoC2dyR5YROFDi0ZPzscALuqFyP3tXobzhCp003eH5GWIixA16ssm6Dmv+CZMFVVy2aNdr4YyyjkyAjzju2bVIT2Ibg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB8588.namprd11.prod.outlook.com (2603:10b6:a03:56c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Wed, 21 Aug
 2024 00:12:45 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.7897.014; Wed, 21 Aug 2024
 00:12:45 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "tao1.su@linux.intel.com" <tao1.su@linux.intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 12/25] KVM: TDX: Allow userspace to configure maximum
 vCPUs for TDX guests
Thread-Topic: [PATCH 12/25] KVM: TDX: Allow userspace to configure maximum
 vCPUs for TDX guests
Thread-Index: AQHa7QnNXQp+JaEvS0KN1ruzt/gnWLIt0PMAgAMSpwA=
Date: Wed, 21 Aug 2024 00:12:45 +0000
Message-ID: <9a5c0f7f1e71adf0463e45f6bf9695d020242c3c.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-13-rick.p.edgecombe@intel.com>
	 <ZsKdFu9KTdoLJEBV@linux.bj.intel.com>
In-Reply-To: <ZsKdFu9KTdoLJEBV@linux.bj.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB8588:EE_
x-ms-office365-filtering-correlation-id: 01f1bbee-4aad-4829-d158-08dcc175fb55
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MVdIMU4zM1F2ZG5IaEhQWHU1emhKNzNSdWlQOU03Z2lYWWdvRGxMWC9PN0lD?=
 =?utf-8?B?Y0J0ZHNaMHROeGVuQW55OXJzSXpNalhHVzZBVnY3WVpXMXRWOXFnUWgzWUh1?=
 =?utf-8?B?Y2FIRXNtSWhiN3BLUDFucVI0b0pEc2owY0s3WDhSY1dqNEVPeHRpVXZmYlZq?=
 =?utf-8?B?WFR3c0ltMGFzYjArZlRybWJUZEl1UStST284ejBTbnNSbmM2RURjL01LRFFu?=
 =?utf-8?B?UmJieHdGMkdadU1EYUlXSHFQYXBHUkdPWm5BMkRod09NTTBNL2J4MThYWUpP?=
 =?utf-8?B?UVNaQTBoZ0I5Nzh3VDBZdVk1K1FpQ1ZSR25RWkdmZFR3VG9aV2tlL3lzT3Zo?=
 =?utf-8?B?RW85dGQ5ckZyQTV4SlR3WXhnckxjYXpRV0lkZmNRMUt2a21nQWE0QnZha21x?=
 =?utf-8?B?Y28wQlp3aERhTHNVNXdDSnkzVTgrWFVKMmRUeWViUXhtMEFyZmNKZG9Sc2NX?=
 =?utf-8?B?eS8zeXJFeEhwTmFxMU9YMUdlMFJ1R21QRHpHVXFXOUZwQkVmc01FMEtNRGpw?=
 =?utf-8?B?czRONnQ2Q3VEcWpPc0RSSUd4ZUsvTHFrQ3dQK3pqR0hEL2xCRVFjQWI5S2cr?=
 =?utf-8?B?anppWnBMYm5JNEIxNzZBUHF1WTN4MFhUS1k5bFlHdHQzRFdERWhMSkdadnFR?=
 =?utf-8?B?b2xPTVhhRnF4ZGF1cEJMNkhxaVBoZG5WeDRMN3pEM3RsdllacDEyN0VmaWZN?=
 =?utf-8?B?SEVMTTRzMTRVclJBZVljeDc5ZnRDdUVyOVFrWFV2SXVmM1ZzRmtsSEVMUDlj?=
 =?utf-8?B?SmU5V3BkMU02aVg3RUd1VnlibS9mWjJjS1dkc0hLSGp4Ui9wT0VOQkxrSjcr?=
 =?utf-8?B?UmZ0U3M1RDhKbzNLNWMrUzdlVWJtY2lWZVlrQjVNSXpsYmtBV25TZGNsS24r?=
 =?utf-8?B?NElmQWVVOVR3c09zNFFDOU5XM1JtRTZCYUN0aFBtbFQ3UjF1bTNJdXBmNCtz?=
 =?utf-8?B?U3BEY29naFkrVEtrV3dISTVFQUpwYmdEdFpDYTkvN0JjajNQMXl5OWxwc293?=
 =?utf-8?B?YU9CenlWNG8rNGhFVVpsdjNOZFBnVXB1cVdFOExoeDdRMmtOYmpySCtQQm1P?=
 =?utf-8?B?aWJBWkMvaFBIQ0tZQ0lwMi9FUmtJODd4cldWdWw4ejB1UkRPa0luN2hKSEYz?=
 =?utf-8?B?eGFsa2o5N1JiTnN1dW1EMUEwdmc2SzJSVWd0V1lObnhOK2t3WVlVUUJBRUs5?=
 =?utf-8?B?OFl5NjhTcFVjTFNENnBkbzZFeDhreU9rdVl1a2dhUG10NXRCeWQvZmF6R2dF?=
 =?utf-8?B?bzQzejVTa2x1T0xXRjBjSXA0OERxdGFlTkNqdGd5ZmxDTlhybWhKenlBLzk2?=
 =?utf-8?B?YjJ3UUdGcXFFbno1RVpHYlhjbHIrRGs2QjArVnBkM2ltZGgxKzNWM3doWGVM?=
 =?utf-8?B?QTUzOTM2dCtLdVZjWlRiT2dQcUNHeGV6ekFEN3cybk9EaVA5U1BMbzlLb2RQ?=
 =?utf-8?B?VW0xQWNwL1cyMjFZZ2Y2ZTRPOFJ2Qm9Oa1BMYW96SGd5alM4S1ZXZkp4SkJs?=
 =?utf-8?B?d3lqYVNxVitIOWpTb0VRbmFGZmd4UXZLSUNrYTd5V3FZeHpFYmdpMWtXZzJJ?=
 =?utf-8?B?TlUrTHdIYlhMSmMzWWR3UERwLysxaVVUSTAyVElDcDZlclJOMTBiM3BwTmRh?=
 =?utf-8?B?WVcyZXpvUWFEeWJHL0hmd2w2ejNaSWxHS2lHNUZPRmZ5RTNMMTF0OUkybUNB?=
 =?utf-8?B?ZGtYY2Y2eUdGQStNWUdiOFJKTGUzT1VJd05WVFlOeitvVWdYUW5PSVlhVWt6?=
 =?utf-8?B?Q2srSXVvdzhab2pBZVA4dWIrOVRZVUkvdHJQaHJ5bEJ2ei9DaEJ1LzhTYWRx?=
 =?utf-8?B?alZPZzcxVXBudUNJN3NsWnNlQUJnOUQyeEtFWnhiVGQ0TC85K25xeHRDTXYz?=
 =?utf-8?B?R051UElIZncyR1hxRkFTbHB4ZVBhSnhmYzFpZk93SWNzNVE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R0ZLYUZpRUdOM2tYb2cvOXZORHQ1c3JCNlpNYm5pd2QveCtLdGJnZG5tY3VZ?=
 =?utf-8?B?VTZQWVBUZk81MnJlc3RCNy9CemlvUFhvS3VyWjBSbVhMdFZvWjJpMDNqRHdC?=
 =?utf-8?B?SytVejZVc3JsVW9uMTZDVUp2Nmd2VlVPR3Jtb0Ftdy96alZlSk5ZSG5wSk0z?=
 =?utf-8?B?ZTVxb2NVOWtiVWtCNXpRMTdRb2tkcDhyL2EwSjJicVA4WnBJcTFUemNYUHJH?=
 =?utf-8?B?azkzMXFCQXI1bmtCQXVOZW0rZU5pOHRzV2pzYkdFaUcrSndqL1NwaTI1VE1Q?=
 =?utf-8?B?Z00wdklxY1I0dlFuMjd2MThRTUx6R21vbXQwaVBNc2ticC9EYlJ5Z092YlNx?=
 =?utf-8?B?N2htNElIZm12M2ZJdDF5OEZyNXBSZ01CUitvZVVuVlVWZUgwN2hZeE5RbzZ0?=
 =?utf-8?B?c0hBNk54UEZBU3ozZWtZay9hY1RZSm54NUxOWXJEUXJMTmlkdmQzVDNDbHEx?=
 =?utf-8?B?SHhDVjRTQ3pKbGdVdkF3bWJiQy9RTWpTUzZiM1BRb1Y4dnI2bWxKV0JsWmFG?=
 =?utf-8?B?WTBBbWlGR09hZ1E1ZXFNWDdjY2Q4YURtQTcwTm9VNk4wTkE4YzY4YjRQcDk5?=
 =?utf-8?B?Q2NIMnQyd2dyZEV1K3FTNkZ1RTNVOVZSdkY3Z0lZclhQZlB2TjhIaEhxSGdQ?=
 =?utf-8?B?T3ZJc0IzdE5WeXlIYXR0YlFzUHBQVkdFSldLRXlHRXdMeC9VcytaS1BFWXVz?=
 =?utf-8?B?WnI1Ui8zdTU4RVF4dzBKWEQrNTZ5Wld6aWk3amlzcE51MzhrTTJpRmpadnJY?=
 =?utf-8?B?bTViMCtjWVo1SVN4S0J1bE01N1h5RlZ3S2hRUlVZQVEyOWplSnhTOHhLWW84?=
 =?utf-8?B?R3U1UGxOSml4TDhuMWVEWTRxU1JQYUQ3dDVwNEdPbWN0cjFPZVRydWJMQjlY?=
 =?utf-8?B?cXdIcEMzMi8yanJWWEJxS0ZUbi9RZTFPS0pUL1JDWTJIZW9rVEhjVFdpZGdz?=
 =?utf-8?B?NFRFU3RLVG9ZOEZPNXpLV2FqUkxRbkQ3SWZLNitCRElweWdmNFpEQldyaUZ5?=
 =?utf-8?B?TVNPcUNadmR1SUI4cExEQkFiVm5BSmMyU0VBdFRkbElROW02akh6UFN1VDhH?=
 =?utf-8?B?YnRzWlZSaDQxWTg2TWR0UnFYYWg3K2NDRUlpNjRZeWdtUHVqNjFYakN5ZmRh?=
 =?utf-8?B?NGhVMU13YUt1RVVTWDhDNmdmVkFESXlsME9hNVd3WXFudVJYTlJkWUFCVm83?=
 =?utf-8?B?TlZnR0xZYm1xWkJPbUpGeE1sdEx1SmlQMHNGYkdHQ2IydmdPTlNPRTNPa2NK?=
 =?utf-8?B?eThkQ1ZaYmdBMXVEMnpNeVgzdnpwTUdLdVhQMW50MDRzSXo5dXFHc0dQWWh4?=
 =?utf-8?B?a1g3MTlPY3FzTVl6MWJkZHVVRmtybG1WUVZ1Q3RydUZVNmZoRHpOU0RwTmhS?=
 =?utf-8?B?UW1SNWhnR2xxcXJ2SUYwRFRXdlVCaVRORGo3S1B2YjE1Z1NCMU5YZGxEbFdJ?=
 =?utf-8?B?ODl5ejZwZE9VU0hDUFVTSjFRcmUxRDZkY2VUbTB1M2JTS3ZBUXBRMVlqQnB0?=
 =?utf-8?B?c0xsY2tQalJKeDYra0JJU3JJdFZVNnJyZ3YrQjM1eTgvUlZaLzlUN2R1aFcr?=
 =?utf-8?B?Yk5za01QNUovd3NVMWNOdGZsNmF5NmlNWjY2N2l5Zjh6clIwRk1KUmZkbzFY?=
 =?utf-8?B?TWZHVEx0Y05Vd0YwUmM0T2diRmFxZU9HWDhxRDhWUFU4NGdaYUZHdE1UWWJH?=
 =?utf-8?B?V1dtY2dsaFpQRXEvR2JEYnZibFdHNlE1NitlN21HTy9PYjU3Umt1NmhwcTRp?=
 =?utf-8?B?VGpxT0ZCOTdVdFc3RTEwcU9oRzkxVWlOOW1uK3NGamFSYkxwdzVuanF1K01C?=
 =?utf-8?B?ZnpVdWkrRVVlTGU0c2wzemZLVUJ5d2p6VGM0aXpSOHdCNm5rZHRhbjlNNkUx?=
 =?utf-8?B?RzFjcXhDd3FRSDNDeis5L25ldFdmZmV0TGppQlkrREg2K2MvZU1hWVZITmwz?=
 =?utf-8?B?ME9nY2ZLbnJHekkyQVdDTXJRRUtxbzhaekNnRys0WXhWYzNqMW1uNFlJYjdG?=
 =?utf-8?B?VjBQQ00wSFpFUTlLLzhWaFZwcytVK2dTU3YxRVdjWTBUaGpBcTRLQTlxMU1p?=
 =?utf-8?B?ZHdXc3hLVFdMWUtIUi9YWExtQXRwdzg2NE8wSEI4bVM5Q3c3YWNBbGhaWXJM?=
 =?utf-8?B?R0cyS28xNDYrVlRpdTVoWjh0TU9oclFDVE5VeWlockpTTVcyeHRabW1xYjF5?=
 =?utf-8?B?a3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F16082FE838F814FA6A5ADE16A20CEEC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01f1bbee-4aad-4829-d158-08dcc175fb55
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2024 00:12:45.1371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S8buT4ldOF262YP1801b8Euy/d4zf6FL8N1WdAEDYo87AtUEhOZaj/uumKgp8NaCHSl9eHH+AjNhZoQey42y/wmIZuqTjtX7YIJxNVJmJxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8588
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA4LTE5IGF0IDA5OjE3ICswODAwLCBUYW8gU3Ugd3JvdGU6Cj4gPiDCoMKg
wqDCoMKgwqDCoMKgZGVmYXVsdDoKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ciA9IC1FSU5WQUw7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKGt2bV94
ODZfb3BzLnZtX2VuYWJsZV9jYXApCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHIgPSBzdGF0aWNfY2FsbChrdm1feDg2X3ZtX2VuYWJsZV9jYXApKGt2
bSwgY2FwKTsKPiAKPiBDYW4gd2UgdXNlIGt2bV94ODZfY2FsbCh2bV9lbmFibGVfY2FwKShrdm0s
IGNhcCk/IFBhdGNoMTggaGFzIHNpbWlsYXIKPiBzaXR1YXRpb24KPiBmb3IgInZjcHVfbWVtX2Vu
Y19pb2N0bCIsIG1heWJlIHdlIGNhbiBhbHNvIHVzZSBrdm1feDg2X2NhbGwgdGhlcmUgaWYgc3Rh
dGljCj4gY2FsbCBvcHRpbWl6YXRpb24gaXMgbmVlZGVkLgoKWWVwLCB0aGlzIGNvZGUganVzdCBw
cmVkYXRlZCB0aGUgY3JlYXRpb24gb2Yga3ZtX3g4Nl9jYWxsLiBXZSBzaG91bGQgdXBkYXRlIGl0
LAp0aGFua3MuCg==

