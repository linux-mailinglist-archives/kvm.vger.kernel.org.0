Return-Path: <kvm+bounces-34552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E473A0118D
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 02:44:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 509313A478D
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 01:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71FB15588E;
	Sat,  4 Jan 2025 01:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mu3vLj/b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8965381B9;
	Sat,  4 Jan 2025 01:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735955050; cv=fail; b=On3Ad/oDU9gK0iXSO/GNda1l5hP0t3r45nSo3gi3QpMI6VJWGVKoCtQT879yUEtFvFrrG1b+6Oew302dmOcGwUgVvPw/XoONKXnqMWbWsk5/dnCAy0E0u/RFm6Pun0mUL58xj8JODUqMI9YcQFcq1gvgk1K1gp3O0k6wuZumtQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735955050; c=relaxed/simple;
	bh=T/tnu3QatD13PtnNedkDqaazdcmbTo9tKNJ0vGeO9qQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gbBC6xMDNj7KO6nn2626gKhkOLKFhNu+lepWcPYUtu1M1F5aBnTgANnycFYgzz9Q12W/uaP8kguLyOh2NYYH3Kvvm7m3MUCIlnF3JzA2zHnUG8DL1Iut0NKMHtdR4/3suzJHMWefQHCpjLdj6BXXlU+B/o97TxeonATY4NCIlfE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mu3vLj/b; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735955049; x=1767491049;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=T/tnu3QatD13PtnNedkDqaazdcmbTo9tKNJ0vGeO9qQ=;
  b=Mu3vLj/b4eR9hV2IPRrAyDmgdX1W/knqfYKyZYgp1sIkr6Sf7wAzvBPx
   Bulqdqf7UEuI72iJ5uS/7MfcqU32tctfX8dpuAcIs/s1GoD6D0+26EhHO
   TsrVXM8Xli/9WUJlDL25xGR+Y44oD77iaWrkFYeZKwwSox0Ayo7aPXUl4
   WFI2ybnTlhrJQdPTHcy1Cs+BYzA5oT8PEkAsEwpl9mdMPgcT/7XrlSgh9
   Rept4LMtLJuJctlP3I7HjWATi2ljoLK722pMs8NoHvnqzwRGduuhF8ysu
   5P7jlK59YJyYsTOgaP8yO3mhQycQPzY5VdxOzROxfjxyWVD3BNrVXwz+y
   w==;
X-CSE-ConnectionGUID: s03+g2SpRhCzoems4K92WA==
X-CSE-MsgGUID: 3mcgoILkQhSI0M5+qd2eAA==
X-IronPort-AV: E=McAfee;i="6700,10204,11304"; a="53613548"
X-IronPort-AV: E=Sophos;i="6.12,287,1728975600"; 
   d="scan'208";a="53613548"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2025 17:44:08 -0800
