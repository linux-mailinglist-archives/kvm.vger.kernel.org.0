Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF21119E7D2
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 23:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgDDV6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 17:58:04 -0400
Received: from mail-mw2nam12on2047.outbound.protection.outlook.com ([40.107.244.47]:6131
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726314AbgDDV6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 17:58:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnWnqO56y0x87zL9789rjw3wLf/ictW35oQFdVrOZ8u0UlHK0az1khnRA2BwvqK4xsebi5NI6qmIQnGjtJWBjtgjKCtWAWd5dklePgBle4hK53Dhxgtz9j4QCYlk4FmcbNrh4Qi0/W+5x48fuNjBgFKudfVB4d23GSuzs0pMwql2p0LluebU1ScxQviGu0EdAgsFHFLKwBgFzPXMcrrx2ISoJdSfL1x+Fl/g4902PtaRoAblY/sw2L0lkHEespLLb1m6r4q6xPhY1JjcyC0Q6kxz8kHL5Tslf4SS9H7B2vukGooY24zryrGZtJHOy8XA9U7L12u9AHoezLfXFMErAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEZzhU1YSdjgHDhdHl0S5gF9goIaH9MMhc1x6L6cy48=;
 b=TIBR4LhFvhdtGyHF0Os/bZ/V3MZae9ImKO0uvGdP+nuCNAwQ84k4Qvr8LDE6Y6iXClP0KCXAVaVsqBQBRXthx+KCZFeQqvN5tupxkCgN0deYywZ4qD4xzShxmpLYpMXF4UMT34WkCRyJbviWBB6khu3WTvUBvUytrWdJez2MkoeUaJg1EMAe2nTAIm2NtirM0qXEqUKtFYJaEL1/94GvzGVRkzNyu0Gw1GwljrqK6MydxSAnsRqzbQpuzOQNfLwcoU+HOHsGe+mIpljPBJFmJu9vhpDLkd2EQIq2mRWlhG1gTPQ9SxD2NaOdQ+an6RuljjueYvzed/4GztJ91+zANg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEZzhU1YSdjgHDhdHl0S5gF9goIaH9MMhc1x6L6cy48=;
 b=UmuGnuiWXF1XCgrdaalokYGhF01eWX33qClT/ew790i4VNSaHLVvJJt/lPU4/YP4jcXBhTsMqwOlXlykNJTt0e2kob6R2pP7ca0A+We+RNKEKpIRooOPivYSY2UI2LQq3nT2CiOiRGK2xC7vxZo8GkySCBNNhAcLSWz/uiIN330=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2391.namprd12.prod.outlook.com (2603:10b6:4:b3::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.20; Sat, 4 Apr 2020 21:57:48 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2878.017; Sat, 4 Apr 2020
 21:57:48 +0000
Date:   Sat, 4 Apr 2020 21:57:41 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org, brijesh.singh@amd.com
Subject: Re: [PATCH v6 14/14] KVM: x86: Add kexec support for SEV Live
 Migration.
Message-ID: <20200404215741.GA29918@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <0caf809845d2fdb1a1ec17955826df9777f502fb.1585548051.git.ashish.kalra@amd.com>
 <c5977ca2-2fbd-8c71-54dc-b978da05a16e@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5977ca2-2fbd-8c71-54dc-b978da05a16e@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM6PR14CA0069.namprd14.prod.outlook.com
 (2603:10b6:5:18f::46) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM6PR14CA0069.namprd14.prod.outlook.com (2603:10b6:5:18f::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Sat, 4 Apr 2020 21:57:47 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 19c904b7-9ce4-450d-e7d4-08d7d8e33681
X-MS-TrafficTypeDiagnostic: DM5PR12MB2391:|DM5PR12MB2391:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB23912B32BA7A13FAA150955E8EC40@DM5PR12MB2391.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-Forefront-PRVS: 03630A6A4A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(44832011)(33656002)(55016002)(956004)(5660300002)(478600001)(6916009)(6666004)(7416002)(33716001)(4326008)(86362001)(66476007)(66556008)(53546011)(1076003)(52116002)(316002)(2906002)(9686003)(66946007)(6496006)(8676002)(16526019)(186003)(26005)(8936002)(81156014)(81166006);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nQXOTK/ocJExhnQdShdtJNUWkL3XGoCAqIEvn0syAHrCSIWUawPul+UIG+fPvpA3UE+8F6atXxdex8QiQo1n4ZEOwWKkqhlDR2ssI6ztPbPYXoD1fPh3NA9qEqpgjp8Hz6ecqhecN3L1zFkscPsTpnVPB0j+ORWhzrDfibf7rMdT3h8OB3tq/vnGffYnZpHiwwE/1Pm+OYblGkFVjgr2RflP+9EhOIugfyn+Nw/okFx0tHsSUa9Cfjya2xZaBWGI0gSne7+KSGRLcnMTnut/J2G6na7pUbTXnskAECJNfvw5wj2l81kb7BkPj8FqF24InRdWNt0cdJEv2IrLHNTyfzN2+SarZywdfis4u8jFf0e8214OYX0JnE+xSiTHFzPUBcOHXL4WFCY7wLHY29RkCYvytSIQkyGuBJt8SF2miUjlYZRlELN1RGelOJPCAbK2
X-MS-Exchange-AntiSpam-MessageData: 6ERFoYR+Crjs2Qw5Q90js7SFX2eSWlPiwfRjK7T1CyRw+0jKDE9Rp/6VIFpEdg89ktaYMzllOm75n1PJwASWyK0EeCgDSK/8DVtsNFNADHzOU9aUszEKqCmV/bdo/xH176oFGcrKFMGrMZ9X+UQWlA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c904b7-9ce4-450d-e7d4-08d7d8e33681
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2020 21:57:48.3162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AGGx4KHFJwgD5NauRmoOz5FLRPIS/WWimLTNePQP+7yCxfS8uWe6PjnskzyxnUBCTC+A93ArG1wGovHMDVKOHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2391
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The host's page encryption bitmap is maintained for the guest to keep the encrypted/decrypted state 
of the guest pages, therefore we need to explicitly mark all shared pages as encrypted again before
rebooting into the new guest kernel.

On Fri, Apr 03, 2020 at 05:55:52PM -0700, Krish Sadhukhan wrote:
> 
> On 3/29/20 11:23 PM, Ashish Kalra wrote:
> > From: Ashish Kalra <ashish.kalra@amd.com>
> > 
> > Reset the host's page encryption bitmap related to kernel
> > specific page encryption status settings before we load a
> > new kernel by kexec. We cannot reset the complete
> > page encryption bitmap here as we need to retain the
> > UEFI/OVMF firmware specific settings.
> 
> 
> Can the commit message mention why host page encryption needs to be reset ?
> Since the theme of these patches is guest migration in-SEV context, it might
> be useful to mention why the host context comes in here.
> 
> > 
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >   arch/x86/kernel/kvm.c | 28 ++++++++++++++++++++++++++++
> >   1 file changed, 28 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 8fcee0b45231..ba6cce3c84af 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -34,6 +34,7 @@
> >   #include <asm/hypervisor.h>
> >   #include <asm/tlb.h>
> >   #include <asm/cpuidle_haltpoll.h>
> > +#include <asm/e820/api.h>
> >   static int kvmapf = 1;
> > @@ -357,6 +358,33 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
> >   	 */
> >   	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> >   		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
> > +	/*
> > +	 * Reset the host's page encryption bitmap related to kernel
> > +	 * specific page encryption status settings before we load a
> > +	 * new kernel by kexec. NOTE: We cannot reset the complete
> > +	 * page encryption bitmap here as we need to retain the
> > +	 * UEFI/OVMF firmware specific settings.
> > +	 */
> > +	if (kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION) &&
> > +		(smp_processor_id() == 0)) {
> > +		unsigned long nr_pages;
> > +		int i;
> > +
> > +		for (i = 0; i < e820_table->nr_entries; i++) {
> > +			struct e820_entry *entry = &e820_table->entries[i];
> > +			unsigned long start_pfn, end_pfn;
> > +
> > +			if (entry->type != E820_TYPE_RAM)
> > +				continue;
> > +
> > +			start_pfn = entry->addr >> PAGE_SHIFT;
> > +			end_pfn = (entry->addr + entry->size) >> PAGE_SHIFT;
> > +			nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
> > +
> > +			kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
> > +				entry->addr, nr_pages, 1);
> > +		}
> > +	}
> >   	kvm_pv_disable_apf();
> >   	kvm_disable_steal_time();
> >   }
