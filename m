Return-Path: <kvm+bounces-39103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3DC9A43C3E
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 11:51:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE21516BC12
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 10:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 589142676F1;
	Tue, 25 Feb 2025 10:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Po57wcKx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E120254858;
	Tue, 25 Feb 2025 10:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740480649; cv=fail; b=eH+BoKzp9RxUB5mYc9WvZ+SethBr06RiRjRYi7gvIsHx9w4sqQ0uv50oPtYvOeyEaR0rh9ikCHLp77pN804kah6n8izQTMunCblCtyYBtQHcHoks6aHg6/CWRkMTAuRPtG1njYT2rboUVrKdTKtxVX27dfEIqFak0Iu0pVUDXHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740480649; c=relaxed/simple;
	bh=A0sIRk1Qc2CD1q66e0taB9inC0IVyp+5qA++GXIWec4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YTnwHStLqRok5JinTrR+JpC82h9XcEehVmeaLk+ZLCCNU0Sh40oYtG/dcnaDDBObMI3B0g2IJqeGsbjnClQ1wfp3mPGmnXky8EMKi5c4lvA7ODSyEnUaYlBgHSN0DP7zU9ozrQPL/UuHbcoxSL60vR4Z7h78Y8MtfsfS5fsf14M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Po57wcKx; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740480647; x=1772016647;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=A0sIRk1Qc2CD1q66e0taB9inC0IVyp+5qA++GXIWec4=;
  b=Po57wcKxBwU4iDfZq8BqtMCGLHwA/00m4w+4NB8LTTz130PvjLdpphgG
   dV7ofdJa9QDY6pI291cNQ4NPOkLJSxtkP1G31ZpYQS10s0dhwX/l5nWFo
   DdUqMvqVevToAk4/5UrE1k4Zpcex49hWaWmZuKPKeoXCtsRW68rTCGzLU
   CspMl59iI2Q7lLXvpJTgkzHTS3ra8NFb3KEzi5L8Z6Rdj2UNSPZCAPUvQ
   scc0pY+7ZvbP+ThsULbgHJ6OiR+NaTB4/bC0Z7bX0BGRG701cLOOmwPFS
   n8anUjf504j0pheqB+ySjuyvmVcXQ4fIAlKsgumMRQY1VoPQTrLk05YyB
   g==;
X-CSE-ConnectionGUID: 5GXYQOJHTO+71wtZzocl+Q==
X-CSE-MsgGUID: wwSy4GaaTbK6idUis+wwGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="41482389"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="41482389"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 02:50:46 -0800
X-CSE-ConnectionGUID: LtQaxkTaSgSJ/g0Gz0COXA==
X-CSE-MsgGUID: jckV5blXReqlHflaL49hJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,314,1732608000"; 
   d="scan'208";a="147178528"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 02:50:47 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 25 Feb 2025 02:50:45 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 25 Feb 2025 02:50:45 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 25 Feb 2025 02:50:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y9C9xIW1K5C+dzX/0aKZz2IgmcPAuDTeM9w//U2p8YeU/aoM3HXRJ9Z3U7rFVrtX9/Foub1fuYVOL4Peojew3PzxPmAaDjducJAwFVjSkSyPkBhoGkxVydWQfvSoLc2jkJqH8Lcb56eH95LBqWOVp/GqjJnF1UjUWWyRDXeuygh6bVCZHB0qYpyun1K/CpEB0QRVEDFD3Ybs97CC/FmEC8MpfuyxGEpwZYvhpn98ML0fPyIZXHRUXXHKpkmZeI+90BC2e/+SyTCOWH5qUd1pKijLbYYNR/QP8EJksWYga4baK9EwItG4EdC2BTucP4DhfIBrwlI0Mj5iB4Be4uansg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0sIRk1Qc2CD1q66e0taB9inC0IVyp+5qA++GXIWec4=;
 b=bgfD/jLvs7i7Sm50yyKjGodxWhoOY+F8bRQJ9vrjC6DniTKgavnS97BrrseMgsNSAemgD7fUDMbhoPFCZfQZt1cLt8fZq6xph5nBgEaAwvsoMd2JbNGdNwXQnM40hd5N9Qu6iezp9quF2Zmh+Fz7k7T1zGFRD8PPgytrAGCs3hT+pLCwEgelxJWzbS+KtcD1QrXXsWsn6hbs2vup1hIdXtT761a06Erk/p7/hYHhPRNXGHXRJ+bldul+R66IGvoOUVhFe42KZsygX4Nw0YqI7XIqqwionba/YOMbrs0ZDXjHSvv7DioTDu3gDd8h0NZ4Ddm6ujW5ZzoTo3SMqHvH+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB5916.namprd11.prod.outlook.com (2603:10b6:510:13d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Tue, 25 Feb
 2025 10:50:43 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 10:50:43 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 18/30] KVM: TDX: Add place holder for TDX VM specific
 mem_enc_op ioctl
