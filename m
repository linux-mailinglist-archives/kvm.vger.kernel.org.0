Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E183E41A7
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 10:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbhHIIea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 04:34:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:16089 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233986AbhHIIe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 04:34:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="300236877"
X-IronPort-AV: E=Sophos;i="5.84,305,1620716400"; 
   d="scan'208";a="300236877"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 01:34:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,305,1620716400"; 
   d="scan'208";a="459999142"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 09 Aug 2021 01:34:08 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 9 Aug 2021 01:34:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 9 Aug 2021 01:34:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 9 Aug 2021 01:34:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZE9DJUsVK2WII2MFFx1zTrX75n4G0hE2/w+dKymzXpva/Y/vIOZQfgF5sN6tieS7ly1mbeCkP3p0bWsxFf43U7f/vt/LSXztVlcmjgu5bXdnjeDAlIxdj5SqLpjIuc2qCCtZVFYpzhXQLY2QzLGecUUoFYXEs9lJgwoTFoxeCgyCtcUc1CgrQ1KBZ78+nqURxijEXKzI94mvYs53LA9SglfZoHUVUJppjqlDVSpCktjzuT3sj5V+9RsLxMdGYFIdR/AODr3Q5GH07bJny+PD6TotW1RUCsp8Ruq3nVA9YtR3GKpmqTJ+Nw2elDs8mj9b23T4PaNUjL6CAzLj4FFMEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvjIAOIQgmjqL9W6IgZCU3+cP6ApZVh6lFPU8V1LF2k=;
 b=T0MPPH131p5LV/TURGW4gcPRtjhSk/1WY1//O1njqoecDjBLoDDBZwMkUyyjKENHlqHjvzNrR2wpyJ5UUztUVVNW3iUUQXRAMAQiYQyB+bD89RhIwImf8VWbNmGyzVYrKqprqdSecNbFbqLFBIbo+M9Z3QtueY6OQJva4dvI4Rg22PzqIZro5EgGDIHIHmvYbIYHl0m0ARppJBJRABtXkrQZBOuyiujH8c07XImkyp+lEytCnaQriONpmMHFXaTkRQVwVp1u8B83lLZyLDOPbsCQGSzPLJyOlnKrtdKEIClIfm2s1G7BIE2rVwPGsFKb3MBtnwt2SsMzqF089scElg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvjIAOIQgmjqL9W6IgZCU3+cP6ApZVh6lFPU8V1LF2k=;
 b=afdGErFBuXXxIvGTM8n+jszjMf25RwrlS9ohhJ7A1fbVSqFw1d+mS+3IJX/D0WjzeIyTpBHTwusFW/zjQxswcugGdlxNA9PZd6zDW2xqBK89JGrimqIYmRLV8uq/gCSWdPEYT1vFdbS1ciwfDqb0KWnUyPz3RC+D7OogXJkXcKQ=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN7PR11MB2561.namprd11.prod.outlook.com (2603:10b6:406:af::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Mon, 9 Aug
 2021 08:34:06 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce%4]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 08:34:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: RE: [RFC v2] /dev/iommu uAPI proposal
Thread-Topic: [RFC v2] /dev/iommu uAPI proposal
Thread-Index: Add0lrMH87IsTsl5Rp6WN1oQU6kGMQNQxoYAAGGEwqABKoT0AAAAch4QAJyI0wAAnMDPwA==
Date:   Mon, 9 Aug 2021 08:34:06 +0000
Message-ID: <BN9PR11MB54338800A20821429D7C34038CF69@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YP4/KJoYfbaf5U94@yekko>
 <BN9PR11MB54332594B1B4003AE4B9238C8CEA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YQig7EIVMAuzSgH4@yekko>
 <BN9PR11MB54338C2863EA94145710A1BA8CF09@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YQy+ZsCab6Ni/sN7@yekko>
