Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADF27CEE3F
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 04:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbjJSCtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 22:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbjJSCtH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 22:49:07 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1DD12C;
        Wed, 18 Oct 2023 19:49:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e44sMuoMWcJZf3YLqNjNmI8162QcO/75TfC2F92+bpBdmFzKCCUghGVBe6RJ07zevXvsvovHL0CcVEldqp3UQANoSg+GsYXWg287KtqlfPzFXK4BEGTw/RdNhArdvixz+4QHG/BqVYXEapCm/Nd8anA/yOsFXSplQd6uWOdOd6tikbslkjn4Brl3xa1qLmgILW8DwiH12EUx/K8kow62WJvU1swwMyIK9DcLmfwg1fQIRhjC/BwrtfElXfYNU3Jo8Txlfa379DKG2ETCN0PdtxDHZqwzEOHGAlgS3ZR83idt31pIWqxVqvYIL8dL11jL8c33aChWBpLGwByRRT5Azw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q75WRsg9zaLqjI5Ls/eaC6LNAr2oOqKQfdFy0VzIxnU=;
 b=VwdV/gAVpQsU2tgw1WBw7Fs2gUZ6zEB3yGwViiUFWNQ8VLCmUH7+gJ13tZnneGWTlyU8uJsvyee0OsDFDev/ojl5CEk03d2EvwHAmO5T5B4sA2YvrUy23mVjHoKo83qASbiCw/pusGEYbWewyyh98beGzswoC1Oap9Y9EU2o+wd5lZwj5DIu/3Tj9M/Gkb2KDllM4NHc+xorsabUBMuaLB+nS1VQMbEmlHiEqlp/3YS6013LlUhIuRDezoWwEzqq42zQxZALfHS6MIuvCMHiil1mEUxWnH5JeNHFE8FqcD8E4kCipoqvsXbvJ+KHpt2i+3xNSS+5r2aTtPnBc9DE4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q75WRsg9zaLqjI5Ls/eaC6LNAr2oOqKQfdFy0VzIxnU=;
 b=rKcHOYEqc2uTBSXN191mFMOxF/qdsAIyKxp++7WeXX1nDJrMC4zXZiBfBwTdc0U9lSTnYwNEFldQFtgXm02OLsX3E6le4AH8OvNqOX9KciXSY7YLDteWT8vDx1+UNpjhiWYMIcq8NitT9DZI1fA00Iq4hq9ltuHa4Vh0NPSlSm0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH7PR12MB9256.namprd12.prod.outlook.com (2603:10b6:510:2fe::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.43; Thu, 19 Oct
 2023 02:48:57 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a%3]) with mapi id 15.20.6863.043; Thu, 19 Oct 2023
 02:48:56 +0000
Message-ID: <924b755a-977a-4476-9525-a7626d728e18@amd.com>
Date:   Thu, 19 Oct 2023 13:48:26 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dionna Amalie Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        pankaj.gupta@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-49-michael.roth@amd.com>
 <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com> <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZS_iS4UOgBbssp7Z@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0075.ausprd01.prod.outlook.com
 (2603:10c6:10:1f4::11) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH7PR12MB9256:EE_
