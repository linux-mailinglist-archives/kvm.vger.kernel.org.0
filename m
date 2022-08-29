Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B785A4065
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 02:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiH2AiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 20:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiH2AiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 20:38:08 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2A230F73
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 17:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661733487; x=1693269487;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=z1PAEkZn0LH6bo/FahN8M7YsJdcydzj6KmRRr3njI4Q=;
  b=SrswiQzm6aPlTo4t9uDbRJg5lSHJpoM7VahHDb1mgGEk/GwgR/NvLD0Y
   tfTzMSJsNTb2/llW0KikYKh72jy3Cy7INGfjwAVomDJ8dAdI4Q4L5Zqbh
   3C8lgY7O+s5dvdMTXMSCa6HRmmGx698o/+IruHda5Rfkqn/jtc3pm0qt1
   vDLPaWCkopgDc7uy1jpWDwH1jRzzza0IUVULx1wqGURFpANQw2wZS3UUc
   rflJkKXnjNHeWrQNel63AfLK2tm0fjNrrkYhnZEdsEC6E7wZqWBL8dhrk
   xg7cymDMNEKyF5/B9MDKdHzeSkqWyV10Y2+OPJeUkiBfDO5Xn2DMHPAT0
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="320899150"
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="320899150"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 17:38:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="714669683"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2022 17:38:07 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:38:06 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:38:05 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 28 Aug 2022 17:38:05 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 28 Aug 2022 17:38:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vu7+vLTM/hesSCNBm9FXEYDASGk7SO1oQjJVZiAjHTMFB9Pp5Sawsgd0XrDCNQMwyuJ4k5wlP4FtSc0W1edH8sUaENQ2b1KywFUlXbf7Lol+DChAY7oF5X8Xn1YwH20dxrJzu9CWXZCr0QXgojeLwdf/fT4/7slbtB2fZBEc0+o9n8QNFe4VAvPPFhebjGhiLMBbCHEi/wq6xs6zcxNQmc//FLg6lvTkaxOwk73XT9hOGUAcnsQRzL8LebB3akhaKajvLSvNj47dbda5+JNef/95D3PMu8oy/mt7HTYRy2veJwG6o8qhFlFZ/65i6WaZjSQNXsoWudQnQW0dMO2R0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z1PAEkZn0LH6bo/FahN8M7YsJdcydzj6KmRRr3njI4Q=;
 b=h1wxuN5j3UXbpNZmH7530/4cP8iRJj1I0KUHGe2k+uEB7ta9Z/xlpA9kf0ErVyjdoHMy2TduamiexTjtxhLv6F1RI4kqYveyMI2O+E+LoGLN7fXyKZHNstgV9ynTNeOgMT/ZpiocIW0+Ux9V0fgk6RQnc6LoR5418WL4ezafjUO9pP6b/EpV1D+BXuhzxagJ8DURvIcYQxnXP8p9KSv/hcJ0xC17iJjwCM++ZGnKbZpD1jLNYhA9qVDFP1h/EziKbSl174bUleXHrW/lp5gLCU9Pz5f4NgftFThXTIvwHkOAzEwuNJfAO6iXOpGWQvVNLYsBaTF6VfeQsLMU8T+2cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB3968.namprd11.prod.outlook.com (2603:10b6:208:151::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 00:38:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6%4]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 00:38:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: RE: [PATCH 4/8] vfio-pci: Replace 'void __user *' with proper types
 in the ioctl functions
Thread-Topic: [PATCH 4/8] vfio-pci: Replace 'void __user *' with proper types
 in the ioctl functions
Thread-Index: AQHYslOeOAAkLUZUFEmOZAUT5d3I863FGTyQgAABQ+A=
Date:   Mon, 29 Aug 2022 00:38:04 +0000
Message-ID: <BN9PR11MB527677274988885094EDDB528C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
 <4-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3af26fd-0be2-493a-0c97-08da8956bc54
