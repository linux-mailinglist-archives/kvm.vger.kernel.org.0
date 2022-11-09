Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08E66222AF
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 04:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiKIDiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 22:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiKIDis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 22:38:48 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADC01A044
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 19:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667965127; x=1699501127;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dtbJFTma2PqxrsggIlQVoIVt1+2bj+vJzMy8sYR4Fbo=;
  b=cAFnMzYUQ4yxlmHGjCaf7Xt0ggJ+uNO3zOHMOzmX5LWrMcPJy0tvMlnh
   kv0MNfhv3jDYejK0XZWKRMs18j+FIuxjuDD/xTnvHSKDNalg6UfNG2jEa
   zMrTiLFADUIIIvPmNbYBQZWXeHsjx5EaYLl6aXrAiIAat+Z19lKhoJzkg
   rWzrfABZzQHwFc6CyZA4u2NxqpN3grMIF3oB60zoh2jvPjbITwuWg3yQO
   1mdf6/9RbaVIGNrwIuyVBsMvi7XCPTudvMJ3oyT+nmdJm2vkUIChwQMu5
   wyTf0ZiQ8CngyGzAnm/tcci+3nhnoMUcKlWINAS6KTbB2OkhaGpTU61D2
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="312674242"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="312674242"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 19:38:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="761735028"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="761735028"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 08 Nov 2022 19:38:47 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 19:38:46 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 19:38:46 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 19:38:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eNgGPEEPIjlpv/LY/PMx1d/hC3SuJXYA7CLsp7AhT/i9u3OKdHDOtJAVZHyqwcLqhKeqLqa8LPsHwforRyRO7KpzJ0/lhop1114vnxaAqq5AK+ScjR1Wd3czOlgqio/mT3Mo/dVuxANXsU4Ir/zZlLPO2EM2SFZonB+pkFcCLqmCdBUEoar/IVe8JaSnxdOqzLedy/lCRH7rDpP/JiQ/83WEnMcknLHT+lqsb/dQyDZ75t7tB1LfvxMoPmwBHysj/iMmMTMrviYua0TR8ud5t2wMwIuaJZo7wKiaVzPtM/g3n/6TD06OsVryavdruzogzCjPtHUxUhITh0pQxJ6CUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SX1JQIwPg2XfyWB8Y4kvbnl5RoTQ3NdZlm98zr/++u0=;
 b=oONc7d5GBkHtAHWiRcO0Jk7XMwD3OHU82eW1eCt1KjZFYCKdfh8mwCLgNsxBMJQTProQPxtuiyLC0+TKpvH27xOuTa7L99VszzZJGOr5WPecKarnb+HxyvrDYwQqSgmWeeJSAG3HJ6Il1JMr3HBt6HTfoc5/IGq6c7k4nmSqonzHKbJVs6Sy8MYLZw79OXSaKe+PXg0y1MasB7bMmuVgB+JDPNvuSIxWkv6M+UGVizeBnBVGQxcJfqBDNgv0WlDSDcrExufS8E6787FmwBU3H2NlqtOl60FE/+y13fxwUSYFKad8FkbJkeqEZXfEFycRDctzuA+3xJd91pDXQ8Wzcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY5PR11MB6487.namprd11.prod.outlook.com (2603:10b6:930:31::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Wed, 9 Nov
 2022 03:38:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7%4]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 03:38:40 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Anthony DeRossi <ajderossi@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "abhsahu@nvidia.com" <abhsahu@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>
Subject: RE: [PATCH v5 3/3] vfio/pci: Check the device set open count on reset
Thread-Topic: [PATCH v5 3/3] vfio/pci: Check the device set open count on
 reset
Thread-Index: AQHY8Wj1zTaN8+L3+kaOKANSFYaUaK419pmQ
Date:   Wed, 9 Nov 2022 03:38:40 +0000
Message-ID: <BN9PR11MB52760A98AEB26DB36602F07E8C3E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221105224458.8180-1-ajderossi@gmail.com>
 <20221105224458.8180-4-ajderossi@gmail.com>
