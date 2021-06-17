Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DD43AAD9A
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 09:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhFQHdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 03:33:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:4781 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229901AbhFQHdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 03:33:15 -0400
IronPort-SDR: R566SddYggMg8jYD7x/Rrt8LktSSwke13VqQMvHMNw3iEaJ3JXNPHqKFTZEFvfcZgP8+48zxJc
 tg9U4+igyavA==
X-IronPort-AV: E=McAfee;i="6200,9189,10017"; a="227830210"
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="scan'208";a="227830210"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 00:31:08 -0700
IronPort-SDR: esUD+VqgwGdBgQ1cyFgl+9nPcpd0DTKJzg4Q+zP8cJS9O1sBsM4tRFuu6XZyed6ImloKCU1yxV
 qio1TFdkqSxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="scan'208";a="554318385"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga004.jf.intel.com with ESMTP; 17 Jun 2021 00:31:07 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 17 Jun 2021 00:31:07 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 17 Jun 2021 00:31:06 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Thu, 17 Jun 2021 00:31:06 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 17 Jun 2021 00:31:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4nsTNRv2anzJTxtFNTrWrqu/8R/RtRvoIib6K+5cYvFT6Gx3o3hlUVMwKrxXIvDN2w/1hKNmBeutjQWMz+xMf8fWv1jEBEE/yRqzuMXovI7K2YHWy3C/RzBYOfXWUozdq+TSYW+D7SfPQBLlgPrgDn6c62RT1N8G9Mp56YF/OWffjf26LB+VeAjtdAtVsJwNio0//5hN7k0ft8nmHoqO1dTb3Akz8YPYAzgmTcV3SI6FL7WShG+ze8FzunNqEp10slVY7F5DHxMDvFAbAXkXpQcEhvtmynnbvWgeeViJX/fOTcST8FMiAOyNsqIQyP6Rih7r1X0rm1umpd9yBfolA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZpuCOlzs+q6BqBHKTJn3cT01jo+x9EV+ziSafLWy5Q=;
 b=h6DW9x8uLXBe9YSk0Tja7wDc7ZaAvY9oJ59BLgUPH1jp9uY7UP4zfHgATd7/mkbScSKdwEX/Vt1u74tneHzOMt9WXziGOweTGfbsEU/VzLSwmJgF5r4mthrAv/Og4xSOmf5CgDzUGGdzmUcmCPjOz7Pn2/RkwTuykNKq6IfWNl33W9sfIEmnDBpiMMl/OEQroevX1bWKzaZ9LBMxlqskJvc4gNzOoJ+Emn3U2v6lmWrghjzQxuGIiGj49l6hI4wus+pgIJQXk8IscofWC+eftRqI2G4tmCe47JgNwesuYFyjFWh5nkjvpvwoBTV1uVWYoh9tfEK2gl4j+ZJS4ZpAyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZpuCOlzs+q6BqBHKTJn3cT01jo+x9EV+ziSafLWy5Q=;
 b=pPJMGsOFP5cHHb51Tf0Mhk3sxqwAXoTMAdmZQ+u/WSIn2W7DSO7c8fWEhUObuFjh5+CrkYecV2VOOxHplLMzyzuPcgEtPsGR6jAtgFyq1A5pD1Ny7CBoL28KYE48MzTm3PgjpqaaaQMZY1C5dyDmbJy6x3SQFyCPmGQtN1I7wjY=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1840.namprd11.prod.outlook.com (2603:10b6:300:112::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Thu, 17 Jun
 2021 07:31:03 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4219.026; Thu, 17 Jun
 2021 07:31:03 +0000
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
Thread-Index: AddbO/WEUAFl3MPnRsG8exiH8bwEagB7l+uAAACIfoAAAdwYAAADDw6AAAHKgwAAANd4AAAAacwAAAT4QwAAK587AAA0n7GAAAYKlwAADDvuAAAgbLGAAF6lSYAABO0WAAATSRtQAB5ymYAAEyKHQAAmZhSAAAo/ocA=
Date:   Thu, 17 Jun 2021 07:31:03 +0000
Message-ID: <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210609150009.GE1002214@nvidia.com>
        <YMDjfmJKUDSrbZbo@8bytes.org>
        <20210609101532.452851eb.alex.williamson@redhat.com>
        <20210609102722.5abf62e1.alex.williamson@redhat.com>
        <20210609184940.GH1002214@nvidia.com>
        <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
        <20210611164529.GR1002214@nvidia.com>
        <20210611133828.6c6e8b29.alex.williamson@redhat.com>
        <20210612012846.GC1002214@nvidia.com>
        <20210612105711.7ac68c83.alex.williamson@redhat.com>
        <20210614140711.GI1002214@nvidia.com>
        <20210614102814.43ada8df.alex.williamson@redhat.com>
        <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210615101215.4ba67c86.alex.williamson@redhat.com>
        <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
In-Reply-To: <20210616133937.59050e1a.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d36f561-1507-413a-20cd-08d93161dcef
x-ms-traffictypediagnostic: MWHPR11MB1840:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1840C1D2EF95C76D98126F408C0E9@MWHPR11MB1840.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w48BmbGoGgo06cY9/piJvVGn1p8RKQKccC3/yXFLozrbOEoyUUXEwLL+LUhN6JfE36+13ZkhoyU4vH72PXU9a6L+KBJ6OIOJ7j+GixCKoDcCsramp8rj9oD0OJUUl62X2kymMjMPJR4/lENb7jDTiOR2KENKmlrZ//EJo9/VhWHfzcty9DRiz+eQXWuQHMvl2R2lOq7pCVkDk76VTvoFql8RKqAgyQZVhCV+sAH/vFfUkd4vAmCdgCrP/AOfxpNH97tjP2FcLVagZDQmZ02KkHruVKHfYpO9jqauyiAP5TjYlnbyxq4z8gfdcOs2S/LtAqKIaW/AkEX+unDqy7OflNG7GiOiZiL3+29eQfCg2eEt+lA+UrQgsH0ls0LKw7YZXVGcNUQS2ePwYcZCHcyQjrWbk9OmX1Xpgxqs4Lzebx6waajnsStzvGSlvMAGwctVFdfWgDcO6yvx3+vLE/t0e+9FduKlIc44xbq+EUhBcv+3wQFEvCEfl0Qtr/IwGfcMPa7w4yk9h21rV1j5b7mttfgVmBfT38qlaY5ELP18pehNUJKDetSlpXL8L3uWC2SOCvfd67V3uz32hjr/Qr1SjvrB611HTlCeP6cL4KYT4YI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39860400002)(136003)(366004)(6916009)(76116006)(64756008)(66556008)(7416002)(5660300002)(6506007)(66946007)(71200400001)(26005)(66476007)(4326008)(186003)(122000001)(30864003)(38100700002)(316002)(2906002)(52536014)(33656002)(86362001)(66446008)(55016002)(9686003)(54906003)(8936002)(8676002)(7696005)(478600001)(83380400001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Yz9ErM2qFjaLVgZp25Mx2mz9tiXFpXLLlHJY8+b39nCe0S2S4zh8wTw8SQ8N?=
 =?us-ascii?Q?D/sxRE53yjC4i5jlSI20bsELLq1okfn+dTx4OrN4MPACBBXUEbbESyEM44+8?=
 =?us-ascii?Q?OJqgBJEckCxotObKa1ty041kSTa5QCtVUqj50joRGFitvsl/0Ml4EwW5Yz0y?=
 =?us-ascii?Q?5ag3Ssw6QU4ZEcrFS70MDXr/baZOajKAKyxQ6oHo8MKgKNY181ygT3giBCOD?=
 =?us-ascii?Q?ti/FqOV1gYIAaRoJXpLYYWmWI677Vs9rMTDDC1fHrXXpTCcCMk+G0lO5hYS9?=
 =?us-ascii?Q?Izo0esuN5w57ObLYK8Zd8jTsguK5HahTpyslYCFB/YZYpuYqbcVD5d65Np3F?=
 =?us-ascii?Q?O11Rtau9hbzCOfHoDEG7xzjGb1P2vXZl9TFvpy5i51Dv+RMXyrjHUJPBv6yB?=
 =?us-ascii?Q?WiA0bK9WiFOcF397Ugwo+d9Mg/6BTMpKAaalu6bBrWs7Ey70UIVQJRsZbiRz?=
 =?us-ascii?Q?gGamks/d+Uj1/7hgdzLZMFi8eVHofQi794rHR8rnntlfW7LUc3ar0dVnciQQ?=
 =?us-ascii?Q?hdK18/7qxES26xdW39/TsNGIi/1TBbhItUr4hPB9JNJHEv5J/eHiPC0iOyan?=
 =?us-ascii?Q?m4O+MjfsAWRCXJUq18x53EryTxZu5mcG7QqvctjwAe1Q/o514nX+aN+H+SXS?=
 =?us-ascii?Q?2YRm/IuJ65mkdGtEgMlfdE0aMADirBTwENrL2Zu34nczgVABO4FQqRn6Zjzy?=
 =?us-ascii?Q?+JX7CS2Xz0n8TfU9RVdqceoFIj2ELG/Mu0eGeZ3Kwcgur5L0ZorA4htQsNXr?=
 =?us-ascii?Q?w6uepql2w0ucA7dd21QvgdgdAMDxnuAuJCgvWNtb2mwabIQu9neIA1D32O/S?=
 =?us-ascii?Q?/lKLUnGMDZe5Sm5RowGpp8RYnQgyEG0EMOG6S5SR8mptHzap84edNx1fn+ET?=
 =?us-ascii?Q?fkF+qYD1KW2e8WTkmA+/rnyq/ubRex3BcGsKdpvOu0nFL5zFus6It3tQClmY?=
 =?us-ascii?Q?LbSM3CAthPC8wgtLFh5fD3ftPDQjvZ2EjE6cfmzdKWXlQGHToZNZNa48wlpP?=
 =?us-ascii?Q?TRx39CrR6FAdRIZd5EbaS98H6DrZscq1xpxGoGzdXWv+SvstXddEjKGCM9BO?=
 =?us-ascii?Q?PE4blnvFW4b3fkZMjxfKoK3KfXXKJCTWmtVyuFN2X+VpvTUHnS7x0iiKl267?=
 =?us-ascii?Q?MfkiJQthIiDOatpnwDzj1aChAnPRLZea+hvPty8vumn4vw+uzpLOXNMMiPHx?=
 =?us-ascii?Q?Cz5UDpHxnACGObqPgLRBdxCXcvsacANLQjBhOQ9E0BN79jkpJjYnAVZgOHOh?=
 =?us-ascii?Q?1a8rqiTEdpol+Jh5lHrA4U2WpUCVwHHu2nJEcLLxAAgxjJPYVud7o15Mq/Lj?=
 =?us-ascii?Q?h/RyQ8cwTI5uUBFnt2jFJkI3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d36f561-1507-413a-20cd-08d93161dcef
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2021 07:31:03.7213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y3+A5rDLTW42UmhONTBnZgIIGvSedg/pQro/ml3lv4czxb06N5BEYmy3o8D2UmmovV66ZPrmiRycV+KhlLyCWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1840
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, June 17, 2021 3:40 AM
>=20
> On Wed, 16 Jun 2021 06:43:23 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Wednesday, June 16, 2021 12:12 AM
> > >
> > > On Tue, 15 Jun 2021 02:31:39 +0000
> > > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > >
> > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > Sent: Tuesday, June 15, 2021 12:28 AM
> > > > >
> > > > [...]
> > > > > > IOASID. Today the group fd requires an IOASID before it hands o=
ut a
> > > > > > device_fd. With iommu_fd the device_fd will not allow IOCTLs un=
til
> it
> > > > > > has a blocked DMA IOASID and is successefully joined to an
> iommu_fd.
> > > > >
> > > > > Which is the root of my concern.  Who owns ioctls to the device f=
d?
> > > > > It's my understanding this is a vfio provided file descriptor and=
 it's
> > > > > therefore vfio's responsibility.  A device-level IOASID interface
> > > > > therefore requires that vfio manage the group aspect of device ac=
cess.
> > > > > AFAICT, that means that device access can therefore only begin wh=
en
> all
> > > > > devices for a given group are attached to the IOASID and must hal=
t for
> > > > > all devices in the group if any device is ever detached from an I=
OASID,
> > > > > even temporarily.  That suggests a lot more oversight of the IOAS=
IDs
> by
> > > > > vfio than I'd prefer.
> > > > >
> > > >
> > > > This is possibly the point that is worthy of more clarification and
> > > > alignment, as it sounds like the root of controversy here.
> > > >
> > > > I feel the goal of vfio group management is more about ownership, i=
.e.
> > > > all devices within a group must be assigned to a single user. Follo=
wing
> > > > the three rules defined by Jason, what we really care is whether a =
group
> > > > of devices can be isolated from the rest of the world, i.e. no acce=
ss to
> > > > memory/device outside of its security context and no access to its
> > > > security context from devices outside of this group. This can be
> achieved
> > > > as long as every device in the group is either in block-DMA state w=
hen
> > > > it's not attached to any security context or attached to an IOASID
> context
> > > > in IOMMU fd.
> > > >
> > > > As long as group-level isolation is satisfied, how devices within a=
 group
> > > > are further managed is decided by the user (unattached, all attache=
d to
> > > > same IOASID, attached to different IOASIDs) as long as the user
> > > > understands the implication of lacking of isolation within the grou=
p.
> This
> > > > is what a device-centric model comes to play. Misconfiguration just
> hurts
> > > > the user itself.
> > > >
> > > > If this rationale can be agreed, then I didn't see the point of hav=
ing VFIO
> > > > to mandate all devices in the group must be attached/detached in
> > > > lockstep.
> > >
> > > In theory this sounds great, but there are still too many assumptions
> > > and too much hand waving about where isolation occurs for me to feel
> > > like I really have the complete picture.  So let's walk through some
> > > examples.  Please fill in and correct where I'm wrong.
> >
> > Thanks for putting these examples. They are helpful for clearing the
> > whole picture.
> >
> > Before filling in let's first align on what is the key difference betwe=
en
> > current VFIO model and this new proposal. With this comparison we'll
> > know which of following questions are answered with existing VFIO
> > mechanism and which are handled differently.
> >
> > With Yi's help we figured out the current mechanism:
> >
> > 1) vfio_group_viable. The code comment explains the intention clearly:
> >
> > --
> > * A vfio group is viable for use by userspace if all devices are in
> >  * one of the following states:
> >  *  - driver-less
> >  *  - bound to a vfio driver
> >  *  - bound to an otherwise allowed driver
> >  *  - a PCI interconnect device
> > --
> >
> > Note this check is not related to an IOMMU security context.
>=20
> Because this is a pre-requisite for imposing that IOMMU security
> context.
>=20
> > 2) vfio_iommu_group_notifier. When an IOMMU_GROUP_NOTIFY_
> > BOUND_DRIVER event is notified, vfio_group_viable is re-evaluated.
> > If the affected group was previously viable but now becomes not
> > viable, BUG_ON() as it implies that this device is bound to a non-vfio
> > driver which breaks the group isolation.
>=20
> This notifier action is conditional on there being users of devices
> within a secure group IOMMU context.
>=20
> > 3) vfio_group_get_device_fd. User can acquire a device fd only after
> > 	a) the group is viable;
> > 	b) the group is attached to a container;
> > 	c) iommu is set on the container (implying a security context
> > 	    established);
>=20
> The order is actually b) a) c) but arguably b) is a no-op until:
>=20
>     d) a device fd is provided to the user
>=20
> > The new device-centric proposal suggests:
> >
> > 1) vfio_group_viable;
> > 2) vfio_iommu_group_notifier;
> > 3) block-DMA if a device is detached from previous domain (instead of
> > switching back to default domain as today);
>=20
> I'm literally begging for specifics in this thread, but none are
> provided here.  What is the "previous domain"?  How is a device placed
> into a DMA blocking IOMMU context?  Is this the IOMMU default domain?
> Doesn't that represent a change in IOMMU behavior to place devices into
> a blocking DMA context in several of the group-viable scenarios?

