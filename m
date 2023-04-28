Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23D96F11CB
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 08:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345277AbjD1GeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 02:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345142AbjD1GeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 02:34:24 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745EC2735;
        Thu, 27 Apr 2023 23:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682663663; x=1714199663;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=s00T3eQSb1HKi5qtUpyokqLv9anUOloQ4OWTRzUWIH8=;
  b=WfAP1iGg4c5Y0OdxxhxH59g3azGoexp6KqplkBP2FFLHBSLQjKa8tUwB
   fDIqbHWgoh9Vtdi59f0VxPfvS1kTn+vBszvFbSGt4wnXlJKUR0nb0E3JP
   6+6uBx1VzotSD4AXTZ/aZDJfjsnyByUdPFqqp06BUNdiZaV/6VUkq/AZ1
   uQKxU3TTj3bQkCQg2nlblI6Mg4DLOw4u3dGIcMPtvrE8fBTW/iMQ8NKI7
   AVmzuSELiWPvktgAGOuKKW16ZLEtzcpZJTOfGG7knve809bhP31GNqNMW
   NYhAtwr8qTjS0x0azsvgq7pNuuLEPxN4oDWKSkCoqDIpPe56i8oRgo7TS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="327285960"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="327285960"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 23:34:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="838743192"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="838743192"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 27 Apr 2023 23:34:15 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:34:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 23:34:14 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 23:34:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7c5LoL4SEszxTx/zsj6sQkS+naDqqVIsymqo0Bsl8ukvRl7yQkXOpxwdA3BzWnKl3IWzXWop7nSdwJL7MNOnmf0fLYEvHv3gixZ+PIajivNzO2vhJDuN1+6hxlBulwHS3UixuVKcPQ150vSTkrKAmqkG8ZD0x9zINh7ghU9pvDHkSWvcy+oh5tmJrLoUJldIAeY8J3gb6o/QZJXcY+sKNvvEq0a0cuKpzwYxiwoSUKLoTgfoMJOwSV3czboflxpZXdYc+qe7lkOUkyHO3GiIXDRdkPFAricgFPFUCXwdhP+sx2MnDvMNGhnKMavrFTgEyRPV/1+MEQZg6rZLgJYDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s00T3eQSb1HKi5qtUpyokqLv9anUOloQ4OWTRzUWIH8=;
 b=Xf000gpvH7nUL0whGWdnmVy/3pE2yo7Ru2jFmOmxmUofEkRS2BHUOe+jLvZjLDpjbSzeTWGDI8ESmK1LWYrRdkCUVXBTtho1x8OLngJi+GpajsTiCbKiNhoUr3oUjIRafjRBIUSL7GtSLxKRQQDaR5o+4ttradXN8AeM4oZ1lk6E8CG9ZLOYyJ9d+tDPGxXrKbeqnrYdnYkCt8DnZkQOuEOIpvNmhFPSED2oT8ga8cgt+IYARH04NA06dLR3wKRhnZy3R9p8/Yf84d7lostwJyqKc4ltv76FHKzJ8UvJVOes5T9Qz7hrTjFF05/W9XYPvY0YjoOly5IUiPTumV5gbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5581.namprd11.prod.outlook.com (2603:10b6:a03:305::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.23; Fri, 28 Apr
 2023 06:34:09 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 06:34:08 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V4 04/11] vfio/pci: Move to single error path
