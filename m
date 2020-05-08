Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4B61CA793
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 11:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgEHJwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 05:52:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25546 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726904AbgEHJwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 05:52:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588931553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+dz6rA08h3MZ8FdUWtlFCXT77fAjr2cP8WCCtv+kX0E=;
        b=Ge3X+mM5gUCEpTBgwN8HV+a8lEFuPmO9qnBZKoHenkYyVsnDbMxUaCVYCCtwrtDD0x4fgK
        8aOTiYCOJPR9jTYSBP4obh5Nsln2lEWqzrAcc4Y0A7QTIzPGHjJ7oYZJgKnVxm3mvyjnDx
        xeIv3rMCJ0oRn7CHLbYqVFQLhcX1ZO0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-Jn9T9Bl9Pzqi6UWSnd1Kog-1; Fri, 08 May 2020 05:52:29 -0400
X-MC-Unique: Jn9T9Bl9Pzqi6UWSnd1Kog-1
Received: by mail-wr1-f69.google.com with SMTP id e14so622482wrv.11
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 02:52:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+dz6rA08h3MZ8FdUWtlFCXT77fAjr2cP8WCCtv+kX0E=;
        b=hc2EQ4jtCIpYVQEklzE1u2O2FXXpDhQjF6K/BCNYoepN2CJeIGXyHt1bvH5l5q7B3s
         r7amP63SfrQQ9bzhC67V24NOtYU6+zvgCYiVjfiROjjo3Ro9FkOHpup/0LOS2ONcbX3W
         OBLqxlqkCRSnNqAN4pVt3C20xHqabdeLG2VIMbc08KDWANAHjPevjp3hi25rfVt7nys+
         +4LKoYZs35HiOjvb347YEukDNxL6+Hgt3nQ8rcZMOlke2lhdcG0HV/PjpAtTNhiW3jJu
         +841+MnhBwvIYkLQLVkJzYzd//qHxMuXtWnMdKVF87yBtbCNhe0sRHUG+IK2LvgBy92Z
         WbHg==
X-Gm-Message-State: AGi0PuZ5IkrFR0KEWqxxwq4WEx0ObavIS/PdYyIoU4t6Uf3TlsKcRb6/
        LbxTcoXs5f2MXjGEARi/YHmwUxxgiPhYLkAcdumbTe3wSQg6uIULT3IkynlpWhzOPO5DrsBa8Rt
        Wou/v4/Jwyv6f
X-Received: by 2002:adf:bc41:: with SMTP id a1mr2133063wrh.302.1588931548435;
        Fri, 08 May 2020 02:52:28 -0700 (PDT)
X-Google-Smtp-Source: APiQypIXg2rUC+xsWJ1CTk51Rn7BwUDILnaCu2NtMy3/wwiwPkPeCChG25HI6ju147+iTr3raidjMA==
X-Received: by 2002:adf:bc41:: with SMTP id a1mr2133038wrh.302.1588931548233;
        Fri, 08 May 2020 02:52:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:20ea:bae4:47a7:31db? ([2001:b07:6468:f312:20ea:bae4:47a7:31db])
        by smtp.gmail.com with ESMTPSA id g12sm4237266wmk.1.2020.05.08.02.52.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 02:52:27 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86/pmu: Support full width counting
To:     like.xu@intel.com, Like Xu <like.xu@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200507021452.174646-1-like.xu@linux.intel.com>
 <3fb56700-7f0b-59e1-527a-f8eb601185b1@redhat.com>
 <72d7d120-85af-d846-a0d5-fe8fe058be34@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aabf0a54-ff60-5c1e-279b-9c8bf18e396d@redhat.com>
Date:   Fri, 8 May 2020 11:52:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <72d7d120-85af-d846-a0d5-fe8fe058be34@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/20 10:42, Xu, Like wrote:
>> Given the bugs, it is clear that you should also modify the pmu.c
>> testcase for kvm-unit-tests to cover full-width writes (and especially
>> the non-full-width write behavior of MSR_IA32_PERFCTRn).  Even before
>> the QEMU side is begin worked on, you can test it with "-cpu
>> host,migratable=off".
>
> Sure, I added some testcases in pmu.c to cover this feature.
> 
> Please review the v3 patch
> https://lore.kernel.org/kvm/20200508083218.120559-1-like.xu@linux.intel.com/
> 
> as well as the kvm-unit-tests testcase.

Awesome, thanks for the quick reply!

Paolo

