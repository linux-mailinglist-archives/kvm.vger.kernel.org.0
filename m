Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDAF46B6DF9
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 04:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjCMDaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 23:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjCMDaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 23:30:17 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2063.outbound.protection.outlook.com [40.107.100.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48289311FD;
        Sun, 12 Mar 2023 20:30:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHjnl9VvQjYAqxlF83MdgWowMN7atFB8G0NXe7pYQUXwSePZgSVcOw213vOB3dCvOWtb1mAeFIuhwNuOjG2nMKY+gShex60MGfQ0NOCVKFuK7oJdK2uyPdp9768cvkPyBSJb3ted9qmLYpkW0OqUf7VyfrM2zgcUuVCfBkPi+dHAa+f2aSFZAS6GNHSS6fnO8+kzIVooaFotACuFTycse48hIbl/RlQIgx1V+V6b+e9V7ie8i82kJTxDnROSkN+u4yETAEwm44oFP2k7wcQmJwjJ2AH2UV5stemxfgp8yECetzIW8S/mlihL/h3JbQMund9UAKr0agbgphPvDmjhXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQg3mXx0K0elpgjyZjok2suoMatqS61fv619rNMzg9M=;
 b=cAuSM9AdIdMyh62CJ8LZLlDd/o6JoIMhVyzNGCZDFv35QsEMuNbxL0L6sZK18od+oAkkrSw/V9V1XMgMUEFbH5XH392pjQ08Rlq+BU3Fx6qualymXczscPe6DAq7V39PhYmp1e+o3O3+tECMcAR92db5epcouWxSZefMNGAJskPcR8MDqv8m1iEws1pYHUnuDvubiwGtGTULD9dEljIKLMrMYnjvZkB9mnAxca8exNjPU7Fp3n151g820wa+xDBk1twl7VQTNEZiBDqKVoRlAX9hC4JOP8CVdznSSX8wX9M8Z0mUS0s4+aLkY0tehatE6bgYzoypyHUSZvQCY8Yn3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQg3mXx0K0elpgjyZjok2suoMatqS61fv619rNMzg9M=;
 b=CWR0jG2FF6a1XMWznVZi7BlbZd9gHIqI+JhVARSr9jGse53CBNu2NiO+md/iGB50/lWio/86E9AFfoU2x+el4jAfirADpfD8I4jcuKsAFW4+GKDK/+Ke7JJQVQYp/hE5RfsGjwEBoU7Abz9/gJDyy1rWvJqV4Rlcecqd73H2I2I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by DM4PR12MB5391.namprd12.prod.outlook.com (2603:10b6:5:39a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 03:30:06 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::d8e6:76b5:2c23:1247]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::d8e6:76b5:2c23:1247%4]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 03:30:06 +0000
Message-ID: <e3f3864c-a6d6-6d6e-31d1-d3dff4a1beca@amd.com>
Date:   Mon, 13 Mar 2023 08:59:49 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [RFC PATCH kernel 1/2] perf/x86/amd: Add
 amd_prevent_hostibs_window() to set per-cpu ibs_flags
To:     Manali Shukla <manali.shukla@amd.com>, peterz@infradead.org
Cc:     mingo@redhat.com, acme@kernel.org, jolsa@kernel.org,
        namhyung@kernel.org, tglx@linutronix.de, bp@alien8.de,
        dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, jpoimboe@kernel.org,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        sandipan.das@amd.com, jmattson@google.com, thomas.lendacky@amd.com,
        nikunj@amd.com, eranian@google.com, irogers@google.com,
        kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ravi Bangoria <ravi.bangoria@amd.com>
References: <20230206060545.628502-1-manali.shukla@amd.com>
 <20230206060545.628502-2-manali.shukla@amd.com>