In-Reply-To: <YQy+ZsCab6Ni/sN7@yekko>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05efb3d6-35a6-4126-f6f5-08d95b10738d
x-ms-traffictypediagnostic: BN7PR11MB2561:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR11MB2561CE7E254B7EEF1480FE1F8CF69@BN7PR11MB2561.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KxGCuNgA+h4oJa2Hs8xMkGjXdUgFKAXy32gVZ1jBt8COYIGEL4QhyF/2dI4ZxY3kGWqL5NJTCJfLxL3iEPXIsjrH247Sf4q50P6n5JfMPNVqna5WDyfRcnHwhU0h70+Owd0fgAetREOjz6Wx4tb+PaoGBK7m6YHDYLwVwfD+G2a28fldChzh+i/wXnF0hJ67GVklNoFeJd6xpCosXrSZyOTqGBTCJwMZSz0K8pSvUFDbBcP0aU3csvrCGqDrmAn1n6iB8yEtOEtaSv5vaqKlFO2+mSiU5NdYq9PUjZ4QHBLD7tWMRm7m6XiKjOKAjSMcex1twxhbCsHhDWN35buX4hDIMykg8TMQSdF4ZY+ZeOARI4yiGD1zIHJRL5hloLwGj+gqX0le+Y5BUrYLFf3A0Z7iScADQ2uYZEpLQwveamyCM1/99LpSj2L/3jgeJshhtDqgBQJ739h1R5oKeDiYjQira+rSCUPbmg5GG6udVBmuvb7Cl2/0iGzd8HYNkrfaHo0joGfO5bYuNcsRqfUbD+/fIUsGgcbsmGSXX9RZThQjxod8aJPs05cYlR+2LGHsT6GOjpcHIzNdCitU7GkdQMVti8Oeh4lDfbHcO/bVWsL8xMsZXwcpP7IKcS82jeI03ygokIV+MILVCb24Zd8ATjrTBlnZKEMDMR9qvQQrKxOn/Yj0szYKwnFtCOaOS/A6Yq33cIiFWo+KiT8VsI1PpA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(38100700002)(186003)(26005)(6506007)(508600001)(33656002)(5660300002)(7416002)(122000001)(52536014)(55016002)(76116006)(38070700005)(86362001)(54906003)(6916009)(316002)(71200400001)(64756008)(66556008)(66476007)(66446008)(66946007)(2906002)(8676002)(9686003)(8936002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fzR8mlmZPUwZklTpQzK9GdxyyoJQpWDncIFvVb54MEU6SsQd4SnDflvQ/qqp?=
 =?us-ascii?Q?dZsVPIA/+t3InUPugE0ZQ9bdG5Xl+uwwYRDnBoDGy8fi1tqKK1WrQqEv5Irl?=
 =?us-ascii?Q?Y5jqLBRDoUe93YUAbHxG2Tg3cSbiskw7ydXitw7390LOXs9CljrqvRhZ1fcu?=
 =?us-ascii?Q?1hvzmtXy+WW15v/L3giHL/ZUEG1+NaiUoYOalbAg+iC7OqKWKcwLV5tumlw9?=
 =?us-ascii?Q?5uAAt3p40EOcUETUiXRXpvKFoliKXn6Kwla/Gsi2mAW42JTrdiqbJGjuHmRJ?=
 =?us-ascii?Q?tQ82cd8KvPJf15be6hAMqMrSNqH53+R6UFNoMUXmr7WeZea66gL4gontRP6p?=
 =?us-ascii?Q?BmyuRIHMt4lotaYlho7PUnUCDXPNqaRorl0+GiM+obrkIXIN0hGFmJAnZjy0?=
 =?us-ascii?Q?sXz0p0C5uSxDOJPSDeLFYGY70lLtIX98mpRPDSvX76XG1yvZOsPcYj1NmOl4?=
 =?us-ascii?Q?bplelazc/cyYUFXw/iAcMjl7ZOlELoelOI53q3cKxEPpiZ61D82At0LERErM?=
 =?us-ascii?Q?d7qGcOueE0yC+qCDf7MlfwrzsO6FDTg7ux/AnvBX+B0wITUa3YrsT3IIF7aW?=
 =?us-ascii?Q?WfeMTl9CoF6NwTBvg7cN/6ZE50QFeFIolGJWDIjJ4ENzLJzlZ9VMdDy3WIcx?=
 =?us-ascii?Q?khXhvYqk9524rRAF1d8wOKIxbphWn1kSjGWE/6S1/1ZYDnniL4Janf3vLcpg?=
 =?us-ascii?Q?3EoLHbYJVmAO5PuxsO6tsZwbKaj9bKeO3VSYlUOhxmHRmcSj49c5KQMdHvrZ?=
 =?us-ascii?Q?QS7FbZdlWA0MlOzK0pCFQtu97XxOQf1lrmdjh2b173s+W8gbawgxH/ULs+21?=
 =?us-ascii?Q?Fvs5VPhzV6eKn2AvXl2EkU3a+ocASlxxoABSk5jqKrmicT/+du5ejgFoEs6p?=
 =?us-ascii?Q?egBAj2478QckqHk8Z7crfCc9siF/yyMyYe3CY4US8vd2MzjNavq6d6OduGds?=
 =?us-ascii?Q?4Q2hFfu77W8+CuyL/dHb8V1lFicOblEAalPgAu+rd0aDBc/dTgTjX53M1O7e?=
 =?us-ascii?Q?QWeDFIn/e+SjeGm3wp2klTOFqOq2bisCrYoVaOEiE0WOQNQPy+/6FwVg8mZz?=
 =?us-ascii?Q?bd//QqcgPKvFkKaNnkZVz+C2FFWgbtw0+C0JeBFA0yWo93c06qtWiGoGGAbL?=
 =?us-ascii?Q?0Cw/d6stmIBtcdQdASOANdZjHxHsvbcyKHzZmA1kRVy+g52V/oFZLdLidnzc?=
 =?us-ascii?Q?sdYKCiM9fA9hgDbVGps+p+leWnGEFsyvVK23IgzucYJ4qKfMZ5GpMWG/qPAd?=
 =?us-ascii?Q?ZDbtP7lHIfFOwZMQ8pL7V0KbIukqX9zMl+aieOm8JMn7FDbFo9PkQROwbPm3?=
 =?us-ascii?Q?j0hGFnJed+XHOeBJWQFF0EtY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05efb3d6-35a6-4126-f6f5-08d95b10738d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2021 08:34:06.4619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gksn3A7h6t566cJ7+LsQf59S2u5k2dWc2rUmgB9NCUPO9ff5Cwag23gqLoiI9b+DZw1+/2gkWE8NC6e1bJRmDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2561
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: David Gibson <david@gibson.dropbear.id.au>
> Sent: Friday, August 6, 2021 12:45 PM
> > > > In concept I feel the purpose of DMA endpoint is equivalent to the
> routing
> > > > info in this proposal.
> > >
> > > Maybe?  I'm afraid I never quite managed to understand the role of th=
e
> > > routing info in your proposal.
> > >
> >
> > the IOMMU routes incoming DMA packets to a specific I/O page table,
> > according to RID or RID+PASID carried in the packet. RID or RID+PASID
> > is the routing information (represented by device cookie +PASID in
> > proposed uAPI) and what the iommu driver really cares when activating
> > the I/O page table in the iommu.
>=20
> Ok, so yes, endpoint is roughly equivalent to that.  But my point is
> that the IOMMU layer really only cares about that (device+routing)
> combination, not other aspects of what the device is.  So that's the
> concept we should give a name and put front and center in the API.
>=20

This is how this proposal works, centered around the routing info. the=20
uAPI doesn't care what the device is. It just requires the user to specify=
=20
the user view of routing info (device fd + optional pasid) to tag an IOAS.=
=20
the user view is then converted to the kernel view of routing (rid or=20
rid+pasid) by vfio driver and then passed to iommu fd in the attaching=20
operation. and GET_INFO interface is provided for the user to check=20
whether a device supports multiple IOASes and whether pasid space is=20
delegated to the user. We just need a better name if pasid is considered=20
too pci specific...

But creating an endpoint per ioasid and making it centered in uAPI is not=20
what the IOMMU layer cares about.

Thanks
Kevin
