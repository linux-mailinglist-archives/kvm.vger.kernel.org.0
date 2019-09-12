Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A583B12CA
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 18:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733216AbfILQ3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 12:29:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41666 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730310AbfILQ3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 12:29:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8CGScFI136545;
        Thu, 12 Sep 2019 16:29:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=J243/MYMpsG7T06FaCo2avTrkWCRXyky4fIhhXtFhmw=;
 b=MSO3D3gtMd56lordTN+o1Okb1s/BprCW1x2LqTw8yWxjEk1vaG2KscMUOtqXxNy4+Y6h
 JdLmOLpN7Ly/xM2L6gc6U9feRHCj5ytTwY81l+Dir8sodmwx1X5+I61dEA5B5e5Uznhn
 G6/j6PtNNwZNcwD6Zuph4W+QQxN/2ohwwA3Xp4O3P9u2DFW3N2DmLTGVJ/XZ3vo2IVED
 LF/1ncl5E8nyhXNof4qhNLlymg6IVb48tApndQTUA9/unnjDhIAedtthnbp9CGkMCrGt
 03JVArycb+nHkboHG0inHgVmQV5rxP/lf/f+NSuAZB4bruQyRLF5uo/YjEMd7mFGtcx4 Kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2uw1m99p8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Sep 2019 16:29:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8CGSm74167634;
        Thu, 12 Sep 2019 16:29:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2uy8wa9wdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Sep 2019 16:29:13 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8CGSGdx008158;
        Thu, 12 Sep 2019 16:28:16 GMT
Received: from [10.159.229.118] (/10.159.229.118)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Sep 2019 09:28:16 -0700
Subject: Re: [kvm-unit-tests PATCH v4 9/9] x86: VMX: Add tests for nested
 "load IA32_PERF_GLOBAL_CTRL"
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190906210313.128316-1-oupton@google.com>
 <20190906210313.128316-10-oupton@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <94c97f67-7dc7-110a-5289-7ca23aafa654@oracle.com>
