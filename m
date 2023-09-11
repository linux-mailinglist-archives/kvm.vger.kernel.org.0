Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D887179A350
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 08:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjIKGIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 02:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjIKGIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 02:08:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155C1EC;
        Sun, 10 Sep 2023 23:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694412522; x=1725948522;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ommxphXmMSSCHvkzr4vQdax2d1IVytBgM1Vax/Xo84M=;
  b=WY8LpfLrE5S3IcqmFZ1pkbEK0hZ6/KXGcuD0A3sQ9HtFNvQ9NxLBysZI
   ZF2v4ivHMHVPl1l/DIthuaFS0HXdpL7EtvwPMPHK3YsHkz3tBLBfq9YvP
   pwRZLYx1yVzksTQv32/DgtcLUxowARs0/97fATebDMFw1EfJ7KWmmMBO2
   UIkblQVc4b1MzghkMaRsMWaR7LjKrurdERaItOOHCYexeQMqAjFQm9TVi
   E9K61jILL265H2KewTS1Hax9TGbJwPe1qvHStq/eIDun8BNzfJMZJlchT
   XoY21hKyz7b2NQra050XrsCS/mnU80tN0HlPbIEVb/ZfFsnB4gne5ee/1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="375357344"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="375357344"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2023 23:08:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="743219170"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="743219170"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2023 23:08:41 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 10 Sep 2023 23:08:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sun, 10 Sep 2023 23:08:40 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sun, 10 Sep 2023 23:08:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6W2inOVwITIN49M7qNozNWMlA1+21Norz5t9VjDn2znElug/d6uBpYlVymS3QmKYwXzJfS7BiSLP6SR7lyJ16eFKU550qugFPTK2sdiMMJg0Ty5gt9jla+u0lJQmBpsp2uBdxabUDrouM7bvaBJ7Y93Qct+/C3pD15VZsKy6Zc+Bi9DyYqwdc9d5NFMdEq/k6svFCwrPMGj0/QCkkdODU1bt1cKHc2wHB45khiLqXIe0nRiBiBfn5PVvlcEH5HRRDm+p1+oMZE4wPEwE/cQQGyEwVLHmmB9EMbGvZPd6eYH6am0HjtXVmB33haLdROaRY+pz8wDtIwQ+KFfYlfjYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ommxphXmMSSCHvkzr4vQdax2d1IVytBgM1Vax/Xo84M=;
 b=f/R5XevtehQhhjG+eyXcfnwoL7nze0v1pT9OGGDVUbO63crC48c0E4Y5rJcypWSPHIfao7pTuLEv9UGJ4OkEwktRVm+tTrd5K+ZApojLJDl83OTwnu1WdRR9ZJQbASUbIUDjdX6tZLEElHY6KYKVEWXcZfv3tr1zL1ZTo+fY36rgE9hZHgcGs5PWKLy5gt+bagn1Lh7tBKJGJLiNs0YG59yPz230ZE4tX3IgSQ1u6lK8bJtVwwN4Qgcso75SsO6Z+qTG1932/PAYGchaA1mqk7gCAdRI5paV65uAtg1vF0PUAHY9ea6JqKmPO+ZtPjHaxF/vx/W7NUGpBbev8juiFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB5989.namprd11.prod.outlook.com (2603:10b6:8:70::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32; Mon, 11 Sep
 2023 06:08:38 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323%7]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 06:08:38 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     David Laight <David.Laight@ACULAB.COM>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH v2 3/3] vfio: use __aligned_u64 in struct
 vfio_device_ioeventfd
Thread-Topic: [PATCH v2 3/3] vfio: use __aligned_u64 in struct
 vfio_device_ioeventfd
Thread-Index: AQHZ2qaNdtPjA0VxYEOGnUPvUPkGKrAVNybw
Date:   Mon, 11 Sep 2023 06:08:38 +0000
Message-ID: <BN9PR11MB527604FA5A439C9037C0C0E68CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230829182720.331083-1-stefanha@redhat.com>
 <20230829182720.331083-4-stefanha@redhat.com>
