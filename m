Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5A439EB3B
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 03:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhFHBMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 21:12:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57984 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230314AbhFHBMr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 21:12:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623114654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ble1OdVWSdUFgnj3SJybSz6FbcPfrGdp/yR5UPi1dnM=;
        b=AGe7Fw91N1N6Q9oa+tcu78UcGYNg4ht+CpaAlYW6REyw25JrB4NW5BROsVqDwwDz/9IJOz
        yLyftKoO3r/Egxi1AP0jiqPYh7Y/1kQ4//ag0tQ2BFNXKn+Hq13IYaZD7Fi/IL3W1BNF+A
        UaCtiVFLanXtrmgMoPLhqrFYl8Cfe7E=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-OMORsP7hOCmLG_-Fssrn1A-1; Mon, 07 Jun 2021 21:10:53 -0400
X-MC-Unique: OMORsP7hOCmLG_-Fssrn1A-1
Received: by mail-pf1-f200.google.com with SMTP id k22-20020aa788d60000b02902ec984951ffso3898080pff.11
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 18:10:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Ble1OdVWSdUFgnj3SJybSz6FbcPfrGdp/yR5UPi1dnM=;
        b=HRnTnzorX+hrPnLKJqbpIEiMEzKoHLuCTHH4Kg4jMEBasnr49M9+kq0RDuGzEB5wsc
         tDnjgznQXR68hdxn2ALUuNRznMDLyrzCWhidvcg//2+uZbzBsx650/XisIbrlGHebNZD
         OI5S24+dSn53WNSKpgdTjVynndCheyIkxKk5F+FUpErMBnP/3Uvgs783pB0Dh2bWz0A0
         cnG/Ggzhdq7/n9mn4kDkRZD0szYg/0oDH5pjqu7593LrNKfedSUT5WvPamXy0vCKdcqp
         Op6HG6NnKzr5U8I3QhiTXlfqk3I0fZLZL8slDr/sXTL/NfKJhLe7EoC7Vnfh9b/jd1I4
         +/Xw==
X-Gm-Message-State: AOAM530e+GIno5h5lLwGz6naYgx/ntW+g13N5F0aMJ7Yezza+Xbj9WRf
        Loyvm01oay8bddPsXe4nIc4ni/PiWI7Y2nvESSj3bG3cU/Ufy9gZg7DPzmSy66uvAz0LZlI95k7
        1wUDMsK1ZdDNY
X-Received: by 2002:a17:90b:318:: with SMTP id ay24mr23612461pjb.175.1623114652573;
        Mon, 07 Jun 2021 18:10:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx253KrivISywGLROa5WGmZPzIUrrh3/ViJVkQze+aUvfxcfFXPOZCDpYA7zhgges937Rhj+Q==
X-Received: by 2002:a17:90b:318:: with SMTP id ay24mr23612437pjb.175.1623114652306;
        Mon, 07 Jun 2021 18:10:52 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c5sm6947662pfn.144.2021.06.07.18.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 18:10:51 -0700 (PDT)
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
References: <20210601113152.6d09e47b@yiliu-dev>
 <164ee532-17b0-e180-81d3-12d49b82ac9f@redhat.com>
 <64898584-a482-e6ac-fd71-23549368c508@linux.intel.com>
 <429d9c2f-3597-eb29-7764-fad3ec9a934f@redhat.com>
 <MWHPR11MB1886FC7A46837588254794048C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <05d7f790-870d-5551-1ced-86926a0aa1a6@redhat.com>
 <MWHPR11MB1886269E2B3DE471F1A9A7618C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <42a71462-1abc-0404-156c-60a7ee1ad333@redhat.com>
 <20210601173138.GM1002214@nvidia.com>
 <f69137e3-0f60-4f73-a0ff-8e57c79675d5@redhat.com>
 <20210602172154.GC1002214@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c84787ec-9d8f-3198-e800-fe0dc8eb53c7@redhat.com>
Date:   Tue, 8 Jun 2021 09:10:42 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210602172154.GC1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/6/3 上午1:21, Jason Gunthorpe 写道:
> On Wed, Jun 02, 2021 at 04:54:26PM +0800, Jason Wang wrote:
>> 在 2021/6/2 上午1:31, Jason Gunthorpe 写道:
>>> On Tue, Jun 01, 2021 at 04:47:15PM +0800, Jason Wang wrote:
>>>> We can open up to ~0U file descriptors, I don't see why we need to restrict
>>>> it in uAPI.
>>> There are significant problems with such large file descriptor
>>> tables. High FD numbers man things like select don't work at all
>>> anymore and IIRC there are more complications.
>>
>> I don't see how much difference for IOASID and other type of fds. People can
>> choose to use poll or epoll.
> Not really, once one thing in an applicate uses a large number FDs the
> entire application is effected. If any open() can return 'very big
> number' then nothing in the process is allowed to ever use select.
>
> It is not a trivial thing to ask for
>
>> And with the current proposal, (assuming there's a N:1 ioasid to ioasid). I
>> wonder how select can work for the specific ioasid.
> pagefault events are one thing that comes to mind. Bundling them all
> together into a single ring buffer is going to be necessary. Multifds
> just complicate this too
>
> Jason


Well, this sounds like a re-invention of io_uring which has already 
worked for multifds.

Thanks


