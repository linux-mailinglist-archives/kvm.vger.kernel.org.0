Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC6B1ABEBE
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 13:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506085AbgDPLGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 07:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505858AbgDPLFu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 07:05:50 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD954C061A0C;
        Thu, 16 Apr 2020 04:05:43 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h9so4302524wrc.8;
        Thu, 16 Apr 2020 04:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6rXLsoYlFfQPmNLejSgy03ROUldhs4mrq41XQKaeI+Q=;
        b=cFHPz9O8k8mVYz9lBsfPHaqUCa51L1fIbpql7SuqNJkX3rgxolxA/7BH5ERuQqbNML
         NpWElN89Dci6p8brYcxKWUdjqrSvFCyI5HlydNFIrzi8U+cGO49p4J9JSN10HxzecmK1
         ZK0vmicrryFQu06ixWhMQwQt1gzroORvUbfXDG1E2isTw7yct57s+/F8LOLK0MY8i+hn
         GCsdS36/P5TF4sf8RwEiuWV6syUHF/7KECb5v7SEYw3EIstsTTQBz4WDs7SaYIJzKp/M
         eiCmG6n5t4RvtAJpZGzMOGULrHjWX3xDUX2VBQdFoSz2XDEUvD9Stqf9Pz8ixXTvVeTK
         AK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6rXLsoYlFfQPmNLejSgy03ROUldhs4mrq41XQKaeI+Q=;
        b=jLk5OrGs0FFWd+/QuQ0GO7I9NKwu/jD0QBQewvhto1zBXbtyvmLiKQpaJEbYFySBU/
         iNceqZmXBn6dob4n/3+eBfo6c2UmKh5bZ3753ToOHuY55Z/M7GIIlae1Yk0GMur2lXHt
         yqCDY+g4MK4hD/65HwLa8CB3m9MY5RIIq0TsxSj9wYKrAYggajZFrDmWbvW3hpJQvpxh
         wao25UDDwjeUe+MGsxvk1K2dRurzLm4ScpHqbKXeUgYfdVG+PSjTSGUDQAwZQJ695QqA
         9k6h4qJCvnUKZAvpA0MBe8wFL3IBxm1aqKIzeVricuCQn7bbnAH7Yub7yX3RnJkdpjBB
         LICg==
X-Gm-Message-State: AGi0PuZMyJzDRcCqGiBd4LpxSC9ToAWb3nIzHvmvhnalAKtatRYo60Dq
        kqsunMYqkkYjS/6S3GVUbAU=
X-Google-Smtp-Source: APiQypJz/1peVCMf3F0WMgBhS/RWJY+ZSPwTWxUWLm8IJg/J8X+mFhmLAA7f9dY70sr4eO3z10WT0g==
X-Received: by 2002:adf:fc92:: with SMTP id g18mr25409368wrr.10.1587035142376;
        Thu, 16 Apr 2020 04:05:42 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-155-55.inter.net.il. [84.229.155.55])
        by smtp.gmail.com with ESMTPSA id b85sm3272253wmb.21.2020.04.16.04.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 04:05:41 -0700 (PDT)
Date:   Thu, 16 Apr 2020 14:05:40 +0300
From:   Jon Doron <arilou@gmail.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v10 7/7] KVM: selftests: update hyperv_cpuid with SynDBG
 tests
Message-ID: <20200416110540.GK7606@jondnuc>
References: <20200324074341.1770081-1-arilou@gmail.com>
 <20200324074341.1770081-8-arilou@gmail.com>
 <87d09286mx.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87d09286mx.fsf@vitty.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Did this patchset make it into the merge window?

Thanks,
-- Jon.

On 24/03/2020, Vitaly Kuznetsov wrote:
>Jon Doron <arilou@gmail.com> writes:
>
>> From: Vitaly Kuznetsov <vkuznets () redhat ! com>
>>
>> Test all four combinations with eVMCS and SynDBG capabilities,
>> check that we get the right number of entries and that
>> 0x40000000.EAX always returns the correct max leaf.
>>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
>Something weird happened to this patch. It fails to apply on kvm/queue
>but it's also a bit different from what I've sent yesterday. I fixed and
>tested it, please find the result attached.
>
>-- 
>Vitaly
>

