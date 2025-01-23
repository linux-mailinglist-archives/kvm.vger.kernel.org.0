Return-Path: <kvm+bounces-36437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 882A2A1ACEF
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:55:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE2E716C1DE
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 22:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BB951F0E34;
	Thu, 23 Jan 2025 22:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M4Kc8Z2v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B5D1D5ADC
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 22:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737672888; cv=fail; b=WEecfNrQMkqK40+z3axF2Wm1krxdpHaoKLZMLZCvtlZAvL1Uw0p1zoWmpdECRjNLW7W7wOkcycH9aGApiD+psLuMQBN8fdCsSyCAfO7xwGOF3p9W9KzuhCUrk1lZSmyCz8TsScJ3Vil6nj4//2r/EaYCjlUTwVFsi3Mw3Jqf89s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737672888; c=relaxed/simple;
	bh=uKhecaCnYaO4V0lF76x1Onl13zWvkaJBtazzzdeGHIQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HiSEwNQmbGo/gmzesKD/AKWgokmNbTISiPA4TjQ97+zogbqSdwnEjmjcBPTIbmvWI6hs8wvoG1gMCNzpTi8f0w/KPq6A8WlLY8NVKw75unEF0jofQOQacIxbl2J6RSUuKR/WjK+tywIYdJA+iEM3Vf1piD1OuG9UWL2Xqap+JbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M4Kc8Z2v; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737672887; x=1769208887;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uKhecaCnYaO4V0lF76x1Onl13zWvkaJBtazzzdeGHIQ=;
  b=M4Kc8Z2vk0sVRQqKZD4P1P7QGEzcFCZzJzDG+aKBiln8T/jV7lusu/is
   eYS6zqoWGhQdIyFLC+76gr1nB0omrvCXFO//biOe35rRSXdcIL5K+D0Qv
   sg5wruaXA8Me8v/CeF4Qwid1vGiEAkOjfr3rXm0HIf4Y7thRj9oFe2Vd0
   6G2ip+O2sw1jd3dAksvS2DahcsspgPDcw/dNxirAJVanN5iVbkp081aob
   oA0B0/Evvl8b1F9bnItwNUabSWc2chhIzITlICmnuIJ5ysnFIMnjKqKcW
   DtZSQItMjCS6/fl6fkxI4tuAjbno+44Ex9c2bfYu6306Ll8FHAX7+MNhh
   A==;
X-CSE-ConnectionGUID: h3qb4hJQQouzXgeqQ2emvw==
X-CSE-MsgGUID: cyqiUpqeQVaZKGz8isw98Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11324"; a="37896431"
X-IronPort-AV: E=Sophos;i="6.13,229,1732608000"; 
   d="scan'208";a="37896431"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2025 14:54:46 -0800
