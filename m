Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E14D2154204
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 11:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgBFKlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 05:41:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29381 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726538AbgBFKlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 05:41:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580985680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z3MLvs9QeO5YfLds0ekW7KKa80cPvToO4kODbI4MibM=;
        b=dE3SKuNbRZNjZsuj6i7prRNA0l5X58GUN0L7LAimtYkYPVRkQ14xckOW/1ccqwN1ocFvYo
        LZ1/z1zmvufZTnoXr+pVUdj44HuQryAPwGfcwCRyuhM6a6IQ0BtVHu4ZVT1nBVrB8uiz7R
        x+5mJIQay3X/dTn/2yIUDDOQ0w3v/Dg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-iiRUbR7UMV2eNRzfoyC5TQ-1; Thu, 06 Feb 2020 05:41:18 -0500
X-MC-Unique: iiRUbR7UMV2eNRzfoyC5TQ-1
Received: by mail-wr1-f71.google.com with SMTP id v17so3141209wrm.17
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 02:41:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=z3MLvs9QeO5YfLds0ekW7KKa80cPvToO4kODbI4MibM=;
        b=COJvI755245XpOGg6rlOyavZ1ITyhRqQqF607wAQ9CHN7l4Ucbge9134D7PoP9rxBx
         JCYmWiCc+GDeP9QoRd9s4ukftbQVBGWirAdq940S4foGwzh0n+SmE43Ueztw6cnZUh9P
         OzpzeBEdZqA316ZsPA7uwSajv+5SK25FkHVOXRWOLrml41vTDye1scCyD0RsNUrtZbMA
         VMnTVSU9OOl9eTfGODWYNFmzdDB6DcMV+7Oc1JamenyfqI9aNHSwY6ft+ePzdhKZ3A3n
         F+dl1w6Vc6A7QPFUzGa8IxN8BXbcTtrO3DN9VY6D2u8I7d9mRar4kuR7R+yk1X4KYeqK
         WpxA==
X-Gm-Message-State: APjAAAXdIQL165Khs7VBWmBWyvU7TI1+y50ikGT85XZ/rJo2yARVe3DU
        /UH2dPu2QREVwNSvV6hZHMi5XHZl4tCaSluX8vXVZbzI0WU6KNML+T2u7nJ1CZdei/cL6frH+/t
        AFHpAaPgSOnnd
X-Received: by 2002:a1c:9e89:: with SMTP id h131mr3810488wme.161.1580985677259;
        Thu, 06 Feb 2020 02:41:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqyDh4uumYKMzVvavc7ne4C/+Y4wIseWOIgttAS3dqIsiaZbXeKK3iMa37NwzhkJfhRCKINK7Q==
X-Received: by 2002:a1c:9e89:: with SMTP id h131mr3810455wme.161.1580985677003;
        Thu, 06 Feb 2020 02:41:17 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id e17sm3732182wrn.62.2020.02.06.02.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 02:41:16 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: x86: remove duplicated KVM_REQ_EVENT request
In-Reply-To: <1580953544-4778-1-git-send-email-linmiaohe@huawei.com>
References: <1580953544-4778-1-git-send-email-linmiaohe@huawei.com>
Date:   Thu, 06 Feb 2020 11:41:15 +0100
Message-ID: <87ftfogfqs.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> The KVM_REQ_EVENT request is already made in kvm_set_rflags(). We should
> not make it again.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/x86.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fbabb2f06273..212282c6fb76 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8942,7 +8942,6 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
>  
>  	kvm_rip_write(vcpu, ctxt->eip);
>  	kvm_set_rflags(vcpu, ctxt->eflags);
> -	kvm_make_request(KVM_REQ_EVENT, vcpu);

I would've actually done it the other way around and removed
kvm_make_request() from kvm_set_rflags() as it is not an obvious
behavior (e.g. why kvm_rip_write() doens't do that and kvm_set_rflags()
does ?) adding kvm_make_request() to all call sites.

In case this looks like too big of a change with no particular gain I'd
suggest you at least leave a comment above kvm_set_rflags(), something
like

"kvm_make_request() also requests KVM_REQ_EVENT"

>  	return 1;
>  }
>  EXPORT_SYMBOL_GPL(kvm_task_switch);

-- 
Vitaly

