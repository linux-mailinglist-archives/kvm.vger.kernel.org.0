Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0BFC177422
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 11:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgCCK1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 05:27:07 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57705 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728473AbgCCK1H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 05:27:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583231226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3meacGVL2hG/N2ilO5Ew4SwZwYsirTCzCeIbnNcDdw8=;
        b=WuJM0aLGKmxL5U4g7jlajXRhZbE5jSpUAxjKDzcS/fIwh8lUM4mH8TqhMw6hf99CDXn2YX
        VdJqidEeqHMchlt6jk/y4BrjfLY0bZB7sBg4zaFlBoOabxKaFrUjHCFx+MbaT5wdeb0VZ+
        70kPCyh5aEb+G1/YLDVCeXp/VA0/T+s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-_OUeXA6YOvO_OnYuEGosFg-1; Tue, 03 Mar 2020 05:27:05 -0500
X-MC-Unique: _OUeXA6YOvO_OnYuEGosFg-1
Received: by mail-wr1-f71.google.com with SMTP id d9so1000912wrv.21
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 02:27:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3meacGVL2hG/N2ilO5Ew4SwZwYsirTCzCeIbnNcDdw8=;
        b=YU/TEKgufdDt+u3LIWf+foB+sRQ7p4sa9bzja8VijZCFHuOPDNnU8cGUKaThDZLDEU
         s7gF1F8DUNY3amD4cSDx6ECfhLzYFjwndMz3wSLzNm1HPcsZP/t8LtlJQ4EisApRARGx
         GFxe9WkIaBF4Dh0PQBE/aWPai/+AAD6zP/o/HRiaujOSYp2fRH0VkFqkWBUqKUkyxpWD
         AHtxzL6GOFy+e/DKLCnLDIt5cezvnmjv01bgmxo3kVj5gddyBCxq3TH7Pyc95APH3pYn
         1gWYsyjNJdqCcHNC1W9/E5aw50DfqraSo8X4RGTKHjEOrGW1yt3owceycSlMXEtG4YXE
         ZhFw==
X-Gm-Message-State: ANhLgQ3v8H4iKD073zYgYYnzidxq/UJmWxgylBS2aHGOu6Npa+AZPq75
        NZsHR0MeqRs4gHRvD5W/fW2eOTzThDnrOax9JSHycLaO2N7CuP3Zy4k/qXdyPp60NTChXmLjVos
        g2b8/W39Rn1EE
X-Received: by 2002:a1c:ac46:: with SMTP id v67mr3505332wme.153.1583231224075;
        Tue, 03 Mar 2020 02:27:04 -0800 (PST)
X-Google-Smtp-Source: ADFU+vucRdkYw1PkKF0aTRDgOm7ysVdj5DbiWFq3slbOlAX8zuizt+zhEdWIemdtp7SSZntZe3drag==
X-Received: by 2002:a1c:ac46:: with SMTP id v67mr3505308wme.153.1583231223856;
        Tue, 03 Mar 2020 02:27:03 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id p16sm32702712wrw.15.2020.03.03.02.27.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 02:27:03 -0800 (PST)
Subject: Re: [PATCH v2 09/13] KVM: x86: Move kvm_emulate.h into KVM's private
 directory
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
 <20200218232953.5724-10-sean.j.christopherson@intel.com>
 <87tv3di70f.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <05ead265-d50d-43de-47d2-3c8ae24b8a3a@redhat.com>
Date:   Tue, 3 Mar 2020 11:27:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87tv3di70f.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/02/20 18:38, Vitaly Kuznetsov wrote:
> Not this patchset's problem (and particular forward declaration is
> likely needed), but 
> 
> $ grep 'struct x86_emulate_ctxt' arch/x86/include/asm/kvm_host.h
> struct x86_emulate_ctxt;
> 	struct x86_emulate_ctxt *emulate_ctxt;
> struct x86_emulate_ctxt;
> 
> The second forward declaration is not needed and this patch (or
> patchset) may be a good place to get rid of it)
> 

Squashed, thanks.

Paolo

