Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1E73DD120
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 09:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhHBH3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 03:29:11 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:50081 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231649AbhHBH3K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 03:29:10 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 157BF1AC0113;
        Mon,  2 Aug 2021 03:29:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 02 Aug 2021 03:29:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0m9FBh
        beBZo8/qQDkQ1JphIjEPhFPxp1hGYk9kyWEVA=; b=jp6QSetEkC7nb2ikHmEuZc
        yfaGPjEUb+17jSLLa/yCE494veY6qma45Oj7kIuRYg48Zhg3baBBy+vq0H3EesMv
        bpwYkuS8pwJ2RIpj/FmShua48fhsSXwAWzvv1J0G7GOmKsV8aC/eMW52oTwBiAcV
        3wg3MElYihz8DxR5hQDvlJCQY9wBfjv2hQSCE7EVuH9q/J/jwdJiCVuEzJ/b5DBF
        vSUACY6lR878WJzZgtk4smxymLckklorsHqt4h1edJKrrSHxbWMoAtH5x0oMBdRk
        HF88Yh6ZTPB6vKdlVfNU9vI7EjTEm3L8xSDrtvbVuaUUMysCNtVLwyqKdEVChUVQ
        ==
X-ME-Sender: <xms:up4HYXv2wb6dBdd0Hgqb9P1IvEeByeqk_05RIQq9Z6ZbLeIsYGyb6A>
    <xme:up4HYYeQYqcbiTEAxZZzYcs61mn-KWTYYImm2g8fsOcCyLiJ9A_N6tC_z79WYxPbC
    ynW5Fp0E0QN-5phgZo>
X-ME-Received: <xmr:up4HYawrpRg2V3mu6PI69puM3bu5LS6mPyg7vr-ViZ50EHA0CKhmbEU4zMOQxMi8ELnizM0vzqkEBILbDQ5Ar571WexITcGBhySU1Itt7Uo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddriedugddutddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepvffujghfhfffkfggtgesthdtredttddttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtg
    homheqnecuggftrfgrthhtvghrnhepheelfeefudeiudegudelgfetgeetkeelveeuieet
    udelheejkeeileekveeukedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepuggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgtohhm
X-ME-Proxy: <xmx:up4HYWOMA5MWXha5-RcXpChFakLWQDaUxc9LJw5vxVWlmjqJ9jrYpw>
    <xmx:up4HYX98K0oTTCa0mZsauQfmf5Qbu59lXdeFaup7FB1dPpVGM8bt0Q>
    <xmx:up4HYWW4WA4eyUWOoEkLUNRrpjvJQC-aMNbb50Ds1hrHh3TCI6Waeg>
    <xmx:u54HYRmvm8eydQwz_hF25zxgf7YBl2D7ajML6OOrDrE2aaNKe6NZpmpNJKMANNzU>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Aug 2021 03:28:57 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 089f93a2;
        Mon, 2 Aug 2021 07:28:56 +0000 (UTC)
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
In-Reply-To: <YQR52JRv8jgj+Dv8@google.com>
References: <20210729133931.1129696-1-david.edmondson@oracle.com>
 <20210729133931.1129696-3-david.edmondson@oracle.com>
 <YQR52JRv8jgj+Dv8@google.com>
From:   David Edmondson <david.edmondson@oracle.com>
Date:   Mon, 02 Aug 2021 08:28:55 +0100
Message-ID: <cunk0l4mhjc.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday, 2021-07-30 at 22:14:48 GMT, Sean Christopherson wrote:

> On Thu, Jul 29, 2021, David Edmondson wrote:
>> Should instruction emulation fail, include the VM exit reason, etc. in
>> the emulation_failure data passed to userspace, in order that the VMM
>> can report it as a debugging aid when describing the failure.
>> 
>> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  5 ++++
>>  arch/x86/kvm/vmx/vmx.c          |  5 +---
>>  arch/x86/kvm/x86.c              | 53 ++++++++++++++++++++++++++-------
>>  include/uapi/linux/kvm.h        |  7 +++++
>>  4 files changed, 56 insertions(+), 14 deletions(-)
>> 
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index dfb902930cdc..17da43c1aa67 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1630,6 +1630,11 @@ extern u64 kvm_mce_cap_supported;
>>  int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
>>  int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
>>  					void *insn, int insn_len);
>> +void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu,
>> +					bool instruction_bytes,
>> +					void *data, unsigned int ndata);
>> +void kvm_prepare_emulation_failure_exit_with_reason(struct kvm_vcpu *vcpu,
>> +						    bool instruction_bytes);
>>  
>>  void kvm_enable_efer_bits(u64);
>>  bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index fefdecb0ff3d..a8d303c7c099 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5367,10 +5367,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
>>  
>>  		if (vmx->emulation_required && !vmx->rmode.vm86_active &&
>>  		    vcpu->arch.exception.pending) {
>> -			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> -			vcpu->run->internal.suberror =
>> -						KVM_INTERNAL_ERROR_EMULATION;
>> -			vcpu->run->internal.ndata = 0;
>> +			kvm_prepare_emulation_failure_exit_with_reason(vcpu, false);
>>  			return 0;
>>  		}
>>  
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index a4fd10604f72..a97bacd8922f 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -7456,7 +7456,9 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
>>  }
>>  EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
>>  
>> -static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
>> +void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu,
>> +					bool instruction_bytes,
>> +					void *data, unsigned int ndata)
>
> 'data' should be a 'u64 *', and 'ndata' should be a 'u8' that is actual ndata as
> opposed to the size.

