Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA84396D1F
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 08:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhFAGI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 02:08:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229477AbhFAGI6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 02:08:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622527637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WBtT6QfhiDgonj2vvLPkT9r7vtcFNwuVXyhZCxDQcFk=;
        b=g3QgaCw5HTnjmQFssW/gZqX/BdxT0PiPrInkzqb5sDFCrlZW/UeDGH6QYMkAJzZSfUbhHC
        56mj8tPmO1GnMd1xQ9AIwflyXoIKdg18G7XVDGza8kx41G5M1pjk7cDnA+OMq+o+ccdix9
        np7eeJfiaqV8rO/jl/rZd7wDFV8JtuI=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-9agc_9_8O_eiwElr-L92Zw-1; Tue, 01 Jun 2021 02:07:16 -0400
X-MC-Unique: 9agc_9_8O_eiwElr-L92Zw-1
Received: by mail-pg1-f200.google.com with SMTP id 15-20020a630c4f0000b029021a6da9af28so8271958pgm.22
        for <kvm@vger.kernel.org>; Mon, 31 May 2021 23:07:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=WBtT6QfhiDgonj2vvLPkT9r7vtcFNwuVXyhZCxDQcFk=;
        b=f14d2Q42YaX/9e4vBhNbOnEAJzk05vxH1C9ckCwbcCnl6FbEN4iI8HaCsZTQ7W6QCc
         x3jz4RACxYloNaXIvxYsNj2qBHl7k/4fwhclOrzukuQDiBNhuldKw/WJXWwD3tiDyctU
         lcA6eVDrM+hm+d21lZb1tdVvADemv8UB6ki7uKuPzahaxcm/ECVd3GW1JyROFApPJxAg
         dwtE9rvf+UoHR9pAli39celzCr4LA4sRDG4lFogYp/88/CxQ4B/tOteHwkqgySkaHiB/
         7X0VnW80yW8nHRrE1kvHzQ2WNeO1KA8EMA3VoCB73dEiIlSTbYXs1SnFgY6/i4TcD5QY
         X3JA==
X-Gm-Message-State: AOAM533qcdT2CCxv30VRV+B0iUjojRji5ZpPj+HjfjQFuLeJ5v5WLrpt
        y9dxHQEk7lhBo9gjzOtx3F8u232U2HZ0QwpySWW7bSVQ/31NKKOjFcigHDGMs7j7V0KgvKzYkg3
        Pz6mkIAYph05Q
X-Received: by 2002:a62:1856:0:b029:2e9:c6ef:3b34 with SMTP id 83-20020a6218560000b02902e9c6ef3b34mr10235743pfy.65.1622527635282;
        Mon, 31 May 2021 23:07:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy061Dy19iHLayhC8IX/sic1Xj79JCDr5oreU6IxvFEXjUpr+lVQ790JMBSTMUZPvKcvJ5VZQ==
X-Received: by 2002:a62:1856:0:b029:2e9:c6ef:3b34 with SMTP id 83-20020a6218560000b02902e9c6ef3b34mr10235727pfy.65.1622527635026;
        Mon, 31 May 2021 23:07:15 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 25sm12058529pfh.39.2021.05.31.23.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 23:07:14 -0700 (PDT)
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Liu Yi L <yi.l.liu@linux.intel.com>
Cc:     "Alex Williamson (alex.williamson@redhat.com)\"\"" 
        <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <f510f916-e91c-236d-e938-513a5992d3b5@redhat.com>
 <20210531164118.265789ee@yiliu-dev>
 <78ee2638-1a03-fcc8-50a5-81040f677e69@redhat.com>
 <20210601113152.6d09e47b@yiliu-dev>
 <164ee532-17b0-e180-81d3-12d49b82ac9f@redhat.com>
 <64898584-a482-e6ac-fd71-23549368c508@linux.intel.com>
 <429d9c2f-3597-eb29-7764-fad3ec9a934f@redhat.com>
 <MWHPR11MB1886FC7A46837588254794048C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <05d7f790-870d-5551-1ced-86926a0aa1a6@redhat.com>
Date:   Tue, 1 Jun 2021 14:07:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB1886FC7A46837588254794048C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/6/1 下午1:42, Tian, Kevin 写道:
>> From: Jason Wang
>> Sent: Tuesday, June 1, 2021 1:30 PM
>>
>> 在 2021/6/1 下午1:23, Lu Baolu 写道:
>>> Hi Jason W,
>>>
>>> On 6/1/21 1:08 PM, Jason Wang wrote:
>>>>>> 2) If yes, what's the reason for not simply use the fd opened from
>>>>>> /dev/ioas. (This is the question that is not answered) and what
>>>>>> happens
>>>>>> if we call GET_INFO for the ioasid_fd?
>>>>>> 3) If not, how GET_INFO work?
>>>>> oh, missed this question in prior reply. Personally, no special reason
>>>>> yet. But using ID may give us opportunity to customize the management
>>>>> of the handle. For one, better lookup efficiency by using xarray to
>>>>> store the allocated IDs. For two, could categorize the allocated IDs
>>>>> (parent or nested). GET_INFO just works with an input FD and an ID.
>>>>
>>>> I'm not sure I get this, for nesting cases you can still make the
>>>> child an fd.
>>>>
>>>> And a question still, under what case we need to create multiple
>>>> ioasids on a single ioasid fd?
>>> One possible situation where multiple IOASIDs per FD could be used is
>>> that devices with different underlying IOMMU capabilities are sharing a
>>> single FD. In this case, only devices with consistent underlying IOMMU
>>> capabilities could be put in an IOASID and multiple IOASIDs per FD could
>>> be applied.
>>>
>>> Though, I still not sure about "multiple IOASID per-FD" vs "multiple
>>> IOASID FDs" for such case.
>>
>> Right, that's exactly my question. The latter seems much more easier to
>> be understood and implemented.
>>
> A simple reason discussed in previous thread - there could be 1M's
> I/O address spaces per device while #FD's are precious resource.


Is the concern for ulimit or performance? Note that we had

#define NR_OPEN_MAX ~0U

And with the fd semantic, you can do a lot of other stuffs: close on 
exec, passing via SCM_RIGHTS.

For the case of 1M, I would like to know what's the use case for a 
single process to handle 1M+ address spaces?


> So this RFC treats fd as a container of address spaces which is each
> tagged by an IOASID.


If the container and address space is 1:1 then the container seems useless.

Thanks


>
> Thanks
> Kevin

