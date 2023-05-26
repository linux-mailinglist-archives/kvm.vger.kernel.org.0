Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F631711E0A
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 04:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbjEZCgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 22:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233071AbjEZCgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 22:36:20 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD380BC;
        Thu, 25 May 2023 19:36:18 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1001)
        id 1932320FBE98; Thu, 25 May 2023 19:36:18 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1932320FBE98
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1685068578;
        bh=QsI2Tqrh7Dq8rATEw0dJAIe6Y8MEWIZaKj+0i4m1b94=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=rc/phama1ktXAiy+vs2NVCSXABwbcfYCYzvoNhWo6b4QznrBTZJyht2XFXGcOWpXT
         eN3vRQ77IyNVtRNsEt3dUwkwOKfWmDDqOGFtsKRkzHP0DTyYh3PuCH9zyVE+5kTU93
         rssQ3lVi3y4biGwhIuiBnmIaxdqEKLD8WYOLFyno=
Received: from localhost (localhost [127.0.0.1])
        by linux.microsoft.com (Postfix) with ESMTP id 1639D30013A9;
        Thu, 25 May 2023 19:36:18 -0700 (PDT)
Date:   Thu, 25 May 2023 19:36:18 -0700 (PDT)
From:   James Morris <jamorris@linux.microsoft.com>
To:     =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Alexander Graf <graf@amazon.com>,
        Forrest Yuan Yu <yuanyu@google.com>,
        John Andersen <john.s.andersen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?Q?Mihai_Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?Q?Nicu=C8=99or_C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Thara Gopinath <tgopinath@microsoft.com>,
        Will Deacon <will@kernel.org>,
        Zahra Tarkhani <ztarkhani@microsoft.com>,
        =?UTF-8?Q?=C8=98tefan_=C8=98icleru?= <ssicleru@bitdefender.com>,
        dev@lists.cloudhypervisor.org, kvm@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [RFC PATCH v1 0/9] Hypervisor-Enforced Kernel Integrity
In-Reply-To: <20230505152046.6575-1-mic@digikod.net>
Message-ID: <17f62cb1-a5de-2020-2041-359b8e96b8c0@linux.microsoft.com>
References: <20230505152046.6575-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Side topic]

Would folks be interested in a Linux Plumbers Conference MC on this 
topic generally, across different hypervisors, VMMs, and architectures?

If so, please let me know who the key folk would be and we can try writing 
up an MC proposal.



-- 
James Morris
<jamorris@linux.microsoft.com>
