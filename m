Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C5D199868
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 16:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731082AbgCaO0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 10:26:35 -0400
Received: from mail-bn8nam12on2056.outbound.protection.outlook.com ([40.107.237.56]:35801
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730703AbgCaO0f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 10:26:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXJZztntvRuakWF7CzHIvBLv1c5hOxyTTiESvMA7LNId0IqP3fp/Jk0pT+Mgn/ImhFgUBJ3xhTIt3x4Bsz8+ZyiED+QGHQRUjEZmLR31PLkHwbdXWlKlsSpLFEicvoY6nQwFbn6exajp5l6pPzuczmYrov6PgmeUbeM5Usoy0luQrb6WvI9GwUiuxSSJQ8+DqMU2DgS2hdFfhjWcO42qLjU2SbBhKfYwE3elx/HrSae3CICIk7fEMKpGyGlX8DUzon2Xznv+SU6rLKUHXm+6mvaP0Z/5uVjA+UxOygUkcSGzKjBpe6A43jSXc5ZMr/QviOr80S0nq3Ei8jbNOSHT1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVpGAVFLQm+BHXgN94J2WDW3z/QNoFX5VNdqVxdbl0Q=;
 b=RJ4NRViueWTCRtn1poXrMBcZkxS0sNti8f+TblgRzky40ogT5DUvQTBh2e6ro2eEGJz4IIhm4mKIOGv3DO7pRTZJZ94dDbDXKdHmGiItzrWD2v3D8gLpBhMT4xEf/5+oMqKNG19GKJpSL847SkhFRNMmcsCPpXsCqk60D5o0zzetHNvj9SRaTSpGvPunjfMhTNEl1B1nRLiT+eWTXX1VaB6bzSsUTSEzGIsbKfHmLUKEOQ6GHT0BIUKPOmqz41Z87dtXQG5uUVPE9Bj9jMVMeEzwDWoLy5sQ/U3ogDyWrwMw+rljgW3MpuSRljBufswdsugROxxbkWBchHyMGz1dAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVpGAVFLQm+BHXgN94J2WDW3z/QNoFX5VNdqVxdbl0Q=;
 b=0biJCe+niwyvdcxeZRGF9RwyIY7J41zNiP46naKx0MI60NQCgOVeIolxoye79erUzqVZOiCM5kNZ+heHPnucm/Eiw7s8A9mY3qFjw3Bu12VzP989ls9x5IszapQwLHoBGyOLBvXwxT7pA61VugEqUJ/mxA5PRHA1ILdkQ/pc5u4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13)
 by SA0PR12MB4480.namprd12.prod.outlook.com (2603:10b6:806:99::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Tue, 31 Mar
 2020 14:26:31 +0000
Received: from SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::60d9:da58:71b4:35f3]) by SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::60d9:da58:71b4:35f3%7]) with mapi id 15.20.2856.019; Tue, 31 Mar 2020
 14:26:31 +0000
Cc:     brijesh.singh@amd.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org
Subject: Re: [PATCH v6 14/14] KVM: x86: Add kexec support for SEV Live
 Migration.
To:     Ashish Kalra <ashish.kalra@amd.com>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <0caf809845d2fdb1a1ec17955826df9777f502fb.1585548051.git.ashish.kalra@amd.com>
 <95d6d6e3-21d5-17c3-a0a5-dc0bac6d87ca@amd.com>
 <20200330164525.GB21601@ashkalra_ubuntu_server>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <3dccbcc9-c9b9-c98a-357a-dafde04984f6@amd.com>
