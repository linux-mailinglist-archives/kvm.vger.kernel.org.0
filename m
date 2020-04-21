Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875491B30A9
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 21:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgDUTvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 15:51:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39337 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726039AbgDUTvw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 15:51:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587498711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qGYpXz6VdCPTKs7yYyKCHLyhRb5XfP8CRNgtLy4ommU=;
        b=ENKK17mN2Qdi+4Q993au2qGG9q4TgwW/nyDdEvDVlqxhqixBTE8vIl8s+J5lpDBXD77hBu
        LbvSncBVIIwSJOJjPnsKA0FU1lJLwN3CQ7EaQs4GQsqN4FxsJgs5ZeIGPHpZuPHhdKr4AT
        VOCdkBBReXIeR5TSIjJMFDtIcxqEf80=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-18hqGz05Oj-6fYm41gIaRQ-1; Tue, 21 Apr 2020 15:51:46 -0400
X-MC-Unique: 18hqGz05Oj-6fYm41gIaRQ-1
Received: by mail-wr1-f70.google.com with SMTP id d17so8254191wrr.17
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 12:51:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qGYpXz6VdCPTKs7yYyKCHLyhRb5XfP8CRNgtLy4ommU=;
        b=lndOl387qARwtgRVi1wiZDJe9VKpVVdkn9gH5JvXw6BlIlqW5SZiVjP+CWDE0f/ZDD
         8tQ5pmC5S1KgpHjzAjf/sEaMzP/BaATwkN1JY3jUaTH+wwBs5AUXB4n+QK3+ydqJVur3
         dPT9m3aRGkuA9fTGP8cscHIMoizWRYkn4ieMhZqazUsv7PxuvLo/kHIsStN1pEkUdC6+
         rriHBOF3/L1Ig64Rb/JcIjCQFfRqE6I1aif/YrMjt+JtKjI8380skLb2D/FyZnvYwLgd
         kuOtYSK6XO738yzfo56qZ55SjVQVINojeZyQD+RSgO0z70lEhjW5Mj2Yt59JPL9AVe2p
         YfcQ==
X-Gm-Message-State: AGi0PuaqmV6wfWYhzuhZjt5/IT44Xxrsl3GziPC8dCE5JJ2DZ7lDGxVw
        oj0AfIVDomK6WNVBD/CMV8ecCS6FV4fmGOMNx8w510waR1PGS8wg4YfmBwVavvs9LIEjrZ24TGH
        k52COdWs/f+XR
X-Received: by 2002:a1c:9dd1:: with SMTP id g200mr6999169wme.82.1587498705645;
        Tue, 21 Apr 2020 12:51:45 -0700 (PDT)
X-Google-Smtp-Source: APiQypKCm0OdoTbIs/9fTEnN7H+32sVw2+Ijze7xR/UCwljoIR89/XFefVi/yu08ILmptP0S3k6XUA==
X-Received: by 2002:a1c:9dd1:: with SMTP id g200mr6999153wme.82.1587498705368;
        Tue, 21 Apr 2020 12:51:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id d7sm4918133wrn.78.2020.04.21.12.51.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 12:51:44 -0700 (PDT)
Subject: Re: [GIT PULL] KVM changes for Linux 5.7-rc3
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
References: <20200421160651.19274-1-pbonzini@redhat.com>
 <CAHk-=whVo7CzzjEYp+G7+MjNSg4cURR4SeUTvQSYVBFn3o5TPw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <04150cae-6fbf-70c6-d968-b287f478a674@redhat.com>
Date:   Tue, 21 Apr 2020 21:51:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=whVo7CzzjEYp+G7+MjNSg4cURR4SeUTvQSYVBFn3o5TPw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/20 21:35, Linus Torvalds wrote:
> On Tue, Apr 21, 2020 at 9:07 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>>   https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
>>
>> for you to fetch changes up to 00a6a5ef39e7db3648b35c86361058854db84c83:
> 
> Did you perhaps forget to force-update that tag?
> 
> That tree still shows the tag from April 7 (that I merged in commit
> 0339eb95403f).

Oops, yes I did.  /me goes and adds "set -e" to the script.

Paolo

