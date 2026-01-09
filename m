Return-Path: <kvm+bounces-67639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 555D7D0C20C
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 21:00:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0687C301B753
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 20:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2E3366545;
	Fri,  9 Jan 2026 20:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KvGawusq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AFA1EE7C6;
	Fri,  9 Jan 2026 20:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767988847; cv=fail; b=i/kbvhwK3Ah7hyVFaVK03bfXfkvj8HrAFhd/eljoHKbIeZkhvD7bbvNV4Fp83Pr/R4P/NxGWzcrUIolO/9QYoc5QrKiyr3xveNsHL/+TWbUwpmjP8TWFPLX3dm40U10ZDDIySoO4kHA1THoiblVa+FndnZCRSexlSarVW9LEV2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767988847; c=relaxed/simple;
	bh=zMOKItf7TxvSSab3RgYnFvtMaGtN3n1V8j4mlL7XBoY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qMWaO1taIjM7xkZRWn0B4sao26NdvLgmMHxB5Q3lIE5pt9WyNjCMgy1z4+exvPnEV1OOBA5ju3jr5sN9GT/fz6lgieAIJsOqXoEmvigjdZnmvmZQHNQrUaICGPQYOaoIr7nVbyUTcTHAhBzpIzZKSuauFWzbPEOEBb0F/pi3QCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KvGawusq; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767988845; x=1799524845;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zMOKItf7TxvSSab3RgYnFvtMaGtN3n1V8j4mlL7XBoY=;
  b=KvGawusq9l3e33H88N8Ma02wrykof08vzn+GgHKr/UfeuIufDuqfSrww
   yRcHbLVCviJIsR3fUUHNeStzZpBzUZB+itFzmX+RZwpGEOum5KfW9QA0B
   6/qySUTJz30ofXNz96JBZJhzsxImG3wd24ONyE6lqD7rZAwkkkDI7uaGc
   hA9qap5yJpWL5n/XjAenYG6EyHqm6yxA+w8Cmv024TQYPTlz55IDafq0+
   c4kUe6onyOf5IjvPlxveBBf0gR6FdGebJQuiVz+jeb8x/11gLVE3XD/az
   zF8UD9lrGrZE32yAvJY3JWuee8kydMeVSPUDlQtegt6blodGnPjr9C3CA
   w==;
X-CSE-ConnectionGUID: rHOTyxjMS4ivUBMJrvpLYg==
X-CSE-MsgGUID: M4bIvO3GS+OVy8VVVt1F5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="94846534"
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="94846534"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 12:00:38 -0800
X-CSE-ConnectionGUID: fuaPCzDcSEaPoZF+EXgjfA==
X-CSE-MsgGUID: wJEMZ8ueQgq9hCU3haFFjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="203464033"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 12:00:38 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 12:00:38 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 9 Jan 2026 12:00:38 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.17) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 12:00:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZMzLrFrrUZGbbux8QnYJREeI/HZUtrWBm28w9LQ4M0sTpSeJRBkIeMjYci7PQOk+tWiEuAm1zgi40ivHX7qnROx6IASmZKw1sYXoR/+FmG5PHWjW61985hFkcvlEpRCAvLvebPfZs+5erdRHyANnUb3e5fqQovMjxgk/Y93D2HN2Ev/Yo5f39XEW+OHigjsHjmOBzrdcPYPEWbu25VlsuUNYL0XBVPBKEs9orDEyl9o/UlYFPKfT2Scan9Kd2Q4NQLDymczDe+1xxdw0BhaTrCB4p93bKuKDhvOwNX2j/JgpIj1XQUhI1wtP2wqXgPtp0nkl7mhsH21ueWj/etOzCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zMOKItf7TxvSSab3RgYnFvtMaGtN3n1V8j4mlL7XBoY=;
 b=sFGp2zmN0jXlOVNo9yw+UDN/GyWz2b5M/CTvXmN8Q7PvOKq5Xxg//SXaymNYRpeNmfnIl2w+ALUAuhGzHuQ37MEJk7hy1iqTf9iWSWoc9Hq8AN00NEzUbgw/vIWh39waLbaCABYQE82V8jpFwt3q9vkajfuWZ4JWT+7ckBIObstSOGcApc1TwOAkico4DB96ZPb969wTXklns2nyw19dLGBZLkF/7NeM0fcy5EdHqk415LeNacjuj49gd8EHj+kjmtXAXoGUt9AJpj4eAEQ6NZhG0MMBv11YA6cIvm1G1AbXmT/dC1bcnLaXcyt6PG1b8hqG5xSuu5pOQETuUJSlhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB4858.namprd11.prod.outlook.com (2603:10b6:806:f9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 9 Jan
 2026 20:00:35 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9499.004; Fri, 9 Jan 2026
 20:00:35 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Huang,
 Kai" <kai.huang@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 2/2] x86/virt/tdx: Print TDX module version during init
