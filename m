Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CD33DA4B3
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237837AbhG2Nsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:48:54 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:33165 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237831AbhG2Nsx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 09:48:53 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id A60611AC0113;
        Thu, 29 Jul 2021 09:48:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 29 Jul 2021 09:48:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9QPW2T
        aD5TkdBoSC7awJVUB3Oz/9pHuBCU2Rqw2XRmM=; b=UX5PL0C7EKdRQuy+w/FfN1
        Bgu9VREKmyd4QqYE2mhCz63k7Z7Nld6DHJpjKy1I0Z94U3NlpQts+L4MhXK/oskt
        jcOyiHibEl2xKYk2Kkzp1keMK0qQiWq8skd4R6r2uwp6trW+wQg2Mduso3jLFWlR
        Nz7HqI4TqKDkSRa3xj4k/i3BG9RO57RttgUveqArp3QmP7pRna23+aEviFJqB1Dq
        NDnPKGs7YygNQ41QOxZ1X8KcQngsJXtJEjIMbnxCuAbaqlXe9kYmNcao3l9aZhAZ
        ygJ/TyiLHPeJPmzmY5Zdz2MDCagp1Yb4il5oGO6WDeL5JfKfgCTwE4d1+APUwq8g
        ==
X-ME-Sender: <xms:uLECYQKaAAPIOcNBK7DO0W4TMK1h7hiIoG_hdXwKSl_rAJIQo_A7mg>
    <xme:uLECYQJ7bc_skfmUr8G0NnQ8jnuNTliOMdGZNVxOA4wUZrspQCj4o2gmainu193P9
    lPW9OhfzdGNrj93PLE>
X-ME-Received: <xmr:uLECYQuEWcfJbTIrmKDjsalZaHiGIU6el4Pm5AXi_jrVNNPHzadhtJ5CUYD7ET6SgSl6WbmPav3Fh-E3IgusIOqSigoU1ap08qX35VT6Qgo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrheefgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvufgjfhfhfffkgggtsehttdertddttddtnecuhfhrohhmpeffrghvihguucfg
    ughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgtoh
    hmqeenucggtffrrghtthgvrhhnpeegtdegheevhfegieekfffhledtjedugeehffegvdev
    feffheeliefhkeevfeejfeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepuggrvhhiugdrvggu
    mhhonhgushhonhesohhrrggtlhgvrdgtohhm
X-ME-Proxy: <xmx:uLECYdaGxtYm92wj4W1DtEK31OUdCPpnhVDymZIMm6hZZuqGbcIwcA>
    <xmx:uLECYXZxN-0DfUqhYKGBSe33Mcx__DUUoLfCADD-bpwyjnrkmmScrw>
    <xmx:uLECYZDvOT7HNn0mYPXm_jT8z4lw_Y6F_6QCjHZjJaReJawnYh4PcQ>
    <xmx:wLECYdwVh-qLAgSXrGx4FCGSkfiSwL3lJRMClSuEh3b8TAkhN8mGChuzs47hFOaZ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Jul 2021 09:48:39 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id bb8cfb13;
        Thu, 29 Jul 2021 13:48:38 +0000 (UTC)
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH 2/2] KVM: x86: On emulation failure, convey the exit
 reason to userspace
In-Reply-To: <YOjGdFXXCqDeVlh4@google.com>
References: <20210628173152.2062988-1-david.edmondson@oracle.com>
 <20210628173152.2062988-3-david.edmondson@oracle.com>
 <YNygagjfTIuptxL8@google.com> <m2pmw114w5.fsf@oracle.com>
 <YOjGdFXXCqDeVlh4@google.com>
From:   David Edmondson <david.edmondson@oracle.com>
Date:   Thu, 29 Jul 2021 14:48:38 +0100
Message-ID: <cunmtq5temh.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday, 2021-07-09 at 21:58:12 GMT, Sean Christopherson wrote:

> On Fri, Jul 02, 2021, David Edmondson wrote:
>> On Wednesday, 2021-06-30 at 16:48:42 UTC, David Matlack wrote:
>> 
>> > On Mon, Jun 28, 2021 at 06:31:52PM +0100, David Edmondson wrote:
>> >>  	if (!is_guest_mode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) == 0) {
>> >> -		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> >> -		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
>> >> -		vcpu->run->internal.ndata = 0;
>> >> +		prepare_emulation_failure_exit(
>> >> +			vcpu, KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON);
>> >
>> > Should kvm_task_switch and kvm_handle_memory_failure also be updated
>> > like this?
>> 
>> Will do in v2.
>> 
>> sgx_handle_emulation_failure() seems like an existing user of
>> KVM_INTERNAL_ERROR_EMULATION that doesn't follow the new protocol (use
>> the emulation_failure part of the union).
>> 
>> Sean: If I add another flag for this case, what is the existing
>> user-level consumer?
>
> Doh, the SGX case should have been updated as part of commit c88339d88b0a ("kvm:
> x86: Allow userspace to handle emulation errors").  The easiest fix for SGX would
> be to zero out 'flags', bump ndata, and shift the existing field usage.  That
> would resolve the existing problem of the address being misinterpreted as flags,
> and would play nice _if_ additional flags are added.  I'll send a patch for that.
>
> [...]
>
> Which brings me back to adding another flag when dumping the exit reason.  Unless
> there is a concrete use case for programmatically taking action in reponse to
> failed emulation, e.g. attemping emulation in userspace using insn_bytes+insn_size,
> I think we should not add a flag and instead dump info for debug/triage purposes
> without committing to an ABI.  I.e. define the ABI such that KVM can dump
> arbitrary info in the unused portions of data[].

https://lore.kernel.org/r/20210729133931.1129696-1-david.edmondson@oracle.com
includes both of these suggestions.
