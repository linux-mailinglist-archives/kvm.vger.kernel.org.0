Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDCC49C0F3
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 02:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236061AbiAZB6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 20:58:39 -0500
Received: from mga03.intel.com ([134.134.136.65]:40910 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231380AbiAZB6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 20:58:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643162318; x=1674698318;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SrXGGFCFyshqESjHzC7oVvPxXlKqoM93agM9gU/d6zQ=;
  b=cl/qeNWGIDrbawvNdGL+vL/cnpGW6nxYFgPUvRBAglnA1gVhC5sH5VNM
   BYxzoq1RyHaVAvu9CN9s9IG0Agd2xnUH+dg9FHq6n5NrPfVk407Upnv9z
   WTPY1Yveuqnor3/sxMX99qAnPIVfdgCGCnSVl5Tyu6E4FQviWloHXvmMr
   f1qA2i3mcgQkwSUqMOvO0YmYTGK10A2X5LA5L6Z6T8lPnbHjVKAMneHc6
   XaQkrb6tf9CHYTaFFShCgk2xTtkZdd1IEvHBukTE6IsOk3HNm1/gCiiez
   Ln6T9095cmhhNkiXx6rZcSfia0Q+26KcyAQhaXP0UqZiZQB2GMaoLEaHi
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="246405995"
X-IronPort-AV: E=Sophos;i="5.88,316,1635231600"; 
   d="scan'208";a="246405995"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 17:58:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,316,1635231600"; 
   d="scan'208";a="532621209"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 25 Jan 2022 17:58:38 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 25 Jan 2022 17:58:37 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 25 Jan 2022 17:58:37 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 25 Jan 2022 17:58:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8LRtkIyB+hj8+mR1Jcr/5FcNn2pTtW9TsttvllMKjUN+kaFEiNZj5esqEd87ZYRuVN2z8w7si2idsunp8eeGmNCch+76JRou2j5ybzVh+Cu5uteNZ85jFmHVr31dY74icp/gbJuDFpRsExk8CnaAj27UaCPBZusXMfZBCM/9YhFiUjkq+VAJYvsl1DKtGUOvJqaxYaeCsiIQNjpP6A0jfply6tdqyAnwmrh5W5KqjRtcAhjXVlmH2FjCx6eMfjDaNNayuQloJFplrtOp5FA10vb5TgI0wNEdhhSCrfrSVKBgNAUoMs9hrLgMWNmi3auvij3x/v1Dkt4MeCf8nwvBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SrXGGFCFyshqESjHzC7oVvPxXlKqoM93agM9gU/d6zQ=;
 b=dg4ZQIaLgXs4Z/0GmZH91xTe9Os3jy3ajTpwwd+Rw9Ntf/xgyy5VIbe/UIIyUyT66itZyZjmwW/eFg9BlaZI4Z/HZnjDWZnwwaYH8OxBjzkS6wbsIcOPfoJ9prfpFnRJuBVI/iGXuRId6PWB394EchtKuXhEq3wEV0PExkkFiGB3241kbau1JUPYqV9PTZ9CW/I6fSVOYGQxMnqLfiCFAHoHXNYG8M7NQ+yPf0fqTxmQMQbpBOWdmqPtxhek151BIA2yUyhNbBUn2+DfQldTmeFnlPdlZu59fAPK5SYReZ7U/cx4ZkN8ShZFGJLb205xqL/K6E//8bwpLogpYsB8AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1780.namprd11.prod.outlook.com (2603:10b6:404:103::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Wed, 26 Jan
 2022 01:58:36 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc%4]) with mapi id 15.20.4909.019; Wed, 26 Jan 2022
 01:58:35 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: RE: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Thread-Topic: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Thread-Index: AQHYCX3pQbl/KJiueUy+Ou1rwdnoq6xzKCRggACfIwCAAMkU4IAABssAgAAD7JA=
Date:   Wed, 26 Jan 2022 01:58:35 +0000
Message-ID: <BN9PR11MB5276D925DCE559DF372B7E568C209@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <BN9PR11MB5276BD5DB1F51694501849568C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220125131158.GJ84788@nvidia.com>
 <BN9PR11MB5276AFC1BDE4B4D9634947C28C209@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220126013558.GO84788@nvidia.com>
