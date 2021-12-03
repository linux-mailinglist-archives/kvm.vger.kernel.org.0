Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD3146735E
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 09:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379250AbhLCIpZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 03:45:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1379251AbhLCIpX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 03:45:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638520919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6GZB4B1N+7654kHtpQfNF47RaDJVwe0bhDq5s6FRHyg=;
        b=RKnk/VC+UB4KX6FRQdz9/0Ei49OMNuOB82OgJiYQzA6jZ9cQox+b0k+2mdKYrihUYLpAAS
        DlaEmnnBEkmxe/Q4g/SBlHV3FzDYMp4J1k1SA70/iETNQRiKWWkQHvww17zoU2F4+TUm+o
        4Sxb50AADVSJNwltxnrr697Tgf9A1Bg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-S2NJFWt2OgmeMEnxvWkP-g-1; Fri, 03 Dec 2021 03:41:59 -0500
X-MC-Unique: S2NJFWt2OgmeMEnxvWkP-g-1
Received: by mail-ed1-f72.google.com with SMTP id v10-20020aa7d9ca000000b003e7bed57968so1891361eds.23
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 00:41:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6GZB4B1N+7654kHtpQfNF47RaDJVwe0bhDq5s6FRHyg=;
        b=qj+AaO5/vIi47j6MzHIp626ssv42JXAvNDdyaqQBQpf4idevoknT+4nbI5B1YSUhOa
         vqvJixG33Myx09XhJlgGWCOX0So+3AHlZ8usgtt/TudW1vT+ay9Mw9oSvONFuKP0EPCf
         xpwCJ6MD1XGNNwl7bgmgJ4HEhxZN0jZaAr/io46/h8joSxnf5Rddc6SYPFPYqQuMUjxo
         FbpWIqVzJ1HgBtnEhI1eP75R9pIWXimlWTQXAg5wjNZFLSwcppRy50mgsFMH50juAyNX
         QUkf+vnhS6h+khTsxaX80KU3LdTqGD3uL2jVjGwwzUxr/o1BXJPWrFuZojT9BfShZ0Sc
         1BxA==
X-Gm-Message-State: AOAM530YZlt2J0QHj7+uHs9+xe4Uhh045ZXhEA0ABid5yBsQcCANvH27
        vPpkXR2ITAVKUhlLpwQPzDlM278hUFhKZkJ61EYJObQONXsnuQ3WIkYsjoGYYENmBR+Z0OmjoN6
        DRryGiEXxOWgk
X-Received: by 2002:a17:907:2da5:: with SMTP id gt37mr22331296ejc.316.1638520917554;
        Fri, 03 Dec 2021 00:41:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzb/7LfnJkZdygdHrdv8Opu/P8GNBZ71fU2X1d4rvGa3jMNrBM7Vo1vtI9fJLdAjbdMVuP/5Q==
X-Received: by 2002:a17:907:2da5:: with SMTP id gt37mr22331277ejc.316.1638520917422;
        Fri, 03 Dec 2021 00:41:57 -0800 (PST)
Received: from [10.43.2.64] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id j17sm1535384edj.0.2021.12.03.00.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 00:41:57 -0800 (PST)
Message-ID: <63d013c1-bacf-2c06-896a-fd9c2b010653@redhat.com>
Date:   Fri, 3 Dec 2021 09:41:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v1 00/12] Add riscv kvm accel support
Content-Language: en-US
To:     Yifei Jiang <jiangyifei@huawei.com>, qemu-devel@nongnu.org,
        qemu-riscv@nongnu.org
Cc:     bin.meng@windriver.com, kvm@vger.kernel.org,
        libvir-list@redhat.com, anup.patel@wdc.com, wanbo13@huawei.com,
        Alistair.Francis@wdc.com, kvm-riscv@lists.infradead.org,
        wanghaibin.wang@huawei.com, palmer@dabbelt.com,
        fanliang@huawei.com, wu.wubin@huawei.com
References: <20211120074644.729-1-jiangyifei@huawei.com>
From:   =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>
In-Reply-To: <20211120074644.729-1-jiangyifei@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/21 08:46, Yifei Jiang wrote:
> This series adds both riscv32 and riscv64 kvm support, and implements
> migration based on riscv.

What libvirt does when detecting KVM support is issuing query-kvm
monitor command and checking if both 'present' and 'enabled' bools are
true. If this is what these patches end up with we should get KVM
acceleration in Libvirt for free.

Michal

