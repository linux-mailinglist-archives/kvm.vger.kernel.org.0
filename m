Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBF979AE2B
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 01:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbjIKUr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235305AbjIKIZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 04:25:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B93DC;
        Mon, 11 Sep 2023 01:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694420739; x=1725956739;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3D37Jm485yTVeWCYc9nC5wtH6ixHOQQoxA5I+mxHUKg=;
  b=i7TaIRGyETgzMGp18jl5oTBI8htyWnkZTjV7VV59vD4JQAwutZIdhlHC
   0WHDXWBICd8P0O5mHKHmzJxFp34oPJ5A20fBwvetNAbMKsWsKICRDRaHV
   JJZWEI0H0E7wBJ7DxOM/bY3BwV99sdgm2wYFxjqRgtpQjFbXCZ6aBfhnC
   nxCnGJDAoDwTblQS/tmEtURS8B5PHuZ0aMUOK1FK6AwdIpv0SjcgtvtSV
   Mj6sckYtds0DkR/hvY19+bkVVWJgGK9ZawEafrT9NoxzUM76ZjRj1JbfF
   SL479Vjxz1QBkBTlvnba1EdRV/HFrLtR2k11bxXwiEZOFE5Q4Kjxa3qBf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="358329848"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="358329848"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 01:24:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="916944462"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="916944462"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2023 01:24:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 01:24:19 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 11 Sep 2023 01:24:19 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 11 Sep 2023 01:24:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfFS09noRy4ESY3GCBZ+o2Drdg2GhPDBnMJ/Ly7IPwx5ZxODyxdvb06zpFLEzJ9cYaoijbzm3kDQVgC9IXd7MsiGOVNu4d60dwE4HlgRFFiT1n621MAh8OcBOmhJOJ7cCDwM4ZWdb/1KLD01f876HvKd3awJX/3gJzfYccAcUVLOigV6TrH3+jkjqMfjht22cty+miDc9u8MzSCa1647omC09hZFv2caNo6a0JqcMXjXQjn4awaQHj8zsrjj9b7NjLZ1l7zdFo6JYXLDvKhZduiX7iXox24IISUVBMGS5kL5E8f3eZOO6OUSbI7Jjjk3rkx0+uYTEYgoD4oqMJUvBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3D37Jm485yTVeWCYc9nC5wtH6ixHOQQoxA5I+mxHUKg=;
 b=bvXgwG6j62aZQpWtAzr+ZKEWIShX633I/TLDlVN57p+1ZpDAR6vWn3ePOmidM5XH1m4ycb8yKIA9PDnooOW20E4mcLMXxI5/HO7USTmNL9l99HuewSlfRbsSm3Oc7NOYiBDGVH5FRVATapv57dvAZQssH66TdA5Z5srovRss0vwrzI/+nFC7ZuYYXR/RVb3i5O4Hh6BNe8QEV/uoNtotN1Ut/72vWOR6LmTa/P2Zw5jGmiKuONisiA3qBYdlJBdu5VAt9KCQm1QrMq5HjYdCdZG0wy7FZtdWr3xLscB5aNbuhD3elO27BoQz3RcOr06y5p6EPj1jcVDmxKdeex0TGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6291.namprd11.prod.outlook.com (2603:10b6:208:3e5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Mon, 11 Sep
 2023 08:24:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323%7]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 08:24:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Ankit Agrawal <ankita@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        "Currid, Andy" <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v8 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Index: AQHZ11GKWAVxhbL7fE2VxDNOQbtCXLAP2/IAgABN7YCAADqIAIAAUAcAgAA5YoCABGFuMIAAEvQAgAABAWA=
Date:   Mon, 11 Sep 2023 08:24:16 +0000
Message-ID: <BN9PR11MB5276CC0D0E21F8A1C335A3828CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825124138.9088-1-ankita@nvidia.com>
 <20230907135546.70239f1b.alex.williamson@redhat.com>
 <ZPpsIU3vAcfFh2e6@nvidia.com>
 <20230907220410.31c6c2ab.alex.williamson@redhat.com>
 <ZPrgXAfJvlDLsWqb@infradead.org> <ZPsQf9pGrSnbFI8p@nvidia.com>
 <BN9PR11MB5276E36C876042AADD707AD08CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <BY5PR12MB3763D6DA3374A84109D0B2E7B0F2A@BY5PR12MB3763.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB3763D6DA3374A84109D0B2E7B0F2A@BY5PR12MB3763.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6291:EE_
