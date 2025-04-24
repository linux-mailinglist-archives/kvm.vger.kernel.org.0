Return-Path: <kvm+bounces-44227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A377DA9BAF5
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 00:53:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A22E31B68505
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 22:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3193428467A;
	Thu, 24 Apr 2025 22:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rgjt28kd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC9E224B13;
	Thu, 24 Apr 2025 22:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745535188; cv=fail; b=PJAznWxLOrlRwh38Dnb2TfaLpa8Rysd6t0d9+Hp3pyUyQpzD2Qz3xRwfWl1W9+lVUrD6BlVU90QmGilJpaYGVd5xYAtSuciHpqYx2GoisZiwSYwVggqGuUaR0OkV5eGk6ZML5XpVBmdl33Uga+1z28aQeMLYpvV9SKg9xadECOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745535188; c=relaxed/simple;
	bh=gATVI1sT5iRy+Ud5pnxZGHzkBNfVOwczIik/rlnVviw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=O8tXqFf7j6qwC2KooA+ZTKuwYT02ibm3uTb7lbZDxITvFdokx9M5R6NCmtLcR3jC1FF+wKx0FjgB9Ui+ejhAHpA67ixvohjAqjn9tYLxJFxmAIyFxJVsBDaVWDsfPfN10w0ax8xvnbvERlvJQkxmxTTKvTboeQq65xfAuda1AsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rgjt28kd; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745535186; x=1777071186;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gATVI1sT5iRy+Ud5pnxZGHzkBNfVOwczIik/rlnVviw=;
  b=Rgjt28kdoviHe1YNilN1X9rhZly9QhtVJ3hl1wWEQ1MWz9IbAn1PrmDv
   tPdinx1TzE+Ixx6f6P+9dXBkrnOZD636+JZy6BbExFEy7NjDFk9MBxgBG
   L+ua4npPfm5iuvygK/xfHfbh5cQb7Vt9arqDkLv9mX0pvmkhvu/CZm9Al
   ZsGqQIgdxXVoEofqz4O3C2YQQsOsZPOwWtjeM9EqvDgeI+5XWxw7VcgjO
   nIXYGy2HX2ZRYoZoxlfrvaodCPcMDDLeCGRcxAP7Bk0BaQ2sqTNV0XNXB
   Kir4IiumQdnljgL+KiimCNtJ4g/pV9zKsfc2rrFnZhDsLygYwaaSDDzn9
   g==;
X-CSE-ConnectionGUID: aHxbiMpCS3GUoIzLlworKg==
X-CSE-MsgGUID: jXwp3xjLQcy9p2kGDUnk9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="57829490"
X-IronPort-AV: E=Sophos;i="6.15,237,1739865600"; 
   d="scan'208";a="57829490"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 15:53:05 -0700
