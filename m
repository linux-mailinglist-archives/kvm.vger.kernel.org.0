Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F74A97A9
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 02:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730330AbfIEAff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 20:35:35 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45607 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729941AbfIEAfe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 20:35:34 -0400
Received: by mail-pl1-f193.google.com with SMTP id x3so377761plr.12
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 17:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=NKD5g5Lrj+apo2cR/IP8jA2maiKtfmP4x5CUlHLMk4k=;
        b=cHBLae2EOlF9Eo3b/REgyCLSCvRccIWNO1k4Pf0rMMKqNHYDOHPcNgdiJ/9oq3YFfJ
         yHOx8B9TduEWgMlYRXlMvz8NMnr4nyu6vavtNv2qA1BPxLyiOMdMXuImCW/6MsKrF4b2
         3QtG0vAJanbK+fARv4RKOiGAsBE53sFCV8NYgUa3LKcJq5wDumA1NGJQYx8JLPLmssG+
         DZMmfA/+q3QLj1WA+YyUj7RDhTgSJuFO9ymTnjz5dJ4DG2wcic4NGQoNiIenWnz8cAYO
         a7jT9uwx/5TakeJyn4s+p1Xhb4O2zsoxIta5+5RpaNT0Jx2/hS53LN83PrfxZwi9C6Lp
         m9OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=NKD5g5Lrj+apo2cR/IP8jA2maiKtfmP4x5CUlHLMk4k=;
        b=G8WM/kA2ToznLto+Jzqaqp+adUCnZssHTLoSMEB1iyrWRfPr4b9pHp4B7VpCtI9dlf
         4ldSe9NjpPzqoTq8qcvudVdnQ+etzwKLjHZ7vzosedi4XRZCJKyoeYW2gLxSrw/KCqRZ
         dBcKJPvYg0p4UeTax1P041c1Cci5cz9LzlWSSkZUj6UxVtTN00gLCXA9vFjKeL7pizMX
         nD1PmMErHNv2CGVjfsHFgc+ZtDpD6xYUfh0H0Kzggq9RKbQkPd/LyBYmdzTnZaLdcDOv
         EViplpn3IgeDAmiewNvtCbeSOThvbUqIHJ45LQc35T13LKaNgZ9Z4BUXrvzt0F5eRS9j
         FR1g==
X-Gm-Message-State: APjAAAWU3oS6DX1v2FBTAGotyAiaN7BJHlBTO7yThq3FcIlngsreRbYT
        MSDTHP/SPqxRvOqSxifknVw69Q==
X-Google-Smtp-Source: APXvYqy7wAeXaUfFTAiq8R0yRQHufTQ1xn65KWLL5gQc4isTaQzm8RPXFnYKuxDsfOWQqrImGdjKFQ==
X-Received: by 2002:a17:902:7245:: with SMTP id c5mr486028pll.187.1567643733241;
        Wed, 04 Sep 2019 17:35:33 -0700 (PDT)
Received: from google.com ([2620:0:1009:11:73e5:72bd:51c7:44f6])
        by smtp.gmail.com with ESMTPSA id x8sm249902pfn.106.2019.09.04.17.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 17:35:32 -0700 (PDT)
Date:   Wed, 4 Sep 2019 17:35:28 -0700
From:   Oliver Upton <oupton@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [kvm-unit-tests PATCH v3 8/8] x86: VMX: Add tests for nested
 "load IA32_PERF_GLOBAL_CTRL"
Message-ID: <20190905003528.GA107023@google.com>
References: <20190903215801.183193-1-oupton@google.com>
 <20190903215801.183193-9-oupton@google.com>
 <5dc635d7-607a-ef0e-d9c9-8dced7fd89b2@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5dc635d7-607a-ef0e-d9c9-8dced7fd89b2@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 04, 2019 at 05:13:17PM -0700, Krish Sadhukhan wrote:
