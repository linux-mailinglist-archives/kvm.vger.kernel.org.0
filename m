Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32F06BF4D4
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 23:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjCQWEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 18:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjCQWEI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 18:04:08 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD3A2E80A
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 15:03:57 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id i26-20020aa796fa000000b006261da7aeceso1714796pfq.5
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 15:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679090636;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7C3PJuu97/IUN2lM+itL189yjrDJAkAtzdO1nAsVKvY=;
        b=FWGgeZvK63Q1WB/XlhKAN68MH8trZ+PjZ1SV8UWcuXV2KXhVMI0v7cNIoOOCt8kmkQ
         kgoewKJzgTCT153lbLNPBKBuGIoIpcdEkLwUwjlWP7/+K/sarIAoCQ6Nbt+8TnpOqMzD
         xQUxgUCu7PAvy8Xj90dCNZzSGtSDE6vGeFfA/V+Gnt/RPqx94gx9yxh1z15vbCkf5COa
         XfyFr04LXrcbCZiK72fcJsWnhuDD6Tu5HvOowxc622yDSXGrp1RPKsRUW6mB6N/t0JcI
         TFCbYeJDW3+mfzyX+M2T81G796CYRdZSjGqtlEi7EEEKBgiTR5nDxeIhfyShrnJsbyFO
         fQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679090636;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7C3PJuu97/IUN2lM+itL189yjrDJAkAtzdO1nAsVKvY=;
        b=yxK3RRVEPhEsC7Cbj7Rd+gfliIJqApTjsb1stryCDl6R+cs742WfoCumROM4ayATbo
         gsxG7ZbTbAs3OpOsY7ZAHAPPsoXWrOBoA2NaQXuPEXX2K7p70Bj0hXXY0U0C37tj0xDv
         fUDUoCnu2HQilG7pYEG1nqK3aYWgjhz46fZmt/sLaA/1kKt6waF84Hc2AI6vLSGDmteQ
         KKh0IsxjHsAUvP//YiUFexcilekglqSF6nZT+aJ11eIsX9s8ZBRLXh+7uRlV1FlI/P3q
         FLcl2dsmHu4EOdTUmtIHPW0Q8Vvnyb3ypPDIGe8GTVdhRaZw6hVO3387rvQ5UjkapWVt
         gOHg==
X-Gm-Message-State: AO0yUKXSbGFlMZqDmFgVnMeZpwsVYepz0UA+KURZjvENt0S2NfK3NjfW
        vauEvsL7aCOUpYo8Ky8Ko8jbMSLzzXA=
X-Google-Smtp-Source: AK7set+VzqqNiIO1L9ALKARbx1rDsnA3JwjovSMCxTLDOQdu7hGMjzpjYDlM+0wJnuoxCZGZeHQmam0Cf8Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ca08:b0:23b:349d:a159 with SMTP id
 x8-20020a17090aca0800b0023b349da159mr1425777pjt.3.1679090636594; Fri, 17 Mar
 2023 15:03:56 -0700 (PDT)
Date:   Fri, 17 Mar 2023 15:03:55 -0700
In-Reply-To: <CAF7b7mpwJ55vhmVfy0-_Nosgd+GZfno_HT1QQHg-952kvXW_5Q@mail.gmail.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <ZBSmz0JAgTrsF608@linux.dev>
 <ZBStyKk6H73/0z2r@google.com> <CALzav=dBJyr373jnBF_-uLJfZMwHOsKSVSR2u4xr83etjp6Daw@mail.gmail.com>
 <ZBS3UbrWFZJzLzOq@linux.dev> <CALzav=fuZRrrMWHR+tRJ7R9hUDHyzhdBJ_Ak2V622TjRpFLoLw@mail.gmail.com>
 <CAF7b7mpwJ55vhmVfy0-_Nosgd+GZfno_HT1QQHg-952kvXW_5Q@mail.gmail.com>
Message-ID: <ZBTjyzOl58ITmkNk@google.com>
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

On Fri, Mar 17, 2023, Anish Moorthy wrote:
> On Fri, Mar 17, 2023 at 12:00=E2=80=AFPM David Matlack <dmatlack@google.c=
om> wrote:
> > > The low-level accessors are common across architectures and can be ca=
lled from
> > > other contexts besides a vCPU. Is it possible for the caller to catch=
 -EFAULT
> > > and convert that into an exit?
> >
> > Ya, as things stand today, the conversions _must_ be performed at the c=
aller, as
> > there are (sadly) far too many flows where KVM squashes the error.  E.g=
. almost
> > all of x86's paravirt code just suppresses user memory faults :-(
> >
> > Anish, when we discussed this off-list, what I meant by limiting the in=
tial support
> > to existing -EFAULT cases was limiting support to existing cases where =
KVM directly
> > returns -EFAULT to userspace, not to all existing cases where -EFAULT i=
s ever
> > returned _within KVM_ while handling KVM_RUN.  My apologies if I didn't=
 make that clear.
>=20
> Don't worry, we eventually got there off-list :)
>=20
> This brings us back to my original set of questions. As has already
> been pointed out, I'll have to revisit my "Confident that needs
> conversion" changes and tweak them so that the vCPU exit is populated
> only for the call sites where the -EFAULT makes it to userspace. I
> still want feedback on if I've mis-identified any of the functions in
> my "EFAULT does not propagate to userspace" list and whether there are
> functions/callers in the "Still unsure if needs conversion" which do
> have return paths to KVM_RUN.

As you've probably gathered from the type of feedback you're receiving, ide=
ntifying
the conversion touchpoints isn't going to be the long pole of this series. =
 Correctly
identifying all of the touchpoints may not be easy, but fixing any cases we=
 get wrong
will likely be straightforward.  And realistically, no matter how many eyeb=
alls look
at the code, odds are good we'll miss at least one case.  In other words, d=
on't worry
too much about getting all the touchpoints correct on the first version.  G=
etting the
uAPI right is much more important.

And rather than rely on code review to get things right, we should be able =
to
detect issues programmatically.  E.g. use fault injection to make gup() and=
/or
uaccess fail (might even be wired up already?), and hack in a WARN in the K=
VM_RUN
path to assert that KVM_EXIT_MEMORY_FAULT is filled if the return code is -=
EFAULT
(assuming we go don't try to get KVM to return 0 everywhere), e.g. somethin=
g like
the below would at least flag the "misses", although debug could still prov=
e to be
annoying.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67b890e54cf1..cccae0ad1436 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4100,6 +4100,8 @@ static long kvm_vcpu_ioctl(struct file *filp,
                }
                r =3D kvm_arch_vcpu_ioctl_run(vcpu);
                trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
+               WARN_ON(r =3D=3D -EFAULT &&
+                       vcpu->run->exit_reason =3D=3D KVM_EXIT_MEMORY_FAULT=
);
                break;
        }
        case KVM_GET_REGS: {

