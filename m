Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E769209E61
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 14:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404694AbgFYMXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 08:23:05 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25349 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404567AbgFYMXE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 08:23:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593087783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IIlCDhNXpuEM1XOmKAIdxZeWNRlYXHDJyHbMKlrYpqM=;
        b=D7X1yYA02SE98kYX21hDvCvss6cjubL/+qecCjwME+LTFbpARop8KXa7jtv5xFR8UtkFnU
        K049PXsp2k2q6SZ3vzSbx0zVe3VSYAG6BYEcbMgb0rAoqEfxdfLrZkNDgeiq28DmnLNZkG
        Tpk7S4D5SaRxspIaWED4YvjwL9lmAvs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-xlSMF1q6NOyInljUm8NfpQ-1; Thu, 25 Jun 2020 08:22:59 -0400
X-MC-Unique: xlSMF1q6NOyInljUm8NfpQ-1
Received: by mail-wm1-f72.google.com with SMTP id s134so6887883wme.6
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 05:22:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IIlCDhNXpuEM1XOmKAIdxZeWNRlYXHDJyHbMKlrYpqM=;
        b=nJrfMvVqqblwencVjqf1KQ7tYlcR59vj+GqDit3XbBJH6Cw9Mt1n8lXA5EzK8/XHqu
         6JALi+EnRpjFszKwT3wOqEdUi1nnEhSjTGHwa7VFAAg4nYLF+LY97vEb00FgM6nIHuiL
         OcAmRKY2ia+LSeDZ75WlHyU2es7sA9qWQvdqzwStwxOsDBCFh/2oY3p+by5E88dYTxoz
         re7gZ+zlgOgGItI/azPC10X1VaQo4PSJgxB1AH3C9+UUDk0TPzagEc7m1tk9bHmCssM+
         r5uFCLVJVNMLgaj8W1GuoKATC9lb3rFbfXalXDz0izep0vy57xQyd1PS0PnuuNdlieCy
         Y5qQ==
X-Gm-Message-State: AOAM5325Voqu/4smnLvT7z50jfdGexYdFCAaFY4vxBaD1xMR/uWpXrEj
        FzAUc1MT4ovW/L44bNN4USlie/KjB0vYgqZ0150I/31ccH+NjnrjH6UVe1gCugXy4F9TzV4RvE1
        7Lovd0bAksW+n
X-Received: by 2002:a1c:dcc2:: with SMTP id t185mr3289182wmg.91.1593087778119;
        Thu, 25 Jun 2020 05:22:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyT6zssfCFX3oMvkQEexRiemlhI7sv150sohXM20lTIZ6oWHBW8BZGggektIBSGSg/1XsqFkw==
X-Received: by 2002:a1c:dcc2:: with SMTP id t185mr3289165wmg.91.1593087777890;
        Thu, 25 Jun 2020 05:22:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91d0:a5f0:9f34:4d80? ([2001:b07:6468:f312:91d0:a5f0:9f34:4d80])
        by smtp.gmail.com with ESMTPSA id n17sm18831145wrs.2.2020.06.25.05.22.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 05:22:57 -0700 (PDT)
Subject: Re: [PATCH 0/4] KVM: SVM: Code move follow-up
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
References: <20200625080325.28439-1-joro@8bytes.org>
 <87r1u3cwvd.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2dd04a8d-774b-b384-a423-fc7fcbd32b2b@redhat.com>
Date:   Thu, 25 Jun 2020 14:22:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87r1u3cwvd.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/20 11:34, Vitaly Kuznetsov wrote:
> Joerg Roedel <joro@8bytes.org> writes:
> 
>> From: Joerg Roedel <jroedel@suse.de>
>>
>> Hi,
>>
>> here is small series to follow-up on the review comments for moving
>> the kvm-amd module code to its own sub-directory. The comments were
>> only about renaming structs and symbols, so there are no functional
>> changes in these patches.
>>
>> The comments addressed here are all from [1].
>>
>> Regards,
>>
>> 	Joerg
>>
>> [1] https://lore.kernel.org/lkml/87d0917ezq.fsf@vitty.brq.redhat.com/
>>

Queued, thanks.

Paolo

> Thank you for the follow-up!
> 
>> Joerg Roedel (4):
>>   KVM: SVM: Rename struct nested_state to svm_nested_state
>>   KVM: SVM: Add vmcb_ prefix to mark_*() functions
>>   KVM: SVM: Add svm_ prefix to set/clr/is_intercept()
>>   KVM: SVM: Rename svm_nested_virtualize_tpr() to
>>     nested_svm_virtualize_tpr()
>>
>>  arch/x86/kvm/svm/avic.c   |   2 +-
>>  arch/x86/kvm/svm/nested.c |   8 +--
>>  arch/x86/kvm/svm/sev.c    |   2 +-
>>  arch/x86/kvm/svm/svm.c    | 138 +++++++++++++++++++-------------------
>>  arch/x86/kvm/svm/svm.h    |  20 +++---
>>  5 files changed, 85 insertions(+), 85 deletions(-)
> 
> Series:
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 

