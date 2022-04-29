Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268C4514508
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 11:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356260AbiD2JHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 05:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356153AbiD2JHG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 05:07:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D865C44F3
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 02:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651223028; x=1682759028;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Wg1kOQ2rxSCXOuUIEuMO7D6QWWwJRcokkpQstAyezjM=;
  b=b6M0k0j0GxJcVy/XbUN+bw6+oR2qq8smBHZQT5LyuCMrKq5e9Iq5mOSh
   Y49eFVe2fdLwFHdgDx0NEJdXbVACMPsNJPz9+s51Hg6z6CdAoyRNPDMLV
   ZEj/d+ZCechnaK1BxG3YxOXSdFZyjGgoV4voniqAjaSE3v6qwsOKi9f88
   I9TojNC4138sZwRYC7cmu4AvlbDPsTeFTMkS7UT0VllDBUMshEV/f7zGu
   2KOl1FjeT3LuOVCFWs4TlGA/E8K7U2yhZHp1POFFIaZkn8Acy7+ZiSj3N
   1gSizw7AHOE4llXyZGZTQ4XkR0giDOyCge9AdGkJPeEUSU9pmDemgvk1q
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="291753065"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="291753065"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 02:03:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="514730240"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 29 Apr 2022 02:03:47 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 29 Apr 2022 02:03:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 29 Apr 2022 02:03:47 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 29 Apr 2022 02:03:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iutplyXaTRYrfxQhB52U82FYWMDJzYdMXFioJgpunQ1/GXk4L9NVcVsKsfaHzebZjp3hcPMKs77EMfCXT+0IvCm7C9bhQ/vYoBS5tMSB4KxtvzaDiFtOtxJVF8VjfhzngbuCBFQ3r+D80pL0/93ozI/yFw4hw4XkDOGNPuu5dn8DekYPfbKBRDKgIyRihONRGJhtwfq3EEBv5YVaLKnLtewrQaUcDdOZ+zwnhWo2FqsT5xgLEGOFrJKphcjI9HUIr540d+efhfMUeOFSXJKOPwzQIao3UxgOEsqr4nyqwlQXqmz1CR2eNIzeqgeHrlcZfJj65hvS17/9Qhw0HW7LXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Id52CqBu8Sp6tgtL1zFTfZtBS6DDzaTsTFqTeEsLiRs=;
 b=ZrRDNekHXgt+3SdCyU/21J+Ntu1M0CAzXLh/AD/SjYRfWw15S47zDvF+I+bGKA6UypRsPWS///AGm8OWmCOjHphqstTE1xC52qnfLkPCRZzYQ1DjKeAN4wLcDdu2RR2gzgTVA5r+brWYUn2xtKJnNvSxjaUtngivRQQ6v519SXlrWTdaknVJ++XfJT+SW5YsnIEiKGtts7YtXSOELY78iShaOYkKe36KeQ3nRqfPR3im/y/YV9WulK27TO27SSwb5HjSXoFKrkeiergl+M1fm2biMNKfC6ixlrfhlJP+NMdxAHIgJB6eVQRNc32me9BSfrRQmfTYQ3/gzwHa0T9JSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL0PR11MB3089.namprd11.prod.outlook.com (2603:10b6:208:79::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12; Fri, 29 Apr
 2022 09:03:43 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 09:03:43 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Martins, Joao" <joao.m.martins@oracle.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
CC:     "Martins, Joao" <joao.m.martins@oracle.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Cornelia Huck" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC 18/19] iommu/intel: Access/Dirty bit support for SL
 domains
Thread-Topic: [PATCH RFC 18/19] iommu/intel: Access/Dirty bit support for SL
 domains
