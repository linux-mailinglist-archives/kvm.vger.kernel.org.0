Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C6163A349
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 09:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiK1ImO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 03:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiK1ImM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 03:42:12 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C3017A8D
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 00:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669624931; x=1701160931;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AursMq0EOgM1rf+bQY6pqpsbPGRBPLbgr9nAC/VAoCI=;
  b=TYFJHAfmsFnZz7DNRFuTo0+sFGetO0SF4+5SY34EQucO3Edkdqfr3Lek
   5PtfPxlV5lK0CzJuVcJs2rk7rMfLWzHVdZzgANbR3r2vJ3AybEyUmHgnl
   grNKafH8DNOGcNpLbYHt8CYtiDkOCXkwbqajaFUZ4qyk56saPXNzHjiOr
   k9hdL+CsC8+B10xvL7zOusFycJDjIMVgbd5UeKkvz0cKpmC3K+PDpdu/h
   W8VU3DEqWA9gNVgfXcnqachzWjvL6C4x5GNoAiJj3hLIOReMllFxepUtQ
   gexvh5yBG2ro3jUu0B73qK++NzG7tJTTOsU8ArNruoE4epdYL5VWRxK1C
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="379036049"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="379036049"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 00:42:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="972177260"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="972177260"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 28 Nov 2022 00:42:10 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 00:42:10 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 00:42:10 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 00:42:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEiBkbJLXFGB/Uo/hUTEk7w3Hlpj7vQpkkF85zHccScaFP7dlQ4TfOL3USBtYHxqCKAj8JDAw4jCuXU8SlPZGIZWz0fQ4vPe18ffMmT7oP94jB+cBjo9WXMupoLEDU2fM3FfGstKnCLcXjMs66G1F5DBlkepJdJY9WrmN3Gr5cMd4l91sR4X44hH25Q0OviP+j1osvS39qXUeKibDs9yJw1/bcdrlytlubMxxdzjngBQLz7Oequ7FZsKCCt/usR5mhWmqbZ8aPyX8nklIOStqVYut4ODrVEIIOrh2yhzGfcRbr6MK9wR+Q8YS3uCJwmW7b/80aCdhh/oAi0HlFAyCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AursMq0EOgM1rf+bQY6pqpsbPGRBPLbgr9nAC/VAoCI=;
 b=Gier2IIIeOoE9I2sFg3bdIB86CiZHIV0VW5aIrgP58f3fILKgg2tL6vKI61ib6C4PO0HD+WByiT1NmZNusyJpe2fOb12YxWqXk6Uo7BnN0uH4rHS3mcwk1j5xStC61FfxWQqVVTr+HRjkkTtmDuTDqSFyt3G44mlEGDRAv2lvTvwQtTiwPgKQqXeJ7fYMzWAUq8qf2veLK7IhRbrtuUhalUFOaW0pDgY819XgRn2EqXe3RBnBhABQv/9udKknkUCy61vI7TrDLY4trXwqUjzmYVITpchJofdVO83KNKMAcnnllCedH9S4Fbmxz2sWh5kP2Zr3vpv9+Ag6V+0Ro64/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7049.namprd11.prod.outlook.com (2603:10b6:510:20c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Mon, 28 Nov
 2022 08:42:08 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%9]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 08:42:08 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC v2 10/11] vfio: Refactor dma APIs for emulated devices
