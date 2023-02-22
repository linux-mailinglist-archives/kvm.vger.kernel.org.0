Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC9069FC1D
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 20:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbjBVT1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 14:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbjBVT1m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 14:27:42 -0500
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA68C2069A;
        Wed, 22 Feb 2023 11:27:39 -0800 (PST)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1pUul5-0004jR-Jj; Wed, 22 Feb 2023 20:26:31 +0100
Message-ID: <2dfae61c-6ac7-7686-ebd1-6ad4448b2bf8@maciej.szmigiero.name>
Date:   Wed, 22 Feb 2023 20:26:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US, pl-PL
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
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
References: <20230217225449.811957-1-seanjc@google.com>
 <20230217225449.811957-3-seanjc@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 2/2] Documentation/process: Add a maintainer handbook for
 KVM x86
In-Reply-To: <20230217225449.811957-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17.02.2023 23:54, Sean Christopherson wrote:
> Add a KVM x86 doc to the subsystem/maintainer handbook section to explain
> how KVM x86 (currently) operates as a sub-subsystem, and to soapbox on
> the rules and expectations for contributing to KVM x86.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   .../process/maintainer-handbooks.rst          |   1 +
>   Documentation/process/maintainer-kvm-x86.rst  | 347 ++++++++++++++++++
>   MAINTAINERS                                   |   1 +
>   3 files changed, 349 insertions(+)
>   create mode 100644 Documentation/process/maintainer-kvm-x86.rst
> 
> diff --git a/Documentation/process/maintainer-handbooks.rst b/Documentation/process/maintainer-handbooks.rst
> index d783060b4cc6..d12cbbe2b7df 100644
> --- a/Documentation/process/maintainer-handbooks.rst
> +++ b/Documentation/process/maintainer-handbooks.rst
> @@ -17,3 +17,4 @@ Contents:
>   
>      maintainer-tip
>      maintainer-netdev
> +   maintainer-kvm-x86
> diff --git a/Documentation/process/maintainer-kvm-x86.rst b/Documentation/process/maintainer-kvm-x86.rst
> new file mode 100644
> index 000000000000..ac81a42a32a3
> --- /dev/null
> +++ b/Documentation/process/maintainer-kvm-x86.rst
(...)
> +
> +Coding Style
> +~~~~~~~~~~~~
> +When it comes to style, naming, patterns, etc., consistency is the number one
> +priority in KVM x86.  If all else fails, match what already exists.
> +
> +With a few caveats listed below, follow the tip tree maintainers' preferred
> +:ref:`maintainer-tip-coding-style`, as patches/series often touch both KVM and
> +non-KVM x86 files, i.e. draw the attention of KVM *and* tip tree maintainers.
> +
> +Using reverse fir tree for variable declarations isn't strictly required,
> +though it is still preferred.

That's the first time I hear about "reverse fir tree" variable order,
no wonder other people were surprised too.

AFAIK the most common variable order seems to be the order in which these
variables actually get first used inside that code block.

