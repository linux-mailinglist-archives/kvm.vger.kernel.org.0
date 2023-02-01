Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F80685DC4
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 04:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjBADOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 22:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjBADOR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 22:14:17 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1FB5A349;
        Tue, 31 Jan 2023 19:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675221247; x=1706757247;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FRvuarMZHFC7ydV5KnBS2kjUP6bBP7F0Tq6rP48poaA=;
  b=T1bwRMFxiKVNZpmDeC0NgGEbTs31V1sWNvewFnIPiDWxDcZhuV5HF230
   U17KczsO+xRIhmfVZybPhpUKZ6yPkUhTtV1hKtY/Bs1jIzYJ4REt0jqie
   EdKGXym/8QsA7qis4XvWiz77KfmeAg4BN73xTUM9iw/LwVvJUeGjctXtk
   0bKWdJ9xYYYGBBKlhsBbJxJgDZ/Dmtegn4cnWoq3RVU6mnY/DegkPf2yf
   KocDeFh5g8m3Z8Cm2OoQo8HE0xG6K2eA56HX0zVrcysgZmhinumc1FILY
   1GImtrXwyJrrV0YYe1mQ/4jzsuRZtH8Ln+M/Uktyy7+02C0T4FBzQi4Dc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="307682354"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="307682354"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 19:14:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="728205877"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="728205877"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 31 Jan 2023 19:14:05 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 31 Jan 2023 19:14:05 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 31 Jan 2023 19:14:05 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 31 Jan 2023 19:14:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sf3DQ3Layoj79AAfFifN5Fo3R0wVj6qtyUTJrnMgmOPRjVkGLWFjienfeUiT36Q2exdgfi6lQ8JeGq888UC4w7wOE+hieJJbu+DQttnaOtRENj/kXgmX7I43vTCw3+bG4S2gp55nxKQq/peIBRPl+SQvaPif2TPL7Vt2dBMNzMJgBoPU7K/abiLu9UIu970Znj2Qzm/v5/UwUotl14lsVJZQTzl2hvduuz+MxxYujPc0pJShbwt6CDJTZOGAkddD45qPSJdzxMuUon4RxnpkQWXy1PSEBntFlaNcEyItjt0E2gZMklQ1L/Fi1l784UMrZc/8VAUaowpwV2eV9/CSkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FRvuarMZHFC7ydV5KnBS2kjUP6bBP7F0Tq6rP48poaA=;
 b=VH4DcTbMd049eYkErxCsHUuiQ9NMthcUDmW+eaP2zbAcJJ6jdaNKRPborWr5bh+JUO4KFIXNGxXTc9+vpMyG5fe5f0rB61iTe8cHh4ybwfBFMqw71WJG+e5nbM96AsHeu2QsUhSsBpaHms6VUjwZqCOPG5RCQ0zYs1QNtRvQS5FuuGLc3ssTR5VWGkXCJYh8RHkaDITCezp73J4lA6e9GEmZXtEoiBaZcYUZFlJp6F1I3Ui5ML6GykQJ/1voUAFvPWLURFu59BL4qOUDAytGdANvQUbB3e6x14cl2egkHPudlRwHHzn6jBMxyA9JEIHh0Ufb8GG50RpRDHAp5zTY2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL3PR11MB6313.namprd11.prod.outlook.com (2603:10b6:208:3b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Wed, 1 Feb
 2023 03:14:03 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6043.038; Wed, 1 Feb 2023
 03:14:03 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Robin Murphy <robin.murphy@arm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "agross@kernel.org" <agross@kernel.org>,
        "andersson@kernel.org" <andersson@kernel.org>,
        "konrad.dybcio@linaro.org" <konrad.dybcio@linaro.org>,
        "yong.wu@mediatek.com" <yong.wu@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 1/4] iommu: Add a broken_unmanaged_domain flag in
 iommu_ops
Thread-Topic: [PATCH 1/4] iommu: Add a broken_unmanaged_domain flag in
 iommu_ops
