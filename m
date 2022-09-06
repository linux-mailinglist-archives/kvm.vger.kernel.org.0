Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7EC5AE111
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 09:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbiIFH23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 03:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbiIFH22 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 03:28:28 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3743F72B66;
        Tue,  6 Sep 2022 00:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662449307; x=1693985307;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EQAfVtlYwSuMJBPclmdULw78PNxT6wJqeTSWaFrvvMY=;
  b=dw7u8FrI+DBRRuO63NSHWJAoTtmq3CSTSI1vY/vjoC2TT8b9/BIFFflx
   nBtts9vvm30X/Tl3u/X4p/j2wc8KRa4VD5hBUZRHLQFMLlxMieQ5sr/qs
   pOA5ivT7vcivkCaKNl3LB/dbrIAW+5Sy4r95feys5sZbLeCzl5S26t6Wu
   ym3FDXyfV9+hiZ/J3ACIoaSNZ3x6kHke6k9q3KKgsn5bRzQiWv/JsMeN5
   T6RQfVGYN0xNemdh8nPsDoIEDGvrAAOGHU4BbM1rpqk9WkrY3i0Zov4zv
   x6JAvlrakpRjSsy5l+AzZt4QHm/QsSw6g1nbgMImF1mHgASay16x7or5f
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="276920211"
X-IronPort-AV: E=Sophos;i="5.93,293,1654585200"; 
   d="scan'208";a="276920211"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 00:28:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,293,1654585200"; 
   d="scan'208";a="609868822"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 06 Sep 2022 00:28:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Sep 2022 00:28:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 6 Sep 2022 00:28:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 6 Sep 2022 00:28:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3isCP2vKxlRo4KRSt9BCXAK28kjvR1y2TVL7SrRTdmQe5Ko8dQgUizC1n4o9Bn21fNRVl7fIBi4ySxXNoUTvBq/fbABwzmNEqcxGDOjcj5jG/O/MxTCDGEt19it5BasstvGgBeRRtJj19GuYoFPF4NXJAdh882gd0BwG8PW1Rsn+upWziIg1TNL9SXD19iNDDsxq4GA604xGrzDHeRyrrE1dZ0HTt77Z3Cy9aqNS7mqoB8cFL7YkAsQT0n7B2IYV3cXYNdNIdf0va4Da3S6W3q/7T04Hw0RhnHIgU6Jh7GqiB2SpMa7iJ7v6ICOGr4D/sl6Ex+XvcOShx7ZeQeVrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EQAfVtlYwSuMJBPclmdULw78PNxT6wJqeTSWaFrvvMY=;
 b=CQM9BXOS1n6YAu9f8dOlxwVSf0SAQDh8fu1EvCc4zU44K24D5xwsh7hH6z/GNywvQUT7En5L1Rl3Ku9JaD8Equ+1xWwhkUDw/zHJPffN9yPjgSAIV0TZx7JDm5+tAc9Nob8mCfP6fIEVn21R2qZgeR27pMVMcPta8hN4+kbBempL3ya83Hg5DxwZOByPbIkzzIva2e6lv2AW8WxQ69x8J96HbwP0ASyU5kCVVrWiUXZzYYHvA6C9zOHolhiuTj2e3M6YlGJ4pyWbSX7I7FM4qZOsxj+cqxB4d/TBUJsn8kZwQOMDoR0C7wTvbYHU3BidbJseoHfrJ4qwtoRgU9kYAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY5PR11MB6365.namprd11.prod.outlook.com (2603:10b6:930:3b::5)
 by SA2PR11MB5049.namprd11.prod.outlook.com (2603:10b6:806:11b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 6 Sep
 2022 07:28:23 +0000
Received: from CY5PR11MB6365.namprd11.prod.outlook.com
 ([fe80::4016:8552:5fb1:e59]) by CY5PR11MB6365.namprd11.prod.outlook.com
 ([fe80::4016:8552:5fb1:e59%8]) with mapi id 15.20.5566.015; Tue, 6 Sep 2022
 07:28:23 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        Uros Bizjak <ubizjak@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH] KVM/VMX: Do not declare vmread_error asmlinkage