Content-Language: en-US
From:   Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <20230206060545.628502-2-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0098.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::11) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|DM4PR12MB5391:EE_
X-MS-Office365-Filtering-Correlation-Id: 5459b16e-fa5a-43b7-c354-08db23733d52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g9GpQunLP0XM2I8MzcCiWK6bZaXReSXNnGZXGyiljbT0quAm22MDf9/r+DeCkVqHlAT1Ck7JCClODp2/XlaZiaKTBPndN6YTn48wWWALYlHCR7eyqgldqyAXwrJML61Td89uYR0DNJLNsxtKGAZxU2Zd9hP2KgHwUDd6tyPi2cZLbK4sVVQUA9M3BEenJbw5hsvt+xae63Hla+QPGGDm9oPrPxtkRVOSt1w+VIfaZUgIDCOsUGj0hYoMA5uEDdS8FQjh2VWlzbRtWdH03cQvN4kEXSe9hHSDRowlDYqHdfx5jHwXSGHxvljYYfFJgq6nJnaG12udId68fTVYAbudvLbrAeE4cirt810AgOmzKgZCfXcXtBSVTvfUDkJLo+v1AxRhR6YPyjqLQA2cwa+ndxt3P6lypO5t2ErJRpuTdM35KmadOoo1kpoi4lI42dK07cFeksp6TvFapqvBuqv1Wu2V1leyb/wn77bV99tFxxprfnooIHHDHdxImdkB+c5tdaWtqu5YWac7SPGnuOuMbcKuJbxJgZCYz2T1PUvlJ+OhesynE1dIn9PiDkqK58hBALFDTeVCy8H1Si6uM5WEt+96zTu/pdHBNKpu4KlZUwxka1ikLxe5mT6qIUNsg9cZSV8f1T6SvRbGjEnt+H14OTSU1zKRuW2iQNGnutJZ+fT4m1w7H/0LSRi4pDa7Gi2iaMjdiw+dlXQ2x++7vss83QKiCDpvqP28+0LQZNhMlWI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(451199018)(38100700002)(2906002)(31686004)(2616005)(478600001)(316002)(6506007)(6666004)(6512007)(86362001)(31696002)(36756003)(41300700001)(66556008)(66946007)(4326008)(66476007)(8676002)(8936002)(186003)(26005)(53546011)(6486002)(7416002)(5660300002)(83380400001)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dTd3aG83YTlFWVpDZDdnUm5tOFhhOVNzY0w4eDVvZXVoVTVscC9NSjJNR1Uz?=
 =?utf-8?B?VXJNdG9ZS0Y4U0JjV3NrSlplT3dNRitmV0xGcUU1YitnbGNXTkVQOVB6ZWdu?=
 =?utf-8?B?QVhRb2Jmd1AzVjdTYXlCY0FlK1g2TXJhTEFCVkNXaTJWVU96Y3BlWUlsVkli?=
 =?utf-8?B?UjJ6UnB4MVlKeTYrYlNhOThTSG5vU2hHcnRIRld6OFJzSENaR1hoMGZyVXor?=
 =?utf-8?B?NE5keWpqT2VCR0VDQlVmcmNVTjVLdTh3RHg1ZXFucHlCM3U4RkRQQlg2cVQ0?=
 =?utf-8?B?WHg3ZVBwV0VFTGFmbWU2OXdzbmF6NzJxTldRSnJQUzQ2V1VpUm9zSW53eWMz?=
 =?utf-8?B?aWUyd0d5ekR3Nk92ZXVJM1k2MW1FUGw1M20xU3ptMFpHV0FraVNORE5jNGlQ?=
 =?utf-8?B?R1VNbmlOSmp4elJFaTJDS2tQTFFhaHNKMDNGNU1tTDczUE9XM0wxQzRXeUwz?=
 =?utf-8?B?MWQweFM4QlljbFZXRHQxVW9QelNhUUwrcXI5NFVpbWVhbDNUSlZlTXNVd0Mr?=
 =?utf-8?B?emVneGttcDFEOWYwOG1OVXA1RTNXRWtHajhhNFlSbmpaZU1ZWDlHRkU4Zzkr?=
 =?utf-8?B?b3YwbXQ2c0tIN1N6N3g4YzJOajNZVFlrV3MyTyt6L3EzY3NZbXJqWVF5TVNs?=
 =?utf-8?B?blNwYWVZcndndW1yWjJZWW1BWE1sekkvUmF0NXdKb2lBeHhLNFFDLzF3ZXpY?=
 =?utf-8?B?NENyWWlQNEk0OXdoWndYeEpJWUZiby9McG5md1l0L2xBVitpeHFmQ043YkYv?=
 =?utf-8?B?ckpaQ051WlF1akdTV09JUWIzVG95U2pNWDFSVGl6VDludWtiU1RjUlQxQ2pU?=
 =?utf-8?B?M1hFSlJwWGpWejdBUmh0N0l2NWFvUklDQmE1WWhMQlZiNDdJT2l6MDQ2Y3g1?=
 =?utf-8?B?RVpnSXN1TmhFWlJxQlVXOVR5SlV4VDhnUmkwN0xpeFJEbFJ1a0RhbEM0aFdm?=
 =?utf-8?B?Vi9CTlJMQVRsaE4vYnd6SWliTUtwbjZnTHZDdUs5Tm96d2pjWW5xKys5eGZZ?=
 =?utf-8?B?bmVHbXVFZEw2bGxsV2JibkpoZFNiNC9KUUgyRXJrbitmQ2lCRE5LT0M4ZEN0?=
 =?utf-8?B?NG4wWlVQeWNLNDBQOUZSZGpyOUlhQnlKenJuSGh3MFRmT0w1YlhIWHJFbTF4?=
 =?utf-8?B?VWRmSGVFdUNxNk80YU5ZSDhGWE5TZFB5UkV4U0Jjd05EQ3ZEN2FyeFhqeHhm?=
 =?utf-8?B?TlloQXdMYmE2TGRNaWhQbFFyNEYxNE53cDYvcjNCdkFzQUdIM3d0OUJKbjB5?=
 =?utf-8?B?V3pqUUtRd0JQV3VBVHRWSDdrYmVjeEFPeTRDM1ZUZktaYmcxYnpuNmQzR205?=
 =?utf-8?B?T1M1U2pqaU5BRGU4SGQreGM2NS9uUHZtSXB4ZnUvNkpudmYrekM0QStSRmRr?=
 =?utf-8?B?UzVBOHRuTHpZNSs1ZGEvYkZnSk44NEpXRFcwSHQvL1JMNUNDRU56RGtsVy9j?=
 =?utf-8?B?dmVYdmFzcXpjOUpqOW9MRm8zUmpEbitiLzI2VWJQd2FiRVJBYkN6ZlM0L0Jj?=
 =?utf-8?B?OS9wQWFBSjcvLzd6a2RsTHVnMWdkWWQ5VnlkNzIyS2pnd1AvSXVxcnBvVXU0?=
 =?utf-8?B?WE5tWElXVHhpcE9EV2xWTUJMajloWjhJbTVHSEFpbzYxNkJ5c05tQW9ISHJi?=
 =?utf-8?B?MjZRbDRRRGc0azM5VXQyVnQ1MGRvd2pRQ1NnQVZienNKMjA3ZFFIZi9CV3NN?=
 =?utf-8?B?NTNJZzNlejBoYmZmTTNjSU41VnRycW1HT0hvWlBGVyswNDNGSW9UbmhtN1lt?=
 =?utf-8?B?RGhJbEwvQmF0U0F5eitJcFh0ZWdkTlY3ejEyWmM1cGtpUE9TVXBpeXJJcHRj?=
 =?utf-8?B?RzgyMGIvK09Kamo3dytCOVdlaldxeklyVk9lVGhyTi9nbjkzZWlKTENIV3NZ?=
 =?utf-8?B?dmpMSjNmbTdmOEhUTmtMdGNpVjg5alBsOGFqLzZ6MkR6VUtlaHVjeFRadTh5?=
 =?utf-8?B?RUtBNGpTQmprSjFnTnFKaW0rWnpRVjdkSWdONFFDU0U0VFdSQTNDVUY0bWE5?=
 =?utf-8?B?TGR3eGdOQ3RHUnJJWVZBRWVXT1F6bUs3REwrY2p3ZmxBTzN2enRNSDlVTmhr?=
 =?utf-8?B?c0p4RjczSU9IbUxGQUU4VW5YSlhRamlrSzRlcFFkTjBlT25uaVVmaGlQditZ?=
 =?utf-8?Q?ahodjiO5eJ56NLk3UzSrtQrLU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5459b16e-fa5a-43b7-c354-08db23733d52
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 03:30:06.4788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TQKI087qFPriCHE1t7iEp0yMZnfIiP7njm2qJt/uoQfJbnADOl7nffkm/x2SL92sog/KZGSxEpZfREVaIDG6SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5391
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06-Feb-23 11:35 AM, Manali Shukla wrote:
> Add a function to set per-cpu ibs_flags based on an active or inactive
> PreventHostIBS window.
> 
> MSR_AMD64_IBSFETCHCTL[IbsFetchEn] and MSR_AMD64_IBSOPCTL[IbsOpEn] bits
> need to be cleared for PreventHostIBS feature to be enabled before VMRUN
> is executed.
> 
> ENABLE bit and VALID bit for MSR_AMD64_IBSFETCHCTL are contained in the
> same MSR and same is the case with MSR_AMD64_IBSOPCTL.
> 
> Consider the following scenario:
> - The IBS MSR which has ENABLE bit set and VALID bit clear is read.
> - During the process of clearing the ENABLE bit and writing the IBS MSR
>   to disable IBS, an IBS event can occur that sets the VALID bit.
> - The write operation on IBS MSR can clear the newly set VALID bit.
> - Since this situation is occurring in the CLGI/STGI window
>   (PreventHostIBS window), the actual NMI is not taken.
> - Once VMRUN is issued, it will exit with VMEXIT_NMI. As soon as STGI is
>   executed, the pending NMI will trigger.
> - The IBS NMI handler checks for the VALID bit to determine if the NMI
>   is generated because of IBS.
> - Since VALID bit is now clear, it doesn't recognize that an IBS event
>   is occurred. Due to this reason, the dazed and confused unknown NMI
>   messages are generated.
> 
> amd_prevent_hostibs_window() is added to avoid these messages when
> PreventHostIBS window is active and PreventHostIBS feature is enabled
> for the guest.
> 
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>

LGTM.

Reviewed-by: Ravi Bangoria <ravi.bangoria@amd.com>
