Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B946CB74A
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 08:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbjC1Gh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 02:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbjC1GhW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 02:37:22 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F013EAB;
        Mon, 27 Mar 2023 23:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679985442; x=1711521442;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f8vwpIydkcEMQ0lgHhf5t3iAKVvWQiaOAI3YAhJQCmw=;
  b=LDoBgSeRqosH7ptXZhYWOuqostuvqug/gIQGsKDOFNleO94zxpz9EKG4
   kAvzSNc+z2VxqXGmaqJFwt0jZ9nBosDYLLTzfmwcq0q5dKKrgRh71iCel
   pYlo1WsdBSTVIi9w82MbH+tk6oiPRqtuDIPaL1OADgw4rOpi+MYdXf/Gu
   yOHn1ptNRdvpWwNsn9EnyHG+TPxde7sKs9UR+ltbvb5bNHpNBNKkFpzk4
   CYlF0fdg061ekkN97xAwU3tk3ovVRC2lEDyBD0xnz9vfNekGukoEfXc7/
   pKwPWlGXIN3q5prE9dFRy2vGAaDJISxmBYlc3pfURGmsFYP7QfNBK816D
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="405420974"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="405420974"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 23:37:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="677247611"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="677247611"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 27 Mar 2023 23:37:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 23:37:17 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 27 Mar 2023 23:37:17 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 27 Mar 2023 23:37:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPz67ubG7WUB7ZCK5rKhzww6jFyiI3E3gG0nBWvLtylp7X3wuFvvPPZr3qYW6wXrBNy1e/0x2OCOssthA8OQMDIotrAgpSTzb8Q3qkUCFzms4RzxLXlV5zag3oMrX9yW/5jn931HWextIpvuMsRPfasREqy17GYorHdvksAnvvVu0wLh20141JBF6zLAdSnEc0+ndnA95MIFEOYiIbUteO9/6X/4ZgFu0eJPFOFMvrcqsdRbK7+jn2KI48zReU2zzqJnS1Ldxgx+bQSRFSDTezW/NL0NE6KLtoJt1QujfyGm5V5pbImrCI7IaPmYtpABSN2xX1XZflD1Xd+s7+bF0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8vwpIydkcEMQ0lgHhf5t3iAKVvWQiaOAI3YAhJQCmw=;
 b=LXNMu+1mhwlaqmo/5EHnJuYWijtq8HzNqavgzkxL0fYlNtAK4+KPcik+ptv9f5HcVcFZyUL6kTaLtdFNNrw21JMD7/GLGH4f63zFHcilLwT08oixZckPxRX28CBNNwInD2WUNcOFkMCjo+dwVnSlGXSnX6O+ISQcZuw+Bkv+HuplAL7jq0pczkqzrPAu3U9jZnwI2QsiAoUv3iSpYc6TNUz52uqHLgss+Coi+chYQJ5fu+Y0DVPHKrU+t74pc9t7/LKS8lSvpfAFp0rhVsAOrtEmflduqi6lgeXYKRFAao8AN+aQIHhjK8sb/L+dKWnW+/ru8Z+Dg4YlTM+y6DMVIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by CY5PR11MB6114.namprd11.prod.outlook.com (2603:10b6:930:2d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Tue, 28 Mar
 2023 06:37:15 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::410d:f336:9014:8675]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::410d:f336:9014:8675%9]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 06:37:15 +0000
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
Subject: RE: [PATCH v8 19/24] vfio: Name noiommu vfio_device with "noiommu-"
 prefix
Thread-Topic: [PATCH v8 19/24] vfio: Name noiommu vfio_device with "noiommu-"
 prefix
Thread-Index: AQHZYJBEdNBBuNQZLUycb6kERjKjma8PvjMw
Date:   Tue, 28 Mar 2023 06:37:15 +0000
Message-ID: <BL1PR11MB5271B51317864362D4D297D18C889@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
 <20230327094047.47215-20-yi.l.liu@intel.com>
