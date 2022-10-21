Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800EB607F8E
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 22:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiJUUNe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 16:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiJUUNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 16:13:32 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6209C29E99A
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:13:31 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id 10so3371213pli.0
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SsTrKyn4D6bUIajE0OuRcI1eQtyN8Db+ITFw4jj2MPM=;
        b=KEbIkqbaFppP5trnLE3+Bq6MI1q5c4gTevgjr1cuDmInMwjCCGQzAQYqNOvb2IGv9+
         8pBQN+rrJMfDOOfKOqiY4AetSsT5QQNB5tH0FLHKyvuC0wibPylmafhvzIwRH824efVz
         RQK1RdhVxTNUWGKArm3L1eux9n3X4c2Mgznfnh88INuWMq3AZqYoj626iQxOJWiop/wq
         sk7jloKq2UhvQ6TRdHGGc8gfO2xlVS34r4L5kMVT4KQ/imoNTmsVlDdPd07AWpVuuIn+
         oAPr3qWgRSvCzraPR05esOCe5BU90qd1gnDZWxTN/yQDOWEddbkHiXtPqo11VMBSyMM1
         3BXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SsTrKyn4D6bUIajE0OuRcI1eQtyN8Db+ITFw4jj2MPM=;
        b=OdfI2sPcChC4e14LlWE4wVHQTp3NxW80n2SWAwb2F0GplUJQfviFLqBTcnvlTnLnHm
         gYBErQNDokSsMwV5669ngZijD6kabIL7PYhAagLaxV7WoUsLxPc+FhVIRILppAEtVgo+
         9iHD5ciUsHifK4VmyPOLRCOdLGfXCRjvhu0OD7swun3N+6FDLJ1Lqw1f7f9AoYacw+yP
         pbyU3xMmYOPxxHdLwAzToPhe/lbCBchjEy35soV4yFHPbNvW8oa9KOa1EKF1v4VijKbb
         9e1ViM5sYnd3SKMU189mvLbC218ZmS2fJTa1kUlAuQwaC4QXr0zv+RUNQlKfpapw3le1
         hXyQ==
X-Gm-Message-State: ACrzQf2tIXsMLya/42nTEVrwAb/d+0lbWVtKgofxjCT1znLMvG5SPWVk
        R4xjLNw8n7n3+V+SOjW5TKp/lg==
X-Google-Smtp-Source: AMsMyM6gDlDqchxuAvlSVTovrxJg6Ns53+Pr2a+hXKGM4UEFJD4Hp3hXH/8Qi2uTBQm3FyOYcClOGA==
X-Received: by 2002:a17:903:22c8:b0:17f:7039:a2d4 with SMTP id y8-20020a17090322c800b0017f7039a2d4mr21566760plg.2.1666383210794;
        Fri, 21 Oct 2022 13:13:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h190-20020a6283c7000000b00561578478f9sm15430062pfe.134.2022.10.21.13.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 13:13:30 -0700 (PDT)
Date:   Fri, 21 Oct 2022 20:13:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     vkuznets@redhat.com, pbonzini@redhat.com, dmatlack@google.com,
        kvm@vger.kernel.org, shujunxue@google.com, terrytaehyun@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Add Hyperv extended hypercall support in KVM
Message-ID: <Y1L9Z8RgIs8yrU6o@google.com>
References: <20221021185916.1494314-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021185916.1494314-1-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 21, 2022, Vipin Sharma wrote:
> Hyperv hypercalls above 0x8000 are called as extended hypercalls as per
> Hyperv TLFS. Hypercall 0x8001 is used to enquire about available
> hypercalls by guest VMs.
> 
> Add support for HvExtCallQueryCapabilities (0x8001) and
> HvExtCallGetBootZeroedMemory (0x8002) in KVM.
> 
> A guest VM finds availability of HvExtCallQueryCapabilities (0x8001) by
> using CPUID.0x40000003.EBX BIT(20). If the bit is set then the guest VM
> make hypercall HvExtCallQueryCapabilities (0x8001) to know what all
> extended hypercalls are supported by hypervisor.
> 
> A userspace VMM can query capability KVM_CAP_HYPERV_EXT_CALL_QUERY to
> know which extended hypercalls are supported in KVM. After which the
> userspace will enable capabilities for the guest VM.
> 
> HvExtCallQueryCapabilities (0x8001) is handled by KVM in kernel,

