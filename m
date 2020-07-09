Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7462195C2
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 03:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgGIB44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 21:56:56 -0400
Received: from mga07.intel.com ([134.134.136.100]:49155 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbgGIB4z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 21:56:55 -0400
IronPort-SDR: LV6oS6ab99jIFlSG9LLt8PYUIdVFPfcm/nlt+9P1gp3gLUvbOoca3EqZhj7JJ8pO4PdxCiWx91
 F9Hc18reX1AA==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="212842728"
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="212842728"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 18:56:54 -0700
IronPort-SDR: TDryZUSlta/i/KORciW6p0hzZOER9FP5BggM+RGuNLStQMMquEb1pGZrptOH57n83rz5n5S+YR
 GQoCVDJnFQjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="484089917"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 08 Jul 2020 18:56:53 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 8 Jul 2020 18:56:53 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 8 Jul 2020 18:56:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 8 Jul 2020 18:56:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyxPJnRtdCSkfkucSp3PEYpjBQfJut6j+mllU6bZkz6zRoMmyrvmBOsYRKmwuq98PLFfEza44yXxNWcREBJamPpqmqyhtuGLYnhRU28chaww5Ye7IzfcoXw462oE85NIfE45muhsxLae7RLXieNEeTwydV1te+Ixp7Epak98P2DgtfXJIhYHa6id+el6hg9Y3YPnq3YPyHkx1fT+4f+oJxzTAJV6jIVe28Ihz6YJo5PKvtjPB5EIUqN2+7W/eIMajb5QX79hJFr3R7Tv98QZwjUuIYrvIBpcI01jRRkdK55Rwoq8KqfklroQTOz2iskjXN/DsjmyrPA2UYqkFLPxzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6Z18PlihcmVIvZ3z3MtTK+xhcwJSZmQY6lpe8jCNvE=;
 b=hinztQGWF8QudvGv30gIEu33rkm3z1a6b3qp2SDetPn38Mlbae/kaMGc6p4Sqa6sLstXzZ/rTvM0YqXhBFuWlEkpc93c0u3SaxasiuvG0WZPSSKky9Z5FNPblWNwg1i654xVbD8qCq8pvDBsxrW5V8CYpNPe4droE9C7VIyCPInNYcOmkovXF1cuExYM5PoUFPSYyMh7+mj3t4H88IVG5ihlSDUxAXYI0gcfu9PIY/1Hl5CpaFBw5mZ9MZn/nOj4Yiq+3yWyn536k5GBj9jFPLg0bnq8QxvE2wLSop5V2FUgxucqvSTdfx5Y6FP3DQNuJkDretsRlJd5rdoU+5RNJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6Z18PlihcmVIvZ3z3MtTK+xhcwJSZmQY6lpe8jCNvE=;
 b=QRuITXJDb/AOxz7WwL7CdKT+boQQtC5MoydwNZg73nmxEhuDoE93lNpT/RRxlpk4hyVw+Na6LNlyfOLi282suVmWYLVVVJJOQAfjz+01onEIlkCE14AXA9jXMcR6xPFGQY/z9/uJlOlnKRtJzIOBxQ7cjGi2VC4SNEq/wKq/bP8=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB0015.namprd11.prod.outlook.com (2603:10b6:301:66::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Thu, 9 Jul
 2020 01:56:48 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb%5]) with mapi id 15.20.3174.022; Thu, 9 Jul 2020
 01:56:48 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 06/14] vfio/type1: Add VFIO_IOMMU_PASID_REQUEST
 (alloc/free)
Thread-Topic: [PATCH v3 06/14] vfio/type1: Add VFIO_IOMMU_PASID_REQUEST
 (alloc/free)
