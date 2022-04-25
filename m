Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C2050D82A
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 06:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240951AbiDYEP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 00:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241069AbiDYEPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 00:15:02 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945B4F57
        for <kvm@vger.kernel.org>; Sun, 24 Apr 2022 21:11:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvsviIhiEo7fMPio9ZaIFtonZ7C/C/plUXwG1STAVSTcKOjchb87NlAqeN62nhOSkH+/uyDDSXQzUmwRCQY/9MFg5stZMyb/2YgGF4QHgq2HFucL3T7UmJhnEC1MgwceZLXw99FtymECFsN8GF7mTPyA7oFtuh/Cl9wskG2AQQjp3Z+DQRkO9DcbEiwUTobHJzaVfKSC03gEZkj4M+itmcNmY2NNvujB9TEsVdibmQana/NAWYHWB68q4G9MfUmJgnviamrGSbbmbtt9wAizirNtRFu/BgOAjSqbwYAWiQ/fzfyhffTlv77T87Ye/FkQCEfsfeCs9bygqXynsM8MBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BIaDNa/6iVivCeFTQPQoI0WCrRTVZRcYrf95J3EzJdc=;
 b=QrJMscn0i/TnYjw0C3j0Ql+2m1x3t06mFG4x9/vV0XLcO9+E/oj15+p+frr3bCFJRlskVFrs+0dQVXVmWgcOxT+fvU8nJkdIfO5Z4PS1dDT2ZBHRDjDwnmT1CzAMbhGxkBaZ03Hcd3+FduhstOk7sRGa9mShlDlhWXRddorrZqLe50reoxw9QMJSNZY/3qY3PXV8CABy112A2Nk2FzTJl2y5QymnznyxoUPu4HfvoDh80MUXIwP55jZb6Ru1nTm6+wATY3TbBm7uh1lMNdjbJhdHtxmGJMMBlwdIcIt7aTvbQUxs4vWJ9eTU/LJddyec6jBn6yAAOMUB499BpO3HjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BIaDNa/6iVivCeFTQPQoI0WCrRTVZRcYrf95J3EzJdc=;
 b=Gh4MtrC/UhE769Dr4jfshWCNTnZw9Sj18AoCSTmWksrtk07gt47yPT4RyRLPG8luaAh5oF0zi6RDjeRQbYjOgTD+p+2bazhj6KWM1iISB+Pb56cvLqsnQtl66UnImrXkVrTF9TYk/Q8GbaKqeG2uxE8Rf0oAzXRbh56AANSHTZc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18)
 by SN1PR12MB2479.namprd12.prod.outlook.com (2603:10b6:802:29::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Mon, 25 Apr
 2022 04:11:47 +0000
Received: from BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::acb0:6f4c:639d:705f]) by BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::acb0:6f4c:639d:705f%9]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 04:11:47 +0000
Message-ID: <f1ca676a-72d1-c953-2709-dc475b78eb9e@amd.com>
Date:   Mon, 25 Apr 2022 09:41:37 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [kvm-unit-tests PATCH v3 0/6] Move npt test cases and NPT code
 improvements
