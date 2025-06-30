Return-Path: <kvm+bounces-51093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBB47AEDB30
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 13:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A56517608A
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 11:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACFAC25E454;
	Mon, 30 Jun 2025 11:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DPS5fQTO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B75242D81;
	Mon, 30 Jun 2025 11:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751283322; cv=fail; b=tlSX2Vs5JsgVTAkTip+uUgJRTl4S511ClfG3p7s8z9e36ujEju4Ar/NuZ9izrTr6XBBBYRl976Ou5UF3ICg+CfwFmQS5bmTNAmuy30Nr4/HCIL9eHgKNX9HJ/4oIzKbOS8xFUdU0HFfa8acrYocXOF9CFwmsL6jkEcjPVGu6BbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751283322; c=relaxed/simple;
	bh=++oP6Q91dMR/VzexRXM6VzNRyNmpENES4iO5vMjnkNY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T4UDeXiFERAHeXg03ZgqVu6r90uctiIHe3DlxC1VFeqQ/fJdRknzTxLx6r6TgWdfkjr9V9BCa8kyerPdkfPcLGlZTQGmVpnS4T4OISU3lVYy7/4gvXHN6mCqJZJbufMj++Ishoj+sPwQ92fi56u2RChMqG9RRY540pvdWYMYLGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DPS5fQTO; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751283321; x=1782819321;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=++oP6Q91dMR/VzexRXM6VzNRyNmpENES4iO5vMjnkNY=;
  b=DPS5fQTOEAh/hOQS2TetWOIWs+ViYg+99cbzXAHLjGAPeIBiC9Z9TydT
   k6PtxKAFPFEdoeEj9RqLNzlcVyZs6C4kELLovAG1X3pEzNRmtRPbQez7u
   J49rI+ZiO98FXySZUT/LZYqRv+JIXbfpm3J5FHxCLjMqM3k+fxLZGjN8Q
   6cmNOR822Z19DuzQK+zB/44Whv13xoXPDAy8/sD97u3cudsZ4SHEkKmFB
   pqk9cVWn4dcoeh/+8mg7U5em/uPRU0aU73M3qcq2i0V6rQP0vloWsEAj8
   t4w1JDR9dZnnuTLhb3gcFT/9z2Yvy77xqX0/3lFL1cYCeYml/pSMLL/fE
   w==;
X-CSE-ConnectionGUID: eWrNqXPGRMKeO5EdECedlg==
X-CSE-MsgGUID: sa2WyGwHRlWFcJ0LWqggZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11479"; a="41132672"
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="41132672"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 04:35:20 -0700
X-CSE-ConnectionGUID: XURgSGU0Qx2QYXdiCvw00g==
X-CSE-MsgGUID: DT3ogzyDQQeSGIgUpr9lng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="157710011"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 04:35:18 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 04:35:18 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 04:35:18 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.54)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 04:35:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KOsIGT4u3LwZ6gGcS3FtF3NCnRumYZlnl+2Wvcuj1oFSnHPZZDhb2wAKg93hOFOD1hUL3DWSaTbws+Yq7XWaZ2aygoRcCEI1tLK/aYKJaO8B3V9SBghUBQcahzLd12tqZX96G5lQZ+5hC1k/BQMveiT51He8oX21wDezp/ScVxsmP5g/54hTtQs/nCNA4Uq1qZ1fiak1Mm+8ms4ymvsQtc8KUdXLX4YVWGIuHOeeWQ+mXBNHM2ASfO+Drr4eO16LSKG3fPMvfcmbbKx9WE0A6zUX2Q/UD5DRkhoyGC9AZR4C6XeRBfXix+3Kd6AEELDJUj8RH0eKYldMUmcUzqK3RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=++oP6Q91dMR/VzexRXM6VzNRyNmpENES4iO5vMjnkNY=;
 b=M3Q6XXquns6k/lXrbwRhT7EPaa0WaZPVi0pR8Es/nUQOva6/xoZXRVym4Ku0anfn2xQ6xxUnCKobUOuLdTi5xnKselL5XifVAHdAz7rF18GEr5I7PAyhbOhQArptsng5jli2qF31YhXX+0mFt3jqE+gXB1QMEhShJ+c5v5+wE1Jkz+WxWJqqzca9p6H+UUDgfwCdinHC623648I3rrIWm13ltUI/QhDacxxFDz/oxpYmvqnZ1bgFAktix/kfvaig3LeoRtzauCtifRXHPW5DB9Q9tNyhgvJAwTbtqs8pujG3rdwFofspzF5NACynLmdQIBJwOfa+mez/XpJ8rPs3JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by DS4PPF382351574.namprd11.prod.outlook.com (2603:10b6:f:fc02::1d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.29; Mon, 30 Jun
 2025 11:34:35 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%5]) with mapi id 15.20.8880.015; Mon, 30 Jun 2025
 11:34:35 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "bp@alien8.de" <bp@alien8.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"sagis@google.com" <sagis@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Williams,
 Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Topic: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Thread-Index: AQHb5ob1Aej6jhsWsE288GxQicmcLLQYiUSAgAMPkYA=
