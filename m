Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F2F23D489
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 02:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgHFAWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 20:22:02 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24856 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726013AbgHFAV7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Aug 2020 20:21:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596673318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NNC27QJGcBMosaf0qhEYeMAB3BZCYSImh+vM7tQXNuI=;
        b=eugBS+KePJtOuiAmV93iSHznht9hkrwzd+2xlOdtBZ2ABwrHvzsz/b8M5MZ454tUWsIKDt
        AedCh+cWtal6sfYLEqE23yQRy4JxFi7iBYpgrAtiv6YTmQuipW1R5H0ZH8X9MrTWWKxVET
        rWmFDPhNZtIdt4SyX6ucXTuQ1lLRilE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-d_YNOHByNsCpB8WQH88ilQ-1; Wed, 05 Aug 2020 20:21:56 -0400
X-MC-Unique: d_YNOHByNsCpB8WQH88ilQ-1
Received: by mail-wr1-f72.google.com with SMTP id d6so12475216wrv.23
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 17:21:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NNC27QJGcBMosaf0qhEYeMAB3BZCYSImh+vM7tQXNuI=;
        b=IU7UgkHrclFGOBVvdwqEjo2NIxnJuKi1yJ23n+TW/HBMaj+Aw2VII3sfcvg9wihgk+
         p8Vl13yQ+n3g6Wcc/LE3BWsDvYrxDT8Zr0kvT+WQ1ApY+/BQrZSmiTjNuPlakJz91aVD
         lpemQ6pJUrG5jA/Bh7fP0z2QSoVZpTHk7sTOxF87CtG8dDZ+7MVLaohFCkm0o/eKQ8NM
         YLL/L0qDiI+Fc0d+fElTT8z+URv2iMP9lz5qt94FAC3qk/RQsBM/47kLpJtkWb0Ze7pU
         WucF5JEp4CKvBeCKd3age1VkmyWXI8cqn0jk1qkLhRsxX9MrSiG5GIke7hwcbiveJyo3
         HppQ==
X-Gm-Message-State: AOAM530zNisqFZt0wAKBig4YSlUztq+Oh4PFOW3+c+x1abq9BPKrDP+I
        mlsmuJfiLpyBgMEQSMsfUoS4ETDQyi6lUMjtE23Fam34aVJaubxdT7CKYj2KOSlG7RPuB8OXQ1a
        jbLAWJwewwoAm
X-Received: by 2002:a1c:cc12:: with SMTP id h18mr5767452wmb.56.1596673315378;
        Wed, 05 Aug 2020 17:21:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlN6Bpmb2ZW3xnYrX864VA5YiEsKXz0L7ESwTdaDPvOupscpVX/k+KQxw9CIv4k/gk0OQ5FA==
X-Received: by 2002:a1c:cc12:: with SMTP id h18mr5767425wmb.56.1596673315112;
        Wed, 05 Aug 2020 17:21:55 -0700 (PDT)
Received: from redhat.com (bzq-79-177-102-128.red.bezeqint.net. [79.177.102.128])
        by smtp.gmail.com with ESMTPSA id w64sm4753537wmb.26.2020.08.05.17.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 17:21:54 -0700 (PDT)
Date:   Wed, 5 Aug 2020 20:21:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
Message-ID: <20200805201851-mutt-send-email-mst@kernel.org>
References: <20200728143741.2718593-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728143741.2718593-1-vkuznets@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 28, 2020 at 04:37:38PM +0200, Vitaly Kuznetsov wrote:
> This is a continuation of "[PATCH RFC 0/5] KVM: x86: KVM_MEM_ALLONES
> memory" work: 
> https://lore.kernel.org/kvm/20200514180540.52407-1-vkuznets@redhat.com/
> and pairs with Julia's "x86/PCI: Use MMCONFIG by default for KVM guests":
> https://lore.kernel.org/linux-pci/20200722001513.298315-1-jusual@redhat.com/
> 
> PCIe config space can (depending on the configuration) be quite big but
> usually is sparsely populated. Guest may scan it by accessing individual
> device's page which, when device is missing, is supposed to have 'pci
> hole' semantics: reads return '0xff' and writes get discarded.
> 
> When testing Linux kernel boot with QEMU q35 VM and direct kernel boot
> I observed 8193 accesses to PCI hole memory. When such exit is handled
> in KVM without exiting to userspace, it takes roughly 0.000001 sec.
> Handling the same exit in userspace is six times slower (0.000006 sec) so
> the overal; difference is 0.04 sec. This may be significant for 'microvm'
> ideas.
> 
> Note, the same speed can already be achieved by using KVM_MEM_READONLY
> but doing this would require allocating real memory for all missing
> devices and e.g. 8192 pages gives us 32mb. This will have to be allocated
> for each guest separately and for 'microvm' use-cases this is likely
> a no-go.
> 
> Introduce special KVM_MEM_PCI_HOLE memory: userspace doesn't need to
> back it with real memory, all reads from it are handled inside KVM and
> return '0xff'. Writes still go to userspace but these should be extremely
> rare.
> 
> The original 'KVM_MEM_ALLONES' idea had additional optimizations: KVM
> was mapping all 'PCI hole' pages to a single read-only page stuffed with
> 0xff. This is omitted in this submission as the benefits are unclear:
> KVM will have to allocate SPTEs (either on demand or aggressively) and
> this also consumes time/memory.

Curious about this: if we do it aggressively on the 1st fault,
how long does it take to allocate 256 huge page SPTEs?
And the amount of memory seems pretty small then, right?

> We can always take a look at possible
> optimizations later.
> 
> Vitaly Kuznetsov (3):
>   KVM: x86: move kvm_vcpu_gfn_to_memslot() out of try_async_pf()
>   KVM: x86: introduce KVM_MEM_PCI_HOLE memory
>   KVM: selftests: add KVM_MEM_PCI_HOLE test
> 
>  Documentation/virt/kvm/api.rst                |  19 ++-
>  arch/x86/include/uapi/asm/kvm.h               |   1 +
>  arch/x86/kvm/mmu/mmu.c                        |  19 +--
>  arch/x86/kvm/mmu/paging_tmpl.h                |  10 +-
>  arch/x86/kvm/x86.c                            |  10 +-
>  include/linux/kvm_host.h                      |   7 +-
>  include/uapi/linux/kvm.h                      |   3 +-
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../testing/selftests/kvm/include/kvm_util.h  |   1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  81 +++++++------
>  .../kvm/x86_64/memory_slot_pci_hole.c         | 112 ++++++++++++++++++
>  virt/kvm/kvm_main.c                           |  39 ++++--
>  12 files changed, 243 insertions(+), 60 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/memory_slot_pci_hole.c
> 
> -- 
> 2.25.4

