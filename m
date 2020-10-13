Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F4028C936
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 09:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390054AbgJMH1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 03:27:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44339 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389874AbgJMH1U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Oct 2020 03:27:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602574038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U29b+DpSNEK8t7VlArhSyxRK4Bdvo64dhfMqIFz57jI=;
        b=Tikn7NUcWUEWnTzMrc/bhhgLXNogzAAMQW9NynZo0eo4WaT0xGme9aVG9tg3FYD3gGIKqm
        ooMAxA01Ef4LRZNQh88cFO/ql8dxY84rmAIpRyJO4HzgTwqEaIu1F4k4ZiCoYJORmLKHqw
        Fb8OrPKYIWJtbOdULSDxGXRhrmnnyqQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-j6AO5cC-M_mGhGAQkzfEaQ-1; Tue, 13 Oct 2020 03:27:16 -0400
X-MC-Unique: j6AO5cC-M_mGhGAQkzfEaQ-1
Received: by mail-wr1-f71.google.com with SMTP id m20so4177430wrb.21
        for <kvm@vger.kernel.org>; Tue, 13 Oct 2020 00:27:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U29b+DpSNEK8t7VlArhSyxRK4Bdvo64dhfMqIFz57jI=;
        b=By8U3giBO3JaYnHQyKxJdXL23y/MGGiqFNMg7q5MHFUVdRMdPDiFuQuuUacFL6az/+
         cIyi54hJAvo4S1/Ap0TT4GfLd70JeGZen6ioCTqgDTMKPPU7pEQq87PGE/jh8dCrdcqr
         pDrWNk4mS9zYNGv8Sb4f2KyuBq6nx/Xtqw4azZ/HsA6dVtDNfjKXqPJz1lhpa7xh6/qI
         Mom4mp8YzlnT7YAlvaFXS5b8Jw4dWsXXudqtQyBvzi15xB423Oxs/VgeVJXrpglB6xIs
         ro98DUNYkXhhBSHnHdla31BV4mN1RbMU961US2im3j3CXlkOADCU+BWxn0N2J8TDbTp4
         TLgw==
X-Gm-Message-State: AOAM531D3jOsU9Oa6q5AxBoe3nGRlPJzJJh+KX+0WZvrWt7Vv6v8BQuZ
        kDyKUtwEGYaYGWIu+NyhYO4zS2KWQFTj2eRK2S8cC5aZ+ZhxEOSX68owtuuBEk0JWeQ7XRW60wS
        Dlb7CoFzxZPhe
X-Received: by 2002:adf:e78b:: with SMTP id n11mr35392294wrm.280.1602574035544;
        Tue, 13 Oct 2020 00:27:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQQxP8+9P0wsLZ02YH3DOZOSRsW9JaGdCw5AWhVTclsuWN0jiwlLQJrBd+Ygaz9BMFlz6mIg==
X-Received: by 2002:adf:e78b:: with SMTP id n11mr35392272wrm.280.1602574035354;
        Tue, 13 Oct 2020 00:27:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:61dd:85cb:23fc:fd54? ([2001:b07:6468:f312:61dd:85cb:23fc:fd54])
        by smtp.gmail.com with ESMTPSA id t124sm27268833wmg.31.2020.10.13.00.27.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 00:27:14 -0700 (PDT)
Subject: Re: [PATCH 04/35] dmem: let pat recognize dmem
To:     yulei.kernel@gmail.com, akpm@linux-foundation.org,
        naoya.horiguchi@nec.com, viro@zeniv.linux.org.uk
Cc:     linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xiaoguangrong.eric@gmail.com,
        kernellwp@gmail.com, lihaiwei.kernel@gmail.com,
        Yulei Zhang <yuleixzhang@tencent.com>,
        Xiao Guangrong <gloryxiao@tencent.com>
References: <cover.1602093760.git.yuleixzhang@tencent.com>
 <87e23dfbac6f4a68e61d91cddfdfe157163975c1.1602093760.git.yuleixzhang@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <72f4ddeb-157a-808a-2846-dd9961a9c269@redhat.com>
Date:   Tue, 13 Oct 2020 09:27:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <87e23dfbac6f4a68e61d91cddfdfe157163975c1.1602093760.git.yuleixzhang@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/10/20 09:53, yulei.kernel@gmail.com wrote:
> From: Yulei Zhang <yuleixzhang@tencent.com>
> 
> x86 pat uses 'struct page' by only checking if it's system ram,
> however it is not true if dmem is used, let's teach pat to
> recognize this case if it is ram but it is !pfn_valid()
> 
> We always use WB for dmem and any attempt to change this
> behavior will be rejected and WARN_ON is triggered
> 
> Signed-off-by: Xiao Guangrong <gloryxiao@tencent.com>
> Signed-off-by: Yulei Zhang <yuleixzhang@tencent.com>

Hooks like these will make it very hard to merge this series.

I like the idea of struct page-backed memory, but this is a lot of code
and I wonder if it's worth adding all these complications.

One can already use mem= to remove the "struct page" cost for most of
the host memory, and manage the allocation of the remaining memory in
userspace with /dev/mem.  What is the advantage of doing this in the kernel?

Paolo