> +
> +Except for a handful of special snowflakes, do not use kernel-doc comments for
> +functions.  The vast majority of "public" KVM functions aren't truly public as
> +they are intended only for KVM-internal consumption (there are plans to
> +privatize KVM's headers and exports to enforce this).
> +
> +Comments
> +~~~~~~~~
> +Write comments using imperative mood and avoid pronouns.  Use comments to
> +provide a high level overview of the code, and/or to explain why the code does
> +what it does.  Do not reiterate what the code literally does; let the code
> +speak for itself.  If the code itself is inscrutable, comments will not help.
> +
> +SDM and APM References
> +~~~~~~~~~~~~~~~~~~~~~~
> +Much of KVM's code base is directly tied to architectural behavior defined in
> +Intel's Software Development Manual (SDM) and AMD's Architecture Programmer’s
> +Manual (APM).  Use of "Intel's SDM" and "AMD's APM", or even just "SDM" or
> +"APM", without additional context is a-ok.
> +
> +Do not reference specific sections, tables, figures, etc. by number, especially
> +not in comments.  Instead, copy-paste the relevant snippet (if warranted), and
> +reference sections/tables/figures by name.  

This says do "copy-paste the relevant snippet"...

> The layouts of the SDM and APM are
> +constantly changing, and so the numbers/labels aren't stable/consistent.
> +
> +Generally speaking, do not copy-paste SDM or APM snippets into comments.  

...but this seems to say "don't do that".

More specific guidance would probably help here.

> With
> +few exceptions, KVM *must* honor architectural behavior, therefore it's implied
> +that KVM behavior is emulating SDM and/or APM behavior.
> +
> +Shortlog
> +~~~~~~~~
> +The preferred prefix format is ``KVM: <topic>:``, where ``<topic>`` is one of::
> +
> +  - x86
> +  - x86/mmu
> +  - x86/pmu
> +  - x86/xen
> +  - selftests
> +  - SVM
> +  - nSVM
> +  - VMX
> +  - nVMX
> +
> +**DO NOT use x86/kvm!**  ``x86/kvm`` is used exclusively for Linux-as-a-KVM-guest
> +changes, i.e. for arch/x86/kernel/kvm.c.
> +
> +Note, these don't align with the topics branches (the topic branches care much
> +more about code conflicts).
> +
> +All names are case sensitive!  ``KVM: x86:`` is good, ``kvm: vmx:`` is not.
> +
> +Capitalize the first word of the condensed patch description, but omit ending
> +punctionation.  E.g.::
> +
> +    KVM: x86: Fix a null pointer dererence in function_xyz()
> +
> +not::
> +
> +    kvm: x86: fix a null pointer dererence in function_xyz.
> +
> +If a patch touches multiple topics, traverse up the conceptual tree to find the
> +first common parent (which is often simply ``x86``).  When in doubt,
> +``git log path/to/file`` should provide a reasonable hint.
> +
> +New topics do occasionally pop up, but please start an on-list discussion if
> +you want to propose introducing a new topic, i.e. don't go rogue.
> +
> +Do not use file names or complete file paths as the subject/shortlog prefix.

Do we strictly obey the "75 characters max" rule for the subject/shortlog
or do we prefer to be more flexible here if it results in a more
descriptive patch subject?

(...)
> +Testing
> +-------
> +At a bare minimum, *all* patches in a series must build cleanly for KVM_INTEL=m
> +KVM_AMD=m, and KVM_WERROR=y.  Building every possible combination of Kconfigs
> +isn't feasible, but the more the merrier.  KVM_SMM, KVM_XEN, PROVE_LOCKING, and
> +X86_64 are particularly interesting knobs to turn.
> +
> +Running KVM selftests and KVM-unit-tests is also mandatory (and stating the
> +obvious, the tests need to pass).  

I would add an exception here from mandatory testing for changes that
obviously have negligible probability of affecting runtime behavior.

For example: patches that modify just code comments or documentation.

> When possible and relevant, testing on both
> +Intel and AMD is strongly preferred.  Booting an actual VM is encouraged, but
> +not mandatory.
> +
> +For changes that touch KVM's shadow paging code, running with TDP (EPT/NPT)
> +disabled is mandatory.  For changes that affect common KVM MMU code, running
> +with TDP disabled is strongly encouraged.  For all other changes, if the code
> +being modified depends on and/or interacts with a module param, testing with
> +the relevant settings is mandatory.
> +
> +Note, KVM selftests and KVM-unit-tests do have known failures.  If you suspect
> +a failure is not due to your changes, verify that the *exact same* failure
> +occurs with and without your changes.
> +
> +If you can't fully test a change, e.g. due to lack of hardware, clearly state
> +what level of testing you were able to do, e.g. in the cover letter.
> +
(...)

Thanks for preparing such a detailed handbook Sean.

However, having so many rules might seem intimidating for newcomers, and
deter them from contributing out of fear that they'll be screamed at for
accidentally breaking some obscure rule.

That's especially true for unpaid volunteers that might become
professional kernel developers one day if their learning curve isn't
made too steep.

Maybe have a paragraph or two that, despite all these rules, KVM x86
strives to be a welcome community, encouraging newcomers and understanding
their beginner mistakes (or so)?

Thanks,
Maciej

