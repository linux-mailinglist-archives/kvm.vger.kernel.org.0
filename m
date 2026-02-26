Return-Path: <kvm+bounces-71938-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SPrqLEsCoGl/fQQAu9opvQ
	(envelope-from <kvm+bounces-71938-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:20:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 626111A2725
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:20:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 76C6F3077698
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:19:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 375BF38E5E6;
	Thu, 26 Feb 2026 08:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AnW6Xz2q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438BE3815E1
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 08:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772093996; cv=pass; b=hDHY03JobFwt2QejrrE8ROtL7JB33fPTyMpIG4mEVYWAWDzhNZbKux5G7Av/B6+NaMszKjbItYsZYmtO1zaIJhnrtxFQwrlie5teNxZnBTGYE0ZTfW5Q4XesPNgty5bAA+m17dFYZk3VKw/5Zuc1MnqBX0aNXmfNgDsTUoFBn3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772093996; c=relaxed/simple;
	bh=cdBxMl2hAVhNIc25QWUuK78SdurupBpgKnwJrav1VP0=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QrDMnGJI7nnxfCFsprV11hlyoc9oOGWjGntdPzJMzonYJPlL3+mGUgcVAYQR3UYCOzxpUon7mM0eSzVFq64C3JFAMkcKPQb59oKWSFKBe14kQhP4H+Tjq0RU0eBsH5KQAWMiyApRxZOYXQtDODE9iFGCGmZrXYHTprpS9zzLFpw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AnW6Xz2q; arc=pass smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5ff07cb35f2so278332137.3
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 00:19:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772093994; cv=none;
        d=google.com; s=arc-20240605;
        b=XiBV6aXWI/N/PdTnY3fBTrD5qhVbVB7GlFB00omVPtV6YWs4Qn6D4ph5KqjiYsRusg
         45HfC3q1zHXYAHKrtfqmkEudEYe48UhV0JyrTdjNZ/q83sfeWCatMjD7wbPHAhKjyA3B
         vP0iC5KelputW4oV5X9ej1c4C6LbNhcC6dMSr0K4kWYwBOkXjQm5ot2wKc76B3I50hBb
         uSsPKBDhquwALtWuvi+BF/Qqnv1Pvvr/UOOfJhQmq37TZzW+OVNQ+p+8F2FP5Y/xj6N2
         wgeq/MKypaWwN3LvF9xJ2gDLLYHM1glfPPKtrAbOvAGaqg623doLeJ0FklVQxl/qowxP
         8xTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=DtFIIVRotBA0wMwfgLQC8UuujLTYkQfIRNv/mVGEs6o=;
        fh=LaMx82Fm1vQjnNVpTkoGwcNcfZbJ8CEQwbS9dqOPfXs=;
        b=QKPIukDTP1f0mPRnD29tsrsSTSEI309Z+U4mtCiZS/YOWkvceYP/NZYnW33qEN0LmJ
         2bBzzXW2J57ey1Pn9YYA/2IjQpp3MJ0xWscF/c3206qghvoub/keyCaMZ2pD0rH6+oOe
         uNfzIKiJsHvK1r9Hsy32m1kk66NZSzsJlYYSL74NgXvCFA8UfeBLEbdeqbjCBBbVKCaF
         aWxJLawjKvZjtosXXA/qNLHcbyIYitdvFgujgN2LmLBZ3g19fGYKDKils3pyxVHfAYhs
         ybp81D+kEr1MSC+v9zb1wZwWrLBWZUwwzIc4jq2ZTgRKABwQwI4NPWg8x/s8bOzs5sfB
         UZIw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772093994; x=1772698794; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=DtFIIVRotBA0wMwfgLQC8UuujLTYkQfIRNv/mVGEs6o=;
        b=AnW6Xz2qfW7uu+KlEnVYCVcLirDL2vw7Emkh9UCz0j3iZQORpC8iQx1cuy0w2YwhPj
         HVobCEIP0JmwpDfopczz/FyHkqMfc0iV/XqeYa/UW7o/GRb3uNPtTHwUDnI1fNiCY0Zp
         eCH+X5dJYeDE+KUC1uaq+HYkGlpBllMDRw12qjbc+UlTDEnAxnPPOw3q61AQNRmEXRZP
         uIyn2UEhyVxINmAdZLiSVqF+u+Sgq3Ksiro9e0kd21i9zctYEYn41RFyjERr2VUPOgM2
         Q3Sw5GVVTN+lwLIccGzBrpZMNsZ438YxY5d4bOkPQSTsj2OWOgP4UBEr8WHU/iVd4N3+
         D5rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772093994; x=1772698794;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DtFIIVRotBA0wMwfgLQC8UuujLTYkQfIRNv/mVGEs6o=;
        b=tyYSz6VzvaYRjzVNL2Pn28lV0V+ZY8I6Whhf8rEYjHl91bcR8SV3PlBMnhOwwg7QcC
         tPTcky0DMUCTnTzSMZvWAayovCMh6nj0ZDThI7QWu8d4dLJzOvbfI2Y/0pnHlRPT8vRG
         /JTe6NlOlUyNvyjWNAyNMmW0qB4EEaTxDIdvyB1ddRiY7BUtrYMHqn1bSerIQ1Efnw8s
         +bWWrdcwipPrLSV/D8rTclu6M4lheeFxZyjBktrFYIIMfbUO8LDYmGmg8d6rZ87wmgI0
         Dkrr2eVdk+6qFHa8PasISldXa1j0gXy7+zN4BA9UvRPvCNq/HhITLbdzihjcVKit0WEY
         Fi3g==
X-Forwarded-Encrypted: i=1; AJvYcCXeBJhwPSMfjy9EGhS5r5Ud2sNXyCUigJk6ZBCF1glCfkpO/y/qQGJoe6m8xjlscBapiic=@vger.kernel.org
X-Gm-Message-State: AOJu0YzT6o892tdyZvzl6WCSRVzJHTbaDBFQwuDshSOxw2HFzRgk2JqP
	oVBbFQtmJiKsHyQ5kho4VTr+h4y0AFZ/scwabO96S8ip0qzp4lmv92X4LV/GjEKkCScCREzJaV2
	+V/6BeE4qWORno9bBnAGCVLVuWJmk7JTvTyxxMPh1
X-Gm-Gg: ATEYQzztx20QWIkgola5sOD8b6MsD1g/ZKx7SU7miWt63dmUg8sqJdzlQ/BwWLz4Mt5
	s62OLu92Xt2Q3PCEAkT9gbm0mClaA9eDsdYT03MlFuVUCLAO0mZ6zVE+CuqWMvwoW+F+I2gxNr5
	RQzDQGeU2KV/A0EyCgo//XmVZCwqrceP8UJ5HvU/+MWTAG//GP2LOwJqgwl+BA60opdBFKhEFbM
	T4PcMFuUwErgYkgPTgEIF/+PQU0wofHAuGgOD/7/hxP9YpV8R5sXVSrFCVHnlIeauRRzjSsCK+N
	cDZyUMfk66LYjZHSxl1zvwaQ6cbi/3hVDM/9gUtXnDP40cMmdB15ELs5qcsfcqUsK2X6KQ==
X-Received: by 2002:a05:6102:3586:b0:5f5:3dbd:700b with SMTP id
 ada2fe7eead31-5ff209d60admr700294137.7.1772093993676; Thu, 26 Feb 2026
 00:19:53 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 26 Feb 2026 00:19:52 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 26 Feb 2026 00:19:52 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aZ7-tTpobKiCFT5L@google.com>
References: <20260225075211.3353194-1-aik@amd.com> <aZ7-tTpobKiCFT5L@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 26 Feb 2026 00:19:52 -0800
X-Gm-Features: AaiRm521_jXlXSJX-4uKdrVOZ3AmqJAuqV9X1wXlubDjr97NXoS5-0me4TVgZLc
Message-ID: <CAEvNRgEiod74cRoVQVC5LUbWDZf6Wwz1ssjQN0fveN=RBAjsTw@mail.gmail.com>
Subject: Re: [RFC PATCH kernel] iommufd: Allow mapping from KVM's guest_memfd
To: Sean Christopherson <seanjc@google.com>, Alexey Kardashevskiy <aik@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Steve Sistare <steven.sistare@oracle.com>, 
	Nicolin Chen <nicolinc@nvidia.com>, iommu@lists.linux.dev, linux-coco@lists.linux.dev, 
	Dan Williams <dan.j.williams@intel.com>, Santosh Shukla <santosh.shukla@amd.com>, 
	"Pratik R . Sampat" <prsampat@amd.com>, Fuad Tabba <tabba@google.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, michael.roth@amd.com, vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71938-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lpc.events:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 626111A2725
X-Rspamd-Action: no action

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Feb 25, 2026, Alexey Kardashevskiy wrote:
>> For the new guest_memfd type, no additional reference is taken as
>> pinning is guaranteed by the KVM guest_memfd library.
>>
>> There is no KVM-GMEMFD->IOMMUFD direct notification mechanism as
>> the assumption is that:
>> 1) page stage change events will be handled by VMM which is going
>> to call IOMMUFD to remap pages;
>> 2) shrinking GMEMFD equals to VM memory unplug and VMM is going to
>> handle it.
>
> The VMM is outside of the kernel's effective TCB.  Assuming the VMM will always
> do the right thing is a non-starter.

