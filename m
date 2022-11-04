Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DDD619BA2
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 16:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiKDP3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 11:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbiKDP3d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 11:29:33 -0400
Received: from esa4.hc3370-68.iphmx.com (esa4.hc3370-68.iphmx.com [216.71.155.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D3BDE80;
        Fri,  4 Nov 2022 08:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1667575772;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UUHFzUtc7Cb0PEC0ZPXLSH3rg8uLgVqqPoA7y8qowus=;
  b=KQ6VMtc8PnVprNgw+PiP7cZUwDkx6uX1R86s9gi3GPUpbEESXbnxf688
   RlWZ7VC0FQCLDiRnpb2K7a/6Z+aemJ/Xz36wCkkWE7kfb1zxAPvRGD6wE
   rQ8ZSlMClWCgZ3LkdZHF0Y15454jnt0ykw8rJi459YIBCBiOJ4s0hTzZv
   U=;
X-IronPort-RemoteIP: 104.47.59.169
X-IronPort-MID: 86721719
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:/lYNtKxYwpmfJVho+nN6t+cLwSrEfRIJ4+MujC+fZmUNrF6WrkUGn
 GUXC2zVPPaDMWLwc4xxOYXk8koPvZaAnNE1TQQ6pCAxQypGp/SeCIXCJC8cHc8wwu7rFxs7s
 ppEOrEsCOhuExcwcz/0auCJQUFUjP3OHfykTbaeYUidfCc8IA85kxVvhuUltYBhhNm9Emult
 Mj75sbSIzdJ4RYtWo4vw//F+U0HUMja4mtC5AVnPawT5jcyqlFOZH4hDfDpR5fHatE88t6SH
 47r0Ly/92XFyBYhYvvNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ai87XAME0e0ZP4whlqvgqo
 Dl7WT5cfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQq2pYjqhljJBheAGEWxgp4KXFc8
 8dHIRxRVzaKufyS6pjgZ8lopu12eaEHPKtH0p1h5RfwKK98BLzmHeDN79Ie2yosjMdTG/qYf
 9AedTdkcBXHZVtIJ0sTD5U92uyvgxETcRUB8A7T+fVxvjmVlVIguFTuGIO9ltiibMNZhEuH4
 EnB+Hz0GEoyP92D0zuVtHmrg4cjmAurBt1ITeLhp5aGhnXP2isfBSQmU2GD+9WekkjuUs0GK
 EUtr39GQa8asRbDosPGdwW1vHOerDYdXdRKGuE34Q3LzbDbiy6fD3QERzhpa9E8ssIyAzsw2
 Tehg9ztFRRrsbuIVWia8LaE6z+/UQARLGkfdWoHQBED7t3Lvo4+lFTMQ8xlHarzicf6cRngk
 26iryUkgbgXy8kR2M2T4VfdnTuoqoPhSg8z+xWSUGW46A9weI+iYcqv81ezxepBKcCSCFKBs
 X4sn8mY8fBIDJeRmSjLS+IIdJmr//GENTfbjHZsEoMn+jDr/GSsFahI6S53IgFqL8MNY3nmf
 VfPsCtV5ZlOLD2ra7N6Z8S6DMFC5av/FNfjW+r8Y8ZOcN56dGev9SV/flWZmWXslEIxi6cXP
 ZadbNbqDHAGBKAhxz2zL88f2LktxggxwmTcQZ29xBOiuZKeZnrTVbACNECmYeUw7afCqwLQm
 /5dMMKNjRBYSuD/eCD/8IgPIFRMJn8+bbj0rNdabu7FJBd0HWgnI/7X3b4lPYdimsx9jODT4
 nyxRmdXz13zgHzcbwKQZRhLarz1Wo1khWkmJiFqNlGts1AmYYe15aIWa7M0cKMh+eglyuR7J
 9EMYNmoAflVTDnDvTMHYvHVoIVkdRmvrQOJMCesejI4b9hmShCh0tz8ZALz+SQNSCy+pMI9i
 7Sl2kXQRp9rbwluEcPfev+z51y2uncZlaR5WE6gCsFZf0P+8Y5rAzb8gv8+P4cHLhCr7jiE0
 i6IDhoC4+rAuYk49J/On6/sh5y0CeJgE0ccBHTH7be1KC3C92yi3adJVerOdjfYPEvv9aykZ
 +59wPb7P/kK2l1NtuJB/61DyKs/457jouFcxwE9RnHTNQ31W/VnP2WM2tRJuutV3LhFtACqW
 0WJvN5HJbGOP8CjG1kUTOY4Utm+OTgvsmG6xZwIzI/SvkebIJLvvZ1uAiSx
IronPort-HdrOrdr: A9a23:AlU1MKoIS5moOF5kJT1OJ8IaV5uIL9V00zEX/kB9WHVpm5Oj+v
 xGzc5w6farsl0ssSkb6Ku90KnpewK+yXbsibNhcItKLzOWwldAS7sSobcKogeQUREWk9Qw6U
 4OSdkYNDSdNzlHZIPBkXGF+rUbsZa6GcKT9IHjJh5WJGkEBZ2IrT0JczpzeXcGJjWucKBJcK
 Z0kfA3wgZIF052Uu2LQl0+G8TTrdzCk5zrJTQcAQQ81QWIhTS0rJbnDhmxxH4lInJy6IZn1V
 KAvx3y562lvf3+4ATbzXXv45Nfn8ak4sdfBfaLltMeJlzX+0aVjcVaKv6/VQIO0aSSAWUR4Z
 3xStAbToNOAkbqDyOISN3Wqk/dOXgVmibfIBSj8AbeSITCNU4H4ox69Mxkm1LimjQdVJsX6t
 M140uJ85VQFh/OhyL7+pzBUAxrjFO9pT44nfcUlGE3a/pWVFZ9l/1pwKpuKuZ3IAvqrIQ8VO
 V+BsDV4/hbNVuccnDCp2FqhNihRG46EBuKSlUL/pX96UkcoFlpi08DgMAPlHYJ85wwD5FC+u
 TfK6xt0LVDVNUfY65xDPoIBcG3FmvOSxTRN3/6GyWuKIgXf3bW75Ln6rQ84++nPJQO0ZspgZ
 zEFEhVsGYjEnieffFmHKc7hywlbF/NLggFkPsulqSRkoeMNIbDIGmEVE0kldemrrEWHtDbMs
 zDSq5rPw==
X-IronPort-AV: E=Sophos;i="5.96,137,1665460800"; 
   d="scan'208";a="86721719"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Nov 2022 11:29:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G4xETYtdlAVsv25iSuBhMda3ymhFgw11iCbQIIJv2pVShSKRDMeQwtK0hOUphX+0VzC7AvT920pSkRbo3AIAnA1R21rDwzQZhtYPRfSHLXjiHfOvlbtijFXOOC9A3ebrQIxKCI6LHuhJUHuZJaIZLFw8PAubhAbY1UoScz8PcGfyNVVlv/1gNTLnBsrH/A7JO4B7KUULIlouWVYhsAvclD3KKaCpRA3k+v9bg1xj3/e/FYO+E1h0uSLYTIiMb2P9pJ3sZOA7jWBgsmiADRf3zR+njaquJ9wgh9RoF0n9ppSYpkukd+5Py37LxPH5YBin7ZU04a7uckRUWvaHF5qp0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UUHFzUtc7Cb0PEC0ZPXLSH3rg8uLgVqqPoA7y8qowus=;
 b=kbvx8bxd3IGToTns7YGTGdGwazPPY83HayB73MF1epT2VeyqWapM3+f1zVcpoEAWmL5SAMSyvk+zXS7gHEXP3H0svG6CFch527nx/cdBN/rXkGSzZa3hQUy75nGtwTVnHfbGoAvvFL6XXS+/NqqgNz8mUoyHD7JQy4HeeRp4JZ0gUWqhSGdxvmYf21qmDiQfrpL7OjXpfEvGUqe1u0p76/gQz1XcB27RStgp7GRVZYP/GjNO/rmb3KmjDO8jGgmSadhH1fHYM4rQ7P3p1hVM6uDdE04THYu3jLZyNqBtzq43wU27Zpwkchj87Vn6gcpMfWC7+DtDFlq0TODUAQknrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UUHFzUtc7Cb0PEC0ZPXLSH3rg8uLgVqqPoA7y8qowus=;
 b=k4Vo/opHjPXXKg1sr3cKQfiYyCgSTQNXeoC/LxsrHIFpr0qHbgXTBxnOBXfKOBSDpJ7nLvUNwmKt716boSxTFS57WW57x3uqpo8SDg4GHAJocrFRYYnogM88rb3SY5XXJF0sMaEj96VWFHjcHinMBqgIxszNsPBNVjapsfU+ICE=
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by SN4PR03MB6735.namprd03.prod.outlook.com (2603:10b6:806:1ef::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 15:29:26 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::1328:69bd:efac:4d44]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::1328:69bd:efac:4d44%3]) with mapi id 15.20.5769.026; Fri, 4 Nov 2022
 15:29:26 +0000