Yes, it represents a change in current IOMMU behavior. Here I just
described what would be the desired logic in concept.=20

More specifically, the current IOMMU behavior is that:

-   A device is attached to the default domain (identity or dma) when it's
    probed by the iommu driver. If the domain type is dma, iommu
    isolation is enabled with an empty I/O page table thus the device
    DMA is blocked. If the domain type is identity, iommu isolation is
    disabled thus the device can access arbitrary memory/device even
    when it's not bound to any driver.

-   Once the device is bound to a driver which doesn't allocate a new
    domain, the default domain allows the driver to do DMA API on=20
    the device. Unbound from the driver doesn't change device/domain
    attaching status i.e. the device is still attached to the default domai=
n.
    Whether the device can access certain memory locations after unbind
    depends on whether the driver clears up its mappings properly.

-   Now the device is bound to a driver (vfio) which manages its own
    security context (domain type is unmanaged). The device stays
    attaching to the default domain before the driver explicitly switches
    it to use the new unmanaged domain. Detaching the device from an=20
    unmanaged domain later puts it back to use the default domain.

Then the current vfio mechanism makes sense because there is no
guarantee that the default domain can isolate the device from the=20
rest system (if domain type is identity or dma but previous driver=20
leaves stale mappings due to some bug). vfio has to allow user access
only after all devices in the group are switched to a known security=20
context that is created by vfio itself.