I think looking up the guest_memfd file from the userspace address
(uptr) is a good start, and in order not to assume much of the userspace
VMM, we could register the mapping with guest_memfd, so that when
there's a conversion or truncation, guest_memfd will invalidate the
registered mapping in addition to the rest of the mappings being
invalidated.

At LPC (2025) [1][2], people pointed out that needing to force unmapping during
page state changes (aka conversions) are a TDX-only issue. It seems like
on SNP and ARM, the faults generated due to the host accessing guest
private memory can be caught and handled, so it's not super terrible if
there's no unmapping during conversions. Perhaps Alexey and Aneesh can
explain more :)

Will said pKVM actually would rather not unmap from the IOMMU on
conversions.

I didn't think of this before LPC but forcing unmapping during
truncation (aka shrinking guest_memfd) is probably necessary for overall
system stability and correctness, so notifying and having guest_memfd
track where its pages were mapped in the IOMMU is necessary. Whether or
not to unmap during conversions could be a arch-specific thing, but all
architectures would want the memory unmapped if the memory is removed
from guest_memfd ownership.

[1] Slides: https://lpc.events/event/19/contributions/2184/attachments/1752/3816/2025-12-12-lpc-coco-mc-optimizing-guest-memfd-conversions.pdf
[2] Notes: https://github.com/joergroedel/coco-microconference/blob/main/2025/optimizing_guest_memfd_shared_private_conversions.md

