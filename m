Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D476610679
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 01:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235318AbiJ0Xls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 19:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235132AbiJ0Xlr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 19:41:47 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF2C1126
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 16:41:46 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 192so3330364pfx.5
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 16:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=04eqSMn1z0OEca6B5XINzP5mWOGCwfGPjlEJVIRWKX4=;
        b=oFfYtEVkDvpSAV5ghip/QQgHDwDnFIOp9MDY0lzcJIqJVbyodMMlcSf5+iT/tJg5Do
         TPUNkqu4TUAtobXESizU9LEc3b5P8JqS8ue4QRj/iXoxHK6aIR9T/A+351HWAGeSd/D1
         rSFGudvS9XZpbfZ4VlO6RZOOB3B3IZrofI13ENeMQbAWxUIL9lCOUGkJZOLfDitvpLzB
         wwJagi2x4bqhlXBNMiQabnV87ZAs2vIjcoHWlmY7lpNwaP+4R0D+597+wXReQk9t+6Jc
         53o4iwZJd0qrB8ZVVdzEwe5U3SkHICV0IS4NI0e4UcY4rVyV58qYgULljc78W4uvgmBi
         stNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=04eqSMn1z0OEca6B5XINzP5mWOGCwfGPjlEJVIRWKX4=;
        b=AJTHXtScxODK2noOobyb00tmXnLd6klXihQRHvaddjobCxhsrR+OvUlHZGIRMJEys5
         raZBeTLjWCbgitHUv/LT6+YY/zsscZhw5lpYhsvbrDBlsMy+0DV7t754PvbrXjPR8OhL
         KS0lPgpNzddam+SuPlLjoakK0safFEUZo9Trur+iQZxYEUGS+cKYoYRFAoNy0qodujDM
         MPmR0dgz0+Wo/e/kOBoKjkneQEhXEFrRAtEQ9d1kvDSySVHl+5C23zaCplprrM6Ci/Rn
         VjJnnLA+cDqnfIlxv31a3sTQ1L9ofdzbOd9PpwKejGrO02Bc48XFcipaJmkdlPSJt644
         HY7g==
X-Gm-Message-State: ACrzQf3qTPreznTL6/qo9AGbhqCvC80v/IEKwXD47/STBUPeN7bo+kqv
        8ssNDzh+Tg/9rlpKN05XqmMb4w==
X-Google-Smtp-Source: AMsMyM41niU8KsddBEFG2yimNGYnxhRiKwS8zRzE3B9hzqVmohgEMdoIgi5bV8hxP7Ub3cqNhXVd7A==
X-Received: by 2002:a63:5d0b:0:b0:464:bb2b:9b0e with SMTP id r11-20020a635d0b000000b00464bb2b9b0emr43044321pgb.583.1666914106353;
        Thu, 27 Oct 2022 16:41:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o18-20020a170902d4d200b00176c0e055f8sm1764739plg.64.2022.10.27.16.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 16:41:45 -0700 (PDT)
Date:   Thu, 27 Oct 2022 23:41:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/8] KVM: selftests: Explicitly require instructions
 bytes
Message-ID: <Y1sXNuM2e9p3DF92@google.com>
References: <20221018214612.3445074-1-dmatlack@google.com>
 <20221018214612.3445074-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018214612.3445074-3-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 18, 2022, David Matlack wrote:
