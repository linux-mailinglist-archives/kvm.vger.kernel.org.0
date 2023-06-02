Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBD5720567
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 17:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbjFBPIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 11:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbjFBPIE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 11:08:04 -0400
Received: from smtp-42ae.mail.infomaniak.ch (smtp-42ae.mail.infomaniak.ch [84.16.66.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A391FE51;
        Fri,  2 Jun 2023 08:08:00 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QXmb25PBRzMpvbm;
        Fri,  2 Jun 2023 17:07:58 +0200 (CEST)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QXmZy6vrvzMqFLN;
        Fri,  2 Jun 2023 17:07:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1685718478;
        bh=yJE/Ib8CPqqu+pE7BkHIlxbJFGVwWpFIuzDHb02zjjk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Y/lyrxGPo8c180stzPdCnGebpqaZr7guTmVJQXq4bERYM4B+j1lT37uiVerrU0Av9
         75l0ubCibpTA3YwVLV/e32ZD5+ANNsE4cCxtQCdQgc16z+jTjh0iaoD9qUHXUYS4hO
         bUNLdL5rf9ajSxeyAltPRwLo20RiTIQoinN2+7Mw=
Message-ID: <97aabfe5-7f1a-8865-ab05-bf4af254e1b7@digikod.net>
Date:   Fri, 2 Jun 2023 17:07:54 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [RFC PATCH v1 0/9] Hypervisor-Enforced Kernel Integrity
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc:     "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "marian.c.rotariu@gmail.com" <marian.c.rotariu@gmail.com>,
        Alexander Graf <graf@amazon.com>,
        John S Andersen <john.s.andersen@intel.com>,
        "madvenka@linux.microsoft.com" <madvenka@linux.microsoft.com>,
        "ssicleru@bitdefender.com" <ssicleru@bitdefender.com>,
        "yuanyu@google.com" <yuanyu@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tgopinath@microsoft.com" <tgopinath@microsoft.com>,
        "jamorris@linux.microsoft.com" <jamorris@linux.microsoft.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "will@kernel.org" <will@kernel.org>,
        "dev@lists.cloudhypervisor.org" <dev@lists.cloudhypervisor.org>,
        "mdontu@bitdefender.com" <mdontu@bitdefender.com>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "nicu.citu@icloud.com" <nicu.citu@icloud.com>,
        "ztarkhani@microsoft.com" <ztarkhani@microsoft.com>,
        "x86@kernel.org" <x86@kernel.org>,
        James Gowans <jgowans@amazon.com>
References: <20230505152046.6575-1-mic@digikod.net>
 <93726a7b9498ec66db21c5792079996d5fed5453.camel@intel.com>
 <facfd178-3157-80b4-243b-a5c8dabadbfb@digikod.net>
 <58a803f6-c3de-3362-673f-767767a43f9c@digikod.net>
 <fd1dd8bcc172093ad20243ac1e7bb8fce45b38ef.camel@intel.com>
 <ZHes4a73Zg+6JuFB@google.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <ZHes4a73Zg+6JuFB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 31/05/2023 22:24, Sean Christopherson wrote:
> On Tue, May 30, 2023, Rick P Edgecombe wrote:
>> On Fri, 2023-05-26 at 17:22 +0200, Mickaï¿½l Salaï¿½n wrote:
>>>>> Can the guest kernel ask the host VMM's emulated devices to DMA into
>>>>> the protected data? It should go through the host userspace mappings I
>>>>> think, which don't care about EPT permissions. Or did I miss where you
>>>>> are protecting that another way? There are a lot of easy ways to ask
>>>>> the host to write to guest memory that don't involve the EPT. You
>>>>> probably need to protect the host userspace mappings, and also the
>>>>> places in KVM that kmap a GPA provided by the guest.
>>>>
>>>> Good point, I'll check this confused deputy attack. Extended KVM
>>>> protections should indeed handle all ways to map guests' memory.  I'm
>>>> wondering if current VMMs would gracefully handle such new restrictions
>>>> though.
>>>
>>> I guess the host could map arbitrary data to the guest, so that need to be
>>> handled, but how could the VMM (not the host kernel) bypass/update EPT
>>> initially used for the guest (and potentially later mapped to the host)?
>>
>> Well traditionally both QEMU and KVM accessed guest memory via host
>> mappings instead of the EPT.ï¿½So I'm wondering what is stopping the
>> guest from passing a protected gfn when setting up the DMA, and QEMU
>> being enticed to write to it? The emulator as well would use these host
>> userspace mappings and not consult the EPT IIRC.
>>
>> I think Sean was suggesting host userspace should be more involved in
>> this process, so perhaps it could protect its own alias of the
>> protected memory, for example mprotect() it as read-only.
> 
> Ya, though "suggesting" is really "demanding, unless someone provides super strong
> justification for handling this directly in KVM".  It's basically the same argument
> that led to Linux Security Modules: I'm all for KVM providing the framework and
> plumbing, but I don't want KVM to get involved in defining policy, thread models, etc.

I agree that KVM should not provide its own policy but only the building 
blocks to enforce one. There is two complementary points:
- policy definition by the guest, provided to KVM and the host;
- policy enforcement by KVM and the host.

A potential extension of this framework could be to enable the host to 
define it's own policy for guests, but this would be a different threat 
model.

To avoid too much latency because of the host being involved in policy 
enforcement, I'd like to explore an asynchronous approach that would 
especially fit well for dynamic restrictions.
