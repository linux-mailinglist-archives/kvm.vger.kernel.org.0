Return-Path: <kvm+bounces-38799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BCE4A3E709
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 22:55:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0CC13B30E8
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 21:55:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8CFE21421A;
	Thu, 20 Feb 2025 21:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B7f7IXoe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9E11EA7ED;
	Thu, 20 Feb 2025 21:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740088532; cv=fail; b=ahuB9zombKVx4TCMNxWjfyNWrZ65gHk6xB2vCrBUXEJhHDZ5MifRMIXTGJXLSaLTKhIax+pT7HJttXVlX2QneAirbrKSrKQkmyMMtRdUMmFEvi0WBjdIXzavyafaV+05fp/eU/8KRxMmv7DcCFb8lDFn/up7Vv/+TbVj1rKtwzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740088532; c=relaxed/simple;
	bh=WfU2QuANmJiRqkPpXS8G8paiTMOx6qZpaa12Ah4tpaU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=peI+3Xd4JP73W0G3kEeBuEeQKRcI1EpUqLWewhceqe3TCo1JLsQ/EJlyDoCz6daJNPoHuOPCgbXalnBv/kT5w98ApxbRaVQ0WDHIOPZ38LarGOBPyZ1PFAFOk+E4YTagw34L1c0R57wsVSNCivQ4Qr8B+xAWdVv77HDg7WFxSR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B7f7IXoe; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740088531; x=1771624531;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WfU2QuANmJiRqkPpXS8G8paiTMOx6qZpaa12Ah4tpaU=;
  b=B7f7IXoelO8nNZOcGO4ABt2YcJGXw/WbZ4XX1woa/S3ZsW0/l7XS2uaw
   aLqqNHMF6smBZzs3anPZXbwOzTkNNqa7NabTKPNxyUVc/usL/js7vFyHe
   w/OM43VNifIPmi75uTeBTUFzYJyzvu22p5cO1F+a91nzZXHnFmAgZHMtc
   COowQE67J6Icg0K3AaUCAs7PmA0qKkxriI/EJl7ihJ3DNL1So4rMRbAI+
   oI5rBnu1ywcBisjGfPhBXe4nsvxF3qe72Fj3v+QIbHkCB52E6BWTq2PGR
   ZSAtRrIlik6vai6BTBTxZMLHnzWMWROXrcrWCNDdxc2zmRq8XF4+kZHis
   w==;
X-CSE-ConnectionGUID: M0rG84NlRrCcULXzXqqAEA==
X-CSE-MsgGUID: QDYF3+XHT6GBsQ7xHnkvGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11351"; a="40751307"
X-IronPort-AV: E=Sophos;i="6.13,302,1732608000"; 
   d="scan'208";a="40751307"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 13:55:31 -0800
