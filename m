Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6B2142E80
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 16:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgATPLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 10:11:47 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50590 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726642AbgATPLr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jan 2020 10:11:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579533105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Jl75FyV2eKAuNVkPFCRLduCG2Tj/ztsoq3xLT8s1OKA=;
        b=K7Q8MY/KgiUi7P93izqgMkTW1FW03GC3wYq+6yrfeaKLqxa6kQgAESG3OWN5H1+TdBCa83
        +zVt5VFsF53FGYdrfo0vPdjx2USDLX9bNpyGCQZ/hirenYeWFhj0Ef1jwGKqFr9bzJTCbV
        zm0TcnyG2MDVFPdJsK1//moXCdY0GEg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-QI0UbABzNy28ZPMzfKuWqA-1; Mon, 20 Jan 2020 10:11:44 -0500
X-MC-Unique: QI0UbABzNy28ZPMzfKuWqA-1
Received: by mail-wr1-f71.google.com with SMTP id f17so14284201wrt.19
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2020 07:11:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jl75FyV2eKAuNVkPFCRLduCG2Tj/ztsoq3xLT8s1OKA=;
        b=IvXWOHSbQj/KdkrdhkrJoyhNEhAyS6vxtgYfVc4bK+UngDhOl7OQNIAllAD9oQHQQ5
         u+F9vK89Asi+nBl1ulke2vHyjYAy+TA/ACqCOlAbhG3Vli8XydMCwF1tpYuu6q0OLQJ3
         n/Z5M5bUeblmREabSo1qGRbSVAhIImugJQI4Y+z00pkSsGqgxzXuDnXa+/JMeEeLLsjS
         OOqCPLH11xfVsBqt7W5HGRib6zQiBv5/9+bNVW1iNbehjoVqlg9imp9nzTQpXjrgpRDp
         +gjNUr93p9DRVybXhEkDEAJoKt0xv9KWTWZ6398jYc0PKPKeYuEFsEyH/esuaNEyzl6p
         Pj8w==
X-Gm-Message-State: APjAAAW6DUgm0HK9Tns0n+v1/65E2LVT9jM6JUVyU02gTLSOs72ZDt3U
        /JR8b1KD5Mbnh5OvIE/D0MoQm8hWtxnh830wIFx9O2amAizde+1NftcGbWMRexxCSLQLg8DK7DI
        YiqSLqbVyx28S
X-Received: by 2002:a5d:6144:: with SMTP id y4mr18472334wrt.15.1579533103594;
        Mon, 20 Jan 2020 07:11:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqwozBAXQphYzllCmalCwNBWOVy6u0dZCaSjZL8FjTnS+D47H1/1MzPh9W3DbIpfjfStE25Mbw==
X-Received: by 2002:a5d:6144:: with SMTP id y4mr18472310wrt.15.1579533103369;
        Mon, 20 Jan 2020 07:11:43 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id y20sm833707wmi.25.2020.01.20.07.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 07:11:42 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>
Subject: [RFC] Revert "kvm: nVMX: Restrict VMX capability MSR changes"
Date:   Mon, 20 Jan 2020 16:11:41 +0100
Message-Id: <20200120151141.227254-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This reverts commit a943ac50d10aac96dca63d0460365a699d41fdd0.

Fine-grained VMX feature enablement in QEMU broke live migration with
nested guest:

 (qemu) qemu-kvm: error: failed to set MSR 0x48e to 0xfff9fffe04006172

The problem is that QEMU does KVM_SET_NESTED_STATE before KVM_SET_MSRS,
although it can probably be changed.

RFC. I think the check for vmx->nested.vmxon is legitimate for everything
but restore so removing it (what I do with the revert) is likely a no-go.
I'd like to gather opinions on the proper fix: should we somehow check
that the vCPU is in 'restore' start (has never being run) and make
KVM_SET_MSRS pass or should we actually mandate that KVM_SET_NESTED_STATE
is run after KVM_SET_MSRS by userspace?

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4aea7d304beb..bb8afe0c5e7f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1321,13 +1321,6 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	/*
-	 * Don't allow changes to the VMX capability MSRs while the vCPU
-	 * is in VMX operation.
-	 */
-	if (vmx->nested.vmxon)
-		return -EBUSY;
-
 	switch (msr_index) {
 	case MSR_IA32_VMX_BASIC:
 		return vmx_restore_vmx_basic(vmx, data);
-- 
2.24.1

