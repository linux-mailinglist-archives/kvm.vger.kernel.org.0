Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 265B511836B
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 10:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfLJJUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 04:20:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58636 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726883AbfLJJUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 04:20:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575969600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/bYiIJtudCWkuxmJ3U7uh+uE9YOFh6uPtLmRweTcPTI=;
        b=AVYNTqOhDE6yi9AoQuiqzKFpZTwyXmsSTA8azI91hwphWzbKwh7w+I88h+Fv7WpBagkWWo
        +Nh7UwZsEq9u/FE1s1/5Sw/YTM3M9L9IS9WGwXRjgVPX8AXvjpuMYjjTgK2T3zUj34KbFK
        JGw7WNlaw4DMFK/S/eZl56M0ff+aiTU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-c-QwPJFbMUq3Ipf4lhjQ9g-1; Tue, 10 Dec 2019 04:19:59 -0500
Received: by mail-wr1-f72.google.com with SMTP id c17so8639280wrp.10
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 01:19:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/bYiIJtudCWkuxmJ3U7uh+uE9YOFh6uPtLmRweTcPTI=;
        b=Nfar0+JV5oM86zVMqNe6oAYbVXgLpf96Qgf63Q7T3ZElp54ClSi7B3+5Pvn4g3oKfw
         2Q4FD5e1AwJSQf5fY17Juf16qxFzaMpC8yMBKi8Hc502LtKNc5GrU4HWGSvHtm7D8gLc
         tx0Bsvgm0OZa3hfbMWJk+2SnpOX5YJdBp1bRkuDk0qHNUra8n7jVQUGBxCp5tBu1IKAW
         31BMsWX46TOknYYumY45XryIjk+EOfLFfw6mM5bjOyXLUPdaX54vIvK0Jho/XIssA+Qq
         5Thys8cksr3hb9Sn/1+SDQIXCGUGePgBDs6vBoq1cSJ61jgS369X1Wi8j8pA1vSzO4mj
         1dvA==
X-Gm-Message-State: APjAAAXyBnboHzSMyjkNbC27G1XqCkY3Wmut0A6TF4lPNCRMMYuCwD+f
        iYkEwnHS5WxN+mE2Hml71SAar7G30BP5n2tFof6FB/de3xw8ZuF5N2DWD7oR2saiqGY1Vq0oaPI
        d1CfUsVH2uPUW
X-Received: by 2002:adf:f803:: with SMTP id s3mr1955416wrp.7.1575969597796;
        Tue, 10 Dec 2019 01:19:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqwzDnyT2KZKAXq1IvkcmoircMXuSHIe+B7ZX1hbvwigcGPf4Y/msYzb6HapPfHPkh1RodEdyw==
X-Received: by 2002:adf:f803:: with SMTP id s3mr1955389wrp.7.1575969597600;
        Tue, 10 Dec 2019 01:19:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id m3sm2549644wrs.53.2019.12.10.01.19.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 01:19:57 -0800 (PST)
Subject: Re: [PATCH v2] KVM: x86: use CPUID to locate host page table reserved
 bits
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, stable@vger.kernel.org
References: <1575474037-7903-1-git-send-email-pbonzini@redhat.com>
 <20191204154806.GC6323@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9951afb8-8f91-2fe1-3893-04307fafa570@redhat.com>
Date:   Tue, 10 Dec 2019 10:19:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191204154806.GC6323@linux.intel.com>
Content-Language: en-US
X-MC-Unique: c-QwPJFbMUq3Ipf4lhjQ9g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/12/19 16:48, Sean Christopherson wrote:
>> +	/*
>> +	 * Quite weird to have VMX or SVM but not MAXPHYADDR; probably a VM with
>> +	 * custom CPUID.  Proceed with whatever the kernel found since these features
>> +	 * aren't virtualizable (SME/SEV also require CPUIDs higher than 0x80000008).
> No love for MKTME?  :-D

I admit I didn't check, but does MKTME really require CPUID leaves in
the "AMD range"?  (My machines have 0x80000008 as the highest supported
leaf in that range).

Paolo

