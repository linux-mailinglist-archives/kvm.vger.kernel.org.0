Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD4F5F74CB
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfKKN2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:28:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57246 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727054AbfKKN2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 08:28:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573478895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=FoSh0/g3U6MbcnL55kIsQwm9IFAJJTF+M/2yfYHu2HE=;
        b=EoLi5eWRocG4PqLoZTFS9ta00oSQ7i5bZ/CjMACkjDWju2+4v9qi5c+yb2+PdyhHK/kept
        KDFifr1NBdimDhFfaMVkTyPdUNhdyXxb4BQKTWnQ/bdxkQFOnHgMSWAhNe9onuOYxKsdrR
        DEaihP6W83g8U9zYo3TESq2frlYs+/Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-KLf_ugWuMA-l23P4_WSTFg-1; Mon, 11 Nov 2019 08:28:14 -0500
Received: by mail-wr1-f71.google.com with SMTP id f8so9948671wrq.6
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 05:28:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KU+gPyOztTq20GSQTzZSVUPDKxWlRM8qWPtXV9rkkj4=;
        b=VZ7sb37/slTvwvTgmCzZVHRR+rFlpSy3naCs6cBL8PtD2IDLbqugH+kI0YhQekpfFd
         oyM4j5hGgbBrB7IyfxiVTdysEI4CvGfdpzMjcUnlKPPt2r553RBavJ2+XPwFvlqJbKLO
         DuZ2VkSelatrJKbS4hfmW2CWPsIITpbfCY6hOx9utZ7a63GR+BpauYdqsjdH0pPAXi4t
         AnwJUMPsrGh4fSxZFFC9Vmrc0cz0fi8FMXw+Jtu1zmm6kr6FaS6qDIkIlMyzaTWwnf27
         87x+r/fFiH1z9FVKMWw6He0erG2c4jb/ON4XWYGfaG1MlItHv6D0ef2lDn5+lyRqFmgY
         RS3g==
X-Gm-Message-State: APjAAAXIFMxufVCcOFydQouTRQoJ5ZWLbhC0oTD5h6h6jokv0fMrWSkZ
        jVDaI6Fzj8XPBYfixrXVcxeY3YH1v3ZDB2wXRJqvpYdgaTqlt8lwJxxtBWxKsm6lVKHhUhp2jgc
        qdsZKQeT733ob
X-Received: by 2002:a05:600c:23d1:: with SMTP id p17mr21176423wmb.7.1573478893513;
        Mon, 11 Nov 2019 05:28:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqz0aYN7SGDDu0Hz4GSUD/GrUidKZd0dfcCR+q9egopBPToWi9LeErLj1b+SQ+533tRm/Pthhw==
X-Received: by 2002:a05:600c:23d1:: with SMTP id p17mr21176404wmb.7.1573478893173;
        Mon, 11 Nov 2019 05:28:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id j63sm21859722wmj.46.2019.11.11.05.28.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 05:28:12 -0800 (PST)
Subject: Re: [PATCH v1 0/6] KVM: VMX: Intel PT configuration switch using
 XSAVES/XRSTORS on VM-Entry/Exit
To:     Luwei Kang <luwei.kang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, rkrcmar@redhat.com
References: <1557995114-21629-1-git-send-email-luwei.kang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <54ee0d57-098f-32de-6d05-1c614ce9c1ad@redhat.com>
Date:   Mon, 11 Nov 2019 14:28:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1557995114-21629-1-git-send-email-luwei.kang@intel.com>
Content-Language: en-US
X-MC-Unique: KLf_ugWuMA-l23P4_WSTFg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/05/19 10:25, Luwei Kang wrote:
> This patch set is mainly used for reduce the overhead of switch
> Intel PT configuation contex on VM-Entry/Exit by XSAVES/XRSTORS
> instructions.
>=20
> I measured the cycles number of context witch on Manual and
> XSAVES/XRSTORES by rdtsc, and the data as below:
>=20
> Manual save(rdmsr):     ~334  cycles
> Manual restore(wrmsr):  ~1668 cycles
>=20
> XSAVES insturction:     ~124  cycles
> XRSTORS instruction:    ~378  cycles
>=20
> Manual: Switch the configuration by rdmsr and wrmsr instruction,
>         and there have 8 registers need to be saved or restore.
>         They are IA32_RTIT_OUTPUT_BASE, *_OUTPUT_MASK_PTRS,
>         *_STATUS, *_CR3_MATCH, *_ADDR0_A, *_ADDR0_B,
>         *_ADDR1_A, *_ADDR1_B.
> XSAVES/XRSTORS: Switch the configuration context by XSAVES/XRSTORS
>         instructions. This patch set will allocate separate
>         "struct fpu" structure to save host and guest PT state.
>         Only a small portion of this structure will be used because
>         we only save/restore PT state (not save AVX, AVX-512, MPX,
>         PKRU and so on).
>=20
> This patch set also do some code clean e.g. patch 2 will reuse
> the fpu pt_state to save the PT configuration contex and
> patch 3 will dymamic allocate Intel PT configuration state.
>=20
> Luwei Kang (6):
>   x86/fpu: Introduce new fpu state for Intel processor trace
>   KVM: VMX: Reuse the pt_state structure for PT context
>   KVM: VMX: Dymamic allocate Intel PT configuration state
>   KVM: VMX: Allocate XSAVE area for Intel PT configuration
>   KVM: VMX: Intel PT configration context switch using XSAVES/XRSTORS
>   KVM: VMX: Get PT state from xsave area to variables
>=20
>  arch/x86/include/asm/fpu/types.h |  13 ++
>  arch/x86/kvm/vmx/nested.c        |   2 +-
>  arch/x86/kvm/vmx/vmx.c           | 338 ++++++++++++++++++++++++++-------=
------
>  arch/x86/kvm/vmx/vmx.h           |  21 +--
>  4 files changed, 243 insertions(+), 131 deletions(-)
>=20

Luwei, I found I had missed this series.  Can you check whether it needs
a rebase, since I don't have hardware that supports it?

Paolo

