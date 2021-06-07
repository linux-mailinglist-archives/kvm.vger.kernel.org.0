Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DE939D369
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 05:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhFGD1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Jun 2021 23:27:43 -0400
Received: from mga05.intel.com ([192.55.52.43]:34541 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230172AbhFGD1m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Jun 2021 23:27:42 -0400
IronPort-SDR: ELE1BSBeORPmUDFLORXtRWVDwCKmITXynMPxaJ0jzAQUQn/7bbs6j89UmE0LrFIvkoiOvJz4bx
 MkML4+jYmW8A==
X-IronPort-AV: E=McAfee;i="6200,9189,10007"; a="290181626"
X-IronPort-AV: E=Sophos;i="5.83,254,1616482800"; 
   d="scan'208";a="290181626"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 20:25:35 -0700
IronPort-SDR: jBhQDbBqXyGZifNE1Kz/skjEH8eEpPqvvRyQKH8m6t5xiPpPHNtHJVR+GDdE7RdCQFzxPxXKzB
 2BPHnCt+zLlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,254,1616482800"; 
   d="scan'208";a="551101849"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga004.jf.intel.com with ESMTP; 06 Jun 2021 20:25:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Sun, 6 Jun 2021 20:25:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Sun, 6 Jun 2021 20:25:34 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Sun, 6 Jun 2021 20:25:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fzmNpBMEgygcEglkkuvSOzxh6T5SqVYiB31SCiYPwuJZ+KCLS5r4Spn38m9g7Kuo4GE/5DCzG4EZQJM2KHuyD0IUBoanMnBmejL4GZh3TCNiQFN8nvxe9LOohR85QRLrwOj5JZBbP10pXoMu7cRu+3ed2RR7+VP/bJtQmGmT/i4KKxA7VCP+JBjkW0iFf3qSUtswxkLyHNN4wQ9a1Auyy1yYP7AmGhsHTu+e9MZDRtiHxsPZygitdoR9r02SaYtXcaE9KzZG2AgEjnpEWb9e7jSwspfB0ec0L6u/0lyXKSJft98XFPEA5wrESW2QlnzHkxoFW6bhkSzF9wtAE/mfCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oXrHLGyq455N7a53jgHQMX0iTk/4cdZpqAtxJ5snkeo=;
 b=iKLWtIodv4NzJQx64Q2D/MatT+C6SnTdIxm55wnSoznGiiPIg+Qtq2anJOhfaEipfROmyUekc+Wgdfwu35dzDTadXO1DW9isv4aLjHDsxY8kec0wofBvZ/VI2NicPDl+3b47mmhhPQsnAEFbpNNHWmWjBiHM2FI/TKfLotmXFb/Gvrgg1o0YrkQzIuERytdlXEUX7LGteV/qg7ok5r36VEfgE1jJNto8HKqB9e/QMsNcvOdvvuFnPoRtlGmk8fCBmHtRNlQhkxDFeaxO5gU+blv9Iq4nGlygOLaV3XoQ9hdlRSb3Rr+oU5P+Sh0OHm1mr3fxIPcNJCEirqXgrwsUCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oXrHLGyq455N7a53jgHQMX0iTk/4cdZpqAtxJ5snkeo=;
 b=LBf+LbJ4MKflJnwiZStiUZIYmITMEbbB5Iwhelmtf0+R/O81FL+kNHXc+Si4gzvQtp42onlxoLgjuojK0RF5yp/T7dnk3STeNeBTIiFmLJ5KtXkafVxzHxUKp3bSQHV+TSa65GUURzXCrriYEFINOjXr3VVRDNVKNgKdNNr8BBQ=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Mon, 7 Jun
 2021 03:25:32 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 03:25:32 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBL2ymAAKTbxpAAKSt7gAAHpf9wAB1YcAAAAm5sgAAA1YgAAADonIAAAEmcgAABzCaAAAHbfwAAAYTsAAAEeLUAAAiRJwAAFF14gAAPozMAAABMSwAAA0bJgAAVeTBAAAlp0QAABjX0AAAAf0IAAABWuQAAAD8IgAAAOC4AAABA0oAAAn0sgAAIof4AAHA5uFA=
Date:   Mon, 7 Jun 2021 03:25:32 +0000
Message-ID: <MWHPR11MB1886E95C6646F7663DBA10DD8C389@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210603201018.GF1002214@nvidia.com>
        <20210603154407.6fe33880.alex.williamson@redhat.com>
        <MWHPR11MB1886469C0136C6523AB158B68C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210604122830.GK1002214@nvidia.com>
        <20210604092620.16aaf5db.alex.williamson@redhat.com>
        <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
        <20210604155016.GR1002214@nvidia.com>
        <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
        <20210604160336.GA414156@nvidia.com>
        <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
        <20210604172207.GT1002214@nvidia.com>
 <20210604152918.57d0d369.alex.williamson@redhat.com>
In-Reply-To: <20210604152918.57d0d369.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.80.65.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 569d892c-a719-4d17-733f-08d92963e842
x-ms-traffictypediagnostic: CO1PR11MB5089:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB5089AD913B83AC4F778404B28C389@CO1PR11MB5089.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0VhqU4LKvakAEq7ZkPrP7iClDvv8IBWAgtGRY0K5k43E+rOpDEUgGAMpqaa/PSoHX/e/lg8RByDQ1buTUIWJ09JtFWaDlKFRCaYdCAzu6YptPzYTN01lsVTt9/S7lRU2/lhxx3MVOXdRtE7oq4cyyJLr6Y9b9JlJksdjNGi0byqIKPDsihtvJTVaAgHU3/6vOlJE/jHxOB/ATRf5vhOeVHcTxEvUGHis2EmZzz02PSmscOag+ABeDaSoW7AwUt5aQyJYX2/TeJ7ZZDfUJIKjp6TKzweBBze7/SNT0uKSukonsQ4AXiPdWFNsW4X1cjgjvO+BmGh8tZ7bYGfzqrHHL6H64Es14WhdW9awbiuLsKmNsq+dptgM2ICuyQtSi68VBGblQc+P9im/58C20mIvWJkZxSeBRwv8ig6FqmgoVcX5HRLHBvKJ8MejG9WD79OXAR3ZBDPFwuAc46JN5tUo5wiERDWWmLuXi3hNWhegMguZ4Eyo0+wHnSh9tj6JIMMBhdlBNkUGdTIVKO3MTHjmYdfbark6yRXcgBKKwjoG0TXMi1FnIOfTETZSP/UWTuGE8zOQASqr6qcb06ISyM2xrHKKD/Gvw6IZvXBdD9GxpbY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(136003)(396003)(39860400002)(2906002)(53546011)(110136005)(5660300002)(86362001)(54906003)(4326008)(7696005)(66476007)(8676002)(76116006)(9686003)(6506007)(7416002)(83380400001)(122000001)(38100700002)(52536014)(64756008)(66446008)(66946007)(55016002)(316002)(8936002)(33656002)(71200400001)(26005)(478600001)(186003)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4fuqSrffRBkLAwY2CPlwg1+kjXL2i0ZjxCDdPObBU49lzN0sG9dTUgLbPy5b?=
 =?us-ascii?Q?tOhM9MntfPZRuYyPnDEe37d6HNmGemWr2YnOCHvLVW5AaztKN+PiEgvGRUni?=
 =?us-ascii?Q?+YsVNceL38LRBtt1Em8Xk9F9ESJRVghI6U/NDQKJqJKNXaALzRlmzsVRbihA?=
 =?us-ascii?Q?SabFCB8WjbIw/MyPZaS+dum0jFRUeYh4vk/kJL8Zg2sMPPBGmkgoBalX/50e?=
 =?us-ascii?Q?QNF4dmhQ7z7Aw/9+2+DRq7WnjgwWmEUrQYkl+2HVUahWiAi5v12Ak6pcagKG?=
 =?us-ascii?Q?Yt2dtInSwuuJHZje6a15AAKhCHN59mACX2iDhHmTm1wn7rp/16l0GXrEySBg?=
 =?us-ascii?Q?ncKb1TscVYSiwzFlnKHktqEjeQ0JGFvYb680TuFyxxTdPiflkIZUNjQ2ypyv?=
 =?us-ascii?Q?P00MYfm7A2cBFc9vzAu7ai3VehWL9fNTmMtLQgP9HseRhE+Ptdkcgyyi6J+2?=
 =?us-ascii?Q?2mWs0thF3UnJmWaecFyhDys3tI6F3pmJ3KmmpGfgOiD/B5m+E1+2n4WDJQZW?=
 =?us-ascii?Q?glFIQUC+nglGVrCTzCfnMVij6ymeaQqwWLnZM0fprpA3QIHNBsIfrxwNwj2b?=
 =?us-ascii?Q?tw1aRo/T7qp9XV+DHeYJ+uLNGiy+nG2e0cUk6LOiQmxCeYq/8apkvs2bzLUu?=
 =?us-ascii?Q?uXR30CkeU9iB8GoJCJkVjkXWdXHlj3A4AiTKeS1eis4g+Cy6RcLi5rHY0Giw?=
 =?us-ascii?Q?h5fWOIlyLNXDcA9PQZWoKw/1vgblTIbrJTWLgF9Gx+Vhg0HIuI3wejlwMkXI?=
 =?us-ascii?Q?hw6m1foRetNOLoYl7GtAS3B3PaECkTNkzguCQ6f+kVqciW+J9K3/hTVAZGhT?=
 =?us-ascii?Q?zy3BJUIufcV8sM4V42yWlRRczfjxGhyPoyJlcZGmHeqNf6GnaYZkgxRoQXLl?=
 =?us-ascii?Q?YJ6dM5Q1WsxncyYSI00kVIOLWhF7hsC+eJ+X6OKelPmYY5+pY0KH5KAzwxIZ?=
 =?us-ascii?Q?m5tHZB3P50QTmZV2cu9sHDpp8rKerVEizD3wY+eMY5XfzMN/C1idLn2SG/4c?=
 =?us-ascii?Q?/UWKhrNUnrF7nx3qH7pBZAWdX1y0aWDVJu7lVZXmOSvti8JO4/gH5532TAN6?=
 =?us-ascii?Q?Ntv/butGTKl62xpGnP4B5jrNEaLVaQUIDkRnVDB0wTNMwZDzEM0kUobMFlD2?=
 =?us-ascii?Q?7cc8BhPkvLWtW4/WN3j3zsf5YZsYMGdYrb0QdViJmvKl3TzeFiHU3Yu81qxm?=
 =?us-ascii?Q?Ymzcm5S5gGf7EIgpAdMkDH8P9e+4MGxNmbir9t+p0kjTP7o7oL36tp3Sl/i8?=
 =?us-ascii?Q?V+pWHpKQLmOQpYuvZGxGW5WJfbCQv2NMUpZP29lAmL9LUx4wq5AVmawNR7F5?=
 =?us-ascii?Q?HTI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 569d892c-a719-4d17-733f-08d92963e842
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2021 03:25:32.3556
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RZIqym1oHw47VqIE9KsjtVFXWyWI8/uyFRhMtsw86f2Wf7J/XRqs7SOIpcSb8nHF5EVPmnoXdyeKWBcMVi0phA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5089
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, June 5, 2021 5:29 AM
>=20
> On Fri, 4 Jun 2021 14:22:07 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Fri, Jun 04, 2021 at 06:10:51PM +0200, Paolo Bonzini wrote:
> > > On 04/06/21 18:03, Jason Gunthorpe wrote:
> > > > On Fri, Jun 04, 2021 at 05:57:19PM +0200, Paolo Bonzini wrote:
> > > > > I don't want a security proof myself; I want to trust VFIO to mak=
e the
> right
> > > > > judgment and I'm happy to defer to it (via the KVM-VFIO device).
> > > > >
> > > > > Given how KVM is just a device driver inside Linux, VMs should be=
 a
> slightly
> > > > > more roundabout way to do stuff that is accessible to bare metal;=
 not
> a way
> > > > > to gain extra privilege.
> > > >
> > > > Okay, fine, lets turn the question on its head then.
> > > >
> > > > VFIO should provide a IOCTL VFIO_EXECUTE_WBINVD so that userspace
> VFIO
> > > > application can make use of no-snoop optimizations. The ability of =
KVM
> > > > to execute wbinvd should be tied to the ability of that IOCTL to ru=
n
> > > > in a normal process context.
> > > >
> > > > So, under what conditions do we want to allow VFIO to giave a proce=
ss
> > > > elevated access to the CPU:
> > >
> > > Ok, I would definitely not want to tie it *only* to CAP_SYS_RAWIO (i.=
e.
> > > #2+#3 would be worse than what we have today), but IIUC the proposal
> (was it
> > > yours or Kevin's?) was to keep #2 and add #1 with an enable/disable i=
octl,
> > > which then would be on VFIO and not on KVM.
> >
> > At the end of the day we need an ioctl with two arguments:
> >  - The 'security proof' FD (ie /dev/vfio/XX, or /dev/ioasid, or whateve=
r)
> >  - The KVM FD to control wbinvd support on
> >
> > Philosophically it doesn't matter too much which subsystem that ioctl
> > lives, but we have these obnoxious cross module dependencies to
> > consider..
> >
> > Framing the question, as you have, to be about the process, I think
> > explains why KVM doesn't really care what is decided, so long as the
> > process and the VM have equivalent rights.
> >
> > Alex, how about a more fleshed out suggestion:

Possibly just a naming thing, but I feel it's better to just talk about
no-snoop or non-coherent in the uAPI. Per Intel SDM wbinvd is a
privileged instruction. A process on the host has no privilege to=20
execute it. Only when this process holds a VM, this instruction matters
as there are guest privilege levels. But having VFIO uAPI (which is
userspace oriented) to explicitly deal with a CPU instruction which
makes sense only in a virtualization context sounds a bit weird...

> >
> >  1) When the device is attached to the IOASID via VFIO_ATTACH_IOASID
> >     it communicates its no-snoop configuration:
>=20
> Communicates to whom?
>=20
> >      - 0 enable, allow WBINVD
> >      - 1 automatic disable, block WBINVD if the platform
> >        IOMMU can police it (what we do today)
> >      - 2 force disable, do not allow BINVD ever
>=20
> The only thing we know about the device is whether or not Enable
> No-snoop is hard wired to zero, ie. it either can't generate no-snoop
> TLPs ("coherent-only") or it might ("assumed non-coherent").  If
> we're putting the policy decision in the hands of userspace they should
> have access to wbinvd if they own a device that is assumed
> non-coherent AND it's attached to an IOMMU (page table) that is not
> blocking no-snoop (a "non-coherent IOASID").
>=20
> I think that means that the IOASID needs to be created (IOASID_ALLOC)
> with a flag that specifies whether this address space is coherent
> (IOASID_GET_INFO probably needs a flag/cap to expose if the system
> supports this).  All mappings in this IOASID would use IOMMU_CACHE and

Yes, this sounds a cleaner way than specifying this attribute late in
VFIO_ATTACH_IOASID. Following Jason's proposal v2 will move to
the scheme requiring user to specify format info when creating an
IOASID. Leaving coherent out of that box just adds some trickiness,=20
e.g. whether allowing user to update page table between ALLOC=20
and ATTACH.

> and devices attached to it would be required to be backed by an IOMMU
> capable of IOMMU_CAP_CACHE_COHERENCY (attach fails otherwise).  If only
> these IOASIDs exist, access to wbinvd would not be provided.  (How does
> a user provided page table work? - reserved bit set, user error?)
>=20
> Conversely, a user could create a non-coherent IOASID and attach any
> device to it, regardless of IOMMU backing capabilities.  Only if an
> assumed non-coherent device is attached would the wbinvd be allowed.
>=20
> I think that means that an EXECUTE_WBINVD ioctl lives on the IOASIDFD
> and the IOASID world needs to understand the device's ability to
> generate non-coherent DMA.  This wbinvd ioctl would be a no-op (or
> some known errno) unless a non-coherent IOASID exists with a potentially
> non-coherent device attached.
>=20
> >     vfio_pci may want to take this from an admin configuration knob
> >     someplace. It allows the admin to customize if they want.
> >
> >     If we can figure out a way to autodetect 2 from vfio_pci, all the
> >     better
> >
> >  2) There is some IOMMU_EXECUTE_WBINVD IOCTL that allows userspace
> >     to access wbinvd so it can make use of the no snoop optimization.
> >
> >     wbinvd is allowed when:
> >       - A device is joined with mode #0
> >       - A device is joined with mode #1 and the IOMMU cannot block
> >         no-snoop (today)
> >
> >  3) The IOASID's don't care about this at all. If IOMMU_EXECUTE_WBINVD
> >     is blocked and userspace doesn't request to block no-snoop in the
> >     IOASID then it is a userspace error.
>=20
> In my model above, the IOASID is central to this.
>=20
> >  4) The KVM interface is the very simple enable/disable WBINVD.
> >     Possessing a FD that can do IOMMU_EXECUTE_WBINVD is required
> >     to enable WBINVD at KVM.
>=20
> Right, and in the new world order, vfio is only a device driver, the
> IOASID manages the device's DMA.  wbinvd is only necessary relative to
> non-coherent DMA, which seems like QEMU needs to bump KVM with an
> ioasidfd.
>=20
> > It is pretty simple from a /dev/ioasid perpsective, covers todays
> > compat requirement, gives some future option to allow the no-snoop
> > optimization, and gives a new option for qemu to totally block wbinvd
> > no matter what.
>=20
> What do you imagine is the use case for totally blocking wbinvd?  In
> the model I describe, wbinvd would always be a no-op/known-errno when
> the IOASIDs are all allocated as coherent or a non-coherent IOASID has
> only coherent-only devices attached.  Does userspace need a way to
> prevent itself from scenarios where wbvind is not a no-op?
>=20
> In general I'm having trouble wrapping my brain around the semantics of
> the enable/automatic/force-disable wbinvd specific proposal, sorry.
> Thanks,
>=20

Thanks,
Kevin
