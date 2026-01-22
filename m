Return-Path: <kvm+bounces-68871-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OESyIfP+cWmvZwAAu9opvQ
	(envelope-from <kvm+bounces-68871-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:41:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0678865648
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:41:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7B2258889CF
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 10:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC753D3311;
	Thu, 22 Jan 2026 10:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f31tLoKq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC98302147;
	Thu, 22 Jan 2026 10:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769078010; cv=fail; b=S0h/zYL55rBfDAxtasfGvisOsEcBtuA/J/qrkruSFHoq8S4JmmlsASnR2UgtMf1QfuK5ACoBYkukCxnN/EMHLCoIlqdTb+7Itjq5xei37FFRb6vI++d7Ls3g0X8SAmZUyN+QcFYS/2VRNxkKjQSALbEWQFAS21JkqHn3N36Ziig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769078010; c=relaxed/simple;
	bh=QpAbiYy0aBOBWrDfMNGOGqPtUOIbEKB11K5Y0kuvF1E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rJLFPTYYWXcmI5AAasnUsbI/pxq9MR408G4FsNUfpuwBgQRlAPzLxbhNjTIPWptro7MZu+dLdmfzOAmZst7myJQsf4OhXk1X6AwCJqZHo3LBHn9k+pMCESbFbcVySciSuIl5yIBOiurJYk3nKmEbKkOA1O8Ila6Vv6TGLo/qtgM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f31tLoKq; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769078008; x=1800614008;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QpAbiYy0aBOBWrDfMNGOGqPtUOIbEKB11K5Y0kuvF1E=;
  b=f31tLoKqR6Ze2Bz4oLTfvH6TmP5SR/1450L02VfOUiHXsJMu9Uv2dJit
   DSQovFFnFOVF81DwwghFiK1e5ZPhtf2fmcON8SQvY+S31hRccnyFuUndR
   Iirp622OuxZ5UlPmooP0ELepDHOb4RC3Q+2AfXPKiWvym4sziWGNEgjqo
   Y7aakySXBhYd0XYSfBy7VorPyk36hnqqd37QOc1OKu5eVj0Dkw8z+XA2n
   Sv209gSrILULrC2ii7W85H9JCEsdm1N0QwIhX+paTXxKjsupRxvxbeuPR
   9wWMm8+fChnOYKVPLp5ZhHOLAfmU/Mj5k+5DSc+kz7Myf7pLHq5+ioV8L
   g==;
X-CSE-ConnectionGUID: mUdpe8zmSiKjWwKTdqxAvw==
X-CSE-MsgGUID: h/U0RHzmTg6qs6pYGWRtcA==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="57881227"
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="57881227"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 02:33:28 -0800
X-CSE-ConnectionGUID: vS8+BotTT6uVJgJ21zRaHQ==
X-CSE-MsgGUID: IqsKgpwAShiPBFUcU/CsCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="206960682"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 02:33:28 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 02:33:27 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 22 Jan 2026 02:33:27 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.23) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 02:33:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AEIxQL270axlmC+qcQkVx5z7L9n1JemN17j6eO56Pmm3/i4BisOOcZM4InFKyq8Q9HUBZfAlkd6AsA91alwjYJ6APH4E0flYbcsltMWnUW7yU3j3guTZYnOpDwh4/i+G4cBBM8vumNlFRGDTXsCZutmd+pSQV4sWtwYdGFLV3yy7712ypeZhqm8EEHa30L7PnpQUdhl09Ne4/kuIxW6SBt4ZPwbOmLFvP8ct2MozjuHv4NcxZ8aKsHCw6hKpQqVFb/pu1bc3CcNO00V3/nHuTK8YBc5ECamLf9MCAGMd9VE8dEEWINVpSsC0LWXPvdwMbBtvI/jU1PhL52sXtsPkjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QpAbiYy0aBOBWrDfMNGOGqPtUOIbEKB11K5Y0kuvF1E=;
 b=H+kdV2H9Hlw5MNoF4iKEHUgq22D634S63WUh8tK3DQxB9ao/M6AnXLKH+tzJ1yBzbL1UzwlMYsk0AzBP8pDd37M6XlaAnezquLQcmBQHJLWaUYJr0xgxo9y6Gi586HW5HUcFavzaTCw1XUGr+mmAWqiV/Sa64U5YqcPtC35pZ5qCvseu74Ll8h77P/fQ5IFj6ULcj62VUc0pHPKp83tTkLptgy8OUf6zjodtSlxRzLsS5H7UhekiPeuqvLbijZSyf2InxsSfRTmWjS/UkNFSsUSLY5uTrwyOZzGTQFFrGHGna2hF3hqM0nBd+cTvVqGO/VQ+LN711v4dhTYg5qnTgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SN7PR11MB7708.namprd11.prod.outlook.com (2603:10b6:806:352::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 10:33:24 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9542.010; Thu, 22 Jan 2026
 10:33:23 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "david@kernel.org"
	<david@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sagis@google.com" <sagis@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 19/24] KVM: x86: Introduce per-VM external cache for
 splitting
Thread-Topic: [PATCH v3 19/24] KVM: x86: Introduce per-VM external cache for
 splitting
Thread-Index: AQHcfvbSydlt/e/FU0SaQnkHllxJ3bVb88AAgAEFlwCAAOMVAIAAB4kAgAAFfoCAAC2tAA==
Date: Thu, 22 Jan 2026 10:33:23 +0000
Message-ID: <dfe5cf919eaa922023da8f28bb6718756ad6eaf8.camel@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
	 <20260106102331.25244-1-yan.y.zhao@intel.com>
	 <b9487eba19c134c1801a536945e8ae57ea93032f.camel@intel.com>
	 <aXENNKjAKTM9UJNH@google.com> <aXHLsorSWHRslpZh@yzhao56-desk.sh.intel.com>
	 <8e025ab571eadb2a046e2dc1b53a92de6506ea01.camel@intel.com>
	 <aXHWn411DKY3fYWo@yzhao56-desk.sh.intel.com>
In-Reply-To: <aXHWn411DKY3fYWo@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SN7PR11MB7708:EE_
x-ms-office365-filtering-correlation-id: 4c4aa5e6-b882-40a5-3a74-08de59a1ab8e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?WEtSRjBRd2ZRZXRZaVpPSEtlS0ZoRzNoTSsxb2phd0Q5d0xhQzd0V0I5Tmxh?=
 =?utf-8?B?VkdpYmoxSU5EcEcyUHFsanZMR0RiYUJSYUFqSi9zTUh3OWxuMDFtb2lFbTFq?=
 =?utf-8?B?Slp3YWI5SExOL0RvZlp0S1hiaExOajR2TlkxNjRPaEFTNWdoMERSb0lmUnFB?=
 =?utf-8?B?RTVtckZvTkMxejRXTzF0aHhMd3NUQ0FKZjY4d1BWK2h4cHhCbmlWZUNGTllI?=
 =?utf-8?B?MmJCVE52anMvZjVxVjVKakt0VmcyTndGTnEyM3d5UGhtRjAzSGpGQVhEb3d6?=
 =?utf-8?B?ZTZOY2w1amdULzlNdTE0SDVkREVtMngwUlFSbEFDbm5NcTV2bEgxMlIycFFX?=
 =?utf-8?B?eno5VzBWS0VidGQrQ1hjVzRBWnFDM3BsL0w1QmtqdWU4Vm1uSnZSSGxPNC9Q?=
 =?utf-8?B?R21QQ1FQOFcwQ2o5SFVER0JJaFlCbEYvN21GTkltLzU5K3lBd1RXby9mMzdl?=
 =?utf-8?B?UVJwLzhpTFZYL2hFdmloVjhMWVFwLzVMNFMrL2d6WmVINGk3WURwZVhxcEM4?=
 =?utf-8?B?YmQ3QTJOOXhiVjIyNjlHWjFtTHdIMGp0b2FhbVF1Umk3M0xlY1g5b3YzTDA3?=
 =?utf-8?B?SDluTEFTWjVWSFhCRU0zVlpEYlBwNGJQdm1NM2JPeS96SE83enlNT0FHQkJ5?=
 =?utf-8?B?L3pVaEVIYk05eVFpQUJnKy9PVDA2Q2YzSWZ0MHpBOXNNUFk5Ui9nWjEzdGg3?=
 =?utf-8?B?bC85R0QvZGNZU0ZHMG1SVHYyeTNnK0Y4OUVxNUZIcy9yVGpMbm5Fa3phQXRu?=
 =?utf-8?B?Yklod25UVnJIYnE2c0ZsQlVFb0RLUE1HalBRU1R0c3dOY0IyQWl2V2UxT0pm?=
 =?utf-8?B?MEtmaUpJYW0yS3U3SzkyODIrSmZXNjVtN3ZJYTI4MXRvZVVKQVl3OEJkR3ht?=
 =?utf-8?B?dWtiOHRoU1QwVmtVZUFwMjFINFRBdzIzNmVocjdwT1dxY0Q1WmtoZnBpOE90?=
 =?utf-8?B?THFaUlB1YlQ5aTA5ZTVHdzdiTU1vc1ZTblFkejNvZjdlMmlaUjZpUjJjd0h5?=
 =?utf-8?B?aFhBMS9tNXpPZG5uVnU4Rm0xcHdrcUlENHl2TEN5MHpXamRLSFRDNWM5OTVp?=
 =?utf-8?B?NmZGWlJ3THNWOC8rbkNkVHdqM1hScUdncVR0NXBmMFlkS2V5VlNLeDRMREFY?=
 =?utf-8?B?SllXOFBmUUd2OUlGUmNGUzdEdGR1RHM3TW5Qb1FOS3pvQ0UrVC9JbzRXK2dS?=
 =?utf-8?B?bWswMGhobkRVT1FQZU5aR2VDN2JBT1V1NnhtNVJVNWJhbVNUdzZPaW1DempQ?=
 =?utf-8?B?L2Q0OXNZb2NCQjJTT3VSMGdjOHczSDE0dnIzWVVmRHF1SEtPNVhEL01PMWRI?=
 =?utf-8?B?eEdkTW9lZHUzQWNEc0h3MUFOUWN4dDBFa25velVQK3VzZDBiNHd4WnNyR0JF?=
 =?utf-8?B?d2ZwOWZIYUNuWGJrek5EYjZ5Ump5QVdnanltY0craEg2eFRqNDZIS291RWo0?=
 =?utf-8?B?ZXdhWXJVNWtKZEhIZDUrQVJGdFJVR3N2dlkxaXhyZW5ZYTBUNnJFaGFNWTJp?=
 =?utf-8?B?b0FhMnRmRW90d255VFNkNlBOc0VBeU9PU0JCSzFUUHNVVFZZd0xUcFI1SjFx?=
 =?utf-8?B?K3FJMUIyUGdHbDhjU3J2MlVVa3ZqTTZlVWNNSmdjQnZJZ1NnM3VQWE1FT1NH?=
 =?utf-8?B?SDJiMmZHYy9kL3BGQm1lUmFBdTlTTTdKd3lIbGMybTF2TjB2NklHNCtXYnBM?=
 =?utf-8?B?cGJCdVowZzBvTlFIM011SEVwSjRHdEdZNVJCZE9BNWd5M0swNXNEZXFnRzBk?=
 =?utf-8?B?bS9QRkVCTG9Id2Q3RlRsSEpCSjZGcUpBejJtZ2dGTmhtODMyZDhPbFlXL2Y5?=
 =?utf-8?B?QzJ1ZE9kMXZicWRqWXVPK1MveEtnZ3dnNDhGRHZzMEZpcWtFaDRkNlhUYjQy?=
 =?utf-8?B?cVdhdXhweEx4cEFkd1BPVk9UeWRqbndPK0xaaUtET3Q3SWp3TmlKTThkQ1Ev?=
 =?utf-8?B?U3ZGODlQQy94OSthdzlhSlVSU0Y4bENlVnl0SkdjdkRnVG5xY0NzRGI0ZmtI?=
 =?utf-8?B?YnExaUdkaERINEc4eXZFRnpodCtZWlBqUkMrcW55RElRZVVzbHd2L2U3MDhZ?=
 =?utf-8?B?bDI5clViOWdwS2FNMGwrcWlCSzdiODJlQWh3S2UzUjRiOHpYL1ZCUjk1SGw1?=
 =?utf-8?B?aGJ6dU0zWlQ1SDZCQmFtNkhFRmVuZytNK3hCOW8xR3RpRzl5aWFLMG5LTGQv?=
 =?utf-8?Q?M2ID+mELbbyacukWfG/52Jo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVphZjU3VXFSMmwxMWp4UE9wczgvQjEydjBhalhTUVRrcE1yNGFSdE1tR0hZ?=
 =?utf-8?B?aWhqaFBESEJ1WDkyMUlsazVxbHlSejVzbnEydldUNjNpTXFXMVdtWjdLTFo1?=
 =?utf-8?B?ZWN2c1hwMzlObnp4dkRtRXFrejJOKzVJbmxMeVlaaEFDMHJHeUw0blBFZmd2?=
 =?utf-8?B?ZmxSaldIVEFWYmlEenl0QTk1T0JseWxvWE1rRyt2Z2hTTmpjNTNnSVpwL0Zk?=
 =?utf-8?B?WE9KYWM3YTBzdjVObDJDMmU1L0dCZG4wR2ZHZjBxbTI1TTEybEJ1WnlUQUc3?=
 =?utf-8?B?aWNFak9EMmpmcVFKOElMOTZ2STE5clBTTEk0Sk5KYS9Eb2lvMlBLZ2RkYTZ1?=
 =?utf-8?B?NnpaQ2dvdWMzYWN5TmkyRGtXSTQwZXg5WElET09hSTZ4MTFwWnRxbUpMdXB4?=
 =?utf-8?B?b1FJMnFxU24zODhNQmZYTEgyNzdjNlNoVFZaT2Z1ZDkxWU9JaVdLaHRhWk5L?=
 =?utf-8?B?aUtnWWZ3RDdSMzRta1hWQmQ5ZllFeHBYRVFNSHVxZEx1Qm5YbDNGU1FwY3dB?=
 =?utf-8?B?N0ZpaFN1OHBEMmVNTlgrYjlBTTFiM1RRNk1nVERFcmtMWktSaFZzbEhKRUxP?=
 =?utf-8?B?cW5HRFpaRksvaDZ6RTExbmlyZmZBRmxQQkxLQ1FWa2NUM3BuU1JDM0I3Tm1h?=
 =?utf-8?B?Uit0V0ROSW9DK0M4WW1hdlNPcEFyZ0FNVjVsUmNjNUtvak9ZRUVEbGdLUHhG?=
 =?utf-8?B?VjZ2dW0wR1puSXFFUlNhdEprNldYTENWNHBiNHlNaFVadjgwQVhaYlZ1WFVv?=
 =?utf-8?B?cG1hMzlseTlmZHU1RnV1V2VFSFFNSGhVeHIwWkI3czNvcHV2cDlHcDFrOHll?=
 =?utf-8?B?blBjUHJhU1cvbU1sUWpGcld6dlR3NUdVMmJtMWxMZUQ4RXRSbGhROTJVbXRt?=
 =?utf-8?B?eDhlRXNwK3ZNQVg5YWFuKytYS2dCbENxMENsMlp2MU9BZW5vQllUQjJ5Nm8y?=
 =?utf-8?B?WnFmbWd4ZEM0OWZ0MmdHdWUzczJkLzRqT1orK1lmcGZQaktVWlRuMmRzZU5R?=
 =?utf-8?B?SUFKR0RHd0YxZm4yendKY3lKcit2cHlzYW5PMkUwUnhHY2RVWDJpMTRjR0Yv?=
 =?utf-8?B?YVNWOXU1OWk0N2ZyNXlYeDkwaGUyZk9yMUcwL01LMjhhNnpCZFlPZ2l2d1Bs?=
 =?utf-8?B?UTBmY1BWVmNrb1RYd1d5TlFsdTFuWVErYmUvRVFRUlBtVlMrckxkeUREbm42?=
 =?utf-8?B?UllvU3gwUFVZR0ZnN2o5WE14eW5aa3BLNi9ZR1E5Wm5PYmRHVklmZWs5V0Uz?=
 =?utf-8?B?c0JGMmliT2dXRHppbER3ZVNWbndURmJ3VGoyMlovUDBBcnpxNWc2bC9nZ2s5?=
 =?utf-8?B?cFg2RGpSQVNjRlkrWVgxQkJNVkQ4SXU1R2hTVTl2ay9BNU1vMElYMVpPR0hu?=
 =?utf-8?B?UWNGRFV3dXJ1YnJlUXloajNJTFBWS0IyZjFUaW5odG5FYWR2Rm80cEJTM3NL?=
 =?utf-8?B?SzdRbngxU1N1VnE5YWc1V2xlSGhLWmhUOUU1Wng4MmN2ZnRmRElPaGJUR3lX?=
 =?utf-8?B?VmxUWmJXSkpiejhUdWo1ejRlTGR4Z3hSeXZET1hXOUUwa1F0QWlGTGxtK0hn?=
 =?utf-8?B?NkdqaHFsVS85ZE1EQVk2SVp6RkZaQ3NvdUcxdUFLdHR2VVlMWTFlTlp4cG03?=
 =?utf-8?B?VHI1YjJ6MytiSEFhNWNDZmlnWXlhY3ZHTC8rRUVzbWp2ODlzQ3RVTS9YRDNy?=
 =?utf-8?B?OEk2eU05ZDlDRU1aZ3NqUXo3TC93K2E1UHptY2RGbHM4d0NlTC9iVUZkR21q?=
 =?utf-8?B?eGZmTmVJcDNKOGYzcTRiZjhvOWZodlJqNDVxWjlUMlRxT0ZlamFYN2tFUDBU?=
 =?utf-8?B?eTdCYWhPaTBTSXkrbktZRCtLK25wcFJOL3JKQXJlb0pFZ2FtSUpsa3MrTVFF?=
 =?utf-8?B?a0NhUnhwdWt6NG9zQzhWWmplc29ldzdQYXJFbVRDWTk4KzNZVFRtTnJCeS9s?=
 =?utf-8?B?M3ZiaEYrLzk3WlFKVk9vSCtaejQvMTg3M2VDc1hJUUVNN1lzaGtHc2t3ZTBL?=
 =?utf-8?B?eFpRempXb1RNQTEvZDg4SlFJMGRjUjFBQWoyYklJem9FU0dkRW1WZnJlVTNm?=
 =?utf-8?B?SkNpT1piVHNHUHhXbkVWSkFYYUpZTSs1L2I0dUFhYk9ZMFRDRlhLTlpIdDYw?=
 =?utf-8?B?Z3p1eHFtbDdBZDJiVkUzcm1NeUtWbWJZTVE0NGlzRkdSbkJ5MnVnVzl0OFF3?=
 =?utf-8?B?MzAzVkYzRVJyUGI3TFphN3gwMlZ6a0hBdFF0bUdzazMrN3d0L2h1WllvR1E5?=
 =?utf-8?B?ZGxLbTdKdHdRNFpTeDF4SnN6T2xzV3FmbnZZYThvbEx0c01DYzExL3daSG9K?=
 =?utf-8?B?UkpQb2M5SjhCNGZrS3hXSFRkRnVkUmpwZjlNUjJGbE9NVWVEa0gzUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8940B42C0362743B86EF84FEC00CE94@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c4aa5e6-b882-40a5-3a74-08de59a1ab8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2026 10:33:23.5397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +umHnMdBQL6dHJHcZ/44ZhKixr5zptEuoOdNdww65Sny1H1aSU5JyMg2vzRPL/Ag/JcHDD5cq2CzZ4gGsAWhng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7708
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.64 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68871-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	FREEMAIL_CC(0.00)[intel.com,vger.kernel.org,amd.com,google.com,suse.cz,kernel.org,redhat.com,linux.intel.com,suse.com,gmail.com];
	DKIM_TRACE(0.00)[intel.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 0678865648
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAxLTIyIGF0IDE1OjQ5ICswODAwLCBaaGFvLCBZYW4gWSB3cm90ZToNCj4g
T24gVGh1LCBKYW4gMjIsIDIwMjYgYXQgMDM6MzA6MTZQTSArMDgwMCwgSHVhbmcsIEthaSB3cm90
ZToNCj4gPiA+ID4gDQo+ID4gPiA+ID4gVGhlbiB3ZSBjYW4gZGVmaW5lIGEgc3RydWN0dXJlIHdo
aWNoIGNvbnRhaW5zIERQQU1UIHBhZ2VzIGZvciBhIGdpdmVuIDJNDQo+ID4gPiA+ID4gcmFuZ2U6
DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gCXN0cnVjdCB0ZHhfZG1hcHRfbWV0YWRhdGEgew0KPiA+
ID4gPiA+IAkJc3RydWN0IHBhZ2UgKnBhZ2UxOw0KPiA+ID4gPiA+IAkJc3RydWN0IHBhZ2UgKnBh
Z2UyOw0KPiA+ID4gPiA+IAl9Ow0KPiA+ID4gDQo+ID4gPiBOb3RlOiB3ZSBuZWVkIDQgcGFnZXMg
dG8gc3BsaXQgYSAyTUIgcmFuZ2UsIDIgZm9yIHRoZSBuZXcgUy1FUFQgcGFnZSwgMiBmb3IgdGhl
DQo+ID4gPiAyTUIgZ3Vlc3QgbWVtb3J5IHJhbmdlLg0KPiA+IA0KPiA+IEluIHRoaXMgcHJvcG9z
YWwgdGhlIHBhaXIgZm9yIFMtRVBUIGlzIGFscmVhZHkgaGFuZGxlZCBieSB0ZHhfYWxsb2NfcGFn
ZSgpDQo+ID4gKG9yIHRkeF9hbGxvY19jb250cm9sX3BhZ2UoKSk6DQo+ID4gDQo+ID4gICBzcC0+
ZXh0ZXJuYWxfc3B0ID0gdGR4X2FsbG9jX3BhZ2UoKTsNCj4gT2gsIG9rLg0KPiANCj4gU28sIGlu
IHRoZSBmYXVsdCBwYXRoLCBzcC0+ZXh0ZXJuYWxfc3B0IGFuZCBzcC0+bGVhZl9sZXZlbF9wcml2
YXRlIGFyZSBmcm9tDQo+IGZhdWx0IGNhY2hlLg0KPiANCj4gSW4gdGhlIG5vbi12Q1BVIHNwbGl0
IHBhdGgsIHNwLT5leHRlcm5hbF9zcHQgaXMgZnJvbSB0ZHhfYWxsb2NfcGFnZSgpLA0KPiBzcC0+
bGVhZl9sZXZlbF9wcml2YXRlIGlzIGZyb20gMiBnZXRfemVyb2VkX3BhZ2UoKSAob3IgdGhlIGNv
dW50IGlzIGZyb20gYW4NCj4geDg2X2t2bSBob29rID8pDQoNClRoZSBpZGVhIGlzIHdlIGNhbiBh
ZGQgdHdvIG5ldyBob29rcyAoZS5nLiwgb2JqX2FsbG9jKCkvb2JqX2ZyZWUoKSkgdG8NCidrdm1f
bW11X21lbW9yeV9jYWNoZScgc28gdGhhdCB3ZSBjYW4ganVzdCBob29rIHRkeF9hbGxvY19wYWdl
KCkgZm9yIHZjcHUtDQo+YXJjaC5tbXVfZXh0ZXJuYWxfc3B0ZV9jYWNoZSgpLCBpbiB3aGljaCB3
YXkgS1ZNIHdpbGwgYWxzbyBjYWxsDQp0ZHhfYWxsb2NfcGFnZSgpIHdoZW4gdG9wcGluZyB1cCBt
ZW1vcnkgY2FjaGUgZm9yIHRoZSBTLUVQVC4NCg0KRGl0dG8gZm9yIERQQU1UIHBhaXIgZm9yIHRo
ZSBhY3R1YWwgVERYIGd1ZXN0IHByaXZhdGUgbWVtb3J5Og0KDQpXZSBjYW4gcHJvdmlkZSBhIGhl
bHBlciB0byBhbGxvY2F0ZSBhIHN0cnVjdHVyZSB3aGljaCBjb250YWlucyBhIHBhaXIgb2YNCkRQ
QU1UIHBhZ2VzLiAgRm9yIHNwbGl0IHBhdGggd2UgY2FsbCB0aGF0IGhlbHBlciBkaXJlY3RseSBm
b3Igc3AtDQo+bGVhZl9sZXZlbF9wcml2YXRlOyBmb3IgdGhlIGZhdWx0IHBhdGggd2UgY2FuIGhh
dmUgYW5vdGhlciBwZXItdkNQVQ0KJ2t2bV9tbXVfbWVtb3J5X2NhY2hlJyBmb3IgRFBBTVQgcGFp
ciB3aXRoIG9ial9hbGxvYygpIGJlaW5nIGhvb2tlZCB0bw0KdGhhdCBoZWxwZXIgc28gdGhhdCBL
Vk0gd2lsbCBhbHNvIGNhbGwgdGhhdCBoZWxwZXIgd2hlbiB0b3BwaW5nIHVwIHRoZQ0KRFBBTVQg
cGFpciBjYWNoZS4NCg0KQXQgbGVhc3QgdGhpcyBpcyBteSBpZGVhLg0K

