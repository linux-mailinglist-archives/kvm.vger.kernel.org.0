Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9697503D9
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 11:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbjGLJuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 05:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjGLJuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 05:50:17 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0509B170E
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 02:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689155416; x=1720691416;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=alBoZv+HUHBYCC1Jz1K9qLsm0RIGkH5jaFUEWcj1Gv0=;
  b=a7HioF9TdhUCepfjVhpilyyfiWc++LbYiTWVmeY9IXgZeB/ZLiPy3+uH
   bKcq1T9g6IKcMDWi6rEMiNZF8NOox+5mE2raFYqGDRHep+Zo5PMZaBtbn
   6pioaeJyWV8NrB5jbfx7uNvqkaCFydlaE/t+d1QNbl3vsAfCyVceOWVGD
   36ci0OW3YllL425n3Fxu3Yz4s/xdEzJi1otkT/tBNQWlX2Y2IM00ziOKG
   6dAPbJAfZmldGdxvMEPbBCVSxQHJbO20dn0Lcugxu0qCR1aMDSV4hkFK/
   eQx4xOe/MuNssWN00JZuZ/5FvsJqcVfwqnAIBJWWnIEalwlVjkiev18aK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="395646989"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="395646989"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 02:50:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="724819671"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="724819671"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 12 Jul 2023 02:50:15 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 12 Jul 2023 02:50:15 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 12 Jul 2023 02:50:15 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 12 Jul 2023 02:50:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flLcAVghkuhUHQqV8lMoqxJirS8otLthiv1pD0eE3vtcqPPtOOc+DnqI0USi0HokBWd0WbaDlM1JFCwXIKV2g8y6vYpyS2rsYNrcL5i7p0P7Gkf+G7O9+it8Vlt/yviMWpmqk7WL89jky0fn1TfBleL19EcZ9YSiMlb90Zyi8+4wP04UOf4u0iZ9IuN1KnUFrrkpjfJwcQeFB/bE+NeQ7uBZSIwgHXywDARgl0FeVXE9Yt29nBFFbgtvvkSwoWV/2zq9vpKrmJajNEnzfUvkQtMFEI2ULFwyUw3ACd9IlRH7IdbELEolc21T3PhXxMwKWK6xxDSUtaJQGgK/GDbsTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u6Q3FyBDjqpHK7cxCsR32tTrpWxD+QJUFx3zc68ciE8=;
 b=H/CBtssXi35QXlDHaxa9csyTLuOjG76MKUjlBIkMPFkr/UQHXx4qkV836qrCTuPnyymAiDgFlgwWEPLM/Xr2V/Trk+Ngm6Cv6eevoT5VmQ2CQC9d6eJjqMYRL3WBbkYAkeg3Or/8Hu/OEvS5M15F8zv6k9cO4JI474DtU1FF1OprXKscoPvU+n4n/750fyYss1j9Ad3mC9jF1wRa1eaSD6ahO99H6aAHnHeAvHjxYm8ShayvgRYU0hdGuKFc9vNNWlODqQlvDCu14pooP/qqpw3zgBCfkt9voA6wWOzKMTr+LWuxLxtHoj9biIPGeW8JGKBQ4fptppuIrwhpblMqrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6722.namprd11.prod.outlook.com (2603:10b6:510:1ae::15)
 by MW5PR11MB5907.namprd11.prod.outlook.com (2603:10b6:303:1a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.32; Wed, 12 Jul
 2023 09:50:13 +0000
Received: from PH7PR11MB6722.namprd11.prod.outlook.com
 ([fe80::a38d:7b08:2962:bf91]) by PH7PR11MB6722.namprd11.prod.outlook.com
 ([fe80::a38d:7b08:2962:bf91%4]) with mapi id 15.20.6565.028; Wed, 12 Jul 2023
 09:50:13 +0000
From:   "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "clg@redhat.com" <clg@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH v4 02/24] Update linux-header per VFIO device cdev v14
Thread-Topic: [RFC PATCH v4 02/24] Update linux-header per VFIO device cdev
 v14
Thread-Index: AQHZtJP6abAtyMZZQ0mGEdgI1BSU06+1wX4AgAACbICAABtoAIAAA+UQ
Date:   Wed, 12 Jul 2023 09:50:13 +0000
Message-ID: <PH7PR11MB672291F4AAAF422BC824D4E69236A@PH7PR11MB6722.namprd11.prod.outlook.com>
References: <20230712072528.275577-1-zhenzhong.duan@intel.com>
 <20230712072528.275577-3-zhenzhong.duan@intel.com>
 <87v8epk1sh.fsf@redhat.com>
 <PH7PR11MB67221F2DE29B1995918B94159236A@PH7PR11MB6722.namprd11.prod.outlook.com>
 <87sf9tjwuj.fsf@redhat.com>
In-Reply-To: <87sf9tjwuj.fsf@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6722:EE_|MW5PR11MB5907:EE_
x-ms-office365-filtering-correlation-id: 9782a3fd-18ec-4fc3-0135-08db82bd6373
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F8wbPJUSSlo3CAZTL0y6rlxH7sBDmd1DlKINRJuet4ssi/fXCa9Wq9iPCZNkWiGzXXyHBGVO9hcF6t1GW7DLEQc/zCFCu8P1i90+R/HWjta+GMrkl9IM5peDbJN1YQWCq8gSikUAxDwc/c9PO2ysoA8pTuKjUYt1E4kPJtG4DnPeGLqCNr3tswLxC2lPOIh8y6dOEivBXXMRvCRADj93syzZJ/cDEVNU5tMkDkRwjj7FCDhEwR5uPJHtzlAETpNSgWsky9q9ypTt291I1Q5fOwrDvXvQdZIvXt3ctqwsh8ppDC7gmEZq5YT0Wd5xqAujFzNoloG5rSFmLk7XafKWxphzWOnq/3dCjB9UX6z3k0OKiH2FH3TxUmXrtTaemhBDmQOT8ji5oT2xMNXITmlI6B0FXj7tzbd0tFjsyFMldNiWGObsHT7FkSnbcIQySG9OpVm7kQdKp72EqNhYK3Ysk15AL/TUsDohULgNWGe0YCYSZFxQy61xaBwjg5bxEgGatGFap7N6gBsqKQNZgmQpNU9/WHwKsavSveNE7jnObYh4yW9dyIgwmef/UXCBUfe93PivZGfXb01c3GUcBcTRPVncryeKqHAoVBTZnUg0Tmzb5DriVsowLGu4sKJrjxrT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6722.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(136003)(39860400002)(376002)(451199021)(38100700002)(38070700005)(86362001)(82960400001)(55016003)(7696005)(110136005)(71200400001)(66946007)(54906003)(76116006)(33656002)(122000001)(26005)(186003)(9686003)(6506007)(52536014)(7416002)(5660300002)(83380400001)(66476007)(15650500001)(4326008)(66446008)(2906002)(8936002)(8676002)(66556008)(41300700001)(478600001)(64756008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?D3qjS15Fr6xyvLu3N7R94Mdmaj5aNv95zfWi0UlVvH7ZCeGYFkFqqdX+ff05?=
 =?us-ascii?Q?Dwk1i6jzkEeiE2lyrDC62L0H1S2H1CEDPWXQT5V3WmDS5kZgcGiOw3t91fbL?=
 =?us-ascii?Q?JcsU2s4+68t/G+1WOSTb9do0CiXLrxBQAsD2xtdxqa9PxTu1UnOunp4dzpT0?=
 =?us-ascii?Q?iYe77kR9r3YdEOlgrD916Ehf/9v0PU+LBXMXEVhIHtsYQ2wc79ulKQ/Bo5jm?=
 =?us-ascii?Q?ykefHBdpDz4ZNbmqCRyIHzVhlyImI88aOlyyVHNuibFH4ysJu/Er3Q81phpZ?=
 =?us-ascii?Q?AgtnR5+qFgIRpB29obtKnEcB5iWPHAhOp05xzjgWXs3ZYchD5z53HLEyb20I?=
 =?us-ascii?Q?PsbrjDiiktLc1srHceF1F5NUHZD3NuZQ9Bu0vH6teMwCM5z0rb5Ow3acdEhf?=
 =?us-ascii?Q?oLGOaA/RtiOl58LC2dYXX6dAE1LsLMZXJomZnF8J0yemHi0CajFnbNqLloO0?=
 =?us-ascii?Q?Jjowd4mJ7T6zOvO3MQpapWtfoI/ANo8pcDicCVpv9LgQYmsHAGCmnUXPhvKc?=
 =?us-ascii?Q?1srFo6EFBsQLMHPGjh7eve4aVKbFwZ0OCvTUUCFp3WDGuOcm7U4VUJMTT9po?=
 =?us-ascii?Q?uwZBVw+c2Ev7hQFsjvYGyla5D9XdQS6S7Szdeae8R9qOwfNbWyFpbzLiKb+H?=
 =?us-ascii?Q?TKoAwgGgYz/fdnIl/3INSR5lObjopn/ySyT0q94+CHkzhUvPebjoFmdhMLME?=
 =?us-ascii?Q?XDPU4mXc0m0IBcGkmp/AMAI7iLbBDnzbdyHyND6r+zpGQN09nKwL2+kagPBx?=
 =?us-ascii?Q?UtLq6dz7bkU6eHj8Ha4rKqrb9d+GMhdW4TvN3TgC8i4/l4HRPyuEm+31uo8Y?=
 =?us-ascii?Q?Zx+/qmbIzayOJPGi9lVx9aoV9mGW5vMl/L4p3oqjSraj3G6OeCdLqSQsTqim?=
 =?us-ascii?Q?FSqP/UkRdyVaFo6T619LzFStpJep699eOOpYbzB6j6u6KHUQM3SY52NWEfPA?=
 =?us-ascii?Q?7F4wJYwCvBTe4fnyUXdZ8umLi5ZM6emthi/GnxZDn4UXyy/cKAwNR2J1afjs?=
 =?us-ascii?Q?zUsHo/QL3LXiAQX+VPqilOI2z4Dcli7/NAxOdpLidWCgcqPn9qqhz7rbDWRe?=
 =?us-ascii?Q?ZdDc0xt5QSkLB8YPatxVZYY8f26btj8HRwkwksMdiKZiG4WVA0/Z7ACU6Asx?=
 =?us-ascii?Q?JynJNny0h09GZfzXkCwJ+WMOR5M5DxtGeqg4A9v7QUdljF2ZFZJPVRPAoJft?=
 =?us-ascii?Q?v9UGV67AIbxleMgj1rJK35wMpkaGJx4Jvi992mprR0F8Q4CIyEFdWCaeEduL?=
 =?us-ascii?Q?bBchAa8XOMv+NPwB7zdzaTTNh0wSFT2YeovD9KDwLWKaeBbGKqECgMcHao9g?=
 =?us-ascii?Q?7VfrX3UD8H2hLNuqXQDAZUg/0x+HjN7+hcB7KdEHme76EJRo2+GYDi01Tsy1?=
 =?us-ascii?Q?HZk0ri+OIZQB2MyzCNDudEXUDlIu09JhnUc/vTF1lmJbdE5kCsjeIJCusThl?=
 =?us-ascii?Q?ILpw23XlDSVlJHBfmWVEZwXsPOXptTz4D4PleUvKaTjo+EegQWGGzBDlhAYf?=
 =?us-ascii?Q?TPxQ+kMEBZ3VH3Nwgd5DH0esc+rRp0sZR52zdAISydx3x9lcgw3pEKJJy5+d?=
 =?us-ascii?Q?amOjNsg6yc2LxMhIAKTDkEC1TCKcqA1/XZZEK9iE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6722.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9782a3fd-18ec-4fc3-0135-08db82bd6373
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2023 09:50:13.1509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ln8ucajxqc438uT5zuWKvNaHbhcm4RiYBsIFqDOU/Fy3srQmhPUt+OsfrlK7HpXkFDHkt9/UqISb5uot/TwVUSc7ZtzGkbbFtSmuIbtiMWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5907
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



>-----Original Message-----
>From: Cornelia Huck <cohuck@redhat.com>
>Sent: Wednesday, July 12, 2023 5:36 PM
>Subject: RE: [RFC PATCH v4 02/24] Update linux-header per VFIO device cdev
>v14
>
>On Wed, Jul 12 2023, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
>wrote:
>
>>>-----Original Message-----
>>>From: Cornelia Huck <cohuck@redhat.com>
>>>Sent: Wednesday, July 12, 2023 3:49 PM
>>>Subject: Re: [RFC PATCH v4 02/24] Update linux-header per VFIO device
>cdev
>>>v14
>>>
>>>On Wed, Jul 12 2023, Zhenzhong Duan <zhenzhong.duan@intel.com>
>wrote:
>>>
>>>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
>>>> ---
>>>>  linux-headers/linux/iommufd.h | 347
>>>++++++++++++++++++++++++++++++++++
>>>>  linux-headers/linux/kvm.h     |  13 +-
>>>>  linux-headers/linux/vfio.h    | 142 +++++++++++++-
>>>>  3 files changed, 498 insertions(+), 4 deletions(-)
>>>>  create mode 100644 linux-headers/linux/iommufd.h
>>>
>>>Hi,
>>>
>>>if this patch is intending to pull code that is not yet integrated in
>>>the Linux kernel, please mark this as a placeholder patch. If the code
>>>is already integrated, please run a full headers update against a
>>>released version (can be -rc) and note that version in the patch
>>>description.
>> Thanks for point out, will do in next post.
>> About "placeholder patch", should I claim it is placeholder in patch
>> subject or description field, or there is official step to do that?
>
>Just put a notice into the subject and/or the patch description; the
>main idea is to prevent a maintainer from applying it by accident.
Clear.

Thanks
Zhenzhong
