Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A0F59B880
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 06:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiHVEkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 00:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiHVEkM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 00:40:12 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E869C1D0C8
        for <kvm@vger.kernel.org>; Sun, 21 Aug 2022 21:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661143210; x=1692679210;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rf6HPw67lwjV8PB1DAsRtqCYGcukbDLyFwhGQGnC+mw=;
  b=ALXtbk1bUa6RTGGimrZkjkuhMMCegrNpdu/p+IFheoIb0qBN4aXh9Fe5
   4lN+cS7WPnmFAM5lfTopmt5MgZam01DVqTt3vyijAxm+gtnuFuNiOMnLC
   E5MJr4tzzPKv1h2PYw6HvtcL1+k7IUQ+hKmY8eIMJDI5EIaKhvXer2RSL
   bVXUL2D3Ev1vnXGJ4NfzhGLgTGQUM08kM4Sd54LEH//HL8/51iU1uOL3o
   XVJ3OeABZVxtHEc2oQb1GXj6bpU5Z+1onblpdJKyNyc+mUA1y/aA1gnQe
   ilLlxaBGGnGGAPBpbgtXC7SVhxpN4S4NcOd73yQ82GCPSXnXXBjnqvCTx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10446"; a="292060828"
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="292060828"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2022 21:40:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="734971958"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 21 Aug 2022 21:40:09 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 21 Aug 2022 21:40:09 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 21 Aug 2022 21:40:08 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 21 Aug 2022 21:40:08 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 21 Aug 2022 21:39:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OH40shscQPxCZ0mMIeqJtBhr2p2jt8mPoGQgHTP2xGu9SRxs6q3IBICBaODPKCbEy5Z8RkY82WsVy1i9sw8EXI4iKsGj0pBa1xqJOMEfVz5hdOmxrDNdwA31t/mX3dGHxmNS5y4billeKc5VnGlalOcFXXMp54SBqSYXwGEvEhYHwO3Q9gaetohI52EDc+SFBkut1SulHKPC0AW+PIeJXaiUJrxPxaIJwhaYxhmhfD6ny+I/M9f3/Qof4Uw2h0VTz1xgvXREzYz/MMHvt3OVT8pPWkceGAcGIyOzmzcyo4m4fryYsQYTupCDynp8NaYdieBegqMt2o3yg+ggKThfWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xp5M0Ve3xjZRDyIPTGgrx+i2CEadIa0j4GXss19eJ/M=;
 b=E4LVdU1C1CWSEZSYp6lW0Msl8B6qdC8ocEykfhQzZoI7p+mJ+ULHEOLnqW/PXQUJIOhJu1Y7IQvDKNgccBccApHjM+CIUrVNkq6W2Jfh7bLVdQWV5pV+Q49ybzLnt6zMUppErsBEn20pvPy3j1mfq4qmhBlaRiJbfEmw3NJ0StN0Us32FRqBfNnHqeMUS/p8/ifVr/MjgoVUlZw46ldFJyjAZ7TxVRlqKXiYALDp/ZpSbEbFMxAkpbnmewB89wH4zqagPfLK+4BrU3PO//a4Ij0YUQGDRV9ceSZI5EuD3d6yC19K0O9mdw1h5+DFmz8eqzJeONphjxtz4rg1fQofJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ1PR11MB6201.namprd11.prod.outlook.com (2603:10b6:a03:45c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Mon, 22 Aug
 2022 04:39:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::301a:151:bce8:29ac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::301a:151:bce8:29ac%3]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 04:39:45 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2] vfio: Remove vfio_group dev_counter
