Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C24206CC5
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 08:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389001AbgFXGnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 02:43:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37707 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388428AbgFXGnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jun 2020 02:43:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592981029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/02uPq4zk8r0wmfzw4RQauYtrOqYi6rH11UOMOfXqAc=;
        b=T3aZIUocFomuKhhrozgIeMJxxCtwhUBGPBimVPRwi5G+5od7jOFYgXmjHgKV8YN4mPWd4H
        pC67vVN2Mwynw4mRhkD+yx6Hlid05QrqMRvEmiiiht+r9TgYNXOZA57aPQHU2e+bXHcHmJ
        tP0er7qeXyWXdoLWacV43Xh9Ny4csno=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-1yggjp3sNHCa5r1JQYuZ_g-1; Wed, 24 Jun 2020 02:43:45 -0400
X-MC-Unique: 1yggjp3sNHCa5r1JQYuZ_g-1
Received: by mail-wr1-f69.google.com with SMTP id a18so2067919wrm.14
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 23:43:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/02uPq4zk8r0wmfzw4RQauYtrOqYi6rH11UOMOfXqAc=;
        b=l2IVrlAKAhJHf5uPmpfMClClm6Xlk5Ek7Dv/5taOPQ8694cerPwVyu6Ko7YXH4uRr1
         KKrpm3v23A75vqkp8MT9kewKNVJYF2x9eCRtxVLKiu1jmSN9j3fStKxl9UByKAkFTv2E
         dBsTBynjO9UDoOQsWsuvn7hx8Oa7Zc5TZnxCI2eBGUARZNJC6kRYO4Y4mqNAll68F8b4
         47X2+b//03LJ/aPfY1bogNk2/jP1zXenjekMrrMb0iq6ZsFVyWu6FDJMvqM65OSEr6aC
         X3qBrKTZd+KicAHoPud1kkO2FXzeem2d/Dg8Ze2FdYG/6E9WyZwY/I9KqgJ2AmVhgYt6
         8/Qw==
X-Gm-Message-State: AOAM531l+tE07+hvWUtfj3IKwHopO1dvhEc9A6S50q8af2Ml9wyECpwM
        v7pGJVIPBYI0EvwMEKvfDQR/0KTAQzxN62n/dQ5ITYek1KktHoWSobifUp4FI8KcOIvSCKH/7wS
        K10V6NTVIoL8C
X-Received: by 2002:a05:600c:d5:: with SMTP id u21mr21547876wmm.156.1592981024118;
        Tue, 23 Jun 2020 23:43:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4S+p3wcBQffEBfpwNSYs8PcQV+/Dza8uSM51jRvN2rnhyAEmqHGkXnYkJG6PI1dIAdlbMUQ==
X-Received: by 2002:a05:600c:d5:: with SMTP id u21mr21547861wmm.156.1592981023916;
        Tue, 23 Jun 2020 23:43:43 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id z6sm2554267wmf.33.2020.06.23.23.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 23:43:43 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] x86: always set up SMP
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        cavery@redhat.com
References: <20200608160033.392059-1-pbonzini@redhat.com>
 <630b9d53-bac2-378f-aa0a-99f45a0e80d5@redhat.com>
 <af2c5e61-3448-0869-22a2-7be5f11e72eb@redhat.com>
 <C6C2F636-A610-4880-A7E9-409EE260DDC3@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4f8e46f4-172c-5447-bfd2-36e4d459ee1c@redhat.com>
Date:   Wed, 24 Jun 2020 08:43:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <C6C2F636-A610-4880-A7E9-409EE260DDC3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/20 11:11, Nadav Amit wrote:
>> I'm not sure why it starts failing now, the bug is unrelated and I see
>> the same compiler output even before.
> I encountered the same problem on my (weird) setup, and made some initial
> triage. Apparently, it is only the #DE that causes the mess. As the #DE uses
> vector number 0, and the IDT base is 0, it hints that the data in address 0
> is corrupted.
> 
> I presume there is somewhere a rogue store into a NULL pointer during the
> 32-bit setup. But I do not know where.

Thanks, that is certainly going to be helpful.

Paolo

