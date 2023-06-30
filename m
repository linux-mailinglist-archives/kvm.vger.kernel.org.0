Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDEB74383C
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 11:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbjF3JX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 05:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjF3JXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 05:23:18 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296A419C;
        Fri, 30 Jun 2023 02:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iTX8DaTvNk5W0MCthv55SgD+0pWkPm2TRQnZZ/JQ/qY=; b=XmROkBf3JCdjF81mNoAr+LIl+f
        Vw8rNxXyhVFIA0bcfCCqDkKp3Al+MOXDa0mh1xa9kPkY5ab+csf2UZDMVn5QeNXvnolMSu7KXZamX
        liALNMxlMn2C5LbM5kDAFUWhYIBVmAef4LIoP1kjEkKtDU2knGS7fXjBFuUqkKkncUp4hZzHaJSz9
        jhw4r3B8HYmhS3zz7YVk0EBMRfidp7WyeP9dAzb36mYOOsr0Lxbf6/FsQgwJai7oPDdjonVeM7Hv7
        YYyJhy0l1q7TWDUSN2nX/2Xt/NOP8giii0QyfQDX6v4keJsJdG9b6/BcmIYd2X+JGtxww/4uDsPOi
        sxo96+iQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qFAKn-007wJ4-0D;
        Fri, 30 Jun 2023 09:22:33 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 51BE7300118;
        Fri, 30 Jun 2023 11:22:32 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 31692245D3645; Fri, 30 Jun 2023 11:22:32 +0200 (CEST)
Date:   Fri, 30 Jun 2023 11:22:32 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "bp@alien8.de" <bp@alien8.de>, "Brown, Len" <len.brown@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230630092232.GB2533791@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230627095012.ln47s62pqzdrnb7x@box.shutemov.name>
 <d6a0fb32ebcdeb6c38ebe8e2b03f034f42360c0f.camel@intel.com>
 <20230627121853.ek5zr7sfiezfkfyj@box.shutemov.name>
 <9361abfa9bf22c2a1a4b25e5495bcccc5b8dcd43.camel@intel.com>
 <7b61715ad35d7b9916f55df72378e02e62c5cc4e.camel@intel.com>
 <20230628133541.GF2438817@hirez.programming.kicks-ass.net>
 <03def8b40a7db14f31d2ad67fb1a201e8ae8bce0.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03def8b40a7db14f31d2ad67fb1a201e8ae8bce0.camel@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 29, 2023 at 12:15:13AM +0000, Huang, Kai wrote:

> > 	Can be called locally or through an IPI function call.
> > 
> 
> Thanks.  As in another reply, if using spinlock is OK, then I think we can say
> it will be called either locally or through an IPI function call.  Otherwise, we
> do via a new separate function tdx_global_init() and no lock is needed in that
> function.  The caller should call it properly.

IPI must use raw_spinlock_t. I'm ok with using raw_spinlock_t if there's
actual need for that, but the code as presented didn't -- in comments or
otherwise -- make it clear why it was as it was.

TDX not specifying time constraints on the various TD/SEAM-CALLs is
ofcourse sad, but alas.
