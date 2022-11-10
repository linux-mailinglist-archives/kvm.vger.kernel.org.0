Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68973624D7C
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 23:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiKJWJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 17:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiKJWJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 17:09:38 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8034D45A1B;
        Thu, 10 Nov 2022 14:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668118174; x=1699654174;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=czE5FFFEOGcSmug+lK0OSFoZeqsg+hCBwG02X8JDp3M=;
  b=lASmPG2Hgcpz8W4BNO4FM5Azr9BsXlO2Jg3+63EF74wNaSn+P4M0NJw8
   aFvwTqU7ZIO7Zj1Mb23GqdWJ/bdhkrRV+5tK65fej1fo5TgMVmMINlOQJ
   /ZUjdG2R2/UKroy5y8nR9Qpr4WIC1L2L5/0Xi97qtSMdzdMdynvwAkipk
   OgjJXFJJ7968Z5Yg1NsmSd+3T6M8YRvoH/Mr8QSXVx1IKnDg88eFf11Ck
   DHMftiSpYe5FVfedK3FFnae9BuSdZepWFzqi+jTXbB9DaZyVGgrY2citm
   W8kXoux6V0Gv9AFDq2UrGg2/sDDDmXcapgSs3texMhoWpPa1MCPadzU8i
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="312594511"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="312594511"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 14:09:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="726559048"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="726559048"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Nov 2022 14:09:33 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 14:09:33 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 14:09:33 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 14:09:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idf1IDrxQY6W9Pc0LuKRE6xz5s4jTnRm+fM/ak0iIvJ2i66M2Ow9tbIsWh+OBsPchfbFAkVOOzQeCnD2aZxr4d0gXkZj+Bf6B4Fn8QU2K54mffI1ofFwoJA9d2eFrHQEDOOMXrm74JZiOah3echbCW0htvpFSntkkRXP+tRPTa9a3Z7g2xCr4wVW34b4pXPbHVFnDpAKDYYCTmZUespRa/mUFUpl0dhvgUuKP95+itAYyvvCc5cVzy42xp1X468kYM9POD7XWoxzn5k/aXV0BOoeLDgX7bdOHIYthFMEfpZCf0Ye7Ouev7n7d1SPKGN14uhRWxq4ogc+wuyYTG8jfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=czE5FFFEOGcSmug+lK0OSFoZeqsg+hCBwG02X8JDp3M=;
 b=aJwg4QKo9TzTJASmIGuSK1Qr/eXNgvJyRzJUMGB/PM2GrHpNtuJW+sYxp1n8nsYeGTc8T4gpJkq5HptB6IQgV+n7VBQwR4W5+N+r/K2Afv3kzPZBDolqlvWMcswWqHjSgzl7O01ycFkJTv98HaRAXEOCplwzFc+ReeyaSUYXT8/1m0Hj0JKxpx0/b5AN+OQqnJPdDkoT51hxDOn3f32G9OdmltbSvSgb4TL2nZdErbYUNgnIYU8zmD2b2ananhsRXyfbh2YZJXu5ugo48ir4I+a7WqitdMDuyDpOc8VBuYqUnK8tNiFnCVwi3s+YMYkLfVSz22bp5hn33xR1eTEcQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by IA1PR11MB6515.namprd11.prod.outlook.com
 (2603:10b6:208:3a1::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Thu, 10 Nov
 2022 22:09:26 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c%11]) with mapi id 15.20.5813.013; Thu, 10 Nov
 2022 22:09:26 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Ashok Raj <ashok_raj@linux.intel.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: RE: [RESEND PATCH 1/6] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
