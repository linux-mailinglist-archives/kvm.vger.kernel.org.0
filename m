Return-Path: <kvm+bounces-15750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 110C38AFF96
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 05:26:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28FA11C22107
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 03:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E7213A269;
	Wed, 24 Apr 2024 03:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fqf/AKuL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D6185C46;
	Wed, 24 Apr 2024 03:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929151; cv=fail; b=CAwHuUrqS8MAYjNBW4fmzxVFOeEMtZ3qRhTadugOQSoxZTAU53zNRMGVovR1cebX1acnG9Bafv6zbu+RGCNOuyPPsV9C7kk1J+aRC/7BwCC6lzz6GnXBN162wFjC99ropNUuour/HKAK8c9urWLPbiHmK00xfsmP+wmxG3XC3lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929151; c=relaxed/simple;
	bh=4UG4rQx2JOcAlv+tqKwGz8M1s/6BKBPwWTyjeAWEqEQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tgN6v+nMHn98o7xxiBILVQ8fMX9pxBwyvfKleoGNpinl/Yap2hbN9Q8vPeoEtZ2qJbuK/w6npKg3LYYfHTVWYT7tdL9nxF98rIG5kD37xjnOdQEj3SgJdXlo7PZ6SyV6H6krDCV1+MJEalj+NArGATyRhchjODdcPEEF678weYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fqf/AKuL; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713929149; x=1745465149;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4UG4rQx2JOcAlv+tqKwGz8M1s/6BKBPwWTyjeAWEqEQ=;
  b=Fqf/AKuLYgT01Csq/P93UI3GZTcIYnN1nsrOiFVpRrH2rGC4qxkik378
   KTU/4DcqnGxH+bAKahqV9e638mDSI5QDhS9wh4XJ0mLZetvYRAkV+slho
   G+bd2/Bf0JAWiUcJvj4BvqtC4bJBuSE9P+sYQwMBn01rQOsCYDPJAYZuv
   FquGF+f14anCeY8gkb4dUkJY7pMlLrgvBuWt9HM51fV17lvxriCKXYOkq
   26HrhcjrPV4afm2lMtdJBrFEiRMn7vJW+8xd7VJtXrUS10cx/sXgUoE9E
   doR73YSxB4tqLXLRHfg1b5DJZt9cEvKmmWaH26qlfGtEapQ2Q5MptihPh
   A==;
