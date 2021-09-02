Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C363FF1C4
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 18:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346437AbhIBQrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 12:47:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25644 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346217AbhIBQrS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Sep 2021 12:47:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630601179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wM5jeR/BgbaPO4304Czble7Nihbr6/IU4liWjqxSIng=;
        b=Y6Ew6lBZVSPk80fdPR6SzZqzr8Lz4neR4w+2QF0U5SGv0K1/cFubRCo96QydhENElLhvRi
        CF0RVca+6Me+dILzvPRJrYTP8NH8oE24XVABGE0HlCjb5iuILO33vhl97rDIynhkGZtK8R
        cmOxfn4EYCyBbv2+RIAsRgNhZSmTbtg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-JPbfHbyBONuEPaoB0bn20Q-1; Thu, 02 Sep 2021 12:46:17 -0400
X-MC-Unique: JPbfHbyBONuEPaoB0bn20Q-1
Received: by mail-wm1-f71.google.com with SMTP id b126-20020a1c8084000000b002f152a868a2so893619wmd.1
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 09:46:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wM5jeR/BgbaPO4304Czble7Nihbr6/IU4liWjqxSIng=;
        b=WjxVkILH6HMSy+yS2yL4R7J1W9Idz/9f5ySMSYzS06R4t8NsY19U4JD/quVOBE+OiB
         Cm4gMJ/5DY4yc+X5/8qHtsZZRejOrbeFK0N53DngCwAd85Wi9Jw+keGvuGMEeWVTNgHN
         BloT5qC0AUKUB1O4xZ/F7vG63B0QON94XFyfM+KJdiXbfSwoHVpzd5erACktlgi3vyYV
         sxCZbytJizTukuHfFjyccEAM7msgyc1RoDQw2tRxAJYAUOVjdloT6JxxVmlAsgQ+uNR8
         k0IFCRkjfXAW5xYOq4RMNBtMIt9PzqB4biwLaPMS+f+EcatTu4KL00NRe/jrX5kKQ6ZL
         8EVg==
X-Gm-Message-State: AOAM532N04wXtiL4TofoRYtzFgbNQbTK868cg2As79xE5xpw6EF6RoMj
        rjGxE4BsVTOZNNYYRq1q8RBeHqBRMiSPw4P1XeCVP+VCix6n3k9cZOA1kSvnS+koXnvVniOf+FM
        xg7nZZc6vk06Z
X-Received: by 2002:adf:c390:: with SMTP id p16mr5093847wrf.105.1630601176842;
        Thu, 02 Sep 2021 09:46:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+Mu40jTTtKwfCi2VF1Q5s3Y3vUCWCZb2j0MvPEkAE/tQN20FSjlYWAo4PNCuAbQImt5QboQ==
X-Received: by 2002:adf:c390:: with SMTP id p16mr5093827wrf.105.1630601176625;
        Thu, 02 Sep 2021 09:46:16 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j20sm2228400wrb.5.2021.09.02.09.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:46:15 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] KVM: Drop unused kvm_dirty_gfn_harvested()
In-Reply-To: <YTD+eBj+9+mb9LVg@google.com>
References: <20210901230506.13362-1-peterx@redhat.com>
 <87y28flyxj.fsf@vitty.brq.redhat.com> <YTD+eBj+9+mb9LVg@google.com>
Date:   Thu, 02 Sep 2021 18:46:14 +0200
Message-ID: <87r1e7lycp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Sep 02, 2021, Vitaly Kuznetsov wrote:
>> Peter Xu <peterx@redhat.com> writes:
>> 
>> > Drop the unused function as reported by test bot.
>> 
>> Your subject line says "Drop unused kvm_dirty_gfn_harvested()" while in
>> reallity you drop "kvm_dirty_gfn_invalid()".
>
> Heh, Peter already sent v2[*].  Though that's a good reminder that it's helpful
> to reviewers to respond to your own patch if there's a fatal mistake and you're
> going to immediately post a new version.  For tiny patches it's not a big deal,
> but for larger patches it can avoid wasting reviewers' time.
>

Indeed. It's also a good reminder for reviewers that inbox is best
treated like a stack and not like a queue :-)

-- 
Vitaly

