Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43A87D5BA2
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 21:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344254AbjJXTkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 15:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343658AbjJXTkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 15:40:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E4A10A;
        Tue, 24 Oct 2023 12:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698176407; x=1729712407;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OOG3jDQt7ouWxKTbivIb7z7vJf2b5nJGnacdJtVq28Y=;
  b=iCLvurVakT768anmmrbs5E2PPHcoEIJDB+x6PuOrldfMHMXeSPq5ET/M
   liRCvgOCCCE0Yi+/5NPp0TDFIzPGBH8eUL+hjE9reBx8uUlx2ujAvsMh8
   lrKH46ERWM+amrHkVvrMl4d4vq1jW0XXtS2jvA4+fYcrIZsKyGcIEW5gu
   paMHnkM/GDixuanpa3pGgWOS6LVrpYuEbOeRa3ZTrGwcWHItQHH1+1DOV
   c+JEOjbiGtuV2YD9aQ9vy0JonLKAWXgxCQnL/Pq5xlxZkNdoObr84HErI
   9vLqh5j6PnV7RQwUfo0ardroFJ2nWKn96HHC8Q2q5YgpzztFGOXcerl/+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="372208432"
X-IronPort-AV: E=Sophos;i="6.03,248,1694761200"; 
   d="scan'208";a="372208432"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 12:40:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="787890339"
X-IronPort-AV: E=Sophos;i="6.03,248,1694761200"; 
   d="scan'208";a="787890339"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2023 12:40:06 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 24 Oct 2023 12:40:06 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 24 Oct 2023 12:40:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 24 Oct 2023 12:40:06 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 24 Oct 2023 12:40:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gw8J+TgpWZmbfBJ/VpM/byFDtlHF5qhtNVgGR9088gQDM/zgSHwQWUGX0+liyaTurTm/Zx6DqLFAgdQdz4De4fcaYpntCu89LO1tN6CMuxB3WHMqgIAurugwSUaM4UZpv7jhxv06nHXX3N32wT4WiAa7um41r08Qg6MufQMJjqUpv+CNKNyq1jHsgpB72F0OaiVASojm5brh5LxvhdaUkow+gGLbBkVL/JAf0xoU7Gov9iHZ3qY/ARsTp68sS7DE9pLY7yD4LHEDVCz6WkeCHkMfstiXL13pVal7ZWYcJz0fYuMyHBnzorGytdYTtCTeYIhPBkW8+MXXhCkMs7r9OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OOG3jDQt7ouWxKTbivIb7z7vJf2b5nJGnacdJtVq28Y=;
 b=J/4vlp29JMF20Aa2W9C/zeBO0qe5itr/uQPBFZe5kfDRGialK0xCowCoXmeq8QvAxUtSmqUQZbekEotnm3yeLvh7iFOuy+j1EPXxG6GzC3DNWwaFE21s5cdaJbry4xWUswr087a9oUzO27xxDljla4ml6sxd/GCHZsF/Im4ZTKuf1C2jqZia3BPPicllgKIayc5Anw1sRqWbk6bhIxxz9fP8lBCQiEABombtKNCSuSkQjipG7zn2HeqBchjoe2vXfiTxItpqSh7CBHG/kKpUR+xFljRt0TWIQI9EPJBfSxILl9Wgr04N2RAWtGPvbN/4uA2ao/SY0Ekuyl8wjAroVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MW4PR11MB7164.namprd11.prod.outlook.com (2603:10b6:303:212::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Tue, 24 Oct
 2023 19:40:02 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3ffb:89e2:2724:4c5]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3ffb:89e2:2724:4c5%2]) with mapi id 15.20.6907.025; Tue, 24 Oct 2023
 19:40:02 +0000
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
Thread-Index: AQHaBlFLwqOP8H6wikWc3HOPoHDmHbBYvyCAgABkX4CAAABOgIAAAoMAgAAE4QCAABeyAIAAA6LggAAJcoCAAAKuMA==
Date:   Tue, 24 Oct 2023 19:40:02 +0000
Message-ID: <SJ1PR11MB6083FE98A35C6BCF027B568CFCDFA@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
 <20231024-delay-verw-v2-1-f1881340c807@linux.intel.com>
 <20231024103601.GH31411@noisy.programming.kicks-ass.net>
 <20231024163515.aivo2xfmwmbmlm7z@desk>
 <20231024163621.GD40044@noisy.programming.kicks-ass.net>
 <20231024164520.osvqo2dja2xhb7kn@desk>
 <20231024170248.GE40044@noisy.programming.kicks-ass.net>
 <DD2F34A0-4F2F-4C8C-A634-7DBEF31C40F0@zytor.com>
 <SJ1PR11MB6083E3E2D35B30F4E40E8FE7FCDFA@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <5B8EB5F2-16A7-47BC-97FE-262ED0169DE3@zytor.com>
