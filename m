Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFE33B152E
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 09:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhFWH7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 03:59:44 -0400
Received: from mga07.intel.com ([134.134.136.100]:53133 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229801AbhFWH7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 03:59:43 -0400
IronPort-SDR: ZoGYYx9rt3Ze+Ejz9rvM9qdFMQiehIvDdmDdvM/YbKizasViYL2b2rHgs0JboHT/0tSk0VrIZB
 iU7niQjmvBmw==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="271060644"
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="271060644"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 00:57:21 -0700
IronPort-SDR: xjW/1U3G9KifhcjJeF4INANdM70m7Cvh02iMOA9qXHDoIn+eDghkenevQ5n0fA/+/4CXvUK25r
 I4/XjunECsuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="639375625"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga006.fm.intel.com with ESMTP; 23 Jun 2021 00:57:20 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 23 Jun 2021 00:57:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 23 Jun 2021 00:57:20 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 23 Jun 2021 00:57:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmiPi0DZBYIm2Lohpy0/3ofbab3rsqHC/nMg2bytj1uVdD9ih6248uCF0p3PEUmtxyYdCxrJ5zhWfWL49x2X++il+eJNeU27uPJl4YaT+mwOlnA98efjvCeXfIpv0pL0gkHqV7iWil4X2dOg72gdIk6tb/U+UOVoI3zOFxS7sKVYgdh22RFtE0Cg+Rcrq9G5Dwv0CQxOF96sAS9di8Pl2I9msmXn+fd3nX3D1rEM1+vabQ3HxuXqcuetcG5AzKi4f1rzgdofTgG9DpIqwmP2VBP/d93wyO7OKII1p+m0wv///IvPcldfql1JAGbQ5tWZ9zvi+uuEBqWmB1lJnNMbPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VP2fgAZI8WyYlLV5b3cwR0tcR6LXIjRxmgNaCd7iGkg=;
 b=Z/8Adu8QFu7hxEhcVt+9MhfqtaIPY+7bQefpSNyyOM2+kzv2MHlEE3XDQ6DBfiChdHOcTy+JZXM3W/ki2XWF7WS5dUQHojBFrS7BrDdStJwvu/AP9SPPRa1aX9LQT4thbCmGyhdv4sgUIrwF2ebAQdshiOB1b4VqBnUSkpqe/7dLycEkrs3bhX0+fbIv9URd/cnLSuMQOQDORzqTmaCPn1BAM4GGOg8xz5WM2NY1PdgyS0QeBxg6UP+8BijYczJHjM1QS+mzFQ6yWk74rliTVybjUGwaRN+6l6Z+Sj8S3Vxn015AELqNsOEbc0pJnToqbCTCf8lJY5IOFhw4A2oNPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VP2fgAZI8WyYlLV5b3cwR0tcR6LXIjRxmgNaCd7iGkg=;
 b=OqRGOHyUNwKyLSGzb0XRow1paC6fCH1d4PHwY4iJby5EbDjz7QEqw5xQO+E4pc8YzeBra33NJ1cNpwtzgGKY0WW5LmPXa+w0ega5ztOnbKj9gax7oaAsOBehkxoP2iCAlLfOyB6eJN+CFux8dwNEvSPco96REYqBE+fJCJ/WSrk=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (10.175.54.9) by
 MWHPR11MB1933.namprd11.prod.outlook.com (10.175.54.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.21; Wed, 23 Jun 2021 07:57:19 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4242.024; Wed, 23 Jun
 2021 07:57:19 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>
CC:     "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Jason Gunthorpe" <jgg@nvidia.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ97BhCb3gd8AUyldaDZ6yOMNABLsqGAAN/dRYAAFU5FAAAaxTKAADwI6AAAwQ1+AAB5vHCAAUN/JAAAT74kgADnO8Og
Date:   Wed, 23 Jun 2021 07:57:19 +0000
Message-ID: <MWHPR11MB18865A92E12E7C2F6422987C8C089@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com> <YLcpw5Kx61L7TVmR@yekko>
 <20210602165838.GA1002214@nvidia.com> <YLhsZRc72aIMZajz@yekko>
 <YLn/SJtzuJopSO2x@myrica> <YL8O1pAlg1jtHudn@yekko> <YMI/yynDsX/aaG8T@myrica>
 <YMq6voIhXt7guI+W@yekko> <YMzR46luaG7hXsJi@myrica>
In-Reply-To: <YMzR46luaG7hXsJi@myrica>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.143.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13185682-2afa-4025-3f02-08d9361c867a
x-ms-traffictypediagnostic: MWHPR11MB1933:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1933F4F84EA623AFAF0C60828C089@MWHPR11MB1933.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 74KVg4qD2PUMA6614La7ld00V1LezQVrPZaanxV0N7acqV/PmY5VMQNvkvJ8jfTIZAYgemWP6C7s+sLOcVbjIAeJxbnPCw1r/ChUJl2ItE3B7W42cfrdT0k7ZQ9w+lDocwBcVXbaBHSPeoK2YZMjXFX1RXd3bDpuo6LuSPlx+5cBH0v7NUteno7kGqKruiQjSex5OyG8tgrei+ybqNa+YF74yeLq7hJCn8QCNp8b7g8/8qgqjiMbaqu1ZDtPiyz78DHc/bwYDgFBCLGH7JhdMEocYhAYPqcII9PHQbibovSRgwuFelnMwg9GXyYOOcls2WurWsIzq97leFlgNxUxNpUVEaXSt0lHsCm9An589Ba+9z/IimzY63HNNVow/qTb+KDtftFFApQrvD8xyDuuwLPhGBUeGedN4W7l1U1FowhVIyHgEhlojZgEmtSCzHK8TpAmfpJw6ew3MYY7lk7RR1H9L5iHcFLJceM4iXQQ7a+NDOexpdLHzx2xO77ru8Ndt4Lhn2tVcqtBQ+EOjO1lpa7mU8r9W63PCrVQu2Egj+90G+dYqPfnlLRiJ1x4RY2Be/fihBcdZL2vwVTLD1rjxYvoOBfgDJZG5H5rrO6pQ0U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(71200400001)(4326008)(86362001)(7416002)(66556008)(2906002)(66446008)(478600001)(83380400001)(186003)(122000001)(26005)(52536014)(8676002)(8936002)(76116006)(110136005)(7696005)(54906003)(55016002)(6506007)(9686003)(316002)(5660300002)(66946007)(38100700002)(66476007)(33656002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Mwp2H+UJHUG+WX3qqt8+fzFMHfHM++MsSSaCTs5VP2liL5HQnoH4mk0B+CXf?=
 =?us-ascii?Q?JQgFM4UgzjC8zLQ2TnvTef2J8v/ILquWYQRcREDXKEKal0KLT2VB7lOvX6Nj?=
 =?us-ascii?Q?QgGK9lNa8LmCta2ADXa8vRRNmqgtwz9ovZK59osg/FFKU2yMYn+CFW+zBebX?=
 =?us-ascii?Q?K51yR2bRLOpMfBc0MmX4MmttKvMB3732U1ZlTJlpEMcs0YqaXZy4C1acgVvB?=
 =?us-ascii?Q?mmmLRzQmx9EAQ0Gs7z5wqjc50HrvGNDm8VXKQaCA2Lhuex8xBpfwwYIwhVNC?=
 =?us-ascii?Q?VTJFIZs8oXHXi/VU7YNUcEfarR3mIQH3OClztMoMCyQEt3JkaKP/nun3UyWq?=
 =?us-ascii?Q?KCE916Cjmh/sfo93/fVY45BUc6dwdpHxlXX7Sw7ZzPFZHz7qrfGlCQsfQ/bt?=
 =?us-ascii?Q?TGE6mB2klOfPsNy0DnuqMmMLpIwT8dgeu9NoVmWwC176M/Vu74uRJSTJ0etL?=
 =?us-ascii?Q?X4ligVxJWuYQ+HfMeRb5tziws4ZIluZB811t8RZT+NObrtQeejrdYSyYtozv?=
 =?us-ascii?Q?4vLqe+X7+g9BTzZe70BEVeaQwA/2EiqY5P4yCVx7crTLZRJFFsitooMrNGZp?=
 =?us-ascii?Q?jgUYVgrz7UqoW5y33eeCLr0R3NN1DbiU5SLvkbpB24avSXMaCsjnSM3Ml6kO?=
 =?us-ascii?Q?X2TpiLdsQlthEE4H8Ui5ZwuKFmZgMG6X8xf/M5R6WktFTuvE+OIh5z+fXr6F?=
 =?us-ascii?Q?qhuB0uigKU+DOaxiP2BOPp3g4VaIcpt4OlL5g4RTCi+N7iVClVLI+tuLxZRK?=
 =?us-ascii?Q?NdfBU+HKqWq+HlpRak83S4f7H16lJD40nijkwHmkghIbMHs3hU7NYio94W6f?=
 =?us-ascii?Q?rioy03ltqHA3OvyHHcOeGlZcVl4bwBdb+emrG1ABgb13AfIKpcsp4ESxNz90?=
 =?us-ascii?Q?FYeHWnI0DEhZBlkF2qAkCVVZzt+TXWwkvOpKBz0+UCjG77qyiwEFQ4mWCJ/4?=
 =?us-ascii?Q?3J3Porcz1Rlbg2JAYqTtl2UXK5lnGnZNRhNRKacMvnHCdPqsAtc6wC4zPLiK?=
 =?us-ascii?Q?b65BzvewZmHe34zBFs8dIWHODJeQZYOwuQqIYlFayyvhW6hwe737oJpT0R31?=
 =?us-ascii?Q?Sp62GpLxo77xkkHJ473usN/9TNR3wwUqhNHIk99iJEcyumnk5TLO7a/tZceG?=
 =?us-ascii?Q?65y6bFwd6ZoXgsvO0ogQTUyOuMrf9nueOUfVgLseF5iGzK5P1xDkmWUHD+7r?=
 =?us-ascii?Q?e4Am2OEXEivCoQZj9hcMTLPx1uErqULIuRxUM1JStogS0vcRceVMLPaVx7uR?=
 =?us-ascii?Q?gE/zaCKd1EHDP1SSZFflWFIyLt8/ybbwV69+PCY5fCE9M1Cr+8uUD9MKlME9?=
 =?us-ascii?Q?PNbrkt/OKKP89zWrnIJA21Nw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13185682-2afa-4025-3f02-08d9361c867a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2021 07:57:19.1788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qzeK2WqLTaLYKacRyJfNRw+ewToYkz2PhNIx5F6M74TFYLSK3zgbOtEb4NYqz9pb9DHrLFCg9Q8zVML8BiNetw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1933
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jean-Philippe Brucker
> Sent: Saturday, June 19, 2021 1:04 AM
>=20
> On Thu, Jun 17, 2021 at 01:00:14PM +1000, David Gibson wrote:
> > On Thu, Jun 10, 2021 at 06:37:31PM +0200, Jean-Philippe Brucker wrote:
> > > On Tue, Jun 08, 2021 at 04:31:50PM +1000, David Gibson wrote:
> > > > For the qemu case, I would imagine a two stage fallback:
> > > >
> > > >     1) Ask for the exact IOMMU capabilities (including pagetable
> > > >        format) that the vIOMMU has.  If the host can supply, you're
> > > >        good
> > > >
> > > >     2) If not, ask for a kernel managed IOAS.  Verify that it can m=
ap
> > > >        all the IOVA ranges the guest vIOMMU needs, and has an equal=
 or
> > > >        smaller pagesize than the guest vIOMMU presents.  If so,
> > > >        software emulate the vIOMMU by shadowing guest io pagetable
> > > >        updates into the kernel managed IOAS.
> > > >
> > > >     3) You're out of luck, don't start.
> > > >
> > > > For both (1) and (2) I'd expect it to be asking this question *afte=
r*
> > > > saying what devices are attached to the IOAS, based on the virtual
> > > > hardware configuration.  That doesn't cover hotplug, of course, for
> > > > that you have to just fail the hotplug if the new device isn't
> > > > supportable with the IOAS you already have.
> > >
> > > Yes. So there is a point in time when the IOAS is frozen, and cannot =
take
> > > in new incompatible devices. I think that can support the usage I had=
 in
