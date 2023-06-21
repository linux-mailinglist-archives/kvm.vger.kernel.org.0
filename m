Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B353737BB2
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 09:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjFUGvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 02:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjFUGuz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 02:50:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E68C10FB;
        Tue, 20 Jun 2023 23:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687330155; x=1718866155;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VbElHGGa/FyQ5dLmQzIlAf9wf960p1huk/4Z+iJmSYA=;
  b=UQ+QRY2z3XadsiJ515RNWsds/L3IV2ZfG0xhGrEwUS0TeVgOgoDV0lqS
   hYmQKmr1zVqdi5sE92VYkpmb/Y8Qrrp1hHPtIU4En8vMmxfRoz3Nitod7
   H7maf9hXnPKXGhz0hzdt+baeK+q+8XTsbP/tyZUvJRjvqKIZfxEid/CqV
   kT5CW8iRtqsrXRWBK9s2/h8ngxWyNvBKaTfWcRcesWBAX8RVbTzLzYuGo
   C7ojAYuL3vYR3rJR2b+tGY/qXkT7vMRsIwyNeCCYrY+PwVmYe0x9+DK01
   w4/dTlsGDQCx33c1OGQEKsVDPqPtAtSDxxKfQzC29NSOrKQq3iH0odc+R
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="340429105"
X-IronPort-AV: E=Sophos;i="6.00,259,1681196400"; 
   d="scan'208";a="340429105"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 23:49:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="804249016"
