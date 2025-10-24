Return-Path: <kvm+bounces-61013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D88CC059B8
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 12:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 429334F329C
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 10:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A944F3101C0;
	Fri, 24 Oct 2025 10:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A6hUXlHL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF1A30F95F;
	Fri, 24 Oct 2025 10:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761302197; cv=fail; b=MIzOd/U0zAzgupJrQ0ND1tbvBzydRjX6EggXWHV6dAowzrcgpCoyfuS8cXRWK44tETryRS1uVIoxuIr1yHr2ufrx6yYZ4bHym8QCMs32ZYEHJ5b6iMHzzhDSCoxLLDix4wmII81CNa9W5qqSbuAnBPn/P24AI9z894y/ivmR4jg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761302197; c=relaxed/simple;
	bh=Z9n4b39QFM7BN+K0z9LA/ctnKeBFEsNTYy0S9IWgLg8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=quNsDOPCeVtqzPxGUeFj/sQVV4+Fw6whSqDzm3CN1EGKTDALyZ4pWUbaqfWYdJ4pP9XskGPgMu3Yocd4I9GxQFY+zTYOK77IGP1+BNiF6NIFEQetc4QGl+qS34Po992DEQ0hshA3ZDHz5d6bWDYAiJkEcxmt8quHaAy+bbjYSjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A6hUXlHL; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761302196; x=1792838196;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Z9n4b39QFM7BN+K0z9LA/ctnKeBFEsNTYy0S9IWgLg8=;
  b=A6hUXlHL27mS3bQOHI00CvXdVNPVG27p0cjIhyWtC2OTmVsJjuGE3MBK
   q70QGqeZWFhFbbA4Oxby3qzYLRj6Lyx8pAE6MVvRCnk/jOTW+HY1LcL3q
   PBYopjFjh4Mpa+hhlA6vtS40NODPbcl0cBCOZRWTVQwTg247G4adJAEpu
   cHlItVgcVeJ8Zyk1/A8o/7DbwXrI/nPirFt8LnFNT4sosLh9VR/D0Wo/w
   Hm3ygcGl6fE3gIWT+v31lefWt8PkyWO/0+jx99pANBWB4KtObZtR2mx1I
   6dXCJ4he0TXzf0PZWtTxg7d1rNtOIXo0PjDX7IQ8KZVTmkG3qmEkWPRh3
   w==;
X-CSE-ConnectionGUID: op8tGYhHSTGIUwfHijweYw==
X-CSE-MsgGUID: uREt4EnRSke4rRLwRqzOdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63384654"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63384654"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 03:36:35 -0700
X-CSE-ConnectionGUID: O5cexmBeSx6/+UqAQoTZIg==
X-CSE-MsgGUID: kePbqHtHRo+FvakdQFtF2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="208043939"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 03:36:35 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 24 Oct 2025 03:36:34 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 24 Oct 2025 03:36:34 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.8) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 24 Oct 2025 03:36:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VnRZtwB3m/86k48Tqea1GCBN35PlO3yKjAdikT9fPxjddIauA60GODWpf61V9rsCtzh87BVW4LnzIB7siGaKwa0jTy6sJvGpM3F5WUkoHclGR1VhX6CjvtrobtM8AKFAReksTIme8h++XAKutB/Fb3eXoRhH6GSVBMe9lhpUVIW0uc1ij4qbxdc3jOtq4BNC2TtlZ/ejA3RKYSqNF8y31j2qY3O209hdz7RT7tn9KKn7JkRRNmto9CInBXZahB6QBl+lJEVJuXvB/fkwfRUy5LC7/ENoAhhL6hIZi/Q0+VO05txuymGiTWYSQ+WYEK5ZawyOxWY9Scwe4YEb8d8KXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9n4b39QFM7BN+K0z9LA/ctnKeBFEsNTYy0S9IWgLg8=;
 b=y9wMBPq7oRhN6PNkdqZnbnCTfiJYfhRI/jVUZnH9Xt9pUKib5GMa+W6lSb7rs7VDwl4yvMwLO54Sp82AzFB7OAgw6rTgvUJY2fWBn8AMDZfn4eMK5K/Njww6wTDrM7fPszfc20VnUDrp77d3rVFLiBSvSDhZgTH6fjjAzz98V1XN9+9h6IeBmQknmno6DXqoGgvQKR0xQib8AyjEI/4b76JwZAWW+RtBN9jZ72t2nSqWsopwlZQhUCswF547BL+aJ4JwcaiGNR5ELfp1vHxYxftBqp7nkjeK0ZJatJk/ulrsiUzuSoU8MCPFroZeZQrpL/nwPtoJDNdLIRAHv9oMig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SN7PR11MB7091.namprd11.prod.outlook.com (2603:10b6:806:29a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 10:36:32 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 10:36:32 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "frankja@linux.ibm.com"
	<frankja@linux.ibm.com>, "maz@kernel.org" <maz@kernel.org>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "pjw@kernel.org"
	<pjw@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "maddy@linux.ibm.com" <maddy@linux.ibm.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "imbrenda@linux.ibm.com"
	<imbrenda@linux.ibm.com>, "zhaotianrui@loongson.cn"
	<zhaotianrui@loongson.cn>, "anup@brainfault.org" <anup@brainfault.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm-riscv@lists.infradead.org"
	<kvm-riscv@lists.infradead.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 23/25] KVM: TDX: Use guard() to acquire kvm->lock in
 tdx_vm_ioctl()
