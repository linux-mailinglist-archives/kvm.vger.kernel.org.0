Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3AD1B1812
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 23:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgDTVLA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 17:11:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29172 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726067AbgDTVK7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 17:10:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587417058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=khKvjfV1QCWwAueHyk1A6WWqM5T3d6Pqr1J9kJq0InA=;
        b=a0crEKwbbJEh4/sJTa2gOosR7kiWJWM4rIzSpwgE51yCZZc4l92M2gZrRfZpXxuvHdX4oh
        A7UFY0Tk8Wt51sSafRXSvVZjDuzkT9i9ZpjkOLwlPv27gswn4xumH3nrpJPdQeb6B6tcUT
        MqU160R6hNn7TPZaHfSuCaoZXBy7I/4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-dYvZ3doJMDW2Y-3FDixlfw-1; Mon, 20 Apr 2020 17:10:56 -0400
X-MC-Unique: dYvZ3doJMDW2Y-3FDixlfw-1
Received: by mail-wm1-f69.google.com with SMTP id 14so440209wmo.9
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 14:10:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=khKvjfV1QCWwAueHyk1A6WWqM5T3d6Pqr1J9kJq0InA=;
        b=KaMjU583wU7nZq8u6Ivq8XStGAM7sllusrbq3KUiQxvcMMnugPvIeIpETo05yxLRBi
         DV57zFRkumNEDWt65Fmbv/kj99cIkfMfu9OCuMd8Ss5q/Qw4+aCEl6omtdTx+TBQVQUD
         Uddot6HRYQ7Wxm5kAqL+0673wE3z/vG9JC7g+d4IkWDzBDY3KLJnN0VSLq7diZhp5dYk
         nYdO7codrWzBveTBzvsqHzH2mr1FnLCf7pFjhhbhJhnOTLV92qhJ7u9ENj239or7ItD0
         AL8xVUj8Fznj5zIfsVLKH5o5zG+NLrCX2Ur+I9Zkl0xKZyM0G5XVvqS0ECENwhUCbgzB
         OrSg==
X-Gm-Message-State: AGi0Puaa291JGCoOHgjOEjp/rk4BmT28v/VwqUzyo/tELX68KEnGL/O3
        UKyfmvoEUjJKPwRDDayzqAA+Ygu6VhwkU3IvPwMaPk/FiHQyl1scG35alkrH5xJtFeW9zq4AypG
        zozEurTZroPL2
X-Received: by 2002:a7b:c1da:: with SMTP id a26mr1235238wmj.125.1587417055698;
        Mon, 20 Apr 2020 14:10:55 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ1L8EZE/VcK8KHeyTKU3uU84RajtjP2xjc6NigEeEzw0EFT4jjaT3MYUVkeGXyRvkc0Wsqzw==
X-Received: by 2002:a7b:c1da:: with SMTP id a26mr1235224wmj.125.1587417055446;
        Mon, 20 Apr 2020 14:10:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5c18:5523:c13e:fa9f? ([2001:b07:6468:f312:5c18:5523:c13e:fa9f])
        by smtp.gmail.com with ESMTPSA id l19sm788708wmj.14.2020.04.20.14.10.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 14:10:55 -0700 (PDT)
Subject: Re: [PATCH] kvm: Disable objtool frame pointer checking for vmenter.S
To:     Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
References: <01fae42917bacad18be8d2cbc771353da6603473.1587398610.git.jpoimboe@redhat.com>
 <3da1077d-c1b0-4fb0-693b-c124e8e4ca0f@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <80376c0b-f05d-9ddc-cddd-a15aae4c9900@redhat.com>
Date:   Mon, 20 Apr 2020 23:10:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <3da1077d-c1b0-4fb0-693b-c124e8e4ca0f@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/20 18:19, Randy Dunlap wrote:
> Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Queued, thanks.

Paolo

