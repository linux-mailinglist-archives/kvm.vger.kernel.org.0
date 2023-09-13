Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D2F79EB91
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 16:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236196AbjIMOuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 10:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjIMOue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 10:50:34 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283EDB2
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 07:50:30 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5704127d08cso854682a12.1
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 07:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694616629; x=1695221429; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q41llD3aO1ZBdbxd4yEGR7UuhY6UnD3ZTPq+ctmbTzk=;
        b=j2XQEjJAwF3a79kZbyVFFjs/4gUpLaNauNZrrSeekpWXr8Srj4P9psd0BOpPqQJUGL
         GGjvUXWrC1ZsSRIt9ztMssW8VK7XG8Y7oWL0UiTObCKHo7iIEZ9b4xZgYODHWDCdpE0S
         oOaFdZwOi7/ikDi+PMaL5dfddR2nilFkLPiaM4Du+FIJPUYIfX6Qdadir/Y5JlHvZlSj
         XzTXB0lo9jxb9d6V9XJIanTSBKEiKjGpfVos/9Rc0JP2QyjrxrQGPwvHbjm7H5stdUfa
         cuv46TNBQwnaACDN08ettIVGmQ1DeJNtXBKkhmF5HWL5T9LxGR/z99ogdG9a6kKfaozK
         EM0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694616629; x=1695221429;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Q41llD3aO1ZBdbxd4yEGR7UuhY6UnD3ZTPq+ctmbTzk=;
        b=XB3C+rMVSvRxBasIRUKQoeeszUfL7B1ozjvj8gBJrcPZJKYDLs079tBQslFAJ8WNQh
         QF4Bn9aENXiqfsaSAUbqwxQHFFjED00uZehZP2w0gkS1nZ4rYudfkR4WTTb5mUk7gwje
         G2vZLqYhWWj0p3ZJlU0x/eYzL/xdYseIg8jXHtR9Bll03QLXYHEVZwGi2GGHzRtZmpn1
         SKxr9IjhDfJ2YtFNHlysR6J9t6MZQIhN7dJ1kFwanaRMQGy8D+BmQtQM3PrcWsZTd8K1
         c7QevFCSV+u3S9UsCH41lL/0bWO7BiRhwyZxfUMhoQmSDK/W/gx8d4RIhChF+cJdr16I
         sqog==
X-Gm-Message-State: AOJu0Yx+lbKP8D26zYherOA+hZfh/Xvj1M/5w5otiO3SPPxMwY14OaZO
        pk7L62f3K7JFtdeicIObJ8+PJuzBIeU=
X-Google-Smtp-Source: AGHT+IF6OLHFs3rc4zlDaaJJlMjjFatCSnlFXp9JVMtBirdNZQaMQNAvUPI9DJwp3ilRUBYHX9sLm/FMmBE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:348c:0:b0:563:dced:3f3a with SMTP id
 b134-20020a63348c000000b00563dced3f3amr127344pga.0.1694616629594; Wed, 13 Sep
 2023 07:50:29 -0700 (PDT)
Date:   Wed, 13 Sep 2023 07:50:27 -0700
In-Reply-To: <055482bec09cae1ea56f979893c6b67e9d6b26a2.camel@infradead.org>
Mime-Version: 1.0
References: <20230801034524.64007-1-likexu@tencent.com> <ZNa9QyRmuAjNAonC@google.com>
 <055482bec09cae1ea56f979893c6b67e9d6b26a2.camel@infradead.org>
Message-ID: <ZQHMM8/7xXReZHdD@google.com>
Subject: Re: [PATCH v4] KVM: x86/tsc: Don't sync user changes to TSC with
 KVM-initiated change
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 13, 2023, David Woodhouse wrote:
> On Fri, 2023-08-11 at 15:59 -0700, Sean Christopherson wrote:
> > On Tue, Aug 01, 2023, Like Xu wrote:
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 278dbd37dab2..eeaf4ad9174d 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -2713,7 +2713,7 @@ static void __kvm_synchronize_tsc(struct kvm_vc=
pu *vcpu, u64 offset, u64 tsc,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm_track_tsc_matchin=
g(vcpu);
> > > =C2=A0 }
> > > =C2=A0=20
> > > -static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
> > > +static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data, boo=
l user_initiated)
> >=20
> > Rather than pass two somewhat magic values for the KVM-internal call, w=
hat about
> > making @data a pointer and passing NULL?
>=20
> Why change that at all?
>=20
> Userspace used to be able to force a sync by writing zero. You are
> removing that from the ABI without any explanation about why;

No, my suggestion did not remove that from the ABI.  A @user_value of '0' w=
ould
still force synchronization.

-static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
+static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
 {
+       u64 data =3D user_value ? *user_value : 0;  <=3D=3D=3D "*user_value=
" is '0'
        struct kvm *kvm =3D vcpu->kvm;
        u64 offset, ns, elapsed;
        unsigned long flags;
@@ -2712,14 +2713,17 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vc=
pu, u64 data)
        elapsed =3D ns - kvm->arch.last_tsc_nsec;

        if (vcpu->arch.virtual_tsc_khz) {
+               /*
+                * Force synchronization when creating or hotplugging a vCP=
U,
+                * i.e. when the TSC value is '0', to help keep clocks stab=
le.
+                * If this is NOT a hotplug/creation case, skip synchroniza=
tion
+                * on the first write from userspace so as not to misconstr=
ue
+                * state restoration after live migration as an attempt fro=
m
+                * userspace to synchronize.
+                */
                if (data =3D=3D 0) { <=3D=3D "data" still '0', still forces=
 synchronization
-                       /*
-                        * detection of vcpu initialization -- need to sync
-                        * with other vCPUs. This particularly helps to kee=
p
-                        * kvm_clock stable after CPU hotplug
-                        */
                        synchronizing =3D true;

> it doesn't seem necessary for fixing the original issue.

It's necessary for "user_set_tsc" to be an accurate name.  The code in v6 y=
ields
"user_set_tsc_to_non_zero_value".  And I don't think it's just a naming iss=
ue,
e.g. if userspace writes '0' immediately after creating, and then later wri=
tes a
small delta, the v6 code wouldn't trigger synchronization because "user_set=
_tsc"
would be left unseft by the write of '0'.
