Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BC15F6D13
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 19:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbiJFRgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 13:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbiJFRgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 13:36:38 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2075.outbound.protection.outlook.com [40.107.96.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626F2C34EA
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 10:36:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SqHkumdFTTF7IKHWCTlEuOheVnxg+2EkzckQLab1zoiBidtKR9iWl7RCnp1ZzQqOLhDtRTYuEkNu6Gcdfjd9OSA11fYDdpmHJTxDiSrLtB8uxT1oPVQoluXXpCXfFKA2TbArN10MMYgQ086gzeaermKBU6YxtoWY+wBJUGzS5LvUEphTuINPR5wXAmCIa5Wgou4NbF0LUidxvrmnnfKXxmVzgue+KAZfKzaQKm8j4YEmhqhB4DaLBWR90INC32GAibiPCnXNcW4npFUeGCSnpFYokt8noUacdITcxH8BVzBqzy+cjLDVUggfxT/ZKxtdpiMnPpQAdwM0EFfh/T4jTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jgsCW1+enaluS+JrzNACbxsjBDegKPgmYIfJuSaQt/U=;
 b=XVZ3+EEkbavl8Cy8reiM4BA8AWPYgtiTei1aQcofAb7QyTiShCNGqhq38u1wfBNgEN5dh2bLDQ8H7bPInHoWiybmZkfmLEAS9N0dHz8gRkSHtoSVDO1K2OG5A09FhGI6GHf7bmUy/TuV8cDiCLh2FRITgr3aZn04CNezZw0mv3pjD6KrQy3R+QCivT0abfrYy1PLX49K1HjrCWLsHmBC+zvR/ibwJ/qA6Ro/cOMobwNfvJ6DEd3+33kCXF8vke9lYSowT2tghyflUhngmObEQP5XE4UR29/DxORHQCI3UuYBQ4fpQed+6t14nYLhzAbDgHPZtK6q4wlj8XDsTjDW9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgsCW1+enaluS+JrzNACbxsjBDegKPgmYIfJuSaQt/U=;
 b=eIxd9cjYTxuiIaBTeb2Nw3vLs6tEUKJZzbQRfPFb4WleQY4S4mBEYBAFM0NIXRJCC01FM+MrnIWzJPQb3PgJLbHgzj3t16yE5kqMrLuL35lQcwF8L1Oa5qDzMUO1IANoadqfhSPaiBA8nDDn5DRM4D87axPX/fjVvbE3eMgguJ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32)
 by MN0PR12MB5740.namprd12.prod.outlook.com (2603:10b6:208:373::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Thu, 6 Oct
 2022 17:36:27 +0000
Received: from BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::656c:7eb9:e45b:54c4]) by BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::656c:7eb9:e45b:54c4%3]) with mapi id 15.20.5676.024; Thu, 6 Oct 2022
 17:36:27 +0000
Message-ID: <215ee1ce-b6eb-9699-d682-f2e592cde448@amd.com>
Date:   Thu, 6 Oct 2022 12:36:23 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH 5.4 1/1] KVM: SEV: add cache flush to solve SEV cache
 incoherency issues
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     ovidiu.panait@windriver.com, kvm@vger.kernel.org,
        liam.merwick@oracle.com, mizhang@google.com, pbonzini@redhat.com,
        thomas.lendacky@amd.com, michael.roth@amd.com, pgonda@google.com,
        marcorr@google.com, alpergun@google.com, jarkko@kernel.org,
        jroedel@suse.de, bp@alien8.de, rientjes@google.com
