Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2137267EF
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 20:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbjFGSGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 14:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbjFGSGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 14:06:20 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BB31FC3;
        Wed,  7 Jun 2023 11:06:19 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-543cc9541feso1695939a12.2;
        Wed, 07 Jun 2023 11:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686161179; x=1688753179;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dNZOQW0NCoas4gPFC5wTHJOoIFU7fDxZ/nxKSq1PJhQ=;
        b=EzXG8FZejiQggLwdU80YAYxhOHQ3W61ulrAQ7YtjhpMJPPtIt1zn46cbi9tBvhR3Z8
         86AQG/HM8xmInxbqPt4RVRTV727/oQng8nra2WNfDwTt0Nsg01b5CSJqe6Oj99YOEgBl
         QHPlKKc9vDWVt+Mh9fz0/hIxfqJj3UgI8NsQSGGRgCrc3hBpYKvAbSSQ/l/5wi144RVL
         smzXHMpyg30spox9mpiqirniVWP7/9YfL7S5lWhM6X8W1tNL6YrorsGKSCBXvXDbnZ56
         J/2Wg8HCkyVK7OX3cIDt5w8GIu/PnQio+ZAvY+UhDaLbOFF7nk19ichC07x767kgUANY
         Moyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686161179; x=1688753179;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dNZOQW0NCoas4gPFC5wTHJOoIFU7fDxZ/nxKSq1PJhQ=;
        b=cRPSTzPWckhuF/19qvzYkah6Ij1Ca+jQptfG6UQ8mF2COjSeM//xAcIgxpNVdw5mZv
         LmOeFYU6RbSorimmkqpJlNDikmF4YwU+d6hZhBJRmY7IufmIqQebTOhbtPC9+v+zZrPW
         DLcmKWAVug8C9GQ69T+tel3+vCWebcQO84TR58VsSTCHCNFYr50A/bFkHdFX0W95NNY7
         Qoyk0ugxvXzzcVMThgpi1VOFSB99DWAkz+nUKpXNINjnWBgcCc5Rz0CTcTeyOEQGZDAL
         rJbx+Ca4hh2Zaj4K0GePURb2T4qZ0Hsxlt3FiUYrq8HAfIDv6q8LHuYnsbk0mWvCXeVZ
         Bf7w==
X-Gm-Message-State: AC+VfDwzo3cOAvK68iii3EDNSRU4+R/zMSDOsK8X8yoyjoMS9EfHhfBp
        CYXaPHoa9QQng9JAGJRXknZv9wLKjKIqOw==
X-Google-Smtp-Source: ACHHUZ5u+e06Pc/bG2TuO5Gbe1MQD3aADnjNNtdrUv9WhSIDPvK+L/vlxGt4YpB9C4Q1mtiEPh4mVA==
X-Received: by 2002:a17:902:ab04:b0:1b2:1a78:fb5c with SMTP id ik4-20020a170902ab0400b001b21a78fb5cmr2214648plb.29.1686161178458;
        Wed, 07 Jun 2023 11:06:18 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id jk11-20020a170903330b00b001ac7c725c1asm10768610plb.6.2023.06.07.11.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 11:06:17 -0700 (PDT)
Date:   Wed, 7 Jun 2023 11:06:16 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chen, Bo2" <chen.bo@intel.com>, "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v14 004/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <20230607180616.GF2244082@ls.amr.corp.intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <e628e2d235d9b6c00b9bd5d81bb69136b77d13c4.1685333727.git.isaku.yamahata@intel.com>
 <3d8355ae582119486ac7ec129c4ba18d2cdf3ccb.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3d8355ae582119486ac7ec129c4ba18d2cdf3ccb.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023 at 04:19:33AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sun, 2023-05-28 at 21:18 -0700, Yamahata, Isaku wrote:
