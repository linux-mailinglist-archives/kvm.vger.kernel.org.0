Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455A74569D1
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 06:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhKSFrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 00:47:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:58992 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229646AbhKSFrj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 00:47:39 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="258151106"
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="258151106"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 21:44:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="537004699"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga001.jf.intel.com with ESMTP; 18 Nov 2021 21:44:37 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 18 Nov 2021 21:44:37 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 18 Nov 2021 21:44:37 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 18 Nov 2021 21:44:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvr5HXJlaTWnkEU1VP0QTKr1VwfLbmhV2zDj1mPX04G/Ag/E+bF7Jays505Uo2aXqNgv2/IFYszIqjcetCFz1qr28K0c7+UZ39CJn47TYLAFmOPdAEFxH4tbqhjEKJx7rI2MwwXvbQ2CTO1Og7sJXdANeKhvb0MUuJrytXAGjxG9qrIuWPUtQBIzrTsl2dyZExxnq0J56+1TTEd2Y2LdVzAld+tEUW529ih604TgBUtpUu/yTKt8uMT+c6SQ4mAWrKeSTgE0mrTkDUNlGmgsDq069u6br+G1RKxpvtVkKQ5WD9Hx4k+cDvPMymOfd2x8IeWve75BWn+/bi88gRcKZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y4LjgUejy0p38kAebtS/6N1uJJoLDu3MfF6X6fIxNFc=;
 b=YYQ0C1lf0YTw2q1zxof1lJiTZtBZmr26ZPrLoW9xqgrfXR4mhrWtbGdMTS0JQwyQPM8wSjib7QaXVLEs6OgNApu7EEhiev5409LNSogCRQC1EP7xVtvEPc61j9CgIievVQsvhCmnXJtl9HQpfPjGhW3+v7zW624fmIaz9NK75Z4GK0JF/CyD/RHYQ/TN5ZgbXG1IGlA/9b7/QkrxgkjpkypPBG5Rqca6TwI8fwvefq3YD462+HgD/xnZsH4aaVyzZlmKD5yqFw7gwtUh7Fx6I6rkBnTDFh6uklHyPLo17FTuKoZ6F1sRiBb+8JEgQH5XZkFDswS0LHAtOkO9e+fJ2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4LjgUejy0p38kAebtS/6N1uJJoLDu3MfF6X6fIxNFc=;
 b=MhmVpbohXhyPIV656p66d5sHnq9xJwP06A0NIk+MzyL40KZ5AScpQ/GfKbuymgnPTGnTJ+Qppz/W0B9oUEaU6QUAWzG7qaNtkwmbGPa5mZlQq11eHBmLcukIEmdpsPS7fBZheiq0hJYU2ML+GUjkWlxbuKpW2mfgbIhTHrZxcpU=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5338.namprd11.prod.outlook.com (2603:10b6:408:137::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Fri, 19 Nov
 2021 05:44:35 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81%9]) with mapi id 15.20.4690.027; Fri, 19 Nov 2021
 05:44:35 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Joerg Roedel" <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        "Will Deacon" <will@kernel.org>
Subject: RE: [PATCH 01/11] iommu: Add device dma ownership set/release
 interfaces
Thread-Topic: [PATCH 01/11] iommu: Add device dma ownership set/release
 interfaces
Thread-Index: AQHX2cX72SW3lNH8302ZqE4v8PTHlawEkdAAgADVRACAAMX3gIACZvYQgAC6LICAAQu4sA==
Date:   Fri, 19 Nov 2021 05:44:35 +0000
Message-ID: <BN9PR11MB5433E5B63E575E2232DFBBE48C9C9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-2-baolu.lu@linux.intel.com>
 <YZJdJH4AS+vm0j06@infradead.org>
 <cc7ce6f4-b1ec-49ef-e245-ab6c330154c2@linux.intel.com>
 <20211116134603.GA2105516@nvidia.com>
 <BN9PR11MB5433639E43C37C5D2462BD718C9B9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211118133325.GO2105516@nvidia.com>