x-ms-office365-filtering-correlation-id: 5f4dc396-ec27-44e5-56cc-08dbb2a07d40
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m+SIYdmDfbj8QTTF+pRQ+8i+RbFdm2KzoFnWPRETnnnpbPH1RnjVkDME5OeR6sc20BZllH4W8SIaNVAS55rAYwtPgBr6BXsf9rWRLauH1bHbtrCJKM114+KNa+GYCKFPn+5wTVdrhitUqSvBtkOvZexklpwSCQTB3tJy6ykoqvKBP9HWjFb+Ak6QbWd4RQ+lCGadDvCG6RmlULTgu9U2W/UefVl0fBjgBJJIVY86djYoCk3EVKVlOKj+ufzBVnJMY9qcEpgURprqmmM98nMKovKK0RF43Qj7w29nA9sNs/+GB0fEx9A6vageTApAvi51eQFtmwV03HwLfY9PHOwl5G9U63NlcEHqILg2NDx72l99UpccB5DGdjsEMoGIFk+YVuMnWFSYoV/B+mCTxJjMchmNktcWgfFoUcBFhj6XBIi9Do/pRlS6YdB9k+OtMtogi49K2J5ivSxB4D7AGDmcv2XVEry3noIm437eWg930d/KVKOhG8PaERL30/1cqyfTe5CT36BaO3izWZmm9kpb1ZjEZQYW5jlfgjULCJ59EOsK3wq/NQti+lI71J8lcAN9lWqqAxibPovMYhwfJI7ZxGBxxK4hiI4PSOk1OMKXnv8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(346002)(396003)(136003)(376002)(186009)(451199024)(1800799009)(4744005)(2906002)(38070700005)(38100700002)(33656002)(82960400001)(86362001)(110136005)(55016003)(9686003)(6506007)(7696005)(64756008)(66476007)(316002)(66946007)(76116006)(66446008)(52536014)(4326008)(8676002)(8936002)(41300700001)(66556008)(71200400001)(122000001)(54906003)(478600001)(7416002)(83380400001)(5660300002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Gnd/DmsiE+1p9TPtgXe+4z9+oogU5b0O9qPS4CjfkAJa2XazHU4lxqNa2FJx?=
 =?us-ascii?Q?AmQqIIOtrEvF0kGfoWdu1p1r9XYOi5Ya5NleOm+Z1e64ksGWgT8i6Ekjb8d2?=
 =?us-ascii?Q?gDpbEug1oATbDyQnJ/6YJJ8U88R3UhyHWIpdtX5Q99iEiy1nRHc9Mh2JX78k?=
 =?us-ascii?Q?MzNoGqkE4qjlZHqwLgm9NKXa4R7lRXdc/uWG50fP0wjItMvVt2yHvqo0umpC?=
 =?us-ascii?Q?o4FaJzrm3pH64LtYbAAntDlEKR6rykkzXN+7yQpb+H5I2zQngdrmdTaleAI9?=
 =?us-ascii?Q?BLkYP4o2dun4ZSQQYqLy0YbmfpkBhsP87aERgvjcwR+2nnc6Ck46XGPC0vuz?=
 =?us-ascii?Q?xy2SwHiy4h+lnbEtI5dp4fOp/xnz/0ZMP5tSeKnLT7G1gLR5LhLjDSOq6BJf?=
 =?us-ascii?Q?Rcr7zpAJW6PbX0OhcFUcLk/2fG+jm81PWLfvtmU2nEsvyQPL7By6zrHfN0Kf?=
 =?us-ascii?Q?EFU8WfO3s1s2dhnWXLc12SUothrD/uHTMejqsuByxNp5GyPoHBs6Y+gkQnUZ?=
 =?us-ascii?Q?Tgz337TbqxwJIj6FSHt3xQ0Cly3/rbyVnCRLZJXu8U3SI8h3j1bWyL6DK6QK?=
 =?us-ascii?Q?tV0uOmWLh6Mz8cSMKIvvq1uEw+Op8/LGgL9MWjtuXAIWGItu22l1ePjO186D?=
 =?us-ascii?Q?vIAoLG1RbUePPxlkeH9b1HHDcP4c/PFinqktIDbY/qWWeQnHlV3Gy+dM84ql?=
 =?us-ascii?Q?OeLixFsjHSG9+ftF4ap2DIYnft45D7+4+AUpVbZp00YIlWIa4auyIWID6M6J?=
 =?us-ascii?Q?pdyncd3pso5r9vQnl6CjxBE6lrrZEfG6xQJG05Rxy0LFqpRULkLiFWalO02X?=
 =?us-ascii?Q?uebKfkhKHwQJa5bVTEsD9vlM3oLnEWei5RmjO0CAM0ugC+SJ18Lg9J1STELl?=
 =?us-ascii?Q?p4VfQ7uCiWMSusLDcaLMZD58plvO5zKvu7n6zk4qXG4hKNELsXUtlcUX6Ezd?=
 =?us-ascii?Q?9ebeCBrwILDIfR3q73u7mveFUfEHeopIEqcAtvi5p94s6hocGItN5zV/m1YL?=
 =?us-ascii?Q?/6L7rQVhAZOYGqOnKneEu9omxD6K6WSO8sqXEfqHYt3y6GLAk0DvZtAsS/uo?=
 =?us-ascii?Q?rz8pA2y/4rVFpR57HZRAvy3/AEtDfmbLfsyvnex62Rxzcdf71NJWF87cwuAO?=
 =?us-ascii?Q?KkfgPz5Yc5SfYNrbxpnDgfTGYNWqNw8O9Os5fJ/dGM392JyHtbASS46RG+fY?=
 =?us-ascii?Q?hE9Pn9Z0gnnA+cUavmVt/4wjyz3hcqJ8Qz0+n+MxNK48QXAPMrOSzi7dQuQR?=
 =?us-ascii?Q?mSRpHqeUlvOvqrcfnqUfcT5Qjd+XpoSlq90G0jwmNqSrwYbhraj96JRN7+hj?=
 =?us-ascii?Q?SWhxwayIDQsCutkhAx8pKOifyrcxwLpB8rfHeQz6wD0/RYr3RpLbKadev1Ha?=
 =?us-ascii?Q?dn7wH61PZquBPwtHcZY0gpVK9WCLprS6t6tgpD8euqBEj/OkFErjX2xTQjVy?=
 =?us-ascii?Q?OfwGAWhnYVafC8JrOUDLIDnzmuSXhV+fu5pxml7i8hIywszyupo2MB0ahVnA?=
 =?us-ascii?Q?dFVx4pA9pM5q5AYgVs6LC/4PiWltv5B6j4dXmcNpbPtYswjK+9nN0MB3e6Qi?=
 =?us-ascii?Q?3E1EtbDG22/NlveWsZ+mJOaagmTdOmZywXS7E78N?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f4dc396-ec27-44e5-56cc-08dbb2a07d40
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2023 08:24:16.8808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1JznKOOucPhYO0J4okVaxmmNwPvHIu2+hWmi99JKMFVJo3obVTyaI6Ibr6toWny/IpXNs0Duhp6Tz8paT/m9eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6291
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Ankit Agrawal <ankita@nvidia.com>
> Sent: Monday, September 11, 2023 4:18 PM
>=20
> >> I don't see the goal as perfect emulation of the real HW.
> >>
> >> Aiming for minimally disruptive to the ecosystem to support this
> >> quirky pre-CXL HW.
> >>
> >> Perfect emulation would need a unique VFIO uAPI and more complex
> qemu
> >> changes, and it really brings nothing of value.
> >>
> >
> > Does it mean that this requires maintaining a new guest driver
> > different from the existing one on bare metal?
>=20
> No, the VM would use the same Nvidia open source driver that is used by t=
he
> bare metal. (https://github.com/NVIDIA/open-gpu-kernel-modules).

because this driver already supports two ways of accessing the aperture:
one via the firmware table, the other using this fake BAR2?
