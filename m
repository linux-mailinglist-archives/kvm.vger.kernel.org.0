Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841437D4F99
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 14:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbjJXMQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 08:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbjJXMQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 08:16:28 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A5810DD
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 05:16:21 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-408002b5b9fso36299975e9.3
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 05:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698149780; x=1698754580; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XqhLs0VKE4eYGQf3IxDeRGyPalLn8V/39qWJijHHo24=;
        b=S3RH8u/NNAbDyCwBiMkwXPeLuQoH1FFiAUHf0+dAdVQF4LB8QDxDu1Wrzh8o1KBODR
         ABy8GTynb+OMsMULv4fUhpmgb4HmhfYfUP7fFD+c3GcCmkdmSPi/IKRSRPyoN1ERSJoH
         da1fnIXKlrdcji37BC3TIaau1DSo/ySpId11FBf7nM1JVO82ZF75iURaGdw0MUdvaIuA
         DUUnZe2DRCK1YRb2at85qfpwNnxnQg3a0nffDCAy24TQ4UjcmhukIU8sB/AuZ+uHuM94
         4WlVyyy7vqe3rQsXVYBGrrSdYwigPD/NDRIaCClBXuD1BoydfsCuQKyufZA9LgUM4jwO
         it8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698149780; x=1698754580;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XqhLs0VKE4eYGQf3IxDeRGyPalLn8V/39qWJijHHo24=;
        b=Qs7J4PG+tc2c6ytVgVZkbS0ZkMeHHGabs6DuqK5XmewXqKboWc9k7H+WOWQvhN5X3p
         VS/WbYhjVCYIFo41LPsNxnkOm8rNbgiUCN2p3OAqbqhoqJxYbGqkWm9qhG2CgBszLXQu
         z5UHWxaARTj6IrhAcL4hx8MzfZLolXj5pe4oeMnKW4b+1h6YyL3LNustUMeufl0PDYw2
         +UvKtpFL1H0DywNt/FCNzCYoREnrhK/zQ3lJ8Wk+btgOFn62JSn6YuG020Yqe6No+Zyp
         8cYT0jTjLbMCQNpB4k+euzLevO+97Gi1VEPbktH5UKYd08M+wm26pEYpX7dmzuU3C0Zw
         IIzw==
X-Gm-Message-State: AOJu0YxvbYgk68pR3vnm0+9urWbiInXrEhjLn+uKxrfmg8vVFZMm1W9d
        lVcnMqlJl/C3io+NGR0KFsQ=
X-Google-Smtp-Source: AGHT+IE4Z5n2fmffxWcQ/sQr9yuXr/uNARW3iYvgNsmcZBaWl9xNE3uVkib5/sqcnF5f4lyc4e1dbQ==
X-Received: by 2002:adf:e650:0:b0:32d:92fd:9f73 with SMTP id b16-20020adfe650000000b0032d92fd9f73mr7885913wrn.10.1698149779261;
        Tue, 24 Oct 2023 05:16:19 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id w5-20020adfee45000000b00317a04131c5sm9822690wro.57.2023.10.24.05.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 05:16:18 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <456aae8e-ea07-4861-a91b-7c7e28d2a22b@xen.org>
Date:   Tue, 24 Oct 2023 13:16:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 01/12] i386/xen: fix per-vCPU upcall vector for Xen
 emulation
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
References: <20231016151909.22133-1-dwmw2@infradead.org>
 <20231016151909.22133-2-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20231016151909.22133-2-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/2023 16:18, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The per-vCPU upcall vector support had two problems. Firstly it was
> using the wrong hypercall argument and would always return -EFAULT.
> And secondly it was using the wrong ioctl() to pass the vector to
> the kernel and thus the *kernel* would always return -EINVAL.
> 
> Linux doesn't (yet) use this mode so it went without decent testing
> for a while.
> 
> Fixes: 105b47fdf2d0 ("i386/xen: implement HVMOP_set_evtchn_upcall_vector")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   target/i386/kvm/xen-emu.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)

Reviewed-by: Paul Durrant <paul@xen.org>

