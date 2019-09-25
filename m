Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3077BBDAF9
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 11:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731821AbfIYJ34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 05:29:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40972 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731740AbfIYJ34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 05:29:56 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6F34D12A2
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 09:29:55 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id t11so2046031wrq.19
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 02:29:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XdCyxypkTILYxxil0UhO8du5NnWEbx8LxbROXgsSMwg=;
        b=N2aazK9H3RpXzVilPqJH0dO32FznsDRGrhtHHL5C8I/C8wTsmBhri2UWmERGKSV0PB
         nSk7vAxGkjNZBRjGIAA9V8WB9IyZaKCljOFNT+wYU+2rIxKIA9AVasNHhxl3GzPy6+KX
         +aI9G7Q7ZezfX9/7p6l7nDTo8fNBWufbGeXy1xVyU4CQxX4tz5wiG/QjT+Mm0nY4OGT0
         S9VMaHNV0iOiJ6xsHpb3wJ+uHwVD6FO5enpBslAm8xdZvl7LOJ7m83iS2dxr1KDzC8Yt
         fT37rizq81E8yHPAmSP71XTvPPWyiywW9vF/a+sIYk7Th1P5wPhsL4ZTOBSnQxRO/BZm
         KUsw==
X-Gm-Message-State: APjAAAXhjMTn+gnoV4i6y93VB6JVzTvo4dKylRfyTTMYv1xxJ9KgRiZH
        hvRMNmBcdD5bRU1HguBlEuUCvOCQgHLeHuRkHxn5sjCPp/eAe7iIKDygvZf2G/04p/otFvfcsBB
        fPqG4DO6gqgdF
X-Received: by 2002:a05:600c:248a:: with SMTP id 10mr6504123wms.97.1569403793886;
        Wed, 25 Sep 2019 02:29:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwM7Grp5b8CHzOYJry57kiiBqUsG7R+SwPYWG/hlDKUI7a9TdSXAhvU+EEvgBUpurnzZWA5Ig==
X-Received: by 2002:a05:600c:248a:: with SMTP id 10mr6504083wms.97.1569403793607;
        Wed, 25 Sep 2019 02:29:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id g1sm2756164wrv.68.2019.09.25.02.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 02:29:52 -0700 (PDT)
Subject: Re: [PATCH v4 0/8] Introduce the microvm machine type
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Sergio Lopez <slp@redhat.com>,
        David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org,
        mst@redhat.com, imammedo@redhat.com, marcel.apfelbaum@gmail.com,
        rth@twiddle.net, ehabkost@redhat.com, philmd@redhat.com,
        lersek@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        Pankaj Gupta <pagupta@redhat.com>
References: <20190924124433.96810-1-slp@redhat.com>
 <c689e275-1a05-7d08-756b-0be914ed24ca@redhat.com> <87h850ssnb.fsf@redhat.com>
 <b361be48-d490-ac6a-4b54-d977c20539c0@redhat.com>
 <20190925091225.bx4c4x2o6qgydidj@sirius.home.kraxel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8fa274c8-6bb7-bf88-7715-bb23f5dfb7de@redhat.com>
Date:   Wed, 25 Sep 2019 11:29:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190925091225.bx4c4x2o6qgydidj@sirius.home.kraxel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/19 11:12, Gerd Hoffmann wrote:
>   Hi,
> 
>> If you want to add hotplug to microvm, you can reuse the existing code
>> for CPU and memory hotplug controllers, and write drivers for them in
>> Linux's drivers/platform.  The drivers would basically do what the ACPI
>> AML tells the interpreter to do.
> 
> How would the linux kernel detect those devices?
>
> I guess that wouldn't be ACPI, seems everyone wants avoid it[1].
> 
> So device tree on x86?  Something else?

Yes, device tree would be great.

> [1] Not clear to me why, some minimal ACPI tables listing our
>     devices (isa-serial, fw_cfg, ...) doesn't look unreasonable
>     to me.

It's not, but ACPI is dog slow and half of the boot time is cut if you
remove it.

> We could also make virtio-mmio discoverable that way.

True, but the simplest way to plumb virtio-mmio into ACPI would be
taking the device tree properties and representing them as _DSD[1].  So
at this point it's just as easy to use directly the device tree.

Paolo

[1]
https://kernel-recipes.org/en/2015/talks/representing-device-tree-peripherals-in-acpi/
