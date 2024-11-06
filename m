Return-Path: <kvm+bounces-30860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E6EE9BDFF6
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:02:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85A501C233A7
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BCDA1CC8A3;
	Wed,  6 Nov 2024 08:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KEJd1zvp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542EB71747
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 08:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730880092; cv=fail; b=tDUWGsTWWFWtqtXeMcBTjkAVOFnPN/dQpvFR0YW057GvrCTlhypGs08/Z0pp6AvJv9Y8kUjwRmfDBEQeRmStxS84eo7XBsXNPmFpias8Vpc1PnfljxHPcFpNgfSO+j3n1hYgaT/bpIRSGsV9UOjB5/ELOQtXFelBJG4lXd/r6xs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730880092; c=relaxed/simple;
	bh=9R/u55/lNFz5+0JdhrxOjEBsIGB1NOLCvHeBhrOAZqk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iOY3ap5yPnN3N6WVxYkY/URKWo+8zElQcTLPe/bzDn+qhUuJF8MjhCp6tmnAybfSmAoBA6ATPMKlrJD+dwug+Aj99JGC1uhGsNgpqI2Bh6oEgyroD8eAVRNJFaK2f7KCHDeYntOgcGCliOvwAmTRNWwP1ebojgp1m5EBYNYBakI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KEJd1zvp; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730880090; x=1762416090;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9R/u55/lNFz5+0JdhrxOjEBsIGB1NOLCvHeBhrOAZqk=;
  b=KEJd1zvpNB9WnjlHPr5P+/K6F7KNynvRUGd6BfrvFlbHUQwHleb6Kbh2
   qBM1V/Dw+5amDEDmbM9c5FzBZ+efoPZ1ottcJHuzbIMKamL8cZMN8rLoU
   DenYp4bTVFv88eZ+YjQmLtVCLxKLy6PX6FhXKDWJiEyMphbkiLPqUbpHV
   Ho/8RuaX2JWChuFXvwuZ1QEEASRBOPsk4kBl4oScHUyTRgiW7QdCw2ONH
   IpJRrADOI7oRhnOUj/0zO4wtYd53L+WEP1YyNlLi9R7wJH5KSXJM1mofL
   CpjfQc+x2rvf/4qEFUI1ZPg+lr7snAd6ydEjT0PB5E8XNp6ONzjMmU3yb
   g==;
X-CSE-ConnectionGUID: EYGra5oKTKGcdbeeKzuKLg==
X-CSE-MsgGUID: YzTV5Sm8STKwhGVpb5kigg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="34359010"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="34359010"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 00:01:29 -0800
X-CSE-ConnectionGUID: 2JKWhnETRPS2ndp+GbC8cg==
X-CSE-MsgGUID: d4ImThOyTOa+Y4gGnztqhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="107731664"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 23:59:18 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 23:59:18 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 23:59:18 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 23:59:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CwkLwphZ9pxK++1pLxv9qSsBVEK84SVVCUFT0lVTd0SeSIWzkBld3dK+3AlEBk6D8aCUM14xZxI87BayfzOkEJWRFcPvczVPlSNREcSoNHUh3web41RY4vjYkF1zgNer7ViiyESJdnPuy/Iu69iz/OfBY9/TtRCztjbd/GI3dI0XGkGBiwtOPE3w0OzO6nbqRPaIsWuwl6AJspYNvmVqSLqlBDQBdVielrf2s+vuCSdtUGbdkl9FtTGFYGil8nHlmUf/N8ipbnUC7wy9TT8pF0dpGNzZVHMwv3/213ZnlGF7H7FYo0u1dZmL6pYbf/nIjQvBRJUKdi1a3LhHnh4RNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9R/u55/lNFz5+0JdhrxOjEBsIGB1NOLCvHeBhrOAZqk=;
 b=bLBbtYzwIpabbK1A1iogLVAdYuLDIyLVXWy7VBPFF2rrfNd/4xB+9B0mkLvomYPaZP/sIrp8pkwIxXvgCtMMwnYyLQHPh1zWxZ179cPPr+Dmyqk4dJwYCIZCLLRDypVqd7RUSmu1Mv8RLAQ1ZJWHjGi7KA04eeU6c6Y2vKEU/ed0ec6UWbXzy9wnHuOYObrEav8kYaTg4U5ZyVVJ/bQ4HGQBQ56DJqqCfsvgoD1A+thRseUYqEwwkNEsNGUaRZEv6qFmVZUvHwKAahyaenRzvN99uyt9UgPcUqt9BTL+qivBfrwHXHtO07XWJy21gw5vFcuj3J/hl3xwPUt5p5XEGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB4948.namprd11.prod.outlook.com (2603:10b6:303:9b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Wed, 6 Nov
 2024 07:59:15 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 07:59:15 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v4 11/13] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
