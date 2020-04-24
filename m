Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5001B7B90
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 18:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgDXQ1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 12:27:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57742 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726908AbgDXQ1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 12:27:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587745673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sqa2zwpSHX/aXBjtwrDIW+4Ig2oY54LeCCkYHCPqKQY=;
        b=HG3KGu6ivtxLwQiNFW8P0B5jjTxX3+h13NXncHKTg+3kuJwnAxOzoVne+ddBxe+yan0TlS
        xhmT4HsE5DdgLon/EbTIn8HofMwYDl7ZUFz9beT3m+RtuLB6V3avjnw7DErigcMEeYVt48
        nhmjT8VZJnXAedBlICGtybPI+orZ3Wg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-flM2cS70OheOlr7uCaAt8A-1; Fri, 24 Apr 2020 12:27:51 -0400
X-MC-Unique: flM2cS70OheOlr7uCaAt8A-1
Received: by mail-wm1-f72.google.com with SMTP id h22so4052041wml.1
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 09:27:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sqa2zwpSHX/aXBjtwrDIW+4Ig2oY54LeCCkYHCPqKQY=;
        b=PCtbBU1AMisz/gTVYQwU3OiVw9YSqTK+CLtfZzD4irbprheRWv6pGXyhaJyHpZtb3G
         uOJtcYomJXeCo0aK5lxDTzYF3GuB3ENrJldYvb+GW0/+mua1MyjQtiPE0N9hsNX7bHfj
         ePRfk4eXSyVce67CCOB5PAUUTRcLjjsrR+L6U7btzRPDCeadgjtQyQYHl34vdHVe2dJk
         mIM3UZSk9tK1P2AMgxf2Yf83x4NXAz5DuhbmABoP59b0JBoz57AfVZeqI0uDwvjempNF
         Mp3OlR8mDb0G94MYVb6ssHifGpPGhGtva6hw18XdrPiWN1EEP6P1ZuQIEeTi2W6pzcBj
         GOsA==
X-Gm-Message-State: AGi0PuaPJMEOg4vc8UzdRwjeW9g269glvyJVHlh1A9x754fx/ekBnozq
        dGXsD4UIHZMmMdrzxqPz9Cd5nHVOngDrVzel+TPI4EYvBDtDGPCLGon/7PSfIFqNGT5Zc4BKDCZ
        B2LmweoPJzuP5
X-Received: by 2002:adf:f1c6:: with SMTP id z6mr4968441wro.361.1587745670672;
        Fri, 24 Apr 2020 09:27:50 -0700 (PDT)
X-Google-Smtp-Source: APiQypIHstS4mrgHIDeQ+fTnoYDfe+UHEdeBZBtwXAhvHQPJTVKOCiAjlm0h5Fan95TAEh8l+gYMmg==
X-Received: by 2002:adf:f1c6:: with SMTP id z6mr4968408wro.361.1587745670416;
        Fri, 24 Apr 2020 09:27:50 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id y10sm3443488wma.5.2020.04.24.09.27.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 09:27:49 -0700 (PDT)
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     Alexander Graf <graf@amazon.com>,
        "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
        linux-kernel@vger.kernel.org
Cc:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <2a4a15c5-7adb-c574-d558-7540b95e2139@redhat.com>
 <1ee5958d-e13e-5175-faf7-a1074bd9846d@amazon.com>
 <f560aed3-a241-acbd-6d3b-d0c831234235@redhat.com>
 <80489572-72a1-dbe7-5306-60799711dae0@amazon.com>
 <0467ce02-92f3-8456-2727-c4905c98c307@redhat.com>
 <5f8de7da-9d5c-0115-04b5-9f08be0b34b0@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <095e3e9d-c9e5-61d0-cdfc-2bb099f02932@redhat.com>
Date:   Fri, 24 Apr 2020 18:27:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <5f8de7da-9d5c-0115-04b5-9f08be0b34b0@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/04/20 14:56, Alexander Graf wrote:
> Yes, that part is not documented in the patch set, correct. I would
> personally just make an example user space binary the documentation for
> now. Later we will publish a proper device specification outside of the
> Linux ecosystem which will describe the register layout and image
> loading semantics in verbatim, so that other OSs can implement the
> driver too.

But this is not part of the device specification, it's part of the child
enclave view.  And in my opinion, understanding the way the child
enclave is programmed is very important to understand if Linux should at
all support this new device.

> To answer the question though, the target file is in a newly invented
> file format called "EIF" and it needs to be loaded at offset 0x800000 of
> the address space donated to the enclave.

What is this EIF?

* a new Linux kernel format?  If so, are there patches in flight to
compile Linux in this new format (and I would be surprised if they were
accepted, since we already have PVH as a standard way to boot
uncompressed Linux kernels)?

* a userspace binary (the CPL3 that Andra was referring to)?  In that
case what is the rationale to prefer it over a statically linked ELF binary?

* something completely different like WebAssembly?

Again, I cannot provide a sensible review without explaining how to use
all this.  I understand that Amazon needs to do part of the design
behind closed doors, but this seems to have the resulted in issues that
reminds me of Intel's SGX misadventures. If Amazon has designed NE in a
way that is incompatible with open standards, it's up to Amazon to fix
it for the patches to be accepted.  I'm very saddened to have to say
this, because I do love the idea.

Thanks,

Paolo

