Return-Path: <kvm+bounces-1290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9632E7E62D2
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 05:27:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D1436B2105B
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 04:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A52563B8;
	Thu,  9 Nov 2023 04:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bHK8KV4K"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57522611F
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 04:27:03 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E4926AB;
	Wed,  8 Nov 2023 20:27:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8rUKhzXQhaMTUPlM6Q4OloKxMiYq7QrULjazZZQBwbSbj2svW6UxQcgx/UwqY1Gw79j4/GyHAwfib51ZO58LyMW95Z8M9uMEuFrb9IqRKkcaXbWfSj0/YJMboHAbgrTXMTiGjOKPpL18FQncgvo44t2HAICbLVwMYKBB2Ccku+zK9EDRT0IMPADxyyYq2b0jxbeXZjWYWI2Z6SpUUIo0o1Nm22w2UJecvKMBhxhvMZui/c253JJPq0biz02pUGOuZyGSqL/a7DJcGBGWmCpR/TTyHdEPCi/QOcj9600jEA4cAHZ3Er8k2WwXcf3DWD9Ryd5XYxhv+Dr/VwnBNHV8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TH7gNH1dwX5nL3hpqItBRxJhJ3j2SpnSJAuYHdUGGC4=;
 b=oIwPfLgE4EgBtic8Spivfh/qWCn9qjXo5utEV6F+NmwJ5XoIJY00s2Ab/1vL/l3BoR4ILKL5AcS3lHSmZB0kXlWPYu+ECgNhKueAmaKaJGZ7LjcfbXl2uyYeZzkCJMGvsrVv6QuymFia5peKfKL4s/k5MAIK5xbmqIf219YuaqIORQzckoh47P17D8MwHJI7je4tmPsR1qJF/e6IYBiNjuL6+v/8e8uLCLh5Un/9R1YXC9JcnadjxCAbgdtrgHHazwdEK2seLhGPs4fr7Nd9KC0G63plbu648ZZIyyVE2ed5ll5G/8TH+0fFQnByHWCX66Mn2fXaUnqUChFwyDni7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TH7gNH1dwX5nL3hpqItBRxJhJ3j2SpnSJAuYHdUGGC4=;
 b=bHK8KV4KSzwgzDENnK7yWFhLfKv9Et18eY/D9Q8hpnarZuCl2b4aKgb7hsFbLqp+jLmtuOMopUGIgUOSTrZ5oCw+mH6/ZUUMHBP4PhYVQX5O8Ixpbg8Ad3ddsoR5pCZs13pO7K2mEK4roXPAbfBnLQ2TaQmTsIuWhdfHQpmS4giYwISlPItOciB1WhwFaRpHw9RUa+M8wBXv36Yisy5dTEZRi9DBWhbnUrx+xLTBHjI0da42tnoxqDJZmyB9x10bXSR0P0N1KoXE90OFB0u15qmwHHrBzx2N1t3pZcqni3xKlMk0oswIeaRkEigQ3ZTGvOONAnIYyKNo0X8aOrN5LQ==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by SA3PR12MB8439.namprd12.prod.outlook.com (2603:10b6:806:2f7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Thu, 9 Nov
 2023 04:27:00 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::946b:df84:1f08:737a]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::946b:df84:1f08:737a%4]) with mapi id 15.20.6954.029; Thu, 9 Nov 2023
 04:27:00 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>, "shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, Aniket Agashe <aniketa@nvidia.com>,
	Neo Jia <cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun
 Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v12 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Thread-Index:
 AQHZ/4T6dPreO49caEWsaHN/ceuQqrBOmsSAgAi/5YSAACTLAIABhTmtgAAJHQCAAS20AIAAOkSMgAAn94CAFurKBw==
Date: Thu, 9 Nov 2023 04:27:00 +0000
Message-ID:
 <BY5PR12MB376365035E31B569D767D636B0AFA@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20231015163047.20391-1-ankita@nvidia.com>
	<20231017165437.69a84f0c.alex.williamson@redhat.com>
	<BY5PR12MB3763356FC8CD2A7B307BD9AAB0D8A@BY5PR12MB3763.namprd12.prod.outlook.com>
	<20231023084312.15b8e37e.alex.williamson@redhat.com>
	<BY5PR12MB37636C06DED20856CF604A86B0DFA@BY5PR12MB3763.namprd12.prod.outlook.com>
	<20231024082854.0b767d74.alex.williamson@redhat.com>
	<BN9PR11MB5276A59033E514C051E9E4618CDEA@BN9PR11MB5276.namprd11.prod.outlook.com>
	<BY5PR12MB376386DD53954BC3233AF595B0DEA@BY5PR12MB3763.namprd12.prod.outlook.com>
 <20231025082019.14575863.alex.williamson@redhat.com>
