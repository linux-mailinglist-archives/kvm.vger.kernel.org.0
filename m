Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9156B63A277
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 09:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiK1IIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 03:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiK1IIj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 03:08:39 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B550140ED
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 00:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669622918; x=1701158918;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=u5j8o2cGr7YfRf+Lt0Fln29w2dO9CV6Kw0Ggc4HuvGk=;
  b=P5XGjJqs8RflDmXU/gGZYlXO3pm4QYZ2Np/kZad/hOdA70wJEJr8gFu2
   jU5pAYf6VCxG7diHtF/ENpLtyebYnnvk/hJuPxQ0RMwMu01nMdhNBe1T9
   SfRxGoIzqlJRTqCSiBPFWv3+/tDNJlzeDw8e6smIbK0kJOEJAsWmjqwXs
   MqqTbxa/hdn5Cj5jpAxrRvV07Cz9XO4ZxgAtrxrBT8YSgHRtFPczMZG9m
   2ZcjQ04w+WTcAvxfOdD6Jt5SoF/9+AJ/uRo3bvhxe9O1ub1mw0vyYNwM8
   K3Livu3yXtHLOJlSkQyrUrqn5y1LXEvOTT/pkxx5LmP56PVu4pfrmUwdv
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="294474199"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="294474199"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 00:08:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="711867926"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="711867926"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 28 Nov 2022 00:08:35 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 00:08:35 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 00:08:35 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 00:08:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBvZjoo70MF6mInNuoKf5ppOLZUlu74FVr6auq+TVbMgOEs/nOJkR4pnTXY1wSXjhj6QFFoYKFzlZYLp4Z9FQAOV8S4r1QGaqJ5rbd94uMLbUcTlgRqCOPYUdHxmFFEbWrla9jA0+3TE5BuOo4enbXnsSoCgJ2vxBMygfgU1JMK8BE4an7CpHNOmWE15qLFhjeVAsmmI7Jqc6+tbR3JmQazRVbr8x+V9TggQgfcYj3m3yUk3vDijPjpGGfBxIndhrIrl0geR/5WR5ZETO+sVnO6ZendwbO78aJGtNFGH6u/NrZUKAP3d1kAaTXH6cMl7GS2+/jNFhfQ/lv5kgS0QWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MY/oNXjxJsuh4/Yxuj0osKewsxjgBq5uhcSMrRgb6qA=;
 b=GFc/VwJtBHbTMu0hEOJ60rQ7RxRrjROrhN/O5Fu3m0+5/4mskqoERxvIMzPbt5oasjAgKfOti+i1RL73f0azibTwu3WAO2Fy36vk0LlSJQi8htcj2Be2NVHaB0hhPTcSujtRu01O7RFB21dEZgoDg8+R2gUF89Mz/wUcjpTp4ZIP+iB+Xky4sunUqOAGg+B9wSK9A8rYZHQEpuULHVdwiK3lZhZFyH5JvYq9P7Xj58sKI1tnivzwlHOJaah6YV+pn5MGCzs2SaB/8ohdV6AIK+P0rJoxo98LFkLz2cfxYfdhvZEuWA1OrwRtVstZdXKRcmlPtva1tFYPYXJRIV1Spw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6499.namprd11.prod.outlook.com (2603:10b6:510:1f0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 08:08:32 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%9]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 08:08:32 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC v2 03/11] vfio: Set device->group in helper function