Now let's talk about the new IOMMU behavior:

-   A device is blocked from doing DMA to any resource outside of
    its group when it's probed by the IOMMU driver. This could be a
    special state w/o attaching to any domain, or a new special domain
    type which differentiates it from existing domain types (identity,=20
    dma, or unmanged). Actually existing code already includes a
    IOMMU_DOMAIN_BLOCKED type but nobody uses it.

-   Once the device is bound to a driver which doesn't allocate a new
    domain, the first DMA API call implicitly switches the device from
    block-DMA state to use the existing default domain (identity or
    dma). This change should be easy as current code already supports
    a deferred attach mode which is activated in kdump kernel. Unbound
    from the driver implicitly detaches the device from the default=20
    domain and switches it back to the block-DMA state. This can be
    enforced via iommu_bus_notifier().

-   Now the device is bound to a driver (vfio) which delegates management
    of security context to iommu fd. The device stays in the block-DMA=20
    state before its attached to an IOASID. After IOASID attaching, it is p=
ut
    in a new security context represented by the IOASID. Detaching the=20
    device from an IOASID puts it back to block-DMA.=20

With this new behavior vfio just needs to track that all devices are in=20
block-DMA state before user access is allowed. This can be reported
via a new iommu interface and checked in vfio_group_viable() in=20
addition to what it verifies today. Once a group is viable, the user can=20
get a device fd from the group and bind it to iommu fd. vfio doesn't
need wait for all devices in the group attached to the same IOASID=20
before granting user access, because they are all isolated from the=20
rest system being either in block-DMA or in a new security context.
Thus a device-centric interface between vfio and iommu fd should
be sufficient.