In-Reply-To: <20230829182720.331083-4-stefanha@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB5989:EE_
x-ms-office365-filtering-correlation-id: ca49d100-bd97-4a3b-94fd-08dbb28d8a79
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fu790RQllRm83U734QrOipMU6HIbY+Oh6mt1QnqG6fZvk0k9MWCSTQhXtR/E1Dim6FU0i0MBy/lubUk3XKynfIffg738O0QogA84EUG3lF2+HhU4wOT5vbwcaGgUeP4oBNDZ8H3hK8sOMZWY64cT1aLZ5XnLB4P2ZWcixmiklvWE6U136c1vhCBnoMshmL0uYQ/4w0wBGtuWyZ2bhDiHy6L48rh5J4NG3fRT12EXVfzPWtoF1FHAZawVdHBWnQjSzUYc07U1v1Q8HEdMPIFxPZlCQZQSOC7i9GuwrEO5LPSmc9Kf4kb8WtR4WQPfd0M+vrb2rs0xDXKAPaEPR56KzTmHR7O1NwQV2mmpF3M0pVS+6x8GtTWu5WMYoZcouiFfjFZWYNQNRjbF9TcQ8GLuvceK5oyVs3SWBncuo2+8IPiYCjwVnpSXY+/revv6U+UF/hoeoRTQI0nWidqqbu5E3IqrtPMbsIArfo3KO4rF/NOVRaAgqbf4M+ABdR2yIAJKU7EDXk72/qbAxcqgk8wyJ8yaWPuNQqWg9aKQ8aOrws5RosaJ8c7H5rYBMc+RDIQbwrqF5YmbV6OLmsYgFp2dtpHEmQHfuMNJl5h/x7Ix8erciflZnRSN2CWSvWuSz2Mq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199024)(1800799009)(186009)(66476007)(55016003)(86362001)(2906002)(8936002)(316002)(41300700001)(8676002)(52536014)(5660300002)(4326008)(33656002)(26005)(71200400001)(478600001)(122000001)(7696005)(6506007)(9686003)(38100700002)(38070700005)(82960400001)(110136005)(66946007)(76116006)(64756008)(66556008)(66446008)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?q+GSXApVLS+HkNWs2CmKikNum3WuWWmfazVZ/sjVQcKPWybwA1JJgjHHhgb+?=
 =?us-ascii?Q?CxOVMUmoCxMLKx4XbdSv7rqJ5/wyR9Cbxa2Oc0TG34B5if0lxag2Q7hGK8O4?=
 =?us-ascii?Q?BsDom9KDL9/o70HlaAxwquqfJlkvZY8brC7Y5N9elYhrWSxbk4/U0SA3rE3X?=
 =?us-ascii?Q?8IM0iPwKo2v+gdIq/mtNNNjOfoTroffND1QOeg7R5ifezH0m13E4+odyyAoz?=
 =?us-ascii?Q?mgNf8ScNMF1yVETY7j6nvYYrxVXBJVW2ExYVU6evPoeoGY65hBhWGWe5AYXd?=
 =?us-ascii?Q?RNMkuY0B/4k2ZZudGFLTTLolcIx9NDseMOHDT/iYJmkzTVjqtFIbGm1tt3lz?=
 =?us-ascii?Q?WsTxNdG52liw9bBnQpSaI89ybLE9jHydCH01Lo3RIVpyqKObvtxn/h3We/Lt?=
 =?us-ascii?Q?fKPon/vb8PDfDAa5fhFEB3BrxoS5hy5SNlidtmfmIA/oFmdBANljAIAZig2i?=
 =?us-ascii?Q?VAjHoTcamUBO6VfLC+M07K8lWQnL1EPzAAXyY8GCIcGiKOB+JJCLXYqZZoHk?=
 =?us-ascii?Q?mY3uq47lb7beAt/56hk6otEBzkvUQlNMt7ZraLBAT0l6e6I6Fru2UHg05vh3?=
 =?us-ascii?Q?MBdpdKvz6Jjx3HQirO6vbA3ismU7BTSeUGNt+6iMnq6LukUyLBTDQjx0v2vL?=
 =?us-ascii?Q?4AijSQkD93r6ctqmzGdjY+L876cZiGKFQHNJAuOYJPs5f/1bnBlBCd6cexzR?=
 =?us-ascii?Q?GwJCv8V2t/lom2xUnK1xiOWyg1/5pwZLKGUsBXSQdqeI46kRAJBHVvzoBuoC?=
 =?us-ascii?Q?h9K4DEOusJmcC/rS5luyK7ShWQuhFtjK3Yy/Tjv1rN3maC0FQUF863PBRsgE?=
 =?us-ascii?Q?WHRPbFfVnwWBDUL85ynfEJGjV0vDvqsgLhaYAPX8DS4He/V6Zm6Pcu61096H?=
 =?us-ascii?Q?8O28s2kqK8wow51/v9wsxIAyj//Kzm8hcT1o5e26W1g9VCfbZbyWH6A7SjfN?=
 =?us-ascii?Q?USgWFWCKY27D5FBAm3whLshXH2PKyxP5RvIBJd39dtYdNFO1tSjntmOPPaag?=
 =?us-ascii?Q?sK37NDKjwFy6zYmRg7mWbZ5CM0tGq2nNKOnzw4lBd7TuHrpn8DzgJEOdMuF1?=
 =?us-ascii?Q?3kjxiymrq1bBqRhUk47JdA7/bWeH05Mez7Mk6OlYXtZSXaqaKKyVJnB3y7i0?=
 =?us-ascii?Q?iJBsbUGwZFxDBZqEnpQH5WpN7sAl7r/e41giAhpEm8KFGlpeRCPEamCcgjsJ?=
 =?us-ascii?Q?JGNaOJmRFy2k63+S4hyLtvbYf9OVBdhaaHjL9S9fKlC8epAxv0y3qJWk4vGm?=
 =?us-ascii?Q?j3Dws+TzN+uyY4EEjQ2JGzHm+xow21w1tdoam0oqjJJ8sCaF/q/n0MkwAGEZ?=
 =?us-ascii?Q?WYfyjOQZp2jgJPgzPv9O2KN30FK+U9bFPKrNXpc3ZXjCnewgTQPukVtwPo7J?=
 =?us-ascii?Q?WWBT0mTsRhfs1PeKY0iYxC/sVpAqqEyWWW9SGY4Fo5w5dwNy5iOJlSJw4574?=
 =?us-ascii?Q?77tzBWRmBeR9TqTmjfPdBucWmA+VxuCsNjBE9+xQlWpbYNBWg34uYDH2S2wW?=
 =?us-ascii?Q?7g2yHsyd4NUA1+GONnQqIQiYwCQtyDJczRmRLSsh78mwoRolhceEMcyMLbcW?=
 =?us-ascii?Q?z/EAnavftryC8CFRKjANTEbfCbCDQC+tJAwSygLu?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca49d100-bd97-4a3b-94fd-08dbb28d8a79
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2023 06:08:38.6011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yccJds/uwx0tSAeqQgVTn/mNcEXrh2/lT9Ys40ekSXC9VWzFk7nFojIknp3TEkqB+UF+Shc8NbtrMs884ykgEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5989
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Stefan Hajnoczi <stefanha@redhat.com>
> Sent: Wednesday, August 30, 2023 2:27 AM
>=20
> The memory layout of struct vfio_device_ioeventfd is
> architecture-dependent due to a u64 field and a struct size that is not
> a multiple of 8 bytes:
> - On x86_64 the struct size is padded to a multiple of 8 bytes.
> - On x32 the struct size is only a multiple of 4 bytes, not 8.
> - Other architectures may vary.
>=20
> Use __aligned_u64 to make memory layout consistent. This reduces the
> chance that 32-bit userspace on a 64-bit kernel breakage.
>=20
> This patch increases the struct size on x32 but this is safe because of
> the struct's argsz field. The kernel may grow the struct as long as it
> still supports smaller argsz values from userspace (e.g. applications
> compiled against older kernel headers).
>=20
> The code that uses struct vfio_device_ioeventfd already works correctly
> when the struct size grows, so only the struct definition needs to be
> changed.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
