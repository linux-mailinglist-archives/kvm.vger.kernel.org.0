Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D25D689180
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 09:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbjBCIC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 03:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbjBCICR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 03:02:17 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACFE1B30C
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 00:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675411265; x=1706947265;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3zGpA/OObAYI5Gxb0erPDZG8oxY6HLyKHM2clpr+euc=;
  b=hPT01sq2n58cg8jFBjO6NYPlRkKqO4Ox5pWpAojY/0GK4sGv7pkla79s
   f+jZuQNny9L6OlVEb4ItsXcuCL+4aujHZPx21Lsc+QLEPALw9tR7BT4BC
   yA+38BLiR3rIYWJ/g+Nd//1pvRmcnniHDCzqERULb5gANrVQcqrtOY9Pw
   iwEcAlmxUnhC2mdGYIOWIeQ2OagQWneKk5Cb57NTcBbcZb7CrMKgMKoDB
   Eu86PRa2YDR8htY+6JeVXBV4URSnGoNj4nAoQYxqrndcRVGhQTAhs6dTf
   3aT+uFsr7RUbIpJN3Zw4BTiPJkm3DryTRyAoRu17vA0o8+DdQhdlbW/04
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="309021283"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="309021283"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 00:01:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="734249728"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="734249728"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 03 Feb 2023 00:00:46 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 00:00:46 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 3 Feb 2023 00:00:46 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 3 Feb 2023 00:00:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TF5DfxuaRrvZi9nYRmBxHwsAmqENnf52syjCWYk9OxrZGbP8po41RoGqfrVP6lt91BsbQuRKmSaJ5eDTAQLGOnHDKdNWpJQt/t+SRxq5yYFEEy0LfJoLK5CJINKXnSyKXj/4o4CyGLo03X80qVO2WrPNBOn1I4hkL5EfkZsWPtse4W1oQBrAZnCZzzC/AsDO3wpTuqy3bElcL+gwF+26RR7vKRr6WVn/IFWnlSMGTgpo/ECMcEYb4i8RpYwkY11ZT98bRBdDs1hvjSeVam27YldkcgYcznUEdELFlrMFn32k1mqBcegFC6PnAS0RUoUZVq43k/kkQ2e61ghKZSY2Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+lTWlde/UPUv1C0xqxTI91kMkiplWNsNjHzEl0FJI4s=;
 b=UycqiWB6iT5I59XwNUAfJ5HjyXfT/96/3fvR5teUjDNAiK1XamjiDRDde3xp7eluavj1Qio5NVc4H7otpxMkK6NqlEp0TcXTYjAkCIuL5vZRlHuuTqzwG2Mkd5jqB4QbpJwtKe3LorUJzKBlQwv/wOjbeO78TkNGKBTjX/k7w+/4tsNP3KgUFJbXg2sA1fgU79bXnu5+DdZ6R2LAnd2CY0+mz4y93zYd271xcu374CPCEtbZ76NFn2jy8ILWyGFaKUh1iBevLLuBFhZiRmtSZL3ep1Q0M/q9JUMNXJCKFdOPQJ7dGITqlGZ1R5/OnO6jHn5WKghjKk4O/Cv4Td+oBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CO1PR11MB4979.namprd11.prod.outlook.com (2603:10b6:303:99::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Fri, 3 Feb
 2023 08:00:44 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6064.024; Fri, 3 Feb 2023
 08:00:44 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Topic: [PATCH 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Index: AQHZNtymfc/0mKQcj0e603kVKITxmK68Nf0AgACnTrA=
Date:   Fri, 3 Feb 2023 08:00:43 +0000
Message-ID: <DS0PR11MB752909747178627015241ECEC3D79@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230202080201.338571-1-yi.l.liu@intel.com>
        <20230202080201.338571-3-yi.l.liu@intel.com>
 <20230202150110.1876c6a9.alex.williamson@redhat.com>
In-Reply-To: <20230202150110.1876c6a9.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CO1PR11MB4979:EE_
x-ms-office365-filtering-correlation-id: a6d5814b-22d2-462c-4ab2-08db05bcc042
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jXsxDLGfoJhrS4ESCGXpFG5txyqyERANv9jylGXaoMLUSp3fPDcbMkjhQ6G3OvQzVdBei1Vz3Z8S9mpz2WMi32UTCLUTJr11IS404axQgx7arRkodXr1b+ZHgEOUOBDQhR5VTZE127JldibnyGWLbOMU2mNtVW1fyM90NymaZYTTL5TQlIzmto6L01kjVwNjU6jeMymainZt0fQEZ4ac/S9BD65vN6ckKAnB5OjAlWjIBUQLVjyvAXwX8Y6ldI4hU0FKwEOR+aDZImp2BM+wljzf3VMnI2g/QxiSiP/TfsNKjw7ohmuQZZfWOISGQ65DRTPsdmysHBYnO+lPL11rCeeNifci0oG5fmQXdUKSxq8kXcnhZDWF9dR8NbsRsnoYSIdX4N/XcDrIBNoJBVT4jeTSCSCS6+NR75FNuBt0Hz0veStWnWcgQq5ACF9Va1J/oZyyvyfVy/bcXw+4WolOvOY+SfGFDyZIF3rCt+WcGFQO6LtmlwjSfxCMGPt8I8dfVsJ9bA77yXFBmJ5KjCQCE4v/xDawxssKhq49o7PdTM2gpny5ADBJcc/PKIln7+ltF9qyGG/zTuyRSx8eamqoZ5LXto86zzwE7RwA5wnIgIDoPrRStgf84ecOVTf/d2x8eQI1ePFQTq0uUZ3/hPbjsZtOTEQ0IApVOX4llYFzQ02wTg4f8y9zT65anF25VOJFuC5vbevfR8sqhh/VZ+IGvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(366004)(136003)(376002)(396003)(451199018)(71200400001)(64756008)(66446008)(8676002)(66476007)(6916009)(66946007)(66556008)(76116006)(4326008)(52536014)(316002)(54906003)(5660300002)(8936002)(4744005)(41300700001)(2906002)(7696005)(478600001)(186003)(6506007)(9686003)(26005)(38100700002)(82960400001)(122000001)(38070700005)(55016003)(86362001)(33656002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XYaL9JyCDp3I7yIw83IalwJkojHpKoR7zxdLiSBhNWOFMDqghxNedmesXGVw?=
 =?us-ascii?Q?Vt58MaUt+POx5GvyOV/24BXfUdhg0FVqijsvOWFkXelOm7Wk1d4Wwn1wUr2h?=
 =?us-ascii?Q?npyKzyHAwH84hGtbw2Uil/Mb5zUlH/VHt4oGy4XmKzxn41lCMPfmeNWHMqoS?=
 =?us-ascii?Q?ykL6eoA3ETNNMq+H46QBVYEDMTK084v2gZtNna1t695xh/FCObfvYGPlw1Av?=
 =?us-ascii?Q?Ux94codBPiH/yBo+yug7P3J7eimlcHNErJ9WlPqSQBrDEg0JOqqcxrStjqf2?=
 =?us-ascii?Q?3BZQnTBf/uzLLMAahk3OK4Sqi7BmmuEpyPhE42V5GFNpA15Zbbr8KfeZg2DF?=
 =?us-ascii?Q?dy4Rb+lR8YTyJ8Naj6v/s1ENIsbs/ksD1ee9r0NR1aRWPJEoYcIcp5q9tyTe?=
 =?us-ascii?Q?/FZc9OZG7FdSk4Bs8y1K5b5eeU89Ck/665fK2BQxZ56LrfTzdJpUT/tB14+Q?=
 =?us-ascii?Q?qxTsN69JFo1I4lvbb/iXcvRd4qKyP4J6+elfWv8L7wlYMmxSahtZ5RgeySBV?=
 =?us-ascii?Q?d9uGlvTpUJANPV7aqEMoed2Zb5bxSxcypPnuxSTygXabcJxy5EdiGhOY0Ivf?=
 =?us-ascii?Q?nK2Jr3gFw+TLzcqA+SsHSfkCgqG9Eev3qaOHL+kBSpeakIyGbva8VFa22nLb?=
 =?us-ascii?Q?WsEVA3+f5Aqbs1JOhM8M5bYot8fFwvG7UDxIF/97qwRRQC7Ssx27SAfVUFTH?=
 =?us-ascii?Q?F3oxeZasBs28jdACWyeCJtyOI4Slp8cr0DOQhIKFz4dace1vrHNEFVZl3be2?=
 =?us-ascii?Q?NLaIA/UJQ4XpexhdVrHmZ9ndbLHGajepM4BNuiCMpKGDXlxvNWxQuQLkJZL6?=
 =?us-ascii?Q?AYpLo2BL+nPQu6LkFYehl/uK4DWgZWojb5qe7hPPk2gfiu4GTaHohiBQNl8T?=
 =?us-ascii?Q?BA/fBSV22GXtzyRdxeus89w4g63R5AoiM/QDRM31+B9CJCWAWYgQazt92i29?=
 =?us-ascii?Q?vJwc6gJfnPdzsktxlBV+2eCveDzrguZqZ9LFmS83Je6I3VdxHEiWRo9fT+y9?=
 =?us-ascii?Q?Ct+reTUt9MKXuVzFU3uIfLpruXHPoQjZhS3hc8ozJkbmrc2ldCl+SRC+Is1r?=
 =?us-ascii?Q?Fc+0M9xkLcG26S/R+z4MxvZNW3M9h2Br7u+223Prp0Jno3jEi9nggzC3Yeab?=
 =?us-ascii?Q?8WAr5LyWWt3LfWnrRV8URjIxAxeIIsqeh07Rb6WUABlAy8mwpHPgTyoe2veI?=
 =?us-ascii?Q?XgyVL9ufuYh4wjBEP8J4p9cxu8L2u5CsmWKw2fl8F1X81crT2hSHxbQTzhrH?=
 =?us-ascii?Q?VXnqpwpNYcuDjf5RWtldcEEuGo34RAhYwuTn3EKI6XDmM7VF43370Wr3YBOs?=
 =?us-ascii?Q?qKl/VJR/41zkv4eY1fJKgRQfZJI6J9vrO4lb3UktdtOHecGK6dKg66MGjVco?=
 =?us-ascii?Q?B8KrZifrPXtDJBO/+py9v6qFMgxYMJBnl2c7H1QBgeUSyHlXmLcxrUP/jvaC?=
 =?us-ascii?Q?CRvVBTYP5ihksZ2sbUanYT2xKVgesIshL4WEsxe427IzzUu34YI+bJDRGoTy?=
 =?us-ascii?Q?Y4VvcxYfxKl+eOpA1jCwF0uZNgCi71zqB+oUTlfcVrUPuNnYUphx+RevTzSE?=
 =?us-ascii?Q?DXhOckzywC+Lh/wRjonJReNWYp1uW1CBRS2GsB5R?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6d5814b-22d2-462c-4ab2-08db05bcc042
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 08:00:43.9992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DhD/FxyLD8FOgsWLhaEeWnf/w4LzR3NamnY1d0M6ToAfp2gYVNvIz8P++/+nQ54nMcKHPNbQ3vOz06VQRlFqFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4979
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, February 3, 2023 6:01 AM
> On Thu,  2 Feb 2023 00:02:01 -0800

> > +in the vfio_register_group_dev() or
> vfio_register_emulated_iommu_dev()
> > +call above.  This allows the bus driver to obtain its private data usi=
ng
> > +container_of().
> > +- The init/release callbacks are issued in the drivers's structure all=
ocation
>=20
> drivers' is the possessive of plural drivers.  Thanks,
>=20

Yes. Thanks.

Regards,
Yi Liu
