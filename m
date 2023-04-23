Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B636EBDF3
	for <lists+kvm@lfdr.de>; Sun, 23 Apr 2023 10:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjDWIYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Apr 2023 04:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjDWIYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 04:24:07 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2630810D2
        for <kvm@vger.kernel.org>; Sun, 23 Apr 2023 01:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682238246; x=1713774246;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k8ylOURsJ6W0u8+MxMgUik7AEj8VFcJyZwFPJUondak=;
  b=ALS6Kq/7uG898xRJpntbcA/XMxSsv8BMIH4BWt2QfRoZlzH6jKX0OiX4
   bmxu6eGcDogfrQHKP02jXskcVWIIpuBBBoEKRijY7JtVRvs64vfQCLaGd
   aC31vVwgdg1NannaSuCEkEtgaIecRSufErDyK32z4HHaBhEPkrsLdsE7E
   TUaQz4L/MpFWRW4st/LJrNNaQJ7+fBeSUWmcqXkvDb/7wKk8Y2sBuYYt7
   KqKrA+qDnaSdyntEMISzroqtS/v9VxVxQlG54g+PnYYokdGaMkjGgNR4k
   p86i5ZDwgvmtGaw8GHJx16BNXuWGyNtZRS7dwwmR5kcBbgH67+RZ3DlMZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="346281702"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="346281702"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 01:24:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="642983211"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="642983211"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 23 Apr 2023 01:24:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 23 Apr 2023 01:24:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 23 Apr 2023 01:24:04 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 23 Apr 2023 01:24:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdkNnhMO/yuW/0lWVXnb6BH+vsvTtA7/mny0XJgD7QWLCnhz1xJ9VsNVf6bc5XafiTUPsHdjHK8DyMptQHwhDnNWtpcHxh5BXxBHHfkN7K+QCAiPog1x97do00sBE9Fuxs2JhU89uu+uWkESh8TDtXEaHwnQn/1rYeGc4bURUBjFkpAteETD20xYCvY7DerK0im4uM0u+Gts0Q6F11m7mvrY2H6DP7NUHldiogOn8c5vC48wYQqHunC6p0Q5SgiMh0HE9SW/InBSKROAcAng7yWU96eVuHFZfWV5tzkRWr1N3G2TDlboDdSNefuVzHf4uhcqDJrkKoGuqIO8rKC0og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k8ylOURsJ6W0u8+MxMgUik7AEj8VFcJyZwFPJUondak=;
 b=d0aibyEylrJJn9v/dumlLWLtDeUz32q6UxGPjQB5rwwM3BgJl9ZyhIxQcVzmUOcDVBHy1BoiBUc0c/D8ql7P91+DuvnFT8IpoG/HBWYzocCH6q6VIV6RA9LP2KIY3ZWuOGQYnNqKsShFYpUzmzNO93XFaQL3iXDYHvZYUNU+m0+RKzZnnkYAdunYKusFfyaZ9RshFFa3ZOek2Owo2UsWn3obPWqIRLvhDl+BuhU6bDTa1U33E3arLx21gTyzs40f6pnc7/AunWZ2YGU21WO/oAwEGQz7gY/p/Wbig8nzlUQBZD1xkRn+iUOMcS9RpNZSqIL6vcgCX9QK4/rzDVRvnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB6797.namprd11.prod.outlook.com (2603:10b6:806:263::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.28; Sun, 23 Apr
 2023 08:24:02 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6319.022; Sun, 23 Apr 2023
 08:24:02 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: RE: RMRR device on non-Intel platform
Thread-Topic: RMRR device on non-Intel platform
Thread-Index: AdlzU1l2SINtdgKASzuG/OHqnI4zdAAPzvCAAAAmJYAAAQTsAAAEaOkAAApGNYAAHd47AABc227w
Date:   Sun, 23 Apr 2023 08:24:02 +0000
Message-ID: <BN9PR11MB5276723C89B46201F471F7E78C669@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230420081539.6bf301ad.alex.williamson@redhat.com>
 <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
 <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <ZEJ73s/2M4Rd5r/X@nvidia.com>
In-Reply-To: <ZEJ73s/2M4Rd5r/X@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB6797:EE_
x-ms-office365-filtering-correlation-id: 4da109d8-a8b5-4dc9-5933-08db43d41882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x4JJubsZohQD1GP0dzGiJXxV0sGJeYNHCFbP6D5PHzT/FIUGsOcB65rw0WdsXkTT+yLJ9RBbCEKr+LIOVUoiqR+ry87EXC4ekYZ4A71NKaTeNRMQdnpM8KMBimi8MmK+wv/rmvfG3dCK2jq3EAKlIhRLC3WAzhK5qAX/O0HoZzvOUcJGYksI3iiydeVVC4PKp3KxmxlVhYdfQ2ca/F++Ezrn2GnbUuxMzcoS9hRXtilwcH7SIBJ+CboYrs9Xn1hr3IwY2o3Jxq3GCXy1g89EyscQHeYIy4YOM3Fh15OvFIJRjSQHd6flwagWzJwAasrbvOErLScsfSf0nB9oTRdVesY6WNQW1IbgTiitOexeSCc/7qAw6q/s9xaFybQmtn3VR2yUC+chb1mB8kTB5jnD5ayTkiP1MvXsbFW/NomMWtEMwlFHDr0ffD4RPtBCSU3ANVEiqFXsEDW157m/7pHEBqpYLjhSsXJnattyMj/+JL5U3yCQx4B3JvcD/vR/h6Mpjv5R5yqpG0HJYnkuzRaPNhEQlBaWAj2N+btA0HUQkGUDOyTy2P+yqOutCPspGNjlJkSlt2wwGCuZ2pHgv1Qvn7QLkDykI2jCleUuRPZdaCI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(39860400002)(366004)(346002)(396003)(451199021)(110136005)(54906003)(4326008)(64756008)(316002)(76116006)(66946007)(66556008)(66476007)(66446008)(478600001)(7696005)(71200400001)(8936002)(55016003)(5660300002)(8676002)(41300700001)(52536014)(2906002)(4744005)(82960400001)(38070700005)(86362001)(122000001)(38100700002)(33656002)(9686003)(6506007)(186003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YQB2XVRHONr7o7m+zBfkDel08qzkq5uiP3biaofc3aaX4u8pbD/C2YtJGQfJ?=
 =?us-ascii?Q?3BKjrDbiz0NAbQT+CzZcJpeD9sSL5UAAF/+zbIUt2JIxL4AZ4aW9SKetOx2W?=
 =?us-ascii?Q?CON6RTJWwMJLC0qIvmeD7XaKZgkP0NOh+Fr+QIfLwKNYKISND7lXPbz3+Y/Q?=
 =?us-ascii?Q?Lwc0XgOFgQb6p2rZGVt9bG+AdJoZSQqDAbn9Fun4puKX5vaJmD7tEp062827?=
 =?us-ascii?Q?ZT40meM63JnwAduAXOJiiEpKpejHKqhmPANF8OQ2CGIq/1jdvZI4DWhsyacT?=
 =?us-ascii?Q?fHva1TmmKLKDyV6Gf92R05MuDi0CQjCU5W9l+suXYipeOxLsDnhChOoylsm0?=
 =?us-ascii?Q?nWkQY0hLF4Oss7pLBXuT72a8bnXFYEosbV2muXRK7x1b7oHP3X+RnMo0jnC/?=
 =?us-ascii?Q?CZ2cNG3YXUbaHjA/ae0Y1n1GUa7rhsnNEASnVfkJcrjf/4HUw11RQ76zauEd?=
 =?us-ascii?Q?qnitS1IA1uXhc55ew6DCDO7OaUdf1xnv9nJMPndUP0FihbhuJ5/Y1JldpZRO?=
 =?us-ascii?Q?QwnC/nJb/AW8JVHoAMcsS7uOmAc1+YdPCkQ6z5m3KuZvg6PcbsFj/wEsKxhk?=
 =?us-ascii?Q?+L8Kq2YF/TLFU5OlcBm/YJwp85+2DawPSf0K7MPxqKT4dvURCMTaIKAvplY1?=
 =?us-ascii?Q?DLPHBBnqLxgm+x3bkN7Z4g4EbOqS9fgHfTgBPljiacKlxWPAvhNqFq5daYEk?=
 =?us-ascii?Q?HWBD8XyPlkP7n/USqiZnaLiBds0y3I767c4qRYhCY6pghqIKcqOr3+3BO6F7?=
 =?us-ascii?Q?NlyexQtU2es1Fle1JngeBMGVmPpMI3MSPMMcDkRyRJ/H45xHiYkfUSGijilg?=
 =?us-ascii?Q?WYZjQthTEsfqqBRyVO/3hndfQMAd6qCShdYwLwMA9xwP1wujQ8SDSjV3sp1d?=
 =?us-ascii?Q?VvaaQ+VWMfJwFrltSGKVH2MlSF7yKn3stenfE3O0OnLhPjrWkrf1EGwFgArA?=
 =?us-ascii?Q?YoFfMUksh4PMomaV3vwPUmBzT5lJ3XN5BjcRo6Ok5lodN0XVmssfRIRnAfQH?=
 =?us-ascii?Q?jqqu6X7v8GOiDi0d+bngHnV1PD2zXZIwl2ZlTjrHkvtfbYyLxH0ImCLkw8FO?=
 =?us-ascii?Q?1htStIB52jEHXxVE5UWzdZR38oRUT9GtU/X85Qd5avpX8pOAltmGg9+1bHYi?=
 =?us-ascii?Q?eIasv+uS4lfdKes5CxptoYZ6h94hCBWgKHGddjF+YX5BhliYvdZH/keSbHNr?=
 =?us-ascii?Q?cBt2S5Hm2hr7f+SeJR70wbyg8PFDxLg2fBZOJq0+ldVJu7Udr9xNJKXyfMbo?=
 =?us-ascii?Q?pSfnWa2b6LfxP1E/YXWdiPWBg4wGzkDzTq3HGKBqoafzyEe2vvFacRDQjAA1?=
 =?us-ascii?Q?YFfrsaakTu1CZcCvGm3k+D3nSl6YGxtsYsA8uyREZ88TZTmt+DvvESYLF86l?=
 =?us-ascii?Q?cjBw+yA7KhD7K7ck5NrV7kYXUAuTdQJj90pSOtSnf2QjxT0Y2w+7dgvKTYUL?=
 =?us-ascii?Q?SgxuNBBlr3qbYY7isenEGs0sp2YkuaOr2b4c9cDl2F1s6Zv8xgjqYgJjflbe?=
 =?us-ascii?Q?k0RfAyRSYBcLITl1bkpN7+SNDuMRP2nLfXH57ysFIf5G/a0w1fdIeNsLt9Qm?=
 =?us-ascii?Q?rLzjz5+EXTPVYDfd/INcwcfqqWlnt+4fL4O3WC5S?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4da109d8-a8b5-4dc9-5933-08db43d41882
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2023 08:24:02.6036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KEV/Whyx3M8KRzWsAReNhWd2337hCJ2MGgW0EPwg4rBxQORZgg8q6FXl3aKf/ZpGkZT+zLBNUDs6J3krne76Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6797
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, April 21, 2023 8:05 PM
>=20
> So, after my domain error handling series, the core fix is pretty
> simple and universal. We should also remove all the redundant code in
> drivers - drivers should report the regions each devices needs
> properly and leave enforcement to the core code.. Lu/Kevin do you want
> to take this?
>=20

this direction looks good to me.
