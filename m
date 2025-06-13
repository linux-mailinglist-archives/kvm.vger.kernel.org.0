Return-Path: <kvm+bounces-49455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48B7DAD92A4
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 18:12:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 425DC189CDC8
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DD82204C2F;
	Fri, 13 Jun 2025 16:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OUIhOPsD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A563594F;
	Fri, 13 Jun 2025 16:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749831156; cv=fail; b=QbYEpZWyTafe3Hqzu0otMDGV9vfjK0+5bu0f3rQDBPNDXR5RdPyIoWMQ84ufCW9Qrxb2FVnJHoVuU5fkRyhuN6wM6pXc17p23EFdM4mfYvFdAFtPB5Un1Y7xbQr+PwFrNe5o/WXaCsfMGaPsSaEU2+PaBztaD+adDeEsd0MBTcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749831156; c=relaxed/simple;
	bh=y69vQrQioWZggFRcZuNpH7mZddBQdzJz/9HyZAdg8k4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jxmP92V3QwwWlNk8o7J0W43ytRShSyg6JlH37g6e3u3wMcNshcbExkP+F0C7lc9zZpX5DdujuI/wRXGPeIhhVFzCyin61BsgRnZJUlcZBO/TzxOI0RCVkIEIYh0AntgL5ENrkCf64c75Nt1p6faQ43+jN6645tsQvv1oQBVFRyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OUIhOPsD; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749831155; x=1781367155;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=y69vQrQioWZggFRcZuNpH7mZddBQdzJz/9HyZAdg8k4=;
  b=OUIhOPsDAuOZMwpfg6jJ9jMjY9Iy5KNlThbSjP9G2O2Vii1+xc4eQzKp
   AdOuiK1dhKFK5oY+bP/DYVHL89C4cht/xJY2rT1UJVl6/3PDsdzg1A3oC
   537AbHwxXts64aPKk/K2LwweTqHWAlgJIgX+eRmT2lbE6i0+XZLKLszGU
   D4p00xmD8CSHQnYeCsDGhu1t/TsKwEx62gqQQGoW0OLSaDa3DoU0CPyJB
   8r5BbRAW5MxdVQ5MTR+9v4nCY7dwsPcAJBfHQLQLdOLdEJTZTqCQAH7jF
   G3hT3d0eMKqGdEUzxZqkfJJYGJXU/aVLMqPTdB1UDarI95oKFGRk4uEvC
   A==;
X-CSE-ConnectionGUID: Uzuu8pWCQa2f8KtspsactA==
X-CSE-MsgGUID: 4Ftz0xMiQauE8iu6S+6LtQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11463"; a="77443853"
X-IronPort-AV: E=Sophos;i="6.16,234,1744095600"; 
   d="scan'208";a="77443853"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 09:12:35 -0700
