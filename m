Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612854001AA
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 17:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbhICPEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 11:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbhICPEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 11:04:43 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CABDC061760
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 08:03:42 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id f129so5802279pgc.1
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 08:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Orf48Qymoz5f+fX7Ah1Z1mFWpxtUTmn8u/iZMkyoKa8=;
        b=muP6k7WVk+ZfwM3tx/7+DdpIz9xmUlW4n/hJJnkrKchGopWEJO7QLAbBVE0U8Nkds+
         8FZCaW8U2ekAW/6Ss6smKim4za9a6ycNE92CKdQBCF4n3WFI45TXQHMjiYD0NXTvhshQ
         3gmyAPgu0il8Jua3FWlp6kcau+AqlBBYgU/oeyDNk8rOSwjd/KsLnnLyUGZiOy+isKvr
         swTmcyZ/XwQ5/2S6wuBm5qo4B16waZjJR53R4HluPovZ+H54xcttsDp9q0JqpkzfKqnt
         rPcrIdZZ9GyDg9H4zuAO78rCWCIjt/wLxWxaXXHCLY5WNtS45ryk8KXqoR55JWZVP5Xp
         H2+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Orf48Qymoz5f+fX7Ah1Z1mFWpxtUTmn8u/iZMkyoKa8=;
        b=jqZjugZFyA+dFxDFn+uYAuMbGyEfWRp2t1GCGcqvrTe5BLPwzeKyOX+B1adwWbWOf9
         DpfNq+VGjMEtf/k2DS7AiVOcPNSosqW7tn4fGSQQjWEJxbLkcCPccjpkvDSXHHpMiO3d
         bT6IhLnuNT62RfJFCOUIP3+j1/F7jylld7Dj9w2xL/fS1u9wHiHOsFa0T/f1W4BDUoXd
         nfPxKLa3PGWoWuhat6ogXQHvthNgRWTs6DVGGVNSv7NaJb+Ro+yWDSlRWPQlR5sUMkQy
         fhyRzKa3wh+lRBh1PBDInWTnB1zlRZR9QJaPT36kPc/h7oeb1CFP5i/LDIeiHk7NRbxM
         5wAg==
X-Gm-Message-State: AOAM5300TLU9kJP4BSkb1HxCtH99kPb1fVnthCyxejYvFnjRrRxX1kdh
        fwoaLvtzsFEmJfAnfvBz4hQNNg==
X-Google-Smtp-Source: ABdhPJzZ5QFWx1UYVK8K7KK/HottjLsARP6Rwf+7m6SMgBJHHvKxsW+GcSGosJ2Bydm9vXdL4s+Mpw==
X-Received: by 2002:a65:63d0:: with SMTP id n16mr3958589pgv.432.1630681421785;
        Fri, 03 Sep 2021 08:03:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 70sm5899848pfu.93.2021.09.03.08.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 08:03:41 -0700 (PDT)
Date:   Fri, 3 Sep 2021 15:03:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Jiang Jiasheng <jiasheng@iscas.ac.cn>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        pbonzini@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH 4/4] KVM: X86: Potential 'index out of range' bug
Message-ID: <YTI5SYVTJHiMdm+W@google.com>
References: <1630655700-798374-1-git-send-email-jiasheng@iscas.ac.cn>
 <87czppnasv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czppnasv.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021, Vitaly Kuznetsov wrote:
> Jiang Jiasheng <jiasheng@iscas.ac.cn> writes:
> 
> > The kvm_get_vcpu() will call for the array_index_nospec()
> > with the value of atomic_read(&(v->kvm)->online_vcpus) as size,
> > and the value of constant '0' as index.
> > If the size is also '0', it will be unreasonabe
> > that the index is no less than the size.
> >
> 
> Can this really happen?
> 
> 'online_vcpus' is never decreased, it is increased with every
> kvm_vm_ioctl_create_vcpu() call when a new vCPU is created and is set to
> 0 when all vCPUs are destroyed (kvm_free_vcpus()).
> 
> kvm_guest_time_update() takes a vcpu as a parameter, this means that at
> least 1 vCPU is currently present so 'online_vcpus' just can't be zero.

Agreed, but doing kvm_get_vcpu() is ugly and overkill.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86539c1686fa..cc1cb9a401cd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2969,7 +2969,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
                                       offsetof(struct compat_vcpu_info, time));
        if (vcpu->xen.vcpu_time_info_set)
                kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
-       if (v == kvm_get_vcpu(v->kvm, 0))
+       if (!kvm_vcpu_get_idx(v))
                kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
        return 0;
 }
