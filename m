Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01425396CCE
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 07:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhFAFb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 01:31:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232770AbhFAFbz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 01:31:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622525393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=siJz2CTmBAQXJpnvED6F5Lh0Z4do04zZE0SUG5Fvo2s=;
        b=ZZ2Gs+WAwGUw4hJSrtGoi8pFBeenRUCZil/IUzcdrozKK0LSvAz/CqeIN+kKwLkFYc5qDY
        0x8/5YfX9+mWPuaWy59Ksgq7ANoc4AQYyo4dS426j21J6l5x/1EVuQq5hMf/rsS8io6Cla
        d2C8xtBN0BN5tzdqL95wQpbc89LhBKM=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-6oru2BFGMHOuVbw9IwQsKg-1; Tue, 01 Jun 2021 01:29:49 -0400
X-MC-Unique: 6oru2BFGMHOuVbw9IwQsKg-1
Received: by mail-pl1-f199.google.com with SMTP id d13-20020a170903208db0290107a6d5fc80so630337plc.16
        for <kvm@vger.kernel.org>; Mon, 31 May 2021 22:29:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=siJz2CTmBAQXJpnvED6F5Lh0Z4do04zZE0SUG5Fvo2s=;
        b=ECeBZjy34hZYlFLAgpQcDlEBsCkbGCh/26Peil7Stc+yVePXhu98q2K4DCcSZhPe9d
         P6bmw5XSZtZYFxMlSGbG+8IKxuxMeSf9lY7Ku5FvRvzsX5AECJTutnHB0tIr+f0gbe3c
         Uyzno7yA4j4ZFdBlffMBZourk/6GS8iW2mmXDzOXIUCPlMAmf1LrAgDtwLrI0eNvnNr9
         K7Jk1BsgW/oxPyDoKYUv2JAQkVXMSbd/CCZSYgMsEfT4fFf7+U0fc7PyP7pYKJZWq7ua
         23M5xhI8yTkL2GjdDHaLGCPiJiC2YFv5CWSp7W50oXNY7BmhuUA73VuNQX5nIp7DvVXH
         ExcQ==
X-Gm-Message-State: AOAM53228hQdjMjE32/W0c5tJu95TOEwNFtAJ1gGcqjoIQFqb8NxXLem
        9SQAKZUAsBi2DUyH0VY2FQrT2I9Bp6qr2iu7m2qznX+ob2HTPr3ksSfU29JLXsy7KWHWUvVwCBQ
        kMsLvmIIurAj8
X-Received: by 2002:a17:90a:4d0a:: with SMTP id c10mr2950614pjg.206.1622525388810;
        Mon, 31 May 2021 22:29:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZ7rHezJVl5toCxwphy2EqgUV3yr26yAhv4PAH3egfoOPVMm51yn71ZSBxAm52zcWBKyM7sw==
X-Received: by 2002:a17:90a:4d0a:: with SMTP id c10mr2950597pjg.206.1622525388516;
        Mon, 31 May 2021 22:29:48 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y20sm12198235pfn.164.2021.05.31.22.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 22:29:48 -0700 (PDT)
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Liu Yi L <yi.l.liu@linux.intel.com>
Cc:     yi.l.liu@intel.com, "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)\"\"" 
        <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <f510f916-e91c-236d-e938-513a5992d3b5@redhat.com>
 <20210531164118.265789ee@yiliu-dev>
 <78ee2638-1a03-fcc8-50a5-81040f677e69@redhat.com>
 <20210601113152.6d09e47b@yiliu-dev>
 <164ee532-17b0-e180-81d3-12d49b82ac9f@redhat.com>
 <64898584-a482-e6ac-fd71-23549368c508@linux.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <429d9c2f-3597-eb29-7764-fad3ec9a934f@redhat.com>
Date:   Tue, 1 Jun 2021 13:29:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <64898584-a482-e6ac-fd71-23549368c508@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/6/1 下午1:23, Lu Baolu 写道:
> Hi Jason W,
>
> On 6/1/21 1:08 PM, Jason Wang wrote:
>>>> 2) If yes, what's the reason for not simply use the fd opened from
>>>> /dev/ioas. (This is the question that is not answered) and what 
>>>> happens
>>>> if we call GET_INFO for the ioasid_fd?
>>>> 3) If not, how GET_INFO work?
>>> oh, missed this question in prior reply. Personally, no special reason
>>> yet. But using ID may give us opportunity to customize the management
>>> of the handle. For one, better lookup efficiency by using xarray to
>>> store the allocated IDs. For two, could categorize the allocated IDs
>>> (parent or nested). GET_INFO just works with an input FD and an ID.
>>
>>
>> I'm not sure I get this, for nesting cases you can still make the 
>> child an fd.
>>
>> And a question still, under what case we need to create multiple 
>> ioasids on a single ioasid fd?
>
> One possible situation where multiple IOASIDs per FD could be used is
> that devices with different underlying IOMMU capabilities are sharing a
> single FD. In this case, only devices with consistent underlying IOMMU
> capabilities could be put in an IOASID and multiple IOASIDs per FD could
> be applied.
>
> Though, I still not sure about "multiple IOASID per-FD" vs "multiple
> IOASID FDs" for such case.


Right, that's exactly my question. The latter seems much more easier to 
be understood and implemented.

Thanks


>
> Best regards,
> baolu
>

