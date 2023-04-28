Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D97F6F1436
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 11:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345414AbjD1Jbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 05:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345391AbjD1Jbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 05:31:49 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1012709;
        Fri, 28 Apr 2023 02:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682674308; x=1714210308;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SJNa2wIlzH5MMiiF8pOD8PbDPFOboVwShKJIrcci2F0=;
  b=hw0nw6gUOklhZFV6kkqMDZQE/E4ozlVn1Tvlu6e8SfrXZiUOef6QrAtq
   eo2NTQ+LSbbnJ6Q+vxW0fCY8dksQcoHYmR/76eA/SUd+8kyhmIC2rAYfu
   r1TXO//7fO37M70e0BldA29mVJgW+u9zJCWPNOylX6nXNr3v63+Yd91p5
   Huh0xTffNiIicqlybFGQZlJe8qi+nq/uiCHWyemuVet+u+uFveXZ7Nfsa
   Xq4RVfYfzai1xopuNxo1Jpod4d07BvE0OBwmP2t6TD45ls/H3Od1oX0Gp
   rd5DFLUE1qKhDBS4kVz1sreV47zKxCve0yRvGPbsWqg/pAiA617G58XCN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="375692273"
X-IronPort-AV: E=Sophos;i="5.99,234,1677571200"; 
   d="scan'208";a="375692273"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 02:28:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="759591310"
