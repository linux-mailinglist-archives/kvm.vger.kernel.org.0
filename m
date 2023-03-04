Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144B96AA8B2
	for <lists+kvm@lfdr.de>; Sat,  4 Mar 2023 09:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCDIWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Mar 2023 03:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCDIWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Mar 2023 03:22:08 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2365E19B9;
        Sat,  4 Mar 2023 00:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677918128; x=1709454128;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SegDPYkXBGP4Qxm+tlqTdxHVodiJeV+hYvfA8SYBjqM=;
  b=dLSSMvD9tcCjFnE913aBlJjDk2U9+GzJBtCsoy/TpicZ+i/eiIKbSpRr
   Df/W+fJb3lQ/ACm9sWmUbOZtnwLfgOdls/dVbkFpLcJblk9iLcl9vemjt
   +8LDgKHZcBzjB5w6ozovTT5IYlMUGAOTNfD9f0JeyLVB1zBwHNrSwGMDu
   paIX+8DX6XYTRtTQzGNQ6wHRI2FBIxmPC63d8gpewFTcc4POko5n1QC9R
   EmhrerLBMzvLLJ+9JBkHfMzwYZQbIVZ94Glt2y9W/T4bMZ3m0HVXTrzhB
   Tq8STJVtlErb6UfOBc9W+jfY/3mNi9NnTbfJ36HHOicK/81eixRnAV34g
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="336757999"
X-IronPort-AV: E=Sophos;i="5.98,233,1673942400"; 
   d="scan'208";a="336757999"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2023 00:22:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="708099386"