Thread-Index: AQHYW0SjIbmx8hnipU+EU3D2Wp9FUa0GkGZQ
Date:   Fri, 29 Apr 2022 09:03:43 +0000
Message-ID: <BN9PR11MB52765037DF7BDE1EA9A6558A8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-19-joao.m.martins@oracle.com>
In-Reply-To: <20220428210933.3583-19-joao.m.martins@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4116c5a-c4db-4ae8-bf2e-08da29bf297b
x-ms-traffictypediagnostic: BL0PR11MB3089:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BL0PR11MB3089E21E3884D814C5F052078CFC9@BL0PR11MB3089.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HQPHUPlJcEExiMBX/d2dEldb09hDPuQNUkFFi95RnE7uG6atwjY1DIjStioDli5ZrCyd8y4SePNgSwlo7n/IDgmmiKfEmP9V4Q1RJITWBPpEM/zho13RU7YttrThhYOMlQnakfq3yKvbrFsRgyt//RwpKag0++6zJ2O+k0ZGoKFYLu7bbpCrqw3q48Rn1gdL2HGz0zl3nJS4BwgtlVuHZMdtwwyVtRHJjgBaMQFkRucx8/imTFZneIMk0Uc5aAaFKiBGwkW0nHrR2/0wOZpPf4yb97bAMd9WiIaBjRqavdjgeSUanQ+nWnied2KaT0Z5BCR+qsLT9dynOGYKmCq7SONJ672tYa04lP6qKZQ0HQIr4A6SDJgU27vKcVyuFYdcKrYyuUVng6FtJu2BiTKErhp0i43wdpdmMSibV5v3+u8oOPOhqz4W48JxAQgr3J2uJ+Z+O32X3sM9ByC6ZVaSn6zDTs3wClosKYhbaTsPwi6AJAezhBJQviTXI2QryDK8j3uG3KXiUXKkcxfFxexGNGmttc9+E7Iy+r4nusI6G5GliCwauTYqErsGAlbhPr/ESdJyaUyKvzbkSyvz2T3zqD2ZTTGBrIGmoxAm9JKuDOxqFc31BP7bMpK0uyisa8Tb66fp7Qdx9t61ytd7zeTGx6QizOmI1CJZ7jgYPuxXIsBnmYMnFqVqFuaYRjmDLfcQSmVD51tfRXuIPOam79D5gJqRNAtaNGhzLMwFJrWvavs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(83380400001)(7416002)(186003)(66946007)(52536014)(64756008)(66556008)(86362001)(76116006)(30864003)(5660300002)(66446008)(66476007)(2906002)(55016003)(8676002)(4326008)(7696005)(6506007)(9686003)(122000001)(26005)(508600001)(33656002)(38070700005)(82960400001)(54906003)(71200400001)(110136005)(38100700002)(316002)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2nisD54NNYTuZHawQxowZjQS7QRJG4u3DR//SMw5A676ki5Pfny5wguBZDlJ?=
 =?us-ascii?Q?FSVQQ4Yc4TjaVUYScBYQ+dM64tOtjIWPxtJ4/17Km4dZNbQD1q3ZXNMY/KlW?=
 =?us-ascii?Q?sAVBc1Fn+K3xPmmMvYG4SP/g6HbHvCUDXFYzxcfQr02p5iNg6VzYjEmUCAZb?=
 =?us-ascii?Q?n5w5kiCJob3gMe2Scu6Vzim6vEgM6TOzdpa08ZetSEjDhgzwao/5WZRs9t4j?=
 =?us-ascii?Q?g1zoBAA3iqw3X+k095teXsynL6N7XwurAeY+I5/ofxrpEmEf9XzY7NVKIOOd?=
 =?us-ascii?Q?Jsubjr0dJAgHxNHTUcJSeVMsX5i2SLXbsHAX9F+TsxhzcI1tcSqwvf53IVlT?=
 =?us-ascii?Q?eg6DyOXJQz/tcvmALJRXzLJg8bxccoPcPmlHUXfY9zpK/z5jDWBdV0UvZxzS?=
 =?us-ascii?Q?GLOa4K4cTUV9B2kuEhOl2l15yLhE+FlmqRmackpzgK4JCOtcahDZ9WbEATsk?=
 =?us-ascii?Q?8xD+Qo5IB62B96XP2DbZ2oH9xTNORJ4GHT4Z7oWk0Y5WzAPPqqbrIiPiTcxp?=
 =?us-ascii?Q?eaVJojgTV8YpaCTHfHEcox/F26Z65NhUNWGVS09OnsyLkHMyGQ77uRldvW2g?=
 =?us-ascii?Q?q7q32C6gyGJNjY22LzZqR/RZQxDs5Zrvh1PyGB4Xw4NbbofA0dTqmyj7SzNG?=
 =?us-ascii?Q?LCISSY96JF8ePDSYPRMdEGicZ1rBBHsZBrSRuyArCdGLAL1rQqb5DFCbRxdO?=
 =?us-ascii?Q?qnQ/LJAZ41axtYfUAoFsGS4ZCVzwmpIZ4Wu8Q/uPbMeE1nc1tGSoLYneeZ38?=
 =?us-ascii?Q?1txGaK/XZA6j0eGFRlCR+OiJ2Sxxl1Gue97QQ9eLjQXllMp4WZ6zTZUI7nsz?=
 =?us-ascii?Q?07vECegClXJbkDAgn4t7XPDktqnuaU9y5at4IiJ+/5R+fr8tEX75H14tQ/ZX?=
 =?us-ascii?Q?3ZvnIaq1hIoWTIssTRqmXCO+uPEugZioi0J4k4Q3t6UEmz6AvffyDWER0E4R?=
 =?us-ascii?Q?Dx6XlzLaOi5hysLn7rswYa8eDmxO9Z2HW2BuKQZNrHfXNDGAbAKNQL2NNDHX?=
 =?us-ascii?Q?FxVnkeVnEHGtbaeC0g+aJB64VB1AIQ764mMaXm2akTvLTeJbPvg/tFQJthMR?=
 =?us-ascii?Q?Y4BrioVoXvoiVEujLKqmb/S/a9sgY70qw4J3WKBm3n0QCHbSK5+bmaS0LOeH?=
 =?us-ascii?Q?Rh9klrAmNvpGkoZzOXN3uD4qelOuXyo+9w9jLTBQVkq4RDsn5gficOTC2hsr?=
 =?us-ascii?Q?J7LhavhgBT/I0mtmwnkN4jRizahq8KUA8TDa3I2GHFR6WOcpVB10m7SwfneG?=
 =?us-ascii?Q?8y12rpSi3OxIT92soXlXpnLlUy17JLgKbTo/vat9RFmot8FQs5HGZbb/RWrU?=
 =?us-ascii?Q?RmxPnsjakiqwmuMX2tInvSK1sqV0ursdi5kzR+AuhGVzaxCh+VoXBfmMgKAb?=
 =?us-ascii?Q?7A6bEGU+hRRwy0rabyBZpbc5ZOS7DyP4xj3cgMhEZukz4cdc5ocezgd2VxwB?=
 =?us-ascii?Q?lmu3M3E1/6vwApMiCoS9pQVQFYCYZimq8DC2MtEHuXi+PmpEdoTHg3FozSHu?=
 =?us-ascii?Q?dfdh4Mgp000dAWNrvlgwKXyFTaqBjNYdG5KcFy+NSn3dMHQfxnuPITIbNS8h?=
 =?us-ascii?Q?25nHX5Y40vbWVwDU0nu7jxjYf3GM+uzQa1VzZhMP0fFHIZ8W75lT51OfujEi?=
 =?us-ascii?Q?OLfTsg3khEy2Ks6X1rxpqbpq6z+O2JLj9PfiKijLyalpd5lEYzTN9tOEY8Sg?=
 =?us-ascii?Q?pL28BmI0zQOV4K9YWKQfvotgovnIj7YiIfLe1rPwciJIkix6avgdIYnm7XAZ?=
 =?us-ascii?Q?cAtoZLbH0A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4116c5a-c4db-4ae8-bf2e-08da29bf297b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 09:03:43.7189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eh0fSZ6gOJDWKR1whUbr3ln+ks2cwcKKcpK10c8Wb6j7giiBFB/XBpnEkAZ1hqjIQGKC8TZf1rZylej7xLqKYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3089
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Joao Martins <joao.m.martins@oracle.com>
> Sent: Friday, April 29, 2022 5:10 AM
>=20
> IOMMU advertises Access/Dirty bits if the extended capability
> DMAR register reports it (ECAP, mnemonic ECAP.SSADS). The first
> stage table, though, has not bit for advertising, unless referenced via

