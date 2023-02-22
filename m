Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3AB769FDAE
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 22:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbjBVVZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 16:25:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbjBVVZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 16:25:24 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AF143912
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 13:25:22 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5376fa4106eso46757037b3.7
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 13:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VCAEO323b86BbB7XtvnH+rG3EP2w0C3Dqq7NI+H9LE0=;
        b=rzW4oiBSJ63i/anFjhOay2GibzgaSIcPlhs4icaZXWt5tih/osT60UF5e1mwSVULhr
         JA10nXn/Y6ES/XMfobF3rXA0+xT8tqci00AYfMRUEKHVUxG6JbSqI9dpiBOiOKsrLbee
         bYfLIVa2BYR+spMxhwdoUyja2LlL+Mut0U/wnb3uo6zTUNO+QbmpWgddUexwhQjv1HXV
         zoLD7Nt5c/165lbrdfRGyO8N0FXIlW/zx8x2Ec3Omk9D8TqW3ZfghlgsWa2lUSnTeGOM
         9sxnd67n4MCSx7otekA5PPlVXRqMI+iWtlHIKZrBzcfZ3JxTRhsjCjR6AQ6bjByIMLKG
         /Vnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VCAEO323b86BbB7XtvnH+rG3EP2w0C3Dqq7NI+H9LE0=;
        b=icNaL8iGXMCOJLXdrg8JBVONIxmE82DsbSKzcUeOBJJffFyfJIlcH2QfDemDGfWrPi
         bi/BuL8eYO/qNwqnlpI5VFhODOHXLV4F7Sr+31iH9bQAaXl7lcFy1RTR8qCcW9DmCLcd
         lz3jkBCAEiK80LC10syG2YcUBlbsbppJY6J/0qjNSIcdz7jAPSxHg/BJRGBgXGpCp611
         1C1KjNJR+MqSpyVZogg4rp7hIQl+CPk6eW2yf+WrtNP3mt7GrogsD/raONK7BpkbdVjp
         tev3VgIGjWyjBAjPFqy1euO+/pYLOzYhBLK7nKABJbC0ox5MavHjGHDtiauyz9jvyyNa
         Cggw==
X-Gm-Message-State: AO0yUKV8fKpQiIF9b+smtpKdXv+GTxV3597yluJBzObLzMhd8ZTJI+7V
        dTvrGgha3PBs8LbRDFZyQKb/+yhJdKQ=
X-Google-Smtp-Source: AK7set9wDZXbRc6wLa992mDcUcum92VMWfB8kgedycpfygyX7MXQMXDLL4D76H3UAiAg1sC8Z7wuyTwxayc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1028:b0:a27:3ecd:6 with SMTP id
 x8-20020a056902102800b00a273ecd0006mr438895ybt.1.1677101121372; Wed, 22 Feb
 2023 13:25:21 -0800 (PST)
Date:   Wed, 22 Feb 2023 13:25:19 -0800
In-Reply-To: <2dfae61c-6ac7-7686-ebd1-6ad4448b2bf8@maciej.szmigiero.name>
Mime-Version: 1.0
References: <20230217225449.811957-1-seanjc@google.com> <20230217225449.811957-3-seanjc@google.com>
 <2dfae61c-6ac7-7686-ebd1-6ad4448b2bf8@maciej.szmigiero.name>
Message-ID: <Y/aIP4aCxTVOU/ZC@google.com>
Subject: Re: [PATCH 2/2] Documentation/process: Add a maintainer handbook for
 KVM x86
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sagi Shahar <sagis@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Peter Shier <pshier@google.com>,
        Anish Ghulati <aghulati@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Babu Moger <babu.moger@amd.com>, Chao Gao <chao.gao@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Guang Zeng <guang.zeng@intel.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Jing Liu <jing2.liu@intel.com>,
        Junaid Shahid <junaids@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Leonardo Bras <leobras@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Li RongQing <lirongqing@baidu.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Michal Luczaj <mhal@rbox.co>,
        Mingwei Zhang <mizhang@google.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Paul Durrant <pdurrant@amazon.com>,
        Peng Hao <flyingpenghao@gmail.com>,
        Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
        Robert Hoo <robert.hu@linux.intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vipin Sharma <vipinsh@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Wed, Feb 22, 2023, Maciej S. Szmigiero wrote:
