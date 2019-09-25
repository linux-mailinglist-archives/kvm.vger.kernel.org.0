Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC1D9BDEC6
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 15:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406353AbfIYNRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 09:17:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19375 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406329AbfIYNRm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 09:17:42 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2753A2A09C4
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 13:17:42 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id o188so2166674wmo.5
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 06:17:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=KFMcKSB28vicD7mJB9VGf2zDH2JPjeINiiBxo90LMbQ=;
        b=kXm+RlwWFHCkBNMeI+FW5+PydfaZTEk5UvHnT4Ouz2ZIdaXnINwxC8B+lVbL8r0j6x
         FtPJFdvEhc+ZZJXRhJSt9X1WKu3X5bXggMffJneqhTlGrLP0I4bwnlIgcFZlDP3wfsWl
         FID5/6GNs/l5DJOhJS10AT+VLQDAKojyTkIgaqk9vgwIe5vRRunpBNjCgAq/zlZKZ5W+
         4xts63BN7h/NLADAEUHAvQwObHM79P4oVtHDWK13ItOyvehloWrVGmBv2MswMt3sYxVq
         uXIW/Q+Qxh6OHt+/rVbtCm5FQ97HbPF/uG8CUyXiPcL5k5QIX91VI+4dghIqH2agt/63
         72lQ==
X-Gm-Message-State: APjAAAWVzagDKbVdrtmYyitdtubjSkhMRX4eZ0gnrPnfepZ+MqtyLmA/
        JMx41+xOdo5SmpTK0xjikPyFiTYuLsLLBhL+eHD2eKMI/PblQShNUEzeKc72AtnyjPkDBeTfoVO
        RI5odFy5FwY+Y
X-Received: by 2002:a1c:a851:: with SMTP id r78mr7765923wme.166.1569417460905;
        Wed, 25 Sep 2019 06:17:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyDxoF4IGLsMV5Fm6FzZNwokbfobF8/BfLCX5YBkz5lgs3B9lT1iwzQ3B2G/0XzN9ZNkujVRw==
X-Received: by 2002:a1c:a851:: with SMTP id r78mr7765898wme.166.1569417460667;
        Wed, 25 Sep 2019 06:17:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id l10sm7860611wrh.20.2019.09.25.06.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 06:17:39 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: RE: [PATCH] KVM: vmx: fix a build warning in hv_enable_direct_tlbflush() on i386
In-Reply-To: <KL1P15301MB0261653DB1FE73A1EB885E2D92870@KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM>
References: <20190925085304.24104-1-vkuznets@redhat.com> <KL1P15301MB0261653DB1FE73A1EB885E2D92870@KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM>
Date:   Wed, 25 Sep 2019 15:17:39 +0200
Message-ID: <87y2yc7bws.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tianyu Lan <Tianyu.Lan@microsoft.com> writes:

> There is another warning in the report.
>
> arch/x86/kvm/vmx/vmx.c: In function 'hv_enable_direct_tlbflush':
> arch/x86/kvm/vmx/vmx.c:507:20: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>   evmcs->hv_vm_id = (u64)vcpu->kvm;
>                     ^
> The following change can fix it.
> -       evmcs->hv_vm_id = (u64)vcpu->kvm;
> +       evmcs->hv_vm_id = (unsigned long)vcpu->kvm;
>         evmcs->hv_enlightenments_control.nested_flush_hypercall = 1;
>

Missed that one (and I have to admit I haven't compiled my patch on i386
:-). Will send v2 with this included, thanks!

-- 
Vitaly
