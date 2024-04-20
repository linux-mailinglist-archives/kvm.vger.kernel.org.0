Return-Path: <kvm+bounces-15410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FCBB8AB920
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 05:02:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 439EA1C20961
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 03:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC04ECA73;
	Sat, 20 Apr 2024 03:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OEASaTtY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D048BEA;
	Sat, 20 Apr 2024 03:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713582117; cv=fail; b=kxGnGVDcmzM8r+fk/CrJ1HRkCnwFz/QQopBMzeLogdem6ZrIAsOpKW83wPphFDOh21jJQ5kimYKES3rfCWId4n8/Wa/VkzGeOy98DUhEwZ48TLCmlqglODHPoiwR+85hcmjSd+SlYxiqASvN+TIcx2VQUpSO+OYCQUljUOe137Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713582117; c=relaxed/simple;
	bh=kcN31y/WUYQfHuIjHIGi3QCmTGFt7bSRlSaqphhKQcM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=irgfMQEkmvSdEgVWQVT0zyg5RZo1TXzVO2a9pJsi+KlMrsX8gdD5t4sil07Ee2jMKLqcGIlObjDleHWIsqPEtHDByn912nHvGsQa8MuuVIIGFW2JXBFxYjHTmPDF6Hiaz1BYsuMC1PxJ3esDirSCcdjtmEMrIX4BEqvNDb8LqqM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OEASaTtY; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713582116; x=1745118116;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kcN31y/WUYQfHuIjHIGi3QCmTGFt7bSRlSaqphhKQcM=;
  b=OEASaTtY+OGwBCmFEyq4Ru2n8CbktxwNHtwu+8Wb7rZ4HgwCINNJpCcO
   S8/s5I1p5e8kKXxEEfU7xbpDi/PXo7Izs8hWKiqMH4gW01USSmpQ0T5ea
   Vf8JJ+RHqaWM1F6dtZHJT3VfCcT7UPNOHw0mFXpoAR0WagMkQTlTHaUu2
   iiRxtsnjI0+ZK3+QX0mCNrBh3lqqdiL4XiwrqIoAt42Kr7fvNTYdHyNyH
   bzzA3n5nmWMKqiehweautXVcA/QP4eDHbAeu10zGJxRfUxgvSCgdA5okx
   87R/L4Em2LsbSwXXyoPFmwUsKnwebxJ7H5f0TAlQTEl3cWhOKNU8eqE6P
   Q==;
X-CSE-ConnectionGUID: uxJjrCwDSzGAGrXU2j3F+A==
X-CSE-MsgGUID: ETumjQdvQPOlSXZQOxHvoQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="9058442"
X-IronPort-AV: E=Sophos;i="6.07,215,1708416000"; 
   d="scan'208";a="9058442"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 20:01:48 -0700
