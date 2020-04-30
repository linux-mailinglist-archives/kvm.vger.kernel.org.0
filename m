Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1087A1BF6F4
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 13:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgD3LjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 07:39:02 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60023 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726053AbgD3LjC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 07:39:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588246740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5XeH1zPtAudcspM1wJQFHJHuK3vCR4Jr/YYiBf3rewU=;
        b=Vzx+jEIuGuMxwN0s2WVcHuNgn9ebkqLf3BIbkmk3I7B91hsH1jKDBi1ibUfpKYSt67FdEp
        gwh2xZtmVmGjfHAM7UJ890MnSKIodrm3TZcJjKfT3R9/Q4vsWMWj43YuIVRKu3qDzMKKN2
        lhc6DfTSfwVsrieAYnsoCF7wxnW0oJo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-2owZ14kaOlCi36dGuIimzA-1; Thu, 30 Apr 2020 07:38:58 -0400
X-MC-Unique: 2owZ14kaOlCi36dGuIimzA-1
Received: by mail-wm1-f71.google.com with SMTP id q5so714255wmc.9
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 04:38:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5XeH1zPtAudcspM1wJQFHJHuK3vCR4Jr/YYiBf3rewU=;
        b=p1It6c2WkFWSKNHwYfVgwwvjfQNEZrpXu7wsGny70wyd/ADeeICO0LEdzvJvyRSbMw
         TEMW6XscKmbfQUVKUxP8JMVmx+/rpqkjcM25n/jx+esn1jjomnb+u13SO+Qmonp+Kn+b
         1s4Yvg8rSK7hkozTTnXfnQ6mjt/SE+PS6KnAcHCnF4OKXquS1s6aeFxv/u7P0hKuUUCk
         HMwJnYng/2iVkq+JOFIfsfQV8Px0vVosi9iFvvHDUL8+fm7g7b25PmYKsJLpl6HXbflL
         kK5XExE6+sGuQvQiVLkHukpYi0rcHtYkowyL4uJ4BNbndlufHzAdZpWhGJJ2M2K1jnmc
         p38A==
X-Gm-Message-State: AGi0PuYA6U7W57dUGhQwUryOMikukbwCwV6xp86qrzrk6qKxuuKX0Fpw
        kTUbR4xWs87pjwBZ0jHN8pDvH9d+ugLJLABrkt4tNQ5awt2F/+cx//oOgmIiCubjG96N4+uV9l/
        0XpAAVJVOjf6N
X-Received: by 2002:a05:600c:20f:: with SMTP id 15mr2608839wmi.71.1588246737668;
        Thu, 30 Apr 2020 04:38:57 -0700 (PDT)
X-Google-Smtp-Source: APiQypIWUQGouBw/RA4IOXRL400gAdp6cpLXqBn3k1uo8PN7rELjejkXrBF6HPN93fNuSurU5FltdA==
X-Received: by 2002:a05:600c:20f:: with SMTP id 15mr2608811wmi.71.1588246737430;
        Thu, 30 Apr 2020 04:38:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac19:d1fb:3f5f:d54f? ([2001:b07:6468:f312:ac19:d1fb:3f5f:d54f])
        by smtp.gmail.com with ESMTPSA id z18sm3494422wrw.41.2020.04.30.04.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 04:38:56 -0700 (PDT)
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
 <095e3e9d-c9e5-61d0-cdfc-2bb099f02932@redhat.com>
 <602565db-d9a6-149a-0e1a-fe9c14a90ce7@amazon.com>
 <fb0bfd95-4732-f3c6-4a59-7227cf50356c@redhat.com>
 <0a4c7a95-af86-270f-6770-0a283cec30df@amazon.com>
 <0c919928-00ed-beda-e984-35f7b6ca42fb@redhat.com>
 <702b2eaa-e425-204e-e19d-649282bfe170@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d13f3c5c-33f5-375b-8582-fe37402777cb@redhat.com>
Date:   Thu, 30 Apr 2020 13:38:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <702b2eaa-e425-204e-e19d-649282bfe170@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/20 13:21, Alexander Graf wrote:
>> Also, would you consider a mode where ne_load_image is not invoked and
>> the enclave starts in real mode at 0xffffff0?
> 
> Consider, sure. But I don't quite see any big benefit just yet. The
> current abstraction level for the booted payloads is much higher. That
> allows us to simplify the device model dramatically: There is no need to
> create a virtual flash region for example.

It doesn't have to be flash, it can be just ROM.

> In addition, by moving firmware into the trusted base, firmware can
> execute validation of the target image. If you make it all flat, how do
> you verify whether what you're booting is what you think you're booting?

So the issue would be that a firmware image provided by the parent could
be tampered with by something malicious running in the parent enclave?

Paolo

> So in a nutshell, for a PV virtual machine spawning interface, I think
> it would make sense to have memory fully owned by the parent. In the
> enclave world, I would rather not like to give the parent too much
> control over what memory actually means, outside of donating a bucket of
> it.

