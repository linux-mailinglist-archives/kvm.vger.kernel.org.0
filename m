Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2FF46BDE02
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 02:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjCQBPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 21:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCQBPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 21:15:23 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96ABE10A;
        Thu, 16 Mar 2023 18:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679015719; x=1710551719;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/n4Ml7OeD0oG117m3KFpP4G6CcQfmpTnvWM/KCBFt/M=;
  b=Y2VmpeKfYNwhIkIou9jPXj+ZkBG3ZGKfFPKa7PboDeEV7+dGpTQRpJzJ
   O2NppbnIeeHZujBJSWh+FTLPv0RqKSnEQp4LILIsLmrLgK2Zl9/N8i0S3
   m0uRc5dbBAYsp2aPdYTqzUzsuWpseEo//E043XmnfxTz7b7j1PpI8Qbj8
   S7YnJZBUNzKUSJAsOV81LN1H7nka0+nHeRuiy9Ep9MQNkciG4Fijarbff
   6q4EhqTkliGnhnCwumaAAYBTBkUVsBJ0udFVZ41GLl2bAb4DnQ7Cn+sVr
   ljJ4A1B2nReMubMCZcxbQcJ7IEps4rWiR27HETY6s8gn5rJkkVsZS0/n3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="318547731"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="318547731"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 18:15:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="657386544"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="657386544"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 16 Mar 2023 18:15:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:15:18 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 18:15:18 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 18:15:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GtbK6tR2j+lTxasu+3vpKWf1BXsxITx+jBpn2i40VhOkAN0OzyfzGltC5xOybkmSNV5fSV/jnvPVwHQP3Fb0Uc7nhvJoEAWYK1tknki9QU6bBNTbEUAmGHEvmc7+IKImGjy5iFUCwUc3lh78OaTeuYOIyWWI2Ap2UD0ET5ete+1Xl3M5YgXOnE+yCxbGoPplUGU2bL4zEMtWdjwajsQtlWn/FSAAPb1mlcKFCsjY1Z4ulmTg80nooeSLjP82RrsO/2/BSd3v/ydL+40M+DwUXPWUm5oO0H87O+DfqxfWUaWTmCI5ukujOGQY7qeRzmNslrxPozQIIhdpYqEWzJjy5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/n4Ml7OeD0oG117m3KFpP4G6CcQfmpTnvWM/KCBFt/M=;
 b=lgunSpd3ap/52Qo4KNfCyf8porQhU3lCrfSMDv+6QVCTEfQVB6zqdyYknXW/vKdXaxbCOc/SIRX/hLjIjZMR3TfMcTcRcZp0YeoE+oGywGoYVJTnMzWR0CkQj9Kil0K9oT8FM1NeR50NspU9ZC2FZ3VYbeq7VJspOHhrjjoz64oxR8EXJNJwGuGEiKNcHYEoYbvjSY31h3u+pauJxCUOt2glSohCDi8b3yEIVJ18YueFyFtvOiKM+vnItkRWVvZhQiI80fbuXYKDWemTlWTvnfDzPOaBbjScF+K9So4NEDnJcC1OTOxu+lQGdO0UYwhdg7+yJZOsY+3AQNwHWWCIKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6242.namprd11.prod.outlook.com (2603:10b6:208:3e8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33; Fri, 17 Mar
 2023 01:15:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 01:15:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH 3/7] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH 3/7] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZWATD63T3j/FB1UaYrvbHgUlP0a7+K68Q
Date:   Fri, 17 Mar 2023 01:15:16 +0000
Message-ID: <BN9PR11MB527658C7676060F0EE7400CB8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316124156.12064-1-yi.l.liu@intel.com>
 <20230316124156.12064-4-yi.l.liu@intel.com>