> On 17.02.2023 23:54, Sean Christopherson wrote:
> > +SDM and APM References
> > +~~~~~~~~~~~~~~~~~~~~~~
> > +Much of KVM's code base is directly tied to architectural behavior def=
ined in
> > +Intel's Software Development Manual (SDM) and AMD's Architecture Progr=
ammer=E2=80=99s
> > +Manual (APM).  Use of "Intel's SDM" and "AMD's APM", or even just "SDM=
" or
> > +"APM", without additional context is a-ok.
> > +
> > +Do not reference specific sections, tables, figures, etc. by number, e=
specially
> > +not in comments.  Instead, copy-paste the relevant snippet (if warrant=
ed), and
> > +reference sections/tables/figures by name.
>=20
> This says do "copy-paste the relevant snippet"...
>=20
> > The layouts of the SDM and APM are
> > +constantly changing, and so the numbers/labels aren't stable/consisten=
t.
> > +
> > +Generally speaking, do not copy-paste SDM or APM snippets into
> > comments.
>=20
> ...but this seems to say "don't do that".

Yeah, that didn't come out right.

> More specific guidance would probably help here.

Is this better?

  Do not reference specific sections, tables, figures, etc. by number, espe=
cially
  not in comments.  Instead, if necessary (see below), copy-paste the relev=
ant
  snippet and reference sections/tables/figures by name.  The layouts of th=
e SDM
  and APM are constantly changing, and so the numbers/labels aren't stable.
 =20
  Generally speaking, do not explicitly reference or copy-paste from the SD=
M or
  APM in comments.  With few exceptions, KVM *must* honor architectural beh=
avior,
  therefore it's implied that KVM behavior is emulating SDM and/or APM beha=
vior.
  Note, referencing the SDM/APM in changelogs to justify the change and pro=
vide
  context is perfectly ok and encouraged.

> > +If a patch touches multiple topics, traverse up the conceptual tree to=
 find the
> > +first common parent (which is often simply ``x86``).  When in doubt,
> > +``git log path/to/file`` should provide a reasonable hint.
> > +
> > +New topics do occasionally pop up, but please start an on-list discuss=
ion if
> > +you want to propose introducing a new topic, i.e. don't go rogue.
> > +
> > +Do not use file names or complete file paths as the subject/shortlog p=
refix.
>=20
> Do we strictly obey the "75 characters max" rule for the subject/shortlog
> or do we prefer to be more flexible here if it results in a more
> descriptive patch subject?

I prefer to be a little flexible, I'll expand this section to clarify that.

> (...)
> > +Testing
> > +-------
> > +At a bare minimum, *all* patches in a series must build cleanly for KV=
M_INTEL=3Dm
> > +KVM_AMD=3Dm, and KVM_WERROR=3Dy.  Building every possible combination =
of Kconfigs
> > +isn't feasible, but the more the merrier.  KVM_SMM, KVM_XEN, PROVE_LOC=
KING, and
> > +X86_64 are particularly interesting knobs to turn.
> > +
> > +Running KVM selftests and KVM-unit-tests is also mandatory (and statin=
g the
> > +obvious, the tests need to pass).
>=20
> I would add an exception here from mandatory testing for changes that
> obviously have negligible probability of affecting runtime behavior.
>=20
> For example: patches that modify just code comments or documentation.

Agreed, will add.

Regarding documentation, I think I'll also add a requirement of 'make htmld=
ocs'
without warnings for non-trivial docs changes.  It's all too easy to write =
buggy
ReST "code" that looks correct as raw text, e.g. the whole double-colon thi=
ng.

> > When possible and relevant, testing on both
> > +Intel and AMD is strongly preferred.  Booting an actual VM is encourag=
ed, but
> > +not mandatory.
> > +
> > +For changes that touch KVM's shadow paging code, running with TDP (EPT=
/NPT)
> > +disabled is mandatory.  For changes that affect common KVM MMU code, r=
unning
> > +with TDP disabled is strongly encouraged.  For all other changes, if t=
he code
> > +being modified depends on and/or interacts with a module param, testin=
g with
> > +the relevant settings is mandatory.
> > +
> > +Note, KVM selftests and KVM-unit-tests do have known failures.  If you=
 suspect
> > +a failure is not due to your changes, verify that the *exact same* fai=
lure
> > +occurs with and without your changes.
> > +
> > +If you can't fully test a change, e.g. due to lack of hardware, clearl=
y state
> > +what level of testing you were able to do, e.g. in the cover letter.
> > +
> (...)
>=20
> Thanks for preparing such a detailed handbook Sean.
>=20
> However, having so many rules might seem intimidating for newcomers, and
> deter them from contributing out of fear that they'll be screamed at for
> accidentally breaking some obscure rule.
>=20
> That's especially true for unpaid volunteers that might become
> professional kernel developers one day if their learning curve isn't
> made too steep.
>=20
> Maybe have a paragraph or two that, despite all these rules, KVM x86
> strives to be a welcome community, encouraging newcomers and understandin=
g
> their beginner mistakes (or so)?

I like that idea a lot, I'll add a section at the very top.

Thanks much!
