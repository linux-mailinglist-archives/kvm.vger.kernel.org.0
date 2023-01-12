Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28567667ACF
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236730AbjALQ3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240159AbjALQ2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:28:53 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B7365BD
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 08:27:50 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id v2so7623434wrw.10
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 08:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WitOV3cOHB+1bVHkyAyXe7dd7LPP1idGNSuKJxs5/9s=;
        b=IppHk41eVYWRVRhHwZsbCdR/fu0aYDvd8bPZTkgeUX2ranwWj3aSLsgPP8pOlP+tP0
         4Fr94kceHbxMSV2s5qGQwldN8CMVvH063ZGoos2oFq5e1wyAVyE0Y3+ahLhwn+ChvQiw
         Hwye2iyt+FKOH0FGoMsvCOtfbJbZctT3gEbRP1k395YFNgk0MFnMaFbkxzIpjigcOWCo
         sevSpq/xnmwfmDTAJl8K2SL6CLT37lgiyuasShOitdr40Vsgsc3WOyIUdkUx2x7drA9d
         0+e80omiq5YweIiTvf1epX8LGnzC8lXxnwLM3blRl4tkcwKWxwZCKS+ReyTxLZ8b3pyX
         lOJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WitOV3cOHB+1bVHkyAyXe7dd7LPP1idGNSuKJxs5/9s=;
        b=Sk3cZyuGQUkV3GzfdIVBmYUJyeagKPmVP6K6l5E07FFbqNkp4A9Mmeh/xw+apVCOyi
         t+YM0+0NGxaBfTydBhwoL3iLXAXBQ13IlVTqdqeMTGLxuJBb5apFg3t74XJoJJV7rFKZ
         EJzPAOAVLxxG6Gt2LKKSntvpR4YYzb2jjbUJ1b423yZhQNntxGnYeJuqXt2Zn/xY0hug
         cKjBOMnT3OsHjhdA4tPhpvBFZwxlmY3lqEJdJ9+3p/b8y1ZtOWoA2Uh3KjXv+HWubdSG
         PTWnNO3luUUoN7/NXFqAM7h4ekeTWxYuk07isDp98zAVgZ5NAETd898lUw8T82Yv9K9P
         6XJg==
X-Gm-Message-State: AFqh2kpSyYYY9TCvyXBcw4GcHiNxh8tq302m6dKugSIgtsKGv9g5VbYY
        Of7KW0dH1/k9SFCuK1AtDooHwDHmhhrw+A==
X-Google-Smtp-Source: AMrXdXsTiX0e+xGQviwRFgt+ol5YsWoioC/RTSVAH+RfsZhB6X2x6NY+/OuIOtnqFOyXkaAbbAgURA==
X-Received: by 2002:a5d:42c7:0:b0:2bc:7f49:d276 with SMTP id t7-20020a5d42c7000000b002bc7f49d276mr8557336wrr.46.1673540869096;
        Thu, 12 Jan 2023 08:27:49 -0800 (PST)
Received: from [10.85.34.175] (54-240-197-225.amazon.com. [54.240.197.225])
        by smtp.gmail.com with ESMTPSA id z18-20020a5d44d2000000b002368f6b56desm20134321wrr.18.2023.01.12.08.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 08:27:48 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <752c4ea4-b244-b07e-7efb-23f6116a255c@xen.org>
Date:   Thu, 12 Jan 2023 16:27:47 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 3/4] KVM: Ensure lockdep knows about kvm->lock vs.
 vcpu->mutex ordering rule
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
References: <20230111180651.14394-1-dwmw2@infradead.org>
 <20230111180651.14394-3-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20230111180651.14394-3-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/01/2023 18:06, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Documentation/virt/kvm/locking.rst tells us that kvm->lock is taken outside
> vcpu->mutex. But that doesn't actually happen very often; it's only in
> some esoteric cases like migration with AMD SEV. This means that lockdep
> usually doesn't notice, and doesn't do its job of keeping us honest.
> 
> Ensure that lockdep *always* knows about the ordering of these two locks,
> by briefly taking vcpu->mutex in kvm_vm_ioctl_create_vcpu() while kvm->lock
> is held.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   virt/kvm/kvm_main.c | 7 +++++++
>   1 file changed, 7 insertions(+)

Reviewed-by: Paul Durrant <paul@xen.org>

