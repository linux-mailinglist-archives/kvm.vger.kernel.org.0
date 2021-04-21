Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECA4366699
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 10:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237547AbhDUIBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 04:01:30 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:39149 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235510AbhDUIB3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 04:01:29 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 59C561941B18;
        Wed, 21 Apr 2021 04:00:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 21 Apr 2021 04:00:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ApckIW
        ymDvQzvvTezAcPTxf3ZjSXC77DU2kd+nWpIG8=; b=MYvjSjcNMF08ITyQ76mFqJ
        nErMOtDKTJMgeqWb6zTemfXcbmkmRj9BFc77A6Q5C+eCMwPLEi76/TgxWZy3YR9h
        NN9X2kBojRiLk13xwbkadlCIxzdCb0qKBww17t+kOX0PXxiqYtIMVMmxVeis9hEz
        gBW1pyh01C47IbH/fVjD7dXAlbthUa9cGF0cOwV8Fm+yNj8Y64MPnwQWAqyyozMn
        gx4mSDDjgyVVNdZBMuet5Iq1+zWylj8ea9ulzDdwYfj4QqGATchgoqkF0L2LvrL5
        naaEAGrrSfslEKx3g/2z5gemZQ4rfrvMDEa26cBdjMo80m+HbyOson5UsIFumoBA
        ==
X-ME-Sender: <xms:t9t_YBuLeAATe16Xv1mwWKJAq211oD8cQ5SC3_v-14d6nXHGkaLJeQ>
    <xme:t9t_YKeYJ28Jopyq1UZAaG0Ue_ROa9qcdOHMYg26Gk3Aeu-nqxULHEcEQJq0U9KG-
    ZomUrfgOXiEKFiFA-E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddtjedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefvufgjfhfhfffkgggtsehttdertddttddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceoughmvgesughmvgdrohhrgheqnecuggftrfgrthhtvghrnh
    ephfekgeeutddvgeffffetheejvdejieetgfefgfffudegffffgeduheegteegleeknecu
    kfhppeekuddrudekjedrvdeirddvfeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepughmvgesughmvgdrohhrgh
X-ME-Proxy: <xmx:t9t_YExhVmpQwRTOnYuNOUiYYERJFhoqRDV-Y44DnH52VnKISakXxw>
    <xmx:t9t_YIMhJcGnCQnZAPjsnoAoLCjLkfOuPHpAVOe6w_K8Df1nlq9NpA>
    <xmx:t9t_YB-78lNNvpPrBgihY237GGIfV0viGbkjZvoaGdPP1mNg25qXjw>
    <xmx:uNt_YMZziFV14UQEiY556jMaEQyEBkKC_Fc_w2Svd8U2BVEHuxsL-w>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4C1FC108005F;
        Wed, 21 Apr 2021 04:00:55 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 0aa263d4;
        Wed, 21 Apr 2021 08:00:54 +0000 (UTC)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] kvm: x86: Allow userspace to handle emulation errors
In-Reply-To: <YH8btp+ilY93fKN0@google.com>
References: <20210416131820.2566571-1-aaronlewis@google.com>
 <cunblaaqwe0.fsf@dme.org>
 <CAAAPnDEEwLRMLZffJSN5W93d5s6EQJuAP58vAVJCo+RZD6ahsA@mail.gmail.com>
 <cunzgxtctgj.fsf@dme.org>
 <CAAAPnDGnY76C-=FppsiL=OFY-ei8kHeJhfK_tNV8of3JHBZ0FA@mail.gmail.com>
 <cunbla8c2y3.fsf@dme.org> <YH8btp+ilY93fKN0@google.com>
X-HGTTG: zarquon
From:   David Edmondson <dme@dme.org>
Date:   Wed, 21 Apr 2021 09:00:54 +0100
Message-ID: <cuno8e82hjd.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday, 2021-04-20 at 18:21:42 GMT, Sean Christopherson wrote:

