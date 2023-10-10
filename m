Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC457BF644
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjJJImW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjJJImV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:42:21 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5085CA9;
        Tue, 10 Oct 2023 01:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696927340; x=1728463340;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/gFCE4Qd65omaVfzD7Nz+2xDxDa3WXvUJYP+a3au63M=;
  b=c8b8QZJeHdZmiZ3jJikrmwK5Ny85kI0mMIloFneROYdq9ifsi40xHUfp
   RypgwZx+r6h29tge9aH3ek/zxQomRtdIxVKZv36l3ALBelnnOTcNAsWr9
   foNKZ+AgybzdwvNH2S8GvdVdMd0CAluGnzy/WRTCwzrjsM+MjUDXnTiff
   fFCJrQpKbJv8LKmWX1EVHm+L2tIxS+UURIMlqy8/Vohs/WlZ0rWETqL+n
   +9IKaCq7OEZtiHdPPyIPNnaTkHLYbfkotoBRqMEWa6t9P+6WBQShSIat8
   XGpwQpDv2oLh9tI4ARrQTV/h4AChKFmwZQ4+Q2pB677C/sMxT75ydbrnR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="387178549"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="387178549"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:42:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="730003030"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="730003030"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Oct 2023 01:42:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 10 Oct 2023 01:42:18 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 10 Oct 2023 01:42:18 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 10 Oct 2023 01:42:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4GOslGZW3sDvaZqSfiMOql1nmKw2R5UyLUeu/8xAbJmNhLc+Cassc/3mxM7A/34N5Ifjf3GhBQwatfuuDEcZJNn+qTaUOEAdQiZo4i6PNYwemAXQn7PEKyxOg/o1D1IhZZMFhop1/8PWFr2dV60/CBOL9Oq0efAI89Gk9xxU4qN+T1qkXo2S4I6hEyBnUiwNARaWRFTbHKTMOqCrJmfkyHpqmgT1L5n2a83YGAQkJDBRLiiVwNWsGmdHyxIZFrKqX+Fe205a77XSogXhfJzXfbuCkaPnM2/IEKtBoaZo4HNiBNbnPov4QH3l3q6DVc27Zv15Q1FqgMkyLorYK1+Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/gFCE4Qd65omaVfzD7Nz+2xDxDa3WXvUJYP+a3au63M=;
 b=LCEflUw3MQXuvs9nYuLf0h+ykQSqhBT85MYiu+RCs/QBAfLCKFjyb84WpuJMINQkXPUg2fliVRp+r0SjHeJdwHmnnttBLQr0qFHe/AgTnEPejH0+HVw1Cyr2kHaZ7V6nlwdAP2nboVqN3drklTI3lf1/p1tCcGu6Eo4wc4ZXcZFy5wAHrDYjHDquxc2KLGX/inFuSXQtknSX4nmOwbcNH7/m+RI6HNZngxyZ320XiYCbc4SZWbSEB9L7XgulHaz2ajX2hC0O17xfhmk0o3NJS9jLoZ+acJ5O+4UXAd/p3BkF3fusGQUcEbVtMamMdf05IRoGOSz5lIip/aDMnsSEgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH8PR11MB6973.namprd11.prod.outlook.com (2603:10b6:510:226::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Tue, 10 Oct
 2023 08:42:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6863.032; Tue, 10 Oct 2023
 08:42:13 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "ankita@nvidia.com" <ankita@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
CC:     "aniketa@nvidia.com" <aniketa@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "targupta@nvidia.com" <targupta@nvidia.com>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>,
        "Currid, Andy" <acurrid@nvidia.com>,
        "apopple@nvidia.com" <apopple@nvidia.com>,
        "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
        "danw@nvidia.com" <danw@nvidia.com>,
        "anuaggarwal@nvidia.com" <anuaggarwal@nvidia.com>,
        "dnigam@nvidia.com" <dnigam@nvidia.com>,
        "udhoke@nvidia.com" <udhoke@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v11 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v11 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Thread-Index: AQHZ+VwgDWGk0VCFcUeltplt5s48drBCtrFA
Date:   Tue, 10 Oct 2023 08:42:13 +0000
Message-ID: <BN9PR11MB52762EE10CBBDF8AB98A53788CCDA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231007202254.30385-1-ankita@nvidia.com>
In-Reply-To: <20231007202254.30385-1-ankita@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH8PR11MB6973:EE_
x-ms-office365-filtering-correlation-id: 3f87de3c-c21c-485b-84be-08dbc96cccda
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H9raAZSBzr8pLAHBxC88kAwSDpMFbEKhJ0zYFA7OgduXc1guKTppE5Nbmc+WT4G1FkPhMzeEvDU+7Jjr83EjrkVpGx6ZtUmNuzr8TwT2fVwKz+uapF8lH89fKUIOYbJV0S3pEQPBuh2GcSWdTufCza5zNm1/EpE2NngUBuIA2LiTI3UT4uGcHLefZWJTwYH2NWBsZJAevdNSyuqLeZ/ZeWR5N3TQ7d3lRdoOoEmig/B+aY1wIi9sPxSHMo6sXkkxpFxtoMdOSCGpMndff/wb5E0YCoZZXxlAbj0qbIMIxxUUiWVubAqWwdLv2cbyTd/ar9Kg1rv38VZkMhELh0Y72XuhnBjOiMOqj6sZKmYslSbDjqLeSrL+H71AvPO0PkIPVMP8rJbASMt8OzSyy0XCnfkutxwCodDyphrBQw9nuVHPoN/v36MUlIVMHrIsTwv+sTAEGAICCDU8fyUHuvR2tcVMvJQbqmgYXbMOas4mE66/MhFEGDs05oUebus4pJhKEUzqDuABYcsb0yrI0+M5JSaCNlxZF5Vv41q7aFd8rKGEVsiye+2IqBgMNk6WtPqPRaeDcF3N7qfbYNzkPHZrY6zHpQRsY12gL7okRC5IAwOYIVrXGu/xzAkW1WM9jtdo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(346002)(39860400002)(376002)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(110136005)(316002)(66476007)(66556008)(66446008)(66946007)(64756008)(54906003)(38100700002)(41300700001)(5660300002)(7416002)(8936002)(4326008)(52536014)(76116006)(8676002)(4744005)(33656002)(86362001)(83380400001)(38070700005)(7696005)(6506007)(9686003)(122000001)(2906002)(71200400001)(55016003)(26005)(82960400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SYB1oSVUfGUsyJd2aCfi0tSKoV+bHJGX+3l3gfgPh7jDdHQjOCMqm+VfZx/u?=
 =?us-ascii?Q?3KXG33RRzx+O1c3zWyd+rBrpTp50vdbCh4h4fAxLSfyxuSQ9/5wE4yntOqy1?=
 =?us-ascii?Q?W9Bpw8dpdpGniJHeMmEEP65Lm8cvxltJKnDpEMMU6mStKQucprRMBn1xr5l/?=
 =?us-ascii?Q?YyVvOdivphg00FpNjnQPhL0OcC3A80Ys3DDnvVFLJUzprqtgmHTGc8MQ/pOO?=
 =?us-ascii?Q?1qqraP1QAU0qiu3fR9sr3/LZzPPI0n38T8VV/e7YSBbTKcLBhukRpXhm33Kg?=
 =?us-ascii?Q?z9Iz09sV81dMkVGxLOqh/xJ9AxuOe6MGdVN0fAvS3b9vjukxDwNZPeOMXl2d?=
 =?us-ascii?Q?SBlRs2gZiWZOj3y34tvfoucpUVT5HucDn1Wrbkm/mqaqWrs8390GVaquF6SO?=
 =?us-ascii?Q?cQFe71VPK06wumq45rMMOQVfV73vYLHLTu7ff9agGRNWuOynd20yLrc0vZUl?=
 =?us-ascii?Q?vq8GSeqXWf+XxGZnk/jkJJUz2AcyU8dF5lfuGUjMgt2U/PGVa91j/NTh+IVN?=
 =?us-ascii?Q?Zx920FIi24ytudJPsLHl7LZgOWfqz1D4KQugxJmvJXklnv9zpIZexNXUI4Es?=
 =?us-ascii?Q?7o9krK+X5U/xBWG+IqBwg9M4WlPwSKiC06R8EsvrIN39GaZ9r7knnjXqtyjd?=
 =?us-ascii?Q?mF9Lz2/MdVwIJ3ohf2FRtA3BWfAbnbN1Ytos7Fc0KpqzMjh5nqiMzixtyZHl?=
 =?us-ascii?Q?rjeGcrNRhrGKZh8Q75T2ZXi3aByCQnx2ZasKr7cttqL+YTugrCiANHkE3Aun?=
 =?us-ascii?Q?1vkj0OTiJwBXgaNrpBP6ijpzg/Iv3edcfEblimyUFdUQpYNEiclRu2o+i6Xq?=
 =?us-ascii?Q?IlgNkMPeE1dglQ/L7ItXq+8VQeiHkJAWE85308JOzmerZHBYqfmZkR3enn0h?=
 =?us-ascii?Q?eepbta8P3X6oNz13wB3refLtkEv2WZfGqZ4h9SZMyz29qrMIMI1IryAUSh3w?=
 =?us-ascii?Q?7ZmirwStV/Dp83W/le4KE+A+mE45rLbSpLJlk5bjjQXqFaHJCQboRCxHATer?=
 =?us-ascii?Q?Ob27VmLNrxqcshdWqKY5mmzIKl/jfDDu39xyKrQxBIMYYbUpUhFwBajkMPNg?=
 =?us-ascii?Q?xzUUENFqMFMQgH5921F38M9LbTCOmI35yyzRGep8h6NcaVm5xtyuIiKmUuNC?=
 =?us-ascii?Q?mzSD4yME4GYVZIO+RxwQOEzC1FBtW8FDf/KP0WwzstT4ajG7tbzBm6xWjhdK?=
 =?us-ascii?Q?gLWML0yd+1+icgkT7k2zEYt/OzOgc4q/YuPatbAs8Jy6YZ9wRk5bxLDFdD1m?=
 =?us-ascii?Q?+jk690BmlpBkSg9EAQqy1ocveVFVblZ9B5dKr0LJIDo3LOtE8S9iZLoN0lr3?=
 =?us-ascii?Q?1ItvCgK4oeN5MCirxXSYKo6vdOsyQI7dqb03rtBNe1YHzdrtRghR1XfOOiMU?=
 =?us-ascii?Q?r9LjoQUsGB8jictdOkh4aXoZXB6Mxp/suQysmlJIcWq//ASrbjoZFCgQyH53?=
 =?us-ascii?Q?IBjQnNIfvQckrvc9lV/lemk2s8a9mJfyEtszffeVdpsPwH8whcrtneFbctfU?=
 =?us-ascii?Q?h0Kx44GxVMG7FbH+gqtzXE4J3ny6/J5/cqn9etDj/1ePqvgCMvoWMTc6fUmc?=
 =?us-ascii?Q?CPw8q64YaP+yoBg+3jJ3j/RqdDtsDcCY0R1KW8h5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f87de3c-c21c-485b-84be-08dbc96cccda
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2023 08:42:13.3342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bOXiclflphoJNqTXuSCeutTnfKybfXGNQOW28CRARdt0NGd36H5Lme3soedt2T5IRXr6H4whLRYeDtzMpDtSWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6973
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: ankita@nvidia.com <ankita@nvidia.com>
> Sent: Sunday, October 8, 2023 4:23 AM
>=20
> PCI BAR are aligned to the power-of-2, but the actual memory on the
> device may not. A read or write access to the physical address from the
> last device PFN up to the next power-of-2 aligned physical address
> results in reading ~0 and dropped writes.
>=20

my question to v10 was not answered. posted again:
--
Though the variant driver emulates the access to the offset beyond
the available memory size, how does the userspace driver or the guest
learn to know the actual size and avoid using the invalid hole to hold
valid data?
