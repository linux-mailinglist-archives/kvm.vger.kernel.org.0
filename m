Return-Path: <kvm+bounces-67688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 007DDD105E6
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 03:44:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6A58C302571C
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 02:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BEAB304BBD;
	Mon, 12 Jan 2026 02:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RlL9NMU1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119D0266576;
	Mon, 12 Jan 2026 02:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768185851; cv=fail; b=W3zAxNObk6/a0mDG7loDg6fH3t3yUy5iRFg47Z9Wpj6O3oQ8hz6gOa3boRkt5xYNLDfCFmfum6szxavWd1wxkjo+j/R/pbmzRnAho0PY7JMNDD6++PlYP+qb4lJcQDbIRpuscJwpKMh9DA22J8+ki/KZJ+FWkSdQjgNkL9ii184=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768185851; c=relaxed/simple;
	bh=OZh3Ra7s6N3AM4ZIgcjiYE8Lgja3jFnJKN69Hgw3UMQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ahrvdFNOIcpnhZ3JTAf4ZIgRTva1d6KzTFrdjWrQELZo4hFigseSUHkmcfCZB3MAfmEErCELS5aRwG9MLQ99ltneo7CxqJfvO7wbk1sLDCX/itTGGNF/lBrsYz2RKMRNfZvaysAzYbEr9cuZzBvC8UndvYxL2w2sfpWt7pkwJ8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RlL9NMU1; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768185849; x=1799721849;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=OZh3Ra7s6N3AM4ZIgcjiYE8Lgja3jFnJKN69Hgw3UMQ=;
  b=RlL9NMU1aNx80+p2Jhdqsg042HhPHgK2MCXuLt5QKN55O9aRez7EYz+0
   S6/F4WmtJNiiT18BFA7Sx6bwzspz/eq0Bdkz8HmEGlpg0x2b3Idkw/EbT
   1FSj6WxJKRcbloQdn2C6Pe37YsbJweHyQ2vMq/u6YV6b1+mK41EVHTmIt
   BxWWkMIt7DyZokSaI8B4qtqevVkL7W+ub/g8L2GNXSnAAKelsg3reV2/D
   t+DogZ47eNp+j2KHox+1RbX6hzhAz9EPtDjTpZBk8tnCVnsV6XCXbJ1MP
   uoouA+UgE+vu/pTDpyF4FsOXLJ3Q/VUXj62H1nV7CXn2rx7bmUCfDMnI8
   g==;
