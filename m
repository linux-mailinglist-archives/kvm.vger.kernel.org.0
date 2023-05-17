Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7A6705CFD
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 04:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbjEQCQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 22:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbjEQCQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 22:16:06 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395D459CA;
        Tue, 16 May 2023 19:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684289734; x=1715825734;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jSz0Axee3NHwqz1qYu49luKzlDJPIa0b+M3/N0g0OWM=;
  b=kULb2J7j7bZFFxkbFsx2C/bgcWKzA1jOFAs3Oy0rCE5xQXqbPjHSh4bC
   w5OwZSPFIRYsoFZGcYI9Mc8gsgjrPo6TJVFLx1kfmKGT6nq1qcmTIUYOY
   ecoK4kP16PBplA5R+vWw0raieEu+DN3pF0MwtRMay9CSP6tMp7iGiLtf7
   yUTDcuH6Du1hLsNVTNH4tJkg/6vbJyIRHD8PWy9ABhrRncfE+nKb919CR
   4VObV4k3jqOlf5KKteuP1T+LWSKyCEixOVCQMUzOtoGcARmR5H/0Cc8jW
   JtJlTptFVppVYUjT3l0C8pgYTt4epNQH2SxTTrP4szryChpME/iss+gaB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="417299182"
X-IronPort-AV: E=Sophos;i="5.99,280,1677571200"; 
   d="scan'208";a="417299182"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 19:15:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="732210750"
X-IronPort-AV: E=Sophos;i="5.99,280,1677571200"; 
   d="scan'208";a="732210750"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 16 May 2023 19:15:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 19:15:06 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 19:15:05 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 19:15:05 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 19:15:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4T4Ch4iK+3oU6Q43/1itE9K45FEDwmgBV58qv2g6xSUinsVrJqxHknKhsOVLe7N07D64TTzHO7OVYOPkh6+aANxzWU5obr7zekTaiBeEL9BrPt2iJgXLIIF/4SOZ59U3YhhO0vZ3FLc3aR13FUDKW5IwIQM6j8SmG+SwnBaKLkNtdPqnho/PdZ9dY+AEU0GmzFzcty0PZaXzo4AAY0iIpq6UWXE33sTAu0Ya5BoAErbuiWFRVKmP72zL7AIHLDxviHEph9np9JbsJd5kpyKZqW2fromeaMJbkHxogsTaW/a4j7y394TjmOi/Caphl5kdg5yNzhfNcBXwR7CL5yXuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FqyOLVsCzfNiuLLND7SVkcnFoERTDJIu0WA/Bzmfxf4=;
 b=T0zyZeW3xeTU+1cYwdMxCvUyhTUSo/Cv536it3dIuuwqhVesqO2ns2af0qLAM11Qre1wJ3z+gv2j2nMorBN4Z1LhrlgWHaccAoOAyk+KVc0+q4w7gAWtfhQEnxISdbqHb9192dJfaJEsvgbFyNn0F/909+19qDwTmEHfJhy1pjTiHyRu32pic6U6w1rMiEkRxiCrOQx4Hv2eXbmA2uSPlEZwW6PlC7in85qtTfYTtvNcRt/oaOIblDL9HsQFha8jXZpgFTQTSeRBaDHNGSbL6S/Uikkfnck35fCZZ2gsqqrbVQX0DyF7+Kr0B9qQgVvL7Ba4BACGw9UJi+n0G7I9UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB8201.namprd11.prod.outlook.com (2603:10b6:8:18a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Wed, 17 May
 2023 02:14:59 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 02:14:59 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V5 00/11] vfio/pci: Support dynamic allocation of MSI-X
 interrupts
Thread-Topic: [PATCH V5 00/11] vfio/pci: Support dynamic allocation of MSI-X
 interrupts
Thread-Index: AQHZhB+PoaHMIm+N6kmnr0VVXmGkHK9diiwAgAA4KeA=
Date:   Wed, 17 May 2023 02:14:59 +0000
Message-ID: <BN9PR11MB52766D2B3D4EEA58D540FA858C7E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1683740667.git.reinette.chatre@intel.com>
 <20230516165320.229b4928.alex.williamson@redhat.com>
