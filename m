Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F23734185F
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 10:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhCSJcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 05:32:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229975AbhCSJbu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 05:31:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616146310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xSRPqSlHasWOtKCAmIMpsOHFNUheb5Kd9GbHS0kbp9c=;
        b=ZSAqpK3VNHjWYTgkWRO2bUjgsvBYFHcmR7/7b7giGApPacPyc4Nfs2cIpSlvIczKJdpz7y
        85H8ijmAScNt+b6zRqSiIqAJK7jr5FyRvRfa+/qKaMtbvmkZFlZJIuL9EDKswI0RBRDlI/
        Fv7IRptIVUYnR+gzTXbRsw5qbnhJLgQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-7rsOjahiNu648IevYi-N2g-1; Fri, 19 Mar 2021 05:31:46 -0400
X-MC-Unique: 7rsOjahiNu648IevYi-N2g-1
Received: by mail-ed1-f71.google.com with SMTP id v27so22509931edx.1
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 02:31:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xSRPqSlHasWOtKCAmIMpsOHFNUheb5Kd9GbHS0kbp9c=;
        b=ZviDZborj/1VAwj0kl7lZj+ZxZyUKj2a4fQD4C24coI5GSN1ycllAGEO9vfjSLfYBG
         KKTUmT+Jqc7pJB/bKGMcRHUJZQv9VWrXNO3U39gPLq/c50rRifYEdyO88rA8/c3gDoQ0
         0K5XviDyFTJAJhhFgVO+Sj0d6O2LFg4HSVKevCf4Wowe9fxaywpUJjerH81ZbBwAvzxt
         cvb00qVRrGJNtqrY78uO3jgYGybdQ8DBaxjq/jJ+fkqLYeEodFOXQyix1MF/5jIE6Ct5
         coxDI9D1qgZfIShZtY90l0S8vXBskd04PaTmNiJTJvF+GegNQVO4RdcnZNL/9/WmA4ph
         JKkw==
X-Gm-Message-State: AOAM531bLc53Hjne/bwHR51TMoQeQ0U5fStB65HjPA+/FYZP+kEuWjJa
        2sA7wo/5I/VnqgKsK8tXxNiyskV+R3dSD36o/khpXrW3G0kmNyAlqYwrcXejWH2reTCMPcGKBNh
        Td5YUcbA7mBQy
X-Received: by 2002:a50:ef0a:: with SMTP id m10mr8391621eds.261.1616146304881;
        Fri, 19 Mar 2021 02:31:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3r72fWZ+WnHJwauh+tYRcGl/q0ZdX2psXYYooGwFbKXx25e3vDBNp41L0JN+IfnaYj0jlDQ==
X-Received: by 2002:a50:ef0a:: with SMTP id m10mr8391608eds.261.1616146304755;
        Fri, 19 Mar 2021 02:31:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g21sm3349054ejd.6.2021.03.19.02.31.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 02:31:44 -0700 (PDT)
Subject: Re: [PATCH] documentation/kvm: additional explanations on
 KVM_SET_BOOT_CPU_ID
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-doc@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210319091650.11967-1-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8d48bf1b-208c-89fb-1150-b9d7f589e152@redhat.com>
Date:   Fri, 19 Mar 2021 10:31:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210319091650.11967-1-eesposit@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/03/21 10:16, Emanuele Giuseppe Esposito wrote:
> The ioctl KVM_SET_BOOT_CPU_ID fails when called after vcpu creation.
> Add this explanation in the documentation.
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>   Documentation/virt/kvm/api.rst | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 38e327d4b479..bece398227f5 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1495,7 +1495,8 @@ Fails if any VCPU has already been created.
>   
>   Define which vcpu is the Bootstrap Processor (BSP).  Values are the same
>   as the vcpu id in KVM_CREATE_VCPU.  If this ioctl is not called, the default
> -is vcpu 0.
> +is vcpu 0. This ioctl has to be called before vcpu creation,
> +otherwise it will return EBUSY error.
>   
>   
>   4.42 KVM_GET_XSAVE
> 

Queued, thanks.

Paolo

