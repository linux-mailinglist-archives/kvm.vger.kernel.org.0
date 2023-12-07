Return-Path: <kvm+bounces-3788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 609D1807E3B
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 03:13:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9201B2823FA
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 02:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FAB31847;
	Thu,  7 Dec 2023 02:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BhAKScNb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A8DD3;
	Wed,  6 Dec 2023 18:12:50 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-5c67c1ad5beso1172195a12.1;
        Wed, 06 Dec 2023 18:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701915170; x=1702519970; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F6X+T6Mykykh8vGh/oY1a46+a1k6SSaP+1sG2gyssig=;
        b=BhAKScNbJGRIvZeACEQHXCZCSZ6Yc81roGd79ltVBPr3jYTndDVRYPGHkGvxNZZXnV
         zsnFwRxqWMZIoeO3Ie82MzSG5RQ61EtAxu3z6SJX4YpIcu08AS8x54EYGgPDxKRsjpVv
         QhJqH1VrEjs5NCb3KWfF9Seh5Pwf7OtBVKm4Zo9gCxVUZxKPL/HGdVo/bpArOYoSok4g
         C5q1KsyuZF5yRLsbQ8CcYagvL/26uV1GQ8fpyN5RIFrpJ9UYl2GZFkPOegQZ2LwPU622
         nVScKp341T+Ty/sXntgo01pQfTRR+uHu6HCh1Acn5OHMiLQc6s9RosTE/pvRz03k4x99
         SF6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701915170; x=1702519970;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F6X+T6Mykykh8vGh/oY1a46+a1k6SSaP+1sG2gyssig=;
        b=BTf7Psn33M+Bd//30msvU9TGF+NEMLPxygTMncjvfY+BdL5cttUwPFmTzPH5fSeaYQ
         4h1ZOnIJPBFimdy3DPVP9nog+zQQLyOTwGOnjDLRF+I/JNmLS+tWMHNobDkp6onYBG/P
         XrBRC0VBObQixG0gG7iciBY3WxGPqmpCN1Zg7QRaQMd1Zl1OwbnEloBzPWNmDCnXnG1P
         BGyThW1xFM8GoeIEZbu6TNilpRxgPkoT3EVklSH0RiVDmRHnHAT5q5LEQ8armriS1Gj0
         4KCR0KxEJ9gGkzd1u9ikwuH8NHykzpQgbogn/0Rg8h+QIA+MHxYp2lbW8H9haY/rZpvT
         /Eog==
X-Gm-Message-State: AOJu0YyMCB8/QRAFr/gVaee+GmjyRyf4RrGshVrNOjJ0iETOjMSN+TOu
	UuV7HzLkw1uwpestZBhIXXLnFZb06o1iBQ==
X-Google-Smtp-Source: AGHT+IEMDYpDtRl5H20Km/BPuAkybvz4ljAPGqM7u+9sIRmz37yrU5pvxP1j1d6oMO//3CfpB/UvfQ==
X-Received: by 2002:a17:90b:1b0e:b0:286:7c79:8dc7 with SMTP id nu14-20020a17090b1b0e00b002867c798dc7mr2323708pjb.11.1701915170147;
        Wed, 06 Dec 2023 18:12:50 -0800 (PST)
Received: from [192.168.255.10] ([203.205.141.83])
        by smtp.gmail.com with ESMTPSA id pb11-20020a17090b3c0b00b00286ed94466dsm93380pjb.32.2023.12.06.18.12.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Dec 2023 18:12:49 -0800 (PST)
Message-ID: <6cd419ff-97d9-495b-bc9c-0c53c4b1e3d1@gmail.com>
Date: Thu, 7 Dec 2023 10:12:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: x86/intr: Explicitly check NMI from guest to
 eliminate false positives
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andi Kleen <ak@linux.intel.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20231206032054.55070-1-likexu@tencent.com>
 <ZXCTppx4II1sbRAl@google.com>
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZXCTppx4II1sbRAl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/2023 11:30 pm, Sean Christopherson wrote:
> Please don't make up random prefixes.  This should really be "x86/pmu".

Thanks.

I'm hesitant to categorize about NMI handling into kvm/pmu scope. But you
have clear idea on it and it's fine to me. Please feel free to refine commit
message to fit your understanding and taste as you did.

> 
>  From Documentation/process/maintainer-kvm-x86.rst:
> 
> Shortlog
> ~~~~~~~~
> The preferred prefix format is ``KVM: <topic>:``, where ``<topic>`` is one of::
> 
>    - x86
>    - x86/mmu
>    - x86/pmu
>    - x86/xen
>    - selftests
>    - SVM
>    - nSVM
>    - VMX
>    - nVMX
> 
> 
> ...
> 
> New topics do occasionally pop up, but please start an on-list discussion if
> you want to propose introducing a new topic, i.e. don't go rogue.