Date:   Tue, 31 Mar 2020 09:26:26 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200330164525.GB21601@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: DM5PR07CA0098.namprd07.prod.outlook.com
 (2603:10b6:4:ae::27) To SA0PR12MB4400.namprd12.prod.outlook.com
 (2603:10b6:806:95::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by DM5PR07CA0098.namprd07.prod.outlook.com (2603:10b6:4:ae::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Tue, 31 Mar 2020 14:26:28 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6ff1b7a2-3727-4768-07d9-08d7d57f81bb
X-MS-TrafficTypeDiagnostic: SA0PR12MB4480:|SA0PR12MB4480:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4480F8762F12F9E9921C49D2E5C80@SA0PR12MB4480.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(2906002)(44832011)(316002)(31686004)(37006003)(956004)(7416002)(478600001)(8936002)(6512007)(81166006)(6636002)(81156014)(2616005)(52116002)(16526019)(26005)(4326008)(6862004)(5660300002)(6486002)(186003)(8676002)(31696002)(66946007)(66476007)(86362001)(53546011)(66556008)(36756003)(6506007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1KxUIF9OuaYegSXPyXakDt3R+OkooZ7dzNCchx1UtXbuxKaK+jkijqUArZF3ZdbC22bls1Hcq33N2NBokQ63g1YQ7K7xEDmht9cx5Rw23KpZeTW+Wqmq76YN2RNd8eaDhj0m8K0kkMd5Uf7cSsRCy+sJPbSIckxjrrPVwG4zXmwZmhBygYu4XTpGjJoYxiyHN20n30nyhU3YnrcVYdzq/cvhKHGupP5h8kf3OwAgyRugJqKwO8qfDlY7iLnmiQXYUwUH2weL7fnSB/rFkjX3eZOfWjTqQ4xEVwyhqAehnnUmB3ynsMYcCHB9s9tMWZbvyLhP7u8I2uUANvH+YPAjZcxiY20eeNlNt0p9lIf+9vxSuAgq5whmUbgJxNepJfWqj/1AOK5IQs6sYreawW0Umq2V2qf+8VvYF03OirLQkm622K/NAVPSBMFN80Zhqcty
X-MS-Exchange-AntiSpam-MessageData: EFjK6Gvy95RCZ0jjMmTCgedDaS1S35wr9lgdKSxG/K02GtBZM4QLHigPkR2ACWjWzJM37ystY/vIluvH3H1+2v4qMarIAFzVGYjZrbO/BKRW0GD9FhD9/lkiPVfOo0Z659MxdZObEIjCOdw5HWYBeQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ff1b7a2-3727-4768-07d9-08d7d57f81bb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2020 14:26:31.3441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kDvq1UyHEIhjeq10C5ruyTRm5FycrBEh6EO+XXV/96JEXImvMXWrL4DCnr2r/efqcw39eMcilsrBGO7EUoNcuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4480
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/30/20 11:45 AM, Ashish Kalra wrote:
> Hello Brijesh,
>
> On Mon, Mar 30, 2020 at 11:00:14AM -0500, Brijesh Singh wrote:
>> On 3/30/20 1:23 AM, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> Reset the host's page encryption bitmap related to kernel
>>> specific page encryption status settings before we load a
>>> new kernel by kexec. We cannot reset the complete
>>> page encryption bitmap here as we need to retain the
>>> UEFI/OVMF firmware specific settings.
>>>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>  arch/x86/kernel/kvm.c | 28 ++++++++++++++++++++++++++++
>>>  1 file changed, 28 insertions(+)
>>>
>>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>>> index 8fcee0b45231..ba6cce3c84af 100644
>>> --- a/arch/x86/kernel/kvm.c
>>> +++ b/arch/x86/kernel/kvm.c
>>> @@ -34,6 +34,7 @@
>>>  #include <asm/hypervisor.h>
>>>  #include <asm/tlb.h>
>>>  #include <asm/cpuidle_haltpoll.h>
>>> +#include <asm/e820/api.h>
>>>  
>>>  static int kvmapf = 1;
>>>  
>>> @@ -357,6 +358,33 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
>>>  	 */
>>>  	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
>>>  		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
>>> +	/*
>>> +	 * Reset the host's page encryption bitmap related to kernel
>>> +	 * specific page encryption status settings before we load a
>>> +	 * new kernel by kexec. NOTE: We cannot reset the complete
>>> +	 * page encryption bitmap here as we need to retain the
>>> +	 * UEFI/OVMF firmware specific settings.
>>> +	 */
>>> +	if (kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION) &&
>>> +		(smp_processor_id() == 0)) {
>>
>> In patch 13/14, the KVM_FEATURE_SEV_LIVE_MIGRATION is set
>> unconditionally and because of that now the below code will be executed
>> on non-SEV guest. IMO, this feature must be cleared for non-SEV guest to
>> avoid making unnecessary hypercall's.
>>
>>
> I will additionally add a sev_active() check here to ensure that we don't make the unnecassary hypercalls on non-SEV guests.


IMO, instead of using the sev_active() we should make sure that the
feature is not enabled when SEV is not active.


>>> +		unsigned long nr_pages;
>>> +		int i;
>>> +
>>> +		for (i = 0; i < e820_table->nr_entries; i++) {
>>> +			struct e820_entry *entry = &e820_table->entries[i];
>>> +			unsigned long start_pfn, end_pfn;
>>> +
>>> +			if (entry->type != E820_TYPE_RAM)
>>> +				continue;
>>> +
>>> +			start_pfn = entry->addr >> PAGE_SHIFT;
>>> +			end_pfn = (entry->addr + entry->size) >> PAGE_SHIFT;
>>> +			nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
>>> +
>>> +			kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
>>> +				entry->addr, nr_pages, 1);
>>> +		}
>>> +	}
>>>  	kvm_pv_disable_apf();
>>>  	kvm_disable_steal_time();
>>>  }
> Thanks,
> Ashish
