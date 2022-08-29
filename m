Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9745A41B9
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 06:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiH2ELZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 00:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiH2ELY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 00:11:24 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A0E10577
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 21:11:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kS1mBDL/qFjoMWL2q8ZoT1kVTPYoqmbjMIy0hYzA4I5AXe5dq6cVm8oqukVe7nZNf6+6TLg30zqK1QVjLxcF4OcamKXJL5qtLt3kjmVrxGWq5M6Q7z03zhmET3upoBgNuGKagMLHFpLqG2NFQ4Jca+iKdz4WNivPaMCgvTP5LnkLxdSvX5RelmGGLf4HLov+A/F8U0zVShvJOD2u5yGc20TA5RfTY+T3VDBX9Ymu/Thvah9tuY2aQ8oMxK9U4EdPsiuwxPMkIzXozBhZHfMENenqhvyw3+dofZQ5yRzoLUAF+8Jd0ztCbvZAxhfwUMN5e6HiO+CXuyHGPSKCHAe7Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qGBkgT+ZSJOJ9nucTzUcwl+t0FjS/pLCKDH2dtiEa+M=;
 b=eb1nP7DntYKLHhW6gvFV4uV8klIqjsp2lqzCaczezLlJAQ81QRBsXSzBdwogCFwGHkNMPvnZRoVLKdTU2oe0es29TMQ/V0dDeJUQB9JIkLSRPdPkm6sxI+TxdCv5oQ7JEAdARlmYh4Erao8SQWHWzreLXm7FivVT6duzMlb0KimIPOa+S5DAv41oOy60cY0AHWTDERI3QKaYM2+GJ6676ocEty8qRgdOhFUxoaFQLMRABN2oPpboce4PmLK/XU2/a2oaz2Fww8/nW/3oEEsckQloTfwIGpcfgEvnOziDN7Pk+q4QpO47SIKOuMBLUoBYMh33/IAwpWREObE9+cQTNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGBkgT+ZSJOJ9nucTzUcwl+t0FjS/pLCKDH2dtiEa+M=;
 b=W1tXHPzRxR61UhkHsZDgkcoDVSqhT7ZJZQBe4Yk4vIPwH5KPBm18NlWLRjVSkk75+aEB6br3Ra9LTJ4qVov0zZ2B2p1ro83gbqxSbl3DMw0wNE50b0ywtPHVVRqOelVMv3Lk5X5ridgSdMw4wsoRK0Zhr1CpGkWsvdzKHJqWQ58=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 BL1PR12MB5048.namprd12.prod.outlook.com (2603:10b6:208:30a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 04:11:16 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::8e2:b1b5:887f:86fd]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::8e2:b1b5:887f:86fd%2]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 04:11:16 +0000
Message-ID: <d62703a8-7c8b-eab4-cf35-bb520312d0d9@amd.com>
Date:   Mon, 29 Aug 2022 09:41:08 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [kvm-unit-tests PATCH v2 0/4] x86: nSVM: Add testing for routing
 L2 exceptions
