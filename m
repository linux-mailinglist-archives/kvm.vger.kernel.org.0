Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF0A42F7B6
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 18:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241123AbhJOQMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 12:12:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30979 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236309AbhJOQMF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 12:12:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634314198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dnfANBB2I+4/u2R6zdQab17LpLYmlt8K+rtwlvYN/XE=;
        b=byvTG36iAubNLSinp8AA4Dc6JJjYyioUfSsza4xb9Pjjpx2Y5UibAMdRiJC4aRk9JGpWzy
        WO5jig6no345wMPZ2sSGPX+N1GmOR7+alXZJHivFjOCtZKWp2VIuNb/DTGfUZHTSItZZ6N
        3Te3dmnAP94c5IIhslifsLT0BiWDulU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-NhDbqNTeN-SeyW-NM2qtvw-1; Fri, 15 Oct 2021 12:09:57 -0400
X-MC-Unique: NhDbqNTeN-SeyW-NM2qtvw-1
Received: by mail-ed1-f72.google.com with SMTP id g28-20020a50d0dc000000b003dae69dfe3aso8666466edf.7
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 09:09:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dnfANBB2I+4/u2R6zdQab17LpLYmlt8K+rtwlvYN/XE=;
        b=Bc09lEce1rq4GSpZH/BJOdqlY8JxZGhL43DonJO7Wk7Mg/q74uyXI6OewCkLGgeJAY
         8b7YCpZ+OihdqYLZxGjF8qEscdjCqA9P4bZ0fStlp0g9uqEd9R8es8reS0ycWApIbFKr
         16W2i3KMc6e+n5Lx3hYIPTUz4Xj1bCd7/OZICyV0a1hd1nBI1ZKIeDWSnNCtUCgEszck
         4EkXQHU17Bvvs83JDSer7I9ZEN5nswKAvNOwAhBBa6J5o7xp4v2rrg+xAerJs2vh9Cop
         rMs35jLK5rR+3/UEyqAJXDX0H0cYS2k/EpnLHSb/92Jk7OiB9NK8EdwlzhXGQqoynqpu
         MKiA==
X-Gm-Message-State: AOAM531Ir2BvHOy9vV/ED6qrPekpstgWZaNfBQwJT/pbvxjbXEXkpINr
        9uJ8k1g+DlkYkbNzomZ7WX75uxf8n7OtR/acJOHihjXBlMKn9+tYGholHmyUb9er6gI623uuzuJ
        rYIZBRqJXzGqC
X-Received: by 2002:a17:906:2706:: with SMTP id z6mr7963378ejc.551.1634314196167;
        Fri, 15 Oct 2021 09:09:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuWAd7ncZfnIeZgIDTT+YOIcvvrgaaqL/f1aEsFdxWOGgkAlm6Ofb+y9gqqqHUSqC2dkHfwQ==
X-Received: by 2002:a17:906:2706:: with SMTP id z6mr7963357ejc.551.1634314195938;
        Fri, 15 Oct 2021 09:09:55 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a9sm5116649edr.96.2021.10.15.09.09.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 09:09:55 -0700 (PDT)
Message-ID: <8fc633a2-430c-5981-3190-6538b7ed74ec@redhat.com>
Date:   Fri, 15 Oct 2021 18:09:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3] KVM: VMX: Remove redundant handling of bus lock vmexit
Content-Language: en-US
To:     Hao Xiang <hao.xiang@linux.alibaba.com>, kvm@vger.kernel.org
Cc:     shannon.zhao@linux.alibaba.com, seanjc@google.com,
        xiaoyao.li@intel.com, linux-kernel@vger.kernel.org
References: <1634299161-30101-1-git-send-email-hao.xiang@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1634299161-30101-1-git-send-email-hao.xiang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/21 13:59, Hao Xiang wrote:
> Hardware may or may not set exit_reason.bus_lock_detected on BUS_LOCK
> VM-Exits. Dealing with KVM_RUN_X86_BUS_LOCK in handle_bus_lock_vmexit
> could be redundant when exit_reason.basic is EXIT_REASON_BUS_LOCK.
> 
> We can remove redundant handling of bus lock vmexit. Unconditionally Set
> exit_reason.bus_lock_detected in handle_bus_lock_vmexit(), and deal with
> KVM_RUN_X86_BUS_LOCK only in vmx_handle_exit().
> 
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Hao Xiang <hao.xiang@linux.alibaba.com>
> ---
> v1 -> v2: a little modifications of comments
> v2 -> v3: addressed the review comments
> 
>   arch/x86/kvm/vmx/vmx.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 116b089..7fb2a3a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5562,9 +5562,13 @@ static int handle_encls(struct kvm_vcpu *vcpu)
>   
>   static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
>   {
> -	vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
> -	vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
> -	return 0;
> +	/*
> +	 * Hardware may or may not set the BUS_LOCK_DETECTED flag on BUS_LOCK
> +	 * VM-Exits. Unconditionally set the flag here and leave the handling to
> +	 * vmx_handle_exit().
> +	 */
> +	to_vmx(vcpu)->exit_reason.bus_lock_detected = true;
> +	return 1;
>   }
>   
>   /*
> @@ -6051,9 +6055,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>   	int ret = __vmx_handle_exit(vcpu, exit_fastpath);
>   
>   	/*
> -	 * Even when current exit reason is handled by KVM internally, we
> -	 * still need to exit to user space when bus lock detected to inform
> -	 * that there is a bus lock in guest.
> +	 * Exit to user space when bus lock detected to inform that there is
> +	 * a bus lock in guest.
>   	 */
>   	if (to_vmx(vcpu)->exit_reason.bus_lock_detected) {
>   		if (ret > 0)
> 

Queued, with extra *-by tags removed.  Thanks,

Paolo

