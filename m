Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75E75847DC
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 23:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiG1VwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 17:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiG1VwJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 17:52:09 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE5274CF6;
        Thu, 28 Jul 2022 14:52:08 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id v67-20020a1cac46000000b003a1888b9d36so3266747wme.0;
        Thu, 28 Jul 2022 14:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jpGgxpvIkQO/n6ZLfYcCHWOvaxvfkFkGsZvzYRkRkOM=;
        b=HkqMq3F9Zijhh8GQqz1TDPHmUggiWtS+p7HkNeSMuGe3YL+ZU4pBgRO9MEwVDkcMCN
         Qg2esrY5PT610qXupRVPrK3TkX3rO8yhUUXxtPuM1HtAXGmvrT1VZpzy19K+uzGTV+5T
         b17g3EOn5VYywzT3WVK82YlnKZdc9Jj1R3xkuFZj4yhthqJAZHSLlMXAuzNcWB7Z9IVe
         G3h81kpc2lsRNsDchtYA8C2u2kO/DRKlgZg+NyNCP6JFSPGX9tCyQa1IiHkoermbh0BU
         74OkGMIeMz3ND1lpQn24LN3HwJ4ifROHUIz9lHXL5OmPAubGK+E+vZXGcIO53UP/IFsb
         CMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jpGgxpvIkQO/n6ZLfYcCHWOvaxvfkFkGsZvzYRkRkOM=;
        b=1Qx3e+BFxKjdfmUIWgCPdzviojS6fQAhpoXh2Ql0W92GC/fWqvLRlxQE29krq/rMYB
         CXK1T/KDT9nZkOy464ah6/qP7FSdr0RPKhSxqxumumQKHCfbaYJVbjmnIB9vz59yXUTI
         D2iqA13XxDhdeCWVqhE3d7vU/guXpxz71STv0EohzmQmcyQTJXmMhWToMmJzYQkqNua4
         +dT7MoJN2HhWO8/5hv6wTTQFM9HU5Nd2rweZbbxE7eaukt3GcGR72HgRGDDTAFuTQbMu
         nhDOqoL9eF7Jygret8AL2GZNf9ZrbGcijZZSMYgmd/vzpxh3FucX13TF69pL81vTGx3g
         hxuQ==
X-Gm-Message-State: AJIora/TTG+yVdf2k20wPmH+xu6DEvdFIyAI77z5t9I+EN4FCevTS44M
        R3Ij61MeVtG6xLjDV+AFjxY=
X-Google-Smtp-Source: AGRyM1sAevvI0bWd8zojOxlCumrwh1t9w1gBtRi97GF3WwlMDOtJolKBur/qzslKsHNLxv+i98NB9A==
X-Received: by 2002:a05:600c:34c9:b0:3a3:561d:4f32 with SMTP id d9-20020a05600c34c900b003a3561d4f32mr501144wmq.30.1659045127126;
        Thu, 28 Jul 2022 14:52:07 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id o9-20020a05600c4fc900b003a31c4f6f74sm7716574wmq.32.2022.07.28.14.52.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 14:52:06 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <870d507d-a516-5601-4d21-2bfd571cf008@redhat.com>
Date:   Thu, 28 Jul 2022 23:52:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 09/25] KVM: VMX: nVMX: Support TSC scaling and
 PERF_GLOBAL_CTRL with enlightened VMCS
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-10-vkuznets@redhat.com> <YtnMIkFI469Ub9vB@google.com>
 <48de7ea7-fc1a-6a83-3d6f-e04d26ea2f05@redhat.com>
 <Yt7ehL0HfR3b97FQ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yt7ehL0HfR3b97FQ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/25/22 20:18, Sean Christopherson wrote:
>> I kind of like the idea of having a two-dimensional array based on the enums
>> instead of switch statements, so for now I'll keep Vitaly's enums.
> I don't have a strong opinion on using a 2d array, but unless I'm missing something,
> that's nowhere to be found in this patch.  IMO, having the enums without them
> providing any unique value is silly and obfuscates the code.

Yeah, like this:

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index d8da4026c93d..8055128d8638 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -342,9 +342,10 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
  	return 0;
  }
  
-enum evmcs_v1_revision {
+enum evmcs_revision {
  	EVMCSv1_2016,
  	EVMCSv1_2022,
+	EVMCS_REVISION_MAX,
  };
  
  enum evmcs_unsupported_ctrl_type {
@@ -353,13 +354,37 @@ enum evmcs_unsupported_ctrl_type {
  	EVMCS_2NDEXEC,
  	EVMCS_PINCTRL,
  	EVMCS_VMFUNC,
+	EVMCS_CTRL_MAX,
+};
+
+static u32 evmcs_unsupported_ctls[EVMCS_CTRL_MAX][EVMCS_REVISION_MAX] = {
+	[EVMCS_EXIT_CTLS] = {
+		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_VMEXIT_CTRL | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,
+		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_VMEXIT_CTRL,
+	},
+	[EVMCS_ENTRY_CTLS] = {
+		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_VMENTRY_CTRL | VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
+		[EVMCSv1_2022] =  EVMCS1_UNSUPPORTED_VMENTRY_CTRL,
+	},
+	[EVMCS_2NDEXEC] = {
+		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_2NDEXEC | SECONDARY_EXEC_TSC_SCALING,
+		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_2NDEXEC,
+	},
+	[EVMCS_PINCTRL] = {
+		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_PINCTRL,
+		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_PINCTRL,
+	},
+	[EVMCS_VMFUNC] = {
+		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_VMFUNC,
+		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_VMFUNC,
+	},
  };
  
  static u32 evmcs_get_unsupported_ctls(struct kvm_vcpu *vcpu,
  				      enum evmcs_unsupported_ctrl_type ctrl_type)
  {
  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
-	enum evmcs_v1_revision evmcs_rev = EVMCSv1_2016;
+	enum evmcs_revision evmcs_rev = EVMCSv1_2016;
  
  	if (!hv_vcpu)
  		return 0;
@@ -367,32 +392,7 @@ static u32 evmcs_get_unsupported_ctls(struct kvm_vcpu *vcpu,
  	if (hv_vcpu->cpuid_cache.nested_ebx & HV_X64_NESTED_EVMCS1_2022_UPDATE)
  		evmcs_rev = EVMCSv1_2022;
  
-	switch (ctrl_type) {
-	case EVMCS_EXIT_CTLS:
-		if (evmcs_rev == EVMCSv1_2016)
-			return EVMCS1_UNSUPPORTED_VMEXIT_CTRL |
-				VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
-		else
-			return EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
-	case EVMCS_ENTRY_CTLS:
-		if (evmcs_rev == EVMCSv1_2016)
-			return EVMCS1_UNSUPPORTED_VMENTRY_CTRL |
-				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
-		else
-			return EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
-	case EVMCS_2NDEXEC:
-		if (evmcs_rev == EVMCSv1_2016)
-			return EVMCS1_UNSUPPORTED_2NDEXEC |
-				SECONDARY_EXEC_TSC_SCALING;
-		else
-			return EVMCS1_UNSUPPORTED_2NDEXEC;
-	case EVMCS_PINCTRL:
-		return EVMCS1_UNSUPPORTED_PINCTRL;
-	case EVMCS_VMFUNC:
-		return EVMCS1_UNSUPPORTED_VMFUNC;
-	}
-
-	return 0;
+	return evmcs_unsupported_ctls[ctrl_type][evmcs_rev];
  }
  
  void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)

Paolo
