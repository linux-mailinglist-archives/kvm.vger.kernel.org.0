Return-Path: <kvm+bounces-30896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A00B59BE313
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:51:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F5281F22C8E
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC901DB37B;
	Wed,  6 Nov 2024 09:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ulx7Z97V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A690F1DA31D
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 09:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730886671; cv=fail; b=EWHHC5qg5nLqw+o47x+SmtKuL24K74FXhmcYWdtfo53MaRbvLEJbeStxM+Yhsqtyafppo3k0kA7FPpuTF7FTSJCFj7+Ad143o3ZL12xMOwJppLzT7092o/NlwpQZX17CO7oGNu8yHangiOS1i0ABP1pz/DJeBdc7i99emjnICUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730886671; c=relaxed/simple;
	bh=m2Tsg8uhijkrKkZXmdF0IUBP5RcuO48YNaKjzbsz/oA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Wztdec2PWVAcddRhJRlJVQaWMjF6Ql5lP3CNHqsxYs2N+JV0LfMwCuL2WmWsur0HxNFeMVIY8w5GMd+PFpQEwP+MDCMx7D1ITgQ5sshylDx9f8unMQQfG2pFYGR4DuiBdPwVyUUVWByM03Hz+SqdfCUoRYV07MFgGO2YUIH6/y8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ulx7Z97V; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730886670; x=1762422670;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m2Tsg8uhijkrKkZXmdF0IUBP5RcuO48YNaKjzbsz/oA=;
  b=Ulx7Z97VCBmMfuUli+YioAlwrMI8GiwSPmkDgne9dHhIMWWE1ihRSyiv
   meStbY38c0O0xVu220hq+NvkTdt7bV5mrsf/sdzWq39F8eRFpm9T6Kp9o
   0C7HDF0fD1CHh9xx/i/9C4tUwhgt5pq6MP4KkmxUDAvJi4u/5Zyt6qU6w
   X5uLHmjp7Z6LdE0n6ZDBj/PS31inwMaaAxn5ZWxf/FBJGVgse2GuW1Am2
   ssUgeAX5goIDQ0NWY90cje3YhYkNMcGT7R30vlnlFtG7hzLwrJ2QAmgC8
   M/WO0NFxuc3Y+TmS+rcF3vbdAbuNmGnlIVj4d+CliHgVveMrVh8pnWWp0
   A==;
X-CSE-ConnectionGUID: GF36ARCxSoCw7LHb0PKRyA==
X-CSE-MsgGUID: QJ9uhbxkSZ2ODTnIvgNhLA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="34371806"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="34371806"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 01:51:10 -0800
X-CSE-ConnectionGUID: g6HxE+B9TI2Ri6ft9/oxtQ==
X-CSE-MsgGUID: /uHh40zHS5+cKM8qsEjynw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="115231242"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 01:51:08 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 01:51:08 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 01:51:08 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 01:51:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aiLUVt8j66oCf8PK0d1Amnqb22TnHUJRjHRYvYseKVww6qbLpPCfoGEKEZDsHkqYsXuQUNNZqvREV6eQpEXwv2/B8gz2X7uhk7oNyafXcrR+gFuH3ZyN2uGvf5NQPjwLqT3Ptc9i8Prm5T7lNV3X2frk1pSGJyMt+ruX91LlS9WZafOPRNsvwbgAq6MYrg7W0nW5AAKd2YIpfm++dMdcMNPOuENee45oyOw7+GWTCP488tRav3s0I5XEEi0A5iNXpL95Hqq7On+E8+s0uJOTkFron+rHChIYjrtfJ5PXl7P7Pbc+oxjaKqMcEjwaSXvsVOc6OZKrX5+F/fONA1Cd0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m2Tsg8uhijkrKkZXmdF0IUBP5RcuO48YNaKjzbsz/oA=;
 b=tvXBMyJiCRsRKFru6hEv43RTFKJsDdn+I3C2uagcdlyG8NVDTO7CpKHsER7DNnsevdyKjCqdnM0PW10Y9UGHjFjfRx4T+LAqsrzj/3uNuWfDcaGAhMSXxVzt9TgSJ7ONg7/hGdpLLVAQw4Ouxqs9fRHjGy4fDkM+xI/luv02QiqjjtRLzNEWEbXFQjbMhLogtfIzq00KXxUegAetd6K4A7TPXOhI7rfO4MRxc/IP87QBWugvlkoxeSWrmj/CXwTKnbU+ZCfpmvEkMZxGOaefRNu2XtNLrt2cJXKP1xfbC10OT1coi1b2G0ov47pAgQqBR51MiQwFnDAyHTp0xHzGpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB6173.namprd11.prod.outlook.com (2603:10b6:8:9b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Wed, 6 Nov
 2024 09:51:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 09:51:04 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v4 04/13] iommu/vt-d: Add pasid replace helpers
