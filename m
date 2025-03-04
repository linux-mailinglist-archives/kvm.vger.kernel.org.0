Return-Path: <kvm+bounces-40008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DD01A4D941
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:52:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7D693A7FE1
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:45:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BDBA1F4E38;
	Tue,  4 Mar 2025 09:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e2iClcny"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36299C2D1;
	Tue,  4 Mar 2025 09:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741081523; cv=fail; b=I4titDISJZ/X2wPu+EdqKZeGMCbXSqOLfHB6hWwPLxbuywqiASh7A7FQWaHMWua25IRbndM1UgvGF56ihdjmuvCUD8613jXcFlHoh98+zlR9rzvnNerXhi5vuGOsQp/FPHcTv5Zl4L0+QlUpnBZhOE7JlwjueuK2b37arp/NVaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741081523; c=relaxed/simple;
	bh=KaOzJTehlGFUayoNwgcsZ6Vpw5faR1h9cp1TpC/gSFI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZM5sYp6RMgxk0rJERWyvjUkJxTwBui+LJpBA85nbgSD7FWRHgTfHuX1CmG+Ol5+/K3vhdxTLlro0T6bL+ca5bvLevTTHONWmy2ku3YXmcHTbYzvCntxiu9KaCuhNBqVO2ykVFmtYMsUh9V+zvc55I2vm/DW+HiVu02fw+x1eAXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e2iClcny; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741081522; x=1772617522;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KaOzJTehlGFUayoNwgcsZ6Vpw5faR1h9cp1TpC/gSFI=;
  b=e2iClcnykLLgWhf8xKsGG6bOAa/5Oztgnj167d4ykHBl1sB1r7tibRQ7
   0cJEXBkqLNUjj++nDKGNguNyTNZVMF3Y/IDdrdmGT7YmhUw0hUBQvQvwu
   /vmrwbRMVcbbSew9kNSiNOORhVO5MgudSaVU9CYoqXkK62ra+XnsNe+x4
   TNR6koD7WNZRiL35sOeX8T9TyY6zA7FSEdWz3kDwpbnWNdjADazh7Gqq9
   MAa7yIpR4YB+x1j0WuKs1nqyQwD3H9DadiH6BQJg1zgC4xPIYFfjtUOpS
   DA/ryT3Ky8531jwt4k/qjCzHJGjA0ePlmxK1NxwenpEKM05BQqA3MOhv+
   A==;
X-CSE-ConnectionGUID: 2IelSsGLRfaFA7dNiJAWSw==
X-CSE-MsgGUID: EPj83PDdSve1TOJJetZlNg==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="52972679"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="52972679"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 01:45:22 -0800
X-CSE-ConnectionGUID: uUODBbAkTX2fumuLw9/ZUw==
X-CSE-MsgGUID: r9kROhgJTOeiAqVWjWDXjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="118125594"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Mar 2025 01:45:21 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 4 Mar 2025 01:45:20 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 4 Mar 2025 01:45:20 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 4 Mar 2025 01:45:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J6lpsBk3f/I3ZUigkV7hB7vI3/+25bALezwqLfzh1vyAt9dpYgLyfto/s4VaPTkodemTgSIvGlttrUnGKOsTFibXGgCbjJ/jsYb7QkFAfeZzwWICSY7pqSZwzirCXBRbcyJwPg2azXT0myDQxA7g8aZ5OaVaMm2BiKM9W2DlqTEshePqJjn48JSibKua6ePkscOD5OsKQeqPQymRfdmq4OHfp2+ecCBS3iO5hzSm6sdqjsxmdN/8R9EqjkLEdmLsRuY8TlkjGssViCNZZnRVGAoeSrMmr/K8GtycrGX7AvgghrmRlXdhvTorEadneLQm8UUsK76OLdcHG+ms1+VNAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KaOzJTehlGFUayoNwgcsZ6Vpw5faR1h9cp1TpC/gSFI=;
 b=WMM6xAtYa82+uOL/xa/39M3xeoHvniQu+NT1Gf/IqAi5HlW6xXRsLDU0YbOicIS7GUkhWcqKgR0oGe0eF0UAly3QnHPs+9S6Xmwc5/SblRPslI10a0DrtKkRpSMgc3mzaJ8Mtet8dMPsJawIe/PnixTfRkJoTHgau3U5vYXwF97cInwdBOr7eIHH1U6Zhm3t72nJtZ7IkHMx/nwCHr0tvkhFjJc7ZziQ+ekh0kt2NuoNnuqpWf8uQoKglMZDHTpLiZIT2PtewSkzOZk3DiiVivP1FeLW2w0Xyp0IOr9N3RUOHmQv8OxTQA1ip0Gd0scwO8IHoVwxofJ08CrHcRQDUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5135.namprd11.prod.outlook.com (2603:10b6:a03:2db::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Tue, 4 Mar
 2025 09:45:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8489.025; Tue, 4 Mar 2025
 09:45:12 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"xuyun_xy.xy@linux.alibaba.com" <xuyun_xy.xy@linux.alibaba.com>,
	"zijie.wei@linux.alibaba.com" <zijie.wei@linux.alibaba.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/3] KVM: x86: Add a helper to deduplicate I/O APIC EOI
 interception logic