Date:   Thu, 12 Sep 2019 09:28:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190906210313.128316-10-oupton@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9378 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909120171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9378 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909120171
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/6/19 2:03 PM, Oliver Upton wrote:
> Tests to verify that KVM performs the correct checks on Host/Guest state
> at VM-entry, as described in SDM 26.3.1.1 "Checks on Guest Control
> Registers, Debug Registers, and MSRs" and SDM 26.2.2 "Checks on Host
> Control Registers and MSRs".
>
> Test that KVM does the following:
>
>      If the "load IA32_PERF_GLOBAL_CTRL" VM-entry control is 1, the
>      reserved bits of the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the
>      GUEST_IA32_PERF_GLOBAL_CTRL VMCS field. Otherwise, the VM-entry
>      should fail with an exit reason of "VM-entry failure due to invalid
>      guest state" (33). On a successful VM-entry, the correct value
>      should be observed when the nested VM performs an RDMSR on
>      IA32_PERF_GLOBAL_CTRL.
>
>      If the "load IA32_PERF_GLOBAL_CTRL" VM-exit control is 1, the
>      reserved bits of the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the
>      HOST_IA32_PERF_GLOBAL_CTRL VMCS field. Otherwise, the VM-entry
>      should fail with a VM-instruction error of "VM entry with invalid
>      host-state field(s)" (8). On a successful VM-exit, the correct value
>      should be observed when L1 performs an RDMSR on
>      IA32_PERF_GLOBAL_CTRL.
>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>   x86/vmx_tests.c | 172 ++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 172 insertions(+)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 84e1a7935aa1..86424dab615a 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -6854,6 +6854,176 @@ static void test_host_efer(void)
>   	test_efer(HOST_EFER, "HOST_EFER", EXI_CONTROLS, EXI_LOAD_EFER);
>   }
>   
> +union cpuidA_eax {
> +	struct {
> +		unsigned int version_id:8;
> +		unsigned int num_counters_gp:8;
> +		unsigned int bit_width:8;
> +		unsigned int mask_length:8;
> +	} split;
> +	unsigned int full;
> +};
> +
> +union cpuidA_edx {
> +	struct {
> +		unsigned int num_counters_fixed:5;
> +		unsigned int bit_width_fixed:8;
> +		unsigned int reserved:19;
> +	} split;
> +	unsigned int full;
> +};
> +
> +static bool valid_pgc(u64 val)
> +{
> +	struct cpuid id;
> +	union cpuidA_eax eax;
> +	union cpuidA_edx edx;
> +	u64 mask;
> +
> +	id = cpuid(0xA);
> +	eax.full = id.a;
> +	edx.full = id.d;
> +	mask = ~(((1ull << eax.split.num_counters_gp) - 1) |
> +		(((1ull << edx.split.num_counters_fixed) - 1) << 32));
> +
> +	return !(val & mask);
> +}
> +
> +static void test_pgc_vmlaunch(u32 xerror, u32 xreason, bool xfail, bool host)
> +{
> +	u32 inst_err;
> +	u64 obs;
> +	bool success;
> +	struct vmx_state_area_test_data *data = &vmx_state_area_test_data;
> +
> +	if (host) {
> +		success = vmlaunch_succeeds();
> +		obs = rdmsr(data->msr);
> +		if (!success) {
> +			inst_err = vmcs_read(VMX_INST_ERROR);
> +			report("vmlaunch failed, VMX Inst Error is %d (expected %d)",
> +			       xerror == inst_err, inst_err, xerror);
> +		} else {
> +			report("Host state is 0x%lx (expected 0x%lx)",
> +			       !data->enabled || data->exp == obs, obs, data->exp);
> +			report("vmlaunch succeeded", success != xfail);
> +		}
> +	} else {
> +		if (xfail) {
> +			enter_guest_with_invalid_guest_state();
> +		} else {
> +			enter_guest();
> +		}
> +		report_guest_state_test("load GUEST_PERF_GLOBAL_CTRL",
> +					xreason, GUEST_PERF_GLOBAL_CTRL,
> +					"GUEST_PERF_GLOBAL_CTRL");
> +	}
> +}
> +
> +/*
> + * test_load_perf_global_ctrl is a generic function for testing the
> + * "load IA32_PERF_GLOBAL_CTRL" VM-{entry,exit} control. This test function
> + * will test the provided ctrl_val disabled and enabled.
> + *
> + * @nr - VMCS field number corresponding to the Host/Guest state field
> + * @name - Name of the above VMCS field for printing in test report
> + * @ctrl_nr - VMCS field number corresponding to the VM-{entry,exit} control
> + * @ctrl_val - Bit to set on the ctrl field.
> + */
> +static void test_load_perf_global_ctrl(u32 nr, const char *name, u32 ctrl_nr,
> +				       const char *ctrl_name, u64 ctrl_val)
> +{
> +	u64 ctrl_saved = vmcs_read(ctrl_nr);
> +	u64 pgc_saved = vmcs_read(nr);
> +	u64 i, val;
> +	bool host = nr == HOST_PERF_GLOBAL_CTRL;
> +	struct vmx_state_area_test_data *data = &vmx_state_area_test_data;
> +
> +	if (!host) {
> +		vmx_set_test_stage(1);
> +		test_reset_guest(guest_state_test_main);
> +	}
> +	data->msr = MSR_CORE_PERF_GLOBAL_CTRL;
> +	msr_bmp_init();
> +	vmcs_write(ctrl_nr, ctrl_saved & ~ctrl_val);
> +	data->enabled = false;
> +	report_prefix_pushf("\"load IA32_PERF_GLOBAL_CTRL\"=0 on %s",
> +			    ctrl_name);
> +	for (i = 0; i < 64; i++) {
> +		val = 1ull << i;
> +		vmcs_write(nr, val);
> +		report_prefix_pushf("%s = 0x%lx", name, val);
> +		test_pgc_vmlaunch(0, VMX_VMCALL, false, host);
> +		report_prefix_pop();
> +	}
> +	report_prefix_pop();
> +
> +	vmcs_write(ctrl_nr, ctrl_saved | ctrl_val);
> +	data->enabled = true;
> +	report_prefix_pushf("\"load IA32_PERF_GLOBAL_CTRL\"=1 on %s",
> +			    ctrl_name);
> +	for (i = 0; i < 64; i++) {
> +		val = 1ull << i;
> +		data->exp = val;
> +		vmcs_write(nr, val);
> +		report_prefix_pushf("%s = 0x%lx", name, val);
> +		if (valid_pgc(val)) {
> +			test_pgc_vmlaunch(0, VMX_VMCALL, false, host);
> +		} else {
> +			if (host)
> +				test_pgc_vmlaunch(
> +					VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
> +					0,
> +					true, host);
> +			else
> +				test_pgc_vmlaunch(
> +					0,
> +					VMX_ENTRY_FAILURE | VMX_FAIL_STATE,
> +					true, host);
> +		}
> +		report_prefix_pop();
> +	}
> +
> +	report_prefix_pop();
> +
> +	if (nr == GUEST_PERF_GLOBAL_CTRL) {
> +		/*
> +		 * Let the guest finish execution
> +		 */
> +		vmx_set_test_stage(2);
> +		vmcs_write(ctrl_nr, ctrl_saved);
> +		vmcs_write(nr, pgc_saved);
> +		enter_guest();
> +	}
> +
> +	vmcs_write(ctrl_nr, ctrl_saved);
> +	vmcs_write(nr, pgc_saved);
> +}
> +
> +static void test_load_host_perf_global_ctrl(void)
> +{
> +	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
> +		printf("\"load IA32_PERF_GLOBAL_CTRL\" "
> +		       "exit control not supported\n");
> +		return;
> +	}
> +
> +	test_load_perf_global_ctrl(HOST_PERF_GLOBAL_CTRL, "HOST_PERF_GLOBAL_CTRL",
> +		      EXI_CONTROLS, "EXI_CONTROLS", EXI_LOAD_PERF);
> +}
> +
> +
> +static void test_load_guest_perf_global_ctrl(void)
> +{
> +	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
> +		printf("\"load IA32_PERF_GLOBAL_CTRL\" "
> +		       "entry control not supported\n");
> +	}
> +
> +	test_load_perf_global_ctrl(GUEST_PERF_GLOBAL_CTRL, "GUEST_PERF_GLOBAL_CTRL",
> +		      ENT_CONTROLS, "ENT_CONTROLS", ENT_LOAD_PERF);
> +}
> +
>   /*
>    * PAT values higher than 8 are uninteresting since they're likely lumped
>    * in with "8". We only test values above 8 one bit at a time,
> @@ -7147,6 +7317,7 @@ static void vmx_host_state_area_test(void)
>   	test_sysenter_field(HOST_SYSENTER_EIP, "HOST_SYSENTER_EIP");
>   
>   	test_host_efer();
> +	test_load_host_perf_global_ctrl();
>   	test_load_host_pat();
>   	test_host_segment_regs();
>   	test_host_desc_tables();
> @@ -7181,6 +7352,7 @@ static void test_load_guest_pat(void)
>   static void vmx_guest_state_area_test(void)
>   {
>   	test_load_guest_pat();
> +	test_load_guest_perf_global_ctrl();
>   }
>   
>   static bool valid_vmcs_for_vmentry(void)

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