> Explicitly require instruction bytes to be available in
> run->emulation_failure by asserting that they are present. Note that the
> test already requires the instruction bytes to be present because that's
> the only way the test will advance the RIP past the flds and get to
> GUEST_DONE().
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  .../smaller_maxphyaddr_emulation_test.c       | 47 +++++++++----------
>  1 file changed, 23 insertions(+), 24 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
> index 6ed996988a5a..c5353ad0e06d 100644
> --- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
> @@ -65,30 +65,29 @@ static void process_exit_on_emulation_error(struct kvm_vcpu *vcpu)
>  		    "Unexpected suberror: %u",
>  		    run->emulation_failure.suberror);
>  
> -	if (run->emulation_failure.ndata >= 1) {
> -		flags = run->emulation_failure.flags;
> -		if ((flags & KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES) &&
> -		    run->emulation_failure.ndata >= 3) {
> -			insn_size = run->emulation_failure.insn_size;
> -			insn_bytes = run->emulation_failure.insn_bytes;
> -
> -			TEST_ASSERT(insn_size <= 15 && insn_size > 0,
> -				    "Unexpected instruction size: %u",
> -				    insn_size);
> -
> -			TEST_ASSERT(is_flds(insn_bytes, insn_size),
> -				    "Unexpected instruction.  Expected 'flds' (0xd9 /0)");
> -
> -			/*
> -			 * If is_flds() succeeded then the instruction bytes
> -			 * contained an flds instruction that is 2-bytes in
> -			 * length (ie: no prefix, no SIB, no displacement).
> -			 */
> -			vcpu_regs_get(vcpu, &regs);
> -			regs.rip += 2;
> -			vcpu_regs_set(vcpu, &regs);
> -		}
> -	}
> +	flags = run->emulation_failure.flags;
> +	TEST_ASSERT(run->emulation_failure.ndata >= 3 &&
> +		    flags & KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES,
> +		    "run->emulation_failure is missing instruction bytes");
> +
> +	insn_size = run->emulation_failure.insn_size;
> +	insn_bytes = run->emulation_failure.insn_bytes;
> +
> +	TEST_ASSERT(insn_size <= 15 && insn_size > 0,
> +		    "Unexpected instruction size: %u",
> +		    insn_size);

Unnecessary newline, insn_size fits comfortably on the line above.

> +
> +	TEST_ASSERT(is_flds(insn_bytes, insn_size),
> +		    "Unexpected instruction.  Expected 'flds' (0xd9 /0)");
> +
> +	/*
> +	 * If is_flds() succeeded then the instruction bytes contained an flds
> +	 * instruction that is 2-bytes in length (ie: no prefix, no SIB, no
> +	 * displacement).
> +	 */
> +	vcpu_regs_get(vcpu, &regs);
> +	regs.rip += 2;

This whole sequence is silly.  Assert that size > 0 but < 15, then assert that
it's >= 2, then skip exactly two bytes and effective "assert" that it's '2.

And while I appreciate the ModR/M decoding, IMO it does more harm than good.  If
someone can follow the ModR/M decoding, they can figure out a hardcode opcode.
E.g. IMO this is much simpler and will be easier to debug.

#define FLDS_MEM_EAX ".byte 0xd9, 0x00"

static void guest_code(void)
{
	__asm__ __volatile__(FLDS_MEM_EAX
			     :: "a"(MEM_REGION_GVA));

	GUEST_DONE();
}

static void process_exit_on_emulation_error(struct kvm_vcpu *vcpu)
{
	struct kvm_run *run = vcpu->run;
	struct kvm_regs regs;
	uint8_t *insn_bytes;
	uint64_t flags;

	TEST_ASSERT(run->exit_reason == KVM_EXIT_INTERNAL_ERROR,
		    "Unexpected exit reason: %u (%s)",
		    run->exit_reason,
		    exit_reason_str(run->exit_reason));

	TEST_ASSERT(run->emulation_failure.suberror == KVM_INTERNAL_ERROR_EMULATION,
		    "Unexpected suberror: %u",
		    run->emulation_failure.suberror);

	flags = run->emulation_failure.flags;
	TEST_ASSERT(run->emulation_failure.ndata >= 3 &&
		    flags & KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES,
		    "run->emulation_failure is missing instruction bytes");

	TEST_ASSERT(run->emulation_failure.insn_size == 2,
		    "Expected a 2-byte opcode for 'flds', got %d bytes",
		    run->emulation_failure.insn_size);

	insn_bytes = run->emulation_failure.insn_bytes;
	TEST_ASSERT(insn_bytes[0] == 0xd9 && insn_bytes[1] == 0,
		    "Expected 'flds [eax]', opcode '0xd9 0x00', got opcode 0x%x 0x%x\n",
		    insn_bytes[0], insn_bytes[1]);

	vcpu_regs_get(vcpu, &regs);
	regs.rip += 2;
	vcpu_regs_set(vcpu, &regs);
}