Thread-Topic: [PATCH V4 04/11] vfio/pci: Move to single error path
Thread-Index: AQHZeS7Myrfqz9PnuEuDQL/XmYyy8q9ARFqw
Date:   Fri, 28 Apr 2023 06:34:08 +0000
Message-ID: <BN9PR11MB52768E041B430C7F98D9FB278C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <521fd5184ef052ff768a90bbe670cfc4e375eff9.1682615447.git.reinette.chatre@intel.com>
In-Reply-To: <521fd5184ef052ff768a90bbe670cfc4e375eff9.1682615447.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5581:EE_
x-ms-office365-filtering-correlation-id: 146fc405-2b28-469f-5f39-08db47b29257
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1hZUW5+qwRsQqKEY5tjlfqFQVkXbmfrGmRhkgC6wx4sgLe50jV84e6nBgXTrRhEoezQjz/z0vTIqvUAbvczp/HOqSNEsi+LXqtZ8fnWS7Pj1JdB/grtbr5x14dBq2sjDiNT/50TYENrRR+2YCUmwwcMGH1Q4eVH6kEgyb0RISRqapxjesPkHVBc//P7JpBLnJ7eph4NQ6zV0B5UWp3wONMz2O4tsh/o1yCjLtTjU8uVDVuankeUvxy2SxTdTc5lsQVpu+n4DviGA134CnPmdujURREZOI2W6HGO3F3mY8L11980JcL10PKCAiWIXUJzbH7gvyUolxB7+oNhC/MJoeA+72DiWEyvUOOJFaHfHf6arn5/QTFfw2289S9dArLiBw7fVHGzQQIO7LNZ/yOqjumVtUDu2Zs/erdq7UFmRC/B7xSmhdNKr3XxrMq1hyIEajhy/71ARTsCrCg51398EVBt7UVpiEW1Fa0S95njZFRePI+q4TfT4bJCxHH0+e0FKHhTGdq0LI3Hx4plPo4lixNWt/lt+zHVd2iA4mwmzoQF0zE+2E/W0Kx9PdAlYMK1Thq8YCEU/nVWuYdgBPviu+0wsdNvSvAcWxQJiFuJ+qeK6si22nVy2o5d9HwVACHdQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199021)(76116006)(66446008)(66946007)(66556008)(66476007)(38070700005)(8936002)(8676002)(316002)(38100700002)(64756008)(41300700001)(33656002)(186003)(4326008)(2906002)(4744005)(110136005)(54906003)(5660300002)(82960400001)(122000001)(83380400001)(52536014)(478600001)(86362001)(7696005)(55016003)(71200400001)(6506007)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I/PplqdlOPRV11Nyf6EfvdBx+xc+1iXWVocTXAb+TS1ACaAu5hAmCW9C7umC?=
 =?us-ascii?Q?0vAFxeZHOgpZ2Bw0miUuC6BAuD8PJkFZp7j3Jzbj6ZNtU/Lnp59RSvi7yJYd?=
 =?us-ascii?Q?qNj0a1prcj6YkhuqkiDv+Guw2Wp2hVEf05Th8H4A1WbmhIRRi9+NsI4lYwdl?=
 =?us-ascii?Q?6S9m4bWnTn3K6ARRMmNpdXJv52F2iBb+QfIfHCgz/4hHeeBDj7y2pdrO5uM6?=
 =?us-ascii?Q?KGTDGfRJxGiTVdeX8Pe962ma90ziX41IOxXEPBfnnThDuBFx5m96dT3rE+19?=
 =?us-ascii?Q?FDNYJLBlnGhXmDQw5b7oXYROcI2EqSzpIRjNSqKKQBlGchCKjeadj2eealuH?=
 =?us-ascii?Q?LpBH79KDwGVTZaMBZ/OdNRsurgWvd31jEJZOncLVSQaAUHsd5tBP5RToNur4?=
 =?us-ascii?Q?S5Q4HLahCaXq7Ehy7EJsqYYTS/GAUcOSyeL4+uoEYGFY57DboE4YiJbuIYPX?=
 =?us-ascii?Q?Qufk4gUHl1klKrkDlpXlx8O1xJebbgMpIzo7q0+2OoALSSH7y1Oc0uKdNMbf?=
 =?us-ascii?Q?6hHCtm7Abi+G3FEjQLojDfJ2zr5IzaNAzIHY3/gz+1ZG8B0IxaVjhDP7LtxT?=
 =?us-ascii?Q?0y03F2iQ30eHiM/odnoaQCRDa1oFvZx4AnadJXr8XiCM4s7i24R6L0ByUPts?=
 =?us-ascii?Q?mXd7Si0WZGYm/wSpRawmfZlMRaDiA30nitaIrRaaA1FwhLymBnAzRkD+yUEs?=
 =?us-ascii?Q?3Myc9kKKb52NowdXdvmamyyLLt8HqEf6e7GLW4e0OCWMEkKVLUiGm3PuMZ+t?=
 =?us-ascii?Q?YwLXqWzW3iYyzOtmQkiW+nHCY+GiAe62OT+Kt+HqesZQiC+l3nyM8fHlfXXK?=
 =?us-ascii?Q?7FIr6aXSX9lMDibJ90DCAwgjo3EWs7+SZTsxpYvhhutu/V12XXPwTvYSGQsS?=
 =?us-ascii?Q?YulDlZFfsDQCmGo5s9cDdU9gRAMzU9BrAGpZRWxxUfXFGX3tmgg71MTBI7zk?=
 =?us-ascii?Q?kOcAN+xnXMWTxOz3Q1KNE3u4g2DuyRXBAtVGrjBi0l79SzeR4LzC7LN3npKj?=
 =?us-ascii?Q?W0XZrfa69897aWeBn51kU5hol/gyGXnpRpMd6Ep1WimnObnZedQI9tcYMuO+?=
 =?us-ascii?Q?PMAXALVZeINbUMqOGzeubyFi0RkNowfP+mkJP8H9yTRyULwS+qxmgYWxPvar?=
 =?us-ascii?Q?dyExDo/c3mzRFP8pOU0bAMxMhzHNpKOsDgV2k2j3NXGLeFQOdGCyGt7Z7aDb?=
 =?us-ascii?Q?eHHktEvlLhqeLNMvwK5z+vCTgvG95HqClWVgfJv37mgOTlz8snQv6g3fCEfX?=
 =?us-ascii?Q?e4mdr4I86aJ+06zyl23UviqBrOY5YLU2aOJHnFhqUPprvqYu1z14eWF4vc1n?=
 =?us-ascii?Q?sWG+s4+FGQKsXOqmhurMeGKDoOlBO1aR9DkDCe/69ghc831NncOuhZpPET3C?=
 =?us-ascii?Q?jlS25KrZwG8UE6OWm2yHobx1SqcHD+M2xMoCHq24+1lL5yQDExB7Xj+N6hah?=
 =?us-ascii?Q?470sGAlZfq9NPePwCu5DF6x7/8MfrXYW5lwqJW/oJ7fPwpexE5daGEvt5pR8?=
 =?us-ascii?Q?Gt6n3IEd0Nqxtv+ue6TVPAGTt8xEyzpbD8yl/R9QUSafojjAoElb92qY80zH?=
 =?us-ascii?Q?Wupcs31hZ6UxMvZMPBSWc5965FLp1LjeXvSnLo3U?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 146fc405-2b28-469f-5f39-08db47b29257
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 06:34:08.7455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c6BlzzNgnPMKMh6JCGrTa0pyUsIKRIcXWTynTTPruNum5fyTEoBaPMKf1/dPXU7lK6kwUXtKbrf96qM6bD6ijw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5581
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Chatre, Reinette <reinette.chatre@intel.com>
> Sent: Friday, April 28, 2023 1:36 AM
>=20
> Enabling and disabling of an interrupt involves several steps
> that can fail. Cleanup after failure is done when the error
> is encountered, resulting in some repetitive code.
>=20
> Support for dynamic contexts will introduce more steps during
> interrupt enabling and disabling.
>=20
> Transition to centralized exit path in preparation for dynamic
> contexts to eliminate duplicate error handling code.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
