Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10F554ADBB
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 11:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349834AbiFNJvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 05:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242478AbiFNJv0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 05:51:26 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F3F47049;
        Tue, 14 Jun 2022 02:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655200266; x=1686736266;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6tc1PMiRgscILLLx31HiISt7P3TkpMArEd2gjoYumaU=;
  b=PYNkHJFkLKUnbkQu5yDoSsWE4tSerUD571TR0lbcd21qyDSg0176HpNk
   B+eW9c5mfUwTLy88HPSEIDtEHq5jdi5BSIgQKQAfExlNvT54Bo6uarYtN
   4fgo6ggfk6ghwA82yyn8SblpgvX/9O0BRMFtPUIPumepJkV1k2iKTJlJW
   3Ptb8yuT1tE/rV62up0Xm+vtBPB7o8DfTxAvjlD5MBXVM9dtPLJmTahLR
   PGkC61Kf9F8R4fPLa6/vK5awGu3lfiSBQ2Xv2Lv0wwNbdustc5fu5VwLN
   Bt+mYhTNXI8S4gtCxTbttHFvBvCVblWvVNlkTIHA9oqeL9xVZrZOsiN3A
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="340234331"
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="340234331"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 02:50:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="673796825"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Jun 2022 02:50:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 14 Jun 2022 02:50:49 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 14 Jun 2022 02:50:49 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 14 Jun 2022 02:50:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVU+9B9T8h+BGcRm74iY5Mp2Xt5QPYD2EmegbXqP4n+coCaErGi8/ytPjCPKBDv2qPEcfXX8ZVcgxkuCjh/fKXZjvRw7R5Y86hGUP+J6Aa+4SpeNwlKQEy/CuVOAohZuTqBVjS/RkocIHpWbPtSjLPbwWxKGYwrI/78KmuAT64vOgo2z6K8reRbTF9IurvQ0A2G4KUXgRBLY5VIerBe9wOjKhu6ITIZg+kIlN9YD1CcVN7rJMrDUJkw74AahmKUJZN+Q4XhHarjxlGsudLUR5JiU37O40LyIwcOsMfIrFec95PdQezxOgkZKS8RhdDOD73PKWaS4+FCLwkPPdI7MQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tc1PMiRgscILLLx31HiISt7P3TkpMArEd2gjoYumaU=;
 b=ajXS9KsyTXax0C9qbMYDz5b/18iYUaEgFO1Fsg078wE8BYJeBqqYfrAr7amSDKW/afW2e96CZsHhbUEaWVcdYyNkNGbM/Cdbp1aAXXfoQPo3Je69cxufaKGr2bJ4TwBtciG8DQD1TkqVCXX1SdQ0DiBDHZewjFJZJZghZ76e1SUqEDiMKnQiUflgYYo+Gt4zb7wFk+1XoS+X7cs9zBvfh2DnsY27/WLVShNptylFOL+o17FdG4z0cDIEjy3opWX18VAzC8euUrbjxLu/zcK2gH/8K6POtfHr/ns03lxTxEpJA3P9WhjtW7VyfMGEA42lR/ci5YsQeQcmbsKIgDHTyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MWHPR11MB1453.namprd11.prod.outlook.com (2603:10b6:301:c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.14; Tue, 14 Jun
 2022 09:50:42 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 09:50:42 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 01/13] vfio/mdev: make mdev.h standalone includable