>From ae2c688389c20a99d7457861e57ce97054780908 Mon Sep 17 00:00:00 2001
>From: Vitaly Kuznetsov <vkuznets () redhat ! com>
>Date: Tue, 24 Mar 2020 09:43:41 +0200
>Subject: [PATCH v10 7/7 FIXED] KVM: selftests: update hyperv_cpuid with SynDBG
> tests
>
>Test all four combinations with eVMCS and SynDBG capabilities,
>check that we get the right number of entries and that
>0x40000000.EAX always returns the correct max leaf.
>
>Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>---
> .../selftests/kvm/x86_64/hyperv_cpuid.c       | 143 ++++++++++++------
> 1 file changed, 95 insertions(+), 48 deletions(-)
>
>diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
>index 83323f3d7ca0..5268abf9ad80 100644
>--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
>+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
>@@ -26,18 +26,18 @@ static void guest_code(void)
> {
> }
> 
>-static int smt_possible(void)
>+static bool smt_possible(void)
> {
> 	char buf[16];
> 	FILE *f;
>-	bool res = 1;
>+	bool res = true;
> 
> 	f = fopen("/sys/devices/system/cpu/smt/control", "r");
> 	if (f) {
> 		if (fread(buf, sizeof(*buf), sizeof(buf), f) > 0) {
> 			if (!strncmp(buf, "forceoff", 8) ||
> 			    !strncmp(buf, "notsupported", 12))
>-				res = 0;
>+				res = false;
> 		}
> 		fclose(f);
> 	}
>@@ -45,30 +45,48 @@ static int smt_possible(void)
> 	return res;
> }
> 
>+void vcpu_enable_syndbg(struct kvm_vm *vm, int vcpu_id)
>+{
>+	struct kvm_enable_cap enable_syndbg_cap = {
>+		.cap = KVM_CAP_HYPERV_SYNDBG,
>+	};
>+
>+	vcpu_ioctl(vm, vcpu_id, KVM_ENABLE_CAP, &enable_syndbg_cap);
>+}
>+
> static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
>-			  int evmcs_enabled)
>+			  bool evmcs_enabled, bool syndbg_enabled)
> {
> 	int i;
>+	int nent = 6;
>+	u32 test_val;
>+
>+	if (evmcs_enabled)
>+		nent += 1; /* 0x4000000A */
> 
>-	if (!evmcs_enabled)
>-		TEST_ASSERT(hv_cpuid_entries->nent == 6,
>-			    "KVM_GET_SUPPORTED_HV_CPUID should return 6 entries"
>-			    " when Enlightened VMCS is disabled (returned %d)",
>-			    hv_cpuid_entries->nent);
>-	else
>-		TEST_ASSERT(hv_cpuid_entries->nent == 7,
>-			    "KVM_GET_SUPPORTED_HV_CPUID should return 7 entries"
>-			    " when Enlightened VMCS is enabled (returned %d)",
>-			    hv_cpuid_entries->nent);
>+	if (syndbg_enabled)
>+		nent += 3; /* 0x40000080 - 0x40000082 */
>+
>+	TEST_ASSERT(hv_cpuid_entries->nent == nent,
>+		    "KVM_GET_SUPPORTED_HV_CPUID should return %d entries"
>+		    " with evmcs=%d syndbg=%d (returned %d)",
>+		    nent, evmcs_enabled, syndbg_enabled,
>+		    hv_cpuid_entries->nent);
> 
> 	for (i = 0; i < hv_cpuid_entries->nent; i++) {
> 		struct kvm_cpuid_entry2 *entry = &hv_cpuid_entries->entries[i];
> 
> 		TEST_ASSERT((entry->function >= 0x40000000) &&
>-			    (entry->function <= 0x4000000A),
>+			    (entry->function <= 0x40000082),
> 			    "function %x is our of supported range",
> 			    entry->function);
> 
>+		TEST_ASSERT(evmcs_enabled || (entry->function != 0x4000000A),
>+			    "0x4000000A leaf should not be reported");
>+
>+		TEST_ASSERT(syndbg_enabled || (entry->function <= 0x4000000A),
>+			    "SYNDBG leaves should not be reported");
>+
> 		TEST_ASSERT(entry->index == 0,
> 			    ".index field should be zero");
> 
>@@ -78,12 +96,27 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
> 		TEST_ASSERT(!entry->padding[0] && !entry->padding[1] &&
> 			    !entry->padding[2], "padding should be zero");
> 
>-		if (entry->function == 0x40000004) {
>-			int nononarchcs = !!(entry->eax & (1UL << 18));
>-
>-			TEST_ASSERT(nononarchcs == !smt_possible(),
>+		switch (entry->function) {
>+		case 0x40000000:
>+			test_val = 0x40000005;
>+			if (evmcs_enabled)
>+				test_val = 0x4000000A;
>+			if (syndbg_enabled)
>+				test_val = 0x40000082;
>+
>+			TEST_ASSERT(entry->eax == test_val,
>+				    "Wrong max leaf report in 0x40000000.EAX: %x"
>+				    " (evmcs=%d syndbg=%d)",
>+				    entry->eax, evmcs_enabled, syndbg_enabled
>+				);
>+			break;
>+		case 0x40000004:
>+			test_val = entry->eax & (1UL << 18);
>+
>+			TEST_ASSERT(!!test_val == !smt_possible(),
> 				    "NoNonArchitecturalCoreSharing bit"
> 				    " doesn't reflect SMT setting");
>+			break;
> 		}
> 
> 		/*
>@@ -133,8 +166,9 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(struct kvm_vm *vm)
> int main(int argc, char *argv[])
> {
> 	struct kvm_vm *vm;
>-	int rv;
>+	int rv, stage;
> 	struct kvm_cpuid2 *hv_cpuid_entries;
>+	bool evmcs_enabled, syndbg_enabled;
> 
> 	/* Tell stdout not to buffer its content */
> 	setbuf(stdout, NULL);
>@@ -145,36 +179,49 @@ int main(int argc, char *argv[])
> 		exit(KSFT_SKIP);
> 	}
> 
>-	/* Create VM */
>-	vm = vm_create_default(VCPU_ID, 0, guest_code);
>-
>-	test_hv_cpuid_e2big(vm);
>-
>-	hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm);
>-	if (!hv_cpuid_entries)
>-		return 1;
>-
>-	test_hv_cpuid(hv_cpuid_entries, 0);
>-
>-	free(hv_cpuid_entries);
>+	for (stage = 0; stage < 5; stage++) {
>+		evmcs_enabled = false;
>+		syndbg_enabled = false;
>+
>+		vm = vm_create_default(VCPU_ID, 0, guest_code);
>+		switch (stage) {
>+		case 0:
>+			test_hv_cpuid_e2big(vm);
>+			continue;
>+		case 1:
>+			break;
>+		case 2:
>+			if (!kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
>+				print_skip("Enlightened VMCS is unsupported");
>+				continue;
>+			}
>+			vcpu_enable_evmcs(vm, VCPU_ID);
>+			evmcs_enabled = true;
>+			break;
>+		case 3:
>+			if (!kvm_check_cap(KVM_CAP_HYPERV_SYNDBG)) {
>+				print_skip("Synthetic debugger is unsupported");
>+				continue;
>+			}
>+			vcpu_enable_syndbg(vm, VCPU_ID);
>+			syndbg_enabled = true;
>+			break;
>+		case 4:
>+			if (!kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS) ||
>+			    !kvm_check_cap(KVM_CAP_HYPERV_SYNDBG))
>+				continue;
>+			vcpu_enable_evmcs(vm, VCPU_ID);
>+			vcpu_enable_syndbg(vm, VCPU_ID);
>+			evmcs_enabled = true;
>+			syndbg_enabled = true;
>+			break;
>+		}
> 
>-	if (!kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
>-		print_skip("Enlightened VMCS is unsupported");
>-		goto vm_free;
>+		hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm);
>+		test_hv_cpuid(hv_cpuid_entries, evmcs_enabled, syndbg_enabled);
>+		free(hv_cpuid_entries);
>+		kvm_vm_free(vm);
> 	}
> 
>-	vcpu_enable_evmcs(vm, VCPU_ID);
>-
>-	hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm);
>-	if (!hv_cpuid_entries)
>-		return 1;
>-
>-	test_hv_cpuid(hv_cpuid_entries, 1);
>-
>-	free(hv_cpuid_entries);
>-
>-vm_free:
>-	kvm_vm_free(vm);
>-
> 	return 0;
> }
>-- 
>2.25.1
>

