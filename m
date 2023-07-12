Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A15D750EDB
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbjGLQnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbjGLQnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:43:01 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447D8139
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:43:00 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b888bdacbcso68383205ad.2
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689180179; x=1691772179;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pJeJfhMLEnhRMANJsk6yWXHyLbadVDaiRIH4vbqT/vk=;
        b=k41zHfIMZRbHeWmRjg7KUfi8JPaEBqss88J+m6mAgEE9A+R5NjyrNiSWps69gLz0Ba
         aYUJgDGGGxE3x4HvGPaSpSU3eSb2keI1z+gC/jsDvA3ampK8I2wxusUVK0aestPx1g0v
         D6vAMJpnGoSaTWDIyjQTXs7teXrnmcDC+++Tm7aaWBJ9AqGpOjvrubGF95SBaxlQriQL
         gYIE05SZ8yM8uAelypkSfQequ+qFtGDOSQH+yWr2AzF+ivYsuJWnKA3odIrmoZR6JD5Q
         8YTHFqF2p4UlJCtwZL75hBdZJJ/J/ZnICyik9edEoIKm4DaoUiyYBH3RthpntUr0lMOB
         ttvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689180179; x=1691772179;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pJeJfhMLEnhRMANJsk6yWXHyLbadVDaiRIH4vbqT/vk=;
        b=jdkBMQp6sCE50cNmxcdohq4R7gU/+10JjOGivoIzkpjIUH+QdnNgA0JJEzf5Rg2WoH
         5wT5bavIKDGbcBW0VmQEbAvdl1fynb4ojk9wDUPxieDp3lYZC6a2OmPdCUNubFht0Vgd
         9WfuCr+YyebcEXXoV8poGO5KnfihHexyK6b6p8V9pFjTLOJmF2XssX+zBbnlb6XbPc3+
         ek5jt56Ctvy2IWkyQEI4Iisy6uWgx49Ccxv0E1DQEzHNT0xAMg6TTW10bueWPH7HlD7h
         i577FNSZEifI/stlOfzWYTd6cDkt9FY1zDyUlTJnGp2jR3Ko5kzVAuawlJuAPz5yoJm2
         QvgA==
X-Gm-Message-State: ABy/qLbjCBI5oPA2Tzv43qvGJ7EL8weML6rzv7rp/ONeIl90NGobdNK5
        NOy+e930WZcXi/fTxPZrMdjJW99J9GE=
X-Google-Smtp-Source: APBJJlHpBa2hBuxNS4HgO14PIZEQ4LuQ+Nt324qJ+jTn5kIZf90oDrZAZf9mlj8iVnKCvgthVo9Lb9C4vF0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:495:b0:1b5:2871:cd1 with SMTP id
 jj21-20020a170903049500b001b528710cd1mr11822099plb.0.1689180179646; Wed, 12
 Jul 2023 09:42:59 -0700 (PDT)
Date:   Wed, 12 Jul 2023 09:42:57 -0700
In-Reply-To: <30b8d82b-ae2a-7022-2343-6cef9416510a@intel.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-14-weijiang.yang@intel.com> <ZJYwg3Lnq3nJZgQf@google.com>
 <30b8d82b-ae2a-7022-2343-6cef9416510a@intel.com>
Message-ID: <ZK7YEUE9lxlvagsv@google.com>
Subject: Re: [PATCH v3 13/21] KVM:VMX: Emulate reads and writes to CET MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Gil Neiger <gil.neiger@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 07, 2023, Weijiang Yang wrote:
> > Side topic, what on earth does the SDM mean by this?!?
> >=20
> >    The linear address written must be aligned to 8 bytes and bits 2:0 m=
ust be 0
> >    (hardware requires bits 1:0 to be 0).
> >=20
> > I know Intel retroactively changed the alignment requirements, but the =
above
> > is nonsensical.  If ucode prevents writing bits 2:0, who cares what har=
dware
> > requires?
>=20
> Hi, Sean,
>=20
> Regarding the alignment check, I got update from Gil:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>=20
> The WRMSR instruction to load IA32_PL[0-3]_SSP will #GP if the value to b=
e
> loaded sets either bit 0 or bit 1.=C2=A0 It does not check bit 2.
> IDT event delivery, when changing to rings 0-2 will load SSP from the MSR
> corresponding to the new ring.=C2=A0 These transitions check that bits 2:=
0 of the
> new value are all zero and will generate a nested fault if any of those b=
its
> are set.=C2=A0 (Far CALL using a call gate also checks this if changing C=
PL.)
>=20
> For a VMM that is emulating a WRMSR by a guest OS (because it was
> intercepting writes to that MSR), it suffices to perform the same checks =
as
> the CPU would (i.e., only bits 1:0):
> =E2=80=A2=C2=A0=C2=A0=C2=A0 If the VMM sees bits 1:0 clear, it can perfor=
m the write on the part of
> the guest OS.=C2=A0 If the guest OS later encounters a #GP during IDT eve=
nt
> delivery (because bit 2 is set), it is its own fault.
> =E2=80=A2=C2=A0=C2=A0=C2=A0 If the VMM sets either bit 0 or bit 1 set, it=
 should inject a #GP into
> the guest, as that is what the CPU would do in this case.
>=20
> For an OS that is writing to the MSRs to set up shadow stacks, it should
> WRMSR the base addresses of those stacks.=C2=A0 Because of the token-base=
d
> architecture used for supervisor shadow stacks (for rings 0-2), the base
> addresses of those stacks should be 8-byte aligned (clearing bits 2:0).=
=C2=A0
> Thus, the values that an OS writes to the corresponding MSRs should clear
> bits 2:0.
>=20
> (Of course, most OS=E2=80=99s will use only the MSR for ring 0, as most O=
S=E2=80=99s do not
> use rings 1 and 2.)
>=20
> In contrast, the IA32_PL3_SSP MSR holds the current SSP for user software=
.=C2=A0
> When a user thread is created, I suppose it may reference the base of the
> user shadow stack.=C2=A0 For a 32-bit app, that needs to be 4-byte aligne=
d (bits
> 1:0 clear); for a 64-bit app, it may be necessary for it to be 8-byte
> aligned (bits 2:0) clear.
>=20
> Once the user thread is executing, the CPU will load IA32_PL3_SSP with th=
e
> user=E2=80=99s value of SSP on every exception and interrupt to ring 0.=
=C2=A0 The value
> at that time may be 4-byte or 8-byte aligned, depending on how the user
> thread is using the shadow stack.=C2=A0 On context switches, the OS shoul=
d WRMSR
> whatever value was saved (by RDMSR) the last time there was a context swi=
tch
> away from the incoming thread.=C2=A0 The OS should not need to inspect or=
 change
> this value.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>=20
> Based on his feedback, I think VMM needs to check bits 1:0 when write the
> SSP MSRs. Is it?

Yep, KVM should only check bits 1:0 when emulating WRMSR.  KVM doesn't emul=
ate
event delivery except for Real Mode, and I don't see that ever changing.  S=
o to
"handle" the #GP during event delivery case, KVM just needs to propagate th=
e "bad"
value into guest context, which KVM needs to do anyways.

Thanks for following up on this!
