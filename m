Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D26C674B59
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 05:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjATExD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 23:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjATEwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 23:52:42 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665EB5FD4
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 20:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674189883; x=1705725883;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N4x9fmk3xGU9Mbr9184lsZn5QE4QNE1gbQAetKwrX3U=;
  b=IvA3fIU4vA2uKtlh5Qbt1GiBcZqWQajEEbHXAuXS68N71Of/dPSXwHQn
   ZJYLm18gIW2qup3/j/NhIYAInfpB8Nnapch+EKBlPyuPHdiTxpY+vjueQ
   B/iuLrk4kWjS65WLqk+6qLSXDoF1ggjuz71noJ8hqhdrjZ1VXRWKjX6rf
   F/kqMuuhf74iMUwIC5tJNYXsAwErWr43xVBe6ggJsoPMhxZjiBLAOut2b
   Tdo83HtLo6K7X5L+oGcHLa+QKCocZWeNXpwZgLkEfXh99OMcJDaT6VM9M
   6+Cpu7sVg6P5iPhFYvXXdLfR+YiqxIP5zk64MocUexg2Rqf96D1dkC1/0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="308801403"
X-IronPort-AV: E=Sophos;i="5.97,228,1669104000"; 
   d="scan'208";a="308801403"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 01:55:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="690570362"
