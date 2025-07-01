Return-Path: <kvm+bounces-51129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 79BFFAEEB36
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 02:22:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 909241BC2494
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 00:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCECD72636;
	Tue,  1 Jul 2025 00:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MmhHB5Gh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20625288DA;
	Tue,  1 Jul 2025 00:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751329330; cv=fail; b=W4FDzKvErQEe33id3nTX4tQSklkobNm6Q/vLlpZGxIxs//9LShXFGJljYvNO67iVPfcpV1OWJx2QmmlLKgrWCb+fey5z7vIS/OARFYswneXTBv/n5bDztzinudicR7XOLQb7nFNAtPg3gVPhxClY6FrbIvY9d4xFdsDCuHa8UsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751329330; c=relaxed/simple;
	bh=2N92AWLb5pAjLBI2+AJ+gW6kDqer9UAd/2vlYGdzTxs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jRr0nOR6soDjII1WztiCjjs6/FiQsSsfwDwhKWx6nn20b+1XP9/D/tcYMpOlqRMAgcOMnPD8wzhXvdo+6GTEgztx4Zs+tnWE1UEx3Uout3r2oILb/oD9QfBE/tC6HZrGAu/dPf400Rp0f19uvXsTqsd6di+mqzANVv/VkxnflPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MmhHB5Gh; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751329328; x=1782865328;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2N92AWLb5pAjLBI2+AJ+gW6kDqer9UAd/2vlYGdzTxs=;
  b=MmhHB5GhbAzvkoj2ok8IGOrFCLXtuwnkYhJNAushSKG1cysO3tzITSOv
   varPLiCee4pJ+iXh1t+/9EBxu3me4P00ideVwk3iY/Jy0P0Y1CXLxZhK2
   QwN5tQwPftj2q5pFIJWtgRmJxpo71K/QCRlu5sPiLYtU1zxJ/w9JBXuOJ
   Pub0nv2sFqTTd7oCPcJnN9H7QEBhVYbjKyOdh+4DWWl+HGwmSRFdgilhl
   6D1bmS4TXjGyaf5AP4w84TYsjHAC/UPN+uYMRg68zHwJ2zTZ1vexO3ldF
   wAqtM6AY4gQ2A+7/68CqJ2upzaKZ2QX1ZrLh2mm7ANalNzY1sQaYBLA15
   w==;
X-CSE-ConnectionGUID: 6RES8dlrTtib9Im9TYVpZA==
X-CSE-MsgGUID: SzLmfyPZSY2QJAE0iH3AkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="53696495"
X-IronPort-AV: E=Sophos;i="6.16,278,1744095600"; 
   d="scan'208";a="53696495"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 17:22:08 -0700
