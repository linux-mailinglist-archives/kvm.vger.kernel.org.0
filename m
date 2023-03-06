Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BA36ABDA6
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 12:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjCFLEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 06:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjCFLEF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 06:04:05 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2040.outbound.protection.outlook.com [40.107.100.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B6F900C;
        Mon,  6 Mar 2023 03:04:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFGcX8TKOmIVpjjGkPzJpaiFQkICGJ3jzGRI/OEzT071TorDAr2R2Y4gwD9KkK0V/+Wj/pSEqEHDYHpSIMvq5BL/J49e3wzE6UXNvkrGK0ui8GzT4n0NgKgzod5bzhbaZEm79nq8Lwq7nO4wUOZLZ82kNtdUDOaRg37VoWI81jvilFvuOi8s7jR9o5LYnWGlveUrKcIeId7ewfVSPBtGR/hBGMv7dihNgMpLWER6w3bFtjbWIUxQ1mrkusRqtAzLrKYJ6iamU+gdThofDj0P8iDJ9a6XHaYEDcM1Zk4s77G5zzFtUTl3A3XLMDEGk3Z2AJk3p1j0n4/RMl9x21nWiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EQ1BgrwE2pWCx6jHyKUwuP4k6T2Gnvkdz8tkHS7df9g=;
 b=JIZ+xPIkmZ/jFJgD4J256/R/cMO4gB4dTFvnTENnQg3A/9yM0rE493lf66w5VXGBwmuHcp65uqQOpUsCiIGO3mnbkfjeOOR8HMT4tdcPHV+YJIZkmS6Dayef0/TnNh4TapZkeWqb3GSEd8fEy1JACugbLvZrfsDzBLqxu9iOR7fSUFl2fuuLWDGOimJQU+C3zGxZFVJc1WydjfRGlXAy+SfKpI4x6BKGJeFGOOs7zYT8woZTUigNlx8PIlDwJFq4xm2D+Lunv9k2X3+jq6LqwdU5JfL2nyAtp8r3saEbzM0iJ3y6IJwNARN5URCfGWWxpkLd5CxNGezXsf0rAI4JTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQ1BgrwE2pWCx6jHyKUwuP4k6T2Gnvkdz8tkHS7df9g=;
 b=sbLeq7ZY3bSipJA7EhLxo589NjHv6z1y58yaeZiipnOcWglJWrv6HO60ce1wM2/zaPx8f7855eB5VXXTc+PZboyaH3288V2lRQBR8MrPd2rtmJ8vDbfRACENS+254ON8fR6NWNa3ny4CibJsnf0BUT5rrJucDtvuOdKMlNb88pY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 BL3PR12MB6378.namprd12.prod.outlook.com (2603:10b6:208:3b1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.27; Mon, 6 Mar 2023 11:04:01 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::6c34:2aaf:bf7:c349]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::6c34:2aaf:bf7:c349%8]) with mapi id 15.20.6156.027; Mon, 6 Mar 2023
 11:04:01 +0000
Message-ID: <d85c1028-0fd9-52e6-1c3e-a8e50ffb57ed@amd.com>
Date:   Mon, 6 Mar 2023 16:33:34 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC v8 09/56] KVM: SEV: Handle memory backed by restricted
 memfd
Content-Language: en-US
To:     Vlastimil Babka <vbabka@suse.cz>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-10-michael.roth@amd.com>
 <8670a645-f48f-1d64-e5a5-291f2593643a@suse.cz>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <8670a645-f48f-1d64-e5a5-291f2593643a@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0236.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::20) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|BL3PR12MB6378:EE_
