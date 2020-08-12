Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05701242456
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 05:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgHLDfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 23:35:48 -0400
Received: from mga18.intel.com ([134.134.136.126]:37703 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgHLDfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 23:35:48 -0400
IronPort-SDR: vzWgV3GZDYxTaGPSx6usdHR7H14WxjrUzy5z/Aqg5bDFbyeGbBiy0RqRJplDrKbIahIx+Ir/20
 gnG/Al82Ap/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9710"; a="141492776"
X-IronPort-AV: E=Sophos;i="5.76,302,1592895600"; 
   d="scan'208";a="141492776"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2020 20:35:46 -0700
IronPort-SDR: zRnKIecbbxvlOBMwn4bP59lZVKSt6L1HvwLorTd/DWC3bpTiAPSYPk8ITlMg3DJTgbn50aFNK0
 X4mR40yLTQZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,302,1592895600"; 
   d="scan'208";a="290901974"
Received: from orsmsx606-2.jf.intel.com (HELO ORSMSX606.amr.corp.intel.com) ([10.22.229.86])
  by orsmga003.jf.intel.com with ESMTP; 11 Aug 2020 20:35:46 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 11 Aug 2020 20:35:46 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 11 Aug 2020 20:35:46 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Aug 2020 20:35:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLpr4vLz9vObUzqkDykC9EDQ4B5OeSDn2xdIMiKmDZ4tSgjtBJuSGx4KhlUVBi9zBB6sIXjWhSFJjMaxTtRkXwMTbknQM06Ze9B+1ytjd1055Y8DNC+Bd6XlVeu03rjq4Ze90F9lbhi3w4w5HTQUEBuNKa0s7rwcv2KjX5jKNa9t9rYpPq0Spaq/a4ItG436GavgwAcU3WkSLQgJRqS9CJUYFe8hoQdRCXFwW1KWJtdJHO1LVmYlR71X8/NQEPXSspZclf951DFocWNIkR0XPRSrdNrsLXTR9L7RH84XvGi+k221yknZbjKsLTBQjoOT5lTZ+mJM7fcnQJOm7IdMRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5o64O+z66IJsTsAJJosdgRdvPhnWXG7eApOu7cZ4nI=;
 b=W10ykzHA9tn+JMX1J9KsMGl465HQfFFg9+gwaim21ahZyGowDb90CHvu+Se6WBzQTFT2gwkiZXOKnIwDnBuJQPWOyL61ov5v22bKPyDVKQKaTJV1paRFkTk7C0M8qOXWzs1inl9z5mhB424c/qcavRPrTbnoqioOGb0hzA1dHiJK5Ad/pXSeacz7/N3b/wEUlChdkXuxO6oxcxCsufLTA6/AHt2dn4M3mTIb0RNf8dpxId/mNGmVOIMeEB7cbC7aQ6UYXl1gxIJBiBy7BdnfOtnkdvYe9ArLO2T21Wh76dzLCi18C7XtuE92rVs4zmnAhVxJElfc5gjt14kArT06lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5o64O+z66IJsTsAJJosdgRdvPhnWXG7eApOu7cZ4nI=;
 b=P7E6p5trOcAdHXF/gke///FMtAaILXpvNa7xVk5rxuwbuoKQHaytKxhzO/Sqs2XKWMmRssfkmrKabft3EoT2x5Qc0XwXcOttIdrvN0Rwxy8K3dV0uRJsUrf+QYsXvWzwYcQAVb8JL3s6k8hqyqBAutJXCegWdEKU6wmJO7fpQCA=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1647.namprd11.prod.outlook.com (2603:10b6:301:d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.17; Wed, 12 Aug
 2020 03:35:39 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c%7]) with mapi id 15.20.3261.025; Wed, 12 Aug 2020
 03:35:39 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC v2 00/18] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Thread-Topic: [PATCH RFC v2 00/18] Add VFIO mediated device support and
 DEV-MSI support for the idxd driver
Thread-Index: AQHWX3hut2htBlMVB0qfW0Pa+gZbC6kSPbuAgABwW8CAAzMrAIAUgAoAgAJJ4oCABDO9YIACZAIAgACUIGCAAAy5AIAAD1+w
Date:   Wed, 12 Aug 2020 03:35:39 +0000
Message-ID: <MWHPR11MB16455FFA478EFA54F728D9198C420@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
        <20200721164527.GD2021248@mellanox.com>
        <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
        <20200724001930.GS2021248@mellanox.com> <20200805192258.5ee7a05b@x1.home>
        <20200807121955.GS16789@nvidia.com>
        <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
        <20200811110036.7d337837@x1.home>
        <MWHPR11MB16451E4BEC7BF29C241FD69C8C420@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200811203618.41aa6031@x1.home>
