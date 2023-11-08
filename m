Return-Path: <kvm+bounces-1213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D58F77E5ACC
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 17:08:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8626B20FE9
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 16:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4974D30CF3;
	Wed,  8 Nov 2023 16:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KfWUcF8u"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB8F3034F
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 16:07:52 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17AC1BDD
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 08:07:51 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5afa77f9a33so94333487b3.0
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 08:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699459671; x=1700064471; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iKCBOihcFpwPiFXJ7beQ54mZLc6qbUkb2m18TA0L4ag=;
        b=KfWUcF8utVuoJ8rWDjFJ8/mKqxaV8Dek+UFT8n0jOJg07dChxJ5JPPapZWgEFn4D74
         VeXg4RC3Z2TXxSXNH4sM1uljFpF3SmDYYveyKrUS35I1Ud8TF9cIo/XKD2AKSOInrWke
         VY7InMsJJr9t8p9+IElrVTAI02GETGZ+gc24nZJRItHuVvqyh5uXralIrmnT6M/McER0
         C71DMimLplcZQg8YbYviLN0nlU1ioeykfmyZi65F+I0uy9oxf1NvHXs7CGpgoH+DQBAX
         p7yF1JMBIRVae7Aa4nNDD7L7Iib/pOSmseA3s3IItsyAo5qYzJkQe9wOZ5unjU+PYRGA
         XKkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699459671; x=1700064471;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iKCBOihcFpwPiFXJ7beQ54mZLc6qbUkb2m18TA0L4ag=;
        b=kbED4vVes+A2xJLPJzL3JGNisvsh1FFsh8ffgZC23FYNU02oe82whlphDyycNQAaaP
         TA34UU1skNtlkli8MG0cMhyB+tcvYOl6CVmXmkMLHfoKjV25mnH2gzyiFV015RIMrDk4
         7goo1wszRfoF4IO5d5mjrUKlP1Axx1B1rvRYTxDqB3XR9vwFzBld5zIInYHAesKA0PaC
         sEPCiDYZl/fvyr8ayHLKFtgjjtKXJAlhIyXSXanHorNN2W0ziKVglkUFV7QKjYz0Mi0s
         ECmJ5pGfDtH1xsuv0W9LrmqzdSz8UHFuyU0q4llgD+JmAZf900SRi7ew4uELJ4Y1ecuY
         FmCw==
X-Gm-Message-State: AOJu0Yz20cRJwRJ/rkSw3RHVdDqlg2DK/8Kq5YN5uO6dUjlgz1yMnKBa
	8V5k1zWM+F2yUfWYsqvyI/PNDmMHWPg=
X-Google-Smtp-Source: AGHT+IG6W6qHJUtwWlgT3nZPL1H/oHRqw5KPj1osmkHyoB8gU4H4AXf99W7WzIxzrRs4vjlX4336dNFt/H8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:cad5:0:b0:59b:c6bb:bab9 with SMTP id
 m204-20020a0dcad5000000b0059bc6bbbab9mr42567ywd.3.1699459671031; Wed, 08 Nov
 2023 08:07:51 -0800 (PST)
Date: Wed, 8 Nov 2023 08:07:49 -0800
In-Reply-To: <0ee32216-e285-406f-b20d-dd193b791d2b@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108010953.560824-1-seanjc@google.com> <20231108010953.560824-3-seanjc@google.com>
 <0ee32216-e285-406f-b20d-dd193b791d2b@intel.com>
Message-ID: <ZUuyVfdKZG44T1ba@google.com>
Subject: Re: [PATCH v2 2/2] KVM: selftests: Add logic to detect if ioctl()
 failed because VM was killed
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michal Luczaj <mhal@rbox.co>, Oliver Upton <oliver.upton@linux.dev>, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 08, 2023, Xiaoyao Li wrote:
> On 11/8/2023 9:09 AM, Sean Christopherson wrote:
> > Add yet another macro to the VM/vCPU ioctl() framework to detect when an
> > ioctl() failed because KVM killed/bugged the VM, i.e. when there was
> > nothing wrong with the ioctl() itself.  If KVM kills a VM, e.g. by way of
> > a failed KVM_BUG_ON(), all subsequent VM and vCPU ioctl()s will fail with
> > -EIO, which can be quite misleading and ultimately waste user/developer
> > time.
> > 
> > Use KVM_CHECK_EXTENSION on KVM_CAP_USER_MEMORY to detect if the VM is
> > dead and/or bug, as KVM doesn't provide a dedicated ioctl().  Using a
> > heuristic is obviously less than ideal, but practically speaking the logic
> > is bulletproof barring a KVM change, and any such change would arguably
> > break userspace, e.g. if KVM returns something other than -EIO.
> 
> We hit similar issue when testing TDX VMs. Most failure of SEMCALL is
> handled with a KVM_BUG_ON(), which leads to vm dead. Then the following
> IOCTL from userspace (QEMU) and gets -EIO.
> 
> Can we return a new KVM_EXIT_VM_DEAD on KVM_REQ_VM_DEAD?

Why?  Even if KVM_EXIT_VM_DEAD somehow provided enough information to be useful
from an automation perspective, the VM is obviously dead.  I don't see how the
VMM can do anything but log the error and tear down the VM.  KVM_BUG_ON() comes
with a WARN, which will be far more helpful for a human debugger, e.g. because
all vCPUs would exit with KVM_EXIT_VM_DEAD, it wouldn't even identify which vCPU
initially triggered the issue.

Using an exit reason is a also bit tricky because it requires a vCPU, whereas a
dead VM blocks anything and everything.

> and replace -EIO with 0? yes, it's a ABI change.

Definitely a "no" on this one.  As has been established by the guest_memfd series,
it's ok to return -1/errno with a valid exit_reason.

> But I'm wondering if any userspace relies on -EIO behavior for VM DEAD case.

I doubt userspace relies on -EIO, but userpsace definitely relies on -1/errno being
returned when a fatal error.