Thread-Topic: [PATCH 01/13] vfio/mdev: make mdev.h standalone includable
Thread-Index: AQHYf6rmGSxIp5+GOUW0bXrNSuSMIK1OqNyA
Date:   Tue, 14 Jun 2022 09:50:42 +0000
Message-ID: <BN9PR11MB52762DBACF429AE384A062108CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-2-hch@lst.de>
In-Reply-To: <20220614045428.278494-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee4f8b6d-5943-4d80-1ba7-08da4deb5875
x-ms-traffictypediagnostic: MWHPR11MB1453:EE_
x-microsoft-antispam-prvs: <MWHPR11MB1453B90616CD526118AFCE078CAA9@MWHPR11MB1453.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mNe/KFj+8Jgl1Ix6QCgC/rb5a6rIZyx4Qpidt+0SjONQu9Vxrk4SEBmSM20K8UYIfrInL0eWnuf1jxUB26WbHpXHIASwCJy31Fy3paK2GQ14jGGQAP1tV/ciJPyeD2MSVThFai+l6jaetDMhby1UgMI8V0hD4BsaOQXAvsmMHztwfHaC3zKQJp8eQ9rinxPUdgk0QoxVKuhlLKZubS4Dx1vwyMN5BnEs3op+bxSYWJhN28LR8rIsaBc9na38vHmOMhoVXqVSUmGyqBD5MQgp9HvuMF0FPDvt+H7CPo6ETGmBCNllBaTHTpb/fDZapeZOi+EnDCAdLRzj56/2VfsTc1Clb0plzgISJzR55eVHkyxEb7yex0sxeKTUmCOP+GDj3AbAK+WFcF4AUcp1+zN4uPD/QWFLYyoXnllPoEfO2yFGtU/lxMp7QEqa/alvuaf1cOiI4OCxoEwkO2bWjtuf5V9e26OE+HBf+BWkQbKw9ST+WMnqHED22959soN7COfwo275ZB3YICWCyC0SRzYqljNkJTVizhwePIbkmtBkzQys8rstLSikRn+gagmrdQwNt//+EABuSVOQUqU0NLSCeQZRSmya01JRi6yzbRTWttvSLmxpHqyLb+BZLw16DJUt/cKAfK1aqaS3HdefNhC2S62Ry2HlkIBEh5HW5QU7FK76aj1d2Ykt+yOgTFg9sH9rafSSzM5OKMSDbCkjngnOHvchaL9sYe56O4HTHEBorxE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(558084003)(66556008)(921005)(122000001)(508600001)(38070700005)(55016003)(7416002)(5660300002)(33656002)(2906002)(66446008)(76116006)(86362001)(186003)(316002)(110136005)(66476007)(54906003)(4326008)(8676002)(52536014)(8936002)(64756008)(7696005)(6506007)(26005)(71200400001)(82960400001)(38100700002)(9686003)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?S/wzbMmE0OCNCLtDSqQSkSj2PIHEdrNLcEBrBrMTD2431BzkaVAvp7NSL/RW?=
 =?us-ascii?Q?C/GMO3V0yJ6pqL7Ivzw1zmy7BRDJi1x0SONy1F1tIbqGD9fC9PzrTZ31tNOf?=
 =?us-ascii?Q?3gV+lfK2+EYV5rrIQlGJfBKJ64XnKE3/Uq/gJk4lifa9ZvjFye4vM7TIcjb+?=
 =?us-ascii?Q?zEnqOI0d7i1jKs738zMPwVCkZqOekptzsLWAsS+y5AvypbHSTIh0IVkbFXyV?=
 =?us-ascii?Q?9fSDWCsIYnGp1vfKBuMXU5u5QLff/wc0psQdGCFukZF1yrhiafZ9cQjKA0qj?=
 =?us-ascii?Q?OfrVPiHbhIuq/Fe92gJ64sVQ2Z4NPyZwH9LpUCtvEPjqoC459Uz1YpeQqr4X?=
 =?us-ascii?Q?f+MtdXec9IHUlSeH/gPnsbiqZjBXXJMZu+zjC7JlEisEedn6SSdJ0qxdOf6q?=
 =?us-ascii?Q?UkfHVMHT4l5fHZm0egsjJbUC1m3K8tkQhh6C0wpddhHA52CEuQlEp5sBJIn5?=
 =?us-ascii?Q?TQtLno/BB1u4Z30xp/MYYC4XHRH7eF1F8M/5lw8qjJ9h4luPff+A4MOVybwq?=
 =?us-ascii?Q?yTj27VPCyptyp2t2GXMmXcSvibMGZl/w+Wt9+BXODN70Vxq0dPDxo/36VvEq?=
 =?us-ascii?Q?CeibZlyPszcJ/wl+e37REEtjGeopMgSTmYGxwrkKsu0P91rAG9yWDZJJrF5n?=
 =?us-ascii?Q?MQVa4YFQDG64sacLdjIhAifMttHO2kBrDORt7sPoLOQ127B3ePiUFh14+vnk?=
 =?us-ascii?Q?xySHSq4BF/KHwsxCIcVZyD5YPaGEvLY4dx+vBDwC/QUrDFMWq4YxCnG1NQjR?=
 =?us-ascii?Q?7tykeRDLQoHJ+iZLxbUzWCRVWhVBgl2tcTVtVukGd7+c2oiAowtFh3u0I1Yw?=
 =?us-ascii?Q?gG2du1QpGjVpc4gYl3P5pvcjOocQDV8a0uHVIEQvS7CdCdlCALVfMDi/uOGK?=
 =?us-ascii?Q?MsK1Ayynn3uEOmNXsL3pxYiTd9h9iA6mQrWqU74UPYgHHvI8H30bLS9eMQXA?=
 =?us-ascii?Q?f2Fm6exrjjxOE3V1h1PvMA6Wl/MIRx0aB7MjEBRpIy6w3EJ8ArlqEsA97eUi?=
 =?us-ascii?Q?L3OhRbdB3YbELosKGdadQl8x2dhIhFE0W54djZSYyPI87M3Oqx29NorlBbCZ?=
 =?us-ascii?Q?Gx6Z2kt9CHlQeDZoD3fvWBpYNDGX1HX5TOw3Zm2uN+OU7c6p6RIqp2PrOSVh?=
 =?us-ascii?Q?DSGXPHrD2KeK9qpn7+vBJZGaLI5n92Ag08qmUHQ8SQKnuadEzz40ewFBcOLP?=
 =?us-ascii?Q?orPNNKK4atu1l9D9IrsQlAXdqarDWSWNgbNDjVr68jObd8qLPIVTesM8UeYQ?=
 =?us-ascii?Q?prU6ICnbMbaC5PfyXQZQlfAGtSDNRFoGhsV0jwF55qOen+CSa+aEFVAbuOix?=
 =?us-ascii?Q?1Jfx5P0L7Ip5e1uxjf4duSxwlT+MsX0XJ4LIMjDt+KM9CNv+FrvbzxMRDd+N?=
 =?us-ascii?Q?9aDhcLfdHaEduBNqP/7e240U+m5NJXLsQSmQ0DVnL4AlhCY9UMt7MypihDdJ?=
 =?us-ascii?Q?MM1Qn11AK0DTXmiYcsDc4crzGvKNzwV7Ef27WHwKXtyzxh3fbgMCqBnEv4ZE?=
 =?us-ascii?Q?bs5vIPCgBBIrnfigqWlo0m27kPpcXkYyFt2ZEhQTZ5I3XVoFewCPiGsNA+t2?=
 =?us-ascii?Q?14si5UhAfjbt1jsSoYOdu6XtRHFYaw/3IzXAEwMNfSW940CrNtnIu4ydXtsS?=
 =?us-ascii?Q?LYP4tMJbegdAAKVCOkjcDdKLFXqk9Tz+7ktTI1qlytPRlqHoP9GN+pbuXLmJ?=
 =?us-ascii?Q?SxYr0dUPbqn4l4RwGyYdGI210d5WINzg+KfJW+dfMnmfYPh16Rie8pDCzoqV?=
 =?us-ascii?Q?Tjypm1uQRQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee4f8b6d-5943-4d80-1ba7-08da4deb5875
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 09:50:42.2914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EKRnoKBErt3r+uASUezre9kcBhVhNz+FYJ67jW/18RUHtHQspCVPbl7yxW+3KRRPfYBSllxb1SLzrqY83XKpyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1453
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig
> Sent: Tuesday, June 14, 2022 12:54 PM
>=20
> Include <linux/device.h> and <linux/uuid.h> so that users of this headers
> don't need to do that and remove those includes that aren't needed
> any more.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