X-MS-Office365-Filtering-Correlation-Id: 068660b4-d522-47b6-e1ad-08dbd04def2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lh5/0oyNVMewlcefv6a/erMyrMMUZdd5u5DTAxbuKt9NQi2R5sDctMcOEpjzaoOVQKkSvN/P0h0pusRobl1+H7QGw/kLs2yuu3VBrgbrCVu+2fjU3Enwjcsi1qRj8v9Zqt+Uh2EiqswOlfkbRmhZ0/hV204qG9RVYWSmvkzX6et2HWgFBW91Nx9Rl817khfZVD6bwika6+XxNhXE6EqSx1nL+V5kZS/V3rEuGdpEEjUtd4y47zVoprrLHMbzxFsmAg8Yr7tf1WiigMpHg18tx315SjL9ZdtgWSeIrZEEC+okQRVIY34S9/9sThCGPd22c210PPsSJChcZJsuG9HyTqz9hjD7S03jDbKViE1EAkmMiT8X2TAI/DurTjuLf58WKYqOyMSmDPfVAQtukvEKjokxLCys9RfF24oEjXS5Oh21176gKaqVRaRv2MBa2TCqgPZvB98DNovYaZlo8BQ7kHGWzR1IG9w6ym6UG5hQhySt/oISK4DW/QYiDKk06f9JHkVlIO7oTIhuARBYfe9AM9mzCzuuKA34FSRdcrTLSBRIp+4sV2RFZRCNUcvUIWkBI5WU2bhbPCE9bVK0BtQ4K5g0BsuiabV4EIRaDci3/LwHctYQBD4eWXSnejp0tJUibDUds9Q1x5OO3rZKV0TLjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(39860400002)(376002)(396003)(346002)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(4326008)(66946007)(66476007)(54906003)(8936002)(66556008)(8676002)(6486002)(6916009)(5660300002)(316002)(31686004)(41300700001)(7406005)(6512007)(7416002)(66899024)(2906002)(26005)(83380400001)(2616005)(31696002)(53546011)(38100700002)(6666004)(478600001)(6506007)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTAzQUFkZHpIWGh2ZFZRSi95amcxSTNtUTJVcnlZMVdlL2ZTc0tvYWErNUow?=
 =?utf-8?B?L3dNczNYYUc0U3o4R0twR2YyT2JaRXB4RTZBckE0MnNoSVRndWkxWGpjV2lG?=
 =?utf-8?B?UzRMbStsSFRsZDlSdll1SFBsNnBvdjdoOXVxSjZhZTVXWnFUYU4xZENOZTU4?=
 =?utf-8?B?QjE0bjBlZE80aENaU0UvbDdpc1ZiV216QU9tOVRaQWkrcG5ISjEyN05FdTdJ?=
 =?utf-8?B?L0N4ODRrYkp6R243LzloSWN4SGV6L2RIV2U0QnZIYzAwMFpkYjBKNjdJcGZ4?=
 =?utf-8?B?NXRtc0o1emY5ZXg5U1pMLzdVQmltbmpNWUxsYXFtcktJTmlBYTRjOWRTS2dq?=
 =?utf-8?B?TWlGUnFwelhqaXZNUXhibUp0YmdpTEZYcUwwTWU2S09KeHNpdUJHc2x2UER1?=
 =?utf-8?B?OTgxT05wUnFwbkxob2Z2LzVBOUhFZUZ6bkNSNEhXbDg0SmpJeE5MWXVheTJQ?=
 =?utf-8?B?ODJoNFoxanVaa3RJdnZuVEdXSjlyZ0hwZjZOWE4wVkwwdmsyWFpJR3llTHln?=
 =?utf-8?B?MFJxeXdLNW45NksvazJ1MEFzdVVzL3FqR0psT0VnVlV0RDR4WW5TWFFwcUd1?=
 =?utf-8?B?aHJmU1g1N1R3Zm5wbTRzdWtjcjhDVzRZYlM2QTYwaVVldkJkNU1jRFZheSth?=
 =?utf-8?B?T0VETjZxRk83aThmTlh1MlNVQndjSDNUdmFPQXhGbXNIT280N09qUTRMSlBX?=
 =?utf-8?B?VWdzZisvWlJDSjY0a0hmZk9RRTAvUTNycm1Nb0JoMG1aZ0duLzVaUVNyTkxn?=
 =?utf-8?B?L2l6NW8xOE9RVHJGeTc0TWNCeVlpOW1kNTJtelo0NXlsVUgzdmtZd2cvNWoz?=
 =?utf-8?B?c21BaTFSamh6Q0tkMVIzcGRGRUNDLzhpZ01pUno2L25Sb3RsM0pDV3dpUm8y?=
 =?utf-8?B?eTdaaFFSRXZqRVZCMDFhWlhDMk9UTnVsbGx4dUVqUUMxN3BINkdJLyt3bjM4?=
 =?utf-8?B?RUcrZnoxTzY2VGdKUGczcDJteXUyVytYRUt6UkJhM25SUGF4Smo5MEZOZEk5?=
 =?utf-8?B?T21kZHBHSk1lRHQ2MmRhZFR1TGxobUFqQ2UreWtHZEUvbk1pdUYxbDZxRnpP?=
 =?utf-8?B?cytmbkh4NmpId281akQ1bFVBb0phQkt2YjluMERrcGFoMThUbStaRkQ1MU5D?=
 =?utf-8?B?LzFEUG11bVJUMXJDYjRjdU9Zc2VNY0NBRHJxQ3hHanlXemhnYTlNV202Tyt6?=
 =?utf-8?B?WkZBK0JVUTNabkFOdU9YNmxMaEY1d3lDckRtVkNIUXNmOEVoU0c1dVhmcmNj?=
 =?utf-8?B?ekw0VjhnMW1oZ3JmRXNyQVpZU3FTcVRrM0piL0xlcVZZZHNrZ2xIdi9HWW1Z?=
 =?utf-8?B?dHJLQ3dEYVRuYTJwZWhhMHR5bm9sZFFmc2s3cmV4Y2o3aDlEY3NHVmNhcHJB?=
 =?utf-8?B?R3BjdE0veFZTNld6LzhQYVR0VTcxbExsRFJ3TWZPTjZKcjV2clIwamFTVnNS?=
 =?utf-8?B?K01KYkQ1TUZXZmRWSmtiLzhVQmZCZlhuKzZMc1daTkdCSkc4eUVkakw4bjI4?=
 =?utf-8?B?eDBGc2s3WVRvRXJmL3ZqY3NybDk0eEVXbllHL0gxSktLMSt3REIwZENvQ1Qv?=
 =?utf-8?B?NmxFZGlhWjRsRGw4MHYzaHcxbnZEOXhxcWZJTmphRUlwTkVGYXRrZzVmYldn?=
 =?utf-8?B?eXlaNEV2Y0Y0MmZyVnRnRUtzK0hudXE4STNGSVBkU1N2OURLS3ZmaHgydE1I?=
 =?utf-8?B?VHBLbmlERCtQdjY3ZVlCT0MvcWVEQ3VZMXVjMERhd0JJQUdoYzNoR3R0Uk9i?=
 =?utf-8?B?VUh1L0wvMElONkdFK1dveG1zcGpFVlI3UExyQ3NJK1pLWVVKaEhEQjZ6ZFZZ?=
 =?utf-8?B?SllqYjUrcUx3RlliU2JncTVLOFhMcnBiaEZXdisyNFFLTy9GL0kxN01oRVBp?=
 =?utf-8?B?QVFyazczYmY1ckFxNHFXWGhBS1g5ZWxPNC9OWjBFN2o0NzJtbUVuUzhsZ0ph?=
 =?utf-8?B?WVNCTHI1ckN2YjQ2MXd6Smh0bDB0a2hSTmdURzQxYnJKZTUrckV5bUFqandD?=
 =?utf-8?B?d1BCVGlmVHJ5VmZoSFJOd0Fjd1E2bFRqYjBtMHhCTldwWlVVNnhTR21haURv?=
 =?utf-8?B?VUlUdVZxQ3lGK2ZsYlNXMWRyaGhEcjlleDZUWi9FNFFsRFFodU1LOUpRQ0Fy?=
 =?utf-8?Q?jJv40YW5+4e/Mj5HOA6x26/Uf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 068660b4-d522-47b6-e1ad-08dbd04def2c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 02:48:55.3196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kcLiFAEDfJViBKl5ZgD3MPpXEdt6uAVQ/6KU7jSPwVuW224q8z+UV7vrgSibgPybkJAm+kMAM23JGlKntohVhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9256
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 19/10/23 00:48, Sean Christopherson wrote:
> On Wed, Oct 18, 2023, Alexey Kardashevskiy wrote:
>>
>> On 18/10/23 03:27, Sean Christopherson wrote:
>>> On Mon, Oct 16, 2023, Dionna Amalie Glaze wrote:
>>>>> +
>>>>> +       /*
>>>>> +        * If a VMM-specific certificate blob hasn't been provided, grab the
>>>>> +        * host-wide one.
>>>>> +        */
>>>>> +       snp_certs = sev_snp_certs_get(sev->snp_certs);
>>>>> +       if (!snp_certs)
>>>>> +               snp_certs = sev_snp_global_certs_get();
>>>>> +
>>>>
>>>> This is where the generation I suggested adding would get checked. If
>>>> the instance certs' generation is not the global generation, then I
>>>> think we need a way to return to the VMM to make that right before
>>>> continuing to provide outdated certificates.
>>>> This might be an unreasonable request, but the fact that the certs and
>>>> reported_tcb can be set while a VM is running makes this an issue.
>>>
>>> Before we get that far, the changelogs need to explain why the kernel is storing
>>> userspace blobs in the first place.  The whole thing is a bit of a mess.
>>>
>>> sev_snp_global_certs_get() has data races that could lead to variations of TOCTOU
>>> bugs: sev_ioctl_snp_set_config() can overwrite psp_master->sev_data->snp_certs
>>> while sev_snp_global_certs_get() is running.  If the compiler reloads snp_certs
>>> between bumping the refcount and grabbing the pointer, KVM will end up leaking a
>>> refcount and consuming a pointer without a refcount.
>>>
>>> 	if (!kref_get_unless_zero(&certs->kref))
>>> 		return NULL;
>>>
>>> 	return certs;
>>
>> I'm missing something here. The @certs pointer is on the stack,
> 
> No, nothing guarantees that @certs is on the stack and will never be reloaded.
> sev_snp_certs_get() is in full view of sev_snp_global_certs_get(), so it's entirely
> possible that it can be inlined.  Then you end up with:
> 
> 	struct sev_device *sev;
> 
> 	if (!psp_master || !psp_master->sev_data)
> 		return NULL;
> 
> 	sev = psp_master->sev_data;
> 	if (!sev->snp_initialized)
> 		return NULL;
> 
> 	if (!sev->snp_certs)
> 		return NULL;
> 
> 	if (!kref_get_unless_zero(&sev->snp_certs->kref))
> 		return NULL;
> 
> 	return sev->snp_certs;
> 
> At which point the compiler could choose to omit a local variable entirely, it
> could store @certs in a register and reload after kref_get_unless_zero(), etc.
> If psp_master->sev_data->snp_certs is changed at any point, odd thing can happen.
> 
> That atomic operation in kref_get_unless_zero() might prevent a reload between
> getting the kref and the return, but it wouldn't prevent a reload between the
> !NULL check and kref_get_unless_zero().

