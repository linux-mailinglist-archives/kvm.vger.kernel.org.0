Return-Path: <kvm+bounces-55976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D8B1B38F59
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 01:45:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 658091C2405E
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 23:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 800CA3126B9;
	Wed, 27 Aug 2025 23:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fibSLwzi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3E52E9ED2
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 23:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756338302; cv=fail; b=TV3WOCmhcOnqLYbrVdrtrczXVwYXByjl5sfsd/YIFYcR2wuZtNMAs6Hye2ZKdgpbTUCHIEyBTmBbp8x5yHTotO3IWISESrxltVSoWrZVElYa25kTcXgB5wuGxN1EpOlNXxuZsYdky/Psjy0djVdLBXuxKSNfBhx0hHqIsS6NMv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756338302; c=relaxed/simple;
	bh=0X6iUlLwUyJJtrQmyllA1DWN7My6mPKLSbUH3nhyA3w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XI8fC7tX3qFydAvPFpiYxvia9oLvRZ6iH74bkmNwK+hEh9iReP2R0x0UP9+EZZ3exPV0N72jzBqyfw14cEN1RXgl3pAwbvgi1+W0i84Jiz+jub93H3aII8mjFjwT0QIqomeKF0WRpSUJFbXbFdBGmTeDK0Bq66Tw2w8Cv/radl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fibSLwzi; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756338301; x=1787874301;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0X6iUlLwUyJJtrQmyllA1DWN7My6mPKLSbUH3nhyA3w=;
  b=fibSLwzi2+tc3YW8UMKDijjuWYBQeNHNLA/XhMDrm4yzlY9W1jDOIysj
   AGb85R9ePg8TL3e0ur4TSs1bGXzHdU3Q1ockxVqHk73ZQTuGpqZSiC8eM
   ChEfoVbOpkvZnXRpIbi04qZZ0OKE2dOMWR0bqre0wpwrjTku54R42MvGb
   8BfX7X7wo3nCuhCF0NLFb42f6AU18aoymWfpcm9+c2afaViBWHS/73+ek
   wx9dcL45VCGOgfx/9POsJZyAwsO7wUxFmEwyzrAZM0Y5XrXqLk63fiCBY
   PYyniQ51dfCPTUQWEuztRSkQkVI6NSM0h98JTeXAmoWY6LEIQDg8oVnSp
   A==;
