Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA886D4B54
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 17:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbjDCPC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 11:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjDCPCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 11:02:55 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645E311E93
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 08:02:54 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id e5-20020a17090301c500b001a1aa687e4bso17732066plh.17
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 08:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680534174;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hbMbZi+huQ2hPf3sjYcxLECq9oILbQJUcDUPXoJimxM=;
        b=gQFDScVEYVGkPX2vuuCtrfW8grQtu9fQFLRJmk2TKmcY2JCeDge0XbtL7jyzIMtj9J
         /kgNjX+HV8V7ViIZmKeLGda3QoJ2s3s9hK9rSGy1Fduo9BgaYRscfy5tqDS5Q/br512V
         kqP1ppWRv4qqlmmaU0J0uk9Hf2j6JdBdba5nDXD2aYj+bg4VhwzU041OHKG0uVbLKO2M
         QbrDlar6GApKBPjq4ZeRzWsmnyElmsF4ZOKhJtGgbBrTluI1D/QUaQeSAC+0ReNvRgbK
         S+cC0dOGOiqJ389WooWpLNbzY4mQUI3qGMaWxa4jSipucz3Qbiomi1MQOyBj1D8Aqpsn
         aR6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680534174;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hbMbZi+huQ2hPf3sjYcxLECq9oILbQJUcDUPXoJimxM=;
        b=2WvkA02zMcRzm9Ygsx1UP9E/USXhKXDbjwRPK2f5B1cOxs0P1xrmvxhLLQOOGiK94H
         Gk9lFHljttBYW2Zr4UaOIBQ+m690jhlf1mTu8A8x7if4p+IEVC4Vzq3+G9mgoZx6zCjx
         tqvaAcRiS1xkOE5eAAPt0RgnXXY8kOa6YO+zrCpVEKr0Kj7+LiTYldPMxPILKDzbbfjO
         iAg8OsEvdWkWSG3cas2G1WKTdnLfdEkLX5fb4ha2wQoick3A+R0S8iWEEuI69im6PvU6
         dAvPm90U08mcfLod/bZjauHf0uKfVbsNI4kQyogta/iizyG5oRltgiHlDr+JSFmP//ao
         dnmw==
X-Gm-Message-State: AAQBX9fPQLGudy4uYvTSAMOapbMdvARSa/j4kt8JZOrmCbWstNxRVrX1
        v6kaAHJHlrM4mkKdrG8rlx88s32PEDA=
X-Google-Smtp-Source: AKy350ZFF+f98maypgxRZSwem7yt3ugKYlpvsZ4d+KsXnuHKPwslT2YmO5o/yuIEa8NptQZGHoWDHljj2uc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:493:b0:1a2:6e4d:7831 with SMTP id
 jj19-20020a170903049300b001a26e4d7831mr6933034plb.12.1680534173947; Mon, 03
 Apr 2023 08:02:53 -0700 (PDT)
Date:   Mon, 3 Apr 2023 08:02:52 -0700
In-Reply-To: <fc92490afc7ee1b9679877878de64ad129853cc0.camel@intel.com>
Mime-Version: 1.0
References: <ZBhTa6QSGDp2ZkGU@gao-cwp> <ZBojJgTG/SNFS+3H@google.com>
 <12c4f1d3c99253f364f3945a998fdccb0ddf300f.camel@intel.com>
 <e0442b13-09f4-0985-3eb4-9b6a20d981fb@linux.intel.com> <682d01dec42ecdb80c9d3ffa2902dea3b1d576dd.camel@intel.com>
 <b9e9dd1c-2213-81c7-cd45-f5cf7b86610b@linux.intel.com> <ZCR2PBx/4lj9X0vD@google.com>
 <657efa6471503ee5c430e5942a14737ff5fbee6e.camel@intel.com>
 <349bd65a-233e-587c-25b2-12b6031b12b6@linux.intel.com> <fc92490afc7ee1b9679877878de64ad129853cc0.camel@intel.com>
