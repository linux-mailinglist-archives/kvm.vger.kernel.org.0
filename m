Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179317A722A
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 07:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbjITFhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 01:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjITFhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 01:37:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07892AC;
        Tue, 19 Sep 2023 22:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695188225; x=1726724225;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=me+U2iTHXurBymr2k3gfv22hrxgoJYBOzBhvgk843tQ=;
  b=f9+gLrKhe1nWTvYA/S0rUVpu0pz2NQAHh6D63ZqYQe9YSBM1vTCF9bNr
   nWmop3VBG6UO83ZV+16+eUIFIbs4oeukA6paecr6YIzZW+muBS+XOoeEE
   jxMa5TP5/nlxM4cDx+gH4QVqqlEFDJ2bbwtYQi8LKSDiLxD6URlx82yDS
   Po+x2mJDRW/Gvw82u1tMHCfoRY4wsUxxhI73JumGGeNDdjHQrTGAEw/C5
   qvFp2/LO2mTSpRGeM3e3zxF5GxnRF0JJVVBPVadACb1aEwfChPiy0CBrD
   aV4dVYS6D6z2O91hBoCrc8JthZVWlkb0lQXj3994aI67+O9o2iZ4TAFwo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="444223482"
X-IronPort-AV: E=Sophos;i="6.02,161,1688454000"; 
   d="scan'208";a="444223482"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2023 22:37:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="920144084"
X-IronPort-AV: E=Sophos;i="6.02,161,1688454000"; 
   d="scan'208";a="920144084"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Sep 2023 22:37:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 19 Sep 2023 22:37:04 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 19 Sep 2023 22:37:04 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 19 Sep 2023 22:37:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AU/ttNziD7SRx04pEJZ+jh+gBdpGCphqHyOq/wCNOi0WxytZy9JcnU9/C7PPhXzHxfkE48tQhdkEoNZ6YSMdV/4ktZD09kPDM/eCxAtscHuT9OPXgnVMzYU1ETSVPiP01XTAX6OzsBf4G1r769kNWRKNjHhpJRUxvkLBl6XDVBim/2gznR2rXUuJIOdDjNAXhIfWyV4n5JgOQv7cCSdCADpVIqg2MJCVieZ4IBM5ZT8Ob26r3JPY8JSt+PiewggxoJZqcX4sMIvVSlnaenuiwN96ZDV1+KAijDdOJU6rwlMvvLICZ7LD5DKoo80eHZ9YiMtnX7aGbtHU1b4VaXrmGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5wiua2LE+mpaGQcXi5aRLhLIIdQOxHc+z0iclgVvATs=;
 b=YMv0+CBBA1mi+VfYwXavddKoxD+/Va3yQtQPs0iOcXTy5xN0KcQm/CvNbBEbdL4Nc65GlzRCAiuy29xu6s7gPDZ1tYas9+yMpwIFpM4HI+26GbapydAtUjtChgovpYZO7x5U1mE+2SLP9Txq0c/WK30TANHJ77RMWnMbhuR3nMstS+bl8UrQnHvD6SyBEu1uc2kEqlBXMZvhZcUMDuGLgroldkDpNpw0nWkdwHYUOXkL0UENYzGzKvMhXMZmPtorZhy0m/bp/6TGcjEsbhIV2A4SAlHxrUirn3hQijCXYD/I4K5e7C6ve5EaQanr9rxRgmaMe/HwGr9RTvUuMz0pig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB5923.namprd11.prod.outlook.com (2603:10b6:806:23a::17)
 by PH0PR11MB5064.namprd11.prod.outlook.com (2603:10b6:510:3b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Wed, 20 Sep
 2023 05:37:02 +0000
Received: from SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::a9c7:a04e:633d:cfad]) by SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::a9c7:a04e:633d:cfad%2]) with mapi id 15.20.6792.024; Wed, 20 Sep 2023
 05:37:02 +0000
