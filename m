Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A3F6D1CF4
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 11:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbjCaJuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 05:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbjCaJtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 05:49:53 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C651FD08
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 02:48:46 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id o44so16006647qvo.4
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 02:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680256125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=haO5oy1hHoEi95p0w0HT0G2pQYSJcwxtZ4LM32vwLeg=;
        b=eM1shNluFqdhpLeIhdFpgPHr2gGo13yM8w11yfVl5Hyh/ii4eciTnk82cdXE6NMpGZ
         At7gEqB0jq73fDdJweyFFf7m8ZQh3fjxobibq+DJzxPdYdCa5GhjiO6GFfKzG0oOyfEm
         Y0lxTuOpWYm5S8OFLMFZKKGndayNNUutdKteTo7ENFT46/t/95YztSs+byVM5PHNCuT+
         akKXzsMAuKxKjstnxJ1KyymmLCkamPCTQFHCOq2dpQ/7WAvVomgA324LWz/f4IF5+UFf
         lc/OIv62dYWkQh0VhEFAaimttnJEjUSj868whHpW+VOC9/U4L/W+jaFf7yfprGXodTU2
         Ob1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680256125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=haO5oy1hHoEi95p0w0HT0G2pQYSJcwxtZ4LM32vwLeg=;
        b=SibFX/JTvQmR7PveP4n6ie8CviNFX9ad2srRFx+FWolnfY43CSUtSAtfg+tMBduWsG
         QvEusHnz3v+u3MlMFiJR77SSEoot04UldzB5r+c9oO3K1CpQg4wuOBP7jbDyGAr6bf+Z
         KlV3l19cQa9T0owqGL1bHopyPlWhvg5h/e9buk7MGxj2IO0KO5Np8uFS0GWIZC+YlujE
         y1AHUaBjzFoDgpItVEVgjqA4pug25tc3dR3ZiS/AkWD5jsN7BkQKK2J8qyb/gmNn7jvj
         0V0TFcabPuU5oXLg7ThjZ6fQON/tTUAJekCHKI5Yz/c2CUEaHMhU2wUTFSdEqU6KdpR9
         c5pA==
X-Gm-Message-State: AAQBX9cF5WwrNsW4sKjWKbyoiCJQkREGYrlAkGDXS1oqLRCi0abpMDDF
        W5MQV1a1YtdX4VsqyZkWYcI35cdHPn35PPSSwu4=
X-Google-Smtp-Source: AKy350amKlB75t1uLraLDYMg9Glfrt5gHish7KRp1pHgLWaCjuj3A/L+1XaskAFJAOIOtXciakaLsNa5QnAEzJIVuh8=
X-Received: by 2002:a05:6214:1750:b0:5df:4d3f:81f4 with SMTP id
 dc16-20020a056214175000b005df4d3f81f4mr2159878qvb.7.1680256125491; Fri, 31
 Mar 2023 02:48:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230310125718.1442088-1-robert.hu@intel.com> <20230310125718.1442088-3-robert.hu@intel.com>
 <ZAtW7PF/1yhgBwYP@google.com> <CA+wubQAXBFthBhsNqWDtY=Qf4-FtfJ3dojJctXXg=iokXJRbmg@mail.gmail.com>
 <ZBHz7kL7wSRZzvKk@google.com>
In-Reply-To: <ZBHz7kL7wSRZzvKk@google.com>
From:   Robert Hoo <robert.hoo.linux@gmail.com>
Date:   Fri, 31 Mar 2023 17:48:34 +0800
Message-ID: <CA+wubQBDU4y97HrShmn+=0=o0HGwTckU1_y+VJLCuJtf2M+fyw@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: VMX: Remove a unnecessary cpu_has_vmx_desc()
 check in vmx_set_cr4()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Robert Hoo <robert.hu@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=8816=
=E6=97=A5=E5=91=A8=E5=9B=9B 00:36=E5=86=99=E9=81=93=EF=BC=9A
> > Sorry I don't follow you.
> > My point is that, given it has passed kvm_is_valid_cr4() (in kvm_set_cr=
4()),
> > we can assert boot_cpu_has(X86_FEATURE_UMIP)  and vmx_umip_emulated() m=
ust be
> > at least one true.
>
> This assertion is wrong for the case where guest.CR4.UMIP=3D0.  The below=
 code is
> not guarded with a check on guest.CR4.UMIP.  If the vmx_umip_emulated() c=
heck goes
> away and guest.CR4.UMIP=3D0, KVM will attempt to write secondary controls=
.
>

Sorry still don't follow you. Do you mean in nested case? the "guest"
above is L1?

> Technically, now that controls_shadow exists, KVM won't actually do a VMW=
RITE,
> but I most definitely don't want to rely on controls_shadow for functiona=
l
> correctness.  And controls_shadow aside, the "vmx_umip_emulated()" effect=
ively
> serves as documentation for why KVM is mucking with UMIP when it's obviou=
sly not
> supported in hardware.
>
>         if (!boot_cpu_has(X86_FEATURE_UMIP) && vmx_umip_emulated()) {
>                 if (cr4 & X86_CR4_UMIP) {
>                         secondary_exec_controls_setbit(vmx, SECONDARY_EXE=
C_DESC);
>                         hw_cr4 &=3D ~X86_CR4_UMIP;
>                 } else if (!is_guest_mode(vcpu) ||
>                         !nested_cpu_has2(get_vmcs12(vcpu), SECONDARY_EXEC=
_DESC)) {
>                         secondary_exec_controls_clearbit(vmx, SECONDARY_E=
XEC_DESC);
>                 }
>         }
