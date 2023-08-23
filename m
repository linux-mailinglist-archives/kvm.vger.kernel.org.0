Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA99785C2B
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 17:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbjHWPd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 11:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjHWPdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 11:33:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754AECF1;
        Wed, 23 Aug 2023 08:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692804803; x=1724340803;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1X8VwHf1dBNY2O2fwr05k0tcNFpXF867HhQa2pODef4=;
  b=JQzBIAg+49XaS/J3jNLUSl/EdZS96FLKeYhckDizs3MTG2Khjt821H7h
   uLC7Ix5U3Erauk7XKwSB7QCDRuCNsD1TaFtgZLOkMAKVG555QfMiW49p8
   +aZ1eW2GPWBq8aXqlpGFDrP9mYC6I1ZmHPjGYPj5IJbDi29QaBbs+POth
   2vGX85URNLnWRTKfaRhE0L9i94Vw7/2N0Vz/rcZ9oHKtsABoT0Itusg99
   CnE0PDhStH07YR9QRuCR4ktXE2WnPLCm5OIuLRdY7CCTj+eBrboZYu2z3
   v8rhhH9SQBR/SNeUHGYyiDfKFnOj5cq7dt+RPOh6gVmq1SFvpvTuZrmrk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="359180209"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="359180209"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 08:29:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="983341998"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="983341998"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 23 Aug 2023 08:29:50 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 23 Aug 2023 08:29:49 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 23 Aug 2023 08:29:49 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 23 Aug 2023 08:29:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6eS5vTTYBwRHOpm09WSGSaUw/VK5e+EgR5usB/mf8XQEe3jR0IsUo3VOOfh/TbFzsuI+NfuGJGlrPodzmQ+IhBVDQbvMq38MPxMq++AqNlstjkYARRuMmS2U1WAbTfJ4he2JGn9EZcVFuGcqCOuseJZT0ZMYpJJGJ8MoRAAiSDWARgCXP6Rpq4/pPH+u3V7jaduPjZssPAL94/f081C1qCFtNGwgyHUXzL5b3F463CzvVvOtPVyV3UVURISKb8ea7fPENAZn//AJrvR+6U/7KSnowsUPGUl8+GnQabhY7X1iFY38qgkO986x7WQYXLKST/yowc6SzF+z/cir9guog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xseBlK5q1dSUPSttTx7IVtP1hWtpj8PLZhyVZGYCowA=;
 b=aER4/VSpr3AqxWoodUb/De4V64umCS1l7TFlMhyjAPkmkWhrHdXg16kK6pAzQ03WT+lHv4gKlYawtqvs4H7sQr9pWHEw0MNZJA3jJ8jN3twUBD7xjS1+Eu/8BUMYdNkpNjyYxh9/Tk4KeN0PV6HZHghs7tWnuKocfg6+RFHu8dfOqOCt+FHNAc5nTlaAWhsF8c67fQmvJ7aq6fAIFg+KAmiA6YrnQGSfeXoO5R0z+0VSQ+5sKt4n3hq7e+tEq/Qx4EcqLgCyQkvRwlBcmYzKEreIitUhX1mqxEof6o7NcjnUogI4zHhgC5sAf66xsrs4JR1qZJa1CYfXzUkC1F7hMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23)
 by SA2PR11MB5019.namprd11.prod.outlook.com (2603:10b6:806:f8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.26; Wed, 23 Aug
 2023 15:29:47 +0000
Received: from DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::889e:2c90:67be:2005]) by DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::889e:2c90:67be:2005%4]) with mapi id 15.20.6699.026; Wed, 23 Aug 2023
 15:29:47 +0000
From:   "Zeng, Xin" <xin.zeng@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Cao, Yahui" <yahui.cao@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [RFC 5/5] vfio/qat: Add vfio_pci driver for Intel QAT VF devices
Thread-Topic: [RFC 5/5] vfio/qat: Add vfio_pci driver for Intel QAT VF devices
Thread-Index: AQHZq1VcBEuBLxaWQUiMZlgj/qpcxK/MmosAgA026DA=
Date:   Wed, 23 Aug 2023 15:29:47 +0000
Message-ID: <DM4PR11MB550203FB22F8D6F0EAF8F717881CA@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20230630131304.64243-1-xin.zeng@intel.com>
        <20230630131304.64243-6-xin.zeng@intel.com>
 <20230726133726.7e2cf1e8.alex.williamson@redhat.com>
