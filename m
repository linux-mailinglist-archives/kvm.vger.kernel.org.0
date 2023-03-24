Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E886F6C7AD9
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 10:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjCXJKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 05:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjCXJKD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 05:10:03 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E2316AF3;
        Fri, 24 Mar 2023 02:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679649002; x=1711185002;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=s3CvGEs66O4tAbFqoNnDjYLzMdwuWNugLKqkSJXLM3E=;
  b=ezYTwTSfOZJXfCu9BSlFGd3946kGy/LwbDB9JP4CwOFKULcygH0YOA4n
   9VdfqSroxW1aRl+XuVJVGnXkAModWVXbykcHv2E2+0J88dAtBhzpIMMXa
   7YT9mXRzEeDI36aa2QfcV/i8ObtUx37QGJCeZ/ZSDVmV5XQ1XpsxRO2jS
   /ukc+PqBe3GHeHAqgOXlIrINfcJMP0nxiTrdd6Y3HTZXONdA5xIi2GdDx
   fOPYlE+JKa6PQaB1mT6jnxEa4Eb8y1axRj5+ZUvK1q7xIB+E+9bGOXgG8
   8yern3zLkSwl/Uyz1TCXebbYlkpIHfaGe3UsC8Anv7L/SRu4tdclRZup/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="402318685"
X-IronPort-AV: E=Sophos;i="5.98,287,1673942400"; 
   d="scan'208";a="402318685"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 02:10:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="715159909"
X-IronPort-AV: E=Sophos;i="5.98,287,1673942400"; 
   d="scan'208";a="715159909"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 24 Mar 2023 02:10:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 24 Mar 2023 02:10:01 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 24 Mar 2023 02:10:01 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 24 Mar 2023 02:10:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UuBweSMr2lKDKaGNBcB+6PzyUg+zQgRkEq8ED+Wc1HcDMEnly6Qd/CyCpppf9HtLMm1V/F9R3MuZ5+HY4TUwA0w+EvDmFdisi+0V/ZJpwn4QoodIZca1Xhjvgxbm5yfM9kagwKDmn2SKz4pPI3Vm3IO3b7bgNGLT4Un7kOj/cRlMd2UxzML7S8vZppY4vabmkNi1Ql3W4ofW6OjBhEIoLrbd3+5hGj9RZZ1QpusLTY671TJ2+sc8YY0QBw6kleYbyjSxO2ZvQkyA16BpS1C6hpnRWLFvjTv+1fG8I3KDhTdSr5+NfubP96Ki0hEtDJScwwn6xa1TB7elrZMaB2lJCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KCJQD0o5ibZp/ncl5PheSgI60d6W2ayNv1Nzc5grRnk=;
 b=Xcb/SqwecSVH8sbUmPms9mD4eTDMeqnRbKkO+QJ2tSxBUTqqvSh1qIaNNDA0gOyoZdtxB70YFUASLgIhOU3j54lfyQLv4NrqFK0BmB8KPAC6B4/ZZcHpD96oAz75SqKyMjuOvHkhYDm9EylBmY8n09eA1VjvOqiRhpw+mIKYOWfUaDbed2y+8gYVJd+Tcin7i8Veg63ucSwMg72JWb2f41syBlul5HuXDu6ugfq506XYY/waFz++QfHQ6FxAXhFHuHaXjh8bZrijkstHjbXJe2utregprLihPilJHVv6d8bdNVsQASDL390SP661/v21lNHelON5ih1PBLcdaiXdrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.39; Fri, 24 Mar
 2023 09:09:59 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.039; Fri, 24 Mar 2023
 09:09:59 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZUcIISo3Z1SbL8EmJASujVt/DZK78flGAgAAE67CAAUg5AIAATEkggAAR+wCAAAeXoIAA8euAgATYMwCAAF5LgIAADRaAgAFd3wCAAAU/AIAAAxcAgAPvcSA=
Date:   Fri, 24 Mar 2023 09:09:59 +0000
Message-ID: <BN9PR11MB52768F48FAFC65ED7AB45A428C849@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230316124532.30839a94.alex.williamson@redhat.com>
        <BN9PR11MB5276F7879E428080D2B214D98CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230316182256.6659bbbd.alex.williamson@redhat.com>
        <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230317091557.196638a6.alex.williamson@redhat.com>
        <ZBiUiEC8Xj9sOphr@nvidia.com>
        <20230320165217.5b1019a4.alex.williamson@redhat.com>
        <ZBjum1wQ1L2AIfhB@nvidia.com>
        <20230321143122.632f7e63.alex.williamson@redhat.com>
        <ZBoYgNq60eDpV9Un@nvidia.com>
 <20230321150112.1c482380.alex.williamson@redhat.com>
