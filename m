Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2974DA44E
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 22:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344572AbiCOVFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 17:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237862AbiCOVFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 17:05:06 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE3532043;
        Tue, 15 Mar 2022 14:03:53 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id z3so157142plg.8;
        Tue, 15 Mar 2022 14:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2S1vKrodTPj0beAXtPYJjM5KYwEQpjwd/LYAjdYuoww=;
        b=BGu4z5+PIndZT8KU6V8POD8KqZM/yBbhBZ26PEopHrWwbDM7+sQSNvA4t6BEpaeXeC
         IBYTNy5+e7iAssJCEVbTbYs3X7Jk+xs3h5IVNK/6WiXfa+68oy6oaxewfkwaKtTRlaDV
         Ej4Tlv3JRsyHb3n/2kU7S+zKYeAfhvTbS7FMjwfBDwN8Ex8Uy8eX3xc2DE/nMM6kMuYg
         0UjVqCbwzY1UnimI/8XbXVJDNC2eOlYqEvgfaaK3nchI8SflRq4yHKBg0Nhb/5Az6QYj
         EEK8PHP3p4TKHwvD1AZcDhiA452ycGKFgMZgnBnl8gY3+wfmlLCEtcaGDl1flK/rpaw1
         XaDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2S1vKrodTPj0beAXtPYJjM5KYwEQpjwd/LYAjdYuoww=;
        b=7bxBlBgXQOr1kN53EjKZOc1juL0XvgPqMvZC/uO0946fjfsznpWagutwg5oME6RmUQ
         3Xu/NxMJ272FOVi+4MaWsqp5SwfvERo5uu2A3qmCZGlUL5y40VdvExxucw2YeOF2JQCM
         VSPqVs8zKUzl1LejP652i0haQY3Wrlhf4Po9w/Ti7KrMrexE40Wdk7gmZsOFBvga94OI
         1hgCtorv6YcUZXj7ne0Kly7Nxqq6brQLSlm6JHEXDcBe8n2npylRAC1ScYEqRTzWW3TV
         i9sqW7lNvbusOxiD3u6r1kT2cS3rvpJtVLSccIXT+b6mQ5G0Kbfg2cUyA/hMJku6KhGq
         6MYQ==
X-Gm-Message-State: AOAM533r/eao/ZlhUSG6HU5hMP6jvnVPar3/CJaG/giwL14vQ+NY6RWv
        E1fEV0zMf0S/MnbO4dRRfP8=
X-Google-Smtp-Source: ABdhPJxfCYyF4CYcUWYTz493jWdYPQ8nlKCEOPGlTw5prrKIDMvoX9y86TdKwm+oQG1SokVQCmgiSQ==
X-Received: by 2002:a17:902:76ca:b0:153:ad09:9c73 with SMTP id j10-20020a17090276ca00b00153ad099c73mr2352138plt.63.1647378232846;
        Tue, 15 Mar 2022 14:03:52 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id j17-20020a634a51000000b00378f9c90e66sm150745pgl.39.2022.03.15.14.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 14:03:52 -0700 (PDT)
Date:   Tue, 15 Mar 2022 14:03:50 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 010/104] KVM: TDX: Make TDX VM type supported
Message-ID: <20220315210350.GE1964605@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <0596db2913da40660e87d5005167c623cee14765.1646422845.git.isaku.yamahata@intel.com>
 <18a150fd2e0316b4bae283d244f856494e0dfefd.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18a150fd2e0316b4bae283d244f856494e0dfefd.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 14, 2022 at 12:08:59PM +1300,
Kai Huang <kai.huang@intel.com> wrote:

> On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > As first step TDX VM support, return that TDX VM type supported to device
> > model, e.g. qemu.  The callback to create guest TD is vm_init callback for
> > KVM_CREATE_VM.  Add a place holder function and call a function to
> > initialize TDX module on demand because in that callback VMX is enabled by
> > hardware_enable callback (vmx_hardware_enable).
> 
> Should we put this patch at the end of series until all changes required to run
> TD are introduced?  This patch essentially tells userspace KVM is ready to
> support a TD but actually it's not ready.  And this might also cause bisect
> issue I suppose?

The intention is that developers can exercise the new code step-by-step even if
the TDX KVM isn't complete.
How about introducing new config and remove it at the last of the patch series?

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2b1548da00eb..a3287440aa9e 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -98,6 +98,20 @@ config X86_SGX_KVM
 
          If unsure, say N.
 
+config X86_TDX_KVM_EXPERIMENTAL
+       bool "EXPERIMENTAL Trust Domian Extensions (TDX) KVM support"
+       default n
+       depends on INTEL_TDX_HOST
+       depends on KVM_INTEL
+       help
+         Enable experimental TDX KVM support.  TDX KVM needs many patches and
+         the patches will be merged step by step, not at once. Even if TDX KVM
+         support is incomplete, enable TDX KVM support so that developper can
+         exercise TDX KVM code.  TODO: Remove this configuration once the
+         (first step of) TDX KVM support is complete.
+
+         If unsure, say N.
+
 config KVM_AMD
        tristate "KVM for AMD processors support"
        depends on KVM
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b16e2ed3b204..e31d6902e49c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -170,7 +170,11 @@ int tdx_module_setup(void)
 
 bool tdx_is_vm_type_supported(unsigned long type)
 {
+#ifdef CONFIG_X86_TDX_KVM_EXPERIMENTAL
        return type == KVM_X86_TDX_VM && READ_ONCE(enable_tdx);
+#else
+       return false;
+#endif
 }
 
 static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
