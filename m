Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C31368CD8E
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 04:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjBGDmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 22:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBGDmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 22:42:31 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B4E196BA;
        Mon,  6 Feb 2023 19:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675741350; x=1707277350;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C51cNhFM8APgQWXFpcibr15npHEMgAvITriHq2dX8hk=;
  b=NUIhToec1gEVYpYtLcl2dYNYqtA236wg1ba3cm8zWoGJ3NqN6/+KsahR
   EFBEqc6HhgALA3fVM/OSUcg7qzM+HVubq9yZGlsse0JGtkDVmjf6T6udK
   f5tvqXE86w+cfWNe0+kZ1YC8xOPS/Wp2nXj0EkehBBm7UeNO+2hHe5LIR
   btINaxJHrSP5Alz9B38ZtTeGpk7TqK6m26AJpxFlM23r0hx17CsQO3mkO
   uLywsuzxIdqs8lvHUmtYlT9NoCNKndc7g8OmiMQup88KL4fibZu0i6Hd+
   3UOU5Iv+/fsGrrvME3dA2Q0Oec8IFIysa7eohGKx27Rppqlk/gfya5v/k
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="391790596"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="391790596"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 19:42:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="840617042"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="840617042"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 06 Feb 2023 19:42:29 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 19:42:29 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 19:42:29 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 19:42:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NpIXzd9JyXWRg0w9YnFPAg4LmSRT5DiPg5Ws490Wy5f39E0Dxa7u7IulTay2zt+3DLqylTgAfRmISylZj7vQ25k533sdV75lec4/sOI1YFtxEDDSodI5eB8bot5lol64VpFUqShu2K0Wh1UvZ4Prux9mkPmpg+oHU0y6tRpDzmj6sXyEFeBb49trJTUXs+hasoD+/kKwTKuvZ5Y8hN3FPq0rCxpZ9oQLeLO/ygc6A6uzyCfRHp9yxJ4VWuBHdNkF2LxBvzX21fZW/D0G6wAs9WHDpYzzDKv+m61xLprKq6LrnrRlGbn8M1F6YR5y1gveSVeRdUAIze167MNjRKdLfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C51cNhFM8APgQWXFpcibr15npHEMgAvITriHq2dX8hk=;
 b=BoqWfYjulgNGJIm8hZgz/htpnrEnvDOPdgsWb85tZVe5WsSmGCPFMfnM9t7hVxlLlfTNC7q0NUG6XsGI6rrVFEho2HxAtnJ8+0fRRbtPNZH13PagLKlcr3cXr47Abt93tWbv3jfXadNA+pA60gAd8wdh06ntXbPba4DcEqlV88RhlAUrKdDdpKmXq9UG8jda+10btYofjRaIuDwwUE2XsKivUy5bKZws97aqenvG+5tzw6g+FGj7oyt1tSkpodqnkDDUAFAA6My6dTEd7RgJWskbBq39nD175KFdsj5EC5ZwsTAFGs40UUrCCagmiycOUExHXnWESMxyDRsdnO/psg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB4882.namprd11.prod.outlook.com (2603:10b6:303:97::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Tue, 7 Feb
 2023 03:42:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 03:42:21 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v2 06/14] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Thread-Topic: [PATCH v2 06/14] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Thread-Index: AQHZOgo4o8ZzqD0PI0OiLCLh0tA5Pq7C2DBA
Date:   Tue, 7 Feb 2023 03:42:21 +0000
Message-ID: <BN9PR11MB52762973F6BE8611D87574F18CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230206090532.95598-1-yi.l.liu@intel.com>
 <20230206090532.95598-7-yi.l.liu@intel.com>
