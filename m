Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385AB4AF7E3
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbiBIRLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238102AbiBIRLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:11:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D143C05CB89
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644426699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iQs4y9ejLWNczy8HXhh1vDnY6jrshkGK7+qkXn9tZ4Y=;
        b=DOpfaCkpptFJs2X/qmo2QgTyTFG6qWlCmQffBWbBN6I+GD0MAza3T5IPZR3NZ8eLmG0+Xz
        o70mr45SMdGiDj3XG5OdUgGA2TShy49oThQbu+WAuo6PuolJ4estIb5+e5gk/5pWNcHbC6
        trb24S0K/Lc4j+opLj1R68qMfUTHDOk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-5agGKsW1PmqseydhLKsA7w-1; Wed, 09 Feb 2022 12:11:38 -0500
X-MC-Unique: 5agGKsW1PmqseydhLKsA7w-1
Received: by mail-ed1-f71.google.com with SMTP id 30-20020a508e5e000000b0040f6642e814so1696051edx.19
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 09:11:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iQs4y9ejLWNczy8HXhh1vDnY6jrshkGK7+qkXn9tZ4Y=;
        b=ElUWxStWPl8BPHtKvulOwVV5bFSwSHEDTGy+4/St25RuX3O3qMVbDUnGf3yJdxASne
         3xdbL1qg5i9eTs8TMpCUjlbIrKfQu2eACEoSGoszjZ3smdDKXvnOroAxuyBEO32blMwX
         yHlAMkuohL/TEcnyvY35fpFC7ah23N18lLptGld/UhiVWZaXpUdzjFQ70tFiVVp+bKf7
         VgrI90msiGAZRsrHf7k0IM1Y9wukewKfjD4s3bGWRpa58bLz2MmGikdgFjQ1Jcyzre+s
         syTAsXE7QwCNvyOsTm3etszz4z1oYBEroJgsoJCtj+41rzMZXHGfK2eTvRoQIDAM4oys
         NUHw==
X-Gm-Message-State: AOAM531PDHSnf6t+XC05F/FE0+C2pT0ifSzhkQkKz6BZHuDlEnbczpKe
        NZwdG1AiLMxZAwleBkoy76AxpDnPK89d7yyP/4cJtQSmOl6IwPA+BuDo1YmvCcP5fX3nDVPPSFb
        XTii/Z+iBJEV3
X-Received: by 2002:a17:906:478c:: with SMTP id cw12mr2813194ejc.214.1644426696911;
        Wed, 09 Feb 2022 09:11:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxUXH92lhPWvXHhNKgOwcYNhiqoW2ncfoaMyf0NglUCkzpRmK0wIC/g3kQtRc6brn9RvFIPRg==
X-Received: by 2002:a17:906:478c:: with SMTP id cw12mr2813175ejc.214.1644426696700;
        Wed, 09 Feb 2022 09:11:36 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id bo9sm3946812edb.29.2022.02.09.09.11.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 09:11:36 -0800 (PST)
Message-ID: <fc3a4cdc-5a88-55a9-cfcc-fb7936484cc8@redhat.com>
Date:   Wed, 9 Feb 2022 18:11:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 00/12] KVM: MMU: do not unload MMU roots on all role
 changes
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <YgP04kJeEH0I+hIw@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgP04kJeEH0I+hIw@google.com>
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

On 2/9/22 18:07, Sean Christopherson wrote:
> On Wed, Feb 09, 2022, Paolo Bonzini wrote:
>> The TDP MMU has a performance regression compared to the legacy MMU
>> when CR0 changes often.  This was reported for the grsecurity kernel,
>> which uses CR0.WP to implement kernel W^X.  In that case, each change to
>> CR0.WP unloads the MMU and causes a lot of unnecessary work.  When running
>> nested, this can even cause the L1 to hardly make progress, as the L0
>> hypervisor it is overwhelmed by the amount of MMU work that is needed.
> 
> FWIW, my flushing/zapping series fixes this by doing the teardown in an async
> worker.  There's even a selftest for this exact case :-)
> 
> https://lore.kernel.org/all/20211223222318.1039223-1-seanjc@google.com

I'll check it out (it's next on my list as soon as I finally push 
kvm/{master,next}, which in turn was blocked by this work).

But not zapping the roots is even better---especially when KVM is nested 
and the TDP MMU's page table rebuild is very heavy on L0.  I'm not sure 
if there are any (cumulative) stats that capture the optimization, but 
if not I'll add them.

Paolo