first-stage is compatible to CPU page table thus a/d bit support is
implied. But for dirty tracking I'm I'm fine with only supporting it
with second-stage as first-stage will be used only for guest in the
nesting case (though in concept first-stage could also be used for
IOVA when nesting is disabled there is no plan to do so on Intel
platforms).

> a scalable-mode PASID Entry. Relevant Intel IOMMU SDM ref for first stage
> table "3.6.2 Accessed, Extended Accessed, and Dirty Flags" and second
> stage table "3.7.2 Accessed and Dirty Flags".
>=20
> To enable it scalable-mode for the second-stage table is required,
> solimit the use of dirty-bit to scalable-mode and discarding the
> first stage configured DMAR domains. To use SSADS, we set a bit in

above is inaccurate. dirty bit is only supported in scalable mode so
there is no limit per se.

> the scalable-mode PASID Table entry, by setting bit 9 (SSADE). When

"To use SSADS, we set bit 9 (SSADE) in the scalable-mode PASID table
entry"

> doing so, flush all iommu caches. Relevant SDM refs:
>=20
> "3.7.2 Accessed and Dirty Flags"
> "6.5.3.3 Guidance to Software for Invalidations,
>  Table 23. Guidance to Software for Invalidations"
>=20
> Dirty bit on the PTE is located in the same location (bit 9). The IOTLB

