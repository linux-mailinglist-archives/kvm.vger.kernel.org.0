Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469D66BF497
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 22:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjCQVvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 17:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjCQVvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 17:51:10 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1149C9311D
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 14:50:28 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id u22-20020a17090abb1600b0023f0575ebf0so4186220pjr.9
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 14:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679089824;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hdPge4bhOsWQbmZrwme423W7WRqdyrCd2AvtA/fj7QE=;
        b=JjO9xXnuzRjj/hog2yauNL3Qa2MgKCq4BsIPDmJncgc/6aX+NME2UlKmXBIYDHFKxS
         9792UxcJIeSpn7RUTUwSdGIrs9fpLjw3PQP0/EJhaWCl817jLBLImfFQ8sVoJuiJXYBl
         NMB7JtV0gsG0JY8ZiyQ5zntbmMMQEI3Ru22Q8ySxpKaMsL01/l3SuocSdB3/VBgLA/Yd
         fmi9ttlr60sW8yVLCY1nlGOmxydV2Rqf0mBDzACq9LiOqB0U9Q6/tKgZIEWyu5ipQTEk
         RT8kHme7zjCqPosF6+GzRn+DkhjdUPkbwMZN7oXhyUXgyKckU3YpzHJiqcz+GYYfalBZ
         2eMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679089824;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hdPge4bhOsWQbmZrwme423W7WRqdyrCd2AvtA/fj7QE=;
        b=xzaCGWCkPhskwOFRcogMsJxBusxkzmrFSEltKma1R3JA5IOIYzAxqypcK7+7aQmy+W
         2yL7nqYFSAQddTGrMwKmPHEI/YllkhkHknuq4D2mxpILzo+ZT2OcllRSIaorrczaedv+
         DPhqq42je50si25Mmiwv7N3mxFDRosWjWOLDD4oh1xhkPDfmjIxS7GrKYYV/Mm8oysbq
         4uk+0MQMrEQ/pwQSoCD63J3wQBvyPmI9jNKhgdBy+X9csRlJdjBCnhryUeWkIx6ZA+lI
         JcqNF4Wev75IsQV1MsoT0aQQXgRoqDBTze8KBz5S9bEt263mZP/Vf02K+7XFCb5R8rBv
         C1ug==
X-Gm-Message-State: AO0yUKUVcntDe7FniO2Ygudk7DOfW9gyTnl73MY3ywGtG0jaaT0exQ8W
        4kXZZML1g099X9nW1UFrtCO0YoX6GRE=
X-Google-Smtp-Source: AK7set/OHXHCF1av/YaQbLQdhw0lrpqh12uV5bz+F/t2BLB40XOviSVPWewE3R8ZPxfDrxeo8bytR57GTyM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a3c8:b0:19f:2af0:466a with SMTP id
 q8-20020a170902a3c800b0019f2af0466amr3332378plb.4.1679089824069; Fri, 17 Mar
 2023 14:50:24 -0700 (PDT)
Date:   Fri, 17 Mar 2023 14:50:22 -0700
In-Reply-To: <CAF7b7mrTa735kDaEsJQSHTt7gpWy_QZEtsgsnKoe6c21s0jDVw@mail.gmail.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-5-amoorthy@google.com>
 <20230317000226.GA408922@ls.amr.corp.intel.com> <CAF7b7mrTa735kDaEsJQSHTt7gpWy_QZEtsgsnKoe6c21s0jDVw@mail.gmail.com>
Message-ID: <ZBTgnjXJvR8jtc4i@google.com>
Subject: Re: [WIP Patch v2 04/14] KVM: x86: Add KVM_CAP_X86_MEMORY_FAULT_EXIT
 and associated kvm_run field
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, jthoughton@google.com,
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

On Fri, Mar 17, 2023, Anish Moorthy wrote:
> On Thu, Mar 16, 2023 at 5:02=E2=80=AFPM Isaku Yamahata <isaku.yamahata@gm=
ail.com> wrote:
> > > +inline int kvm_memfault_exit_or_efault(
> > > +     struct kvm_vcpu *vcpu, uint64_t gpa, uint64_t len, uint64_t exi=
t_flags)
> > > +{
> > > +     if (!(vcpu->kvm->memfault_exit_reasons & exit_flags))
> > > +             return -EFAULT;
> > > +     vcpu->run->exit_reason =3D KVM_EXIT_MEMORY_FAULT;
> > > +     vcpu->run->memory_fault.gpa =3D gpa;
> > > +     vcpu->run->memory_fault.len =3D len;
> > > +     vcpu->run->memory_fault.flags =3D exit_flags;
> > > +     return -1;
> >
> > Why -1? 0? Anyway enum exit_fastpath_completion is x86 kvm mmu internal
> > convention. As WIP, it's okay for now, though.
>=20
> The -1 isn't to indicate a failure in this function itself, but to
> allow callers to substitute this for "return -EFAULT." A return code
> of zero would mask errors and cause KVM to proceed in ways that it
> shouldn't. For instance, "setup_vmgexit_scratch" uses it like this
>=20
> if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, len)) {
>     ...
> -  return -EFAULT;
> + return kvm_memfault_exit_or_efault(...);
> }
>=20
> and looking at one of its callers (sev_handle_vmgexit) shows how a
> return code of zero would cause a different control flow
>=20
> case SVM_VMGEXIT_MMIO_READ:
> ret =3D setup_vmgexit_scratch(svm, true, control->exit_info_2);
> if (ret)
>     break;
>=20
> ret =3D ret =3D kvm_sev_es_mmio_read(vcpu,

Hmm, I generally agree with Isaku, the helper should really return 0.  Retu=
rning
-1 might work, but it'll likely confuse userspace, and will definitely conf=
use
KVM developers.

The "0 means exit to userspace" behavior is definitely a pain though, and i=
s likely
going to make this all extremely fragile.

I wonder if we can get away with returning -EFAULT, but still filling vcpu-=
>run
with KVM_EXIT_MEMORY_FAULT and all the other metadata.  That would likely s=
implify
the implementation greatly, and would let KVM fill vcpu->run unconditonally=
.  KVM
would still need a capability to advertise support to userspace, but usersp=
ace
wouldn't need to opt in.  I think this may have been my very original thoug=
h, and
I just never actually wrote it down...
