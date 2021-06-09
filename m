Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F2A3A0A3F
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 04:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236009AbhFICvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 22:51:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:51477 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232690AbhFICvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 22:51:32 -0400
IronPort-SDR: KKz9mQrKF61Ae3Art6uGMid29tQitiTOOnMJQYNjbhxGEnm78YgR/LPDqaByXLOd03r0qNdgK0
 FWnhMSiQH9Wg==
X-IronPort-AV: E=McAfee;i="6200,9189,10009"; a="204955817"
X-IronPort-AV: E=Sophos;i="5.83,259,1616482800"; 
   d="scan'208";a="204955817"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 19:49:38 -0700
IronPort-SDR: bwDF72YUntEF+0s0hkuNTBJmUjalOXjVI5U0X8DZ4Rl0Bbm+x0n8yhA+Qtw0TGsLwY14N8xB92
 Xkg3HFmPzGzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,259,1616482800"; 
   d="scan'208";a="552519382"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga001.fm.intel.com with ESMTP; 08 Jun 2021 19:49:37 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 8 Jun 2021 19:49:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 8 Jun 2021 19:49:37 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 8 Jun 2021 19:49:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8CfiMhBL/0PoCMW5J59gVUGzxFLCtawBUCrsTnRwriXYM6oWraQ2oDNVaXdP9rcrZrC8I1mOjXiTX+WnOeDCmZg8ct2yTCXd4EMROMxQjhZdcIJMqw+Qbo9E3xrpJkxyGxnv72evynMGvZ9puEFH7oMNTRDAaqEA43/o2vRn4OPE3VdjGThIPtvG4XyNmK7SIdf1TyDiMXVgAzNP5KBliAxcoL5bKx4OsrdPpnYhEMjZfp9jlyKqW2K/fWv4U76WlDnqnJlscbkoSly6yQV0k1SQxCcYawLjQ6TbJ2OmCj8w+2DhgllYUEbtffvgxn1CpF0Q6W0HYzipGdmxopnXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihcFaORYWXAeoZSlN3Hu0gch8jp1E2YYC5imGEzwRmo=;
 b=dyuGciPsxzqK9pFyRJ22lBuuEa0SBNJLa8Q0blEjScWT8fGIBsFuQhAlctvrQCSl0PSBnvE9W+/IOTDzb8Sk6wuJGrjDTS/7285Vwn/y/e9liGQon4QFo8j3lkdE9uLa5ssNnnnY2RDx70aoCDqoTHzEluA2/kIh1fyqorIYmNq2Y1Gp73eP5277FDaxyD/KbuVJ8ccRQY53CErSvLBfDeEjsW1+Z+eSFHctlJjPiZsY62qjLk+lEbSadqGNsnuclhz0tX0M+807A7eXiOMfSoETObDVlWMltg6tmt74htsTjVxfwm4Jsjj5yvtMdS5AK1rMtPSrQY8gGr6Zz7H+VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihcFaORYWXAeoZSlN3Hu0gch8jp1E2YYC5imGEzwRmo=;
 b=eK+fJIXCtRhFjK5RDw0dkcmETI7ATijkxwC6n8ABy6z+W15su+QKoVFvNF8h8DNyDqc7KLV0hNN1D55bLRsk5eW2t7dzT5U2xF1EDWQRvVBTHbT+r5Ebuu7Z3E5Wy65mW3Inb8IqJ17yLWqhg9EDmRG8/kpu1ruRuy5KSSDm030=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB4852.namprd11.prod.outlook.com (2603:10b6:303:9f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Wed, 9 Jun
 2021 02:49:32 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 02:49:32 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
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
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBL2ymAAKTbxpAAKSt7gAAHpf9wAB1YcAAAAm5sgAAA1YgAAADonIAAAEmcgAABzCaAAAHbfwAAAYTsAAAEeLUAAAiRJwAAFF14gAAPozMAAABMSwAAA0bJgAAVeTBAAAlp0QAABjX0AAAAf0IAAABWuQAAAD8IgAAAOC4AAABA0oAAAn0sgAAbQLqAAHzsuQAAHTjUgAALKb+AAAEAJgAACpEpAAAO1BBQ
Date:   Wed, 9 Jun 2021 02:49:32 +0000
Message-ID: <MWHPR11MB18861A89FE6620921E7A7CAC8C369@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210604092620.16aaf5db.alex.williamson@redhat.com>
        <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
        <20210604155016.GR1002214@nvidia.com>
        <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
        <20210604160336.GA414156@nvidia.com>
        <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
        <20210604172207.GT1002214@nvidia.com>
        <2d1ad075-bec6-bfb9-ce71-ed873795e973@redhat.com>
        <20210607175926.GJ1002214@nvidia.com>
        <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
        <20210608131547.GE1002214@nvidia.com>
        <89d30977-119c-49f3-3bf6-d3f7104e07d8@redhat.com>
 <20210608124700.7b9aa5a6.alex.williamson@redhat.com>
In-Reply-To: <20210608124700.7b9aa5a6.alex.williamson@redhat.com>
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
x-ms-office365-filtering-correlation-id: 93ec3acd-9039-4a98-d9e9-08d92af135d4
x-ms-traffictypediagnostic: CO1PR11MB4852:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB4852C254786279C4AFDF74898C369@CO1PR11MB4852.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xN0ul+nQokFYK5Vqe/S/YuxlmgPNdflU42Dh/EjFsE7tOYqTySF/1o/YqruEOm7tBg3IT0pobnCdgU8QEp32GgF8eNJuqdHW0I3vW30zNFdcLiYkix01LRU8NGFlSpahEdh30D4iyqKkUZh0XFS+mo452gUQ8j6b+lR7Zz3cPIad4k4EX/aupbqxPSspZvzCkPNFUeXjFBCPbHqhQe5K9n9bIxI9ndvGWtY5e6ctWbN3wjVhGPisfO5E2bBBnrMeTBFikxBAJRj6H2y5MjGWcxjmyJfCnD220W8XX8ltucCulmh+KCdahHsL+c6Ik0gv5jY7aKHuOYCyMIljYmajmG1OlHKeMTaHCaQ27B1ETnUvbRN/Z6unpqaEHwcgPKkGCg9V9dDErGzWKtI2Rbzn8hFWEZ31E/xOu6kk9kL3e8iB8912s3ak7RrKGj+a1OsepmBa33Y6r74w/Jw+/dn2IImBQeWPCR6zOAFApl4jzAf7bDlOUobA7mZMgsaFGyc2mEEX3XoMZL+9eDbWDPPfKYl7iecJkzPPaqJJm2s1DTYUGK7p6XPMK/3H04te94Vhnf+n08XOSTqNp+YAF8mV0XljrfSLrwIsEOf6o9d1Zc4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(66946007)(76116006)(52536014)(7416002)(64756008)(4326008)(86362001)(6506007)(66446008)(53546011)(8676002)(66556008)(66476007)(33656002)(38100700002)(5660300002)(316002)(110136005)(54906003)(122000001)(55016002)(8936002)(9686003)(7696005)(83380400001)(2906002)(478600001)(26005)(71200400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4GKFV9QwAG4d8q8o06uI4r95gv7dMnHz5zTMZhxcN5KeqS8pZXYTzYvku7aD?=
 =?us-ascii?Q?l+ppT8tBrE5AKkkFsdUJxqp+ZhTWNK8DLL6eEPo3209seWqmAjQ4LeNkapnM?=
 =?us-ascii?Q?1RZYKCfErsji6QhBZY8PuwgTdqhZNszRm4MieJ9XPyOIHAVQ8gdCRsJRjrbW?=
 =?us-ascii?Q?0Uvu0iF4E0IhYiRk8gs2EnlkSTpMtLkl/Kebkg/jqfggzcEqCpEfuFLK4tUl?=
 =?us-ascii?Q?80YKckuhRBpwaIh+DeezPYc4hFIbDg98sQqH3QsoLQ5MS/u2Us5XTxGKCDMY?=
 =?us-ascii?Q?/B4uvgs3pf0vl8KMhpjVeJrifensxtTQT2hCdhrD5A9hIBluyIUrNZNs+3xj?=
 =?us-ascii?Q?zHYJm2IOonAmBQihcgCkM2Yp8asfEd547qoG3N7KUAE23QlfBrmcdj2L9oJO?=
 =?us-ascii?Q?Yif3Aedydhz5za3peqNBIKTIc+twA51tSmmIsykM3YjuCSw9CC0fq7wP7fAK?=
 =?us-ascii?Q?861k8zI4WoNtHvuji52nQY8JfeW5Nm6eaa9cZrQ50VZ1ww9MB7f5v/JpXwnd?=
 =?us-ascii?Q?xiLBMU4OpSMrFAZzX9r88YT+8mAR6w37tfEjdTPtxvRd7J/n/lNbT/lpRD4V?=
 =?us-ascii?Q?LEF2hUqDECnfr1bJvZE6qFYwfQ+66fr4qOf8EIGi22xjoS5BziZbQ59Qg+op?=
 =?us-ascii?Q?DTpEg47+xBHIDOPsHa0+AnYoFHtYVz+nOdjiTExSQFmpWd3dtRERnmQwvwb0?=
 =?us-ascii?Q?ppawCBUz4To6bEQM370uU/KFuQwZtiuxwd72/RklQcoKUEmhl2r1zO0FTwVP?=
 =?us-ascii?Q?2P9BaF5ifMS2BsJeiBBmSeOFvRcWby6NubFxU0sVFtp+2ZuA7TzHUPKiTxdj?=
 =?us-ascii?Q?4W0SPd3NNMrPYnB4VJkkSfWklq3RudVTy6OLz7Q4ahMWOkKCbW97Tr0QnJzr?=
 =?us-ascii?Q?nIWV8U0crFvIMUIyl2yW9eisIin84HsE/f/VH9eBx2htCNI2HoPAHo1ayy45?=
 =?us-ascii?Q?HX+hEhpLmNWVIqpZVYTFBLUj4fk/vNs3qXThh8M+P7CoTxRUN9lCMSzZ/N6k?=
 =?us-ascii?Q?GCq86p+VqvU2YogT+Eb64YRL2cxxwyIGQ/LxBLm7+7BnmD2YgWODHo4LXbBs?=
 =?us-ascii?Q?Oju6VKLehwQFSRhiq8t7zWIadlxGNjf6eDUfEOi1JMezL7xVYkiTGIoruXXn?=
 =?us-ascii?Q?IGHxK5d2uJoCrmC5YT0k68V7QnBXIWHsk9c+l3Jx1g4wsakFb7ONQOZMXWnx?=
 =?us-ascii?Q?gs+Ikg6zU8iywNC7/Uj1fL7vZy+FX3Tp8kwEa/X05V872JHtnLoUzAQd6c06?=
 =?us-ascii?Q?6Eod/dW3HBfJ94BuAC7HIegpXc1+0JBUdXvd6x1134BlKfCZdM1MCXtnL89r?=
 =?us-ascii?Q?qj3oqB/2nHoDf54BZeYcwSOv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93ec3acd-9039-4a98-d9e9-08d92af135d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2021 02:49:32.7073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KaoPUsmN3oXvfqoIn7e78KxHj1cjDkaD1R/1Rld4L9bIZHUYT14mVz97gW6QGmUx+rGx0G1x9mrRdNH1vcFiaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4852
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, June 9, 2021 2:47 AM
>=20
> On Tue, 8 Jun 2021 15:44:26 +0200
> Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> > On 08/06/21 15:15, Jason Gunthorpe wrote:
> > > On Tue, Jun 08, 2021 at 09:56:09AM +0200, Paolo Bonzini wrote:
> > >
> > >>>> Alternatively you can add a KVM_DEV_IOASID_{ADD,DEL} pair of
> ioctls. But it
> > >>>> seems useless complication compared to just using what we have
> now, at least
> > >>>> while VMs only use IOASIDs via VFIO.
> > >>>
> > >>> The simplest is KVM_ENABLE_WBINVD(<fd security proof>) and be
> done
> > >>> with it.
>=20
> Even if we were to relax wbinvd access to any device (capable of
> no-snoop or not) in any IOMMU configuration (blocking no-snoop or not),
> I think as soon as we say "proof" is required to gain this access then
> that proof should be ongoing for the life of the access.
>=20
> That alone makes this more than a "I want this feature, here's my
> proof", one-shot ioctl.  Like the groupfd enabling a path for KVM to
> ask if that group is non-coherent and holding a group reference to
> prevent the group from being used to authorize multiple KVM instances,
> the ioasidfd proof would need to minimally validate that devices are
> present and provide some reference to enforce that model as ongoing, or
> notifier to indicate an end of that authorization.  I don't think we
> can simplify that out of the equation or we've essentially invalidated
> that the proof is really required.
>=20
> > >>
> > >> The simplest one is KVM_DEV_VFIO_GROUP_ADD/DEL, that already
> exists and also
> > >> covers hot-unplug.  The second simplest one is
> KVM_DEV_IOASID_ADD/DEL.
> > >
> > > This isn't the same thing, this is back to trying to have the kernel
> > > set policy for userspace.
> >
> > If you want a userspace policy then there would be three states:
> >
> > * WBINVD enabled because a WBINVD-enabled VFIO device is attached.
> >
> > * WBINVD potentially enabled but no WBINVD-enabled VFIO device
> attached
> >
> > * WBINVD forcefully disabled
> >
> > KVM_DEV_VFIO_GROUP_ADD/DEL can still be used to distinguish the first
> > two.  Due to backwards compatibility, those two describe the default
> > behavior; disabling wbinvd can be done easily with a new sub-ioctl of
> > KVM_ENABLE_CAP and doesn't require any security proof.
>=20
> That seems like a good model, use the kvm-vfio device for the default
> behavior and extend an existing KVM ioctl if QEMU still needs a way to
> tell KVM to assume all DMA is coherent, regardless of what the kvm-vfio
> device reports.
>=20
> If feels like we should be able to support a backwards compatibility
> mode using the vfio group, but I expect long term we'll want to
> transition the kvm-vfio device from a groupfd to an ioasidfd.
>=20
> > The meaning of WBINVD-enabled is "won't return -ENXIO for the wbinvd
> > ioctl", nothing more nothing less.  If all VFIO devices are going to be
> > WBINVD-enabled, then that will reflect on KVM as well, and I won't have
> > anything to object if there's consensus on the device assignment side o=
f
> > things that the wbinvd ioctl won't ever fail.
>=20
> If we create the IOMMU vs device coherency matrix:
>=20
>             \ Device supports
> IOMMU blocks \   no-snoop
>   no-snoop    \  yes | no  |
> ---------------+-----+-----+
>            yes |  1  |  2  |
> ---------------+-----+-----+
>            no  |  3  |  4  |
> ---------------+-----+-----+
>=20
> DMA is always coherent in boxes {1,2,4} (wbinvd emulation is not
> needed).  VFIO will currently always configure the IOMMU for {1,2} when
> the feature is supported.  Boxes {3,4} are where we'll currently
> emulate wbinvd.  The best we could do, not knowing the guest or
> insights into the guest driver would be to only emulate wbinvd for {3}.
>=20
> The majority of devices appear to report no-snoop support {1,3}, but
> the claim is that it's mostly unused outside of GPUs, effectively {2,4}.
> I'll speculate that most IOMMUs support enforcing coherency (amd, arm,
> fsl unconditionally, intel conditionally) {1,2}.
>=20
> I think that means we're currently operating primarily in Box {1},
> which does not seem to lean towards unconditional wbinvd access with
> device ownership.
>=20
> I think we have a desire with IOASID to allow user policy to operate
> certain devices in {3} and I think the argument there is that a
> specific software enforced coherence sync is more efficient on the bus
> than the constant coherence enforcement by the IOMMU.
>=20
> I think that the disable mode Jason proposed is essentially just a way
> to move a device from {3} to {4}, ie. the IOASID support or
> configuration does not block no-snoop and the device claims to support
> no-snoop, but doesn't use it.  How we'd determine this to be true for
> a device without a crystal ball of driver development or hardware
> errata that no-snoop transactions are not possible regardless of the
> behavior of the enable bit, I'm not sure.  If we're operating a device
> in {3}, but the device does not generate no-snoop transactions, then
> presumably the guest driver isn't generating wbinvd instructions for us
> to emulate, so where are the wbinvd instructions that this feature
> would prevent being emulated coming from?  Thanks,
>=20

I'm writing v2 now. Below is what I captured from this discussion.
Please let me know whether it matches your thoughts:

- Keep existing kvm-vfio device with kernel-decided policy in short term,=20
  i.e. 'disable' for 1/2 and 'enable' for 3/4. Jason still has different th=
ought
  whether this should be an explicit wbinvd cmd, though;

- Long-term transition to ioasidfd (for non-vfio usage);

- As extension we want to support 'force-enable' (1->3 for performance
  reason) from user but not 'force-disable' (3->4, sounds meaningless=20
  since if guest driver doesn't use wbinvd then keeping wbinvd emulation=20
  doesn't hurt);

- To support 'force-enable' no need for additional KVM-side contract.
   It just relies on what kvm-vfio device reports, regardless of whether
   an 'enable' policy comes from kernel or user;

- 'force-enable' is supported through /dev/iommu (new name for
  /dev/ioasid);

- Qemu first calls IOMMU_GET_DEV_INFO(device_handle) to acquire=20
  the default policy (enable vs. disable) for a device. This is the kernel=
=20
  decision based on device no-snoop and iommu snoop control capability;

- If not specified, an newly-created IOASID follows the kernel policy.
  Alternatively, Qemu could explicitly mark an IOASID as non-coherent
  when IOMMU_ALLOC_IOASID;

- Attaching a non-snoop device which cannot be forced to snoop by=20
  iommu to a coherent IOASID gets a failure, because a snoop-format=20
  I/O page table causes error on such iommu;
 =20
- Devices attached to a non-coherent IOASID all use the no-snoop=20
  format I/O page table, even when the iommu is capable of forcing=20
  snoop;

- After IOASID is properly configured, Qemu then uses kvm-vfio device
  to notify KVM which calls vfio helper function to get coherent attribute
  per vfio_group. Because this attribute is kept in IOASID, we possibly
  need return the attribute to vfio when vfio_attach_ioasid.=20

Last unclosed open. Jason, you dislike symbol_get in this contract per
earlier comment. As Alex explained, looks it's more about module
dependency which is orthogonal to how this contract is designed. What
is your opinion now?

Thanks
Kevin
