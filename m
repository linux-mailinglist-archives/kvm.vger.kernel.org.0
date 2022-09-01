Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFD05A8B2B
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 04:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbiIACEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 22:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIACEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 22:04:42 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC77612A5DE
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 19:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661997881; x=1693533881;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CdRxkNbsj22XR6dcVA5O4YKZkhNpcnai1ClZaQc2oqU=;
  b=ITvs7y7SllJoOB3AHs+mbJ45RSmfN20Wo4oa4Ab3C/SrVs5VU142Gd5s
   0tlfjRm8m6OLfZqOOe8Stjs+L8z0hlM4+lp2N/AGxClnhyCIK5e8c+6jN
   287zMyVgcxRUpDg1eQBRWcsprqEYOyP4EX275XrqE/Z6J3+ud83xKvKqO
   rSHgsuWlLLIcZg+j4KEcuIzMgTM4jj+LIy0bqduL6oiHL8yyDGqkF7WmJ
   l4L/A6U30kfzNg1VfzHkH7QYVxtVAZVrtwEEDrE28zmpl8DkggXE5Z1GQ
   72NmUV8O9PJX/cx8LK2C0RxMQIUrn+icBfnl4y4Vct34E3Fa8qgcdc9Ip
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321738723"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="321738723"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 19:04:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="563261191"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 31 Aug 2022 19:04:39 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 19:04:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 19:04:39 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 19:04:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H99JYlhsYG24/w2PSa5SwUOmeK0Gs4tAs9O8/AS0bmyzzBnAQL4ef248rfKZzy5c5zdNb8I+YjgpDaghfCoXFuz94Y+X9p6G9LjeYfmqGR1+ByBtWS6hyPZKpnsYBC7IWKcjaGrH4MYEI6wgT4kZ2nAEmasy8x6FyFe44s0x+osj/CBag/hatr5dVBggvsKXHJDSFih0tBa1E3vKLoGyDYsOq3Zu+eWZTYOMauEISF7H44YzJI4Loyli72vMT42YmQVacX+qyCO6U4VjfUVaaCsm1Vg8W4CqHozSQsjqFUPPjUN88spXoL6phD6nJs0U/bGcK30ibK9BPR7fS2wDbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CdRxkNbsj22XR6dcVA5O4YKZkhNpcnai1ClZaQc2oqU=;
 b=FEtR5JJEaXOxwHhG75SftOQaGq652+lf3aBkKiA5mVhRrDLyrWVyjXuQfOkMye/9As2gRM4fFWM4etkpmTGLLZ/aNIEwBNWhlmO4Ran1ZkHTR0S55xmag2fmhxgE8g4jawbN9GSS1HmLre/PUS1Zzb51WdgNd9lEvGnFycffOgwJssx/KTkf0jB4GWWdQkVZIroM9h6+hOGgbBONDSgDEzjy/uJSyW6J+t9Ufj1eSmn+JzYnkC5chhn7D/IjM8Ag17Bdkia7OnFtTXGsRgVfwWJLUk69+UiRvD9uCGU2BL0eoXbuye7eevjTt9KiGZ0zNwHruaKTJlVU1YT54K88DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN6PR11MB2799.namprd11.prod.outlook.com (2603:10b6:805:64::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Thu, 1 Sep
 2022 02:04:26 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 02:04:25 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "liulongfang@huawei.com" <liulongfang@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>
Subject: RE: [PATCH] hisi_acc_vfio_pci: Correct the function prefix for
 hssi_acc_drvdata()
Thread-Topic: [PATCH] hisi_acc_vfio_pci: Correct the function prefix for
 hssi_acc_drvdata()
Thread-Index: AQHYvRgj1toz8B2HTEGH5JU1mjhZUK3J1Avg
Date:   Thu, 1 Sep 2022 02:04:25 +0000
Message-ID: <BN9PR11MB5276EC6E33AE7B4F6CA48A1F8C7B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220831085943.993-1-shameerali.kolothum.thodi@huawei.com>
In-Reply-To: <20220831085943.993-1-shameerali.kolothum.thodi@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8619a06a-9f3d-42e9-29d4-08da8bbe4bab
x-ms-traffictypediagnostic: SN6PR11MB2799:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uHpF1TPu3MqRsirzNEs+kTWH2zsfYENr7d4eH3VEbLknlOjRGZZWJAEjOs+L5VusvsWX6p/VRiZ3lQ4fklSV9QxXBGiT7npMgPI/dBt2KWZsa9/u67G7FGQdUd+L7cJhKOcgVcO3J/Bs3qDAfCU5feoWqMwq68gPZiIpS3lf09yR31Kb0YiE0gUoSX8bpmKJdOVxdAzCbNr+SyVhB8KoJYfBZ2gqKaelfni8t/oCpDYDp2ZotSTHGOzBJA/tV5YDS6fg6v4mITLZLTgWpzwjHhFCShhYdcB5vgtczovF6AJHZLJd4DgwqS1E1Zf1O92aA+53FwlYzqxp6Af47f7h25a5fTASBuloP9y/odSfpUxtDOlxq3Wcg1dwDnnRAMqa9HcYNFkrpKaI18BLNZbkkcJqZWIM8QIK1t3h272+eyE9o56dWC3kay2GW7G2/kv5ah4y57yXKq7wSTMVeZZ1mbZN31Z/ZxtQklkkKBn0zLhhVb4FdgdX6uBWBeG0raRbOmRDC+movuoXe/vpNZCAzQlHRzfTUa/ovZq9JAY1LsDw3TLMoJujbqx5dZLu6fsIqp6hdAbIFvmgNOUZKttXJdJNWfKxpujnYKqqxiQb6LbHxo/P230d6M17p1VxpUv9/7+CUAmREes+xzHLSXG6egyJE27ER6oM11EaXzFpYrRx0AGwj2WeLkd9NOivrt4nppiYuiT5NRjK3448nmaQSDNprZJODOejqJbX3Xzdgaw+jCBHIev8jOAkD8INsGcb0psd/z+KH9aFN8hDoQRuHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(346002)(366004)(136003)(376002)(4326008)(76116006)(66446008)(66556008)(5660300002)(64756008)(66476007)(316002)(52536014)(8676002)(66946007)(55016003)(33656002)(2906002)(86362001)(8936002)(4744005)(83380400001)(122000001)(478600001)(38070700005)(38100700002)(110136005)(41300700001)(71200400001)(54906003)(26005)(186003)(6506007)(82960400001)(7696005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zuIkm8opv8hv84+hdAEEasgPLl8NcfcvpAUI58lIW8CL/saBqrrWsQ2EFud6?=
 =?us-ascii?Q?JM+F5698Y1O9f0K8fSiSwXDJVeXMHEdLXXDysHzYUTJB7E5FlW/gVt5x0KBy?=
 =?us-ascii?Q?88E+RLuIdExZU+0P0X75ct6QZEr+AFtCRH7hyefrJz4ZSdtGkbexTLj0VBVD?=
 =?us-ascii?Q?ssQT2wKhVGTxdhdhN/WFC0g0O+nl2oU0T0qj1yIsoMty4hhDtlvpdQfUOhKP?=
 =?us-ascii?Q?cmvMFbYNc47vL+D8KsTZdSVu6acd5OL53WtA2weZ/YM266QX0fvaxZ1NJdce?=
 =?us-ascii?Q?v55ds5MCyF6xIdjWTcXqqxQADwtqI8XBVc3DCYSxMEAoooffZyiP5ZdPjMbC?=
 =?us-ascii?Q?0lW204hF+SDMpHllZlT/3qaFMh4cxb2L/8muip94fKT9qjDQGrspSuK4d+pI?=
 =?us-ascii?Q?lagCiTV+JbN4ArZB8EoX7Pm3o1JOWweBjjQcpWvrQamN2vEclGqvEPrNsonT?=
 =?us-ascii?Q?LQjkeIrJ9JDv1couE1PP20xkYXhDRi3+nJ6armzt78VChYB+Ff8LXSXCR/sO?=
 =?us-ascii?Q?huK/vF2wmQxlNtGXE3Mrb7mnORa3D5ZNGFhM+cftzI7IQTAOsxxM1xWqV9ao?=
 =?us-ascii?Q?02ONC/a72yfcBzQktU+rELNO6xL8SZ51aEc5N7/LRYBwoZq1pbJ12/YhjyNY?=
 =?us-ascii?Q?+B4DrsciAbhswzXnVzEgyo7cODTsx4DlfKQme1aqXMwg42evwiBvdLUw8bwJ?=
 =?us-ascii?Q?aNLhfH4RRgnRDpc+pINZkGYcAiWWg7pJj+AZdlQxVtivpZ0ntwl0j+VyWTnT?=
 =?us-ascii?Q?UdCYaOadgn79CwCPE8fnorpfungQV0d/C9PcvYxDKEh2DK3C+Ejjpu+Qof2D?=
 =?us-ascii?Q?oQxLDN9V6mSTLx1HrSvo5tf4ZPdmjbKsuHxkSlHh4J/0RMQDQ1pRtJyFrB2l?=
 =?us-ascii?Q?kGpR4fpJ8Zqzb3C+kATsk7DPamoFwzd0ej7aGCGsw/kPXm+DHiW1vaMm+sXk?=
 =?us-ascii?Q?tV4+4NXTFO4CoutahscYNAynd5GSxHAa2TlaaBzZ8HzFbyi3drTlDKpsr58N?=
 =?us-ascii?Q?su/ZbdJIoqr2vCewyttVhl31SdTGRWkYv5yvsCpHB872c0NhkJ3XarXCk7Oo?=
 =?us-ascii?Q?WG2rOvh4XRWFFsZmZHo/GaevfDuRNKRy5B0xEcII2zWnGL295c3mIcx5Pyx2?=
 =?us-ascii?Q?S2Cpfa8GFIVNqQUXAXtqXy6mHySMYIQy+fyqOxYw/0RCZxibA27yCDSB+ooF?=
 =?us-ascii?Q?XI5jYfselSjvrb4pwxKJdvJaNxLR+6i5mGTXxTmc8aL0Wu7VqKV3cEoD5jx4?=
 =?us-ascii?Q?p8/+HBhxO5Pi5FDOrQaTP+l6k7mfXNH+YCX6GACYgRLsyQhkX4nFrQ055UsR?=
 =?us-ascii?Q?vMrLZJ4EQrMBrpCAnqwWWLbVE9ZPX56LosT2pQ2y5ShMlUad7IXYiEjchLgW?=
 =?us-ascii?Q?kDKYoF4VW7z57iTnjX6srDPQQZsKivwPbP491ZkFI2aDwzyJFPV0BtNEpmJP?=
 =?us-ascii?Q?AYMBScovsYJzTlJiD3DeEr7XfZcUvTtoXmWlyho3GMRXZJ8BBrOSId/Pa6Tu?=
 =?us-ascii?Q?S3GnpnQIxJI2xK0fFWVGjqdRKVIk/TNKgx2XaaSScMFxQtnzCs6T6TOfu2B8?=
 =?us-ascii?Q?aXtLMHaW/KzLvyyIcARaDP7D+gau/ArtRyDR/oo3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8619a06a-9f3d-42e9-29d4-08da8bbe4bab
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 02:04:25.5432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c5wfdX1SVLxaIOYnUc1samF4vyqkpKVOON7T8eGYarI4yHsKHUKurWHuyoTpMiAmNn9FsCFeZ8MazaoN1yUiaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2799
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

> From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Sent: Wednesday, August 31, 2022 5:00 PM
>=20
> Commit 91be0bd6c6cf("vfio/pci: Have all VFIO PCI drivers store the
> vfio_pci_core_device in drvdata") introduced a helper function to
> retrieve the drvdata but used "hssi" instead of "hisi" for the
> function prefix. Correct that and also while at it, moved the
> function a bit down so that it's close to other hisi_ prefixed
> functions.
>=20
> No functional changes.
>=20
> Fixes: 91be0bd6c6cf("vfio/pci: Have all VFIO PCI drivers store the
> vfio_pci_core_device in drvdata")
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
