Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F54B3A3B74
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 07:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhFKFqJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 01:46:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51971 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230370AbhFKFqI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 01:46:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623390250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5nlidzY7vVox2ieeNTmLbeG44JwkLPe3MMhpIq19x6g=;
        b=LOiTUDx60R9wOz9sP1ZGZtlwFXZen6zjRQvWMitayuXLMNIcTLGlDvaUF3WVODXI8I35q7
        iC5GJros2ztPy4IZuHHeOWvIAZPoIshMuJIs4cISIPcMr8QCZIZeoMxJ19vNCCOGDXS0aU
        rlpnURci5sjJN8MvfCzJQE+fbqDvKZ0=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-_AqdL-B3P-KDqQAaR0ll4g-1; Fri, 11 Jun 2021 01:44:09 -0400
X-MC-Unique: _AqdL-B3P-KDqQAaR0ll4g-1
Received: by mail-pg1-f200.google.com with SMTP id 17-20020a630b110000b029022064e7cdcfso1103245pgl.10
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 22:44:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5nlidzY7vVox2ieeNTmLbeG44JwkLPe3MMhpIq19x6g=;
        b=Ng473mkjMXgqgHeAq3m0UvkhPezDOvkUZxLuaLjyfAzoAYkXcnkV/VLHYo/ekACkVR
         NqYU2U49qPNdX8UEZMy2C3/CmQjLaUsUINgKo1f0SpForKgJWNrm5knuqgOf1Ze8xfTu
         /puVnm7YSdP4iJrP84gcYODRnci9FjH2IWRQ8qD8+SHPO2mzTwZnPB4wWpG1HfxgnOQb
         zsFm76jnNhhoD7/u057G9fre2ZL/Iluzb13wgWr9WZR109je1X1SuNbfrPHWhOlsEfuL
         Cu91EjjJDKVvqVCj3obIoZYicbDVpfbcFI2g6N/RnIi+F7fzG8FcHGK1nx68Kp7IoPeP
         1/1w==
X-Gm-Message-State: AOAM531kmhBsNg/xqI4AOoF6xVAxK3CFcc5hkk7tjVS1Eiu4ZJHRcIFM
        plgz7HC5CjR7IC9WKa1/+rPTpVH0XqVyjPQQCTbpRmCAc6uyZsdT8yNvsy2wTGPi6jgjg2xhNEB
        2BbAjsmEeTh1i
X-Received: by 2002:a63:6547:: with SMTP id z68mr1935902pgb.341.1623390248323;
        Thu, 10 Jun 2021 22:44:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKB65M93ciDtRjp4dLL7boO1gINllpJ4guVwZKP5dhsZp4Ljb4TFphg7Htp0BodlrU9JnK0w==
X-Received: by 2002:a63:6547:: with SMTP id z68mr1935883pgb.341.1623390248048;
        Thu, 10 Jun 2021 22:44:08 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d8sm4085729pfq.198.2021.06.10.22.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 22:44:07 -0700 (PDT)
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
References: <MWHPR11MB1886FC7A46837588254794048C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <05d7f790-870d-5551-1ced-86926a0aa1a6@redhat.com>
 <MWHPR11MB1886269E2B3DE471F1A9A7618C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <42a71462-1abc-0404-156c-60a7ee1ad333@redhat.com>
 <20210601173138.GM1002214@nvidia.com>
 <f69137e3-0f60-4f73-a0ff-8e57c79675d5@redhat.com>
 <20210602172154.GC1002214@nvidia.com>
 <c84787ec-9d8f-3198-e800-fe0dc8eb53c7@redhat.com>
 <20210608132039.GG1002214@nvidia.com>
 <f4d70f28-4bd6-5315-d7c7-0a509e4f1d1d@redhat.com>
 <20210610114751.GK1002214@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d2193dbd-0d55-7315-4e76-eea7f8cc8f5b@redhat.com>
Date:   Fri, 11 Jun 2021 13:43:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210610114751.GK1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/6/10 下午7:47, Jason Gunthorpe 写道:
> On Thu, Jun 10, 2021 at 10:00:01AM +0800, Jason Wang wrote:
>> 在 2021/6/8 下午9:20, Jason Gunthorpe 写道:
>>> On Tue, Jun 08, 2021 at 09:10:42AM +0800, Jason Wang wrote:
>>>
>>>> Well, this sounds like a re-invention of io_uring which has already worked
>>>> for multifds.
>>> How so? io_uring is about sending work to the kernel, not getting
>>> structued events back?
>>
>> Actually it can. Userspace can poll multiple fds via preparing multiple sqes
>> with IORING_OP_ADD flag.
> Poll is only a part of what is needed here, the main issue is
> transfering the PRI events to userspace quickly.


Do we really care e.g at most one more syscall in this case? I think the 
time spent on demand paging is much more than transferring #PF to 
userspace. What's more, a well designed vIOMMU capable IOMMU hardware 
should have the ability to inject such event directly to guest if #PF 
happens on L1.


>
>> This means another ring and we need introduce ioctl() to add or remove
>> ioasids from the poll. And it still need a kind of fallback like a list if
>> the ring is full.
> The max size of the ring should be determinable based on the PRI
> concurrance of each device and the number of devices sharing the ring


This has at least one assumption, #PF event is the only event for the 
ring, I'm not sure this is the case.

Thanks


>
> In any event, I'm not entirely convinced eliding the PRI user/kernel
> copy is the main issue here.. If we want this to be low latency I
> think it ends up with some kernel driver component assisting the
> vIOMMU emulation and avoiding the round trip to userspace
>
> Jason
>

