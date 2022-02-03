Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F7A4A827E
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 11:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiBCKjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 05:39:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29914 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229938AbiBCKjL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 05:39:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643884750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZU2hQlwm8ZITkE014YQsnffx0TQv/CDRydtKMinCyWg=;
        b=GWKEcahWWiCUR4EnTQ+oefXaY2xe0m6wzBmjTlHOD7s4z4AVsEDR0OYakb1bsP8xNB9R9v
        gs97WnfB6uDsYovfpskWeA9/eQh+n1Xepflcqs1wxvJ6Z1iuluTR+9G9eNk+UqW182x1TB
        62Dsvk8YY1B8+ZI7yu5aKwqrI/k2d5s=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-Qv1qh8q8Np-_T3B19wpnpg-1; Thu, 03 Feb 2022 05:39:09 -0500
X-MC-Unique: Qv1qh8q8Np-_T3B19wpnpg-1
Received: by mail-ej1-f70.google.com with SMTP id rl11-20020a170907216b00b006b73a611c1aso966937ejb.22
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 02:39:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZU2hQlwm8ZITkE014YQsnffx0TQv/CDRydtKMinCyWg=;
        b=Pfcy9T7kw+vYYyGAW1gMSL+9AM0VF+K+4NB0ybAdvEFx3CdAak0uWN05XgbCw7mLlz
         4GSespwLTF4mnzs9lMqqSluPY72b8mQZw0jlGKNmHnA/sLMfHU+x1ATvvR5asYBxJphV
         VbbEnSa2HFH/nZP+X+rKT1BY6RXd/Q9BS6O5B1VIcP/HImeFxkN7948OvkWd+vbNdR01
         r1eNv1lHeyJCcUTILR4SkhI/NfUiU2OU4gHAp68LYPX55+F1nKgI40mfn4IC/IycOKSe
         O4f/sOWXgYx4qQiR7jOSARnLqTDUTZJEwGzvGC8ko3MXvKW7a3JOWVKaH2a1cpajjkUt
         tpuQ==
X-Gm-Message-State: AOAM5326V8exvST1aILz/fghVoLcawi+b0Zc9KNOT54+6egY+PPLXntD
        Fh7sv2A5V6r99GfQpM8AGVHE4qJmqhe3E98s5bQRnoM+oRX7Fap+EqRYP3iWUC2PYPcHgfUTVND
        o1xmMU/TmupjN
X-Received: by 2002:a17:906:58ca:: with SMTP id e10mr28351530ejs.747.1643884748425;
        Thu, 03 Feb 2022 02:39:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwKs+aSJvdcjbzyefZcODa3xJFx8vm3Ss3xSl2n1IOj95dcAGAXZsV3zQvJcOBmAMoellGPSw==
X-Received: by 2002:a17:906:58ca:: with SMTP id e10mr28351495ejs.747.1643884748180;
        Thu, 03 Feb 2022 02:39:08 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id h1sm21709716edz.64.2022.02.03.02.39.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 02:39:07 -0800 (PST)
Message-ID: <f3be1081-e7df-20ab-9706-29f4b7d61bbc@redhat.com>
Date:   Thu, 3 Feb 2022 11:39:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 0/4] KVM: SVM: nSVM: Implement Enlightened MSR-Bitmap
 for Hyper-V-on-KVM
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
References: <20220202095100.129834-1-vkuznets@redhat.com>
 <429afd81-7bef-8ead-6ca4-12671378d581@redhat.com> <87czk4b7m2.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87czk4b7m2.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/22 10:51, Vitaly Kuznetsov wrote:
> Would it be possible to squash the attached patch in? Thanks!

Yes, of course.  Tests FTW. :)

Paolo