X-IronPort-AV: E=Sophos;i="6.00,259,1681196400"; 
   d="scan'208";a="804249016"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Jun 2023 23:49:14 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 23:49:14 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 20 Jun 2023 23:49:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 20 Jun 2023 23:49:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmQZ9jXjTcUdhYu1vQjSVsip6m9Zrv5vGDVwmz4qp61WWsAHeypYXmySx4SG3VO5NUWrAdmY5CVZ8q3koaI6+YcZUmqrUOf2ez1WEmWhg1iY9Jgef1cK/BvTedjAcOU0ESBvIuiVqwM/r0PtfiYGms0ZLsLVXpsMB3Ca3wTg0mG8zvaGqfWsmrzfkOK5+ChUr5htlRxxvCAWie64Yf66iZW8NEeedFv7gFtVQ0am7Zc1LEPiGqgzv9z3KM7fp2h3bLgyK3Yk4kgs3XSENk/YzeR7Eqk2iAhl7UOWEJbDlf6+eZrwcTVIO6iVSHoqap1Jm0csQxGG8WiKLI819j4ukg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RU3EVTvWPrAZcwZRMmDiSrvWtZ1Qt3BfoETKb8lKci4=;
 b=DXjsOZuiTeTYRF18DM3LaNXBKMZBy9H9SvIm9VqVcfVyX/9saRvKpRk3k8NlnXkJP/ENkhn/vHRp1cwFyGM/TofK0jiRbHY/GJS60yQ/W8kyz1yPoUyFtFroAn/9AxbsNenZNTk1SA+gyuZ7qmOJcb97O+uqrmsIa+sWIRyOnYqGAwXtpxnefXLK9wlOwf0szNj50wAVm37pKtYRP2NMj7V0D7hXDHzprJT4gS0Vs5Kav/HTdi8we1md+SX7jojmZsPAycAGhrPug9PHBSPQJePdGn1zMnl+OYa+/8KtygvEXDLQtvR9S/m02xGdP9l2p3fOMppP8VPfMFhuuiPzQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB6654.namprd11.prod.outlook.com (2603:10b6:806:262::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 21 Jun
 2023 06:49:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6521.023; Wed, 21 Jun 2023
 06:49:12 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
Thread-Topic: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
Thread-Index: AQHZlZ4kU3Fwl99xbECsoSBHo1JwW6+NFosQgAUWbwCAANnr4IAAtAcAgAEnoKA=
Date:   Wed, 21 Jun 2023 06:49:12 +0000
Message-ID: <BN9PR11MB52763F3D4F18DAB867D146458C5DA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-5-brett.creeley@amd.com>
 <BN9PR11MB5276511543775B852AD1C5A88C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZJBONrx5LOgpTr1U@nvidia.com>
 <BN9PR11MB5276DD9E2B791EE2C06046348C5CA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZJGcCF2hBGERGUBZ@nvidia.com>
In-Reply-To: <ZJGcCF2hBGERGUBZ@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB6654:EE_
x-ms-office365-filtering-correlation-id: 8ec9d0dc-4b85-4dc7-79cc-08db72239f87
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U23t3/wG0jcI/77Te0uL4sxW9lpk682ZFeTC1QwU82+EoggVJTjBA4MxOzdq02MFf6xS2CaTHfz06EPuXA78H1rGWYE/Pg0dVHpo1qYTzb0OsCJQrErRhInSTgIeAwiNl26sQAvhh5YKGP4+FlZI9Bf9ozWDlNVST+/CWtM0RpvEfpOi+hx9/7j+dUhwQ9IXbr5YBB1XXGUz4tsAO5jyza1YXs3ieIpUwxK12StWbKtN5U0ZhP6KVRtbkRpjpDdEvORfEf1n8kjBty17fv2QhhKt97tWkmaF5pzX9UtMh5yQtVMOG4NIULLGPR6UDaRiC0ujRo0R9rZNVne3hpfRa4jQSaWZAi88iBiFUWYBN+6sLwEJaoe1+yGysx/+FmHSA2S8bKPQR+m5aR6JTttDTKR57oOg7oHpb/4rpWNvtLrA7OV3qb68bHfH0deOkI/ldQFrsV1+yR6aVDjKlu9Cu5QNTbEhqZJO9XrjgpeDR7uwd8SgqMYApFuWmOA4czKvQhuel7bjxj6Hh3wn5wFXe7o7L1A1Ws6j2QfBKFeds6j9e5ne+bZls486v3DVgAkw4aVzwkPry7YCZLkKPmRbue5oiu5Hqz1tyHJkCkJFc7zOJ103vXWXvtela9L7BXNW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199021)(66899021)(7696005)(38070700005)(478600001)(4326008)(6916009)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(71200400001)(54906003)(316002)(86362001)(6506007)(26005)(55016003)(186003)(38100700002)(82960400001)(9686003)(122000001)(5660300002)(52536014)(2906002)(33656002)(41300700001)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bjKehGGgWW/0z5XDrCYYn+pDhuFzyg4mPkUGBwWKC9Br0pjiMZVcwej2rPKG?=
 =?us-ascii?Q?cOV3lwLzwz2yY4pNbDvl+bUeqgZ7zAzAKJF24urBsLn+JXlKZ2d5VDF/jwqt?=
 =?us-ascii?Q?XWB8WTR1n2mTjRIMU4O2SSBkujJoOhOOfaUfHLb25RCCwQZQGkuCi7bN9dS2?=
 =?us-ascii?Q?F1TPy6obkKEUoKJc8yFbv/aMDTGD5NBDNqQjEQ+pFqUxc7VUEITQlDhxOMU4?=
 =?us-ascii?Q?JvpA407+75eAWt2xcEB/em9kx5Be2j1wZEO9Aw6rYCbeCCu+sNPMHb1bk6jm?=
 =?us-ascii?Q?fU9hqtxVgGGwty9pT+pRb2xCqdWEFdizxhV1VgSLKdAx5z+0qf27lpaxOd4M?=
 =?us-ascii?Q?j0DjLpSBRrDoSgLXHrAt3GPDxougGxAl4AAUcVySryI5d0bgGetvW2ZRYSfR?=
 =?us-ascii?Q?PA2pgWmmFf4LGCYG7hsqqLUQ2zcnVB4SgT3ToMwYovNz0C+BgLxrvGwgV/++?=
 =?us-ascii?Q?drlVhcifyqj/HvXL28aIXdozj+u5lA3vD+EocLXSgsymtd855ReFAYeKQbc6?=
 =?us-ascii?Q?+XFeJuT9U+MJOPLfSf6DRo33WHnBe1JxPdHyIhkzkCG7esRmjyFckFgJjy2k?=
 =?us-ascii?Q?XfqRF8nf2AeQOytXjnDAQTLMHkjDrji0FKGLAbcd2sG986EJJO4Z4P0HedSG?=
 =?us-ascii?Q?2NHAycf631tEHWiAEOkuMdn9wXkyqga3rUZXrBNf5wUUnye1CYcKVoMkoD/v?=
 =?us-ascii?Q?JvyuD2PI9VBL6pLED7urIKXMCxFUXXjU6WLqy5T8VH/onrBN94h96+hi5zgo?=
 =?us-ascii?Q?takB/9nehBFcdHEjW1z1W+iVjDO70O6xj6tbBbKf87KgzKQnHmQLlYcAkV1q?=
 =?us-ascii?Q?s+5ovjBrCuUzHpgiJFSrzEPdxbpejKlz1RruWfmhNqI66nfq3kUvi9wm0iYT?=
 =?us-ascii?Q?pjS15iILllVcuYX714eeDvXLGusvl5cKeNol4I+OoadfyW98EvVTZ0MrNubu?=
 =?us-ascii?Q?f6yhX00VKwrLF8gB6yCXoDeQFcs4m0HyODnFriwtCjNzHDYXtznFPkHACAFp?=
 =?us-ascii?Q?NjjfFbsa0+0+dtcw4xUqyTbevubW62M+WJDAUX2v9F78SRmT1SlxwkNR5Hox?=
 =?us-ascii?Q?BO7RQziHLl8vxhxQfwB6g0N5dd60BDRPEpXugXnnTCG48XXOrhhIN1BjKeR9?=
 =?us-ascii?Q?veECt8B0d1YTtMQJDUIyMzk3putFOEpJZhTNh882+1WsRbqUzf8vP44GmvaY?=
 =?us-ascii?Q?Sd/jdWfrmQYP7gqp4LJ3t5uGiUjF9RCpK5s+tx3p0y3jJ7d+AIDQymQYwG8W?=
 =?us-ascii?Q?bDW1AtiTPqGcNiBe29SsKhtHUcywJ63nuI3LUnqjswvuoSZR3RUjLy8/UskM?=
 =?us-ascii?Q?aDnFAztGR4RodkL8KzLKe+x0sOp5RqhYwIwm0FW3wfkEZTXJmcTfK8kuPMtK?=
 =?us-ascii?Q?j2FVcNQCOm4S3KzxII+le0ENwd0gDIR1uXF+/aafGjkhqUbDqMKoq00X1/KB?=
 =?us-ascii?Q?k8PR79uRRmHoV9DUbzHXCUwZv29bLIWpzhcJ/jmG9xugcj30txZdkerhCVbJ?=
 =?us-ascii?Q?rclXUYGkVCPiG0zk9p5dPpB6rxLOaui0TrGbjkuEmbsD37fn+kICtq4I3y27?=
 =?us-ascii?Q?N4DjbJLegNZl9dwLP6l+yEgZO/fZ5KSWjk9UKSNB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec9d0dc-4b85-4dc7-79cc-08db72239f87
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2023 06:49:12.8824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cfGHjpq7zGLhrTt+ShOAQALh68rc12dTS7WkyrcdXzNZRWiL+miSl4+ggE4fclkv5PMcza/3HfGcGg0R7TyKGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6654
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, June 20, 2023 8:31 PM
>=20
> On Tue, Jun 20, 2023 at 02:02:44AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Monday, June 19, 2023 8:47 PM
> > >
> > > On Fri, Jun 16, 2023 at 08:06:21AM +0000, Tian, Kevin wrote:
> > >
> > > > Ideally the VMM has an estimation how long a VM can be paused based
> on
> > > > SLA, to-be-migrated state size, available network bandwidth, etc. a=
nd
> that
> > > > hint should be passed to the kernel so any state transition which m=
ay
> > > violate
> > > > that expectation can fail quickly to break the migration process an=
d put
> the
> > > > VM back to the running state.
> > > >
> > > > Jason/Shameer, is there similar concern in mlx/hisilicon drivers?
> > >
> > > It is handled through the vfio_device_feature_mig_data_size mechanism=
..
> >
> > that is only for estimation of copied data.
> >
> > IMHO the stop time when the VM is paused includes both the time of
> > stopping the device and the time of migrating the VM state.
> >
> > For a software-emulated device the time of stopping the device is negli=
gible.
> >
> > But certainly for assigned device the worst-case hard-coded 5s timeout =
as
> > done in this patch will kill whatever reasonable 'VM dead time' SLA (us=
ually
> > in milliseconds) which CSPs try to meet purely based on the size of cop=
ied
> > data.
>=20
> There is not alot that can be done here, the stop time cannot be
> predicted in advance on these devices - the system relies on the
> device having a reasonable time window.

