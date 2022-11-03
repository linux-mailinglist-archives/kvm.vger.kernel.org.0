Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C92F618C15
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 23:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiKCWzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 18:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiKCWzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 18:55:04 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Nov 2022 15:55:03 PDT
Received: from esa6.hc3370-68.iphmx.com (esa6.hc3370-68.iphmx.com [216.71.155.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D8860F3
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 15:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1667516103;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=U3rvOF9jwrNTYPZmNxJdVmcazSrroHivgaB/3vV/WaE=;
  b=PLzENcivCVLvEiXXo4OXEMqQLRqHc2l8y5Drgv4jNS2d7gPWul81MGIa
   3jwbAigNSJ0Ogu37ZgwEkrY9PeRkLMh0hjZEfbd9yMeK7KF50yGIt1ula
   Cjtydxy3z9ZT9E414jPhyjo7ZhOL6NnXDWB78xRD6d9H4ndrtpvev7Pbz
   0=;
X-IronPort-RemoteIP: 104.47.73.176
X-IronPort-MID: 83742687
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:8wiUn6/mpr0c69BXy/LMDrUDrXmTJUtcMsCJ2f8bNWPcYEJGY0x3m
 DZNWmzQbPjcY2ehed5xbtvk/EgO7cDUzdBjGVZtpH08E34SpcT7XtnIdU2Y0wF+jCHgZBk+s
 5hBMImowOQcFCK0SsKFa+C5xZVE/fjUAOG6UKucYHsZqTZMEE8JkQhkl/MynrlmiN24BxLlk
 d7pqojUNUTNNwRcawr40Ire7kIx1BjOkGlA5AZnPKgQ5AS2e0Q9V/rzG4ngdxMUfaEMdgKKb
 76r5K20+Grf4yAsBruN+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+v9T2M4nQVVWk120c+VZk
 72hg3ASpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn9IBDJyCAWlvVbD09NqbDkkW6
 tpJFRwnTiutnv218OvjTNA9uNgseZyD0IM34hmMzBn/JNN+HdXmfP+P4tVVmjAtmspJAPDSI
 dIDbiZiZwjBZBsJPUoLDJU5n6GjgXyXnz9w8QrJ4/ZopTeIilUujtABM/KMEjCObexTklyVu
 STt+GPhDwtBHNee1SCE4jSngeqncSbTCNlNSOfmpqECbFu7xDZCEg0EfFyHp/zgm1SUZYxzM
 BdKw397xUQ13AnxJjXnZDW+qWKEtxg0WNdKFeA+rgaXxcL8+wuFC3IWZj9HZsYvuMI/SXotz
 FDht8/mASxHtLyTVG6H8bGVvXW+NEA9KW4EeD9BTgYf5dTniJ88gwiJTdt5FqOxyNrvFlnY0
 2DUhCsznbMeiYgMzarT1UzAmSylopTSZgo04BjHG2yi8wV1bZKkYIru7kLUhd5cLYPfRR+Kv
 HUCs8yf6v0eS5CLiCGJBu4KGdmB5e6CMTjWhlNHHJQ78TmpvXm5cuh4+DhhLUEvMdsBcCWvb
 1LLpQp54J5VIWvsbKlrbob3AMMvpYDjCtXmUP3ORtdSYoo3fw/v1ChqdFWL1ibokUwmjLs5E
 ZOad9u8S3ccFaljijGxQo8107YtwCAWymTUSpT2iR+g1NK2ZHyRD6sCN1+VRu885aKA5g7S9
 r53NcyDzFNaV/fzYzPe2Y8VMV0Oa3M8APjeqctMe/aDZAx7CmQoDdfQx68sf8pumKE9vv3P5
 W2wVlNwx134iXjGMkONcH8LQLHgR5FktlogIDche12v3hALZIau9q4afocffrQ98uFni/luQ
 JEtct6cKvdCUDLK/3Iad5aVhIBrchWmgSqPOCWoaSI1eI4mQQHVkvfnZhHm6CQDDWyxvNo3o
 JWp0w+dSp0GLyxvANvTYeCi03u+un8SnO80VEzNSvFIdUzqtoosICzrj+QrJNkMJA/YwT2y1
 gCKDBNeru7Iy6ct+t7Pl6GCrq+zHud+F1YcFG7ehZ61Kyzy4GWu28lDXfyOcDSbU3n7kJhOf
 s1QxvD4dfgYxlBDttIgF64xlP1godzyu7Vd0wJoWm3RaEimAa9hJX/A2tRTsqpKxflSvg7et
 l+zx+S28I6hYKvNeGP97iJ8Bghf/Zn4QgXv0Mk=
IronPort-HdrOrdr: A9a23:6jtNd6A7GUSAHQblHegPsceALOsnbusQ8zAXPh9KJCC9I/bzqy
 nxpp8mPEfP+U0ssHFJo6HiBEEZKUmsuKKdkrNhR4tKOzOW9FdATbsSp7cKpgeNJ8SQzJ876U
 4NSclD4ZjLfCBHZKXBkUaF+rQbsb+6GcmT7I+woUuFDzsaEp2IhD0JaDpzZ3cGIDWucqBJca
 Z0iPAmmxOQPVAsKuirDHgMWObO4/fRkoj9XBIADxk7rCGTkDKB8tfBYlml9yZbdwkK7aYp8G
 DDnQC8zL6kqeuHxhjV0HKWx4hKmeHm1sBICKW3+4gow3TX+0WVjbZaKvi/VQMO0aWSAZER4Z
 7xSiIbToZOArXqDyeISFXWqlDdOX0VmgLfIBej8AfeSIrCNXwH4oN69PxkmlGy0TtegPhslK
 1MxG6XrJxREFfJmzn8/cHBU1VwmlOzumdKq59bs5Vza/poVFZql/1owGpFVJMbWC7q4oEuF+
 djSMna+fZNaFufK3TUpHNmztCgVmk6Wk7ueDlIhuWFlzxN2HxpxUoRw8IS2n8G6ZImUpFBo+
 DJKL5hmr1CRtIfKah9GOACS82qDXGle2OFDEuCZVD8UK0XMXPErJD6pL0z+eGxYZQNiIA/nZ
 zQOWkowVLau3iefPFm8Kc7gSwlGl/NLAgF4vsul6RRq/n7WKfhNzGFRRQnj9agys9vcPHmZw
 ==
X-IronPort-AV: E=Sophos;i="5.96,135,1665460800"; 
   d="scan'208";a="83742687"
Received: from mail-mw2nam04lp2176.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.176])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Nov 2022 18:53:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CduRxvxcYWqiqj1FTuG4kdqyKWjsnBp/xdpUQa/pEUQpVeKvlevaR3Gz7HfPrIJ5auKOSSl1PFgFhGMkfTzdrFeD5GqyGnAWHKGxvPL5TGNWL1Qm321KwUg3frThxZmY0Xu0v2kx0tyNtB9dbntLe3HDa2KA9/sMB846mxspnOh64+SB1JmZznBNTDiAkNnZ+Xwz0xPFUbEVNPEUJuQLiC5fX0aEaz48p+Lvap8j3gWaFouUcw4q87teVSJsmIHDECbiVL+gAH7jFLgj6mdYaW44tzS7tUTenWu08QpTP8X63xT3+JuXDyVHZRLr0W7STGyCEw3Yp0uKXlMPRC48Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3rvOF9jwrNTYPZmNxJdVmcazSrroHivgaB/3vV/WaE=;
 b=Ps1ytmGkg3LZ7cnWndvcFBDs4NvwssSIvAr1seEmNdFzHV/ZDG+92YD3fQTulknOURSkArCnHc/bVWp5SpbhLL6ArC2rpWNJOzgpqWxU+AdqQRNC4YYSApxM6ZRenargac9c2Ehmn2AZKBykQUCfQPs6Ull5Hw3rE8qC+LtrOG0IFmnhipd05cJBrUkVIReVilWqvrrayp7W42QiONxjXqMv9NKeunPXPle8v9YT1IGg2Wz3yWGxXmA50a113/AtRJAFTd9QcXws/rwL7G9yihsUvAM/CRXt9RNU+IalSvDnP70gKHicpZIIlUVMa0bPjYFAAqXRlorKnPTWtp02zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3rvOF9jwrNTYPZmNxJdVmcazSrroHivgaB/3vV/WaE=;
 b=v2PJdLWRHa/OWqoYsGY+ZjjV6v2hoyia/ZW/vaP1N5QOd0tLZuEF5iiDIIk0vsQebc0yGGlqFrXS9XUlBZ+5fBbm81y8AHLpoiDGnDRLq/meVEb0LXrMjsi+9vvrZSvPRmclAwAz2CKk6sDTbswgI8KXYndbUQ9mMtMeYhR1FzI=
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by BY5PR03MB5155.namprd03.prod.outlook.com (2603:10b6:a03:218::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 22:53:55 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::1328:69bd:efac:4d44]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::1328:69bd:efac:4d44%3]) with mapi id 15.20.5769.026; Thu, 3 Nov 2022
 22:53:54 +0000
