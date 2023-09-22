Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15187AB51D
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 17:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjIVPuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 11:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbjIVPuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 11:50:00 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB59199;
        Fri, 22 Sep 2023 08:49:52 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-404314388ceso26035905e9.2;
        Fri, 22 Sep 2023 08:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695397791; x=1696002591; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1pk390ChrTCsthcK4uf4cQzmUvgXyIclFIFBle0EOe4=;
        b=TApFWPOz7fabs3bGMCfGU0A8oMvWDM+ofSqSUcOPdTYhdG/rtTm5dDaxY2GFr7yTNH
         3VwvRS35hqSZjLHCzocjmYMllZsfTJZ02ts/DbuCfKoGrHzeW7jEGfMWFw/I45UnS96d
         oVlmXdy+czyAQ8StdMXvXE0w7moTLjFl7W0NYHiB4n0gmzmHXtBAvtJo9aJXmzBNdXJa
         cSLImh4iPRHANmrUne9ltq79yiqHWOTfsqFi6U9jKt8TRCynrGyVbp9Q8xrTFFdwpY6j
         DLMXfhQmTLIV5fnBa5EVQyMD3KA/EmAMmLmR+MyNBZtG8HHyj7UQ9egEUij69m5P5AK0
         QqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695397791; x=1696002591;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1pk390ChrTCsthcK4uf4cQzmUvgXyIclFIFBle0EOe4=;
        b=cjo6K24oY/VwK5HlrK+GjQfskx7U4pkICV2CjIsR/0w18EUqDd3rhqUwZ5bp6evetN
         MEwyE/X7V6y5i7S+bqnKlfYqmK/HwozdqMIgOCw81yiESjM0pr2I7/ylU/JmYvv+K689
         OTc1yIwbSCTrGOuAwn7FfLGHt9thazyO6+NENhNeK7qemuVjOPViN0BVEh3TTPocLMTg
         V/dkVxbieGIlZi3LCgDUtbYPlvsOU3lK1P/XzewDVR0pMhMZAheBMr2QFCzIsIw2IR5y
         qAav4oK0c5NQ+LELMUG13vuUjrAeDil59koI8blCZ5mOzaQ+sMqOPc4C8is35MFJkV71
         u+Jg==
X-Gm-Message-State: AOJu0YzXVHPduXmb9KYgk/l8wHYzosfl+fL/kZE9M5JFmBtFX4I6qgtd
        +gcH2gCda8ipx0TYrarIp9k=
X-Google-Smtp-Source: AGHT+IEuwq14+VyVLlOeMo0Q6AHsIoBfhMnHDINTyA9JEZwsgFtgEYSJPl/HnNPHn9wFfubJI/toBw==
X-Received: by 2002:a05:6000:118a:b0:31f:eed7:2fd9 with SMTP id g10-20020a056000118a00b0031feed72fd9mr43577wrx.57.1695397790991;
        Fri, 22 Sep 2023 08:49:50 -0700 (PDT)
Received: from [192.168.4.149] (54-240-197-226.amazon.com. [54.240.197.226])
        by smtp.gmail.com with ESMTPSA id p2-20020a5d68c2000000b0031431fb40fasm4755076wrw.89.2023.09.22.08.49.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Sep 2023 08:49:50 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <34457a97-516f-4122-a9d7-920eb3b3c2e0@xen.org>
Date:   Fri, 22 Sep 2023 16:49:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v5 07/10] KVM: xen: allow vcpu_info to be mapped by fixed
 HVA
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
References: <20230922150009.3319-1-paul@xen.org>
 <20230922150009.3319-8-paul@xen.org>
 <8f61e1618f23e975f30e552c09787c5f82ee89f3.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <8f61e1618f23e975f30e552c09787c5f82ee89f3.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/2023 16:44, David Woodhouse wrote:
> On Fri, 2023-09-22 at 15:00 +0000, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
>>
>> If the guest does not explicitly set the GPA of vcpu_info structure in
>> memory then, for guests with 32 vCPUs or fewer, the vcpu_info embedded
>> in the shared_info page may be used. As described in a previous commit,
>> the shared_info page is an overlay at a fixed HVA within the VMM, so in
>> this case it also more optimal to activate the vcpu_info cache with a
>> fixed HVA to avoid unnecessary invalidation if the guest memory layout
>> is modified.
>>
>> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> 
> But it should *only* be defined as an HVA in the case where it's the
> one in the shinfo. Otherwise, it's defined by its GPA.
> 
> Which almost makes me want to see a sanity check that it precisely
> equals &shinfo->vcpu_info[vcpu->arch.xen.vcpu_id].
> 
> Which brings me back around the circle again to wonder why we don't
> just *default* to it.... you hate me, don't you?
> 
> Your previous set of patches did that, and it did end requiring that
> the VMM restore both VCPU_INFO and VCPU_ID for each vCPU *before*
> restoring the SHARED_INFO_HVA on resume, but wasn't that OK?
> 

No. It was painful and overly complex, with too many corner cases that 
were making my brain hurt. Given the pain of the last week, leaving the 
default handling in the VMM is preferable. It means I don't need to
impose rules about attribute ordering and hence get caught by needing
one thread to wait for another inside the VMM. It's better and more 
robust this way.

   Paul

