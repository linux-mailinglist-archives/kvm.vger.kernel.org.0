Return-Path: <kvm+bounces-190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7E947DCCD8
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 13:22:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A75C81C20C6D
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 12:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A50A1DA5F;
	Tue, 31 Oct 2023 12:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vk/OE8j5"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CB81DA4D
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 12:22:17 +0000 (UTC)
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061BE98;
	Tue, 31 Oct 2023 05:22:16 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-32deb2809daso3560505f8f.3;
        Tue, 31 Oct 2023 05:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698754934; x=1699359734; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s2Z3nezCqTwH2BJQCZtQak+101Mqilb66MpCFaczsFs=;
        b=Vk/OE8j5aeRoVx5xxfDFJcB8PGPzVBfqlMbRzZaiJr70y6KAgM/kY3BP5/XbN21VIT
         v7P13OJ3LC379LTkdANgBmQ9dRLqqOs4g1fvmWSVHpHkoRtNg0TS681qFcyhyCKbwAQC
         BXNOAq6c+KxRkTouGvrQ1N+qgGCPjWzWVx4SlRQnaL1nC2uZ+xVbCOy8qhixFLidN/N3
         AKARPfrgP1XyXGPIxXOFsQHKSZ9GCrsSGxdhv2JcwRkjR9A34JA8THl6/o7eit+V+R0I
         E2lk55Kh5O/+d3c7bP4f+4xEsIYlyDuTpnmDJ965yrpNfaCeYOozh6KjvSdSp57T5YUg
         tXuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698754934; x=1699359734;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s2Z3nezCqTwH2BJQCZtQak+101Mqilb66MpCFaczsFs=;
        b=IlSwDQfFcJwqgf8avTDwlYkI5ONVAyn5yHE0QJZWsd/TfuisPnWZdtnLJ8jh/28090
         PYsthYdftHdzzIklih9yc0DNwvali/TvSdULjc93TEqpRisoVWcHj9KhpnIbj6SgWUNz
         BuoAQD2bA7rykfuaawtlkiSgKyJYMnS1eQCmFi/ZcPH/KUOffJY13doVed6DK9z8Ea7B
         t3Y6qm/iEPTq3FJrZPIKtqZClFJXxZv5PduI/IwqGszcpbZZ1RUtGuP1+MBf4mBOwDE0
         UvLJSwtRgT7XScVcKlgsQivtKN/NoWszF0Dm5mhbSwxLDFuCL+/C/MyNK0HmWd72T4PN
         Mcqw==
X-Gm-Message-State: AOJu0YyDexwFS96bX37t6xVpUK74C4JepME8vLtoeiA6CQqOtT506doV
	Zk8DfyYSFLulbDnjkGUaPrU=
X-Google-Smtp-Source: AGHT+IEttRhp1/NOYUvlkNgiMGRZbEpHMy7xazY41UZqIVz6U9rY6Bly/gMlBHrm6QhanUn2JvfmbQ==
X-Received: by 2002:a05:6000:b8d:b0:32d:9395:dec6 with SMTP id dl13-20020a0560000b8d00b0032d9395dec6mr10018028wrb.67.1698754934351;
        Tue, 31 Oct 2023 05:22:14 -0700 (PDT)
Received: from [10.95.146.166] (54-240-197-230.amazon.com. [54.240.197.230])
        by smtp.gmail.com with ESMTPSA id a8-20020adffac8000000b003296b488961sm1403305wrs.31.2023.10.31.05.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Oct 2023 05:22:13 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <a2a13598-6d37-47a2-8a13-9963acb0f1e5@xen.org>
Date: Tue, 31 Oct 2023 12:22:08 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH] KVM: x86/xen: improve accuracy of Xen timers
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, Paul Durrant
 <xadimgnik@gmail.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>
References: <96da7273adfff2a346de9a4a27ce064f6fe0d0a1.camel@infradead.org>
 <1a679274-bbff-4549-a1ea-c7ea9f1707cc@xen.org>
 <F80266DD-D7EF-4A26-B9F8-BC33EC65F444@infradead.org>
 <6c9671b4-d997-42ac-9821-06accb97357f@xen.org>
 <1DCDC3DB-81E8-426C-AF4B-AA7CA2C1271E@infradead.org>
Organization: Xen Project
In-Reply-To: <1DCDC3DB-81E8-426C-AF4B-AA7CA2C1271E@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/10/2023 12:11, David Woodhouse wrote:
> 
> 
> On 31 October 2023 12:06:17 GMT, Paul Durrant <xadimgnik@gmail.com> wrote:
>> On 31/10/2023 11:42, David Woodhouse wrote:
>>> Secondly, it's also wrong thing to do in the general case. Let's say KVM does its thing and snaps the kvmclock backwards in time on a KVM_REQ_CLOCK_UPDATE... do we really want to reinterpret existing timers against the new kvmclock? They were best left alone, I think.
>>
>> Do we not want to do exactly that? If the master clock is changed, why would we not want to re-interpret the guest's idea of time? That update will be visible to the guest when it re-reads the PV clock source.
> 
> Well no, because the guest set that timer *before* we yanked the clock from under it, and probably wants it interpreted in the time scale which was in force at the time it was set.
> 
> But more to the point, KVM shouldn't be doing that! We need to *fix* the kvmclock brokenness, not design further band-aids around it.

Ok, fair enough.

> 
> As I said, this patch stands even *after* we fix kvmclock, because it handles the timer delta calculation from an single TSC read.
> 
> But overengineering a timer reset on KVM_REQ_CLOCK_UPDATE would not.

I'm not sure what you intend to do to kvmlock, so not sure whether we'll 
still need the __pvclock_read_cycles(&vcpu->arch.hv_clock, guest_tsc) 
but this patch (with the extra check on validity of hv_clock) does fix 
the drift so...

Reviewed-by: Paul Durrant <paul@xen.org>