In-Reply-To: <20230516165320.229b4928.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB8201:EE_
x-ms-office365-filtering-correlation-id: 86fd4f8b-1c13-43f4-d153-08db567c8439
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZfSziJ14PUr5DKzXGc7213LCxaDHLS1y8s0zoydECb4evCsDt0SNjrFdDG+EO3SsahRB84xXsxazRlSAKZGzh3vblZ9VTzsICxf8VR7HG0nbSURbVZHNKAukonbmPtY/AhVLbDPbrP/EbtZ37wtHL9qR10TixsDoKw+ekTy/2ZWhi/VCnzL24a4Fa2W2dmHb8z87np95XxrDMQNpalPlSN7MWri4UdQO3oWvX/EYIn5JpT2mZvisecaRjgCLBqK7xBYP5wa34vRo4bgTEvRB8VDVAt4ipi++t0e50Yb7PuPiSIUMcIjiSWnnr4FnH/Uf1s08FTw+B0Rd+wEW2jNLoQBT7af4tt9CnR4NYM/TTnakLth03Ig0yvvIbYxvWdwIuawjxDoggm2GqeKd3wj75S8c9bfyHCDJHq7EOHQlxVfvPwNb3Q5NRkF3LjtM1JC0gtzsnLRNSzhLANWd+LVrJ6Z/KmPecUtH6KpOjanU3LxLDT/GBbqhFMQCEGpfSw9snW4Gq0aqVHDnC88W+3R+1zXlIuhZFufglIPWWjNXImTZECADMGXE5r4JcYZrKSzXR7f/wsw394Ajy0tGRcaP22nNAX4kUXdfuoNkpkH4Gzo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(376002)(366004)(136003)(346002)(451199021)(54906003)(86362001)(110136005)(478600001)(966005)(55016003)(9686003)(186003)(6506007)(7696005)(41300700001)(26005)(71200400001)(33656002)(316002)(122000001)(38100700002)(66446008)(4326008)(76116006)(66556008)(64756008)(66946007)(6636002)(82960400001)(66476007)(52536014)(5660300002)(2906002)(38070700005)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7vT/aIxjGhnDUF9Xba1FLXuQxn/K6hIYeHA7IEfHXEcUl4GrnLfa4TFKh6/R?=
 =?us-ascii?Q?SqROyBOoOukq/sAKauWyrCKxjURAA+xlskSAai4ND2mp/NdMBtepQIomRHFt?=
 =?us-ascii?Q?HiKT4bZ4HuK4VbDR04bulsv4ECqQKcGW09VOPDTmEINJXxQY6Fe1YhT0ieTI?=
 =?us-ascii?Q?YbPJFZ/CX/mT3vcX16DBK+Kc3Fqb/0hsO+rubmXhiwdzyO7WYUDYaiHF2SyH?=
 =?us-ascii?Q?BZX1kAAAMLFq3ZOgFcxdUgLy7YuKsfqwiliY/v+pkA0Y5qPMLort0jZFUtaG?=
 =?us-ascii?Q?OU7yGTZuHYDCWSQxOoVNVtgnjAYQjFHOKfp65vXgvwVbtxf1UBmObrWNBr1z?=
 =?us-ascii?Q?4LdMXgdeY+JYr7gb8WkjUmuFWn0mNBqNaoVSPjGsXO0Ps4MbiYBdwS268/vA?=
 =?us-ascii?Q?URpUUoIPTIuBkZMmtCWVgxzOyShM5/scowy/9YvqjZaPpTuKH0Vx6qk1iqIu?=
 =?us-ascii?Q?Le06HXV71rg9NoN1T/9CpshTCAQXtXJbExFMzzXAB/TCzaH2GLeJ1rEGIw/n?=
 =?us-ascii?Q?B6AVAmh0PD0lTNkr4r8aYBm+vaJZALvAATIwx7TMF61/m3MH1qv9ye5kPayr?=
 =?us-ascii?Q?XEsXemekc6zqmxA0SoKEQzaTH4F8m3NPnfAG3Jc2fMs1DaEmop+LSoyipsk0?=
 =?us-ascii?Q?PRgq0m5LCPToZwRhclj8CwrIg9BMfsL/GZJywRcTHc+m2yQScTDiv6ZT3R7Q?=
 =?us-ascii?Q?Gc9d3JPwp3yI1RjW6t1L3fws1xCwwwMbmJXYpdShP58N2hrqMxjzIQUsnBYH?=
 =?us-ascii?Q?NdKEhOruDgbk05llnoC92NEYUg7R9mTcMjbK5WJQYpisFSo8UyWA8OYtY6L2?=
 =?us-ascii?Q?EXQuXsIXSrUHO73MqAPPOn35Pbx3MxK0sWT5EhKzYLpakDxborJmUsBdKk5j?=
 =?us-ascii?Q?U0mvWsyTfnLagG3vzAQTldFTuXJHw24rjuN7eMVsSEf/PSDWHCIfaH6vg5xR?=
 =?us-ascii?Q?/Niyg0G/6ixO4QdpyvOTcEy/g9ssdUT1Ec8EWNlemgB/dmj85wo+uhyqAU13?=
 =?us-ascii?Q?ZCJFYY6+g8RwgdTdggG+cLJ/gNh7mfCvYFhSZrMSJyfbQOMo47IdQX9lwKXh?=
 =?us-ascii?Q?p64secuspL+pCVZ685/P3AV1ZNTW5tias93YzXeFFOCyi+fASqDHbiCiKkkA?=
 =?us-ascii?Q?Yak/fwyKqBLD6glWmDiVD8CJxurRQOsYhE6yGUf0Zv9Yn77brHsQw96OgSd/?=
 =?us-ascii?Q?QEHQJPOJNJLg8ERwkmZoFWJiGKdEcT/hdWFFOJVdH5Ok9yfq5Bjbt6mYQSR1?=
 =?us-ascii?Q?+hGoR7mZGhn+O4cs+WphjUtwJGXs33YAJS7hsxZgk3jxYDffPYXbodInZvxl?=
 =?us-ascii?Q?jo6767BJFIcjpUTBjggdBbWDk6AmrjBuGHVxAYBgzejowGVkIYmYdnVozVwf?=
 =?us-ascii?Q?9ww/axDnyvVIuL0KotQ77mJe+dgxAMuvUMFXr941e521yCqDMdyC02wJptiN?=
 =?us-ascii?Q?dJZd/vUJILlQN3VRlfZKjOw83amEfqKe9Fm52Cw9K5/qv6ujwrrplF1VzmL9?=
 =?us-ascii?Q?0+zg7b9At3s7iwihAIFHlXZqgWzrWWhhLlcI4/FghnVFP3PUmVG1skP96AwS?=
 =?us-ascii?Q?hptscpo2lYyUgRMbZ63bnchTLev49ResobpFsmix?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86fd4f8b-1c13-43f4-d153-08db567c8439
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 02:14:59.7184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lve8h4UUc9aLw5vlwVm8swvnqfkU6AClFYuzEY9inWTRoaSYEwEki7CJQTv/fPSnQNDTbDtLXv57FwzWrGNChg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8201
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, May 17, 2023 6:53 AM
>=20
> On Thu, 11 May 2023 08:44:27 -0700
> Reinette Chatre <reinette.chatre@intel.com> wrote:
>=20
> > Changes since V4:
> > - V4:
> https://lore.kernel.org/lkml/cover.1682615447.git.reinette.chatre@intel.c=
om
> /
> > - Add Kevin's Reviewed-by tag as applicable.
> > - Treat non-existing INTx interrupt context as kernel bug with WARN. Th=
is
> >   exposed an issue in the scenario where INTx mask/unmask may occur
> without
> >   INTx enabled. This is fixed by obtaining the interrupt context later
> >   (right before use) within impacted functions: vfio_pci_intx_mask() an=
d
> >   vfio_pci_intx_unmask_handler(). (Kevin)
> > - Treat pci_irq_vector() returning '0' for a MSI/MSI-X interrupt as a k=
ernel
> >   bug via a WARN instead of ignoring this value. (Kevin)
> > - Improve accuracy of comments. (Kevin)
> > - Please refer to individual patches for local changes.
>=20
> Looks good to me.
>=20
> Kevin, do you want to add any additional reviews or check the changes
> made based on your previous comments?
>=20

Good to me too. I've given the remaining reviewed-by's.
