Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEE3473244
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 17:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241021AbhLMQxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 11:53:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45971 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237179AbhLMQxO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 11:53:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639414393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DR00qm4+umClllZ9CSbjkDci9NLaK9U/TcJkdgDx9Og=;
        b=OCW7iorBhHYXBeSXnE1Hw8fcQ2zrQKcHZs+a/LHj7pZ8Cy9sv5SANtnrMuRRFD+fCkvk/k
        o4E/Pgr1Jr/WYwvbcMqn4C0CKXrssDKqBxY5LO10jeHp/3LFA3KI+tdIQFaSRKFu8y1cdK
        k/vvqDYwhcQI1arPNq2Sam6wcv733ME=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-0w6EsdceP7-wIBPICcFVJg-1; Mon, 13 Dec 2021 11:53:12 -0500
X-MC-Unique: 0w6EsdceP7-wIBPICcFVJg-1
Received: by mail-wm1-f72.google.com with SMTP id ay34-20020a05600c1e2200b00337fd217772so6699776wmb.4
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 08:53:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DR00qm4+umClllZ9CSbjkDci9NLaK9U/TcJkdgDx9Og=;
        b=mFV0FLMpkd/JFWp5eItPHcf+ZoxrjxskpD0GynCZRNmOadYQz1d349LNPfOlgdkYKP
         c6dqCev7IaD6hoj4bKwA4FjjUSm71QrxaOdufOu/BZrMEvYcA1Wi54kWm7Y0dwYEMSf1
         xUaWXIYlH4ndfFyVdyCiM/F2dn48dZUBdmxemJCwcqc+JVrZ6rV83IZu3OsB1yKN8rnW
         zMk3KftFAnNgAG70AoIGjzRBn/F4bv9ruGiWmuLsOF8sA8K87lbJNAxCNTVKnkDvq9eG
         PWVxQOhreqVKSx2w8YCQHwXgnmC1Xj1J7q/mNmgWL0rfswEHrevDFSEFLRUbDJmVZXno
         Vfyg==
X-Gm-Message-State: AOAM5336k/O3BvSKjSg8JS1dDyvBQ8Jy9M9L4UVMGAnsfYRapKJL4G7Y
        /T3rOjWkqSjmK9GEl0OgfKvYI05JC8tY/05BKzaNdX6K2YhpS8q67R9MANLpmPyddfHSBDtHUGV
        ygK3xUERIfev3
X-Received: by 2002:a7b:c256:: with SMTP id b22mr38675472wmj.176.1639414391472;
        Mon, 13 Dec 2021 08:53:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy9Whyxn3/Nyu4vyyaWULQGY99yFCS5IGAccxzJM+sLywPnUZSW7c/PeU4WYzU/6rHILKdcSg==
X-Received: by 2002:a7b:c256:: with SMTP id b22mr38675451wmj.176.1639414391282;
        Mon, 13 Dec 2021 08:53:11 -0800 (PST)
Received: from fedora (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g16sm9196894wmq.20.2021.12.13.08.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 08:53:10 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Subject: Re: [PATCH] KVM: x86: Inject #UD on "unsupported" hypercall if
 patching fails
In-Reply-To: <20211210222903.3417968-1-seanjc@google.com>
References: <20211210222903.3417968-1-seanjc@google.com>
Date:   Mon, 13 Dec 2021 17:53:04 +0100
Message-ID: <87wnk8v43z.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Ideally, KVM wouldn't patch at all; it's the guest's responsibility to
> identify and use the correct hypercall instruction (VMCALL vs. VMMCALL).
> Sadly, older Linux kernels prior to commit c1118b3602c2 ("x86: kvm: use
> alternatives for VMCALL vs. VMMCALL if kernel text is read-only") do the
> wrong thing and blindly use VMCALL, i.e. removing the patching would
> break running VMs with older kernels.
>

FWIW, we also use hypercall patching for Hyper-V emulation (when
HV_X64_MSR_HYPERCALL is written) and this complies with TLFS, we can't
get rid of this. It's a different 'patching' though...

-- 
Vitaly