X-CSE-ConnectionGUID: o+Xi8WgjQ/ysnhPIqc639Q==
X-CSE-MsgGUID: cjELdDn6TzqCExm3yzicbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="94936096"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="94936096"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 18:44:08 -0800
X-CSE-ConnectionGUID: +IXB/SFiS96npVXNsGDo7A==
X-CSE-MsgGUID: HRX5anyISrWTsp/qmZ8PxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="203881643"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 18:44:08 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 18:44:07 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 11 Jan 2026 18:44:07 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.46)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 18:44:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wUNUBUMMc+/pM2ar6Hw7u3U0OGp7rI+KPIVldjqGF3o9Yrca1Yc8ypBe6RVuvEe4HOc8lodXGQ74mmunosw/xoGigDhMc+MEh7ir9y5TL9th2KVDTBDbnHiDqZW4cceBiAvYv9Lbw4bPMyf1IQ2uWWT+vvWVydggDw3G4LjYf0tLevJzNLTcPSYLA7019v35AaZs61M/3zZeVyPkYRbTOJrbdYvChcBPFvXkL/kkdZHBkQNekzEhnBEN4Xhe48WRZoXjZaWX1HuUeKmP3j8hbCy/Fl5SQwKSBI+De/3DTuvby9KhgAUybHBkKzJx39QVudMsAYz419+qD6laxSbPbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QG1ccLF9C/LdYBv2HFe8ftbsZ9kkzvlbdBgTz4+8EmU=;
 b=YqPSVExULlpMbYJ0XOtT/xm4VSHmzOkHjHThr99FHoPCn21rqc+pE84bK1W2Vn57sZUdRWCbviTiNbJIqvfyLIqmEn0P39nmRQEFXvTEWn+ubLfJ7FKREJzUPBSmGOLFaLnipq/FEPELZRdksAeJoZTK2Wv4MaVApQtCg/FJBTUn4AGJzpOKaOLJsFUDvqYPEwkgwJZv9NC6RpaDCvKc+7tYRlHLFpA+WGB5YX1rU+EkbrI9FAMg0cN7mp9K7NA1GfOVOx8nGzlmWakRz9fatbsSuINrYEBXGCtz7YTcR+qxAY3q96r/5E+zdwTzp41z4kite47pBBW1NM6u0UM2sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN0PR11MB6010.namprd11.prod.outlook.com (2603:10b6:208:371::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 02:44:05 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 02:44:05 +0000
Date: Mon, 12 Jan 2026 10:41:24 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: Dave Hansen <dave.hansen@intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<x86@kernel.org>, <rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <michael.roth@amd.com>, <david@kernel.org>,
	<vannapurve@google.com>, <sagis@google.com>, <vbabka@suse.cz>,
	<thomas.lendacky@amd.com>, <nik.borisov@suse.com>, <pgonda@google.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <francescolavra.fl@gmail.com>,
	<jgross@suse.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <kai.huang@intel.com>, <binbin.wu@linux.intel.com>,
	<chao.p.peng@intel.com>, <chao.gao@intel.com>
Subject: Re: [PATCH v3 01/24] x86/tdx: Enhance tdh_mem_page_aug() to support
 huge pages
Message-ID: <aWRfVOZpTUdYJ+7C@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106101826.24870-1-yan.y.zhao@intel.com>
 <c79e4667-6312-486e-9d55-0894b5e7dc68@intel.com>
 <aV4jihx/MHOl0+v6@yzhao56-desk.sh.intel.com>
 <17a3a087-bcf2-491f-8a9a-1cd98989b471@intel.com>
 <aWBxFXYPzWnkubNH@yzhao56-desk.sh.intel.com>
 <CAEvNRgHtDJx52+KU3dZfhOMjvWxjX7eJ7WdX8y+kN+bNqpspeg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEvNRgHtDJx52+KU3dZfhOMjvWxjX7eJ7WdX8y+kN+bNqpspeg@mail.gmail.com>
X-ClientProxiedBy: SI2PR01CA0005.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN0PR11MB6010:EE_
X-MS-Office365-Filtering-Correlation-Id: 96697dea-41a1-4b21-aa69-08de51847391
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mHRTFOSDdSCqces7m8OeY18uw52witUd9/sBH1DOpbDVtBpDAxcpGYxm73SG?=
 =?us-ascii?Q?Ky5AkJBx3XF4glys6nrPpkZeAtALHWsAEt7zlwCK3w6zwhQr99+2hFLFKXh4?=
 =?us-ascii?Q?wGz8GG2xKude19WOcODVTG3xEd371XnaRCtUnXbtSV4IDiXFVRvp6W8AfLq5?=
 =?us-ascii?Q?J0PteX5z8D8Ea5HfMl9p6sZIiCfobPFOjvcIEfdAZNxpGMcpOnZvO2e0F4wN?=
 =?us-ascii?Q?ZAU7WFZWz1WCA6GBwk36YTJDhIKXJulH0ebHyDGD8qiR984fSOi/ie8z560X?=
 =?us-ascii?Q?h9PLH3TjMsfDEvZmshVx59dM5Oygd6VNWZHDJjh85PNQfklfHpOMUYb5oGTB?=
 =?us-ascii?Q?GnntyZECZYvN1Ix3eWyC6XpmgyPI0u+ScqG2P9/MPt9g07Rp8PtFkZ+dOtNk?=
 =?us-ascii?Q?N+pHwivGEbOFb7Hswb+B3R59WhfQ0e4n1RwBMdqjJXYPzJ65TMiyiU1QBsMQ?=
 =?us-ascii?Q?XNSwuD1T1YowHHDMkqmrk7bpSl3U/tEY3ZAH8Xp0ZWPU2FeifB3Oxbmbn51a?=
 =?us-ascii?Q?2T2NOmI78tVruFdogi1ZpfaAJQFna8m/a92VVupu2BnHG7IwD5sDeBqVq1ll?=
 =?us-ascii?Q?baHC9xh2VCuRwCIUM0dpRqw0Vn9ERQtRsfE1054CWkROPuirmU1VNDe+jiOQ?=
 =?us-ascii?Q?YrJhw9Ubhbxbwu7gqi4XqTthgZMXyuQHMoVCKzYbrOAjtTwJSwln65qH0Oi/?=
 =?us-ascii?Q?Io+R/iHOGa2bAtigKE1+cZf2wJ2Gqns2Fy+c56UsLbEBKzxf+hufLk3ZAAv9?=
 =?us-ascii?Q?3ioL1OWczXTXNi9rYFNjTk3gk5oNhO3Yf7Z0Fxf3au9dkqrQQ9eN7GWDNPES?=
 =?us-ascii?Q?OiYGxeHr2ise30ifSrfgAihUwwHjGt5Yj1WRtna3iVG6QjlYZe3D6dtOxNpJ?=
 =?us-ascii?Q?nI9O940j6YpBfpKYIickr9B6nyhsL1SSoYdFAgBxK1EALUZ151Y2BhMc9hia?=
 =?us-ascii?Q?wyR7NLDkw4PT4kHyOdlzvkmFRJGwviyUnR40RsL/xGxSdKejpU8EQibmAtTw?=
 =?us-ascii?Q?S+6q8ftPYJxWmhGLThTzQDSLFlNfceZccoL79nGQTUTYhJaeHA1eqve1Zp/6?=
 =?us-ascii?Q?cuv0lOuM1SKuhEXEwl+lhY5MKCndmWtSIPikw+W+vmyeAdkCSaP+B04x+kWH?=
 =?us-ascii?Q?iS800CuTJ6CHbAUpZgAdjTTOabeZtfjKghI0Z/lXEPvL0ng7ObM0ti0LA/39?=
 =?us-ascii?Q?8S9noSL+ZBNSb9Xj2c8zn6tvZOVipUMvJvelqYV3UAw1i+LUvjOjTMpEsAXr?=
 =?us-ascii?Q?5tfy+vEytB/XYQe0vwMcbLFIbSJhQMheJfctthYOPqDZC9KpfSptV1W652hV?=
 =?us-ascii?Q?GVbbfKpQGsr/Dx0C8DmXna5HdhrsuvErw6OhndNfBIgOP9hnx0wxCqnRBYS9?=
 =?us-ascii?Q?cgUSkaaSXX1TCJ5B5NIO8L6hTr0LQkchbKxU+bqAsqzp7AhRFbojYeZrujlQ?=
 =?us-ascii?Q?LM+v447cfE5HDiK0d1Maqp2MHbyLI/3AFrpXVh1mv0hOnQQuwVGAZQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3/HGW5kIuI7X+MO2xiSFUjAgdrUJm1iPi3bHvJzW0SFi41zslxc/g38Oiisx?=
 =?us-ascii?Q?2xoh349nS6KLl8bBYe2b2g/jqs1h6X0jpbPKNZHooA45mWsa1Tv431YFjoXz?=
 =?us-ascii?Q?f3RMyZ9KgEiOmjNCEHoZ5Y7aYhkuiYaIAiueRIooncMVMgp2Fomos1FuNvVA?=
 =?us-ascii?Q?VTrZ8AVFIVe75Lps2D80qzgiKexRM9IW4dXgfQqMAcBzSPj5wuLR81yWFzAX?=
 =?us-ascii?Q?VIaF84KcKZRo5brEWG6Nzbo31A4/kIYtiM2cvw7gJss440Y4M3V+QfgCulF4?=
 =?us-ascii?Q?kRC+C0wQFELkddDGNOUtiqVsCKUrslyiW2LPwWA5Jv2VLln4CodYp4c2jO25?=
 =?us-ascii?Q?F7F3hwZR4eFndHIh7UU3lIiAg+yuj4277cHEzyWiaMUY2MemdYLZGACMtxHe?=
 =?us-ascii?Q?SbKoBiBCMyrex9s0GJzMsvBb3Pp4Tfu06df7hVp+SGtnBF3AGJ1TkPh3sJAj?=
 =?us-ascii?Q?lqG+0TSddlR5hd/Pj768E7z3Tvp6Pt3ma7ePTbSGromLR8A5yhtGtv60y3eV?=
 =?us-ascii?Q?mc20k9U/BCa4t+rP43EF38X4fEr3V2EjbNQ7uUWmJqcXoXCnNi00ZlA5ZV13?=
 =?us-ascii?Q?nsLgYbdeljeAHFu1kBZuv8C4Ndj2cBiTjBOS9ojdFMg/OyvLCqcNMfXMbcJt?=
 =?us-ascii?Q?v+gL91dhX6nh6pBEccK5BzxS3TZr4tA9eGGTsLkj6+ybdNtz3CIwtKlcuQDb?=
 =?us-ascii?Q?zWrJeGxSQLGvVI+O9qtyJrtybIvelrgZY+PjUObL0Tgjzk2E1dq5DzMKmyWz?=
 =?us-ascii?Q?dMX6ERZEpmanq3NsA4W074wQcg6g24TxUB8RynPgd1r2j3v9Th6bcHVcMKg6?=
 =?us-ascii?Q?gxMr6BhnosJZUJMmVZ5oPLHA+BECgqRSmr6t7aF5NFUITV8/G0oYfvIL4jYX?=
 =?us-ascii?Q?VcjpcqHx7vJ8oaaEjOE/F8u06uq60oHAC6pEfcS+3EuaVwk/N+Z5KtfK46LR?=
 =?us-ascii?Q?zGOOrkWjaxSqjXqbHS/Gm8ZFAjd2ih31191rqIWy8RG8yvbyYA1GhxR3zy4q?=
 =?us-ascii?Q?kSxkiWNJpj8rbQD0hRUv4OCK6SGxurD3F4N6jIq+GWrBLOxumCkXUNIT3KYN?=
 =?us-ascii?Q?h4Xn2d/zBGzdXcNUeJfGXTUX33xaTcaN8JgniU67CoGvE5hJw4HTX8B0zUhx?=
 =?us-ascii?Q?+4cIAHKV2qad62Z5Bc+YZGKo0hu2FxHH6ZjOiFB3AQwi2Ef4+GAOyNwayYGa?=
 =?us-ascii?Q?PB6xM+gzkRJCGKZWKYzepMPGhoKjDwnmdmW/7zVBnzV4ZG6AuutqxR/IIhIe?=
 =?us-ascii?Q?qKLngguLbJeHBRPVmEmsX9t1rbXrhXV7AvIoRqpsqKMFh4lD1Kf6r6Gyvxyg?=
 =?us-ascii?Q?GGmhKcrlD9n8ej5kvYqDUW7ZtM8TbS1WY1oNPJTxW4LLF5y+VbD74jQ/oL8Z?=
 =?us-ascii?Q?ypwf3pjMK8UrAyXRASVvh7AcXnKRRduLzOdmKaelmI84476MBhEsVL8gHsIN?=
 =?us-ascii?Q?CfHRk+NosfVXZl88lEi4X3oncTAouEYKHT9XMdf2CVVxIE7XplsOQW646lWM?=
 =?us-ascii?Q?wqEI2oY2LEmQHFvBnZm0L6wdgELLyeqP9DT6KlgguayfN9xQuNDij/S/SSc0?=
 =?us-ascii?Q?MIa1zcNrFV612LubRRJRp2Nc05M/gU1KUBcS5+RlnqMr6u5kHJ9ZS7l8UB7z?=
 =?us-ascii?Q?S2+AVDJo1nIIOEO0BRSf8KqzUQ/5c4LNmGV12atC6Qh23RxACVUzgRKzJShN?=
 =?us-ascii?Q?eKDNwD0lmLRe537IU2etbdl93343QPKOULQmwO6iu7SP1LJWdL4LZeKivpyI?=
 =?us-ascii?Q?t/nbvILyzw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 96697dea-41a1-4b21-aa69-08de51847391
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 02:44:05.1054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iMF8GusdCIJyzfmooaPSuJOXJsadmaSj/zQVkr4xAsmtFQ5/6PzS39wzVT08wQ1aBtzWnFw06SlNVYseJ6cwqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6010
X-OriginatorOrg: intel.com

On Fri, Jan 09, 2026 at 10:29:47AM -0800, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> > On Wed, Jan 07, 2026 at 08:39:55AM -0800, Dave Hansen wrote:
> >> On 1/7/26 01:12, Yan Zhao wrote:
> >> ...
> >> > However, my understanding is that it's better for functions expecting huge pages
> >> > to explicitly receive "folio" instead of "page". This way, people can tell from
> >> > a function's declaration what the function expects. Is this understanding
> >> > correct?
> >>
> >> In a perfect world, maybe.
> >>
> >> But, in practice, a 'struct page' can still represent huge pages and
> >> *does* represent huge pages all over the kernel. There's no need to cram
> >> a folio in here just because a huge page is involved.
> > Ok. I can modify the param "struct page *page" to "struct page *base_page",
> > explaining that it may belong to a huge folio but is not necessarily the
> > head page of the folio.
> >
> >> > Passing "start_idx" along with "folio" is due to the requirement of mapping only
> >> > a sub-range of a huge folio. e.g., we allow creating a 2MB mapping starting from
> >> > the nth idx of a 1GB folio.
> >> >
> >> > On the other hand, if we instead pass "page" to tdh_mem_page_aug() for huge
> >> > pages and have tdh_mem_page_aug() internally convert it to "folio" and
> >> > "start_idx", it makes me wonder if we could have previously just passed "pfn" to
> >> > tdh_mem_page_aug() and had tdh_mem_page_aug() convert it to "page".
> >>
> >> As a general pattern, I discourage folks from using pfns and physical
> >> addresses when passing around references to physical memory. They have
> >> zero type safety.
> >>
> >> It's also not just about type safety. A 'struct page' also *means*
> >> something. It means that the kernel is, on some level, aware of and
> >> managing that memory. It's not MMIO. It doesn't represent the physical
> >> address of the APIC page. It's not SGX memory. It doesn't have a
> >> Shared/Private bit.
> >>
> >> All of those properties are important and they're *GONE* if you use a
> >> pfn. It's even worse if you use a raw physical address.
> >>
> >> Please don't go back to raw integers (pfns or paddrs).
> > I understood and fully accept it.
> >
> > I previously wondered if we could allow KVM to pass in pfn and let the SEAMCALL
> > wrapper do the pfn_to_page() conversion.
> > But it was just out of curiosity. I actually prefer "struct page" too.
> >
> >
> >> >>> -	tdx_clflush_page(page);
> >> >>> +	if (start_idx + npages > folio_nr_pages(folio))
> >> >>> +		return TDX_OPERAND_INVALID;
> >> >>
> >> >> Why is this necessary? Would it be a bug if this happens?
> >> > This sanity check is due to the requirement in KVM that mapping size should be
> >> > no larger than the backend folio size, which ensures the mapping pages are
> >> > physically contiguous with homogeneous page attributes. (See the discussion
> >> > about "EPT mapping size and folio size" in thread [1]).
> >> >
> >> > Failure of the sanity check could only be due to bugs in the caller (KVM). I
> >> > didn't convert the sanity check to an assertion because there's already a
> >> > TDX_BUG_ON_2() on error following the invocation of tdh_mem_page_aug() in KVM.
> >>
> >> We generally don't protect against bugs in callers. Otherwise, we'd have
> >> a trillion NULL checks in every function in the kernel.
> >>
> >> The only reason to add caller sanity checks is to make things easier to
> >> debug, and those almost always include some kind of spew:
> >> WARN_ON_ONCE(), pr_warn(), etc...
> >
> > Would it be better if I use WARN_ON_ONCE()? like this:
> >
> > u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *base_page,
> >                      u64 *ext_err1, u64 *ext_err2)
> > {
> >         unsigned long npages = tdx_sept_level_to_npages(level);
> >         struct tdx_module_args args = {
> >                 .rcx = gpa | level,
> >                 .rdx = tdx_tdr_pa(td),
> >                 .r8 = page_to_phys(base_page),
> >         };
> >         u64 ret;
> >
> >         WARN_ON_ONCE(page_folio(base_page) != page_folio(base_page + npages - 1));
> 
> This WARNs if the first and last folios are not the same folio, which
If the first and last page are belonging to the same folio, the entire range
should be fully covered by a single folio, no?

Maybe the original checking as below is better :)

