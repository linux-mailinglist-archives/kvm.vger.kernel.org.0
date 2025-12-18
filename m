Return-Path: <kvm+bounces-66215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B25E1CCA7E2
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 07:36:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6A2403020356
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 06:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7723227A907;
	Thu, 18 Dec 2025 06:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ddb3NDmm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47D232938B;
	Thu, 18 Dec 2025 06:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766039735; cv=fail; b=GnXFKzFhRlDl7zVV6Q3uhRM/sXKzF3suf1laLfr3sbNpo4BFeEeqCfxpxCecYtPJyGmLvl1ZouD+6MeUL3dw1mKkvUu75RMBDnWM8W9V2Y4/oHv+S7oi2vRyS+0hkTbemWx0/MX1Q+aPdPQpdAnIIFbNQ3BI381RGizchu7qXJA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766039735; c=relaxed/simple;
	bh=aF/ODfgYg2c0G6DToEWNLwztCVFgHkRajWFhaNHMjo8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LBUtpU1dDmagDmRty+qK+9etyoZlQoi9TqOP/BziItxbgxHswWytDlk+eURompS1z+3SOFf3AxUGRkDYK6lVozxN/PTn4445Ax+x+0vKVTr04CmUFVbdpbboSTbohZICCeYnLI7BfXABAXvA2rMCOjjqgZM61u1LxTN+CXczMdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ddb3NDmm; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766039734; x=1797575734;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aF/ODfgYg2c0G6DToEWNLwztCVFgHkRajWFhaNHMjo8=;
  b=ddb3NDmmakholCL71iQH7v82BfZjuaIOLLfe0J/PjEyeP9Zobn6Hi61G
   bdGxXAT8kxYW/byQ+sLjD/a+wMm2joGA5IKrOtMyrrCYstxDCJLnXAwC3
   CU++ZSHDixNF7+avmwInAWUmW5ZDmQO0gfnvi3hbIJCEGTu7iSI38tVSG
   Ea594BdpauhiIvf8rlDVEaC+bMOpciPMt6puNwhP3vo0q94Oecn7AZdZ0
   ULNasqzSBwLxYyPhHjEtTO3tSm3Z/OvZ9R7Wqmc5GOy9Cxk8biHdYHrD+
   M2nvuwrrhHMWcJVrdoz8xmlnHupSudEFVwbhFYfIo1sAEK93jWE+F1EtX
   Q==;
