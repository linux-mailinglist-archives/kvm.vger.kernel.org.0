Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178DE7C4798
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 04:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344738AbjJKCAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 22:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344209AbjJKCAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 22:00:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9757792;
        Tue, 10 Oct 2023 19:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696989636; x=1728525636;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BGlAKUlf56Ul4U3tCF9GWt83EN7a6gISN8SvxA+grZ0=;
  b=BJod8F65mspyW8j735mYboeccEOAtvaoH7seyT9oqI8OilLe3OiSCQK4
   8DmArKB4zjhV2Sa3RYwRD2d1rN8rFxB8b46PTxSE1Gv7QhSyiwoB0p4qo
   nuG+yH0EvVnR7zRVHXfkOkbsa6zA8mA3mhimVFb4s2v4Xmq8+T1OqsCz9
   XQbapyxH107KEiK4qq0w7jLp955FpOywVL5+3ptI1xn8IalWZIjfXCdvD
   iqVk6fxWX9I2uQpxD4vJPeTxlWarhu+oagzffHi42qxny2+uV54jpNMWi
   S/z5R0JYaSLldXsaUEr69gtUcmQCmLMuuwi2pUamxCOc6IXxIlY0Couuh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10859"; a="364841949"
X-IronPort-AV: E=Sophos;i="6.03,214,1694761200"; 
   d="scan'208";a="364841949"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 19:00:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10859"; a="747279662"
X-IronPort-AV: E=Sophos;i="6.03,214,1694761200"; 
   d="scan'208";a="747279662"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Oct 2023 19:00:31 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 10 Oct 2023 19:00:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 10 Oct 2023 19:00:32 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 10 Oct 2023 19:00:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5ho93qfinVP2c76HSsF8Ntv+2wXjbzW69mcwrKSUepjz4vZpZnA0uUiUfGjf2cJuBE+oFajYJ0/UT6aljzTQGbQDjn6ghKsEbtm9KbcgpEds6x+ptQkhdDW6VDRU9yVtsC5zggldXvMFgnLTtVO10zOxiUlMKwrn8rS95NyCAzfBkapHl3UBq++JbU1brCkPc7lqcNDz5IIRR87i6TVBP/DCbwCdfHpDVfF88H7yVRq1A4XwINKJin/7/MtA61SyKxJ5tymfYoHGe0x31YpbAvToDH9LhDXWh+jx2gbm9IQGtVI3RFu1OesIW1v1gdZdztbp0lwQnYXhnJ8vZaLEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BGlAKUlf56Ul4U3tCF9GWt83EN7a6gISN8SvxA+grZ0=;
 b=WwX6U1il9skxNCV87HzRKx/22sOWuXgW2WzqN7QExgG12KkMEYBMSMK3cv05v/I66bKavScYhlpeYZGCmYYWnAJMR9hp+yG0QSyH6lYsWIuLYvU90v1ITFJY9emecWSogqedtNbmdlzIgF+lkkYNLY+EKtPBxztX2dAWIxz6UL0R4CgIU+ti1yds43KlF7F7cL50hPC1wG/CW4KMOqTiRT8DTU82pa7hwWQc68uOrCFO8yU2Nao+1fJr/JmS2QM2dHJVNxXR8kU0/sQB0Xo/o5Ukkd9VunbkdLFOCQljZJtZSCwguY5enM6NztoskEAJc7BAlr/EtClnMB8tjcBP5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:95::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Wed, 11 Oct
 2023 02:00:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6863.032; Wed, 11 Oct 2023
 02:00:30 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "ankita@nvidia.com" <ankita@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "aniketa@nvidia.com" <aniketa@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "targupta@nvidia.com" <targupta@nvidia.com>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>,
        "Currid, Andy" <acurrid@nvidia.com>,
        "apopple@nvidia.com" <apopple@nvidia.com>,
        "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
        "danw@nvidia.com" <danw@nvidia.com>,
        "anuaggarwal@nvidia.com" <anuaggarwal@nvidia.com>,
        "dnigam@nvidia.com" <dnigam@nvidia.com>,
        "udhoke@nvidia.com" <udhoke@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v11 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v11 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Thread-Index: AQHZ+VwgDWGk0VCFcUeltplt5s48drBCtrFAgAAx5oCAAPC30A==
