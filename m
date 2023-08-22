Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B59783B6E
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 10:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbjHVIKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 04:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233693AbjHVIJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 04:09:55 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB8A196
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 01:09:53 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1bbc87ded50so26673955ad.1
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 01:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692691793; x=1693296593;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ReMukLzPWF9LnG1igHrE94gO4QgjdRUiL5Va8lFBbLM=;
        b=JAErxNNk5ah7gi9Q01OQtrS2a3vp0ndZ6BjM4kfuimELn9wiBpqpcEGxd8l2OF9Aqk
         9XlvnO9yMicIXGbSVwpwByDTybgd8P5P780BHxABeNz9CW+j4khRoPBp+UTxRI2u03b2
         NcnozVPtSWNh37gS/3qOA/2Kp2B2C0xTZoRAdn7IjtxKBj+626cgXlbWmrIKroF63cOM
         ZAEpCTaHwmOTbWQXAg1Rf+CApK/7+TKXcDuk6WhURZLk0iD6H1TWs7KQfgFiXNkJH9Dh
         0QD1aAFe/mfMUeBV+Agzt2jxajgE/n0WGTa3uggsqNvFZVCkyzH0tfZ+08HXSZOMo0DZ
         2eQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692691793; x=1693296593;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ReMukLzPWF9LnG1igHrE94gO4QgjdRUiL5Va8lFBbLM=;
        b=WN8WUwlX+6ze8mJf1Aewt8GqljyW5a4WGb2jl+XpxzY1SJ4F+GYScf+cQEVz8H9n4K
         w1e+2HhFu2pxCNtpn1Wq98sQ1hiGRzzHIIGxGlBYv/s2NsnGojydPNTn67AuuH86Ar+K
         RQhkmfTpfHutV7fE/Su5OLCSV0+//zRhX8GkDckvnzNwwhVh1Edz6x3UHwO0X6d4ANF9
         H36JtvygDlUST/g4BPXQ0k8KmC52HOs4ih+1WD5v1FHwj8yUWWSi1lDZboLuOHywDAmV
         pgHl2s25tFfRDddltEW4gFyw+/yYNrW2l38rPOA1PnAuc6o7Lb8AK9084v7JeL2IXoTE
         E6kQ==
X-Gm-Message-State: AOJu0YxzlLyBFCecVyCKGUJiAUO28olmTXeywkgLlMGa/JSUePfONU6s
        SkgoOD5EfhgmFDTEvMwqzG0=
X-Google-Smtp-Source: AGHT+IEotSHSU6wO+e2Igk8v7gFZAsBWds9LE+kJXAgiFdrdzstcSw+N3XHlmgRZZd+qs7V7PkRzWw==
X-Received: by 2002:a17:902:dac1:b0:1a6:74f6:fa92 with SMTP id q1-20020a170902dac100b001a674f6fa92mr8975731plx.19.1692691792914;
        Tue, 22 Aug 2023 01:09:52 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jw18-20020a170903279200b001bafd5cf769sm8388523plb.2.2023.08.22.01.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Aug 2023 01:09:52 -0700 (PDT)
Message-ID: <e8d69cf3-346d-1e67-9fcc-f12826c0e2e4@gmail.com>
Date:   Tue, 22 Aug 2023 16:09:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [kvm-unit-tests PATCH 03/10] x86: Use "safe" terminology instead
 of "checking"
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20220608235238.3881916-1-seanjc@google.com>
 <20220608235238.3881916-4-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20220608235238.3881916-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/6/2022 7:52 am, Sean Christopherson wrote:
> @@ -138,13 +138,13 @@ static void test_no_xsave(void)
>       printf("Illegal instruction testing:\n");
>   
>       cr4 = read_cr4();
> -    report(write_cr4_checking(cr4 | X86_CR4_OSXSAVE) == GP_VECTOR,
> +    report(write_cr4_safe(cr4 | X86_CR4_OSXSAVE) == GP_VECTOR,
>              "Set OSXSAVE in CR4 - expect #GP");
>   
>       report(xgetbv_checking(XCR_XFEATURE_ENABLED_MASK, &xcr0) == UD_VECTOR,
>              "Execute xgetbv - expect #UD");

Oops, xgetbv_checking() has not been renamed to xgetbv_safe().

>   
> -    report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, 0x3) == UD_VECTOR,
> +    report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, 0x3) == UD_VECTOR,
>              "Execute xsetbv - expect #UD");
>   }
