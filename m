Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F3B2DFF90
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 19:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgLUSUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 13:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbgLUSUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Dec 2020 13:20:37 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC47C061793
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 10:19:57 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id m5so6898733pjv.5
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 10:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y7YXrofGy04EzPSBwy2tiG07JmHeqpoCbscVvl8zlbI=;
        b=jCxSWg/NjWqzN7+hxsfq82SMexR5j2/J24cKKtOw+kLXken1XstTX1XQRly2g4Ud1j
         KXJZq3LWiAIp1P6vrZneUIbIOsHGs6i1Yx3QkdH79//bhlG4dcldZpt9Z37kkJhECEzH
         0MCptAZ64WmvwwdG6HbqXu8smD+o9fGTz+aQa5Pu03BP2aajZMHHVAMk5mVIFp95bDLq
         +UmeU+ML/jJDokTcNsiZ9zZQmV2t0eIltfeeLDyG8tD6gj0XwxKVOaFWkvWnCklxanjM
         8vhS5Ztmskyib8PVsKBhxavFfIjLjI1+16HqCYoHDarAUxAYOXYnW5FfyRFR5CkhRyvI
         xrRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y7YXrofGy04EzPSBwy2tiG07JmHeqpoCbscVvl8zlbI=;
        b=lZnd7N4fU0Xr6yD8Ga0kvtynWx8QLnJ2nOyB4YRzCfMZnXxzeA/Se5nwx7b1D2I96E
         2j4ojsqjYnfuCRoYgIa85fJA/GVIT5lgszjD9k4xoY6jkgPm4i6IUgOQYZzUGq8cUG3Y
         atkX+S9wHvx8cyLyOgJelWE+pPmFPeMvPDMxdl3iuVlRX++BkBlZOK/0J+701V4sPNCl
         HmJeYWJfP/iWu0rjUMHnR/NqjRBMeS4cbhZThqZa5eZBWp+f48sP1N+KR/uTA/vYxukK
         ijCdea2yxg9CPTBozfYj1KBHIFiB7XWtRo2kiJzSkm39vWDrAQQYoA8UFc9vs50UaCKE
         QV4A==
X-Gm-Message-State: AOAM533z95XcmqJVvNS4f15jxqfizTDzqXTKdQV9pbbmGLcYl2r03/1t
        x98P4oNcoY20C9KnpKwOD+FQOnWYML6KUg==
X-Google-Smtp-Source: ABdhPJyHWlfTxHlQHF3IJV0kFO0bBSvy0Z3c4b0a4D4A49KgheCW20J5Ryw7q0wwOE+UQG+erHzUmA==
X-Received: by 2002:a17:90b:46d2:: with SMTP id jx18mr18724013pjb.106.1608574796679;
        Mon, 21 Dec 2020 10:19:56 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id gb9sm2507692pjb.40.2020.12.21.10.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 10:19:56 -0800 (PST)
Date:   Mon, 21 Dec 2020 10:19:49 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v2] KVM/x86: Move definition of __ex to x86.h
Message-ID: <X+DnRcYVNdkkgI3j@google.com>
References: <20201220211109.129946-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201220211109.129946-1-ubizjak@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 20, 2020, Uros Bizjak wrote:
> Merge __kvm_handle_fault_on_reboot with its sole user

There's also a comment in vmx.c above kvm_cpu_vmxoff() that should be updated.
Alternatively, and probably preferably for me, what about keeping the long
__kvm_handle_fault_on_reboot() name for the macro itself and simply moving the
__ex() macro?

That would also allow keeping kvm_spurious_fault() and
__kvm_handle_fault_on_reboot() where they are (for no reason other than to avoid
code churn).  Though I'm also ok if folks would prefer to move everything to
x86.h.

> and move the definition of __ex to a common include to be
> shared between VMX and SVM.
