Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7D36BB9C2
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 17:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbjCOQgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 12:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjCOQgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 12:36:07 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525606FFDE
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 09:36:00 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id a17-20020a056a001d1100b00625760338c5so2613837pfx.14
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 09:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678898159;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NegWPg0Lvu/eZQrAwDtVNiRiSWTeZSjojzDjsuosPPc=;
        b=BkH9SMl/ovE+tHe9ijLaPoKPfnV2DrNAdNrzrXh1m8LlB/f5FxmvR/HRDZR3c1w1A3
         cOf0fVC4GNvJzrnvOVu6wVHS7+4ukone5w6im9iyzAdRyie06dCZ2udJSzeA6225lUoo
         sacBkvtFTrBLv2WrTnh+6vHnk4ma2oSeYdxCs21gd5LwGlyiQG+Q2E+2tFQUCW4MbIJg
         k3AG1p4789Hl82bAmoPtUnSNhVOnzU8J++T3tVf5Ub2zU8wqAo3EY2U3X1ABTcg+7/98
         ceJCVzI92/fQW1ISQmFgwFQtcNdME1j6WDiKpVlaLO1foc5/WQ+lgB/v0CT4eRpsdqXJ
         nmfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678898159;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NegWPg0Lvu/eZQrAwDtVNiRiSWTeZSjojzDjsuosPPc=;
        b=VDG8vehkzTxCj2zS2XWlGzZqjJjsPaaxAhgGJt2iIlYO4sUg6rF5M3JNWEHBypByRc
         mRwEtOUK0uwWLmlWeRfh7XnUUZGXSaKHa3Oj7UBauEuAPsBJ7TmwT51JO1TYj9aRU/Tg
         1C2zz4Q724pJYA/tq9IY8yryocXlUMf99H0Hxs3X2sNKNMOUBYzvTfGkApjK5AvK0Tc5
         2CDqM2tNYcTaRcAYvVXAMoMp9YKefQjlHSHwG5mDlZ47WmP8GoKgr6VmZmL9rS+Cxy75
         bi4zMmqvR+mf8PGqJXFrxCG0wXq7qBGz/mUwsiIupz0Rd4fy//y6w9RmklLiSQLBISDV
         4ETA==
X-Gm-Message-State: AO0yUKV1Ky3IO9uU2GEXmCONMEzmMbQC4ggqWJuXG7gr2DkaaZjKqKNG
        OR4s/0kgCQ+aNLdpTimGcFrxDpisY1A=
X-Google-Smtp-Source: AK7set/G4MhxVu3xt4Lnxfnwt7snTSRIg9+6tosFgbiW6f3GfKcKwqYtkNeDgzEMxq/6VJK79MDNUGNvt14=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:ff25:0:b0:507:3e33:4390 with SMTP id
 k37-20020a63ff25000000b005073e334390mr94688pgi.6.1678898159630; Wed, 15 Mar
 2023 09:35:59 -0700 (PDT)
Date:   Wed, 15 Mar 2023 09:35:58 -0700
In-Reply-To: <CA+wubQAXBFthBhsNqWDtY=Qf4-FtfJ3dojJctXXg=iokXJRbmg@mail.gmail.com>
Mime-Version: 1.0
References: <20230310125718.1442088-1-robert.hu@intel.com> <20230310125718.1442088-3-robert.hu@intel.com>
 <ZAtW7PF/1yhgBwYP@google.com> <CA+wubQAXBFthBhsNqWDtY=Qf4-FtfJ3dojJctXXg=iokXJRbmg@mail.gmail.com>
Message-ID: <ZBHz7kL7wSRZzvKk@google.com>
Subject: Re: [PATCH 2/3] KVM: VMX: Remove a unnecessary cpu_has_vmx_desc()
 check in vmx_set_cr4()
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hoo.linux@gmail.com>
Cc:     Robert Hoo <robert.hu@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 11, 2023, Robert Hoo wrote:
> Sean Christopherson <seanjc@google.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=881=
1=E6=97=A5=E5=91=A8=E5=85=AD 00:12=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Fri, Mar 10, 2023, Robert Hoo wrote:
> > > Remove the unnecessary cpu_has_vmx_desc() check for emulating UMIP.
> >
> > It's not unnecessary.  See commit 64f7a11586ab ("KVM: vmx: update sec e=
xec controls
> > for UMIP iff emulating UMIP").  Dropping the check will cause KVM to ex=
ecute
> >
> >         secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_DESC);
> >
> > on CPUs that don't have SECONDARY_VM_EXEC_CONTROL.
>=20
> Sorry I don't follow you.
> My point is that, given it has passed kvm_is_valid_cr4() (in kvm_set_cr4(=
)),
> we can assert boot_cpu_has(X86_FEATURE_UMIP)  and vmx_umip_emulated() mus=
t be
> at least one true.

This assertion is wrong for the case where guest.CR4.UMIP=3D0.  The below c=
ode is
not guarded with a check on guest.CR4.UMIP.  If the vmx_umip_emulated() che=
ck goes
away and guest.CR4.UMIP=3D0, KVM will attempt to write secondary controls.

Technically, now that controls_shadow exists, KVM won't actually do a VMWRI=
TE,
but I most definitely don't want to rely on controls_shadow for functional
correctness.  And controls_shadow aside, the "vmx_umip_emulated()" effectiv=
ely
serves as documentation for why KVM is mucking with UMIP when it's obviousl=
y not
supported in hardware.

	if (!boot_cpu_has(X86_FEATURE_UMIP) && vmx_umip_emulated()) {
		if (cr4 & X86_CR4_UMIP) {
			secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
			hw_cr4 &=3D ~X86_CR4_UMIP;
		} else if (!is_guest_mode(vcpu) ||
			!nested_cpu_has2(get_vmcs12(vcpu), SECONDARY_EXEC_DESC)) {
			secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_DESC);
		}
	}
