Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E073B3C18
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 07:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbhFYFXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 01:23:42 -0400
Received: from mga04.intel.com ([192.55.52.120]:11496 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhFYFXk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 01:23:40 -0400
IronPort-SDR: dS+vjrFfPlS4PVqHTSC91cOXFGLlNb3F4KTNnNBmWAuyW/uIPpUDIaB2wP+uEw7Rqdtkt8I6wA
 ET23v6hjpwxw==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="205784007"
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="205784007"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 22:21:20 -0700
IronPort-SDR: pY1rn2+yFwurYEEZusyAcMIbYAL5gNGeSAySVygwhPQlEZa/LtSF5sLmquVg15OsP7JQTpe5GH
 hRvS6lLleLKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="491433661"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga002.fm.intel.com with ESMTP; 24 Jun 2021 22:21:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 24 Jun 2021 22:21:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Thu, 24 Jun 2021 22:21:19 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 24 Jun 2021 22:21:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjdhTQtyOmNKeeweXxANE3vnYCDfy3aCeL/v2+xjZXDIyKzFsSbxk8xpKRqHJ+aYDNxxqz+Ioc+wBqrfKeo0H3i6Z78+3VrSGB6lU3FMrQlCRIWZCETqnNeMr5YVixsQlXIt4c9XpZOVgtKMpYA9Jkpt8cFCGZdSH6oHn46VzbBrfvPUESSE3FMBc/AORkKyrDv8vWpP7HRA6ieczc1/W4jtpQnU2fBs1fvOK2khBButl3PfeS87E3wsG/pKhhtMAENKCYA5cbPHMeX4y8xs/ecxSm/51t0ixO2DouxGhKhLHK9jV10Whe6wEVsW6N8luBp4gHsWC/u9zOuNAEF39A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+v4YLEKy884bj/K5/sQayDqVFHmLHv7ZaOhbOfNkXzU=;
 b=bLNHJIFL09tcJ33iYwogZtU+mE5E67dQ66+lnMKdoMd89Ew3FL7qj1HtbGZd+NQ4B1A4CmVGt/s0W705Enk6T3p5stK+NUbX1lGBoK0vIRo8LergmClQL0rVZAvBnUzSAUpC8QZIbxLXXTS69arZiqD8i2u0S72s1+vXpCBrjCwUN/T+gU1cJ39bB6Lfd+8xkP+PlHeMqoEh1mkjdEseV5Cr2qnVHHggT8+tCG6OLKO0/MBg3VIw7olReOlQOJ0Aom3F9uxHb9Tg16J3tk3JjIXUN8btLEYE60cjtcENzAA9Quwdod3VPIJb8660gZsvShCNrnc3aVSqcF0EeCBrLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+v4YLEKy884bj/K5/sQayDqVFHmLHv7ZaOhbOfNkXzU=;
 b=w7P6Y7Nn3R6wGwZOxot07DBpDq7iTMSlbXnieNqCf/xWbik9C/Xh2DyLhp8Dzm32kU6tDrPCkPv1lRk0YAzH7voa0LtBSUmFdzp+LcNoYDdlTck2SCFM2RAkDl9r9hWAP7s3Fgc6CBOOHHewes7k3+dbT1FHqWy/W/XC9UJbBk8=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN7PR11MB2596.namprd11.prod.outlook.com (2603:10b6:406:b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Fri, 25 Jun
 2021 05:21:11 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::2539:bbbd:5109:e36a]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::2539:bbbd:5109:e36a%5]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 05:21:11 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        "Bjorn Helgaas" <helgaas@kernel.org>
