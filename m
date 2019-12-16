Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 894431206B2
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 14:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727757AbfLPNLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 08:11:31 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38763 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727402AbfLPNLb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Dec 2019 08:11:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576501890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FXYYP7m5x86Bk37M1YJB4xh6R0fOUNpBlIMCqcUij+E=;
        b=YOwSkv3hwTn52Q8KmzcMXD8vTB5bvikw2DHtbMr6UQeiL/s5Ki8nnsdAJnRUu4A//mwMkQ
        A7GaIh9KDhHn3MOOzZRSCFPazwgREBcA0nVIRMcI/hu7euBzzO+IItOlarPmO5gD/n65LX
        lIVNFZ/wmql0GiYb3sCHnEvTJQJT8cY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-_-lpanDvMc6GvzWYHzrsJA-1; Mon, 16 Dec 2019 08:11:29 -0500
X-MC-Unique: _-lpanDvMc6GvzWYHzrsJA-1
Received: by mail-wr1-f70.google.com with SMTP id d8so3043031wrq.12
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 05:11:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FXYYP7m5x86Bk37M1YJB4xh6R0fOUNpBlIMCqcUij+E=;
        b=q3i9lHf8NDOMLOoN/VXWe/gHTpge/4dyXf4vOjVJybOJE4bfC0W9LlZekdb0arcpZ+
         R011RjqCqS3jgTYVQAO0+kdTwGXrDLu81TalOC0Zc0PgkolhyNuJQbjQmn12F2oYo7mN
         UNsZJ/CewR5if75c3o/fi5q19YH05qTzGwa3dNoWAJ8juw79I6sSU9WuuNSkYCPdXgb6
         DTRMP6lL/fs8h780xsu505OGhYLnhDSkVRA+rcMMe2Qe2OcoRzAiGsTFwKtT+x+iFn0f
         is4hGH0ZqmuJbmuXUCyd4y8M5tE4w7ib7qYMzkhSXwgySL0D6B10plffUS1Chns7GFAs
         gCFA==
X-Gm-Message-State: APjAAAUH4zgRqcUnRucK3kYBT42+k/droeSTRZpJpUG6w+fCIJBBOnMt
        GFVu+4emWhEtAK8d6f8/Nc6Fr6izOT7aIGKqFkvIIceZMhIJeDpAN1I20oxUN5iBLQ6bEve1CcC
        c0X89oErtiiOf
X-Received: by 2002:a1c:8086:: with SMTP id b128mr30614676wmd.80.1576501887766;
        Mon, 16 Dec 2019 05:11:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqxdE9VroDhn6zSvqLM+CRCLzGyJou2Umxg4Ryp4vAVu7qRvR4LrFZvhR++1aIuoI0i+slJgYw==
X-Received: by 2002:a1c:8086:: with SMTP id b128mr30614636wmd.80.1576501887535;
        Mon, 16 Dec 2019 05:11:27 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:cde8:2463:95a9:1d81? ([2001:b07:6468:f312:cde8:2463:95a9:1d81])
        by smtp.gmail.com with ESMTPSA id d16sm23348661wrg.27.2019.12.16.05.11.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 05:11:27 -0800 (PST)
Subject: Re: [PATCH 05/12] hw/i386/ich9: Remove unused include
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     John Snow <jsnow@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-block@nongnu.org, Richard Henderson <rth@twiddle.net>,
        xen-devel@lists.xenproject.org, Sergio Lopez <slp@redhat.com>
References: <20191213161753.8051-1-philmd@redhat.com>
 <20191213161753.8051-6-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4f195401-f896-75cd-f590-0c1f4bd6c46f@redhat.com>
Date:   Mon, 16 Dec 2019 14:11:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191213161753.8051-6-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/12/19 17:17, Philippe Mathieu-Daudé wrote:
> The "pcie_host.h" header is used by devices providing a PCI-e bus,
> usually North Bridges. The ICH9 is a South Bridge.
> Since we don't need this header, do not include it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  include/hw/i386/ich9.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/hw/i386/ich9.h b/include/hw/i386/ich9.h
> index 72e803f6e2..eeb79ac1fe 100644
> --- a/include/hw/i386/ich9.h
> +++ b/include/hw/i386/ich9.h
> @@ -7,7 +7,6 @@
>  #include "hw/isa/apm.h"
>  #include "hw/i386/ioapic.h"
>  #include "hw/pci/pci.h"
> -#include "hw/pci/pcie_host.h"
>  #include "hw/pci/pci_bridge.h"
>  #include "hw/acpi/acpi.h"
>  #include "hw/acpi/ich9.h"
> 

Queued, thanks.

Paolo

