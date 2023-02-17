Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9572569A64E
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 08:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBQH47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 02:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBQH46 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 02:56:58 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F2C2449A;
        Thu, 16 Feb 2023 23:56:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRVKCPbEcK8OB3Ki147T/vaLdqv68gXh7Z3AiZbJ/wT+5hpa0RP3rjgWvahkvOoV2uUdl4vUG3VU2rq3OKhfTPh9DITAm7ODct7+an879s2OcEo8rGrNcTWPr92DkVLSTivtilVVfCfX0d36e60j+Fu0HUUnpI8EEUKFugsv0exIhm3ln16heMS/DpZvIs60qdTmCZ/TnlTa4uUDvSzTSvstEhX62/w8wjV7kU+K8/v07dtyem0sqHOGWfDtcKQgOxGXFqWoG9QB7GSudV3D2AFgR3PyL7R02+L7tpvht3/X02O1u8WqeYZCF3uRBkRi01QEMSZfHgU6oBR9YGDq2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=811lBCcdevgjOu4j2IPeJEeu1XmOcnXZ8W/a8Me9qrg=;
 b=aj0lFTYTRIFYDU68et/XBF2JnPLuE3wbCQxI87HxlJzBInkCdOg3tZumYyw8HqWDkEDZ8XwmiYeqlpgFTL9qRAgM2BzfHd6QsNlnP6WNGByszxjSLKiUJmGbB6T2MCTz5zCOpK6jdTZvcfTNZW7ux953DB2nysK9VYKfAKrrtiHPOiSDW+a2JqYskiF0tas277jvLZZ2tvZgWqG2d+xM7IzdPKA0zLGxCViMFl0tyWdr6nfViR17wfKL6JDFKRTPPqBlk4vRNPg0RLgU4jw/K1EzzLDH0V+0G3wwA70dDUnArLXDm65DMWC7uiPupKlXEJeXBGgG/9L4dE+bt56zLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=811lBCcdevgjOu4j2IPeJEeu1XmOcnXZ8W/a8Me9qrg=;
 b=Mv9Zb2qxF+7R3Kv6suZr8N758vWm8RIhTgRV/FZkfu1Q0K3AO8kuo8iU3tjWH9t/lsp2MgIVjYJnhxn67YXYhmfVch4L7KHL8JyupbuXuju5IQnCs7NQjIP61S7Ob9VD7YXRkTlSSqENQPcM/XhPaQf66cv9hPK0X7QTrfuSbtI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by MW6PR12MB8706.namprd12.prod.outlook.com (2603:10b6:303:249::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Fri, 17 Feb
 2023 07:56:54 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::c110:892:21d6:9a5f]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::c110:892:21d6:9a5f%3]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 07:56:54 +0000
Message-ID: <f5dad9e6-9824-ede1-e208-0e14c163a4f6@amd.com>
Date:   Fri, 17 Feb 2023 13:26:08 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v2 07/11] KVM: x86: add a delayed hardware NMI injection
 interface
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-8-mlevitsk@redhat.com> <Y9mWFlGdzoa8ZDW7@google.com>
 <a59505b3-5405-0409-bbf1-34466932c2c1@amd.com> <Y+PIdJZtCsGH2Sw3@google.com>
 <2b5994e2-15ba-dd57-285c-fb33827a5275@amd.com> <Y+1f/En6rvqoe6st@google.com>
 <Y+13N/Ky19VK0rzq@google.com>