X-CSE-ConnectionGUID: t26I8q22TDe4IepyBvd4Xw==
X-CSE-MsgGUID: 0meVMxMGRjqTzow/Bj/yBA==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="13330349"
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="13330349"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 20:25:48 -0700
X-CSE-ConnectionGUID: 8LW5/cfcRyK/rYSCYRRDkg==
X-CSE-MsgGUID: EMqYRkf6Rei/SdCWqoeT5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="24632516"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Apr 2024 20:25:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 20:25:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 20:25:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Apr 2024 20:25:47 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 20:25:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jxp2Q4u7fEexifOUlXFR9oNBq6WFOIPZldunNuPZL2cKOdV6RWuqu3LJnhObxvffQX7Go8SKQv3weCCFPm9od0KbiYe3VeUBoT0I6yeG/lQcUi1zlw+TgtKm5G8w1QYOuSf6ze2bRr/wBx9P9c/ewAZ3+7rJYiahD6wVreZLHy2TdZMcU6wlVq1RL4rNXl9L+81HJDAbqoQwBJ29w936LDSE0LsdMULHdEfDMqwt22m+73PS6x4gbVXBeUb0lyoG1xl7UgQTYpoNNKmxtPF+AlCOBBC3PlQ7RCQHY2A4CwemGp+7YqV2o9H0T44puNTCXczYzQsOaVp6RJ54b+Nb/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UG4rQx2JOcAlv+tqKwGz8M1s/6BKBPwWTyjeAWEqEQ=;
 b=jonrjFqo2Q8M5OPfT4F8DDyBzR7mGe0xHiTR8el9rzW2xSHyudI+8mmc5qGT4lUpBlMgsXdalwjWc1QfnFDQ5qJ7WYwBjcEK/jA/noRCqsqOdjnzxeq6izlqUJqovOID5IbA9MNqiE5nBvrY+xslJEfZUnoMLniMOYRCmzHFqqC6Y2kYu3Ka5pHB4EWoMWNlu53irVCSFFTfSOQW+sCFuGtxM164lLVuTWMvgiEH4iI/VugeZtQ0k3xDF/d0uRim3Y2KRlX1QaqzcxAF4Tanu1SB63GrZUIDt2WtvLWMQo2RPa5aJQKzhye85r4rmscFIjKGKYN1lY6bBa5Iw7jV6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7762.namprd11.prod.outlook.com (2603:10b6:610:151::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21; Wed, 24 Apr
 2024 03:25:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 03:25:45 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: x86: Explicitly zero kvm_caps during vendor
 module load
Thread-Topic: [PATCH 3/3] KVM: x86: Explicitly zero kvm_caps during vendor
 module load
Thread-Index: AQHalZ7v1+lFvpoeBUe2ws/CuIZWqrF2wu+A
Date: Wed, 24 Apr 2024 03:25:45 +0000
Message-ID: <8e3ad8fa55a26d8726ef0b68e40f59cbcdac1f6c.camel@intel.com>
References: <20240423165328.2853870-1-seanjc@google.com>
	 <20240423165328.2853870-4-seanjc@google.com>
In-Reply-To: <20240423165328.2853870-4-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7762:EE_
x-ms-office365-filtering-correlation-id: 920a9d81-209f-49a5-315b-08dc640e3aa6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?SnpFclVnclRIUTJGc1R0WFAzakdmTnp6US94ZTVOOW1oTDZQWkdZRUhOVzZr?=
 =?utf-8?B?QlpNSG5ybi92UGlLZjhHWmZVbEZJT2tCbzRHWUFLbXhYTE1GVllZM1JJRFZl?=
 =?utf-8?B?TjFFRExDa0xETC96YTBHZFFJTU9PTHhGRHZPdVFldGQ5Q1JsaDhPME1SMUdJ?=
 =?utf-8?B?aTVFT1ZGb3B1R2R1K3lJdlROc3kvaXFiR2hDdTZibjk5aGxBVTZHNWRJb0gw?=
 =?utf-8?B?d2VOT0VWZHZ0UlRPYzdDRlVuU3dVcXAyVjJZOEc1b3p1bE9URFhsbFdtUVpv?=
 =?utf-8?B?L2RzUmdiUStnT3VSYVhzRkNienpJT2tTUUhUa3ZmOEZvcE5iSkdiQ2YvTS9C?=
 =?utf-8?B?UkRLWUpPRnRibVFtRks1WXhuYkxvNlRKRnAvU0RCVkx1N2dKKzh1b0ljYmJE?=
 =?utf-8?B?RklWaTFrMGpEODE5aS9icUJycWQyTkY1azAxZDN6Z3g2VUMydGtKbmwza093?=
 =?utf-8?B?S1VMclpvUWM3cFUwS0JEV1JJdW9sM2pjbTNReUxORC8yVGdrbEsyVmMzRDBp?=
 =?utf-8?B?dHBDa3B0QUpyZiswVDNwTDJlS1RZT0RDYmNGczBDUFdKUkRoT1UrOXV4TFlY?=
 =?utf-8?B?WC9taEZEN2lyMTRtaGlsT3NzeGluSmpJbWpzN1lOanF3SXYxUHcwMHpLcnlh?=
 =?utf-8?B?M3VtRHVOUm14MTVEcWtBOWVpdkFVRUx3SWdXeVlLWEcyUmw1NkwrVS8wWHJa?=
 =?utf-8?B?dlVLUXk5eWU4cW5sV0xXallhcjBFL1FJYkY1aVZTQ2djKzdmbFBQOWw2VmVU?=
 =?utf-8?B?bklUS0hPSXR1UzhSK1p4RksvQ2hhaFBFUGQ4NHUxcVJ1aGcwYjNlQ0tNV0wx?=
 =?utf-8?B?ZUZpV3hQTjNXbndxMzBZZjJLZGtxUDU3YUJqMlJuOFJSR1FxQzhSWlFKVWgw?=
 =?utf-8?B?QjFJRVkxT0Z2azB1ME9GZ0U5SlVkQitOSDFSTnpaNEVrS1h2ckRrVGs1OE85?=
 =?utf-8?B?K0FuVURFMWhDSkN1c0dFQWNzZEZ0VTV6Qjc2OTRsaXUrVXdIT3NYRTRhdHFW?=
 =?utf-8?B?aWJhU3M5UURSeGl3TXg4WkVnNkVrNGxnaHlVbjg0VU5oY2k2WFpYVlVuQlBs?=
 =?utf-8?B?RzladFB1VzRPY1ViVDZiZmVES0p2TFhjL1cyYVduTUVCM1FjWDJkbHdZMEc5?=
 =?utf-8?B?RkRSc3p0YURETjJpWExXVW5UVjQrWWpyNGUyMDF5T2Jma1paVWtkeW5TSWVX?=
 =?utf-8?B?QmlTKyszUmRjTHlqN0Y5bkRweTNYR2tnWWpsZnZCdjMyRUdhU1JNWWxRUVo2?=
 =?utf-8?B?RFJveFVUSStDaGJ0Y3VCSUU0U2JjTG5lK3hJeTlyckx0QjhGL3pJZTdrZDdE?=
 =?utf-8?B?YXlESnRHYWJsSmhDUVVFSmlYdWJBTytBM2FUWDUrR2Fzb2REdytZajFnM0lD?=
 =?utf-8?B?eDhtUmVCRittQjB3K0FhNFFLUXMrKzFvR2JJR1FFWkNtVThCRWtGQ3kvY0l4?=
 =?utf-8?B?eEtLeVdNUzhwVUpndXhNNDdENDdidDQxUnY1OEZBT1A4U3B3MVlYNENmd3Mv?=
 =?utf-8?B?R2h6emZkTXVObmwzYnJEcGZhT0l0eGlDOW5aaGZwRDFsbFB1V0RJZEt4Qkg1?=
 =?utf-8?B?cFpXV3RqajNNVThILytQTkxlckFKK2l6b0JBVnpQMlRzb1FlVTdyNzlWbGNI?=
 =?utf-8?B?QXFIT1V0NnRrSmVNRk4vK3lCU3ozMkpnWndnWUE3bEs0dk9aL0lpcHczbmdX?=
 =?utf-8?B?dUU4ZU1hdHNianRIaEx5NWdIdU9oSk9DY2o1SkczRzdDWmdmNUxiaE5hbm1H?=
 =?utf-8?B?NkFSM2pzUEtpckcrVnVCNXZCb0JBbmR0aTNxTHowSmMzL3ZWS1R4anVtN2VE?=
 =?utf-8?B?WlJ2Mm1BYjdLWFZvTEVsdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TE1IZEptOUdZSGY1R2FKMmFJaFVyQVBsdzJrS2haZUdENU44c0xvTWQ0SFBT?=
 =?utf-8?B?cEd3UW82VWlmM0hWMStjSUJtZnBMMmsvRkRWdHA1SGk4NzBxOEFCbnp4ZkRF?=
 =?utf-8?B?UGlZRHREN242cGRXakhuZUFPSG1ITHlDVTJaVWJ5MDJuOWdsanJQKzlrZzhm?=
 =?utf-8?B?WlRaL29EYnV6MzNjQXpOMm90NW90WFR4Yll6RUs2VExkR1V2Mm9NOUlDc0Jz?=
 =?utf-8?B?bVhpSnppS01mV2JxUUUvZjNwUE9yaFF3aEYxL25DVVVUQkhiVHhOWVRUZTho?=
 =?utf-8?B?dFBPSjVnV0VmTHlsVUNYejEzY1NjT3h6bmRQMjZxc3VRODY1TXltanlkYUgv?=
 =?utf-8?B?engwSXpGTDRCMmQxeVhGcXdRM0pBVDNFa1M5K1dPbmtScS9wWEJsUndmSjlk?=
 =?utf-8?B?T0ZOYXdnNzVEUU9SOUtGemxtOGdLb00vQVJzb0hHdUcvQUk3VWV2cGhYb3hv?=
 =?utf-8?B?cno2ZitRT3Q5bGU2RE1CVnl1SktqWVd0TFVhZXpBeVgyY002QTRwOUk4YmQw?=
 =?utf-8?B?Ly9aZlF4K2FjQW53WVREZmlVdnU4OWtPQVBVaGpTTENuaCtSanNmbUM1dzZF?=
 =?utf-8?B?clBjSDlmSkxDR0k5OEI5dHBaaWJzWWkzYTdnT1ZJd0ZTQ3lKRm5vb1JZekVS?=
 =?utf-8?B?UVF5MlFuS1J5a2RhL3R3Z2l0M3hxNGU2K1h2ZWswdTZGU0U3a2FzLzBwaGtZ?=
 =?utf-8?B?eStNTUluM25sc2ZWcjZPR1BTUmhyN1ZyeEd2NUNzUlFpaU1WUVBNV3M4Z3B1?=
 =?utf-8?B?SllSRkFuYUQxTEpIVkdWK1lCR1ZUd0NhSjNPTzBzQXJxb1NnalJSNkJWRVZl?=
 =?utf-8?B?N2pUR25NTC93NzQyODJMR29VNTRjWUpkMXFtR3lHMWVvb2RZdWNOMHlVb3JU?=
 =?utf-8?B?SGcvc3hZVmJDa3MydGhubkFJL1U4MDVtN0wrekJoNUdmYy9sUUI4ZENtMDRs?=
 =?utf-8?B?L2RaZjNhQUQrSGpiNDN0WnBQWnZWcS83VElyMXRNTzZDRzc2eXVVMGE5UFV2?=
 =?utf-8?B?RzJwT3hnb2taNE9LRW9saVFZblIzOHd5a0FGNXErdW52dnRaTUsrb1JTR0Yw?=
 =?utf-8?B?VW5heHhsVTRPRWRDdUlyTHJkWVJmM29RY0NZMDZGWTZoaHVqNDBYNW9ORU1p?=
 =?utf-8?B?alhWMkYxOUZqNFI5alMzUWI5dXRPOWx5VnhIQzVaZkhhZFB6K3M4SjRUMWNl?=
 =?utf-8?B?ei9DbUN6bjllN1ZhMzZMV3F1U0pyZ1RlWHlZU2hkS3l4U1V6MjdNaUdiUUhj?=
 =?utf-8?B?NTdzN3liMnlkL1R2L3c1bGFHUWNqblRYNHdlZ0NmUmo2ZFBMU211M1c3THNI?=
 =?utf-8?B?WmZSZUVVdHlnelFjZEtKZUpSUjZzbTdBWXJKWlZJVTJzcllsU1kyNW1vYTlO?=
 =?utf-8?B?ekt6b0NoeldYNVN3aFN6SW9KUVdEOHJtaWZhOWFPT2FibTdPRDhhWlZ6UkNv?=
 =?utf-8?B?RHRxdFB3Y1ZtUXN3eWRuNWZPanhLdmZZWGJZYUdUeFFFMkZwYVc5Z2h2eEkv?=
 =?utf-8?B?U0M3aURSNWExdWRIcXNsK1VWdFB4UzBtTUh5WGNQZ0JKNk1oTVVqN3liRmh3?=
 =?utf-8?B?WFo0MTc2ak10L3htUWR1c0tXQnNmUUVsR3NQM1FGYW1lZVdlYU5ZZWJUYXpq?=
 =?utf-8?B?dk1jam5kYmJiZjJjSHp1bzkxeGRMUUovL1NlcVdpVlFVL1RrNjk3QWU0RmhL?=
 =?utf-8?B?VDlaUGhCMFluVFJTQ2phbU5mbWkyS0IvTGJwcFNjTWh6ZGI0dDZrUzNLQUta?=
 =?utf-8?B?eGRzZzI3ME1XNnlhc3FsV05SMjJEQ3c4NEZrazkxdjQzMU5yUzlLN0YycG9Z?=
 =?utf-8?B?Ri9zQm92b2lMcmN3VEtWNVlTL2RtcThVV29rT0IzOWVHbzNoT1BrS092NjVI?=
 =?utf-8?B?QmhUUUtyanlvMHFyeWE5aU8wVE1YWHJCOFp0dlNJcEpUQlRxTHRrU0tSbUdX?=
 =?utf-8?B?VVE4dE9PTVJnRHVRNm9yZWs2QVdCdzloLzVZMFVtT1pTNEEyWTVmYkk5YnBt?=
 =?utf-8?B?K3M2ZmpBMy9KRnhhY24zMG1tTWFxSFoxSGpaWU81U2hveHdIcTBSVGtpcnlE?=
 =?utf-8?B?dFpScmFQRGh1QjNxKytWUWU4YlV5OEZxY0R2bVNYS3hyeE55aEx0dzN1VUp3?=
 =?utf-8?B?ZFJvZFZRbjhkTGNiYjRRbkMzSEk1WCs1NXJ5aGttTmZKdjJOUmpma0crWThD?=
 =?utf-8?B?NEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E8FD52A20E3124A9DAFB07977F11764@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 920a9d81-209f-49a5-315b-08dc640e3aa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2024 03:25:45.5796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TWrPqIuI+Ti5hSl3J0ASzMRr5Aq4ESDhAjciuCK3o5pXwjq1MxfOhUoBtXFYvoOL/p3mSUJ2UQ2NRMLD0X7mhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7762
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA0LTIzIGF0IDA5OjUzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBaZXJvIG91dCBhbGwgb2Yga3ZtX2NhcHMgd2hlbiBsb2FkaW5nIGEgbmV3IHZlbmRv
ciBtb2R1bGUgdG8gZW5zdXJlIHRoYXQNCj4gS1ZNIGNhbid0IGluYWR2ZXJ0ZW50bHkgcmVseSBv
biBnbG9iYWwgaW5pdGlhbGl6YXRpb24gb2YgYSBmaWVsZCwgYW5kIGFkZA0KPiBhIGNvbW1lbnQg
YWJvdmUgdGhlIGRlZmluaXRpb24gb2Yga3ZtX2NhcHMgdG8gY2FsbCBvdXQgdGhhdCBhbGwgZmll
bGRzDQo+IG5lZWRzIHRvIGJlIGV4cGxpY2l0bHkgY29tcHV0ZWQgZHVyaW5nIHZlbmRvciBtb2R1
bGUgbG9hZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5q
Y0Bnb29nbGUuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2t2bS94ODYuYyB8IDcgKysrKysrKw0K
PiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Fy
Y2gveDg2L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYw0KPiBpbmRleCA0NGNlMTg3YmFk
ODkuLjhmMzk3OWQ1ZmM4MCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jDQo+ICsr
KyBiL2FyY2gveDg2L2t2bS94ODYuYw0KPiBAQCAtOTIsNiArOTIsMTEgQEANCj4gICNkZWZpbmUg
TUFYX0lPX01TUlMgMjU2DQo+ICAjZGVmaW5lIEtWTV9NQVhfTUNFX0JBTktTIDMyDQo+ICANCj4g
Ky8qDQo+ICsgKiBOb3RlLCBrdm1fY2FwcyBmaWVsZHMgc2hvdWxkICpuZXZlciogaGF2ZSBkZWZh
dWx0IHZhbHVlcywgYWxsIGZpZWxkcyBtdXN0IGJlDQo+ICsgKiByZWNvbXB1dGVkIGZyb20gc2Ny
YXRjaCBkdXJpbmcgdmVuZG9yIG1vZHVsZSBsb2FkLCBlLmcuIHRvIGFjY291bnQgZm9yIGENCj4g
KyAqIHZlbmRvciBtb2R1bGUgYmVpbmcgcmVsb2FkZWQgd2l0aCBkaWZmZXJlbnQgbW9kdWxlIHBh
cmFtZXRlcnMuDQo+ICsgKi8NCj4gIHN0cnVjdCBrdm1fY2FwcyBrdm1fY2FwcyBfX3JlYWRfbW9z
dGx5Ow0KPiAgRVhQT1JUX1NZTUJPTF9HUEwoa3ZtX2NhcHMpOw0KPiAgDQo+IEBAIC05NzU1LDYg
Kzk3NjAsOCBAQCBpbnQga3ZtX3g4Nl92ZW5kb3JfaW5pdChzdHJ1Y3Qga3ZtX3g4Nl9pbml0X29w
cyAqb3BzKQ0KPiAgCQlyZXR1cm4gLUVJTzsNCj4gIAl9DQo+ICANCj4gKwltZW1zZXQoJmt2bV9j
YXBzLCAwLCBzaXplb2Yoa3ZtX2NhcHMpKTsNCj4gKw0KPiAgCXg4Nl9lbXVsYXRvcl9jYWNoZSA9
IGt2bV9hbGxvY19lbXVsYXRvcl9jYWNoZSgpOw0KPiAgCWlmICgheDg2X2VtdWxhdG9yX2NhY2hl
KSB7DQo+ICAJCXByX2VycigiZmFpbGVkIHRvIGFsbG9jYXRlIGNhY2hlIGZvciB4ODYgZW11bGF0
b3JcbiIpOw0KDQpXaHkgZG8gdGhlIG1lbXNldCgpIGhlcmUgcGFydGljdWxhcmx5Pw0KDQpJc24n
dCBpdCBiZXR0ZXIgdG8gcHV0IC4uLg0KDQoJbWVtc2V0KCZrdm1fY2FwcywgMCwgc2l6ZW9mKGt2
bV9jYXBzKSk7DQoJa3ZtX2NhcHMuc3VwcG9ydGVkX3ZtX3R5cGVzID0gQklUKEtWTV9YODZfREVG
QVVMVF9WTSk7DQoJa3ZtX2NhcHMuc3VwcG9ydGVkX21jZV9jYXAgPSBNQ0dfQ1RMX1AgfCBNQ0df
U0VSX1A7DQoNCi4uLiB0b2dldGhlciBzbyBpdCBjYW4gYmUgZWFzaWx5IHNlZW4/DQoNCldlIGNh
biBldmVuIGhhdmUgYSBoZWxwZXIgdG8gZG8gYWJvdmUgdG8gInJlc2V0IGt2bV9jYXBzIHRvIGRl
ZmF1bHQNCnZhbHVlcyIgSSB0aGluay4NCg0KDQo=

