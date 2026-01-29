Return-Path: <kvm+bounces-69632-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aArXODDde2kdJAIAu9opvQ
	(envelope-from <kvm+bounces-69632-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:20:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id ACDC9B53E6
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:20:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E199330078B0
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79AC836AB4F;
	Thu, 29 Jan 2026 22:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RqbqNavm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA0A361DDF;
	Thu, 29 Jan 2026 22:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769725226; cv=fail; b=qvU7cdVRYGGY3vCMYLIjJdUbtq4zTN0Gcjp2eRh6pBFrVY4KQO7e/3ywXrWY4VApmIjlJVPisg0NKwB6c2kQQH/e+mMkmFgs3ep/63avcYrpYsouAA+1pVr1WdF9ZOArl9ED1ICweN3pZmWAXHpFDP7F76sUF4erUJOszlpydnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769725226; c=relaxed/simple;
	bh=iJHrc3EVUFTsWfjZI2eJYPYDVCosebp/Rv2wpIYC+JM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PcRsoCNTbX9WQiZVfqA+WLzyQa46M2g1Q0A/QRry5SmBkIErm9yx9SaOXtwITxs9XZSXazKyWwo0Rw/c/vAOSFr7304/QOBAACL/4iXioSJAM7To5AX5cGgbY9SW1If0Ma9sJ34RzIlLSRNE9ThUzRacgeR8+xsAd68gijLSxS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RqbqNavm; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769725225; x=1801261225;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iJHrc3EVUFTsWfjZI2eJYPYDVCosebp/Rv2wpIYC+JM=;
  b=RqbqNavmz52f1kvgjqsiUhYyTHh2L3AOwaCxUHMz1lvpXG3A73kDUh1U
   kQwuUdDhO3gog55xftHQCV5FPrMq41M3lSnZsdJ1fxAtrDWTGYtQpWpQL
   DRZ99WeuzeWwoKl9QYhebTodY901GV91msO+tq3THOoaeOYp849W0fWVv
   OIfj8ljBfxuX0O9mEd4pEcDyxd4XMeJ70ETrHksFdfpvYvkQoDSnqLIlD
   BbH9GjKv5NCC+64W3I2Be/L29oRjYofbJwFLWizGhZXo00ivqiwXciGHP
   QadKyQRhw2NS1MRtnMCb2tHaN4X/BpQ+lJ2yIjmXtbzwlChhcgwHCJ343
   Q==;
X-CSE-ConnectionGUID: tbgxvg68Tz2nFvlwJwATyw==
X-CSE-MsgGUID: aXqH9P8VQsiLyR6kEPzrvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="70873818"
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="70873818"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 14:20:25 -0800
X-CSE-ConnectionGUID: cBvo104GTqOEmADi0E5p4A==
X-CSE-MsgGUID: YRrqtyiQST+YmUDaLm7Kgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="208297317"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 14:20:24 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 14:20:23 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 29 Jan 2026 14:20:23 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.5) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 14:20:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bjD8cYQ2lgt+Efe1LfW0Op0eLjMnvppzGgNUOAarVClesSAic68nHYd1QT6zX3oJRcV5vGYeYf+pZQPaY8Xa9Voyj0SIfzxThhnyzVXaHy0HQ6qYbtZGWdibjXRYfELGmhbPbm0rJTWrpUQkneaN9nrBKMt7xQ800D9ftsODdA4lm7mbOZEMvT2QcE4belVKyWa3bPHVDxqXCd9h/Z/B5x1Esk9jsn7ugWdXODN7swFEkCX7hn2u7FBF+pBPy5836x02e5oADn48W6yuRwCUop4Z545uLZKNGwH8evYJCVUvrv88zaUnh934uchnueTvys24+XCtB3RxuaE+5Ixb+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iJHrc3EVUFTsWfjZI2eJYPYDVCosebp/Rv2wpIYC+JM=;
 b=Ho3/6LZN6NpAdmOknc20gKDllhlUUfx07/MHp31uaaXGaA3S5y7qGiJ+4PjAyh94EDAi4B3npyIunXcNDqdjwzeXJ5xRK9qxHVFF7EejMKgLPIUGdr8pREOvW7vNO0bnPX7KvHDIjm4Gmo70/vFKGEpgDoDnTw/FKJ5tB5ZRFaAguCnG7iSiL5Tk9KcNri1KJpWz57gAWVaZw9l43o0i5I+lJue/NHrbNDaB55vKo6m5EmGkMkoLHg2Z/KjTdNOcYJBWC2Jjm9tQxczSHOSwAuKxcy00Ztdn1zYKSYA6fikMZctRGi7jXV8153zJOswFZcWoE/Vc4YWGpM20qhV57Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW3PR11MB4570.namprd11.prod.outlook.com (2603:10b6:303:5f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.10; Thu, 29 Jan
 2026 22:20:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9564.007; Thu, 29 Jan 2026
 22:20:18 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@kernel.org"
	<tglx@kernel.org>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "sagis@google.com" <sagis@google.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [RFC PATCH v5 04/45] KVM: x86: Make "external SPTE" ops that can
 fail RET0 static calls
Thread-Topic: [RFC PATCH v5 04/45] KVM: x86: Make "external SPTE" ops that can
 fail RET0 static calls
Thread-Index: AQHckLzQFrPuo30t10erbAiwVzJgFrVpuWuA
Date: Thu, 29 Jan 2026 22:20:18 +0000
Message-ID: <f9f65b0fad57db12e21d2168d02bac036615fb7f.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-5-seanjc@google.com>
In-Reply-To: <20260129011517.3545883-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW3PR11MB4570:EE_
x-ms-office365-filtering-correlation-id: b9421aac-ea53-4292-6867-08de5f8495e3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VU9UVi91U3EwQ251dEs3eG1EWHBjaWRxRFh2eVA4emlpR0R5N0hiQlhLQUNP?=
 =?utf-8?B?NUpYOExTMU5HMFZMMTlHSk4rUUdHM1J6VEtMZmM1UzJuMGgzQm9WNlEvcEtt?=
 =?utf-8?B?U2lXcnc5SmRFOUt0UCtudHVYd2NzWTlUMm5PUk9xM3NhN25uUXJRTDJHUUVr?=
 =?utf-8?B?UzJvSDlFS1hRTy96OUcrT3JSTFhPSWZlaUNTM3VkTWdsL3NDTGRLdUN0dDMw?=
 =?utf-8?B?WHk3UzlQY1hodG1JWk4xVkdpTjBqOFgyNkN2TkVaNW1rRzh0SUs0SVFQRWVU?=
 =?utf-8?B?RGlSQ29zUVhIVHdHdnJybElwKzMycVBzeW01K1VUKy96RjYzaE52bGxiUGx4?=
 =?utf-8?B?bkNNNi9valNZbkNEZU5QWjJsZ0dlcy9JdmNJai9mWkpDSkx1M3I3Nm90K0s1?=
 =?utf-8?B?R21zZTNEWHhZa0ppdExxUnZlQ3Uzc1VPb0lTcFZRa3MxYnRRY2piSDRnUitP?=
 =?utf-8?B?SXQxc2E3RndDWjdrYzE2REFnQW92R1ZxMkZQeWY2TmZDeWJFZ2RHdDlqbjdn?=
 =?utf-8?B?MS9xMkdBMTFndmRSNWRzdXhlNDZKWW1LVDAva2dKdkEwVjlFeVMwTnF6dU9E?=
 =?utf-8?B?L1RSRzg3YXZJNG5RSmtwTUlKanROWm9PLzR0QlBINERnNzBzeDdqNzFWckl6?=
 =?utf-8?B?cTNNU0tjMU8vaGFIdzBZaVZyWWs3Sm1Wekx2YW1yZ2cwbjkveU1wZ1RFUWky?=
 =?utf-8?B?UkhRS0NEd0VwTTBRSGpsc21xdTBQTFROVzB3aGNRWTllenZOY3FlY1h5eFEx?=
 =?utf-8?B?ZjZkcmU4Tk1nTXVCYUpUYUxhb3VjZERlN1Y1Q2k0NDJtR2xvZDJTajZ4NndO?=
 =?utf-8?B?ak1tc1R5cEI5ZzJ6WVJZK3pqTjR6WmpPN3Nlbkhxci9IbHBUTlpEY01ORDA1?=
 =?utf-8?B?T3Q1L1VOM1REejZvV2pvV0FHMjBmQm1ZUHhVNUVXUkJZQlMzdElmN2dnWEUx?=
 =?utf-8?B?bjF6OXFDQk1MM2ZOdE93T25JdHJDWE5RODVNakd2Q2lEUUlEWGJXcG1RVTVi?=
 =?utf-8?B?WktGdzM1SVdGTno3ckpRaENpR3Q4U2kyZ1J3VUh6bW5SbmhEalhscXhtVHVC?=
 =?utf-8?B?Mjd0empBdkhseDB5OVF5UmprRWZpaGVnKzJndXd6a0gwWVpRYndUV0VGU3BD?=
 =?utf-8?B?aWV3UnBHOUJ0cTJ5S1hoYVVXTVJ5UEpGRHNVMjhqcXlZOG02WVJWZml5cTVB?=
 =?utf-8?B?eU91dGsvOWNGNHM2azV4ZDE4M29SeUhBcFJqV1pFcDFTUUNUaWtQckJDNWZB?=
 =?utf-8?B?ay9HSFhxKzZVQ3ZEUXhUZ25iRDl5YXBwSCtvcWN5dnhrd3FwRjFkUWFjMzZY?=
 =?utf-8?B?L1RCZ1hEWGI3UE40eWVBaVJLdG51OFZISGRxT3FSQWYwLzhLQk0rZmlUZTdJ?=
 =?utf-8?B?YmJsTTN4TXpMRHpybUxkWmNiVmwyV2JISFkvaVNMWmtjeXhqUGtJeTZRbXhJ?=
 =?utf-8?B?RDIwRytPa0xKcXU4Y2czT01CKzJJTWdpWFdoT1hPRTBDeUt0Y0YvZXc4c0Ju?=
 =?utf-8?B?YUttMFBzbk9SQitvTzhFS1RUSGJmNWFtYWNmVlJ4YmpOZWFuNDV1R0paT0RT?=
 =?utf-8?B?dnlUM2p1ZDNaRk9jSnRCSlZET3FKcjM5Q2RGUkJSOHYzZTFmbFJnb3RKcFR6?=
 =?utf-8?B?OXpjS3VabnU3WDM0azVXMXNIRkx0OUduTlhEVnBmWnZUMU1obXJueUxkTXFa?=
 =?utf-8?B?K0J4ZG1DSFp5aEVZKzg0b2sxM2FBWi9PaEhMVjByNTJGSzN4QXAxeVdneFFB?=
 =?utf-8?B?Y1ErODJyVXE4d05STHhzT2IrUTROQWhybCtvdGlXK09ZOG1mMldCbmdORHli?=
 =?utf-8?B?NlBrWTczSlZXdGxDOUs5RUtKazVGZHFKYTRnNUo5Rm1XVC9jaVU5M1VDSVF4?=
 =?utf-8?B?MlhXZFJKZnBEQkdFejhaUzl1RVN1STBydml2NVF3WGprNElCSmU5ZGtoeWhV?=
 =?utf-8?B?VGZnVzFMNUVaa0I0Q0d2blNpUnhvS2RkOEhQWkhocnlsK1hhZG9Sb2IwNHlu?=
 =?utf-8?B?REFKMmxnTHgvcXlVdUVwQVRsaWU3MlRoSVZNcmtPR1BFZUY5RnMxd2xmMTZv?=
 =?utf-8?B?VmFXNW0xYkNXWHRHZUJvZkgwcDFQT0ZzYThBRnpMU2JUc1k1LzN3UGpYOXh0?=
 =?utf-8?B?Vjk1SUpVYk9IOTlFMWRZekdKOXliZDBlT2pLckFXSjlQbWN2ZW02S1NUNFda?=
 =?utf-8?Q?QVZ4WD0BxtcV5wcTe+cU7Eo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlJUd2hvLzE2ZVFaMk4vWkZwQVU5R2J1QVQyVnRtZGhDNlpMVVlOdXpXVDlp?=
 =?utf-8?B?TzRMdC9ENGlmZjlMcHV5OEtpWi96cHdKbW00dzlJQkR4Q0J4MUNyVzlmeDMw?=
 =?utf-8?B?WXhKa0QwQjQ5WHNLY0g2eTF3ZFlXVEFUdlZqdVFTQ3plMXNpQU10N1RSc3du?=
 =?utf-8?B?NUl0Ni9wSTEzWVdONUE0TWNCMDM0cHdielRQZW1POGdBTWY1dW5mYXRodUlM?=
 =?utf-8?B?QVVMZFVNemJLL1h5THU4TUN5UmJDV1RqejhSM1JOQVlSZDU3WjRXcXprYWJv?=
 =?utf-8?B?bFF3Q1lGdkI5bENXSDdNL3pwOHFRL2JTMUtpWERxOEl4QTkzWXF3VGpoQXJ1?=
 =?utf-8?B?Y1dsbUY4WVM3TVAxenlOdThnYWlHZmN1azlwN2pPdS95Yjc0bW83dWtPQXpm?=
 =?utf-8?B?WTN1ck5EakI1L3ZybjUxUTVQU0dpV2FGOTlQSTRDeGxYUUFOcnM3eFlnZzJi?=
 =?utf-8?B?QWg3MURyUmd0ZTZRcXFuSTZPaHF4S05hMmhiZlVPQWxjbW5IYkNURmVEVEJa?=
 =?utf-8?B?UVFzTGZNVDZScEJHSEhscWhjNy9OMklZMk1sTkJWV25CZDRmZDM2WmxmdW9q?=
 =?utf-8?B?Z3hsZmozdXlyY2E5SEZZdUhOcFh4anNRalFlYXJQMVlOTGoyMlJ1Nlh4Z2ti?=
 =?utf-8?B?RUlocjdGaUg0bWx2SUhLQ2l3UTdNT0s5cWtjT1crWlZNVUVuYk5kejR2Tmdn?=
 =?utf-8?B?UVExVjFKdXk0YzI5OGdHd09GL2MxUGNGTG52cVdrdnVxSmVMQTdlYll6Ykhl?=
 =?utf-8?B?dHZuUVJBMFVqVm5OVVRNMitLbG5zeHc3N2xHdjMxU0lVK2oyZHlTL3VkNzJ2?=
 =?utf-8?B?WGw0VThxZFNnWGkzMU1SbnBtZnBsNk4vaTF2TXh3czlWcDR1Qnp3Y1BLLzNE?=
 =?utf-8?B?R1pCRVNRbEdUbnhsLzNKR1AxR2l1VEpsSFB0Q0ZBbVB1eTA3TUUrR3BFYnNx?=
 =?utf-8?B?TUo5RHhoM3VHK3Z2RmRzM3RBS2U0Zk9zbEhxTENuTm53VkR5K09TRGRqV3c1?=
 =?utf-8?B?Ty9ycWxKejd2UDhVbXRCNlpQWWVYWkRzbXJPTU5Fd255R2xXdzVXUjNTaEc1?=
 =?utf-8?B?RzVJUUhpTEVpQ1hOREk2cHFLellrQUNHVmhaUzJ3cW9UWE5GeTZGUmVaa3BN?=
 =?utf-8?B?Z3NWRlcwcUM0dlNOUTJIRW80ZjNXd2toT2NSaFkyZDIzWDdPeEg4VEh3YlFY?=
 =?utf-8?B?MWJ4ZlhHSDZ2S1kvMjcrSkRMK0N1SHFtZVhFN1BDTHpIMklUazFLb3VISUlm?=
 =?utf-8?B?RE1TZlZqazg2NERyNUVYSzk2SWJRaFRQTzJPa1FocUcwSDZ1c09yTmk1Nmtx?=
 =?utf-8?B?MmRmTkt5OWVsNmM2Njh6OGx3czB4SGZGV1ZiY3pCc0lQUGE5eGJ4T3pFbkdi?=
 =?utf-8?B?U00zYkNJUXhCL2s5aDZ3OTJPN1lqOFhVYm5oUHJjdHhNTFdpZ0tDaDNyMzl2?=
 =?utf-8?B?YlVzWjYzU3NDalVsbmVvaTVpY3pVS2hPdUdEb0xQdVY5bkdYa1RaUUl0WFUw?=
 =?utf-8?B?Q0dITkdIR0dzSnpma3F4eUlDZFBDb1NUaVBtd0RJYzhQSURMUFlOR2Y5cU1t?=
 =?utf-8?B?bjBPbUQ5K21JdmlWOU1yZmtIZktEYUNyci9DZjhzL3BNOVZMOEk1ZlhrNVRj?=
 =?utf-8?B?V2FyenNNVXhrVzI0K3p1eFRTekI2ZERoeUZ2ZGZmQ3hIWXdvYlFsRmI2SXcr?=
 =?utf-8?B?WXo3dVYxckFYNWU4WDY5ZWhzcmJMako0eXF3Y0NYQ1JjK0tUKytIWWZ2aEhE?=
 =?utf-8?B?RS9kMEZmOUZySk8zd1pGa2RFQk5TQnR5MlJDTG5MNXhzeHNkR1l3VnFqajBv?=
 =?utf-8?B?TlI4SHVlVFJMUHVleHRVT0d6dFFYQ3dLeDI4WjUxWVFlOUVjTjZyZFh6YXpF?=
 =?utf-8?B?U1d5cFNLR1U0N3VLdDdhL0czZ0NmdVMxemtSZzlRRzhWeEdEM0xuMi9lZjZt?=
 =?utf-8?B?aHhVUFBpeGw5aDFrZVQyaUxqLytrRlRNeDRhWXRwWUlycTlWdW9kWmdWT243?=
 =?utf-8?B?NGJrNGt1ZXZTaFYzc2NHamhOY09qK0FuaWowRjFNVTBEb252Nmh3QW52QUov?=
 =?utf-8?B?bmFCRlRDNFJMSGNURjZTdHhtM1JCZUk4VEhSNldNbHZIRCszcnVUVFVUZjFi?=
 =?utf-8?B?eExWQVBGQ3ZpVkVsUFZ2THhxLzdKUUVrK2hqaHRkR3ZXQXQwWkZQWkNjTko5?=
 =?utf-8?B?bzBHbldZWTduKzViVGNKKzJYU21FcU1TWVpHdUhiWEY1ejJoMDNBS0hLRlBG?=
 =?utf-8?B?UjBXdU5mK1BtZmVpa3hTckg0L1ViT3U4MXhZSVZZZE1RNTB5aHJaeG1PSTFw?=
 =?utf-8?B?bWV5Mm9pNnNmS01zeDZDVUd1OG9FSkVWVGQzTEkrcHVmRlhVTytmRW12K1Bk?=
 =?utf-8?Q?9qvgc0An4lhxh20g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C42BA0D3604901438317DBAFE4A73618@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9421aac-ea53-4292-6867-08de5f8495e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2026 22:20:18.8176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bfzmJ58OQy+i2OmrAQH6uV77qWAkwah1l/JKFcjMsmwWE89gk0ejAn0sJvaX0JKWCcS14Xf8nDrBFJ1TwqqEQkGRxZZeFIAQtsIS74t0D18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4570
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69632-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: ACDC9B53E6
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAxLTI4IGF0IDE3OjE0IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBEZWZpbmUga3ZtX3g4Nl9vcHMgLmxpbmtfZXh0ZXJuYWxfc3B0KCksIC5zZXRfZXh0
ZXJuYWxfc3B0ZSgpLCBhbmQNCj4gLmZyZWVfZXh0ZXJuYWxfc3B0KCkgYXMgUkVUMCBzdGF0aWMg
Y2FsbHMgc28gdGhhdCBhbiB1bmV4cGVjdGVkIGNhbGwgdG8gYQ0KPiBhIGRlZmF1bHQgb3BlcmF0
aW9uIGRvZXNuJ3QgY29uc3VtZSBnYXJiYWdlLg0KPiANCj4gRml4ZXM6IDc3YWM3MDc5ZTY2ZCAo
IktWTTogeDg2L3RkcF9tbXU6IFByb3BhZ2F0ZSBidWlsZGluZyBtaXJyb3IgcGFnZSB0YWJsZXMi
KQ0KPiBGaXhlczogOTRmYWJhODk5OWI5ICgiS1ZNOiB4ODYvdGRwX21tdTogUHJvcGFnYXRlIHRl
YXJpbmcgZG93biBtaXJyb3IgcGFnZSB0YWJsZXMiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENo
cmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCg0KV2UgZG9uJ3Qgd2FudCB0byBjcmFz
aCB1bm5lY2Vzc2FyaWx5LCBidXQgZG8gd2Ugd2FudCB0byBnZXQgc29tZSBzb3J0IG9mIG5vdGlj
ZT8NCg==

