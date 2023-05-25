Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B5D710EED
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 17:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241295AbjEYPBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 11:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241064AbjEYPBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 11:01:01 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C401B4
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 08:00:59 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-2533d8f48b5so974751a91.0
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 08:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685026859; x=1687618859;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2rgc5wNBzRwTZsiTn0J0WHKeSrzO5GwJcVsGE/2GYBg=;
        b=AyY7s5NO6ZYMxx+nAp8os1iSmL+QUh0+NNNS14PW8xDvfy14jeBv20Cn+/xySm0GS+
         7JLXIMsPgorL07xkxMYRmcSAp/H90WQnq5m0O4W/mOE9Um4tYYNOk5Bgg/ZJeGjjUE0E
         tAU2NRyk6rNg0Sd0lXD/e5OJdMa3n3EpMDS/xks/N183FlGxRzVW1SsHC/8+k8/JX/Y1
         af3OGWtTx7YIOKwNAEi/VswrUDCEvN2lluN+Bpsy/lCDUbo55Rx4891gHCjPsU2SUtSS
         8uNw0kEDQBwtNMS9jtoCWLNl9mVDch8QqvuUftQh8EZpQMLUC3PrWXy31Dy4aOSm5rUq
         vuZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685026859; x=1687618859;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2rgc5wNBzRwTZsiTn0J0WHKeSrzO5GwJcVsGE/2GYBg=;
        b=Ym8qhR7WWo/ZBMIb2cOaw8BCbu2gJrK3QoS6Qb3OeQX5Sab19SJwIYvU6kL5RhQh6/
         BLA6Mn7ELBNT1++YGP6g7aLwT/5iUc8HQpnmPYDULpkDkCeMSMmd8xV/BIzU0UmQ+pZ5
         GIbHXDlj0D0o8OHsOuoagh21zFR9COtFkf5XXLvVkwftKKmHeDBQKJTTyJNdghRhzL4T
         culo12ekkuCARLm87Yj6kykc+XshD+AoAdlnGrZqVCewpTtomSIwz7kFyc9JQkbcvxib
         eljMRaVsp5Xk574j4kL3HX75niVDfycqphFLw3zVuPd/YrK+WrYl918mrxhKNIPlLCA5
         QrbA==
X-Gm-Message-State: AC+VfDyrIBlB7PyfraXyY1On9LSI8TduM6F08KrGITe94GlPydqSHPcf
        aRG160tQTIck8VN1ITGpMsbbXCinAoU=
X-Google-Smtp-Source: ACHHUZ7RT45qInXgmU/+XvDTNZGc1dzAPlp7OuPf32BVGX9UmDt71fsVlzRmkTnl1/mPDEQCJf1xczlIfmM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9304:b0:250:a6c1:b843 with SMTP id
 p4-20020a17090a930400b00250a6c1b843mr436712pjo.9.1685026859534; Thu, 25 May
 2023 08:00:59 -0700 (PDT)
Date:   Thu, 25 May 2023 08:00:58 -0700
In-Reply-To: <393b16f7-8359-5d77-7d5d-8942de987331@gmail.com>
Mime-Version: 1.0
References: <20230509134825.1523-1-yan.y.zhao@intel.com> <20230509135300.1855-1-yan.y.zhao@intel.com>
 <3f09e751-33fd-7d60-78cd-6857d113e8bd@gmail.com> <ZGxbat2mM6AfOOVv@yzhao56-desk.sh.intel.com>
 <393b16f7-8359-5d77-7d5d-8942de987331@gmail.com>
Message-ID: <ZG94Kmb8jMZKhtJW@google.com>
Subject: Re: [PATCH v2 5/6] KVM: x86: Keep a per-VM MTRR state
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hoo.linux@gmail.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 25, 2023, Robert Hoo wrote:
> On 5/23/2023 2:21 PM, Yan Zhao wrote:
> IIUC, your saving comes from skips the intermediate state during boot, when
> APs goes through setting MTRR, which would cause SPTE zap before your this
> patch set.
> 
> MHO was, now that your ignores other vCPU's MTRR settings (unless it is
> different from BP's MTRR?), why not let each vCPU's MTRR set/update directly
> set to the per-VM MTRR states (if differs from current value). It's guest
> OS/BIOS's responsibility to keep the consistency anyway. And even if the
> malfunction caused by the inconsistency might differ from that of native,
> SDM doesn't clearly state how the malfunction should be, does it?
> that's to say, anyone knows, when inconsistency happens, does it cause that
> logical processor malfunction or in fact it impacts the global MTRR
> settings? If the latter, I think leaving only the per-VM MTRR state aligns
> with native.

The MTRRs are not system wide or per-package though, they are per logical CPU.
Yes, they "need" to be consistent with respect to one another, but only when the
CPU is actually accessing memory.  This is a big reason why trying to track MTRRs
as a per-VM asset in KVM is so difficult/messy.  Software doesn't rendezvous all
CPUs and then do the write on just one CPU, each CPU does its own writes more or
less independently.

> BTW, with regard to KVM_X86_QUIRK_CD_NW_CLEARED, I see svm honors it while
> vmx doesn't before it clear CR0.CD/NW.
> 
> svm_set_cr0():
> 
> 	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
> 		hcr0 &= ~(X86_CR0_CD | X86_CR0_NW);
> 
> 
> vmx_set_cr0():
> 
> 	hw_cr0 = (cr0 & ~KVM_VM_CR0_ALWAYS_OFF);
> 
> Perhaps vmx side can be fixed passingly?

Sadly, no.  SVM and VMX manage guest memtype completely differently.  VMX doesn't
allow CR0.CD=1 when VMX is enabled, and so KVM needs to emulate CR0.CD via the EPT
memtype.
