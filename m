Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0561643C7B3
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 12:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241420AbhJ0Ke6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 06:34:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239378AbhJ0Ke5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 06:34:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635330751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZpDTbLV2n+Qg6lI0UNtzA072Lo2usMm1q8b+tx7LSww=;
        b=U7qzHOm6+UYKjSAxcMnpkozD5fyQTuM1KtlsR+bXIkjeLch3Cay3NLJODL2hpYAKaQpmmA
        y7xuKmwtTAQuNlKht4YByjqv9ojnf8DyQx8ecf0ASVGfhcLCE2tlpucaRW3QEIqdcAn8g6
        6PMR3g6NNQvAAdJv5/KEfjPdkaFqNYY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-wPP4Nnz1Ob6Y8__OzNmJtw-1; Wed, 27 Oct 2021 06:32:29 -0400
X-MC-Unique: wPP4Nnz1Ob6Y8__OzNmJtw-1
Received: by mail-ed1-f72.google.com with SMTP id g6-20020a056402424600b003dd2b85563bso1885167edb.7
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 03:32:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZpDTbLV2n+Qg6lI0UNtzA072Lo2usMm1q8b+tx7LSww=;
        b=wtP/fxIwmoIwkUFKjb73WZoMmULKlKmQJcMf7rV2acLpk+1uk5RnfSOoW7Sn4vlwme
         PoE5P46q7obZ5jnl+EpH73gkJcszLlwL3gpUbtBf5ARIfI01mnfD10Tb01qXmWabY//f
         PMwAlnRc41CkZHIgxztgCixgD2IwHpNDfMqz6zvKMSav80sM6kh/VsZh55EdbeR9/Snu
         d28MAp/CIa9dSoiawaI+YFNN2Q8K8wlXiMFcPYgweUKmNr15L3wpAlTGV63nik66ZCV/
         xPPT9Wphhkj+JdlhIS1STuo+SEKQngJ/ETrVn7LYQ9PzDzvTNVXgZI3/esmGVQ+5QuP3
         sRUQ==
X-Gm-Message-State: AOAM531UTCSnQWu8g+LPPdv2CPbxi9wh5sp4O25DaQdMYIMu9oC2xHDK
        heCn9zrjaYmH73tcQ1WjpPobZSJwtnJOAaale11sx8Q4TxsJi5e5v1+NIoNxID3DDYCSgusWK9d
        G5t5Uoc1uYohj
X-Received: by 2002:a17:906:646:: with SMTP id t6mr33637705ejb.209.1635330748437;
        Wed, 27 Oct 2021 03:32:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJp0E2xSwEzNmUoGavtAqs86aKHQkha4V0D9DUdm+C+KykQjUFDJc6UWr5b0bUCQFwuTsmPQ==
X-Received: by 2002:a17:906:646:: with SMTP id t6mr33637680ejb.209.1635330748210;
        Wed, 27 Oct 2021 03:32:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id nb1sm5770785ejc.56.2021.10.27.03.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 03:32:27 -0700 (PDT)
Message-ID: <861c6a1f-a68d-85fc-e6d2-1cd90f32f86a@redhat.com>
Date:   Wed, 27 Oct 2021 12:32:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
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
References: <20210607175926.GJ1002214@nvidia.com>
 <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
 <20210608131547.GE1002214@nvidia.com>
 <89d30977-119c-49f3-3bf6-d3f7104e07d8@redhat.com>
 <20210608124700.7b9aa5a6.alex.williamson@redhat.com>
 <20210608190022.GM1002214@nvidia.com>
 <ec0b1ef9-ae2f-d6c7-99b7-4699ced146e4@metux.net>
 <671efe89-2430-04fa-5f31-f52589276f01@redhat.com>
 <20210609115445.GX1002214@nvidia.com>
 <20210609083134.396055e3.alex.williamson@redhat.com>
 <20210609144530.GD1002214@nvidia.com>
 <b9df3330-3f27-7421-d5fc-3124c61bacf3@redhat.com>
 <BN9PR11MB5433B2E25895D240BA3B182B8C859@BN9PR11MB5433.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BN9PR11MB5433B2E25895D240BA3B182B8C859@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/10/21 08:18, Tian, Kevin wrote:
>> I absolutely do *not* want an API that tells KVM to enable WBINVD.  This
>> is not up for discussion.
>>
>> But really, let's stop calling the file descriptor a security proof or a
>> capability.  It's overkill; all that we are doing here is kernel
>> acceleration of the WBINVD ioctl.
>>
>> As a thought experiment, let's consider what would happen if wbinvd
>> caused an unconditional exit from guest to userspace.  Userspace would
>> react by invoking the ioctl on the ioasid.  The proposed functionality
>> is just an acceleration of this same thing, avoiding the
>> guest->KVM->userspace->IOASID->wbinvd trip.
> 
> While the concept here makes sense, in reality implementing a wbinvd
> ioctl for userspace requiring iommufd (previous /dev/ioasid is renamed
> to /dev/iommu now) to track dirty CPUs that a given process has been
> running since wbinvd only flushes local cache.
> 
> Is it ok to omit the actual wbinvd ioctl here and just leverage vfio-kvm
> contract to manage whether guest wbinvd is emulated as no-op?

Yes, it'd be okay for me.  As I wrote in the message, the concept of a 
wbinvd ioctl is mostly important as a thought experiment for what is 
security sensitive and what is not.  If a wbinvd ioctl would not be 
privileged on the iommufd, then WBINVD is not considered privileged in a 
guest either.

That does not imply a requirement to implement the wbinvd ioctl, though. 
Of course, non-KVM usage of iommufd systems/devices with non-coherent 
DMA would be less useful; but that's already the case for VFIO.

> btw does kvm community set a strict criteria that any operation that
> the guest can do must be first carried in host uAPI first? In concept
> KVM deals with ISA-level to cover both guest kernel and guest user
> while host uAPI is only for host user. Introducing new uAPIs to allow
> host user doing whatever guest kernel can do sounds ideal, but not
> exactly necessary imho.

I agree; however, it's the right mindset in my opinion because 
virtualization (in a perfect world) should not be a way to give 
processes privilege to do something that they cannot do.  If it does, 
it's usually a good idea to ask yourself "should this functionality be 
accessible outside KVM too?".

Thanks,

Paolo

