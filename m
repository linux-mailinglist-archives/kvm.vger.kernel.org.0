Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808BB63728A
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 07:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiKXGuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 01:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiKXGug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 01:50:36 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334F3A3408
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 22:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669272636; x=1700808636;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=47l+4hYCQYYTonq1Y8RoB9XX4v62exbBpgQBFGVpSao=;
  b=jb/B6NUJ9uaGkZPPRZ8/gzXuwQ0cMPAcNyykjTlSI5AEfLhwlPWiMZ83
   2s7pTFGFo0/E+K6Eq6OrAKkn/PTQUU3AuT0E8/rNGO4AZM3etjAv+tQR7
   1I/N4G3O8MVlMRg4iCDgxcGE4qfHUOkt7m6qatHVAHDEepIKD3srD+zRm
   unIFJuqfPV6HSOC8Th5qRny/KQmw4Tve1z2kgKgNDKp8rCD20gDQtl4Qj
   iWVcdFwfdnPgifLHHASRMRQYC6GiH5dVoWqF7QznPSTWwQ0v2WXhOLeX0
   BG/zV+AeqCy+6i/+DYLxA1P7HWtfSPa3/FZIMdwZiBU+96BUVstRBSKSL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297589608"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="297589608"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 22:50:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="731033550"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="731033550"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Nov 2022 22:50:35 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 23 Nov 2022 22:50:34 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 22:50:34 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 22:50:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCuOViiATdOhMqGr9QIIWcACoz0eW5xyEJXSpSrMWLD5rr/mCo89Zuij0S+dLdWYemzVfx3Yi2BaXGCRJRaXulnUD0ZxoXC5akywjyfwwJ3E4Ln9jQzvNvtL0k3ri99k+KLdiV0uayJSTdOp+osQA/79coB/sFCWJQ2JUVd+kLx+OKFmd8XvVqLzm5RvqzOplghynheHVa2J1whWn89V1yGkGPaJt8JNknSxhMsnBDowip556GksWkmVLUJlnf3QnH+2v/wY5L5UjS7Kq8RDP4j2hFugo0I+ZXggSTy8+co56iH3ebcC7RJ2yrJgo9Mxeijx+ZmNTQ7lp0Udnb4qYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47l+4hYCQYYTonq1Y8RoB9XX4v62exbBpgQBFGVpSao=;
 b=igl1ShotB1UqBcHJRlnBsWmcCbYs86A3AEjR8whzENdt2DJ2axvwuUCqwd+U2KxDNWcTbAQRVqiXqV1OxZZJBYejD21BVI+gzz1F2Ho3xstXqnCvjlGXPWnkF455Dl2KTNBNnthbNckb8lKxu51XYUdCTnxIDMmDGptm8sKOOo5TNl4kqKa1EfloswAa6cNeYzNaOxKLdeHWHhIIZXtuLuE/mhhMq5fAjEtoP4FvSzKv2e/4daJZFN5ffVBf0VopilpGTY5ZO4/CGiqx8Ugpe6iB3ruFuO3QedHD+Nq8WeAiDLx2ZcSqmlSwQ/t//03kX/l6k6e3LEUEGvKF24bYcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA0PR11MB4735.namprd11.prod.outlook.com (2603:10b6:806:92::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Thu, 24 Nov
 2022 06:50:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%8]) with mapi id 15.20.5857.018; Thu, 24 Nov 2022
 06:50:33 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "Halil Pasic" <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        "Zhenyu Wang" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Subject: RE: [iommufd 0/2] Make mdev driver dma_unmap callback tolerant to
 unmaps come before device open
Thread-Topic: [iommufd 0/2] Make mdev driver dma_unmap callback tolerant to
 unmaps come before device open
