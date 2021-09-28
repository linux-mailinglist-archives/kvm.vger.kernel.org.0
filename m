Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388DB41BB84
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 02:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243338AbhI2ABy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 20:01:54 -0400
Received: from mga17.intel.com ([192.55.52.151]:54920 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243210AbhI2ABx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 20:01:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="204978795"
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="204978795"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 16:59:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="708110498"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 28 Sep 2021 16:59:53 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 28 Sep 2021 16:59:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 28 Sep 2021 16:59:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 28 Sep 2021 16:59:52 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 28 Sep 2021 16:59:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVdFxGIxw/lmqs83qxZY2diXDzRtTX1IRS1G5494vijXrY0UF8aIaZ/LWx5vkkZ1jflzfqZpCthq1fhZjF5eYEquUMBNras7Ca4dGGIcgjBBYJ3d/sZz66WpeRQQPQYwupR7U7y/DfJu1HnU6okjRi+dDLCtCicP+QWTqHJAcmJAZucYf659BrsbJRGoKngqBa2meButRqckXFMArLVbC/HunhTLU7hF6H6UqNBKWRX/kW7E0Lqg9GHlHXOiX9uFvCe2FHyhmH6GkUL7Y4wexooyhonlQIb5n2vca9gCzlfBQLB8/faBkMqbOLS2kMPKJnyxij7S3of4GI92BZQFxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=d7Ns5Pn7DTk+YY970UGsDai7b3vBcTuHemPZ/YwXpWg=;
 b=HNU2Jn7o2Xb8gmd3B2Ty4WMzRdYF32gYYc2emij01aQbpEEovhUJkspHtW+VOZa3raoCB0vmt6W2l2HRtiFRP+ZWq7bBl1i360AW+xgpSHTgNT6hxwvV4DZizg2y2IS7lznlOP4ZdMlhBvk2/pykfheYftwDjMfm8g8Z0yz/8rpth0NrsDRGINwaQxab0HK3buUG9JMgXoMazdg7GHnwjzP0v2rU+4ywlEqS7HnfR334KcTBhiPdwQ6oflEJ/lefQBoYyOZQEppi5dR+CH5hG5DOAz36TSTkDeCm8A87dkwlfMxj10BQo8WovVGbxTWM6Zyqiy6j6Z/ilPhGJ4PhuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7Ns5Pn7DTk+YY970UGsDai7b3vBcTuHemPZ/YwXpWg=;
 b=ebMMo6FdlCVtSmswhJ9IJcqGVCr82MrTqNw8W/rmD+scXeSFRbHO84GGk8IlcC38RUA95TGxGgX53QoOx45ib/TnXEaJQZX4w/G6K8IumfT0vp245MtKSHC5toitKrokkWLgwPq/klY172LjjpsDeEuxJT3N+PsY39DgeUioC/Q=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN0PR11MB5759.namprd11.prod.outlook.com (2603:10b6:408:168::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 23:59:50 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 23:59:50 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Topic: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Index: AQHXrSF9WDj+Z+DU+UqMJ7tQK2EdmauuvK2AgACKnbCAALw6gIAHYVYAgABthQCAABACQIAABTKAgAAAdqCAABi9gIABEGXAgABTw4CAAMklcA==
Date:   Tue, 28 Sep 2021 23:59:50 +0000
Message-ID: <BN9PR11MB5433E6CB4CC0F96DB6E00D978CA89@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210921170943.GS327412@nvidia.com>
 <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922123931.GI327412@nvidia.com>
 <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927115342.GW964074@nvidia.com>
 <BN9PR11MB5433502FEF11940984774F278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927130935.GZ964074@nvidia.com>
 <BN9PR11MB543327D25DCE242919F7909A8CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927143947.GA964074@nvidia.com>
 <BN9PR11MB5433CE9B63FD6E784F0196B68CA89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210928115431.GJ964074@nvidia.com>
In-Reply-To: <20210928115431.GJ964074@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa64c73c-1ed7-4bf0-898b-08d982dc0f36
x-ms-traffictypediagnostic: BN0PR11MB5759:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN0PR11MB57599B0E4F5EB5C28AFBB7128CA89@BN0PR11MB5759.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4VVjAV0gkwr08v5GSs5T2FWIgN6p7kGB4eaN/6GlVJPWFXID5mGVRXxuySQUtYV8N9H8zpe6yRFTD1rThVJR5QBieMSML5fA4YGJ6opzzzEIRzfMSQUi13+8T5m9NufwAJ0G/7f/NliOJTF/CfD3W3SIRreSuqXRak5bFdnXl3Yuvtj/b9vplcf9wECHPdP0qBMLAF4QMZDmuVlt6fsVZUuyiQsMhdws4/BV6fCq2Zah4hCkxkMKjTK5NNivs+JNckTlApVM95NGVvZ8irdrefwcK3WL1NW8pb8r24uHoVZ7rQ3QaDSR/oGG6GpSimgd2b1nRGd0SNc4qCT+23n10+xqhfQIM9I7s/lDNcZVSpkH9nYbfssDVuAqo9GPNhSivT0IO60pXdmBr/cvqtT7P/4Tu3WBmYsO8/tJpM2w0z+m/nKFHmvOH4gOe8zzRY726k25NFVWvFtmYFeTsGnvBwGoBWsoHSUjoXJ8eeol7dE6SVA2v8QusQItjppn+UTN7y3gZgAmPMeONj87uT2TPU9K1On0bq0lnITA+doAXM0RxEq2BvvygAbFPPWAI7AB1gWShF9sV0eLhHPCBi8crW50n6IZ7fDWf3WdYQL0ZygLzSOatHSp7D65xUI3GKdaVHwbQtJbRARxcpfSAvHy6705SIEGj56n0LOHlChW2q3C40+S6DIXZTyHtc8EBSC/DnroxI9/BI6fqZpa3g+0Lg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(186003)(76116006)(9686003)(5660300002)(64756008)(38070700005)(55016002)(66556008)(66476007)(8676002)(26005)(66946007)(6506007)(66446008)(8936002)(83380400001)(71200400001)(2906002)(33656002)(316002)(6916009)(38100700002)(7416002)(122000001)(7696005)(54906003)(86362001)(508600001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PrvOHeEuDeZ84N99KO86AcHY6ZZb3k0yxC57zQna6pIcrMot5yoDc/Jotm/8?=
 =?us-ascii?Q?jlQvqK3q/JQIDILhXc7BxDy4mB0bLVgC36AaOV+HcIjyTSqIT3sdfqOVR5xW?=
 =?us-ascii?Q?tiwcukBpYmNxJdmTKfaYfEepqC6OUIO7HF+piipS0pBeyHad1YRCG1BmtvNJ?=
 =?us-ascii?Q?OFTap+Dl1lDNVZ/D3EoF9FhsvqsI4OBjindrGS6xCqcwQtx1VNjlZtAA44tU?=
 =?us-ascii?Q?4YZM9ckXVVrVsuBre6QY7RMj1B3RTxOEAJXtHDY9Ju82+ua95HVmHahyDH+y?=
 =?us-ascii?Q?6Y/hu/l3udCVh57OQlGD65k8Wsrbwd3eoJfTxFXncfG2c22zwezVPIejjWn3?=
 =?us-ascii?Q?LbhJZsAy1XgvwxUaYJ3M+aZmEfZWzos19Cr9Y83xM1r47tFd0kaYNi7ke5lW?=
 =?us-ascii?Q?vIjQaNsGBwHz972MSSqes7Z3wmlfOeQ7lhKYqjMzjrA6XlZ1t2JC96gsekQa?=
 =?us-ascii?Q?3LhGGIsBDDBG5jauH5sqef6Qb4axIu1dmdPSNb7y1GeCfypL42w/pAo9/Tiy?=
 =?us-ascii?Q?SoQvoEZjmHuWJxEppnf9sGfeSo32tJnioRUmS0sjziICCqNrb0u5EC44U93F?=
 =?us-ascii?Q?lAiPAQDgxeQADZCltcZOv8ff0St3s4XI5tL3wXvhzSeEO2v7WMU5LkFS3ba6?=
 =?us-ascii?Q?ox1uVyCpn4y0Ie+zpj1w+Lwe/9HYDTMYsQTYEirgHXrIrPNGGi9HOn0omKZp?=
 =?us-ascii?Q?XUTWsrwC4Mq5d0dTh6jHVuTVwtCIv/cPMjAOyy6vB6lCNlECKvlEXv/I1xDl?=
 =?us-ascii?Q?J1tjacHPFrccFRZmJew1KhHY01AhZSO6hpZZ2PsgnDlrJoWZkvx1BXsGTEzZ?=
 =?us-ascii?Q?awAdZizA5OQQqSUfXWYn21WuL+c2gp5ditfsxqzletY5L8I37k4lvgY8jbs+?=
 =?us-ascii?Q?FQ4RfJ0Um+XUoV8EmLjH5PrH3VKichXM29cFKPOTzagVh5A/wC6yOyZK8eYT?=
 =?us-ascii?Q?tZ/avO8LHu+MDThuMiLtI+F3wpqsCXnhdbR9Epy/vpGZ758qVFSrZ7eJLLOQ?=
 =?us-ascii?Q?1t1u7qugp6Id8LHp1vD+aYKMig9dTwSKtb1QcXmlVO5x87Lt882dyFZyDShm?=
 =?us-ascii?Q?PEcxBzzp0BKydYnGEEnjIhH/sywmiS/nx8A7r85xspkfoQLeAIr3o207YCUu?=
 =?us-ascii?Q?wyOr0qBg/ZF3U5jyYCKlNeGtPfaKCfXnWfhnEXKfzV5l/3qsC8ch9vjrsGEZ?=
 =?us-ascii?Q?5vkfzwfqQXqjRFnQc6CfU3eP+mchTr89ufQ21bG6xcDz0aiwf6tOnx9LSbr8?=
 =?us-ascii?Q?IGCF4xRsakO28WgcLbTnWDIqwqxMWmcOkQh35sarCZc8zAGnKsByntDN9ZFK?=
 =?us-ascii?Q?Wy0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa64c73c-1ed7-4bf0-898b-08d982dc0f36
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 23:59:50.8338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bUrDry/12cPSSWUnqd8iCOAfhlJLqvyhOcb3ILhPKfLNYedbhhuZpiovBNlIeHUJdmTcB592xNXiSPK4nsOz3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5759
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, September 28, 2021 7:55 PM
>=20
> On Tue, Sep 28, 2021 at 07:13:01AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Monday, September 27, 2021 10:40 PM
> > >
> > > On Mon, Sep 27, 2021 at 01:32:34PM +0000, Tian, Kevin wrote:
> > >
> > > > but I'm little worried that even vfio-pci itself cannot be bound no=
w,
> > > > which implies that all devices in a group which are intended to be
> > > > used by the user must be bound to vfio-pci in a breath before the
> > > > user attempts to open any of them, i.e. late-binding and device-
> > > > hotplug is disallowed after the initial open. I'm not sure how
> > > > important such an usage would be, but it does cause user-tangible
> > > > semantics change.
> > >
> > > Oh, that's bad..
> > >
> > > I guess your approach is the only way forward, it will have to be
> > > extensively justified in the commit message for Greg et al.
> > >
> >
> > Just thought about another alternative. What about having driver
> > core to call iommu after call_driver_probe()?
>=20
> Then the kernel is now already exposed to an insecure scenario, we
> must not do probe if any user device is attached at all.
>=20

Originally I thought it's fine as long as the entire probe process
is not completed. Based on your comment I feel your concern is
that no guarantee that the driver won't do any iommu related=20
work in its probe function thus it's insecure?

Thanks
Kevin
