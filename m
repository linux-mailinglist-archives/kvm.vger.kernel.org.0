Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A84D27B33B
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 19:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgI1RbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 13:31:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726424AbgI1RbS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 13:31:18 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601314277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BmBUVhbY8uYL/9rFspjmnabiru47MygeGdBGbv0g4Ck=;
        b=HYjM4uWSGL0Ua6CJn28Wli9scPYlNtwJoFNze8WRPN6dUe8Mtk7e7keBaBGDAaRrQjyh2Q
        cQiD4YxTnSpUE+ws6ZxtU6PaOn7vawyq8AgKp5R2oOLxmSWgenv3qNxFyP5wZ2805dzQve
        p5XoAyyXH/ureAblIUqCiMXAx0SWYwE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-MtjNDhinOvq_PS6Ftle2vA-1; Mon, 28 Sep 2020 13:31:15 -0400
X-MC-Unique: MtjNDhinOvq_PS6Ftle2vA-1
Received: by mail-wr1-f72.google.com with SMTP id f18so669700wrv.19
        for <kvm@vger.kernel.org>; Mon, 28 Sep 2020 10:31:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BmBUVhbY8uYL/9rFspjmnabiru47MygeGdBGbv0g4Ck=;
        b=cidvtPHV6uUw/tkaSMDI1uVoUChuc3Fj8SAxivMcSGWtdI/1RZlMqZi+ugliRz9CPd
         drF1a8e7uGciP/HI6cXYkw/4m7w41LG/dSt6Vx6ADYu4mIjOtHYaQR5MKiMRFnVIzygX
         Einw3xa5UVfNcx2IuTJUcuZk4yILtjIKiao/cLywKgDxwzT6RJGxip+MmYhUrRJ2PkFy
         hespaVot13KyRZ43lEF5j4hEhCkEIUzwuzqBbvktSvNdo/GQPlZRbuQuUA/kvZ1FInKI
         +Pgv44Z8NTHPyclc8vAqH53JeftAxRR33dZ0Y19mogsECf5op4Gm6WtWknd7rKcSkJp4
         6lnw==
X-Gm-Message-State: AOAM530FNbHvsh4Rjt4Hd/u9nAZrl6QfYVrbL7YqzDJUs9QPyaCwgZ3r
        uTs9Lz8oeGgprcT7IqPQFgNJOAnoP5CgemSea47Jz+PaOqRLNAxilvxYjvZYQO1qgomXTJi8NIz
        LINkUIE7ttBsp
X-Received: by 2002:a7b:cb17:: with SMTP id u23mr262377wmj.166.1601314274216;
        Mon, 28 Sep 2020 10:31:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwaUnnk7NPkByA7LLdvtAfjRG19RKiw8pzMjMqzLNtVXmwZmZHbRHGM9re/YfcV595i17Rww==
X-Received: by 2002:a7b:cb17:: with SMTP id u23mr262350wmj.166.1601314273923;
        Mon, 28 Sep 2020 10:31:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f4f8:dc3e:26e3:38c7? ([2001:b07:6468:f312:f4f8:dc3e:26e3:38c7])
        by smtp.gmail.com with ESMTPSA id f6sm2225248wro.5.2020.09.28.10.31.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 10:31:12 -0700 (PDT)
Subject: Re: [PATCH 00/22] Introduce the TDP MMU
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20200925212302.3979661-1-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <425b098c-dbe0-d614-8e62-1f50b2f63272@redhat.com>
Date:   Mon, 28 Sep 2020 19:31:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 23:22, Ben Gardon wrote:
> This series is the first of two. In this series we add a basic
> implementation of the TDP MMU. In the next series we will improve the
> performance of the TDP MMU and allow it to execute MMU operations
> in parallel.

I have finished rebasing and adding a few cleanups on top, but I don't
have time to test it today.  I think the changes shouldn't get too much
in the way of the second series, but I've also pushed your v1 unmodified
to kvm/tdp-mmu for future convenience.  I'll await for your feedback in
the meanwhile!

One feature that I noticed is missing is the shrinker.  What are your
plans (or opinions) around it?

Also, the code generally assume a 64-bit CPU (i.e. that writes to 64-bit
PTEs are atomic).  That is not a big issue, it just needs a small change
on top to make the TDP MMU conditional on CONFIG_X86_64.

Thanks,

Paolo

