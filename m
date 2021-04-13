Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B22335DCE4
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 12:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344060AbhDMKzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 06:55:00 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:55327 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344006AbhDMKx5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 06:53:57 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id BFD401940918;
        Tue, 13 Apr 2021 06:53:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 13 Apr 2021 06:53:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LU2r2V
        aAOHQrDcDegAXkrCbLQ5rLC3ELxpAY5KMD34k=; b=Urrm1paw1rJuxWjNLyJb8B
        8ysGi72VT4VwnBe+cqoWS6UK7J00L53pmGPeN2XXCtFDb52Cc0rONk8VuVbxWaLN
        PkjaavzYRLWkNZPC9evUu9KVszgP7/YPaoOtP4EWbEMTs4+oVsE0v91OD9eo5mkm
        xRSP1kOcaWvNRXkTYBEQsODv3hpSaDhz3h19MqqnpIVhiIt1rdE3pONkczF7YRsT
        amIhg32PhgY8yzngsgihsTYxuPXzh6TEa2bmw2cvyNg5ysPrPwADoM7ykH2OvwaA
        ZufsEKz/Nj+FTY7yD3ZSDkIp5/fYuBERqdoDkJ6oAZ7q5srdqZH4rZJ5Vwcte1pQ
        ==
X-ME-Sender: <xms:LXh1YKav4TO8_USeLg1vL3DkKR1ko3310XjPD319Sl0sW1JDWgX4QA>
    <xme:LXh1YNYJ5QNYRVE7u526JvWRUL4W01w2J2oAUvJUmnK6PljzJ2KpBVZrd0QdOwsGS
    uL_z0ziHxCUd3w8ZOc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekledgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepvffujghfhfffkfggtgesthdtredttddttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtg
    homheqnecuggftrfgrthhtvghrnhepheelfeefudeiudegudelgfetgeetkeelveeuieet
    udelheejkeeileekveeukedtnecukfhppeekuddrudekjedrvdeirddvfeeknecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepuggrvhhiugdrvggu
    mhhonhgushhonhesohhrrggtlhgvrdgtohhm
X-ME-Proxy: <xmx:LXh1YE_MAwxcY7uEKWMQcv0XPS-UdGgGm9OPoo5DYMo7DW2PmRyqAw>
    <xmx:LXh1YMpj5KZrfnqsgJhBJ1FIl1n6_1feVRERAGBxqnM8pDDu6MB-jg>
    <xmx:LXh1YFq9YaeU5nifU2ihFbdsKTM6JKMWbK9DPD3uHhJqCR6Y-Os5YQ>
    <xmx:L3h1YEe10TRBeAFAfCSlt6Bvs7XvKoxXi3AtDBflLj09wvTdmYKvZ2I4CFs>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id EFF4C24005C;
        Tue, 13 Apr 2021 06:53:31 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id a8eaf34e;
        Tue, 13 Apr 2021 10:53:30 +0000 (UTC)
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH 5/6] KVM: SVM: pass a proper reason in
 kvm_emulate_instruction()
In-Reply-To: <YHRvchkUSIeU8tRR@google.com>
References: <20210412130938.68178-1-david.edmondson@oracle.com>
 <20210412130938.68178-6-david.edmondson@oracle.com>
 <YHRvchkUSIeU8tRR@google.com>
X-HGTTG: zarquon
From:   David Edmondson <david.edmondson@oracle.com>
X-Now-Playing: Dido - Life for Rent: Stoned
Date:   Tue, 13 Apr 2021 11:53:30 +0100
Message-ID: <cuno8eisbf9.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday, 2021-04-12 at 16:04:02 GMT, Sean Christopherson wrote:

> +Aaron
>
> On Mon, Apr 12, 2021, David Edmondson wrote:
>> From: Joao Martins <joao.m.martins@oracle.com>
>> 
>> Declare various causes of emulation and use them as appropriate.
>> 
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  6 ++++++
>>  arch/x86/kvm/svm/avic.c         |  3 ++-
>>  arch/x86/kvm/svm/svm.c          | 26 +++++++++++++++-----------
>>  3 files changed, 23 insertions(+), 12 deletions(-)
>> 
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 79e9ca756742..e1284680cbdc 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1535,6 +1535,12 @@ enum {
>>  	EMULREASON_IO_COMPLETE,
>>  	EMULREASON_UD,
>>  	EMULREASON_PF,
>> +	EMULREASON_SVM_NOASSIST,
>> +	EMULREASON_SVM_RSM,
>> +	EMULREASON_SVM_RDPMC,
>> +	EMULREASON_SVM_CR,
>> +	EMULREASON_SVM_DR,
>> +	EMULREASON_SVM_AVIC_UNACCEL,
>
> Passing these to userspace arguably makes them ABI, i.e. they need to go into
> uapi/kvm.h somewhere.  That said, I don't like passing arbitrary values for what
> is effectively the VM-Exit reason.  Why not simply pass the exit reason, assuming
> we do indeed want to dump this info to userspace?

That would suffice, yes.

> What is the intended end usage of this information?  Actual emulation?  Debug?
> Logging?

Debug (which implies logging, given that I want this to happen on
systems that are in service).

> Depending on what you're trying to do with the info, maybe there's a better
> option.  E.g. Aaron is working on a series that includes passing pass the code
> stream (instruction bytes) to userspace on emulation failure, though I'm not
> sure if he's planning on providing the VM-Exit reason.

Having the instruction stream will be good.

Aaron: do you have anything to share now? In what time frame do you
think you might submit patches?

I'm happy to re-work this to make the exit reason available, if that's
the appropriate direction.

dme.
-- 
And you're standing here beside me, I love the passing of time.
