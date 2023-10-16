Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7614E7CA189
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 10:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjJPI1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 04:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjJPI1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 04:27:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E936A2;
        Mon, 16 Oct 2023 01:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697444819; x=1728980819;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O/Inn5hgloMMCd7bda+tRZs2e9LmUeezCmuL607OZz8=;
  b=Rxi6DY+5XjhyvyM4tBj+RoLg/pq4kRQu1FWRY6B0Felg+ZI3IdI5Ocf2
   6f5Qcqs9GICFUy1MLNDCQw+DpCwHgParb7sZJrhjk9kN96iybL8gluzOL
   txbEMlJOcYcz4nhM0/O/G1XBAyFKzgXkXjdER1PuhdOaV7uMa2VOp+flo
   i7DobmHQjqdYd4+ZiIq+aLiF9GDuFGA8aBsjM+atXRNdStLLWoq660qwD
   8/JHLaCNY8jyQMumET06BGw+eg31WcnaOOsJk3nI2UjZ/YyGfncbZO74T
   0+NNBzAvfMMtHt3wPyOE/B0SbB8uZ3c/ZhV3hAEx+xft9Np9E080POEqh
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="389336319"
X-IronPort-AV: E=Sophos;i="6.03,228,1694761200"; 
   d="scan'208";a="389336319"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 01:26:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="755608776"
X-IronPort-AV: E=Sophos;i="6.03,228,1694761200"; 
   d="scan'208";a="755608776"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Oct 2023 01:26:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 16 Oct 2023 01:26:56 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 16 Oct 2023 01:26:56 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 16 Oct 2023 01:26:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNY4RVY+qxIVweqKdGifAqJCDJjNGfkQ31SLx8MdbTkik0t9hvjdwQMz5wxGtessu5S2RBxm+3QhDPSg051f6ClA7GKnKh0XfYU0o7VnERIhmpk6RkMLgcpgcsWrRjylfu2cs9J8Je+xH+2JhoUDQ5kdhMz7sd7HBtFpqT1lgN4PmG8yV4D7h6qWXjrBX10HwI4GakjIOPIF3rMRVkHy2Bg0krEB7BFEcKmx2hzWDQFkvsMa5/m8Pi1mBsTR+dzXQcxpVOrdBymtXz0pdXaO1Xu537HJfsSLmD1PxzKZ5xHQeRtkPPhjche3qk0UaWbUa03c+5IeHvx1G0gxOu0jSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eAX82LDZ09I5w+snW06KDXqCGKvELuEApTAt/1mpb2c=;
 b=eQLL9xEi81QrkNSUBgIOxJxDv8cc83J7V5mQgQA+vX5tlOUmwvbQ86KCgTBn/rS0/cnZFoWEUGIHI3WfQgQvgc0bu4zBO2jAy1Xl+1CMgis2BxL+TSp0ZoUlz3/JZ5WpA7ZDxWqzNZynr3K1s4zLPjrXJhOh0Vr1zuiS6AnGpRrBpqUqARh/9hxlUw9mE5LB/Xu9YPvCa5DpW59mgfb3ua5H+6/ui6WfgLZFC3P006wWTCFxu/19OTRcUg/Tk2gAw4MVjobWUBF56ucg9hvd5u01oATBtkASrZrdZNe0+qlbtUVAxu65j07TR153bAy6EgTdMxBK3RM/0sx0kUNrNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB8207.namprd11.prod.outlook.com (2603:10b6:8:164::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 08:26:54 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 08:26:54 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Cao, Yahui" <yahui.cao@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Liu, Lingyu" <lingyu.liu@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "brett.creeley@amd.com" <brett.creeley@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH iwl-next v3 13/13] vfio/ice: Implement vfio_pci driver for
 E800 devices
Thread-Topic: [PATCH iwl-next v3 13/13] vfio/ice: Implement vfio_pci driver
 for E800 devices
Thread-Index: AQHZ6flqZD1UOTQKXU63YTaA4XkWubBHjNTwgABcfgCABFeu8A==
Date:   Mon, 16 Oct 2023 08:26:54 +0000
Message-ID: <BN9PR11MB52762B6019CFA0496B0272FF8CD7A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230918062546.40419-1-yahui.cao@intel.com>
 <20230918062546.40419-14-yahui.cao@intel.com>
 <BN9PR11MB52763EABE64389B5FBBBFFC68CD2A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231013140744.GT3952@nvidia.com>
