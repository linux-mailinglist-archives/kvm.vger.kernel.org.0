Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724BE76A541
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 01:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjGaX4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 19:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjGaX4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 19:56:38 -0400
Received: from mgamail.intel.com (unknown [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2058710C1;
        Mon, 31 Jul 2023 16:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690847797; x=1722383797;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=31WsicpcNNvek3YnklVyRXD0MklKRmtFMmVSh76vOCo=;
  b=K4zo5F73zfapQRWX5w6Sq+w6GjmBWW4w//le2/rth093tFs29xFIM8B3
   ALPgRWWoYQTDYdUw2tsPc/5LmgcjURebpMb9CiabNS7CR2rUFQdE1k8eH
   YaJ/13weKwthyk0sP6JT1eeFQVIMhzj7eam55c3XepYrQLQrpK8DhCJRX
   f8WhPbuopm0T6pDVF8IlP3myP/mZTVdf1nCZvkqSbKV2mgRmxuos4DFwd
   UzXOW75qiioUW0WXMfOetuBcfaYSFnpWw/5xQZ/wWo5qXD5fMd3Cq0NuM
   RJh7ztLesZ1DMXvSYjPSSN8QTJZrjMqN+ebVqAD5p6vj09PItOrI64yy9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="435473912"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="435473912"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 16:56:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="722277434"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="722277434"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 31 Jul 2023 16:56:27 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 16:56:17 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 31 Jul 2023 16:56:17 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 31 Jul 2023 16:56:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDFRp2hkuZuuO3RCWo7jyJTUenxPWv8RPHFGZuhn+b6xVqERTq9m4rmdw/Wl+Oq8FLiouU83Kbnb9oHDTJfJuhGHKJPfXgdcCdIOKqhS+CJ3He6jvmjbolXSRCWAamB6/OBKBhKzkrLWRvIHAOEmxyOtR9TzvOrJD9X0PBjClAH02GQEqNodu85QaCVaTDz5CEEPL0Oi3sYaNeYZR8yYy/3kP1GF19eBe/Si1q0GZdxyK0Ay0zFG1BFUk9Zz1+UuBEoeYUII+6hdcIp2l9W40dEXgbUagDNeLIju4m5EqMK8E7wdmoeFs4ma54EXGbfIeTmKY2OtHcdq3NKkA15iyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/0sj4w5hcV1tPo+r2Dgugjcpxzo+B8dri5u2a20JY7Q=;
 b=H8dADxF6A94Jzr6wBvPn+ckhXmR5BnSEtJHY4nwiGR4DiApcyXUV9T1a5XK8JWRBK1p6/IkI2RxZU7xRrk5VOt/3plcimXXMOdqCyF4+iLxvL0pcE/MNn7rZ/WzaSiQmCAUWiN/QG1d5J4tMqNB0OFqBcd1oR/kFvLl3qV8a+n1VkSbEZtbipbTNh5pVax1isc4ng4bQSbuFNbaiLFJbKRjQ+k+/Yp2JTY27N17GVbbbZWsJ9O66RzL/CoYvqMJGZdDFKPJ/5mbP4PN1NtL1JT4lxmnCc+6GJJs2aOkke6QJxKsEjW6tjbPAB+GzUv9vYpKrBSRQivxnL7mmS/Dclw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SA3PR11MB7583.namprd11.prod.outlook.com (2603:10b6:806:306::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.43; Mon, 31 Jul
 2023 23:56:14 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::50e4:2cb8:4529:af04]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::50e4:2cb8:4529:af04%7]) with mapi id 15.20.6631.043; Mon, 31 Jul 2023
 23:56:14 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "Cui, Dexuan" <decui@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Stefano Stabellini" <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Breno Leitao <leitao@debian.org>,
        "Nikunj A Dadhania" <nikunj@amd.com>,
        Brian Gerst <brgerst@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alexander Potapenko <glider@google.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ze Gao <zegao2021@gmail.com>, "Li, Fei1" <fei1.li@intel.com>,
        Conghui <conghui.chen@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Jiapeng Chong" <jiapeng.chong@linux.alibaba.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Ostrovsky, Boris" <boris.ostrovsky@oracle.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Yantengsi <siyanteng@loongson.cn>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sathvika Vasireddy <sv@linux.ibm.com>
