Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86422AFA93
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 22:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgKKVgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 16:36:19 -0500
Received: from mail-co1nam11on2071.outbound.protection.outlook.com ([40.107.220.71]:13633
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725959AbgKKVgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 16:36:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cdp6pYWd91RiTOmA01ZgLnWYD2suGYIOBVq/u64LGOiJwbZmtM6qypvcjS3Lg+2pVFWbOdi0v6tIjZcsWwfwBKN6LEh/wT2GoNSvDEm7Yga41kmsxB4oQFh0aKmx+d24qje+kWC+fFmvOlc7TDryImdIGMEyzLGj06leatNYBR5OcJlZ/m2h+klXbgdRl0xjnr+4FlNeF+F+xSVpl2xGYrHEc6h7HNUE28Hf56q2SIeYXQXKnXJIHpwadi/IbPXLU1tD8d3cAipvbyjBqmuqVo42fs731NjsTc8ceMDUiPpOCvCWQ5zg/lueG1ypgveYl5v1jc4ifhnMigmDAoo/fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqJwHCEmVZnpxtQr3Yn2jQOk8owns8XmwjiBoH3RPEg=;
 b=LreClDNE82fYVFmhLDIjbm0ind0OYX20389pOBeZZBpyZkMt8jKOy8uPT7c2ArWj2OnL7uxIB9zS4Fg9rSg2iB5bBGQKg8Oo3a8GC3q+gr4C6k2yAJtLSV58zjIGIW+BUHMw9vgFKZ0bDmHlnCxPjRWIJJUFSIZDdRdcGTj13Ck8PrN/kE8WadxLhaf02Qx0VlVfINxEYRkeV0URT1JpnHLZv57fFZwvtNsoXOlZNoWSO8pP2UKcpsOmPem9GkKzKF23EDVKDBWgd3K+p8jcT+OrzSPGMboPNPjgekZdVbICf50wn4HD9Ho3RRTdGb7m0JXY6BbVTsMZHbgY77+AZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqJwHCEmVZnpxtQr3Yn2jQOk8owns8XmwjiBoH3RPEg=;
 b=G0HGo/HeUAEd2GteMnqBJS8YMwaWJ4CfM3LDbAkkt8JB0vHaNpIe+Oy0ucDRIX90Ct8HJ3I80zV2G544uuTLPXAzVSQMLVfJU9B/iWdr2j313gJ4LzTqZNSyhq57XDXpJgu57cuQLwCGjIYW5cUvdyyFhP9CM3OTS2LdD/Fpe4w=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2462.namprd12.prod.outlook.com (2603:10b6:802:28::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Wed, 11 Nov
 2020 21:36:16 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece%3]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 21:36:16 +0000
Subject: RE: [PATCH v3 0/2] KVM: SVM: Create separate vmcbs for L1 and L2
To:     Cathy Avery <cavery@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Huang2, Wei" <Wei.Huang2@amd.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
References: <20201026174222.21811-1-cavery@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <75b85cc7-96d9-eab9-9748-715ed951034d@amd.com>
Date:   Wed, 11 Nov 2020 15:35:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201026174222.21811-1-cavery@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM3PR12CA0074.namprd12.prod.outlook.com
 (2603:10b6:0:57::18) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by DM3PR12CA0074.namprd12.prod.outlook.com (2603:10b6:0:57::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Wed, 11 Nov 2020 21:36:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c88fc693-b791-4638-83b3-08d88689d1ca
X-MS-TrafficTypeDiagnostic: SN1PR12MB2462:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2462C1556BD149094AF8FC5395E80@SN1PR12MB2462.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q7PBpv1M6rL4F9j+/8rxOU+do0FejtfbNXz/XBOr7CbzvjgJlk2bYBhZAjXi1BdvAjxe8tKBT0gTYZb+FZiJe/192YjM+MBDl9k3Z0zveb3z3bEnEjEZgEtx8l1lKxy2+ifQAa3ncUCoO8rw0blDme99oedeIx4MAYUUpj3qxVyfKJVyaoCwXNhLTqLOgWphVUOzvI1F1NZDpkFAPhiOhzhe4h6qoBfnBQkI00OKGv5IPTb7mW4pHNRG7ImK6SJyQ+Tx3nlwHNkVTbYaptSV4joMJFrizZRhD5nDhqKOEE0XJDRw/i3Kgt7fqqW/2Hv6pdyYivSlqnqYf+9YoXYwGIypgLha/YRAoGUnX40NQJV5iWRtonvjOH/+dtfc2vEBlZss8/r4AEVcWbjypsIuQDmbkT2c8paEW3omjuFWBfsJHO4vS0aToTuwTUHTEeNxYQDPsE2oUA6rMajN08cgDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(26005)(66946007)(66476007)(66556008)(6666004)(4326008)(44832011)(52116002)(8676002)(316002)(478600001)(53546011)(54906003)(16576012)(110136005)(86362001)(8936002)(956004)(16526019)(2906002)(5660300002)(2616005)(31686004)(36756003)(186003)(83380400001)(6486002)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lINqzttXy7T9yypWJ2vOIGZBXCeTxrsdimG5XTizTrVmKbAHq6mKSYGpHv7LagOPe6L8JNFCk61rOVN2mnNLxROMPeMmbT7Lpo9gMwgXe/AUiYOi/ZKq9+EpgUOgbW6Gxm2X68JQMvoccFZZ0m3sRTVZCUGHwYezKeF0ofAKQuSLL45L2Y+LEYZPp8SzStmHx5kVAWZWQgOB6zI0FmH3TioLgpws34QHubi8VBVdgmFYLViO2FWX1iL0no1n9y73E++eZCeAFMS/VB+55zKhrBwHefGJXQ0frhMfDZcM0QozFYFYAbJz9lm91e1e7yuaoWajtPMG8o+aZ+QNUXCOQClULzrqxunS4B71IXUl7i82BRuWLFYNOPT80q4HxK0eybtD66HKzOvSuuzoGzuL90Dj517hFRbUPUV22dMCn9ReYEaww5fkMHlHzDcOIk+NLHqa0zd3vKAbHBhRo8D35pNf3MhtvbWtig2zvxAlGl7G2p9kP9N5llJimBw+tpUhzOAnX5vDYNhKNvnro4MYN2crKHXYNzd/PH729NzGIr3YS5qFkYN7wbTAHmmXpNyvlxUiWyGTHKt96OloQ/teCdSNOSkWRpY8IyOn3NcbP1Zo/EO30xHSVWlEepAYVOWIXhw4cz53H6OAD1YJ8Ryu9w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c88fc693-b791-4638-83b3-08d88689d1ca
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2020 21:36:16.2586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HPfD1uFiHwyBx6/PARciJEAx2/bzpN0A8rOa8Xww3f1MSFarbImXBbkeKdRcUf7L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2462
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Cathy,
I was going to test these patches. But it did not apply on my tree.
Tried on kvm(https://git.kernel.org/pub/scm/virt/kvm/kvm.git) and
Mainline
(https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git). What
is your base tree?
thanks
Babu

> -----Original Message-----
> From: Cathy Avery <cavery@redhat.com>
> Sent: Monday, October 26, 2020 12:42 PM
> To: linux-kernel@vger.kernel.org; kvm@vger.kernel.org; pbonzini@redhat.com
> Cc: vkuznets@redhat.com; Huang2, Wei <Wei.Huang2@amd.com>;
> mlevitsk@redhat.com; sean.j.christopherson@intel.com
> Subject: [PATCH v3 0/2] KVM: SVM: Create separate vmcbs for L1 and L2
> 
> svm->vmcb will now point to either a separate vmcb L1 ( not nested ) or L2 vmcb
> ( nested ).
> 
> Changes:
> v2 -> v3
>  - Added vmcb switching helper.
>  - svm_set_nested_state always forces to L1 before determining state
>    to set. This is more like vmx and covers any potential L2 to L2 nested state
> switch.
>  - Moved svm->asid tracking to pre_svm_run and added ASID set dirty bit
>    checking.
> 
> v1 -> v2
>  - Removed unnecessary update check of L1 save.cr3 during nested_svm_vmexit.
>  - Moved vmcb01_pa to svm.
>  - Removed get_host_vmcb() function.
>  - Updated vmsave/vmload corresponding vmcb state during L2
>    enter and exit which fixed the L2 load issue.
>  - Moved asid workaround to a new patch which adds asid to svm.
>  - Init previously uninitialized L2 vmcb save.gpat and save.cr4
> 
> Tested:
> kvm-unit-tests
> kvm self tests
> Loaded fedora nested guest on fedora
> 
> Cathy Avery (2):
>   KVM: SVM: Track asid from vcpu_svm
>   KVM: SVM: Use a separate vmcb for the nested L2 guest
> 
>  arch/x86/kvm/svm/nested.c | 125 ++++++++++++++++++--------------------
>  arch/x86/kvm/svm/svm.c    |  58 +++++++++++-------
>  arch/x86/kvm/svm/svm.h    |  51 +++++-----------
>  3 files changed, 110 insertions(+), 124 deletions(-)
> 
> --
> 2.20.1

