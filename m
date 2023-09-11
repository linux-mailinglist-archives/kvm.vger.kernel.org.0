Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F1A79A431
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 09:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbjIKHMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 03:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjIKHM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 03:12:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43A81B9;
        Mon, 11 Sep 2023 00:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694416345; x=1725952345;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/93Y/1lfuGB40/hjl8qyrZ6WYvEv/F1ADTA8M2iSK6A=;
  b=JrjaDmvmoV6xQaUbYWpXwxJwM6P19MPJaHALnFWB573rVinGXNsrrTId
   fI6KhgJXWx/05LA3rdDBs+ja0+CEly9jLwz3Q5bXBwI/GCAfVGMxFrJIu
   IN29domgzAckjguulAHCzxI+HF5kFzwaWhnSdk9m6yIsuQhY9pqgbapVN
   5kxoQddxley8M1sPIWSuDyl1dj/2j2b+TdFPvq0IwBdLwoYHn05dDBWi/
   pbxLFDc4llykknrBTjxjIOm881aa8jZodfyvq5hnyxlKeWYQec5ptsnsJ
   BunGviq6SWlTYbCwZGEeBs0SYpcDOhTEV2mJDcI3nox7Q2GQ/i0Hg0JEL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="363038085"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="363038085"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 00:12:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="1074034876"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="1074034876"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2023 00:12:24 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 00:12:24 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 11 Sep 2023 00:12:24 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 11 Sep 2023 00:12:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZmN/A2Esay1Uk0nrfLvaGwVZQV/2yxBHKQCMDhaxuhg0DlVhkpNmGAAizmYapt76afiIcDGCPAWmGlGnAUR83iBPVI5nIQXbARs3aI08LGyNTSqbltrZa4Vn9OP4TclR8crHW3QClp80kUqIbjccvfbJRV4ijTaY1xlQL1bAc2i3DjloU3vlFkVU/mTDDWouDLOCiKo+cLKrQLJ7vS33yTK6QjqEI3GuztyCfadREusfK3qzNeja0YHBeBim/Jes39+Epku3QRMDMtzoa/x7B/IYCO4fO7igR8XnuO+VTbF6P8FZtUF+7xij7aVQwLMMpyMa93V0aVgBvs+ZBd1xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGPr1wKqBVCFmR2qVnyw+UYS5r0sdiHTH347PJLpG3M=;
 b=IwUqQPF8yIF444p8CnCsmf1iOX3RrYiVZKytNHO97E2tiofXUz8EivQqXObByCI7sGCNLXD3EWkbntAEKCbSVa2jZKjbUfymIkGqCCfPl/JrQ0oxSBv6UDA4BWz1i/9iXSGCp9QwaejEiI1LqEFhIcXW0rChrinVeD68vGv0dRonxPpuAx3IXbYQZZZdqIpt7RCwui987G0ra1AcdhJJy0GJW+z7uxk+cWaHWHdE9vLmgBT+OIGg/GiiHv2abTLVDU8B6It4KHbtKKkhpE1H4v0Qt6u6ys0Gw12jz1cmpxOYdX1rsiyRAKCVtRK2SuXnvbFccl5wkqKZvTpGpJM18w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB8222.namprd11.prod.outlook.com (2603:10b6:208:44e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.34; Mon, 11 Sep
 2023 07:12:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323%7]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 07:12:21 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "ankita@nvidia.com" <ankita@nvidia.com>,
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v8 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Index: AQHZ11GKWAVxhbL7fE2VxDNOQbtCXLAP2/IAgABN7YCAADqIAIAAUAcAgAA5YoCABGFuMA==
Date:   Mon, 11 Sep 2023 07:12:21 +0000
Message-ID: <BN9PR11MB5276E36C876042AADD707AD08CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825124138.9088-1-ankita@nvidia.com>
 <20230907135546.70239f1b.alex.williamson@redhat.com>
 <ZPpsIU3vAcfFh2e6@nvidia.com>
 <20230907220410.31c6c2ab.alex.williamson@redhat.com>
 <ZPrgXAfJvlDLsWqb@infradead.org> <ZPsQf9pGrSnbFI8p@nvidia.com>
