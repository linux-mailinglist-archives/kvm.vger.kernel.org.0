Return-Path: <kvm+bounces-14928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C79708A7BAA
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 07:03:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54BDA1F21EF1
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 05:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B69851C3F;
	Wed, 17 Apr 2024 05:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HO+mo9w6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3954EB5F;
	Wed, 17 Apr 2024 05:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713330182; cv=fail; b=UjVgfSnz8wrTqxLdr4rqpscEcuCq8MixAuNVIaEK0STmJ1fua7DBFqbNnZ5kHXJ/NZuvZYVV9tXCE1+5ujqH2X1BB6SXhw8hru4XzkD8y1Fye9aF27/CJ4xE0ebah0utQKek6QHSGA7LDY9sekax5WOaTAfrp7yB9uMQGGuZsk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713330182; c=relaxed/simple;
	bh=mNOJjOlGgsuvDAE4oHyPq5C20yhWIP1wGBjzgi+0miY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LfS9VcuefOoG85dbGzlDFqyK8V/stq3xXMnwB1w4e0fwX5tCH+h/wg2VztAqldAIbSNzQZpcwOhA+8CcRrPblZQk5xWo0QgyDOt570z4joFl+aqiOWgIsaiomJPsmp/NuxLZooydQQRkO0n5R8cqMmfpqlfy7+Ngj7S4bcrxbAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HO+mo9w6; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713330181; x=1744866181;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mNOJjOlGgsuvDAE4oHyPq5C20yhWIP1wGBjzgi+0miY=;
  b=HO+mo9w6l/3M38gU3LBa60frrzqrjS/Fe4H1YBkcqAMmwyTvDXegXMUt
   OTBkrVfPSE5We1XEbxeB2Q4TRybqN+Yc8avdRniKqjJOOFoBRjecFge4b
   BZciw5Zw3DGJEWv4iJI6yTgB9eHm3z5BZgTeZ7xripfmLXP8JS/xt1g4+
   hshiIyz6sJl4U62bMmr/3QEIuEW6cBoHhGAWeGdP4wZSFGXLzvozfc+Ri
   Cbp6gl8pPnIoxPJWYkMBUI/dIQJS7I5hORgXt8AzPMb0pPPGqv82wdbhh
   cldGG9Jbw7OuawrGYGPi9jMHE5B0DqnHCsqzkLwkB0+ZYZem0150ItFdY
   Q==;