From:   Andrew Cooper <Andrew.Cooper3@citrix.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Nathan Chancellor <nathan@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Johannes Wikner <kwikner@ethz.ch>,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Jann Horn <jannh@google.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Joao Moreira <joao.moreira@intel.com>,
        Joseph Nuzman <joseph.nuzman@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juergen Gross <jgross@suse.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: KVM vs AMD: Re: [PATCH v3 48/59] x86/retbleed: Add SKL return
 thunk
Thread-Topic: KVM vs AMD: Re: [PATCH v3 48/59] x86/retbleed: Add SKL return
 thunk
Thread-Index: AQHYyPfjjpvUr6RS/U6flgiPXiYq5K4YIFkAgACzkICAAFvXgIAV1N9kgAAt4YA=
Date:   Fri, 4 Nov 2022 15:29:25 +0000
Message-ID: <f571e404-e625-bae1-10e9-449b2eb4cbd8@citrix.com>
References: <20220915111039.092790446@infradead.org>
 <20220915111147.890071690@infradead.org>
 <Y1HVZKW4o0KRsMtq@dev-arch.thelio-3990X>
 <Y1JsBQAhDFB2C0OE@hirez.programming.kicks-ass.net>
 <Y1K5D2u6pzXRQz6a@dev-arch.thelio-3990X>
 <08bbd7ab-049e-3cc3-f814-636669b856be@citrix.com>
 <Y2UJPrgYTtKHblnh@hirez.programming.kicks-ass.net>
