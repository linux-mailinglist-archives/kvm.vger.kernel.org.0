Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918FB78C79F
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 16:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbjH2Odz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 10:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236871AbjH2Ods (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 10:33:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95ADC107;
        Tue, 29 Aug 2023 07:33:45 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37TCCVrx021790;
        Tue, 29 Aug 2023 14:31:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=icXVFKOLIpqNS7VKsW0vC3cSZXZm/MVY8JnNCQq/tMM=;
 b=gFE9cn+nZdXL4xSQFzL/04BLADDsC6iuDmaUAJGF7mmKbhPjUsCRlDX+hrFO8VwpROGV
 xbMJE8tXKdjkfUJ9bAFnI4+dO+Ewaq1StXkB5OUGFwIBYjhgs6P4HJs9F2h8PZEcpXGy
 Btnauzyv/h7eLUqat87wux4dqj6y/RJDN+k/ggZJ/NkakNE1E7hSkX93Z3oCi21u71aZ
 ANZniy1lPfccwu79hMzO+8pz8L+teoRJNXa1UXWy40PbtaMAmgz34KM7dzlR2NbPj5F2
 QGDZdQOC5MN5El//MTCCM+XKLaGE45ZjAZJnF0eNAjebbqDlFfIR84WUQ/GgJbFonaaQ /g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sq9j4d65f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Aug 2023 14:31:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37TEVRmL032692;
        Tue, 29 Aug 2023 14:31:40 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sr6dnp5ud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Aug 2023 14:31:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldiJyAwdHGAXEph4IJescSKPgj7jkH4BgdB/spv6GHPTXjudsE1pqQCXsdgiuz/lN1WkZG6DrxGE1Py2diE9+JWk6o8PP5Zv+IhQ4iBYjOpi/5plUiQ2tkQC4g4qnYh1kw/XKU1I6A7M5U8V61ixme7NE8r9OQzRmFQKzjXtqQAFPrnFFdvx0nZdluyvGdvjo1JJ8WVFEls8Knm5qYpYJfTHRa0o8RgoIEwzvoby2ULtZA0MsOBZXzI/h0CyK6NHD+W5NkrEeA2naGb+QYCkSqDzvyDDElPB3anV8quVR5v4p7G7ey+/DCvdRmDfAyzjWH8ONLsW9hkXS+aO8uiDlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=icXVFKOLIpqNS7VKsW0vC3cSZXZm/MVY8JnNCQq/tMM=;
 b=neI5cQhRWhCmxt9Z9FBpg8XyUfeUD028rMfKb/2VPG5xHVbonFIlgIeWN6fjw7LIdi/zR2yKyiu2CqmXJC1v59lnT40ihSibI1vElZnadVaaI/DJJhhv75xWGsrUngcsP6GL/veC+EoS0WHd339SaXUz0Xwf+V7FZTc3Y/iYBrclKgQr3FV32hZfNyu80DFhrEj/j3N7/ASsINKNd76+IsADTXJNRXACnPpyWwvai/w4Z+TX68TKaheEcMJrs27H4ijX0dRRUp6T5jP4RsJJPHAE/41vLN1CC/NKf5Esfd29pVtlGimzjkqM34ZQItuthXoVyrbINLEmnlqlM43XcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=icXVFKOLIpqNS7VKsW0vC3cSZXZm/MVY8JnNCQq/tMM=;
 b=drJxAYx1t7aVilxIiBy1FQeWiB1q0g6uk0p32rh5gQK9TpR4JONTR1LybxWMCzBGyLcRL4Sotqa51NNruzQepl+25FWsQpWdLkIg57GHzZadaHX6XwedtDI6BxlUF5UicAvua+xQsytYgLjMfokMZp7NVfbQQ9Gqpam3E6W2KEE=
Received: from PH0PR10MB5894.namprd10.prod.outlook.com (2603:10b6:510:14b::22)
 by SA1PR10MB6295.namprd10.prod.outlook.com (2603:10b6:806:252::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.18; Tue, 29 Aug
 2023 14:31:37 +0000
Received: from PH0PR10MB5894.namprd10.prod.outlook.com
 ([fe80::750b:c9bd:2896:cf60]) by PH0PR10MB5894.namprd10.prod.outlook.com
 ([fe80::750b:c9bd:2896:cf60%6]) with mapi id 15.20.6699.034; Tue, 29 Aug 2023
 14:31:37 +0000
Message-ID: <ad2e6b6a-57a3-2c22-8ec8-7ba12e09dbeb@oracle.com>
Date:   Tue, 29 Aug 2023 17:31:27 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] Enable haltpoll for arm64
Content-Language: ro
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        Joao Martins <joao.m.martins@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-pm@vger.kernel.org
References: <1691581193-8416-1-git-send-email-mihai.carabas@oracle.com>
 <20230809134837.GM212435@hirez.programming.kicks-ass.net>
From:   Mihai Carabas <mihai.carabas@oracle.com>
In-Reply-To: <20230809134837.GM212435@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0017.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::22) To PH0PR10MB5894.namprd10.prod.outlook.com
 (2603:10b6:510:14b::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5894:EE_|SA1PR10MB6295:EE_
X-MS-Office365-Filtering-Correlation-Id: 1077a855-8e5c-42ad-8517-08dba89ca6f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uw9CV31wujpXsTx4t9vYVkMMwsYGQ9OvLFAE9qQqcKAElvVB2airAfBZ7C5ORrDwYMz3aqiYdKw71ZctB6QnKi5tIIJoax8MnJp4TB1NkVVFO6CG9J4/J68v8l0t/MBhY3eGq/ZcLEYY6uyeWHwkMXhJVf5+8bXrWmaovt/37taE3HRWdgPzroPGQm/N7XWUD0n9vT4UCNz5dwN0qOxO7LeSrpoICD9MPFP7Ec1faxKt1VJye4vwpKvxOYSpgOgisOrQidiKT68VDibsbh/7Y959DOOvJSXB7VrBnUKcdhH5SVPA7+PxG7ngww9UrMyn/mF7RVgvE54lHUsWlyEwEcbkwTYP6UohKr72SlmEk3dwUfeHrAZ8DfS0qkS1pwrdjLRKkdkPhDRyx574ijcvLJaVHlzK4AD2aI6Iua6ckVqKlewS/8HqPW9oFD2qIZHtZv2CrjM7hyKVQwjfDNWoLecKpf3hFq7P14AIKGxGajwbyA7u2rxMfisoSOtPDRXEW09QXWdG5PgQShpmSS79OyDz0plENGfh0V+ZOZ/RFfG906URIenO7KlO2k6sraFaSRinf0bOZFqfAF4eEsVRH0u3pyIrbwJmFqJ3SNMLkAPt+RY6/fDyImpdv4vAC/upk4UXfL+lBeIQ9vFAiB6+Og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5894.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(396003)(366004)(136003)(1800799009)(186009)(451199024)(31686004)(7416002)(2906002)(54906003)(66476007)(66556008)(66946007)(44832011)(5660300002)(316002)(6916009)(41300700001)(36756003)(8936002)(4326008)(8676002)(6666004)(31696002)(6506007)(6486002)(6512007)(38100700002)(2616005)(86362001)(26005)(478600001)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHkvK05EbHFiQ0RXUTUrSUNyN1c4cmtHemxKL09lQVdRSThsS1JrVERsYXdt?=
 =?utf-8?B?L0JZM1Y4YW1qVjVGQ3NveFlEUTVOSERPM0puek1wNWxKV3NzRkxVTldycWZz?=
 =?utf-8?B?eXZzaEw1a3c1WnQvb0tJa0RXYUs4S1lOQ2Q3SDFucmtPNVVvS2swblRhSVpQ?=
 =?utf-8?B?VUpGcW5GcUVvZEVLcW9jd3J1cjdWY3U3SDJyQXVUeW1uQkJKdFo0bTcwT2NR?=
 =?utf-8?B?NU9NUndDMjJ6K1lxZDFoNzZONkp2WDFKcllPekdkeTRhcDQyZkVKRm9aQ3Rr?=
 =?utf-8?B?Q2Q4Ni9XTHFvdlFWRCtWekNISzBZc1psM2pkc1lMSWN6bjdPWURZRDljUzlW?=
 =?utf-8?B?blFUYTZPVkpMZ3ZtQzJqOWxnU3JYWUZSbHBtRVp3YXRkZDJ5U3g1aWNtcDZn?=
 =?utf-8?B?U2wxbWFqbzlkeXIvZ0J0OTVFeG45SU9JcFJDbHVnS3hrV0xEOUtZVWh0eFNi?=
 =?utf-8?B?REVtd3hWNk9Sdm4wR3NsQU5mb05YVytBQUZLMzQrdVlsZlllNU4vRnVURDVI?=
 =?utf-8?B?QnYrSlpaVGN1MFh0TExVaWpQdGNBMngvQ0p6bkNzS2E5R0p2cmMvdUdGdm9Y?=
 =?utf-8?B?V2xKTkw3OGZMdm9BMzBQVXlmN2EwZUMxRVpXSHdvRm1JSm8rNFpnNW1Cdlpu?=
 =?utf-8?B?ekJIMFQ1QUJUQU1GRllTcGZGOWhDNURReVh3T3MwVlkvQ3N1VDZzb01MVE9p?=
 =?utf-8?B?NUtJSWx0blNjamhsYkRXKzlXWFlaSWxLVVQrZXN5MFJiTjlnRkI3Yjd3VlU2?=
 =?utf-8?B?RVVvNGdXSzVqUFczSzBPMGMzTjc1Umh0anUwTURKRlJ1TVFlcCtHRlIrbVc3?=
 =?utf-8?B?d3h5RFdMd2ZlMmw1ODNQaEZmWmxoTzFyQjF2Q3ExaGZ4ZXdCOXl5WU4yN25M?=
 =?utf-8?B?bGNXWFRpUWYrV2VQT2MxWFFMZkptblFOZXV3ekFpalIwdFZ6MlZtVEFHeEtC?=
 =?utf-8?B?T282bm90eFlodzUvWDlwaFRxa3Bac0xWbGFXc2tGbXVieG5wQk82QkZLK3V4?=
 =?utf-8?B?N2NTQ1hwSGtmbk8yVlBGWXFUYUVYTDlGL3pHQW8xMzdVMGRpWVBHQStwMDVK?=
 =?utf-8?B?aktaSFJ4cmZJejlUQXFwcDdFV3JLN09rdm5nR2pZQ3JYanVFeUVUd1BmVzNO?=
 =?utf-8?B?Y0wzR2xpbXJ5aDk1V2hFT0N5NDdaQytUV1F6WWVBa2ZyZkRNMlY2L0greEhS?=
 =?utf-8?B?NzE4Z2JKOHlWMktOOURSRGNkTVp3ZXpZSXRVY2N4RHo4ZmZhVkxseVhCVjdk?=
 =?utf-8?B?TkpuMEE1QkxKZlFmNWJzTWlsZ0FYWUlxWXB6TUNobHgvLzFlb2JNTDJiWnNE?=
 =?utf-8?B?cWJrS1AxVzEzSlREcEVnYnRWeHhTYklPalFQVWRzdE9rRzdIRWdUb1J4c1Jz?=
 =?utf-8?B?eXdrU0w4YUZtb29JY1JlUEdUYmdpbWNScGVHMVNHblVIdWNZZ0NvWWt5VTIr?=
 =?utf-8?B?Tk5IczJoWUxPZ3daeitTWnZQM3pEQ3NvMnNONGhrUk4xV0Z2ZUJPVUZnemNn?=
 =?utf-8?B?cmV5dmkvZHpJOWRIMy9sUllGTGtSRXJoZ25TN0FMTGhTQkhvQWUvZDVXUEpK?=
 =?utf-8?B?U1VJeFJQeVJrL25BVE1PVWZEcURBTkErKzd4OUtXbnFMTkVnYjluT2poS1Nw?=
 =?utf-8?B?eWtCOWxOQXY0TDdPa0NycEZBMk4rVjBKOWpsSlhTTWx5QitNZ0g2VmZFQ1Fv?=
 =?utf-8?B?Q2lLdGRHUkJ3dmljMGQ2VENzZEVKV0hEZ2g2Q2ZLVW5iaWF5dnNneDlXa1gr?=
 =?utf-8?B?UGlWbjMwY25KbzAzWUFXd3VmL2thbjcxRk4wekRyZXh1NmtIa1k0L3h5aFI3?=
 =?utf-8?B?MVZ3WWo4TC9TVmxhOStSM2QwdGRrMVVqaW1IeEdSMjJ5elNHZGRtMUN2a1gy?=
 =?utf-8?B?VCtHdy9DdHo0eXExZXVObzZMcjRaSFkwUTdlR2djVHhVbUhxSUJ1aFlvRWp4?=
 =?utf-8?B?OTZJK0VTK1dzVXRHZTdzai9oVFZoMW5YbWN0Z01KaklZdklXM1BaUXBpN0pt?=
 =?utf-8?B?S0syQ25CSGg5TjV5Nld6NElvdHpuQ21HUzJad0N5akw2QTQ0MW1CVk04VjR5?=
 =?utf-8?B?dkg2aFlrOE50am1wSzJ3MkF5cU9yeWxJaTdLTk9ZejFsMUdyMFA3ZFVMUTdz?=
 =?utf-8?B?VjJVajYzWFp3bVJ6SHJPd2crYm8rVWVQK2tvMW0zL3gwaWVseFBZK3dPNGVa?=
 =?utf-8?B?ZFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?R1VwY3dGYUtCa2N1d21GWGdyRDRqNzNoZDN5emR1Y0trbElVN1V0Q2d2Z0JY?=
 =?utf-8?B?azNqMDRpUzVwUHo3R3Q1RmVyMVpCSkQ5Q29pbWdsVmVTa3VudDVDcGplbzc5?=
 =?utf-8?B?SVdSVXBMUStmbHQxMFkvQ1Jtd0t4MlUweUFwS0NjQklnL0t2d0xhb2pXc0VB?=
 =?utf-8?B?dDVYRERLOUloODJKUUoyc0pZQ2tFdnN4Wm5XUGlGYWJxOGt5NnV3WnlLYjU4?=
 =?utf-8?B?QTJLVXFCRDg2dW0wb1QzZUZGNHQvbG5uRDFUcVN1a0xsNHpXZ2NVdEJzNmdo?=
 =?utf-8?B?bmhjVnVWK2lTZHRvd2JKU3ZIUU1VaUkzQ1FMekpWWkZMbXFETEFCMUdQeDdL?=
 =?utf-8?B?M0l3OVV1WWlScjJDbWpGZW5ENWZNL2xrSFZ1VlQ1d1hJNjNtOHZZTTMvOG9v?=
 =?utf-8?B?WEtwWDlJMUNYOUFzUnJmK2ZwSHo4d1hyNFJ1Tk9CWVVoUWdKanZhUDhhSFdL?=
 =?utf-8?B?Q2F4S2RGL2gydHBNZ1JGRmE2MTN0TU1ENUxibHJnWW91cHFqU0c3dExNMnZ6?=
 =?utf-8?B?MVJnaTlRREdIOHgwMzZGcEFPSG4rcEV0TmhnREE2cnJTUzBKU3E4Ykh3aHk0?=
 =?utf-8?B?b2lTbTM2L2xJUDhYZWRYYy8vYS84Qjk4ZlZ3dzkyUko2TWlxT3NhVW9Mc2lw?=
 =?utf-8?B?ZDA2ZktRTG9EalltT2tsQU5ZOEUvMzR5SStGSU1SK2gvRTQwMWN5elFpZ256?=
 =?utf-8?B?UWc5QlRhdlNDYkJZaXVBMjZLa0VPT1hRT2hMVGY3QVRpTWJJZVlvWWJTM1FT?=
 =?utf-8?B?YVBvZmEzcytSeUE0QzAzM2hxY3dkOEtWRzlwUXgyZmIzakRWY3N6ZVVKZXNI?=
 =?utf-8?B?dk95QW4rSVgzUjc3WnIxWTc2ZnJnSU1DbXBRbllmRytGeUhaRFBFdXYzcnNW?=
 =?utf-8?B?YnZPS3ppZU1aOVkvRENLWlZtNXZFQ1dvTzkwbGRwNEhvUXExSVpnOUZ3bHVZ?=
 =?utf-8?B?WWpibGpKL3JUMjBwRCt2RlE3dVdtc3MrOGMveHh3ZU9pWTVkYUVYaWhJZEQx?=
 =?utf-8?B?dHZ6SGxqZDQ4R2VjUnE5ZU52WGRwYU5VMngvVHVsNHNjUW0wUnI5b1cyMGxY?=
 =?utf-8?B?aC9RVzhpOWo4M1B2b0JrczVjVmN4VVpHNmxUNHVmMEhjK3ZtRjh1Qi94V21U?=
 =?utf-8?B?RzQrWDFLYUhETWhJc1ZkRCszMGF2VitKdmVjZUoreEVUU2hzYkVubElWM0pV?=
 =?utf-8?B?dHNOMC9xM0pvbkptWDBabGpyMWFjQUJ1bWM4d2VvZnZtRXFxczJwTDBhZm1W?=
 =?utf-8?B?TTNWbjVacWJOVXdudGhUZ0hJVkNwMWhqQXZiZHpEZmJpTGxJL1l3enhkM2lL?=
 =?utf-8?B?azJWREZrY2hGRXlLM3lMRjNkeUNMNXlTd2dobGJRMlZ1b3oxZFVaMXhXSG0r?=
 =?utf-8?B?bUlKSGw0Tk9TS3lCamIvSWNzWGwrbnNuZTRObGFZYnBTdytWWjluNEtBeHpC?=
 =?utf-8?B?Y1JvRVBvNGozamovZDhUYWRGd2oySEFRTTZRN1VzSkhyWUdjWG9vakNBS084?=
 =?utf-8?B?bmFWMks1V0owek1URTh6RkpQSk5UekxVcTFFOGtSSHZ6a3QraDU0YXZDazZ4?=
 =?utf-8?B?YzlSMXplcVE1cktzcE1MbUt1TmJRRThWaENSRWhoNTRyM3d6MjEzSW53VGdU?=
 =?utf-8?B?Q1l0OFhsU2IxWUtuYnZ5MWFCdzRWWGxRMXVHR3VCQW83cmNTS3o1SVYzSEZq?=
 =?utf-8?B?NUxqbVc3VjMvV1ByZ1BncTh3UllWQXFNZkVSeTBrOXRyN1oyYWtFMmdZZ1pw?=
 =?utf-8?B?bDFWakJ4Vzd3ZXJQdGVLdWlTSUpua2l2cTh0MUVWRWhOb2V3ZTNGY2tyd0Y3?=
 =?utf-8?B?YWxwZmpsM0kzOVRPTGVMQlhJZ2g0elo3eWFxb3NmVURLbTl6U2dNSEpkZEt0?=
 =?utf-8?Q?MqxQujE1su7L0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1077a855-8e5c-42ad-8517-08dba89ca6f1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5894.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2023 14:31:37.6319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0v8p9fNz+fkhZWx57UJGfbL3e5dvsHg+4xpehS9A4Cwi5jD8Qne9399kqmjiNolOmo6It99bc62hE5/8m96xBt0I8yipcCTySWIGW7rTg2g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6295
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-29_12,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308290125
X-Proofpoint-GUID: zvcy3B792YLYrG3tGjxHNj4m4Y6aIoPi
X-Proofpoint-ORIG-GUID: zvcy3B792YLYrG3tGjxHNj4m4Y6aIoPi
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Using poll_state as is on arm64 seems sub-optimal, would not something
> like the below make sense?
>
> ---
> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
> index 9b6d90a72601..9ab40198b042 100644
> --- a/drivers/cpuidle/poll_state.c
> +++ b/drivers/cpuidle/poll_state.c
> @@ -27,7 +27,11 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
>   		limit = cpuidle_poll_time(drv, dev);
>   
>   		while (!need_resched()) {
> -			cpu_relax();
> +
> +			smp_cond_load_relaxed(current_thread_info()->flags,
> +					      (VAL & TIF_NEED_RESCHED) ||
> +					      (loop_count++ >= POLL_IDLE_RELAX_COUNT));
> +
>   			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
>   				continue;
>   

Thank you for the suggestion. I have tried it and also different 
variations like [1] to respect the initial logic
but I obtain poor performance compared to the initial one:

perf bench sched pipe
# Running 'sched/pipe' benchmark:
# Executed 1000000 pipe operations between two processes

      Total time: 136.215 [sec]

      136.215229 usecs/op
            7341 ops/sec


[1]

--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -26,12 +26,16 @@ static int __cpuidle poll_idle(struct cpuidle_device 
*dev,

                 limit = cpuidle_poll_time(drv, dev);

-               while (!need_resched()) {
-                       cpu_relax();
-                       if (loop_count++ < POLL_IDLE_RELAX_COUNT)
-                               continue;
-
+               for (;;) {
                         loop_count = 0;
+
+ smp_cond_load_relaxed(&current_thread_info()->flags,
+                                             (VAL & TIF_NEED_RESCHED) ||
+                                             (loop_count++ >= 
POLL_IDLE_RELAX_COUNT));
+
+                       if (loop_count < POLL_IDLE_RELAX_COUNT)
+                               break;
+
                         if (local_clock_noinstr() - time_start > limit) {
                                 dev->poll_time_limit = true;
                                 break;

