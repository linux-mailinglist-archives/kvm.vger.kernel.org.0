Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025B76DF8BB
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 16:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbjDLOjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 10:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjDLOjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 10:39:02 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1187AA6
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 07:38:34 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id q10-20020a170902daca00b001a646870238so4383391plx.15
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 07:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681310313; x=1683902313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YjNNjhvcQw4WbAW0UTAD5k66A9ANuIr45cT7T0+9r+8=;
        b=Pp8Q23Yp/mDqxykt5WHPOjrQMSgUZWsYs9QJEP4BegJlgOmIoyNAW6S+MCKw2LM67P
         haxE5wzWyvTlLRccH6z7dlcgYLicFkD8IXfuGLs7lMZcjKuzz+2UJiMQtTo8iWo5BS7p
         82dftvI2eXC25ZrH/2lsJzZ8Kt1O+XbfC9IQ46tT+3W30sgpyfVpeCVP29KZ9CBxkkZ1
         09x7sfu9c7XAGnvIb5UN965BdiXqn3A8wyZmyi2RwKFyTEJkqRU5Tyf7XhO7C6e7KE9B
         hS7ak4J/2EQYWc/WQtyA7LGVkmllGI8lCNUGqLQqilvv+j4wLdar+XG6qpGPbN/qdq6V
         6PNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681310313; x=1683902313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YjNNjhvcQw4WbAW0UTAD5k66A9ANuIr45cT7T0+9r+8=;
        b=kZvoTXFOsf/KArHShzzis+5VikYOdm/ZkXDFRZb39/CU2VdTK684qcBFlpBZMMw/kT
         6b8W3P1drlZ/uy9ocfepgC0hHnNt9NSxRzchJLImvovpbyC4tb49f+TD03lhax7FN0oh
         Yf+9KL7G4o1SppSeA4nOgBmRLmLjqj8SdvXpO/m8heZYoW+3pLbnrhDctPkA7jj5Btvl
         yiCBqQ2O94aM5MCKY3tvdEtNb57XdiqQBevfPyBUVpJmIyqK7P2bqNrSazLCJjLxsdsd
         SIlGTzFSKg6uTjJv4iIxsUMVlGYZd7THdKhLWtcbJh4Am51sq5ZxdBOXDYnsXPLCTIBZ
         MDoA==
X-Gm-Message-State: AAQBX9dHHXdMir7Eb5UeAXnzdUhMociU/bSAPSBAzSs01HV/M0sdwkR0
        bVWflklsf1RLtjTe0MB9mhVdHwmcEpA=
X-Google-Smtp-Source: AKy350btSAgJtnnEe7VmMJ1nOKb8OT6YTx/yfjX3A3kRuOYjq7vzXkehc72EawYLRjMrDlnQlV6a0/hl1+0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:b03:0:b0:50b:dfd4:b56f with SMTP id
 3-20020a630b03000000b0050bdfd4b56fmr647098pgl.5.1681310313640; Wed, 12 Apr
 2023 07:38:33 -0700 (PDT)
Date:   Wed, 12 Apr 2023 07:38:32 -0700
In-Reply-To: <5d537415da25ac654b332db64b4018dca0bae6a7.camel@intel.com>
Mime-Version: 1.0
References: <20230405234556.696927-1-seanjc@google.com> <20230405234556.696927-3-seanjc@google.com>
 <03504796e42badbb39d34b9e99c62ac4c2bb9b6f.camel@intel.com>
 <ZC8IsP5ehaJXQOnu@google.com> <5d537415da25ac654b332db64b4018dca0bae6a7.camel@intel.com>
Message-ID: <ZDbCaEUboTrvtwda@google.com>
Subject: Re: [PATCH 2/2] KVM: VMX: Inject #GP, not #UD, if SGX2 ENCLS leafs
 are unsupported
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 12, 2023, Kai Huang wrote:
> On Thu, 2023-04-06 at 11:00 -0700, Sean Christopherson wrote:
> > On Thu, Apr 06, 2023, Huang, Kai wrote:
> > > On Wed, 2023-04-05 at 16:45 -0700, Sean Christopherson wrote:
> > > > Per Intel's SDM, unsupported ENCLS leafs result in a #GP, not a #UD.
> > > > SGX1 is a special snowflake as the SGX1 flag is used by the CPU as a
> > > > "soft" disable, e.g. if software disables machine check reporting, i.e.
> > > > having SGX but not SGX1 is effectively "SGX completely unsupported" and
> > > > and thus #UDs.
> > > 
> > > If I recall correctly, this is an erratum which can clear SGX1 in CPUID while
> > > the SGX flag is still in CPUID?
> > 
> > Nope, not an erratum, architectural behavior.
> 
> I found the relevant section in SDM:
> 
> All supported IA32_MCi_CTL bits for all the machine check banks must be set
> for Intel SGX to be available (CPUID.SGX_Leaf.0:EAX[SGX1] == 1). Any act of
> clearing bits from '1 to '0 in any of the IA32_MCi_CTL register may disable
> Intel SGX (set CPUID.SGX_Leaf.0:EAX[SGX1] to 0) until the next reset.
> 
> Looking at the code, it seems currently KVM won't clear SGX1 bit in CPUID when
> guest disables IA32_MCi_CTL (writing 0).  Should we do that?

No, the behavior isn't strictly required: clearing bits *may* disable Intel SGX.
And there is zero benefit to the guest, the behavior exists in bare metal purely
to allow the CPU to provide security guarantees.  On the flip side, emulating the
disabling of SGX without causing problems, e.g. when userspace sets MSRs, would be
quite tricky.
