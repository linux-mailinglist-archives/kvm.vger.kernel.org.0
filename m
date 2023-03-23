Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18C36C7369
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbjCWWyg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjCWWyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:54:02 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F082C679
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:53:43 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id i15-20020aa78d8f000000b005edc307b103so108468pfr.17
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679612023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wEYvDKOxnIlpQusiF6SA0T7tXCoz4W0iXPvv4uKMc1E=;
        b=At8h77NnzlAZJKd5E5nUfhwLxZxZ+/xC++bofIlWznW1dizloSaOJ8Ma4Dq83EfCnb
         KkSTP4DpHqmt7U8jFvUIhBqLCfI2EomrC09NIR4gP0jBsZMXv808gNLVmRCRkbAiUfNx
         bRd/cPvDWtlCij0tuzTlWFqpiDnAlQYRdHvxhy4KWI91w2ai1lHFJ5t7YNAaVeRiscEC
         hy4l2dkA2rQRbXjbJCnlgcQTWMgnpxqucXL7Qza7wNSiaiKml0CjHtDK7MMYqlkCp6++
         VxFMXWCspgFHC7lc1ZJZqsAwpzv5Q7xvn525yT0clY445S25mvOfRnMgN2YzqdLjj3wU
         idGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679612023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wEYvDKOxnIlpQusiF6SA0T7tXCoz4W0iXPvv4uKMc1E=;
        b=I4j7LENyleYexmUyDpU/BFQ9T4n8sN7Ia6xlCX/eUPRggyiSqLxV0CtmUWruJzrdMS
         TOOOiiFLi/zoeK2BpNJBnu/7ZwvjynNAOxv812u2qrCUmlYfaJZTzchZoGQjwpXcgPkS
         9ExvBiQlG4jKtdndG8y1W1URI7T/vJQe0D8HRLEDuDdUNNOeaF3r/5oRuss2A4rK8LD+
         OT4LcGr0BOEcjqsDTiSsiiU9JGkFqEWNnYBjLPYYoOMIJ+8+M+RAA+iZKGPL2OZeWZ6Q
         3TRkGl6Vu+ZShCKZJjpYPJqZEzDMdG8YK+ZyYZbRICoW8Ys0MZiS/sadS0R2MqYRgiks
         xdwg==
X-Gm-Message-State: AAQBX9fSaVFIiyind7OuVA3YTtsTmkZnHFr6IZ5WZMgbeS5pIznglBN+
        K28gR0T0DJm5jBx+9cdAO/RWUihbfws=
X-Google-Smtp-Source: AKy350bt4xTSvYjFPODKfvs4QgedXHc9Y4eLZfNUlXiApxEkEGf8gsqfxapjIVRed8EOussZqO2FW27Zrkw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:41c9:b0:19f:3a27:6c5e with SMTP id
 u9-20020a17090341c900b0019f3a276c5emr220571ple.0.1679612022984; Thu, 23 Mar
 2023 15:53:42 -0700 (PDT)
Date:   Thu, 23 Mar 2023 15:53:36 -0700
In-Reply-To: <20230119141946.585610-1-yu.c.zhang@linux.intel.com>
Mime-Version: 1.0
References: <20230119141946.585610-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <167942115350.2068418.1799786492353731807.b4-ty@google.com>
Subject: Re: [PATCH v2 1/2] KVM: nVMX: Remove outdated comments in nested_vmx_setup_ctls_msrs()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Jan 2023 22:19:45 +0800, Yu Zhang wrote:
> nested_vmx_setup_ctls_msrs() initializes the vmcs_conf.nested,
> which stores the global VMX MSR configurations when nested is
> supported, regardless of any particular CPUID settings for one
> VM.
> 
> Commit 6defc591846d ("KVM: nVMX: include conditional controls
> in /dev/kvm KVM_GET_MSRS") added the some feature flags for
> secondary proc-based controls, so that those features can be
> available in KVM_GET_MSRS. Yet this commit did not remove the
> obsolete comments in nested_vmx_setup_ctls_msrs().
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/2] KVM: nVMX: Remove outdated comments in nested_vmx_setup_ctls_msrs()
      https://github.com/kvm-x86/linux/commit/ad36aab37ae4
[2/2] KVM: nVMX: Add helpers to setup VMX control msr configs
      https://github.com/kvm-x86/linux/commit/f6cde92083de

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
