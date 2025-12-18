Return-Path: <kvm+bounces-66285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 62E36CCDCEA
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 23:28:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 435D23058F8A
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 22:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 928642FF178;
	Thu, 18 Dec 2025 22:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ht6rH5GR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F392D97B7;
	Thu, 18 Dec 2025 22:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766096651; cv=fail; b=BmFSp8ya0zV2AKuA1HR/ulvhc5sse8Jou7p0odVp9wvJ4RPgy6Mbuhgf06Zp9kMi6Qxcc/1FOlBah5w/l71N7Ci4m9Ka0gJJfI82k4xO3CicOoCgHtjx6ilIlkiXrc0n8HAIuO24SxexT6vciIaHdysztJhyug6MIfQn71i4VL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766096651; c=relaxed/simple;
	bh=jzZxp4Nwm8oqv0zq1D5ufBF1euopXyj0m3ZBAhIrewE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Zm14m6Jqhr2eEmJ4yw8SpfHyK5u6FIsHlZHdFrBv3iU+BIymuzOfGqUNM7HTFIVH7OeFepaInmka8aWYAumjJ9Em+j3TINKkEWqO0hYXDxxEZ9UccbDOGdFsQfkc8PhPbcZ8kCozI1vlodX/CO4UfCafrpvdjLYc0n/FRxbIXTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ht6rH5GR; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766096650; x=1797632650;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jzZxp4Nwm8oqv0zq1D5ufBF1euopXyj0m3ZBAhIrewE=;
  b=ht6rH5GRTFdjFAImQXOhoSSd4mpPE5sAvHpIzPV6nd/BmGQsfQOKp97+
   iOmQKk+3KRAI5p2B6Wls4BiZMIUuCJoAlhNQsIfIHcahgbh4bW19Xdi4t
   T3Z4+qYcG2LHpVgMpWtoUEtfXD04a9EmYaSuRYNfimDrx2Tbpz4uPH8Nm
   kovg4zejwwGxEtwKFwPfpr7g0bx2UFcwSPVe6B3GoYV4mxPe58ibVZtK7
   qDxUVU3TvXs09XjNlzF1f2DDTU/7dDQ68UivtiBvKJtWt6UF6+r5db77c
   vaw0l/lCwSZcMEO7s9TTj6NZYgMoI+HmLgURiL+bBcoPzc7i0hV6C6c4L
   g==;
X-CSE-ConnectionGUID: bqFza7ZiR0OzB9BPhJ62Cg==
X-CSE-MsgGUID: ZvA/yMtqTnqaQKj/Lb0M5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="68215065"
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="68215065"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 14:24:10 -0800
X-CSE-ConnectionGUID: wU0w2tYxSEG+C9Uou42Vtg==
X-CSE-MsgGUID: 6Y3Tc6zOTOq6YHzdGJ0DLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="203104335"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 14:24:09 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 14:24:08 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 18 Dec 2025 14:24:08 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.61) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 14:24:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AzYSo1ElFZy036Cj1scLsT+S2T//2HGKHiHHYUtmODBbE/gh/Gurx3I+7awdk4I0gNlYbGjQpGy7Ta+FWYfxMreCg86b/AHlqQ2cvtsiK8tw74MtkWm8dxK3ZLbWEvLcTYEXd/mqq9pCbtgTYWWJzdt49AFUzXldbkb6ubZBpn1un7As77U/qbIdTs8agyMR9hBtD+8PLAny/x0bHuQ58QYpF7u5G7W0Bg0FJI/yg4AEeVUOXsvSKbsPq1SaMxoT1BWHDj+Lq8Eq4RMwgSZbQFJyOL70d2FTXQKfhv452lZPnNtHhahZweRbq3kpjmV2ICKDnkmFCtoieQfOyxM2eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jzZxp4Nwm8oqv0zq1D5ufBF1euopXyj0m3ZBAhIrewE=;
 b=eutWZskuP+7isWbZvwTJUj6hiZGkyIi7BD2LFcpHuBRH7yrsLQJxV3X8vK1yDDBrjdupVsE6FhSnpBpVuspHlbE1PRmsHh5NR2nhG65lTyOiLgB7Yb/7mIa1HvXuAU+xKcl8VrXc9e0WVxrWRzfrJkhN/utKMpaRzBfsC/gHV7pQwTHpqnEVnzKIdqpp1rEVmDDfzjMNBL3O6fqyq6Sr+iC6sCjHNpnH3gbb8FiWRaaTR3xF719Awt9Xi0Ozb3xGzUhwJ1u1Uv5dT85pqq8tgxux7+uhDmaCTu0XEfBIyCWnB5jfh0s4tWCgMImXKuKTyNuLl/WqWx7guYXTeuej+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS7PR11MB9475.namprd11.prod.outlook.com (2603:10b6:8:26b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Thu, 18 Dec
 2025 22:24:04 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 22:24:04 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>
CC: "david@redhat.com" <david@redhat.com>, "liam.merwick@oracle.com"
	<liam.merwick@oracle.com>, "seanjc@google.com" <seanjc@google.com>,
	"aik@amd.com" <aik@amd.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v2 5/5] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Thread-Topic: [PATCH v2 5/5] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Thread-Index: AQHcbdillEmrRvxJJES/bBrcXHasxbUn/lQA