Thread-Topic: [PATCH v4 11/13] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
Thread-Index: AQHbLrwgCcgcCX71Y0C4SXwzGBnNu7Kp5fdw
Date: Wed, 6 Nov 2024 07:59:15 +0000
Message-ID: <BN9PR11MB5276D7C4806189DA6633ED518C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-12-yi.l.liu@intel.com>
In-Reply-To: <20241104131842.13303-12-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB4948:EE_
x-ms-office365-filtering-correlation-id: 25507dca-c4c3-45dc-1486-08dcfe38e873
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?N1dBoGKCWmBCCvzxI+nSuvE8glhOH7a+Bc8QRYPT5bBWI7iSwd2Ntq3kcoE2?=
 =?us-ascii?Q?QLGDItnXUvISiBegGhQMFEg5NT58zMo+0SNapVTr1jCaJrsBj9A47mWkS1nt?=
 =?us-ascii?Q?6Qztuwf8HTGFaZvbaHsHp8cKVr8DOmWJVHibVyas0Qigyl7u9CHjdfM6kNee?=
 =?us-ascii?Q?XjoJS9du9fNyVxCnYT0jeM6QK+KwTOlvUKz2WuBJZQkl1k9gpwvxNfkv2I/a?=
 =?us-ascii?Q?H3oNkGtDw7lVzo8diei1U/RoE05CS/bXnbp9HXC96/oNcTE0YwJdp/l3EWu+?=
 =?us-ascii?Q?v98NKUOQD9wEdqpPsDEdY8UiHo/hE6u3ix0sxcK9sLEY8F7GCuVxrIkYPXGV?=
 =?us-ascii?Q?r+oOqRFpH4h/UStuonYpc7lWDbyVop5igozqSF3y7gvS48SbsxVKPKRI/UJu?=
 =?us-ascii?Q?620IIiRV6XgW/SpqteXQbsyx608iPP1lPLwTT/nv2vErfDveC9UiVNg9kRQ+?=
 =?us-ascii?Q?zOrAclHHsQu15orJiZiypXcDrOnMMbiiwIl6/zLtXxbQn4NqE783h5sA9FQn?=
 =?us-ascii?Q?EPdnr7+qGgut/Iynhti59UH4sUxUBrL+lKFIet+V+57W4I176dkzR1wcK9eE?=
 =?us-ascii?Q?5v/IqIQ5rUL7a3xvH2Zj117LtOCdTYuH6I7mPlMHVqHewutnUO6Juvil1lqi?=
 =?us-ascii?Q?QiP0B9gUlzkfpUT2E4VgIm9OSLGSFN85yDTI+d80kZzw975Xju8jHTASyYOt?=
 =?us-ascii?Q?1d6NGew3bT3edGDD8A92vKVmpD7A109me82iyusRy2Qk1/UgjvUuDLarpuUe?=
 =?us-ascii?Q?b/8fpa3rDAMw7bbIVIZ62xE0CJnUmX1ekVlu3/prqYvaR1CbD7+bwsPXkYVy?=
 =?us-ascii?Q?V8X2NZIBKJi7fdTfUV99ggVnCM3IpOP5V4JxgINnYrO5hTnjmLdo0tsHSMDV?=
 =?us-ascii?Q?UXuzR5979AHKkjA4Yo2qM5P2+tNXCfVEGrSPT+bem9vLLBZ9Gm4CfrFh2JVf?=
 =?us-ascii?Q?EmjJpWRg3qraExbPPNi7E8hnk8znUsR0d3VcrBWR2uLD1zImYOW5pAPkoXQ1?=
 =?us-ascii?Q?l2C885biDjPgSloAjVm/iV7LAVCxsgWIQaGTZO98zbub+UzT2l16MJ4H+UTt?=
 =?us-ascii?Q?V7qwMFF5gCZiyur6l8kSrCkadELbdQzI6pwhcW/peIsshmNMcv7/NFRwD87S?=
 =?us-ascii?Q?lmP8w43RgWsUXlEmshBwExBgKOax4IqaxMR0qor0l2mslPlgaaCUV0y1wwWe?=
 =?us-ascii?Q?WCIOZQsaffC6CAFaYBgAzAuLOUvJ6WV6JvMu4+wW77Yij5EgZIJSlTKra/lx?=
 =?us-ascii?Q?DNYQkM8nAnQ6ZiyzOgNWJReEsqBYUUf8hHpb83IwjFEkLGfR0TLPEmpDL/te?=
 =?us-ascii?Q?QAC8EBkWucVavjfLgnigUuoXtYJtV0nS0Fx/udRlgLhnUUK+L/BZ9zOe/gul?=
 =?us-ascii?Q?a1rVccA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vS9tiA4s0R021ltLl11YbAMGqsfWD03g6fFbSUieGbjAiNAQoMsuNfpPpPEj?=
 =?us-ascii?Q?ABJouco1y0kPvMzrNclBUMhKqwcJzJiAz8ymA4mNUJTbgsJAREbC33UxXVg7?=
 =?us-ascii?Q?tvvMxDrIheIywHTXjCeShh0UwgXdUpiKJMgmoBGnThrrnKYgaGP4NVt3T4cw?=
 =?us-ascii?Q?a0WRwVOyDQDyeLkP8cvhA4uf22Q0xAyJpiw2IpKVqi6b2SQmJ4E/vALmRf8X?=
 =?us-ascii?Q?iOJk6zeOcfTor84z9/ml/7LZJwybgTMI+eiE4CgW4OL23F5JKX3vVuovuKDR?=
 =?us-ascii?Q?PyNJQk8H/VWGre8ARD7GHVVHttyJwEoQFBq53PWS4/VP/GfMFhjkXxlUt37L?=
 =?us-ascii?Q?DnnVaXKyzFNZO0UPflW7iWobvoiCUJqhdsp1lApwN+MQKCVanbV2Y5EIfjDT?=
 =?us-ascii?Q?/13VrwEGffs2eRBXY8XlqDARyHurvrPTA+lPykAm7+/falKMcmIIDp8bhEhg?=
 =?us-ascii?Q?/9p5aR7+BUBPnBRHy+PouPquXXlneEMRQ7l6QuzmLIzApdkA/vgGwgEZGj/x?=
 =?us-ascii?Q?WIlEw9TLkOXDTnEIElrlhkrLSi/UeOZGVG/O8ZtcIZC8aLF+EUzH8RoXse0z?=
 =?us-ascii?Q?y5WWIyGNFYH9orFdlmWXTRfF0Nfd2dBqpXSrNJHurBhPVlHbZbvoYOABQvJK?=
 =?us-ascii?Q?dRk8l8KrZnt2vu6E97gcr3Kt1PsOAoDl7pofYJj6o7J+ewoV0i6ZpiqBFVwe?=
 =?us-ascii?Q?N7U7DA68Z9rLbZUsE2NEZYpZ7S0DPPfL1GXyKoKuyVb67o+307oOe6ANDHMx?=
 =?us-ascii?Q?4RzgHvUyReSMYyZxsaPIzbs1Dlhqtn/P4dCIze8FIIu6tBxSBP0OWBIuAGu2?=
 =?us-ascii?Q?TlGryFP88ZlhKm4tINlVxbZ7RWAvwSDXtH3Hs9Z1ZB1qS/kPRXayy3YRgPTc?=
 =?us-ascii?Q?WaCQ9PEP41IEWJHG9RsGAlSODW86OxvNpHdq+tBg0FVpJRY43r7Gs6zryq5u?=
 =?us-ascii?Q?1I1HWMMADcoYCqvtpRBV4m+vtsmjFLjBh9QowJTqZqoJqs1NLRY7yVH9ZHjV?=
 =?us-ascii?Q?CsuA4sgSWSDCD4YzpWN0pyBlNUYo32rApE2jgq9h3p3VosC8zk1CYJqRUjvL?=
 =?us-ascii?Q?hjOorlMsk/PPVWetWoOi5VgKofpE7AFFIspZ3tOw6Xwf4Zs7aJ/Gnv7hVIZA?=
 =?us-ascii?Q?XB/5mAet5kERpYkj0z4ouzTr3MaA/SdbKnkIrmmlTGgpOOpsufr9jug91pxj?=
 =?us-ascii?Q?DjBKaTi9WG+kkm468pAfu6Z2/fxrWcJeoTQm3tXEwGk4LVkTNHyaat9IJgOc?=
 =?us-ascii?Q?caVFYsrOGWrRhF1oVOob7TZKmYtb4T0cCiDWFC//hofMrwUXtbzgRHgvrNO0?=
 =?us-ascii?Q?uFf5hyHUniUdITtg50yR9e++Pr3UltTFoq91Keg2apnI+/8aCQesFpVhYBaa?=
 =?us-ascii?Q?e10iBykcQjyZ/TdmWwUwOQhlH/YqGW8fM4Yglhz4nRthDV/2On4cg5q5MAMj?=
 =?us-ascii?Q?h4TC985Drfuhz49Awktjvp1TtGj3kW15w/8hAMuFrJ7ZHzxOp3NGIURgOTZc?=
 =?us-ascii?Q?KMxU5TN/1IA6arCmUG/xhT/ugquG7Ou6tQHjoAeuSmFbvXHKKcLUsuQghS/n?=
 =?us-ascii?Q?W1X7egeX18dfK0ji5SaO83yzp1aK68wZ1OogEeik?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25507dca-c4c3-45dc-1486-08dcfe38e873
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 07:59:15.0896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FQhWMBXpXl3fSnAGrIw6FpkZxluUtlGIDgHhkC7TRTwBJLR4oLlQJvfjG03wnyWF8sg8mlGPZBCyntGGkztKkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4948
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, November 4, 2024 9:19 PM
>=20
> From: Lu Baolu <baolu.lu@linux.intel.com>
>=20
> Add intel_nested_set_dev_pasid() to set a nested type domain to a PASID
> of a device.
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Co-developed-by: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

with Baolo's comment addressed:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