Oh. The function is exported so I thought gcc would not go that far but 
yeah it is possible. So this needs an explicit READ_ONCE barrier.


>>> If userspace wants to provide garbage to the guest, so be it, not KVM's problem.
>>> That way, whether the VM gets the global cert or a per-VM cert is purely a userspace
>>> concern.
>>
>> The global cert lives in CCP (/dev/sev), the per VM cert lives in kvmvm_fd.
>> "A la vcpu->run" is fine for the latter but for the former we need something
>> else.
> 
> Why?  The cert ultimately comes from userspace, no?  Make userspace deal with it.
>
>> And there is scenario when one global certs blob is what is needed and
>> copying it over multiple VMs seems suboptimal.
> 
> That's a solvable problem.  I'm not sure I like the most obvious solution, but it
> is a solution: let userspace define a KVM-wide blob pointer, either via .mmap()
> or via an ioctl().
> 
> FWIW, there's no need to do .mmap() shenanigans, e.g. an ioctl() to set the
> userspace pointer would suffice.  The benefit of a kernel controlled pointer is
> that it doesn't require copying to a kernel buffer (or special code to copy from
> userspace into guest).

Just to clarify - like, a small userspace non-qemu program which just 
holds a pointer with the certs blob, or embed it into libvirt or systemd?