Date: Thu, 18 Dec 2025 22:24:04 +0000
Message-ID: <8fe83dba66ca0fcaf94a990a30b4f7d8ea2ae37a.camel@intel.com>
References: <20251215153411.3613928-1-michael.roth@amd.com>
	 <20251215153411.3613928-6-michael.roth@amd.com>
In-Reply-To: <20251215153411.3613928-6-michael.roth@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS7PR11MB9475:EE_
x-ms-office365-filtering-correlation-id: 5e8aaac1-9e4b-444a-6e16-08de3e842717
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?K1ZMYmY2YWRrRFB2RXl5dmNyNnJ5QUdLZ3R3ZVJnMEVEOGIwc1pGOVd2UHkx?=
 =?utf-8?B?eU1pMTYrZllYVjN5WklacSsySUFnVWpYNFpVaXRtaFFHVzJETUFuRnZLMEJQ?=
 =?utf-8?B?M1B3dkVqRGlUb2taSWtHYldnSFJsRmw0N3dHT2Z1V0twQjIxd01aL0Vva0VO?=
 =?utf-8?B?TzF0VTBVc3ZzT056c09xc2dUUFRqVzA1UHNqeHZXNFpnbGd2eGFKWkVteW1w?=
 =?utf-8?B?cjRqUFFpb1lQY3NhWGVGRWZrM01DSGl5bWFQZm9DNkZMZXh1czYrekxEeHNZ?=
 =?utf-8?B?R3g4QnMwcGltNkxWTlUwRy9uZkZEbHhhR0ExQmNqYVRNTDI3UEsvdHJCSTBz?=
 =?utf-8?B?U1RRcVY5dnUrczFWeFVwK2pTcUkwZEFFcDRlbUpnT252ejFWc0FZOGVDdTZa?=
 =?utf-8?B?cWRLN1YyS2Y4L0hTTlV2VENOUDVCMG4ydzd3Qis4enZqb0dmUU95UWdlb1Vh?=
 =?utf-8?B?RlRsSllWQ25RL254NXU2dkZxbmF1YWlOYTFvU2xWVFFubUtXbFF4VkkrZGFP?=
 =?utf-8?B?cU5kbjZFcFZ6NStwb0JQcEdKU29hTGZKVnRrcWU3YzlicVRrTWc3R2RiSVpi?=
 =?utf-8?B?b2NnQkFFRTNoT1R4M3ZPMm1XYjFiOXhsOVhMeCtTcGQxcHpxWG9qL0JLTzZ4?=
 =?utf-8?B?NnkvSVhRK3ZzMGRFa2dJT3R4M2pXL3lQU0p4YkJJdkd5dU5YR2FMYnFDOGxj?=
 =?utf-8?B?UTR6WlZOeUQ3bDFZV3ZCK0VSYzc5WTRobTZOUG85VXFnUDNoM1lieXdyU3Bq?=
 =?utf-8?B?L0ZWa2hNbVd0dFdML2NVN1RBM0o2QjZFbkhCZ3ZYbUhSY3FNUm1pNk1NUlJW?=
 =?utf-8?B?UWo1Y0JNQS81Z094V2NhMEFJMVpRUmFQa1FyaEJiR1R6Vi9aQ0NYanlZZFVX?=
 =?utf-8?B?QVYzOUpSTUdRdzZJQzFIUUtIY2dxZmZWQ2dNdGVPcGRKUFN2YVp1SFpMNFdF?=
 =?utf-8?B?N2NKaXV3SUcyTmtNNnFYb0JpVFBUNFl2WmYzNVZnaHQzMWdWU0EvQndBeDZS?=
 =?utf-8?B?eGpFUmxvQUlkZUpIVHJ1aXJobDFtWlVheGNYaHhFNDN5VENnVHpOL3RJdzBh?=
 =?utf-8?B?VURHd05TWkVYNVkzb09vYmNCNm1Kajl4UnpvNVl3S3pEVzMyS3Y2M2R0Y1NR?=
 =?utf-8?B?YmRPV0FxTm1BbTFqUkRleFp6Z1k2cmlrN05pMmdNenYwM2VHMFgvajdlaXZH?=
 =?utf-8?B?MEx3UUdzK1VzS1EzaUVkczB0WWdiOU5XbWtMdWhMeFNiN0FRTmFEQVhPTTN2?=
 =?utf-8?B?NzFYcjVXektzUTNJM0k4TFAxeFlRb1gySlBHNGR4R1NMbDEwbjFqV0s0dnl1?=
 =?utf-8?B?Z1h5Mm1kR084R0lmVVlxdEJtTVhHalo5SmtqQlREelZTQUtDWHg5eDVGazhS?=
 =?utf-8?B?NFVLaktueitGbDZ5Qm1lb1MzVzl0Vk0yQjZUbWpoNlhvTURDN0N5ZXFOdzZT?=
 =?utf-8?B?MWkzQWFKT3N2UFVTeWpOVnBpUFZrUUZ4V0t4WjBmMDVJVWFUdG1vWDF5Zml6?=
 =?utf-8?B?eGpEU0JpSmxTTFhwbjJJNTF6S0l2aUdiRFZ3Nm5JS0IwSW4yRGV4bXA2b2ZR?=
 =?utf-8?B?VG9rZWUrWVNxOW1TZWpBaUFNNm83ZUtWeXVlS1VOWXhoV0VvS3JQdEJoaUdF?=
 =?utf-8?B?ckdpaHB1ODFyRjYzbDRTc2U2a2VlY3lOSGoyZlRGamlTVk05VzVzd0syWFdh?=
 =?utf-8?B?NnpBVGduUUhqRG5MQ3ZMRy9MbmtYZ3JnQmVtRGVjMWxENDd0N25tYXhiYnRP?=
 =?utf-8?B?MkN6UTRrTWJUeUlSSm9CbU9yUkdDamhXRU55WmV1S1RoMGh3dDNERmluWWhn?=
 =?utf-8?B?S0N0TWNtWWhrN2FsK2I1bjRiT1FhNytEMGhyeDdsL04wV1dheTlnZHBlUERp?=
 =?utf-8?B?MHV0MGtOZENJRXRCbWt5UDRVZ0JmamZJZVU2WXZ3bjVwNjF6OUpWM1VEY2RO?=
 =?utf-8?B?NDIySi9td3B1VGJuS0pMb2hTS21MaVk3QjdiT2hpN3ZhRzEzNkJiTlNwSkpR?=
 =?utf-8?B?cUJteFY4UWFFbHhTdElTWDlhdXcrUVJoSVFYaDdzdzJGMWl4czF5WlZpSmRu?=
 =?utf-8?Q?V3R5uV?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXVxcFFJMXJCeDhsM043WGdyZitaQ1NJa0tkc0ZkRXRCZFpqSFBGUmJZYlJE?=
 =?utf-8?B?SytLa0VRSDlJYVh3R3g3UmdWVXE0WklFNTJkckpvWjJzNkc4bHViZXBMdGJS?=
 =?utf-8?B?T1lzb2NYcUUxTVczdzVsWmIyRUZDajVBWEhVcG9PWVpXUzN1UVZzZ0IyLzhH?=
 =?utf-8?B?dTBMSlphY0xNT05SblMzcU9vdGVPbTFxaS9qWDM2OFlRSEJqTmdVR0U3L0Ux?=
 =?utf-8?B?T2c1SU52MDk0L0Vod2piY2phUkdiaXVCd21KWVFBSmRrcUkxMjJlRnB6OG5x?=
 =?utf-8?B?aHJRNngwdjBiMnphSGRnNDFKb3pwN1BmTGZJcVJTNWJ4aEh4RU9BbFlkZHZm?=
 =?utf-8?B?TUFiQWRPa1lqVHU5Tml4VndJOXRrOUhGc24xMm81ZVQxbkhSTnlybk14UXly?=
 =?utf-8?B?RTJUeDh5UVozL0FFOUY4WXdKbERzYkhTSjlNZlQySEF4aXByNTVNandNb1Iz?=
 =?utf-8?B?OUU0QnY5bWJlb1R4N2VpNGRqL05EMDM2djFNdElZTWJLb2JtRjBINmIrRy9K?=
 =?utf-8?B?WmdFcktxZVhOTmVrWDdYTXRqZGdhNTN0VW1YdlBucDlMS1NaTDlCZDgyRnJs?=
 =?utf-8?B?RTJaaEpwUHJHWW5XZUJaSGd3S3RpQk95Nk5aNk9laVlRMENINVUvUlVBSVRU?=
 =?utf-8?B?QmJ6ZTdlb0svakp1UStRTWVRRmhWQ3ZxeGZNVXhwTllRaU42UTZ0VHlvUTNq?=
 =?utf-8?B?SmdPbEVNOGN0VEIxOXVKL0FGVzBNbEVGelNHRWVTZ2dpb01Vb2FxQ0c1bFEr?=
 =?utf-8?B?dFZnbk81dndlNEZqa3Ftdk9JSmh5RmpCcFBudVFFcVJ0dE4vSU9ieWdKeVRj?=
 =?utf-8?B?VkI5VVo1SjlwMzFQbk1vT2twdUtEQU9CMTN5MFJrSkZBU2pJY1p3NFpET3ds?=
 =?utf-8?B?dFhsbTVnRmxidDg0VWdkc3p4aHo4dkwxQUx6RVRMTzB0NTVTaEdnM2JQUzB6?=
 =?utf-8?B?cENLaG83RmJlYi94SVUzVXFSMDllRnkvT0I4Y1NYbnhQZnJHL0hrNy9tYUlv?=
 =?utf-8?B?VW9yR0VxYnM2cDNYWXFGd0RINC8rODJSMWI4RkxlZC9VYUttWmd4Mkl3ODJG?=
 =?utf-8?B?aXh6RjF1akRQMitNdk5oRmEvbHUzN2krSFdJMk52VS8vUlpvWjd2N0FQQUpt?=
 =?utf-8?B?aHZYcnMwaHkwbWtPRGh1a1YxUWFkVXRuQnNhS1Izek1JL2VUY2VINHRYTklr?=
 =?utf-8?B?Ykk2VTgvTWxLTnhocUwrNjFWNXd4aG9tZFlCZnorMU5pREZvSFBxTTFmR3g0?=
 =?utf-8?B?Y1Y4eW1RSmJUQlhYQWVpSjU2UDFob3RkMi9RTVVJbHdnQ0FsRjZhQlVweWdv?=
 =?utf-8?B?SGhmaHpmV2NLc2RrNkdDcnMvN1hmNkdlakFIWExUL1hIUVJQSUJhWlZBNDEr?=
 =?utf-8?B?ZVFoMmhnbVJKSityNVNsQVJtUkFYelBKQWoxTWZ6SUprRTgwZ3kzU244dnVC?=
 =?utf-8?B?MUhXcTRYU0g2S0xNRzA4UUk4MXl5Q2dkblMvcmpOVGNFbk9QWGhHaGVFTkdC?=
 =?utf-8?B?V0FFTXovODVwQVRlZU0zbHlheEhTNUhDM2c5dXJObnE3NkhKSlRwakRiQW4v?=
 =?utf-8?B?dHFzcmQzVWF2aTdNV1NHOXYwajBCZkY1WWFtMHJWSG9qdk80TXl3UEpsZ3ZP?=
 =?utf-8?B?Um8xcFM0S1QySzl2c2JGSXZLMTF3VGZXSDQ0a0xZSVdKd0lXV0sxcUVWUGc1?=
 =?utf-8?B?alIrTzU0ZTI1T3JlRE43dG1PNXBvcTQ1SllSQUgwTStqdk9KaTVvb2tkN1JI?=
 =?utf-8?B?M3ZJYURUODdRMWZYdHEzVWs3S2k3TE52LzBlUmhPWnA5K3JEbHFHZC9ydEJm?=
 =?utf-8?B?Nmp4VEo0ZjJzS0NwbStFZDEzMG8xdzRDdk1wdFB3ZnFkQWYyWUU3Um56cHk1?=
 =?utf-8?B?cXE1RVdnYTJoZ3dUSks3UjdXeEVCV3hPNndFa3p2aE9EckQ0b3ZoL2toay9B?=
 =?utf-8?B?c0R4eUk0NzlIYUFDL3lhZFl4cGU5Z1VTNVhkSlNON2JVSmJaenRCR1RlZzdQ?=
 =?utf-8?B?ZlJ2OUFsa0cvbkNheUg0VmFBVkM5SmN3S2JWQlcrNkZmT0Q2czRiWTZ3b1Jv?=
 =?utf-8?B?dzJ0d0liOTR5VW5lMVRBMlN6bTZMekY2MC9yb0FPT2hoNUg3OXBJRkRhaFBx?=
 =?utf-8?Q?pBbmjt0KMkbThgGzbeVxdvaaD?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0F2D558F5B356743A58DEB4CDDD42153@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e8aaac1-9e4b-444a-6e16-08de3e842717
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2025 22:24:04.5397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: twucjNLJgA/63LmLrpDz5De2hrA29JnIWUFdmV3ljOje2AjB4JuPPyvJJRwDo5pXfWXhQDL5dZHoft2WF4SdFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB9475
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTEyLTE1IGF0IDA5OjM0IC0wNjAwLCBNaWNoYWVsIFJvdGggd3JvdGU6DQo+
IEN1cnJlbnRseSB0aGUgcG9zdC1wb3B1bGF0ZSBjYWxsYmFja3MgaGFuZGxlIGNvcHlpbmcgc291
cmNlIHBhZ2VzIGludG8NCj4gcHJpdmF0ZSBHUEEgcmFuZ2VzIGJhY2tlZCBieSBndWVzdF9tZW1m
ZCwgd2hlcmUga3ZtX2dtZW1fcG9wdWxhdGUoKQ0KPiBhY3F1aXJlcyB0aGUgZmlsZW1hcCBpbnZh
bGlkYXRlIGxvY2ssIHRoZW4gY2FsbHMgYSBwb3N0LXBvcHVsYXRlDQo+IGNhbGxiYWNrIHdoaWNo
IG1heSBpc3N1ZSBhIGdldF91c2VyX3BhZ2VzKCkgb24gdGhlIHNvdXJjZSBwYWdlcyBwcmlvciB0
bw0KPiBjb3B5aW5nIHRoZW0gaW50byB0aGUgcHJpdmF0ZSBHUEEgKGUuZy4gVERYKS4NCj4gDQo+
IFRoaXMgd2lsbCBub3QgYmUgY29tcGF0aWJsZSB3aXRoIGluLXBsYWNlIGNvbnZlcnNpb24sIHdo
ZXJlIHRoZQ0KPiB1c2Vyc3BhY2UgcGFnZSBmYXVsdCBwYXRoIHdpbGwgYXR0ZW1wdCB0byBhY3F1
aXJlIGZpbGVtYXAgaW52YWxpZGF0ZQ0KPiBsb2NrIHdoaWxlIGhvbGRpbmcgdGhlIG1tLT5tbWFw
X2xvY2ssIGxlYWRpbmcgdG8gYSBwb3RlbnRpYWwgQUJCQQ0KPiBkZWFkbG9ja1sxXS4NCg0KTml0
OiB0aGVyZSdzIG5vIGxpbmsgdG8gbWVudGlvbiBbMV0uDQoNCg0KWy4uLl0NCg0KPiBTdWdnZXN0
ZWQtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiBDby1kZXZl
bG9wZWQtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gQ28t
ZGV2ZWxvcGVkLWJ5OiBWaXNoYWwgQW5uYXB1cnZlIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+DQo+
IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBBbm5hcHVydmUgPHZhbm5hcHVydmVAZ29vZ2xlLmNvbT4N
Cj4gU2lnbmVkLW9mZi1ieTogTWljaGFlbCBSb3RoIDxtaWNoYWVsLnJvdGhAYW1kLmNvbT4NCj4g
DQoNClsuLi5dDQoNCj4gKwlpZiAoc3JjX3BhZ2UpIHsNCj4gKwkJdm9pZCAqc3JjX3ZhZGRyID0g
a21hcF9sb2NhbF9wZm4ocGFnZV90b19wZm4oc3JjX3BhZ2UpKTsNCg0KTml0OiBtYXliZSB5b3Ug
Y2FuIHVzZSBrbWFwX2xvY2FsX3BhZ2Uoc3JjX3BhZ2UpIGRpcmVjdGx5Lg0KDQo+ICsJCXZvaWQg
KmRzdF92YWRkciA9IGttYXBfbG9jYWxfcGZuKHBmbik7DQo+ICANCj4gLQkJaWYgKGNvcHlfZnJv
bV91c2VyKHZhZGRyLCBzcmMsIFBBR0VfU0laRSkpIHsNCj4gLQkJCXJldCA9IC1FRkFVTFQ7DQo+
IC0JCQlnb3RvIG91dDsNCj4gLQkJfQ0KPiAtCQlrdW5tYXBfbG9jYWwodmFkZHIpOw0KPiArCQlt
ZW1jcHkoZHN0X3ZhZGRyLCBzcmNfdmFkZHIsIFBBR0VfU0laRSk7DQo+ICsNCj4gKwkJa3VubWFw
X2xvY2FsKHNyY192YWRkcik7DQo+ICsJCWt1bm1hcF9sb2NhbChkc3RfdmFkZHIpOw0KPiAgCX0N
Cj4gIA0KPiAgCXJldCA9IHJtcF9tYWtlX3ByaXZhdGUocGZuLCBnZm4gPDwgUEFHRV9TSElGVCwg
UEdfTEVWRUxfNEssDQo+IEBAIC0yMzI1LDE3ICsyMzI1LDE5IEBAIHN0YXRpYyBpbnQgc2V2X2dt
ZW1fcG9zdF9wb3B1bGF0ZShzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwga3ZtX3Bmbl90IHBm
biwNCj4gIAlpZiAocmV0ICYmICFzbnBfcGFnZV9yZWNsYWltKGt2bSwgcGZuKSAmJg0KPiAgCSAg
ICBzZXZfcG9wdWxhdGVfYXJncy0+dHlwZSA9PSBLVk1fU0VWX1NOUF9QQUdFX1RZUEVfQ1BVSUQg
JiYNCj4gIAkgICAgc2V2X3BvcHVsYXRlX2FyZ3MtPmZ3X2Vycm9yID09IFNFVl9SRVRfSU5WQUxJ
RF9QQVJBTSkgew0KPiAtCQl2b2lkICp2YWRkciA9IGttYXBfbG9jYWxfcGZuKHBmbik7DQo+ICsJ
CXZvaWQgKnNyY192YWRkciA9IGttYXBfbG9jYWxfcGZuKHBhZ2VfdG9fcGZuKHNyY19wYWdlKSk7
DQoNCkRpdHRvLg0K

