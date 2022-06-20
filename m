Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453C5550E7A
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 04:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236560AbiFTCDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jun 2022 22:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237556AbiFTCDv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jun 2022 22:03:51 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0688365B8
        for <kvm@vger.kernel.org>; Sun, 19 Jun 2022 19:03:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCGOfJlYIwUe9O2xKmWcRjDKiCgmLR2kNR/7f723bMhw9e51rGIWIMQtsBBiq5lAdS1I3K9ycc8ehdZPGVnt8d/Wef3xpllh60tyTyW2q42HrdzWSJJkdOVAffbRVQqstloFOdlBKiKmf6t/xtpBaTmOBQgQ5eqOW7eAmfIeAjkwoj4sKd60/D2sHmMUlZjTpS3OXZ4pkycko+31xZwSlwfzD6cKrBcf9bEu5os6klV04yXUs+aIBVLRcPsb5RD3F6/8238kHWUeoirKM4mKgrBkS2Iuv3dXiHJJr5bTKidnTKg8U6mvSjLAu3HDt7LYks5aFaPl68JAkDHUCCu3ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rqbm3yGHvW0QDAO7CEnWsDeoao7DbgtK/AD7cQFfjxs=;
 b=FvSpYtOMxWME5ebDEw220GykefKX4zszBsrr0K08FUy6keytcIL4JIAaL4EET2uAXUYnfteZ77nm4AMLTfkNFjNmI0AIUE3AKxQNS0YZpLCRirBjFcMYMdy5ot9p+GkAZoW6APR+k3WVBLXyRTTWusskBdZwuHZ1v2AsVZ1jIWeZ0ahDVzuuiQfNPabAVjNx+4Q1Z3esG6ZGknKh7Q9bX8DJB9OqMFXgsXzubVahoQEPBjhlkYDRq01sigRM9FjXhwsiuKGDqRGOJYC4Pvb4gKXBFdJwH1bucsnR4Rss8I5q7OyFDeX/urWQhuMlEW4QCk2vB7bGJN1aTOpqt95I5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqbm3yGHvW0QDAO7CEnWsDeoao7DbgtK/AD7cQFfjxs=;
 b=RaObeOqkEa9MkqyofFTRx4jeuaCzdaXlIRtDph2tVG8Pi/73YN6g98OHQMZcuqKkgP224VYyYkQHtdY0W1lUUzREdwtJUgy2c01x83UkZN0YDCZGbEUJ5p6U5UBrVWMlavUjHm+/O2Whh0uTbpLPDaC8hKn12Ra+NbA/OLc6e5o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 MWHPR12MB1151.namprd12.prod.outlook.com (2603:10b6:300:e::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.14; Mon, 20 Jun 2022 02:03:46 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::bdcc:775:f274:7f12]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::bdcc:775:f274:7f12%4]) with mapi id 15.20.5353.014; Mon, 20 Jun 2022
 02:03:45 +0000