> > +static void __init vmx_tdx_on(void *info)
> > +{
> > +       atomic_t *err = info;
> > +       int r;
> > +
> > +       r = vmx_hardware_enable();
> > +       if (!r)
> > +	       r = tdx_cpu_enable();
> > +       if (r)
> > +	       atomic_set(err, r);
> > +}
> > +
> > +static void __init vmx_off(void *unused)
> > +{
> > +       vmx_hardware_disable();
> > +}
> > +
> > +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> > +{
> > +	atomic_t err = ATOMIC_INIT(0);
> > +	int r = 0;
> > +
> > +	if (!enable_ept) {
> > +		pr_warn("Cannot enable TDX with EPT disabled\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* tdx_enable() in tdx_module_setup() requires cpus lock. */
> > +	cpus_read_lock();
> > +	on_each_cpu(vmx_tdx_on, &err, true);	/* TDX requires vmxon. */
> > +	r = atomic_read(&err);
> > +	if (!r)
> > +		r = tdx_module_setup();
> > +	on_each_cpu(vmx_off, NULL, true);
> > +	cpus_read_unlock();
> > +
> > +	return r;
> > +}
> 
> As we discussed in v13, this code doesn't track which CPUs have run
> vmx_hardware_enable() successfully.  Thus if ...
> 
> 	on_each_cpu(vmx_tdx_on, &err, true);	/* TDX requires vmxon. */
> 
> ... fails on some cpu due to whatever reason, in ...
> 	
> 	on_each_cpu(vmx_off, NULL, true);
> 
> ... vmx_hardware_disable() will fail to do VMXOFF for those cpus that haven't
> done VMXON successfully yet, resulting in BUG_ON(!kvm_rebooting) being triggered
> in kvm_spurious_fault().
> 
> We need a per-cpu flag to track whether cpu has done VMXON successfully.

Thanks for pointing it out. The following is the fix.

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8a1d0755d275..b0d3f646afb1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -4499,26 +4499,39 @@ u64 tdx_non_arch_field_switch(u64 field)
 	}
 }
 
-static void __init vmx_tdx_on(void *info)
+struct vmx_tdx_enabled {
+	cpumask_var_t vmx_enabled;
+	atomic_t *err;
+};
+
+static void __init vmx_tdx_on(void *_vmx_tdx_on)
 {
-	atomic_t *err = info;
+	struct vmx_tdx_enabled *vmx_tdx = _vmx_tdx_on;
 	int r;
 
 	r = vmx_hardware_enable();
-	if (!r)
+	if (!r) {
+		cpumask_set_cpu(smp_processor_id(), vmx_tdx->vmx_enabled);
 		r = tdx_cpu_enable();
+	}
 	if (r)
-		atomic_set(err, r);
+		atomic_set(vmx_tdx->err, r);
 }
 
-static void __init vmx_off(void *unused)
+static void __init vmx_off(void *_vmx_enabled)
 {
-	vmx_hardware_disable();
+	cpumask_var_t vmx_enabled = *(cpumask_var_t *)_vmx_enabled;
+
+	if (cpumask_test_cpu(smp_processor_id(), vmx_enabled))
+		vmx_hardware_disable();
 }
 
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 {
 	atomic_t err = ATOMIC_INIT(0);
+	struct vmx_tdx_enabled vmx_tdx = {
+		.err = &err,
+	};
 	int max_pkgs;
 	int r = 0;
 	int i;
@@ -4582,6 +4595,11 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 	for (i = 0; i < max_pkgs; i++)
 		mutex_init(&tdx_mng_key_config_lock[i]);
 
+	if (!zalloc_cpumask_var(&vmx_tdx.vmx_enabled, GFP_KERNEL)) {
+		r = -ENOMEM;
+		goto out;
+	}
+
 	/* tdx_enable() in tdx_module_setup() requires cpus lock. */
 	cpus_read_lock();
 	/*
@@ -4592,12 +4610,15 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 	 */
 	if (!cpumask_equal(cpu_online_mask, cpu_present_mask))
 		pr_warn("The old TDX module requires all present CPUs to be online to initialize.\n");
-	on_each_cpu(vmx_tdx_on, &err, true);	/* TDX requires vmxon. */
-	r = atomic_read(&err);
+	on_each_cpu(vmx_tdx_on, &vmx_tdx, true);	/* TDX requires vmxon. */
+	r = atomic_read(vmx_tdx.err);
 	if (!r)
 		r = tdx_module_setup();
-	on_each_cpu(vmx_off, NULL, true);
+	else
+		r = -EIO;
+	on_each_cpu(vmx_off, vmx_tdx.vmx_enabled, true);
 	cpus_read_unlock();
+	free_cpumask_var(vmx_tdx.vmx_enabled);
 	if (r)
 		goto out;
 


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