From:   "Chen, Jason CJ" <jason.cj.chen@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [ANNOUNCE] PUCK Agenda - 2023.09.20 - No Topic (Office Hours)
Thread-Topic: [ANNOUNCE] PUCK Agenda - 2023.09.20 - No Topic (Office Hours)
Thread-Index: AQHZ61Q3W8C4TbDbjku4TL8lLfXt9LAjMW6w
Date:   Wed, 20 Sep 2023 05:37:01 +0000
Message-ID: <SA1PR11MB5923CE0CA793FF8B63DFDAEBBFF9A@SA1PR11MB5923.namprd11.prod.outlook.com>
References: <20230919234951.3163581-1-seanjc@google.com>
In-Reply-To: <20230919234951.3163581-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB5923:EE_|PH0PR11MB5064:EE_
x-ms-office365-filtering-correlation-id: 9532ab6e-15ee-4793-a2b4-08dbb99b9db0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ifsRcfdqyF1dnf+M7elHPiRdG5Nbkwm9oXpnSadYahnHtzSZ4xvmOAafdIXN2ba7uDpzvIjXXh9aY37uuzWLVMzOxn5cyJZML01N/C4XJdnHgs3MV7WJyyVqt5/yKDIoFfipBanrtEOcCkKaCXZk9nVb1Iyiu3CNOhk0Euvmq/noL8LyjJdVkcunj9S/cx4NuNeWntpNLlZJT2CVQ1s3hCZbWygbPFgGzhphpnfwKInxS4uQJNEQqSOOzF8X+78N4fD6S7N/DBLkEa+ukdTK5Lvk1rCwwpbKkbOBbqOSD/xiWoLpfskgeiFYOPl/qvyuMmKT7keFqK+NIovhAVBbTkP/GxMSXVgXFp1VyjDs7lBfCJrnBxKvAKTCfH5PpVZvSnXINcA6WKSXPG+1SoRJFhgEyM+oK68PV7RW5jlINrXJec67ILjyRjKVws0qG93L2uoNgpqhpK5QxxHJaFrxdpf4K/k8d3LwVjyZSPNjUvbPKfMMx0i2iPh/bwLsajYXdvNJHjQbFROA8/vl27BMaIpn3JULqj5o8Ku+H3OzwRnBNxRYxSd9xZ4xtzCKR3vshm2FvDZii8MHAtz0oRJI9FVuAbWOi72uNSoTnxC6nALOKlLQKmVE7qnlGq/NfmWXBMrKdpJthc0DH3Oh36AuB3YW2fJoSNup8ZPdwrMCpRApJGIby4kuK1HjAcA8Dets
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5923.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(396003)(376002)(346002)(451199024)(1800799009)(186009)(33656002)(5930299018)(55016003)(52536014)(5660300002)(83380400001)(86362001)(8676002)(8936002)(4326008)(41300700001)(71200400001)(82960400001)(6506007)(7696005)(53546011)(26005)(9686003)(122000001)(38100700002)(966005)(99936003)(66946007)(478600001)(38070700005)(2906002)(76116006)(66476007)(54906003)(66446008)(66556008)(316002)(6916009)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ckljaTBKQnFKOG9hb1FYeTlYR0F2OStITzFsb3FiS0grbmQ5UDYxK29iMHhC?=
 =?utf-8?B?T3M2U1FFN3RBZHdPVUpSTndEclBGTlQzMFR1Tm51N2FieDJOd0JCNGpzWlpG?=
 =?utf-8?B?L0kyQ0lQbGtzY1J2VU12YTRoa0ZrODhZTStvbTJZZ2dSZG5pRkw5YlE5Z3l5?=
 =?utf-8?B?WU4vRDFKZ3krQTZnTWhNc1BSMFJONmVSMFVocUlZcDRuTnF4Z2RQR0R5SkJ0?=
 =?utf-8?B?ZnpKc3Vkdkc1WHZuMGxCTWRZaEhldEZCS1UzemY3NFNlMU03QTZ3N2FaZDdY?=
 =?utf-8?B?NGpDdkhRNnU4SDlXOStQRUU1OTk3VXFJdHFPZUlJUWJ2Y2pBck9VUUFLeHZq?=
 =?utf-8?B?M1FOWmJmZGpZNkZ6U1hWdVJpZk44ck5RUFkwZjVEZENZTDRJUnl0RzFxUE02?=
 =?utf-8?B?Nmd1OS9FOGpaOHFnc3ZkNm12ZjFmMzdYZTEwUDJ0MEJwTUFBY2JoTHB0aWk5?=
 =?utf-8?B?UFMrajNVWWszOVhRVTl3RUQ1QmpJUzNtZ2JtSDZUbzdFTlVGM1Zzc3gyU2M4?=
 =?utf-8?B?RWh4SkhJSkc5aE9ub3RrZnltYjYvY1JXdkMwSnV2WUYxVURjOFFicmVTS0hr?=
 =?utf-8?B?Z3dIbTY3NEk2d2xFSFp2bGhvSWRUZVdzVU55RzNMNWc1Z0o3Yk0ySjRSNGJF?=
 =?utf-8?B?VUMrMGtobzc2VW1EU2NNU2J3ME9aZU5tZlAydjBXVXVQeXpYeVIwZHk0WHRK?=
 =?utf-8?B?dXhKUlh0SldYeVZKSi9mRUV6b3R1NmNXOFRVSk4ya2hxTlgxTWlwenYyZGVS?=
 =?utf-8?B?eTNNcFVDbUN1aElFN0FrUlE0Y0hUdGdpS3lXUFFPUVp4YzRUOURlN3A4UTdO?=
 =?utf-8?B?ajQvdnc3QjBKTVlYUS9PckkrREllUUhIQVNoaEV4NEl6RkgrZ2t5ZFVnYUI3?=
 =?utf-8?B?WkhWaVFSZ2pueXZuNUZGRkN6NExMaUtUVSt4dGhqZjltYm1DU0JQbENGMXdW?=
 =?utf-8?B?SGZ0QmZEWDJJdnF0TkttSmFtcWxYbVVsVWRiVnNpL042bmNkYVltWjJURjd1?=
 =?utf-8?B?OXpxL0VSVm5EbWtxM1dkQktlcDlBaDVOelg1Y2ZCUlVaM2xaS2lKQjNQaEJP?=
 =?utf-8?B?U0lydkRDZkRjWDdWaFRqRUY0S3NjMVZGVU53OHRBYW41bkcxU083Ym9vaVRS?=
 =?utf-8?B?TnExMmIydUlaTGlsckl1c0hPUTNLNHNENTFaVjdrVGdZd0E3TUR5QU5EUVZZ?=
 =?utf-8?B?Z2t4dExpenhXazB6Ylh4NDZiUjI0WGdGVXFFUnNpOVF4MG0xSy9kV1VSUWxh?=
 =?utf-8?B?NU9uUThmWjdRWE9HRHJIbjMrQ3h3WVUrREtLd0dLNTlqeHFGd1Z4L1R4MVJS?=
 =?utf-8?B?dCtjY1V0TDRoWHNESjNuTXh5NXZ6QWNPaGVKNjQvdFpkQWhENVAvb2lweHhJ?=
 =?utf-8?B?MjcvYUx5VTFjYWorajJmdnhCVmVobmg3eG9jQXMwdHI3R2loZFZUdUJ2OVJq?=
 =?utf-8?B?NE9ZY0ZzYVV1d1lzL2pQaDgyUTZ4QmxsNDR5NklRTkVvMTloeDVtSG5XUm5H?=
 =?utf-8?B?ek8vYVBBTVhQaUhRVkplVDZnRWNhVWNWdDFQVmk1QStqM0N3TUFzMGp0cGJq?=
 =?utf-8?B?eGgvd245RC9NcVJkbmcvN0t4UFJZbzZoZnUvWllZczZSRVdPVGs3dGZkcU1H?=
 =?utf-8?B?bkVJS245K3RrdGp1dnZvQ0gyQ3h6ZlFFbTl3WFN0Mm9SUGhjcnQ3RHhFdlRh?=
 =?utf-8?B?b2hzd1NEb2hvajdkS0JvWWNrT1diUTh0dHpIeGpZQnJSMnRackpoZmxTL0tV?=
 =?utf-8?B?TklRY2dDTnpab0V3czUxWWNWdWs3b2pGYm9XS0U4dWNRWHE1aW9mM1B1OVhE?=
 =?utf-8?B?RFcwWW9VekJUSDk0VDF4aDJxcGRvWXdac2ZEdG5HUDk2NWl1NkxlUUZjdFN1?=
 =?utf-8?B?VzRzZ0xSNkpBdkx5RUlxL3NLUXY5NFdDYUlzdG02aTAyRldoN3pLVzhMWEcv?=
 =?utf-8?B?cCs4Z2grL2FJUW1KdHVLb1JyZFlHVFRzbzRUNHpvRWh1SnJSaUZ5TThqcURY?=
 =?utf-8?B?ZGdhZzFvM2w3ejllM2U5bGZKOUt6MDQzWE41OUpCNkUyNVZ6Z21TMVlrejhE?=
 =?utf-8?B?VmoyYUltVmhJMklteGlzM3RxbEI3TTg3dTFHK1h4SldId3hHRkFVVnV5SjJl?=
 =?utf-8?Q?AVamZFEIc/w0ZNDJKtmE8GuRt?=
