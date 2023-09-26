Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48AF07AE8DA
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 11:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbjIZJWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 05:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234015AbjIZJWR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 05:22:17 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C86E6;
        Tue, 26 Sep 2023 02:22:10 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-5046bf37ec1so3863704e87.1;
        Tue, 26 Sep 2023 02:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695720129; x=1696324929; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pEubR82kKhu3tOa9yAY875CpIFzn8tiEB3Lg50u4kRo=;
        b=eeN1aOY0+Mwz5Mx6wDa8s2yN9ICKYCLWEKUd6e8eO2JI/Wih9h4MsWwab3H1s8Pt7E
         gGFYExHJR/dERCh3t/wTbVhDTsVWYollnf5v8k1nKbKBLH4J1PZpcr87ysnV4GUOwIK1
         bDu+hmk5NzZf72AenjwH/t1W4tY0DWXmZOacHgJi1EcMKmnNrkVGRRKrTC8PID/Dbdoh
         z45OauqwBfZwDOFW7FHYiKIqE6npiakU2hYXttFpAxrvXmR9ISbrwsDTYkfuA1gJ3hte
         G2+KLbmBjdMyxYW1yqYMS/VPUPEHcu9Dv68zj89k5HWebqGsDIuWFoJ08zJyP79enS69
         Etwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695720129; x=1696324929;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pEubR82kKhu3tOa9yAY875CpIFzn8tiEB3Lg50u4kRo=;
        b=HYw14TyQ7ZxST/UvnRdepuhGyAQeBnoCL6cSww5yCADaopBYeeUpyNv+RXq3ksYhjg
         OHntToi/IMIllVqoZVil9MAQfFtIVbfNjq4bcRRqsqklgIRrRYXeZpPMaNJB53G9ePMZ
         wc3x0OQqDgL/VfIsIgjDeEm8si5mWqfzaD3YbDOBystCrj5LsYM0O00addw1ykBYd8xl
         ucA+Wwtrl+6Rx/UWq8DUbmiQbIXd5ie4XtlYN+4/qgnxN1PbrUSLTPxHZjl9Lsa6BTKh
         OLhJbKLSN2PLjRYIz+qkxiBlGygpMRISkwhkIjWA7i5exuO6RsRhGImMKHEmaiVc3JnX
         l4OQ==
X-Gm-Message-State: AOJu0YzYmcUgfxkLrrEaJjTgtEJMfyGPJsQRQVUoGWgrzzMfShFXIse4
        Pc7ReyFY1WVxTse2OYLEBi4=
X-Google-Smtp-Source: AGHT+IF+KtP3QcLKBXveBnhJaxi5zjPIyU/ScF+ivp5PYEBpi8ScyCKmc3UCDNoNWo9VHPKwrhwFng==
X-Received: by 2002:a05:6512:308f:b0:503:985:92c4 with SMTP id z15-20020a056512308f00b00503098592c4mr8747988lfd.52.1695720128822;
        Tue, 26 Sep 2023 02:22:08 -0700 (PDT)
Received: from [192.168.8.182] (54-240-197-236.amazon.com. [54.240.197.236])
        by smtp.gmail.com with ESMTPSA id t1-20020a1c7701000000b003fe23b10fdfsm17442193wmi.36.2023.09.26.02.22.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 02:22:08 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <5b448307-19f3-4d69-b7f4-3ebedcff030a@xen.org>
Date:   Tue, 26 Sep 2023 10:22:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v5 06/10] KVM: xen: allow shared_info to be mapped by
 fixed HVA
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
 <20230922150009.3319-7-paul@xen.org>
 <0bd42244f232ecc24cbbd2750196758bf7944293.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <0bd42244f232ecc24cbbd2750196758bf7944293.camel@infradead.org>
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

On 23/09/2023 08:07, David Woodhouse wrote:
> On Fri, 2023-09-22 at 15:00 +0000, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
>>
>> The shared_info page is not guest memory as such. It is a dedicated page
>> allocated by the VMM and overlaid onto guest memory in a GFN chosen by the
>> guest. The guest may even request that shared_info be moved from one GFN
>> to another, but the HVA is never going to change. Thus it makes much more
>> sense to map the shared_info page in kernel once using this fixed HVA.
> 
> The words "makes much more sense" are doing a *lot* of work there. :)
> 
> When heckling the cover letter in
> https://lore.kernel.org/kvm/d13e459e221f28fb1865eedea023e583a2277ab1.camel@infradead.org/
> I suggested that the explanation probably wants to make it into a
> commit message rather than just the cover letter which tends not to be
> preserved in the commit history. It's *this* commit which needs it, I
> think.

Ok, I'll try to come up with some concise wording.

   Paul

