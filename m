Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC03C48569D
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 17:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241910AbiAEQZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 11:25:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231290AbiAEQZ1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 11:25:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641399926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hknNMTwFhbYpQSmz5No5xN0sw1+0JrW2QZ6zSfztptA=;
        b=PUFbdOhWGQ7oXMXulO9FW37AFir02Li1j4txkzG/pbmVlWhKeoX8tNXnrtfSh1k53uSp1E
        f3D0uurGu8oHaNcZJ2px2qVdxoIVPmJnoflZo6vtk8FMH03sASZL12rW+GU9BAt67RAu8b
        bWyNS/vaMknaGJPCZTTEGZrm3qm7bzU=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-9g_m86JmNuacC35s_-zOUA-1; Wed, 05 Jan 2022 11:25:24 -0500
X-MC-Unique: 9g_m86JmNuacC35s_-zOUA-1
Received: by mail-qt1-f200.google.com with SMTP id j26-20020ac8405a000000b002c472361f33so26840927qtl.16
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 08:25:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hknNMTwFhbYpQSmz5No5xN0sw1+0JrW2QZ6zSfztptA=;
        b=lfexWzmh1Q0VY27yuAUvBhK9QvLM/nzFebsFXwsIZKZMDJF+SRJcC2RNZdWBpWmZOv
         0cWohVWwsYpQWBX+IrsePkBkRWKRLsZ1t5zL0TQq4yE9yPMBwNw8g3Z/gUFFN+tiX6nI
         zPBDrTXcitYjRBz9DetYSVqTIn3EQC1MWxvXY9mq+/5UzgqOioHi/Qds2Ohk08nw3vP1
         mqm7igxe7HvnJdIHBncsrA6kGOf4fXAiLOrj7kLjlXoNVGu8bXezRwc+6ntun7/XuP+l
         7k9b2lSSFfWJDmYKG0iZX/UHyjS+yN5YPDMd/YH4rM99r24/yJgwClleYCl5Spp1V8GT
         54LQ==
X-Gm-Message-State: AOAM53115A0U+qVspsVqI0gONlxz1tTabNs+ihbJWliBfYPHvjdigmSM
        xwYxsmQBUZh8gKC15BXo5sUsOKJnvj7UMBRi1donMQLcip4hyT5UdY9DuLpeBNyowO6ZoaUATuA
        OLmw795jdK1qp
X-Received: by 2002:a05:6214:4015:: with SMTP id kd21mr51294322qvb.41.1641399924303;
        Wed, 05 Jan 2022 08:25:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwlKHgt/quzEpSNY3x5FQOure6fAVMboTj7d0dDxEXUBGTvUItt4q2D6fkCkEzFQ7R/QFrV9w==
X-Received: by 2002:a05:6214:4015:: with SMTP id kd21mr51294296qvb.41.1641399924089;
        Wed, 05 Jan 2022 08:25:24 -0800 (PST)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id f12sm34865877qtj.93.2022.01.05.08.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 08:25:23 -0800 (PST)
Date:   Wed, 5 Jan 2022 17:25:19 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com,
        Eric Auger <eric.auger@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH] hw/arm/virt: KVM: Enable PAuth when supported by the host
Message-ID: <20220105162519.5kjtkhphv3sdyaw4@gator>
References: <20211228182347.1025501-1-maz@kernel.org>
 <20220103134601.7cumwbza32wja3ei@gator>
 <878rvwzocq.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rvwzocq.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 03, 2022 at 06:05:41PM +0000, Marc Zyngier wrote:
> Andrew Jones <drjones@redhat.com> wrote:
> > 
> > Thanks for considering a documentation update. In this case, though, I
> > think we should delete the "TCG VCPU Features" pauth paragraph, rather
> > than add a new "KVM VCPU Features" pauth paragraph. We don't need to
> > document each CPU feature. We just document complex ones, like sve*,
> > KVM specific ones (kvm-*), and TCG specific ones (now only pauth-impdef).
> 
> Sure, works for me. Do we need to keep a trace of the available
> options?

For arm we need to extend target/arm/helper.c:arm_cpu_list() to output
the possible flags like x86 does. On x86 doing this

  qemu-system-x86_64 -cpu help

not only gives us a list of cpu types, but also a list of flags we can
provide to the cpus (although not all flags will work on all cpus...)
On arm doing this

  qemu-system-aarch64 -cpu help

only gives us a list of cpu types.


> I'm not sure how a user is supposed to find out about those
> (I always end-up grepping through the code base, and something tells
> me I'm doing it wrong...). The QMP stuff flies way over my head.
>

Indeed, currently grepping is less awkward than probing with QMP.
With an extension to target/arm/helper.c:arm_cpu_list() we can
avoid grepping too. I've just added this to my TODO [again]. It
was there once already, but fell off the bottom...

Thanks,
drew

