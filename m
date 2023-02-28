Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE9E6A5B04
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 15:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjB1OqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 09:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjB1OqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 09:46:00 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC15E30194;
        Tue, 28 Feb 2023 06:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677595556; x=1709131556;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aLzCtKhI01As4ruXBrYfk3b+I8TTpHSQmuOY0vKHQL0=;
  b=D6XzpNlUj5eamXpcp9LFNThT7XgXbbrTly5/SSvY5UVHdB6ieqI9Two5
   PUdCpsMqMlC6xGM6SWxio+O80Pfn8odkEcnPtQBVrwUM/FTcvDp9+GIEk
   TbTWF1LF5Hpyx7XuOyCYQ1kTxF0WJcESVjKjwlL1sZIZAj1zQf20f5pcn
   ohKbOmaiKrOY0xguwDlC7e5f5rsJMxD+tExxVzpK10aj8vHxa7M82kO/Z
   XQ+2XUdcSBZnh/lyktJvnU5MwS3+U0pbwSr43MbsrKSm/X9MaZ0gW88bt
   5ww7BPRCLvtZtHjNivArVCHxzjsmIwf/OPuHmPeNnJzalh+I8Iy4ai4Pu
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="396717295"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="396717295"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 06:45:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="706583429"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="706583429"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga001.jf.intel.com with ESMTP; 28 Feb 2023 06:45:43 -0800
Message-ID: <425d56ca2a2c9eb3a0bd4019706aee6db5dd8fc6.camel@linux.intel.com>
Subject: Re: [PATCH 2/2] Documentation/process: Add a maintainer handbook
 for KVM x86
From:   Robert Hoo <robert.hu@linux.intel.com>
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
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Michal Luczaj <mhal@rbox.co>,
        Mingwei Zhang <mizhang@google.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Paul Durrant <pdurrant@amazon.com>,
        Peng Hao <flyingpenghao@gmail.com>,
        Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
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
Date:   Tue, 28 Feb 2023 22:45:42 +0800
In-Reply-To: <20230217225449.811957-3-seanjc@google.com>
References: <20230217225449.811957-1-seanjc@google.com>
         <20230217225449.811957-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-02-17 at 14:54 -0800, Sean Christopherson wrote:
> +Branches
> +~~~~~~~~
> +The KVM x86 tree is organized into multiple topic branches.  The
> purpose of
> +using finer-grained topic branches is to make it easier to keep tabs
> on an area
> +of development, and to limit the collateral damage of human errors
> and/or buggy
> +commits, e.g. dropping the HEAD commit of a topic branch has no
> impact on other
> +in-flight commits' SHA1 hashes, and having to reject a pull request
> due to bugs
> +delays only that topic branch.
> +
> +All topic branches, except for ``next`` and ``fixes``

What's this "fixes" branch for?
If fixes for current cycle, will apply to main KVM tree; if fixes for
next cycle, why not directly to its topic branch or next branch (kvm-
x86 tree)?
I see in main KVM tree, its "fixes" branch is very inactive.
Too many functional branches will add your maintenance burden.

> , are rolled into ``next``
> +via a cthulu merge on an as-needed basis, i.e. when a topic branch
> is updated.
> +As a result, force pushes to ``next`` are common.
> +
> +Lifecycle
> +~~~~~~~~~
> +Pull requests for the next release cycle are sent to the main KVM
> tree, one
> +for each KVM x86 topic branch. 

Will each KVM x86 topic branch has a mapping topic branch in main KVM
tree? I mean where is their pull target(s), next branch in main KVM
tree? or their counterpart branches in main KVM tree?

>  If all goes well, the topic branches are rolled
> +into the main KVM pull request sent during Linus' merge
> window.  Pull requests
> +for KVM x86 branches are typically made the week before Linus'
> opening of the
> +merge window, e.g. the week following rc7 for "normal" releases.
> +
> +The KVM x86 tree doesn't have its own official merge window, but
> there's a soft
> +close around rc5 for new features, and a soft close around rc6 for
> fixes.
> +
> 
> +Comments
> +~~~~~~~~
> +Write comments using imperative mood and avoid pronouns.  Use
> comments to
> +provide a high level overview of the code, and/or to explain why the
> code does
> +what it does.  Do not reiterate what the code literally does; let
> the code
> +speak for itself.  If the code itself is inscrutable, comments will
> not help.

Welcome comments that state preconditions for calling this function?
e.g. some lock held.

> +
> +SDM and APM References
> +~~~~~~~~~~~~~~~~~~~~~~
> +Much of KVM's code base is directly tied to architectural behavior
> defined in
> +Intel's Software Development Manual (SDM) and AMD's Architecture
> Programmer’s
> +Manual (APM).  Use of "Intel's SDM" and "AMD's APM", or even just
> "SDM" or
> +"APM", without additional context is a-ok.
> +
> +Do not reference specific sections, tables, figures, etc. by number,
> especially
> +not in comments.  Instead, copy-paste the relevant snippet (if
> warranted), and
> +reference sections/tables/figures by name.  The layouts of the SDM
> and APM are
> +constantly changing, and so the numbers/labels aren't
> stable/consistent.

Ack