Thread-Topic: [PATCH] KVM/VMX: Do not declare vmread_error asmlinkage
Thread-Index: AQHYskgUp4SxXrn7d0qTS0WMmh60i62zP7+AgBVtLQCAAh/uAIAHTyaQ
Date:   Tue, 6 Sep 2022 07:28:22 +0000
Message-ID: <CY5PR11MB636505ECC6D27486065E5CE0DC7E9@CY5PR11MB6365.namprd11.prod.outlook.com>
References: <20220817144045.3206-1-ubizjak@gmail.com>
 <Yv0QFZUdePurfjKh@google.com>
 <CAFULd4bVQ73Cur85Oj=oXHiMRvfrxkAVy=V4TfHcbtNWbqOQzw@mail.gmail.com>
 <YxDRquTx2piSX66J@google.com>
In-Reply-To: <YxDRquTx2piSX66J@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 787df357-a372-4e95-5b28-08da8fd96152
x-ms-traffictypediagnostic: SA2PR11MB5049:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kh8IWhtfTEimHxxD8tNJxXqoGia8Q7cM4l7NSOjy6FqP0eQtYVq0vJo/c4jmN1AnPTn2QOsdhkAhfaO9fSwPbPZ3SjSNMK42kixlSyd6qvMD/Z7HpWxXsQZeDuncQqDkzxFMPqX9mGNEnz/U93ojZNyim6RcBKkAgGpZ290YCXtd5c3Z98i7C7xdzDJ7L9JEnwcIH6/PQOv3r7sRRaJHOvIBqU0XhZZ84dhjzYsitLJ5L2psDczkLxnKL9IR9sI6Yo5G/3sGBLDD1oekZAPAloGlVKqdmwXWoPpCgBDhx3INw7hx/sdVbPLf/LJBxscnVBjlqPtD3TrEjHL2lbNocmmjEMu4ZCLN2uEP6QTU2CUhiKkhB0E0Tst5FqIxMiDS9isQpv7aFGujSCB/qzKaHRssUpqd/t5aa/SEXSXxxzeBHoyQIorct/u5poMoxLJCOGojh1e1RNvwu7WaLWKs+LBsZKJEGHvXUgiXv0UMpwbrJOH+WVpTYu3ZshLQVGV96t98qlt3wmOtwMKUjpQ1ibevHiD69tTXq1PwHBqO9u90Z6GFoZHXhxxQ3lodZWvP2XOmpayFZkMJjqr6yTKCDOuOkL9WseR1IwcsD1BAJ1ceIEIwrpcBRotEcTO92b1krpQ7UOmlhEPML5IZrwL7j/lsbaxIPLx02RCkSZ6JIS6uVPoBoZQy1uLJRdbrf2viZfIZ6XCb7HFX6SQKNVLUlgHylMoyexIYWGDKx6OzQOMcUoPk9cSf45DfJePIuRcblo4f/nb0tl3HgSfjYdGDOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6365.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(366004)(376002)(39860400002)(136003)(4744005)(55016003)(54906003)(316002)(9686003)(82960400001)(110136005)(86362001)(38070700005)(2906002)(122000001)(38100700002)(8936002)(5660300002)(8676002)(66446008)(33656002)(66476007)(52536014)(64756008)(4326008)(66946007)(76116006)(71200400001)(41300700001)(186003)(6506007)(66556008)(478600001)(53546011)(26005)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0evm23OARwOjL/nHcXvqR6NQfpDx+nhAuQrgSytPpRfbOjLQI04JJkWT7Qhc?=
 =?us-ascii?Q?fFFw5pwYzvOC64lgtqRyoagPPjdPCDQl2OEF2ylPDiRyuhYfzMZJE4vU/LGh?=
 =?us-ascii?Q?Wc/omfBVmriXOAdU3dT0WTLCd18LQeSzj1IEL2Umnfxs6mNvOEa2AmHZw9KG?=
 =?us-ascii?Q?Kce5aX5zaw3rIH9ieRDcmgEZWUitj+VSQep9loZV9ULha8kLEq43dyd1Oif/?=
 =?us-ascii?Q?TjdInXwGlmFqKgF0IF3COYTCEye7rkKZ7a3pvYtv4KiDcYEiz+SWqQVdvTDz?=
 =?us-ascii?Q?+Y7j86vLlhtST3ZDp78sjvUrgoCWp4VTYSwbahuoBoVlcIJZ5Q5LrJnP9Q2v?=
 =?us-ascii?Q?g/fzhVVSQcTWkuSo4cspY2d2wnQ50P54CEXwg2/sm5buIpeaG/E2u2PYP0vK?=
 =?us-ascii?Q?VXRtQxU7C94nCEqm5BMdeKZRoDrLMPRldiwjEhGqbPj7kUhlRc0pLhjEzZ7u?=
 =?us-ascii?Q?NdmpbzyaoBD12NNIbFoVuSiCTOBteUe41cNHvjsULghDDYJ91zAlHG9zxxpf?=
 =?us-ascii?Q?HXN6syFU3t7ZmgbVc9BDsYTqu3UDMF4MZ2AcvHbPq8LxFW/39GorwMZOVI1Y?=
 =?us-ascii?Q?Ou4EYrQYhwdalF1cjMIFjJDa8c7sNt4/adeK5r5lslmLwVEisPcpWDTFwPeU?=
 =?us-ascii?Q?hm9aQ+Dy2/GGC5UtKBTio5oMeQBEyNyjjnziNYh/Dx4/pSFqtF/ms/PpRy58?=
 =?us-ascii?Q?qGCS4GgSLxb8S3qYCB4tz/xtROTUS4+g7xflJhjHvPa9FksKQ1rRE4TEVWxY?=
 =?us-ascii?Q?E8FuaJ+Z80Rs6aDJYKrCqxdwu+K8908z7J18cfPTadNDiFQbtNtPGM8Flrns?=
 =?us-ascii?Q?V3Jq/P3jXZjNVHLfNXHAzRlSD5a4Dc0xsEaBpaJId+iqbIxrjzWsSerl2nIP?=
 =?us-ascii?Q?MCYpSx43nQBgMDlU7vNnkCEKr4oe0r4U85/afOCW2r9AH5sL2MrmJQZds3g/?=
 =?us-ascii?Q?iMZDRU0Q2e4LLuMkMkRNR9Uv3TyyYLrZPDKLIcd+HqUBYL1qQQQbByCHUGof?=
 =?us-ascii?Q?uzVrdj+csDp7ultYhawfrsrr+LzSa/Fu6+Ij1ASFpdKa9ua+Y95fg1Xn8NvE?=
 =?us-ascii?Q?GcZzoJFE8tD7bCzboG4JkMetgSufc2C1U/CGJTeXD9FDMWYVvYgsemf+L1PR?=
 =?us-ascii?Q?E/p9UF2EYy1jDGAidIRiuKA+qgtL4Ze2oKundf+iTdTO3kzbpzikdkazq7+F?=
 =?us-ascii?Q?1ZA2M0O81JwoirPWDQHlowstfJdJEkzAp3+y3AclWBvw24/IWBTIgfWg5nst?=
 =?us-ascii?Q?gxJ6CCPCHoEU+0Xyb9GE6jHavQx4IjD+4GqsryMloekqbE2gEseoeglIpjsO?=
 =?us-ascii?Q?PfLQ4KiAumwvtT2SKPS+PoXIA6otkfq7gAGMzNip+ZJcp1PL6kfRZO6I/wUA?=
 =?us-ascii?Q?jTDfnRjdawgr/pjrgIPbYZ7Oq5+VAJozWwWOQHojR4YveFUCRqonlghH0Tix?=
 =?us-ascii?Q?JTlTRhKSBWW5u0DVSYzIbq9R5jmOS9VORMBvwzXkssQh7Fi8d6ghzDk6CbT5?=
 =?us-ascii?Q?Mq2BVUtm4ybmPP9ZqngtXb1U4tmxAu8B//rFIYRC7EOUpHJUPWCOmZpYOp79?=
 =?us-ascii?Q?Lm5S7left1+sLNWA+rhh0nwdGgl0bIowel3gJVQS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6365.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 787df357-a372-4e95-5b28-08da8fd96152
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 07:28:22.9340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OBr0RF151RJdh8LJeDwiLsytSqSTaDfws3EbE8FzqVfHj13t7KDu4L8pbieEIzsgHyWyfW4z0TaAID0c0grtBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5049
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, September 1, 2022 11:37 PM, Sean Christopherson wrote:
> > > And vmread_error() isn't the only case where asmlinkage appears to be=
 a
> burden, e.g.
> > > schedule_tail_wrapper() =3D> schedule_tail() seems to exist purely to
> > > deal with the side affect of asmlinkage generating -regparm=3D0 on 32=
-bit
> kernels.
> >
> > schedule_tail is external to the x86 arch directory, and for some
> > reason marked asmlinkage. So, the call from asm must follow asmlinkage
> > ABI.
>=20
> Ahhh, it's a common helper that's called from assembly on other architect=
ures.
> That makes sense.

I still doubt the necessity. The compilation is architecture specific, and =
we don't
build one architecture-agnostic kernel binary to run on different architect=
ures,
right?

Thanks,
Wei
