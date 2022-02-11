Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3140A4B1A68
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 01:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346337AbiBKA1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 19:27:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238950AbiBKA1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 19:27:38 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DEC55A0
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 16:27:38 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id c3so3310191pls.5
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 16:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=87vVVlt1Gj8gtKfe5Lr2/twqlYXCww3QQq8NSJlRxOY=;
        b=g6faqlPYdt6/QRXXz+XK476VGGGfTiJy3bKL70N0F+WD8GrL4lZc+StV90vlUD3Nm4
         W0WE6qNKicd2LtJjrPifzDGgb1ONl2cgs7eY0MEoZQ65zsVV5LsiiKDDDDJpzwRgeAQg
         syxBykrBibhV/yk/P7fGUObXiFfiICbaDF8awb8nT++oCUI1u7qxVNQuGV8LCndsLJwW
         sMFVwlqYEJH/gntTENi/GnHlDxMm6LGhaeH7NLF83CUzQH6UH0u+IyLCCPEtgzVL2UIg
         WhcqEsBAXsgRMKLIqat4nfklmIdWaHd7UltnlJAqSi4fX8L6LnbYFa86sKy+qS7LBeFP
         EIMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=87vVVlt1Gj8gtKfe5Lr2/twqlYXCww3QQq8NSJlRxOY=;
        b=P2s1z++IB6pHyuVCNFU12sZs+EKJF/liXw1oMI4WCbsJleCaShnV8y+fUWgMY/k2Vu
         jsTkgBUwXhONlwsmm246zTQbUCbPCyzzLq/Ol/xgM0NWR0hAQydm6d8f5nD4VuHGyJ9D
         QswdzJpZbifUUhukDnIwgv9PuGGaIpTC/GSBI6lJqWGTA7VZ9tHz1PSbxkheNYWrLREJ
         JueNXtREGPelJxEW5CRTH+K+34CTXhWC1M4WNzu8pceSBpi0Tvryk8Ekjna28BgXrZ3y
         uqvOspalOQ6AqiY7k/oXiJ1IiqgsKvIx1d+M5XPA73P0FYUfB2EwILEZxHqjMcOxW9qZ
         p52A==
X-Gm-Message-State: AOAM5301GNxmbbu1085cSxUENtkreJwoURPH+O4SUG6aP3/ER8BNvkQ3
        CgOQOTDczsUrXtDsimBLVM6tZw==
X-Google-Smtp-Source: ABdhPJzTy01qWyWwog/7undC3RcQ3tQ8v0n1XiIFjQWriUIblT6wduEMltC5zYBM6SDbmqX8rigDaw==
X-Received: by 2002:a17:902:eb8f:: with SMTP id q15mr5303584plg.67.1644539257851;
        Thu, 10 Feb 2022 16:27:37 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t15sm18290964pgc.49.2022.02.10.16.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 16:27:37 -0800 (PST)
Date:   Fri, 11 Feb 2022 00:27:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 06/12] KVM: MMU: rename kvm_mmu_reload
Message-ID: <YgWtdUotsoBOOtXz@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-7-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209170020.1775368-7-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 09, 2022, Paolo Bonzini wrote:
> The name of kvm_mmu_reload is very confusing for two reasons:
> first, KVM_REQ_MMU_RELOAD actually does not call it; second,
> it only does anything if there is no valid root.
> 
> Rename it to kvm_mmu_ensure_valid_root, which matches the actual
> behavior better.

100% agree that kvm_mmu_reload() is a terrible name, but kvm_mmu_ensure_valid_root()
isn't much better, e.g. it sounds like a sanity check and nothing more.

Maybe just be very literalal?

  kvm_mmu_load_if_necessary()
  kvm_mmu_load_if_invalid()

Or follow cond_sched()?

  kvm_mmu_cond_load()