> On Tue, Apr 20, 2021, David Edmondson wrote:
>> 
>> With what you have now, the ndata field seems unnecessary - I should be
>> able to determine the contents of the rest of the structure based on the
>> flags.
>
> Keeping ndata is necessary if we piggyback KVM_INTERNAL_ERROR_EMULATION,
> otherwise we'll break for VMMs that are not aware of the new format.  E.g. if
> ndata gets stuffed with a large number, KVM could cause a buffer overrun in an
> old VMM.

Agreed.

>> That also suggests to me that using something other than
>> KVM_INTERNAL_ERROR_EMULATION would make sense.
>
> Like Aaron, I'm on the fence as to whether or not a new exit reason is in order.
> On one hand, it would be slightly cleaner.  On the other hand, the existing
> "KVM_INTERNAL_ERROR_EMULATION" really is the best name.  It implies nothing
> about the userspace VMM, only that KVM attempted to emulate an instruction and
> failed.
>
> The other motivation is that KVM can opportunistically start dumping extra info
> for old VMMs, though this patch does not do that; feedback imminent. :-)

It's nothing more than that the interface ends up feeling a little
strange. With several flags added and some of the earlier flags unused,
ndata ends up indicating the largest extent of the flag-indicated data,
but the earlier elements of the structure are unused. Hence the question
about how many flags we anticipate using simultaneously.

(I'm not really arguing that we should be packing the stuff in and
having to decode it, as that is also unpleasant.)

>> This comment:
>> 
>> >> >> > + * When using the suberror KVM_INTERNAL_ERROR_EMULATION, these flags are used
>> >> >> > + * to describe what is contained in the exit struct.  The flags are used to
>> >> >> > + * describe it's contents, and the contents should be in ascending numerical
>> >> >> > + * order of the flag values.  For example, if the flag
>> >> >> > + * KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is set, the instruction
>> >> >> > + * length and instruction bytes would be expected to show up first because this
>> >> >> > + * flag has the lowest numerical value (1) of all the other flags.
>> 
>> originally made me think that the flag-indicated elements were going to
>> be packed into the remaining space of the structure at a position
>> depending on which flags are set.
>> 
>> For example, if I add a new flag
>> KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_CODE, value 2, and then want to
>> pass back an exit code but *not* instruction bytes, the comment appears
>> to suggest that the exit code will appear immediately after the flags.
>> 
>> This is contradicted by your other reply:
>> 
>> >> > Just add the fields you need to
>> >> > the end of emulation_failure struct, increase 'ndata' to the new
>> >> > count, add a new flag to 'flags' so we know its contents.
>> 
>> Given this, the ordering of flag values does not seem significant - the
>> structure elements corresponding to a flag value will always be present,
>> just not filled with relevant data.
>
> I think what Aaron is trying to say is that the order in the aliased data[] is
> associated with the lowest _defined_ flag value, not the lowest _set_ flag.
>
> That said, I would just omit the "ascending numerical" stuff entirely, e.g. I
> think for the #defines, this will suffice:
>
> /* Flags that describe what fields in emulation_failure hold valid data  */

Agreed.

> As for not breaking userspace if/when additional fields are added, we can instead
> document the new struct (and drop my snarky comment :-D), e.g.:
>
> 		/*
> 		 * KVM_INTERNAL_ERROR_EMULATION
> 		 *
> 		 * "struct emulation_failure" is an overlay of "struct internal"
> 		 * that is used for the KVM_INTERNAL_ERROR_EMULATION sub-type of
> 		 * KVM_EXIT_INTERNAL_ERROR.  Note, unlike other internal error
> 		 * sub-types, this struct is ABI!  It also needs to be backwards
> 		 * compabile with "struct internal".  Take special care that
> 		 * "ndata" is correct, that new fields are enumerated in "flags",
> 		 * and that each flag enumerates fields that are 64-bit aligned
> 		 * and sized (so that ndata+internal.data[] is valid/accurate).
> 		 */
> 		struct {
> 			__u32 suberror;
> 			__u32 ndata;
> 			__u64 flags;
> 			__u8  insn_size;
> 			__u8  insn_bytes[15];
> 		} emulation_failure;

Looks good (even with the snark).

dme.
-- 
People in love get everything wrong.
