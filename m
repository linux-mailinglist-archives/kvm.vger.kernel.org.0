Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 049C3796E8A
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 03:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235747AbjIGB1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 21:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjIGB1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 21:27:49 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB3A172C;
        Wed,  6 Sep 2023 18:27:45 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-31f71b25a99so204f8f.2;
        Wed, 06 Sep 2023 18:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694050064; x=1694654864; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YNvMZOUMF9nTFwos5xvMEitjVFFAuaJPfYqM/Mu6XNs=;
        b=kyLSbsAP632wDrvkeRumRf2en/abGr724Wrri27qJgAQx4EHAPgtuwGw4uShSQ57TC
         KzOIQeQtH9Wdf6/wqg/UVWx/5rQHcdUPO2HYpNvmSyxkj4nQtEGDkUXLk31rK6SbMk8N
         aXOPJpZrXXjvMK075N0nbpmh5Spw4rcpfrtQ6W8ZLtlgWtLbCC3YKjuL/L9BRuFygU0v
         GdogkrmORbcg/LNiKeV6xeN/abB7Emn5SNjDnww3K9DKnZWNElDvkTDyes+bExfv5z8E
         1TMC1vyprzYvtvaHKEtYE4W7sfkb7kEXT2FQm8FhKD/rkEPe8AUVTUoW0ImtANIYrxUc
         687w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694050064; x=1694654864;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YNvMZOUMF9nTFwos5xvMEitjVFFAuaJPfYqM/Mu6XNs=;
        b=juKxJvsFLVBUnUnT834DeOOxGcF2dq1mYRlWXyVPA9zWtnMzxrV8g54yDklvPxZhi0
         9rdK9A/mVcjWuCZfNQfG5yxij/+C1XHbYDWO15RGiIIwmdVV7a9Gi3sWJkMfmeHWrf5+
         Fedn0RJF0IdoxQeqnfm1b8khlY74SDwH7pfuMDG4mhSgZhY2aVB7z3ZsgFntiiNaBQk+
         Iih0gbC5M2VVrpHJkokX4Fog5gLDMz14iATC4jk0GR32FiQZJlZ70YPWMGYWB4xE0fsp
         H4qYj5QPZ5rQetO1Wh7E0g5jvXYQEsVfowSQ70kZxZrJSyJdlQJp0ywdQRrQJGsRAUOz
         8DUw==
X-Gm-Message-State: AOJu0YxgE8IxOcycjzzyKNfZ25zgx1+fysOc98A14422jG5EwkHgGjKg
        Zq/SpFToc1rZUZFj7373KsTn4jcZvXOj7IN3yCE=
X-Google-Smtp-Source: AGHT+IE02oUSL28wAn0rBJmPST7T2NC/5UHQERs8/OSSjYlmdyHXVxLgDbIyjxSfxWXTZAzg3zzVRhVpMnq2QfsYL+I=
X-Received: by 2002:a5d:6504:0:b0:317:6cd2:b90c with SMTP id
 x4-20020a5d6504000000b003176cd2b90cmr3678988wru.13.1694050063527; Wed, 06 Sep
 2023 18:27:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAPm50aLd5ZbAqd8O03fEm6UhHB_svfFLA19zBfgpDEQsQUhoGw@mail.gmail.com>
 <10bdaf6d-1c5c-6502-c340-db3f84bf74a1@intel.com> <ZPjcO/N54pvhLjSz@google.com>
In-Reply-To: <ZPjcO/N54pvhLjSz@google.com>
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Thu, 7 Sep 2023 09:27:32 +0800
Message-ID: <CAPm50aJjZhTWZVMj6FVtOP70ZuSVPrHPqFvVors1NmJ+8SYVQw@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Reduce calls to vcpu_load
To:     Sean Christopherson <seanjc@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 7, 2023 at 4:08=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Sep 06, 2023, Xiaoyao Li wrote:
> > On 9/6/2023 2:24 PM, Hao Peng wrote:
> > > From: Peng Hao <flyingpeng@tencent.com>
> > >
> > > The call of vcpu_load/put takes about 1-2us. Each
> > > kvm_arch_vcpu_create will call vcpu_load/put
> > > to initialize some fields of vmcs, which can be
> > > delayed until the call of vcpu_ioctl to process
> > > this part of the vmcs field, which can reduce calls
> > > to vcpu_load.
> >
> > what if no vcpu ioctl is called after vcpu creation?
> >
> > And will the first (it was second before this patch) vcpu_load() become=
s
> > longer? have you measured it?
>
> I don't think the first vcpu_load() becomes longer, this avoids an entire
> load()+put() pair by doing the initialization in the first ioctl().
>
> That said, the patch is obviously buggy, it hooks kvm_arch_vcpu_ioctl() i=
nstead
> of kvm_vcpu_ioctl(), e.g. doing KVM_RUN, KVM_SET_SREGS, etc. will cause e=
xplosions.
>
> It will also break the TSC synchronization logic in kvm_arch_vcpu_postcre=
ate(),
> which can "race" with ioctls() as the vCPU file descriptor is accessible =
by
> userspace the instant it's installed into the fd tables, i.e. userspace d=
oesn't
> have to wait for KVM_CREATE_VCPU to complete.
>
It works when there are many cores. The hook point problem mentioned
above can still be adjusted,
but the tsc synchronization problem is difficult to deal with.
thanks.
> And I gotta imagine there are other interactions I haven't thought of off=
 the
> top of my head, e.g. the vCPU is also reachable via kvm_for_each_vcpu(). =
 All it
> takes is one path that touches a lazily initialized field for this to fal=
l apart.
>
> > I don't think it worth the optimization unless a strong reason.
>
> Yeah, this is a lot of subtle complexity to shave 1-2us.
