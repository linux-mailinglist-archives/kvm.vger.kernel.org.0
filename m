Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B44E6B35BF
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 05:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjCJEuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 23:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCJEur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 23:50:47 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C7F105F1D;
        Thu,  9 Mar 2023 20:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678423845; x=1709959845;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wgeYoz/CKfmSWD0Jeeh+OhgBF9QU5Lq87TeaNT94/qE=;
  b=UdD5UJdRHHnFIWh2lS+F7zPOoNv5CCqtYZLsB+8kn5jINr0dBZYnzjEz
   hfVKrQaOWQQy05Ps6zMxy6hGtx5OB1oRKXyY2iDukcoanozEhrZFpDS2U
   LOhdeebBgNlu3GZVsO6bZS9HuqboAo3QMy10qohmhGZgmOLtHK4NrczbZ
   A/Swln2ABHrb/DiGfaRDyzoxOuLAPYrYQM1rmWXQN78tDSRee5JceWP2N
   KSxvyA09HqKYSYFNLK6oB/IWjiyOPXTIr2c2nhoM+2JGMctpq5hcngUxQ
   iqZJdulfCdBmulFV7kavrOpAopZcFUyqt1qJF2IvZq6rk5eRvJ7ejtvTV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="338200206"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="338200206"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 20:50:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="923535584"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="923535584"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 09 Mar 2023 20:50:44 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 20:50:43 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 9 Mar 2023 20:50:43 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 9 Mar 2023 20:50:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2NiOpWaOn3Ny7DtJV19UrVa/uc2VRKwBRZpyphBQBsVByy8sm6cbKmDnfJs5ApKoLgtYC3CYTLNqExOihMYYaiQnu2B+LoizY2CVP1rwa6RQGrmXRgAANWY7vj0HNFlYzYqCbjNh+CvKLPJhJe+iucTskDLXIxV2TrzNJQn7IFrnqIIp2UyOiHaAyWXqu4mLG1cTj9kEsT+wcGxPlYekQgcA5Ni6mp/2SRrUWDyByF0HFifWyC9ZFotiB998b2XulkQy9MwNGa0EbtNJlH8Ng6Mj23V1I1dJo5QHd1jkB4xE6/UBINa3ptkpeoMIsN0AleJeKI9Niu1LfGGcYS4VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61NlAAZyAqizPrsDaDjAQAz0JQa4Ew2Hz42Pbl/Xcsg=;
 b=KDqvbAu7E/Gz3PTQpNrG7Ci7FwMCiQQHOFESmqO+6T7w9ZYxetG7nMZt/k4I46qCkBXztKOJUw7fBhkqimQ0E0ecem6vSIU8kugo5/ixsns9xzUcDw0DgCJGB/zIoVuXeAs1RZxwpY6TrPgFn2xPnlk4MGK0EiXrrJ3nV2IizmDECBnN11msIAqjPes3ctA1OHARCHULUpIDKnFVx629b35II6WaZBcVqnl9CXA9I56kU7xtdCIuAAHV7g9oRs+YBFHpXfuELkbUQrwtgdqMwWYhl1xxtoiuAHWqcEd4UAqsweLtT1cdohPm+d2gZ7piwiExV3+ciMpBF/l4/IEiKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA3PR11MB8075.namprd11.prod.outlook.com (2603:10b6:806:303::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Fri, 10 Mar
 2023 04:50:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 04:50:41 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v6 07/24] vfio: Block device access via device fd until
 device is opened
Thread-Topic: [PATCH v6 07/24] vfio: Block device access via device fd until
 device is opened