X-IronPort-AV: E=Sophos;i="5.98,233,1673942400"; 
   d="scan'208";a="708099386"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 04 Mar 2023 00:22:07 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 4 Mar 2023 00:22:07 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sat, 4 Mar 2023 00:22:07 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sat, 4 Mar 2023 00:22:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSJNGw6PT4pJfbNckehflxtSsNe6T4JShw+sOEPUn8I/cGxrFjJbN1o0iRwpIy4ZBmu26Mbun8X3YTHjSy+26WsXAxrmgYEat9Pqcm+wbzgEWMtQ1udt3ZzNByHVcSeC3uLO+0JKHjSxwe2PNGSiyE/RtPx2s6hCYIpE7iIotefUHfOjsVEXFjfgTvic97NqN5Tl14P+/zdPmM5kWXKGAK7a9cVeyOqc+/w+lFfg768/JN72Scm2UtKtAIDgvW6+thbrGTK0c3TNh1PoLwjQdEgfFN0Lq6lWKo1Sl8nWd/w7asU8VXN6GnBl3TQm+3c3L0kHaaFa4a+0ljspKeEtvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SegDPYkXBGP4Qxm+tlqTdxHVodiJeV+hYvfA8SYBjqM=;
 b=MsyRgF4htl1Ta6W4WFUvaEoflSljxh0c82S4+WBvA0/vM04BwWWO4JC0Yw9AiqVZu4a1EAfsDdB3FjpqYxA+Im6UNTBEg1/ANzp8zxyQVn4BWdfeB+SpXGLErqoBW+LH6RqO1zwhTwrFZVdGSXa88lG7f+t2l/UtnMbiQzcJptrSN6wFl9c+hJvrCLkgWxTM38HlsJH50Iw8J4L6YJ+WamWuCCsYNxy5Ycn266vZ2DlnsyvW+A7WojV2QoyE7uTpOqoEzbduLirP80HDlCMWoiuc8VrConpiI7O/WtMOO/BKm0LXH0oNSjTWd4qDLAB3fgfVJ41fAdX9+Nm8fFMliw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7998.namprd11.prod.outlook.com (2603:10b6:8:126::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Sat, 4 Mar
 2023 08:22:05 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6156.023; Sat, 4 Mar 2023
 08:22:05 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
CC:     "Xu, Terrence" <terrence.xu@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: RE: [PATCH v5 00/19] Add vfio_device cdev for iommufd support
Thread-Topic: [PATCH v5 00/19] Add vfio_device cdev for iommufd support
Thread-Index: AQHZSpxK1lmQCF+hqU67xTFYCSDhDq7jLB2AgACAqYCAAOmpAIAAn5IAgAILhgCAAOz1AIAA/j2AgAEMKwCAABZUsA==
Date:   Sat, 4 Mar 2023 08:22:04 +0000
Message-ID: <DS0PR11MB752945E5B57C4BD12BB554C3C3B09@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <Y/0Cr/tcNCzzIAhi@nvidia.com>
 <DS0PR11MB7529A422D4361B39CCA3D248C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <SA1PR11MB5873479F73CFBAA170717624F0AC9@SA1PR11MB5873.namprd11.prod.outlook.com>
 <Y/64ejbhMiV77uUA@Asurada-Nvidia>
 <b7c1f9d5b4b647f0b0686c3b99f3d006@huawei.com>
 <ZAE2J0I1LiBjWUnm@Asurada-Nvidia>
 <d59a0262d5bf423c9e49ad4ac6015296@huawei.com>
 <ZALspPvvLGFuK96F@Asurada-Nvidia>
In-Reply-To: <ZALspPvvLGFuK96F@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS0PR11MB7998:EE_
x-ms-office365-filtering-correlation-id: 234f7fcd-9a96-4261-79aa-08db1c898982
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5QPbL2i+Gc7Z/cXBtqe+O6nysrZhMcf7O903fzvWbilE4uwOCAB1HMYm2HQ422/YSXK423CGZqa/INoUdIphFYrbC3fDWJYHmfrOskv/gtKhVtiK7twEo8XxCkVpmMN1TOvaSkNvoc3AuSugD2wPqyaVt4Tdm1B9s6F9dxdJ/pl65xjV7aNteQBcS4hmtTwbnoA/awS5r9SBHSHZ6Wsaiko+zt93BypLgy3ELj4ZCvxw7eTSrXqVkorrS6boVB7DGsR0WRn+xONaFuUz3wpYqJEmw7FuVIh0SWtcqadkb6bsSsbd/VD0Vpm+myeSV8btFgbYz3VzY29f/lckqIUGcUlbsG817I2mWDfrT2Oro23vcNWFaLzGWQKC/i4nZ8ux3D2m2risSy2GTTwsgzwyT/P93bJUKP1t5hpEiBUT6B/71QtSIX33XIUUmmyIyLrK1R9Q1NargZd2QlV2ew3cQawGwE9qjmX7fS6zG8fAcB0LkGC173GtHXWZPS1cS4VRqCXzZvBTM339TBJmd+rUNhDN/RtJjUBBOS3ZqMbeLAHJosOobPkI+5T+oAQQ/ybquTjW1ISWBaLtcS+vG1ecuvSVV92Bru5T/mdBnzBHWAEvW7oj3S7dGsb7nHKimZ26xEH18Xb4Q18Jy3/PxQN+iU/MO2BEfPBP1N64TRqOaMcLc2UNTkSBdhw8Ft60buEsuprhK502+K9BBTPQjxORBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199018)(33656002)(6506007)(9686003)(26005)(7696005)(71200400001)(82960400001)(41300700001)(186003)(8936002)(52536014)(66946007)(76116006)(66446008)(66556008)(4326008)(64756008)(86362001)(2906002)(8676002)(66476007)(5660300002)(4744005)(7416002)(38070700005)(122000001)(38100700002)(54906003)(316002)(478600001)(110136005)(55016003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9gSA4Vj7VK7apIL2aOhAIqwdC3yce4tthmEDka3wG7ZoIs2DHzlzsk3ozN2v?=
 =?us-ascii?Q?WZkCUY98mYR+1OV8QVeGJcBsH9/Qc7Uxcoo69XAqZ5npZijHzZG3wSaB4vt+?=
 =?us-ascii?Q?efjYufXFtn4sHRrp7M8ILwx62lT0h4HE4cfthHlXeQ4OnYVbAsZN2tyCcCAZ?=
 =?us-ascii?Q?nwKf3ftpCU6mrKtVLXz0gkLS+8XpOkMJwk0hNhvcpU+9dlMVD/HyNr81nllL?=
 =?us-ascii?Q?9FAm2vnrU1bJoLfi+gfb8+YyYJBqty6GEzetNLEJtC1FI7Hcna37DI3NXJJN?=
 =?us-ascii?Q?4QGl1zVmOyaKwDlUBjFxn6hvZmfkmFRiy/sFfGYMsToeCfpkJqDQo9GJYW1P?=
 =?us-ascii?Q?Khg3LbDpE/K1JRxglvv7zlpqt+SnGSfqO9ihZjUoWzqOYLgMJeOpLl4olq2/?=
 =?us-ascii?Q?wua7gJRmMXK3oPewurxwf696Lj/KMQ+tHgrW3PofVsRiMO2n3exktrFLrp/I?=
 =?us-ascii?Q?0x43DAcAzB24LBfB046/ps/h7vqYLjp5dsJa4EIdLOgK9OzIxEc70dmZebBQ?=
 =?us-ascii?Q?+hjk6DRJj9NLE7L1GEzIpgITSeaXIM8Gjxt7Z6RzNMaMV8XtPpAOO9ubPu7O?=
 =?us-ascii?Q?mVhWsoM4CEm6gQWwBAf+FCi0jTdshav9R5nzPtZPCMZ24KwAFdOmFM3M2pU+?=
 =?us-ascii?Q?tSQDtEPnGJILFc8j8gnzEMBCCeesaqtCs+KGRI+rRU0mwqqnLSy6gKn7T5FS?=
 =?us-ascii?Q?YFMjtiickjV6c8nVdjMgSDeLj6zL7ZEMVWtc6mGdYgSWXEqfByPbD2k3R6SW?=
 =?us-ascii?Q?o+XT34r/eystwMwXpCsTxweWxoOR6MGeyEix990pL8LiiuRyqbp7RS1ROjUc?=
 =?us-ascii?Q?R0UeIFATlglnnz4XODg/pSELM5Seu6i1rFViqxDgkC9EA6fT9AaIUH/7NF9x?=
 =?us-ascii?Q?wiArykW+73aQM0ZBUvzEOkgY4vryKbrEwMiwRlyRQ2l+rltX1synQJ+A7qTs?=
 =?us-ascii?Q?Z0yl9j3KAMXbwtinZrQ2HRzLDimjwI/3mFf7Cppq1fW6q/OAK4UxUOMPePYC?=
 =?us-ascii?Q?rAC4r5p+bgYXu7L0HY1fawn8Jbx79TrtvZMUENK8M7pl7aDTNwHwDnWweVse?=
 =?us-ascii?Q?Ms+dx4zur8fbz90SZ7N7Mc2RkYeL1lnErZ0tiK3DnsG3hEyIzg9+uLDT1lEq?=
 =?us-ascii?Q?tV/ro1QUX672bcQaURtodqaAX09p0sm0JiU9fJrE+KKaEKI/51Cn/cTOX8Ap?=
 =?us-ascii?Q?E1XyD7nwuYOF76FBgdZL+8jQitksWxUiFnMyIIn3HXu1cfiC5LxU/16UUDQd?=
 =?us-ascii?Q?YNQBU7WnFi01M9Qig6YHYHWyxktdMwpyTynCSja0X/KzZ0d+jb6y3673HB3f?=
 =?us-ascii?Q?qMLWRrfAEowB/1XHozZvlmDb2Y9qgyvKabFnsBIMqQWVxx0FlB55T8TYqGYo?=
 =?us-ascii?Q?n9EbRjCYA0OYP3K/ptkg2J7YsHieAeZrdH2RDLor178PErqW80MCjb1QbgAS?=
 =?us-ascii?Q?A2hD7sGgQ4AZRV3p97IKQpktzWOlsUocO4MmBfP2PW8ZyTieWi/sf0M1Le9d?=
 =?us-ascii?Q?5HMm0TNiDf8OugsapCB57DqTV2wSX5oqDxtFVvo8maeNUi5AEvQlPTlt9Lvq?=
 =?us-ascii?Q?gU5TjyQlTQG1qwq9r0ER72sbog8N5ATQbg8lbS1f?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 234f7fcd-9a96-4261-79aa-08db1c898982
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2023 08:22:04.5558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: evIrv/RVL0/mHn7gPNuQtcnCtApEC+4wcB1T+lVppQO5HMsNarThSHR0BA0xiTRAU3l4pvmjpTD0I77eoX4iSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7998
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Saturday, March 4, 2023 3:01 PM
>=20
> Oh. My test environment has been a single-core vCPU. So that
> doesn't happen to me. Can you try a vanilla QEMU branch that
> our nesting branch is rebased on? I took a branch from Yi as
> the baseline, while he might take from Eric for the rfcv3.

Yes, I took the qemu from Eric's rfcv3, just plus two commits to align the
uapi.

Regards
Yi Liu