In-Reply-To: <20200811203618.41aa6031@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.202]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f2dc017-2e19-4e60-b1bf-08d83e70c870
x-ms-traffictypediagnostic: MWHPR11MB1647:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1647E76B5B247C591808590D8C420@MWHPR11MB1647.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gDd60CZ2S/O4MxAOvHkLbgsgAAuBTCflVY6RKVymx0yEnK6X3rwkRBGOpyKlA0sSggHR2DFgmUqQ5H7kiK7apDQalFeYPbIQ3Ha5fKM2n7NamBX0nZm8/yKo1qPkUT9gWh466R0YkoocBLVrHiG3ynBKBultsDspX51Dtb/UPjfs0KjAzEQYRYIJmlc+kBsz8o7Gu7h4NwHWvqeBsivaKM6eidJkR84YrSXv9hq/W4Jv9DvX1PYy5kNQY3uCfjUKPImOoJXKdm1ASyOCEdS8PruW8vUsxhNokogA+L8T2zc4D5RlLsoUIa2/9IMDxGiXgBKAxArPmQ4hn1ZWhf/B3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(6916009)(7696005)(7416002)(9686003)(6506007)(26005)(4326008)(8676002)(76116006)(8936002)(52536014)(5660300002)(478600001)(33656002)(2906002)(54906003)(55016002)(186003)(71200400001)(66556008)(64756008)(316002)(66946007)(66446008)(66476007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ZwrlrQkm5qmGf7SjwShgxUO1LSF4RhT2KN6Qifn9mSMhik2bfPbVcPyRAK2VXh8POtUOt7Lenea8VwAYAT60icQ2Xmh1WBUgcItLJ/ozLShuSI7rgns5VLQwkpFw4aWUCSCr5nYrQ2ONleE6d0TD1OIxZ5ZL2joZcJ/U+deqIPF4aZqB/dITatwTbPRDkXpHgMZh12F70xqtBTbNy/QlKNMqNQkrA6UpXdFVXUNtuR/1hFReAnowkfq1PEWNz68r88FzS0vvlGdsvCeG4ZDt90w9DytA9Q4ZSRvO8ys//zYkZuOHZYc9RgQ4hvUemdbEr4KWs5pl8k8INXglKInSkjAy3xf9vCP5ihlJrm3e7c6sfC0gJQ/uUJmWE2fhuZKVng/swMduB8BmG7mmOxUDluFiumbPHEEYqVl8kNW0+esvPNLYt4lrb/1YXT1WcsLxcQDV/EBtCxvMmzVFpDlsEJRaYBZPBVUHXTEAeALwfbHiKwwoIuKjeMr0W8xRaG03iC6F0zG1b7D6JAIhS5cYgR2qs29AkAp9728/tT5lCP7OJ8NJYuIylA7HXrixRPEYxlIU7ZtfRC0YgarmxAKTbXuzXqkiIsUqmolFPRSXjPmtwHxpbOsG8yd2X73M7yEy0Kg7hsJKgPMHi8ylLJS+qQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f2dc017-2e19-4e60-b1bf-08d83e70c870
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2020 03:35:39.2113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z4YDs/1+15MIllGJcXucg9I+e6sLBICd1kR6SQG3Y9yQvMi4ZbyNdbnDeXdHwahj6TvZ2CTe5wSI5a92ci0Y+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1647
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, August 12, 2020 10:36 AM
> On Wed, 12 Aug 2020 01:58:00 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > >
> > > I'll also remind folks that LPC is coming up in just a couple short
> > > weeks and this might be something we should discuss (virtually)
> > > in-person.  uconf CfPs are currently open. </plug>   Thanks,
> > >
> >
> > Yes, LPC is a good place to reach consensus. btw I saw there is
> > already one VFIO topic called "device assignment/sub-assignment".
> > Do you think whether this can be covered under that topic, or
> > makes more sense to be a new one?
>=20
> All the things listed in the CFP are only potential topics to get ideas
> flowing, there is currently no proposal to talk about sub-assignment.
> I'd suggest submitting separate topics for each and if we run into time
> constraints we can ask that they might be combined together.  Thanks,
>=20

Done.
--
title: Criteria of using VFIO mdev (vs. userspace DMA)

Content:
VFIO mdev provides a framework for subdevice assignment and reuses=20
existing VFIO uAPI  to handle common passthrough-related requirements.=20
However, subdevice (e.g. ADI defined in Intel Scalable IOV) might not be=20
a PCI endpoint (e.g. just a work queue), thus requires some degree of=20
emulation/mediation in kernel to fit into VFIO device API. Then there is=20
a concern on putting emulation in kernel and how to judge abuse of=20
mdev framework by simply using it as an easy path to hook into=20
virtualization stack. An associated open is about differentiating mdev=20
from userspace DMA framework (such as uacce), and whether building=20
passthrough features on top of userspace DMA framework is a better=20
choice than using mdev.=20

Thanks
Kevin
