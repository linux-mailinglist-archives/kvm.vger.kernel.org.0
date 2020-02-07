Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 614E6155B00
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 16:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgBGPtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 10:49:43 -0500
Received: from mail-bn8nam12on2083.outbound.protection.outlook.com ([40.107.237.83]:23518
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726874AbgBGPtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 10:49:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bB6Af1K1+WLuDqcKaKzaO4EWk+EXqNYGhlBzRzpRu0XToMjmSLs20e8bUJy1UgRbb58ZvSRzub4z2WALu6j8hoTLtdQcI5OEegip4AiC/m8HQ4ehfXnuYdaBNmjjWbaLB+3OAKCTIAoREYI/oOdsvgLKWJaW8krfTh9w1jCpUbE/BezhhHIZbIKlzOFUUkW5/yNuECTmrK0GBIKiXTJZMi8S0X3SOjgdgyUMwF7T8yuxe0euww52bw+bPtG7WeuJl2MY4mrTk6+qgsQ+PzpR98ovXGqtziUUNHZ7eianI4OUQewXZk/zvLO9Z6QQGGwXGw+z14p4qaoIh8FeU6EOww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FrPbTT8UM/dooNdpWttwq8p2PT6EKWTaxeV4RQ9oVeQ=;
 b=Z+UEOulL/UJUnha7i8dXbZqdMgsUg0b0SMiUcnZHDSeZpjpjOA2MAje849p4R4Oiqpn1uy34laEG3yHgqiT4RU4r4yoVROWg7eQGgM09RgkkPepSNrY7pYYKD9MgDWCUyGSWMJpnP1eolKQmTVf2qRddkQk48mqnBQoscmfUEk3DoCYobA9C2qFmm2dP/d2Gh/J3XFo55CJyRz8y0Cnd2o55CIqsI5eA192gBFvsX86kryLvpzADpG155GLqlAEFstLdu8ViMPTep4xShNeU215FoxQXSs8qC05NwK6DWxnj8jm76DZd/Q1AnZpTCkoJfbiiDTpipaAdx3dt+HrOnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FrPbTT8UM/dooNdpWttwq8p2PT6EKWTaxeV4RQ9oVeQ=;
 b=tX/obtMYNXGRd0DNq5k3TVT39PlPmlgdE0bTB4bzqIKYtQlrVudUfoohOOPAE0bAuUjo/vJ6qLpYZAsX31Vy0v1OQWrffUT6QVYGMz4/S8pgBsu/NVwVg/YVKxhcadh+e++OPZOgiwGZV/8LF2b9JA7gEIAyl8unOP3JhAZB0jU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Wei.Huang2@amd.com; 
Received: from CH2PR12MB3991.namprd12.prod.outlook.com (52.132.247.26) by
 CH2PR12MB4214.namprd12.prod.outlook.com (20.180.7.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Fri, 7 Feb 2020 15:49:41 +0000
Received: from CH2PR12MB3991.namprd12.prod.outlook.com
 ([fe80::5559:35b0:5478:1892]) by CH2PR12MB3991.namprd12.prod.outlook.com
 ([fe80::5559:35b0:5478:1892%6]) with mapi id 15.20.2707.024; Fri, 7 Feb 2020
 15:49:41 +0000
Subject: Re: [PATCH v3 2/3] selftests: KVM: AMD Nested test infrastructure
To:     Auger Eric <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        thuth@redhat.com, drjones@redhat.com
References: <20200204150040.2465-1-eric.auger@redhat.com>
 <20200204150040.2465-3-eric.auger@redhat.com>
 <20200206181521.GD2465308@weiserver.amd.com>
 <88fe7667-17ab-6856-0e99-7106454b9de4@redhat.com>
From:   Wei Huang <wei.huang2@amd.com>
Message-ID: <c4af40ab-3ad3-ace1-36dc-44e2613a6bbb@amd.com>
Date:   Fri, 7 Feb 2020 09:49:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
In-Reply-To: <88fe7667-17ab-6856-0e99-7106454b9de4@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0067.namprd12.prod.outlook.com
 (2603:10b6:802:20::38) To CH2PR12MB3991.namprd12.prod.outlook.com
 (2603:10b6:610:2f::26)
MIME-Version: 1.0
Received: from [10.236.30.248] (165.204.77.1) by SN1PR12CA0067.namprd12.prod.outlook.com (2603:10b6:802:20::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Fri, 7 Feb 2020 15:49:40 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c2df4efb-8d7d-48c8-560d-08d7abe55845
X-MS-TrafficTypeDiagnostic: CH2PR12MB4214:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4214A11A241FA7F6A7EE508DCF1C0@CH2PR12MB4214.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-Forefront-PRVS: 0306EE2ED4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(346002)(396003)(136003)(376002)(189003)(199004)(2616005)(956004)(186003)(66946007)(16526019)(31686004)(8936002)(81166006)(8676002)(81156014)(316002)(16576012)(26005)(36756003)(5660300002)(2906002)(31696002)(86362001)(478600001)(4326008)(53546011)(52116002)(6486002)(6916009)(66476007)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR12MB4214;H:CH2PR12MB3991.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RErujJYLHRb2ZOZYTYjTcUQifsZQay4e4LNlnKz+6QOG6lx/Nla7NFgquGeGpoJsSjQ/72i776cdnoQrRFp6Hs/P9vQWJjOhogwNl6FYZnxp1kU3/OaTfP8tDCf84iS56nN9VE6m6DVC09FiaJKh9387xiEFG2fa8Cv107ATuQZmss1XnSrXsn7cA7XoFUR9ViX2trFAbktJP98PXshQ5Rk5cUp1+0PXhq18glMMMwDfxoSXddRxT9U4wl1oYDodxyYR4R78Xn8CN2VYnF9MosMkNQh/MmXc7Zbr/muDNvURSvIgQv83fl3jJlv/Qjkr4L+pK8QO8vrkKKJ3ByHPDF3pDQ4n6Bo3XzzIPEj4GazS7OOzDEc4sZD2iuHMvbDvpnbwKBpxs8X9eGp2bxfgkTE2+x9OfUXSiAG92ZHFJ75A/iB7FneYtuvUaGjBCrfK
X-MS-Exchange-AntiSpam-MessageData: vHp3CGUiHwqc0l0iK0xfDgNufYYmWFLcnlZDZVO7lD5ZfzdX0Dsglnzu1vDxNmlCGNmwxq3UIHx+IplUUiKHXe2csJDogiveFLSt0CjAccilAv61lKwyI6ae1Sp4czzQH0t6P3qQpWlqaBhXhQdWwA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2df4efb-8d7d-48c8-560d-08d7abe55845
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2020 15:49:41.4403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G4qK+A2L/FBR6iPHnttq3/GUmPGZM1wIcrsrvF+XyGiEnKvYyLBF6zdEvetKwer4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4214
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/7/20 3:53 AM, Auger Eric wrote:
[snip]
>>> +
>>> +#define	SVM_EXITINTINFO_TYPE_INTR SVM_EVTINJ_TYPE_INTR
>>> +#define	SVM_EXITINTINFO_TYPE_NMI SVM_EVTINJ_TYPE_NMI
>>> +#define	SVM_EXITINTINFO_TYPE_EXEPT SVM_EVTINJ_TYPE_EXEPT
>>> +#define	SVM_EXITINTINFO_TYPE_SOFT SVM_EVTINJ_TYPE_SOFT
>>           ^^^^^^
>> TAB instead of SPACE
> 
> as written in the history log (but I think I will add this to the commit
> msg too), this file is an exact copy of arch/x86/include/asm/svm.h
> (except the header includer #ifdef + uapi/asm/svm.h header inclusion. So
> it inherits the style issue of its parent ;-)
>>
>>> +
>>> +#define SVM_EXITINTINFO_VALID SVM_EVTINJ_VALID
>>> +#define SVM_EXITINTINFO_VALID_ERR SVM_EVTINJ_VALID_ERR
>>> +
>>> +#define SVM_EXITINFOSHIFT_TS_REASON_IRET 36
>>> +#define SVM_EXITINFOSHIFT_TS_REASON_JMP 38
>>> +#define SVM_EXITINFOSHIFT_TS_HAS_ERROR_CODE 44
>>> +
>>> +#define SVM_EXITINFO_REG_MASK 0x0F
>>> +
>>> +#define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
>>> +
>>> +#endif /* SELFTEST_KVM_SVM_H */
>>> diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
>>> new file mode 100644
>>> index 000000000000..6a67a89c5d06
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
>>> @@ -0,0 +1,36 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>> +/*
>>> + * tools/testing/selftests/kvm/include/x86_64/svm_utils.h
>>> + * Header for nested SVM testing
>>> + *
>>> + * Copyright (C) 2020, Red Hat, Inc.
>>> + */
>>> +
>>> +#ifndef SELFTEST_KVM_SVM_UTILS_H
>>> +#define SELFTEST_KVM_SVM_UTILS_H
>>> +
>>> +#include <stdint.h>
>>> +#include "svm.h"
>>> +#include "processor.h"
>>> +
>>> +#define CPUID_SVM_BIT		2
>>> +#define CPUID_SVM		BIT_ULL(CPUID_SVM_BIT)
>>> +
>>> +#define SVM_EXIT_VMMCALL	0x081
>>
>> SVM_EXIT_VMMCALL is better to relocate to svm.h file as it is an
>> architecture definition.
> For the same reason I am tempted to leave this definition here for now.
> Maybe at some point if we introduce some additional ones, this will
> indeed deserve to be moved to the parent? Is it ok?
> 

I figured out this was your intention when I compared arch/x86/include/asm/svm.h with tools/testing/selftests/kvm/include/x86_64/svm.h. However I also noticed that vmx.h in tools/testing/selftests/kvm/include/x86_64/ is not identical as arch/x86/include/asm/vmx.h. So being the same isn't a hard requirement. I am OK with either way.

-Wei