Thread-Topic: [PATCH v3 23/25] KVM: TDX: Use guard() to acquire kvm->lock in
 tdx_vm_ioctl()
Thread-Index: AQHcPv2usq93PRHw5UC9GQz0G1+2frTRJiGA
Date: Fri, 24 Oct 2025 10:36:31 +0000
Message-ID: <5fa9236f1a06bda345d76f93ccef85dd522a2616.camel@intel.com>
References: <20251017003244.186495-1-seanjc@google.com>
	 <20251017003244.186495-24-seanjc@google.com>
In-Reply-To: <20251017003244.186495-24-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SN7PR11MB7091:EE_
x-ms-office365-filtering-correlation-id: 27bbe84f-933e-465a-166e-08de12e932b0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?Y0hkZE5qOEVsdm54NmhGUVg1UDlxck1tQkczQ1lnWkdjck5BM2czWHRpcFdn?=
 =?utf-8?B?aFIybnRSL3A0ZThOdG1lcG1Scm5TSWVqNjE2THRVdnZxU0o3S0xRdGFSTkZi?=
 =?utf-8?B?UGdoWkxBR054NjliUFBJWlFyN1JyaW5yNmdkSFhRUmMxeElsN0loc25Zc1Zn?=
 =?utf-8?B?UlE5eW03Rms5SGhMakI1YmQvbWRCY1hLNHNGYUMvU0lnM29IRlRSd2twRGFI?=
 =?utf-8?B?TDd1bm5yUlB5RUVDWXdNUVBacmpSbWhxd0pwUUFZRzlNdnlGUDZmOElrOE5u?=
 =?utf-8?B?aHhCNUVjMGw3Z2h2UnRMdGtycm5oSWdGTWxobHk5NlhLU2JrbUErZFF1U3Fu?=
 =?utf-8?B?cnIyWkFjbkxJZnRmZTZGZXdZbVFINVpSUkhZVHFFa21GWEVDV01jYUlCdWkv?=
 =?utf-8?B?L0FGekNrV0lGRXREdmRHRDNUN0M2U0o0dVkwOHBaWnZqVG9FWS91STBjVXBn?=
 =?utf-8?B?Rzk3NjFqQ09LSy9iR1FkMVg1cnRGVTB4M0h4blJnRHJvQjNiSDhNUlpOQ3pO?=
 =?utf-8?B?Q1VYZTB3ZkRMNEtIZm1vcC9GQlhGNEFRcDk0c2JTRVVnUmVCVWUvMXpBM3pB?=
 =?utf-8?B?ZnpRNUhQZmZ3TWxZdDJVcGYwdUJOTU5QUURZNkI1NVlYZlloQ0Jmc05oRTM0?=
 =?utf-8?B?RnRKYjB2VTg2YjI2MmFqMUo1elNVU01sN2d3YU5VZXhOQ2xScHlnRlpxbWFk?=
 =?utf-8?B?K2ZZOGxlamYzZmpZZW9RZm5NT1NuTFlyV3ZHbWlTbnJ6Vk4zcFhHM3U1RVRs?=
 =?utf-8?B?Vkl0VTE2c0doQkEwU2pEUE9VZ3BYTGV4ZEtMZkM3SzNxRUZ0bkJBR0JWbkZl?=
 =?utf-8?B?emE2NVc0L0c3Yi90d3Y1RWVkdDFZYnBWNGpLc1NzWlNqbWl2Z3J1dmw1b0ZY?=
 =?utf-8?B?Mno0VDV6QlRDcUxBaC9JZHRjQzVqVGEzUFYwY0ZBYVE0N3kxMG16TlhWQXBt?=
 =?utf-8?B?YTdPU2VpZGFnVVNWaVRqNjUxSVhNZ0dTWjQwQkxJTDcwbEsvUFFQRzZhbStR?=
 =?utf-8?B?WnhjMlJwT3Zzb2JaeDFtWVcvdjA0RnorQ1o2djI2VkJlN2EyNWhTcm5iNjVv?=
 =?utf-8?B?R3IrRzVySXhlbVZhRnE1Y01lREdZWnFrcjZMWUE5V05lN3o0WmFlL2FqZDBW?=
 =?utf-8?B?OVkyVklOMUhsZHpnd1dULzVlRXFLbytaWWs5SjRsa01PRGtQbjFnSlRZc0JC?=
 =?utf-8?B?R0YxZXV6cE56OFJacFpiV0xKZnpjcWZ2MENkRGsrMm1LVlRvRjdRRElSaUht?=
 =?utf-8?B?VVVwbTg5TlU5ZVBETjdERDlNZFNHRGlYVUl6ZEgvNW8xSmxkQ3M2Rmw2aFox?=
 =?utf-8?B?elhFa2wweVdQZFViUjFRaU1JSGZZNS9lQzdHbGxTbS94Z243QnBBNEJsaThp?=
 =?utf-8?B?QWU2amNVeXhlWkFvajNwVDFqazF2V0Z2MGpHWTNsdHNRTk1XK1cyamhQb3hU?=
 =?utf-8?B?TzV4QkRodDZxbnA3aXRBNUtnbysrWW5xbnhiOEJyVHhqWDYrWDBwNEJsaGJm?=
 =?utf-8?B?L1MvaGlTV3J5WFdJbWNjWHJSa3k5d293N01xSjhQQTFhdXVnUVJzTzdoello?=
 =?utf-8?B?OGplOEM5WlArRW91WmJra1JwaElja2JVOVR5RnZlZUZIN0dCMlJJbGxnY3Ur?=
 =?utf-8?B?VXkwZFV6WlN2UVBYZFJGSThyaCtlbG8wdUZGR0I1bVIyVHNrZVM3L052Wkoy?=
 =?utf-8?B?bStJcHVMcGxhbm1RL3BhZjdWRk5weldUR3JZcXdoV3k3TzNJdGlWbmRZQ1d3?=
 =?utf-8?B?VlNzYXU5NUhxVGVRdGJNUDRGbzFTZDEwTGhSWDhnSnNSWk1lOGFDUkt2UEY4?=
 =?utf-8?B?dWxsaDVJdk43bGVUbERrZ2t4eEMxNW5YVTcvUXNpYjRXTEtUK1c4NGZZbDR6?=
 =?utf-8?B?VnFSc2FOelRkYzdEVE03ekdaYloyUlpDa3pNaWNreGNDVkU1UGtFUnpCM1dj?=
 =?utf-8?B?WjVzZy9udjlrZzc5SkhibURMbEQ0Q0ZVK3g5VnBBNTgvR0k4TzhZSE9qOXNO?=
 =?utf-8?B?RlBCdm8xc0pTRndNdzB2UjA1cmx3VTJENkRrLzNOMnRXTThzRFlqNXo5K3pI?=
 =?utf-8?B?S21GRU5HYWh5TFlpRUkwTm1yMnNZSDcyN1lDdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eDNCYVNrTjlvWDZMRUJtZHdRN3htd0M4Q2NTL2hOS0J1SHp0d2MrR2JWN29y?=
 =?utf-8?B?SklhYTVraUpLWEJkSHJISHZIdE52cWs2dmh4eUhMNmNibHdCa2tEY3BxcVFt?=
 =?utf-8?B?N0Q1aE5iaVZNY1N3QnhWVm9aN3hZcW4xSG41YkR4TXdscXNYYlNBOWJ2eHZy?=
 =?utf-8?B?WGw4aGUwRHNhMlFFZm9pT003WUFkQmNEdCtSclVNUzBVNHBHN0p1Rk5XY2JH?=
 =?utf-8?B?Um1YbW9NcTA4b1JhWVRMSDM0UXRtaUxZdkxYbUUySmk4K3JaME0rWWtJZkw4?=
 =?utf-8?B?ckJiWCtmSHR4V2ZJYWsxaDl3SEQwOFB2c1VEYUJtMHZoNHpQZmoybkJyRjBE?=
 =?utf-8?B?cFlhWWdjbFhobUxvNEtUNmNBeVlkQllPTHIyOWJ6ZHZpV2w3eHViZUxRRWRk?=
 =?utf-8?B?cW9NREw0VjlZcENaTEp6N3hpM1RyK3RCRmtpWDF3U3lkUUovRDJ6Z2h0NlZt?=
 =?utf-8?B?V0FibjNkSkNSOW1PR3VYK3BFVHBIbnRRaUNOaFcwRGR5NXg3dlZtSzFyUTR3?=
 =?utf-8?B?Qi9SVEI1YVl1cEpKendyMjFtSzVCNEVRVEhSTEdmdTBqL2M2dU82Vk1QYkNF?=
 =?utf-8?B?VjhDaDF6ZGFrcWpEcUFHUmZMaGIwNkhZRUxZNjk5WklGektYL1JTU3hpa09K?=
 =?utf-8?B?NXNrYmhxMm9OWDJJN3lwRDROcVcxZllOZ2hOVFhNeEhkdGlLWk1GbGdzQkZK?=
 =?utf-8?B?bGpYUjFjKzVsS3A5MWM0NmhQYmNmd1VTNjQwNVAzYW13Z2hXWUZQM055NWhE?=
 =?utf-8?B?ekp0N1BibmlKQ0RNcnd0ZXBaVm5iZGNNYU5LclB1MURudWpQMlU3eW9Od01Q?=
 =?utf-8?B?Yk1Jb1FEVU1IUXVyWnNCZ0dQQmlyejNvQkc4cTdzUkpCSmpYdGZsY3Z1NlZt?=
 =?utf-8?B?SHNPMW1WYXQ3dC9DS1UzOVg5NEhFVjBDNVUxUlRKVi9nditUWjIyTkoyczNy?=
 =?utf-8?B?ZXE3REJLSzh2VWFzbGFFSHhFeE44TlF6U0ZqNlRnOW9Nd29qRGpjMmZmMTFv?=
 =?utf-8?B?am1TZkRDMXAzR0lCOE1zai9mdlJRN2VFWUc3MTd4TGpVeU1ZWFowZlplb2Ry?=
 =?utf-8?B?KzI4alE0Z3p3alpVbUxoVmNyTGk0cFpkbWdHSjhjaytURHhqUjk5VjVQNGdB?=
 =?utf-8?B?WGtzUTZrYWZ5V3Q0MjFtYnJzK2dkdGlIeXZmREU1aTdsWUpFZThadWRteGhK?=
 =?utf-8?B?UmJNWHBuUUtIeFlvbW9DdVdyWEUzWGthSmVnMzJIOXN6SmlOQ0UvWGhPNXp3?=
 =?utf-8?B?bzhuTDdTdTdLTzZMdm1mdjYwN3NsSHkzRk9BUno3TUJqY0d1RkNvNEZMU2ho?=
 =?utf-8?B?MXAvNE5Qb3d2b1JDMkRLWUx6RFduQWxpR2NTazBFZEg3Y0krLzZGZTR5SzR1?=
 =?utf-8?B?eThWNXpsRGg0Q0dqVmhWWWRwL1V1Zi8zNjNGUzE1d1AzU1c5NDRTZTRwOXda?=
 =?utf-8?B?SGovaWNFRUJCNVN2eTU1bndwMmo0RjJjWjdHV29vRFBEbHgyZG5Rb2N6TUJt?=
 =?utf-8?B?MXkva2hPa3pLbmIwa2dSbStJRUR3ektBbVZ4YUl4L3g0d1dDa1diMUtRNVhz?=
 =?utf-8?B?SWplOXhPVXdEMU1YSksyaUNNbWJDTzFBSlpGS1h0empndEM4Q0xrQzFXSURG?=
 =?utf-8?B?R09aWXgwYVdCdGpZcUFjQmVRVmE3NjRoZU9LYk5SUXdqanVmMzlWb2tiVDRa?=
 =?utf-8?B?VEtiamg0eGhRK2pLaUIxbTdtVVhhazFGZlN4MjFsMmx2N1JWY0FhSTBhVFhF?=
 =?utf-8?B?eEJZdzRVQjh1YTZpTmNncy9oU3IyWm5NU05NbEpIcFhwblJSQUVuMlVFTW5L?=
 =?utf-8?B?ZVZWV1VBbjNqQ1pkOEl1RVJ6UTl3eGhiU2pPZmk3aU1OYXRjT1ZYc3NqV0cw?=
 =?utf-8?B?TUYxNGFORDRLQS95M3h4N2JzSGxUam5YMTFMMTIvQW1Lb1gzOXdUVm5ucHp6?=
 =?utf-8?B?WmtkbkpNanI2UEpyZ1l5Vk5rbEpoOElhY3NjK3VKOXZjZ0hZV295WGtiMWIr?=
 =?utf-8?B?R0FPdzJCL0NxT0FKVEtmZzVBUjc0ZTRESXpUOVlESzhFWWdhdlFOU2Ryc1BV?=
 =?utf-8?B?NWJVSklYby9wZllBQUFlMXpjYVRCOCswMzJUTXZaam14VGhHeXRCSnVCa0dG?=
 =?utf-8?Q?NM7yx4zTm1trBe/8DTo8/ZvzC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F626644874034E40A69B81466DEC9470@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27bbe84f-933e-465a-166e-08de12e932b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2025 10:36:31.9874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HfvnO5/D4iOee71c28Ds2IFQ6Q23bH+bOyWyOgbl1aKAZ/Lhf/yLzqNelgQdoPa+SdRz9KS1n5VqODvlJWYlgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7091
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTEwLTE2IGF0IDE3OjMyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBVc2UgZ3VhcmQoKSBpbiB0ZHhfdm1faW9jdGwoKSB0byB0aWR5IHVwIHRoZSBjb2Rl
IGEgc21hbGwgYW1vdW50LCBidXQgbW9yZQ0KPiBpbXBvcnRhbnRseSB0byBtaW5pbWl6ZSB0aGUg
ZGlmZiBvZiBhIGZ1dHVyZSBjaGFuZ2UsIHdoaWNoIHdpbGwgdXNlDQo+IGd1YXJkLWxpa2Ugc2Vt
YW50aWNzIHRvIGFjcXVpcmUgYW5kIHJlbGVhc2UgbXVsdGlwbGUgbG9ja3MuDQo+IA0KPiBObyBm
dW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRlZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hy
aXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5n
IDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K