In-Reply-To: <20211118133325.GO2105516@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 138a110b-8d55-494e-daf1-08d9ab1fab0a
x-ms-traffictypediagnostic: BN9PR11MB5338:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN9PR11MB53380E113C061E79EA0ECDC38C9C9@BN9PR11MB5338.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VBfYxOAs0w8vlKjwacxwA8RSHPjFko/aNRiJdMGjjHg9zGREiYsFUpXcESavcQSoT1RvApe34fexSC4ZgxcO0/s9eEB7l1MoZR2huE7zLb8c63qRuNDXN9lr3MHxIjRdn7ZcCWAAZnFIDy2zidkPVwgl+pQusYQZfrWBU4lw57pqjWfyuQLKKMHfeweRNY3LvJH0Quex7ujjR3M76e37mZRtyoPMkl2GGmzb6NS468MPSDRSJumyHXc5drW+gNqezi+jo8N7INKtN5tThqF7gaP1cJ5lSZniVUtHays6fdz6Cw3Gbupj0deEwfEhjV2nBLpGJTlNbn8Sh1Jnaj3J0X4nf9+QzAonDjhdga8Vt0RrkrZXAM5egEPhavPuWhsDMFi+2NSMxET+IeAeXusxvscNEDRjRwalxRz0vvZmdCzC2dsEcRltLdSOo7iDj5tHmBwRF73psGVo7WjbKH+HSUrLEexkgVSFvwXCI/iDMG3MyqsR9jHnZvXOD8e2ozaEk9fzqWv8FegOqDrmDP9qDlCOvdAsw6ynYTsRcm9JCO0U7kaCa0i5uD5HOGxLpsAJ7iV4mvaRXzTA7hj6/oPEnTisJQzSlPtjWYlObOZpctBRDWICpzt/BuILAN+8K20cyjeL8YA5D9pFluTOzNitJ+NnmbWEiRl8i1Of00UF2RFe6n57vGRO63hc8Ox5rZIvn+BiZMBy+NGJTzoMS0/CUQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(316002)(8676002)(9686003)(7696005)(54906003)(4326008)(6916009)(66446008)(38100700002)(122000001)(7416002)(71200400001)(2906002)(55016002)(64756008)(66556008)(8936002)(52536014)(38070700005)(26005)(66946007)(82960400001)(5660300002)(33656002)(186003)(508600001)(86362001)(66476007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4XhPW5y7zKvWtaaM4WzsExRHz3Iq3b2DPpDNqEWG650nAisLywqa3Oflwo9N?=
 =?us-ascii?Q?TLJx9+9HLLE9LjxZNjybZUZ0cPh2m3EHtxqjOu3XaisQaOxFaOpZQ6Rz3abc?=
 =?us-ascii?Q?lJ4AF5SYHcQKFATStkwaBcmhWs3xn1Flgi7yiMVpTrH/f58GFtmSMRo1h6Nw?=
 =?us-ascii?Q?T0P7wBYbdnxg9bD/Eo1RRw7blzNQ6cxZKgZaXvUI2HQgyf9qYDF6U5BAfOwY?=
 =?us-ascii?Q?3RlGFVh1w5PmK/9do9eScow8jgdNBjBMNeMLVdUqC0/g0y6MiAihvxwaalbV?=
 =?us-ascii?Q?tu9VaR48HIsyR8BhMHvep4igJban7+5NAAnJHM/VACrbmnS04bcqvw+y61xp?=
 =?us-ascii?Q?KQj06YK6uooCCjvmiWQsJWhjMF1LSokqxN2M3G3fy3G9SCfytYl3feRQMNTk?=
 =?us-ascii?Q?RAddH8aCmLdcRs3bidnwvEmzj2b1/xFgG6fCHIzxtX1eMJFvzUy9imEmvwFS?=
 =?us-ascii?Q?Ws0TlokRzKt3kdbJdkk5IqzQmVPFxc+pwbW5WtzNI6nlB7xIb+TPxpjzVIiv?=
 =?us-ascii?Q?QI7x5EoDqasokPJeH76aFmTKgIr1xpvvyyDnuB4ls6R+RZXwN+S7wuDp7IOF?=
 =?us-ascii?Q?aOCrzlnWqdB7GY0mqHqcwbfzYDkHnCsbkRTQsjHATqBwqoHLcCO8gwAWWb1l?=
 =?us-ascii?Q?DS36sAUqDUDSvdb4qjCUWkKFcGgPh++6ZOXpqx4pYqVDo5RtYk+nWkZtHpV7?=
 =?us-ascii?Q?HCJ3a5+2KeRJI0z8s8FcUPOiaAMT/vq5xZ/VH2rbd/YR3ymE3CNpdd0et/6/?=
 =?us-ascii?Q?6x/OKE+wqySm81SLVvaP5PbPxWUKHD5RTKNEBXRRvgGho1SwWs2N7hDNF1vO?=
 =?us-ascii?Q?ide52cq7PLxAkHQUEYdTymV2s8RYt9I5c+9ELu6CxivNhdMeA8HttEnZk5Eq?=
 =?us-ascii?Q?ADq4d0NL/kPUF96D58qG3Uq3iTG+P0NL/W/snYdTn0ixuKHEVlhrTzWot1qh?=
 =?us-ascii?Q?0BE/4RSR8xOOKvmwf+UmI/B2P+hiSNLXxH85O6OIKzwWIgl/efnbI6kiWo8y?=
 =?us-ascii?Q?P9I8qRwhLlZ9qIvzzGtIGOUkcdYeRi6Uo2WfV7lSkln8dYTshV1guL7Y3ZJu?=
 =?us-ascii?Q?6yD4LhXYtLie+AV/URfRFDzFNxU1aUWInKHbQU0CWeBhUN9dBX7UGNbp22I0?=
 =?us-ascii?Q?awHcDApBF8FU80pEPK63P/AAochzDIviZVHgF0F3086GzNmjXPfEYTunHaLI?=
 =?us-ascii?Q?Pg5/tVTCw9JJ7VsvRVUT3hxg/962e9OCbW00yW9f503xJCLkf52OEuYuD0CW?=
 =?us-ascii?Q?0zImzR9hRPvZH3exVvHhrQ3vC2UJoOuIcmEbmz8Z7gRPyYOXq5jaUY8HOVI3?=
 =?us-ascii?Q?pd30mcC9ZJ7r5ORJz9dED0t5aG80EbDrbH1zDpA8TvRcFzvJ1Q3c4huTs593?=
 =?us-ascii?Q?lpb6KTJGxa6Y6JTuFOEOT9DkH5s8droSci9mz1UQk5zimRr9iltBIJj8FmYM?=
 =?us-ascii?Q?pNd98mGo4Em8JUf4HrzuWjoTKLoP6hITN8suYmya/X2f/JTLuyarZqLxVrT6?=
 =?us-ascii?Q?CmLb7P1e9TrT1fq/ZDVnS/VBrMEN9j8LadDrjmqswKbLd6f6orUx/+ivMaSh?=
 =?us-ascii?Q?dgGLNpKdhYuLRXOgaIDRrKAabi2LoXpWekyYmpIZQIbzielhnh6zSSbX00Qf?=
 =?us-ascii?Q?HA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 138a110b-8d55-494e-daf1-08d9ab1fab0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2021 05:44:35.0920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U0IZm3EJ6GW/suwo3q626mdBHLM/ErBD+6Z3Mmn2Zz+CrRMluN1toK+jIcZKwgdHvgKzVh/WSYCA2QW9RLLlJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5338
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, November 18, 2021 9:33 PM
>=20
> > In concept a singleton group is different from a
> > multi-devices group which has only one device bound to driver...
>=20
> Really? Why? I don't see it that way..
>=20
> A singleton group is just a multi-device group that hasn't been
> hotplugged yet.
>=20
> We don't seem to have the concept of a "true" singleton group which is
> permanently single due to HW features.
>=20
> > This series aims to avoid conflict having both user and kernel drivers
> > mixed in a multi-devices group.

Well, the difference is just in literal. I don't know the background
why the existing iommu_attach_device() users want to do it this
way. But given the condition in iommu_attach_device() it could
in theory imply some unknown hardware-level side effect which=20
may break the desired functionality once the group size grows=20
beyond singleton. Is it a real case? I don't know...

You are now redefining that condition from singleton group to
multi-devices group with single driver bound. As long as no object
from existing driver users, I'm fine with it. But still want to raise
awareness as it does change the existing semantics (though might
be considered as an imperfect way).

Thanks
Kevin

