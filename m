Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B70A019818E
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 18:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgC3Qpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 12:45:32 -0400
Received: from mail-dm6nam11on2068.outbound.protection.outlook.com ([40.107.223.68]:6057
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727148AbgC3Qpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 12:45:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqRS6Tt7KwyP5K+STstxwJLodNmph9aiEO5+10UwvL4w4Yle84gGeSsCASSzx3Iv61HbbqP6zZEuL34ridnS9vURFUzIIOQBRcq9CJDJY0lmrla6iD07IT9pErvYof/CQua/dUieaQ98s917G7Iik3W1WpD/SvYdj4OVU89J+vrwxE7PfvS1p0wZjXJpbbpCR4YS8/YAVnMSxPZWPLNa57kqadrN5Z0yEeThZ7eCVApPd1xPuA+6L8Az/AFe2iSa5CG2klQqChMKz1KgqCWdjZU4BSLz3Ek2il/+1MszYbJP/Ooat3gcIDKcBp1jNB0xP05GwU7tYWFbzI4nOWI/Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pebW3a3a7FPq1wYv/UbdudCuSofgEzJpSv+WDdLzXLg=;
 b=gPj/QJzLgKc+iOzr7VHboXii6Hm0WrBXRNXfk8y7ee1Bpu8L8b/ZMMsQyGZRcREkT5FzpecT7hZN+8zol6Mf8mIAFE49sVsW2fmjKSKPKFWGZK5qRgXTX/hoI3NSpeaZ7qTqMsAxR9fVxFw/95XRbGcULmrNBbceDwRlDMpK8+wtoYrrC9MvjTsvLslURNiiCXlUlupBU5nZKBlE2JzNjIVX6kfhO+gTbcJmRiEwx6aIBJxOxf3JONhI1Fo7Lbn7FkUadjc8Etp+DkCqb1prIyN+QtAoFf8yhzokhIAKaAeGWXSrHsI6ZqEaqz97lKWxjgNT4U1s5bS3CWOuyKCCKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pebW3a3a7FPq1wYv/UbdudCuSofgEzJpSv+WDdLzXLg=;
 b=kmKwomQKKCihVvOya5mgzmFM4RNyxqv/gxGDXmMjZNUoyFCIYrkB1HhqJl+KsGEWTMdpFAByCGoE7jPs3OaRTUNOgbZA/D6xDp8i511qXvehM1y/B5XoFrAkaTDBvplhn4NNAfOZzMEbcHqGFqdHBKK7KK23YW43YZv/wIr4OY4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2501.namprd12.prod.outlook.com (2603:10b6:4:b4::34) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 16:45:28 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 16:45:28 +0000
Date:   Mon, 30 Mar 2020 16:45:25 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org
Subject: Re: [PATCH v6 14/14] KVM: x86: Add kexec support for SEV Live
 Migration.
Message-ID: <20200330164525.GB21601@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <0caf809845d2fdb1a1ec17955826df9777f502fb.1585548051.git.ashish.kalra@amd.com>
 <95d6d6e3-21d5-17c3-a0a5-dc0bac6d87ca@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95d6d6e3-21d5-17c3-a0a5-dc0bac6d87ca@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM6PR02CA0053.namprd02.prod.outlook.com
 (2603:10b6:5:177::30) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM6PR02CA0053.namprd02.prod.outlook.com (2603:10b6:5:177::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 16:45:27 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d41deda0-9aa5-4648-674b-08d7d4c9c0a3
X-MS-TrafficTypeDiagnostic: DM5PR12MB2501:|DM5PR12MB2501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2501F94C15E4739AAB0E1CE88ECB0@DM5PR12MB2501.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(6636002)(7416002)(33716001)(478600001)(81166006)(81156014)(26005)(8676002)(86362001)(16526019)(8936002)(186003)(1076003)(44832011)(956004)(6496006)(53546011)(2906002)(316002)(66946007)(55016002)(66476007)(9686003)(66556008)(4326008)(5660300002)(52116002)(6862004)(33656002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3bW7PWyS3rbJ489KqXdZyMrNiSg1VS7YuZiCugtjhAobdVPx1S5+MpOTmeyBzcjT9YehVOsM1LGYsUo1oyORbN7LDwjMc7/z0+HywTEEjvGXI6W+b6juWZP7pMY5LcFqPczcWs0UQaKzR9jMHtN6+rabezSUqyf/yhmroUuSRi+bvjWFmfVAzseMds9eB2V+1BI92Ze4/qRfcP6pQBrk5BZ4lZHC8ns38FcDlv1QD9habjNPmDlOe0c60CFlcv883j0qLxgeCjAQNCnc7kfbX+TBNoEpcsBijqZpr7iRJWOvCJFuO6yOY+EiuHKGvZVctsiEFqbRIE0RylhbMeuLU4aIU76KTmhmidj2/eftDsJhT2+e7dLCIV3/yLAtuX1TfC5DDvYktkkWQVi5Ny65jZHIUTyUwDV+1UH+HfrQ6krjKHPAtnSDmT6Mc0EuqFBg
X-MS-Exchange-AntiSpam-MessageData: TVK4CiZgWbSf10Df//7wzcqz6auZcc9tjtRulZPHwkYP+yVUSxDnAWsT4am6jNrGFSFghYp+wxbe0KPhIdBsXFA/IVHxJDnq0faRGxwPJWVYgwnBKArmkaB5m0CocCZWfDV+1JDPbaCet/NgueZMGA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d41deda0-9aa5-4648-674b-08d7d4c9c0a3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 16:45:28.4872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jdGDlgV7wXBuclpQ77Cctdy5hDC+dIC0C1yT+NTHXbJ+sWWBirtivAamBaV8ysnTO1E8X4089VjEB1fqgAiN/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2501
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Brijesh,

On Mon, Mar 30, 2020 at 11:00:14AM -0500, Brijesh Singh wrote:
> 
> On 3/30/20 1:23 AM, Ashish Kalra wrote:
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > Reset the host's page encryption bitmap related to kernel
> > specific page encryption status settings before we load a
> > new kernel by kexec. We cannot reset the complete
> > page encryption bitmap here as we need to retain the
> > UEFI/OVMF firmware specific settings.
> >
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  arch/x86/kernel/kvm.c | 28 ++++++++++++++++++++++++++++
> >  1 file changed, 28 insertions(+)
> >
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 8fcee0b45231..ba6cce3c84af 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -34,6 +34,7 @@
> >  #include <asm/hypervisor.h>
> >  #include <asm/tlb.h>
> >  #include <asm/cpuidle_haltpoll.h>
> > +#include <asm/e820/api.h>
> >  
> >  static int kvmapf = 1;
> >  
> > @@ -357,6 +358,33 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
> >  	 */
> >  	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> >  		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
> > +	/*
> > +	 * Reset the host's page encryption bitmap related to kernel
> > +	 * specific page encryption status settings before we load a
> > +	 * new kernel by kexec. NOTE: We cannot reset the complete
> > +	 * page encryption bitmap here as we need to retain the
> > +	 * UEFI/OVMF firmware specific settings.
> > +	 */
> > +	if (kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION) &&
> > +		(smp_processor_id() == 0)) {
> 
> 
> In patch 13/14, the KVM_FEATURE_SEV_LIVE_MIGRATION is set
> unconditionally and because of that now the below code will be executed
> on non-SEV guest. IMO, this feature must be cleared for non-SEV guest to
> avoid making unnecessary hypercall's.
> 
>

I will additionally add a sev_active() check here to ensure that we don't make the unnecassary hypercalls on non-SEV guests.

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
> >  	kvm_pv_disable_apf();
> >  	kvm_disable_steal_time();
> >  }

Thanks,
Ashish
