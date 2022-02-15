Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA994B76F6
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 21:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240476AbiBOSHm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 13:07:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238532AbiBOSHj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 13:07:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3474D7637
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 10:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644948448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=datg8lNLKiIl1WXCHn9HnuSPwv/jJjkjBNmJYipaVUg=;
        b=bTeUFLFrZ4TLXWSq27ESBS0cobnioI93yszWublNWa8opMys51d1Z7homeW8NGPiXIKgp1
        /nhGSY7ZFclsVypUkvtmrNevrA/pSvB5byjNwqEb/PhZtakmVA38hQsUTmss9a1tC7IfvB
        gwEr9tzmv6D0Xf7VCQaWYCoqFtpqdII=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-31qhJXgnMumjbGRtakjm9Q-1; Tue, 15 Feb 2022 13:07:26 -0500
X-MC-Unique: 31qhJXgnMumjbGRtakjm9Q-1
Received: by mail-ej1-f70.google.com with SMTP id m12-20020a1709062acc00b006cfc98179e2so788081eje.6
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 10:07:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=datg8lNLKiIl1WXCHn9HnuSPwv/jJjkjBNmJYipaVUg=;
        b=hr3xWe/YKwp+IsD4DWs31nrLWrkkbDVIzaGOyM03gwurZKr9f2r1YPj+aifRnNBGs+
         YRyNRL0Fu8i9To9Dvw52IhNS0oDOdk8N+cqSQx122wqRrbXsFdtPqaWPvyO20YxQTZ3s
         LINzYJrMYV5xCvxRbc2uIF0rPURpzzMu6m6X4uyRsX9wkH4Es+L3KKDUV9q6G6iZaRjG
         Yugp9OjU48oqYC0wtlmKa3J1YPyWaXacsxlPQkkHHIU21avLrzpcDWenLFtMHqy9Qql0
         jtJHCj4ZkUjJJROEDyMOGejxOdTjvAVX21c7OWzIttLz1hFtlLMkGPmKSAWYOPCrBjDw
         HPbw==
X-Gm-Message-State: AOAM5328PR5yrZPFs/1kenA4XO+fG11SkVIfc7nsNkN+vmM1KLiG+p/R
        i9IpeIWI04RVmPWa42HLTK5STmNEmQ2yeEgfLBY68yOoJHe8MOqm7rNYeJFYQXwLrSKNPxhTtbM
        ZC7reEAbU40QW
X-Received: by 2002:a17:906:6498:: with SMTP id e24mr269426ejm.12.1644948445025;
        Tue, 15 Feb 2022 10:07:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxuHQdH6fWFMzgIH7BEvZiDbuwOK8q1e43c06q1Yb4ASG5HGXjrHD1XO2oGrj8kzqM+AOBPRQ==
X-Received: by 2002:a17:906:6498:: with SMTP id e24mr269410ejm.12.1644948444793;
        Tue, 15 Feb 2022 10:07:24 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id ed9sm222149edb.59.2022.02.15.10.07.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 10:07:23 -0800 (PST)
Message-ID: <b34d235f-e22a-71dc-0c20-7be46d2182ff@redhat.com>
Date:   Tue, 15 Feb 2022 19:07:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 5/5] KVM: x86: allow defining return-0 static calls
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220214131614.3050333-1-pbonzini@redhat.com>
 <20220214131614.3050333-6-pbonzini@redhat.com> <Ygvi5jr4V8S/bKSe@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ygvi5jr4V8S/bKSe@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/15/22 18:29, Sean Christopherson wrote:
> s/KVM_X86_OP_RET0/KVM_X86_OP_OPTIONAL_RET0
> 
> And maybe "NULL func" instead of "NULL value", since some members of kvm_x86_ops
> hold a value, not a func.
> 
>> struct kvm_x86_ops will be changed to __static_call_return0.
> This implies kvm_x86_ops itself is changed, which is incorrect.  "will be patched
> to __static_call_return0() when updating static calls" or so.
> 

Very good point, thanks.

Paolo

