Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71BA33984A5
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 10:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhFBI4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 04:56:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22323 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229959AbhFBI4R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 04:56:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622624074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TOI6E9j/kLUqqLzfWVG9w8giJlysUj5C+KWef8bCQ8I=;
        b=iey3U79HA+VvTZDpvn1WzZuVy5l3v5TtkaaFIzHe2il5HHOOGPHzbDXGtiQDNBsOFN19sO
        mNTCWKrpE+y6XmGPFu41oA/AWk/aqGo8VO6vkp0q+3NJdCwM6Iezl+7WPJ+YfRIsxQXClb
        E0mOrFzHtGAgKY6sPrOW8RlG6yeWu6k=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-crJ3WZQkN7OnZAcNfywdJg-1; Wed, 02 Jun 2021 04:54:33 -0400
X-MC-Unique: crJ3WZQkN7OnZAcNfywdJg-1
Received: by mail-pj1-f70.google.com with SMTP id o1-20020a17090a4201b029015c8f11f550so3021510pjg.5
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 01:54:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TOI6E9j/kLUqqLzfWVG9w8giJlysUj5C+KWef8bCQ8I=;
        b=VLlT80TUVbTt/NNew7xDhDQneGDHwqaNAFMh2wREZy/DS5sBKcIGJiY7H10lzrCmiM
         yZ1/XXBYrI9kL8jCuzPXBi9mQKUrm3n7D/+oa1rrfdiDNZC68nwWMvnu0Rs2xN4vSanq
         bZ6y19M5hI7yU+scSh7sRm2rhDD1x1LOPFH8ylhldovvdZmwu8xHDFpFCCgrkAqMGV9i
         9kueL5ThR4UgjK3DQgSca1o5PmSZylcWNIntomB1Gngu2KcTV9tN0qkhLgAb+RWfy06c
         2NNZjfBknYxQjoDLmETgyO+9y4oi5c29ByH1FAmX/ddUum3wTrRdVRuYDcyJU9umMyZ5
         GBMQ==
X-Gm-Message-State: AOAM530L8RQ4dsEwrSR/JvDmacBZ7/fRJhVpEIyzx61peOWc2LvHf0DP
        DlDc/YgbP4N9u3e0CqZUKLj7aD1ilr4xgG8aTaBjGhkvhg1bCrE6OMFCon3TqfjnEebc1Rf1ukj
        NPrNdapdF9RFe
X-Received: by 2002:a17:90a:7306:: with SMTP id m6mr4486585pjk.217.1622624072029;
        Wed, 02 Jun 2021 01:54:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQ9jinHicYAMXd7FQEuh3El0Ofh9v6RECp7TK6Os2FVDpLb1bDFUCefzQjoGn2stvAL6/t8g==
X-Received: by 2002:a17:90a:7306:: with SMTP id m6mr4486565pjk.217.1622624071836;
        Wed, 02 Jun 2021 01:54:31 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w2sm4060045pfc.126.2021.06.02.01.54.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 01:54:31 -0700 (PDT)
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Liu Yi L <yi.l.liu@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)\"\"" 
        <alex.williamson@redhat.com>, David Woodhouse <dwmw2@infradead.org>
References: <20210531164118.265789ee@yiliu-dev>
 <78ee2638-1a03-fcc8-50a5-81040f677e69@redhat.com>
 <20210601113152.6d09e47b@yiliu-dev>
 <164ee532-17b0-e180-81d3-12d49b82ac9f@redhat.com>
 <64898584-a482-e6ac-fd71-23549368c508@linux.intel.com>
 <429d9c2f-3597-eb29-7764-fad3ec9a934f@redhat.com>
 <MWHPR11MB1886FC7A46837588254794048C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <05d7f790-870d-5551-1ced-86926a0aa1a6@redhat.com>
 <MWHPR11MB1886269E2B3DE471F1A9A7618C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <42a71462-1abc-0404-156c-60a7ee1ad333@redhat.com>
 <20210601173138.GM1002214@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f69137e3-0f60-4f73-a0ff-8e57c79675d5@redhat.com>
Date:   Wed, 2 Jun 2021 16:54:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210601173138.GM1002214@nvidia.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/6/2 ÉÏÎç1:31, Jason Gunthorpe Ð´µÀ:
> On Tue, Jun 01, 2021 at 04:47:15PM +0800, Jason Wang wrote:
>   
>> We can open up to ~0U file descriptors, I don't see why we need to restrict
>> it in uAPI.
> There are significant problems with such large file descriptor
> tables. High FD numbers man things like select don't work at all
> anymore and IIRC there are more complications.


I don't see how much difference for IOASID and other type of fds. People 
can choose to use poll or epoll.

And with the current proposal, (assuming there's a N:1 ioasid to 
ioasid). I wonder how select can work for the specific ioasid.

Thanks


>
> A huge number of FDs for typical usages should be avoided.
>
> Jason
>

