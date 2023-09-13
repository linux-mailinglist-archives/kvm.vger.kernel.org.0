Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC1979E2FF
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 11:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239238AbjIMJKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 05:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239211AbjIMJKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 05:10:32 -0400
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D026C199B
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:10:27 -0700 (PDT)
Received: from 104.47.11.170_.trendmicro.com (unknown [172.21.162.147])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id C3A0710000959;
        Wed, 13 Sep 2023 09:10:25 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1694596224.727000
X-TM-MAIL-UUID: 25da8eba-f2c2-44c1-bd24-92b6ff1f724f
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (unknown [104.47.11.170])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id B1A361000156A;
        Wed, 13 Sep 2023 09:10:24 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irF/ziGz7tDK1g1d+e8S3aqTEOFV5OVpaMwwpD0RBd3bxsdVtyymOfnRgE7OUjEeX0K5zm8wS073IbMly6uwiyu51flZZWZZxv9kj/iHVi0rupy9lL6ynCIywhmoasoVml7ReJBGT0en4e3XfZKVf2SquN525vs3jo2Moy+Sdbr525ddbSLjoqQUgdMnWUIp6cc5+tmdDMMp8tz8qRulb5PmWYcutYsQD57Au8jfTz93HpORf179XxPDYaNlzBlHXHXWqVUZRwLOjTlZz3feuCjVWr0JKWNYrde/FJGgUbiwMz7dRAD3qWRBUeReOAr7GHOCCcvSTEBLPsHp9fDw3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jhpJlfcXFQ/f1E0AHSa7bkPqGijeEEFbBd9RMVcSLYc=;
 b=UVg6zYMwj1Hd3eHovT/Jz0ofXq+Oy93HwaKTUz0sXPvbU3zT2O9bSslHgAZPvLPvGDNQkFHljuTp67rjnFuPbT1U/XJ6wrgO/evSI0VXLKCa1kkPuMmoJ9oIhwTgk1LimDqa5/veqGAX7SV5rB7YJOEzY2dbh+rQz6FXAsyBXeChubXC1i5gVwjhwfIcU7zXV8zPZlx0CWTUtkN+pnur7/+kPzFRL3MfqczPwWEVHzj3QgbO0Jc6VBpQ9O2pVN6eLcXmMeq2qV1CqW5aPN/vd3nrl80LTAa9niEAV0PyO7G8LgpEcfuF+HTlFbMIR9svyLnzdRHVPFQt2h5c1AjllQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <8f669a0b-6d49-4a77-cf2e-692afc2a38e2@opensynergy.com>
Date:   Wed, 13 Sep 2023 11:10:21 +0200
From:   Peter Hilber <peter.hilber@opensynergy.com>
To:     John Stultz <jstultz@google.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>
References: <20230818011256.211078-1-peter.hilber@opensynergy.com>
 <CANDhNCo_Z2_tnuCyvu-j=eqOkvDQ+_n2O-=JKpf2Ndqx1m5GqQ@mail.gmail.com>
Content-Language: en-US
Subject: Re: [RFC PATCH 0/4] treewide: Use clocksource id for
 get_device_system_crosststamp()