Subject: RE: Virtualizing MSI-X on IMS via VFIO
Thread-Topic: Virtualizing MSI-X on IMS via VFIO
Thread-Index: AddnMs7+4GfLhTceT8q8tdV8716lmQAZ7UiAAAoHBgAACsXtAAAX4LwAAA2wIPAABLctgAAACLXQAB0q6IAADZ4hAAAOY4tQ
Date:   Fri, 25 Jun 2021 05:21:11 +0000
Message-ID: <BN9PR11MB5433063F826F5CEC93BCE0E38C069@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <MWHPR11MB1886E14C57689A253D9B40C08C079@MWHPR11MB1886.namprd11.prod.outlook.com>
        <8735t7wazk.ffs@nanos.tec.linutronix.de>
 <20210624154434.11809b8f.alex.williamson@redhat.com>
In-Reply-To: <20210624154434.11809b8f.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.143.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8f5ad9d-169a-4cfa-1267-08d937990bc9
x-ms-traffictypediagnostic: BN7PR11MB2596:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR11MB2596621B0D3708F777175CBF8C069@BN7PR11MB2596.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j13+/9qnU7fQXAojmnsyaHSCa3kyglZPMeTVWVvccDM41ZWk3Zt9/dYXnIghE/ml2EVoRYWrrGu2frcFKz27xIrw9hk1WfOKj8cOIZWQZGi6Wt/Zfi6U0ssNAlRiUTUNJvWfqtjfpA/IuW+66f00qTy1qkjJoYC0i1pXsLX7x1V3VvFU7uEzEWrmUKsKw3iNcsRzgaQnUDL+kTAOBDy6pksSYfZQPZd8GHIcGF2xZt4cgnOVcO44b1lC+NTeUyNxzrd6TANwSsx2lzw5CEockniewTPh7NVb2XwYXTeNIn5mp8h/DAvSfzffs/DVYukdjvUhepcPqkEuZ6mrz6t8OEfuCrPGZBuTF5tfHqbfOImRtUu4frSz2E97J2zhgMXHBCGiOBopZJv/8Y8481ENZcaANEkPkdSbFJHu355yhQ42MPIV/ARIKhCFRpcQtxIk3cysu4lfqRf+C+4YEmsp/XuTkFdnR7xAWeKRRw7j7Ng/1zgrAW+VM4LGCGHs2fx6CHN181Pq+ZQb7NaiSmtxx+B9MnpZA3p5A9UkEIxxD4EiYBwcrFPbD/nbWcQbn01tsFUN2GI2dCZXaX00lglDmsVWksoH9yR4GvhHAojEbRUvFQP9PUS8GzONz2i4EZ7FlvBbSeAbXeXC+wl0KL6GR3R7MhnBfscEhO7glofQ13MUs3VRvalVsUdlH/fMdpacZPv4KZoOd8c7XsgAT9hEvRggmfRJn1xdEpE4pdTyr3c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(39860400002)(396003)(5660300002)(4326008)(122000001)(71200400001)(33656002)(55016002)(52536014)(9686003)(316002)(7416002)(86362001)(66556008)(64756008)(110136005)(66946007)(7696005)(186003)(2906002)(83380400001)(8936002)(38100700002)(478600001)(26005)(8676002)(66476007)(966005)(66446008)(54906003)(6506007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SymMrEmzYyhclrL2oKYjasxO1vwW2riu1BEH1KE/evqU+I4fF75ah3lqrr8p?=
 =?us-ascii?Q?DT0XeFO0Fns0fun5i97VxjQq1yyOR/+GUOX789BOCKsXd3XPOFPa9Bazs6if?=
 =?us-ascii?Q?nbPyQICmkEQqM8IlMIQGmQVHLuR2nZsxzq7dacU4COxs/Ltede84/3VCMUCb?=
 =?us-ascii?Q?YToccPewPNJdwxI8i5qba+KvzO3RtWcJLwcsucstS6NYkbL+EA+FLu2rJj3U?=
 =?us-ascii?Q?0j/M1oGOSloHcfPXE6SFpb43MSIrMlvjPo1Al8o+e5GonDZguGg6FBGUlW4P?=
 =?us-ascii?Q?mpHezcUazvhmqA/Oa/mMZNCSifUOJmEpFIJ1VigTmjGSFO1+hCFnXM8zNgzD?=
 =?us-ascii?Q?OJdysLXt4DrxZ4njX1kEceFZlrJRg1R521CFUGU0dH0iNhygei7XFSwmuuCK?=
 =?us-ascii?Q?ytKILJiecg8SM1q66t3oYEFtovPMFRYlYB0/AXQjc8TWJsDZb86BU113TMzS?=
 =?us-ascii?Q?sOWSaQ601auCstFBPiuzNo4w01HH9TdId2I/1Fkq6nFJHIwm9rHrRjoNMPCF?=
 =?us-ascii?Q?a5/Ac0DsDOe0lIaNkMppEEu5nWdBVpjHGNlUDzK/Q8QS0K//tS6aGVZOb68j?=
 =?us-ascii?Q?NbMj+FcOCxKiu1j17b2J8lu0yciblxqvNUm5urbvMtFY+LuMq5ae5YccQTg8?=
 =?us-ascii?Q?Zis9hQuBrHC8V/swk5roc1NpJMN4s/Rec+4NSBZkgBs2jfrSpSMuqKBqdyQg?=
 =?us-ascii?Q?Rnxmy2WrK0blRxnddrcQh6jg1/5PqIep+JzcIz4LdbIMdWuOsiCV7CagcMQK?=
 =?us-ascii?Q?ktzgodC9zpy67N0Pp7YkPpvfXJvub4QqneHPR3OcLwDjMc0+HV9RuXJcZboH?=
 =?us-ascii?Q?FRkLmPQMUd9lIaYOabBpApc1EzYcIOqWxehJoxZk2IMpT2MrJhwvDbQIAWLf?=
 =?us-ascii?Q?UdzmAaphdBxy6D+SqTBahT+jneBcA0qCqatfQCENZf7bPk8xzrDEq1Ze9Uc7?=
 =?us-ascii?Q?HUJkFtPLpfOCrIy+zG94LMG7zIoZwjsXZeW/YeGSJFXoDm7LmuNjDO90bSkA?=
 =?us-ascii?Q?mYDrUYNQ+b0gvB+Y7vErBSPNEfZp46QOYVBhwkMU7Fgu7EePHhwrR2E4byV9?=
 =?us-ascii?Q?A6C3WgeU0cnD5/u/QC2KiGawzvuozlixFcMY8Asg9pIicAw6oAF2duLrAG7K?=
 =?us-ascii?Q?+w4H4Knxb1xvMWQQYcVgdTaSqygpwgUS6RDIZzjnovq4A3fOetLUXBOB9N+/?=
 =?us-ascii?Q?IhD1STMLaW75ZZY8+RDDptR7XCPhu23wRf5hjN/ZRnhse6OulbzRjdHUXd8a?=
 =?us-ascii?Q?ichUzefSmkkSQKvIbjsZ38DmS2CEoNYyXJ1Rrj8S307xUjBNhOSCO8+mrfET?=
 =?us-ascii?Q?TWJVXiWUhxiufPWUmFZKI9Xm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f5ad9d-169a-4cfa-1267-08d937990bc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2021 05:21:11.5781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NjM6nhVyPK7n2Q40RaF1Iww3KTQByxARddLyJViLIcYrBw1VuDiNVIsYEMNLzr3m5hn/LsJH+E93GnWV0LgvLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2596
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, June 25, 2021 5:45 AM
>=20
> On Thu, 24 Jun 2021 17:14:39 +0200
> Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
> > After studying the MSI-X specification again, I think there is another
> > option to solve this for MSI-X, i.e. the dynamic sizing part:
> >
> > MSI requires to disable MSI in order to update the number of enabled
> > vectors in the control word.
>=20
> Exactly what part of the spec requires this?  This is generally the
> convention I expect too, and there are complications around contiguous
> vectors and data field alignment, but I'm not actually able to find a
> requirement in the spec that MSI Enable must be 0 when modifying other
> writable fields or that writable fields are latched when MSI Enable is
> set.
>=20
> > MSI-X does not have that requirement as there is no 'number of used
> > vectors' control field. MSI-X provides a fixed sized vector table and
> > enabling MSI-X "activates" the full table.
> >
> > System software has to set proper messages in the table and eventually
> > associate the table entries to device (sub)functions if that's not
> > hardwired in the device and controlled by queue enablement etc.
> >
> > According to the specification there is no requirement for masked table
> > entries to contain a valid message:
> >
> >  "Mask Bit: ... When this bit is set, the function is prohibited from
> >                 sending a message using this MSI-X Table entry."
> >
> > which means that the function must reread the table entry when the mask
> > bit in the vector control word is cleared.
>=20
> What is a "valid" message as far as the device is concerned?  "Valid"
> is meaningful to system software and hardware, the device doesn't care.
>=20
> Like MSI above, I think the real question is when is the data latched
> by the hardware.  For MSI-X this seems to be addressed in (PCIe 5.0
> spec) 6.1.4.2 MSI-X Configuration:
>=20
>   Software must not modify the Address, Data, or Steering Tag fields of
>   an entry while it is unmasked.
>=20
> Followed by 6.1.4.5 Per-vector Masking and Function Masking:
>=20
>   For MSI-X, a Function is permitted to cache Address and Data values
>   from unmasked MSI-X Table entries. However, anytime software unmasks
>   a currently masked MSI-X Table entry either by Clearing its Mask bit
>   or by Clearing the Function Mask bit, the Function must update any
>   Address or Data values that it cached from that entry. If software
>   changes the Address or Data value of an entry while the entry is
>   unmasked, the result is undefined.
>=20
> So caching/latching occurs on unmask for MSI-X, but I can't find
> similar statements for MSI.  If you have, please note them.  It's
> possible MSI is per interrupt.

I checked PCI Local Bus Specification rev3.0. At that time MSI and
MSI-X were described/compared together in almost every paragraph=20
in 6.8.3.4 (Per-vector Masking and Function Masking). The paragraph
that you cited is the last one in that section. It's a pity that MSI is
not clarified in this paragraph but it gives me the impression that=20
MSI function is not permitted to cache address and data values.=20
Later after MSI and MSI-X descriptions were split into separate=20
sections in PCIe spec, this impression is definitely weakened a lot.

If true, this even implies that software is free to change data/addr
when MSI is unmasked, which is sort of counter-intuitive to most
people.=20

Then I further found below thread:

https://lore.kernel.org/lkml/1468426713-31431-1-git-send-email-marc.zyngier=
@arm.com/

It identified a device which does latch the message content in a
MSI-capable device, forcing the kernel to startup irq early before
enabling MSI capability.

So, no answer and let's see whether Thomas can help identify
a better proof.

>=20
> Anyway, at least MSI-X if not also MSI could have a !NORESIZE
> implementation, which is why this flag exists in vfio.  Thanks,
>=20

For MSI we can still mitigate the lost interrupt issue by having
Qemu to allocate all possible MSI vectors in the start when guest=20
enables MSI capability and never freeing them before disable.
Anyway there are just up to 32 vectors per device, and total
vectors of all MSI devices in a platform should be limited. This
won't be a big problem after CPU vector exhaustion is relaxed.

p.s. one question to Thomas. As Alex cited above, software must=20
not modify the Address, Data, or Steering Tag fields of an MSI-X
entry while it is unmasked. However this rule might be violated
today in below flow:

request_irq()
    __setup_irq()
        irq_startup()
            __irq_startup()
                irq_enable()
                    unmask_irq() <<<<<<<<<<<<<
        irq_setup_affinity()
            irq_do_set_affinity()
                msi_set_affinity() // when IR is disabled
                    irq_msi_update_msg()
                        pci_msi_domain_write_msg() <<<<<<<<<<<<<<

Isn't above have msi-x entry updated after it's unmasked?=20

I may overlook something though since there are many branches
in the middle which may make above flow invalid...

Thanks
Kevin