X-IronPort-AV: E=Sophos;i="5.99,234,1677571200"; 
   d="scan'208";a="759591310"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 28 Apr 2023 02:28:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 02:28:44 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 28 Apr 2023 02:28:44 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 28 Apr 2023 02:28:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TpwetohPwELvDCsyWJKkAn0GmFLYjKQmtsXGhbFchT5rRphMBCFHPHyBZVEr67J4fcXDboZj002UcQzYWKs4JHZrF+P6yqOXZKVqcUzMG+LA+8uh0basqMbS6k0vWJhZbRKowvg0giukfw3uuvFsPsw+5tiMjYy0XdVCxnEI43V+3dtby4W2qWb9JI0w7+iqIIFt9ReoRzfW0aiy+O2PddYvgiP25LcSLW4+A23A6I8lC+CSyiR9k+r/KJmVpSg0ZN1qFUtN9R89FOJw/gwzkiO9zGgWB/jgVonz285ny1DgksIQCRIdTNuRozgpMPpxT0VMLnw1awmEZ8rG7D4mfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SJNa2wIlzH5MMiiF8pOD8PbDPFOboVwShKJIrcci2F0=;
 b=PVAdewyipoDV8KPyrQaIgFmqEmQRSXMjgxEEA/oeA629TiCEE/f+1k0yVZhPCSSvg+3qKsskJGCOoAcsiHKPSpn/TkXqLFMVfG+YJnaaRYsJnk6XmKYjcToYX6r32azZC70sxhdzp/1U7NrhZnNb25ypJ296Zf/8eGDWd3tsVbq6QSA4mnSlmxQFYyAvgC5h1xo5NEr1qGyd4lMQUc0om2sTKvEaBcDEq5Osv2K4NbfYFAXtq+NHoBJMt/jKZygvAX3yYF/yNpnuVZ3PbKx6nNb8VlIM2U6PykygCRm0ByWHHrGmCmtorFX3eP0DfQXWXr+MkyV4jH9N0DrwF4CopQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7)
 by CO1PR11MB4881.namprd11.prod.outlook.com (2603:10b6:303:91::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 09:28:42 +0000
Received: from MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::ea27:a8a0:3e6:db89]) by MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::ea27:a8a0:3e6:db89%7]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 09:28:42 +0000
From:   "Jiang, Yanting" <yanting.jiang@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v4 0/9] Enhance vfio PCI hot reset for vfio cdev device
Thread-Topic: [PATCH v4 0/9] Enhance vfio PCI hot reset for vfio cdev device
Thread-Index: AQHZeE8AbqZEF84PlUWwgvN23aVeha9AdnOA
Date:   Fri, 28 Apr 2023 09:28:42 +0000
Message-ID: <MW4PR11MB67632FDF85A5BD729B09318AE86B9@MW4PR11MB6763.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
In-Reply-To: <20230426145419.450922-1-yi.l.liu@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6763:EE_|CO1PR11MB4881:EE_
x-ms-office365-filtering-correlation-id: 9f5e17cb-d39b-4f55-becb-08db47caf50a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xvqZA6rauxA7H5XX8Ge9sIintk/p49/jHsz19JVjCovIN6IwfKfGvZxgyqBhqqfbHyS4hxWYzPtl61nAll6qCyJStJ8E7zuCMhtc0QwU/6fSCLPz402Lzas6EXEd4wM76th1nNS50nDhE0qz77nCli8cyUGSbJuD05K2xRQdQnprU1XAI9KXMTUpLY0mZgsLtRZuC9jsh8Dc3uxJp4yVqPZB1ouAiTgfeup9u2eS7YO/kj77HgRfJYAgutXvnXOsRrBhdg3YCSVMbAgWwYRpwS+BeC3l1DqW2parB4rUMHNygLMTY/+pkcCjBOdlyyaFVy9G+UhiiqTmglSIxIS5E5RxPlasdC6BIdqmgUJA6cKh9vAFYllKHwTLV7k2yqxbr0LsL2Jz/U20Fgru96mxMmWsWd6ajpkUNhG17C6bxJI0parfD6u1mF2gyjN+MuYiqDG1BBLahVsjKe5gty/WkuijXQ6wv1ns8xfLTBeXDMyrr8HxgwLIm80B3g2BRq2TTCLQYyP8qPstZb8LlKov+Pzy3+uo1/G6B/v7gjTvWrAzdQRl99ux/2ANg4yuwgeHipp3wT6pYLcMU7jj9kLN3ZKLMvrHCccKcbaw+AB0A1g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6763.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199021)(66446008)(66556008)(316002)(76116006)(66476007)(6636002)(4326008)(110136005)(66946007)(54906003)(7416002)(5660300002)(82960400001)(52536014)(55016003)(41300700001)(8936002)(64756008)(8676002)(38070700005)(2906002)(38100700002)(122000001)(186003)(966005)(26005)(6506007)(9686003)(83380400001)(33656002)(86362001)(478600001)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kPjxOKEY165q6O/WXkkASuczdees/GBeZA0pvLGKDhtveP/bD8GBAq6YM8JX?=
 =?us-ascii?Q?3o23pbn01i8lTf27k3SFoNT7DjqK8upuKs5lUkBTK2+/ZAXsly1cuJFf3I/n?=
 =?us-ascii?Q?L6u12dfJ/6UpnnOSjrxlPwFuBPIjOLalO1Logqh0LsgQyvCHQTctZUZLP7RQ?=
 =?us-ascii?Q?4dnlR1dtMYoX24Rb+cHe2MDpWUY9fFGyFNtb6s7ElrwU8j8bBsdVfysq8thF?=
 =?us-ascii?Q?Agalm/+aTHPvO5UFxAXVRyXf1V430C+l5UEHsdBa7fLGdWcLCH0/JdUD/+Hk?=
 =?us-ascii?Q?/E3C5DwZaDjkub2kqTavRLVvi29Sfgm6BXmIowcFzqgaWJS3/oUe+KMhQSas?=
 =?us-ascii?Q?4kDZNA7fybWwLMK0nQxCgf143qe70+afaCn2Dp7UZuwhx0LEVphZfwdu2lcT?=
 =?us-ascii?Q?OC2IKMbITb6XszgZVYwocdeVpTCDOuTk1kZqgTn48F57teNwJy/rXMtz0snZ?=
 =?us-ascii?Q?hjmGvFyHMhRrYLoC7svWryrrRuYJ7vxUmpKTPHfhqe2hFVSq75jPd5HD0PAB?=
 =?us-ascii?Q?kS63wYvwi8MYeKPAEVAaleDaLDNzNi92kXyfPEwbtOgmzV/3VH0Wn1lDVj+R?=
 =?us-ascii?Q?Qr6DuqNna6rh1yvKWuJ8TzhkVin0IK6e/u43ZDFM9Ne0Oje1Zg0lRnGVPsjz?=
 =?us-ascii?Q?4s7vWhhz65mvhZlt6St1JiWI2ZCN6SFKctGiqAztJkU3xOBSxFN43laIlcki?=
 =?us-ascii?Q?bEy/btSr9pxXqIW3/MmcyO8mP9DIAPE9B2mb4yeZwIc5Z/RPnbCoxDz/bAUM?=
 =?us-ascii?Q?3+4a3ljWAoyI4HN123K7anbWEL7X1x3Gu+mTYSVMG9M0oIuq3nc3URxpQtnG?=
 =?us-ascii?Q?EQUNYaU09Ee9nnpstr1K6YiuNcp16eqPLbivDaaINGF4uOhxyLxWkSHgAy/r?=
 =?us-ascii?Q?nVWPUBW6W9j9kzoB0Y6qGdAV077nigt4hImNGyRWkzZFoJCkumpqW/Z61Y2T?=
 =?us-ascii?Q?mRRH8Xp1wbg3jaJAtzGDCdwHCjSa6RyzzusHZv9F7/Tkcvf+maZVUeZlplWA?=
 =?us-ascii?Q?y1TbxJk/1oxlB3HhfTrWkdolwPkVTuzW+cRmaXE4bSaBSDw2Jxd7+R3WDsq9?=
 =?us-ascii?Q?AnX5a9AMbMtMCv2XvfY1sA+ZfJg43kSqJazQY47U/IfEtJU/AyWHkqI3J24I?=
 =?us-ascii?Q?Rmdy+Sr4NKTaOgySlTAGp9PWYP3MxMWc27U4+3wO8An90L/o18dMQR+OSPAB?=
 =?us-ascii?Q?dnR1y1olETsupUI2tqcwLWDBFWXnP+6WwGZSpD1kNG1l0QCylwxxA3z4coYe?=
 =?us-ascii?Q?NoOyr+/6mp7D07FBvlH6e/cIMg6UYe83j8eFXbl5ahKDNkLG9mdO3G0oRUK4?=
 =?us-ascii?Q?kWa2/hKVZMJ+MAaQ81GG74ZEDcWYa0jWyz8nY368oXZ8Pz2qFjELbUwimCHy?=
 =?us-ascii?Q?Q2BKFfMM0ZTnEBh8fO7OTuWrtFtTwxGMvnirAVjcrjfZeJTsU2uYxkTTWe7u?=
 =?us-ascii?Q?TppQwFAq5jJQ51eGPydAtzhi+OYpmugH3f+BBPFmXMhNEwXJVWDcFC+BWpvP?=
 =?us-ascii?Q?wlLWXVhwtwo8iyBhWE+8+HV+fuFYTd8J6zvRqfmhJeEmnNHWVQZzZslrJqEa?=
 =?us-ascii?Q?ByPZIFl8tbQGFu4nDkq3LfKqd3Sn5lhNaYtShAf1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6763.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f5e17cb-d39b-4f55-becb-08db47caf50a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 09:28:42.2824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VR/zOaYzwVlCQqQCghB6z+XTs+1admrcxH9w9SmnH+gmxQcnG011Qfj71v1GR4HWHYTgD2EEFhSBxuIV0PT3yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4881
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> VFIO_DEVICE_PCI_HOT_RESET requires user to pass an array of group fds to
> prove that it owns all devices affected by resetting the calling device. =
While for
> cdev devices, user can use an iommufd-based ownership checking model and
> invoke VFIO_DEVICE_PCI_HOT_RESET with a zero-length fd array.
>=20
> This series first creates iommufd_access for noiommu devices to fill the =
gap for
> adding iommufd-based ownership checking model, then extends
> VFIO_DEVICE_GET_PCI_HOT_RESET_INFO to check ownership and return the
> check result and the devid of affected devices to user. In the end, exten=
ds the
> VFIO_DEVICE_PCI_HOT_RESET to accept zero-length fd array for hot-reset wi=
th
> cdev devices.
>=20
> The new hot reset method and updated _INFO ioctl are tested with the belo=
w
> qemu:
>=20
> https://github.com/yiliu1765/qemu/tree/iommufd_rfcv4.mig.reset.v4_var3
> (requires to test with the cdev kernel)
>=20

Tested NIC passthrough on Intel platform.
Result looks good hence,
Tested-by: Yanting Jiang <yanting.jiang@intel.com>

Thanks,
Yanting