X-CSE-ConnectionGUID: qYqf7HBxTE2feNpq7tmzbQ==
X-CSE-MsgGUID: jHIRCzWNRCu85i0szIRTrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,229,1732608000"; 
   d="scan'208";a="112597413"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Jan 2025 14:54:46 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 23 Jan 2025 14:54:45 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 23 Jan 2025 14:54:45 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 23 Jan 2025 14:54:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CUwr+0xECSlkcW0DQuHMotaGozqxECTQ4kMMDokrPn+Cm8ITe4lzpPpEmDtw2vvsBrx/vVK0beBl1EpQpaWTCRj82wIq+zPn7YmnuF375HJw84WieU+NLzEBq7/cWqbEMf0s1DWqDgSI2UdveCxKL1i2AkL7DsvJ2CdI04qCo524n2FF15sJfFhtFjHCFVpSNFnnbU8rHPY9lU08fUE3punw/b+tdRutKZ1vzjCw6yO7Wl2iLLliT8yFkK324nzkQ8K1rwgjJKMrwC8BUlwX45Zcvv7tmqFgddIIDEtbeDmjKodDNFRt0F2OyuRIjsSCQHNC3MOIyIc/BYrr7+s0Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uKhecaCnYaO4V0lF76x1Onl13zWvkaJBtazzzdeGHIQ=;
 b=Qc7RZEBlrBxT9D/8DXF9A5v8/Mc/SLVPiVw8PHC+zgZ0mqV+3tZa8nhL9x/w6HD/KHCqNr7gqR+MWbGLITtj0d+ALIrBwI+HX13YT75CM5ENOx1dLzz61dN9qWsfjAagi7ICHx0Mo5n2b9+tm/z1CUfB0ln1Xy5gc8ba6gPEdIaSRnNahu1kkLbqg3PbAstLGDKvVcbK0Z897ycXZWunlhQ2ZIKf8Z766TNpwFxZdgLyJdEI2iw0B++1F8bC86F7Iwlr/HWCunfvuh2eSrBfDo+LH9hIaLCVxHYKWy5MfVFZTdUz2ssrM9kYqixdfvjx1DY5xDiPKGEgpKi2jzin4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB5328.namprd11.prod.outlook.com (2603:10b6:5:393::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.19; Thu, 23 Jan
 2025 22:54:15 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8356.020; Thu, 23 Jan 2025
 22:54:15 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Huang, Kai"
	<kai.huang@intel.com>, lkp <lkp@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "llvm@lists.linux.dev"
	<llvm@lists.linux.dev>, "Chen, Farrah" <farrah.chen@intel.com>,
	"oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>
Subject: Re: [kvm:kvm-coco-queue 39/125] WARNING: modpost: vmlinux: section
 mismatch in reference: vt_init+0x2f (section: .init.text) -> vmx_exit
 (section: .exit.text)
Thread-Topic: [kvm:kvm-coco-queue 39/125] WARNING: modpost: vmlinux: section
 mismatch in reference: vt_init+0x2f (section: .init.text) -> vmx_exit
 (section: .exit.text)
Thread-Index: AQHbbem5EB0SI+Q8IUyeQqppzMVZ3w==
Date: Thu, 23 Jan 2025 22:54:15 +0000
Message-ID: <9a9fbef8ce874f15a5c8fdd24f2958a4f76c6080.camel@intel.com>
References: <202501231202.viiY8Abl-lkp@intel.com>
	 <BL1PR11MB59780AA56D67068C906A40BAF7E02@BL1PR11MB5978.namprd11.prod.outlook.com>
In-Reply-To: <BL1PR11MB59780AA56D67068C906A40BAF7E02@BL1PR11MB5978.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB5328:EE_
x-ms-office365-filtering-correlation-id: a33c0c81-ac67-4a74-5945-08dd3c00dc5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b2FCTm1lbm1LdjVVMzhFeEl0WXowSDZ4U0p2RVd3eHZQVG1pZ0JzOXFhU0tk?=
 =?utf-8?B?dEN2V1pEWFEreEw3RVUySkY0eUoxZVBIdTU1WTk1UjRxZUdyT0tFaXFmUTRP?=
 =?utf-8?B?eFoxOGJrVnBWMmRoQUdwak9tTThsZmc0bkJRS1J6T3ZoQlNXcW03emtZTWN3?=
 =?utf-8?B?Q0Z2b0JvU2J4MmRnWXZqZVE1ZmJUMWNJVXRhSVlLTjRBYWdZQXI5UFErVmh1?=
 =?utf-8?B?MVFYTmQwQWxJNHE5aXJwZFJtczA4Ung2MEFKdXFCaitWT2lmbUR3dDNURmlo?=
 =?utf-8?B?QXBRVDdNYUliMVMxZ1ZHRFBkdHg0SC9SNHJ0VUNvWTRpR29WY2JoVzFVTXRt?=
 =?utf-8?B?U253dllNT2IzdG5mZ044QXNKcHJ1ZHJHVUxVWGN4d0hPZGJMNGJnM2dqWWZo?=
 =?utf-8?B?VHRGbk1aNDg0SWJOR2pINVVPbk4zanZVTy9haWdYWE9iZFUwM24waUcyaW9y?=
 =?utf-8?B?R29VYldZSGViUEoyanBpZFkwZHd5QVIyb21JOERNSXM0cllBdDA3M3djS1Ja?=
 =?utf-8?B?RmcvL0Fvby9aOE9uNzlFYkhJZGhwaVJrcVVIQm5ydWZGT1JDVHFYRUE0aTNv?=
 =?utf-8?B?aEpSempaYmhoZElLbk5Fa2RPSVNVejVTUHBCY2NKdGFiWHBGK0VrSXFnRzlU?=
 =?utf-8?B?TU9xVjg5S3lwMVE2YUVqTXdnM3FTSlJ4Z2ZXQVFJYVNqRVRiZkpkYVdyT280?=
 =?utf-8?B?a3hhcW9tcTZxamdSUSt4a3FsYW1xKzZHRzduUFlTQmNsNmViK3h6T0xTcEdr?=
 =?utf-8?B?RVI5dXUzbUZpMkNtQzFRdVprOHhRbkhmcExLQnNQajdqc1l6blBRaGFMbXgz?=
 =?utf-8?B?TnJuOVJET0c2TFdYaU1Ldnk1c3JIMUdnUytPTTJ0NGRZd051RFJjNVlPNkJM?=
 =?utf-8?B?V0lpT05FeThXZ2h3UWJtUXZNVzVscTNicC9keUNhTGMrNnJTaEpPR0pucFdP?=
 =?utf-8?B?SVRSVTU4YnNrVkdIZVZudGc5dmNKUnNMK0JXZUpyeVBoaEdzeUVqS0w0MDYv?=
 =?utf-8?B?MEFMK3NIRkJwanorU3c2Vm4wOVJ0dWI5ZGZpaHZnOXJnZlRteGNmbHlSVVpl?=
 =?utf-8?B?bDZCYXlLZGwrczdJekNlSUgrYXVoWmdnRXBCOGQydE5EUEYraUxnWEJDcHdN?=
 =?utf-8?B?eUZmVTFwdzVVaXU4RlBZQUxFQm5CcmNCdDdZM2dMbE0rMkJCQkdTUUVFN2RN?=
 =?utf-8?B?Tk8rcHdhSkJLckYzVlM4SFF5OUFhMHBBdGZvdzRDRU9rSUFYaEJOL0tGU3Nz?=
 =?utf-8?B?bmZmTmdZUW1VWStCd3VGUk5xMkJqRnFWRGp0NnRtVkxNYjJ2Y3BXRHFMU0kr?=
 =?utf-8?B?VDFydGcraXJZUHhuKzFCR2JVTk9KYXFIUWJPSGVHTjRaendaQ1FFSkptaXps?=
 =?utf-8?B?cTI2Mk9rK21uVTZOYXB2aFJNZThGVS9MS2hvT2JQejBZZ2hzUHdsbC9LbUt3?=
 =?utf-8?B?YlBsMmpOaGdHcVFtUTRXVmNUdGd6VENadVNla2VJTkVLWW1iNzRJYm9uQ0ww?=
 =?utf-8?B?c0RuRHNNU0tvUzkzMkUxNm5XZUdXV3A5MzBaNjEyQmx1YXlvTG95b2YzMUph?=
 =?utf-8?B?VmZ6dmhESHkwMmJ3OWE5TDN1MDNPaFpsYTJYRGJaWmtTbFVsWWJ1bVdFVEQ2?=
 =?utf-8?B?YW1lbmJFeVp3R2lwZmJnc0FyV1Z5Y2pBUkluaEFRRDRwVitPOHpDN0p6WFIv?=
 =?utf-8?B?M3ljc3JwTjF5NHRjRi8rU3JHekphZ1dNbkY4a252Z2dZYkw5azd3KzRvbGxD?=
 =?utf-8?B?NHdIT2xiR2N6aEFLbC9rS0Q2MXFpTU5QWUpyYWl5Zm5HNHVBVTZMUnZCNmV2?=
 =?utf-8?B?dGxDMys3cHhTdW0xOTlrM05jSVptK1RIcytzTTgxOVBoalFuNHVVMXArTlBK?=
 =?utf-8?B?TllCdVFLbXlRaGlCK3lKcG1ZRW0yZEx0dlVTZnFQQVRpMXc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGc2K2xpTTcvcmJKN0NBT080SkVTZC9ORUhjTVVyL1ZxbnpqeStjb1RmajdI?=
 =?utf-8?B?RnQ3bzJVUW5jb29kc0J2ZC9nTCtLeStoWldUaGdQN2xoTGp2eTBlelR4ZTN0?=
 =?utf-8?B?WHF6WHQ2ekFCK0N5RiszUk9kWUwxbjJacWFGMXNsaVprbDhNY25hUEVDaGpI?=
 =?utf-8?B?WWxHYWdVbGZDNXBwVnphOWQvdmRPU1JGTlB2QkJtZHgxNDcvL2pSWEl1bERW?=
 =?utf-8?B?YnRPRXQ3Vlg5TGZQcVZrbENIWTB3UTI1a1dxQVJXM2xCUFBOZHVBd3VGTDRV?=
 =?utf-8?B?ZU01K1V6NTAzSVcwSmFEcUNTN005TEQ2TXc5Ri9JZ0k2K0RmOXh4cnJPZXUr?=
 =?utf-8?B?NUxwRmNzVXVJSFRQZFJsRGlLeXBMOWpCSzBSVnAzM0FNSnVWcm1wN2tlWGdq?=
 =?utf-8?B?SjExMnBrOW5nNldOc2ZQdkNieUpqUVdaMmNtU3hpVXUyRjNtS3EzZGpFaE83?=
 =?utf-8?B?WHJmcjZTcTBuUnJiMHhHWm1QYzdldXkxdzZrV09TYUV1L1QrempOVzBER0hR?=
 =?utf-8?B?ZGsybVFtN3pidHBYR3ZCeHA0V2dQaHBkSGdNYm5Wb3BUb2VLa3RTRXhhcnMv?=
 =?utf-8?B?cmtyb2tDTW1LNkFPbGs4TzNzVDhjZERBMjRWdVpxTWJFbjM3Z3lubUlldVJJ?=
 =?utf-8?B?SnZrN21aZ0pCOHdrTjYrL3NYK1NlK3JmYUZINXZFK3ZiUndVK0dlS0pzQ2ZF?=
 =?utf-8?B?YnJUdkx0Rjd5NFF3MzZscVNCNVlZdURhQlV6NFpFQ3RuRk1hZ0hhZkhnWkJx?=
 =?utf-8?B?clJYT1pUYWZFU0FwWVRsY3ZDWXJXWkFJQXhxSldDellzNUU5Q1l0aTExWjdF?=
 =?utf-8?B?anFCUG1KN0tqeXdIVHFFMzFUVEllZDZLdUpUdi9lMDJJQXVZQ2o3aU4zMDZ1?=
 =?utf-8?B?WnlIMDhCQ09ZcENsSllVUnNGZEg4VlJFVmZUcG1TYWd3eU1odlRYKzFFK1pu?=
 =?utf-8?B?S1RWWXgxZ2RVbG1kaWdCaTN2WFp4VDJBQVNlY1NYMlBtZytFaXR5cURiRUV4?=
 =?utf-8?B?L2RMb3JtOWRxUzFlWUhGUWRxL29mTkVoR1JCdDdFdGdndzdZU2hMSnk2L3FC?=
 =?utf-8?B?eG9HY1BvNm5BT3l4ODdvbUFDTVFaTXJNbFNlWlBCMkVuNVYrWlNmNWdxU0xI?=
 =?utf-8?B?Q0JUK2poQXRWbm0vc0o2UzJxZVA3aDgxa21aaXhZUENza0VlbG1nYklMQm1J?=
 =?utf-8?B?WlVZZGo0Z21VVmdiVGZIOVRjS1liQmhkaDF5OGFWS1h4WCtYUGJpRUR3cVNp?=
 =?utf-8?B?REk3R0ZDQ1E5K3Q2WVJ5UWszZGk1bmhuS1YyeUhoYWlpZlFRdG8wRnQ0ZnZ5?=
 =?utf-8?B?SFplbjVrZ1Axd1g4dG9Wd01YV2pnL09pbHZIKzFnQ0RQZEE3YmNYdktBcUt5?=
 =?utf-8?B?d0ZxMll3TU1lL0VBcXoweDJaVnIvdXN0bVhINVZ6NzRTazRnY29QQXFDUFR0?=
 =?utf-8?B?eVJBQ3k1NlI4RjFVUjRtUEhCb3U3RFlnYjJranhDU3RLWjVwQldqc1EzTHkz?=
 =?utf-8?B?eUFIK1hQMlM4L21WS3VHZG9BWGIrMDQ4Z2NYR1d6ZDlrSW5OdytmREdWcFNu?=
 =?utf-8?B?WCtUc0hHYkFPWjMwUU0rM1U1dm1lR0lRTGdkMHNEMUtwQ203b2hNZkdmRE1j?=
 =?utf-8?B?WURjT0VNaU1Sa0FHeExwZVAwcDVsd0J2cUtSVGQ2R0MrUDV1SUJRcTVvQWNW?=
 =?utf-8?B?RlF4N3Bkbko5RWgrMEFEeTlkY2NiRkRYNVRPcytVWHA4MlA4SmgxNzlJcy90?=
 =?utf-8?B?NmZIYURMcUx6UnFudG9TOTVDS3pET2J4aFVZTnVRZEE4S0tjdlRNaXZwWDhn?=
 =?utf-8?B?eXdBaENBYUJpeFN1MHVwb2pTWGNBNS9PazlEVWdFV096OXAwMkJxOWRhRWFM?=
 =?utf-8?B?WHkzc3oxbGJDWHBJd0lnS2N6aFluK2NGZTFIL2lEQ0paQ0d4ZVhuTlM4L1hZ?=
 =?utf-8?B?eXkxcWVyWHZNWjNDRlRUV3hFaTR2QlgrR1BqOWFjVjc4QlMvenRTUy9KSHMz?=
 =?utf-8?B?ckFQbFAxejBERDBWU0hpSXF4TUU4MGgvMUE0cElSMzMzK1dzTjE3ZjF6Q3JC?=
 =?utf-8?B?K3ZUYTlmd3E1UXBLbm81bGVibzFBaS9jcFh4OXFBRDlZaVQyd3NSUjhESmZj?=
 =?utf-8?B?SW9QWWlMelV0K092c1kxeGVJcUJvU0F4Z2Z3WUdkRm1FcTJ4aFRWK0szM3cv?=
 =?utf-8?B?Q2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B318114A4446D4B8D71BE33BFA096B7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a33c0c81-ac67-4a74-5945-08dd3c00dc5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2025 22:54:15.0871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MF0WNXKiHF8HtsU6gjqIisYuPAuuMkpVuYOkc64nz+3rtKes4vV+0vy24EyEsTfc+FbzIhfmwyEEAk/voyX37hgtb3C4l6hEJ6ck2Y0M1Ag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5328
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTAxLTIzIGF0IDA4OjM1ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBJ
IGNoZWNrZWQgdGhlIGNvZGUsIEkgdGhpbmsgaXQgaXMgYmVjYXVzZSB2dF9pbml0KCkgY2FsbHMg
dm14X2V4aXQoKSBpbiB0aGUgZXJyb3IgcGF0aCB3aGVuIGt2bV9pbml0KCkgZmFpbHMuDQo+IA0K
PiB2dF9pbml0KCkgaXMgYW5ub3RhdGVkIHdpdGggX19pbml0IGFuZCB2bXhfZXhpdCgpIGlzIGFu
bm90YXRlZCB3aXRoIF9fZXhpdC4NCg0KWWVhLiBUaGUgX19leGl0IHdhcyBqdXN0IGFkZGVkIHJl
Y2VudGx5Og0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzIwMjUwMTAyMTU0MDUwLjI0MDMt
MS1jb3N0YXMuYXJneXJpc0BhbWQuY29tLw0KDQo+IA0KPiBQZXJoYXBzIHdlIG5lZWQgdG8gcmVt
b3ZlIHRoZSBfX2V4aXQgYW5ub3RhdGlvbiBmcm9tIHZteF9leGl0KCkuDQo+IA0KDQoNCg==

