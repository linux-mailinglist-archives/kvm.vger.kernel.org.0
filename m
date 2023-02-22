Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E3F69ECD4
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 03:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjBVCdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 21:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbjBVCdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 21:33:04 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A65DA5D8
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 18:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677033183; x=1708569183;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AFJ1LFCsKEZZIiCrtHmAqNmUzZO7VUOXYOUjR6vALyc=;
  b=Oz1Pf3UhK2jXFRPD/bZLB4ypI2mjRUZRqernXcWZFjomr4cdbsUoAHjH
   t745BxkvqdyP2i3r0KH/4E3AVzuLToLxVWLwppllXJvZEZBIQ5HOykgwV
   OIDTSSrErYUUUi3RRRgWmaNkOFrrAh7V+yPc4aTZodYVvDSzFkStDCaA1
   TowYr5hOfoUmTceEbfIrXKNtRNc7ZiIhZ5lmTx4rmeFRfCC+mKCKq3/ke
   VKCfnZ3+vVlpCnoR1VfisrlYubgJY+YQts2n6jHENKoZqpXRVIcqNLE8F
   zD4pAzjL6j1CI5m2iEEj94l/PKjg0/ctzGJCaYifBD6nenWChFJswY9/r
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="312440767"
X-IronPort-AV: E=Sophos;i="5.97,317,1669104000"; 
   d="scan'208";a="312440767"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 18:33:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="671909265"