In-Reply-To: <20230726133726.7e2cf1e8.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5502:EE_|SA2PR11MB5019:EE_
x-ms-office365-filtering-correlation-id: e4b54046-60b7-4cd7-b899-08dba3edc907
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZoMciYVQcBqc8eZcBBI8MBG+W3Ul3rEec5rL+HosFvqGdR8Z9/tlIezAkQjOKot56ulGVMwCi61U0O2ytVfbmWSA5fc+F48I2k+GCmtsqZVSB9wODXRbkDn5xkZtZzMJ/TpXY3K0/y/jjgfKCwfqbPxTawB/qt3ChOVtNjDr8di2DXBBcLm16ewrYujQAfE2lJVvqU/Z6g9b/i58/xliMCgbI/DsAnemakQQB+vHrTMP8Xvz0H8XIZmEl+X7ORS9wH2LiB/mNzf21jc6HSBAdVsZOuNlfEjTysOjU5ksdm+SAH1B9TTWGjvww3iHUgH3I37Sq8oQlbGqqh5EKe+Lid7S2FVKMU7KOrgIePfM9a1G2slYmaWw4ATu4cgqKA20uNXJkZvF4indO1O/YjwPnprDG11HjPBS7ZIVkQ0ZON5BlTBUtvVbb8Hcecm5ndodME5OF1+RipJJAz+RSjjWctJgutpdFggUd3yQ3uXWW3qxixS178aRMm7A4xN4odBf4hF7nyFP6/cJaTkOcXmlFRG1FjezxYH2lA36s7tTAc4lJs1pNYheb7tFMnQFjLuhQ5YDV8yoXeVtrBiEGDCKgaf8YJF5E170AhNHu7WA5GNwt6W1aeaZwdXaTZiTOfh+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5502.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(376002)(346002)(366004)(186009)(451199024)(1800799009)(6506007)(7696005)(52536014)(316002)(6916009)(53546011)(4326008)(8936002)(8676002)(66946007)(54906003)(66476007)(66556008)(76116006)(64756008)(66446008)(41300700001)(55016003)(9686003)(5660300002)(71200400001)(478600001)(83380400001)(86362001)(82960400001)(2906002)(33656002)(38100700002)(38070700005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7G2ornb53yI2sBlDR5jwy3OGK68g+catDcTHC7aHHPKfmTTWVUnhyvj2JJzd?=
 =?us-ascii?Q?bkmjat4AWnFfhdwfqjKxyHoheah7KNqcHyGubTBiQqL8vLkkrAxGjLllihED?=
 =?us-ascii?Q?kXlpE7ziUhhMfAiyuu3zmy5E3ZfGafnJsq1sI9CfUiAPvA30ZyweNuFnnfwH?=
 =?us-ascii?Q?mYj6fK8g9SBAWNuBZXingfU1U4jQQwz0M1tlKLOlaqomfm8LlTjT9N7GHdvn?=
 =?us-ascii?Q?XDBNFmlwxo7gpYoWtt4metIpdUXLr8YPd7wzDW5H2xnUk9wMXoeti/jAvIpr?=
 =?us-ascii?Q?RXCZfSO+DKFhOVRd+la9rkc46p/C7jQw9ANw37ea+MVcOZUKHYfR9sVnqMD6?=
 =?us-ascii?Q?dqR62oiQjaUokSrXogOYOvNHBBYaXx2DyAtwZJkxyE9bTva9jG/WP4lhD78e?=
 =?us-ascii?Q?I0qU9VlzcQUq5Wy/xKVM8pNDi09fxAr+wIdbk+FHOTeWSQssR08NLI8NTJ/e?=
 =?us-ascii?Q?czsNpZqTmnlDdK1aovPDyQGYnplPdyIzUstoe9U/+94Bc2zm6PcJeNndRltc?=
 =?us-ascii?Q?7huIf7GPlYv8wTDZl2YKaKkEHM+3g0tCn0SJnnRw/AL3I5kYgXwE0Y+NIVee?=
 =?us-ascii?Q?idbKcROMF5rRabtrlj6lTu9HcgWeuLqpXllqB0tKYNjIfYoA6HNcOJ1BeoGN?=
 =?us-ascii?Q?d+eDj+dqA8iJO0pLj48zDJ8xAyJ+3PoXWylQfu9ZwQqZtdcXBpgWwSCX/n1b?=
 =?us-ascii?Q?4hAjkg6CHzWJYH4Drlw1dwHcsnqRqX2AImHAigQx4td/gbF9T9V6LG9DiPek?=
 =?us-ascii?Q?bIQxYEJf7a7TqobgkzGSYUjG1e4kxe3qMX4cE+iYJkJ79HQSkywjRLBVHi4i?=
 =?us-ascii?Q?cgppKm3XGS0DvJ7es2Xkl/aaoD/BWz1/8USmm3CI3hq50MqrFshoRcwrFufW?=
 =?us-ascii?Q?Azt41EU/cA03LeoX3eGrvc7rJvwHWI0eHoIO7oLwJwP9edv9suYdDMCxIISi?=
 =?us-ascii?Q?hili4evHTP8NtQDnHbFQm7/PCsYAv3SdeLwConHVYZiB8cv/X5Yl3E6nvV9b?=
 =?us-ascii?Q?yBME40K8acaM17KmCWpklbFHGi5l1E+o3aNPFo1U7aXd6oOpk6BwRiT4cnA4?=
 =?us-ascii?Q?Wzv5pg5yene6LTQ66qdtrQia/EbUsxKlWsoBcV3BA5Oss/ZssJnO5CS/JPFP?=
 =?us-ascii?Q?Owxrxl+AZu0ifrbGPL1pa3LH2aA9pj+U+oA6162+K+heCqVBlQOkDXTvJnDe?=
 =?us-ascii?Q?K/425Ox3xGGsAgxk1cviDOOaEUvZQtBjbRLe6Ui2jO8FX3VXbKcLH+s2rWJE?=
 =?us-ascii?Q?pL5a4t0uUdchYIg6y/VnjRpPKh5hb0GNc1DFyFPhmxEZ+ZiFMDGgcj6vRTh0?=
 =?us-ascii?Q?J0mdxyf3gUa8ylHwOzYBBPKl5bhgFh93tHJKu6VFd6kIBR5NouOb6wPAoSjN?=
 =?us-ascii?Q?fr+YvJEsQ9U0DcB9h7oA4wq7v0dqW1vr9IKhtHbk7RZ3kDh5us6G2VqkI7kU?=
 =?us-ascii?Q?ILqV+D0NnkW5muE/fuVlAA/XTsvnh9GpvKbDIvoXb8lMlube60AokQp76U30?=
 =?us-ascii?Q?MVEdvF+8VxSbrkeKBbq8VX1dvkhbremETzjbfSsuBAaLphm2nXH6QzJGTw?=
 =?us-ascii?Q?=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5502.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4b54046-60b7-4cd7-b899-08dba3edc907
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2023 15:29:47.8227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BASmIRNIblHcXNyCPJDKiuyLwidvPS1mW4xI59pb9PPrCR/sqkhoit2d/EByADX7ntgdtDyFt8JdQLZjXJoluA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5019
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for the comments, Alex.
On Thursday, July 27, 2023 3:37 AM, Alex Williamson wrote:
> >  drivers/vfio/pci/Kconfig                 |   2 +
> >  drivers/vfio/pci/Makefile                |   1 +
> >  drivers/vfio/pci/qat/Kconfig             |  13 +
> >  drivers/vfio/pci/qat/Makefile            |   4 +
> >  drivers/vfio/pci/qat/qat_vfio_pci_main.c | 518
> +++++++++++++++++++++++
>=20
> Rename to main.c.

Will do in next version.

>=20
> >  5 files changed, 538 insertions(+)
> >  create mode 100644 drivers/vfio/pci/qat/Kconfig
> >  create mode 100644 drivers/vfio/pci/qat/Makefile
> >  create mode 100644 drivers/vfio/pci/qat/qat_vfio_pci_main.c
> >
> > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > index f9d0c908e738..47c9773cf0c7 100644
> > --- a/drivers/vfio/pci/Kconfig
> > +++ b/drivers/vfio/pci/Kconfig
> > @@ -59,4 +59,6 @@ source "drivers/vfio/pci/mlx5/Kconfig"
> >
> >  source "drivers/vfio/pci/hisilicon/Kconfig"
> >
> > +source "drivers/vfio/pci/qat/Kconfig"
> > +
> >  endif
> > diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> > index 24c524224da5..dcc6366df8fa 100644
> > --- a/drivers/vfio/pci/Makefile
> > +++ b/drivers/vfio/pci/Makefile
> > @@ -11,3 +11,4 @@ obj-$(CONFIG_VFIO_PCI) +=3D vfio-pci.o
> >  obj-$(CONFIG_MLX5_VFIO_PCI)           +=3D mlx5/
> >
> >  obj-$(CONFIG_HISI_ACC_VFIO_PCI) +=3D hisilicon/
> > +obj-$(CONFIG_QAT_VFIO_PCI) +=3D qat/
> > diff --git a/drivers/vfio/pci/qat/Kconfig b/drivers/vfio/pci/qat/Kconfi=
g
> > new file mode 100644
> > index 000000000000..38e5b4a0ca9c
> > --- /dev/null
> > +++ b/drivers/vfio/pci/qat/Kconfig
> > @@ -0,0 +1,13 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +config QAT_VFIO_PCI
> > +	tristate "VFIO support for QAT VF PCI devices"
> > +	depends on X86
>=20
> What specific X86 dependency exists here?  CRYPTO_DEV_QAT and the
> various versions of the QAT driver don't seem to have an explicit arch
> dependency, therefore this shouldn't either.

You are right. Will remove it.

>=20
> > +	depends on VFIO_PCI_CORE
>=20
> select VFIO_PCI_CORE, this was updated for all vfio-pci variant drivers
> for v6.5.

Will update it.

>=20
> > +
> > diff --git a/drivers/vfio/pci/qat/qat_vfio_pci_main.c
> b/drivers/vfio/pci/qat/qat_vfio_pci_main.c
> > new file mode 100644
> > index 000000000000..af971fd05fd2
> > --- /dev/null
> > +++ b/drivers/vfio/pci/qat/qat_vfio_pci_main.c
> > @@ -0,0 +1,518 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright(c) 2023 Intel Corporation */
> > +#include <linux/anon_inodes.h>
> > +#include <linux/container_of.h>
> > +#include <linux/device.h>
> > +#include <linux/file.h>
> > +#include <linux/init.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/mutex.h>
> > +#include <linux/pci.h>
> > +#include <linux/sizes.h>
> > +#include <linux/types.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/vfio_pci_core.h>
> > +#include <linux/qat/qat_vf_mig.h>
> > +
> > +struct qat_vf_mig_data {
> > +	u8 state[SZ_4K];
> > +};
> > +
> > +struct qat_vf_migration_file {
> > +	struct file *filp;
> > +	struct mutex lock; /* protect migration region context */
> > +	bool disabled;
> > +
> > +	size_t total_length;
> > +	struct qat_vf_mig_data mig_data;
> > +};
> > +
> > +static void qat_vf_vfio_pci_remove(struct pci_dev *pdev)
> > +{
> > +	struct qat_vf_core_device *qat_vdev =3D qat_vf_drvdata(pdev);
> > +
> > +	vfio_pci_core_unregister_device(&qat_vdev->core_device);
> > +	vfio_put_device(&qat_vdev->core_device.vdev);
> > +}
> > +
> > +static const struct pci_device_id qat_vf_vfio_pci_table[] =3D {
> > +	/* Intel QAT GEN4 4xxx VF device */
> > +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL,
> 0x4941) },
>=20
> Should this driver depend on CRYPTO_DEV_QAT_4XXX if that's the only
> supported PF driver?

This module has not any dependency to QAT_4XXX module at build time, but it=
 indeed has implicit
dependency on QAT_4XXX runtime to enable SRIOV and complete the QAT 4xxx VF=
 migration,
do you think we still need to put this dependency explicitly in Kconfig?

>=20
> > +	{}
> > +};
> > +MODULE_DEVICE_TABLE(pci, qat_vf_vfio_pci_table);
> > +
> > +static struct pci_driver qat_vf_vfio_pci_driver =3D {
> > +	.name =3D "qat_vfio_pci",
> > +	.id_table =3D qat_vf_vfio_pci_table,
> > +	.probe =3D qat_vf_vfio_pci_probe,
> > +	.remove =3D qat_vf_vfio_pci_remove,
> > +	.driver_managed_dma =3D true,
> > +};
> > +module_pci_driver(qat_vf_vfio_pci_driver)
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Intel Corporation");
> > +MODULE_DESCRIPTION("QAT VFIO PCI - VFIO PCI driver with live
> migration support for Intel(R) QAT device family");
>=20
> Or at least one version of the QAT device family ;)  Thanks,

Will update it.=20

>=20
> Alex

