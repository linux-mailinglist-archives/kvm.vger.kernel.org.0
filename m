Return-Path: <kvm+bounces-29599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D32149ADE2D
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:50:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F36681C26265
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 07:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F391A1ABEDC;
	Thu, 24 Oct 2024 07:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JHv6fc3p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4164F19CD16;
	Thu, 24 Oct 2024 07:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729756217; cv=fail; b=aHrrKReYOOuhWH+SQzqQGH9mhVYQrfJYe2QkADZr4Alj/ea1HT7aUyFiBbeicZc+Bj9yPSBJvue5GMu98ZhXC4V32a0724R0vmQQG1Ml+WGJVn5hUw+VPvAYZ8Fmdubo7qIPOZKQKWR+rFv4GHV80dEmgyr8n0HjBD+LqJETswo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729756217; c=relaxed/simple;
	bh=sDxxqq2zL9nkIUYh2zgMRk6WY0tHNXNg2S/rQnPWx38=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gFxEIDdM9r2M0BJ5haCWwiZqRz1e+aUH8MUeXU7f6OsCuAG9M5jz9m8jFmMaagUpVoE3G5o3Mws9+ttkAEHqIfEd1weDcVo2rXhTbGZoAn4QH7TcUTOSFccsMSxqhsaCb4OML5igfLWzbhhwWJfEjCUG+93ojLxPYuTX5EDTmxY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JHv6fc3p; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729756215; x=1761292215;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sDxxqq2zL9nkIUYh2zgMRk6WY0tHNXNg2S/rQnPWx38=;
  b=JHv6fc3p8V9UTz0AXhxFKYMUyP6/G2FK6HyhEWFUIruQ10d+OPvxz8QW
   SdNdZ9Y1DsbMpZRFBsVuQ/OyU29EuksXCrk2NO4AlQXybZRW8kzgbob5T
   QzRE50Utugv9Xss0ZC1CeMgh71ctIXGCbqBf4uq1290PfM27ZzeRQPbHj
   z4lJsqWOr+z0ms/LA76RaMTMKMi8RABGAa3zpwRH/rsuBsRwjiVxatgUK
   K9cz9ra4xzuaG8hAptK6pVCEpiLHG4SBEYAsP5sxtBES2Kbm5XpyZihFk
   8jb55N/a7GFe0rpFr3MSiGPZIkWx3wQDguljMHwZ0bEujbQaNijHiHBra
   g==;