In-Reply-To: <5B8EB5F2-16A7-47BC-97FE-262ED0169DE3@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|MW4PR11MB7164:EE_
x-ms-office365-filtering-correlation-id: c03a3886-5052-4ffb-cf89-08dbd4c9040d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j0vBd8yKQRV3gWyLRea1kVXGWSiJeetmuaTPuyKI3FurChFyDT50OSG8/PcyXzaI1kq2TSPoaj6bbpY9kQIkfbciOYw8DrkpDwQS15F3E6XQZ0Ct2C1tb6Ow/34QtQuBgEx9QVyEpSu8gIkp/Famdwsz+qVhiH8jmXxDTMUMHE5ykE6TXR11DHHCU3B8PgSf5PZXpcoongRmRn00jvs+xBfPZwO5+yHAxNV96sY9WuZ4rYsW5YrAgtCy9zJAVQsDdTUVySPYvvZKYeTaP1F7EUza3K8cG44Ras5CaZOGrx5fTpRpM0mjT1dslO4YjocOn7amYislpygQgD4M0tig+Cpkhu4x0wFaTtY4ChwdJIMtxOXLRWVqhDE5fR4P6yxOyMqAdDJR4L5OcRx3s1eSam2taZK0+Eu2THxDtxqdtvqKtMfuh0fvXNiqDCXQXVHNnm2FXDZzUviGrPKNbj2HL9bbyTFS1JlwPiTWVudObAg7E0n7OhXwxq4689oZj2udmHHCpgfwZnc4YRKe2bEb2S14Abm1P5BAybfhBDJjLIPsvL47N48DoxTCUhZ4W05RtKp6uRo4XzPJoRuqejw5+Kaz6YeZ4Z7ZF/ONYbd5j7mDg/ZQbioF1lBtuL5DmSIY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(39860400002)(366004)(396003)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(4744005)(2906002)(7416002)(86362001)(6506007)(9686003)(71200400001)(26005)(110136005)(66476007)(66446008)(66946007)(64756008)(76116006)(478600001)(7696005)(33656002)(66556008)(82960400001)(38100700002)(122000001)(54906003)(316002)(5660300002)(8676002)(4326008)(8936002)(52536014)(38070700009)(41300700001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0dSaGNWTk01ODNyZVZWeGpkT2VtcTVIUU9vM0htc3V4aDdESnk0bDF3Z0pu?=
 =?utf-8?B?SjBNaFFDdVFQT1krZncvcjRLdnUyN29YMEFDeWxUcGJHY3F5WWlYcEowNXNV?=
 =?utf-8?B?ODIxK241amJ6ZmdOZDlZazBzZHVNK2pRdVkvdlE5V1hMSHE1QjF3eG1CR2lP?=
 =?utf-8?B?aEpXMXN1cU5CNXRheFRXbGY2Q282QnBtL3V5b3NqY0tjS0xWUGs1emlUb3FP?=
 =?utf-8?B?bmlVRE8reTdnMEswRmlFMjEvT04yTkNNd2tzNnVBREdLVzc4cUhWMUhzN3BI?=
 =?utf-8?B?eENYbitzc3hVQUprbWpDeDlJUDBoL3BhMWt3T1ZBT0puSUhneWEwVUg2eEE3?=
 =?utf-8?B?Z1dWNG1OV1czSEY0Y0Rwc3dYRGZGMndKQ2RoRjlpZ2UxclpzWTlwcE93NHRG?=
 =?utf-8?B?OUp6S28xd1VDRC9qM2toeWtDWEx6bytkWTE2ZHNpRTd6TkZmeTdCS3ZBWjMx?=
 =?utf-8?B?K2RieGdiN3dTL2o4N3E0NG1GSnBIdWE1NFdqQTc3WFRoR2lGNy90RzI2Z2VT?=
 =?utf-8?B?eTFyZG5oUFEvc0l1STgxbUltMVAwRWYxa0pISXFIRkhwVndTc3dHM1V0UHo3?=
 =?utf-8?B?dHYzeHBua2JZeDcrY01sUmF0S0FOOVVNY29CdHBnWVh1RWRwZkY0Z3NFMERn?=
 =?utf-8?B?YnhvS0lZREp4RFZZYjhTSDcyamhhd3kxSmNReW84czBWeDFvcGNPWmhGdTNC?=
 =?utf-8?B?WlZxS2IzS0c0SU1NZ3ZaMnVabVcrVkw5eE9nVEkzazBESFgwQ0h1NExwcWEy?=
 =?utf-8?B?OFBwUlFseGRxVUI3QlNxekV2RXRSUFVmSndOTHp0ZVVIUVVLUTIzUmg3a0M3?=
 =?utf-8?B?T0NDd3NzQVExc1ZOV1YrVW9SalZmWWhpVlBrRGZOS1ZPQnR0WVBDbTI1Z0Vk?=
 =?utf-8?B?ekMrZFhzeEpoNXpKUCs3ZzBvS3VOMkt0bGFVZzRXdlZFTGlzZjI3bkh2dUY4?=
 =?utf-8?B?ME9GUFlYZTFSdzFWT1lTVDUwTjdrME43Vk96WGxhMTkrSGtVV0lEZUhheFEr?=
 =?utf-8?B?Yk42bzJTajZPOHBJWExkRk12NXZ5WmJaVWhlRFZNRHMxUWtSQVF0TmROcDZV?=
 =?utf-8?B?clYvdzl3S1NpZkdtbnVIU21BYWZTUFVUbURpVENJQUdPL29yVnlxRm9LV0NI?=
 =?utf-8?B?bWFYQ210UkFFbjBKZ005RlJUQ210RlZnTTluK01rTHZVM1Z5QnlNWDBXcmsv?=
 =?utf-8?B?bHN4MmFvcUxYcUJnSUNGSk5yd1pEUXRNdWJyN3ZDdmRETXUrVEtxYm0wenNJ?=
 =?utf-8?B?cFoyZ3prTFhpTkcybUZsdmdoQXFqYitHQkcxWmYrTlRmU0p6cDdHcXJYaFJm?=
 =?utf-8?B?VjBBakE5THY1U3VEMlRBVHZGTXFUYXhIeWYzZTU5aWR4aHZZREhGVnZGWkpz?=
 =?utf-8?B?ZDR0dDVoRk04TGFoS050Z2d0VXRxdm10Vy9rNEJnQ0NTZUt3UkVYQkRkN0NX?=
 =?utf-8?B?d2xCdVFXa3RvRGxTTFRyK1ZHMnZ0NldWcGFyMkV2a2NBOUkyTDkxR21TK1F4?=
 =?utf-8?B?TnQ4YVhpd1o2WnovTjB6OFZtUmEyOG95VjJUWU0zR3NCamFrcDh4UWt2am1y?=
 =?utf-8?B?NUJKK3p6VHBaNXhjQkNVL09YVmlkai9kUEpwMW1sa3Y2dGFDR1pISXdWZVIy?=
 =?utf-8?B?ZlZtSXlOQnBSME5VWnVtcm81Q0ZaaW5tWFZQV3lmbEFzNm41c2p3OU40U2to?=
 =?utf-8?B?V3ZSaDFaWnR1TjU3UUNPUXpwTlFOa2w5RDdnSU1VNElzdnJkalVVWW1CZm5L?=
 =?utf-8?B?L3JTL00wdy9obStWa2UzOE1pZmh4VmZkbG5FYmJtTVpJMXRuQW9XSjlVRE50?=
 =?utf-8?B?THlCa2ttRkJkbEtKTUlBWUpQQU9wRjZySGZKc0RFdnVzRS9LSERzbkQ4UU9j?=
 =?utf-8?B?eFN0K0tMY3RoNDhNempsT3pvdWZSVDZSdW9tM3RLeHB1RVp0R1NOVnlrenJC?=
 =?utf-8?B?WDl4eUlQblVaWkI4clZTcVBZN1FUa0tqcDRscHMyOXg2U3RBVFhLamdkelNZ?=
 =?utf-8?B?b3RMdmcvb1gvSUVlcHdwdndhbHROWExxREExbHdMM3hNU0QwUkJlOUxCcG51?=
 =?utf-8?B?eHhpWC9iR0x3U2xSRXJzVGg4VzBSTGxyR2kvNlZnOFM1dlllSWJ1RXJxdm9X?=
 =?utf-8?Q?bxa/cS3Y/hFNU5aangemfaHmG?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c03a3886-5052-4ffb-cf89-08dbd4c9040d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2023 19:40:02.4525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MIvHWvDDdxfglfwag7HE5YV/xNMlyY07WpPJ77UQ6tFCoxLTA0rPbBmVGQo5cJIeRclOOz5XW6WvdSSmZWD+bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7164
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBTdXJlIGl0IGNvdWxkLCBidXQgaXQgd291bGQgbWVhbiB0aGUga2VybmVsIGlzIHNpdHRpbmcg
b24gYW4gYXZlcmFnZSBvZiA2IE1CIG9mIHVudXNhYmxlIG1lbW9yeS4gSXQgd291bGQgYWxzbyBt
ZWFuIHRoYXQgdW5sb2FkZWQgbW9kdWxlcyB3b3VsZCBjcmVhdGUgaG9sZXMgaW4gdGhhdCBtZW1v
cnkgd2hpY2ggd291bGQgaGF2ZSB0byBiZSBtYW5hZ2VkLg0KDQpPbiBteSBGZWRvcmEzOCBkZXNr
dG9wOg0KDQokIGxzbW9kIHwgYXdrICd7IGJ5dGVzICs9ICQyIH0gRU5EIHtwcmludCBieXRlcy8o
MTAyNCoxMDI0KX0nDQoyMS4wODU5DQoNCkxvdHMgbW9yZSB0aGFuIDZNQiBtZW1vcnkgYWxyZWFk
eSBlc3NlbnRpYWxseSBwaW5uZWQgYnkgbG9hZGVkIG1vZHVsZXMuDQoNCiQgaGVhZCAtMyAvcHJv
Yy9tZW1pbmZvDQpNZW1Ub3RhbDogICAgICAgNjU1MDczNDQga0INCk1lbUZyZWU6ICAgICAgICA1
Njc2MjMzNiBrQg0KTWVtQXZhaWxhYmxlOiAgIDYzMzU4NTUyIGtCDQoNClBpbm5pbmcgMjAgb3Ig
c28gTWJ5dGVzIGlzbid0IGdvaW5nIHRvIG1ha2UgYSBkZW50IGluIHRoYXQgZnJlZSBtZW1vcnku
DQoNCk1hbmFnaW5nIHRoZSBob2xlcyBmb3IgdW5sb2FkaW5nL3JlbG9hZGluZyBtb2R1bGVzIGFk
ZHMgc29tZSBjb21wbGV4aXR5IC4uLiBidXQgc2hvdWxkbid0IGJlIGF3ZnVsLg0KDQpJZiB0aGlz
IGNvZGUgbWFuYWdlZCBhdCBmaW5lciBncmFudWxhcml0eSB0aGFuICJwYWdlIiwgaXQgd291bGQg
c2F2ZSBzb21lIG1lbW9yeS4NCg0KJCBsc21vZCB8IHdjIC1sDQoxMjMNCg0KQWxsIHRob3NlIG1v
ZHVsZXMgcm91bmRpbmcgdGV4dC9kYXRhIHVwIHRvIDRLIGJvdW5kYXJpZXMgaXMgd2FzdGluZyBh
IGJ1bmNoIG9mIGl0Lg0KDQotVG9ueQ0KDQoNCg==
