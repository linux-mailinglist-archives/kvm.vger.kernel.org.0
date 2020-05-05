Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7521C5E3F
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 19:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730573AbgEERCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 13:02:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20123 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728804AbgEERCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 13:02:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588698159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5wA5G//ZMwKX3KXqf3Mv3pq9KAcUMr/otngiqdWE/rQ=;
        b=MlVHtLTYs5c/qp4v+MUqKfkdu+gayo+YrOPdAPrqUH17h94GAYml7XE29etNbtWuddsCtW
        lHhOjlF5obhgRGHZImG+zNhOtOYCTCI2DKRDafbn3xN1h2wIaYHP7UseGYylGVXb7Hfr0K
        tuDvQuLf2c42QCOCcWHjvH9qAmLE45U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-8kh8I7z3Nw-ZXO2Q4FlAXg-1; Tue, 05 May 2020 13:02:37 -0400
X-MC-Unique: 8kh8I7z3Nw-ZXO2Q4FlAXg-1
Received: by mail-wr1-f70.google.com with SMTP id y4so1537865wrt.4
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 10:02:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5wA5G//ZMwKX3KXqf3Mv3pq9KAcUMr/otngiqdWE/rQ=;
        b=m8aFz9O5zHFOiVqrvwggvDNMOa3SHcTObBeVi2Tp90BndW8N8cbj91Ddx1mcbIb0o1
         tuuZe7Gjbd8xfF3/OBl2Mkd8rsyWB4GJLkHsZd2xXwDZ8jSxRp04g9Lxq2g5l7Y30Zy3
         QA1tQii8YSs8Dt2Y+vi+ysnhz5Xb3evCn6ymNioLgbdDm3K1hao6l/v4R2ZQ7CF1J2Aq
         8EbJfk1rmXqhNKM9RSSU6Oxyy8vWGT/CSfUUEGBWwatgIyGBOcY34j40+39adZe6WLNW
         lJiibGQulOTmzFUbj+TEINYixExZhRqHLGWKRyLJXD/CMPWZHf8SZ+cVsfcYQO/eRGvJ
         pu2g==
X-Gm-Message-State: AGi0PubTBWqzF3PBx2AAGXze+m3f7enLUbP5o/0IY6ZpXpgxIY5uDZZe
        Kqp91E6A/Jf3+Gb64AuIEgt99W8uOB1IWnPbVk9dx9fzJ0+RxYDHnKXDdojZM3yWoj2P9tfJlmy
        zwux1jGWDQIf+
X-Received: by 2002:adf:d0c5:: with SMTP id z5mr5096750wrh.410.1588698156792;
        Tue, 05 May 2020 10:02:36 -0700 (PDT)
X-Google-Smtp-Source: APiQypJLNwomNOVHwIvpSDnSwZmv6Omr127dtUlNqUvacYqezIg5AT62IcLqVfdIy2Hep5WWyqsAoA==
X-Received: by 2002:adf:d0c5:: with SMTP id z5mr5096701wrh.410.1588698156541;
        Tue, 05 May 2020 10:02:36 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id g24sm1632241wrb.35.2020.05.05.10.02.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 10:02:35 -0700 (PDT)
Subject: Re: [PATCH v2 0/5] Statsfs: a new ram-based file sytem for Linux
 kernel statistics
To:     Jim Mattson <jmattson@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Emanuele Giuseppe Esposito <e.emanuelegiuseppe@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
References: <20200504110344.17560-1-eesposit@redhat.com>
 <alpine.DEB.2.22.394.2005041429210.224786@chino.kir.corp.google.com>
 <f2654143-b8e5-5a1f-8bd0-0cb0df2cd638@redhat.com>
 <CALMp9eQYcLr_REzDC1kWTHX4SJWt7x+Zd1KwNvS1YGd5TVM1xA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1d12f846-bf89-7b0a-5c71-e61d83b1a36f@redhat.com>
Date:   Tue, 5 May 2020 19:02:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQYcLr_REzDC1kWTHX4SJWt7x+Zd1KwNvS1YGd5TVM1xA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/20 18:53, Jim Mattson wrote:
>>> Since this is becoming a generic API (good!!), maybe we can discuss
>>> possible ways to optimize gathering of stats in mass?
>> Sure, the idea of a binary format was considered from the beginning in
>> [1], and it can be done either together with the current filesystem, or
>> as a replacement via different mount options.
> 
> ASCII stats are not scalable. A binary format is definitely the way to go.

I am totally in favor of having a binary format, but it should be
introduced as a separate series on top of this one---and preferably by
someone who has already put some thought into the problem (which
Emanuele and I have not, beyond ensuring that the statsfs concept and
API is flexible enough).

ASCII stats are necessary for quick userspace consumption and for
backwards compatibility with KVM debugfs (which is not an ABI, but it's
damn useful and should not be dropped without providing something as
handy), so this is what this series starts from.

Paolo

