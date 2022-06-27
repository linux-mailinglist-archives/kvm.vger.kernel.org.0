Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63F855C977
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbiF0G5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 02:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbiF0G5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 02:57:52 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833955F6F;
        Sun, 26 Jun 2022 23:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656313071; x=1687849071;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GJ74egfCAIfjp3R2RhVDn/vzBqH9Y9BbPxTC35JFhFg=;
  b=ec1i60dwGgExQSAIbkxk3KJEuxYvs7987IBSlEc4Fgc0t6iqa2L0Fc1w
   jN6Ew7fTH5Ibz8X/mhKCOc6Q9sA22v9cY1JenizsOAlNQXvgCJzsQPboL
   t0jmNwU50k3fcSSrFzBrZVoZciPl4CWd0BUrCANWWoFC29EOvPNNq5V5q
   K7edHIrFKPClr5h0mEZGIC/KSK6lUjnEKImOQS4eonil5iB4qIV7iX4vl
   rKzXaI14IfUyo+I5OD7+itqgFiyLU9t4nQesWCLnEaT3sWrpCjdN4MT6B
   BdiZkEEmtgI7Pb7PyTM05/PaQA4LHaf2gJ8i14ZJsYrC4hBa+fyjQ1RXu
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="264419483"
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="264419483"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2022 23:57:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="616688781"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga008.jf.intel.com with ESMTP; 26 Jun 2022 23:57:33 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 26 Jun 2022 23:57:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Sun, 26 Jun 2022 23:57:32 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Sun, 26 Jun 2022 23:57:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/4H6BsGr1k0/RE79FQ2tSufXqCVfoTbXTEeK5Nz1FZoLcC9bs/LXtpRpK/o2OFepDdRSVIY3bh5aLyzXoGeM+vqvTn4KKQdy/idbrhXwoVKHDEf2V+xcOkW9jigO07xLzMEz+ewzb30Pa5ufs4l31Umq16h2XuGleWnXTpzB/8K+rKeu5kxAQzn16kIua/vGcMPBHKPYEEUji+rBee/DsxH0CtEo8e8sjSslQ+45MXuQja0NVnIwyAlkKxmjnxhC410jhLwHzCDlNWhMiv9EnAPeGhLENUKVh1GeBSP+WO2jxZi3P0+C5+X3mKKcQ/upXPFp3QfcG2pCy6fWD4G0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJ74egfCAIfjp3R2RhVDn/vzBqH9Y9BbPxTC35JFhFg=;
 b=FfvK4KyHZ3+9aUCSV8SLDw7SXXTeD3A54mj5i/CrHXmD8q7tCWstVUcELVWXA0K8exjg29vUHmceXYQUp7WxaAmu3UKze92Qc858sTne6ZMlyp2a2SxUoJRMVzbD+pTYrCUlZyH3Zdjj+SIm5OOGWHzUmTMGMjf0gohhZvvuXWE091U+CJmmbzaN0tsRL+teVUqSPmXVcfkdwd+SqQooDO2gNiWNCQqtJr06bSpWUIBo3ukJxLOD8qFcSkwX+cqmid5xsslXr0negXfYboNeYDR3oLG4Fn4BrQWuXY2GihHeh/w4mnsw8bFyk+tnt8oe3thNDVQ4C3d9gCIcSjv3Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR1101MB2214.namprd11.prod.outlook.com (2603:10b6:910:19::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Mon, 27 Jun
 2022 06:57:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 06:57:30 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "yong.wu@mediatek.com" <yong.wu@mediatek.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "thunder.leizhen@huawei.com" <thunder.leizhen@huawei.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "chenxiang66@hisilicon.com" <chenxiang66@hisilicon.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "john.garry@huawei.com" <john.garry@huawei.com>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "jordan@cosmicpenguin.net" <jordan@cosmicpenguin.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v3 5/5] vfio/iommu_type1: Simplify group attachment
Thread-Topic: [PATCH v3 5/5] vfio/iommu_type1: Simplify group attachment
Thread-Index: AQHYhzwe4VU2czSkkECgi7i4dXum561i1xTw
Date:   Mon, 27 Jun 2022 06:57:30 +0000
Message-ID: <BN9PR11MB527662B37F6BDB3EE79F3A5D8CB99@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220623200029.26007-1-nicolinc@nvidia.com>
 <20220623200029.26007-6-nicolinc@nvidia.com>
