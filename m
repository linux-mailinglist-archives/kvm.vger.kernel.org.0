Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1B96BDE42
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 02:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjCQBpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 21:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjCQBpK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 21:45:10 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37BD7DF9E;
        Thu, 16 Mar 2023 18:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679017510; x=1710553510;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Tqqeb//JDcylMBHaZaVGOlX/9vmJt/8q3v2ltEVvcXI=;
  b=n4SSMtJYskGGBvkYq/kNQgV0U6nK7SG9cyJqFAp0EcH6TO61ICZ3oJTm
   FCPO6inzxrEbOB6X69fnqyNUrSWUm6H7fHf0cPp4D79OBTEEMoNDnUNWy
   lS/VwjVxfPfmfR4E7HMCRbcbv6OZm8Ed09qEjXNc6R+b7LGKciMh/HwCA
   lD9k6Ho76L2a15PmJtmlE8bYbb2aROspunlbMil8R2HSzolOCJ3JzfR90
   nOf1uFGkIklUIGZOlgod54qN/C/ZkTL8SkNuVtXwxJmmeHUTKsnvyJyvr
   LGsSIWJnW2JHFOuw98ko8Jao901g+aXuydUgc27mHsH7EsFkciIxGe5Oc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="339698306"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="339698306"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 18:45:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="673387647"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="673387647"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 16 Mar 2023 18:45:08 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:45:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 18:45:08 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 18:45:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NzoHVhCBy3aFXMQAADb8/vhTI9UO6YFJhGHLgeRvlVtSTIblrB910rmEn6Bl6y5ZGAfNWdsHe9fBaNY7xfmjRER+esKB7IUrvcDns4qPJYcFmpZ9BCbOC56Jf1SqjOfPz+ZrXZGj2+rXOdqoe/w2fljxerlbY4L74uCu9xHUbDCivLa+8T1Hu3bc7xFQobEZz4lRQVes9hULVm2XS567r/btQetJk8scUSNcBm0bdl5yoXZF0whrdz9wotHexQzFxms+/05MAlBBFjbJHFS6LSIyNaYwmmlXyCOH+muc3xdNfSfFGpRR+zsWy9Nd8eexheNDxE04KgFkFMLCpjbQ7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tqqeb//JDcylMBHaZaVGOlX/9vmJt/8q3v2ltEVvcXI=;
 b=g7xPGX/yHVj9fH8tCZEKCVRQc74DGQWbnapwp95z7xHrL7wYyB49sceeoInysQ3MT5h4iLfVIaFaJfnbjkTk9AsluTR9LC+hJl2le7kxD2iOuzLtL4SiTv7pc5IbWpOGe5QkKE8qhWJYkgnOXI24z07k+3eCMsMgjkY44V7WAEDDAsf9irgo856u1Y0UFTTv3yU8xgTl17//RUYBFujmi+DeV543pGArrOJwWXV9IYAzzCgGQSaKWbRgLkC90VVzhZyCvcg2dINL5tVJaG1RtHq1ep46iCUbZdrLG45TGwuXPXzS5Faq79FEBifQ+/AThI9aJSbPLLV0enqRhAQsdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB5107.namprd11.prod.outlook.com (2603:10b6:303:97::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 01:45:06 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 01:45:06 +0000
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v7 11/22] vfio: Make vfio_device_first_open() to accept
 NULL iommufd for noiommu
Thread-Topic: [PATCH v7 11/22] vfio: Make vfio_device_first_open() to accept
 NULL iommufd for noiommu
Thread-Index: AQHZWAaqLA8SiTrxNUuffMJURDdNuK7+NAnw
Date:   Fri, 17 Mar 2023 01:45:05 +0000
Message-ID: <BN9PR11MB5276BB0DDCAF3E08BC3DE83E8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316125534.17216-1-yi.l.liu@intel.com>
 <20230316125534.17216-12-yi.l.liu@intel.com>