Thread-Topic: [PATCH v4 04/13] iommu/vt-d: Add pasid replace helpers
Thread-Index: AQHbLrwadjuhsNo8NEGmUJt6qlMg6LKp2axQgAAmLICAAASugA==
Date: Wed, 6 Nov 2024 09:51:04 +0000
Message-ID: <BN9PR11MB52766A4A2C15C9C58F9513128C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-5-yi.l.liu@intel.com>
 <BN9PR11MB5276B9F6A5D42D30579E05E28C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d218eb1c-ca02-4975-bd6a-310a81b3d88c@intel.com>
In-Reply-To: <d218eb1c-ca02-4975-bd6a-310a81b3d88c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB6173:EE_
x-ms-office365-filtering-correlation-id: 79722687-ad25-43d8-1f75-08dcfe48875e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RENRQzBxQllnenNBL1JxUWFFQnZsUjByYWRPSFludjlreHBDQlFPTkVWK05t?=
 =?utf-8?B?MjNMMGExaUdBNUtNS3NiS1oyK0xZWjM1SFBwY3RBeVhKTytIWTNpL0VHL1pD?=
 =?utf-8?B?aVNJSjJoTEFPNDByc2l6RDUrZzhvaUJCWTZsaTBRU0VFTGhYbC9oTW9PS2NH?=
 =?utf-8?B?NjVYd1NmMEtwQU5kOS9SUjU5T1dMZWtCb0ViSW12ZDJvYitlRXowR1F5dEVO?=
 =?utf-8?B?eDV3bGlVcVVkU2VFTWhEajZldTZhOFVXV3J3RllFWEY1SlBrVDBWZ0lNZHN5?=
 =?utf-8?B?dDYyTnEyQUJxa3dlbm95SHA5czVBaVJ6VEg5cGFxNG1HRkZMTnBkUHdvbXhi?=
 =?utf-8?B?elJLenZmUE4xbmhWSGx3aGM2dkV4Q21GUlYxSUVZemc0b1NBWXc1L0ttUG5H?=
 =?utf-8?B?NW9TdHBzRG9STmJ5Rjh1d3dSbHhzKzkxUmRDOWRXWVk2UzYvNWQ3d2ZxLzMx?=
 =?utf-8?B?MmNramcxWUozWDZEOEFyQVhjZjdsRjl3WXhTU0F3bUVXakFZMytXUWVRUnVF?=
 =?utf-8?B?bkIvOGFUNFBJYmtxUnR5eUVuWUhnOTFXU2Z3Q1N2VlQ0QW1keksvT0NhZFhR?=
 =?utf-8?B?dXNPWlhDaWV3Y2F6MTFENEkwbkVha3RJL09BWjVLTGRGVi9RRVBYWmNUeHpK?=
 =?utf-8?B?anJPd2UyeFJ6NlZOU2ZjdVJDaU5lbkh2eWo3cGc2dTBmaGd6UmhmdlFHNFp4?=
 =?utf-8?B?enV6dkV5K1RpWVM3YnZNUklQNjJsNmhSZHJMUGJBVUV4d1k2ZUduWXZtVjcv?=
 =?utf-8?B?d24xTlJ1ck0wN3dOa0VYVTlkd2ZZamNlY2dhaFk4N3hmQlRvMXErUGpqM1FI?=
 =?utf-8?B?QzM5NW5nZm5reWFab0U2bnBQYXRkSVRHaFo0MnIyMFZjMDNvYzZWRUthLzZC?=
 =?utf-8?B?RktzTFQ0YWFXelkwb2FxdTNHTjdkc2hmWFh3eGpmNjNiQTgyWDFjZHNZZlVI?=
 =?utf-8?B?b1NkTGZpMTZrUFZEdmdrOTUvbEY5dUl2QUROUkkxT2dNdVdCQjRDbThHQXJH?=
 =?utf-8?B?aFlpUG1xeDhSc3dqVUFWSWdZcVJPMElObGl3Z2RpeFV1ekpMQ3ovMG15MmUz?=
 =?utf-8?B?ZmxZS3hpQnBYK0RaRk0xZ3l0UnVqblE5cVpQbGF1cWZIMm9iMHdzVGprU2cr?=
 =?utf-8?B?cWYvTTFOUmtOdGpydzZPZ2VaamYwaU1kK1Q1a1JJTUI0T1JZakdLaUYxdGN6?=
 =?utf-8?B?cFY3S1VobDcrSDJGc2NYaHJCd1IxSU00bkJnWWJCaDUvL0IyZEtpUWpsZFVn?=
 =?utf-8?B?WTNsK00vSXlhZjJBeFlXUHp2L1JIYTVBWldJcU5ZdUhyMFM5VkJ3MDV6NGZT?=
 =?utf-8?B?WDVZYURWODJGcUhBaExYaEVKK1dxVzhQUU90blQxY1llWWlRMzBhMXJTY0p1?=
 =?utf-8?B?N3RnMjNpSFJBS291enFTVytWc2FTRjQyeUhqV3R5RlgxR1VHZmU0ZC9qeDIw?=
 =?utf-8?B?Ylp0aFBiaTlSb05TQnUzN1ZpWFpYUUxsV05pSk9BSlJzQmJETTdTek1URkNF?=
 =?utf-8?B?SzlZdy9FU2E1amJXTTRNbnByaHlHcytJYUt0T0dpc1VNa2RaakNsOEFkTW9t?=
 =?utf-8?B?TnBLWHBUM3YyM2ZYd0RmMmZURURzQUhKR3dacjlWM0MrcE5Hc3hvRFVsZlJl?=
 =?utf-8?B?b2dGUmJqM2V1b3pUWEpvMmFTbjYxTlNkMk11WXlVaFBwUFlOZTlsMm92ZkpH?=
 =?utf-8?B?VXpCY0hmRHF2WlBQcVN4VkkweElaRzdVNktpc05kUEdYNks0a29xT0VFcTFq?=
 =?utf-8?B?bXBTUEtpNEJlT0h0UDZzUGFHRG9YTVluY2hpK1AvK2lhcWtrS04wQjc5SlVx?=
 =?utf-8?Q?uFqUtt33RZVlD1ReFq3QzZtBVjpOyu6p9HgBc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TlFNc3NpKzBpbFhnbzVSalcvWEFucEhJT2ZJenR1NktnTjZtaTlXTjdaTmZB?=
 =?utf-8?B?VGJtdHpRTWQxMHhvRjMzdTVXNXJtckpTVm9OZG5ZUWxqejJoNkNYUGxWZ0gr?=
 =?utf-8?B?UG9POXNjTW5tdVFWNW1iS0FXNmp4UGlkODgwOVozZFRBTHd3U3JOeGVYNkRr?=
 =?utf-8?B?YWhHTmVnNGhPOGNjeGl6ZlgycHdxQTQxcmVieHkyUnV0bnJ2R0h5MGNLOFE3?=
 =?utf-8?B?T3NZTGdBTTd3MUwyM29UN0tkUTZ4QVFncVRGTWNxbGk0ZXY5cEpVUmFDL1Jr?=
 =?utf-8?B?UElTM1Fwa0YyYTB6bld4eHNxTkF5UkZRclZYNkgvVmJZZ1c2VHlZb0RqZEZT?=
 =?utf-8?B?bVY1RkVzeFZ5ZEtoOGtCZlJTVnFCdHZydFNrOXdCNXRyMWVJSTVtQWdab295?=
 =?utf-8?B?R01vYnVuYU9wYkE4SUxzQmxwN0VDR1lTY1NNZW9GcnBETGlpaGhLa24zT05h?=
 =?utf-8?B?UnZaMDZmYlN5ZWRsOTRJL28zdkxLa1dybEc4RFBFYS9tQmhabVpKbk1VR3lJ?=
 =?utf-8?B?OHFCRjVmencrQ3ZCcDJ5TC9wc2lCNll3dEc4bDREaWNuZ0JOUE0wM1VwSk1s?=
 =?utf-8?B?SW8xaElZRVV4YkJpZWJXb0paRkpmRnZPd3JuK0wzZW53WDY1VTlHMjQ1UTI2?=
 =?utf-8?B?NDBiMVExT2pvMVUrZzRCYUpFZ2FVcUFWQWxZVENmWEJCMTVEenFWcFZQYWoz?=
 =?utf-8?B?ckNFblJnMHV6ZGhsUjdOQ1JYMVhIK01Wa21Zby8xUTVjdVMyeUtwTTNMcE5W?=
 =?utf-8?B?L3hRdnJNRUIySkRsSlh0UzVsWjROZWY5aWtEY2JHbXkvMVFCcVh6S2dNckFU?=
 =?utf-8?B?cTluTlJUUmw1QjlFMFo1RjVIYk1TRFR2OHFYeHdvTmZOM0hWNmticU1oZUZr?=
 =?utf-8?B?TGMxR055aWhWU0hDWVZtUFNPR1lLWFpidHdBU1RQOWJqWjRSME43czh2VDZr?=
 =?utf-8?B?ZWxFSFJrU01yUGlpR2dUUTJBeWd3NFZjekkvWGYrL0ZLc01wdzFTcVUrMWxX?=
 =?utf-8?B?R1F4ZkFJSlRiYkU5eTRIdENsNVpWQjNCM3BaUGtMRDk0Vjl1RU1wRFdIUzk1?=
 =?utf-8?B?K25SNGkzamZTZ0hTZDQzc1Z2dlZ1VVZ0a2doQ1pqa2k0ZURPMTJjTjhXUm5n?=
 =?utf-8?B?OWdrRWY0OEpjU0IwWUFYSDJ4UHo0bGd0QmtPM0VKL04wYnI4OTB3K2xaT1Q0?=
 =?utf-8?B?eHFLWDNISnJTK0lCY0lYb3psZ0t6bUxiT0hrS2xYRWVPV1E2MW5taFd0dkZz?=
 =?utf-8?B?U0VyVTZNcjFBNE9meGlIbE5aRzVkZXJTZFduQzZnRXdlTFJtSTlBL0dPWVo2?=
 =?utf-8?B?SkZaUUF3dXBLb1VsRmozdjNhVmxtamlkR081aS9Ib2VaRVJxc3gwMUwzdmU5?=
 =?utf-8?B?Ynl3OEdiejAxakRTSTFGRTZubUlPMXJNVSt3Q0FvOVZ0dEYvZUgwTmgwZnNl?=
 =?utf-8?B?SXZSbVZqalBROTc5M29iVFl5MkEvYmdxQ3Z2NTBuNi9JMzlKRzgzUHErMGlK?=
 =?utf-8?B?dFN1NmtRWlRYZnBIVU5MTmt3d3hpM0xsY2ptMjhSUWVpK3FTN2UrNFhqVDlK?=
 =?utf-8?B?eldsZWRFVEhNN0ZpSVNZVktZWm8vbTFXbmgreElhUWk3NXZLT3orK083b2l1?=
 =?utf-8?B?RVhQcHhMMkd0K29RNFV5bS9BK3pWNndsS2FYakVYdVREVkVNMHplYU9tUGl2?=
 =?utf-8?B?Z01INnk1b2x2TmlXSVRNdlZ6VXpyWGtVMXNmNzlQZUJrdkh6M3dtUWMrUVpm?=
 =?utf-8?B?THJDVXdHN3JGQm1vMVJMQkVkOTlOTktHUmNyVWd0SUZFVkkrSUYvTTM4ZzV3?=
 =?utf-8?B?L2k4TWlCZnBlVWl6M3g5VFE0Y0NvWjBTdkNINVV3QjY0djZsdGIyak1SNHVB?=
 =?utf-8?B?UTBJOHg0OE1EMjI4VjAxaUVXa1o3TnpWT1ZtMDY1U20vTmF5eUdmSzFCaEFH?=
 =?utf-8?B?OW41L2I0ZGNEeERYVCtYT052ajFqbWlReFptaGRSYmVEWXhYeDBUNkVWOWlZ?=
 =?utf-8?B?cFVUZ1ZKOFpvclMvSVdldlFxeVZZaE1Vb1hhOWM1OVVPd0RpVllwc0lVOVVi?=
 =?utf-8?B?aWxFRGUyQTdvT1BNYVg4WXo1bk1hMGk2djM2RzA0Qis1NDNWUEZTVHdYZERZ?=
 =?utf-8?Q?xhyPTzsAV4WefQ2u6cpo/Zo7B?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79722687-ad25-43d8-1f75-08dcfe48875e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 09:51:04.1443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dau0ily5JcXbCqnJDG9JB29CE7vWiFs+q1A4JIeawfWTnJvF9SO9ACsTjG7Zv3Shd0r7AIg9fZNAByOVQfAMJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6173
