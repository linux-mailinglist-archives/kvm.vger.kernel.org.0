Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB24392D57
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 13:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhE0L7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 07:59:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234547AbhE0L7F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 07:59:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622116652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t/UG/vOjqqYiwPQvAtrFfzKJeXXNxXalH1G9gKu4yuk=;
        b=TXa4UvhLApf6G9sxfMX4tIO/gNo5mbt95TgD5lxgdDUQh7RnyDerHIUUG0EepsnLEzrZtW
        QYIFQIyUKy2vYdgD++cZ4DYzInALJ3TALJWvZ+vlY4rZPRIZ1pMpF7HoI6CkMaOHm3y/G0
        6ueHDG9DbHzlzL5CKNG4VVjfP4qjlEU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-huaCDWu_O7aWfulimyu4EQ-1; Thu, 27 May 2021 07:57:30 -0400
X-MC-Unique: huaCDWu_O7aWfulimyu4EQ-1
Received: by mail-ed1-f69.google.com with SMTP id c21-20020a0564021015b029038c3f08ce5aso173631edu.18
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 04:57:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t/UG/vOjqqYiwPQvAtrFfzKJeXXNxXalH1G9gKu4yuk=;
        b=R13/o99Gga4aW5J59CVMiumOVisvHyuiDWkOk+HzdQRl36513qgn8+2tVdRj7gu2vw
         hzcRrydgGHaild8QIGcI8dHTTOdZr4YweWx0uOIGSEadZFFcJRZvBe5yEnjg5Vj8fZfG
         u2AyWpEG4nRRnU1FfIkOHrUVVBduo/Hos0rI+8FuiLuLazI/K/rNiWifwSsSrHtn9dzX
         wa/gPei340vDMCwrb1BNxkshrfyzEisNyl3JAb2HFIKkta0AEbxsjU0GNT0KEUsar6PF
         ZEL/i2pWFDPs3G+Qb2P7/wMF6IxOhQ0s20ZL29L5LGj3j1HOJRY7bHd/cGSciHCqHb8d
         R7RA==
X-Gm-Message-State: AOAM533IIPq7WC7YH93W0U61/uUx7rA8J/5vGssokiic2Vb68z60EETs
        2N2pJpeaXUGsdD6n9NeWIBotd3gsLR0b7WgwuFGs8KAWH5UZpjK6lkbR5iq148/N9cPPe7NKes8
        btGvG1+u/nEe6
X-Received: by 2002:a17:906:5388:: with SMTP id g8mr3473962ejo.413.1622116649705;
        Thu, 27 May 2021 04:57:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhGZTcVuQnbCjm3ZagKU/nq5IWs4q2sr8cCZYIwCdhNu0LsJLPb5h6cpDUBYOO0UHNjmFQVA==
X-Received: by 2002:a17:906:5388:: with SMTP id g8mr3473944ejo.413.1622116649502;
        Thu, 27 May 2021 04:57:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j4sm980365edq.13.2021.05.27.04.57.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 04:57:28 -0700 (PDT)
Subject: Re: [patch 2/3] KVM: rename KVM_REQ_PENDING_TIMER to KVM_REQ_UNBLOCK
To:     Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>
References: <20210525134115.135966361@redhat.com>
 <20210525134321.303768132@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e8ebd90a-3557-2929-4ebc-e70a7c40f627@redhat.com>
Date:   Thu, 27 May 2021 13:57:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210525134321.303768132@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/05/21 15:41, Marcelo Tosatti wrote:
> -KVM_REQ_PENDING_TIMER
> +KVM_REQ_UNBLOCK
>   
>     This request may be made from a timer handler run on the host on behalf
> -  of a VCPU.  It informs the VCPU thread to inject a timer interrupt.
> +  of a VCPU, or when device assignment is performed. It informs the VCPU to
> +  exit the vcpu halt inner loop.
>   

A small change:

   This request informs the vCPU to exit kvm_vcpu_block.  It is used for
   example from timer handlers that run on the host on behalf of a vCPU,
   or in order to update the interrupt routing and ensure that assigned
   devices will wake up the vCPU.

Paolo

