Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4790E162611
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 13:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgBRMZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 07:25:39 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49658 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726445AbgBRMZi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Feb 2020 07:25:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582028737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zUALy/6rw/WQITi6JawN9LYVRine+PJ4kFmYbzQ+Tno=;
        b=M5WgTAxRKXLJpfruws7l7/Nx1pcMWyvRqRMkvHgIERrNDszUvIFxISwBED+ZGvdSqzmWli
        3w5+s3gPKJK3BUS//ZjK8L++NzMviyEqZPLLVcP0OoDAOPzSBmf0GGfNBsp3X51YIgX2wK
        Wr4papdZ9GIDrphYmt5/8l4HPwm2M9U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-5871is8YP7y7cygIPpol4w-1; Tue, 18 Feb 2020 07:25:35 -0500
X-MC-Unique: 5871is8YP7y7cygIPpol4w-1
Received: by mail-wm1-f71.google.com with SMTP id p26so961646wmg.5
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 04:25:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=zUALy/6rw/WQITi6JawN9LYVRine+PJ4kFmYbzQ+Tno=;
        b=TKutp2opBk8xvVsXHPqmzAySg02XHgmpVAGWDUlr6ScA5Piznm3/EUWLH/D8iw/8R3
         oqOz1evKI4mqlijwIL1XXwiu9gK1gakHDkQf3d5GS26RkmNd4ioG2zbzkIp5xF8Sej0G
         nUnWsdzmXfyt6IDMv69Sq5FIrHCvBrUMBCC+mJYpbohmhb0aFWFmygI6XMAhVmoXUttR
         B5cF472+rFXOPVYfwA+5ANNlF4K2qIcx1hwQ4As7+FFVdgq9e6s428JhTPmBmjkfZN/w
         7wucY/4ZIh+X5srEDVWc2yos7Z32UmnpyqIgoIqtdYb9Efjcc975bnJeq8rU6znToNrP
         4M7Q==
X-Gm-Message-State: APjAAAWQ+qApemP+67RGyJEH6PXav6Qg5lsSod9sAKxCuXKVRLWPQHrf
        3W6cgExiKj6cJUKaVC2qZE1bh/QROeTlQv/0zbfF/wOzpTpgRawhN45C0PZztyXBzZr78aBhBfY
        KbVDHdLerHxOO
X-Received: by 2002:adf:d84c:: with SMTP id k12mr29071456wrl.96.1582028734672;
        Tue, 18 Feb 2020 04:25:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqxhU8pdbXEFSvaSqszpm3vIy1yZrm2dReINqHQSVvV2IHiG18n2f1rI2hRMmHYcZjp8GImIvg==
X-Received: by 2002:adf:d84c:: with SMTP id k12mr29071436wrl.96.1582028734500;
        Tue, 18 Feb 2020 04:25:34 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z10sm3232941wmk.31.2020.02.18.04.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 04:25:34 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: VMX: replace "fall through" with "return true" to indicate different case
In-Reply-To: <1581997168-20350-1-git-send-email-linmiaohe@huawei.com>
References: <1581997168-20350-1-git-send-email-linmiaohe@huawei.com>
Date:   Tue, 18 Feb 2020 13:25:33 +0100
Message-ID: <87wo8k84le.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> The second "/* fall through */" in rmode_exception() makes code harder to
> read. Replace it with "return true" to indicate they are different cases
> and also this improves the readability.
>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a13368b2719c..c5bcbbada2db 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4495,7 +4495,7 @@ static bool rmode_exception(struct kvm_vcpu *vcpu, int vec)
>  		if (vcpu->guest_debug &
>  			(KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
>  			return false;
> -		/* fall through */
> +		return true;
>  	case DE_VECTOR:
>  	case OF_VECTOR:
>  	case BR_VECTOR:

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks!

-- 
Vitaly

