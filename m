Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F8F10E7AC
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 10:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfLBJbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 04:31:17 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24279 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726190AbfLBJbR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 04:31:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575279076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o/hoD+0u+dDjYhVpXJbZdoLaLC87tWFi3qSZzrNOkxw=;
        b=br29y0ks35M+nen2B6oFbnEmB/QZsGzHxU4EgtvQGSz/xHxT4FIT/MR2xUKw6wtFJbah3+
        4Hb/YRD5YpLE1c1fQYyqFGqg8ZmGXqrfSLe/ZVb6Hsw5Ph1J0o+corXU3Mxo6KjEY0WrBJ
        k3QrIljZBZTgyn9N/BV4ogroFmTd+HQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-RCPvgrAHNxSL5yamCs_fZA-1; Mon, 02 Dec 2019 04:31:14 -0500
Received: by mail-wr1-f70.google.com with SMTP id h7so20238816wrb.2
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 01:31:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o/hoD+0u+dDjYhVpXJbZdoLaLC87tWFi3qSZzrNOkxw=;
        b=FKFO16rUWFQ89mn/KCBihV/DRK1PuYnzwhDCPxxMXsHFAk2elAWvs++4rkcRF+j3Tw
         HFgTVG/ipZFgXqqGat3CrHTcauUyhd28UD6l10AmTE/qdk6/h7H6FYkEKWbyJ4uNMn+m
         hRq9nFUPQOUzp7BNCX/q0JDD/5sdiqJ7zXU+SLJjuyP5T0htKihBJBgRPf9bssclsvAf
         c4K6xd5dt0ydN8uOxtyGqX43DrbRKMDd/jhbqli1GnV/OzYZNhfPhuqzC+LS3jMmpetg
         ufWJPPD9qc0pn5PFvEAjPj5Pm/8cFij92snMCXV5Tph7MiyOuALLWySVU2J9v8ypkesf
         WM+g==
X-Gm-Message-State: APjAAAU5/zf/qBR/QP/Kw+AHRefikXcFWvMuKj/+dWCkMyKj9z0j6ll9
        jzJLx1IxHcqVro9yaxBxNuOTGsQwjB0a+JBI3w7NV6+H3cVkDXSK56FAR8+zH2XUTq2Ng/AEVms
        meAimIwGqbW6O
X-Received: by 2002:a5d:4386:: with SMTP id i6mr16291136wrq.63.1575279073718;
        Mon, 02 Dec 2019 01:31:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqw5myrgbwNLl5pT3XXiiksqesBdjxCxjdGPzI1YpHFrNJuwwlDLnrK8Sv65GeOFtay6Kohtvg==
X-Received: by 2002:a5d:4386:: with SMTP id i6mr16291105wrq.63.1575279073477;
        Mon, 02 Dec 2019 01:31:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id b63sm22032882wmb.40.2019.12.02.01.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2019 01:31:12 -0800 (PST)
Subject: Re: vfio_pin_map_dma cause synchronize_sched wait too long
To:     "Longpeng (Mike)" <longpeng2@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Longpeng(Mike)" <longpeng.mike@gmail.com>,
        Gonglei <arei.gonglei@huawei.com>,
        Huangzhichao <huangzhichao@huawei.com>
References: <2e53a9f0-3225-d416-98ff-55bd337330bc@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <34c53520-4144-fe71-528a-8df53e7f4dd1@redhat.com>
Date:   Mon, 2 Dec 2019 10:31:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <2e53a9f0-3225-d416-98ff-55bd337330bc@huawei.com>
Content-Language: en-US
X-MC-Unique: RCPvgrAHNxSL5yamCs_fZA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/19 10:10, Longpeng (Mike) wrote:
> 
> Suppose there're two VMs: VM1 is bind to node-0 and calling vfio_pin_map_dma(),
> VM2 is a migrate incoming VM which bind to node-1. We found the vm_start( QEMU
> function) of VM2 will take too long occasionally, the reason is as follow.

Which part of vfio_pin_map_dma is running?  There is already a
cond_resched in vfio_iommu_map.  Perhaps you could add one to
vfio_pin_pages_remote and/or use vfio_pgsize_bitmap to cap the number of
pages that it returns.

Paolo