X-CSE-ConnectionGUID: kJh3jJjYSbah6vwQNr3PCQ==
X-CSE-MsgGUID: WomBwPLQSEe4xzBZOIJ2hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,302,1732608000"; 
   d="scan'208";a="115162381"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 13:55:30 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 20 Feb 2025 13:55:30 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 20 Feb 2025 13:55:29 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 20 Feb 2025 13:55:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wXVsObj4DRles0n4vmE+aOKXJUeCCgwoQ5J5/huisz1QpOro07+md7Iq1pgDc1VOqeKrS3grpXtY4D7HxFsOSg9K59Fn4CV6FpEtlANMyie+71IjG+fI+FDhgVE0EFX/h+OpV/0zguhIwpQxv6o1BTo5da6hb+EdG4VkXCpOcXmP/aFgiXPmA4Sy7Rvp4YvBF+z72fzBLqqDD5ddsoCQDGtD9yWUG0Jj0z4f33u2kZyxeAcHY1IyuCxSZiA3R9Rdnw4xbli4M66sRtop7DdLn9LVJPOJNcq6X1qhu7bM+Q1BmczMJ6Jxj+VzrS+V8CHBZrECjgcWDPmQJnr5PZamCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WfU2QuANmJiRqkPpXS8G8paiTMOx6qZpaa12Ah4tpaU=;
 b=bHv44bMrD38UZsVSWrOTeYRkumdm/PFl/Ysj80PYZfYeY0tz9novsOEx5WsfSweKXNFA7igw0lQa0vChj5XgLbbj9CbEzTjI2aatuyoeyBZhJ8VsT1499kJ2+czYwtzWbTphvX1ekaANqpHV+jwKz3zEvutcql92l2YdO4e6wv3FAqcmSLX+BtQCDkZFN8yEMgXKwAdJD2UtaUmxvm/pPEWG/wqUhpci2uQUiRfdOjX8FleGIGC/yaBN55xdZJH3avTB6AeD5wno1g6NrfM2g+LOha0pTUjzIa6ooENRyLVmCRErUbRpcgqLeeJWNXMZ8JyZMgdjvwxO0HGBTYRsPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL3PR11MB6409.namprd11.prod.outlook.com (2603:10b6:208:3b8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.16; Thu, 20 Feb
 2025 21:55:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8466.015; Thu, 20 Feb 2025
 21:55:21 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 11/30] KVM: VMX: Refactor VMX module init/exit functions
Thread-Topic: [PATCH 11/30] KVM: VMX: Refactor VMX module init/exit functions
Thread-Index: AQHbg7nTfughB8v9HEaEV3oOU+MIvrNQvM4A
Date: Thu, 20 Feb 2025 21:55:21 +0000
Message-ID: <a239fb653a040a62d1f3d76edecd2bf28b810135.camel@intel.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
	 <20250220170604.2279312-12-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-12-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL3PR11MB6409:EE_
