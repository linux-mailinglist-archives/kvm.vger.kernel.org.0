Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7D77236EE
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 07:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbjFFFql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 01:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjFFFqk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 01:46:40 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173F21B1;
        Mon,  5 Jun 2023 22:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686030399; x=1717566399;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nPOuXXwIr5OTZuwL4SX8aNK62+y3XWaZrVrkWLU4C2k=;
  b=Aea6vhlaWbXSA7rsvPyVybMpzcEeiTfb9ppkg9+2gx0J5Fe3vynKf71H
   JMHNQ9cAUwIw/N8ghvll1mW61HuNM+JC9VKsEja3mt0BA6dnWwbseOnJO
   fzKuA8GTmvIriVbF3n0sQ1Y/r5yc7KuikO4f3b1g2sY30295s17HJoLPn
   ov2ULu2vfsJsXS8Wm++rVjDinjF2VGsdgLS+6BDSkYmcfGTwxSRyi8cWq
   2StE6pxxNOyihKmiXoHPBypHhNzjxWhJnbZWzGuff7jjB2yZqP+NduntV
   sfK7XtEZaxwY0PMg0qajT6TGEmJYFInLRTp1GTiJblRgxQLLuzgDZZIUa
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="346167784"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="346167784"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 22:46:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="853267274"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="853267274"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 05 Jun 2023 22:46:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 22:46:37 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 22:46:37 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 22:46:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdyGZfQGfVMfjRzvwllWO8fjx1Or2fRhcgJkEoStwOqMOxI/BkI80tfKlksLc2MLSoqhjfKyW7cejiQ19Y387nXyATS5+S3uWcORKFNuN686hM0pDiNtW/vfZ5NPoNw4T5XY3vwo3FDy7pZPbWLg5BaJoUW2+f+7Xtg2+IvsiRK6TD2D+uXkQ+nTaKKEI62Xjn+ddhW6jWX/ldmPvUQanIMTHf296mMP8FRWcWa6t14BCawxhPDF3/ITeSyw7MZoH22rYTSTaWwNR3ACA360siv6PHJa7Gcqt1bIgtE9h5udJkGS0MWTNVeSzEZPxLNxT77vCZrl2S3vkRqfP4PQ2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=azczIjWrUyj9MC0fNae/Xvod4OriqCagc2r6cstgavQ=;
 b=eQf49+GWppFy0p0nGo3aQuOhm4+Q+btAmasRpLe4WJghezqVM6EJBcHEMxzb3/Z7uH8w538bCmUEI0QGbJ2or3ABqZbsBAbTJjhuDLjTFa04CEc/uFQQWMX3bF3MSTnaZiEEY7QSCMt3JSyNe78w/Dw7RmGKTHuyeg/k1Pw5yz23mxUJV1sNER8pfwYilm07KhnctNCm61kVty9U2ugYn2N2jakSjwJbbGNt93wuEhX1irtQSCO8o+cXhtRE2ABepYHl97dC84gTgPIsKCugTN/RJvSY2jXni5rGxZruBisWDA2y0YdU9XEmWPvLIOu/B24/8CIB3VI3TF25M51rww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CO1PR11MB5009.namprd11.prod.outlook.com (2603:10b6:303:9e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 05:46:33 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d38:3229:72d:88a4]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d38:3229:72d:88a4%3]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 05:46:33 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v8 04/33] x86/traps: add
 install_system_interrupt_handler()
Thread-Topic: [PATCH v8 04/33] x86/traps: add
 install_system_interrupt_handler()
