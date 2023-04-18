Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0516E5848
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 07:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjDRFCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 01:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjDRFCv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 01:02:51 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20F43ABB;
        Mon, 17 Apr 2023 22:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681794169; x=1713330169;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bpch/0fRSstvM8XbMHNZtNb9LEG5diVBcZX2ES0qdu4=;
  b=hp/SU231pKCPlCsusDr3Vl9yhziZxgKRDfc1Sfzfu8ZnmDk5FGKeY/br
   jiIcSex0NhidxgYh6IvuJOaSaywTb1AfK61kYHeBjivjmrx5Upae+Wtwx
   7Ay7/b/DPtPDmbq+SGFPqOJKuEhz10Scw6iBejjmO2n9mZaZQgZG9Ckf/
   QEEB3+ESSF/SiFYEOMRAvnxvkySo9JbXfio4J3TX26igBERp44d0ItIcj
   gp0gd4uRHQX79NEozdk+prQx5T3HfrtMgYC8xCYHhsBbzXlTHZzFoSXQd
   UW2Bgc0ZFu+WVUbNEp0nhxDfggvs1PZz/8ierCsaaISVOOj6TJPUxXhtM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="346922671"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="346922671"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 22:02:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="937108194"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="937108194"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 17 Apr 2023 22:02:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 22:02:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 17 Apr 2023 22:02:47 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 17 Apr 2023 22:02:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+jG/BUdNrAEPsJwYtj8X2A+lvtLpnPbMSAkWdcgtv3hIwS3XqtVzva8C7ZZclvTAFaDlW07PxJ7S9o3+DN63JCfixAdym+vuqPOx2hXrMV4eG9ApDBAUyZpxqY0uVcUCpVIpqUQChRUMg8SnuGq+npuStgHybi1CBIAQ2Qep4MKOcvKEUmqxBqul1/YY2OTONBfyYPX05xf7CNQe31jGeDmEqQDOVdXH5mATxPv02mxIkQknU7HIVsC5PkemWZ9cwkESdYCqNGs5KcO1PyLv1LqOcilTxae5RYS7ydyXRinhyMpwZ+xIDrgITr5orzBNcCvNkLzonV/T3AhQ5EkbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ir/qPlHBFPRkIfTSCv4AvDTvCUWWInNvVlclfx4pv2U=;
 b=BKTwfDc6LBhbglZQQETvQSasclZzFlSGz4NskKTld2tO/eH8N5h+jr8Cxdb2xk8gG+d7VhU/x6w/BWqGQoGJXTy6wIbmXGF30o123x1kcacthVH5b/CDyv8W7ahEE7oPlSIFVPWBh9b/jvYa3eTzMRwVzfOmWJ9aO1Cw9xCBwvocufphJJEPHbZ4XeJTH1+dGNRXw1WajKkrO156cubOl5JLSIDxwm2F5DM2I7Cb1LP9yEkcEASEB/I8i6qCxHEuT8SRBXzvqkLJleK4/Z4d0tG/Qx64v2Iv3xf8zrpgGICTaZvV7hHLGopI6BWyNKdhu6YEauaXuHWGqCvWXuUDbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB5188.namprd11.prod.outlook.com (2603:10b6:303:95::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 05:02:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%7]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 05:02:44 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCXow33Wzeq0K314B/OZqu968cqG8AgAAdbYCAACdegIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACyrQCAAIPEgIAHkI0AgAApuICAABWEgIAAGNKAgAA3aoCAACJEAIABGhiAgAA2uYCAAMsIYIAAPMKAgABpLgCAAPe5MIAALfsAgABc2YCAA9/IgIAA9jYAgAAIdQCAAAm2AIAAdrUwgAAQe4CAAAn+EA==
Date:   Tue, 18 Apr 2023 05:02:44 +0000
Message-ID: <BN9PR11MB52764F6F00EFCD6EF9ACC71D8C9D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230412105045.79adc83d.alex.williamson@redhat.com>
        <ZDcPTTPlni/Mi6p3@nvidia.com>
        <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZDfslVwqk6JtPpyD@nvidia.com>
        <20230413120712.3b9bf42d.alex.williamson@redhat.com>
        <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
        <DS0PR11MB7529B7481AC97261E12AA116C3999@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230414111043.40c15dde.alex.williamson@redhat.com>
        <DS0PR11MB75290A78D6879EC2E31E21AEC39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230417130140.1b68082e.alex.williamson@redhat.com>
        <ZD2erN3nKbnyqei9@nvidia.com>
        <20230417140642.650fc165.alex.williamson@redhat.com>
        <BN9PR11MB5276D93DDFE3ED97CD1B923B8C9D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230417221033.778c00c9.alex.williamson@redhat.com>
