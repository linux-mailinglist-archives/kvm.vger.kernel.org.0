Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A248342D4DB
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 10:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhJNIcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 04:32:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:44849 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229970AbhJNIb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 04:31:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="214570693"
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="214570693"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 01:29:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="491855190"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 14 Oct 2021 01:29:54 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 01:29:53 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 01:29:53 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 01:29:53 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 01:29:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aO9Npn0Mw6LHybrkYCd2ueMgwDp8q+//I2IGmPETSy6AFSWXN/sKMTyJgRdhnsxo/tlqa/LuhbsN4yEJSO1RcA906SjzAWZ1KhQ7OCMRdsJZeeXZqt1D0V/QkIz7ygQUijG9pMRw17qh9Zz288Te0pd8Brk0eWbtDtX/Vdy/BjOHAXN/PyZLRCPoCSqN8bcuT73XR0CO+NosPmm8oKiGxmpP4j7L/LHDyZ40Lkg8Iq2beTL37JervtgEMf5UYYgQqfT37E94uL6hqRkZ8b/nLuQ275lphVYuAtvkityZJpiG/aU22R8rssSp3ZjyVFokabHXPnzPVggQ08DalebQGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oV6GgHditvzWEdvIUcGlADeveRoMjsycamnFAJu3Pcs=;
 b=C6z/nf5Kb9gXm7krFT4xluA6dtBNit1ZlE5/zn3c6rdNVgyU9KGghFrwUMv5yLUkKtumzALMmSNtwx/6bENiNgoT3d6CiVXQyCQSQkYxVVKygasUCjTwLzXJLvA2HlB+k5sCkyVYA3QeJkNX7762s0tI28lGdVGhQOESZR8YWlCaA7L1pwSFXyV6DdQciz8afBy440Tdrgt1Rqo210/l9HNSeThzYgkQnFdOZeDRetkPAUgcBFYq0055dEYXZZtk/EL1WeD2+UAjTPEYnmDDj0xwUi6HClDDYv/ru83KU925HyZ7t3m1W8T9JbAmx074g/oLaRZQZUxM3nvcLgkArQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oV6GgHditvzWEdvIUcGlADeveRoMjsycamnFAJu3Pcs=;
 b=T/bQuVF1lGi0nwm9Z3UelV7raiJCVk/voSBxMOS+k/VNEZMEN8fFqYlHlwQO5ljfA5Nl9i+ZanCwX8xuhADZ9VpRtHFdRon5WiwPWRYG9OU6wEZ2E8Qa0lvTfR3FATyDZ37Gi4DTcvEV+HCIST6QpI2qb37R/RYChLMA8Jf6Dmc=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5340.namprd11.prod.outlook.com (2603:10b6:408:119::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Thu, 14 Oct
 2021 08:29:51 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 08:29:51 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "hch@lst.de" <hch@lst.de>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "parav@mellanox.com" <parav@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Topic: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Index: AQHXrSGNbNtRgavabUSKJjvt8l12BauwlhaAgAAouwCAACufAIAAgyUAgAAUFACAAAdkgIAAB/8AgAkqbYCAAEeFAIABQYSQgAAuX4CAAME3AIAAWmMAgBS7FgCAAAVnAIAAAHKg
Date:   Thu, 14 Oct 2021 08:29:51 +0000
Message-ID: <BN9PR11MB5433B2DBD259DD716094EB8F8CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210923112716.GE964074@nvidia.com>
 <BN9PR11MB5433BCFCF3B0CB657E9BFE898CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923122220.GL964074@nvidia.com>
 <BN9PR11MB5433D75C09C6FDA01C2B7CF48CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210929123630.GS964074@nvidia.com>
 <BN9PR11MB5433C9B5A0CD0B58163859EC8CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YVWSaU4CHFHnwEA5@myrica> <20210930220446.GF964074@nvidia.com>
 <20211001032816.GC16450@lst.de>
 <BN9PR11MB5433075C677D7E33C20431418CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211014082224.GA30554@lst.de>
In-Reply-To: <20211014082224.GA30554@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 906d099d-f8af-44fa-c863-08d98eeccaed
x-ms-traffictypediagnostic: BN9PR11MB5340:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN9PR11MB53408A770D69916DF4E79CDF8CB89@BN9PR11MB5340.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cjVQOBSm9COz4pf7qkpwwFD0fsvYquWMYgOaZzmUqmmZwBYQPYixe6McP/mk63fiNjqalawOq0+Hggusb2AQttcnvlGQb36nZz9TNrrm9fixZeBQudtaL3dQ5QaU53vr8A/utzXxneHHObtq3bRpbeBslDzR0zUFZub/15QGyqMSp6qlQyHHPrNnloNIaWQPSKGSmIEIWY7iDW62VyQDfoiDds2DXtVcPIWK/s6Fc6SYdGcFBZMMB3kLTDLtuj+T6ApCojCLHjzPkYvoNN0ImuQ0GLN4ko6N2rvcHTiKZUshn0juAiitIDeGMEI+YcNWQMQV5waYKjDRCzWjzA9SQsViuFfaCrah0THaJu4rwAQBZdQfUNc4ZysN7NWPEEH4Ktu1xL0Ag+jL746V75VNg63Eqq7IcGiQQVanlhM/ddpUinwMy+XJ7RPhP2aIvJEJjxjWN/w+Dn4EZTACjbDN31VgM8gr/vjPys3sa8KtQWk9AESwfIrLj0f6sMPJmWMOFfP1U8N+8EhOatvL1l1katpqXH8ObDft4gCoTcSRh1TaQypLyTf7Z9ndvh3r8UGG3tzt69MzFv8Wwv/OzBl3/uovOuJ2FdbKt2Xa2aX5IkvG7JkqLPHPUF+hMxtkO27wovM0Xbp0xHrbf674MV3OMQDoSAOsvleWZbWe4Wmm4vMcEaFTl3O6JmKOP3ALZl03rmjo3rvCO5WtROec3do9+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(71200400001)(38100700002)(86362001)(186003)(6916009)(8936002)(83380400001)(7696005)(66476007)(2906002)(54906003)(64756008)(9686003)(33656002)(6506007)(8676002)(66946007)(82960400001)(4326008)(52536014)(66556008)(55016002)(26005)(76116006)(38070700005)(7416002)(508600001)(122000001)(66446008)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VvzhclQ400OmDSBL9XrfltqHXATqWskCLQ5Tgkx/ESVxJsH3ox+gl3QgkODI?=
 =?us-ascii?Q?TGUiq7anSZfvLu1zy0Pnia2B34rM3IC0PDe+y9w9dLl7VckmfgNiTYsb5b04?=
 =?us-ascii?Q?bK056SRJTblgzhMaGRmfR6gvGjKd59WMuFNdRRPBNPBbgmBZ6cLR5Fb2FBnm?=
 =?us-ascii?Q?EjznOGN6bsOWHDStgPM6w01duBw05nLwoNXauTx5ER5S2QkIe7TPDp482mJP?=
 =?us-ascii?Q?Iy8/vHaqKClDdpufTGFvo6Fpa7scP+5gjflNGNvDP30DOtb+1ffGjEToUrd8?=
 =?us-ascii?Q?vQ/KMeY557HCTUSm/1Fl83AThv3mE/sFz6RG2H+I16dwpCMlzF6RR8/LJ9DO?=
 =?us-ascii?Q?0bBBLR0PO77ztTnbIpXn8lbQsnTxJ5tcHR/4EcnCCVPqk6xErK/nfmO1GxPZ?=
 =?us-ascii?Q?XtMZ4+oOptJOG2onAu/RpAsCnWCUgqKtOJRPQtgtiLf2AUIIQdVzcxCHby+3?=
 =?us-ascii?Q?XL3HCwAufwNV2hmWwAYqu8DGeTm4TMYK2w2kg8OcJBBt7fEx/3wydV1aVlPI?=
 =?us-ascii?Q?K6Lb8NEsVjxr/g5eYiSS1vymY/63zXeqtuO333+f2DMIaPN17vbswbbUmX/p?=
 =?us-ascii?Q?wsAfjr/iOzSaB2aIZ6/IDSIRMtuPxUhUfR/cWPaD2KJBAyp+VJcQDAeRbuTm?=
 =?us-ascii?Q?+qfG7J9OvquGdZ5NXRKhPoO66fhiyIVToDQ8uXdsInDTJkF1Babx0H2kMQTG?=
 =?us-ascii?Q?SGJyXJFLk81xOHPaaijZPf+bLIeMUScyI2LaQqMWwoZAB/2zFju87KoZQh1R?=
 =?us-ascii?Q?iKa6moG6QPL5SjUsPw1Rhk8p6TwcegNex9yWtTaKlQeVXvb7Nor8mYiZXTy2?=
 =?us-ascii?Q?MAnRv8yLf5od2BVGEgZeWSutDyEVivAvQAjJz3S6Z38YireAw89wS9noTjJG?=
 =?us-ascii?Q?gPepO2AAOJw6oZugYPHa2BvuUKqmHPwdE9ceEn9A0Z1gVBRSZH+1GwwEbTIP?=
 =?us-ascii?Q?fL8/BFtY/PXQJIhcYXJVtimd/V4KCfanTxBROfr6nFtMfrlyk9j0JfRUGsZe?=
 =?us-ascii?Q?TalDCJJj29bPdsjGMn/6T8ZuIAgm8p9BUwIyBJov78Mg0iI4O7qI0zPX+Klp?=
 =?us-ascii?Q?/XAPT+tu6v9hvjWqzlGf4OgzP/cIxZroo8ecVZ6Bo0iBEN/ITEM+xrYOuBfq?=
 =?us-ascii?Q?g4IqX75iKRtP6COm8Vk5BGFCgHlykrTKeEtdaVNrehcsrcvX41EJ1J65paY8?=
 =?us-ascii?Q?0jALFf2BPdnA6v/hlO21xnfAeZswBbi8c+iA/W1jAaSeu33f77w4wvI4STIp?=
 =?us-ascii?Q?m6zf5a+DgQljm4hr+MSrOoh0VrmNuKqNUaEX/vvdfKI7vFbxmvX82N1zYQaT?=
 =?us-ascii?Q?xmql/Q9Jp3lDlMKL/S4vGrUD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 906d099d-f8af-44fa-c863-08d98eeccaed
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 08:29:51.6119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PLiML3oSorEk56b8wCtPOh/KaOy51CP6iGzC/KLz0qUAvOTVmBogqTOY68N1xQFnaAekBuQOzV5uaf3KLJK5sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5340
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: hch@lst.de <hch@lst.de>
> Sent: Thursday, October 14, 2021 4:22 PM
>=20
> > > > What I don't really understand is why ARM, with an IOMMU that
> supports
> > > > PTE WB, has devices where dev_is_dma_coherent() =3D=3D false ?
> > >
> > > Because no IOMMU in the world can help that fact that a periphal on t=
he
> > > SOC is not part of the cache coherency protocol.
> >
> > but since DMA goes through IOMMU then isn't IOMMU the one who
> > should decide the final cache coherency? What would be the case
> > if the IOMMU sets WB while the peripheral doesn't want it?
>=20
> No.  And IOMMU deal with address translation, it can't paper over
> a fact that there is no coherency possible.

Does it relate to the ATS story where the device gets translated address
from IOMMU and then directly sends request to memory controller?
In this way if the device is not in cache coherency domain then nothing
can change it.

Then if ATS is disabled, suppose the untranslated request from the
device is translated and forwarded by IOMMU to the memory controller.
In this case IOMMU should be able to join the coherency protocol
even when the originating device itself cannot.

Is above understanding correct?

Thanks
Kevin
