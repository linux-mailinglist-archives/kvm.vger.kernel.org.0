Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16506CB745
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 08:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbjC1Ggt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 02:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbjC1Ggq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 02:36:46 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0E0AB;
        Mon, 27 Mar 2023 23:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679985405; x=1711521405;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bccfVOYNoX624yUwRhCuZ4qVtm5knZ79vpKtUJWwxKo=;
  b=SQYEukPtX21a1zGBWeh8w3KxwXegcBljFR6hKmvl6ypPMV5Z3RGAsyVL
   tZZtJ+JBd7t19eVloM+DZUtKK4Y0qFtoOhdD8Y0gh1WSqxw3vGD5zaAaq
   U+f4V4I/lRT35m7f/wkI8poGKRtYneiZIOmMGckTgxPVnqe8J9kuRfOnb
   vRSwJr5uSIai1OEvj1yBj6Cr5rZLSPtrto1DJI2OvKZSM/yh/y3bDiw+q
   Aqbrc5U11iyOYCriseoQSncEbmaJods3KeOTpN8Q0ID9bMB0MgnyEVrbK
   eXoSOtS9o5NFUzWB+67RPKNnjJDnvMMME2jHz7noGBAwGmCWSBttZjdE7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="340508588"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="340508588"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 23:36:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="661077259"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="661077259"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 27 Mar 2023 23:36:44 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 23:36:44 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 27 Mar 2023 23:36:44 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 27 Mar 2023 23:36:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U8e+RTQcej3l6Layyr1U1/D5IbCuQfZPC21oX8vV2oG2ROQBzKXJGQ6m4C6d/gsggG8Rx7zYiJc7Y/XQH0Z/xD5QyoD/R4BjgeJXgXoTjOaDs50Bi/uWzjQ5BVWvmSleWZn5JSncGvRPyKBaJEFa+2lRSm3G7ez9tvCF6cvzW/U0DrFpbwqgaeD4hzZgMeJXLBo1lntGWuAZ7fKtGfBnvPC2fFOqYWd+v+ltIHb4giJcpwNDoGqN3x+sxJXvsIhacnIQoCIL1QGXbKaWtTHcxWiMnFdm+to6ZCq2nBaOVuwrCOmI+fHrnUpN66HNL3LQRAinqU99lCsbUG9F4IBCWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bccfVOYNoX624yUwRhCuZ4qVtm5knZ79vpKtUJWwxKo=;
 b=QjOCK/eZ9rVl1j4GZXvamAxbNBIF2BdXH5IrVM1Q0EaQjOCrLpa6K385R+/dYVkAe70T31+kZduBar9j8+cciDFQoqGe4sa2+TBGwCft0tnJcc5vSAjGnq5PGhv7BfE+jKo4ggDu0D7FWB9j27omKMSOd4pw56xFLziNCBVTNNzXQJuIL8OSFWoOZ0TwCYG6cyWBqcaeNj+QI4GtASOGvP9KuEqlAO3p5AdtWL/K6bR6yCLG0mdS83LGeI+iyyKAnMoZDiVGyGbT8wwjdkdTLL897lHNI1QRIjw+k2OFWO2r0rpq2gPbe0ACjK4RUOrLv9btz6AaNb9WsJssAsTZWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by CY5PR11MB6114.namprd11.prod.outlook.com (2603:10b6:930:2d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Tue, 28 Mar
 2023 06:36:41 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::410d:f336:9014:8675]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::410d:f336:9014:8675%9]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 06:36:41 +0000
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v8 18/24] vfio: Determine noiommu in vfio_device
 registration
Thread-Topic: [PATCH v8 18/24] vfio: Determine noiommu in vfio_device
 registration
Thread-Index: AQHZYJBGHDLrw1qqRkafOPF39TAXxq8PvdMQ
Date:   Tue, 28 Mar 2023 06:36:41 +0000
Message-ID: <BL1PR11MB5271A5D96A358CFC6FA946878C889@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
 <20230327094047.47215-19-yi.l.liu@intel.com>
