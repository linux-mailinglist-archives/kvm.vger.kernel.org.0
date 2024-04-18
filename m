Return-Path: <kvm+bounces-15038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ABAF8A8FDD
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 02:09:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D1A21C213C2
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 00:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C7005CB0;
	Thu, 18 Apr 2024 00:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JLe6twAY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844444411
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 00:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713398893; cv=fail; b=birAChjVId4QYCpw+vpaq21DqBvBP0ulQYYjH9wxG5h6HpKgHE0i4tYyI/nCm5PTf+i5asYqnorWwmci9BSXuC705vZ2mXyOEB2c9Nk1XbCsCmrTOJxMYZKCvuegZGnbnUne3uowIgTVTWqqXTpln0nehAhXbXHJ9ZWtVQ9aYUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713398893; c=relaxed/simple;
	bh=pmpWhXJY14GhO304yvq0Cn51XkgD/+r6zrsl09T9ggY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Wrz9hT3KMUGD5AXWwY2Cy9ct+9XbzC3aJiqss3vp0jPZZXrqSdBSo8K/QIpInshu85GPRjJBFtv3vtSZfk+KDs6rcJaNoC4fO50y53XnJ3XT8bCa/LOKd3jALeEHXtG5QqCUuXW95R2WluxQlPaUBuidHjnSMFcMIHt8jNZISOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JLe6twAY; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713398892; x=1744934892;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pmpWhXJY14GhO304yvq0Cn51XkgD/+r6zrsl09T9ggY=;
  b=JLe6twAY0n1C1QeqT6l8+11DQTorQXajZzufDRzaSA7LATIHpxVaKzln
   3sy85X+n0Bf/jVGYwJZsbTks0raVBHQQ4FloG9JX3YLzuBwmBOAU4vSln
   BilK+3qRBoKGrnx151ip6HXLf+V62pcOv0hol8IQ4OU7D4Gj10gvcbkYl
   XnPpF4YZuM87WE54zpeLmpyv0Mdke/CGvFGYFTVAQ7gzG61NJyVYpxN3P
   Q49nR7sJF1yEWXDtZ4o14hTaZhZVG+bv5gE6nS97RytVkpmiosHoDTrId
   cCSxlG8MqbvEc/6AYpOo5NTdSA3opFNbZYu+VVdDy+IFZvYYQmD7PTH98
   w==;
X-CSE-ConnectionGUID: MNnB/jzYSwmLA/zy89UPcQ==
X-CSE-MsgGUID: Div4kPrzTsmtQ/XNaimgtw==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="8783825"
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="8783825"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 17:08:08 -0700
X-CSE-ConnectionGUID: Xw/4wzH2QKGVC67a9FF+Kw==
X-CSE-MsgGUID: DfqfIjqCQMaPAdmQhvGJ4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="23225353"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 17:08:05 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 17:08:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 17:08:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 17:08:04 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 17:08:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUECByfTBoGf3czW7r8CbY+pjD4MoBy4robV73/5QMRBEgGkWCPQZjcUzF7m0HQ1340HiNAVVP+js1KySBlBbG4hqzpNpqh4bR3zkAGr85nBVr9g/9Gf+TdJqaGUDvHCxWKATHEzB+fjLS2X2Op5jUW1dI6Nlu8TfOi++U2vSe1xxTKfTRKCri/UzbTHBEqF0yaJufRUbAsS8YhyL9QDT0tXmgtRhZMNwWeilWOEFs/u3xdVwa3vAfRcI0owWb5Y5RwuvmgyuL64IP5zo/iVpvSWQ9nCBUimAC/k5aWP0R1k9ToWWEE+AhGFhWcTD1alR3sVRK5oaP6fFcqYWs1IiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pmpWhXJY14GhO304yvq0Cn51XkgD/+r6zrsl09T9ggY=;
 b=bGYAiHmNyaKT1d0Iyzvo1PbpnJNnSgRqK8FBGuHN3vVSIVo/DacB6RAb2jgn0oPtu4tdy9cWJ02zn1BGdDFeus1iz3qo5gkmSbU0f6fwipRdg2gCv8S/3S4puVnPD8q6g62lF2JdkmNBpO+eHPWwJn/aMBq4gtmYnstgtBF25R1bw/IzS962qx6KPCLP9+hL4bKcauhD/vtrb0iNY75MTzAUZL+1dtF+wmFQB7jfAv/8F3py32iQBerxDutAdvLW3pXawCNLI2bwvtmHISCJlTdMHnfJqGFkWXrTedroNJmHqRVIY8Hqzls2sNYkjB0GQXk8KAJJNrw7wcCM6P4Rmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6195.namprd11.prod.outlook.com (2603:10b6:208:3e9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Thu, 18 Apr
 2024 00:08:02 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Thu, 18 Apr 2024
 00:08:02 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "Pan,
 Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 02/12] iommu: Introduce a replace API for device pasid
