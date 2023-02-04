Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C41968A9ED
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 14:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbjBDNJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 08:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjBDNJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 08:09:32 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F5ECC3B
        for <kvm@vger.kernel.org>; Sat,  4 Feb 2023 05:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675516171; x=1707052171;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rmv+CKpSMoyD7Xc60jHvDkPvcMgVLOZrwk/SfmKzAz0=;
  b=QXnV4Rj2O+juFIBhpB153Pypp8mrA0PYvXWGJGwqVSfz+yRW4Gi9eIzh
   YORD/ZJCGAcw/ZKCLctn7vlAlugVHeYQyrkkAb/3tpdVo0uSdIJrpLVfw
   RnXCj7D0Neucb5iwYD8CsqMo2UXGd49PB2giAyCvkDvZq5CwVJ/B1D1Nd
   652c7Vm4A17SAmRJcH8hxV9q7jQVW0DumHdBwHteM4Uxz7OuxC68QNF+p
   pqYEv7eN654TmCRwrBui5lOoVf6p88hWY37By4MwVoJvklSmjv8xxm2vo
   xyV+l7AIV7Tf9Wjq7JOnlAovk2M0QD5dQmFa9F3eO0don0bI1k+5ZV9IJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="328957548"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="328957548"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 05:09:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="754766222"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="754766222"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Feb 2023 05:09:30 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 4 Feb 2023 05:09:30 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 4 Feb 2023 05:09:30 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 4 Feb 2023 05:09:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5uxjzFnuDevVRs2xCYCtiwieK4bNAVKTGmqWiIhUgjma58OnWMVSKdXuMFFcR7KA10N/f/eH19G1sedFwEnMCS7LIjx2Mh7xYh64bHFeC7Ypg+dRDDs9QsYf1gtjawuC+ZtZ7sRr8xhthchBCYG+ryENnW3dx2s25l6U5C9LyRYqBe9sf7laNj8pt0lE27CDw3ZW5bB0dsFYUCq+voHg3q4on6ifB8evHhwNcw8Dh3catF+tvoYOmgbr3F/zvZhnE/4hC6A0vvYIaR6bhCFNaw0tJMMzEENRyicP4zWpCcUGRsOirH/ixEa2Gui5xFcloQ9xYeTxIsTZou9VB+/mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TfYcU7GyBy6MFtHFrdQDhe9/eGw4rlkjuQFNeNIHMrQ=;
 b=bWP8HLXDGx3Q8QBWTZ5JtdlhCpYj3eGxCYEE2aWuIGf6i/CwpqUbqMkmT1x6Z7xYzJq/4oNsm1BVVISUPKuKA6wrPMrPYKwFFVcIQrpOokZxXrG+lg2CVehh3dyW8ggdRzSSFsUL1r1gQ67ZMLQPlLIVRpHEVU039SJdX9M22xPSBqGyJx15yDGjHKoV2FiI48C9soZ7FZ2riLAAX5T6W93uMHqoc9/K5GpspuHk1iPYJT2QRJ0wPld/Z2QBeZEyRsPgh9nbmqPTXYga+kuUtZ6k/XTEdEGHc68tZtRTp3Y2APpo+Zc9cTLZRlwj9Rn9LDd88cx+jfolGdPdSHte9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB8159.namprd11.prod.outlook.com (2603:10b6:8:17d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 13:09:26 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6064.024; Sat, 4 Feb 2023
 13:09:26 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     lkp <lkp@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Topic: [PATCH v2 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Index: AQHZN6pAgxMUZr7czEyeNEv3R/udlK6+fcIAgAA8qDA=
Date:   Sat, 4 Feb 2023 13:09:25 +0000
Message-ID: <DS0PR11MB75299A027633FE16852599CCC3D49@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230203083345.711443-3-yi.l.liu@intel.com>
 <202302041603.N8YkuJks-lkp@intel.com>
In-Reply-To: <202302041603.N8YkuJks-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB8159:EE_
x-ms-office365-filtering-correlation-id: 19da0865-8f70-471c-9ceb-08db06b10a9c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z4i5ehgr6+lCQJqjAbzhQS1j6p8B3PQXDl+BHmJGam5lEyrBX5f6MmxNhNa0HuL+TM7ntF39CACvEV2r/84s5aYRkImRnEH3tpxAMymQqGOR1ZECx8rdgr7HXcTbW1vmUiqqQgiGJCAZ5D75etP24PJ0AeCGnCO23/YX1YHWyetmG24Ic9x2c4Athj83NmnFWgWi5up7ip79GO4e1jK7vUnaLK380CD7ORVUzcFolb9jYegQh3s6kPSfCB4NKoknoDR/GhYeGbITyYUmzYjEb3tbZxLlWWftf9ym51jtqlS9t+DwZQMGr2b8L2326IZdylhYisZHC88/Z4S2cQJcdp7hBH7NanQCplB2fVLwohfZzK5RBoW3pvUep1LX2XasFaRGn70mEbboR5kFLKPhwDqgNoHNXmLwKGOC2jxzUV24l0hyrzO0A/sQPZhB/UrEgwilf0S1XXJQ10HmwOFhXTsj/4nAaodiaJ/r9XmQjlLvFnqCcrzZVjwGVIHVQAsYGwUxCqvlbafRQHqMNSAggwMSmOHBzHY4AOusxuTnrQLe4ox996/IMNyLMgHl0R98R1/jYKdoPoKrscXMOBPy6eDp5J7gx3qGI7Ac3CoMHHKutIkzy69hotlm6Pp6eMY7tVtSgjJ9FRwJjiy66bOVeUP/bwkKNAvaFiIof5o8+WIEV83NVShcxPTjCQ0mBdJfoKeE3Rj7qd59TRbhtt4UdpLdnHVUx1gwFahPupFTtsPpCAu6PO8Ia4btn+6u0jDD12jddC5upqfxy+VufBZMtUNDwFND1gmMmKTmDGiXJkc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(376002)(346002)(39860400002)(366004)(451199018)(110136005)(54906003)(52536014)(316002)(82960400001)(966005)(86362001)(33656002)(71200400001)(478600001)(7696005)(38100700002)(122000001)(186003)(26005)(9686003)(6506007)(53546011)(38070700005)(5660300002)(15650500001)(83380400001)(2906002)(55016003)(76116006)(66946007)(8936002)(4326008)(41300700001)(66476007)(66556008)(66446008)(64756008)(8676002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GaEePo3MRsoNKWPHIX763Y18CFslJKdb8VF2trqdFVOlR9GoCaQyE6SiifuB?=
 =?us-ascii?Q?zIa9abPsr6o1v2sIJZWzyaieEsZJZy9TPXyC/Lo/18NQ4PxYppu1dJHomfF8?=
 =?us-ascii?Q?ecreKbJtAeoDb6EIJr/3IjgoxAGI5U1Htw8x8jm7ipbdageDuJnLlKT4t/c3?=
 =?us-ascii?Q?z2qQOYORbotbVifHzAGFinws2MDJJawDcNzdSZvKG5jPV5kSKYCLu/MloSzq?=
 =?us-ascii?Q?eHHNObvQRO9PM4wSi6wRPirlEiT2IplfnG4EMJvUWFOjuSU8UYRqVZ5fWzqy?=
 =?us-ascii?Q?CPUSeDKahP7IBBCxxWk02UzD+crA6hayTq7RjvDVK9ONKhGgXEpefUGAE60k?=
 =?us-ascii?Q?WoOCJGS2oUuAX8ZUAYc9J+HHHD6aj93+Z1gmdmRuBrdIggIZtScFH7CzAUjl?=
 =?us-ascii?Q?DBjlUXnXRbD8YxEgjM/tMKmGq/RklHnvMvzFTtE/zYoaYC4bcF9dsoDchWPv?=
 =?us-ascii?Q?Ol2rdKd25/sd46/UgrcEta2OzaYcmcfzbkiwmloqxvLoPjlWZkXg9BLKs/qi?=
 =?us-ascii?Q?v0coUKcf6Ec3gXPMMaaTamI6aHh2bRmUsXUiROr5YguuT1sgaUbcYHWhHapV?=
 =?us-ascii?Q?k9XnPJLwZ3v1toQRvCO4QbB2O7takULzuH8DI1SmgnC0I0Jep5TDjD+gJds8?=
 =?us-ascii?Q?9wqsxJmht9pRoQ/Mgzcgw8xU6lhBpDj9x8nK26AgfHCAxC52CXUGE1lUm3Zj?=
 =?us-ascii?Q?5MCPx73SsWdExAi+dx4v7jJ6x1D9hcZvkNovtP3xHrcQNZyoUdGSGVSLazWR?=
 =?us-ascii?Q?Ieue0NNx+skSKhFpQAfhyBoDc3KhWlcljIjbGdiXwpuGLfv+MgrtJ4o0c8tC?=
 =?us-ascii?Q?GPAgzkGU25luIeEUUIFrRc192q4JNzdmZpAJISTkIXmZW0XRMkQRUTNz9IZk?=
 =?us-ascii?Q?vYp5KE7SVGriMae2mrjL+OS4KceVOhIuf7YRlsRBsu7HgkI+p/rjWXnvfx9I?=
 =?us-ascii?Q?TUGNUeEoaypFqBimgnkcpXP7KIjfzWmBANS8BEcRTxMDpYLFhGFS4hI1CWZH?=
 =?us-ascii?Q?cwtsHNcWD8o5ZdlO4dIBS2qgF4UHzB2I8kYw0phPetCy/CvIxB0n/0avQxcR?=
 =?us-ascii?Q?Bkk9QFyypPuG5QIM5rCqSWPtv56nKnsuphwdm7vlNWgZ4PMbGv8GmM3ndk5k?=
 =?us-ascii?Q?DLKcwvvVM5riDnktyCFHpuZZiDVO52i13a72Kl9Be5MzevhDwSNE0btU6ihL?=
 =?us-ascii?Q?mh2drAXPIqGvCP4x3o5L1IsiD9fOsRYFMViWgVPQpv2U8xwf3tAr/rI/lv0x?=
 =?us-ascii?Q?loFQWuukE4Q9Vds9GZjRQoRyDc8fm3449Q0Iu8pXYAygXbB/OjD8HZID4exf?=
 =?us-ascii?Q?N89mgqHvWFC+c3Z04ane3Bhj4mBFrZx1kMmCg4JwEOFxE20fTRPUsKjr0Tg5?=
 =?us-ascii?Q?Hy3zTX9bLa4zk4yN/lijIEYB3yiltVUIiJbIwksK/qPJdC5WjoHe/2GQhoEt?=
 =?us-ascii?Q?njLUy+Pcr0GyuaUeRV/dz9zU8DKs6PbCpn+PqFwJUv1sRIJUHUT3cCM2MU+8?=
 =?us-ascii?Q?6tpskqDhlvlkcgLLH4QVXAOd3jHQe9juERGFSvdRwXlFkA7E/5B8nyKnV217?=
 =?us-ascii?Q?LaIyz2kaKyGIORYw659dt8GreQBrew00FgpsBK47?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19da0865-8f70-471c-9ceb-08db06b10a9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2023 13:09:25.9914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /oI+tr4ASvmYJRkeFhmnMH0/5P1lJEcz6UVBlN0etxSbHN4azp8KlIC+Oh98fu1lXqJ/hcR5idZfkcZfkrTM2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8159
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: lkp <lkp@intel.com>
> Sent: Saturday, February 4, 2023 4:56 PM
>=20
> Hi Yi,
>=20
> Thank you for the patch! Perhaps something to improve:
>=20
> [auto build test WARNING on awilliam-vfio/for-linus]
> [also build test WARNING on linus/master v6.2-rc6 next-20230203]
> [cannot apply to awilliam-vfio/next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>=20
> url:    https://github.com/intel-lab-lkp/linux/commits/Yi-Liu/vfio-Update=
-
> the-kdoc-for-vfio_device_ops/20230203-163612
> base:   https://github.com/awilliam/linux-vfio.git for-linus
> patch link:    https://lore.kernel.org/r/20230203083345.711443-3-
> yi.l.liu%40intel.com
> patch subject: [PATCH v2 2/2] docs: vfio: Update vfio.rst per latest
> interfaces
> reproduce:
>         # https://github.com/intel-lab-
> lkp/linux/commit/8db2c0d3414387502a6c743d6fa383cec960e3ba
>         git remote add linux-review https://github.com/intel-lab-lkp/linu=
x
>         git fetch --no-tags linux-review Yi-Liu/vfio-Update-the-kdoc-for-
> vfio_device_ops/20230203-163612
>         git checkout 8db2c0d3414387502a6c743d6fa383cec960e3ba
>         make menuconfig
>         # enable CONFIG_COMPILE_TEST,
> CONFIG_WARN_MISSING_DOCUMENTS, CONFIG_WARN_ABI_ERRORS
>         make htmldocs
>=20
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
>=20
> All warnings (new ones prefixed by >>):
>=20
> >> Documentation/driver-api/vfio.rst:264: WARNING: Inline emphasis start-
> string without end-string.
> >> Documentation/driver-api/vfio.rst:296: WARNING: Literal block ends
> without a blank line; unexpected unindent.
> >> Documentation/driver-api/vfio.rst:305: WARNING: Unexpected
> indentation.
> >> Documentation/driver-api/vfio.rst:306: WARNING: Block quote ends
> without a blank line; unexpected unindent.
>=20

Hi Alex,

An updated version to address comments in this mail.=20

From 6d9c6f9b3d10da2923b28d8cfbf5fdd39e5fd8aa Mon Sep 17 00:00:00 2001
From: Yi Liu <yi.l.liu@intel.com>
Date: Tue, 31 Jan 2023 06:16:50 -0800
Subject: [PATCH] docs: vfio: Update vfio.rst per latest interfaces

this imports the latest vfio_device_ops definition to vfio.rst.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 Documentation/driver-api/vfio.rst | 79 ++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 22 deletions(-)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/v=
fio.rst
index c663b6f97825..0bfa7261f991 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -249,19 +249,21 @@ VFIO bus driver API
=20
 VFIO bus drivers, such as vfio-pci make use of only a few interfaces
 into VFIO core.  When devices are bound and unbound to the driver,
-the driver should call vfio_register_group_dev() and
-vfio_unregister_group_dev() respectively::
+Following interfaces are called when devices are bound to and
+unbound from the driver::
=20
-	void vfio_init_group_dev(struct vfio_device *device,
-				struct device *dev,
-				const struct vfio_device_ops *ops);
-	void vfio_uninit_group_dev(struct vfio_device *device);
 	int vfio_register_group_dev(struct vfio_device *device);
+	int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 	void vfio_unregister_group_dev(struct vfio_device *device);
=20
-The driver should embed the vfio_device in its own structure and call
-vfio_init_group_dev() to pre-configure it before going to registration
-and call vfio_uninit_group_dev() after completing the un-registration.
+The driver should embed the vfio_device in its own structure and use
+vfio_alloc_device() to allocate the structure, and can register
+@init/@release callbacks to manage any private state wrapping the
+vfio_device::
+
+	vfio_alloc_device(dev_struct, member, dev, ops);
+	void vfio_put_device(struct vfio_device *device);
+
 vfio_register_group_dev() indicates to the core to begin tracking the
 iommu_group of the specified dev and register the dev as owned by a VFIO b=
us
 driver. Once vfio_register_group_dev() returns it is possible for userspac=
e to
@@ -270,28 +272,61 @@ ready before calling it. The driver provides an ops s=
tructure for callbacks
 similar to a file operations structure::
=20
 	struct vfio_device_ops {
-		int	(*open)(struct vfio_device *vdev);
+		char	*name;
+		int	(*init)(struct vfio_device *vdev);
 		void	(*release)(struct vfio_device *vdev);
+		int	(*bind_iommufd)(struct vfio_device *vdev,
+					struct iommufd_ctx *ictx, u32 *out_device_id);
+		void	(*unbind_iommufd)(struct vfio_device *vdev);
+		int	(*attach_ioas)(struct vfio_device *vdev, u32 *pt_id);
+		int	(*open_device)(struct vfio_device *vdev);
+		void	(*close_device)(struct vfio_device *vdev);
 		ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
 				size_t count, loff_t *ppos);
-		ssize_t	(*write)(struct vfio_device *vdev,
-				 const char __user *buf,
-				 size_t size, loff_t *ppos);
+		ssize_t	(*write)(struct vfio_device *vdev, const char __user *buf,
+			 size_t count, loff_t *size);
 		long	(*ioctl)(struct vfio_device *vdev, unsigned int cmd,
 				 unsigned long arg);
-		int	(*mmap)(struct vfio_device *vdev,
-				struct vm_area_struct *vma);
+		int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
+		void	(*request)(struct vfio_device *vdev, unsigned int count);
+		int	(*match)(struct vfio_device *vdev, char *buf);
+		void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length);
+		int	(*device_feature)(struct vfio_device *device, u32 flags,
+					  void __user *arg, size_t argsz);
 	};
=20
 Each function is passed the vdev that was originally registered
-in the vfio_register_group_dev() call above.  This allows the bus driver
-to obtain its private data using container_of().  The open/release
-callbacks are issued when a new file descriptor is created for a
-device (via VFIO_GROUP_GET_DEVICE_FD).  The ioctl interface provides
-a direct pass through for VFIO_DEVICE_* ioctls.  The read/write/mmap
-interfaces implement the device region access defined by the device's
-own VFIO_DEVICE_GET_REGION_INFO ioctl.
+in the vfio_register_group_dev() or vfio_register_emulated_iommu_dev()
+call above. This allows the bus driver to obtain its private data using
+container_of().
+
+::
+
+	- The init/release callbacks are issued when vfio_device is initialized
+	  and released.
+
+	- The open/close_device callbacks are issued when a new file descriptor
+	  is created for a device (e.g. via VFIO_GROUP_GET_DEVICE_FD).
+
+	- The ioctl callback provides a direct pass through for some VFIO_DEVICE_=
*
+	  ioctls.
+
+	- The [un]bind_iommufd callbacks are issued when the device is bound to
+	  and unbound from iommufd.
+
+	- The attach_ioas callback is issued when the device is attached to an
+	  IOAS managed by the bound iommufd. The attached IOAS is automatically
+	  detached when the device is unbound from iommufd.
+
+	- The read/write/mmap callbacks implement the device region access define=
d
+	  by the device's own VFIO_DEVICE_GET_REGION_INFO ioctl.
+
+	- The request callback is issued when device is going to be unregistered.
=20
+	- The dma_unmap callback is issued when a range of iova's are unmapped
+	  in the container or IOAS attached by the device. Drivers which care
+	  about iova unmap can implement this callback and must tolerate receivin=
g
+	  unmap notifications before the device is opened.
=20
 PPC64 sPAPR implementation note
 -------------------------------
--=20
2.34.1


