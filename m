Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E397C7C7FAD
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 10:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjJMILa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 04:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjJMILD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 04:11:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F2A12A;
        Fri, 13 Oct 2023 01:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697184657; x=1728720657;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fQhfRWQWQh0Rxebe12MGYwRTy/eosW/S1RAiMRPHyW4=;
  b=G9wchZzuLvG4fSoPtgijSvaUgnH4vxyPG7iCWHP6pr1j2Ipv7P1dgIXY
   ru/QlDEyYZ2S/2/ixl9f/bvi1YuPkkOCBilZyuizC6+pGD370TS8wKny7
   F1k6OhvV7rpPLpQdI4DfUGSFBo+lScPidoJ17xHvh6qgm9w9JqmDV+lvw
   UygYFo43YhVVuLXJ9vDNcTEaBs1/0rpMjFqf7Vna5q/dY9EOycRwBeZzX
   TbVU1qLi53fjC4gUNcmaAykf+/Dqyndt7dn0MdUa0pKthaRJc3eXgc61C
   PL1mpOREnUnrTNNmSGq4vc/Ot+rS9l38lnaOgIrRvG4AP0GWoj2tlDD5n
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="370195198"
X-IronPort-AV: E=Sophos;i="6.03,221,1694761200"; 
   d="scan'208";a="370195198"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 01:10:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="784056923"
