Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAE21D759E
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 12:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgERKwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 06:52:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35021 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726279AbgERKwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 06:52:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589799171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7i73MdO6mSnLJfSeLQzf3Paj06/1AUhoEWhZbMxx9q4=;
        b=Ze/27E1N0tXOoYYt7jyn6fXfvXyUBFidjZWIz3XP8DJxl+5jc1L6JCGHagplTDZV+D873g
        tq73g8177GPGmvglYkIQPg51CYE3kYWifTSoAT6zYSpcFhxM+cLjwTRBJJlGX2kyq8iywi
        M+a+s+Iuy5We0VqXA8A2HvrlYWzwVOo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-6iwQ_gLMP9G5NpJSvF41eQ-1; Mon, 18 May 2020 06:52:50 -0400
X-MC-Unique: 6iwQ_gLMP9G5NpJSvF41eQ-1
Received: by mail-wr1-f70.google.com with SMTP id z16so5480259wrq.21
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 03:52:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7i73MdO6mSnLJfSeLQzf3Paj06/1AUhoEWhZbMxx9q4=;
        b=dX6QXyKkjiXWp9/s8ZcFjpsHJ9xoEbk4j1AJ4pW54Oo1e6gvve+aO9eF8LwngTOAdN
         r9tKKhoxEsE2e4mKmCsRtABR7BkE6q2pLScY+D5U3g53l5/1lrS1E1nlOEwywM2i5uu0
         SdzlLqTUj/FPSudbI0N6PZrz/yyDpxGTj9dYJ/pVc1ilYuxyKkuU+7xeVbgl8uOIhtov
         5xlpCaqOWJcJ4OV3mXvS5zvipKtU88ZhWJ+XWLwJO+JwVtej5k4w7FH4qVI0ccKkhLlj
         vNR4yaN5GNWmQvmN/Ux+VbfUVMiSOkEnFvjyBt2vcSXoKt8yC7azkRqPAVDb6OxDEtz5
         zqeg==
X-Gm-Message-State: AOAM532Ns7NRep1ns7+pXWVeOIT7FmwDxUF8R5D4jPnAKjdnyPunIKkJ
        x7WI2rjWrwsCgV7ZW4eScKIMw5f06m2sd7Ne5lTEzYXwLCLrLeHitg092r/B7QPlex81uRELoSK
        3p8mT8h1WNpNB
X-Received: by 2002:a7b:cd04:: with SMTP id f4mr13204926wmj.118.1589799169118;
        Mon, 18 May 2020 03:52:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyb5bJSjhIwujoAPyEeSV2lEHQs6rr/TIG41qjwncep2S48dLrjzAAz5OSj0DtYMHlyn0kYKA==
X-Received: by 2002:a7b:cd04:: with SMTP id f4mr13204900wmj.118.1589799168906;
        Mon, 18 May 2020 03:52:48 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.90.67])
        by smtp.gmail.com with ESMTPSA id x17sm15630846wrp.71.2020.05.18.03.52.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 03:52:48 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: VMX: replace "fall through" with "return" to
 indicate different case
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1582080348-20827-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <50b2bf9b-d4c3-e469-1ef9-3d58b44f4de8@redhat.com>
Date:   Mon, 18 May 2020 12:52:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1582080348-20827-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/02/20 03:45, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> The second "/* fall through */" in rmode_exception() makes code harder to
> read. Replace it with "return" to indicate they are different cases, only
> the #DB and #BP check vcpu->guest_debug, while others don't care. And this
> also improves the readability.
> 
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a13368b2719c..5b8f024f06c2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4492,10 +4492,8 @@ static bool rmode_exception(struct kvm_vcpu *vcpu, int vec)
>  			return false;
>  		/* fall through */
>  	case DB_VECTOR:
> -		if (vcpu->guest_debug &
> -			(KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
> -			return false;
> -		/* fall through */
> +		return !(vcpu->guest_debug &
> +			(KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP));
>  	case DE_VECTOR:
>  	case OF_VECTOR:
>  	case BR_VECTOR:
> 

Queued, thanks.

Paolo

