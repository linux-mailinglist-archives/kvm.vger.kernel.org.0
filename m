Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565743A2234
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 04:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhFJCS3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 22:18:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25582 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229557AbhFJCS1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 22:18:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623291391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NnaUokRoNM6Q2FbT2TvIPzJXqmr5yWwj9gPCdPyZQmw=;
        b=acHl2IrkP8FXvHOBYUSrLuFY4278K3gD+L939k2a2VK8+9TzC6WP/9KgOulVW0TtqDY/mh
        8qtuGU/kJ2uCLj6xSbVS3854lk0yWJns5tqYnQGi9jNdKE92/Fnkls1OlVVNWt1NmuHQlL
        DFkZCo/lLLZ3zxyCc7KvcZs8jruxzm0=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-X0ve6lS8PPuwlmlaP3fiAw-1; Wed, 09 Jun 2021 22:16:30 -0400
X-MC-Unique: X0ve6lS8PPuwlmlaP3fiAw-1
Received: by mail-pj1-f69.google.com with SMTP id w12-20020a17090a528cb029015d7f990752so2873094pjh.0
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 19:16:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=NnaUokRoNM6Q2FbT2TvIPzJXqmr5yWwj9gPCdPyZQmw=;
        b=KB/2fFKQqESLfijlyy1H7g5/521w/L2KD5HMfp/skwokoSz78uHwUID3CCiWRWYnv2
         WGhPZUNBQC7/t0m8Uofnz7bNsyzUzocmbTvhzPxC7gRwA+iO3vlQx6vERbJbtSblT/CS
         CStR8aySbVHS4IfEtL7wEBfnsR1O/rOEzQG99T0JWU9fsJpVftVAsNsnkeNeC0VAqjoI
         /so3Dr4egVy/JQ+SUYTU51Z/JkyatupvjLBULGh9PqSg0IImjKwiajLUMz3y70M63Hrx
         GLPevq7IUi92JrqohURslgSdyMsgCzo0eP6cbQfLF/wjctcVuqi/Gx8Hso9fP+P2gMJv
         jz4A==
X-Gm-Message-State: AOAM532bfm/R8R4Seo4bDQjM6gFMlwB2Cc/fs5xzv9bXuYjoMPL5qIAJ
        Jb9TYAF2sskFkMZs+mbe4ICIm5w3JZlenUkjF929JVZxnzBdnUmMIS45JLyO98l/VYequ48C9Y2
        rN0gIQ75Ydjf+
X-Received: by 2002:a63:4814:: with SMTP id v20mr2691503pga.8.1623291389544;
        Wed, 09 Jun 2021 19:16:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGFH3+Zi1qg8fLvGeVh2H1tnJw2kTEQ1WuxGNYkVj+kLoxCEbUmdaVO29Ee6FLnMdfVVUCXA==
X-Received: by 2002:a63:4814:: with SMTP id v20mr2691486pga.8.1623291389293;
        Wed, 09 Jun 2021 19:16:29 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b14sm889674pgl.52.2021.06.09.19.16.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 19:16:28 -0700 (PDT)
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Liu Yi L <yi.l.liu@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)\"\"" 
        <alex.williamson@redhat.com>, David Woodhouse <dwmw2@infradead.org>
References: <64898584-a482-e6ac-fd71-23549368c508@linux.intel.com>
 <429d9c2f-3597-eb29-7764-fad3ec9a934f@redhat.com>
 <MWHPR11MB1886FC7A46837588254794048C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <05d7f790-870d-5551-1ced-86926a0aa1a6@redhat.com>
 <MWHPR11MB1886269E2B3DE471F1A9A7618C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <42a71462-1abc-0404-156c-60a7ee1ad333@redhat.com>
 <20210601173138.GM1002214@nvidia.com>
 <f69137e3-0f60-4f73-a0ff-8e57c79675d5@redhat.com>
 <20210602172154.GC1002214@nvidia.com>
 <51e060a3-fc59-0a13-5955-71692b14eed8@metux.net>
 <20210607180144.GL1002214@nvidia.com>
 <633b00c1-b388-856a-db71-8d74e52c2702@metux.net>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0f9224eb-2158-4769-f709-6e8f56c24bd3@redhat.com>
Date:   Thu, 10 Jun 2021 10:16:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <633b00c1-b388-856a-db71-8d74e52c2702@metux.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/6/8 下午6:45, Enrico Weigelt, metux IT consult 写道:
> On 07.06.21 20:01, Jason Gunthorpe wrote:
>> <shrug> it is what it is, select has a fixed size bitmap of FD #s and
>> a hard upper bound on that size as part of the glibc ABI - can't be
>> fixed.
>
> in glibc ABI ? Uuuuh!
>

Note that dealing with select() or try to overcome the limitation via 
epoll() directly via the application is not a good practice (or it's not 
portable).

It's suggested to use building blocks provided by glib, e.g the main 
event loop[1]. That is how Qemu solve the issues of dealing with a lot 
of file descriptors.

Thanks

[1] https://developer.gnome.org/glib/stable/glib-The-Main-Event-Loop.html


>
> --mtx
>

