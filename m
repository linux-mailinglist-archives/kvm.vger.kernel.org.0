Return-Path: <kvm+bounces-4095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AACD480D9B8
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 19:56:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 567721F21A53
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 18:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E798A524BF;
	Mon, 11 Dec 2023 18:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fzpXb/RU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A072ABD
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 10:56:12 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-dbc7fce330cso1664852276.1
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 10:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702320972; x=1702925772; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IFjg9I3v2Rsa7VKs1XrcNPB97hOFSlELTlvyiZA/SWY=;
        b=fzpXb/RUPDgEHc448zxkC9ksNdTBMjANUDXaSHht6UCjaNmPZlKK/oN/OAvwJR2D2n
         /kJPOTNWLH6pWhH2Txg5n7TU2riOd/q6hEa7+H5sd1XbS9q1fyW1bifFheYdEQh3/7s8
         R4OXJNudAqKWi6HXZKd1+OezxaWfa1l7rmBIAYwdQQLnwdpSDYeSZbo4tOfRecnhTVlN
         p4D5ep5NYRjvtfjhLbW3iD9pQSdPwbRBYxgt3LWtRjHaWkQJSuGi12wulxLXdaJSHqfO
         BhLpeMlp8oFGjKV6KhgfwgbVD1uYM8JuDpYoBA5jyXS2tJ5MQVqFcoN+7dmN1GwxQIQb
         EFpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702320972; x=1702925772;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IFjg9I3v2Rsa7VKs1XrcNPB97hOFSlELTlvyiZA/SWY=;
        b=EN6EgJQsDMoWSVf6ByG6xQpfAMoDq2r8Fxy4LJkcm4VtygHTG9cygg/vSfhUMLColc
         bAwVLMoA1/pNqrmDTa2duKVtbNH/1pDaqwSzBQtOxTfYySA/nOk/uxFAOdZm6Hu1Bkw8
         5D3OrbeAeRzvRVFmHWznhwApMG2YMCY0oUw9+fETNpSpAPrRL4VvXCvwrwfZKKHVaXOK
         P6XASlmgkVtbd+pd8BqgVid8XX6Z/gZsxmIHuVv5vFLco0+GilvQvlfVbM0P6w66Eoa3
         NBFAw2+0gE7u8FAeVPPtSLcVlfGMDmLN3vs5mnXZEMQgfTmtRnfWm9C30+Z6zJuhPR9I
         GQXQ==
X-Gm-Message-State: AOJu0YyglTUU+gPZhbw2osBg6IbyDCjpuBNSdO0JJzxCLyoRqqGagLaA
	yBsL8E3Q0pEf/01iex7RVVdrn96JkVo5+A==
X-Google-Smtp-Source: AGHT+IEvE4TIXnYhdyyFGBMiYt35+/TxrLg6ExyrYjbz+4DQSwVZEuJWEzK3m6DkOMobAqb64QE1CO36CPJRUw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a05:6902:cc8:b0:dbc:1b8a:8b7a with SMTP
 id cq8-20020a0569020cc800b00dbc1b8a8b7amr38403ybb.4.1702320971753; Mon, 11
 Dec 2023 10:56:11 -0800 (PST)
Date: Mon, 11 Dec 2023 10:55:47 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231211185552.3856862-1-jmattson@google.com>
Subject: [kvm-unit-tests PATCH 0/5] nVMX: Simple posted interrupts test
From: Jim Mattson <jmattson@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, pbonzini@redhat.com
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

I reported recently that commit 26844fee6ade ("KVM: x86: never write to
memory from kvm_vcpu_check_block()") broke delivery of a virtualized posted
interrupt from an L1 vCPU to a halted L2 vCPU (see
https://lore.kernel.org/all/20231207010302.2240506-1-jmattson@google.com/).
The test that exposed the regression is the final patch of this series. The
others are prerequisites.

It would make sense to add "vmx_posted_interrupts_test" to the set of tests
to be run under the unit test name, "vmx_apicv_test," but that is
non-trivial. The vmx_posted_interrupts_test requires "smp = 2," but I find
that adding that to the vmx_apicv_tests causes virt_x2apic_mode_test to
fail with:

FAIL: x2apic - reading 0x310: x86/vmx_tests.c:2151: Assertion failed: (expected) == (actual)
	LHS: 0x0000000000000012 - 0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0001'0010 - 18
	RHS: 0x0000000000000001 - 0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0001 - 1
Expected VMX_VMCALL, got VMX_EXTINT.
	STACK: 406ef8 40725a 41299f 402036 403f59 4001bd

I haven't investigated.


Jim Mattson (1):
  nVMX: Enable x2APIC mode for virtual-interrupt delivery tests

Marc Orr (Google) (3):
  nVMX: test nested "virtual-interrupt delivery"
  nVMX: test nested EOI virtualization
  nVMX: add self-IPI tests to vmx_basic_vid_test

Oliver Upton (1):
  nVMX: add test for posted interrupts

 lib/x86/apic.h       |   5 +
 lib/x86/asm/bitops.h |   8 +
 x86/unittests.cfg    |  10 +-
 x86/vmx_tests.c      | 423 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 445 insertions(+), 1 deletion(-)

-- 
2.43.0.472.g3155946c3a-goog