Thread-Topic: [RFC v2 10/11] vfio: Refactor dma APIs for emulated devices
Thread-Index: AQHZAAAa7sCzUxw/VEWYoL8WY7aktq5UCoKg
Date:   Mon, 28 Nov 2022 08:42:08 +0000
Message-ID: <BN9PR11MB52763C1E813EBE1F8792FCDC8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-11-yi.l.liu@intel.com>
In-Reply-To: <20221124122702.26507-11-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7049:EE_
x-ms-office365-filtering-correlation-id: d18297ed-13ea-4de6-be9b-08dad11c6fa0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Am+EOLHCot0wQ2VFyXsUaEpzWE6b39EwsUgODikunS3scFXiAcsB5br4FWeSWH1O/JxC9U1BEGyOrpc4QFI1nS785GQ3nwRG+a1Q51qce2uJa4fDziAZEIzswbnOwTfNk3aWQXS8g5BIQlbsmSDjAaChYd1i8z35RHlsB/oEmrwUwkHJ+5/CYpeEfB4TEClva9RxwNxS+ss7xa8LVMAUN7zNOArps/jYCsc6yW08SHpTlJ0m6g9lk1ulePGX4IAe219iGQ/JWAJu7a6Lw1mxyBotM43zpTzhxJ3lG+L8MZYoLOgsYy4PLKUuajD/qFKepN54SsPXKTSpm1IWZiRxtnvHc2NTnQriu36wGkBaquOzXmgf2LCP0LbzZ64ftNPe05Dnvv2WNz76tJAL2bbGjnR6/3YBGmiTXmwPbsrxnK61GSOJkR8NmyfijXnWATepYbrbr8QXXkCgsNG6xklXNFByQru9eCg2CnHrjD0SjDzdFBguGaTDEy43U9+DFPsn7S4BjnsnH5+c/f91L1duqKIcuuW2diIBQ59ulmjt13yJ4oYf83egDyQEaM6npZ5+kIFxWIyoqoJwSF5mvbROSD3UZ/YQMIEkiPAAWJi3pFjaUaiq2ffueYOg7XGAVwskdS2s6lSf2qEhUJTAnpf11BiFR7FSTxQXtcpeVCHS9X7RTzMfSXTse/TFwFixYS0/f0h2CxhKQzHrvxQzMIIYKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(39860400002)(346002)(366004)(396003)(451199015)(122000001)(8936002)(38100700002)(2906002)(186003)(558084003)(55016003)(33656002)(86362001)(52536014)(38070700005)(478600001)(82960400001)(76116006)(66556008)(66946007)(66476007)(316002)(41300700001)(66446008)(54906003)(5660300002)(9686003)(8676002)(4326008)(7696005)(6506007)(64756008)(26005)(110136005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bIcyfYdHX3htDcBwJHjyNLaOa9OawVlbVM7DanWrwXeMFwZa33i+btAYXsrx?=
 =?us-ascii?Q?sJia2v0vmIFAljNxEgzJaMI6pv1K9tCqHj9v+w2aVm3S7/tV0Yi2ZLaq0Bfe?=
 =?us-ascii?Q?TJLBVg4j3icPPf/UnxTeoPGicm9t1JGpOJGIhHyuZa+GAd6fEA3xttAQijQ+?=
 =?us-ascii?Q?dBSK8Tflhv2wjZXoSmtC1AFDM6W97rxPE7kmf1ZfaBNpKWWq7ApDr8/LZJue?=
 =?us-ascii?Q?5/O4hdR9otf/CrfBt8dL0r4G0wMWV3lUVnVebwwmnoufix24NM7GFEviO+jt?=
 =?us-ascii?Q?BNvQ0DMookNquFpkbpqCFky8XpJ0e9q3ItMKGS3EEqw3iwj0IRTLcLzWLZT+?=
 =?us-ascii?Q?6On5Wk9kHxI7yxl6blE5cqP4CGBd1NmmWV+aBzdDFwp50dk3DCq8CqRWvJQx?=
 =?us-ascii?Q?cumUrPMFV9xzLdSo8qFBAOb8qqqWI68AgRUYH1saLZgA3pgJIqb0S7f1tVSL?=
 =?us-ascii?Q?QjsnKnJ53bItwtA47jiDqVJJ0xcwVg+cm5/SfpyYfh/GS3L7NknRdjZRJwn4?=
 =?us-ascii?Q?2HoX9D1kGmhTUMBGXrUjVmPELlVqC3fQToRGsXgbTftMdNZ24ZNZ1fPpfa9G?=
 =?us-ascii?Q?O71rhcBbXvlIt7pEVB56EC6NNsqj/dsBr+bqjDSuW6MJwUcsIaaSDR/clKmc?=
 =?us-ascii?Q?ovl5rZ/3zp4K9uTa+xpRHCxedK1qAWc/2IZrdpfoJZ4HGab3x706QfB2MgYM?=
 =?us-ascii?Q?tJHrXTbssoMK22fc2WOv2x7nXEbrRK3TLXv5Vm2LQY0UuoGf81MhErqSlfaT?=
 =?us-ascii?Q?QBUqEBm3po3FC5vyxRRxYWwGG5I9bTJPH6ZZLErCFlyCtpx3TT4F/KagtsXu?=
 =?us-ascii?Q?kQSSw0Vm+dWHjUzAJdUF8Ogyn1MdXTXlihOJsMjpDC+EVeYsqaG9Cg7A/4p0?=
 =?us-ascii?Q?eH5/bjgiV/uDtLb1Cv3YIynWujOXFOSAhtB2fl6YjAwX/TopyuZ2tVDztDDC?=
 =?us-ascii?Q?1KfG2l19PAiSDiYePoUZgv+lOTHu2PU9STo+XG8SUgmyh1FIbxL8ABEOt33I?=
 =?us-ascii?Q?nO4yoPs7Xl7P+FBAHOo65bzW+/L3wNEYsrgvvEWyEQ4yvcCcJ1TpryNNbZ6a?=
 =?us-ascii?Q?FUa6jl8lPjVJnIZwjjudBrivEylvse+UG5dWZ2Sa2AozaTG1/8gPK6R9O4ca?=
 =?us-ascii?Q?Xun9Xz+Ba0YcHNrZOIJYt3QNKA1WfEce9r8nnJF+WByse+MdE3DqaaSSKbo9?=
 =?us-ascii?Q?KqLXTncVKiIxbnGJLvTw8uyEnawMKNSikDulFqc51sreUTGCxiclfOigVYjU?=
 =?us-ascii?Q?gIb2eqTS4cs5SQElCEtrU080XrVrQ3vCp+apFWa9jwd/RDPVCWazqY8d+5Kn?=
 =?us-ascii?Q?mhbmeisW9VHIURWir24jwi9fwkfVUt9BHW/TwnGvBAGRpG+i3iR9uj2UHwjD?=
 =?us-ascii?Q?9MQGM+2krXjCvMNrnD2fvYmsruyevEQAY/W0FiLMvObzpv4Lb4L3OdzUhk4U?=
 =?us-ascii?Q?R1b96GIRGfbMk8HCSRgLeBDPp32wv7zTo53BIsih5K8YXM+DK9gFWwX/dYFS?=
 =?us-ascii?Q?gdEf0OXIrNd4aNV4/5mhfTdw5xVv0a5TR/7TrxEEgURX4WyBxYNX5Gy+ewJJ?=
 =?us-ascii?Q?tqv/WeCqJDjE3e1HTCAMlK4rJtoJVM4FEIKhyGMX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d18297ed-13ea-4de6-be9b-08dad11c6fa0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 08:42:08.8129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HYj7Nv6y9KFglZO+zOtjTjOuJRMTEUsKfiVgFxzAWgUf1PEX2FD5ge6sxQMTyEQSK3ZzOvLtywA810O0TM+WBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7049
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, November 24, 2022 8:27 PM
>=20
> To use group helpers instead of opening group related code in the
> API. This prepares moving group specific code out of vfio_main.c.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