x-ms-office365-filtering-correlation-id: 7aa80e32-9eef-4157-87fe-08dd51f9457a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bGtFbjhjS1hDb3ZKbUtsczhzSlV3OXFZMjFxM2RNZkpQY29pWnRuVVU5WkVz?=
 =?utf-8?B?VWkzZ1lzRWxmZFRkalBkYXpNeWcwdFpiUkZvSFJvT0VtdHBFbEVIV2M4RnQw?=
 =?utf-8?B?YWpSZmlBbmVRSTc3TnM1MEFhNU1tWEQwMUhEY1JlNytwQTFhN2ZjTVFJYzUr?=
 =?utf-8?B?UmRtRFNGNGtSL1krOEVCV3lKZ25nMTlianhPUUFuUy9uTWM3a2VRTmNvbzBC?=
 =?utf-8?B?YnRNbUlaenQvUGY0ZGJYblVUN1I0QUlJZnpHSW1QclJNd1A4c0pzVDZtckwr?=
 =?utf-8?B?ZnpzUUVWaFFLMVlrUDUxTFVwTmpGZmNzbkNDZG9Xb3FBc2NlalhDZDI4TkpZ?=
 =?utf-8?B?RW1tTUZXYnNFT3d4UzdBcENKbElONnRldllaeDJkWHpLTVk4aHJSb3FXNVBZ?=
 =?utf-8?B?VzcwWi9LeklNQUZ6Y3NDYityaFhkUGUya2ZENVJROXBvekIyYzNtZFAyenJY?=
 =?utf-8?B?b3h1UVQvTWN0RDd3VzJNektCUkQzdXB5cWQ2cEs0T1FTdkREdlZFNk4vVFZY?=
 =?utf-8?B?VWRveHJpWmErSGpMRG9aS0YvZmIvc1krTHJuS0ptRHY3WHBha1N3WUpYdGg4?=
 =?utf-8?B?bWJhNHArUUx4WkdTbHVybms5ZTVCakp5TlBIMTNNQ21TNUd2WlZTM3FmczBP?=
 =?utf-8?B?NEhibFU3cjFzRDViNGJsRXdpWEJCL1dNRVN6bnBIVGlTbVNYaFpXTmdWcFlO?=
 =?utf-8?B?UVpBWXlTMjZuOGZOSk5heXA4UnBPbDFmRVN1ZFJWQWZxdDRJS0t4THBRRmp5?=
 =?utf-8?B?dUdPR1MwdEkxWTNGY29tZ3RxZlZQcjhTR1lUcGt4dUZLVFZ3UEwwZFdjd3RO?=
 =?utf-8?B?czR1VVloSXpPS1VFMzhlZnI1SC93T1J0N0pRVUFwUkpZcEpiVy9NWTNDZEkx?=
 =?utf-8?B?V0VBT2J1aGNvMzNreDdVZ2xBa05rUiszTTNtMmU5bkZjb3dzVzdJR3JiSzJW?=
 =?utf-8?B?Q2hWU0grcHZtVzJib3NNWjgreWtuVjJwZWJvbHYvejBLNXoxMHpZNDJNMnlR?=
 =?utf-8?B?alRIVEQwS3FvQXd0cjhRTU42UkJnRWhUNXRqcVN1LzBZSHQ2SHl5SDhZT2xV?=
 =?utf-8?B?UWRBWktvQXdMY2VwWWRXZVVtb3VDM0FBZjZ2WVRnNWJGdTdIWS9vaFRWblFO?=
 =?utf-8?B?UkpqdXNPMy9JYnlZT3JnQmxoTVhMbFBkMVFGbmxJWUFpMWF3TzFFL2JjTDNY?=
 =?utf-8?B?TW9abVUzU0JaTGZiWFY3RFZocmg2WTMyc1YvZDJmblFDZWUyc0FyTlBBVHBj?=
 =?utf-8?B?aUpYMURjTGc2cWt5aEcrelV6YXV5b0lybFB0eWt4Z1dIdUhsanFzbDdMdTU2?=
 =?utf-8?B?TkdySlRKTEhSbjY3NlJ4cVh6NnBKUEt0YXl0ZVQ3emkvakozTjhBSEZvNXdS?=
 =?utf-8?B?bWFYK2t6KzM2RExiUFRrTndtb1RZK1VkbnN5dVdidlRneS9ITUdmazMxYmp2?=
 =?utf-8?B?TzRSR1dUYldZc3Blc2hEcnRqd3h3eUNBTmt4VDNwVitBcklxS0FNV3NMV0pQ?=
 =?utf-8?B?OWxrOVA5eWl4ajNtL202UDkxS3VSSmF5SnpSNFZqL3I4eFM2NXM3UklSZy82?=
 =?utf-8?B?WjcyNnF2aDUyYmN0Ni9wZVB5YUFybkw0MXptdjVjZGs5VXAzaldvUko0aXVi?=
 =?utf-8?B?QnZqMEZqZ0pkWk1OeHVwVTZMaU9GWVh0RlBkc25rNDRGdjFpckpLN2Y5TkVh?=
 =?utf-8?B?UjBoU2tnL0ZkRE5oVlFMT3VzeTg3VU55ZXhGNXhDWHFTbWZ6T0NCMkpTMWx1?=
 =?utf-8?B?eEpiYWoyRlNQVjdVd0lhQUNHR09NQ1d3dVl1L2k1KzdKeWFXQzFGMWNZMGIx?=
 =?utf-8?B?RjhYcEZJK205a0tpRXJtdllBZ2hsTlRBd25FUlpNUlJFcmhMdkRXcmowek1p?=
 =?utf-8?B?SXRjUHhGNlptRWwwMzQwZTFNenZJKytmbm8yU1l2ejU1V2c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q1M4ZW1QNU94WkMrdDVmL3hBN3ZnWXBpRWhQUGRwQno2cmx2OW03Skt6Q1NE?=
 =?utf-8?B?U214MUR2Z3hQSmplUWRMV3JYZTA2NWswR1cxOHRqZEY2WTBVTS9VY2xlQjVM?=
 =?utf-8?B?OEZHZTVCd0d5MWR4bUgrZUFBQkJwRjFFZ0NPSUN1NjBYWFBHQmZqV2tHdFU5?=
 =?utf-8?B?S0tOQjVlMHZaK29STDg5N2p3T2w0WjhHRjlFRjRKS3hmWml1MFM2elJxQTV6?=
 =?utf-8?B?MnRaclBYNVhGRlFaYWQyV1BZaDNoVmMzY0ZRV0RDd1FtOGFKQTQ5UHlRNWpT?=
 =?utf-8?B?dDZ3N1JzS2hGWWE0dWhSWEw1Y2hZbzJTUENpU0Vnc1BocmdyQldtQnFrWW5R?=
 =?utf-8?B?TzBuelBjUUFjTHczcUNKR2R4dmFQd2Vuc0xRNnNId3FqbWI3dldHcldPNWlm?=
 =?utf-8?B?cVBrREZlSDg5TVRpZFFrd1IzNlMxZWp2bktJQmc1VDdpZDJMbEZiWVoxTzVU?=
 =?utf-8?B?dzFGbkZFK01jaythSy9JUmQ4Q0pvbm1CS2x4bE9TVTM3K2dHWTdPQ2E0dlF1?=
 =?utf-8?B?UEk5Mmg3TTV2Ymo4NnNTL08xQ1VRek1HbExzZUV1emN1VkF3cXBVSWhOOUZ0?=
 =?utf-8?B?c3Y3QUk2VUZJV0ZjZ0I4UGtGQ2VpQS80NDBia0xGWjQ1N3lldjBRc0xpT2xV?=
 =?utf-8?B?cVJ4aHMvZCtRaHJqb21nbGprbkFUUThVbG5mYkEvYmZaS1JHU0JEOFY0b3Ev?=
 =?utf-8?B?RzlNR2RiVTRJakwvZE9qcnpRR25MWFlJbFVoclpEU29OUVUxMTVZUUQyOUtT?=
 =?utf-8?B?RldnK2dJa1R3Vms4aGl6NDVCTEJQQ2dqN3REYnRvZjVMbzY3RGVZNUgxUW1w?=
 =?utf-8?B?dXVySk85eHd6aGhqMk8zdGJvY3hOaGUzTlBMc3ZFTDh0RGtzN2pucDhQTWpM?=
 =?utf-8?B?RjVVdnZpWkFDOHNDb1I1VDVvbXVsUW1uaWJCcTRIWng3Y0Y3WURlbFc0ZWg2?=
 =?utf-8?B?WUduM3Z1WW8wTzBlcnMraUVGQmRMYk8ybFJxNVJtOXdmQWZWbGlYOUJOZHBC?=
 =?utf-8?B?V1VzakZNQ2NIMm5uMjhxTi8wN29HeG9DclRYNWQrVFZBTlNZNUw3Y1pkSjhH?=
 =?utf-8?B?WkcyekVVN0ZzdFFpRzJCKzg2RGlNZVZ4em9mMEh3aTZsUmRobVBzWHpiaS9y?=
 =?utf-8?B?S3dZVS9GWUhBdFNGZEowU0NJTUZwQ1dKUGh6bFhNWEtVQzVCeHNrS0RJbG95?=
 =?utf-8?B?SnZnVlhiVzJhaDVFNHRFZE5PTGNDM2o5UUJTKy9Ick1oTzBNeFRyd04wMlNs?=
 =?utf-8?B?T0lWaEZrTG9kMzBIalpkTVp2OEFKbFd0anRuMG4yaUxBN1o1TEl1ZDVENkI4?=
 =?utf-8?B?WUUyVkwwYy95THAyaUJRcWpMcHJKblA0N1NzSmgxTzQvbHhaeDdaRHZQU2hN?=
 =?utf-8?B?bXMrU21JdjBWVDlsUytGNGs5QzdyNVRmS0ZoMHF6azRPRS9iNDZ2VlZlMTVk?=
 =?utf-8?B?VnFFK1VUMVZCaTdRT1JROFM3d2tzaFJ1RGxDWDg1K3hWQ0FpSHN3Y3pNVWg2?=
 =?utf-8?B?elFOQnJPTXMvcW9VZmFFMVhGNGVoS0NzeXdIcDduYjBKRVZiajg0encvenl4?=
 =?utf-8?B?TEdjbUNZeTBnYXVGK1h1Tkg2d3JRaTEyZ1RiSUoveE1IdW05c1F0a1dySmRH?=
 =?utf-8?B?OUI0R2tVckorUGFDSlhtSFJ5VnhNUEJtK0xuM3RyRktnWDZUTVhBcG5wbHJW?=
 =?utf-8?B?SVhDVTRUZGxwT1pkV0tFRnFmS21mU1pTSXI5QWdxNHJTQnQ5STBDMXUwWkVM?=
 =?utf-8?B?SFdRUXQ5YXJncC9tTGpoY0ZFYmpEOEx6MFZLUnFJMTdQS25VSWkvRWxqaVRO?=
 =?utf-8?B?Z1RBT1BJQXk4VWtONzhXNTlUZDd2ZnJBTXdRUHkvYnNNWWJpeWx2MWdWZm9x?=
 =?utf-8?B?MHV3Qk55K0VVbUQwcmkvWUZOVHJzQVA5clN6VnlrVGN5ZXpzaTFCUUpsa1FZ?=
 =?utf-8?B?RmlDa052THpwVCtPMHZVS1VPQ2NOZkdVMDAvYWZpOXpHMERzeTZGNHFmL3Iy?=
 =?utf-8?B?Q1loM1NnSjVDcFBXSmVlOVRZbUZrSkd1eTl3ckM5NXJqd3E2RU9iQXZwNU1L?=
 =?utf-8?B?TEhpS21iOVF2S1BTM1RoNFN6OWt1SFlwY21wMTVEZ2JUY2R6VE5Jdm1OaTNX?=
 =?utf-8?Q?cLxS1WxF847AVGoyFUtjY/Q6U?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <459F90F8DA276948A147D0D74B50ABF3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aa80e32-9eef-4157-87fe-08dd51f9457a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2025 21:55:21.0657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6aZVE/DDC1ple9fDBgL28qrT9AcJLjjnFJ/8r4mILCZw+Fe/fxM5SH2hi1ti4JAFSZ421GFSwOF9iE9viU6Big==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6409
