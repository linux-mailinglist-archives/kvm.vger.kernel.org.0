Return-Path: <kvm+bounces-68772-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QNJ4KTwycWlQfQAAu9opvQ
	(envelope-from <kvm+bounces-68772-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:08:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D1185CD8E
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:08:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C1E397850DA
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E4A3D3CEB;
	Wed, 21 Jan 2026 19:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OsMrS9kk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CCD26056A;
	Wed, 21 Jan 2026 19:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769024385; cv=fail; b=Bt35nkdzh+sTb1irmE9PtgGnC2yKYtSumXvElJpwTYFP9pC3uf/kohoNFQXOzWQO8WalvqVJLJhRZJgnI6TigVIbWX0Bly4uFoSytoF/ndyqi2e1Viv0tHlLIZIBlnrZ4sUT06PApcJ/xqCfnJvJ97Gnn20FQLoZwunRcrACdCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769024385; c=relaxed/simple;
	bh=0aLeF6vipz1Dwwct4QjMl9oZn/RP/nYBgpH+JfQS9NE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k94pOZ1kobo3IIa3HxmSEUjlTYPZ5kbwX+m24+nJ2ZKO23kPELbNJ2wDwGfYFTNrX58YI8aydO4AKTsC6+m+1RWfOUOI+iQLDLcBySJ5kRgFZ1snCLCkIJSUMv8xBSTkvie8rh/NJizhyZckm8x+VadBmZSZWKfhCXG6IxgM0kM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OsMrS9kk; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769024382; x=1800560382;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0aLeF6vipz1Dwwct4QjMl9oZn/RP/nYBgpH+JfQS9NE=;
  b=OsMrS9kkFuMnfcZqBZZ7zPi0TjAUVzcVdl9y35cwO5yYnneIaJE85BVJ
   T7cAkLOsNdhJIQXrilGFFhz8DOk31rYBiwhWsfst3pTe1b6PDCpkxZMHS
   wjFBeR7zyTaJHI+y+8G9CeyPLbYSSa4n9Rq8AZkB2FeTTJSXnJgrja96A
   Hp05A8ms1bFi89Z2t0DLB/1JQty5PpqdgpkKug+nFXEXEIu/clIkrh9iE
   0P54AY26tdqfh5sWgncmWRGk6FcnFb33gA1/414kAmTCD3KhObeXZ1yxV
   nKEa/h73dfEAfnfvNGeapMyR8LLWiSVmqjNFg6E+UO/x1RiRA4GqdTvnU
   w==;
X-CSE-ConnectionGUID: aDRucIi3SouZ+XXR/WcUkQ==
X-CSE-MsgGUID: fDBmTFrwRbOs4y1dtWfvlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="69456585"
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="69456585"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 11:39:39 -0800
X-CSE-ConnectionGUID: j75JzR1MT222NY1HdEI5EQ==
X-CSE-MsgGUID: qZMjZMHPRq2kMJ46L3xS5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="206960993"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 11:39:40 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 11:39:39 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 21 Jan 2026 11:39:39 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.15) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 11:39:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QU/4cE0icxP/UduhgvHfU8a56UISmJjJrW/OELImEPnL7aEmt+1Ni4KPtvLJCROomjuPogNT+THf9HBMYkJrs5JCR9ODfBOJVVYgPVcqz7M76xKJ4OieGqdyb0AJJ+mhTMPT1HcO1Polz0WgYb7ZOjQqpdEk2zIZvwP8E8ImuaCjbSVwIRBe1qobfUoGilygZW34JKc1iY1l6rtW2KmF9P9Qiqtww8jFLRSlX0VsclamirguTX+7g+EZMVfQHKTMGutbKi0eLsotJDgPI8XaWMlbC0E3L7+dCEXZ8rOqZ8yIPGGYYAnEIkbDCECEK5iO1YybGKW0dM0ORp5G2sq1hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0aLeF6vipz1Dwwct4QjMl9oZn/RP/nYBgpH+JfQS9NE=;
 b=M7nt7uURbVBXsxiSUTK0VMG6/CjQoo+I5fRpWRpWXnpnu1XduOktTEuCeMihsa2y2SWdu159/uP5vHKI3byeB/aRk93VTC3LJMq8vHZUnJ7oFHMAGL4EcO/QAlThpJs368ZZV+uie7Q7qMkf9fYBs3G5+jtpdMdQrHZ6+CMBet5ZFNq85kSUNyuuvH+FcgdLy9OxYawLn826rlzq9bhez7/RxdKPoWwpv5D6PrhpWTKhUmwnKMWM5y+nRgn6K15EMCW6rQSGxAG5H1bC9qp9Gv9w5QON4l6sVvLPJY5gPDEm7cTX3k7mw2ity1m8a60xdAJ7njsYMfr5vEM2QwrtCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Wed, 21 Jan
 2026 19:39:36 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9520.011; Wed, 21 Jan 2026
 19:39:36 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "david@kernel.org"
	<david@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "sagis@google.com" <sagis@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "Miao, Jun" <jun.miao@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jgross@suse.com"
	<jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v3 19/24] KVM: x86: Introduce per-VM external cache for
 splitting
