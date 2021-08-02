Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E783DDE6B
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 19:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhHBRXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 13:23:43 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:53105 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231410AbhHBRXl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 13:23:41 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id DAA211AC0477;
        Mon,  2 Aug 2021 13:23:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 02 Aug 2021 13:23:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=paabWa
        2xNdONg8O+31P0jix5EoZeeaUaNV4cT5H6DrY=; b=i3TYK1HvKYcBRaXbIouOl4
        jMxIGABlgkRMpecFi2JNSCHZRywYXGtK3ACOwxV0MIgZTZnhfNsb0t7x9XCdUcas
        U+IlbDOT6y7yeuV5emHyXejgcYjY0e7057toPQVcWg22YWQ+o0+qyb+YPMnE4sQk
        EM5TaJDnLhXcrsXYmLvvUSWSdxoj2IQ0d6e10AVoaOigwzQ3gCKOqNfNEHnr0cjm
        iLGXxx0gv5f6g7oUkSvaVos1XIgBCXo4k/E1UQqqv+X9iqm5y9NoWJnM5VsmEc9b
        1TfsaA94dI9GTpJoNEn1AbNSiaVaJMqUQGCewyh+hWrSDBR+omgq4YXm5mLWnlZQ
        ==
X-ME-Sender: <xms:CCoIYd3i8ycbqRBwXW6_B9z-lZiDVZElgx5nKvCSWzIAU_eQ_nWj0g>
    <xme:CCoIYUFCXDKAhQJfiz01ps2qiJyONbeJFc0Plwx8Hz9Qi3Tv7LBiqb0j0ZSO4xyMx
    H53PhQ-_3m87k_LwBQ>
X-ME-Received: <xmr:CCoIYd7zGr6AOOj3AJjKMnMKzCII1dCrFNjaRj3ds13gD99j8iLM3BUvdZuC3V3SHjKex-ZcmBfh6rCXtFmfUCNBWQ7juMteEzQE8FL481c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddriedvgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepvffujghfhfffkfggtgesthdtredttddttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtg
    homheqnecuggftrfgrthhtvghrnhepheelfeefudeiudegudelgfetgeetkeelveeuieet
    udelheejkeeileekveeukedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepuggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgtohhm
X-ME-Proxy: <xmx:CCoIYa21HsJurVoPc-6powVv5CwwBXi2FEOrjFcjx-vbN62fanmIOQ>
    <xmx:CCoIYQGNDPy-yqvQMD81Ig9yUi7AAyobCE0u9gbUeyRBJTer2M9wIw>
    <xmx:CCoIYb-L2fOSzQ1mxBbh_XzGw97Www_w2Vm9HSD4U3KcqUn82zAmow>
    <xmx:ECoIYcPUYm4UulqXdBhipUuxnnwAwj2cQb1ZfJlfzr2V8sXAUiEZq_CESGOuSzR3>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Aug 2021 13:23:19 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 6ae5efb3;
        Mon, 2 Aug 2021 17:23:18 +0000 (UTC)
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH v3 2/3] KVM: x86: On emulation failure, convey the exit
 reason, etc. to userspace
In-Reply-To: <YQgkGwGkrleO7I2A@google.com>
References: <20210729133931.1129696-1-david.edmondson@oracle.com>
 <20210729133931.1129696-3-david.edmondson@oracle.com>
 <YQR52JRv8jgj+Dv8@google.com> <cunk0l4mhjc.fsf@oracle.com>
 <YQgkGwGkrleO7I2A@google.com>
From:   David Edmondson <david.edmondson@oracle.com>
Date:   Mon, 02 Aug 2021 18:23:17 +0100
Message-ID: <cunbl6fn4l6.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday, 2021-08-02 at 16:58:03 GMT, Sean Christopherson wrote:

