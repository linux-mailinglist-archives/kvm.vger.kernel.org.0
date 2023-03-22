Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648406C53B2
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 19:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjCVSZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 14:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbjCVSZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 14:25:39 -0400
Received: from esa3.hc3370-68.iphmx.com (esa3.hc3370-68.iphmx.com [216.71.145.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B874298E3;
        Wed, 22 Mar 2023 11:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1679509537;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+aWEUlLY991KOE/jatIknYzKcMT6yfWEkcACDKnjmw4=;
  b=aKqO7ElVbZ0NC+GzcFaPEXEoadCMnqJFDRD6emnKeL2yW5VgLYiS+wmJ
   VxuwJs1FI8j/itm5hwWCL+vJ36P3edk/Yyrw/akJxtK5gQ+IqT0oyOpb4
   NqWncWQOC6jF63AkHFZAc0utEKxSSRUzKgY22s0xTMvzqPyjSJlJ+UwXp
   M=;
X-IronPort-RemoteIP: 104.47.56.172
X-IronPort-MID: 101915405
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:+pj1Uq6RhlwfJBCX1R9AoAxRtDLHchMFZxGqfqrLsTDasY5as4F+v
 mFNWD/QbK2IYGL2fIp3YNy3ox8DuJCGzd5iHQA6qy02Hi5G8cbLO4+Ufxz6V8+wwm8vb2o8t
 plDNYOQRCwQZiWBzvt4GuG59RGQ7YnRGvynTraCYnsrLeNdYH9JoQp5nOIkiZJfj9G8Agec0
 fv/uMSaM1K+s9JOGjt8B5mr9VU+7JwehBtC5gZlPasR5geE/5UoJMl3yZ+ZfiOQrrZ8RoZWd
 86bpJml82XQ+QsaC9/Nut4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5iXBYoUm9Fii3hojxE4
 I4lWapc6+seFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpdFLjoH4EweZOUlFuhL7W5m2
 /YqDiwJMy2/wOOm3pCddeRhouEnI5y+VG8fkikIITDxK98DGMmGaIKToNhS0XE3m9xEGuvYa
 4wBcz1zYR/cYhpJfFAKFJY5m+TujX76G9FagAvN+exrvC6Okkooj+KF3Nn9I7RmQe18mEqCq
 32A1GP+GhwAb/SUyCaf82LqjejK9c/+cNtKTezhq6Iy3TV/wEQiCA9KTGCxqMDmrU6OA/BGO
 WUl8zgx+P1aGEuDC4OVsweDiG6FuEVaX9t4Eusm5QXLwa3Riy6bB2ECQSVBYdoivc4eSjkj1
 1vPlNTsbRRvqLS9W2OB8a3SpjS3UQARLGkfdWoHQBED7t3Lvo4+lFTMQ8xlHarzicf6cRngk
 26iryUkgbgXy8kR2M2T/k7Cqyyjq4KPTQMv4AjTGGW/4WtReIGhd6Ss6F7G8exHKoeJCFWM1
 FABms6R68gUAJ2NnTDLS+IIdJmj/96MNDzRhw4pE5RJ3zik5XPlfYlW+zx4DENoNNsUPz7vf
 ELX/whW4fd7JHa2YLVlS4O3Bd4jwaXpGZLiTP+8RsFDa55zfyeI+yZhYUPW1Gfo+GA0m6Y5K
 5adcO62AHoaALghxz2zL88H2KEqgD543mPaQ5Py1Tym16aTYDieTrJtDbeVRuUw7afBqwKM9
 d9abpKO008GD7e4ZTTL+4kOK1xMNWI8GZ39t81QcKiEPxZiH2YiTfTWxNvNZrBYokicrc+Ql
 lnVZ6OS4ACXaaHvQelSVk1eVQ==
IronPort-HdrOrdr: A9a23:sc8KRav99CyJ8qfIaS0C1TE97skCpIMji2hC6mlwRA09TyXGra
 2TdaUgvyMc1gx7ZJhAo6HnBEDkex/hHPFOkO0s1NuZLWvbUQiTXeJfBOnZskTd8kTFn4Yzu8
 ddmsBFeaXN5DNB/KHHCWeDYrMdKe28gduVbKrlvgRQZDAvT5slwxZyCw6dHEEzbA5aBaAhHJ
 7ZwsZcvTKvdVkec8z+XxA+Lp3+juyOsKijTQ8NBhYh5gXLpTS06ITiGxzd+hsFSTtAzZor7G
 CAuQ3k4aeIte2913bnph3uxqUTvOGk5spIBcSKhMRQAjLwijywbIAkYLGGtCBdmpDQ1L5/+u
 Osnz4Qe+BIr1/BdGC8phXgnyP61iw11nPkwViExVP+vM3QXlsBeoB8rLMcViGcx1srvdl63q
 4O9XmerYBrARTJmzm4z8TUVittilG/rRMZ4KUuZkRkIMYjgYJq3MUiFQJuYeE99RvBmfca+T
 xVfYnhDPU/SyLkU5mWhBgi/DWWZAVOIv63eDl+hiWr6UktoJlY9Tpo+CVNpAZxyHt6cegx29
 j5
X-IronPort-AV: E=Sophos;i="5.98,282,1673931600"; 
   d="scan'208";a="101915405"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Mar 2023 14:25:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jffI+IC9t1ZMAR4nYb98v5KhpWPfMbbmxEOeRAmUjnL0rYUrKauVqZHf6a61DtuZ99OwqsEd3TCT9QHW80HCISvmnShmHFCdhEBH8p/YARcOs5K7y0LfHmzOX8Bpqfa86VCQwlKme3VT0rs/0zMsJFlhezGDPoEKiONwwUzIq7+RjbqKnPRa0ykmjy8X8Kv2Lk4ePZtuSDb8wNgTvh3FXuxK0wqrOpi67hsuNr+pObj6jTIOEBrCuFoFeba+gFTu+owupjepQ5SB3JbubxdnXl2qUnHt33xEaVFjWOnGiIQFK0jTsCfaK1ol7v7XWrKR6CzQxJ2Q+sOPQ0bPbD56iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+aWEUlLY991KOE/jatIknYzKcMT6yfWEkcACDKnjmw4=;
 b=B+IuRIR4TmoCOjLBI0LJe9A247HhyriBC+PGjBJFm18YSgouR7KhMZWVqEDEInCmcjEDeWrnivFTNZ7YoEL25xsSfZq9RKi5udWBt5xVgYJP9yYO3sU5nG2lhqv9ZvKRuy8tSKecldkUgwL5MVb+9Ls0dxK2YIUZVhESWGxIdJxc1A+pfHj7c+FMXtbs9Y7LitTzqpjELgmvQ2cIKqJwuKJ66lKAZDoAoznWN88YuYN3sCrN8LU9/S9E8O9shBz7+sHy3uo0/3tdnEp3DEsApuEoLsZRxsk1Cif+WN0FU/gOoa0orlRMJz/xUk3s11BMgGbObFMbsU7We/1GZIK+Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+aWEUlLY991KOE/jatIknYzKcMT6yfWEkcACDKnjmw4=;
 b=ROmQgSsOgt0XGkdxBJqDbRXDrK3pEiZ7C24zTnSCX4T+UszScoq/Oi6BOwfKoJqy6XpYDd512hxE5i/hiwmKw/ri5KXPvCh5uuw4mxUyBGdCEaQKnZTtm29EEwIgu2k3zp1+pfVy2CFtqFlhsH3U77KWXHkBvF3R4a06xVw6Fk8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by CH0PR03MB6020.namprd03.prod.outlook.com (2603:10b6:610:bf::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 18:25:33 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::8299:f95f:934b:29e8]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::8299:f95f:934b:29e8%7]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 18:25:33 +0000
Message-ID: <3e76f5c2-8398-0be6-f8ac-c9a2b04f551d@citrix.com>
Date:   Wed, 22 Mar 2023 18:25:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v5 22/34] x86/fred: FRED initialization code
Content-Language: en-GB
To:     "Li, Xin3" <xin3.li@intel.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-23-xin3.li@intel.com>
 <CAJhGHyADXz-3PCFS3M_7TJ8qLGJ=4NcV9aBWrpjemuXB_SnMGg@mail.gmail.com>
 <5D679723-D84F-42F0-AD8A-8BD1A38FB6CD@zytor.com>
 <CAJhGHyC0_1xJD2R03-NoRVpMXFTHR4v8CdzyJOZe_k0rdv=NfQ@mail.gmail.com>
 <SA1PR11MB673486AB91F77B468ED1BD82A8869@SA1PR11MB6734.namprd11.prod.outlook.com>