Thread-Topic: [PATCH v3 19/24] KVM: x86: Introduce per-VM external cache for
 splitting
Thread-Index: AQHcfvbSFt+gau7sOkqhXaKVAfqmOrVb88IAgAEFlQCAACQTgA==
Date: Wed, 21 Jan 2026 19:39:36 +0000
Message-ID: <1cf13a8929e7087087fdafad09ec736f204eb1a7.camel@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
	 <20260106102331.25244-1-yan.y.zhao@intel.com>
	 <b9487eba19c134c1801a536945e8ae57ea93032f.camel@intel.com>
	 <aXENNKjAKTM9UJNH@google.com>
In-Reply-To: <aXENNKjAKTM9UJNH@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB5214:EE_
x-ms-office365-filtering-correlation-id: 04676001-bd3e-4d34-4dc3-08de5924cf21
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?STRaUVVueG5GQ0FRZ2FDK1VUL2pWWGtHQlBsdENmQjJVaThiZ0VZMzBUL1pD?=
 =?utf-8?B?dkNzK3JHR0xDTHFDVzNvV0hwTDZqRTN1UzUwU3ZYbVVCWXY4ZlVDTXFCNC9N?=
 =?utf-8?B?RGx3RW1PQ2dPNjBxVkdZcG52Q3NuMndvRnJEUUt3RU1wYnVmeDR6VXFtTGFz?=
 =?utf-8?B?TUlTVDNTb3YwL2FCOEJtQ0pZMlQ0L3RRZnFkTk1XVDFsblBQaFBXMDlkVWo3?=
 =?utf-8?B?N0JDUzlkc1pkTFlwSmQ3TlpPbTNJZFRPRjlDOG02VHIxZCtpamtrTW5rdnJh?=
 =?utf-8?B?Nk9EOVM4djdmSXY3NUpmWlJSM0RacHpkMkExSEZCN0FVRVNyOGdvSWlHa0x0?=
 =?utf-8?B?Z2JxcTBqazVseGgyNUdqWTEwTEtBRGZpcnRBK1E2d2pDUjEyODdPSndqcW5Z?=
 =?utf-8?B?WmZBejlrNnpsRkJmNVoxZ3VIOE1vUmVDQTRnTEc5RXFoNXdOa2drK1dCdEJI?=
 =?utf-8?B?a0lXaDNkSGF5RnNZZklpL1hDT2x6bWJnd1l5R2hsam9pSFN4SkNJMFlTZTNJ?=
 =?utf-8?B?MWJWMG5uSGVNcVNUYmZFM01zM1dUbXlwNFc4RFYwMzZFWHdKWGpmNUpNemZq?=
 =?utf-8?B?bUF5L2xSL1M4ME5pM29NTExYZ3B1YXJtNTFyRFZmdzViV2hNUkVIaytHSFJH?=
 =?utf-8?B?ZGdydG1aVVd1R0Fob05xdDAxaFc1UnpJcWZudUtjb3d6RmdtcmUzMDBZS3ZN?=
 =?utf-8?B?bnNHbXVPN1NxdDR3QkFpdnNOTVJESTZJOEh1Z3VoZWlyMlU2Vzd3clJMSEYw?=
 =?utf-8?B?WEtjR29xVjNnODBwRGFNbWtpV2lPaXRUMnVoNjZhMUswcFhsTnJIWXE5ZlZ4?=
 =?utf-8?B?RG55dW5wOUtXR2Q0QnA3V3Q4eWczMDFJQmFURGJnY3U0RWNEN3V2QWNCajht?=
 =?utf-8?B?WXNYeVJGMFh5NVNneVlvNVJ4aHNvdkpWRldZZWJtNFhZRWF1aWkyTTM5QXNU?=
 =?utf-8?B?dWRXZ1hXYlhiYm1OODFQQnJDdnlwN0dCQUxZMWExbFpoOFJPYWVzZFBYQUxW?=
 =?utf-8?B?WVZtNTlOcnBJSEF3ZVgrU2F2cjN5d0V3WFpUR2xnZFFqQVprSS80OEFPekV5?=
 =?utf-8?B?dC9vRU1pYnpnS2FZTlpEci83dGE5bm9sWEVyVlIwMlRmNGRVbXRPOEtIS0I3?=
 =?utf-8?B?M1lxVTZyaWgxRFJIaC9GWG8xRjZlNHAvSUFFYlVCMVBORUxGWWhEMmlPdnEv?=
 =?utf-8?B?VUljd3d1eUVqdDUvdU5MMko3TDRYbHdmcFNWb1RpVU9TZXhDSGk1NDd4NS9T?=
 =?utf-8?B?Mnp4RFBlVEdEcTIzV0lqQTY5Z05VcGJaS3lHY3lWTS80bDA2bW42cExlUHhX?=
 =?utf-8?B?eXp1d3ZqRGhITmlVWm1Qbzg1eW1GNTVFc1dmb3c0eEV1aExCQWoyaHlDZXpx?=
 =?utf-8?B?MUNSNjhudktaZCtpREhYWUJVbGt6LzgvTjNkQ1RZSmwwbExqdVdPWWk0QVVN?=
 =?utf-8?B?anJJRDUwWDBhMXhoRU9mb2U5S0IwalBTaVdrVFhLc21HNkh4T05OOThqNzYr?=
 =?utf-8?B?WkJRT3RFRGhGeHZ1dnVWQ1hEblk5TTFIUzkyWmhyQ3lZQVFTTUg3SHh0OGlV?=
 =?utf-8?B?S2RUSGdkeFNESHBDYU4zYVRNY2pmNnRicWNLZWVmV056RmlDREorY0xOdlFT?=
 =?utf-8?B?TlpxQTVDazVKa2NNYTBsSG9SNkVrblhQQU9nZlBSUHlwRlM4U01Lb09TN2F4?=
 =?utf-8?B?N3B0RXo3SUJaai9LWnM2VkR4cU41TDAwa2M0S1YrUXlzY2xkQ1lCVWF2bllM?=
 =?utf-8?B?WjBqVUlZeG1ZRDcwNnFJdFhQQ2RBQXZGUy9lTWw5d3hMSUdzdmZtZWFxVDh0?=
 =?utf-8?B?T3BCYmVSV29RT013QjRGMzdEakdlcVVhN3JqU2s4ZndQWlRGdk9Jd2MvaVBJ?=
 =?utf-8?B?cDZhd2E2Y2RMelo0NFAxOWhVQ2hTYkFCdGdKb3JqclhrSWtDNS9GTVQ2TXQy?=
 =?utf-8?B?VStDWnd5bTcwQ0s1d2dDbjhWaEZmTFFlY2txTktuN2F2ZE9ZaHFaajh3RFB6?=
 =?utf-8?B?cG5IbGNXNmFwSGVjV0E1VWdqZVdtb01aNG9VRmFkV3E0TXhzaGlKYW5TUmgz?=
 =?utf-8?B?YXBveVNlWC94RUtLYUpoNW5pTzhBUVU2VThibVFZMFlGaVo3anZjVHd1cHIw?=
 =?utf-8?B?azNpNDhOZ3VsdUtBMklsbDV4NjFNeUtDZjV5alk0aUpiWi9uQXRrdlNqbFdY?=
 =?utf-8?Q?Sm6X+nW8YRP4vvC1cnOwLJE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXkwZnpsV0YwUy94VUhkMHFMMDAvQ1BBTVBKZ3I3MkJVNjB6RlovRU12MHBp?=
 =?utf-8?B?ZVgrMkVnWFV2QmY4SjlQSkJuNVI4UStlYzZXbFdjbHY0Rm9maTZaUmdvUHdE?=
 =?utf-8?B?SXpPYk1EejNlMWhhOU0yMUQyRnBBV014SjRiYmJSS0ZvK1poMittbmtPSUpG?=
 =?utf-8?B?RVMyRzJ0RS9ta3VsTjV1d2QwaWU1RmxIaUhUc1ZuTzNkNG5rWnREaUF4VUNC?=
 =?utf-8?B?cEt6MlB1WmgrMll2cDVVL0ZxcVR1dGx5SkxHNnkzYStQOEcyUnpsSTZyVWZJ?=
 =?utf-8?B?ZjN6UnV6QWFrc2lGQWxXOGU4WU9ock9nWTdwSDgraUhkSDQzeGkySzBNeXFC?=
 =?utf-8?B?YVcvUmZiQ0ZyM01jaUpxVnlIbHpLbGRsdjZ4ZTFkN2VkT3dkWlc4SjNSV0hK?=
 =?utf-8?B?NGVhbHhlcHNvSnRmcDlJaVJ4MmRtdGRoV1A1UVpYam9aUWczM2JUUEt0dmVU?=
 =?utf-8?B?Yk1NYkJZbFg1ZTN6TDRkL1BDQXpsYmQ5NDh1TE5aWDFkWFpZdUV6NXBQemZD?=
 =?utf-8?B?clhzblVPTWNLUm04alh0NUw2cXdOQzJwdUFZSksrVXNPbjhRWTkvbGNkanRl?=
 =?utf-8?B?M2YzeW51a3c1ck1wZWZFVVk0bTU5MkVmRmJZaCt3RzJVSGZRQXE4bldCZ01H?=
 =?utf-8?B?T2srbHZ2elFoYVhzNzhOcXcyZ2pDVnFyOThBRDFwRUpVY251NmI4ZWJNZ0dN?=
 =?utf-8?B?TmpxTFJRb2t2K0Z5UktjTHI2NEVBcC9NZk5BS2RXVk1QTTl6aFFNTXRYdm5r?=
 =?utf-8?B?b2tUSjF5RjVzR3EvaGI3cU1rNUtQYmdvRHppdmdkK1ZiYTVoczEvWFRYZHRV?=
 =?utf-8?B?dEU5SDRlVnBERWhNdS91clpxSWNTZFRPdndWdzFTZjU4a1MvY0Ftd3c5akd1?=
 =?utf-8?B?a0RHUzZRWFN3dDUzek5KUTNtWldhbjRhZUJoUVpWcFVKcGY3K2RwUmR6MWNw?=
 =?utf-8?B?ekQ0aW1yZ01kYm1JUjRwem5nVFJJZTUva0dEZmp6bWszbUsrZmFjY0NOVjN6?=
 =?utf-8?B?TS80aDdvNzdYbUkvVlpOZnhzMVhSRnVod2tScy9nNXdZck9rL3h6dy9xdmhE?=
 =?utf-8?B?UzJaTklrRFlUOFNNWkNnSGJJLzV4bngrNXEyL0J4cUZreS9UY0sxMWpiemZR?=
 =?utf-8?B?eEsxSWRzV2syb2Rhd29YRFlIaE1BOEJwR21nMXpramhtM1JtSDF6VlQ1ZFhE?=
 =?utf-8?B?dzk5aGZUaytkOXF3RW8wbXlNOFdmSVZscWFpYU5TcVRHWEpJZjA4RXJmN3B3?=
 =?utf-8?B?ZUpreXp3YlJnWFNLWk1yMFhLRXBMOXdQTXFVeFRVVXhMK2xMYWg0UlNCN1VL?=
 =?utf-8?B?NUVvWTF6b3RIMFk0UHhlNTR2YWlKY3A0RXJoQVFnNmZjYmdzTnNrVVlUbnpV?=
 =?utf-8?B?N3BML3V6YzM3dURLdVZ0Qm01b1JxUm9Na21Cc3FVUkxpS0FjcjN3SGREaTdu?=
 =?utf-8?B?V1FsUC9uMS9sUnEyS3BRZjh1SGljelM1WStlUmJjS0kxaU5tSEVrM3I3ZGJ6?=
 =?utf-8?B?eFBXZ3F4MFhZOThvUlcvZGFLTkhvN0JTZzVCZlUvQ25YbkFtZTczUzI3MGpM?=
 =?utf-8?B?Zy9vVnkxYktiNVlrM3kyd0lsSlEzQjQxL2tFaGtnSUllWFUzNWgzSFN3M1RZ?=
 =?utf-8?B?ODJMSDdCNmF6elVXUk56eElXd2NveVRQVUZCZWNYV3ErOGtJRUthc2Zpc3FF?=
 =?utf-8?B?L08rajVUZ015cjQvSUpIczE2WUVLd0ZrYVl2byt6VGk2ZzZXb0xaaDZBZjhO?=
 =?utf-8?B?WVZ5bUcrWTFPSG1MeGdlSFNDS0YzQzBCU1FBdThTby9qd2E4SzVueUtCemVk?=
 =?utf-8?B?S1l5eGltWUp2RkJ3YzhXYThRaXUxVlBKQ2NDSzJHM0xhWGFNc1N6NTd6eTRV?=
 =?utf-8?B?dVNDOFMxWEdnVk9ZVFRRa0JkNzRaSS9mZVM4akpEdHoyOGpOQzg4by9LSTJ0?=
 =?utf-8?B?ZnNuZnlDeG82bDdzOTFuYlhYSUl3cXZncm84QVptbkNDbjAvMmh6VnYySE1M?=
 =?utf-8?B?YUVjclZ0UWg5a3ZGempxVlhneGZyc2d4bmtva3lUSHFwUThxbVVKOGxkdG9k?=
 =?utf-8?B?a3NPZ3RONDZ6MXI0MEtPZHJPMUQ4YTQ1eDZEWWxGdkVHcm9jVmI2MldaVWls?=
 =?utf-8?B?SFdqb0hHa2Z4ODFMeHFvcXlMN1o2ODJzRUxrZ25iUmtkdFg1THVVWVB3TWZU?=
 =?utf-8?B?U2FIaUJyai9kK3djR0xyU2RDc3JQRG9kcjRMZkRUTVF1K3N3bEFRU1JkajNG?=
 =?utf-8?B?S3VVNXZuaWFkZVdqVFYrZUxtQ0JjeUNWRnBTRHU4dlJnOGFucm84dGowN0tC?=
 =?utf-8?B?V05DYmREa0FXcFJRMWk2Q2RXeXVjNDJSMi8ydTZyOVk4YlNIUFhkRm05WjJo?=
 =?utf-8?Q?RCeGCUWr+qc30YcA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <340FA2206DA789438B753925BE79C8FF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04676001-bd3e-4d34-4dc3-08de5924cf21
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2026 19:39:36.1189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zx/VM0TeFC8v5mhRkUHL0H2yhvqgPVvPrUCY3w31dv97IiEIaN4S4Ac+bEKE5r54/kzZyMBwYNBm3l7YM3WweGf2GuZTQ79NykxqSpvfaBA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5214
X-OriginatorOrg: intel.com
X-Spamd-Result: default: False [1.64 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68772-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,intel.com:mid,intel.com:dkim];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,vger.kernel.org,amd.com,suse.cz,google.com,kernel.org,linux.intel.com,redhat.com,suse.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[29];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 6D1185CD8E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

