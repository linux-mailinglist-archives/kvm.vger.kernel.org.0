Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52327156E3
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 09:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjE3Hfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 03:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjE3HfU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 03:35:20 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDF4A7;
        Tue, 30 May 2023 00:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685432118; x=1716968118;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r5otXTb0Rr9kV1sdVhCTLynkGsJvnsVpx1sTHMxmFB0=;
  b=ayNPxu6lp5PRpDJGLI+Jqox5iBazXJNp4dJGNSn591qIQLM0NHv3Q7xX
   7XJeSu8fayAPBEGzSDKQrjlOEZmn2piVdVag83M+oxl5ueVohlnWRoRfQ
   gWg7jYTywE+GX38iuGjcJbVK3uI90wMjW5KxhEEW4C3ccazYQmZ3oWGiv
   wWpDDGR34AMn7XdRyuYT3hQ5iXYoXf0bS1ziQh1q9ftj+qScX59C9lxPM
   wLAhCITWixdrtZT3IERojjTZdfmo1R5a7sTQBGywlcqnNMMmYgA0v+EXy
   5IdOyZsKilb+ykIpk8vqYCUHACt9lxNjM3Q1tVjIQxFh/hxNaJ7DemUKj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="420600554"
X-IronPort-AV: E=Sophos;i="6.00,203,1681196400"; 
   d="scan'208";a="420600554"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 00:34:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="953015145"
X-IronPort-AV: E=Sophos;i="6.00,203,1681196400"; 
   d="scan'208";a="953015145"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 30 May 2023 00:34:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 00:34:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 00:34:52 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 00:34:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKmhlLhxdeB8o05msaJe8HVqlwbWlKW1WzXfze5BVlApaz7hfWo4yb8rlRl9aQRMqPGP5oKfXhWEOUARxfDdegS5XR0DPY+BH3epgNS8cTiz6ge11piPXY5HHBQCJfcnhoszhWmUnYpPEU7P4Vhm2jhvklvFdlJg71thkThK6iw86GNdQeEiAiB8ppxjUG1WT7afJgs7EzxZPHq+I698jO013uPT2TTzzXVuWzO2jY37vPNINtlw44J/lysxcQQvG4sMLQSTax8b4FPTow0ScbQLCwcN2HER8IdDePyTQmKWJa6TiFDuUdvtXHZ0dr/LKAW6CmnoVx5kW+S9kwLyxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r5otXTb0Rr9kV1sdVhCTLynkGsJvnsVpx1sTHMxmFB0=;
 b=HiVwo2IP+473WmDbtFBh64CDcXgbUPGSjG35SzV3JeuwLFA+GSDfZyzKkmY5C2HywUvC73tWb0c62vqXudgYWmxmrGa9HAjDyskeV0Ehf7vRHFbjrErO2vL2xEC6oGnBR/gcj55yOmgDXdIgOXsX4ZYe0tU7nEXKuAi0JMtwT1tSdegJMa30UmaTIY4ZVAutOJsdN274n+8r1Qtmp31ID5bzgGl/FsFdn0v7B6SBo9dxV5vqql+yL8+9fTlbcLsLnuAKgxq80Twdj0K6xDiG9cqqJN3T0jDYczHPa76qx+AJvdoVxsoDQ6/QrsgaAbK32uAgGEg952x1clgvUl89Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 DS0PR11MB8181.namprd11.prod.outlook.com (2603:10b6:8:159::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.22; Tue, 30 May 2023 07:34:45 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::14c:205:c858:1ef6]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::14c:205:c858:1ef6%7]) with mapi id 15.20.6411.021; Tue, 30 May 2023
 07:34:45 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        "Chen, Bo2" <chen.bo@intel.com>