vfio_iommu_group_notifier will be slightly changed to check whether=20
any device within the group is bound to iommu fd. If yes BUG_ON=20
is raised to avoid breaking the group isolation. To be consistent
VFIO_BIND_IOMMU_FD need also check group viability.

>=20
> > 4) vfio_group_get_device_fd. User can acquire a device fd once the grou=
p
> > is viable;
>=20
> But as you've noted, "viable" doesn't test the IOMMU context of the
> group devices, it's only a pre-condition for attaching the group to an
> IOMMU context for isolated access.  What changes in the kernel that
> makes "viable" become "isolated"?  A device bound to pci-stub today is
> certainly not in a DMA blocking context when the host is booted with
> iommu=3Dpt.  Enabling the IOMMU only for device assignment by using
> iommu=3Dpt is arguably the predominant use case of the IOMMU.

vfio_group_viable() needs to check block-DMA, and iommu=3Dpt=20
only affects the DMA API path now. A device which is not bound
to any driver or the driver doesn't do DMA on is left in block-DMA
state.

>=20
> > 5) device-centric when binding to IOMMU fd or attaching to IOASID
> >
> > In this model the group viability mechanism is kept but there is no nee=
d
> > for VFIO to track the actual attaching status.
> >
> > Now let's look at how the new model works.
> >
> > >
> > > 1) A dual-function PCIe e1000e NIC where the functions are grouped
> > >    together due to ACS isolation issues.
> > >
> > >    a) Initial state: functions 0 & 1 are both bound to e1000e driver.
> > >
> > >    b) Admin uses driverctl to bind function 1 to vfio-pci, creating
> > >       vfio device file, which is chmod'd to grant to a user.
> >
> > This implies that function 1 is in block-DMA mode when it's unbound
> > from e1000e.
>=20
> Does this require a kernel change from current?  Does it require the
> host is not in iommu=3Dpt mode?  Did vfio or vfio-pci do anything to
> impose this DMA blocking context?  What if function 1 is actually a DMA