T24gV2VkLCAyMDI2LTAxLTIxIGF0IDA5OjMwIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBJICpMT1ZFKiB0aGUgY29yZSBpZGVhIChzZXJpb3VzbHksIHRoaXMgbWFkZSBteSB3
ZWVrKSwgdGhvdWdoIEkgdGhpbmsgd2Ugc2hvdWxkDQo+IHRha2UgaXQgYSBzdGVwIGZ1cnRoZXIg
YW5kIF9pbW1lZGlhdGVseV8gZG8gRFBBTVQgbWFpbnRlbmFuY2Ugb24gYWxsb2NhdGlvbi4NCj4g
SS5lLiBkbyB0ZHhfcGFtdF9nZXQoKSB2aWEgdGR4X2FsbG9jX2NvbnRyb2xfcGFnZSgpIHdoZW4g
S1ZNIHRvcHMgdXAgdGhlIFMtRVBUDQo+IFNQIGNhY2hlIGluc3RlYWQgb2Ygd2FpdGluZyB1bnRp
bCBLVk0gbGlua3MgdGhlIFNQLsKgIFRoZW4gS1ZNIGRvZXNuJ3QgbmVlZCB0bw0KPiB0cmFjayBQ
QU1UIHBhZ2VzIGV4Y2VwdCBmb3IgbWVtb3J5IHRoYXQgaXMgbWFwcGVkIGludG8gYSBndWVzdCwg
YW5kIHdlIGVuZCB1cA0KPiB3aXRoIGJldHRlciBzeW1tZXRyeSBhbmQgbW9yZSBjb25zaXN0ZW5j
eSB0aHJvdWdob3V0IFREWC7CoCBFLmcuIGFsbCBwYWdlcyB0aGF0DQo+IEtWTSBhbGxvY2F0ZXMg
YW5kIGdpZnRzIHRvIHRoZSBURFgtTW9kdWxlIHdpbGwgYWxsb2NhdGVkIGFuZCBmcmVlZCB2aWEg
dGhlIHNhbWUNCj4gVERYIEFQSXMuDQo+IA0KPiBBYnNvbHV0ZSB3b3JzdCBjYXNlIHNjZW5hcmlv
LCBLVk0gYWxsb2NhdGVzIDQwIChLVk0ncyBTUCBjYWNoZSBjYXBhY2l0eSkgUEFNVA0KPiBlbnRy
aWVzIHBlci12Q1BVIHRoYXQgZW5kIHVwIGJlaW5nIGZyZWUgd2l0aG91dCBldmVyIGJlaW5nIGdp
ZnRlZCB0byB0aGUgVERYLU1vZHVsZS4NCj4gQnV0IEkgZG91YnQgdGhhdCB3aWxsIGJlIGEgcHJv
YmxlbSBpbiBwcmFjdGljZSwgYmVjYXVzZSBvZGRzIGFyZSBnb29kIHRoZSBhZGphY2VudA0KPiBw
YWdlcy9wZm5zIHdpbGwgYWxyZWFkeSBoYXZlIGJlZW4gY29uc3VtZWQsIGkuZS4gdGhlICJzcGVj
dWxhdGl2ZSIgYWxsb2NhdGlvbiBpcw0KPiByZWFsbHkganVzdCBidW1waW5nIHRoZSByZWZjb3Vu
dC7CoCBBbmQgX2lmXyBpdCdzIGEgcHJvYmxlbSwgZS5nLiByZXN1bHRzIGluIHRvbw0KPiBtYW55
IHdhc3RlZCBEUEFNVCBlbnRyaWVzLCB0aGVuIGl0J3Mgb25lIHdlIGNhbiBzb2x2ZSBpbiBLVk0g
YnkgdHVuaW5nIHRoZSBjYWNoZQ0KPiBjYXBhY2l0eSB0byBsZXNzIGFnZ3Jlc2l2ZWx5IGFsbG9j
YXRlIERQQU1UIGVudHJpZXMuDQoNCkl0IGRvZXNuJ3Qgc291bmQgbGlrZSBtdWNoIGltcGFjdC4g
RXNwZWNpYWxseSBnaXZlbiB3ZSBlYXJsaWVyIGNvbnNpZGVyZWQNCmluc3RhbGxpbmcgRFBBTVQg
Zm9yIGFsbCBURFggY2FwYWJsZSBtZW1vcnkgdG8gdHJ5IHRvIHNpbXBsaWZ5IHRoaW5ncy4NCg0K
PiANCj4gSSdsbCBzZW5kIGNvbXBpbGUtdGVzdGVkIHY0IGZvciB0aGUgRFBBTVQgc2VyaWVzIGxh
dGVyIHRvZGF5IChJIHRoaW5rIEkgY2FuIGdldA0KPiBpdCBvdXQgdG9kYXkpLCBhcyBJIGhhdmUg
b3RoZXIgbm9uLXRyaXZhbCBmZWVkYmFjayB0aGF0IEkndmUgYWNjdW11bGF0ZWQgd2hlbg0KPiBn
b2luZyB0aHJvdWdoIHRoZSBwYXRjaGVzLg0KDQpJbnRlcmVzdGluZyBpZGVhLiBJIGhhdmUgYSBs
b2NhbCBicmFuY2ggd2l0aCB0aGUgcmVzdCBvZiB0aGUgZmVlZGJhY2sgYW5kIGEgZmV3DQpvdGhl
ciB0d2Vha3MuIEFueXRoaW5nIEkgY2FuIGRvIGRvIGhlbHA/DQo=