In-Reply-To: <20231025082019.14575863.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|SA3PR12MB8439:EE_
x-ms-office365-filtering-correlation-id: df587a97-908e-4580-b27d-08dbe0dc1e03
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 cTlE/yCxdxRZbiEFtqxgYvnLFDVKygSjeWf2bM0eAoiQfH6ajDrKhI9EkgWq4JX9+2EIJSQySwwdjzoXKUzm2ih4ZZSQ0tNTkQzZhtIf9BNXVKngHTWKakYej070TCZelvkiY7Ubj5FwH0H3AwQfeYJCcHo5My6f+xjNO36GL05pkf8s5Gxqx9wrkmjh9TPyjIVOwmPkQ1u6i/FFtx5Z2unT5gqCmZ/vJP6esWLHdbljx+Dc8J1tp3TYY9cJcAO4BBUBUksPdHggptGR6wxEA6ZE+4Z4DPB+79hGJtk3U0luStrn1PGLDBMxSqc7b7Xd687VB67dykvajKBc9hFTH8pCafDctVXJMYpx6rzywcpydrY4U7Dy9yYOD3htKuCgpQUOs4NwuHzJm0yCs6o174vdQTOjnS+0o6zihrmO4T9an9iVfVz5Cod1os1PTtRJcNtfhSWvklU6DXGNjRYooEKUfovUGmPsMvGfqKVW+T6fATMb780ZmqIRRd9+Y/VLJTBb8hoD16xfWC3m5KSYBoLX5C336bUx2AopYTkUPXGjlLFKPQlUhO254Eh13Ozd6+2kJcxGs9iMQ990n55bHu+miovPCFdM3SyG3itp0W2pp7oieUllCL7jMS11zB9K
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(346002)(376002)(366004)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(9686003)(41300700001)(7696005)(6506007)(478600001)(71200400001)(8936002)(83380400001)(316002)(52536014)(8676002)(5660300002)(76116006)(2906002)(64756008)(66476007)(91956017)(4744005)(66946007)(54906003)(26005)(66446008)(6916009)(66556008)(38100700002)(122000001)(4326008)(86362001)(33656002)(38070700009)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?7m9Rj4tSdujRDh/DMJXlScvy1cJcDwjNnrlDKCDxXOHRZJyuUMwAGMWzwa?=
 =?iso-8859-1?Q?jFBTqKJufzXVUJOVgdXuSsz/iKu+o6aq6dMiLOtbxbzmRFL8zEl3i+rfqn?=
 =?iso-8859-1?Q?dvTDEHzu8AkGZ+Oz5DJOuo0f+PaS0fYiYMX4kfkPPIoekUlxxSgIOuCC/Z?=
 =?iso-8859-1?Q?tdAVE1qDs+fybt80xe+mzw4l71M7U+pb1bKU1BgH3bCyEzVuDWenW5sUuq?=
 =?iso-8859-1?Q?W8sHeF0jmUrI4wB5VLdD9xFTiho0Zc3vI7VHXBNWS/YzpwLY4i5k+950qn?=
 =?iso-8859-1?Q?Ew1EmSaW0DNIOFjNEX/5VHzGktB2e+ooJWEQavsufDJN8tB+aJAROQcufU?=
 =?iso-8859-1?Q?no/nr0uprd4Vd2TJ7ArbfDO/xVPeqP2IlN5dbJr1F8Y3KdObj7foRQf79+?=
 =?iso-8859-1?Q?9UsITFP3IBCg9UvpF7TuS0rFMZ/aL84ZC6YfYzWPiAIiEUMy4ol/6nFnFy?=
 =?iso-8859-1?Q?RHk64PLD+ngbgCqdVbwoDBLATSt3SSpSyubhzxogy2JjyjbMeJtKntSRMJ?=
 =?iso-8859-1?Q?GFLnaWAvUaJXj+YvH/rNqZCUW1JF2tG92+jJe4uzuI7mlkhWeH9U1Zar45?=
 =?iso-8859-1?Q?yDM4HzkoXJMwxyLQ+KzzFN8wZjPDZ8bk5r4kmMdap1RVbBKf3htMEjdGBA?=
 =?iso-8859-1?Q?fvUWIrzGHFQctHAaBLED9gVwDwHbI4iH6O6PkaGixsaglQJoZIqzbKSak8?=
 =?iso-8859-1?Q?xfORo48jccG8tOJEd3+URqv7YumOQopyGSEFIm7Tgk6pxT03FoY/7RddLV?=
 =?iso-8859-1?Q?DnU3wR/aNDI07Watlc5UYC+C+nFpTuNqrUXXfo/6Mr60xMY2iRn9Miy8oO?=
 =?iso-8859-1?Q?ruxqZEa39svwtRsUOR0B0DJ/eq+4HEKO7l+uWxke+wR7wQCDnxCFtnfcuO?=
 =?iso-8859-1?Q?1ooooxNRX28Q2QwcqfcOxtL8MrV6QIyDnOWnX6iPdbkbjvElfP9Q4Ae+ZZ?=
 =?iso-8859-1?Q?DELIXnqYYlXI+Jrs2BGf+dUrppUkqJfcr1McSlnDbOeKSil/Otwm8sPzMN?=
 =?iso-8859-1?Q?L88nmoDHr0R0WWJE0+SU9wjRSnX5yKSLItO3AZ02V8Wl0JRxS/JwnkihA7?=
 =?iso-8859-1?Q?ofsxaqiA9C4XAMpusmtKDJ3DmB/3w3/bQUxFtM56pfvLD2p8VepF/Dc2yZ?=
 =?iso-8859-1?Q?QYQdRQZLJgQm26BmmKn99guv7NaUafqGGjA1J7FlCVryEe1E/CqCHQqZQe?=
 =?iso-8859-1?Q?lQ4KVHPIPsxCEBvylIXdADVPISBunVL0aQsDvWngTVTJ9BR1Fa1U5986vf?=
 =?iso-8859-1?Q?6YrxJSu0ek6Q8zcQNCM5bNKcc5r87eI5FAbgUspq7eqBOVOeUmBRCBgc+8?=
 =?iso-8859-1?Q?k9OmDQi3sg6zYNYW2bEsFsmXsSv/sir4gEBGWBLexViCwevYehsuXcLWeB?=
 =?iso-8859-1?Q?g0vukow32WQmKSM/8xrp35FE2AElRkYMTWDrvssQaIZ8tmoa16Rfiouf8L?=
 =?iso-8859-1?Q?dnuQBC8FTIpTWPysRP1e665Op8xiqKmU+CfQ8Fni82osFx42tzMcunTUBs?=
 =?iso-8859-1?Q?QegpbJhvxyb8AJ5IrW1LIbOsWQTpIl94F3l9zlsO9TaoqDUPVNCw1al4b3?=
 =?iso-8859-1?Q?F9mKBB/N0rxAOKRW7zABSXwJIFqu+bjlelSKDLIbqE4eZQXZWoE/4IcKJB?=
 =?iso-8859-1?Q?dwe3rBlusG3MI=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df587a97-908e-4580-b27d-08dbe0dc1e03
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2023 04:27:00.3535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RMrOrbyN+0+7s1OCu7DrCwChXJdi1thGSQ0oU/HCruFk2EDH2yd77j4A47yUbYKL/1voDaHKI0O7wuDh7cBd+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8439

> In light of that, I don't think we should be independently calculating=0A=
> the BAR2 region size using roundup_pow_of_two(nvdev->memlength).=0A=
> Instead we should be using pci_resource_len() of the physical BAR2 to=0A=
> make it evident that this relationship exists.=0A=
=0A=
Just wanted to update on the discussions.. Since the underlying physical=0A=
BAR is not being used at all, we will emulate the PCI config BAR registers=
=0A=
for the fake BAR. Thus, the read/write requests to those registers will not=
=0A=
go to the underlying BAR on the device. I'll make the change in the next=0A=
posting.=

