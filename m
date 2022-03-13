Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5354C4D75A8
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 15:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbiCMOBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 10:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234304AbiCMOBc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 10:01:32 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C7582D13;
        Sun, 13 Mar 2022 07:00:23 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id u1so19989061wrg.11;
        Sun, 13 Mar 2022 07:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/xfMkdH76Z4z8MumqZk6OYP0XH4abR1Ugh2C9K0izxI=;
        b=YfbCU0cHm+YbEdoF0Ockk8y2YAlzNc0LkNN7uNWr4A11ntuNbGh8bCZqzp5aYctM/T
         u20Ru3iyKM63G7YpAAZbUIbbcmq1u7WZApw73YXndvYF6JfmlX4GIJi0RtSJjCn4Rue6
         qgIaYs9jGsrR2BqWqNLydOHQTxkWHkZq0LObj5zdwyb/o1oPZP4QhxBaGYFhNR5T1aBo
         BbshZFLxoKTEevqmWXZNlvz6RNwDS8Hg/DxXKaqgRUEsNdhrtcypWVKGmyGHvH3TM5E3
         uVLGk//bWp/GLtr2uEUzvF7zlagu9McyAS8TimQti2CbEJ6o9nD7cdY4/FOrizorpcQz
         Hjvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/xfMkdH76Z4z8MumqZk6OYP0XH4abR1Ugh2C9K0izxI=;
        b=Dgr57NvyG+uxjJJBipfOx1tfVdyYNFaPUXXK3AHu7TOQwfpS6Ii1A9QK5RQNBkMqX8
         QuIQG9/mRok3h9TzcIc8kMHnXH8W8gPrOWWKTses/omneSWuSDeAP9scby1XXQMoNSD0
         xNdng0cKtF45paADioRkuJB04IxlnQHrT+8wEBurjjaFoxkvx1n4JRUM7yLziRbOgQlT
         gqLoqaqsG6vFtzXyqWkkQ+O0PrG4dcH/LfSFj1iiWV/RWcHxht9WsPIbdwi359gH9lSV
         POwWIDjbE4vDaAtXUhQZX5+C8/y4igM2Eoc57xp6TKCe8miWKwp9Xh3iKYGMXSbdWWNU
         MzLQ==
X-Gm-Message-State: AOAM531WkRb92wX04ciAqDFGyXBmTIhOpYSQXO98mGjLbxbfHgF8h46M
        a36RNNjKyZNXoaiu1TjznT4=
X-Google-Smtp-Source: ABdhPJzSCXoP4SYOVrF0n8vWBfLvbQtyPdOiUIdlmv2fs12Ug1ketXzjCSJ7LgdUd2V2z1MmqPHKsw==
X-Received: by 2002:adf:8b5a:0:b0:1f0:224b:5645 with SMTP id v26-20020adf8b5a000000b001f0224b5645mr13561161wra.544.1647180021944;
        Sun, 13 Mar 2022 07:00:21 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id bl20-20020adfe254000000b001f1fa450a3asm18485479wrb.72.2022.03.13.07.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 07:00:21 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <19b85f45-4e8b-52fe-daf2-371e86310e6b@redhat.com>
Date:   Sun, 13 Mar 2022 15:00:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v5 000/104] KVM TDX basic feature support
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>, isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <YiW327HAJVizRJHZ@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YiW327HAJVizRJHZ@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/7/22 08:44, Christoph Hellwig wrote:
> A series of 104 patches is completely unreviewably, please split it into
> reasonable chunks.

It is split into 5-15 patch chunks, and I'm going to review it mostly 
according to the separation.  It's just posted together because it 
doesn't really accomplish anything until all the chunks are merged together.

 From the cover letter:

>> TDX, VMX coexistence:
>>         Infrastructure to allow TDX to coexist with VMX and trigger the
>>         initialization of the TDX module.
>>         This layer starts with
>>         "KVM: VMX: Move out vmx_x86_ops to 'main.c' to wrap VMX and TDX"
>> TDX architectural definitions:
>>         Add TDX architectural definitions and helper functions
>>         This layer starts with
>>         "[MARKER] The start of TDX KVM patch series: TDX architectural definitions".
>> TD VM creation/destruction:
>>         Guest TD creation/destroy allocation and releasing of TDX specific vm
>>         and vcpu structure.  Create an initial guest memory image with TDX
>>         measurement.
>>         This layer starts with
>>         "[MARKER] The start of TDX KVM patch series: TD VM creation/destruction".
>> TD vcpu creation/destruction:
>>         guest TD creation/destroy Allocation and releasing of TDX specific vm
>>         and vcpu structure.  Create an initial guest memory image with TDX
>>         measurement.
>>         This layer starts with
>>         "[MARKER] The start of TDX KVM patch series: TD vcpu creation/destruction"
>> TDX EPT violation:
>>         Create an initial guest memory image with TDX measurement.  Handle
>>         secure EPT violations to populate guest pages with TDX SEAMCALLs.
>>         This layer starts with
>>         "[MARKER] The start of TDX KVM patch series: TDX EPT violation"
>> TD vcpu enter/exit:
>>         Allow TDX vcpu to enter into TD and exit from TD.  Save CPU state before
>>         entering into TD.  Restore CPU state after exiting from TD.
>>         This layer starts with
>>         "[MARKER] The start of TDX KVM patch series: TD vcpu enter/exit"
>> TD vcpu interrupts/exit/hypercall:
>>         Handle various exits/hypercalls and allow interrupts to be injected so
>>         that TD vcpu can continue running.
>>         This layer starts with
>>         "[MARKER] The start of TDX KVM patch series: TD vcpu exits/interrupts/hypercalls"
>> 
>> KVM MMU GPA stolen bits:
>>         Introduce framework to handle stolen repurposed bit of GPA TDX
>>         repurposed a bit of GPA to indicate shared or private. If it's shared,
>>         it's the same as the conventional VMX EPT case.  VMM can access shared
>>         guest pages.  If it's private, it's handled by Secure-EPT and the guest
>>         page is encrypted.
>>         This layer starts with
>>         "[MARKER] The start of TDX KVM patch series: KVM MMU GPA stolen bits"
>> KVM TDP refactoring for TDX:
>>         TDX Secure EPT requires different constants. e.g. initial value EPT
>>         entry value etc. Various refactoring for those differences.
>>         This layer starts with
>>         "[MARKER] The start of TDX KVM patch series: KVM TDP refactoring for TDX"
>> KVM TDP MMU hooks:
>>         Introduce framework to TDP MMU to add hooks in addition to direct EPT
>>         access TDX added Secure EPT which is an enhancement to VMX EPT.  Unlike
>>         conventional VMX EPT, CPU can't directly read/write Secure EPT. Instead,
>>         use TDX SEAMCALLs to operate on Secure EPT.
>>         This layer starts with
>>         "[MARKER] The start of TDX KVM patch series: KVM TDP MMU hooks"
>> KVM TDP MMU MapGPA:
>>         Introduce framework to handle switching guest pages from private/shared
>>         to shared/private.  For a given GPA, a guest page can be assigned to a
>>         private GPA or a shared GPA exclusively.  With TDX MapGPA hypercall,
>>         guest TD converts GPA assignments from private (or shared) to shared (or
>>         private).
>>         This layer starts with
>>         "[MARKER] The start of TDX KVM patch series: KVM TDP MMU MapGPA "

Paolo
