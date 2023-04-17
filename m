Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06A46E49C9
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 15:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjDQNVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 09:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjDQNVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 09:21:24 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2067.outbound.protection.outlook.com [40.107.96.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA56B0;
        Mon, 17 Apr 2023 06:21:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFz8N/BMIEXgcUcTVEgpOtXh72NZAtnrYOOOICfS52OdweWfd1NjQ4WTFmLw10Lrytvj2XKSd638QTCCWrwJV5GQCs0ie+oUsPbOCam7VdITQf4aejhyIh0i5xVtNnhKA2XJ3U7abaQDVuiH/CNeFMf4aaHozqw+QkagfWnmlMn7HFPL/nh8n7suAV/6wplkajQaeR9TKZ+RknmZvvz6VdJ0jZVp0RvPmwysilw88O8W6ggS3W1mdWtxPJco9rFWPyxxb/qlW/KR9VIzM3f/9d56gMVqvFNt9nvECZBTCPoV0mhmACWs6znY7RaI5O8HCuPmP9W8qNkrez6Xs+vhxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KX+0RnpI/PM3OMfTg7nkQbd5Q6i4xPtC1VlYU9tvVKU=;
 b=DIeWeS3kPH8sRJ1JuW1OlRSCkja39WYDNWAmHmYcuAEvvuTKRRpSySTol2D2qdLdagNfuEKmBigtDhG7h6qkvinCqffI5ZqaHXV+hrjNIynfo8FpjK0mRDWD02JDY16qqZsVgtDBv9MedonRfEl+NmaFOPftD81uAt8cs09nx3J7HkMXmS+znx0IcRR5Gup6chfA9/RZlZTeKmWoql0IeDjQp/cbHE29u5ApNw/0YqgFvN5RY27aCg/4mqwaQpvu/kZuvCy4ICaEjNttck5uDjwG0yZ9hj31AXPu1yr3mpLX5G9ndRmk4tr1U0mXKTFvVYkpvnnypa+4EBZiQIwJbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KX+0RnpI/PM3OMfTg7nkQbd5Q6i4xPtC1VlYU9tvVKU=;
 b=B4dRnSRsBRuN+OvT7I3gtQJ/vHTjRAaHHlRbX50oKwB+Tt86p3Ag/fUhS8ixa2VTsDYY/EU5nEtdu1wbLiIVJET1670qC4mkTW3U29n0BYHIasumnygx+aex2vZvTuFo7X5BXUHO8ZV4G6KocgvXdfjQNcn7sIOu6sTMmu7rEt4=
Received: from CH3PR12MB8308.namprd12.prod.outlook.com (2603:10b6:610:131::8)
 by SA1PR12MB8643.namprd12.prod.outlook.com (2603:10b6:806:387::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 13:21:20 +0000
Received: from CH3PR12MB8308.namprd12.prod.outlook.com
 ([fe80::4e4f:3a93:b7bd:489c]) by CH3PR12MB8308.namprd12.prod.outlook.com
 ([fe80::4e4f:3a93:b7bd:489c%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 13:21:20 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "nicolas@fjasle.eu" <nicolas@fjasle.eu>,
        "git (AMD-Xilinx)" <git@amd.com>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Jansen Van Vuuren, Pieter" <pieter.jansen-van-vuuren@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>
Subject: RE: [PATCH v2] vfio/cdx: add support for CDX bus
Thread-Topic: [PATCH v2] vfio/cdx: add support for CDX bus
Thread-Index: AQHZbs15HOi8AGJVHEyZ47Q7VDPnRK8rVKsAgAQr/ACAAABjgA==
Date:   Mon, 17 Apr 2023 13:21:20 +0000
Message-ID: <CH3PR12MB830804AFBF4623C9CF78F3A3E89C9@CH3PR12MB8308.namprd12.prod.outlook.com>
References: <20230414123414.21645-1-nipun.gupta@amd.com>
 <20230414153614.3b72e659.alex.williamson@redhat.com>
 <ZD1HMkbdhQpAYs7P@ziepe.ca>
In-Reply-To: <ZD1HMkbdhQpAYs7P@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2023-04-17T13:21:17Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=014aca73-68e9-4bda-8d7a-c6aabc41e417;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB8308:EE_|SA1PR12MB8643:EE_
x-ms-office365-filtering-correlation-id: 29a80878-1301-4e41-1b50-08db3f46a205
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /CONaxC7kQkVVzOkF3vmoLJxYBviGpIjERM7gnnmMJKtz9RCWbcIDaYmo9tgXUyZI10QfLDSVT9R6MhUh6Lxxj8Galt3q5jnR3pPATLxiwQhAmNag87cQ5toRe8LgYLv4qJa5rAtYT95m0s8yjq+ZRzbVZ6iu5wJxSqMGtZjseHCOst/0lnwVAWHHSuYcL0n469crUz07YO/YsX2ukAkFOFH/BQ4Wfxu0EHusFuoV3It3aAHQNKuxuthR3PwGFNBIduELt6V+UMf82k7cHeZyOFAqlEMYh+b0u/znACKZN0YOzqFSdhyYLbMz4+vBUrQxDVP57R4rh294g9Bh7gVlzIi8Q8zglCM3w3r/OI8Z8KkJvrye74hfBptzpLa8QVBO9YjiAeRfpSE/Zqox+zBUTJFT4UJCJCa7XKR9AImPwt1UvuFU5xtq20leg6H2NJg379GhJanmXY9bf+Kh0Kr6Agn/fBWJpxEtXVB/I3Urw2q7YO3V9mjIhyGINJdW6nG/VxRpuWhdAqKTpd6cLDfgAH+2z5tq0I3V5evnuhMVpWEpNSbXxyJ7k6CKK2zoZnFWbW3npO18Vkwa0va2EwmAw68AoaWywvTQDa4KwPx2fuSnLWPgmvNeEkKcqZM+bhH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8308.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(451199021)(33656002)(110136005)(54906003)(4326008)(316002)(76116006)(66556008)(66446008)(64756008)(66946007)(66476007)(71200400001)(478600001)(7696005)(55016003)(5660300002)(8936002)(8676002)(41300700001)(52536014)(2906002)(38070700005)(86362001)(122000001)(38100700002)(26005)(6506007)(9686003)(186003)(53546011)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hzUF/thpSc3aBP7DFQjf2Z7DwQV3C/Potaort+VTgbBieFzqnMLmMti3M0zi?=
 =?us-ascii?Q?QQrrC040beJcxwE4i40rcVGR4QMiA5XCJwpxY43XHWV9rEgCdOKPzMcFHFrN?=
 =?us-ascii?Q?qR/2RsExxWZv9pu0LpR+HNYFLcAXhaWevQTzEVW6YfDC8+CneHseV4XcPiOi?=
 =?us-ascii?Q?ZIr1jIjVa/nK/n8w41Yb2Hh2wGPM8jeMwvxXRCLm+rI9p8DyStbP/WvJTPcW?=
 =?us-ascii?Q?JF8+0+78jibZToayM+O/HAdfW2sGHDJyjIK3gq3es05f8zTlTRyYV/BtfK3K?=
 =?us-ascii?Q?nSSS1La+wK6DOGAycZc5mlAdBrGCUQ5rnt8sNoR3JgJMUJm524dktDfM3L/6?=
 =?us-ascii?Q?u+d47KwQkZ5hsK31zgIgrCWqtp0i213qgOPXqPacAjh2NUjBeU+hg+roEGaU?=
 =?us-ascii?Q?Wla6I57HiA2Ylcf1qFXQZfSozSm/uE7e8sn34Y5H1T+HSVfNq8kH7J4QA8Mg?=
 =?us-ascii?Q?ln5fvfMb7WEPbXvFTryo7A09EUabX4nyiz2vQdGoSs5wrf2G30uZ1jBXC9SC?=
 =?us-ascii?Q?nC0+clgAFz+ZLDz6Hh0M8ku0CNhcY/dPEEXW6yVYMqhV9SmPIK0gb1ACv5Xw?=
 =?us-ascii?Q?zS9AWIPq8NiPozxwBSZEGpoqafgVc5ar6OvJ5s33SxFzb1CFC4AUUZ+C0OpQ?=
 =?us-ascii?Q?bgvxjDRrG0Vj9039KuLgGb471UoWOj/Btrl0lUGCyrG8OPQFeE7krLgmYn10?=
 =?us-ascii?Q?hjBe6NYOBADBKFYB5MPK0/Se+Fi9Sw7q+Xx7Bns137U9RJE3BmMV4O3/BReI?=
 =?us-ascii?Q?yB+wqnTUFtAdm5xjg3HBE9S3BVPhP7bhCNXHMY10M5Ubh6mP8OMgo/Qbn3Og?=
 =?us-ascii?Q?rzaDn3UOa9ZxuXNR2avWdl6jiahOTviQirX/VFsVDpxdXBDym9dpo+hdaA05?=
 =?us-ascii?Q?2blpbL/96b8PrJkqxCTsZXH0yPLerf7Hs9375BWTA0bWjHL9ImAeadkijymZ?=
 =?us-ascii?Q?xvvF9rZy+UoOmrVF53b5VsttJ4cbqdhYgchbuki+A2a/EsyEjP3Ag1o5AxKN?=
 =?us-ascii?Q?TKf1EeVQrW0mZLuciWWSDiUX35gNKTvQOq8kQxVLqqntnyT0AgW1KZPnAvLs?=
 =?us-ascii?Q?ewxOWN/aYalVLGEtQqXkpiM1Zl8bdgqmiito9pDrj+YggdBjSA03eIIzueK6?=
 =?us-ascii?Q?8kltlbft/B6kLwKCCjFQ7+DEi/gMqCr5HU8dZ4hAAEidE5YJMDYWuPdfnV+s?=
 =?us-ascii?Q?2yT99QGAtkM+ipCvHFxWqy6esGTu4mgjOZZtUOioa10vi6FEnW70mriMpxRJ?=
 =?us-ascii?Q?s3LN8NOjKSz6VrCFG7zMYtzLELAj6/v7OvhuIsoOGj1BngIrrvfdfE0cu8Gp?=
 =?us-ascii?Q?PiEHeGlhLw/or3/p8rwCY9ExJ4z1mUnz/mv88Rw0Em8IZFPBoDH9+gNg+ZqH?=
 =?us-ascii?Q?JpwrF4zO5kxEDyO9LsjMZ0fm36rAMo+6sQYm/m6piJsbFZoZdEu4aAH206kY?=
 =?us-ascii?Q?6oXqFKrAF5pXE/gfuV42EkclKArlnW00cb0Bx/fdxLeUiFDXktqHITXLgSdQ?=
 =?us-ascii?Q?cGziZB1/YnQV1242PxqRJyQva1qYEubETxn6ykSFIZyfW27v2etuv4Va4eo4?=
 =?us-ascii?Q?dQdcHoo2nvfdCwr21KU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8308.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a80878-1301-4e41-1b50-08db3f46a205
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2023 13:21:20.1387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vKpZaF8rlq6J1jV+aUExf9fT8YhJ7c+5bkMCF3CEFKNiQglYVdYGPnhJgphqxw5i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8643
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Monday, April 17, 2023 6:49 PM
> To: Alex Williamson <alex.williamson@redhat.com>
> Cc: Gupta, Nipun <Nipun.Gupta@amd.com>; linux-kernel@vger.kernel.org;
> kvm@vger.kernel.org; masahiroy@kernel.org; nathan@kernel.org;
> ndesaulniers@google.com; nicolas@fjasle.eu; git (AMD-Xilinx) <git@amd.com=
>;
> Anand, Harpreet <harpreet.anand@amd.com>; Jansen Van Vuuren, Pieter
> <pieter.jansen-van-vuuren@amd.com>; Agarwal, Nikhil
> <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>
> Subject: Re: [PATCH v2] vfio/cdx: add support for CDX bus
>=20
> Caution: This message originated from an External Source. Use proper caut=
ion
> when opening attachments, clicking links, or responding.
>=20
>=20
> On Fri, Apr 14, 2023 at 03:36:14PM -0600, Alex Williamson wrote:
>=20
> > > +static int vfio_cdx_init_device(struct vfio_device *core_vdev)
> > > +{
> > > +   struct vfio_cdx_device *vdev =3D
> > > +           container_of(core_vdev, struct vfio_cdx_device, vdev);
> > > +   struct cdx_device *cdx_dev =3D to_cdx_device(core_vdev->dev);
> > > +
> > > +   vdev->cdx_dev =3D cdx_dev;
> > > +   vdev->dev =3D &cdx_dev->dev;
> >
> > Both of these seem trivial to factor out of this patch, cdx_device is
> > always available via to_cdx_device(core_vdev->dev) and the struct
> > device is always available via core_vdev->dev.  vdev->dev isn't even
> > used anywhere yet.  Both the init and release functions here could be
> > dropped afaict.
>=20
> Yes please, I have a series someplace that gets rid of all these
> redundent ->devs we keep around everwhere.
>=20
> to_cdx_device(core_vdev->dev) is a good solution, maybe with a static
> inline.

Agree, we have already rolled out v3 which has this change i.e using
to_cdx_dev(core_vdev->dev) instead of storing these again.

Thanks,
Nipun

>=20
> Jason
