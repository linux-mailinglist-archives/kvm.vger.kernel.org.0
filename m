Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925FA652C17
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 05:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbiLUESm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 23:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbiLUESi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 23:18:38 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FC15F8F
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 20:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671596316; x=1703132316;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zYrBAYb2OSlfaY3pEBdignpFXTXOdlKivRMeZYJpWQQ=;
  b=fUxLI8TgMiAGW5/NogKNhfFQkPgoWX2z2w0yveccdiOuMpAOoAqxeJXB
   I8yNOD3bpH+OSNnOUwI9iBHS0j+Unph+lTADP3erkdEWf9XvTI33CP16C
   yn+HTiUyp1AWp86vJlp0DPkJRb0m0M2HvSf9a/1Zm2V+OfBx5XBkHWHeV
   6DlteuL+5AdKjYj7FwYNs4w9bfGT8GvkDLaekY8TjUWxN8y1z2H6sWezG
   JMToWra2BhfMFfBI7S+6UsfP7S55DNvMSCLwdV/55/XnXGB/8UAJmhcHT
   UjlcuoXv6Zs6Effr3hecwIU4bH/Yt4Dn/OIj/EB+1v9nXf6VlvqmEc1Za
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="382008277"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="382008277"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 20:18:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="793561922"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="793561922"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 20 Dec 2022 20:18:35 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 20:18:35 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 20:18:34 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 20:18:34 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 20:18:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PydwTacIk0eC3VD/yMH20vQypOGBqapcNl2jB/hkAr7AVy1cThu4WG1jHBhx6E4ZZXpDJAYoxgDxwP1E+fOLuC2F8Is6JTh0/VzST7jVRe7/Q1aBdOR8XcmEgwFZaXz7dU1gQ3sB4kG8ezeRHdhHSprnzhHZCBVyI/pOAqHUW+Ucfd+jxYuNIirDRscjtkyvHbK9hUJTlqs8fWEsapn6zE6Mg4qchLBfqnKriSGuki7Uba7IAY9f28AhZ3V5yoKi3hOs9B/2Hn4ylpXXVefuV28RiG0bTBDiWpYKGrAJ0dDManBog10HH5LhSGSRwAiLrzoSm9YmzspxjUeL3D7o0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kq3jFfhWxKgUF1Qxq4gCxDY/BrFPCC1sFvQBSPX67UI=;
 b=YNNWKHVcDtByXuECm0nABRCDflEaXIN3ZBaniC7e9F9mnvREWL00oSBAHvSEegYUWSy7+7zSuV4BbPr8Q1CzQktU3CkdQ4ZINA8cBTh5BOoZ0XQftKGnFLKRcLYBz0hem8eJ39LBSDDR5Rq5VyxdaDqN+RsG5j07Jgl/qHIUfRaGP7WKdGzeArW1oXYlxuKi0YYmsIPoM1CfFJJOLFmZD/+yqqQELb5F1T7/Sj2J3LnkaBdszXtCalkgi8+ZCh+EDwv90pnKnbWbXAN7CVHfA+Z9EhiMbLuJ/oYdmV+UifvXLrtjjNcaz/zxWoNWaoRQr6kxgwn0xJwvUYcZ0ohd2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB6714.namprd11.prod.outlook.com (2603:10b6:303:20f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 04:18:32 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809%4]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 04:18:32 +0000
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
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [RFC 07/12] vfio: Block device access via device fd until device
 is opened
Thread-Topic: [RFC 07/12] vfio: Block device access via device fd until device
 is opened
