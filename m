Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C81929D3A0
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 22:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgJ1Vph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 17:45:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40799 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726097AbgJ1Vpg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Oct 2020 17:45:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603921534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=66nQyac2hxeaBQvnu3KghvLtDJPnPJ2NCil3q6sKCIg=;
        b=X55rUPVa8g84zR5hz81o8vq1lmxxTYqY30A5JK8z6nq/TNkNygwfofsxXruKKDXnPyXAQO
        MJC74S41atNbPVurwfNUc4B6DTOhIUnAyDT3UFLRgnfxdhsSHv1kZe41VQtbq85oExnmzu
        cqpZ+xwu3S8MlScPBmGOndLXVVjp5Jg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-8azooClHMwyNfkceA9PlLw-1; Wed, 28 Oct 2020 10:44:55 -0400
X-MC-Unique: 8azooClHMwyNfkceA9PlLw-1
Received: by mail-wr1-f70.google.com with SMTP id w1so401934wrr.5
        for <kvm@vger.kernel.org>; Wed, 28 Oct 2020 07:44:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=66nQyac2hxeaBQvnu3KghvLtDJPnPJ2NCil3q6sKCIg=;
        b=nwUfwGpQTPwvhCeVImYbHhymzssF8++UTNruyDdZOmsIQecKGlNop8cU+GWYbF7FrC
         viwZJ8DoKyZJNXJek19i0Pu2DH60ZXu4KuNLNe11JRhJw034+TZdFFc0crYmNcSQ8lxw
         38Me2M3r2M2OkX9eFH3AmNmhPMpibKRUdgv4dPKzHmbjCWBkf0RdiUtkDd/p8STtfjV1
         7ao+C52pnJ3nVkH3w8By0JUFeluRBGBxBtNT6JjYssrACAEhPCoy4/Hnbc/6sW/uZZLr
         X1/XUf91R8p5yBnGiVRmsTHOtIYMRfZ1a4S/NZfUZhqkS/TbRccb2KvNn7ZMF1Oo5Fuz
         4hmQ==
X-Gm-Message-State: AOAM532/QF6E1d/zI4Yq+lGCng1DdduRkqUtHFywiApXlUfm/mNNZcg6
        IVPh0kKkM07iTchuQhQZYkFia7+aImuCsFdvo2HeQropW/1oZ05SOnOTXmzE9+y5B+3JzaU2j3g
        zXV5mw/CgOjsN
X-Received: by 2002:a1c:6302:: with SMTP id x2mr9139059wmb.121.1603896293884;
        Wed, 28 Oct 2020 07:44:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyVZ1pMlnMRV9XQp7ynV1e5d9Un1RCNyFC9GqQDtizxI9AAulK2o6sKxWadGDvbXi+JMtVvKg==
X-Received: by 2002:a1c:6302:: with SMTP id x2mr9139042wmb.121.1603896293696;
        Wed, 28 Oct 2020 07:44:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k81sm1492901wma.2.2020.10.28.07.44.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 07:44:53 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] sched/wait: Add add_wait_queue_priority()
To:     Peter Zijlstra <peterz@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     Davide Libenzi <davidel@xmailserver.org>,
        "Davi E. M. Arnaut" <davi@haxent.com.br>, davi@verdesmares.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        kvm@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
References: <20201026175325.585623-1-dwmw2@infradead.org>
 <20201027143944.648769-1-dwmw2@infradead.org>
 <20201027143944.648769-2-dwmw2@infradead.org>
 <20201027190919.GO2628@hirez.programming.kicks-ass.net>
 <220a7b090d27ffc8f3d00253c289ddd964a8462b.camel@infradead.org>
 <20201027203041.GS2628@hirez.programming.kicks-ass.net>
 <0bc19d43229d73c0fcd5bda1987e3dbb9d62a7e0.camel@infradead.org>
 <20201028142031.GZ2628@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c2d63dd8-4f31-df23-2834-979a261f7653@redhat.com>
Date:   Wed, 28 Oct 2020 15:44:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201028142031.GZ2628@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/10/20 15:20, Peter Zijlstra wrote:
> Shall I take the waitqueue thing and stick it in a topic branch for
> Paolo so he can then merge that and the kvm bits on top into the KVM
> tree?

Topic branches are always the best solution. :)

Paolo

