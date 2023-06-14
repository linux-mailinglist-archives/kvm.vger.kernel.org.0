Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65DDA72F4A2
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 08:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243116AbjFNGU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 02:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243098AbjFNGUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 02:20:23 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886BB1BDA;
        Tue, 13 Jun 2023 23:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686723614; x=1718259614;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HszwuYCceGH0Bvg6IsfK3suBLlyg0qGcHLUk8iamvS4=;
  b=MxtNXqQba0I840td7yYefJ1hfpjZxHgwdSXKTvODyKqr0WPSZaNJxZGD
   m9/9aWRHoYtJgu8O5Vrfx+P3T+U6Iq7INQ0wd+P+FUBD5j8L6IyQ2HahH
   yRPl4ZJ5sFy2y+sx+8gKrj79MNwXvW4HhnvkjdSqAJj/aXT3gGLAQaUlw
   AfHwNHsTx0e0bfHMqVSbRXQd1YHNAsnEkfJFo/buhoLXC0IiQD767o/ax
   3GARODmXk58m1Oy7zBBlmb9SB+41Ri6qzr+YqTZkhHQWJhxuhkLqCRvuB
   lV1B/n60b0Y62SyBEd3NXoKyT4EUZkhK0pDpoC85Vualvm++A5GT3+H79
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="424418291"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="424418291"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 23:20:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="715071945"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="715071945"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jun 2023 23:20:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 23:20:13 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 23:20:13 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 23:20:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOH57/yFsu+h4IXMLO11VeotSAmvbhFe0qrfzTw0lItofkvvbobz+e4tJL24diHTov3f1lKTi7kRonR9NAZyTa4ZOGjUs8Zm1+U30YSnhNvKy3dzYGW/pVJ2Obe5AV1RoOZIlEQ6mn1HjMOJVrq2L8F54Pf2sRAcYy5DOWfBeyJ65QkoeFff5bQ75rd7CssAfUz68dSECKiYkLMwXOIqT6sy9Zkhf73SPTcDIfP2zJV6pwPwV0cHRNlpu3GUlQpLR3o2LCnbus74ekkfNlYRAGsmMapWk02+3SpNb3ZFJDaFXicRdXw72XjW0u3uTyy+FCCxYO1CAT30zHdqE7+iNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NRENmjiQxkrU3x30DmpzK9/m3xqWdlVQHAKrouIfyVE=;
 b=VZlplvYaRC84IjSe6FD/wZtP9NgprMeLGNHqdFaoxGIpAkhmbDEstYGIPkiMV0hBb1JKFGMpXte2zmwDcCGoK7JyyRO1VOw/NYBCQbTy7OFPqu6aZ8d+KrgX5EwpDi6KQKwRDP5YBKM84C3R5F5o9YecSuxc+fCskh6NFFWhM/FHy4vUIybJzQPFFhHPlWb1JYEsgk5Gtd9VeZh9nBvTIEnZgJci5Lk6RdG5StN+KVtNe2MVgS4EhMpHPvYCL+BpnjhjaVjnK8CmaLJSzUy28uWulRZAUth33jjZD6bydNgLdSETYQZaUB4QtYNazpfenS1XOtwIEADDLWZB3J27Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5024.namprd11.prod.outlook.com (2603:10b6:a03:2dd::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 06:20:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 06:20:10 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Topic: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Index: AQHZlUw4/rlFbB33G0OF+kxLW4i2ha+H07wAgAB4fACAAI09gIAAA9uAgAAEUQCAAAOrgIAAAzGAgAAiIoCAAAWUgIAAK4AAgAB5BgCAACPuwIAAC6cAgAABjDA=
Date:   Wed, 14 Jun 2023 06:20:10 +0000
Message-ID: <BN9PR11MB5276FF400A7860DD23CF222B8C5AA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-22-yi.l.liu@intel.com>
        <20230612164228.65b500e0.alex.williamson@redhat.com>
        <DS0PR11MB7529AE3701E154BF4C092E57C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613081913.279dea9e.alex.williamson@redhat.com>
        <DS0PR11MB7529EB2903151B3399F636F5C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613084828.7af51055.alex.williamson@redhat.com>
        <DS0PR11MB7529E84BCB100DE620FD2468C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613091301.56986440.alex.williamson@redhat.com>
        <20230613111511.425bdeae.alex.williamson@redhat.com>
        <ZIiozfqet185iLIs@nvidia.com>
 <20230613141050.29e7a22b.alex.williamson@redhat.com>
 <DS0PR11MB7529F2D5EF95E9E1D63C9264C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52761B4E9C401A46FA5B4F2E8C5AA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529E50A3F122449AAE5733FC35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529E50A3F122449AAE5733FC35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5024:EE_
x-ms-office365-filtering-correlation-id: a083ed41-2f81-4a33-08fd-08db6c9f6849
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M/3DsN2/WLrELEp4BcUftyFVrAMyH8ymKOHO7SAtXpG7nUcuyg1Usky2IiWC+W7PDwoCsw2iYdo8edmkzqVvUgOam2nEXLCkpHZ7TBcXwuhMiSmb8cp3r9vAzRhzI6TqwOzSqiWFxGqrMdMuKl06kkYAXJk8o47KW5l/45GLHafS1pJo66JORaTFRJNU72Al436LKfl12HlnXNga4q10eMP/5aReBTLD0yUVV3NfefuchTa15qvBBjBNWEZv94WyqZQKF3BVz3sw2o7MQhQEMM31yQJWyIzw9WNbwA/bJCqbNcaWKvhY5tvAAN2EaD/tqzvchbXvvNWdelA0l+w5QTXlLZa9Lf/gSdhyZEAVZ/tGYOTrQwkPq9HZTJ/KQkmJ67KB9aLlCqKcGUAhzMLL0LlL7EYT84msthfl59TTgl0aXTKMr7zleGiDcMedHWzeslKxUFSODDzsZeW56qrU2lCTmy6euZczWNak4TnpyQMLsSLvBbvyzqDhTJs5471zbSsua++o8WenuMhT+ZlVQaN0J/TsBIaiwUpBVCqzHrUPcZTszfg4Ayz0NhWC5O469rNqsfXVN8qXDgUTAfSttOVdFMftjBckVumyW+lBzh6XGFw8rAkR7hFeDi63m/Lb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(39860400002)(366004)(136003)(451199021)(7696005)(8936002)(9686003)(26005)(8676002)(41300700001)(82960400001)(478600001)(38100700002)(71200400001)(66946007)(66476007)(86362001)(4326008)(76116006)(66556008)(64756008)(66446008)(316002)(122000001)(38070700005)(33656002)(110136005)(54906003)(6506007)(55016003)(5660300002)(83380400001)(52536014)(186003)(7416002)(4744005)(2906002)(66899021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EPYt31yXeQSXopkW2Ot86+LzmVr+MpSp4mSk6HBum3MOO+5PEsypLPHenmR1?=
 =?us-ascii?Q?EE2OO2Fz316YCaTKXRzqldIhUALSx2qKxg+8s6GhLmB1m1xOMAska+Ao8C9B?=
 =?us-ascii?Q?wCuHZdBU/MdhDwEjqgskua6ar6/LTki46GYpqLwyHO5cncJvxwvvA3qiZKi+?=
 =?us-ascii?Q?n7OaSlBZZiIZXbSU9jbDSxonr8sGWG5eIyXwlvupClDJYSTM3tXanUckyfb/?=
 =?us-ascii?Q?HDjA7OrHlu6kVHX0Y9RESunAYLVS0zkeFstgvKNVPtk0NJr6xkUVlq51cpWc?=
 =?us-ascii?Q?XsT4xfxuK34eGEnXriVNaebRD4VUOv97vUC2SL5yiJjKu8X/mBPDfr5ZogtR?=
 =?us-ascii?Q?kpf9jmHoAJmofNzWgGAL8PiNwS0KP7g0M7v0AYVgvqT0lKHW2dANdmmpYWSq?=
 =?us-ascii?Q?4+SGUZQjJSxdn9zUNnV1v7baXovlIHRathSuIZ5aN7nSoDNn3FUv5dKgb0O3?=
 =?us-ascii?Q?twFa/s+VlX0JrS3SC+2hpBDanhZ+Ic4/niENEz18M7QyYFxdbFNrlfbPP7qn?=
 =?us-ascii?Q?CcOXiG/AB4mLRRAoesj1QKrI3guGzSrOpPto14fGtUUB4OTjrB/i7BpD7KZG?=
 =?us-ascii?Q?kM1Wsf2xbS9gztlQAwaswBjyivWBmESiVasTFtYFOrQPc0tj2DTX4EsoHYSz?=
 =?us-ascii?Q?uH0bNxmrIHvIMJGzDvsmsQccHErLU1bgUtRYPOiiK4AU8ld+Y2HZ83EWNPOm?=
 =?us-ascii?Q?+7LJaKIvLE2qG219w61OHiJnYbX/RGJKN2Kp0WHDapO2OxJz0QJkCqn/S3lD?=
 =?us-ascii?Q?lk4p30dbNmqHJYOQcfspXXieWsdonJxjjVj503WluELL2kBX1nv/QAdMBk53?=
 =?us-ascii?Q?+exZ1fHSZcjkmvFHf1lMOReM+R4U7P4+X70WLS3ldm58csXC4bUMNEtSF5GM?=
 =?us-ascii?Q?IiW1/GVNk77C4AkQFYiJhhSJX/Rx4+1Rq6mDiS/V7v1ZOHoOlQl0NfzUC3Mc?=
 =?us-ascii?Q?Ir5sf/0EZ/u4Co5x4BcON/nKhqAqxxu5J0LzuMbVEbFRe5SG2IRI2e+GaMsX?=
 =?us-ascii?Q?UUi/LKD1oQldFPKAxyaOfylPzaKcFByc246K4kWyS0xjJv1o77hneRmwQpYq?=
 =?us-ascii?Q?pEcH5UQpzPw9NZnKnBG8gTDplAd/NrYCkh07VkCzQpMLo591csp1rnV2EQNL?=
 =?us-ascii?Q?9B2wObLYa00lyt9SSYpK1brrlVsuj365lnXMc23IVFLY4lgPLAB9rW8rCRHG?=
 =?us-ascii?Q?LqyGU14yuOWJy/SacmDhxOPicNNPjAorEFjY+mqDN9+yrOzLv2UVFFtwI+7Q?=
 =?us-ascii?Q?UdZjwX/lEdcHN29Lm8Dmpu5DZkKcvaUN56QomuMZLXe9cjGkRb7vhyxLSjUm?=
 =?us-ascii?Q?6HJc5BsYG/HpmnFVDkzIqDPF9GglskxqQxKpGD0rrc4HNr9PXpawtBmWdVos?=
 =?us-ascii?Q?qd8kr6MWEffdvuTcPR1hnN6v6/1jdMMccI3WZlmPpfyYS307zcikmHdEDuRY?=
 =?us-ascii?Q?4wX9U8O2p4ToJ9SzF0QE3fEHYngnx6wfAvEm3I7nXJM7XHooH4CyeAtIQ+yY?=
 =?us-ascii?Q?pyEy0T6yOG+yCKUuyRxPeqcbB5f4iZ2shHPJWVlQWaYwlnAs2QDl/wDjvlyR?=
 =?us-ascii?Q?Vh0LVyqlFQEm6v/1gB14cpp+VG5sqiPO0cWXI5VK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a083ed41-2f81-4a33-08fd-08db6c9f6849
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 06:20:10.8109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gmVYMzOTxU4JmQinIFyKiRNiHAxANpbtuakMimXitj0ddNZz7N+Ll3dVSjw3RDWQrejvs8WIGVSU+ag1Iecbdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5024
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, June 14, 2023 2:14 PM
>=20
>=20
> > With that I think Jason's suggestion is to lift that test into main.c:
> >
> > int vfio_register_group_dev(struct vfio_device *device)
> > {
> > 	/*
> > 	 * VFIO always sets IOMMU_CACHE because we offer no way for
> userspace to
> > 	 * restore cache coherency. It has to be checked here because it is
> only
> > 	 * valid for cases where we are using iommu groups.
> > 	 */
> > 	if (type =3D=3D VFIO_IOMMU && !vfio_device_is_noiommu(device) &&
> > 	    !device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY))
> > 		return ERR_PTR(-EINVAL);
>=20
> vfio_device_is_noiommu() needs to be called after vfio_device_set_group()=
.
> Otherwise, it's always false. So still needs to call it in the
> __vfio_register_dev().

yes
