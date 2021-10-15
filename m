Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4376D42ED2D
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 11:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbhJOJKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 05:10:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36986 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236166AbhJOJKI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 05:10:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634288881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hJqXmdMFj3XAcDTBzK//awAGj1JnVHCl7MMIlwOu05Y=;
        b=dZrIsedkW1lCFqrErLSiZfsgA3jTit9w9kOBewm2UnRMgkqI8/4ZbZaYRHnnsXldCFe5qL
        3tG/OIcRIvBM4tjdkWAC3QPy0ucGm7XEdZCJmn9kgrxxL+796R8seTPK0AgGSIL/WTCZsl
        yXav18qy9cgi/x3dnvHVb+6o6LVtVFE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-GjzOaqKHOv2eVF3pxixiMw-1; Fri, 15 Oct 2021 05:08:00 -0400
X-MC-Unique: GjzOaqKHOv2eVF3pxixiMw-1
Received: by mail-ed1-f71.google.com with SMTP id t28-20020a508d5c000000b003dad7fc5caeso7635313edt.11
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 02:08:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hJqXmdMFj3XAcDTBzK//awAGj1JnVHCl7MMIlwOu05Y=;
        b=5nXymylAhcq9UuZMwT4drCae0Ex1jfQv3WV9io1Dj4wx51IqOYGUEqrHB2wuX1w6Wy
         AROsYkCkBdljfcBTYk49RD2feVkkVcwbArwv2fWZd/91MTkUUwtMjFooCbHyX9X9oa4b
         9wkaPL71A3djMilPCdSAbgAhcZCnCVNiHT7bJzeo4ukcDO3+M85rPI5lHVQmAdUfhp9M
         2bXM+YdyTPUnVLmB0g+TKNLrlH4L1rn9bKy18a/vgNeJvITv7eGbhSbYgps3LmiI5dtJ
         q/JH63LZ3NNSxQx4xwgzlkqVy2YVBnt7ys9rfsQzHYGORG+JgAwXaSL+VzLYEYGeGjFd
         HGww==
X-Gm-Message-State: AOAM532BNega/HLlBG36SPLTCXi2bhg7S1hB542VM2/CGy8Ytni9kEo4
        7jEmo5bTrErFm22x+nfuaIqlvclm7WFhSe4y0Yscpx4rzbrzZAcn3KsGLmsVGUaQQhN/8PjCg48
        vKSaIbuFK03eF
X-Received: by 2002:a17:906:7113:: with SMTP id x19mr5489025ejj.557.1634288879251;
        Fri, 15 Oct 2021 02:07:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMPJOeGYgYVhEVPIYGY8hDGQ/Y5o3fYULf44dGpiwY5cIXIHynpZokIe5BfdDi1RZ1oSkyzg==
X-Received: by 2002:a17:906:7113:: with SMTP id x19mr5489003ejj.557.1634288879004;
        Fri, 15 Oct 2021 02:07:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dt4sm3616006ejb.27.2021.10.15.02.07.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 02:07:58 -0700 (PDT)
Message-ID: <5ca4405e-e2a8-a940-1c5f-e3a78894d337@redhat.com>
Date:   Fri, 15 Oct 2021 11:07:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: kvm_stat: do not show halt_wait_ns
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Stefan Raspl <raspl@de.ibm.com>
References: <20211006121724.4154-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006121724.4154-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/10/21 14:17, Christian Borntraeger wrote:
> Similar to commit 111d0bda8eeb ("tools/kvm_stat: Exempt time-based
> counters"), we should not show timer values in kvm_stat. Remove the new
> halt_wait_ns.
> 
> Fixes: 87bcc5fa092f ("KVM: stats: Add halt_wait_ns stats for all architectures")
> Cc: Jing Zhang <jingzhangos@google.com>
> Cc: Stefan Raspl <raspl@de.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>   tools/kvm/kvm_stat/kvm_stat | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
> index b0bf56c5f120..5a5bd74f55bd 100755
> --- a/tools/kvm/kvm_stat/kvm_stat
> +++ b/tools/kvm/kvm_stat/kvm_stat
> @@ -742,7 +742,7 @@ class DebugfsProvider(Provider):
>           The fields are all available KVM debugfs files
>   
>           """
> -        exempt_list = ['halt_poll_fail_ns', 'halt_poll_success_ns']
> +        exempt_list = ['halt_poll_fail_ns', 'halt_poll_success_ns', 'halt_wait_ns']
>           fields = [field for field in self.walkdir(PATH_DEBUGFS_KVM)[2]
>                     if field not in exempt_list]
>   
> 

Applied, thanks.

Paolo