Thread-Index: AQHZMoqzsVwORV4fDkqb25GPYvi+2K6yz/kAgAAgNYCAAhsCEIAB7paAgAJ2Q5A=
Date:   Wed, 1 Feb 2023 03:14:03 +0000
Message-ID: <BN9PR11MB52769E3A3DD09983C11677F88CD19@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1674849118.git.nicolinc@nvidia.com>
 <0875479d24a53670e17db8a11945664a6bb4a25b.1674849118.git.nicolinc@nvidia.com>
 <dfad6d75-6f4d-99ef-1c6a-4bf397dcaa13@arm.com> <Y9RkG2dejdXptUTB@nvidia.com>
 <BN9PR11MB5276C9BDCCA7FB295C25BC738CD29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y9fHJSTIP6zXAStX@nvidia.com>
In-Reply-To: <Y9fHJSTIP6zXAStX@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL3PR11MB6313:EE_
x-ms-office365-filtering-correlation-id: c9dd0070-8ab8-4548-4755-08db04025f2d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KQ2wl9l9mHXVrjx5UageLe7oDXt9RgFJgVUBAQ/RHWXTEN33wwuai/6O/F7TH499xtAd5ZPdElldbST5E/qONPKhU/cQKRzw+JIQCuc7/EHs6O3jr16VHZzLWLdXXcTGd91ydOIchNobhCE7C/fNiT1YVtl+gnKRfEwT1MN4fo7/p1+ix06CfIgKZOjoBf1fqI5UEAYjLkDjtmWsQiv+cmeQ+g+KTBrxVxtzvNpoQuUcJTYxmFg7qy30vs3gaMkOhqx0LMVXCelhdSPhlMJsBHUrYiWecaIHcgf6cX3Xi4Ym9VmCheaYv7GdgQQSW4uWRmPYOxIBA1mRumANQQ+pBGGZXpU2JvLe53A6UICXoBH+lAk523xtyQM6nSvrj1k2eHZVyRDD3WW41upfaQ/ohY3R87a2XbWMuIn1R93Cstn6WMgAym7SnFvbVLGorf6VVfhiH8VXmew+PlKoBumvlWJGpOn9qeiRiOtdVDQwOqcUVgthHOyjQEJs/UpPxfbTjJBjArqCaT1BeuuXm/nznttxueM6e2KCkl63kynczHpp8tJZNrJ4UYdEGJuMJAXgvOJ8tUdIHIvSXj+XlO4dP+0Mqu/CNepGGcBtRjkuCXo8tXVMxo8xuUMkUZhN4koSK+alIu9J3LUReMhLdmQhw1/QN4pb93/zveLgo2PC9ID9d66v+hme4akZQOikPWoeFBQCMfX5L/vq17gNdrGImA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199018)(7696005)(71200400001)(33656002)(66476007)(64756008)(66556008)(66446008)(6916009)(8676002)(41300700001)(76116006)(8936002)(66946007)(4326008)(83380400001)(478600001)(86362001)(82960400001)(2906002)(122000001)(52536014)(316002)(38100700002)(55016003)(38070700005)(5660300002)(4744005)(6506007)(9686003)(186003)(26005)(7416002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o02RaQplbTVy/So7gAv2/JFJ2q9NPaj+FTV8NZy6hKaXgR6zWFoguwUIS8kr?=
 =?us-ascii?Q?GvE10GekbiEXVGp5KE8NOS8wCjrpnQFy5R14ztFb2XH7nV8ZJS5pmO8fjdol?=
 =?us-ascii?Q?vxmvbNOz4zz8K1ixUAl4wLrgHmXzx/pltL7ruTel9r/cvsC4tBGWu68wwlka?=
 =?us-ascii?Q?uFsUeZ3YZRu11166NAInf2oIdz8f0Rp02Ewst8vewd/NHyFEQwi05MgYpi7d?=
 =?us-ascii?Q?2964HVCtqNNgS8CFD7JA+E504ps9w3q9bZwS2UluO/Tlm0aruK5h14meMD5x?=
 =?us-ascii?Q?7F//5100DW+lOh9JSa6e6DPRcfIxbl3HI1/8kr4SAmamjgAH8g1+YQqgcQEj?=
 =?us-ascii?Q?A4FlpDVePbcjpDLyhNeGSe87qoag+qBiCb+jMsviBs1p9qMzMAWA4++X+7xu?=
 =?us-ascii?Q?97eis2owt+cQ5RkfeBp6s8vlzVSGWstxb56UC2H3eggfAI9uL2o40liihP7S?=
 =?us-ascii?Q?d8n2mfTGkoFpU7K3N8Z3Dch7g+bxFA7Ed+ZyQAF0YxcJTYg6fPSvdS95Ao+f?=
 =?us-ascii?Q?Fysb8XNjHglI/hUEv0ignURBk0FxCf5xWzJk8+yuTXvfCa2GLfhB3lKDaGvw?=
 =?us-ascii?Q?v0HL4cPaEJMWjtLjP3s3Bv6/bBVD4KWD6Z+IdslxqxaCkGMB329rLcTW1d22?=
 =?us-ascii?Q?LrDmY8IO0/1CmEyZWiiekxb3yBdJJy/s79gEmIuIISyoabUpEJQut+S1iHnz?=
 =?us-ascii?Q?O6ufmiIiBHxOsl5YIeBVATZZ4lZLBi0+3Ugdu1fZ5hFWvzaDqwRvJOwOzGlg?=
 =?us-ascii?Q?uW5cLR+f05qq/wx/3iiqhRfjmakfbykD/cnbRTm5eqDQDMpIx6aPHLbDkBgp?=
 =?us-ascii?Q?zFoynmcX7qxPPhNS0NcC05W/ZHz+dlytKIpsa3bTIL6mjodY1VNtWEbQGunB?=
 =?us-ascii?Q?EcwpG89WGUhk2jrVfFLE5T6pRdaXKcgUvO4MQkn3EXX2Fi8hx4KzpLYdpczu?=
 =?us-ascii?Q?F58FkwqDWl0V0ta+qktZBnRlXcs5dKWkb4xb+peGQgbngURZwZ1z4bibkqDg?=
 =?us-ascii?Q?Y8YDLdrSKElx98S/B04+rECtBuuYGpVTuF+YW5Aj48NcGjI70EvfPQIUP+fN?=
 =?us-ascii?Q?CLmkmnblo/Bm/BukZjHySiM60fjp+2LTXm651N4/awzT7QdjuyGadRL8fCjT?=
 =?us-ascii?Q?RlPoSea1tJKkEGfET2PdIrADOPSMIsh3sYIgGIss8VCqRQQ4qmj/ghl1PoXM?=
 =?us-ascii?Q?YSdap0/O1zsc5VXrgZBUQZenXNsC4B5Oh9HubtyFTvd0Sgv1eR9qroM9ixtx?=
 =?us-ascii?Q?83UT0GX3scJLTsd2poOsX7ZsQdRnPBUtQUkXAaUQqPkHwj6WJIx6vvkL5O0e?=
 =?us-ascii?Q?+F3rUnuwi79MPJ0i77kEIIwahmQYtR/PJ7XrY2AZogradmmASF4GoN07J13f?=
 =?us-ascii?Q?Px39NBvun/aSZsaH8Gvmw6fq2uie9jeukEVWrR2gTcAqOA2/CWyalJDb72Vy?=
 =?us-ascii?Q?TlhyGd+trTzzlbW2V3jGZ0jsy35dtGS+eJ5efmXuftv7C6TA3lCyHAQm8e+I?=
 =?us-ascii?Q?e5H7o1+bPRHNSv5AsuCDDbUNUARx6/dihB63iGYW7yHQSm3PYWwY7MmAXIHT?=
 =?us-ascii?Q?75fOh5uX828nzS25EPkXAuT3lFzm5M62Oway9BVY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9dd0070-8ab8-4548-4755-08db04025f2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 03:14:03.5680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q6U4j8QjWXXbAp195cCUJP0fet+rV9NbdgFkH7gU6oToOaABtJL6P8dV1KsrvYXLw94G+Ro0vb8WJOj8Ay9Ypw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6313
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, January 30, 2023 9:33 PM
>=20
> On Sun, Jan 29, 2023 at 08:11:48AM +0000, Tian, Kevin wrote:
>=20
> > " I'd also question sprd-iommu, which hardly has a generally-useful
> > domain size, and has only just recently gained the ability to unmap
> > anything successfully."
>=20
> So long as it has a correct kernel API and exposes the right (small)
> aperture then it is OK.
>=20
> The device will not be useful for qemu, but it would run some dpdk
> configurations just fine.

I still didn't get the restriction here. Can you elaborate why it works
with dpdk but not qemu?

Can qemu verify this restriction via existing path or need new uAPI
flag to communicate?