In-Reply-To: <20220623200029.26007-6-nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d08ade97-d304-4d78-b73e-08da580a4dd2
x-ms-traffictypediagnostic: CY4PR1101MB2214:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c91xJ8+DANXwUlxMKqmOF7yZVjjzefwDQb4/RCpizllo9kGvnmCMTIqyGIKRvLRIbTC8yfg50CubG90FeHab/Xs9wCAH++oEuf5JdPv8Lkla+Dfnys5pxrwcL05hvDLuGyOtXTvstP8rH/L54iCby1awpeOP0BG3DmW08tqT4SekwaWmouNPUxokTa5GvH6329uraexMddwhOoeXK7q6y+ZZP5MupH28UC18HVaGE3C3FAMEacDdHNOeDy21ytxpKMhO840M2RgvKo/xsW2hECnK+Sc35daOZ6qNcXtbMt8Uaq/sCb4qbhA8u43QuRaCAfTIiyUxlk6HiDOWkDOpXvKeQfDpfILXG3haa9d1G/78W9Xit7aG+rvi1vHYsl/ZO5pCst5M86d/5Ynh0tRY9HdOSansSa8v95owYyfHBTjzpWJx8k9dr0OMJimX7ZIciT3+VMhfBTy9O3fOJVhJqIh8tKi2bZDAkl1Y7hAbVk2fAapc74+N+vDFGnK2dvHPFsgNrVZVGOLE0bpPICzj0sEfhrifcaDZLS3k2J+dJo8F0BUwk6riFitFnGZ9vOMnMcYOdbhEK23+mWHBvItCGUpSPASRDk2QEAfEquTQBk1IK/DvknDDdHQMT2hh/mE73wui3bfQ3+/Zk0EpYnNVpuy+firjF8lneKiBGqjOioOnoCWXavdEOC2nGuMgkdZEo4gVNEkxG+v8wlsj5HJaBj4JWjoTdKEQz1L33B3DFQh54hXCiMYSR6qtYPx3dcqi0khNVD/wELw0lOXfUlEV3Uzi4p/MgYclljetl2GVXwfaMDErAjhveXXB20+MIVF1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(366004)(396003)(39860400002)(136003)(41300700001)(55016003)(66446008)(83380400001)(64756008)(4326008)(316002)(71200400001)(52536014)(86362001)(76116006)(8676002)(66946007)(9686003)(66556008)(7696005)(6506007)(26005)(54906003)(110136005)(478600001)(66476007)(186003)(2906002)(38100700002)(122000001)(5660300002)(921005)(82960400001)(7406005)(7416002)(4744005)(38070700005)(8936002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?U0ISetns/7YYIPmiG2s/ghnARNAWiMm30fqBpO86rgtEjJELKEK+B5L8OBS/?=
 =?us-ascii?Q?E9/IQaK4vDRc7ltxv4cBnHCbWGWMKFOJ8fFugoJZINrBtPCyNNBoNpPES6u1?=
 =?us-ascii?Q?+JFG9rm84t9y0SDO/nEHyVBltIR3mJcM1NeAGUkzBoToIbr5Yv/gdFjsN+9g?=
 =?us-ascii?Q?ZOFJ5ax29o8giHH1pdD3qf4kew+e+BN+y+HDiEntnpSrOeNksRxPWlNFbaSW?=
 =?us-ascii?Q?8mI2ijM/kcaKclLbCxf0O6aWBKjkyTStI7KPNZ444sq5zFednETHngR/Uqgn?=
 =?us-ascii?Q?vK2Pyag2GRGOOGttGHPW5PCPmB7s+APd+hkSHfzirKypxeOz89teLnd3wtID?=
 =?us-ascii?Q?djL/nodFDfWdzYCUOhEH7A7jlS8pVq2Wvz1IbrYLME6ziuuMMGM0RV/npmeF?=
 =?us-ascii?Q?CpcvZge7WdEnIzvv/UhV05doEg5Wu2DXpfWfXLYgeK9n7Ee3+ReI0i1drMAb?=
 =?us-ascii?Q?n9/jxbcOz3ijQlB9hkSpUen6d6ezFa0Z6yZsvN/cgD1DMmGlz/zheqPbHkWz?=
 =?us-ascii?Q?2a66CyGrlqUXWY3N061Xm/WycLp746X/dy94KrQFMoHJjwH2niv3AosURIPQ?=
 =?us-ascii?Q?do/KyOndALws/OgOHuy4C1uHBg531p5B5WcAfI0BZFTrD889Atdi00O0XRMj?=
 =?us-ascii?Q?QY+hMxsFoOaqxNUFpp5b6PeVNo8FExijXIYmj46nXwxc2cuQoSlNPsB8zn88?=
 =?us-ascii?Q?FR3TDmimGlf0XVEAgSRsoNiLJRBkfBs1cE5B/i5ysfqI+Xm1iuX66JCiXkCh?=
 =?us-ascii?Q?Sehlv00B5nMFUixPmvwbC53KxW4bXyQEvAKtW6Td6Y3RNP9HejyamK6iIG3U?=
 =?us-ascii?Q?VAOUq0Pp1JQ4H4IwHpLT6zV4aTSWE2R4dRpGJrZ6ZKZiENzhQ2Fjwgc6YRE/?=
 =?us-ascii?Q?dD82glrEEhpBM5u6VPZADFDaWvoDu6ToChe0GI/+VBdEWqK3vEtS+BN0xxFz?=
 =?us-ascii?Q?6/ahqg5IIrzomKBrlV6ng07ABYGH+gy+kNpVr2WwR1oIbMoLyXzeIck/nI3R?=
 =?us-ascii?Q?VcqvDzvSosUB22s2r0j2/r1jCbRr/dCJS1/Snsy+qmw4l309ZpToC5TNiTBm?=
 =?us-ascii?Q?yf8quB+InfG0GowStcwKySduRpVGNgahe3l+tAL5B0BxYzyfXWu9SGJFvcG6?=
 =?us-ascii?Q?EE82SPXkBDkLVCvoo+Gf5mJNnxaIAuGj91LFiemxTcbY+zSxx4ueJxDFZRzz?=
 =?us-ascii?Q?zKQgf/8DS7+cGgE4AK3P4ucZUuc8C3fF1RtDCUSxGYa4+Q95UKZ4jAGd2U/r?=
 =?us-ascii?Q?wFwf2U3bMkShez0Rm00o1z1Gl+CrdeZQ/97N5dR6yc6apBg84QQ7lbiwZhwo?=
 =?us-ascii?Q?A6aFYXjKteJxdkZ4LLZXgyJuj6ccMwaCf43NomvFbHx7wUowZ4BhBGPc8V/2?=
 =?us-ascii?Q?+ea3SLTNNSV2ubsrC7L+pJgtNwjxxjCsbf6LY+DsYYtgLWi4P+dgCIvNxkjo?=
 =?us-ascii?Q?Acvj07cfdtM+Ya8wcEwUPnN0BIPF93RBMK4i7+V4cnFngfvPNjv1aE+qi+Yh?=
 =?us-ascii?Q?tXIyhWKX/RneJFKfXy0MFZ/syqSFN78NgmzKiouVnr3F0dK15ZJenS2t0iKu?=
 =?us-ascii?Q?+vbFa8YRcRHXhbI8NlzxlaB83rawatEoWkV1uq34?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d08ade97-d304-4d78-b73e-08da580a4dd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2022 06:57:30.4606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZLHODCDg/nvbZBmzFibGKv+r9QBs+OyrmBQIEqfgN08DJbr1ExOA1Ow83yk+7JPwsISi8JiKKs/gF/EVF1FOVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2214
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Friday, June 24, 2022 4:00 AM
>=20
> Un-inline the domain specific logic from the attach/detach_group ops into
> two paired functions vfio_iommu_alloc_attach_domain() and
> vfio_iommu_detach_destroy_domain() that strictly deal with creating and
> destroying struct vfio_domains.
>=20
> Add the logic to check for EMEDIUMTYPE return code of
> iommu_attach_group()
> and avoid the extra domain allocations and attach/detach sequences of the
> old code. This allows properly detecting an actual attach error, like
> -ENOMEM, vs treating all attach errors as an incompatible domain.
>=20
> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
