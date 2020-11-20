Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F672BAF62
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 16:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729944AbgKTPzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 10:55:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728404AbgKTPzG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 10:55:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605887705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rY2Rec5SHAHV9d9Nn2wvBLT2el7uEj1Kc43gm3aG5HM=;
        b=g9lD0bCxENPqcIGc2Z5tasWLJyAqqyHwdIWyhdE3T+gFEmncp1Z07rSQz1E2Gi3/qTwJ+3
        skp0DCXX7dsULaSAGcfW7EiyaIfzVDY8pSkV/5a65pPivfHUbXb+ZLHeS7GQuCmhACXkH8
        bIu4k/kvl7e+wNF5Tqkh0s8Olh/H8HQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-qhGoJAbTMOGpWErZ5mWj-A-1; Fri, 20 Nov 2020 10:55:03 -0500
X-MC-Unique: qhGoJAbTMOGpWErZ5mWj-A-1
Received: by mail-ej1-f72.google.com with SMTP id e7so3635050eja.15
        for <kvm@vger.kernel.org>; Fri, 20 Nov 2020 07:55:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rY2Rec5SHAHV9d9Nn2wvBLT2el7uEj1Kc43gm3aG5HM=;
        b=gnE9n2zcjqNQoc5DG38rUGpqlfY/K+injge9dVfMQExgPSrLgzYDQjY+oAIui8hcHZ
         i+w/EHqflx619cT89fSY+Ez07PJ4owk9bTF2VzrNh2bRVJf482QtpJMzfmuTpGAcKfST
         mRAr3v+70/G8C7pA86nuSuGrEnV+pgV5ttOVhQNpgKbyo9mxf+BIL4ZIrn2n6azLgz/C
         CyCrlYzTe9rmUw0Q5co+pk6/asBb5BEad07gqP0bLkSeL2o3o5Nkg8mq/vLEKZ+G2XGD
         WU3OHTp+zAXJWf+7wdISZ4c8/PA+yIA3/ESUVJFIVUX1x3LM3PQWAeR3ktI809sRlF9t
         zc/g==
X-Gm-Message-State: AOAM533UwYIlRKkihRicPvCLjd/oCAe7r2sHJJNx8hBMug97HNQsqY3u
        lsHYPvZcF/HGGg7uvnPkYYXJP77AyKFVAG6BnLiUGL+2clFqlAzIdccUtSFHD78d5Ola51CPWBd
        NoYmxYre5PH5E
X-Received: by 2002:aa7:d2d9:: with SMTP id k25mr34928694edr.310.1605887702587;
        Fri, 20 Nov 2020 07:55:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw3gVlgwW/bmEajthpJVdpMUNtgPUbi/HFUtFVuvcpkMu9pSTRR3a9KC3tEdlGleoOWxNajPA==
X-Received: by 2002:aa7:d2d9:: with SMTP id k25mr34928681edr.310.1605887702427;
        Fri, 20 Nov 2020 07:55:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r25sm1300693eji.8.2020.11.20.07.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 07:55:01 -0800 (PST)
Subject: Re: [PATCH v6 16/17] RFC: kvm: pass kvm argument to follow_pfn
 callsites
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>
References: <20201119144146.1045202-1-daniel.vetter@ffwll.ch>
 <20201119144146.1045202-17-daniel.vetter@ffwll.ch>
 <cd56eb8a-fbec-e81f-9c14-d1256a193b68@redhat.com>
 <CAKMK7uHDrPDcsWyMgFgjf0+hdebSUT4hX5hKR=CnTH=soLU-Kg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3eca2dde-c78b-3eb4-8f61-7fdf16573419@redhat.com>
Date:   Fri, 20 Nov 2020 16:55:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAKMK7uHDrPDcsWyMgFgjf0+hdebSUT4hX5hKR=CnTH=soLU-Kg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/11/20 16:44, Daniel Vetter wrote:
>> It's a bit of a pity, it's making an API more complex (the point of
>> gfn_to_pfn_memslot vs gfn_to_pfn is exactly that you don't need a
>> "struct kvm*" and it's clear that you've already done the lookup into
>> that struct kvm.
>
> Yeah I noticed that, I think pushing the lookups down should work, but
> that's a fairly large-scale change. I didn't want to do that for the
> RFC since it would distract from the actual change/goal.
> -Daniel

Pushing the lookups down would be worse code and possibly introduce 
TOC/TOU races, so better avoid that.  Your patch is fine. :)

Paolo

