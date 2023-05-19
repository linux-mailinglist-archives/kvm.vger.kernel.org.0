Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38774709113
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 09:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjESH5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 03:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjESH5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 03:57:52 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5875EC;
        Fri, 19 May 2023 00:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684483071; x=1716019071;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/qxv4+BbNRAxTy6ZvbPt+94viybxSW0G8pXLM4yrke8=;
  b=ciIzBYpRfacB74Qirm82RcTeLjbri7R+mMIbI0I4z1gQcioDy/EwGlHH
   NMKjBPxezIHt/qhJHhdRrkAwBZ1U2U274ubawCC4as41UmSPRgxH2DptG
   mismhzAaR4aNJB9jPGjuxX9eFTBJNO8L5WsHlvafMzSCL9HQf8DAUHguo
   g+2S5n1yigM4dDyWZnPavcgKsI17MfqKIKSGSB+QrfaH+z3x8O/nzdWSx
   IVw7ImYzy4pvhSlD5onanCwM0755cy+Nre91WN8Lzook3E9VMJ4IO5A2V
   Dmt/AEmvyzC4ZABrjfMesMh0jjpOrR2eAjF2JC1EEzI46mXOhPn0Gactv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="415775422"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="415775422"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 00:57:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="826705687"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="826705687"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 19 May 2023 00:57:50 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 19 May 2023 00:57:50 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 19 May 2023 00:57:50 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 19 May 2023 00:57:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QpzNyD2X8bx+295c2FP6EhCvktKIr1GZUDF5BtLQOLEO2Fula1cer+WyC6ukPtf2+wbmTz36iI6NYIpN0oUtL5BRDAqB9iudcaM6R9DrQlE6YvBd7CUObk3TkYZHR0VLEyO1lNMK4UM7yblWSfGTBbAh+5u6wmXkExM5f8qRf/9lj46brkdK9w8FPcksHMnIzCTmBim26V7hBhmBwnPcfObmGdFo2yRZnfbDoRcmvl28nyycBv4HUUqG+fjv2IeKe0RHyX7DFOi2Y6v7LvJWrw+X3vULGzbbfOP/Ld36k7vvbQ9D6F2nTn3JAk6DqgTdx7mMgf+wgO54CE25aaCNfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uugVYbZKC2aCkJAkxhKMvsJEp897KW/T+8/jJYIfOCk=;
 b=XHpQDhqih1OvoFg4g5yLU7suEVCpxrFQNrCFZ+HQ4BLw9AA4N/2eNsj/Eu4KLzYpvgR9vN5rXfz92kJj8Gz9yA110NBPtLBRSn+sGxPOceHV8nleQPde5rooDJ+UXNxznkvJTfD1fheJZKECuRCbRPXsycO7qLibwTLw6HdZAOh6SrJOYGmSJyrFiQ9rpL+UOjRbV2IlBVvJn0xFdUWQeqptUooDGUusJcOoZvmFcNIYpT5xJhMeWNtHT36qMUp+ftGakisIbxwoGBZjNq0Wa4KpFsjl0i32/lfP8YMPUau60CWMuseB5QK5hoVY/L4iPukA+R1OVa+uA2wZobOJZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB5505.namprd11.prod.outlook.com (2603:10b6:610:d4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 07:57:48 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6411.019; Fri, 19 May 2023
 07:57:47 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v5 06/10] vfio-iommufd: Add helper to retrieve iommufd_ctx
 and devid for vfio_device
Thread-Topic: [PATCH v5 06/10] vfio-iommufd: Add helper to retrieve
 iommufd_ctx and devid for vfio_device
Thread-Index: AQHZhZ3ivLvfOE0VdkGiYgWNYrYwC69ey9SAgAFBgYCAATZ0YA==
Date:   Fri, 19 May 2023 07:57:47 +0000
Message-ID: <BN9PR11MB5276570278B6FE08D93DE8EA8C7C9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
        <20230513132136.15021-7-yi.l.liu@intel.com>
 <20230517121517.4b7ceb52.alex.williamson@redhat.com>
 <DS0PR11MB752963E14A652AEE1A1C2699C37F9@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB752963E14A652AEE1A1C2699C37F9@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH0PR11MB5505:EE_
