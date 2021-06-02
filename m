Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B74398962
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 14:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhFBMZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 08:25:57 -0400
Received: from mail-am6eur05on2131.outbound.protection.outlook.com ([40.107.22.131]:2273
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229734AbhFBMZ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 08:25:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFpyWg+NCLz11e99i7U2LQeF7iEKSKeS85M4hgS4+sqDcPW7ayY3qQhHerK1clvkv9u4lVbc2X/tpAlADCDpmeGuRunEpbhEaNpP26W4SYTHMWaKj3nseB3M9rz3n8+UYyMCjHgzMR+f3mfVeoF4mSdfM2sBd2KYZPoQ3Az0thConLr/QtDCO0ydpPE/xtXy/63EwrxA7PardQw95nYTLN+WV+9Lx+mXEpddsn5pbR5KDuN5sI7aNkTouhdymgIfjyxMgOfjVcOERdsIkLuTosHFGaXJrWmh70JyV2yakCR5p1z0EC2vpo3nrsWEWOsNB6dipAJyO+GdkZ6hGYRx+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWc8x+ZLPG6ZQ70r2WlsMpimjmeLiUcTNW5NUBOG/7Q=;
 b=CKtNuuWvGMZJ2oxrxqZAUtgbR2NOAsojJiU87lgMz1i/Lz4FmzVUNfs42lelwZPUcxotTDM4xwa5qegPgEyAcazgqQF9uMONhBDUOA5GGPBMShuiW5C00soNsyKWi3S3pNV9F81IamG49HV0pT957hqmwhFVXo9gAd/+qSDGaxaBRonC5x6FgrT6AVVmHv9tc8IIc5YJVZRZg1vY3/3V+ihORlUi6C0eG2XfFEgxWB2zmC7XqmXntlZig6eA2/IpjLDB6rVDG3lMgpmSc2nc5luoWgW1lshItw96WPxhbuGBYYAjM5vmKCHnXz1PN3BsYP+etCw9reyFp+gi2MAFZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWc8x+ZLPG6ZQ70r2WlsMpimjmeLiUcTNW5NUBOG/7Q=;
 b=XkjGZ03urfmyaToJSnmucqW9uP51IZ2Ahiwz+Whh0UPzzshT/4Kyt/MUYG4NLZ+845TF+C5Ue+smkJspu0AWlDsUL9tM7jJb91TMQrn6ZS4DxyIR+lZYwkOdRk4Ow1HLuS4HfBpqeW24klXLqQ4nDbBCEN8c0P0nDE73bfYRATY=
Authentication-Results: openvz.org; dkim=none (message not signed)
 header.d=none;openvz.org; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM7PR08MB5494.eurprd08.prod.outlook.com (2603:10a6:20b:dc::15)
 by AM7PR08MB5494.eurprd08.prod.outlook.com (2603:10a6:20b:dc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 2 Jun
 2021 12:24:12 +0000
Received: from AM7PR08MB5494.eurprd08.prod.outlook.com
 ([fe80::f928:f4f2:77c0:74b4]) by AM7PR08MB5494.eurprd08.prod.outlook.com
 ([fe80::f928:f4f2:77c0:74b4%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 12:24:12 +0000
Subject: Re: [PATCH v8] qapi: introduce 'query-kvm-cpuid' action
To:     Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>,
        qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>
References: <20210531123806.23030-1-valeriy.vdovin@virtuozzo.com>
From:   Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Message-ID: <f77db186-c553-e618-7f18-475fb943d389@virtuozzo.com>
Date:   Wed, 2 Jun 2021 15:24:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
In-Reply-To: <20210531123806.23030-1-valeriy.vdovin@virtuozzo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [185.215.60.211]
X-ClientProxiedBy: FR0P281CA0082.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::21) To AM7PR08MB5494.eurprd08.prod.outlook.com
 (2603:10a6:20b:dc::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.100.8] (185.215.60.211) by FR0P281CA0082.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9 via Frontend Transport; Wed, 2 Jun 2021 12:24:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55f76bbd-c6e0-4b5b-b074-08d925c15450
X-MS-TrafficTypeDiagnostic: AM7PR08MB5494:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR08MB5494E353F70C5EA0D5454D02C13D9@AM7PR08MB5494.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kkJ5kAFqjhEVe3zlZ5Di99hLa6RLESkQGZkS8l871H2/9gIiD2GNDwaRE8z3qGzqb8XZfjHgfYdMonmE5oPfNGuWjfatzhsm/7NPvvxFYxQVIIj5paw3svRwv/Bz1dXf2Bvd40ST4BiKST/gPNfOrY8q4j7V+semQCvB4hkkf7TaxSlAKET6K6h0dYnFAWJ16187COrNvOgyiMlwjj9BXST+9CWX6FS3/OYZNnoch6xp8eknQiCsXD0TnXKQbSU+YGIOm764nBhQYALuBsFXFty3wnJzYvLEz1ZFvKdJkh0uLC1nEV6JZtKKALXKr+anR4OK+iEC5KLylbFwgetLQiNKZJ800LMuQ9J/qbZpcohEcicp9wQFEm91yS3C3a5Vpbfk+XtoJ3EC65/VCRvyRstFmY42eg43QhacvsZzlfR/vnr3WpMYRSQWJvRWFJ3uZ6u0yGZuWcjkt9tnddQfQcJv90UphGR2Acd46XJyph4jmzzMelOYIuztQNGsHUnnJJK2hQG2giR305A3P2C2zd4Mo5YPR5HtBwNOdYUnp1dlRDulH2hXhAlfkFqLtmH2EoLrIyFT976L55yD0Z0W/DwcRJ/TSrxR9AMCqrBP5+rWFaQwNtOQjKG9O+IVVCYemGvjnZizF4XrWtWp2Cr/R6Xw+o+kXuV2VLxqyAns7auA3D1BiXkN7HSRvMBp78gTZkspYlOk0feC0f+cd5Hxbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR08MB5494.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39830400003)(316002)(16576012)(2906002)(5660300002)(54906003)(956004)(478600001)(2616005)(16526019)(38350700002)(4326008)(36756003)(8936002)(7416002)(6486002)(26005)(107886003)(38100700002)(31696002)(8676002)(66476007)(31686004)(66946007)(52116002)(66556008)(86362001)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dU9uaE1sNVF6NFllZGpkdmg5TGZEZU15MTJ5ZkUvQmxJZmJkQWZxZTdDWXpY?=
 =?utf-8?B?SGhaZG5abXE3SWZIU0lZREZ0TWkwMWEzVlV5dDRoa2Ryekw5K3J2MDFZTFpq?=
 =?utf-8?B?WWlkSUN6TjJNOUZtb1o4M1AreVVQR3I5aURrZzZaZ0lORnl0U205U1piRTEw?=
 =?utf-8?B?dW9DQndzNVBJdWUyT1ZKMkNKbGpFSnlvcDJ2Vlpub3lRSitKMFkwQ09BVjBu?=
 =?utf-8?B?MG56WkFCbTJrS3ArbXdMdzl5OVgxREVtNms2Z3hpQWFwQmpPWWttcDA0dHRw?=
 =?utf-8?B?YWExcDVla05OY1hhaUF1dThUZjR6VUR6WTlsakRQUTFia0hXMG5xZ1lLM01J?=
 =?utf-8?B?KzU5SDFDT01QdkhybEg1QWZNY2s4bU16eVQ5ekhkcXRhckNZYjdEWjZlbDhF?=
 =?utf-8?B?N1RCUGR2RDdhK1NmRHhRSGVTRmdidytma1ZTSnlLelZMZCtrNlZSL2lUWnRY?=
 =?utf-8?B?QmhPU0NObnRvU3V6VnBGNTl0RG45OGJhSkFyVlNXZ2lnMklLK3Q2MmNuR2pl?=
 =?utf-8?B?c1BCbEt1aWI3NktDV2JLc3RzWTdtVGFEU1FFTFRnTkJhbHNqZG83bGpjcHJu?=
 =?utf-8?B?OGxJY0d0R3FiZ2dpVmFRdGM4TitjV0JwWnJrV0FuTm53alE0eVl6RmttdlRk?=
 =?utf-8?B?L3ZNUEVoOUxuNmdVMkZtYkNhd2xsN2ZVdVNjUXArQ3M4ODROYzQzeVpjOFVO?=
 =?utf-8?B?cEFnRzBtemZLSmRxTDJwdmlER2RKYzZ1QVoxSHg1a1dNdm1LeDlOeTNEM09B?=
 =?utf-8?B?cDJ1OTl3UTl0SklXZFhNUW5QUlZNWXdJaTdUaHdKOTAyRnlXYXFKZEVDSXNa?=
 =?utf-8?B?bUYwL1ZmTjlWNDl6T1J4VkhpeldQaGVTUlVpbUMvK0h2RTAwRks3RTlibDg5?=
 =?utf-8?B?eHl1N2xhKzRBcFVkTENpS1Y1c21WTjNZUDh2RWo0ZUFiNGk0dktmMGtGTUxa?=
 =?utf-8?B?STJDK2UzNVNvZTJpc2dFMytiNHp4VnN0MnBJNUMwNEdOZDVoZ285VkZWQ2pp?=
 =?utf-8?B?emI2aG9IYjhoUHY1bXBUL1UyMW9ZcGVHcTM4cktWKy9KQjI2N3NFWC9WZlJL?=
 =?utf-8?B?eUNSTUNPYzIvT01yR2dub29IUFEvcXFRZFhpM1NoY05xc0dHMncrdWlRYmRr?=
 =?utf-8?B?bWRRUHYrMEF6YitOaXMrYUp3QXo3UW5tZS93RlB1Qy9UQWhFTjg1MVNlYTBa?=
 =?utf-8?B?QkkvRFB3QjZmK213R0ZGS3BjKzFORG00S2hRc0Z5NmgvV3hXaHNEVExBdXFL?=
 =?utf-8?B?OE5haUdCc053dW9sRHhHOEV5NFhsUkhnWlVySTNZVG5CMDJ6Q3AvMDZCdElr?=
 =?utf-8?B?Y3VQM0t4R0ZiazdCN2YxNmQwODNMTFFSRUw1VlhiWkhLRzBpV21SYnBPZGZE?=
 =?utf-8?B?MHY0ZXJYV25EaW1ZUituOHF5TytmMHlaS01STGpOaWY0VVNENy9SMlZ1ZlB2?=
 =?utf-8?B?TFRFb0ZERVhTTkxya1hiUUJBWTBkdVFZQjYrTGlNNUFIMS9vemZvcHBCUzVm?=
 =?utf-8?B?VVRoYUltQzg0ZVdKN2UwdGtKRGl2eno3TnVUbzUwWTRUZWFCYmdUOXRYYld5?=
 =?utf-8?B?VGY5NTJyNDJPQ1VJWW4veWhSUlZwSmZkSTRVM1MvL25uZHBMUnVJNUJaWHlF?=
 =?utf-8?B?T2ZPc0kzT3p3YW9VOTRWazZwbUZkT2pKcWFvNEFNYjZsUjJ3dUZnZ2ZFZjRG?=
 =?utf-8?B?NXdDbkhFeTkvemVnL05NbnVqcEZaWmdHMis5clppZ3RlcnMwK2xOSzFxMnJS?=
 =?utf-8?Q?MZZcMfV9dERUKf5IetcyLFw43yPA2o4V+iCho3U?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55f76bbd-c6e0-4b5b-b074-08d925c15450
X-MS-Exchange-CrossTenant-AuthSource: AM7PR08MB5494.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:24:12.4091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZAj4kYv5sNj3NLbDURtAuthVex9K29jYPF51+Np+jYgEqX9sThN0GfodOmBKIJUBWwVThJoKynPH5/DdigKBl07sm3JJMGqzsQNIV8Mbius=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5494
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

31.05.2021 15:38, Valeriy Vdovin wrote:
> Introducing new qapi method 'query-kvm-cpuid'. This method can be used to
> get virtualized cpu model info generated by QEMU during VM initialization in
> the form of cpuid representation.
> 

[..]

>      "ebx": 0,
>    },
>    {
>      "eax": 13,
>      "edx": 1231384169,
>      "in_eax": 0,
>      "ecx": 1818588270,
>      "ebx": 1970169159,
>    },
>    {
>      "eax": 198354,
>      "edx": 126614527,
>    ....
> 
> Signed-off-by: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>


Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>


> 
> v2: - Removed leaf/subleaf iterators.
>      - Modified cpu_x86_cpuid to return false in cases when count is
>        greater than supported subleaves.

[..]

> +# @in_eax: CPUID argument in eax
> +# @in_ecx: CPUID argument in ecx
> +# @eax: eax
> +# @ebx: ebx
> +# @ecx: ecx
> +# @edx: edx
> +#
> +# Since: 6.1
> +##
> +{ 'struct': 'CpuidEntry',
> +  'data': { 'in_eax' : 'uint32',
> +            '*in_ecx' : 'uint32',

I'm not sure, probably '-' instead of '_' is preferable in QAPI.

> +            'eax' : 'uint32',
> +            'ebx' : 'uint32',
> +            'ecx' : 'uint32',
> +            'edx' : 'uint32'
> +          },
> +  'if': 'defined(TARGET_I386) && defined(CONFIG_KVM)' }
> +


-- 
Best regards,
Vladimir
