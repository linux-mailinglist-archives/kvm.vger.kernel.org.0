Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97474625F9D
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 17:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbiKKQfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 11:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234238AbiKKQfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 11:35:44 -0500
Received: from esa4.hc3370-68.iphmx.com (esa4.hc3370-68.iphmx.com [216.71.155.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C716B836BF;
        Fri, 11 Nov 2022 08:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1668184536;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aNNUu01QVByABtJ5QpelHZxwnDaodKxlPnjnWL9NdcQ=;
  b=MJMKxFCGEo7LqgTer3knWHxrPbF31MaZHDZw7pwSlao2uJ/bPzTJzSLt
   /JD6x/G5HOeB+84IJesAmvgFrr/jmvNzLYSEx5btpG+v9c4hEC5pwp1ec
   +dHVXE9fVFzCHw5nAuKgffzHsx0RXcqnolwA55NsqA5onRN3bBuiGYJGT
   U=;
X-IronPort-RemoteIP: 104.47.74.42
X-IronPort-MID: 87194760
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:cxh1w6ojDsS6lzdLxg37j+aNuE1eBmJsZRIvgKrLsJaIsI4StFCzt
 garIBnTM//YZzfzeNxxb96+8U9X78TWn98wTgtppC1hEHwS8puZCYyVIHmrMnLJJKUvbq7FA
 +Y2MYCccZ9uHhcwgj/3b9ANeFEljfngqoLUUbKCYWYpAFc+E0/NsDo788YhmIlknNOlNA2Ev
 NL2sqX3NUSsnjV5KQr40YrawP9UlKm06W1wUmAWP6gR5gaHziBNVfrzGInqR5fGatgMdgKFb
 76rIIGRpgvx4xorA9W5pbf3GmVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0MC+7vw6hjdFpo
 OihgLTrIesf0g8gr8xGO/VQO3kW0aSrY9YrK1Dn2SCY5xWun3cBX5yCpaz5VGEV0r8fPI1Ay
 RAXABwLcTO42KGJ+rOUeu9Mj8IRfJjFGLpK7xmMzRmBZRonabbqZv2WoPV+jHI3jM0IGuvCb
 c0EbzYpdA7HfxBEJlYQDtQ5gfusgX78NTZfrTp5p4JuuzSVkFM3j+SrbIC9lt+iHK25mm6xo
 G7c8nu/KRYdLNGFkhKO8262h/+JliT+MG4XPO3nr6823wPLroAVID4xDmvnnOOHsRHkZO5HN
 WBIpXRtn7dnoSRHSfG4BXVUukWsphMAVsBCO+w85huExqfd70CeHGdsZiZLb9o0tck3bSYn2
 l+Ag5XiAjkHmK2UTynb8ra8rDWuNCxTJmgHDQcATA0Y85zgrZs1gxbnUNluCui2g8fzFDW2x
 CqFxAAu1+s7jsMR0ai/u1fdjFqEpYbMZhA66x+RXW+/6A59Iom/aOSA9Vff/d5ELYCEUkOGu
 nkU3cSThMgLDJeCkwSXTekNFa3v7PGAWBXWmXZmG5gs8WTr93PLVYxZ/jw4JE5vKcsCUTvoZ
 lLD/wJX+JJXenCtaMdfY5q4I9Y70a/6U9/iU5j8dddHZJp6XACA+y5qaAib2GWFuEshj6A5f
 4uaeMCEDHAGBKAhxz2zL9rxypcuzyE6gGnVFZbyykz71aLEPCLPD7AYLFGJc+Y1qruepxnY+
 MpeMM3MzAhDVOr5YW/c9ot7wU02EEXXzKve86R/HtNv6CI8cI39I5c9GY8cRrE=
IronPort-HdrOrdr: A9a23:hvkz06NkxCWXb8BcT+/255DYdb4zR+YMi2TDiHoddfUFSKalfp
 6V98jzjSWE8wr4WBkb6LO90DHpewKRyXcH2/hqAV7EZniohILIFvAu0WKG+VHd8kLFh4lgPM
 tbEpSWTeeAdWSS7vyKrjVQcexQpuVvmZrA7Yix854ud3ASV0gK1XYaNu/vKDwTeOAwP+tdKH
 Pz3Kp6jgvlXU5SQtWwB3EDUeSGj9rXlKj+aRpDKw875BKIhTaI7qe/NxSDxB8RXx5G3L9nqA
 H+4kzEz5Tml8v+5g7X1mfV4ZgTsNz9yuFbDMjJptkJJi7qggOIYp0kf7GZpjg6rMym9V5vut
 jRpBULOdh19hrqDyCIiCqo/zOl/Ccl6nfkx1Pdq2Dku9bFSDUzDNcErZ5FczPCgnBQ/u1U4e
 Zu5Sa0ppBXBRTPkGDW/N7TTSxnkUKyvD4LjfMTtXpCSoETAYUh6LD3vXklVKvoLhiKrrzPI9
 MeVf00I8wmKW9yWkqp+VWHBubcBUjbUC32GHTq8fblrgS+1EoJs3fwgvZv3UvovahNNaWtrY
 7/Q9tVvaALQckMYa1nAuAdBcOxF2zWWBrJdHmfOFL9Ccg8SjrwQjHMkccIDcyRCeo1JaEJ6d
 38eUIdsXR3d1PlCMWI0pEO+hfRQH+lVTCozs1F/ZB2trD1WbKuaES4ORoTutrlp+9aDtzQWv
 61Np4TC/j/LXH2EYIM2wHlQZFdJXQXTcVQsNcmXFCFpN7NN+TRx6fmWeeWIKCoHScvW2v5DH
 dGVD/vJN9Y5kTuQXP8iAi5YQKbRqU+x+MFLEH3xZlh9GFWDPw8juE8syXI2uibbTtfr6cxYE
 xyZLv6j6LTnxjCwVr1
X-IronPort-AV: E=Sophos;i="5.96,156,1665460800"; 
   d="scan'208";a="87194760"
Received: from mail-bn8nam04lp2042.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.42])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Nov 2022 11:35:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I51lqHTzPQzu8fPcwSBWo3yeGrS8JgItp4plpd3TnCG53DRTTAB59LeHgwSQzdy3jIZorR7Vi8uXtvUadak06OKDWlHeUXwTNhuQWAx14mFDPl2LGe9QKdfkL94uJvY/s0A7ftUkBn2i8WM5EbFDaTQKNVluzQz9vJC6mSfJmxHZEXYC53UZlOZJqS9rqtTjIuEl5Bo1Zq5oXjkGbYwPRHMMnFOUGEgI8lqCfA3HT4Nk6Pa1lYsF8DzDU1Doxcq/j2GD/HurjcBgxMqgaROLoK3Myfkh6tDYmMzoL83l3yZu6InJ8oUB/RJwksK/Jj1YdjAAb9pgAaCJ/YnFtBetQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aNNUu01QVByABtJ5QpelHZxwnDaodKxlPnjnWL9NdcQ=;
 b=HTl6kwJ09G6mZbPxGFSxJkwbhECW8ZjyC8FWvZ6d1ZXx5BHgmLfReGoIFqPSeTI6F1+9awb3NQrsiX2Y4G8ou4VMGNI8I0/Rb6a1BoT4qeJO2HuFCIIdJDMVl3OUJ86sJ1Yvl6uvMvm+ujowRxD1JnLoiAWvBzFGwrtBOUkECfcjKLQA5MCT+ifrfS/xGni9bsXt/R3EZvScAMzzzEaXhP84T6uGNBJaCQtWg+Qo/LFEcnj45o53V+YjGgg+woZ5RCav/Sq3JMKW6Xry9xu+tg/ZJ+mtM0KtZr26BuVGsY1BmjF3jaAnsPiwSH3moWvoqczv48G9oXWaV/6MFkJqiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNNUu01QVByABtJ5QpelHZxwnDaodKxlPnjnWL9NdcQ=;
 b=QMb0Ky+UMGpQHnASUavuUaQSvfQ79rXUCM01LRAV2cKchK1PqfctZdFHxbCUGrHQwIOeAxy/b6EiJU8M0u+cyvp1f4o/PI8FB7Dm8egfLtjg6TpBHLS2lK2ZErRNUlL16FvcLzqIOT+5Xufw/AQyzdgPCB6nnuNpCvlf9MF8aas=
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by SJ0PR03MB5630.namprd03.prod.outlook.com (2603:10b6:a03:28b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 16:35:30 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::1328:69bd:efac:4d44]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::1328:69bd:efac:4d44%3]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 16:35:30 +0000
From:   Andrew Cooper <Andrew.Cooper3@citrix.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "Li, Xin3" <xin3.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Topic: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Thread-Index: AQHY9eoXIENKa+aZTkmvQcTDrqyY364562QA
Date:   Fri, 11 Nov 2022 16:35:30 +0000
Message-ID: <0b5798d6-aa1d-8ad8-b129-9cffdfd4e5da@citrix.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-6-xin3.li@intel.com>
 <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161976800EB14B74A24D9F3A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net>
 <6097036e-063f-5175-72b2-8935b12af853@redhat.com>
 <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net>
 <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com>
 <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