I hope above explanation answers them.

> alias of function 0, wouldn't changing function 1's IOMMU context break
> the operation of function 0?

Sorry I'm not familiar with this DMA aliasing thing. Can you elaborate?

>=20
> > >
> > >    c) User opens vfio function 1 device file and an iommu_fd, binds
> > >    device_fd to iommu_fd.
> >
> > User should check group viability before step c).
>=20
> Sure, but "user should" is not a viable security model.
>=20
> > >
> > >    Does this succeed?
> > >      - if no, specifically where does it fail?
> > >      - if yes, vfio can now allow access to the device?
> > >
> >
> > with group viability step c) fails.
>=20
> I'm asking for specifics, is it vfio's responsibility to test viability
> before trying to bind the device_fd to the iommu_fd and it's vfio that
> triggers this failure?  This sounds like vfio is entirely responsible
> for managing the integrity of the group.

manage integrity of the group based on block-DMA, but no need of=20
a group interface with iommu fd to track group attaching status.

>=20
> > >    d) Repeat b) for function 0.
> >
> > function 0 is in block DMA mode now.
>=20
> Somehow...
>=20
> > >
> > >    e) Repeat c), still using function 1, is it different?  Where?  Wh=
y?
> >
> > it's different because group becomes viable now. Then step c) succeeds.
> > At this point, both function 0/1 are in block-DMA mode thus isolated
> > from the rest of the system. VFIO allows the user to access function 1
> > without the need of knowing when function 1 is attached to a new
> > context (IOASID) via IOMMU fd and whether function 0 is left detached.
> >
> > >
> > > 2) The same NIC as 1)
> > >
> > >    a) Initial state: functions 0 & 1 bound to vfio-pci, vfio device
> > >       files granted to user, user has bound both device_fds to the sa=
me
> > >       iommu_fd.
> > >
> > >    AIUI, even though not bound to an IOASID, vfio can now enable acce=
ss
> > >    through the device_fds, right?  What specific entity has placed th=
ese
> >
> > yes
> >
> > >    devices into a block DMA state, when, and how?
> >
> > As explained in 2.b), both devices are put into block-DMA when they
> > are detached from the default domain which is used when they are
> > bound to e1000e driver.
>=20
> How do stub drivers interact with this model?  How do PCI interconnect
> drivers work with this model?  How do DMA alias devices work with this
> model?  How does iommu=3Dpt work with this model?  Does vfio just
> passively assume the DMA blocking IOMMU context based on other random
> attributes of the device?