> On Mon, Aug 02, 2021, David Edmondson wrote:
>> On Friday, 2021-07-30 at 22:14:48 GMT, Sean Christopherson wrote:
>> 
>> > On Thu, Jul 29, 2021, David Edmondson wrote:
>> >> +		__u64 exit_info1;
>> >> +		__u64 exit_info2;
>> >> +		__u32 intr_info;
>> >> +		__u32 error_code;
>> >> +	} exit_reason;
>> >
>> > Oooh, you're dumping all the fields in kvm_run.  That took me forever to realize
>> > because the struct is named "exit_reason".  Unless there's a naming conflict,
>> > 'data' would be the simplest, and if that's already taken, maybe 'info'?
>> >
>> > I'm also not sure an anonymous struct is going to be the easiest to maintain.
>> > I do like that the fields all have names, but on the other hand the data should
>> > be padded so that each field is in its own data[] entry when dumped to userspace.
>> > IMO, the padding complexity isn't worth the naming niceness since this code
>> > doesn't actually care about what each field contains.
>> 
>> Given that this is avowedly not an ABI and that we are expecting any
>> (human) consumer to be intimate with the implementation to make sense of
>> it, is there really any requirement or need for padding?
>
> My thought with the padding was to force each field into its own data[] entry.
> E.g. if userspace does something like
>
> 	for (i = 0; i < ndata; i++)
> 		printf("\tdata[%d] = 0x%llx\n", i, data[i]);
>
> then padding will yield
>
> 	data[0] = flags
> 	data[1] = exit_reason
> 	data[2] = exit_info1
> 	data[3] = exit_info2
> 	data[4] = intr_info
> 	data[5] = error_code
>
> versus
>
> 	data[0] = <flags>
> 	data[1] = (exit_info1 << 32) | exit_reason
> 	data[2] = (exit_info2 << 32) | (exit_info1 >> 32)
> 	data[3] = (intr_info << 32) | (exit_info2 >> 32)
> 	data[4] = error_code
>
> Changing exit_reason to a u64 would clean up the worst of the mangling, but until
> there's actually a 64-bit exit reason to dump, that's just a more subtle way to
> pad the data.

Unnecessarily extending exit_reason to u64 would be bad, I agree.

>> In your example below (most of which I'm fine with), the padding has the
>> effect of wasting space that could be used for another u64 of debug
>> data.
>
> Yes, but because it's not ABI, we can change it in the future if we get to the
> point where we want to dump more info and don't have space.  Until that time, I
> think it makes sense to prioritize readability with an ignorant (of the format)
> userspace over memory footprint.

This seems reasonable.

>> > 	/*
>> > 	 * There's currently space for 13 entries, but 5 are used for the exit
>> > 	 * reason and info.  Restrict to 4 to reduce the maintenance burden
>> > 	 * when expanding kvm_run.emulation_failure in the future.
>> > 	 */
>> > 	if (WARN_ON_ONCE(ndata > 4))
>> > 		ndata = 4;
>> >
>> > 	if (insn_size) {
>> > 		ndata_start = 3;
>> > 		run->emulation_failure.flags =
>> > 			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
>> > 		run->emulation_failure.insn_size = insn_size;
>> > 		memset(run->emulation_failure.insn_bytes, 0x90,
>> > 		       sizeof(run->emulation_failure.insn_bytes));
>> > 		memcpy(run->emulation_failure.insn_bytes, insn_bytes, insn_size);
>> > 	} else {
>> > 		/* Always include the flags as a 'data' entry. */
>> > 		ndata_start = 1;
>> > 		run->emulation_failure.flags = 0;
>> > 	}
>> 
>> When we add another flag (presuming that we do, because if not there was
>> not much point in the flags) this will have to be restructured again. Is
>> there an objection to the original style? (prime ndata=1, flags=0, OR in
>> flags and adjust ndata as we go.)
>
> No objection, though if you OR in flags then you should truly _adjust_ ndata, not
> set it, e.g.

My understanding of Aaron's intent is that this would not be the
case.

That is, if we add another flag with payload and set that flag, we would
still have space for the instruction stream in data[] even if
KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is not set.

Given that, we must *set* ndata each time we add in a flag, with the
value being the extent of data[] used by the payload corresponding to
that flag, and the flags must be considered in ascending order (or we
remember a "max" along the way).

Dumping the arbitray debug data after the defined fields would require
adjusting ndata, of course.

If this is not the case, and the flag indicated payloads are packed at
the head of data[], then the current structure definition is misleading
and we should perhaps revise it.

>         /* Always include the flags as a 'data' entry. */
>         ndata_start = 1;
>         run->emulation_failure.flags = 0;
>
>         if (insn_size) {
>                 ndata_start += 2;  <----------------------- Adjust, not override
>                 run->emulation_failure.flags |=
>                         KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
>                 run->emulation_failure.insn_size = insn_size;
>                 memset(run->emulation_failure.insn_bytes, 0x90,
>                        sizeof(run->emulation_failure.insn_bytes));
>                 memcpy(run->emulation_failure.insn_bytes, insn_bytes, insn_size);
>         }
>
>> > 	memcpy(&run->internal.data[ndata_start], info, ARRAY_SIZE(info));
>> > 	memcpy(&run->internal.data[ndata_start + ARRAY_SIZE(info)], data, ndata);
>> > }
