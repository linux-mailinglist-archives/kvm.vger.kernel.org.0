Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37FA667ADC
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjALQai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbjALQaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:30:00 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E62BA0
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 08:28:57 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id bk16so18602864wrb.11
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 08:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bTJXODJcH+IHm4MKnkbT3WjBTXF85Sbr1AhMSwdXdO0=;
        b=ma9EnGSAx3Crp5y7T1rcp7CfQ0xWie5n0QgXOBceJDnYREeqvGYmZnlJ/6SGUWZ0cT
         p3Ogh8En1bAu0PB9UUxHdiVjar4GNnM9RlAzrx9rrItQQ+YlwIC/+YrDq2I6rixgvt1a
         gmJ+w4wjL70U2XDqNr5h/C0RjnfyzlLcqDPXaHuHeFSxmHM3I7Jf5Yd6ZokZ8iOpmYEv
         aE716jnknDXCpBhgaXWBKAvt7gvJdiOwKPMLALseIXtJeRwqBVTbr2vxX9i1DPK43Ypb
         yKaZNCBgnXoociHkMrp4vzN/iaVbAZhMIEJh1ljSu7jEbrY/Zmw/xHgJeZeDVsw8RLz7
         ZkFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bTJXODJcH+IHm4MKnkbT3WjBTXF85Sbr1AhMSwdXdO0=;
        b=dOKLpi+NGWxBOfUinpfsBgkdP9X6buCbgRu/NXSnieTcx8+ztQzUQvvA6JE14G1nQn
         gDaYdWK1qQ9r978/lb+VmbLgegGF9fxJoM3kf6L4NQNjbwnCxyAOabRkDOZVuu11N0nv
         0p7E9DfYmukN6+69al1VAsYuW9kEEC1cJBuXksnAcfYYK1cZkOQIIPH3ChWWEeOkd5Dx
         JiPTzU+qDQlFj0dHDSxZ2OVunOL9rPyeEhazU8SeyDcUoJ7+8Zh0lqhflgW31tVRJLhP
         5nwXP9XQFLoHdxcuoGwF+vxk4qDqXg0pGaP6Ue/6gm9sw25MhbXXccecoK/wWIdBnEGv
         AwFA==
X-Gm-Message-State: AFqh2kohfBfcT9rr7lAElG1ppEg7fseSGVhVbG5m5GDTAey1yLkS1Fyi
        ZE39UoTQ+3kA1otrqkmKgBA=
X-Google-Smtp-Source: AMrXdXtVBDAy5ddIKfX7E6Dz53yCaGhB+skKIvNIc4LV/ue8vlRz1lWWvMoY7epmCXMZy0fBQY9WGw==
X-Received: by 2002:a5d:5a18:0:b0:297:9256:c2ac with SMTP id bq24-20020a5d5a18000000b002979256c2acmr27742678wrb.8.1673540935594;
        Thu, 12 Jan 2023 08:28:55 -0800 (PST)
Received: from [10.85.34.175] (54-240-197-225.amazon.com. [54.240.197.225])
        by smtp.gmail.com with ESMTPSA id k9-20020a5d66c9000000b002bdd7ce63b2sm1474952wrw.38.2023.01.12.08.28.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 08:28:55 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <886c13a1-3e37-7103-1caa-a14be2a50406@xen.org>
Date:   Thu, 12 Jan 2023 16:28:54 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 2/4] KVM: x86/xen: Fix potential deadlock in
 kvm_xen_update_runstate_guest()
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
References: <20230111180651.14394-1-dwmw2@infradead.org>
 <20230111180651.14394-2-dwmw2@infradead.org>
 <64cf2539-6f78-1ec4-15ad-8fc5ca8353c1@xen.org>
 <e0d7e7c164d06e17e50485ffba4331878005d726.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <e0d7e7c164d06e17e50485ffba4331878005d726.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/01/2023 16:27, David Woodhouse wrote:
> On Thu, 2023-01-12 at 16:17 +0000, Paul Durrant wrote:
>>>     
>>> @@ -309,7 +317,14 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
>>>                   * gpc1 lock to make lockdep shut up about it.
>>>                   */
>>>                  lock_set_subclass(&gpc1->lock.dep_map, 1, _THIS_IP_);
>>> -               read_lock(&gpc2->lock);
>>> +               if (atomic) {
>>> +                       if (!read_trylock(&gpc2->lock)) {
>>
>> You could avoid the nesting in this case with:
>>
>> if (atomic && !read_trylock(&gpc2->lock))
>>
>>> +                               read_unlock_irqrestore(&gpc1->lock, flags);
>>> +                               return;
>>> +                       }
>>> +               } else {
>>> +                       read_lock(&gpc2->lock);
>>> +               }
> 
> Hm? Wouldn't it take the lock twice then? It'd still take the 'else' branch.

Actually, yes... So much for hoping to make it look prettier.

   Paul

