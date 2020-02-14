Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C593215D43E
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 10:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgBNJAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 04:00:14 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26063 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728332AbgBNJAO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 04:00:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581670813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x+VX2FQf3kyDtClegJXdB0mBW6VZ2ArXcFukxh9hdjk=;
        b=UOdhSQutDX6vfOwW8DluyJMJb08yGibcdJjkS3EUIT9OfKhjDQQIZx+IZTAd8X2ej2QMnI
        dYJYdSJg99C61Nhkrh3LN0BdUqmCHGOnyBs74hrB4PWU7PRYMcYTvbTbIJCFCral+TOgGF
        K75eOQ6rCD2T9RENia6cm+g7kDyHKX0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-jW9Xo_Y1NRuwNisHQrUYJA-1; Fri, 14 Feb 2020 04:00:11 -0500
X-MC-Unique: jW9Xo_Y1NRuwNisHQrUYJA-1
Received: by mail-wm1-f69.google.com with SMTP id m4so3522619wmi.5
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 01:00:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x+VX2FQf3kyDtClegJXdB0mBW6VZ2ArXcFukxh9hdjk=;
        b=YMhRe5pZJnQRMoiEJ0eaQzxgOejzjGkMwJcg3WiPBl08LFSR5rI8lo3Dq7kjIzroJG
         IJhsxFuRrXkvnypXfhSxgbSNu0SqYc3XdxTf/zkzSZnSDS6ipGHT5vTUTalgFDKw76Im
         m4wg26Ts3lfqPK3R7VJBCSPuKOthJNRYA7mxlF4LgRiFeiS6+rfsl8KIOBn4vfgp36OC
         TnBrunLXF1HuoU0bJ1NclDqNgl66MHur8X4L6RNAp2nvUC8vBAnvPW95jMjsOAy23yUs
         JXo+AHlrebLQylb98S4TrVG6VyvngRahSP3+fwbEMTvY1OrmCo3vQNl/wys1RUBmnfUt
         IQEw==
X-Gm-Message-State: APjAAAWni5Yi39asUisCYp5t0YMCh/YziwSTxeXmj13pIzYWv/NSAKy9
        1yNNQvQTdlkzHRuYZMF/yTO15fHthU3yiVCKjgOYWd8RJrqeLAX2zqw8/Y4zo8td8cS0meFNK3T
        gXA5qPAOmQyAm
X-Received: by 2002:a1c:7419:: with SMTP id p25mr3319350wmc.129.1581670809952;
        Fri, 14 Feb 2020 01:00:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqyEIZIA9Kxrz8amgH46i7rBPtORsj7AocTwH1XDMgMl9UeS6VKJ+PUUPyV6/vdZr2Nk/NDObQ==
X-Received: by 2002:a1c:7419:: with SMTP id p25mr3319301wmc.129.1581670809571;
        Fri, 14 Feb 2020 01:00:09 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id i204sm6932621wma.44.2020.02.14.01.00.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 01:00:09 -0800 (PST)
Subject: Re: [PATCH] KVM: nVMX: Fix some obsolete comments and grammar error
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1581648245-8414-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4fdb28f3-dbaa-34bb-2da4-496ca881fb2a@redhat.com>
Date:   Fri, 14 Feb 2020 10:00:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1581648245-8414-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/02/20 03:44, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> Fix wrong variable names and grammar error in comment.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 657c2eda357c..f2d8cb68dce8 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3160,10 +3160,10 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>   * or KVM_SET_NESTED_STATE).  Otherwise it's called from vmlaunch/vmresume.
>   *
>   * Returns:
> - *	NVMX_ENTRY_SUCCESS: Entered VMX non-root mode
> - *	NVMX_ENTRY_VMFAIL:  Consistency check VMFail
> - *	NVMX_ENTRY_VMEXIT:  Consistency check VMExit
> - *	NVMX_ENTRY_KVM_INTERNAL_ERROR: KVM internal error
> + *	NVMX_VMENTRY_SUCCESS: Entered VMX non-root mode
> + *	NVMX_VMENTRY_VMFAIL:  Consistency check VMFail
> + *	NVMX_VMENTRY_VMEXIT:  Consistency check VMExit
> + *	NVMX_VMENTRY_KVM_INTERNAL_ERROR: KVM internal error
>   */
>  enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  							bool from_vmentry)
> @@ -5301,7 +5301,7 @@ static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
>  }
>  
>  /*
> - * Return 1 if we should exit from L2 to L1 to handle an MSR access access,
> + * Return 1 if we should exit from L2 to L1 to handle an MSR access,
>   * rather than handle it ourselves in L0. I.e., check whether L1 expressed
>   * disinterest in the current event (read or write a specific MSR) by using an
>   * MSR bitmap. This may be the case even when L0 doesn't use MSR bitmaps.
> 

Queued, thanks.

Paolo

