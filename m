Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5D13A0F5E
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 11:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237930AbhFIJNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 05:13:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42537 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237918AbhFIJNR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 05:13:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623229883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ePZh2khRcBN5AJHEyhbtv31/bRFlPEJ4/4U8Xk0wMo=;
        b=M64qtcSJImQzhtgTOmErCPSUCVfDA27WQrMDsZFqi8D0nAbtoGdzbaTxmU2rm/6IvUdur8
        97wew9Q8uthhuJD3tN6uKK1eQumK/V2vxZ2P3dcpb+9mysRpkusFhUZ4m8MkTrcRWDmj4i
        WSpc2d9NP+6z2ZkajbUKi+AkS6m/jUU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-0iNXT4q_Pg2JxOn2KzNmmg-1; Wed, 09 Jun 2021 05:11:22 -0400
X-MC-Unique: 0iNXT4q_Pg2JxOn2KzNmmg-1
Received: by mail-wm1-f69.google.com with SMTP id z25-20020a1c4c190000b029019f15b0657dso1680085wmf.8
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 02:11:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2ePZh2khRcBN5AJHEyhbtv31/bRFlPEJ4/4U8Xk0wMo=;
        b=RM7hp0RcWtgr59/22Loh+/flfnLJU/fFfxxTLZ+r4x6niu1uGkapr49IVeK8OVpwno
         IqpDBUmlgipiJ6b7BRx/RojxIlLXQwEX04WhUbHWxvmAMtC/CAfkQeHiyyo+moweySL6
         bykk2oeKmWHYdJZA1tq6SZDIVif9z+Ns1hie/7JfRsDoB7nr3lOW/YsLEl//DXf1tXuU
         JeevuamhVeCx7D0Cx95oQao0DiZi7piE8dPsFWNcuC0kdoeMSvy0EF8Z5Xlq4vELR/DS
         2Vu5be2y6y6CRdjxvrTciMGyk6eonS3kgrv7TlPwcgsRdoiMW3iWK4EX4joPS+htwSkm
         SX2g==
X-Gm-Message-State: AOAM533gdZIwEae9M/WY4a7zXxgDnOSzPbzi7ePjt8Ud0IuVvyCHniBw
        qkWqtgUot4JQmH250ef83ZnS4I5TwLyMbWFf+lxVaeJTxix02Xur9aC3gnCxLFNZEruXmhpQHcx
        G8ExyLkLPzcIA
X-Received: by 2002:adf:e507:: with SMTP id j7mr26371291wrm.178.1623229880818;
        Wed, 09 Jun 2021 02:11:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBSu8Kim/TFLMDmfSnepx2bA9qkajHoLuNSdNG99iK42XOJ0rk/n+XjBkjpM8nPppmmP/+6g==
X-Received: by 2002:adf:e507:: with SMTP id j7mr26371253wrm.178.1623229880319;
        Wed, 09 Jun 2021 02:11:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z3sm24335841wrl.13.2021.06.09.02.11.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 02:11:19 -0700 (PDT)
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
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
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
References: <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
 <20210604160336.GA414156@nvidia.com>
 <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
 <20210604172207.GT1002214@nvidia.com>
 <2d1ad075-bec6-bfb9-ce71-ed873795e973@redhat.com>
 <20210607175926.GJ1002214@nvidia.com>
 <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
 <20210608131547.GE1002214@nvidia.com>
 <89d30977-119c-49f3-3bf6-d3f7104e07d8@redhat.com>
 <20210608124700.7b9aa5a6.alex.williamson@redhat.com>
 <20210608190022.GM1002214@nvidia.com>
 <ec0b1ef9-ae2f-d6c7-99b7-4699ced146e4@metux.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <671efe89-2430-04fa-5f31-f52589276f01@redhat.com>
Date:   Wed, 9 Jun 2021 11:11:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <ec0b1ef9-ae2f-d6c7-99b7-4699ced146e4@metux.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 10:51, Enrico Weigelt, metux IT consult wrote:
> On 08.06.21 21:00, Jason Gunthorpe wrote:
> 
>> Eg I can do open() on a file and I get to keep that FD. I get to keep
>> that FD even if someone later does chmod() on that file so I can't
>> open it again.
>>
>> There are lots of examples where a one time access control check
>> provides continuing access to a resource. I feel the ongoing proof is
>> the rarity in Unix.. 'revoke' is an uncommon concept in Unix..
> 
> Yes, it's even possible that somebody w/ privileges opens an fd and
> hands it over to somebody unprivileged (eg. via unix socket). This is
> a very basic unix concept. If some (already opened) fd now suddenly
> behaves differently based on the current caller, that would be a break
> with traditional unix semantics.

That's already more or less meaningless for both KVM and VFIO, since 
they are tied to an mm.

Paolo

