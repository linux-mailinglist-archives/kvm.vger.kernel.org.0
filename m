Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4800347ABC
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 15:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbhCXObr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 10:31:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53537 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236222AbhCXObM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Mar 2021 10:31:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616596269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+jtHaYpG/XZInPp8hHHKOOdzU2YSMvIuIW7BEJkipo8=;
        b=KqHRh/Wf0nk6pudXDypiBEZdt2ZySsNSFvB0+AwMW8iM9l8er6jJchvGa+bZCd0Y4XgpGB
        YOgogUzZbiMSn1adlCNR5db37w7xTrG+n7Dan2O8Y3fIKmyi8mh+o+hy1BEkak80RzOvXO
        CPKR/pfnFsYMdXU0gbmkwypkjF3r3PU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-BePhCiUbPpelUpT0HyXn2Q-1; Wed, 24 Mar 2021 10:31:08 -0400
X-MC-Unique: BePhCiUbPpelUpT0HyXn2Q-1
Received: by mail-wr1-f69.google.com with SMTP id t16so1149062wrn.20
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 07:31:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+jtHaYpG/XZInPp8hHHKOOdzU2YSMvIuIW7BEJkipo8=;
        b=I+yKvwjOGe//tW/9TE+UNUVFfbEq7Cqa3+X5Eum1IqBYl4wqEuR3uwvKvwtXfDkL0M
         VsNxk6DP280woBQVGSCesLJYVLbcuk5qYVoFntL6UXDAsIZV77QXZM7WrcYQcjE3USOG
         3VCiVo1a29/wk4MQr0QRfYx/eIbtHCaLaipY/IUmnw6HsIj4iLuadwok90kUotKmUhjT
         BJdw9K+EWKbXucAEoC/PTWNLpUVi9uDJ2G/nt31cwwjv1o2zPJWIdhNH9TFX6R7aHx7f
         8MXJ7m4qWLQojXhxQy0QnH02WO9us7+zZTa63UXEXZ57vXIjuxBEQKCPOrh4YBPsRYE6
         6E6g==
X-Gm-Message-State: AOAM531SA9daNzH8wn+6WcRRwNfd/1v5LlWFoBKPrY7eQqCE1lLzg8o/
        5RgIPt04gxbVaCat8eHWslyhLBYXtyBFPhlpeoFIIOFdE1TWOxsTUroCBRCkeKOHDJLaV4lXonN
        dp80peNXBJ+YF
X-Received: by 2002:a5d:68cd:: with SMTP id p13mr3977881wrw.247.1616596266460;
        Wed, 24 Mar 2021 07:31:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIf+VryoTPSfwti+YSTkQ2E1C0/b6Xuw3ivYfNPK4a9PF7c1OO41KjvaTv9A51GLRMrRGgKA==
X-Received: by 2002:a5d:68cd:: with SMTP id p13mr3977856wrw.247.1616596266249;
        Wed, 24 Mar 2021 07:31:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u8sm3366640wrr.42.2021.03.24.07.31.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 07:31:05 -0700 (PDT)
Subject: Re: [PATCH 3/3] mm: unexport follow_pfn
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        3pvd@google.com, Jann Horn <jannh@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Daniel Vetter <daniel.vetter@intel.com>
References: <20210316153303.3216674-1-daniel.vetter@ffwll.ch>
 <20210316153303.3216674-4-daniel.vetter@ffwll.ch>
 <20210324125211.GA2356281@nvidia.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b1a46866-cbc7-4e7f-0e17-79fee57b32a0@redhat.com>
Date:   Wed, 24 Mar 2021 15:31:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210324125211.GA2356281@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/03/21 13:52, Jason Gunthorpe wrote:
> I think this is the right thing to do.
> 
> Alex is working on fixing VFIO and while kvm is still racy using
> follow pte, I think they are working on it too?

Yeah, or at least we have a plan.

Paolo

