Return-Path: <kvm+bounces-30850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E2E99BDF32
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:14:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DDB5284C36
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 07:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C2E1CC88B;
	Wed,  6 Nov 2024 07:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZUeJj9OV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7574F1C878E
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 07:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730877267; cv=fail; b=ixZU4OG7g7vNA7Ekvb+fnLWJpaa3gxRaWr7kr3Oc+2KS/LDGY1ueRkQh8ds/eIszSDZUUshJHrrZdYhwXqJxx4sHK0+c6hO1hD5p9OQ0I/C8Em2vqr46kp7GtP97NmQmrutj0t6wWHlTTgCA8CtRu+NcSH6BIwR9AhBxZhNkz+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730877267; c=relaxed/simple;
	bh=CxO2VqJwWSR9ONv7Hjp0CI+F5PxLDHc3Jb8qX3nk6g4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lqIwWdQGXaB7fg7qRbrECrgE6dggKfCRz5OhdAQ6+hZIQs4EjD6czL+GNiT8AtTGdp0l7fO32YI/oS4wiLXetn78uSHDAVIBdEXv5HPsrtJUHJLicmjsJwZBHZp5b+DyuvpM2PPUxKoKQbA9vy4n2ZH753sgyIHcaMlG38lIXco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZUeJj9OV; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730877265; x=1762413265;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CxO2VqJwWSR9ONv7Hjp0CI+F5PxLDHc3Jb8qX3nk6g4=;
  b=ZUeJj9OVN9Ek0tbimAWENhkFSEZMxViHiJH4pfFacRZ5AgTk4HeeSVy1
   qWxSMhirfpfkHo7ENPHGL9gxMBMQvGo/MF4ryoUwWo57RWboqkowzde4y
   nUls2DI44ZsGe/HxPYOZoFf5A+vN/hlpbp4RAFmekJVCGV7NOj7r1zY0k
   cacWspFkhJBaCCHjiwvSywk8AuoGcB3KZ68bxgBLLPnnokYvZCS2k6pbq
   MXoehULWV74GIHYeYkak+IwmSqW/4cHbKzK76McWC5qt5R1yAcP70VqRY
   qMn7d9tMKmVaU7iYzecq1dRZ40QovUkIGHwvcuOXeP+mlrJGLuMTm31rr
   Q==;