> > > mind. If the VMM (non-QEMU, let's say) wanted to create one IOASID FD
> per
> > > feature set it could bind the first device, freeze the features, then=
 bind
> >
> > Are you thinking of this "freeze the features" as an explicitly
> > triggered action?  I have suggested that an explicit "ENABLE" step
> > might be useful, but that hasn't had much traction from what I've
> > seen.
>=20
> Seems like we do need an explicit enable step for the flow you described
> above:
>=20
> a) Bind all devices to an ioasid. Each bind succeeds.

let's use consistent terms in this discussion. :)

'bind' the device to a IOMMU fd (container of I/O address spaces).=20

'attach' the device to an IOASID (representing an I/O address space=20
within the IOMMU fd)

> b) Ask for a specific set of features for this aggregate of device. Ask
>    for (1), fall back to (2), or abort.
> c) Boot the VM
> d) Hotplug a device, bind it to the ioasid. We're long past negotiating
>    features for the ioasid, so the host needs to reject the bind if the
>    new device is incompatible with what was requested at (b)
>=20
> So a successful request at (b) would be the point where we change the
> behavior of bind.

Per Jason's recommendation v2 will move to a new model:

a) Bind all devices to an IOMMU fd:
        - The user should provide a 'device_cookie' to mark each bound=20
          device in following uAPIs.

