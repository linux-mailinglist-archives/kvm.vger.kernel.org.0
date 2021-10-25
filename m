Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3CED43951A
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 13:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhJYLqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 07:46:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232168AbhJYLqV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 07:46:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635162239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=izsm49eA61qZ8qdVa2a+I7K8OqA1n1lR0Zdrq4VQPXo=;
        b=Moh/z82CEOxL3M9hxUdDtRm7HF4K5zdQdxVPum0w+6sFigW+4/EFfxfCzFLIeGhFq7/DwI
        gLkgxLiYqG7rpc9Gxcrm3SvXLmDc/Ftjf5/XjSI1mnkSG6R5cqbxWrfZFC/WpY8yJfPAuK
        SyQjjMQpIQgJqA5Z4qdLZ+PRBFW8MC8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-bODP2OqyPEm_vaDj8WTuXg-1; Mon, 25 Oct 2021 07:43:58 -0400
X-MC-Unique: bODP2OqyPEm_vaDj8WTuXg-1
Received: by mail-wr1-f72.google.com with SMTP id u15-20020a5d514f000000b001687ebddea3so1649900wrt.8
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 04:43:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=izsm49eA61qZ8qdVa2a+I7K8OqA1n1lR0Zdrq4VQPXo=;
        b=B+vJYX1CgtRJS2xPqbCSAieR+5scjR+FyJ4qfh/P90YMobG8e3H1JoGzRnLCAZtJUQ
         t0sMoh1qZOM1tkPmw/4fBy4FcLDqdulK3irMuQZdm3Obub3XrU/L5aWFMwV3HMolgp5m
         hjZ36v2DPBEbz/wqk3qAVBgm4xB6LYB/xI4oup+MviY+IxkKX9PPVTpNxx+PFgwNV5Eu
         hRRxK6SiZzlDj3oac83RjFYsdqJgl4xDabecuZaW0uUP/xIV58lCa1k+/zKCxioobdkI
         VYBE5JjsWcQjBAIYc7X5qwM9vMVJ1htSJoVo8+OLm4xX0TDc7WJPY7CrYXG1iDD13SZn
         1v+w==
X-Gm-Message-State: AOAM5334enisqDz0rC44JGLK7kgEjyvkcqed9Ev1wWautdQCNq8LIlEo
        BMJpaSKlKk+ZD8b0cNzXYxVFFBgar3BmXELsJlzyJekHiJKVTQj0hqf7LVyEQbZjNK5Ce6VAXWd
        JPasC+6hCxyZv
X-Received: by 2002:a1c:7413:: with SMTP id p19mr25853658wmc.141.1635162237033;
        Mon, 25 Oct 2021 04:43:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw22BzL1PnBqBmTOo35Iin9jNquZ+OaAgF1WuDKGlMZUBYw23A1OI0oH8oyqeJXtNKJ+Bs7Wg==
X-Received: by 2002:a1c:7413:: with SMTP id p19mr25853636wmc.141.1635162236728;
        Mon, 25 Oct 2021 04:43:56 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o6sm2860052wrs.11.2021.10.25.04.43.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 04:43:56 -0700 (PDT)
Message-ID: <e5db0fcc-f4a0-b12a-d75e-5f9c4f746126@redhat.com>
Date:   Mon, 25 Oct 2021 13:43:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: x86/xen: Fix runstate updates to be atomic when
 preempting vCPU
Content-Language: en-US
To:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
References: <3d2a13164cbc61142b16edba85960db9a381bebe.camel@amazon.co.uk>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <3d2a13164cbc61142b16edba85960db9a381bebe.camel@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/21 21:47, Woodhouse, David wrote:
>   	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->state) !=
>   		     sizeof(vx->current_runstate));
>   	BUILD_BUG_ON(sizeof(((struct compat_vcpu_runstate_info *)0)->state) !=
>   		     sizeof(vx->current_runstate));

We can also use sizeof_field here, while you're at it (separate patch, 
though).

Paolo

