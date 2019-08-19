Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35E992821
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 17:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfHSPPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 11:15:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4403 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbfHSPPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 11:15:00 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AFDB02A09C3
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 15:14:59 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id g5so89640wmh.1
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 08:14:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C7SoejRWRuHJ6BGslNq0HYAXwiWp4/65kEvpnkCVews=;
        b=Z8Fwn/XqHkvjBibZDQ4/DF5wLMA6hQkt5IF2V9jeZYfRnEaxNiUAN9zhK7QGWTMTQc
         fZLbmeUHafpHnHi7EShPYj2OlVe974i0oA2Bw/ugaG4DtCl8bP5XgldakBcsnJaaWegw
         PjxIt2Bl3iH5HGDrZKf7VvQtbD5sAjRINtCC8zEzIkwxU4ZCiKTREkSGNAns+FfXtBm/
         jZf2v2gmNH0C+2JNoNHXBmMpVEhLoAtcDmx/VlZ5Eez9xY3I2rCsmx6RqMqFwPV1IOVM
         gFOq/8489XqP1BAD0LbEK8YuVh6Vruy9fe2kCRF+LJ5MN+N39F8grFs7yUJDFHs3GuKz
         4KLA==
X-Gm-Message-State: APjAAAWXS+iyweUrqw5lQcIe/II68lQPmufbqgXYmPIoUAEpcoYwtq2K
        fiZYJliarjDSk3NwhgE24iuYP4r8PVfUsUzekzJ4GFM6Jkb5BOm1GNeSPXuBQP5TKLLGpkdNjgy
        yJwPQV/ePcY+W
X-Received: by 2002:a05:6000:4f:: with SMTP id k15mr27459828wrx.221.1566227698368;
        Mon, 19 Aug 2019 08:14:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy9RZQLbX5VJkCPpbScttbojZgMXP2p2KsS260Ym4OCGfKaJxFH1bWjHnvJt9xyKMxddzVfVA==
X-Received: by 2002:a05:6000:4f:: with SMTP id k15mr27459793wrx.221.1566227698083;
        Mon, 19 Aug 2019 08:14:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8033:56b6:f047:ba4f? ([2001:b07:6468:f312:8033:56b6:f047:ba4f])
        by smtp.gmail.com with ESMTPSA id g14sm29413407wrb.38.2019.08.19.08.14.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2019 08:14:57 -0700 (PDT)
Subject: Re: [PATCH RESEND v4 5/9] KVM: VMX: Add init/set/get functions for
 SPP
To:     Yang Weijiang <weijiang.yang@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        yu.c.zhang@intel.com, alazar@bitdefender.com
References: <20190814070403.6588-1-weijiang.yang@intel.com>
 <20190814070403.6588-6-weijiang.yang@intel.com>
 <87a7cbapdw.fsf@vitty.brq.redhat.com>
 <20190815134329.GA11449@local-michael-cet-test>
 <CALMp9eTGXDDfVspFwFyEhagg9sdnqZqzSQhDksT0bkKzVNGSqw@mail.gmail.com>
 <20190815163844.GD27076@linux.intel.com>
 <20190816133130.GA14380@local-michael-cet-test.sh.intel.com>
 <CALMp9eRDhbxkFNqY-+GOMtfg+guafdKcCNq1OJt9UgnyFVvSGw@mail.gmail.com>
 <20190819020829.GA27450@local-michael-cet-test>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e9a269d8-b410-2489-aaa3-24b487ffd1e2@redhat.com>
Date:   Mon, 19 Aug 2019 17:15:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190819020829.GA27450@local-michael-cet-test>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/08/19 04:08, Yang Weijiang wrote:
>> KVM_GET_NESTED_STATE has the requested information. If
>> data.vmx.vmxon_pa is anything other than -1, then the vCPU is in VMX
>> operation. If (flags & KVM_STATE_NESTED_GUEST_MODE), then L2 is
>> active.
> Thanks Jim, I'll reference the code and make necessary change in next
> SPP patch release.

Since SPP will not be used very much in the beginning, it would be
simplest to enable it only if nested==0.

Paolo
