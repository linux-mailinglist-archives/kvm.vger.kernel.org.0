Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C27342EF81
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 13:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238411AbhJOLTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 07:19:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230434AbhJOLTd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 07:19:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634296645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PLWLkBQXMNGKBODhUxl5sJuJicKkC9lyNhKYr16226Q=;
        b=Blx0XZ2/Eu6mtYzHD4XwLS+3MU7ALmWpOsWbn0cCsPAX156hC4jV6l6PUfzwX0wUJOGFD3
        1PZ1whGz6Pg9CEzR9EUVg5Oqg5Z+szPCjHmfHyBq1BWS9oVFMXOmt7te1QCz24DbtXyqG0
        PD79Tg2mCqVX15wx9ViZ0FOs9OhFsy0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-la4B2sawPrm89_xf5P3PDw-1; Fri, 15 Oct 2021 07:17:24 -0400
X-MC-Unique: la4B2sawPrm89_xf5P3PDw-1
Received: by mail-ed1-f72.google.com with SMTP id u23-20020a50a417000000b003db23c7e5e2so7937086edb.8
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 04:17:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PLWLkBQXMNGKBODhUxl5sJuJicKkC9lyNhKYr16226Q=;
        b=fWDLs0AnB/NqpF2N1oFuNofcAEUWTL+R9KJosDFhq9PT/NHjTFduDEqFilynsSRR8A
         uADdzrtKjpNICubPOOLOHcSzBDrhpUF8UX7ki2DTWSti7sL5rq+2V6xH2HK78RlavJ1G
         2wVLKwiwh26ZtgCVhJf8Oc1Dc9FwcVPsm6iwWd9pGKXlT9uY1lTWXPUXrfiskj3E5JG4
         4ETARcAO8UrEgxBb9jKIbnbOdmf1OjaoOwNid7qrJ/satMYmR21VeyzilT+YkvRZE1e7
         30KgVu4iqY99Gqq8FJcA2tX/xGXG5NbRfKSZc4O0ebYEOCNds4gDWWHLdAO8VNX1iz2Z
         Upug==
X-Gm-Message-State: AOAM532q5Nt69pj8QYaaf/9FY7dsjvoWLa2bwRIEoCOBirfiUjzGKu+d
        UBAcub8KmyvoPHDZ7o2oaeXP2QGAmR8UnYdD/WEn5mo3hs+O0tNsNaDXvlKcljEs0riaCAETa1P
        DpL3sxXw9trJV
X-Received: by 2002:a17:906:bb0c:: with SMTP id jz12mr6007741ejb.455.1634296643042;
        Fri, 15 Oct 2021 04:17:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOEb5DQCjpld1lFtUIdW1j1M8acmXn5+T7Dk5kQK54CbcN1RiZW1b2pTtQEIQrCR7zp8jcUg==
X-Received: by 2002:a17:906:bb0c:: with SMTP id jz12mr6007728ejb.455.1634296642862;
        Fri, 15 Oct 2021 04:17:22 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z19sm3957128ejp.97.2021.10.15.04.17.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 04:17:22 -0700 (PDT)
Message-ID: <37923aa8-8d86-4409-7689-3fbf8ce8ae4f@redhat.com>
Date:   Fri, 15 Oct 2021 13:17:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
 <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
 <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com> <87wnmf66m5.ffs@tglx>
 <3997787e-402d-4b2b-0f90-4a672c77703f@redhat.com>
 <BYAPR11MB3256D90BEEDE57988CA39705A9B99@BYAPR11MB3256.namprd11.prod.outlook.com>
 <877dee5zpf.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <877dee5zpf.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/21 12:50, Thomas Gleixner wrote:
> That might be matching the KVM expectations, but it's not going to
> happen.
> 
> KVM already violates all well known rules of encapsulation and just
> fiddles in the guts of FPU mechanism, duplicates code in buggy ways.
> 
> This has to stop now!

FWIW, I totally agree about that.  Over the years we've gotten more 
well-thought hooks in the kernel for KVM and less hacks, and I'll only 
be happy if that extends to the FPU code which I'm quite wary of 
touching.  Most of it has been unchanged since Ingo's last rewrite.

Paolo

> You are free to ignore me, but all you are going to achieve is to delay
> AMX integration further. Seriously, I'm not even going to reply to
> anything which is not based on the above approach.