X-CSE-ConnectionGUID: KF1Brc1MTCqlJykeRz6+XQ==
X-CSE-MsgGUID: FqaxNF3QQNuc4sQTPcjL3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,278,1744095600"; 
   d="scan'208";a="157875823"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 17:22:07 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 17:22:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 17:22:06 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.75)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 17:22:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B2i96W/dLoHmIPdpmD1NUjZqwg5nolzp9o/tyV5LLIyjAVVS+4wagKvNNzRQKWgAetO0TjdCxqcgCvUuO/OnaKxxXQSIZQnhq/TiKKYHe/XVtPlphTX4qyDBwOMoyFWo4KvD8DW4Qvjk6TXkwSzRfFyx1YEpnaYIxzrhqq7eUm28aF88rY3nM7/3Qox4E0ZBy6oVrOWdz4cOu+XGoQ4MTEQ7jtj0EIy5Q3lGWkJRwR3JD+Pl04RUJ6/CBdj8VZMfh2MG+V4L8t5F9lg21L+cUb6kQkiZR4UmPqTq4/7Q4cFCdP83DDN3adDFYwK6GU+RmstZG8u//v3TjZnHqbQKhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2N92AWLb5pAjLBI2+AJ+gW6kDqer9UAd/2vlYGdzTxs=;
 b=uQXtAlnVi/w6iKkpMcNeFNC3wmegKNBpETzAAu4BkQijDam+zNhWnsv0KI4KH00Fb6lPR6GQyAwjPPdlUy/5Lh5KS6p8cFAAQUFfTOsLoChlXy3mLO0y+6mLMHA3+ZBtwZe84WC1E7/Ve1otBgPpbxTVFHgn3XKLXvlTmL13dAHi1MeWoUFCsAnbT4meuNjLZWxQgI2ykdJcZ14aHAzb/Y9Q34vzHiyx82z7oQdyltt7IhVpF5Asxefw6sVa54bvaMg1kUrX4h3vR9F9n0kgaIuWB/072BEtLQnbAC2scvK4Esj9Kci0guKUXoVoPK+hxuL07qK5ddj8+OJMKYXQWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH2PR11MB8867.namprd11.prod.outlook.com (2603:10b6:610:285::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.22; Tue, 1 Jul
 2025 00:22:04 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8880.027; Tue, 1 Jul 2025
 00:22:04 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>, "Hunter,
 Adrian" <adrian.hunter@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 0/3] TDX attestation support and GHCI fixup
Thread-Topic: [PATCH v3 0/3] TDX attestation support and GHCI fixup
Thread-Index: AQHb4hHS/UsZaVpkpUG4zr37m8X+drQceDEA
Date: Tue, 1 Jul 2025 00:22:03 +0000
Message-ID: <3843262c8c33fd44f0ef65d57df90075f7734a43.camel@intel.com>
References: <20250620183308.197917-1-pbonzini@redhat.com>
In-Reply-To: <20250620183308.197917-1-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH2PR11MB8867:EE_
x-ms-office365-filtering-correlation-id: 588ee6b3-b168-492a-2e6f-08ddb8354e35
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dm5od1VzbjNyS3hWak43VHdISG0wQ0dldzY1UEVDSGJYZFAyNVphMlN3SkFs?=
 =?utf-8?B?ZjB6enk3ZkVmSWNCR2ZSZTltSmFFcllNM3VjUjRxVzRreGV1ZGUzaXZYNUdZ?=
 =?utf-8?B?VlVuUlM5bllVUEp3L0xibUF2eTkwY0ZiOUNnakFUcjlrRVdDaE1HeW90cUhN?=
 =?utf-8?B?ZjRFNGZmRDFrQzkzdGo4WUpSaGp1TFVwZCtCQ2VaeFFyY2QxRUN5MDQrTk53?=
 =?utf-8?B?d1N2ZFhmUmRHT2pUZUl0eXlPTFhRdkkvalJ3NWI0cmt3UlN1dU9va1A5WVFK?=
 =?utf-8?B?WWJUTkZCSVJ6eENiZFVkb3llTWkwSFJOOW1lOVNZNGFiS0Q0R1I2aU9QMnMr?=
 =?utf-8?B?YjVoajRJd1dNMHpzQjU4eVlLODRlUnUyM0wzK3FxVGd0ZkpDSlZNa3pORkVQ?=
 =?utf-8?B?OTRoSUFRQnJ1MFBJWnB5aVU0NkM0eHM4Q2ZmTVBRVzl0VnJVT1hHRnVVS3ly?=
 =?utf-8?B?KzkxaTIxVlF3WFEwQ0RSTTcwRHBFRHpWYnFuTzZvZ09HdEJzVFRPR0t2MUtX?=
 =?utf-8?B?UmYwZ0xGQmxMaGt3SjZJTTlvSTd5QnVFZk1qMnpJSXRTN0xZc25mQ1RmM3d1?=
 =?utf-8?B?a0l2RG1sMFpwYTQ5OGNMekpSalA2ZEpJbmk4djB5SVRrTENIeWJRTUdpZlU0?=
 =?utf-8?B?dWdHQXVlNUdUelE3ZFM3VGZ1QzByTXZybDZLYzhUejljNFNhT1dDRVNOQ3lh?=
 =?utf-8?B?NkFhWkNxSHhWQXVDT1BVWWdRU1ZwTDduMThhZmZFQi9Db0FZcCs4TFc1K1Ay?=
 =?utf-8?B?elEyUHlnbENqNWNseUFBSlJiV2twRFNySC9EMHVJYklQNlNNQ2g0cXljbXEx?=
 =?utf-8?B?Q3o2ajU4eDhIb0VYTVVYdm1yNkYrN2w1SjQxMmlqK2pJZXY2S3NwenVlUzlK?=
 =?utf-8?B?NlRWbWprZytXVUdMbTFBWVRkSnA4eW9XcUxRbVM3WEIreTlveUdSME1lTlB6?=
 =?utf-8?B?bTV4TndNcXZYdkZmcGdVSW9hU3hkcGlNSnlWdHpoMzdGTDVhVXlaZjhCWHlp?=
 =?utf-8?B?Wk1iL3NjZzg0SjZJWUhIcFpMRzRRSDlmVUQzSm9SYktHR1RTVFFvbkQ1ZUJB?=
 =?utf-8?B?Vm1FbFdpSFUwbURzU2lPUnA5TjBKTERod1Z6eStwTjQwVGxCRVNtV0ZUTzFD?=
 =?utf-8?B?bWphbGRTRmUyb2FuYTB1R3RHWmdVN2d2QTdPTFExeXRERElzYzEyaGNIWllo?=
 =?utf-8?B?Z0liZkpGOWJEWUZVeDBucVh5azV2dTFDaCtFb0RzTkxVblFxZUN6UEsvenN5?=
 =?utf-8?B?bzdwT3ZsaFh1VzI5bVY0UWFWZ09wL2JVVzh5WmVmWEY5NURkU1BMTVNweVNI?=
 =?utf-8?B?d3dmUDR1Uk1oa2lRSkoxWS81RTlnTU4wV1VKOUs0ZGxSbWREd25pNXpSSmMr?=
 =?utf-8?B?cUNTNmpxb2dzamNpeTU3OFdrUGhkU29SdDg1SVJSLzNYME9YamRuemlpcnN2?=
 =?utf-8?B?aHNJOWpNekg0c2ZtRS9GNXExcEJueUh6SW01dmNVZWxsL1E1NGZFeEdFeXg0?=
 =?utf-8?B?TG5GOVVNNmdNMXBveDc1dEpyN0ZVZFJXbFB1a0w0cTNydkNJWFoxcFNVK3hW?=
 =?utf-8?B?M0QxZzhMaHdBbHNFQ1FPSVd6b0FQOHB1clJXdUN2WEVHNTluM2NwalVkaGtH?=
 =?utf-8?B?N3BJMDRmSGROcmpTK1NEU1ZTcjdRQlJCODJtMDlGUXA0SHZYeUJqZW1IeWRo?=
 =?utf-8?B?NzlvOUZhbEtRbmZJMjdra1RjVXg2cS9HUjZGSkgxVGV2eDR5V1RLWTg1R1dv?=
 =?utf-8?B?QThEUG9xL01RWVdsYjdkd3NWenNic3NYb3pBWStqNWxDMnF6cHVUR3d3ajZa?=
 =?utf-8?B?cnhDWXVGMS9wOFpNSVI3dm5jOHowRTdQaFJVRmdGLzYwOFdkblZsUWMxMjR2?=
 =?utf-8?B?NVNsNy8xRDhCK0xSUVZjZmFmUS9ta29wZzN3V3gyMzV3OG5qZ3lmcTYzZ3pB?=
 =?utf-8?B?MXVhODFVbTRZUHl3bHJvRWZ0RTBJcU9kd1BvYXl4alpZUHVCUDh5eVR1OExS?=
 =?utf-8?Q?XRJgOWPxWXX3NauF4yvMrSZ4Hdu9vE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dW8wNmdxYlgxcndhV0NLclRibllNV0hneGFEK016TGRzZjZNeXI1ZjFJd0ZZ?=
 =?utf-8?B?dGg5dnlNNzQrdTlTbEpGUXVyd3Y4N3VIVVVSbFpLQXU1Q3VhN3FUTkE4eW9w?=
 =?utf-8?B?M2dKVVhZaEhDendOeUwwUndncEJmcVZDUFFFODJWT2Z5VTBNVE9SNDhiRzFU?=
 =?utf-8?B?d0ZCRDQ1Rk40SVljR3E3ZDlvcXorbGJ0ZXEwY0Z5OWx2S0ZvNk1sRy9sQi9w?=
 =?utf-8?B?OStxdmdwODdxL0d0emVLa2F1WUlaWHhPdm5qeWVqd2VDUmQ3MnJpQWhaaXRX?=
 =?utf-8?B?Q1c0ZlZHNldnWk1MdVpoOXJxQkwrWCtDSnE3c1hGRHRLYmNxck1HYncrajl5?=
 =?utf-8?B?d1UvSEprdnFFL2ZKVW1OWkdNekswL0tNemV3cU9ETWFjdWVGeW5JOHo1R0Q3?=
 =?utf-8?B?RDZmNThVeUo2aFhidGhHTEFsdDBqdEhjdXdKaFhWSWp3RFZvTG02bXgwUHp3?=
 =?utf-8?B?VnVIWFNib2g0ZlNaNTZ5WlhBU1ZVVnVHZGpldUs5VDFDQ041dk80NGszK2dG?=
 =?utf-8?B?TmNjQnhLMkRKRC9rTGdGNmtXUXJOMThyYmhSdnlNc1NwMEZwdWllc0NMYnYv?=
 =?utf-8?B?REpCbkJackc3RC82Q29rY2NWeG9vNHhncnc4enVzUmVxSjlPYUxKb1RkNzdm?=
 =?utf-8?B?MGpBVUtUMTYyVER0UG12cTlYUDhFbmx2dnVBS016c3pTZmRZUkhOTXVUT1My?=
 =?utf-8?B?c3BIQjUvZVI0Tm1yU1U3ZWphd2paeVZaWWJOMjRXTHNZaGlmdVZRc2l0YktP?=
 =?utf-8?B?SGJqUUpXK1plWHVtbW8xVDR0RGFtaFgzWGRYZlhYYVJOak9zU0FYT1IzaUtY?=
 =?utf-8?B?eERyYkpCZWNLcDNQTStRdlA3MVBFU3RJUXpXK0xhbVJiQWtjN2IzM1N5ZWRH?=
 =?utf-8?B?dDQvRVZrZmhjZDBEc1RuR3QrNE95ZERuWHZjOWN3U2hPQmZ2Z21mcXdTRGxY?=
 =?utf-8?B?dXRGTTV6NmJGeGdyalBoSnR3YlZobE1LZnA1TzZSVW1RbjlNbUpSQTI2Vkdw?=
 =?utf-8?B?WC9KcnR6eEVFUnlVWVM5N2xQcm95alBoVUxTMFJHRmRLV3lHV0piL2RNTXgw?=
 =?utf-8?B?Vk9aSmc1dWRreGhBWEZ5aFA2bWtMK2hPRnBMR2RzVzdwdWpVOXg1bEhTT0hQ?=
 =?utf-8?B?WmNSZWtrVnB0WlhHbTcxVWhHQkc1QllMVGdFVDlqM3pkdE8vK2ZlUXlMVVJ1?=
 =?utf-8?B?dndHK1BMaGlndG8rNEllczdmWmlxOGNKSCtHaTg0czdXS2o4VG5UVEVVREdR?=
 =?utf-8?B?TXY1OVpGM0g4M1J4bG8rYTMxSFc4MDZoejFqNkNCMG0vZmFXdThLbzBJQzho?=
 =?utf-8?B?TGczVWFLTVozb0Z0STgrM3k0bEdWcTVWeWpUN1JkclRhNlkzUVhrOVpFTjh5?=
 =?utf-8?B?TnFlVncyVzREbTl1ZkMrTXRKNHpvdkd1MHoxSEI2NnQzYlk2SVNWSElXbnBa?=
 =?utf-8?B?dlhNTVQ1Z2w2S1cwZTg3TFpBa2JUVkRGblVPeXc4dWt6ZGtTeEV0VTZVbWp1?=
 =?utf-8?B?akFSckNjRHFyMUxUbnRHbkh1TDJiQURaSno2clFOWnBOU2FaMi9GaVdpY1Rq?=
 =?utf-8?B?UXNRT0xMdFpYY0dSSm9zYmlNRXd6ckNObU9FbEplOHhFS3kydGNZTGc4ZDlL?=
 =?utf-8?B?M3JyK2NGZHV5R3dSbU91b1RseUZQL2hoUFU1TFBmbGJlbTdKTXJueFpnQWNz?=
 =?utf-8?B?MkMycW5pQjY1LzFyZnlPa1NzVXRvVkw1TFl6T2xPUW5ibDFqOVY2STdsQ2V6?=
 =?utf-8?B?RXYrV3d4UTN3ZFZQVzYwTEFlR3hDM1FkbWFqYUxWM2h1THRJcXZkQ2lEY0Fh?=
 =?utf-8?B?VTl5SUdzYVN1TlpKQ2l1RWFmV1BJSmpBYkRuV1g2NjlIbUczVXFTb3hVL091?=
 =?utf-8?B?d2wvV0l1WmNGRmRZVWxkM3o2cEQwQ2t6cDNOR0NpWTdSWDlrS2RVT2pvaW8z?=
 =?utf-8?B?VGNaUVY1dHIyR2ZqT21RRDREY2paZ3hiMExjbUFSNGI1Wi9SZVYyUFI2VmJL?=
 =?utf-8?B?YVVsTTgxTUJjNHpzMDhOTWFhcHRnS3lxaStvWVFjem5GT3gwdWIwNzc4a1c4?=
 =?utf-8?B?dUtZbGl3c21ieSt5T2hBd2hQZWVHTWJVdGgxTGNtdnBVNWZEc0JPWnlBNElR?=
 =?utf-8?B?ZVRoU3ZqMDd6c0ZnVjJWdUx0bEx3TXZYUlJtRERpdFl3amtLRVFwVVQxZWFI?=
 =?utf-8?B?MlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <58E6BCDEEBF1E64DAEF8C0A20077FCD8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 588ee6b3-b168-492a-2e6f-08ddb8354e35
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2025 00:22:04.0761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rg7dg3XF/397UaStgpK2o+Ns7CKEa5eYeSZxSOFvvW9g8OODE8KhxVK4JZJ07Y0vGJASHaDEOIuK0s3PoyS2CV490pFQgmLR9yN40Gwp4HY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB8867
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA2LTIwIGF0IDE0OjMzIC0wNDAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBob3BpbmcgZm9yIG1vcmUgbW92ZW1lbnQgb24gdGhlIHNwZWMgc2lkZS4NCg0KVGhlIHB1Ymxp
YyBURFggZG9jcyB3ZWJzaXRlIGhhcyBiZWVuIHVwZGF0ZWQgd2l0aCB0aGUgZHJhZnQgc3BlY3M6
DQpodHRwczovL3d3dy5pbnRlbC5jb20vY29udGVudC93d3cvdXMvZW4vZGV2ZWxvcGVyL3Rvb2xz
L3RydXN0LWRvbWFpbi1leHRlbnNpb25zL2RvY3VtZW50YXRpb24uaHRtbA0KDQpTZWUgIkludGVs
IFREWCBHdWVzdCBIb3N0IENvbW11bmljYXRpb24gSW50ZXJmYWNlIFNwZWNpZmljYXRpb24iIHNl
Y3Rpb24uDQo=