In-Reply-To: <CANDhNCo_Z2_tnuCyvu-j=eqOkvDQ+_n2O-=JKpf2Ndqx1m5GqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0268.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:86::13) To BEZP281MB3267.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:77::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BEZP281MB3267:EE_|FR0P281MB2174:EE_
X-MS-Office365-Filtering-Correlation-Id: fc5b98c8-470b-4caf-9dae-08dbb4394312
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JvCoaOMkrNbOvx5KDJqBGB8UxoeoQ98wA11IVHVpr5zuC0NTK8HcvTWKDG5uf/L9X6eQHJh7D2VfVKxfuM08b46CYCpomZoYfGG3t6+e6ok8S/OGOmB9G+orGNNmKBv41waPid54yEMTz4ZpjADpp0aPn3U2IETSrrS6kutNqS5P1Wjhn5HiPByNVVB24lrtxWpPyZoPm+SUCb2yclOZJeid/Sxj8KF2B3ELgHQ9l90Mw3pJAV8GesaG2yYkAIvY2uvojnCqtHO6R/hIl8yWvRgzy+rQ4AfaWQQpJr3GkqZ9S4/SGp7Duaje99UUHwEDsfqRmIrpvoLunr/TGrmYyI610k9g0m83px07D9sx3SxMit99Tm3eGEQmkl1Ma7ckYOL6hVyEvTLNRRtN+IIJ2g0rzWFc40pMuj2kq27W8xEwgj+mwqOzk31qVp5cgYYPSkxAxTcJ4wVB3gTynmpouoWFYyvcG8V9NTRV4xcxUqWUDqrY2u7FDGc6kbNiy8mfNSMUwTWVyDphnec7wnpKa1N68PNpBJEffR2w8DkHqdU73+6OZNl7GbEbYo5LICfU8oZleZIcoExZ9CqABdbrWX1pbbhLVUTnmW6rhujLDeydyguhG+o0Sh1nnKRQrJpV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BEZP281MB3267.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(39840400004)(366004)(396003)(346002)(136003)(376002)(186009)(1800799009)(451199024)(41300700001)(5660300002)(4326008)(44832011)(54906003)(42186006)(31686004)(8676002)(8936002)(66476007)(66556008)(66946007)(6916009)(316002)(2906002)(86362001)(31696002)(7416002)(53546011)(478600001)(966005)(2616005)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGEzYy9jaTZrZEp2WFBvN0hWR3YwSjByeXlKbCtzY2IwN0l6eGpsL2JFaG9X?=
 =?utf-8?B?NHVDV1lwMlcyT2Z1Sm5KVTcveUtSTXhwUXJ4WEtUYW9xYlc0a2NxNGdMZWFK?=
 =?utf-8?B?ZEdaWkJCUjBCdzhhaXJUaVdBS3VvNk10M0x1Vjl0WncvTURDSVBpVXI5L1dw?=
 =?utf-8?B?TG9xWGswdXBRU2hkY3N3ZmM4cHlpS3lvRDdjMDU1N0JDTGtTL2g3UkxiK2FL?=
 =?utf-8?B?V2l3eUxYaGJ5ODFIbzdaaG5BbVkyQW9jcVFZaXRTM3V6RlJjbTF1NnBpTlNj?=
 =?utf-8?B?R21iTFZQa0NzWGtIOEtkN3kzcE13aktycTU0emN1WjVZV3hmMCtWUHlaYkVq?=
 =?utf-8?B?R2Q0a3lWdkRya21IUlppN2VLZVM4QkpmeEVFT0Q4UjFJRGgralg2NHpKbldS?=
 =?utf-8?B?d1d0ZlU0OEE5WE03Mk5zeFB2UXQ3dy9ZM3lxZytZcUpRVTVqdEJrWG0wbWdV?=
 =?utf-8?B?ZWhGR0hId2RraHdlanROcU1uT0ZGVnFVZWI5aXlISGJPLzVxdmZtVnVNQUV3?=
 =?utf-8?B?WnB0NEVkQXhwd0tzUDV2UE5YS2NoNis1ajR6SVkxbjZSb2VqODFqbEJaVzFj?=
 =?utf-8?B?eko3cExjc2Y3RjZJNXNHZmVscDcvOGxBSjIzNERDNFkxbmdnMTIrZzBMSUU1?=
 =?utf-8?B?UjUwVzBXNHZpc21wVXg5ZWxoWmswMjhSWlJvSExsbHBMdjZPWndzMnBIMitB?=
 =?utf-8?B?OXN2YUlNZjBTd0ErUFFVZzlTS2NPZzJ5UnJMaXhCdlVhdG1PUjYyYmFJcG1E?=
 =?utf-8?B?SVBoWHNCTll5VEJqTlJ4Um42aDM0Q01RaWJhS1gyK3pDSCtxeHJlN3hGZlRQ?=
 =?utf-8?B?ekdvS3JVcDYveXlLSElSM2VWZzQ2VkV6Ym83T21iZXZtY2RxK2dsUllncWhY?=
 =?utf-8?B?cnJqYWE0eGRMS2FkSnR6OW85UHBtOXVpMUlkNXE0QTFXcHhWTFZkYW1ONS9z?=
 =?utf-8?B?WEVHUzRXWVllSWpDVVM0ZzBpMXMxUTBmNTNwQTRUUDNFU3FhMnVLS255N0du?=
 =?utf-8?B?TmhnMzhiU2NDOUI4SHExamthL0xmMXFEaE5HQi9tbktWR3duSnhDUkYvWVRT?=
 =?utf-8?B?WlVHNjVEaDlWYVFtV1A2UnkrZUJSYzIrRERubE9kS3pNSFZwM0YwclVRamxo?=
 =?utf-8?B?enBiTnVHaXl4VGxNOERHOFZZalhSWXUwZ2xoM1dYSDlSQUMwY21KV2xuVzRu?=
 =?utf-8?B?Y3dlbHZhakV2WStkUG9rbkF1ZVlKSlJCV2s2RHRJNzUzMXUyYmNEUDQ0a0lz?=
 =?utf-8?B?Y01rVzliSFBVbW96cUI4MjdIZmRpdmZ0U09VWE1TdVdFMkhqK0NCeXVveWxZ?=
 =?utf-8?B?UkxpMUplK3J2WDlJdXFGbVdTejMxLzV2czBGSjdQRmFVRkUrc0VLd3Nhb0VF?=
 =?utf-8?B?K0Y5U1R4OWNxdDA2MDR4TDI0VGpacG1JcTNydEc4aHIxcXJ0YlFWUnFwRXRx?=
 =?utf-8?B?WXdzSk1JNzJTQVEyUjNiUG9XYzJzclBKQXRoam1mcUNJY0M5QUZEWXlxM3M5?=
 =?utf-8?B?b0kyNGpSTUYxc1ZqQkMyOWdnSGsyaHNBS1dzUGFYNmNORmcwb29sQzZEY09w?=
 =?utf-8?B?Nmk4MUNYN0dOUkN6VW1uMkhSN1RtcWk1Z25wT1EzQ05yb294N1o1QUpJaEVJ?=
 =?utf-8?B?bG51ZUV1ZkZmUzQ3eGJucEhhVVRoc3VVanlSOFRCY1JucUFYUXRPQ3l2QTMr?=
 =?utf-8?B?cDFDV3k4WGlBdGpmbENNZG5SczNrOFdCT3U3TVlEZFQzbHpadzRMekFVcHcr?=
 =?utf-8?B?SVdubWVMT3B1SURBYmJZYUU2eFVvcytpN1p2cU1MUC9vUm9LdTJod3lmN3JO?=
 =?utf-8?B?dzd5b1RlemZPSmhoSnh4Uk5mbnNxVlB0VEM4bEdDQ3Z0bHNCRStWRWNuWXc1?=
 =?utf-8?B?QUhQZVNYZjhUd0xZWmMwTVIvZ1hFL3doL0RVRWV3ZDlLSml1bFRVdXZjaW5E?=
 =?utf-8?B?a2U2c1htZCtuZmxsVDNKZURIbmRzNUdYa3pUdnRRNzlnL0k0TWN0M3RKV1pJ?=
 =?utf-8?B?eXBxVUxCL2o2SmZEQzVhR0VLSS9PVTU2ZkllZ0xaZGd3dW96b0wyZVFuZXNu?=
 =?utf-8?B?L3BYZ3Y5d1Q5OFIwQ0hQc0JuZ0JFZWFjdWlLNjA5c2xiNGlBTVp2MlhNajgz?=
 =?utf-8?B?T0NMVlYrTFdJYWFXR2NiaEFKVTFjYnR0UE14YTJHTEtBNzQzZytsNTFTOWdq?=
 =?utf-8?Q?ncP9ulGjoGZcko6emRRJK+DcvEURqZNQ1t2T9QD+QmwE?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc5b98c8-470b-4caf-9dae-08dbb4394312
