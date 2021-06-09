Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF483A14C5
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 14:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhFIMsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 08:48:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44548 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230146AbhFIMsH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 08:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623242772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aV8lGXCf4JWxP5wrUtMX1uPufd4NWDA47LRUUqM3gO4=;
        b=FHlXed8RHbqcxJN1v0fYPtruwFTGVJJvT5xHBf0qR1ipKYVlQxvaWld3NEinU7jTiCUvUX
        Fa21bMAxgnadgLt7X6hLclZuTb5EzMc3REoxa7RTNRcvaUGA5EFJPdUP7pxjDWerynmKud
        r+ZT5Lcd38mkjaPAXNMgjkcMRYPOo08=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-3sMyLQ8UPHSf-C23rIarnw-1; Wed, 09 Jun 2021 08:46:11 -0400
X-MC-Unique: 3sMyLQ8UPHSf-C23rIarnw-1
Received: by mail-wr1-f70.google.com with SMTP id q15-20020adfc50f0000b0290111f48b865cso10719575wrf.4
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 05:46:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aV8lGXCf4JWxP5wrUtMX1uPufd4NWDA47LRUUqM3gO4=;
        b=T8+yJ3hz7DSBJVx40BUe824IICiZ9B8u+v9VZNDaQSwrBrfpW283P6hAdABD4h5ku9
         TFH02tXcqo1sM7B3vJBmDYP9PLddRLhp2cTO2vpG5A/juomN5A3W9FuaikRdH/qDWhaM
         2LEphsTSijVe/HoOxkfxebMHtbjMcfpW31krvEBW7HUzujZ2agozymHbLuqj/sXBMdMy
         UC7ucEa+/FPVOObdQW3SAD59CpUqudaBq8ARQIvHz5tBqGXlEeEAmxcMcKGebLV9In41
         QbG4Np4OdG9HK3JRsFgWUQjPAEE8aFHh+4xs/+V05TAoodr4L0szuOLQcVIB7tjGqBSS
         VkSw==
X-Gm-Message-State: AOAM531iWDJoxRXJqM/kWHvdER0nhP9zdjixfwQZWHP27D14K+iLdqBn
        BcEHwzrdHW9mwP62/yRJDYWBwbXHggV0kuckAXBslkouWfDLNmyAryq8+nrdMSqxGAyJ7X9SYMk
        Woe7qbjroF7IX
X-Received: by 2002:a05:600c:354f:: with SMTP id i15mr8076530wmq.131.1623242770296;
        Wed, 09 Jun 2021 05:46:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzssGJ2TKM/C2YsruUldvJ4psZlR+tiJSwiHUOX3ataMRoMzZVYUZnHCu+koyMrOPAZjrC5IA==
X-Received: by 2002:a05:600c:354f:: with SMTP id i15mr8076509wmq.131.1623242770063;
        Wed, 09 Jun 2021 05:46:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k12sm6167589wmr.2.2021.06.09.05.46.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 05:46:09 -0700 (PDT)
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
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
References: <20210604160336.GA414156@nvidia.com>
 <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
 <20210604172207.GT1002214@nvidia.com>
 <2d1ad075-bec6-bfb9-ce71-ed873795e973@redhat.com>
 <20210607175926.GJ1002214@nvidia.com>
 <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
 <20210608131547.GE1002214@nvidia.com>
 <89d30977-119c-49f3-3bf6-d3f7104e07d8@redhat.com>
 <20210608124700.7b9aa5a6.alex.williamson@redhat.com>
 <MWHPR11MB18861A89FE6620921E7A7CAC8C369@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210609115759.GY1002214@nvidia.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <086ca28f-42e5-a432-8bef-ac47a0a6df45@redhat.com>
Date:   Wed, 9 Jun 2021 14:46:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609115759.GY1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 13:57, Jason Gunthorpe wrote:
> On Wed, Jun 09, 2021 at 02:49:32AM +0000, Tian, Kevin wrote:
> 
>> Last unclosed open. Jason, you dislike symbol_get in this contract per
>> earlier comment. As Alex explained, looks it's more about module
>> dependency which is orthogonal to how this contract is designed. What
>> is your opinion now?
> 
> Generally when you see symbol_get like this it suggests something is
> wrong in the layering..
> 
> Why shouldn't kvm have a normal module dependency on drivers/iommu?

It allows KVM to load even if there's an "install /bin/false" for vfio 
(typically used together with the blacklist directive) in modprobe.conf. 
  This rationale should apply to iommu as well.

Paolo