X-CSE-ConnectionGUID: TNMyD7++TMyUOePl+/JAqQ==
X-CSE-MsgGUID: wZ/8P6GQRyuc4HGDgwB8JQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,215,1708416000"; 
   d="scan'208";a="23485352"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Apr 2024 20:01:48 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Apr 2024 20:01:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Apr 2024 20:01:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 19 Apr 2024 20:01:46 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 19 Apr 2024 20:01:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dIox/njBQ8RHPJtfMvqXcrAEVV11WxWRFGr7jGQSF7ofHEU6VhboGR2j2iOSE+PTS+hVeQDcoMEZExdjQ5PaBzjb1aQtYsoa2z+oRz9Ex0FMX09TWHhhV5q91O/azIfEfeHYGCmWiOGw2cG0qwWeGOB6eHoTS9j1TegG2mDFKMgjNwgJl/AXOz4H9RZsxaUxENjAqwCmgNA+AVnboLGaVaCVRewjZ+W6dPiYJLmjYpkibu2wKZLwk76SdJExXU12x1oMt2VoxpS72+7QUfqem4CTAzWpcrhRvu0UGBIUqONh4Ab4nJ650QmIZHSN4S9Jy+mQLcsKdxxu7N0kRRrzUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJsNhRZzO2Od+iqvlUcQthV0PjNuiX588npSe/gG3Ok=;
 b=a8amIVLjLmqRDm+d92dHpekoyeDpehowtwJx1P4X5Gv4o8D4qFg8o1yE7BRo1/k7ANK2opP4O+GnnGypQq/faeZaC9VI3i3oW2979aPVdj3qYWbxRh2+Ld7HzJB/JKMHO3Mg7JLHJ/L0M3QUC5VHDB5gS+blqEF6NgaIDkzkHuxTwl7Si0YPC+sBmZXjUipGiLT4QZMY6WcMjlzkNvGOZTp0wfscXyCT1/bZ3mTrauYzb5x5i6pXLbiPCoEtf0/TTV51Gl/WJROdkq0Xds3jyz6B9EpRmyV4fuhAaqGJjj5Z/bxOAmnJTEUC5ikX0/NHDz6ks/uGx0i/EiIKzVTRDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 DM4PR11MB8227.namprd11.prod.outlook.com (2603:10b6:8:184::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7519.14; Sat, 20 Apr 2024 03:01:44 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c%7]) with mapi id 15.20.7519.010; Sat, 20 Apr 2024
 03:01:44 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v2 4/5] KVM: x86: Remove KVM_X86_OP_OPTIONAL
Thread-Topic: [RFC PATCH v2 4/5] KVM: x86: Remove KVM_X86_OP_OPTIONAL
Thread-Index: AQHakkz4v8XEzjLts0GEpU850B7z97FvmgoAgAAKIQCAABv5AIAApn8w
Date: Sat, 20 Apr 2024 03:01:44 +0000
Message-ID: <DS0PR11MB6373A7876C312CA9A06AF349DC0C2@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240419112952.15598-1-wei.w.wang@intel.com>
 <20240419112952.15598-5-wei.w.wang@intel.com> <ZiJ0mjZxlRsLwl3E@google.com>
 <DS0PR11MB6373D059F2BB9F196AA9D503DC0D2@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZiKNWM0XyMqbKrD2@google.com>