Content-Type: multipart/mixed;
        boundary="_002_SA1PR11MB5923CE0CA793FF8B63DFDAEBBFF9ASA1PR11MB5923namp_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5923.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9532ab6e-15ee-4793-a2b4-08dbb99b9db0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2023 05:37:01.9562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zdB/FHS1OWwHLJBSp8UiI5aByU0HrFts5RiVKxJMcmar/d9d8/PnlCS9YXzMLcFzWymaeSYFoCuq4rhL4X6xBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5064
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

--_002_SA1PR11MB5923CE0CA793FF8B63DFDAEBBFF9ASA1PR11MB5923namp_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGksIFNlYW4sDQoNCkRvIHlvdSB0aGluayB3ZSBjYW4gaGF2ZSBhIHF1aWNrIHN5bmMgYWJvdXQg
dGhlIHJlLWFzc2VzcyBmb3IgcEtWTSBvbiB4ODY/DQoNClRoYW5rcw0KDQotLS0tLU9yaWdpbmFs
IE1lc3NhZ2UtLS0tLQ0KRnJvbTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5j
b20+IA0KU2VudDogMjAyM+W5tDnmnIgyMOaXpSA3OjUwDQpUbzogQ2hyaXN0b3BoZXJzb24sLCBT
ZWFuIDxzZWFuamNAZ29vZ2xlLmNvbT4NCkNjOiBrdm1Admdlci5rZXJuZWwub3JnOyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBbQU5OT1VOQ0VdIFBVQ0sgQWdlbmRhIC0g
MjAyMy4wOS4yMCAtIE5vIFRvcGljIChPZmZpY2UgSG91cnMpDQoNCk5vIHRvcGljIHRoaXMgd2Vl
ay4gIEZlZWwgZnJlZSB0byBjb21lIHdpdGggcXVlc3Rpb25zIGFib3V0IHVwc3RyZWFtIHByb2Nl
c3NlcywgdGhlIHN0YXR1cyBvciBkaXJlY3Rpb24gb2YgYSBwYXJ0aWN1bGFyIHNlcmllcywgS1ZN
IHRlY2huaWNhbCBkZXRhaWxzLCBldGMuDQoNCk5vdGUhICBUaGUgbmV4dCB0aHJlZSBpbnN0YW5j
ZXMgYWZ0ZXIgdGhpcyBhcmUgY2FuY2VsZWQsIGFzIEkgd2lsbCBlaXRoZXIgYmUgdW5hdmFpbGFi
bGUgb3IgT09PLg0KDQpEYXRlOiAgMjAyMy4wOS4yMCAoU2VwdGVtYmVyIDIwdGgpDQpUaW1lOiAg
NmFtIFBEVA0KVmlkZW86IGh0dHBzOi8vbWVldC5nb29nbGUuY29tL3ZkYi1hZXFvLWtuaw0KUGhv
bmU6IGh0dHBzOi8vdGVsLm1lZXQvdmRiLWFlcW8ta25rP3Bpbj0zMDAzMTEyMTc4NjU2DQoNCkNh
bGVuZGFyOiBodHRwczovL2NhbGVuZGFyLmdvb2dsZS5jb20vY2FsZW5kYXIvdS8wP2NpZD1ZMTgy
TVdFMVlqRm1OalEwTnpNNVltWTFZbVZrTjJVMVpXRTFabU16TmpZNVkyVXpNbUV5TlRRMFl6VmtZ
akZqTjJNNE9URTNNREpqWVRVd09UQmpOMlExUUdkeWIzVndMbU5oYkdWdVpHRnlMbWR2YjJkc1pT
NWpiMjANCkRyaXZlOiAgICBodHRwczovL2RyaXZlLmdvb2dsZS5jb20vZHJpdmUvZm9sZGVycy8x
YVRxQ3J2VHNRSTlUNHFMaGhMc19sOTg2U25nR2xoUEg/cmVzb3VyY2VrZXk9MC1GRHkweWtNM1Jl
clplZEk4Ui16ajRBJnVzcD1kcml2ZV9saW5rDQoNCkZ1dHVyZSBTY2hlZHVsZToNClNlcHRlbWJl
ciAyN3RoIC0gQ2FuY2VsZWQgKFNlYW4gVW52YWlsYWJsZSkNCk9jdG9iZXIgNHRoICAgIC0gQ2Fu
Y2VsZWQgKFNlYW4gVW52YWlsYWJsZSkNCk9jdG9iZXIgMTF0aCAgIC0gQ2FuY2VsZWQgKFNlYW4g
T09PKQ0KT2N0b2JlciAxOHRoICAgLSBBdmFpbGFibGUhDQo=

