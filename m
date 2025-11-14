Return-Path: <kvm+bounces-63201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8517AC5C5A1
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 10:45:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EEF73AD7D6
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 09:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB9B4235358;
	Fri, 14 Nov 2025 09:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gU7yTbJJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8F72F8BDF;
	Fri, 14 Nov 2025 09:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763113537; cv=fail; b=D4oCVYP12gOSxfc/7t/PqSvea6547q2ovI4ThzRz2j1dMG2ATc16J7duBYFeDoyI6HrHczPgjtQxMYmtTtGYfKkk7T4pRGZsFKksh/hNhz/Iv9PZQ9T5pBbHG2WDqiOP2gKB0/qySLIwLwAFuOuCdYfcXpi2A/JvjzL/NVn0Qog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763113537; c=relaxed/simple;
	bh=Av+vYm7RPKQ5y0n9hdX1FzNOxyO7XdxZWk5U7hr6Zek=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bDJ1KvDZDsH/erCewbcwBe8vEPz1iOcTi5ISn5ffHdzA5GDwPiRDfd5XQVL4thI+1rhIK/8Ck/pZh57kDsrz4ZguS+jmFUaa3BY4BoYfVyrnZ4gO3LruzZrgCwEqRhRsgOws32XVocx2etwudZgXBQgMb76KNQD84lWfltV8u/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gU7yTbJJ; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763113536; x=1794649536;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Av+vYm7RPKQ5y0n9hdX1FzNOxyO7XdxZWk5U7hr6Zek=;
  b=gU7yTbJJZ51kZBK+paSBdjEvwqlr/7Mq6FDk2+kRmCLFZGHmvLEmRaXz
   sb6uX31ZAqxmHmFZ5wSLeP9/BbZsPskic8lw8jB7tPHGbLD+x8AbhPbi5
   rGpQh73cQRCpgpZSS1bguwhBl3uLxF2Kw48vTkDWuvwfG6XgxQQmGWtjp
   1XoHQ82XiX6UkUO3Xtvu51TIwjBmAUTCabZeaX7SxI9fwcTB2WqMi8+/n
   6eDGD+vVT8dih/ZelIKN6VYZKEcVr5CGzOqIZqb7ELACsyyUUOnCVMHlV
   FmGid6Izsg88ivoIvW5uE4idqeJYTd2jMNNbGGj/TAH7Gjbuq01nE71Ca
   g==;