X-IronPort-AV: E=Sophos;i="5.97,228,1669104000"; 
   d="scan'208";a="690570362"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 19 Jan 2023 01:55:22 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 01:55:22 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 01:55:22 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 01:55:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AHBwBd5afSULq3T1qlWGK5OzznWd3V9SKZAyMLK48pH/W7EjGQlFVWLrc7wbFGZdhCtrSuNF4xWnIJB5vhYOS9SYo5sx/oNbrg67y+Y/BvNI2amb5ihhveQK4yd3Z9ZSrl1NrZTiHjYtYs+WsoKgB5P1uCo1wvIduRBJ04zEGqA1f9sY0ZDjlaQXNIPKQ8AeJYrlPWIW6IwESZYQWlmClSCfmeA89eb9NeqZyUVQwMz0UEfMW0SdxTvaV2y7BaVmFBgyInEj2663Vt7d+W+sl59ZcnTxo3esGwLTIKemoijy5p8wN/hR2IaK946CMr/jQKwYlrimIT21eeailABnkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R9ZPWoykfP81aCCEq5s179Jpdl7XmeC+7n/BUHs+hI0=;
 b=cbzERnRNycYkUBObveWoCOFxkQSEXDks0DGUalHkxZ+2Rw93Zag+BLL6w8j4Won3ZDGrwnYEOc3ETdTUIXIfJAGXfq8X9dg0oVoTKsQeqXYt/as7FC0wMtyULYBdIEoLRofW/muB7evQ2E3rZ7nVq615JrprUZrvFiTmEsbRtIVcw6XZceJPuVjjgzmYGWaSGDcak3nVKZbVit2GjHmHW6xsYHevBD27jWFlUXlHkBlVUSETD9c0W9l972UsVd9HuEepBRq3C4rEAr1xF1yVs4I6PBqSRKZc/8qrzep7DOwGStkneHAUHRBcRQ3vNLiBDHvaVU4cYS4N8yMXJPKEdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB7675.namprd11.prod.outlook.com (2603:10b6:610:122::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 09:55:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6002.025; Thu, 19 Jan 2023
 09:55:19 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Topic: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Index: AQHZKnqafBBqpcX9SES7NJ4Rmsa6D66lgedw
Date:   Thu, 19 Jan 2023 09:55:19 +0000
Message-ID: <BN9PR11MB52769CBCA68CD25DAC96B33B8CC49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-11-yi.l.liu@intel.com>
In-Reply-To: <20230117134942.101112-11-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB7675:EE_
x-ms-office365-filtering-correlation-id: 06ef8c02-ee82-4e7d-4c2b-08dafa03464f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iAcDdqbatU9EO6htExtk6gq06TAkN2r9EhLRcfiKdLnrGc+f97hLGOVkANjw/rDICFlfJMd7UjYAR1yY2GR2DwOeoN66f1qt4nek5q8RFOMx2VCUJ4r7bMIOgGRzwjy1fsvITyDzUJCjbQt68xgwUDcZAoykh4wsIcteMkv/P+ocF+ygHA4IDJibCepKPNzc1xANRy70RUiwTQehyIj/7V8YKW5z/kyECSqLDMNkTyzCVf0H+mfevYqIQArO8jfDkmDtCpey48iC/+nLwkP/fccUIODmwbjehjMZo30+6WNrROEBPZlfuTJslujUKK18toB/GX2BebpMNWrOVV5mAL6TDkCw2VsBxd7xJftnaVB+++dIPL5sFpNPJVCSofDSGvjkxsyWiUltyjWyLw7wXfz37MJsx23jIpvqudu0a1LTh4onMN2UPwRk8BqcfV3EnbaiOATdE5bpYss3XeahinaxvczrdLicP6cwFzyYZNwQigFKwuc8KDWxNXtq62z4zwCU4pelSU0SINjoRwR/1gU4zvyJqmn7F/Mxl1/WH5Qon4FAAD43Mx0iHiBM0KXvundfMnk7o72Yh/PN/ywil3boAWoql2XaV07Xlf0P7vK0HxCXa/HBZu2AQdzev3mg3ZuDqWGzBAbUwBDo2mcfZJiQbw7/85z3YQ/8xM+g28q+OUHel872vIWB70pewAqMQiiNVCY+XPTonJJ90DzYyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(366004)(396003)(346002)(451199015)(82960400001)(122000001)(38100700002)(66946007)(38070700005)(33656002)(76116006)(66476007)(5660300002)(8936002)(2906002)(55016003)(52536014)(7416002)(66556008)(64756008)(4326008)(8676002)(41300700001)(9686003)(26005)(66446008)(186003)(83380400001)(7696005)(110136005)(54906003)(71200400001)(86362001)(478600001)(316002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ehgDc8L03+uzxy2RHfrg9/u1huUYXkd2rIxTe5bvUBJYgW3hdxq98qNvpLOf?=
 =?us-ascii?Q?i4vhDv6f9XCauqCqHVdU+5vosDtFwE9xBl2HATq+W66kCyDM/Dx2ph5Ria6g?=
 =?us-ascii?Q?quCTjxXqTEiXSDQ/4ywFTaWFDGcB3puzhYPjjTbZhjTqivBsuUZTDNNhf74S?=
 =?us-ascii?Q?tOdtivRmKB5/CGtunav7o+jUe+0MLzjs1yoK/euV5rEzxLKxQ7i58+dWLR7Y?=
 =?us-ascii?Q?7wO+GTlo+hCBgsYdbqansDo+Qa2Nw+IOm12gy+0AtaZLJ4tHCqfcbvslvSjF?=
 =?us-ascii?Q?PrXtoKYVmOq7DYbnDBH5KjkWoo31HztTC0Q7xho6Z+eo7n9RCQSbaizAAg+E?=
 =?us-ascii?Q?4PIWzSNQ+zPNKeourfWkIPa6nyL1ebM9WI5qOfqogpkq1+GwbgHrupzft6u5?=
 =?us-ascii?Q?y8Y/tPnJ+fK6xYHPORI+CeXCHPtoNJZhXo6oLjHBVxcH6BGp/Ew3xiX7MZJq?=
 =?us-ascii?Q?K1GDePOohRydwfrLQr1to4kGEeFGI8a/0Hhx6s/jcQLmHJ3EEgnSQax34m4K?=
 =?us-ascii?Q?Qj7ry/oDw5l1Ztm67dwsnA8hysJTk6BT+KvuumIo0nY8Cos1hQbnTqLYCG0u?=
 =?us-ascii?Q?T4Klp56QAQp/SqFxg7Ei1yVtA+tYWbjMERSqcymHy0/+VzbrU5Zqy05QhQp3?=
 =?us-ascii?Q?wWW/tgH304Ita/TwY6M0bttXSvPAzQ4XPWyQStkoJH+lmgfYhg/we3xHI2Su?=
 =?us-ascii?Q?tYgV+5Oilnzkr/sOuBZ1WThpsUSzKF9zFDsJii+CPltWCSU0JRCB3IA0Ody9?=
 =?us-ascii?Q?vqJJB9LG0Jrfe8Dfhkin5hPaL6RGktJHdi2+W9OtODpjle1Lz0XhFTGZTteH?=
 =?us-ascii?Q?SswyZzpTxQeIzKWT/bXKJMv9OqwgPNOlOQDgA58l8Zu7s4clAM190g8b7OIq?=
 =?us-ascii?Q?H7d/7fczDDQHsG/pad5LQAd3wueQjQFmF81bh0Sze3qGvmqxjAhbxDVyzPQ9?=
 =?us-ascii?Q?QQ5ODZ1Kzj7dWcdTqOCN/YBRLBp/QSQgAbPQ00bSRUQ43BWBgRsfrJasbX/Q?=
 =?us-ascii?Q?O4bvNqwQmapDbSe0XmOGZIq7/rZvIoXG7roVbsOteaSlyXbQvt7DPPujQ6Ir?=
 =?us-ascii?Q?NvwJtjTYf75Fe+V3de0toYhL3J+zuCEE+WU859YlQl1Z1RwQSXPmyYs+c+ID?=
 =?us-ascii?Q?8zYS+r+eRcpoZR/EClaw2sHtMRW1KjZHrLk5c/bUNR9IHwUaLm4YkCnY5Lh7?=
 =?us-ascii?Q?zumOT0u17/QJ/cA8F/Zp3MJlSP6/+H3+E94aMFMnGjGGEKY+gn4eBd+Npv//?=
 =?us-ascii?Q?EgEzKqQbN9SXU9qc1lb1vGLaTT6H2pHP9n6mWCr7xSGIXRArKyOQ15Pi2Wj2?=
 =?us-ascii?Q?LLhtwOWmMSLXFAUZaYKqH9N3/TJxOoivf6k0tcdNf1S1B9tE2UbvatR9q6sq?=
 =?us-ascii?Q?EM1vPRpTsY3JyZ0urV8/LKNvCfdfq2a2SamD/q9S4R5U2ARNt0c1a2sR0P5S?=
 =?us-ascii?Q?rz+upT4fsbO9eRxF5ctHAEWzA0C3b3FUpuC27BlhF7qtDYGbDcc/hYuseSz6?=
 =?us-ascii?Q?LFFfd53rujroPINKhK6m7Uhrg72PiOSNjlGjdkSE1HoaedWhtAaDOA4X62E5?=
 =?us-ascii?Q?iP628c/34X7dDb2ykBzXxN6sb18NXfkP1u8NThJE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06ef8c02-ee82-4e7d-4c2b-08dafa03464f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 09:55:19.7157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dQ5tezAaEvNoMc2vlegijPsswZ9o5qA+lSRqI2xuvs9bSLr/lUnb15sNZl5BHNq4k1HPw+eUExn6R6Te8fDpXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7675
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, January 17, 2023 9:50 PM
>=20
> @@ -17,7 +17,11 @@ struct vfio_device;
>  struct vfio_container;
>=20
>  struct vfio_device_file {
> +	/* static fields, init per allocation */
>  	struct vfio_device *device;
> +	bool single_open;

I wonder whether the readability is better by renaming this
to 'cdev', e.g.:

	/*
	 * Device cdev path cannot support multiple device open since
	 * it doesn't have a secure way for it. So a second device
	 * open attempt should be failed if the caller is from a cdev
	 * path or the device has already been opened by a cdev path.
	 */
	if (device->open_count !=3D 0 &&
	    (df->cdev || device->single_open))
		return -EINVAL;

	/*
	 * group path supports multiple device open, while cdev doesn't.
	 * So use vfio_device_group_close() for !singel_open case.
	 */
	if (!df->cdev)
		vfio_device_group_close(df);

because from device file p.o.v we just want to differentiate cdev
vs. group interface. With this change we even don't need the
comment for the last condition check.

it's fine to have device->single_open as it's kind of a status bit
set in the cdev path to prevent more opens on this device.
