Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E111EE877
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 18:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgFDQUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 12:20:36 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38774 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728740AbgFDQUf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 12:20:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591287634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c0B1gOCQB3tsMAy6nQWjh9wldszMTnQJEuaouLyuBOY=;
        b=NkmlohsQlfsbJ8hHTHYZ8kXQe/aggq074zd3ZZ1pDa6DAkfIAw0AN0+K4m/yO3mu1uPF0H
        d1V4OQh00meymQR8jOYUGQQKHWuJSIWxpt23iPPdo5TW05tqL38I0yBNC5DrLyKXcj+Aax
        aK1BOGxK2AcIVQF+OOlmQSXZBOqcQKY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-Q0CbadCFO0Gd4db2xhr63g-1; Thu, 04 Jun 2020 12:20:32 -0400
X-MC-Unique: Q0CbadCFO0Gd4db2xhr63g-1
Received: by mail-wr1-f72.google.com with SMTP id c14so2607796wrw.11
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 09:20:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c0B1gOCQB3tsMAy6nQWjh9wldszMTnQJEuaouLyuBOY=;
        b=M442rr52xYq63f0sqNNcUZNLQNwcekhdo2d31RuaKVe1fNM5FSgQgKzj9WhO+35bLt
         +axlC1NS3qXEnfqxI8Zppf06VZScipboQuLrT3pstr+fFqSJHeQaxgj4aEBBjF+Osr/+
         VzZO7XPYxQphgPuaCUPKiPGx3teON3Jf5TcziM4uYaDY76tQdzNJ/TncXYLO0ujwQPb0
         CHXTACkG6keXU9Z843e1883NN5svb9do9lkW+GXkGPz9gFIOMu8DmAorsY86SLFjQm1r
         NWZFoUWy6AsbyEOPX7Qf3UDOR6LSUXEyr9o8GTklaGavfO71E2d0vfUp7qxRidi6cN9J
         M4aw==
X-Gm-Message-State: AOAM532R8EdLXt3EHmFbpmP0Iz6PVK+2/H4FR8Ho20Iz4MHwl0DcyZn2
        O++4ygv/A5FkEARzbqO8wa+zvqwyXEEXM11Emn258jUCqNql+0jT+hCV5utNmFCIDhYIpJ+a+kq
        wmrnK84D/vxpw
X-Received: by 2002:adf:e285:: with SMTP id v5mr5042138wri.129.1591287631529;
        Thu, 04 Jun 2020 09:20:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3W3/M9qQ/tUPpEsUkOe3S+h3yWEMQolGXs+VzVVX35oHJCG/g9ZFPQyKy/A/EqO1DNwfL/Q==
X-Received: by 2002:adf:e285:: with SMTP id v5mr5042116wri.129.1591287631274;
        Thu, 04 Jun 2020 09:20:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id q1sm7570203wmc.12.2020.06.04.09.20.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 09:20:30 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Always treat MSR_IA32_PERF_CAPABILITIES as a
 valid PMU MSR
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Xu, Like" <like.xu@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
References: <20200603203303.28545-1-sean.j.christopherson@intel.com>
 <46f57aa8-e278-b4fd-7ac8-523836308051@intel.com>
 <20200604151638.GD30223@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f7a234a7-664b-9160-f467-48b807d47c8b@redhat.com>
Date:   Thu, 4 Jun 2020 18:20:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200604151638.GD30223@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/20 17:16, Sean Christopherson wrote:
> On Thu, Jun 04, 2020 at 09:37:59AM +0800, Xu, Like wrote:
>> On 2020/6/4 4:33, Sean Christopherson wrote:
>>> Unconditionally return true when querying the validity of
>>> MSR_IA32_PERF_CAPABILITIES so as to defer the validity check to
>>> intel_pmu_{get,set}_msr(), which can properly give the MSR a pass when
>>> the access is initiated from host userspace.
>> Regardless ofÃ‚Â  the MSR is emulated or not, is it a really good assumption that
>> the guest cpuids are not properly ready when we do initialization from host
>> userspace
>> ?
>
> I don't know if I would call it a "good assumption" so much as a "necessary
> assumption".  KVM_{GET,SET}_MSRS are allowed, and must function correctly,
> if they're called prior to KVM_SET_CPUID{2}.

Generally speaking this is not the case for the PMU; get_gp_pmc for
example depends on pmu->nr_arch_gp_counters which is initialized based
on CPUID leaf 0xA.

The assumption that this patch fixes is that you can blindly take the
output of KVM_GET_MSR_INDEX_LIST and pass it to KVM_{GET,SET}_MSRS.

Paolo