X-OriginatorOrg: intel.com

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5
LCBOb3ZlbWJlciA2LCAyMDI0IDU6MzEgUE0NCj4gDQo+IE9uIDIwMjQvMTEvNiAxNTozMSwgVGlh
biwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwuY29t
Pg0KPiA+PiBTZW50OiBNb25kYXksIE5vdmVtYmVyIDQsIDIwMjQgOToxOSBQTQ0KPiA+Pg0KPiA+
Pg0KPiA+PiAraW50IGludGVsX3Bhc2lkX3JlcGxhY2VfZmlyc3RfbGV2ZWwoc3RydWN0IGludGVs
X2lvbW11ICppb21tdSwNCj4gPj4gKwkJCQkgICAgc3RydWN0IGRldmljZSAqZGV2LCBwZ2RfdCAq
cGdkLA0KPiA+PiArCQkJCSAgICB1MzIgcGFzaWQsIHUxNiBkaWQsIGludCBmbGFncykNCj4gPj4g
K3sNCj4gPj4gKwlzdHJ1Y3QgcGFzaWRfZW50cnkgKnB0ZTsNCj4gPj4gKwl1MTYgb2xkX2RpZDsN
Cj4gPj4gKw0KPiA+PiArCWlmICghZWNhcF9mbHRzKGlvbW11LT5lY2FwKSB8fA0KPiA+PiArCSAg
ICAoKGZsYWdzICYgUEFTSURfRkxBR19GTDVMUCkgJiYgIWNhcF9mbDVscF9zdXBwb3J0KGlvbW11
LT5jYXApKSkNCj4gPj4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ID4NCj4gPiBiZXR0ZXIgY29weSB0
aGUgZXJyb3IgbWVzc2FnZXMgZnJvbSB0aGUgc2V0dXAgcGFydC4NCj4gPg0KPiA+IHRoZXJlIG1h
eSBiZSBmdXJ0aGVyIGNoYW5jZSB0byBjb25zb2xpZGF0ZSB0aGVtIGxhdGVyIGJ1dCBubyBjbGVh
cg0KPiA+IHJlYXNvbiB3aHkgZGlmZmVyZW50IGVycm9yIHdhcm5pbmcgc2NoZW1lcyBzaG91bGQg
YmUgdXNlZA0KPiA+IGJldHdlZW4gdGhlbS4NCj4gPg0KPiA+IHNhbWUgZm9yIG90aGVyIGhlbHBl
cnMuDQo+IA0KPiBzdXJlLiBJIHRoaW5rIEJhb2x1IGhhcyBhIHBvaW50IHRoYXQgdGhpcyBtYXkg
YmUgdHJpZ2dlci1hYmxlIGJ5IHVzZXJzcGFjZQ0KPiBoZW5jZSBkcm9wIHRoZSBlcnJvciBtZXNz
YWdlIHRvIGF2b2lkIERPUy4NCj4NCg0KSXNuJ3QgdGhlIGV4aXN0aW5nIHBhdGggYWxzbyB0cmln
Z2VyLWFibGUgYnkgdXNlcnNwYWNlPyBJdCdzIGJldHRlciB0bw0KaGF2ZSBhIGNvbnNpc3RlbnQg
cG9saWN5IGNyb3NzIGFsbCBwYXRocyB0aGVuIHlvdSBjYW4gY2xlYW4gaXQgdXANCnRvZ2V0aGVy
IGxhdGVyLiANCg0KIA0KPiA+PiArDQo+ID4+ICsJc3Bpbl9sb2NrKCZpb21tdS0+bG9jayk7DQo+
ID4+ICsJcHRlID0gaW50ZWxfcGFzaWRfZ2V0X2VudHJ5KGRldiwgcGFzaWQpOw0KPiA+PiArCWlm
ICghcHRlKSB7DQo+ID4+ICsJCXNwaW5fdW5sb2NrKCZpb21tdS0+bG9jayk7DQo+ID4+ICsJCXJl
dHVybiAtRU5PREVWOw0KPiA+PiArCX0NCj4gPj4gKw0KPiA+PiArCWlmICghcGFzaWRfcHRlX2lz
X3ByZXNlbnQocHRlKSkgew0KPiA+PiArCQlzcGluX3VubG9jaygmaW9tbXUtPmxvY2spOw0KPiA+
PiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPj4gKwl9DQo+ID4+ICsNCj4gPj4gKwlvbGRfZGlkID0g
cGFzaWRfZ2V0X2RvbWFpbl9pZChwdGUpOw0KPiA+DQo+ID4gcHJvYmFibHkgc2hvdWxkIHBhc3Mg
dGhlIG9sZCBkb21haW4gaW4gYW5kIGNoZWNrIHdoZXRoZXIgdGhlDQo+ID4gZG9tYWluLT5kaWQg
aXMgc2FtZSBhcyB0aGUgb25lIGluIHRoZSBwYXNpZCBlbnRyeSBhbmQgd2FybiBvdGhlcndpc2Uu
DQo+IA0KPiB0aGlzIHdvdWxkIGJlIGEgc3cgYnVnLiA6KSBEbyB3ZSByZWFsbHkgd2FudCB0byBj
YXRjaCBldmVyeSBidWcgYnkgd2Fybj8gOikNCj4gDQoNCnRoaXMgb25lIHNob3VsZCBub3QgaGFw
cGVuLiBJZiBpdCBkb2VzLCBzb21ldGhpbmcgc2V2ZXJlIGp1bXBzIG91dC4uLg0K

