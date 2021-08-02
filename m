Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926333DD10F
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 09:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhHBHSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 03:18:34 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:46001 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231649AbhHBHSd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 03:18:33 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 211651AC00CC;
        Mon,  2 Aug 2021 03:18:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 02 Aug 2021 03:18:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=WBgQhr
        7+uwTed/8uhlgXLoHO+0NWliI4QXXIGZ4PZXU=; b=mR12apI/NAdLtGleYVSnlK
        m3YmcjnAWdIvUTs11/BuFxCQALMND+8duWD6j1W4nIhUPkfSQJ6xRVZpenOzZH1s
        y6rYi50/P9xI0uIVKxnp7T+WHZw75jNW6QWwkyX5/gtWTDQbC4wI7RBwOFdutp5a
        HA7R6h55ZlUxeeEPwImvd4HIy3d93G722BxZzurA7gjv06eHRI9QtRCIFxo74qJ1
        5tKuaoHZhzL+4C9phvIaBJmagOuuDYQF1x6pK/0MYxwWCOJ6jNgUo8bQMtnrB9C7
        J5K21h3/v8YSU6IlT6uOCEEUOkJCiplkyIISYkzk3TqIMiZAAR954DG2VjXTum/w
        ==
X-ME-Sender: <xms:OpwHYfN4A86KRf3lxe2wq6PNUIuuuDUpIWxLA0WhSmgpGPL1VKW8sA>
    <xme:OpwHYZ_tHlgBAMFnP_4siH1lC71VRPnCYhEUGnl0qSU5_Zcumh2xmiSOmJ4XdBNFH
    j1zBspoHRKMSQyoMM0>
X-ME-Received: <xmr:OpwHYeRenDbqDtMrQ16zFY5ou0Z2PW3su6wr155xnE1hSOdDarQTkMzQ3SVJvPYWUXJxP-Ibs0OQ2R2jiAmxnIO-H2Xvez1fUXDCk7dNUSg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddriedugdellecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvufgjfhfhfffkgggtsehttdertddttddtnecuhfhrohhmpeffrghvihguucfg
    ughmohhnughsohhnuceoughmvgesughmvgdrohhrgheqnecuggftrfgrthhtvghrnhephf
    ekgeeutddvgeffffetheejvdejieetgfefgfffudegffffgeduheegteegleeknecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepughmvgesughmvg
    drohhrgh
X-ME-Proxy: <xmx:OpwHYTur6DSQsHj5VXa9ko0qBswkNKy8NcRIIBQr8U9pka2sDkbBEA>
    <xmx:OpwHYXeuj9F13p4Vaxtos9eqPJuSjJnRpT5kHgqHjVflh9Tbw8kOtQ>
    <xmx:OpwHYf3Ohtk1NYdwLzTW5FCT4pcE8qHBJhSPzuQx3GiwbYXQ9Wumsg>
    <xmx:O5wHYS2Ty3tixOqXVkMEO8LdP0CS6-UPlcZKjhkikz-sKDgtOg21S5asc-bwGes1>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Aug 2021 03:18:16 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 5a5976c4;
        Mon, 2 Aug 2021 07:18:15 +0000 (UTC)
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v3 3/3] KVM: x86: SGX must obey the
 KVM_INTERNAL_ERROR_EMULATION protocol
In-Reply-To: <YQR6XgkjaGfGhesl@google.com>
References: <20210729133931.1129696-1-david.edmondson@oracle.com>
 <20210729133931.1129696-4-david.edmondson@oracle.com>
 <YQR6XgkjaGfGhesl@google.com>
From:   David Edmondson <dme@dme.org>
Date:   Mon, 02 Aug 2021 08:18:15 +0100
Message-ID: <cunmtq0mi14.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday, 2021-07-30 at 22:17:02 GMT, Sean Christopherson wrote:

> On Thu, Jul 29, 2021, David Edmondson wrote:
>> When passing the failing address and size out to user space, SGX must
>> ensure not to trample on the earlier fields of the emulation_failure
>> sub-union of struct kvm_run.
>> 
>> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
>> ---
>>  arch/x86/kvm/vmx/sgx.c | 8 +++-----
>>  1 file changed, 3 insertions(+), 5 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
>> index 6693ebdc0770..63fb93163383 100644
>> --- a/arch/x86/kvm/vmx/sgx.c
>> +++ b/arch/x86/kvm/vmx/sgx.c
>> @@ -53,11 +53,9 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
>>  static void sgx_handle_emulation_failure(struct kvm_vcpu *vcpu, u64 addr,
>>  					 unsigned int size)
>>  {
>> -	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> -	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
>> -	vcpu->run->internal.ndata = 2;
>> -	vcpu->run->internal.data[0] = addr;
>> -	vcpu->run->internal.data[1] = size;
>> +	uint64_t data[2] = { addr, size };
>> +
>> +	kvm_prepare_emulation_failure_exit(vcpu, false, data, sizeof(data));
>
> Assuming we go with my suggestion to have kvm_prepare_emulation_failure_exit()
> capture the exit reason/info, it's probably worth converting all the
> KVM_EXIT_INTERNAL_ERROR paths in sgx.c, even though the others don't clobber flags.

Okay.
