Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5835F0C80
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 15:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiI3NfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 09:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiI3NfL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 09:35:11 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3D74507A
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 06:35:09 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id lx7so4320513pjb.0
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 06:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=drulgaQumTg7MUqb+eavC3/aY6f7GE0YABILoSPZ2z0=;
        b=hAnbGiHo1W+6K3Yt48uLtqXxiJLLL+uLW8X05fbm9BieSLrWVYYT+9Y6shsWYth0X1
         YcSiE8imaKHFDjYwOdG5lb5T50tXrIzILHa3poODj5Hv3oVemuGaAjAb5TZlbbdAq0ug
         EIs3xrlIdvv9dt4DFO88Ko25GEyjZF9VwSnvFuznGU41Tkh3LH9gMutY4NlwKId0xWOs
         1lhBK7j0aKJHA4kO+b2o7zwrgLXVVkAcFDSLTWcbf/InyQJLN9e58ic1QajarQlut1lv
         D5fm+drWdLsju2qcwaFTiDje/8llSuCeHGv4Pny44stTIQtJYC+E1Da6mlaprDg5JHrb
         g2kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=drulgaQumTg7MUqb+eavC3/aY6f7GE0YABILoSPZ2z0=;
        b=OTbHic+IECXPsGwW0c4ef7X72cIEBN3+T5KgD9wKMfXE7MsEc2H/xszuN+/iwh4pCs
         CfHY591Q6VBxEkkxMcusVUgC2xsyBsfsQS4O12ZVmLZPeQjUCkQpnYjyTYHOFEXXIU7h
         jtQXghmPr/JlLTj5iW5D+/70Jqx+g1JYYX8sAIHIwfk0eMuGY+AEkx7ITeNZEZgXPUlZ
         FSbRjzIkZs1Fgd6ITBKB2tGRzj8Kys2PoF0umvosmYvb6pB7OuCWtx4sSb19eV7WSETx
         aU9ifk0jPqNNxysvHXbfI0HAbXeIcxl/Uq0dCBnTEMiq2L2Q1gVQ/tXjeJlg9DY6zf4d
         WJzQ==
X-Gm-Message-State: ACrzQf1XSjoV7Zz7GZji3SQDoM4YqFtG7qtIBweBeRf2MFEGvoiXKuLu
        ouMSt0G64r6h3VVPVC6/pXN12CP2U5BYkQ==
X-Google-Smtp-Source: AMsMyM5bdW7Mt7zvcFFsXTxRhxd4EfYJJ8wgSnTXZHN85zNKy7g0pgN5a9IMKO45A/h7b26jggIz7Q==
X-Received: by 2002:a17:902:e944:b0:179:dee4:f115 with SMTP id b4-20020a170902e94400b00179dee4f115mr9185623pll.141.1664544908987;
        Fri, 30 Sep 2022 06:35:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w2-20020a17090a380200b0020255f4960bsm5344760pjb.24.2022.09.30.06.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 06:35:05 -0700 (PDT)
Date:   Fri, 30 Sep 2022 13:35:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     kernel test robot <yujie.liu@intel.com>
Cc:     lkp@lists.01.org, lkp@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>
Subject: Re: [KVM] 7055fb1131:
 WARNING:at_arch/x86/kvm/x86.c:#inject_pending_event[kvm]
Message-ID: <YzbwhXJnQQPpFm7Q@google.com>
References: <202209301338.aca913c3-yujie.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202209301338.aca913c3-yujie.liu@intel.com>
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

On Fri, Sep 30, 2022, kernel test robot wrote:
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-11):
> 
> commit: 7055fb11311622852c16463b1ccaa59e7691e42e ("KVM: x86: Treat pending TRIPLE_FAULT requests as pending exceptions")
> https://git.kernel.org/cgit/virt/kvm/kvm.git queue

...

> # ==== Test Assertion Failure ====
> #   x86_64/mmio_warning_test.c:117: warnings_before == warnings_after

...
 
> [  100.924976][ T4704] ------------[ cut here ]------------
> [  100.931287][ T4704] WARNING: CPU: 67 PID: 4704 at arch/x86/kvm/x86.c:9934 inject_pending_event+0x6e6/0xe00 [kvm]
> [  101.237320][ T4704] Call Trace:
> [  101.241522][ T4704]  <TASK>
> [  101.245343][ T4704]  vcpu_enter_guest+0x61a/0x3540 [kvm]
> [  101.271009][ T4704]  vcpu_run+0xbe/0x780 [kvm]
> [  101.282791][ T4704]  kvm_arch_vcpu_ioctl_run+0x334/0x1540 [kvm]
> [  101.289810][ T4704]  kvm_vcpu_ioctl+0x455/0xb00 [kvm]
> [  101.359680][ T4704]  __x64_sys_ioctl+0x128/0x1c0
> [  101.365052][ T4704]  do_syscall_64+0x38/0xc0
> [  101.370066][ T4704]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [  101.376647][ T4704] RIP: 0033:0x7f2a78126547

Good ol' emulated real mode.  The warning exists to assert that KVM didn't queue
a new exception while injecting events, but when emulating Real Mode due to lack
of unrestricted guest, KVM needs to emulate the actual event injection and so can
trigger triple fault.

Ideally the assertion would filter out this exact case, but rmode.vm86_active is
buried in vcpu_vmx.  Easiest thing is to just exempt KVM_REQ_TRIPLE_FAULT.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb9d2c23fb04..1d02cc416cbc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9972,7 +9972,15 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
            kvm_x86_ops.nested_ops->has_events(vcpu))
                *req_immediate_exit = true;
 
-       WARN_ON(kvm_is_exception_pending(vcpu));
+       /*
+        * KVM should never attempt to queue a new exception while injecting an
+        * event, at this point KVM is done emulating and should only propagate
+        * the exception to the VMCS/VMCB.  Exempt triple faults as VMX without
+        * unrestricted guest needs to emulate Real Mode events and queues a
+        * triple fault if injection fails (see kvm_inject_realmode_interrupt()).
+        */
+       WARN_ON_ONCE(vcpu->arch.exception.pending ||
+                    vcpu->arch.exception_vmexit.pending);
        return 0;
 
 out:
