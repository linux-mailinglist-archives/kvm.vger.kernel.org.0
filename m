Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56BA55B314B
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 10:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiIIICY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 04:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiIIICW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 04:02:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3DA103047
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 01:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662710540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L4aiCv3DQffhho4nhLvtJMFC0s173+oyNkH3+TzK2R0=;
        b=TmYiMivkm6IGUzem1pfChbdtTOGLM2gC0N5ys2EvUAyiKgsAMh8mnioL2LgEv5bmQdg566
        E2fk3idEk6Il+zxVq45MRNGQtvWcqKTCVB/Coo+etxdFZ6PvuybbtNOkTGrhBcHExAQF10
        mGUpLasVhVRSVMonrxBIMFqCqJ1F4PQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-232-ga1R_IZgOk-Jx0nFA0wDvA-1; Fri, 09 Sep 2022 04:02:19 -0400
X-MC-Unique: ga1R_IZgOk-Jx0nFA0wDvA-1
Received: by mail-qt1-f198.google.com with SMTP id cf25-20020a05622a401900b0035a6ef450e9so906984qtb.9
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 01:02:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=L4aiCv3DQffhho4nhLvtJMFC0s173+oyNkH3+TzK2R0=;
        b=hkTdA0qs+Sa41NSMDpgGXDUdJlCgepKIxwhBerOHhjTb4uXEDNDaXjJbuRb0eJEHUA
         n+wUHNJ9XQ2V0wB2IBIJsXLnHzFBhWW2anCSLUp4Wk/pBQ0bWKdr/tc/EQguRIUF6jlA
         AI0qufSX9kbpJQNNmpB1zbdchzY8vAGvC9LSpa6d3HDuSUqCBk6cvwp11Z7vDXrh0eIy
         SsN/QI/NhdqI6G7/YiYclGz9ei0dGGbIeQK35Gtwro4ykFE4IaO6lD0HSbdBKg+zZphB
         xa2CUPY/SUp/u1sFopz1KKILd+A9/hNik0s6bzYechBKQVTua1/6Dp9ydBs56x7ghWd3
         ydvw==
X-Gm-Message-State: ACgBeo2u7oBVUlOaP0EWm8gtGZ6rSvQi0OFP3FIUbGg6NppD7Amev8wW
        rcn6GzDNRtp5H7jbLLpNI0gU9wIp8uEItk4AA25MJTZucPCFAzf6Z6a6p2xWZZY3bK+9E0ECYWd
        8fKLcSelY4Dla
X-Received: by 2002:ac8:5e4f:0:b0:345:391:cee6 with SMTP id i15-20020ac85e4f000000b003450391cee6mr11144035qtx.255.1662710538665;
        Fri, 09 Sep 2022 01:02:18 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6PUhWbboaAJvfMcvsjnLKVPMEpnYD1kR0kHKKQKLGf3kZn/jivKqv+dqTnrFEu/OG/msZC1w==
X-Received: by 2002:ac8:5e4f:0:b0:345:391:cee6 with SMTP id i15-20020ac85e4f000000b003450391cee6mr11144022qtx.255.1662710538485;
        Fri, 09 Sep 2022 01:02:18 -0700 (PDT)
Received: from ?IPV6:2a04:ee41:4:31cb:e591:1e1e:abde:a8f1? ([2a04:ee41:4:31cb:e591:1e1e:abde:a8f1])
        by smtp.gmail.com with ESMTPSA id fw12-20020a05622a4a8c00b00344b807bb95sm1032388qtb.74.2022.09.09.01.02.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 01:02:17 -0700 (PDT)
Message-ID: <66ed2e5b-b6a8-d9f7-3fe4-43c974dc0ecd@redhat.com>
Date:   Fri, 9 Sep 2022 10:02:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 2/2] kvm/kvm-all.c: listener should delay kvm_vm_ioctl
 to the commit phase
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Cc:     Leonardo Bras Soares Passos <lsoaresp@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-3-eesposit@redhat.com> <Yv6baJoNikyuZ38R@xz-m1.local>
 <CAJ6HWG6maoPjbP8T5qo=iXCbNeHu4dq3wHLKtRLahYKuJmMY-g@mail.gmail.com>
 <YwOOcC72KKABKgU+@xz-m1.local>
 <d4601180-4c95-a952-2b40-d40fa8e55005@redhat.com>
 <YwqFfyZ1fMA9knnK@xz-m1.local>
 <d02d6a6e-637e-48f9-9acc-811344712cd3@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <d02d6a6e-637e-48f9-9acc-811344712cd3@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


>> One thing I forgot to ask: iirc we used to have a workaround to kick all
>> vcpus out, update memory slots, then continue all vcpus.  Would that work
>> for us too for the problem you're working on?
> 
> As reference, here is one such approach for region resizes only:
> 
> https://lore.kernel.org/qemu-devel/20200312161217.3590-1-david@redhat.com/
> 
> which notes:
> 
> "Instead of inhibiting during the region_resize(), we could inhibit for
> the hole memory transaction (from begin() to commit()). This could be
> nice, because also splitting of memory regions would be atomic (I
> remember there was a BUG report regarding that), however, I am not sure
> if that might impact any RT users."
> 
> 
I read:

"Using pause_all_vcpus()/resume_all_vcpus() is not possible, as it will
temporarily drop the BQL - something most callers can't handle (esp.
when called from vcpu context e.g., in virtio code)."

Thank you,
Emanuele

