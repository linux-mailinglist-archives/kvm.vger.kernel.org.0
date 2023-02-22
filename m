Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CABE69ECCA
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 03:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbjBVC3b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 21:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBVC3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 21:29:30 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDBB2C642
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 18:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677032966; x=1708568966;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a6Deex69jiCrDXkQzmd+xToHgG8o1bT0YQrU+0ak/Z8=;
  b=a09wIZGx1bCvoXKBkjKmUGKbI1CJbx35Fx6ZhpTIeQaOIESbQoT8jSwm
   04cdGS7Upe88+nVkFfUafsITIrGxs+OaPlyYm1B+/g/8KSrM97Tf17ya2
   1B0m/jRVUFL4PCY2zB2DdI9/H8FZKrHywn2G9AgTc8AVeRdYe2/H6ZrUU
   kCyuotvd4Szk459276PD3UxyTyhzV6w6AfANEQYAu8a1ChAzFjBnEz0p6
   ejjE82H4ZVYJTWNiTG9udI8v/EbbXj9/wl5jy8N4XRjwtWUhfKOCtT9FS
   abqgTUJmvckxULPT5/3vDpzrFz4OaS+6B/QThJ1+7OMcaO2QB1jsAMrtL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="395298572"
X-IronPort-AV: E=Sophos;i="5.97,317,1669104000"; 
   d="scan'208";a="395298572"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 18:29:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="621743972"
