Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F426D1690
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 07:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjCaFCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 01:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjCaFB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 01:01:59 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C705B767;
        Thu, 30 Mar 2023 22:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680238919; x=1711774919;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9+ETKmv++op/YpqhDaAS4YRxy2b9/qNyxQjvm2r7VPk=;
  b=caZpE5Q5UgWbE9CutTXaW6gP82KonMMHKCDJX4/azo0fyirtHypzUwjy
   C25ayWvoGwDRgkK/ozycpwXdEPmVqJiRogSXUd/yz1FFVn0q2lH4LptZb
   oVxOKleThIRUQgTwVUp4HEv0wS2vXU2GjJlKN+SSnRGEHzUGORObhEZIr
   MXOEbKDAUtKwhNdZU8vGTwqrtIk95QaSN61jiLGFsx4x3DyvdlDcSmPQd
   BBKi7DXZlULz3ahgNeFr83Rhlfn6r3Bk0IJuBx6p5Yz8LVHnhRNkkkyHf
   Q44fcBeAWN8uZAvwkKTsjmmL5sSzgLDetMRKPrAngXYFQTRCNgiLva0bj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="404066883"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="404066883"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 22:01:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="662303998"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="662303998"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 30 Mar 2023 22:01:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 22:01:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 22:01:57 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 22:01:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvIMA2ZuafycqISI4zpSIfaSckCnYIz9wmiXj5rCyYCm98zd0ZB6rq6ex6Hye70O9PsYGO5iVZcgbK4e3hLPV9cGhXcelVebFZJ1L5XyFH505NxviDf8M94pxBu3sGq+XKgWMyHIDmqumV6WZlCGrAF4mWqfwZKAGgVlbawtbJKsiFITGafviLPEyUkmIp47JQ7eSN2r6HwYhJVqJYuRCHIerpLneF9mY/bm7ff/fAdNiKw516INt06g7u02mvfdZUE8jRRKlgnETCS2zhm/qggRYL/kMi6p3GtaiqmzcDTJGneNFQUe63zyDEBOjvxq6n1DDrWBkPbWnxyui5UfyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9+ETKmv++op/YpqhDaAS4YRxy2b9/qNyxQjvm2r7VPk=;
 b=bl8atIn9vX+pZezzvTicQYYmXREqVMiacmRimiun3nh4/N6k1F1EqVNZyW9P/Bj8Ci2XO2MBoWtpUDuIyk52qv4H4aoLw5W7iF/Ges5VHce2aJq6KhlET4LI+ULR44O8vqBxHzBOouBt7/V8hYmlLLaRu4UQU3oAn2Z5B/L3LjrsRJIhkILCTq9T1GK239i6Wm62qmzA3uWzKADyxwLzAs8mxu4tLgDK5QiwGw4vhsxygqavUplJK0XXhNwBnAXxIj1S2HSOSjBN404vgCg0cBj/RbJc+21Xa/loEgMIfoMZxA7TMB8KemdWFxA6RhoLKHipnHGgZ0QYVKhYVunjDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7)
 by IA0PR11MB7790.namprd11.prod.outlook.com (2603:10b6:208:403::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Fri, 31 Mar
 2023 05:01:55 +0000
Received: from MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::c4e:6c7:e9f7:7222]) by MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::c4e:6c7:e9f7:7222%7]) with mapi id 15.20.6222.035; Fri, 31 Mar 2023
 05:01:54 +0000
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v8 00/24] Add vfio_device cdev for iommufd support
Thread-Topic: [PATCH v8 00/24] Add vfio_device cdev for iommufd support
Thread-Index: AQHZYJA9pBM5UV0gsEGCaT5PZWWhNa8UWoSg
Date:   Fri, 31 Mar 2023 05:01:54 +0000
Message-ID: <MW4PR11MB6763873E1EE47726A65165ACE88F9@MW4PR11MB6763.namprd11.prod.outlook.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
In-Reply-To: <20230327094047.47215-1-yi.l.liu@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6763:EE_|IA0PR11MB7790:EE_
x-ms-office365-filtering-correlation-id: d729e673-bc6c-463c-8b82-08db31a50bd4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QWF2f5Ywsx+lM3SV/wLRJCvM8DljO6BnNDuq5ZesIiVZ4aBU56ItGMIev5eFPfXyYis/rKOPKW6mca/CBbz8g9ldMDcbuaG8966T9nvEYOklSkWDbvAfoSfKI9X4UQTl21+qHLnsk4pS+OMiCnXWU6N2V3cNgNrpGwcs16KRtW67wtk68MAWJjaCX7LLpz9liPekWv6brpMjxUakZlgcidtEpCfhLeY4dGI5AAGYOLJpBFFVJVDWn2IBFHmCsUbSZSTJicdEJv080XnCcWur7/WrSAI553J3YjwXTVZMHzg5bgCzCah/O9PO6WJ8CZ1MjbWqrjkq4L3Bl5QQgqveNBoHqZTAyEJL75b3QWDFD9ZfJXLwFhuAaK5VRHXZyUYuU7MdsUD2dRMK453U58nTejAqgzIodehkfzRVfVB8ooJ43Vm06ubEjrQJKKQ6MJMUfKuar5Yy87b6Da+1fgl5Dgb44wI2S/GZf3q6Tp1WC6WT/u1tKyRzeUL9XIz1z1Ei1DDPi6XiKPQm9eo/TsItjKBGUMhyc+iX0Gua5Q7iQe+mD0nlRIGNi6p6C4ssJ2u+jr//JxyFzOu+uIM7LAcuziMgP9zlen+Ja72IMWXrlO0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6763.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199021)(52536014)(55016003)(66946007)(5660300002)(186003)(8676002)(8936002)(41300700001)(66556008)(66446008)(66476007)(64756008)(4326008)(76116006)(82960400001)(122000001)(71200400001)(7696005)(26005)(966005)(86362001)(38070700005)(38100700002)(9686003)(316002)(83380400001)(6506007)(33656002)(478600001)(2906002)(7416002)(54906003)(110136005)(6636002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?04HzpnO9ICEdHBcP2c8VuSXCHt4nlzg8PEjy9qrwPe3MhQzA+XjcF8DVwkyR?=
 =?us-ascii?Q?M5b24xeUpb8Mphv8rcuYGV7rR5FYwGRoOYOA5eh8yNA5/NDkamZ8yW9JS+fb?=
 =?us-ascii?Q?IcMn9msLaUh0c5Z2Ak7qBKhzHNxADTxbwooqf3K6DL/chAFWjo2AL9+g73j5?=
 =?us-ascii?Q?d+AB6UEVN+i39vOzUhF1Z8hpCNzhoerBsfR5cm3HbreltuWNfwgcbRVPJUco?=
 =?us-ascii?Q?LJICaeU87reEaDBpCtP0/nSy6RwGQin0Q30knJxBnrbYYuvuKtlrvasCR6lK?=
 =?us-ascii?Q?qvFKPb32GZM0EgdLxEkqSCxFnXWVTmswb9VhFyJAwTSfKQdP2aEUdiuK0coM?=
 =?us-ascii?Q?z8erVGfwKooS3NLXFqwn2jF5qE1cY1hVxUz7qFV5fXEuYNDsWhTrIYDpsH+d?=
 =?us-ascii?Q?ocWC7SRNOH+OVoZGfBVN79hSADMg/2sZvhqlHuSmv49AVPzWlANC0E3tC7Zb?=
 =?us-ascii?Q?Kx/6U7jSCCb2rlpO93/2/CksFlX6JlWlm6F00yK1FbFncOAMgCYzizPGSQAn?=
 =?us-ascii?Q?RqSdwW8kqj+wvCIzK2fjtlGq5GFcqtatM/9w8S7yV1AsqnxtHNChuINmUoMn?=
 =?us-ascii?Q?SNnyWcyB7HZ1jLJksLDRcXYPhbm20FxhDeUMwLPn2U33Wj8QqZIhyRzdSgOI?=
 =?us-ascii?Q?98OB6OICBIgRGNQ6yFmZzAmtDml6dKwTBW+UJao1MZqslqjrEjZH1kaS4WRb?=
 =?us-ascii?Q?KhG7leBgqBL5MS9kPCCYPQMnLN8ClNkjTdf4KJfFoD2mKaTYmYUIeVcIKrmv?=
 =?us-ascii?Q?OzIrUf4dAsMJGkkunjfVVhfSCaVacdxJZMzS/cJHCP7t/3ibuqk1lyDWzAB0?=
 =?us-ascii?Q?Of0bHiScVTwRHQqgSeZxUWsDp5LLnwIqnKH58ir94D99cWm6FUk2n7jL7rvs?=
 =?us-ascii?Q?+ADoMvKGXRFu1Sp9bZCLesmi8viC5mXqVViKXghqvaV0vFGqCb/F625vZ5qi?=
 =?us-ascii?Q?NReoDhe/sN+8l+lvH4tm3uVbljgStzO69EBUuUqEROTYmA4NLVGDPy+zZaUt?=
 =?us-ascii?Q?gGT/Yi5a1EIXfU7NVTIRxrRi7wdpt33uaFSOThL05vLNljhNJOmiy5LKXjAG?=
 =?us-ascii?Q?k8ceSQXjpKB5UDIrKSyIh2kUcqsB8HRSX2PpNYFof2z2BbKhkD2K0N/H1qUo?=
 =?us-ascii?Q?MYc8oFV3ALHb1qSWVu0Spg4RA7r9BxxUdsA6fwLFwgUCZwZ6q/rK2UosovUO?=
 =?us-ascii?Q?q/kbTrudBO/tmqQnX10hgOY1d8iLh8qK6BkfItJU9ArX00ycJimBFmMTVlUR?=
 =?us-ascii?Q?z99L3FimFrifT1P1cx3uTNNMQAd6W+qe2QrSLqc4JGstzZkF3WXYNnzuzuLW?=
 =?us-ascii?Q?2vezbRYoZQyN3f0WoUJnWCvNobDP/zTI0Gp9MudVSRmUd3LFBPstmESpRVMW?=
 =?us-ascii?Q?hiINLhiLnGrDPvADQ1aqOoUK6MYHINGe0nA/agcGD0hvAtB5IJej6Ot2ydww?=
 =?us-ascii?Q?FAG4s58X+Y4KkUhnFjWwxzE8VVbm1qf+jCeI5t1tJqmA1OGe3Lwrj3b8tKh4?=
 =?us-ascii?Q?n9yV4FaJwf0A+fwMGLh8MvlzdtTjXSL0ojNo9CWfdAtWeM81wOKVhTfrcxKE?=
 =?us-ascii?Q?MksuR8pRTxxhYawXhPsAo861TziNc9Ky6tS9F93w?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6763.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d729e673-bc6c-463c-8b82-08db31a50bd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 05:01:54.0638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4GtzFLJvpjBybnvo5mvIzR6Aj8f6fx1py+gMBUdS+zYMF/35LhNr+fheAVVJd2GM/6xZl7a9LVRRZq3SpYNxEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7790
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Existing VFIO provides group-centric user APIs for userspace. Userspace o=
pens
> the /dev/vfio/$group_id first before getting device fd and hence getting =
access
> to device. This is not the desired model for iommufd. Per the conclusion =
of
> community discussion[1], iommufd provides device-centric kAPIs and requir=
es its
> consumer (like VFIO) to be device-centric user APIs. Such user APIs are u=
sed to
> associate device with iommufd and also the I/O address spaces managed by =
the
> iommufd.
>=20
> This series first introduces a per device file structure to be prepared f=
or further
> enhancement and refactors the kvm-vfio code to be prepared for accepting
> device file from userspace. Afte this, adds a mechanism for blocking devi=
ce
> access before iommufd bind. Then refactors the vfio to be able to handle =
cdev
> path (e.g. iommufd binding, no-iommufd, [de]attach ioas).
> This refactor includes making the device_open exclusive between group and
> cdev path, only allow single device open in cdev path; vfio-iommufd code =
is also
> refactored to support cdev. e.g. split the vfio_iommufd_bind() into two s=
teps.
> Eventually, adds the cdev support for vfio device and the new ioctls, the=
n makes
> group infrastructure optional as it is not needed when vfio device cdev i=
s
> compiled.
>=20
> This series is based on some preparation works done to vfio emulated devi=
ces[2]
> and vfio pci hot reset enhancements[3].
>=20
> This series is a prerequisite for iommu nesting for vfio device[4] [5].
>=20
> The complete code can be found in below branch, simple tests done to the
> legacy group path and the cdev path. Draft QEMU branch can be found at[6]
>=20
> https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v8
> (config CONFIG_IOMMUFD=3Dy CONFIG_VFIO_DEVICE_CDEV=3Dy)

Tested-by: Yanting Jiang <yanting.jiang@intel.com>

Thanks,
Yanting
