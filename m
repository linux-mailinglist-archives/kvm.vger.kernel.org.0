Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C895794462
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 22:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244304AbjIFUUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 16:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244293AbjIFUT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 16:19:58 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8FC137;
        Wed,  6 Sep 2023 13:19:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=krnEiiwg/ZX6+m33LE6vW82sozeA7JuceILRzwLqzmBpPJ+WwpGiZCOGvo2iIWcl6w+Sla4ka5fy1G2pgOpBA780nzig/eIShdbXgeZv8qJ6Bhc3HXwOujGey0OPapEaAizhS4C2pA8Z/5FttVuMkH1Anby4V2ZnzhKjW/2iekkynD5J/8mv8TwAHgIt8/X7nzYB+IvgpjPUEA+M4JVFyJH6YkKtsCanQyOFrjXYlDVywVLP+gxmsJEzaAcuvoX5yMOTNwweZfOlWH3A8C7q/mpYjsaDqFTm0p+B7y6Bn4try5G6Dlx1GhKZnuL4CyDcErkF5XN6AxwlF/bG8gx2Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3BiSDoHMkJpCM+/sizd+KyMCNHNKh5/CH4Dm4VlVJo=;
 b=XVVGhNEE2y1yoNa+O8VZL4Qbcj4v27eYEmLHZt2l/PvhLVz49X4uTba88zzbds0eKSH/cGRX7ZeznDSRdALv2e2lGW6/1Z8zmwwKbVyjHjxcOoSpWkrHxTfb5wQMQJo/rFnMavRD/0T+PkflAKlcYsmGl2sliQdTXl59OAms/k83AZc0n6MGZl8R2ay5M4iFsr2jvtAEpK+YkIwzbi5rhUX4fjxmRc2YDvft6r5IcU/xJGszpl9Qv6gwKNCmOSGitZTJ3JCtMJyEDar+MIzGyLHKR+J37MSUebaMKQMeY3aBmq7ByzGA3++ETjQ+HylqUae9jphyqPfu+ROG/UXkZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3BiSDoHMkJpCM+/sizd+KyMCNHNKh5/CH4Dm4VlVJo=;
 b=Q8o+qNjTJwSquGAqOUNmTcZlX1G4/pGqHGEV1g0l+ZwKwVgKJDL+w/hU2tCBnZwsY9D7C8goBA2pIlBDi4ePFcwiU7iwv1BVTO1RCm51AkgNGygwDUstLgHn8TLaM29n9lhBt6roWhUCbOWz4tPNwyxca00U3oJoWFmlmLilX9c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CYYPR12MB8730.namprd12.prod.outlook.com (2603:10b6:930:c1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Wed, 6 Sep
 2023 20:19:52 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6745.030; Wed, 6 Sep 2023
 20:19:51 +0000
Message-ID: <249694b0-2afd-f653-a443-124e510f4a4c@amd.com>
Date:   Wed, 6 Sep 2023 15:19:47 -0500
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
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZPjc/PoBLPNNLukt@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0036.prod.exchangelabs.com (2603:10b6:805:b6::49)
 To DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CYYPR12MB8730:EE_
X-MS-Office365-Filtering-Correlation-Id: 23d48c6d-e294-46f2-3d89-08dbaf169ffd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yUlNpOb5f4e5UToYb35JplZ8Ni3/a+bJmBGDWfsdn8gclUs0t2P24tZ+8k4beaYPDDcjgXjVAvGzw/QdN+hMXHqXg4tiaqwGCu574qyMIIHwDUAtY/ltfJTP7hIIGUWgchOwjKwrk0RANjG/RqffFgywQrRweEA4rRt3D7SrgtPgzxjSiQSuLn/630CmjhTpDbQ/BnvFVEek8vUQPC+5ib4E7JVvWfBwYPMWnGJ/zfMyGGz6yythgTmbQYXHBgLPzMMGeEOKVKmg03hlpTe41IfYIhIaD5oZtQ5BIMv2zLp0kdgfgrqVbXhdIQf7QEya5dNz6/bt6YcIAmV02XtvgazdV7ZKO7qGNrF0GgqSItfTpKq01DSb+i6J7obUS5zR8psW9elYSzkKYxOgpmI7AvjpI0rqJaVQTpNg8kWmP17/szUbRxFwORzrLnJ+VnnJt6GUYFprcv+AwAO10OViamUbxX6VAsphHrCnWaO/oYNqx0Ce7lGWc9pDwzJxMW6d5BMXlR7HClK/4ZOHaYvVYF02oJId56vhMUId8VwH6mtUQU5deymoYJDKROHMDhY943x/GTQ1J4zX3GAJNqhHSWuhF2vo5ou3e6hlNAzzSAdxpaVmVkeVMqL+TQhNmSJWnKZh119sIhH94LgGSG6k3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(136003)(396003)(346002)(39860400002)(186009)(1800799009)(451199024)(15650500001)(2906002)(38100700002)(36756003)(31696002)(86362001)(41300700001)(6512007)(53546011)(6506007)(6486002)(54906003)(66476007)(66946007)(4326008)(66556008)(8676002)(8936002)(6916009)(2616005)(316002)(6666004)(31686004)(478600001)(5660300002)(83380400001)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1R4QmI4aS9PUnp0RVpvdUpUTklTeWxjMk42ajgyY2JpODExdGJETEhQdzRI?=
 =?utf-8?B?djh1QnV1bHhCWGxmaFhmeS9iQnlCTkNwNTE2dlUyK2pWTFp0MVBsNjY5Zk4w?=
 =?utf-8?B?WVlwRHNIdzJQQ2crMzhIMjVpZzdIdDhDY2xKeGVJenViSGw3d1p0SDRFMGgy?=
 =?utf-8?B?bmhCMlVybDlkWmNVaWdSUlJGLzRPanBXU00zazJqY1ZEd09RakZEOGdVMEo4?=
 =?utf-8?B?T3UySTdlcWY5eEkrVE9RaDY3U2FGdyttL1IzbWFaYTZsRGRBK0JVUmFuMUM3?=
 =?utf-8?B?L3JqQ2VwVE5KNzVYS29zcGxaQkZtQ21NdTF6LzBKZ2hHS1ZmOXczY015YWM1?=
 =?utf-8?B?ejVMYXpFRFU3REQzZ1VFVEtZUCtsK3BIN3oxdndiZEY3TmFUM1c4TFJxVUsv?=
 =?utf-8?B?YWFYekZxcng3RUdiUERiZnByRFovVEoyRzFtLzFtS2tqMHFBTllMTHJyenEr?=
 =?utf-8?B?U1NUcWNqU2M3ZVZESldCN0NNWnk2TnBGcTkxdE1lWi9qMTVJaGM3bVhCU052?=
 =?utf-8?B?aUtLTmlGaU1idVAxcHRqNWY1dG5RQ0wwUEczUEM4ZXlkM0FyL2pWKzBmb0Z0?=
 =?utf-8?B?WGRxSndYNlI5VC9BeThucGZPOGlVUE1Za1IzbmN1NUpSUzdPWERmVk8wK3ZE?=
 =?utf-8?B?RTVSU01aeW1wbTV2azJBUlJBWUYzUWRRVlErOXJ4SXZIdGpxVjRqOGtESFR4?=
 =?utf-8?B?d0tkUnl3TkoxSktndjBVMHNqbEh5OHVBZVk4UmJrY2pGVTBRMjdCMnJZS1pT?=
 =?utf-8?B?UWNPSHI5Z1ZCbm9mTUJlZTB4Rmtwdm9BVFFWNDRBR29lendvemxxWHBOWGQr?=
 =?utf-8?B?UG1NRHp6bW9FSnVTNWxuVDRTYkNmdmxKejhoSUdSRXcrRjRsaGRhaGtEYW1P?=
 =?utf-8?B?ZWdPQXZGaVhkZmt3WkF5UzZDVkZweGw4Mm1xa3hBVUpqOWN4RzJjVnVMWExk?=
 =?utf-8?B?SXFuU1U5R2p0bTBrTHlpaDAxbG5nV21xSit4L2ZSaUFxZmtxUGFjWHdmQ3ha?=
 =?utf-8?B?U2grakpMRnZBSFQ0WDc1QlNkUlV5RVhicUQ5UjVCdk83R1F1K2xCc2NrRzQ4?=
 =?utf-8?B?T0diTWpUdW9McmpkOWJoT3lta0FLR0JrNEhGMHZYVEM2ZkJpaHFsS2h5cDVr?=
 =?utf-8?B?c1BMc1V5M0JidjlBM0xwSDBOY0hWWFV6ZTAyVkttaWFyNWRSdDZqZEV4T2I0?=
 =?utf-8?B?cUpnUm1oS1BKanlHd01mTUVrMWtGeUlad2E5SzhRQ2dJNUlxc2ZwT1RtbGdp?=
 =?utf-8?B?WUFIZUdzamtKQ3NaaEk1ZEduWjlvUlFvalhaazR2WnNIYkNORjU2aUQrMEg0?=
 =?utf-8?B?ZTNpZEpUdHExWlRDZ08wcGdVSGJwTURwbng2dFdGVWtTYWIvdXZoQmZZM2cv?=
 =?utf-8?B?K2pMcFhrcGpkWC9JSXZXd0ZzQmQ2bkVNSWpFRHJDSzJsWXR3cW5qRzRFWlh1?=
 =?utf-8?B?T2lmaVBDOU1XVmZMbXJ3WUVTZHlvVmtzVys4d1dPM1l5QllVdkkvWmpoM2tz?=
 =?utf-8?B?a3hBVEFXcG9SNmV6Y2VNbE5ISlgvS2NCaWJkQkczTGlBMGZNZm1PVkkwbW4x?=
 =?utf-8?B?MGhWeTVES3RKU2dHYUpXZHZmQXQvSHUrd3lUc0lLV0JIMzV0cGRXTTBCN2Ey?=
 =?utf-8?B?amZqTVJwZXhaYURQazRhL08yWi9JblE1b2M4bTdtNHpBUzM2SVhUMjRUcTRm?=
 =?utf-8?B?TXRRam0yYmZRNzI2b1lYYnZyT2NpcGJWMTF1R3ZXS2EwcHRkR1JSdStnbmtu?=
 =?utf-8?B?WW1YSlVTKzNBVnZIMFR4dlJXL3J2eWtrZ29FcVoxdVRRVm83UDJzSXFMS2ZT?=
 =?utf-8?B?TkN6TEUrNk9jVTFhandlYlpsU1crWjRlbUtNcnU4cXJoZEE4cituaktWVHYy?=
 =?utf-8?B?Z3dNTktjU29OMWJrNldvSmVMNW1IVDFQcllxY2lFUWErYWY5N25vSUExRTdu?=
 =?utf-8?B?cDJONERyTmZzMHkxY3VyVjNieUlUQUwxQTJreHhmdkg4NlpLOWExbVAvTG11?=
 =?utf-8?B?MUNuTHg5SWpyWjRJUSt1bXJNbWVsZGthUWZCYVZ1ZFlrSEFob093ZmY1a2VQ?=
 =?utf-8?B?ekx4VVpyRjI1ekM5M1VoTjErbnN1N0hoWFJsaHNNVm1FejViQjR5Q3J2TGZz?=
 =?utf-8?Q?mgUbrcWpRVf9902eXLtzeACef?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d48c6d-e294-46f2-3d89-08dbaf169ffd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2023 20:19:51.2718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FQM4cQejWpFUyEhgAHyGGvsnkLapxHkHcMJpt6d+DdPWOwq28DoZ0B1fkRpwF8n6/wkDJtZuO+b2oKWXFnAl9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8730
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/6/23 15:11, Sean Christopherson wrote:
> On Wed, Sep 06, 2023, Tom Lendacky wrote:
>> On 9/6/23 10:14, Peter Gonda wrote:
>>> Currently if an SEV-ES VM shuts down userspace sees KVM_RUN struct with
>>
>> s/down userspace/down, userspace/
> 
> Heh, yeah, I read that the same way you did.
> 
>>> only the INVALID_ARGUMENT. This is a very limited amount of information
>>> to debug the situation. Instead KVM can return a
>>> KVM_EXIT_SHUTDOWN to alert userspace the VM is shutting down and
>>> is not usable any further.
>>>
>>> Signed-off-by: Peter Gonda <pgonda@google.com>
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>> Cc: Sean Christopherson <seanjc@google.com>
>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>>> Cc: Joerg Roedel <joro@8bytes.org>
>>> Cc: Borislav Petkov <bp@alien8.de>
>>> Cc: x86@kernel.org
>>> Cc: kvm@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>>
>>> ---
>>>    arch/x86/kvm/svm/svm.c | 8 +++++---
>>>    1 file changed, 5 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index 956726d867aa..cecf6a528c9b 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -2131,12 +2131,14 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
>>>    	 * The VM save area has already been encrypted so it
>>>    	 * cannot be reinitialized - just terminate.
>>>    	 */
>>> -	if (sev_es_guest(vcpu->kvm))
>>> -		return -EINVAL;
>>> +	if (sev_es_guest(vcpu->kvm)) {
>>> +		kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
>>> +		return 0;
>>> +	}
>>
>> Just a nit... feel free to ignore, but, since KVM_EXIT_SHUTDOWN is also set
>> at the end of the function and I don't think kvm_vcpu_reset() clears the
>> value from kvm_run, you could just set kvm_run->exit_reason on entry and
>> just return 0 early for an SEV-ES guest.
> 
> kvm_run is writable by userspace though, so KVM can't rely on kvm_run->exit_reason
> for correctness.
> 
> And IIUC, the VMSA is also toast, i.e. doing anything other than marking the VM
> dead is futile, no?

I was just saying that "kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;" is in 
the shutdown_interception() function twice now (at both exit points of the 
function) and can probably just be moved to the top of the function and be 
common for both exit points, now, right?

I'm not saying to get rid of it, just set it sooner.

Thanks,
Tom