Content-Language: en-US
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <Y+13N/Ky19VK0rzq@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0205.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::12) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|MW6PR12MB8706:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f8ecb4a-d0be-44ef-cde8-08db10bc8906
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U0rnLRo3akWM3ziUe+AlzJp3c7ekMVR6fGU0YSa4UlhG0J9zMG8iJxK0+2sxvZJ16ageeJZTvfg4DDoaSIYnem7nauZioWvjkfE9d30kI16utx5/eGPs3ii32FiN2fDtRLQRVwjHh+VsZjfrht00+E+j8xbMiPY3OWlMtcAoUumQi6i5NH2xSC8l1Gr4xQGBaQP6aiNa4Wsb7Wm2sDj9OszyN/cHsvHpsXQ/Gf3wdmlnJjB9W7jRfjyyjuzFQJU8BRxPQcfA3TFoohm/yCbPRBhL5zNHusAvkSy/LbMWb71TJBBYjDoZKobsrNvwOjXWSM8udkTR/vsy8uqkHVB53B+AX6bIRoteqlXHkh5zuh2pFjhUUmJDLGgMxvzdu4M/pUk0Ihjlj3LKf6NHjHQooppfMIvJbwVSunvxeVx2uHX1dF/QB1nvJLcyY/PDcIRymf7RFwS4kwgTFsSo9ZcLqFGw2apY6yg82GYBukvHwoZI3revhKa/PirBalR2LzP+seUfVQLAcHWQRff4+IDNtVzWETrNsjzzl71VrfvW8jzjJw4170RxQej7IF+zQdVgtKqDW+2BmZlKetBnaC8y2KcSHOkttjVwnIwpORPXNAPK3w92lGCpu5XtS9ANlo6rtuPUO7eo/PhfyFPku9ensfAprdO7pE4ks2YPgPGVmaN3JDZzw0be7Q2K5Zun11VWViMJ74xNqSsoTGLjvXCRmsYkKSx+7rTmFppvD4+VCF8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199018)(31696002)(38100700002)(86362001)(478600001)(6486002)(36756003)(6506007)(6512007)(186003)(6666004)(83380400001)(2616005)(53546011)(26005)(66556008)(44832011)(4326008)(6916009)(66946007)(2906002)(8676002)(66476007)(8936002)(7416002)(41300700001)(5660300002)(54906003)(316002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3U4K21rL09nKzZ6SHFPZDNQY293QmR1SVF2YW5zejJmdEt4bVFWYTZnZkNE?=
 =?utf-8?B?R3BtUHNKbnNxRUVQS2lKenRLb3ZjMVo3bDlXaGgxS2YxdXB3WEdiNzVSalYv?=
 =?utf-8?B?Uk8zWnNQY004SFBxMk0zN2pjMzFqamZXaEFGdU1qb2RyRE83ak1yc2o4bTJo?=
 =?utf-8?B?TUZROEY5Yjl3c3ZpcGo0MXA2MWxlTkE2eDlvL3g4Q2hUZVVFU2dvdTA0QUVU?=
 =?utf-8?B?N2svME5EVUdxY3M2YTlDVjZha0hKWVNrT2xSMEpNSWdQNU5iSzBOcXFjcWVV?=
 =?utf-8?B?Y0h6M1B2ZklObkNITE5wM3JwTWtLZjZMSlFkaU1ENlR6OGsrQ2IvUHl5RHUx?=
 =?utf-8?B?MXFEZmJZZVpPNDZtYTNGZXd0MDA4SXdLNWkrd25VZmMwTStSSzJLd1VQNHlZ?=
 =?utf-8?B?T0NrVjlBTFdpSkJOcDFmU3N5SUk1S1IwSk1YeDh0VjRXMzltK2tNSmhpaEht?=
 =?utf-8?B?MHczaEp6NjdBb05VUE5lRzA0Y3VIdEZCZitlNGFZM3lBVHFodDhFeGhnVWxu?=
 =?utf-8?B?cXFJMHZkS3dLcXFhUGVKVi9NbG5hYmFkdUdqOGRTbHFwTmhjek5naG1ycmZ0?=
 =?utf-8?B?eEJYQklXOWJjUU92STlKVThQTnRZdHJTTHN2aUh4WGo3RXVkQmI2TlhFSHgv?=
 =?utf-8?B?WmJjWFRUZDBPTVpmK2ZMNUJ4MXJmVW1FVzhmMVdMaFJtSXlBQ3VHUlpYNjh0?=
 =?utf-8?B?S2htajhXelNRNWRJRnRERjQ4M3oxVTFRMEloWkV5WDJUSHpNOHUyTUdqWjBp?=
 =?utf-8?B?ZmdSSHZzQm1Xc0xYd1ZiUUlybUlLWGhhOVBncHlxQWVnTGRiUWxEUFZzRGZY?=
 =?utf-8?B?NWp3bEJxS2RySVI1RlVIcDdyTkRCMW45cGNvclRzY1RPTitMN3lPVm13MFFU?=
 =?utf-8?B?VHdYN3VwMTdPTXVaeTlWcC8xaVF4WmtXKzcwWDg1MDBhZzNJOWxTU25DMTB5?=
 =?utf-8?B?Q1ZMNWxPU3NTVmQ1cnd1dEg3eUZ6N3IrT3BKbUJEMng2Q3pmb2V4UnVDbUdM?=
 =?utf-8?B?NXhlOXlKOFJ4Nk9pUEpGbGlNUURaN0l5MVZscUdHaHRaWkJJZkl2T0pzNkw4?=
 =?utf-8?B?bzFRNk1rREVqdnNkdzNXYnJ1R0pVL1BaOFVwT2hYalgvY0pySzh6bDVYYUps?=
 =?utf-8?B?TUJQdDRCYjczaktRREpTYUhldVRpU0RBYjZxbmJDZ29CT056YW1GOUoyQjVP?=
 =?utf-8?B?NGJiYSt6bG5VLzltSjE0cFlieEVLWEhFdXlORWhlNXVNZTRWdXVvdEREa25R?=
 =?utf-8?B?MnlMYnZhVzdOYU9wRHQ1cS9YaGkxS1BmbFNSd05mZUhVOUhmemV4SHFCaldt?=
 =?utf-8?B?WHlPNEQ3bS9TcXBWeWhFVUh2VWQ1ZDJLcnA4Si9JV3NocUU2NTFMOEVMWFFH?=
 =?utf-8?B?c3VoSDFRM2xTazB4SGZKN0p6ampkZ2w0QXdGU0MrYmJoVmxlS1lKWG1Ba3Fn?=
 =?utf-8?B?bHFLczJCaTk5SDRvU0lFWEl5VlU5U3B6Z1VtQlNJVUhYYTVadkc4cHdsbVVG?=
 =?utf-8?B?b21CUFNqMDhyU2c5c2xmUHVjdTV3dEdhU3piUWJ5MHR0dVFkdVpsalJNT1hH?=
 =?utf-8?B?TEpjMXIzMXQrTjE2eVhrN2NwVUx0LyttZkc0QjVMRzNlZU1qUldTNnRnZmw2?=
 =?utf-8?B?MzkzNWtDbEx3SEcxZHlzeVZMSnNuZ0NRaldxTHRIRmJMZnBwRisrVUlDem5Y?=
 =?utf-8?B?VnZFcFpZaFJJTzM0T0twbzFkZlBlY0hrZE5NWHBtWlovWm55QzFIUGtnQ3ox?=
 =?utf-8?B?c2JUS2tTc1BiYzBKUEhGY202blYvZXZaSy9jWFIzVHh3aTk0WXNyckk2Yy93?=
 =?utf-8?B?UVEyMmg2eFF6UUtjM2RSYnpNMFM4a0xWTlNJTkxCVWxka3JKRDRKM1BtSkJC?=
 =?utf-8?B?KzVPeDgyZVVpVGlldnBtRDJvZGJ2TXBoMHYwTmtvcFZ6TFpJS21TeVk1UDdx?=
 =?utf-8?B?Nm5IZmRJN0xrVFE4Tmg1VVpGVGpzMjVnUlZrQVBobXZseFJjWVJNMVJSOHJE?=
 =?utf-8?B?VmkvV0FCOXhicjUvaUVJU0UxQ2E4S0hiNk5wbHp5aDhlUFJ5WVNUS2g1d1E2?=
 =?utf-8?B?cE9lZjhuRkUxL3ZBeGhSMmExS2IwWmdYc3BkclBtQm5sRU9zY0ZCMGpIQUJC?=
 =?utf-8?Q?NP/v3YPH/XL3Naip7fLX7C1CJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f8ecb4a-d0be-44ef-cde8-08db10bc8906
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 07:56:54.3453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KMsSlNMibtzZiwwZjcVt/cIXtbHVOaJ/SO1Yqk8Q2pjcumKW6IGUfW/FuFUZ0yOnnXg6LQtLl0MxE2oc1FpzRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8706
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/16/2023 5:52 AM, Sean Christopherson wrote:
> On Wed, Feb 15, 2023, Sean Christopherson wrote:
>> On Tue, Feb 14, 2023, Santosh Shukla wrote:
>>> "
>>> V_NMI_MASK: Indicates whether virtual NMIs are masked. The processor will set V_NMI_MASK
>>> once it takes the virtual NMI. V_NMI_MASK is cleared when the guest successfully completes an
>>> IRET instruction or #VMEXIT occurs while delivering the virtual NMI
>>> "
>>>
>>> In my initial implementation I had changed V_NMI_MASK for the SMM scenario [1],
>>> This is also not required as HW will save the V_NMI/V_NMI_MASK on 
>>> SMM entry and restore them on RSM.
>>>
>>> That said the svm_{get,set}_nmi_mask will look something like:
> 
> ...
> 
>>>  static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
>>>  {
>>>         struct vcpu_svm *svm = to_svm(vcpu);
>>>
>>> +       if (is_vnmi_enabled(svm))
>>> +               return;
>>> +
>>>         if (masked) {
>>>                 svm->nmi_masked = true;
>>>                 svm_set_iret_intercept(svm);
>>>
>>> is there any inputs on above approach?
>>
>> What happens if software clears the "NMIs are blocked" flag?  If KVM can't clear
>> the flag, then we've got problems.  E.g. if KVM emulates IRET or SMI+RSM.  And I
>> I believe there are use cases that use KVM to snapshot and reload vCPU state,
>> e.g. record+replay?, in which case KVM_SET_VCPU_EVENTS needs to be able to adjust
>> NMI blocking too.
> 
> Actually, what am I thinking.  Any type of state save/restore will need to stuff
> NMI blocking.  E.g. live migration of a VM that is handling an NMI (V_NMI_MASK=1)
> _and_ has a pending NMI (V_NMI=1) absolutely needs to set V_NMI_MASK=1 on the dest,
> otherwise the pending NMI will get serviced when the guest expects NMIs to be blocked.

Sure, Make sense. Will include V_NMI_BLOCKING_MASK set/clear in svm_set_nmi_mask() in v3
and will soon share patches for review.

Thanks.
