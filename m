Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9FC794498
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 22:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbjIFUeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 16:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjIFUeX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 16:34:23 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F381993;
        Wed,  6 Sep 2023 13:34:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evFcbjIXOuZXCanINDgFyNPCHZYs0qnFDmaEviEWbfXL+LkSYsbpJp/SX5mpJzyZ7++jogxAE81P1Ew3i8ds41J5CYQ4D08uK7bXe/5l07QyeTyOl3IIvCdrbQmIJon19nQkBf3KpzcHtT6FM+A5/pVGYztiC7vMhvMn9xY1kBUFYMr5b/dr0rPns5tEpkUzzMLadsWtML89YclYDyA/mYyac4IRJPArQ4+sIsajM0TEY4bpevExp8f6rwGi0A4o7beiDV0tBbfK9H3sK24vGURw+GqkjRo4YQ8lR9bG4KUN7zDUiIPFEwaII1GCnrCTXcYrdkQqygozsZ5A1kbE0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y4HUr6G3Q+CKvrx+4CPHkKFevP8SMd4uPvdOBPlEKF8=;
 b=esZlNdQWjwVXl0UajXA5i/HpKr68neAp5hTkEXxcwWWXLT02KWsgH1M4vEPY7PKLjsx7HMlnBdKEE2YAPDcA/PabdA8f5XSIh8alZsJJRnVOrd5l89Osf6rnakXa7fDEtmhT7FuSFlVd1NFwibK2bGc6cdtL2s+gXPhzDIhFVG6Qs0KUAwoOT/ibPcIgx2akZ87cBJgO8T7mrO4ITuwirPNHoEUpSOeZHq//PcDR3hOLlAHW+Gj+ejZEJ7W4L9c7rlwWVD0st0bu/ORRg36UW1GmTLuCX9eFKmuZ3d4DWz9VFt/R6WsLJ3PE34iq8fDwIeNvDZyweS0vMVx1WZbmdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4HUr6G3Q+CKvrx+4CPHkKFevP8SMd4uPvdOBPlEKF8=;
 b=Tvu9Gc1Wv6L9pDX9QSo3oJggJ6Y5Lyc4D9W6K/bFT5kZPl/At/OLN3JYIn9aCBowN7tiOuiRJDQ2du1/HELcIPaI35HZsPANKZA9olKdJj8ZbnWEd1XYQEDtw16Kv68fsdC6nIo1ua66owzBRNbgfg0D9V7OI30LwoiGqmmzfiU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MN0PR12MB5809.namprd12.prod.outlook.com (2603:10b6:208:375::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Wed, 6 Sep
 2023 20:34:16 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6745.030; Wed, 6 Sep 2023
 20:34:16 +0000
Message-ID: <126deeee-0a34-bfad-27d6-ff39c93c1e25@amd.com>
Date:   Wed, 6 Sep 2023 15:34:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH V2] KVM: SEV: Update SEV-ES shutdown intercepts with more
 metadata
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20230906151449.18312-1-pgonda@google.com>
 <68a44c6d-21c9-30c2-b0cf-66f02f9d2f4e@amd.com> <ZPjc/PoBLPNNLukt@google.com>
 <249694b0-2afd-f653-a443-124e510f4a4c@amd.com> <ZPjgaKoF9jVS/ATx@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZPjgaKoF9jVS/ATx@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS0PR17CA0016.namprd17.prod.outlook.com
 (2603:10b6:8:191::7) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|MN0PR12MB5809:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d9a5407-40e2-4aa8-51b2-08dbaf18a3d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s+ErwnA2ppUMP4g/brXnH/J6onBgiqNS9VqQg8yGupwAoQpttDjJ37grmc3yNQycyE9uj3hukUZOm5G44UQVSfGM33cKUFK4HNIZ44R512CvHz/59CMc5yI6w116H+orq3mlOOAl4gQq4y8J/l5g2NcRxQF31Pnxzk2aE4tLIEU7wwMvRX04TAnDIM94lEtFqrZ0dZNxIl/EAeDVe3JeBnuhAGDIE1GexI3Ke2NKLN4UFn8LqQRFrmtaxzdIbQjYU0zsXOvwZGklR4ivu2ISFlFFycOUl5tWvsB8GgwLW1plcngdQqXH8AcHu5u19/YhTLIYsIKUtk4xihG8hf4ivTw4lEKsmum8k4a0xlC7Gryl8sjsYBc2Cp8CVU+HEpImP7lyu2ydaotoKQofRRovuvOHLFnZfvbUNJngQzMXU2QIOF69c5Y+hGAr33ZDPU82GsQq7YK1dxfBnnUbwoVHW4n4i6qKVm7h4VMOQA2SwfHuzmeMlfCn7lhgjt6XaxUWBYDGQlMpZk8W8yJ5Dn4Ey+O+L5bcrucx6YWHrqeuGoNk+jjPg1uxfb6dS2gI+7FXB0arhBQ+vQEEauY7o0IcQIirTRtCJwkOzTIyif8EWPXP5NPNzT2xEGeu2TISTwSPP/ZtcSdnzBLsaaKpP9bvVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(136003)(39860400002)(396003)(1800799009)(186009)(451199024)(66899024)(2906002)(38100700002)(36756003)(86362001)(31696002)(5660300002)(4326008)(8936002)(8676002)(26005)(2616005)(66946007)(53546011)(41300700001)(54906003)(66476007)(66556008)(316002)(6916009)(6512007)(6486002)(6506007)(478600001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MStBb3h1cmVXUFhrT3BycFVFeTJPaFJWQmo3K0FuZUphcGxtVWtSRFZDWjV1?=
 =?utf-8?B?V2F0OThETHhwNXMvODNVcmxsWHJnaGRreDlkTnBJYTRUc1F4OEZ0ZHRWbkp4?=
 =?utf-8?B?U01MUnI1LzVtNnljdXZPZXNYNXdRblFYT0VkNGZuS04zY3d2RXNIVVBkUmVx?=
 =?utf-8?B?SHpCQzRBeU03aElybjlEOEdlbEF5c1BwalV2VGh0TFVaSm4wNUJHMnJYWjdx?=
 =?utf-8?B?dk0wME1SSDJrRng2Z0h2ODhWUHNTeXhZOGxjaXVLVzR2WFlCVnQyRkhLRXc1?=
 =?utf-8?B?QlEzOUVTa2VITEtoaGx4c3lCK3N0VmZtWU9HM05GMGExMGl4Um1OdnNyWHZC?=
 =?utf-8?B?eDgyVDQwclBBWTc1VWd1a3AvcU4zZU15eUhBQlcwdDRqN3ZmYUM2d0lLK1Ur?=
 =?utf-8?B?V3puMkp5L2poVmxCTWprNzBmcWJFSWxqRGZFRjhWL3VEQkwwRmNXaDJnMDdK?=
 =?utf-8?B?alhWcnAzenRnTGJvMFE4MjFaTXVTWHB0U01XZ3Q0QUg0blg3MERiWXBHbWg1?=
 =?utf-8?B?c1I4bEx6V3FvbWJMMHY2K0cxZjNabjBBUGJnV0M2K2o0NXNFRVFpU3orajVM?=
 =?utf-8?B?aGhQU0JLNllFakZoSnJoRFZLYXNOd0ZMZUxQbWpoOEFDcXJ2bG1UZWQ1azdX?=
 =?utf-8?B?blRaV3hpUU51T2c0YjNzQWVXblFweExFZDRDWllFSWpVekhQUHRJU0JpaGJM?=
 =?utf-8?B?am92YUIrU3d3UXlXVVVUNWQ3eU5pSHZIaXl1aU0wcTQza0tScUkwdHd4TS9v?=
 =?utf-8?B?MC8rbzJ6SlY0L1h3Z2tDcURKbzVHYnNzbUdWNUxiN244S2NGTC9BUE5ZVnNp?=
 =?utf-8?B?VmpXMVVJWGIrVURNRjM5ZHZ1dHJkZVVpSVMzMGh2MFVLWFg2STZoNE9XVGpL?=
 =?utf-8?B?dUhDZ1RUc1JubUFhbEVhUnBsUjhFYnVFTU1aQkpvVFpLZ0paaEFUNmJ5ajhJ?=
 =?utf-8?B?eGNMOVltaktpNlpseWZ5OUhsOXFUM2tPbU9EWW83L0ZzdUZoQ2c3SSt5eUhD?=
 =?utf-8?B?b1lnemtybHRXaGJrUnZ0Rk16WU0vdnkwYjFuc2Zqa2F5eWQ3dVczWFdsamtN?=
 =?utf-8?B?dVFkbWExSHFyOEpiWHprL3EvUGlnNW1tZlAvYStTUXhvQW43MXlNb1JlbE5F?=
 =?utf-8?B?VXpmM3QzWGRGNWJYNXlIc042ajBwVTVjbTBJRkRkUXdTWXVJNXg0WUx2eXpP?=
 =?utf-8?B?MkpoRW1pcnNzL1Z2RmtpaEpOaStaTmlTazN1bU9BSXA4UUEzMEp5MmNySUND?=
 =?utf-8?B?dStjdUNJK0ozNzR6em9GL0xhMjA1YnQycDRDZzhaUHJKckVxNEp0UGRyMVRh?=
 =?utf-8?B?UE9XZVp3T3lFNllVZGlEbTBBcVdMUks1TlR1cXo3RDVVV0l0aFlCOStrU1VM?=
 =?utf-8?B?d21QMDR4UnQ5RG1Rdi9IdnBtVFlDd1RiVGlDTHh0SStCaHJTblRDQkJHcEJi?=
 =?utf-8?B?OXZ1YjBsVFhEcDcyOEFDekNKTmM2MzZhMXlGYnVRMFJMazFqZWdsU0dqOERI?=
 =?utf-8?B?R2lweWd1UlJ1bW1mTTJGY2UwQVhySTlnN3JEWHY5ZFhDVHhqU3czTldVSHIz?=
 =?utf-8?B?YzlybW1ZRmdPY0Vna294YVlTSERvVmg4eDNwZTBsbkpSMU9tRStqM0dwcHJ1?=
 =?utf-8?B?ZVFSVWxmdi8yZ3hZNnkxZFZEek1TOWxYS2duZkxFalVSZGZOM0dIaUJHQ3ZM?=
 =?utf-8?B?Y3c5cWtGeHA0enc2VmdUU2JLRVRWL25QUlZDK2hMWjJJRFdZMXdVQkNXdXhV?=
 =?utf-8?B?U2ZPL3lNSWw4eVY2Mko3SXptSjhMZXpFRnVrRVlvdG9YT2dxaUZQMXY2cG1Z?=
 =?utf-8?B?cklVZ0JqWGdGZmgwUHI4REx6Q05aL3U0Tm1lT1lkY1ZpMUVJNlJBbTU2RGVl?=
 =?utf-8?B?enJ0UHNPNmVRQ3MwQkF2b1AwaHNsYUVFU1JBWVk0RDZoUUd5VnZEUVlSMnk3?=
 =?utf-8?B?bWE2MmkxNnJnUDlySW0wcC9tcTZvd1JFTkRSMnhMMkNBeS91TGpCM0llQUFz?=
 =?utf-8?B?RWU1K3R0MmpFbDVxQXA0cDREOUptZDZ0SHFuVVY3OU0wY0VQYTdSUXlpUkZx?=
 =?utf-8?B?YUhHTEI4MUxreEIzb3k1VG5PTjQ5MWhCSUl1RUpOOSs4a2s1RS8xSnNqT0Vq?=
 =?utf-8?Q?SRQ0Bw+7EYArBHSY9k10WVslq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d9a5407-40e2-4aa8-51b2-08dbaf18a3d5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2023 20:34:16.7347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HEC6aUZqxNM88WiCbirYCZ1nQOheq4tlMbF4VR5rwyuqIw5Ir3e8QnUF9Qso9kZ7rT40/X9GwDgVzZZW7G3H7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5809
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/6/23 15:26, Sean Christopherson wrote:
> On Wed, Sep 06, 2023, Tom Lendacky wrote:
>> On 9/6/23 15:11, Sean Christopherson wrote:
>>> On Wed, Sep 06, 2023, Tom Lendacky wrote:
>>>> On 9/6/23 10:14, Peter Gonda wrote:
>>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>>> index 956726d867aa..cecf6a528c9b 100644
>>>>> --- a/arch/x86/kvm/svm/svm.c
>>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>>> @@ -2131,12 +2131,14 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
>>>>>     	 * The VM save area has already been encrypted so it
>>>>>     	 * cannot be reinitialized - just terminate.
>>>>>     	 */
>>>>> -	if (sev_es_guest(vcpu->kvm))
>>>>> -		return -EINVAL;
>>>>> +	if (sev_es_guest(vcpu->kvm)) {
>>>>> +		kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
>>>>> +		return 0;
>>>>> +	}
>>>>
>>>> Just a nit... feel free to ignore, but, since KVM_EXIT_SHUTDOWN is also set
>>>> at the end of the function and I don't think kvm_vcpu_reset() clears the
>>>> value from kvm_run, you could just set kvm_run->exit_reason on entry and
>>>> just return 0 early for an SEV-ES guest.
>>>
>>> kvm_run is writable by userspace though, so KVM can't rely on kvm_run->exit_reason
>>> for correctness.
>>>
>>> And IIUC, the VMSA is also toast, i.e. doing anything other than marking the VM
>>> dead is futile, no?
>>
>> I was just saying that "kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;" is in the
>> shutdown_interception() function twice now (at both exit points of the
>> function) and can probably just be moved to the top of the function and be
>> common for both exit points, now, right?
>>
>> I'm not saying to get rid of it, just set it sooner.
> 
> Ah, I thought you were saying bail early from kvm_vcpu_reset().  I agree that not
> having completely split logic would be ideal.  What about this?
> 
> 	/*
> 	 * VMCB is undefined after a SHUTDOWN intercept.  INIT the vCPU to put
> 	 * the VMCB in a known good state.  Unfortuately, KVM doesn't have
> 	 * KVM_MP_STATE_SHUTDOWN and can't add it without potentially breaking
> 	 * userspace.  At a platform view, INIT is acceptable behavior as
> 	 * there exist bare metal platforms that automatically INIT the CPU
> 	 * in response to shutdown.
> 	 *
> 	 * The VM save area for SEV-ES guests has already been encrypted so it
> 	 * cannot be reinitialized, i.e. synthesizing INIT is futile.
> 	 */
> 	if (!sev_es_guest(vcpu->kvm)) {
> 		clear_page(svm->vmcb);
> 		kvm_vcpu_reset(vcpu, true);
> 	}
> 
> 	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
> 	return 0;

That looks good to me!

Thanks,
Tom
