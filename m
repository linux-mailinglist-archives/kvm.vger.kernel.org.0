Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0DC54EFAD
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 05:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiFQCxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 22:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379856AbiFQCxT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 22:53:19 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E8D28713;
        Thu, 16 Jun 2022 19:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655434398; x=1686970398;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2Le/cUDeQ3fVHTzWwi8s6g5GhAwassRMhG4UvW4l4M0=;
  b=mXpCUv9bfyDWmXotJCEc+MyzQ4yGNxZGEHxqaOViU9cwv5F3AATh0i+I
   sDeZISeq+l32iShfEQV1Sy5rqovnjlnnf5x3qwZxk4t1pNDQ/zIeXEb6T
   90JbtfGCUhSjjAT+z1qFX0oBfoFDqyiB6kWCbzs+/2wScGYv+BmsLyAr3
   SPSIJwDDye0TL7didZ8Yx7lIfVl2Z/cVybXcthkqjEaVbDORdAwS8VkpR
   gKXYHTyCozKv+a8EKx/fbKkk8rZWsOSoadRuhfyfv3zNLrd1MebIgWXsK
   1B+PNikOG05M3/+b7vR8eAc8ylmL1A8vh4eKKFHWBExhd1Rq8wCjFYcj4
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="268092061"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="268092061"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 19:53:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="560183594"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 16 Jun 2022 19:53:17 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 16 Jun 2022 19:53:16 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 16 Jun 2022 19:53:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 16 Jun 2022 19:53:16 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 16 Jun 2022 19:53:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pl10RGwB5t1tCmCbyNXyrll3IcJLIjw9m8P5c+1dzFyBAvIprsMnKCUhxoKsPTzzLkW5vVDb6p17ZzRWUN1G8FGnWrHTzsv/hFEkPcaJkX31TLs4r6JUVKLSTXmxeAvA7N1Q2MWygmsi+IYK6LYR4Dj5kZ1JUXynkZjX6JpzUgbOGGJzkrRcWeEcxkrdESTd7fnkgpzp8y4GKv74wYJD1B9bvIVttK+K8mmjU9Lcml+m9sU75G1O1PtUcxiOr2osBNQ6ccbHAa54IhRaJCkIEFGqsPz9PADOwcsZh2iBdwLorG/+DmVH2i47AakzvxY2q9Wam2QSUt61gpgPnWgLFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yPnaR3oeG9KD4dYZ61Yls2r2JyUJaYA7pG76XgATqjA=;
 b=ZzTM5dbX3UNFH/jHR380Mt73/3yIhceIQBWIy2LOOqwjr9LTGHlwXqnnJtub0RePW+X/XM+egzeC5zYqts6ek6q0RqJcrzFsxVyHXcFOxGoOPiDciZkuQpp4iuDigkzhIMQRbHEDtUqO20uoVaK6sSwALdoVR7hOIrJ0v0fDvT+pws6gsr3zcteS+UZfKCbWo0HqSyuo8wN4v07WEQ9K0wS8+i31cORb3YcS6WBiWErn400h3iwzW3/0gVCIPmy/cL8fEZu3tV9qFbk8l3nmEL34eMnoeXK9Xn/zQHrHEMucb5HFL714OLWRJCpkz3xwcMCTZqmEheuxAh3i1Npr4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL3PR11MB6364.namprd11.prod.outlook.com (2603:10b6:208:3b7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.17; Fri, 17 Jun
 2022 02:53:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 02:53:13 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "jordan@cosmicpenguin.net" <jordan@cosmicpenguin.net>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "saiprakash.ranjan@codeaurora.org" <saiprakash.ranjan@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "isaacm@codeaurora.org" <isaacm@codeaurora.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: RE: [PATCH v2 5/5] vfio/iommu_type1: Simplify group attachment
Thread-Topic: [PATCH v2 5/5] vfio/iommu_type1: Simplify group attachment
Thread-Index: AQHYgRSKHdu8hpsyN0qjOVzlAFzvDq1RlxsAgAEK+wCAAERFoA==
Date:   Fri, 17 Jun 2022 02:53:13 +0000
Message-ID: <BN9PR11MB5276C7BFA77C2C176491B56A8CAF9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
 <20220616000304.23890-6-nicolinc@nvidia.com>
 <BL1PR11MB52710E360B50DDA99C9A65D18CAC9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <YquxcH2S1fM+llOf@Asurada-Nvidia>
In-Reply-To: <YquxcH2S1fM+llOf@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5147c22a-1f2e-4e1e-86eb-08da500c8596
x-ms-traffictypediagnostic: BL3PR11MB6364:EE_
x-microsoft-antispam-prvs: <BL3PR11MB6364D7D831E4B3EC36093BC68CAF9@BL3PR11MB6364.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V9STjNJLVCbisCsbaj1azUPXnO0ZIcwsFI7Gthg6kPd7aP0t2dSRxQ2Qxjhhy96BRHvZoT2/d9UyF5YdvCqFcHnEkTWYXBo+eD0uiHC1hJKVGmAmL6GwRei1SNl/bDV23QAFQ26Xc1HubgXb7O2V/pIvKTRbZUpiSZNn7GwSVubrJzZa3Om2jImvTkAAm22INVjvsRWT7Z2K2URhpqSUe6bUOt1mqPTpjndJcIz3LD+ejKYcBGL3292OQMNaRJNfGKWa6vJuPaCdtTs7v5LKmoG8InNKJZUgpwNrm1utv4EPQIzS/AxlEN2TQPaPrjvIuNSjaDskuHTOzP9nocR7PMFuqDNsxCV+Kgdd3WViKFftxAhXWbKZ0tNe+t+CBsAMAXEbVmUXz8k1l3bXq30EH5NPmZy6BU4Cd/sgj+huCPunxkU9gOrLXOswv6I4o+zoM0RlzK6ouE13rFWy/aNgYDOkgSx6dT8LBYvC+nlrkch1f/jvx8cYFRnCh4ueT6QOmeEjwZ/qMc/y79n6MGsrVSrowA74yLhTH2SwgeiH8eqrLWXz2shmV4E0z+KOGQr3Dh5w2cpUTaRJeH13DuPO3hsxsKpMOnPAIuIQOiQZKMXSQXbbk2l08ME65DilEDUHhF1BMGxYsxF1ib/5gTL2biWpXgDMOQovHpob3HJ/GTwdgDRyJHw/MmpwGHgsZIHNDN4JEslnqlgg5SXLYR2Iaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(7406005)(66476007)(83380400001)(7696005)(66946007)(66556008)(2906002)(66446008)(64756008)(5660300002)(76116006)(33656002)(52536014)(6506007)(4326008)(86362001)(8676002)(508600001)(8936002)(82960400001)(71200400001)(38100700002)(122000001)(6916009)(55016003)(9686003)(54906003)(316002)(186003)(26005)(7416002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lyTN/2amkbHeY/hzFVNHHa0JM68w7YyJZNnFnS4vR0vKqvybaTFEdm5OIC43?=
 =?us-ascii?Q?axmtD9/j+HlbM8OFFS7t+qaz0bnTcO+jDzpnu3rZvzMmHgT2RBTxScoB96pR?=
 =?us-ascii?Q?4CJHkN6dtBFcX2sg6OfTR/6zwWidQ31M3JG5sOnBWGjVTn+u/rF4OYZVVAtM?=
 =?us-ascii?Q?L5a8V82zyJQbTv75i2ejDfzTwZA+2H/r11StA9441Kf6TW2dpz/KKwZsnnMq?=
 =?us-ascii?Q?So2bp9mgVCpt3lAtqC+FuqbS9ULSg9212+2bxQb53hlCETOc2oQwCMVD9Br3?=
 =?us-ascii?Q?nikmSCCHgdmgSOBlIju4OJyDEteYU1p4bBdgpdKWdElHdRioD/eMJGB0EpSO?=
 =?us-ascii?Q?qF+q/TFoIdkQwjeJT3JZ21hQest/H9nuo+Rstx8TsOYJtM+bIkOQClb40kQs?=
 =?us-ascii?Q?ejPAYXc1E8F/8LV08JJ4Jl0bkbzO651S4prnPCZvTd2Lmw7WC1lVhIPk0OX1?=
 =?us-ascii?Q?YsI+w4cs9fykfYPY5uAmtmOJ4Cq1idSCtG29xPPdMdkVdPHfIx+XdJGGvyIr?=
 =?us-ascii?Q?fw3VltI29BQFBW0Cimohic+7XcbK3IVvo+0o3+RkZewyBPL5dgvxDrJk0N4B?=
 =?us-ascii?Q?KBzr17EbnjVVXUXahlgoNbhiZoyAua3G4Pl2uCD2RdPqt8UBRB3N49WQq3Gp?=
 =?us-ascii?Q?O6fjvQNdg4dHPsuBWhe4s+dpuKLTQr60rPtYFzJrDwkRKoIvzRO1+Tj+kS1f?=
 =?us-ascii?Q?NWoSTbt/Uz5azhWju8Bd6hltmmmT6RVYMvzEIsZhMqEJKwsm7U1q8y12LggH?=
 =?us-ascii?Q?zUrQWZA0eRUQ5Ik0witljrGWFeX+mfSFFQIDrCZ+VushsZOehP42Kd963nRA?=
 =?us-ascii?Q?qga9hnyEwXPFASO6yt+pfabVeW9xad91MX66q4p0wlThdYkB4Eifbob8nonc?=
 =?us-ascii?Q?JAjoKgy9rbOM4NDmE1qlWVBm4xDm3o8eJAOJX6CLf8FNYfCr7rxPcCGk8VMH?=
 =?us-ascii?Q?47WQAvMSdmypNXk83zJVwYzra2BKjOglSdWXl5shQ+MiQ6/NvA6gsihJ/02A?=
 =?us-ascii?Q?6o2mRevL6uBByM00Kh+FVFJsPwyexKeoYkwvh7m2ZpLEmmvEuqLjSHmLvINv?=
 =?us-ascii?Q?IHGA5BJEtt9z9oIEEty4npvobI82+AW/xB4ba6dsdikuoMK900ftxoGJ0KYP?=
 =?us-ascii?Q?MBkg8CJWCZp1oRgDGOoDR00XsXcdnRjGnbnnymyhMfrFrjGjno0+alim3xG/?=
 =?us-ascii?Q?F5SiTqNkzpfQTyifmRaRSuOx1lK99CgoAj6Ycx7tx/yxAFrX8nhWBA/am8o6?=
 =?us-ascii?Q?RRhih5NonYCMlJ3Au27hLroZVWhIxz7dzSwktf+ddj2RywTZO7JePEFuoR2K?=
 =?us-ascii?Q?dycdiT2ttjZJ6BWGPcOp3SYBSzD7VaET/wBKK3/ntuz951GCG6ZQCEFdgBWI?=
 =?us-ascii?Q?k1j27NinOj4WlBCeWl2D9FfBIqcg2Mo776eWh3nuIlRthgthSV50oDoRzOph?=
 =?us-ascii?Q?gHhUO/yXPTdvbu9x6RV7A3Uws1hOKrRdj6oJVKzhAlMApNT90JeXsEPdhl8n?=
 =?us-ascii?Q?YF0Z73PxOV3nJUmwgFBGlpXvSnjkfnuwLx0nOaFxz8ybtBBkDqWNS++8Svxo?=
 =?us-ascii?Q?qohhRYFBN87kmLIsNlhtM6M1vAXCBxVZa5XQP8QuuRMc53JviB+l3ujsv4tV?=
 =?us-ascii?Q?5XnU73nukDhpDUzFXNFCStiYl4XJB+Q+OTl0DJkFD0w31ZVk7lqRsr8KDjFt?=
 =?us-ascii?Q?wtMQIdJr1JnECuW7SMfPAsW07i2GCsg/hQmnwUvstMTM4HdaowTL66R/g2z4?=
 =?us-ascii?Q?EUnm3uaz4w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5147c22a-1f2e-4e1e-86eb-08da500c8596
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2022 02:53:13.7254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7yUlOT25uayJzx73Rv7IGqb0mK4ZbUqUwe7NsHX4YpxMBVGEhxkIZOlbdE5zx9cWX4zQUHQ3SNFZFp6lMrfRmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6364
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Friday, June 17, 2022 6:41 AM
>=20
> > ...
> > > -     if (resv_msi) {
> > > +     if (resv_msi && !domain->msi_cookie) {
> > >               ret =3D iommu_get_msi_cookie(domain->domain,
> > > resv_msi_base);
> > >               if (ret && ret !=3D -ENODEV)
> > >                       goto out_detach;
> > > +             domain->msi_cookie =3D true;
> > >       }
> >
> > why not moving to alloc_attach_domain() then no need for the new
> > domain field? It's required only when a new domain is allocated.
>=20
> When reusing an existing domain that doesn't have an msi_cookie,
> we can do iommu_get_msi_cookie() if resv_msi is found. So it is
> not limited to a new domain.

Looks msi_cookie requirement is per platform (currently only
for smmu. see arm_smmu_get_resv_regions()). If there is
no mixed case then above check is not required.

But let's hear whether Robin has a different thought here.

>=20
> > ...
> > > -             if (list_empty(&domain->group_list)) {
> > > -                     if (list_is_singular(&iommu->domain_list)) {
> > > -                             if (list_empty(&iommu-
> > > >emulated_iommu_groups)) {
> > > -                                     WARN_ON(iommu->notifier.head);
> > > -
> > >       vfio_iommu_unmap_unpin_all(iommu);
> > > -                             } else {
> > > -
> > >       vfio_iommu_unmap_unpin_reaccount(iommu);
> > > -                             }
> > > -                     }
> > > -                     iommu_domain_free(domain->domain);
> > > -                     list_del(&domain->next);
> > > -                     kfree(domain);
> > > -                     vfio_iommu_aper_expand(iommu, &iova_copy);
> >
> > Previously the aperture is adjusted when a domain is freed...
> >
> > > -                     vfio_update_pgsize_bitmap(iommu);
> > > -             }
> > > -             /*
> > > -              * Removal of a group without dirty tracking may allow
> > > -              * the iommu scope to be promoted.
> > > -              */
> > > -             if (!group->pinned_page_dirty_scope) {
> > > -                     iommu->num_non_pinned_groups--;
> > > -                     if (iommu->dirty_page_tracking)
> > > -                             vfio_iommu_populate_bitmap_full(iommu);
> > > -             }
> > > +             vfio_iommu_detach_destroy_domain(domain, iommu,
> > > group);
> > >               kfree(group);
> > >               break;
> > >       }
> > >
> > > +     vfio_iommu_aper_expand(iommu, &iova_copy);
> >
> > but now it's done for every group detach. The aperture is decided
> > by domain geometry which is not affected by attached groups.
>=20
> Yea, I've noticed this part. Actually Jason did this change for
> simplicity, and I think it'd be safe to do so?

Perhaps detach_destroy() can return a Boolean to indicate whether
a domain is destroyed.