X-CSE-ConnectionGUID: d5JlcdYeTwaOXoISB3TKXg==
X-CSE-MsgGUID: OftZlhy6ReuvvOQZnBIeCw==
X-IronPort-AV: E=McAfee;i="6700,10204,11234"; a="33281748"
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="33281748"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 00:50:09 -0700
X-CSE-ConnectionGUID: h8eVmri4TwWaZiYZjVTc1w==
X-CSE-MsgGUID: M2OFeP5eSUm/LkBqlNERDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="85307862"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2024 00:50:08 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 24 Oct 2024 00:50:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 24 Oct 2024 00:50:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 00:50:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pOUZomURynJKFKsxXQu4NoguzKqByf9uhrzyDQOyxMiSPDadHax22iEwNX//MecueahRFegTEdL56vnp1qMSycD12EWhS5KQulv6Wg8XOQxn+t6DOGPSvUYqubQ7zE+qC2J31sQxrVqHW1siwknuNIHOGUmah/QujavVJapGzkORcOinmsOXiX5VswLDmOaxUvBMzMsOprhU1aekBS2oykeqQmP/2syd4Pptx1XCuZB9ajO7fkpObC9sFL1G8axcyF74tVGH9KVM9EAWJEWTKjHHn5uvXclts1P6ZRMJtmr9IrhtVWmKvQ7WjdYTyt01kw+3AS8TEjKU9EeEYHhtyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sDxxqq2zL9nkIUYh2zgMRk6WY0tHNXNg2S/rQnPWx38=;
 b=azUprPglmdNpI5WdL/T4FPL+ds2k4uliRBZT0rxjvnsDQx1jpuDIbgavt14qnvTipOyYNqXTxc4UXU1Qd0kPEQHzTjI9Gff/diQngkP/0e+igCTb1RxZL/IrwGTGNpfvtzQlTaJN0QLkGOKXY7xsDO2n0ZCh8WyGm67xuFY2RYf+qR296KYIcbIslYU7lnWq96OcFHRczgB9KMqXZkzhgXDqDZM4yhsy7HSmQixADBhtVdGV2SN/kVncCHFIMdsJWIKOppyPcIHDxEABW9GR29gJkLQE1uR7m765Ne1qy7g9ZIaieVIYn4zAKb7VFCUOWfePkDhq1DZRU73uZ24kqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BY1PR11MB8056.namprd11.prod.outlook.com (2603:10b6:a03:533::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.18; Thu, 24 Oct
 2024 07:50:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.8093.018; Thu, 24 Oct 2024
 07:50:04 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, Hanjun Guo <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown
	<lenb@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Moore,
 Robert" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, Sudeep
 Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin
 Chen <nicolinc@nvidia.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, "Mostafa
 Saleh" <smostafa@google.com>
Subject: RE: [PATCH v3 8/9] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Thread-Topic: [PATCH v3 8/9] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Thread-Index: AQHbGmeyU1B+CmovGkCGDGOQ5Dk1ILKVncdw
Date: Thu, 24 Oct 2024 07:50:04 +0000
Message-ID: <BN9PR11MB5276B2BF2513F22627C6A04D8C4E2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <8-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <8-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BY1PR11MB8056:EE_
x-ms-office365-filtering-correlation-id: 95685ffd-f179-48f6-36dc-08dcf40078be
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?VuHOi++L7V5Yu2xx+4yNOGBJDZltN+4PqjLq50PojubmgMcQf4JqwJ1rkVKx?=
 =?us-ascii?Q?okmcEVIStogcIUZBx249T3g4U61xe4RqEPVg5PVPzZBlFsPeul6lkLvcephV?=
 =?us-ascii?Q?B56od3jTaQpIgdV3XZ44YhHa8OfnMDw4TC8eiTM05wnBON5yHwbMrnGi8Bk1?=
 =?us-ascii?Q?kbh5j5SaJkOtepSEcCWWlcMmLwlEparr9Dxlrk0qVfSr2vMdE7vW64iT00Fp?=
 =?us-ascii?Q?bjZxDGGRHTeNPJoX6uOoQcgYGoIi7CCxku7nMpJErI3IQgrEb5jnQkCLlUO1?=
 =?us-ascii?Q?w1e70B1I0Em+XdtgOwJ6fowiFkrCPfVc2xL0cuzpd0STE2gAFpk9Xk1BJ1N8?=
 =?us-ascii?Q?ISQ5Vmx3Rrxr9O2Dj0HiJBKWAhxfrKFTn8DDkXUp3qZ7qlYJwgNAnAYIPXiW?=
 =?us-ascii?Q?IWz86gEedBx+V03RoYHXAHtJ4LgBEPqNogGcdw8izh5yDtY7D4vTKxqOskab?=
 =?us-ascii?Q?0JMmJ93vlQa6wrX2B7aIuUVALgtebdAvgIWdEzYcu8fB10yaUHMX/Ols1T+T?=
 =?us-ascii?Q?1Pyt+PW7hBd1sXeRTPBDR+Zi4rO8n40EAWx7nTR+dTgKSqN/pMGrTJny4i4S?=
 =?us-ascii?Q?xP1Y4fqtquX/odB8Tz9ktzhLFTKCM8uNpX/CnBC1Ef+UTuITbNI2shNuKZuU?=
 =?us-ascii?Q?MV1yPjBsHl97uu0LId1qPmItNsqz9yXYoq97RQB+XwjulRI3j08FeDtpw0MO?=
 =?us-ascii?Q?IIm2C4y9ntHnquhco97Wn4PwbAQxb0EFuWIhfp/CvNO7KRW1ZCw8yhaDeKYW?=
 =?us-ascii?Q?YfBI+N9YjwCH4un25wSDigNSv8xfmXr9DZeKpWj6TQlS919LamZvsXKeUMx0?=
 =?us-ascii?Q?FcvDuUYE9p7aBiCXqdivAu3LbqPU3o+7/L0IG9fmPk/vSarje0kx2nBTCylA?=
 =?us-ascii?Q?dpDFER8bZE1arowna/BMZDizDRaBvhiXfcOdGnVm+fZiMjIcha70osGpZSRv?=
 =?us-ascii?Q?1JEXSZPAaIXQsHufn6AOqofhNbqNQUq3E3UTN8xfGitLxhcE/fSAlWyAGraM?=
 =?us-ascii?Q?jzH8wMpNU1u3dZ97b0inRA5cLZ3ePoFOqnzYv+tvTB9FVlgUDyBxB+VIFb7G?=
 =?us-ascii?Q?BcTNgUlqePVB0+kjfmWlpKd/n/OqZo8h7cv4ExN3VzmFz5j3f2xbb9vPDNuW?=
 =?us-ascii?Q?QuATZE/FjEM5eUNJCRz1Gr4dOwnpLuLu1jpFystSqiI1qcjlk5Dl9tZYDBj1?=
 =?us-ascii?Q?YtOieXtN6xkAIwxwlqGo0KuC/FPmMtQAQTxHyzv76xW0fuyq2H2+fDJdbM0v?=
 =?us-ascii?Q?lLD6OCYpCg3LdVoPgbVviJskm8KozIJjnNxB/V5pSRHztZztIO0xj0kqXrec?=
 =?us-ascii?Q?leJJTdAd51KQ3/TN/iWrQy9PKUhb/gVAjz50fy02omYdZ59AiK3Unfl+Ohln?=
 =?us-ascii?Q?LPFDtmpeJEDT74xd0i129Vseit8C?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A8CBBiTVRc7V2gW1Ss3Sl52NgkSWUh2gt8T+Ojbs1I2cvbr90T8DfBg574QL?=
 =?us-ascii?Q?S/U1yjZSZx57ATyhZNjyq72b0Kj5Z/iOcFiEpFPzVbpT3PZQBJR2fInGQXp1?=
 =?us-ascii?Q?kxmw08U0GxL22+X7Ta9NrXZpNzEzLoHY0c87FTWLs6dpL5kJFvJN7j/EY5yl?=
 =?us-ascii?Q?+6idbHOx9gFnHUb+eegt07zAseU9FKJJzG2SCJP43/x4uwQD8NKbhWYVDWry?=
 =?us-ascii?Q?I8zCQ1oY+ohHjoan6kAiScp9DnrPFO6qLKwbya3G+iaVQB2w2p3ArsHsHIGe?=
 =?us-ascii?Q?fnvF0wUP6Joo21qPkn6Vz+0+Rb5gpUyNiOCAdob0vnE3b7ZTeH0e5bx13lOs?=
 =?us-ascii?Q?rgdnyZEbTxb8apE8mRjL0VnUpfBTsug8TXiakF3wwSaIGKTbeQi5Hv9Z39jf?=
 =?us-ascii?Q?Z2sk3qcdqr6U5KR83pnYaP7IiBdt4mQ6pfgvqoJNIfqC8EEIHcNqOHESqJBd?=
 =?us-ascii?Q?ZRIkyo6oxH1P3rcOP0ZAvh3D5ccJmxv+wQ5gBDvkkpgA1GFuAX1o2x/vGgQa?=
 =?us-ascii?Q?fERpIQgxK5z43LboND/J6tE/NR6JxRuxaXFdLXVsrWI1hSwVURF/700gBiy1?=
 =?us-ascii?Q?BiKSTtsh9iNGFKPVmmjIMIItZnTACRu66X8fw5IPVPGbVB44QuPPLPzkuc04?=
 =?us-ascii?Q?4rLab9GxQ/Y8Ywz7GjrCgCLxZYlNC8dzvd3OXq7J1e9QESg4qkhGWF0BcSTb?=
 =?us-ascii?Q?3cSkK0xdWg4gdZV6DR4tFR7U/t9DJkI1RhfBHm8zS1+yXI9b9nqEjn1AriaZ?=
 =?us-ascii?Q?UlITRPGqsQDzc+J2F4avixGFtQ+o9ADAxDRu20wjswgeIvBS4rQnUMrE2r2e?=
 =?us-ascii?Q?yg+hrQU2FEyN2OCmfj0nLZ04Z/oLrQit4ON/72UNRI9BmPaggZKLkk8Ok5jn?=
 =?us-ascii?Q?Eam7WRXCDsamkJl42gt1IrUl83W/5IpS4OaWmaMDnODoebpG1UcmiwdHGqBt?=
 =?us-ascii?Q?wdsbjVkIgnhxHxLVgm9IzvSaDwoai0Kf6cDyv2C24i4Ou3QlcjcYaDNmn68R?=
 =?us-ascii?Q?GlGaqlZ76PHT9BnxSps8Z126Vp+QugcOUuCjwpFzD9j+bkyq1Bt1UOnGc9BX?=
 =?us-ascii?Q?raNCruXWPbUmQXXSI5n+rKX9AnXsQ/bSovlJtjkP6Vfa2dopGfkDL1O5vOJJ?=
 =?us-ascii?Q?sE5XSbqnsm7BtwuAs2YGnQ5zFNLYhqGy1wm1pLdUjpJzfLmsN1D1s7V83OrI?=
 =?us-ascii?Q?H1zQTMdy2/NcJMhxYEn7IHvrQ8M0YE1C+mSt6Vn0yyqQ4duzjCluwvUlgX46?=
 =?us-ascii?Q?l7NzGxS9/htTnld0OxQs5GfdzSNIt4dhzu4OGY8KK1VcBQQ0srqbf7dr4E4R?=
 =?us-ascii?Q?TD8RgleG/HRxWdbwlb+E/im6c3I0Wc/dlTQRv1u51eBzF4mqCP50sGjIrx1C?=
 =?us-ascii?Q?/tdZiqH7A+j9DXoq97OIq+ZMUwQWuu89VAs+84gBAK4DB1Aa4Ekga4TuE9Wi?=
 =?us-ascii?Q?uXx0zAxLvY7RMMwM8msQq35YLXg80NT6adt6ZXMy8cODU/FoMnBG4Jvoc3Wm?=
 =?us-ascii?Q?eRRFxCo8bR+YD9VrlS8kbjJ9M0/YV7w/7aUO5ywRbTI3kKtGa388nYkESAkv?=
 =?us-ascii?Q?/pWgE9b+wt9cNUAVSG1wapYqUSp5qN7/v7ScEJvc?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 95685ffd-f179-48f6-36dc-08dcf40078be
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2024 07:50:04.2151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qAd+DEr6IRpIDIXbgDDWoyBKt//1BdtoValXVnswRhjCaIg55rIolz7slvbrrGps1C+a8eMV8X6uznozgoZaaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8056
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, October 10, 2024 12:23 AM
>=20
> For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2
> iommu_domain acting
> as the parent and a user provided STE fragment that defines the CD table
> and related data with addresses translated by the S2 iommu_domain.
>=20
> The kernel only permits userspace to control certain allowed bits of the
> STE that are safe for user/guest control.
>=20
> IOTLB maintenance is a bit subtle here, the S1 implicitly includes the S2
> translation, but there is no way of knowing which S1 entries refer to a
> range of S2.
>=20
> For the IOTLB we follow ARM's guidance and issue a
> CMDQ_OP_TLBI_NH_ALL to
> flush all ASIDs from the VMID after flushing the S2 on any change to the
> S2.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