> Actually, looking at the flow again, AFAICT there's nothing special about the
> target DATA_PAGE.  It must be SHARED *before* SVM_VMGEXIT_EXT_GUEST_REQUEST, i.e.
> KVM doesn't need to do conversions, there's no kernel priveleges required, etc.
> And the GHCB doesn't dictate ordering between storing the certificates and doing
> the request.  That means the certificate stuff can be punted entirely to usersepace.

All true.

> Heh, typing up the below, there's another bug: KVM will incorrectly "return" '0'
> for non-SNP guests:
> 
> 	unsigned long exitcode = 0;
> 	u64 data_gpa;
> 	int err, rc;
> 
> 	if (!sev_snp_guest(vcpu->kvm)) {
> 		rc = SEV_RET_INVALID_GUEST; <= sets "rc", not "exitcode"
> 		goto e_fail;
> 	}
> 
> e_fail:
> 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, exitcode);
> 
> Which really highlights that we need to get test infrastructure up and running
> for SEV-ES, SNP, and TDX.
> 
> Anyways, back to punting to userspace.  Here's a rough sketch.  The only new uAPI
> is the definition of KVM_HC_SNP_GET_CERTS and its arguments.
> 
> static void snp_handle_guest_request(struct vcpu_svm *svm)
> {
> 	struct vmcb_control_area *control = &svm->vmcb->control;
> 	struct sev_data_snp_guest_request data = {0};
> 	struct kvm_vcpu *vcpu = &svm->vcpu;
> 	struct kvm *kvm = vcpu->kvm;
> 	struct kvm_sev_info *sev;
> 	gpa_t req_gpa = control->exit_info_1;
> 	gpa_t resp_gpa = control->exit_info_2;
> 	unsigned long rc;
> 	int err;
> 
> 	if (!sev_snp_guest(vcpu->kvm)) {
> 		rc = SEV_RET_INVALID_GUEST;
> 		goto e_fail;
> 	}
> 
> 	sev = &to_kvm_svm(kvm)->sev_info;
> 
> 	mutex_lock(&sev->guest_req_lock);
> 
> 	rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
> 	if (rc)
> 		goto unlock;
> 
> 	rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
> 	if (rc)
> 		/* Ensure an error value is returned to guest. */
> 		rc = err ? err : SEV_RET_INVALID_ADDRESS;
> 
> 	snp_cleanup_guest_buf(&data, &rc);
> 
> unlock:
> 	mutex_unlock(&sev->guest_req_lock);
> 
> e_fail:
> 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, rc);
> }
> 
> static int snp_complete_ext_guest_request(struct kvm_vcpu *vcpu)
> {
> 	u64 certs_exitcode = vcpu->run->hypercall.args[2];
> 	struct vcpu_svm *svm = to_svm(vcpu);
> 
> 	if (certs_exitcode)
> 		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, certs_exitcode);
> 	else
> 		snp_handle_guest_request(svm);
> 	return 1;
> }
> 
> static int snp_handle_ext_guest_request(struct vcpu_svm *svm)
> {
> 	struct kvm_vcpu *vcpu = &svm->vcpu;
> 	struct kvm *kvm = vcpu->kvm;
> 	struct kvm_sev_info *sev;
> 	unsigned long exitcode;
> 	u64 data_gpa;
> 
> 	if (!sev_snp_guest(vcpu->kvm)) {
> 		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SEV_RET_INVALID_GUEST);
> 		return 1;
> 	}
> 
> 	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
> 	if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
> 		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SEV_RET_INVALID_ADDRESS);
> 		return 1;
> 	}
> 
> 	vcpu->run->hypercall.nr		 = KVM_HC_SNP_GET_CERTS;
> 	vcpu->run->hypercall.args[0]	 = data_gpa;
> 	vcpu->run->hypercall.args[1]	 = vcpu->arch.regs[VCPU_REGS_RBX];
> 	vcpu->run->hypercall.flags	 = KVM_EXIT_HYPERCALL_LONG_MODE;

btw why is it _LONG_MODE and not just _64? :)

> 	vcpu->arch.complete_userspace_io = snp_complete_ext_guest_request;
> 	return 0;
> }

This should work the KVM stored certs nicely but not for the global 
certs. Although I am not all convinced that global certs is all that 
valuable but I do not know the history of that, happened before I joined 
so I let others to comment on that. Thanks,


-- 
Alexey


