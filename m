Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5364D1030
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 07:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343507AbiCHGYh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 01:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiCHGYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 01:24:35 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9D33524D;
        Mon,  7 Mar 2022 22:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646720616; x=1678256616;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7ie72RiWEN3qW1ybsnFMqnBSTT6SFK9XMdCee+j5LpE=;
  b=Kj4pYoSr8EJUZe9jonkmw/IB+dWL7HalxMOXFurIQdGyUq9RI0kPhApW
   ejnKQELGZ7i086I6IXoHTPnU7xCCIWg64s5zPzPLNLLjYSDKyCt/Y1jsB
   z18L1M5OeedCKnv5KxzYBhetFDdnRi4+mTNbGm6Q0tDXdDVD5HbV0dHId
   A6L39GPxVwCjX0lfFQ6wZKCm287uYbg9W4FMWCaixRlQaP84Tdb9EIt87
   eNMm8QQFlMaCB+gOcivTvO8kcNB970OgioD1zqLRddC2svPlFeCHD6cV4
   gt7DDrNlF657JNyt4qKL/cfSSflgCfGJYBNmjB3VlrC3tXCpHn4thLk5M
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="254333417"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="254333417"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 22:23:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="553494616"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga008.jf.intel.com with ESMTP; 07 Mar 2022 22:23:36 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 22:23:35 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 22:23:35 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Mon, 7 Mar 2022 22:23:35 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Mon, 7 Mar 2022 22:23:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKjBLMoHiwmKKuZ/lP4ZYk5ckg0x9kZzzliuWLT0b2Crvjtjbhrm238RyOZEYcUNC/JvcAK+IF0CqjTghyKbPHz3v+jZqTkiWQWuvoryVXDB03vxxlNGxPKt6Z04Tc0zUFxUNNVvwdBBVMMz6Kfj5iOxE6hX1UqnoKwm5Bip+oUxPIPXrJSyXfeZxXRUvuhCtNZ2/K0JGZ4ChZvaryXva8JktUewg2a/PBuMCitJR53f7ReokMSZYzldCWXjFCkXODASneDgjVUcbz0Uti+9k0tV742T1Bsk4NUGKKG7dc1Tty/FVFWn0inr/1H5VMpoMDmyS9eIp+Dy2EREsXZndQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ie72RiWEN3qW1ybsnFMqnBSTT6SFK9XMdCee+j5LpE=;
 b=FTb0vv+V14auNTqonk26WG/9TOH3H2bX+8RlQCraEAwcZsSywN6nmEU3jJv4bOkC4n0/cOgqYKwdkNE/DozHyos53fe4nIvE1GU5GZYrjNNctO2BGbVAIQK3nKoTlVx6kZJaHr5g6njlFGGcu6eHkhNA+nzeg5c1bOUWDgurw+QH33TcVs+zkL8Mi9h+6u4aj3TzWTDdMn2JHd6K7qh3zve+iAw2kuL0dLEIdVYrDLMR0wHCAx7I671j6CN7sHhnZV8ai3aKcd+iXOgG63hz61m0vuM2s4tbXClkFsGlHNKSZcJ/dqqQTP7M3/cJjEAGkmf5Q1/I+4JPm/UMIZPZ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN8PR11MB3683.namprd11.prod.outlook.com (2603:10b6:408:8c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 06:23:29 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%6]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 06:23:29 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "liulongfang@huawei.com" <liulongfang@huawei.com>,
        "prime.zeng@hisilicon.com" <prime.zeng@hisilicon.com>,
        "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
        "wangzhou1@hisilicon.com" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v8 5/9] hisi_acc_vfio_pci: Restrict access to VF dev BAR2
 migration region
Thread-Topic: [PATCH v8 5/9] hisi_acc_vfio_pci: Restrict access to VF dev BAR2
 migration region