X-OriginatorOrg: intel.com

DQo+ICtzdGF0aWMgdm9pZCBfX2V4aXQgdnRfZXhpdCh2b2lkKQ0KPiArew0KPiArCWt2bV9leGl0
KCk7DQo+ICsJdm14X2V4aXQoKTsNCj4gK30NCj4gK21vZHVsZV9leGl0KHZ0X2V4aXQpOw0KPiAr
DQo+ICtzdGF0aWMgaW50IF9faW5pdCB2dF9pbml0KHZvaWQpDQo+ICt7DQo+ICsJaW50IHI7DQo+
ICsNCj4gKwlyID0gdm14X2luaXQoKTsNCj4gKwlpZiAocikNCj4gKwkJcmV0dXJuIHI7DQo+ICsN
Cj4gKwkvKg0KPiArCSAqIENvbW1vbiBLVk0gaW5pdGlhbGl6YXRpb24gX211c3RfIGNvbWUgbGFz
dCwgYWZ0ZXIgdGhpcywgL2Rldi9rdm0gaXMNCj4gKwkgKiBleHBvc2VkIHRvIHVzZXJzcGFjZSEN
Cj4gKwkgKi8NCj4gKwlyID0ga3ZtX2luaXQoc2l6ZW9mKHN0cnVjdCB2Y3B1X3ZteCksIF9fYWxp
Z25vZl9fKHN0cnVjdCB2Y3B1X3ZteCksDQo+ICsJCSAgICAgVEhJU19NT0RVTEUpOw0KPiArCWlm
IChyKQ0KPiArCQlnb3RvIGVycl9rdm1faW5pdDsNCj4gKw0KPiArCXJldHVybiAwOw0KPiArDQo+
ICtlcnJfa3ZtX2luaXQ6DQo+ICsJdm14X2V4aXQoKTsNCj4gKwlyZXR1cm4gcjsNCj4gK30NCj4g
K21vZHVsZV9pbml0KHZ0X2luaXQpOw0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC92
bXguYyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gaW5kZXggNmM1NmQ1MjM1ZjBmLi44ZDNj
ZmVmMGNmM2IgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gKysrIGIv
YXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiBAQCAtODU4OCw3ICs4NTg4LDcgQEAgX19pbml0IGlu
dCB2bXhfaGFyZHdhcmVfc2V0dXAodm9pZCkNCj4gIAlyZXR1cm4gcjsNCj4gIH0NCj4gIA0KPiAt
c3RhdGljIHZvaWQgdm14X2NsZWFudXBfbDFkX2ZsdXNoKHZvaWQpDQo+ICtzdGF0aWMgdm9pZCBf
X2V4aXQgdm14X2NsZWFudXBfbDFkX2ZsdXNoKHZvaWQpDQo+ICB7DQo+ICAJaWYgKHZteF9sMWRf
Zmx1c2hfcGFnZXMpIHsNCj4gIAkJZnJlZV9wYWdlcygodW5zaWduZWQgbG9uZyl2bXhfbDFkX2Zs
dXNoX3BhZ2VzLCBMMURfQ0FDSEVfT1JERVIpOw0KPiBAQCAtODU5OCwyMyArODU5OCwxNiBAQCBz
dGF0aWMgdm9pZCB2bXhfY2xlYW51cF9sMWRfZmx1c2godm9pZCkNCj4gIAlsMXRmX3ZteF9taXRp
Z2F0aW9uID0gVk1FTlRFUl9MMURfRkxVU0hfQVVUTzsNCj4gIH0NCj4gIA0KPiAtc3RhdGljIHZv
aWQgX192bXhfZXhpdCh2b2lkKQ0KPiArdm9pZCBfX2V4aXQgdm14X2V4aXQodm9pZCkNCj4gIHsN
Cj4gIAlhbGxvd19zbWFsbGVyX21heHBoeWFkZHIgPSBmYWxzZTsNCj4gIA0KPiAgCXZteF9jbGVh
bnVwX2wxZF9mbHVzaCgpOw0KPiAtfQ0KPiAgDQo+IC1zdGF0aWMgdm9pZCBfX2V4aXQgdm14X2V4
aXQodm9pZCkNCj4gLXsNCj4gLQlrdm1fZXhpdCgpOw0KPiAtCV9fdm14X2V4aXQoKTsNCj4gIAlr
dm1feDg2X3ZlbmRvcl9leGl0KCk7DQo+IC0NCj4gIH0NCj4gLW1vZHVsZV9leGl0KHZteF9leGl0
KTsNCj4gIA0KDQpIaSBQYW9sbywNCg0KSSB0aGluayB5b3Ugd2lsbCBzdGlsbCBtZWV0IHRoZSAi
c2VjdGlvbiBtaXNtYXRjaCBpbiByZWZlcmVuY2U6IHZ0X2luaXQgLi4uIg0Kd2FybmluZyByZXBv
cnRlZCBieSBMS1AsIGZvciB3aGljaCBJIHBvc3RlZCBhIGRpZmYgdG8gYWRkcmVzczoNCg0KaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtL0JMMVBSMTFNQjU5NzgwQUE1NkQ2NzA2OEM5MDZBNDBC
QUY3RTAyQEJMMVBSMTFNQjU5NzgubmFtcHJkMTEucHJvZC5vdXRsb29rLmNvbS9ULyNtODI1Nzg0
YzRkM2Y1ZTI2NTE0NTUyOTVkOGYxYmQ5YTRhYzhlY2RkOA0K

