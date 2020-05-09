Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E271CC1AD
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 15:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgEINOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 May 2020 09:14:34 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31048 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726891AbgEINOd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 9 May 2020 09:14:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589030072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9vIjQnViRfZwscroTfECH3V+T4XrW9uR2jVjjcW+gQc=;
        b=RXXMoa98/swJH3kmgDW3XRgi0wk7yKLsK2sOz3kqAFUU1OwGEmkc6YwuUQg4uH4PCKp2Sy
        jmQBbNBEwxguPBEKre9FF/2+p5uBHebM8E8eAFc6IB6ByGEfVKgaB92uMwFcaptXnnH75W
        qMuaqz9fc7rSh/jwB4vis+bJPVgO83c=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-t0rbHnYENauD92XTg9DTQA-1; Sat, 09 May 2020 09:14:30 -0400
X-MC-Unique: t0rbHnYENauD92XTg9DTQA-1
Received: by mail-wr1-f72.google.com with SMTP id 90so2314579wrg.23
        for <kvm@vger.kernel.org>; Sat, 09 May 2020 06:14:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9vIjQnViRfZwscroTfECH3V+T4XrW9uR2jVjjcW+gQc=;
        b=NKhePtRsHzgK6L+Nu4E4rzKAIwHFpNX/w+O5A5OyUS6gGij+/wjkJfycAfwWXMY0EX
         o9NEKEUE5eJrQQuL5dPUx5GDLgYCZpN4sRCNaskucOj8QZ3QE7WlWA0vqPzu8UY7E0rP
         v2kiSs/sSPnKxUNQVuf0bHDiyeU7jH3lGol6s6uvg3n7qsmXjeOuydrfRHjGdaOiBwpE
         3OwVwakuFTAA9Q8ahz/27eUHiV7ftD/N6bJPEYskiKXDrXnrurOpbS6ycNaSvgGkOts9
         Uf/Mv4VfDzbNTBqHlu8kC5+++O07w4EfdU5sur0sYFeAgqDmPlefT6cz8ztLpg19x8z1
         tk5Q==
X-Gm-Message-State: AGi0PuZUSIF6cpYgU1vXFs2qcLm28T0wNk8yb+sPwMxSllg9kOv/Il0D
        iFV46oAh0Kth0kmOe+Iwf+jVlJkuJpPT0aoC71/5SNA5NxSRw0n0CIDSeu65vDgvqXdAbvYSyIn
        c+K/8VK1HBFxa
X-Received: by 2002:a5d:510f:: with SMTP id s15mr9122652wrt.103.1589030069206;
        Sat, 09 May 2020 06:14:29 -0700 (PDT)
X-Google-Smtp-Source: APiQypLHkyvgwx2twdUJ9IkwN+FBSqsH1YDklvr4+UWoTcvOatZ2XbqtRYDG/JDt1+5a1NKwVmOD8w==
X-Received: by 2002:a5d:510f:: with SMTP id s15mr9122636wrt.103.1589030068937;
        Sat, 09 May 2020 06:14:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cb4:2b36:6750:73ce? ([2001:b07:6468:f312:1cb4:2b36:6750:73ce])
        by smtp.gmail.com with ESMTPSA id p9sm1744666wrj.29.2020.05.09.06.14.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 06:14:28 -0700 (PDT)
Subject: Re: [PATCH 0/3] Pin the hrtimer used for VMX-preemption timer
 emulation
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20200508203643.85477-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0f0f4134-be5e-47d1-f22c-6fe223157fbf@redhat.com>
Date:   Sat, 9 May 2020 15:14:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200508203643.85477-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/20 22:36, Jim Mattson wrote:
> 
> It might be possible to improve that pass rate even more by increasing
> the scaling factor in the virtual IA32_VMX_MISC[4:0], but you'd have
> to be even more of a stickler than I to go to that extreme.
> 
> By the way, what is the point of migrating the hrtimers for the APIC
> and the PIT, since they aren't even pinned to begin with?

Unless housekeeping CPUs for timers are configured, the timer will run
on the CPU it is started on, even without pinning; see
get_nohz_timer_target.

Paolo

