Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0973B361DFD
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 12:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239536AbhDPKc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 06:32:28 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:39631 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238766AbhDPKc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 06:32:27 -0400
Received: by mail-wm1-f53.google.com with SMTP id i21-20020a05600c3555b029012eae2af5d4so4286440wmq.4;
        Fri, 16 Apr 2021 03:32:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yqhNqfjZUG4eC0lkMn87qOHykQGaWRjakY07kc6mVKw=;
        b=gVznrD3krorP8fo6hwOv4a2IeibvemExqseX8YiirgAqQuUF9WoKmHB1QGG6lEQmjP
         ELx7kwqXjo6VT4Cg/b9NKmiPBjKmTipWKeTI2GO2eXsyo55iyRGfh3cPb2aTpC2HXCpu
         VXAWPb07YDBgkxuB/cduWVOsTQs+OqMegHZvJQwYzwKQuUgVQBHgYZmPiaCQFbJIYQj9
         UIBNw9EhBuPnwElShCF3nWZBNyijJ/FKB/Ei4wk7I2qM4zW362xJMsaVJeqZvZVzKyu8
         r5PW8oCc/Dr7QofpAAPqYyf4t9Qm2b+R7/AyAgGIWxUFwUKdQAjLmySAB0103KzsWyW3
         QFSQ==
X-Gm-Message-State: AOAM53142kJvOubzcvso74w7/bMK0Cs/NKkTQkgz+rkfsyx0j3oIqwql
        ctZ3tiGb8jFI5sc5zSbkjl0=
X-Google-Smtp-Source: ABdhPJxerASWRcbPAJybWqXWONU6R+tPGuulB/fKNbyDGI3tyQ4wQNWfaWet2Kd1JYysI92oOshy9A==
X-Received: by 2002:a05:600c:40c4:: with SMTP id m4mr7468836wmh.25.1618569120641;
        Fri, 16 Apr 2021 03:32:00 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id u8sm9631940wrr.42.2021.04.16.03.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 03:32:00 -0700 (PDT)
Date:   Fri, 16 Apr 2021 10:31:58 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wei Liu <wei.liu@kernel.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH RFC 01/22] asm-generic/hyperv: add
 HV_STATUS_ACCESS_DENIED definition
Message-ID: <20210416103158.34cxzspi5idzci5g@liuwe-devbox-debian-v2>
References: <20210413122630.975617-1-vkuznets@redhat.com>
 <20210413122630.975617-2-vkuznets@redhat.com>
 <20210415141403.hftsza3ucrf262tq@liuwe-devbox-debian-v2>
 <877dl38sw2.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dl38sw2.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 15, 2021 at 05:33:17PM +0200, Vitaly Kuznetsov wrote:
> Wei Liu <wei.liu@kernel.org> writes:
> 
> > On Tue, Apr 13, 2021 at 02:26:09PM +0200, Vitaly Kuznetsov wrote:
> >> From TLFSv6.0b, this status means: "The caller did not possess sufficient
> >> access rights to perform the requested operation."
> >> 
> >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >
> > This can be applied to hyperv-next right away. Let me know what you
> > think.
> >
> 
> In case there's no immediate need for this constant outside of KVM, I'd
> suggest you just give Paolo your 'Acked-by' so I can carry the patch in
> the series for the time being. This will eliminate the need to track
> dependencies between hyperv-next and kvm-next.

Acked-by: Wei Liu <wei.liu@kernel.org>
