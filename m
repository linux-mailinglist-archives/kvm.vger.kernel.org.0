Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A90D73F42F
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 08:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjF0GDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 02:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjF0GDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 02:03:33 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0521BEB;
        Mon, 26 Jun 2023 23:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687845812; x=1719381812;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KkSXQjxNnss72b2f1eMzW7SIwHCyDENbPfwoVz9egps=;
  b=Z4EYyiRXKiMX6thM0wh5H1UZ7GIpI9LpxDyGvGAFU5kpcoX6LVNXTlDS
   9CXFzXv87N27V0oTLd3TS+Q+xea4bsPnSApt1nVf8U34oSOZ7JTEOoyWl
   eTHuCfloPeWcpqC0AjfZO6kTPLFhxVgC79gaI4j2/2Cx32iLc32YdaWjw
   wQSC0CMmACC8W9qJcmuL62uUhoyoiUTvxJOMCaQ1ylt5iUtgr+rRzTLjJ
   +mtgLskbBsoTSBiVMzG040U2KBhFE10z2sW/p4L3PU/zwv4AyXbaCYEqN
   iH96zthYn/79iOB1oAULnO1apTJ+xftp6a9W/YFoV0zdTXoRkZrBXz3yq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="341825406"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="341825406"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 23:03:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="666573714"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="666573714"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 26 Jun 2023 23:03:31 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 23:03:31 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 23:03:31 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 23:03:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvN9FMqMYkT4zFbLp1Sw4Ka5Zsx2bY2PBXOqLi5wTzIIY6FskIM78vVxNGiStrbKFIngIdTLmhayjpy0pKl3itZY6lKA7bt2AtN9CQ+jd52d1fFGyIqwto1G4uuMAlK9rSC5HNjmK+XeOdRVKCOMrPKQiZLT+jtA2/lUj5ibdIE5e9lC4Bu1QnUO121hDEiCf2/2cn8Lsa6MNHRjKHeXUxukAX6SqyBuDK1yXLYd4hnzaDCfiGCBdjILFTH3NCp6ushgBP2PY6DffQf9E8MmIpiA0bASfcbA1s1AEV4WJgyfBV60bNguxd2aUDfU2PsEgULQ86YZS/PstpB3w1Y78w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KkSXQjxNnss72b2f1eMzW7SIwHCyDENbPfwoVz9egps=;
 b=hy45zUSxiJBYvS7ezk+23wwZG7+aFtMxeZsRPn+pgukkEl9v/Tft8ntmVuUituc0XGLhUnmK5zCAPiAXDmuPSFfvQAYD427rxflkgesakN+t7UDbukPDlHRfG+yCOpavwt1Xlwmtac7PknWYgyEHJeudnm5hoqDD+6YrU+0qI9t1BMNdnoJZUxgyPpI1sFmdHg74BL7u3nb2Jx1wRn6m7l7v2hMsWtfXuAG8Ul+oqWDnAOZLaCU9wLQ0K8bFdoo9J4b/ETPqZCsgxsSAnEKNLmxICxSMEv4fWRaDvbOU7i8r2EwWA+P23BNjD2sU7vMq0EJIuqfVCuAYQg4o29k26w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6444.namprd11.prod.outlook.com (2603:10b6:208:3a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Tue, 27 Jun
 2023 06:03:29 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6521.026; Tue, 27 Jun 2023
 06:03:29 +0000
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
Thread-Index: AQHZlZ4kU3Fwl99xbECsoSBHo1JwW6+NFosQgAUWbwCAANnr4IAAtAcAgAEnoKCAAHp3AIAHb+EwgAC7zYCAAMX5cA==
Date:   Tue, 27 Jun 2023 06:03:29 +0000
Message-ID: <BN9PR11MB52761E563DC967853FEC22218C27A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-5-brett.creeley@amd.com>
 <BN9PR11MB5276511543775B852AD1C5A88C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZJBONrx5LOgpTr1U@nvidia.com>
 <BN9PR11MB5276DD9E2B791EE2C06046348C5CA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZJGcCF2hBGERGUBZ@nvidia.com>
 <BN9PR11MB52763F3D4F18DAB867D146458C5DA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZJL6wHiXHc1eBj/R@nvidia.com>
 <BN9PR11MB52762ECFCA869B97BDD2AA9D8C26A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZJnVYczb9M/wugO8@nvidia.com>
In-Reply-To: <ZJnVYczb9M/wugO8@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6444:EE_
x-ms-office365-filtering-correlation-id: c2a98f09-80f0-4ff4-a645-08db76d43ac1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NyieO+U+0JfxZl7rTQNxOXxpWNdBYxtgPWo/qc6a8lPXm21giqA9AtPFZWpAJp0aPOibNWHnXZG3JU62nLsRtB5dcZpi3AF5s3XP+oy5x5jt3KNmaMkqnksrCbmP0ICFjITr6ICXZ9rTkZLuA/XW/TSXxVWmuebMRdBhtmHYemw2L6WuPWBsk3jZWHrFpevloIjkk1f1Me7sGFedWt7ArNA1oYxBhgTgOCXMLEkv2b3HQ7jQPgJ9+p6Ipe38RhRmO1+u1PMSukMzAXz2ug8GPuhily0rsb+4GUFxIzLhhHyRkTx7XrjSJFGJCEp5+HBvxhQepz8AHjiFVo3YY0xdu2s/m6KRX1yzmvHb3W1LuVt+YnusyRpyk6cs3NUjmKbvJInZtp7H9BCX8HsP1tHdps1SU9lkDbP+yDEjBduPpjuJbTV2aKqD+OniHysOyT5rew3qpkTRPjTb5xkMGtz024jTbPJqp0nCcTfip+ez+/nsZWSNdVXFzp/ZYszQE9Jj0LQPqskFD+9dL0oRI4qpQS98vt8HiJf03UjrIL2cbry2nA1LxJmF2w6UxkB3ZVT+z+dWESzoaovvqj3LA5h6AsAhH9wMvww5v3s3sBxaogNLMbJg2argwpBq/dpv7Agh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199021)(2906002)(7696005)(82960400001)(71200400001)(83380400001)(122000001)(38100700002)(9686003)(186003)(26005)(86362001)(38070700005)(55016003)(54906003)(41300700001)(478600001)(76116006)(64756008)(66556008)(66476007)(6916009)(316002)(66946007)(33656002)(4326008)(66446008)(6506007)(5660300002)(52536014)(8936002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?g4P6MGXrre75JBsoeMUXO1vh6cbZZ6/T8v3xlGzjRUAyev/06t85JbC02buA?=
 =?us-ascii?Q?wh+fS+Fzpx7Ib5ZZF42HBCAY925Qcup1VKVNCaC57Y+sMpIcsuNlXt2WDOP0?=
 =?us-ascii?Q?5V5ol97XbXEM05kWx3FTkcEnbekbf63Cgb0jm41irUBFyyold+IPD2P0bPqL?=
 =?us-ascii?Q?881AFrhxvDcyXG4qE6JNEtC33MarSNLA2UCKwHYHBKnf/B6TWpy5boDBSlUB?=
 =?us-ascii?Q?TpOtPNcx+NR7XRxiTnmG2xzXyizjMmMOU/FX7KjkEzEKyX0qmfwZmdsnbMR2?=
 =?us-ascii?Q?xdxn3+dnjcmICqCUd9BxAgUPGdOdvzcZbtO9D6h4bz/vJLVr0l3bFjESsRHz?=
 =?us-ascii?Q?75bWfDuHmuLFZvNwvzborOnNlopzgytqY8HSGUHE4n19eqcJEaHKgjL4f8aQ?=
 =?us-ascii?Q?SBNIfesOnvSkFQ59YzNCmfZmU/SRTFR2hUPkQWLC8ubHPhpqeqRvXF5x83xq?=
 =?us-ascii?Q?lo8HuDi/q2ss5Zg/aObgnG/thtP4sS/E7CNszCqU2DQpGNIMcdKNs03yb6If?=
 =?us-ascii?Q?ij2T/e8M0R9ep9xlJZgPQkahAe8z3fcqpAbWN+UU0g6fB+jYhc7jBdIe/C2/?=
 =?us-ascii?Q?V5FZQHCxJmbf4ZEF9zXANAVegAKdAFbIqPVJtz9QA/dBidTkAYRc2DBKFaO+?=
 =?us-ascii?Q?gGwiNjxAErHA0Zpy4n3cla+OCBXP/trPld1tZqeAQK9uoQFO3EM+95ox4s/S?=
 =?us-ascii?Q?iaOrIy4m2yiR0mJERvrLvnO1kLpL/ZrRKQxZ52NtJ+TTTR0qVYr5EQZFzJwf?=
 =?us-ascii?Q?o5/LRw027TnoA4mBkJOzDCwnUWnH+UUtc8lTzZ/aCFiEVvW+B6Z3hOQYjGhz?=
 =?us-ascii?Q?wmZHA+qTnVn3ULabcm6cHx0q9mHQQs26IdcTrCjnjuWg2xLkInH+ZU4Os9pI?=
 =?us-ascii?Q?FKRl/0aSL8V+B2UbhtXczqP8U3jcopP3E6CQhg2BbHeDOexdVDv0uEunk8sr?=
 =?us-ascii?Q?KXIFwmo42vHiPn41o2Y5HhGaNjkZI+VY42SSstbzMOPHImn1mgRixpMZr9i8?=
 =?us-ascii?Q?SvGjn8IVpHPOnM3MZHG+bTWLOfU6Xym1gIr1y6t9j2hepYD1OoOBDmJSmya3?=
 =?us-ascii?Q?eQB0bhQUC+wDQdAVAevp5TiesbWyOavSv53I8ymi0Wf17IaQeQr5iq75HYnO?=
 =?us-ascii?Q?+nzMpQUl/arpalZGga3KupSaZLcZ07urPRJQyOTgbNyzPXyG5Z/43O3VXsTf?=
 =?us-ascii?Q?fACoj4Tt1htp1VFV5oyIsRbFM9m3vPU8m//qDu2oOVq9R6VeDAvOshymrUSE?=
 =?us-ascii?Q?uPxwdmd6j1vzNRabCUXWuFrgcjOJlflZ8nXU1+5X3y/zZ1egWcr/Zi5lvsij?=
 =?us-ascii?Q?qpLkE7kIV1M0+zPhDX3KN4ioG+yBGEdON/g2Xmjm7p7h/yVe84Idx/XDPqxf?=
 =?us-ascii?Q?LgJVf3HtLxpM9atemVuBRuMCCY25kRrVI2i/GJEfx7T75EpzpcNjIJXtBD2W?=
 =?us-ascii?Q?0p5Jmbgkk06hANnVaTtq8n/9wi+3S1+4/L8gZnRY2f0KbJlJWWvZVHbAkPBP?=
 =?us-ascii?Q?9Q//KHikR4glf/e318EJbhBd36iaQVtkFWvjXjheJLSdxNNjdxHCblKzblCh?=
 =?us-ascii?Q?+dPZbw7SdRvTdkww3YLQRPuhWMuGlCtrPSzRzrGH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2a98f09-80f0-4ff4-a645-08db76d43ac1
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2023 06:03:29.3788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6BoSFuMAbUpSNZzy2Qcv02bVi2tGtQTXwptqCOzH9YM0aVGKlxUmdAnKjtj/hbsPBL4dYeiMC6VWazFpWnOdAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6444
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
> Sent: Tuesday, June 27, 2023 2:14 AM
>=20
> On Mon, Jun 26, 2023 at 07:31:31AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, June 21, 2023 9:27 PM
> > >
> > > On Wed, Jun 21, 2023 at 06:49:12AM +0000, Tian, Kevin wrote:
> > >
> > > > What is the criteria for 'reasonable'? How does CSPs judge that suc=
h
> > > > device can guarantee a *reliable* reasonable window so live migrati=
on
> > > > can be enabled in the production environment?
> > >
> > > The CSP needs to work with the device vendor to understand how it fit=
s
> > > into their system, I don't see how we can externalize this kind of
> > > detail in a general way.
> > >
> > > > I'm afraid that we are hiding a non-deterministic factor in current
> protocol.
> > >
> > > Yes
> > >
> > > > But still I don't think it's a good situation where the user has ZE=
RO
> > > > knowledge about the non-negligible time in the stopping path...
> > >
> > > In any sane device design this will be a small period of time. These
> > > timeouts should be to protect against a device that has gone wild.
> > >
> >
> > Any example how 'small' it will be (e.g. <1ms)?
>=20
> Not personally..
>=20
> > Should we define a *reasonable* threshold in VFIO community which
> > any new variant driver should provide information to judge against?
>=20
> Ah, I think we are just too new to get into such details. I think we
> need some real world experience to see if this is really an issue.
>=20
> > The reason why I keep discussing it is that IMHO achieving negligible
> > stop time is a very challenging task for many accelerators. e.g. IDXD
> > can be stopped only after completing all the pending requests. While
> > it allows software to configure the max pending work size (and a
> > reasonable setting could meet both migration SLA and performance
> > SLA) the worst-case draining latency could be in 10's milliseconds whic=
h
> > cannot be ignored by the VMM.
>=20
> Well, what would you report here if you had the opportunity to report
> something? Some big number? Then what?
>=20
> > Or do you think it's still better left to CSP working with the device v=
endor
> > even in this case, given the worst-case latency could be affected by
> > many factors hence not something which a kernel driver can accurately
> > estimate?
>=20
> This is my fear, that it is so complicated that reducing it to any
> sort of cross-vendor data is not feasible. At least I'd like to see
> someone experiment with what information would be useful to qemu
> before we add kernel ABI..
>=20

OK. make sense.