Content-Language: en-US
To:     Manali Shukla <manali.shukla@amd.com>, pbonzini@redhat.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org
References: <20220425015806.105063-1-manali.shukla@amd.com>
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <20220425015806.105063-1-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0103.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::15) To BN9PR12MB5179.namprd12.prod.outlook.com
 (2603:10b6:408:11c::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59cfbd83-9acf-4c22-460d-08da2671b708
X-MS-TrafficTypeDiagnostic: SN1PR12MB2479:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB247912CAC1AB4FF8672060D0FDF89@SN1PR12MB2479.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mrj454zj9sX44t7f5hSoNkhffB8o0dJWcB0P3StC6h+kX+KnEb4SQH9iMIwFtjgwd1rA0fxKoQG+2uTGH7Jp7rUlLYQkowJFL/gCijsQFeevR3+MkFfqI/4IpadBIJBOX0vIdsw5nkU45llANKqcyznG6+86ImbXdoWnsaCnFBdwhlyJRnE2n6X6Ft+65McQMadjpPLNQS/qQNGKQeAwcaZ9m2JfBPFgMFgZ+HtFClqrdbnjwx+wxnMJqI1ZI/qhFaHit5rRKW13iPNWvapR7RhxLctxqCAveAzmfQsvP3GSfY9bMassWmkUX5SAiUgJx0z7V8dQThN02cPzPL4KfL6qFxmhnXKYlLzlydmmhtaWsss21xfCujI1Lj9LKr4CxRqZ+/Ifa7ZyQRoHz8XXEG6vDsMd00SgliDDCLK7rQjxQIvLZ2dIMp8TRyaT1wuOEkNPCxJEcnGRSJGPi71WZ9FNYTFbq18rAtQQ+slEkGsUYjEdrrvYr/mZL9M/TnVy/X51pHgxPXIbFab0/+PmdPniU3CvWlOzguYcuzYOcZjZskdzh7Gtr5NUStVaESF2JlwRp8zvGzxPluAHckD0M7eg++YDSBulaxvg3R4+4UlnojptS+vhLWVjpYgAr4xOV1e/LW2TybXp1i1txwqOugDF6uLCCeeB1x9vg7OlKKYwTGB8LNe83lN+xGBWLUP+dujkzX+jnEH9ZA2wL/KbY+amCKTpe4YYCcj6omCWvO45caqPSGAJTOYaIY2OND3d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(5660300002)(2616005)(508600001)(8936002)(2906002)(31686004)(83380400001)(8676002)(186003)(66946007)(4326008)(66476007)(66556008)(6512007)(26005)(6506007)(6666004)(316002)(53546011)(38100700002)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3Z0cVQ1RU1ieG1JdHpsMXgyYUlFR1VtYWlWSnZSMFVyU2RxTU9jSVFpM1BW?=
 =?utf-8?B?NlEvS0U4eCt2Mjg3K012VTRiT0dzTGtFOHJ0MGk5U1l0MDdaVU54RWxyaEN5?=
 =?utf-8?B?WkUvTEFhaWE2RWIzZmlDWDQrTjZMQUxBL2JVdTVpbTlJMTdOYnd3czBCMEV5?=
 =?utf-8?B?MndYNDdaNlFSYXM5VHBWYlBiUGJVSVdwem5sOXZ3RWdiUnNGdmZuUGk0SkJv?=
 =?utf-8?B?eEZsZzRmSjJBVjdwZWZFNmJINkxWVTFqeTZPUFVxaFpnM1VYZmJrNjdYZ1Zz?=
 =?utf-8?B?akZrKzJGV3NhUWs0am9NZWdHOFVDZnJNK05UZ3VWRHFBemFqczV3WjBZUFh2?=
 =?utf-8?B?UVBFSkljWkxhN25Qc2lSK25MOVl6em1ZOHpEc1gzeEFVUkhGaFI2ZnRDZzAx?=
 =?utf-8?B?UFpibWtIanFMUGlQOEo2eE1mbng3SXhZS1ZqSFJZTXp1QVNWQVlnWmJkbGl0?=
 =?utf-8?B?b1FYdG9YVTNpZ2J1dGlQQUVtM0srNkZtYzlTV0k5ejJBWkNNejJ4T1YvUTRv?=
 =?utf-8?B?UjNpZkt2T0ZqdE5xTlFRTEl1M2xmTGhFQnB4MkZ5QzhtZnFGTUZtL2o1QU9x?=
 =?utf-8?B?RzFDR0RGVWVqRVY3VGZxK3NqTnV2YnVFWm5iUzZFeit1bWQrMlFuVGdoTWti?=
 =?utf-8?B?UEM3dTZaYUNVSVBsVzBYN29Nd3pPTzd1MlA5c0wwMEZDUzBwdURvbEJMNkx3?=
 =?utf-8?B?WjBJbXY1MEYyVncvVFkrUGlQZmRKTDRZUmVLNkJtV3Ixd2VvNUxwNjhDbFg5?=
 =?utf-8?B?ZjVaaVBIelM2OVI3N1pUWk5vS3dQK3ZtWDBGcGJBZU9mNFk5VjBXajJVRkd2?=
 =?utf-8?B?eWJFeFJmbkpTUHRwdzVoTTRoU1FSbDNTNFZXbk1kYXFIMGxOL0h3ODE5TWpG?=
 =?utf-8?B?ODFHRmw4MzVzam56VHlEbDdTUmRZRWUrdWp4L1FNdGVQWjF6SVoxb25VdCtX?=
 =?utf-8?B?dHljTW04YksydWxUNzdXY2gwVjFRN3JiTVIvUWtreSs0emQ2VUZ0RVZ4MHJj?=
 =?utf-8?B?TS9yK3VNdjRsVjJUNGZwMWxzL3BWVWt5NkdOcEMzOVFoeVFEWHhEYmVaK3c0?=
 =?utf-8?B?SDM2NUF5MCt6YzVJMFBkQ1NKQVhxemZNUk1wdUlHYkx1RjVqUXRTMjJZQlp6?=
 =?utf-8?B?d2NicnhvSE41a1JhMXBrbVZMMGZ4RlZJYTYrdHRIbWJkRi9hc1VpTVk3MVUy?=
 =?utf-8?B?UDV5bHdTazN0MEo2MFlqNEovMVVrVkFzci9LTU5iSGhiTThmZmpKMHdKTm1O?=
 =?utf-8?B?d1VyZkp0TVJDL3BjdWNGL3JxMDVIL3l2VUw3WHZXR2hJUmN2cUpSQnd0MnlQ?=
 =?utf-8?B?ajhqQ0tZdlJibmUrVnR2ajM1ZDFHVlVyRkpaM3JaZTlTNmdTUjJGZlc1WUVZ?=
 =?utf-8?B?MXFuaFZlMVdrWmdEL0NMRWRaclNxWGMrVFFXM2xaWkRKKzJhUU5KMWNMRG5Y?=
 =?utf-8?B?bzR0NnJUTEJXNkRmUUQxd1lWeWxYL3lCU2oyL2Mxa08xTjRjdDAzS3VldGZK?=
 =?utf-8?B?cVoxRW5kZnRQRUd5REQ1dVlBcXNEb1p2azhXUGRyKzVLMjVJSXVQVWMva1Jq?=
 =?utf-8?B?WTI4ZE1jR0kxYjVlWGxVc0lWSTI0OHBsbUxhejVVcVlTTFdZa2JtVlRXaUYr?=
 =?utf-8?B?bW5tT3FGQ2l4QTdVNXd4S0EwS2puazZxS09vanM1UHhacVNFVHNtdlJuWTAx?=
 =?utf-8?B?cDVhOEc5a0N1Q0RsVlY5UWlTMmJUbWdPeVoxck8rN1FRN2RRS3lvZEZBSTFk?=
 =?utf-8?B?MW1yV3B1ajhjY2xySmlYQ2E2dURIOU5QaUI5MC9pczVxSDdZWjNQenlVcTJZ?=
 =?utf-8?B?YU9WUCtRY0puZDFtTm9JNG13VmRsaFdrMjdmZHVXSmRhUlFZZHRWc25xcTNQ?=
 =?utf-8?B?ZHNMbWpTZm5rOHp4MFViWFBlWUJqVnFMMWhiazFDcVpQZmxjMDAzWHBDRkUv?=
 =?utf-8?B?Q01YaWZ6TkEwTG1RSXRrNURGa1ozNjhnaXF1TDJtZzdtZysyRXZ6RFdveHRD?=
 =?utf-8?B?ck1IbUZaSVArVDFRams0UERYdGVjdmxVSGR2UFpnQUFHVkcvQVY3aVNRLzl2?=
 =?utf-8?B?dmJpc3JnZTNxdXdTNzRwRFc3ZXgyVFBObXpiZ0hqcHRCSTlMa0xzMkRGVU9r?=
 =?utf-8?B?L3hFbndsQnZOTnBxM1BKSDZMM1ljVXZ1bGRVZHk3MFJyb2NnK0I2WGJnSlRQ?=
 =?utf-8?B?ZmwwMExYREhPamhlVm1LdHE1NEZ0WnNKVXhIQ0Zwb3V0MGtJOEJxcFhkeWM2?=
 =?utf-8?B?SHBGdDJ6cWc1bVFxQjlYOXNva1E2YTNheWRSTUovdVJJdGRTYTRWdFF3R1Fx?=
 =?utf-8?B?UU9KVm5zUGN0dGx1bkc1WFNVNUl3S2p0U1FLaDU4cFd1N3VMejl5UT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59cfbd83-9acf-4c22-460d-08da2671b708
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 04:11:47.4185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TKkEWhDk48eupp/TSVb/vzrPGf8AcoWzuzRSU6SOcECBGWynkUZCCcR/ouc1UpjoSiA8tauVabPwWxr4RtYz5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2479
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/25/2022 7:28 AM, Manali Shukla wrote:
> If __setup_vm() is changed to setup_vm(), KUT will build tests with PT_USER_MASK 
> set on all PTEs. It is a better idea to move nNPT tests to their own file so 
> that tests don't need to fiddle with page tables midway.
> 
> The quick approach to do this would be to turn the current main into a small 
> helper, without calling __setup_vm() from helper.
> 
> setup_mmu_range() function in vm.c was modified to allocate new user pages to
> implement nested page table.
> 
> Current implementation of nested page table does the page table build up 
> statistically with 2048 PTEs and one pml4 entry. With newly implemented 
> routine, nested page table can be implemented dynamically based on the RAM
> size of VM which enables us to have separate memory ranges to test various npt 
> test cases.
> 
> Based on this implementation, minimal changes were required to be done in
> below mentioned existing APIs:
> npt_get_pde(), npt_get_pte(), npt_get_pdpe().
> 
> v1 -> v2
> Added new patch for building up a nested page table dynamically and did minimal
> changes required to make it adaptable with old test cases.
> 
> v2 -> v3
> Added new patch to change setup_mmu_range to use it in implementation of nested
> page table.
> Added new patch to correct identation errors in svm.c, svm_npt.c and svm_tests.c
> 
> Manali Shukla (6):
>   x86: nSVM: Move common functionality of the main() to helper
>     run_svm_tests
>   x86: nSVM: Move all nNPT test cases from svm_tests.c to a separate
>     file.
>   x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled
>   x86: Improve set_mmu_range() to implement npt
>   x86: nSVM: Build up the nested page table dynamically
>   x86: nSVM: Corrected indentation for all nSVM files
> 
>  lib/x86/vm.c        |   37 +-
>  lib/x86/vm.h        |    3 +
>  x86/Makefile.common |    2 +
>  x86/Makefile.x86_64 |    2 +
>  x86/svm.c           |  182 +--
>  x86/svm.h           |    5 +-
>  x86/svm_npt.c       |  387 +++++
>  x86/svm_tests.c     | 3304 +++++++++++++++++++------------------------
>  x86/unittests.cfg   |    6 +
>  9 files changed, 1979 insertions(+), 1949 deletions(-)
>  create mode 100644 x86/svm_npt.c
> 

Hi all,

Last patch from this series was bounced back by throwing  below error:
"BOUNCE kvm@vger.kernel.org:     Message too long (>100000 chars)  "

So, I will split the last patch in multiple patch and send it back

- Manali