In-Reply-To: <20230316124156.12064-4-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6242:EE_
x-ms-office365-filtering-correlation-id: 9fe2c05b-f9d2-4a22-48c3-08db26851115
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u61M84qrCx+v8ROXDgGVPMUrb+ODYCRuepavaLZtEvjRXqzT4qLETXnwr41sXZkvkQgryLJCWaGNd5yDAC/mZQVpFuk2aRzsb1vurQLd7ciO8IXj45YaMvyErrsTKgigPOeAT4bHlvAu0QVV92m44GmNENXdd6H5LhR6e+TWFbVh4iaySWA81ckhEcKfzfwyckuxPLew4DBMf12MrUnrdl8IpVOD+0mz7psMjy7icvldLcum3cWhLQLa9xP1KDAlkSh0Prk3lhUcz/PEJy18AA9MyJ9DuaQsKsOGAcEt5BQX5xJSg645uNYB9pyWrQroQ2N/232rLthf4RjweVmRhUgaV65/XPChbkLsGCnV2ZbJLOJCEdfuGrw7k4oXom6m/HZLAemufT8KhVYqY2CUTI5AWnLV4NA9QChNSluSq5aNYC+F9t+N1HvmfsVCo7BmfC0QFM2HP5cLnQMiU5p0Z99gOjw6DK/smKfJ2ujxqExf7BimhK0o470aTEV//S/S9Rp/1jctpF9ww1bSiWl6neU/XvlSpImrDuXIlI1LVvPkyYPUqi6vLPMBCb5gcA0sCbSNwi4GEglsOIreDJ+xSqfgZKNIkXbRgnrMXuTwBrhdDHKthT7g9qRTbv2he+2g6TTYOUZ1aIgLfd8rNjEdfppNtI4On6n5d6qMK7/NgOu/FHwB/DU7fisvqeCePDeoQulV2sJ8CebFManfn2TzmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(366004)(39860400002)(136003)(396003)(451199018)(54906003)(9686003)(8936002)(55016003)(52536014)(186003)(316002)(110136005)(82960400001)(7696005)(122000001)(38070700005)(38100700002)(71200400001)(83380400001)(2906002)(5660300002)(33656002)(478600001)(7416002)(66476007)(66446008)(64756008)(66556008)(76116006)(66946007)(4326008)(8676002)(86362001)(4744005)(41300700001)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6lE5QbTgjCDqCQh3gBaAervbIUGNhqGOC+YWDLrfZNazOUwSxPU7IduDJ02c?=
 =?us-ascii?Q?mgc8CBcgAqkEvnhRko39Nw+HfTiShFevsgqOf6Y5x/zuSwc/Xb12JxECdV7s?=
 =?us-ascii?Q?0imuy0eXpi8kipY6rn0ezRIRRE4LqBSdHj82CuRlt0LcAC3rjQniz9s9KrXb?=
 =?us-ascii?Q?HnV4fO5qgdfbVkikvrCURHWaTUuef8xzqL3erVGJBT2derIyloVV4bYNhRCh?=
 =?us-ascii?Q?GC/qGxZYpkU67hx6bAfthBPCp8CFru/60FzlnkHQQZz5neN/Ysa+TWvCjjF4?=
 =?us-ascii?Q?0FP5Gv0lsgDwmieX4REIFZGHON6bAI6NNBiJx/+OxqQaYofmAzPeQMqtalQH?=
 =?us-ascii?Q?kD0tNDe9msEhQcBk7b5SqaFIA5FIbR9UmFTSEU5Tbz8P2fth7vzbjy83HI3q?=
 =?us-ascii?Q?AMTHW/hqjxyE6EKatan7aUvW52k96WpkPjQPPyLyxa59aIRbMucsDUJhmbcn?=
 =?us-ascii?Q?oQwzWGaDGZkRGsmJTq0Yf/vOgI6Dm2NJJOXTK7pejWefJUAdAYUHylA4RrOO?=
 =?us-ascii?Q?ijGG4Ax3OGYPkK0Ej07yVkidV3Oud/tWx5KiKZ0PtpSwILrz8HNm1/4/+epr?=
 =?us-ascii?Q?EVdSCJNaSCv3uJyMEkrNT3y+VFgtZcii0l+vqIbcGHxO8sYiZw17alJwoACh?=
 =?us-ascii?Q?vFUYL99zJeimpdBUxRM455vgQ25jNPcJYM0CK0d8uqjheKYf4Par/tiTR/zI?=
 =?us-ascii?Q?p2mbgq/OSgcbON9ZuvkFSxXcz5wiZdpIQu5ZL1Lcyq+EKjU75ZP3aQ66lQAd?=
 =?us-ascii?Q?4SVZFTJygQcH9GSktlv3zZbXvBx8G+1iVt5tHFU31ypwdzVkZODVodDdG8lp?=
 =?us-ascii?Q?u57NEEs4ndM9oLKgV7oCIYLMR2uuPIGVhg/kOjNZXQAesy/twVWHU/agHSDb?=
 =?us-ascii?Q?Gpe4lw8QcnqC6VbkgUN91J4ZSQt5hpgLafsvI5eCNtNNkufzOANZ7CxezsEP?=
 =?us-ascii?Q?7mFovGPuTUWPT3O5QNGCOPOgpUMq/1ppKqwpKS8/o56oyCxqd0ABOVWEToBf?=
 =?us-ascii?Q?+Nl79BOJ0YvveGDideV5ji9tTmhrMTlmrfJLRbmDW/xvYAlpFeLGhzmUKodi?=
 =?us-ascii?Q?/UF+oFY5SuxnNwfiJNkhQQjca8r8OA2+tb9RpaQr6wsYQwwFfwjyLja1XjcP?=
 =?us-ascii?Q?UGHQgTDo7Saa0cQkynTt7UJ3IEtvtnue1j6tKlMLPNkj8xz2ttFAdqy/q54k?=
 =?us-ascii?Q?+g/OXtoaVXo8kx0WmmGyhLjs9jTNVcW7Ym/0LVrxrO+yVKEPiRl7mVIsbMG/?=
 =?us-ascii?Q?NgpDJdXmthO/pH12S7S+TnCoG2/GH+v7LfdOyr0DhDWTx7vzXNLRC5SigWKw?=
 =?us-ascii?Q?lisVOl/ayJAznNvvLV6kudSkl55vEeCwJd8gsrw76gIEaROk02EQ4DtNceJz?=
 =?us-ascii?Q?F7bShjUogfkvoHgTrFVplb0emkMlf+gF9QMYpuyxHSoYfsyr7KrCDbghQWsw?=
 =?us-ascii?Q?AVLaklUY4nlhy1QKC4K3NF7+Z/lwaFcP5NZTWu+T8hFUk6xagdIVUqLHwAb4?=
 =?us-ascii?Q?ZFm669UUr3aS7l01XQSufRMgRYH6s6OcekbPDwlLdsQ5mWj5h8SlEIdF6Yr9?=
 =?us-ascii?Q?m83aFQI5GL8KxMZv/lRNkj52mDg6Yt223a0b1nhb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fe2c05b-f9d2-4a22-48c3-08db26851115
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 01:15:16.1858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O3kjdE0FwBebYcI5Bc+bLOgocMHO25MrDvWypWkB2doH+lXlJztqtAL/+tx+B9KPqTDz/O7nuSEjJBcXYpD6hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6242
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

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, March 16, 2023 8:42 PM
>=20
> as an alternative method for ownership check when iommufd is used. In
> this case all opened devices in the affected dev_set are verified to
> be bound to a same valid iommufd value to allow reset. It's simpler
> and faster as user does not need to pass a set of fds and kernel no
> need to search the device within the given fds.
>=20
> a device in noiommu mode doesn't have a valid iommufd, so this method
> should not be used in a dev_set which contains multiple devices and one
> of them is in noiommu. The only allowed noiommu scenario is that the
> calling device is noiommu and it's in a singleton dev_set.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

let's hold this one until there is a consensus with Alex/Jason.