Thread-Index: AQHYL1LgK0paKWluGU+nIOk/ItMZEqy1Br3A
Date:   Tue, 8 Mar 2022 06:23:29 +0000
Message-ID: <BN9PR11MB527681F9F6B0906596A77A178C099@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-6-shameerali.kolothum.thodi@huawei.com>
In-Reply-To: <20220303230131.2103-6-shameerali.kolothum.thodi@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 004ac928-bcb8-425b-2df9-08da00cc2998
x-ms-traffictypediagnostic: BN8PR11MB3683:EE_
x-microsoft-antispam-prvs: <BN8PR11MB36838CE3A5A7B1156291E56B8C099@BN8PR11MB3683.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rjWSuxzH4JXNSI7X/jCTWsRwlE2txlpO3VsnZaPfiERgrikAqnCy3PTMcg41b33ucevGKCjnIW32HieyVON2PVzj+rnPhiZGq8BnV7en+ov312XjG59fidLGwWlWTx4SKILtJdpfbolJy9mnTvjvvGoS98ZRM/IthJO+p0YR4QbgXNGLwi+3UfznwPxm+QZlNIoLL2HjKm5Fgj4OQaJpdPmgBu7HfJ6CP8yNZGf7a1jbexRLpK6CyZ76lz2C8oNOyZxpDfawYl24oF9R3qC93Q3iqBdpoy+j0+crg+mWvCO/YVawI/6B3hWCTSVFC175LiYGSKkyXkk27BmVXvKisB46TejnmgguXDCvGnq7u8jd6EYE9pey1brg+HpE1BJHpC30xxG46AMxpeIvCMkT7b4spSXJvvzh0Bz69PREX+50OPLytBO5PhS05jFBV0EBPdtM8enSvGnQ72AS+UgDzwnkutjNp94X7eGznjYi9KuSSiIfbx5AB4/oI9N2rzVOeEIrCEOUkEQ/VRDbmav3PJJxDl0So569OmWSsfJ32gkh+HBDrJWjqF/n48Eu68lPKb8cMR6HI28plKRxgAs4S1lgYPAK5srk/z7xgo9GZ2QrtZMo9iSehAXnkpeY4IF6oHLwhqyHs0rE8NOkekB50q0PnL4NWGTZOO8+9d8pcMdRnUYeBN4nzdR/1qgMDhhWVd08E36CB8QUeqm7Vsc2aw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(33656002)(9686003)(71200400001)(38100700002)(8676002)(86362001)(186003)(110136005)(54906003)(316002)(4326008)(38070700005)(66476007)(66446008)(64756008)(66556008)(66946007)(82960400001)(5660300002)(26005)(76116006)(4744005)(122000001)(8936002)(6506007)(7696005)(7416002)(2906002)(83380400001)(55016003)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ti0pNHqUrPdJ+s6J+RGSXgM1uUWmPrZmfm0sI5CmqAoThXlvFGf7n6ofuOGW?=
 =?us-ascii?Q?2tYIkCbZM1g9MS01B9PGcmTtYQBCGIECEJCNZ9OJrkTeMG/A8iuZR14Rx52Z?=
 =?us-ascii?Q?zAjahRJHJ+Izyv1e4HyJxzcOPA9VJ+S6Z3PCL7ShJUA146bYnkQ9MOFuh9xT?=
 =?us-ascii?Q?QkwH9KhDrAhz/rOKoPHcf6D3EX31gx+cyME7LiOMRY8u1QQKdF05uFIltnWg?=
 =?us-ascii?Q?SBJfGVNLrATh0gD/kG+ch5frTviZSCOEET7cEoyNLIbrte9lCzAbfojjO8na?=
 =?us-ascii?Q?U6nldZBxtMYMrh48K+9m6892Qdyi5cs76zrzCAMQk3wngCo+v/hrM2mYFhIz?=
 =?us-ascii?Q?x9kEHW/Bl8/bgxotlmd8lbP/x1i6GpNPHE/aWWlaHH/yKEussp7M/AucXpsH?=
 =?us-ascii?Q?SJ+NZ3s6eoejs0H2pP07+CIsysG8nZmjmqnUO6AaeBkZGptpC/eUbq0vjiUF?=
 =?us-ascii?Q?0L/Plws7rTL1slMQWEuyrIsbnQBaDJJHP6F3wFL2IRcwtJ64Vh4Vl1yu1OB+?=
 =?us-ascii?Q?UQrbHLpMM3CBPaVnvwpCDN4tSAQ2MnagsiFJ6ASfpmXFLc3DUHM2axvkobKS?=
 =?us-ascii?Q?29eX2iI5rGVeB7jlS6BxHi4HQv6dFyFR974JS1gqZzsKOJbsgoCC7OwKPDK0?=
 =?us-ascii?Q?f+yc9cTYTrF08U/Sl6p3q249jltdfwd3RviKJNAIx1YRnGLF+DxXOv9U5CJB?=
 =?us-ascii?Q?w0cuMk04I3zeqF2B6fTqSXIl8NfjWVCLlLYvTBw2TkiV7jDtib4DhU5Ixf21?=
 =?us-ascii?Q?yb/VNcS/oZZZanyqaQV8m51Iy4anhxkKW0wthOsVviH7cOya+ZEDYikDq+QG?=
 =?us-ascii?Q?GHPYPQC79OLq4RbIAYodL2/mA0KVRoSIJ2MgOizcJ6CR5KuodUE9kwDoPcsg?=
 =?us-ascii?Q?0DLIqWV1amG4ST3VLrWO3etEc7hIFoNJ9P0XfuGV4rU6iKn5NsRe2eX+weB2?=
 =?us-ascii?Q?ocoDpAcb1+0CnASsOYKWyUO3eIubyb3d5Gq3/vCA2QxG4EjMg+vvXzzSh4Sq?=
 =?us-ascii?Q?e0EBjuR8BgMPfMNp2+xLMzFFlUsWr0s0yJETGqYC2yERUmTO1ZVGGi9TIyb8?=
 =?us-ascii?Q?6Jcm2jKUAMWdXHL/OX8mnnq5iK8+WUnSwqdcE7SXGsbl86TqlLpwwEHO6JCG?=
 =?us-ascii?Q?4Bw2yWKU38xyoKx5b/sbEVYk+LIBV7FO8/nzv9dCsVM8y3moTpEE0EWBJRnm?=
 =?us-ascii?Q?fCsFGxsZf3MqRcq3l3drDTei3WUTQ9p6UYAhVV14IrrYLB4ph3Hy2As140uK?=
 =?us-ascii?Q?m+OF8Ip8OMEuC6uzuUVga5cw84zkfpejQvGCxVEeuX92nfblsP/3sdivhHz6?=
 =?us-ascii?Q?RNGWloISz/Hd5pEbP+CHArKsuxbQFu/JK90jzr2YE6LfMCZ/vpgJTUwEALpF?=
 =?us-ascii?Q?ht83PDQn2i30nrIz0z7bTZgPVv6X0B5Djvt8wDcag28p4+wAcUM2fSqF1xws?=
 =?us-ascii?Q?D34LbwXUSClv+oK4V53B65eeYCnhWXiB+AD5IYQKhBoy5QkkyMPMXCnCKo23?=
 =?us-ascii?Q?O/le3HY71MG6qTOyz9rd5XX56dRF/wAEy7069khf4aoIcdP7u4uLmX7ky3qB?=
 =?us-ascii?Q?j0JhiGd65nufmdqEWYLWU1Qan5XFlKFBphwuUdHxs8cYrDQryrCjgilO5jPj?=
 =?us-ascii?Q?YA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 004ac928-bcb8-425b-2df9-08da00cc2998
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 06:23:29.6889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GTTgr2BUj9nPGngOrb/4PVBdPjc3RZudKRTeMDF5nc+WrIIhX6k0XBO15m7zEVEav5bxKgWA+nD7lC6IvIZGmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3683
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Shameer,

> From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Sent: Friday, March 4, 2022 7:01 AM
>=20
> HiSilicon ACC VF device BAR2 region consists of both functional
> register space and migration control register space. From a
> security point of view, it's not advisable to export the migration
> control region to Guest.
>=20
> Hence, introduce a separate struct vfio_device_ops for migration
> support which will override the ioctl/read/write/mmap methods to
> hide the migration region and limit the access only to the
> functional register space.
>=20
> This will be used in subsequent patches when we add migration
> support to the driver.

As a security concern the migration control region should be always
disabled regardless of whether migration support is added to the
driver for such device... It sounds like we should first fix this security
hole for acc device assignment and then add the migration support
atop (at least organize the series in this way).

Thanks
Kevin
