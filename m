Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A697073C50C
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 02:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjFXAJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 20:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbjFXAJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 20:09:32 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C97273D
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 17:09:27 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-53fd224ad48so726770a12.2
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 17:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687565367; x=1690157367;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6LvkJneBy3/YMbwKk609UgSQMNaHvxDfIWkehlJrEmg=;
        b=znEFkvugMo4sImCFfgS2qwCOLArcMdjXNcjLgHOhMC9xIU3DvkzpkMCW6uGVJRd6Ju
         g76vDmwk2C3WSAvIWBDrFYrqVe7JL5hI1Mf333G2jyuGDEvWJ3vhYX8pH1syinbdfDFh
         hbRo4fkBW9WO0wrevYIRn8bU13AZJFHNrhgm9cz26iwq/UtFXuP7fBHX/Uq1dgsTslxR
         9vLiVWcHcP/15wxXU65k3wQ7ne+ORwPRg2o4zVmdcaNjAcndf6ggLs+lIUvj84zgWTyR
         3YTZOyatvBcMtxPQpri0htvOeEZ0rsKid9MVUg672KjGfmiUq1Y501qF79MyFBZ4gbxp
         QEAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687565367; x=1690157367;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6LvkJneBy3/YMbwKk609UgSQMNaHvxDfIWkehlJrEmg=;
        b=NmbxT8pQG10HuTWYJS03DODlLJASkpx0tnX+Cv5m4JjLLFbHub15tp0f87uN4w4qdM
         UZpC1bvKd7YLztI1CR4ljnjvIS4qigUxYKd8nXaQa9PCcCjaA9gUZow6caZnSq40hQ/n
         7NiP2rxSE4qZwIhLfXA0Vh08nliMIjyhtAF/2+gmumRSoIBbHViCI2iFdw+vkaWcb436
         +06b2rwQdZYv4zJG5ZkpYC5LgNLKaxNPESq+6zjEju+SVFTvAjxGxSB8irnlAmPUBwcZ
         8JrJ+qe9zk/xEboZZl5LumnEVv7zpERPohrXv4UqRKjOCwUi9hU0VhcLsHt9t7d250p9
         pQmw==
X-Gm-Message-State: AC+VfDxWwsTV1pVVt3VMl/9jSkNKJ1vZ4hrBdfJ4Zhr0WSkTNctlxul4
        NjDhmhhG5l+s/N5PpWCzs6dz4MCyZMY=
X-Google-Smtp-Source: ACHHUZ7GYqhOn7bHUyi6+FrThgCMRPif8Rtwe80QIDWA0IpGY9LZNVqsPFDUF3IV6HL7i3Z8DDrWsIB9vyo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2f42:0:b0:53f:7713:5e0e with SMTP id
 v63-20020a632f42000000b0053f77135e0emr2662006pgv.5.1687565367474; Fri, 23 Jun
 2023 17:09:27 -0700 (PDT)
Date:   Fri, 23 Jun 2023 17:09:26 -0700
In-Reply-To: <cover.1686858861.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1686858861.git.isaku.yamahata@intel.com>
Message-ID: <ZJY0Nudy8ym2kKNg@google.com>
Subject: Re: [RFC PATCH 0/6] KVM: guest memory: Misc enhacnement
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 15, 2023, isaku.yamahata@intel.com wrote:
> * VM type: Now we have KVM_X86_PROTECTED_VM. How do we proceed?
>   - Keep KVM_X86_PROTECTED_VM for its use. Introduce KVM_X86_TDX_VM
>   - Use KVM_X86_PROTECTED_VM for TDX. (If necessary, introduce another type in
>     the future)

How would KVM differentiate between software-protected VMs and TDX VMs if we go
with this option?

>   - any other way?
