Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8096A449E51
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 22:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240466AbhKHVkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 16:40:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28883 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238291AbhKHVkk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 16:40:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636407475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kEYcui9/ibB8xQH8a7gM67TyBzGReF+v9iXxkCWd8B4=;
        b=MVUY7gN71YThulYM7HnekoFJqKLmTZM9H5MRF+e27ASnq9cEjD+DpNvaGg6Z//Fqm2encg
        rAojOrEeS5+x/2a+t15yR76+/IvyxuvFbTYt4Y+OZIZOWbifQ1KXXDiQqkdiNgG91Gn3mw
        TH5t9AgHk4B14mfIHZKbVUV246R4CWA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-FIarCHUdOtC4Ro_UcdYI2Q-1; Mon, 08 Nov 2021 16:37:54 -0500
X-MC-Unique: FIarCHUdOtC4Ro_UcdYI2Q-1
Received: by mail-ed1-f72.google.com with SMTP id z21-20020a05640240d500b003e3340a215aso5125414edb.10
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 13:37:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kEYcui9/ibB8xQH8a7gM67TyBzGReF+v9iXxkCWd8B4=;
        b=pEekz2Q473VXgcu0MIGlsrhn2mE04VxwKGkEK8+zjRzQvbyMJKTu/l7Zgxnm7qewff
         fp/pQD9MAL1BwXisAJOWMSGXtbxwqYQhl1no6KA4vr8MtVw0ZY6PI36wGLdsNilz/x+E
         O4/aSoplL+LEKlv2duKFBQJcyXNfWGtM4n9uQ8O1PH+1C8s0ycxNXnFDw+Cz8F6tztD2
         FA3sqS0wdral1mULXESmAkE67z4wlfxBYIMxUsKKgF5BLitMl/4aZt6qD07kIJCnyl1K
         Zq6J+SAHgKul1QCCLHbKqCr9u1NamKt59EBaiRe619U9n0gW56emI1mKzKHnQSw0lyfo
         GeAw==
X-Gm-Message-State: AOAM532Os60Q6pSLTbS70Ja/W2hEJRjuaJAn7ZiuhZ5Zj/hEhE1TVXvE
        fLxcbLDH/5CyeJ7HcX0MCG8R7VS3L+98yjnCUTGunDTgDGJv1zzjF5vHmTL7JRECYWRnnkZ/uv0
        wbE2alj8/8sRR
X-Received: by 2002:a05:6402:27cd:: with SMTP id c13mr2962345ede.365.1636407473336;
        Mon, 08 Nov 2021 13:37:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwY0ttKe3rWZ2r9QhW9fmevF1+KojcowYXZ9CDgS9/umobI2M831kaVSzZthf0PekVN2j+6Ag==
X-Received: by 2002:a05:6402:27cd:: with SMTP id c13mr2962313ede.365.1636407473144;
        Mon, 08 Nov 2021 13:37:53 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id gs17sm3679857ejc.28.2021.11.08.13.37.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 13:37:52 -0800 (PST)
Message-ID: <ba65851f-4f03-e5e2-ac88-139d9b48d44c@redhat.com>
Date:   Mon, 8 Nov 2021 22:37:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: RFC: KVM: x86/mmu: Eager Page Splitting
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
References: <CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com>
 <c9bd3bca-f901-d8db-c23d-5292ab7bd247@redhat.com>
 <YYmBMGvU/kthFiM9@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YYmBMGvU/kthFiM9@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/8/21 20:57, David Matlack wrote:
>> I'm not super
>> interested in adding eager page splitting for the older methods (clear
>> on KVM_GET_DIRTY_LOG, and manual-clear without initially-all-set), but
>> it should be useful for the ring buffer method and that *should* share
>> most of the code with the older methods.
> 
> Using Eager Page Splitting with the ring buffer method would require
> splitting the entire memslot when dirty logging is enabled for that
> memslot right? Are you saying we should do that?

Yeah, that's why I said it should share code with clear-on-get-dirty.

For initially-all-set, where it's possible to do it and even easy-ish, I 
would like to avoid paying the cost of splitting entirely upfront, when 
enabling dirty page tracking.  But you can already post an RFC that just 
splits always when dirty page tracking is enabled, so that I have a bit 
more of an idea of the new code, and of what it would entail to smear 
the cost over the calls to KVM_CLEAR_DIRTY_LOG.

Thanks,

Paolo

