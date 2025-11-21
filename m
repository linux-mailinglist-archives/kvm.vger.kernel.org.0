Return-Path: <kvm+bounces-64073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 88E04C77A7F
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 08:14:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 892F84E77D0
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 07:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6847A335570;
	Fri, 21 Nov 2025 07:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H9FKiIYp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FFC283FC3;
	Fri, 21 Nov 2025 07:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763709224; cv=fail; b=omNtCXY0aTlcqZZ/pESHi4N4XHOcWWxGIDCPiu2wylYtD6SKBPT3GACAhQxr1g9VJSM8pjgSdt73rRnBCfR422aVXrRw9GwHOANp/5HSQIp8porvrM98+BMNWz3uApRLEPiO+vMWr+7UX2//+LsrK96guMbQSVr0m22Qt6syolo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763709224; c=relaxed/simple;
	bh=tVQANviN2VT8bPT/bkD2A4qWEuyKa6kH4D1kr7LH6Os=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=suZel9EUB+9zEXsEhCcw60E7N4T4td2/Tl+7hPi621KoYFs/le8C8xhn2HIo4peYpnl9/XbUvs+xLr7pzWiuviQjGHks49rMXd1RAXzA/cc7txoQPpq5WYsawoTtzzAzyXjWUnKCv1VTIKCwUt7bJTYxoJH4x/OB7LmpmdPfQOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H9FKiIYp; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763709223; x=1795245223;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=tVQANviN2VT8bPT/bkD2A4qWEuyKa6kH4D1kr7LH6Os=;
  b=H9FKiIYplsZRfRJCN1hMAF3sSd6QtgX1dP1OcmCniu1kab6ro7+tzwNH
   tENZCnGVp1/lw131GU+9WPdeDdanFAB2FjdgFXDcwqo6EN1ZQ3KfGFWZm
   ExACajq6Ka+h3rh/aQHboKQ0SFktIsYkxaYUJ4DyMxScqlEh4p76+EaeE
   tEskPFbmVfqvMNFNJbg/NkkUVlJ7lariA7gfRacQ+WLKpThmDGANbtWZ+
   ur/0eVodKyHRXduoJrn/8onG9gh6SnE13q1q0dhN7tCAr6JMgmLN4ih2w
   7TISJ2Hz+nHly7NZuqUqcVgYeZyNw8QbhXRMgfmoKwIJfYb1U1hLQeqKV
   g==;
X-CSE-ConnectionGUID: 4j7hahXsTJyzzV5ZTjij2g==
X-CSE-MsgGUID: JJHC/KlSQkSv2yNatx2i8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="69656082"
X-IronPort-AV: E=Sophos;i="6.20,215,1758610800"; 
   d="scan'208";a="69656082"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 23:13:42 -0800
