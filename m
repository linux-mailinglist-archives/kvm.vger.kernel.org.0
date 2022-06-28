Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C92055F1A1
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 00:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiF1Wz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 18:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiF1Wz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 18:55:27 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3B72A968;
        Tue, 28 Jun 2022 15:55:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aCxWqhVluItSbbnPvLum3M+7hPphNS4B7rX0SxA/hgL2cUL5gyghVe4GejrsQqpasuO0x5ju29JE0csYUbwF1E32+A23WX9ZbSdCgqNa8o7kQG13nL+u6MfNK3gY9sQXpYWppztJi2kZJG9T6yeDWHKr/Zj7kFk+lBTUjQQZBakdX3O9nlXCArC0Kig+5EpDi5F6u760A+YlDk7yhzyzjq3bY4AWjA91qylFSCXKe9u5XTsSN6TLn2RGglY4XRpsPKDCH3bV7zrIi9IhzrARh7Egaeo79bO6BLDJ/0672MscQJ5Rk1xsTtHojU7mDjcpnv4gxhm+KoSoca28bnSbzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zpzx+jSCS/HxoWu3iUCNo2i7Fl8A+ozpdpN3IMU3M58=;
 b=g51pBvhkKopAahCVyPpDQ+yqmStBRsL4QdVlw2swKRXkRexAdGoHUM0ZgRj33PIRQydxYP9VWumDzPf0cHkEnDrzyYe47rHKctSOG++nae7mAiOdj4n9PcdzFVSKPyfc3X0vCyrIKNffd44lo7VGFX09yNeAmRIrq5+uwdLDMjNxXpzA7YDeKw3X++FHBiACQQE9hlMab2NiYhEzE/hmI4FWDPUWHNVGG6LnsiUFn5Ad1zdJkhuPdMLj9Azpw+yi3eUufA1IF5bWidle9pnrL7AH9ddGkY2Dsnvj2zS9FVyLya6ASexAcFICPi1Hv8hWX0nm5PMXdKNJ190p4/Oi4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zpzx+jSCS/HxoWu3iUCNo2i7Fl8A+ozpdpN3IMU3M58=;
 b=Ta43H1cK2TC6/JKNT4/PUzHHKgXzUNzgSLPC5SwwIFhYdNsmRVN9O+U+lo4PMZb3EGP79r84ANJ+fdh6tNG75Q8wtAYUauQ7AMXB9AyTFlHO99PHjzkTM8x6s9E9pSG8NtWJ+2ZaMdh9Mk5YjVpU12A2XuO2cH01HAfqId+YtiXQz6gxFz5RxEuabYp4c2U404yxAZJdhKyL6BUJHVINSoy2eiTX5BNmE6a2Y5oAq732uC21fBCCY0n05vWbaxipcKiF3oIKhWpKARofKgVK/IHmpcnuNskeZqCuEOQmwRw/464FlgRtAYftMWuSZrWy6DV/jkoIhD09+7UCY+/R/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4140.namprd12.prod.outlook.com (2603:10b6:5:221::13)
 by IA1PR12MB6482.namprd12.prod.outlook.com (2603:10b6:208:3a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:55:25 +0000
Received: from DM6PR12MB4140.namprd12.prod.outlook.com
 ([fe80::407:3929:7093:be20]) by DM6PR12MB4140.namprd12.prod.outlook.com
 ([fe80::407:3929:7093:be20%5]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:55:25 +0000
Message-ID: <c4f7d5cb-5b23-3384-722f-cc8c517cb123@nvidia.com>
Date:   Tue, 28 Jun 2022 15:55:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/4] kvm: Merge "atomic" and "write" in
 __gfn_to_pfn_memslot()
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-3-peterx@redhat.com>
 <c047c213-252b-4a0b-9720-070307962d23@nvidia.com>
 <Yrtar+i2X0YjmD/F@xz-m1.local>
 <02831f10-3077-8836-34d0-bb853516099f@nvidia.com>
 <YruFm8vJMPxVUJTO@xz-m1.local>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <YruFm8vJMPxVUJTO@xz-m1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0009.prod.exchangelabs.com (2603:10b6:a02:80::22)
 To DM6PR12MB4140.namprd12.prod.outlook.com (2603:10b6:5:221::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86a27550-5502-43ab-83e1-08da595949fd
X-MS-TrafficTypeDiagnostic: IA1PR12MB6482:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YgOiQNTd1k/icPVWhlcbz/59owf696teeCBQv0nwiAprh6qbJY27X8gIhiekY9SWYNhhzUb4EzSWNOU2zo5dNL5YCD0hwPnc/8l6kv1ejQlagv2NCPUggFJPzXVQPOm3TSB/N7TwN9RBfX/fjzvqJvj5wGohqyZX0rq5oC8DN+XcVF5Xs4eayN2ZzyKIwLFlbzch1OIVSXt4/17e+Kbbf+oY75Eeyn4TGuiFeJAxaOAfCovae2wHCZu3BvwdaKx8qqA/akLq8Q7rk8uJBRJeevLq3ph2/rixI8DMh1wwXk2GdkBZnWhxUcIs5TrmV95E4sfHnYFpa52+47fp3WT4su/XXfmw4wmW0EKMDIeGiDqUKNoMgvUF9u8On7kzf6KfXWsYD98taG2Njmxr3uCaobQcwH4+Qc8NZ7X7kj1UWh4pAIqdFvEYXWIHCsLJ6E7mEJFjd9OTMzTUQxuR0wiSw4OCzO3qtc2aRXF5e9dHqwJ0BwKRPkF7v9DcW9LYA9mM84mAoSjE7VIBmKWa35+TU1RQ1D8y9ewhsLDKJ9FGOLt0OksxFFI+Wu2+ekMqZZ/0oRmTqiBEXfNmX24xDfPBma/mnXUgvArx598+IyIxFbr+pyKnAowES3UkuaPhk9EbNKEPvKAopXMlDTCozfQgzE69Xl9cQSlq3p1ZKroQcbuINGQaO5Z+3kjoyo+8WX04hsJXOS6PlbLDjdh5QVO1o50kZjOtGkECO+kvnC1KEFloO3CoyijrUPiL8GduVwKYCHaDT+fL/Sko/nea0xEmsqhPIvJOAzHyCiuMXRd1+hai4WB/ymqm9obbRe5RdZDw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4140.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(5660300002)(4744005)(66946007)(316002)(186003)(8676002)(31696002)(66556008)(66476007)(6916009)(4326008)(86362001)(8936002)(38100700002)(36756003)(53546011)(6506007)(6486002)(41300700001)(6512007)(54906003)(31686004)(7416002)(2616005)(6666004)(2906002)(26005)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OU52b2xGUmFFU1dxS3pIQ0s1VGRmL3A0L3ZnOFluTjBraWo5ZGZDVUJjRUU2?=
 =?utf-8?B?aGVibWwzaWJxbUFsV0Y3czhrNyswOU04VGdncy9pMEdhRGErYlZ4YlJYR1h6?=
 =?utf-8?B?bi90am1DZ0F3a21KWTAra0IwRW43ekxzdDJwSzRWUXIvbys2bi9wdmk1UnVI?=
 =?utf-8?B?UnVXSm8wc0Q4UlFiT2JTaXhBWHdMUmtGMXc3dWJTMWE2dmRqRnp3L3l5RnBG?=
 =?utf-8?B?WnJnNFFNL05vY3VqTmRPYS92L3ZGdWp1UUdhck94WUUyZ0JTbHphYXl6aDl4?=
 =?utf-8?B?K3pNMDVCNkJOYTJ2TCtueEFrV2N6V2U3NXVyZmlUQWIxMHhiVUg2bHpXdGE3?=
 =?utf-8?B?N1V0czQwRjJCalBnWDJlRW1YL2t6MTJneC9HSlkyRTFLUXlBajhaUm1uL1FD?=
 =?utf-8?B?OC9NcHVIQnBCQUtab3k5MWZBQWcrNkQ5bVJOdGNySlJzamVUelpOQ1BVZFpF?=
 =?utf-8?B?RFMvbXhhN2V6cUU2bnRuQUUyMzZpWFpOSmNrWjJxSE9BOXJ0QkZLek1lcGl2?=
 =?utf-8?B?OGZGYVpCclNSaGNCOWFrTDl0elFqRU9VNDVzK2NKTlMzMkRSWUk3a3dPUFZY?=
 =?utf-8?B?QmN1WEZqY2hjYyt6dmZrclZENmgyS1ZPMWhtQWJKN2k0Y1MrKzlqaTQ0TS91?=
 =?utf-8?B?QUdEYVZxSGtXMkhVbUJhVnNkOTF0MUlZUjZTeURUV3JqQ1lyL2J1eDYvVHNF?=
 =?utf-8?B?SGdaVU0yT2h4ZFdZQ0MwSGNNWWRiZ1dtbnVoVUNWYU1JdFM4d0kxYjRRZXNx?=
 =?utf-8?B?aDVDYXZtd2U4ZDZsZTJIRDlvdjFLRTlqZ0V0b3FDZFBYSXl4YVhYSXFPZUZO?=
 =?utf-8?B?TjUzUFFTRG1iV1gybGdDUnVNeHd1Wk8wTGFWaXFPcG1MT3ZiRDZiRHlrSVdv?=
 =?utf-8?B?dGpCRDUyR2sxVUlpMGFrMDV2NXpXWVFYT3VWQUR2NzUwemVoV0kyem1HMmV3?=
 =?utf-8?B?SjJtZWJkbnVFVm1PaHFFTjhvdHNnREk4WE9Tc2ZyNldtaTQxbmR1QkJLb0xP?=
 =?utf-8?B?SUZXcHpWN2FWYUxoVmg2cVJ4dW9SVEhNbmpxSUhIU1YwbGo4djFzUGpuWWk3?=
 =?utf-8?B?QWtYaXBnTG1JN2pxVVR6ZnZFdVRGUnY1bVBYa1JPWGdhTmx0OFhROXhLeG5m?=
 =?utf-8?B?OVZZTW5sR1dzL21xSnRGM0FmYUQ1dHM2RXphaW13R0M3V1JxUDl0ZHppb2h3?=
 =?utf-8?B?ZzRPempxcEc0dTM2SjUwVEx0U1RIYnhqQWpmbUgxcUpMWG4rWFZaYUU5YmFr?=
 =?utf-8?B?b1ZpdTlaTmtSNWJCWWtpNmpjN01pVEJUb3lObFkycGpRc1U1M0dpWFdNMlEz?=
 =?utf-8?B?ek16RTJ0OUNJczFkdjAxWTdZVFJ0bzV5OFJpWVR3d0wvUFQ5cmZnSDdEU01h?=
 =?utf-8?B?dDBQZllCbFZMWlVqY3RNUHh1dUlTM211NVo0Q2JaVkVlUk9LOGdwZEgveTdG?=
 =?utf-8?B?bU9nMnExeU9aWUVST21JaFF0UjJ6NTNqY1BYajRPcEdpY3MvNGVPYkVqQzJM?=
 =?utf-8?B?NkJwQlFiRlRtMG1LTmt3d2hZVmtWYW5hZmdQYzhsOGxHVFl5bmMrdUtOTm9a?=
 =?utf-8?B?OGtOZytYN0FnOWtabi95aGNkNHFjRmNCZ2U0Q3lpdkNFamF3NGl0TmpyRTF3?=
 =?utf-8?B?Z2NZRkQzUnZmYlVMcncxQUEyVTJvYVptM0toMDFHTDBOd2x1djJHZ3FRUTRl?=
 =?utf-8?B?VWJZNTIrZkxYZkMyTm5qWkh4dTI1YTZSOUh6L2puODJNTzZxVDg4TlhoUUxs?=
 =?utf-8?B?eitML1I1QWhOSjlWWXNUdVZQS2xsdUZUcEJBSk9BMzFoRUtYNGNNK3VRalJ4?=
 =?utf-8?B?M0tZSjlpS0xmSU1kakpxcndOYXVMWE5UREpjbFQ0MUptOCtMbXc4NGtFVm01?=
 =?utf-8?B?RlZodllJSW4yS0RqazhGRk9Yc2xtcTJacWZmbERjYml5RXNPN09oaTJuc1hY?=
 =?utf-8?B?cjRYNGlGc3k3Q1BQMkZrRFNpYUpvMzJnUG1PWks0cmc3eHgrS1BJSWFtUStB?=
 =?utf-8?B?R1BEcFM2TU93Tzc5OWVnaXM2MHpERmR3RjRTR1dZcDJPcEJObjUzTk5PYjdE?=
 =?utf-8?B?bGU2VVhMQW55YWN3ZFhERnVkOU94blE4ZVAyTHpXUlhLcTBTcXArQTVJczVE?=
 =?utf-8?Q?Tw5gC7MRvRRTHOAD3M/68JF4B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a27550-5502-43ab-83e1-08da595949fd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4140.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:55:25.5908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LJvQtlWCsJlW+OJBtlCnw/6Lb1DXgKfa3nVT5Ix1jt3N5i36ODQMzhsku/WMgKJoE/SK2WqkaExVsbOdUR51Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6482
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/28/22 15:50, Peter Xu wrote:
> And if you see the patch I actually did something similar (in kvm_host.h):
> 
>   /* gfn_to_pfn (gtp) flags */
>   ...
> 
> I'd still go for GTP, but let me know if you think any of the above is
> better, I can switch.
> 

Yeah, I'll leave that call up to you. I don't have anything better. :)

thanks,
-- 
John Hubbard
NVIDIA
