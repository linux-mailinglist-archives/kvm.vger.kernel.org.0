Return-Path: <kvm+bounces-57571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E2BDB57B31
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 14:35:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2212F7A855E
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 12:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E40309EF9;
	Mon, 15 Sep 2025 12:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ap0cy41T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801BA30AD06
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 12:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757939730; cv=fail; b=FjkiqtAqEdeTEPLkCF8wXBC0LpGdi0WzM+/hQICV6NitovYCTRWcEAbONbsdy8Gq76K4ZOOkxNDXEVyCCJFp/ENheqiv2npTj+BxbQFxafes2TolkPhxKs9SNlEgC30lMMpv+rfMbaLf1YsGGMsLEGP30GXT0XA9nAbBkyBf/jM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757939730; c=relaxed/simple;
	bh=aN5B9yZb10redgrRRKiJo3aUFj0aa44lwNPXEXMVmCw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kzF+MCGQ2UkNd/y7HNqJMmiNShy91x1yc6a7TlDlCtoX2HyIspQZD8XLqPyVe9K7Zt5ygEqYrKLmURmaGUFHPSeymS3krP1RLr6fzLcM843TE7S+I/GB9f5HV5NzimQjZPvWLq2sgMrEVer1o/Wck0435DToKYiOalgyZhyuQW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ap0cy41T; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757939726; x=1789475726;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aN5B9yZb10redgrRRKiJo3aUFj0aa44lwNPXEXMVmCw=;
  b=Ap0cy41TBzUH8LqYexqkuZmnTzO+vXjFk9V/QO9QUn5mgiLZbWLHGqso
   3vfUtatX2B2T1AIOfS0HXklsJXpsvSZ5PoXkHrq6D5Q4aOThaQeXo2uTy
   32ggNROWH23+EWlbFQ6fyAB+xHv7lrEYHtuifW36U66WzJNfBf6jJLjqz
   azveHuchrHWPUOBy7JJ6Foj9GQODSOX0fMqeI/a9uvYdVYR8a3mlynbII
   VZjchrlNs8HlKJESmA/Wg4EJGRPvHD8D1v9XsR7bRmEzm3gULxQMCeOrF
   IyYcne4MAKEN1TbHK7U9xDsDNTvTaxuEoVDg4BdcV1U1u+U1Q4EnIyHlk
   g==;
X-CSE-ConnectionGUID: 5OhdmQVwRgGfUUeiZXhobA==
X-CSE-MsgGUID: x6gCoaRnS3qozjKzegW1DA==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="60295031"
X-IronPort-AV: E=Sophos;i="6.18,266,1751266800"; 
   d="scan'208";a="60295031"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 05:35:26 -0700
X-CSE-ConnectionGUID: GCxqxDN8S86RUGukqd+YIg==
X-CSE-MsgGUID: TB7lHCP8Q9Wga8bQETifpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,266,1751266800"; 
   d="scan'208";a="179879731"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 05:35:25 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 15 Sep 2025 05:35:24 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 15 Sep 2025 05:35:24 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.18) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 15 Sep 2025 05:35:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C2M2tTKcnNILXfgGUCu4QUzqfOgZb7un7AAKD0m80MZ/ZqL0xu+mRoiYtHVApn7AKwJU+u9d3YAeTWkp4QN8oxZTKmAz4atu0jyAfVP4hPGw1sQwpzOufIsigOfTNHyHpVc02gBJU0YwvNhq/0zmi43pooWJ26wUlgYzEGimBzRI5b1a36NxAmPna3o4qlO9pQ6WUA3HEF968UZN9OAVY63gcufDYUWU94NEkM7bCAQ18pzbpWutHWgyJcc1skJ2KPa5MoG1Cb3sy9bCrfmG3DdTltYCpdn1P47C/vpLdLA027+KnjaFCriDFiHNk+m9AXTpfmy4Rh/WDGuKJ15WkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aN5B9yZb10redgrRRKiJo3aUFj0aa44lwNPXEXMVmCw=;
 b=x9jrGq3ZV0QQ69b8G7O4FffbG+b4bjbauLxVoQnff/LGWuPZlc27NyE6GpTxac6bA8JKyV7aSzfb9Ta4oNWbLPCA+K9COAb3iczZunyKHAMIN4NwkWnegqrbRDW9ZKTqEu1ZvFxVdSqcN5+dVkdM3O9ukWSeGpOP/XTLhgtgdlLFOZtaPjvNTd15Jp1xCsFxOmJv4sBttve2U+tMjqQTqRrelEUHRoQU/9hD0NqlUm7yoPGyzF+HMfmuplgUD4FGAY/3FT9eIyoMkPHfjmcfvkHejc/9vwiln5eZAx0aPMWLaNETR69I4vrKi4g2ik3U6e1J1kqtq/abWnJ/z5LDZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by LV8PR11MB8582.namprd11.prod.outlook.com (2603:10b6:408:1f7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 12:35:23 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 12:35:22 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v2 4/4] KVM: SVM: Add Page modification logging support