In-Reply-To: <20230417221033.778c00c9.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB5188:EE_
x-ms-office365-filtering-correlation-id: 9b276065-7796-457b-547f-08db3fca2542
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8jUUl9gZxFFQ+G4ERjAQVHPbfuT3OcArPxG1POHgPqEHfqLTHussgLNbt/S92+nNUo/N/oXFsU06PvWc/zyEPai2e6X+1OxCQJb1W9ef9s1NYcqiefm/tkGGvjby9pVUzO3rcMbJaJiP0pP8iOYKzjlVy19wPzU9DAWOBxUDl1jaXUQMd1kryI+t/i6cmWHvCiT2SwyfYf19DpDTla2PSOMmEix8aEfqszLyjAGiRE1lK5JQc9slq4mEMqqFkj3PVPtWVK+NwUpXEsKuyHukwBVCeHFE1WnfC8ZM0hK4OoKNFBcY+ExW6IGxdPO/0WPoKA5ohS5FVYUN5Ee/5YuWlrM2iApb2tPYqFb3G+HVj8Rc2eq6wuYnejhJx+XaBRQ0HOZlgdqCaEJbq2uqXdg7g+C4pyEPd4t/z1trgEBY/WNaRellU9/k/J7Ap+4ZgWH8RJcTw4lgb8GVBXo3D3LmwXgfGTLqs+L1JqoWS3FviOSwg38SLD+iKU9m6+2q48ghXVIHrL/1AKLikTueZtQvULQaAgTNyUhSJYz6mcDSiq02pPoieS86jsl2gTRBnERC9XcSSYkO6772v8BLAo2guKTOeS6dzuHknZ8PSCYVujTIkDQXHnRaf5RMrnPT29gW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(376002)(39860400002)(396003)(451199021)(38100700002)(8936002)(8676002)(122000001)(38070700005)(5660300002)(7416002)(2906002)(33656002)(86362001)(52536014)(55016003)(478600001)(7696005)(71200400001)(54906003)(186003)(9686003)(66946007)(6506007)(76116006)(66476007)(66446008)(26005)(41300700001)(82960400001)(316002)(83380400001)(6916009)(4326008)(64756008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZMtLLM4M5dEaYJID2n+d1pUdBky2AUBrOc8LMFs9yxv1szvsJZMLFvNvRwQ7?=
 =?us-ascii?Q?Q/3f+oyA7cIAKY0agQYTRs31a2Yy5i28jLF0R16M+QtWT+PPb6HCJw+MQXf2?=
 =?us-ascii?Q?9OWTAc/ua1YhxF3p24OyDyiAl4is9h02eZlsg1NMucSP+OlELqJ4dBw+5aiC?=
 =?us-ascii?Q?QPUFvCSzearDOGACI84sMiRp3+abBp/GGQTara0Mgk3cM9QEVn91kyS4iM9v?=
 =?us-ascii?Q?O6OJCVsJpYhU+Qp0rIRpJ3oqhEU9R0SEiPdaSgFnLJXqD2KcjH2WejlXOG6T?=
 =?us-ascii?Q?fqcsUdMmTsCkZ4UXGwTzdHpEF31Lg6kPNWachoZhemdWvebfXTUMLYW7Dc1p?=
 =?us-ascii?Q?Ve6+94elbv9GQSrkPGjIuSpEYDlcqF0ZokXEmhJDe3j7YSFlTKhUmBHJRSOR?=
 =?us-ascii?Q?3Lo43fEB0dGV/NtSg4XX5mhoLgWKbsIJ2jbzB6sLmLQK45fzqfPiMqflu0bg?=
 =?us-ascii?Q?iMYdX1GZwyt2o/0M0JJ0G7xsdpLy51rka8VD+7+y3OAYc7tqbjOIfZmucVq7?=
 =?us-ascii?Q?+0PWQaWlI2RswthPI6LH6QmWSwFtU5AoSJE2kF/Mpnm2Ny3TteA1/zXKlTT0?=
 =?us-ascii?Q?NaDFdXJDgcINPhE2B3aUFc7c3Dhqb3TGtzUVER0hXJwMxdxxuK06IMMtNxxx?=
 =?us-ascii?Q?tvhBjgxoZKuQaZ654FFPFKvx6cwA/csX3BZIBS+y2o1c1QRqUufH39K4aonO?=
 =?us-ascii?Q?JqQ3I97g1zF91RqD9aat33SGkviIN3U98NoDYna03/VFztkLvwPcSxSyng0k?=
 =?us-ascii?Q?ST73KL+xNQKXSSI23fEhROSlO1tYvDOfqpoEAMBwB4iMZrr1qsaTyv8gg4kM?=
 =?us-ascii?Q?InQ6GllpgFKPUQS6krEcsMC3FOWE1q8acgstspPn9Ido9SU9GSQ4pIW0k+TU?=
 =?us-ascii?Q?ORUz0d/p1Pp8+nWBzS1n/cafRFZOjqfA+hKU4tj7V+ddJRj1I2uc8PQ1tjk5?=
 =?us-ascii?Q?jMPX5Wj+vJ2uW4yVMTmYEFKJREibZvaEU47I9lgtVwNg26sRD47pmTChkrOx?=
 =?us-ascii?Q?+O8FNxkyqvxYt6hyBVEEGzR667h9OnaM6e1Ml36srhK557mfvsIt6UbJThgX?=
 =?us-ascii?Q?kt+Qqy0z9qSAtybY+G9j+qzZ+U58dEnwUzSnGdcRhH69bFkl/ty9I0nK6m94?=
 =?us-ascii?Q?1M6l3cDOXoZa4LGa3U1wRzmbYlkIh6KIRF7+hL6WLHSbq1uKga8FRz1AMZ2v?=
 =?us-ascii?Q?Cc05a2Di+BNHy8nmEiKvXt3o0hjG7M/A1EkiF/1WpEJcOJzRUd0pfohSo6Mb?=
 =?us-ascii?Q?/pEZQN3MMLU6zjz6zxJ8VIEPI8XNrXb5E60tr2uWK3aGmJr551a+LXq5+0Th?=
 =?us-ascii?Q?RF+5WkRjPqScJQEz3uq0zUBKq3zyfvACTHFKdMSMgCnKa6zVSGBlyW+uo/lZ?=
 =?us-ascii?Q?lPAX8RyzdVdObQvlsvp02hM9l6uKZENiZlYzaOAT9gIED9GbWT1ehmjA3wqh?=
 =?us-ascii?Q?S5IPE/fG4uTZ5cgKilUAnUU0vRu4fmuyPqjwJsfLEUpfpzH0Rf+a8/GQw1at?=
 =?us-ascii?Q?Ei7aGXwHdRwhVibcj5vTuv3YVk5iR2yIzYyNbwUooqIxJhCCbHM7GuHKlrnM?=
 =?us-ascii?Q?Fvhn/uav14WloaHFpIGzf8EjQJa59OSRR7KJEGPv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b276065-7796-457b-547f-08db3fca2542
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 05:02:44.3925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PkdR8o/fnsIBba64yF+tm1CsKFHL+7vkC549fhoi7XZAjNx7f/UtIoMtO85g8rkcy9iEhGY01Hd2YCM4LxnMfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5188
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, April 18, 2023 12:11 PM
>=20
> On Tue, 18 Apr 2023 03:24:46 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Tuesday, April 18, 2023 4:07 AM
> > >
> > > On Mon, 17 Apr 2023 16:31:56 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > > On Mon, Apr 17, 2023 at 01:01:40PM -0600, Alex Williamson wrote:
> > > > > Yes, it's not trivial, but Jason is now proposing that we conside=
r
> > > > > mixing groups, cdevs, and multiple iommufd_ctxs as invalid.  I th=
ink
> > > > > this means that regardless of which device calls INFO, there's on=
ly one
> > > > > answer (assuming same set of devices opened, all cdev, all within
> same
> > > > > iommufd_ctx).  Based on what I explained about my understanding o=
f
> > > INFO2
> > > > > and Jason agreed to, I think the output would be:
> > > > >
> > > > > flags: NOT_RESETABLE | DEV_ID
> > > > > {
> > > > >   { valid devA-id,  devA-BDF },
> > > > >   { valid devC-id,  devC-BDF },
> > > > >   { valid devD-id,  devD-BDF },
> > > > >   { invalid dev-id, devE-BDF },
> > > > > }
> > > > >
> > > > > Here devB gets dropped because the kernel understands that devB i=
s
> > > > > unopened, affected, and owned.  It's therefore not a blocker for
> > > > > hot-reset.
> > > >
> > > > I don't think we want to drop anything because it makes the API
> > > > ill suited for the debugging purpose.
> > > >
> > > > devb should be returned with an invalid dev_id if I understand your
> > > > example. Maybe it should return with -1 as the dev_id instead of 0,=
 to
> > > > make the debugging a bit better.
> > > >
> > > > Userspace should look at only NOT_RESETTABLE to determine if it
> > > > proceeds or not, and it should use the valid dev_id list to iterate
> > > > over the devices it has open to do the config stuff.
> > >
> > > If an affected device is owned, not opened, and not interfering with
> > > the reset, what is it adding to the API to report it for debugging
> > > purposes?  I'm afraid this leads into expanding "invalid dev-id" into=
 an
> >
> > consistent output before and after devB is opened.
>=20
> In the case where devB is not opened including it only provides
> useless information.  In the case where devB is opened it's necessary
> to be reported as an opened, affected device.
>=20
> > > errno or bitmap of error conditions that the user needs to parse.
> > >
> >
> > Not exactly.
> >
> > If RESETABLE invalid dev_id doesn't matter. The user only use the
> > valid dev_id list to iterate as Jason pointed out.
>=20
> Yes, but...
>=20
> > If NOT_RESETTABLE due to devE not assigned to the VM one can
> > easily figure out the fact by simply looking at the list of affected BD=
Fs
> > and the configuration of assigned devices of the VM. Then invalid
> > dev_id also doesn't matter.
>=20
> Huh?
>=20
> Given:
>=20
> flags: NOT_RESETABLE | DEV_ID
> {
>   { valid devA-id,  devA-BDF },
>   { invalid dev-id, devB-BDF },
>   { valid devC-id,  devC-BDF },
>   { valid devD-id,  devD-BDF },
>   { invalid dev-id, devE-BDF },
> }
>=20
> How does the user determine that devE is to blame and not devB based on
> BDF?  The user cannot rely on sysfs for help, they don't know the IOMMU
> grouping, nor do they know the BDF except as inferred by matching valid
> dev-ids in the above output.

emmm aren't we talking about the 'person' who does diagnostic? This guy
will look at the VM configuration file to know that devA/B/C/D have been
assigned to the VM but not devE.

>=20
> > If NOT_RESETTABLE while devE is already assigned to the VM then it's
> > indication of mixing groups, cdevs or multiple iommufd_ctxs. Then
> > people should debug with other means/hints to dig out the exact
> > culprit.
>=20
> I don't know what situation you're trying to explain here.  If devE
> were opened within the same iommufd_ctx, this becomes:

It's about a scenario where the mgmt.. stack has assigned all affected
devices to Qemu but Qemu itself messed it up with mixed group/cdev
or multiple iommufd_ctx so hitting the NON_RESETTABLE situation.

>=20
> flags: RESETABLE | DEV_ID
> {
>   { valid devA-id,  devA-BDF },
>   { invalid dev-id, devB-BDF },
>   { valid devC-id,  devC-BDF },
>   { valid devD-id,  devD-BDF },
>   { valid devE-id,  devE-BDF },
> }
>=20
> Yes, the user should only be looking at the flag to determine the
> availability of hot-reset, (here's the but) but how is it consistent to
> indicate both that hot-reset is available and include an invalid
> dev-id?  The consistency as I propose is that an invalid dev-id is only
> presented with NOT_RESETTABLE for the device blocking hot-reset.  In
> the previous case, devB is not blocking reset and reporting an invalid
> dev-id only serves to obfuscate determining the blocking device.
>=20
> For the cases of affected group-opened devices or separate
> iommufd_ctxs, the user gets invalid dev-ids for anything outside of
> the calling device's iommufd_ctx.
>=20
> We haven't discussed how it fails when called on a group-opened device
> in a mixed environment.  I'd propose that the INFO ioctl behaves
> exactly as it does today, reporting group-id and BDF for each affected
> device.  However, the hot-reset ioctl itself is not extended to accept
> devicefd because there is no proof-of-ownership model for cdevs.
> Therefore even if the user could map group-id to devicefd, they get
> -EINVAL calling HOT_RESET with a devicefd when the ioctl is called from
> a group-opened device.  Thanks,
>=20

Yes I chatted with Yi about it.

If the calling device of the INFO ioctl is opened by group then behave
as it does today.

If the calling device is opened via cdev then use dev_id scheme as
discussed above.

in hot_reset ioctl the fd array only accepts group fd's.

cdev can be reset only via null fd array.

It remains a small open that null fd array could potentially work for
group-opened device too if vfio-compat is used. In that case devices
are in same iommufd ctx with valid dev_id even though they are opened=20
via group. But probably it's not worthy blocking it?
