Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3605119804E
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 17:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgC3P6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 11:58:47 -0400
Received: from mail-co1nam11on2087.outbound.protection.outlook.com ([40.107.220.87]:46088
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726497AbgC3P6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 11:58:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XaDN8a8c9dwQtf8C9+Ni3kwn9LvObOmSaZ18dnuDSWVwLRVXccQa6i16BCi7urNno7ymnjqQK2109WlTiqspgKxNgVUa5ASwealurC4oAHaNg4w3CgJuKYBH7Spwb2jlStcatNTz11yuf4zTd1NwbzTmyLSQp/Y1VBqtcmlHEgfU0rvRpFerYUjjIdQbJIPgUp7T0VZBLy3ThmHA88dKdYtEAyP7ViwMl8CVfD1VtSzkPOIGqWVwLTu3d1h9WHdG9TGqP9E+DGTaPeIHnOANh6z8Bxspkkx+sD6vRbazWzFPcqVLuHO2OeZFU8fpgD3xMTVOxmKu9wAq5+u9NgPMUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2AQ6sG5Z6R9bUGNf32OXilfz65NnmNmFO6yIPgxDR64=;
 b=OpP1zerXHz6jWKSHw1eQ+kuDCZkLgar+kaeSe+dngN+bI9ZQ9qx1tBX/iz154r/GRClZ19sM31hgvuOSjQZFRLpLvaF9exVEWi8IZpwzWm3NzkgL19oF5VtYaKZmhVWnNYpNnIx2mqqFikmkyy1dxZN6VAVKyD/qu8tbnbEMCsZcIrf7dibWTBctNBGm1Lio0kxtUBmgIY9ehcnuH5l4+TrLnYitFBAvbKzx58tsgDrdiPxMIJBN/3BQcgbzlqjinJ3aoFbRjcWLHZ2wb7XCTs8b3xCzkGV/jtI1Qle8ly655oXw8s1XArOOh3zJa8prGtZP7xPEb4EULF2MU+5DPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2AQ6sG5Z6R9bUGNf32OXilfz65NnmNmFO6yIPgxDR64=;
 b=sP6sbF/nlUpe5hGWITxIqlOLu51JAmzfPuwNmEJ+CZk9qB4jwNW+6n6MYSW8w6FTZO0OofUvvcUHVPsNUg2wHVKtCRXGRLAKpI2QsdtPK3oOxTpcmKgsM3/DOR7FK6h4e9A3COdxwjuk5n9xqEzC2yNONvvpNk0ZzJV9bHH/SPg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13)
 by SA0PR12MB4525.namprd12.prod.outlook.com (2603:10b6:806:92::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Mon, 30 Mar
 2020 15:58:32 +0000
Received: from SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::60d9:da58:71b4:35f3]) by SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::60d9:da58:71b4:35f3%7]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 15:58:32 +0000
Cc:     brijesh.singh@amd.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org
Subject: Re: [PATCH v6 14/14] KVM: x86: Add kexec support for SEV Live
 Migration.
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <0caf809845d2fdb1a1ec17955826df9777f502fb.1585548051.git.ashish.kalra@amd.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <95d6d6e3-21d5-17c3-a0a5-dc0bac6d87ca@amd.com>
Date:   Mon, 30 Mar 2020 11:00:14 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <0caf809845d2fdb1a1ec17955826df9777f502fb.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0701CA0042.namprd07.prod.outlook.com
 (2603:10b6:803:2d::16) To SA0PR12MB4400.namprd12.prod.outlook.com
 (2603:10b6:806:95::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0701CA0042.namprd07.prod.outlook.com (2603:10b6:803:2d::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Mon, 30 Mar 2020 15:58:31 +0000
X-Originating-IP: [70.112.153.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 354852f2-21e0-4d3d-1c3f-08d7d4c33220
X-MS-TrafficTypeDiagnostic: SA0PR12MB4525:|SA0PR12MB4525:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4525E7D418855DBB55DBEAFBE5CB0@SA0PR12MB4525.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(36756003)(6506007)(6512007)(6486002)(31696002)(81166006)(8676002)(478600001)(31686004)(2906002)(86362001)(81156014)(316002)(7416002)(6666004)(5660300002)(52116002)(53546011)(66946007)(8936002)(44832011)(16526019)(186003)(26005)(4326008)(66556008)(2616005)(956004)(66476007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mgJxNrHSVyTAj7q1FnfKf27XRWvilUGXWkA5jgOMg8RXYIKdoX/Kl72pihrhjMhhzyrv0x4X7cNwLxZ109iQKX2QDiM99ycfLENGu1BPBUZMrcNNf0V71hfs5ea1HhmIgtteWrNHC9Rway1lkrh87fy/2Jd3wPYkTi9d75+iM6dqxrl8tPamBOwQBrfMMYVko8elhPQUh1AEVAv2mjHPkpfrAHajyk0nxpdjbdN7oKgfdAOH2N1LZqDCVJbj8BzPZ5nROYisdsrmtXkH8liMRuVsjI4jtGf7vensHJJYHs9uwsFwIDXkuoMhUc17uw479+NuMOh7MYYOzwLTcUoD7MZU/wR3trie1kSiHbba+UkPB5P4fZpfyWbUpLedHmIr1QZnwBsYMB1pgtmowGxtCbV0nDtwKYeBqltuTee3EH0Me8159ZZ83y5s2qn0Xf6k
X-MS-Exchange-AntiSpam-MessageData: fqkL9itcBq42SMCJk5QgM3nTrtdbmHZpRTi/JMyE0OW+ZwBixTxZLk54rQXR/4ACRvEhXxNJbE8F5m3wjuX4BZswg2bzfapLPsEVcYXBolKAqPR8dVY6NIk/dJnsDk1l2/19q9JzVZz0Tiz3xs01CA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 354852f2-21e0-4d3d-1c3f-08d7d4c33220
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 15:58:32.2334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1bop3KTD6kbqLqcyo1gVpw2N7YUNOM6Hhkd4dMNwW6IzUb1kTwop23rfP+Vvmv0W8CvORNUBupJWJbHrGJAHBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4525
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/30/20 1:23 AM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Reset the host's page encryption bitmap related to kernel
> specific page encryption status settings before we load a
> new kernel by kexec. We cannot reset the complete
> page encryption bitmap here as we need to retain the
> UEFI/OVMF firmware specific settings.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kernel/kvm.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 8fcee0b45231..ba6cce3c84af 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -34,6 +34,7 @@
>  #include <asm/hypervisor.h>
>  #include <asm/tlb.h>
>  #include <asm/cpuidle_haltpoll.h>
> +#include <asm/e820/api.h>
>  
>  static int kvmapf = 1;
>  
> @@ -357,6 +358,33 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
>  	 */
>  	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
>  		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
> +	/*
> +	 * Reset the host's page encryption bitmap related to kernel
> +	 * specific page encryption status settings before we load a
> +	 * new kernel by kexec. NOTE: We cannot reset the complete
> +	 * page encryption bitmap here as we need to retain the
> +	 * UEFI/OVMF firmware specific settings.
> +	 */
> +	if (kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION) &&
> +		(smp_processor_id() == 0)) {


In patch 13/14, the KVM_FEATURE_SEV_LIVE_MIGRATION is set
unconditionally and because of that now the below code will be executed
on non-SEV guest. IMO, this feature must be cleared for non-SEV guest to
avoid making unnecessary hypercall's.


> +		unsigned long nr_pages;
> +		int i;
> +
> +		for (i = 0; i < e820_table->nr_entries; i++) {
> +			struct e820_entry *entry = &e820_table->entries[i];
> +			unsigned long start_pfn, end_pfn;
> +
> +			if (entry->type != E820_TYPE_RAM)
> +				continue;
> +
> +			start_pfn = entry->addr >> PAGE_SHIFT;
> +			end_pfn = (entry->addr + entry->size) >> PAGE_SHIFT;
> +			nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
> +
> +			kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
> +				entry->addr, nr_pages, 1);
> +		}
> +	}
>  	kvm_pv_disable_apf();
>  	kvm_disable_steal_time();
>  }
