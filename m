Return-Path: <kvm+bounces-1317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10B727E6756
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 11:06:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C776E2813A1
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 10:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 792B715AC0;
	Thu,  9 Nov 2023 10:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Svu4rloa"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164C914285
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 10:06:49 +0000 (UTC)
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D102D79;
	Thu,  9 Nov 2023 02:06:48 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id 38308e7fff4ca-2c50ec238aeso8481851fa.0;
        Thu, 09 Nov 2023 02:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699524407; x=1700129207; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ziH0evbWe+MkV0AfceDy6ohEFNGYBOK5CmtTzEQCRBk=;
        b=Svu4rloaqTvKWJznkkmEbTSi12m9NWSIYYE+3JkNvBD2ocih8/x93h7kERlfDxCGPu
         DGXYCut5bKAte6jkv1XScxCn1Jp/7/HL8Ak+UsrVMHBpMjgoqLKFTpSSjyAUFTRvi5mb
         LdHHDcfqyZpWW/RAsfpZYaL4+GxjCerkeF1f5ToB3DUmivR65+vzQ2XNPcmzkDIw/lIi
         V7oFDfz4jV2iixTm1mXG9DPLXOKtZ03sMO28DAceENnLfehZGGTCymzMBVJpccVmnamH
         B0F8OoQfOgMvVQp8CA44A08LsO2p5GYSUniylLUo9AlmnMJCj+QPrnDFzy1ghyotlV68
         ILKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699524407; x=1700129207;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ziH0evbWe+MkV0AfceDy6ohEFNGYBOK5CmtTzEQCRBk=;
        b=W8VHwb6cUDnGcxTnZhBEgSSt2h5Y+0sQBKzSRJb8l/xdyAzo7BXRNQAty8s97jjDDd
         MZtcoySY78LNrghCAueyzs4jvlE+dNDqhaPlfaFsVwPgAujxQXzaoljV/SSj3/SD31KE
         VZjikLp46xhVo+js+Xj/HqTZ05tQXb3yK7YQg4a0m64WJvh+HTpoCR9Mjd+sAmpYSSOf
         9g7y9Rl2IQ9kIyGlwU4H0+jq32d3obTdovAkzIFhktPtYRx2MXPervto0k5NVNsV2aWf
         Kx0EG6KmJX6OtDPeSFZC3gBNp58/q+kW2c99QPtOaLEvED1cLOAvGB8wcjzftvP6EtN/
         dM9A==
X-Gm-Message-State: AOJu0YwT+d/iy4dmYaz2CVz/yY52UzpMv0Sg0z5pXVl3VrLcogTLA+Vh
	RwLd/wMqRzSR3umNSr4jWBI=
X-Google-Smtp-Source: AGHT+IEXVZ/aDOimk6Eks94c9xbwgB5ss6PN7WwJfVoVAEWfsiJeVVPWfibJtnLANdc0DIO/eVeb6g==
X-Received: by 2002:a05:6512:488a:b0:509:b3f:8a7b with SMTP id eq10-20020a056512488a00b005090b3f8a7bmr939296lfb.22.1699524406879;
        Thu, 09 Nov 2023 02:06:46 -0800 (PST)
Received: from [192.168.12.204] (54-240-197-239.amazon.com. [54.240.197.239])
        by smtp.gmail.com with ESMTPSA id j6-20020a5d6046000000b0032fc5f5abafsm7034674wrt.96.2023.11.09.02.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Nov 2023 02:06:46 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <b7d0c879-3c44-4f44-b796-78c0d3855976@xen.org>
Date: Thu, 9 Nov 2023 10:06:40 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v7 00/11] KVM: xen: update shared_info and vcpu_info
 handling
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Paul Durrant <pdurrant@amazon.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, x86@kernel.org
References: <20231002095740.1472907-1-paul@xen.org>
 <6629b7f0b56e0fb2bad575a1d598cce26b1c6432.camel@infradead.org>
 <bf34f990-4f32-4cd3-9dd0-df1cf9187b25@xen.org>
 <117d1e78e7277177236dabc616ade178fdc336fa.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <117d1e78e7277177236dabc616ade178fdc336fa.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 09/11/2023 10:02, David Woodhouse wrote:
> On Thu, 2023-10-05 at 09:36 +0100, Paul Durrant wrote:
>> On 05/10/2023 07:41, David Woodhouse wrote:
>>> On Mon, 2023-10-02 at 09:57 +0000, Paul Durrant wrote:
>>>> From: Paul Durrant <pdurrant@amazon.com>
>>>>
>>>> The following text from the original cover letter still serves as an
>>>> introduction to the series:
>>>>
>>>> "Currently we treat the shared_info page as guest memory and the VMM
>>>> informs KVM of its location using a GFN. However it is not guest memory as
>>>> such; it's an overlay page. So we pointlessly invalidate and re-cache a
>>>> mapping to the *same page* of memory every time the guest requests that
>>>> shared_info be mapped into its address space. Let's avoid doing that by
>>>> modifying the pfncache code to allow activation using a fixed userspace HVA
>>>> as well as a GPA."
>>>>
>>>> This version of the series is functionally the same as version 6. I have
>>>> simply added David Woodhouse's R-b to patch 11 to indicate that he has
>>>> now fully reviewed the series.
>>>
>>> Thanks. I believe Sean is probably waiting for us to stop going back
>>> and forth, and for the dust to settle. So for the record: I think I'm
>>> done heckling and this is ready to go in.
>>>
>>> Are you doing the QEMU patches or am I?
>>>
>>
>> I'll do the QEMU changes, once the patches hit kvm/next.
> 
> Note that I disabled migration support in QEMU for emulated Xen
> guests. You might want that for testing, since the reason for this work
> is to enable pause/serialize workflows.
> 
> Migration does work all the way up to XenStore itself, and
> https://gitlab.com/qemu-project/qemu/-/commit/766804b101d *was* tested
> with migration enabled. There are also unit tests for XenStore
> serialize/deserialize.
> 
> I disabled it because the PV backends on the XenBus don't have
> suspend/resume support. But a guest using other emulated net/disk
> devices should still be able to suspend/resume OK if we just remove the
> 'unmigratable' flag from xen_xenstore, I believe.

Ok. Enabling suspend/resume for backends really ought not to be that 
hard. The main reason for this series was to enable pause 
for-for-memory-reconfiguration but I can look into 
suspend/resume/migrate once I've done the necessary re-work.