X-CSE-ConnectionGUID: 5OfZGNR1SXCnm3m27tWpRA==
X-CSE-MsgGUID: f0ktoIZFTIanCYlsomO2Pg==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="42041921"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="42041921"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 23:14:25 -0800
X-CSE-ConnectionGUID: xOHVbVGARa+S1xP0leaJ6A==
X-CSE-MsgGUID: E+xO/5y7RFmwsMx87G3FLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="84721301"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 23:14:26 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 23:14:24 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 23:14:24 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 23:14:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n+tRg2D7hIYUVP1K0RFz1dO00OCd1lOYi5VEpfhkFHMkS4Xy9Rbkyh3VSWjSyGClBgQiU6AO5qxRh3DTw3SUoe73jdGueVDVqgRCjyTYJLS+geasisCo+xUyTGJksWkTfuvsqoL/8DMiuqovhyt6r2pJzbfZWwrWZsf9Zho5ikM7k/ljq+zfyOs9I0NoRAlyjdDC2BqXHDpoKIPSeItATqxm3Cau4Ba6gvBfm4HdfTYljPBe4EASnm2F47l5FGfviQdIM4IWAhMJnONUTBSHFkBz1ze6NNLUUDsNe2F6/kLMQQWhPk+vZklHD3JDqZT/L1YSGrzcNXjmfhvYTlmhQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CxO2VqJwWSR9ONv7Hjp0CI+F5PxLDHc3Jb8qX3nk6g4=;
 b=Q9mimSr9JTUNO0Hfr8E1VufNU6f1PvZIcwOgaiZLlkWx/efjHuvYNdwqM+jGtJd02djPtNGKDJ9W3j/IojibAb12riDerqxFAIxKCKN2nDMljG0yFSnZ5ftApWvse+8j7+NWpzPobTNFVIoy81xaGdDGQTq+4pHm6p3SFriQGNE2g7ia34AtJ9Fs/HoEE3la0za++8rr9KriXGtMrNrRUx3p0L+ifwVvomWPfgjoP937+9vMJt+20FNX6N8b8l/zpqxws8cfCj476DWEtqRXXAMgThj25u414HWYlSeZMwpYAoW1s7zvXIqa0oN7aCip2CjmNC+nPBx/0V7QhtWU2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6403.namprd11.prod.outlook.com (2603:10b6:510:1f9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.33; Wed, 6 Nov
 2024 07:14:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 07:14:16 +0000
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
Subject: RE: [PATCH v4 03/13] iommu/vt-d: Refactor the pasid setup helpers
Thread-Topic: [PATCH v4 03/13] iommu/vt-d: Refactor the pasid setup helpers
Thread-Index: AQHbLrwa9EFYQit3aUKvMmAWrrsQqrKp2PMw
Date: Wed, 6 Nov 2024 07:14:15 +0000
Message-ID: <BN9PR11MB5276A33DEC84EE55B4E6DA9D8C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-4-yi.l.liu@intel.com>
In-Reply-To: <20241104131842.13303-4-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6403:EE_
x-ms-office365-filtering-correlation-id: f7bca651-8c13-45ad-bba6-08dcfe329fa5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?KfuzoGiZGt9GPZiBdWtd+MUK+go1EqTFOhcgSgF8isWRLxHl4J/AmA1JyAw7?=
 =?us-ascii?Q?b30hg/Q62HCxfCmprCMjuOpAGMI5pscQOlVz7U9Jm64xTwM2poyYwSHjIVns?=
 =?us-ascii?Q?vk5ja542HaQMblI9yKlD6Ln0RPsBfGMmemyTmXYySCcISYiP5UbDw+nTdles?=
 =?us-ascii?Q?XeUKsJA7BDE4qQ8OXna9Z9XW0KorVyq7JTXkTY7Pwo+LvF5AmzN5sSgqity3?=
 =?us-ascii?Q?4ln2nZVZqQnfCmaStzkE+p3jRpdq2WVCOGW64imE7VUOsOrG/yZ7r92O/4Kq?=
 =?us-ascii?Q?Wl9gvoBuXKHfcMBVuv5fHLOs9VLWJ6SAOb+vdXzM1lu9NQuGI5y6oGP0OC8X?=
 =?us-ascii?Q?Jjju8BIA/4MtlAQvbiuvtHCF1SgbxOdUC+x+SiKWzxb5WjSPqVXpxS1zxwpg?=
 =?us-ascii?Q?w8gqd+zk03Hdq7yGrwDdXKwGoz5SMU/6CGEnb/SIFGkDloUEzouLyCVpiRGm?=
 =?us-ascii?Q?F5g8Ye9drsVSTDCoXDWzXiVM/X0CYKtK51U2x+rw5rhRng3gGJq9gqdF/gT2?=
 =?us-ascii?Q?ouAWZfQofdn2jOQFKZYdI0h1BOO6eUfQU5U92KOfRnfEODuEA36RZgrdOF5D?=
 =?us-ascii?Q?2xkn30efXIDb6XDOpuL5B+cs20uKqEwyFvO+YhYSZ3mWUEabjNgcfwVcUd3i?=
 =?us-ascii?Q?c3Y7/QCGFQcMkmhebU8wEU2sfym+XByznuh4TurRXoFU/u0XUksUXly4wMmG?=
 =?us-ascii?Q?bUKFzwrcMCuHopYjwBcjMDjm63F4L6ptWLnLpbSyCunseD2PuCTv4XsppKbE?=
 =?us-ascii?Q?2Og5Ovtmw7K1bgGbAU5+hlZpPuJLxDcxkXUzq71T7svGY/oERoRkkg/jG6+R?=
 =?us-ascii?Q?RGlTe8YEGcyk7vgC0qgzSLzP1tkRuZGLOQ+2PMD/KWaxZqqoHKpj+y0vA0pU?=
 =?us-ascii?Q?G8AzdRU7WLpizvXuebcXEEd4Lw9+RE1yl4h9pY+3447PFgmSNx/ch2HhjDrh?=
 =?us-ascii?Q?sog3Btmu+LB/yNH4dMnJ/HwN3J0nrWTui9qWDWTe2J5uoyD4b4hHiYYJxmRc?=
 =?us-ascii?Q?MyU1+FsXr0/OPxUe/nBi7MGAJbvyiu76zRxVBBdXpYRqJU8GpE1fUMKkLeXJ?=
 =?us-ascii?Q?DqOFrt7rnR2GT/fYvqDouSc+7BuB0ex4qeIX9ViQGjgzG8Qy5f0lxyelwVS4?=
 =?us-ascii?Q?A4DUDhnzPVX9i47VdkPk3xMUl0bvtKebix2k+VW5SxU/Nsp4pNFYhoTdqPQ0?=
 =?us-ascii?Q?wix3UfKKV6zHt+yAjh4+9oG51Q53tu6mQ+hUrNw+N449DZWscOCMEJgzmvHE?=
 =?us-ascii?Q?TbLxOSNEyKaeDqW+1cxgN4ZoUanyM0Qa85J8BS7LcorxJYpgppyXuoFjbe+W?=
 =?us-ascii?Q?C5V2hwsNHhzV51SOkQfg6sN19PcrGv2CeXr5qc/n/14TBSAf5DQDrADeq9Vv?=
 =?us-ascii?Q?J9SL2f4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zO2fzptynEHhXZ2RzubV1dIWVgff3tZAI3BThgRP7GX3Eu1M9MOp9WpW1MO6?=
 =?us-ascii?Q?EX1oBKA4gFh/HXFWT4bn50rotHCn0KrnCUl37g8gyrNwV5XM9EURL2EykZ5z?=
 =?us-ascii?Q?Wn8O8cxlbTBV18t+rT0dlejFyUhsFNnES5hJRtYOp+2R3S80bOFEvEfyxORQ?=
 =?us-ascii?Q?ui4q0884qAIIdpJnFfBqwYUUOkpms9fyWh8y9MzcqSBCKSD/mp7Oat22gJJz?=
 =?us-ascii?Q?JKYBH96Fuce1YTQCxowhAqbE6dwz8maNRtmyHIkIbEVBZR2Aik9Mnh1w6eRC?=
 =?us-ascii?Q?nMI8R2yqq67+u/BKDLeShycizewXUzhd2Qlj2xp+jpfaMqo1FT2Udk35pvHF?=
 =?us-ascii?Q?a5p6uFalGwmPVbuYgQqbtMKTtDPQUQcViSld+ZU4VFxwCj7/JmAdR8OPpV60?=
 =?us-ascii?Q?XEYZufA/m8464Q5/Iz1pTUp1vbLIGTe+pkMqyYA6De5EzUpFWkXRbyXetvQx?=
 =?us-ascii?Q?acanrtNTVIFpHJT/e81jO2h9yzXlVm55I6VmtKsNAsixywOFPecEIY48oQKd?=
 =?us-ascii?Q?sR+A81UaFoxaamjx7S4ZdTkYgC7sbqlIv1beW3gGK3pkvKrKfCG+PV4n2ofP?=
 =?us-ascii?Q?u4VnB4ZISpizN5Im5YkgkzGU49ZvZF9jDqk6UOZ8SudwHuSYymbjLgSJPh3u?=
 =?us-ascii?Q?0mQCLObN57hX4/UwoNS7wpiCCrWqbFY1leXODtST/3dqtZpJO36Kre6ramN6?=
 =?us-ascii?Q?j5JIf/eT3rZmQi/CCF36bQ7ffdRUwkVFgv+ipo8mArUnO7HM4wvwm0C9/UVT?=
 =?us-ascii?Q?zp3jAiD3Xjk56IiqQwWw9wPSm83xESvfYWlvAcuwvaiuTPjYm4tmDj6UcDBx?=
 =?us-ascii?Q?0OYXn8zjgqgy+RJB/t3rlm42C1VEYvxipNWdFbdcFMw1zU50NilRkD37j7k0?=
 =?us-ascii?Q?VgqhLoBbQaetGU3R6/XeyqKsHtPkAgb5flt4BFvZy/1Hzde9Ho0yWF1YF3KQ?=
 =?us-ascii?Q?NEofdBwhH7ErQvClgtHqDcHYNi6ttcUADhVhnDuKv0hsKFB1Hnfw7NxQoIpk?=
 =?us-ascii?Q?Sjo+CggMD6iH6eWIekj+YppDZNMjwwkFvbt5v3vVznHRj9Uef0TJq60VhtPc?=
 =?us-ascii?Q?6psJJPAkQD4xWJPhBuRv1FV+eczzxv5UWyvpBT00YpQfwIbUNgK2jkXeG/kk?=
 =?us-ascii?Q?5lYQ0Tm9zC1QtzFDIwN20G47lw0xfLhqNo5xybtByMPoQH1X2RVBUXstbJy0?=
 =?us-ascii?Q?jA5nxkPggRBVGr6mjvMWhMbXP4By4c2ZRgCzyb5va8VwqF9UOb5Q0JxbjvzY?=
 =?us-ascii?Q?xrnQCn4QpWN6xC1r7ZM04Mt880sii635dIWWGhUoxQ2Fwfo/zq7c+fZuxOvn?=
 =?us-ascii?Q?IAymX9VedqkEbo+aQJtD3esUBLKie8/P6tIok5zzcG+9V7211p1hhvRytQ+6?=
 =?us-ascii?Q?hLAZYHuRhgVyI7VSA95GgHGXPEGuvAMdqz7QB6PIlFjOX68h7pCT27W22hoT?=
 =?us-ascii?Q?tqffpDLOByr48ieaBJMNK5+5HHRj56D06k2SpLvDg7p4c7TqfrtaLmMytlB4?=
 =?us-ascii?Q?rh8L6xSmPteYD3hmyEFBgaT9JwK6h2qtOeW8dxkaWckpgWUC06cLrHXFg9Xe?=
 =?us-ascii?Q?mmNHu3GRZRZXVoD+jA9riqSADxrpzvzr0pZzVl1D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f7bca651-8c13-45ad-bba6-08dcfe329fa5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 07:14:15.9836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OqFC/OIhIIqRkL4wwui7MsYt4gzVc4u53VovCjgpIZwkcnWFsfVeY6w/J2rCU27LxT0c/H7GXq6S6H+IKolF4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6403
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, November 4, 2024 9:19 PM
>=20
> As iommu driver is going to support pasid replacement, the new pasid
> replace
> helpers need to config the pasid entry as well. Hence, there are quite a =
few
> code to be shared with existing pasid setup helpers. This moves the pasid
> config codes into helpers which can be used by existing pasid setup helpe=
rs
> and the future new pasid replace helpers.

hmm probably you can add a link to the discussion which suggested
to have separate replace/setup helpers. It's not intuitive to require
this if just talking about "to support pasid replacement"

>=20
> No functional change is intended.
>=20
> Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

