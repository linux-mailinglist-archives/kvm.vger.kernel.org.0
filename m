Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBDD52CC3A
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 08:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbiESGw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 02:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbiESGw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 02:52:26 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D29B8722C;
        Wed, 18 May 2022 23:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652943145; x=1684479145;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/cG7Za+7/M1bF3yDnyScpTPZmeJpY7sHbMHyaozXWIE=;
  b=hGDhkMDPxf+AdCIpZNROWH1vTdZcMqFrZM63a7OEQatrJIr8Y+GtyISg
   LCqNX6Xj1SF/QHdf8mOVfEoINYFgTrd2hUti/jTbMcsCrSQbHoBMRRO7e
   s7Yy9Aec2ZsxCD6gMIA6OgiAdgiK1tgz6oGs076Pn5cselqM0Xu226lpt
   PCxww8rWhz6Ys+Ebra0fSQqUNukMww1UaWRigVJhBUUkF5uHRThfCgT2s
   QPjVvW0rh8vvElZjvBbnWc3DJdQ9J2n/I89PVcYrvnClVz2KoqGc/ILBX
   WEsbBslY8nDXVE2Ua1NoV5bA3WSyJlvdxgHXQuPwO92uNOds7x8viOubd
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="332674244"
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="332674244"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 23:52:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="523924117"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga003.jf.intel.com with ESMTP; 18 May 2022 23:52:09 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 18 May 2022 23:52:09 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 18 May 2022 23:52:09 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 18 May 2022 23:52:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xxse//DyZSdWF/KjYqS0L3CSfGhXdujEBa0F+lkykDqy+uBD4OSEiMBrrZKFJdEWj9MGDAt2t3JuL0Kh1bPbr20t2tdBRBxDy9CM1999DXg39O6puhNrOZ0kWXkxgaO7qgqBCNI1Pfq9QKR05kfSXyDSSiLPywMA3jgPNA/A3jrTE1SHa75271TaNFArrFxMHVpSP4kk4RUwyTnzcQTuRRlxZZF5poPpQs9m6TZOJVyogBjyZKnApTT2K1zrkFoD8Y7NbIH+p/D5c3e3gr6VG5zRzliMHMcy0W9A/8Mm6KQc7ZjO1opq7TyfVTCEVblOtQuYxyW1O5oYfJDdbF18EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4op4zzKKgMoc7Wb8CdIlwVGey2cW67/iw+4jwtcn0Lg=;
 b=kVfJSA2qU2ZOiUcUDGt28H6rJtbV01pUGSGTQUxF4QA3pTmY1SSo49U1raaTuEG7mI3Jnhm+99X4qRBkGJcm3iS99uSZ+MluBaQQSiptH+hOIQDutefERpUiqARKsGeeyPY/ZdQgzIbwqU/PH7QKc5GdqAuRl3bY2BQWyKYDrlVE52kYiP6grmtQv15/KyuYqzVzTDqyySelYquPmemGjVG52AmMPIP2omkt4WbaRE0UUYQzZDtyuIJVOrfMERKRNA4accbkoV18+6JzpsRIllqLVS/djIP5qllvOt0z15FMNSCzUyovnqBlEqj621E1DY+RxmjRCYl0XGPfRjNpSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MWHPR11MB1903.namprd11.prod.outlook.com (2603:10b6:300:10e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Thu, 19 May
 2022 06:52:02 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5273.014; Thu, 19 May 2022
 06:52:02 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "hch@infradead.org" <hch@infradead.org>
CC:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Subject: RE: [PATCH v2 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Thread-Topic: [PATCH v2 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Thread-Index: AQHYav38r+LwcdssakyG6t/K4P4DTq0luTjQgAAJoICAAABuUA==
Date:   Thu, 19 May 2022 06:52:02 +0000
Message-ID: <BN9PR11MB52764D919142D6917685B3CC8CD09@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220518212607.467538-1-mjrosato@linux.ibm.com>
 <20220518212607.467538-2-mjrosato@linux.ibm.com>
 <BN9PR11MB527684F9BD1B906B930E4A468CD09@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YoXoL2tt06sEz9Rd@infradead.org>
In-Reply-To: <YoXoL2tt06sEz9Rd@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6331302d-b4f0-4aa4-03b7-08da39641413
x-ms-traffictypediagnostic: MWHPR11MB1903:EE_
x-microsoft-antispam-prvs: <MWHPR11MB19038FF09A4F257BEA3D57CF8CD09@MWHPR11MB1903.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GBK4YKKUB1Vmki/doq9ACXkIcTLkkkZmyYtRQfvjfACa5nv6yl+4F+sYVLv95LYoXBiVPA+Zq9PJrYTEKpgQu5Ih5hHJROr5hETiv5StQO577VjflIRbR6KMhyQENcxPu3WxFoU6oQZwfrOIK6Kn4OuJBo4PTs18OIqWNO7s2WUXgiEh+MmMHvzO96CzMOWqvxIxfr7KmJ2NOogXtj18W4BrUEdGbbXjXz3OOn3UIhfycoflhYMJtPZx9jNyEmgIxLfWqwIU5PqwbsiPsLSzOtBrV+Z481UyfWLq62OXPEUNaCGHoRGDhb2dm4wzXu0efEANqOnl8oL26ED4p4r0lXBoZWcKeubEbpgo1cjBjBjbt1jyBi1URhJ95cYu69IT04sv99aFuToQ+eLMZi/Tact7BLvGSoz+AOIbmcoE8FWTB8HjbBc8VNBYlUMqNQPVz9c84TynqUDI2nyNyrrmcWKEWr9hNNja5Swg3XqjNNKvhmcJVhMHxCjlsqIxImglIgRKrP46kofUwgUwKqidwbBRD06bzgGX2pzOU25IRDlUN3802YDEIEcqxADG5n18y5rcKumKcpeS2cAqbfGz2CKvCuyrjLDvvP8nMbB8yWMkEV0NFh/mCvtbRUhGPp0I76Qt2pafC5ZrjOhKRcn9ild22x6R6LW1/dJH0AO51xWvwtCqSg3vl6nTW9WSmmv0Guvy3ygp4+08vxotJvywKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(64756008)(38100700002)(8676002)(122000001)(4326008)(7416002)(5660300002)(86362001)(76116006)(66946007)(66556008)(38070700005)(186003)(8936002)(508600001)(55016003)(6916009)(54906003)(71200400001)(7696005)(82960400001)(4744005)(316002)(26005)(9686003)(66446008)(33656002)(52536014)(2906002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qIOTZvcezvPE4U5LO7bY00ae5syd+P2qVKWrJ7dP5fnaH6LUUuTibrWuulmT?=
 =?us-ascii?Q?NyuGdVF32fXb9TKQ3T4agkl+NIouo1G8C8E7xy9xRy7SpwJhKZOY9xbLEsP+?=
 =?us-ascii?Q?laGOYmVdq0HdQDYXNRz80KAy/LvebCnK0fX0CSQawsuNVIr/ZxNXHzmOWO8a?=
 =?us-ascii?Q?LEvmzG0eTRJLjivxyx5dwCqm+Yw+oALkC+j9msC9yE2b8LvGWWmk4DdCLhB2?=
 =?us-ascii?Q?57UWXcMOa5YfhPmYIGcy6N3KD+2J7l66Z+8uhP/6QGSDUwlcB8YdpAXy0W6R?=
 =?us-ascii?Q?DRTqLCbwpFlJLGW2ggjeEskXqXJylBglKDin1VERvGNw80vVwX8zLwFySDbI?=
 =?us-ascii?Q?t5FyHRplz0yckTnumo7gV5Jw6g/v2y5wzw4fgFh9vzG4KeycQsMOA+2yTERz?=
 =?us-ascii?Q?AUV6BBMLE5+g9NN8xA9QLn/Q5mfA4vYgG/Ys9ezx2GU6GKz+E/6LuJlsNO3q?=
 =?us-ascii?Q?g4HsHInYkgOa0rsmpoJIhZVrHjpbrcstcGCkELpjm8ab3+wJAhjqXDP1jFgK?=
 =?us-ascii?Q?gEXqbjX5MW9fzi6Y2D9LAAm69+x7zoFr814hTYbu1vnit8JqFB1p7YzvoIKI?=
 =?us-ascii?Q?IvOnn52/gnqoAnBmJiElb8p8nzZwSClwVLct0w/8MoFdcrGwS1NK3zU5H3j+?=
 =?us-ascii?Q?sfb0Hi10UI0qyXi1F/zbShcN9RgWyLPc66HZ6aRNI6PeXKNfOgPKkdcRD1+u?=
 =?us-ascii?Q?kP80sWsxrMGNG1QewmfhkpDB3bvFugqv01MyJArzH/i9kVM38j2kl4vc6PGY?=
 =?us-ascii?Q?gXwk7MetsHVXp6rqtNQYodG273YpTq4Db5qrQepdItj6L6TMsXKjqia26Pc4?=
 =?us-ascii?Q?lCuWdIE/kAGooTTAt0iIKs1VFj9O2SqK7vxkSKjYriAXWEXXBF1EJ8ORjgLK?=
 =?us-ascii?Q?zGVbhDPvhvVWvirooZmnHZFMRAY0LMRjS/kfdXTEs1tiFPHU+6U97tC7s/r/?=
 =?us-ascii?Q?HOAI8ysnLhCp9GSHCuRvQxes8Cp8jacYbM9u0TvqbllyoQwaBcAwtChU7Ho8?=
 =?us-ascii?Q?QICajkDswqZpcDlEur2qoPto/GNGP+6HXVdV2bY1cbjUT/Y4W7Ezq3XIKphw?=
 =?us-ascii?Q?QJctDPfXVt/ThPAGFTlh5sk3wGMbaV5JxiEXyEEtJVcEp0BFGsFscp78RJFs?=
 =?us-ascii?Q?szvigiMc/Wa5khguxQDnanmHAt9tpdOHj6HqMOzqrjoJILiHtjIx7PsVt+0y?=
 =?us-ascii?Q?zSBGRTBGYZpnGBu9AQ+px3IKW785ZUD+xTnpoooJRCKhMQxLYi8BwGW8waq7?=
 =?us-ascii?Q?L9iKcly/HOCT0o1/lDiesbZgMHxvvlKZM65vRv3dZR1FpFLs7w/vMTdKfNAI?=
 =?us-ascii?Q?uFL7ip931UowMehRkocM9qztRfKO5JHJKizCwTkstEEfvocnAUgDujKmGyYL?=
 =?us-ascii?Q?g63/X5rNmHI+i2MBq8Ly8HX+f3m1yFtXAudHPGBdm4GOaXmnQ6lodW4Sb5D/?=
 =?us-ascii?Q?mmPBdykZGAuMhvfEPZsPi1UCRJOoQTmeNGsrJ/x2iJcM1wwp3ypQ0jb8o2f/?=
 =?us-ascii?Q?t7L3a+Y0doZTaHmP3qnzJq4Y7pwm3fJR6efjDP0H09NSZPNWYVXv0L6Iby1W?=
 =?us-ascii?Q?/8KUxOxzYYcv/iTqlmsmJAQd9KhVVIodNTGHPLMxI67dTnVqZTE0iLsy/wSS?=
 =?us-ascii?Q?PH/Dm7Qr3GaruQd5V0gq5JdRZhwynG60UulMNynbjNOiRtOk/qcsAnl/s+Zw?=
 =?us-ascii?Q?3nQI0CBc/itpJZogMTddBFmUgg5mexaBqxbfj67/W/5gmWYDCA1aDB5yjU4t?=
 =?us-ascii?Q?NuOOjIskNg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6331302d-b4f0-4aa4-03b7-08da39641413
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 06:52:02.2492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eVdP3EJcQB3qYLczN3LK2gV+54mW2o8zY6ugREp7BpVHcnX/4ZbZFvE3EuD+G1VKM4J4ER0O4k6AwT5A06Tsow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1903
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: hch@infradead.org <hch@infradead.org>
> Sent: Thursday, May 19, 2022 2:48 PM
>=20
> On Thu, May 19, 2022 at 06:43:06AM +0000, Tian, Kevin wrote:
> > > This fixes a user-triggerable oops in GVT.
> >
> > No changelog.
>=20
> ??
>=20
> the cover latter clearly states what has changed since v1, and this
> patch has a good commit log.  This is exactly how it is supposed to
> be done.

sigh... don't know why I missed the coverletter.