pci-stub and bridge drivers follow the existing viability check.

iommu=3Dpt has no impact on block-DMA.

vfio explicitly tracks the dma-blocking state, which doesn't rely on iommu =
fd.

but I haven't got time to think about DMA aliasing yet.

>=20
> > >
> > >    b) Both devices are attached to the same IOASID.
> > >
> > >    Are we assuming that each device was atomically moved to the new
> > >    IOMMU context by the IOASID code?  What if the IOMMU cannot
> change
> > >    the domain atomically?
> >
> > No. Moving function 0 then function 1, or moving function 0 alone can
> > all works. The one which hasn't been attached to an IOASID is kept in
> > block-DMA state.
>=20
> I'm asking whether this can be accomplished atomically relative to
> device DMA.  If the user has access to the device after the bind
> operation and the device operates in a DMA blocking IOMMU context at
> that point, it seems that every IOASID context switch must be atomic
> relative to device DMA or we present an exploitable gap to the user.

the switch is always between block-DMA and a driver-created domain
which are both secure. Does this assumption meet the 'atomic' behavior
in your mind?

>=20
> This is another change from vfio, the lifetime of the IOMMU context
> encompasses the lifetime of device access.
>=20
> > >
> > >    c) The device_fd for function 1 is detached from the IOASID.
> > >
> > >    Are we assuming the reverse of b) performed by the IOASID code?
> >
> > function 1 turns back to block-DMA
> >
> > >
> > >    d) The device_fd for function 1 is unbound from the iommu_fd.
> > >
> > >    Does this succeed?
> > >      - if yes, what is the resulting IOMMU context of the device and
> > >        who owns it?
> > >      - if no, well, that results in numerous tear-down issues.
> >
> > Yes. function 1 is block-DMA while function 0 still attached to IOASID.
> > Actually unbind from IOMMU fd doesn't change the security context.
> > the change is conducted when attaching/detaching device to/from an
> > IOASID.
>=20
> But I think you're suggesting that the IOMMU context is simply the
> device's default domain, so vfio is left in the position where the user
> gained access to the device by binding it to an iommu_fd, but now the
> device exists outside of the iommu_fd.  Doesn't that make it pointless
> to gate device access on binding the device to the iommu_fd?  The user
> can get an accessible device_fd unbound from an iommu_fd on the reverse
> path.

