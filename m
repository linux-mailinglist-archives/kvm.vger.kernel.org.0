Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D556265CC
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 01:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbiKLAIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 19:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiKLAIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 19:08:19 -0500
Received: from esa3.hc3370-68.iphmx.com (esa3.hc3370-68.iphmx.com [216.71.145.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CA425C71;
        Fri, 11 Nov 2022 16:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1668211696;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XlcveaUfg4k/L1F6HOicWivuulVFOJ2lelPYQ7LoIh8=;
  b=Q1jjDBIvJ4QwQpkK1RYKo82ziVOomCDFnxLSDPlz3NKDpbetS8KH2XF8
   VM7KGLiJIu1rP1EUkWKvRW7yTQagIHfA4DxivqRi3ge9JkcArgF5x+RbA
   VXhPk4VMZimRRHEyNnwT3OAsBaODM6mB/3dKl2n4paPhxBIdyjnZX8LVF
   c=;
X-IronPort-RemoteIP: 104.47.55.170
X-IronPort-MID: 84673819
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:XMx1y6Bz6q9E6RVW/17jw5YqxClBgxIJ4kV8jS/XYbTApDh012ZUy
 jdLDzuFOv/YMzf1et0lPdy380gF6sODzoRrQQY4rX1jcSlH+JHPbTi7wuUcHAvJd5GeExg3h
 yk6QoOdRCzhZiaE/n9BCpC48T8nk/nNHuCnYAL9EngZbRd+Tys8gg5Ulec8g4p56fC0GArIs
 t7pyyHlEAbNNwVcbyRFtcpvlDs15K6o4WpB5wRkDRx2lAS2e0c9Xcp3yZ6ZdxMUcqEMdsamS
 uDKyq2O/2+x13/B3fv8z94X2mVTKlLjFVDmZkh+AsBOsTAbzsAG6Y4pNeJ0VKtio27hc+ada
 jl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CA6IoKvn3bEmp1T4E8K0YIwxMowBWpjr
 fUkDzUGTDuKvee5xayRRbw57igjBJGD0II3nFhFlGucJ9B2BJfJTuPN+MNS2yo2ioZWB/HCa
 sEFaD1pKhPdfxlIPVRRA5U79AuqriCnL3sE9xTI+OxuvDC7IA9ZidABNPL8fNCQSNoTtUGfv
 m/cpEzyAw0ANczZwj2Amp6prr+Tw3ygCNtDfFG+3s9Si0Osw3c8MwwPc3SBp/izq3eZZOsKf
 iT4/QJr98De7neDTsH0dw+pvHme+BUbXrJ4C+Am5Ruf4qvS7RyQCmUNQnhGctNOnNc8Qjo41
 1mIt8nkCTxmrPueTnf13qeVq2j0PSk9LGkeaCtCRgwAi/HnoYcunlfMQ8xlHaqdkNL4A3fzz
 iqMoSx4gK8c5eYbh/uT/l3dhT+o4J/TQWYd5RvSdnyq4xk/Z4O/YYGsr1/B4p5oMImdXnGFv
 X4Zh9KZ6uEeS52A/ASIQeMCG5mz6vqFOSGaillqd7Er7xyk/3+ue9AW7DwWDEtgLMtCeTbve
 0LVkQdQ4oJDenqscaJzJYm2DqwC1qXpE9bufv/TadVKb956cwrv1CJje0+WmXzsmU4EkKcjN
 JPdesGpZUv2EoxixTuyAu0bgbkiw3lkwXuJHM+jiRO6zbCZeXiZD68fN0eDZfw466XCpxjJ9
 9FYNI2BzBA3vPDCXxQ7OLU7dTgiRUXXz7iswyCLXoZv+jZbJVw=
IronPort-HdrOrdr: A9a23:IB+A3qDMjKC9ISnlHeiCsseALOsnbusQ8zAXPh9KJCC9I/bzqy
 nxpp8mPEfP+U0ssHFJo6HiBEEZKUmsuaKdkrNhR4tKOzOW91dATbsSoLcKpgeNJ8SQzJ876U
 4NSclD4ZjLfCBHZKXBkUeF+rQbsb+6GcmT7I+woUuFDzsaEp2IhD0JaDpzZ3cGIDWucqBJca
 Z0iPAmmxOQPVAsKuirDHgMWObO4/XNiZLdeBYDQzI39QWUijusybjiVzyVxA0XXT9jyaortT
 GtqX242oyT99WAjjPM3W7a6Jpb3PPn19t4HcSJzuQFNzn2jQ6sRYJ5H5mPpio8ru2D4Esj1P
 PMvxAjFcJu7G65RBD1nTLdny3blBo+4X7rzlGVxVH5p9bieT48A81dwapEbxrw8SMbzZNB+Z
 MO+1jcm4tcDBvGkii4zcPPTQtWmk29pmdnufIPjkZYTZAVZNZq3MkiFQJuYdM99RDBmcYa+d
 pVfZjhDTFtAAunhkXizy5SKRqXLy8O91m9MxI/U4euokVrdThCvjclLYok7zQ9HdsGOud5D6
 6vCNUWqJheCsARdq5zH+EHXI++DXHMWwvFNCaILU3gD7xvAQOEl3dZ2sRG2AiGQu1/8HIJou
 WJbHpI8WopP07+A8yH25NGthjLXWWmRDzojsVT/YJwtLHwTKfidXTrciFlr+Kw5/EERsHLUf
 e6P5xbR/flMGv1AI5MmwnzQYNbJ3USWNAc/tw7R1WNqMTWLZCCjJ2RTN/DYL72VTo0UGL2BX
 UOGDD1OcVb90iuHmT1hRDAMkmdDXAXPagAZJQy09Jju7TlbLc8wzT9oW7Jlv2jOHlFrrE8el
 d4Lffujr67zFPGiFr10w==
X-IronPort-AV: E=Sophos;i="5.96,157,1665460800"; 
   d="scan'208";a="84673819"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Nov 2022 19:08:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oRez7nocVP5Emvx4xMLZ25szFn4egCXnxeJkmWeuysOqEkw3ZQCPQi3sUEyntNlElZs0rex1Fs3ZlNZVcSHzmo++Ek0qWEzWJS/6mFrWrx6lHeyPyMgDWqKB4+wvdXmNCO554mjuMW5Xirt86LKGq3teYboRNfP2BQzTTYMSLdCmBSKNw1O4GlFASa7Eac04eVa/EvUioLSqGo4/4ir3IjViG69LjWBvqL2yu7gLiWsBWo2zIN6PKXz+WVkhkxnd4gye5uvU4/icFWg9xCRr/5ZnLBmMM0KO3sUWjL07FP0nqtH/8/y08djzsasfLMuELvQhRkiZ0xK1+y4MqqsW0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XlcveaUfg4k/L1F6HOicWivuulVFOJ2lelPYQ7LoIh8=;
 b=bMgmDJkygRXLmXlU6bMhv1zEY3jOTACmMebgrFHCaVP+ReGDg8Vags05GAzHXWORhFwOBoC9wjuXbOorAsdzFRf9F8pLLZ6jQEH6ebWDI7tFCcr7sRGZazKNTB9bKIJyfAZRg2sLF4qtF2YYcuCckCwhZF3XHXe4lXSa0lhEZDD8vswDZsa5jaIqcZDKVqPezWyqEaSlC6Oug5I/0IkzxBIZPWWU8kW1pR+vNLyIV36JvzNZX5KSjZFJQByEurvpdYtlSy05YGSMWfm3elvne/yG4gn9iQ/cDTMLSJn+3eLoI6U/VQadHEHDCwsM3IxXWcEK/KdS06pGCSuMchPm6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XlcveaUfg4k/L1F6HOicWivuulVFOJ2lelPYQ7LoIh8=;
 b=O16RNBq86XZMRMcSxA/mFFQNMvLxIXk/k23JNW0I82CC8S9TqcLsP2x+ZrfK9YwcGstyAPlWlV/MF+q+QliZvFCgyaHDgA/V/d41XvJ/j4959yi83XOW9eVD0I9RctJ9UOtBKc7/ZEcadQRN0ynxeRCve7CwvfwgHkHVwGNqaUU=
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by SA1PR03MB6498.namprd03.prod.outlook.com (2603:10b6:806:1c5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.14; Sat, 12 Nov
 2022 00:08:12 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::1328:69bd:efac:4d44]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::1328:69bd:efac:4d44%3]) with mapi id 15.20.5813.013; Sat, 12 Nov 2022
 00:08:11 +0000
