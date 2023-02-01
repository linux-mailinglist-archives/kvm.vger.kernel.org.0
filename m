Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E1F685D7E
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 03:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjBACsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 21:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjBACsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 21:48:16 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA33334336;
        Tue, 31 Jan 2023 18:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675219694; x=1706755694;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SyTULpt0t1ruTqkckSU3CmolhvgljH/95LHb2+UsfSA=;
  b=G9GsfKop1fMCd0Q7T5SJivQOOtgaqanc023NNTMDJOSwtqSQuaLvOYFF
   +jaFUj9ej0gCssRy1Gmvt+rG1GZSe6fGvqBxHm4jjLo4Tgv47lQnbCuvs
   DwAUNu6ws+LgDsCfqT8RfxQGW6sFwIxmhanTLNrTTYsi1YZiEl6e/coFG
   Y9IYNfsS+BjFCV2BO2ySJeXbKS1DMXwS21PFXIHLHfzxL/ZirX5T8Q9b5
   TCWdwwO11Yh0A7Suy710FXt7nRFbjayvEOhR3DZOXtsFLlkDgoc3MontF
   +EaFWm0T12ss6OnAcqtn9LeQcDNJhWtQwg+HevyFHVUKiM0vBVLjcJCYd
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="329293511"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="329293511"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 18:48:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="695179906"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="695179906"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 31 Jan 2023 18:48:14 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 31 Jan 2023 18:48:14 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 31 Jan 2023 18:48:14 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 31 Jan 2023 18:48:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HbcG7nSZ+qclCn4PMFKeGGxUdX84xkgLVxUKMMl3Xex72jbDDdOv0YGmOU7w1D8dulMraJ7Mix/8ASFWYNSjsU7c/WHH+bPjVetHXSk1X25T4LMaOrghUkjvf0oWbc1gwNZtDv0z4fGjJrmkNS4sl9vyfGud21S1IESNXjQ55aYVXaoYtX4++q9uF3jPgD3F1fr/8tXrz5czxYcnGWDaL02KGqSStAJkTfzKygkJFH46NaA6EkldRUmWVORl7N6LYo2h4XnMdhFfLsE+n1FoIboLAtZoL8Kqq/mpUWkZkGVikQbMJIIuJnoAWuFAFRtMghokb0tcHOXM+LGz+VQ7Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SyTULpt0t1ruTqkckSU3CmolhvgljH/95LHb2+UsfSA=;
 b=HLjIQtZFw4XFH6NHCKCwJqkeMQw0ebVxZwhc6A5lndIh3oxgle6XIt/wbdHHJc5o2c3Q3lUmKS9nGmEngXx4gI/xoeVyU70yOu1hY4TuErSLf0zMmQ5Sj6sURpJUyrGEY8pTuSlfsXl4ckdVbJp7lX8ma/fVbCHcYgKNfcYftKxl397G/arIJuwb9FdffejCGMFDFClpBXJCdmbsyfvBIcyTlh84zkbZWLV1XFCtIlS5df9zZfheK+W1eJgdigseR52QBJEaR4kvBjbnjWN9pvjx5sbsGhbblLsOxM3qlMMIzFo0OVMbQZmMAJCxvZCaTVuNLznHcp3kHjrJEhPWEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB6062.namprd11.prod.outlook.com (2603:10b6:8:75::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 02:48:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6043.038; Wed, 1 Feb 2023
 02:48:11 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Tomasz Duszynski <tduszynski@marvell.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "open list:VFIO PLATFORM DRIVER" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
CC:     "jerinj@marvell.com" <jerinj@marvell.com>
Subject: RE: [PATCH v2] vfio: platform: ignore missing reset if disabled at
 module init
Thread-Topic: [PATCH v2] vfio: platform: ignore missing reset if disabled at
 module init
Thread-Index: AQHZNU7jtB4WJYQMwkG7JmIaEg62tq65ZH+g
Date:   Wed, 1 Feb 2023 02:48:11 +0000
Message-ID: <BN9PR11MB5276184D9CDA28BFC2098FAB8CD19@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230131083349.2027189-1-tduszynski@marvell.com>
In-Reply-To: <20230131083349.2027189-1-tduszynski@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB6062:EE_
x-ms-office365-filtering-correlation-id: a96c28d2-b32f-492f-f0ae-08db03fec239
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: spRFwxyajDYt9QOKC42rvinoLzxVYDkv+7aym+M/X6mqm3IzdU/brW24pjGs0b7IS4zOY4ZaCCCOpNSpelvL5KKpbHH3E4dwwscVnOtOiGOy0dSNAQnvbXOtBRNjvYRaTYX01nmKrzXExMwv5Kdpg9AWM8hbgem1AC+6RAuE5jNY8wS1iSPurC4+ocUTs/CKC/RD2ZYzNY1pWmV43YMpX3P5/4kKoAB8zyNqgAVfah+PSzan6IUdHSILe6VlGD/ySkELV874A4Xr+JaQmc9dFSd7B2NWU+NqmFFBNECI62RC01unqrAxFpEEsjqZWB22QcIeG1IIf356NW68xC6FVP+oG3RUNfLe25vknS2DohYFXrm6fxYHNJ5k2YomXJ+WKVFMHpnRddiTTCmSUV3O8f0CKkiy4IR2uJNtnA5+GS6sLg5RU9ZtAB28ubXjjXzha0In2ZLovYYhRiunEa/FZi/HUdaIlIMnIZ8Yh79a6e8wDVAIKHXGLWxP4aR3D7qM0rbkQ5IY1nYf2KFGAt16w047AUYHUrugMv3kaxXjyHfhv6odVCBPNB18U8iUpjxUAg7nSg1HqYBUvNwBtFuqyN2Al5pDx1y+EbV27JErIrsRaREv9fxbMnF+CVlT6817gYroQS32LDB+kW1qZW1+8txVc656nzdBIx958CXNirK8ar8QxJJDO459U3Tjr4P94Tqv/C/VE6hpb2sDmYJwGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199018)(110136005)(4744005)(71200400001)(316002)(2906002)(33656002)(122000001)(38100700002)(82960400001)(66946007)(66556008)(4326008)(66476007)(66446008)(76116006)(64756008)(186003)(478600001)(7696005)(6506007)(26005)(9686003)(86362001)(8676002)(41300700001)(52536014)(38070700005)(5660300002)(55016003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?F70EEUXXLZA5VbzJIF95n9LxICt4XH7AAzQrG6X7pCeAzbLOd+gf5artjlUH?=
 =?us-ascii?Q?qBGaqjoIcGmNJ3Q8exqNwn2ABRVQNRjpVpl6qrGunkLPX1lSXlxP6cyTVsJG?=
 =?us-ascii?Q?0FqOvuAFiKWfkNHLg/5x+TyHxLsfu+AJJs7+Dmzu4s16VM93yB3NAx9dGUAq?=
 =?us-ascii?Q?4zoLo4oGpv5uVVRsZBdoeFSW45S+uc+FXsCxsdXUeQ9Uk+swEsh7u+IM9LdF?=
 =?us-ascii?Q?LGUzrdQjOUG1Nbfetj7BTYe8e8TBpi8tz1Fkr3d4/bxm8Db6WBCyZaP/xpKK?=
 =?us-ascii?Q?sYnqd4vQyUiNpRXsnLjFBRLgkbjFzx3Mqgo57RB/1dAlK8Xnf3qy98V+mySJ?=
 =?us-ascii?Q?3A/QeSaPtNKH04JuoQh8hxaAecyv4253FXCuc+SnBBuBXF0bY9fOU4rlM3Ma?=
 =?us-ascii?Q?La8F4ZUlAlcjiYmvlLLLnLcfjrK+2NG6/Nhp3a/DXNNumy79POh9ew2P951Z?=
 =?us-ascii?Q?lMLRwjOYoqen0bPvzYULHTCdCHrLl5VBvi6F6oCy85n9j9XdTRrqp4pfaTJR?=
 =?us-ascii?Q?oFpNue9a7rhjuvK1KsIe25I59B8FmuWQSeukR/WvlDqFfbQ5iZvUOjvv3jQ2?=
 =?us-ascii?Q?AxR5Nvnzw3cMsXabR+yBCpZ0L6uXb7EC0/N7bnN11XljX9c65joXZ7T72FxW?=
 =?us-ascii?Q?kNWGIXPKaXhV4L+GEGizmTb92PHCEkuBw9qGVjsIG5UnR4MZKGxyuMBhGo1g?=
 =?us-ascii?Q?LGrTBJmWH2FDClYZFi7IVUAIe5+4WiIRcL4Dx8HfaqmgdDMtV0hO/fu3RBNX?=
 =?us-ascii?Q?Sk3/2nSmScly406gPOk1VEKqct2GRaUWV7LrkCSc5Z1Qo3xWgolqV2geccvK?=
 =?us-ascii?Q?J1O81BHy8SUFAur5IdpBFSOWZY4GOG17ZvtFyrXRdd8L2g1Ef2QN/78ZbksV?=
 =?us-ascii?Q?2kkZ+O1BIpKmRuIVhOsmepInQZSMGmjUuB+vFBEHHK3xlA/2Any+GQVn0kiX?=
 =?us-ascii?Q?4IUYvzL39QcMSu17/RLBjpAeikJUx5ljUjlEwumi8kH/THiYZJhEAuHgkb7V?=
 =?us-ascii?Q?RKfU2ca+KJ/OfYwy/oxKBBbKj6X0BMeVNHbrxdM/kW8qcvMYKvoV3WOHX9+o?=
 =?us-ascii?Q?9j8JSfXdqAzrzHXp+yKnyIAkwYL3SaL0URdWSRIGcMKvTBFRa5G2qBbHtU95?=
 =?us-ascii?Q?IzNrNA5d8gWZy5iOvH1uActO+S7Z5o0Kslfhn2LvKfiUXdqduivTfvGITGTG?=
 =?us-ascii?Q?EstB+xiTvR19sihJqh7D+/RWMScu89vIQut0IVC7X3xXAFmFK350XFddipbx?=
 =?us-ascii?Q?A3w3c6WYra5YjP3YcX25sKyZqQoGyyD24FGwzjVdT57Icg0sogIkn7Hf3O2r?=
 =?us-ascii?Q?uQ2ijtwwJrJdj1n8ycf4O0A8y6Xu4jPIEzhtCV5vuu93tZnMI1UFI2xpiHA+?=
 =?us-ascii?Q?YxMZ6rg9uuTn2Flq+rDyPo5bd3BaTYGEDhjHX34VPPnqrA/hTisljn3nR/qq?=
 =?us-ascii?Q?mdGrs9OZI/qk193XwlMIPd5IgbMYVqkpE99SSt1hCj7gryPO+v+rXo+OSR9/?=
 =?us-ascii?Q?qe48H8MCZpmrKRoSE9PNOsKl4//D5oHC/7UoqixcTip4oOa5OA22Jl62/SIo?=
 =?us-ascii?Q?bEzYdageIoGd8trI/+Rc8ANshROQmAhCFyJoBBzp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a96c28d2-b32f-492f-f0ae-08db03fec239
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 02:48:11.8054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 58Fxsbh3pLMX4TnhA02JTPFPIGchWaD7p8Rn6GtqG9UhPm59cn8mW9ZFX7yw2PuL3AWJ2xFvczMVD1YrPzA5nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6062
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

> From: Tomasz Duszynski <tduszynski@marvell.com>
> Sent: Tuesday, January 31, 2023 4:34 PM
>=20
> If reset requirement was relaxed via module parameter errors caused by
> missing reset should not be propagated down to the vfio core.
> Otherwise initialization will fail.
>=20
> Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
> Fixes: 5f6c7e0831a1 ("vfio/platform: Use the new device life cycle helper=
s")

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
