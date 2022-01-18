Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720C0491F5C
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 07:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241693AbiARGZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 01:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiARGZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 01:25:32 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3690EC061574
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 22:25:32 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo1876229pjb.2
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 22:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=aTnd4qhFMq647A9rnsLhOHTMXCmJvKj7Yo5qShVI1kc=;
        b=XM98BLaa5ICs5Ko0zyUGfOaTS+RcHFlAQiTGuMcnGXP3M9uFzxkiUPYtIKfaaptTpw
         fjahoenxTexY+qrk2lNeCJTjiY77K+OoqBZJdQ2lpbfuslhtgD0yqCwHvIym6emkHmvM
         zVXmj5OXGm+XCCPGctShiOublPL3lRg2aedJdGUfIDzyBwJypfURy0Ot2Zv3GzD405Wd
         y8MaDN+yiTe15pFh1NbuQGzv9khRXr+vE8n9YiTf1saFCPt4VRrfOz+Mk3yueUXvzSSd
         b7yXmW61S5ggaG4shGlI+TqUMC3/dlCQLcuM/+jVtRsUTK+ZbLt5xA8mE7EWnH+CHSkJ
         dO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=aTnd4qhFMq647A9rnsLhOHTMXCmJvKj7Yo5qShVI1kc=;
        b=c/bazF5Be/IXsgopz4jHOMCEYQnmKmh4WXxudVcnY4nTIl3XqgIuMm9f0i4sxtdpLk
         6rpIAQExZQ8o1thbUOQOBJPcpxgRvxg4MdvhJ0exlofhB6JtWrVSlla3YJLkMmO97R3r
         IZOlDT4HUj4MKHxEoZiDsHavFQyc2cK//V7uDQuhTIZKnBVkyJ2ZLRJ7CJUndUV7H8xs
         brcQrS7EYeq0v/JEtr+Okolm5PzUmU+NevC0hmMSOCQqCK0rh1DRZJBPrCSN3THUo2cK
         87kdDyK1uUCth/q+gk/u0uRvdOVQq14hNNUYpgZm0Xb14Z59Hu0ecRwqSYCdQXQgJM82
         5ZwA==
X-Gm-Message-State: AOAM530uL2XJiCTzDaF+X0zR6oMzvj7U8YfEH2CowRJk84KIS/sEvjHa
        95Pj0r3eIU38TzCFzt+8U3g=
X-Google-Smtp-Source: ABdhPJzwQVr0jhKHXdSjNvJtsrEvW372vxct513q9yQNgj84fPYlCYYLQR4B5cOvL9LGbN90N1tfiQ==
X-Received: by 2002:a17:90a:bb8c:: with SMTP id v12mr37218240pjr.100.1642487131760;
        Mon, 17 Jan 2022 22:25:31 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id me11sm1370967pjb.34.2022.01.17.22.25.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 22:25:31 -0800 (PST)
Message-ID: <b3cffb4b-8425-06bb-d40e-89e7f01d5c05@gmail.com>
Date:   Tue, 18 Jan 2022 14:25:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Ananth Narayan <ananth.narayan@amd.com>
References: <CALMp9eQZa_y3ZN0_xHuB6nW0YU8oO6=5zPEov=DUQYPbzLeQVA@mail.gmail.com>
 <453a2a09-5f29-491e-c386-6b23d4244cc2@gmail.com>
 <CALMp9eSkYEXKkqDYLYYWpJ0oX10VWECJTwtk_pBWY5G-vN5H0A@mail.gmail.com>
 <CALMp9eQAMpnJOSk_Rw+pp2amwi8Fk4Np1rviKYxJtoicas=6BQ@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: PMU virtualization and AMD erratum 1292
In-Reply-To: <CALMp9eQAMpnJOSk_Rw+pp2amwi8Fk4Np1rviKYxJtoicas=6BQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/1/2022 12:08 pm, Jim Mattson wrote:
> On Mon, Jan 17, 2022 at 12:57 PM Jim Mattson <jmattson@google.com> wrote:
>>
>> On Sun, Jan 16, 2022 at 8:26 PM Like Xu <like.xu.linux@gmail.com> wrote:
>> ...
>>> It's easy for KVM to clear the reserved bit PERF_CTL2[43]
>>> for only (AMD Family 19h Models 00h-0Fh) guests.
>>
>> KVM is currently *way* too aggressive about synthesizing #GP for
>> "reserved" bits on AMD hardware. Note that "reserved" generally has a
>> much weaker definition in AMD documentation than in Intel
>> documentation. When Intel says that an MSR bit is "reserved," it means
>> that an attempt to set the bit will raise #GP. When AMD says that an
>> MSR bit is "reserved," it does not necessarily mean the same thing.

I agree. And I'm curious as to why there are hardly any guest user complaints.

The term "reserved" is described in the AMD "Conventions and Definitions":

	Fields marked as reserved may be used at some future time.
	To preserve compatibility with future processors, reserved fields require 
special handling when
	read or written by software. Software must not depend on the state of a 
reserved field (unless
	qualified as RAZ), nor upon the ability of such fields to return a previously 
written state.

	If a field is marked reserved *without qualification*, software must not change 
the state of
	that field; it must reload that field with the same value returned from a prior 
read.
	
	Reserved fields may be qualified as IGN, MBZ, RAZ, or SBZ.

For AMD, #GP comes from "Writing 1 to any bit that must be zero (MBZ) in the MSR."

>> (Usually, AMD will write MBZ to indicate that the bit must be zero.)
>>
>> On my Zen3 CPU, I can write 0xffffffffffffffff to MSR 0xc0010204,
>> without getting a #GP. Hence, KVM should not synthesize a #GP for any
>> writes to this MSR.
>>

; storage behind bit 43 test
; CPU family:          25
; Model:               1

wrmsr -p 0 0xc0010204 0x80000000000
rdmsr -p 0 0xc0010204 # return 0x80000000000

>> Note that the value I get back from rdmsr is 0x30fffdfffff, so there
>> appears to be no storage behind bit 43. If KVM allows this bit to be
>> set, it should ensure that reads of this bit always return 0, as they
>> do on hardware.

The PERF_CTL2[43] is marked reserved without qualification in the in Figure 13-7.

I'm not sure we really need a cleanup storm of #GP for all SVM's non-MBZ 
reserved bits.

> 
> Bit 19 (Intel's old Pin Control bit) seems to have storage behind it.
> It is interesting that in Figure 13-7 "Core Performance Event-Select
> Register (PerfEvtSeln)" of the APM volume 2, this "reserved" bit is
> not marked in grey. The remaining "reserved" bits (which are marked in
> grey), should probably be annotated with "RAZ."
> 

In any diagram, we at least have three types of "reservation":

- Reserved + grey
- Reserved, MBZ + grey
- Reserved + no grey

So it is better not to think of "Reserved + grey" as "Reserved, MBZ + grey".

