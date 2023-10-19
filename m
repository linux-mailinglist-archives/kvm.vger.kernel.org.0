Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6487D0598
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 01:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346760AbjJSXzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 19:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346735AbjJSXzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 19:55:49 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D06132;
        Thu, 19 Oct 2023 16:55:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKU0IdHAlSUxGAaeztQOCV9RdQXf4JdD3Xz2OpLhTLYTTHE9TwEBX0K2bhTrU9wMYtldvx+kH3IKCUhZDRO5FKbOjCFF82SWJ5oeB7zXlu9NIyJ9c1yyTDnoebQwrjjd1D98jNbLmC5wSw7/y0oc3IJuuU3RhgzEo05Cxyymzio6lI2I3KJI6XxNdsDNxwLD6nOeUys+PX+2gMiHHkTEXTnFMJZRHvHhvUtjnPjmTbze5cqz7UrQGdqXoZJrHWGcDQDJsNlKFUBL7Kj3BSIiZ26gjYdt10UJk7IAJoReGA1iVBf0EfL5VeD1C+/9b4SY36Rf8eXxxb4BBR4uqe2/ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CtegL5eow/qCWJkprViwsc/tafZru6sl0xC2+DiEgOI=;
 b=a+Ubtq12eQ+eJkoLPiXXkm4HAAq5WyjYhYne2yksr6aH9dl3EsqYRnvz0kF0OE97RFiEKxaCwqNZtkO+HFycjSFXmIceWW8xVBijt/fbdLruAYK0tVTIPP9ZwCBC4bWdKxGgrm3Vi/L2EZ/zwb1Ln6t43W6j9+3mA6Je1fCQh9LflfeYtb3NYC9JGKtNTMUQEFV+7w++fzR/p3d3w87UO46UK5kAKVssSgFBKTcEVKbuYCt60G2Vrosf3T8ht1Lw94uS5MdwzGEv99l5EL/aUkc82tJvOca84C4LW1lX9hvgi8C8gxQcyOP7kkgp175yLjXn9qxytRLF7rxfpat6aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtegL5eow/qCWJkprViwsc/tafZru6sl0xC2+DiEgOI=;
 b=J10w4Qn8DBDJzIT+Yhkr76SoR/1DvH5TgwtmXVe0NyeDxwRqNZGdT06nbA8K1Bpogw4tuvQyzp3nZ1/8H9IkOA7yQclmR6RyK3Ats2qBKgWbQY946HEgM01RZvPzrSHuDHwzmeW2SWpEl8Mzemoqb1Vjhvw++2y6+flPYws3aDw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SA0PR12MB4496.namprd12.prod.outlook.com (2603:10b6:806:9b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.24; Thu, 19 Oct
 2023 23:55:44 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a%3]) with mapi id 15.20.6863.043; Thu, 19 Oct 2023
 23:55:43 +0000
