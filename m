Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE216D6E2F
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 22:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbjDDUkx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 16:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236168AbjDDUkv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 16:40:51 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2AD49F9
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 13:40:46 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id q8so16493945uas.7
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 13:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680640845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X0YHahKX6Ti1tIBc3jsDKlYnwMrCgQ2U6OVAAr9gJkQ=;
        b=RbeHh+aDBr6GBjxqIzFc4vCnObwnXoXmQahjcWW3Mc8Ko9t5tkG+go3f+/tpr5YgvC
         VOBjCukTh0ewWeN0d7xXva/KdbJ7QFKYP9CSiySjNmjac3FgTYS4xIBs2tORvz1OWVbs
         e80NxE0d+49PRIi8/v08srjSGqOfnZyQT2N/fLsmZhTCqVzUjmxb6/1eakw1n7H2sGT9
         2ySBCnDQbgZmaZm6BSKmtBYDUWucKKfHraN3DQ6MzwNthlCmbhbItI6eP0Pkll/EOuWd
         BTkMfci1J/474hyIfXj7iPVHlw2Zi3CTW+ly3qEdwMKO+5iQBO8207pIBujqKEG6YhLd
         zRLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680640845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X0YHahKX6Ti1tIBc3jsDKlYnwMrCgQ2U6OVAAr9gJkQ=;
        b=M3dVS52RFWwLu+ptl5fwHFFRbIYcQZG8WBPzaC5exp+eNUtesW+J/wiTQhTJ4xNnc3
         1DjtfL3lYR4KQt/B0wiS4GIbKjkxPsn1B+vAqpaEDqEBPN4qYD5mtQ1+WqcLSp1AqbPy
         xcGGCfsjtJv0uj+uez+P6se7XlF6alBz6N1YVaysz9sZQl5AP9mPwHdDLejYs+OEg88D
         loCTLbTtA6B5Uo8oMQo4O02wWdSE0Soqd0zKxaPeNvbtaawYH3ECd8qoEi2PioUspm6m
         hK6gN4LhBMQpsDEmrBsWSLgS2sAkbHl3Kd2RzzxjYGNoxVizgMtFpT2CNiapEYOVpT/b
         rQ9w==
X-Gm-Message-State: AAQBX9ffTXVNqwT8w9NslAVsTNN1ZQyD1SAW6wLvsbhXio2BqNqvwYPw
        3/9aS1P4xjwq9T0wURWOsBNbfkzq5Ojzi0h5eAhA5g==
X-Google-Smtp-Source: AKy350ax2Shl4uT5kvkrYUUQ14xwaYjEbFbeZwtpAXbNBK7A3K+NnBKnHkwaA7SHkCvGgyrEScGbMIm6PEM8fqjOpr0=
X-Received: by 2002:ac5:cca6:0:b0:43b:da40:a2fe with SMTP id
 p6-20020ac5cca6000000b0043bda40a2femr1777898vkm.15.1680640845664; Tue, 04 Apr
 2023 13:40:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230317000226.GA408922@ls.amr.corp.intel.com>
 <CAF7b7mrTa735kDaEsJQSHTt7gpWy_QZEtsgsnKoe6c21s0jDVw@mail.gmail.com>
 <ZBTgnjXJvR8jtc4i@google.com> <CAF7b7mqnvLe8tw_6-cW1b2Bk8YB9qP=7BsOOJK3q-tAyDkarww@mail.gmail.com>
 <ZBiBkwIF4YHnphPp@google.com> <CAF7b7mrVQ6zP6SLHm4QBfQLgaxQuMtxjhqU5YKjjKGkoND4MLw@mail.gmail.com>
 <ZBnLaidtZEM20jMp@google.com> <CAF7b7mof8HkcaSthEO8Wu9kf8ZHjE9c1TDzQGAYDYv7FN9+k9w@mail.gmail.com>
 <ZBoIzo8FGxSyUJ2I@google.com> <CAF7b7moV9=w4zJhSD2XZrnZTQAP3QeO1rvyT0dMWDhYj0PDcEA@mail.gmail.com>
 <ZCx74RGh1/nnix6U@google.com>
In-Reply-To: <ZCx74RGh1/nnix6U@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Tue, 4 Apr 2023 13:40:09 -0700
Message-ID: <CAF7b7mpbeK24ECkL4RWG3S6piYQQTEqLFMKYTFz9g4tcjVdZVw@mail.gmail.com>
Subject: Re: [WIP Patch v2 04/14] KVM: x86: Add KVM_CAP_X86_MEMORY_FAULT_EXIT
 and associated kvm_run field
To:     Sean Christopherson <seanjc@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, jthoughton@google.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 4, 2023 at 12:35=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> > Let's say that some function (converted to annotate its EFAULTs) fills
> > in kvm_run.memory_fault, but the EFAULT is suppressed from being
> > returned from kvm_run. What if, later within the same kvm_run call,
> > some other function (which we've completely overlooked) EFAULTs and
> > that return value actually does make it out to kvm_run? Userspace
> > would get stale information, which could be catastrophic.
>
> "catastrophic" is a bit hyperbolic.  Yes, it would be bad, but at _worst_=
 userspace
> will kill the VM, which is the status quo today.

Well what I'm saying is that in these cases userspace *wouldn't know*
that kvm_run.memory_fault contains incorrect information for the
-EFAULT it actually got (do you disagree?), which could presumably
cause it to do bad things like "resolve" faults on incorrect pages
and/or infinite-loop on KVM_RUN, etc.

Annotating the efault information as valid only from the call sites
which return directly to userspace prevents this class of problem, at
the cost of allowing un-annotated EFAULTs to make it to userspace. But
to me, paying that cost to make sure the EFAULT information is always
correct seems by far preferable to not paying it and allowing
userspace to get silently incorrect information.

> > Actually even performing the annotations only in functions that
> > currently always bubble EFAULTs to userspace still seems brittle: if
> > new callers are ever added which don't bubble the EFAULTs, then we end
> > up in the same situation.
>
> Because of KVM's semi-magical '1 =3D=3D resume, -errno/0 =3D=3D exit' "de=
sign", that's
> true for literally every exit to userspace in KVM and every VM-Exit handl=
er.
> E.g. see commit 2368048bf5c2 ("KVM: x86: Signal #GP, not -EPERM, on bad
> WRMSR(MCi_CTL/STATUS)"), where KVM returned '-1' instead of '1' when reje=
cting
> MSR accesses and inadvertantly killed the VM.  A similar bug would be if =
KVM
> returned EFAULT instead of -EFAULT, in which case vcpu_run() would resume=
 the
> guest instead of exiting to userspace and likely put the vCPU into an inf=
inite
> loop.

Right, good point.
