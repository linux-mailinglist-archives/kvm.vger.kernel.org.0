Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84186B5632
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 21:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfIQTeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 15:34:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41184 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbfIQTeN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 15:34:13 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9AF49368CF
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 19:34:12 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id o188so1651941wmo.5
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 12:34:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oyRZ9yRbWvPLYJ7xJ/RWX6c9dvFuQeGVTO5kSpbtosY=;
        b=QH74/1n2q3VhnWJC+y8OvrgeQZKOvyFQt9F4q3F5k6LEkGuOzEdUUHfFXbotvMOsn1
         wmBqCePLyynIoWItSlbqwc1M8Lqb72GgHmx/7Llwp2ouY4WCph1gJeBoi1jGdG2sCnOU
         4ig+Zwgf4ztOjK2dupX/AkPhhphSk20RmXR1kL4/cZIZpeVeQoQeZ4QHzqkpGfu7mfqj
         vZzaFDpKxxE2Utv9HihBBgFU7Ojy9GGLKURQHwzEkTy2XqwQuMwUH3VFt37JGNBMHRfc
         Y3vFHG/td0EDYjhC7nVydQ5M86eI+CT/xVa46WibvRK0loAsydmuG6Dhvvrby1CQ18m7
         jf+w==
X-Gm-Message-State: APjAAAUwA5xj0k6c3WcqlHlLTaLbC06h1M1HojaURTu8Q0FKD+xXuD4Z
        90RDrNO0b8GWC/7HEMJru6jpwZxuB4+uy/erMP3z/d91uNVgCsuSgpE0D+xj0g27EaIQXkKPLhV
        fiLcSLooihd3G
X-Received: by 2002:a1c:f30d:: with SMTP id q13mr4415670wmq.60.1568748851292;
        Tue, 17 Sep 2019 12:34:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx3xHb0JukXUbTTMqcE+trhGmnmjzDMa5Z3XBlqh10WpRucLlMRP54wV5iwJ6ivbZUAj4q45A==
X-Received: by 2002:a1c:f30d:: with SMTP id q13mr4415656wmq.60.1568748850969;
        Tue, 17 Sep 2019 12:34:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c111:7acd:8e1e:ee6f? ([2001:b07:6468:f312:c111:7acd:8e1e:ee6f])
        by smtp.gmail.com with ESMTPSA id a18sm6896472wrh.25.2019.09.17.12.34.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2019 12:34:10 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Use DEFINE_DEBUGFS_ATTRIBUTE for debugfs files
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Yi Wang <wang.yi59@zte.com.cn>, rkrcmar@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, up2wing@gmail.com, wang.liang82@zte.com.cn
References: <1563780839-14739-1-git-send-email-wang.yi59@zte.com.cn>
 <31eec57f-2bc8-0ea0-e5fb-6b21ce902aae@redhat.com>
 <20190917181240.GA1572563@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <533b250a-56c4-34c9-c294-15ee19ed4e65@redhat.com>
Date:   Tue, 17 Sep 2019 21:34:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190917181240.GA1572563@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/09/19 20:12, Greg Kroah-Hartman wrote:
> On Tue, Sep 17, 2019 at 07:18:33PM +0200, Paolo Bonzini wrote:
>> On 22/07/19 09:33, Yi Wang wrote:
>>> We got these coccinelle warning:
>>> ./arch/x86/kvm/debugfs.c:23:0-23: WARNING: vcpu_timer_advance_ns_fops
>>> should be defined with DEFINE_DEBUGFS_ATTRIBUTE
>>> ./arch/x86/kvm/debugfs.c:32:0-23: WARNING: vcpu_tsc_offset_fops should
>>> be defined with DEFINE_DEBUGFS_ATTRIBUTE
>>> ./arch/x86/kvm/debugfs.c:41:0-23: WARNING: vcpu_tsc_scaling_fops should
>>> be defined with DEFINE_DEBUGFS_ATTRIBUTE
>>> ./arch/x86/kvm/debugfs.c:49:0-23: WARNING: vcpu_tsc_scaling_frac_fops
>>> should be defined with DEFINE_DEBUGFS_ATTRIBUTE
>>>
>>> Use DEFINE_DEBUGFS_ATTRIBUTE() rather than DEFINE_SIMPLE_ATTRIBUTE()
>>> to fix this.
>>>
>>> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
>>
>> It sucks though that you have to use a function with "unsafe" in the name.
> 
> I agree, why make this change?
> 
>> Greg, is the patch doing the right thing?
> 
> I can't tell.  What coccinelle script generated this patch?

Seems to be scripts/coccinelle/api/debugfs/debugfs_simple_attr.cocci.

//# Rationale: DEFINE_SIMPLE_ATTRIBUTE + debugfs_create_file()
//# imposes some significant overhead as compared to
//# DEFINE_DEBUGFS_ATTRIBUTE + debugfs_create_file_unsafe().

Paolo

> thanks,
> 
> greg k-h
> 

