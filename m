Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0F025C864
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 20:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgICSDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 14:03:35 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24818 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726990AbgICSDe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Sep 2020 14:03:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599156212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sIYywuI+5zo+5SpQBzc44V+N7rc22duk7DoIeCwwY34=;
        b=et4ooAbPr5cg9tQacWsbPmRB0NFLUz3rYf3WB4rmuieE4BNDSXzkUh+w4ZEZEcLF0saB+B
        RKJhqieqdvZNMh0U2oJ1H2DVUiqYvpnirEgS/vWVJgc5qFIdxhQtGe0SNf7FKuoV0ykt1t
        K+9hgT9DkVVs4WG02m0QdOtcNDkQ3GQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-wqquF0yoNda2KSihF5GqNw-1; Thu, 03 Sep 2020 14:03:30 -0400
X-MC-Unique: wqquF0yoNda2KSihF5GqNw-1
Received: by mail-wm1-f69.google.com with SMTP id z1so1258977wmk.1
        for <kvm@vger.kernel.org>; Thu, 03 Sep 2020 11:03:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sIYywuI+5zo+5SpQBzc44V+N7rc22duk7DoIeCwwY34=;
        b=qZuGHc9hs0usH/Voum9OLcS0GF8u01mBnXhk2iywkY9APFC4Cdy9SY8A/Fegd2Z+QU
         xaMyQDOR19iP2CnSUtDAEcE3a1fNi8fzAvFU88GWZYvaXgLLJrKef2mL+EOkhC4IpMEu
         TNh7eLOQVl9XJvXOp8P6ktYR+kpqhFVSzfMHY9ZcD1i9tcfXDTnzmad1R0sKO5Iqv/j7
         uPlvwVGHjmBIhAVOmdjkYvWPQbfooDgwY6Hvad96bZgiuXv4L9DtS9NECytIKqcbvAJv
         CnycOM4PrDRqaAwz3a4Aii1F3D+Ua9aqGUw+yKpWju01L/jlWdexUYqH9w3lRwtAG2+A
         +wtw==
X-Gm-Message-State: AOAM531XP5BmYp68jQukkoyRee8GK7lDHkgvU8ukxJ8nvJKkwP5UypjU
        K5TVVmx+XdJ1VVasqFf85HxHB5FqERqaNcIYvYqWGjAjF0ppAMQdIrVceqexqnSMTtebcOofAeP
        fwmIkajqvzeMp
X-Received: by 2002:a5d:60cc:: with SMTP id x12mr3614743wrt.84.1599156209610;
        Thu, 03 Sep 2020 11:03:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywzVzvNoipx7UCAuCRf8BdHygTvcKAX8HtMdA2pAN3MK/J16WybvdgXkklbxMMCzuSooHB+Q==
X-Received: by 2002:a5d:60cc:: with SMTP id x12mr3614713wrt.84.1599156209243;
        Thu, 03 Sep 2020 11:03:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:197c:daa0:48d1:20b2? ([2001:b07:6468:f312:197c:daa0:48d1:20b2])
        by smtp.gmail.com with ESMTPSA id o2sm6331216wrh.70.2020.09.03.11.03.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 11:03:28 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: VMX: Make smaller physical guest address space
 support user-configurable
To:     Jim Mattson <jmattson@google.com>,
        Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200903141122.72908-1-mgamal@redhat.com>
 <CALMp9eTrc8_z3pKBtLVmbnMvC+KtzXMYbYTXZPPz5F0UWW8oNQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <00b0f9eb-286b-72e8-40b5-02f9576f2ce3@redhat.com>
Date:   Thu, 3 Sep 2020 20:03:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eTrc8_z3pKBtLVmbnMvC+KtzXMYbYTXZPPz5F0UWW8oNQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/09/20 19:57, Jim Mattson wrote:
> On Thu, Sep 3, 2020 at 7:12 AM Mohammed Gamal <mgamal@redhat.com> wrote:
>> This patch exposes allow_smaller_maxphyaddr to the user as a module parameter.
>>
>> Since smaller physical address spaces are only supported on VMX, the parameter
>> is only exposed in the kvm_intel module.
>> Modifications to VMX page fault and EPT violation handling will depend on whether
>> that parameter is enabled.
>>
>> Also disable support by default, and let the user decide if they want to enable
>> it.
>
> I think a smaller guest physical address width *should* be allowed.
> However, perhaps the pedantic adherence to the architectural
> specification could be turned on or off per-VM? And, if we're going to
> be pedantic, I think we should go all the way and get MOV-to-CR3
> correct.

That would be way too slow.  Even the current trapping of present #PF
can introduce some slowdown depending on the workload.

> Does the typical guest care about whether or not setting any of the
> bits 51:46 in a PFN results in a fault?

At least KVM with shadow pages does, which is a bit niche but it shows
that you cannot really rely on no one doing it.  As you guessed, the
main usage of the feature is for machines with 5-level page tables where
there are no reserved bits; emulating smaller MAXPHYADDR allows
migrating VMs from 4-level page-table hosts.

Enabling per-VM would not be particularly useful IMO because if you want
to disable this code you can just set host MAXPHYADDR = guest
MAXPHYADDR, which should be the common case unless you want to do that
kind of Skylake to Icelake (or similar) migration.

Paolo