Thread-Index: AQHWSgRRTio77cjKfEyUOM8HK1PN0qj02KQAgACZigCAB/njAIAAwyYAgABNmICAABJNAA==
Date:   Thu, 9 Jul 2020 01:56:48 +0000
Message-ID: <MWHPR11MB16456D12135AA36BA16CE4208C640@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
        <1592988927-48009-7-git-send-email-yi.l.liu@intel.com>
        <20200702151832.048b44d1@x1.home>
        <CY4PR11MB1432DD97F44EB8AA5CCC87D8C36A0@CY4PR11MB1432.namprd11.prod.outlook.com>
        <DM5PR11MB1435B159DA10C8301B89A6F0C3670@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20200708135444.4eac48a4@x1.home>
 <DM5PR11MB14358A8797E3C02E50B37FFEC3640@DM5PR11MB1435.namprd11.prod.outlook.com>
In-Reply-To: <DM5PR11MB14358A8797E3C02E50B37FFEC3640@DM5PR11MB1435.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.196]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5a5619b-44b8-47e2-3395-08d823ab572f
x-ms-traffictypediagnostic: MWHPR11MB0015:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB0015CAB2883C85B8F14AF3F08C640@MWHPR11MB0015.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04599F3534
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dHO3RiM27gvhE3a3ynhMruLQJz44IWPKtGlBbwhBM7pOokA2VYmwsm+Q5BKT4IqNplj0NG+pno7sYdY4E0aV2eT7vvwsyZ81QaLn1HIKMMMpshZlGpMdNsSXdnMzGfxeYEY+0wZ5ovIRlfLDrQPrHS0f3VUv5ec8mrylfZPAAokufY96BaN6fZRQ7cXFo3G2FjAF/3RdgC64nuJ6ZYjCKyFMiMBBv8wJwjak5+cYPzPS8nnIFb3mgHlshjKLL1i2MjfgJeweUrmXEVuJOr1bmOFK4LmXBXbeUV7aQYsFM5/WGxUgTxLkFoAE25ihBv2HujCCxfwLKo0/BgWOCD8M2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(26005)(186003)(8676002)(64756008)(71200400001)(86362001)(66446008)(33656002)(83380400001)(6506007)(478600001)(2906002)(5660300002)(7696005)(9686003)(316002)(8936002)(4326008)(55016002)(110136005)(76116006)(54906003)(7416002)(66946007)(52536014)(66476007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: p8WLKr5oDeobz7iOnfHfLiJb5vREtbqxZlHrl7geG2+vp+PRdK0vHblt9KanVG5/4xMR7O83RiIlOrpqADjvJqgukP4YumcDIUKoXMrDBSgw2r482d4iQE1sCaVPDLrAOn3tS+UwlGdkxVNgtSk94Zhm9SjZ2jsr9LajZsWix3o+tFTa5YEBUBe4BH3G0LcOdYey7WQkjw2jxgM+mYirhTOCSYQzHKdHsk6ytubdCxVfvw5AZ5uVRq0K2fS2dWuLuu1CF7lsFm1bcz3ABpvC/T/PIQgcv/TGncTrfdhiPqdYNKXrVuffMXpAZfwwmlqFEdkQpdpLsseM7iDxqBDn/isBfn6ssT224gWjqmdvx1NOVtm8j/Pa+G843Uh9/5yqEoM6ycRxv6pTgxzRweEDgxDnuD5arJq7wV4Kw3H4KMhL6PAuoDqm6KtD/7XhACYhf/twyucgdRcyVUjkGyz+veLRRO9YlXcuvST5IKNiRB9VglQpJb0Jd4ekRaYFMFZ3
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5a5619b-44b8-47e2-3395-08d823ab572f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2020 01:56:48.1406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OMnbMRUxjlPZsHBPf7ty1Im9xw2Swc5BSXn1Mby6HIofvzu5DjLTR41d+mV74FEUaPT79E4RBgx+7X738umIpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0015
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, July 9, 2020 8:32 AM
>=20
> Hi Alex,
>=20
> > Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, July 9, 2020 3:55 AM
> >
> > On Wed, 8 Jul 2020 08:16:16 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >
> > > Hi Alex,
> > >
> > > > From: Liu, Yi L < yi.l.liu@intel.com>
> > > > Sent: Friday, July 3, 2020 2:28 PM
> > > >
> > > > Hi Alex,
> > > >
> > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > Sent: Friday, July 3, 2020 5:19 AM
> > > > >
> > > > > On Wed, 24 Jun 2020 01:55:19 -0700
> > > > > Liu Yi L <yi.l.liu@intel.com> wrote:
> > > > >
> > > > > > This patch allows user space to request PASID allocation/free, =
e.g.
> > > > > > when serving the request from the guest.
> > > > > >
> > > > > > PASIDs that are not freed by userspace are automatically freed
> when
> > > > > > the IOASID set is destroyed when process exits.
> > > [...]
> > > > > > +static int vfio_iommu_type1_pasid_request(struct vfio_iommu
> *iommu,
> > > > > > +					  unsigned long arg)
> > > > > > +{
> > > > > > +	struct vfio_iommu_type1_pasid_request req;
> > > > > > +	unsigned long minsz;
> > > > > > +
> > > > > > +	minsz =3D offsetofend(struct vfio_iommu_type1_pasid_request,
> > range);
> > > > > > +
> > > > > > +	if (copy_from_user(&req, (void __user *)arg, minsz))
> > > > > > +		return -EFAULT;
> > > > > > +
> > > > > > +	if (req.argsz < minsz || (req.flags &
> > ~VFIO_PASID_REQUEST_MASK))
> > > > > > +		return -EINVAL;
> > > > > > +
> > > > > > +	if (req.range.min > req.range.max)
> > > > >
> > > > > Is it exploitable that a user can spin the kernel for a long time=
 in
> > > > > the case of a free by calling this with [0, MAX_UINT] regardless =
of their
> > actual
> > > > allocations?
> > > >
> > > > IOASID can ensure that user can only free the PASIDs allocated to t=
he
> user.
> > but
> > > > it's true, kernel needs to loop all the PASIDs within the range pro=
vided
> > > > by user.
> > it
> > > > may take a long time. is there anything we can do? one thing may li=
mit
> the
> > range
> > > > provided by user?
> > >
> > > thought about it more, we have per-VM pasid quota (say 1000), so even=
 if
> > > user passed down [0, MAX_UNIT], kernel will only loop the 1000 pasids=
 at
> > > most. do you think we still need to do something on it?
> >
> > How do you figure that?  vfio_iommu_type1_pasid_request() accepts the
> > user's min/max so long as (max > min) and passes that to
> > vfio_iommu_type1_pasid_free(), then to vfio_pasid_free_range()  which
> > loops as:
> >
> > 	ioasid_t pasid =3D min;
> > 	for (; pasid <=3D max; pasid++)
> > 		ioasid_free(pasid);
> >
> > A user might only be able to allocate 1000 pasids, but apparently they
> > can ask to free all they want.
> >
> > It's also not obvious to me that calling ioasid_free() is only allowing
> > the user to free their own passid.  Does it?  It would be a pretty

Agree. I thought ioasid_free should at least carry a token since the
user space is only allowed to manage PASIDs in its own set...

> > gaping hole if a user could free arbitrary pasids.  A r-b tree of
> > passids might help both for security and to bound spinning in a loop.
>=20
> oh, yes. BTW. instead of r-b tree in VFIO, maybe we can add an ioasid_set
> parameter for ioasid_free(), thus to prevent the user from freeing PASIDs
> that doesn't belong to it. I remember Jacob mentioned it before.
>=20

check current ioasid_free:

        spin_lock(&ioasid_allocator_lock);
        ioasid_data =3D xa_load(&active_allocator->xa, ioasid);
        if (!ioasid_data) {
                pr_err("Trying to free unknown IOASID %u\n", ioasid);
                goto exit_unlock;
        }

Allow an user to trigger above lock paths with MAX_UINT times might still
be bad.=20

Thanks
Kevin