x-ms-office365-filtering-correlation-id: e17d197d-696f-47cd-6f8d-08db583ebc5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: of+jxVaL/BzKbQllugyGt1tInLOimcDOcLLJBB2A0FFlRYUywFcT1mu0v35yfsnc5d0asXooTrix4zIUhekuLuXkBnUeLFffIR7GlAu+CHM/tGfVcteid6J2RBNZsOYBsQ1d6WOE18JfR0EDOPZ7YI4z4VApHxVN6CY5ncI1+YwioSrm6r5nfyue5/7DuTzjWJHeX21kwAeCyTldQ+JGQKwcJnK5S1XbWhXeh75L030azdiIdJQijuB07k2/eHrxxhlVYMRRHZFgsg4Unwh6TMJ7OyCJql74JHIRV1rUrHEkb/kQMCtFJnxgWP+ygtY+57jGvmTgIiZbPLQEULjjYafl7Aj38h6YJjS9bRK9QE+0GkXP5waNhiGwFufvPKhLeTbGMTG24sAKgbOCcK3nwlUqIW9wzD0t3QOcfQd7Hl/5BRG4M9GkMitCjpLoZ1H2FCn7mAbsH5/aQDEY6g28iroSSNwnJAB1kDG9NPSWPyiNSIljfJk6YFMWyBQNN+pdCmv16v7R8zy8Ogy0WxIYCHPGek8zDKEBKyaEiGobbrG2EDKtJ1+QEbAj2yjVYUKIpMXJmhzm79lzWCH+kOpPdot1W3zjzOD+fXDIcrUXMvyFI3TJChheXNk0FNpZortc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199021)(86362001)(38070700005)(33656002)(110136005)(54906003)(316002)(4326008)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(478600001)(7696005)(71200400001)(55016003)(8936002)(8676002)(5660300002)(52536014)(41300700001)(4744005)(2906002)(7416002)(38100700002)(122000001)(82960400001)(6506007)(26005)(9686003)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SJw0ItrYxDN1NvTWp81+NCZIEGQ4Vs7PccRgv9X7fzv3LavrpbTqFTovThNn?=
 =?us-ascii?Q?+uSDLu3cfHLZOBj+RMaC+XAgccsG9nEf+KyEFhobOFmL6g328oiJY5afPxlB?=
 =?us-ascii?Q?yQO1QQ1F/Im40Q4VAdZOK9PFRTaP2B6Tn6LSKXzO/HJeDtQ5VXlBjD7zgAmC?=
 =?us-ascii?Q?jsnAWdoQ4/1mAz0KYjSmoIwrejyJvNQbTcUw648SsRj9ZAEN9jmxRn9G6lX9?=
 =?us-ascii?Q?+t+auulGuJU7NgsqEvobQ08hH9datvgmFLQO6YC7Uyvzvyo9eXuU4P/Aga+M?=
 =?us-ascii?Q?Dw2B/vAolJ5zBjBx+jdmTaL8HslJ1mKW5lD/g7jtuGAUGc+NVH1OSbUh4JsY?=
 =?us-ascii?Q?OYzhZW6Hm7uIVo+nPifgBevQfb1fRaBbBNQYFyKTzwhmzef/C2njQoGK555w?=
 =?us-ascii?Q?Ll0wWUycTunDOZCfsKHvA2hFeInibsRLKHR8NoRrHhpXvND0gzKONAu8b2JE?=
 =?us-ascii?Q?6EHdLPTWq0BZaM+No6xESYSqG5Tmb1uKgl3l9IaurjGTDgXf4/im1puxTdKN?=
 =?us-ascii?Q?4dc/4S6AJ4x8pF25UXhydQ4O9xLhilo5FO919TLqSTCqZMepoxsIAfQftiOQ?=
 =?us-ascii?Q?ClvxS6vmNv0dJRRLJDIZyUcrwtGXj24Hak4LZI9s/FYiOo9sJktoYM0lP82E?=
 =?us-ascii?Q?5xDAttVJAK25EpYUWci40dUh4pHCt5Yhsd1mImgs7DrBEP1ot9hcLhLdweSI?=
 =?us-ascii?Q?WdIuZ2Tro35pN05yOTi/kbI9TsUwOMoQjKsT6gLeekWN2JCk44d6o6ga9MfZ?=
 =?us-ascii?Q?tFQjMXj/0hWJkXSHnyzB0jfWeHrQmbHVisTZTv9ld7Jb8WN4AUKYyhYmMEJG?=
 =?us-ascii?Q?HMkwZJ3+gJZhokklmEgEVEP8RdJ24TbBzYtV3m6dMljturdPq+ojGv2sj5ss?=
 =?us-ascii?Q?vXnNJIXaCo3AOwCN7nGA2EJrY2ddMNFpvOEWaVaDttuxbQkWwgD7yMhbAXMj?=
 =?us-ascii?Q?+CW9erliPyy5Gv/4O89j4SlXLgx14hVV4ZoIW02htktl6DARxcqibodekY5M?=
 =?us-ascii?Q?UrjFDeMf5OrVaUIec2NDj8LjEPLH9+znYqBRzFPZciKYULTAaM2fYL6PXe4T?=
 =?us-ascii?Q?pH4ttsNmQkGGNysSoVSNg84RQoxa0tWc6mw6iey1/l2ABXv4lM75PxhTyDu4?=
 =?us-ascii?Q?aMqAzaOBTPwP4cOSnFMjJZW4su+3d4yTuNuX56oe4F+nlIyNezl7r5eK7fce?=
 =?us-ascii?Q?N2xP1hhSbQ+pTWo4T5PtRnSPXui6PH3SIc5lIkey8uFsNZtP2Fmmue0xhe+q?=
 =?us-ascii?Q?Du9XMV4oVzTMC6Ww+1ziuQJWfk4+dZbU6aM7M8Zb+M8WzMdTksXsaXW6Fy+9?=
 =?us-ascii?Q?N1HGmjLs3b19v61OycGJc5lSpuqLqmBex7iPt9+R1VO/0w/lKlwlz24/x0UK?=
 =?us-ascii?Q?Hk9A97koYajT1JZYvHWTJkIULunM47o/wd45tEKZSl81aWGCJlRDKgAy3ivk?=
 =?us-ascii?Q?1725NWm/RXZ5444lfRoWPZ0CepykrK7YK4Iky4+RWiQ6SlOBT+OaOkLZewU7?=
 =?us-ascii?Q?G357hj6j3FqiIcjj5VtEROUhoXOo3MmjObVXYOIaaEkvhTRR7iYNfIy56c/s?=
 =?us-ascii?Q?lbQs2t4GvbOC/k30Vb5ounFFB0oiL0DN+vJRkXMU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e17d197d-696f-47cd-6f8d-08db583ebc5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2023 07:57:47.4203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NFAQPi9R6j/jutrh7TWNlJwsSI/90LfDjccwPK8RuuVzZn7vWb7q0i8qS5Yf1kW4s8bvGVQ7F7NqQ+5dVVnJyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5505
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, May 18, 2023 9:26 PM
> > > +int vfio_iommufd_physical_devid(struct vfio_device *vdev)
> > > +{
> > > +	if (vdev->iommufd_device)
> > > +		return iommufd_device_to_id(vdev->iommufd_device);
> > > +	if (vdev->noiommu_access)
> > > +		return iommufd_access_to_id(vdev->noiommu_access);
> > > +	return -EINVAL;
> > > +}
> > > +EXPORT_SYMBOL_GPL(vfio_iommufd_physical_devid);
> >
> > I think these exemplify that it would be better if both emulated and
> > noiommu use the same iommufd_access pointer.  Thanks,
>=20
> Sure. Then I shall rename this helper. vfio_iommufd_device_devid()
> What about your opinion?
>=20

Probably just vfio_iommufd_device_id().