X-MS-Office365-Filtering-Correlation-Id: ee236e83-16e2-4dc0-b311-08db1e327d7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4OJCLTYZx1iBm5RfIQu9GjTURhAJaFm+151yBWlgYCJNUcXwJuLR47xWbvPmIY/wleZR3N6FZk4O7mx5hlri1BDu3zf1yhIejzdYG1R22CWUFqguZPWs6fnk0ijqKhrWM6lxB9jCdiTDncUaK5tPEGDyCYZlaepcJl0Yg4Nvtf30P57+SAubGYxJ8jYStKlVjXC6K9Os1AZtp/gl/DrLQpmScanLGTToSpBuKX5YJyQY3r2mY517XRttSfludLOV4qA0VkvbdZyY4JbFSWim1+kJqXynJVNyx3Iqn8ayhcuGhOnTjAsRBEXcG2j9R2fgDnxQgmCmY4Q3DCw17NHy+ESA9C5tJrMCDiZ+SH91rNSBpmsqy3PU2cZg8juXiyVVoG6bvU+kOianssYDzv+2xJMr96t1Ct0McNz38peiF4fp2TFjpW8nHpOcDMcdEP++vu6L+tjrBRP/ORwocpTBwJK/oO8a6VTNAoTT+IysRVjixeT4b5ShMz9//fvzw7xHQIpJsJU67q2xuFHt1okZ/M5QLY96iBDCRdEeUqo/5Oz9cwrYaYPjusFv37wpksMvPy8Hq8qLsG1sTtwkDxKYb8E9uc/XJo7oSiOau5qiMhDgrjwxxiv3zDCl5pGcRtXgg/Ue7ETly41xEWHG9FxzYXAV5iVnw/s+TwoYqL+y5l9Ctlkz+bLLQOirkxmVVPCiNYnTrmw35fUpUJEPEVG/4ilYLSdUM5qbY57CFZTgv0Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(451199018)(4744005)(7416002)(7406005)(5660300002)(41300700001)(8936002)(2616005)(2906002)(478600001)(6486002)(110136005)(186003)(66476007)(26005)(316002)(6512007)(66946007)(6506007)(6666004)(8676002)(53546011)(66556008)(4326008)(38100700002)(36756003)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlVRa3l0QWhwemNOZ3NJS21tZlpTbURmTy9jc3M1bmNwaXVIdFVFd1N0NSs2?=
 =?utf-8?B?L0tQTmpmN21hRkRVaGZKYlpRd2EwR1E5dXl3ZEFEU1BNQjhHbHdPNEw4K2pS?=
 =?utf-8?B?OVhRNmZKVnNlbUpOZGlObEI5NU5HU0VxaUxwZHlLWWxWYVlIUDVVdEQ2a2No?=
 =?utf-8?B?b2VrTnppdVpNN0M3T0kzeE1tYXpJUGpmSHdXcnl0aU5oTmZBcmVzNjZPbXg1?=
 =?utf-8?B?NEdXazJHcHhLWUZSSiszN3FYcnQyR1RkNng5SW1tVm4yZ09tWjZaY1Z6TmRU?=
 =?utf-8?B?Z1h5R2tDbU01aXQydFdnblgyb0l1RVFHeitRY1ZZZUdkZk5tUDBNeVhMOC9C?=
 =?utf-8?B?YkFkTkgrWVI3WUNUVTJ5RnVtRFBreTBxYkhST2ZoWXE0WXJtbUdXN0tjbk82?=
 =?utf-8?B?cjZheWZQaEE2WGJ4OGk3ZW85aXcxQU5SRWI5M1F3Vnd6c2NmeCtLRTFiR2ZQ?=
 =?utf-8?B?ckpORWoxWkVtclZTcEh5elUrYmR4ZENuMnRrd2I4OW11dEJBeU9oK1dFQnJB?=
 =?utf-8?B?OG9tbXlyK3B0WVNVQlJyY2lnYVBTZzE5RzlDc3dDVTczR0FFS2srNjJuYVhz?=
 =?utf-8?B?YVhCcHhDb2tnL2NLZWkra0t3b2V1ekZEZjlkNCtTalhHT3dkZkgyWGlYVDg4?=
 =?utf-8?B?Wit0KzhkRHNpbFc2K2l2Y0puY0JxUVhlejJpc3prVjQveFF6OVBmMnBUR3Za?=
 =?utf-8?B?T1FBOHNTanBkVVhQM3pjd005cFQ5eGltRHFSTzg0VnpTWUczUDAxYmduNWl3?=
 =?utf-8?B?Sm0xb1dJUU1wRklaaGxBV3NNbGVBWHVaMmppMDIxamJENmFVMkdOWDRYbWFm?=
 =?utf-8?B?YU1KRjNDc0taM2xaSXBSYzNsbGdmK3BpNk1ZbDI3Tk5QR3FXY1hPNjEyOS81?=
 =?utf-8?B?cDBZQndWcnNQWVN0UnFnVmtocm9YY1A4NTI2dG0xeHYrSDg3SG5raHByM0J4?=
 =?utf-8?B?R1lwUDhpbTBQM01nSEZBTkxoUGJCRmF0bjA2V3ZOdEZ1RGs5bHFzYStFQ1d0?=
 =?utf-8?B?MmNNVHcwWjNvZ2pKT09VeGZXcjY2SnJ1VElmT0d2ZlE2RlV4eDVDYU9jb1Zy?=
 =?utf-8?B?SzlLNlFnUmpZcmpKN2IvYTVVOE9RWHBsRWFhYWdFUi9PSXkzTkNNNC8ybXp4?=
 =?utf-8?B?aE9Pc2ROUUVyMXJXZWJHR1dlc3ZJd3NnWEdXdUZFZmpiYkdSeDI2WDJmNXA4?=
 =?utf-8?B?SkVGa0hCRytTYnpIZFFWWk9WaG13eVJmL3A5ZzdqWENka2JGeU00TjQ4Ympv?=
 =?utf-8?B?ZGgvV29LZmZ0NlpkQ3MzZ2hqYzhPc1FHdzN5dGZqbzMyUi9vWHdTbEZPWWww?=
 =?utf-8?B?c09XaGhpNVJIeDVmV1JXeWROMllrRmRPeGw3cWpObFJxckdsaDFYc2x6aUFm?=
 =?utf-8?B?UXAwbytXNFBtTkdTUHRkVVczdlZ4VTlrem96UXdmckVRUjJmRjNKdGtGWm1j?=
 =?utf-8?B?alpTZEdJOC9kZmRFb1RERXEzSjY1Y2plOFU2Y2ovRWxyR3l2cGVvTjR1UjFB?=
 =?utf-8?B?TnY0dXlqRkxmWEE0Ri9wZm92ZFNsMDFZY3RyV0pVNFF1WU1STGNwVkRGNWla?=
 =?utf-8?B?VmJ5MkpBRmxHbU81aHc0MVdPazRiTWJ2RklpZ0lhK2hoT3E1TWpSblZJcnN6?=
 =?utf-8?B?OGtuMkNoRmVTdHdMaUZvNmdkdXpzNjV2WHIvZ3ZSdmVHaUFVcWZHcCt3YW5k?=
 =?utf-8?B?QlhjaXNNVUxEM2dZSStkU2NzbmVEMFBXNXI5QldGU2ZvSmZobTkvY0FINEZs?=
 =?utf-8?B?NkpkTGhtTjZRSGxMTlBpUWJDL1A5VVZLcUtSSXp2a29qQUpQUVE2RUIzYktH?=
 =?utf-8?B?aHlPMVdyVGNDK202VjRseGtuTlpFeGZET1ppd2RWNkJiWlVWU2ZHZlUwU2JU?=
 =?utf-8?B?V0xtVm5GZ2hlbjJrZmt6d3JsZ2poc1VyTFNXODZXaWZTQWpvNHdzaFBpclNX?=
 =?utf-8?B?bExETmJXeTNjMlNrV1A0L1RvOCt6bWNKOXYxWGZld1FHUGpmUHpiT1M4S096?=
 =?utf-8?B?VmNSQ21mVjR4TVFyT09WbGY1eTNrWU5sTkQxdGEvRHNqcWplVzdxMXE5Sk9i?=
 =?utf-8?B?R1BmWUxkSDJDNmFFckdFT2VqbWUrZXNPaUFPZ3RQRE1SQ1FCSWVOaGRlcjdE?=
 =?utf-8?Q?BsPc+SeYWaTU/45unUNq8StEq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee236e83-16e2-4dc0-b311-08db1e327d7c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 11:04:01.0433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: US74AHVma9tjXAlNWwMWSiNZbjX6J9OdHFQExLbLvpyUYNOlEeGMgFAX0kwhCGa/IIzJZqBpfoMAFVBnXAZRnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6378
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 03/03/23 19:35, Vlastimil Babka wrote:
> On 2/20/23 19:38, Michael Roth wrote:
>> From: Nikunj A Dadhania <nikunj@amd.com>
>>
>> Do not pin the guest memory backed by a restrictedmem backend, as
>> pages in the restrictedmem are already pinned. Instead, populate the
>> pages array for these guests using the already-pinned pages provided by
> 
> IIUC the "already pinned" became "effectively unmovable and unevictable"
> since the earlier versions, so that would be more accurate now?

Yes, that makes sense.

Regards
Nikunj
