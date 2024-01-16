Return-Path: <kvm+bounces-6328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5575882EB8E
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 10:32:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8643F1C22DA7
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 09:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D55134A0;
	Tue, 16 Jan 2024 09:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CJCFTTJC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2FC12E40
	for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 09:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705397516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RXJRf67FGygBSwTq+ImaBbYLkmHg7FGC5oYkqjq+YeA=;
	b=CJCFTTJCu5tFxfDKxn5Mokupuz49WB1M9n27cn0tnneJJ7fVDzya21OUKCQ5gynOefInec
	2nPdMlFouf35BtBU+LITHTnzG6ZL5+j13E8Y/POA5gOuwxPmetvHc+pqPEiUCeq1GfxDqb
	qm/mLlnSdHRf7qDpJLrwcSbBkV+zUes=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-138-5csJ0pXIM6i5DAT1ZEkABw-1; Tue, 16 Jan 2024 04:31:54 -0500
X-MC-Unique: 5csJ0pXIM6i5DAT1ZEkABw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40e6e3c46bfso23520755e9.1
        for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 01:31:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705397513; x=1706002313;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RXJRf67FGygBSwTq+ImaBbYLkmHg7FGC5oYkqjq+YeA=;
        b=LLk9loCiS1Yv/WkpAJgejSleBj2VrQOfTspcE50huCDXq2J1sb9KRDQIynwIJe7Z5z
         Z/lU3lVlEErmYXXhEg/SR/8/t185yFS0e42J+I25oTHAMf3noLlwHtuzWcliAJhSt2UF
         UtjscxjEzvWShAzNNVhh4cSR9H8rTRL/fqS2hg5kyorLujJWTGoSJ3vRhtcNJ6RbDTKC
         uM73W3JSbR9qHz20ZtwQs/h3Xv55mvYhmbAT1hXwsLgWZtNJtYbdkARFsQjDM3CdlA6Y
         23+9IlqO3MfqpZbPrpOdGIBaCdRgekFnDRyntX9I94XJJAwH4A1xja3N6g7gxLz2iDTS
         OHQQ==
X-Gm-Message-State: AOJu0YzzcaXriA81BDucCZHptoW9GdqPVFwWY4byap0xuk8A579ZAXG2
	P4Q4j8VE83RDNS63w+GKQeXr5ZGnSPpPgdnnmWDZ7IAPqxUpG/c3g3BBcf/1cgTY5/DAjUwGWQU
	FMP1FuT0+sPWE2aeBFdnbkvo7TmRG
X-Received: by 2002:a05:600c:1c14:b0:40e:5316:2173 with SMTP id j20-20020a05600c1c1400b0040e53162173mr3713016wms.174.1705397513286;
        Tue, 16 Jan 2024 01:31:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHeKe7WhuCPRV24M7POZhFc8IZa9D4Q02mLGeGRvGGuELJEdSNVupJg26yEu5bUuF1xeM3eEQ==
X-Received: by 2002:a05:600c:1c14:b0:40e:5316:2173 with SMTP id j20-20020a05600c1c1400b0040e53162173mr3713001wms.174.1705397512998;
        Tue, 16 Jan 2024 01:31:52 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id l39-20020a05600c1d2700b0040e50d82af5sm18762137wms.32.2024.01.16.01.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jan 2024 01:31:52 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Eiichi Tsukata <eiichi.tsukata@nutanix.com>, "pbonzini@redhat.com"
 <pbonzini@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>
Cc: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 "mtosatti@redhat.com"
 <mtosatti@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: [PATCH] target/i386/kvm: call kvm_put_vcpu_events() before
 kvm_put_nested_state()
In-Reply-To: <585D19C7-80BD-4599-ABBD-A0FE25F0ACB9@nutanix.com>
References: <20231026054201.87845-1-eiichi.tsukata@nutanix.com>
 <D761458A-9296-492B-85B9-F196C7D11CDA@nutanix.com>
 <78ddc3c3-6cfa-b48c-5d73-903adec6ac4a@linaro.org>
 <87wmv93gv5.fsf@redhat.com>
 <D3D6327A-CFF0-43F2-BA39-B48EE2A53041@nutanix.com>
 <87edh9h8nk.fsf@redhat.com>
 <7A7A55C5-6151-453A-852C-96CD10098EE6@nutanix.com>
 <585D19C7-80BD-4599-ABBD-A0FE25F0ACB9@nutanix.com>
Date: Tue, 16 Jan 2024 10:31:51 +0100
Message-ID: <87cyu1bp4o.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

As I'm the addressee of the ping for some reason ... :-)

the fix looks good to me but I'm not sure about all the consequences of
moving kvm_put_vcpu_events() to an earlier stage. Max, Paolo, please
take a look!

Eiichi Tsukata <eiichi.tsukata@nutanix.com> writes:

> Ping.
>
>> On Nov 8, 2023, at 10:12, Eiichi Tsukata <eiichi.tsukata@nutanix.com> wrote:
>> 
>> Hi all, appreciate any comments or feedbacks on the patch.
>> 
>> Thanks,
>> Eiichi
>> 
>>> On Nov 1, 2023, at 23:04, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>> 
>>> Eiichi Tsukata <eiichi.tsukata@nutanix.com> writes:
>>> 
>>>> FYI: The EINVAL in vmx_set_nested_state() is caused by the following condition:
>>>> * vcpu->arch.hflags == 0
>>>> * kvm_state->hdr.vmx.smm.flags == KVM_STATE_NESTED_SMM_VMXON
>>> 
>>> This is a weird state indeed,
>>> 
>>> 'vcpu->arch.hflags == 0' means we're not in SMM and not in guest mode
>>> but kvm_state->hdr.vmx.smm.flags == KVM_STATE_NESTED_SMM_VMXON is a
>>> reflection of vmx->nested.smm.vmxon (see
>>> vmx_get_nested_state()). vmx->nested.smm.vmxon gets set (conditioally)
>>> in vmx_enter_smm() and gets cleared in vmx_leave_smm() which means the
>>> vCPU must be in SMM to have it set.
>>> 
>>> In case the vCPU is in SMM upon migration, HF_SMM_MASK must be set from
>>> kvm_vcpu_ioctl_x86_set_vcpu_events() -> kvm_smm_changed() but QEMU's
>>> kvm_put_vcpu_events() calls kvm_put_nested_state() _before_
>>> kvm_put_vcpu_events(). This can explain "vcpu->arch.hflags == 0".
>>> 
>>> Paolo, Max, any idea how this is supposed to work?
>>> 
>>> -- 
>>> Vitaly
>>> 
>> 
>

-- 
Vitaly