Thread-Topic: [PATCH v5 2/3] KVM: x86: Add a helper to deduplicate I/O APIC
 EOI interception logic
Thread-Index: AQHbjKV6uzNF3UkFwkSPxyhypcWTcLNiuvCA
Date: Tue, 4 Mar 2025 09:45:12 +0000
Message-ID: <ac7d9e0d06bb58e4344c304e21ea9690c4a17f90.camel@intel.com>
References: <20250304013335.4155703-1-seanjc@google.com>
	 <20250304013335.4155703-3-seanjc@google.com>
In-Reply-To: <20250304013335.4155703-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5135:EE_
x-ms-office365-filtering-correlation-id: 3d5c9bd9-f32d-46dc-1e66-08dd5b014265
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Y1ZnUkNkTkJHclFDcW9xWkduOEcvQnZqTkUxQ25wTm9FaWRSTEdiVTJTOUFr?=
 =?utf-8?B?STA4Vmtlc2kxYTlJWHVvUURRTzF2bll5eWtyTXVLeW1tdnh0Z3lYcEV6R2x5?=
 =?utf-8?B?MDJKY0JDbitjUzBOTlFrWHNBb256OTRGNEtvdGVFcW9ZeGJlQmxQQkdYeXVJ?=
 =?utf-8?B?ZzZUSDViMkpzb011S1pyMXRaZU8zclZrZ2ZyZHZCR0h1RllvaEYrSWlxK0I1?=
 =?utf-8?B?MXZ1UXBCa3NXbkNXdTVEKzFiaGZHODBOUys4RWZ4anRmOUJ1Yndwczg1VDNp?=
 =?utf-8?B?SjdlNDFFZGJvZDdIOEh2anBaU2hIb1FCTzZ5SDJoT01nbjRIakdPQ2hDazlo?=
 =?utf-8?B?SUJHamZPRWRsZkFibmdHY3h1ZkEyVFdhMWxxL0xwRi9IejQyQmdFMTVoOGZT?=
 =?utf-8?B?V3VUaG03ZFdodDRnREZaSVFMdFQ1ZXdWV0FZOXdHL0dETkZOVFV4eU14SSts?=
 =?utf-8?B?R2h2OFowcWNWdTJ6emMxbk5nT0ZkYk5XM3Vna2poTzh5YmJMQU5za3BNdG0x?=
 =?utf-8?B?aGdVcGxLWEJXcW1YRG56VnNVQmp1cnZJM2orVGtueXFrM2h0cVpXT1YxdTUw?=
 =?utf-8?B?NzFTWXhCbGtBSDk1S2QxcXM4QWhKWEVYWXNTL2o1bzEzZUpRMDdHVlJhNFFS?=
 =?utf-8?B?NjRobUo1NlRuV1ptTzB2eWlZbnUvbXFqVTh3RUJPMDU3ZkpjK1BNWXBGLzlX?=
 =?utf-8?B?TWVqQ0hJcnEzUDRaWS9LOTRPbndSVENKNjlISGtQMG03SVlSaWRNNHp4T3Qr?=
 =?utf-8?B?bjlRYkRyWXlTSE5hejEzQVg0M1g0Rm96UlJ5aVcvM0hicFNYaFNvN3hOdm54?=
 =?utf-8?B?UW8ybTR1Mkx5Wm5vQzZOZW5TV0VIQS85N3k4a2JOUWlyOEpSZytva25rWjND?=
 =?utf-8?B?SFFab0ZTVVdVcnRRYlFpazVzTS9YdDBQRlU3Q2JiaEU0dndIVE5WVzd5RDBn?=
 =?utf-8?B?Ty9PT1ZCZ29MdWRGcWgvcHhFYUtVQ3pOZ055dnRKczcydVZKcndwclQrS0xx?=
 =?utf-8?B?THhiU3ZBMGs4NXU5L3NkdTUyRExrd2FudUxwalVGZmlYNDgzU2JZejA3b0oy?=
 =?utf-8?B?VE1zbTVjSHdrNE51QzFob0tMUnlWelAxV1pVNzAxTWNYUnk0WURTSVUvYUR3?=
 =?utf-8?B?amxCSWhmeUZYbXY3T05kK01uTStOVk4wMWUvQitZNDNOazlDbmlMdzh2d3d4?=
 =?utf-8?B?eVhsTnV3Um91L3VIUjhTODZpVnlFbWt2Mkg0U2hmVkoveGFJdGF4Mno0S0Rl?=
 =?utf-8?B?K3NvL3RybnFidmt3Rm8yM2VHR25XWlA4ckdBT05BSGZkcG1DREJBVzA5TFdn?=
 =?utf-8?B?TElzWDNxaERmT0NRVjdjcW1RS2tkMDVnTmpQQXZVRUNyN0VEeVVPaDNUM2Q3?=
 =?utf-8?B?eE9jdm40OGdrdWFJWWI2cWkwYTB1eVRFdWdiK1B2SndvV3QwU2dwc3djTDNp?=
 =?utf-8?B?aW81ZXlLMEk0N0VMMU9PS0xwdW8zdnVyUCt3TU15Wi9hZnladXV4Yk5Lek5B?=
 =?utf-8?B?QWNyOFhpak9aSjFCYUI1c2xUZUV4NU1JeEdqOHFjS29XM3JKOCs3L2wvQzVa?=
 =?utf-8?B?VnJWVjdLRXdubUs1c0xlcmJ5QmJIRzQwcmR3Q0krczRvNW1KQTduWTcwUWN1?=
 =?utf-8?B?UVUwcHpUNGN4NHNyTUV5ZXA3T0VYZ05YYmpTSDVQUGFPVGpvbU0vSTNYYmFI?=
 =?utf-8?B?NnprOU1aS2NtTHI4Q1BsSDlJYzF6WVNyaEhKTis5MlJjZTJSQU9hYXpWeVpH?=
 =?utf-8?B?UnRCZUhCNjd6dmhpK1ZYQXE3U2hEdGhQRnR3ZkZxVEkrb0k4cVE1ZzQ2TmtD?=
 =?utf-8?B?YzZPOC9Md0k3OVNIOFZLTkM3VmhORjljZzJKRjk3aTZnN0lMVk9ranFqTFdH?=
 =?utf-8?B?SXc2Njd2M1VmVlEzcVljaTlXUUdsMUJqKzNtdnhwS2JvZUgzb3piMTlrcW1l?=
 =?utf-8?Q?//W/URW4d/xI7Nvpu8gnDnK4hl+hy6gj?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0xXNWlycjMyTnRjVTFQcHhTRWIrZitFU2Zkd1BmSVZWZGdpU2VaTHRFNStR?=
 =?utf-8?B?cUVrOTRWL0psQkV5UU9hZFNTSDhBS0VKUHkyN2Q5MTdGdEV4aEZWVk5DMlFs?=
 =?utf-8?B?ZzZDTG43SDBGNFEzb3dzcUdaRGxLYTBrd2JzSEtLV3M1MnNxeWJlMC9BUkdF?=
 =?utf-8?B?b3dvcVpxUzd4S3VjVGFUdDBzZ25DQUw0UlhZUGNXSEsrUDZZdHZ2bUJkR3Nz?=
 =?utf-8?B?R2diOS9QZ3RXamI0S0tDQ0NGTjZQUEkzSG1zalVGYUZmODdPWVU5UW55SlV6?=
 =?utf-8?B?SEQwVitwcWRhU1haNzg1RC9SeVRHUlJrcTloVjdueUJWbXRkN0pkL0Z3ZnJ2?=
 =?utf-8?B?Nzl4LzFWV0VQR2x0ZDNSZWUrWlhDQkVwL1VFNzhhbHUzK0FyZlZzUnlTaXBu?=
 =?utf-8?B?dEs1WnhxQXhUZlh6RzVEMjNuMTBYRThtYXVkbWpidytPOUhzVGdSY0ZlL3B4?=
 =?utf-8?B?SXJrV1U4L2haVnN1bFJMUDcwY2tnUng2YkR1UXE0OVVvU2F0WE5zdERONlVw?=
 =?utf-8?B?QWJmSVBHQUhrNEl1cUdCL1lndWhjTHArU2Vnb0xCeXlQOGlML09UQ1hjN3c1?=
 =?utf-8?B?ck1mR2ZnMk0rNmFDMnVjSVhjSXRLNEhVQ3NVb3Q1dzFmWXNFWS85aWRVUlNN?=
 =?utf-8?B?ZlgvL2d6R3hFcC9pTDhTenhIcTlHdGp4VjVBYlhuV1E5MUlUUDhTbzBGMXpX?=
 =?utf-8?B?ZVU1c0hqRVZWc29tY0VQSFJHSEZ0VmZxUHNwWTFuVFRBaHZ1VlpQWUJseHBk?=
 =?utf-8?B?ZmQ4bW9RSDF4ME1QMWdWOHluTWEramVYaStra0dPdUJ1ZWM5ZTNNY2kyN2RV?=
 =?utf-8?B?SFFiQURPamJTditkRklGamg0VWdnWm9oTXdkeTBSNGN1MFp4Y25ESDk2T0Fp?=
 =?utf-8?B?NU1qR3ZYaUJuZmRwZTZtWHdxV25WQ2dJZWlCYmtQcWgvR2NWeHFWNzhRNnpK?=
 =?utf-8?B?YXNLbXJNSXR6QTBUU3EwQnBqU0x2NXFxanluUUh3VTNMaEw4NW00SEo5ZGlV?=
 =?utf-8?B?MlhNY3duMnEwMWdqalJDU0NqOXBKYXBBSHFueEpVcm1FemFXelJqSXFiTWRM?=
 =?utf-8?B?b0xXb0lZMTE0NWN4Y3o5ZEFVTkM0R1dodWxRSDBaVVFQTnFXVkU2VEpKQ2ZJ?=
 =?utf-8?B?U1NaZzUzV0VCZ2hMbm9rRmEveXdUTnZReUlzaWRkWC9sUUtUYUxjMXkzekF2?=
 =?utf-8?B?ZThTL0NPeVFkOGJTZEo5L011WnBLS3hyZ0JrYkRSY1gweDByN3l5SlBWT0ow?=
 =?utf-8?B?Zzl1SWJ3dlo4SFVOS2EyS2VpU214SXoxa0xGdkFNV0Y0THl3Yk1uRGtMT3pt?=
 =?utf-8?B?N2s1Z0phSWhqekJrYTBWendDaEJURVRoNW00Sk52NEJ6M0NFVkp3VzhyM1U4?=
 =?utf-8?B?K1VoTG4yMzJrc0RtZzJ4cVkwTy9nSUZIRy8zT3g5WlJEdEpYZHRTckdtRTNr?=
 =?utf-8?B?L2lGb2k3UnVpVXZvd2lIVEdpZnRUM2tmTEtzWHc1cWhGRFdFd0M0ZFkzK2pW?=
 =?utf-8?B?azdnOGpPNTNyMzlJRjlsUVJSSjAwS3daTTRsYnJzZ01VM1ZFM1NScHZ6Wjh2?=
 =?utf-8?B?aE5FcUdvNmYvWXpLbmY4SFdYQ3pJQ1QyVjdRM2RDZDcyb05BRzB3L3A4MnNG?=
 =?utf-8?B?Rk1DT203Z0poQ1hmRFM4UGlTUGhjWGIvUEVYdXowWU1lVkJ0QkZHUEdFVXJi?=
 =?utf-8?B?UGM3aWRiODNOUlgrbG96SHIwMVpNN1hDNzNFQXA2K2NmUE80ekVGYW92RWY4?=
 =?utf-8?B?ODNka0FTWGxnRFZ5K2VlQVhCUjh6QUREanR2V1hrSHJpZzBPby8xODdiR09R?=
 =?utf-8?B?Ukg1Wi84TzhOWTh3ZDlNRUZYK0NFRS9yV1hSVm9RcTBrMGU3RHh1S2gyMEpE?=
 =?utf-8?B?M0I2R3kyYnRLL0oyNkRmRTNCaSsyMlNBUitBZ053TC9yTC9hM2pGQU9JM2NX?=
 =?utf-8?B?T3BzL1Nxa1I2SzdtQ0o2V3ZsOWI5Z3pRQWc1RjJzRlVzUlZNbnduQ1pWNXVT?=
 =?utf-8?B?SVRzNDA1NFFwYUxuRWRCTG9udXpQQnJ1KzdiQXNaVzJLOTJ4ekoyWGNieFZi?=
 =?utf-8?B?MjRtdWQ3Q0xOREVXNDRsd2Y1d003djArbkdQUzFUb3M4TEhPclIxdHl4am5I?=
 =?utf-8?Q?LzpB5/2tSRq3nUDZr2l+9BxPt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD997542ADF24841A42805B3D617BF51@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d5c9bd9-f32d-46dc-1e66-08dd5b014265
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2025 09:45:12.3243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OC6qVIC9AqS9XfPMvrvoqfmemUC9XXamhxpsIqy8nbK3uqaO1mBjvVOcomWhpiWpKiItlNUITMRr95TRa5H/jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5135
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTAzLTAzIGF0IDE3OjMzIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBFeHRyYWN0IHRoZSB2Q1BVIHNwZWNpZmljIEVPSSBpbnRlcmNlcHRpb24gbG9naWMg
Zm9yIEkvTyBBUElDIGVtdWxhdGlvbg0KPiBpbnRvIGEgY29tbW9uIGhlbHBlciBmb3IgdXNlcnNw
YWNlIGFuZCBpbi1rZXJuZWwgZW11bGF0aW9uIGluIGFudGljaXBhdGlvbg0KPiBvZiBvcHRpbWl6
aW5nIHRoZSAicGVuZGluZyBFT0kiIGNhc2UuDQo+IA0KPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBp
bnRlbmRlZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5q
Y0Bnb29nbGUuY29tPg0KPiANCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGlu
dGVsLmNvbT4NCg0K