Message-ID: <d9cac7fe-c38a-1470-2048-3319eb9d3470@amd.com>
Date:   Mon, 20 Jun 2022 07:33:35 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [kvm-unit-tests PATCH v4 2/8] x86: nSVM: Move all nNPT test cases
 from svm_tests.c to a separate file.
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
References: <20220428070851.21985-1-manali.shukla@amd.com>
 <20220428070851.21985-3-manali.shukla@amd.com> <Yqpur6a7oYqUEfGd@google.com>
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <Yqpur6a7oYqUEfGd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0043.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::19) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fb80c4a-8245-42c4-d200-08da52611b9e
X-MS-TrafficTypeDiagnostic: MWHPR12MB1151:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB115198DA2B5ECA746FFA6DFCFDB09@MWHPR12MB1151.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HPK5Elsi28UHuy4KoW54JVLr/bNHieeZjJTV1MFg7+F8EvlGzMCHbrlUGDMUMYWmVLY6zBajRpFCyhpOrPSwKDw3S0TpM6ej0vEhURI1QT5dn9MJiNDi3wlMoIipYqiCdyn+byy4poN71J04uOlocLRHIRgBrHB8tldOzynb8Q4OyDC2VyH9Yzr/b6vDxWu7b7bFsPMAXda7KvflyfWzup7gGcTw4/9yczOrGpZZ9QhbOj9JCP4tcWdRa6aMmZncd7Ge0gQ397CjGejWDf+6sKqmIw6Tq6VQMDsJ25wvnRqUXnlfPW9PKinjBQylm60Worq9m9WOrw6JSZpq7BKZj1CB9UwypcJbs2L0JbXs2960ellO1H1OfL3hisbekuWR8hZiwknw8UlPRSqSkJSPR1++jvJoz1NwLuk+9TiGLfIN+gRKg38Xfgm9g4UdalDqj1nmdVjnu21+E5Z1l9to/MedWWgDpjv3okS1vrsQ6AxBgCTKtv/f9QrWJlHXv2pP6V9n5MRLbdjVSiFqjCRJEUawWxOlEv4fdjpFiaZoU5jMn/6dPEtmTo2TkdWW7B3axFAnzNosqpFqPpc+n55JhOze7b9r3d9ZHuR6koYR+osy8KHoN+8vYJCz29An2uxBJyFNCRPCK89JaIOoIvs/N7fTBK4M0U5rAo+lUy1Y6e/MFL/VWI72U14wlubgGtMJYYC6a8JbK2vqjuxUgGWsMS51h073y5zET7nXMsVdHfE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(6512007)(478600001)(41300700001)(31686004)(316002)(6916009)(8936002)(26005)(8676002)(6666004)(6506007)(6486002)(36756003)(53546011)(83380400001)(4326008)(66556008)(66946007)(66476007)(186003)(5660300002)(2906002)(31696002)(38100700002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1Q3SE5zc0dMNFJ6VDdCcjRSWEc1dWp1UFJFejZsZFZrNXozT3MyVzZCVURB?=
 =?utf-8?B?eVNBc1dKQmVUMXhQN3YrVU16L0FFS01wODZBQ2kzWEM0emczRHUxcG82Sk9U?=
 =?utf-8?B?bTBHZDNtMm9jSW9rVzJiVmFidVlyd1ljMlB0Z0FtNjVnOEk5aGNBQUs2V2Jz?=
 =?utf-8?B?MkM5ekovbnZPdytrV3hvSzZNZGw3cGNSMm03K2c1S0M0b05UVGNqOC9vb0Ry?=
 =?utf-8?B?WnZQb0ZWeHQvbWhHYms0aWE2eGdGWmhQQk1JSmNEYkVIRGdMOHQvV0F6WmFu?=
 =?utf-8?B?Y3hIUG16RThFNytqdjM1YjRoem9TZyttVWladEtuQ051eXNmVlJhVjhvWEoy?=
 =?utf-8?B?L0JxanZiekNaZ3JoY0lXbjh3TnBybENJR2lKVExDZjR1RjNJL3ppS3pBbHZG?=
 =?utf-8?B?REtHZFNlMHpxdEFKL0ZHSk04RlpTcnU1dUNqVjRXWDBtaHVCS1pSZ05XQXdu?=
 =?utf-8?B?bm9RRDRZY3FtRlA1emIyYldLQi9hV2R0N3lkd21lZHY4Y3ZXUGw0bUF1MFB0?=
 =?utf-8?B?QklnQ0N0OW01ck44NWJja1A4VUxrcVRTeW4wRE81ZUd5U1QzOUt2OGY3eWt2?=
 =?utf-8?B?eXVzMmdNL1Nrc29IbGk0QjV2aEgvWVRjeFh0R3RGcTB3UFBHYVFxNWlCWDJG?=
 =?utf-8?B?UjRiVGZaeEJ4OTZYbFpaQmVrcjFGeXMveWRYZFVRZjdDQWs5bFZWTHZjTC9h?=
 =?utf-8?B?WE85T2dpaUExeHVZR2dkWStGTjNEL25pN2dBRnpldVp0K0Yvdm5vMVRJeWQ3?=
 =?utf-8?B?WlkvbS9HR1BNV2d1VjNRa2lqN3d2eVdZZytoN2VMbEdqS0pRUlFxVWxNTDJU?=
 =?utf-8?B?d3NIMHBObGxjV2RyS3Q2c3FVUlNDRWdEbFRobmR1bUE1Y2pDR2Fwd3VUOEV3?=
 =?utf-8?B?cFIxRlczdHYxdDYrK0s5OGxmS0JEUmdXeFhZekgwbVZJaFI5VWxaYUhVS2Vv?=
 =?utf-8?B?a0h5N241UG1FOTVZMTFMaHFMZ1pQVU81UXR4UDNoOE5jNloyQ2ZoZGppSmc4?=
 =?utf-8?B?eHBaSzRBbXVsRktlQjNHeDVwMmh2ZXpxM3psblFxU2hMb0d6YnQ4NFZWSlNH?=
 =?utf-8?B?blBpSzk1YXQyc0RoSEE4V1J1NW5lUjJraTk1WXhXamVZQjhEaEgwQTZlY2RC?=
 =?utf-8?B?UWN6Nlh5dThBanpCMy85R29oWHVBSWY4Z1Ird3gva3gzdzRwZitwUUt0V3h5?=
 =?utf-8?B?Ull5T3BFTG9BbHYrWWVQOEE5aFVGVENqcXo4MFdCeERsdnM2S3F5YS95NkxS?=
 =?utf-8?B?bjFaU3RkY1hOUFFBMVAvZVRHUHRsaTVjUjNwWWZMa2MwSndaR1FYOXR5amJ0?=
 =?utf-8?B?UFFzZEZmM21HYzBybUFFcVZRR2FrVjU1eXQ4WmRRdWF5MzlTWUgrVm0rQnRm?=
 =?utf-8?B?YVlIeUp0bVB0NTVlSlNOdDZ2amN6bnBZZDhrcjVrb1haWnZUUlFWeE5MTWFt?=
 =?utf-8?B?Q2t1SmZ6WlNBUGFrc2NkQzRaV3U5SFZnVjg4aGZtcW5LWnFOSjN2aWVZZ3JR?=
 =?utf-8?B?M3AyMFZQbDQzWGowbGgwV3NUbkhpOGl2d1grMUFCRVVZQ1JyZFBqSFZSVFpC?=
 =?utf-8?B?U00rY3hETGM3RlhuY0dEdExiRElCQXdwZDZMU3F3SWFOK1VaN2VaYlNqVzBw?=
 =?utf-8?B?cGhIZGJhZ0hWcm15S21wYzJzNXRKNExTRE1EeXFZNHFDYm9EczhzZy8xYUt4?=
 =?utf-8?B?ZFk5YW12akQzVFlXQU9MQVZWZFV3L3E4c2UzbjhMb0p6VEdYTTkvd1YzWHBz?=
 =?utf-8?B?S29ac21RVGpTN1ZJbUx2YVFheTlKR3doeEh4WU8yUzZ2dk9yeWFML2pSZ0tY?=
 =?utf-8?B?TERSQlFuKzI3eE5YdXhJbUxQaEZiSVhUaHU0LytvdVREN3R4MGJON3czTEMw?=
 =?utf-8?B?YVlrWEZETDlhejNORlZpaGFsdHJpRmxuOFp5ZU1uQ2RmMEM0OGRPNzVHQmFY?=
 =?utf-8?B?a1I3RFpjZkVjRXNtN1pMY1RuTk1GeEdiOXBIVlo5cGhZakd3NVlXMUJQSTg5?=
 =?utf-8?B?dGlKMjU2MjNvZDQwWGVKcVVKcXZtQ0VOelBXREt0OHAwREpzbGtCYU82bytF?=
 =?utf-8?B?L3c3U1JHT3NVeVpvWE5WWFhiZlZydlZRS2p1bXVYUjNMYWdrZ2NMZkx5ODVB?=
 =?utf-8?B?ems0S253b2JXUmNYeXAzN01NWVRhZHRpOEtRSXhDMG5OcmpIV3prMEpvSnIw?=
 =?utf-8?B?WVloUk9UWVI5cXBEdFNRalNzYlVTSW9lbW1scE44Vk81ckxUMEtKakVUSWxs?=
 =?utf-8?B?a1E3aVB4THhYT3ZoVi8xckQyY29XUGQrTU56UmMrbDRkNHh6clhKQmFDK3Bn?=
 =?utf-8?B?b1hMRlZZOWRjVlJDU3phOEFPamNqOEVwQWxtUGJUS1ErMXFwZ3U0UT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fb80c4a-8245-42c4-d200-08da52611b9e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 02:03:45.8482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mqZyaFO8SXg39PY9ZwqTMR/f7egg0wH3PBU8oPHSgq43BpwWCkDyvaHj4nGDCSEFiy6s69xWZ99nMsLyRWgznA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1151
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/16/2022 5:13 AM, Sean Christopherson wrote:
> On Thu, Apr 28, 2022, Manali Shukla wrote:
>> nNPT test cases are moved to a separate file svm_npt.c
>> so that they can be run independently with PTE_USER_MASK disabled.
> 
> Nit, phrase changelogs as command.  Referring to the patch in the past tense is
> confusing because it's not always obvious if the author is referring to this
> patch or something else that happened from long ago.
> 
> And kind of a nit, but not really because I suggested this and still forgot why
> moving to a new file helps.  Moving to a new file isn't what's important, it's
> having a separate setup that we really care about.  So something like:
> 
>   Move the nNPT testcases to their own test and file, svm_npt.c, so that the
>   nNPT tests can run without the USER bit set in the host PTEs (in order to
>   toggle CR4.SMEP) without preventing other nSVM testacases from running code
>   in usersmode.
> 
>> Rest of the test cases can be run with PTE_USER_MASK enabled.
>>
>> No functional change intended.
> 
> Heh, this isn't technically true, as running the "svm" testcase will no do
> different things.

Hi Sean,

Thank you for the review comments.

I will work on comments.

Manali