Thread-Topic: [PATCH v2 4/4] KVM: SVM: Add Page modification logging support
Thread-Index: AQHcJh9EXHGxvGqeOkaYmP6ow2+YLrSULiWA
Date: Mon, 15 Sep 2025 12:35:22 +0000
Message-ID: <4c9e02133992661190b644d93a393f5f2d6bb32c.camel@intel.com>
References: <20250915085938.639049-1-nikunj@amd.com>
	 <20250915085938.639049-5-nikunj@amd.com>
In-Reply-To: <20250915085938.639049-5-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|LV8PR11MB8582:EE_
x-ms-office365-filtering-correlation-id: 4d58cdce-dc2d-48bb-c961-08ddf45456e9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?M2lOcm9FNHUxRWpteWZFWklOdFEzTlh5aFVpMkhtOENsQitFalNxWEtJc1No?=
 =?utf-8?B?Mi9qcGFGblJzQlFOYnVwM1VFYU9sYmhWVS9BYVh5Vk5FZ0QxZEc0RTFKeXdE?=
 =?utf-8?B?V2tQQzQ1bVJOd25Lek1FZUhZdWpnTXZaVmtZemdlTGNYejlSMnhpOFNFRzJE?=
 =?utf-8?B?Y2EwbDFKcmd5eGVGanB6OGd1cWhmdFhMMFNKQjdxODBMV2pPelRnanNseUU3?=
 =?utf-8?B?RUZzUjFyUkVYMmFTdkRkWDlTd2VQTnFXcDlSV3FCV3l4MVJuUlZxdjFGeUJa?=
 =?utf-8?B?RTYzUHpaZ3FjL0pYSU95VmJPakk4T0Z3aGN4ODdyaS9KY1NXTFluOWhGeFRL?=
 =?utf-8?B?dlY4dldoZjFYaUwvWXBUVHEyTXFaY0x5YzBoZ3EvVTJiT2Jkdk5jc3FUMlkz?=
 =?utf-8?B?VkZIMmhBRjlCSVpmRzRvMXZCYjN5VngzMEhmQ2V0K3NZQ2FXSjkrOFAvdU42?=
 =?utf-8?B?a1pMNUhYVHhXcVB2NDlBNHpMTWMvKzdOMWp0Q0lIUHY4blB2a1UwRm5KWkhu?=
 =?utf-8?B?T3NXSFRpS0pHMnFqazU3dVFNd3IwTnBzWEN3MEtHYjFUT3pBSVpZOUp0WHRW?=
 =?utf-8?B?L3ErZ3JwYTE4UnVIRUZsTUVNNS9nNXRlMThhVm1SWkpCYkY2WWd0TjMvRHBU?=
 =?utf-8?B?bnV5U0IzSjZZaEl3Z1lFeDEyT1hsZTBNVUd0N0pEeExCb09ESzRxdkFwZHY2?=
 =?utf-8?B?UTIxM0FnRDJoZlpqQUNXei9aVXdDa1Q3a2VPaHJyYlFxMWNWTXVUQlowY1dr?=
 =?utf-8?B?Z3kwOFVFaGJTMVd6dFRpMEJCeHZzWk5YTENZWTV6Yk5Obk52a0t1RldPSXFx?=
 =?utf-8?B?OWZIRmZIcVg1WW1BakV2Y3c4Q2dkOHBqcGlxYU54MitFWFdYT1gzUUNqdjl1?=
 =?utf-8?B?NG1ZQVJyOXdCQ0xZdjRuRmNXSmNvYXZxS0l5V0JFVjBkQzlEQWZBV3pHdVBH?=
 =?utf-8?B?UVh3d2I0amZxU2V5aGh4VFZWNVRKZE9MK3phRlFPRUZzb21ucUtOK05aenlB?=
 =?utf-8?B?ZHVMVGdxMjBxOE01aTV0RjJlOHdSVVg3SDNVaEFtMDhyMmJGRkkrWUFodTVX?=
 =?utf-8?B?Z0dHcWdEWm85aWwvcG0xbFZhR2ZJM0dQMHVpMlplbWRQOTBUUW0rKytvTVAx?=
 =?utf-8?B?eUhKS3g1Z3U3NGVqb3FURGMwcjJjNUs4VTZkaUhuMnVydU9hc3pXWUR5dC9M?=
 =?utf-8?B?aXRUSnJWQXc4OXBUZW9ndlZXd1M2QkZORjVzRkZucVc4dkl1ZzVDdGlzd3Z0?=
 =?utf-8?B?VS80S0Nod0s0NEQ1R0JGWGszaTRoNEJzUGx1ZXlwUkF5cExsZzBzRkZlZ2Q2?=
 =?utf-8?B?eU50ekN5NE80Tkk2NTZxb291eVZGL0hHSWE1N051WlFDcCtleGx5bFRycXgw?=
 =?utf-8?B?YW96cG1IdU92ZVBhMytBcXpJREk0N2xDUitBU2RqTU1CREhrdXo3YjIveXln?=
 =?utf-8?B?cmZ1TnVTUm1DRCthSUJCaXdBSDFEVVhvNkJvVWN0cFh4ZHM3bjFkQmkyWUgv?=
 =?utf-8?B?V29VdVNMTVdGVGRJZmtDbm9lTE5aYmZIdGRHaTZsWE83SjBKZTVMeGZNSWNm?=
 =?utf-8?B?ZkhkeUltcnlYM0prY05QMXZ0Y3BhaXB4OXp3UExIb3pjUjgwY1YyU0FXVkxs?=
 =?utf-8?B?dmpiMmdpNmVpWk9KOGNoeXFqeHFTTzVxdFNSS1dxbUVuMDVuTjl1YXl5dkNR?=
 =?utf-8?B?S05CN2haWkkvRXFDWWpBbzBMdzdFSDU0NUF1L3BVMHNPc1Q3L29hR3NxNnpW?=
 =?utf-8?B?ZFNvT3NPTDREejJrNU5NcXcrTzJLVjZTSkg3UXhaOGpHTDMwaXdpemV0YlBm?=
 =?utf-8?B?bVc3SnhrYkdJdmRZOThQc2J2cjRxc2FzRStyeEoyMVBLYkw4VlV2bzNaQ2V1?=
 =?utf-8?B?eCs3dFBtZ1RQUnNHOEpqdDdwamI2MUxoVjZyWXExbTgzVjM3dXdJcURyVXNv?=
 =?utf-8?B?ck1zcmE3Zk80dk1ka1czcVhjRjdwMjlNZ1kvSU0zWG42UHRmZDRqTElRT1Np?=
 =?utf-8?Q?sE6XNinzEN1K5yEV/se8GVfhtjOj3k=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RDhCRmxYcmR4VlN5MnNBWHNEVTZYQng1cnlTM2I0bVVWSE51UHdLbXgxVkph?=
 =?utf-8?B?UXZvREJFNjQ2cFMyUkNEbjhDNlBXZG5lWUNPTDduYkFOaytWTktmL2duY1BH?=
 =?utf-8?B?a2JwTmRLUmZGczl5NitMNmxVMnB6Yno1WE1FdGlGa005TFo0TVpkWXlLY3Nx?=
 =?utf-8?B?aWtqSmw2U3YvWTJPaDhZRDdMMzR3Rnlha2ZlcG5CMk8vV1VOTkw5UmUrMXFG?=
 =?utf-8?B?TlFTRXNhbzdVckE0TkZ0aEI1RUFVaVlqRnJRR1dPTisxWHJvcWUrRDlKSjR6?=
 =?utf-8?B?ODN3WmJMejR0aEtDZXVDMlh0VEUralB3MnRsNVVReU5hL0d4U3VGcW04eXAx?=
 =?utf-8?B?QnhEbU5PYU0vM1d1NGxpMmxEekFua2FDcjN0c0tvb3hQd2hta1N6UURiZWxk?=
 =?utf-8?B?MGNzUnRUczl1enVndGRjR3dPaVN2TTRhbGFTWm5qQjJIZFNJbExSQlpvWG1W?=
 =?utf-8?B?SGNWN0MveFo3V0dNejREdlJvL2k0clJMTnA4RDB6bXpnODNDRlVvT3Z6ajAw?=
 =?utf-8?B?NFpXdUN6WTU1bDIvVGZYREQ4Vzg2N1p0dXB5Y2UrQ1FzK2JtQXoyaFU3YTVK?=
 =?utf-8?B?Wm1Ia28yMXRhdmxMWGxpSWlTRmZlVE9ST2I5VzBxZTVIVTVqQmMzc2V4TW9a?=
 =?utf-8?B?dmRDRUZDek9yVGR6OGJGUi84aFlBWHdxZkN6QjJ4am05Zk9GZ3MzQWJSZkx3?=
 =?utf-8?B?UVNyRUNyM3drK2VBQWNHb2pidVZVd0J4WldjOGFxVEgwV1NnVmROUkJGbHNW?=
 =?utf-8?B?b2VyVU5HeXdtcVo2VDdEdENBYWZ2MCt0am1od1VmckVNeW1RN1VJYmc1WmdP?=
 =?utf-8?B?ZWo5QTMxUmF4OUFzRHYzL0Nlb0N1ZUhOd2kzMEhIVG8xb2ZtRTg3YXB0YzNI?=
 =?utf-8?B?TDU2dFFZVlpjRU1wR1BxMEltQ1JNWnA3RDd4MjNESTJuOXlKaGNxSHRiTWZ5?=
 =?utf-8?B?emM5UXYzRUhxWnRoRzc5d2FvK21tYUEwM2hyTFlaekNCUmp2V3orOXUyRklK?=
 =?utf-8?B?M1p5TU4xRExvNjNjWVMveWJtQkkwYXV4Z2t1aUkrT1d5ZFpOU25oZ2gyUjJl?=
 =?utf-8?B?ZG9sNzZIZVRJRTVzaTVDWmFaNHRpV2h6OXRtOEZLNi9VTUthU2k5d3J4aDZD?=
 =?utf-8?B?MGdDMGFwL3lNVGVxcW9jbUZVT3BCN2FTb0R3TmE3U0JWZkRwVkRKSzhDbk9U?=
 =?utf-8?B?MnQ0Wi9zWkhsazRQUmxtR096MkVpVEM1MHErSGFHMHZWNmZpQnBhQVNtZGZn?=
 =?utf-8?B?VCtFenVXekdnYUhOWVA0RzR2cER4aWRxbzdrUFR3ZTk3R0N0bmp4UWE5THVr?=
 =?utf-8?B?VTZkeUpzK0VyckYvTHRweWFWdnBKdGZwTWl4eXpqSkJaQU5iNFp3OUlaSzg4?=
 =?utf-8?B?c0l5ZjlvUytuZk9TT0M3dEk4Mjg1WGVRa1pCZ1RhTm1xWHY2QTdBSVhzeEl2?=
 =?utf-8?B?UlNRZE9RVmZCelB6T1RORjNocTUzRXd2TU03LzZMSHNROEJEem9zOUN0Skty?=
 =?utf-8?B?WUtjTHl5UWRQRTlkT2NFUDgwaTVtczNlNmh1YUtCTzVZaHhSNXRYTmM3bGty?=
 =?utf-8?B?TXpNcXVHUjdWZUM0NmlJbzljbm9sWStVZFZnVUhSZUJPM1hDd0tTMmVROFNj?=
 =?utf-8?B?L015YlFjYnRCeVI0QVRqY3FNRVBpa0VmbDVtQ1NGUXBCSHkwZklNZXA3MVdL?=
 =?utf-8?B?dFZOMGQwaGRCOE16WG0rMHdHUEtXcFAzRHVsVkN2RWpMRDZpdEx1aTJGeWVJ?=
 =?utf-8?B?S0N3WTJ3MkVacHBBd2U0bHlpSG5WMDZoQmljWTcweUx3ZTROWStLaHBCQVNv?=
 =?utf-8?B?dHhtclphZ3dOMTlyS212M0hMMFZTU3BvU1pNdlpuOG9iVEkwemhlVFprK1lX?=
 =?utf-8?B?ZS9IN3Jpd3o1OE5PZmF6MEtUUVhUVzQ3TmE2T0R0Nk5XbmhBemVra01wK2h4?=
 =?utf-8?B?Q2gvV1djNW1Ddm9GRTRwVmJqSkZNaVAvTmlCendHOEh1UFIvVjNOUTliaklD?=
 =?utf-8?B?MTJXNXV3RWJpaE81dWVBQXFoMXQweldUR0hGS28zS2VMMDk5NUI1aXhFSjl2?=
 =?utf-8?B?eVhBTDl5OXJMNE04Y1pKQWlzNnBRVUFyMS8yUVR3emM4ZS9sWHAvUk91ekU2?=
 =?utf-8?Q?Y4jM6e9xfq6Gb7uMOGxIjigzc?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C335EFA4F8BFD7409900A7946FAE1305@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d58cdce-dc2d-48bb-c961-08ddf45456e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2025 12:35:22.8785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OdZslaVBVSTYM6zGK+QZ4u8gL2U1k40uYE+nhTrWKfGQg8oYgT0s2iCIkArAba4FOl8DU2opSx/6OF6sevEj/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8582
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA5LTE1IGF0IDA4OjU5ICswMDAwLCBOaWt1bmogQSBEYWRoYW5pYSB3cm90
ZToNCj4gQ3VycmVudGx5LCBkaXJ0eSBsb2dnaW5nIHJlbGllcyBvbiB3cml0ZSBwcm90ZWN0aW5n
IGd1ZXN0IG1lbW9yeSBhbmQNCj4gbWFya2luZyBkaXJ0eSBHRk5zIGR1cmluZyBzdWJzZXF1ZW50
IHdyaXRlIGZhdWx0cy7CoA0KPiANCg0KQmV0dGVyIHRvIHBvaW50IG91dCAiT24gQU1EIHBsYXRm
b3JtcyBvbmx5Ii4NCg0KPiBUaGlzIG1ldGhvZCB3b3JrcyBidXQNCj4gaW5jdXJzIG92ZXJoZWFk
IGR1ZSB0byBhZGRpdGlvbmFsIHdyaXRlIGZhdWx0cyBmb3IgZWFjaCBkaXJ0eSBHRk4uDQo+IA0K
PiBJbXBsZW1lbnQgc3VwcG9ydCBmb3IgdGhlIFBhZ2UgTW9kaWZpY2F0aW9uIExvZ2dpbmcgKFBN
TCkgZmVhdHVyZSwgYQ0KPiBoYXJkd2FyZS1hc3Npc3RlZCBtZXRob2QgZm9yIGVmZmljaWVudCBk
aXJ0eSBsb2dnaW5nLiBQTUwgYXV0b21hdGljYWxseQ0KPiBsb2dzIGRpcnR5IEdQQVs1MToxMl0g
dG8gYSA0SyBidWZmZXIgd2hlbiB0aGUgQ1BVIHNldHMgTlBUIEQtYml0cy4gVHdvIG5ldw0KPiBW
TUNCIGZpZWxkcyBhcmUgdXRpbGl6ZWQ6IFBNTF9BRERSIGFuZCBQTUxfSU5ERVguIFRoZSBQTUxf
SU5ERVggaXMNCj4gaW5pdGlhbGl6ZWQgdG8gNTExICg4IGJ5dGVzIHBlciBHUEEgZW50cnkpLCBh
bmQgdGhlIENQVSBkZWNyZWFzZXMgdGhlDQo+IFBNTF9JTkRFWCBhZnRlciBsb2dnaW5nIGVhY2gg
R1BBLiBXaGVuIHRoZSBQTUwgYnVmZmVyIGlzIGZ1bGwsIGENCj4gVk1FWElUKFBNTF9GVUxMKSB3
aXRoIGV4aXQgY29kZSAweDQwNyBpcyBnZW5lcmF0ZWQuDQo+IA0KPiBQTUwgaXMgZW5hYmxlZCBi
eSBkZWZhdWx0IHdoZW4gc3VwcG9ydGVkIGFuZCBjYW4gYmUgZGlzYWJsZWQgdmlhIHRoZSAncG1s
Jw0KPiBtb2R1bGUgcGFyYW1ldGVyLg0KDQpUaGlzIGNoYW5nZWxvZyBtZW50aW9ucyBub3RoaW5n
IGFib3V0IGludGVyYWN0aW9uIGJldHdlZW4gUE1MIHZzIG5lc3RlZC4NCg0KT24gVk1YLCBQTUwg
aXMgZW11bGF0ZWQgZm9yIEwyIChmb3IgbmVzdGVkIEVQVCkgYnV0IGlzIG5ldmVyIGVuYWJsZWQg
aW4NCmhhcmR3YXJlIHdoZW4gQ1BVIHJ1bnMgaW4gTDIsIHNvOg0KDQoxKSBQTUwgaXMgZXhwb3Nl
ZCB0byBMMSAoZm9yIG5lc3RlZCBFUFQpLg0KMikgUE1MIG5lZWRzIHRvIGJlIHR1cm5lZCBvZmYg
d2hlbiBDUFUgcnVucyBpbiBMMiBvdGhlcndpc2UgTDIncyBHUEHCoA0KICAgY291bGQgYmUgbG9n
Z2VkLCBhbmQgdHVybmVkIG9uIGFnYWluIGFmdGVyIENQVSBsZWF2ZXMgTDIgKGFuZCByZXN0b3Jl
DQogICBQTUwgYnVmZmVyL2luZGV4IG9mIFZNQ1MwMSkuDQoNCkl0IGRvZXNuJ3Qgc2VlbSB0aGlz
IHNlcmllcyBzdXBwb3J0cyBlbXVsYXRpbmcgUE1MIGZvciBMMiAoZm9yIG5lc3RlZA0KTlBUKSwg
YmVjYXVzZSBBTUQncyBQTUwgaXMgYWxzbyBlbnVtZXJhdGVkIHZpYSBhIENQVUlEIGJpdCAod2hp
bGUgVk1YDQpkb2Vzbid0KSBhbmQgaXQncyBub3QgZXhwb3NlZCB0byBndWVzdCwgc28gd2UgZG9u
J3QgbmVlZCB0byBoYW5kbGUgbmVzdGVkDQpQTUxfRlVMTCBWTUVYSVQgZXRjLg0KDQpUaGlzIGlz
IGZpbmUgSSB0aGluaywgYW5kIHdlIGNhbiBzdXBwb3J0IHRoaXMgaW4gdGhlIGZ1dHVyZSBpZiBu
ZWVkZWQuDQoNCkJ1dCAyKSBpcyBhbHNvIG5lZWRlZCBhbnl3YXkgZm9yIEFNRCdzIFBNTCBBRkFJ
Q1QsIHJlZ2FyZGxlc3Mgb2Ygd2hldGhlcg0KMSkgaXMgc3VwcG9ydGVkIG9yIG5vdCA/DQoNCklm
IHNvLCBjb3VsZCB3ZSBhZGQgc29tZSB0ZXh0IHRvIGNsYXJpZnkgYWxsIG9mIHRoZXNlIGluIHRo
ZSBjaGFuZ2Vsb2c/DQoNCg0KWy4uLl0NCg0KPiAgDQo+ICt2b2lkIHN2bV91cGRhdGVfY3B1X2Rp
cnR5X2xvZ2dpbmcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiArew0KPiArCXN0cnVjdCB2Y3B1
X3N2bSAqc3ZtID0gdG9fc3ZtKHZjcHUpOw0KPiArDQo+ICsJaWYgKFdBUk5fT05fT05DRSghcG1s
KSkNCj4gKwkJcmV0dXJuOw0KPiArDQo+ICsJaWYgKGlzX2d1ZXN0X21vZGUodmNwdSkpDQo+ICsJ
CXJldHVybjsNCg0KVk1YIGhhcyBhIHZteC0+bmVzdGVkLnVwZGF0ZV92bWNzMDFfY3B1X2RpcnR5
X2xvZ2dpbmcgYm9vbGVhbi4gIEl0J3Mgc2V0DQpoZXJlIHRvIGluZGljYXRlIFBNTCBlbmFibGlu
ZyBpcyBub3QgdXBkYXRlZCBmb3IgTDIgaGVyZSwgYnV0IGxhdGVyIHdoZW4NCnN3aXRjaGluZyB0
byBydW4gaW4gTDEsIHRoZSBQTUwgZW5hYmxpbmcgbmVlZHMgdG8gdXBkYXRlZC4NCg0KU2hvdWxk
bid0IFNWTSBoYXZlIHNpbWlsYXIgaGFuZGxpbmc/DQoNCj4gKw0KPiArCS8qDQo+ICsJICogTm90
ZSwgbnJfbWVtc2xvdHNfZGlydHlfbG9nZ2luZyBjYW4gYmUgY2hhbmdlZCBjb25jdXJyZW50bHkg
d2l0aCB0aGlzDQo+ICsJICogY29kZSwgYnV0IGluIHRoYXQgY2FzZSBhbm90aGVyIHVwZGF0ZSBy
ZXF1ZXN0IHdpbGwgYmUgbWFkZSBhbmQgc28gdGhlDQo+ICsJICogZ3Vlc3Qgd2lsbCBuZXZlciBy
dW4gd2l0aCBhIHN0YWxlIFBNTCB2YWx1ZS4NCj4gKwkgKi8NCj4gKwlpZiAoYXRvbWljX3JlYWQo
JnZjcHUtPmt2bS0+bnJfbWVtc2xvdHNfZGlydHlfbG9nZ2luZykpDQo+ICsJCXN2bS0+dm1jYi0+
Y29udHJvbC5uZXN0ZWRfY3RsIHw9IFNWTV9ORVNURURfQ1RMX1BNTF9FTkFCTEU7DQo+ICsJZWxz
ZQ0KPiArCQlzdm0tPnZtY2ItPmNvbnRyb2wubmVzdGVkX2N0bCAmPSB+U1ZNX05FU1RFRF9DVExf
UE1MX0VOQUJMRTsNCj4gK30NCj4gKw0KPiANClsuLi5dDQoNCj4gLS0tIGEvYXJjaC94ODYva3Zt
L3N2bS9zdm0uaA0KPiArKysgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5oDQo+IEBAIC0zMzUsNiAr
MzM1LDggQEAgc3RydWN0IHZjcHVfc3ZtIHsNCj4gIA0KPiAgCS8qIEd1ZXN0IEdJRiB2YWx1ZSwg
dXNlZCB3aGVuIHZHSUYgaXMgbm90IGVuYWJsZWQgKi8NCj4gIAlib29sIGd1ZXN0X2dpZjsNCj4g
Kw0KPiArCXN0cnVjdCBwYWdlICpwbWxfcGFnZTsNCj4gIH07DQoNClRoaXMgc2VlbXMgdG8gYmUg
YSBsZWZ0b3Zlci4NCg==