Thread-Topic: [PATCH 18/30] KVM: TDX: Add place holder for TDX VM specific
 mem_enc_op ioctl
Thread-Index: AQHbg7rnfrPDgR9JzkiWOeU1FO+JQrNX3sIA
Date: Tue, 25 Feb 2025 10:50:43 +0000
Message-ID: <5fef771544197940b9173b2b3bee34bea8f9d13f.camel@intel.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
	 <20250220170604.2279312-19-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-19-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB5916:EE_
x-ms-office365-filtering-correlation-id: 5c1ebe49-ebac-4833-f647-08dd558a4076
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?LzV4Y2dGVUJwcFYwZ1FiYXh0MnBKQ0tjVnNoTElLNEd4NEFERzZqdDc0MHZX?=
 =?utf-8?B?ckE3R29zVVNqS2JoSUFxZzhwQ3VYZmExVFViL1gwM1RLYk9peVp6cm9MSlNG?=
 =?utf-8?B?Q3ppTUlXcGk2M0NvOVdodXFOb216WktFcGhWbVYvTzczNS9Dem9JOWl0N20r?=
 =?utf-8?B?MlRnT3RVTC83VDlnZ05PTlJVZHZIVjlKRDlsL3B0clF5aXZra2hoRGVLb2JY?=
 =?utf-8?B?NkxWMk51Y2JkNDZSK1lRd2NQWmxVWlZ6aVEzblpzd1RDRkZGdS92Mjhqdit1?=
 =?utf-8?B?QlVIcEJMSkJaV0ZrUHJmUzBqSHUyZFBXNTRGc0RneG51ZnZZeFp2VHFWSEt2?=
 =?utf-8?B?OE4xM0g5V2ZpZEhVb0lsUSttcmVHNUp2NVJPaHZZWXJUWTQ4V2FGTVJDMThq?=
 =?utf-8?B?Yk1oV3NGY1ZyZEE2REJLbEcyQVlzTVlGM1hVRkdUZWJmdVdPeVNaSlpCVEZG?=
 =?utf-8?B?S1VXZUZxMnEvd1F6S2tXOFNxVVFGMHljRExlQk91djlDQytWVUozSlNNamRt?=
 =?utf-8?B?Tm5oRUtjVDVzeC81aHJBMDliVzlRSER2RGdMaG0xeWFSSDgvVXdqMUJ4WFFS?=
 =?utf-8?B?VVp6M1k1TGlFeVo5aWpLNzllZlBUdHZjN0ZSczVacU9CSVk2L0pHRmZacjlZ?=
 =?utf-8?B?ZDA4YU5SQWFXK1RNaDZrbXI2WU8vU3VHK3ljeElhb0NySEN0L1lJUlhhSEVQ?=
 =?utf-8?B?YnlQRU1qd3l2RkEvUjVoMVE3UXp1Y29OaDhSbGdjM1QvbXRHWlcwZ0l6S0M5?=
 =?utf-8?B?eU9TSHQyK0xzbUZxYWxCblJXSFVSdVVKYWxCY0E0a1pjdWxzVUJnbGwyeXdN?=
 =?utf-8?B?VS9LaTd0SGRVd0tvNDRMd3ZiYzYwSEJzSmNrMUdYQVh2OVZRZlRzcllqN3NQ?=
 =?utf-8?B?ZzIyMmJnZ01sZnZRRmFLTytDMklwZENMb25pZTBscE9YbENLbUZOd2NsbU9W?=
 =?utf-8?B?WDdMR1ljb0FkTWNNQVlTRzlxNjNSVW1VTG9uNlpXbmRPZVlIUU9sSjZ6bTlZ?=
 =?utf-8?B?UmVabjNsY2dWK2NjQm5wTmluSGZ1TGZ6enErQzJXL3lKRi9IZm15RW9CNGxL?=
 =?utf-8?B?dHVrZ1RGNldxUGNEQ0ptNHd2Q0xMY2hEdFBxR2o5K1NFTG03dDUyNXR0WHVa?=
 =?utf-8?B?RloxU0UyNkRKS1I1MXBORXUvNzBUMG0vZHlOaU5WSmtHakpyUER2d1pzOHp4?=
 =?utf-8?B?bVRrK2Z0UDMraEdqTDM3N1JtUGRWNG9rZ0lDN0RiR2RrbGtMcUVoOEFqc2tW?=
 =?utf-8?B?dm1wWmlvZ2ltcWlPa0lhR0dxYkRlMDdZTkJQQTN0bkFGdDNySUN3YUEreDI0?=
 =?utf-8?B?ckl0d3Y5Ujlyelptb211dll0dXdQVzJoc0V2SnlUQUpNMVlITFl1akFjeFpZ?=
 =?utf-8?B?eDNoTGxSaVVvQnlNVmtaSDlCZmZIVFM5Y3dEbWFab2NRdE1oRnd0YjBFUDJK?=
 =?utf-8?B?dUUxbW5mbGlRZVBJdXE3NWlDQ3psQ29yOHVFWlNaU013OHBIeGhTZXo5Mnc3?=
 =?utf-8?B?em1sTTdzaFNnN2RmVy9nVmsrM3Fqdi9ISGxzRXAyWDR6Z0ZHcEwwUDVXdWJ6?=
 =?utf-8?B?THlMd1liQ3MyUjhxTnhPQWJ4UFVjTjg2b2NaOTFndEZSS2pzNzBkQksvU3Z2?=
 =?utf-8?B?eDBqQWJCZlZOb1RVTm1FcWN0am5pdDFxZGhrV01PUEs4SnlsSmw4UCsvQm9o?=
 =?utf-8?B?ZXo0V2VNZXFtOVF4YWFnYkNLRisyL1YrRXJsb2lFMkgrSGZaTkc3SkVBbTdk?=
 =?utf-8?B?WklOUzBSNEdJMXhhZlJnbmd4SXBIS1Exd1ZjTDRNVjk5LzFTbEZqdmE4dE5O?=
 =?utf-8?B?K1FUaWZKdXBJVU5vcHdmNGJGUWR0NEtNdGlpTnoyY2tROWtXdlYzcnVocXR2?=
 =?utf-8?B?YWlGeVNMUU9Ud2VLTlZoelJybHRlMURzTEV0c0xwOTl3Qi9UREpIS28wYXg3?=
 =?utf-8?Q?Fas+IvUs/E96cBNYCRmuqU6utL0RtBVI?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ui9WZWIzY1BEQTdqdit6RkV3UllLR1ZUeGNwLzkwSUl1S1VSZEZHMXNjSmxm?=
 =?utf-8?B?dkRUditvOWRkeGEzdlhuNEhHOGE3UnJmOEp1TTk3L0d0ak52QmFDVFlkZ3Av?=
 =?utf-8?B?a24vUGtGanFlbitUNHlJajZuMW50eE1QUm5VNmQ3UFFoTmdNSXJmZlp2Uzht?=
 =?utf-8?B?dTJVcUp6Tk5EQ0JsQVVGMmE5SXczWURpVFl0dWdSL21UazFycklKNUx3ell4?=
 =?utf-8?B?ZEJ4V3RreFZmRUZ2eVpsQjlCS1JpeFpaL2JXaUR5aFN3b3ZJclVrN3h6bXZX?=
 =?utf-8?B?bHhDOVZVUDlSOThEbDQ5aXhpZm1EMTBQTytiSnV1b1pCMS9LU1BYRUNRVjh6?=
 =?utf-8?B?WktPWjRuUHVPMDJFa2lYa2FuWXo3dCt1TDhHZ1VrbVFVSjdnMUg2eHNFeEhv?=
 =?utf-8?B?T0hLZEFwanorUFVXSnM1RDVyNDAxRXJMMGlQaG5udVNIeXZoWTFBOEMrWnJu?=
 =?utf-8?B?U3pVZ0p2ZUNnekx6ajVkSFdHYlk4MFh2WG42ZUNCTm1XUlhCYlJmMFVRMDVx?=
 =?utf-8?B?SlpsOGRTcjFlVTZuck9qN2F3MjdTQnhPR3NjaVZsOWtQa1NMWjIyWWtlWTYv?=
 =?utf-8?B?cUFGbmdQcmJQb1RscC9HRC84NUY3N3dReWh5Ti82ajNNVTVNSjNnekNhTkx5?=
 =?utf-8?B?c3h1Zzg1NU0wV2k0ZU1hMzZYa0RwUTF0YVoraTFpa0JpWWRwTmh0RUdEcjN1?=
 =?utf-8?B?NGMwUEtJMkNqeEJpUFF4Vmh4Q0ladCtuNkNuNTVNMW1PcjUwVlNmSG1Zbkta?=
 =?utf-8?B?MS9tT3ByR3FTZUgzWmdneEQzeUszaGcrZWwvWEppUnpYSDI4VGY4Zjlrd0w1?=
 =?utf-8?B?UjYxZnV6ZEdnY2wxL1psRjFLNWZPbVkrMDZmL0Y1V2pqd2cxK1JJZTYrbFBP?=
 =?utf-8?B?NmxsTE9uWGVyRWNIOFdaSjhEMzlXTWI1QjRLcUc3T3VBaHdRWUk0eUkxc3Ev?=
 =?utf-8?B?SEg3M2JpU2czYWp2c0hoYlBIblczaklSOFV3RFlLaFZzVzEzcDM3dThLNlM1?=
 =?utf-8?B?NzR2cUNmbmZqZTYrNDRGSUh0Q0JxaEE4b2xncG9CU2V3OFNYTjJxYXpibW5x?=
 =?utf-8?B?MkoydWhtb3pnWitVbjc1Z1hDUFIzQkM4YXIrWlp6bUhuRk9LM1JSVWsvRXlO?=
 =?utf-8?B?aGlCSkZJNWtpdmwyeUs4bjd5WjNEcS9EalpiNDZoK1hQcUJNQW5WdVBic2wz?=
 =?utf-8?B?YzhjdjdUZ3AxZWk4MXF3bkpyTjJGTXg4cm8yU2JoWmlDVFI3aUt1eG5VSFVM?=
 =?utf-8?B?ckdYTUdjOXRFM3NYbmJFK2p5dDltY0lwb3dDZFl2ZUxjRGtPK0ZBemc0YXJU?=
 =?utf-8?B?SmlGUlFCV2lxcWYvdFg0ZUNFb1ZySDgyeFdZZXRCNVg1c0VIVVVFdUVQV09y?=
 =?utf-8?B?a1B1cjBaakZYWXVmRWJqK284eVd1R1RkekVwSWM5b01MMlRxUy9wdWZLT0wx?=
 =?utf-8?B?MFNjbkkvQkI4ZGVzUlloc0h5UGZvUlNVL3VIL1hBdGlKb2pZY2t3U3pzcW1v?=
 =?utf-8?B?Mm1scmg3elVzMzRXUVR1WXJPc0hORDRseERFS3ZtVXU2clcwZXdXMVpGeFhj?=
 =?utf-8?B?cnlLV0JRMG1xMTFoVnZTclFDdjFIQXN0VERoZXcvVXU4ZVR1cEJHb3U0NWdN?=
 =?utf-8?B?ZC95ckZ0T0syK1Y3dFR4WmN2TmRIckZOSDhYcDMvUTlTQVZrR2xTdkFGTktk?=
 =?utf-8?B?VVorTjJpU2NVVWZ6RG5BM0dRZTNsQ2tqUW14S3A3VWFLN01waHhYN1h6S29j?=
 =?utf-8?B?VHIvZ3YzUnhTdkNQb1J5VUtWOEZCclJVWlV4QjNYOFFFakNNU21zRm9IcVpG?=
 =?utf-8?B?Q3NuSnl6MXpzUEFnaE81TGR3cHdWSDBtYlRZbWQxUGgvdWVGZC9XMXhpdFZ0?=
 =?utf-8?B?MFpTS3l1ZkpHT2hsM2JIb1dvMUE5THBMRUpTRVVWaTRURS9wVGp2VDJBUHBp?=
 =?utf-8?B?VzN3VGlDcWtSVUg1bkZFR245YWswcHpOcU8rR2FQd1Jvb0Qwb3FFcnZHaUk3?=
 =?utf-8?B?SDlwbitWbExNS1RGMmJWWURsYm1ZejIwQ0craUtHUGU2TFJDVTlTUHRQWFQ0?=
 =?utf-8?B?d1VrOHBZa0hhV2kyUWt3bkZMdGZCeFdId2NoQ2lLUnQwNzdmMUV1MU53WlQx?=
 =?utf-8?Q?antTkKD5KTrDLXuG0/eAhrcjS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7EE0D320EE8EF46BF7D0958AF75D3C9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c1ebe49-ebac-4833-f647-08dd558a4076
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2025 10:50:43.1648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vZhaQXFx3LXh0WxhaSVUrm9XAF9diQCrFsp6wImuU4mOOQVKVPlQUnjK1kunZFQQ4ARxWP1TaNJFF+2qd+Bg0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5916
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTAyLTIwIGF0IDEyOjA1IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBGcm9tOiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiANCj4g
S1ZNX01FTU9SWV9FTkNSWVBUX09QIHdhcyBpbnRyb2R1Y2VkIGZvciBWTS1zY29wZWQgb3BlcmF0
aW9ucyBzcGVjaWZpYyBmb3INCj4gZ3Vlc3Qgc3RhdGUtcHJvdGVjdGVkIFZNLiAgSXQgZGVmaW5l
ZCBzdWJjb21tYW5kcyBmb3IgdGVjaG5vbG9neS1zcGVjaWZpYw0KPiBvcGVyYXRpb25zIHVuZGVy
IEtWTV9NRU1PUllfRU5DUllQVF9PUC4gIERlc3BpdGUgaXRzIG5hbWUsIHRoZSBzdWJjb21tYW5k
cw0KPiBhcmUgbm90IGxpbWl0ZWQgdG8gbWVtb3J5IGVuY3J5cHRpb24sIGJ1dCB2YXJpb3VzIHRl
Y2hub2xvZ3ktc3BlY2lmaWMNCj4gb3BlcmF0aW9ucyBhcmUgZGVmaW5lZC4gIEl0J3MgbmF0dXJh
bCB0byByZXB1cnBvc2UgS1ZNX01FTU9SWV9FTkNSWVBUX09QDQo+IGZvciBURFggc3BlY2lmaWMg
b3BlcmF0aW9ucyBhbmQgZGVmaW5lIHN1YmNvbW1hbmRzLg0KPiANCj4gQWRkIGEgcGxhY2UgaG9s
ZGVyIGZ1bmN0aW9uIGZvciBURFggc3BlY2lmaWMgVk0tc2NvcGVkIGlvY3RsIGFzIG1lbV9lbmNf
b3AuDQo+IFREWCBzcGVjaWZpYyBzdWItY29tbWFuZHMgd2lsbCBiZSBhZGRlZCB0byByZXRyaWV2
ZS9wYXNzIFREWCBzcGVjaWZpYw0KPiBwYXJhbWV0ZXJzLiAgTWFrZSBtZW1fZW5jX2lvY3RsIG5v
bi1vcHRpb25hbCBhcyBpdCdzIGFsd2F5cyBmaWxsZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBJ
c2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiBDby1kZXZlbG9wZWQt
Ynk6IFRvbnkgTGluZGdyZW4gPHRvbnkubGluZGdyZW5AbGludXguaW50ZWwuY29tPg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBUb255IExpbmRncmVuIDx0b255LmxpbmRncmVuQGxpbnV4LmludGVsLmNvbT4N
Cj4gU2lnbmVkLW9mZi1ieTogUmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwu
Y29tPg0KPiAtLS0NCj4gIC0gRHJvcCB0aGUgbWlzbGVhZGluZyAiZGVmaW5lZCBmb3IgY29uc2lz
dGVuY3kiIGxpbmUuIEl0J3MgYSBjb3B5LXBhc3RlDQo+ICAgIGVycm9yIGludHJvZHVjZWQgaW4g
dGhlIGVhcmxpZXIgcGF0Y2hlcy4gRWFybGllciB0aGVyZSB3YXMgcGFkZGluZyBhdA0KPiAgICB0
aGUgZW5kIHRvIG1hdGNoIHN0cnVjdCBrdm1fc2V2X2NtZCBzaXplLiAoVG9ueSkNCj4gU2lnbmVk
LW9mZi1ieTogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gLS0tDQo+ICBh
cmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm0teDg2LW9wcy5oIHwgIDIgKy0NCj4gIGFyY2gveDg2L2lu
Y2x1ZGUvdWFwaS9hc20va3ZtLmggICAgfCAyMyArKysrKysrKysrKysrKysrKysrKysNCj4gIGFy
Y2gveDg2L2t2bS92bXgvbWFpbi5jICAgICAgICAgICAgfCAxMCArKysrKysrKysrDQo+ICBhcmNo
L3g4Ni9rdm0vdm14L3RkeC5jICAgICAgICAgICAgIHwgMzIgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3g4Nl9vcHMuaCAgICAgICAgIHwgIDYgKysr
KysrDQo+ICBhcmNoL3g4Ni9rdm0veDg2LmMgICAgICAgICAgICAgICAgIHwgIDQgLS0tLQ0KPiAg
NiBmaWxlcyBjaGFuZ2VkLCA3MiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bS14ODYtb3BzLmggYi9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS9rdm0teDg2LW9wcy5oDQo+IGluZGV4IDgyM2MwNDM0YmJhZC4uMWVjYTA0
MDg3Y2Y0IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm0teDg2LW9wcy5o
DQo+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bS14ODYtb3BzLmgNCj4gQEAgLTEyNSw3
ICsxMjUsNyBAQCBLVk1fWDg2X09QKGxlYXZlX3NtbSkNCj4gIEtWTV9YODZfT1AoZW5hYmxlX3Nt
aV93aW5kb3cpDQo+ICAjZW5kaWYNCj4gIEtWTV9YODZfT1BfT1BUSU9OQUwoZGV2X2dldF9hdHRy
KQ0KPiAtS1ZNX1g4Nl9PUF9PUFRJT05BTChtZW1fZW5jX2lvY3RsKQ0KPiArS1ZNX1g4Nl9PUCht
ZW1fZW5jX2lvY3RsKQ0KPiAgS1ZNX1g4Nl9PUF9PUFRJT05BTChtZW1fZW5jX3JlZ2lzdGVyX3Jl
Z2lvbikNCj4gIEtWTV9YODZfT1BfT1BUSU9OQUwobWVtX2VuY191bnJlZ2lzdGVyX3JlZ2lvbikN
Cj4gIEtWTV9YODZfT1BfT1BUSU9OQUwodm1fY29weV9lbmNfY29udGV4dF9mcm9tKQ0KPiBkaWZm
IC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS91YXBpL2FzbS9rdm0uaCBiL2FyY2gveDg2L2luY2x1
ZGUvdWFwaS9hc20va3ZtLmgNCj4gaW5kZXggOWU3NWRhOTdiY2UwLi4yYjAzMTdiNDdlNDcgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgNCj4gKysrIGIvYXJj
aC94ODYvaW5jbHVkZS91YXBpL2FzbS9rdm0uaA0KPiBAQCAtOTI3LDQgKzkyNywyNyBAQCBzdHJ1
Y3Qga3ZtX2h5cGVydl9ldmVudGZkIHsNCj4gICNkZWZpbmUgS1ZNX1g4Nl9TTlBfVk0JCTQNCj4g
ICNkZWZpbmUgS1ZNX1g4Nl9URFhfVk0JCTUNCj4gIA0KPiArLyogVHJ1c3QgRG9tYWluIGVYdGVu
c2lvbiBzdWItaW9jdGwoKSBjb21tYW5kcy4gKi8NCg0KKGNhbWUgZnJvbSByZXZpZXdpbmcgdGhl
IEtWTSBURFggZG9jdW1lbnRhdGlvbiBwYXRjaCkNCg0KTml0cGlja2luZ3M6DQoNCmVYdGVuc2lv
biAtPiBFeHRlbnNpb25zLCBzaW5jZSB0aGUgbGF0dGVyIGlzIHVzZWQgd2lkZWx5IGluIG90aGVy
IHBsYWNlcyAoYW5kDQphbHJlYWR5IHVzZWQgaW4gdGhlIHVwc3RyZWFtIGtlcm5lbCkuDQoNCidz
dWItY29tbWFuZChzKScgaXMgdXNlZCBpbiB0aGUgY2hhbmdlbG9nLCBhbmQgaW4gYmVsb3cgYXMg
d2VsbC4gIEZvcg0KY29uc2lzdGVuY3kgSSB0aGluayB3ZSBjYW4gY2hhbmdlICdzdWItaW9jdGwo
KSBjb21tYW5kcycgdG8gJ3N1Yi1jb21tYW5kcycuDQoNCj4gK2VudW0ga3ZtX3RkeF9jbWRfaWQg
ew0KPiArCUtWTV9URFhfQ01EX05SX01BWCwNCj4gK307DQo+ICsNCj4gK3N0cnVjdCBrdm1fdGR4
X2NtZCB7DQo+ICsJLyogZW51bSBrdm1fdGR4X2NtZF9pZCAqLw0KPiArCV9fdTMyIGlkOw0KPiAr
CS8qIGZsYWdzIGZvciBzdWItY29tbWVuZC4gSWYgc3ViLWNvbW1hbmQgZG9lc24ndCB1c2UgdGhp
cywgc2V0IHplcm8uICovDQoJCSAgICAgXg0KCQkgICAgIHN1Yi1jb21tYW5kLg0KDQo+ICsJX191
MzIgZmxhZ3M7DQo+ICsJLyoNCj4gKwkgKiBkYXRhIGZvciBlYWNoIHN1Yi1jb21tYW5kLiBBbiBp
bW1lZGlhdGUgb3IgYSBwb2ludGVyIHRvIHRoZSBhY3R1YWwNCj4gKwkgKiBkYXRhIGluIHByb2Nl
c3MgdmlydHVhbCBhZGRyZXNzLiAgSWYgc3ViLWNvbW1hbmQgZG9lc24ndCB1c2UgaXQsDQo+ICsJ
ICogc2V0IHplcm8uDQo+ICsJICovDQo+ICsJX191NjQgZGF0YTsNCj4gKwkvKg0KPiArCSAqIEF1
eGlsaWFyeSBlcnJvciBjb2RlLiAgVGhlIHN1Yi1jb21tYW5kIG1heSByZXR1cm4gVERYIFNFQU1D
QUxMDQo+ICsJICogc3RhdHVzIGNvZGUgaW4gYWRkaXRpb24gdG8gLUV4eHguDQo+ICsJICovDQo+
ICsJX191NjQgaHdfZXJyb3I7DQo+ICt9Ow0KDQo=