Thread-Index: AQHZa4hMKbfML9J2EE2n9O+e9+6txa98QHyAgAFcNPA=
Date:   Tue, 6 Jun 2023 05:46:32 +0000
Message-ID: <SA1PR11MB6734F829654B94EA23FE0994A852A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-5-xin3.li@intel.com> <87y1ky70ce.ffs@tglx>
In-Reply-To: <87y1ky70ce.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CO1PR11MB5009:EE_
x-ms-office365-filtering-correlation-id: 20a5271b-a85a-4da0-9d44-08db6651623b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ++i5WnquFlrk1b0tY2weXjmogNcNRsjOaHdGWUabyCaykd8ckuu1wb5NHOEHxD91gqkxF1jRKw2Oydvbu3GzLhOJBcYgUJJ27xxGZ0RGciFFPXzDPlj1vJ2yRTIiPPHhR+cw1c5QBlJFnqkPfUyhugGCh5aU/qw+6lCwOY36SP5PMJtQf2T2RaSMJbm1jIkLg/Hjf8CVPmEaoeJRYJuTq4lPpqJLETquZ3tgJS6DMGu7ACnOi7XkeT56ZjkulFfhvM2EO2/Ah4kvympgEVZTNYzfc5h77nzwpPYkyyk1HhRvzl1I1r71KOyMUUXtdJ6oVoaqdDOdNtIkAs+sb/v+erIKuHBaJWDGWKQTW9Rhkn/53iO8ntsDppFZsSJcdVyRzCInkq5WqyzXgDlqMzQF+TAT8tROP85/34DypAKaOQcWVUStPhJSQlhUjFKHjO9uuokXLJDiGH9RPJfBm7IPsd+L30MsZyTWuIU3Tf6EDJT5+I4iBXSBFU9l9dEmd1sCL/mcoBS2/po2NuwU1KntCTp4Kg2it90x5dywXmazGLemq0og4S1lY3O0Pf9U6Zr4IO/iI00aD22F5PEK8BGyupZsU1YW79E6e9o2wkbNYIZQfFlboE3QfU8wj6AXFjWU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(39860400002)(376002)(136003)(366004)(451199021)(71200400001)(26005)(110136005)(66556008)(64756008)(66476007)(66446008)(76116006)(66946007)(82960400001)(38100700002)(4326008)(122000001)(478600001)(7696005)(9686003)(2906002)(4744005)(6506007)(41300700001)(38070700005)(7416002)(55016003)(316002)(33656002)(8936002)(8676002)(54906003)(186003)(5660300002)(86362001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vRrutTzHzMX2TzSTSyjad8Ck2WCfL0Y9pNKOfmKK3jsmdqWDKPO59Bqzm6Ro?=
 =?us-ascii?Q?/JcMbEqEFahHHJgckE/C2+fGz6yCwHkyBBMep5CAeweLkic7xW2Cf0bC4/CB?=
 =?us-ascii?Q?Wp196miyGVOd6n2CXnOLW5120fVRBABujYVuZ/f2Je7AH0f6wnn1aF9Tnjah?=
 =?us-ascii?Q?p0kJpDCHncvxMdRyG0a8TVnwzdcXbWJQIKUjK7T02JO8ECsV0/GM2+Ybdgvf?=
 =?us-ascii?Q?ZDjdEOA3Lsbu+cvoRkhvg+mRyjab+UN4ssAy5uD4i0QDk79EZJ4wWi8sYiGg?=
 =?us-ascii?Q?XAnsXrJA/ZDJ0Q8W3SuOJzGDqglats9j1CiJSy8LJW8NS3+f3lVD3A222UB0?=
 =?us-ascii?Q?sEwusMTt99dh7AFnLfRKb2u4sVl3M2l0/WoBWAQrsC4zHCDdhas3hmYhxjIU?=
 =?us-ascii?Q?tg1gDgiFMO+piA4I7nR3z9ooYpRd1WDxypyDSTWQCxVmiKB4Kjd6csoAcBrr?=
 =?us-ascii?Q?DkLyuwGrF3xvMQG6hCpatsOLJUhp9nUWfb/0zISIel3Jx60WrpLNUrGo59tW?=
 =?us-ascii?Q?JI5r/AQW9wDZLxiPNkLPgNoqM+GtLCpBKG2KHP6rLrZj6WKQnHDXuUXp6DBv?=
 =?us-ascii?Q?s7lwXl4RVrImkmy33G+q9hK5TtfbD1BriAxN9wvYggbSmNrNPWckC9/wXoYD?=
 =?us-ascii?Q?fRVSQPtQfbOqyHxUlptQs0bivAc+1tPOCnoY7dTMWLxY6zBxlNM1geXAFxaA?=
 =?us-ascii?Q?Arcc2rsy014TMdRLq47XTXqNXoDJFHSqvUvrgc4r8vRe+XfgvNebUpNVsh9E?=
 =?us-ascii?Q?puGtg7rJeCDE90BKzQZ7R+m7VKB6fJP2oN4qF1rNNKpKBHLunrSqp7OuXuEA?=
 =?us-ascii?Q?hDhlhYKnXt/FZeRhomXzAZv6dXZTGPtD2ZIiVRiz0RdYJjXYSS3ihfu0oWWM?=
 =?us-ascii?Q?h5cb0IWVWyuxLSOXFz2MZp6819dF4XkDMh7v5k6AYDiakmuwd1r8nAxRoGB8?=
 =?us-ascii?Q?ztyN462dYUUE1vGqeB4JuwlTjaoha8dTxmhzdC2zhCk6UeuOkHCcYBFO8dX6?=
 =?us-ascii?Q?cozPijcRvKVaR8Ti8Yr15aiZYA/09LSfCG96vxUflK2E5uSh6U5YgQQmEh7f?=
 =?us-ascii?Q?6lT3QSloOfSOo1suPXxl0U+SJLHgCun76CXG0/yTKnyEsv2MZ4D3kshiBzJJ?=
 =?us-ascii?Q?RPMsl4TR6GdlOeMVsmefLSJkEvdXM3si5SK0vPsny8DWOJ2AtVot3ZbLWgo8?=
 =?us-ascii?Q?QiN9N+9SCTAvPOhhzzs4Yqg9A+ms2aof5AGFJxGUqg5IFxmeXq9f7L1P56v7?=
 =?us-ascii?Q?/MfzYU5XPnlY1zwnenNwSPBEMJZxbeZM/JXgPfYQTk/vMkJTADajB/DdaHOU?=
 =?us-ascii?Q?25gG5BhCpEKneysZK7QKyC1Ry1TasFZ2y4W8GLBCpro8NQrS/luUlHjjSmLK?=
 =?us-ascii?Q?0+uM9Y5ijbqRDcq5YE8d7h9y8zqqH9f7tVnXqqGETed5gHnd5RI8sicJmsiw?=
 =?us-ascii?Q?xCx/myQXwEXWJFKqwD00uiiMbfzTWQsXLCArHtJcn4jhZ0giUpo1w2IQRibY?=
 =?us-ascii?Q?JsVvjUrgsp+xBvDoLU8+dHs2MBiVLg3vNJ3a+AY5f7uUX3d1IVQ6XhcFdNjT?=
 =?us-ascii?Q?WOJp+NjUhmfP0Yba32I=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20a5271b-a85a-4da0-9d44-08db6651623b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 05:46:32.9404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mwgsBRsW5sCU4YCWtWUcsGbG6vm9PlhbWh45dq9j5WX3gU9NTNI2SRAgwJ54a/QVAKvbr90BE1hSE2WPtd/ecg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5009
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> #ifdef CONFIG_X86_64
> static inline void sysvec_setup_fred(unsigned int vector, void (*func)(st=
ruct
> pt_regs*)) {
>         ...
> }
> #else
> static inline void sysvec_setup_fred(unsigned int vector, void (*func)(st=
ruct
> pt_regs*)) { } #endif
>=20
> #define sysvec_install(vector, func) {                                  \
>         sysvec_setup_fred(vector, func);                                \
>         alloc_intr_gate(vector, asm_##func);                            \
> }
>=20
> -	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR,
> asm_sysvec_xen_hvm_callback);
> +	sysvec_install(HYPERVISOR_CALLBACK_VECTOR,
> sysvec_xen_hvm_callback);

This is a better way, and I will do so in the next iteration.

Thanks!
Xin
