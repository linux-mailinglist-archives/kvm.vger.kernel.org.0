Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0583823FF
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 08:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbhEQGQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 02:16:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231400AbhEQGQd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 02:16:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621232116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QzynawLMKkiNCBVMSr0NbKElZSYcTMYLOczTr6TiqD0=;
        b=WeaLKDZIGCGBvsMrb7yRFfSShfJLBoGve8RiQ+9XYXH0BT6vwkezn6Dk5CPudhK90REAWT
        58rSbEWfgaFn75GtPPhNo9a6kck0ZxbOFtNKacWwmzQ08Gk7pSqIes1iuAautmolpePP/R
        UsviXckvT+H1MWz5bsp3K9mjZtq6qm8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-pflU_zzlO4WmeAUEBU0MQg-1; Mon, 17 May 2021 02:15:15 -0400
X-MC-Unique: pflU_zzlO4WmeAUEBU0MQg-1
Received: by mail-ed1-f69.google.com with SMTP id cn20-20020a0564020cb4b029038d0b0e183fso3300097edb.22
        for <kvm@vger.kernel.org>; Sun, 16 May 2021 23:15:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QzynawLMKkiNCBVMSr0NbKElZSYcTMYLOczTr6TiqD0=;
        b=olEINlcxjlAeIU7ffCl5MYKM5BQeVlay2inFMRL+chNLHd9CsKYN+fzbSTXKIzEmRd
         VrzT75GLHHcOGoD7j4Ca5IFMXy2Ydko/E2zfBkI6ZDfuWHgeZBCWELOkovZOyRcrt5r8
         zcy2oIUvPbbQMxi/QVatwb6ugDPMFfZYopzLrXwWZlmHIxSZ1EelaLwJdINS0GBbnA58
         t6gzKzSUkvmRmdBdXt0KZU9jjraNwcFZr08L8teEqLHGGGFGdkpgMEobJPNzMWsRdxXo
         5UO5JqiyaKpaZEJUUmRgJnBAFwFUWc73598U3/k9eF4j+dZ7lAEHfJQZkA7WAuQ7NZF2
         DXUw==
X-Gm-Message-State: AOAM532qSjal8omfvz4KKUei9V62dJ55doJwKswsF6YlOmv9jsHrRpIh
        sr5waA41SVZHsKj634YXTnETbPFxIyicyaNooN8OLY2tO/cLPK/eyns/tqOWRVb7unQB9DaouUD
        vQdC6Os1iFKkR
X-Received: by 2002:a50:bec1:: with SMTP id e1mr69873349edk.116.1621232114197;
        Sun, 16 May 2021 23:15:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/GPYOfc8HS+Qk/My2kas8ha99HcGy2zDzV3bQqukH24e/vodE2x93NDUN+pbz54pTBDdv+w==
X-Received: by 2002:a50:bec1:: with SMTP id e1mr69873327edk.116.1621232114075;
        Sun, 16 May 2021 23:15:14 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id h9sm10259584ede.93.2021.05.16.23.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 23:15:13 -0700 (PDT)
Date:   Mon, 17 May 2021 08:15:12 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ignacio Alvarado <ikalvarado@google.com>
Subject: Re: [PATCH] KVM: selftests: Fix hang in hardware_disable_test
Message-ID: <20210517061512.tgaoivplzxbz2rmi@gator.home>
References: <20210514230521.2608768-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514230521.2608768-1-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 11:05:21PM +0000, David Matlack wrote:
> If /dev/kvm is not available then hardware_disable_test will hang
> indefinitely because the child process exits before posting to the
> semaphore for which the parent is waiting.
> 
> Fix this by making the parent periodically check if the child has
> exited. We have to be careful to forward the child's exit status to
> preserve a KSFT_SKIP status.
> 
> I considered just checking for /dev/kvm before creating the child
> process, but there are so many other reasons why the child could exit
> early that it seemed better to handle that as general case.
> 
> Tested:
> 
> $ ./hardware_disable_test
> /dev/kvm not available, skipping test
> $ echo $?
> 4
> $ modprobe kvm_intel
> $ ./hardware_disable_test
> $ echo $?
> 0
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  .../selftests/kvm/hardware_disable_test.c     | 32 ++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

