Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1D1531ABE
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiEWTfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 15:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbiEWTeb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 15:34:31 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F906AA6E
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 12:20:54 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id gh17so17842749ejc.6
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 12:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s4NXdeQQKWvWvoBKIexqsaA2xKby6bTyPdzMQURl0iA=;
        b=ZQyDC3ru3VrplK4uyLIsEPHte6AbxUfu1dzoFvZzfbdWEoClqXlsNgDerDrWFGBaKF
         Q9ysXLd9Vv+cYEmLIudtYwakW20D+5yTwA6nK/QnadOQ1oBdjJMgkSPAYgIuk5c0mDdV
         s53+1pv7GNirB4DKPVRya0eZCtEO5aaHUONXqDPWytec5lFCOdrgLE0qYF23LTnT4Ff6
         MupBNh3qFu6kQ7/Jl+fy1yI2PYfXe6X3shZI+BiKywqVJD+vKJ+gtboU+j2laXewG0Bh
         gfogctBmbn99q0EERoRcft0czOm16JEoy7FstlHRcXIeZ+ioZrK8l7apFGbWzsIE86C0
         LbOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s4NXdeQQKWvWvoBKIexqsaA2xKby6bTyPdzMQURl0iA=;
        b=OqNd53KwlsoK47c8YSIB1P7H1wydrsNFxKxLKxuN9/CV+TMQZJ3xqWM0IvrXJ1puG9
         lrhf6h5+Vuy2Nh9c+Rt7awMA3U+daGKyOaepnUY+3LU4l9NzVQVl1qBtlZVIdUCUPGsp
         422jIQu/Zg9N4ghijWWHnUDoqkMzgsuUgmJvTYXR/x+UfPYpLt0YFH5pqr4o7ZLJskmo
         QrygwqjeWc5yW7lY6yNmhlaZHQ244cYTfx2jkC9cie8K+nW9u+SqDtZ6j4MQoWQmyZSQ
         XJM0HQlq1ZDFIaQoucL//kWEX45XDDv5ScArIgq7iWEVhfBbD4G6eFoX+Qxreh3h8/i5
         gaSw==
X-Gm-Message-State: AOAM533L4615AOy302TrvGRE2n/ZhokARPtuqxg0dyjeiLzUbzxpza0x
        j6CgKgRXPQ3hLqFMOK5qo5HeTyHI/oXx3g==
X-Google-Smtp-Source: ABdhPJx4b9IPISoCkIDt4g0CI4POjmWAn+etCcesUsxdjjjdTQcN1uZ/g8kCTZ0jOfdXT99rdBLoww==
X-Received: by 2002:a17:907:7815:b0:6ce:5242:1280 with SMTP id la21-20020a170907781500b006ce52421280mr21120872ejc.217.1653333652414;
        Mon, 23 May 2022 12:20:52 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id o8-20020a1709064f8800b006f3ef214ddbsm6408170eju.65.2022.05.23.12.20.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 12:20:52 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <6a54047c-fda2-015a-2663-26b1dd2d5ebb@redhat.com>
Date:   Mon, 23 May 2022 21:20:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] KVM: set_msr_mce: Permit guests to ignore single-bit ECC
 errors
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Lev Kujawski <lkujaw@member.fsf.org>
Cc:     kvm@vger.kernel.org
References: <20220521081511.187388-1-lkujaw@member.fsf.org>
 <You/kms+AnKE1t0L@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <You/kms+AnKE1t0L@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/23/22 19:08, Sean Christopherson wrote:
> If KVM injects a #GP like it's supposed to[*], will UNIXWARE eat the #GP and continue
> on, or will it explode?  If it continues on, I'd prefer to avoid more special casing in
> KVM.
> 
> If it explodes, I think my preference would be to just drop the MCi_CTL checks
> entirely.  AFAICT, P4-based and P5-based Intel CPus, and all? AMD CPUs allow
> setting/clearing arbitrary bits.  The checks really aren't buying us anything,
> and it seems like Intel retroactively defined the "architectural" behavior of
> only 0s/1s.

I'm always a bit worried about removing #GP behavior (just like adding 
it of course) because sometimes it is used by OSes to detect specific 
non-architectural processor behavior.

Paolo
