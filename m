Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F6B7D83B0
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 15:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345074AbjJZNfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 09:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbjJZNfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 09:35:53 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B02518F
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 06:35:51 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5b83bc7c7b4so699562a12.2
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 06:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698327351; x=1698932151; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rRdhZYne4XfPyaYOHMxtfEuMULoyloU7R6zGn7uiTxk=;
        b=rf3UWijutkpc0NxO/b6ZwjGJsGRgOTHWuNqsjtzVxIIhZClfpachlmbW71OlVLrDrn
         UHWmuVV1jI4K1UrAjLoQ4tub5Y7FmgLmmsg3sMKeNHj8RIg1/NS0JhCGEMTbIr0lg7DH
         Ii86mb3c9FV0f5PtH3D3FcHpCxMYk8vVow9OIPZh8nxx1+adfNYYobAhpt6sZx6bglmQ
         bYSFiPPRHbMxzrLf1CDx9+J0ZOV01tskOl00cIreo52EY/0LUFRSiBK4J8tIP7xuBzuh
         MUnBbrCi33mMfdG6cp2lWpVwSnORHNymGPQTwiLgK0qVidbhwweiIQDP3/QojgrPcPLV
         TwaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698327351; x=1698932151;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rRdhZYne4XfPyaYOHMxtfEuMULoyloU7R6zGn7uiTxk=;
        b=CKkV3wXGeeYu8Kyq6+vky60hVGcM/2o+MQdMNtffrizQuD9NZD+shi5qDxqvrH6s3V
         XyYG3IGCSTovD9GGMOIwQ588f5V4KjqaXK+xS9zD//aNzkPb9BqNaJiEN6aDUAjvrtNF
         Pree0N3UKj5/pF2G2r1W4pl4B1lQbKmYRx9R0Akbz1ZpKJCs/dF1lqBB2q1XB2A9b7Ea
         7SXe61R05c7dZFi0ZlaaM2OCptrV9cjJcSegRYkYhq5pmMs02tyTfZSU3DCFEMT9jQvG
         +zhXxm/W3MMJNrJFi+xs+INczWlPmq48RyEwsU6+YCZgFd/gydVK99I+j4fgTMI/acp1
         4mdQ==
X-Gm-Message-State: AOJu0Yxh6YabhTUlC2oBjvTiHjRv2vSJUaLYnr6LY7dKNS/4gVvzdOWm
        f0bORg2m7N4Nmy3bnKR4jp+9MGUOc/Q=
X-Google-Smtp-Source: AGHT+IE4X4x5rI3HOw1Mv3YaqgyiPZGmtRV8staZucsaAH2CLjAPnzob8J43/nClI+T9smvpVjC91mu/TIc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab15:b0:1ca:8e79:53b7 with SMTP id
 ik21-20020a170902ab1500b001ca8e7953b7mr326850plb.9.1698327350721; Thu, 26 Oct
 2023 06:35:50 -0700 (PDT)
Date:   Thu, 26 Oct 2023 06:35:49 -0700
In-Reply-To: <2969750E-51D3-4284-B093-23FD27736582@clockwork.io>
Mime-Version: 1.0
References: <594A322A-8100-429A-A3E8-64362E3ED5A2@clockwork.io>
 <ZTf_2MN3uyHFtWqa@google.com> <2969750E-51D3-4284-B093-23FD27736582@clockwork.io>
Message-ID: <ZTprNWvOjf0BdSB8@google.com>
Subject: Re: Questions about TSC virtualization in KVM
From:   Sean Christopherson <seanjc@google.com>
To:     Yifei Ma <yifei@clockwork.io>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please don't top post.  https://people.kernel.org/tglx/notes-about-netiquet=
te

On Wed, Oct 25, 2023, Yifei Ma wrote:
> > On Oct 24, 2023, at 10:33 AM, Sean Christopherson <seanjc@google.com> w=
rote:
> >=20
> > On Tue, Oct 24, 2023, Yifei Ma wrote:
> >> Hi KVM community,
> >>=20
> >>   I am trying to figure out how TSC is virtualized in KVM-VMX world.
> >>   According to the kernel documentation, reading TSC register through =
MSR
> >>   can be trapped into KVM and VMX. I am trying to figure out the KVM c=
ode
> >>   handing this trap.
> >=20
> > Key word "can".  KVM chooses not to intercept RDMSR to MSR_IA32_TSC bec=
ause
> > hardware handles the necessary offset and scaling.  KVM does still emul=
ate reads
> > in kvm_get_msr_common(), e.g. if KVM is forced to emulate a RDMSR, but =
that's a
> > very, very uncommon path.
> >=20
> > Ditto for the RDTSC instruction, which isn't subject to MSR intercpetio=
n bitmaps
> > and has a dedicated control.  KVM will emulate RDTSC if KVM is already =
emulating,
> > but otherwise the guest can execute RDTSC without triggering a VM-Exit.
> >=20
> > Modern CPUs provide both a offset and a scaling factor for VMX guests, =
i.e. the
> > CPU itself virtualizes guest TSC.  See the RDMSR and RDTSC bullet point=
s in the
> > "CHANGES TO INSTRUCTION BEHAVIOR IN VMX NON-ROOT OPERATION" section of =
the SDM
> > for details.
>=20
> I went through the SDM virtual machine extensions chapter, and some KVM
> patches and it helped me a lot. My understanding is:
>=20
> If the RDTSC existing flied in the VMCS is not set, then the rdtsc from
> non-root model won=E2=80=99t cause VM-exit. In this case, the TSC returne=
d to
> non-root is the value of the physical TSC * scaling + offset, if scaling =
and
> offset are set by KVM.

Yes.  Note, if hardware supports TSC offsetting and/or TSC scaling, they ar=
e
enabled by KVM.  KVM simply uses an initial offset of '0' and a multiplier =
that
makes the guest TSC "run" at the same frequency as the host.

> The TSC offset and scaling of a vCPU can be set from root-mode through KV=
M
> APIs using command KVM_VCPU_TSC_CTRL & KVM_SET_TSC_KHZ , and they are wri=
tten
> to the vCPU=E2=80=99s VMCS fields. Next time, non-root mode calls rdtsc, =
the VMX
> hardware will add the offset & scaling to the physical TSC.

Yes, with caveats.  The guest can write MSR_IA32_TSC and/or MSR_IA32_TSC_AD=
JUST,
which KVM emulates by modifying TSC_OFFSET.  If the CPU doesn't have a cons=
tant
TSC, KVM will adjust TSC_OFFSET before the next VM-Enter to try and keep gu=
est
TSC consistent and monotonic.  If the CPU doesn't support TSC scaling, KVM =
will
manually scale the guest TSC prior to every VM-Enter by again adjusting TSC=
_OFFSET
to "catch up" to what the guest TSC _should_ be given the guest TSC frequen=
cy.
