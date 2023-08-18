Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70A9780CE3
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 15:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377416AbjHRNsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 09:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377363AbjHRNrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 09:47:37 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE5F4216
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 06:46:55 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5655a2c868eso1220434a12.2
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 06:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692366389; x=1692971189;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jNlR4KxrzE72vpNuTyvfyVvbrBWXFgdYpu7h9tDZYwU=;
        b=vtgMMSNPRqRJdWk7DyvvesFPY2OKKk3Wr7T5UwkfgFFO5g1QQJFjlFXnDFSHqiiEhe
         lD1aF4LgRzwD94FWX/Pz6c0u5HK7icnntQ1CaUHS9vHM9IfBLQRx/IMRnqrJ2XvhouId
         0Moq9CjzTasCUtU+i24RHqrDECGkg8c4HxeYW+3hVVSOqSMUWJWhjsUvHOJDfm1QKkX6
         RjHcybduEWy7snz7CQD66T2zmTu38UEDu/nBqhGMu91SIcVhwqvGGoeO5Bpr4NZT3IDo
         iT5uJvB/M1Eiu/YSbP5jaRC7KPWjfci5ugAcpMnSVIZdcBjjnH/rWontMjdvVjfSl3nK
         j/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692366389; x=1692971189;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jNlR4KxrzE72vpNuTyvfyVvbrBWXFgdYpu7h9tDZYwU=;
        b=gXav7/yQIxQmlmdr7wTph6zFYvnP14zJrUFVSsmwrqT/uTWdyoByHfRJPpHox7UZd8
         cnR8UEjEzj4DmPyVkN7VIQrtblahdKOx59brKogU+hgyVjIDUc0w3fPyWOUfIhkfvks5
         Ll9lbdirelniugx+h0bdQ05sjW8wy2jLUYim0k48LHt/1Uv4ef8domarCTBfIZPWbBSs
         pv+MzDEE+MYbvULGjff1vdrojvxWdJMHoSsQkbGdDNNM8CvCTd/yc2cbhZuZu8XTl/U7
         OMdiTXtDiR3r0+HcGu+uYKwEGdc9nkr3r9GGsKev1gH/vVUUKF9bfvJEquStR2K1Kv5J
         y1Gg==
X-Gm-Message-State: AOJu0YwbdTh6YCo5pUEY2AasTZHjXUF9L7AWyLluj1FEU6VrXUd8FEyq
        C/zQUGzN4kJgs8zh4zWZrNnt720G0Lw=
X-Google-Smtp-Source: AGHT+IFmESdYKpgGUbBQHEYsCSENkDJqn8Y0SDC8FdMY70toMQGagfsR2ZiXJMY8GWX5/b2Nj3MnFnTrH+0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7b10:0:b0:565:eb0b:6daf with SMTP id
 w16-20020a637b10000000b00565eb0b6dafmr443690pgc.7.1692366388693; Fri, 18 Aug
 2023 06:46:28 -0700 (PDT)
Date:   Fri, 18 Aug 2023 06:46:26 -0700
In-Reply-To: <ZN9FQf343+kt1YsX@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230808085056.14644-1-yan.y.zhao@intel.com> <ZN0S28lkbo6+D7aF@google.com>
 <ZN1jBFBH4C2bFjzZ@yzhao56-desk.sh.intel.com> <ZN5elYQ5szQndN8n@google.com> <ZN9FQf343+kt1YsX@yzhao56-desk.sh.intel.com>
Message-ID: <ZN92MtFkIF3E79/u@google.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: .change_pte() optimization in TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023, Yan Zhao wrote:
> On Thu, Aug 17, 2023 at 10:53:25AM -0700, Sean Christopherson wrote:
> > And FWIW, removing .change_pte() entirely, even without any other optimizations,
> > will also benefit those guests, as it will remove a source of mmu_lock contention
> > along with all of the overhead of invoking callbacks, walking memslots, etc.  And
> > removing .change_pte() will benefit *all* guests by eliminating unrelated callbacks,
> > i.e. callbacks when memory for the VMM takes a CoW fault.
> >
> If with above "always write_fault = true" solution, I think it's better.

Another option would be to allow a per-mm override of use_zero_page, but I think
I like the KVM memslot route more as it provides better granularity, doesn't
prevent CoW for VMM memory, and works even if THP isn't being used.