X-CSE-ConnectionGUID: VFeE6kcYQRWshuahwYPJxw==
X-CSE-MsgGUID: gegtQg5rTny+ueDYPAY6kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,237,1739865600"; 
   d="scan'208";a="137824193"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 15:53:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 24 Apr 2025 15:53:03 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 24 Apr 2025 15:53:03 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 24 Apr 2025 15:53:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ooEsC/GZ8AjercIEop0M57guGBN66frctiDcV2psfhX3UnqYlPZrgjo/04TW/X/Dh2jP+HLxyVBaQqqeoT+N5wO8COtZj2aH3+lZCStN1awwX3dJPjli1Ftx3WoaGJRdMGTgE+2shh8I0i6c4nPX/T5p/hBDnzw/q516bGG+/xJ6t+Id3tfoi22VW/L8fsu02J1VHsSOkhUfQdSfnPkW1Om0/svvTBeOTzsuKjfEmgwRldebAyYihd1/DS5VqAPki/VQhFysWOk2XDjyqarfKfHt4peimCjVjibU+PFXgUg83H+NKQxsn9r3eEQZ54cVFZQF2NI+7LiqLY6knnP0vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gATVI1sT5iRy+Ud5pnxZGHzkBNfVOwczIik/rlnVviw=;
 b=hBV4ias2Et7R92ugEEt59mAgsnfvPNa9VIUiOq3IWxyk+lunIXOolYNliIBjbFp0bcPjZbpLlC9/QvQRxZI6SbGjD1KW17RcLfWJTBbyo8WaHauoFbQ2WER58N+9Eo/By8tnju6cWiSrZuJelRo0ch+5wySbbKfSt1A8NtdxjCRUIKVrayVtJN1enmF5+Hb7dYPtgkl9olH3ooG4BI776RRVEZ0C6PXLBpeht99eSvVT+2FnXRAD+N4FIElbInpQ/YxStNz+G4isrOwPSWf9OZ5V92tFLvUrkAfE594Dl4Fe/DSLTdTypzfdrEKQ3vQEEu9M7veNdN6RUCz4w2fyjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB5793.namprd11.prod.outlook.com (2603:10b6:510:13a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.27; Thu, 24 Apr
 2025 22:53:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8678.025; Thu, 24 Apr 2025
 22:52:59 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Spassov, Stanislav" <stanspas@amazon.de>,
	"levymitchell0@gmail.com" <levymitchell0@gmail.com>,
	"samuel.holland@sifive.com" <samuel.holland@sifive.com>, "Li, Xin3"
	<xin3.li@intel.com>, "Yang, Weijiang" <weijiang.yang@intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "john.allen@amd.com" <john.allen@amd.com>, "Bae, Chang
 Seok" <chang.seok.bae@intel.com>, "vigbalas@amd.com" <vigbalas@amd.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "aruna.ramakrishna@oracle.com"
	<aruna.ramakrishna@oracle.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features for
 host and guest FPUs
Thread-Topic: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features
 for host and guest FPUs
Thread-Index: AQHbqelZqhZU+Oq6j0yiouUZFd9/N7Ozg2wA
Date: Thu, 24 Apr 2025 22:52:59 +0000
Message-ID: <f53bea9b13bd8351dc9bba5e443d5e4f4934555d.camel@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
	 <20250410072605.2358393-4-chao.gao@intel.com>
In-Reply-To: <20250410072605.2358393-4-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB5793:EE_
x-ms-office365-filtering-correlation-id: 6febd732-2e41-46e8-c812-08dd8382c313
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?YkVSMU9SNGNLUkdRd1hHK0hvNmtISVlQb2NYNldXRGVXR21qU1lxWU1zK3dU?=
 =?utf-8?B?akxtb2ZuQk1jUHR0RDhTUkZsL1A5KysyNFRnK3lscHBBZHB0b21wYWh3Sk05?=
 =?utf-8?B?ODJMT1R1VXdXeEFvS3JnNTNqK2piZEE1d3J4R3Yrem1aS013WWwweUN6QSta?=
 =?utf-8?B?N2U2aTdCNks3cmVSTXM5dWZyNXRRcXFnL1d3aWI2ZnRLQjBxNUFxcnFFaEVa?=
 =?utf-8?B?OE92VFkvNnI5QlRWUUlPamdRNVBFbitWREdZTG1nZzhRMi9laG8xOG1sZUdD?=
 =?utf-8?B?MDcrZnJISHNjRXY3U29YMWZlY3NqTm5mOU1PdnZKbzdGUCtDZUFZcUhLbUli?=
 =?utf-8?B?a2FSeG9Ed0xZNWsxME9UcGNxWElPZDhXdklYZ2JRY3dPam83eWJLZElQYzZQ?=
 =?utf-8?B?cHhtOFhoVlhDYlA5SFNCVUNTaVJFQ0xWMUZsdGNkd1Q2Qm1MT1dXZ0VrZXdM?=
 =?utf-8?B?ejFOOWIvZnRsQVZPRGdvOUJUSGtsRkh4NGlDWFpwRmY4cTZNTWl1UFl2QU1V?=
 =?utf-8?B?cjJNTVFQZzVTc3E2RWtWN1E0NS9PelhOaFY3YzRsbmpGMmlQcnpyRTFQU2hP?=
 =?utf-8?B?cmgvdmVxNUVURnkzWDZNVkpaVGVmOWwyVkNwdWdacHJLZkpjYjJaYjZLak5D?=
 =?utf-8?B?T0U0elpqMElBVklwQjJDWTJmd21JNTA5RDlLMThDRzVpNzI5VFZZM2o0bHpo?=
 =?utf-8?B?OThGUjZUdUJYZGI1L2w2MFArTjcvSURnTWVjNFpvWVRNYnMwRlpmazVKa1Bq?=
 =?utf-8?B?VTJPMXg1ZDYxL3pQVGJ2OG1UektCUStVMWYxWUoybGtZbEpldXorcXdYZncr?=
 =?utf-8?B?cGdrNXBUeEpOYVEreVFXcnRLUldSMkdmQmJwMGFkV3c1ajZHcUlsOVBtM2tI?=
 =?utf-8?B?QVp3ZDVzTklrekxPd1Q5TkFWVktVNThqb1FpWXJtUktreE5oeVpZNy83UThH?=
 =?utf-8?B?aHZEUEk0UXdrMWxqWEdVWG5aYUtROUxsNURhYkdHZ3p6YVpMbHlTMHdqU256?=
 =?utf-8?B?Y2tvMFg5NnJGaThvbFZtSVJlSlZEeFY2TVRqRXU0ZjF6TGkvZVFsVGxpM3BL?=
 =?utf-8?B?OTNiUENuWVpMRnp3blpUUkpyUnpMUjZ1NTlQb1JVZzkwMU5yZDZXMC9DUFJq?=
 =?utf-8?B?SjNKYXliYk1ENWIvNzR6TUt3SGV2WWZlQTAxbzJ3WktYQkxOb0dzUVl3LzZ1?=
 =?utf-8?B?WStEZzhkYzl5UEFuWTVxaFJmTWowelNCdzhyL09Od0Q1S0VtanQ1ZTJnU01V?=
 =?utf-8?B?Q0hSWkF1bzZrT1JucFJPWEJEanZxRHIvYnVHWTcwR2ZLNG1OaU1lUEhrSHdJ?=
 =?utf-8?B?NXpZL3NyUlpiRkdneXBuMkg4REFXeldBNHJ1RFBOZ2JtYU1oRzdXc2Jhd3l3?=
 =?utf-8?B?dDZML1JlS25oTVpvMHJDNWRFd0cwcTRDaHFBR3hScE9BS1BMV0h2K0l2MVJG?=
 =?utf-8?B?TWo1UFNQZk5YbDJYRi8yODlkMURrcGp5bEdOY0NQNkJrWUpjaE5SUkpMSTJN?=
 =?utf-8?B?c3JEQk45blVtOHNQVXJYbmZWb05OYTRkUXpXOUFpV1ZYbFZzeG1RQ2RhOVJJ?=
 =?utf-8?B?cDNtVFpkTEtpWGhyTE5nUnVqNDJUTDczcmRWaUFuU0VJTXpLL0RiQlFpU3Zq?=
 =?utf-8?B?a1ZZcnJSMEVtMThrQStUOWM2bkIzY0NUQzROWER2eFU1SnFYeVVnbUQ1UG9U?=
 =?utf-8?B?d1RFYzdQVlo1aG1xNlhib3lHZzhQMjZHZ2RxUHBxNnFMTWROSFVPd3IxQVdT?=
 =?utf-8?B?c0RJV2hGbVZmb0pHaC9WMEh4Y3lXM0Y4Nk44cnpNQzhDMXRXWnB3QjhLRVk3?=
 =?utf-8?B?cmpDd0pIS2lsN2p1QVBxRUR3aDlTNnY5NWJ0UUt4aHZiSmxVVU5DY2VTVUhl?=
 =?utf-8?B?QnZNUjZjUGY1T0R2ZTAzR1ZmQ0kyM3FFNmxYUGlGaUF5WUxQcnMxRGpZOFFy?=
 =?utf-8?B?ODQzRnNqY2hQMVJ4N3VUTGZWNSt5dC96Z3NVYk82clkwTWNYNFJaMWtJbDJP?=
 =?utf-8?Q?EDWRMaRMpOl2l7f7QdDTIOt7lRDUYo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V3U1VTVnZS9SRG0rNmJ1cW5ndktoYVZrN1RiZExQRDJwa25IUHp6SXlJWDA3?=
 =?utf-8?B?eWw5THErenArMEQvQmplSnVOTzNWdmVPRVMwOVJOVlhHVU9LNFhSN0d6TlMw?=
 =?utf-8?B?R05CVWdUc2FXRFl2OXQ0aFFBOXdRY2J5VkhrbTdwMVRPbWxRUXdHeTIyUFB6?=
 =?utf-8?B?Z3FENjdnUE1JSHZ4SEpiTU5mYnhNbTN4ZjV2SlVxNEEzUUJCU0s5UTd6ZXhl?=
 =?utf-8?B?enRBMmdENXpZNXR1bWlaZ0p1SE9GZGJpb2l5QnNnT2RDTHMxNFlERGxGK0gv?=
 =?utf-8?B?Qm0vRVMzRXAzNjNqbHBmeUVmVlE0K0x3MXJSZXoweGtnb2RtSU1lU2JnYzZN?=
 =?utf-8?B?MzBQYlJ5V1FML3FKRHEzcVBaUldPT0RqdHNNK1lqdkZtMS9xNWVQMVQvZWhV?=
 =?utf-8?B?WjhrWE5raHlIR2lMMHoxUWpjY2NHNUg2Q2VrWlE4MVBrTkFZWWdoS2dtc3I4?=
 =?utf-8?B?R3FtUjlSeThiVTJsdUpWbENiWkQvK2Z5d0V5S1VoSFQ2YmlOOE40dzBjYU0v?=
 =?utf-8?B?YnhsUnpSbjNXdXdjTFdnVFFoSU11TFdldkFzY0tUcnhDZVpCRmsyaUNLTVdI?=
 =?utf-8?B?ZjFteU9KT1lIcncvRnc0N1lLQjQzVkJUKzZWT2RhZVJyZkFISlRKVFdJRE5I?=
 =?utf-8?B?V1QvUnJzVVlJZzdwRXhseXVxTkF1MkxhQzhZb2pLallNOGJxdlBFZEJ2NEVI?=
 =?utf-8?B?YU9JTWNMSUpLcGZzV3RpS3JzUnQxV3NMWXFSd1FDTGs3dUhyUGxVbUFlOWZ4?=
 =?utf-8?B?M2V6NUZoWEdFQnpsZ2cxTmRaVFJuNXJOQlhadU5IT0puaW5JYjArZUdtaHRS?=
 =?utf-8?B?bFZHT0xaalg0OFBTb1hGZ1B2RERIV04wbGg0ZDl4c3NhbkdVZzVVdjZCTXow?=
 =?utf-8?B?VS85ajFQNnRxc09oY2NrVU9MNmN6dTJ5K3pZZFdwWjFPY2FpSExWNGhSMFpy?=
 =?utf-8?B?UStPVktvcVNFRFlDSCtkbnA4Zm90T3BrSjd2cjI2Q0xVbko5T1pZQ2VoMkY0?=
 =?utf-8?B?UThhSWg0Q3Q0QjE5L1hiZWNXNU00L3RQR1hZSGxYYWhHUkxXTjlSUXBubGZy?=
 =?utf-8?B?cks1NWNsZ0FHa0JkMDA4eWFXQU1ib0hqZUJTMEM0NjZ2VytzODk3SzJaUFJO?=
 =?utf-8?B?eE5GOUFKRnhDMks5VXNXaWtNVmdWWGk1SWQxVG4xZlUzaGNHbHFaYi9YNlVv?=
 =?utf-8?B?d1JDTktxMXNnQ1JVR0FhZy9GR3FzaVh3VHpkcXNlWkpXZWh6T1JpUG1aNHg3?=
 =?utf-8?B?R3dxNVR6eXZSbW5DcmZNVkIxcytNOU03NmtJMHIwZk8yK0FvbCsrQU9OMjBt?=
 =?utf-8?B?b2ZFTXlURnNTZ3FXSmhmU2NUclNmbzZ2Y1ZuRkp3L0lubDA0eGRqTG10K3oz?=
 =?utf-8?B?NUZ5YzZXMjZJKzIwRTBHdUVDTnhIQzAzTzRNaGpySVI0VGhzUU1lSi9GTXda?=
 =?utf-8?B?ZXVHMi8rZjlFbWhoT29GdU8vUDlZOERJSmlQTm85VG9aWm1lRlJRMU1WeXVF?=
 =?utf-8?B?Wkt2TWF4OU94ckRSN3plUnR4Rmk1RkgrSFlBSGthUXIzUFM4bWV6V2xrNmJu?=
 =?utf-8?B?UXVzTkVYM3d5c1Z3ODBsQ1NHbDkvUXQ2TCtGd0Y2MXpabWpBQk4yWHV2SkVk?=
 =?utf-8?B?WGt3bEoyUXl0bVJMM0VUcW5MQlNrcGJyTXdJdisrcDBaMjZyaW9pQnpwQTkv?=
 =?utf-8?B?V2t6a284cGt3eWM2T0t4bTFibForYnNITm1LcGVXQ0RzcytZQmpwMWVQa2g2?=
 =?utf-8?B?eE8zS3RVUitaa1ZnSG1ZVUk0V2g4ZWV6UERyV2Q3ekxMT2RhY3FnemVGeDdk?=
 =?utf-8?B?bzl6bTZzcHdDUVQ4MWNxOGVmakJ5TGI2QnJ4RnlwK1JZK2s1L3FTZTRCR2Zw?=
 =?utf-8?B?SThPZ0p1NmQrVjhDNjBUVU8vc2RVQWdocnpsZStMUHgyWmRqdTVhMy8vcWJC?=
 =?utf-8?B?OTh3eEVJVXR0Wi9CVTFJY1hmYnZqOXFicUV5RUs1N0ErdnBJdTI4WHhrbUZa?=
 =?utf-8?B?N3huVTBhTlNnU2U2THBvc0pHMGgySnJzUlRhZDlYcy9rNmJqS0t1OTlleEor?=
 =?utf-8?B?L0JsSHgvRjhxUmRscmxqOHIyTDZudVF3Q1p3dVhFUEIwNHVZd3JlUkVPTTc0?=
 =?utf-8?B?M3RjZjBJb2NZTDFSNTNGWkFVQXdZM1VzM053UEtJd0ltWld1REtQNXYwaFNC?=
 =?utf-8?B?b1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F53E83DF2866D47B31C009BD23ED135@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6febd732-2e41-46e8-c812-08dd8382c313
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2025 22:52:59.7718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hsYMWTfSq+4HTOqZr45O1pH3JQg5vkF57bPlPscbRTl/GvhDT9ghH/FXeHiOiyCqFS1mM/bfCVGegmP2H7MazI+rtR37d2Leu+ZQGcm3oWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5793
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTEwIGF0IDE1OjI0ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gKw0K
PiArCS8qDQo+ICsJICogQHVzZXJfc2l6ZToNCj4gKwkgKg0KPiArCSAqIFRoZSBkZWZhdWx0IFVB
Qkkgc2l6ZSBvZiB0aGUgcmVnaXN0ZXIgc3RhdGUgYnVmZmVyIGluIGd1ZXN0DQo+ICsJICogRlBV
cy4gSW5jbHVkZXMgYWxsIHN1cHBvcnRlZCB1c2VyIGZlYXR1cmVzIGV4Y2VwdCBpbmRlcGVuZGVu
dA0KPiArCSAqIG1hbmFnZWQgZmVhdHVyZXMgYW5kIGZlYXR1cmVzIHdoaWNoIGhhdmUgdG8gYmUg
cmVxdWVzdGVkIGJ5DQo+ICsJICogdXNlciBzcGFjZSBiZWZvcmUgdXNhZ2UuDQo+ICsJICovDQo+
ICsJdW5zaWduZWQgaW50IHVzZXJfc2l6ZTsNCj4gKw0KPiArCS8qDQo+ICsJICogQGZlYXR1cmVz
Og0KPiArCSAqDQo+ICsJICogVGhlIGRlZmF1bHQgc3VwcG9ydGVkIGZlYXR1cmVzIGJpdG1hcCBp
biBndWVzdCBGUFVzLiBEb2VzIG5vdA0KPiArCSAqIGluY2x1ZGUgaW5kZXBlbmRlbnQgbWFuYWdl
ZCBmZWF0dXJlcyBhbmQgZmVhdHVyZXMgd2hpY2ggaGF2ZSB0bw0KPiArCSAqIGJlIHJlcXVlc3Rl
ZCBieSB1c2VyIHNwYWNlIGJlZm9yZSB1c2FnZS4NCj4gKwkgKi8NCj4gKwl1NjQgZmVhdHVyZXM7
DQo+ICsNCj4gKwkvKg0KPiArCSAqIEB1c2VyX2ZlYXR1cmVzOg0KPiArCSAqDQo+ICsJICogU2Ft
ZSBhcyBAZmVhdHVyZXMgZXhjZXB0IG9ubHkgdXNlciB4ZmVhdHVyZXMgYXJlIGluY2x1ZGVkLg0K
PiArCSAqLw0KPiArCXU2NCB1c2VyX2ZlYXR1cmVzOw0KPiArfTsNCg0KVHJhY2luZyB0aHJvdWdo
IHRoZSBjb2RlLCBpdCBzZWVtcyB0aGF0IGZwdV91c2VyX2NmZy5kZWZhdWx0X2ZlYXR1cmVzIGFu
ZA0KZ3Vlc3RfZGVmYXVsdF9jZmcudXNlcl9mZWF0dXJlcyBhcmUgdGhlIHNhbWUsIGxlYWRpbmcg
dG8NCmZwdV91c2VyX2NmZy5kZWZhdWx0X3NpemUgYW5kIGd1ZXN0X2RlZmF1bHRfY2ZnLnVzZXJf
c2l6ZSBiZWluZyBhbHNvIHRoZSBzYW1lLg0KDQpJbiB0aGUgbGF0ZXIgcGF0Y2hlcywgaXQgZG9l
c24ndCBzZWVtIHRvIGNoYW5nZSB0aGUgInVzZXIiIHBhcnRzLiBUaGVzZQ0KY29uZmlndXJhdGlv
bnMgZW5kIHVwIGNvbnRyb2xsaW5nIHRoZSBkZWZhdWx0IHNpemUgYW5kIGZlYXR1cmVzIHRoYXQg
Z2V0cyBjb3BpZWQNCnRvIHVzZXJzcGFjZSBpbiBLVk1fU0VUX1hTQVZFLiBJIGd1ZXNzIHRvZGF5
IHRoZXJlIGlzIG9ubHkgb25lIGRlZmF1bHQgc2l6ZSBhbmQNCmZlYXR1cmUgc2V0IGZvciB4c3Rh
dGUgY29waWVkIHRvIHVzZXJzcGFjZS7CoFRoZSBzdWdnZXN0aW9uIGZyb20gQ2hhbmcgd2FzIHRo
YXQNCml0IG1ha2VzIHRoZSBjb2RlIG1vcmUgcmVhZGFibGUsIGJ1dCBpdCBzZWVtcyBsaWtlIGl0
IGFsc28gYnJlYWtzIGFwYXJ0IGENCnVuaWZpZWQgY29uY2VwdCBmb3Igbm8gZnVuY3Rpb25hbCBi
ZW5lZml0Lg0KDQpNYXliZSB3ZSBkb24ndCBuZWVkIHVzZXJfZmVhdHVyZXMgb3IgdXNlcl9zaXpl
IGhlcmUgaW4gdmNwdV9mcHVfY29uZmlnPyBPciBkaWQgSQ0KZ2V0IGxvc3Qgc29tZXdoZXJlIGFs
b25nIHRoZSB3YXkgaW4gYWxsIHRoZSB0d2lzdHMgYW5kIHR1cm5zIHRoYXQgZmVhdHVyZXMgYW5k
DQpzaXplcyBnbyB0aHJvdWdoLg0KDQoNCg==