yes, binding to iommu_fd is not the appropriate point of gating
device access.

>=20
> That would mean vfio's only control point for device access is on
> open().

yes, on open() via block-DMA check in vfio_group_viable().

>=20
> > >
> > >    e) Function 1 is unbound from vfio-pci.
> > >
> > >    Does this work or is it blocked?  If blocked, by what entity
> > >    specifically?
> >
> > works.
> >
> > >
> > >    f) Function 1 is bound to e1000e driver.
> > >
> > >    We clearly have a violation here, specifically where and by who in
> > >    this path should have prevented us from getting here or who pushes
> > >    the BUG_ON to abort this?
> >
> > via vfio_iommu_group_notifier, same as today.
>=20
> So as above, group integrity remains entirely vfio's issue?  Didn't we

sort of...

> discuss elsewhere in this thread that unless group integrity is managed
> by /dev/iommu that we're going to have a mess of different consumers
> managing it different degrees and effectiveness (or more likely just
> ignoring it)?

Yes, that was the original impression. But after figuring out the new
block-DMA behavior, I'm not sure whether /dev/iommu must maintain
its own group integrity check. If it trusts vfio, I feel it's fine to avoid=
=20
such check which even allows a group of devices bound to different
IOMMU fd's if user likes. Also if we want to sustain the current vfio
semantics which doesn't require all devices in the group bound to
vfio driver, seems it's pointless to enforce such integrity check in
/dev/iommu.

