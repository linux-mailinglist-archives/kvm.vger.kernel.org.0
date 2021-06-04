Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA6839BCA4
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 18:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFDQMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 12:12:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31704 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230314AbhFDQMn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Jun 2021 12:12:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622823056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RTnd3yVJTH9740JT32WVCu1PAebhuUq28dsvMUvas14=;
        b=ckIazIR80pdAYzQpbIWTmDiNEb2qsGjwR5zvQL64CQ3W0PQXg3ymresHPH0uvqElTp7pUF
        OONtBje9+4n8Kgop0gC6NABiWpP+iKQT9jZvbAroAdnsGbcjn6UNiZbBzpG/GBCTWTFCO3
        Q1DxxR8GFyL4YFvQhVD+QkLRPUekFHM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-mMyny9JAMpOera4m0Pflww-1; Fri, 04 Jun 2021 12:10:55 -0400
X-MC-Unique: mMyny9JAMpOera4m0Pflww-1
Received: by mail-ej1-f71.google.com with SMTP id f1-20020a1709064941b02903f6b5ef17bfso3597289ejt.20
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 09:10:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RTnd3yVJTH9740JT32WVCu1PAebhuUq28dsvMUvas14=;
        b=TdLbp4e3aWkQiuAxpNxoIUl/X3wgsyHiUzPOYPKj2s20M/v6aMhqfAK/aAnIYisejG
         FyUYsc50dncW48QksLnzSV2g9UQuTuuq4GiojKjmYCxrnUI1AvKxmHvomptlzK4lQ5J8
         KHVOnmJWY2cf3zQYWPryyaechXsFuu25qqOGGWlfAH+bPFRpI6r1ssiwiD/KZDF84Yom
         As7PTS8PiXeSb0PxOtGag6kN22eo7md2Jx/F3x38rzxhlDjAbMqf0ma3aIzzWVJjFvct
         /cIYFoXrfqBdIhMt6ACeFUY6cz9MupYUd9gwBiCyyihALw2r2nE43DTA6S47MIZn32IY
         2FUg==
X-Gm-Message-State: AOAM530pjG0rSEPRmixTSKgKaRSY8neu7qqzALUA4QmKOHXKaJG6JQjo
        0rCxdWzby6XfhH0qAjne+kBKDrgRt2V0MYL/wsZSAHPy+Uq3Fd8WWETufgdibKiQnDk621TJGrN
        zD5BSvg3SALgK
X-Received: by 2002:a05:6402:342:: with SMTP id r2mr5564720edw.69.1622823054173;
        Fri, 04 Jun 2021 09:10:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxl+Ws1Chi8vFl+XGY47+7Vk/he3YcPPXFlfuf7NcSLW1TqV0Dzd1EqxORRIL3XKm5Xuw9+Ww==
X-Received: by 2002:a05:6402:342:: with SMTP id r2mr5564684edw.69.1622823053958;
        Fri, 04 Jun 2021 09:10:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m4sm2915547eje.8.2021.06.04.09.10.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 09:10:53 -0700 (PDT)
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
References: <20210603123401.GT1002214@nvidia.com>
 <20210603140146.5ce4f08a.alex.williamson@redhat.com>
 <20210603201018.GF1002214@nvidia.com>
 <20210603154407.6fe33880.alex.williamson@redhat.com>
 <MWHPR11MB1886469C0136C6523AB158B68C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210604122830.GK1002214@nvidia.com>
 <20210604092620.16aaf5db.alex.williamson@redhat.com>
 <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
 <20210604155016.GR1002214@nvidia.com>
 <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
 <20210604160336.GA414156@nvidia.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
Date:   Fri, 4 Jun 2021 18:10:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210604160336.GA414156@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/21 18:03, Jason Gunthorpe wrote:
> On Fri, Jun 04, 2021 at 05:57:19PM +0200, Paolo Bonzini wrote:
>> I don't want a security proof myself; I want to trust VFIO to make the right
>> judgment and I'm happy to defer to it (via the KVM-VFIO device).
>>
>> Given how KVM is just a device driver inside Linux, VMs should be a slightly
>> more roundabout way to do stuff that is accessible to bare metal; not a way
>> to gain extra privilege.
> 
> Okay, fine, lets turn the question on its head then.
> 
> VFIO should provide a IOCTL VFIO_EXECUTE_WBINVD so that userspace VFIO
> application can make use of no-snoop optimizations. The ability of KVM
> to execute wbinvd should be tied to the ability of that IOCTL to run
> in a normal process context.
> 
> So, under what conditions do we want to allow VFIO to giave a process
> elevated access to the CPU:

Ok, I would definitely not want to tie it *only* to CAP_SYS_RAWIO (i.e. 
#2+#3 would be worse than what we have today), but IIUC the proposal 
(was it yours or Kevin's?) was to keep #2 and add #1 with an 
enable/disable ioctl, which then would be on VFIO and not on KVM.  I 
assumed Alex was more or less okay with it, given he included me in the 
discussion.

If later y'all switch to "it's always okay to issue the enable/disable 
ioctl", I guess the rationale would be documented in the commit message.

Paolo

>>>    1) User has access to a device that can issue no-snoop TLPS
>>>    2) User has access to an IOMMU that can not block no-snoop (today)
>>>    3) Require CAP_SYS_RAW_IO
>>>    4) Anyone
> 
> Jason
> 

