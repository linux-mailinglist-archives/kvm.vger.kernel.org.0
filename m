Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCCC1AC750
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 16:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394841AbgDPOxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 10:53:24 -0400
Received: from mail-bn8nam12on2083.outbound.protection.outlook.com ([40.107.237.83]:6051
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2409263AbgDPN5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 09:57:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kv8lRke9VMF+ZYQUNnYt4lPAd2IYWMSvInWxHVj1Tr6/i2V4zis325/rXZ2nbYcwgGV3Motcxu09MrEqWw94mBPEAhqnPcIlhDq6ALJjZ8RZq6DONZzivUdtNc53Komjxdg+GbbEAFA4S4C2X9u0in0IY6Ymj21DgBHriM6ffM6w358WEfZdYJ/+xQiAdABeTbPLOanR0Dccxs6ALFE1SKxijWdZXpKLLJFHkEZd/1erXU46VYzzLFQJQN71nT5ZOqDuePgPo0Ae6MGpk3PFIjdg4FfYADh1TW657fkpIpBCxBhwjTSEhq6oJkpmKkuR5Ig5TuuAZLTq1hqKWGXaBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+uxcJtdS18MDY1NC9DT6CVmBcNDt2kGXjY0DVaWNm88=;
 b=RZk7Y8C/PoMHqimMCEc6kbhYJcTojMpzV2yRUICvsKvLxvRQn9UB6oWCRqAjbUDzVSH6M2Jbd3BuZnh0I8erp7HEE8rFNH/MRwySGL4oAgTASt99JgPR9Axxe71e/N+4ZTuxNzp3HBQa8ye6FBU8s6bmU4LzLgaf98YFn8QvGPRKssGiwJ0dA2fyMWMjM/6IKlLRY3jxeIpEh5EI4rtiqFbttt99c6bctT3AGoh5QzZCmw2mW7us2UqIBbuTx67Wd/Sit6uMILpHEK0h94JdEYZI7DuHhZt/VaPM3O+JSHOSdTNTSLISaKSXLAPqCz0wcVT1nBRdu02bbXDvtuIVFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+uxcJtdS18MDY1NC9DT6CVmBcNDt2kGXjY0DVaWNm88=;
 b=CMDKQUmLRuAzU0z6b2zbGdcr4qjArUUadrBaOS/iHNK7qDC4ArxVbzHPerHh9NB58pP7KmcSUpPbL1P1wEmfpws79dYGYcbcQUqzHwrKMn/i9iRRlZBIDrbdwsi455Glh3yWrj3ybGagK9Hk71LJywF34J2hC1v9JvS+l9GM8aI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
 by DM6PR12MB3930.namprd12.prod.outlook.com (2603:10b6:5:1c9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17; Thu, 16 Apr
 2020 13:57:07 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733%7]) with mapi id 15.20.2900.028; Thu, 16 Apr 2020
 13:57:07 +0000
Subject: Re: [PATCH] KVM: SVM: fix compilation with modular PSP and
 non-modular KVM
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     ubizjak@gmail.com
References: <20200413075032.5546-1-pbonzini@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <d8cab90f-8c9c-7f79-0913-ba0d8576206d@amd.com>
Date:   Thu, 16 Apr 2020 08:57:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200413075032.5546-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0052.prod.exchangelabs.com (2603:10b6:800::20) To
 DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN2PR01CA0052.prod.exchangelabs.com (2603:10b6:800::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Thu, 16 Apr 2020 13:57:06 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9a38daea-571f-4620-85c1-08d7e20e0ce7
X-MS-TrafficTypeDiagnostic: DM6PR12MB3930:
X-Microsoft-Antispam-PRVS: <DM6PR12MB393031E0E01544C4F0AABAB9ECD80@DM6PR12MB3930.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0375972289
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(66476007)(5660300002)(31686004)(6486002)(8676002)(81156014)(2906002)(478600001)(66556008)(8936002)(66946007)(186003)(52116002)(36756003)(86362001)(6506007)(16526019)(6512007)(2616005)(26005)(4326008)(53546011)(31696002)(956004)(316002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5R7J4sC3uJfPl3FiqnmxbeMRy7Xj2fGzAUBWG4+lOyv0PXs7wcntbCud4p79VBMl6J+TcnFqvc7EBnSEuyfLEPxS8GvkFCgqxJ2D6awpHYN1Y1jBBZPTuFvzkwT+i8cwvYSObeTFCUhcQjshi+9mFXw5bLTwXZzW+ZT5mTg2rIcazpM84o75vKANLgLzQ+SfJy3EG83gUNvHRh9Jq+IY7UaSVxuOwsjs91c0xX95ghRWrTcoOhqQKzosX9iBtOBLWRzMe0gHMLo2yXLeZvDQvdG1YPryX7eYsQ4kZEH9cBvEkK8mbXRWo8kISXfR+AUjNcwxSh6clVMYM31q/jrkIYYr2tphwQIwaVwfDRVIUmJXWWsVMG1axuMELPScSuVkj5l0hTA2AeG4eB3DYyP2eJvy6WxFwOdlwI1X25qC3u7+KLIRgVbKmx2SsPL5QHTf
X-MS-Exchange-AntiSpam-MessageData: mNJER00r4xKmVEXq2twWvOz1J1d5pxH/3RJBTbPBfru5S6RA0x/P9YemXuLkuWEvjBFFJhetUnydnFNxnj0WGpk3GC9ivrnNcvKQnBypX7xbnw7jxH5cs7N/9T3Z+iY0OgSRGhhFOk2uLmlGP+1MbA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a38daea-571f-4620-85c1-08d7e20e0ce7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2020 13:57:07.4131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LmEMOgCJkNlO1swvVpH1PH14ZKpk1OiKWYdEwA+VpOnX+nCpJX3+0E5VPDAZAj8PpbD4vzMLS9qAAjPSt9KUEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3930
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/13/20 2:50 AM, Paolo Bonzini wrote:
> Use svm_sev_enabled() in order to cull all calls to PSP code.  Otherwise,
> compilation fails with undefined symbols if the PSP device driver is compiled
> as a module and KVM is not.

The Kconfig support will set CONFIG_KVM_AMD_SEV to "n" in this situation, 
so it might be worth seeing if sev.o could be removed from the build at 
that point. I'll try and look at that when I get a chance, but I'm 
currently buried with a ton of other work.

> 
> Reported-by: Uros Bizjak <ubizjak@gmail.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/svm/sev.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0e3fc311d7da..364ffe32139c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1117,7 +1117,7 @@ int __init sev_hardware_setup(void)
>   	/* Maximum number of encrypted guests supported simultaneously */
>   	max_sev_asid = cpuid_ecx(0x8000001F);
>   
> -	if (!max_sev_asid)
> +        if (!svm_sev_enabled())

It looks like these are spaces instead of tabs, could just be my email 
veiwer, though.

>   		return 1;
>   
>   	/* Minimum ASID value that should be used for SEV guest */
> @@ -1156,6 +1156,9 @@ int __init sev_hardware_setup(void)
>   
>   void sev_hardware_teardown(void)
>   {
> +        if (!svm_sev_enabled())
> +                return;
> +

Ditto on the spaces/tabs thing, here.

Thanks,
Tom

>   	bitmap_free(sev_asid_bitmap);
>   	bitmap_free(sev_reclaim_asid_bitmap);
>   
> 
