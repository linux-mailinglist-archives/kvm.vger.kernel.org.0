Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5470549BCF1
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 21:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbiAYUW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 15:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbiAYUWB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 15:22:01 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38A3C061753
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 12:22:01 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id nn16-20020a17090b38d000b001b56b2bce31so3960897pjb.3
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 12:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hJKy47pW1oc6236j8uB1UVM4hTAQSU9C3F7elRFpa64=;
        b=PWLgsA2bRjPnVKyKi1lIhnVfI+e7VBGCcM0myxXMQiqFJ/wWeP4kGdkLICCbHSOV8H
         zPCRWNuI7KzsZqNMMHj+cELEl8mjkbMg83e/mDO68SeIac0FezFVgBDeJmoLmZ8cYfWf
         P8GESwgi7kEyExnvWmUUJ0Mf0JEMDkhBIUF2A3x2q3QVy0sUaWpPNPnqkzHcHNF69UEi
         WcDFVXmn5VyyVnMTEptdJDMMV5dgra59/nlg9WsvWwrjy5GFSpkjN1+jjXWmiZy3QIJf
         vmmcW6vb18J0u2+RLbi8O7Fu+qaJWiEzBMC8yofxBGvoLqjtsSeRqkUhkw/mUvhebl0r
         9MDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hJKy47pW1oc6236j8uB1UVM4hTAQSU9C3F7elRFpa64=;
        b=S+4dp4uDzclfiRTCs9n+Ws+R1PKHg9gIYBH9s5JtjG7kNUOJb4aBhVN1vSVZwOCEHO
         958a53cjpEEgvXgS549Qjdbcd86tXz1zm+T5OaJecrsz1NcvKuXl7HPLSWbVviO8ij5t
         SuszPTnn7UqnYEI4c6mydyGhU0EsNQsFTm4QlHv+thwTei4sjjsGKvTV6KEhc+G6QEsL
         XGgKWfdSuceZP9NSQg/Jw0shUYVKGOwe5YGt0hJKXietEzixRR8hX+VSh3hcMLhV/joJ
         p8pOoxXBpIfna+PObQ2u7gtW5S1Wght5+pfBWBKpJL5No/J4WA9SjYYOG7giXEG2qAOM
         xGiA==
X-Gm-Message-State: AOAM530ysmwoffQHTu/4DWmAjloO1K14LtbK6NBd+XrOuCpyyYwG9A/I
        hy76bjSGIK5RG3ZSkeKhHFdzB6xIvFy3qg==
X-Google-Smtp-Source: ABdhPJwpKnxJBMOgi9KonCtY2cy/DGgGQrJnO0rKNuQA9tDen8Sx8jWzGGvymoZTzExcVOWAbaASNg==
X-Received: by 2002:a17:90a:6f05:: with SMTP id d5mr3279064pjk.59.1643142121060;
        Tue, 25 Jan 2022 12:22:01 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z13sm6996496pfj.23.2022.01.25.12.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 12:22:00 -0800 (PST)
Date:   Tue, 25 Jan 2022 20:21:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+8112db3ab20e70d50c31@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Subject: Re: [syzbot] WARNING in free_loaded_vmcs (3)
Message-ID: <YfBb5YU4adUAptUg@google.com>
References: <0000000000002c4f0905d655b052@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000002c4f0905d655b052@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 24, 2022, syzbot wrote:
> WARNING: CPU: 0 PID: 3606 at arch/x86/kvm/vmx/vmx.c:2665 free_loaded_vmcs arch/x86/kvm/vmx/vmx.c:2665 [inline]
> WARNING: CPU: 0 PID: 3606 at arch/x86/kvm/vmx/vmx.c:2665 free_loaded_vmcs+0x158/0x1a0 arch/x86/kvm/vmx/vmx.c:2656

KVM gets confused if userspace abuses KVM_SET_VCPU_EVENTS to toggle SMM on/off
while the vCPU is post-VMXON, I'll send a patch.