In-Reply-To: <20230327094047.47215-19-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|CY5PR11MB6114:EE_
x-ms-office365-filtering-correlation-id: 81c3b033-b0e1-47f9-5eb6-08db2f56ca91
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +cu1D0VAvKXuttYQMWYsRVsPHTufVixRn1ZeoNkSpaY/ku2eMzXaR+5K65qazLlFDSwkKPpkQ6gkNtNitY/THsio1tfq7aKxgl6UAx0hzo5uo5CtXkZU9WYgWx80cPSOMYeAxKPF9CTNbCBSA6w5iZ8QWYyCW9kbRun7LpaSSACrZz95nzCVDcouE8ebNmWuknfIAZrNhaYqxXMR/5OLz3j2R4MaCbFEw6DSnw0NDsjUKqt2dIQB0/c95PR0bWpFzeoplzy4T4msASo/p2day1iSIYZG9Y6dc6UkmVIDVi94kdqU2i5mJ1jlzEjXaWdWeHAFAIe03GJaex0SBzwJf7XfMJYprYWTqrX1BGd4zHdW7x6BJsCAOFE7969C1xotjTdbEPRNUYsLDvMjipWIENYVw94yWkxL2ix9wdHgbCISzAn2jzocuKkFRcmYFvpeFDrqTEDrMh7hrt9rwj6PBy0QU0q6otxNGIH2/sOE+UwePxGEZgwITsyQGcBnsgXYgracLmJYf9XOHdQNr8ISmrRT4fxbuyFgACvuibfNMl574c8xIj5M0ZPtfCBhxU7hKxJikqztZZ4x9pS8HKpTK80Hws1SpLylQ19r1I/Xa12oONc0Sg5Xy619giU23wPl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(39860400002)(396003)(346002)(136003)(451199021)(7696005)(71200400001)(9686003)(186003)(478600001)(54906003)(6506007)(26005)(8936002)(52536014)(316002)(7416002)(5660300002)(41300700001)(82960400001)(2906002)(110136005)(4326008)(38070700005)(38100700002)(122000001)(33656002)(66446008)(66946007)(66556008)(66476007)(8676002)(64756008)(76116006)(86362001)(558084003)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tBuxWXkXQCGyDX5wLUbTn4fx+NYCQVquD7qHX+I4DA+WvtKBTMXzouIKNFBW?=
 =?us-ascii?Q?3eajdWmaNXKwxrI3auxvvInsuWm+SNpGHj3Tfv6jNblyzEyDv55NUtEzXvKc?=
 =?us-ascii?Q?Pz9ChkvSAFXK4lvC9rG3C+NqeUA4C191D+jzNrbBsmJ4PzYNMJ2O8WQoik7v?=
 =?us-ascii?Q?kjhBzTPtjpSvDIA+s5gU8rQ0sLRcsANlY0GuUK4OLiEjNaAW3xWemjQl3keL?=
 =?us-ascii?Q?dXyyP/DDe+5JUlHr/VTKDDREGdZuicTC1T04EYd7zCzg5hnZB4iRsE6bs/41?=
 =?us-ascii?Q?D0H9PJfYIU0iQdZDbgCGqxJr4JE7oXt0H0lFrRdHfduQsukQHp09c1gIXTf1?=
 =?us-ascii?Q?jK/tl6UQoV1QnboqKbK1ZRfWli7hAaNj5L09m9A+0D22d2LLDCcYYXCpQkVs?=
 =?us-ascii?Q?l5EXHG3bhI8uBr8Wy7f52Ma8j0GDuptvfHnsUPw861pR7A7nTIl1L8Q0QGyr?=
 =?us-ascii?Q?MLdlYUSaQGEN4bQi3g7BYOhRxHYGjKQTwq9i4Y4YoOHvshAuw9K/8+Dd4mNn?=
 =?us-ascii?Q?YBYL3mk5ulRzHwRD+yBmrQWtd4LufI7hnD4gkXknZBeNo9FU9uFb8WMeEWTY?=
 =?us-ascii?Q?2VHXFjS7wfBzEYf8fo9ady69ujoAOPAHoNyvCPBfZqwbcNvPVotuL5pEeL/Q?=
 =?us-ascii?Q?U14vGn7lXI6/Jo8N5FY207SaGutx719JbT94dt5ftrkRmiM8O1ohqoZ7qEdq?=
 =?us-ascii?Q?62cQUexJ05Cvbj0RSlaYLQWTe7yBS5xSQi8SK/FbxFOSSPOksuVnUEgTE9JT?=
 =?us-ascii?Q?A3UOqZcxs4K/C38IemqAkEdeW7W4v6ZSF8KL6KpKaTTODXx6hZDGjaoCwdvy?=
 =?us-ascii?Q?J8yLvPus9ON8+xQZPUzwPO3g8pb4hGkElXct3ftkseZ+9tKEhjV1rfb34yHp?=
 =?us-ascii?Q?iAFuB89ih6npp2xe/ihyptWnHIU4KERK8Ipgd5gN58VgeF+lU32ZVbWOcXTT?=
 =?us-ascii?Q?ozdBxvgKfmz11cGgUAyo2Artj3rTqjvsrYS7VZWHNuL6rbMy0MIZBkAnAV0q?=
 =?us-ascii?Q?uINRK7/r9Y9ZDqDcN4TQ9P3N8atgu9pQ1Xtw7DIL4gFL/P99+Gg0mLXFlwjh?=
 =?us-ascii?Q?Ys4wzD3Tbz7dEmJZNywX/Bhz3ucY8WsiRebmwEdvb4u3enM29D02p/DXL3E+?=
 =?us-ascii?Q?ddN6n/Svpg9bqHmkbQrpct9jq0hF/smM0YL0F6dUCpLDkmnKgYkAVxEMOBlP?=
 =?us-ascii?Q?gtHL3YxpXYincB/eyHEDom0YoenqvEz1eZxNdyN/M1gnKmGzxYj0m8zJyqJ7?=
 =?us-ascii?Q?+x1Qv6aZkL1UXn0nmQLeH1PQyETd9NFc+ka6nbsdsfIiDPFRCOu1uthWXC7r?=
 =?us-ascii?Q?QxY75dCaQRnasYQ5ZrBx5L0Yeg/qsUaoIQNR9cCqxfXC/zmN0MfsRCQ3Rby0?=
 =?us-ascii?Q?eaLxezmNZ8E2+JJ7Y/H97N4MlBYGSox3tu6VEvoELWCYyHpXeN90hdoNTI9H?=
 =?us-ascii?Q?vtsAgnvg79d8E9C7UsbAag9h8wTh3vrFpBf0rn/BT2eHVcRx066zoJuAMfWs?=
 =?us-ascii?Q?VFpTbdEwsS4NDYiNzYynXr/4BTzoA3dPOicBSem/RE41ckFzcgX2uYeB7krM?=
 =?us-ascii?Q?AXa53wMiqB9seE6O2yVXHGCf85wZzD23Dv6f4PMF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81c3b033-b0e1-47f9-5eb6-08db2f56ca91
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 06:36:41.4916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j50M0p4zb55nOHg6XZITU6yinA5DUpwL7a38TGSMK396NwP9/ClX0JLdYDG+UO0G9/7XF3pJ78i/8j7cmpb3qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6114
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, March 27, 2023 5:41 PM
>=20
> This adds a noiommu flag in vfio_device, hence caller of the
> vfio_device_is_noiommu() just refers to the flag for noiommu
> check.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
