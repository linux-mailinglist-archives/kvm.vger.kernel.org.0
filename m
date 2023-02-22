Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FC269EF5C
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 08:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjBVHcf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 02:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjBVHcd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 02:32:33 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB46366A3;
        Tue, 21 Feb 2023 23:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677051151; x=1708587151;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=M8CYNnXtEKbHdq+28FVDYbwujohDsauXDzP6mTRiJgg=;
  b=df7IbXJuuqrXJ1arWc7R5VfjM55i2kHP49Tr0PYtTW5DAW3bVO5PCSiC
   8iyxJ11iSerpv4/7PNsh7vqwf/79Wh8qwhaXOUrrgWxa8ZTfAuzicRYac
   YoXrkZBuJKdb+XMq2FK0ia0DMMW42h4Q5Oz3idl6dttaqpLH91aV9gwP1
   efRahVrqL0rFoIT3GbdumqmH+m1h5AQ03Mx3U2m8QQsiabr88Y+5gvq1d
   ezHn3ZOvtpBP5snDD7eJBfEe9uzAUr72VjI82WjcGj067RakbjeAhAlGM
   6TXScq+VyHVrxsQPKfdjq6ytBCKptMUGL+UI4hGsY5RXvvwDYAwDMZxtt
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="419085520"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="419085520"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 23:32:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="781329196"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="781329196"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 21 Feb 2023 23:32:30 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 23:32:30 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 23:32:30 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 23:32:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=STjvlSNF5dMENwz/UEWpUeqKZjtmaRS4egblE1vvpAFCuSJR1vc+wQK35Ztl2xdMXz24/Xy0J4vaEPSX4ADLrpQMzLEq8qI/ioKZKalPcoe1wf7TbtB5qa0p1Z2WZNbuQc2btiiGWARq3A0j/HMT/JNO2XLq8tHYDzrXYcyFGv5nze/W6Apwly3tYfkq46mq8GySaI/c4efRsHd+I7XtF/PeqjTpCdoy6EB95acFa8Cvi/tC2inufWn0rUj7inuBHFB5lgBjSNFMaAna3iJX+xJL+gaKaTieAN0Ywtl1OlGccX3kJQKmRLtUeM3kvxbImxdZ47u7TZjJoYC3+3Mq3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M8CYNnXtEKbHdq+28FVDYbwujohDsauXDzP6mTRiJgg=;
 b=KFXRRjTLZPrO9h+rBFsoswsUapp6uoKIkCXGJ2icMRS1j4MBZPAEwzizD/ESsYGxnqP48hUQK2Hu/VaULVEifwivIOl1QC7ctdCL/xzgmyi+p4Xd2tAos812vlbo+/HGRhpGkslq+wI2OZnNudZCYt5r0A5GVz2TwD+700HrqVs+Se894pWRvycSQNpRU3ovXPMcbUK1K55tNvOla2X0167r93Bv+CjwdAE3eCZzaoEDL8tpKuqN3HB947F55FI4M5efWvPzuYuT46n/hH7GD1nsKhInFinYXFI6b4LaK41FkPR66sazhhcOg2TpZMF5PPbx6Wv8IExIA7vb7D/5tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by CY8PR11MB6818.namprd11.prod.outlook.com (2603:10b6:930:62::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 07:32:23 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f%8]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 07:32:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v4 14/19] vfio: Make vfio_device_open() single open for
 device cdev path
Thread-Topic: [PATCH v4 14/19] vfio: Make vfio_device_open() single open for
 device cdev path