X-CSE-ConnectionGUID: GgDrBIUxT26u+5c2gyKD/A==
X-CSE-MsgGUID: VCcBPOqRRCu0uxQYbRnafQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="85407631"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="85407631"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 22:35:34 -0800
X-CSE-ConnectionGUID: BNrzbUtUSfGe7uFzkaA9dg==
X-CSE-MsgGUID: qfKG5OsMRvWOhZSjsJx95w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="198269515"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 22:35:33 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 22:35:32 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 17 Dec 2025 22:35:32 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.10) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 22:35:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lEbKIxUhoQyYk5rJsCvqbyYgIa6dVLhUSOm18OnEcvaznLHymXTpxMhfVIFEJi79MQHAV1rLLyXobIZcGk6z/qB9nE061dfvaGMxy+fx3r4Fhw/3Ro0qh2zl+WaU9G17gP/0Jey6Lw/wO2eigWzIUP7iFOfNIQyj9dzYnE0i5zFTrnBlfe/eukKHVSH+cV5+/XraY2iC2KdDMyDN3IsNBaIxamWO51ozG5jyZNtUctf97DIoGwD28pWnmeFyLF7Ws8Dw6eHdzUTVKO5IYj2acGf1+EG4+QjfQR/fOxazYEtt7bHI6yadaBP+fAYkxiqAFaU7wVaXHtfM+4v7HbvZqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PVyj/GPDyO3TvzEa4sue5smAporY3wn3zIK33Crmdg0=;
 b=CIVaSTG5XsPGSAoSxNoO9teRO5BVN9rwjed/AbHtPg4q14S8D3Do/fJqW6C+6aJ5X1pVj2Bi0NTgJzMVC2w8nWEYnp1yTWk53VaANrQXEOV2uHAVwcc+66Ygow43Ovkk4/yXsLGJp3T+yfZfE2tyhBPEyjbegXL0xW7/d5v0d7iHbk8UOor6TLq94knSdQ0QNJ1ZSKtNDY1wBynjLvWz6yLXUQhD5VosnZVXWKg+L1MpGMdGEbYBmJBcASdMkOqj35hpQbkv/cRKvUzAZU7FkJGPz44/JPMRoz/GsEQ4opr346u4QVOXoysftaJoyPYlg9p+ZabOJB9A9huDv2pJMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB6063.namprd11.prod.outlook.com (2603:10b6:8:76::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Thu, 18 Dec
 2025 06:35:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 06:35:29 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex@shazbot.org>
CC: Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Yishai
 Hadas" <yishaih@nvidia.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
	Ramesh Thomas <ramesh.thomas@intel.com>, Yunxiang Li <Yunxiang.Li@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Chen, Farrah" <farrah.chen@intel.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] vfio/pci: Disable qword access to the PCI ROM bar
Thread-Topic: [PATCH] vfio/pci: Disable qword access to the PCI ROM bar
Thread-Index: AQHcawxgfpLYYgczj0+cYz6CfPFS8rUmbReAgACNh0A=
Date: Thu, 18 Dec 2025 06:35:29 +0000
Message-ID: <BN9PR11MB527626BAEB61201D6D464EFE8CA8A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20251212020941.338355-1-kevin.tian@intel.com>
 <20251217150755.10d88a04.alex@shazbot.org>
In-Reply-To: <20251217150755.10d88a04.alex@shazbot.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB6063:EE_
x-ms-office365-filtering-correlation-id: 6c85c640-14a8-485a-631b-08de3dffa351
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?Cuk1RUXPa3C59icGVG3ERlXVBL5BxaZk/SuO85heYlAdqAvA0iOVlXuY5JwL?=
 =?us-ascii?Q?W9D+FndphuchrJsO8IJLqbqc5rK97CIQ2HyHaAFoUypqxbntWXJVeZ76rMjc?=
 =?us-ascii?Q?4RiVvBZCBqhWRcTabPp/rBrWzsFk5uSmAGD4+Kku7/GrKn4luYHmdFCr3V/n?=
 =?us-ascii?Q?soukSjBe/9h2wdZYpTueAONdrFz7UDmqLWbKS4uK5vNFSgXcozSLpAKlWAsg?=
 =?us-ascii?Q?M0JZPyU0D9uWEpQK4/kXEBShNPIXT+nWMnNUqy6Xwc8mZV1agbc3k7Hkb+Li?=
 =?us-ascii?Q?ChMwmKbDB0YAKDParSCd4/lJmUOElRdcCYZFN4Z8oB7GUYtfMJyB2EdfEpYc?=
 =?us-ascii?Q?Aq6+tMv40pIHDwm8A75aGjJJPMIPzi2/y/B19WkYVGMolf9oFcnL157/PJlO?=
 =?us-ascii?Q?u+zOBflnb74e41jAwJPZxolurMVyrVADcP3wvCvs7e5UjDGN/KzcyRaftsrd?=
 =?us-ascii?Q?MCb7PaOFQ/6VPx6d9r2zKOVL9Ig++BqVQzmyE1N7cZFzxmEwIXfbDMZrQiDs?=
 =?us-ascii?Q?An5svVPPxOP7OxTU/cXiFPbMS80A/0sspFeyVu6XdEKrmWAda4TWW40hsZGQ?=
 =?us-ascii?Q?Sluvw0K+v+Bn5KIU6ARNpikNg7blJI2cOT7fYYiPOxDCDV+OKBQxi2XISMxz?=
 =?us-ascii?Q?KQo7+wBPWe3wOXIcBWaxcFLkKZU9tMaql2RMWPjgTdlN4R/A5gAICp/K0zCr?=
 =?us-ascii?Q?nLyWt0XatVoTEvxQgHhyzvZEudmozUwwvUxSnkhKTgfbCFk6hn+KvhyjKt3d?=
 =?us-ascii?Q?E3RjSgq7wMcZZj8V1MAd7iQu1NWDSBxfT4lEc/yarerlIEWuQyGzQK/9g5/o?=
 =?us-ascii?Q?nlr8aLIvrt9Y4sCm570Y4THcN3XXkTGWXQLTuSDJTHAT1rgCgrjmIjzElCJk?=
 =?us-ascii?Q?LiF5ivJhVt3AQR8zu1jdIg7h4B+QjJqYFSTwWl2Ro+lpQ1oi9wX41hGWUG53?=
 =?us-ascii?Q?ZFDJVe/yB8vpuqgAfRVivfiNC/fkGc30ioGlCdwGHsGch7TrxT29pfITMbAq?=
 =?us-ascii?Q?drav/BN/ELKGLhptCyw30K/DT4YQVQRRNMuCCzTbEB09Lzy/ytCaHsXTlqoH?=
 =?us-ascii?Q?VqyZoHpmcPPfAcHKk9Nr4dlZH4L5eiUO0v7vAEIATyUO03rGElJJZ/HJthrP?=
 =?us-ascii?Q?dy+2gmG++9dgf6R/a/XKcNYk+IcFOf+HyIkY2zPgQLno2m8rZF2ctOU4Lnix?=
 =?us-ascii?Q?qSlLZemAryPfNrZNFOqLDAjyztcHPNuGDuvQfJdiyMqKChAVAAeYZ+Vl5TMU?=
 =?us-ascii?Q?w8wmxBGi0Y7cB6UrYmGzLu8uQeX1YtH4YNMWOu0ptuN3qNijl8HrrCrEaoJx?=
 =?us-ascii?Q?ocB1IzLZeGHT1vxUvxLj/pVR1DWOXCYCToHQl/sTn7EfRQfBtW90YBw+uBd4?=
 =?us-ascii?Q?hKs3XhY/BDR0bbSj0sQ43KkXc91X6blGNlzRST8a1y2Q7O52wSIzO1GmnVMG?=
 =?us-ascii?Q?ySV1dvqxkmXNUGEbW4Q8REwj454FnohxPuUO9K8W5zSTDj9uQ6GYmVCGaGmf?=
 =?us-ascii?Q?px66NWxCOTcYdaz6Y8eAHCC8MmE+FNTIpgSm?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FueYE5ZFrLG1dYnwkm8WhuwoH83KLHQQTwYV+bhqZPQQKViFRmN3ZSkmJfj5?=
 =?us-ascii?Q?DZWkl11Psh3PFNHoS/ssswp8u0Yi4SGFr0MssTNBEuxrFhwALUZ6eGoLsO5M?=
 =?us-ascii?Q?MLxpcaX2yHzr+dkd97KzxZrkk98AjWKnzPdt6esdRzf9GH1YEWGXVcNQQBaw?=
 =?us-ascii?Q?XMujsNr97Hr5qnFPbXclv+Ag8+l/xVXo89CG7kjE1rFGpkAdgM7C3iJK7zH5?=
 =?us-ascii?Q?4g+cbxbuBpx0LAPS8nrl2lHEurxXA3WuTloDSxkAIHA1CQ7aPXKW2Kulv1ZM?=
 =?us-ascii?Q?zdeiuoSiFv74YCUsQjaFWbYzQZKqL44zoNbaq0VUp288yxVugJd47HK48HgY?=
 =?us-ascii?Q?G8B7L9PwB+9+K6d1tq2H7+N8McAzjpKwTp049VDsMEM4k9GryNRDEHR3pOmi?=
 =?us-ascii?Q?WcY1XDdiyqbqfHKLGgOaQ7aolTb6NBnK2eIoOm+yf4Tk6rdtzYNGFBc8nJ7O?=
 =?us-ascii?Q?/JTcGKKZ48jS/Qlu7niUR1YE2bOinI44kzuB+OyBl4oA4m4i4HF/Q33mdLaU?=
 =?us-ascii?Q?N3o0rCKF5LoNXp/vf5Y5cbBkr3RM6XrqDvPfkVQI/N+amozA5M58T9WUfnKX?=
 =?us-ascii?Q?hMIA4Oad+E3XraebxgLompLJK/yZOtuWIX1iSoxJjttFGd2TobCtdPUiO/eV?=
 =?us-ascii?Q?EHQJH3inVZ4tDjYxA8n8hWw1qkGmemAl9PzsTd53zJw9+e/IJNnhPzWVVIdL?=
 =?us-ascii?Q?Ttqv30ltPoHc3TXK3m7YLda9eQALuYQZndu9PQrpfC5oVY2lXQeIRZ2M2qBI?=
 =?us-ascii?Q?dbVs5aFBhUKEP08iI95mb1MckwihX12FJ36b841kuXBVlctq7yR/Bgp7uEwT?=
 =?us-ascii?Q?4S4rlSVmvP6qvetkT/EMwZnq+xkKfH0+tWiym8A7priOgYNhyA/Q9zaISfKm?=
 =?us-ascii?Q?T4nx9fb0puU5j1VfeaGnZxGeywWwbnfeqJnoaxia1jiPwu8c7yinX1SUyesl?=
 =?us-ascii?Q?FR/Z65hgJ5MjbiuqZi3ZMzt6dx0FBqFjHUQ4H4e0O0I3qvLRDJ+pZC+ah+QX?=
 =?us-ascii?Q?OZVdRxtbjiKnP5fXGOORs7X1yY9kQOGJ24PrghAarYCJI30T2Cm2PKmt8j4x?=
 =?us-ascii?Q?YM5r4yexP16dbTPO8wwyw9LdyexcpMefcTV/jk4Rx4Xuj2EmTEspF6+rPlAn?=
 =?us-ascii?Q?EYQdZEJwNPc4RJBGKLfy4bU1de4Q5AXkMXQD59p0ynMS39vBOcM7k12dxb1U?=
 =?us-ascii?Q?UqjTj9+O+vkVXx6RgPtKedyvEcFSsmcjY7TbJ2QYdkFNj4ZAlbvvXOfOvg3m?=
 =?us-ascii?Q?vv7IjZmwstESldyUgaca2jBegOxCibtGALG0sj4bs1ogGioMToErluiAsgX2?=
 =?us-ascii?Q?Isb06Pat3AyuZXCDuqL2l8ZckI+wK9rdSKU7ix3qVEufmstiJYysrAHcwmYC?=
 =?us-ascii?Q?n7jnLcdWb73XVgMiHI+AUxOJ+/U91Qch6gZ4qqxSg/X1S/9ALZ+JTvS+jdVb?=
 =?us-ascii?Q?dczzsWtwUsY4dcHX/ovOrdcDwtZAU7DDK9Zb12pMT+08qbtqw9ZrsC0zU8ZB?=
 =?us-ascii?Q?sUtHIx9VJmv2OVhl266qBWX8tCK65mi2SUZRnh3RDyjt9Bhd1eiRauOChd9K?=
 =?us-ascii?Q?aI3Ll6F+u9t3iNZXHBnwQUwi1zIetFPbPjaSMQjj?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c85c640-14a8-485a-631b-08de3dffa351
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2025 06:35:29.8993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c61EONCwjyJ344H0XrthPxfGV6ZUw92JscZeMQC6LtA3IiqxjFxpN27gJXcSxeCQgKdS6uwKd25JA9CjBb3NQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6063
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex@shazbot.org>
> Sent: Thursday, December 18, 2025 6:08 AM
>=20
> On Fri, 12 Dec 2025 02:09:41 +0000
> Kevin Tian <kevin.tian@intel.com> wrote:
>=20
> > Commit 2b938e3db335 ("vfio/pci: Enable iowrite64 and ioread64 for vfio
> > pci") enables qword access to the PCI bar resources. However certain
> > devices (e.g. Intel X710) are observed with problem upon qword accesses
> > to the rom bar, e.g. triggering PCI aer errors.
> >
> > Instead of trying to identify all broken devices, universally disable
> > qword access to the rom bar i.e. going back to the old way which worked
> > reliably for years.
>=20
> Thanks for finding the root cause of this, Kevin.  I think it would add
> useful context in the commit log here to describe that the ROM is
> somewhat unique in this respect because it's cached by QEMU which
> simply does a pread() of the remaining size until it gets the full
> contents.  The other BARs would only perform operations at the same
> access width as their guest drivers.

will do

> >  ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool
> test_mem,
> >  			       void __iomem *io, char __user *buf,
> >  			       loff_t off, size_t count, size_t x_start,
> > -			       size_t x_end, bool iswrite)
> > +			       size_t x_end, bool iswrite, bool allow_qword)
>=20
> I've been trying to think about how we avoid yet another bool arg here.
> What do you think about creating an enum:
>=20
> enum vfio_pci_io_width {
> 	VFIO_PCI_IO_WIDTH_1 =3D 1,
> 	VFIO_PCI_IO_WIDTH_2 =3D 2,
> 	VFIO_PCI_IO_WIDTH_4 =3D 4,
> 	VFIO_PCI_IO_WIDTH_8 =3D 8,
> };
>=20
> The arg here would then be enum vfio_pci_io_width max_width, and for
> each test we'd add a condition && max_width >=3D 8 (4, 2), where we can
> assume byte access as the minimum regardless of the arg.  It's a little
> more than we need, but it follows a simple pattern and I think makes
> the call sites a bit more intuitive.

make sense

> > @@ -352,7 +363,7 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device
> *vdev, char __user *buf,
> >  	 * to the memory enable bit in the command register.
> >  	 */
> >  	done =3D vfio_pci_core_do_io_rw(vdev, false, iomem, buf, off, count,
> > -				      0, 0, iswrite);
> > +				      0, 0, iswrite, true);
>=20
> I have no basis other than paranoia and "VGA is old and a 64-bit access
> to it seem wrong", but I'm tempted to restrict this to dword access as
> well.  I don't want to take your fix off track from it's specific goal
> though.  Thanks,
>=20

I'll add a new patch for it.