X-MS-Exchange-CrossTenant-AuthSource: BEZP281MB3267.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2023 09:10:23.6582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l5myMFxVP9bXgdGkioG38GcEJ0L2Q0OyvLlmrmQJYUkq1R0iSbGylUgdewlZue0ay6C1v4VFCq/lzo+h5/XvqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR0P281MB2174
X-TM-AS-ERS: 104.47.11.170-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1011-27872.006
X-TMASE-Result: 10--13.865500-4.000000
X-TMASE-MatchedRID: vbSD0OnL8/I8JKpd6Kt6Son73EnA6dC3zipu6AMXhRUrwvLze83KAuIa
        26cVKu7ABf+oLr2yQk0+Q7n7SBm127sAQwsyoP9i0RneM2u5ms/riyrp6RgprerZB6IUDx4zfBy
        +dxnwrxhrYq2UPKuEJJB3uGqece3UA6J7qwYXtBIeIPbDQDiuhhJFEvBK54PatHyEPgw8ZA/R0y
        JhnGbpx0mHa2Y1urEIKTLwffkyTWkAsgl6PZgqJIlaRcdIl09ElIhi5GPAGePROZXiimkAmvzC1
        lcNJt+s0c/H40eLBxa1D3W0JQRvwqiD/iwt7DmUBe3of2xuKvhHIblJJHuYwXOLzPYW+Cj678UG
        MLhJh5HRXenBNWkRkmwrN+VXzn9BmCU9hDj/cFWUQk7vSq1TtnJ8bM38R9gpJsfJJdVp3fqvngk
        jHjojpLjxouJb9uKcTWwLp7YEOWY58Sarp97J825FeHtsUoHu65FJey0jmuw65ScPZSDr62fRKm
        DC4qbM0XbzBFAbQfVfCOKFKuVYGg==