From:   Andrew Cooper <Andrew.Cooper3@citrix.com>
To:     "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "Li, Xin3" <xin3.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Topic: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Index: AQHY9eoXIENKa+aZTkmvQcTDrqyY364562QAgABg3gCAAB2dgA==
Date:   Sat, 12 Nov 2022 00:08:11 +0000
Message-ID: <3435ccbf-8ca4-19ca-ca34-dbb1a551b103@citrix.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-6-xin3.li@intel.com>
 <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161976800EB14B74A24D9F3A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net>
 <6097036e-063f-5175-72b2-8935b12af853@redhat.com>
 <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net>
 <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com>
 <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
 <0b5798d6-aa1d-8ad8-b129-9cffdfd4e5da@citrix.com>
 <8D824B88-1EBB-4CEC-9D1D-89123D536500@zytor.com>
In-Reply-To: <8D824B88-1EBB-4CEC-9D1D-89123D536500@zytor.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR03MB3623:EE_|SA1PR03MB6498:EE_
x-ms-office365-filtering-correlation-id: 6690d09d-0fcd-4b10-f1ad-08dac441fc9f
x-ld-processed: 335836de-42ef-43a2-b145-348c2ee9ca5b,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IV9GE1aQEPLo241Xmskng6hz7wm2i0RQVMYUdIqLtxoo8qyd9oDIJK5m9HwRhTYK4dmGxEkFn7u2Qeyn5cTyUwn6/Au9LHVo0U3EVWbvwQMO5aml3+fdCCndiVmnV5fOgB6Ac+Iv6hLZI6UlXLrqgk9WbSTD7Xzdfk0DpUK2RO3UEReY8fF/UaFnU0ZibV8sFMQ/kllgOGRVP3lU79YglJSAxR0+itvxZJ0FpfNQFSCb4Ooo9GkjCQtrhMEwwcTOzmyT1FBfx6lIb/tdnRKG5/d+76YRDtW+qL7ODlnuzibHyLkMXA9w0jW2dAoW/owf2BAfMxzRIjuVeeGIoPSrvTbWa4RqWJi4nsAjXttE01RIcTyhgeS3JRon1wX9KR++nFcqR1fmHMc5fCknQE7SLIsxoshNa1K7j03aAGvxHCsALGeWAHC5rR4nW2sFT22PneaoRNH3blt0yVxouuMUCXP91MX3p0XbIyoqpp0qZZsoOELuTRIuSqY21nhRMtazvlSb9JHipNJRg8X6IXp8VkQcXvw6Ku5KZm0voKoGWnU0mgm//wtREqDnKAMjvJKY312CDHywmCs+FdKSa15qkjALFEv4cq6+Y05WYhDwLQh4Lf7YU0FDyZ5RU0NuEjh8DX+khRC4vXMEwrcXV9ON5PrxGEnD2KTySqgzqIEEGeZqP+EyiLDyMkwPExprr0/2NdYdoQjnSmnsb0xkiO+fdrloKXDLPi4iSqmSk+B2J86fU+kxfOv41l3dVSDZPRiiHWQye+AsFjNJlMWY40J/ZO4iMR0WDdEv8Lf9xC+mEF50eW5xaqOnMGP8e8VLyxo4dsVhWDCSyYB9MmwpR4TJQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(451199015)(83380400001)(38100700002)(122000001)(82960400001)(38070700005)(31696002)(86362001)(5660300002)(8936002)(7416002)(2906002)(66476007)(66556008)(64756008)(91956017)(76116006)(8676002)(4326008)(41300700001)(66946007)(26005)(6512007)(53546011)(6506007)(107886003)(2616005)(186003)(110136005)(54906003)(71200400001)(478600001)(316002)(66446008)(6486002)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cktVNXE2M3lOZGVTcmZiSFc2SllCYmRLRTY2NGloQzZkTS82dU44emtLLzk4?=
 =?utf-8?B?dFZnWHA4N1gzTnFDeEpMRFJIclFrZVNsU3hWaWYyUmY1bm9BenptZ2VGQzA0?=
 =?utf-8?B?SkVXVkE3S2NpVVRkWHlGT2p1c2NweUptdmwzWFhDY05MNDAzelI3cDVOb3ow?=
 =?utf-8?B?L0FTM1B0Njl0eWJEdnlZWnFudGpTNlA3cStKU2NZK0ZPbXVmcGhaUGowY0Nt?=
 =?utf-8?B?RytMRy9TazRabFA0eDcyT1QyYklHcDhRRmZXSk5GL2VaWVpxdzNDRmVDcFBL?=
 =?utf-8?B?bTN3ZnpwLysxSnoza3ZQdzN2TlNZUmVYbENRNUxhZkUwdlpWUHJLR2t4NkVm?=
 =?utf-8?B?dzRzZGc2M0lpTTdidGJRL1ZqSW42OHdzRnhsVjErVGxBeHIyUi9YdE1reG9j?=
 =?utf-8?B?TlRqN2VybndiQTJJSmNWaDV4bzcyTEJyYlF6d0hBYk95Q1JhczJtcEFSdHF3?=
 =?utf-8?B?bkFKdUV3STRSbVZxcUdPZkVBaEJGSUljMDFOVjhvNGd3NXNoMmlLTmNPK0FE?=
 =?utf-8?B?V3BBMGwvVFpIWUFqd3NwZndBNWlmQnU5OERhK0xQYzNuc0RDL0gvODVRNVlC?=
 =?utf-8?B?dDVEMFdadmc4dFU4NERJMVRuT014MmQwcWoxak5EYUFyNXhwTDBlN0Y0aGk3?=
 =?utf-8?B?SCs5aUxoQjdoMkJUdDBhRi80YVNueVA0VGpmRGpHY2sxZHFFMEVSS0FnNGVQ?=
 =?utf-8?B?S1Y5UGZWWmhSekpiR0diRUZ2aGd1b1o2cjVwNHdpRkwyNlYvUTVCTzI2dGI3?=
 =?utf-8?B?M1JNbW1qZVIrQ0l5UlkyTWlHWGpRbXFPWFpMNEdtN21jZzJOeXlJMkZYTm9p?=
 =?utf-8?B?anpENC9IeEprR2pRUFgybkNFVTR3eU5lUUZPa1ZWSGlHWXpUREQ2T2ZBZkRk?=
 =?utf-8?B?dlBGMTgzUi9wWFR0Y2YraE4xUjZqQnZLYTN0SDVFekZ0cE5maWYwM3VvaWs1?=
 =?utf-8?B?YURac05sZy9VbGEza3owajdqdnJydGdpT3QwRDZlZ2JFYTg2czlGTldnVHZN?=
 =?utf-8?B?Slp4NVN2ejNYUWtQb0UwMzArbE5GZzdHNzFFQlk1WE5iQjhxdnRrWkZEVDEy?=
 =?utf-8?B?aDZZWE1QWWsvYVdiL0tzK3FIQnFtM0F4TFJMUDZ5UWJDMTg4Q2hyMGI5MmZk?=
 =?utf-8?B?L211UHRwTzRrY2l1bXk4NXo2WFJ2dkJaRDJ6eGNmd1BhcHZvU3NnbVVnT1NB?=
 =?utf-8?B?cW1GbjJEbGxMK09tTGtjVHNXYjA3dGRwSnBad01ZSWZrM2svNkx6ZmJjM29T?=
 =?utf-8?B?ZkRSRzA2WnVhK3dCRGRXTDNDVlRhM0ZLTytNSzArd3BqS0tJRmRGc3RUMHl1?=
 =?utf-8?B?QlI4b1Y1MHIyZGUzNXJDME9TamlYVEM4dWlTaE9MVkFGSWFHdkR2TXlic09y?=
 =?utf-8?B?cEYxRTlyUHVMcW1PNm1JNkpCdnN1eDJEa2U4d0c4VGZDM2Rpb295RWV5aHhZ?=
 =?utf-8?B?OXVHaUFpOE5INC9pSzhYZkhhbmtZR2tCS0x1c2NEbzFnU2FaZ0huOEdDZ0RG?=
 =?utf-8?B?L3E3Z1RBUGwrWUp2Sm1oRHJ4eWlHT0pndjhZSlhzYThVYlZzc0lSc1BTc2E3?=
 =?utf-8?B?cmJDNEJiYityd0R5NkFFV09ka1hSQ3FHR3ArT29BOFBvVjc1dm16M2pVYXhM?=
 =?utf-8?B?ZjZHZEtPa0w5ZStUVFI4UzRKR0E5enJMM01QUkc5K3ZHOWhVTEsrQ3c0TExK?=
 =?utf-8?B?L1k3eTdBYVRKWDZUUW1jUmpmZWZHeGJhV0dWeDdHaHhZY21DcGdoUHZoalNi?=
 =?utf-8?B?Nk9Bdy93QmRPS0w4QStuWmJ5WTRBUzBJNi9Yc1lDTHZEbU1jbDlrNUk0M0Jq?=
 =?utf-8?B?dWF3aUdLTG5WU3VWdnp2Z0JOMThaNTdpcDZUQWVUTVVRSVBURWt2K1dCV0dY?=
 =?utf-8?B?WitGOXRVWDV3c2EvV3RrSkRIVytEU0JObHRhMkthcGY5OGVLZTI5THF6aXZy?=
 =?utf-8?B?SnRTcS9UcWlCTWIyQ2NYM1I5MzM0eFkrNHRzUUJkMndrREE1V0xwZ2Z0SHk4?=
 =?utf-8?B?cHZjMkgxU1gxRTRJSjVxbXRSanVVck9ocVNHNHR2M1hGUDg5RHFpa2tGNVZ2?=
 =?utf-8?B?Rm54WUJOSnlybGZuUGZiWCthc3BEbXRZczBiOTNnMFgvYUpmZ1FSL2h2MTRu?=
 =?utf-8?Q?WxxnGTZqtKQJujWmMzrr4Mmg8?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3EE223CFBE3369438557BE8946B3D66E@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?L3Vac3RRT3ZKVFZSci9JSTFybytIZjQ5RU1BdUszNm5iT2dncFI2OXdHSk9w?=
 =?utf-8?B?TnVqaWZzTXdITHdudXNhTjMzK1cwY1Bwd0hZbnd4ZXZtMHdDT0RNQTEyUUEw?=
 =?utf-8?B?VVpQVUlYdDNKMllBdmtxUDFnMDBuWmlxOVI4VlFlTHRHbGdTSnpTcFdNc0N3?=
 =?utf-8?B?QWpNZFlVMWRxUHQ0UnkvbWRaMFBwNk1lb0FhTStIdUx3ZDlYZGFFbzlGTmZy?=
 =?utf-8?B?MENjOGpuUEVOZ1dYQ3lGcDVZWG8wSDNwajNGQnZaTklUQ3U5alRFSmxwNzBX?=
 =?utf-8?B?QVVFeEFrbzVJNnBvaVVXSmlMNEVZcnVpMUErYUw5a0FVMzRXS1NENU9FN1lz?=
 =?utf-8?B?c0tqMHdURlcydVIrQzJ3Tjh3bUtjekRxQkhIL0xJY0l2a3VBOXdqMnhWUzA5?=
 =?utf-8?B?WklhS0MzN0o3cm9WYlJHQnZVM0pxMmtIWjVYRGp5WEs2VzFDTGdRZmdCV0Nt?=
 =?utf-8?B?TnAyQm1RMzlGRGJwd3p1ZmxPcEczb0VTN1BjUlh5Sy9PSnpEMmJJUnVMVHdC?=
 =?utf-8?B?K2tlZm5vcFFwV2NWak5Vd3ZCU2lsQ05qaEdDaDMrd2VTWGRlZndweGh3bVUy?=
 =?utf-8?B?ZExhZVdDWENrMXluVFZuNnpKYUZCUXlnUE1OY1NXcXI2ZWRsVUx0dFFRRFdq?=
 =?utf-8?B?NXRoVmkvM09wRy9WblBQMUZxKzlwY0VOeTBCV2krUnJNTHdlMVM2Q2Rrbllq?=
 =?utf-8?B?N1BHR0w1UWVjclJ2TWpMMFgzN1ZwQ2VZcFl4SENoQVNsR1pkY0oyMW92M1hj?=
 =?utf-8?B?dXBVeFJkMlZrQ3pPbDdNREVRdnZSUENEWi9GUUVUaXZXSVlPZ2xkSllVMWRX?=
 =?utf-8?B?ZVpoN1RZQlcxdVN1bStjR1NRWkFIeC9UZndTK2Q5NkEvbkZqNTdUUGZ1bDZk?=
 =?utf-8?B?N1J5eVQ1NC9ZZG5NMEN3UzRCMkRQQ3lDU2Y5eEhwSnJhL3cremRZMHFDWDZR?=
 =?utf-8?B?SFZGZ28xenVnNktxdzllL1Axb1kyZ3Bnc2ZwVWRPdVd5T1diNEIwazFKQXQ4?=
 =?utf-8?B?TGRtRVIyNUlycTZjVWV2TmZkUWoydDlVQmFBb0Nxdnp4eEJvNVlnYmpMYk92?=
 =?utf-8?B?cGdlU01jRVpGNTU4bElaaExOdlZJQUZ3dWk2YzRqVU5xeDgzTEdnUDlSeU1X?=
 =?utf-8?B?RWNWVHRET044d3lkeGVUWWNSenZoblNZdFdhZmloL2Z2dUlXdklSRFVOL2hW?=
 =?utf-8?B?SlZ3dTYxWUUvTjVscnFuOFlOZUNZR1QxL0p1RGVkdStTMXRIY1drSGFGaGkz?=
 =?utf-8?B?TDBtZlRRMUdMWHNZSXJtTG4ybjZ3c3V4Z2xuclVObWRuL3ZrSU5lUzM1bjhm?=
 =?utf-8?B?bjNLQUlzaU1LSm9ReXVBTzYzMm0wb2tDN3lyYmUrYlR3TXBmbUtoTFpmV0dU?=
 =?utf-8?B?Z3QrMzV1ZGhTOUp5aEJWWHZtTFV4ektjVnMvOHpZN3VXZTZGREo4WFNscW9w?=
 =?utf-8?B?WDlQZDA2MkxXN1A0M1JZZjB2MHloYzZBVEdWa0QxWTFSa2Zhd1RJOVFtRzAy?=
 =?utf-8?B?VHpRRjFyaGZxdUx0d3QyTVlkWlBtYWt3RENBckhRVzV5c0tMc2V0OHRXQmlj?=
 =?utf-8?B?TjFFQT09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6690d09d-0fcd-4b10-f1ad-08dac441fc9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2022 00:08:11.6449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eYqh6bqA4ge/VhLSToECBiFHtxMkhZmbqMrF4sjtlacurc5gaZhVsmflGLooSHXV9XJ6X0IZMq3uMXzE+McSUJwICeaGV32dF4uX6BPD7cI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR03MB6498
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTEvMTEvMjAyMiAyMjoyMiwgSC4gUGV0ZXIgQW52aW4gd3JvdGU6DQo+IE9uIE5vdmVtYmVy
IDExLCAyMDIyIDg6MzU6MzAgQU0gUFNULCBBbmRyZXcgQ29vcGVyIDxBbmRyZXcuQ29vcGVyM0Bj
aXRyaXguY29tPiB3cm90ZToNCj4+IE9uIDExLzExLzIwMjIgMTQ6MjMsIFBldGVyIFppamxzdHJh
IHdyb3RlOg0KPj4+IE9uIEZyaSwgTm92IDExLCAyMDIyIGF0IDAxOjQ4OjI2UE0gKzAxMDAsIFBh
b2xvIEJvbnppbmkgd3JvdGU6DQo+Pj4+IE9uIDExLzExLzIyIDEzOjE5LCBQZXRlciBaaWpsc3Ry
YSB3cm90ZToNCj4+Pj4+IE9uIEZyaSwgTm92IDExLCAyMDIyIGF0IDAxOjA0OjI3UE0gKzAxMDAs
IFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+Pj4+Pj4gT24gSW50ZWwgeW91IGNhbiBvcHRpb25hbGx5
IG1ha2UgaXQgaG9sZCBvbnRvIElSUXMsIGJ1dCBOTUlzIGFyZSBhbHdheXMNCj4+Pj4+PiBlYXRl
biBieSB0aGUgVk1FWElUIGFuZCBoYXZlIHRvIGJlIHJlaW5qZWN0ZWQgbWFudWFsbHkuDQo+Pj4+
PiBUaGF0ICdvcHRpb25hbGx5JyB0aGluZyB3b3JyaWVzIG1lIC0tIGFzIGluLCBLVk0gaXMgY3Vy
cmVudGx5DQo+Pj4+PiBvcHRpbmctb3V0Pw0KPj4+PiBZZXMsIGJlY2F1c2UgIklmIHRoZSDigJxw
cm9jZXNzIHBvc3RlZCBpbnRlcnJ1cHRz4oCdIFZNLWV4ZWN1dGlvbiBjb250cm9sIGlzIDEsDQo+
Pj4+IHRoZSDigJxhY2tub3dsZWRnZSBpbnRlcnJ1cHQgb24gZXhpdOKAnSBWTS1leGl0IGNvbnRy
b2wgaXMgMSIgKFNETSAyNi4yLjEuMSwNCj4+Pj4gY2hlY2tzIG9uIFZNLUV4ZWN1dGlvbiBDb250
cm9sIEZpZWxkcykuICBJcHNlIGRpeGl0LiAgUG9zdGVkIGludGVycnVwdHMgYXJlDQo+Pj4+IGF2
YWlsYWJsZSBhbmQgdXNlZCBvbiBhbGwgcHJvY2Vzc29ycyBzaW5jZSBJIHRoaW5rIEl2eSBCcmlk
Z2UuDQo+PiBPbiBzZXJ2ZXIgU0tVcy7CoCBDbGllbnQgb25seSBnb3QgInZpcnR1YWwgaW50ZXJy
dXB0IHByb2Nlc3NpbmciIGZhaXJseQ0KPj4gcmVjZW50bHkgSUlSQywgd2hpY2ggaXMgdGhlIENQ
VS1zaWRlIHByb3BlcnR5IHdoaWNoIG1hdHRlcnMuDQo+Pg0KPj4+IChpbWFnaW5lIHRoZSBub24t
Y29jIGNvbXBsaWFudCByZWFjdGlvbiBoZXJlKQ0KPj4+DQo+Pj4gU28gaW5zdGVhZCBvZiBmaXhp
bmcgaXQsIHRoZXkgbWFkZSBpdCB3b3JzZSA6LSgNCj4+Pg0KPj4+IEFuZCBub3cgRlJFRCBpcyBh
cmd1YWJseSBtYWtpbmcgaXQgd29yc2UgYWdhaW4sIGFuZCBwZW9wbGUgd29uZGVyIHdoeSBJDQo+
Pj4gaGF0ZSB2aXJ0Li4uDQo+PiBUaGUgb25seSBGUkVELWNvbXBhdGlibGUgZml4IGlzIHRvIHNl
bmQgYSBzZWxmLU5NSSwgYmVjYXVzZSBiZWNhdXNlIHlvdQ0KPj4gbWF5IG5lZWQgYSBDU0wgY2hh
bmdlIHRvby4NCj4+DQo+PiBWVC14ICpkb2VzKiBob2xkIHRoZSBOTUkgbGF0Y2ggKGZvciBWTUVY
SVRfUkVBU09OIE5NSSksIHNvIGl0J3Mgc2VsZi1OTUkNCj4+IGFuZCB0aGVuIGVuYWJsZV9ubWko
KXMuDQo+Pg0KPj4gRXhjZXB0IHRoZSBJUkVUIHRvIHNlbGYgd29uJ3Qgd29yayAtIGl0IHdpbGwg
bmVlZCB0byBiZSBFUkVUUy10by1zZWxmLsKgDQo+PiBXaGljaCBJIHRoaW5rIGlzIGZpbmUuDQo+
Pg0KPj4gQnV0IHdoYXQgaXNuJ3QgZmluZSBpcyB0aGUgZmFjdCB0aGF0IGEgc2VsZi1OTUkgZG9l
c24ndCBkZWxpdmVyDQo+PiBzeW5jaHJvbm91c2x5LCBzbyB5b3UgbmVlZCB0byB3YWl0IHVudGls
IGl0IGlzIHBlbmRpbmcsIGJlZm9yZSBlbmFibGluZw0KPj4gTk1Jcy7CoCAoV2VsbCwgYWN0dWFs
bHkgeW91IG5lZWQgdG8gZW5zdXJlIHRoYXQgaXQncyBkZWZpbml0ZWx5IGRlbGl2ZXJlZA0KPj4g
YmVmb3JlIHJlLWVudGVyaW5nIHRoZSBWTSkuDQo+Pg0KPj4gQW5kIEknbSB0b3RhbGx5IG91dCBv
ZiBpZGVhcyBoZXJlLi4uDQo+Pg0KPj4gfkFuZHJldw0KPj4NCj4gVGhlcmUgaXMgbm8gZnVuZGFt
ZW50YWwgcmVhc29uIHRvIGRvIGEgQ1NML0lTVCBjaGFuZ2UgaWYgeW91IGhhcHBlbiB0byBrbm93
IGEgcHJpb3JpIHRoYXQgdGhlIHN0YWNrIGlzIGluIGEgdmFsaWQgc3RhdGUgdG8gaGF2ZSB0aGUg
Tk1JIGZyYW1lIG9uIGl0OyB0aGF0IGlzOg0KPg0KPiAxLiBOb3QgZGVlcCBpbnRvIGEgbmVzdGVk
IEkvTyBsYXllcjsNCj4gMi4gVmFsaWQsIGFuZCBub3QgaW4gZmx1eCBpbiBhbnkgd2F5Lg0KDQoz
LiBUaGUgTk1JIGhhbmRsZXIgZG9lc24ndCBkZXBlbmQgb24gYmVpbmcgcnVuIG9uIHRoZSBhbHRl
cm5hdGUgc3RhY2suDQoNCj4gU2luY2UgdGhpcyByZWluamVjdCB3aWxsIGFsd2F5cyBiZSBpbiBh
IHdlbGwtZGVmaW5lZCBsb2NhdGlvbiwgdGhhdCdzIGZpbmUuDQo+DQo+IFNvIEkgdGhpbmsgKnRo
YXQqIGNvbmNlcm4gaXMgbm90IGFjdHVhbGx5IGFuIGlzc3VlLg0KPg0KPiBBZ2Fpbiwgbm90ZSB0
aGF0IHRoaXMgaXMgbm90IGEgRlJFRC1zcGVjaWZpYyBwcm9ibGVtLg0KDQpIbW0geWVhaC7CoCBP
biBmdXJ0aGVyIGNvbnNpZGVyYXRpb24sIEkgZG9uJ3QgdGhpbmsgRlJFRCBpcyByZWxldmFudCBo
ZXJlDQoob3V0c2lkZSBvZiBhIGZldyBtaW5vciBkZXRhaWxzKS4NCg0KVGhlIFZNRXhpdCBiZWhh
dmlvdXIgaXMgc2ltcGx5IHRoYXQgb2YgdGhlIE5NSSBoYW5kbGVyIGJ1dCB3aXRob3V0IGFuDQpl
eGNlcHRpb24gZnJhbWUgb24gdGhlIHN0YWNrLsKgIFRoZSBlYXJseSBhc20gaXMgd2Fsa2luZyBv
biBlZ2ctc2hlbGxzDQp3aXRoIHJlc3BlY3QgdG8gdGhlIE5NSSBsYXRjaCwganVzdCBsaWtlIHRo
ZSByZWd1bGFyIE5NSSBoYW5kbGVyIGlzLg0KDQoNClBldGVyIGlzIGNvcnJlY3QgdGhhdCBvbmNl
IHlvdSBsZWF2ZSB0aGUgVk1FeGl0IGhhbmRsZXIncyBub2luc3RyDQpyZWdpb24sIGEgcGxldGhv
cmEgb2YgdGhpbmdzIGNhbiByZS1lbmFibGUgTk1JcyBiZWhpbmQgeW91ciBiYWNrLsKgIEFuZA0K
dGhpcyBoYXBwZW5pbmcgaW4gcHJhY3RpY2Ugd2lsbCBlbmQgdXAgd2l0aCB5b3UgbG9naWNhbGx5
IHRha2luZyBOTUlzDQpvdXQgb2Ygb3JkZXIuDQoNCldoZXRoZXIgdGhpcyBtYXR0ZXJzIG9yIG5v
dCBpcyBhIGRpZmZlcmVudCBxdWVzdGlvbi7CoCBSaWdodCBub3csIE5NSSBpcw0KImp1c3QiIGFu
IGVkZ2UgdHJpZ2dlcmVkIGludGVycnVwdCwgYnV0IGEgdGhlb3JldGljYWwgZnV0dXJlIHdpdGgg
Tk1JDQp2ZWN0b3JzIG1pZ2h0IGhhdmUgc29tZSBmdW4gY2F1c2FsaXR5IGJ1Z3MgdG8gY29udGVu
ZCB3aXRoLg0KDQoNCklmIHRoZSBvdXQtb2Ytb3JkZXIgTk1JcyBpc24ndCBhIG1ham9yIGNvbmNl
cm4sIHRoZW4gYSBzZWxmLU5NSSBpcyB0aGUNCnNpbXBsZSB3YXkgdG8gaW52b2tlIHRoZSBOTUkg
aGFuZGxlciBpbiBhIGNvbnRleHQgaXQgY2FuIGNvcGUgd2l0aC7CoA0KT3RoZXJ3aXNlLCB0aGUg
Vk1FeGl0IGhhbmRsZXIncyBpbnN0ciByZWdpb24gaGFzIHRvIGRvIHRoZSBoYW5kb2ZmIHdoZW4N
Cml0J3MgaW4gdGhlIHNhbWUgc3RhdGUgdGhhdCB0aGUgTk1JIGhhbmRsZXIgaXMgZXhwZWN0aW5n
Lg0KDQp+QW5kcmV3DQo=