Thread-Topic: [PATCH v2] vfio: Remove vfio_group dev_counter
Thread-Index: AQHYsaRGGwFgE99eLU+zfxszxAHdM626W62A
Date:   Mon, 22 Aug 2022 04:39:45 +0000
Message-ID: <BN9PR11MB5276281FEDA2BC42DF67885E8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-d4374a7bf0c9+c4-vfio_dev_counter_jgg@nvidia.com>
In-Reply-To: <0-v2-d4374a7bf0c9+c4-vfio_dev_counter_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e29a04c-d209-46a3-ceb6-08da83f856bc
x-ms-traffictypediagnostic: SJ1PR11MB6201:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MKuct1LIMENf0JpPyLoJrC4kRHgrcYduxJKw9dSAVk84ujYfb168sL7HWboludV5QDDk0Nf9hAbcpdD7dwhndMgcXo7RKZbONqBAvYQ8+v1ZPqZRDzpGp2vxEPCQfoZKC+KjwODoqHqfQUAn7Zbgv6Yj2Zr34yy+oxBEQ6mH66a0l28e2Yjzyb6lTtoGktW4i2VvQQhJH17S0uqRqStYs6fUbp1EkJBajyohAA1VIUTiHZ048POCtlXYd/tqAkRr1M+NlGYsi/mg0xcd1h4N61penT3KtYxEZx0RH0H/Aow0w2oTD2err+6ipxNPzpXxKNb8Ffl39JjhwXwlrMh2Xl2BKTUaWxpJ2MzVVReaCQmtqRrN7Yot6hONFsw/B04OJnmR7fGcVTIWoko4YhsJTKO00711RxC8LiEWA9mMYlprvbfZoTpK2CLfz5VmmjNleE3VxTIix+CjqvxWdBiz+Rt/HiA5XQ5S942ZgghDiRAXWfNALOpGCb180SsysFUiIsyHApHv9KDANB2Q7IVAZnWr8wctquJP3lw0J4Rp3WIfgnujqH7hljdHAGsKGGwgcWteUCPiYZuMSKE1dkCaHM1YSQ24Y3lFOUtczweUn9HqqtN6wUkXdSCbgrfgG7ONtlpZwFQBKeHfVUEH5n+AVnmHCmA7Q7dJgirX74J7r8MJmOYeOmFIkeYvn/qljzqOMXQjCbIPz36XoLLcyC/kaenbABJlFg7cHjVavnxVgTWiaTtk4netfVvUKBkaxXJoyz27Y9kcv8nbFl50eqnTHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(396003)(366004)(376002)(136003)(86362001)(82960400001)(122000001)(38070700005)(38100700002)(110136005)(316002)(8936002)(5660300002)(52536014)(4744005)(76116006)(66946007)(66556008)(66446008)(66476007)(64756008)(8676002)(4326008)(2906002)(186003)(55016003)(41300700001)(71200400001)(478600001)(107886003)(9686003)(6506007)(7696005)(26005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?45KGbfr4Z3aWt4BFuvSa7qrWFfvZiFA/RXOG3qVv+vXAcwF3chydoTFdCog9?=
 =?us-ascii?Q?3MClWHMRD0fnZtKUzu2qjaq0ALzO4QsVfpLKfoJTrzCL14qIbWz3pfGXwb29?=
 =?us-ascii?Q?KcKpsG/yzK8o2uT4LGp9W74kMw77r6m6RHBX8i8vJusHWHEpKP3hdaNn4twk?=
 =?us-ascii?Q?oiCqCvND4t3kPROHUaPysZ63sxItU8oZpIgUE7GiQQSOjFLUnkclhoxYF8TE?=
 =?us-ascii?Q?g4NK1wtTR+XvfUkE6O6uj0I12ieBaHoZYlO6KQiG1Ph6rrxwsM2fOq6voMDe?=
 =?us-ascii?Q?/dSXDzS4vx6xhywDH5hFMKTXXOX9lPYf4n8pq1hqLefaGclvqqwzMMHYDGEA?=
 =?us-ascii?Q?YwoDK4cyTBd1Yg/5hVltHpsjpnG4a+I9M1IgH3NH3jiphU6inTDgVrOhIPrG?=
 =?us-ascii?Q?7b1P+cuRFolHcYAY15ZcprJmLmRVyPp0iiKkmf+V+dOjfbiyV3mez8myFPKf?=
 =?us-ascii?Q?Fb7LF9/X2XhpsDdGEx3Abb2Ideq32JAWA6F6bDeLHVK/1nQll4Xuk+VU+wX/?=
 =?us-ascii?Q?ef1CPFu2R58n6A3b0NPBJSqUgFRKW0izATRecRK9XJFyS39k2zuSVxuG9e4n?=
 =?us-ascii?Q?ML1Md+RifL1RQRouTPolUGvq4eUi/ZJMFZLKUsh/ju0braoH6m8QIaTsqnYP?=
 =?us-ascii?Q?wkwVS2BfAmKREcZVVK+MX3s8Y6igEQHtCk9Y5Pt6KfUybQwupPNC8I87+Nk+?=
 =?us-ascii?Q?N0kdgYPaK6sqHinEyiEjgwlJG6UxaYMK65uFSXi7/PvWs/R3bzy/+YnUjaCo?=
 =?us-ascii?Q?MLrVeuj2da59UC643WB6k5xhFcnD2ano3mNdP9OrEeLkvoCcGkHFQuXxN7RA?=
 =?us-ascii?Q?J2KmgyyGJgJX9hTVFTMn3QDCsrwFoWXXfk5kOBiurMK5FsGoJVe9QnZOnpeH?=
 =?us-ascii?Q?2KNifnPsMu0R2CvHPxmjMgt+QlUCCQp8NoxgJA6tpGhYluQL2SwVWrFmnPNu?=
 =?us-ascii?Q?ztYIKYd83B/GD+j0Lkn+PkGcZVLi/fjI1r4K/2tt9Ux5h11T99Vynj//ZQ3V?=
 =?us-ascii?Q?4VkBClPGMxhfqakNi8s5zzEusCAF+E6D+Vxx6004U8T56HMTMPwKkZ3o34Lv?=
 =?us-ascii?Q?ttpjP58o8GZj1vtT7J1vm4P8M29JIfbMjUak/OOFC5iM6hszRhH32Spyn/vg?=
 =?us-ascii?Q?WxogxVqzsGMuu0mC4cILrjHINhXWrk80diRqUUnPhLfqPyfdIxoReRKmXAGR?=
 =?us-ascii?Q?c2PkNAee6GLr0Z+Ok0T8WI/Ds9SIz9TZOjpyYiqbs8IdWoq47doXc+b4dVXX?=
 =?us-ascii?Q?qw4BxKbJONzAMA9oXYSbMo6QKv8+9DIKRk5Ht20SQp8ZXNYPAgsAeJpOxEcp?=
 =?us-ascii?Q?GailEfuRlXwpWep9D6HVbK3zB13biSt1Civk+mQzNV5rQ1TmevhBqun/qC6Z?=
 =?us-ascii?Q?XTJapdO2/TFtjzPZrXiLpgC5bF8a3hVlHoVZY6tO/ptRDUniQBt72yqwkBwm?=
 =?us-ascii?Q?aLS8BSrTOXSgVKWq+/zBJkh7vh+Z2lGOu9gyZpH3KI3I/csbTcOzSOWomfgU?=
 =?us-ascii?Q?F9diSY7kWszWwrFS6dNRuCAfyiys55cOXpQc6ej96peMHCDBzv+G1XXd06vu?=
 =?us-ascii?Q?rHXmiDJiHXgCuRXZFr80tSnmjQSSNz8QKQF2BLd2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e29a04c-d209-46a3-ceb6-08da83f856bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2022 04:39:45.6050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: smCsESrmZ6nL7rc5lGx01+ntB0ogz67g7zIzqK4VndG9d/s89abFB+pZkir4VT/jTKuIOTFjYA/IHIiv2jDd/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6201
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 17, 2022 3:13 AM
>=20
> + *
> + * A driver may only call this function if the vfio_device was created
> + * by vfio_register_emulated_iommu_dev().
>   */
>  int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
>  		   int npage, int prot, struct page **pages)

Though I agree with the code change, I'm still unclear about this
comment.

First this comment is not equivalent to the old code which only
checks dev_counter (implying a physical device in a singleton
group can use this API too). though I didn't get why the singleton
restriction was imposed in the first place...

Second I also didn't get why such a pinning API is tied to emulated
iommu now. Though not required for any physical device today, what
would be the actual problem of allowing a variant driver to make=20
such call?=20

Thanks
Kevin