Does this really need to be handle by KVM?  I assume this is a rare operation,
e.g. done once during guest boot, so performance shouldn't be a concern.  To
avoid breaking existing userspace, KVM can forward HV_EXT_CALL_GET_BOOT_ZEROED_MEMORY
to userspace if and only if HV_ENABLE_EXTENDED_HYPERCALLS is enabled in CPUID,
but otherwise KVM can let userspace deal with the "is this enabled" check.

Aha!  And if KVM "allows" all theoretically possible extended hypercalls, then
KVM will never need a capability to announce "support" for a new hypercall, i.e.
define KVM's ABI to be that KVM punts all possible extended hypercalls to userspace
if CPUID.0x40000003.EBX BIT(20) is enabled.

> whereas, HvExtCallGetBootZeroedMemory (0x8002) is passed to userspace
> for further action.
> 
> Change-Id: Ib3709fadbf11f91be2842c8486bcbe755e09cbea

Drop gerrit's Change-Id when posting publicly.

If KVM punts the support checks to userspace, then the KVM side of things is very
minimal and future proof (unless Microsoft hoses us).  E.g. with code deduplication
that should be moved to a prep patch:

---
 arch/x86/kvm/hyperv.c | 43 +++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 0adf4a437e85..f9253249de00 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2138,6 +2138,12 @@ static void kvm_hv_hypercall_read_xmm(struct kvm_hv_hcall *hc)
 	kvm_fpu_put();
 }
 
+/*
+ * The TLFS carves out 64 possible extended hypercalls, numbered sequentially
+ * after the base capabilities extended hypercall.
+ */
+#define HV_EXT_CALL_MAX (HV_EXT_CALL_QUERY_CAPABILITIES + 64)
+
 static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
 {
 	if (!hv_vcpu->enforce_cpuid)
@@ -2178,6 +2184,10 @@ static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
 	case HVCALL_SEND_IPI:
 		return hv_vcpu->cpuid_cache.enlightenments_eax &
 			HV_X64_CLUSTER_IPI_RECOMMENDED;
+	case HV_EXT_CALL_QUERY_CAPABILITIES ... HV_EXT_CALL_MAX:
+		return hv_vcpu->cpuid_cache.features_ebx &
+		       HV_ENABLE_EXTENDED_HYPERCALLS;
+		break;
 	default:
 		break;
 	}
@@ -2270,14 +2280,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
-		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
-		vcpu->run->hyperv.u.hcall.input = hc.param;
-		vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
-		vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
-		vcpu->arch.complete_userspace_io =
-				kvm_hv_hypercall_complete_userspace;
-		return 0;
+		goto hypercall_userspace_exit;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
 		if (unlikely(hc.var_cnt)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
@@ -2336,15 +2339,14 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 			ret = HV_STATUS_OPERATION_DENIED;
 			break;
 		}
-		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
-		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
-		vcpu->run->hyperv.u.hcall.input = hc.param;
-		vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
-		vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
-		vcpu->arch.complete_userspace_io =
-				kvm_hv_hypercall_complete_userspace;
-		return 0;
+		goto hypercall_userspace_exit;
 	}
+	case HV_EXT_CALL_QUERY_CAPABILITIES ... HV_EXT_CALL_MAX:
+		if (unlikely(hc.fast)) {
+			ret = HV_STATUS_INVALID_PARAMETER;
+			break;
+		}
+		goto hypercall_userspace_exit;
 	default:
 		ret = HV_STATUS_INVALID_HYPERCALL_CODE;
 		break;
@@ -2352,6 +2354,14 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 
 hypercall_complete:
 	return kvm_hv_hypercall_complete(vcpu, ret);
+hypercall_userspace_exit:
+	vcpu->run->exit_reason = KVM_EXIT_HYPERV;
+	vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
+	vcpu->run->hyperv.u.hcall.input = hc.param;
+	vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
+	vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
+	vcpu->arch.complete_userspace_io = kvm_hv_hypercall_complete_userspace;
+	return 0;
 }
 
 void kvm_hv_init_vm(struct kvm *kvm)
@@ -2494,6 +2504,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 			ent->ebx |= HV_POST_MESSAGES;
 			ent->ebx |= HV_SIGNAL_EVENTS;
+			ent->ebx |= HV_ENABLE_EXTENDED_HYPERCALLS;
 
 			ent->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
 			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;

base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
-- 