In-Reply-To: <20230327094047.47215-20-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|CY5PR11MB6114:EE_
x-ms-office365-filtering-correlation-id: 7716c8a6-1f74-4497-8d1e-08db2f56def0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 60r30YohNmqiKMvrSiGgYnksbpt8xx7XhBZpXvMHw1pLZo4SzvpFg8uKTtBxx0iukIyeIJ8NACDZX0sAzLGCeJi1e2NO8H05IiIPMZmPo7M43DLljHXrnng9xMd8DvWGhBwo5aBQaEdWssr/wM2US+fH/YKjCA0RphCPWcViGedZM8Yk3HLuxKVZNzWi6Ujbts1wMrIAaIaJj2nkpTD/v8lQ/JV8t1lZ8Bk8P0fQXGW934FPUJyGx/sL0KdjrJmeegHM6Ab21JjJtPs5GQNwxn0z/LZ40adJbv//tW7YrpFtQrUSQ2M3KVv+GbqBWsdrKtiZ9AKUENIsUOZzGvxeS2qS1S5NagAyo3NSLVJ/aiFJmaMTYlupmZKZoTp4yVTltnHjFe6RbQiM2qOamWWpKt5nStkeY35cp74y4Fab8tywgZpp9lmXxG5oaK/1JbvhfD/oki+tuqipVl7UK0O5+F6N4YlO9bPW4iiPeMSnv5dal6bS1r9ZOfAcBKmOy3KgTlNyMU9uezyYC/eZvITub1rJE2/1zETYzi1gaO9vvGGGdRyT3XQuGKhHJb3vvkWFn7DVg737X/vJ7HiEwLZ5MTP+7k0GQHjISYrd8wRMY6g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(39860400002)(396003)(346002)(136003)(451199021)(7696005)(71200400001)(9686003)(186003)(478600001)(54906003)(6506007)(26005)(8936002)(52536014)(316002)(7416002)(5660300002)(41300700001)(82960400001)(2906002)(110136005)(4326008)(38070700005)(38100700002)(122000001)(33656002)(66446008)(66946007)(66556008)(66476007)(8676002)(64756008)(76116006)(86362001)(558084003)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QRRkkwqH4bgpFcWTBPO/qiTrDsgmczocInhkKSIrrQXhoI+YwduaEN/hFiJ/?=
 =?us-ascii?Q?Z37jx2jsXi/8QELoAq7O1KWjPlcUAe88Cnyo1wAwnLZKn46ZTyQLyVlX3gcV?=
 =?us-ascii?Q?dCaQ/gnVxbLlCVo3R5ACnOurfZNOP9KUcCwsanrtfmevXK5QdXHfxWjcBDBW?=
 =?us-ascii?Q?3dWq87eYU2xWNzTld1pXr9uXxx8bEQVDuJJgbITHR4YT+MzJcJiethC5ob4y?=
 =?us-ascii?Q?IRLm3ApVKOUCEM0FEkKf6tGvXjyMBB5cfUb+RJxT5GxSpu6+ByBneRWkeMxV?=
 =?us-ascii?Q?lwZLd88SZ4muIOmamyy66ETlWRrbkKU+bOFTx5n2Ob5gpf+525OZ8yWkMn4b?=
 =?us-ascii?Q?JiseTbzfCfa31R+IdRafCo2m/TRaaDFOmbq4REOvMooqzRJim0oXI5bnQtzZ?=
 =?us-ascii?Q?KVBx5xl+P8On3CI4htD16yMg+5R93pSJeBUYvZl1PKJ89/fuieQD/4BqxeZ/?=
 =?us-ascii?Q?ZiHzJYF2MrRn+HqJb6zU7yBx6rpE3L0paz/AtphtpRB7MSC31jTsTleIKzUf?=
 =?us-ascii?Q?07LC1biHKfc7XWAP/EvKPQIRg86P/M8/QszIUHXk9zOk/OZjyVo4zLVLyIBl?=
 =?us-ascii?Q?15GuUrG+FfxkQpcjio23kNyfR+uumruyCIftueDzf7aiUIyrbfK6WC6X9jC/?=
 =?us-ascii?Q?byiFPKKMi2tA4M0VhEyAatzYfbtoJ7FT0utXiqyh9Y55Tq0GehsjacEE2+ep?=
 =?us-ascii?Q?j7Llc/0b548N9UsJO3BVssz2JKjJAp/8ildMgzzAIFlj5NOWFaCXDJgfcboa?=
 =?us-ascii?Q?ismNdEi5+T7MNP8jnCUd1zhSuXDp/uznx5MmNDnrFBQyEXrB7R2Lyy4KBlKC?=
 =?us-ascii?Q?j4PD2CAsQTcHq1UB+lRxi6XmE6T53EBIbOifaA1cK5ZjhSLfYx0vx05TciHQ?=
 =?us-ascii?Q?3uL1K8YKLaqp/bHgy1MbIXPhkNA2MLdrYWE7TxtmvD60nmqXoYysFhvyE39+?=
 =?us-ascii?Q?tYMAy9cgIHehmZ4CsEYm5ckq4QAaqhXR/gKMrz/+PCJzFGF/+8kZeBPW4lRi?=
 =?us-ascii?Q?moJYTjpk4dHHCgoC8u2whbKi483KF8O5xHpblf5sS2PrL8meUqL/DroICXM/?=
 =?us-ascii?Q?veFEJutKGlk/73ducSqtFdEmofpSYgwcGI+k8NQjhvQw3PiEZyjS+hkMwPvE?=
 =?us-ascii?Q?280TyA+XQsW0c+xuV9FVfDFatisVvN4RfwLX1QUp1KTypEbiCboA4DvDhz9R?=
 =?us-ascii?Q?qX4mZbIkkbLxVKbwF7C4SauBVx+DEB/Zy6Yt5Q7PMzKfBz8xMCcYwNBy0zVd?=
 =?us-ascii?Q?xACxPBEtq2Gw2DEVuYX8ByTDURO9TVzozXNTTH9YxhC1EqZZETtBih/Vfujj?=
 =?us-ascii?Q?3pnxV1M2ZBG1GJ0W69O5KuqtA68oNid+bUUZSQoTf1VLJf43SvkejbdRNW9F?=
 =?us-ascii?Q?+y2tmgzssxYBiJF/wkaFMeaLrnL7qMPw3Q57lgPBFYx0Zu451srOw5r/jkqc?=
 =?us-ascii?Q?ytXpDA30eJMKQb+R8omMxOrPbW2pKn+WELRn2sbNgqV1Llg1hEMWmAk0k5pX?=
 =?us-ascii?Q?mGXBkOil8llaqBNTwlbLMJtAqnCaeUdifEE9XkXHtbJ5YG5Gh1Yyo3LmbiPJ?=
 =?us-ascii?Q?TSZjft0/l6Mtd0tEsqbDZDfAYlmUXhT3I4D+cK/z?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7716c8a6-1f74-4497-8d1e-08db2f56def0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 06:37:15.6784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NSrkMR1Yr51B2ZscqCOu01KcK8tPQ3RtqpAfqySfs6pdHPmqDibhLypjz27KDGBGya1u9smzlNxDg81cJ02a8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6114
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, March 27, 2023 5:41 PM
>=20
> For noiommu device, vfio core names the cdev node with prefix "noiommu-".
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
