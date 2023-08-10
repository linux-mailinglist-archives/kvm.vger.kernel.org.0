Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED338776E75
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 05:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbjHJDXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 23:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjHJDXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 23:23:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82B810EC;
        Wed,  9 Aug 2023 20:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691637779; x=1723173779;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qeeq+nsfl2CSuw7bJlvcztUzz+Q2r6aNw/oPramCVQs=;
  b=JsRUWQtDNoeoULt3BH5r/Qm+9hOY5CGW+WTszlltkxDG/znGz8h40Y+s
   dB6QFYJUb6hwCAaW4QgBWPN8H1+5fsguVeyTlg5sT56juGgu7UQ24j6KZ
   qzCvFCqDzitP1HGuE0WlRtiDKIFiH5v2xzdY+mUFRJnD7L0to/Ut4xCjH
   7RQIknZcM50beVcCLbTfNGDVZkkmUMFebkEpI+/zmS34ZuyxC03qIIZIx
   10bkc4DfKEw0SXPa/2nXw6RJqQpEZnWfMXCpa/80ifj7lrDnNL24pwFyy
   qpy/cSuW+Lrny6g9P3XJr8YNEXw7iHNrxjIig7/up26rUJrh8YnJlzA6+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="435181347"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="435181347"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 20:22:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="735239042"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="735239042"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 09 Aug 2023 20:22:59 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 20:22:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 9 Aug 2023 20:22:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 9 Aug 2023 20:22:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WgeO5Aw60OAMOBik4EpwXwKNB31Qij0AW0WcuwV9iOrDr0rfP7fxYRalRGrItLmg9HOuREMVsWNQ9R4BftgB37ZQCGYo/xCJdfPbf6YnmQ66egUcNUfu3ps3wYiUBsNDZTMxAiNgABt1iPhVaHyVdPUlqgLMCeGJKsK9rtJWQ7pWD9W1oqR6jbz8/nrTiezKqY12Q38Y0KR/LgnIYgyqYDgbOBZGVVu9DkmGzx622inzbwYDqsBqhg4nqInETluU4w5JVBYQ4yDdG2VWQc/tl6qaNUZ6qmjFwLiVXhp1dcYZBR43wGq8VMk8XJiCvlACe0YiU7k8e32e1atJD8WftQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E8pjwWZhw+BJsBtPiXZntjop4XUSopzm3rqpQKFsnKM=;
 b=VinNOzwrsGiBsV7FPfX3mL+OQKTuWnOpeM1PGV83VLwgqcRhUfAzZVFAaO0qGAXaA5cKyRi2ZYl2/2OkoxAxJiYVCmMslhL5NmiNDL0bwPPTHjCdw/gfO9IrV+6ux9lDLIx/86R+V4XQ3O32d+VsYzJZk+Zbqh8ictxSat2ggFhOO/iy8kzPjk+Qy7HtYj1WQsRZ06284npqKK8gv/p5YQgL3ABn33TI2K2oGtcLGQI4X6APPllyh+Ktj12aF3GsFQ/pHlzacMycqYxKxMGryg70zh71WB1IelMCF6MZbl5CV+I8fsJIxAvFEyXn04hcQtze7zGCNxTgMqlzPqsSkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN0PR11MB6011.namprd11.prod.outlook.com (2603:10b6:208:372::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 03:22:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.029; Thu, 10 Aug 2023
 03:22:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Jason Gunthorpe <jgg@ziepe.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: RE: [PATCH 2/4] vfio: use __aligned_u64 in struct
 vfio_device_gfx_plane_info
Thread-Topic: [PATCH 2/4] vfio: use __aligned_u64 in struct
 vfio_device_gfx_plane_info
Thread-Index: AQHZywUD9/fh9XBS6EyCf69oWksSBq/i2x/w
Date:   Thu, 10 Aug 2023 03:22:56 +0000
Message-ID: <BN9PR11MB5276BC132EAE86D470B886528C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230809210248.2898981-1-stefanha@redhat.com>
 <20230809210248.2898981-3-stefanha@redhat.com>
In-Reply-To: <20230809210248.2898981-3-stefanha@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN0PR11MB6011:EE_
x-ms-office365-filtering-correlation-id: 804bcaf6-97c2-45a4-8eba-08db9951178a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ltEtkHE8TKJ2U7Ze21vco4GEpMBmN58sqiILEEsCs6h9pS2UYO6zQtLNicD2tZOBNwHpC4uL7k266aYmTryCsdZ1vHJTSfbtPvJg4r1xOMnCHT2zmo3w1JlvTzhzBOY4KWa66uHNY6Qlj7RCPY+nexUFcP2zIuDtNwBC9sCYAtsL9+9qbIzhDK4M7Emb/CrWVtz5JJ9c6MJu18zKxd6l+ZqvrzgtXZg2fjFJWObbmOqGsTMGV5PzA34ApW4EZ5WAvvHgIhMPw/oFligYXyByHe4G6+TXQez6aNm+uvOugsTtAlve9rwN6zNCFVRx/IwQ1Ae5+E2i0wP4H1GOL8lV9eQWIIf1VxDFd1H2CPSPtqCrMxNjE+Tp9THVEnd6zVA/6Bc44epBfn/WeVgareyAjOCJKRJUk5M6t7SW1wqQi+TaWZWctmtCZLDib2LNbi7Q1ad2QRjDTRGiM9g9DUZXu9mL/aphQcCnABKhMvults5D2ozkENMt1PBXBAtuSgtM2fhz24dV3ZW5k3tagJXAu1DJKsnMZYLk3A5MBSjWKNn6www4CWtkBvvi7f7vxR7w24LilZ1Zoccr0ZGIxQVvNqUVquFo3Xf1E9nS5n644Gc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(396003)(366004)(376002)(186006)(451199021)(1800799006)(55016003)(66946007)(66476007)(66446008)(66556008)(6506007)(76116006)(26005)(64756008)(54906003)(71200400001)(110136005)(478600001)(33656002)(41300700001)(7696005)(316002)(4326008)(966005)(9686003)(8676002)(8936002)(86362001)(38070700005)(2906002)(82960400001)(52536014)(5660300002)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B+SAwS74/tipXRHOeH78LfVyGesAiaAjWVlYRP3NGhbMxmxmwVp+eiaLlArU?=
 =?us-ascii?Q?7AAX5jBsXNV1Ws3NuSQElESViXzzFYFCMnGVYGjLoF9sD2u4U2lrFI6FW3Ew?=
 =?us-ascii?Q?DFCPJFctXsVwNKIVjJTM4L2dAJfbARXs3fPTQE/GkSbKRJdSqFKcZaOLW/TJ?=
 =?us-ascii?Q?CFdlFZ/nzgongznVZKFNKays1st2SwxaHSv7tYjPc5ka41hj3fyWFB590X3J?=
 =?us-ascii?Q?aJWw6zBCcvpbYer4cvd4emhtCF224PNYaq4Izcb1YZqlv2yBDT4k3XFP2npD?=
 =?us-ascii?Q?xpefyjC+VmWGFxU1oOBvQDYdd67qJ6bxKvXTreuG6hUo7ziSIr3Q+9uS9fHL?=
 =?us-ascii?Q?Bez/1roEqrwDk5/qA/LC3sftUOSrr1JFpJGsV+CdQ4Ei/SrakDCp3/aSslyF?=
 =?us-ascii?Q?v/s6TXA69RM2sSzFgvby20jhfOaAYZQivNNrHP2k1cOlpnQDwZdG4qZeHyZw?=
 =?us-ascii?Q?5hqYwgEDstnp/vyTG7MQHoW9ppQCHcUwZ7Se6gRrJO7AFrwaAvsFLB8sMRH9?=
 =?us-ascii?Q?8oadb52ISUojhb1l5yW8w3iEW18UmBwh4Ppt2QxWAsK/A9A/+rAWeAS4E+tT?=
 =?us-ascii?Q?H6inDbX9VgilPIkIETdXikWbj2yVkNkev7+x3cw0b0oFKfZ0ntKVIJz6zYix?=
 =?us-ascii?Q?6gALr3Aq/8eDKQlMeTSBEHY9GHCraPm8tw+Khsivul3G8uOzk2aJaOjQr1I2?=
 =?us-ascii?Q?Sfp/e6Uw/W+e1BlX5JT43mKswe5PD2Mk2DxtnxWo6G0g6yTFWNuGWPHp1nh/?=
 =?us-ascii?Q?Pq/8GwImo3jKDtQaLpyBXVHwYCGS1I3T6N5LouYEkIgqswzj/E/nv6u9RLpL?=
 =?us-ascii?Q?LBHJTaNV9Xdb132peHxaJ/6t9QgcBaZNqaRVgcl7q1W/sC+xLjhyx3DWQ5x3?=
 =?us-ascii?Q?87cMvCUdx1e6QfBnnfALaKQdutVQNd5iMiAMDRrMiFtqn1RPkJXQ8jCxUpCX?=
 =?us-ascii?Q?3e2QXTUxm30E4VPh2nUyijosrmxI15cWLppmFCWfXTyY7X37bXh0AhKbaKSL?=
 =?us-ascii?Q?FgjliN6E2Fy4cLil/NXFaTRT94FedZreSgXYmz9SxQ+dh0nXz0u+FWJUgHg1?=
 =?us-ascii?Q?Jha9i9B2pue7svAjQ8cbesg4pM9+jUSPurhDHK1IAPG2LlvaP5wh/cgXadXi?=
 =?us-ascii?Q?DsUx+0tnPTq4Av1FhyOu1gTlvZ/NnxGalrn5GA0JP7rzb1TJNsNO7rNYGq3e?=
 =?us-ascii?Q?r+FNkw31LgOigqpv47OF8OvwslYpS2oEGTlX0l6r3wPsv3ltg7aGDBagJEy5?=
 =?us-ascii?Q?1lk+P9O3oEv8jY+shec/ZVm4F4E4Zn7cddk0QIZ8kA4Ci5A7IWOG/Odru2pb?=
 =?us-ascii?Q?bPEOUN5SiNCSfXL67FjXLdh1kWeaxqhgGOu6BUAIkwS4cn3IG0F/TqLTKPPs?=
 =?us-ascii?Q?F6794c+jlrIds2EqUlEfm0GRXGzAFw5a6G61YryYoKDcnEeqCTLdBm7gt/Z8?=
 =?us-ascii?Q?IzTs2GH7zEhzJ1xhtCtcwGCboMIh7c3xkE1k7LYg/5oN5bZjKIpkSOHAbs4n?=
 =?us-ascii?Q?tDG+sWYGjHtUNZeJDLxH0l6xrRbb3uA/MjavicmXZJ6DN0Qccc0+nwjwS4bu?=
 =?us-ascii?Q?EApZ6wXem96reVhZT4BAygoiRluoW8kl+mtI1gZS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 804bcaf6-97c2-45a4-8eba-08db9951178a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2023 03:22:56.9099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zbGGpufrr5x16nBR1txrwFrpWVz9zdvVmLhVMF8I7DJDy/oxsMqWgZ8N0yzrSLSqQoQ58Em1dWlwTAoF4AXnIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6011
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Stefan Hajnoczi <stefanha@redhat.com>
> Sent: Thursday, August 10, 2023 5:03 AM
>=20
> The memory layout of struct vfio_device_gfx_plane_info is
> architecture-dependent due to a u64 field and a struct size that is not
> a multiple of 8 bytes:
> - On x86_64 the struct size is padded to a multiple of 8 bytes.
> - On x32 the struct size is only a multiple of 4 bytes, not 8.
> - Other architectures may vary.
>=20
> Use __aligned_u64 to make memory layout consistent. This reduces the
> chance of holes that result in an information leak and the chance that

I didn't quite get this. The leak example [1] from your earlier fix is real=
ly
not caused by the use of __u64. Instead it's a counter example that on
x32 there is no hole with 4byte alignment for __u64.

I'd remove the hole part and just keep the compat reason.

[1] https://lore.kernel.org/lkml/20230801103114.757d7992.alex.williamson@re=
dhat.com/T/

> @@ -1392,6 +1392,8 @@ static long intel_vgpu_ioctl(struct vfio_device
> *vfio_dev, unsigned int cmd,
>  		if (dmabuf.argsz < minsz)
>  			return -EINVAL;
>=20
> +		minsz =3D min(minsz, sizeof(dmabuf));
> +

Is there a case where minsz could be greater than sizeof(dmabuf)?
