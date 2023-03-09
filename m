Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569F06B2C2E
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 18:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjCIRki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 12:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjCIRkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 12:40:36 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA13EFAAE7
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 09:40:35 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id iw4-20020a170903044400b0019ccafc1fbeso1415923plb.3
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 09:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678383635;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FMpG6QqC6hhrGl7QyTuyVx8ARghXDw/6XzjfUQpd64U=;
        b=D/D3EgchKsiUdj5mlSTQ+Ok6aeaCq1dG8+qQMkOxZ7eugU5DM9o/1dj56peM5nV7xZ
         ux7nQLkAXPYszpdD9hAlgY2/sIyE1k73uNyuLDieL3TReaT8qAD6ImwUAjsHc3myenJR
         FWrMpRB7Nki33S0YJQJQS9DRErPKvxeBK7Em21L+6ixo1rHYbSSdeC0YWoG0beAdfvjU
         00YxqveXzQYkD/Y7wCOyG1SE0sknD4nAiDi3LmwHfGaLj567di27VM7k1l/bVpPCWLGU
         lUeCqLW4qtdoTrruby9k7EFnrOSBUTJrs78mpAwhWcXOoS7eQV82wPungBlgsGdHqSgP
         42Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678383635;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FMpG6QqC6hhrGl7QyTuyVx8ARghXDw/6XzjfUQpd64U=;
        b=Ewv+6G7IrJItevBHPswt563/7kDIQhCGlUAqCKZQpka3bjokIuFDBonhXphBO2IQst
         EpgvZ1b0Lqg3+cScafFiWe0jaGePS5YU+BajJ8bVFYo/BAGA6YeR70zCnyDDtitCX08v
         MQqE/1qqU+V3rwc2LyCkNieMf1dQRBkQWLmnHqx0Erwtj+J9+sTpQe7ECjfsA1ZdSJ5p
         Amv/CiVk9kNdQ98buUin+6xW7KVOTPMl5qZVuAv0llzFZ+DDBQ3nxJcXHioa08BiAOEa
         d2Iq++XulwQkUwWPhwpdWxNn4q1mHZkO+3faTmKr5mNO+QkWbd4ZD/0BDnqtbxsx52QS
         phGg==
X-Gm-Message-State: AO0yUKUs5QuyomgfgjPGQzX90LeZp48sszqT8V+fnfKrn0hoAlzrd+ZY
        RbGGIHlgtqMylxkRrvrXUPA/9tG5lqk=
X-Google-Smtp-Source: AK7set/K8mLaAxGwzT1+biG01J4A21PfKNmxCXL7Ak5krO/ojpRMzIhImPmz2N4awPbZsK6+EPZg9zLX070=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2585:b0:19e:b69e:531b with SMTP id
 jb5-20020a170903258500b0019eb69e531bmr6666236plb.12.1678383635166; Thu, 09
 Mar 2023 09:40:35 -0800 (PST)
Date:   Thu, 9 Mar 2023 09:40:33 -0800
In-Reply-To: <ZAlGeYAmvhPmVmGe@debian.me>
Mime-Version: 1.0
References: <20230309010336.519123-1-seanjc@google.com> <20230309010336.519123-3-seanjc@google.com>
 <ZAlGeYAmvhPmVmGe@debian.me>
Message-ID: <ZAoaEUfr5nnLzZbv@google.com>
Subject: Re: [PATCH v2 2/2] Documentation/process: Add a maintainer handbook
 for KVM x86
From:   Sean Christopherson <seanjc@google.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
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
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
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
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 09, 2023, Bagas Sanjaya wrote:
> On Wed, Mar 08, 2023 at 05:03:36PM -0800, Sean Christopherson wrote:
> > +If a patch touches multiple topics, traverse up the conceptual tree to find the
> > +first common parent (which is often simply ``x86``).  When in doubt,
> > +``git log path/to/file`` should provide a reasonable hint.
> 
> What do you mean by conceptual tree?  Is it Patch subject prefix?

Not really?  I'm struggling to describe it in words.  What I mean is something
like this

                 x86
               /  |  \
             VMX pmu  SVM
            /            \
          nVMX          nSVM

e.g. if a patch touches VMX and SVM, use "x86".  But it's a bit more complex than
that, e.g. a VMX-focused patch that just happens to touch Intel-specific PMU
code should probably be tagged "VMX", not "x86" or "pmu".

Massaging subjects when applying is easy enough, and there will always be some
amount of subjectivity, so unless this is outright confusing (or someone has a
better, succinct, and easy-to-understand description), I'll probably just leave
this section as-is.

> > +KVM selftests that are associated with KVM changes, e.g. regression tests for
> > +bug fixes, should be posted along with the KVM changes as a single series.  The
> > +standard kernel rules for bisection apply, i.e. KVM changes that result in test
> > +failures should be ordered after the selftests updates, and vice versa, new
> > +tests that fail due to KVM bugs should be ordered after the KVM fixes.
> 
> Did you mean that in a patch series, selftest patches are placed after
> their corresponding KVM changes?

No, I meant what I wrote.  If a KVM change will break a test (uncommon, but it
does happen), then the selftest should be patched first so that there are no
unnecessary test failures in the git history.  But when adding a regression test,
the KVM bug fix should come first so that again, there are no unnecessary failures
if someone tests an arbitrary commit, e.g. during bisection.