In-Reply-To: <Y2UJPrgYTtKHblnh@hirez.programming.kicks-ass.net>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR03MB3623:EE_|SN4PR03MB6735:EE_
x-ms-office365-filtering-correlation-id: dbbc7a8a-6b18-4cf8-5528-08dabe795b5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 41rm9L8JXbxP6IIvlPTu4iVbZOMKTWic+eL5HrJdR5UjB7I8tY+T1mnEgM1iqd+Yir/OOm2ABcm2pOsPT+Xm1uDAMMGYpjfsg4PtdSGIp0UuIPryV+i5d1EzOD1WFJyj29TOfU1ItVJNcN7IgE0+WSxsAeg1+s5ptqlHOkb2h9b56ln0jUM8wKDeloVwYgARHw6tl8nFkXyErqbP9xE/X+kHClOdj6+xDHAXIUC8aph2XGK0Cgilr5qDm+ekUycFr1G2qtSUbhyEDsLiZpnBTI7Jflx5RShRBrRoqkMx3mzZHoqlrX8iosP4TbcldeVKC6M4xJ/ZBVenZB14mgNAAJXUP/X2B0sHxbRDFyPjiRd309fRMuUNs3NRYCSQBTou1QOBd8/XpLM76UjQsNb2nH4WX+PUVNfP3+EalmPqmCp9zo6cAK+MnFqFK1waR5PoMIjG6ih+3n4kpDuzuV1zNzIZ0+0Q/h6xw3EyhTOkiMCLImGtDo2AqAY7DE/wCOzawCTgszZPUK9h1yMAV7pWwNuoL0HRjOPIekTI8BtsvDSJIMZjSNqRSRSQmmyaAIT7oDqDdeRDgaFpVSfQQuTYpIoGru8D9cL6JgvzREGmrKs6Hs0ANZmmCmWR9uE4iN1pFOCU+yMb8eKvP7MeTVuyKcPoRo8v02v6Dvchq2r023dUJqnUcKCOeLbv+58BCLZzCu7ZQVNfu1qn2q0z/eN4MCE7iK2CVyTLPJNgG3hYxJ3aNv1tmAvLVwo+Qq3nIMWA/zS97585Om923ykFjdkqsX3F57olKaCCaoNeUmeDTkhBEHGtdJ6TkX+i/P2G5qUX+lNFrAGGdpr1Yp0ZXWbOZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199015)(82960400001)(66899015)(36756003)(6506007)(54906003)(38100700002)(66556008)(2906002)(107886003)(5660300002)(7416002)(6486002)(8676002)(66446008)(76116006)(66476007)(64756008)(316002)(66946007)(4326008)(71200400001)(91956017)(122000001)(6916009)(41300700001)(31696002)(86362001)(38070700005)(8936002)(2616005)(478600001)(31686004)(53546011)(26005)(186003)(6512007)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmxGc0NEVVg5SklJbGpoN2NEbkVxM2h2bzducXVEN1FpU3poeWVvbnRYN2Zo?=
 =?utf-8?B?SWJyYnBkUTRMRGVJV2R2R0xGQlh2MFJKTTBQaUdXeGFLRVMvbmY5N1hTb0tk?=
 =?utf-8?B?TzNNUE5OWHJWS3dBK243Z3V0T2FzakhMbUs3djlFNkd0WlZscE9YdnNYdURt?=
 =?utf-8?B?c1pTdmhsdWNTckJkeFp1MVhjaXlOa0gyMHVyR0YwVTdFMmRCamU1eG1VL0RB?=
 =?utf-8?B?NTlRbnZiY1VDK0VlSWJ6UHpIMy9KOU9UWWZUa2RqZWJURHNTYlRWUmxIMmlo?=
 =?utf-8?B?QTBVaE1ISmZLZDN5NElhblY3TVRqUmpyT0dxeHhxNFgra2ZBbXNUdjYvQnU1?=
 =?utf-8?B?a1NBZnZYS1VuZUZxUnp0eFBBVTJrclg5L3lNU3BYTWVkb3hjaWQzOXNTWGNI?=
 =?utf-8?B?OXJLT0Y4bzlFTDhsOC9GY3VYTVdKWjM2VGUzTENycGVicnVyV0xVZTMrUjdZ?=
 =?utf-8?B?cHE1WXlWcmFMb3dac254Zkg0K3o1WnFkbFhGaXMxQVZ2V2hXcXpGY2NyeENu?=
 =?utf-8?B?dUZ3enpjakpiQW9tNExGMTlaby9SMkNxZjBOSXUwSkNaVkxybno3eVY4VXNX?=
 =?utf-8?B?MG1pdnozdHo0VUVoQXN1RWxaS3BaVy9oUVp4emN1VWZpajF4QkhsdU9OQ1Vk?=
 =?utf-8?B?NkloMXNZVXNqVGRYb2ZWc3dyakc4Y25YK1VWTTFnQnU4YnVYa0c1VWd0T2po?=
 =?utf-8?B?RkhnU2hTN3ZzY1VJbTJxU0hySEptTkUrbWJhQU0vejFwZWQ2TE8vQWhONEpB?=
 =?utf-8?B?cERGOTBRMFducUZwUHJlN3Z0bkV5Y0M5UjNFeDZqcnBBa0JyeS8wT0JLMmJu?=
 =?utf-8?B?MGpFakxKN3hGdVkvdjh0THNTalRXNDdhd0N1WG5VMTE2TnYxZCtWK2t6WUR6?=
 =?utf-8?B?bXFySzRmYUJ4MVJnWVZHUU1RMlplbThLVnAyNm1iY1lNMzJWRXE3VTFaa0pW?=
 =?utf-8?B?MXRlMTNyZjVjTDFNOXp6QnJuSnRyVHNmRnAvT2xpSUVvKzZpQTYydkVXR0hD?=
 =?utf-8?B?ckpjZFBIR09PckdVdkVrR3EvSjAwNmNacUhIbXl4SmNFTmtnQWt5MW9nWWdM?=
 =?utf-8?B?aDAyOHg2bmRlUUt3NGRMNDBKQ0RhMWQzbTRWWHBjeTk1UjBGOCtOMkloRUow?=
 =?utf-8?B?YkoyaTIzUHlYOU9OYVlCKzVNVWhWQUNxU1hYam9neFBDWUlKZnFwY1pvK29v?=
 =?utf-8?B?QlFZd3NIMldBT2xPb0l2MkRoekpiSmVpYUJpYWRhaGg0MTVBYld6UFpMaVdE?=
 =?utf-8?B?TVJpa0pVT3gyV1o2MUNWL1dMYWQyRURDZDRVUEhNTnllMzlTK1dGdmJ1ejZK?=
 =?utf-8?B?YXhpMCtZZDYwMnBodjdwNWYzdlQzZHlzOEc0RkxqWmFZR3lILzVlNjJoZTFv?=
 =?utf-8?B?L0ROeGR6NG5UOThWbGgxL0s3a2hNRFRMNitMOTlybHJBSTdOakNEMkc5LzBr?=
 =?utf-8?B?Y2gwWFhtMGhGdkx2R3RXbytmWmRSdXhPMFpGd29ZSm9oMFluY3FjaFluczZJ?=
 =?utf-8?B?ajNIcXFCVGZDcEVha0FPZDZCZmJsREt6UXVNWWltYVFSREI0WlpnMzREclo4?=
 =?utf-8?B?enFEKzkwbFZONXFkMjZ2MWEzR0VLb3Y2MEYwMDdzRi9CeXJIUEVsYWc4Nnp4?=
 =?utf-8?B?RUQ2M3Bqdk1rY3VTNVFPaEpSSEEwNUlvVXRoSWt4Ri9NdVJZUjM4QTc4UHVh?=
 =?utf-8?B?TFU0THJ2cVp0KzdJWm1ESTRBVWtaaEdkTi9OZHJvb1l5aENGcFVzZ2RhZWI3?=
 =?utf-8?B?RkNsNEVGSmJsbU0rZnF4M1BPdDFvMlQ5VXpMRkJWcTBjUk11OVBNNE1yb3VE?=
 =?utf-8?B?VmY3U1drNUI3NXRNcU9pc1VBdFFLYVlIVGE4UW5SMGg0eTh5TXVCUkhRZUNu?=
 =?utf-8?B?c0U1MW5kOHBaWGhsaE5keVQvTTNHNnNsZXFYT0JweXhxSDZ2VUx1cWFNM0FY?=
 =?utf-8?B?d3BzMVBQMXhzWmZDV0ZyWjdXbXJVOWYxRDcyanRQYmNLaGxwVndCZ3VBM2E4?=
 =?utf-8?B?OWJVNFkybFFremw5aGhTZkVFQ0U1VmJHYmZXMHJjcEt0dmxPT3FWZ0M2Y1R4?=
 =?utf-8?B?RzByMHpKQmJMeWFrTHkwY3VGeWVZanlGMFA0S0NDdnB4c1NYbnZaOHRNdXIy?=
 =?utf-8?Q?iR0VLM8D78ths2RJQBFkFh2H8?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6EC0683849A995478FF2E9097CF790D3@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbbc7a8a-6b18-4cf8-5528-08dabe795b5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 15:29:25.9288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aUoL2LoTfvz/BViPew6frGiFhhF8TkOqIOaNzoHwj+mOtH+NVYjJkoZti77VM1vHnzYZwY4NabidtdkM0ex2ytLlfVqq67KQMm/gWlxvaCw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR03MB6735
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMDQvMTEvMjAyMiAxMjo0NCwgUGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+IE9uIFRodSwgTm92
IDAzLCAyMDIyIGF0IDEwOjUzOjU0UE0gKzAwMDAsIEFuZHJldyBDb29wZXIgd3JvdGU6DQo+PiBP
biAyMS8xMC8yMDIyIDE2OjIxLCBOYXRoYW4gQ2hhbmNlbGxvciB3cm90ZToNCj4+PiBPbiBGcmks
IE9jdCAyMSwgMjAyMiBhdCAxMTo1MzowOUFNICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4+Pj4gT24gVGh1LCBPY3QgMjAsIDIwMjIgYXQgMDQ6MTA6MjhQTSAtMDcwMCwgTmF0aGFuIENo
YW5jZWxsb3Igd3JvdGU6DQo+Pj4+PiBUaGlzIGNvbW1pdCBpcyBub3cgaW4gLW5leHQgYXMgY29t
bWl0IDVkODIxMzg2NGFkZSAoIng4Ni9yZXRibGVlZDogQWRkDQo+Pj4+PiBTS0wgcmV0dXJuIHRo
dW5rIikuIEkganVzdCBiaXNlY3RlZCBhbiBpbW1lZGlhdGUgcmVib290IG9uIG15IEFNRCB0ZXN0
DQo+Pj4+PiBzeXN0ZW0gd2hlbiBzdGFydGluZyBhIHZpcnR1YWwgbWFjaGluZSB3aXRoIFFFTVUg
KyBLVk0gdG8gaXQgKHNlZSB0aGUNCj4+Pj4+IGJpc2VjdCBsb2cgYmVsb3cpLiBNeSBJbnRlbCB0
ZXN0IHN5c3RlbXMgZG8gbm90IHNob3cgdGhpcy4NCj4+Pj4+IFVuZm9ydHVuYXRlbHksIEkgZG8g
bm90IGhhdmUgbXVjaCBtb3JlIGluZm9ybWF0aW9uLCBhcyB0aGVyZSBhcmUgbm8gbG9ncw0KPj4+
Pj4gaW4gam91cm5hbGN0bCwgd2hpY2ggbWFrZXMgc2Vuc2UgYXMgdGhlIHJlYm9vdCBvY2N1cnMg
aW1tZWRpYXRlbHkgYWZ0ZXINCj4+Pj4+IEkgaGl0IHRoZSBlbnRlciBrZXkgZm9yIHRoZSBRRU1V
IGNvbW1hbmQuDQo+Pj4+Pg0KPj4+Pj4gSWYgdGhlcmUgaXMgYW55IGZ1cnRoZXIgaW5mb3JtYXRp
b24gSSBjYW4gcHJvdmlkZSBvciBwYXRjaGVzIEkgY2FuIHRlc3QNCj4+Pj4+IGZvciBmdXJ0aGVy
IGRlYnVnZ2luZywgSSBhbSBtb3JlIHRoYW4gaGFwcHkgdG8gZG8gc28uDQo+Pj4+IE1vbyA6LSgN
Cj4+Pj4NCj4+Pj4geW91IGhhcHBlbiB0byBoYXZlIGEgLmNvbmZpZyBmb3IgbWU/DQo+Pj4gU3Vy
ZSB0aGluZywgc29ycnkgSSBkaWQgbm90IHByb3ZpZGUgaXQgaW4gdGhlIGZpcnN0IHBsYWNlISBB
dHRhY2hlZC4gSXQNCj4+PiBoYXMgYmVlbiBydW4gdGhyb3VnaCBsb2NhbG1vZGNvbmZpZyBmb3Ig
dGhlIHBhcnRpY3VsYXIgbWFjaGluZSBidXQgSQ0KPj4+IGFzc3VtZSB0aGUgY29yZSBwaWVjZXMg
c2hvdWxkIHN0aWxsIGJlIHByZXNlbnQuDQo+PiBGb2xsb3dpbmcgdXAgZnJvbSBzb21lIGRlYnVn
Z2luZyBvbiBJUkMuDQo+Pg0KPj4gVGhlIHByb2JsZW0gaXMgdGhhdCBGSUxMX1JFVFVSTl9CVUZG
RVIgbm93IGhhcyBhIHBlci1jcHUgdmFyaWFibGUNCj4+IGFjY2VzcywgYW5kIEFNRCBTVk0gaGFz
IGEgZnVuIG9wdGltaXNhdGlvbiB3aGVyZSB0aGUgVk1SVU4gaW5zdHJ1Y3Rpb24NCj4+IGRvZXNu
J3Qgc3dhcCwgYW1vbmdzdCBvdGhlciB0aGluZ3MsICVncy4NCj4+DQo+PiBwZXItY3B1IHZhcmlh
YmxlcyBvbmx5IGJlY29tZSBzYWZlIGZvbGxvd2luZw0KPj4gdm1sb2FkKF9fc21lX3BhZ2VfcGEo
c2QtPnNhdmVfYXJlYSkpOyBpbiBzdm1fdmNwdV9lbnRlcl9leGl0KCkuDQo+Pg0KPj4gR2l2ZW4g
dGhhdCByZXRibGVlZD1mb3JjZSBvdWdodCB0byB3b3JrIG9uIG5vbi1za3lsYWtlIGhhcmR3YXJl
LCB0aGUNCj4+IGFwcHJvcHJpYXRlIGZpeCBpcyB0byBtb3ZlIHRoZSBWTUxPQUQvVk1TQVZFJ3Mg
ZG93biBpbnRvIGFzbSBhbmQgcHV0DQo+PiB0aGVtIGFkamFjZW50IHRvIFZNUlVOLg0KPj4NCj4+
IFRoaXMgYWxzbyBhZGRyZXNzZXMgYW4gdW5kb2N1bWVudGVkIGRlcGVuZGVuY3kgd2hlcmUgaXRz
IG9ubHkgdGhlIG1lbW9yeQ0KPj4gY2xvYmJlciBpbiB2bWxvYWQoKSB3aGljaCBzdG9wcyB0aGUg
Y29tcGlsZXIgbW92aW5nDQo+PiBzdm1fdmNwdV9lbnRlcl9leGl0KCkncyBjYWxjdWxhdGlvbiBv
ZiBzZCBpbnRvIGFuIHVuc2FmZSBwb3NpdGlvbi4NCj4gU28sIGFzaWRlIGZyb20gd2FzdGluZyB0
aGUgZW50aXJlIG1vcm5pbmcgb24gcmVzdXNjaXRhdGluZyBteSBBTUQNCj4gSW50ZXJsYWdvcywg
SSBlbmRlZCB1cCB3aXRoIHRoZSBiZWxvdyBwYXRjaCB3aGljaCBzZWVtcyB0byB3b3JrLg0KPg0K
PiBOb3QgYmVpbmcgYSB2aXJ0IHBlcnNvbiwgSSdtIHN1cmUgSSd2ZSBtZXNzZWQgdXAgc29tZXRo
aW5nLCBwbGVhc2UNCj4gYWR2aXNlLg0KPg0KPiAtLS0NCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2t2bS9zdm0vc3ZtLmMgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+IGluZGV4IDU4ZjAwNzdk
OTM1Ny4uZjdlZTFlZWRhY2ZlIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5j
DQo+ICsrKyBiL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMNCj4gQEAgLTM5MjksMTEgKzM5MjksOCBA
QCBzdGF0aWMgbm9pbnN0ciB2b2lkIHN2bV92Y3B1X2VudGVyX2V4aXQoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1KQ0KPiAgCQkgKiB0aGUgc3RhdGUgZG9lc24ndCBuZWVkIHRvIGJlIGNvcGllZCBiZXR3
ZWVuIHZtY2IwMSBhbmQNCj4gIAkJICogdm1jYjAyIHdoZW4gc3dpdGNoaW5nIHZtY2JzIGZvciBu
ZXN0ZWQgdmlydHVhbGl6YXRpb24uDQo+ICAJCSAqLw0KPiAtCQl2bWxvYWQoc3ZtLT52bWNiMDEu
cGEpOw0KPiAtCQlfX3N2bV92Y3B1X3J1bih2bWNiX3BhLCAodW5zaWduZWQgbG9uZyAqKSZ2Y3B1
LT5hcmNoLnJlZ3MpOw0KPiAtCQl2bXNhdmUoc3ZtLT52bWNiMDEucGEpOw0KPiAtDQo+IC0JCXZt
bG9hZChfX3NtZV9wYWdlX3BhKHNkLT5zYXZlX2FyZWEpKTsNCj4gKwkJX19zdm1fdmNwdV9ydW4o
dm1jYl9wYSwgKHVuc2lnbmVkIGxvbmcgKikmdmNwdS0+YXJjaC5yZWdzLA0KPiArCQkJICAgICAg
IHN2bS0+dm1jYjAxLnBhLCBfX3NtZV9wYWdlX3BhKHNkLT5zYXZlX2FyZWEpKTsNCj4gIAl9DQo+
ICANCj4gIAlndWVzdF9zdGF0ZV9leGl0X2lycW9mZigpOw0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94
ODYva3ZtL3N2bS9zdm0uaCBiL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmgNCj4gaW5kZXggNmE3Njg2
YmY2OTAwLi4yYTAzOGRlZjdhYzcgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9zdm0vc3Zt
LmgNCj4gKysrIGIvYXJjaC94ODYva3ZtL3N2bS9zdm0uaA0KPiBAQCAtNjg0LDYgKzY4NCw3IEBA
IHZvaWQgc2V2X2VzX3VubWFwX2doY2Ioc3RydWN0IHZjcHVfc3ZtICpzdm0pOw0KPiAgLyogdm1l
bnRlci5TICovDQo+ICANCj4gIHZvaWQgX19zdm1fc2V2X2VzX3ZjcHVfcnVuKHVuc2lnbmVkIGxv
bmcgdm1jYl9wYSk7DQo+IC12b2lkIF9fc3ZtX3ZjcHVfcnVuKHVuc2lnbmVkIGxvbmcgdm1jYl9w
YSwgdW5zaWduZWQgbG9uZyAqcmVncyk7DQo+ICt2b2lkIF9fc3ZtX3ZjcHVfcnVuKHVuc2lnbmVk
IGxvbmcgdm1jYl9wYSwgdW5zaWduZWQgbG9uZyAqcmVncywNCj4gKwkJICAgIHVuc2lnbmVkIGxv
bmcgZ3Vlc3Rfdm1jYl9wYSwgdW5zaWduZWQgbG9uZyBob3N0X3ZtY2JfcGEpOw0KPiAgDQo+ICAj
ZW5kaWYNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9zdm0vdm1lbnRlci5TIGIvYXJjaC94
ODYva3ZtL3N2bS92bWVudGVyLlMNCj4gaW5kZXggMDllYWNmMTlkNzE4Li41MGYyMDBmN2I3NzMg
MTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9zdm0vdm1lbnRlci5TDQo+ICsrKyBiL2FyY2gv
eDg2L2t2bS9zdm0vdm1lbnRlci5TDQo+IEBAIC0zMiw4ICszMiwxMCBAQA0KPiAgDQo+ICAvKioN
Cj4gICAqIF9fc3ZtX3ZjcHVfcnVuIC0gUnVuIGEgdkNQVSB2aWEgYSB0cmFuc2l0aW9uIHRvIFNW
TSBndWVzdCBtb2RlDQo+IC0gKiBAdm1jYl9wYToJdW5zaWduZWQgbG9uZw0KPiAtICogQHJlZ3M6
CXVuc2lnbmVkIGxvbmcgKiAodG8gZ3Vlc3QgcmVnaXN0ZXJzKQ0KPiArICogQHZtY2JfcGE6CQl1
bnNpZ25lZCBsb25nDQo+ICsgKiBAcmVnczoJCXVuc2lnbmVkIGxvbmcgKiAodG8gZ3Vlc3QgcmVn
aXN0ZXJzKQ0KPiArICogQGd1ZXN0X3ZtY2JfcGE6CXVuc2lnbmVkIGxvbmcNCj4gKyAqIEBob3N0
X3ZtY2JfcGE6CXVuc2lnbmVkIGxvbmcNCj4gICAqLw0KPiAgU1lNX0ZVTkNfU1RBUlQoX19zdm1f
dmNwdV9ydW4pDQo+ICAJcHVzaCAlX0FTTV9CUA0KPiBAQCAtNTEsOSArNTMsMTggQEAgU1lNX0ZV
TkNfU1RBUlQoX19zdm1fdmNwdV9ydW4pDQo+ICAJLyogU2F2ZSBAcmVncy4gKi8NCj4gIAlwdXNo
ICVfQVNNX0FSRzINCj4gIA0KPiArCS8qIFNhdmUgaG9zdF92bWNiX3BhICovDQo+ICsJcHVzaCAl
X0FTTV9BUkc0DQo+ICsNCj4gKwkvKiBTYXZlIGd1ZXN0X3ZtY2JfcGEgKi8NCj4gKwlwdXNoICVf
QVNNX0FSRzMNCj4gKw0KPiAgCS8qIFNhdmUgQHZtY2IuICovDQo+ICAJcHVzaCAlX0FTTV9BUkcx
DQo+ICANCj4gKwkvKiBTYXZlIGd1ZXN0X3ZtY2JfcGEgKi8NCj4gKwlwdXNoICVfQVNNX0FSRzMN
Cj4gKw0KPiAgCS8qIE1vdmUgQHJlZ3MgdG8gUkFYLiAqLw0KPiAgCW1vdiAlX0FTTV9BUkcyLCAl
X0FTTV9BWA0KPiAgDQo+IEBAIC03NSwxNSArODYsMjkgQEAgU1lNX0ZVTkNfU1RBUlQoX19zdm1f
dmNwdV9ydW4pDQo+ICAJbW92IFZDUFVfUjE1KCVfQVNNX0FYKSwgJXIxNQ0KPiAgI2VuZGlmDQo+
ICANCj4gKwkvKiBQT1AgYW5kIFZNTE9BRCBAZ3Vlc3Rfdm1jYjAxX3BhICovDQo+ICsJcG9wICVf
QVNNX0FYDQo+ICsxOgl2bWxvYWQgJV9BU01fQVgNCj4gKzI6DQo+ICAJLyogIlBPUCIgQHZtY2Ig
dG8gUkFYLiAqLw0KPiAgCXBvcCAlX0FTTV9BWA0KPiAgDQo+ICAJLyogRW50ZXIgZ3Vlc3QgbW9k
ZSAqLw0KPiAgCXN0aQ0KPiAgDQo+IC0xOgl2bXJ1biAlX0FTTV9BWA0KPiArMzoJdm1ydW4gJV9B
U01fQVgNCj4gKzQ6DQo+ICsJY2xpDQo+ICANCj4gLTI6CWNsaQ0KPiArCS8qIFBPUCBhbmQgVk1T
QVZFIEBndWVzdF92bWNiMDFfcGEgKi8NCj4gKwlwb3AgJV9BU01fQVgNCj4gKzU6CXZtc2F2ZSAl
X0FTTV9BWA0KPiArNjoNCj4gKwkvKiBQT1AgYW5kIFZNTE9BRCBAaG9zdF92bWNiMDFfcGEgKi8N
Cj4gKwlwb3AgJV9BU01fQVgNCj4gKzc6CXZtbG9hZCAlX0FTTV9BWA0KPiArODoNCj4gKwkvKiBO
b3cgaG9zdCAlR1MgaXMgbGl2ZSAqLw0KPiAgDQo+ICAjaWZkZWYgQ09ORklHX1JFVFBPTElORQ0K
PiAgCS8qIElNUE9SVEFOVDogU3R1ZmYgdGhlIFJTQiBpbW1lZGlhdGVseSBhZnRlciBWTS1FeGl0
LCBiZWZvcmUgUkVUISAqLw0KPiBAQCAtMTYwLDExICsxODUsMjYgQEAgU1lNX0ZVTkNfU1RBUlQo
X19zdm1fdmNwdV9ydW4pDQo+ICAJcG9wICVfQVNNX0JQDQo+ICAJUkVUDQo+ICANCj4gLTM6CWNt
cGIgJDAsIGt2bV9yZWJvb3RpbmcNCj4gKzEwOgljbXBiICQwLCBrdm1fcmVib290aW5nDQo+ICAJ
am5lIDJiDQo+ICAJdWQyDQo+ICANCj4gLQlfQVNNX0VYVEFCTEUoMWIsIDNiKQ0KPiArMzA6CWNt
cGIgJDAsIGt2bV9yZWJvb3RpbmcNCj4gKwlqbmUgNGINCj4gKwl1ZDINCj4gKw0KPiArNTA6CWNt
cGIgJDAsIGt2bV9yZWJvb3RpbmcNCj4gKwlqbmUgNmINCj4gKwl1ZDINCj4gKw0KPiArNzA6CWNt
cGIgJDAsIGt2bV9yZWJvb3RpbmcNCj4gKwlqbmUgOGINCj4gKwl1ZDINCj4gKw0KPiArCV9BU01f
RVhUQUJMRSgxYiwgMTBiKQ0KPiArCV9BU01fRVhUQUJMRSgzYiwgMzBiKQ0KPiArCV9BU01fRVhU
QUJMRSg1YiwgNTBiKQ0KPiArCV9BU01fRVhUQUJMRSg3YiwgNzBiKQ0KDQpGb2xsb3dpbmcgdXAg
YWdhaW4gZnJvbSBJUkMuwqAgVGhpcyAjVUQgaGFuZGxpbmcgaXMgcHJlLWV4aXN0aW5nbHkgYnJv
a2VuLg0KDQpCZXR3ZWVuIHRoZSB0d28gVk1MT0FEcywgbm8gZXhjZXB0aW9ucyBhcmUgc2FmZS7C
oCBwYXJhbm9pZF9lbnRyeSBjYW4NCmNvcGUgd2l0aCAlZ3MuYmFzZSBiZWluZyB3cm9uZyAoaWYg
I1VEIHdhcyBwYXJhbm9pZCwgYnV0IGl0IGlzbid0KSwgYnV0DQpub3RoaW5nIGNhbiBkZWFsIHdp
dGggJXRyIGJlaW5nIHdyb25nIGZvciBJU1QgdmVjdG9ycy4NCg0KQnV0IHRoYXQncyBmaW5lIGJl
Y2F1c2Ugd2UncmUgaW4gYSBHSUY9MCByZWdpb24gYW55d2F5IGFuZCBub3QgZXZlbiBOTUlzDQpj
YW4gaGl0LsKgIChXaGV0aGVyIFNNSXMgY2FuIGhpdCBpcyBtb2RlbCBzcGVjaWZpYywgYnV0IGlm
IFJTTSBjb3JydXB0cw0KRUZFUi5TVk1FLCB0aGVuIGl0cyBnYW1lIG92ZXIgYW55d2F5KS4NCg0K
fkFuZHJldw0K
