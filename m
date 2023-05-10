Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849AD6FD3C2
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 04:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjEJCQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 22:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjEJCQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 22:16:09 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A1840C0;
        Tue,  9 May 2023 19:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683684967; x=1715220967;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=42JgTNOhypZQRElqjXkqnc1Mwj1YnwWlr66aclFoA0Q=;
  b=Csup8aOm4vvAQMHslNSqyh8N6JHDuUPXMEAh9pjwzUf0wKrRebpj3ItJ
   7CrbV7eyIcfry9nKSWNzJ0e3ubqdkyzKaDcSXUjXbhoPtINva3gB/8TzO
   VvZeZNW3TuQQMbGrMRtnjXNqIRk7Ky52wXhnsU7b2dMJBZ6QD7ewg147D
   2n9jkTcKpZxU14gwdHHcbfg707z+xcuI28wGi/BPu883t6O1wvEoz78jj
   Ax7puwiCkSZ2DoTYHVxFJ1GHMVIS5nPVY1HRAJePIZtDCYCi5LXbw78Zs
   +PiuyDaN1KecRNRAwmGD1z+TsE+EIkU41dXAq1nQLHchlN8s7ozbaT3c4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="353174581"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="353174581"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 19:16:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="843343898"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="843343898"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 09 May 2023 19:16:07 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 19:16:07 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 19:16:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 19:16:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HIbZ2Vy7/eNknKbdmNfBSzji49/Ie32BlGoy1ZXzJOJFdelx2UTThMHecHFEzaPVuTIxoI0mPDOXRQlFxbCpOmCPl52dIQpdCtsZloa21SbAxPXrz/aWDBpoUL2zEMyg89s5s6dm5V/7FP/OfgEXHViCh4IRgN73h77RVp1Bxgcmd0dmWOnaa51R1rAF2QEYrMvVdpIwGwwa0yxSaxmPVJJSi6dDc92bU1EZRQ66U3DBSPGdOmSB5vAmB2WyI/bbvqP6fFWEpfKQRdjtShbwC4bNVkYE5Up3YEUhIYM7klaEAF5+CyVi+eJxWam1toTtS1QyQEEItsrQ2cNOWDgnOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=faOYcvgAbN4XLfDGa64n7YksmUHACT2+fwNv4MhoWJI=;
 b=kd7Ca7pqPJhy3mRl8LIKlx1gG82JouPNLyJ6ay3SplNjGmyykVXvJlp/4va2mHyIpr02HxMcuFUQuk5+aU6lWcJ1p0lDv3CJ3lrjKKljUOHS82i7l2JORM7W7Dk/f1ncXz2kYsw7ac8dnZmvXOoSq4h7Zc2G4tfzIKlYZseV5Ai08wEOVQdQxQw8m9j+worzcmuRMJB0okX1o8QMnY96GKjdk+NdGVFkUWKSodFp4A17uISdItZrk6BGcQAX/xPwjUDkYYdLqH9Fz2QAV+715CmUBzxexSp64vhfxJFdGHR2FcY2uaffU7TkuuNGIRzWObDX2DpH6nrr39J2IyxTIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA0PR11MB4655.namprd11.prod.outlook.com (2603:10b6:806:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 02:16:05 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%8]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 02:16:05 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: vPASID capability for VF
Thread-Topic: vPASID capability for VF
Thread-Index: AdmCTgezzTkHY+EMTOCoyMjynB/f5AAeawOAAABU4SAAALJtAAAAuuowAAH+6IAAAPqjgAACPuHw
Date:   Wed, 10 May 2023 02:16:05 +0000
Message-ID: <BN9PR11MB52765638CD15BBDC762100EB8C779@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZFrMneCMKuCtu7JF@nvidia.com>
 <BN9PR11MB527627F407BB2942ADFF800E8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZFrThMhUnsYOE3WP@nvidia.com>
 <BN9PR11MB52760816DC23D5322A4318228C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230509183111.6a4a7f39.alex.williamson@redhat.com>
 <ZFrsYZPRpHqVyjcZ@nvidia.com>