Thread-Index: AQHY/0JLydHQzQG62US/HVV4xP+tZK5Nochg
Date:   Thu, 24 Nov 2022 06:50:33 +0000
Message-ID: <BN9PR11MB5276DE5010A39F50C9C657AB8C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
In-Reply-To: <20221123134832.429589-1-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA0PR11MB4735:EE_
x-ms-office365-filtering-correlation-id: 9ae60721-9bc9-4430-c206-08dacde82f06
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YZg6DdWiQJPNaKYwj1R/zBnb/ugq+ZNUNbyPechjYD+W1+LqmIR8uP082mM0RddPIuJGGsxPSrnPy0FffKtRRZNFbOprQVGVSEwDfrQ9mHDLFMG/7wFd6UBmzXhR1YfIhHWHjM9Hwe+QTfS56EIeqvVkr8IZYfBNLGsYC8OjOtaAq8kjT6iMDvQ8dbNmLHEr8IdSKBqq5bY9l1/QQvAeg5/YgPh/TfAC6NLhmHTbYVpo+XtTlXPFCmnPM2vqtO3kZ+l+vXuSsiUiYmDzALU9DX+7tX910Q33umiHpOklaOXtcd8HScNsFXdogKerocXI6uchasPRuh6HuaQW5cuuBRkIsmrC9cn6HYWI9fNF+nBFAupXGJD2xGelD2vk7dsBByyvIjPd9wylsPskmB8xl2L1lElO1nbH/EmLZa9Ke52e35IG+2wIwuH39thvmu3YRtguQmaKZyDTAG8zW/QSoXSneU/iHYyxBw27ckdUDOCpZ/idpYcRURC7Vts1ZIu4Dvm8UbYWgSPMPOQ178sn69Wp3aCqfmq3ULwqJjcxqPxXOK+g2TXo7BRMBKWm8ZCgP8AX76iNMTM2HbBqNuxjhPjRqNdTUN+1f1j/o71jCTqtNo6zao25+sD+VY83A7f9YSGI6qEPWddrSy9aOGtV+qAlU1CIcbJcYujP7siC7na6JprRFlDs+w0FP4uLgXPT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199015)(33656002)(83380400001)(86362001)(122000001)(38070700005)(38100700002)(4744005)(5660300002)(2906002)(55016003)(64756008)(8936002)(8676002)(66476007)(41300700001)(66446008)(4326008)(66556008)(7696005)(66946007)(26005)(6506007)(9686003)(52536014)(76116006)(186003)(316002)(110136005)(54906003)(478600001)(82960400001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ylOVWju7EQzvlj24vM+r+KivN7jYIf8ufO2UDzvQvsrnhj63jkNq+mhtvOC0?=
 =?us-ascii?Q?2I6TjP0j/0YOiGAXH/T9AZS2umtb0uzKuFY+zSUy9tZkTA0AYTiBcSBdGuVj?=
 =?us-ascii?Q?mD5B9AO6iNfLSOHethFv4o5U+b8nVAFi0ssFkdlfoP+1+WpK2wI5aHuUtt1p?=
 =?us-ascii?Q?SHoPXpLHOxeDgALlkYUwMJa69QAikGe5ldPLkFKogz9DYQlL8ep9GAtA6jpV?=
 =?us-ascii?Q?ZWxr7BVqDau9G62ymgsH2U3NGiuXEkENC1fb71gxabj5rXrH6uz1WOqWmSWO?=
 =?us-ascii?Q?FNKkeKa8wiw9RZiXE6kH35z6DmaTHJ/MFbeaIi71MyRAOq+UhVQt9EIkD/1r?=
 =?us-ascii?Q?Z+Ubx8J3yAIoWmSAGpbL6gWV/jK3aUHUevdl8ES+r0VHoOafET2QzANRIJKb?=
 =?us-ascii?Q?1vaZiJupMTqbK47LPzrTjOkD9oaRYgPAOo3SXsjOmIO598F/k1VlU52LcUPq?=
 =?us-ascii?Q?zcv93gTL/m+qbr9UtaDJ3SlJFBNOei4AAUaGg3QO7/c4xYfeJSdNPCSH7sqP?=
 =?us-ascii?Q?YP5L7uiW7loknr6G3N+d8TGAsVsJvNNBCOXVjwwC9t2OTJ/FKljeIgp4mYR+?=
 =?us-ascii?Q?cmnFowOZgLexWMiIZpEbSQQ+TCy7Ce7S5xLCdNeIQqM21wnmhdOiimA/zE3S?=
 =?us-ascii?Q?zXk6MJYGvF0lluQaZzbR0x6oHpxRMvRqbPkwJJwBGPYS+/txdWM+mTn8LxDC?=
 =?us-ascii?Q?COaelNhEzn2xqYFb4buGlM82ohk7X4p7N9BCiWOC7++jaiUDSFoUn9Ebm9We?=
 =?us-ascii?Q?VrQ5qNsmc6Kv0IsQXVlqyvspaWG9WQrb+oi5GQ9W+2QUKWA21zNUxC+I4FNg?=
 =?us-ascii?Q?MZKYQv6MlBa+P/cZyWU74WEe7uAgzpPpceyp2tHVFRV86O0+63Okm4MZRDnu?=
 =?us-ascii?Q?cu8VUTjUYC22XKfd2Ukf4PkxSklK4vfMwP2J+rnqR0RU9igCyaBqYPQAMsgY?=
 =?us-ascii?Q?QqhoAys+nLot9EtCabaPiYmGPtnXABMkIykSTZCs+DbZx6DzMK4YeOAxdJiB?=
 =?us-ascii?Q?7kh4bMM1l1JPcykYadTk/A4AKaVTdLCWDmMTBSHh4zZ6wwUe6QxEV96J+4gw?=
 =?us-ascii?Q?Xi7Edzz830DA9VzKJiiVv/iK/u110pc7LBgL1rBPfDcEaLMfZXBTPCTtbzvc?=
 =?us-ascii?Q?RpU646KuSAR0/UrH87d4tzMu7y78SEUCnC71Ieh9nKfxyRda04oHF5keWEPw?=
 =?us-ascii?Q?0sXW/Q7V8lpVlBJBxl80PgRdv2awn0ZRwqmMU4c7nGxml8q2A202ttM5kdcQ?=
 =?us-ascii?Q?qxvHcUlzRLWYHI8I5LaL4Uyp+Y0PQI/LybIQpETUbwA1jYdKRo3PgJK1IF0P?=
 =?us-ascii?Q?UcI3K3X/WbAnCSmJ93BcjGaU0kQoHCDa+eB7h8RQCvRHrAoqF4WafHPfJtjY?=
 =?us-ascii?Q?cy34LQqm6Ntfl+eUIiOZsayzFtk70ecUlYFVXcyj1qPHRGUmRhoyWWZ6H+os?=
 =?us-ascii?Q?cPkijqGPun3kCtOzCLODt5Kb35UURmow2alx26vOOyLX4ubKvciu/5CKS9m+?=
 =?us-ascii?Q?3c/+sxt7TTPyfPFIKpzGy0GSEl1C363sw+f2CcP2UZ/R7eAaMk/XT1rU6JYJ?=
 =?us-ascii?Q?/ieuUOLs6p0Ajgxem+bwteX0Hea7LIrjLFdmb1iM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae60721-9bc9-4430-c206-08dacde82f06
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 06:50:33.0956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4lMku9e6+ncYwS9de2nkljaUZbf8dVlt5OS8jz6GRY9aVKXkS6oU8tsgAInw/iVvrgC+0hoU/v3uolGz+GXXnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4735
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, November 23, 2022 9:49 PM
>=20
> Jason's "Connect VFIO to IOMMUFD" introduces vfio iommufd compat mode.
> Under
> this mode, vfio_iommufd_bind() creates an access which has an unmap
> callback,
> which can be called immediately. This means mdev drivers may receive
> unmap
> requests before the mdev is opened. For now, most dma_unmap() callbacks
> are
> tolerant with such unmap requests, except for gvt-g and vfio-ap. This ser=
ies
> tries to enhance the two drivers.
>=20

there are only three drivers (gvt, vfio-ap and vfio-ccw) providing
dma_unmap().=20

I'd not call the situation where only one driver is OK as "most
dma_unmap() callbacks are tolerant".=20
