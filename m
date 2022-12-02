Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5D2640351
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 10:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbiLBJ2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 04:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbiLBJ2e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 04:28:34 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CB67B545;
        Fri,  2 Dec 2022 01:28:33 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 136so3943484pga.1;
        Fri, 02 Dec 2022 01:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fs0JIzy4lX8egoTkPwM/l/BKNOdR2IYRmHGc7hnBUhc=;
        b=dbLMStjj6FJUPNQlyPqMl5VRs41CACk/p9hbBm4MJDLR9Xr4OZOdNq5CDjo36fq5uw
         DrAAgmbaGxMHNo1TFU+84juWbNUMPW+Iy0/8wYlRKU0nij19c4G7j8ITEAZI1D13VVdm
         hrpO7DmMvK92Ms8qVYlqYgt+gCN5nXNkXCS0pQW9Zz2x8vh9LjEqWgqkEqHgwALewR/E
         pueIGYpQCit6kRYgyp7J2rVgOxIQgb4laH3ERBF2IN4I2+Wp1Xdi1lufq7wvFelbKhEx
         fpYWV80Nu/0RjFjSsCj5PbRJ18G+eesLeGzjpiMgZAB2sZvgs9wqA5sjO8QYL0gENvs3
         l+ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fs0JIzy4lX8egoTkPwM/l/BKNOdR2IYRmHGc7hnBUhc=;
        b=by0XA9in8GlfOWu/uiXOJLQT3Za9+vsQXnF72C/uCY4PW+7SdhMzWyxbJSazETpzw7
         L0LUJQag01K8yee4Hk/wAm3eWYW6PyYeDGBA/+Q491DiIOYjXs1L2sovw6fYqWtoUFGy
         ba6JdmneECv20NK7R4qzqzOY3Fl8O2UH+95Ghm6zbuNV591pPUg8JgF2jdS5tTFLkKjd
         JBUIL2Ip63OR8IvKv9NfzORP3HxJqCUUgWoQykPcv5DZ8l4UPw/NPpWfFVGcs5znAQ8E
         PGARqoc8jGyGhXVnGGifMbtLplK3eC0Ons8XmRj1XRDywe45X8xnvI3lkZPWtJrP+BON
         Ut6Q==
X-Gm-Message-State: ANoB5pkoazbeq1Qw49tuAq0w2lu4NiPmvOhV+wRbSjwhPmAse04u/lRm
        Ca82GNfDnKxpz18SXsv2/Ak=
X-Google-Smtp-Source: AA0mqf65JqqKHj2qFz7cWUeO996IGldexk+Qcx6YTtKxDzzs+AFh/9Fg1jtlCpw6EtBnFJGFIa+bWQ==
X-Received: by 2002:a63:1142:0:b0:477:e0f7:aba3 with SMTP id 2-20020a631142000000b00477e0f7aba3mr30358340pgr.388.1669973312990;
        Fri, 02 Dec 2022 01:28:32 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 24-20020a630d58000000b0045751ef6423sm3747385pgn.87.2022.12.02.01.28.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 01:28:32 -0800 (PST)
Message-ID: <544d854f-e980-c7bf-39e9-425202760cc5@gmail.com>
Date:   Fri, 2 Dec 2022 17:28:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH v2 05/16] KVM: x86: Remove unused argument in
 gpc_unmap_khva()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20221013211234.1318131-1-seanjc@google.com>
 <20221013211234.1318131-6-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221013211234.1318131-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/2022 5:12 am, Sean Christopherson wrote:
> Remove the unused @kvm argument from gpc_unmap_khva().

Nit: the caller kvm_gpc_unmap() can also get rid of the unused @kvm argument.
