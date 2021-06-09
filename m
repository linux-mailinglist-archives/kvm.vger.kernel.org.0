Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066F63A1588
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 15:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbhFIN0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 09:26:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22694 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233793AbhFIN0M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 09:26:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623245057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=20U4EvP+/4P7U+6EGZKMPnMwVak4M1Pove365pXCudk=;
        b=VnRNFVkJKa+j0AFWYs8Ms/9Kp/ldZPgsrzDFacZf9mOY7eKRzlSXMRIE40UMfkgD4CDAEV
        QfioZneITW0ssjGWLYQpYX5szclp1ONabGnnf2/FXrWTa4VRQmK1fA4vJWnLrespyyS4B1
        JRveNf0V/CjpmSyPn5oS2th2SdZwOhc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-yf-z1ljFNFSPHrtrRN91NQ-1; Wed, 09 Jun 2021 09:24:15 -0400
X-MC-Unique: yf-z1ljFNFSPHrtrRN91NQ-1
Received: by mail-wr1-f71.google.com with SMTP id k25-20020a5d52590000b0290114dee5b660so10790733wrc.16
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 06:24:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=20U4EvP+/4P7U+6EGZKMPnMwVak4M1Pove365pXCudk=;
        b=MQGh5ejHW1jPsVdC3OINV6n2cInm/D/tbg4/WK2GGoRKdNjoZ+hiCScrwkCOF1+S9x
         Gf0S/JVXrEMbCxGuLU5QeS2VqB9Tu4HYtYCCVXY4bbkHZnsfX8i22dGVB6qX53VeVeUr
         EFp6eGYKwrKpOoGaauomPOBXgaDZoqkvNlwgcOftL0VEdeRr/O//Ury6WlxJgh7XQ4Gb
         8qSgbr3vEYkucu1g+A103QnTWiR1skc0f5INCZL66GtJInFPFkesGWFaDY/b+B1lDFxR
         wo3rKdBu85Tv6PzkM5izC9+qkfJQqBE0Mms1Sg0K3U1ih70BISrkEnlRcMl92vvyattI
         724Q==
X-Gm-Message-State: AOAM532yXy3u+X3Ro/+0zdMy+psHS1AiLXUGGo66cQOakJEd+Yvg6EUD
        URMwq6R6eXls109t/RvrcMCjjYpHAoS+AMdFZ7TbqQDCK/WxkW+/lp1BCMd9FVuKKLDnrhZkuDq
        g9ZiJZFWessiJ
X-Received: by 2002:a5d:4a43:: with SMTP id v3mr28228661wrs.397.1623245054486;
        Wed, 09 Jun 2021 06:24:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZHa62Nu93nfcNXj9gZ2LfL0bfkGDMGaOIWtXI/yBXylwFuKfSs0RPk1+NDaNWif1T7to5CQ==
X-Received: by 2002:a5d:4a43:: with SMTP id v3mr28228631wrs.397.1623245054289;
        Wed, 09 Jun 2021 06:24:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x10sm13071040wrt.26.2021.06.09.06.24.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 06:24:13 -0700 (PDT)
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
References: <20210604172207.GT1002214@nvidia.com>
 <2d1ad075-bec6-bfb9-ce71-ed873795e973@redhat.com>
 <20210607175926.GJ1002214@nvidia.com>
 <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
 <20210608131547.GE1002214@nvidia.com>
 <89d30977-119c-49f3-3bf6-d3f7104e07d8@redhat.com>
 <20210608124700.7b9aa5a6.alex.williamson@redhat.com>
 <MWHPR11MB18861A89FE6620921E7A7CAC8C369@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210609115759.GY1002214@nvidia.com>
 <086ca28f-42e5-a432-8bef-ac47a0a6df45@redhat.com>
 <20210609124742.GB1002214@nvidia.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <8433033c-daf2-c9b7-56f7-e354320dc5b5@redhat.com>
Date:   Wed, 9 Jun 2021 15:24:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609124742.GB1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 14:47, Jason Gunthorpe wrote:
> On Wed, Jun 09, 2021 at 02:46:05PM +0200, Paolo Bonzini wrote:
>> On 09/06/21 13:57, Jason Gunthorpe wrote:
>>> On Wed, Jun 09, 2021 at 02:49:32AM +0000, Tian, Kevin wrote:
>>>
>>>> Last unclosed open. Jason, you dislike symbol_get in this contract per
>>>> earlier comment. As Alex explained, looks it's more about module
>>>> dependency which is orthogonal to how this contract is designed. What
>>>> is your opinion now?
>>>
>>> Generally when you see symbol_get like this it suggests something is
>>> wrong in the layering..
>>>
>>> Why shouldn't kvm have a normal module dependency on drivers/iommu?
>>
>> It allows KVM to load even if there's an "install /bin/false" for vfio
>> (typically used together with the blacklist directive) in modprobe.conf.
>> This rationale should apply to iommu as well.
> 
> I can vaugely understand this rational for vfio, but not at all for
> the platform's iommu driver, sorry.

Sorry, should apply to ioasid, not iommu (assuming that /dev/ioasid 
support would be modular).

Paolo

