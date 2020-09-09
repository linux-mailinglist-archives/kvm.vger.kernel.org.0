Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D35026369B
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 21:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgIIT0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 15:26:47 -0400
Received: from mail-co1nam11on2058.outbound.protection.outlook.com ([40.107.220.58]:4736
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726184AbgIIT0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 15:26:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHipMGUHyBVKoPpvW1bvwqTjXFrw59o4S6tcpJjyMnaUdSpUoDlBkjGAE/DsX1YKzRueNN+RLo6cfgywcM2rKTuLonXcm7TOufBm9U8NqArRFQANZLIO1IMA22RNGLKEtBdqxU9GE4CnRZsB3ETRqA4vqz+48BCgT74guZmu79lOLnbcknMbNxE11atHBjPafuAZrM+ScgxwwYpiko2J2nnpNOcyDMK/9sTt4vxOHCMx4WyP+Iv/eEjywuaJjswQ/I+oXPVzvKJlgfWXgIx9C9O7/WarWghaCcfSQJDcuZc/Y3HymHIEV/LnkH2INuKaSKH9JvH2RV5NV570lmlw5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3e1SZuEkIeUX96FPRvQ1YvKfoixlGlZlhT5U+QMD9c=;
 b=OhZ9PJN7eX5pYJ8ZLrhdRu/4caZCxW/kbcRlz1TOqbUZVas8uNdbU881PENKQQhx8Ce1oJNuyN+TnnA8jR3C0SDXi4OZztOOcTXLdI5kx3TB6bRVm7ChlfJTnqTMAOyHBVMQPM44rtDTnn9x/YP3IC2DfHxtPD5Sk+fS3fJA3xrGSZT/NM2B72VjuuWhZ2lKG+xHZ831AMAaq3ZMaFVQUumfIGwnCbwm0imnDIkWndrcZg8HHimH3jjdlu30rmV+OgZ8gCAEDChFLRkb2bJUVxZMlWCWPe/U2YjKY9+i8amfRtsC+7dlj8b6DZql+3dtcr0G7kk7shx/S2wTMo8pBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3e1SZuEkIeUX96FPRvQ1YvKfoixlGlZlhT5U+QMD9c=;
 b=JTKL18PNJyhfuF+Ai3cP5EY4uAU+P2ByWvEdZ5u8W1sUGF5OXIUqyfVbD25fGf5145fAX73iacLp3jDGbDqEtoYaIuMuXlX+f/pblCpEeMia1R7HfYoxyUueYx8eFvHMLXyH28fylnNXOVKLRj5lt2Y63raA9xtU3QiuPCws80c=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2590.namprd12.prod.outlook.com (2603:10b6:802:2e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Wed, 9 Sep
 2020 19:26:41 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3370.016; Wed, 9 Sep 2020
 19:26:41 +0000
Subject: RE: [PATCH v5 00/12] SVM cleanup and INVPCID feature support
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "jmattson@google.com" <jmattson@google.com>
Cc:     "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <fe0deb21-1128-ab8e-fe3e-c9863398095c@amd.com>
Date:   Wed, 9 Sep 2020 14:26:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM3PR08CA0011.namprd08.prod.outlook.com
 (2603:10b6:0:52::21) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by DM3PR08CA0011.namprd08.prod.outlook.com (2603:10b6:0:52::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Wed, 9 Sep 2020 19:26:40 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cc09f171-ad4b-408d-65c4-08d854f64764
X-MS-TrafficTypeDiagnostic: SN1PR12MB2590:
X-Microsoft-Antispam-PRVS: <SN1PR12MB259034DE3AC54844C13D54E395260@SN1PR12MB2590.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E21uwF9O3uiChS2C26748rlX7Sx3LHdz3MeX431lWnSrKlOWSYjNbL8TcQ3cHmgKscBZxtOdTSq+eKWc3+sWEOtPICv12bGQuxCP4oU4mU2mvvax5/y1N1KxqlA8rjulxaXsKMIKk0rNQFKf2/oT2wlfoKOHIT/Lz8ENx2umvUQHBKo21ulO4VulpzLUO0uqzYjMYhOOJ+XDS9xzpBoBMZRPcU4o5weizJII0lttNHrfkGf+6Kr/F9pJ28UcJistVSXC1Xm9BGoPSMBoWHdrir0Nk1sxjJserxM2piu/kshAIwVAa+2HDJ17FM+A8pHSVOvOb2u8nYO5m64yXSPcwmRfo7+ejeP0xtWqBoz+Pd//zKp+RkVQtFnJw9zPvVn4t6QTNNIs4jhnstlZ74Faq2H1kOcJMj9an5VyLJzKikC1Q17Q20nEdMcBiSaKeTj56//fNK4JnUjjk44Sluvx2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(44832011)(478600001)(52116002)(7416002)(53546011)(16576012)(316002)(16526019)(186003)(31696002)(26005)(6486002)(8676002)(2906002)(86362001)(5660300002)(956004)(8936002)(2616005)(83380400001)(66556008)(4326008)(66476007)(66946007)(36756003)(54906003)(966005)(31686004)(110136005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3Mn+xWcOTMOClkV9sKLSgYWdHk2OhhT5edIdyLfe2jgVh/Qz7dmyK2qMxxzpYpoFEps1w19LsTLOe9Ov1lrFiIJNi/XPHH6VWN5moSXbN4guPf5wO8OcaybSlr5BAb6EjsfvguOXAvKgq6gliTvWh87nBuWRAor1xuS/v4HKNaJcwITpOR4q69UJlx5OCg3iTgqqxrstv1r3vfpC1fPvoQ9ABfC1hms88e/zD0y2CdMEwcLy0nd2kzcypLihezlEwpK2QyRtTEDJK4bBOkMaN4bV4h8eMWk3bNjiOTGjuvy7BaLa39KOKs+QXpm5jfdbr4yhA4Y58teNb0AXvOwC+mql1Ihovomp/mH6VdNhoNbCbUf60SviwYM2I9Z4FPVEsrKPb4EWI+MKRvbuNC5alCCmZVxLOGVQXaFFwdkEAjjxaz2R1NdG62gFd/P4jwGrIegcR8fbkioYkTSVnYpGsWxCw6t7vy8POE9IPJhsEY+u8yz4FWX/sojMi5CzY93Oa9XeMx/pYAxbhH8h/R0RFOWd6GEA1Pjscq/GSaAPXyIXpoGZNAh+A+ww+ilU4RhZ/tEPSEjzfMXa0Ng7VCUyCdlPoaKIUT0sv0sBdkMRTzXrEnHHoK6+SPfpXUPULmF8SaHSl2YxnIJU4sUPSfvnQQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc09f171-ad4b-408d-65c4-08d854f64764
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 19:26:41.0774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fxj5l6BuR1PFk7Dyu6YWtExGTCxvZ+ZTvg2EG6/WYMmc4/9r9WX1ZObb7iRLwy7Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2590
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,
Let me know if you have feedback on this series? I was thinking of
refreshing the series. There is one minor comment on PATCH v5 04/12(from Jim).
Thanks
Babu

> -----Original Message-----
> From: Moger, Babu <Babu.Moger@amd.com>
> Sent: Wednesday, August 26, 2020 2:14 PM
> To: pbonzini@redhat.com; vkuznets@redhat.com;
> sean.j.christopherson@intel.com; jmattson@google.com
> Cc: wanpengli@tencent.com; kvm@vger.kernel.org; joro@8bytes.org;
> x86@kernel.org; linux-kernel@vger.kernel.org; Moger, Babu
> <Babu.Moger@amd.com>; mingo@redhat.com; bp@alien8.de;
> hpa@zytor.com; tglx@linutronix.de
> Subject: [PATCH v5 00/12] SVM cleanup and INVPCID feature support
> 
> The following series adds the support for PCID/INVPCID on AMD guests.
> While doing it re-structured the vmcb_control_area data structure to combine
> all the intercept vectors into one 32 bit array. Makes it easy for future additions.
> Re-arranged few pcid related code to make it common between SVM and VMX.
> 
> INVPCID interceptions are added only when the guest is running with shadow
> page table enabled. In this case the hypervisor needs to handle the tlbflush
> based on the type of invpcid instruction.
> 
> For the guests with nested page table (NPT) support, the INVPCID feature works
> as running it natively. KVM does not need to do any special handling.
> 
> AMD documentation for INVPCID feature is available at "AMD64 Architecture
> Programmer’s Manual Volume 2: System Programming, Pub. 24593 Rev. 3.34(or
> later)"
> 
> The documentation can be obtained at the links below:
> Link: https://www.amd.com/system/files/TechDocs/24593.pdf
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
> ---
> v5:
>  All the changes are related to rebase.
>  Aplies cleanly on mainline and kvm(master) tree.
>  Resending it to get some attention.
> 
> v4:
> 
> https://lore.kernel.org/lkml/159676101387.12805.18038347880482984693.stgi
> t@bmoger-ubuntu/
>  1. Changed the functions __set_intercept/__clr_intercept/__is_intercept to
>     to vmcb_set_intercept/vmcb_clr_intercept/vmcb_is_intercept by passing
>     vmcb_control_area structure(Suggested by Paolo).
>  2. Rearranged the commit 7a35e515a7055 ("KVM: VMX: Properly handle
> kvm_read/write_guest_virt*())
>     to make it common across both SVM/VMX(Suggested by Jim Mattson).
>  3. Took care of few other comments from Jim Mattson. Dropped "Reviewed-
> by"
>     on few patches which I have changed since v3.
> 
> v3:
> 
> https://lore.kernel.org/lkml/159597929496.12744.14654593948763926416.stgi
> t@bmoger-ubuntu/
>  1. Addressing the comments from Jim Mattson. Follow the v2 link below
>     for the context.
>  2. Introduced the generic __set_intercept, __clr_intercept and is_intercept
>     using native __set_bit, clear_bit and test_bit.
>  3. Combined all the intercepts vectors into single 32 bit array.
>  4. Removed set_intercept_cr, clr_intercept_cr, set_exception_intercepts,
>     clr_exception_intercept etc. Used the generic set_intercept and
>     clr_intercept where applicable.
>  5. Tested both L1 guest and l2 nested guests.
> 
> v2:
> 
> https://lore.kernel.org/lkml/159234483706.6230.13753828995249423191.stgit
> @bmoger-ubuntu/
>   - Taken care of few comments from Jim Mattson.
>   - KVM interceptions added only when tdp is off. No interceptions
>     when tdp is on.
>   - Reverted the fault priority to original order in VMX.
> 
> v1:
> 
> https://lore.kernel.org/lkml/159191202523.31436.11959784252237488867.stgi
> t@bmoger-ubuntu/
> 
> Babu Moger (12):
>       KVM: SVM: Introduce vmcb_(set_intercept/clr_intercept/_is_intercept)
>       KVM: SVM: Change intercept_cr to generic intercepts
>       KVM: SVM: Change intercept_dr to generic intercepts
>       KVM: SVM: Modify intercept_exceptions to generic intercepts
>       KVM: SVM: Modify 64 bit intercept field to two 32 bit vectors
>       KVM: SVM: Add new intercept vector in vmcb_control_area
>       KVM: nSVM: Cleanup nested_state data structure
>       KVM: SVM: Remove set_cr_intercept, clr_cr_intercept and is_cr_intercept
>       KVM: SVM: Remove set_exception_intercept and clr_exception_intercept
>       KVM: X86: Rename and move the function vmx_handle_memory_failure to
> x86.c
>       KVM: X86: Move handling of INVPCID types to x86
>       KVM:SVM: Enable INVPCID feature on AMD
> 
> 
>  arch/x86/include/asm/svm.h      |  117 +++++++++++++++++++++++++----------
>  arch/x86/include/uapi/asm/svm.h |    2 +
>  arch/x86/kvm/svm/nested.c       |   66 +++++++++-----------
>  arch/x86/kvm/svm/svm.c          |  131 ++++++++++++++++++++++++++------------
> -
>  arch/x86/kvm/svm/svm.h          |   87 +++++++++-----------------
>  arch/x86/kvm/trace.h            |   21 ++++--
>  arch/x86/kvm/vmx/nested.c       |   12 ++--
>  arch/x86/kvm/vmx/vmx.c          |   95 ----------------------------
>  arch/x86/kvm/vmx/vmx.h          |    2 -
>  arch/x86/kvm/x86.c              |  106 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.h              |    3 +
>  11 files changed, 364 insertions(+), 278 deletions(-)
> 
> --
> Signature
