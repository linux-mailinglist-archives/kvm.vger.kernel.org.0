Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377DA2744DD
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 16:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgIVO7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 10:59:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726667AbgIVO7d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 10:59:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600786772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ie4FgsaJ8xtrZo1tT/YxE8jQ72lhX7SJi+q0Q0SDr4=;
        b=ISZ1U4S31ioAtar5GVQN/I0KxL5bKGXmT637bJjwvEmrk7iKmAqbp68Pcy/aNX84DPidkS
        EVFD5g394+CD+V2/84jUnaoM1ank1oIWovZOKDGrc7ydsRnuX7IPNdFr4qP364EnO5glsV
        JKqIw3GlnK1QSdev7qujUreOEfv0UTc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-jdlXPRd_PKG78RTrlZ3kxA-1; Tue, 22 Sep 2020 10:59:30 -0400
X-MC-Unique: jdlXPRd_PKG78RTrlZ3kxA-1
Received: by mail-wr1-f72.google.com with SMTP id h4so7565989wrb.4
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 07:59:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ie4FgsaJ8xtrZo1tT/YxE8jQ72lhX7SJi+q0Q0SDr4=;
        b=UoSOjw7lmDJ2d6L6qHu2JISg50HjM/OaX+H8A5v9KPrKHr2ozezOxcEOXvmfx691ix
         KB3DYag+NtzC5NCK0znTuwV3YLpb0EJtKcVpFsSumK4kQYo4GmUuOtfCVCOZiW8+hQ2l
         Xd80nG/d8LJnu4fANgSn8afhm0nXLG0YqZBhBNDCK+yCnTAGcQ1ic1i9G8ypFQdbxl6p
         OXQ121anRPSDNeyxH9TQo4VayIJFeyX7mmb5+mj3aMnsNdDbAgz0cCMjQ8z22vSkquTy
         gppPN12iEWDeLj19qvwcOxSNNbPAGyQo0ZrJbFlYskjCtZtoZeAZmNqRFlgEg1XTY/sp
         GK4A==
X-Gm-Message-State: AOAM532dqVM2kGvHrBMVGOpp4zOT2AInjxObdRzhIHvZdvMEJNpvKGos
        NUA7/NhuCG0MxzpUjbBgZ/c3fJB6eUdntr0uIvp6KM737MUrtXjVFzJ/u6A0bu+4/XMeimsbyfr
        Vwf+2qxpTtWSa
X-Received: by 2002:a05:600c:2215:: with SMTP id z21mr1461675wml.176.1600786769339;
        Tue, 22 Sep 2020 07:59:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjXMY9ACgiqgHGp5tNwuf2wVfMhVgm+WoLSRb/hPYSzvi5t+bZ1Ms/v6mljOfdaOoO68v4OQ==
X-Received: by 2002:a05:600c:2215:: with SMTP id z21mr1461650wml.176.1600786769065;
        Tue, 22 Sep 2020 07:59:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id u2sm4979316wre.7.2020.09.22.07.59.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 07:59:28 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 0/2] Use same test names in the default
 and the TAP13 output format
To:     Thomas Huth <thuth@redhat.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <20200825102036.17232-1-mhartmay@linux.ibm.com>
 <87bli7tm68.fsf@linux.ibm.com>
 <d740c6a7-6680-ce7b-489b-aaa8cf712f56@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fa01ef1b-b6d1-dbfc-eb7d-675b1bb7650b@redhat.com>
Date:   Tue, 22 Sep 2020 16:59:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <d740c6a7-6680-ce7b-489b-aaa8cf712f56@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/20 10:53, Thomas Huth wrote:
> On 15/09/2020 11.38, Marc Hartmayer wrote:
>> On Tue, Aug 25, 2020 at 12:20 PM +0200, Marc Hartmayer <mhartmay@linux.ibm.com> wrote:
>>> For everybody's convenience there is a branch:
>>> https://gitlab.com/mhartmay/kvm-unit-tests/-/tree/tap_v2
>>>
>>> Changelog:
>>> v1 -> v2:
>>>  + added r-b's to patch 1
>>>  + patch 2:
>>>   - I've not added Andrew's r-b since I've worked in the comment from
>>>     Janosch (don't drop the first prefix)
>>>
>>> Marc Hartmayer (2):
>>>   runtime.bash: remove outdated comment
>>>   Use same test names in the default and the TAP13 output format
>>>
>>>  run_tests.sh         | 15 +++++++++------
>>>  scripts/runtime.bash |  9 +++------
>>>  2 files changed, 12 insertions(+), 12 deletions(-)
>>>
>>> -- 
>>> 2.25.4
>>>
>>
>> Polite ping :) How should we proceed further?
> 
> Sorry, it's been some quite busy weeks ... I'll try to collect some
> pending kvm-unit-tests patches in the next days and then send a pull
> request to Paolo...
> 
>  Thomas
> 

Don't worry, I'm finally back and learning again how to do code review
with "lighter" series. :)

Paolo