x-ms-traffictypediagnostic: MN2PR11MB3968:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5/CsHpU9nkqbPH+9mVwHYtR6pSiqry1tz+hUpEgosB4P1JVZr+kmM+lTbCTYLn96SHVUsr7Vx7qPZb9RtxG9DSaZ26cigQx7UHBAxRLsxPip+f+rD69swNZwaD/nOqdKQd3GUAWsmGvjdiNcIGrra6zompUuPmrOhBg0wHf6Jt3JP+k2pm4KuCmCvn5I0j0kHWGp9eNKpMclf9CHdmrtHDtIsG9vNBwdeiApaBDPqC9qwwj+S6bOqvVRVzyjZkYDkMW1lqhHiic90sdIaTyEL+p3uOk+/5kUedrToq6uDgG7tN6V8ePoucklMcaNvudvaghx4ycGOZs//4aaHYJhweAxJnxTdI71eNnv6Eyenzx+VzlRle+IQHjvjC04cW2TaL13WQeFsAXhFWTL105PhMVnylz50y6ys52Dm3a/nCoFvGWQSSys+kdHElLL1feXtTygZYZFIDK75jm4hUU8n6MfmxImC/9LVoy/6RTep9fVVG2BrH/ufoyvbplWqJVNxxa8EPaznkVF0tS99yRyW81PCEaxq2HUSYJ+jZdJoeSzq7HWGfZaRWFJaaKkYviM37srXRajCq7pvKQMNgdD+0MHWGq5Rfsv/E6VLhADksAd9RI84OrLrmudEwoSBGSnf1ryvKYf+0ptou9Mbj7Ais9spk5d4s8AVZt0xtH5Db7gxYfYI718pkqJHayRZ5n6E5FRwpejwyJGhIuJrEQkWslUdvSzyfHxT+eKCn6q32YslCwIgeebaiGaBhXSnPOD2Br2SSia6ZIeWnurhxIa8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(376002)(136003)(39860400002)(7696005)(9686003)(82960400001)(86362001)(38070700005)(6506007)(26005)(33656002)(122000001)(83380400001)(186003)(478600001)(41300700001)(71200400001)(55016003)(66446008)(8676002)(66476007)(64756008)(316002)(110136005)(76116006)(66556008)(52536014)(66946007)(5660300002)(8936002)(4744005)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JROyd2Q6APkpMrbaDFs8WZRMjeAM7GpugOLT3LLof8ZNurlELFVaeSlESFvr?=
 =?us-ascii?Q?VD76rA+ybQWigrv2+OM5UiJsmuWAah8eTVR0/DCIC/LGiY4Hxdy0pfBAnEVC?=
 =?us-ascii?Q?ojYQwAMC3FXM98WpJLy8PbLo/qer7+v67KKzIeg8tS24dZ8ztUL0e5xMO00w?=
 =?us-ascii?Q?L1q3ON6J8Io73RLSj/E+0z3k+fqVKsUvZGli6PDeW4cT6SwaOWQ4uUTlsXmu?=
 =?us-ascii?Q?p1nzmuap9MK7RmYZ2Fwv4i3npHmPTF6VJPsWgVCEdezETg82M5vW0rWMWxt0?=
 =?us-ascii?Q?dMLzMq1cu/cjaInqurNCy/5HUIF35G98G9PxyQrr51WxzC6f1BHqhFQ7qBd2?=
 =?us-ascii?Q?X23aj2SugUCC4HAgqT7bD8/TpjAf0WTI5Ig7MNjjKuro/eaV6GZEqen4uSq1?=
 =?us-ascii?Q?Qk8LuFn7SKRoyaKEsq4hLGEi42RkUajgqRrPZKac1otWj8nwEME4PRrII0Yg?=
 =?us-ascii?Q?cYyKoWi4F22nh/sYDxlEXw0n/xRFRmiwG7HvJlutytBBdEno8rhhFYooKQ0X?=
 =?us-ascii?Q?OJWhfvcHU+M34Wk1ry0pMmAaGLKpTh59F+WyA/fA564URqLM5PeBOlxIh7TS?=
 =?us-ascii?Q?bOmH0mBc9GSX55oTprjHNz3AKb8IE6pSU6gP6kTXQ8juY+bVUX80wdy97Iu2?=
 =?us-ascii?Q?CEqh5mDcX1BzxnLxygvWHwxEqjmJ8sonhNR4VCkSYFNZfMkJDPpaqlC2Dtuc?=
 =?us-ascii?Q?USkvGljtNcefc9vVL2ayXKxbEaz0oo6Vo4sdvSqsWptYZElBXuBW0MX0fwfL?=
 =?us-ascii?Q?OHYyMA2pXn5AENY7g5ClTDQ+FWhKNRBqF4UIoGjWuj3xMVbiRQ17aTklNB1f?=
 =?us-ascii?Q?KSH/iBU1E9fypLtnyn853/69bjYOwvps+M+ReM+wA3bFJ80RAZDsOVKynoEO?=
 =?us-ascii?Q?qWwwrPjStJ3uILiqad88U54D0Ji9xC6B1iIdJABZFjxlp7D2zhGu0gy8pLZ4?=
 =?us-ascii?Q?RcKlqm/Cy/2skT+pc8yz2NCZYRBpWZrFo/5IkbO4R2i1MuCg/KyCzs4aXhlU?=
 =?us-ascii?Q?p4ApuUcV0Q89OHqyq5R2o/4FaA9eepKdwJ1m9xuGoRTQf8DFWIu98vwb24ul?=
 =?us-ascii?Q?eWj6NTotsNm/gNR2XKPuvr/Gi7LXDaqNohgt4Qanyh7zrNsqPnv8YkFdD4rd?=
 =?us-ascii?Q?TPMhC94IQalQnhV1XQZFUzCXz0M9Tlfn5A8fe9N1PGMBUSJnO6qakgc96Hxy?=
 =?us-ascii?Q?TeMxvINiYaTjo7Df+iyt0xr/m9mp0jhJOZb0FVGFpt+AeyIkJ96SmZwFC4mc?=
 =?us-ascii?Q?7teyuanduGX2VvLQ2rKnxalqAsvbjc64mlpInum4iHKCiAIiANvE8Y9ym0vJ?=
 =?us-ascii?Q?eJVF4k03ER21s5ezTpNjMo9CZyJSEIoDQ0jSIzOQU6N5ouOicesm/D4bdL1r?=
 =?us-ascii?Q?cvxYn/BFdCYStVFD1knCyDnHfX3qLhtiBJQSQNG0rZF7Zb5UgBqeJqKp08q2?=
 =?us-ascii?Q?kl85kJGpZDEnoT3aq2MXwjmrIXg6N6Y3nA65PaFvhw+eubqV43mdpMvcB+sb?=
 =?us-ascii?Q?p5ionx1FcJ/Im1hRj+jnVFjjfZHLa4bnnK/zi8wei4cD7CL0YGHrbi5AuBTI?=
 =?us-ascii?Q?TgeRI9gV//47Tq5KWczcGIoqnyelUNv/9o6MnW2R?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3af26fd-0be2-493a-0c97-08da8956bc54
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 00:38:04.5528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oMrDSk62/LUPeyWeKleTS7Wux2YqDaA7A/VLxYWNcUOGXODy6KarwjYlY6kvIR5P0YcKs4a33XfcK2x6pRcw6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3968
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin
> Sent: Monday, August 29, 2022 8:35 AM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, August 18, 2022 12:07 AM
> >
> > This makes the code clearer and replaces a few places trying to access =
a
> > flex array with an actual flex array.
> >
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Signed-off-by: Kevin Tian <kevin.tian@intel.com>

Ah, quick typo. Should be:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
