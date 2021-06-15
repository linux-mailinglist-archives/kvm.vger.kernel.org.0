Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC183A74CD
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 05:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhFODQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 23:16:07 -0400
Received: from mga03.intel.com ([134.134.136.65]:60769 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230040AbhFODQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 23:16:06 -0400
IronPort-SDR: /JmLL9sqTLiAhREfHzFN6QwMtdSobY3K8bXYFSG3qMLMC6lb5g9pc7KvFkUu/qiIe+80mo3zzU
 WbZoEDEHaA3g==
X-IronPort-AV: E=McAfee;i="6200,9189,10015"; a="205935808"
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="205935808"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 18:05:36 -0700
IronPort-SDR: a0ir13e/BzJaNciPsna0Ci/RFWDgpE43oyuAxYXsdxZHNDLRUYNkw4XXhYTxz8HrfbiwgOkB87
 1mevmKaqRWRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="450064592"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 14 Jun 2021 18:05:36 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 14 Jun 2021 18:05:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 14 Jun 2021 18:05:35 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Mon, 14 Jun 2021 18:05:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aA0z1pm0uvOwK0ZAS104+S+Wjx/vkf2pOtBgGI+MkZ2vAt98zss1f4mynH/hRq2pGuGYLZ5LJX4tuU7i0QuSoEkcbIUQAhIOil0JJWYIS3sDmF7P6/22VPeecjsigQ11+xbOGXyw14b0rqheeCP6u+E1D1DSp+p+i3tL03CVBKhbU6eYjvfgXaOSKILbs6Y1mdPSltWtvMuN8xD1xVwsAn2rowlHWo33Muy6pq35VJI/wykEnge2CaMyoEL1lU9Vb8RK8XuQLl9RgE6tt6RfLLN8+ckM4Nco1EcLAdhGewK7fkb4GL4gAHYPLOpLJpMUZY3GfFb+n9S7/HZOHBtHcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mjar7nNp6h5GKCSZvrkpGq/+gEcvf8VTCbKnucZutLY=;
 b=KyXwBQa4np9Bf9cXyzdxQF9253N1Qntnvp1QmcUis8z4OkUMTH2FN+8b5oYbQMWge1/7+asNCLKVNxleK0TrGVAajOsXBV7niOqulGK+pRja/BeEnFbwi3Oy92EEZlhBz/TGLuhGn4Jq2fUDCW58rjmzW9CrjL2wAbdkU3OzErH8m68o3gLHybCPKL9TBCOxonIx4OTsMHLxvJb+8OcfVgAW0L19FEDPquAwINgWy//uI1/j7Xm1Vhbg1OilKVuZYOjMPbnqSA7vV1gzLk/qBormYHxOg3Y/Vp2fGpIvC/AtlElL9dOxvw70XzuX1Mj7vvGCx8c0CM1PqyhWDAwwCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mjar7nNp6h5GKCSZvrkpGq/+gEcvf8VTCbKnucZutLY=;
 b=WAc4XjiDcDo0ZUqia/7Iwnmh15//+z/gdXxXAwdXP/UglJ54Xy88yj5V5kSzx021De8U162P/4qPgfImovQTi/kx8KOR9PFVIjYYZfi2Sl3iDkr2ruf08s45VOgpJEOnAc7CTJOp2+OHdJuWRcX50q81hNHWG8VLo/eQ7v78g4w=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB5010.namprd11.prod.outlook.com (2603:10b6:303:93::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Tue, 15 Jun
 2021 01:05:34 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4219.025; Tue, 15 Jun
 2021 01:05:34 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: Plan for /dev/ioasid RFC v2
Thread-Topic: Plan for /dev/ioasid RFC v2
Thread-Index: AddbO/WEUAFl3MPnRsG8exiH8bwEagB7l+uAAACIfoAAAdwYAAADDw6AAAHKgwAAANd4AAAAacwAAAT4QwAAK587AAAR+AnQACzmaQAAbNgBMAADwf4AACz/UeA=
Date:   Tue, 15 Jun 2021 01:05:33 +0000
Message-ID: <MWHPR11MB1886F94BDF1CCBC9AC8253A58C309@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
        <YMCy48Xnt/aphfh3@8bytes.org>   <20210609123919.GA1002214@nvidia.com>
        <YMDC8tOMvw4FtSek@8bytes.org>   <20210609150009.GE1002214@nvidia.com>
        <YMDjfmJKUDSrbZbo@8bytes.org>
        <20210609101532.452851eb.alex.williamson@redhat.com>
        <20210609102722.5abf62e1.alex.williamson@redhat.com>
        <20210609184940.GH1002214@nvidia.com>
        <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
        <BN6PR11MB187579A2F88C77ED2131CEF08C349@BN6PR11MB1875.namprd11.prod.outlook.com>
        <20210611153850.7c402f0b.alex.williamson@redhat.com>
        <MWHPR11MB1886C2A0A8AA3000EBD5F8E18C319@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210613212258.6f2a2dac.alex.williamson@redhat.com>
In-Reply-To: <20210613212258.6f2a2dac.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.143.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1de190a9-deb3-411f-7e7c-08d92f99adc6
x-ms-traffictypediagnostic: CO1PR11MB5010:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB501003C0803B2A1F9AB2C8218C309@CO1PR11MB5010.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ++UU085wHzx89oQmWdrk6QSIzugnfTZPsTfC54NdG/NqA10ByC/L+Ma4/ZWvnn38S2iVVl3Fyco2DPgyWJlMxaCebnfZDDz3R0GsUGzhR9tdVmaLWur9FM6OSCPSW006RggU48Kra6Vs8MjIR7GJmoI6o/a8+HA9P3I6l0xTWxecFL/zYqqfHvqoNlJPZfXV38eaj8PWzPe9rWsFei4RoD+MvBoelReSxurS3OlgErEFcSXleonaXVntsO6597X86JJsTLFUDvJNd69y14N813aKH0isRcDHa8oVgHnUT6p4h+Xxxj1TITpO9CnrWBMbCq7s8bYl2YqD3P9bsCNCqFzi+8hwopVyG9M0eG1Y1duHcCGgLinaIeSRj/1pOvj0eVBsOT6mQNKjzNNHo2QMe2qHAOAvhSupL6/qSanVA8yFBYV06TchJMPAMSnWoC453R+PvbpHOK864cz/KPXyH9/tjtM8brUI4VKffXafbGDD3P9Zs8QAQo7aKuGTg/kP7y28ra91UzA/9Ocnrf7IROICyufBby9K/WJ++ZDBqX46nOLWoGT5uUqyyOM8qVnN67TQDBr4m8HB4AU8uIz7yNvi5MzXuQ+wkUsgoY2S0nM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(136003)(366004)(376002)(5660300002)(478600001)(7416002)(52536014)(4326008)(9686003)(33656002)(8936002)(6916009)(26005)(55016002)(54906003)(71200400001)(6506007)(86362001)(64756008)(186003)(66556008)(66946007)(76116006)(7696005)(8676002)(66446008)(316002)(83380400001)(38100700002)(122000001)(2906002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZD/oSuz0+62Zbm6CRmm6kbcCdexv/MJb8ZnfJ8qF0tYGcfW2Vnmooh6/s1fr?=
 =?us-ascii?Q?rrGSIQFTJmmdRR7tqiaH90BcLex9hTZpgh26+k2pqWKjWv8kspu14PRNdKaP?=
 =?us-ascii?Q?s/xOj89Ntwl0uDDCT1VVDXQj1P+lVrcjraWz/Bsc+45KjDG1kFSKbqbu/2Lq?=
 =?us-ascii?Q?17Vtcc0h0NiqEWxwCnVaHpstWw0gLUWmPWYu5a0AmWysVKwPdCiSHAwbsLli?=
 =?us-ascii?Q?eEkZeq3evH3/HuQ1IiCGsuMi5M3RDdNCNG+sdK4x5O8PUFhWr3cjZCP3+onI?=
 =?us-ascii?Q?FK4LLt4Ll1L4AN2ydfulMuneWQiLPq6Ub/oGjqq2tIUB1Toe3G9zE7t5/Cun?=
 =?us-ascii?Q?BgYoG4m+6buTFZPieCG+ks5zbJPYrGRtfB4Ldb8zTCmm7B/84lblEmaGWZG2?=
 =?us-ascii?Q?DSDtdYEBb9c1zT8dS3Zfrp5QM/KRPZLyHNQ+511iJOyobD57+IYkUdhchnFk?=
 =?us-ascii?Q?iA7BkcbfXNFJWYq9aYz1lZEaCfWnquCYXiDpn+R7mDvmAse/ZtajLWomhX+J?=
 =?us-ascii?Q?RBquKYauoW9JCP5qkLXo04yIBXAf6Yca4SNcKUMfKT39NCiDr2sVGA1zWsRP?=
 =?us-ascii?Q?bH2ZfbWUAn3YkNYqNw1q23fkEEn9P5wvCCQs+qklY5fwg2kao7djLbwkU67I?=
 =?us-ascii?Q?8GgoY4nky9gHWKCrJTsha2ps5vqdSvnVIVsTpEzAONobngHo9oLEyvHANE7K?=
 =?us-ascii?Q?qUtGBGFPBxP5KT13y/rlJyMsdCE2MaXoWictesAvl3SxbzqJ3O98RWohpOqD?=
 =?us-ascii?Q?NwG1McmXlWDfvnQoyY2FqkEEETxM6N1mKkikJfMxD9GWrOk042toO25dBZQa?=
 =?us-ascii?Q?MoX1BYtdY94fAwDPNsWq1SgkBNgXc7Y8t2n6zSkD37LITjINDGOWY5H710UV?=
 =?us-ascii?Q?nxnC5W1AivmF2XrN1bewG0FrDVmGf+M/wCj45lHbyzY9TzzChCIK38wqu1nU?=
 =?us-ascii?Q?1VYw3MAlezWyZpI28kPxpQprqOUfwIT2kmInH01gHJIhaqBv8lj4g+vhDZVo?=
 =?us-ascii?Q?9QKkBdDtYo4plqLFKf10PnYGNgmrxMau5FUYSynojgle04XCigIiV5Xsobem?=
 =?us-ascii?Q?7KYmjmor6DYxfpGfAa3iu3oml41yQdM3fyg16GUpHy5603XYVpYCkoeeom/R?=
 =?us-ascii?Q?GMNYlAy7/WrUE8wkh1u04eJNhHkVG1hguX71f32d1o4asjcAgbJIyEhe/MZV?=
 =?us-ascii?Q?JywbHkptR4sAuuAbxGRqOM69/ciXXJBdD7GQ294vYa2pGZk0DsXO7tchwNBr?=
 =?us-ascii?Q?ocLCNY7LnkfmLrh1w8CAo9NiswY/RHAn6ECxLmC2aBtz5SQd3iNShSE2G3IE?=
 =?us-ascii?Q?nBOj5TtoB4Vnj25W4Xb2jPfm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de190a9-deb3-411f-7e7c-08d92f99adc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2021 01:05:34.0534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3oFKSb4ro8Ww9f/sXleiwVn2nLuQwbEtGPtqwLu/aq0eSRyQH1d0+CZ6ELQmHFCVfYPeUoS9q0+yRckMlal5Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5010
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Monday, June 14, 2021 11:23 AM
>=20
[...]
> > In the meantime, I'm thinking about another way whether group
> > security can be enforced in the iommu layer to relax the uAPI design.
> > If a device can be always blocked from accessing memory in the
> > IOMMU before it's bound to a driver or more specifically before
> > the driver moves it to a new security context, then there is no need
> > for VFIO to track whether IOASIDfd has taken over ownership of
> > the DMA context for all devices within a group.
>=20
> But we know we don't have IOMMU level isolation between devices in the
> same group, so I don't see how this helps us.
>=20
> > But as you said this cannot be achieved via existing default domain
> > approach. So far a device is always attached to a domain:
> >
> > - DOMAIN_IDENTITY: a default domain without DMA protection
> > - DOMAIN_DMA: a default domain with DMA protection via DMA
> >   API and iommu core
> > - DOMAIN_UNMANAGED: a driver-created domain which is not
> >    managed by iommu core.
> >
> > The special sequence in current vfio group design is to mitigate
> > the 1st case, i.e. if a device is left in passthrough mode before
> > bound to VFIO it's definitely insecure to allow user to access it.
> > Then the sequence ensures that the user access is granted on it
> > only after all devices within a group switch to a security context.
> >
> > Now if the new proposed scheme can be supported, a device
> > is always in a security context (block-dma) before it's switched
> > to a new security context and existing domain types should be
> > applied only in the new context when the device starts to do
> > DMAs. For VFIO case this switch happens explicitly when attaching
> > the device to an IOASID. For kernel driver it's implicit e.g. could
> > happen when the 1st DMA API call is received.
> >
> > If this works I didn't see the need for vfio to keep the sequence.
> > VFIO still keeps group fd to claim ownership of all devices in a
> > group. Once it's done, vfio doesn't need to track the device attach
> > status and user access can be always granted regardless of
> > how the attach status changes. Moving a device from IOASID1
> > to IOASID2 involves detaching from IOASID1 (back to blocked
> > dma context) and then reattaching to IOASID2 (switch to a
> > new security context).
> >
> > Following this direction even IOASIDfd doesn't need to verify
> > the group attach upon such guarantee from the iommu layer.
> > The devices within a group can be in different security contexts,
> > e.g. with some devices attached to GPA IOASID while others not
> > attached. In this way vfio userspace could choose to not attach
> > every device of a group to sustain the current semantics.
>=20
> It seems like this entirely misses the point of groups with multiple
> devices.  If we had IOMMU level isolation between all devices, we'd
> never have multi-device groups.  Thanks,
>=20

If multiple devices in a group are all in a block-DMA state when the
group is attached to vfio, why does vfio need to know whether they
have all been switched to a new security context via IOASIDfd before
it grants user access to a device in a group? Yes, there is no isolation
between devices within a group, but from iommu p.o.v they are all
blocked from touching the rest of the system thus having user access
them won't cause any security problem. Then it's just user's call about=20
how it tolerates lacking of isolation within that group:

1) User could attach all devices in the group to a single IOASID;
2) User could attach some devices in the group to a single IOASID,
     leaving other devices still in block-DMA state;
3) User could attach some devices in the group to IOASID1 and others
     to IOASID2, e.g. when the group is created due to !ACS and the two
     address spaces are carefully tweaked to not cause undesired p2p
     traffic;

In any point in above use cases, the devices within a group are always
in a security context which isolates them from the rest of the system
(though no isolation in-between).

Thanks
Kevin
