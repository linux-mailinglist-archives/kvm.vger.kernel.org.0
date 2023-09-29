Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D56EB7B3387
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 15:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbjI2N0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 09:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbjI2N0N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 09:26:13 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFE711F;
        Fri, 29 Sep 2023 06:26:10 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-406619b53caso2516765e9.1;
        Fri, 29 Sep 2023 06:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695993968; x=1696598768; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=cmv6iXfRTopHDbPBVkKdKDSUtq84pFm/WPY5mj049GY=;
        b=Ks33P91qAADUguPXPT6vNsHlj3CzoyzC3esOalZzbEhMtUQU+gbSGAbcG+9vfg3OOC
         ZrXJQ1bqTZ1iPtC9p/0qrlIPMDrvosa6uUWA20hYUfc6TQBa4BKPokWON6Q/myEzNTP8
         1Hcfc8BJCBfEWorhjheiA0qKKr63Mb6ezb5NSjBCVDnXwstJ3jPMLsLZbcdvcoBEwKX7
         1cH+UySFupVBsuqGKMppDMXq2Mv22pg4oAay0cbz7Ih0UM5wPb43v7vihqReMvJT7GIq
         Wy9N46xibi2v6Y+oF2B7t2v5/NFQQ0jn2lhIaVPxui1bQhLDn5DQy1imaFzuGUPx8chj
         vGOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695993968; x=1696598768;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cmv6iXfRTopHDbPBVkKdKDSUtq84pFm/WPY5mj049GY=;
        b=QIqXX/48KJa/RG7e8KYs2cpvkWB89Ud1BSNoRhMxHlgpfw2jBS1e70HBsdiv90cI+f
         2gb0YmDSFAhbVn5AaeuSL+cdNwF/zBmofv8nY+etzja3fYplAl+Q53t93HRkgKRGypYc
         wd1h78O+vIpIu1l+kzvRZp+q9rcH6q5Gu0mgOJTQtguWOeFUf+k3qA0bI1VOHoIqqS2a
         udWCv9U6gsXr/riyt6TrDxt3jmjiNOUwoyspPsiT4qBLKNrArcOg+ZRKY4+847+bX9oZ
         DsPvQ/b+jUJNcbq972Pn8ot+ZsYCTHg3C48XNt8QSmi87D8kU5+KDKztpZiqiJdyKhNh
         J19A==
X-Gm-Message-State: AOJu0YzSyyzjP1On3ZTJaEyBEbxCJax74/EzvYbpmT+paBYq8iti+6dR
        3MwfpU0m4+8MXV6vhna/Qq0=
X-Google-Smtp-Source: AGHT+IGM2c6/xDc/82D9tWfeNO5ntJ7uN3YkETHPyMeHNSHbB595iRpX8PC4KVreqHWY/TafnyrKOg==
X-Received: by 2002:a5d:4bcf:0:b0:31d:8fed:c527 with SMTP id l15-20020a5d4bcf000000b0031d8fedc527mr3581889wrt.42.1695993968362;
        Fri, 29 Sep 2023 06:26:08 -0700 (PDT)
Received: from [192.168.11.157] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id s7-20020adfea87000000b0030ada01ca78sm21381476wrm.10.2023.09.29.06.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Sep 2023 06:26:07 -0700 (PDT)
Message-ID: <445e4eb9-7bd8-4c7a-82c0-2f1e633e0088@gmail.com>
Date:   Fri, 29 Sep 2023 14:26:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2] KVM: x86: Use fast path for Xen timer delivery
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Paul Durrant <paul@xen.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <a3989e7ff9cca77f680f9bdfbaee52b707693221.camel@infradead.org>
Content-Language: en-US
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <a3989e7ff9cca77f680f9bdfbaee52b707693221.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/2023 12:36, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Most of the time there's no need to kick the vCPU and deliver the timer
> event through kvm_xen_inject_timer_irqs(). Use kvm_xen_set_evtchn_fast()
> directly from the timer callback, and only fall back to the slow path
> when it's necessary to do so.
> 
> This gives a significant improvement in timer latency testing (using
> nanosleep() for various periods and then measuring the actual time
> elapsed).
> 
> However, there was a reason¹ the fast path was dropped when this support
> was first added. The current code holds vcpu->mutex for all operations on
> the kvm->arch.timer_expires field, and the fast path introduces potential
> race conditions. So... ensure the hrtimer is *cancelled* before making
> changes in kvm_xen_start_timer(), and also when reading the values out
> for KVM_XEN_VCPU_ATTR_TYPE_TIMER.
> 
> Add some sanity checks to ensure the truth of the claim that all the
> other code paths are run with the vcpu loaded. And use hrtimer_cancel()
> directly from kvm_xen_destroy_vcpu() to avoid a false positive from the
> check in kvm_xen_stop_timer().
> 
> ¹ https://lore.kernel.org/kvm/846caa99-2e42-4443-1070-84e49d2f11d2@redhat.com/
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
> 
>   • v2: Remember, and deal with, those races.
> 
>   arch/x86/kvm/xen.c | 64 +++++++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 58 insertions(+), 6 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