In-Reply-To: <20231013140744.GT3952@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB8207:EE_
x-ms-office365-filtering-correlation-id: 78a928af-3fe3-40da-cf45-08dbce21a77f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I0A2MgvSUZsW3p8jLG8K623pF1yO/7Qaw0zsJI1mP78R2VOQiaGl/i7gAT7sNJBvA6SQQTRXL9qzk6WgMTZYJy9PTMgJFGBVlGLyrTEsDUcQOBnnlv8LKrkUCzxzyISPcSii2ICcuWstzD9IpXnwwUOCLLGD8L/+FZbpQUXVYKPzo/FtBkTY6HXoJf7cRS27M598Vou14DUo5NJRcxLtcpiinmj1r55uB9Ui8AHvV0T0kVxwzAv0HLFtartEKpFsbmHP57zRAR9jNPz6SLtFSfMpUdqnQ2mJI2TGn38LzggurVnNu9MuH2u0hRY0hAlvCHa+mcUIRNGN+UIgqjTpEJxFRLx71vQc3KeQv6i0YrPVmYdNuioHmENvK3DfllFX4RiZlYy/5nvxYzfPh26swMv2QJQ6CBSuUXxzqvqYWSsmHcBFnmKMy70nz7m9i56vnJ90+ncjZdDwT2Ik7rPnYzc9hiC6iwWNyBl/ws8Ga2WVaO2rF+Yroeo042J8S7E0GJWQKEfiXhzX2mzrUaGnpsG36d6TRNMPHv5z+kBiDcGTPe3cT7/jCnLzql7hyqeWZynXNaquMFEPlbE6ZMM/oIgQNkbId2Cf2eYbg4bFOWcPIYPGrc3e4MTjQQJrS9XI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(346002)(39860400002)(396003)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(55016003)(478600001)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(54906003)(6916009)(71200400001)(83380400001)(86362001)(38100700002)(82960400001)(316002)(9686003)(26005)(107886003)(7696005)(6506007)(41300700001)(33656002)(5660300002)(38070700005)(122000001)(8936002)(8676002)(4326008)(52536014)(7416002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9+OWndBjG+OjlJSkltk+EEonoADwHDEFvbx0+geYwRSmdnjRM3+xlaXAAt4l?=
 =?us-ascii?Q?1+zBH43blL59QgYtpF8CMCEpCssYnOxvN1JZKb8WP4JPouBLh+axhC1NqOy5?=
 =?us-ascii?Q?celJstdVxYthNFAqSEIQu4CZqA7RXLPX/z/+9dLMooLHvvmHGwtFS+NNBmSG?=
 =?us-ascii?Q?MMtdRnlOYimvk5NgeHvNsj48iz+5zPknhhBjO+Kwlf+qsksTjj8jGhMCv3vM?=
 =?us-ascii?Q?Vzb1qji23bBCZjH9Dc0pQaWQCkU3jnWOF1f2/pMHoq2512qeFQhcRdhXCOvg?=
 =?us-ascii?Q?XP/L6ktj+NkPKY56OMJvzUvgtDc30khP4atxdY7nT1GvP4g+zkmq33pFmJmt?=
 =?us-ascii?Q?XKga+80WC/9h68n8vfK2TdNNGYwhcn7dOOFAkxuMQwO90aCbMxF0Dz2fTl0Q?=
 =?us-ascii?Q?woLfXvZ+9GOTtBt9ETtuapJAuIgMoYnm+yotZfG2qa1fyhDXWsbl1HuDq3zB?=
 =?us-ascii?Q?A17XjdMs2c4np/SP5zGfQr7ts5xQ32xpKGy05ks+l10apO8614J7Vxc8fHHQ?=
 =?us-ascii?Q?n9uZ6Hq5KalFn7hAcSEDSAk1uPh2GcuEflbNIBhG3kDCfUR9hBfy6/9j3giO?=
 =?us-ascii?Q?RV1eb/RVpbq4DwmrvEEcTjYVWIs9hJAcbHqi8E4Low10VrcLPU8yvH4rgde1?=
 =?us-ascii?Q?uunY1tSjUZ/gRHSA9WBGp1mU7gqWEDTuh8jUIGpeIYxX4/Nc9/In2MR8EODW?=
 =?us-ascii?Q?MSxdaMMT8cagiunqq+OxMnE6aWpRcJGXwZ9GO+ZvZHogYcXw4MBQG+8/qr/M?=
 =?us-ascii?Q?71Y1LZgt5ZcACbjWqrrHqGyAf4Gt1YpY0GsCdLNT0YoGsfwTJwgLvoPpAWcY?=
 =?us-ascii?Q?dfSdYE+107xPiFVfjSafOvrF1zZYdnL5R2RfjUL3QKAv5j8TV3wrYsbrpzeA?=
 =?us-ascii?Q?NfspTYzVX7izIeISeIIs1sHHH9q5efwNYR86Bp4FlqM7EtLSpw/gkRHSqnVG?=
 =?us-ascii?Q?XoXqAPraZt10M0uhhdBOjOZAjX5bqXPe6UPEOXQqrL4RSkMoCM6Sxn0ImS7+?=
 =?us-ascii?Q?WfWLgLNocDTH9WlxKzxPKHRUwxgJJbh0E8wDpbJheoVAAlZXl1w2wHDtcN+W?=
 =?us-ascii?Q?v3OlyfwIA3X6LId5NJySIee+nuiCdE4OmISBySDMRbx5pVi9uP0jTCr5qc8v?=
 =?us-ascii?Q?udStOT3Sh/pS+A7zixJ/x7wC+AWPOO9vVu95+dER5dk/7ZMLLNP4JvpGwoU7?=
 =?us-ascii?Q?1LySLY9UvknIiEKqGTC6JMumAQZHBBtIY1NmSZ54VfSX65SgD/vBRojbbPuw?=
 =?us-ascii?Q?UodtA7QBt2+4TBsJH0oHn08pBTRc6cjaaFa5uIykJe5hbefAzX/A1IU7/WGd?=
 =?us-ascii?Q?5rwIjEoJfC5vl/s3pJ35MYDwtu/Ue8aRrW6rlld4shl0ZAm1chSWoOcLiryH?=
 =?us-ascii?Q?K7hoJs0K6GGqBlZJA6/yunM5tkNE2tDXjKS9dVYquWZIf3EQv4z8z+CXvtUC?=
 =?us-ascii?Q?jM+IO2yUiynZL3NgS+mGLHM1rFo3Vi0cMgR3ZWzd9ltvp+EFnkdngCjnD/vb?=
 =?us-ascii?Q?iqbgRblOfP65eC/hZDAgcnKBQy7S61hZ17kWVMZvmw0gY0p3GZfAov0h3UNz?=
 =?us-ascii?Q?+T6yCxRIGCVKR/yO8H5Ciqq66Tu34uApoGb3YYkA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78a928af-3fe3-40da-cf45-08dbce21a77f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2023 08:26:54.2415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yZu31L0f0h7UKjdaenmQ0ObmwfRoRSN7AJVNTknURr3GbBvjbUuI84ZMGl5NcNjS+ufp4aPUA7Dx98dS4z7Clg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8207
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, October 13, 2023 10:08 PM
>=20
> On Fri, Oct 13, 2023 at 08:52:07AM +0000, Tian, Kevin wrote:
> > > From: Cao, Yahui <yahui.cao@intel.com>
> > > Sent: Monday, September 18, 2023 2:26 PM
> > >
> > > +static struct file *
> > > +ice_vfio_pci_step_device_state_locked(struct ice_vfio_pci_core_devic=
e
> > > *ice_vdev,
> > > +				      u32 new, u32 final)
> > > +{
> > > +	u32 cur =3D ice_vdev->mig_state;
> > > +	int ret;
> > > +
> > > +	if (cur =3D=3D VFIO_DEVICE_STATE_RUNNING && new =3D=3D
> > > VFIO_DEVICE_STATE_RUNNING_P2P) {
> > > +		ice_migration_suspend_dev(ice_vdev->pf, ice_vdev->vf_id);
> > > +		return NULL;
> > > +	}
> > > +
> > > +	if (cur =3D=3D VFIO_DEVICE_STATE_RUNNING_P2P && new =3D=3D
> > > VFIO_DEVICE_STATE_STOP)
> > > +		return NULL;
> > > +
> >
> > Jason, above is one open which your clarification is appreciated.
> >
> > From my talk with Yahui this device can drain/stop outgoing
> > traffic but has no interface to stop incoming request.
>=20
> > is it OK to do nothing for RUNNING_P2P->STOP transition like above?
>=20
> Yes.
>=20
> The purpose of RUNNING_P2P->STOP is to allow the device to do anything
> it may need to stop internal autonomous operations prior to doing a
> get_state. If the device does not have such a concept then a NOP is
> fine.
>=20

Thanks. this is clear then.