Message-ID: <ZCrqZTZWd1LC5s3J@google.com>
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit mode
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023, Huang, Kai wrote:
> >=20
> > I checked the code again and find the comment of=20
> > nested_vmx_check_permission().
> >=20
> > "/*
> >  =EF=BF=BD* Intel's VMX Instruction Reference specifies a common set of=
=20
> > prerequisites
> >  =EF=BF=BD* for running VMX instructions (except VMXON, whose prerequis=
ites are
> >  =EF=BF=BD* slightly different). It also specifies what exception to in=
ject=20
> > otherwise.
> >  =EF=BF=BD* Note that many of these exceptions have priority over VM ex=
its, so they
> >  =EF=BF=BD* don't have to be checked again here.
> >  =EF=BF=BD*/"
> >=20
> > I think the Note part in the comment has tried to callout why the check=
=20
> > for compatibility mode is unnecessary.
> >=20
> > But I have a question here, nested_vmx_check_permission() checks that t=
he
> > vcpu is vmxon, otherwise it will inject a #UD. Why this #UD is handled =
in
> > the VMExit handler specifically?  Not all #UDs have higher priority tha=
n VM
> > exits?
> >=20
> > According to SDM Section "Relative Priority of Faults and VM Exits":
> > "Certain exceptions have priority over VM exits. These include=20
> > invalid-opcode exceptions, ..."
> > Seems not further classifications of #UDs.
>=20
> This is clarified in the pseudo code of VMX instructions in the SDM.  If =
you
> look at the pseudo code, all VMX instructions except VMXON (obviously) ha=
ve
> something like below:
>=20
> 	IF (not in VMX operation) ...
> 		THEN #UD;
> 	ELSIF in VMX non-root operation
> 		THEN VMexit;
>=20
> So to me "this particular" #UD has higher priority over VM exits (while o=
ther
> #UDs may not).

> But IIUC above #UD won't happen when running VMX instruction in the guest=
,
> because if there's any live guest, the CPU must already have been in VMX
> operation.  So below check in nested_vmx_check_permission():
>=20
> 	if (!to_vmx(vcpu)->nested.vmxon) {                                      =
     =20
>                 kvm_queue_exception(vcpu, UD_VECTOR);                    =
     =20
>                 return 0;                                                =
     =20
>         }
>=20
> is needed to emulate the case that guest runs any other VMX instructions =
before
> VMXON.

Yep.  IMO, the pseucode is misleading/confusing, the "in VMX non-root opera=
tion"
check should really come first.  The VMXON pseudocode has the same awkward
sequence:

    IF (register operand) or (CR0.PE =3D 0) or (CR4.VMXE =3D 0) or ...
        THEN #UD;
    ELSIF not in VMX operation
        THEN
            IF (CPL > 0) or (in A20M mode) or
            (the values of CR0 and CR4 are not supported in VMX operation)
                THEN #GP(0);
    ELSIF in VMX non-root operation
        THEN VMexit;
    ELSIF CPL > 0
        THEN #GP(0);
    ELSE VMfail("VMXON executed in VMX root operation");
    FI;


whereas I find this sequence for VMXON more representative of what actually=
 happens:

    IF (register operand) or (CR0.PE =3D 0) or (CR4.VMXE =3D 0) or ...
        THEN #UD

    IF in VMX non-root operation
        THEN VMexit;

    IF CPL > 0
        THEN #GP(0)

    IF in VMX operation
        THEN VMfail("VMXON executed in VMX root operation");

    IF (in A20M mode) or
       (the values of CR0 and CR4 are not supported in VMX operation)
        THEN #GP(0);

> > Anyway, I will seperate this patch from the LAM KVM enabling patch. And=
=20
> > send a patch seperately if needed later.
>=20
> I think your change for SGX is still needed based on the pseudo code of E=
NCLS.

Agreed.
