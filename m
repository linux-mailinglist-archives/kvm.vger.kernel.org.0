Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1111A7D5ADD
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 20:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbjJXStQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 14:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234883AbjJXStN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 14:49:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8964510D4;
        Tue, 24 Oct 2023 11:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698173351; x=1729709351;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=usdxsF9lYCqMI+L7dc8BmacVO2mMQ1i8FF8NWg8YyO8=;
  b=WvvmOFhPthaPuQIqyFXrCV3aZYIdGI+LZtgjAOp8gT39zFoE5zzorMDO
   AQUviS78qPPkFWwepWT/rPafjKMShy2bkjaby0fHaT1bbDTk27wwG0mnT
   ycwx6CWty5VMYmzbb3/SOU83oCBsPho38vBMFzaDLqhl2b1ssOqe1v9ji
   OowHLK2qZ+2ITzE4eoG7y98l0J+G+z32G8tTzfxa48SEkI72yGgWWSmfn
   /PrJz1zga2HX53L+0ul1W7yWQ9jxoEnnvd0AvDZ1QlpPl+Jpc9fcjJHC7
   /9Ybk4LZ0t90m4TvunvVGERfTsgSpAS6mDzNJbnPQtrkKQaElJAUYrOSi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="377515324"
X-IronPort-AV: E=Sophos;i="6.03,248,1694761200"; 
   d="scan'208";a="377515324"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 11:49:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="708420787"
X-IronPort-AV: E=Sophos;i="6.03,248,1694761200"; 
   d="scan'208";a="708420787"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2023 11:49:10 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 24 Oct 2023 11:49:10 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 24 Oct 2023 11:49:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 24 Oct 2023 11:49:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9LPU1taWHy7xkzJZj22JAMLwhFh7PTuCvNzXHWwuSBp62LHHGwVofRNqr4L6ZP060tHajz3+H2u0yLY0RQLEgjxjkCU/a7ILgusaPg8e98V/CM24Jo1YzRv7OFhvkPdKcHmNta33TrCJQ0xtuH5yT9WM9fH3OjrkiGxxcSpQ+4ykd5S6ZWUFo7a3ZC/Y1EpA7jo67bgO1fDoiqt7F1dafWVIczcNxPGmICPflvfGYnHDF0i74ngJkdP/72r7P6zpmziJykl82fTjZDusjtyYz2Esu7Nqj8LXia3xbJrh9CQxUGVQ5kv9Wglj+qCKq38I2hXS/NbpC7eepmNDNoXoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=usdxsF9lYCqMI+L7dc8BmacVO2mMQ1i8FF8NWg8YyO8=;
 b=GNr6zsfOLEjJUzX8iQmFf2RNqQie13YQjvi/KQvEP1HWTAMU24J/pwkubUPZLg9bdFvbKy3G69klwYUTfj1qewlOpGBbO5+c+EM2sYkYRnhXwQDAgCW83PvcalfpMdSZ+T8wNpdbPlHAsJkVCXRHey/GF9ZB++eipvqA6QjTGkBKRJgvralMVPNvF3V5Vm0t6j+JBd9tss6JVtamdjRUjjOxGGQ/C6sn128jy4kNRrIHMuDec1VlQpiM3Y7vaYoMdcZ60dQhnImH4yj64e3AtnfouR7zk1IjYrSgIAwd8NXNNbqfMvvaKR6xkHqSZa/YOYo+k0g8GEjXHdU8iolKCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA1PR11MB6894.namprd11.prod.outlook.com (2603:10b6:806:2b1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Tue, 24 Oct
 2023 18:49:07 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3ffb:89e2:2724:4c5]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3ffb:89e2:2724:4c5%2]) with mapi id 15.20.6907.025; Tue, 24 Oct 2023
 18:49:07 +0000
From:   "Luck, Tony" <tony.luck@intel.com>
To:     "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Lutomirski, Andy" <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "antonio.gomez.iglesias@linux.intel.com" 
        <antonio.gomez.iglesias@linux.intel.com>,
        "Milburn, Alyssa" <alyssa.milburn@intel.com>