X-CSE-ConnectionGUID: oogrGyRqRDeuVc3BT+9BNA==
X-CSE-MsgGUID: rn7WYqaOSfijVkDckqx7Gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="102794949"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jan 2025 17:44:08 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 3 Jan 2025 17:44:07 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 3 Jan 2025 17:44:07 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 3 Jan 2025 17:44:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E0iGYa0mfW2rcOeNNjbh8SNG9d6KNOH+frvBxZ04c3GnsAW1a+7+g8IZMulGA4kNjSvZUUrtpYm1yA5ueoUVawzVMvgqa83cZNHyyQtExUzeUHec7LwAcBXD/OFp/L4lVMYduR8FTAU/TnmdXYi9XDkuBw5pfN9GNlDbQ+lkRTf4FjuiqUsefjyK65kNje2sdfihEz/FMBnZyxRE7LhuS1l3hJ278ue2ztTcVNyhxu/r/X9z2vyOdynCqavzU+7mY7G3UqXq4kR4JM5Kd1LfkCNliySsXaOYJ5pkOFVW0Dnh/eXop73riV5uWXMOadVVIEwEvmvEI1inLmcfxpOfTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T/tnu3QatD13PtnNedkDqaazdcmbTo9tKNJ0vGeO9qQ=;
 b=QSqEn7Bwb/DxofX88DBnZgeIy2IdAnjR0pswu1F6/TNY2pOM+jBNTLtus5O65N2Xg5NYzh52x9gO4ArpS5tVKRt/ZP/SPOOZCdZ1HidbkEUPDSyXMsqkGfUa7lgNeum2QVBH+NyuC6mbZgab2P+P1b23a7j69+5uXs3TSSIyOfo4dOLniWzzyCxlcjD7QousYHMh5VO/OuIVgDiGM5+ZvftfGSagdjSicDgiBe2RTR1JSZw2JAGoncVtw3obSv1FtgvjXoCFEh2ctC3ZpSH2GH4SqGIg5tAy2/AVx3J5DLe6RnN7EvvO4Co2TcH6e+tJgx9+vnqjMXAdL8u3IByWNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN0PR11MB6303.namprd11.prod.outlook.com (2603:10b6:208:3c1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.12; Sat, 4 Jan
 2025 01:43:56 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8314.013; Sat, 4 Jan 2025
 01:43:56 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [PATCH v2 00/25] TDX vCPU/VM creation
Thread-Topic: [PATCH v2 00/25] TDX vCPU/VM creation
Thread-Index: AQHbKv4pVcc0TTk+90Os28TjCMK+G7L0WKAAgBHlnQA=
Date: Sat, 4 Jan 2025 01:43:56 +0000
Message-ID: <94e37a815632447d4d16df0a85f3ec2e346fca49.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <CABgObfZsF+1YGTQO_+uF+pBPm-i08BrEGCfTG8_o824776c=6Q@mail.gmail.com>
In-Reply-To: <CABgObfZsF+1YGTQO_+uF+pBPm-i08BrEGCfTG8_o824776c=6Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN0PR11MB6303:EE_
x-ms-office365-filtering-correlation-id: ca51e459-b264-4979-f455-08dd2c61409b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018|7055299003;
x-microsoft-antispam-message-info: =?utf-8?B?ZTU1eEVpVmVmY0xOdnJYL3FEWkhtV1Vmd1AvaHRVWmNjSkVGVVBlK0JXQkpP?=
 =?utf-8?B?dldYTWlsWXYyOUs5QjcvYzB0VG1qMGFIQUVQY2R3b21Vb2M2V1ZBTG9CTTdq?=
 =?utf-8?B?alZheEhGVzIvblczTzNMTDVOYU9Dc0dicm92UFgxdEhCUm9JaytKdEpGK2lw?=
 =?utf-8?B?KyszZXlNL3FsR3BZdTlheFNma3RTV09PYTRJWG5TMHlQaEtEVURabVpjeGtW?=
 =?utf-8?B?T2FwVmhmMndoL1dOZG82UlJieGdlYnp2OUYyUWxiZGlnazlyTGdIcjlpRHBq?=
 =?utf-8?B?Q1dXSnVYY05jTllnMXBKTG52a0RKNG5WcURjdUw2UEZVWWQ5eG1XT2VHcTZO?=
 =?utf-8?B?TWQ0S0N6c1BJRE1PcE5vem5Ub1djM0FhTXJQN0FEMnhZaVNxbitmUk0wR3BL?=
 =?utf-8?B?bDZIaFJkbFQ5R0NHMG5LS3JBWWdoWXJLWnpLMENtUXhwZWZYWHhOUlI1d1JF?=
 =?utf-8?B?N2xnSkw4cVUveFJQU2ZIR3FyTnVMZUluTkhKK2JaeVNyUEpxd1NNZFZlcjNO?=
 =?utf-8?B?S0c0QW9vSjI1UUVObW5ZWkV1dm5yazlXMmcwY2tySlRkRDRaMXFmUE9DVTRY?=
 =?utf-8?B?aVNxa1lzZTM5S2RPdEZWWlFqUzdCQkhNVzBWMmVVSS9VaS9admM0VTNEb0JF?=
 =?utf-8?B?QTBXbmlNcUZVNTZSZk54ZTRtZkkycS8yZ29uRmg2cnVvbnozUENwR3BWRnNI?=
 =?utf-8?B?MlVudHhsY0pWYkpFanQ2SmNFSHU4M21OZkQ1ejh2MENidFFIQlNNN2k5R2Ey?=
 =?utf-8?B?Z0pvY0ZnVGlVaG5TSCt1a0JPOVg1dVNEdmVabFRLOW42emwzSEdvRE9YVXRx?=
 =?utf-8?B?enNXcENLZ1RRRHVLenc4TkIzV05NNHBmQmQxcjZ4RVROWVN3bkc2SURxbE8x?=
 =?utf-8?B?RzIycG9rc1Fzb2Fld0oraFIzTnpmeUNDbEU1cThYc29wcWU2dTRsc3FBZE9N?=
 =?utf-8?B?bnU0bVVIMW5XTVBLYllucVkwZTYxalpyV01FNnBWakJRZEFybXZHb2lCd3gr?=
 =?utf-8?B?enlrbnpsUlZVTlRIa0F5RUNlSElPZm55WS8vc0tneGJldkgzWlRGSGlsZ1Ay?=
 =?utf-8?B?YWcra2hwS3EzNTBwRDRKK3UrbHBNZlZIU2p0OHJYL0tNU0xqNElUT3QyMURz?=
 =?utf-8?B?OXh0RTUwdTczKzdud24raU1YMzNHZ3lkc2NYVnMzMXY3K25kRjdhbjZyRmFq?=
 =?utf-8?B?QzAxQ3Z2U0o0VG1BU2JkMmszWklFVFZWWXRFVDVpSGp0aStsVldhR01MdytN?=
 =?utf-8?B?M3BrakZLR3k5OHBwMGl4SlphRGtBNS9OMVZtd2hEdlRSWjNacTY3Y1NBK0tj?=
 =?utf-8?B?Z3NabFF1N0hzUTFvUzRxbDVKMFpxTGVnaEkwaHZKZ3JWVU1ubVBlMDlwZEUr?=
 =?utf-8?B?bmtLVGZhcUhsVWx2L0wyb0RpMUU1QUg1RlppU0tzbHU3K2kySWMvZlpsc1Bv?=
 =?utf-8?B?N24xTlJneEM1WkZ5cVFQVWtqL211Z0F2aTFTZEFpeExVVFBiQkdiZ2ljY1dQ?=
 =?utf-8?B?bkYxM0JQZmp2SzB5ZUhkL3hJdkZ3L2ZFdDRUOXA1ZDU4NkdSUmRtUHl5OEo4?=
 =?utf-8?B?Qk1HeXptM0dTTUY1OEJsTFJCWklwR29FbkxPVGJGL1pCcXhDTDFuNFF5RnAx?=
 =?utf-8?B?N0tndGRQdE9PYWlSamsrZ25pWHVtK2RWdmxjeTFEL3pUSEhtRzBEOXovUEpG?=
 =?utf-8?B?Wk5obXRIdjA2Y0NFRUJlb2dBUVdZSC9iNkdTdW05Uk5zRGVsUzNrNjdEYnFC?=
 =?utf-8?B?QjlSZDRLQVdDc2l4WmFpRzVyRU8waUxHSTFoZ1ZMVktjOW1JL21aTzg2aGpJ?=
 =?utf-8?B?dXdHZDhXcE00R1c4dUcvV09hZ21rSWN5UUZSOWRuL1YwSHBoRHhRWHNXSG9F?=
 =?utf-8?B?OHc1amRWbzZEQlF4TFVzemhQSVZKUmRuTnUzZWpQVmRzUnE4bjhJSW1iNnUr?=
 =?utf-8?B?NXFYSkxVQnFwNWJrdDlpSTJWdFMzc2FhREJJcUpMZVJlMU55QTR3RUxWdHAv?=
 =?utf-8?Q?BnHVEdXF7QrbzAZweEgXET4Zkg0mnI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018)(7055299003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aHdpeFNTb3BMMG5rOFlPTEJnNVBFQ2FDbFRBYXZhTWdxcTdmck1VZzZGQXE5?=
 =?utf-8?B?Ty91ZmRmMWxMVjlOcTlBZ1U4S0gvZmlRV3hsTEtteDNiV2htdG8veEhHZXlv?=
 =?utf-8?B?dk0ybThHaG9SajJBcGUrOWRySTlPNWhqRVMydTBPQk5pbFNJcWsxeWJoQW5o?=
 =?utf-8?B?ZTZoY3FBZzBqeW5RV3lpTXZOVDhWUitTeGFSNHFMU1NidjhYZFFURXFRb0VQ?=
 =?utf-8?B?VnFySXhyMnRaenlCNCtaei91dlk5VkJlMmVQTHpOaU1NMUFTMnN4cnd4NHNm?=
 =?utf-8?B?MHBId1JjalVKMG95TWZuNHJYcTJ4Ni9ZcUsyYUwremhkSnJZV3VQVnhSNWhx?=
 =?utf-8?B?b1l5NC9NdU4xdHl6dFlLcWtlaXV2RW15eDlzOFVyRlpISVhsVzhNU0ZGOWs4?=
 =?utf-8?B?M3YrenBUTjFqcDl5aFp1eUoyZVpLOGwrL2g2aFIwS2xQUGlwelVPQzUvY0V2?=
 =?utf-8?B?eVRoYnk2SnBKOG1kZjYxSUlVOTh6bWk3TmppY01BZ1J2S1BtbnFpVkMybzRv?=
 =?utf-8?B?VTdXVUxNcU1UODdlWElSSDQ2QmF6bTZTaVRUVEZiaE9NcWtpZjRDenZ0S0RX?=
 =?utf-8?B?QzRDRDRBblBOL0xSUEwrdFlXeldHRjIyaU5OWjZqb0xDSG5sUnBZTlFTUmk1?=
 =?utf-8?B?b0V0Rk9jdUtjZXpsMzFOT0V1Ym1reUtualJVbE03NXJ6TkRvYjhwamxCVjJW?=
 =?utf-8?B?VWZxN3pSR1JTTnVPbms2VGUycEljbmo5ditKVmFtLzhvVDBERUJ1ZTU3cmdM?=
 =?utf-8?B?OXV0K2ptREIvZTlGQzdHSklUcytPZGdaUEhaWFV4ZkI4RnA2VXkwakFmSE1S?=
 =?utf-8?B?RnN5TmJ2K0wrWFY1Rmtva0ZFUHFJaGhjTjhmRW5ndHpHelo5aDdld3p3V0Zr?=
 =?utf-8?B?enNwSlA1QTg5T0gxNGZBYVRtekxqeU1GSUtFc2NWa2E1SmRlZlBrZFh6RkNG?=
 =?utf-8?B?NktWa2tzZGNrTzVHbURHbmFkSnVOWTJkcjNVd0VWOXNWam1QZDlqTTNmTHo2?=
 =?utf-8?B?OFJZWEp6ZmNMbkQ3S3lQV1IxSXZnalQ0NjlnVXQwRW1UZUMzczJHZ0hVcXRy?=
 =?utf-8?B?NUttMFQ5Y1ZsUUhmR05YR3MxV2ErSjgxMitIejB4MkVPRWY5Wk8wWkRHa1FV?=
 =?utf-8?B?azVpemlaZzRGcDV6ekUveVVGUkp6aW1WY0orbjM4TkQwTjJQNWZGUUd6MDhD?=
 =?utf-8?B?bHJZUTVyTFRER2tFL20ySXljZXhPRU1reUdIRExvTmtyemZWTkVFSXp2b0ZM?=
 =?utf-8?B?a2xOUmNVTVlkaWhkejV5Z2R4aW94V1ZWaCtJU0tURisyOXQ5UnlNazBFL1Qy?=
 =?utf-8?B?T3M5YWVXZEZTT1JZZFFRVitqSEJZdlBOVzJuZUU2MnZMZE1pbyt1RE1TelRx?=
 =?utf-8?B?M0ZRZGs3MWgzdm5QWFRHZG96TE56QitzYVowRllpZS9ZU1NERDRTR2EwNnRi?=
 =?utf-8?B?a21FRmZISkJUcXlvd2JvS01wYnNBOFFxRm85MVhpMVV3U0c0MnhwZFk5Uk1h?=
 =?utf-8?B?NXMvQmV3SHFPVThpOXBteUZrbUpGUldIQUFoMW04T2Y2U1dtSXNxM0FqMDVF?=
 =?utf-8?B?UGUwdGJxOENzK0NSc09WNkpzSVluTkRDaFBEb3pGQjQrZ3I1M2tiNElFRGVi?=
 =?utf-8?B?QjgxNEIrWjhSZWo2MVJzYUp5b0ljbS9aRStoNmtWa2JHdGVLYUxpQWM5NWpS?=
 =?utf-8?B?Q2RvU0pveWpCaHR0UVhJbGQwbnlrQUc1Y25hL29JUGtvN2kwdERFeVFyeUlH?=
 =?utf-8?B?YVJXZXk1SGJRT1h0cjZZWGJvT05CLzhlMG9VVmxyZUNWVHRZMEoxUVZtZFpW?=
 =?utf-8?B?K3h4YUpOcEZuSHdQTUNwYTlYdVY3Z05EMFVnMGhucWdGU05pY2hVVC9kb1FJ?=
 =?utf-8?B?Y1EvSHdhaE95alZKeFNwaWNRTGFDUCtzVW1qdjRiOG11RXVWRnlhTG5qS3Yv?=
 =?utf-8?B?bnh3bXkya1JiRDgxbWtlNGR3ZGkycVpZVTZ0b0JKUjdVWjhaMUVkYUE3a2NO?=
 =?utf-8?B?NTVUcUVtSVFtR0Z2TkVJbFJIbkk0ZnRMTTBTcTIyaTJEWTN4c3VYYy9tS3ZL?=
 =?utf-8?B?T0p4NnpBSGlMVnlSUWZWemhHU254Ulp4V013TXZTRUo5ZVNWb3k1ejBoYXFa?=
 =?utf-8?B?S3JFNnBhNitNcjI2ZVV3Z0FMTXpEbkt5Rit5cVN3M09LYzZvdFJGWEFaY2Vq?=
 =?utf-8?B?TEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB9905C07E24BC4182373D013DFCDB2C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca51e459-b264-4979-f455-08dd2c61409b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2025 01:43:56.3594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4nErG/0/2bui0dwohgiUD30W3PdM/Twj5QYABYnlcDbDKRh0aKBPqNoWb4W8/hBp4erXzlfoRnWwl/YLJuaNaA2q5nJ1V8rwmv6mRpY7J1Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6303
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTEyLTIzIGF0IDE3OjI1ICswMTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBUbyBzdW0gdXA6DQo+IA0KPiByZW1vdmVkOg0KPiAwNCByZXBsYWNlZCBieSBhZGQgd3JhcHBl
ciBmdW5jdGlvbnMgZm9yIFNFQU1DQUxMcyBzdWJzZXJpZXMNCj4gMDY6IG5vdCBuZWVkZWQgYW55
bW9yZSwgYWxsIGxvZ2ljIGZvciBLZXlJRCBtZ210IG5vdyBpbiB4ODYvdmlydC90ZHgNCj4gMTA6
IHRkeF9jYXBhYmlsaXRpZXMgZHJvcHBlZCwgcmVwbGFjZWQgbW9zdGx5IGJ5IDAyDQoNClNvcnJ5
LCB3aGF0IGlzIHRoaXM/IE5vdCBmcm9tIHBhdGNoIDEwICJ4ODYvdmlydC90ZHg6IEFkZCBTRUFN
Q0FMTCB3cmFwcGVycyBmb3INClREWCBmbHVzaCBvcGVyYXRpb25zIi4gV2hhdCB3YXMgZHJvcHBl
ZCBmcm9tIHdoaWNoIHBhdGNoPw0KDQo+IDExOiBLVk1fVERYX0NBUEFCSUxJVElFUyBtb3ZlZCB0
byBwYXRjaCAxNg0KPiAxOTogbm90IG5lZWRlZCBhbnltb3JlDQoNCkkgZ3Vlc3MgdGhpcyBpcyBu
b3QgcmVmZXJyaW5nIHRvICJLVk06IFREWDogaW5pdGlhbGl6ZSBWTSB3aXRoIFREWCBzcGVjaWZp
Yw0KcGFyYW1ldGVycyIsIHNvIG5vdCBzdXJlIHdoaWNoIG9uZSBpcyBkcm9wcGVkLg0KDQo+IDIw
OiB3YXMgbmVlZGVkIGJ5IHBhdGNoIDI0DQo+IDIyOiBmb2xkZWQgaW4gb3RoZXIgcGF0Y2hlcw0K
DQo+IDI0OiBsZWZ0IGZvciBsYXRlcg0KPiAyNTogbGVmdCBmb3IgbGF0ZXIvZm9yIHVzZXJzcGFj
ZQ0KT2suDQoNCkknbSBjYW4ndCBmaWd1cmUgb3V0IHdoYXQgdGhlc2UgbnVtYmVycyBjb3JyZXNw
b25kIHRvLCBidXQga3ZtLWNvY28tcXVldWUNCmRvZXNuJ3Qgc2VlbSB0byBoYXZlIGRyb3BwZWQg
YW55IHBhdGNoZXMgeWV0LCBzbyBtYXliZSBpdCB3aWxsIG1ha2UgbW9yZSBzZW5zZQ0Kd2hlbiBJ
IGNhbiB0YWtlIGEgbG9vayBhdCB0aGUgcmVmcmVzaCB0aGVyZS4NCg0KPiANCj4gMDEvMDI6b2sN
Cj4gMDM6IG5lZWQgdG8gY2hhbmdlIDMyIHRvIDEyOA0KPiAwNDogb2sNCj4gMDUvMDYvMDcvMDgv
MDkvMTA6IHJlcGxhY2VkIHdpdGgNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzIwMjQx
MjAzMDEwMzE3LjgyNzgwMy0yLXJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tLw0KPiAxMTogc2Vl
IHRoZSB0eXBlIHNhZmV0eSBjb21tZW50IGFib3ZlOg0KPiA+IFRoZSB1Z2x5IHBhcnQgaGVyZSBp
cyB0aGUgdHlwZS11bnNhZmV0eSBvZiB0b192bXgvdG9fdGR4LsKgIFdlIHByb2JhYmx5DQo+ID4g
c2hvdWxkIGFkZCBzb21lICIjcHJhZ21hIHBvaXNvbiIgb2YgdG9fdm14L3RvX3RkeDogZm9yIGV4
YW1wbGUgYm90aCBjYW4NCj4gPiBiZSBwb2lzb25lZCBpbiBwbXVfaW50ZWwuYyBhZnRlciB0aGUg
ZGVmaW5pdGlvbiBvZg0KPiA+IHZjcHVfdG9fbGJyX3JlY29yZHMoKSwgd2hpbGUgb25lIG9mIHRo
ZW0gY2FuIGJlIHBvaXNvbmVkIGluDQo+ID4gc2d4LmMvcG9zdGVkX2ludHIuYy92bXguYy90ZHgu
Yy4NCg0KSSBsZWZ0IGl0IG9mZiBiZWNhdXNlIHlvdSBzYWlkICJOb3QgYSBzdHJpY3QgcmVxdWly
ZW1lbnQgdGhvdWdoLiIgYW5kIGdhdmUgaXQgYQ0KUkIgdGFnLiBPdGhlciBzdHVmZiBzZWVtZWQg
aGlnaGVyIHByaW9yaXR5LiBXZSBjYW4gbG9vayBhdCBzb21lIG9wdGlvbnMgZm9yIGENCmZvbGxv
dyBvbiBwYXRjaCBpZiBpdCBsaWdodGVucyB5b3VyIGxvYWQuDQoNCj4gDQo+IDEyLzEzLzE0LzE1
OiBvaw0KPiAxNi8xNzogdG8gcmV2aWV3DQo+IDE4OiBub3Qgc3VyZSB3aHkgdGhlIGNoZWNrIGFn
YWluc3QgbnVtX3ByZXNlbnRfY3B1cygpIGlzIG5lZWRlZD8NCg0KVGhlIHBlci12bSBLVk1fTUFY
X1ZDUFVTIHdpbGwgYmUgbWluX3QoaW50LCBrdm0tPm1heF92Y3B1cywgbnVtX3ByZXNlbnRfY3B1
cygpKS4NClNvIGlmIHRkX2NvbmYtPm1heF92Y3B1c19wZXJfdGQgPCBudW1fcHJlc2VudF9jcHVz
KCksIHRoZW4gaXQgbWlnaHQgcmVwb3J0DQpzdXBwb3J0aW5nIG1vcmUgQ1BVcyB0aGVuIGFjdHVh
bGx5IHN1cHBvcnRlZCBieSB0aGUgVERYIG1vZHVsZS4NCg0KQXMgdG8gd2h5IG5vdCBqdXN0IHJl
cG9ydCB0ZF9jb25mLT5tYXhfdmNwdXNfcGVyX3RkLCB0aGF0IHZhbHVlIGlzIHRoZSBtYXggQ1BV
cw0KdGhhdCBhcmUgc3VwcG9ydGVkIGJ5IGFueSBwbGF0Zm9ybSB0aGUgVERYIG1vZHVsZSBzdXBw
b3J0cy4gU28gaXQgaXMgbW9yZSBhYm91dA0Kd2hhdCB0aGUgVERYIG1vZHVsZSBzdXBwb3J0cywg
dGhlbiB3aGF0IHVzZXJzcGFjZSBjYXJlcyBhYm91dCAoaG93IG1hbnkgdkNQVXMNCnRoZXkgY2Fu
IHVzZSkuDQoNCkkgdGhpbmsgd2UgY291bGQgcHJvYmFibHkgZ2V0IGJ5IHdpdGhvdXQgdGhlIGNo
ZWNrIGFuZCBibGFtZSB0aGUgVERYIG1vZHVsZSBpZg0KaXQgZG9lcyBzb21ldGhpbmcgc3RyYW5n
ZS4gSXQgaXPCoHNlZW1zIHNhZmVyIEFCSS13aXNlIHRvIGhhdmUgdGhlIGNoZWNrLiBCdXQgd2UN
CmFyZSBiZWluZyBhIGJpdCBtb3JlIGNhdmFsaWVyIGFyb3VuZCBwcm90ZWN0aW5nIGFnYWluc3Qg
VERYIHN1cHBvcnRlZCBDUFVJRCBiaXQNCmNoYW5nZXMgdGhlbiBvcmlnaW5hbGx5IHBsYW5uZWQs
IHNvIHRoZSBjaGVjayBoZXJlIG5vdyBzZWVtcyBpbmNvbnNpc3RlbnQuDQoNCkxldCBtZSBmbGFn
IEthaSB0byBjb25maXJtIHRoZXJlIHdhcyBub3Qgc29tZSBrbm93biB2aW9sYXRpbmcgY29uZmln
dXJhdGlvbi4gSGUNCmV4cGxvcmVkIGEgYnVuY2ggb2YgZWRnZSBjYXNlcyBvbiB0aGlzIGNvcm5l
ci4NCg0KPiAxOTogb2sNCj4gMjA6IG9rDQo+IDIxOiBvaw0KPiANCj4gMjI6IG1pc3NpbmcgcmV2
aWV3IGNvbW1lbnQgZnJvbSB2MQ0KPiANCj4gPiArwqDCoMKgwqAgLyogVERYIG9ubHkgc3VwcG9y
dHMgeDJBUElDLCB3aGljaCByZXF1aXJlcyBhbiBpbi1rZXJuZWwgbG9jYWwgQVBJQy4gKi8NCj4g
PiArwqDCoMKgwqAgaWYgKCF2Y3B1LT5hcmNoLmFwaWMpDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByZXR1cm4gLUVJTlZBTDsNCj4gDQo+IG5pdDogVXNlIGt2bV9hcGljX3ByZXNlbnQo
KQ0KDQpPb3BzLCBuaWNlIGNhdGNoLg0KDQo+IA0KPiAyMzogb2sNCj4gDQo+IDI0OiBuZWVkIHRv
IGFwcGx5IGZpeA0KPiANCj4gLcKgwqDCoMKgwqDCoCBpZiAoc3ViX2xlYWYgJiBURFhfTURfVU5S
RUFEQUJMRV9MRUFGX01BU0sgfHwNCj4gK8KgwqDCoMKgwqDCoCBpZiAobGVhZiAmIFREWF9NRF9V
TlJFQURBQkxFX0xFQUZfTUFTSyB8fA0KPiANCj4gMjU6IG9rDQoNCg==