Thread-Index: AQHZE4aVmVdiL0Mus0yGnn3rlFwubq53tr/A
Date:   Wed, 21 Dec 2022 04:18:32 +0000
Message-ID: <BN9PR11MB52760551B1E8E5B0BC44860F8CEB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-8-yi.l.liu@intel.com>
In-Reply-To: <20221219084718.9342-8-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB6714:EE_
x-ms-office365-filtering-correlation-id: 7717e192-082d-4842-69b6-08dae30a6bd4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: prf4ML8f3WeGjGI8SFhin/jKzwgO/j/sco7Q9w76Bs/F9d0jyw/nXYln3UpMumABeSz80/toLpR4joar9qayUI4VOD3FCTXHpZhKKguDtjMeCDRWrjcjqce3iy0KFuIYng9Us/9it7bm627/QJ2+VLeD/T+BasJ1sgOFgooN/jklFBbkwqq6ep/d4VZOFpAOvFvcdyEHDkUPIajqOLt37L/xb2MP2R9cjg9rTPb7+x5UifipuCzf5+5WzbAyi63mxM8ql4chcBj1ZT3iX9BK4y/mEkxPYqNeQMJSiXjYg6g51TzRUT58NIkvSlFWOsW/fbrv4x5mK9Xy1qMJToxKDqGOPKBLgM6W9CC6o7afeVhA5hfq5onagVkbd40y8cLQTt/eYVz2HXEzHFvx18a2QZtNF1rCJf4CjKUxB9x/MsNq5wZa+g3cVnIREOzERqM0I/9BBQOYm/6PWXD3Lc6gBF5+cihyYd3A3vpl4o+DuI/o4QoQVFsCNCnDm7b3NsUiyGFThLFt4fNBoZPVO9bUkcfN73uSgbmzGGE+u3swqQitxA8t8v3M1ZxR/Dqi+ehEn6fizL1K6LfFnUJowXAQVQPbaa13NIFi0IpU74m0wpN4WDlKqCd5ENTPDlnO73Wmf5LRVYwkHUltwxSb7UxiMVveF/Ks64aia916mQ7fPp+tCACT55uYY8G0MvBCdlOUychHzK4xi11j/xuCdav0sg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(136003)(396003)(376002)(39860400002)(451199015)(7416002)(9686003)(186003)(33656002)(110136005)(64756008)(66446008)(66476007)(8676002)(66556008)(71200400001)(76116006)(66946007)(4326008)(5660300002)(38100700002)(8936002)(82960400001)(54906003)(122000001)(52536014)(7696005)(6506007)(26005)(86362001)(38070700005)(316002)(83380400001)(55016003)(2906002)(41300700001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hLUnIQ0tbmOpoOR+JezcTzxAxQ0dWHpkIEiFNRq7exnMFE13XlvSZJNF9/iU?=
 =?us-ascii?Q?ThsRoWOEaZJz70Lu95HtWioKUpRZyY2BUQRP9IHwb/xDdY9nEqMOVW1Qfw0Q?=
 =?us-ascii?Q?1qefozkivIGTizAcRNQ37Agk5qfifg+mFeyOyJl+vFi/wA50l2XcmQzf6b1N?=
 =?us-ascii?Q?foDXt8usQAlO3xy3KSaBTJequzlUxGTufPKrbW8SWkhIx1UI+qk3csIuSbm3?=
 =?us-ascii?Q?sjvFnfUXcf04+lUIyL2EImvWOzXvaaYigyjxS33F6kNHO1fszIx5SapKOUxH?=
 =?us-ascii?Q?EqCbQLJtlPmDxo6idEL5QE8IabDKjzYXpV4BFI0mm1tBRTu8WH0PTZ5neEC4?=
 =?us-ascii?Q?l84DTabD7QUf3WjG0Bmt8UmKEupU3yN4p9xriPXgSap0tIatLicXZVC9yt5o?=
 =?us-ascii?Q?zv6hdKh/WtOUS6wnZQzy/jCAWj5mY8X6yfxzgWzGflcuEb759JpRLblwYpky?=
 =?us-ascii?Q?qabfmpin4hfPAtQhXXlTu8vmY26v7/APPSKfjDqMNPWhJguvP59DZFzwlIl/?=
 =?us-ascii?Q?AYI3A+XLvoj6/mLvBSENUkq7J6NUUYyihQeg8NgeyJSBkG4btZdUl/3xIY3S?=
 =?us-ascii?Q?nJGnp7boMeAN7N6pzT6NWP6rGBy2jWtxLTNo78ePNCnSM4SH2Gij90TC/ozI?=
 =?us-ascii?Q?NDbOxMtTQyCKnp2OQbAm8LiW7DNAH0NUH+w6INp/cIYf/0dwki0OITMl6H9t?=
 =?us-ascii?Q?OUWLFwbAxcRqJqSnfeXU43nD6X6GlEXSyC3JlIwerMZ6Vm+w639rZNU6n2mw?=
 =?us-ascii?Q?6RQ3JtNwvPEiLUfJ5wCDAwAfGLwrkWp59YSwL62B7gpk9+BIj6fg9JyofOW0?=
 =?us-ascii?Q?HYbTxNCA6GG4Z27WKXP7OsFc9p3HeMw9o73CaHvAmXPgABkTX9aLuDqXSB4Y?=
 =?us-ascii?Q?7RQb0u2ix8QMvipu6P0Vc7VToSP9S5VlyaHHLCf9vi7GaU/IfS6sthVgYG35?=
 =?us-ascii?Q?zx/DvIbuQw3apci01STCatDBFIc1YFf77mD8NqwFhJzTtxKkGHNyIZI7EDAF?=
 =?us-ascii?Q?RHDD5I3hK9PaZ6I/BvPtXCPtSEimvbnpMqj7pGmgTqDEVwTvuzLzB1Bwazox?=
 =?us-ascii?Q?4zfE21YmqP4SZnruedsYFSRbm6gp+BQ6tSiQxkqwyxX3nUIW762Jxb+DXKTi?=
 =?us-ascii?Q?urlQNwPGiYpGNwT043QS4FioFdrHKx8dtFjMx/b6wE2iNf81wlUfkzU7QxUc?=
 =?us-ascii?Q?QpBmAkNU+IUv+OSULk1TyT3X/MP5GGsLq7NPrwXp4RAMmGrGIMYb3aP2Ywz1?=
 =?us-ascii?Q?Fs3XMLID19We0VWjNK7Hpr1BijROd0+N6sqcDRhOpJCOOJho0dOcwLUS4ye3?=
 =?us-ascii?Q?Keo1PCQIIsyxjpuhjF1ZY2avMQjDOxlLiLaAxzh07nM/eo9rx4XU76i23ygu?=
 =?us-ascii?Q?ySPtCfQm3oK1hm7YywnB7no9Hsd5/vskfpv4cCgvfhSeXNcKeQtPY3pfWMua?=
 =?us-ascii?Q?puzu7oLIy6G6AH/s3P1gu/4x6ZK/0ao5HyNchLWBQxXuvxlUqCH9tWG2XUju?=
 =?us-ascii?Q?DbBHyQQs1dNagzCW0b7CEJB0adNh3FCMa+rr4301uz79r5ZQap4FnRT8FHjL?=
 =?us-ascii?Q?w6Y1SJOKtRN4s+Q9uUpILDW2z38Mt2Pcc1sozoBA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7717e192-082d-4842-69b6-08dae30a6bd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2022 04:18:32.3982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3+x9lt4MjmYW2o+26wM/hZ8QhUkoex2hy4yhxcqWovDPdjNH/m2rA+DpKbYd6MyrtLdOoUCT6L4djJnGada7wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6714
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
> Sent: Monday, December 19, 2022 4:47 PM
>=20
> Allow the vfio_device file to be in a state where the device FD is
> opened but the device is not opened. This inbetween state is not used

'but the device cannot be used by userspace (i.e. its .open_device()
hasn't been called)"

> when the device FD is spawned from the group FD, however when we create
> the device FD directly by opening a cdev it will be opened in the
> blocked state.
>=20
> In the blocked state, currently only the bind operation is allowed,
> other device accesses are not allowed. Completing bind will allow user
> to further access the device.
>=20
> This is implemented by adding a flag in struct vfio_device_file to mark
> the blocked state and using a simple smp_load_acquire() to obtain the
> flag value and serialize all the device setup with the thread accessing
> this device.
>=20
> Due to this scheme it is not possible to unbind the FD, once it bound it
> remains bound until the FD is closed.

Could you elaborate why it's impossible to unbind the fd with this scheme?

>=20
> +	/* Paired with smp_store_release() in vfio_device_open/close() */
> +	access =3D smp_load_acquire(&df->access_granted);
> +	if (!access)
> +		return -EINVAL;
> +

-EPERM?
