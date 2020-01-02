Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E26C812E4E3
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2020 11:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgABKSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 05:18:03 -0500
Received: from mail-mw2nam10on2066.outbound.protection.outlook.com ([40.107.94.66]:45281
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727990AbgABKSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 05:18:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6qdjfYHv/YABc5X5p0j7mWVHXEmB+KZE9kl+akt6+T/1LHKoBlqm8ERlJIEKQpBpQKKrow8cpyKKy3WGOSUW5/BRsxxi2WijERH+tVHDLl1xPl8FvjHP6efyNvl3fu/ZgT3F3j7FKJN+sUQedrBb5U9g2ekdYLzyYtB4wAj8IEcBGuCJG9M0kCB7EAXZNkMmIO3Mn9RW+DL0relSSk7Puq+ZE3AFCGUBLJ7rrSOXQdUaqQrXWYANjicn3DIAmicYhQNTodFttsxBOPE7KuEgiS+m1p3puQTPehfrlmM0dCSPC6e/xBUwrkOPKBO8HwLwLpjL0JFvscpA3qpPqecIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zMJToqKXojpUKDYL5SkdbqK8qxRe9p30td+zc0dqHo=;
 b=AngjtlaU9oRYoa3mRzOfEPZT4Zr9s2UbNBaCMCk9Hqha/4zg24xHMuK32PfqmMdkRvPYUcPCHXyp8YWqw4Gz2aQGb4qk9l5QqsdicCNgRGk90ETcSf2wSVhGaYAdKSzKUdwaovtIYjOX9pDYk8wigJic5q3wEKSze4Qw5dMUugVh+YqKOORPUbJRBqSbwC9zD2BN8H4NU8wRagbVaOcHqB+WFFBHjNdP8pDq8pDJIqKQWBq+3DRSNj9b9dqrkmdlbZKxYzU45q2fQlzKJXhJ2qoqzisxTHu77POA3KZCD4da7qddxGi0MJ4eMl645eevmgnr18CU2moc0IFsqnxGhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zMJToqKXojpUKDYL5SkdbqK8qxRe9p30td+zc0dqHo=;
 b=n6nfYd5MM82u2ZPH/f7fcuUw7tmnKVn6gwcgHwI0L2eVSJrgrG+tb+8FmLPm6TGNr+nAhAs6VrVRe3MPBhSEPtTyjMNcDUFf0o4Hef9eFLSwTuu9A+lS9jsYrVsV7zdjSzuaqEBQkWJwxd3w+Bgh+zVwWGF+lyD/caIbKd9vzLg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from BY5PR12MB3860.namprd12.prod.outlook.com (10.255.138.89) by
 BY5PR12MB4081.namprd12.prod.outlook.com (52.135.55.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Thu, 2 Jan 2020 10:17:59 +0000
Received: from BY5PR12MB3860.namprd12.prod.outlook.com
 ([fe80::793f:db82:f2ab:9758]) by BY5PR12MB3860.namprd12.prod.outlook.com
 ([fe80::793f:db82:f2ab:9758%7]) with mapi id 15.20.2581.007; Thu, 2 Jan 2020
 10:17:59 +0000
Subject: Re: [PATCH v5 00/18] kvm: x86: Support AMD SVM AVIC w/ in-kernel
 irqchip mode
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com
References: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <9e3e9692-d786-844e-c625-62b69505d2c9@amd.com>
Date:   Thu, 2 Jan 2020 17:17:47 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
In-Reply-To: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0089.apcprd02.prod.outlook.com
 (2603:1096:4:90::29) To BY5PR12MB3860.namprd12.prod.outlook.com
 (2603:10b6:a03:1ac::25)
MIME-Version: 1.0
Received: from Suravees-MacBook-Pro.local (165.204.140.250) by SG2PR02CA0089.apcprd02.prod.outlook.com (2603:1096:4:90::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12 via Frontend Transport; Thu, 2 Jan 2020 10:17:55 +0000
X-Originating-IP: [165.204.140.250]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7a9aca43-ce81-4bb0-c48d-08d78f6d0a80
X-MS-TrafficTypeDiagnostic: BY5PR12MB4081:|BY5PR12MB4081:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR12MB4081AA676AD2A34E06AEF277F3200@BY5PR12MB4081.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0270ED2845
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(86362001)(31696002)(6486002)(4326008)(6512007)(44832011)(6666004)(8936002)(81166006)(81156014)(8676002)(478600001)(7416002)(2906002)(36756003)(6506007)(316002)(53546011)(16526019)(186003)(66556008)(2616005)(956004)(5660300002)(66476007)(66946007)(26005)(52116002)(31686004)(21314003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR12MB4081;H:BY5PR12MB3860.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IjyqGGtj7ouqa5aSoioBXWKNM/Go353SDX+hgbtLOTtPL+qTnSKbBW6CkW0snhvq+hT1Kf6RqiS0ACNJushbk6Q7u5zbTOFtXVcbnEK1LPGW9/E2nMW0jv9Y7IPENwzGYe0Ntowx/JWV2efgG2DZYQT/4oukBXWsdK9UrFTOTuRGpFOCRvNE2M3GQq1ZPo5hjA14S+QvYAhS9tAaZDFy3TyhmkY3yQppx3gzHegUqm5oxoQL6zxLV21PeSLDd+sM+Fmo/vb1C9/uNz6q75Czfne5FOPcrfBK402mYDPTJhYExqYBlXNmeviVIGr3xirJ175XfDbbdY6iHF/Rt5G+8Cat9sDE11/vFHnFR0q5DyyN4F2bo5D+8JQib58KMeXSJhR0S6+2Wk9LUF7vD3uYQs5vMzqhxhqHNOBxCIUwlenzGvYMxaSR3T20pM07nGbmi9xPODm/8j0g7u0nMw6s3znPAyPY+CK+2t3WUAihc77rAQioadeMyTrE7Gj0w8l2mNHxkoN/diRT4wUZvPkVSw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a9aca43-ce81-4bb0-c48d-08d78f6d0a80
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2020 10:17:59.0790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wt7x7B0xRkBhYqB4hEMNTqnYq9Kd8464zdHvzEJlc4kpPr514hl2Gb/AsIOJW+lsQmalQtHMXP9c8JhvI31I3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4081
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Ping. Would you please let me know your feedback when you get a chance to review this series

Thanks,
Suravee

On 11/15/19 3:15 AM, Suravee Suthikulpanit wrote:
> The 'commit 67034bb9dd5e ("KVM: SVM: Add irqchip_split() checks before
> enabling AVIC")' was introduced to fix miscellaneous boot-hang issues
> when enable AVIC. This is mainly due to AVIC hardware doest not #vmexit
> on write to LAPIC EOI register resulting in-kernel PIC and IOAPIC to
> wait and do not inject new interrupts (e.g. PIT, RTC).
> 
> This limits AVIC to only work with kernel_irqchip=split mode, which is
> not currently enabled by default, and also required user-space to
> support split irqchip model, which might not be the case.
> 
> The goal of this series is to enable AVIC to work in both irqchip modes,
> by allowing AVIC to be deactivated temporarily during runtime, and fallback
> to legacy interrupt injection mode (w/ vINTR and interrupt windows)
> when needed, and then re-enabled subsequently (a.k.a Dynamic APICv).
> 
> Similar approach is also used to handle Hyper-V SynIC in the
> 'commit 5c919412fe61 ("kvm/x86: Hyper-V synthetic interrupt controller")',
> where APICv is permanently disabled at runtime (currently broken for
> AVIC, and fixed by this series).
> 
> This series contains several parts:
>    * Part 1: patch 1,2
>      Code clean up, refactor, and introduce helper functions
> 
>    * Part 2: patch 3
>      Introduce APICv deactivate bits to keep track of APICv state
>      for each vm.
>   
>    * Part 3: patch 4-10
>      Add support for activate/deactivate APICv at runtime
> 
>    * Part 4: patch 11-14:
>      Add support for various cases where APICv needs to
>      be deactivated
> 
>    * Part 5: patch 15-17:
>      Introduce in-kernel IOAPIC workaround for AVIC EOI
> 
>    * Part 6: path 18
>      Allow enable AVIC w/ kernel_irqchip=on
> 
> Pre-requisite Patch:
>    * commit b9c6ff94e43a ("iommu/amd: Re-factor guest virtual APIC (de-)activation code")
>      (https://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/commit/
>       ?h=next&id=b9c6ff94e43a0ee053e0c1d983fba1ac4953b762)
> 
> This series has been tested against v5.3 as following:
>    * Booting Linux, FreeBSD, and Windows Server 2019 VMs upto 240 vcpus
>      w/ qemu option "kernel-irqchip=on" and "-no-hpet".
>    * Pass-through Intel 10GbE NIC and run netperf in the VM.
> 
> Changes from V4: (https://lkml.org/lkml/2019/11/1/764)
>    * Rename APICV_DEACT_BIT_xxx to APICV_INHIBIT_REASON_xxxx
>    * Introduce kvm_x86_ops.check_apicv_inhibit_reasons hook
>      to allow vendors to specify which APICv inhibit reason bits
>      to support (patch 08/18).
>    * Update comment on kvm_request_apicv_update() no-lock requirement.
>      (patch 04/18)
> 
> Suravee Suthikulpanit (18):
>    kvm: x86: Modify kvm_x86_ops.get_enable_apicv() to use struct kvm
>      parameter
>    kvm: lapic: Introduce APICv update helper function
>    kvm: x86: Introduce APICv inhibit reason bits
>    kvm: x86: Add support for dynamic APICv
>    kvm: x86: Add APICv (de)activate request trace points
>    kvm: x86: svm: Add support to (de)activate posted interrupts
>    svm: Add support for setup/destroy virutal APIC backing page for AVIC
>    kvm: x86: Introduce APICv x86 ops for checking APIC inhibit reasons
>    kvm: x86: Introduce x86 ops hook for pre-update APICv
>    svm: Add support for dynamic APICv
>    kvm: x86: hyperv: Use APICv update request interface
>    svm: Deactivate AVIC when launching guest with nested SVM support
>    svm: Temporary deactivate AVIC during ExtINT handling
>    kvm: i8254: Deactivate APICv when using in-kernel PIT re-injection
>      mode.
>    kvm: lapic: Clean up APIC predefined macros
>    kvm: ioapic: Refactor kvm_ioapic_update_eoi()
>    kvm: ioapic: Lazy update IOAPIC EOI
>    svm: Allow AVIC with in-kernel irqchip mode
> 
>   arch/x86/include/asm/kvm_host.h |  19 ++++-
>   arch/x86/kvm/hyperv.c           |   5 +-
>   arch/x86/kvm/i8254.c            |  12 +++
>   arch/x86/kvm/ioapic.c           | 149 +++++++++++++++++++++++-------------
>   arch/x86/kvm/lapic.c            |  35 +++++----
>   arch/x86/kvm/lapic.h            |   2 +
>   arch/x86/kvm/svm.c              | 164 +++++++++++++++++++++++++++++++++++-----
>   arch/x86/kvm/trace.h            |  19 +++++
>   arch/x86/kvm/vmx/vmx.c          |  12 ++-
>   arch/x86/kvm/x86.c              |  71 ++++++++++++++---
>   10 files changed, 385 insertions(+), 103 deletions(-)
> 
