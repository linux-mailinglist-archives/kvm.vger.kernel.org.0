Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464C76B57A5
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 02:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjCKB73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 20:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCKB72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 20:59:28 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B8A13D8BE
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 17:59:27 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id bo10so4822476qvb.12
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 17:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678499966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SOKBKD6liD7w/UEHazkRj8cAaUxlkAqZoQBXeW/oTQY=;
        b=ccDmKvh21GZH/UXLtd7nNynlNcjrwJBcq934D7eRsxVHp215CHm6JtU9VgV3mbYLRy
         UqqmLMvYw1mYx/kGZmmnO1PIt6slY1b3rHFABY7rMrTraV3U5wfCfRSaSiKIEZgfARe7
         E4E3PYZDUjbIBvZ490VoxuvopzVpTOPAHru4nH8PTWakFa0ibXkwnCThBnyQiZ1n+aBa
         tSWhma5Eucjj6Bph+337DX/Amu4Jl/St4CeqqARhIBvrmGUs8EiEaMryGA8X/GRskFi+
         pAOE5zskbuH5cjfEoNYbicsBSfqr5B+zgoXLoRcMuFu0GN97abW4MUeGZzKw7apnEvGT
         Zs/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678499966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SOKBKD6liD7w/UEHazkRj8cAaUxlkAqZoQBXeW/oTQY=;
        b=5Ddqud3MpvPmWKG9NUZ7YwvcZ7HGY9y/e2cuEM1AKJb1tQl+TEEofI32nnRVrmnWNK
         LhRN6nOhhVMqIlxxBcYgZ3bwuveNHNABdWdO2BvAShfh50lBqp5WrZSOu2vShawAOOMO
         SO2ny/QrxtdnAIMMjlEC2+jvsPPXv9oq68f3n39KZQdSrSNgffYH9zeyOd/Oy0882JF2
         aSz2e4Syd6z/Na4cooSuMYYpY164MugRTnvFeu/Dxd85jhtckjyVRIjNZ67r86g/k/Pq
         SIkJKOwXUd8ICalelsKblUfq9imTOcdV9Gfd42g/XmXWgAy1lxITC6WexAYcwHzPSwIt
         dPOg==
X-Gm-Message-State: AO0yUKUOPSkNHd9VQrcElscTbjcd70Ta8GCwH8nJJYDGq3IKY4vNn9cJ
        ic2N51BJ+5wcr0jxGqctqczlU+UIuRqeOtYPJimB/yauH5g=
X-Google-Smtp-Source: AK7set8DhVKhn6iCOLxSMFukvBklT8a+1kM5B3pc4cVaVJy14kcPhCOp5ecMFDCyKWWeUNqvtQODKre4mlTcXUJonmA=
X-Received: by 2002:ad4:59c7:0:b0:56f:3e5:850e with SMTP id
 el7-20020ad459c7000000b0056f03e5850emr239890qvb.3.1678499966552; Fri, 10 Mar
 2023 17:59:26 -0800 (PST)
MIME-Version: 1.0
References: <20230310125718.1442088-1-robert.hu@intel.com> <20230310125718.1442088-2-robert.hu@intel.com>
 <ZAtT5pFPqjM1Ocq0@google.com>
In-Reply-To: <ZAtT5pFPqjM1Ocq0@google.com>
From:   Robert Hoo <robert.hoo.linux@gmail.com>
Date:   Sat, 11 Mar 2023 09:59:15 +0800
Message-ID: <CA+wubQBWgz4YAi=T3MV82HrC3=gXSC_yD50ip0=N_x3MnTE1UA@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: VMX: Rename vmx_umip_emulated() to cpu_has_vmx_desc()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Robert Hoo <robert.hu@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=8810=
=E6=97=A5=E5=91=A8=E4=BA=94 23:59=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Mar 10, 2023, Robert Hoo wrote:
> > Just rename, no functional changes intended.
> >
> > vmx_umip_emulated() comes from the ancient time when there was a
>
> No, vmx_umip_emulated() comes from the fact that "cpu_has_vmx_desc()" is
> inscrutable for the relevant code.  There is zero reason to require that =
readers
> have a priori knowledge of why intercepting descriptor table access instr=
uctions
> is relevant to handing CR4.UMIP changes.

I think this is where comments can play its role.
>
> If it really bothers someone, we could do

Yeah, below also came to my mind, as one option.
>
>         static inline bool cpu_has_vmx_desc(void)
>         {
>                 return vmcs_config.cpu_based_2nd_exec_ctrl &
>                         SECONDARY_EXEC_DESC;
>         }
>
>         static inline bool vmx_umip_emulated(void)
>         {
>                 return cpu_has_vmx_desc();
>         }
>
> but I don't see the point since there is no usage for SECONDARY_EXEC_DESC=
 outside
> of UMIP emulation.

SECONDARY_EXEC_DESC concerns more than UMIP does. UMIP emulation just lever=
ages
part of it.

Also, vmx_umip_emulated() =3D=3D true doesn't necessarily mean, as its
name indicates,
UMIP-being-emulated, e.g. Host has UMIP capability, then UMIP isn't
emulated though
vmx_umip_emulated() indicates true.
