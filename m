Return-Path: <kvm+bounces-4556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 042968144ED
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 10:56:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 374B61C226C7
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 09:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC59C24B5F;
	Fri, 15 Dec 2023 09:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BhWdUJ/4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEF324B22
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 09:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702634159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XsVx4MsxXeqsM9UmamEQoOhQwuatdwZpdHk8xWe7cXU=;
	b=BhWdUJ/4947x7hKIo0aCfsgf1Dxfl7TXoXvNhNd5NmBgy+BXsBs9qAsu/vfoLcFpmwNc2R
	7QNxbt9VfV9mY+kU+kC/hym3jlM/+nm4BCPX6JruoyI6ZqPvbn+Xn2+QI+XkOrCK/uYAF6
	rQPZG3I/G6MR39u8JFk/i1GRr1CwB6M=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-S88MhR2WOzWHxLQIT3r8Gg-1; Fri, 15 Dec 2023 04:55:58 -0500
X-MC-Unique: S88MhR2WOzWHxLQIT3r8Gg-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-421b20c9893so7833331cf.0
        for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 01:55:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702634157; x=1703238957;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XsVx4MsxXeqsM9UmamEQoOhQwuatdwZpdHk8xWe7cXU=;
        b=hOIezWwim+BVq5NZeqPUcEWybgeH3oGCvEyCMyKvqxfGv5Zlc8srekYKXx6NfpSPoX
         lSwoF5ufAb+jwT4G1Y32OQMvzQ4UELJYARSviLReO/E5wQAwnVR5GWEBYaV82QrOXyYH
         nuQV/ommGq3VNh3VlMgxIKwZd+G9dO9vVCHKThU0xYQxmjlrs9rNYY8OFiCuWXZeEzOR
         t/ZaGtLWh8NiTnhNtFW05BKjx9J4FZ5Q1HCH5R9HqvbKId8xayAPiKN0TELN3NqA38be
         Q8z8WZT6+d6TLoUk+orlwl8D7LNBa3QlyBP2H0Uqe9JAVWV0k/rGa7kbcNrFJehVQa3I
         ywhQ==
X-Gm-Message-State: AOJu0YwONPU3D/X4qwtO9jAlID0Oj17Ho4nmXvw4zPr+HkcH1MMvXS9t
	ErYvBg9qMVSQQUqpR884EqF36rU8VWtha//g6jJAIHYxfGBCIxP60ezcDzkUi6MF2uepbK5p7cn
	9YlDU7RaDVfCWXOowqz6B
X-Received: by 2002:ac8:5d46:0:b0:425:aa00:cdd7 with SMTP id g6-20020ac85d46000000b00425aa00cdd7mr16876846qtx.85.1702634156952;
        Fri, 15 Dec 2023 01:55:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHRNgexYYxGeBYpv2I0o7qP+XF4lN98Nhfdv7ZmdQHRJsJB/kJYReY37LmjQ3BwLt+ONAKnSw==
X-Received: by 2002:ac8:5d46:0:b0:425:aa00:cdd7 with SMTP id g6-20020ac85d46000000b00425aa00cdd7mr16876839qtx.85.1702634156712;
        Fri, 15 Dec 2023 01:55:56 -0800 (PST)
Received: from rh (p200300c93f174f005d25f1299b34cd9e.dip0.t-ipconnect.de. [2003:c9:3f17:4f00:5d25:f129:9b34:cd9e])
        by smtp.gmail.com with ESMTPSA id cd5-20020a05622a418500b004255fd32eeasm6318380qtb.7.2023.12.15.01.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Dec 2023 01:55:56 -0800 (PST)
Date: Fri, 15 Dec 2023 10:55:51 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eauger@redhat.com>
cc: Shaoqin Huang <shahuang@redhat.com>, qemu-arm@nongnu.org, 
    Gavin Shan <gshan@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
    Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org, 
    qemu-devel@nongnu.org
Subject: Re: [PATCH v4] arm/kvm: Enable support for
 KVM_ARM_VCPU_PMU_V3_FILTER
In-Reply-To: <be70b17c-21cf-4f4e-8ec1-62c18ffd4100@redhat.com>
Message-ID: <f1b6dffb-0a23-82d2-7699-67e12691e5c4@redhat.com>
References: <20231207103648.2925112-1-shahuang@redhat.com> <be70b17c-21cf-4f4e-8ec1-62c18ffd4100@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 14 Dec 2023, Eric Auger wrote:
> On 12/7/23 11:36, Shaoqin Huang wrote:
>> +    if (kvm_vcpu_ioctl(cs, KVM_HAS_DEVICE_ATTR, &attr)) {
>> +        warn_report("The kernel doesn't support the PMU Event Filter!\n");
>> +        return;
>> +    }
>> +
>> +    /* The filter only needs to be initialized for 1 vcpu. */
> Are you sure? This is a per vcpu device ctrl. Where is it written in the
> doc that this shall not be called for each vcpu

The interface is per vcpu but the filters are actually managed per vm
(kvm->arch.pmu_filter). From (kernel) commit 6ee7fca2a ("KVM: arm64: Add 
KVM_ARM_VCPU_PMU_V3_SET_PMU attribute"):
  To ensure that KVM doesn't expose an asymmetric system to the guest, the
  PMU set for one VCPU will be used by all other VCPUs. Once a VCPU has run,
  the PMU cannot be changed in order to avoid changing the list of available
  events for a VCPU, or to change the semantics of existing events.

Sebastian