Thread-Topic: [RESEND PATCH 1/6] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
Thread-Index: AQHY9M8xsiKU3SrZ6U+Kt6Id72zaXq44g2cAgAA04QA=
Date:   Thu, 10 Nov 2022 22:09:25 +0000
Message-ID: <BN6PR1101MB216153BB7BB13C4D0CC3C4A5A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-2-xin3.li@intel.com> <Y21J/CehGK7a4Lva@araj-dh-work>
In-Reply-To: <Y21J/CehGK7a4Lva@araj-dh-work>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|IA1PR11MB6515:EE_
x-ms-office365-filtering-correlation-id: 2fbbb397-1bd8-48fe-dad8-08dac3683af5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wh1hc/7Ztn7ic5CoqmRk5zVZAuepb2pYj60VTURmX3ioh6bSJ0WEJwFIZjKhEFnpq6opC6vdjo860FPogD03K6kZ0UDd3xPiR+ba5d8+w1xqh73WaFXvpFfGdUXeUKjuQ2j013ePgiZyX5z+SQEoKa4ZE2qpdYP+e0h/mKnOTz2nQyt3J18JF3uA8iACsmTlV/1YlIIqLkJMEWUITVVVHjphL0ldSA+PQF23YFKrNH1sZRpGCoYV4NwGFMz95J+39bd1AjuR7yGnZVf/PPTfWZUW5jkbCFIqU3Oj0Jf7b6j4I9aFSzgPcPhcIW1Ar4QoYpoQxcpJ8+NEiWfQ65RsOYAkbAPwcHhz7Zhy3v2o2M3a+biRPd4tXXOKRaP2l9eLXaxmTcrrMK5f32Ubl4lqTBn4Xi4yH6V9wuyqWWyj4BbPB5E4W1VXYjb/KEmE5mXWfWdFK8d3dg1TwIgQHIYigj+nz0ZFww9h0nIrIh0bAI64fUoPTE9VTLEcGoC19z7yh5UclbNIp0PU6GmCckVu4Yi2cS++hGK+gvEkpTbkwb8uflz/wKo3ysPjvLLcrUDK6k2peeBDlhoyM9CyLNAvukVMaPHT90Kg08X3KregbIz07ytGJnn8XJLN3DIPNassIzY17RfxfIAuT1zGov9a+RQRft+ZtSqwHa5eN5NjKGgkPfaROjW3a6/sBtipzdBogRZq2kveLgBj5lpFzPA1ngJXgDImx6r2ulJXoODwcBjZWHCtvq7PYPClHuQ2r5hBJPnkK54ANg2DdM15te55Ew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199015)(38070700005)(558084003)(33656002)(82960400001)(86362001)(55016003)(9686003)(2906002)(26005)(7696005)(186003)(6506007)(64756008)(8676002)(71200400001)(6916009)(66556008)(38100700002)(66946007)(66446008)(7416002)(54906003)(122000001)(316002)(478600001)(52536014)(8936002)(41300700001)(76116006)(5660300002)(4326008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EfJb9P1Si3jczosYlHquI9P6UxkBfClha+1ffDQNR8VZ6rBWrecqoE/XkJC6?=
 =?us-ascii?Q?ppf1xj9KP00JOj96vYW5wotQUqgkh0zBW0aINz5aaXX4K39dnpT0ak5fL5K+?=
 =?us-ascii?Q?wFWGOUQy735N4knuZ7z3qdclEsNgkEMiJ+Kbezjf/aIzVvbZP/ITISBpKKwZ?=
 =?us-ascii?Q?5Tc5F7F8ZFA/IsTEYJRGoCg8+8/gzoCsC1Ewia6gTYg7671waMY7Uuau2vWH?=
 =?us-ascii?Q?OeL+DSr5boTKl/rSv9jHUyRO/mSizDBbSwUHtrKUoCqWJ10/cP3V6agobx0N?=
 =?us-ascii?Q?d/Po0WTTIny9g2yYO3rLxWWdb7VkEkLeNP3l8zOpeJHmK8iJtQhN8UcIgbHu?=
 =?us-ascii?Q?l3aU+SAj4D/Dt6IWQ3t/6sF2ylOqKK5551vypK0OEqe1clCJyWf/DkbhSVCM?=
 =?us-ascii?Q?+htZfTn7G5tA6c+mzqcTryxZOyajjvmKVeuu4ZbPbEsePUoalt6rlzrVua2F?=
 =?us-ascii?Q?XnlPVVZFe0w2IyWyEiRZq3tEMt4Mn6oNSdUJHPth3KjtQm+Jk6YI0uePwIal?=
 =?us-ascii?Q?ba7ay2hKriPxECTPv7zjEBdHPrK2t+3ruxEdXUVQazTCBZu/zuaedbkyBdmg?=
 =?us-ascii?Q?XuNLrlad9o3hk7PJPaFPGLLN7uANXznFbzfb83eC4rpPWFYbZI7BRdlmqvRd?=
 =?us-ascii?Q?HmZpcJ86lLWPtPV55IWIsDjZAj1JoiqPqHrCIrafOmYlvhx2FeVkxHgvLfj+?=
 =?us-ascii?Q?HIHC4MnLipN3d5YJt/20b2TSCOr63Wm6CGm3V3Hx0vH2kDUOU2I8YkpzwW4h?=
 =?us-ascii?Q?GUWx181o3huB24xNbqvMdYMd14tkIcUcj/xJXUIpk1J3yxMoid30zdT9BRIX?=
 =?us-ascii?Q?9lbBh0yhyNS9VPXF2HH1rrBi5Shp46igPnLMHY0vNuqSTW7vNiothIGaKYFe?=
 =?us-ascii?Q?a638715O04mcC2k1QRPqFSGJS94UgR9YanfyXkGzmQ1M0bVe8vGhTPUi0YmU?=
 =?us-ascii?Q?n5jXtJwLBvt824P8s1mlKCy3EySXo6PNjDves5m1anfJLm8GUtKWodsFCB95?=
 =?us-ascii?Q?5SoecjL3w2FIell9e9b3D+bES9fEoUc1D9eLgtM6AaxsDEnk5EUvIICgBTRx?=
 =?us-ascii?Q?OhJY79uXx0lZgKtnlwnIQhjZEhkBqXmXwGNjltcn4P040YGNapOJAEQenqh6?=
 =?us-ascii?Q?RQwl6d8FnJBJhSA87f8ow9t9clyPDfscq/CQbAb4Ofu7wvsYA9xtN41IFYP0?=
 =?us-ascii?Q?Hwl14uAt289doSGyQG+aJXm7Wr34DXElL5D/AJL3IpzCg18HUrUDGE1/uoWd?=
 =?us-ascii?Q?mBDXMIrH7SDQrrhWnoeiBbAPgkbVf678Y4pmMzXUs0DHWjdgBpFXrha7D7ZL?=
 =?us-ascii?Q?AY2fE6iti2qXBdc0WsGq38+CRZcZN13dV0lLCq35hSA9sTwqMaPD30WkYyGw?=
 =?us-ascii?Q?UqlPFs4FsSEpIux+jQrPPluszt2/8oNoZA/wCf/UYmZRDdPC8YfPGeGnkITV?=
 =?us-ascii?Q?/tDu3D4MNWpxxMSdn6kg6Ga+US0QdHeSTDZezt8YEYgSsBBG1qAcBp++EUS1?=
 =?us-ascii?Q?VUCXWJm+UYlHl74iMl5oRKUoigc3phuT1VCcgzM1X81nLqBMjTt76N8LIafh?=
 =?us-ascii?Q?sxslsHNpB08FyZFQBzc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fbbb397-1bd8-48fe-dad8-08dac3683af5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 22:09:25.9240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YnZr2qunAVFNn8i8Jis+TwY7oVZ/ZOeosgktjqANnnBnRJ9ppI4YpiClnzdprQt6jiNs5arzsCfnskoF9w4TQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6515
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > IRQ_MOVE_CLEANUP_VECTOR is the only one of the system IRQ vectors that
> > is *below* FIRST_SYSTEM_VECTOR. It is a slow path, so just push it
> > into common_interrupt() just before the spurios interrupt handling.
>=20
> nit:
> s/spurios/spurious

Thank you!