From:   Andrew Cooper <Andrew.Cooper3@citrix.com>
To:     Nathan Chancellor <nathan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Subject: KVM vs AMD: Re: [PATCH v3 48/59] x86/retbleed: Add SKL return thunk
Thread-Topic: KVM vs AMD: Re: [PATCH v3 48/59] x86/retbleed: Add SKL return
 thunk
Thread-Index: AQHYyPfjjpvUr6RS/U6flgiPXiYq5K4YIFkAgACzkICAAFvXgIAU7JsA
Date:   Thu, 3 Nov 2022 22:53:54 +0000
Message-ID: <08bbd7ab-049e-3cc3-f814-636669b856be@citrix.com>
References: <20220915111039.092790446@infradead.org>
 <20220915111147.890071690@infradead.org>
 <Y1HVZKW4o0KRsMtq@dev-arch.thelio-3990X>
 <Y1JsBQAhDFB2C0OE@hirez.programming.kicks-ass.net>
 <Y1K5D2u6pzXRQz6a@dev-arch.thelio-3990X>
In-Reply-To: <Y1K5D2u6pzXRQz6a@dev-arch.thelio-3990X>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR03MB3623:EE_|BY5PR03MB5155:EE_
x-ms-office365-filtering-correlation-id: e5d36d5f-ab63-47d9-59c9-08dabdee48a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qzgpS3Xp1h+H19ujMWVsFQqpsJi2eiAmjtCM3Na7EjObA4qopZgbX7jYOQ8yjQgsBtH+8PsSgYJ72sdPfw/kBYFvHFZAp+26ldqV90zF2Lb7aMANV9icH0BGQ1/kwqkqvkB5yXaKQMXQfhrfW5PnP2XrSmNAdYILI3pz2+dH+i1X2iBnIaiThiBhy6zo0Zz52F6Su/2Qy2wqycUZ463ueYByoNFffogpHHmsIQG0KDsOHqrHSVLsncbPdHjEgLxQX73TZGT5umyaNIGaxhRoyN+FxMU1a3EJxM4L9MwomBUaeWzploplc1YHuUYF9NPd5rWWwjpBZq9Alb5msjhAyUw1fQ2XLODtAPdiNheQfOcWKPsvr0DJZZ+BrrIWMMmfbkLpp2PpXaWDNo2orstk9FFVY4br0FoiCsK48DWhYHoSK5D91tkvoZtngThX2VUn3kF0TGs0ZO9wWF4zQIFxKTq//+QDpFrhqSbjDTM2UtSHnmP7v11aaUkk2LhlQpiLXDSQnPsNWMlcx6Nnq05P10/P0ed5vCzYd/oic8JoFWxxtzilOTzZmq5ao4oYzhoVJ8uTkuTq/mmE2/2ROFICh4dRAONFX6vOa7T8tQQXw9Cr4F8ixwk7+tgm6TRvLnlQGBvRH+4Ys+X6BBF05Vu0k8/Bz7cjREkEftv5mMOohMW+dd/nvKnuezXEZaUNXPJfZIqngTothmpm8GLPiSRhZikxpzuia05vg23Gs6zoV+AXtBKQ/Lu7w6zTIRjS/vmI26eBElxglQlo+wEdgvqDz1bHmzSA+GiEMEPvbgDS911jKQzpTZk5xcY6DRygiQIgI0Eaki8yW6GYcyPjiof6Bg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(366004)(346002)(396003)(136003)(451199015)(8676002)(36756003)(4326008)(478600001)(76116006)(91956017)(66556008)(6486002)(2616005)(66476007)(64756008)(186003)(5660300002)(38070700005)(83380400001)(7416002)(41300700001)(31696002)(2906002)(8936002)(86362001)(110136005)(316002)(66946007)(122000001)(71200400001)(82960400001)(66446008)(38100700002)(54906003)(31686004)(6512007)(26005)(6506007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NTdhd0cxa0hVTVFrRkNVaTVnL0ppV3ZFKzlteGdUVk9OMkhmcDA4bEZjWnRw?=
 =?utf-8?B?MVoyVkM5Z3kxaUJoa0FtUHJ5S1pkY3hMeUhESlNoOGEzeEpkbGJMSFkzYS9n?=
 =?utf-8?B?bWdhUHVCZEQwdVI3c0hsY1VWWG5nM0d1b3ZOWkxDT1doK01YRHd2YjQ2Wllw?=
 =?utf-8?B?U1pNa2lPa3VQZExQL0FlQ2xDT1NSU1d1SFJUU2JUQ3dGV1FPRnpIK3E0WEp6?=
 =?utf-8?B?ZllZZ3lpV2MzWDJkN2VqU04yVTk0ejUrOENVNjF5b3RwVFpVQklqcHpuMWVD?=
 =?utf-8?B?U0UrUlhJVDcyT2w3M2hndm1XelRkNWdvMWJ6SGVIZVM1c1plcFI5MXpVMjBh?=
 =?utf-8?B?dW1FRGsySkV5NzhYY0krKzlMY1VlemJtU29vbVRrdWJYNE5JYjNJRnJXejdn?=
 =?utf-8?B?VWcwL2FWVStacmdqV3JYd1orQURHN2l3cml5a3NhTm0yeDUwUzQ2UHdXZFlG?=
 =?utf-8?B?Mlh2VHFRTTJwN09BcVltMk12SmhJaWdjaUE0cG00bkZoRXBNWSs0OVFkbXhq?=
 =?utf-8?B?eFMreVY2NTE5T201blpwZVhhOUhEOVR2eXNmTnJzTVFwUDkxNXB6TDVybWkx?=
 =?utf-8?B?SFZMR2tPM1BpUnpmWGFLTDVPenZLNTQ1VjZYMTRlRnVrTGgycUsxK3NROXhr?=
 =?utf-8?B?OUR5UWJpa3RpVERnQUV6ZmZHdjhDUHlJcWEzNEtVV1M3b01TTGJKZXplUU44?=
 =?utf-8?B?bCtheFZqVmxaODJSTlZSekg2RXdpZmx2SWk2NEgzQ056djkwTjAweExaTFRk?=
 =?utf-8?B?L0Z0dlAwSVBpVGloaGwvaFhESUNCZzhFQXczajgyS2xrVVBQMk5OOXBVVkFK?=
 =?utf-8?B?UjBlbU92RWxHemk4dy9mUVpkWEpiRDBDTi9GcCt3M2N0bDh1V05rS3ZiRVdZ?=
 =?utf-8?B?bU9FbWNRMzBFWHpmVk1SS0hmTVMvdlVwa3J5YWhVQ3Z5S2wyNUVGV1RpOXJw?=
 =?utf-8?B?b3ovcm1pYmIzZ1VZT3I5Ui9qRWdlbVVPK2xvL04zakt4dE1BNzdqcWxtVlVT?=
 =?utf-8?B?bGx2TWtiQWVBekVoM1dDaEhXenJpVmVaZnlmK1F2RnVsTE9zUjdIYSt0VmhQ?=
 =?utf-8?B?OVVNeGlmZTZ5UTF6VnovUjdvdEtUM3dabm5HN2NraEhuOHVnUW9rdU5hQUlV?=
 =?utf-8?B?YlY5V08wV1oweHFhdFJsRE5sYzZ3UmRNYzk2R3FkenpSNXZzbWRFWVlzYnFr?=
 =?utf-8?B?dTNwOXBUWU10REZWczJad0RGSVpIYzVXRStHdk9sTS9xdm50bXl2L3lCS2Vy?=
 =?utf-8?B?Smc1dGN3cnNibGtaLzZSYVpwRkFIUWUyRmZTZnFVaUliUVQvMldaTXBnUFRo?=
 =?utf-8?B?Qzl4RHQ5M1FnT3lEaVF0dlpvRzVxanJld3N2N1pYTUI0OW1oNGd5RFh1M3Jn?=
 =?utf-8?B?a2tRSzlGNlUwSkdWYk1qcDlMSXdKL0JHVm54eFhYVE1SK09GSWIwVHYwK1lh?=
 =?utf-8?B?QUJXMHh0SE1kajhBb0liZWlNL25pTE9xQ3E3ZVFXUENGeldUQm95cE4vbFJN?=
 =?utf-8?B?UnVOVUJYRnlsQ3lMNFBrS0lodUpEQWMxdGtrT3FMQk1kNWZNSnRaK1oraVJY?=
 =?utf-8?B?WUszOUxqTjVrVFZ1RW1BZXFTUXlDZk1ucE1GYkV2WkZyQkRKdHFGVlR3YkRK?=
 =?utf-8?B?QWxQd0tYc3VSSkZNQ2xBMXFObXBMM25qai90R1Irb2xxZHlGZzZ2eE5jUWl0?=
 =?utf-8?B?Zmx2dGNFamtrZkFPYXRHUkFxVHFDSzZYcXNLWmpJWmNXWjBQWlVjaXNYTG95?=
 =?utf-8?B?WDZuNFkwa1JlTTdTZksvYnYyREREMUlIajlrZmdVeVljc1k3UVE2TWg3T2p3?=
 =?utf-8?B?SzlqRWpLamYrZkRSN2lxM2V6cG9RTXhUOG5uN2QycjlkN3ZaV2FyazB2V1pi?=
 =?utf-8?B?RWtEcUh3YVl1c3JBajNPWDJoeGZxVGN1cUMzNG9xMHZiUElVZ0x3OFBHOTNC?=
 =?utf-8?B?LzFwMDhUR0hTdkJKZ3VPOUpUMVYwSFY0OWJFc3pWRysxSUp4M1NwVGZWSTI1?=
 =?utf-8?B?Zkh3Q2dsWnlGcDQyUWNiUzFFd012MUVuY0RZM2xWRnBxT25TaEZZNjJwclZ6?=
 =?utf-8?B?TnJuelVnaXRVMkFpNjNHb2QzN2lOWTdUYzNsYkh5KzI5bEZndUlmWFhqei91?=
 =?utf-8?Q?B2vqnS1ZZeO+Jo2Ci+7kItT0v?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3024A09A4F45764F89AF8F551C23DF30@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5d36d5f-ab63-47d9-59c9-08dabdee48a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 22:53:54.4736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xcBNosny6JrDXPYzRNUAjFhyxRZSDVr5pc9w9+9VcqmTw/Izu8MOd40R56DbTfs6s0iexS5ApiRIPz0RA27GTGZsDmMON9WyO27BKe5P+d4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5155
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMjEvMTAvMjAyMiAxNjoyMSwgTmF0aGFuIENoYW5jZWxsb3Igd3JvdGU6DQo+IE9uIEZyaSwg
T2N0IDIxLCAyMDIyIGF0IDExOjUzOjA5QU0gKzAyMDAsIFBldGVyIFppamxzdHJhIHdyb3RlOg0K
Pj4gT24gVGh1LCBPY3QgMjAsIDIwMjIgYXQgMDQ6MTA6MjhQTSAtMDcwMCwgTmF0aGFuIENoYW5j
ZWxsb3Igd3JvdGU6DQo+Pj4gVGhpcyBjb21taXQgaXMgbm93IGluIC1uZXh0IGFzIGNvbW1pdCA1
ZDgyMTM4NjRhZGUgKCJ4ODYvcmV0YmxlZWQ6IEFkZA0KPj4+IFNLTCByZXR1cm4gdGh1bmsiKS4g
SSBqdXN0IGJpc2VjdGVkIGFuIGltbWVkaWF0ZSByZWJvb3Qgb24gbXkgQU1EIHRlc3QNCj4+PiBz
eXN0ZW0gd2hlbiBzdGFydGluZyBhIHZpcnR1YWwgbWFjaGluZSB3aXRoIFFFTVUgKyBLVk0gdG8g
aXQgKHNlZSB0aGUNCj4+PiBiaXNlY3QgbG9nIGJlbG93KS4gTXkgSW50ZWwgdGVzdCBzeXN0ZW1z
IGRvIG5vdCBzaG93IHRoaXMuDQo+Pj4gVW5mb3J0dW5hdGVseSwgSSBkbyBub3QgaGF2ZSBtdWNo
IG1vcmUgaW5mb3JtYXRpb24sIGFzIHRoZXJlIGFyZSBubyBsb2dzDQo+Pj4gaW4gam91cm5hbGN0
bCwgd2hpY2ggbWFrZXMgc2Vuc2UgYXMgdGhlIHJlYm9vdCBvY2N1cnMgaW1tZWRpYXRlbHkgYWZ0
ZXINCj4+PiBJIGhpdCB0aGUgZW50ZXIga2V5IGZvciB0aGUgUUVNVSBjb21tYW5kLg0KPj4+DQo+
Pj4gSWYgdGhlcmUgaXMgYW55IGZ1cnRoZXIgaW5mb3JtYXRpb24gSSBjYW4gcHJvdmlkZSBvciBw
YXRjaGVzIEkgY2FuIHRlc3QNCj4+PiBmb3IgZnVydGhlciBkZWJ1Z2dpbmcsIEkgYW0gbW9yZSB0
aGFuIGhhcHB5IHRvIGRvIHNvLg0KPj4gTW9vIDotKA0KPj4NCj4+IHlvdSBoYXBwZW4gdG8gaGF2
ZSBhIC5jb25maWcgZm9yIG1lPw0KPiBTdXJlIHRoaW5nLCBzb3JyeSBJIGRpZCBub3QgcHJvdmlk
ZSBpdCBpbiB0aGUgZmlyc3QgcGxhY2UhIEF0dGFjaGVkLiBJdA0KPiBoYXMgYmVlbiBydW4gdGhy
b3VnaCBsb2NhbG1vZGNvbmZpZyBmb3IgdGhlIHBhcnRpY3VsYXIgbWFjaGluZSBidXQgSQ0KPiBh
c3N1bWUgdGhlIGNvcmUgcGllY2VzIHNob3VsZCBzdGlsbCBiZSBwcmVzZW50Lg0KDQpGb2xsb3dp
bmcgdXAgZnJvbSBzb21lIGRlYnVnZ2luZyBvbiBJUkMuDQoNClRoZSBwcm9ibGVtIGlzIHRoYXQg
RklMTF9SRVRVUk5fQlVGRkVSIG5vdyBoYXMgYSBwZXItY3B1IHZhcmlhYmxlDQphY2Nlc3MsIGFu
ZCBBTUQgU1ZNIGhhcyBhIGZ1biBvcHRpbWlzYXRpb24gd2hlcmUgdGhlIFZNUlVOIGluc3RydWN0
aW9uDQpkb2Vzbid0IHN3YXAsIGFtb25nc3Qgb3RoZXIgdGhpbmdzLCAlZ3MuDQoNCnBlci1jcHUg
dmFyaWFibGVzIG9ubHkgYmVjb21lIHNhZmUgZm9sbG93aW5nDQp2bWxvYWQoX19zbWVfcGFnZV9w
YShzZC0+c2F2ZV9hcmVhKSk7IGluIHN2bV92Y3B1X2VudGVyX2V4aXQoKS4NCg0KR2l2ZW4gdGhh
dCByZXRibGVlZD1mb3JjZSBvdWdodCB0byB3b3JrIG9uIG5vbi1za3lsYWtlIGhhcmR3YXJlLCB0
aGUNCmFwcHJvcHJpYXRlIGZpeCBpcyB0byBtb3ZlIHRoZSBWTUxPQUQvVk1TQVZFJ3MgZG93biBp
bnRvIGFzbSBhbmQgcHV0DQp0aGVtIGFkamFjZW50IHRvIFZNUlVOLg0KDQpUaGlzIGFsc28gYWRk
cmVzc2VzIGFuIHVuZG9jdW1lbnRlZCBkZXBlbmRlbmN5IHdoZXJlIGl0cyBvbmx5IHRoZSBtZW1v
cnkNCmNsb2JiZXIgaW4gdm1sb2FkKCkgd2hpY2ggc3RvcHMgdGhlIGNvbXBpbGVyIG1vdmluZw0K
c3ZtX3ZjcHVfZW50ZXJfZXhpdCgpJ3MgY2FsY3VsYXRpb24gb2Ygc2QgaW50byBhbiB1bnNhZmUg
cG9zaXRpb24uDQoNCn5BbmRyZXcNCg==
