Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0DE4B2B40
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 18:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345094AbiBKREY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 12:04:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiBKREW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 12:04:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7AE71102
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 09:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644599060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KYptzzuR1nRVaqjLXcd0YpNLgMFhMfqS6KLF2X09zmk=;
        b=RbJU5WGTf4HqTpcR3/CQX1HI6QQPu/qPPS0S93Ga2J8z+hN/G1OeqV0OGjAp/0zVc7Shlr
        XASqxGR0uEWoh70YHcgdfVHLDugwwy+TJRyTWUh5TpGe/eVKJzsNUXFuVsXKRv951btOTX
        mFFwvbTKMqxUd3UTxyxQBIW0T4znSSc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-qYUvORpONpaGXq0UeaoJRQ-1; Fri, 11 Feb 2022 12:04:19 -0500
X-MC-Unique: qYUvORpONpaGXq0UeaoJRQ-1
Received: by mail-ej1-f69.google.com with SMTP id la22-20020a170907781600b006a7884de505so4372851ejc.7
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 09:04:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KYptzzuR1nRVaqjLXcd0YpNLgMFhMfqS6KLF2X09zmk=;
        b=ErUO00J/omMdPwR3Lf/zTh6wtJ61a3hwVny91V4+q85RMCxZ/acmBPH/7jrvgbVLOz
         IShI5P8raRKErGRne/BqSLtUdZcIPeRUzBNFjN3dt+TnjZ+FntsxNBUqrBP4hqrltuDZ
         bz9LjEPRiultOznw9ltrIZesC3rUuMzfNVBC/2Vo5UfJI3F3cUGnyiw0Au6a/JgMZj7Z
         7NqNJCoTNIz7Nr8AvdQc3/fFhE4Hji5cJT7mfCnUFRWyP3g7YDkZmVSfFUKKkoiPzcKh
         1MqTaAZH/R2DVVeqR/G0mAD9A3Wn4CP5jtFlo6cMTme/HKS7XonG2LOpN++EXrlkmpt7
         sFwQ==
X-Gm-Message-State: AOAM533Pqhd03ti5ZC9Wz4xsp3/7uFEPmclwbZ2Ik7cOc/hVHIVLeT5k
        ZqC34A7tiKG5R3ZHFQ5cvPRZcSXRh/jDT75Twx9CwXiNtMti7jUZ6nCp+wit7GHjt3qPCz+2nR6
        eni1iVj/176A6
X-Received: by 2002:a17:907:3ea8:: with SMTP id hs40mr2128567ejc.735.1644599058187;
        Fri, 11 Feb 2022 09:04:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxv3OGJ97g/9VhVJFwY2nWNdHnB645TanqX4RlrDEEAqgX3mlcjN7rfDf5geKP/v54xNTXTbg==
X-Received: by 2002:a17:907:3ea8:: with SMTP id hs40mr2128545ejc.735.1644599057972;
        Fri, 11 Feb 2022 09:04:17 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id o4sm6036116edq.45.2022.02.11.09.04.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 09:04:17 -0800 (PST)
Message-ID: <f9b5c079-ba10-b528-a2fc-efb40cbb5d8f@redhat.com>
Date:   Fri, 11 Feb 2022 18:04:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 0/3] KVM: x86: Fixes for kvm/queue
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
References: <20211216021938.11752-1-jiangshanlai@gmail.com>
 <7fc9348d-5bee-b5b6-4457-6bde1e749422@redhat.com>
 <CANRm+CyHfgOyxyk7KPzYR714dQaakPrVbwSf_cyvBMo+vQcmAw@mail.gmail.com>
 <YgaPZcET90k14fBa@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgaPZcET90k14fBa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/11/22 17:31, Sean Christopherson wrote:
>> Maybe the patch "Revert "KVM: VMX: Save HOST_CR3 in
>> vmx_prepare_switch_to_guest()"" is still missing in the latest
>> kvm/queue, I saw the same warning.
> 
> It hasn't made it way to Linus either.

This was supposed to fix the buggy patch, too:

     commit a9f2705ec84449e3b8d70c804766f8e97e23080d
     Author: Lai Jiangshan <laijs@linux.alibaba.com>
     Date:   Thu Dec 16 10:19:36 2021 +0800

     KVM: VMX: Save HOST_CR3 in vmx_set_host_fs_gs()
     
     The host CR3 in the vcpu thread can only be changed when scheduling,
     so commit 15ad9762d69f ("KVM: VMX: Save HOST_CR3 in vmx_prepare_switch_to_guest()")
     changed vmx.c to only save it in vmx_prepare_switch_to_guest().
     
     However, it also has to be synced in vmx_sync_vmcs_host_state() when switching VMCS.
     vmx_set_host_fs_gs() is called in both places, so rename it to
     vmx_set_vmcs_host_state() and make it update HOST_CR3.
     
     Fixes: 15ad9762d69f ("KVM: VMX: Save HOST_CR3 in vmx_prepare_switch_to_guest()")
     Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
     Message-Id: <20211216021938.11752-2-jiangshanlai@gmail.com>
     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

