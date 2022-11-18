Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8694E62EB95
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 03:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbiKRCDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 21:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbiKRCD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 21:03:28 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68938EBA
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 18:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668737006; x=1700273006;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=y++Jc7bJZkA0BlwGwHfCHrnrGLsS8ANLtj0W1LCiFxI=;
  b=RV6PLfTDQmNAPe/Gq0s88sHM0AAmA3RbXsFJT8c+FQk0OKhIuZMITk2S
   mPJGCyFlIcMhNF8FXoQprWEgqGGRGG/5bKssbeAYY7R5kjA2KsdV5YO83
   biXRdqN4D5TwsmFCt9wjJTVsbHyIF0u2OVjxBr2Q/GkqVRjtOyCtduaI6
   x1YR+0QRnsIjjU1rc+8iLUmqWt+31+L8CX7zQWbhVSdqFL0ZxS8i7XIYs
   6ifTQBCfp5z4kWgFFi6GYsvKZ1T8m8xBTJVZlZ8yCrcBwULzn1zZRUo0y
   k2Ir38xOCoETR318wQeJQ9FUKn2DWNQcOqTFGrXtnC6eaORul0THRy1bv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="339864250"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="339864250"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 18:03:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="640042175"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="640042175"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 17 Nov 2022 18:03:25 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 18:03:25 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 17 Nov 2022 18:03:25 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 17 Nov 2022 18:03:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yjin4f9FNXcvCSCZkLDw0Nb8JdKKAxxZwjQfL2ymQA0VX1h6J+MRTuCLtemeji4fQMpjgGNsFmQJdc6B64+L+8KFkeHOUL6esFQJdy3Mrz48WWlU6W5aRG5fXC9rk1ojIS/Ov6o9WBiHz4zLp33I25VN0EwOm7C1V2Br04IB72rtc4ivcWe2FiQhCI99Dimt+/wYUbUXDAY365+vsxpb3TqETcW1eO+hxcYFiCg+Uu9DHVBFkdtbzIWa6oGN/BXbX/lW7jQrYLeQO8giXVx2PlXUKI/1s94PuPk659tWTkb4HokKxiKN/IZ4tiYcj/6Zo3pU5avA9y1ccULCAMlJ9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y++Jc7bJZkA0BlwGwHfCHrnrGLsS8ANLtj0W1LCiFxI=;
 b=DoQG0gT5MF+AlgV8BEMCM2OgG/+YXH3mEc41zwdGRUyiHnOKTgbOs+fVIsUKep+MhWwebxj0z6iAi80skG9an6Q3LlR5Z67AJcnpLF3xG3NomKCkgE4SM9+crtw1zOM1AWMEn87prOS8qzxnX1zMgGYCDMskDrloZeq2DK3sWuO3iGFzS0raQbvhMIQ+XftGqCEA25ijNzFJ2Xzi8PUr5zBTZoRj8qqh0K8H6z9Pp+8UfrYaiSnB/3/5YVwhz5z7hytYw5/UwHJPw28D5nK8+hH7BiPJSpj4gabWu1KjYF7gmq9xJqhwKfetoeC7TpEkmyfIOW+fdEByEu5Yq90L9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB4724.namprd11.prod.outlook.com (2603:10b6:5:2ad::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Fri, 18 Nov
 2022 02:03:22 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::9929:858c:3d20:9489]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::9929:858c:3d20:9489%4]) with mapi id 15.20.5813.019; Fri, 18 Nov 2022
 02:03:22 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yang, Lixiao" <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "He, Yu" <yu.he@intel.com>
Subject: RE: [PATCH v3 08/11] vfio-iommufd: Support iommufd for emulated VFIO
 devices
Thread-Topic: [PATCH v3 08/11] vfio-iommufd: Support iommufd for emulated VFIO
 devices
