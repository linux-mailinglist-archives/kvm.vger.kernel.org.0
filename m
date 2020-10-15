Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7526F28F644
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 18:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388560AbgJOQAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 12:00:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30780 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388393AbgJOP77 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Oct 2020 11:59:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602777598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P+Fz1xnny1QViwthSCJcz6si5Gd9eekT3vsqmAf12Bw=;
        b=UQjs0ozeQjRCe0up70bwq51fD8YhbmFqMCLgD8c02x+1rl6cvfAszpPB69N5hGonz3UuCS
        9g4f0bErxODZAUaIBSjIUIOGlRFij30iuGTvCi3QTbZy1x86f2UEghP+yzX/JjWFs2JGsw
        QNf2qeBYz0H0XuFnhSQonFZdsNV/3bU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-yHfPs7LKPICEDHrdoMEGHQ-1; Thu, 15 Oct 2020 11:59:57 -0400
X-MC-Unique: yHfPs7LKPICEDHrdoMEGHQ-1
Received: by mail-wm1-f70.google.com with SMTP id l15so2068615wmh.9
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 08:59:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=P+Fz1xnny1QViwthSCJcz6si5Gd9eekT3vsqmAf12Bw=;
        b=rJl7X/xymsUz936tEH1lSaW8JeIdcMQdesgh1m7DbFTXwHKr4YHQl27LIJ++kqR5y+
         BarSJ7F9A9Cy1zaSovBLMp2YRdZgEbh2+CYOdmgLp5O2cG40Xwpiy+/+NUZQPqemxeFb
         E27UkJ2bxO6sBbKGhZkgD2Kk6QWAahebkenloui9CZ/Rar23io4Tq2r1IH3YPm9XAmCU
         aBnTp2uih7z10/0hxE4wB1fUQYrc0RLuuRNY05rt91rG6Y2il4peF6v4eTAa8XqvKseO
         OcjhSaq15sWf51h6PlzL4jJ3h1hAP6Rgta8bkC2NOfuxln4jYTmO7FTjGhnLXt7WZ1Gu
         6aRA==
X-Gm-Message-State: AOAM533H0r12zg9STyD7q8HfxnOmtZ1vm2rN1/BC/k/J4FoVc18VElhY
        GUm6RKKhmGMg3ODytUkNExS/pFX7DV8rR57MvMM4O+UCoukvjsbVAP8fpbtCZTtesPwTJNv8QKe
        Dxi2+keNiOWEj
X-Received: by 2002:adf:8285:: with SMTP id 5mr4964106wrc.330.1602777594701;
        Thu, 15 Oct 2020 08:59:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+/O35BobPrgxPh/vxMF+1XSqwrMdjPaj2aUYTYqzrheoyYdashF6JZ3qdQS4nsNlZ8IF30Q==
X-Received: by 2002:adf:8285:: with SMTP id 5mr4964088wrc.330.1602777594434;
        Thu, 15 Oct 2020 08:59:54 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c16sm5448938wrx.31.2020.10.15.08.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 08:59:53 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     po-hsu.lin@canonical.com, kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCHv2] unittests.cfg: Increase timeout for apic test
In-Reply-To: <20201013091237.67132-1-po-hsu.lin@canonical.com>
References: <20201013091237.67132-1-po-hsu.lin@canonical.com>
Date:   Thu, 15 Oct 2020 17:59:52 +0200
Message-ID: <87d01j5vk7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Po-Hsu Lin <po-hsu.lin@canonical.com> writes:

> We found that on Azure cloud hyperv instance Standard_D48_v3, it will
> take about 45 seconds to run this apic test.
>
> It takes even longer (about 150 seconds) to run inside a KVM instance
> VM.Standard2.1 on Oracle cloud.
>
> Bump the timeout threshold to give it a chance to finish.
>
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> ---
>  x86/unittests.cfg | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 872d679..c72a659 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -41,7 +41,7 @@ file = apic.flat
>  smp = 2
>  extra_params = -cpu qemu64,+x2apic,+tsc-deadline
>  arch = x86_64
> -timeout = 30
> +timeout = 240
>  
>  [ioapic]
>  file = ioapic.flat

AFAIR the default timeout for tests where timeout it not set explicitly
is 90s so don't you need to also modify it for other tests like
'apic-split', 'ioapic', 'ioapic-split', ... ?

I was thinking about introducing a 'timeout multiplier' or something to
run_tests.sh for running in slow (read: nested) environments, doing that
would allow us to keep reasonably small timeouts by default. This is
somewhat important as tests tend to hang and waiting for 4 minutes every
time is not great.

-- 
Vitaly