In-Reply-To: <ZFrsYZPRpHqVyjcZ@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA0PR11MB4655:EE_
x-ms-office365-filtering-correlation-id: cff99985-d936-48a3-a22c-08db50fc8284
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X3T2xBnxBnnYjDcYB2FehAjEKE4C80mmSqT2BOCFVFe3miSPj/fpu3Fukl7zyCXLlGTdTu5pQVirnIFbGMhAu1XeCKlN1ZpBRjPNQZRQqXEAqmrK3v/I47fAslQgPa/l/HvYAEUZHcKv9aGhkjcWSnGhG/iBZKshePSkkhkDH8hGpXXQWgdXujyBxRGB3f89Em4z0l33bLWnSl/hDk3DZcMj4JeDwVpIRvnEhP3dEyzkQ8qug+LN56A8aCM6EODmEbdhWL+ihkRjzx+TaxNGC19uuNEQbFYYL9+M4BPhk0RhMuOogVYxa+pNF1V9Pr4PaW6Ny3gL2XYzRo32lck7Yy9GJU0CVTSMKcItk8sPEifeEDvxL65OTTxGD3TWRnvkcv4u4QGxlixK4OFCTMDC7Tq9y9POD87Yig3dq2Cyi5dp58/LGZAPOeBGMZEFcA83I5K9N8oOIiQ07QfkV/5pfElCf6WzCgHBgLv9Rd8RWEKHWA+ggP3OYqNav3DbHLgxXmMcuKxrNPhh/exl+rRL+I0i7ZNuG9EoA/yDqLwccfNZoAHyo9ne/GLIpyYmq1LprY2+9lsdrtqBU04jii3dfgo0AtOUJuuDtxs1ASZKNyMDHBOIFgkpm5K/jLhxhBXr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199021)(316002)(110136005)(54906003)(52536014)(478600001)(41300700001)(8676002)(8936002)(71200400001)(76116006)(2906002)(66476007)(5660300002)(64756008)(66446008)(66556008)(66946007)(4326008)(6506007)(26005)(9686003)(107886003)(186003)(82960400001)(3480700007)(7696005)(83380400001)(55016003)(38070700005)(33656002)(38100700002)(86362001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DvTX9cYuU0RLqNG3Ze18ZqhJxm1jFw2ogyGmylQWimiLa4ZDWk+u6EfjEUxz?=
 =?us-ascii?Q?TUNj1eaCviFePKe0WpIJPX55hgizG9NLey3zhT+iOsl6Q29IMawFc4TCaGMn?=
 =?us-ascii?Q?4i2HDjYtHl9KMc5udyRXFxnd1JVoQ8meQ2FeTZMeaEh27b2KPMYPbeEYBgEJ?=
 =?us-ascii?Q?mnjOJLcGG4I3Awvy6j0Lj+jEXMwwOIjm2cCCxiK9AHuzSSLyxO0fBRwJZkxP?=
 =?us-ascii?Q?kOOy96VT2FgpVBWY/WTDBniZCZMylHubQ7u4IRJ3nmrIg8MvC1mlmEH08wD8?=
 =?us-ascii?Q?pC2pxTBS2ALSSj7y+um36Jjm+S7ur6Yx3KAoX3yldQyiC2zhu8CDxdnQ4fxF?=
 =?us-ascii?Q?XTsleJHCmGPX/XNViZrhTHhuyxR9F4bQblFH0r6EWpBmJKIZFalyJ+O0vGYC?=
 =?us-ascii?Q?CdRCJzqjoMJ5akaM8s/LXL+1Esa54y9lfO4Gqt8v8t9cm9O/TNh++BpJL/tB?=
 =?us-ascii?Q?8YKgGYFvvBJssHJYcTQ/tkJSDu1dzHdUKs0BxBMWNziUPp/pv+VvBZzU3am+?=
 =?us-ascii?Q?pvDBYrpP3gXhEB8Shk4Ej5vETLeFtjb+5f/R6Ytd5gm676c15aij5NdZQAuM?=
 =?us-ascii?Q?RCrg4mAYNAAM8TVg2L+9wiFoN1Xlgy/HoaRDUEqRyAvs51YonxYhV+dIwPcx?=
 =?us-ascii?Q?nXv03vLvoMJSBJVrS9fereqaPkCkriDlgaWAGtXDWiXVaj+Nofd7yRFTUAML?=
 =?us-ascii?Q?A/tA82OMkxuEw/x3Kts96T6k7Mf/9P1LFd6yxRgMx9+rS40p7J4lSEhtgIz0?=
 =?us-ascii?Q?gbm2eV7R/0LuC3juE3niSjoUpjFDe1ujW16DnY6/qbTf+YiVV3PZIpHM7YbY?=
 =?us-ascii?Q?gg4W5NH5YSEUq43qxyP9duQZWZ75UC36wh8/irMSdyktXkx+lwiYVnFzuP+B?=
 =?us-ascii?Q?2IWeEwK4dpe8y92OetBKPiC9qB3V8pDpePYi2IuhO47WgVCNiwzHtaR4RWo7?=
 =?us-ascii?Q?gV7offS6wpbKyLPg2TyKDiYX42HLjS2ojPUaMymS2mTlPCpgZXJEiXJuHX+F?=
 =?us-ascii?Q?Xss2X+e9esJMewHw7HzHPNi1ebU0DF3Bm9zZsvEXZbCgu5iujr626q3xRXGv?=
 =?us-ascii?Q?pbOnToGL0MusMX/IYFMFqYcWFRqdK9Q06lxfxSp9LxwtszWnkTucTWQ90Imj?=
 =?us-ascii?Q?fbL84j5jl3dZUmRO+DCnnv6VgL2mE5sQUPv99HvEgSulvt2BzFepefkhIaAz?=
 =?us-ascii?Q?Iu3X27fmGEPgwYBd0ecCoesCwpRqgsDusyRhnH5frVmXhQfqoawOqJT9ScjQ?=
 =?us-ascii?Q?GtVvkLyyEercJyWUe0nZrGN6Q8uFGfbMJ+mO+Tk3KxBVwdeZtJZgJzJBxR9w?=
 =?us-ascii?Q?ddje8Wjm+jifsDkiXMbIvDzqa+lQRWEM/KTp/E7DrDPqI2IEHL8oTeogvARY?=
 =?us-ascii?Q?a8DNUet7fPq8KCYDypuc6aKy72ru90Xg2MSxjanFWH1+YbEsr8YWsyjQZYPy?=
 =?us-ascii?Q?3j9xY4AWKz7a+d8trkH1iod+knWD1MR1Nal/L7BmRDCwvVBKZLWhHzTh4+Hk?=
 =?us-ascii?Q?cWKg9Xh8GuKKL0chCdqxKkI9pb+8xE0Hhvid/xoJWK32aNYFc4Qy+SHrifKw?=
 =?us-ascii?Q?8scs4G8h3WsutP0CfBRZOC71NerWPTmQ8n62xlLY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cff99985-d936-48a3-a22c-08db50fc8284
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 02:16:05.4736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HdCXZqDqMb50irNeLa3YxB15RQjl4U35TzwK/KfydEyKyxUCMq+ZM338MzIbRggAB6SIgfba8k4ofnADa6YaBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4655
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
> Sent: Wednesday, May 10, 2023 8:59 AM
>=20
> On Tue, May 09, 2023 at 06:31:11PM -0600, Alex Williamson wrote:
>=20
> > IIRC we originally needed to enable this for a Broadcom NIC that
> > stuffed device specific registers in un-architected config space. The
> > capabilities we're {un}hiding are architected things that we know are
> > unsupported or unsafe, the gaps, just like device specific
> > capabilities, we're obliged to expose for functionality.  Thanks,
>=20
> I still think that if people want to do this they should wrap their
> stuff in a dvsec..
>=20
> If we have no choice but to inject a PASID cap for this to work then I
> don't think we should quirk every device, but punish those that don't
> use DVSEC/etc
>=20
> So.. If PASID injection is needed then block the unmanaged space and
> add quirks for devices that really need it. Otherwise leave it
> alone.
>=20

We don't have a control knob to hide/unhide a specific PCI cap
today. It's hardcoded with proper virtualization policy in vfio-pci.

Following current convention once vfio-pci adds the support for the
PASID cap it will be exposed if present (for VF it's the presence in PF).

So I wonder how "if PASID injection is needed" can be decided.

If we pick the policy of default blocking the unmanaged space when
the PASID cap is exposed I'm not sure whether it will break any
existing device which already has the PASID cap and hidden registers
in the unmanaged space and can be assigned successfully today. That
legacy usage just doesn't need the PASID cap.

That uncertainty leans me toward quirking every device to use PASID,
though I dislike it.