X-CSE-ConnectionGUID: vRjKtx9rSr6gLBdWBcNPQQ==
X-CSE-MsgGUID: UMylp7IZS8yK9gvXpfshuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="69969213"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="69969213"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 16:45:00 -0700
X-CSE-ConnectionGUID: MyDexs6LQFWJv01isPkh8Q==
X-CSE-MsgGUID: oQQwDh9sQNGWZoIUXxI4eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="169216092"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 16:45:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 16:44:59 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 16:44:59 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.40)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 16:44:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=faG/LItwrdaY+d+bpSSNE2ZwrHlGviMHggexx8+tjSf3Cr/KlknC9AulkC+ZVshWp7OettG0Tdp9GDCJYQmdVJgazIM9QhSPlCOjuhx2w7l0p/TDGP9jMvW7QRtKda12E8NbjsSPFXKsoZXt84mDvB3fBDyQC/fcpI02MAyMulMJCYZ+H2T/3v2zILIn+Zp2QFnFdeDgi0sBOaoF7mzuZh8crmI7jqGpD6Vt1i+jCUSAwXHIs/CH5a0lk7b4QC1SaHxMZ0jeuXj3Q81MLqwnfLhanabjmWv38jGxIsbJwdKbI5A4y4ceZwSZ6WTHjuM6QUL17QhbM7c5EA//c744Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0X6iUlLwUyJJtrQmyllA1DWN7My6mPKLSbUH3nhyA3w=;
 b=kWDbFF+UpG9Z0nKb259Cez3mQ7p+I2IoqeDtJoBjj2knggkXHWDPdtyROrSW1QQJfoc6KD4liOjpFgqtjU5hqrSmH3Az+8fUyJMywB0DpVh+LH1icXrDQ/ANNxinGcG0dmT55s/PHpg1UCSofVU9aF5OkoearX7V7NTZ8pAM4hM8Ujxt2NfT0UNgdaPbIWwQLV5DURbTYJArMWM/VoQmqM0FCW69j6Poai/F5EU1MffPhGh6jEPLtHcSq43NXl8F4Xx9NF9LmVKbhSPnIY41wtZtmJ3YIQ4rYbyxpT1wOOo5V3U2y35ArV8v4mjpWVHpvBR04DNDjO0smwbBRPU6PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA2PR11MB4874.namprd11.prod.outlook.com (2603:10b6:806:f9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Wed, 27 Aug
 2025 23:44:51 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 23:44:51 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [RFC PATCH 4/4] KVM: SVM: Add Page modification logging support
Thread-Topic: [RFC PATCH 4/4] KVM: SVM: Add Page modification logging support
Thread-Index: AQHcFdP/eGfeNpsxKkei0uEsxdMRfrR3LX6A
Date: Wed, 27 Aug 2025 23:44:51 +0000
Message-ID: <fb9f2dcb176b9a930557cabc24186b70522d945d.camel@intel.com>
References: <20250825152009.3512-1-nikunj@amd.com>
	 <20250825152009.3512-5-nikunj@amd.com>
In-Reply-To: <20250825152009.3512-5-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA2PR11MB4874:EE_
x-ms-office365-filtering-correlation-id: afe5630e-7f9d-4ff8-f222-08dde5c3b799
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YjhUSnZaZ3FNdEtlUWZjZU5BeVF5bE05aHQwMG5KTXZDeE4rYWxncnJUK2M2?=
 =?utf-8?B?WlZFMk4wN3hsbkNIOEtDYUJndEhCLzhINWNpVlExYWttdFFxOCtla3pRZFNK?=
 =?utf-8?B?NlFhNS9lZEFuR3V2R3JFWlA1Z1dwdG5qek16TnVPV0JaSGg1T3JFQXZjV0ZM?=
 =?utf-8?B?em5hTWdFME1oSXhqQis3YkkwTm8vdndwUjF1WHl5a2p2MTFzcTh1UHU4WWhk?=
 =?utf-8?B?WnJ3bXV1MUxXWDVyTU1yN2p0Y01oY0t4QnZzZC8xemhkZUEyNG41NzQxNlhI?=
 =?utf-8?B?TFovU1RmYU5HN2FOMnVXemJjaUZDYklrdmRMM0xNZ1VRdTNDUldJTlk0aDhL?=
 =?utf-8?B?d3VYNFR6djVheUNxMWVLSnJnMnpRVnVrK3F3Rmt5ei8vSGxGZVhibGJKYmZI?=
 =?utf-8?B?NUVmeFhrdTFnb0ZRZkFoZEZhd05CQjFzYkF0V0RJYnE2ZDl0SS9WK216WmJi?=
 =?utf-8?B?TXMxM1VIUFpMVFdFcXM5SXFwM2M3K1VSenpSTVplTXYyT2tGeXRvY1oyalZi?=
 =?utf-8?B?aDhXZmQ1anRGd3RrT2d1ekEwR3hHMU9wR3lrR1JMVGtBR2JZaWdJeTBPSDlW?=
 =?utf-8?B?TGxIZ1E1NU8yMCsvSi9Mc1Q2TnJjdDNFczBSR3BuT1Baa0x5eWhmTWZnaWti?=
 =?utf-8?B?VG5PRDZtVzdVek5mWFg2cjNLVXNrenQyejhYaWM3V2xITXJJWmVVS1l0R25Q?=
 =?utf-8?B?NzJUV2VlRzRuT3RWeWdzR0kwOEdGS3hCZ2wraU1PcDlkdG40MjFrQjJxa0Rm?=
 =?utf-8?B?WUxmMjkvMjlLS0hpeFB2Rnd4b2VhMGtXcVlrSFY5TXRNUWpqcnRmZG9COEhY?=
 =?utf-8?B?MjFpUTJXUndtYUNDeG5vSmhEUXErQm5PTDVUdGdQUmZoNnF3bjA3L1FGbXZI?=
 =?utf-8?B?b1R5bnk5dWVqcUpXM1pRTVlxSC94dnpkVXFhR0xtTXVFa01JSGsyMzJmK1dp?=
 =?utf-8?B?cEFHdVkyOXdYTkI5Z1p0UmNrQ1dpZnhtQWVJUE5aOU83TXJNVEhDQ1k4RXVt?=
 =?utf-8?B?cU9KZGZncTlDYXBTaTZlYm83aHplWmxka0I1ZWwyd0hQT25leW45THhFSWNM?=
 =?utf-8?B?NE1wZ3hOYjF6TFhwT3BYR2hBSGVmT2JUdWliTHRUcWZLakJTTzFrMTZFM1N2?=
 =?utf-8?B?aUFsWHNGV3M0T2VtejYxcHROS0lLa2JLaW01MnV0RE9DVGd3Zk90UmdFbHI0?=
 =?utf-8?B?VjE1b2MrV0Y2TTBlZFRtVGp1bm1tdzlvN3lUS1RjOWUyaGFITklzTUU5L1Ux?=
 =?utf-8?B?MjZkU3g3NnBlQml0YWpjNHFQZ2tETXlnQVIybjB0VGFwWjY1OExYbW9ZL3B3?=
 =?utf-8?B?SEk5bDFPeE55Z1YwdktzY3d1WmV1NkRyNlAvcThJbkhrTHk5aHN3MTczbXdz?=
 =?utf-8?B?cUtaZ0pxWnRXeDIyak1jQzNyZElmeUFVN1dSY3cyUXF6VWNiUFpCektTRDNt?=
 =?utf-8?B?WitjRGVPM0E4dEdWRHMxck9CanhERExGRmVyZG95WnFCeTdyNTlWdEN1dWFW?=
 =?utf-8?B?NXhJMWFVNVlESzZTYlFrY0RES2tObzVaNFNvZEtXL0JQWllZYURTQ0k5UmtH?=
 =?utf-8?B?UlczTDBpU2JROUpkTFBYVDgzT2xwcnRTTFNMTWQrVGYxcUlYZzhsVWEyTWtr?=
 =?utf-8?B?UGtVWkxnRzFwRjFjZ0IxRWFSZk1wVXhvQjZqTzJmVkx0K096OFR0bXY3eUhZ?=
 =?utf-8?B?VFk4UTRML3FhUU5lNENVL0ZHWHNicUpVd1g5N0labnk5SGJWQUdLZW9OYzNz?=
 =?utf-8?B?YXorSTdyaEJMYVVEUEN2eEg0QjVwQ1VIZFVGNkV3czA2OTZyd1JPOHZSWnU3?=
 =?utf-8?B?VGhrZTZiWElVL0ltS3hTc2pWbjRRZlRBQlNsa1NndHoza0JSV1JodGtXc3or?=
 =?utf-8?B?RDZOaTlRMjBjcXJYbWlzaGZRRXVvQ20rSDg2bFZlYkI5c0dOTFhtYXlzY0FV?=
 =?utf-8?B?MTJib1RmODhlek55OHZ0ZWgwa2JteW40aWxyYXhoUkRsRW1nNDdKQ0RzSXc5?=
 =?utf-8?B?REFRTlpqcU5RPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YW10R1lZWHlhcW5BanhYRU01UUZGMDdwVU9LRWw4WXZIc1pKQ0tQUTFTYzBv?=
 =?utf-8?B?YndFUjhaSWV3V0dQWUQ4RUNuV08ra0txWlVoSExxUE13VE5IS1Jmd0NCWWRl?=
 =?utf-8?B?VWd0SWZ1b1BKdUs1cXM1TGlHVHliQkJ5VHJQSDlOZlNqdzZPNDZVdS9kWGNs?=
 =?utf-8?B?aGNlR2kxSTVWb1Q4b3B4bkZzVzdZV2RnVHZVa3R6amV4aDhtaXhMSTBGOWNI?=
 =?utf-8?B?TC9NTHZ5bXFSVXNCRk9RSXJseFFoU3IxWm1hZm8yQURvSVJMTXBFZldscWtU?=
 =?utf-8?B?VkI5U2I0bm9iZ3E3c2Z4UTV4Ym9FRFJUWnJCN21PZ245MTJ6M0VFNWw5YU5Y?=
 =?utf-8?B?YUpLeGQ2SUxrTERpM3JJd2pYcWxScTNhNytYVzNUMGRMWWFPLytSY0tFT2ll?=
 =?utf-8?B?dEE3WUNJeXZxbUxqQ0V3eUhTamk3WXMwbmV0aVZZSzNXMUJBRkdTZ0xvU2tr?=
 =?utf-8?B?Yjg5TnRJNlU0b2k1U0xlblN1ZG8wUHhXMnNYWDBjbUFBc1dIbEw4eDNBb2tM?=
 =?utf-8?B?bXg5aUZrY2dyWVpwUEFQcUZRVzdScHJ5ak4vZWZLajVCN3NIL1ZDVnFCSlZq?=
 =?utf-8?B?N2NrWlJFSXZ2Uyt6eW1oWHNNYlZkZVBnWGpEOVhXbGdFSm9oZkFMbkZDaFo1?=
 =?utf-8?B?N0VqVm9IWHI5enMwMW9KWEdJWjBCUkFzWklZYUZaM09KdE5jZ2U3TlVVdkln?=
 =?utf-8?B?S2F2L0FUTFg0ekI5Q0lpSmRCYitaTGFDZmRIZWhxajUxK2llNVorRXVRa0FT?=
 =?utf-8?B?YTZDK1NpT2wyNjNOamg0TmM1dUhseTh4aXZnNG1FbjRhWWtkT0JWNlhvWUJu?=
 =?utf-8?B?cjdtU3J0NVVUU0lsVmRJczRnZy9tcHJXYnpQMXF1ODM0M2dmeDNzbiswK3F6?=
 =?utf-8?B?QlJGbEViWHNyRC9KK2U2NXVqK3psT29TM25kZDk3VFdEaHcrVEwzbmcxWjM1?=
 =?utf-8?B?VVIxUTNtOFBYc1NaaThlT0Z0S2tta1UycDB6ZXBNMlp3SEIvcTN2YWRGZnRo?=
 =?utf-8?B?cUVCNEVKZkMrRVJqdjNBM0xvQURyVXUxVTY5QklUSUtQY0dNcThlTWRmbnJs?=
 =?utf-8?B?VnBjcnpmVHFZYTBBdW1nWTlNQm91NUFaNkJlQkZHWDZlNGZtYmE1RUVkbVlX?=
 =?utf-8?B?S09xaSsxS3NWYVFFZk5UNGFDMElxalhrZUYydzhGdWhlQ05PUEsrNWtyK0k4?=
 =?utf-8?B?a3RkK3VCc2RmSDJjVFlCODZ0WVg0dkZ0akZDMnBxT2xHaXZDWjZkTW4rblVV?=
 =?utf-8?B?WCtLZWxqczFsSlZRaTcyUVRZM1FVZUtXOXZULzVGbzZtYmFLQ29zdFMvNFlv?=
 =?utf-8?B?SjhUc21ZMEUrSlE5bkJ6OUkvRkdTbXlhcmJyK3ZUai9PSHV5Z1RmVnkvZ3Uw?=
 =?utf-8?B?ZXNlSWFmTnRqM3BmOE1SMDF0djNHV0p6MmNwTE8yQUtSUUE2djMwTFBwZnBz?=
 =?utf-8?B?VENzQ01MKzczcUhEcEp0OVFFWVltVzZpSGRFc2xwWDd0NE1QTVRXWmlXZm9S?=
 =?utf-8?B?OEdndWx1eEVwcGtUbW5NTkE2ZnNqd2RkZGVuWEpiOUZjRHptZTJ0TVBTa05r?=
 =?utf-8?B?dTB4N2tScFdqNWs0aVFqQ2Yya1ZHdjVDellqNzlDd1k5MHB6Wi9NRVBOc29S?=
 =?utf-8?B?STRJSGhyVHBrMlRraUR6Wnc5bG1TN0hSdGtHaUVxcFkra0w5ckNrb1BQYkdk?=
 =?utf-8?B?dGtXMEJkaHhGWHpjaWdISTBOMnVzYTl6ZUFOcXE5WDFYWU9vanZHU2ZDYlpT?=
 =?utf-8?B?Ylo3OG9ObjJwTTJldENmcHhYV2JOTVBCT2hsenZkMU90ZWlOT3JCSGo1RFU5?=
 =?utf-8?B?clN2UkpaS3NNNWM1QlhmdjhuenRsQ1Vkemw2cFczMXRXWWVHZFY3bHU1dU1D?=
 =?utf-8?B?YkFFWWNuaHVucTZTdmgvRW5IM1luRGhLQnhiNytya2NhL0RGdVV3bXNKUit4?=
 =?utf-8?B?REMzaGZiTXovWVFPR2pZWGRNR3J6dGRTR3pBUDlHN2ZXc1FabElFaEFPV1N1?=
 =?utf-8?B?U2Rqd0lXSGtvOUdpMFo2eE4yaDB4TW91b1p5QzNyVThjSXRSeFdCQWQ2WGtU?=
 =?utf-8?B?bDFqVjFLYjFkbEVjV1RocWFxT2ZqZHhmUkdVVnNSc1hNdkdIYnU2eWpmTHF6?=
 =?utf-8?Q?0NV3xaoywEIi0+Tb1vChBG5Bw?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <538CA41FED54B1499A0C35E79668168D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afe5630e-7f9d-4ff8-f222-08dde5c3b799
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2025 23:44:51.7619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NN8GzfVA1gD4rdoACOuFlnJgfEkFVjQyHk0FHc0BYMquFQNb4+fLN+hH3x1C9kmAVYbkdcxo8DhBAFgvJkeRUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4874
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA4LTI1IGF0IDE1OjIwICswMDAwLCBOaWt1bmogQSBEYWRoYW5pYSB3cm90
ZToNCj4gKwlpZiAocG1sKSB7DQo+ICsJCXN2bS0+cG1sX3BhZ2UgPSBzbnBfc2FmZV9hbGxvY19w
YWdlKCk7DQo+ICsJCWlmICghc3ZtLT5wbWxfcGFnZSkNCj4gKwkJCWdvdG8gZXJyb3JfZnJlZV92
bXNhX3BhZ2U7DQo+ICsJfQ0KDQpJIGRpZG4ndCBzZWUgdGhpcyB5ZXN0ZXJkYXkuICBJcyBpdCBt
YW5kYXRvcnkgZm9yIEFNRCBQTUwgdG8gdXNlDQpzbnBfc2FmZV9hbGxvY19wYWdlKCkgdG8gYWxs
b2NhdGUgdGhlIFBNTCBidWZmZXIsIG9yIHdlIGNhbiBhbHNvIHVzZQ0Kbm9ybWFsIHBhZ2UgYWxs
b2NhdGlvbiBBUEk/DQoNClZNWCBQTUwganVzdCB1c2VzIGFsbG9jX3BhZ2VzKCkuICBJIHdhcyB0
aGlua2luZyB0aGUgcGFnZSBhbGxvY2F0aW9uL2ZyZWUNCmNvZGUgY291bGQgYmUgbW92ZWQgdG8g
eDg2IGNvbW1vbiBhcyBzaGFyZWQgY29kZSB0b28uDQo=