X-TMASE-XGENCLOUD: bf6034cc-ec33-43f7-9963-3fe3916678c7-0-0-200-0
X-TM-Deliver-Signature: A6A2F9A313510BCCE2ABCAD8D52129E8
X-TM-Addin-Auth: beYAjVFrxBfaEb6/lCPDp/kyDDK5nWYXuoYuZTlNVFGjzEu8+zj4r/R9Gos
        faG4WbfRM6nyuU7OJSSI6vxtTpqmh/eCe1JyGG9I1dQ6zZaILSncmz/+Bywgid1nuYH39zlya8A
        PuC6xRo5mWAI+eJAtRGEqx2CRPCrC5b1nqLY5bxq6aOQHwLM69XXE8RvDQ+DsO0liD2dldpf7+G
        VgWgKAKzWyzttvYu37PBXVnp9L8fJbaY6AKFJZk3t1h4zn1nn1pG0NxB2VKM5ZzaUr/gaXbq+kn
        X7/TrD0AQ4HX+Vw=.w2mWd1qsgE7EB3RJZcscOZ0KsfSaWb5eujvu810SI/dEdIVz8uOL/vnHMv
        juI+5v0WlqLA73BN3dUj+qDxIjH+cu7j0AGcyOlUjZrchywLwnvOBBfccM3gAfrzfoMWCvzwhUt
        9gt638jVicfO+LOxbk8M90znKHojGr7LvlkeRBUUP7FzwrVgURMuJL5X63cR+F/JJ6wr67VayoC
        mLGaE2X+ahHt3B/be8gK5oh2u3+ENEQ9n5tm/Fh+4G8W6trF7dVWdhUk5uNI/q2We6du0wjcrcy
        tVxiBDLBk0ULxTaUlePBQVI02EQsobLv37Ohn9KIwvsI7bdJ3Efq71RetYQ==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1694596225;
        bh=2Dn/xxZPfbXZzE09+h7llvwCzPFS48yjmrS+IzNG0ok=; l=4391;
        h=Date:From:To;
        b=FIpgL97XA12nfkxJ8Py9CgYg7KbpI/YwE+2p8cD7r1zZuoWdQnoLlL4tvr4FhoTOr
         N4GqNcnyAimuyYd4t2ei0PCFrhF2lLnpX+P50yZoo1qQTJNm8oIBO5Ky7OpKf9Xr/P
         Yj+TG31imCCVPIZ26/zbHqSrpxYmF4sPdCYJcUcxUZ4WqEjeHYhn8h/7QB6GiUXkme
         UaA0/dMgnEwRZOf74a32EneyJNzU3HJjUL/bcfsbX3YdjtbbxoNp4WYucIqKgJpuQO
         mOQPrCLq8Fub+gUr7cCMAIjpw8ECZMJ9sqkR42nVP1PLgUK7PBiN4pno5E3Xy8VzOb
         OEI4FXq5AaYLw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023 6:18 John Stultz <jstultz@google.com> wrote:
