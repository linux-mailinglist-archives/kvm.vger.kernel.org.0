Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F503C9210
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 22:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhGNU1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 16:27:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230004AbhGNU1o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Jul 2021 16:27:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626294292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bCsP/PPqNxIIYG5LcyFgwlQyKhjOkaw7+xl85j07Jcw=;
        b=g+3A0EUlncJ6eyl66kIV7WoGxPaRkUVWFyCX2CTkgGarYgLt80Xbt9Z4yHKbcghUtSCZw6
        +RcS1S052A5rN6xzDlspFdkaV3YhbNuOejqCDsLcHhnvAcvEZrOsPD1wc4kSNsT59hoUTI
        XgxThk5jv3gJP0C9UozmKPrx5WWLsxk=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-n7jvE_RDPI2_EzTmCsYD_w-1; Wed, 14 Jul 2021 16:24:50 -0400
X-MC-Unique: n7jvE_RDPI2_EzTmCsYD_w-1
Received: by mail-il1-f198.google.com with SMTP id c7-20020a92b7470000b0290205c6edd752so1800546ilm.14
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 13:24:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bCsP/PPqNxIIYG5LcyFgwlQyKhjOkaw7+xl85j07Jcw=;
        b=W/eyrwJ/62LgmaOurvssgHZuGsb1MuIqQx5YwC4vD1zbPpuDro1vfO0Rqpqam/ELgP
         SAg2JVjDQX6vPMyPMPr3wRFLWixL2fbIUz8YNmJVFJj65RmkPvuVodE82SisGFFgFoKG
         ICCdEhWwTyaJCXTiu2Q8inBuzvb25F7iD3do6buNxqdWwVOgJvN3mrMvyY8poO8Deawi
         pDlrYGu6ORg8IWcgSWyGXDWlWqHWJjM7vTVe+e7Y1ZaQ4B1Rn3/3pYDpn7f5NqbSeZXO
         jRfmNszdBIFebrrlH8jktg7ovmUoNGDmZ1DBBK7TDV24v7d90PEPtYVh2tTMjkxVUFcN
         pINw==
X-Gm-Message-State: AOAM532z4ddX4OUr4RlBaa4Hr/JTRWrXgRX6uvC48tgC+KlG8NlsGlKq
        nOQRwVbfOmJDXk+lE4OYMuxZVVJeuBvWljVpeJJOBjWMTnFCzlGVe7wpM/FTD4juVh4ZeiOQwVO
        JtyfavYSu6X5z
X-Received: by 2002:a02:956a:: with SMTP id y97mr83533jah.58.1626294290402;
        Wed, 14 Jul 2021 13:24:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWWW7j35CQALLyAjFwuPMrImvoSzeW3bB28/6/oA8a7KLtco7nRvKEmS19cDh1k577GdXDwA==
X-Received: by 2002:a02:956a:: with SMTP id y97mr83523jah.58.1626294290219;
        Wed, 14 Jul 2021 13:24:50 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id d8sm1827659iom.49.2021.07.14.13.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 13:24:49 -0700 (PDT)
Date:   Wed, 14 Jul 2021 22:24:47 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] Avoid backticks, use $() instead
Message-ID: <20210714202434.24ji4jqrgcj7kt4a@gator>
References: <20210622091237.194410-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622091237.194410-1-thuth@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 22, 2021 at 11:12:37AM +0200, Thomas Huth wrote:
> The backticks are considered as bad style these days, e.g. when checking
> scripts with https://www.shellcheck.net/ ... let's use the modern $()
> syntax instead.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  configure             |  2 +-
>  run_tests.sh          |  2 +-
>  scripts/arch-run.bash | 10 +++++-----
>  3 files changed, 7 insertions(+), 7 deletions(-)

Applied to misc/queue

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/misc/queue

Thanks,
drew

