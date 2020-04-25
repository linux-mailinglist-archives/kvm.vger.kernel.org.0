Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F8B1B8428
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 09:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgDYHVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 03:21:31 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40780 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726059AbgDYHV3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 25 Apr 2020 03:21:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587799288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GLnr0m2mVETKPeWfL0iYJ5elKQI3FKKirhJwNjsAap0=;
        b=SfBQY2dx0EvbNRs7mH1VQ9iFK6AhdVlOkEU7SWiDaJzL855SsHDcJITZmJXhfy3A4Z4msD
        NunAireyY92zSbMIdlpV7DvmRZkVbujn4RLBuWlbQNwA/+3saYhYUdaW28KAEQfeJHYKQS
        8b+ftGbOVZeKnnd1mKOpVx8ZTJHctmk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-5-aotUr7PWmxMj011SJ-1Q-1; Sat, 25 Apr 2020 03:21:26 -0400
X-MC-Unique: 5-aotUr7PWmxMj011SJ-1Q-1
Received: by mail-wr1-f72.google.com with SMTP id m5so6302743wru.15
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 00:21:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GLnr0m2mVETKPeWfL0iYJ5elKQI3FKKirhJwNjsAap0=;
        b=HjSJ7jtFn4qAUv4OPCLgFy1MiSgsHUc7RAPYunVY5GgTb6qJtaVa75LQCtfjIaVLAM
         6++giTzYBk8jpq9m6RJ+0pNlJtjwmT+y57Tt9Ube2r8fs7CAMgzQ0nS7kJVSvN4ndnJV
         5AtZtg5arR4IwztkUzspaAanOj5ZtcQ6Ct5QtdSdAKwol+dZ+rRe35B8HeBv+wnnRHQS
         VWLQBEyQG2eN2IM4R//6Junu9CxPaX1SpbTjsvu5OUvqriSBAgjzUtCmq0hr+a5j3f4+
         2dKIF8vi7RifqVGcZOQ1p8NkoQMk8vGCMuj43kHAseb72jPPrVP7uNHzDd1CTj8TP8UF
         Z6Zw==
X-Gm-Message-State: AGi0Pua5qGGfGMpKQzWPB+a1y80zbxStODY10b+F4xFAfBlnZO5gs1uH
        8avtkqGBuCUcGpY9SLyxJKX7rxXSs+jJXkNGACJOgTZn7McmEvAbXf+KRFCXAcb96HBy79/3dhc
        2K3S+KX8LlIZy
X-Received: by 2002:a1c:9a81:: with SMTP id c123mr13814740wme.115.1587799285221;
        Sat, 25 Apr 2020 00:21:25 -0700 (PDT)
X-Google-Smtp-Source: APiQypL4JnN8XmD5Fqhx0zlOQUyNh6Q7sMfKC21sn7xaAJ7eING3tm0vPSCkfvnXY3alByn/09trCw==
X-Received: by 2002:a05:600c:218e:: with SMTP id e14mr15366922wme.140.1587799276137;
        Sat, 25 Apr 2020 00:21:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d0a0:f143:e9e4:2926? ([2001:b07:6468:f312:d0a0:f143:e9e4:2926])
        by smtp.gmail.com with ESMTPSA id w18sm11290918wrn.55.2020.04.25.00.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 00:21:15 -0700 (PDT)
Subject: Re: [PATCH v2 00/22] KVM: Event fixes and cleanup
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        wei.huang2@amd.com, cavery@redhat.com, vkuznets@redhat.com,
        Jim Mattson <jmattson@google.com>
References: <20200424172416.243870-1-pbonzini@redhat.com>
 <20200424210242.GA80882@google.com> <20200424210539.GH30013@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c92b29db-14a1-21f3-5484-23e308af4e99@redhat.com>
Date:   Sat, 25 Apr 2020 09:21:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200424210539.GH30013@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/04/20 23:05, Sean Christopherson wrote:
> On Fri, Apr 24, 2020 at 09:02:42PM +0000, Oliver Upton wrote:
>> Paolo,
>>
>> I've only received patches 1-9 for this series, could you resend? :)
> 
> Same here, I was hoping they would magically show up.

An SMTP server, in its infinite wisdom, decided that sending more than
10 emails in a batch is "too much mail".  I sent the remaining 13
patches now (in two batches).  Thanks for warning me!

Paolo