In-Reply-To: <ZiKNWM0XyMqbKrD2@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|DM4PR11MB8227:EE_
x-ms-office365-filtering-correlation-id: 3a9c2e81-3422-4d40-d05c-08dc60e63610
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?UHIoQETa/RTHmJDsAQl1BA9ia5w8UpclLueJC08zs3l9tak1n39fgRPUfF3Y?=
 =?us-ascii?Q?taZa8zimLhtwTOhq0tvCApIDBTMMIB7hEjGHZ/WhN1cuRajzTNkdqWDrARJY?=
 =?us-ascii?Q?n5s+Rs+xnJy5ZS/btQXWTVnbhya1A+yphEALgFWXwbQ2OGwwFMtomg1PMVcm?=
 =?us-ascii?Q?wdrF0ONj59v6Qjhq8IywCZqqEuiWWyee/k8ivbytsIF3VlHIhMkfnZa6bUBB?=
 =?us-ascii?Q?RFvMuh6a6jJbwZmwCuL2dyvjUS81V0RJvbrCeVWU3HN14JZIL53xN+7VN34y?=
 =?us-ascii?Q?eJwXjn5RbtkPseYw6TUwM3bHxf2fCvbXGGRUgGUA7LIbrU6AtXyWxQji2lHi?=
 =?us-ascii?Q?5cEMn6jWBnwDvymHYNPcswGgX/lz1fATIvDpuFcvVdfb0D3WG0p8CH/e1ySE?=
 =?us-ascii?Q?iG9DtpT0SDDPHAQTsnj5JvPU0OBl114yVmyMW8yoZ4LZnMpBygNcfz8QrYIp?=
 =?us-ascii?Q?RparUjD12jnUJtEqod5ntypVBhoLcDKyXmFY13+mth/Qgglr155mbjbByXeG?=
 =?us-ascii?Q?s06Hso+3XUQIcOj96NQDS+loVd2scgHSsg1FWL/5SdatQYQeFdaYB3TFga/9?=
 =?us-ascii?Q?jzhsT4wuPMW26qD05ILfgki4fA0xnxI8xkogyHf27Zbu97BK2RJbEUMw5J6v?=
 =?us-ascii?Q?VSqcYoJGcfN5crphtB34c9WjlpeEXb/caqlHCEeXNYhD7KRS+LFXpQWk81xS?=
 =?us-ascii?Q?h0CqwshcgqfRjoHcktDG/BWYfgcUCJxydQmftCINkscebS/ehxdneLf7tbho?=
 =?us-ascii?Q?Yua4qfc+BgSc1iwwuSG/z8FhuFZooAHJCYlod1qtkbWlpEkCA1TI3oLUscdu?=
 =?us-ascii?Q?j/SRQ6dxqL+oU6pQo0/H+sqCRGX+yIs4LLVeGX65+JcnahfyszhCeb4jcsBk?=
 =?us-ascii?Q?OQD/jFg4bULIcdUZ6601k3DeB3ZUn0RdoW/ta9s0JgfaR5rZwDaVPMIdzD7y?=
 =?us-ascii?Q?HSZAacw7U6s8PXPJXH38LgBgC/JoJly2nK/wOH11LqSTUrdSt1AFpYaCDxJu?=
 =?us-ascii?Q?/x8W/0VEmWSL1h4m+7qSdpPSDkeHw/17ksB80nFYSgHk4RGn+WXjOV3SwDxV?=
 =?us-ascii?Q?uGhY2RCwRlNxDxHskGnL94efaHlnnx+lqud/r8uLw8xyywkjJxSMC4vcylxF?=
 =?us-ascii?Q?xAiF5dWVZwWf8x5R+hAaQa+SoZBdbz7QDA8z5vDe6MwVQi4IK8YXeyidCJLX?=
 =?us-ascii?Q?gkrwhBSkVSP/nqxtCRTf/SDGcpn1fvvuUhQgF46mO19meWDSIzDGgQ6CIgON?=
 =?us-ascii?Q?A6rLwtpFIGZ28ybs1LNI1Wut934QK+4uh3qcAwQnKif4q/YYrW4knx7HQD/j?=
 =?us-ascii?Q?BrLsv7FXx+SnoetMfZjPk3yM7R1EgJsSwZWiP8whm/hTQg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sXHA1+QWKqfoburqccXboawRUk8ym3QsJdwQOzZhrp3ok4FXC7vJRCybs1Rm?=
 =?us-ascii?Q?ZYEgh7DRFoe9xoiCY9owQAkPli4ZlPusienXhw4jFL7HMBe6HnGLHgrlmvvB?=
 =?us-ascii?Q?z0UdXjhWewln2gEDOKUGga3TyBg3nZ4HPAsAl7uqVjyTr84nkKaCDx18Fzb8?=
 =?us-ascii?Q?Fbsbp/iHJR0C350dms9VgLzbOMiZnu4EA5yjLtXismTAYUTgya9C6oiifTcR?=
 =?us-ascii?Q?KG+iFCFgBo5K/x2siHzum0PJC4U23QZ4o6V3Xd7lfB7gP+fd8Bgx6FqoiifV?=
 =?us-ascii?Q?EwAitFPUjMLbZOUM2vw2CJgv4S7SHQ3Dygumo4P/WuX6JfqRVHZbKNQdjBRq?=
 =?us-ascii?Q?Z1Yigv5UXowLoCofkBs1PdI2HhpWdqJ3raz5uTnoFVl9jC2kPEq2Mckp2DVZ?=
 =?us-ascii?Q?iNq66ouN1f3COUhK2bvZmOwcNBtajzpEge5n5s8DChY/eT5Bf9lTfLhHYq6D?=
 =?us-ascii?Q?K2glbQmnZYtIB52/OGoUJ5hGOa87CS6qkHAh/b356tyRGDqAmTuszbPmTwzm?=
 =?us-ascii?Q?FZVlui1/r49DarlI6qSQWZwcJ2Ryf7Vk3Fmds9J0V2LjH71TGCk07wlyODbZ?=
 =?us-ascii?Q?g8QEst29BA3OdknjZn/t5F2Sk2Q1mOEscNYZmHPAOb73nvdqsr47AcfAI6yz?=
 =?us-ascii?Q?QVP6d49UHkNT+HNYrRYGU+8r4EV6giKoOPt0WjxM9NDvztYjd1bZTm9YXOAN?=
 =?us-ascii?Q?AkPxAT7Yf9py8xNPH0GpxTBrwnsY+SZqMJv75ZYP2CiOjGfMawZu1eeoxc1o?=
 =?us-ascii?Q?ApnXbXtMpirrv7x4EnivG5hNBHFXOJ88NfrhVMfY7NXvVmT1S04p9n6aq0dC?=
 =?us-ascii?Q?Caw8JTUa5hOwidggRqqkgW5X6WCg2UbW0y5BvDbIJ+lUUKhCyeQu8/skLAQ6?=
 =?us-ascii?Q?Ydc0jqcs8+mO6gKZSRbKvQ3bxWCR50ZFRTRCBGFXmZg/I4tJdJlWUEr+7bC8?=
 =?us-ascii?Q?ZuF35t+Y+xoOZ5jrKKe3K7clT8Wf0BTgZzeglp2bRTfpHUo+C+5rQASlo6sZ?=
 =?us-ascii?Q?9FLbAnqX5KCXW1t7cck9xeRIR6CuCX21F2PbjDR4elocA7ULXvyqPTCkfaOX?=
 =?us-ascii?Q?HCPmMcyhMzoNOrK4Uki08K9KelybcZ0ew0AycLi7J8ehGaygKVcK3FV51LxA?=
 =?us-ascii?Q?fnpE0iZgOuy3GunGVilhB0wi8ksRWGLrW+BbtmMJlKHysN/FmWrDIBMWuWNR?=
 =?us-ascii?Q?SZEKoOCFQyjbqKg1T85MN3dyBlNLfoRosCmHcxVoRoF2MBT7tjKZk5O3OkSl?=
 =?us-ascii?Q?nrvEr/MoL3JXzs2YCR9hG1KJPjCd1YAcP8TmYJKbWrec++7TyL3bH49xZEpt?=
 =?us-ascii?Q?G9nARLYDyST7UC1h1JvAgY0chZ8CFzZdPpUI0ukiEEM4vF/GWD9qxfLCR34P?=
 =?us-ascii?Q?13nF5rYpgPetTO+dJuBP4qWs7k7TSaUzJCXh0JEzNVf4j39j21DBjNA17uvA?=
 =?us-ascii?Q?7qJw2W1PEz53gx1GxfdNOLV698AMrqaZHC1W0fcoHocdDNClaS9DgU/PjbYK?=
 =?us-ascii?Q?5Ko6kPuYFfNQOxkktlTVMk8PxjvDy9LrRjcvfEehTSGfnEEvHRe2doRCMNcp?=
 =?us-ascii?Q?5Kj19n81dhwvNI7GlOqF1Ngx1UBis1nsyXtdJfe2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a9c2e81-3422-4d40-d05c-08dc60e63610
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2024 03:01:44.5120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jfSv2wPjj8goyHpF3fdkvW1adRHszKCun/3L8hDXM1ju4sVkxkJo9i4zE1JAr5c8kLoEUhAUaEwF2nhHf/q3xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8227
X-OriginatorOrg: intel.com