Date: Mon, 30 Jun 2025 11:34:34 +0000
Message-ID: <e7d539757247e603e0e5511d1e26bfcd58d308d1.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com>
	 <20250628125001.GDaF_k-e2KTo4QlKjl@fat_crate.local>
In-Reply-To: <20250628125001.GDaF_k-e2KTo4QlKjl@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|DS4PPF382351574:EE_
x-ms-office365-filtering-correlation-id: de0c3441-d529-4d01-25de-08ddb7ca16c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WUFLM0JzK1E0cE84SU5CaHVLcndRRmRXdDUwZm4vYVJmY1FVYlU1YS90Y2Zy?=
 =?utf-8?B?MHJhWlNFcnFDK3hoU2ovemp5UFFaVlRFMURMeXA0MVBDYmFsaVg2bjd2cU03?=
 =?utf-8?B?T3NyU1pYanRwVjl1M0tlRzk2V1daNzhDL2tycm5WTjlpTjZIWFI5TGtaY3kx?=
 =?utf-8?B?WFdZYThPVUdRT3NqNWxVUmJxLzBLY3lrY2FKRytScHZWV3gySmdnemRBVTdV?=
 =?utf-8?B?R1l4RXB6NkUvb2txWVppZWVCeXlwbVdEb2R1Z1BLdllxSzJpTHpOaEZlTGJT?=
 =?utf-8?B?U1FSeEdCRGFRWWUyVHFqZG52UUpLMmhaMlZ3U0pTd011K3RlTEVUNk0ySXow?=
 =?utf-8?B?Y0dZQlJocUxWdDNzcksyWXFML0plVkhFRmttNzZyZEMyb1lZRGhlMTZhYzdx?=
 =?utf-8?B?bHBuV3Y3ZU9CdEZVTnM5NlFENjdtR2VOc21nc29VV04vdVBadXZWaFZUWnJt?=
 =?utf-8?B?MjBrWFFqQjFRUTErd3ZBZmZkdWlSQzUwVDdaenFFNmFCcERFcmVKNUdvT2tz?=
 =?utf-8?B?d09lNGkzRk9WcUtiVkhxMGt0N3hobjduN1p4KzE0L0RoaFl6WTlLNEIvTXVa?=
 =?utf-8?B?SVJNTnJEZHBULzkvL2YrWitLL3paT0gycjdhZFRUSXYyc1FuSEZYQ1AxL1VD?=
 =?utf-8?B?bmNsODRaeEt5dFNQc1pyRml0SkxsVTZCVW1jWkxLSXZVVWVzVnBXSHZhWXF2?=
 =?utf-8?B?MC9RSndXcFd0eWJ3ZU9zbVgrK050WFlqVEhpN0tUck1LODVEQU5RQzdpOXAy?=
 =?utf-8?B?NTZCdGN5Y28vQjl2UWVNTjlydzJBKzhGZSszTm1Ic0NUSTFiMjZIUGJkSmJL?=
 =?utf-8?B?MFJTOVdmN0o4Z09XckxjeUNsTGlMejJuREdFR2VEcXFpYlA0UnJpQ2IwSks3?=
 =?utf-8?B?M1BQcHlwUll4UHV5aytJeHI2OVJyNG8ydE1kWEl0cDZaV0lZMzRxbTlyczlo?=
 =?utf-8?B?NmVHRnpDU1VRanJkTkhMMUx0azEzMFM4dG5OR3poYjhSVHg1TlU2M1Q5TnVm?=
 =?utf-8?B?bW9HbUJFREc2YXY0QjhLWGZVRXc0UEYrT0dRNmJwTmdrSnliY1M5Yk5yL25I?=
 =?utf-8?B?ZVVHL2xHR3g0Qm1QR3hrTXl3eHozZG9ZZFJsTEo0V0ppY2NPNERaU2ZoeFZ6?=
 =?utf-8?B?VG9ua3pFNDdQdnduT0ZtT0NHdDNxVFpqSnl1alFreGpsTlR2RkhPMElmMjVD?=
 =?utf-8?B?THZlcXJVY3R0bjhNYU96U3dOalp5bXJCejd3cDRCRUV6Mlo5SVk3L3ZEYm1U?=
 =?utf-8?B?a2k5TVJoa1RkRXpUNUV4eXBnTnZySVlJV0VqMzdGdWpEUTA0ZWE2T25qKzRV?=
 =?utf-8?B?U2dCbEo3cW55VXpjWWFhOFBjZkw3NjJUWW9mZWZwbG5ZaHc3aklua21IbS95?=
 =?utf-8?B?TjVFM3R4UEJPVWJQT2RhZlJFZVJWR0xxTCtXNnIwcGxBMEdYamtOSGk5RCs0?=
 =?utf-8?B?WWoxdDd5M3VxOW1WcTc3eFE2OVdVaVlLZksvaHhITm55MFdrQUJLS2YvbTEx?=
 =?utf-8?B?UE9qNWs2ZjQxNzE5R1RQbmRESExjVE5TQmR6VmJWQk0za2JXc2Y0Nmk4ZTV5?=
 =?utf-8?B?SzJxcHF0aVVEKzhNcXl0YVFTaHl2Yks2Y3dPYUNiejROdzFxcnJYNmxwM1px?=
 =?utf-8?B?ZWpzZXNZSlVCNEl6WUJTeTJwbmRDby9zVWducWgvRzd2WDhNc2pLYjZNWEFV?=
 =?utf-8?B?SDRIVEx1YlV4VzBZd1N1eHQ5Q0ljbkdQUjRSV0RtMEwyK0IxSHhBWm0wYVNT?=
 =?utf-8?B?K09IZXA2TUZyUFptRkhMUnprelVraVBkTk9GV0JBMHdDNkR6RTBCZHBtSXBF?=
 =?utf-8?B?VWdjeWJxdUI3MFlNR0E3WWxLV09ISUYvSVJSSFN1TzJTWWNGNmV0SHJWYm5p?=
 =?utf-8?B?VHhmZ0ZBTE9nZmhSdmlzR1VYZDBrOG9KTmdZTlZ0S2xCTTE2aEZUcDBuYkV4?=
 =?utf-8?B?M0s0MGFJOUR6akxxNWdqUjBkS1ZTeDdTRXlTZ1pyNVlSOUFTQWsrdisxYXFv?=
 =?utf-8?Q?ZF424m7rBAQY6H6bqaGon475NYsMgU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTRSa1BIWkkxTTA3dnNnOTVkc3ZPOG9zSEsrbytMdzFaVFpKQ25EekdNSVpO?=
 =?utf-8?B?bWx3OVZTU1FhdU5qZzk1MUVncFFSSmFsdS9pckpZYVJhZTRNVmJ2bmc3am5h?=
 =?utf-8?B?OUpFVWpCQUNoaW1tNmsvcE9MMGhmN25KVDY0QzRMNUM0TnlFb0REUEpwdHhr?=
 =?utf-8?B?SDZUVWJkRjRMQkRVc3UxY1NySkZmaTZlQ0JLRTJZZDk2NFBHNDNBT3I5WnV1?=
 =?utf-8?B?dHBuT2lJR3IvcnN6UHM2TWdWNjZyQ25USEtiMGNPeU54NjJITi9LWUJURTJv?=
 =?utf-8?B?MTBYQ0tQT0t2MlkvOVY0MUdqWDFERWZXVklkVUJnSXhCaXFKeEVzUEpHWUVG?=
 =?utf-8?B?MTBTTWY0VEpSZVViQXltd2ZFTDdsdWgyZTFHR1BqeTYyK09ZSnlFK3dnRitU?=
 =?utf-8?B?KzRtbm9DV25qYXBsbk9RcmVtL0JEd292dkF3dG43YWlNMmZtTDBFTEZROEpp?=
 =?utf-8?B?Zm8rek1La0dnSGhIQUhmNXNhSmEvTWlYM3JnR3NSSWhtYUtHc0gzY1ZCZGpx?=
 =?utf-8?B?cjQ4aENKQmovM1lLdVgyUDBNNVpxR0FVa1V6dzBFZGVtSy9sUlF1d2dLdllR?=
 =?utf-8?B?cTVMV3RTOHAzdGl2YndOcU9TbEhFUmtLSnkyYjRqWnJ0VnlDUzgxOWlEaDIz?=
 =?utf-8?B?RGhSOFRVUit5RGtqR2hEOUE0QTcyWjc1aHZMeGZRejFVUXhmN1U5QXpnKytP?=
 =?utf-8?B?OVNBVTMxbWFNR2Exa0czZUFwSTlndzMvM0dkczFTckpqcFdPeDA3b0RNdXJX?=
 =?utf-8?B?YUFKUUFicjRzazVwbWYvN2R6UGxYTnNWQlFjTHdrbkdOSDhaUExBaFowbTIv?=
 =?utf-8?B?L0RscGdxdENtT0hCMEJLck0wWnkvSHE5RVp5NmVmUFR0dXdzdEVUZDA5OWtt?=
 =?utf-8?B?ZFh2cE9LRUpvSlArUHZwRzlZcC9WTDl4UE9xU0FEbnpXWHlTZjh0N0Znald1?=
 =?utf-8?B?bVZtMDZJOGxibEdiaERhbG0zc3BlQTk0WFR5L2pqQ0hpcUFKdSszcU9xdGxQ?=
 =?utf-8?B?RXFaU2wxdTFQTVZHOUdIeEpHbFkzdncwQTM4VmszcThNS0d0QlRYU1VPak0x?=
 =?utf-8?B?TldoRHRpNVFBWXI3eldGcG9qVXM0N0gwMWhQRTJqTEJwdzBreFNjMUgxT2VH?=
 =?utf-8?B?MnNlenJ4YXcwSmp5eHJXVjJuNnJLT04vMmsySGpqcnJDcVFkN3N1aE54ZmZI?=
 =?utf-8?B?NkE3UmI5dkpzaXNIVFlMNmRQZS9yNzV1aGxrd0J1eW9PejlxUTZrOFNMYmJo?=
 =?utf-8?B?WjBNcVg1WnR1aFNXTkRCOXVBTnQxcHpISkRrNWtGSUkxdlYxb1JtSjllYlJ4?=
 =?utf-8?B?ZVBWeEhnUnpQeDBzeUlucHdxdHRFSUh0aUZLRXUwTVREbVNRUjBVTzNtMU5J?=
 =?utf-8?B?RjRoSGNlUFVESkxkeWFJbnAxZkZ0SUMzNkhJT1R4VHExZzZuNWJyaE9ZSUhI?=
 =?utf-8?B?NjQ2d0Z1dWZEaU93ckhGUkJaSEJyS2YranZmSm9TQnpleUtzcGwxcUR0VDd6?=
 =?utf-8?B?blRETnJSRzNRRGdVS2E4RTRtRVpGRjlUT2NYZDlKUVdMdmg5cWhQTnlueTdz?=
 =?utf-8?B?MzBTM3l4SmdScmhkR1FzdndiVURVQTR6SXpLWjhUdjRKanhobFFieS9QSGN6?=
 =?utf-8?B?b3hhb2ppRzRBT0Rxd244VG5XeXhEMGhHcDFUYlc2QWJnVnRVYm1CNzIyNlEx?=
 =?utf-8?B?eDAyNFlIQnFISUEwNVI3RkhpbHZqQmFsdXZXYnVqQllVam5sOExwbWl4Y0Q3?=
 =?utf-8?B?bkdLVnlMVVU2dmJFWHkzV3hTQW5ZaDd4d1ZBSTNvYlN0Nmo4M2h5NlFCa1ZE?=
 =?utf-8?B?MXpkMVVUdzZaSy9YOHRzMlZIWXpSMG1OeGtxc1NHT2poRDFGZW1ta1A2Wm44?=
 =?utf-8?B?bXBtdC9jNGpQdTM2bmdQKzcvTXh3Y0VLeUFISW9wNWRHeFN5Y3BZOEtjK1RT?=
 =?utf-8?B?c1J1OGhXdStwTUk4ckFRWTNYSzBtVVozZ1NwZmhMcC90QmFWaEE3N2Iyamd3?=
 =?utf-8?B?bU5IcHBMaC9iNDR5S25ZeDRyOTQrS1RPNW9lWlp1KzNYWXRwNmRmME5EcW9K?=
 =?utf-8?B?VDdFdUI2dmxEaE5oV3VndnBCM01FVjIxcU43YjZHdmNZdW5MUUZDLzZqYnBs?=
 =?utf-8?Q?ywUBBZjTkdZJ4Fk/aLDZO3oZl?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F18ABEED1112145B4F8210BF33436FD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de0c3441-d529-4d01-25de-08ddb7ca16c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2025 11:34:34.8984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kev++P/KfTMCHA2FBQcmA39ePAPW+H/1ygdRF0tfkTFD5bhKHm+WcmO/xnKaAJzEcAYw5NSD1dwOS0NaubR1tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF382351574
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI1LTA2LTI4IGF0IDE0OjUwICswMjAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IE9uIFRodSwgSnVuIDI2LCAyMDI1IGF0IDEwOjQ4OjQ3UE0gKzEyMDAsIEthaSBIdWFuZyB3
cm90ZToNCj4gDQo+IC4uLg0KPiANCj4gPiBEb2luZyBXQklOVkQgaW4gc3RvcF90aGlzX2NwdSgp
IGNvdWxkIHBvdGVudGlhbGx5IGluY3JlYXNlIHRoZSBjaGFuY2UgdG8NCj4gPiB0cmlnZ2VyIHRo
ZSBhYm92ZSAicmFjZSIgZGVzcGl0ZSBpdCdzIHN0aWxsIHJhcmUgdG8gaGFwcGVuLg0KPiANCj4g
T2ggdGhlIGFtb3VudCBvZiB0ZXh0Li4uIA0KPiANCj4gUGxlYXNlIHJ1biBpdCBhbmQgYWxsIHlv
dXIgY29tbWVudHMgdGhyb3VnaCBBSSB0byBzaW1wbGlmeSBmb3JtdWxhdGlvbnMgZXRjLg0KPiBJ
dCBpcyBhIGxvdCB0byByZWFkLg0KDQpIaSBCb3JpcywNCg0KVGhhbmtzIGZvciB0aGUgY29tbWVu
dHMuDQoNClllYWggSSBhZ3JlZSB0aGUgdGV4dCBjYW4gYmUgaW1wcm92ZWQuICBJIHRyaWVkIHRv
IHJ1biBBSSB0byBzaW1wbGlmeSBidXQgc28NCmZhciBJIGFtIG5vdCBxdWl0ZSBoYXBweSBhYm91
dCB0aGUgcmVzdWx0IHlldC4gIEknbGwgdHJ5IG1vcmUuDQoNCj4gDQo+ID4gU2lnbmVkLW9mZi1i
eTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBhcmNoL3g4
Ni9pbmNsdWRlL2FzbS9rZXhlYy5oICAgICAgICAgfCAgMiArLQ0KPiA+ICBhcmNoL3g4Ni9pbmNs
dWRlL2FzbS9wcm9jZXNzb3IuaCAgICAgfCAgMiArKw0KPiA+ICBhcmNoL3g4Ni9rZXJuZWwvY3B1
L2FtZC5jICAgICAgICAgICAgfCAxNiArKysrKysrKysrKysrKysrDQo+ID4gIGFyY2gveDg2L2tl
cm5lbC9tYWNoaW5lX2tleGVjXzY0LmMgICB8IDE1ICsrKysrKysrKystLS0tLQ0KPiA+ICBhcmNo
L3g4Ni9rZXJuZWwvcHJvY2Vzcy5jICAgICAgICAgICAgfCAxNiArKystLS0tLS0tLS0tLS0tDQo+
ID4gIGFyY2gveDg2L2tlcm5lbC9yZWxvY2F0ZV9rZXJuZWxfNjQuUyB8IDE1ICsrKysrKysrKysr
LS0tLQ0KPiA+ICA2IGZpbGVzIGNoYW5nZWQsIDQzIGluc2VydGlvbnMoKyksIDIzIGRlbGV0aW9u
cygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rZXhlYy5o
IGIvYXJjaC94ODYvaW5jbHVkZS9hc20va2V4ZWMuaA0KPiA+IGluZGV4IGYyYWQ3NzkyOWQ2ZS4u
ZDdlOTM1MjJiOTNkIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2tleGVj
LmgNCj4gPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rZXhlYy5oDQo+ID4gQEAgLTEyMiw3
ICsxMjIsNyBAQCByZWxvY2F0ZV9rZXJuZWxfZm4odW5zaWduZWQgbG9uZyBpbmRpcmVjdGlvbl9w
YWdlLA0KPiA+ICAJCSAgIHVuc2lnbmVkIGxvbmcgcGFfY29udHJvbF9wYWdlLA0KPiA+ICAJCSAg
IHVuc2lnbmVkIGxvbmcgc3RhcnRfYWRkcmVzcywNCj4gPiAgCQkgICB1bnNpZ25lZCBpbnQgcHJl
c2VydmVfY29udGV4dCwNCj4gPiAtCQkgICB1bnNpZ25lZCBpbnQgaG9zdF9tZW1fZW5jX2FjdGl2
ZSk7DQo+ID4gKwkJICAgdW5zaWduZWQgaW50IGNhY2hlX2luY29oZXJlbnQpOw0KPiANCj4gU28g
cHJlc2VydmVfY29udGV4dCBhbmQgY2FjaGVfaW5jb2hlcmVudCBhcmUgYm90aCBhICpzaW5nbGUq
IGJpdCBvZg0KPiBpbmZvcm1hdGlvbi4gQW5kIHdlIHVzZSB0d28gdTMycyBmb3IgdGhhdD8hPyEN
Cj4gDQo+IEhvdyBhYm91dCBmbGFncyBwbGVhc2U/DQoNClllYWggSSBhZ3JlZSBhIHNpbmdsZSB1
MzIgKyBmbGFncyBpcyBiZXR0ZXIuICBIb3dldmVyIHRoaXMgaXMgdGhlIHByb2JsZW0gaW4NCnRo
ZSBleGlzdGluZyBjb2RlICh0aGlzIHBhdGNoIG9ubHkgZG9lcyByZW5hbWluZykuDQoNCkkgdGhp
bmsgSSBjYW4gY29tZSB1cCB3aXRoIGEgcGF0Y2ggdG8gY2xlYW4gdGhpcyB1cCBhbmQgcHV0IGl0
IGFzIHRoZSBmaXJzdA0KcGF0Y2ggb2YgdGhpcyBzZXJpZXMsIG9yIEkgY2FuIGRvIGEgcGF0Y2gg
dG8gY2xlYW4gdGhpcyB1cCBhZnRlciB0aGlzIHNlcmllcw0KKGVpdGhlciB0b2dldGhlciB3aXRo
IHRoaXMgc2VyaWVzLCBvciBzZXBhcmF0ZWx5IGF0IGEgbGF0ZXIgdGltZSkuICBXaGljaA0Kd2F5
IGRvIHlvdSBwcmVmZXI/DQoNCg0KPiANCj4gPiAgI2VuZGlmDQo+ID4gIGV4dGVybiByZWxvY2F0
ZV9rZXJuZWxfZm4gcmVsb2NhdGVfa2VybmVsOw0KPiA+ICAjZGVmaW5lIEFSQ0hfSEFTX0tJTUFH
RV9BUkNIDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Byb2Nlc3Nvci5o
IGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcHJvY2Vzc29yLmgNCj4gPiBpbmRleCBiZGU1OGY2NTEw
YWMuLmEyNGM3ODA1YWNkYiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9w
cm9jZXNzb3IuaA0KPiA+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Byb2Nlc3Nvci5oDQo+
ID4gQEAgLTczMSw2ICs3MzEsOCBAQCB2b2lkIF9fbm9yZXR1cm4gc3RvcF90aGlzX2NwdSh2b2lk
ICpkdW1teSk7DQo+ID4gIHZvaWQgbWljcm9jb2RlX2NoZWNrKHN0cnVjdCBjcHVpbmZvX3g4NiAq
cHJldl9pbmZvKTsNCj4gPiAgdm9pZCBzdG9yZV9jcHVfY2FwcyhzdHJ1Y3QgY3B1aW5mb194ODYg
KmluZm8pOw0KPiA+ICANCj4gDQo+IFNvIG11Y2ggdGV4dCBhYm92ZSAtIG5vdCBhIHNpbmdsZSBj
b21tZW50IGhlcmUgZXhwbGFpbmluZyB3aGF0IHRoaXMgdmFyIGlzDQo+IGZvci4NCg0KQWdyZWVk
IGEgY29tbWVudCBpcyBuZWVkZWQuICBIb3cgYWJvdXQgYmVsb3c/DQoNCiAgLyoNCiAgICogVGhl
IGNhY2hlIG1heSBiZSBpbiBhbiBpbmNvaGVyZW50IHN0YXRlIChlLmcuLCBkdWUgdG8gbWVtb3J5
wqANCiAgICogZW5jcnlwdGlvbikgYW5kIG5lZWRzIGZsdXNoaW5nIGR1cmluZyBrZXhlYy4NCiAg
ICovDQoNCj4gDQo+ID4gK0RFQ0xBUkVfUEVSX0NQVShib29sLCBjYWNoZV9zdGF0ZV9pbmNvaGVy
ZW50KTsNCj4gPiArDQo+ID4gIGVudW0gbDF0Zl9taXRpZ2F0aW9ucyB7DQo+ID4gIAlMMVRGX01J
VElHQVRJT05fT0ZGLA0KPiA+ICAJTDFURl9NSVRJR0FUSU9OX0FVVE8sDQo+ID4gZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvYW1kLmMgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L2FtZC5j
DQo+ID4gaW5kZXggZjE4ZjU0MGRiNThjLi40YzdmZGUzNDQyMTYgMTAwNjQ0DQo+ID4gLS0tIGEv
YXJjaC94ODYva2VybmVsL2NwdS9hbWQuYw0KPiA+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9jcHUv
YW1kLmMNCj4gPiBAQCAtNTAzLDYgKzUwMywyMiBAQCBzdGF0aWMgdm9pZCBlYXJseV9kZXRlY3Rf
bWVtX2VuY3J5cHQoc3RydWN0IGNwdWluZm9feDg2ICpjKQ0KPiA+ICB7DQo+ID4gIAl1NjQgbXNy
Ow0KPiA+ICANCj4gPiArCS8qDQo+ID4gKwkgKiBNYXJrIHVzaW5nIHdiaW52ZCBpcyBuZWVkZWQg
ZHVyaW5nIGtleGVjIG9uIHByb2Nlc3NvcnMgdGhhdA0KPiANCj4gRm9yIGFsbCB0ZXh0OiB3cml0
ZSBpbnNucyBpbiBjYXBzIHBscyAtIFdCSU5WRC4NCg0KV2lsbCBkby4NCg0KPiANCj4gPiArCSAq
IHN1cHBvcnQgU01FLiBUaGlzIHByb3ZpZGVzIHN1cHBvcnQgZm9yIHBlcmZvcm1pbmcgYSBzdWNj
ZXNzZnVsDQo+ID4gKwkgKiBrZXhlYyB3aGVuIGdvaW5nIGZyb20gU01FIGluYWN0aXZlIHRvIFNN
RSBhY3RpdmUgKG9yIHZpY2UtdmVyc2EpLg0KPiA+ICsJICoNCj4gPiArCSAqIFRoZSBjYWNoZSBt
dXN0IGJlIGNsZWFyZWQgc28gdGhhdCBpZiB0aGVyZSBhcmUgZW50cmllcyB3aXRoIHRoZQ0KPiA+
ICsJICogc2FtZSBwaHlzaWNhbCBhZGRyZXNzLCBib3RoIHdpdGggYW5kIHdpdGhvdXQgdGhlIGVu
Y3J5cHRpb24gYml0LA0KPiA+ICsJICogdGhleSBkb24ndCByYWNlIGVhY2ggb3RoZXIgd2hlbiBm
bHVzaGVkIGFuZCBwb3RlbnRpYWxseSBlbmQgdXANCj4gPiArCSAqIHdpdGggdGhlIHdyb25nIGVu
dHJ5IGJlaW5nIGNvbW1pdHRlZCB0byBtZW1vcnkuDQo+ID4gKwkgKg0KPiA+ICsJICogVGVzdCB0
aGUgQ1BVSUQgYml0IGRpcmVjdGx5IGJlY2F1c2UgdGhlIG1hY2hpbmUgbWlnaHQndmUgY2xlYXJl
ZA0KPiA+ICsJICogWDg2X0ZFQVRVUkVfU01FIGR1ZSB0byBjbWRsaW5lIG9wdGlvbnMuDQo+IA0K
PiBXaGVyZT8NCj4gDQo+IFRoYXQgc2FtZSBmdW5jdGlvbiBkb2VzIHRoZSBjbGVhcmluZyBsYXRl
ci4uLg0KDQpJSVVDIHRoZSBYODZfRkVBVFVSRV9TTUUgY291bGQgYmUgY2xlYXJlZCB2aWEgJ2Ns
ZWFyY3B1aWQnIGtlcm5lbCBjbWRsaW5lLg0KDQpQbGVhc2UgYWxzbyBzZWUgbXkgcmVwbHkgdG8g
VG9tLg0K

