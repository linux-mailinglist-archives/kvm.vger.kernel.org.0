Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85741E676C
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 18:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404986AbgE1Q3w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 12:29:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40272 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404926AbgE1Q3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 12:29:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590683389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YaE0Z0J9Xl8bXh8Z1QFNehOXrm7ji22swhNoBCR/M5I=;
        b=MAzrJuVSWUhkFWIHhV6qkho2HXscsEGFL6XZKMgjPY1aqOEDNxlU9lrMnG3kOZUJeCCDDQ
        LtqwTLBDfxkOPf6wfcAl0Y5IgjrXwM1ZSJad138TGpyrt3PHGKFbCYTZzfTZ/YPLuuWWxN
        nqN7Lh4MYlucliQ3H6bP0P7jiFLphKY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-Dx3RY288PNOWSzKm2JpRrA-1; Thu, 28 May 2020 12:29:47 -0400
X-MC-Unique: Dx3RY288PNOWSzKm2JpRrA-1
Received: by mail-wr1-f71.google.com with SMTP id t5so271724wro.20
        for <kvm@vger.kernel.org>; Thu, 28 May 2020 09:29:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YaE0Z0J9Xl8bXh8Z1QFNehOXrm7ji22swhNoBCR/M5I=;
        b=C35KKdLy4Yu98/rHEzq0jHhI1/Uwi5GTKMRj27/qI1452QN1j0KIubDrCyJt/E9sXY
         dHQyCK6uLxU1tMF6YwLoLyqAuWvlA4ZcJIohpQXRT7Sn5D+XneSxToybMEqgDdC706U+
         mfswmcXxQN1ZPGdKRSc0cvlHF3ytDwcuJaOki9uc6M3zG8IpWx2NHsouh6IMh/J51rP7
         e36r14j0x5eBMWIaKnQK3OuHWfsea9stDvYnk6tU1DYUvccDRl7SKb+bQeRrpQ5ROkfm
         XEl/TxCRk3uN+tZhLtgkEp5stt7TW0C07SReez6ypq8X7Bqdr1UB1fjmHAvwo/U6ZMAe
         j+pw==
X-Gm-Message-State: AOAM531a96DRF9+MyV4jMy8s7SIrUQR/J+jqH7k1HkWBdqRryGDYAEZ2
        p4VK3Bl4jkzYNoRlZjFrAfdcFBktGn8GYV/omh/TUswJkAkQUi4XsK+6VocCAh+PLCJOw7cYHoj
        5Koyb9stRaiAi
X-Received: by 2002:a1c:ba86:: with SMTP id k128mr3593691wmf.19.1590683386229;
        Thu, 28 May 2020 09:29:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxN6dd+mcaubqeRGsL0ucW1WQRaaVrp7grWaIvcYfB7iE3HfsafBln61gpKpSB7XgwRaPAEYg==
X-Received: by 2002:a1c:ba86:: with SMTP id k128mr3593683wmf.19.1590683386057;
        Thu, 28 May 2020 09:29:46 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 10sm7354175wmw.26.2020.05.28.09.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 09:29:45 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests] access: disable phys-bits=36 for now
In-Reply-To: <20200528124742.28953-1-pbonzini@redhat.com>
References: <20200528124742.28953-1-pbonzini@redhat.com>
Date:   Thu, 28 May 2020 18:29:44 +0200
Message-ID: <87d06o2fbb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Support for guest-MAXPHYADDR < host-MAXPHYADDR is not upstream yet,
> it should not be enabled.  Otherwise, all the pde.36 and pte.36
> fail and the test takes so long that it times out.
>
> Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  x86/unittests.cfg | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index bf0d02e..d658bc8 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -116,7 +116,7 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
>  [access]
>  file = access.flat
>  arch = x86_64
> -extra_params = -cpu host,phys-bits=36
> +extra_params = -cpu host
>  
>  [smap]
>  file = smap.flat

Works both VMX and SVM, thanks!

Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