> On Thu, Aug 17, 2023 at 6:13 PM Peter Hilber
> <peter.hilber@opensynergy.com> wrote:
>>
>> This patch series changes struct system_counterval_t to identify the
>> clocksource through enum clocksource_ids, rather than through struct
>> clocksource *. The net effect of the patch series is that
>> get_device_system_crosststamp() callers can supply clocksource ids instead
>> of clocksource pointers, which can be problematic to get hold of.
>
> Hey Peter,
>   Thanks for sending this out. I'm a little curious though, can you
> expand a bit on how clocksource pointers can be problematic to get a
> hold of? What exactly is the problem that is motivating this change?
> 

Hi John,

I'm very sorry for the late reply; there was some unexpected delay.

Thank you for the remark; I'll expand on the motivation in the next patch
series iteration, similar to the explanation below.

The immediate motivation for this patch series is to enable the virtio_rtc
RFC v2 driver [4] to refer to the Arm Generic Timer without requiring new
helper functions in the arm_arch_timer driver. Other future
get_device_system_crosststamp() users may profit from this change as well.

Clocksource structs are normally private to clocksource drivers. Therefore,
get_device_system_crosststamp() callers require that clocksource drivers
expose the clocksource of interest in some way.

Drivers such as virtio_rtc [4] could obtain all information for calling
get_device_system_crosststamp() from their bound device, except for
clocksource identification. Such drivers' only direct relation with the
clocksource driver is clocksource identification. So using the clocksource
enum, rather than obtaining pointers in a clocksource driver specific way,
would reduce the coupling between the get_device_system_crosststamp()
callers and clocksource drivers.

Next, I provide some details to support the low coupling argument. There
are two sorts of get_device_system_crosststamp() callers in the current
kernel:

1) On Intel platforms, some PTP hardware clocks obtain the clocksource
pointer for get_device_system_crosststamp() using convert_art_to_tsc()
or convert_art_ns_to_tsc() from arch/x86.

2) The ptp_kvm driver uses kvm_arch_ptp_get_crosststamp(), which is
implemented for platforms with kvm_clock or arm_arch_timer.
Amongst other things, kvm_arch_ptp_get_crosststamp() returns a clocksource
pointer. The Arm implementation is in the arm_arch_timer driver.

When I proposed in the virtio_rtc RFC v1 patch series [3] to obtain the
clocksource pointer of the arm_arch_timer driver through a generic
helper function, one of the maintainers wasn't very enthusiastic about
it and suggested reusing kvm_arch_ptp_get_crosststamp() somehow [1]. But
to me there seems not to be much in common [2].

Quoting myself from [2]:

> If[!] &clocksource_counter should not be exposed, then I can see two
> alternatives:
> 
> Alternative 1: Put a function of type
> 
> 	int (*get_time_fn) (ktime_t *device_time, 
> 	                    struct system_counterval_t *sys_counterval,
> 			    void *ctx)
> 
> into arm_arch_timer.c, as required by get_device_system_crosststamp()
> (and include a virtio_rtc header).

This looks inelegant, since it would require virtio_rtc to put part of its
code into arm_arch_timer.c, and would require including a virtio_rtc header
in arm_arch_timer.c.

The second alternative is using this patch series to expand the use of the
clocksource enum to get_device_system_crosststamp(). This should also make
it easy to use get_device_system_crosststamp() with other clocksources in
the future, by just extending the clocksource enum.

> I just worry that switching to an enumeration solution might be
> eventually exposing more than we would like to userland.

ATM the enum is not in a UAPI header. So IMHO exposing this to userland in
the future would require a pretty explicit change.

Thanks for the review,

Peter

[1] https://lore.kernel.org/all/87ila4qwuw.wl-maz@kernel.org/
[2] https://lore.kernel.org/all/151befb2-8fbc-b796-47bb-39960a979065@opensynergy.com/
[3] https://lore.kernel.org/all/20230630171052.985577-1-peter.hilber@opensynergy.com/
[4] https://lore.kernel.org/all/20230818012014.212155-1-peter.hilber@opensynergy.com/
