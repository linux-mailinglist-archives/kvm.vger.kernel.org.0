Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61AE3A2200
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 04:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhFJCCH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 22:02:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45283 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229634AbhFJCCG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 22:02:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623290410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+xQmp7fuwVh279E0Cth1KC9j6h3TM0sEtu/caMbRU18=;
        b=a5+CDxhG0+JHuvNib3mWW+zJ/qdjIWa+q9d+Rzw3uOOnUR5fhwZm31ZrvawGxyIjKcpc1q
        Ysx7FvqPcC8sGd8QZYqjVDi+1UVcNfeQ2V+eS7L74WbDxFkvYPW9gp7PUD7y6bjiPUHOd9
        se3AzCL84qRvihJctxIXTDpLv3GbNxg=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-WPeW1RiBOmWRwloNRRvFZg-1; Wed, 09 Jun 2021 22:00:08 -0400
X-MC-Unique: WPeW1RiBOmWRwloNRRvFZg-1
Received: by mail-pf1-f200.google.com with SMTP id l145-20020a6288970000b02902e9f6a5c2c3so294427pfd.3
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 19:00:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+xQmp7fuwVh279E0Cth1KC9j6h3TM0sEtu/caMbRU18=;
        b=ZBpEPdN33tELsZFtlfouhpuM+Sr72lsc3KSbYAR/P+f2fTcMZOvZj4hUbp7xBiZie+
         FPDAeMFHZ1Xogzs4i/10jaYyxDPqf+v9lr6rmeTvR4DF/bfLcxXuplBZwEPwCzqdVmPL
         bTkWl4Ao8V70Tj4GSEvYK3+AUz6wpXJ+YleYq2Ym84QKeA++bQ46t/AXS1kxg5naZycN
         Mh9OYzK2/ZpkDcZvh6mQETF2nqtDxa6rqAJcHl7qOWnp9bA5akZVRGANjYgHw/WDdQ9h
         nCK+nH/zBF10E8x6BgPqmJXAt1Kvhuy0zVSv+seCkRAUkmJ86rJVmig//10X7cKNCAYa
         9SNg==
X-Gm-Message-State: AOAM531M/70DYnn9yz9WVEHBL5Tem2EkfmgZnoEe3rqvNid/1vsaqpVn
        T863Pi4g0Y92du2qFZTya6Hj9uRYx+ZNocHfQCgb+kL9lFOaaGB0rhZmzdqwSothzYaT8RizFbz
        zntvgq790omuL
X-Received: by 2002:a17:90a:2f22:: with SMTP id s31mr743835pjd.62.1623290407727;
        Wed, 09 Jun 2021 19:00:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw65n4JwUpdZlyhZQm9k41Hm7KYINbBHKELAjIO4WceQeGIBYZlAZLwBtr5XPeJivWvj8g7kQ==
X-Received: by 2002:a17:90a:2f22:: with SMTP id s31mr743805pjd.62.1623290407512;
        Wed, 09 Jun 2021 19:00:07 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 11sm884327pge.57.2021.06.09.19.00.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 19:00:06 -0700 (PDT)
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
References: <64898584-a482-e6ac-fd71-23549368c508@linux.intel.com>
 <429d9c2f-3597-eb29-7764-fad3ec9a934f@redhat.com>
 <MWHPR11MB1886FC7A46837588254794048C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <05d7f790-870d-5551-1ced-86926a0aa1a6@redhat.com>
 <MWHPR11MB1886269E2B3DE471F1A9A7618C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <42a71462-1abc-0404-156c-60a7ee1ad333@redhat.com>
 <20210601173138.GM1002214@nvidia.com>
 <f69137e3-0f60-4f73-a0ff-8e57c79675d5@redhat.com>
 <20210602172154.GC1002214@nvidia.com>
 <c84787ec-9d8f-3198-e800-fe0dc8eb53c7@redhat.com>
 <20210608132039.GG1002214@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f4d70f28-4bd6-5315-d7c7-0a509e4f1d1d@redhat.com>
Date:   Thu, 10 Jun 2021 10:00:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210608132039.GG1002214@nvidia.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/6/8 ÏÂÎç9:20, Jason Gunthorpe Ð´µÀ:
> On Tue, Jun 08, 2021 at 09:10:42AM +0800, Jason Wang wrote:
>
>> Well, this sounds like a re-invention of io_uring which has already worked
>> for multifds.
> How so? io_uring is about sending work to the kernel, not getting
> structued events back?


Actually it can. Userspace can poll multiple fds via preparing multiple 
sqes with IORING_OP_ADD flag.


>
> It is more like one of the perf rings


This means another ring and we need introduce ioctl() to add or remove 
ioasids from the poll. And it still need a kind of fallback like a list 
if the ring is full.

Thanks


>
> Jason
>