Message-ID: <2034624b-579f-482e-8a7a-0dfc91740d7e@amd.com>
Date:   Fri, 20 Oct 2023 10:55:18 +1100
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
 <ZS_iS4UOgBbssp7Z@google.com> <924b755a-977a-4476-9525-a7626d728e18@amd.com>
 <ZTFD8y5T9nPOpCyX@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZTFD8y5T9nPOpCyX@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0193.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:249::16) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SA0PR12MB4496:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c324ed7-01da-4d15-d839-08dbd0fee7e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WX7Nf/ETrse0B71tOyroumI+eejBGswDyMY69+AZ740r97s1Eb3ITgYi1ALWjgPH3qomOAjvDndBJRr7iiSffn5Lpf/3cfoYtArRDF+HedBFk8Ob+nIYuT0x9QSVJycq5+yPCiRQO9Z9bf6ktqFkwYS+NQ/Sh8NDO6cxMO0QyFgnlZZcqCiHJe3sZLZ3i95tjpMDGNxoKAu/8OVMltbGpdjWanHGiNnx0uaKto7j9YyNG4MPURxK/n4ZF1OQfhwv7v1b83orQ6LpoIV4EB8BlA455pE+6M5Gb1AeKTmRjZQ2ePB/GgbQSYFP3XRO2mGYeu62JQaWAyvUBS4zImfO0kGl+tx53RbUWL8HzCdEhyJp9vCapW4Nkw6/Ow45dJqjoFM9IR4zdzqio6mtDAJAiyX7v+T+a9v8UjMtN/ZXO2V1Z4wVsLYC0wN5Ayhcrw8uS50u/SAbDbjCn6apmS8BiLslfDNRt37uRgqt6g0/oJ3+hVW1WNdyffZtD8UaLnsOIPmq+Ys7Km8TgNKT9YfHDfcfM0E/1Bv6YgfWEYnhls/mS11J0W5FqzY2a/1rIS7+iCKcYm/d7eTYOE5dvJU0g6nKJ6/20qMIqH6Yra2HF6N1vIERM4zeOFL8/GwquQ/2ApMnVBSR9dGbfDjplRG1sw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(376002)(396003)(366004)(136003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(83380400001)(26005)(2616005)(7406005)(7416002)(5660300002)(8936002)(2906002)(4326008)(36756003)(31696002)(31686004)(8676002)(6666004)(6512007)(6506007)(53546011)(6486002)(66556008)(66476007)(66946007)(41300700001)(54906003)(316002)(6916009)(478600001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVRiRUIrTGM1d1Q4VlhjNjdia3pvOGlOZEltL0J0ZjM2cWdQVVBwdis4Y3JO?=
 =?utf-8?B?ZTNlamU0TExKOWFTSThScjduQ080cHpIc1BGMmU0WFRnaXE1NDMyaEdQMVRO?=
 =?utf-8?B?MjRaM1VWMWMrMjlwalNyc1dUWWNETUw5ME5nVmtPcFJncFVuVytnMXFjdHpQ?=
 =?utf-8?B?bFBBQ0VyaXVHOXQ2bEMzcXcxNXM3cVpqdDNBUXJ3Q3N1bDlLa2xZTUJHc2lN?=
 =?utf-8?B?WnY2cDJUaTNqWkxWdWlTR05pVGNFdENXbGFnbWg5SStHWDN2SGF1MXZBK0lY?=
 =?utf-8?B?M0R5ZjErWjAvRmh3V0R0c3VCcGtpUldpQWtyb0xycDZrM1gwQ2ZZcGM3Ylln?=
 =?utf-8?B?S0czVjQyZFpwSzU0ODE5Y3ljVDVCaVVYakJuNnN2V3hOTGpmalpOK0Y2Ym91?=
 =?utf-8?B?V3VqSHllL1ZaajZoMlQrYmlkc3IrcEZrVC9abExkbjU5clF6OFVRYU9MZUJO?=
 =?utf-8?B?TUtyN21lUFZtYTN1ME4xdWJmNnlFVjJtd0dTY2pDZmY2ZG9wUEV6dEx4WkJr?=
 =?utf-8?B?SVNiZ3puV3hMaWFlMUJwQ01zOURGMmRVb2hkTEppYlU0cDdxRWQ4dXdJcXFt?=
 =?utf-8?B?ZGo2ZzhrTzNRWHY2WnRnRjFqWVo0R3VtUk4wem1xcG9SdHNKdTBYS2taMnFT?=
 =?utf-8?B?cENPNzNaRTNNQkUyQmpKUnplS3hUR2dWa2dNR2Q1dXJNN1JRMUh0MmU1V09O?=
 =?utf-8?B?QlE3a1F1K3pBK2I2SmpFdVp6NmtEcGlzNXcwM2pUNFc1TzRQUHNlY0p0WVc3?=
 =?utf-8?B?YlQ4Q1ZqTWIwazJ6SVd5R2dwTSthQk9lRmkzWHpvbVZhcGRscUpzV3pNdnN3?=
 =?utf-8?B?Tmpnd0ZacmxTMUhlckpBbUVJWUhHVUZGWXdVTEVMUXJIQjhEbjdKeHBJOFFQ?=
 =?utf-8?B?NGZTRUZnak1wbUpXZFAxZWxmQy9rcUpJTVJKcVh6WHdxcDgwSnAvcTJHcHkx?=
 =?utf-8?B?NE50RWpNYkVNS0x2a2J1VXoxZVRXb3ZjMzErK0t0K1MxaTJLWkhONUhlalVx?=
 =?utf-8?B?aGdrZGZTSDNTRmhaNWtzWW1aK0p3WXJtN0owN2pJcW5HOGREWG0ybGxUVmRz?=
 =?utf-8?B?T0tLeEFjKyt0SzhOZDRNWUdqWmxjZGZKdEFoK0U1MXhPWkY4MzZ1WCtzbTMy?=
 =?utf-8?B?WTVrNG9aMDlFRW9uQ1F0VFp3c3Y5NU1yRXlGQVpISFFZNXVrYnc1UUxjTHQ5?=
 =?utf-8?B?TEc2c0pnTVlxMEE4b2hoS01pMEY2MExWMmNDcWh3TCtxZFRLd3pwYkRjclU0?=
 =?utf-8?B?R2xSaldneGYwRzdZZWk4OUZGaDlkL2drbWQxQmhwNHgybnZGT2JSTzBIclZm?=
 =?utf-8?B?RnI1VXpBY09yMERNTm9jN2o1WmZzWTNFaERQN1ducUZuMCtnRm9XWlg5OC9M?=
 =?utf-8?B?Z0JaUUFCQkgwZjJybjdzaXlhVUZ6dmw3eStSWWVDYmpBandlQ0ZDTGhLR25y?=
 =?utf-8?B?QzVGQjRPNjFGc1lWbnNORDMzNExjejl2WWdQa0lKUDI5Z3B0TnJLRmZ3SCs3?=
 =?utf-8?B?MEZTbDdqYjlENTNrVitrMjU5dENWVyt1VUpSVFlXVXRBMFZOeTdzSjdwWGdX?=
 =?utf-8?B?L2VIVzNyMjJNVkVjVVdVdlA4VmZiWGxzVEdORFdCZEtPQUg5QzVpVXZyRUR0?=
 =?utf-8?B?Q2tyRytrWTZ5dEpyN2d1NWxuaHlrMGx0TUlPRXVJanlnRVZ5RjBtM21UdGpT?=
 =?utf-8?B?UEZCN3dMN3pzUlhQTkNiUS80bXpGL2g1T2hwVVh4ZkdsVjh5b2VDMFJqdkgw?=
 =?utf-8?B?SVJzUjFpYnhKQkFhVXlWbWFTRGxEdElRUXFNZVIzTEdIM0ZzdGZ5dUd1RGFj?=
 =?utf-8?B?ZHZIL21zZlBlL0tPN2hPWERlZVBldEZwZUllZHo4RUNxWWh4T0xjeVlQQ1Zy?=
 =?utf-8?B?L25PakMrVkFzeFAzUGUzTStObm15NjFZR1NIenpESlZ4OUVJRHF6QTlqVVBD?=
 =?utf-8?B?NGJKUUdpVlgzYTdVdmcwNFppZ1A2SnJkdDRCQUxxSkxWdFdZTUdxUU1saUhT?=
 =?utf-8?B?VC9hMWQxWW1ZTFgybkNKNVI4TnB6RDRmUnhKK0NDd04rSVpCQXhiMlZYNXVw?=
 =?utf-8?B?OWZYKzYrWUN1UU85eU1sYVZCOGlhOE03eXZyUTNJdTY0VWJzVDU0dlM3bmIz?=
 =?utf-8?Q?ICbuIt1G5ZMkUh4dtR3bXFEVE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c324ed7-01da-4d15-d839-08dbd0fee7e1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 23:55:43.6833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5wE4IcqxZY8qaIo73GRCB+62dmaRxXcMjFVfL6PYzeJ5UXp7xPWWg6IIbxTZMpSRKQtOCBU8IdMrOuR3zki4WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4496
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 20/10/23 01:57, Sean Christopherson wrote:
> On Thu, Oct 19, 2023, Alexey Kardashevskiy wrote:
>>
>> On 19/10/23 00:48, Sean Christopherson wrote:
>>> static int snp_handle_ext_guest_request(struct vcpu_svm *svm)
>>> {
>>> 	struct kvm_vcpu *vcpu = &svm->vcpu;
>>> 	struct kvm *kvm = vcpu->kvm;
>>> 	struct kvm_sev_info *sev;
>>> 	unsigned long exitcode;
>>> 	u64 data_gpa;
>>>
>>> 	if (!sev_snp_guest(vcpu->kvm)) {
>>> 		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SEV_RET_INVALID_GUEST);
>>> 		return 1;
>>> 	}
>>>
>>> 	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
>>> 	if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
>>> 		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SEV_RET_INVALID_ADDRESS);
>>> 		return 1;
>>> 	}
>>>
>>> 	vcpu->run->hypercall.nr		 = KVM_HC_SNP_GET_CERTS;
>>> 	vcpu->run->hypercall.args[0]	 = data_gpa;
>>> 	vcpu->run->hypercall.args[1]	 = vcpu->arch.regs[VCPU_REGS_RBX];
>>> 	vcpu->run->hypercall.flags	 = KVM_EXIT_HYPERCALL_LONG_MODE;
>>
>> btw why is it _LONG_MODE and not just _64? :)
> 
> I'm pretty sure it got copied from Xen when KVM started adding supporting for
> emulating Xen's hypercalls.  I assume Xen PV actually has a need for identifying
> long mode as opposed to just 64-bit mode, but KVM, not so much.
> 
>>> 	vcpu->arch.complete_userspace_io = snp_complete_ext_guest_request;
>>> 	return 0;
>>> }
>>
>> This should work the KVM stored certs nicely but not for the global certs.
>> Although I am not all convinced that global certs is all that valuable but I
>> do not know the history of that, happened before I joined so I let others to
>> comment on that. Thanks,
> 
> Aren't the global certs provided by userspace too though?  If all certs are
> ultimately controlled by userspace, I don't see any reason to make the kernel a
> middle-man.

The max blob size is 32KB or so and for 200 VMs it is:
- 6.5MB, all in the userspace so swappable  vs
- 32KB but in the kernel so not swappable.
Sure, a box capable of running 200 VMs must have plenty of RAM but still :)
Plus, GHCB now has to go via the userspace before talking to the PSP 
which was not the case so far (though I cannot think of immediate 
implication right now).


-- 
Alexey


