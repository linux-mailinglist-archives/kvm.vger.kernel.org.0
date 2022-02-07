Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8284F4AC693
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 17:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241400AbiBGQ7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 11:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353384AbiBGQoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 11:44:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30FA0C0401D3
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 08:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644252292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JXASh+EywLGlhAlg4jFsCAK0tQKzE6uQ4u5IHhy56MY=;
        b=SS9QSkUI+dnDGbx+k0fUyAXHpAD+QwjzccoaVhL7h3ljMvjGzjrtk4gjoyKy0LeTkyZzEd
        s/ZI36nvE1tyZ24h1kB5ZN3QRFLF6UpoOjoFJzia0Hu41iIAT5cypGrl5jf/lakfPKnP3a
        KO4LWsGcAp/GHir/BGEqlgOLe2wGQXs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-a2b0Z_nHOHqt1D2un7iwOA-1; Mon, 07 Feb 2022 11:44:51 -0500
X-MC-Unique: a2b0Z_nHOHqt1D2un7iwOA-1
Received: by mail-ed1-f70.google.com with SMTP id m4-20020a50cc04000000b0040edb9d147cso7318391edi.15
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 08:44:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JXASh+EywLGlhAlg4jFsCAK0tQKzE6uQ4u5IHhy56MY=;
        b=AIPjc90YQ/Se1KCSHzYr2EZYQtI4seFqJNqgoCrJsOWIq4qBz9AOmEVdJ0YaU/QA3T
         AULWxDi6AO3r/fwhYh0gqFazMTt9BD11zvrLWATNkzkxzicOs9VC+ehRvLm5k6OADz9l
         hkXazI9EcD/SCsh6ibyWHjh/LaF2Y1XCz3rzNL74V/3uqiToXhhQiyUcZyL8owlZLjzN
         vGhqi0+E0PY3W57kSPiUmmYrbf6Ywz+J8C3Qa9YClLadssKddw1O6Ju0wlmYo5cT09Jy
         WElNRMoGr9wofxqY88zz57k1MHzDJ8GEGA7lmBVruJdeZb75pBhTizTb/OPnkiYdlmVQ
         8Wow==
X-Gm-Message-State: AOAM530xZ+8TQVJEWlRNYq7V4ENhS8GgUbHf5UB19h/lN5y+4R9bY+/O
        vcCMtQJyLYx/zo1Tqf3DOVbsCl6146+dmOvJD3w7aZgV3L+IbhqLK0ZTYdvocqDfkgTzhqsleiI
        kzXM+71cNGOUT
X-Received: by 2002:a05:6402:2934:: with SMTP id ee52mr334462edb.9.1644252290078;
        Mon, 07 Feb 2022 08:44:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzVIvJoEuJU3wDHneUFudIoStwD9wbzeB68Ef8g+xfhRwzYcSHu/Qp7n8pAhJpWqEyFTe1aww==
X-Received: by 2002:a05:6402:2934:: with SMTP id ee52mr334440edb.9.1644252289892;
        Mon, 07 Feb 2022 08:44:49 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id k24sm3887374ejv.179.2022.02.07.08.44.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 08:44:49 -0800 (PST)
Message-ID: <e37ff0ec-af46-c7c6-8858-dc2fd93d5b3a@redhat.com>
Date:   Mon, 7 Feb 2022 17:44:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 01/11] Revert "svm: Add warning message for AVIC IPI
 invalid target"
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20220204214205.3306634-1-seanjc@google.com>
 <20220204214205.3306634-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220204214205.3306634-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 22:41, Sean Christopherson wrote:
> Remove a WARN on an "AVIC IPI invalid target" exit, the WARN is trivial
> to trigger from guest as it will fail on any destination APIC ID that
> doesn't exist from the guest's perspective.
> 
> Don't bother recording anything in the kernel log, the common tracepoint
> for kvm_avic_incomplete_ipi() is sufficient for debugging.
> 
> This reverts commit 37ef0c4414c9743ba7f1af4392f0a27a99649f2a.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/avic.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 90364d02f22a..ecc81c48c0ca 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -345,8 +345,6 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>   		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh);
>   		break;
>   	case AVIC_IPI_FAILURE_INVALID_TARGET:
> -		WARN_ONCE(1, "Invalid IPI target: index=%u, vcpu=%d, icr=%#0x:%#0x\n",
> -			  index, vcpu->vcpu_id, icrh, icrl);
>   		break;
>   	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
>   		WARN_ONCE(1, "Invalid backing page\n");

Queued for 5.17, thanks.

Paolo

