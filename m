Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BFA22CC98
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 19:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgGXRuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 13:50:14 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29153 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726593AbgGXRuO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Jul 2020 13:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595613012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sTJ+cPiiGlwq5/s3PSlzC8KEoaa5YrhJ4JrwoRgWcV0=;
        b=b84ySiIOBhNEMLgIeSKuNWpV/YVJELOKmiKXFExhKh0iGwwpu05MHS4es45jzwSFTCKeTv
        1zbU3kU5nYhom4sqKTi33DajrxrWv3m8nrH6qj5itPZQIckMGGr5Z7zB+fdG3JpXIscqKA
        rX7LkHE6c8XbVkDQewNEYJu8vrakYjY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-OizNlznkO-Ct1BAGYvVcfA-1; Fri, 24 Jul 2020 13:50:11 -0400
X-MC-Unique: OizNlznkO-Ct1BAGYvVcfA-1
Received: by mail-ej1-f71.google.com with SMTP id cf15so3954937ejb.6
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:50:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=sTJ+cPiiGlwq5/s3PSlzC8KEoaa5YrhJ4JrwoRgWcV0=;
        b=M/MzHvgMVOiBjsJqR0h5L+D9eK6ACxSJ1rHOxo6nAdmG4fymkmW0hhrIKeCDqStGQN
         JAksWGGYt3cxHgGgfoLSQ/GtvmAQuTVQeokZ8JT5205Jv5epQADNWQ5YBkdUx5fpcX9b
         dgpFv81X5j768sbQGKQFjO6WJ3oo6HajTK4pedZHHDDDaz32qoALhP138AIAHp0RsmAX
         RdM7/z4fNQWHuLMkTwuZYwnBZ2cUkK1IcnmFiX1Nuj33IuM8gqIH43IeJpjwdftBfn16
         HvY/KUiiWDg55X9h1r0JwaymTlKJE7jfNL9Uc64lOu/T1flf3v87AThXwkIPNwCVxNJZ
         SYqQ==
X-Gm-Message-State: AOAM5338HNFaU4yLWWgFSnz+b8a7WtqMySWWHshtIR+hFUt7R0C2I/XP
        TZ7lG7mu5hbHEXIolxtVC/t1vr+wz/6Th58ZZbKap8WneOg+zsoSrjO+K37ZNYRT37N24qbObWs
        CVXInxPcyEFCd
X-Received: by 2002:a50:8a62:: with SMTP id i89mr10223846edi.324.1595613009919;
        Fri, 24 Jul 2020 10:50:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybapy5a8Qja8Vc8+vPK3f+zAoda+bqijI+q1PHQanVyoWiDBG9nz2/Xh6L2JP4+WEBEJmKgQ==
X-Received: by 2002:a50:8a62:: with SMTP id i89mr10223831edi.324.1595613009746;
        Fri, 24 Jul 2020 10:50:09 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id sd15sm1079000ejb.66.2020.07.24.10.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 10:50:09 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Fill in conforming {vmx|svm}_x86_ops and {vmx|svm}_nested_ops via macros
In-Reply-To: <1595543518-72310-1-git-send-email-krish.sadhukhan@oracle.com>
References: <1595543518-72310-1-git-send-email-krish.sadhukhan@oracle.com>
Date:   Fri, 24 Jul 2020 19:50:08 +0200
Message-ID: <87zh7on6pb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Krish Sadhukhan <krish.sadhukhan@oracle.com> writes:

> There is no functional change. Just the names of the implemented functions in
> KVM and SVM modules have been made conformant to the kvm_x86_ops and
> kvm_x86_nested_ops structures, by using macros. This will help in better
> readability and maintenance of the code.
>
>
> [PATCH] KVM: x86: Fill in conforming {vmx|svm}_x86_ops and
>
> [root@nsvm-sadhukhan linux]# /root/Tools/git-format-patch.sh dcb7fd8
>  arch/x86/include/asm/kvm_host.h |  12 +-
>  arch/x86/kvm/svm/avic.c         |   4 +-
>  arch/x86/kvm/svm/nested.c       |  16 +--
>  arch/x86/kvm/svm/sev.c          |   4 +-
>  arch/x86/kvm/svm/svm.c          | 218 +++++++++++++++++-----------------
>  arch/x86/kvm/svm/svm.h          |   8 +-
>  arch/x86/kvm/vmx/nested.c       |  26 +++--
>  arch/x86/kvm/vmx/nested.h       |   2 +-
>  arch/x86/kvm/vmx/vmx.c          | 238 +++++++++++++++++++-------------------
>  arch/x86/kvm/vmx/vmx.h          |   2 +-
>  arch/x86/kvm/x86.c              |  20 ++--
>  11 files changed, 279 insertions(+), 271 deletions(-)
>
> Krish Sadhukhan (1):
>       KVM: x86: Fill in conforming {vmx|svm}_x86_ops and {vmx|svm}_nested_ops
>

I like the patch!

I would, however, want to suggest to split this:

1) Separate {vmx|svm}_x86_ops change from {vmx|svm}_nested_ops
2) Separate VMX/nVMX from SVM/nSVM
3) Separate other changes (like svm_tlb_flush() -> svm_flush_tlb()
rename, set_irq() -> inject_irq() rename, ...) into induvidual patches.

Or you'll have to provide a script to review it as a whole :-)

-- 
Vitaly

