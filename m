Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF1B7B86DA
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 19:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbjJDRnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 13:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233386AbjJDRnj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 13:43:39 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C10A6;
        Wed,  4 Oct 2023 10:43:34 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-4054f790190so511035e9.2;
        Wed, 04 Oct 2023 10:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696441413; x=1697046213; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dJRQHEYymuYT6nedrf8OXg+ScX94IEj3289OiZXUtTA=;
        b=QlyP8lflVavHV75zXROO8o/BeD/M8zeB/scEYRS5KqwtwfrWiwnuO6sPOM+muMZVxH
         4Bz8k0aC2QQn3NVVRTwPKmtdkYJTC4M9b/kuUu/048XUAAjMHfCGj2RllYgyL7ZisCdl
         p647z3VN6dnq+0hyamzfeUOIzakh54wwQ2lztMw5Da+nIz9Ukvcnk4TpowBRg3Hh6f4N
         lLN02SJzxndiviTAM5LzY0InU3knKtGClcPfa6To9eomyyY9bwiy7WrIYXKZeKUFPjxq
         bDLJUaoTsjoqyzha1n6rJ2GRHx2N6Be38MjObEyDkUxL960nVq9YbI7fGzeuSqfuM6d6
         720w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696441413; x=1697046213;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dJRQHEYymuYT6nedrf8OXg+ScX94IEj3289OiZXUtTA=;
        b=SVZ5XcSABbc16y6cU43YuFeMEHip9sEN+hnG0ntkwc2tdO2T5qffbuEXcVhXgZCNmz
         wQI8LB+MHy2+mnwjs/zB1aIAKbULVsI/EEY5xAbbbDFb1kele1YMjM83LU4+tRZPL1SE
         nxy2fG3PdZUHTfZeMsCyyy4PQPtPdm8xHIC9pOrNP6hjkZupZz+Z2rFkapO11ikNkSwM
         NfHdxQ4t8WQAzZZf3LClhyndWSLwuUSe9594kTVLRFuvUZA90EDYxVcSqCR1d0uI2XOf
         6V5F4u86+fLiaVyKStVe2y8fpRqg9b40KOmA5IoAoRMPYqniAKTG6uHyjZAOp4LSyhaO
         r3Ng==
X-Gm-Message-State: AOJu0YxzZFyogDMCmHGzoqc7JAgJPgyQmt4UCGkp89+iIQsXIVNswSxE
        G1xJy/kNKwU4E8bBG4F9LBk=
X-Google-Smtp-Source: AGHT+IHOn9nqWNjhJpX+oURiK5wOk58C7aADmpFqXHJyH7nzPYxBbR3pP3bZ3YjQO7+7UqjBDA5Wbw==
X-Received: by 2002:adf:f546:0:b0:317:634c:46e9 with SMTP id j6-20020adff546000000b00317634c46e9mr2940564wrp.43.1696441412660;
        Wed, 04 Oct 2023 10:43:32 -0700 (PDT)
Received: from [192.168.196.117] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id bl40-20020adfe268000000b003233b554e6esm4545585wrb.85.2023.10.04.10.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Oct 2023 10:43:32 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <8799ca02-61b2-46c4-855e-97d8a534d9e0@xen.org>
Date:   Wed, 4 Oct 2023 18:43:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH] KVM: xen: ignore the VCPU_SSHOTTMR_future flag
To:     Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Durrant <pdurrant@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
References: <20231004171102.2073141-1-paul@xen.org>
 <f5e08c03f6815945588f3eaf47dcee9ff166800e.camel@infradead.org>
 <ZR2iHd18_FsyeWxP@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <ZR2iHd18_FsyeWxP@google.com>
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

On 04/10/2023 18:34, Sean Christopherson wrote:
> On Wed, Oct 04, 2023, David Woodhouse wrote:
>> On Wed, 2023-10-04 at 17:11 +0000, Paul Durrant wrote:
>> nit: I think the commit title should probably be 'KVM: x86:' and then
>> mention Xen somewhere in the rest of the line?
> 
> I would also be ok if we start doing "KVM: x86/xen:", because it seems like y'all
> are sending enough Xen specific changes that differentiating would be useful.

Ok, I'll send a v2 with an amended subject line.

   Paul
