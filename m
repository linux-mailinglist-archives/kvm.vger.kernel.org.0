Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9292C4BC6D6
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 08:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241701AbiBSH4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 02:56:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiBSH4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 02:56:01 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7BD1BB702;
        Fri, 18 Feb 2022 23:55:42 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id d10so20123841eje.10;
        Fri, 18 Feb 2022 23:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RrXiZDD7PTY+squB+2WTkj/JwujSEeOy/s6pDsbaDwA=;
        b=Ifefml411w6zWQeeeIHONvXpeYAlv7xgij/oqQRGyK2GZodau0R45cXCNx+JnO0IDA
         LE2NTO26p/aYyqCnXJXu5cc4Q/MAhwDcn/4y5349xiRaZBbqRe3fRLNyxHx9iIAd9J3B
         ryurI/v+z3Fj5f5eMBW09Ld5rq4e64ODtSbPdZ1TJTaOR0kZF9z5s2jkzU2Yp9dhf3UF
         W32MP7xw41aYVVwyhYvODl62T5u0YlYSxlFtcI50OcGvQsXPcJASCGdf4+33ZEKjFk0i
         WRZrOSwrgIUETv/XND7z4RxBnV168xmEo40hG8N8rh29BgZXJGbxm8qEApw43zaw2pb7
         qL7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RrXiZDD7PTY+squB+2WTkj/JwujSEeOy/s6pDsbaDwA=;
        b=RMW9s/WpR+y8O39VXbxAI7tNIB5NW8uZD3cF4PVAbATYdsJ/Vf28I9imRMvVzrV7cP
         pJwCpanFu+veqWQcta6Jbjzgj1b2DxOXBUlzuGhRkXMZP58EPnQEsyc3fUhTHxII8eo8
         pHC1hIzguxvFFI7LI0+OG48UHrxfvVeZVDNCIGsKRztQ9AgkwYfIEQMSTrJXVMQ1+f+t
         3wRcYHtUh5I9Mnaf0f8oP7vVDPGbr61AI9yr5GfGRI4hYex5L/AhtgxMFTlfq33TGdI0
         2WNfjSypuQ5Dd/DTNWHDhS2Xs0GdOzGrWVc2ArusrsytS23kM0rWZRnd0Aw9CJAMIyCE
         AITw==
X-Gm-Message-State: AOAM533vPyllPWy4MZcmxHxkml2hOU4M7XpmklLNUb7kQWfYlzH5flKT
        mx1ByyUHDN5tLt85DosibGJhIBlKPDo=
X-Google-Smtp-Source: ABdhPJz74L7JEIbykFtDFLKtJwalgprHvTapwcIrgZBtySy9Q4V1tK0oUfnoDT6z/8fJ+kUtmqnrLg==
X-Received: by 2002:a17:906:b356:b0:6cf:3810:dcf1 with SMTP id cd22-20020a170906b35600b006cf3810dcf1mr9261139ejb.761.1645257341349;
        Fri, 18 Feb 2022 23:55:41 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id b19sm2170829edd.91.2022.02.18.23.55.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 23:55:40 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <70cc45dc-c1e3-9ad4-92c2-f6305b8e8574@redhat.com>
Date:   Sat, 19 Feb 2022 08:55:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3] KVM: Move VM's worker kthreads back to the original
 cgroup before exiting.
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kernel test robot <lkp@intel.com>,
        Vipin Sharma <vipinsh@google.com>, kbuild-all@lists.01.org,
        mkoutny@suse.com, tj@kernel.org, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, dmatlack@google.com, jiangshanlai@gmail.com,
        kvm@vger.kernel.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220217061616.3303271-1-vipinsh@google.com>
 <202202172046.GuW8pHQc-lkp@intel.com>
 <3113f00a-e910-2dfb-479f-268566445630@redhat.com>
 <YhA6QIDME2wFbgIU@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YhA6QIDME2wFbgIU@google.com>
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

On 2/19/22 01:30, Sean Christopherson wrote:
> 
> So I think this can be:
> 
> 	rcu_read_lock();
> 	parent = rcu_dereference(current->real_parent);
> 	get_task_struct(parent);
> 	rcu_read_unlock();
> 
> 	(void)cgroup_attach_task_all(parent, current);
>          put_task_struct(parent);

Yes, I agree.

Paolo