On Friday, April 19, 2024 11:58 PM, Sean Christopherson wrote:
> On Fri, Apr 19, 2024, Wei W Wang wrote:
> > On Friday, April 19, 2024 9:42 PM, Sean Christopherson wrote:
> > > On Fri, Apr 19, 2024, Wei Wang wrote:
> > > > KVM_X86_OP and KVM_X86_OP_OPTIONAL were utilized to define and
> > > execute
> > > > static_call_update() calls on mandatory and optional hooks, respect=
ively.
> > > > Mandatory hooks were invoked via static_call() and necessitated
> > > > definition due to the presumption that an undefined hook (i.e.,
> > > > NULL) would cause
> > > > static_call() to fail. This assumption no longer holds true as
> > > > static_call() has been updated to treat a "NULL" hook as a NOP on x=
86.
> > > > Consequently, the so-called mandatory hooks are no longer required
> > > > to be defined, rendering them non-mandatory.
> > >
> > > This is wrong.  They absolutely are mandatory.  The fact that
> > > static_call() doesn't blow up doesn't make them optional.  If a
> > > vendor neglects to implement a mandatory hook, KVM *will* break,
> > > just not immediately on the static_call().
> > >
> > > The static_call() behavior is actually unfortunate, as KVM at least
> > > would prefer that it does explode on a NULL point.  I.e. better to
> > > crash the kernel (hopefully before getting to production) then to
> > > have a lurking bug just waiting to cause problems.
> > >
> > > > This eliminates the need to differentiate between mandatory and
> > > > optional hooks, allowing a single KVM_X86_OP to suffice.
> > > >
> > > > So KVM_X86_OP_OPTIONAL and the WARN_ON() associated with
> > > KVM_X86_OP
> > > > are removed to simplify usage,
> > >
> > > Just in case it isn't clear, I am very strongly opposed to removing
> > > KVM_X86_OP_OPTIONAL() and the WARN_ON() protection to ensure
> > > mandatory ops are implemented.
> >
> > OK, we can drop patch 4 and 5.
> >
> > Btw, may I know what is the boundary between mandatory and optional
> hooks?
> > For example, when adding a new hook, what criteria should we use to
> > determine whether it's mandatory, thereby requiring both SVM and VMX
> > to implement it (and seems need to be merged them together?) (I
> > searched a bit, but didn't find it)
>=20
> It's a fairly simple rule: is the hook required for functional correctnes=
s, at all
> times?
>=20
> E.g. post_set_cr3() is unique to SEV-ES+ guests, and so it's optional for=
 both
> VMX and SVM (because SEV-ES might not be enabled).
>=20
> All of the APICv related hooks are optional, because APICv support isn't
> guaranteed.
>=20
> set_tss_addr() and set_identity_map_addr() are unique to old Intel hardwa=
re.
>=20
> The mem_enc ops are unique to SEV+ (and at some point TDX), which again
> isn't guaranteed to be supported and enabled.
>=20
> For something like vcpu_precreate(), it's an arbitrary judgment call: is =
it
> cleaner to make the hook optional, or to have SVM implement a nop?
> Thankfully, there are very few of these.
>=20
> Heh, vm_destroy() should be non-optional, we should clean that up.

I think determining whether a hook is optional is easy, but classifying a h=
ook as
mandatory might be challenging due to the multiple options available to ach=
ieve
functional correctness.

Take the vm_destroy() example as you mentioned, it could be debatable to sa=
y
it's mandatory, e.g. the VMX code could be adjusted by incorporating vmx_vm=
_destroy()
into the vcpu_free() hook, and being invoked upon the first vcpu to be free=
d.
It could be even harder at the time when the first user (e.g. SVM) adds the=
 hook
and classifies that vm_destroy() is mandatory.
(not try to argue for anything, just want to gain a comprehensive understan=
ding of the rules)