From:   Manali Shukla <manali.shukla@amd.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, aaronlewis@google.com
References: <20220810050738.7442-1-manali.shukla@amd.com>
In-Reply-To: <20220810050738.7442-1-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0019.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::10) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82ddc7e6-1437-4537-8557-08da897484b4
X-MS-TrafficTypeDiagnostic: BL1PR12MB5048:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4tGPt+BN/wUEjzbBjvffMYbIAXkFkYeZDWu1hU7Cxeq6ZZTGoS/x7b6XFU8rfpwvWJKWS7aexBBzQVBUK/iEwPN6Ele9gRAi1BTHR7huhewmzpRDUf7D/3lV8Td8Slrvcj6zz+5pht3oEkbvlIDCehquDIVoTNGGpX7yhy4i6Ggv0htnitEKRrNGA4EmSdsSFMDMU11UJGSVfZZ8x7mG5VK8eNedYc0SkAPKJF5VBzxVWa2T/G2RPdeSEPIsok1NtzgOj8N8yjGerEQ+rWK5IJUj1FUXyyCM3IAmHnVRhiBP2YMAGHzL1qkffqctit1KpdX3s/cEh2UNnjv3d0qvP7vVBY3JyqAs+ahUd8aVIR5X0iWiBITMUx6hGNTDGJ9Cdsop9qORSH6Kd502PL4BH9a90PfOwpuadRK6TxqHDVbGja9qWdIaE89xj9Ec/OicAFVOuxxyaWEpJx+OUo1yyu3fPuBrlFAP+hMO8ZIZ6KEjPY0PW+gjQw96J6cdjew188knJ/lVwUPoXHH5Zz/Q/4vHqnaNCq1fXKXLWLVvK+aPNFAkYJ/QLXw+2aXK5XgU+T7McdjK0C6ZVs7bCv99nSZvcm2cg/oBM2QJsSWVyurh2AQa+S61A1aHeF9G0Uwxeu8xG+1wE1KssUXwSph+tHGRBLmGIDW2+9gHRsecHKnkL/dQVDrddia1pHbbCzin12c/ZcttGaSOpiIKJcGEEiPgjUMJIW7h1MwkeMkvgEV0q1lt/KCX7F3YKczzZb8XIsB9zq1SL0BxBTYKQDDMePFNxCzjiZbg5HMS2tA98HZB3xIcjjOQn30bQVNyzGPyZtJAzi/US4wumYq51sWR5KUs8UqF2srBrmnpU6/fmP8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(8936002)(41300700001)(5660300002)(2906002)(186003)(2616005)(86362001)(31696002)(6506007)(6512007)(6666004)(53546011)(26005)(44832011)(83380400001)(316002)(38100700002)(31686004)(36756003)(66476007)(66556008)(478600001)(8676002)(66946007)(966005)(6486002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWlMZ0J5YWRiNGlmWnAzbi9STDJJZmJpRnZtV3BaVDE3VkZHZUJUdFAwTDJE?=
 =?utf-8?B?b2VJajVPVzRJdHNvYm1JRG5tSk4rNjNKNjU4Qk9iWVprK2twRkh6aEZKdzVh?=
 =?utf-8?B?TmZZYUV5dUlOSmtPS3hnaWxnZU1peDRydkNyZzFUaWxFdWttbjRlbkJ3Y1l3?=
 =?utf-8?B?TmtXeFljNmJCTnlNbEZoZ3lrZ1haTFNPWi9lbTZFZC81Z2pwSExNMWtvSlZk?=
 =?utf-8?B?ZlAzV2JnRVgybTJqa0p3S3R5Y2x1akg4R25sNWNHcmppZk1IeVllM0cxTFVW?=
 =?utf-8?B?anhiNm00bkU2U0FrN1NnanlUUEJkN3BxVlozZExWSnRSdngvbGgxdmdiZDJh?=
 =?utf-8?B?YkN1aEF2QUFxRHR5MGQxb2ppbVByZTdNZis0Y1B4UUF4MDg0UUwxbGtSOE9U?=
 =?utf-8?B?ajlTcnRGZnhhWnZFcUpXREkvdnJucHNwK1RNdlUwczBYNEs4WGxaZ3pvSWwy?=
 =?utf-8?B?VjBUZkx4THFKc21WVWpLc2kvU0VkQmRWZnhVLzNnM0UrTEF2bElZL2V0VzZ0?=
 =?utf-8?B?SEFoRVF3ZTJ6S1RsVmhhMkFhQWRrTFZncWxPakpLeEhhVFVCV1NWQU1MQ1Rv?=
 =?utf-8?B?K3hhWHZVUDA4MjBQUmhTZGpnWnkxMDg5dnVQN3hTT2d4VXEwOE9UMEdXaGl0?=
 =?utf-8?B?UTVwWDVRKzdZbFZHMXJVSXprZ1pDY0krUEV6alFWdTRiVHV5ZUxVaThyVk8z?=
 =?utf-8?B?SG1hUWlhTnloNjNsOFJmV002b0tqYi9VTy8ydk03M2ZJNWwwbkFVczNuQlgx?=
 =?utf-8?B?dEtIaVFJRm1SeURTZHpEWVVGRStQT2ZrdTlkamQyWXRyOHVLNUUyTmZ6SmRB?=
 =?utf-8?B?WUlJbHFKMjdDUVUzVE85Z1dySDBTc0FLdGh4cXpEN21LQStROUswbzJDYWZW?=
 =?utf-8?B?Y3FBOERZQ1NMU2hlOEVsbkp1aXE3NVRnc0JVY29QanNOUVFURkx5YUVYeURP?=
 =?utf-8?B?Yk9VMmJiUHhENDZ0WWgyU1pUTmJGWm4zZE1OQ2s1dU81YmFoMThyUHE3UUFR?=
 =?utf-8?B?a250VlFSTll5MmJxYkd5UklhOUI0ZW42Ukp3eWVBTjlIQ2NkRW9KbHRyMStL?=
 =?utf-8?B?WDFhNXp0UHhUb0RkbW9NSkNuNGo3MThSaDhRMXVEdTB6WUhBV0ZadWJLNlp2?=
 =?utf-8?B?NWFobHdScXhXa3hkaFFQVGJJUUtJamd2QTZTeUlrdktNNCtNMDhKbTJxYWQ4?=
 =?utf-8?B?c0RWL3VRZ3k1SmhKYkx2d0RILzFCWTYyOFNoVDREc1NtMytDUUFJUTZyZ2x4?=
 =?utf-8?B?V2R5M3RacVBRbFhvQ2tCUUY0YkhIdHltUXZleDdnNXdnT2dIa0RLV3J4NnEv?=
 =?utf-8?B?cm9DdEprK252bTBzVkx4dEpNSmQyU2ZBTVZLN2hNRTZvOGdYc09LamhQRGFR?=
 =?utf-8?B?RjZ2NDFFc1FwaXZqeFNUcU81dXdqbUZRRXA1b1RXbjNtTW5YNGV6WmV4VWNE?=
 =?utf-8?B?dmRYYlRJTXNOajNHMktDZmZMK3J6dmk2UXhIeFlBaGVCU1hkZ3dxN1djV2Vn?=
 =?utf-8?B?Ky9iT0RqSjIxdkZ1c1FYbWhSSGovVDhlUytGNHVvQlpQYXlpb0FqUUkxejA3?=
 =?utf-8?B?enB6QklhYWFaRDRFOUtJUnhSL2VCSkhlQndpQ1V6UDZNQ1hYVnNZTytvWTd1?=
 =?utf-8?B?VGt1WFZkejhYRVNnMUc2eWpheXBNTlJ6T3JTZUNSandwZ2FPY1FTNWlyaENi?=
 =?utf-8?B?M1NzUTEvTW5LZGVENmFqMDAvdU13NlJRSEJXNnpxdXZ1Q04zazJldmpsb2xW?=
 =?utf-8?B?Z2NIUWIwa1gxMUdIc1Y2cDVtQTdpV3JJejBNUWdEREdMMHEzaTJhbk1ZVjJF?=
 =?utf-8?B?SjhWZmFZWFY3NlhKYnZrTDJwSHVvanFLOGF2QWk5d05SUzQvcDc5V0x1MkRK?=
 =?utf-8?B?UWcvY1NRaEt0dmtzWXZIcjlIOWk5UEJWNHRVTUdxR1hlZ3RGRitiUnAzMWtR?=
 =?utf-8?B?eUszd0N3d2REckFMZytNVXJWT3pNMlNjbnRQeHJ5MWZLT0N5c2kydENhdXoz?=
 =?utf-8?B?MHpUTElocUtaN1RrK1hiU0FRSUxWN1dRLzVlK3RNM2VDaHVndlJVZ2JWRm4r?=
 =?utf-8?B?U2I3aFZURjlaMGV1TEN5ZUNzbTRBc0s1VVlJa0w2Y3EyRktidVprRldiVmU0?=
 =?utf-8?Q?t5TPAENAV/qE40Yl/sHhI5+vQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ddc7e6-1437-4537-8557-08da897484b4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 04:11:16.5519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mFkGhmJdyOVxGc0X+84XoBzPwYqeHFWZ99X8WWmYVDzpzh45MSDY/m7PTK3ij7H/Ws1pqy6RmwkPWUalULEJIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5048
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/2022 10:37 AM, Manali Shukla wrote:
> Series is inspired by vmx exception test framework series[1].
> 
> Set up a test framework that verifies an exception occurring in L2 is
> forwarded to the right place (L1 or L2).
> 
> Tests two conditions for each exception.
> 1) Exception generated in L2, is handled by L2 when L2 exception handler
>    is registered.
> 2) Exception generated in L2, is handled by L1 when intercept exception
>    bit map is set in L1.
> 
> Above tests were added to verify 8 different exceptions.
> #GP, #UD, #DE, #DB, #AC, #OF, #BP, #NM.
> 
> There are 4 patches in this series
> 1) Added test infrastructure and exception tests.
> 2) Move #BP test to exception test framework.
> 3) Move #OF test to exception test framework.
> 4) Move part of #NM test to exception test framework because
>    #NM has a test case which checks the condition for which #NM should not
>    be generated, all the test cases under #NM test except this test case have been
>    moved to exception test framework because of the exception test framework
>    design.
> 
> v1->v2
> 1) Rebased to latest kvm-unit-tests. 
> 2) Move 3 different exception test cases #BP, #OF and #NM exception to
>    exception test framework.
> 
> [1] https://lore.kernel.org/all/20220125203127.1161838-1-aaronlewis@google.com/
> [2] https://lore.kernel.org/kvm/a090c16f-c307-9548-9739-ceb71687514f@amd.com/
> 
> Manali Shukla (4):
>   x86: nSVM: Add an exception test framework and tests
>   x86: nSVM: Move #BP test to exception test framework
>   x86: nSVM: Move #OF test to exception test framework
>   x86: nSVM: Move part of #NM test to exception test framework
> 
>  x86/svm_tests.c | 197 ++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 142 insertions(+), 55 deletions(-)
> 

A gentle reminder for the review

-Manali