Thread-Topic: [PATCH v2 2/2] x86/virt/tdx: Print TDX module version during
 init
Thread-Index: AQHcgZw+MXCKAY83WE6WK9nKqrJZ2LVKQgIA
Date: Fri, 9 Jan 2026 20:00:35 +0000
Message-ID: <fe6e6884d28d786dacb1ff4729904b04afd8303d.camel@intel.com>
References: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
	 <20260109-tdx_print_module_version-v2-2-e10e4ca5b450@intel.com>
In-Reply-To: <20260109-tdx_print_module_version-v2-2-e10e4ca5b450@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB4858:EE_
x-ms-office365-filtering-correlation-id: ae4a057c-9c81-4f3b-a00e-08de4fb9c095
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?M2s3cVU5dXlyeDVTZERtR2ZjeEVDR1hGckpxY1lKS3hINHFCL2lHeDd1U2Fm?=
 =?utf-8?B?L1dXVzdFU283NHBHRDBBOFA1L3ZyMUh6bnErOTdKR0ZMck1EUFZDdUN4cjV3?=
 =?utf-8?B?dnEveEVISVBocjZOckhGRlhqV1I3NEo3SWRiN2JOU3RXQzlITTY1UURDRFVD?=
 =?utf-8?B?Z0pncVRLVHNqT3NGamljZzFlVHpSczFDanJZVlM0a0x1RDlEUVNTOFVsN0RD?=
 =?utf-8?B?OUxsWWVSaHFOMTZJb1VDeStYVldHS1lZZXNzWlhmTHZYRzY2eEp5R2RvQXdI?=
 =?utf-8?B?UUN3UTBVZkNaTzFjeHJEdEs4MlViMDRaVmJsa2JXRkg1Ym1FUlgwenlDNWl2?=
 =?utf-8?B?N2Z5K0dOdjhsWUp0ajFGbkk3a09yVG9kQ0l0Qzd3L2JodGlkWVJhd0x3dWV4?=
 =?utf-8?B?Z1dLVlEvRUhWWThXVDlkMzdNRDBkMENXWVM0QysxZ2EzN2pHbmo0bkt4eXpD?=
 =?utf-8?B?ZGFPSFVlMTF4VVF4KzIrREhWdDgwalh3TnRrVUNmUWZmUXBXVkNvRWJaNHBG?=
 =?utf-8?B?U0dMU1RpRDZ2blZJTDhCQWlQekpHVnhzVkhmWUJHUUo3OEt3MkZCY3o2TXlu?=
 =?utf-8?B?cDh6azJpNHlDVjhrVzNvazFEa1BNTXd0MC81NFNiYWZCVTZFVStEaWwreE4v?=
 =?utf-8?B?ZUplcHg3VzdqeWgxUDRIdE9Ed2FhRDdQQnZrQ3A5ZExOSXhiY0tMTmJoa2lR?=
 =?utf-8?B?LzB3K05RbXRuSTU1V1hlZ2pjcVRnVlJ0TzRvaG40MEtFYy9RZUtaVGJ3NmtV?=
 =?utf-8?B?bHZ6TC81dGllM01pODlFSURhV2RyWUdwZUhlN3hodkN4OGdJVHJ1WFVGQTYw?=
 =?utf-8?B?RUZzcE5GOXdSaHNyRVFCaldHbEZwLys3bHhFczdlNklXWWxhZ0cvN2pVdGJh?=
 =?utf-8?B?UkFOTG50TC9iYzVFYW1oVW5PWWVTZklEcTNNSnlCSnRuYzRRcjN3NXZHRTV0?=
 =?utf-8?B?Tml0V2FJQS9wUENFSm5sMDZoQ21qc2ZuZXZzRmpyMWl6ZXpYOHBQbXora1BY?=
 =?utf-8?B?QlZNMFhUZm9PSHJ6VmJIcHBqd0hWQ1dYZ3lOemZvMThQc2NQSHZYZnlsRHMv?=
 =?utf-8?B?alkxQXEvOHBsODVZc045akhrcFVuUFJrQldaOWtENk9zbEkxWUE3ZGpTd1o3?=
 =?utf-8?B?YW9DREhsTmUrMXlhc0F3YmlVVnc3ZW1VZzArd2tURzNJYVdSbmwzci9GdEh2?=
 =?utf-8?B?TVNVbTdXNWxNOXpURm14dFhVd1dzeDRWblh6UURHeDBDOWlxdmdleGNDaTI2?=
 =?utf-8?B?Rkl5MFlmVlhBU3JTZExhdzNqbjhzKzFZTXBUL2NiclJrck5aZHVLTjRxbGhq?=
 =?utf-8?B?UHBTOG1ORWRWMDBpNGUzNDVtWklsdGRGbHdQbHFwWnpXdjYyb2dVT0ZieUVn?=
 =?utf-8?B?a09jMnR5Z1JVZlNtTjF6TENEMzZibGlTQ2RRR1IvMEhNdHY4dXJtWTJaY3J5?=
 =?utf-8?B?SEZURGlkYVA3NkdBRjZjYUpWR2JackU4NzZpdHZCeUFrZkJ3Wk9wM1hBeXNI?=
 =?utf-8?B?SCsyR0wrNDNFaGRBRS9Zc0g4QXEwWGJGTldUVy9PeWhURnpKQmpjaWswVGI2?=
 =?utf-8?B?TUNzUmRRZEc0eStYdldvZENUWjZJZ2pXZnpwY2ZLOVF6YjNxOHI1ZWlQNFlW?=
 =?utf-8?B?aXh5T0JMNlRQU1JDNjU4TDdaVmxTaUVac0ZkU2NHV2V6TDJ4TkdGZnAzNzRX?=
 =?utf-8?B?L0RnRXAwRjNQM1dSMTlYNjVINmc1TzlDMEprTDU1c3F5SytLTHBVRUU3QTRK?=
 =?utf-8?B?bVd0aEV2VVRmQzNWQzJHYnYyNFNJdm5BL2RoMGNQbjJDSG1jd2NUN2tuVUNB?=
 =?utf-8?B?WDBuQkNnZThGREdOQTZjOVdXY2xMMTAwdWVBT1h1TzhzYXlVc3hwTkpMOE5S?=
 =?utf-8?B?RG5yWlc3em1UWWFPSkdzdWZEUVFhQ0xnNnVtSWVYZDJZMVFkQUxTVEt6VTRv?=
 =?utf-8?B?RkJLSEFLK0hRblBYMkxUUTV6dVMycXE1dUw4cFNXbDBpZGtaVXIvZ1h3U2ZF?=
 =?utf-8?B?Ukc3eXFkNWU4dUVLZTRXM3dBV3RLcTZxZ0FkWllSRmFqeS9ySUdKZzVISkw3?=
 =?utf-8?B?cGQxY044MFJnd215ZUF4QVFiMGZieGpZRHViZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eEtuT3BsQ2lhM1dsaytpa2QrcVZ3cHNJU3psK09VZnZTL0JydG0yMGtISkd3?=
 =?utf-8?B?dHByaXo3UWF1UUNzZy91a0tOaitUTTEwN1VsTERyWXNUQjc1UzF6ZmFOMGJW?=
 =?utf-8?B?UExaeE10Smdpd0hBNzlNYXY5NUVlTDVuN2hRQThCeVpFdWltRUFxK0VMREZm?=
 =?utf-8?B?eDM4a3doaU1NeS93YWYwUTh5bGJvQ1ByNDN4bzVvUDlNc291dHVKRXA2dlc0?=
 =?utf-8?B?dlFOcEhvMWVlc2w4aDhCRHBHRmpoUnNSRU5qUlR0bFpiVGR4Tzc4N0FPL0dK?=
 =?utf-8?B?aThQM1R2UG1OSnZtR3ZEczZLNEUvczhFd0I1aEtuWmpXYjlPZWMwc0dlQjBi?=
 =?utf-8?B?OGttMFhpejRYOE5najFNNDFqNXAvcE1kdXFxeFZ2MlFuaWVCRFZqRVh5bllk?=
 =?utf-8?B?TDZ0SFJWa2VSMXMwZ2s4QThVSVlyMHg0VGMyR0FHR2VKemRGOXFIRmVNU0RB?=
 =?utf-8?B?bkZnUnZUQXJoOEVZMW5IVENISnplaEtya2R3UkZ6aHdhZUFxL1k1c3IvMmsw?=
 =?utf-8?B?WHRKb0h4clpHbjcwWUMwSmR2QXF1M042Z0RNWjJTUVNDblJPT0orMW1JTHEy?=
 =?utf-8?B?ZlN4Y0tQTjMzWmF2Mm5TK1lGcDNGalpuc2lodDlaU09OR0llSjRLdXFqQWVx?=
 =?utf-8?B?U1ZJcEcyQjFnbUplUkJ4bWl6eldnTjNmcVNHUEhqR2kwUktaY09BbkRjNll4?=
 =?utf-8?B?SlpzaURKbStpSitiZjVjZVNqeEwvcnlyYllSNFVrR2lzSlNGVThEWXpITURl?=
 =?utf-8?B?bEN1UmIxRHBIMmhvdUJvVHJzbkwxTUFDYysxb3FNZ2FXbU5Ba1VHL29kWWNF?=
 =?utf-8?B?ODBtNTBzR2h5ck92VjZySGdGSlhiR2FaNS9UeHk5UTNzQ1J2a1FqZGhTWldM?=
 =?utf-8?B?Qkphb01qMWhCZ2xUb3dUbzJvd1pqcGxleWZhR3VDZlZON3JDR0x5ckJMdXRx?=
 =?utf-8?B?a3pVcVVkNlk1cFE2NUpWWCtYMXNTWjRHTE0xdTZEaTI1YUREejBMRXUxM2RK?=
 =?utf-8?B?TEFwbk1sNEVBUm9KNDdLR2txaEpKc2xqS092UmlzajIwUDVsc0pTdkdQV3VM?=
 =?utf-8?B?UFRzL2RFbUZ6MVVackRVNUJYQ3k2N05qVmtCL3cvUEwvYUloN2hYT04rMzJu?=
 =?utf-8?B?SVV2ZkNzTjc2MEZLYjBOUTlEL1J4NEtWTHV4YTFMak91czZSOTd3YVZhYjJi?=
 =?utf-8?B?azFPVzdVN0MyTnVMdkc4RUh0QkZWTDNCOHlvM0ZWbzdwN1hCbVB1ckZ1Qnhv?=
 =?utf-8?B?a2pwUG5kZVJIZ0tiRTQvaVZhV1JKSWRySXJlSWFXSmFJZ1BkOW5ZVE9nNzJ0?=
 =?utf-8?B?Qi93ZUtBMlpFWW9IbmIrYWN4RmlSWDZ4MWdJSVdraTNPWHBrVXNNaElkaU4w?=
 =?utf-8?B?amZsa0FrMGREYkxJZ01xdG53emNpVmtBekFpYWV0b28wTWFrQ2paQXU1QUpy?=
 =?utf-8?B?YzBOT2trUWlTOWc3MEt0Q1ozK2xZZ3pKVWU2U0plYy82ZllpejNRY0wzS2gw?=
 =?utf-8?B?eWVFVDIrNnkzTEdqdHAyUzFyWUFGSDZHbmYvcFNKbk8xZXJjV3A0RGhobUNy?=
 =?utf-8?B?ejZ2VnhuK25RbVhTNVl4S1ltNzk2K2hUVnJRVDgxQktta1NSMzlud2hjNHZT?=
 =?utf-8?B?S1ZXU0x1L1FhSlkxNFlPNnBiNjZTMXNzUHNhTk1tMUJQY3EvY29vU25nd0lm?=
 =?utf-8?B?L3ZTS2pVcWl3eEI0N3o2MTFoZ0xZU2F1dkl3VWxSN00zMVV0QmFaT1h4UmRD?=
 =?utf-8?B?UytRSmRadGtTemhuM0xyeGRWMDB3Z3M4c25EVWtYZkIyNVowQTJmc3hLUjVV?=
 =?utf-8?B?ZFY3TitPeEV1ZHMzSDlySVN6MTZhd25XSFlCTVJVeitrVlFTMTY5aHlLNDBR?=
 =?utf-8?B?cFgxTnE3WnRVSHd0emducXZkUXlBZW4zMCtWQnZoS3UwV05HOWV5Um9pUVVl?=
 =?utf-8?B?a0JiS3VCbnh4Yk9lNkdrZ0lhUXVPRlVadFYwQ21USDlEZXlzQ0RzczFMbWg3?=
 =?utf-8?B?KzBDWlNPZitFMDdPdG8rWE4xWks0T3d3UWwybmNZaVFKRTJnNTVnKzBzL1Jt?=
 =?utf-8?B?T2s5eTRpbDNyV0NRdk1NSStIN01udG9FdkJwekwyYmt1V0E5T1pDd2h3bkFP?=
 =?utf-8?B?N1hYR1dwTXlhYVZieEhnU0xQUlFaUFluSG1kY2lyVE43Z0VJS1NmWkRDdGtp?=
 =?utf-8?B?S0pXRnNwSVJBek5Teld3cCtNRlBTeWxkQ0NqZ20wUkdBR2l6dzk2cWhwR1dv?=
 =?utf-8?B?dm5xWWd0eVBLL1dCU3c1N3FXYkw1NlpzM0U5VjZ0NTJVbkhLVXVuTXI1YTdS?=
 =?utf-8?B?bXFqMGF1cFpJTGpjQzJmdC9rQys3c3JudStzMmNPMWtvS0FXSElFa1dXQ1k0?=
 =?utf-8?Q?pQ0jc/93BE44O44c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B426FBDC3794F94D8532F228044554D4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae4a057c-9c81-4f3b-a00e-08de4fb9c095
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2026 20:00:35.1194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: latwvzTVNfkCx9o2dw0AqIoJeqPbIBlyBLf849EK+UDljPe4AxSoOlOOJa4yGhQjZycTMR3QhlMd0cN/lc1qYhY3D0fxNuiHoTUdB1HEFI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4858
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI2LTAxLTA5IGF0IDEyOjE0IC0wNzAwLCBWaXNoYWwgVmVybWEgd3JvdGU6DQo+
IEl0IGlzIHVzZWZ1bCB0byBwcmludCB0aGUgVERYIG1vZHVsZSB2ZXJzaW9uIGluIGRtZXNnIGxv
Z3MuIFRoaXMgaXMNCj4gY3VycmVudGx5IHRoZSBvbmx5IHdheSB0byBkZXRlcm1pbmUgdGhlIG1v
ZHVsZSB2ZXJzaW9uIGZyb20gdGhlIGhvc3QuIEl0DQo+IGFsc28gY3JlYXRlcyBhIHJlY29yZCBm
b3IgYW55IGZ1dHVyZSBwcm9ibGVtcyBiZWluZyBpbnZlc3RpZ2F0ZWQuIFRoaXMNCj4gd2FzIGFs
c28gcmVxdWVzdGVkIGluIFsxXS4NCj4gDQo+IEluY2x1ZGUgdGhlIHZlcnNpb24gaW4gdGhlIGxv
ZyBtZXNzYWdlcyBkdXJpbmcgaW5pdCwgZS5nLjoNCj4gDQo+IMKgIHZpcnQvdGR4OiBURFggbW9k
dWxlIHZlcnNpb246IDEuNS4yNA0KPiDCoCB2aXJ0L3RkeDogMTAzNDIyMCBLQiBhbGxvY2F0ZWQg
Zm9yIFBBTVQNCj4gwqAgdmlydC90ZHg6IG1vZHVsZSBpbml0aWFsaXplZA0KPiANCj4gUHJpbnQg
dGhlIHZlcnNpb24gaW4gZ2V0X3RkeF9zeXNfaW5mbygpLCByaWdodCBhZnRlciB0aGUgdmVyc2lv
bg0KPiBtZXRhZGF0YSBpcyByZWFkLCB3aGljaCBtYWtlcyBpdCBhdmFpbGFibGUgZXZlbiBpZiB0
aGVyZSBhcmUgc3Vic2VxdWVudA0KPiBpbml0aWFsaXphdGlvbiBmYWlsdXJlcy4NCj4gDQo+IEJh
c2VkIG9uIGEgcGF0Y2ggYnkgS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPiBbMl0NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29t
Pg0KPiBSZXZpZXdlZC1ieTogQ2hhbyBHYW8gPGNoYW8uZ2FvQGludGVsLmNvbT4NCj4gQ2M6IENo
YW8gR2FvIDxjaGFvLmdhb0BpbnRlbC5jb20+DQo+IENjOiBSaWNrIEVkZ2Vjb21iZSA8cmljay5w
LmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo+IENjOiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5j
b20+DQo+IENjOiBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5zZW5AbGludXguaW50ZWwuY29tPg0KPiBD
YzogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+IExpbms6IGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2FsbC9DQUd0cHJIOGVYd2ktVGNIMistRm81WWRiRXdHbWdMQmg5
Z2djRHZkNk49YnNLRUpfV1FAbWFpbC5nbWFpbC5jb20vwqAjIFsxXQ0KPiBMaW5rOiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9hbGwvNmI1NTUzNzU2ZjU2YThlMzIyMmJmYzM2ZDBiZGIzZTUxOTIx
MzdiNy4xNzMxMzE4ODY4LmdpdC5rYWkuaHVhbmdAaW50ZWwuY29twqAjIFsyXQ0KPiAtLS0NCg0K
UmV2aWV3ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4N
Cg==