Jason, what's your opinion?

>=20
> > >
> > > 3) A dual-function conventional PCI e1000 NIC where the functions are
> > >    grouped together due to shared RID.
> > >
> > >    a) Repeat 2.a) and 2.b) such that we have a valid, user accessible
> > >       devices in the same IOMMU context.
> > >
> > >    b) Function 1 is detached from the IOASID.
> > >
> > >    I think function 1 cannot be placed into a different IOMMU context
> > >    here, does the detach work?  What's the IOMMU context now?
> >
> > Yes. Function 1 is back to block-DMA. Since both functions share RID,
> > essentially it implies function 0 is in block-DMA state too (though its
> > tracking state may not change yet) since the shared IOMMU context
> > entry blocks DMA now. In IOMMU fd function 0 is still attached to the
> > IOASID thus the user still needs do an explicit detach to clear the
> > tracking state for function 0.
> >
> > >
> > >    c) A new IOASID is alloc'd within the existing iommu_fd and functi=
on
> > >       1 is attached to the new IOASID.
> > >
> > >    Where, how, by whom does this fail?
> >
> > No need to fail. It can succeed since doing so just hurts user's own fo=
ot.
> >
> > The only question is how user knows the fact that a group of devices
> > share RID thus avoid such thing. I'm curious how it is communicated
> > with today's VFIO mechanism. Yes the group-centric VFIO uAPI prevents
> > a group of devices from attaching to multiple IOMMU contexts, but
> > suppose we still need a way to tell the user to not do so. Especially
> > such knowledge would be also reflected in the virtual PCI topology
> > when the entire group is assigned to the guest which needs to know
> > this fact when vIOMMU is exposed. I haven't found time to investigate
> > it but suppose if such channel exists it could be reused, or in the wor=
st
> > case we may have the new device capability interface to convey...
>=20
> No such channel currently exists, it's not an issue today, IOMMU
> context is group-based.

Interesting... If such group of devices are assigned to a guest, how does
Qemu decide the virtual PCI topology for them? Do they have same
vRID or different?

>=20
> > > If vfio gets to offload all of it's group management to IOASID code,
> > > that's great, but I'm afraid that IOASID is so focused on a
> > > device-level API that we're instead just ignoring the group dynamics
> > > and vfio will be forced to provide oversight to maintain secure
> > > userspace access.  Thanks,
> > >
> >
> > In summary, the security of the group dynamics are handled through
> > block-DMA plus existing vfio_group_viable mechanism in this device-
> > centric design. VFIO still keeps its group management, but no need
> > to track the attaching status for allowing user access.
>=20
> Still seems pretty loosely defined to me, the DMA blocking mechanism

Sorry for that and hope the explanation in this mail makes it clearer.

> isn't specified, there's no verification of the IOMMU context for
> "stray" group devices, the group management is based in the IOASID
> consumer code leading to varying degrees of implementation and
> effectiveness between callers, we lean more heavily on a fragile
> notifier to notice and hit the panic button on violation.
>=20
> It would make a lot more sense to me if the model were for vfio to
> bind groups to /dev/iommu, the IOASID code manages group integrity, and
> devices can still be moved between IOASIDs as is the overall goal.  The
> group is the basis of ownership, which makes it a worthwhile part of
> the API.  Thanks,
>=20

Having explained the device-centric design, honestly speaking I think
your model could also work. Group is an iommu concept, thus not
unsound by asking /dev/iommu to manage the group integrity, e.g.=20
moving the block-DMA verification and vfio_group_viable() into=20
/dev/iommu and verify it when doing group binding. A successful=20
group binding implies all group verification passed then user access=20
can be allowed. But even doing so I don't expect /dev/iommu uAPI=20
will include any explicit group semantics. Just the in-kernel helper=20
functions accepts group via VFIO_GROUP_BIND_IOMMU_FD.

Thanks
Kevin
