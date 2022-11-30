Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C600163D7FC
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 15:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiK3OWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 09:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiK3OWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 09:22:11 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918835ADE2
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 06:22:10 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso1513779wmo.1
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 06:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=0IHtiVwCjmlBEYq8MTDzwSDa2nW8ZbVoC4BRykDBeTI=;
        b=Z7Mko0x3+QSZF2vJZdKNO4EvNEVkzCZ8Dz5x6CMugc+/4UFn0fPkRl6XWYgHSaj4Nw
         Ud02wBc0CVh35f3+II8LdHmyCYl81/SP5xz+yZfno2vMwcHBrRV1JqTp1jMpWg6OQAFb
         EA1zZHyqE1hGdrb61sSnf6XPx5ZluA/vBAJvmVGuVv/yImi7dOIyvmZ6rzGMfufEgmmn
         5bSwOtFeiARprRuL0dD8rqXU0dOE9RDamn6O4a9SPx7xyN7XADHwYvD6DKzqQWpdKMM2
         /qvv8d9KZNGMLvjyYTNpTjHcwavNgDOc6vTArNKC4Ekly7O+OaM1+ruUAyPPGsUQCcsK
         XcXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0IHtiVwCjmlBEYq8MTDzwSDa2nW8ZbVoC4BRykDBeTI=;
        b=zeL56O38u467o3dLG2tPX8cZFvuZY0gCkroNT+/3l8jkW9nYOdbXs0Ezhc/OUmbKhL
         Rrp+NOkvsq7aiBpekEYuZe/mwd/kgzEwGz14PBsCh7MizZS0t5wtQRxXQVayHx7Irfd9
         eanQ9UqHLdYYDIrdDHDIBMWxrea4B4KPYI7CHjtHjIzW9aLtUf2Y5d3K0guPSV1w4/I8
         nGhKqyWMYNdhxubnxO3lZ/hB/kXjwO8EsgHsFAntiHuyVwILJyubkQsfsy5PCLZuhNfW
         XiZlmt9X44P5y/hLbw45l0iS61mlmFcQgijGHpN1rkxkNZrePxG9HHcYvrUDmJZ5vGka
         idbg==
X-Gm-Message-State: ANoB5plxwubc+PRiT+gNWgr0AjiObQY67LOUqlxB+sk3/NXfs00hZNWI
        Qp/+joog/z0QK9STaZmBpUM=
X-Google-Smtp-Source: AA0mqf7RzcFdsX7f9/B2vWJ492MEw8oi4xRpCEL6WARvDvcTeoQ00338vK9aTgOGGQQapUqd87CKDQ==
X-Received: by 2002:a05:600c:354d:b0:3cf:45ff:aca with SMTP id i13-20020a05600c354d00b003cf45ff0acamr36040329wmq.53.1669818129188;
        Wed, 30 Nov 2022 06:22:09 -0800 (PST)
Received: from [192.168.23.148] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id f16-20020a056000129000b002421ce6a275sm1656504wrx.114.2022.11.30.06.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 06:22:08 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <ad4594a7-3db0-4469-a21b-562373950d1d@xen.org>
Date:   Wed, 30 Nov 2022 14:22:08 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3] KVM: x86/xen: add support for 32-bit guests in
 SCHEDOP_poll
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm <kvm@vger.kernel.org>, "Kaya, Metin" <metikaya@amazon.com>
References: <1fd9826b2319cc9e58aecf6e11348acd63fdb81c.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <1fd9826b2319cc9e58aecf6e11348acd63fdb81c.camel@infradead.org>
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

On 25/11/2022 15:00, David Woodhouse wrote:
> From: Metin Kaya <metikaya@amazon.com>
> 
> This patch introduces compat version of struct sched_poll for
> SCHEDOP_poll sub-operation of sched_op hypercall, reads correct amount
> of data (16 bytes in 32-bit case, 24 bytes otherwise) by using new
> compat_sched_poll struct, copies it to sched_poll properly, and lets
> rest of the code run as is.
> 
> Signed-off-by: Metin Kaya <metikaya@amazon.com>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>

Reviewed-by: Paul Durrant <paul@xen.org>

