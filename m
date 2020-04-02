Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6320419CD84
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 01:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390210AbgDBXec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 19:34:32 -0400
Received: from mail-dm6nam12on2062.outbound.protection.outlook.com ([40.107.243.62]:6077
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390178AbgDBXeb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 19:34:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gREOa1lG1lvB90Nk1kIOpWHfLlVBWJa4sTs/+RQzTXqrd5O+L/NztPCi1Z51WXiJgU04VF+ajjmkHPUKIC4r33SrjO/QTwIyIjBxdSuvorv9lG3xHSgMWZBYeHsChSaoT+LaFOehYzPgdyych3ZehTQ9H+fAHGpD5mgfDoBOQHrENNwRlNnHYJoDLxy7VU7QKg2h4wCoIo/Gcaz3fvMVduEa1shpOizhCB1CQOsXhH7KLbpfilsaSg/rUyp7E1zN1gft0dDLBlqikAYivhQcoiizF6YxLdghkOtMFUG8XMJ7LUNdqx8w3LP8skaSDk09zk52Z7GYCWufryiU6tHurQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOcS/4HS/IFhZ3b88VNO5tvwKsNdxyrNR843bvQ7r2I=;
 b=RSz/lNjfMSByrO744j/WMozc1i2DMcrnR+CNwaDgMoxbZUTlVe+uBNuSqBLkzgsdFCrCyW0IOCPdwg7pKx6WGsqgyykd2veoVNBVf3gRlB0fdCYgluZ7IcDCKh3ltikZbfTbpMC17foJJg/nUnWVOD6qM1A0fPzPEsaF7JjkysJ+zpr5gt4IMmct+JvF+qfncw702Ezmh4pJi51bHij/dNjYOEdbni2E2I9JjmxEvPl0mIgqEK/0isZ/Cr8DwxTRsFSW5ixnKW+OFV4qJ6BvdwhSDIdj4C+Xy65nZLzAeRdvacYevSAWy1oayJlYtLKu7+6ZqYBhbg/ehwiDPOF/zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOcS/4HS/IFhZ3b88VNO5tvwKsNdxyrNR843bvQ7r2I=;
 b=mAWYfzqaShxIhp4mEZV7dAwJN2OjAKJMsFXvO8gXeBvTyoclN6P/2cPJeFNgvKSF5zLmb8CRCeoQ0229OgT1mCdSIsk/wQW5J9eJqX4yKzaruGrwBQskJtBSdd+bT7zEulFKgPoSrIOUafk++2YE7rRHGVxNHVIA3ptGgIAZU7s=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1468.namprd12.prod.outlook.com (2603:10b6:4:10::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Thu, 2 Apr 2020 23:34:25 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2878.017; Thu, 2 Apr 2020
 23:34:25 +0000
Date:   Thu, 2 Apr 2020 23:34:20 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org
Subject: Re: [PATCH v6 14/14] KVM: x86: Add kexec support for SEV Live
 Migration.
Message-ID: <20200402233419.GA25861@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <0caf809845d2fdb1a1ec17955826df9777f502fb.1585548051.git.ashish.kalra@amd.com>
 <95d6d6e3-21d5-17c3-a0a5-dc0bac6d87ca@amd.com>
 <20200330164525.GB21601@ashkalra_ubuntu_server>
 <3dccbcc9-c9b9-c98a-357a-dafde04984f6@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3dccbcc9-c9b9-c98a-357a-dafde04984f6@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM5PR07CA0072.namprd07.prod.outlook.com
 (2603:10b6:4:ad::37) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR07CA0072.namprd07.prod.outlook.com (2603:10b6:4:ad::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Thu, 2 Apr 2020 23:34:24 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0bf19ea8-3304-43d7-4b30-08d7d75e6151
X-MS-TrafficTypeDiagnostic: DM5PR12MB1468:|DM5PR12MB1468:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB14688449FB74CF73C10743C88EC60@DM5PR12MB1468.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0361212EA8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(39860400002)(396003)(346002)(136003)(366004)(6636002)(4326008)(86362001)(52116002)(1076003)(53546011)(16526019)(6862004)(33716001)(6666004)(6496006)(5660300002)(186003)(7416002)(66946007)(44832011)(81166006)(81156014)(316002)(26005)(8676002)(9686003)(8936002)(66556008)(66476007)(33656002)(956004)(2906002)(55016002)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Mjhm8Z2PzaXmlNzJ+2innkUjHensB3YbXf/Wujt6HWB1ubQ5SvhgJ3NTcW7qw2EPDBODYreqHf0VAA7rd0X2KH50XoPraU8T2fjU+TsQmnRQsk9gw1c+hGMlwVopaxtaCrEayoC5emk9hDd17Id6okdDLanDy4scyQGj4zE2OWKTpF/crZ+oHxkfvOUOBdG145wk1hjg2wZOtDUQ+rwYlflBtC1PkJ/7Bj4DY/XUb3fjcMTltUYVI4DqAh+Uh9fQBq0H/oxhCn5AA5SWZRM9XPPPgLR5yOABNZAFbVK+TMs6qGu7BjkeabqGzye3kLnqQROC/oHMierPJAWN4xxrW26RyDxKtcPFiAAtmbmJsj88U90xU+PMai7up8CM74wkhNwncEv/kMoHJsFGPHc9CobbarrcGGWmfuBkMJSQJo/DupOdCqlOPnXV3dXfTVo
X-MS-Exchange-AntiSpam-MessageData: AsMRGHaCGQPr7jH026rYuYySFbKnkcREawr1PagkeAmZbgL5p8+P6ycUjzI9zE+XDb9HjBZsTlsLelvLvswky+zIK+G9tjDrh/WoI/ei5fm43d3+5fnDHUkQ6ZzdMBlxLe9yn5iHwb6UKhATvZ3kAQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf19ea8-3304-43d7-4b30-08d7d75e6151
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2020 23:34:25.7848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AltN345Wn7SJBvrLnZMJAcdQtAgb2dawX6K1nv78kx6x+Dzv06ruOh9llHWXqtA/Tg5honniYg6hXb84Yf5xkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1468
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Brijesh,

On Tue, Mar 31, 2020 at 09:26:26AM -0500, Brijesh Singh wrote:
> 
> On 3/30/20 11:45 AM, Ashish Kalra wrote:
> > Hello Brijesh,
> >
> > On Mon, Mar 30, 2020 at 11:00:14AM -0500, Brijesh Singh wrote:
> >> On 3/30/20 1:23 AM, Ashish Kalra wrote:
> >>> From: Ashish Kalra <ashish.kalra@amd.com>
> >>>
> >>> Reset the host's page encryption bitmap related to kernel
> >>> specific page encryption status settings before we load a
> >>> new kernel by kexec. We cannot reset the complete
> >>> page encryption bitmap here as we need to retain the
> >>> UEFI/OVMF firmware specific settings.
> >>>
> >>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> >>> ---
> >>>  arch/x86/kernel/kvm.c | 28 ++++++++++++++++++++++++++++
> >>>  1 file changed, 28 insertions(+)
> >>>
> >>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> >>> index 8fcee0b45231..ba6cce3c84af 100644
> >>> --- a/arch/x86/kernel/kvm.c
> >>> +++ b/arch/x86/kernel/kvm.c
> >>> @@ -34,6 +34,7 @@
> >>>  #include <asm/hypervisor.h>
> >>>  #include <asm/tlb.h>
> >>>  #include <asm/cpuidle_haltpoll.h>
> >>> +#include <asm/e820/api.h>
> >>>  
> >>>  static int kvmapf = 1;
> >>>  
> >>> @@ -357,6 +358,33 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
> >>>  	 */
> >>>  	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> >>>  		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
> >>> +	/*
> >>> +	 * Reset the host's page encryption bitmap related to kernel
> >>> +	 * specific page encryption status settings before we load a
> >>> +	 * new kernel by kexec. NOTE: We cannot reset the complete
> >>> +	 * page encryption bitmap here as we need to retain the
> >>> +	 * UEFI/OVMF firmware specific settings.
> >>> +	 */
> >>> +	if (kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION) &&
> >>> +		(smp_processor_id() == 0)) {
> >>
> >> In patch 13/14, the KVM_FEATURE_SEV_LIVE_MIGRATION is set
> >> unconditionally and because of that now the below code will be executed
> >> on non-SEV guest. IMO, this feature must be cleared for non-SEV guest to
> >> avoid making unnecessary hypercall's.
> >>
> >>
> > I will additionally add a sev_active() check here to ensure that we don't make the unnecassary hypercalls on non-SEV guests.
> 
> 
> IMO, instead of using the sev_active() we should make sure that the
> feature is not enabled when SEV is not active.
> 

Yes, now the KVM_FEATURE_SEV_LIVE_MIGRATION feature is enabled
dynamically in svm_cpuid_update() after it gets called from
svm_launch_finish(), which ensures that it only gets set when a SEV
guest is active.

Thanks,
Ashish

> 
> >>> +		unsigned long nr_pages;
> >>> +		int i;
> >>> +
> >>> +		for (i = 0; i < e820_table->nr_entries; i++) {
> >>> +			struct e820_entry *entry = &e820_table->entries[i];
> >>> +			unsigned long start_pfn, end_pfn;
> >>> +
> >>> +			if (entry->type != E820_TYPE_RAM)
> >>> +				continue;
> >>> +
> >>> +			start_pfn = entry->addr >> PAGE_SHIFT;
> >>> +			end_pfn = (entry->addr + entry->size) >> PAGE_SHIFT;
> >>> +			nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
> >>> +
> >>> +			kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
> >>> +				entry->addr, nr_pages, 1);
> >>> +		}
> >>> +	}
> >>>  	kvm_pv_disable_apf();
> >>>  	kvm_disable_steal_time();
> >>>  }
> > Thanks,
> > Ashish
