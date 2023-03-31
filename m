Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D196D15E1
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 05:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCaDOH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 23:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCaDOG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 23:14:06 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD79EB743;
        Thu, 30 Mar 2023 20:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680232444; x=1711768444;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WtMjNBiE7vXrvG56iNDSGTHx1VHykHzZHIX6E5CSyAQ=;
  b=fFPD6Fkv3wsxcB8Dr9+AW4YyPx5T6GWNHwg94/FqppsuztsBfL/bToCx
   qbDSkJydV6B5aeafZSeveeXa6Nw38g4jXfS/PN9T6QxNK15yWrkWHOqcN
   X/MTmYspPnOJaWgGzcZQV9Cf0p2Ljw3W+R+An41BlFHVCTIz97+RgY4NR
   QzhTbrfZtwZRTesqtNcwZqPFW/9fzbZvaVvahFZlZrfAYpNRs1E5FZT6U
   U0cmtF+oe3jslBPLQP5kR7/QB9Wb7es0vqurXlJe1lZ48dQxjmm07/qR/
   IagMPmOs6oFc3W8ucGN9/XOcEZqWAsu4y2sl/WcUa/Ios1xX74qfsABJQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="343849999"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="343849999"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 20:13:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="808887864"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="808887864"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 30 Mar 2023 20:13:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 20:13:55 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 20:13:55 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 20:13:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNYEy54CevaqUqbIb4ZbKbHgW17Qbxgp47YWC+FtWkzz8Odv18+khvWlhZw2sv8e/7jIHF3Ur3QepZGpf+EC1okgkdmkEYmzd3joZ+I+MYYkJIBrDUJ1tJ8FLNwR0p3bs2fOsixOtJ057j2N87RxrHIr0dA8iUEF0i5wCe0qskjjSlKSUaNkwwQD0U3+E8Togx1X2xpEemEgaQNjq6CSNkJWzANM+fi+Hif4llXxgpQ/zu9edJ0xFdPaAGWczWSDWGZyOocuP2Qla6Oi9449x5E52nExBN7TH3guHs/mB21k3LJ4Jg7dnoCvVsmZhUgXPbVNnkTPUK9KP4Yj4IEBDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WtMjNBiE7vXrvG56iNDSGTHx1VHykHzZHIX6E5CSyAQ=;
 b=YNuY0FT3PlF3PvXciY8Pqy1A2tkEGHDyHxrWKApXGUuggC2ERQdUS5X9QVSOVhUna4cSQBmHrYAfWINRwr/hC+1NjBlJb/wTgKip2aQiOPZ0Kg0jCGyczcpDCTuBB6rYHQUFYuUxXUpVeCczr6OQy6niBL3LXYh/LJwsBmq1JEIyEpMEwUHbn0AFs5XHP6cufQLLfWPZalUKXWF3EKSa5vOm4V/KyHvSVybLY15n0CDXJjO2WWcNgte+IZ0DQCgKxyUctPLwo/HUbgwdUxtiwPjJSoTHhkp6AJ/GuRQIirqIRuKsc/85Nf489zHM1Vr0NS2waB12PUBBa2JJs+bMqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7)
 by SN7PR11MB8110.namprd11.prod.outlook.com (2603:10b6:806:2e1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Fri, 31 Mar
 2023 03:13:46 +0000
Received: from MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::c4e:6c7:e9f7:7222]) by MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::c4e:6c7:e9f7:7222%7]) with mapi id 15.20.6222.035; Fri, 31 Mar 2023
 03:13:45 +0000
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
Subject: RE: [PATCH v3 0/6] vfio: Make emulated devices prepared for vfio
 device cdev
Thread-Topic: [PATCH v3 0/6] vfio: Make emulated devices prepared for vfio
 device cdev