Thread-Index: AQHZUcIAj/95JiMxkkaKE0ynxQt4oa7zc/PA
Date:   Fri, 10 Mar 2023 04:50:40 +0000
Message-ID: <BN9PR11MB5276066BC3C07113500ACE3D8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-8-yi.l.liu@intel.com>
In-Reply-To: <20230308132903.465159-8-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA3PR11MB8075:EE_
x-ms-office365-filtering-correlation-id: d429a91b-2d47-48a8-3792-08db2122fff0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ge4fVdyBSMoySUFfu+ofpKo/qQMHLcJ5IBYsf3dy6w1z8LQcAo7GL0AwvFGcY9XhlGKOYPM2UlxJdhxGCmq6TjxP5pRSs3uBmL/vb9jHTksgIV3NhN77vRgopN5jeUm+AJC9pqO9lA2rNwBVuJHcFx367L1YkFEpf9uQVHndFa5/qmiBwa3Qzs1xmtCKfIHVaGgY69WykeAJ7AjBMlb/VzENGRhurMV02oW6Ie37CO3b7vguNxwU0ZWvKm48iWzi3ipwsDaiJPE0Aw5uvxciNNK5GdpF9/Hw0+SXNjjZEJqQza6aZ9UMoWXcSm5vbnZ3KIvUg4toRgJXkTXDioHgTzF8+2L2JEy6Lkp7bOl9BzzGfv37vWXGG+FfXAjun2A49JHlbHND50j8WV1ssejiPGTlJFESjqp4w5zsr+mUH5MlvaWbnp7VfWQm/4T31BCpHXHgVJNrAmzAShl9SJKhu6KK9wtt/oTzSRf3jBVC5yXKp4LkucmYzLpgS63kBYc/yHnAnAN224LAHJPoi8lcIyDwG69IG3SGwPPxpa65Pzy+IKb2XI72DkHfaHIQhL+d7r3A2gJzrd7wsfSfXMV9+YR2FAUAHXOcCqHelKHIXbJ7Cni8DI9Tn4K39kHMWqNVBM+ToQnMqpOWfRsRftRTnZvggqeUWcq0huA/lyROHE9YlU2aXXhQq9TY/0p98/3b3nB2UocpjoAtIYuxXmIIzw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(346002)(136003)(39860400002)(376002)(451199018)(478600001)(82960400001)(83380400001)(33656002)(54906003)(55016003)(4744005)(122000001)(316002)(38100700002)(38070700005)(52536014)(110136005)(26005)(71200400001)(9686003)(186003)(7696005)(6506007)(7416002)(5660300002)(66556008)(4326008)(8936002)(76116006)(64756008)(66476007)(2906002)(41300700001)(66446008)(8676002)(66946007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?usq/S2CIl4qhAj2hweBXwnRRjPQ7DnuhZcvjVAZXsgfEY3VspQjQZNLkroDh?=
 =?us-ascii?Q?yJN1Lw/v5JIVlzgSvdObNlffkIizE8qdh+XQ815Ns5A9BSI+k54Rm8PdBShr?=
 =?us-ascii?Q?F/3hrcg4QlPoFRTQlXIQIyuDwLQk1N08Hi8SoIOsC2bXrBgtduRxIPUPLpFA?=
 =?us-ascii?Q?vORzE3kZJd+/CV49tQIr6T1ecscoaGYBuU58gtt99c0pHUvV7Jg/y+sOBLr8?=
 =?us-ascii?Q?ALRDt8FwxPXRUGu8HrhN1kUIsvzJB5W8vhIAe4C2wWmssS0S1vNo7LbXDzWd?=
 =?us-ascii?Q?WCePAJQ+qqH9MjxIwJtkM+TKHpjx9r6j8B0QcYEK1wMex0AaafcVEvH+ww+v?=
 =?us-ascii?Q?HEpDirWXzknn7CbLLLXa2lxFBYJs1fH1iAYcOspiSo2afRvMdhqRcggN8sdG?=
 =?us-ascii?Q?ge5JoZKiDJ0cWMzuTqVSFBs9gjpXxlSVcbRcvbepA/q1NE9p0l7oGvNUkuAP?=
 =?us-ascii?Q?9NZ3qIhS4k8HdR23kvfzpF9uJ4ByhC0IhUxcf7uzdsp7pa7YJ/g+bjN9tNjo?=
 =?us-ascii?Q?ZX4Xy9viDxjUTI1RNXBaiHwLxCYekgvJXc7cAH0Yr3WNSO4mzQWLlFfFAvKO?=
 =?us-ascii?Q?Q1UjWM67lSwF0WCzTfjW0EG3dq+9xuFvU3CZbSRR57Y1wlCB7NYEsNwVxtik?=
 =?us-ascii?Q?CvJm/QwG4usc9GaO+x+wjrg0rs+jGcXNcWA+jrF5A8jp3x0/0KB8NKQNWlE6?=
 =?us-ascii?Q?6E44aaUuq/j5u7424VE3pEttvz/W2hFpaIdSn0mxkcJAKbEKSTrJ8nWCmyG/?=
 =?us-ascii?Q?D4MYpR9oBAMRnbJ+vceZUO3RDEGW47+HxrdoK0q7iv/Pg1ecffnaZBfQbpiA?=
 =?us-ascii?Q?XBfGLGGLgSYGYBi+rqMuaxvuocXsJuSAgr2A6cjbaArxB730Nr4Jm05RUyGj?=
 =?us-ascii?Q?0yL3v00OEZ91BWR+u2t1O4mddSLzPVFR5zf2RLHRHVZA55mDlzbyLYLzl1u0?=
 =?us-ascii?Q?j7LUqtZF39k5F3zO14vuZoJNQl1wFbIxA/TT4UfOQ7vuA8XFif/j1wL1M0Yj?=
 =?us-ascii?Q?biLg530dbrUwFW6w+sN1KtQ51NgSNpbCWfFK+yUFjpdVGyNXCC2zL5Y3TPTP?=
 =?us-ascii?Q?shzFnRQxtGOuO0WHn6n3dCnC+JXmO+/9xUhrfdWI+M49sKoyvzjdNK0QUsLd?=
 =?us-ascii?Q?RMe80oCAsncXEMvWSkWSAyeP/l9ISfnlyktnRbpD+7+BlyMGZEsRaYzjYYRe?=
 =?us-ascii?Q?+G3wftEQCHOq3K6G69ySzDdNuBhaZl7oYij43tLR52oPwG9oxCAjSCjog1Z5?=
 =?us-ascii?Q?t3xhTQ2Y4jiNar/SQCdD7KJIKJsXoRK4a9MMUHHgDlWmLghAadmbtihVEYYs?=
 =?us-ascii?Q?pJKFFqP6qOZhhuOAokGtLt4dl+Cdlvj5PvU2sXiQ6tFyAUBHd3qr7SszCmrN?=
 =?us-ascii?Q?YcTs06TVkoWPN9y5FxmHqXeoFDg7Z30OdDAdU9YNOY7uLTzqd4ju8HWMzXv8?=
 =?us-ascii?Q?dEjnOXGIMh+3ZHibh/Q/+cqJM2Gv9BHAjpgo4U04sjsnWot6f6HpyPPfkn0s?=
 =?us-ascii?Q?nQ7uupjR+OLfHK48Wohe+wg4VwCs3tt3BQ6h3pvsmgVAZL6tlMS/302rVWle?=
 =?us-ascii?Q?9ACHvsHyWC9WWgt8Q7V9DWGZbEGjz0Qw9eN/RSUe?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d429a91b-2d47-48a8-3792-08db2122fff0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 04:50:40.9127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gAitSadvruYLkL9VGOKhrYdK418vXj4nEAIaE1bBWL7kOOC9Yf0ENkmNbu0r26+7tjB3B9l7GX9UCWzxJxNDkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8075
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, March 8, 2023 9:29 PM
>
> @@ -1114,6 +1114,10 @@ static long vfio_device_fops_unl_ioctl(struct file
> *filep,
>  	struct vfio_device *device =3D df->device;
>  	int ret;
>=20
> +	/* Paired with smp_store_release() in vfio_device_group_open() */
> +	if (!smp_load_acquire(&df->access_granted))
> +		return -EINVAL;
> +

/* Paired with smp_store_release() right after vfio_device_open() is called=
 */