I'm not sure what information 'same location' here tries to convey...

> caches some attributes when SSADE is enabled and dirty-ness information,

be direct that the dirty bit is cached in IOTLB thus any change of that
bit requires flushing IOTLB

> so we also need to flush IOTLB to make sure IOMMU attempts to set the
> dirty bit again. Relevant manuals over the hardware translation is
> chapter 6 with some special mention to:
>=20
> "6.2.3.1 Scalable-Mode PASID-Table Entry Programming Considerations"
> "6.2.4 IOTLB"
>=20
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
> Shouldn't probably be as aggresive as to flush all; needs
> checking with hardware (and invalidations guidance) as to understand
> what exactly needs flush.

yes, definitely not required to flush all. You can follow table 23
for software guidance for invalidations.

> ---
>  drivers/iommu/intel/iommu.c | 109
> ++++++++++++++++++++++++++++++++++++
>  drivers/iommu/intel/pasid.c |  76 +++++++++++++++++++++++++
>  drivers/iommu/intel/pasid.h |   7 +++
>  include/linux/intel-iommu.h |  14 +++++
>  4 files changed, 206 insertions(+)
>=20
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index ce33f85c72ab..92af43f27241 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -5089,6 +5089,113 @@ static void intel_iommu_iotlb_sync_map(struct
> iommu_domain *domain,
>  	}
>  }
>=20
> +static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
> +					  bool enable)
> +{
> +	struct dmar_domain *dmar_domain =3D to_dmar_domain(domain);
> +	struct device_domain_info *info;
> +	unsigned long flags;
> +	int ret =3D -EINVAL;
> +
> +	spin_lock_irqsave(&device_domain_lock, flags);
> +	if (list_empty(&dmar_domain->devices)) {
> +		spin_unlock_irqrestore(&device_domain_lock, flags);
> +		return ret;
> +	}

or return success here and just don't set any dirty bitmap in
read_and_clear_dirty()?

btw I think every iommu driver needs to record the tracking status
so later if a device which doesn't claim dirty tracking support is
attached to a domain which already has dirty_tracking enabled
then the attach request should be rejected. once the capability
uAPI is introduced.

> +
> +	list_for_each_entry(info, &dmar_domain->devices, link) {
> +		if (!info->dev || (info->domain !=3D dmar_domain))
> +			continue;

why would there be a device linked under a dmar_domain but its
internal domain pointer doesn't point to that dmar_domain?

> +
> +		/* Dirty tracking is second-stage level SM only */
> +		if ((info->domain && domain_use_first_level(info->domain))
> ||
> +		    !ecap_slads(info->iommu->ecap) ||
> +		    !sm_supported(info->iommu) || !intel_iommu_sm) {

sm_supported() already covers the check on intel_iommu_sm.

> +			ret =3D -EOPNOTSUPP;
> +			continue;
> +		}
> +
> +		ret =3D intel_pasid_setup_dirty_tracking(info->iommu, info-
> >domain,
> +						     info->dev,
> PASID_RID2PASID,
> +						     enable);
> +		if (ret)
> +			break;
> +	}
> +	spin_unlock_irqrestore(&device_domain_lock, flags);
> +
> +	/*
> +	 * We need to flush context TLB and IOTLB with any cached
> translations
> +	 * to force the incoming DMA requests for have its IOTLB entries
> tagged
> +	 * with A/D bits
> +	 */
> +	intel_flush_iotlb_all(domain);
> +	return ret;
> +}
> +
> +static int intel_iommu_get_dirty_tracking(struct iommu_domain *domain)
> +{
> +	struct dmar_domain *dmar_domain =3D to_dmar_domain(domain);
> +	struct device_domain_info *info;
> +	unsigned long flags;
> +	int ret =3D 0;
> +
> +	spin_lock_irqsave(&device_domain_lock, flags);
> +	list_for_each_entry(info, &dmar_domain->devices, link) {
> +		if (!info->dev || (info->domain !=3D dmar_domain))
> +			continue;
> +
> +		/* Dirty tracking is second-stage level SM only */
> +		if ((info->domain && domain_use_first_level(info->domain))
> ||
> +		    !ecap_slads(info->iommu->ecap) ||
> +		    !sm_supported(info->iommu) || !intel_iommu_sm) {
> +			ret =3D -EOPNOTSUPP;
> +			continue;
> +		}
> +
> +		if (!intel_pasid_dirty_tracking_enabled(info->iommu, info-
> >domain,
> +						 info->dev, PASID_RID2PASID))
> {
> +			ret =3D -EINVAL;
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(&device_domain_lock, flags);
> +
> +	return ret;
> +}

All above can be translated to a single status bit in dmar_domain.

> +
> +static int intel_iommu_read_and_clear_dirty(struct iommu_domain
> *domain,
> +					    unsigned long iova, size_t size,
> +					    struct iommu_dirty_bitmap *dirty)
> +{
> +	struct dmar_domain *dmar_domain =3D to_dmar_domain(domain);
> +	unsigned long end =3D iova + size - 1;
> +	unsigned long pgsize;
> +	int ret;
> +
> +	ret =3D intel_iommu_get_dirty_tracking(domain);
> +	if (ret)
> +		return ret;
> +
> +	do {
> +		struct dma_pte *pte;
> +		int lvl =3D 0;
> +
> +		pte =3D pfn_to_dma_pte(dmar_domain, iova >>
> VTD_PAGE_SHIFT, &lvl);

it's probably fine as the starting point but moving forward this could
be further optimized so there is no need to walk from L4->L3->L2->L1
for every pte.

> +		pgsize =3D level_size(lvl) << VTD_PAGE_SHIFT;
> +		if (!pte || !dma_pte_present(pte)) {
> +			iova +=3D pgsize;
> +			continue;
> +		}
> +
> +		/* It is writable, set the bitmap */
> +		if (dma_sl_pte_test_and_clear_dirty(pte))
> +			iommu_dirty_bitmap_record(dirty, iova, pgsize);
> +		iova +=3D pgsize;
> +	} while (iova < end);
> +
> +	return 0;
> +}
> +
>  const struct iommu_ops intel_iommu_ops =3D {
>  	.capable		=3D intel_iommu_capable,
>  	.domain_alloc		=3D intel_iommu_domain_alloc,
> @@ -5119,6 +5226,8 @@ const struct iommu_ops intel_iommu_ops =3D {
>  		.iotlb_sync		=3D intel_iommu_tlb_sync,
>  		.iova_to_phys		=3D intel_iommu_iova_to_phys,
>  		.free			=3D intel_iommu_domain_free,
> +		.set_dirty_tracking	=3D intel_iommu_set_dirty_tracking,
> +		.read_and_clear_dirty   =3D intel_iommu_read_and_clear_dirty,
>  	}
>  };
>=20
> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
> index 10fb82ea467d..90c7e018bc5c 100644
> --- a/drivers/iommu/intel/pasid.c
> +++ b/drivers/iommu/intel/pasid.c
> @@ -331,6 +331,11 @@ static inline void pasid_set_bits(u64 *ptr, u64 mask=
,
> u64 bits)
>  	WRITE_ONCE(*ptr, (old & ~mask) | bits);
>  }
>=20
> +static inline u64 pasid_get_bits(u64 *ptr)
> +{
> +	return READ_ONCE(*ptr);
> +}
> +
>  /*
>   * Setup the DID(Domain Identifier) field (Bit 64~79) of scalable mode
>   * PASID entry.
> @@ -389,6 +394,36 @@ static inline void pasid_set_fault_enable(struct
> pasid_entry *pe)
>  	pasid_set_bits(&pe->val[0], 1 << 1, 0);
>  }
>=20
> +/*
> + * Enable second level A/D bits by setting the SLADE (Second Level
> + * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
> + * entry.
> + */
> +static inline void pasid_set_ssade(struct pasid_entry *pe)
> +{
> +	pasid_set_bits(&pe->val[0], 1 << 9, 1 << 9);
> +}
> +
> +/*
> + * Enable second level A/D bits by setting the SLADE (Second Level
> + * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
> + * entry.
> + */
> +static inline void pasid_clear_ssade(struct pasid_entry *pe)
> +{
> +	pasid_set_bits(&pe->val[0], 1 << 9, 0);
> +}
> +
> +/*
> + * Checks if second level A/D bits by setting the SLADE (Second Level
> + * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
> + * entry is enabled.
> + */
> +static inline bool pasid_get_ssade(struct pasid_entry *pe)
> +{
> +	return pasid_get_bits(&pe->val[0]) & (1 << 9);
> +}
> +
>  /*
>   * Setup the SRE(Supervisor Request Enable) field (Bit 128) of a
>   * scalable mode PASID entry.
> @@ -725,6 +760,47 @@ int intel_pasid_setup_second_level(struct
> intel_iommu *iommu,
>  	return 0;
>  }
>=20
> +/*
> + * Set up dirty tracking on a second only translation type.
> + */
> +int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
> +				     struct dmar_domain *domain,
> +				     struct device *dev, u32 pasid,
> +				     bool enabled)
> +{
> +	struct pasid_entry *pte;
> +
> +	pte =3D intel_pasid_get_entry(dev, pasid);
> +	if (!pte) {
> +		dev_err(dev, "Failed to get pasid entry of PASID %d\n",
> pasid);
> +		return -ENODEV;
> +	}
> +
> +	if (enabled)
> +		pasid_set_ssade(pte);
> +	else
> +		pasid_clear_ssade(pte);
> +	return 0;
> +}
> +
> +/*
> + * Set up dirty tracking on a second only translation type.
> + */
> +bool intel_pasid_dirty_tracking_enabled(struct intel_iommu *iommu,
> +					struct dmar_domain *domain,
> +					struct device *dev, u32 pasid)
> +{
> +	struct pasid_entry *pte;
> +
> +	pte =3D intel_pasid_get_entry(dev, pasid);
> +	if (!pte) {
> +		dev_err(dev, "Failed to get pasid entry of PASID %d\n",
> pasid);
> +		return false;
> +	}
> +
> +	return pasid_get_ssade(pte);
> +}
> +
>  /*
>   * Set up the scalable mode pasid entry for passthrough translation type=
.
>   */
> diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
> index ab4408c824a5..3dab86017228 100644
> --- a/drivers/iommu/intel/pasid.h
> +++ b/drivers/iommu/intel/pasid.h
> @@ -115,6 +115,13 @@ int intel_pasid_setup_first_level(struct intel_iommu
> *iommu,
>  int intel_pasid_setup_second_level(struct intel_iommu *iommu,
>  				   struct dmar_domain *domain,
>  				   struct device *dev, u32 pasid);
> +int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
> +				     struct dmar_domain *domain,
> +				     struct device *dev, u32 pasid,
> +				     bool enabled);
> +bool intel_pasid_dirty_tracking_enabled(struct intel_iommu *iommu,
> +					struct dmar_domain *domain,
> +					struct device *dev, u32 pasid);
>  int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
>  				   struct dmar_domain *domain,
>  				   struct device *dev, u32 pasid);
> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> index 5cfda90b2cca..1328d1805197 100644
> --- a/include/linux/intel-iommu.h
> +++ b/include/linux/intel-iommu.h
> @@ -47,6 +47,9 @@
>  #define DMA_FL_PTE_DIRTY	BIT_ULL(6)
>  #define DMA_FL_PTE_XD		BIT_ULL(63)
>=20
> +#define DMA_SL_PTE_DIRTY_BIT	9
> +#define DMA_SL_PTE_DIRTY	BIT_ULL(DMA_SL_PTE_DIRTY_BIT)
> +
>  #define ADDR_WIDTH_5LEVEL	(57)
>  #define ADDR_WIDTH_4LEVEL	(48)
>=20
> @@ -677,6 +680,17 @@ static inline bool dma_pte_present(struct dma_pte
> *pte)
>  	return (pte->val & 3) !=3D 0;
>  }
>=20
> +static inline bool dma_sl_pte_dirty(struct dma_pte *pte)
> +{
> +	return (pte->val & DMA_SL_PTE_DIRTY) !=3D 0;
> +}
> +
> +static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte)
> +{
> +	return test_and_clear_bit(DMA_SL_PTE_DIRTY_BIT,
> +				  (unsigned long *)&pte->val);
> +}
> +
>  static inline bool dma_pte_superpage(struct dma_pte *pte)
>  {
>  	return (pte->val & DMA_PTE_LARGE_PAGE);
> --
> 2.17.2