Subject: RE: [PATCH v14 000/113] KVM TDX basic feature support
Thread-Topic: [PATCH v14 000/113] KVM TDX basic feature support
Thread-Index: AQHZkeUAlR2dYIpUAkWLdmAkkWfx269yVJmg
Date:   Tue, 30 May 2023 07:34:44 +0000
Message-ID: <DS0PR11MB6373D94AE8420F45798E7D40DC4B9@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|DS0PR11MB8181:EE_
x-ms-office365-filtering-correlation-id: 7362abb1-9665-45d6-7c9f-08db60e056c8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cncmx/mJXWeMBP44ZLL7Y+msaCba3GJJ9ENUOy26zIlDI/GQJntN5y6tpRyM49apmHABNuav/AncPpNb5S+nC7lnfwrghK44M7rUy6Fy0fDI4YYItkJwW+eERoIdHKxGI8S96RzSlvlJZrIFM4FcrQTHjoO2WlAmLVnjW+VCBz2HlOdcy/h6bxDg7SJtZHLiUy4LPDewDBOKGx6sTgwx+ui3FjI5zw1RJXtppAEDVxBXg06dDYNc+0E54Ou4Z+516X3DI2WfIAHzi2w5ykGsZdE3cISC1TI2F5y/yVHSehl+faWa9IwdVFUIswFeJbod/KApbdMLe0N8LjnHMsquWigxWPyY916Sb5r+jbQYKTo8Oav5cSO9hxn5J/fZIN+gbp3/XPWrpiWKmedOXNYAEijb0L35u+xwdHhaPqDtFqs3tSF29bBc2r2gjf8W2Z4Gl6FiYUsDe8drwOLFnOtyWhpMJWfow2X5gOVPun4PHB6uJsgjN7DJEjmQFfwuWaoLLJj2fxv/4t1ytlHE9teJm18KFmm5q31lB/sihFAF+U1lf+Zo7n8hdp5QscAHjy8PSHZkxz2Wpu2CkbW70H2ditg97R5SsskP+asQneNyfIaZAC5f39UboJQ9AQfHUqJ00+0ejGvrCtl+jqHv54hfkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(39860400002)(346002)(136003)(366004)(451199021)(82960400001)(122000001)(478600001)(38100700002)(76116006)(66476007)(64756008)(83380400001)(66556008)(66446008)(66946007)(38070700005)(54906003)(86362001)(110136005)(4326008)(2906002)(4744005)(7696005)(33656002)(316002)(186003)(26005)(71200400001)(6506007)(9686003)(53546011)(41300700001)(107886003)(5660300002)(52536014)(966005)(8676002)(8936002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Oppj/eYyUOTspQJbCjF7JCwE7fhQufKm1MWXGgnCgnpKOZnApY8/k1yRw4G/?=
 =?us-ascii?Q?Mw+z1BxMvHmBQCa56C8L1g3J/ljUAOiMdzOcLJy6LPI7rLvu1S+5Z1y+sXTV?=
 =?us-ascii?Q?1rRTlGHpk2gSvmMB2ttqU9zIUoixtzLZxbM3jo6Xz6PQhmtVE6bwQ7Xb80L+?=
 =?us-ascii?Q?4bEymNuuBCEjFQNm8sFzKE/3mX1rSpN/5VA3Zz0XfFbPWHU/cSO4l5I9hxFQ?=
 =?us-ascii?Q?KGuJhPxcgC9zw2qklaPidMhjNNl5y34lgq2RSPFyBCtzgGYJZMAU1fONO1BZ?=
 =?us-ascii?Q?PmRQX3lmNMYCdnw7i0sT+RbYV/DyrgZlnHHJtjllkn4ITMq1wOyhrQ+p+F3w?=
 =?us-ascii?Q?z/TtkJoNEprGk4ik5e6zqZmylPpAEjczhXrE9nlvwbHDN1I9Qx57kSTm2DRF?=
 =?us-ascii?Q?rKSn6bl5I6eZJJNeQJeSVLiZu4QyIzwC0BwpdRXr36KCl2gSe4gR6zxb/IW0?=
 =?us-ascii?Q?TOA9AZ4iOmC5dfUhtEcSlEIplYd8vO5Q7x+i4ABv095lidwvBnl82GQdAL1n?=
 =?us-ascii?Q?xDYCnSmfD1sHQxL4q7nOt0C9XjQR1IAp6QYcLtHuKzcm8AEoTJvSbNTY6kW+?=
 =?us-ascii?Q?2ZKEJ7bDbasZOk9XMkSyos/33bxhr9LKOmYwVGWJxSvjd8c7cabzRacBnhQ/?=
 =?us-ascii?Q?XCsVGkl0sObgcm+nkiJkCDy2UzkgMG42e/TDRPFcZrwTYTxKj183U9JKq23E?=
 =?us-ascii?Q?QDGoZWuPyYlfXyP6VwYPI0VLuRY3Dt6Ur8dd3zCZzqZncHSpV/LU8nKQaAxl?=
 =?us-ascii?Q?KazlX/YyLOhnYEURNjdI1e7oLokeV0LqTpa9rmFGPQOCQDjiGZYCTmNN6+M7?=
 =?us-ascii?Q?BBhy8/VaAfRhRsRDdNcEMkfaugRA/yhf17D4okaDu1sIgReS686PoUnhp77O?=
 =?us-ascii?Q?t9Ji2C7MQEVOEwOX0pAft3x5wnLxAZXMJghn+iqw7zwzfpZmfWGslytFXnWj?=
 =?us-ascii?Q?gZIRx0yyMzDy7iydcpIsYUm4bM8qor0W4AZNFQDU6PAXwtmzbnU1GgvtiFAs?=
 =?us-ascii?Q?nfFqWdl3MC3LWSTrrk2ftBUWGVs8gcNtoXyh3rgcD2tsvUoQSq+cFy/qKsPz?=
 =?us-ascii?Q?FcIO0QzcV5FrfA36PMDqj95rx2YXyiycIcHQybLcFwqbxNicd4t5iA0xT1Pn?=
 =?us-ascii?Q?uiHk/CdhpjnbLZmw1P2dOafC/J5y/y/CBqrN2C1sqetuzzBhbhh0PDzE2fuN?=
 =?us-ascii?Q?06ZaYUp2vWk68+QaAkz8o1+nH/aeejVv/G6c9Nm3nX17lI9jmTsBcOqs0hxw?=
 =?us-ascii?Q?508jGjAYAWNaqHtziQ2SkmF+KbHmMoJFiYpksnTBVnA+cnrq1hA96OvkBjTm?=
 =?us-ascii?Q?EhwE0BgYnzmS0+39KVf9vTI7dGI8mlGipt6T8jW5bVQmjcy3fI7MFoSBn3Ga?=
 =?us-ascii?Q?RnhMyp5r/lV1OKcReGWBYeuDAZ/ddIdmX73V8ZfHlcWfyA2eBumm1SaN/vr8?=
 =?us-ascii?Q?yT+/d9GjMcskqLTw6N8h7kQtG3YtpaV9MAOD0EiWNWKA6YB+J5/QFwy5iPwc?=
 =?us-ascii?Q?v2oW0k3rLdd5LPwd7oEbr5sLBUe78q9M1QJ9Cq7Zr3jvdgQLA9ksurmpQ2xZ?=
 =?us-ascii?Q?1Uui7/St0xW2ZfUBN33dWl4Lx85hzQmgcEgstgEi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7362abb1-9665-45d6-7c9f-08db60e056c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 07:34:44.7624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mHihsvbsmfEmGyrqKWwem8FcAcP0hv04Y3Pb+iat8MqaPvTG+W214P0cNyr8s4XCgwbqObrB/9E8dejgmainnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8181
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday, May 29, 2023 12:19 PM, isaku.yamahata@intel.com wrote:
> The tree can be found at https://github.com/intel/tdx/tree/kvm-upstream
> The corresponding qemu branch is found at
> https://github.com/yamahata/qemu/tree/tdx/qemu-upm
> How to run/test: It's describe at https://github.com/intel/tdx/wiki/TDX-K=
VM

Seems the above wiki lacks some update, e.g. tdx needs to be enabled explic=
itly
when loading kvm_intel, example command line (e.g. private=3Dtrue for
memoy-backend) to launch TD with gmem.
