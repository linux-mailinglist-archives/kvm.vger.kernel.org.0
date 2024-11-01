Return-Path: <kvm+bounces-30321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F42B9B94E3
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 17:04:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A29B51C219B6
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 16:04:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10DC01C82F1;
	Fri,  1 Nov 2024 16:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IYbwXee8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8A981ACA;
	Fri,  1 Nov 2024 16:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730477049; cv=fail; b=mbPI77EUEp+YHqeXEC8AEcRd0mTEwS4EsbcvQUCewIlvzISh2/gxsvEvi7P6LbwLW59Rw6ZWMgm0uCjVcOt7Sl9/INY0wxm8tF/4Jc/YByakH5xSv/rPV2/RSrWvnD/6IjkxZmGKPOyjJTE6HofrGNl/ru9MpBswbE/RTV1zBVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730477049; c=relaxed/simple;
	bh=MwIdL0knCC6X4PoY6h7Wie/GHWL2pidZkujL8vAOh0w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l1T6OCUXxKb/SJ+PyM8OBzkRkPbWyWBCZCbdDBWYgV6KbaL1puQzLDX9KuTBt5imiqc9JA4Do3uKBqBvKcy/oSo84kaTmdSkGiIB9aoBumHQcdmE5F27WuTqLzgyfYknoqZz+fC8tzw+fdb56MqG+dXR9UZMfV5d/RocdbQz66I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IYbwXee8; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730477047; x=1762013047;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MwIdL0knCC6X4PoY6h7Wie/GHWL2pidZkujL8vAOh0w=;
  b=IYbwXee8UtBMNCF83JsDtF1coPZ1kRVcQXXjlGK7EXj0dI2mw2It5Nav
   7OnBPmmu7nYzsQxRBD4pjLoJr7vAWd9deTOqfwcoklwCEAlyIkHXsr1r4
   C6iCipMQQGx4xfkahDoewvjgoZJb/BS7i2OqStMAwS5/Gfu+mv6Q3IjYc
   6YJA7fMun2yEpHg1vLEPWPgZbSWpBMU+6SxM7y2zPtOYo8eHnnEy8vxSc
   lSXwtrEk/Vr7QJtt6scxtG3RJtfYDnqAyZSGUWArlvZPi7YdBMBC8YwYm
   0PW4WCBHZLcnVsObS4cM/5Walxl4a3HJSfSSucx3uSr8P7bPUotNoMLiT
   g==;
