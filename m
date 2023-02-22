Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DB369EF7F
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 08:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjBVHju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 02:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbjBVHjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 02:39:49 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA4C34C02;
        Tue, 21 Feb 2023 23:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677051588; x=1708587588;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L6bKBxHjHS5sCSCSAwNJZIC6rwhNFyee5tEDSPRs/bM=;
  b=i0rcRCaJ7IzbQiNj+Ba1AKUmZFAr0kXZ5XVJKE4zetav1cRv3/rdO3Rz
   BUmHHTv1AxyzevMXV3bGZLZ1je2erG/nQG4ahShO1WKcbJCh6dj7l0J/V
   cRMcD0kC22sOKyghkbk17AJ5B90Ff6oVNgLQj2J1dMoE+OmAxiM1jygqu
   fG+bQiKHaNO8DU9XViGnAACAiCNkOQccAAx8g+adN/3hDz+b9Gkjyyf5g
   KlWTjczyf8XczEShJxPl6UleVpoiTTWxwYVxb9n2BGoHF5pr/ZQFMcx3z
   HVohV5iBZJL2JcI9Zs7gfaA6aEmHcIN7KjF4lZ3z4vfZyionVvz1IH+Ph
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="335055790"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="335055790"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 23:39:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="702303056"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="702303056"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 21 Feb 2023 23:39:47 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 23:39:46 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 23:39:46 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 23:39:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlBYtrNQEZrX8S30T64PKUtIaItmtPM4iqjUNx49/KSeOXqJYf7+ICnwaUenL1xB4ySK0VYksHDRe/pqUuHatKsggcU1/I2vkkiOzuCHRRXqZ3gEtbpPgg4jxHxySM50tanslZOvPQS0vRSs1GYluvYR3xjSuiaCR2RKiQuIBE9eYKOTisxG40bK1VOi+7xN19f67SxtAqWgi+A05DhPCd4/DEhkZFevgBn8A/0s99Y2msa1PQ7cKCQI009zPAEJRhyId6iXM2MzYpg9FT1u2hdLfL4HgCTwtJi5OF04mWU9kRs/nz2O3AgkvwXBbCjRV/O4ZvXcQR1yS6EnSSeN6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yEwFmKyjO/nbIGHj5LX59TMWCBjG5DdGCj7sn61CmbI=;
 b=gOsfIUqhrXjDBv+uzdpAF/COc5HEyr6FYe1ZAqJPtNDcbCqVzaFc8+6r4XI2OPVHRQJBvZrpAmU1MEjjgXdeou6jKCHrThSSQU6xbqJ/MZPsy/gSIVan/BcL8gz55mqwV/tmI1Qcm7TkGYdQlOttBH8mglRCDmG/xUL/xDKE63VYAowiQHxAeXeN20OABUTSm90VIQyecVJc0H8XScEcPDlNfXmnZ0GigaB+lGpyyb92QpqFzzMScY2D8b0CQPiPsYcJ0MEssRckUal2CmPdEgStOWwtAJzWuemFpZdpjtF6INdo9jRaEkIJMJs6XlyTZEK7iZ5qE77TnQEeKMDKhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by SN7PR11MB6749.namprd11.prod.outlook.com (2603:10b6:806:267::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 07:39:44 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f%8]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 07:39:44 +0000
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
Subject: RE: [PATCH v4 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v4 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZRadl/ZvSXgcxQUO7N/jWnT1di67alMhA
Date:   Wed, 22 Feb 2023 07:39:44 +0000
Message-ID: <BL1PR11MB5271AB3735F7A783C2871DB88CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-17-yi.l.liu@intel.com>
In-Reply-To: <20230221034812.138051-17-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|SN7PR11MB6749:EE_
x-ms-office365-filtering-correlation-id: de62fe4a-624a-489c-4dd6-08db14a7f73e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1fsWvn5PfsskXhtOWfb3asvRYK7WOsLfC7t7Z+CqC+sL0UTBaOrD/dMlOwE0MFvWsI1up7NuUyxsUaPg+d8Rx0+F7oKYWIxKw7pa2JWs35TFIWcbfRWe3PEHqn6DCGbWfMFhLBTeasqjtGFuZIbx1qANL83goQJvtWEEgokzncop7WafPIK9LlmQqOFjBCg1wEpzLMe4ub50jNF1QDgk9F1VASWj3CG+mvgJrXE36TlYfZEmCKQLcYQMUgh8xTgqEvL8O3armgmFXmBSpJeBTRYKdztUcZvpmO9aRyZiUdUje98Oubi6vguapwdlCbEJrSZWTAaiMgMXkbo/JHMJDxFIrHcuBbRA/KyfMIgphdNNp0IV1w0yhX6uWK1LhxroHyFwSWnN5vGg30TJ+dO+LbN5fZ6K0vHmlkXYgikSfrPVeRAwcmjEJfFAW+ePq3o5zp9qgFtk2eIwbWWTni6+Em+5IecRWiZzAUDK21CuRhdF9R26FAMI2eg9pvmunnga+cgKfME/P+usMHCcLJKe93EnNgbmm2gyXAudPFhUqL5XXkvPbaiLGzRvZ5pvnSd6u+ebnFsaw0dM0r7HM227AfLdwQ6xRYRWVyLqDGiHnZwaV9j92cZJ6wXSVcFJgFRljFyxZuOO0sHPy0FDNN77quIgJ6TyDN5yLWBWU0EMw5n+PfomNu9hMJZJfrBxZw5Nj2xV/8QMqey1cPoLM44KnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(376002)(366004)(396003)(346002)(451199018)(52536014)(2906002)(41300700001)(8936002)(5660300002)(4744005)(7416002)(8676002)(66556008)(66476007)(66446008)(66946007)(64756008)(76116006)(38100700002)(82960400001)(478600001)(122000001)(316002)(55016003)(54906003)(110136005)(71200400001)(38070700005)(7696005)(4326008)(33656002)(83380400001)(86362001)(9686003)(186003)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?slXN+WwqAEmxc74Kb5A+5+bRMjC8q/9J1wGUR6u45QjBR+wMTSlRtXvepS+3?=
 =?us-ascii?Q?y8s5vBIxi+73QS0bIU2cRx787t9OrHP3D0pzkbv9HslhiwTIWD7Ca0PH3PmL?=
 =?us-ascii?Q?QeXs1uxS9pK76BL8qo45kcHo9qTkGqFKY+mGYysa80vItAAmyDG9rkDOGAqW?=
 =?us-ascii?Q?vS9JhiZSevNilaF9es48wxch1S54Yt6ydPeR9Fp1ty26FhXl0bi+jbZm3w7H?=
 =?us-ascii?Q?TJvHnmjG770ZI4F7L+wDcB01oQNJMCDWvhtWyiHJyb3bmB203KYSSCQqfjTm?=
 =?us-ascii?Q?sHyobaQawnNmLMkRNqZfuZQATScnOljVNwoCAjwnBhujFSK9TQIQj+Bx+3gZ?=
 =?us-ascii?Q?5N/HOIMdwVs5bdIJxvgheRNcXMXlDzYq5QbP88j5afuDGHHXR0q/Qc5Evkcn?=
 =?us-ascii?Q?avb9HREUHD4eYrndAJRdKlYqZyBql9YPFYJjuUDpsZrdW9GPYeFSE8VgM48S?=
 =?us-ascii?Q?KTYxqc0wboxLYGDgvH10djbFu2tEmrqkZwRCFdNuOMw7xu5jZhHGcIVZHWYz?=
 =?us-ascii?Q?N7jcj/RtcTG9xLu2ONI4JHnd2NtlPkxQQASWVPlZZ20gjan41n7U2jEl9ePl?=
 =?us-ascii?Q?c6nQYs8/9XTVvZWeiDit5dPYMrhhNSodAPTFEGSKaH2mBRH2KtXMMm1IO1yx?=
 =?us-ascii?Q?xBopBd/xZAL6PWTV9S6Lmi4jrtQQbi0vlIQk/hM+Ppj/CMzXuQhIl8JQMtX7?=
 =?us-ascii?Q?8ZWvUrmcIh5RSn0D/6SHADBSr57g7t3Mc5XotT+Jozr8WtbGFV/aSmtw6YYD?=
 =?us-ascii?Q?0zLd8xgQVIoxux6+ZYRSDlmu7qU5WOiFs7B1mQcSrhIm2cSbQ7kdnMFm0TBU?=
 =?us-ascii?Q?5VFAdbRWnPBSDbN0tBEuBJ4JzsrFA+lymp6GQwbneVE6I1HYXFgRXx+JWwjk?=
 =?us-ascii?Q?vPYcDnW5V6hpVrcntPcZetEX98fSpLpKiVBh4LazJI6mIkxAGFl9MQez8gID?=
 =?us-ascii?Q?bTVlyL5puNtNlky6AK5E5pjq27Vs5b0aLDpzebHecBt2HCeiortMYQDxnHdp?=
 =?us-ascii?Q?TWokNtSrvOllyHHWscIuFc+Rd4dGlFhQA1+/6OEkMaPNThjWB1jlN521mWTT?=
 =?us-ascii?Q?Z6ZvHM8C0Eh7BC5sPPWrP4pTez2gWgVwvZetC9udTBEnXUpDilDMhQcEsiK5?=
 =?us-ascii?Q?1MHkJ1mIRivF1dBBvRK0GlreAIFLyuRqZVExgLgfmQsfgU3Lktthua6KNAI6?=
 =?us-ascii?Q?cv/3csViEym5B6bWJkCXYQa22G4V7KA+A3ZNN6L+tdFk0s3dqRdmuTGsUzsK?=
 =?us-ascii?Q?BGiGeUW3lrY0/A6LD8dP9wOJUuPj/s+kVUfY1TsQfuG0gjDAU0UFREOEj2fF?=
 =?us-ascii?Q?uAl9yk44ZZSvOQr6BE45OCDh4WEceF9f+Pi9oObpikhr97U2dS3ND6th1+i2?=
 =?us-ascii?Q?LlFewyJZGe9WpSzZAwoXzDvH0FXqAqh893rZ1UR1F8wVtzsC+/p1lK79oWJ+?=
 =?us-ascii?Q?dn6OiQdufy6S9U3BotoRI5u9H+laAPRlMg/ppr9FIITaKjxyFRNRMUKsjNe9?=
 =?us-ascii?Q?mqDmYNUYeqAS6HrXEJkJZ460qU21qYx/J+uXTSnnvbqhK/F+X6+7E9PG70cG?=
 =?us-ascii?Q?P/UaL1XlO6ZzIc6e8rfLR6l6Ixz16zzIesePzfL/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de62fe4a-624a-489c-4dd6-08db14a7f73e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 07:39:44.2737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YxskPDHG0aNuIc/hbJ6uB6EAthq3WbpG6md/rCxqCuQ7nak1Kn0Pw8Ej+sO2E+Suz6zh/3dRcD74h67Ozkcfzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6749
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
> +
> +void vfio_device_cdev_close(struct vfio_device_file *df)
> +{
> +	struct vfio_device *device =3D df->device;
> +
> +	mutex_lock(&device->dev_set->lock);
> +	if (!smp_load_acquire(&df->access_granted)) {

there is no contention with another one changing this flag at this
point so directly accessing it is fine.

but actually should check device->open_count as v3 does. Otherwise
the last error on copy_to_user() in ioctl_bind_iommufd() simply returns
here given df->access_granted hasn't been set but .open_device()
has been completed.