> 
> 
> On 09/03/2019 02:58 PM, Oliver Upton wrote:
> > Tests to verify that KVM performs the correct checks on Host/Guest state
> > at VM-entry, as described in SDM 26.3.1.1 "Checks on Guest Control
> > Registers, Debug Registers, and MSRs" and SDM 26.2.2 "Checks on Host
> > Control Registers and MSRs".
> > 
> > Test that KVM does the following:
> > 
> >      If the "load IA32_PERF_GLOBAL_CTRL" VM-entry control is 1, the
> >      reserved bits of the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the
> >      GUEST_IA32_PERF_GLOBAL_CTRL VMCS field. Otherwise, the VM-entry
> >      should fail with an exit reason of "VM-entry failure due to invalid
> >      guest state" (33). On a successful VM-entry, the correct value
> >      should be observed when the nested VM performs an RDMSR on
> >      IA32_PERF_GLOBAL_CTRL.
> > 
> >      If the "load IA32_PERF_GLOBAL_CTRL" VM-exit control is 1, the
> >      reserved bits of the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the
> >      HOST_IA32_PERF_GLOBAL_CTRL VMCS field. Otherwise, the VM-entry
> >      should fail with a VM-instruction error of "VM entry with invalid
> >      host-state field(s)" (8). On a successful VM-exit, the correct value
> >      should be observed when L1 performs an RDMSR on
> >      IA32_PERF_GLOBAL_CTRL.
> > 
> > Suggested-by: Jim Mattson <jmattson@google.com>
> > Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >   x86/vmx_tests.c | 199 +++++++++++++++++++++++++++++++++++++++++++++++-
> >   1 file changed, 197 insertions(+), 2 deletions(-)
> > 
> > diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> > index b72a27583793..73c46eba6be9 100644
> > --- a/x86/vmx_tests.c
> > +++ b/x86/vmx_tests.c
> > @@ -5033,7 +5033,7 @@ static void guest_state_test_main(void)
> >   			break;
> >   		if (data->enabled) {
> > -			obs = rdmsr(obs);
> > +			obs = rdmsr(data->msr);
> >   			report("Guest state is 0x%lx (expected 0x%lx)",
> >   			       data->exp == obs, obs, data->exp);
> >   		}
> > @@ -6854,6 +6854,200 @@ static void test_host_efer(void)
> >   	test_efer(HOST_EFER, "HOST_EFER", EXI_CONTROLS, EXI_LOAD_EFER);
> >   }
> > +union cpuid10_eax {
> > +	struct {
> > +		unsigned int version_id:8;
> > +		unsigned int num_counters:8;
> 
> It's better to name it num_gpc or num_counters_gp.

Ack to all style comments that follow. I brought these structs over from
kvm, but I'll align the style with what is suggested for kvm-unit-tests.

> > +		unsigned int bit_width:8;
> > +		unsigned int mask_length:8;
> > +	} split;
> > +	unsigned int full;
> > +};
> > +
> > +union cpuid10_edx {
> > +	struct {
> > +		unsigned int num_counters_fixed:5;
> > +		unsigned int bit_width_fixed:8;
> > +		unsigned int reserved:19;
> > +	} split;
> > +	unsigned int full;
> > +};
> > +
> 
> In kvm-unit-test source,  the naming of variables, functions etc. seems to
> be based on the hex value of the CPUID leaf that they represent. For
> example, cpuid_7_ebx, check_cpuid_80000001_edx etc. Isn't it better to name
> these structures something like cpuidA_eax and cpuidA_edx ?
> 
> > +static bool valid_pgc(u64 val)
> > +{
> > +	struct cpuid id;
> > +	union cpuid10_eax eax;
> > +	union cpuid10_edx edx;
> > +	u64 mask;
> > +
> > +	id = cpuid(0xA);
> > +	eax.full = id.a;
> > +	edx.full = id.d;
> > +	mask = ~(((1ull << eax.split.num_counters) - 1) |
> > +		(((1ull << edx.split.num_counters_fixed) - 1) << 32));
> > +
> > +	return !(val & mask);
> > +}
> > +
> > +static void test_pgc_vmlaunch(u32 xerror, bool xfail, bool host)
> > +{
> > +	u32 inst_err;
> > +	u64 guest_rip, inst_len, obs;
> > +	bool success;
> > +	struct load_state_test_data *data = &load_state_test_data;
> > +
> > +	if (host) {
> > +		success = vmlaunch_succeeds();
> > +		obs = rdmsr(data->msr);
> > +		if (data->enabled && success)
> > +			report("Host state is 0x%lx (expected 0x%lx)",
> > +			       data->exp == obs, obs, data->exp);
> > +	} else {
> > +		if (xfail)
> > +			enter_guest_with_invalid_guest_state();
> > +		else
> > +			enter_guest();
> > +		success = VMX_VMCALL == (vmcs_read(EXI_REASON) & 0xff);
> > +		guest_rip = vmcs_read(GUEST_RIP);
> > +		inst_len = vmcs_read(EXI_INST_LEN);
> > +		if (success)
> > +			vmcs_write(GUEST_RIP, guest_rip + inst_len);
> 
> Is it possible to re-use the existing report_guest_state_test() here and the
> below code ?

Ah, I missed this in my cursory search. Better to reuse what's already
here :)

> > +	}
> > +	if (!success) {
> > +		inst_err = vmcs_read(VMX_INST_ERROR);
> > +		report("vmlaunch failed, VMX Inst Error is %d (expected %d)",
> > +		       xerror == inst_err, inst_err, xerror);
> > +	} else {
> > +		report("vmlaunch succeeded", success != xfail);
> > +	}
> > +}
> > +
> > +/*
> > + * test_load_pgc is a generic function for testing the
> > + * "load IA32_PERF_GLOBAL_CTRL" VM-{entry,exit} control. This test function
> > + * will test the provided ctrl_val disabled and enabled.
> > + *
> > + * @nr - VMCS field number corresponding to the Host/Guest state field
> > + * @name - Name of the above VMCS field for printing in test report
> > + * @ctrl_nr - VMCS field number corresponding to the VM-{entry,exit} control
> > + * @ctrl_val - Bit to set on the ctrl field.
> > + */
> > +static void test_load_pgc(u32 nr, const char *name, u32 ctrl_nr,
> > +			  const char *ctrl_name, u64 ctrl_val)
> > +{
> > +	u64 ctrl_saved = vmcs_read(ctrl_nr);
> > +	u64 pgc_saved = vmcs_read(nr);
> > +	u64 i, val;
> > +	bool host = nr == HOST_PERF_GLOBAL_CTRL;
> > +	struct load_state_test_data *data = &load_state_test_data;
> > +
> > +	data->msr = MSR_CORE_PERF_GLOBAL_CTRL;
> > +	msr_bmp_init();
> > +	if (!host) {
> > +		vmx_set_test_stage(1);
> > +		test_set_guest(guest_state_test_main);
> > +	}
> > +	vmcs_write(ctrl_nr, ctrl_saved & ~ctrl_val);
> > +	data->enabled = false;
> > +	report_prefix_pushf("\"load IA32_PERF_GLOBAL_CTRL\"=0 on %s",
> > +			    ctrl_name);
> > +	for (i = 0; i < 64; i++) {
> > +		val = 1ull << i;
> > +		vmcs_write(nr, val);
> > +		report_prefix_pushf("%s = 0x%lx", name, val);
> > +		/*
> > +		 * If the "load IA32_PERF_GLOBAL_CTRL" bit is 0 then
> > +		 * the {HOST,GUEST}_IA32_PERF_GLOBAL_CTRL field is ignored,
> > +		 * thus setting reserved bits in this field does not cause
> > +		 * vmlaunch to fail.
> > +		 */
> 
> This comment is really not required as it's obvious that there's no effect
> on VM-entry if the control bit is not set.

I'll drop this.

> > +		test_pgc_vmlaunch(0, false, host);
> > +		report_prefix_pop();
> > +	}
> > +	report_prefix_pop();
> > +
> > +	vmcs_write(ctrl_nr, ctrl_saved | ctrl_val);
> > +	data->enabled = true;
> > +	report_prefix_pushf("\"load IA32_PERF_GLOBAL_CTRL\"=1 on %s",
> > +			    ctrl_name);
> > +	for (i = 0; i < 64; i++) {
> > +		val = 1ull << i;
> > +		data->exp = val;
> > +		vmcs_write(nr, val);
> > +		report_prefix_pushf("%s = 0x%lx", name, val);
> > +		if (valid_pgc(val)) {
> > +			test_pgc_vmlaunch(0, false, host);
> > +		} else {
> > +			/*
> > +			 * [SDM 30.4]
> > +			 *
> > +			 * Invalid host state fields result in an VM
> > +			 * instruction error with error number 8
> > +			 * (VMXERR_ENTRY_INVALID_HOST_STATE_FIELD)
> > +			 */
> > +			if (host) {
> > +				test_pgc_vmlaunch(
> > +					VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
> > +					true, host);
> > +			/*
> > +			 * [SDM 26.1]
> > +			 *
> > +			 * If a VM-Entry fails according to one of
> > +			 * the guest-state checks, the exit reason on the VMCS
> > +			 * will be set to reason number 33 (VMX_FAIL_STATE)
> 
> Again, these comments are probably not necessary.

I wanted to capture the nuance between host/guest, since the control
flow seems unnecessarily complicated on first glance. If they're
distracting, I'll drop these comments as well.

> > +			 */
> > +			} else {
> > +				test_pgc_vmlaunch(
> > +					0,
> > +					true, host);
> > +				TEST_ASSERT_EQ(
> > +					VMX_ENTRY_FAILURE | VMX_FAIL_STATE,
> > +					vmcs_read(EXI_REASON));
> > +			}
> > +		}
> > +		report_prefix_pop();
> > +	}
> > +
> > +	report_prefix_pop();
> > +
> > +	if (nr == GUEST_PERF_GLOBAL_CTRL) {
> > +		/*
> > +		 * Let the guest finish execution
> > +		 */
> > +		vmx_set_test_stage(2);
> > +		vmcs_write(ctrl_nr, ctrl_saved);
> > +		vmcs_write(nr, pgc_saved);
> > +		enter_guest();
> > +	}
> > +
> > +	vmcs_write(ctrl_nr, ctrl_saved);
> > +	vmcs_write(nr, pgc_saved);
> > +}
> > +
> > +static void test_load_host_pgc(void)
> > +{
> > +	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
> > +		printf("\"load IA32_PERF_GLOBAL_CTRL\" "
> > +		       "exit control not supported\n");
> > +		return;
> > +	}
> > +
> > +	test_load_pgc(HOST_PERF_GLOBAL_CTRL, "HOST_PERF_GLOBAL_CTRL",
> > +		      EXI_CONTROLS, "EXI_CONTROLS", EXI_LOAD_PERF);
> > +}
> > +
> > +
> > +static void test_load_guest_pgc(void)
> > +{
> > +	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
> > +		printf("\"load IA32_PERF_GLOBAL_CTRL\" "
> > +		       "entry control not supported\n");
> > +	}
> > +
> > +	test_load_pgc(GUEST_PERF_GLOBAL_CTRL, "GUEST_PERF_GLOBAL_CTRL",
> > +		      ENT_CONTROLS, "ENT_CONTROLS", ENT_LOAD_PERF);
> > +}
> > +
> >   /*
> >    * PAT values higher than 8 are uninteresting since they're likely lumped
> >    * in with "8". We only test values above 8 one bit at a time,
> > @@ -7147,6 +7341,7 @@ static void vmx_host_state_area_test(void)
> >   	test_sysenter_field(HOST_SYSENTER_EIP, "HOST_SYSENTER_EIP");
> >   	test_host_efer();
> > +	test_load_host_pgc();
> 
> I would rename it to test_load_host_perf_global_ctrl to avoid confusion
> between "performance counter" and "VMCS control field" though the name is
> bit long.

Sure thing.

> >   	test_load_host_pat();
> >   	test_host_segment_regs();
> >   	test_host_desc_tables();
> > @@ -8587,7 +8782,6 @@ static int invalid_msr_entry_failure(struct vmentry_failure *failure)
> >   	return VMX_TEST_VMEXIT;
> >   }
> > -
> >   #define TEST(name) { #name, .v2 = name }
> >   /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
> > @@ -8637,6 +8831,7 @@ struct vmx_test vmx_tests[] = {
> >   	TEST(vmx_host_state_area_test),
> >   	TEST(vmx_guest_state_area_test),
> >   	TEST(vmentry_movss_shadow_test),
> > +	TEST(test_load_guest_pgc),
> 
> Same comment as above.
> The other comment I have is, why not put this inside of
> 'vmx_guest_state_area_test' because this VMCS field belongs to Guest State
> Area only.

This is actually a point of discussion. Are we going to want every guest
state test to set up its guest each time? As the code stands currently,
we can only set an L2 guest once, or the test will fail out.

This was less invasive, but I think the better solution would be to set
up the guest once from 'vmx_guest_state_area_test', let the test
functions run, then clean it up. This would require also moving the
guest setup tidbits out of test_pat(). Would you agree this is the
better route?

> >   	/* APICv tests */
> >   	TEST(vmx_eoi_bitmap_ioapic_scan_test),
> >   	TEST(vmx_hlt_with_rvi_test),
>

Thanks for the review, Krish. I'll address style fixes where noted, only
pending question is on the guest state test.

--
Thanks,
Oliver