References: <20220926145247.3688090-1-ovidiu.panait@windriver.com>
 <20220927000729.498292-1-Ashish.Kalra@amd.com> <YzJFvWPb1syXcVQm@google.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <YzJFvWPb1syXcVQm@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR18CA0038.namprd18.prod.outlook.com
 (2603:10b6:610:55::18) To BYAPR12MB2759.namprd12.prod.outlook.com
 (2603:10b6:a03:61::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2759:EE_|MN0PR12MB5740:EE_
X-MS-Office365-Filtering-Correlation-Id: 841af539-a2cc-4f81-4c41-08daa7c14bf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Xef55GYWbp/TccO3TDmvFP688x3qJhkunnBMTTS9q4DUG6oqn/TW4pbrztawamd43kgGUlkDdT869oyxGicvkqxlaTkT7nBY5Vmj2pAEYRrr1Uj6UneD68wAqwscpRWiBCT45mZToVL1yfpIKSGbpW9zc4bJHkTfIHXvVJLlWc7RjKM3bTMl7q2kohOkdg8RDF/OdA7IWwS49+IzZue2rnqOH8LkziAmF41zdaXuysCsVjAKdd2/LDTlD+PE0issH74Puub0DemdCJyIqB1fnci7vhxXf0n6y3xefJbJJIued/Fnfc32CRTJWADD1rW/PeOZf5c+o7RJHWwHWZcMYLX4t8IgLeq6TwiBWlEWPiXannL7svNXPwR6wNUQ/SpK4T+8ZrBdFigGIZ2it+7jzEyf/BkFi+NgxMwSQp9bNTVKPBr3ynyCzgKHuNFuJeBG/eUugtyfQbtcoKjzOQRCS+kpIOoTqKjqQPKqjF0fWxteaD3RtuHZ4mSZes5QTOInKsuZ4PkKXyYnyCO2Y5uHUn0qldbZkAh/84HETCZeb4SrZ2nC+gzFnV8LKdk7UzrlyDwlxhLpjuZBpLqz9c3iYNoSJv90kj/JPLZHoU56BvIm5baWEAlb1zgYbRPZl0vtLxtlVgfH0Tv1UOa5CkIG/ZW2FfMxfbmo9mqfujXl26+ZpPunYN3EQ69W8LQTE5Nm1kmS56dmS+nfBAfZY5l/Sc4zcXUievGPdu9UQeQW/99knB3d8khR05Q6UT3GUpHBSCHghHAUvboWjr/m6sU5aZ/KPLjIZzFJhq8/ypCsco=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199015)(6666004)(7416002)(8936002)(2616005)(8676002)(41300700001)(4326008)(66556008)(66476007)(6512007)(186003)(2906002)(83380400001)(53546011)(86362001)(36756003)(6506007)(31696002)(26005)(5660300002)(66946007)(31686004)(316002)(38100700002)(478600001)(6916009)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXl2M1hhRHNESFB0My9CZWJZUjNJOHNORHk4bW1lNG9CbjByVm1wTzZxU3oy?=
 =?utf-8?B?S2ZiQ0U4WjkrbkpZMEtESlV2Q2F1MWwyZ0dUa2kzVVJYMzlHRityNy9EcDd0?=
 =?utf-8?B?U1kzNDJkOHBKczZ3WDF5dGEvNWlJdTRTRTVkc2VzUDFINkpJenZSR0lIcEVZ?=
 =?utf-8?B?d2tRcGxwWCtCdkhsc0UxUjE3aDl0akdEc1dRZDlNblVLYnhSNWFzUmpEaGpU?=
 =?utf-8?B?OW0yUytIbWRuTmZFK080U0hWSDZIVDhFUEtPZlRxeUlYR0VrSEJIaXBaM2tm?=
 =?utf-8?B?QUlJWXRpWFppTUtrODRBaHhKRWZRZlRuSWN3YVA5TmZNSFl3bHlENjRkUWpq?=
 =?utf-8?B?TDBTS0xqTjBBVG53U0ZDVTZZcVZMbXBXaUc0NDFaYTdLTWlLR01SWHpWa2hy?=
 =?utf-8?B?MjU2WVhVWWVLeVBRc0tSMzV4Wk11WXR3dDJyWWUrNzAvZFg3bi8xbnNMUGoz?=
 =?utf-8?B?U29sSlROd09oSitrZCtVclU1Ky9vZjRFMGRYTDdpMm1QWGNlQ1ZDcUZyMFlu?=
 =?utf-8?B?dFlnRnlUQTdxcytsR015K3BwQnViMFFYNmNwVitUQ2dqNXFPVDN5UzFHTzBh?=
 =?utf-8?B?ZDk4eFluTkI4OXBrV2I0bi9aREx1a3hDWXR3K3Vtd1RuNjNsa01ZYlBZMG83?=
 =?utf-8?B?RFNmWit0azJDeGM0WFV0YVltc0Q5QVc4RU5ZZlNpRmJzK2JKWW91OXFiL0hv?=
 =?utf-8?B?MytwbmVzZm1Vc2NzYTFaem9hZURwY0kyV25RZ1ZEZHlHaEJ5SkI4d0VzVUY0?=
 =?utf-8?B?dlU0YThxWWdxSmtHem8wZndIOE5IUGJ6Z3AxalhiTy9KUzlnMU15L1IvNEdF?=
 =?utf-8?B?MjMrVy9BUXNJb0t3L2NTYTlXd3ptWkF4amVKOWQrUWhjL2ZLZWdxVUk2Njc5?=
 =?utf-8?B?QUFaUXo4YzFBWXYzQnRna0hURERQQnZ3UE1TejRpSVZZSGF4VXQxZE05ZVFD?=
 =?utf-8?B?Nk1ZekYwUCtjTy8zelM4RU1NeTFoK0VoL0c3cXRORnhJU3BKcDFFL090aDFi?=
 =?utf-8?B?b3VKc3ZVc0dIcGdCNE1HS0FrZWJ3Z1Y5NEZYUWV0RlZ0bjR5bXZicUZWZ0R2?=
 =?utf-8?B?eWdBM0NYc3dodElVMW9oVDFtVmU2SHU2OTY2OUpnT3NwNXRGNXR2djBYUkU4?=
 =?utf-8?B?UnhKQ2RaVU91M0RiL2RSWXBmM3NyUURLMW9qWGtUMWIvUVJuTjgrbG8zaVcx?=
 =?utf-8?B?NVo4S0UvK0VDaU5xNFE0a3lDaHFTWUFLOGU2d0NpOXJHcnVlelBEakJjdDhV?=
 =?utf-8?B?dWE3L0FMeFBLQzdLYkRrMHh4VzFMVlVLblhQaXA5c2xRZ0w1UlNkaGtmR1JI?=
 =?utf-8?B?Ykc2TXRJdDNGSWRQN1FwYWxkZnVPQXVCV0I2TCtnelhBWk5XaXVmQU1YK09k?=
 =?utf-8?B?dC9EbnVybzYzQXJSbDJsVk5EU1I5YnhkY2dMR3VhUmpENGJCaVNXbkNkNmRN?=
 =?utf-8?B?ZTRIL1pYSVAyT1k2eTdrS0NhR01McjBqdGxaWGxaNUUwYmcrMzBteXZMK2Vl?=
 =?utf-8?B?UWZsc0pnc1dpbllWVFJMV3JKaWM3UUZxYWFDS09zaklUcUtkbnFyTGlTK1A4?=
 =?utf-8?B?VkFEYnZRZTJvZ3NIVmZBZVdraHhpU1VaczhQaWUwd3JsVzV5dmRrTnpwdTZq?=
 =?utf-8?B?THNNNkVDUjlGMUtjdGppZi9DQlgvd2F2U0h0cUd1eHVtWjRuQWtFOGlKQlZi?=
 =?utf-8?B?Qm15N3JwV1Z6MU1WWk15d01RejUwTE1RdmRzMWxiU2wxcDQ0SU1XZGtkL0Fi?=
 =?utf-8?B?Q1Bmb2ZNWElLSVROeVgrSkw1UWxKVWFzQVM2bzJLTTlXbzB4NnVHRSs4dXdV?=
 =?utf-8?B?N3p4SmlyR1BUcUJkVEpGU1ZxYllGTkExUTBzM0FaRW8yRjYvK3JMZFRHV0xq?=
 =?utf-8?B?S0M2S3Bpb0htbEVHNVJ2U0YwUFBMVHlIQ0pQQkZWdDhIT2d1L3lUZEdleWlI?=
 =?utf-8?B?cjN0d0lYbVlsVE1Sem1EM0RQK1dXWXNiVy9saE5CU2daTG9zUHBSazA2REMx?=
 =?utf-8?B?bjYwUGNYM1JCUTZ5QTdSUU9VdkFyS3h2VEs2KzFvUlJZVmRTN0JiMzIrb0Rs?=
 =?utf-8?B?QlNGVW1FMytkU3VLSXltR1M2WXFjNGs3VG9LblJxQ2NQMTFiUEU5QTVGRjQ2?=
 =?utf-8?Q?JNcjg5OsbgxaEh1FfjXeplO6o?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 841af539-a2cc-4f81-4c41-08daa7c14bf5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 17:36:27.6083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /IFjd07l8t7W0JjmhCZHYdM+zVHUcwkyoX4HpAeL9n6pfAUupXqkBo4xG/g4nv1tpg3IL5rlZjXbQdgNpAuCZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5740
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello All,

