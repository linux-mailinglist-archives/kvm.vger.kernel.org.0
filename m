Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91407759A4B
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 17:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbjGSP6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 11:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbjGSP5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 11:57:51 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9301D1701
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 08:57:47 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-cb4bb6c7efcso6072786276.2
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 08:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689782266; x=1692374266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/faZ439ffpfGfEHmalSwP2OnuvWR9ATtkot3hlajzjA=;
        b=QydOtl5a0QKciPatAvzcC5pE/xHdcSn4F+B2Dr0i6sAO8cVMeqjLLthl+4QB5qjs9N
         xsgye6l5Jk2TKn+pXgeK6kdVm6ihMR0iACTbTKPDhEFWxyOJCn/GSFge6kIwLS+Vn/LL
         mPFJdCYiApldUtDvCF6Hj5yxdz6h3xDJXrQUNRg7AyM0iHNW5oDsuDY1FWpWHb3PUVIR
         /k/TtAEVvVT96eSEQJUjeU9bAua0Hh854H7N/tmNwKkNvxDPe8MMoyBTSGqW16YfS3RQ
         pKi3mPG9IZ8btaafu8HixtkSrX9qRbn/zHAeCapgTWul+X4y3jSaBrBS+/4YJTUzFzpS
         8qOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689782266; x=1692374266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/faZ439ffpfGfEHmalSwP2OnuvWR9ATtkot3hlajzjA=;
        b=EX5AgzSu1s77guqqehsIulXkm+VoTia9R2JFztVTqX60dGWm728ahd4Cv4NMAQAvtJ
         7i2i6Iz2MfzFnLVVf3f8vhJrLOxpuRG7Wus5LrDNJwY4ANUO45ed7PJHc3WJmyIbySaX
         w37MCX7MF+set871VLmEiVB6Sm5A2b5qZ9xCtaFpaBtcN6zC05zPWf+RtH+47LjBveOh
         8/QRV24P5aK/+1VGpWkHSvz0ImxrAavkRXJeaSttpHdoS5QR/Pzje7w+p1IFbejwZTPj
         62+HqQ/DsnE5DTC9jSf9hDURx4pwhOGVeAC3RPqe7gPHjKNEtRHtJEqLAh0zSQg4dXrp
         oayQ==
X-Gm-Message-State: ABy/qLZ0RwWXHG1zijw42R+jMXeuMIAfZpoaa9QKSkSEmYr2Kn3pH+U4
        Kqk+NfB51rAHnM6gWhxPzwEanVA48TU=
X-Google-Smtp-Source: APBJJlE9XQIl0IoVuVPe1k8cQspT9EjElMzs8LlRIDRC+ZCEOEyjDm0RUb/SIHyIwR9N1WKEI6y4rVYD0Qg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d117:0:b0:cef:5453:b6da with SMTP id
 i23-20020a25d117000000b00cef5453b6damr24214ybg.7.1689782266583; Wed, 19 Jul
 2023 08:57:46 -0700 (PDT)
Date:   Wed, 19 Jul 2023 08:57:44 -0700
In-Reply-To: <bae58fd3-34b0-641a-a18b-010d48c792f0@oracle.com>
Mime-Version: 1.0
References: <3d05fcf1-dad3-826e-03e9-599ced7524b4@oracle.com>
 <20230518035806.938517-1-dengqiao.joey@bytedance.com> <2f6210acca81090146bc1decf61996aae2a0bfcf.camel@redhat.com>
 <36295675-2139-266d-4b07-9e029ac88fef@oracle.com> <ZJ4HJhQytonABUMl@google.com>
 <bae58fd3-34b0-641a-a18b-010d48c792f0@oracle.com>
Message-ID: <ZLgH+LGl+eC4hFdx@google.com>
Subject: Re: [PATCH] KVM: SVM: Update destination when updating pi irte
From:   Sean Christopherson <seanjc@google.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        "dengqiao.joey" <dengqiao.joey@bytedance.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 14, 2023, Joao Martins wrote:
> +Suravee, +Alejandro
> 
> On 29/06/2023 23:35, Sean Christopherson wrote:
> > On Thu, May 18, 2023, Joao Martins wrote:
> >> On 18/05/2023 09:19, Maxim Levitsky wrote:
> >>> I think that we do need to a flag indicating if the vCPU is currently
> >>> running and if yes, then use svm->vcpu.cpu (or put -1 to it when it not
> >>> running or something) (currently the vcpu->cpu remains set when vCPU is
> >>> put)
> >>>
> >>> In other words if a vCPU is running, then avic_pi_update_irte should put
> >>> correct pCPU number, and if it raced with vCPU put/load, then later should
> >>> win and put the correct value.  This can be done either with a lock or
> >>> barriers.
> >>>
> >> If this could be done, it could remove cost from other places and avoid this
> >> little dance of the galog (and avoid its usage as it's not the greatest design
> >> aspect of the IOMMU). We anyways already need to do IRT flushes in all these
> >> things with regards to updating any piece of the IRTE, but we need some care
> >> there two to avoid invalidating too much (which is just as expensive and per-VCPU).
> > 
> > ...
> > 
> >> But still quite expensive (as many IPIs as vCPUs updated), but it works as
> >> intended and guest will immediately see the right vcpu affinity. But I honestly
> >> prefer going towards your suggestion (via vcpu.pcpu) if we can have some
> >> insurance that vcpu.cpu is safe to use in pi_update_irte if protected against
> >> preemption/blocking of the VCPU.
> > 
> > I think we have all the necessary info, and even a handy dandy spinlock to ensure
> > ordering.  Disclaimers: compile tested only, I know almost nothing about the IOMMU
> > side of things, and I don't know if I understood the needs for the !IsRunning cases.
> > 
> I was avoiding grabbing that lock, but now that I think about it it shouldn't do
> much harm.
> 
> My only concern has mostly been whether we mark the IRQ isRunning=1 on a vcpu
> that is about to block as then the doorbell rang by the IOMMU won't do anything
> to the guest. But IIUC the physical ID cache read-once should cover that

Acquiring ir_list_lock in avic_vcpu_{load,put}() when modifying
AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK is the key to avoiding ordering issues.
E.g. without the spinlock, READ_ONCE() wouldn't prevent svm_ir_list_add() from
racing with avic_vcpu_{load,put}() and ultimately shoving stale data into the IRTE.

It *should* actually be safe to drop the READ_ONCE() since acquiring/releasing
the spinlock will prevent multiple loads from observing different values.  I kept
them mostly to keep the diff small, and to be conservative.

The WRITE_ONCE() needs to stay to ensure that hardware doesn't see inconsitent
information due to store tearing.

If this patch works, I think it makes sense to follow-up with a cleanup patch to
drop the READ_ONCE() and add comments explaining why KVM uses WRITE_ONCE() but
not READ_ONCE().