Thread-Topic: [RFC v2 03/11] vfio: Set device->group in helper function
Thread-Index: AQHZAAAdAKOnfng01kKzW8cL4bGI265T/ilQ
Date:   Mon, 28 Nov 2022 08:08:32 +0000
Message-ID: <BN9PR11MB52768F967E34C3BE70AA0FCD8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-4-yi.l.liu@intel.com>
In-Reply-To: <20221124122702.26507-4-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6499:EE_
x-ms-office365-filtering-correlation-id: c4339be5-e834-464c-93b5-08dad117bde8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x9AhY0JziR6cKAEOhThCbfQGXyhnRNEso46aQ4bByVXHGYyj0FO1zblrJZR6uc2tDy+xW37lQZKNBn7RlbOnsuo4QHYi/kFvmAXLxSfyCRZu2RHMF5PQzxy1nwfDUEXDy8NSV8HXIpt3qydFmQS8xHMX6QkEhXOk15qBwJB6k9ZC7pV6eU5je/J+zjbtK75Mp7KqiSP24tQw1gb27kmm+VlCkkOc+z1JEbBmEkI56WKk+VUEKhvrXVbKnOgTIrVQ0tEVg5PZA0Lrt0Zre1XJ7c96Pdr3rYGwUIY8ZgM3OVnt6DCBN6sZPi4OHrmujuLC6mOx5RTLR8XMVJwT7LVxlA9BTD94EFRR3HKHi21LBGNQ5Er1E+VYWLRbWyhl5jGfIr7yHcyb2R9MIOx89u90IVZSWJM4PJLO+nDbSf63b+juvsXxwSRyT/coKVZ/XB3/sL1qPusS/Uxk6d/bttpWfO6Y1okYsLjXEOjCwB/haeTPvonH9Rkfr4FYobQ8Rjakjs+wAzI0WW+JfC7QuoTXFmd9YcE6rCn5Lap4wC4fsdwHapjHenxF/FMlf6+FaJDn4BF5o2amdTc6LZdka+guw4qNAzpDzX58U8Ix5wiaWcah1rwlar+9xiVLp0FVS7Kz8wNxgjwRYVTxsb7A/IY0UbXNChyhqdOx54tIRhhEsZSQf0Si343IHedFnV4O37xeJTjJ4jOW8pgiqiZbCWQShA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(366004)(396003)(136003)(451199015)(82960400001)(71200400001)(122000001)(26005)(478600001)(9686003)(38100700002)(7696005)(6506007)(41300700001)(76116006)(66476007)(66946007)(66446008)(64756008)(8676002)(66556008)(33656002)(86362001)(4326008)(38070700005)(4744005)(110136005)(316002)(55016003)(54906003)(52536014)(5660300002)(8936002)(186003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cbU5dEAvLw/oEShEKtuSjXuZXkX9bRco/6Z24Z5nyq4WTNLo0xeWCv1aOgHl?=
 =?us-ascii?Q?cixsvlnDw1TGF6EpZrsy8wMORMjYQ8AtP+VdNwytSfrs8f5CeJu0VBpTRM7N?=
 =?us-ascii?Q?kZfvH56PJhaBrzxFDNemdU6gOsQWfp6rAnDnBiIP66hej/zjAsfpxLLV9Bmd?=
 =?us-ascii?Q?NvcRtWzB3/tmz2V2G3IMEvS/0w6OymYgWXLltMbAa1avGAofod2+6dUefzA9?=
 =?us-ascii?Q?r/2EmxWwSztydIQIFWkjSwxu6KwDimTyHNPwtH9fLfVs6HFfgns1GOQeKoGm?=
 =?us-ascii?Q?OfBrh3z2nc447NHzOlm6zcnFEb0sz14+b2h/NIGYz8zPgApmooiz54DKbwgv?=
 =?us-ascii?Q?PuQ0rutS38JRif+7R9rsHFh4RiNhAJ2MhzRC6+Dr0jjqPWhWVF4YiYJCzWlp?=
 =?us-ascii?Q?qu8r8POz02Z493TwzvfVRw9KNPVxBd+4HhjDd6B4MueVeEpdnLJp26cfPZIh?=
 =?us-ascii?Q?bV0emeDGXjRZ2RMVMK+Xt4EV7cPw0cs1Nu9b8lKy5OmtwjtN7mpcqT89H20y?=
 =?us-ascii?Q?z8nrKRWIsH87TxV084FukcoTDeAYVXnAuQfWBaM79Y83Z8maRHoCL9Z9Tlz7?=
 =?us-ascii?Q?/e74cspU4q5v5H0mQbXroZyYxCEyNu9pN46pTDBuGetZFdyVdosBBcq04kg8?=
 =?us-ascii?Q?RK8xNcwJGAdKHgLY4EPdFvXNXTERl7IhItkpHICfAQEo6GmwyzRRU4Grmgo8?=
 =?us-ascii?Q?+Xbe4V4Mgo1RMFK70FFtILJxwSqI0re5p5weKv2SbRg7/BwYIQSx3C0Gmwnw?=
 =?us-ascii?Q?9oKtNIcGsPc1a4+WEofsyE8lpmxy3SfsOQiM9PJH+Ns9tUlv6b1u/XKTGjne?=
 =?us-ascii?Q?lETuo0wTfP6cfI1pwez/HJ0lISyQT+Gyqu7sW+vFOsiAtMBs2TyzaaETL6Sv?=
 =?us-ascii?Q?PDxq1h55NkxF/UleDVa5WufjtsfYi9HZCaZTaPBlfLHBq3XjnKcz2G4Vk96C?=
 =?us-ascii?Q?+ScKP8jVojQFh8yioYAfmjMaqVy/WIOknKSCcO8P6yGEerhSINAse2L4kNOo?=
 =?us-ascii?Q?XX0d6yqP7qmLn7geQ14AhZGytYQg4AHMD7Y8si4nJ4CUXyTOKeeLYN/MPCy2?=
 =?us-ascii?Q?AKoyNAvloCmfgtT+qGglhjdUMRkDdp+LsSPb3FB8WX10Mk/ksPx/RJg5Guix?=
 =?us-ascii?Q?1eNVzc9QnklbGn+UI6iRuF70GZG2aebov0vnfQ6P6G8uPzRAZrgJm3LinxKC?=
 =?us-ascii?Q?Jfi2NC6nK3QilghTHLgbjDS4aGFNKvh+zFwF30IcjkYwPUQ4Me4seXKSJ7wj?=
 =?us-ascii?Q?DBvVthEN6oBw9C/Eg3Q+Ao63BdHgTESWJEgpFdHTytlegykZOEoFEgfWuAaO?=
 =?us-ascii?Q?We3gb6FChWeA8lESWE66cFXA/JFS2V8oNO4mvLlm5R1IUltgxReRzURUfIWE?=
 =?us-ascii?Q?BJ8G2y/BttaumyCUfdXmzK3a0oXFWkOjxqV1hIqrutJ42g1EovLC7bEskcsF?=
 =?us-ascii?Q?Nv7n6J9ByD5kf94pFtm2DxN7M8Iokm8t4dqJLMmsle2kJZ/2WYL0Lmtjr8pE?=
 =?us-ascii?Q?JrcUsj0lX4jlkPRLGrgrHLtSgQc38DQe5bj/xRFlB8FQ5Lv81SkfBSQHgszL?=
 =?us-ascii?Q?o51zvcysx13yqKOOZq4ZbFw/1blclTpGIcAv6Q4e?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4339be5-e834-464c-93b5-08dad117bde8
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 08:08:32.6623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d3rSpPJflxzSwG+YmMSnNXe3lcgnjN2m0QzCcvuxFMBuHqg9xFvctnmwpjRgtY8BeJkeB9LOOBZ0XkDGFZeVrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6499
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, November 24, 2022 8:27 PM
>=20
> This avoids referencing device->group in __vfio_register_dev()

this is not true. There is still reference to device->group when adding
the device to the group->device_list.

this remark will become true if you put it after patch04.

> +static int vfio_device_set_group(struct vfio_device *device,
> +				 enum vfio_group_type type)
>  {
> -	int ret;
> +	struct vfio_group *group;
> +
> +	if (type =3D=3D VFIO_IOMMU)
> +		group =3D vfio_group_find_or_alloc(device->dev);
> +	else
> +		group =3D vfio_noiommu_group_alloc(device->dev, type);

Do we need a WARN_ON(type =3D=3D VFIO_NO_IOMMU)?=20

> @@ -638,6 +651,7 @@ void vfio_unregister_group_dev(struct vfio_device
> *device)
>  	/* Balances device_add in register path */
>  	device_del(&device->device);
>=20
> +	/* Balances vfio_device_set_group in register path */

"vfio_device_set_group()"

>  	vfio_device_remove_group(device);
>  }
>  EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
> --
> 2.34.1