X-CSE-ConnectionGUID: 2+whT9V1TTylMXE3D4Ywwg==
X-CSE-MsgGUID: LIc/XuwWRYy21txxCo1L9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="90684322"
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="90684322"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 01:45:35 -0800
X-CSE-ConnectionGUID: y+gBdsSbTDGV1RjKJuJzvQ==
X-CSE-MsgGUID: fJYkmjPLSUCYI161wVr/rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="194724623"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 01:45:34 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 01:45:34 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 01:45:34 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.9) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 01:45:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ga9A8LG3IDafm7T66mnXgRRdHULynPBHtLKpOxH18Mv0Av4DXGz0OWcFBuWtSiUk3wKV7hScHYBIOuGZUioCZY2VW//sy2Um63gZrye6NUARTQ4LLbhvjqHFTxyaAavxSu4zrvhJ78U2fJ4W61imWNAPX5H+7Il/QqsVVHfp2wPLEizVb4SUA6BQ958jpaJW3IL6bYxAVDMqJI0Vf5Z7qJP4QVH5Zion70O0roG0NwUOP37Mpeo8ffWLWh7KUXXoKjT9U5ZyRj/sQbUOAx4QXtFkyFGouFCCgn5KtaNmVB+qFAll+O21MYafzlf7bx0SgO/p5UofRk49PHIfdGsAxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NqXMMLB2Vc+lrB+fGQUb4CsNuH+tk9S51j0VE9/nSTA=;
 b=uo6ah3F9QCLY9W0v6Mtgl5y69vZ20gulXWluFQVKhizctJCuNsP7NPYWHlsFQAqVbyFmZeHHxwHxretZqXAR3ebIe7fl4bemwTTQgirT12lqYQTdH8xZoKewJ+PQBzRTjWRL+WWWX8Lj+M3lhC5w6Y8IRExRpwUc2wV/75DU/6kTFr8dDLdxz961H2Dc32neu+9krca9cNnEao6CP8mOixAyA6TWJl4ggMFUKQEAnZqqmLufa4Ll1AMa/x+3ctVQK2aJuiYPfqtcSx5QT1Eyzlks8dQ2JTqQFa3pTnPP8mPk/TZS8JpQtD24HHeRrLxsH6kEHmWtEkRzfDpBKVTWVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB5328.namprd11.prod.outlook.com (2603:10b6:5:393::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 09:45:32 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 09:45:32 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"afael@kernel.org" <afael@kernel.org>, "bhelgaas@google.com"
	<bhelgaas@google.com>, "alex@shazbot.org" <alex@shazbot.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>
CC: "will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "lenb@kernel.org" <lenb@kernel.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Jaroszynski, Piotr"
	<pjaroszynski@nvidia.com>, "Sethi, Vikram" <vsethi@nvidia.com>,
	"helgaas@kernel.org" <helgaas@kernel.org>, "etzhao1900@gmail.com"
	<etzhao1900@gmail.com>
Subject: RE: [PATCH v5 5/5] pci: Suspend iommu function prior to resetting a
 device
Thread-Topic: [PATCH v5 5/5] pci: Suspend iommu function prior to resetting a
 device
Thread-Index: AQHcUsnzy6x4f36ohkm++SV8i6qV3LTx7zWg
Date: Fri, 14 Nov 2025 09:45:31 +0000
Message-ID: <BN9PR11MB52762516D6259BBD8C3740518CCAA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <a166b07a254d3becfcb0f86e4911af556acbe2a9.1762835355.git.nicolinc@nvidia.com>
In-Reply-To: <a166b07a254d3becfcb0f86e4911af556acbe2a9.1762835355.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB5328:EE_
x-ms-office365-filtering-correlation-id: 79ac4c56-da06-4717-7948-08de23628d73
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?NbqV+ZfytZd2Bzq58yClBxNwJgdWxf9eibRQbf3EMxRYNms47y5z8Ma6GDKY?=
 =?us-ascii?Q?2fPFDMyZRVWIs5JXPb4+4fCDs5LIJ+jI+MPRdeoy6KmNBDz5aLJ+sAihmv+P?=
 =?us-ascii?Q?hF7q9YYbldHWZghkQhsjmwHOYGRy7rGwLMYuM3cPvIy/8tllFXBerkKLmErZ?=
 =?us-ascii?Q?pyNPZ9YQCMgV/narKE3Mp1582jjG1uJQ9uRS2AbdSd5T4P3rJ2nnsPMM1y9M?=
 =?us-ascii?Q?lZ3Jhtq6s7zgbxPMnoZfM6Q7B16xyyMgOEUhkIV/Anb2P2knAehCAROAWSqQ?=
 =?us-ascii?Q?iuRqAA5mWiRqDSbX2jsT21YQJtaMgkQ5EVc9i7aL3xueX5v6tDMCB1y7xJDI?=
 =?us-ascii?Q?yNynA/UmTNUDROpgoPJ6ihWusmBm2AJuAcHc+utXbsGLKh/EV4TJhIhv2aBF?=
 =?us-ascii?Q?OOnvBhbRTx8tPV/Zc6C/9rjVtWTGv0Sa3YfdRVcCJDcOeuL+UsRMXDLGfyQp?=
 =?us-ascii?Q?ckVQ91WMrgtChXnrSIKZJcdGw5cX2w8xL2HDjOghzqUgEmks0X6UDisUNWHQ?=
 =?us-ascii?Q?6zPa0hwGkWL8CU6GhdDFXLspsKkY6bnapBOUq9NlvRdy4KICr1NWmOWQ6TPa?=
 =?us-ascii?Q?veSsI9SMV7Mrsu0+6GnaTrIl54GmSMyunffwEp4fHdPl3dKqPmdvjWHET5HT?=
 =?us-ascii?Q?wWiQMzD2/IawTesa9o9A12rju1ZyRvZ1ZesY2UbLxDOcaaNe8tR3UUER7fS+?=
 =?us-ascii?Q?5GXz8oh2DMONqn39Zkdub8GIleQHqLpuLC9CN0SnBWTGlT9OCeDhy39eD5OF?=
 =?us-ascii?Q?M85oj92DecX077tNok8K4qYUtZk6VhFxpSGretoRNDsaillpbvcxSmsBAvO8?=
 =?us-ascii?Q?Fc8dR1bikebi0+6nLuqFgU8RaSTd1NS4vE7rDpGwoy/T7B4gKP4HeWJN24wu?=
 =?us-ascii?Q?E1jjlFit5SWdrzSMbRIQuFoedJk5q2Qywlj3REUXC3FWWFzNhgAQTl+mETdI?=
 =?us-ascii?Q?Dk/PAMABRW+yoGWDdfjNArolFJ1DZlrgZZgVVlKNfJqIshKnfJcZbk35fbQL?=
 =?us-ascii?Q?B5b1Vt9pYzxtTX3tirlSL5z+esEO+klReCvvt4l+L3FKPOJ/fD/c7YzPC9al?=
 =?us-ascii?Q?MHEqswED3UPNXUwLjnDGQS2IoytUGJs2UP/oOOaVwZjUAv1fqlF1DC23Ep4s?=
 =?us-ascii?Q?02jSEartwOvQhON1UPYkP7T7xZT484UazsUfqtkO1I/xOnxhoN3UEXldH3Z6?=
 =?us-ascii?Q?ofzqOcDxljGXNMVC7DnJHRWB3P68fUAIID44gYMU4ZtwSWz39bii8LxU+y+B?=
 =?us-ascii?Q?VU65DcVxtfN2HrDg0iCBtTEhla41giUWPzPe0RkhKkdQ1W9rlqwo0vYA/VHl?=
 =?us-ascii?Q?jDERIFHs6nA2QPlIJdU9mmiXc32tzrkw8eVUrkM6fivEzUybDUEVP5OmbM2d?=
 =?us-ascii?Q?XVYDzYd+2Z2S0ZBxmePmZIUhz2eKwwVbCsg259cbNokE8md07SXM4guzFPTC?=
 =?us-ascii?Q?gdy5Kbr8Yd35r9GHy5RE2pe0FfY+CpVwyhYGg5aLRk0d/oqYm9IYzgTbaN7v?=
 =?us-ascii?Q?9BKrmip0vhFontO3c9skAF/xNWGAcuvGI0UG?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tjP3xgRwaOD4jkvrQ0AYYcFnuqMoX64PBTFwlcZExcbX3MOw1fbVZi9XbngC?=
 =?us-ascii?Q?iewAuABWRdYhvw98EvhsWW8doHunXwF400XWYB+VBVpvkRXv44tvxoxhuLIC?=
 =?us-ascii?Q?ZNFccYQdVxZeblHBPwCJAvQMqGf69W9PCsDjZguzcJ9eZSiKrK0b2AjWjYa2?=
 =?us-ascii?Q?INgOM60WPK9i8l6slmrYJNegYUP/6Ohjxmtv74p13DjHSglZaAseJNRZEVqF?=
 =?us-ascii?Q?FOg6y+eAffnQRiXk3/6lthmLyOXr8Qd6Tn4Ow0sD8YWcOvtL95/maMSpoySk?=
 =?us-ascii?Q?uhYho5gvlZ4r8pp7YHAzup4sKGZ/UJJZFTv35RUN/AMH/PcE0WER8KpSuXJJ?=
 =?us-ascii?Q?EOMNACoL1eR6oi1pNTj9FTraPf1utooIkZmmJWuEOgMLZRKJ6iou178oljWj?=
 =?us-ascii?Q?tlcAQD7GXI33OfJOG0/NQGBW69I3MDVjqMC/6uz4mewokQLqjCSOieNbwR1e?=
 =?us-ascii?Q?ycIANjsd9NlGdNHKRE0EpMl+DlZ5Qwhr3DiazhlM2w6fD+81oMthoqfJOPJt?=
 =?us-ascii?Q?DiP751WI45EeSYWIVhGnttbhozPE0gT31Cq5Du3285uXV6/3nZ36qtYeZPy0?=
 =?us-ascii?Q?WoNpCLG5X0Yv4BbfA5ELZSQVYIf9pIqt7tipr24Sv8JBizOOz6oiy5cEecA8?=
 =?us-ascii?Q?X++LmE4SvM973S+zA0wQABcj76jQCFOVcDd4Pa+jdJ63v5BnoO/2qA2EuQYS?=
 =?us-ascii?Q?eZtJKqyCkM4iK75PBIln0D9AE8Znw60Su01y85N6OPGcMnu8nTvW8+n0VzoC?=
 =?us-ascii?Q?1f8trJBvJpoIOQhjDVqoi8ZIm2XZM1cCA/P5GRZRC81cKJsQeVNF4cZ9e4Xm?=
 =?us-ascii?Q?cyCViVMxUzM54tOto4iBKBef6bWxeBs2O+csI6yn10d8jG+IBhwma3LDNEzA?=
 =?us-ascii?Q?yrGeSfFxpG66EGwet67uzcgOrHDLLURYq78IISQ0EYrg3MP6A8VCIjC341mP?=
 =?us-ascii?Q?5l7qtgvTPTCgTN4dbpETaJz1sv1K1LrINQ3Bm/R2c4gULqZaok9LmTH9lGnX?=
 =?us-ascii?Q?bj8C2DzD0aoXnBTACa2UtFtDN4n7DYIhc+H4SPk4+bf29RmeheBGsVjhNb6D?=
 =?us-ascii?Q?5fNaEZQ7Rp7UqtmgjKYkZ5ewfIajiPlO0Z4P1O+nfS2C/3PVBsIn7tpTVJnP?=
 =?us-ascii?Q?P900nmGEe3SmtLMQkNVh88u9lGvRNrwOQbid7B/YFF376j6YmHw+9qqnQ5YX?=
 =?us-ascii?Q?jtTFbgC3hPQi5dYpPTfDcxgrb2UBf/hHs5y0wudFq0njC/voA436eCKCJGDS?=
 =?us-ascii?Q?dyfqc2splrnIalCK1GJBQCjXKkQem6IdklkuRErvtbgNdbieTP5xX+2S9Ooc?=
 =?us-ascii?Q?bLz9N7JaJOMtAq1E41MalSv1nwIOvmDYgEo4YruDMs7NnmNzznr2Y5OB/WH0?=
 =?us-ascii?Q?HnJ8DJtgtgtIJ1WO3zNsrvBYhxQuBTANOWDuaFdtqNouZPyls477QIjDQAp4?=
 =?us-ascii?Q?ijuaJ17r/dfYmaOBSD9XvevrEUlPq4iBKyF+YwTOXr7+8XeEyKDDHacs2SVb?=
 =?us-ascii?Q?VEGULwSjZUQdpdhC6L4kNUi+aSmI1y7vyvaknb9TVfJR8bcnBe61ug/SYGQ7?=
 =?us-ascii?Q?X89jXGpbL0++0SPgyawA68trb/sNaJTPVAF6/cs9?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 79ac4c56-da06-4717-7948-08de23628d73
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2025 09:45:32.0057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LAIwGxoafwGR7vgC5+lZH09YzZTfe86CdT6OJCQs1L8M8SNec2sXGaLv4OU8emDWAWTXU7tUcIbhq8DSp/juRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5328
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Tuesday, November 11, 2025 1:13 PM
>=20
> PCIe permits a device to ignore ATS invalidation TLPs, while processing a
> reset. This creates a problem visible to the OS where an ATS invalidation
> command will time out: e.g. an SVA domain will have no coordination with =
a
> reset event and can racily issue ATS invalidations to a resetting device.
>=20
> The PCIe spec in sec 10.3.1 IMPLEMENTATION NOTE recommends to disable
> and
> block ATS before initiating a Function Level Reset. It also mentions that
> other reset methods could have the same vulnerability as well.
>=20
> Now iommu_dev_reset_prepare/done() helpers are introduced for this
> matter.
> Use them in all the existing reset functions, which will attach the devic=
e

looks pci_reset_bus_function() was missed?

> @@ -971,6 +971,7 @@ void pci_set_acpi_fwnode(struct pci_dev *dev)
>  int pci_dev_acpi_reset(struct pci_dev *dev, bool probe)
>  {
>  	acpi_handle handle =3D ACPI_HANDLE(&dev->dev);
> +	int ret =3D 0;

no need to initialize it. ditto for other reset functions.

> +/*
> + * Per PCIe r6.3, sec 10.3.1 IMPLEMENTATION NOTE, software disables ATS
> before
> + * initiating a reset. Notify the iommu driver that enabled ATS.
> + */
> +int pci_reset_iommu_prepare(struct pci_dev *dev)
> +{
> +	if (pci_ats_supported(dev))
> +		return iommu_dev_reset_prepare(&dev->dev);
> +	return 0;
> +}

the comment says "driver that enabled ATS", but the code checks
whether ATS is supported.

which one is desired?

>=20
> +	/* Have to call it after waiting for pending DMA transaction */
> +	ret =3D pci_reset_iommu_prepare(dev);
> +	if (ret) {
> +		pci_err(dev, "failed to stop IOMMU\n");

the error message could be more informative.

