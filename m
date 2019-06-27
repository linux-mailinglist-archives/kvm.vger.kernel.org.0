Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCAE5754B
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 02:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfF0ANa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 20:13:30 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33688 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfF0ANa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 20:13:30 -0400
Received: by mail-wm1-f66.google.com with SMTP id h19so5777893wme.0
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 17:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Q/9jviIAzluORLcW+/ggN45gWvtzFTX7RCAL2RDxTU=;
        b=odmf1rQmpF6BRPWqAMm/HD6RpkvLqanI/cA1zdfPm/rduj75PC/6rGxxvlY6LdH/JY
         kbQA7NR9SRMv0zR6A3wGgd2nxr08AbpWp3obgeO8YDUo4df1Vjgf6Yh0MPodXuakwzqQ
         E880z9Lyq2UO3pKqKAZDXvkhhkYLYFljK9eMOKc3vKYSAicBgqbJQv257QanQGDASoWA
         GtHA2TBlB0ne5oNlhvDvTxUFgzNr8ZTEC5J/GwRWc5DsJN7GLrDdgkA9xK3pk+Wq+kv+
         teFu3JqEOpIZYtgcJcQUAAvnjGmgvv1tM8qVEu+oJgrE3pTgytzqBJf1SBIdVqynfW+M
         ke1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Q/9jviIAzluORLcW+/ggN45gWvtzFTX7RCAL2RDxTU=;
        b=ayPzuUFgOovcsDeDvai+5SVos3QRkBiB/mohVG6liRdVxpXqUuuRHIyzG0gSDc5mCs
         wL7j7waunSjIQWwIey5qhTGEsN3BFE3hyRMTC13xGXsyKiCglZyliT7win2VGM9FM7bo
         NnxNY5Uc+yDv6h8x5D1s06A52eNm1D+ZWnuN/pDcb4+UAIFiIMF4Dug4Eg9DJib5fZB8
         4kWrpH5LSlhXVIq4qkquwcWoVgVducV59weiTi5pQo3altLuzX1su/WD7QwwdDNcv2iu
         ncmDbx4lYcVbmvEbTuHVbrhmCobLhaCIsc6g2TMHtkXjqgWYE23cDJ/h70kf+4HUHcr5
         dqdQ==
X-Gm-Message-State: APjAAAUF5G3xspwLdXy3PdbD0y4KUg3SRtz8emDOC8goRpMlVrADVNwe
        scJc1i0gXualBLQF8zdniVDx96qchvdxxxKWRQ5o5Q==
X-Google-Smtp-Source: APXvYqxcyQYwJ/lXkmZFvmxIwqjtkC5jbVv13IpphJY1rGUfTHasxyE4psPkH9NESCV+6Hxp1ccc3IcymD+mRTSSUQE=
X-Received: by 2002:a7b:c766:: with SMTP id x6mr935811wmk.40.1561594407854;
 Wed, 26 Jun 2019 17:13:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190625120627.8705-1-nadav.amit@gmail.com>
In-Reply-To: <20190625120627.8705-1-nadav.amit@gmail.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 26 Jun 2019 17:13:16 -0700
Message-ID: <CAA03e5Hfe0e1=Z_ODOLsL4=aJZTinGkbatyFjDcNRTwS5Q8qyw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Mark APR as reserved in x2APIC
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 25, 2019 at 12:28 PM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> Cc: Marc Orr <marcorr@google.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  lib/x86/apic.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/lib/x86/apic.h b/lib/x86/apic.h
> index 537fdfb..b5bf208 100644
> --- a/lib/x86/apic.h
> +++ b/lib/x86/apic.h
> @@ -75,6 +75,7 @@ static inline bool x2apic_reg_reserved(u32 reg)
>         switch (reg) {
>         case 0x000 ... 0x010:
>         case 0x040 ... 0x070:
> +       case 0x090:
>         case 0x0c0:
>         case 0x0e0:
>         case 0x290 ... 0x2e0:
> --
> 2.17.1
>

Reviewed-by: Marc Orr <marcorr@google.com>
