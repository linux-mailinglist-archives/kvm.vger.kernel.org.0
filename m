Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0165F214AAC
	for <lists+kvm@lfdr.de>; Sun,  5 Jul 2020 08:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgGEGqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jul 2020 02:46:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23460 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725873AbgGEGqN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Jul 2020 02:46:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593931572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p0sk3bwciG+XqxrH/dV8sbWGUHyaJJ5u2sc2HO/S//0=;
        b=DNNnSJLOnyvUL8b1IdLGxSOvrgfa8N5dMOfmPQ8nLHBYMDhNS9i2cGPSr1cZf5dFD/XirW
        8pm+5aY6gQRoI30BB60Ujy8rvkDuU63CZXzyrVJ56WvOzRZReiRfgMIllUzzkURkG74BGJ
        gxcSQXR5PnANh/gw/ZyDEZxu7vaNwO4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-gngAMAdsMZqEOYM6QjRCvg-1; Sun, 05 Jul 2020 02:46:09 -0400
X-MC-Unique: gngAMAdsMZqEOYM6QjRCvg-1
Received: by mail-wr1-f70.google.com with SMTP id j3so18143740wrq.9
        for <kvm@vger.kernel.org>; Sat, 04 Jul 2020 23:46:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p0sk3bwciG+XqxrH/dV8sbWGUHyaJJ5u2sc2HO/S//0=;
        b=CH6J9F1wkp7Viph4Y1HduN2uK1Jd98e121mOpXzKV6MtH880OdOFHIlbhxZ3MabZ3O
         gV0c6YnWdyj+IjyedZKPWEhTVegJZM4hXqaIPzCzDo/3BK1169PqcocFBr193dvbrim2
         YR3sjGfbeYJ4bw8wbl+a4RP3jKQODOiWZ/32f8/iml9bEfnu/JRZgpX1o3ufvjenRhze
         mNeVFy05F4K5QT7ptF4jGXIxN8S01H0ukkeGdstKwSMFSvkvZjXKAWlRYgiAQHvq7tpK
         Unry5ky+fqzC9dOlnNDsBYdCvc/Qlx0FagirlylpqMss9TVgHP42zCQLDapCEtKzs4uj
         zsdw==
X-Gm-Message-State: AOAM530QsOWzTdhufmfA0tbMtvWgkPYa8FNrC6AGJ6gzJehIKUElKNpC
        K1BC/z7EiZ4XBdMlK540ZP8UTClX4fo0gnzIZYsOWdpexhGdwPA0jAc9o/JJGQz2dbZia7WMBdE
        +o2uSEvROBDmQ
X-Received: by 2002:a5d:658a:: with SMTP id q10mr40591258wru.220.1593931567805;
        Sat, 04 Jul 2020 23:46:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzq51uSfh0JjnUIlv6KEhzCyQQp1OOe76oqsEBc79uhgx9ZK7eZBo4mSdy4lZkP02mJmEIIYA==
X-Received: by 2002:a5d:658a:: with SMTP id q10mr40591247wru.220.1593931567624;
        Sat, 04 Jul 2020 23:46:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:adf2:29a0:7689:d40c? ([2001:b07:6468:f312:adf2:29a0:7689:d40c])
        by smtp.gmail.com with ESMTPSA id g14sm15714929wrw.83.2020.07.04.23.46.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jul 2020 23:46:07 -0700 (PDT)
Subject: Re: KVM upcall questions
To:     Jidong Xiao <jidong.xiao@gmail.com>
Cc:     kvm <kvm@vger.kernel.org>
References: <CAG4AFWZ3zd1LEZa6RHbUYyMsT8vGzOJSmw9G0CK-pnpRLv6Hfw@mail.gmail.com>
 <CABgObfbXnYoNNZ9SmF56XHhJ8Lx4bN4L-ZYnGF_UBFfkEMyBHQ@mail.gmail.com>
 <CAG4AFWbwEtxsvCVyOJ0cvHQ1RNGaCPRMEEmoGzAp-=TRdLExLw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <21db3603-8f05-d8bb-1aa0-efb27e36f850@redhat.com>
Date:   Sun, 5 Jul 2020 08:46:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAG4AFWbwEtxsvCVyOJ0cvHQ1RNGaCPRMEEmoGzAp-=TRdLExLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/07/20 11:53, Jidong Xiao wrote:
> 
> I look at the document in the Documentation/virtual/kvm/msr.txt file
> and see this:

There is also MSR_KVM_ASYNC_PF_INT.  You could add another field after
"token", which would be the reason of the upcall (0 would be the "page
ready notification" that is already in place).

Paolo

> MSR_KVM_ASYNC_PF_EN: 0x4b564d02
> data: Bits 63-6 hold 64-byte aligned physical address of a
> 64 byte memory area which must be in guest RAM and must be
> zeroed....First 4 byte of 64 byte memory location will be written to by
> the hypervisor at the time of asynchronous page fault (APF)
> injection to indicate type of asynchronous page fault. Value
> of 1 means that the page referred to by the page fault is not
> present. Value 2 means that the page is now available.
> 
> When you say "it can be extended to general upcalls", do you mean we
> use a value higher than 2 to represent a different reason, and the
> guest will take an action according to that value? Should the return
> value of the upcall be written in the 64-byte memory space, or how
> does the hypervisor know the return value of the upcall?