--_002_SA1PR11MB5923CE0CA793FF8B63DFDAEBBFF9ASA1PR11MB5923namp_
Content-Type: message/rfc822
Content-Disposition: attachment;
	creation-date="Wed, 20 Sep 2023 05:36:57 GMT";
	modification-date="Wed, 20 Sep 2023 05:37:00 GMT"

Received: from CH3PR11MB8137.namprd11.prod.outlook.com (::1) by
 SA1PR11MB5923.namprd11.prod.outlook.com with HTTPS; Tue, 13 Jun 2023 17:34:28
 +0000
Received: from BN6PR17CA0053.namprd17.prod.outlook.com (2603:10b6:405:75::42)
 by CH3PR11MB8137.namprd11.prod.outlook.com (2603:10b6:610:15c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Tue, 13 Jun
 2023 17:34:26 +0000
Received: from BN1NAM02FT052.eop-nam02.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::a2) by BN6PR17CA0053.outlook.office365.com
 (2603:10b6:405:75::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.35 via Frontend
 Transport; Tue, 13 Jun 2023 17:34:26 +0000
Received: from edgegateway.intel.com (192.55.55.70) by
 BN1NAM02FT052.mail.protection.outlook.com (10.13.2.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.23 via Frontend Transport; Tue, 13 Jun 2023 17:34:25 +0000
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 edgegateway.intel.com (10.1.192.135) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 10:34:14 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 10:34:09 -0700
Received: from fmsmga008.fm.intel.com (10.253.24.58) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 10:34:09 -0700
Received: from fmsmga104.fm.intel.com ([10.1.193.100])
  by fmsmga008-1.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 10:34:08 -0700
Received: from vger.kernel.org ([23.128.96.18])
  by mga04.intel.com with ESMTP; 13 Jun 2023 10:33:48 -0700
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjFMRdb (ORCPT <rfc822;yahui.cao@intel.com> + 58 others);
        Tue, 13 Jun 2023 13:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239547AbjFMRdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 13:33:15 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725751FC4
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 10:33:11 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-54290091339so2706668a12.3
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 10:33:11 -0700 (PDT)
From: "Christopherson,, Sean" <seanjc@google.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "Christopherson,, Sean" <seanjc@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] PUCK Notes - 2023.06.07 - pKVM on x86
Thread-Topic: [ANNOUNCE] PUCK Notes - 2023.06.07 - pKVM on x86
Thread-Index: AQHZnh1OCMVUwM9E2UmgPuz6UJokfg==
Date: Tue, 13 Jun 2023 17:33:05 +0000
Message-ID: <20230613173305.1935490-1-seanjc@google.com>
Reply-To: "Christopherson,, Sean" <seanjc@google.com>
Content-Language: en-US
X-MS-Exchange-Organization-AuthSource: fmsmsx603.amr.corp.intel.com
X-MS-Exchange-Organization-ComplianceLabelId: 12ee4da9-25d2-4141-a122-b55133cf49dd
X-MS-Has-Attach:
X-Auto-Response-Suppress: All
X-MS-Exchange-Organization-Network-Message-Id: 8f897a79-3a7f-4956-a98a-08db6c346f45
X-MS-TNEF-Correlator:
X-MS-Exchange-Organization-RecordReviewCfmType: 0
x-ms-exchange-organization-originalserveripaddress: 10.13.2.160
x-ms-exchange-organization-originalclientipaddress: 10.253.24.58
received-spf: Pass (mga04.intel.com: domain of  postmaster@vger.kernel.org
 designates 23.128.96.18 as  permitted sender) identity=helo;
 client-ip=23.128.96.18;  receiver=mga04.intel.com;
  envelope-from="kvm-owner@vger.kernel.org";
  x-sender="postmaster@vger.kernel.org";  x-conformance=sidf_compatible;
 x-record-type="v=spf1";  x-record-text="v=spf1 mx a:out1.vger.email
 a:vger.kernel.org  include:_listspf.kernel.org include:_spf.kernel.org ~all"
x-ironport-av: E=Sophos;i="6.00,240,1681196400";    d="scan'208";a="357286663"
x-ms-publictraffictype: Email
X-Microsoft-Antispam-Mailbox-Delivery: ucf:1;jmr:0;auth:0;dest:C;OFR:CustomRules;ENG:(910001)(944506478)(944626604)(920097)(930097);
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WjdFRG9xWHNzMU1RU3R3TG1lREZYSFkyOHlVbFZ0b2xKc1dHVTUxMi96MjEr?=
 =?utf-8?B?Nlkvc1FWOW9uTXJ0NFFwSDRMUnJpUkh6cDlHOXkxclFaN0E0NlN3dXV0Nm1D?=
 =?utf-8?B?NHFxQlhOZE1ObkRzQVFiTlR0YUpXaTQwczJQODNBaE9Hb0tjb3R1WE0zTjNq?=
 =?utf-8?B?Z1JmcFQ3NlMzSlo1WkxZLzRYVEpNSVNicFlBWWI3djRpT1QxTGR5M0JvMFRj?=
 =?utf-8?B?Z1BRRHVpY3FoQ2NnRzNNNVNBOVlSUHRUeENFRnhKRzBGd1BqWmZ5WWFoczBP?=
 =?utf-8?B?NDhRZlNWaEppdTYrUC84V3dUZGxlVXhkUkVvQ3pjRWplUzNrb0tQU2diS081?=
 =?utf-8?B?YXR6cHlsUm1Rek0zd0ZncSthMlVBeEh3RXRKclZnZFpmMUFMM0d2NHNtM3Jt?=
 =?utf-8?B?dzhHN1FGbGJ5SjhlWkRRemQ2QmdlOE45OEpBalVFMUVmQmRucjFNZTRXb3hk?=
 =?utf-8?B?allsZUV3T29oZE15QVh4bkZmUUZnc1A5M1AwMUdzd2dSeHFZWlRoYkpYQzBE?=
 =?utf-8?B?SjNVS0RZdGliRUtvVXQ2L2pmTlkveGxuS3NZUU1pK3NxbjRMdG1CWXhmOEhz?=
 =?utf-8?B?eGo3Y25NbFZvamNtWmlOR0dvT0loakE0S3pxYWxMUVU1NFhwMHBDQlJ3Sk4x?=
 =?utf-8?B?Nkg2a3NLMU92aXl1ZllybS9WS3hBSmxESmRXdytEVEJNMTdwUUZRUjNoZXFz?=
 =?utf-8?B?b2FlNEpOQ28vbit2cnVtV2o4MnBJbkhQNzI1TUlXZEhjcWJtbFJwYjh2QkdG?=
 =?utf-8?B?elBpdVRZdHNGV1lYZWFTNEpjVFRzem1pOVNpcWt1cVBCK2ZOU1ZFcHJMclpX?=
 =?utf-8?B?NkhCeXdsVSt0Ri9PMGdOazk5VzU5VEVySVJLMTNleFRpNWJPMkNPS2NHRUc5?=
 =?utf-8?B?ODJnMUhCNVNkemtHUTAvQUE2QUtPenA2ZWtKOVF3aktlTTJPcFJFbXNlSUsy?=
 =?utf-8?B?TmFIdThwenFzTmJhL3lGMjE2NytsV3FUbkFxNUE1T3RGK2VkNnhhVWR3Qzl2?=
 =?utf-8?B?MFdMSXdGaE1IbnBJTzZndnMwRlM3cisvODZOa1NoNVpkN05mQitvSjQ3MVNB?=
 =?utf-8?B?K1BMZUZicW5kUldoVlhlMXZNWUdhVlk2UVI2TkNQSnBZa0N6d043NTgxV3F4?=
 =?utf-8?B?OUJnckFiU21NT1NoMGFMRHM0K3lrVzc2Y2Q4VFpWMm5wc0FoV2VqMzkyU3pX?=
 =?utf-8?B?S1JBcnpoSHhHeVhET2RlajRESW1NRmFUOVZxbFpybC9pajNuSUltSjM2dmZM?=
 =?utf-8?B?VzlYc3Z2NGlxUmlrdGJQNURQa0JzSzBYNkVvYUpvNkNPb3FXRythSFRtclpY?=
 =?utf-8?B?MXFQTXBtc2E4Z3BoWi9YbUtNYTBzN01Dd256WFN6R0xKM2FzSHRNRDRtYm5n?=
 =?utf-8?B?TVJ6aHYxY3gyZDBweDVoTEtzWGplM1J0d053NS9pVHV1c0xFd2Z5aW9WM3Ri?=
 =?utf-8?B?M24zRlI3UHdnZ1UycWc4ZThZVTEwbS9oUXUzZ1ppdFlRL0s2SlVwWkcrQThy?=
 =?utf-8?B?MzlxRW5DMXA4a1ZuaWZBVVBDWHUxN29WeWx5TEh6VmY3RTdQaWlyZTgxMmk1?=
 =?utf-8?B?MStrNzRzWUhKVTZ4alJHcllFVTltTUN2WWY5VUJLU0FvK3hHS1NrcU50T1kz?=
 =?utf-8?B?RklCMksxQzR6UWFNNFRjd05ic0hzZzVBdkE3ZmMySENQYWczaXcwYTlwK1Yr?=
 =?utf-8?B?L1FyVWFxOXVVZThyTGMyakpmVnFxTjVBU3c5bC9OU2RGNlp2ZlhvY2tlUm1a?=
 =?utf-8?B?YzF0Y1JTUkc5ZGluMUZJbFlOb2NSTmNaa01rRE5McXltSk82Wk1UVEg2RUNY?=
 =?utf-8?B?Y3poQ29uZm5oNmNMUFRzUXl5a29UMWJEMk1Oc0RMaThMbVZYMVR3TitmZEdv?=
 =?utf-8?B?M2RZMUN5UmMvVnpEL0NWVTdWQ3BWZXpCeU93dnFqclRnM0VmSGdtTnUwNGVv?=
 =?utf-8?B?MzdFU3Q4YXdCVkxrSzRrS2VROVhQTk1ZME1CcnVhNUR5a0x2UTBJUDlmMFR5?=
 =?utf-8?B?VCtsd2VKN1JwRkRkNUVKck9WVDYvVkg2ZzliSUU2RGk2U3dEZVV0ZkViQ25m?=
 =?utf-8?Q?63zTqf?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3CD1BD79C544C844A1EEC4F8871A9BB1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0

QXBvbG9naWVzIGZvciB0aGUgc2xvdyB1cGRhdGUsIEkgd2FzIHdhaXRpbmcgZm9yIHRoZSByZWNv
cmRpbmcgdG8gYmVjb21lDQphdmFpbGFibGUgYW5kIHdhcyBPT08gVGgvRiBsYXN0IHdlZWsuDQoN
CktleSBUYWtlYXdheXM6DQogLSBQcmltYXJ5IHVzZSBjYXNlIGlzIHRvIHNlY3VyZSB3b3JrbG9h
ZHMgdGhhdCBwcm9jZXNzL2hhbmRsZSBzZW5zaXRpdmUNCiAgIGJpb21ldHJpYyBkYXRhIChlLmcu
IGZpbmdlcnByaW50cywgZmFjZSBhdXRoZW50aWNhdGlvbikuDQogLSBTRUFNIGlzIGEgcG9vciBm
aXQgYXMgaXQgZG9lc24ndCBwcm92aWRlIG1lY2hhbmlzbXMgdG8gcmVzdHJpY3QgYWNjZXNzIHRv
DQogICBub24tRFJBTSAibWVtb3J5IiwgZS5nLiBhY2Nlc3MgdG8gdGhlIGhhcmR3YXJlIGRldmlj
ZXMgdGhhdCBwcm92aWRlIGJpb21ldHJpYw0KICAgZGF0YS4gIEFuZCB0aGVyZSdzIG5vIGxpbmUg
b2Ygc2lnaHQgdG8gYW4gQU1EIGVxdWl2YWxlbnQuDQogLSBwS1ZNIHN1cHBvcnQgcmVxdWlyZXMg
ZmV3IGNoYW5nZXMgb3V0c2lkZSBvZiBLVk0gKHRob3VnaCB0aGUgY2hhbmdlcyB0byBLVk0NCiAg
IGFyZSBleHRlbnNpdmUpLg0KDQpOZXh0IFN0ZXBzOg0KIC0gUmUtYXNzZXNzIGluIDMtNCB3ZWVr
cyBhZnRlciBwZW9wbGUgaGF2ZSBoYWQgYSBjaGFuY2UgdG8gcmVhZCB0aHJvdWdoIGFuZA0KICAg
cmV2aWV3IHRoZSBSRkMgcGF0Y2hlcy4NCg0KUmVjb3JkaW5nOg0KaHR0cHM6Ly9kcml2ZS5nb29n
bGUuY29tL2ZpbGUvZC8xSlo2ZThaZ1IyZ1VmQjR1Qll4c0pVeHAxS1ZMNVlFQV8vdmlldz91c3A9
ZHJpdmVfbGluayZyZXNvdXJjZWtleT0wLU1Hak1MZWMtOEpFSUZDMy12bVplTGcNCg==

--_002_SA1PR11MB5923CE0CA793FF8B63DFDAEBBFF9ASA1PR11MB5923namp_--