X-CSE-ConnectionGUID: Dv2qMQD7T66gOcd2FgVy9w==
X-CSE-MsgGUID: gKIZ33GhRDG2vbAzxTtvig==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30011620"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30011620"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 09:04:05 -0700
X-CSE-ConnectionGUID: L7TM8ymbQaeudqsPnkonwA==
X-CSE-MsgGUID: wN+5r8u3S66jE5RND7g7fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,250,1725346800"; 
   d="scan'208";a="120461946"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Nov 2024 09:04:03 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 1 Nov 2024 09:03:55 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 1 Nov 2024 09:03:55 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 1 Nov 2024 09:03:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hi0VD8qZeymb/ULv95L5XHGRBCEm84tBZGvjonYqAIngMq3glV1OzYBvSYQM38WfZ3m6pqF0eBIlnkRtq43gSqTeFqVoDsNmnHsFOg7hsOg/mYuCCFGpfVcx5u+F6oGHDNdcOfVsSPXl4KTcTPUWBf9mGJ9kjPBjv2zZXreSNobjAdwgJPoo1BJptxLbZl65WCVsi6vUBe5CuBzk31HizaRX3AO4KbTbw0o7aoeVbOFOL+ZBztM+SC6kvMGZx13q8dCGNpS30ScXXNtZGlcABJSQmAtNbh927DHLeVWWvl06s2ZnSAFHvbmYAL/DsgDiDRMEpdGLZ9yApHpcsluyjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MwIdL0knCC6X4PoY6h7Wie/GHWL2pidZkujL8vAOh0w=;
 b=r8Q5MLEAr8LtKzilqTL13tlsaRILoLzb04rXXWyEZAHUfQJghhEyHdmbYpU6YihuJBMo14zZgaK4Tp7Cq/Dnm8fLiLjqqOxQyMQFQyXxUtI7jaIhIueOzlIMg6+U/AQe1qjCnnp7vEGiBrHYhZa68pA+jqk0e6XRxCuwnDzSbNHjlSGy4u1TzCQr805ohB2QCONejx68/FNkRtN3LfYO2PWrWs+8sGbne6jxyoZtXM4yD7QNb2q9/BR9Ew1JUZDYrvnpy700uHI4u74vd8I3U/pvlUeuJYVKlU7W2Ew4KOhaBu2Af2Qq1u3NGS+6coZSlmqKRSf8VBP9hEDsjZXOAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Fri, 1 Nov
 2024 16:03:13 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8093.027; Fri, 1 Nov 2024
 16:03:13 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [PATCH v2 24/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Thread-Topic: [PATCH v2 24/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Thread-Index: AQHbKv5FM3B1aLjYHk6i9GmMdsvqorKh+38AgACdngA=
Date: Fri, 1 Nov 2024 16:03:13 +0000
Message-ID: <34241d74a74f034360022bf0ca5284a9462ce4ed.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-25-rick.p.edgecombe@intel.com>
	 <cb9225e3-3e06-41ba-9f30-d38d1555bb32@linux.intel.com>
In-Reply-To: <cb9225e3-3e06-41ba-9f30-d38d1555bb32@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB7003:EE_
x-ms-office365-filtering-correlation-id: f794b4de-e0cc-4c48-94fb-08dcfa8eb0b5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YTVtKzhzWEYrT0xjSEJ0ajFKV3VDS2Q1MEFERjFySEl5YmIyL1RINmM5WHhu?=
 =?utf-8?B?OFpxRjBicEIrOXI3czc4VW1JYmVmYkFZNFgzVGpxeDIwaU9LNGhwU3lGWlFN?=
 =?utf-8?B?ODd4Tyt6MExXQlRLWUdLbkY2UkpCTk1RYktqdE9qUkZvWHA2REtSSmY4VjBQ?=
 =?utf-8?B?VUhVWHBFTGcrNGRHRGtEeS9oOHQ4aHV5SGJTWkhPeWp1VHV4dFE2dFNhYUdH?=
 =?utf-8?B?eFZQdENxb2x0eFJvMjlEZmpBSUZWQ2syOC9oSjVya3ljN1NtVmkxQVpXN2x3?=
 =?utf-8?B?UUJtNElsaHBXeUQzWTdoTWNmUEloSnpiUi94VlFMRnlXK2x4QXBBa1JHYm96?=
 =?utf-8?B?Q1h5eGNUbUFFSVkyRmFuNVcyZWlYci80RzVLa0swOVYra2psck5wOUErMUQ4?=
 =?utf-8?B?SnBWcG9wczltdEwwNUxaQUhXY1hKUWlsK0RTa3Rpc05sZTN5QXBBeE5YMGgw?=
 =?utf-8?B?RXNmL0RqNEx2QS9pVXBhaWpnUGllZm1UZUlyZDZSSENScjlmbGdRZGR2Q09G?=
 =?utf-8?B?dzI1UjBlVWFPUjZJdGtHanplbE9WcEptU2xFa2gyb3NTRm40MFhCZU9HL3NC?=
 =?utf-8?B?Z2ZwWHIvaVJQRWR1czZHdnNiM09iRjZtYTlUSzhzV1FmRWZlTWFpSVFNRjN4?=
 =?utf-8?B?OEN0ZndpUEJrdGFOTTdxczlPb0IzQW1tTGs5UGhRRU8yY3hpa3Y0dHJGKytU?=
 =?utf-8?B?MzlBMkx2Y1hKcmVMYVVYVWNpTjg1SmhBV1pENnErZHlsaGpVNEpJR3dwZUV0?=
 =?utf-8?B?YkNobnkyTnNiWlgxZ2YzQWt0VmsvK3dhVmxxZUpVQmdIbjFMWTQvUmo3bGxq?=
 =?utf-8?B?d2VKL3BGRUk0S2RkcTkwellEaU1jZFZIV0pYbjZNM2Z0NFZWVG0vMjd5eEdT?=
 =?utf-8?B?TnRFSVhnTUNmNE1pcjZqdCs5YkpRY1J1YVpwcmEvSHI1T3NjZnVuN0VMUmtF?=
 =?utf-8?B?b2VaTmRIYzFtdFpCY05HRTY0NUV6Z2dpaDFjWGtVdDhyZTQwZW4zTlNUc0RX?=
 =?utf-8?B?M3VQSDNwbFpmWEoxMmxjVDY4c0gvZHZscFoxNGlTOG1VakdnRFlNN0JsMnNy?=
 =?utf-8?B?SEJvTW5TaXM2cWh6OXdQRmkwRTFYUjl3VlhwalM4ZCtqRllLSUZFMUVQZE10?=
 =?utf-8?B?dlNXZmJNQzNBdjdwTm1PM3M1UTUrWEVSQnU3R0l4L1BkQlBzai80K1ZTZSty?=
 =?utf-8?B?NWlrcmZHTjRJL2RrVitJM0JoY2xVNU8zNVh6SzdkQkJKcUxEWTB6djExajAw?=
 =?utf-8?B?Y280NVZLWGZFTlRub01TUW1GTHFtdmVXZnJxZnE2bjJ6aXd4T1JjeGI3em9I?=
 =?utf-8?B?WXpnckFlc1B6NWp2bkIzcVc4VElQRGJWU0FwVDdHYTdHMzZjQytZTEZvcVJS?=
 =?utf-8?B?d084dWp2VXFZKzZJNnpxUldGdWtKeW5vZmszWEdRcFExRjdYcEtlNzlvYUV3?=
 =?utf-8?B?b2RybXkxekN4RktOKzZZME9xS3dheTZtaXR3NEcvZEgzMnU1cmFtV09vS1FE?=
 =?utf-8?B?WStyOUJhTGJ4dURoRTdmakFyS3lHR0dkODRJN0xKQ2dram1HQW8rdGllMWlN?=
 =?utf-8?B?NGxEc0xCNCtaL1lhOFRpQmwvcFVEd1RvRFFVK1ZUNEsxV0ZTTXRKQXBKT0ds?=
 =?utf-8?B?M21UcnQxWXB5dDdVeTRWTm54RStiUWNMYU53ZFdZblh4SGE5SVlXaFVUUStv?=
 =?utf-8?B?SVdIbEVOcTRwR3hpNVR1MUg0N24rWjZ6V1JDUFVSbWFidzBTOTNaYlc0REhH?=
 =?utf-8?B?d0JPSXRuY3ZGR25CNDVaVTVrSytiWm1HT1dNMktQamRQQWJBeFJ2Z3YzRTBr?=
 =?utf-8?Q?dcR/65/4Va+01t+ZYlfsMIGpEdlM0tbLRdULI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2QrNE5HWXZpUVZxMFI0a3BtZFA2Qy9YMWNwY05KNmh3eEZTNFQrbHlVZWlE?=
 =?utf-8?B?bHcyeFhDcW83ZXNXR1l2VGJFQ2s2NE5aeVlEdURqN0lmWHhXSkFEcGtsQzRO?=
 =?utf-8?B?QkFZMVFUK0dmZmdNTk9HdDRDM3ZMRUN4a3RYSTFsZ0dFb2g0Qkw1RDkxaitq?=
 =?utf-8?B?L1pqNENzZHExWmRsY3NoL0p6QllFTHBSNldzMDRKZE9xa1NyNVBhellIOHNH?=
 =?utf-8?B?WFQ4TXhJOHovN2V5TzQ4Nmp2WlZZVUQ2RXdtbDZjSkZuWEk3OWpCNUNobE1s?=
 =?utf-8?B?VDVDMEJmcDNyUithVmdhamlQOEhZZWhmeFB2R3Z4LzVGVnh1R1VXdjJkbXFx?=
 =?utf-8?B?a0NkQ3c0ZldxVmtZa2pNc3lpZXFTNGtyU1dCK2s4NXhqcFhJcllLMkY0VlFO?=
 =?utf-8?B?bzhTdFk2TlFYUUxZMmN4ZVNhRjFGZ2lFU0MrTk56K2t4RDR6L0dEaVZUdE5T?=
 =?utf-8?B?YkswYjFMWjcycnkrSTFzbkFyOEFTMmtlWDFKd3J0eEZDeDBlWWhkVW5UcmUv?=
 =?utf-8?B?L1dVSUFWK0d6eXc0T3BOTU9hemw2UVhRTHdLeVpzTjVPUGx1Z2JoanVKNlMx?=
 =?utf-8?B?UkUyTDAyUTk4QUdMUUZZaE1lTWdRV1J1N3l1TldUaHIvaVZkTkN4aktBNWd3?=
 =?utf-8?B?N2d0WGtzMXJYcW1BV3h4S0N5elUvMDhCOEV0S0dSaUxSckFGUVBsc21TTmxs?=
 =?utf-8?B?QlViTkJLVGUxSzN6R2FWeTVIWG5rWW9lVmNadW40T2pWajJpTnRZWGdMVGZ5?=
 =?utf-8?B?amYxR0U0eVMyQUFQNjhNYlI2NGIxRTdrU2pFbHhiTUtlaW1KaDZtODlvd2N2?=
 =?utf-8?B?WVFnVytBQysxc3o0S3A2VDQ1THNERnlMaW9uQjhyRmhJVGNPMkNvMDRLMjFh?=
 =?utf-8?B?N0UreDNSejRkSWJNWUpsaFduQUphaktINElGL2hPRVIrM2lGSFp6ZWl4d29s?=
 =?utf-8?B?czNDUUp0M09rL0pjRUEyNTE4L25oc2FLaUd3OUJobGhWUklpRG85SkhzcUly?=
 =?utf-8?B?VzNzZ1pzb1k4b0F6VTdobllyeWFHenp2RUhWOThqMzJRS211LzBCWFk4cHpm?=
 =?utf-8?B?NGFiU24zUGx5MFdzbG1rRmNhU0FjOHdSSmY5d3dNRzBvcmdKUVZsUE9KRmc2?=
 =?utf-8?B?NEZUS0hNNlJhYVBVQWp0SHF1aDU3cWl3L29lWjdPeGliVnQyUlBIQlhKSkNP?=
 =?utf-8?B?WDlGMGRhNTlLdlN0RXorRzVYQVRFckdhUlp4SXdYSXN2WEJvemh3b25HWU1F?=
 =?utf-8?B?WVNzNUwybTlucEdWNlNCUUtmNEdjMFVad1FlRjJLdUs1b1BSYnUxcmdyWHJ3?=
 =?utf-8?B?eHh0OXkxdTdSbm5CLzZjL09iZnR4VVZSWllJRGNsQm9BS3NzMG5uQlhHQytZ?=
 =?utf-8?B?QUw5OGIxYUlFUjExbXFSK0J4eWltSEl4U1lGR1pZMEdvazJKd1gyQzVoaGJo?=
 =?utf-8?B?dk0zSVI1Ti8zdkJZS3BMR1huME9ZUi84dFVWdmVvKyt4a0lTdTB4eFpzcEVH?=
 =?utf-8?B?dEVxbEQyU1Z4Y1U2MnVmOThJa3MweXgyTUV5MkN5OUVkeWZ5US9hMFVXOEVy?=
 =?utf-8?B?OEtJcUMvQVZzUnpqR0w5UysxVDZBdy90NHlqaVRYNS9RM01HNkVHV01mbnNu?=
 =?utf-8?B?QUx5VFYyYWtjeUlPblNOdDdQaHI2RnJsOWk1SUFCbEVROVF4K2YxRXZ5eWlZ?=
 =?utf-8?B?clZ5RHZlWFNtUjhUYStuM3dZQ2tlZkJsR001RncxOWtnSGNObEd3ZlJ0TEVI?=
 =?utf-8?B?bGYxakFhNkdqYnY3dmJHRmgxdFBORVBuV0ZWbTBVTUdLTGxHUzhZQVNuQkg3?=
 =?utf-8?B?WUt6bXc0RXNoWXBCZTdWNTBKVlFOdTdVMllpMWczNitGSEJ3c09udGJxZ2k1?=
 =?utf-8?B?bEJtbU5Ib2xjdVZvcWxuRTBCVmY0ZkhOV3dZSzRqR1dEZmFsVEJubDZ5ejZp?=
 =?utf-8?B?V1E1SklpWjZzUzNPZ1pDOTdFMjEvcFNza1pXUVNoOUNGTDBMYUM3ZWIrSVhl?=
 =?utf-8?B?NDJlWnZUQit1RGdSTTJEajQ2cTh3aFZJaHNHOVcvRGs0d2hsbGZVTzZRZFNX?=
 =?utf-8?B?cS91NFZ2SnR5TDdXZG5lZ2J0VUF6MVZNcEJsZnZ3ZDdFL1BHL2xxN01iR1Ni?=
 =?utf-8?B?bjNWeXZ5UGF1SFZYZlEzb01xelA1QnFiYWJ6cUxjRGZEZCtNbThnelUveVMz?=
 =?utf-8?B?blE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <562558614558AC48916068887AFB04E6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f794b4de-e0cc-4c48-94fb-08dcfa8eb0b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2024 16:03:13.6308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qi0wfilKB/S68x6yhVg/gRYAqL6EKBirDDwaBsTYjY/iNHRoj2pfQC1tUFT4N7DWW3H93KjTAdo7csejX/rRWfE+A2gaikERlm7N4UQwzCU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTExLTAxIGF0IDE0OjM5ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
K3N0YXRpYyBpbnQgdGR4X3JlYWRfY3B1aWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1MzIgbGVh
ZiwgdTMyIHN1Yl9sZWFmLA0KPiA+ICsJCQnCoCBib29sIHN1Yl9sZWFmX3NldCwgc3RydWN0IGt2
bV9jcHVpZF9lbnRyeTIgKm91dCkNCj4gPiArew0KPiA+ICsJc3RydWN0IGt2bV90ZHggKmt2bV90
ZHggPSB0b19rdm1fdGR4KHZjcHUtPmt2bSk7DQo+ID4gKwl1NjQgZmllbGRfaWQgPSBURF9NRF9G
SUVMRF9JRF9DUFVJRF9WQUxVRVM7DQo+ID4gKwl1NjQgZWJ4X2VheCwgZWR4X2VjeDsNCj4gPiAr
CXU2NCBlcnIgPSAwOw0KPiA+ICsNCj4gPiArCWlmIChzdWJfbGVhZiAmIFREWF9NRF9VTlJFQURB
QkxFX0xFQUZfTUFTSyB8fA0KPiA+ICsJwqDCoMKgIHN1Yl9sZWFmX3NldCAmIFREWF9NRF9VTlJF
QURBQkxFX1NVQkxFQUZfTUFTSykNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gSXQgbG9va3Mg
d2VpcmQuDQo+IFNob3VsZCBiZSB0aGUgZm9sbG93aW5nPw0KPiANCj4gKwlpZiAobGVhZiAmIFRE
WF9NRF9VTlJFQURBQkxFX0xFQUZfTUFTSyB8fA0KPiArCcKgwqDCoCBzdWJfbGVhZiAmIFREWF9N
RF9VTlJFQURBQkxFX1NVQkxFQUZfTUFTSykNCj4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+IA0KDQpZ
ZXMsIG5pY2UgY2F0Y2guDQo=