X-CSE-ConnectionGUID: NkpNpwVdR6ixaCSddLwGQA==
X-CSE-MsgGUID: YdOUhFv0R8Gd1BteFdEc3w==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="9354857"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="9354857"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 22:03:00 -0700
X-CSE-ConnectionGUID: HmnKy3FhQCaitZ5X4Nfjug==
X-CSE-MsgGUID: C4o1rmb6SsaY9TX2vzb33Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="22501322"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 22:03:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 22:02:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 22:02:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 22:02:59 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 22:02:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FoQ8n4z+vLM8q/JnE+fsRdRilC2xNBbuw0+GFPkcDs6gnA1vcaPIctPShDARGR1JmXFgF2qI0Ybg4Yr51hs2B/nbtebVb29UekDhSv9pV7A+zWM8iT3aJi8bFiculDrq48AopoiAJb/kEl8z1AO1f9NYls7orrKNkWWxdL+YR71NKAqEDtF0MVq+K308WOw5UFMK57TQ5Giu9MpmvYoEy0gDB5xdbDNBaLoN5zr4hlR/4yZKgd/9Plk07jAp+i/Hr/FBua+CA5QDjmkwn7CHMi2BwOKzlh+n+qHsDGGdSWddTXSEVkfGkLb7x6TeUpk2ksaZHKqdpUvCh4jExP8Wqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNOJjOlGgsuvDAE4oHyPq5C20yhWIP1wGBjzgi+0miY=;
 b=N3UUrhY8u7wK6q/v8eiW1cNPD5dIho+QGFcGQNCDHaOtEmHeNsMdwKsXVBwHSHTwyH9hsPswQv1h1Ay6zi3HKptWf6gWIpGE+lYkupcG39vUpjcNRbQHzsPEl5GfEHTfrg0xpdMBaJpz6rcqHK/Ff7q0c/w8MiFJ8DX2nwwSp0nnh2bx9x31nZ827tjN5SPF9mFaQp341N0Hedk5RsSaNG4l8uMdoMUdTch6yUdGBijNQSQR13GmYDTsuiFFVMtu68PSAKxgGVde/RFqxvopCiaRQSDkwawDs151aUrnunmnm/oJRLhAXaJVHioE4MXwN1mKfKfRLkmPs73iGdzCkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN0PR11MB6086.namprd11.prod.outlook.com (2603:10b6:208:3ce::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Wed, 17 Apr
 2024 05:02:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Wed, 17 Apr 2024
 05:02:52 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Ye Bin <yebin10@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "brauner@kernel.org"
	<brauner@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio/pci: fix potential memory leak in vfio_intx_enable()
Thread-Topic: [PATCH] vfio/pci: fix potential memory leak in
 vfio_intx_enable()
Thread-Index: AQHajtdALXQmxco44k6vhV3B6hw9K7Fr6ynw
Date: Wed, 17 Apr 2024 05:02:52 +0000
Message-ID: <BN9PR11MB52760CE6BF65BBF7954A45D98C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240415015029.3699844-1-yebin10@huawei.com>
In-Reply-To: <20240415015029.3699844-1-yebin10@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN0PR11MB6086:EE_
x-ms-office365-filtering-correlation-id: 5df3af52-e601-470b-823c-08dc5e9ba2a7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qZcdfYbo1Wzc089fXwovphnV7qOCTfGaFq50jIfhUkKYz4X1FyqRFY5DVwnfwCzb/2UrGlaooMRz8D2dRtb5XxDDk8RPyJl8wK/CXAmwbeTZ8HSZnsDm/vjVI0Lc/uKEIAHxdX5j1cIWNhOifcorCK4pIVAoKaoxuUGLIAxEyXHB1wAIEo05KhQ4xyHORwUeQaHpFPrGEnsY2wNyax+1/eNlawC8XxJFqorx7xZJSeLkcAQCp8TwTUgD24kUDwmlTu7K510uDtOOWmjM7/dhl2IEILFE+PUMbQK3Xv4eWR5pULl382PF4ZHbifMtmBPujEisHdytjJ9ayFC7zks8bhd9zpc8TQjM5BbKS3U/KcBcO44v6WuOehugrisg5UQe7Wj78PUxlp7CD06dYPIJLnq11UihOPb/GDeKk1jrp1+QmqdSuVP4nwKUvpwUwNf5OmV/kL0r39D2tOo1WhZqssrMvVqFTzGLWAhyH2UOQ4RZp1hprMF1nupG2WaRop/Gz7WoevnMAOG9bpxF91Vy8mQLSYiFkvRC9ECLS9dpCdumwbkHI5O6lRoliK0+Wp9ioiaW9lUXnjVm2pQoooQMQB4y3JyCFlerBfVRMFtX+lltbhz9DIjADf5X2WL+MCzZTWd/RsZC4VDM29IZRIpHD5/ZR6CmHvmN774Ef6/w0lvXWttn8vJkMUbnx1bCaiy7O/1Tt7shaI5+rzyjihPvnA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Mcn8Vhe251A7DmShUGN19kUhzBBa7Y5AsiYx5WIliGb+BPgbuiaWwFcVI8vW?=
 =?us-ascii?Q?Xa0qKvVKunDExki0ltS8Mqr8lV7eVSBmXotvaCygtTSQ2KD64bIS4UzBA4qP?=
 =?us-ascii?Q?Q4ohuvnpb1xizGdJ4/RSmLN9nYW0aKokcjQrHEJ56wTiI/Nr8jrzlGwLzo3X?=
 =?us-ascii?Q?NW1T0DiQbsNsHdm5TyMujTJH80N/cmf7s3Ehkkwq4HDLB2pGXIo5NUv/pCiF?=
 =?us-ascii?Q?IKUc+YxQvz+XoPURZ8Ko2pjRzo4+wJeYicb2UZSH53oB6aFWf7TpgJ2bUayU?=
 =?us-ascii?Q?tiWvQ6JoFcbzBs/oLSJkHsoLmJPYh0KuraSSuxanDDlmxJ9lOcf8lY11OXr0?=
 =?us-ascii?Q?ASJ0nnISusaOiygjmAVhw8nd3i+iErbl0E145Gredvar/IBLCiAD8yvxAwxx?=
 =?us-ascii?Q?aR15X/+K3Zd/NspU4KE/no+SxSHOoZv30kZQSxR22pe/Syxjd56Jq/qtefLr?=
 =?us-ascii?Q?LTsYLiE0QecIS9eOJv0yJDPTOh2eVt5BmT66xhKuMibOzkyrzw0zZec9EgoT?=
 =?us-ascii?Q?O9h9HSkwdMiEjkbZlgqn3jOkyTDGDtn238u5vxIeFgomHf4iUM42Mgl6/3lf?=
 =?us-ascii?Q?V2osq2jwCEzhk4wckbTsvLYgJi9BtmeJbD3amWZ62amdz7PTPkxkznlN29me?=
 =?us-ascii?Q?ed0J13bczifX48ln4Vy08AQT4OWmiuPBLPooLcpwCac2fCR5/hZlGfObWn9z?=
 =?us-ascii?Q?EbsD8W9BBxnezLAOKIEhExsVZPsZvfqdopXfk0pkVQB6dWMoIA3NLO7r+e84?=
 =?us-ascii?Q?3IPllpc3/OKz5pEI3GphfgS89HlTy3k56DVdKJTYPg4KT5EDYfoNq90GskW8?=
 =?us-ascii?Q?HiiB6c4jo2pYWYBYJBMy+Be3rDamg8/2DuVjH/6KjT/CcABMti9qgnq8XzyK?=
 =?us-ascii?Q?OsKoybbWqIraShaxQAHtWeBiMoRq6TeMP3aWOq+I4sA+gaLP7DPV44gG0kam?=
 =?us-ascii?Q?4gtAZ3yeZBKJ3vs+KZQ1PlNCzRTQXhCgtDwi1E1+hP/qRIZxucBssm+5N674?=
 =?us-ascii?Q?V9x9VPphuK/RV4f67A5Em6e3GtjLMo6jn2czCrLicV9qbBuGZBcM8G848Cij?=
 =?us-ascii?Q?WO8UoWygZ83NuCCG4o6UP4KxcZb1brtrsXTNEv7/gvO5GaIXhxJb4w5R1EUZ?=
 =?us-ascii?Q?yPv5cu4Ng7cGfiKutNWjK00AKGqOtoLZqCGTTDswFyuzbC9vW4OKm66lqMGO?=
 =?us-ascii?Q?lrCiiRmQWHUmVXsxShLiy8yciO+3ONqrLLtauUCWxpvdFyu2/mlJUsARKINT?=
 =?us-ascii?Q?EFC57ZqFIvNEYIHbTLofswvx2osU9LdNDMFBn/pDFXtS+LqGToZ7xPSZSptR?=
 =?us-ascii?Q?7D5+qdZI9ICGlKFsIvttVOor75fge/878FQi+biirEYca3DLMxS0pAVfnNou?=
 =?us-ascii?Q?rr1/q7TH07YFE4cM+B4M3aGwodkn7GcDUgjpaSBm1BWd7HVZ4DGtapBvCWZX?=
 =?us-ascii?Q?CeVkFJu591+64BXU/apbKZ//g24G10m5xahXuD6k4LKxJy4VlgeXAtRi3lzm?=
 =?us-ascii?Q?Dgn9XIgAIfSyaXI0Z6fZ1XfUtgJwtFvVKmsa03AXa4Z7bcxrKB77RumlWjMH?=
 =?us-ascii?Q?Msca+gBqGQPEcuamu9JKsjfkqERzCitIQRQbk7Uj?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df3af52-e601-470b-823c-08dc5e9ba2a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2024 05:02:52.1368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ve4gf95MvoNsAd1UrSGk92QiIaEQswTKVB4w+I7ngUnB7kaA/+ficChWJkziegP+/esB3h8qPl9b4SU1JgKYlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6086
X-OriginatorOrg: intel.com

> From: Ye Bin <yebin10@huawei.com>
> Sent: Monday, April 15, 2024 9:50 AM
>=20
> If vfio_irq_ctx_alloc() failed will lead to 'name' memory leak.
>=20
> Fixes: 18c198c96a81 ("vfio/pci: Create persistent INTx handler")
> Signed-off-by: Ye Bin <yebin10@huawei.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

