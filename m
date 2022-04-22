Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429AD50B4BE
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 12:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446435AbiDVKOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 06:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377723AbiDVKOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 06:14:42 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BC6506E7;
        Fri, 22 Apr 2022 03:11:49 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id k23so15458529ejd.3;
        Fri, 22 Apr 2022 03:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Xesg0AXR4SVizI2s21m60p1BFH5JwHKKCprTxCBAOZ0=;
        b=Ri00KQO0hd6LSntka2TZ6PirwuyYrkyAMVgRFbuJV8d57Zv6pFabFzdPDqERK8yv9v
         MvoKwnj1uyAIrhz6zUGu5TL5I5eiU+ts7ed6boJEUDszFoyYeFEGDxRv1Qi81hzU/dd8
         BaHcN9soDcTXrh3RiMqEYggPfvrBXx5bUJDww76BoCVQDo/eM63IK9PyPozd/48w0wAo
         8p79QC3/+/qlhC9Zb7qwcV2175hkSJK4R9N7DJltZS+IJXT6Yh87A+jtMYIs2gRVF7S4
         xFZYhFa5RSpT72IdZZLi4gCNjwL7xyTztPZew0q/Q25hIWJBJhbepaYHiou7RDDTeVLm
         SHrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Xesg0AXR4SVizI2s21m60p1BFH5JwHKKCprTxCBAOZ0=;
        b=FFU0DLORU6RHDtNpcx9+tkLKF7RBF/t68YQiTCmddhvuT4wobx2UksuFs9w1BZw/v/
         S5MdsaGG0oFaUjJ7muhAHCHaToAA7Ie+CGBVCxysiqnHnZJCabZkItQZsSmmvw5yLtma
         FVSqJ/xNcdY8yNgudW6gcd9D00x4SGJcR4RRVNtaZLp+I8E52RO+kaXeUwN9JURTLlgh
         eEFDCTfG9Z7VHZFamDV7n6d6V03TZqxZIFouqhEog8/E0DinWuExABrUmiB1wiiAmFv1
         BW1wkIDFx1HwLa8PV2iLnbBQykZANU7qQ+A10GcmGwWyWoOkQevS3MpHCB42ugzH7VW8
         1MTA==
X-Gm-Message-State: AOAM533ca3BvFfcfXefIWd1aNKsOP3ISid56Ae47gHYPcPMQmHQguk9W
        y/o77RDr5GrvLdJ0zNSD/5U=
X-Google-Smtp-Source: ABdhPJzY+ORSQNuSHjVhlOYjZ3FQLp74rSUzg7lTJukBuAyD/T3nkDrbZ+GWtHO9t6eHguq2+1LYXA==
X-Received: by 2002:a17:906:6a11:b0:6e8:d248:f8ea with SMTP id qw17-20020a1709066a1100b006e8d248f8eamr3358974ejc.500.1650622308164;
        Fri, 22 Apr 2022 03:11:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id s12-20020a1709062ecc00b006e8558c9a5csm600431eji.94.2022.04.22.03.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 03:11:47 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <1c13abb3-cd9e-c9ca-3bd8-406bcc6965b4@redhat.com>
Date:   Fri, 22 Apr 2022 12:11:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/4] KVM: x86: always initialize system_event.ndata
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, will@kernel.org,
        apatel@ventanamicro.com, atishp@rivosinc.com, seanjc@google.com,
        pgonda@google.com
References: <20220421180443.1465634-1-pbonzini@redhat.com>
 <20220421180443.1465634-2-pbonzini@redhat.com> <87bkwta1p4.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87bkwta1p4.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/22/22 11:48, Marc Zyngier wrote:
> On Thu, 21 Apr 2022 19:04:40 +0100,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> The KVM_SYSTEM_EVENT_NDATA_VALID mechanism that was introduced
>> contextually with KVM_SYSTEM_EVENT_SEV_TERM is not a good match
>> for ARM and RISC-V, which want to communicate information even
>> for existing KVM_SYSTEM_EVENT_* constants.  Userspace is not ready
>> to filter out bit 31 of type, and fails to process the
>> KVM_EXIT_SYSTEM_EVENT exit.
>>
>> Therefore, tie the availability of ndata to a system capability
>> (which will be added once all architectures are on board).
>> Userspace written for released versions of Linux has no reason to
>> check flags, since it was never written, so it is okay to replace
>> it with ndata and data[0] (on 32-bit kernels) or with data[0]
>> (on 64-bit kernels).
> 
> How is it going to work for new userspace on old kernels, for which
> the ndata field is left uninitialised?

New userspace needs to check the capability before accessing ndata.

If it is desirable for Android, crosvm can "quirk" that ARM always has 
valid data[0] even in the absence of the capability.

> Cat we please get a #define that aliases data[0] to flags? At the next
> merge of the KVM headers into their respective trees, all the existing
> VMM are going to break if they have a reference to this field (CrosVM
> definitely does today -- yes, we're ahead of time).

That would be a union rather than a define but yes, I can do it.

Paolo
