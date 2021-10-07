Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6CC424D9A
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 08:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240178AbhJGHB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 03:01:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38311 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233511AbhJGHB0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 03:01:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633589972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r5cjrtzAUfTFfn+XpMPFhZ+gWkuj4D+fj6EkUQIpFkA=;
        b=BHbwVFUNRbV7NvhEB8xN217d3wy53XGpBpXX/0Epo/vUNRpGn+iWzsQHcybre38dUr/Kkh
        oHXssekPAR57QJ5uius9DxptT85WzsSlZlul3kbCq26I0C6r6v+b6Im7G8iA+esk/Mo1hs
        283FsYrz9OYEG7wRFtx3CWJ64Nye50c=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-AFK1qroqNK6FbRicr-cmrQ-1; Thu, 07 Oct 2021 02:59:31 -0400
X-MC-Unique: AFK1qroqNK6FbRicr-cmrQ-1
Received: by mail-ed1-f72.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so4923212ede.16
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 23:59:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=r5cjrtzAUfTFfn+XpMPFhZ+gWkuj4D+fj6EkUQIpFkA=;
        b=lIjQk1NcX2kC1ZJ9P4WF7tv9BrvQX5Rtg8dOX+41yl2b9SuI+HtzPHgP8wTaibkG+K
         RSH95OD3j+Q1RSIujk79nt5wHFSgDvOPwWESQ0efeZWZKrYmL4B7v7UwlgBhqO0PCSL3
         xFFZjJ93Oc5wKUTXiZehcldZNowaMDcdFY4EVNF7NO9Hs+ahxH1r8iHCJ0fByjZlfC9b
         gEl1g4rhDy32uNlHXzr+LfEsV+WZl6mwCu7AOuX6lr6PCKvfvwQjCmRlmy7tYBU3PIzV
         rgigmhxqaGsMY1B5BngTQ8sr6V2M9rTevNsP9XkCevpLM4sm+nvP2PCl9hGZMe7ekgbM
         27mw==
X-Gm-Message-State: AOAM533RIbEmgoBc1DQMJljMheVI6Ou8uVvrMXv6+2p2N6Jyh3dEwM3N
        Rd/3jRA3jPLcerksyI5d8chlSXHxVRQFowS9BOoWzR0SQZwsfYd8JtdyUdDaR7Silg8A/J/2V9W
        cefhUGof8cnRW
X-Received: by 2002:a05:6402:42d6:: with SMTP id i22mr1064351edc.54.1633589970205;
        Wed, 06 Oct 2021 23:59:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsntpiI6uV8FdxmpZafdNUy/Hfb4zkESAWYNpyyJsdSRNJGc1JGMIgKJzRTW9DrB7PyWuUGg==
X-Received: by 2002:a05:6402:42d6:: with SMTP id i22mr1064336edc.54.1633589970018;
        Wed, 06 Oct 2021 23:59:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id og39sm3195811ejc.93.2021.10.06.23.59.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 23:59:29 -0700 (PDT)
Message-ID: <42039591-c445-9298-607a-76efe875eb53@redhat.com>
Date:   Thu, 7 Oct 2021 08:59:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [GIT PULL] KVM/riscv for 5.16
Content-Language: en-US
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
References: <mhng-03b25a51-3491-4bb7-9e17-1b32fc97b7ff@palmerdabbelt-glaptop>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <mhng-03b25a51-3491-4bb7-9e17-1b32fc97b7ff@palmerdabbelt-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/10/21 18:42, Palmer Dabbelt wrote:
> On Tue, 05 Oct 2021 01:25:41 PDT (-0700), pbonzini@redhat.com wrote:
>> On 05/10/21 09:55, Anup Patel wrote:
>>>    git://github.com/kvm-riscv/linux.git tags/kvm-riscv-5.16-1
>>
>> Pulled, thanks!
> 
> Thanks!
> 
> IIUC how this generally works is that you pull these KVM-specific patch 
> sets and I don't, which means they'll get tested on my end as they loop 
> back through linux-next.  I'm fine with however this usually works, just 
> trying to make sure we're on the same page as this is my first time 
> being this close to another tree.

Generally speaking, Anup as the maintainer is responsible for things not 
breaking.  I do a cross-compile to check against changes to KVM common 
code in virt/kvm, but otherwise just take his tree and send it out to 
Linus.  Once selftests are in, I will also be able to run them under 
QEMU, again to check that changes to virt/kvm/ do not break RISC-V.

Paolo