Thread-Index: AQHY+gA4JC9CGND6XkOp1P8O75dcl65D78Wg
Date:   Fri, 18 Nov 2022 02:03:22 +0000
Message-ID: <BN9PR11MB527680D352D5AFF8E52626818C099@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <8-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <8-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM6PR11MB4724:EE_
x-ms-office365-filtering-correlation-id: b52ea381-ed7a-4c9e-f3b8-08dac9091218
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mzhzxURRKXDXB0NWBbZm5oxqgAZLIMvE2bHJbrDpmGQ7CVBfSWRyGHoGv2xTLzTf29qIuBp0X+JyYrV4hs6E3o3I6ayg/CDPxxZ5wnhNC1Lne7gLMTaWW8soKNwLmp9h2tAsB75W2B6q2sIxysyMGwVrsQDImyfrdvGyhguoAPmM7TBcHakhsTt443rjed+0gewU5WSvCr90iG3+gkpsrSkvYVikheS8COpFyDt98a/mOB1bBe2n5EeYf7sGbMSFf3Kq4V13hkRRbFVTHCWW2xfZ1oeMOhAjK30M7kNKk1p3ePkI6PnqZmlvIjXs28k9b2l/8MlvTW0+9HYattJYSliEQGLL1ae0ntQR6IV4ZTjq7v5c4YP1O737WzISgiNyRLvptMXWFd/l/bhu4yw07x1/JgG5T1x8HRxSAJ6wxRbMTi+sRdt1+YmMdFh5Imj3o0s5uNFcYuV9LEhBT5jSzeb5o5g/kZsYZe9GNlLhzGkdRN1RbKQAyVMBhRUg9Kq+CUP59vKROOTg93gOoHZnwowhirVqX3G16drBTzCKZs3cz1jZ1e4Ryw7cr72fb1OgtwODUQBCCO4Xss0+mVd7zq5Gl8SPquVWie1H5syktciIx9HXH8at6mQ9IMAwxrQSR/vEHvQqgPQgRwsJtjqtKPHK3FKWZwM1Lgn71Lv3YjZsvdBbLFiAjkgB4mgqi+Yq/mPS0CP/rV+eY2n4aNf58Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199015)(71200400001)(478600001)(26005)(8676002)(66476007)(4326008)(66446008)(66946007)(64756008)(66556008)(9686003)(8936002)(52536014)(76116006)(33656002)(4744005)(5660300002)(186003)(6916009)(7696005)(6506007)(54906003)(316002)(2906002)(83380400001)(82960400001)(86362001)(55016003)(122000001)(41300700001)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P5j3Gg7fPbdBPJ9KDP3pTOb6k2ryc1chyqG5dlMPm/g9VQxmb5boCNBI2KCF?=
 =?us-ascii?Q?wdWhsXZP4XaCo6BMxlRKQsSkKncS+yPAVMA8AS+sTS3DH1U5DWhj8dme7uGw?=
 =?us-ascii?Q?xc6Q+Xa/e3VSoSiE4on6OeeaCBtYhdxBear2QFE/86LYZlDlxrVXliA3Pg+L?=
 =?us-ascii?Q?HuCQ8B9Qa3yci71CMVqeqaFKaJktW9u2lD8P7KHWbtizHaA9YCGJNH3WRgwG?=
 =?us-ascii?Q?u9sUdQKUynW2fEfjJeSoJ2JaeRSkVaZb2rINmmCfr59IHEF/wCSyypdZi0Ad?=
 =?us-ascii?Q?sjz94oyk0cmRuRrFRZMCxBzVs190JsQGxq5KgLJpTluYqD39qKQEubkerpe3?=
 =?us-ascii?Q?3VbSTCmJgDZaS8mWb4DOy7O35CvRnL92GNcPZQWlKI5dIt/fP3/+ezPndkOd?=
 =?us-ascii?Q?t2ZshohFtqdntm0izmOzrn1H1iaaROeo26Rgv/O9XUBHxxSktm5pUJxYEqyw?=
 =?us-ascii?Q?2e7/NAlanSC6CkHXoxQLo/B05C+eO5w9wMcBe4cm/VPR6wRcdSDeTZYW71LO?=
 =?us-ascii?Q?AAA8WyXzoK4CTLGzy8WFq5UpAvOcB7A9g4emngIdjdr6E5c8S2ayIYF3r4ek?=
 =?us-ascii?Q?SdUQ5o8xVcEJZnTiDxmuVZ0qQj5ZkiNrbB58xZ0ApfryCmsENuNBzu7uCCem?=
 =?us-ascii?Q?2H0G5NRqr+crpOHa9ujA7a/+78nJ5MyeHeGaVxsVGrMSMmBY9La0WWFdjxQs?=
 =?us-ascii?Q?BqWGHUjDgrSsSApG86EXRtvb1GNi5Kcv3RILr2hPN8NxS3o6RJAKFoHJtpNY?=
 =?us-ascii?Q?zVB7r9wX4NPXRIUabvFL4DlU5Ehwu/GvEwGno6ABm4b6hv3ScpbS/70bAkxr?=
 =?us-ascii?Q?LxrX1dZel3Jq/V/pwSU+O6XFty0H/hb4KcKlWNxag1kUZZJWi8A5U2/VRH5i?=
 =?us-ascii?Q?OnXaUIkhziLOyxvJQMOPIKIAWor8cpID7BrKjrQ9qengbnuYjO8Avm1a+fqw?=
 =?us-ascii?Q?kLZH8qmBIyJQF3AhDXA4CPuteaTX8Dx1yWLyRHLetht08qxz3WK/3zSg0t/p?=
 =?us-ascii?Q?biiXlBtbZ+nYNtDiYB7Ms1iM7FFD5WYY+w4MmmVWPy1SONcd5PsA569wMvH8?=
 =?us-ascii?Q?JWoJtFu45SVcXWtPLFHxO2SYuL7y+vggNixQFzn698KG3ZqvMQtTvrmU717Q?=
 =?us-ascii?Q?AZztDyoOKvKMZP5ZEhGhAaumzk7qlPoyhKWXJu/3b8HxVbPW+hG73LwvVWtv?=
 =?us-ascii?Q?IgSZcPcd6lp4k9qEvibdZTUP/vXXD4t1Hw4lpQx23GnHietg6GGpuKLwfQL/?=
 =?us-ascii?Q?weswZDo/KX0R2t3BEP4EdcltsLvm0FY7EJUJBIoNq42ismmZTxg27YShZg4e?=
 =?us-ascii?Q?OSjCyEorSkj7ac9RYdQK3hgO3VtHaaqqIYuVKx7CXLgoVXUwCizhrDRGhu6+?=
 =?us-ascii?Q?E7inQ3WyfAni3JE3F/3HGbRY8iSrdfHdTdZ9oY/mIOWK7iUCz05ZFApyv+CJ?=
 =?us-ascii?Q?MlKT+OG7j+Q9bQ2qL8hdzzDI9tzVr1ulCda07CwhT4nRmj85RW15V3b7/na8?=
 =?us-ascii?Q?AG/gMT81+BgeFQNyxuAk9HhpO07bGJ69uiDuw+Tjn66wbfoxZiOKKbFAatZR?=
 =?us-ascii?Q?WcX69MJSvADUocBjnpIBuxzc/OOQkvXx5VTSj/yB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b52ea381-ed7a-4c9e-f3b8-08dac9091218
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 02:03:22.1547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2PWcuRlLBlYy5bEcMUyuOxzJOpOmY9Ny3zC8Dpp5BuzDHFqlkSqajO/dQZtYcWFeeVSiSVhJSexMKHj22JGP5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4724
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, November 17, 2022 5:06 AM
>=20
> Emulated VFIO devices are calling vfio_register_emulated_iommu_dev() and
> consist of all the mdev drivers.
>=20
> Like the physical drivers, support for iommufd is provided by the driver
> supplying the correct standard ops. Provide ops from the core that
> duplicate what vfio_register_emulated_iommu_dev() does.
>=20
> Emulated drivers are where it is more likely to see variation in the
> iommfd support ops. For instance IDXD will probably need to setup both a
> iommfd_device context linked to a PASID and an iommufd_access context to
> support all their mdev operations.
>=20
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Yi Liu <yi.l.liu@intel.com>
> Tested-by: Lixiao Yang <lixiao.yang@intel.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yu He <yu.he@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