Agreed that this will be better.

> The obvious alternative would be to rename ndata to size, but IMO
> that's unnecessarily complex, it's much easier to force the caller to
> work with u64s.  That also reduces the probablity of KVM mangling
> data[] by dumping unrelated fields into a single data[] entry, or by
> leaving stale chunks (if the incoming data is not a multiple of 8
> bytes).
>
>>  {
>>  	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>>  	u32 insn_size = ctxt->fetch.end - ctxt->fetch.data;
>> @@ -7464,10 +7466,10 @@ static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
>>  
>>  	run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>>  	run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
>> -	run->emulation_failure.ndata = 0;
>> +	run->emulation_failure.ndata = 1; /* Always include the flags. */
>>  	run->emulation_failure.flags = 0;
>>  
>> -	if (insn_size) {
>> +	if (instruction_bytes && insn_size) {
>>  		run->emulation_failure.ndata = 3;
>>  		run->emulation_failure.flags |=
>>  			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
>> @@ -7477,7 +7479,42 @@ static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
>>  		memcpy(run->emulation_failure.insn_bytes,
>>  		       ctxt->fetch.data, insn_size);
>>  	}
>> +
>> +	ndata = min((size_t)ndata, sizeof(run->internal.data) -
>> +		    run->emulation_failure.ndata * sizeof(u64));
>> +	if (ndata) {
>> +		unsigned int offset =
>> +			offsetof(struct kvm_run, emulation_failure.flags) +
>> +			run->emulation_failure.ndata * sizeof(u64);
>> +
>> +		memcpy((void *)run + offset, data, ndata);
>> +		run->emulation_failure.ndata += ndata / sizeof(u64);
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_prepare_emulation_failure_exit);
>
> NAK on exporting this particular helper, it consumes vcpu->arch.emulate_ctxt,
> which ideally wouldn't even be visible to vendor code (stupid SVM erratum).  The
> emulation context will rarely, if ever, be valid if this is called from vendor code.
>
> The SGX call is effectively guarded by instruction_bytes=false, but that's a
> messy approach as the handle_emulation_failure() patch is the _only_ case where
> emulate_ctxt can be valid.

Your changes to address this seem sensible.

>> +void kvm_prepare_emulation_failure_exit_with_reason(struct kvm_vcpu *vcpu,
>> +						    bool instruction_bytes)
>> +{
>> +	struct {
>> +		__u64 exit_reason;
>
> As mentioned in the prior patch, exit_reason is probably best kept to a u32 at
> this time.

Ack.

>> +		__u64 exit_info1;
>> +		__u64 exit_info2;
>> +		__u32 intr_info;
>> +		__u32 error_code;
>> +	} exit_reason;
>
> Oooh, you're dumping all the fields in kvm_run.  That took me forever to realize
> because the struct is named "exit_reason".  Unless there's a naming conflict,
> 'data' would be the simplest, and if that's already taken, maybe 'info'?
>
> I'm also not sure an anonymous struct is going to be the easiest to maintain.
> I do like that the fields all have names, but on the other hand the data should
> be padded so that each field is in its own data[] entry when dumped to userspace.
> IMO, the padding complexity isn't worth the naming niceness since this code
> doesn't actually care about what each field contains.

Given that this is avowedly not an ABI and that we are expecting any
(human) consumer to be intimate with the implementation to make sense of
it, is there really any requirement or need for padding?

In your example below (most of which I'm fine with), the padding has the
effect of wasting space that could be used for another u64 of debug
data.

>> +
>> +	static_call(kvm_x86_get_exit_info)(vcpu,
>> +					   &exit_reason.exit_reason,
>> +					   &exit_reason.exit_info1,
>> +					   &exit_reason.exit_info2,
>> +					   &exit_reason.intr_info,
>> +					   &exit_reason.error_code);
>> +
>> +	kvm_prepare_emulation_failure_exit(vcpu, instruction_bytes,
>> +					   &exit_reason, sizeof(exit_reason));
>
> Retrieiving the exit reason and info should probably be in the inner helper, the
> only case where the info will be stale is the VMX !unrestricted_guest
> handle_invalid_guest_state() path, but even then I think the last VM-Exit info
> would be interesting/relevant.  That should allow for a cleaner API too.

Makes sense, thanks.

> This is what I came up with after a fair bit of massaging.  The get_exit_info()
> call is beyond gross, but I still think I like it more than a struct?  A
> build-time assertion that the struct size is a multiple of 8 would allay my
> concerns over leaking stack state to userspace, so I'm not totally opposed to it.
>
> 	struct {
> 		u32 exit_reason;
> 		u32 pad1;
> 		u64 info1;
> 		u64 info2;
> 		u32 intr_info;
> 		u32 pad2;
> 		u32 error_code;
> 		u32 pad3;
> 	} info;
> 	u64 ninfo = sizeof(info) / sizeof(u64);
>
> 	BUILD_BUG_ON(sizeof(info) % sizeof(u64));
>
> 	/*
> 	 * Zero the whole struct used to retrieve the exit info to ensure the
> 	 * padding does not leak stack data to userspace.
> 	 */
> 	memset(&info, 0, sizeof(info));
>
> 	static_call(kvm_x86_get_exit_info)(vcpu, &info.exit_reason,
> 					   &info.info1, &info.info2,
> 					   &info.intr_info, &info.error_code);
>
>
>
> void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
> 					  u8 ndata);
> void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
>
> static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
> 					   u8 ndata, u8 *insn_bytes, u8 insn_size)
> {
> 	struct kvm_run *run = vcpu->run;
> 	u8 ndata_start;
> 	u64 info[5];
>
> 	/*
> 	 * Zero the whole array used to retrieve the exit info, casting to u32
> 	 * for select entries will leave some chunks uninitialized.
> 	 */
> 	memset(&info, 0, sizeof(info));
>
> 	static_call(kvm_x86_get_exit_info)(vcpu, (u32 *)&info[0], &info[1],
> 					   &info[2], (u32 *)&info[3],
> 					   (u32 *)&info[4]);
>
> 	run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> 	run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
>
> 	/*
> 	 * There's currently space for 13 entries, but 5 are used for the exit
> 	 * reason and info.  Restrict to 4 to reduce the maintenance burden
> 	 * when expanding kvm_run.emulation_failure in the future.
> 	 */
> 	if (WARN_ON_ONCE(ndata > 4))
> 		ndata = 4;
>
> 	if (insn_size) {
> 		ndata_start = 3;
> 		run->emulation_failure.flags =
> 			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
> 		run->emulation_failure.insn_size = insn_size;
> 		memset(run->emulation_failure.insn_bytes, 0x90,
> 		       sizeof(run->emulation_failure.insn_bytes));
> 		memcpy(run->emulation_failure.insn_bytes, insn_bytes, insn_size);
> 	} else {
> 		/* Always include the flags as a 'data' entry. */
> 		ndata_start = 1;
> 		run->emulation_failure.flags = 0;
> 	}

When we add another flag (presuming that we do, because if not there was
not much point in the flags) this will have to be restructured again. Is
there an objection to the original style? (prime ndata=1, flags=0, OR in
flags and adjust ndata as we go.)

> 	memcpy(&run->internal.data[ndata_start], info, ARRAY_SIZE(info));
> 	memcpy(&run->internal.data[ndata_start + ARRAY_SIZE(info)], data, ndata);
> }
>
> static void prepare_emulation_ctxt_failure_exit(struct kvm_vcpu *vcpu)
> {
> 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>
> 	prepare_emulation_failure_exit(vcpu, NULL, 0, ctxt->fetch.data,
> 				       ctxt->fetch.end - ctxt->fetch.data);
> }
>
> void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
> 					  u8 ndata)
> {
> 	prepare_emulation_failure_exit(vcpu, data, ndata, NULL, 0);
> }
> EXPORT_SYMBOL_GPL(__kvm_prepare_emulation_failure_exit);
>
> void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
> {
> 	__kvm_prepare_emulation_failure_exit(vcpu, NULL, 0);
> }
> EXPORT_SYMBOL_GPL(kvm_prepare_emulation_failure_exit);
