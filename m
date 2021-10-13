Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE04142B57E
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 07:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237761AbhJMFgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 01:36:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24934 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237732AbhJMFgx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 01:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634103290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s9r2xR2EqP/t5FLsHTwtUUvaANXfO/gylgaJSKQRa+8=;
        b=cC7tbFd7PNvNQr1A6a5BiGKY3zDjKuUc1EfbzRZH00ckwDhcjEaZjfIZsTcLeCOBWg8DNJ
        hj9t0eLr4q2MpVl+FlF/sjCn7Le+Eg1SP50GdRDuFriCM7JF82q0rqLrm/XFoHnWFN5vtx
        xqrKu3Zsjomn5c27AswLlTxnI6X1wyo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-cHr5ZxsIPM-KnUNOiFzgxA-1; Wed, 13 Oct 2021 01:34:47 -0400
X-MC-Unique: cHr5ZxsIPM-KnUNOiFzgxA-1
Received: by mail-ed1-f70.google.com with SMTP id cy14-20020a0564021c8e00b003db8c9a6e30so1235357edb.1
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 22:34:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s9r2xR2EqP/t5FLsHTwtUUvaANXfO/gylgaJSKQRa+8=;
        b=zSSV6cS3ENEKppa88JC/gXLUNqjp0vKxccqQyzPEECG6jFfaIOnHiG7tQ0/vkQ4OpI
         MqvNhUhJAvSNp0vxMK3l7/g0z3L/0LZZ+ZldPesvKjZyOVlKsI4yZKFhTCkEN2vHQAcs
         BujGEBlBhIBupe9yGm2+uKXYIyuo9+tISq4pJGXooFbD11tB0X8PVUR0iU7NgtbLCxHU
         gUWQnswHlZpcFMR1UxnMNxdQzTyZ/r7m/ZP2ylDTY9tA4pwjxLLsd7PJfcFCjJ6TelvO
         3qFK09nUiRLWu5dAm15dXaTd7CC5QpXZa1PTqOG78J8U7lGhyPczxpCunJRzOjKLJ4Nr
         uo3g==
X-Gm-Message-State: AOAM533tKUdPtRoCba30vY1LvMBbAApBdc9G6GCz638twCOvCpXpxS+r
        cEXjiXXXUAAjv4NhwsR87ckg02V3DmzRHdnIs71ru3xzroAVwBQnCiT/fAIxluij92EWecTo71l
        wdOhzwPCXKjl8
X-Received: by 2002:a05:6402:2684:: with SMTP id w4mr6554721edd.108.1634103286330;
        Tue, 12 Oct 2021 22:34:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvbp0lfx3vs0ck1sseLJlqp7mWqgndzQU8vzGaHBI2q4E7j80ZWXtMNpOrO5LTzF7xq9/gig==
X-Received: by 2002:a05:6402:2684:: with SMTP id w4mr6554698edd.108.1634103286140;
        Tue, 12 Oct 2021 22:34:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x26sm1916924ejf.103.2021.10.12.22.34.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 22:34:45 -0700 (PDT)
Message-ID: <cc8893f1-df60-2155-d3b6-f889bc1c2201@redhat.com>
Date:   Wed, 13 Oct 2021 07:34:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [patch 16/31] x86/fpu: Replace KVMs homebrewn FPU copy to user
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.249593446@linutronix.de>
 <0d222978-014a-cdcb-f8aa-5b3179cb0809@redhat.com> <87fst6b0f5.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87fst6b0f5.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 19:47, Thomas Gleixner wrote:
>> The memset(guest_xsave, 0, sizeof(struct kvm_xsave)) also is not
>> reproduced, you can make it unconditional for simplicity; this is not a
>> fast path.
> Duh, I should have mentioned that in the changelog. The buffer is
> allocated with kzalloc() soe the memset is redundant, right?

Yes, I always confuse the __user pointers with the temporary ones that 
are allocated in the callers.

Paolo

