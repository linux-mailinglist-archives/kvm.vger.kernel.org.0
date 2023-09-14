Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC28879F8D6
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbjINDYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjINDYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:24:48 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB611BD9;
        Wed, 13 Sep 2023 20:24:44 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id 006d021491bc7-5733789a44cso291269eaf.2;
        Wed, 13 Sep 2023 20:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694661884; x=1695266684; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WRW3w7Rfwm4bJgX5rey8U6FSrmXVfd8dPhYxslx4gaE=;
        b=pHsxsHy1+NR14Mhgx0ZpsrEuRRk7XOfI4enmRC9LkcRN/PKNlCpy6hu7eMWN+zgCae
         hz8WEjVI54GJ2Z0SDGI/1uuQ/X037MRZXPve0UGReAFftBhfDro8xMeoHBWBXXRtSKAd
         beAXalYqCoqU9zvzZ1GkaorWZ3cxM4S/w564P+jEGBPf8FnO9gW6hgGWgC7Euz09n1i4
         YZ95jGr7VEJFq37dVudqyQTjeQ75bPK2m3RmbUkUr2audGEkTkbmq2BPPsMgIZgCP/zp
         aCJp+RmOzgVXIKcpvNgy2BbPOwwzYbcfeuHpdKWToomUxChM2NU60xQv+fqCp2ByCUo9
         I3yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694661884; x=1695266684;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WRW3w7Rfwm4bJgX5rey8U6FSrmXVfd8dPhYxslx4gaE=;
        b=eWOdowlfZ8ixCOw3Eqjdy/Fct3smBw5880heLyJ2f8LXH/w+eHH3duIctuXM+NjJy0
         hNy48GyQzQJlJHMfYWcyBZOwKwF9NkdpTBZ41T7b2mS4MhTadD+FCc9FMQi1raht4Kut
         ylZHUKfmSNQsjzvgj2zWrkqOPTl5FGSOf68CMKOw5oIHlZJE1EzLUMiJwTN+xAYjrjs7
         FgniaUn9QRGdTVqw5Gc6W19sWPAe1dDgKvaS/Q9f8mjOUDlKIPDKwD/IEOgSoDZCA/Vq
         C/+Pn1lhWyqTl9hkOM05eY8RZUApncjIiqDRx5OSQu8BnUcSfnUIGCWWRlLeYEepkIUe
         mWLw==
X-Gm-Message-State: AOJu0YxRc2SMlA7qQxGC3xB0gB0Nz4AiZXgY6jGSd4fYls7iswj/PAL6
        E9LLOfydeb/yCb/EAAkHFHE=
X-Google-Smtp-Source: AGHT+IFXL6V1K2ltGfbRo0fLoRoczFgdScQehSrNQoTYZM7BRsKmlAZrtONWu1GJQ/5Vn7vbrbGGqg==
X-Received: by 2002:a05:6358:5291:b0:140:f6ab:b11e with SMTP id g17-20020a056358529100b00140f6abb11emr5576969rwa.28.1694661883790;
        Wed, 13 Sep 2023 20:24:43 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w30-20020a63935e000000b005501b24b1c9sm225124pgm.62.2023.09.13.20.24.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 20:24:43 -0700 (PDT)
Message-ID: <de4b831a-6649-2462-e4cf-fcefa6e912be@gmail.com>
Date:   Thu, 14 Sep 2023 11:24:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v4] KVM: x86/tsc: Don't sync user changes to TSC with
 KVM-initiated change
To:     Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230801034524.64007-1-likexu@tencent.com>
 <ZNa9QyRmuAjNAonC@google.com>
 <055482bec09cae1ea56f979893c6b67e9d6b26a2.camel@infradead.org>
 <ZQHMM8/7xXReZHdD@google.com>
 <b83a52bf72b951e69d3df23fff144899b0d6c11d.camel@infradead.org>
 <ZQHSJ9Epx1oNTZGE@google.com>
 <814044c62f8804866a6dc4c523797c06d73c82f1.camel@infradead.org>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <814044c62f8804866a6dc4c523797c06d73c82f1.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/9/2023 11:24 pm, David Woodhouse wrote:
> On Wed, 2023-09-13 at 15:15 +0000, Sean Christopherson wrote:
>>>> e.g. if userspace writes '0' immediately after creating, and then later writes a
>>>> small delta, the v6 code wouldn't trigger synchronization because "user_set_tsc"
>>>> would be left unseft by the write of '0'.
>>>
>>> True, but that's the existing behaviour,
>>
>> No?  The existing code will fall into the "conditionally sync" logic for any
>> non-zero value.
> 
> Yeah, OK. This isn't one of the cases we set out to deliberately
> change, but it would be changed by v6 of the patch, and I suppose
> you're right that we should accept a small amount of extra code
> complexity just to avoid making any changes we don't *need* to, even
> for stupid cases like this.
> 
> 
>> I don't care (in the Tommy Lee Jones[*] sense).  All I care about is minimizing
>> the probability of breaking userspace, which means making the smallest possible
>> change to KVM's ABI.  For me, whether or not userspace is doing something sensible
>> doesn't factor into that equation.
> 
> Ack.

If we combine the v5 code diff (the u64 *user_value proposal) with the refined 
changelog in v6,
it seems like we've reached a point of equilibrium on this issue, doesn't it ?

Please let me know you have more concerns.

> 
> Although there's a strong argument that adding further warts to an
> already fundamentally broken API probably isn't a great idea in the
> first place. Just deprecate it and use the saner replacement API...
> which I just realised we don't have (qv). Ooops :)
> 