X-IronPort-AV: E=Sophos;i="6.03,221,1694761200"; 
   d="scan'208";a="784056923"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Oct 2023 01:10:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 13 Oct 2023 01:10:56 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 13 Oct 2023 01:10:56 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 13 Oct 2023 01:10:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ahO6bDrWybrU2++4KvgoyLIVBsBlbddLQwxGk7GhBfd1bJCtaqtxG+wx/cHfJbfoZId2ARhMpwMgh5Vazu528ccvJ4SdDqk10MKCa7WM1NiASDuz30RSeuPJ0bDik/2+pzrLzIntZllxRN9Yi8dJk11sB4aHk6uFPKVGUUrs5JxEjt0Cg3ZvbEu1hG9+zB/EMwk/oW5VgKpS8rb6D1lUuLQ/4bcXcu+MndYCMf3U5h88f0hbMRIITvL91PNTP3H2KRW/ZCNR7F9FvsywrHdz8tS6Y51O/f/Zj+dVXY0AVwbwbUM0pq6tAenOvyBn3+gVQeXI1Wg32CZ6y7wZWoOO8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fQhfRWQWQh0Rxebe12MGYwRTy/eosW/S1RAiMRPHyW4=;
 b=JUNW6OISxpOsUPgtN85E5jcjFTH4tV2xcId/9UEkAVd4hQ6vtRt5Cg4BNanSAPHl0/eTZqRBDqNmhkdgKsSh+aILe1dvxRDxoaCqdGLb3WXkv6QaToYtSmMcNoH3bwQipGViMdC3nrUcZSbqfSRhzqwy9m+pSFsPdlr9X34sLzsCLdAkgkrp0zZ1lmKeSRRBIKu4GwmUoT7UzPO3dR+hrXxM+yX8+KSlzY26B320PBa+LV0hVfOqVZHKzSNLjgdoeCpCnupkYk/5/tIMlbW/ogWePt9hQh0FZOjduox85+XUP571VTRapsnydf6/ltV8SXNo93G8hnzo744/BT9PcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB7813.namprd11.prod.outlook.com (2603:10b6:208:402::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 08:10:48 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6863.043; Fri, 13 Oct 2023
 08:10:48 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [RFC PATCH V2 14/18] vfio/pci: Add core IMS support
Thread-Topic: [RFC PATCH V2 14/18] vfio/pci: Add core IMS support
Thread-Index: AQHZ+HP7H8n8M1qsCESF8QGnzw9E4rBHZG0A
Date:   Fri, 13 Oct 2023 08:10:48 +0000
Message-ID: <BN9PR11MB5276891129DCF849D9E6375D8CD2A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1696609476.git.reinette.chatre@intel.com>
 <0f8fb7122814c5c5083799e935d5bd3d27d38aef.1696609476.git.reinette.chatre@intel.com>
In-Reply-To: <0f8fb7122814c5c5083799e935d5bd3d27d38aef.1696609476.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB7813:EE_
x-ms-office365-filtering-correlation-id: ed91ffa8-202e-4123-280c-08dbcbc3e878
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LazSgzwxLrGWmCnY2ZUIM52MX4VoAKawP2+stOj3f1IubR9q+xhPnUEa88m00C7B6BCAQu7S/oaCR8uTl69xxctocQaCZs8PhsMOz8SEAQhgeBzU25X9A7zNL4fH9v0Qj09Cqc5zivbKax76yv1w9CwrmhKfwyoQ6vVqpAYpe+TrhLolHQmO/vNit5VEfQBaVoB44hA/Oz3amMMs7mWcA+zr6ZVujlwrthg0wVD7FmQ5Z6whHLQotipTehbbEYaERdciwluTo+7RJNVoRJztqF1zY3cd1sbdavJJdJtupU8RPXKj4eaQycr/rwCJK/U80Io1WZpHIEGjt3hONlN86j/pNuGqekWjzOTWJGzFtnrHRUP2gDuGqjsLf6fFVc1QiohlqL0sTTGLzZp27ZCZOfnlxKnnnJcPeNuZSlpxChvcyCJ5OTDvrzd6ANdCrphQdxb69rbb4BjfP9tUo3KRN2ImwIdZu76m+WfBk5NMQ3S/o8aznMZCj5+CL0kZXElWymYyqWDRpmqGS8rh8+J5D2c9YiNVynGOmMKur3usxK3wzY6yrhDqzwplOeAb1QeUXEYxlqgy0PdRk42J+HSYz8FSE3Ita7YeA1pmhsYKtOX+z1/SSAw+zaRWhQmwdhfO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(136003)(376002)(366004)(346002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(4326008)(55016003)(8936002)(26005)(8676002)(52536014)(33656002)(38100700002)(82960400001)(38070700005)(2906002)(122000001)(41300700001)(5660300002)(83380400001)(86362001)(9686003)(7696005)(6506007)(478600001)(71200400001)(316002)(54906003)(66556008)(66946007)(76116006)(66476007)(110136005)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PNahvoXb58E1IfBLFSKJwC1pI3cGql4wKMy7yMEhM5Ak1TaKMjOGBs4g7ObB?=
 =?us-ascii?Q?VBI4AmUzAE8TyB2wCEAF8ATeaq/C9CciejYAVhNitDe760iJ/+0VaXcBpcNO?=
 =?us-ascii?Q?6nUVbJVVLAGAF8JpbiyvX9aMDsGMl9/6lIyX+Z7yXllRbEzmID7yLMK5i/PA?=
 =?us-ascii?Q?XIM0cNsPk0yrjp6l1qw2o51SodrH9M+Pmu4WNi4PDdnCq9CjeZIpr2S0NSHY?=
 =?us-ascii?Q?LmKsImjpftmb5+EgLHSd87Dv4ZWLDDO3iJrKwXJ+F1Lajm7AazEt5PfThDLH?=
 =?us-ascii?Q?j0ldvpiWVfwFc+wG5nt1nd/O3djBn/Pd72bMy65DfrjW7Eu3VuzSrfenJ5AE?=
 =?us-ascii?Q?D7TQXNg9aMew/U+qPkSfXoqGw9FOGF+7ftUAEvy5TlsfIaKXOhvUs0rtFzJN?=
 =?us-ascii?Q?Bd0aW1Bjs8EKdIJrH1/x5j0g1OzhqmtcePU5nvphzcR8BUlsv90qFYLQOBw9?=
 =?us-ascii?Q?vKGSDVlEBc7awqbcBqBHBc16CRodvgVQnh1J3xMB50GNZPH3teHzUJLoaiep?=
 =?us-ascii?Q?aEyRm0zGlWcnezvPj8VmHNujighNwIQ4kKOtGNK8bE5aAjKiugwKqgcNl3Fk?=
 =?us-ascii?Q?GAkD4Kyec20ZnHkMGWSkUucWGRfsu0QmNEW8XYE7cg+zr7XjChP6TAjr0Dkn?=
 =?us-ascii?Q?Yjbvg7XobiPZSgzJC6VwDhh/2q5qNihbBYUWoTEdIza09q5Gp9hKl9AXTDzB?=
 =?us-ascii?Q?A7VjB0oJPBBxa4YNxOuI+NuuNsSTVgszBtT56eBMvckGcTYWCd7ZGmQM2Q0s?=
 =?us-ascii?Q?ulIxoNO1uA5KvKxlp1EnnzmWkVsk4zbcF8PHj8hBC2FbtNho8YUrC7NyeySm?=
 =?us-ascii?Q?QIFdIL28RDaux2TEJOZmk2TlSFNdSzOJSG+l0P3eF55qo3Rl+8hTm7KjI8Wq?=
 =?us-ascii?Q?qv8KUItRiYY03tHxdVW3BaGBQixjIwqqVgnWe5iEdop8BqfbWZ08NhLh/v/x?=
 =?us-ascii?Q?IvR2WzoIssSORaPXCRzsWQoZWfHhl+67WguzOqRB+zHrXwXOfAuA2N12z+UU?=
 =?us-ascii?Q?fNZCXcI91xYDMKdzQw60yUtBElfBnxe3ZAgrfnLpKSRQqOZgGsQht8bu6kcl?=
 =?us-ascii?Q?bXVuBoKsdjmUY2s2LRAq1no6bnlsne2IDJVx6hjyJd2E3nx/gvIvcGn2Hw1Q?=
 =?us-ascii?Q?70HmrtFz2mzWLE1xTMOkkY5qB9fNWugUxkx5TeoYoiiLBOyQmOS+dzbAPxGj?=
 =?us-ascii?Q?ntGqT773mUuEKJ0GPEOLmAhpz6Dm8Z+WHvhbvBbUjWKxuaZ5CBRBzkE0rXqF?=
 =?us-ascii?Q?8lHydKpk4JKYw9JJEwHY7S2ozn/lpSw0xgK4TE/NGwTNcBgHrrBdqAk77k31?=
 =?us-ascii?Q?mRVFGDTvxmqEbjX3IkJWN1/KqiKbMavZPzxxhNrflJz1NmYnxBFcN5AfCXzx?=
 =?us-ascii?Q?QWeYctvC7DiofNw0OaPFrCzJ+/aLv0P3k2pET9rOG03Lue2dQhgVZE52GUtm?=
 =?us-ascii?Q?8hvt/hNaalMGLDPI4JO1DjgYsPz/nazgaF5Ts4BTBPNznMX2ikKe+kbEayLK?=
 =?us-ascii?Q?kNd1QHJn22iO5D9o0hw2javsVUdfmhcwtrh2aTf0FUgOOK4i6Wtq2lyzVgV3?=
 =?us-ascii?Q?BKHHpO5qu4JRQTKFb35uALseD/yvhFTD/raJGLVi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed91ffa8-202e-4123-280c-08dbcbc3e878
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2023 08:10:48.2184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZxDQIbVeCp5sSTxLMUaxTX0wOUudV4YINIFsAVRTCWyomkvIxHwXQknzU6Pj06XN7kXtCmUtFwlrg5XdwI5CWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7813
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Chatre, Reinette <reinette.chatre@intel.com>
> Sent: Saturday, October 7, 2023 12:41 AM
>=20
> A virtual device driver starts by initializing the backend
> using new vfio_pci_ims_init_intr_ctx(), cleanup using new
> vfio_pci_ims_release_intr_ctx(). Once initialized the virtual
> device driver can call vfio_pci_set_irqs_ioctl() to handle the
> VFIO_DEVICE_SET_IRQS ioctl() after it has validated the parameters
> to be appropriate for the particular device.

I wonder whether the code sharing can go deeper from
vfio_pci_set_irqs_ioctl() all the way down to set_vector_signal()
with proper abstraction. Then handle emulated interrupt in the
common code instead of ims specific path. intel gvt also uses
emulated interrupt, which could be converted to use this library
too.

There is some subtle difference between pci/ims backends
regarding to how set_vector_signal() is coded in this series. But
it is not intuitive to me whether such a difference is conceptual
or simply from a coding preference.

Would you mind doing an exercise whether that is achievable?

Thanks
Kevin