Thread-Index: AQHZRadcHpXmMuBO0EyDAqe5y6bsH67alDaw
Date:   Wed, 22 Feb 2023 07:32:23 +0000
Message-ID: <BL1PR11MB5271E8B76F31707D023B10338CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-15-yi.l.liu@intel.com>
In-Reply-To: <20230221034812.138051-15-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|CY8PR11MB6818:EE_
x-ms-office365-filtering-correlation-id: ea61d926-85ae-46c1-b126-08db14a6f04e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Aq662qlR5HLyCUGUQGO58WaXWjAr8W7AyyN5X4P7npf8cZIOc/SvbKw49RCoEK939m8TbgDTFW3sKVjTBTfcwaiaZ6/HzeZD7XidFrQIWX19ESO8EOH0GtnQqEyzKPnZttjEm4fSndxdemKDKoucOPJ31ajgB46LQbM/qPnRyDC2Pki10+HPt/jHffTQn+skKGmdQOkRJLemvolTdZqmT7Hroa+NE1zc1aQqsKvgo5Ab94Bic0B3Mi6P4lgIDvxM3QqXHd3G4Jlet4Nb0OlaqzlGoVuW/ByCyI7sWLheqx0Dal+7aNBoELT3C4Wt23X5gvv/WIJKEE8eoSaWedRJyiMFJ/6YCva2bUFvAosVHOub/PK7xDmqZzfT4/xg6xRin3ExDuxpyAdoedikNuo1ix215Acb1edIqFSO9R+8rXxYFcqE8CgAqVUXUfO/8t8YXUHX0ejlLDxdYJIOJuNyD+5WgOwnmxy/V3BJGfFqbwMXtz4LOI2DAYyXIu51DHhEXg9/++pHqUVw87luAzXCAluaB3TbgTPFcqyDPCc34OTwBk+EWFRcDkcON2isZDUSQDifaykEfFsvrRD+NeiSPXggckXpHFujY8qc8U94PdwOWzlVTlSI+PqsNwmIvo6jUVbt3KKhtR+qwkm0xJ42esdwuxg0ARyxc9iylcRCVoiyvtJxkGL4WPDD30Lx46BXUSMLgbxpHInHjXsiuU/JHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(39860400002)(346002)(396003)(376002)(451199018)(83380400001)(76116006)(66946007)(66476007)(66556008)(66446008)(2906002)(71200400001)(33656002)(54906003)(110136005)(316002)(86362001)(38070700005)(55016003)(478600001)(8676002)(82960400001)(41300700001)(7696005)(122000001)(64756008)(38100700002)(8936002)(52536014)(26005)(186003)(9686003)(5660300002)(7416002)(4326008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MxGCC4LFyeiue9j9qqcTiDR2IljL+8RrAZDK9zmZZQHipAcZ9B5CcbI8ERQQ?=
 =?us-ascii?Q?eFCR1h/KW30ZeWdSF9MtXGLSyfqajnMM9fAlFzQ/AXUugls8XMyUawLFt54B?=
 =?us-ascii?Q?B3wEdyv4RLvheZMrIEFjI/QoHFb6suAClgbkfS+V8AgO4yvSU6pz4ssgBrwq?=
 =?us-ascii?Q?H3DF8/ZPIJnotW7AGQ9ORhBHQp5iQGHWnYREmyITucB8OM5g9xbBcPSat3t/?=
 =?us-ascii?Q?vZHCMcVh0OaBd0dP90VdwSG37pNIDz6O9H4QJGwpKy7H5zDeRb4HAzo06njV?=
 =?us-ascii?Q?49zK+U8ufohNT7ZYRCIrEtCSJPoU1q3rTSNtGdstVVgB2RUjxSi4vPaMg0I3?=
 =?us-ascii?Q?EDA94SNE/TkvRuZL1ZyUZ8gUBxUyxm4DqzWD9xI73TOfY1BzyqLshCIS145f?=
 =?us-ascii?Q?LgUvcO0zNUtyLrrUXA4fnPdrARq74e1QYxSebgrcQJANatN4Pr9m/Wzq090l?=
 =?us-ascii?Q?3VEbJJiWNm7vESzJHmLdCcUon46FTScqAXyDGq7wXqNoDaxn76Wtc+3JavaU?=
 =?us-ascii?Q?1k7eG402mMcrG24D491W10w+1yWk7hzwI0OgtwuN5erIiPasXKTwY/jhmkbV?=
 =?us-ascii?Q?tg+qckpWisD4taUYF87/mSyFXDednw0hrZVXGfz/+jTLlZZU0GdwWjOtjnn9?=
 =?us-ascii?Q?TXaq4KEaapM1CxNtLdk2iISpfYbbyV0H/kqiDtezNGQ8PhWCY59BNUZFMak5?=
 =?us-ascii?Q?88y2v/xToZzlOKf7xoAFwpr+JDZYYFk4t+3pjcX3bCggq27wkTZk2/4fqCgS?=
 =?us-ascii?Q?5K9rF8NR9ujNuJy5COXsTRVwMH9L0RmaDT2FLIagKuanbPqjltbuxGel9AIX?=
 =?us-ascii?Q?YkApebgX5hdAaJpMe85y6jDoKHoJFbrQjhIXoj4RA62o6Oesg47ABgBnM4Ux?=
 =?us-ascii?Q?7NUaius4NMWy5cFXix4R6GQ+HyUKidpCZIyCuSQ2gJvW48XT/cb//i1Xy3Xp?=
 =?us-ascii?Q?y5NxIhBnIQP9Hq8d/hNJKDbFErfUC38S30oQfxWi3UfRppezLQ0lCLzQ2YkF?=
 =?us-ascii?Q?QREecIysMkB0v51aRLzDHvU513THOM+vzowH9pWZ0NVN+4HnTEUxjG/WV84Z?=
 =?us-ascii?Q?enUbEXczXjNp1D9It1teFVjSinBgkRyUdB9DBSBdXTRV0B6HhHy7sMD1DxWS?=
 =?us-ascii?Q?YgE+UIY0BKatCNcm7ZwoB64RTHt0vzla2tRKd1E3AxLZQBbtCdzjbSfZkIgZ?=
 =?us-ascii?Q?zNVE+DlwWhbZiC4v6LGtbkVfkXfbMk0krGDOonoOuH8b0d/kXgt01C2RV84f?=
 =?us-ascii?Q?8JAkp9FPx4t5rpsqoNk6rNbQg0l0QjZ++OyJ8WCSxZoXNomK5Y0KyIXK7DRF?=
 =?us-ascii?Q?qnQbG2wBWgwFPqWRY0C1+RVLxtvaDjrT9eCkBZghZGCJH8aHv7m1ZoEEzWSM?=
 =?us-ascii?Q?IVFx27DziI0iEQ0UVB5fV5gwV0wGagFlYGbrBu/wIzC9dgZ5amLTMu1O5IFm?=
 =?us-ascii?Q?jpzfWzFcpWBQ9N4TZVuX4Je7fz116PKz03eCbsUxkUQDyk0kRS7NofxsgfbM?=
 =?us-ascii?Q?NNh713wING5ZwyKeK8sGUfrNO4zgw5fMIT/OK4ERvGGPnf0RPoGF6AbguZud?=
 =?us-ascii?Q?VQlf94O6DV33D0xzkVYC07enopYpbPOfPFUZPHuF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea61d926-85ae-46c1-b126-08db14a6f04e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 07:32:23.1716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Y8pWet3l798JIZ3uDTdc1kuq8RjXH8ILdELDkcMKLS8ctqrCH56fwmzXkSxTtWsDxIZFwRpzzwL8lIo0PgVkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6818
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, February 21, 2023 11:48 AM
>=20
> VFIO group has historically allowed multi-open of the device FD. This
> was made secure because the "open" was executed via an ioctl to the
> group FD which is itself only single open.
>=20
> However, no known use of multiple device FDs today. It is kind of a
> strange thing to do because new device FDs can naturally be created
> via dup().
>=20
> When we implement the new device uAPI (only used in cdev path) there is
> no natural way to allow the device itself from being multi-opened in a
> secure manner. Without the group FD we cannot prove the security context
> of the opener.
>=20
> Thus, when moving to the new uAPI we block the ability to multi-open
> the device. Old group path still allows it.
>=20
> vfio_device_open() needs to sustain both the legacy behavior i.e. multi-o=
pen
> in the group path and the new behavior i.e. single-open in the cdev path.
> This mixture leads to the introduction of a new is_cdev_device flag in st=
ruct
> vfio_device_file.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
