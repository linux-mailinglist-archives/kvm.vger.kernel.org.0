Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB5C2F8190
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 18:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbhAORF5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 12:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728895AbhAORF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 12:05:57 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38702C061757
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 09:05:17 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id g15so1245343pjd.2
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 09:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dlQMUqsXYPs9RZEmifE90yEH1yGJcIvr2O4QmzFtmV8=;
        b=UXzrp4xzgXoBNmQ/TEEofqZneUS/MCRNKy2J4RgQHb5OjoQSePJEHNkpFWuD+Rt4fu
         hZ8rwf2jK61tL5espAJzPioGJ0M5mqtXnL7Nt0UllbjZMwsFQuQhgvXUGoU1N0PlfqVQ
         /9BSpOWrMnNxDcCaGbpP4q6iFam4ZGPy6PzL96/yPjmwicJy1HKL2EZrtJubIwfWx9b0
         lHmna5dyonmNXT83mgS55B+qA30tR658NmvGQ9ONiX6xh27IiUFAEmkdwrnUXFcSP8lp
         Lw2DHva482hDIH/nSwtggV1SOke18DlIMrsHBbOvHdnDk0vfRhJ7YsMIbTJvpxLLgQxS
         VLvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dlQMUqsXYPs9RZEmifE90yEH1yGJcIvr2O4QmzFtmV8=;
        b=UpIn6yxJj/KBYqRBOPNNuNj6Af20L5YI3gmWiZ19+xpd7Mr0zRj4zBeYRiNL1yuS7C
         koP2xaEnWtRSGxY493dyS76Td9qqwzMJsU6Z8fU1BonwOQA3uAyxiBgPGSEN7G8qcWzb
         P1jpxBE3oCC7Rd1aye13pHI4Ng6jTaR8JEehFgtNUeZwtWYEa0bDoq4VRK0TMVCg5tLf
         vUCfOrRc2wUWy6F+EyAQxXqIXGX0y3BIdg1q0xdw7VSSLU0hneH4IlZWzc6KjFuWwgW7
         fXRFOsuyBwJv2X0Gw0K1WAARtOAJ+MtHOUbJ+PM+ug2229zVfxKg1bUHXQb3R6qLYUgC
         Ht+w==
X-Gm-Message-State: AOAM532zCgyMBOAKZkIm5Dn5eJPTOoIouLUIlg+PoCu+MciNzveArZG/
        B6qDf/Bvu5DC3SC1WlQQQkhSlg==
X-Google-Smtp-Source: ABdhPJwKSbP9N6jXeKm1Tj8rSAi7P8I28jOl1hjJwt6TEIt/yBeVPWu1/WoDJpJdSCwk2yxI+I9ulA==
X-Received: by 2002:a17:90a:7e2:: with SMTP id m89mr7183433pjm.2.1610730316572;
        Fri, 15 Jan 2021 09:05:16 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id x15sm8175175pfn.118.2021.01.15.09.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 09:05:15 -0800 (PST)
Date:   Fri, 15 Jan 2021 09:05:09 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 3/4] KVM: Define KVM_USER_MEM_SLOTS in arch-neutral
 include/linux/kvm_host.h
Message-ID: <YAHLRVhevn7adhAz@google.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
 <20210115131844.468982-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115131844.468982-4-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021, Vitaly Kuznetsov wrote:
> Memory slots are allocated dynamically when added so the only real
> limitation in KVM is 'id_to_index' array which is 'short'. Define
> KVM_USER_MEM_SLOTS to the maximum possible value in the arch-neutral
> include/linux/kvm_host.h, architectures can still overtide the setting
> if needed.

Leaving the max number of slots nearly unbounded is probably a bad idea.  If my
math is not completely wrong, this would let userspace allocate 6mb of kernel
memory per VM.  Actually, worst case scenario would be 12mb since modifying
memslots temporarily has two allocations.

If we remove the arbitrary limit, maybe replace it with a module param with a
sane default?

> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  include/linux/kvm_host.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f3b1013fb22c..ab83a20a52ca 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -425,6 +425,10 @@ struct kvm_irq_routing_table {
>  #define KVM_PRIVATE_MEM_SLOTS 0
>  #endif
>  
> +#ifndef KVM_USER_MEM_SLOTS
> +#define KVM_USER_MEM_SLOTS (SHRT_MAX - KVM_PRIVATE_MEM_SLOTS)
> +#endif
> +
>  #ifndef KVM_MEM_SLOTS_NUM
>  #define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)
>  #endif
> -- 
> 2.29.2
> 