X-IronPort-AV: E=Sophos;i="5.97,317,1669104000"; 
   d="scan'208";a="671909265"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 21 Feb 2023 18:33:02 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 18:33:01 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 18:33:01 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 18:32:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/8ArdcSStXrG8BrXWNbMyCdH5NZG+IOhwPNVKX07O3KxWEWqYsDnqy+X3UdfBGQBYCd/Y5ZwpWKQNwR2X07aKRAC//oNZyt1xfJeNqvr4MiMqKd9eeYvHDSpLJx/q9lEXYhSeag4x810dJQFT+YLt4kCQi77tJ5m8DK6ISnahFvat7TRg1WdPRH7zNS+1QWR4qkeUPAtOeqyksKl2pXZYDpT5vVqHyGbMs9MjrFN8gDsT9bnTVKHgrc/k9FDVatdFaFCzrmwhggwJH3WfSKSvMNBUgNKmC2ZIF2OlZKW9NPeuU+i+rdZEtf3UpKTacesM9mWmUm6LUXw+81MIdUEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBvNo/qAWRYdVca3Qc0wKThjnXsbnkzn4xq0OLPQVAk=;
 b=Vf9c67CuW6V5jLkUE438428tQ9t5ImwXfyvqmbQ50I11dLryGsWU+Hrbjrjjf9nC+zYlt+5TX+356XBDXTM2GfM08J0/IQtw6KbOao5z09YrGTyjAjwDI2eo78mMPisb2rDyclxIrmYOxpretsHzbepWsxEakYe+EBJUw634T59L20aMMJcqFbnMA8alPreVvGlxbfwaAksSLP/B0q4xkGlgMRV7PJDeYVETyRV7f8sm3YLMmSdqoFRpPt6WhNjJJ+SZl0XC2IrgIh9X2mqdKx3e6k/H3DY4UTPEm4BNsX88QeCxvROCHk9E7lxO0SnWbbbkYLsWg7IlrdCiugKRgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB6842.namprd11.prod.outlook.com (2603:10b6:930:61::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 02:32:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 02:32:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: RE: [PATCH v2] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD
 before VFIO_GROUP_GET_DEVICE_FD
Thread-Topic: [PATCH v2] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD
 before VFIO_GROUP_GET_DEVICE_FD
Thread-Index: AQHZRmSItDL7FXx4tUug97Bsv2sBaK7aPs5A
Date:   Wed, 22 Feb 2023 02:32:52 +0000
Message-ID: <BN9PR11MB5276EFCF9C8273C441D46DC38CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230222022231.266381-1-yi.l.liu@intel.com>
In-Reply-To: <20230222022231.266381-1-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB6842:EE_
x-ms-office365-filtering-correlation-id: 037d5074-ba2f-450a-3303-08db147d18c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JJIfyPf4dP45GmzEAiM9iMtU8SKhE74UjLjmBhXfBqtt8Cvuk07ibzMTzdK1ZlQxTNfU977i0PwtxfrW3lYzqP6pFmVcmYkF/yWGAYdTVzq47V3wP8iOdL6Cec9pgLcPSUxJeSphbqEcWosv0MEaFTjZwNFZYBWpqPMyUHhyBzwvyeB07hVGEuLpVuez9kZS81WpGRV5thGu+xArm0azG2yQFCND9kvdrBk5ZFQh2NWJ6s+6OnrMWBipvt/A+CVn+Uq+Q+mpUaBOjQxnBsykiemlfBaAkIBHGeXS0fbkyBme0/JgfYsKaYZJpdXFIzhYtXLrJ5j9h+6Pz4lg5Eup3ZIJM52f7aNxepTQCVIXAyJ+V8XSTABl5Ewvd3w0AlaJdNDSoexwOCKYwGsRgZtsffS0akp+bpCZL3aSzLdIyYY0/tDk7pnr2bhXzFKzbM+i6E57fMmavi1MSHRvqpF4boy70dNPLMaxmR5J9sp6EPIStm69/trHmhCfjfPZ7Q8s7U5EpbfMKokqPzlPv+T8Zz7lWah7njOofUU8dBuM6blfXXmuVKyRqz/NyjKe2+qypcpDYP5u7oUX8B+7ipr7fWAR99n3gcj/kmW6amEK0LzWevER/VMdiTb/4caf8jLaLdqb6Pbntfo9ltU7JDrWGwTY/BLh26F8UK0tvs+f7RJluqdc/dWptPECKqcVlMe/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199018)(83380400001)(2906002)(76116006)(66556008)(66946007)(66476007)(66446008)(33656002)(110136005)(71200400001)(54906003)(316002)(86362001)(38070700005)(55016003)(478600001)(41300700001)(82960400001)(8676002)(122000001)(7696005)(64756008)(38100700002)(966005)(52536014)(8936002)(186003)(26005)(9686003)(5660300002)(4326008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Rdebftvhkuc3qEmh/cCRrIaxmsum0T3/Da82AbD4BB/iXPTwsmbc1lJeU32r?=
 =?us-ascii?Q?+ibKgB63pOSfkCIuf2k2tO4UGBt7g6TXyALWKeYrANPgWjudxHt4f/ntGhJn?=
 =?us-ascii?Q?9r9VSltbYUM5rcEH2qhTlbjxNVTfBdt+yQO3rgLqbCxhLg2YpbALItIwxbpi?=
 =?us-ascii?Q?KD78qhQU656G1cObn6UqYiahpnAhRvk3ES/gqxRGcAnIsGSAX+k+vLwSYR7p?=
 =?us-ascii?Q?ERedB60FSIK9g5uQWV0LPwzehEGbQWzEh7eZwwusrCGJvMlidIkLEW0QnuGR?=
 =?us-ascii?Q?vuU79nu3WO4Fkc5T2SqJgt9xSWhFuPT+DsTOlliSsCzVWpHXXzdZjJZQ+app?=
 =?us-ascii?Q?bq4VFGeYPwext4+ythqHXYGhsZiAG8dp4dmBLqUk2NLtavBWzsf9gt+QNFrL?=
 =?us-ascii?Q?nDshLXU9TXkMKshk37AfrPyMKAX75EmFaNVx6krGVRDkZ3p65iCPiGXeKiRe?=
 =?us-ascii?Q?PVfs1S5amgM4uue/Snayw6Q2ccv1p83USa5FwqEMHzo9jxyECd6279+DTZZ2?=
 =?us-ascii?Q?X0jxlVphPD/3WBMVkfm3dofYA2fbt09jE4VlSd/GJZymLM4dckq8IDGW0K5s?=
 =?us-ascii?Q?0Iy4sBZJh3K8GK12vjT4ZZs3JpwbMzGROTJ43SxFKvd4Y/AWt67kzhYdAt0r?=
 =?us-ascii?Q?GeQ1dg9azOCexpgvrz4M+46GjNbThdFqqtkOonK4e/o1YtLBZQ0AgUt9SYFx?=
 =?us-ascii?Q?MoGl7rB5dLrjMArlJnO17ygaU3jcfxfil+Hd6/KkUBSK1sS83DmI4b36MZyD?=
 =?us-ascii?Q?GIxU9bvgP8WSOaSACEwXuBOGtpjU7svPMoN0UcyQfja/rO4UlZS0WYUanSPC?=
 =?us-ascii?Q?ovHzqg0WiGikbWj60eHwQ1RfRBbTL8mdoc+CJepvuIveH53VxfMQY0578GzS?=
 =?us-ascii?Q?wpKXdQUslydUrM/L2po7i+zLanxS+vYssfmVbmsptPyKZwcx2L5L7Xx9jILj?=
 =?us-ascii?Q?gCzSay4eXdHeN2Sa43kwCfXEGSdjIuRbHOxKZsBhMcl4DbCTgPzBv87QghO1?=
 =?us-ascii?Q?JtS5XB5ojW/bhX/JYqELqC187VDprnr40BZ+WjzsJkwy8ggBDQeGBWMlbJhh?=
 =?us-ascii?Q?JLynRdCIfhk1MgHLjsS1dVeedttI/V0FYxZ/IbBhLVzXRfOyh+HZSeSkvjZL?=
 =?us-ascii?Q?c9t+D9VOMRLKwuKmHY9EvkBZNVu6gJWRVoXeepaKaMWJ4DNsGW4EvQSA08UC?=
 =?us-ascii?Q?w+AusBPrGjZ3nNH3+2FL6p/xjZxusDcUSvVAlCERc45nXXDgvSKxVne3uTR5?=
 =?us-ascii?Q?wt0FCMR7L7ZXq5Re27UC0kVlTMjn1YmtqCtyEAAob78j5OIqzrgYojll/H+F?=
 =?us-ascii?Q?bm01OKuEB4IPFHylomizzmBz85U6InYS5Tk7zPyfXgTz2TgwU5fQDiYgjyAw?=
 =?us-ascii?Q?V9XeJ4zXFQ96qnM2zD9RFIeEnASrab2moYW4Ce82LmDzTNRtm6s0yUNNAAXR?=
 =?us-ascii?Q?URLBstrarmqofRASqi8adUpfvnjacJgybkEgUQBwtC/8J3No4d3Z6fIhbtLu?=
 =?us-ascii?Q?U0MPO1l9Cs6+Q9ia4zHJxlQasx/FEdr58+zXIHUlOcAorhPOWD/GnRWSs2qs?=
 =?us-ascii?Q?equxPv16Bs/O00zSa3WgmoTXwDZLYUFkj0jx6+ei?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 037d5074-ba2f-450a-3303-08db147d18c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 02:32:52.2076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nBGwnnZi5BQ3uer0l73NQUoR5JqjWbwc5/6ESdi0yQ+pzcgUpTYICGLhs07GkR2VoaZqcckbeW1ExMxPEf52zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6842
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo's mail address is wrong. Added the right one.

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, February 22, 2023 10:23 AM
>=20
> as some vfio_device drivers require a kvm pointer to be set in their
> open_device and kvm pointer is set to VFIO in GROUP_ADD path.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
> v2:
>  - Adopt Alex's suggestion
> v1: https://lore.kernel.org/kvm/20230221034114.135386-1-
> yi.l.liu@intel.com/
> ---
>  Documentation/virt/kvm/devices/vfio.rst | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/Documentation/virt/kvm/devices/vfio.rst
> b/Documentation/virt/kvm/devices/vfio.rst
> index 2d20dc561069..79b6811bb4f3 100644
> --- a/Documentation/virt/kvm/devices/vfio.rst
> +++ b/Documentation/virt/kvm/devices/vfio.rst
> @@ -39,3 +39,10 @@ KVM_DEV_VFIO_GROUP attributes:
>  	- @groupfd is a file descriptor for a VFIO group;
>  	- @tablefd is a file descriptor for a TCE table allocated via
>  	  KVM_CREATE_SPAPR_TCE.
> +
> +::
> +
> +The GROUP_ADD operation above should be invoked prior to accessing the
> +device file descriptor via VFIO_GROUP_GET_DEVICE_FD in order to support
> +drivers which require a kvm pointer to be set in their .open_device()
> +callback.
> --
> 2.34.1

