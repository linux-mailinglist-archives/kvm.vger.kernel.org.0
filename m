Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B134399840
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 04:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFCCyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 22:54:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229626AbhFCCyr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 22:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622688783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rml3snF+8HtrCauMNf32U0cEH6eDUnFGeUKsyp+NXXo=;
        b=bGwpNjlDxNRsJUOPjoTby150mO/5w0rk/KbTtYlXTsLTsro9gfRtW/hMylBM0ldwDH0UOs
        +EBwO235rrIPZnLtCO0V3OXJu02HLXn0gGzAbfhBIggvOboR4OFdAGV6L8naYQAsAnbN5g
        JILGuV7Eb/moSDjmbatBHZYldQ1esl4=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-D96Uo4UAOBuh9UT5okRERQ-1; Wed, 02 Jun 2021 22:53:02 -0400
X-MC-Unique: D96Uo4UAOBuh9UT5okRERQ-1
Received: by mail-pj1-f71.google.com with SMTP id z3-20020a17090a4683b029015f6c19f126so2763792pjf.1
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 19:53:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=rml3snF+8HtrCauMNf32U0cEH6eDUnFGeUKsyp+NXXo=;
        b=ZBQkg9vcztC4bwFYbGJg9urvAks2Y7bKhTU90CNrq4uua+plQt2tpULowCinKHtpif
         fr88NguQJ+kebEkA6ZMEjdNfFkwvDVPprfeif0h94JDFZVTCoAnvYDlQW4YZ7OKSDwJE
         0EmenuWzTaytLDhQgBSxUEcz+J3l4+zTtzuIYsD1aI0I0ZVE5opNAHup66A4bRyR9672
         D6L5CKQCUIhYYmE1xc/uKKnY3hGE6PZiyE08z+QQG6TZkC8KFUo+FIcJXvmmuHuONW7y
         eSSaUIukt244EqbptFM4FZN97TpnW5/bS7HOEc55zzlO4OVhD5RSSpboLT71/6QMZRLo
         lYOA==
X-Gm-Message-State: AOAM530Or12k/ygCj0j8bnBKSQGFXTO5YFQpLMw/iE9IVzFlUU2DDcQl
        njACfb53uD6SwnfpwuB2ufkyYheMu8V+5THTHZeCVRFNFnDR1qnYu5HqDvLAZ0THZJhszqlUYeT
        X6yXQhIBF/Wvr
X-Received: by 2002:a17:902:e74d:b029:10d:9cd0:2c69 with SMTP id p13-20020a170902e74db029010d9cd02c69mr2020515plf.82.1622688780894;
        Wed, 02 Jun 2021 19:53:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGUUgfYG9dvW5sJE4TeEfDd6nGvhT7VXFCR8OU+oXimuG2T2IbG4AbopH90YZ4ENmXiBET0w==
X-Received: by 2002:a17:902:e74d:b029:10d:9cd0:2c69 with SMTP id p13-20020a170902e74db029010d9cd02c69mr2020503plf.82.1622688780610;
        Wed, 02 Jun 2021 19:53:00 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ls13sm609152pjb.23.2021.06.02.19.52.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 19:53:00 -0700 (PDT)
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
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
        David Woodhouse <dwmw2@infradead.org>
References: <20210528200311.GP1002214@nvidia.com>
 <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601162225.259923bc.alex.williamson@redhat.com>
 <MWHPR11MB1886E8454A58661DC2CDBA678C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210602160140.GV1002214@nvidia.com>
 <20210602111117.026d4a26.alex.williamson@redhat.com>
 <20210602173510.GE1002214@nvidia.com>
 <20210602120111.5e5bcf93.alex.williamson@redhat.com>
 <20210602180925.GH1002214@nvidia.com>
 <20210602130053.615db578.alex.williamson@redhat.com>
 <20210602195404.GI1002214@nvidia.com>
 <20210602143734.72fb4fa4.alex.williamson@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6a9426d7-ed55-e006-9c4c-6b7c78142e39@redhat.com>
Date:   Thu, 3 Jun 2021 10:52:51 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210602143734.72fb4fa4.alex.williamson@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/6/3 上午4:37, Alex Williamson 写道:
> On Wed, 2 Jun 2021 16:54:04 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> On Wed, Jun 02, 2021 at 01:00:53PM -0600, Alex Williamson wrote:
>>> Right, the device can generate the no-snoop transactions, but it's the
>>> IOMMU that essentially determines whether those transactions are
>>> actually still cache coherent, AIUI.
>> Wow, this is really confusing stuff in the code.
>>
>> At the PCI level there is a TLP bit called no-snoop that is platform
>> specific. The general intention is to allow devices to selectively
>> bypass the CPU caching for DMAs. GPUs like to use this feature for
>> performance.
> Yes
>
>> I assume there is some exciting security issues here. Looks like
>> allowing cache bypass does something bad inside VMs? Looks like
>> allowing the VM to use the cache clear instruction that is mandatory
>> with cache bypass DMA causes some QOS issues? OK.
> IIRC, largely a DoS issue if userspace gets to choose when to emulate
> wbinvd rather than it being demanded for correct operation.
>
>> So how does it work?
>>
>> What I see in the intel/iommu.c is that some domains support "snoop
>> control" or not, based on some HW flag. This indicates if the
>> DMA_PTE_SNP bit is supported on a page by page basis or not.
>>
>> Since x86 always leans toward "DMA cache coherent" I'm reading some
>> tea leaves here:
>>
>> 	IOMMU_CAP_CACHE_COHERENCY,	/* IOMMU can enforce cache coherent DMA
>> 					   transactions */
>>
>> And guessing that IOMMUs that implement DMA_PTE_SNP will ignore the
>> snoop bit in TLPs for IOVA's that have DMA_PTE_SNP set?
> That's my understanding as well.
>
>> Further, I guess IOMMUs that don't support PTE_SNP, or have
>> DMA_PTE_SNP clear will always honour the snoop bit. (backwards compat
>> and all)
> Yes.
>
>> So, IOMMU_CAP_CACHE_COHERENCY does not mean the IOMMU is DMA
>> incoherent with the CPU caches, it just means that that snoop bit in
>> the TLP cannot be enforced. ie the device *could* do no-shoop DMA
>> if it wants. Devices that never do no-snoop remain DMA coherent on
>> x86, as they always have been.
> Yes, IOMMU_CAP_CACHE_COHERENCY=false means we cannot force the device
> DMA to be coherent via the IOMMU.
>
>> IOMMU_CACHE does not mean the IOMMU is DMA cache coherent, it means
>> the PCI device is blocked from using no-snoop in its TLPs.
>>
>> I wonder if ARM implemented this consistently? I see VDPA is
>> confused..


Basically, we don't want to bother with pseudo KVM device like what VFIO 
did. So for simplicity, we rules out the IOMMU that can't enforce 
coherency in vhost-vDPA if the parent purely depends on the platform IOMMU:


         if (!iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
                 return -ENOTSUPP;

For the parents that use its own translations logic, an implicit 
assumption is that the hardware will always perform cache coherent DMA.

Thanks


