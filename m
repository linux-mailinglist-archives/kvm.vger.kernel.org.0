Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1A15F6D84
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 20:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiJFSbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 14:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiJFSb1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 14:31:27 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFA3AA360
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 11:31:23 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id f140so2854075pfa.1
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 11:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5tqpyzMMfKgYRQNtK1HpD/acwmpZ7QOJOYhsAzwpzxM=;
        b=fa84eRR0WULkX9PBmJMowIb5wtxulEbChbHx3QTmTywdR3H6dUR/OFCekwJ9kX0ion
         OWnMU/X1h2xenNFoqVG2wT9CD8RVh1x+KpExrKV0TUZeWtGTu1hNbhISFT6xKfuCCNlg
         b02zuzlNM875Aa2StQEoExcxePzpXHnoRlgWWJy0hvoRhPVb8GAGS66PqfsmyeYH2F+C
         6StSx3vUSCdPCSmm4auVTAAapZvfeLaUIsZuoXEu0LYvHF9Frx5QMw6bIpoOIVn/WGbT
         rQ5shfWYf9QPRMZR65zMZUrFSdah7Yp3e1/GXxfIgQ84Seij9vRsR+2tF5c1gliC0MHR
         26lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5tqpyzMMfKgYRQNtK1HpD/acwmpZ7QOJOYhsAzwpzxM=;
        b=TEN8jfRM3uuL1thUCdkfd0sHXd8HZoFB4Nm4p9RwuW9nuDy+MY1FgWY5wG1IYi53mR
         TTn8G/J4+Q9szXS74PBhFrZTAT3ZTrFNz2aLEB/wm0humt3c28CU1yxA4CIxbhnNqJza
         aGW635snGYhPZWtfUr4Ie/p2lEuuE2GEtVsqBDhdyUIBNLKQn4rPxUnFcTw+H1DAknc/
         0FUfpaudFhz1kA0fjtaBMN4s1j9JmewJ+JQEvKyt7E2u54ouB8QDL/xK/oM27skoMaBX
         tWoOLRs/ydXEPnFFuCI5oP7W4VK2RomfAU6OFgJEJPAzRMwzmPo6DFviLTqhjoe6erAk
         dt4w==
X-Gm-Message-State: ACrzQf2WRDtcQKv8ULwxP+5PtpeO4LAckusVvR/XU2cNppVO0fXdd2FM
        j9TJfAji8ZmNBtQ5R6IPCEphnQ==
X-Google-Smtp-Source: AMsMyM5VjpJstVpZ6fMJq81hg2Zk1rlj0F5x+JOErJlhi+pl/A09JgHlzkidlzgGzMAna0/X4lqJ8A==
X-Received: by 2002:a63:d145:0:b0:443:c25f:5dd5 with SMTP id c5-20020a63d145000000b00443c25f5dd5mr1010382pgj.554.1665081082646;
        Thu, 06 Oct 2022 11:31:22 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j12-20020a170903024c00b0017a04542a45sm12849930plh.159.2022.10.06.11.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 11:31:21 -0700 (PDT)
Date:   Thu, 6 Oct 2022 18:31:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev
Subject: Re: [V4 8/8] KVM: selftests: Add simple sev vm testing
Message-ID: <Yz8e9t0L//pXD9S9@google.com>
References: <20220829171021.701198-1-pgonda@google.com>
 <20220829171021.701198-9-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829171021.701198-9-pgonda@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 29, 2022, Peter Gonda wrote:
> +	for (i = 0; i <= NR_SYNCS; ++i) {
> +		vcpu_run(vcpu);
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_SYNC:
> +			continue;
> +		case UCALL_DONE:
> +			return;
> +		case UCALL_ABORT:
> +			TEST_ASSERT(false, "%s at %s:%ld\n\tvalues: %#lx, %#lx",
> +				    (const char *)uc.args[0], __FILE__,
> +				    uc.args[1], uc.args[2], uc.args[3]);

REPORT_GUEST_ASSERT

> +		default:
> +			TEST_ASSERT(
> +				false, "Unexpected exit: %s",
> +				exit_reason_str(vcpu->run->exit_reason));

TEST_FAIL

> +		}
> +	}
> +}
> +
> +static void guest_sev_code(void)
> +{
> +	uint32_t eax, ebx, ecx, edx;
> +	uint64_t sev_status;
> +
> +	GUEST_SYNC(1);
> +
> +	GUEST_ASSERT(this_cpu_has(X86_FEATURE_SEV));
> +
> +	sev_status = rdmsr(MSR_AMD64_SEV);
> +	GUEST_ASSERT((sev_status & 0x1) == 1);

Add a #define for the magic 0x1.  And the "== 1" is unnecessary.  Hmm, and the
querying of SEV/SEV-ES/etc status in MSR_AMD64_SEV should be done in helpers.

> +
> +	GUEST_DONE();
> +}
> +
> +static struct sev_vm *setup_test_common(void *guest_code, uint64_t policy,
> +					struct kvm_vcpu **vcpu)
> +{
> +	uint8_t measurement[512];
> +	struct sev_vm *sev;
> +	struct kvm_vm *vm;
> +	int i;
> +
> +	sev = sev_vm_create(policy, TOTAL_PAGES);
> +	TEST_ASSERT(sev, "sev_vm_create() failed to create VM\n");

See earlier comments on using TEST_REQUIRE.

> +
> +	vm = sev->vm;
> +
> +	/* Set up VCPU and initial guest kernel. */
> +	*vcpu = vm_vcpu_add(vm, 0, guest_code);
> +	kvm_vm_elf_load(vm, program_invocation_name);
> +
> +	/* Allocations/setup done. Encrypt initial guest payload. */
> +	sev_vm_launch(sev);
> +
> +	/* Dump the initial measurement. A test to actually verify it would be nice. */
> +	sev_vm_launch_measure(sev, measurement);
> +	pr_info("guest measurement: ");
> +	for (i = 0; i < 32; ++i)
> +		pr_info("%02x", measurement[i]);
> +	pr_info("\n");
> +
> +	sev_vm_launch_finish(sev);

I believe this entire function gets replaced with

	vm = ____vm_create_with_one_vcpu(VM_MODE_PXXV48_4K_SEV, &vcpu, 0,
					 guest_code);

> +
> +	return sev;
> +}
> +
> +static void test_sev(void *guest_code, uint64_t policy)
> +{
> +	struct sev_vm *sev;
> +	struct kvm_vcpu *vcpu;
> +
> +	sev = setup_test_common(guest_code, policy, &vcpu);
> +
> +	/* Guest is ready to run. Do the tests. */

Comment doesn't add much value.

> +	guest_run_loop(vcpu);
> +
> +	pr_info("guest ran successfully\n");

Meh, the test passing is a good indication the test ran successfully.

> +
> +	sev_vm_free(sev);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	/* SEV tests */

Again, stating the obvious.

> +	test_sev(guest_sev_code, SEV_POLICY_NO_DBG);
> +	test_sev(guest_sev_code, 0);
> +
> +	return 0;
> +}
> -- 
> 2.37.2.672.g94769d06f0-goog
> 
