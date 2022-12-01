Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0302D63E71A
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 02:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiLABex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 20:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiLABev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 20:34:51 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1721158034;
        Wed, 30 Nov 2022 17:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669858491; x=1701394491;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YopNAk0o4R/Gm+eGMQdhkQKi75mYgT2RAg4YlRHu29c=;
  b=bpOijAC9/nN+0QvL8R9oSxAj3J0jCxQfrlRlqh2OPCAkRn/Bw/TpgyHp
   YyAxBuyMA6nvbKgsiNfuhfSReS2wFSAktO7kled0IayUPFiejOx4x//BO
   XXtfopSO5z581B0dQzbKaV91xtOp9qiBRcZyrPvGqmDAXiwiaG+zM0EjX
   12+A2jmHFc1lmoBqXClZ0fL2DQ2S/Lvb/rpvGmXmhoedHnqjXKkbtCtMM
   xLtOASCxIALXp0N5Q3nAyXRxC97SrEfL5dTw7BGKKHgJ2KArX1ygd5NNs
   y493+4wh7b1IP9V1nDtS4EcTamQhuGi0nM8L8tkvCRu1bSFIZi3gHTYtc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="313186484"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="313186484"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 17:34:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="707875700"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="707875700"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga008.fm.intel.com with ESMTP; 30 Nov 2022 17:34:38 -0800
Message-ID: <ceb3bb1e98a3933c3bf34641d731c69b67d761b4.camel@linux.intel.com>
Subject: Re: [PATCH 32/44] KVM: x86: Unify pr_fmt to use module name for all
 KVM modules
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Date:   Thu, 01 Dec 2022 09:34:37 +0800
In-Reply-To: <Y4fg+MO2DusqMSZO@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
         <20221102231911.3107438-33-seanjc@google.com>
         <ff0e8701d02ee161d064f92c8b742c2cc061bce0.camel@linux.intel.com>
         <Y20r2NR9MaBbOGLn@google.com> <Y4fg+MO2DusqMSZO@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-11-30 at 23:02 +0000, Sean Christopherson wrote:
> On Thu, Nov 10, 2022, Sean Christopherson wrote:
> > On Thu, Nov 10, 2022, Robert Hoo wrote:
> > > After this patch set, still find some printk()s left in
> > > arch/x86/kvm/*,
> > > consider clean all of them up?
> > 
> > Hmm, yeah, I suppose at this point it makes sense to tack on a
> > patch to clean
> > them up.
> 
> Actually, I'm going to pass on this for now.  The series is already
> too big.  I'll
> add this to my todo list for the future.

That's all right, thanks for update.

