Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3399249C082
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 02:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235605AbiAZBRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 20:17:31 -0500
Received: from mga05.intel.com ([192.55.52.43]:24431 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235593AbiAZBRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 20:17:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643159851; x=1674695851;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rWDbDqVEwL3dpB5nBVEdQRzoANZi9a5WfpJnK3ge5tI=;
  b=PLrnfFiH3amlICveJCFv0x1Lj1yGCdnBCoA6AHpHg7zI5DQVkNxTLGII
   6WezomFXVSG4gtBpWtQKDfhx67c6axGEhV3YdLXSE6kHHJLrs4aguj3Ki
   T5QGxmGYfJ/Bvzr0gfUYQU1UNkmz05iuT063GdN5xBv7KVBBDoE4ITb85
   1vnXEvhE/NT2rnZDqeoZofZf8wOM/v0hcL6IVoZSFWklWwsbTiD+NN/L4
   oJmWaApSxV/YN6Dhk1ESljyFd6i0B263beTQUIcXzLNuoSlPlhk8hRVp5
   5EHnN9oEcynzAaO13CWywaSi4PAtaa2UVnXVA99Mm+OmkSWm8De02Lsg8
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="332809913"
X-IronPort-AV: E=Sophos;i="5.88,316,1635231600"; 
   d="scan'208";a="332809913"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 17:17:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,316,1635231600"; 
   d="scan'208";a="479720105"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga006.jf.intel.com with ESMTP; 25 Jan 2022 17:17:28 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 25 Jan 2022 17:17:27 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 25 Jan 2022 17:17:27 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 25 Jan 2022 17:17:27 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 25 Jan 2022 17:17:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsCreY73i6MHsfUSkpzt1pifVMAxOufXiE/0rJCooE+OqRu900Acqzb9/F1g/5i0mfu35FFbE443B4w6l6eawwwtpvd0I8hEKIp/bdqTJil895lh6htEV9jHPillzkSnI2hFMbQLuh2PuaiLQcSR5qhA2DdHRNqe8tV6v0ZPCiNEQJtS+uHUWc6FMngnZn7AZpU4/XLllylWsODz9cSxdQ33bzBzV3BRrKwyqRQk+ySCpLdAXVsH2Z0Zc8RTDalBVq6bSojc7DxwI/w06hmXMZxUbCDVPKybJhV/dVl8WJ8GB9Qx+wdkwgxkQwRvgsmAjwBLZYXNG5g5PHqnuM2lXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4XOdgFp5khnJB4pxnZY6UAfg5WcU5TRfC8YltaqiJcI=;
 b=HJU3giSSt7mtDG2g3wcmwxwfRdjWiX06t3YxHZfm6kMBIqhATzDdnMQ5NXjz2az+32CxFStCWvDCzph2I04H5JzjcDY8u9YCaUcBCdaQjk5oLCmJw0hzqbGsWUXsU4LU2j4XATzllXj5RapoHtxFcbKahAkKidkNwjs7QcmrSrbIaq1jX5zaPNo8vYJmM98mg3oPR/szYWK1ITejJc3WZQZ4tGT/gqLvxK4/vualhdryW2LBwrgqkkN9JO1m8IAlXp5BcDAjQygj9rCVLvqLUWw2zCyIz47xWvHWohA/97tH/NuzkGBwswfkggxS5k5CvTjZxyHHpG0an0yKBf4P7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5495.namprd11.prod.outlook.com (2603:10b6:208:317::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Wed, 26 Jan
 2022 01:17:26 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc%4]) with mapi id 15.20.4909.019; Wed, 26 Jan 2022
 01:17:26 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Yishai Hadas" <yishaih@nvidia.com>
