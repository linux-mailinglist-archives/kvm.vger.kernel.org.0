Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6715F510501
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 19:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354138AbiDZRQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 13:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352707AbiDZROx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 13:14:53 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0203532EFC
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 10:11:29 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id t6so22953505wra.4
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 10:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pamMaaVZYdygrWXDRxaeRqbvXXd7KzsUab9eejNupEM=;
        b=OMe/wMtEHmzc+4un6Figod63BYFZ5h1tujb66Jnawj3zsgyNLOfve5RqPrJl5/0X1F
         +iPjHur9QY6tKsw8nMP/XkE2scN9eIq21Ma56UXjizbhU9YyKUyCOx3ecBPBh4uT9WUb
         KaPr6GMbTqQdpZ080OHQSC4nBSNMGdrrGxCW9Vg8VQPF4rW80XlC5EQoMd2QectU77uB
         HhAqHp4gBRO49gHVqTnULoMkCscMrr4/uy+m/O3YZqb4xcmg9DAZVyZs8Ncb0FybKqAB
         IV7G2jKtYfGUY1YwUiOEgpNCUIlt8LsqHSCV3XZxD4lDFHhRk2WhZQ+2mUWx1BHeYgJZ
         dBeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pamMaaVZYdygrWXDRxaeRqbvXXd7KzsUab9eejNupEM=;
        b=HxDrItQILw6iTpB5ac74u/JfIwmntFH1YFBzJm3k/X+UvqRhVBXhNT+zG3wZqgk/cV
         slf6g1j5+970JPmsd11/76xTFQHiRa9TGhIs2u3WeqWVTOD/5wddOJugwhLXScY6O7P6
         xW+S9cprOMOhuz+vCEIj+QfGwE41aGTXaeY1Yu+h/eDP85dcBXfD27p0W9G3yAAwJjjr
         9JluCUn77xDF0VYH1LvldNVcsSTaOEjIGeHiFFyzmbtlzY/tris846g6bnJAFSUgo6rb
         xDfwKqkgar5jneKzHvdZfgIR2uBrVMaERR31d/czpUR6ZQtY8hr5ZR9UlI5zPQzy/kyB
         pVNg==
X-Gm-Message-State: AOAM530LxojsnfGy1ZKEcK4XwLWDZ95dArVg64vg9qRzAFckqihtZWnT
        gumTtgpeHzaIdbxIWw5GXu0=
X-Google-Smtp-Source: ABdhPJxYCA9Qx+BhHfzATKCmDicrXdteAdALSWfqV3gsh8RgXoBS2FPfaCWAK8GY4OEBreBmrYRV3g==
X-Received: by 2002:a05:6000:1e05:b0:20a:ecc7:41cf with SMTP id bj5-20020a0560001e0500b0020aecc741cfmr255937wrb.102.1650993087399;
        Tue, 26 Apr 2022 10:11:27 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id c3-20020a05600c148300b0038ebc8ad740sm75025wmh.1.2022.04.26.10.11.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 10:11:26 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <cc0c62dd-9c95-f3b9-b736-226b8c864cd4@redhat.com>
Date:   Tue, 26 Apr 2022 19:11:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: kvm_gfn_to_pfn_cache_refresh started getting a warning recently
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
References: <e415e20f899407fb24dfb8ecbc1940c5cb14a302.camel@redhat.com>
 <YmghjwgcSZzuH7Rb@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YmghjwgcSZzuH7Rb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/26/22 18:45, Sean Christopherson wrote:
> On Tue, Apr 26, 2022, Maxim Levitsky wrote:
>> [  390.511995] BUG: sleeping function called from invalid context at include/linux/highmem-internal.h:161
>> [  390.513681] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 4439, name: CPU 0/KVM
> 
> This is my fault.  memremap() can sleep as well.  I'll work on a fix.

Indeed, "KVM: Fix race between mmu_notifier invalidation and pfncache 
refresh" hadn't gone through a full test cycle yet.

Paolo