In-Reply-To: <20230321150112.1c482380.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB6739:EE_
x-ms-office365-filtering-correlation-id: 3c3b627e-98c1-4116-d27f-08db2c478b33
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bRAxOKU7aDQIGxs7GnK8CfWQQOgzWce/qI2uFSjF5I9cn2ufAmZIGn9Tmw+3IRjDxZ1lfM3i5isP13Hmm4k3qZQc+rQAHnN///5EKSPqk/KNYRHW6GES+LHQDaWhj0n3yb0OztDYUSFz3oQfIjJhvbLwpZYrtcHvJmtc7iko8f+pxiUcZT6rYnsAefV+EomaTS8qnQQQsLoHQRSyAUo6ZdobDOkbGwBAvTprJKuduJGYi+efhvCYZvpcDB8fLEARBk+vUEixKCf06Yuhiyd7xn3TfLFLwrpK4jSB8e7YMjdjDmUJfq+Fe3p08RgYVy6pOdfMJC5FHZ1OwAWDa1fL3aRN+bULLz+CJKKQzED2nekNn4XslwEDR+V3Nxo+C+iIYt4IMKxEVdFxK2eiJF1G6w9GEattG7Cn5MiNWUzWAloUYUQ7T+2su7dJASu9llM5C//71mB20h8G1kWZmacoU+ezKTcQyZ264WQtWzGZe3k4xotLE2eiXyuYPLO/IHsoGJaZOrINc9LidoxaIktDjbcDjbXAgif/Bt6ddFhaq7iqbV5tdRqEs2nTEkYTWVVBopujQkYWh7E3wDOz9LczcOJgVWJcPzfBVEWpGaKAaAIkcksnUN7k3JVLcNzq0BLOsTAZZGH7SEYRZx2QejGDvLLorKOZykchPROY8pc7TC224PwPGSxx0lCaIKiRtgokQpExIYvlWC9XxE1CWGoUCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(376002)(396003)(366004)(346002)(451199018)(33656002)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(4326008)(52536014)(8936002)(41300700001)(76116006)(122000001)(71200400001)(7696005)(316002)(478600001)(54906003)(110136005)(5660300002)(7416002)(4744005)(2906002)(82960400001)(38070700005)(86362001)(55016003)(38100700002)(9686003)(6506007)(186003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qYHu/Q1ZGfEPfmglX+vkjRT6mNxgcGFkOKbct7a+RUeTpJcPV62HsbUx1+Bm?=
 =?us-ascii?Q?NZvTlFBTBdb50y2wVY6Vg/iz2JnKuBplFGIS1L/cZSvDuTP2h5noB2ACDYf9?=
 =?us-ascii?Q?PsHkYxPx+WKe5CN+HooTAaMb/no0NB2kmtn5gZWBTNBnPKt+5f9UV46yRw0Y?=
 =?us-ascii?Q?gYwMVcqK6nVBdoCWpt/AkKh65x+jWHXsjFiBWnv+CL6806PHPTxBFNGHEStK?=
 =?us-ascii?Q?I5EE2QIYiGhad/gSHkK+o+93eGN6bt0tS+HFjecWKMeTkrWeoc0gyBUsaIQ2?=
 =?us-ascii?Q?gnScBjKg+NtwCAUQgoqaz1vHaW5qdSIN186uUXcQdTDPbi8AMmoQ0uK5eXbc?=
 =?us-ascii?Q?XjhwecLDTHSIf2JwgdkZ5hxoodzuSF3DS3Twh+zuZ/yFb6wA9uz2embWe1XV?=
 =?us-ascii?Q?OnTyHnO9L93PeGSBs0OOouL3tZSBhlmCtpuDgCfRquRCa5fBLHbSIcqov22I?=
 =?us-ascii?Q?IDCHvKcUeYkMciw9UJgkXIpJi76QDE3V2aLq9k0O7ikCmqhI7KfaW/I1qger?=
 =?us-ascii?Q?bMrdhYg4IAA//wvj5TPOEY8hw0KauJ35LHe//mLrMxY/9T9Lrc0XZbmsuvGi?=
 =?us-ascii?Q?szS1HXVsRHnWTn5+Fxl7N6/FXguJzxQPS8qVkmFZPXk8rJPU1HRt5be9d8XR?=
 =?us-ascii?Q?b4K9HE0VYx8/wZclrHjiLfRb9Gkl6lv7lSspd8LPLFzzcxWEAERx6NPFxUIP?=
 =?us-ascii?Q?xMxnmEVwOwu3pB4vJuNSBvpB2HdYUewYjEVaH2ODf/ROKGRcUOrve88gL2yz?=
 =?us-ascii?Q?XqmvazDuGUi9vcaYlpDRAfV2jXfdB2iBsVxALcKdYvs3b6Nu3ASSUbp3sCeN?=
 =?us-ascii?Q?kWeLWYoFmwTE7eAC253qcMEwX8uQicWK8jd0tLKVxbxIDTK9zV32go+C6jaT?=
 =?us-ascii?Q?LF1RnM3xZDen+5M9Mw/WANHG7uH5Fv70aPqdvaezfmJ4IYpYhFmrhDRqTc8P?=
 =?us-ascii?Q?SBU88tjOlUBmsPj1utpUiu3fQYCfmmZQXG7P35WUit9L/SxLu1z7K/F2DUsF?=
 =?us-ascii?Q?IUWCZRaLS6ViqBbdS30r1O0mdpLZpBvgGlEpbt09oH0OCLWW3jkW+Cd2N1wE?=
 =?us-ascii?Q?zbH+Zd+UPkntHeHuAv6JqtOYFLmAzp7m4ME3HJLGYbN1X2AL4stk6wg8PDrf?=
 =?us-ascii?Q?+LX9Kj0Hihlg5bzzQrtePERBHC5P53DArfFPNClthCOkiIy98aKzDbvqVIZc?=
 =?us-ascii?Q?Zr6cA0UWbedjDoNSzhGeIrHTcfaIy6uwVhgaPeGQhaREFrS+6JSCUbOFZK4x?=
 =?us-ascii?Q?0dqwkEMaP6b/owr2dlKsZ07b/yFxVpFOsdu9kdOdXWftnO9LoYXylm5CAJ2X?=
 =?us-ascii?Q?54bwZt/yatUzovz7vkXQZreAuga/xUDAJp7uSNWucu2p/QEMcHQ5UIajf8gL?=
 =?us-ascii?Q?FpjHXiujBr3i6FGFNCadFFEn+SfYPvAefXFfrlCkhCYy0dBnn7zEFiv5o6GW?=
 =?us-ascii?Q?mJelHTCvNVGYW91WhS+cYXaE5obSunuN0o5xE1cmKr+VpzY2WkwIkBXJmqBP?=
 =?us-ascii?Q?6bvTbq7C1ScdhmQZns/BKtHT9YCfMycJEc/ZB7RR90n8Penhm2Xpe5Z9sQKU?=
 =?us-ascii?Q?rTC48vUB9T6JZlp23FS8i+j3thh+nn57BKGBOSX9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c3b627e-98c1-4116-d27f-08db2c478b33
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2023 09:09:59.2629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a1+3DqRu6pDPkFSJ1MiBXu8N4k77fcJgCb8QIIks474JO3BqK/xDpWoxIGTclMBEWK1iFEiy7XPZU9urVqWDVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6739
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, March 22, 2023 5:01 AM
>=20
> On Tue, 21 Mar 2023 17:50:08 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> >
> > Though it would be nice if qemu didn't need two implementations so Yi
> > I'd rather see a new info in this series as well and qemu can just
> > consistently use dev_id and never bdf in iommufd mode.
>=20
> We also need to consider how libvirt determines if QEMU has the kernel
> support it needs to pass file descriptors.  It'd be a lot cleaner if
> this aligned with the introduction of vfio cdevs.
>=20

Libvirt can check whether the kernel creates cdev for a given device
via sysfs.

but I'm not sure how Libvirt determines whether QEMU supports a
feature that it wants to use. But sounds this is a general handshake
problem as Libvirt needs to support many versions of QEMU then
there must be a way for such negotiation?
