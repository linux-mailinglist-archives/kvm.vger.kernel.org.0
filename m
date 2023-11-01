Return-Path: <kvm+bounces-316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C54257DE1DC
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 15:04:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64C8FB20ECD
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 14:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7592134DA;
	Wed,  1 Nov 2023 14:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gfkaqc88"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0983E134A3
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 14:04:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC03183
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 07:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698847481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KU8sdn3CDmnUGLVhZ2woY8ZKBPjZCE6EPlmsSYG4PRQ=;
	b=gfkaqc88rDvbh2m7fzb5fJ3P8tXpGKVu2LRe1A6YmA1JEhyF5wligb3lOsh7rHadexEgc+
	VUTDxRY87WWOTNBQVQQRT7P8SxzyG5tTAn8W4JDU8SsxHLpgVAgRSSfPPW9wbIWsV7zbEs
	wrH/4aJpwpZzHVP2hriB8cXOoDRAvAo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-GcP990z9PeSYsRFpZgeYjA-1; Wed, 01 Nov 2023 10:04:37 -0400
X-MC-Unique: GcP990z9PeSYsRFpZgeYjA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-32d83fd3765so3349721f8f.3
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 07:04:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698847472; x=1699452272;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KU8sdn3CDmnUGLVhZ2woY8ZKBPjZCE6EPlmsSYG4PRQ=;
        b=O18bsWCTw2GZ8scH3cHgiBZXZkNr5NuAYhByjgi6nn341/1lRY7HTLnPjjaLfTVhgi
         pqDOJizmY7L3fhbt9bK0kk6JgUnmBId58zbMMZ99ClS9nQwBVUvsz0QqiSNz7KokfX+m
         DCX0FzC04OWaDKPlpQ9YoQ7f5IDI2oCXZ1LPdivfOsvK3FUNXYYuBgojam7Dj+yF6hJ9
         WFzR4bKZLlP2V5uCawiu9ZzFtDZFOst5W0bK4BYwOC3ghO7jZfVFzpUoX81FYcWe8tKF
         oPtzQ3eMvHziBhAjFCUZmoNcurxO97RRZb/hnRL+0agyA7kQYUWYpRsLWIm6ZnkuKhoE
         Jk0g==
X-Gm-Message-State: AOJu0YxCD6ooGgPRmOgB/za29oCQrjlGMA9hxlkPrENIuJUWRLb/b8Hf
	hiDZNMKIWDHxLogX3QoSFLr4vUCQKCP5S/9KqpgLIMMiJ4Zeqj2MGYhBSWLgxQFQY7Tubmr6WH0
	0yPVcK/WSMLp9
X-Received: by 2002:a5d:64af:0:b0:32f:a3fb:8357 with SMTP id m15-20020a5d64af000000b0032fa3fb8357mr936587wrp.6.1698847472773;
        Wed, 01 Nov 2023 07:04:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHV0V8FtHtZfHv9dKvRDGy3JkUIh64RgV7hXzJdY6A1SEodVe+DYhpOWtVd22PSTWKR91uu3A==
X-Received: by 2002:a5d:64af:0:b0:32f:a3fb:8357 with SMTP id m15-20020a5d64af000000b0032fa3fb8357mr936564wrp.6.1698847472461;
        Wed, 01 Nov 2023 07:04:32 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id w17-20020a5d6811000000b0032d2f09d991sm4267660wru.33.2023.11.01.07.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Nov 2023 07:04:31 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Eiichi Tsukata <eiichi.tsukata@nutanix.com>, "pbonzini@redhat.com"
 <pbonzini@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>
Cc: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 "mtosatti@redhat.com"
 <mtosatti@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: [PATCH] target/i386/kvm: call kvm_put_vcpu_events() before
 kvm_put_nested_state()
In-Reply-To: <D3D6327A-CFF0-43F2-BA39-B48EE2A53041@nutanix.com>
References: <20231026054201.87845-1-eiichi.tsukata@nutanix.com>
 <D761458A-9296-492B-85B9-F196C7D11CDA@nutanix.com>
 <78ddc3c3-6cfa-b48c-5d73-903adec6ac4a@linaro.org>
 <87wmv93gv5.fsf@redhat.com>
 <D3D6327A-CFF0-43F2-BA39-B48EE2A53041@nutanix.com>
Date: Wed, 01 Nov 2023 15:04:31 +0100
Message-ID: <87edh9h8nk.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Eiichi Tsukata <eiichi.tsukata@nutanix.com> writes:

> FYI: The EINVAL in vmx_set_nested_state() is caused by the following condition:
> * vcpu->arch.hflags == 0
> * kvm_state->hdr.vmx.smm.flags == KVM_STATE_NESTED_SMM_VMXON

This is a weird state indeed,

'vcpu->arch.hflags == 0' means we're not in SMM and not in guest mode
but kvm_state->hdr.vmx.smm.flags == KVM_STATE_NESTED_SMM_VMXON is a
reflection of vmx->nested.smm.vmxon (see
vmx_get_nested_state()). vmx->nested.smm.vmxon gets set (conditioally)
in vmx_enter_smm() and gets cleared in vmx_leave_smm() which means the
vCPU must be in SMM to have it set.

In case the vCPU is in SMM upon migration, HF_SMM_MASK must be set from
kvm_vcpu_ioctl_x86_set_vcpu_events() -> kvm_smm_changed() but QEMU's
kvm_put_vcpu_events() calls kvm_put_nested_state() _before_
kvm_put_vcpu_events(). This can explain "vcpu->arch.hflags == 0".

Paolo, Max, any idea how this is supposed to work?

-- 
Vitaly


