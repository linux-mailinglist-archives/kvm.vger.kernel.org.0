Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8255C527696
	for <lists+kvm@lfdr.de>; Sun, 15 May 2022 11:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbiEOJZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 May 2022 05:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236096AbiEOJZ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 May 2022 05:25:27 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5B917ABE;
        Sun, 15 May 2022 02:25:26 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id i24so11471136pfa.7;
        Sun, 15 May 2022 02:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pZRHTBR5dW8zhXvTd2YkxEziReBHgNlpU15cq9pMkk8=;
        b=FQ0dXDu3kUXPdQIr+jFJkLS/ZbZ9PlZTQ4wWSYIr5yWwZ/09YzhfV8eGn03lXhFRHr
         tcnmaCstg8v2gAAQAz1Bu0igGXJLayl9RmbEo+pXoQQCus7vO1rKXLQeUhLs0a1eAZQp
         hcKHVTj8Bclsxj9QRh4cPyFLadum0Zhm+juTNHrBSsOs5o3iWdsRl+mNogvIS7IHqva0
         EzMvDZQ45BrzCUIVFCXPTe5vXwGxsKz6pW2npd5O9CrTd4nzva5yw7H6M0rvJwgFH8a1
         RvkkK+Azf2H7SjKYC0en7f1Sz7XSF1tBTnh3bZr9Vak4cr3unWsbSP3LsWVbME/32DAd
         sUAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pZRHTBR5dW8zhXvTd2YkxEziReBHgNlpU15cq9pMkk8=;
        b=MnrD/ttXPz2ow7z13UW7Bh52M0188rG7CFuSnwEUuU/rdNcphHHZzry/1/AQKpMPIM
         +v1Ygt28TyCxO+d0SmUGVcLQnmgkwmejjYzNKa+WbW94HUvwhEZszOCC1JOuIqZvlrDI
         UvPikZsJhgL1yigZhXSgFQC4sUo3E7TqvfMk7ds9IYRX7KC225AefR54cDzhtAG7Qdh5
         /HrbBPgbmM5H8GUX+u0YYNj4IkMwj78W4C/bZ5aSVur/JLXPMa0dbRvr6EizaG3y+xP2
         l62Asycve+7xJCR8BcBjqfH/YWaiHFJsFpDcnv5TBV3ytuhvriH/I+Ylc7r8AB7W0HtZ
         5g6Q==
X-Gm-Message-State: AOAM533bINoCrzC7xon95FQzcSoxRFATWUVCQvVB6DvH3CTSbDyBnWGf
        NPGVx6TYraRky2cpu0nmZh4=
X-Google-Smtp-Source: ABdhPJwyVaqhzNfKTvfJOWAQRy7DrGywtaMNEL6nqrpqhjUEjhj5tUWrFWWMPS8s9f71ukqR6dpcYg==
X-Received: by 2002:a63:dc42:0:b0:3c5:e187:572 with SMTP id f2-20020a63dc42000000b003c5e1870572mr11050855pgj.82.1652606725864;
        Sun, 15 May 2022 02:25:25 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id o12-20020a170902e00c00b0016174b312f5sm485835plo.104.2022.05.15.02.25.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 May 2022 02:25:25 -0700 (PDT)
Message-ID: <d741a183-6180-1a49-fffb-b62d36286a04@gmail.com>
Date:   Sun, 15 May 2022 17:25:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [KVM] db16e9b28b: kvm-unit-tests.pmu.fail
Content-Language: en-US
To:     kernel test robot <oliver.sang@intel.com>
Cc:     0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@lists.01.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
References: <20220515092217.GD10578@xsang-OptiPlex-9020>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20220515092217.GD10578@xsang-OptiPlex-9020>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/5/2022 5:22 pm, kernel test robot wrote:
> patch link:https://lore.kernel.org/kvm/20220509102204.62389-2-likexu@tencent.com

Fixed by the V2 version. Please help try.
