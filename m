Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093933FB928
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 17:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237567AbhH3Plv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 11:41:51 -0400
Received: from mga05.intel.com ([192.55.52.43]:43616 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237187AbhH3Plu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 11:41:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="303874716"
X-IronPort-AV: E=Sophos;i="5.84,363,1620716400"; 
   d="scan'208";a="303874716"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2021 08:40:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,363,1620716400"; 
   d="scan'208";a="466151168"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga007.jf.intel.com with ESMTP; 30 Aug 2021 08:40:55 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 30 Aug 2021 08:40:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 30 Aug 2021 08:40:54 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 30 Aug 2021 08:40:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLkXqn6/vkOzaScw0W9wEklyj4zAHu/l4qIEV6N3UXoVy9mECksWvJmGLl07rPqIxrcBLo7rAGSNxlaMSdSCJrHdAAY3k3xPFv4uIEf6Asqm8cxPlb0USkBSHAK7gbpwi9dbVaPD6sPrGvlKZQfnjUqag/0VGHddqzttqp9m+f9WPpUgm6vJyNnaNNCcWAtglf1d0S7vTs0R1kvYlwNAnagkWmz+w0L9BRB8dwCfMcf7ykLlZes63mK85fj4sMFpPFD6iLn173yuLDUrBg6eZEPFKOezYuoeAhM+qL9WLPQjBGy5OR++0vzB2/RkiTllLGbawLLW3SGHkU0iafr4+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgf/sAQDv1MpyNvWnCOdRuiQO+k/BcM+xzy8/DkPNdI=;
 b=PyvV5TfPFVWQfK6K+7KhGq29DrRzv8w+YfrmC4W4evxFzVd23YjR9ttSFl1eZA/ABxA3tVCODVIKaXG9Osha9UMfVQwJl2eP/CK1lmRhsQ6zqPuq6h6sPDtEKT6B7TFofwUnWOOK4ESeicycJVmxU/Lrk8BM690psNulBpLX+7URA334/cW0yzryFzDpqq1yMk53SBBHUmWhBISV3wVcj5vrlyFjvZ6NqxP+foaEVYO+/FCYPYll81oQOs86FwwpSJ/vw+VgigEhtMr1DFfuErxuROGv28/aG5S8TLTzcOEIUfrikAR7f5qZuFwlZIZoCaXoghczYokHPRL4ylBp7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgf/sAQDv1MpyNvWnCOdRuiQO+k/BcM+xzy8/DkPNdI=;
 b=X1aq+DngkvcfSpnX4iMzhcEZIegoIQASNNghps+cOymxlnKVkT6S29s1SzrWp1P8qDLjC+eYo86CaaURMPTtaodspWm29VpNhsvzwdJpNK6dvjs0PssKJK6b5w35yHGkQmNMl5XigZxb/LQbPeoWyLD/vh6gw2M2vSF0DTSx+gc=
Received: from DM6PR11MB3177.namprd11.prod.outlook.com (2603:10b6:5:c::28) by
 DM5PR1101MB2236.namprd11.prod.outlook.com (2603:10b6:4:58::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.17; Mon, 30 Aug 2021 15:40:53 +0000
Received: from DM6PR11MB3177.namprd11.prod.outlook.com
 ([fe80::1801:b765:5ffd:d121]) by DM6PR11MB3177.namprd11.prod.outlook.com
 ([fe80::1801:b765:5ffd:d121%3]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 15:40:53 +0000
From:   "Xu, Terrence" <terrence.xu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
CC:     "bhelgaas@google.com" <bhelgaas@google.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "diana.craciun@oss.nxp.com" <diana.craciun@oss.nxp.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "michal.lkml@markovi.net" <michal.lkml@markovi.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [PATCH V5 00/13] Introduce vfio_pci_core subsystem
Thread-Topic: [PATCH V5 00/13] Introduce vfio_pci_core subsystem
Thread-Index: AQHXmmaz1ZiP+FI92ECDLhV+GQ7uqKuGXIgAgAXXhpA=
Date:   Mon, 30 Aug 2021 15:40:53 +0000
Message-ID: <DM6PR11MB3177A7D59FAB8EE420F14BC5F0CB9@DM6PR11MB3177.namprd11.prod.outlook.com>
References: <20210826103912.128972-1-yishaih@nvidia.com>
 <20210826162108.4fc8b844.alex.williamson@redhat.com>
In-Reply-To: <20210826162108.4fc8b844.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 000256ca-1bdf-4b07-5de0-08d96bcc8d14
x-ms-traffictypediagnostic: DM5PR1101MB2236:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1101MB2236689271E2C40494E88D99F0CB9@DM5PR1101MB2236.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mgoiCLes5+aaluH2TIIiBjkLh+HJJpCvqQsQOjv0SPcXri+SMWaLy3Berc+BziFX7vr2vwaqeX6p0KdhsTOJRRcriyQ830EOLd6OKkeZ9ij+ACfWMBORCl7gt6NxJmfR6W7I3E5zW5FXxQ0iLPucbRsm9a0OWS2enBJHdjpdXL6b6/Bb/gHhFAT66JO0mw9/vcEtoxT5axTEm7XdwnF1Nq85cHWKpfDvpQsN2hiksaWd+GdD8RDfI4p41G0gzYEScyfUuZSOs4QtOeayMnqH+vWA61lTT722Of7wayyD6gTMLJvVN35ovEu/nBuYg644GWKumUumwl/9cntWa3M3k0W0K4Ks2Cjub6PtYcay8GGn7f+e61EkqIhceffThuZ6rMChbfKIFg4ZbnABXtSQI2c+fSlBMn1Vf+AX4+SZXxHWTlK407NXz0Y+SLmpDMMxTb07XuLEhMccol8HX1sKgJ0yWP5F1MkkejsoSCmaHS8JBP7owkQcLeTCdRTL5yprRSjhqXT2qyRBuSRcck29CmMjUrrdHce3CH5tl9N830HqxWbjWIU8f+JdPBIWAPmQa+QjqyIqvvsfjsZYC1YM2MOchJ6tUToUslO6dEckZGA0dWq8MLklZdiIT4QcJ4rLjXry5iiT65UwntFn8e2WtZpRpZJFkI7znDf4He0qbJOExcxC4FBnVJSa8FVJ82TnurqoQpyE/rv+ogZaJkwgFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3177.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(38070700005)(33656002)(86362001)(316002)(54906003)(110136005)(7416002)(478600001)(64756008)(7696005)(66476007)(122000001)(107886003)(83380400001)(52536014)(71200400001)(9686003)(38100700002)(5660300002)(6506007)(2906002)(55016002)(186003)(4326008)(26005)(8936002)(8676002)(66946007)(66446008)(66556008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a4fBqYTYrMKhJkR1fvFbGYwjRmwMUJGh7aKVqYW52Cs4dnx4hydy9R/rPcFW?=
 =?us-ascii?Q?h6JRWHZThpANxfqaNTRA7UgTuRhFfAfDiBPq1B0cAZBflOtAUXSexqVOne6O?=
 =?us-ascii?Q?hv/nu8fk8QA5oTo1d5fLEVrjkvtxGCkINSILbcWOpHNQeb961ahgFWvOm9Yh?=
 =?us-ascii?Q?WufS6hrj+H4ssG1aE6zbPgX+HyGhwc7qh9hWnQkdctlKlbr7Uh7MNKlk5HgV?=
 =?us-ascii?Q?FLg1OhAaZnER52pKFBB2cLp941+IZbFOrsTmyC1F3GC8ba6yothKY3DEHoQi?=
 =?us-ascii?Q?I225ZexI/NnBBSf0XoF4tCT1WlcbdUug3GSUuN9vtyHyFzMOADsTfzEI0IsJ?=
 =?us-ascii?Q?GYSxrJf2Mlv1URs3wtrIRCR/D2pivju8gzw3cReUG+hLnUCxq+MA7R7Dfsz2?=
 =?us-ascii?Q?8S9mhF1HZxsXn+40DPUwh1uh5jWfyA+l7/r1K5XVkwvJdB0zsxSuGr5fllNa?=
 =?us-ascii?Q?RHIsTnYKOSgP4TdjB7MFZ9OqivTVp8hpmiPkOPr82lx11PBV/6o14Jm0bdVP?=
 =?us-ascii?Q?JKEaBYXdwVD4qdwJKwySIT584SR4dfiZPgCXUymDh4JRAb/Ne2cZETDLZN7G?=
 =?us-ascii?Q?LMyN24B0oEvvVvez5MzX1Khmf+dgtIL6zMX6KqdLe02Zskw21EFNf2qTrjxV?=
 =?us-ascii?Q?ZVHrl/E4u0r2JTRuAGvcGgABHf4baCTI3Q7ivLBfL7wq0p3E+MWnGUFf3Trb?=
 =?us-ascii?Q?Ad6Doe7fgv0da/OXjj575uhlj3zq48LIW/xo5DClBK/7lJmzIRmvBOOm0hWt?=
 =?us-ascii?Q?U5G+DRyGpb3oPJZsUGMeLDFGJ2sggz/OdXl0V/WhfneChQ/WXyGp0GzhJeBh?=
 =?us-ascii?Q?DQ1/MkXqD+DbvICbmCqOrFYpuA43m0cL221xHmcjkmw2KAgThj28+yUOUt1E?=
 =?us-ascii?Q?n7KvYQrUaCCQZT1olIfdmvOf8tfqjst/5X2y1fxqaWT8MvFLxvz5Ppy8Xr3+?=
 =?us-ascii?Q?UWysCA7j1Z5jce18eHPVGmQ3RMjQrN62HWhQ2CfBXxN7BADfs+ITOwrYbd7q?=
 =?us-ascii?Q?qBRkLETkZaCbmogsoSbDssRd4l2XFbT8bXllSErROSxEjyQxpR3JYygW5ck9?=
 =?us-ascii?Q?9WKVF7KM6Xsd7KwIddfLvqtu0NQlHLCiDw7p8FnL8AuXluQEIK9LK2bC77ir?=
 =?us-ascii?Q?0X4a0kicYAQmn8n7vJfeDF3K10+GP2RNr0f7zVlneRo3OdnCu+vgSMM3e+bK?=
 =?us-ascii?Q?b9KQvm+HZ4wthKvXNJiDiQx+kptRcsq0+1yaRP1NuOGDSSNiO5y83VMBh1vU?=
 =?us-ascii?Q?Z/2t9GTIKs4iM65u0IQ4lPfUpqkBibn35nf0jv/42/hPdKcSJr9Ko0M7nGqd?=
 =?us-ascii?Q?f2PQBSAQ6HY/l0KBdna7V5SL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3177.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 000256ca-1bdf-4b07-5de0-08d96bcc8d14
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2021 15:40:53.2589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V9T4fscDXU4zfe3OZsOQIOPmA9zno2sH4nY/peT4foMj05Qd/51iafjRkuJWAlPu5cFQwgNfXPidb6PH0yeSjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2236
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, August 27, 2021 6:21 AM
>=20
> On Thu, 26 Aug 2021 13:38:59 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
> >
> > Jason Gunthorpe (2):
> >   vfio: Use select for eventfd
> >   vfio: Use kconfig if XX/endif blocks instead of repeating 'depends on=
'
> >
> > Max Gurtovoy (10):
> >   vfio/pci: Rename vfio_pci.c to vfio_pci_core.c
> >   vfio/pci: Rename vfio_pci_private.h to vfio_pci_core.h
> >   vfio/pci: Rename vfio_pci_device to vfio_pci_core_device
> >   vfio/pci: Rename ops functions to fit core namings
> >   vfio/pci: Include vfio header in vfio_pci_core.h
> >   vfio/pci: Split the pci_driver code out of vfio_pci_core.c
> >   vfio/pci: Move igd initialization to vfio_pci.c
> >   PCI: Add 'override_only' field to struct pci_device_id
> >   PCI / VFIO: Add 'override_only' support for VFIO PCI sub system
> >   vfio/pci: Introduce vfio_pci_core.ko
> >
> > Yishai Hadas (1):
> >   vfio/pci: Move module parameters to vfio_pci.c
> >
> >  Documentation/PCI/pci.rst                     |    1 +
> >  MAINTAINERS                                   |    1 +
> >  drivers/pci/pci-driver.c                      |   28 +-
> >  drivers/vfio/Kconfig                          |   29 +-
> >  drivers/vfio/fsl-mc/Kconfig                   |    3 +-
> >  drivers/vfio/mdev/Kconfig                     |    1 -
> >  drivers/vfio/pci/Kconfig                      |   40 +-
> >  drivers/vfio/pci/Makefile                     |    8 +-
> >  drivers/vfio/pci/vfio_pci.c                   | 2262 +----------------
> >  drivers/vfio/pci/vfio_pci_config.c            |   70 +-
> >  drivers/vfio/pci/vfio_pci_core.c              | 2158 ++++++++++++++++
> >  drivers/vfio/pci/vfio_pci_igd.c               |   19 +-
> >  drivers/vfio/pci/vfio_pci_intrs.c             |   42 +-
> >  drivers/vfio/pci/vfio_pci_rdwr.c              |   18 +-
> >  drivers/vfio/pci/vfio_pci_zdev.c              |    4 +-
> >  drivers/vfio/platform/Kconfig                 |    6 +-
> >  drivers/vfio/platform/reset/Kconfig           |    4 +-
> >  include/linux/mod_devicetable.h               |    6 +
> >  include/linux/pci.h                           |   29 +
> >  .../linux/vfio_pci_core.h                     |   89 +-
> >  scripts/mod/devicetable-offsets.c             |    1 +
> >  scripts/mod/file2alias.c                      |   17 +-
> >  22 files changed, 2525 insertions(+), 2311 deletions(-)  create mode
> > 100644 drivers/vfio/pci/vfio_pci_core.c  rename
> > drivers/vfio/pci/vfio_pci_private.h =3D> include/linux/vfio_pci_core.h
> > (56%)
> Applied to vfio next branch for v5.15.  Thanks,
>=20
> Alex
We verified the Intel KVMGT and GVT-d KVM feature, no regression be introdu=
ced by these patch series.
Tested-by: Terrence Xu <terrence.xu@intel.com>

Thanks
Terrence