b) Successful binding allows user to check the capability/format info per
     device_cookie (GET_DEVICE_INFO), before creating any IOASID:
        - Sample capability info:
               * VFIO type1 map: supported page sizes, permitted IOVA range=
s, etc.;
               * IOASID nesting: hardware nesting vs. software nesting;
               * User-managed page table: vendor specific formats;
               * User-managed pasid table: vendor specific formats;
               * vPASID: whether delegated to user, if kernel-managed per-R=
ID or global;
               * coherency: what's kernel default policy, whether allows us=
er to change;
               * ...
       - Actual logistics might be finalized when code is implemented;

c) When creating a new IOASID, the user should specify a format which
    is compatible to one or more devices which will be attached to this=20
    IOASID right after.

d) Attaching a device which has incompatible format to this IOASID=20
     is simply rejected. Whether it's hotplugged doesn't matter.

Qemu is expected to query capability/format information for all devices
according to what a specified vIOMMU model requires. Then decide
whether to fail vIOMMU creation if not strictly matched or fall back to
a hybrid model with software emulation to bridge the gap. In any case
before a new I/O address space is created, Qemu should have a clear=20
picture about what format is required given a set of to-be-attached=20
devices and whether multiple IOASIDs are required if these devices=20
have incompatible formats.=20

With this model we don't need a separate 'enable' step. =20

>=20
> Since the kernel needs a form of feature check in any case, I still have =
a
> preference for aborting the bind at (a) if the device isn't exactly
> compatible with other devices already in the ioasid, because it might be
> simpler to implement in the host, but I don't feel strongly about this.

this is covered by d). Actually with all the format information available
Qemu even should not attempt to attach incompatible device in the=20
first place, though the kernel will do this simple check under the hood.

Thanks
Kevin