Here is a summary of all the discussions and options we have discussed
off-list :

For SNP guests we don't need to invoke the MMU invalidation notifiers 
and the cache flush should be done at the point of RMP ownership change 
instead of mmu_notifier, which will be when the unregister_enc_region 
ioctl is called, but as we don't trust the userspace (which can bypass 
this ioctl), therefore we continue to use the MMU invalidation 
notifiers. With UPM support added, we will be avoiding the RMP #PF split 
code path to split the host pagetable to be in sync with the RMP table 
entries, and therefore, mmu_notifier invoked from __split_huge_pmd() 
won’t be of concern.

For the MMU invalidation notifiers we are going to make two changes 
currently:

1). Use clflush/clflushopt instead of wbinvd_on_all_cpus() for range <= 
2MB.

But this is not that straightforward, for SME_COHERENT platforms (Milan 
and beyond), clflush/clflushopt will flush guest tagged cache entries, 
but before Milan (!SME_COHERENT) we will need to use either 
VM_PAGE_FLUSH MSR or wbinvd to flush guest tagged cache entries. So for 
non SME_COHERENT platforms, there is no change and effectively no 
optimizations.

2). We also add the filtering in mmu_notifier (from Sean's patch) which 
invokes the mmu invalidation notifiers depending on the flag passed to 
the notifier.
This will assist in reducing the overhead with NUMA balancing and 
especially eliminates the mmu_notifier invocations for the 
change_protection case.

Thanks,
Ashish


On 9/26/2022 7:37 PM, Sean Christopherson wrote:
> On Tue, Sep 27, 2022, Ashish Kalra wrote:
>> With this patch applied, we are observing soft lockup and RCU stall issues on
>> SNP guests with 128 vCPUs assigned and >=10GB guest memory allocations.
> 
> ...
> 
>>  From the call stack dumps, it looks like migrate_pages() > The invocation of
>> migrate_pages() as in the following code path does not seem right:
>>      
>>      do_huge_pmd_numa_page
>>        migrate_misplaced_page
>>          migrate_pages
>>      
>> as all the guest memory for SEV/SNP VMs will be pinned/locked, so why is the
>> page migration code path getting invoked at all ?
> 
> LOL, I feel your pain.  It's the wonderful NUMA autobalancing code.  It's been a
> while since I looked at the code, but IIRC, it "works" by zapping PTEs for pages that
> aren't allocated on the "right" node without checking if page migration is actually
> possible.
> 
> The actual migration is done on the subsequent page fault.  In this case, the
> balancer detects that the page can't be migrated and reinstalls the original PTE.
> 
> I don't know if using FOLL_LONGTERM would help?  Again, been a while.  The workaround
> I've used in the past is to simply disable the balancer, e.g.
> 
>    CONFIG_NUMA_BALANCING=n
> 
> or
>    
>    numa_balancing=disable
> 
> on the kernel command line.
> 