Subject: RE: [PATCH v9 00/36] x86: enable FRED for x86-64
Thread-Topic: [PATCH v9 00/36] x86: enable FRED for x86-64
Thread-Index: AQHZw3zlhMSIUq8NQ0C4pAXZBOhbuq/UddgAgAAIhXCAAAUIAIAABoLg
Date:   Mon, 31 Jul 2023 23:56:14 +0000
Message-ID: <SA1PR11MB6734CE532807D528CEF5063FA805A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230731063317.3720-1-xin3.li@intel.com>
 <ZMg1sD7IamB0INVs@google.com>
 <SA1PR11MB6734A02EEFD83969F1965A8FA805A@SA1PR11MB6734.namprd11.prod.outlook.com>
 <ZMhBDoTxqghvF7G7@google.com>
In-Reply-To: <ZMhBDoTxqghvF7G7@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SA3PR11MB7583:EE_
x-ms-office365-filtering-correlation-id: b79b50ba-925e-4885-c69c-08db9221b955
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fnpJ/4aIfIIMglKmffoocn8XcRv9dO8Mfjs0lsw2pL/abvEayvslP0KJxhorLH7Jpd2cVUPS+0MVNS+hm7tTYBQMe7FUiX2bp1hs83+cJXECGVGVwkSaY0DwKjC3icxE145kzBDw+IQA0Ut1QDz2Wi2htjUrTJghkhoG95Z893qBFAZDro6ZS4YVome9RnzhHXLZHPj2r2ggqClw8oDnlnqKQtRSBUWF3Yl6o+yHtviBxiOq7qOABkOAavAF3IGKlsIVUwnnmBzcBlT9F7JaAzF1F6QOU9km0nPGgcLcUbE4fgtru297gRmLWUGHgvaArcFIYH68IKJxnSpg6cJMLRxfOp8YH+XXom/LzqxVuUJAqIxheSbx+V1zxzyM99qwj6SaCpgIhR6SXfbYUOQpPTjAWGbSN5M8etMTEbBHoJ2WeHkSxVkn01TO0qFgzyKh1CqQgMFe5ksYWUGKB/Ra2WK1xEX+vYINFww/PfNrqs24mJLMhD+lwlUEx6j4zBLwhcEhYnWomWcpommuIYbs5oSSvxgbNYluZPrOvpCezij8FbV+y5mi15BLVur9a/vnx9D/G4R0RZdnZDaG9NgzNg711Pg34smVqQhM6R5r3ipZ8HUxkYDSBxqWeyAI2Hcarq4h9HCd58g51CUMEtNIkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199021)(966005)(9686003)(7696005)(55016003)(6506007)(26005)(83380400001)(186003)(76116006)(33656002)(66946007)(52536014)(66556008)(7366002)(7416002)(7406005)(54906003)(122000001)(82960400001)(38070700005)(41300700001)(38100700002)(86362001)(66476007)(316002)(5660300002)(66446008)(6916009)(4326008)(8676002)(8936002)(64756008)(2906002)(71200400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BGABAhTOr07x+mi6BWqWI7N9oQ/i+ya4IatXebIQVoCDKA3XbuHdie6RaLV9?=
 =?us-ascii?Q?Ikoy/kWqjVY/WIDSaupbIZi8CfQa1/oGF0XbpERbDMna6Dkmkng/CPdigWij?=
 =?us-ascii?Q?dpupTNlY+OLKzUW051H3mmyFHTAVM/PW/ruBKisScon4efLCWJ2OmMDcZ/bQ?=
 =?us-ascii?Q?72W+nm6v7buZbFBLEr89s88S3+SVhprIW5wQdZvCHHc3YoK3hymJ7KhCfyvY?=
 =?us-ascii?Q?5NoL8IYAUQZooP8t45JRXDECNWwU0JlmNx4lAX2eVo7fX0DhJpzNd3kxaVa+?=
 =?us-ascii?Q?dcxpuIDMOrEOgWVdqrnkSJAtHR6omT7TvcHqNzAxbD0qD+iFwujLO5l+XkI0?=
 =?us-ascii?Q?Sog9x/LbA0sIBRpDTiLrc8JYsbIAIUxkFaJ92Kj1/o/P3w41RWp9qB+JpWoh?=
 =?us-ascii?Q?gfDMlLFepChCQZuEoDbA1X/CoBkpwJLckXIvlVichqiHYvfLDKqI2lBkocLr?=
 =?us-ascii?Q?ZXVg+FT9rPx3ROaan336pMVnbin5YX1bDFt+q2h8HqJds3qdf3UPD9TSO8cG?=
 =?us-ascii?Q?4cwC24cET+PcSuRIFBZcKB4if5YBA9C8v5+psPPGCktN+uyg8AKMNh4HovRI?=
 =?us-ascii?Q?9Wj4hp3kpopeD9FMbVWCN9SEB3mEFPcCjOj1bnhIW6Ueu9oUFOYdQRuN8e8q?=
 =?us-ascii?Q?5iHE+ksTlH3KL1LNIFRy6a8bM1Po/4ZBgYN/aT+AviB4yBfT/aG+k5+4Uasp?=
 =?us-ascii?Q?Sp2NADp5gfjj8iY/A5//+HdqaYL/5dr6HlDBUtkS7c/7YnRWWkv5ULZIuSVY?=
 =?us-ascii?Q?ITCRdAyh67SJen0Ljo1Topj7DPxjbZgpYnf70UWtWWaUtC3+ciEpx5WJtHYi?=
 =?us-ascii?Q?0FqffeUPQNaBv0yUTfxFMA5ZV2q/diZ0uB6g171qhkktAmTkygITEIJ6xAj1?=
 =?us-ascii?Q?37cfZGUAzFs35JUzqIeaAwCFtQ2jnxm262v55jI/laf4LtizP+ZjY1Aou/Ak?=
 =?us-ascii?Q?dQ91ygm36oyfbIU/sRe8DSxHubw7lwpaTtI8Kl05IepfZXFAVd/LGkPT5HGo?=
 =?us-ascii?Q?DataDSddskzLc7/LQwz/wLJZkn5uGzoVVvQkhTi9JcICqXWNEnR3LP2ZP4DM?=
 =?us-ascii?Q?sG7iyJjedQmpKJUd2RqdMfO25r86g/ed4KeaGzNDEn71Y6xBDQUiZOoqBLtt?=
 =?us-ascii?Q?8YOPgvRQPUgItmEp8aDM10t6BWN52aH6HuiYbaEFS3JAouSrmYFyHK98IkGi?=
 =?us-ascii?Q?31Msk0T0bq2mLPoBZsWkAUmBTVg6NQsdwP/QB20n06hqAobIunQ6htOvR+rZ?=
 =?us-ascii?Q?5dzaUTISOPj8SkeWsiizXm5ddXja0DhbvYg6ITWiSkbXMq3VSh7OTHlFfctM?=
 =?us-ascii?Q?UIw8dedHl4F3hdQtz0SGoZmOtpChNF1DZbEeDAIfrpS/4zdJG2ISyfQki7g+?=
 =?us-ascii?Q?REObukGNLDF0fpxkbpq7oKo8baQbTt2e2r3PepVhs1uBNrdCmVYCdWiNJDvV?=
 =?us-ascii?Q?L1cPQ4GGUt2SD4usHINHj8mMIo5uusNYc392Z9uSIU4TGh5RZg4TY10vMmq5?=
 =?us-ascii?Q?SUx8kt+wdZLf0y6RLDnI48Z44R0tQzemsNlmzDcDhWkPZuebnlfwlwuj8+NW?=
 =?us-ascii?Q?G+wcifckvjaxlyOoIL8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b79b50ba-925e-4885-c69c-08db9221b955
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2023 23:56:14.3777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j3v5tDRivwDnUkWJYMiphu+ldGU605WuA8UsJ4/IMsqwAzemGYciZrWfvE5R9DuPs3yWPuCg22FPPULjCVqAUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7583
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Are you talking about that you only got a subset of this patch set?
>=20
> No, I'm saying I don't want to waste a bunch of time tracking down exactl=
y which
> commit a 36 patch series is based on.  E.g. I just refreshed tip/master a=
nd still
> get:
>=20
> Applying: x86/idtentry: Incorporate definitions/declarations of the FRED =
external
> interrupt handler type
> error: sha1 information is lacking or useless (arch/x86/include/asm/idten=
try.h).
> error: could not build fake ancestor
> Patch failed at 0024 x86/idtentry: Incorporate definitions/declarations o=
f the FRED
> external interrupt handler type
> hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch

That is due to the following patch set (originally from tglx) is not
merged yet:

https://lore.kernel.org/lkml/20230621171248.6805-1-xin3.li@intel.com/

Sigh, I should have mentioned it in the cover letter.

As mentioned in the cover letter, 2 patches are sent out separately
as pre-FRED patches:
https://lore.kernel.org/lkml/20230706051443.2054-1-xin3.li@intel.com/
https://lore.kernel.org/lkml/20230706052231.2183-1-xin3.li@intel.com/

Sorry it's a bit complicated.

Got to mention, just in case you want to try out FRED, the current
public Intel Simics emulator has not updated to support FRED 5.0 yet
(it only supports FRED 3.0). The plan is late Q3, or early Q4.
