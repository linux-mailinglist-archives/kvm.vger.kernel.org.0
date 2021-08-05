Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF8F3E15B6
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 15:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241692AbhHENcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 09:32:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54789 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237982AbhHENcJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 09:32:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628170315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KFeFt1ww8WzoDvTA8B4ID/THa1sBrEwi6JiSRoox5oM=;
        b=UYNe/jicwMop7jWFr8j3AEnGB1jlLJmLNLel8lHczjZGBudnlDBRcMMaLJ5BdrSYphVBad
        coEPIY1VjClyve620cm55Ufb5xdLNlqrK3uimJA1tPcXt9DoXYFPuvbWJXNB5SRnvj6W0H
        AWFnokaf0gfNVaPDr8W0y3cNWuIuvvA=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-EJMmBF0SMq26ydKTbVi7IA-1; Thu, 05 Aug 2021 09:31:54 -0400
X-MC-Unique: EJMmBF0SMq26ydKTbVi7IA-1
Received: by mail-pj1-f72.google.com with SMTP id q63-20020a17090a17c5b02901774f4b30ebso5715840pja.1
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 06:31:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=KFeFt1ww8WzoDvTA8B4ID/THa1sBrEwi6JiSRoox5oM=;
        b=QN032FpqragOMPFsojIqdgzp6aukhIjzd81LHLeJcEUmvuZS1i8tDq32lG++sxJf6F
         xJtIZILfNJKLKvwGr90UlBrq7VT5cD7Bsre4liqb5TaHZpfHZHes2GkRETFhb8MVYj6z
         NOwU+CMlp9VfDgQGALa8OpyqLWHAdEdG7RCWB5ttzia4BuUUdxDlEIzat5Un1xTZI6ZR
         +x07Hbag1HzFEzYoN2qW59sIgg+D/YyupzwuAiW9E7eT4oLguw4Up1/Hs4RgRhkI4wm0
         TxKYv+q7PL5wEh5wNZAMITsxdbn1rBfQ7mOk8wU8ib/xLnxaFWmr+aCpa6YV9XkR0h+K
         ewag==
X-Gm-Message-State: AOAM531sm6U5oATYA6mbc2iHWGvwnqQqcdb5qpiCxG/W7poUwPHHX4Tv
        jcOYKPX6IUY75oN9UrJB+Inw2moChe5KVXdWYz6v2t/zMii0wP+f0dq/NDpEkL3d21Itlp8a9U+
        Y5nrjTefsss+E
X-Received: by 2002:a65:610c:: with SMTP id z12mr612914pgu.453.1628170312974;
        Thu, 05 Aug 2021 06:31:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweBq6SSyDD2nP+XrrpaLsd2Knf9rcBqrsnAXcXPB8geZ/AllW4llVpLKWNfVfqwtMjCV4ZTA==
X-Received: by 2002:a65:610c:: with SMTP id z12mr612875pgu.453.1628170312586;
        Thu, 05 Aug 2021 06:31:52 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y67sm6867035pfg.218.2021.08.05.06.31.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 06:31:52 -0700 (PDT)
Subject: Re: [PATCH v10 01/17] iova: Export alloc_iova_fast() and
 free_iova_fast()
To:     Yongji Xie <xieyongji@bytedance.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        songmuchun@bytedance.com, Jens Axboe <axboe@kernel.dk>,
        He Zhe <zhe.he@windriver.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, bcrl@kvack.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
References: <20210729073503.187-1-xieyongji@bytedance.com>
 <20210729073503.187-2-xieyongji@bytedance.com>
 <43d88942-1cd3-c840-6fec-4155fd544d80@redhat.com>
 <CACycT3vcpwyA3xjD29f1hGnYALyAd=-XcWp8+wJiwSqpqUu00w@mail.gmail.com>
 <6e05e25e-e569-402e-d81b-8ac2cff1c0e8@arm.com>
 <CACycT3sm2r8NMMUPy1k1PuSZZ3nM9aic-O4AhdmRRCwgmwGj4Q@mail.gmail.com>
 <417ce5af-4deb-5319-78ce-b74fb4dd0582@arm.com>
 <CACycT3vARzvd4-dkZhDHqUkeYoSxTa2ty0z0ivE1znGti+n1-g@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8c381d3d-9bbd-73d6-9733-0f0b15c40820@redhat.com>
Date:   Thu, 5 Aug 2021 21:31:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CACycT3vARzvd4-dkZhDHqUkeYoSxTa2ty0z0ivE1znGti+n1-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/8/5 下午8:34, Yongji Xie 写道:
>> My main point, though, is that if you've already got something else
>> keeping track of the actual addresses, then the way you're using an
>> iova_domain appears to be something you could do with a trivial bitmap
>> allocator. That's why I don't buy the efficiency argument. The main
>> design points of the IOVA allocator are to manage large address spaces
>> while trying to maximise spatial locality to minimise the underlying
>> pagetable usage, and allocating with a flexible limit to support
>> multiple devices with different addressing capabilities in the same
>> address space. If none of those aspects are relevant to the use-case -
>> which AFAICS appears to be true here - then as a general-purpose
>> resource allocator it's rubbish and has an unreasonably massive memory
>> overhead and there are many, many better choices.
>>
> OK, I get your point. Actually we used the genpool allocator in the
> early version. Maybe we can fall back to using it.


I think maybe you can share some perf numbers to see how much 
alloc_iova_fast() can help.

Thanks


>