Thread-Topic: [PATCH v2 02/12] iommu: Introduce a replace API for device pasid
Thread-Index: AQHajLGe8MAFYy5tuku4PxjcbkG1+LFsKHTAgABAdACAAMZzgA==
Date: Thu, 18 Apr 2024 00:08:01 +0000
Message-ID: <BN9PR11MB52760DDE80B5C0CC89F6906E8C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-3-yi.l.liu@intel.com>
 <BN9PR11MB52761DF58AE1C9AAD4C3A46E8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240417121700.GL3637727@nvidia.com>
In-Reply-To: <20240417121700.GL3637727@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6195:EE_
x-ms-office365-filtering-correlation-id: 678c428d-b846-4830-5b5d-08dc5f3b9ceb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HYyK+qxlqsn4UDbJT4DzS6GNz3SWT7NeGHQqVBf+wHR+HNcL1BP+MBDFztDgPTnSYcqY4XXV2gOzQuKyDs2yY6xnozT7ECe5SABDRSxdCATGyztjh57NOHALxQWR0WRYn5hzU1ajEbZsNmAPa7yDrE0yFgjB8ioHC/8JVtzaPupFJx48MX2tuncSuevjbtp8gJs40WbupVCB+n35FQygvP+rkaUPoLgBkteagckAgUYURRGK5jMmImQLpsfVsTseaLED4fdae0bulILb+kQHKo4e+iRXYjnRXBJ9j2z/K1nzQ3ncSosG1VQnJkm2L80zMDH5J+2NHMYX8MPJGekSK5v6Pgs0yALoHgoj900h1j2I4miX+XXfRXsIQF1f9WUjRG9oW7jLfSum5IDt6JAvVyc2sSm5/DC4VuMIvmh7x6jtfXf2xe4Zf8J45xqXRP0cbkKA95H4tsu0tuGFQf8t0QGpixQriXQAq6eCZCPrw/+nGz/NZvRqpj9tx22nODcpxc3psWar3iYcqUKfeR0f/TNU3ctocsdYOx2qsSk6c7elFodK4VE/549KLGRMrVRxGKdrvMkqMwY8S4eKcy6lxrucgorZ0jLuvgjmQoLEEZqBgXpfdgVVUhz+tW+Y0hJvGXJFj6qV10/sPxZgSFDR0Zv7V33P3KVY4NzaVRFHJe6wp1PeATb7ucggB95u4rM5yz5FQ41WfkfSTL40zthJMMrsUmxNjSogI9ltcs9I3YA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnp0TVZaRDNTWDNpdkxuelRXQTMrRll4L0VjYzVZNlB2SEMzOWRDSVRSNzVV?=
 =?utf-8?B?a0trMklFNEN1VXZBQmxzSlR2amxvdS9YaWhnSjRGR3F4THJoRFZtVDIwbjY4?=
 =?utf-8?B?Y3pLN0ROR241YTFZNTFybEgzNlBlSUZ1VHBoNFVXVllIZHRpRm82QjNDeWE5?=
 =?utf-8?B?eFlsMitlRC9GNy83RERIdXUrWk1mVTZjajBVWGU0TFA4aUVQcWRXbXpGakl3?=
 =?utf-8?B?cFhiaFU3Mk5Mak11d3YrZlFkRG9CTE1ZVDlmZVRRYzJ4VzRCdkh1a1h4VkVX?=
 =?utf-8?B?Sk5EMWRtelRORUtpbGxZaTI5dkVyNVgrYzZCYk1MQndCUXZ5ckN0OHRmNUtz?=
 =?utf-8?B?SUxPK01VU2tab2JFcW9udldCOUVGSzhpcGhjMXBPNUVKYlRVV2ZrTVd0KzV6?=
 =?utf-8?B?em1Wb2xDSEo0OFZvRURzSzlZZjVEcHdOOVFhSVVDci9WWTFWbC83ZXovRC8w?=
 =?utf-8?B?Tm5HWktGeFUxd2NyM1huK29FQkluZzBiRU5WV3MwbHl4ekNQSTByR0tadVpG?=
 =?utf-8?B?WW91QjdmYjFRMmVmeVllaWljZmYvM3BGUThieU9HMHNBVHlHWlI5dDkyN0RF?=
 =?utf-8?B?bW83bU5tS3hhRGEzbGJGSmhvaDl5UXB1bDF6NmpJa21yMGJLcmwyek9LY1o5?=
 =?utf-8?B?ejUrNDBzOGhoTGdEVEFRVzRVMGNxVC9sUi9BSS9rUm9FMVFRZS8vbU1OUEk2?=
 =?utf-8?B?cUxhTWdjSU1CM09qanZ0dmxtQmtLRE9nK1kwRDdiZDU0QU9kekM0dWxoWFdl?=
 =?utf-8?B?eU9mYnF2bVIxMDlRb2UyeDhEN1YvNUJpMTNjMVhtNW9VRzZDNjYyenp2Wm1Y?=
 =?utf-8?B?ZVRZZHVNK3AzZlF3RVJ3dlhETXlmbmtuYitrUjU0ZkYzWC84RHBmTXBoYnBM?=
 =?utf-8?B?WVJWNzlUN2xTbElGN29zWTJJaDVqMk9FemNPRkV0VjNOMVVQVEtsWmdsK1lI?=
 =?utf-8?B?TE1Bdy9tSnVQT0JsRHI0OHFMbnFOY0tkVnF4aXVCdHR1MTJXTjl6aXY0b0lE?=
 =?utf-8?B?VzVBek80YUU0RjlsUXBGdjBSN0JaclFmRXpmOXlrVzUxenRBOGhBSVVNa2dv?=
 =?utf-8?B?MDJlM3JwZzJSaFFPZnh6cmpranJwYVI4V3BrU0lWYm5VclpCZ1dRdDZVU0NU?=
 =?utf-8?B?MUlBQWtoWEF4R1FURTVFaHZLVmVRU1NqS292YVNRRHpJbmhsOUZBZFJuMllQ?=
 =?utf-8?B?ekRWazdwVnZiWXIzN09sQWhwYS9EeWtwZVRQY0ZibWttYWZnQm9TMUs1SE9X?=
 =?utf-8?B?OXRiNUxDTUlRb0g2WmNVSlhrOSttc2hjUy9McGErdzdwMWd5RFpWZzg2alNr?=
 =?utf-8?B?NDdkdlloL25oM1ZGT2tWaWdkNHNRQ0hVVmFuR1dJQm5IRncwUFEyd1RWQTRj?=
 =?utf-8?B?UnpUNTgvbzErUWdaRzl0U0xBY0VBb0JYZk5YbGNlTXd5cWhNQTJKOVF0aEQ5?=
 =?utf-8?B?RnEzeEFTbmtUMEhiZ3dudy9meWIzVEV4LzM1bURBZjAvWVczaHNFTnRmZHVy?=
 =?utf-8?B?Y0NOK01lOXhSR01mcEhlTjAyU3QrQzFkMEVGS1YxVnRnUHpSaXcremd1cStz?=
 =?utf-8?B?YzJjbmFmOTdKU2phc1dUWktiV0orSXhVajBCTGdpUHl5RHNJeDU5VDhWV0Ru?=
 =?utf-8?B?ZTZBZEo3T25ObTZIUkJ0MksvZkRqL05pL0FXZ0U2bFlsUWhpQUVGS294T05M?=
 =?utf-8?B?QmxUR3ZNZ3RCdHdiMWs2Y0sxbkhzL1d6TUFBaDhkTlFzT0ljWDFYSllCNlJU?=
 =?utf-8?B?MkF0NThxWmpIWXdVTVJhNUFGUHlkbmxLc2E1c1J2ZkU2S0pBOXRKaEJMVnha?=
 =?utf-8?B?dWtoRlo2cXc3aUQ2YTRJdXhWNUNTVFFIVnNEdUlvMlRvei80bkZuQ2ppKzl3?=
 =?utf-8?B?bDhCNVBoRlJ0d1FmMjF0UHE4eURqL25vVFFJYUh1YXJZWEgvQm5oRmNQVWZm?=
 =?utf-8?B?ekdIYko0TFA4SzFSS1RQajMwakxZdzRoUEc4ZDAyLzloSFN1cCtFelFBTVBq?=
 =?utf-8?B?YVhJc2xPMC9TbGdkT0RhZkdpaVV3WC9uMUNMc1AxWmpVNWZ1MGNjRnZFQUgy?=
 =?utf-8?B?UjZBOUh6MnUzSFV6SkFoY0J0QnNYM1Ira0pZdE9OSlVXRlFBWERyL1Y0d3g1?=
 =?utf-8?Q?O4YzzQE2LGKXRlWCJVDMHmKDR?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 678c428d-b846-4830-5b5d-08dc5f3b9ceb
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2024 00:08:01.9500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IT23PG7X51gFXaljSNXy8BriOCPnE8bioLnBHKd4kYAcqDkSnETdJDiur8+xo5NPsi+WW4FsmBdFX8k/9gV3Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6195
X-OriginatorOrg: intel.com

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIEFwcmlsIDE3LCAyMDI0IDg6MTcgUE0NCj4gDQo+IE9uIFdlZCwgQXByIDE3LCAyMDI0IGF0
IDA4OjQ0OjExQU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4gRnJvbTogTGl1LCBZ
aSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gPiBTZW50OiBGcmlkYXksIEFwcmlsIDEyLCAy
MDI0IDQ6MTUgUE0NCj4gPiA+DQo+ID4gPiAtCQlpZiAoZGV2aWNlID09IGxhc3RfZ2RldikNCj4g
PiA+ICsJCS8qDQo+ID4gPiArCQkgKiBSb2xsYmFjayB0aGUgZGV2aWNlcy9wYXNpZCB0aGF0IGhh
dmUgYXR0YWNoZWQgdG8gdGhlIG5ldw0KPiA+ID4gKwkJICogZG9tYWluLiBBbmQgaXQgaXMgYSBk
cml2ZXIgYnVnIHRvIGZhaWwgYXR0YWNoaW5nIHdpdGggYQ0KPiA+ID4gKwkJICogcHJldmlvdXNs
eSBnb29kIGRvbWFpbi4NCj4gPiA+ICsJCSAqLw0KPiA+ID4gKwkJaWYgKGRldmljZSA9PSBsYXN0
X2dkZXYpIHsNCj4gPiA+ICsJCQlXQVJOX09OKG9sZC0+b3BzLT5zZXRfZGV2X3Bhc2lkKG9sZCwg
ZGV2aWNlLQ0KPiA+ID4gPmRldiwNCj4gPiA+ICsJCQkJCQkJcGFzaWQsIE5VTEwpKTsNCj4gPg0K
PiA+IGRvIHdlIGhhdmUgYSBjbGVhciBkZWZpbml0aW9uIHRoYXQgQHNldF9kZXZfcGFzaWQgY2Fs
bGJhY2sgc2hvdWxkDQo+ID4gbGVhdmUgdGhlIGRldmljZSBkZXRhY2hlZCAoYXMgJ05VTEwnIGlu
ZGljYXRlcykgb3Igd2UganVzdCBkb24ndA0KPiA+IGNhcmUgdGhlIGN1cnJlbnRseS1hdHRhY2hl
ZCBkb21haW4gYXQgdGhpcyBwb2ludD8NCj4gDQo+IElmIHNldF9kZXZfcGFzaWQgZmFpbHMgSSB3
b3VsZCBleHBlY3QgdG8gdG8gaGF2ZSBkb25lIG5vdGhpbmcgc28gdGhlDQo+IGZhaWxpbmcgZGV2
aWNlIHNob3VsZCBiZSBsZWZ0IGluIHRoZSBvbGQgY29uZmlnIGFuZCB3ZSBzaG91bGQganVzdCBu
b3QNCj4gY2FsbCBpdCBhdCBhbGwuDQo+IA0KPiBUaGUgUklEIHBhdGggaXMgd29ua3kgaGVyZSBi
ZWNhdXNlIHNvIG1hbnkgZHJpdmVycyBkb24ndCBkbyB0aGF0LCBzbw0KPiB3ZSBwb2tlIHRoZW0g
YWdhaW4gdG8gaG9wZWZ1bGx5IGdldCBpdCByaWdodC4gSSB0aGluayBmb3IgUEFTSUQgd2UNCj4g
c2hvdWxkIHRyeSB0byBtYWtlIHRoZSBkcml2ZXJzIHdvcmsgcHJvcGVybHkgZnJvbSB0aGUgc3Rh
cnQuIEZhaWx1cmUNCj4gbWVhbnMgbm8gY2hhbmdlLg0KPiANCj4gSSB3b3VsZCBzdW1tYXJpemUg
dGhpcyBpbiBhIGNvbW1lbnQuLg0KDQpBaCB5ZXMsIHRoYXQncyB0aGUgc2ltcGxlIHNhbmUgd2F5
IHRvIGRvLiDwn5iKDQo=

