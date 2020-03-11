Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D25BA182130
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 19:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730912AbgCKStn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 14:49:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41359 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730788AbgCKStn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 14:49:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583952582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YfBxpaAILUlLDcONCdOQOUUPmTwmQsDDi+kgpOYOtpc=;
        b=SYdqwvGM2qP1rlucV54JQ09PfOj2S+zAHe1VJ5DKv0NrmLJArrC0qSK6rdp/EADbRNm5ER
        Izo8y0sZqUO2Q5tJo541110vwwT2REIx+Cis5RfTtadLDywUKX/+bctZ88qKeTWM01+ecy
        z7FiCciXLF8SggrKEmTfY1jflU/mwhs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-iC_xG8qSNYq6UFnS11oLXQ-1; Wed, 11 Mar 2020 14:49:41 -0400
X-MC-Unique: iC_xG8qSNYq6UFnS11oLXQ-1
Received: by mail-wr1-f70.google.com with SMTP id q18so1354084wrw.5
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 11:49:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YfBxpaAILUlLDcONCdOQOUUPmTwmQsDDi+kgpOYOtpc=;
        b=XSgb97BjLfbOykGOCYbPi8ArAdLGFJL/yCSEYFxJRrBoPsfuzOTiiI2hxkyn52icLz
         bxKn1vGnsOKMY190TlnGUtJrjxs21MkICFLV8tH4vYNd/v3fME+k0n0Ub8/9GxiSxfVD
         1r2QX50KkOL3CZF8mxXJCNQwTkSK9yAsZkHdz5nzXCUfMuGN4uO7CIjbHjVeijfQj9Lu
         oSlsvn1UnINFjgs5b2atN/SbW51d/+WhUNXBgkhMOiKkyVKuy9NK15XCFv4j2zcIkS3D
         rl++IgAdi2l5UAVy3JP6tEjX9y3O2M0Ef2MWguVWmbu/V6FxeIhMvArwg4Q4lLU4hvOb
         cTXg==
X-Gm-Message-State: ANhLgQ22NXxz0QvwWC5PeICoaRu0j+mRG/7IFmGdf0DcDKQxY5PbqzF7
        b9qrn1b3684Oqib0sLDmGkK8WCNhIgvRg3Y88qEEOUWWEC6ZxFIMiDGWN4Vn+E7Oe4xs34Vv8nA
        w+zwKCurvY0NB
X-Received: by 2002:adf:b19d:: with SMTP id q29mr5774418wra.211.1583952579763;
        Wed, 11 Mar 2020 11:49:39 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvW8ZkWjSBV9LLgOlM23YlqBML0RJ6dwxVjP61v6JJHWW3ZRtss5/e2WmLmXCZ0v/RMNvtaQg==
X-Received: by 2002:adf:b19d:: with SMTP id q29mr5774388wra.211.1583952579533;
        Wed, 11 Mar 2020 11:49:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4887:2313:c0bc:e3a8? ([2001:b07:6468:f312:4887:2313:c0bc:e3a8])
        by smtp.gmail.com with ESMTPSA id z11sm9131811wmd.47.2020.03.11.11.49.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 11:49:38 -0700 (PDT)
Subject: Re: [Patch v1] KVM: x86: Initializing all kvm_lapic_irq fields
To:     Nitesh Narayan Lal <nitesh@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        vkuznets@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
References: <1583951685-202743-1-git-send-email-nitesh@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c4370fce-1bc7-3a82-91a7-37fcd013bd77@redhat.com>
Date:   Wed, 11 Mar 2020 19:49:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1583951685-202743-1-git-send-email-nitesh@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/03/20 19:34, Nitesh Narayan Lal wrote:
> Previously all fields of structure kvm_lapic_irq were not initialized
> before it was passed to kvm_bitmap_or_dest_vcpus(). Which will cause
> an issue when any of those fields are used for processing a request.
> This patch initializes all the fields of kvm_lapic_irq based on the
> values which are passed through the ioapic redirect_entry object.

Can you explain better how the bug manifests itself?

Thanks,

Paolo

> Fixes: 7ee30bc132c6("KVM: x86: deliver KVM IOAPIC scan request to target vCPUs")
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  arch/x86/kvm/ioapic.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 7668fed..3a8467d 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -378,12 +378,15 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
>  		if (e->fields.delivery_mode == APIC_DM_FIXED) {
>  			struct kvm_lapic_irq irq;
>  
> -			irq.shorthand = APIC_DEST_NOSHORT;
>  			irq.vector = e->fields.vector;
>  			irq.delivery_mode = e->fields.delivery_mode << 8;
> -			irq.dest_id = e->fields.dest_id;
>  			irq.dest_mode =
>  			    kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
> +			irq.level = 1;
> +			irq.trig_mode = e->fields.trig_mode;
> +			irq.shorthand = APIC_DEST_NOSHORT;
> +			irq.dest_id = e->fields.dest_id;
> +			irq.msi_redir_hint = false;
>  			bitmap_zero(&vcpu_bitmap, 16);
>  			kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
>  						 &vcpu_bitmap);
> 

