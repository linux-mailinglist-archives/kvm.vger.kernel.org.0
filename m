Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EFF2665AE
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 19:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgIKRJr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 13:09:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51010 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726325AbgIKRJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 13:09:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599844172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T4JkIThZtF0RdLNQoUDiKXmb6/K82XCLQ+U784yJ8XQ=;
        b=F9ZUZWFUZjo8kEwRxJ8VV35BtpY/mTbRr+mJyFFRjhCrhPYVpkT1pZs+6PFZdlXv4+x3nf
        3O0vOT2SJgKVmHU0D6IDrNaSG1osUsTpN2VJOqg1QiVJ2C26N92tlnaQhLUGzztkeExV77
        5bKZ/755wOAw3nqRXdWBpBVXyHw5VHU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-wtvWYRXIOdO4ovj_Pq1a1Q-1; Fri, 11 Sep 2020 13:09:31 -0400
X-MC-Unique: wtvWYRXIOdO4ovj_Pq1a1Q-1
Received: by mail-wm1-f69.google.com with SMTP id 189so1603154wme.5
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 10:09:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T4JkIThZtF0RdLNQoUDiKXmb6/K82XCLQ+U784yJ8XQ=;
        b=cl3luibhKGhgE/8cpcEqrkm5VNMzKiG22VP7LST4T0/WzOP95XSAoC0vmsE12W2/78
         et+UOYZvoyfBFIcdS29ROcOUQ7N+vK5zOcHNJmY5QvQSpnLE33K7aiab9Akgnjy9VylI
         gPIg5Rsth1HH2MpBSZwgahWaFrMI9Yj6FI/5h/jBu5Wj+WMTsrpomJ8wZzyL5xE64kW3
         8wW15h+kOEbP+xuAknCtSX5F2dJzSHQLeq26cHZARyPgG2aFyBkiAsRhS5U9NTUsaB7A
         osp6BWz4uZOrYJWprlF96a08swebPlZ+bqK6puQAQsSYz++DcvLTGE1lGAdb5zifJjaQ
         cOJA==
X-Gm-Message-State: AOAM532cGZWcYUPzPO3iHGRKMyve0E4kzpp7d/+m85XGhvhmM+r+feeC
        1VMqznzXMQxqjFZ01j3BvmIm09NCpaGGKnSx66TTjhYJyMfmUPsO9JqRbPSxsEO7+cj5ixgCSOJ
        PALkUVNWcczto
X-Received: by 2002:adf:dc47:: with SMTP id m7mr3015657wrj.100.1599844169876;
        Fri, 11 Sep 2020 10:09:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwczH9Dx0QGmo22EabGrVoHI/zSCsT2tl8ywMWc8JG8GxewXLpB+lnrqf4g6SwjPrJb6CVimw==
X-Received: by 2002:adf:dc47:: with SMTP id m7mr3015629wrj.100.1599844169608;
        Fri, 11 Sep 2020 10:09:29 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id g12sm5838009wro.89.2020.09.11.10.09.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 10:09:29 -0700 (PDT)
Subject: Re: [PATCH 3/5] KVM: nVMX: Update VMX controls MSR according to guest
 CPUID after setting VMX MSRs
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20200828085622.8365-1-chenyi.qiang@intel.com>
 <20200828085622.8365-4-chenyi.qiang@intel.com>
 <CALMp9eT1makVq46TB-EtTPiz=Z_2DfhudJekrtheSsmwBc4pZA@mail.gmail.com>
 <20200902181654.GH11695@sjchrist-ice>
 <CALMp9eSv3SrsJigB6KQg+dyS9GmYYCbC5v6QCx3f09951VZidA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <48fd0fd9-97b4-471e-d8e8-628f51dcdeff@redhat.com>
Date:   Fri, 11 Sep 2020 19:09:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSv3SrsJigB6KQg+dyS9GmYYCbC5v6QCx3f09951VZidA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/09/20 20:32, Jim Mattson wrote:
> 
> /* If not VM_EXIT_CLEAR_BNDCFGS, the L2 value propagates to L1.  */
> if (vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)
>         vmcs_write64(GUEST_BNDCFGS, 0);
> 
> BTW, where does the L2 value propagate to L1 if not VM_EXIT_CLEAR_BNDCFGS?

Hmm, nowhere. :/  Probably something like this (not really thought through):

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1e903d51912b..aba76aa99465 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3317,7 +3317,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
 		vmx->nested.vmcs01_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
 	if (kvm_mpx_supported() &&
-		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
+	    (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS) ||
+	     !(vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)))
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
 	/*
@@ -4186,9 +4187,12 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	vmcs_write32(GUEST_IDTR_LIMIT, 0xFFFF);
 	vmcs_write32(GUEST_GDTR_LIMIT, 0xFFFF);
 
-	/* If not VM_EXIT_CLEAR_BNDCFGS, the L2 value propagates to L1.  */
-	if (vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)
-		vmcs_write64(GUEST_BNDCFGS, 0);
+	if (kvm_mpx_supported()) {
+		if (vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)
+			vmcs_write64(GUEST_BNDCFGS, 0);
+		else
+			vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
+	}
 
 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PAT) {
 		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
@@ -4466,6 +4470,10 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		vmx_set_virtual_apic_mode(vcpu);
 	}
 
+	/* If not VM_EXIT_CLEAR_BNDCFGS, the L2 value propagates to L1.  */
+	if (!(vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS))
+		vmx->nested.vmcs01_guest_bndcfgs = vmcs12->guest_bndcfgs;
+
 	/* Unpin physical memory we referred to in vmcs02 */
 	if (vmx->nested.apic_access_page) {
 		kvm_release_page_clean(vmx->nested.apic_access_page);


which will also work in the failed vmentry case.

Paolo