In-Reply-To: <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR03MB3623:EE_|SJ0PR03MB5630:EE_
x-ms-office365-filtering-correlation-id: 6a49e23d-4b8a-4dfc-5d02-08dac402bf55
x-ld-processed: 335836de-42ef-43a2-b145-348c2ee9ca5b,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TVOdRVxvSb1IgTvpXLBKdPCW/36MxPASdqaubKVwtBvMDJaLpP/ee3KvKgrzKQ2i5mEB3iSkz7sV2go9/PRxxh8sSL3Ipqt3PVDKY+KWCFvZGOuGTLOAoqUm6a0Xajwt+o9ksJDRNcvovTNzUSBk8LgiV6zBQ0WpLFhGYfaJkabZR9jICMSDJFWxG0Rmd6mgHfpYAYKeqjhhFfgBpJy7iBFKvPU9B6Z997h/t69Z1FA6jzd+D1P9jb1wv5/vOmi3ogtaN38ltuDtYvj5aNbHxOb900I+2EaCRfaAWKW72QXRoQF26chd9AX3uH2ajQftm530SRwdDrPF2q40JRpVAU0J7tit+OoSTryWh5gNtd0oCll6ZimRetm0Jx0cxdiC2/c0OAxcUPfizqMsjpY/or0d9+1Xp8iboAgk40/4fyVE02N4TSQT109apTr+chT3MKWCPzYbxEJGQ+fTGuH3l5hehLQ6DFyPsZ6Oj96BorzrvPDdQOBiEi4l2w3eUL9Y9TPxORb7dwa85ct8bw92nGgc+obExG56kYfKkxrKbGdWvrEEhYV5uCAO458S5sEphXZCBRLqGkZwENrdDAEac5bS7OMs9gNKqJ6RAl44QOfl0gz2ybfa2VycX3IbttHAYXReX0i5YmFiq5HE/lxxrvg2Cq4SjQJDsUOIKaljrg38aWG21fQDG5tGlJ/+FAtB0DtwitylA3Vy5MrRAolimI5gzL2kZHYCe/M3VVX4B5kDe/gBQBZm2Z9fP+tDEvzOvMXVwEUCakwFj8/XgUtUoknL+kUVuqg0SIOzK5rjUqnG2GY2qruGaJaqQyfB2eufB1IhStnJHRNucTxn7qUWmg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199015)(36756003)(122000001)(6506007)(31686004)(53546011)(38070700005)(31696002)(86362001)(82960400001)(6512007)(38100700002)(5660300002)(2616005)(83380400001)(186003)(26005)(2906002)(54906003)(110136005)(107886003)(71200400001)(478600001)(6486002)(8936002)(316002)(66476007)(8676002)(64756008)(66446008)(66556008)(7416002)(66946007)(91956017)(76116006)(41300700001)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZEp3VnlpRDRaa3M5VmdYeWNVMml6TDNObElma3pEb3pjWGtMOCtCM3VTZUda?=
 =?utf-8?B?N1JRNFlqTllqWDRhWGZwSjRzMXVPTzh1VE1nSG5yYjdQbDRDdm5zMU9ZNDNG?=
 =?utf-8?B?NW9oTHQ5aS9tVnI4YVdMSFE1OHRGZzhtejJQVTUyLzI3T3k0a0hQNnYwOWky?=
 =?utf-8?B?ZTdwUkRrTlA4czdrM2ZYVzdzMTREeHcyMkl0RGpmL0txenNoOFkrdWU2ZWtL?=
 =?utf-8?B?dkI2ZkF2Ujg5ZDh1akxlMTI0Z1hQcEs4Wkw4UFBEb0lOYzBxdUhVRjRjV0Zv?=
 =?utf-8?B?S3U5a1RWU2FkTkxpeHAwUi81azVGSnI4T1p0anNpU2p3L0txRklMQ2k5dyti?=
 =?utf-8?B?UnB5Uk9WQUo0NHJLZUoxYml6UHg0YnplbGQ4RnNQNE8yUStBVUFQMDVSZy95?=
 =?utf-8?B?a2ZocnRvM0JCWFJJajRXdHhQNk1BMUFvK2JFQXc5SGRxUWZrZlBQSGNvU1BV?=
 =?utf-8?B?YWFvMDRqMjFqVG45TFBqR3g5S0lJTVpKWnh2RDJxUVVGMVViOUljK2h2c1ZB?=
 =?utf-8?B?VmtsUWhKckp5bURra2hlS3FoTmV2U2pHVmdTWGNNNzQ5R0dLS1JoVWFyanhZ?=
 =?utf-8?B?dlBHZE1IZ1g0YUEza2VCakJrRVBLVmlObWxoSzdEQ0dzZW1Zd0hhaStKMklv?=
 =?utf-8?B?azRmejQyL1RJU0swMEJlVGJqRmNINzlETS9qbnJlMndwM2R6ZUNid2tVMU53?=
 =?utf-8?B?T1UxQjdWeEpLQ015c1RxYTNwdzZaSHhvZzdwTm0raWJlUzBta3crSjE4L0hD?=
 =?utf-8?B?TElubDZZSXNHcGpDUFB1WFdralV5ZkR2QXJYdlUvc0hTNGVabGl5OTl6RzJH?=
 =?utf-8?B?L2Rac25OWjFqSjQ0TnRtMTlTSVIwRUJMRWpZSHBVNGY3ekI4TlFGRDhsZUd2?=
 =?utf-8?B?bXBLdHY2Znl1eUFzUldsa0VzTS9KYXZRMWpKYnUvYXpDME5IdlpzRWNjQUdm?=
 =?utf-8?B?YXF0aUxQY0tWYkF4TXYwWTJ4UytjSmxMWlJYbGRKWGZxZGx4eEhVWHBCbW5C?=
 =?utf-8?B?K2dNUVU4L0ErLzRZWHltUEFKQ1R0QXhKZEE4ZnVVZjhMYzlhaFBlQVBZYi9r?=
 =?utf-8?B?aFQyalhUaVJaQlBNMTJFazlwaUo3THhYWHhjcTFXdTZVemZwVUhCUHk0cENM?=
 =?utf-8?B?eVBTMXlxQnZyczlVbloySHVPcEk2cEoybSt3WGNWT0M3K3ErVjhoYzRDM05W?=
 =?utf-8?B?MUgxV08wK0hXUDVrNU1NeVR0ZEhScnppNlZpM3o4dTZkSTZhd2pSclF4Yytq?=
 =?utf-8?B?MGFPU1d5WmdST3l3TW5rOVgwTFhXU01uY2dKeER4UHVuREpvUHdrbGpST0sx?=
 =?utf-8?B?MVpEWUxpenZDdmtPZk9wU0I2YzI2bGZCREtYVGNaNUloemxsSXpvd0RsTkNu?=
 =?utf-8?B?QUJWSVFVMVFNb29MUkljWVIwVE9pdVNXTkJVTUY2dHFkZTZLQzZNVW1Yazc3?=
 =?utf-8?B?dEt1VldML0hFNnRSMnN4Kzh5eXFMZThBTjI1SGt6SzgrWkt0b2JweEhCUDd1?=
 =?utf-8?B?NlhLc3Z1VWlIcDhxZGFQVm9odE1hNnNLNU5MZGtlbDNYaU1lZHQ4NHlqcytv?=
 =?utf-8?B?bmZkbUNFcG0yWGxFRnBHM0JLVTROUytaZkVYR2s1ZklSaU1keEtBZ1d1VzRX?=
 =?utf-8?B?T3hmby9XaHRTWitjWnBFY29FdGlaWXZWSnBZM3VRM0RBcnQzeS9LWDZjdmRI?=
 =?utf-8?B?YjBTSER6VGx4dzkwc0Yrd3hWZm5KVk81cks2QmZMNzg1aFBMRWRyTkhSWXo4?=
 =?utf-8?B?WDhVdE14NzJMQ29QQ0dDY2VsR25OclJqQXZQUnlqc2wrWS9XbkZ4c1BvYzQv?=
 =?utf-8?B?VjZnWGs5TEJlaFJMOTJCZC9JdXJuRk5oR0d1V3RkeTUyM0FmSTJsQldHMFBZ?=
 =?utf-8?B?a0cyR1IvL2E4STIwS3RlcTEwTWxRQW9hcmxaWStTbXVHNnh6QVJHd1NLQ3NH?=
 =?utf-8?B?eFVMRVRyV1YvTExPaW1DcVVud1pLSUhDY2ZwM2ExQyt5Rkdsbk5FUVRLUE5h?=
 =?utf-8?B?ZkFUZDlmS3ZESU9ZbFFhRGxoeXhlc0lUcm53Z3lXVTkrdWRkV2ZIaWdjZ2dJ?=
 =?utf-8?B?ZHhzMFVkVkpJYXp2d3l5RTIycjFxNUMxSk9JRGxIa2MvY0RmM0pVTG80Ry9a?=
 =?utf-8?Q?2uIUsl9d0p1gSAPnH28QeVXab?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73CBEB261346A4458E9FE9FC2E2EAA7A@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZmpnTlhyRHI2UWNpbUh6MVlpYnVsYzZuVllscFZXQXdkbnRzclE3Wnl5ZGw1?=
 =?utf-8?B?azBwRHF5VTZ6ME52cVZOZ1VBYys5T1Z6RHZtUklYdVpJTHlNWlZ3RzdDTWxS?=
 =?utf-8?B?bWdKd0FGQ0doS25kSC9pYm0yZmJDYnRtdFI4cnhJdXJKOC9nZXowY2tocjFY?=
 =?utf-8?B?aEYzREtIM2JDNXZQZUFGbURKWS80VkRUaXNwWmpVa1VxbWMwZFk0Yk9JYmo2?=
 =?utf-8?B?SEU2dzZwK3U3U25UVm9hbGFjV2VVMGowYTZxaEp6Q2JTTnVHTFc4MnV3TkRu?=
 =?utf-8?B?U0Z6dURzajd2VzRwa0NrOStIOUtSRTdPNlhWb2JQeldscDc0czFOSWN4SVo3?=
 =?utf-8?B?U0paWjhmeTNEblZsdDFKN2h3V25XQk84WktBeDh1VE1uYlpCL3FJZjRrNjlQ?=
 =?utf-8?B?OEdla3FWeGhBeDFDaW1SZUJmMTVXREZxQk5saDVWQ1NyY1hlVEtsQWY5ZktJ?=
 =?utf-8?B?WGsxdENIaEgyTFNZVXlWUUFDOTlGVWhUeTB2czRuT2syMW5vUUdmNTFJSlpG?=
 =?utf-8?B?NTRrR0hKdVM3WWJZSDdSY1I1bkxzLzlEUFl6SGg3WFY0ekdibXArUSszL1BM?=
 =?utf-8?B?c2YySDV2dW9UdVJBY2pQZy9JOVNJZHk4bDFhTll4TTk4TnI5ZnYyalVteWFE?=
 =?utf-8?B?WWVsamhRZVNxT3RWYWVOUUFFZHRzZ3NQY2FDRjFQU2lHYW5YN2JDOHQyNzc5?=
 =?utf-8?B?ZFNZcGFOTXh2ZTA5em5pdmFiWk9ubEN1dFh4N0RmN0VvaSsycDRPbTFNdUV2?=
 =?utf-8?B?N3pOY3RodkJiWHJrcEZwdnpUY2d1UEd1T3hQVVV3dURFWEhnK0VkSlpYNW5p?=
 =?utf-8?B?dVZQZ2J0MWJLRXR6S1IrSnliOEZ3Y3lpQm1SdnhIRlRvRnVaekdhbmY0dlhi?=
 =?utf-8?B?dGE0TkxaaTJhcVA3WEhTdGw2UGlZallHZ3NSZVZGUzJrdG9qT2kwb1ZST3dl?=
 =?utf-8?B?eGtlcW1DNHN0Y1ZQUTc1U2Vhdnl3YkpVRjVidlFlLzJLcEdKcnlKUk5wV1Iy?=
 =?utf-8?B?UXFacXhETlNvMnJnTUV6bzkyV0R5Z28wUXErRkZLQ2JJNC9sa3NqM051VHFW?=
 =?utf-8?B?NzZLYnZtb3BsU00vazRkT2ZNSFk4bEdsZHJDeENHUTN4ZE9YeXcyejF3cEdN?=
 =?utf-8?B?dnNDbDdYa3IxaSsvMG5CNWR4Y1RkZHQrYjNTTGFhTjZhc3I0VXVTY21UdUdq?=
 =?utf-8?B?YktyRVhQaC8zbEVXeDZKSnlicW14MmZWeUkraHo3TXNoVGg1cy9IMmpUaUxR?=
 =?utf-8?B?Q0kwOSt3QXNIQm5GSmdSWjB4N2l6WmhJWTB0ejkrU0d1U0lIUS9NRDNtRU1v?=
 =?utf-8?B?MUpjZmFEaDhBaTd2UUMyeWJlcGNma2VGTkZQb1pEYUVuOEZZMUZpYVpXMmFz?=
 =?utf-8?B?bk1uanJaYi84YzBVR3RkVjNzTUprMnA2Tmthb1M4Y1RtMkRIOUx5bjh0Rnl5?=
 =?utf-8?B?Mlh3RENEK0t6TDNrcGFIR3dXVmF4QWdtaHNKSndSanFyQzVMSmVHY3BOczVh?=
 =?utf-8?B?VDZjWUhSMVNSNWxFOTRwK2RJNVhtTDg4SXEyRDhVK3pPSERweHV4a1Nzb1Zk?=
 =?utf-8?B?cCtYZz09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a49e23d-4b8a-4dfc-5d02-08dac402bf55
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 16:35:30.4899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d/w7nvSIHf1BncT7dRTqYODSzV3lJdQjMLSaux++zdVEP9wMCj1Ngj5wQvjhxSJz8a+IMu2H9g3CXNpIy1BQmJTDNUe09eSY5fBDMwW8cXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR03MB5630
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTEvMTEvMjAyMiAxNDoyMywgUGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+IE9uIEZyaSwgTm92
IDExLCAyMDIyIGF0IDAxOjQ4OjI2UE0gKzAxMDAsIFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+PiBP
biAxMS8xMS8yMiAxMzoxOSwgUGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+Pj4gT24gRnJpLCBOb3Yg
MTEsIDIwMjIgYXQgMDE6MDQ6MjdQTSArMDEwMCwgUGFvbG8gQm9uemluaSB3cm90ZToNCj4+Pj4g
T24gSW50ZWwgeW91IGNhbiBvcHRpb25hbGx5IG1ha2UgaXQgaG9sZCBvbnRvIElSUXMsIGJ1dCBO
TUlzIGFyZSBhbHdheXMNCj4+Pj4gZWF0ZW4gYnkgdGhlIFZNRVhJVCBhbmQgaGF2ZSB0byBiZSBy
ZWluamVjdGVkIG1hbnVhbGx5Lg0KPj4+IFRoYXQgJ29wdGlvbmFsbHknIHRoaW5nIHdvcnJpZXMg
bWUgLS0gYXMgaW4sIEtWTSBpcyBjdXJyZW50bHkNCj4+PiBvcHRpbmctb3V0Pw0KPj4gWWVzLCBi
ZWNhdXNlICJJZiB0aGUg4oCccHJvY2VzcyBwb3N0ZWQgaW50ZXJydXB0c+KAnSBWTS1leGVjdXRp
b24gY29udHJvbCBpcyAxLA0KPj4gdGhlIOKAnGFja25vd2xlZGdlIGludGVycnVwdCBvbiBleGl0
4oCdIFZNLWV4aXQgY29udHJvbCBpcyAxIiAoU0RNIDI2LjIuMS4xLA0KPj4gY2hlY2tzIG9uIFZN
LUV4ZWN1dGlvbiBDb250cm9sIEZpZWxkcykuICBJcHNlIGRpeGl0LiAgUG9zdGVkIGludGVycnVw
dHMgYXJlDQo+PiBhdmFpbGFibGUgYW5kIHVzZWQgb24gYWxsIHByb2Nlc3NvcnMgc2luY2UgSSB0
aGluayBJdnkgQnJpZGdlLg0KDQpPbiBzZXJ2ZXIgU0tVcy7CoCBDbGllbnQgb25seSBnb3QgInZp
cnR1YWwgaW50ZXJydXB0IHByb2Nlc3NpbmciIGZhaXJseQ0KcmVjZW50bHkgSUlSQywgd2hpY2gg
aXMgdGhlIENQVS1zaWRlIHByb3BlcnR5IHdoaWNoIG1hdHRlcnMuDQoNCj4gKGltYWdpbmUgdGhl
IG5vbi1jb2MgY29tcGxpYW50IHJlYWN0aW9uIGhlcmUpDQo+DQo+IFNvIGluc3RlYWQgb2YgZml4
aW5nIGl0LCB0aGV5IG1hZGUgaXQgd29yc2UgOi0oDQo+DQo+IEFuZCBub3cgRlJFRCBpcyBhcmd1
YWJseSBtYWtpbmcgaXQgd29yc2UgYWdhaW4sIGFuZCBwZW9wbGUgd29uZGVyIHdoeSBJDQo+IGhh
dGUgdmlydC4uLg0KDQpUaGUgb25seSBGUkVELWNvbXBhdGlibGUgZml4IGlzIHRvIHNlbmQgYSBz
ZWxmLU5NSSwgYmVjYXVzZSBiZWNhdXNlIHlvdQ0KbWF5IG5lZWQgYSBDU0wgY2hhbmdlIHRvby4N
Cg0KVlQteCAqZG9lcyogaG9sZCB0aGUgTk1JIGxhdGNoIChmb3IgVk1FWElUX1JFQVNPTiBOTUkp
LCBzbyBpdCdzIHNlbGYtTk1JDQphbmQgdGhlbiBlbmFibGVfbm1pKClzLg0KDQpFeGNlcHQgdGhl
IElSRVQgdG8gc2VsZiB3b24ndCB3b3JrIC0gaXQgd2lsbCBuZWVkIHRvIGJlIEVSRVRTLXRvLXNl
bGYuwqANCldoaWNoIEkgdGhpbmsgaXMgZmluZS4NCg0KQnV0IHdoYXQgaXNuJ3QgZmluZSBpcyB0
aGUgZmFjdCB0aGF0IGEgc2VsZi1OTUkgZG9lc24ndCBkZWxpdmVyDQpzeW5jaHJvbm91c2x5LCBz
byB5b3UgbmVlZCB0byB3YWl0IHVudGlsIGl0IGlzIHBlbmRpbmcsIGJlZm9yZSBlbmFibGluZw0K
Tk1Jcy7CoCAoV2VsbCwgYWN0dWFsbHkgeW91IG5lZWQgdG8gZW5zdXJlIHRoYXQgaXQncyBkZWZp
bml0ZWx5IGRlbGl2ZXJlZA0KYmVmb3JlIHJlLWVudGVyaW5nIHRoZSBWTSkuDQoNCkFuZCBJJ20g
dG90YWxseSBvdXQgb2YgaWRlYXMgaGVyZS4uLg0KDQp+QW5kcmV3DQo=