Subject: RE: [PATCH  v2 1/6] x86/bugs: Add asm helpers for executing VERW
Thread-Topic: [PATCH  v2 1/6] x86/bugs: Add asm helpers for executing VERW
Thread-Index: AQHaBlFLwqOP8H6wikWc3HOPoHDmHbBYvyCAgABkX4CAAABOgIAAAoMAgAAE4QCAABeyAIAAA6Lg
Date:   Tue, 24 Oct 2023 18:49:07 +0000
Message-ID: <SJ1PR11MB6083E3E2D35B30F4E40E8FE7FCDFA@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
 <20231024-delay-verw-v2-1-f1881340c807@linux.intel.com>
 <20231024103601.GH31411@noisy.programming.kicks-ass.net>
 <20231024163515.aivo2xfmwmbmlm7z@desk>
 <20231024163621.GD40044@noisy.programming.kicks-ass.net>
 <20231024164520.osvqo2dja2xhb7kn@desk>
 <20231024170248.GE40044@noisy.programming.kicks-ass.net>
 <DD2F34A0-4F2F-4C8C-A634-7DBEF31C40F0@zytor.com>
In-Reply-To: <DD2F34A0-4F2F-4C8C-A634-7DBEF31C40F0@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SA1PR11MB6894:EE_
x-ms-office365-filtering-correlation-id: 6d45119a-f2e6-4108-f43a-08dbd4c1e6ec
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H9ka/v0uT6hL7LVeEPZMAzLnR/mkb/UkwY3gEBy1jY/t4GYI+WnFsF62V5yo5h7vEmR7cs85PyetMpLQ+0B1dC7WC4QEWN2fo24jMxYzguEcNDsdEdwRl4hQ1fpzsN45hvynb9Jv98s+gPRz0tiwREcAjWqe6dN7a7Q4YhBip8h+r6m/vfVICeEcgWm54Ag6GmHs1yUrKd5JWR222Gr5MaND8/GZgda51pLSVW/L1P/5xZUv3XYD3OlznZsv+F4Wx0slg+3ExKQvZC5W2WK+axGLx34f/0L0g0fTBOL2LsEDMYXyXAiATlXuKNHDUQCuBzqQfw8+REo9yuOZTJ0twIS1d7mGr1uj55FtfV3XCpEzFrfMTcuysMptWC3hydlxpQVSA1sFCwMdMdq+G1eMsFc1JUm7gr/EB0rLWoUccVN+yF+Tqg8cfTkjRcRK4/Y9/jp2cpcwTrGjw61HwUccsWNkktDOyh53Hey+dOcUYBdk8eE/Irz49H0qHX/GNSqpfmsUcGrN5cawsVRYx8Lka+PXsQ+XfmvUTSD/Z+fYQE8g+G2XGcAVtVOnoaoFDC2SM5dqeoN6St/ZLzbnuz4hyqcj92mnCemW7oYB6OYeoQxTJnFFoeVnoCywDnKHnfiE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(376002)(346002)(136003)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(38070700009)(316002)(66446008)(66556008)(66476007)(55016003)(8936002)(82960400001)(64756008)(4326008)(66946007)(54906003)(8676002)(4744005)(5660300002)(6506007)(9686003)(76116006)(52536014)(2906002)(7416002)(86362001)(41300700001)(478600001)(7696005)(110136005)(122000001)(33656002)(26005)(38100700002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qk56aTFrNjVRY3g0N1o3WitLTktieG1jc1BVUGp0K29XMGljR2Y1TkhUTjU5?=
 =?utf-8?B?YnJpbEtqQU12L3pjR3J5VGdsOVNTRXJ4YXpzQWtQbmRyQkVGRnliWjFlQU9B?=
 =?utf-8?B?Z084eFB5ZWZnYWdWbGNSM1hwQ3FZREd0SnpWOTZpVFlXaVo5U0NrdThBTXM5?=
 =?utf-8?B?Vzgza2trRnN2NGVnOTBjUXlYV2tmM0VMSXZLVDY0RUFYT21JOTNaZ1VHZkVr?=
 =?utf-8?B?Z0ZDdjNhV1UvUUJ3TDN5NWdESUdTcnZ6aWhJRktwWWtESk5ObmNHYWY4Rk9q?=
 =?utf-8?B?TW9sTFlFbVk4Qkg0bm8vaVpKTHRLank1dncvVFZNRzcyYWZqeHFBdVlkekpD?=
 =?utf-8?B?a3ZUNE5xNDJwaStybENxRjVjOEdObzJzSDk1S0dyMW5pcnRjU2ZNU0ZOKzB3?=
 =?utf-8?B?NXVHZHdyRlNuMXhtVUcvK2U5N1NlUzAvSjRlWHh0cDVINytnc1BLYmhaYnZs?=
 =?utf-8?B?OXVoNzRYdXhjbVpWUnM0blh5N00zRytmaVEvbUZyajJuNklyY25HNTgwVlV0?=
 =?utf-8?B?UTJWekw1Z1JoTFFwc29aS3cza3pTZkRES0JSVS9VbGpaalhXNDlxVXFqblpt?=
 =?utf-8?B?VDcwODA4SkNhL2dqSTEreXZ1QW5GaWhxM3VGd294ZnY5bUF3RHgwNjFBRTA2?=
 =?utf-8?B?K3d0anFyV0krOTU3Wi9FdmtuZGtXdjFJOWZDTmFFbzVrTTJrOFpDaWQxMW5H?=
 =?utf-8?B?U3NZZC80WFVoUW1jaE5CdnlwcWlyWTg0TGNjV3NzeVJUMm5uUXZlNGU2WEhq?=
 =?utf-8?B?cDVwbXFBRjlBNmRjd0t6TSs1ZDJuNURsdEVQaFFFbU95N0grNmlPc0pGNmJk?=
 =?utf-8?B?ZXJOTDlSSUNPa011L2NLKy9oSm9JUmFtclV3dVo1RE5mTTVZWW9RTk5ka3hM?=
 =?utf-8?B?ZUdjc1hqTW1ZSkRQTnlPUStsYVpHSjZZS2FCSjRvbXZWeHhDUllxYTgxaXJB?=
 =?utf-8?B?clZvVHBleTNOc3hrbXE2bVBVdC9uT1RtR0NQLzhOL2RiSFcxTlNieVV0bUxV?=
 =?utf-8?B?NVZGQjBHczQ4eG1vUXIvd2JqRHRRbmNFV3JMVkE5eTQ4djlGcHFObytWYVFN?=
 =?utf-8?B?TlZYZkFKN1RObHMyWTVDcUg2YmdWcVdiNVZNRFZmQmltMXZlbVBDUTFRaUQw?=
 =?utf-8?B?aFNRMU5GSjRnK2hndXNYYlpMRHpadVNSUHdEMlNjZDFaTENraEg1bEcvK0VI?=
 =?utf-8?B?dWc3RTZCQjBSSXdtUzdESWU2bDFSQytOeUExaWNyS09KMjFKbzJISFhKL3F5?=
 =?utf-8?B?eGlsVWwyWjRtdUFXK2Jud3NZUWNhY2ROdzgzZTNSK2JLNnd4SUhyTWxLQ2tG?=
 =?utf-8?B?dkJ0cnR3dnF5RDQ2aVV4K0JWRUVZR2YyTDFWckJpYjB0Zlk1Ry9vNFdtNXQ5?=
 =?utf-8?B?alhRY3JSdE9kY2JLbmJ1NUo5blVsZVlmYlFKMC9ETFY1MW9NOGxFeWxrRWRa?=
 =?utf-8?B?NmR3LzlDUFRDWGN3VUFNOTBuUUYwVm5RMHUrKzBuWnBidklaYm9XeHpaQjF6?=
 =?utf-8?B?ZXR0VW9NTk9hYnA3d3VZN3VUeU5HKytJOGp4NTNFM0w3SHdyT2xRa2Znakhv?=
 =?utf-8?B?UHZXVDFpNHFROXlhajRFcHB6LzZQdUVEK2lxN24zcmtiRHZMMnBDckJ4Wk0z?=
 =?utf-8?B?OVZUdkRVQjV1U09JQStqVHhxSFFMSlpHelVYWmV6aERFRVFLVWlSc2RLaW9F?=
 =?utf-8?B?cTRqS0VLZzhpeitLQU1uRmpteVpqdUxvYlZNU0hnNUdtWWtyOUZTb25TMXp2?=
 =?utf-8?B?amYzV0srQ1ZOSHE4K3FiemdSaGJrRyt4QWZRa1ZFUDhLVE5ScnpQSHF2MnBs?=
 =?utf-8?B?dk9QUGtoMkFjNXN0azc2dlJqb2VNak45VDN4RlhpbmplR01HMTFCWHJmREpF?=
 =?utf-8?B?N1g0ZUVHSUZHZjZsRjZ4NWdabG04dnE3NDRJclMvelQ3ektERDVNdXhMMGpX?=
 =?utf-8?B?UjcxZStRVWxNc2R5RDNZNkVya09RTDNBMEg0Si9nUDZmdFNlT0l6MDkycU01?=
 =?utf-8?B?NVg0NVY3T21NemhRNmtRMlJ1YjBlbURqT0J3NVRhS2hMOFk1Z0RhVHFkVHA0?=
 =?utf-8?B?eC84Z3NXRGdaZUNORkZKY2hINDcvaVBtbmVQSW1pY05zOGNkcDRLYzgxRFps?=
 =?utf-8?Q?YGGBHThkvQIpRjjzA5iKLuuh8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d45119a-f2e6-4108-f43a-08dbd4c1e6ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2023 18:49:07.1037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5hvdFOVKvU2VrwEW4eVBzskmNm+E8aATOeIyopV31RsihmvcEgpWvBC6ppcpITpIR4s6YfH0/wI2qdoDtVtXCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6894
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

PiB0aGUgb25seSBvdmVyaGVhZCB0byBtb2R1bGVzIG90aGVyIHRoYW4gbG9hZCB0aW1lIChpbmNs
dWRpbmcgdGhlIHJ1bnRpbWUgbGlua2luZykgaXMgdGhhdCBtb2R1bGVzIGNhbid0IHJlYWxpc3Rp
Y2FsbHkgYmUgbWFwcGVkIHVzaW5nIGxhcmdlIHBhZ2UgZW50cmllcy4NCg0KSWYgdGhlcmUgd2Vy
ZSBzb21lIHNpZ25pZmljYW50IHdpbiBmb3IgdXNpbmcgbGFyZ2UgcGFnZXMsIGNvdWxkbid0IHRo
ZQ0Ka2VybmVsIHByZS1hbGxvY2F0ZSBzb21lIDJNQiBwYWdlcyBpbiB0aGUgWy0yR2lCLDApIHJh
bmdlPyAgQm9vdCBwYXJhbWV0ZXINCmZvciBob3cgbWFueSAocGVyaGFwcyB0d28gZm9yIHNlcGFy
YXRlIGNvZGUvZGF0YSBwYWdlcykuIEZpcnN0IGZldyBsb2FkZWQNCm1vZHVsZXMgZ2V0IHRvIHVz
ZSB0aGF0IHNwYWNlIHVudGlsIGl0IGlzIGFsbCBnb25lLg0KDQpJdCB3b3VsZCBhbGwgYmUgcXVp
dGUgbWVzc3kgaWYgdGhvc2UgbW9kdWxlcyB3ZXJlIGxhdGVyIHVubG9hZGVkL3JlbG9hZGVkDQou
Li4gc28gdGhlcmUgd291bGQgaGF2ZSB0byBiZSBzb21lIGNvbXBlbGxpbmcgYmVuY2htYXJrcyB0
byBqdXN0aWZ5DQp0aGUgY29tcGxleGl0eS4NCg0KVGhhdCdzIHByb2JhYmx5IHdoeSBQZXRlciBz
YWlkICJjYW4ndCByZWFsaXN0aWNhbGx5Ii4NCg0KLVRvbnkNCg==
