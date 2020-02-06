Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB58154A5F
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 18:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgBFRjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 12:39:37 -0500
Received: from mail-dm6nam10on2063.outbound.protection.outlook.com ([40.107.93.63]:11745
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbgBFRjh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 12:39:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PCqrpGCTZuC2t+dOeTo9Wa6S5O62T6xze+r14gFk/41skCvu7X3LvgZcFmcEToy7Ni2B/GoDcdVfCbSpANkAFXnQbBvODexDDZERK0p0Zhx/y/TT+AxQmi1OqBON1RZO2O8kNT/0OhXNphxENIrsYZSX6xeFzzfCxh5xPINPhCmTaiUl6potpXs4YmJIzvaH1JQPLIeH8a9RTyZpVYvagu/XmqvxoSGlyYIljygb7hUeSPXzRYBojGXegRkg2c9zgm19yKpSYnOW45yNOtesSwT9f363/9pMo6lFIIi4jXfQq0ysV0ww/ABNMeSqwtjfmci2XQhLLWicI/n8gV7uAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snc/DdR4L4PAbS/XUnBteQWuw7ThV0Mo1OdDmjI22EY=;
 b=UuKEPBBzPvhDVtzek12B/1d1i+9PZqDDMazFbMNBjCQ7HVrOXAU4CMEm4BRC6xmO13d//4OLnFgyoEBIg62h6VKlOL2KuuJBwfVGm8blcDXEzTV363KHDUXdgrWaWmFfblpOTQXMWOqBXiHbFT+WpOibIytsuDooi4ZljvvIe9Xcax7VHkMSzT7MVIIQ3J2f4PuPDusKP74n4PZomgjagHkVjMwl8Kz9pVqX2fnLcwCp7kCWxRcTfeaElVhA498M6mqfMqeebUIu7yACuqFItQvz29oVoiCjJXUvJSJTsgIwmIHhp5QjWkmvThNQob0TfITn3s+UzmZoQ/JwPMLICw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snc/DdR4L4PAbS/XUnBteQWuw7ThV0Mo1OdDmjI22EY=;
 b=AVQFSjWsreROkvuyaOdQcoomU7gOSO9trM4/Ot1gUyltSX5JZyUqT10zMCr7Bv2p3Kr/sGTVxmFbUXDZNaEjfVvcGDrIvn6a6sF1n6ntPBfmDeYG4/M5NcJovbTCyczhHMsTTwGwXQmrIwQsInOB8EcXRdByP9WJody7Q4+X9kE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Wei.Huang2@amd.com; 
Received: from MN2PR12MB3999.namprd12.prod.outlook.com (10.255.239.219) by
 MN2PR12MB3261.namprd12.prod.outlook.com (20.179.84.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.32; Thu, 6 Feb 2020 17:39:33 +0000
Received: from MN2PR12MB3999.namprd12.prod.outlook.com
 ([fe80::a867:e7ad:695c:d87d]) by MN2PR12MB3999.namprd12.prod.outlook.com
 ([fe80::a867:e7ad:695c:d87d%6]) with mapi id 15.20.2686.035; Thu, 6 Feb 2020
 17:39:33 +0000
Date:   Thu, 6 Feb 2020 11:39:31 -0600
From:   Wei Huang <wei.huang2@amd.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        thuth@redhat.com, drjones@redhat.com
Subject: Re: [PATCH v4 3/3] selftests: KVM: SVM: Add vmcall test
Message-ID: <20200206173931.GC2465308@weiserver.amd.com>
References: <20200206104710.16077-1-eric.auger@redhat.com>
 <20200206104710.16077-4-eric.auger@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206104710.16077-4-eric.auger@redhat.com>
X-ClientProxiedBy: DM6PR08CA0048.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::22) To MN2PR12MB3999.namprd12.prod.outlook.com
 (2603:10b6:208:158::27)
Importance: high
MIME-Version: 1.0
Received: from localhost (165.204.77.1) by DM6PR08CA0048.namprd08.prod.outlook.com (2603:10b6:5:1e0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.24 via Frontend Transport; Thu, 6 Feb 2020 17:39:32 +0000
X-Priority: 1 (Highest)
X-MSMail-Priority: High
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f2d5b1fc-aff1-483d-8a22-08d7ab2b86c1
X-MS-TrafficTypeDiagnostic: MN2PR12MB3261:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3261C02DEE7D996974CF6993CF1D0@MN2PR12MB3261.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:169;
X-Forefront-PRVS: 0305463112
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(199004)(189003)(81166006)(16526019)(186003)(4326008)(6496006)(6486002)(66476007)(66556008)(66946007)(52116002)(86362001)(956004)(8936002)(33656002)(26005)(6916009)(8676002)(81156014)(5660300002)(1076003)(2906002)(478600001)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR12MB3261;H:MN2PR12MB3999.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RpucU+FX8nCkPPfPmNAowlODXgI9kBRAE1DcIVAnlzyR51ZzgLNYSNXieIX1VSNv0ihUyO4tyUC0tOAs0tvr+ilZjJsPzIamPXbX3m7Y2S8LCKXx67/zHfH+1RtT8hkeIYWzzT/rj8UwPpr1exsbooT8Adm3UYPrxmtjKE0M6MgAfC1q+2QR1pfFEJFbcupNnOZ3h/2X9jJ1ixYTVufkVhX3JYydLdZCU8Ujta8YQw2BIFNFtnPvKHFzHgKvVbgYpkAIcCmJzCdZF799WhgCyd0b1s1cG4+v04/WsgqsDUKqDbLdflB5+24LMBrw7k5YD/0K6AZLX+352i1fChz5KbvYMcb7qCTM88LGOzIZjkToMlA+5Dr4TPaqK1gxKhu16PTT5uZ8OyVSTItyOk/ouRZuctSQVkTLmOsZ+htTKpwm43BhXE+U14J5xwTpqbh0
X-MS-Exchange-AntiSpam-MessageData: G4VSbHwkKpjSRouvHGU2SKDOuLCxkA253TOPkibrDR3q9eKM7BLDAszYigAJ+5aq1BDc2WAB0rQjkPaZpUIP4eCejpgXXNmUrn/rha4Ziqbw7TE/zNpzSHyUgocdFtkdgW9YUqKwcrjqCOJNvZNA8Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d5b1fc-aff1-483d-8a22-08d7ab2b86c1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2020 17:39:33.2466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Bu/gtVInOzdGxooQifpI42yj3P45ZWkx9gTxn5Dgv4ZBE5cssEX5pb8sUCoTxB1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3261
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/06 11:47, Eric Auger wrote:
> L2 guest calls vmcall and L1 checks the exit status does
> correspond.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

I verified this patch with my AMD box, both with nested=1 and nested=0. I
also intentionally changed the assertion of exit_code to a different
value (0x082) and the test complained about it. So the test is good.

# selftests: kvm: svm_vmcall_test
# ==== Test Assertion Failure ====
#   x86_64/svm_vmcall_test.c:64: false
#   pid=2485656 tid=2485656 - Interrupted system call
#      1        0x0000000000401387: main at svm_vmcall_test.c:72
#      2        0x00007fd0978d71a2: ?? ??:0
#      3        0x00000000004013ed: _start at ??:?
#   Failed guest assert: vmcb->control.exit_code == SVM_EXIT_VMMCALL
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 48
not ok 15 selftests: kvm: svm_vmcall_test # exit=254

> 
> ---
> 
> v3 -> v4:
> - remove useless includes
> - collected Lin's R-b
> 
> v2 -> v3:
> - remove useless comment and add Vitaly's R-b
> ---
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../selftests/kvm/x86_64/svm_vmcall_test.c    | 79 +++++++++++++++++++
>  2 files changed, 80 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 2e770f554cae..b529d3b42c02 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -26,6 +26,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
>  TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
> +TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
>  TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
>  TEST_GEN_PROGS_x86_64 += dirty_log_test
>  TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
> diff --git a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
> new file mode 100644
> index 000000000000..6d3565aab94e
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c

Probably rename the file to svm_nested_vmcall_test.c. This matches with
the naming convention of VMX's nested tests. Otherwise people might not know
it is a nested one.

Everything else looks good.

> @@ -0,0 +1,79 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * svm_vmcall_test
> + *
> + * Copyright (C) 2020, Red Hat, Inc.
> + *
> + * Nested SVM testing: VMCALL
> + */
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "svm_util.h"
> +
> +#define VCPU_ID		5
> +
> +static struct kvm_vm *vm;
> +
> +static inline void l2_vmcall(struct svm_test_data *svm)
> +{
> +	__asm__ __volatile__("vmcall");
> +}
> +
> +static void l1_guest_code(struct svm_test_data *svm)
> +{
> +	#define L2_GUEST_STACK_SIZE 64
> +	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> +	struct vmcb *vmcb = svm->vmcb;
> +
> +	/* Prepare for L2 execution. */
> +	generic_svm_setup(svm, l2_vmcall,
> +			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
> +
> +	run_guest(vmcb, svm->vmcb_gpa);
> +
> +	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
> +	GUEST_DONE();
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	vm_vaddr_t svm_gva;
> +
> +	nested_svm_check_supported();
> +
> +	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
> +	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
> +
> +	vcpu_alloc_svm(vm, &svm_gva);
> +	vcpu_args_set(vm, VCPU_ID, 1, svm_gva);
> +
> +	for (;;) {
> +		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
> +		struct ucall uc;
> +
> +		vcpu_run(vm, VCPU_ID);
> +		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
> +			    run->exit_reason,
> +			    exit_reason_str(run->exit_reason));
> +
> +		switch (get_ucall(vm, VCPU_ID, &uc)) {
> +		case UCALL_ABORT:
> +			TEST_ASSERT(false, "%s",
> +				    (const char *)uc.args[0]);
> +			/* NOT REACHED */
> +		case UCALL_SYNC:
> +			break;
> +		case UCALL_DONE:
> +			goto done;
> +		default:
> +			TEST_ASSERT(false,
> +				    "Unknown ucall 0x%x.", uc.cmd);
> +		}
> +	}
> +done:
> +	kvm_vm_free(vm);
> +	return 0;
> +}