struct folio *folio = page_folio(base_page);
WARN_ON_ONCE(folio_page_idx(folio, base_page) + npages > folio_nr_pages(folio));

See more in the next comment below.

> still assumes something about how pages are grouped into folios. I feel
> that this is still stretching TDX code over to make assumptions about
> how the kernel manages memory metadata, which is more than TDX actually
> cares about.
> 
> >
> >         for (int i = 0; i < npages; i++)
> >                 tdx_clflush_page(base_page + i);
> >
> >         ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
> >
> >         *ext_err1 = args.rcx;
> >         *ext_err2 = args.rdx;
> >
> >         return ret;
> > }
> >
> > The WARN_ON_ONCE() serves 2 purposes:
> > 1. Loudly warn of subtle KVM bugs.
> > 2. Ensure "page_to_pfn(base_page + i) == (page_to_pfn(base_page) + i)".
> >
> 
> I disagree with checking within TDX code, but if you would still like to
> check, 2. that you suggested is less dependent on the concept of how the
> kernel groups pages in folios, how about:
> 
>   WARN_ON_ONCE(page_to_pfn(base_page + npages - 1) !=
>                page_to_pfn(base_page) + npages - 1);
> 
> The full contiguity check will scan every page, but I think this doesn't
> take too many CPU cycles, and would probably catch what you're looking
> to catch in most cases.
As Dave said,  "struct page" serves to guard against MMIO.