In-Reply-To: <20230206090532.95598-7-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB4882:EE_
x-ms-office365-filtering-correlation-id: fad18905-d92d-4ae4-66da-08db08bd519d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F371/vCvJs/7CDsFXxI4Pp/tafPpuAKJOatgbcy7GN+2IlFmSSgOiFR2H/Ubc0a2zQGsZXuQ+YTcA8BgYHsVORHcjFJcnbuYFTI1+tRXZ50AH+0X8NLM3E8V+xp/Nbo5ESiPnDhfTkyxGn91kpL54gG2jhE3bKhR0Vk9lGZx/wJxNvAFPVxW1iQmFThN3+tO4pQ3ui5R5WO5L4/N2LiOFxoYKXufVpBp8+S6yGzTAk2L4FrIMeS8hBJ/DuJUiKLKaiYUqlHmKrFe2hWlo84XOpnk5TKqVGOoCqS/vzAxzD29kcBNkhrUaV3hqm207Zm496Ko39HzBVRy96wC9PMsTwVNc9jNsB0ZXKNy7d6/txDUIahOBHpLaBa2OrIAb4rp2wAqFKImhhdirqJLsNL9b/Mc6GispLNzv80x7nt2e0wNjfzlvkRrqlnzF1MLgY9Lot1MsHvIXNmxfad8gFXnVxRHPjaBYSwJR4SPrkSWtymcUh4polM6oKXqkpoJWsJhKSQaKWO+Xq5X1hr028RuxFgpwOan9XNTNz4zK+dhtaL5cuxJ2HoZWeaO9VpuduwwFvOPLzFD2QgNcPVWQ+tn87YDLJD5t8mea6nqkBGu+TOnb22t1EuoW3soQ5fGsBrhW/FB1neGsqhgh3nPBWVYgFp7cQKqGbOMLpt9qxoRwrj5d7lR3wWwO37B+g15P+O/u9etrKYsqjfiIaa1O5jwfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199018)(55016003)(4326008)(76116006)(66446008)(66476007)(38100700002)(66946007)(64756008)(316002)(9686003)(110136005)(26005)(54906003)(66556008)(186003)(82960400001)(122000001)(8676002)(478600001)(7696005)(71200400001)(6506007)(33656002)(558084003)(52536014)(5660300002)(7416002)(8936002)(86362001)(41300700001)(38070700005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qpr9m5z6Dv7sQ/WbSzpAnbiHtvRm1DYMi34YXSHw57LHnBCnBfdJoOZRUxNR?=
 =?us-ascii?Q?3DZ1naPPmMucNx5L1/Fo0clISYPTeGhNJrMBSI+CVRVDWfOnV68J+YpZEklZ?=
 =?us-ascii?Q?W598xH3BrWRxdkhIl54wCEF+MwAZ1Ab7E651REnwP8sp1DJcz1Lg3zCfrigt?=
 =?us-ascii?Q?7/4HLh1YBNJ++r0xrQtLC0FAvv8Mm+MVrdH6toZJbOKqQx7N6jl9OXxwHcvz?=
 =?us-ascii?Q?rQWYl3IG+mhXK8dFmAqyUWZ1riFgn/Y3RIsP8IeMnrih7DgGmFmY9Nt3j/7c?=
 =?us-ascii?Q?tUi+w47/+DtpcWupEjBC7lsKoBW/QrAD+N1HpHsR2YS3HuKlDO4x1X3GR6Lu?=
 =?us-ascii?Q?RNp6vSVxQpXPrclX2SrW1PDohgA03pA3L5OjIm+VxsKWFHKJVdiSM2sNcZZJ?=
 =?us-ascii?Q?fTi1+02sKJSDarW+uHjZw00NRR2pJmPY5DXl42kfH3Nu9wgL4dXDRgp6Blfs?=
 =?us-ascii?Q?3EacOT27c/BAqQ/U5T55OO24S4B1h+Kw6cXc5Dd/PHPRWU+63lrTx45/lIbh?=
 =?us-ascii?Q?xbmA7YlWojqtCTwhSp06NwFmwlHi4yqL+AmyNdfq5bvrhltIjW/3TnrlVwoV?=
 =?us-ascii?Q?B0JkNSY7V10Z5Mpty2FCsSAaal/T6Bcq6LisyBcOtWLNam+3xe/Bsaeao8qf?=
 =?us-ascii?Q?PYpAhJE1ORr4QRdNGq6ziWSFgzKMxlXOKQBGngeUpGdxKkxz+RjWzLd7UhV8?=
 =?us-ascii?Q?5Ckb+U4cYm+uJPqTgtdysSPvv6z8C3/Q9O9pU9jayHlRmWq3t0afj/AWZ7jB?=
 =?us-ascii?Q?2Gibh/M3fNgtKZrZYAopjFEGzfdqWEAUjptgiyhPf25qUspB6+HPfYtFni/n?=
 =?us-ascii?Q?Yz3DlmQ22h/4c22VcnHUIE7CCFClQBOsLz7oIlt5qQxpFz4hoQyDfMjpRC6p?=
 =?us-ascii?Q?/TFRkcyyKfhWqLDTFnM7/7lzmwpBO5HxFKNxq8JSrRTyXwT/xz9vEHQvyl+w?=
 =?us-ascii?Q?rVW4TUmtydV/hVHUxlzyxV7nVAP7Su+LmzGzUSzSA5IVGIX+K+YfEz8bdSBA?=
 =?us-ascii?Q?Tlp8L5vFa87zOFpm2+8nCD2bfo5ZTDNioryGonbhv+P7RGF4wrWXu+e71y1h?=
 =?us-ascii?Q?GgcYUqejUEsCDrX/NHo07gFn3MEub3JkMhGCEVf6CPsW4vURB3uRILxydkl0?=
 =?us-ascii?Q?LLwL4F69PwDBdw0RkaoeMRYkdGwNcElIBO8PBJhRroEWtK8U6aDVAIZTgLAS?=
 =?us-ascii?Q?otDDiEBmntclsHcrn34/fD+ofms7aKKe2eiBI/PSQDc7JFR+Gu3WLmlFwxAL?=
 =?us-ascii?Q?LnSnAKubG9fnRAaLUuLg/GA+yCEXwATv6u/i1t/OtIOVTvcysQIV3AHcJfXd?=
 =?us-ascii?Q?xJOou2fz584EH/tYukUtaSGgmhawIz9rJmm+pEtfDeeusOTdkjSkoQF4f595?=
 =?us-ascii?Q?mSu7kH4n6xd84TCqIGzzWkSOwjtz8iJEw3hoCfST8T7d/H8PLieju6rd0BTW?=
 =?us-ascii?Q?TvLcSRXYR8PVGW80dqw3TIxskXklEJc2AfSnAZpnsPOOyCAqdgFVVZi7rolN?=
 =?us-ascii?Q?RYDhvSjG1v1tJT/p8bdkHvYZGKAMFqxvLb/jYBR2nlo3MGOKz73xs7qSYfns?=
 =?us-ascii?Q?et2khtaGW5oJwqX3P+m5F7p4eUzUNKWFHtj8M5xT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fad18905-d92d-4ae4-66da-08db08bd519d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 03:42:21.3855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N6ifNmXjjN6nPMQeL52Ubdg9pcIuuFxrftIVgbhIStJEkIwsoGyQHWxW/i8Hv76clLNpTEMast3tCmbpBOmRlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4882
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
> Sent: Monday, February 6, 2023 5:05 PM
>=20
> This avoids passing too much parameters in multiple functions.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