In-Reply-To: <ZPsQf9pGrSnbFI8p@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB8222:EE_
x-ms-office365-filtering-correlation-id: dca780b7-5905-4c4b-0cbd-08dbb29670ea
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zPABtG1a/Wq80ncwlgP/RPWQL2w1SbLfD9bOlS3IMkJL01oYQRyeS1MU2MFBwymWtvFJNq0/lLXaC9p50rZ8vPGt1RwCG4Z3zw3Og0lJb7jEZW/22MRGI17u5xFeGeDvOfwcasg5fk1fOsinjEXJaahMzEATV6WD8MJSUmShMHFhX03Fgtx5pNjdUMbfCAEdpzDQKfriPlUAyOSCRLoloca19bj+ISnpN2Y/NRbGTGw9N/qvtRXFx8L9RkgbGkS95rt6Fis3Q4CMM/2xxhTVlxG/hsLhW2tkzAR6+mOKGftHMme/mqOK1uVf0l9OonICdIThRmCPsHHpbQOCqaV29ub8hvJ24T7/zUCuyFDJF4M72gOhQES/PNSvZZQC8SyLIvXNLBkm811qn8N5LWUHVDatQmtTdSrbLzDZHfvtItEOPGN0Gwf1vBX2t7BMPjTb7Xvz9F2JLVNV07AXZI6BL56JIOzaZ2alUA55p4r5itDN/v5BQxPxYeJFB9AI9xKwrl7lAJkr/1S6L3EdnIgr72kCsTzjjd73RJE7z8b0fGA5ycHxi3WogcMlG/amyTB2wy7zkR0idJOciCTva0jhMppJ6ms4lY9HHLUKaFAq7tehsGAnnIMsa2t5wkw7TesN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(39860400002)(136003)(346002)(366004)(186009)(1800799009)(451199024)(41300700001)(316002)(7416002)(55016003)(26005)(52536014)(110136005)(478600001)(76116006)(8676002)(2906002)(8936002)(4326008)(66446008)(66946007)(66556008)(66476007)(64756008)(54906003)(5660300002)(6506007)(7696005)(9686003)(71200400001)(82960400001)(38070700005)(38100700002)(33656002)(86362001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q26isEZzDqzBD8GXSJw+h9BmIXBNA89wabA9Ezsh5i1wvXPrbSckZ6siclxE?=
 =?us-ascii?Q?VyxpgxzIprrxK0Sum9yQe4PxZXuh1vuwa7H7tt+TOWjU7DGudVd0oxmJQOp0?=
 =?us-ascii?Q?7Cbdp2fGJwaO+tRhSXf03gGbgBUy0KX1AThCEPacw9atNfqboorK49E1YzLA?=
 =?us-ascii?Q?aMICDzAve36oUic1ikCWd4OxYRUrg2QrfHtcjM2VqdyjPq8hXRPSB00Y8elX?=
 =?us-ascii?Q?HPvfsIoDPGuI+OwqRCmMC+TmqwwqcxNzOCOp77aTuHEElB9n3XKb62vrAoGU?=
 =?us-ascii?Q?9LgWbS81DMF0C8q/SapxIQPDHlwZHcBayuskLIGpU70tuhyqUNiZ3I14c5Uy?=
 =?us-ascii?Q?ZV32821Bq5rZ5ZKTI3gxPm5AY9c9SZiuMv4HkJgVvhkU89BBy2vRqnaXaAEi?=
 =?us-ascii?Q?9B594VdjLHx6nvum+x8DppFEGowVlANuEoq8BE2Bw/Zf+15Dakb/cBVGMPdO?=
 =?us-ascii?Q?aAT8A6MLufHdlPwojOZyJ2bbarXBt8+koBfjECceKvbhxIMzdTjh6I2xlR7A?=
 =?us-ascii?Q?v5L52Q+dynILMA3btBzb57LT4QNK2RQR5RJ3yFqZpg8ZmVqqJkEeJjVg6+32?=
 =?us-ascii?Q?6sYkhrL2RL3qRxqSoMN4g8eSgrlIj3pavcNFN8yY/N9GtvF37pFLmD1cmCEi?=
 =?us-ascii?Q?+q1fmlC6Zi5oqs68z2ln0uOP3eIjvzJmzlMmTwduiN/3Sb89FL+9f80l0cH6?=
 =?us-ascii?Q?hS5CVyuWHn2bB14B0sB99VQK1duIjMX3D9LHAywOpDjKPMVZLiIY0Zg/yWtM?=
 =?us-ascii?Q?kkwPNsUzFxSOkkZBoL3SYGMagkJWOIDb5r2BSJZLuqi11SKiqYgjiYph5Umw?=
 =?us-ascii?Q?FAlpKHGXHpiwqkRzWIIfqZo/RVyE8H162Z8oK7ZzX8r/ZNcn5phu5UEN51oS?=
 =?us-ascii?Q?tmB5gEwcRIcf/GAj7EkXsoGJg6OYjEQrhFDxFQiOxe+fMd9U0Zu2V4DemYnI?=
 =?us-ascii?Q?VKPY8DT+aXH9gCW5pJWrGjA6gimQtY1Cqrd22aRZCYkkAzbErySO7o4FgU3C?=
 =?us-ascii?Q?hi+ME83CvZPZiM7RrFp+rkwpZjOaIYx9UCTEWA5TTQZeb+vuOnHRdE2mIhMJ?=
 =?us-ascii?Q?0hHLYrDyDcVqFC1IwZY7wWfKYL2fKUdhgfiYPvqB8z3WvVnM8W38ncsej4zy?=
 =?us-ascii?Q?94xoCUSunQjito+wx0NJ3x5bYJPbNOL6uS6XpEb//ZZ2lIqRD92dmDgGTg2h?=
 =?us-ascii?Q?G1IqHhR2KgJTgNLaq22x+hU12vMrmZqFPDn9P0bgkEyBdH4n8Uva2TzoEJEN?=
 =?us-ascii?Q?dkqCdbslZrMUy/wGCiWYefuCysNrXOMUU7Td/B+urzDgD27y1cQSckkTzy9R?=
 =?us-ascii?Q?81q/kuKPQMIfkfQurf5v6/7jxqRCHbtsx+1Bx6PM2sn5eqj6qDeRPKuJdeV0?=
 =?us-ascii?Q?czg9zQ11G5QU9fqpLwQHlN57FcFKUebngmfN56WOXzDwKLkyWUbtgHtfglux?=
 =?us-ascii?Q?Wna5FaWRck+mydfVA9xPEkWfdXhO03d9bE87MMkXTKl2vQOhf6K8bpxZslRp?=
 =?us-ascii?Q?RV9WAhXqyb33liUgkp6zO0YceN7Aq3Kb3SfTRvPrBxWXPYrlaiWoMXC1LINU?=
 =?us-ascii?Q?lmmXubMIx/hF0bIj8xUwOs1XBfgXQTfnXPczLplv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dca780b7-5905-4c4b-0cbd-08dbb29670ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2023 07:12:21.1747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4XyfrhTWRDXYelrYtgVM5uGR9MyUMAYIU+0ZUaoRPinFAF/MilunZVRbsHnWsW08HuCROSvuklvi2a4S2NqoTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8222
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

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, September 8, 2023 8:16 PM
>=20
> On Fri, Sep 08, 2023 at 01:50:36AM -0700, Christoph Hellwig wrote:
> > On Thu, Sep 07, 2023 at 10:04:10PM -0600, Alex Williamson wrote:
> > > > I think it really depends on what the qemu side wants to do..
> > >
> > > Ok, I thought you had been one of the proponents of the fake BAR
> > > approach as more resembling CXL.
>=20
> Yes, I do prefer this because it is ultimately simpler on the qemu and
> VM side. This ACPI tinkering is not nice.
>=20
> > > Do we need to reevaluate that the tinkering with the VM machine
> > > topology and firmware tables would better align to a device
> > > specific region that QEMU inserts into the VM address space so
> > > that bare metal and virtual machine versions of this device look
> > > more similar?  Thanks,
>=20
> > Yes, providing something to a VM that doesn't look anything like the
> > underlying hardware feels pretty strange.
>=20
> I don't see the goal as perfect emulation of the real HW.
>=20
> Aiming for minimally disruptive to the ecosystem to support this
> quirky pre-CXL HW.
>=20
> Perfect emulation would need a unique VFIO uAPI and more complex qemu
> changes, and it really brings nothing of value.
>=20

Does it mean that this requires maintaining a new guest driver
different from the existing one on bare metal?
