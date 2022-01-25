Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEE849B8BD
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 17:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1583579AbiAYQdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 11:33:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43122 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380697AbiAYQ34 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 11:29:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643128196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fm9WWu0faiQMFXbo4MXjVv/GAy+IAbLvYczCrakEplo=;
        b=APsIA8R8gEB0TNSAz3WmRwHZzRP/necNQogRfrwdZHBvtVA3lR+lx7FnMy8lmj/miHyESi
        qkf/OcjZwinFCo40DnSW1PICfvtw8u5Ta+XY+nlFMazGYTpv0S6v6F6XYz1tk6QZdk6SQw
        lRHNpD/daG1DFwqhOzGFsB2twICoFXU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-139-bElO4FO5PdiJqirnWYv_3A-1; Tue, 25 Jan 2022 11:29:54 -0500
X-MC-Unique: bElO4FO5PdiJqirnWYv_3A-1
Received: by mail-ej1-f71.google.com with SMTP id rl11-20020a170907216b00b006b73a611c1aso2947040ejb.22
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 08:29:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fm9WWu0faiQMFXbo4MXjVv/GAy+IAbLvYczCrakEplo=;
        b=oehqOti27toAbhZ0rG5F+cAwgi4xV0tElxhssQq8SbJ0haerdPkM0HT4jVys9LXgVf
         rLZCqKZgBPh0slhzSYB5348kLi6aWbLTEVKyGFyFOgW1UKbaLHalSCsOTC6AYMxnk9HN
         3CTUPclICE1V3cciSpQawRd1GgpKeBhJxbFi3CLhVx1Y43L66JfeB2rFJ8DP6nPfxZvh
         z5WBLogyu8gqLOoDT4REb184gQLe8BOC39M/MD6RR72QtLJMWM8LjL1YOI0AGTURmWNQ
         Z+2owyUlbLv2kDb6nKu3h7czo2zp90hyiLnyDMctiw26LXfN9fsuSqN+EHME+EXsvGnj
         vzGw==
X-Gm-Message-State: AOAM533fp4dJAMTOIIZpOAh8PcCMfrf8RkbJRXaM/1JnzU4F5hZVCT6s
        4AuRDRp/3WTu3J8eMao8X+3JBBvrxpGqsp/RCAISKbiQrSR/o9hU9Lc+Meo5xlcAR+XuSJYR6sL
        Yc8iegSjm6lSe
X-Received: by 2002:a17:907:3e88:: with SMTP id hs8mr12853791ejc.743.1643128193295;
        Tue, 25 Jan 2022 08:29:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyKwNpvtqJA38vo20uXzUC0Uj8KV4HXRnzIcI2KroYnv/40og58KYBI7L/8kTZg74P+SxrLVQ==
X-Received: by 2002:a17:907:3e88:: with SMTP id hs8mr12853771ejc.743.1643128193100;
        Tue, 25 Jan 2022 08:29:53 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id 5sm8803972edx.32.2022.01.25.08.29.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 08:29:52 -0800 (PST)
Message-ID: <e76ee516-4438-295d-5e1e-698644374d87@redhat.com>
Date:   Tue, 25 Jan 2022 17:29:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 15/19] KVM: x86/emulate: Remove unused "ctxt" of
 task_switch_{16, 32}()
Content-Language: en-US
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220125095909.38122-1-cloudliang@tencent.com>
 <20220125095909.38122-16-cloudliang@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220125095909.38122-16-cloudliang@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 10:59, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> The "struct x86_emulate_ctxt *ctxt" parameter of task_switch_{16, 32}()
> is not used, so remove it. No functional change intended.

This is actually removing tss_selector, but it's okay.

Paolo

> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>   arch/x86/kvm/emulate.c | 11 ++++-------
>   1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index c2d9fe6449c2..9e4a00d04532 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3020,8 +3020,7 @@ static int load_state_from_tss16(struct x86_emulate_ctxt *ctxt,
>   	return X86EMUL_CONTINUE;
>   }
>   
> -static int task_switch_16(struct x86_emulate_ctxt *ctxt,
> -			  u16 tss_selector, u16 old_tss_sel,
> +static int task_switch_16(struct x86_emulate_ctxt *ctxt, u16 old_tss_sel,
>   			  ulong old_tss_base, struct desc_struct *new_desc)
>   {
>   	struct tss_segment_16 tss_seg;
> @@ -3159,8 +3158,7 @@ static int load_state_from_tss32(struct x86_emulate_ctxt *ctxt,
>   	return ret;
>   }
>   
> -static int task_switch_32(struct x86_emulate_ctxt *ctxt,
> -			  u16 tss_selector, u16 old_tss_sel,
> +static int task_switch_32(struct x86_emulate_ctxt *ctxt, u16 old_tss_sel,
>   			  ulong old_tss_base, struct desc_struct *new_desc)
>   {
>   	struct tss_segment_32 tss_seg;
> @@ -3268,10 +3266,9 @@ static int emulator_do_task_switch(struct x86_emulate_ctxt *ctxt,
>   		old_tss_sel = 0xffff;
>   
>   	if (next_tss_desc.type & 8)
> -		ret = task_switch_32(ctxt, tss_selector, old_tss_sel,
> -				     old_tss_base, &next_tss_desc);
> +		ret = task_switch_32(ctxt, old_tss_sel, old_tss_base, &next_tss_desc);
>   	else
> -		ret = task_switch_16(ctxt, tss_selector, old_tss_sel,
> +		ret = task_switch_16(ctxt, old_tss_sel,
>   				     old_tss_base, &next_tss_desc);
>   	if (ret != X86EMUL_CONTINUE)
>   		return ret;