In-Reply-To: <20230316125534.17216-12-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB5107:EE_
x-ms-office365-filtering-correlation-id: 0ce5a8f9-c5a2-4920-a840-08db26893bf0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y8Cxt0nfifPsLHCL0Ynh4nfjpD5HA1t7ERlM+j4p2Bzfm8p0X/xPZhxSeRXznEQKBM+yFfmIjN1dX4aw3cbUTB7wzy+v9UV/rpzQ9ZUpUMffDEYi97KjRLspSRfxul3gerCt58LSyRFYnIljoGqy1HmbxsyyJblGfYN/qMkfi6DFyPpCCkk7Go8npQ+ysL93nUOmpA6rwx5bw4+9cRS+H9BTYAQN6BBtLrpPXSiQnm3XiLMt7jaF/jH67Kkp473gYGSHH2MQFlr/j94nQeO4393UGXDKuWX0UT+qnagI6/6Y/D5gonkpqFHnAOeNxHaFv60NMBXWuoDTzRIPldNHoDhLveBeFbzZ1jBWGHs7I1526VNvXofeeitthC68G5YxIjLfLcOji67x+KaFJfF+J0CIGiTQAs9nzCeTHM6r54TuzUJ2h8hrroYRD9LWXbsjDqlRu3ud+lpQxkNC06F2oy4N1hes/jRcRgRA7lTdwRGiUf3E6Fyv/pxA8E83fS/SgDjC3UYlPXEYN2JWMz+U1/6rZ/f0M4wPsXEY12Pup3cJrvtCtQmljNG8kN3nwRwAQY8VKaI1unquOXTq/JJ1zfmR0MBONXk0BhMjUdYCMwjHTnNMGOmeLlg8DxxT5wkdB4kCySKPo1ntV6ai+1WjQqwo7BASgglxjnMPJfAyiiNwdLy7Ucx1ePoDX43v5F/i7qN0/tzVsIiawNlQpvySnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199018)(38100700002)(86362001)(38070700005)(82960400001)(122000001)(33656002)(2906002)(52536014)(41300700001)(7416002)(4744005)(8936002)(5660300002)(55016003)(4326008)(26005)(6506007)(186003)(9686003)(83380400001)(110136005)(316002)(54906003)(66946007)(66556008)(66476007)(66446008)(76116006)(64756008)(8676002)(478600001)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NWlSXn+nMm/6ziMVI4ZSxozHMr9Jp/obEAEDU5O25MBL8pltD/kdtwOUfVb2?=
 =?us-ascii?Q?6ZP91w/oFN3pe6ezPZUllQHOPqouemHtFQsM3HyTHSvhYvSYoy6IDk5tQOvH?=
 =?us-ascii?Q?aDugJbnX7fU2ZtzhTx5VNSJJwQ5+/xZKkAwLxw8PM3hB38h7hAy20OAazzy9?=
 =?us-ascii?Q?IhzEu0LGT1r1rHhlf7Img+CmmP1zB8pxaLbMYgFsfGI1m3Ia0w983B6lkm8z?=
 =?us-ascii?Q?677kGfd7mxdBb8XynaWmL70hCHlTuX2dKQv8LWrs/5q1SE0wEb1xry3EUE2X?=
 =?us-ascii?Q?2NmKsqv2+oRPDfPHOykfqw9+dzX7AQN0B2fk2xRDFu2IPzjkdQdjceO/PaqW?=
 =?us-ascii?Q?BOSuuik7Msht87dIxe/OEH7uZT1/tYuwCcLPm1uiY8GiloqC81Wua7A9JDRL?=
 =?us-ascii?Q?XYGcRJErlWtmd4wHlrbGZ9QtXpwN7V7SHQxP8RpMCrj919azsCUF0j41LqVp?=
 =?us-ascii?Q?iqR/l7IkB2TUM9mVPMjTYwbOSvIbxEqpFf/BtWo/qZ9IihHnD+m5Osvdaben?=
 =?us-ascii?Q?2bG8zBMORZhUtVXE29USinuZH2Mdps5UVIYoG4Ip8GKIMNJYXkhocfl+Yu3C?=
 =?us-ascii?Q?PfL6J+JaGRoltYxgYJkTzHaBLpazNTqygxqumqeke2hzm2cAVZ4AaAh1cYRA?=
 =?us-ascii?Q?/Dp0S/Co05J2S6RMKVJcFSyI5ie9oUA8eQNKQoDGMq3Tb426uOSDsohRdc/6?=
 =?us-ascii?Q?U3T3pPYX/Qczb89RAjSVDGfj5e6TQu+t8220XonUBh0MSFNzlQjGpxMcZq8g?=
 =?us-ascii?Q?hyNBWXS2PxmDHpJmJ0Y9kfsp66yqSc7Vl0owAcctxihXbLGHof2dPbOKhraM?=
 =?us-ascii?Q?ErnkH7zEQFlrsmpk1dxFkEnm4Yuj6lgAT8+CqgE8N2boSEhkhTj2YVgsbC/O?=
 =?us-ascii?Q?BSdRdZJfCUM2s4qP+Hu7gTPvWV2bWiAqvE8PNYY+YIDVF2bXboc6GcOsFTuN?=
 =?us-ascii?Q?CX/ik8G7WUSZtdH7sJ6EwNbzUUBcPZYo67nlpJyaogEQloWXB+Ds2B4g2X1s?=
 =?us-ascii?Q?GU6HEsxz44+82NKLfif03wYgdPvp0hxForsmu9598wnagzD4Mbsoh24Clk74?=
 =?us-ascii?Q?mZtptvIiN+KTgUFC6fkz/gSL8L7n1FyhmXUN3VJw4KHP5Dn13prcefc3VWyz?=
 =?us-ascii?Q?/Q0Kf/AfMffXVjQTG2MCj2X+o5q33mB07W9gA0HbgCH0ceOzq87QSaqS6Daf?=
 =?us-ascii?Q?7SHR//WF5py/PD8BDuKckTgw4FFkju7ujsStAjVoTv4+ktabkP4UzJkCsTZM?=
 =?us-ascii?Q?YowO4Ln5J74h1ybbrIQ8WZ5ziFqUXwBpoVBGcKF1oiJmXZmc2nHzYiu8jToh?=
 =?us-ascii?Q?0COv3yV71ZWNNo/x/FV3xqE7j9pLnPVPVr/WPBTTrcKq+FDpvZi1ln7Nb+kM?=
 =?us-ascii?Q?KnL1YbpRSQWFUi2i+hZe6X1VFSEEqqiBJyHz9j7/TLPi88Rb904MXBTLhMce?=
 =?us-ascii?Q?TOShJ53NfiNKu37lX1yecg6g1e5MnpOuQu4v/gjWKQio93hqCHSEUNCiaDP4?=
 =?us-ascii?Q?rIl4hEl/3jqVrvP071QPh8JH0PrwhZ26CSE4od6mNuM+N1UfQVOHSGMq1owU?=
 =?us-ascii?Q?RNAefWmzK4g95yEXpJDf0ZZZQ6ijdFZaVMOrTozO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce5a8f9-c5a2-4920-a840-08db26893bf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 01:45:06.0591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N7p+nX4YlS7BgjIA+ldI8f/Pj2Wmc9j79GBCFSstsPEZdmujfW3ooBbtLabxS0h3IlYePZaw3vItqPfDIsRc0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5107
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, March 16, 2023 8:55 PM
>=20
> vfio_device_first_open() requires the caller to provide either a valid
> iommufd (the group path in iommufd compat mode) or a valid container
> (the group path in legacy container mode). As preparation for noiommu
> support in device cdev path it's extended to allow both being NULL. The
> caller is expected to verify noiommu permission before passing NULL
> to this function.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