X-CSE-ConnectionGUID: RWdWDwXHQTWlrkdMpfJ06g==
X-CSE-MsgGUID: iZUZErZKQaihUvl2R237gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,215,1758610800"; 
   d="scan'208";a="191865255"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 23:13:42 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 23:13:41 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 23:13:41 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.12) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 23:13:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h+i6yy/jLHKpmhd0pVEglCE8F/n//q8807TS+GKs3kzvp9RArZa559D9y0lLoNuF50HV+uMsrHMkrZ8AzA/vjD9TsxiDw3bdjFnqvvJfjwowmlvmEzVpJIdX0trWMqMBbIhuYlf3yjryWNn5v9YB+zdbHEJ0WQBAOqT5vjQBEnNeS7jd2Lan+dLSVri5TTNZT2U/2tLN6IdStT7MV/fr/otQOyy2pklAp4oKwFnzDZIZFWtQkCcUVVacixzicCaEc8x/0fhB2JLUsbtMQpExr5A9+slcZj6/g9p2oxUB3jkBWf3q5KNBwM/05sRXeQqePiKodK/3y4IUWIUFjh2UTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tVQANviN2VT8bPT/bkD2A4qWEuyKa6kH4D1kr7LH6Os=;
 b=Jn15lDLfkSrQrPSlUnDTUTXbXjbd2giaQofaZhukFauH9K4FaJhx6/XNpyOS54eV0T3Kq/9k/gBdwaId4UaCmXMy/+aBTHDa1dY4hJC3Kbz/QYODFSSdd0HKx69gcseF+F3TuGDh/ajoXN4zYPH2ootHXIqMEZEcHXqb9/EKlI/CNwJAqIUf5waSaQWOmfzL7a13AV2FxKk+00nv/HeH2ZThULVxFW23GKzYmhENuJl6UMLzi4oq0sylwzF53X/PVpTCMfCrHKMBEp44KRQmzeQm0F31TjZuIdhL2b86NQk4VE605Eqv3FDviCjMmridDgiNWacB/YHNrgCDZBuAoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB7887.namprd11.prod.outlook.com (2603:10b6:8:e2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.12; Fri, 21 Nov
 2025 07:13:39 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 07:13:39 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Winiarski, Michal" <michal.winiarski@intel.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Alex Williamson <alex@shazbot.org>, Yishai Hadas
	<yishaih@nvidia.com>, Longfang Liu <liulongfang@huawei.com>, Shameer Kolothum
	<skolothumtho@nvidia.com>, Brett Creeley <brett.creeley@amd.com>, "Cabiddu,
 Giovanni" <giovanni.cabiddu@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/6] vfio: Introduce .migration_reset_state() callback
Thread-Topic: [PATCH 1/6] vfio: Introduce .migration_reset_state() callback
Thread-Index: AQHcWhpkofe6ygD3oUCcgEACMDssiLT8tYWw
Date: Fri, 21 Nov 2025 07:13:38 +0000
Message-ID: <BN9PR11MB52765AD421658A2C867AD77E8CD5A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20251120123647.3522082-1-michal.winiarski@intel.com>
 <20251120123647.3522082-2-michal.winiarski@intel.com>
In-Reply-To: <20251120123647.3522082-2-michal.winiarski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB7887:EE_
x-ms-office365-filtering-correlation-id: f9a0951c-8650-4aea-d938-08de28cd7e9a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?dVhzaytZUTM1eTVmQ2ErRytNN0MzdG5yY3htTUxKSEdRUDgrMWFVeW1mZk9r?=
 =?utf-8?B?RHBib0NnZFI2NVh0VVhZTnZMd1ZDS3VQblRlR0xPeEsxTWZ1dkFSLzFTTzhq?=
 =?utf-8?B?dnUxcUZmKzl6Qlkwc243OFQxVHAxMVdKK1JOWSsxTkhiSzFmRTBwWHpsVWFk?=
 =?utf-8?B?YUl5UkkzNGVKczJyRUUzN0oyb2RRWjVJVUJ1bXVqSWgxMi9XOXN6RHN1aGM0?=
 =?utf-8?B?VGl6QkkwNTBzRXhTVy9kbU51ZnJnZ0hpa1YwZnVzempHY1dDOERjMnEvdlhK?=
 =?utf-8?B?eTFkOWwvNThqMmk2cjAzMkptaWJocWJ0WUE5SllqSWwvck9NaVJsUzEvOCtB?=
 =?utf-8?B?UU5hVzdSWllKRVZGZkUzZnM3a3V0aE14Qy9sTUFlVEVQTmhWMW5tZTFteDZp?=
 =?utf-8?B?bVlYbUdsQkphN2JxU0ZpVGdnK1hwQUNxVlRFVDYwNTk2QXN4cm8zL1lsMFNX?=
 =?utf-8?B?QytCUVRWcytxclo2SkpCYmU2TksrNFUxSHgxaFZuc1o3aDZnSlJqZVQxdjI3?=
 =?utf-8?B?T3lhUVUzSU9RMkdoYkp0dGRUQkVrbFdJaW8yT3FrdDRXazQvaVFHZTZZN05Z?=
 =?utf-8?B?NkNIZzVFaVRMLzlKdzdTL2N1Tk1NVnUycDRQUVBOeGJkV0ticTFtWWppZmZP?=
 =?utf-8?B?cWxPSTgvZitSQTBzYkhjME1hVjNZb2Roa2lwVXdiTU9YcWdDOStTbGRFNFRN?=
 =?utf-8?B?YmZDeDVKeC93a3ZIbzd2UGpYODd5bW1kNkxGM2k0RHpPbmVXU2hrSmpCcXlK?=
 =?utf-8?B?QU1qTjl3dFhKYlp1Y01pUFVsS2VkWGthMzNNQUtBNWovcnhPcXdBRXFoYXdx?=
 =?utf-8?B?WkZPZUR1Z1dFS0JFM2M2YVkvR1N4Nk4zZkl0QXpkM0RWM0wvNDFJYUdSNkZ5?=
 =?utf-8?B?TUZmamR4VmhyTWcyQ3NwWm14NnRmdWF1V01vTmVKOEV3aXExR2N5enRtWjF3?=
 =?utf-8?B?OVp6dVV0Q2ZaWnNtY1pLWEc1QU1Wam5zSUNieVduWWlBaXJPOGNFemg0VkVz?=
 =?utf-8?B?T3hPa1pCTWgwb2JiS0ZYNVVOU2pkanU4RFAyVGhycTFNdU53dVJVMndmR3hn?=
 =?utf-8?B?OTVCYlVBdFVLdHdqc1Zab3RFWjhuMXdqY3U5WVFxeWdIRkZ3TzRkTU9IVnpQ?=
 =?utf-8?B?S29pU0Fad2c4QUlXUzUwMDVrc3pDa0QwZDgyYmh3VW5HSW04WFQ2M2lEOUtx?=
 =?utf-8?B?TGd3Vlh4Sys3M2psTVlDc2JQUWdWYW5JVnhVQk9CKzNsZHRWeWVBWWZxUTVk?=
 =?utf-8?B?NFpvMldqVkdnQVd3NGk3UHFrSXY4OGFvaFhMU0hqZno1QWNzNTZNZWpxUHJs?=
 =?utf-8?B?ZldBMUZTVTE1YU02cTBWMFg1MGFBVEVMaWlOZS9ldTBYVFhvZDdleUQ0bEhn?=
 =?utf-8?B?bi84SVM2RkFwRGxGYktTOXFDWk1LOE1acDVNL3ZQc3ZKRzI3WEhvY1N4ZkhN?=
 =?utf-8?B?Ym0xMFhFdXZnSlpUZUVsRkNSeWs2eUlJZ1pRbkZPeWVlVWJTc3hycGpRWlEv?=
 =?utf-8?B?UWI2RjRCbUVDUkxjSm50cW9nZDVQdnMxRXR1Y1dSMjhSdFlzYk5NWDI1NmJB?=
 =?utf-8?B?SzNyeUY3RUhMOVJ1bDgycStTbE03aXJodjZKWTRIK25CYVBoVFZDQkJHdHp5?=
 =?utf-8?B?ZmlnNVBMM3EvYUFUZ29WVStvb1p2RU1PZlpWVEFJRkpMSjB1VEpVUkFsL3Mx?=
 =?utf-8?B?ZkYwOXVIVTJhTjBGVDRxOERQRkxqVGYvd25EYzdoS05iZFgrNndyZVl4L1VZ?=
 =?utf-8?B?NndaVzUyS3lPQnFzdDEvb3pkeTJCdXRYQTV6NGZ1ZWxLWXc4K3Z6VWFlS0wv?=
 =?utf-8?B?YWllQkVGcFcxenRteVFDaE5QMWFhb0RvLzl5Z09oQmRZU0pWcWdUL0ZobXo1?=
 =?utf-8?B?NkZDMXp4bHlBbnJSRTh5OGdrNTEwYzEwYlFoL1RRaU1uR21ub3VaK0k1ZHRx?=
 =?utf-8?B?RVNwVzkxQ05pWlZMRmF3dStXWks4VkRNQjQwemF4RS8waE5zWkNVdkxhemtQ?=
 =?utf-8?B?QytaL3dnUXdNNmtWK0h3Z3piU2V0NUo1bEpqMzV3WUgvS2lhVGVzRVJXcGRs?=
 =?utf-8?B?RmNyZzBjZFlMUWRrWU1NVkxDR01lOWQrK21nUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dW15bkYzZDNCNzZBUndkTnEyRDkyOTdrRGNuQzEzUk1DanNVUk4rU05ma1VH?=
 =?utf-8?B?NVlnNEJLSHJRbHRUdnBRT003TjdKSUsxaERQTmkvaVlVUkVMR2FNbkovM3dR?=
 =?utf-8?B?RWtIcmZsZlVneGZyV2pNdmdBS0hEK215aE1IOGhmQnczbmlEUzBlTkd5Qzhl?=
 =?utf-8?B?RmVwM1RXZ3ljeldGSENPTEN3b2Z0VkJ5MlBlRCtJYTBySTBFMFdpbkpVdi9H?=
 =?utf-8?B?V0RwVSt5NzhkR3paU202SThhcGhIaUVJQ2VYNm01QWFpRXp6TEQrNnFQcFNv?=
 =?utf-8?B?ekxhWXR0a0Vvazl5MkVqU01PaGh1Wjl3VHMvWXYzdUhsd3RBZVZDZ3lldjdR?=
 =?utf-8?B?bXh5T3NzUi85TEFKaHRISUNJWEtvMi9PV0o1R1JOSCs1NzYvdzlscWUyQlZx?=
 =?utf-8?B?S1RBMG90cE5FbzZaT3dNQUZleFh1Z0puWlhZYmxDc2xIVjEyR0xBdklJQ1BO?=
 =?utf-8?B?VlBBMm5ZQVoxRytxbGJmbXZTa1kvbzEvQkxyS2ZPT09WVHh5d3pHalpiMFJ0?=
 =?utf-8?B?QzMva2NGKzV4Wnl6L0FSUW5UcEhPdGF0T1Ywc1RtVlBlek04eTh5VmhPMkY5?=
 =?utf-8?B?NWJoRW55aUJOeW5GSW1ERGMyZDdKdmYwU2xBSTV1My90eDVzc3B4TWlOdXk4?=
 =?utf-8?B?c2s1NHpzU3VNTkpQbGR4SWRBNG9Tb3ByUlFWWXFKN09vcnl2VUpVZ25qT1RC?=
 =?utf-8?B?TC9vZnVPNzBrdk9UQ1RJaWN4dzgyaVd4VWFYZktzY0NnTTVKZ1JUbUdwQm1U?=
 =?utf-8?B?WFZTS2dWKzd3L3lhd0lqcG5TRXZScUF2dmNWcDVzaDJOUy9LNytDbHc2MTdV?=
 =?utf-8?B?RlJ1aURyMmpzV3FjSURNbExaREhJczJsY3p3SnQycGp3STdqcVc1WEJRMWxo?=
 =?utf-8?B?ZC9VWkh3WmxXdVJYZ3pOTFkxWUZTTysrak11enNOdFAxTGFkL21Mam5hWlF5?=
 =?utf-8?B?QjlxbHkvSzQ0OThxUEZuanlEVE9tOXZWSlJ1Z25HMVBCWHZHM1VtVDBUWlVL?=
 =?utf-8?B?eE5GLzhiRXNRMEtneTZGbnp5MjlPbmJCcTF5SE9vc3ZkK29EUElCMWN0bEE3?=
 =?utf-8?B?cUwxRTZkRGt2aFErYUdhUjlJKzZ5aVhzZklWbXJtT1JWUHYycjY2bk9nQVNu?=
 =?utf-8?B?S2JNVll4aVZUZHErY0xlemNMbmM3VmtlNFNPZ1FoWTl4c1JwNW51STRqM2Fx?=
 =?utf-8?B?YkdjSUo0c1NnMmlvZ3N1c1g5YzZlTWx0anJQQnA2VUkwV3Y1cUh3WlI0bjJa?=
 =?utf-8?B?cmNseUZrZG12ck9NdzVZSkJ0OWozZXVJblZPMXkwRWJLZlovRzZqQWZZSkRV?=
 =?utf-8?B?L0dVNU5VRlY1MjZ3dldobitPL3FOWFZ5R24rKzlXU2pFcE1XTXRuRER5Wkxy?=
 =?utf-8?B?MXJxMVJSMjE3QURGeWIxZzJnQXJtak14ek9EQ3FtcnJUdlo1c2QwNnNJTDdv?=
 =?utf-8?B?NnVHUWMvOGFTSXlzdjRqRnNzQnN3SlV5Ymx1Y0xyOXZuUHJDVWZURmpIWUhj?=
 =?utf-8?B?VDVNeldqQ2RtNXFTMDE5Sk51QlZLSjNES0FYcDloeEE5clhmcXR0ZE13c2dv?=
 =?utf-8?B?WTFFT3VCZmZST1RNOUY2Mk93bHRBU1pDcGI1OEtPNUNyYkpLL1d4TVoxMzVB?=
 =?utf-8?B?bFJDaDE1SUcrbHBQRXVjL2Q5N2QyRndaVVpkcmYvQ25sR0s0RjNlcjBEREpR?=
 =?utf-8?B?NFdIanF6ajc5QWhLSTE1UHRNVnlDK0gvNkxYMW96dFVrNmNtM3pFWmRnZUV0?=
 =?utf-8?B?VXJzR2NxeEc5RmVLNmh1Nm1oOGtlZ0dkY1FXMGN5V3FBR1kzbDkvRUErcVhz?=
 =?utf-8?B?cW9tdTNDQVdFUGdaMTlkOHVuZ0kxQ1VyMHFQSk1maWxwZkE2MjRFMWVpV2U3?=
 =?utf-8?B?bFVUN0wrZ1JQS2dVNmtLZGVDSHRnSG5KcDNzSktNb1ZmaC9MSFppRVhLaVl4?=
 =?utf-8?B?RmdTZEJ6eU5kZm95cXRnZU1zSU10QTZ1cmd0Z2Vsd21QWHhIbFFCLzc3dHFV?=
 =?utf-8?B?OTF3WmpCc0hUbXdGU09JKzR2MmE5bm9MbHRxNzBqbmdYWmdqc0xtWXpQajdr?=
 =?utf-8?B?Z3ZJVk5WeTJweUE2RGpHaDBEL1d0cUdxZ0dKSUZoNGZxQUJxL01GZUY4QUR1?=
 =?utf-8?Q?LFc3WcvViRlbOhaDAukdCowbd?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9a0951c-8650-4aea-d938-08de28cd7e9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2025 07:13:39.0157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: etXci1hS5fy0HXkMEUfNRcFn/W3bYEMnOKsqKYsygAtK9mJLzS3ElRe6gX3U8E4GaJ+dYlPfTiz+BCnRWhXSCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7887
X-OriginatorOrg: intel.com

PiBGcm9tOiBXaW5pYXJza2ksIE1pY2hhbCA8bWljaGFsLndpbmlhcnNraUBpbnRlbC5jb20+DQo+
IFNlbnQ6IFRodXJzZGF5LCBOb3ZlbWJlciAyMCwgMjAyNSA4OjM3IFBNDQo+IA0KPiBSZXNldHRp
bmcgdGhlIG1pZ3JhdGlvbiBkZXZpY2Ugc3RhdGUgaXMgdHlwaWNhbGx5IGRlbGVnYXRlZCB0byBQ
Q0kNCj4gLnJlc2V0X2RvbmUoKSBjYWxsYmFjay4NCj4gV2l0aCBWRklPLCByZXNldCBpcyB1c3Vh
bGx5IGNhbGxlZCB1bmRlciB2ZGV2LT5tZW1vcnlfbG9jaywgd2hpY2ggY2F1c2VzDQo+IGxvY2tk
ZXAgdG8gcmVwb3J0IGEgZm9sbG93aW5nIGNpcmN1bGFyIGxvY2tpbmcgZGVwZW5kZW5jeSBzY2Vu
YXJpbzoNCj4gDQo+IDA6IHNldF9kZXZpY2Vfc3RhdGUNCj4gZHJpdmVyLT5zdGF0ZV9tdXRleCAt
PiBtaWdmLT5sb2NrDQo+IDE6IGRhdGFfcmVhZA0KPiBtaWdmLT5sb2NrIC0+IG1tLT5tbWFwX2xv
Y2sNCj4gMjogdmZpb19waW5fZG1hDQo+IG1tLT5tbWFwX2xvY2sgLT4gdmRldi0+bWVtb3J5X2xv
Y2sNCj4gMzogdmZpb19wY2lfaW9jdGxfcmVzZXQNCj4gdmRldi0+bWVtb3J5X2xvY2sgLT4gZHJp
dmVyLT5zdGF0ZV9tdXRleA0KPiANCj4gSW50cm9kdWNlIGEgLm1pZ3JhdGlvbl9yZXNldF9zdGF0
ZSgpIGNhbGxiYWNrIGNhbGxlZCBvdXRzaWRlIG9mDQo+IHZkZXYtPm1lbW9yeV9sb2NrIHRvIGJy
ZWFrIHRoZSBkZXBlbmRlbmN5IGNoYWluLg0KDQpzbyBpdCBraW5kIG9mIHVuaWZpZXMgdGhlIGRl
ZmVycmVkX3Jlc2V0IGxvZ2ljIGNyb3NzIGFsbCBkcml2ZXJzLg0KDQpzb3VuZHMgcmVhc29uYWJs
ZSBhcyBub2JvZHkgc2hvdWxkIGV4cGVjdCBhIGNvbmNyZXRlIHNlcXVlbmNlIG9mDQphIHJlc2V0
IGRvbmUgdnMuIGEgcmFjaW5nIHNldF9kZXZpY2Vfc3RhdGUuDQoNCj4gDQo+ICtzdGF0aWMgdm9p
ZCB2ZmlvX3BjaV9kZXZfbWlncmF0aW9uX3Jlc2V0X3N0YXRlKHN0cnVjdCB2ZmlvX3BjaV9jb3Jl
X2RldmljZQ0KPiAqdmRldikNCj4gK3sNCj4gKwlsb2NrZGVwX2Fzc2VydF9ub3RfaGVsZCgmdmRl
di0+bWVtb3J5X2xvY2spOw0KPiArDQo+ICsJaWYgKCF2ZGV2LT52ZGV2Lm1pZ19vcHMtPm1pZ3Jh
dGlvbl9yZXNldF9zdGF0ZSkNCj4gKwkJcmV0dXJuOw0KDQptaWdfb3BzIGNvdWxkIGJlIE5VTEwu
DQoNCj4gQEAgLTEyMzAsNiArMTI0Miw4IEBAIHN0YXRpYyBpbnQgdmZpb19wY2lfaW9jdGxfcmVz
ZXQoc3RydWN0DQo+IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2LA0KPiAgCXJldCA9IHBjaV90
cnlfcmVzZXRfZnVuY3Rpb24odmRldi0+cGRldik7DQo+ICAJdXBfd3JpdGUoJnZkZXYtPm1lbW9y
eV9sb2NrKTsNCj4gDQo+ICsJdmZpb19wY2lfZGV2X21pZ3JhdGlvbl9yZXNldF9zdGF0ZSh2ZGV2
KTsNCj4gKw0KDQpvbmx5IGlmIHRoZSBwcmV2aW91cyByZXNldCBzdWNjZWVkcy4NCg0KPiBAQCAt
MjQ4Niw4ICsyNTAxLDEwIEBAIHN0YXRpYyBpbnQgdmZpb19wY2lfZGV2X3NldF9ob3RfcmVzZXQo
c3RydWN0DQo+IHZmaW9fZGV2aWNlX3NldCAqZGV2X3NldCwNCj4gDQo+ICBlcnJfdW5kbzoNCj4g
IAlsaXN0X2Zvcl9lYWNoX2VudHJ5X2Zyb21fcmV2ZXJzZSh2ZGV2LCAmZGV2X3NldC0+ZGV2aWNl
X2xpc3QsDQo+IC0JCQkJCSB2ZGV2LmRldl9zZXRfbGlzdCkNCj4gKwkJCQkJIHZkZXYuZGV2X3Nl
dF9saXN0KSB7DQo+ICAJCXVwX3dyaXRlKCZ2ZGV2LT5tZW1vcnlfbG9jayk7DQo+ICsJCXZmaW9f
cGNpX2Rldl9taWdyYXRpb25fcmVzZXRfc3RhdGUodmRldik7DQo+ICsJfQ0KDQpkaXR0bw0KDQpi
dHcgc29tZSByZXNldCBwYXRocyBhcmUgbWlzc2VkIGluIGRyaXZlcnMvdmZpby9wY2kvdmZpb19w
Y2lfY29uZmlnLmMsDQplLmcuIGZvciB2RkxSIGVtdWxhdGlvbi4NCg0KDQo=