Date:   Wed, 11 Oct 2023 02:00:30 +0000
Message-ID: <BN9PR11MB5276ECF96BAC7F59C93B5E4A8CCCA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231007202254.30385-1-ankita@nvidia.com>
 <BN9PR11MB52762EE10CBBDF8AB98A53788CCDA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231010113357.GG3952@nvidia.com>
In-Reply-To: <20231010113357.GG3952@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB4787:EE_
x-ms-office365-filtering-correlation-id: 6e25c71b-bc20-4563-9ed0-08dbc9fdd8d7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FJqbOIXXJtw6T+Teu8t+3nHcAJNnc3NiJis3O3Uy7O3InCnsZC8/60LqzUDBPtTD4wWVl9zgjZkXkF6nQAYjyJWEmJm9+zsGaQXXX3cakogFj28jOAPasweDadoJX00ND4V/9/8zyC5UO7fYf/i0VedHYKY9G1nz4OGJ5zH77Y5WATbo0eU1qUnOI6eDayf7ISF2rwZr/mxAlt+gOLetDvzx4av/IlQFIVf6NaNryMwA8HR2X50ZUPdbeuLHL+Xsqs9IMLfFon/TIDk7xxpOkA4vxTx0izLzF29amqBJdC9rNZ7g8oA/wm23uGsbdEiwMOGf6odDErlSVUMd52ylPVYOxPODG9kaqupLZSxIt2KTtmJh4HWPQILsvmd1KiR0Ooiq+KJMQdDDN6Z/41XRMdqk7OjTjpbV8YVMMFjHSW1lMHTy6NfuMdYIJ0TuvcMxUuECogirDUE4MzCFnZOCDNyGfY5Irn243O8XyLXy+Y13pqBhUd90Hro5Tpb6nsOLnykY0a7gFSgYWSk5gh6LFlCxb5Ezh7P1i2pBCBpnykEG2N1aVdQo8kGDfOB7QQNdNoHEDMtDbWTJQLPivFp7inqTLv1k/O1O+H+8wwgFswWp+i4/xw6zC2LnTUj7O+RN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(376002)(366004)(39860400002)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(38070700005)(55016003)(5660300002)(41300700001)(122000001)(52536014)(8936002)(8676002)(4326008)(33656002)(86362001)(82960400001)(2906002)(7416002)(83380400001)(478600001)(26005)(9686003)(7696005)(6506007)(76116006)(71200400001)(64756008)(54906003)(66556008)(66446008)(66946007)(66476007)(6916009)(38100700002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5rhfcotzoGW/yB1HYvqfcsTm3PFx+Up8JG3iKTj7gI8y55Lc7lTZQTcwCOeW?=
 =?us-ascii?Q?tzROCsgzamrOOH82b3/YjM8LqrZhsX3xpPLv2AD5zeiU36GTBYucUq5lnPk2?=
 =?us-ascii?Q?Jns1IirjpftRPSMIoqOyRiQqEq9b24q/Y/yazOSrdujl1KRWWVq3N2C+wu6d?=
 =?us-ascii?Q?Ms6FNKxGigepCmufN0HlemIFM6VtyyDzuH3D/VAVL0hnmevolAl5TTmUeq0i?=
 =?us-ascii?Q?ZfrrxbRIhr1hJJqIFk4h5KVMelwMyGva4HSY40P8fUH11Y/vzCZVRn7ZwLZ4?=
 =?us-ascii?Q?C8PyDbGQHYxbQH+ju5SXYGZKr3JRmmh/jQNsAwiYHasDGEcBMUFoj68PDwm5?=
 =?us-ascii?Q?sOrEAgiirtB5uiUizUOGBhlc9CNkaIkCaL0pJ0eSLCOuitme4t72AfYTbvZu?=
 =?us-ascii?Q?f4ZI97TVL6kiqMk7MPGl968s2YR1LUUZ4TpRXdpU/887r/wELkYX6ACtCf9O?=
 =?us-ascii?Q?/OET1Y5Qi+feGw6IVj15E/hTg05YSh1w/VUgwM/b3zzw7BWa0b9NPQAaBzKO?=
 =?us-ascii?Q?XtJ0qmenTsCB5hpuiiOx4vr7EoPIpIuSR0cWwPIF1u6xMP1CzGXj5KIjiSvX?=
 =?us-ascii?Q?xFpcxNa9HEZHjlaVfzcEp+NXdlpwDyKERFIE9CJOGcFVVZ6g3KpzBMFzkL1w?=
 =?us-ascii?Q?r47KDyoz0CECTbXbviJIZVF9Z2u46bTMy6oXqLqneSBl7uC18dRS8eamtRXG?=
 =?us-ascii?Q?MB4WuwOUz9WChpjrCFmYIOw7j1sipsKAgl6IjtdX9wlEkLfQMKFe7Mw2tPzY?=
 =?us-ascii?Q?0gCng6c6rX35akHcTiJa/WP8gdEIPuMuvL61dDNMtL1+7S6x284efa7GdZge?=
 =?us-ascii?Q?b3AUesx2N8PzjW4kaZOJqGkzgMEV5JDd4t6598DE2z0egt/9cGM2YQ1OQg2q?=
 =?us-ascii?Q?AnbFhPTAhJaJ/0vT8AmESuYiJWoCEYku9zfqvijiW1V6v7a8/mx+w0xlBMK9?=
 =?us-ascii?Q?QMihTBO7tA1o3W4SPVjjEf27JXiBYixiVhebvY1AtmwHiJBHckrYzTuq4OR5?=
 =?us-ascii?Q?//T97WzVS4ek+RsSpc6do23DbHyb27uN14+oRXLSux/P3zODSBWuoCksn0mh?=
 =?us-ascii?Q?uUPKH2SBCtyYER8Yh944EMfEFlapcqFJyVAG6eHoeqdq0iHu8y42IzWCS5zO?=
 =?us-ascii?Q?RfMAIPwoUvVzTg7yXAwbqesrmSV3tVVpGSOh+QY2RHGjwWwE8DsqJ7tHjWKL?=
 =?us-ascii?Q?IN2rcxkffMmt17zc0qimJpDo8/fTCdQ99zx3Ti8oPczajYSwguXVMIkDNhP5?=
 =?us-ascii?Q?OxGplYh2uqAlJUCnCMXM9pvwMKSPetjvp+l3PzhVAK8pY9dTbbpOkRUm/fIJ?=
 =?us-ascii?Q?0lVRmdIcjpTaqEgsq7Hd0x5AohwSljmkUrmHJuTxRMivW3aFx/WDmycpnLZ0?=
 =?us-ascii?Q?3sbOqglmSmyUb7zMWnn5RlxvBiOfw6efcjV3KgaOgA0BHxGiBVYnRUCS4kFz?=
 =?us-ascii?Q?ox+WWbqVw8+whoWz0EpboTC2oAADGhpUKNewy+1nS8od1O/hNj3McejgPz8r?=
 =?us-ascii?Q?O1fvug8LRQgTnbF1IgWdw/kSsSAzAUESA40+X0FyiBPkV9Q57D+Bs+MVFGK3?=
 =?us-ascii?Q?JgRUokT6GetrSgKHu/zImKlGMIjVZEyn6m2z/WuG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e25c71b-bc20-4563-9ed0-08dbc9fdd8d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2023 02:00:30.4408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gkRYWFhe3HHHts+/GTXW0nA3LZ2NTAFHs8tEgYK6zz570sxoYdjQh1Vyh5mj03Dc41BtlV1sU4GP4EAuBYLIkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4787
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, October 10, 2023 7:34 PM
>=20
> On Tue, Oct 10, 2023 at 08:42:13AM +0000, Tian, Kevin wrote:
> > > From: ankita@nvidia.com <ankita@nvidia.com>
> > > Sent: Sunday, October 8, 2023 4:23 AM
> > >
> > > PCI BAR are aligned to the power-of-2, but the actual memory on the
> > > device may not. A read or write access to the physical address from t=
he
> > > last device PFN up to the next power-of-2 aligned physical address
> > > results in reading ~0 and dropped writes.
> > >
> >
> > my question to v10 was not answered. posted again:
> > --
> > Though the variant driver emulates the access to the offset beyond
> > the available memory size, how does the userspace driver or the guest
> > learn to know the actual size and avoid using the invalid hole to hold
> > valid data?
>=20
> The device FW knows and tells the VM.
>=20

This driver reads the size info from ACPI and records it as nvdev->memlengt=
h.

But nvdev->memlength is not exposed to the userspace. How does the virtual
FW acquires this knowledge and then report it to the VM?

One option is to indirectly decide the size based on sparse mmap info. But
that is kind of a misuse of sparse mmap then such misuse better fits to be
a device specific region as Alex suggested.

Did I overlook an important fact in the overall picture?