In-Reply-To: <20220126013558.GO84788@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bce8a20d-65b6-4a14-ab3c-08d9e06f5d3d
x-ms-traffictypediagnostic: BN6PR11MB1780:EE_
x-microsoft-antispam-prvs: <BN6PR11MB178041B11E46CE56F35A3B5F8C209@BN6PR11MB1780.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8w1H7eoXrjIj4yQCkuvW0Rg0470EuuPZsrNplzivBMPxCbBBdJ/vGtLy1uc9U9MoY5cMi6fb1FgpIwM8C2KOi+WPnm3ismyMKe+TPEeBfg3op6W6EpGFsbQznLfSqnCmRf2caPhbAE92XE4FwyvBW6FDAcz8gi1haKeVwJH4TGoY5x9yrlA2FXkxQ3twraT/ZMHuVGiPKUFClt8LRF8gOtlED9ncD0uF5l/8B8iBzlPQyS+8Jcy7dseAwJmOzCA9tx6dhBaAMDHaudP4GISWFppOeQtkZ7Dsc/HDMqQYmQUnlZQ8VT9srgRIrpNKWLa9ZzKLlfwoSd2zZ3x//r9ephrFy0rFd8Ky4LdYxljqUXSfNgEOh4G6diCu6GJoVKiJvMnmqBS12S6BEVUW3CJjD/vpQW5QQ7LbdSsdrj41TO/8koiTLhxXLjPEp7zugneSCprvFXPgvYNu4SA9L6Logu37qNwDVXtSppKbhqOrLe4x8jGVaeFbJWdc8rU/M5o2xF4vTnchysqexW3x2eXbPKMDz0LjxDy1DUm/XRqSl/LLi+yqTS2Iz8J7HD7/GekKUlR3lAwFg5TRrfttci+N7CoDxQm7WXHY1bpp8OW3TN5CKIm72X+sLbQE6LEn/1jqAXdbfF3XslnK9Kz1jktOZjQcCqVN/9dqMlB5PO/AWsvn6wLP6agpv/mfOTJhemYYGdpBhwGaAJXJ08prROoceA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(508600001)(54906003)(316002)(71200400001)(186003)(26005)(33656002)(66946007)(76116006)(64756008)(66476007)(66446008)(66556008)(6916009)(4326008)(86362001)(5660300002)(9686003)(6506007)(7696005)(52536014)(38070700005)(4744005)(8676002)(122000001)(8936002)(38100700002)(55016003)(2906002)(82960400001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SoNS3EaX04k/xjl5z+ZNFZgKkFIT7llgujV94lNPkbDMITq7+hoOB3vB0nxb?=
 =?us-ascii?Q?yBYxYN6g3bTOWRyHERMpb+a/aWUOm9RkD5e0TWlQGCujEtyr2Sgl4GKSgTNL?=
 =?us-ascii?Q?v16SrvuQ6Co/Ft+GDSGYSy1ZJ1aNRb54NybpIA1q2J8/8A8VgMz8+3IlEANV?=
 =?us-ascii?Q?BdKU6U8adCq/jhaQjMzpknxk9P+N9cGAzR4QS1RE7F7hUlGrl4AqzKFm+4AI?=
 =?us-ascii?Q?pbULkzt5dpFDAAluyJ5MIW8rFEkL96J4c1yA0nt6KPjG9BDPaOnXjtg6Tk2s?=
 =?us-ascii?Q?t20wmni1D9HsjOFRtubta1yoWPj4+DBs8okh6dfIOvv3y3trjkPPz5KkcDN/?=
 =?us-ascii?Q?WCfGYbKjZCRjrUuqxSE6zl03tctBE0LgaesvPUjlOjOmm2t8NqlC0+mg5tQx?=
 =?us-ascii?Q?/cuR8Xa5bO/iPhD8wHBUMz/i9QBES4Uy7fnt1ZwtqM9gt00e9tSRLLerQDa0?=
 =?us-ascii?Q?2QytIBKyFMJJsO4gnCguUyC+VwQzXjbmZ4Oyd5h0gYVNEqHOzHJ8c+MsUYH6?=
 =?us-ascii?Q?FfMQqhODybD7anBhYqN6QDdOB7xPgRWUKhLvHVeSChKjloC5EkwOj4XLTdmJ?=
 =?us-ascii?Q?HY2z98ShfwhULd1UevnSzoBPPQoE2KsWZyqBizhzJ2gh6BHLS1U76QTOOPBq?=
 =?us-ascii?Q?TqZgVEYn2utJSdtdzIVXWSGmLY0RKpfwVALx49CTUZNIHgDg17dXHUxXdZkt?=
 =?us-ascii?Q?yeLIHc6J/QJd/cGWrTDVtArNUNNJ0CptiYuSFpHSPEfSetijfzbllJ66A7QZ?=
 =?us-ascii?Q?ZXy118xhwWSU+HlHISBjSkYG8kt2PNqNB9yOX2hbWHKq5lGHzErcUkdyVFtw?=
 =?us-ascii?Q?m/QsXRsJhMpLNenfAm1Vwyp82Qune9FlH6iQAQG/Q2gZJbbJB1ier9Aeq5LR?=
 =?us-ascii?Q?vYz88dUYakWBxAYTck0sI6q+KDgwhplXVFrVFV3gDiaqfdY1RuW0UB5Ke3PL?=
 =?us-ascii?Q?rX9yjpMkz2mCYKeCv0zT6cVwCnM3iF3ygJRUT6Yb2u/NS5iQ6IjoW+e1h0xf?=
 =?us-ascii?Q?qTdd66ToVAQVBvbu9D3z6Q+BafBMfMdEOUcI3c93oLk4QOMXgmNuUPmw2bhu?=
 =?us-ascii?Q?gu5NVXP8E3Gapb8J4ZC11dc/qWubDroKK3VMkE/WsU0qhiJZu6Do35WLy2HB?=
 =?us-ascii?Q?Y9H8BsI/cRgNx2LzL8ak0yQxnCaTuyQCFz52K69XOvTIpmJEuzZnsRTbSNB8?=
 =?us-ascii?Q?7bQYKs5idPjwgLQAjO+Y9WSmo9jdrRc4ft1r+t549KqWGAooidm+yKHiWUh3?=
 =?us-ascii?Q?3UkzzpL0I9hRqthPlmH8Z0cWZVVQSoQStu/MbPGxfqWloD/VB7fxxuYeoQzy?=
 =?us-ascii?Q?tfnwPuFWHESuNcPgXt7azqULLirU0hOjgbp/ruXD9o3hx+9q2v6ZW+C3k9Rf?=
 =?us-ascii?Q?URQPZ/TxWw4UHUpe5FB9EipQJ1jNBTUHOv7QjdaZMN5f77eJ8qzIdRwsW/Sh?=
 =?us-ascii?Q?UWRri6Z1dapqYzS/2gQkf8Oyo0APUmDiGffObQRkXKpZspWbr6hHMv3WAXmO?=
 =?us-ascii?Q?CAquwtdObkQlLcVIU3Rxc+zL6goVZOnbCC5uCbs0KY3+nRV1PHQic8Gpluus?=
 =?us-ascii?Q?ShE3f4ajOLvugKjEATIEzMGYxKtQsHLXvXC1SPAsagGEZLJM5Vnspvwp3QNq?=
 =?us-ascii?Q?0FRGcZNmigrgvDr8XTIyiLg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bce8a20d-65b6-4a14-ab3c-08d9e06f5d3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2022 01:58:35.9012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LEeXLFFBQEem0q/CC0XJS7OEQGTQn4zpmyeiSdo+RCF/XvpG1kyXMv8SO0/KxoM/ZfiL6pZiC+koJZomL677XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1780
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, January 26, 2022 9:36 AM
>=20
> On Wed, Jan 26, 2022 at 01:17:26AM +0000, Tian, Kevin wrote:
>=20
> > Yes. We have internal implementation but it has to be cleaned up
> > based on this new proposal.
>=20
> Can you talk more about what this will be?
>=20
> Does it use precopy?
>=20
> Can it do NDMA?
>=20

Current implementation is more like a hack.

No precopy as the state of that device is small.

It simply switches the order of stopping vcpu and clearing the device
RUNNING bit. In existing migration protocol DMA is stopped when=20
the RUNNING bit is cleared. As long as vCPU is running all PRIs generated
when draining in-fly requests can be completed. That prototype doesn't
consider hostile guest or P2P deadlock.

With the new state machine this can be addressed by a general NDMA
state (with vCPU running) plus a timeout mechanism.

Thanks
Kevin