X-CSE-ConnectionGUID: WX649qLuR1+K49d1zwp5Wg==
X-CSE-MsgGUID: 0dJ0INDcTn6EQVCmFtdFJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,234,1744095600"; 
   d="scan'208";a="152757134"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 09:12:34 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 09:12:33 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 13 Jun 2025 09:12:33 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.88)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 09:12:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ER+8STTppl9m2p+iExxNjacgwCoad6n0iKaG16rAQGIaM5VRdhLibX64YkPs0AVvckn+gNZ+wd9ggW6gmZP9VYEYb94aOju79rjAkXcQ/fhzpW9R+LTfaNGm2VRCG7KqILarpn6c8anPaTnzCyY21wyibS5ie8JUoWO1Q7OhV4vXQyEP8oScoRSkfoInZyp6ng+jCiT7GWgYa8hNRxuZBhHoUHPePJGOqfX4g6fBkKrp2jTfpked1mVdXr/HbPCTF0qB9S5V7K82S90XvFlpai6B8t3l9WrQX1eZnSOaLasumBaD7zegQ8TiT9O65blF6/3Pvzcvwv8PXaJKKhRqpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y69vQrQioWZggFRcZuNpH7mZddBQdzJz/9HyZAdg8k4=;
 b=ql5OFf17qAVDnY9Lkm9kaH09UHv0yukbUtHkhZuQFwyD1fduV/0ipEEgpfWzx7FAzPBF9UhuB0uYA2bXDcWRbmP9mUCX2jU+tbuuGYNQ2RQmMeh/A9q1lAI855Jhu9j/9XOJ6xctCtNYzgUGcoNxUS9fL6I+rodg5V0Q5JQk/gHb9Ahu0kksLnenTBiSpUoY4WVdIhYa2lfb7tBrI9rQkxvbnj7m+vXaaMQgt2hb+oINwoSrrY+gULICxV0wA6s20jhPHk6nENS7pCrkRlM1CQgJziwDL+GcLElWFjw1kUCo4HebhF+1+5OoDLVniocRcedlghp7sS5htJpvT6K+WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB8855.namprd11.prod.outlook.com (2603:10b6:8:257::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Fri, 13 Jun
 2025 16:12:17 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.018; Fri, 13 Jun 2025
 16:12:17 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Huang,
 Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for
 KVM_PRE_FAULT_MEMORY
Thread-Topic: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for
 KVM_PRE_FAULT_MEMORY
Thread-Index: AQHb2mYn9dWQDgvWTEqusObPtA6y57P+Q2SAgAEwtACAAGnwAIAAXAsAgAEM/AA=
Date: Fri, 13 Jun 2025 16:12:17 +0000
Message-ID: <c3cfd230eab895b186ce2bcbf404dc86f9874e15.camel@intel.com>
References: <20250611001018.2179964-1-xiaoyao.li@intel.com>
	 <aEnGjQE3AmPB3wxk@google.com> <aErGKAHKA1VENLK0@yzhao56-desk.sh.intel.com>
	 <02ee52259c7c6b342d9c6ddf303fbf27004bf4ef.camel@intel.com>
	 <aEtsPEnQTRBoJYtw@google.com>
In-Reply-To: <aEtsPEnQTRBoJYtw@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB8855:EE_
x-ms-office365-filtering-correlation-id: c431da11-08c7-4115-a69d-08ddaa951159
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?M2UzMjlJckRLWW5ZeUREK0xnZGg1dS9BZjZGczFFNE5pVnVXYkMzUjJSSjFr?=
 =?utf-8?B?V1c3dWYyM3JySGFWSmpzd2lmSXZCejVXK3p6bGN5Y21JSjJCWTN1OVA1YmRt?=
 =?utf-8?B?bkRUK3FxRThycysvSjdlS0hKd2JqUkxjNTMrTlZSUWx3WG9ObW1mUzJoemNM?=
 =?utf-8?B?QlF0MHpCMDVvakkyQ2VGK3lJN3dPc0tOM202YkR5S2hrWEpnUXdva3R6SmdT?=
 =?utf-8?B?OFF4UUdPQTFnWmxzQi9USWVHYncyZHpub2tUS0ljZVY2RXdUSkdXMWFBamJJ?=
 =?utf-8?B?V09qb0ZmQllCU3htTUJmMUptZ1NXL2ZRTnZaQmNHK09UQnEwelZweU9GYTU2?=
 =?utf-8?B?Ymxma2pZeGVYcUR0WWZabzRpcHI1US9RNytOSXFtNDZCVEdOTTRVMitWM3dE?=
 =?utf-8?B?ZWo0ZVBZb2NxNDBYTkVYS2ZvMURlQ2xpRUNERm1CTjFZOXFlcHFMZ2RQZVp3?=
 =?utf-8?B?RVhiell0Q04xenFjREh6S29nSjIvSDhaWG9OTDQ5MWhad0tSaVZKSmpLeDZl?=
 =?utf-8?B?N3JaV0RiMjVRMVdBME15eEd6cHpMQmRXUFF2R3BSbEJ1bzYveGg3SUxSeUFk?=
 =?utf-8?B?UnlISCsvdHVqN1k5Skt3QWE0YmFlVlNKTkJZbmo1WHpnbXFxVXFyMVcxUmw1?=
 =?utf-8?B?czczSXlhZ3JIZkZFOThhL2JIeHJEMEs0eUpvN3RuaHlxOUo4MmR2V0h0d0Y5?=
 =?utf-8?B?eG9mbW9NNEZRSE5ObDJualRyNlhmeGJpUGZMQmUyc1FmSlRXNmNuWnFjSVdM?=
 =?utf-8?B?K2JQV1JtSHNZaWprcEtST2JpcHpBOW94bnZkWWxrVXQ2RTc5SnNUWDNUZERR?=
 =?utf-8?B?dGJyT0ptRFBNa29wQlFyajVmT0VvK0xzRjB0RDdlNXIwOFZTcU9vT0F5SjBZ?=
 =?utf-8?B?TjByUU5qR1FFVC8wNCtYeWgxNDRINTZtSzRiTUV4dGFRdFRpRzAzaTlUUmYv?=
 =?utf-8?B?dmlSWmNVWHlwbzE2ZmE1eXlTZXRBelpBYkkySDBVWDdKYXRpdVRXSDZoRCtC?=
 =?utf-8?B?eW5mbHlDNHA0ZzNuWDNVckJJN2czNkNZdHI2emo2R3pjTDJqbHNGT1BZMGxs?=
 =?utf-8?B?Y0xGcTFtQWpSUGMySmJzSGpXdHIyZXFxaVZiZXVQM1JsZUlFZVNjNlM4R3pr?=
 =?utf-8?B?c1lkYmkzZnIzVVJTLzlLa05iK2NFT0g4aEZ6ejBleklScU9TTWQ2RUoxWjVS?=
 =?utf-8?B?ZmhhUXBlTnJzQkN3N0ZTWHBDUlV0dXNPSlNma3FOWDRJRWdQR3pCMUp5OWtY?=
 =?utf-8?B?UGZyQjVWaWoyN3hDNFVBYlNURmVrakp2L01FcVJqQUVyTzRCSk01bGVBK3c5?=
 =?utf-8?B?d2xJbGNKYzVwZ1MwU1ZLajN6R3NrbmxzN3FaWE5UTldYVmtwQWhuU0U0M2pQ?=
 =?utf-8?B?QUJqclVhdUtrUlNsRE1ybW1ZWjlTdElSNkNZQnVTT0lkbnQxY3JBOTFVWlhv?=
 =?utf-8?B?bUdURHVIV1QvUzhLR3JsVzluMnlMRFVCeURmNTgwamRXK0d4OW9vL1pzUFBP?=
 =?utf-8?B?L2s3VVl6MlI3VWRWMGx2SkR0MEgxaUExMy91cnlja2R3dVBuNEZsbCtmL1Yr?=
 =?utf-8?B?S3RKT1dXdGZFWmhHdThBN1FzNjIzL3VPdG5XY0xBMXBIZFlJejNsMVRjR3Vh?=
 =?utf-8?B?WFZOTFhEQkhTUE1uUmZhYnNWN1lHTEVaUGFldmlzMldzODFXWDZOb2lERjdv?=
 =?utf-8?B?dkNGK2h3aWRXbHdqVUdhTHRva2ZUQW52QmtxdXQ2NnZmM3V2bExJZEhPaHhZ?=
 =?utf-8?B?RWpsSTU1R3haV0FGZEN3QitwUXRVc1NmR0FFMmVZeXZFOFVTZmFIRzJnY2E2?=
 =?utf-8?B?T3RDSmRWUmxiY2s3Vk5rUXRlZEFKblJyTVlxQ0pRVUV2ZEwyckljTzdHQks5?=
 =?utf-8?B?c2sxdGNlZ0lYMi9sUmw2YzM1S01PTHZHejlJL3haVWUzNGZsWWZMbVVkdnNK?=
 =?utf-8?B?TFg0cWlZWERvcUd4bWVPazVjbmkvTmtmK1JqR1FNa0YyZEQ1SCtsb0hzdWpC?=
 =?utf-8?B?U2dscFFnRUVRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WW5YTGEwQ2svMlcrV09mbWJuQUQ1TW91dkh3b2dYYUUraFcxV0JFRzNuRXE2?=
 =?utf-8?B?N3hFSHVLNUNjT2ZLV05uYmszZ2ZRUUdFNU5Sbi81RTdhVzZmTnFhT0dTbCs1?=
 =?utf-8?B?d2QxNjZnYVlVOXFTTlFhS0RaMmZDNnh0Vi8rOWRzUm51WEd1ZW1sMjh3RTBK?=
 =?utf-8?B?QmZ4SElXTzBSblM5ZGZsWGRFMFJqUGtDU0toTGlXV1ppRk5sU2RianVOcDhD?=
 =?utf-8?B?L3dnRmVWREUwQ2FWTm1pTXE2MzloS04wbUZ3bWlEMy82bzZEMk5wNVBTb0sw?=
 =?utf-8?B?WDY4c1dFM2Q2UXJVdWtJUExIY2FYcFBYSVBIRG1kUVhTcmlIcHB3M2s1Q2o4?=
 =?utf-8?B?azlLMysySWVDQmp5N3c5dml5ZjRPTkhtenpFeDZUNDFkeHBLYjIzQXg5SHBk?=
 =?utf-8?B?bmNQT05KYlJxU2hBODM0WlQwQk5EOWgwZmQrdXV2RmJsQk1ORXRnRkVsb09l?=
 =?utf-8?B?WnlEQmxVWFBEMXAzTmRIaHdkUWJ3Ukx5SGpOalk0U2oyOHAveWlNSWl2aU0r?=
 =?utf-8?B?V1BJK3gxc2FPYmwxVWg4WWNRbHl1ZjV3dWM4RnZjZE1EakNEVGN6OEZyUDRZ?=
 =?utf-8?B?OWd4V3laT1I2YjhkODBMYTRPY2JuNDNIUEVUUnRQRzk0WHppbHF3KzVZS04y?=
 =?utf-8?B?N3QzSTQ4dTVsd2U4NFQxYTZjOVh4elhGN2hYS3ZSUmFWZTh5bndWY04wVlBp?=
 =?utf-8?B?VlI0U1B0SEl4Q1FMZVMvSXhsL1hMRDlkR1BXeGxZZjFIRU0rUG1JOTk4V0xn?=
 =?utf-8?B?RGFjRHJDRjlKQlhodUh0TXN2bzE5VCtuajhZSnd0bTErbG54TzdzcFlFZzFN?=
 =?utf-8?B?ZXEvNk01S2JCMERHUTVFeTloRC9SYlBPOVMzbDZoR3JrdE9QZFVVUXd0TCt2?=
 =?utf-8?B?Z0NzK3c2YkpWWCtVazRwdTRWbWc5dFBUMjE1bDFXZG5vdVo3YmpPZk1lWUhR?=
 =?utf-8?B?MlJBTEU2NmRxKzV6ZkpMYktxblV0TWJ4YlIySDdPcE90RjJBcXVtY2xWdGND?=
 =?utf-8?B?Z2ptNVhNNWxxNm1ObmkzZkoxUmhSZTVBekRDMnkxeFc0Sk1jbHJoMWR4eENG?=
 =?utf-8?B?WXo2eW9sMkc5Tm9rcngrMnFSNnpXbDB5YW9LYjNBQVdLTG05NFJpZzZuSGtB?=
 =?utf-8?B?NnI4RnVQdjZDS2QrRXVOUlRjZjFzaGdNTFlaZGljM0haejc1TTFZaEJVQXF3?=
 =?utf-8?B?ODNIYVA4TFE2RVIxM2t4cEgwemVmOTdhOUt3YU90OUNyRlpVWVB3VlNCWHZy?=
 =?utf-8?B?OFdYaU9IUUxKVXI4elpub2d5TUg4djZFRDA1Mk81Rnk0SndLM3J0dlJzOTZR?=
 =?utf-8?B?S05iTW1nRzRkMHNDYlV2ODRSVjEzc2VjQTZRbnBrQjdYUzgvc1dWWjVid1dv?=
 =?utf-8?B?SGNmSHFQOE5yT0JiaDVzN2dPRERwV05qVjB0cDJwZXVaRmozVjJXZ2Uvb0Jl?=
 =?utf-8?B?VzFudS9oSDZldEZOamFDemQ4YndiM1NwbGgzd2Jqbk4vU2QzUXhOb1ZZRGZB?=
 =?utf-8?B?UmFBTWkrMFZlWFRyWmhSeUhKNE1VR0hqd1VJWW5LNWZSdkUrWXk2ajNEWi9o?=
 =?utf-8?B?aW1SbFMwc01EK3F5MitnK0hVVzlxU3JBSGFQeHdtOE5FRlFvWHh5VFJFY2hP?=
 =?utf-8?B?UGhTNnpGejg0MWtaMFJyblA4dVdSUXhTaHBZUi9jRlpLNUQyUHk1QTlHVlpa?=
 =?utf-8?B?NTVHeTBPWGQ4YzdWMzQ4SEpCVDZ3R1NHL0twNDJ0ZDQwY0xHZTYvSm5ReWZp?=
 =?utf-8?B?VVgxZU5KM3ZGNXc2RHhINHR5bnNXdnYxVnJqOTNVWnhKR0pLSWJDVzMzTzh1?=
 =?utf-8?B?VFVlS0JITjg5dGJwRkVIcld6UnlrR3FtMDVKNHFxcXl0RTMzbitnZG05RXlp?=
 =?utf-8?B?ZEQzQzUzTGx1Umt3cEVjcmdzZ1g3V1JZSDZGUUM5OEhtbllyOUF1ZldxSHln?=
 =?utf-8?B?dkU4VmcvVXJBcTllalpMd05LUGgvazZWOVNNT2EzMzZ6UENxT2ZOTHNjZGVa?=
 =?utf-8?B?K0VWeVkrMGJJdFNRUFc4MzdMSWhWN0hQaDJqa01yMzA5SDc1c2RJR29uZmhi?=
 =?utf-8?B?MHByVWEzWVB2U092SzZ3c05zVkRRVldyRXV5eHRnWml1VWJiY1VWTlN4YzdD?=
 =?utf-8?B?dFhURlI0VS9sYml2TVJCVS9OMmpZRDVNb3FxM2Mrc0p6dGpoYjViQXZ4VVdh?=
 =?utf-8?B?SUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A37FFBE560609A4FB3CC70CADB2BDCF5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c431da11-08c7-4115-a69d-08ddaa951159
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2025 16:12:17.4132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iMraDKRZ3WHlCK+oLrfb2c1UIvSnTPX6usMyHRe49YGqWe2hlKakuHbtX1Fyn8IDgrrx2erVHZgfWLZD3UlnzzSxoWMJ/AkG+Tt/eFjhb0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8855
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTEyIGF0IDE3OjA5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBIGZldyByZWFzb25zLg0KPiANCj4gwqBhLiBUaGUgZXJyb3JfY29kZSBpcyB1c2Vk
IGluIG90aGVyIHBhdGhzLCBlLmcuIHNlZSB0aGUgUEZFUlJfSU1QTElDSVRfQUNDRVNTDQo+IMKg
wqDCoCB1c2FnZSBpbiBlbXVsYXRvcl93cml0ZV9zdGQoKSwgYW5kIHRoZSBAYWNjZXNzIHBhcmFt
ZXRlciBmcm9tIEZOQU1FKGd2YV90b19ncGEpDQo+IMKgwqDCoCB0byBGTkFNRSh3YWxrX2FkZHJf
Z2VuZXJpYykgKHdoaWNoIGlzIHdoeSBGTkFNRSh3YWxrX2FkZHIpIHRha2VzIGEgc2FuaXRpemVk
DQo+IMKgwqDCoCAiYWNjZXNzIiwgYS5rLmEuIGVycm9yIGNvZGUsIGluc3RlYWQgb2YgZS5nLiBr
dm1fcGFnZV9mYXVsdC4NCg0KSXQgbWFrZXMgc2Vuc2UgdG8gbm90IGhhdmUgdG8gcmUtY29uc3Rp
dHV0ZSBpdC4NCg0KPiDCoGIuIEtlZXBpbmcgdGhlIGVudGlyZSBlcnJvciBjb2RlIGFsbG93ZWQg
YWRkaW5nIGt2bV9wYWdlX2ZhdWx0IHdpdGhvdXQgaGF2aW5nDQo+IMKgwqDCoCB0byBjaHVybiAq
ZXZlcnl0aGluZyouDQo+IMKgYy4gUHJlc2VydmluZyB0aGUgZW50aXJlIGVycm9yIGNvZGUgc2lt
cGxpZmllcyB0aGUgaGFuZG9mZiB0byBhc3luYyAjUEYuDQo+IMKgZC4gVW5wYWNraW5nIGVycm9y
X2NvZGUgaW50byBib29scyBtYWtlcyBkb3duc3RyZWFtIGNvZGUgbXVjaCBjbGVhbmVyLCBlLmcu
DQo+IMKgwqDCoCBwYWdlX2ZhdWx0X2Nhbl9iZV9mYXN0KCkgaXMgYSBnb29kIGV4YW1wbGUuDQo+
IMKgZS4gV2FpdGluZyB1bnRpbCBrdm1fbW11X2RvX3BhZ2VfZmF1bHQoKSB0byBmaWxsIGt2bV9w
YWdlX2ZhdWx0IGRlZHVwbGljYXRlcyBhDQo+IMKgwqDCoCBfbG90XyBvZiBib2lsZXJwbGF0ZSwg
YW5kIGFsbG93cyBmb3IgbWFueSBmaWVsZHMgdG8gYmUgImNvbnN0Ii4NCj4gwqBmLiBJIHJlYWxs
eSwgcmVhbGx5IHdhbnQgdG8gbWFrZSAobW9zdCBvZikga3ZtX3BhZ2VfZmF1bHQgYSBzdHJ1Y3R1
cmUgdGhhdCdzDQo+IMKgwqDCoCBjb21tb24gdG8gYWxsIGFyY2hpdGVjdHVyZXMsIGF0IHdoaWNo
IHBvaW50IHRyYWNraW5nIGUuZy4gZXhlYywgcmVhZCwgd3JpdGUsDQo+IMKgwqDCoCBldGMuIHVz
aW5nIGJvb2wgaXMgcHJldHR5IG11Y2ggdGhlIG9ubHkgc2FuZSBvcHRpb24uDQoNCkFoYSBvbiAo
ZikhDQoNCkl0IHN0aWxsIHNlZW1zIGEgYml0IHVuZm9ydHVuYXRlIHRvIG1lLCBidXQgdGhhbmtz
IGZvciBzaGFyaW5nIHRoZSBwcmFjdGljYWwNCnJlYXNvbnMuIFlvdSBraW5kIG9mIGhhdmUgdG8g
a25vdyB0byB0cnkgdG8gcmVhZCB0aGUgYm9vbHMgb3ZlciBlcnJvciBjb2RlIChsaWtlDQpZYW4g
cG9pbnRlZCBvdXQgaW4gdGhpcyBjYXNlKSB0byBrZWVwIGl0IGZyb20gbG9va2luZyBsaWtlIHJl
YWRpbmcgaXQgb25lIHdheSBvcg0KdGhlIG90aGVyIG1lYW5zIHNvbWV0aGluZy4NCg0K