X-IronPort-AV: E=Sophos;i="5.97,317,1669104000"; 
   d="scan'208";a="621743972"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 21 Feb 2023 18:29:25 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 18:29:25 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 18:29:25 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 18:29:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYH7SVjyGmC39wfZShnKzQ9QgSfszLSkmjOlUV+J1ZwxP9Z5/ZYNzzZHOB1Jh4s2kGjMLV/+RMsqv7C+WTYN/yxG6urkfc2CBoql3ruLiL7It8fCHP3Wpz/BG5ANSqX8Plv4sQGV2mKU58N9vaaDX6p/TSwoDSp2+dVNlHA/iP+AZUtZhhc4JE0WI7AQJb0rpACCpsBzRQpzQujY06wTvdJQfbzvtK5D9bRQ70MrGKiU7eeKIvxJOYhEeSoh+NLYJRA5zn4gmCeNB46/rSkOyDKBNCVAsnzvC4oFI0EjcJ90itAof535KW2kMOOutoLjo38rPyIe8IjbpeUI4rvAfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6Deex69jiCrDXkQzmd+xToHgG8o1bT0YQrU+0ak/Z8=;
 b=FvYC0YX8+VAEs7tB4Yzd80D+LEg/68CSaMIWW4Qa4Ja4/mX6zzxfUi4/H2RE5Wt80xBM+2U+bBfZiRmcdfaqH3S/Pyv+E4O2jXuSFBZiltcXOakCCV9XoHPcBbrX+gAJdM+Dat4jHr3Ea1C75YgbHNounbjKvKz/iLjbhZvMoWi96Lm/uQO1y+NEQ+o1Q0oCmEnkaBVCM+xOFnkunyNWBmYAuwvWody+QaJrQD6f123rkfjx0KwZDUzjAIhJ9Lc8GWAoFADZJiP8KRBEvxXzLdJMGvjLU8us9aQRl8YTU8KeeWuIUMiVNSjvLh797Fr+Q8Gn1mymHKY44fUxoaQSXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB6842.namprd11.prod.outlook.com (2603:10b6:930:61::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 02:29:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 02:29:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "pbonzini@redhat.co" <pbonzini@redhat.co>
Subject: RE: [PATCH v2] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD
 before VFIO_GROUP_GET_DEVICE_FD
Thread-Topic: [PATCH v2] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD
 before VFIO_GROUP_GET_DEVICE_FD
Thread-Index: AQHZRmSItDL7FXx4tUug97Bsv2sBaK7aPhmA
Date:   Wed, 22 Feb 2023 02:29:23 +0000
Message-ID: <BN9PR11MB52763ACF2219510F799F8CF88CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230222022231.266381-1-yi.l.liu@intel.com>
In-Reply-To: <20230222022231.266381-1-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB6842:EE_
x-ms-office365-filtering-correlation-id: 52610bb5-69c8-446f-2f3a-08db147c9c77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5inbPwQjklA/D0h2Bj+Djg6f1tOfMXWYw5yR6x6SNGxtcN5rnAvnRcq5M1PRCTGTUaYnPpxnT4NyjTpE2Y/2knG20X2iVV4bEwxS5FtZPYTnXKNn7Ho7FdObJbHtCye7bJuNzinPi3JBZj8KD1LPYV7NxGCh1Vg4lspfHvPUiXKaYRA6lApTnW9s9uqdW4Kz2PpWv1tETxuU45xwupiXsrwCq4K3FPPc3JiXkuUe7ozBGfBKmljRkHCnmV+v4OYI4a9QXMHwZllauSlLnWYt8TFDy5ZoiZnI8Ibsa4MMCXNxyohca6h+V68HLFL8OyFKnsnpkd6fQ+y7T0Jj1FnLMGNOW9RQgB4NKdIa1jNn/RpsKx838CvmVUJY0yMpxZ+G8fI5Kg9lj8nibQjWm3DIUVcgvmxYKzEiwETFErE9U6kw9Z0pNlRgjcvAlkieIUvzk7pi/GHWcTpl5BOo42DEBUPxOV9iLoi7MNIPg1GhlHFjLcJQRbBXp6rW2wzO3PXxNeAK8R0rGYOzzU/toOdsl6QJVfcI4zosDk4mhFSHyhINk+AdqPQ8sJddeU3p42RkQmKuaTXsM6UVn5y/OJBhXNGqACZMQnjvIEwb3lJ+vAQWaN9Qe2Zz5XxkUn7Qwk6VKe57Sacw+Qhkt0VAXy/i+LBC3VfdgACqC9CeBo+hd8J/SuIXKC7coJfVUhrvSQ2DzvliiQRy91tu201G37T24g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199018)(2906002)(76116006)(66556008)(66946007)(66476007)(66446008)(33656002)(110136005)(71200400001)(54906003)(316002)(86362001)(38070700005)(55016003)(558084003)(478600001)(41300700001)(82960400001)(8676002)(122000001)(7696005)(64756008)(38100700002)(52536014)(8936002)(186003)(26005)(9686003)(5660300002)(4326008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4nm3VSzzKxQnh6oyDDuNRLAr9JcYTUdwNkAOrg3yA3hpFnOwJesMt0ynjzRv?=
 =?us-ascii?Q?FjhFHJtHK3A2clBhjjkq+0s4xrM2b4mMurEYa0VEXM2VRS7f8Ow7ugvAzV6W?=
 =?us-ascii?Q?vAyIN7SvoXsL4qrIM7g1Gkp6MSOTHly4gTjP/sY1+deaRHTtfkH6PhXS4FZr?=
 =?us-ascii?Q?6kAkELm7Zx8xPCqtxTPZ2E9lLcK+Uh9m87ewpeOvXO2xm2BjnFkO1ulMvSfp?=
 =?us-ascii?Q?7KRiyQ6TYVyd1caJ/ChdhbXKPo2zlAD2pok6ikX0csbyyewBL5V+kZrFaNzP?=
 =?us-ascii?Q?gJUZoeHdwSkEUMIMIgcT7aKQbvNBZh8uCFzblSQ4u75gU/sXFpeEX+Oap9Rv?=
 =?us-ascii?Q?7PP+k3WhFdOn8vnP3oI1C1n0Jj5rEeCAm6fc8MpyTG+DV7fWojkmDBHjMAWJ?=
 =?us-ascii?Q?AEnWuoKOblwnGu+OszDv9Oo6KvEx5tXBmQ37wzx8d+vfyJiHjRNqNpQ33JnS?=
 =?us-ascii?Q?CnkCxd9O6pKuTnpaY72fDG6MeFT6K7FViyK21j/SURGbemSEKkDLpWIBQHCL?=
 =?us-ascii?Q?RnnTb3wV5ZJTgAuJ9GVfpfJf59KhttiKOWWCwGriMMyWfg1E3we+BBsAzyHk?=
 =?us-ascii?Q?Lr2Gm0LnwO2+hDLP1E3XaIPKoIOyR3etYktOi0Fi0jHI9qHt5u0ug5h/4rfH?=
 =?us-ascii?Q?83c4Qj8nbyCCOKW/o/VoDgvTI/HyedbN5cwqPLJy3uDa9xcbqlLy36tRNsQ3?=
 =?us-ascii?Q?mrTl3XjsRkiEbYvQlL8WLZAVRLcr9V77+8AfRxawt0OgNAR70J2dLW32Xt/x?=
 =?us-ascii?Q?AOK5MRBzlOUSM8O4PKw/gO/mb9gyA+IRNQqLeflfL8p/j+Z8Vt3Z9Jfem6RM?=
 =?us-ascii?Q?3ONxS9v4/MCaHr2BQqevPnlyLrUxe+7RzE6v15Ag/PibQzpI4wI3tCQD6RkG?=
 =?us-ascii?Q?nLR2Gt3BbLAXOrieC1oi+wz/GxCD0djnCaRXrrLTwoFEYEHTPeZ2MDK3kr/B?=
 =?us-ascii?Q?Px2ncRqhsL+tTWET+x8XCyM+tgB7KyDYkYglqXJOkLxK9W1C8zPbBo0ovwPb?=
 =?us-ascii?Q?LZHwO1HuJkDCRjKhUwKObuXF4NSfeqbov9cHRW9nmgej5bHnL7+plrSN9U1h?=
 =?us-ascii?Q?b8T4FRsSbGSpWLCJhOjatnOW39iCpzGVkSQ3N904fYDuVY6nY792ZER9c6h1?=
 =?us-ascii?Q?LPplhtNAFTpBqW/FI4MBL8TOEglawU/nVHUfzQVnJQNoR+OUFTLxOamv9lOS?=
 =?us-ascii?Q?joGZjuQos+hZEfOAv2LkZLSP0kNqs7wsdVnbBS1dKMcSIMxz22991L1T+AaC?=
 =?us-ascii?Q?uY+2WyAwbsG+e9Jl5XZFr/7vjUmwMlcrhcWMSUgm50hkpDxvfdmZ0700eird?=
 =?us-ascii?Q?djMb93jw2+f+FaIOD9zFB9yuamUEd1ojSWs6vviejuWvPzlouwNuRy9R7Srj?=
 =?us-ascii?Q?wukkKYh9FAmtd04Krhr9rLXNYoYvwI0H+i9AmOGYdX22u+DFrzuGuK0M17Ys?=
 =?us-ascii?Q?lyecJ60xp93antcOCmff8xSk/HTUKe1+BzpJcqT1ldsS9eACQFsyP4So8Jl/?=
 =?us-ascii?Q?9w+LXCtUbHyKGt8LA+b4UE/DrWjhXzzRsQ3R+3z+KMJGYYGT0CH5kesBOAt7?=
 =?us-ascii?Q?lRzhCswB3GLvn6V+cI7OuTOx1qSLcxifyoH3avOQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52610bb5-69c8-446f-2f3a-08db147c9c77
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 02:29:23.6457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SjH6jTN2F4munT0uKsoNJSNVN5bynrx9RKG9IKoUZv43dn7QwUnEjyviO4h4c878rJpvnwivA67zF09XbX7Afw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6842
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
> Sent: Wednesday, February 22, 2023 10:23 AM
>=20
> as some vfio_device drivers require a kvm pointer to be set in their
> open_device and kvm pointer is set to VFIO in GROUP_ADD path.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
