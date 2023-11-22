Return-Path: <kvm+bounces-2269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29A8C7F445D
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 11:55:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59DB01C20ABA
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 10:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 000AC20B28;
	Wed, 22 Nov 2023 10:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HL/0JAtj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9F19E;
	Wed, 22 Nov 2023 02:55:35 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2c87adce180so45605041fa.0;
        Wed, 22 Nov 2023 02:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700650534; x=1701255334; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PDj4B8tTKHknHxb5LSqmGL6/2c2RSafLpktnB37g/4s=;
        b=HL/0JAtjo0yLGYjma9U8XwcOXHuL18Hd+WHL33V99kWnb0DiY+Wh3t54xsmr9c24fW
         5gTZx06IPFaJpeD6XgMYZ0wkxz4MbMzPoxnfrGrHV0wwDNTxfuVKLxkckM4PG6uEiS2R
         6oCHwDuUtEsEBhETdaRKULM9R/AteByH8RtMYKU5UHMiIzEb8uDNIkhtTVf79dR51wVX
         AVa0HYCU3HKgNIQKHy7NRy7fzbhRIJseQ7o8d2UcwpXo60CH+RVrTO9Au3ihGs2a3OBP
         wiae3kzTqgnH7AE/JLeUt2Qyv+XmDBoOaMjN7w++b06/CB+1jlmrwcfGl2upXFnl+iPV
         BIlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700650534; x=1701255334;
        h=content-transfer-encoding:in-reply-to:organization:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PDj4B8tTKHknHxb5LSqmGL6/2c2RSafLpktnB37g/4s=;
        b=Ucw2q2j//mzMO479Do0SyOgS6XtdQSpk2EfTXa0A9OvKVNeceoLRitGK9jwQCKIAkk
         9lHO3Rk+9QAr8X251FKYjtjA/uz5lUgMveiHCoRV0NYXMcx24f0bGEjBBLTxTXsXe0TK
         +8D+E5UgsFSo2iZSO08x3xjfqHxbfvVJWoFSfiFgb/cRf4N8z7tNgz1kGNjy8fIxNvf4
         i4JCzS8a7SpnMBYf/igeiWfbuenUsl9z6OEkGsjJXDtXTjDx2KXAiU7Al0tufangwVGn
         P99fWlmHldTFKH2jOwyS9Epj/843qI1ep/6alniofj4sp0DdAEiXOhKQh5s6qr6J3aJm
         w9rg==
X-Gm-Message-State: AOJu0YwRD2wTLjI+QuJ3SqpsX82WSPELotr2iLnHVgCuktW85pWXY1Lz
	KQ+V13h94oHSjAuM/rLmCzg=
X-Google-Smtp-Source: AGHT+IHnbvXvm8EJIvq93WQO/F7f6niG7Cc+eqUmPP4FrhRHF/fZxfAVe7xF7vnquqfdMCmL5tqvUQ==
X-Received: by 2002:a2e:8e68:0:b0:2c6:ed5e:bbf0 with SMTP id t8-20020a2e8e68000000b002c6ed5ebbf0mr1251662ljk.34.1700650533262;
        Wed, 22 Nov 2023 02:55:33 -0800 (PST)
Received: from [10.95.134.92] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id v9-20020a05600c444900b0040836519dd9sm1835991wmn.25.2023.11.22.02.55.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Nov 2023 02:55:32 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <94697586-7600-420d-a91b-2829019dab7c@xen.org>
Date: Wed, 22 Nov 2023 10:55:30 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v8 15/15] KVM: xen: allow vcpu_info content to be 'safely'
 copied
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231121180223.12484-1-paul@xen.org>
 <20231121180223.12484-16-paul@xen.org>
 <4a76b7dc9055485d9e2592b395e60221dc349abf.camel@infradead.org>
 <7c7238a9c8b0dc6bc865407ba804a651cdfdb044.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <7c7238a9c8b0dc6bc865407ba804a651cdfdb044.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/11/2023 10:39, David Woodhouse wrote:
> On Tue, 2023-11-21 at 22:53 +0000, David Woodhouse wrote:
>> On Tue, 2023-11-21 at 18:02 +0000, Paul Durrant wrote:
>>> From: Paul Durrant <pdurrant@amazon.com>
>>>
>>> If the guest sets an explicit vcpu_info GPA then, for any of the first 32
>>> vCPUs, the content of the default vcpu_info in the shared_info page must be
>>> copied into the new location. Because this copy may race with event
>>> delivery (which updates the 'evtchn_pending_sel' field in vcpu_info) there
>>> needs to be a way to defer that until the copy is complete.
>>> Happily there is already a shadow of 'evtchn_pending_sel' in kvm_vcpu_xen
>>> that is used in atomic context if the vcpu_info PFN cache has been
>>> invalidated so that the update of vcpu_info can be deferred until the
>>> cache can be refreshed (on vCPU thread's the way back into guest context).
>>>
>>> Also use this shadow if the vcpu_info cache has been *deactivated*, so that
>>> the VMM can safely copy the vcpu_info content and then re-activate the
>>> cache with the new GPA. To do this, stop considering an inactive vcpu_info
>>> cache as a hard error in kvm_xen_set_evtchn_fast().
>>>
>>> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
>>> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
>>
>> Wait, didn't we realise that this leaves the bits set in the shadow
>> evtchn_pending_sel that get lost on migration?
>>

Indeed we did not, but that's not something that *this* patch, or even 
this series, is dealing with.  We also know that setting the 'width' of 
shared_info has some issues, but again, can we keep that for other 
patches? The series is at v9 and has already suffered a fair amount of 
scope-creep.

   Paul