In-Reply-To: <SA1PR11MB673486AB91F77B468ED1BD82A8869@SA1PR11MB6734.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P302CA0015.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::11) To BYAPR03MB3623.namprd03.prod.outlook.com
 (2603:10b6:a02:aa::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB3623:EE_|CH0PR03MB6020:EE_
X-MS-Office365-Filtering-Correlation-Id: a7b63c5a-45c0-44cf-c1b2-08db2b02d2e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uS6rP5zn4bIi7PvKSbeR1CbicG+eG3+aDE5UXFff2PwnaT8VB10bkmR148Jf/Hv+g5Fe8lbYA+BEM4xu/7VXqPIvzKVcqRORbcPeRr1XkRXYqjF0dfaxi6lEtT810jOx5Gr68+Et64tBcAI+kqPOnxIimOPY4Yi3WMZZ1jeD32mv91EN6G6pEX6Cb16oLeT4q1r+k4mt6JAojv4preq+AozKs5o2us8S4Y/TBjj8d1uCT3gkr7jqgrAGgb1IEu+9wyIYuiIzM6rWjhW+Q5eQc8MyOquhJ6Cov7vxIgYBFrtOli5sRCV5h2K5WbrFA0uvv2+ickDDWgFzBxceS5IzCG8U30JuC/van4MRBlqmvL87MlJUIWFrB2AUsFQS/2syMyTiqs1cUM/rGeWmsf7sl8sQHvOSQfByCbqVwgtaUaAO3C8YAL/Wp/1eq7u9TtyxJpOgW/Di/uInSYKqHeDgbWq/2b8e3NHxSXeYwlcRbYUAXHlwxrjP5SBAYCXVS8uqsLn2I1FhxesO7yRNl/IRv3vE6A7bNrSNamWDBXF5LjEPJVZPtJAI6maD8cuhc1I7VL8MUx4+Egc0K6CS+mUy6D3vm+/JOZr+qhl04Xq4FdPfjwwH302D2YZQu2dsph9ta42kZCL7F/2nR6FiqhMu9qQVkRk8+XKZerJLQHnPL53zxYJLxhl4gedIew5KIsMhzlSYLXQpjK/ygJ/ovs9PV0vxc94HHE+X8ghmztYpYWM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(396003)(346002)(136003)(366004)(451199018)(54906003)(2616005)(6512007)(82960400001)(86362001)(31696002)(38100700002)(26005)(110136005)(8676002)(8936002)(36756003)(66476007)(66556008)(2906002)(4326008)(4744005)(66946007)(41300700001)(5660300002)(6506007)(316002)(6486002)(478600001)(53546011)(186003)(83380400001)(7416002)(6666004)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUd5RURXM1NxeHA0NWtTajFrOFBvSmxhN0RHalVlVHo3MnZlTkV5ZVRFNnNr?=
 =?utf-8?B?N3daa0ZROHBkNDVFZVBjYlUyMmd2UjZpUzNJWFBHeUVBZlRGSWc0SzJGd0Jp?=
 =?utf-8?B?U2h0WWVwYkVsVnFML3dVVFB1Nit6TStCZUh4V1VqN0NrbVhOY0pxRHRXZm1D?=
 =?utf-8?B?aVBiZmE0bXd0SGlJK1F0VVhGNnNCenlTZW4vZTRha2xha2U4cTc5Zm1wSFBw?=
 =?utf-8?B?aHBiSU1WWlNrMk80WHpBSnBISkhQQmppUU1XWHZvWmw1OWlnWmFqL1pqTzMr?=
 =?utf-8?B?a05tTUh4UURzRC81VXRQSXVrT1dPcHBBZFg3NEJQNHNIeXVFajVuRXgwVlFn?=
 =?utf-8?B?ZHJLd3pKV29SUFZaWHkzNnd1eGYyRVp3Wnd2eFU3TXBMZ2NJRG1zWXBlOHA4?=
 =?utf-8?B?MjJuczhiZlJPdTVna05vMDhJbnFwcTlQbzdubFBRajlWb21OWTZLZGJkeU9Y?=
 =?utf-8?B?TXVvdDZnUlJVNVA1cXAwR1VwdDd5dXhxbnZyakduUHhpeVBzS0kwak4rWXFS?=
 =?utf-8?B?L0Z1dGF1T2FUaCtibnRjWEluYzdBb0ZCbnJjMHJrakM2K0NZa29pSHFDVWtw?=
 =?utf-8?B?VFRHVitHYnBvM2hSOHE5Q2tVcVI3amx2RHV6TDlPdEs0Z05yOXpTWnkwRHFy?=
 =?utf-8?B?SVIvODBSMzdoZU0vZHFQRW1hTWcwcGd5OER5VDloeUc5SUR3WmlCb2QwNEFS?=
 =?utf-8?B?K2V0MW41UndXSkpWVHhyYXNvRXJEU3pxRHhYcmZIVWQwTllQSnQ5Tm9rVHJo?=
 =?utf-8?B?VXNBd1hPei81VHgydWNYaTNOaUlqaUVMRG1aelkwcTlxK2xsZUQ5OXZYV1Av?=
 =?utf-8?B?Ylp1YWNTT0QyYU16NitEbnVTZjRvdllvUXplaVFmcXBMN08wNXF5MFgzRGpx?=
 =?utf-8?B?NXNiT3NuNUtFQzhLVWFOUjBqeEd5TWVOUHF5a3U1QTNBWXgwL2dzUjAzbHA2?=
 =?utf-8?B?cXVTaVBFeC92a25ISG5XWkhjZjNCRGdnS2dzQkhCUVJMMU1KYjFHWjRRRVVE?=
 =?utf-8?B?WURBZEZlaVVacU96ZFFDdVZNb2JpZ2dub1QwcFlzNldyYUNoOG83d0U3TUZ6?=
 =?utf-8?B?Y0JlbWZjRVJlMmQ5OExPNTZDcTBZVEVjNzNBMGN1N242bnMzaWJhSnlLQVhC?=
 =?utf-8?B?ZjNKVGJFZkMxNjBKV1oxbGdLQmNkb2pYYk9ja0ZWUjBpMGw5R1hPTmlZYU1P?=
 =?utf-8?B?bkFNTnVmMDc5d1Z6WWYydmVGaElMSFFnVDJaZGtLM0RrR3J4S0pScTRSU1Y4?=
 =?utf-8?B?ckdqSlpQS01ETDM4QzFFWmFZeHlDMmQvdE01Ri96TFdtUVVIMm9rUXJrcTcz?=
 =?utf-8?B?WTVVUXkxRWFxM2t3UDA0cmpjbFFkUFV1bzBmTTNUaW4wTi9DRko4S2NqbDhw?=
 =?utf-8?B?Wk5mQ3J0R0ZLOHZFQ2lPZkdjNEM4cXF4ZVVKMUJQYkdnMm1lay83YURkbjZN?=
 =?utf-8?B?eE1CQkdlY0t5RUdEeTR2MlVTL2NsdWRaR0FTYVJkdklWVmJIcENjRlVrZG1o?=
 =?utf-8?B?Rld5TnpwNnFnSWg2WklhUkJ3bmNsV2NyQkFBRE1BMDZkdXdPR003RHExSk81?=
 =?utf-8?B?bmZpUlgybmphaERnSUhJUFRCck1CMndTWE5IREUwQ1A1NEhORHIyMVZGSlpv?=
 =?utf-8?B?TmZaSkZQbDRJZWNNQ2dUckc4ZFFaZWMyRFg5cndKMzdLK1l6dEFQYU0rbDhE?=
 =?utf-8?B?YU5kRTdtSjhaQnAvM2M3YXFRWXhaNHpvbVBMVWlNNVJCR2FseDZUbnBEOEVs?=
 =?utf-8?B?WEl6WDR2TmZjai9ERmM4aExyejA3UmgveitjVjJTYThGMFgrZHd6cFNWWWND?=
 =?utf-8?B?OFNhVmFibnU5dWhPWmNwSFB3SmdiWjdiTy8xSlRqaEp1Nit0aTNzQXVPL3Jv?=
 =?utf-8?B?VlhuTDI3VGkrR0RXSkdEN2pNNlZ1dHZ6QkxkeStNcmlqY2h1ZW95RFZ2OWVq?=
 =?utf-8?B?M0lva1dqMDl3UEdJbFBmdy9BeFlTVytMZVhwdjEybmtPV2hncS9KR1JhQzc3?=
 =?utf-8?B?aU5rdStSank1UDRxMGZFMndWQnpUV21SMitxdXd1K0ViOUc2eExHQTRQRU94?=
 =?utf-8?B?UmVjNVkxQkN6WGRibmwwSjNEcGRRK1R2Y3VPRzBBK2lhY3VWWm1jdFdLQmJu?=
 =?utf-8?B?RllQSlkvemFDdVh1RGZ3L1g1ZFN4U3NvNk1KZ08zTjZjVWU2YnZTQzNiajB2?=
 =?utf-8?B?dVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Q2l4dStrSnV3alBqRWw1RGxXbUQxcFMzUjFHa1Bodk4vZVprRGJEUmgzRDlm?=
 =?utf-8?B?SGpKdk0zcHRCTDluc0k3QlBaYnlHaGd4ODdZQjJMVFZpblZRbGI5OVRwR2JR?=
 =?utf-8?B?bDBXcHB5QW1Vc05haFFQVlF4aXRVU3I2Z1FGZkkwaEJGck1abTg0VW42NW0v?=
 =?utf-8?B?T0VobXlJMUgrSVlYeU9jNnM2dUtzemkxb0tiOUJKWHk5NDFuaFl3WGxSMUlU?=
 =?utf-8?B?UEZPZlExYmdNclI1RXA4bGZuWDFoM0g3Q0t3OEN5bUxOQXBqWHA4RGhZVGNz?=
 =?utf-8?B?MUNmK2N5cDVZMWxWbnFMMGFpWlpoc3hxVjg4amJRRm1zeVRXNm5hT1BrK25J?=
 =?utf-8?B?bERNaERyd0ovRC9vclJnN3RNMmJhblQzSEdQa1h3a0dIQi9lMVU0VjlCeWU1?=
 =?utf-8?B?cjVhTWNaaVQxMFNzRURPUVpmSC9ZUFZZSlRJdEg5VUt4c1dwejF4emNYNVZS?=
 =?utf-8?B?TE9UZU54Mk1JWXd1Q2xQanJsNWdRMmdoUlRoOVloMVNCV1U2YTE2M05idFND?=
 =?utf-8?B?Ui9VSXNzN1lxaGdpcUtCSW5NcDlTdW1PRUZwb25ST0NjNXRJRkFtajZmZzU4?=
 =?utf-8?B?U2Nla0h4cWg5QnAzaWd0MDRpZG9KcVJnMXRqZHAycmlUYjVKVmIvR2x4bi8r?=
 =?utf-8?B?ZEpGd0dwZkpFNEJzdzZwVDlINGdrTXkyMlY3YkVaZkR2RjErV0xGbUN2WFF5?=
 =?utf-8?B?RHR1NzhpdDUvek9TSC9DeDlHV0hRSGdrTWJzTHlRdXRyWi9ZVGNyWk5wRW1R?=
 =?utf-8?B?Q0dCeFFWYTNvdU5maHgxZ2VHZFhNbzZYR2h6TDZnVU9YVWVRWGhYYTdib2kx?=
 =?utf-8?B?ZnY1SDFOL084c3ZqYTh1RHN1TkptaXFCTFMwYVZGQko0ZnYyckNyS3UySzY1?=
 =?utf-8?B?UitkYXhtRUtmdFdJdlRxSFlBRXZpQTN1S1JFcTIrbXNEc2g1SVgzaHdQZzJw?=
 =?utf-8?B?ekVEdTJjZHAxcVBYM2FLQkJFdnczWi8vQXU2NkhKMndJMWpwMmN3eEFPR01T?=
 =?utf-8?B?MkNuNjFUS3oweUhTbWc3KzNhOGpaME1MdHg2aXZyeElRalJ3WTl6Q1lxR0Zu?=
 =?utf-8?B?d2VBQmdiUlVXSnJhZjBnSmlWait1dWd3L2FuSU9mZWxDZE05Ym5IbDV5TnNz?=
 =?utf-8?B?eDNiVHlzRXIxSC9uUjBJUWN2NGpwL1lmdFV2bzdGK0ZrOFRsYzRHa3BLc0Rm?=
 =?utf-8?B?aGdkOUFZazh2RG12UnZ2ZDRQUHM3elg4aDIwUWZXdFdObGNrekVMLzJsU0py?=
 =?utf-8?B?dFZIU2FkRXFQbXpmcSt4bmFXLzZMaHUrOC8yQ3BOaVlDaCt1Q2swRFRCT1BM?=
 =?utf-8?B?WFUrR2VaME5XM0g2WTlMV0xkSUpNRHZSZXhRTmdqNHhKcGdRLytPSXA4SGFE?=
 =?utf-8?B?aXFtbVc1WlNCRm9lOGh5Y1YvSDJiRllqN0djbDBNY1dRQXJ4UUd5YWk3UnU5?=
 =?utf-8?Q?zuIzEB1b?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7b63c5a-45c0-44cf-c1b2-08db2b02d2e3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 18:25:33.4877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vbj1p8X+3EDWJoIU1bOtbLg7lnI0TXaphyXY6TzqsHw5Dz19wHs5EhWa5Em7yOmMci9td/PCPOe4JltEwSb7aR1uMT7Qtje5EnUTtZyh9Yo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR03MB6020
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/03/2023 2:22 am, Li, Xin3 wrote:
>> If there is no other concrete reason other than overflowing for assigning NMI and
>> #DB with a stack level > 0, #VE should also be assigned with a stack level > 0, and
>> #BP too. #VE can happen anytime and anywhere, so it is subject to overflowing too.
> With IDT, both #VE and #BP do not use IST, but NMI, #DB, #MC and #DF do.
>
> Let's keep this "secret" logic for now, i.e., not change the stack levels
> for #VE and #BP at this point. We can do "optimization", i.e., change them
> later :).

Fun fact.  #BP used to be IST, and used to share the same IST as #DF.

This was spoiled by CVE-2018-8897 and a MovSS-delayed breakpoint over
INT3, at which point hardware queued both a #BP and #DB on the same IST
stack and lost program state.

There's no need specific need for #BP to be IST to begin with, hence why
making it not-IST was the security fix.

~Andrew
