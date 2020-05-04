Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2951C46F2
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 21:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgEDTUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 15:20:12 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26334 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725956AbgEDTUM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 15:20:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588620010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nUz/aAZitMLVExxnDPAtTS+sV7w5r/mnfHx+jPKwGw4=;
        b=AX+VYzmhJStnyDIBj90O1Vruu6IwDNnjfwfAfecjs0m2/9SGPHoURqebLkbFmnYeW5J28u
        wcxJo3FP2OOOzF9wN8rKH1hm9+t612+talDI3rjh2ke0h2llcX8uGpTNn9Y+ktxRNNoLEF
        y4Vf+Vf4r7oQqwGdJDdE/ahKalWb9rA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-m9yL2f7RMPewytXpS08TLA-1; Mon, 04 May 2020 15:20:08 -0400
X-MC-Unique: m9yL2f7RMPewytXpS08TLA-1
Received: by mail-wr1-f69.google.com with SMTP id z5so424962wrt.17
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 12:20:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nUz/aAZitMLVExxnDPAtTS+sV7w5r/mnfHx+jPKwGw4=;
        b=fnCjeK/ecHu/nhIoCrx6DRqM7biVQ0YuXjuKguEXhGtKr30CoSFZs/5gi1A8cP0byq
         ByJLvpSz7FUZCewynQibHTR/cn9EXz8A7dOTGDhCVHJnuYdn9oEHHfO4vzhbn2aoib6B
         l0w/FdaWfQCImi2V54qQ1n3LN6bAAv61alEUkQ3BP28P8l/yriIaE9xYzkWY/RZY1XFe
         nQ3oIbwRbHzirw6A58EDd61Bos6QyzMPmHHPKlu1aGWk2UttDIA1SHjh+uOIQXpDqbRG
         n+OzdNcXyjqWUViNi8VKsYUgkKv7CWDRlQ0ZYSRmVBdPjhDjJc235WFbAGroWoPnzSXO
         3l4Q==
X-Gm-Message-State: AGi0PuYEgK4SJYuA6S1qzfCgJNkuoxDYXiJxPrU8VSyAZUObv2PnDmHM
        UfOxKRg/2feodrpE7yo6J3tu1jYCoujRtYLDGw9rwQKt113QqtRpReaLDuL/jf8stsm6f5QRjiT
        po/qSubmEjLgI
X-Received: by 2002:a1c:f418:: with SMTP id z24mr16040956wma.122.1588620007719;
        Mon, 04 May 2020 12:20:07 -0700 (PDT)
X-Google-Smtp-Source: APiQypLyPq+EBft+DIchDIzmT78A6K6Mxa6RNvlcQjX/sIkHDq7lmFqLYsZCjQWjuXepLhFnr/H1ww==
X-Received: by 2002:a1c:f418:: with SMTP id z24mr16040934wma.122.1588620007436;
        Mon, 04 May 2020 12:20:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:cd89:3799:7fbf:7b5d? ([2001:b07:6468:f312:cd89:3799:7fbf:7b5d])
        by smtp.gmail.com with ESMTPSA id n2sm19921300wrt.33.2020.05.04.12.20.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 12:20:06 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: x86: cleanup and fixes for debug register
 accesses
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200504155558.401468-1-pbonzini@redhat.com>
 <20200504185530.GE6299@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <06dcafe8-8278-a818-ad76-36f3bbbcc0a2@redhat.com>
Date:   Mon, 4 May 2020 21:20:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200504185530.GE6299@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/20 20:55, Peter Xu wrote:
> On Mon, May 04, 2020 at 11:55:55AM -0400, Paolo Bonzini wrote:
>> The purpose of this series is to get rid of the get_dr6 accessor
>> and, on Intel, of set_dr6 as well.  This is done mostly in patch 2,
>> since patch 3 is only the resulting cleanup.  Patch 1 is a related
>> bug fix that I found while inspecting the code.
> 
> Reviewed-by: Peter Xu <peterx@redhat.com>
> 
> (Btw, the db_interception() change in patch 2 seems to be a real fix to me)

It should be okay because vcpu->arch.dr6 is not used on AMD.

However I think a kvm_update_dr6 call is missing in
kvm_deliver_exception_payload, and kvm_vcpu_check_breakpoint should use
kvm_queue_exception_p.  I'll fix all of those.

> I have that in my list, but I don't know it's "sorely" needed. :) It was low
> after I knew the fact that we've got one test in kvm-unit-test, but I can for
> sure do that earlier.
> 
> I am wondering whether we still want a test in selftests if there's a similar
> test in kvm-unit-test already.  For this one I guess at least the guest debug
> test is still missing.

The guest debugging test would basically cover the gdbstub case, which
is different from kvm-unit-tests.  It would run similar tests to
kvm-unit-tests, but #DB and #BP exceptions would be replaced by
KVM_EXIT_DEBUG, and MOVs to DR would be replaced by KVM_SET_GUEST_DEBUG.

It could also cover exception payload support in KVM_GET_VCPU_EVENTS,
but that is more complicated because it would require support for
exceptions in the selftests.

Paolo

