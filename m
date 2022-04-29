Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646C6515010
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 17:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378690AbiD2QCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 12:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378679AbiD2QCV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 12:02:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C29685654
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 08:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651247942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LxsX4QTfntQs6C7Yv2fWXMkZHy++Bj4rZ1fvoMUwGU8=;
        b=GDZXAObdXzzohceVMgnAXlScmFX4wCwhieYUxYpRvNkpGhWnwRBbBYYCR1G79fKZbbfGl9
        ScI3XpnTAoB4RVn2gsHkDPDuMve1ytoiDt857Si1mR9Ihl0DZICQKMUXEZi8vWS99HpLkC
        X/+vhk/xMkcGIP1FB0gQwikkTZWVqzw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-eiaUzX2KOnKHUXSWQU0ZmQ-1; Fri, 29 Apr 2022 11:59:01 -0400
X-MC-Unique: eiaUzX2KOnKHUXSWQU0ZmQ-1
Received: by mail-ed1-f71.google.com with SMTP id h7-20020a056402094700b00425a52983dfso4784408edz.8
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 08:59:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LxsX4QTfntQs6C7Yv2fWXMkZHy++Bj4rZ1fvoMUwGU8=;
        b=6XabRnO+FBelljTWeDLCTXSdaKaX0L0kHsnK9jG3d1moFsvnH3xtyUpEW+nmvciuze
         B9k9kIq34UuPX7advSgvMm3m2IsAm5MEuUYCE4vi7fZ+5iXIQlKre055vMNRH3ZqeF+I
         cx0Dsn4uAFj4xAjnSaUK+2dp1xchxBLrmvIyTX2Hbd2rbvRZc8L3vMFmZ8O311ORiI0r
         a47LAgjsizUekB4Pqv67ACNEN9B4/NErppip+CwApZ9dAY8/nB9igs4mqu+7cG66IAgx
         y6MugpvvrVGonUuH6h/8BTmKhkeu1MzzMVSoyuemoXv4sjg+mxskyY5owMD0YWr/ezJm
         zfxA==
X-Gm-Message-State: AOAM532UOEYHjK4UDPKRVImp7MOVwwysiQ5uuosN/2vIOo01M4PFMmvy
        h0j4nX3Y9Q2gtiODofH8HGGDtTnm2LnICt0ft48Bzu1aFdaXomhZfg1iuiG2GoYLSH7CojJn9TC
        SQaOrxbqbG0Y3
X-Received: by 2002:a05:6402:5207:b0:426:1f0:b22 with SMTP id s7-20020a056402520700b0042601f00b22mr17790317edd.186.1651247939305;
        Fri, 29 Apr 2022 08:58:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9rfe2BvOZTLBxZyXAtLi09aJqjNbWyrLDxfj+FFkLsfpQGzZb0LJod/amJ9dE9xKbjLvuoQ==
X-Received: by 2002:a05:6402:5207:b0:426:1f0:b22 with SMTP id s7-20020a056402520700b0042601f00b22mr17790296edd.186.1651247939050;
        Fri, 29 Apr 2022 08:58:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id l21-20020a056402345500b0042617ba6393sm3053394edc.29.2022.04.29.08.58.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 08:58:58 -0700 (PDT)
Message-ID: <4afce434-ab25-66d6-76f4-3a987f64e88e@redhat.com>
Date:   Fri, 29 Apr 2022 17:58:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3] KVM: SEV: Mark nested locking of vcpu->lock
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     John Sperbeck <jsperbeck@google.com>,
        kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220407195908.633003-1-pgonda@google.com>
 <CAFNjLiXC0AdOw5f8Ovu47D==ex7F0=WN_Ocirymz4xL=mWvC5A@mail.gmail.com>
 <CAMkAt6r-Mc_YN-gVHuCpTj4E1EmcvyYpP9jhtHo5HRHnoNJAdA@mail.gmail.com>
 <CAMkAt6r+OMPWCbV_svUyGWa0qMzjj2UEG29G6P7jb6uH6yko2w@mail.gmail.com>
 <62e9ece1-5d71-f803-3f65-2755160cf1d1@redhat.com>
 <CAMkAt6q6YLBfo2RceduSXTafckEehawhD4K4hUEuB4ZNqe2kKg@mail.gmail.com>
 <4c0edc90-36a1-4f4c-1923-4b20e7bdbb4c@redhat.com>
 <CAMkAt6oL5qi7z-eh4z7z8WBhpc=Ow6WtcJA5bDi6-aGMnz135A@mail.gmail.com>
 <CAMkAt6rmDrZfN5DbNOTsKFV57PwEnK2zxgBTCbEPeE206+5v5w@mail.gmail.com>
 <0d282be4-d612-374d-84ba-067994321bab@redhat.com>
 <CAMkAt6ragq4OmnX+n628Yd5pn51qFv4qV20upGR6tTvyYw3U5A@mail.gmail.com>
 <8a2c5f8c-503c-b4f0-75e7-039533c9852d@redhat.com>
 <CAMkAt6qAW5zFyTAqX_Az2DT2J3KROPo4u-Ak1sC0J+UTUeFfXA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAMkAt6qAW5zFyTAqX_Az2DT2J3KROPo4u-Ak1sC0J+UTUeFfXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 17:51, Peter Gonda wrote:
>> No, you don't need any of this.  You can rely on there being only one
>> depmap, otherwise you wouldn't need the mock releases and acquires at
>> all.  Also the unlocking order does not matter for deadlocks, only the
>> locking order does.  You're overdoing it. :)
> 
> Hmm I'm slightly confused here then. If I take your original suggestion of:
> 
>          bool acquired = false;
>          kvm_for_each_vcpu(...) {
>                  if (acquired)
>                          mutex_release(&vcpu->mutex.dep_map,
> _THIS_IP_);  <-- Warning here
>                  if (mutex_lock_killable_nested(&vcpu->mutex, role)
>                          goto out_unlock;
>                  acquired = true;
> 
> """
> [ 2810.088982] =====================================
> [ 2810.093687] WARNING: bad unlock balance detected!
> [ 2810.098388] 5.17.0-dbg-DEV #5 Tainted: G           O
> [ 2810.103788] -------------------------------------

Ah even if the contents of the dep_map are the same for all locks, it 
also uses the *pointer* to the dep_map to track (class, subclass) -> 
pointer and checks for a match.

So yeah, prev_cpu is needed.  The unlock ordering OTOH is irrelevant so 
you don't need to visit the xarray backwards.

Paolo