e.g., with below memory layout, checking continuity of every PFN is still not
enough.

PFN 0x1000: Normal RAM
PFN 0x1001: MMIO
PFN 0x1002: Normal RAM

Also, is it even safe to reference struct page for PFN 0x1001 (e.g. with
SPARSEMEM without SPARSEMEM_VMEMMAP)?

Leveraging folio makes it safe and simpler.
Since KVM also relies on folio size to determine mapping size, TDX doesn't
introduce extra limitations.

> I still don't think TDX code should check. The caller should check or
> know the right thing to do.
Hmm. I don't think the backend folio should be split before it's unmapped
(refer to __folio_split()). Or at least we need to split the S-EPT before
performing the backend folio split (see *).

However, the new gmem does make this happen.
So, I think a warning is necessary to aid in debugging subtle bugs.

[*] https://lore.kernel.org/kvm/aWRQ2xyc9coA6aCg@yzhao56-desk.sh.intel.com/
> > If you don't like using "base_page + i" (as the discussion in v2 [1]), we can
> > invoke folio_page() for the ith page instead.
> >
> > [1] https://lore.kernel.org/all/01731a9a0346b08577fad75ae560c650145c7f39.camel@intel.com/
> >
> >> >>> +	for (int i = 0; i < npages; i++)
> >> >>> +		tdx_clflush_page(folio_page(folio, start_idx + i));
> >> >>
> >> >> All of the page<->folio conversions are kinda hurting my brain. I think
> >> >> we need to decide what the canonical type for these things is in TDX, do
> >> >> the conversion once, and stick with it.
> >> > Got it!
> >> >
> >> > Since passing in base "page" or base "pfn" may still require the
> >> > wrappers/helpers to internally convert them to "folio" for sanity checks, could
> >> > we decide that "folio" and "start_idx" are the canonical params for functions
> >> > expecting huge pages? Or do you prefer KVM to do the sanity check by itself?
> >>
> >> I'm not convinced the sanity check is a good idea in the first place. It
> >> just adds complexity.
> > I'm worried about subtle bugs introduced by careless coding that might be
> > silently ignored otherwise, like the one in thread [2].
> >
> > [2] https://lore.kernel.org/kvm/aV2A39fXgzuM4Toa@google.com/