Thread-Index: AQHZYI9C9He+bKHK5Eun8edPS5e1Y68UO/UQ
Date:   Fri, 31 Mar 2023 03:13:44 +0000
Message-ID: <MW4PR11MB6763DCF012ACA41B598088BFE88F9@MW4PR11MB6763.namprd11.prod.outlook.com>
References: <20230327093351.44505-1-yi.l.liu@intel.com>
In-Reply-To: <20230327093351.44505-1-yi.l.liu@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6763:EE_|SN7PR11MB8110:EE_
x-ms-office365-filtering-correlation-id: 34f170c9-d82c-484d-375a-08db3195f001
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QzWHWhUVQptoy9xjKSkJLpQ/IflXMRaAnbInhOesQrZAyf9o3QPh/mKZYYf6ZRlDCVKqIegu8ijmeLrPbNpV+qIukaTtz12FbDiknlVuI4pV96MkMMQ+hUtyoCVdc9N8JrX8EqoyoXmARpCbrkKn60VmdnMYO2ki2fqsIE+8ngaG1h+Cn2ONlpfnv4REMHXxLSApFGRPn6ZBxbHqRBJZ6upuo4zZzkajnKY+ymA2NWhhfDEFJuieYbMgqZWdvd4nBGyPxgNQm5BnzHxJTswc5x5xBJpRrd5OQx3fbdmm7IGupiFZ646Ks38sCq2J4qbF+IPsculzdMBqH3ts3ZgBP5yKFZ3eNzUEh/SFiZBC6L1FrXeaxbfQ5tFw5mxaB//ojiu9e7X3k0eiBACjXEdrsAFG/OHd7eyyvt9cSWAt3+jEss6s1ntwf2TPn1dP4FPgXZn1sBcVoFVFfQ0+EhLCauCkWFP0102jS/aok4L9PziuaLaQYEIG7cXYWneZoPT8k6+pBsqKI1twGHo+V3e4/34+ntJpvr4RlqXdiZ3Th3UmzMiQGYgGg+StVubrA3dr+yWfA2koqOl/t/kjk8p0FUN//xuzSAkBhc3jaGLQpxrwtBANdFbVt6nWkoRjY/0r
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6763.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199021)(4744005)(2906002)(41300700001)(316002)(83380400001)(66556008)(66446008)(7416002)(110136005)(71200400001)(52536014)(8936002)(478600001)(4326008)(64756008)(8676002)(54906003)(66476007)(55016003)(33656002)(6636002)(7696005)(66946007)(76116006)(86362001)(82960400001)(186003)(5660300002)(6506007)(9686003)(122000001)(26005)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MEQTOAkq8B/v2iIpauRPMJp/ozRaVv+TibBdKWOKacCG31Q94xw0ojRHpAlL?=
 =?us-ascii?Q?oNbhEFLCWqA7j6p30/4QyULx+tosU0B6k2BTSP3DxsWeQzq6c8PLysSCaqWc?=
 =?us-ascii?Q?bOjrkmYytnTHn2lAUVqvrstv9YFdFhYhi6txy6ZHySKKfprBFCGuAUdmAcbV?=
 =?us-ascii?Q?Wqye041VpnFpMiUVd1Z4VloFHJfTOY9tbYdSaEh1Cbf8M8ywlPvsrxUIQDzT?=
 =?us-ascii?Q?pmYn1gUlTUMwgUn8sXeVGB9D+xJh20iE5YzeN5vq2GCMaQQ0IUvTdQjKDJOD?=
 =?us-ascii?Q?mCLFLWpncF6LODDwquQsd44GTp7KsjBVblLAfSEt6CkY9ynCEm3aEtG5AiOo?=
 =?us-ascii?Q?M5/6MHxdwCncTTLTaY01mixIe9+G/IdTsJi6lhm5etwoyaItpzS0VBHVotdQ?=
 =?us-ascii?Q?2OZTY5jUqmL2+1xANjp9Xry0aDUUnoQV9zlUZyqItVXM7m0uiMw+99q6Rlhp?=
 =?us-ascii?Q?mQ41zYdOZL+janHMWk8roF9Fe/oOZIozlYIGITM4QRouESAEYjix6CF3Ht5P?=
 =?us-ascii?Q?6Zs1IUsFj29Ost6ORcmZgFI2mP5gqwpx4ICfJmp/X4CuiAiPjduOpR6B12q0?=
 =?us-ascii?Q?LSrI54qYela1eeM+6xom6W3RMr7I9oQbCloYxDvlNWv3jfRXchAYKgRHwaTw?=
 =?us-ascii?Q?Fjz4Ol1ezTxhSBv4ws3C3HYqSI+TRx94l5gCpOE8sE92DImRmIHd/VhL6UcN?=
 =?us-ascii?Q?ABJDauS7lFKl0+SDQKamVUSrDbfnxPvllylO4mI25tzcyAjOrwrxzN3fy7Qe?=
 =?us-ascii?Q?JzvI/nYwGzsTo2FkFSZZHhkVRMKyE41FmqRZlHhM5Q9JHSi6aGWSy4ycMEBg?=
 =?us-ascii?Q?cd5SNy2R7W3j8cmBvQo3FmGmvxdmEwJ9l2a5SFiToE1WhvORdujFNVaEYUQE?=
 =?us-ascii?Q?w3GAcKaeWuOFb8DRJigXg/WJISAK5qQT+kR5E4MslpQpMKM3W1m2ugNzBI2R?=
 =?us-ascii?Q?RJLNv2re07f/gZ2q60O6vVR5WwlXB0TmMj2Jk5Kclym89ok96TJSlvvYCEuI?=
 =?us-ascii?Q?Vvsu65pL6GwO376FvKGAS/zEyrO4l7lc953nVoCTYNRbiDwOrp9cLXt/X2Q/?=
 =?us-ascii?Q?+RUQN75h2VoY8tyTkIFEw/n3gnVErpIGm/jnh3j73GprScmuFfxIHi1kVNcq?=
 =?us-ascii?Q?OfgIg9a2TN0WZXGvVJ/hPxqxtXWt7vaVofH+7iHjBeT7woqx2JaUrM+1GgFS?=
 =?us-ascii?Q?MEZH59/dVFO+ZpseZcT4UIMjuMfG+p3HVYe/2Yy6EQ/6oJHbMlnL/HdIznA3?=
 =?us-ascii?Q?PGBM6UNpOEfpi+WsB29tjmh0iHQH35+v35wrGeWYiaiPpTO4nTlAh/UB9idx?=
 =?us-ascii?Q?/IppnsnqM/IZjKlawp7R7gqBFyTdVTHgVfvV+9IGiuVsGHMLgAY9FL8pd2in?=
 =?us-ascii?Q?BRsrdFoiL9oKuV3py0f2zuMeeHQPTpxJ+sXZ68jKo+Hb3hz61T6sW5cpGtMD?=
 =?us-ascii?Q?L47wo3/uL6UtYS3IyjatYalAlC9DwBZdbIJlxA1gHZzLPcuA1oyLcmCdzpxd?=
 =?us-ascii?Q?6xqOeLlRcrQFwieH+5EJBxSXQ+jHui6k1X+jWk1r3U5PobGm8IoSIr7QP7Lb?=
 =?us-ascii?Q?9aRAnHwbPZ8Qx4XSf+j7bYfZj8H4AQZZv9ZO8FrY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6763.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34f170c9-d82c-484d-375a-08db3195f001
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 03:13:44.9061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oPpB5W90A1RpLIntsGMCSvs/jOjijtPYlupslz0E3EPdUsvqE5YPL7iVkSt7ZNvpcTYvwc2uYCToUlCGnCUdng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8110
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>
> The .bind_iommufd op of vfio emulated devices are either empty or does
> nothing. This is different with the vfio physical devices, to add vfio de=
vice cdev,
> need to make them act the same.
>=20
> This series first makes the .bind_iommufd op of vfio emulated devices to =
create
> iommufd_access, this introduces a new iommufd API. Then let the driver th=
at
> does not provide .bind_iommufd op to use the vfio emulated iommufd op set=
.
> This makes all vfio device drivers have consistent iommufd operations, wh=
ich is
> good for adding new device uAPIs in the device cdev series.
>=20

Tested NIC passthrough on Intel platform.
Result looks good hence,=20
Tested by: Jiang, Yanting <yanting.jiang@intel.com>

Thanks,
Yanting
