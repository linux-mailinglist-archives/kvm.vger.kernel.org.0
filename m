Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6DB30765D
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 13:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhA1MrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 07:47:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55012 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229852AbhA1MrL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 07:47:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611837943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PbKeF6zGYsqZjc/gyq24s09E3kJcDXhLLxYC70Xe7EE=;
        b=QyEbD8Sk5fgM3Amn5PRCAYFmdg9V+3IIhJT2XrjHtQN2brYHvz/7is9X/fgfYBZVCBSkT/
        o6m/veFTBnQ7pxjtoRibDf4BgIScBhLnzgyZwrh3fvD6PiLE9hfOzuQGbGt6oO/dJG80Vo
        QxA5SyftoUCQRLL2WBWv4mNUWfuSBh4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-IlS0yPD7NEOXhTMR40uX2A-1; Thu, 28 Jan 2021 07:45:42 -0500
X-MC-Unique: IlS0yPD7NEOXhTMR40uX2A-1
Received: by mail-ej1-f72.google.com with SMTP id ar27so989950ejc.22
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 04:45:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PbKeF6zGYsqZjc/gyq24s09E3kJcDXhLLxYC70Xe7EE=;
        b=fpsjzgEaU3qAaQmUKfrSxD5FK+ZHCP7ImTNpiIRgTGVeYN0hJgGxzD7+6GpSz4eaeE
         /OW5CyTio3e2HqIl992CcD2hRQkxy+JQx7M/PaGc5YpLOhU1X5FFdru8PwL+6E77+E5G
         p4Fm5H4RFzOIUlT+jk37/GcZkeoWhDabrD1nQuFuwr5bpvR3PEcfBgLyQ3Xu1ZqSn0fz
         uVP7HctYhoMsbsfCazO2wNkDVxWdYOZbYNzpqe9jejUDHaJqYi+oue2GD0BQhfvEjAcF
         x7DtbvfKMwPRSfaiTYIjeTKclXmFVes/N+xxfpYyLhBm3eSwWnaMAnt84BkpCWRGAuES
         A4qw==
X-Gm-Message-State: AOAM530wjqkc3lnXecoasPENluyWx+quiw7eiTjgXciVXkvVsMpENHDr
        f/wDIdVbZMY1IObfDswBuH+zFmc0NlEAbQc0ifZpiRvNV0Qf4y5C0vbPzwSlII/9I0M/VFBWkiI
        KLIY4aVqSbzu4
X-Received: by 2002:a17:907:971b:: with SMTP id jg27mr10743346ejc.14.1611837940948;
        Thu, 28 Jan 2021 04:45:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyWRFPnDlvnu+OSs2St8Qk+7eUVfgbNE4ATrRsAAGrYhGhEOaziS3EY5tfXTNfS/4q/5YMsfQ==
X-Received: by 2002:a17:907:971b:: with SMTP id jg27mr10743322ejc.14.1611837940761;
        Thu, 28 Jan 2021 04:45:40 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h12sm2853819edb.16.2021.01.28.04.45.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 04:45:39 -0800 (PST)
Subject: Re: [PATCH v5 00/16] KVM: Add minimal support for Xen HVM guests
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
References: <20210111195725.4601-1-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <98732694-7e57-2457-2519-4f5d6dcc724c@redhat.com>
Date:   Thu, 28 Jan 2021 13:45:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111195725.4601-1-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/01/21 20:57, David Woodhouse wrote:
> This patch set provides enough kernel support to allow hosting Xen HVM
> guests in KVM. It allows hypercalls to be trapped to userspace for
> handling, uses the existing KVM functions for writing system clock and
> pvclock information to Xen shared pages, and adds Xen runstate info and
> event channel upcall vector delivery.
> 
> It's based on the first section of a patch set that Joao posted as
> RFC last year^W^W in 2019:
> 
> https://lore.kernel.org/kvm/20190220201609.28290-1-joao.m.martins@oracle.com/
> 
> I've updated and reworked the original a bit, including (in my v1):
>   • Support for 32-bit guests
>   • 64-bit second support in wallclock
>   • Time counters for runnable/blocked states in runstate support
>   • Self-tests
>   • Fixed Viridian coexistence
>   • No new KVM_CAP_XEN_xxx, just more bits returned by KVM_CAP_XEN_HVM
> 
> v2:
>   • Remember the RCU read-critical sections on using the shared info pages
>   • Fix 32-bit build of compat structures (which we use there too)
>   • Use RUNSTATE_blocked as initial state not RUNSTATE_runnable
>   • Include documentation, add cosmetic KVM_XEN_HVM_CONFIG_HYPERCALL_MSR
> 
> v3:
>   • Stop mapping the shared pages; use kvm_guest_write_cached() instead.
>   • Use kvm_setup_pvclock_page() for Xen pvclock writes too.
>   • Fix CPU numbering confusion and update documentation accordingly.
>   • Support HVMIRQ_callback_vector delivery based on evtchn_upcall_pending.
> 
> v4:
>   • Rebase on top of the KVM changes merged into 5.11-rc1.
>   • Drop the kvm_{un,}map_gfn() cleanup as it isn't used since v2 anyway.
>   • Trivial cosmetic cleanup (superfluous parens, remove declaration of a
>     function removed in v3, etc.)
> 
> v5:
>   • Rebased onto kvm/next as of 2021-01-08 (commit 872f36eb0b0f4).
>   • Fix error handling for XEN_HVM_GET_ATTR.
>   • Stop moving struct kvm_host_map definition; it's not used any more.
>   • Add explicit padding to struct kvm_xen_hvm_attr to make it have
>     identical layout on 32-bit vs. 64-bit machines.

Sorry for the delay, this already looks pretty good though.  The only 
substantial issues are:

- the userspace get/set API

- the kvm_xen_has_interrupt() in the last patch.

I would be happy to get this in 5.12 if you can fix those two.

Paolo