What is the criteria for 'reasonable'? How does CSPs judge that such
device can guarantee a *reliable* reasonable window so live migration
can be enabled in the production environment?

I'm afraid that we are hiding a non-deterministic factor in current protoco=
l.

Looking at mlx5 case which has a even larger timeout:

	 [MLX5_TO_CMD_MS] =3D 60000,

>=20
> > Wouldn't a user-specified stop-device timeout be required to at least a=
llow
> > breaking migration early according to the desired SLA?
>=20
> Not really, the device is going to still execute the stop regardless
> of the timeout, and when it does the VM will be broken.
>=20
> With a FW approach like this it is pretty stuck, we need the FW to
> remain in sync as the highest priority.

This makes some sense.

But still I don't think it's a good situation where the user has ZERO
knowledge about the non-negligible time in the stopping path...

>=20
> > > We want new devices to get their architecture right, they need to
> > > support P2P. Didn't we talk about this already and Brett was going to
> > > fix it?
> >
> > Looks it's not fixed since RUNNING_P2P->STOP is a nop in this patch.
>=20
> That could be OK, it needs a comment explaining why it is OK
>=20

Yes, a comment is welcomed. having RUNNING_P2P->STOP as nop
kind of suggest that the device has been fully stopped in RUNNING_P2P
to meet the definition of the STOP state. But then it violates the
definition of RUNNING_P2P.
