Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF405D525
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 19:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfGBRYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 13:24:12 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39875 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGBRYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 13:24:12 -0400
Received: by mail-wm1-f66.google.com with SMTP id z23so1888263wma.4
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 10:24:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tSdfGWpkKiR9chGQWIgEIfNwYfRToOGumwXKg1V51Yo=;
        b=SkTHs/KPreD0+Lcitkr8d02b2ijt00jsJh7u+c+HVf04eznhfCmQxRpiSQbqdDZaTy
         MoCt9rAaXT9GMJ0P5o+qkED18g0kxt242jeFtG1miriUF5fEj9w7BwjP/jQtmILt0tgY
         utR7KzBlGXQF/8/38qlalJ0Rp3RD6dJLvDUqDyHm6/VtQUJfmMDIkpLyfJJVOjvDB3mQ
         hqkzW3x6Uh/zETMO0o7o9tDPYPTAUyss0NlK78tOB42LCoyOpb/3jHeqQRpvrAg13j/W
         5UGybucmJ7WNBwy84u+/FVPgKjvySdB0siR4rddoPFtTIdjjauTANsA7cf8GtdSUb170
         YLfg==
X-Gm-Message-State: APjAAAVKhEATtcenf1sVFl5fTai/dXH4TxhM7qUzL+VjJwK70PB9xokS
        7WuMpFQpDpoPrqhub+xV1F9oE/3Yr+0=
X-Google-Smtp-Source: APXvYqxLs9O+ZcWl73+pFmPRN+rKjt8aJQupGBefkBsqJAU2Jlbb86l4xKGuX0exkU69g2T/hhj/4g==
X-Received: by 2002:a1c:407:: with SMTP id 7mr4385371wme.113.1562088250828;
        Tue, 02 Jul 2019 10:24:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id w20sm30366656wra.96.2019.07.02.10.24.10
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 10:24:10 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Support environments without
 test-devices
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org
References: <20190628203019.3220-1-nadav.amit@gmail.com>
 <20190628203019.3220-4-nadav.amit@gmail.com>
 <2e359eb2-4b2a-0a52-6c43-cd6037bb72ae@redhat.com>
 <F3480C92-28D8-470A-9E34-E87ECCE4FDD1@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <73f56921-cb61-92fa-018a-5673e721dbef@redhat.com>
Date:   Tue, 2 Jul 2019 19:24:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <F3480C92-28D8-470A-9E34-E87ECCE4FDD1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/07/19 18:43, Nadav Amit wrote:
>>> Remember that the output goes to the serial port.
>>
>> RAM size can use the multiboot info (see lib/x86/setup.c).
> 
> The multiboot info, as provided by the boot-loader is not good enough as far
> as I remember. The info just defines where to kernel can be loaded, but does
> not say how big the memory is. For that, e820 decoding is needed, which I
> was too lazy to do.

The multiboot info has both e801 memory size and e820 memory map info.
e801 is basically the first contiguous chunk of memory below 4GB, it
should be enough for kvm-unit-tests.

>> For the # of CPUs I'm not sure what you're supposed to do on bare metal
>> though. :)
> 
> I know you are not “serious”, but I’ll use this opportunity for a small
> clarification. You do need to provide the real number of CPUs as otherwise
> things will fail. I do not use cpuid, as my machine, for example has two
> sockets. Decoding the ACPI tables is the right way, but I was too lazy to
> implement it.

What about the mptables, too?

Paolo