In-Reply-To: <20221105224458.8180-4-ajderossi@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY5PR11MB6487:EE_
x-ms-office365-filtering-correlation-id: f613ceac-58c3-4354-49e1-08dac203e4a3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B0CYrKFdu0rriUVKw35+j49IAFqeFuC08Gp/hTh/rtm3AhVloUcuaGOWFFbKc2t/vCOnxyJ1WE0MLSw/FplbEGTLEkhPw0EhaWCFV+ucy/4eTelEZCsusIjMIzaJCUba/OeeCAF7lMwLX8sygkovPXZVwwGHFV6oCs3RIQZt1Yt9os4T/o2bKH0NDgkhFrZQOA82Mj0HOJIHSj0ZPXl55ACMRzOi06vYaCR8UBPJl4kiFrVDMeMVBW4SF2DZt9reg2iyAe8xjIVCNv8A/ZOfC6ni+Ei0RlWUnV0CXdD4Uo8SsDPGu3GP1L9V6f0OHVS6JwpioAaL7czgHiFWWJTIurV4R3tTeciTSDL5uJ+16rwwjMhHFCRyyaOqXLVCUOM9mqgXczlLlUFA9fEoz4qlkvfOf7VZI5q6woyA34tPw+6OQow1PUkyy0lnWJbEB5iGz7oc6uBcloF/AXJ4ffPEB5mcBcd9k7LmdnadJd7pJBb7pRBV76MTB56UCdVY+qgMktkcz1Uxz9R0EfQx2bvT1KAp9KvfRNYRwLpbmMFeP+BRlIR8eQ14iJ2JedRU88wTeCiM6no6wt8c5ne4ohN6y+Apw6a/wSMQWPnbIZhlMTnTZ8pLzyvus2rG2kHRuXyxIg7lShs1DXSqW7FzCDCHEv5fhwJRl7K/njbZCcrsO0otavmUKtY+D58Eukbi3G80zDf0gu9SOCOhlXB2AkGFP+chZtBcslopVUxk206QbD5D3bPH/fnyOGV2cmCC05nzFSqPRM4w9e7d7jGWgxZ5Mw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(376002)(346002)(39860400002)(451199015)(2906002)(33656002)(110136005)(316002)(76116006)(83380400001)(6506007)(38070700005)(71200400001)(4326008)(41300700001)(478600001)(55016003)(64756008)(5660300002)(52536014)(8936002)(66946007)(38100700002)(8676002)(66476007)(66446008)(66556008)(26005)(7696005)(186003)(9686003)(122000001)(54906003)(82960400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qEH791lW9bEwCqaXVGko69t/LHaDCo8SRebaDIuAWkoPPv0x0+/SHXCGoy/k?=
 =?us-ascii?Q?WpVwjnIUCoxoIsW57WEEEUyCAWwZ6Fkl92Jf3Z0hz2UMqO8Fq8WSgSXduwd2?=
 =?us-ascii?Q?bdgt2LLX/RHm2UTnab6BFoUlDQmOpNj4SbD2tzHmggrk7r5w17ErcGtqvqxw?=
 =?us-ascii?Q?wcwCGwUBxmgcyM6wIlsqidp8AXWW6oWw+B1X1zdOs1p8yLht3CYu3MH8h90U?=
 =?us-ascii?Q?wRHHZRUK1xrHoI4C+op0KE7CsVq57Vp25PlJ315rFJnRudp/l1IvAGGxyryh?=
 =?us-ascii?Q?8TxC/YofqNXBbTXna+hx6xCVMa6igKHCy37N+PssHfcgxnlNOKhnhG6CP7nY?=
 =?us-ascii?Q?OwR5X6oWzIbwryp/1a/ndods7p66whb+paGjDT59WJHCj5/d6Qkith8j91pt?=
 =?us-ascii?Q?osVLlSi50mHgEK7dsiOc3NozUfAn+fX8EC/D2/Cuh2TlbgMy6z1OHiLnaQQY?=
 =?us-ascii?Q?C9dfvMNwq8+BZ5FXUqV3BvDACTx/IYSWi/BOpqDimPat5G1WpAaJolwC9q5v?=
 =?us-ascii?Q?vsKJc8WyOdENW6n940otVfB38J7t3BxjxXG8B4qpFvMcLoDCQv0orhY4gqkZ?=
 =?us-ascii?Q?62S3Owj45G3vOM0P48QlkmwpZA70jxb6Fv8pOzrKkfGggn+LbUBPLKZuAKyr?=
 =?us-ascii?Q?kxylfp0k0gYmR+k7cQPDK2Qp38dkIiH2jqJw2vnsej4fPkQT2+v+ZLb53T77?=
 =?us-ascii?Q?d61lr7QzOBAmhOIDztngMVDPFuyHRN0IEfW5SxUzQ8dreBZHCORoaROYtAcf?=
 =?us-ascii?Q?g/RkuHs0lkZAsQfg5f4WgvqP9zDZuSp9x0FV1iQJTNwniydFoz4htLK+I3of?=
 =?us-ascii?Q?eKfrhhoCvF3I4mYI55OF34/tYIyCCCuRPavXcXGNLzkRXcG6Ra70kyi9OA91?=
 =?us-ascii?Q?Nl5htaZ89ut4TfGOJXEeSonfbbonWd4Uh0P+iVsAoFXJKMtnVDIq0sY/45k0?=
 =?us-ascii?Q?/Zdgea7wfspe+IDVhsq45WlV6s7eM7LSIYFOvs7BSLQuJ3Oov356tsGo7Iau?=
 =?us-ascii?Q?L4hsBfqKN08SnvxpCfjXkrub07rA+TkB5/lj/ZlMuMauF6ECOFDBi6saPAY+?=
 =?us-ascii?Q?wAoxWXyC1Au4JWBNyKoANsktSWle7bUAlFhTElQ0zLd9QCubt5XTxIELyMLj?=
 =?us-ascii?Q?p/ACjzz8ukvPaB8WkK70ayRxtyIJfWeZXgUDVJ39Yjai3JTuRTGwohP2eaet?=
 =?us-ascii?Q?ZWw31ZOtep8c3PXHh9occrUDHiWi1VrHFm50Ik19Yi9fUgKnWhUYWyfLLwh2?=
 =?us-ascii?Q?ntkDGJSMHNa2BBejYsElGh+Ft4pcCBVqvjqnkYeU/gBIRc9lsYFxXb4JWQAT?=
 =?us-ascii?Q?GI1zYDSIjJo3X7giZV3TKCzvFXSCrNFK0bF3tDZaArh/tUSdz07bnaMOusZk?=
 =?us-ascii?Q?NlOTL2CE+x/a8/e2LvXCbEsYcm82MTnFb2OR8BD/I1+g7qhht5oGIwaY7PMK?=
 =?us-ascii?Q?mjfEInpWT23tjvlfrXa7xtqN2rkfhZgSqKIVmuztXUATHckutBsQ6phdh81I?=
 =?us-ascii?Q?+eCRyxh2P7fCWCv5AICO4Xwmo5WvA48ZBWjW+fTPTMgMbJ0BsMuSaSdijl6l?=
 =?us-ascii?Q?yv1Gzd2bRMy4zMwQ1e9ezF/IFjDZ9NqpAVy3nkGg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f613ceac-58c3-4354-49e1-08dac203e4a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 03:38:40.2474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QFlW9cT4FYkFlu66pD7mtan58DV9ZAMZ/wozy6Ha5xNoCzEnzPTqMM+RlXA8EJl8NOgUb1Mqq6zURtSGkK1f8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6487
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Anthony DeRossi <ajderossi@gmail.com>
> Sent: Sunday, November 6, 2022 6:45 AM
>=20
> vfio_pci_dev_set_needs_reset() inspects the open_count of every device
> in the set to determine whether a reset is allowed. The current device
> always has open_count =3D=3D 1 within vfio_pci_core_disable(), effectivel=
y
> disabling the reset logic. This field is also documented as private in
> vfio_device, so it should not be used to determine whether other devices
> in the set are open.
>=20
> Checking for vfio_device_set_open_count() > 1 on the device set fixes
> both issues.
>=20
> After commit 2cd8b14aaa66 ("vfio/pci: Move to the device set
> infrastructure"), failure to create a new file for a device would cause
> the reset to be skipped due to open_count being decremented after
> calling close_device() in the error path.
>=20
> After commit eadd86f835c6 ("vfio: Remove calls to
> vfio_group_add_container_user()"), releasing a device would always skip
> the reset due to an ordering change in vfio_device_fops_release().
>=20
> Failing to reset the device leaves it in an unknown state, potentially
> causing errors when it is accessed later or bound to a different driver.
>=20
> This issue was observed with a Radeon RX Vega 56 [1002:687f] (rev c3)
> assigned to a Windows guest. After shutting down the guest, unbinding
> the device from vfio-pci, and binding the device to amdgpu:
>=20
> [  548.007102] [drm:psp_hw_start [amdgpu]] *ERROR* PSP create ring failed=
!
> [  548.027174] [drm:psp_hw_init [amdgpu]] *ERROR* PSP firmware loading
> failed
> [  548.027242] [drm:amdgpu_device_fw_loading [amdgpu]] *ERROR* hw_init
> of IP block <psp> failed -22
> [  548.027306] amdgpu 0000:0a:00.0: amdgpu: amdgpu_device_ip_init failed
> [  548.027308] amdgpu 0000:0a:00.0: amdgpu: Fatal error during GPU init
>=20
> Fixes: 2cd8b14aaa66 ("vfio/pci: Move to the device set infrastructure")
> Fixes: eadd86f835c6 ("vfio: Remove calls to
> vfio_group_add_container_user()")
> Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
