Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD79F6C1AEA
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 17:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbjCTQHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 12:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbjCTQH1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 12:07:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF6938022
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 08:57:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z31-20020a25a122000000b00b38d2b9a2e9so13286419ybh.3
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 08:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679327820;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eNR3UizMUz68PAAbpQBLUx5qZhNQIifDJtypw9jZIoY=;
        b=qPXLPJb451tKGXNnG03rIsfjXOFlYCinB5RDAFIiIdYXkmSIhxX+PX1SKv7saayu68
         vefT233ETuhNi6HAKKybGcCqz1oo2xASpssleNLp2/pDx4Wqltv3Qf9w+tS7di3Rt+yG
         FDtI9KvDAfZ1U4ytgUQiPah6sG6uDj/sJKqyqwxn0UDnjKtvWMlT6lmuGMjGcySeDNI0
         z2tco/Doc9ZGxEecfP+ln0YuIvWczhdmZVmBQxmRlNGxwFnqqPBS0LFVru4pOuO9wJQX
         psHdECTNlYEEbSBNJdzPHo7yxtONCUSm9s5zUT0efin5Eb4HgTIxF0Xaf7Vm81DyqBRY
         Qv3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679327820;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eNR3UizMUz68PAAbpQBLUx5qZhNQIifDJtypw9jZIoY=;
        b=OpFeysc0c83uhYUNCHCTBVukV7vmKbXg/HPV0LqSB/cXOV0Ynr2Fn/vsxJvFcpepUr
         uM/1vIu8ywBTsHCGad5KN9GwNBpIOnuCq1bALSZC/St/X6CGPTKW33d7KV97ULVZHJa9
         DDKtKtTHXIBQYDO7T8iZ04KDCYH7+kTqMM4Toou2paBhv4HEzyb0W4fcjkdMrj156EF6
         bvuk8Bt16O9QOReS0vfIK2vIl6J++EYNQWJSFisfshBnnDR15wH0Kz11MABdtC5Lc5Qo
         GAt6Zx7mAaEiyvdiDe+XBShWTcit0MGK0HtmfBwa2PGz4FZZmC85/WtDTP8JcSOo0bY9
         Hp5Q==
X-Gm-Message-State: AO0yUKU0GQdu+y0jIL3JqUWNTfhSfHUexZp1j8qP0sSlttswEYAOqPA+
        doITI3JT/oYjfOr9e563cNliq2EJ6zQ=
X-Google-Smtp-Source: AK7set+8GXHmUO5xTRursJvAv3GyHgeciHG+SlN//jgPwEzVWBqxLaPu3S8Em0agX4geKmITK45CRVQ1BGg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1002:b0:a27:3ecc:ffe7 with SMTP id
 w2-20020a056902100200b00a273eccffe7mr5617347ybt.3.1679327820764; Mon, 20 Mar
 2023 08:57:00 -0700 (PDT)
Date:   Mon, 20 Mar 2023 08:56:59 -0700
In-Reply-To: <ZBTjyzOl58ITmkNk@google.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <ZBSmz0JAgTrsF608@linux.dev>
 <ZBStyKk6H73/0z2r@google.com> <CALzav=dBJyr373jnBF_-uLJfZMwHOsKSVSR2u4xr83etjp6Daw@mail.gmail.com>
 <ZBS3UbrWFZJzLzOq@linux.dev> <CALzav=fuZRrrMWHR+tRJ7R9hUDHyzhdBJ_Ak2V622TjRpFLoLw@mail.gmail.com>
 <CAF7b7mpwJ55vhmVfy0-_Nosgd+GZfno_HT1QQHg-952kvXW_5Q@mail.gmail.com> <ZBTjyzOl58ITmkNk@google.com>
Message-ID: <ZBiCS3gSLUtBuixY@google.com>
Subject: Re: [WIP Patch v2 00/14] Avoiding slow get-user-pages via memory
 fault exit
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>, jthoughton@google.com,
        kvm@vger.kernel.org, maz@kernel.org,
        Isaku Yamahata <isaku.yamahata@gmail.com>
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

On Fri, Mar 17, 2023, Sean Christopherson wrote:
> On Fri, Mar 17, 2023, Anish Moorthy wrote:
> > On Fri, Mar 17, 2023 at 12:00=E2=80=AFPM David Matlack <dmatlack@google=
.com> wrote:
> > > > The low-level accessors are common across architectures and can be =
called from
> > > > other contexts besides a vCPU. Is it possible for the caller to cat=
ch -EFAULT
> > > > and convert that into an exit?
> > >
> > > Ya, as things stand today, the conversions _must_ be performed at the=
 caller, as
> > > there are (sadly) far too many flows where KVM squashes the error.  E=
.g. almost
> > > all of x86's paravirt code just suppresses user memory faults :-(
> > >
> > > Anish, when we discussed this off-list, what I meant by limiting the =
intial support
> > > to existing -EFAULT cases was limiting support to existing cases wher=
e KVM directly
> > > returns -EFAULT to userspace, not to all existing cases where -EFAULT=
 is ever
> > > returned _within KVM_ while handling KVM_RUN.  My apologies if I didn=
't make that clear.
> >=20
> > Don't worry, we eventually got there off-list :)
> >=20
> > This brings us back to my original set of questions. As has already
> > been pointed out, I'll have to revisit my "Confident that needs
> > conversion" changes and tweak them so that the vCPU exit is populated
> > only for the call sites where the -EFAULT makes it to userspace. I
> > still want feedback on if I've mis-identified any of the functions in
> > my "EFAULT does not propagate to userspace" list and whether there are
> > functions/callers in the "Still unsure if needs conversion" which do
> > have return paths to KVM_RUN.
>=20
> As you've probably gathered from the type of feedback you're receiving, i=
dentifying
> the conversion touchpoints isn't going to be the long pole of this series=
.  Correctly
> identifying all of the touchpoints may not be easy, but fixing any cases =
we get wrong
> will likely be straightforward.  And realistically, no matter how many ey=
eballs look
> at the code, odds are good we'll miss at least one case.  In other words,=
 don't worry
> too much about getting all the touchpoints correct on the first version. =
 Getting the
> uAPI right is much more important.
>=20
> And rather than rely on code review to get things right, we should be abl=
e to
> detect issues programmatically.  E.g. use fault injection to make gup() a=
nd/or
> uaccess fail (might even be wired up already?), and hack in a WARN in the=
 KVM_RUN
> path to assert that KVM_EXIT_MEMORY_FAULT is filled if the return code is=
 -EFAULT
> (assuming we go don't try to get KVM to return 0 everywhere), e.g. someth=
ing like
> the below would at least flag the "misses", although debug could still pr=
ove to be
> annoying.
>=20
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 67b890e54cf1..cccae0ad1436 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4100,6 +4100,8 @@ static long kvm_vcpu_ioctl(struct file *filp,
>                 }
>                 r =3D kvm_arch_vcpu_ioctl_run(vcpu);
>                 trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
> +               WARN_ON(r =3D=3D -EFAULT &&
> +                       vcpu->run->exit_reason =3D=3D KVM_EXIT_MEMORY_FAU=
LT);

Gah, I inverted the second check, this should be=20

		WARN_ON(r =3D=3D -EFAULT &&
			vcpu->run->exit_reason !=3D KVM_EXIT_MEMORY_FAULT);
	=09
>                 break;
>         }
>         case KVM_GET_REGS: {
>=20