Subject: RE: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Thread-Topic: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Thread-Index: AQHYCX3pQbl/KJiueUy+Ou1rwdnoq6xzKCRggACfIwCAAMkU4A==
Date:   Wed, 26 Jan 2022 01:17:26 +0000
Message-ID: <BN9PR11MB5276AFC1BDE4B4D9634947C28C209@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <BN9PR11MB5276BD5DB1F51694501849568C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220125131158.GJ84788@nvidia.com>
In-Reply-To: <20220125131158.GJ84788@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 533fedaf-a512-4d87-e4ac-08d9e0699d28
x-ms-traffictypediagnostic: BL1PR11MB5495:EE_
x-microsoft-antispam-prvs: <BL1PR11MB54956B2DCF440758946BFB8D8C209@BL1PR11MB5495.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OaVxwACqOBqFqOai8YSPcgUxY5bWqLuvzOfFyg1tUus7p5Cyi2jGBHUb7MSvPlE3XWh1/KnpaG6kDJ6b5IOCFRcZPTDZIIkpNln3wEQDMYbaZ3PhgGmyNusQzeXT4w3snWp1k3GuFq48QrLSGTAFutD1UWFooHXh5uPvzKC16td10kiNNoLBNTsff+7KFf0fVauto4sbr36oy191TKsrSyaTJWVpID1OOpbt0JPCvNHECSfxJ3iS54T3Kjz1yH1wY+c0VaEvk/DXA9F4sTcV5y3Q7a6k410HL+bfI6G6bd2ji724403blooHzyNmI7OpBYsMi9IED2sYU3/bKs558FJbiQyy71s6NskQiH+Lon/D68QGTDw5PdcD2sSOt9FZZHyl4hYaZwaCUrT4BIF5+O680HKKphkQQqtMdDphgQGg3HaPEcW8cgRtVgt2XPMi2aUKAcMI7UME6CNRrUkNdGlB4Qx1Oa6Dx60UgbSMqay4ok6wMxmAssU1ZewH6hBzIScJJuNLDRDM6+7JfNOJ7ex0p2b2gH/cp11Dd3AFyvsJIwSRQL/Ik6J//A2LZ3FCggqmkZZ1uhhdht5MrVrOfMH2sjP8cA0T3snmHLA7GQGUJkrbBdJ26EwmduzyePGBNn0cBuazUMpC3r//fUeMOAxHb052tYC/ESPFzlo0WcZrp+654OC7ZJeHAk8f0MSYz9TUnfhtv8y6481x/taCnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52536014)(4326008)(76116006)(66946007)(66476007)(66556008)(83380400001)(64756008)(71200400001)(54906003)(86362001)(5660300002)(26005)(82960400001)(316002)(7696005)(186003)(508600001)(38070700005)(55016003)(122000001)(6506007)(8936002)(6916009)(9686003)(8676002)(66446008)(33656002)(2906002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BOZ6K5XRUN1PSra7y3QNt4Vp48Qdc9bR3ym//gC5JbJ1d0Xn8p+I9H8puVzO?=
 =?us-ascii?Q?pqNJ/Zy2sxZW7KT53gDxW5+XyyhkU4+6wkCn65sb0RgJA48u7ZzwoNib2EMz?=
 =?us-ascii?Q?DN1PNe85BAYQJz+Eq1H9LZ/CcbgUOudUyi8TvhoZqjxPr7Y3WrEnx2Xlnzfc?=
 =?us-ascii?Q?DOUUVYhEGBd8cCB9DZ6Ed7sAsgJmpiSqekrpuhderMkGK+NwPnr8ifNeEpnj?=
 =?us-ascii?Q?3E7C4L1YSclcCs0opIP2B6eePaAw50JVMo8TzV4Qr7wJB6uDodjZHeRSvAr2?=
 =?us-ascii?Q?TewtTn+pucg44Z4bV83aWrqMnxwWmPSrWaYnwDnEWomjeVlJMQtZ1WXJ/lKG?=
 =?us-ascii?Q?/lR/LZllzPhAwgA9CmR+bAV3Y0vSHsX5vVZLrfK2VlFhc8wyPdwQp2qqRoqJ?=
 =?us-ascii?Q?QzcbGT9WeNRPzAapbyvlXzzPoY4ikRUIXiC6nE6w524nmhkA4Nrb5jTtCSRi?=
 =?us-ascii?Q?K45xMFOUolfcPzjV0oj9eLUAgm13TAzwYsjTRGWjqSIym6XdtVxz3csCi9up?=
 =?us-ascii?Q?aPaLAgabsLb92RJ/1yVcN+Pyuu3YTIa3OrQKgKoBBjjYw2jbpfN0wNAYs0tg?=
 =?us-ascii?Q?UKXg/tdpm5OBO6suqHwToVchfLPsXg9uw08XMfItk4IrCvX0P+YbnmbPD/zZ?=
 =?us-ascii?Q?xsZpBVJbw0WpZQtOVZ+luYR2nvRpAx5C2T9r+n6KgULBEg5Sr/mGf1iCfKhx?=
 =?us-ascii?Q?SX5C3zkQl9FQBvAm+N5cI6maygIAFG0dKf7huY/C/ZIK1WU75DtIhRkmwkXh?=
 =?us-ascii?Q?b6SoLf3wYx5xoEYJFM3VnN8PayYVG2gjhiV89gejybeymjRd3+7QJQ3RawZQ?=
 =?us-ascii?Q?hCaLLtTuUMB2cxiCFD1xNYVDViyDZc6esI/RKMsc5hXUsJxbZGWUGdNBguL5?=
 =?us-ascii?Q?QSxzg4sO832youIgInGwBoYob+Z8C2l3q0denVUdtvQ69g1ZKiwh3l6eEsyB?=
 =?us-ascii?Q?5V1HyaOxAoE0vnHonWrhG0KUiTtQafMNeJx7uAv3MqABE7QFIzKCT80Ua+0L?=
 =?us-ascii?Q?0BqKtmCWiFLFEoXE+Fjuwep0E3fyZMNBtuhQFvnI31qsJn7A6FEiTQcXWLLO?=
 =?us-ascii?Q?bfhiYxuBpYAW2sXO6rtr2G/fjAIlfuZrK3fFLLGW3gLbVfVsgVO3E1P7mAsk?=
 =?us-ascii?Q?2eLgGskmkM3cdq4RLQJJa3qVq9qz3BSNtw8nfqsitbeB9wnSb9Si4DLot4pc?=
 =?us-ascii?Q?N/BBb299+HbHQXrukcspFo0pgcoDpCY6RTHJRo6VhzuPOryt/bRtLDLkM5pB?=
 =?us-ascii?Q?/qU/TQdgr/JfpWSKpkwlXqwU0WZo0deJ2Fq5Xy115vCeOWPUQolGTqPuiRGT?=
 =?us-ascii?Q?m7wh6C71I9b+ObOvgChJmxy7BohSFnB96wwr8Gh+EgV5kZ4HkK7HFME0HkMa?=
 =?us-ascii?Q?7P0ZnrZoepWtsDz1H5q02EUJD54ypQxgvG38t5DuF4Le87yfo9khxYtJ8h3o?=
 =?us-ascii?Q?/SrLXHOyvVX7QfkRoZcBVbaYPf7F9/Vf47FI6dJNs1OnFbAPDWAOx8nHZQeh?=
 =?us-ascii?Q?2CLPtI2GAtJq0l4nImGjtepziSxAmcXr5i6qZfopA1TkEVqfalKyE+1sdXbI?=
 =?us-ascii?Q?+MWqpyLk0j9LLTICDHzpFGMtgRAXN/Eg6/JAKFy1pRE0Gv5xuDKERtmWDZTO?=
 =?us-ascii?Q?RIiXFjraebJoktZBiR06kyM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 533fedaf-a512-4d87-e4ac-08d9e0699d28
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2022 01:17:26.1277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: woRPfTd2iTfs1z65949zUBbZmFK1+7XifcqSPvh/DPR1QLtJwISgE1EmqH0ZLcazmKT8ZnDpwEsfmYKLBcl+PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5495
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, January 25, 2022 9:12 PM
>=20
> On Tue, Jan 25, 2022 at 03:55:31AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Saturday, January 15, 2022 3:35 AM
> > > + *
> > > + *   The peer to peer (P2P) quiescent state is intended to be a quie=
scent
> > > + *   state for the device for the purposes of managing multiple devi=
ces
> > > within
> > > + *   a user context where peer-to-peer DMA between devices may be
> active.
> > > The
> > > + *   PRE_COPY_P2P and RUNNING_P2P states must prevent the device
> from
> > > + *   initiating any new P2P DMA transactions. If the device can iden=
tify
> P2P
> > > + *   transactions then it can stop only P2P DMA, otherwise it must s=
top
> all
> > > + *   DMA.  The migration driver must complete any such outstanding
> > > operations
> > > + *   prior to completing the FSM arc into either P2P state.
> > > + *
> >
> > Now NDMA is renamed to P2P... but we did discuss the potential
> > usage of using this state on devices which cannot stop DMA quickly
> > thus needs to drain pending page requests which further requires
> > running vCPUs if the fault is on guest I/O page table.
>=20
> I think this needs to be fleshed out more before we can add it,
> ideally along with a driver and some qemu implementation

Yes. We have internal implementation but it has to be cleaned up
based on this new proposal.

>=20
> It looks like the qemu part for this will not be so easy..
>=20

My point is that we know that usage in the radar (though it needs more
discussion with real example) then does it make sense to make the=20
current name more general? I'm not sure how many devices can figure
out P2P from normal DMAs. If most devices have to stop all DMAs to
meet the requirement, calling it a name about stopping all DMAs doesn't
hurt the current P2P requirement and is more extensible to cover other
stop-dma requirements.

Thanks
Kevin
