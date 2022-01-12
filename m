Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7930448BBF0
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 01:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347271AbiALAjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 19:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbiALAjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 19:39:20 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE02C061748
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 16:39:20 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo1773923pjb.2
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 16:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MLmAyAgjyIAoET5SxTUk4lZdHTz7e1l7X30ovuzOjSA=;
        b=aH1lETH3pezLbDCaYuPXnG8RlPlQqKfXegbFrduOSPWOdngHIdmSMfmvGoKv515vb4
         zC9ELJzgsUFWLZXPlgAas6U78dnyrwX4tjvfmrYHZKdFaabY9Uxg8mpT8/Q7u9AquTew
         S1leLlvlQOEL4E4ptvnhkRIrRwkSsHOvE9BfVg44EBEutW+5GHzpFhqkJhgh8df9nVEC
         nwkWl8/hxhjV89emlNvqzFlr0UML4kW3u4tgLFUI6+1Hr7um2UR4QM4BF23AmgrVkdy8
         R+pwapSMVZAHSYMYPD+Toq5cAXmKNBa/H1LJS/yK3L/hptUdQ3YDBwhNQ3b4byBryOF6
         Xh5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MLmAyAgjyIAoET5SxTUk4lZdHTz7e1l7X30ovuzOjSA=;
        b=gPvfbNwVllLwR/QKNazpewe8s1W387Rf4/kFxhnQKoqzOSSXzRRjmhNAdZIOC5T5ZK
         xAH5FFI/PRQ0uUzvfxM0MJA1shEkf5hw3lp8Je3Zgqv1Q6Yd18neF6HbALQ863ZhHErB
         B9Je0Tq6ST19Vme7r00K6prQxPZK6eH4cbGJmDCfOTWromdlxRxgE3pBeB/HweIGi4MN
         1oYYflC7Lb/c1UgtHYXaqjWMAX1QEkjfyCfT7nvtkEO0qE/JGu528VvICzZzLiiWTwxV
         e/2BmX7ZTENNTYLMwJfTlpmZTAuVmiqWh1fd/ykUuK8UD2C2jYBZxpb0zo9i0791Ec1Q
         dRXA==
X-Gm-Message-State: AOAM531n+yujrX1Lil8NkP20EHZk0FKcjqVJbc1ADd9KDiYka0+GrpBy
        IQHpfAYQqxM2Yv0pT2FzRe4nUQ==
X-Google-Smtp-Source: ABdhPJxj0aF6CGeD7VG6f8F8YXOb01/NFD9LRj+VGL90USRFmDkr/48hUkYFK91La1qk+xMpyKXEkA==
X-Received: by 2002:a17:902:e741:b0:14a:5a65:dcdb with SMTP id p1-20020a170902e74100b0014a5a65dcdbmr3825474plf.135.1641947959788;
        Tue, 11 Jan 2022 16:39:19 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g10sm11055238pfo.103.2022.01.11.16.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 16:39:19 -0800 (PST)
Date:   Wed, 12 Jan 2022 00:39:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Aili Yao <yaoaili@kingsoft.com>
Subject: Re: [PATCH v2] KVM: LAPIC: Enable timer posted-interrupt when
 mwait/hlt is advertised
Message-ID: <Yd4jMyi4JIE+uh5o@google.com>
References: <1641471612-34483-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1641471612-34483-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 06, 2022, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> As commit 0c5f81dad46 (KVM: LAPIC: Inject timer interrupt via posted interrupt) 
> mentioned that the host admin should well tune the guest setup, so that vCPUs 
> are placed on isolated pCPUs, and with several pCPUs surplus for *busy* housekeeping.
> It is better to disable mwait/hlt/pause vmexits to keep the vCPUs in non-root 
> mode. However, we may isolate pCPUs for other purpose like DPDK or we can make 
> some guests isolated and others not, we may lose vmx preemption timer/timer fastpath 
> due to not well tuned setup, and the checking in kvm_can_post_timer_interrupt() 
> is not enough. Let's guarantee mwait/hlt is advertised before enabling posted-interrupt 
> interrupt. vmx preemption timer/timer fastpath can continue to work if both of them 
> are not advertised.
> 
> Reported-by: Aili Yao <yaoaili@kingsoft.com>
> Cc: Aili Yao <yaoaili@kingsoft.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
