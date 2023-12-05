Return-Path: <kvm+bounces-3567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9B6380540B
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 13:25:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F862281737
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 12:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DCFE5C060;
	Tue,  5 Dec 2023 12:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="ss4SiFkd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63897109
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 04:25:28 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-40b5155e154so59723055e9.3
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 04:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1701779127; x=1702383927; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QNCLk+56fWI2chNhpjUr6+slGM9CjcICEgag2GdvCoc=;
        b=ss4SiFkdwZY/2AZvfoVCmfCCATG7HPwTjCRg8Om2IoMjSg8oK7Uq1usj1oquxVbxK7
         fSq3eg3Tv2GqVhMnJua29rIOEx8Ed4N1oc47narYzn6CFXObcQxMOeiMVhRF1gZ+KeEn
         pOzUIv/1l2cRiAy3BUm8qk+L0R8DNnv20l6q8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701779127; x=1702383927;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QNCLk+56fWI2chNhpjUr6+slGM9CjcICEgag2GdvCoc=;
        b=Y7xVAwS5xdaeyFaykyQtphht3UjQhoTUOuwzO0PrJ0MKYvlrG4wouWODbs74u4/c7d
         QLvRJUYzTInccfgYyZ5hOTAc7XMC7ORTmlbzLL+sacUwR9RE0z3U49nsgUu9B62qYjKK
         CgajlO3uG/FjUL98Z/ziPj82yi2aqu81nnJAttO1VrILtCHj0ZiWikqqWBmjCDxhl7vZ
         TuaZ9MG3bgtnbFyZq1ygNS5jprTj1gYqZ+i0Pca7r0B3FRfcRD9YfCV1Mvzd/5nmoIN2
         7hwZht4UzVU9hZor8TWqPwrs1MK7LythKu2kKBCpT4FRR2O8pT3wCIg79VfdL39a6XwI
         solQ==
X-Gm-Message-State: AOJu0YwYy0ehGizj3+PsJbSFSrumJZ1Nlg/RdSzSGNvnCVozKmG5kKG4
	/3dAKzprP1wAVALpCu4fffjZSA==
X-Google-Smtp-Source: AGHT+IFxBxp6EQ7qVgNSuhOPqdIy0eT6mG75SBCSajakYFILb/bhoaJag+l06/bE/PKNsb6QbMajOg==
X-Received: by 2002:a05:600c:600b:b0:40b:4e4e:2b22 with SMTP id az11-20020a05600c600b00b0040b4e4e2b22mr365566wmb.38.1701779126718;
        Tue, 05 Dec 2023 04:25:26 -0800 (PST)
Received: from [10.80.67.30] (default-46-102-197-194.interdsl.co.uk. [46.102.197.194])
        by smtp.gmail.com with ESMTPSA id hg10-20020a05600c538a00b0040b398f0585sm18773310wmb.9.2023.12.05.04.25.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 04:25:26 -0800 (PST)
Message-ID: <f260ddf9-be67-48e0-8121-6f58d46f7978@citrix.com>
Date: Tue, 5 Dec 2023 12:25:25 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 26/35] x86/fred: FRED entry/exit and dispatch code
Content-Language: en-GB
To: Xin Li <xin3.li@intel.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
 linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, peterz@infradead.org,
 jgross@suse.com, ravi.v.shankar@intel.com, mhiramat@kernel.org,
 jiangshanlai@gmail.com, nik.borisov@suse.com, shan.kang@intel.com
References: <20231205105030.8698-1-xin3.li@intel.com>
 <20231205105030.8698-27-xin3.li@intel.com>
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 xsFNBFLhNn8BEADVhE+Hb8i0GV6mihnnr/uiQQdPF8kUoFzCOPXkf7jQ5sLYeJa0cQi6Penp
 VtiFYznTairnVsN5J+ujSTIb+OlMSJUWV4opS7WVNnxHbFTPYZVQ3erv7NKc2iVizCRZ2Kxn
 srM1oPXWRic8BIAdYOKOloF2300SL/bIpeD+x7h3w9B/qez7nOin5NzkxgFoaUeIal12pXSR
 Q354FKFoy6Vh96gc4VRqte3jw8mPuJQpfws+Pb+swvSf/i1q1+1I4jsRQQh2m6OTADHIqg2E
 ofTYAEh7R5HfPx0EXoEDMdRjOeKn8+vvkAwhviWXTHlG3R1QkbE5M/oywnZ83udJmi+lxjJ5
 YhQ5IzomvJ16H0Bq+TLyVLO/VRksp1VR9HxCzItLNCS8PdpYYz5TC204ViycobYU65WMpzWe
 LFAGn8jSS25XIpqv0Y9k87dLbctKKA14Ifw2kq5OIVu2FuX+3i446JOa2vpCI9GcjCzi3oHV
 e00bzYiHMIl0FICrNJU0Kjho8pdo0m2uxkn6SYEpogAy9pnatUlO+erL4LqFUO7GXSdBRbw5
 gNt25XTLdSFuZtMxkY3tq8MFss5QnjhehCVPEpE6y9ZjI4XB8ad1G4oBHVGK5LMsvg22PfMJ
 ISWFSHoF/B5+lHkCKWkFxZ0gZn33ju5n6/FOdEx4B8cMJt+cWwARAQABzSlBbmRyZXcgQ29v
 cGVyIDxhbmRyZXcuY29vcGVyM0BjaXRyaXguY29tPsLBegQTAQgAJAIbAwULCQgHAwUVCgkI
 CwUWAgMBAAIeAQIXgAUCWKD95wIZAQAKCRBlw/kGpdefoHbdD/9AIoR3k6fKl+RFiFpyAhvO
 59ttDFI7nIAnlYngev2XUR3acFElJATHSDO0ju+hqWqAb8kVijXLops0gOfqt3VPZq9cuHlh
 IMDquatGLzAadfFx2eQYIYT+FYuMoPZy/aTUazmJIDVxP7L383grjIkn+7tAv+qeDfE+txL4
 SAm1UHNvmdfgL2/lcmL3xRh7sub3nJilM93RWX1Pe5LBSDXO45uzCGEdst6uSlzYR/MEr+5Z
 JQQ32JV64zwvf/aKaagSQSQMYNX9JFgfZ3TKWC1KJQbX5ssoX/5hNLqxMcZV3TN7kU8I3kjK
 mPec9+1nECOjjJSO/h4P0sBZyIUGfguwzhEeGf4sMCuSEM4xjCnwiBwftR17sr0spYcOpqET
 ZGcAmyYcNjy6CYadNCnfR40vhhWuCfNCBzWnUW0lFoo12wb0YnzoOLjvfD6OL3JjIUJNOmJy
 RCsJ5IA/Iz33RhSVRmROu+TztwuThClw63g7+hoyewv7BemKyuU6FTVhjjW+XUWmS/FzknSi
 dAG+insr0746cTPpSkGl3KAXeWDGJzve7/SBBfyznWCMGaf8E2P1oOdIZRxHgWj0zNr1+ooF
 /PzgLPiCI4OMUttTlEKChgbUTQ+5o0P080JojqfXwbPAyumbaYcQNiH1/xYbJdOFSiBv9rpt
 TQTBLzDKXok86M7BTQRS4TZ/ARAAkgqudHsp+hd82UVkvgnlqZjzz2vyrYfz7bkPtXaGb9H4
 Rfo7mQsEQavEBdWWjbga6eMnDqtu+FC+qeTGYebToxEyp2lKDSoAsvt8w82tIlP/EbmRbDVn
 7bhjBlfRcFjVYw8uVDPptT0TV47vpoCVkTwcyb6OltJrvg/QzV9f07DJswuda1JH3/qvYu0p
 vjPnYvCq4NsqY2XSdAJ02HrdYPFtNyPEntu1n1KK+gJrstjtw7KsZ4ygXYrsm/oCBiVW/OgU
 g/XIlGErkrxe4vQvJyVwg6YH653YTX5hLLUEL1NS4TCo47RP+wi6y+TnuAL36UtK/uFyEuPy
 wwrDVcC4cIFhYSfsO0BumEI65yu7a8aHbGfq2lW251UcoU48Z27ZUUZd2Dr6O/n8poQHbaTd
 6bJJSjzGGHZVbRP9UQ3lkmkmc0+XCHmj5WhwNNYjgbbmML7y0fsJT5RgvefAIFfHBg7fTY/i
 kBEimoUsTEQz+N4hbKwo1hULfVxDJStE4sbPhjbsPCrlXf6W9CxSyQ0qmZ2bXsLQYRj2xqd1
 bpA+1o1j2N4/au1R/uSiUFjewJdT/LX1EklKDcQwpk06Af/N7VZtSfEJeRV04unbsKVXWZAk
 uAJyDDKN99ziC0Wz5kcPyVD1HNf8bgaqGDzrv3TfYjwqayRFcMf7xJaL9xXedMcAEQEAAcLB
 XwQYAQgACQUCUuE2fwIbDAAKCRBlw/kGpdefoG4XEACD1Qf/er8EA7g23HMxYWd3FXHThrVQ
 HgiGdk5Yh632vjOm9L4sd/GCEACVQKjsu98e8o3ysitFlznEns5EAAXEbITrgKWXDDUWGYxd
 pnjj2u+GkVdsOAGk0kxczX6s+VRBhpbBI2PWnOsRJgU2n10PZ3mZD4Xu9kU2IXYmuW+e5KCA
 vTArRUdCrAtIa1k01sPipPPw6dfxx2e5asy21YOytzxuWFfJTGnVxZZSCyLUO83sh6OZhJkk
 b9rxL9wPmpN/t2IPaEKoAc0FTQZS36wAMOXkBh24PQ9gaLJvfPKpNzGD8XWR5HHF0NLIJhgg
 4ZlEXQ2fVp3XrtocHqhu4UZR4koCijgB8sB7Tb0GCpwK+C4UePdFLfhKyRdSXuvY3AHJd4CP
 4JzW0Bzq/WXY3XMOzUTYApGQpnUpdOmuQSfpV9MQO+/jo7r6yPbxT7CwRS5dcQPzUiuHLK9i
 nvjREdh84qycnx0/6dDroYhp0DFv4udxuAvt1h4wGwTPRQZerSm4xaYegEFusyhbZrI0U9tJ
 B8WrhBLXDiYlyJT6zOV2yZFuW47VrLsjYnHwn27hmxTC/7tvG3euCklmkn9Sl9IAKFu29RSo
 d5bD8kMSCYsTqtTfT6W4A3qHGvIDta3ptLYpIAOD2sY3GYq2nf3Bbzx81wZK14JdDDHUX2Rs
 6+ahAA==
In-Reply-To: <20231205105030.8698-27-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 05/12/2023 10:50 am, Xin Li wrote:
> diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
> new file mode 100644
> index 000000000000..215883e90f94
> --- /dev/null
> +++ b/arch/x86/entry/entry_fred.c
> @@ -0,0 +1,230 @@
> ...
> +static noinstr void fred_intx(struct pt_regs *regs)
> +{
> +	switch (regs->fred_ss.vector) {
> +	/* INT0 */

INTO (for overflow), not INT-zero.  However...

> +	case X86_TRAP_OF:
> +		exc_overflow(regs);
> +		return;
> +
> +	/* INT3 */
> +	case X86_TRAP_BP:
> +		exc_int3(regs);
> +		return;

... neither OF nor BP will ever enter fred_intx() because they're type
SWEXC not SWINT.

SWINT is strictly the INT $imm8 instruction.

> ...
> +static noinstr void fred_extint(struct pt_regs *regs)
> +{
> +	unsigned int vector = regs->fred_ss.vector;
> +
> +	if (WARN_ON_ONCE(vector < FIRST_EXTERNAL_VECTOR))
> +		return;
> +
> +	if (likely(vector >= FIRST_SYSTEM_VECTOR)) {
> +		irqentry_state_t state = irqentry_enter(regs);
> +
> +		instrumentation_begin();
> +		sysvec_table[vector - FIRST_SYSTEM_VECTOR](regs);

array_index_mask_nospec()

This is easy for an attacker to abuse, to install non-function-pointer
targets into the indirect predictor.

> +		instrumentation_end();
> +		irqentry_exit(regs, state);
> +	} else {
> +		common_interrupt(regs, vector);
> +	}
> +}
> +
> +static noinstr void fred_exception(struct pt_regs *regs, unsigned long error_code)
> +{
> +	/* Optimize for #PF. That's the only exception which matters performance wise */
> +	if (likely(regs->fred_ss.vector == X86_TRAP_PF)) {
> +		exc_page_fault(regs, error_code);
> +		return;
> +	}
> +
> +	switch (regs->fred_ss.vector) {
> +	case X86_TRAP_DE: return exc_divide_error(regs);
> +	case X86_TRAP_DB: return fred_exc_debug(regs);
> +	case X86_TRAP_BP: return exc_int3(regs);
> +	case X86_TRAP_OF: return exc_overflow(regs);

Depending on what you want to do with BP/OF vs fred_intx(), this may
need adjusting.

If you are cross-checking type and vector, then these should be rejected
for not being of type HWEXC.

> +	case X86_TRAP_BR: return exc_bounds(regs);
> +	case X86_TRAP_UD: return exc_invalid_op(regs);
> +	case X86_TRAP_NM: return exc_device_not_available(regs);
> +	case X86_TRAP_DF: return exc_double_fault(regs, error_code);
> +	case X86_TRAP_TS: return exc_invalid_tss(regs, error_code);
> +	case X86_TRAP_NP: return exc_segment_not_present(regs, error_code);
> +	case X86_TRAP_SS: return exc_stack_segment(regs, error_code);
> +	case X86_TRAP_GP: return exc_general_protection(regs, error_code);
> +	case X86_TRAP_MF: return exc_coprocessor_error(regs);
> +	case X86_TRAP_AC: return exc_alignment_check(regs, error_code);
> +	case X86_TRAP_XF: return exc_simd_coprocessor_error(regs);
> +
> +#ifdef CONFIG_X86_MCE
> +	case X86_TRAP_MC: return fred_exc_machine_check(regs);
> +#endif
> +#ifdef CONFIG_INTEL_TDX_GUEST
> +	case X86_TRAP_VE: return exc_virtualization_exception(regs);
> +#endif
> +#ifdef CONFIG_X86_KERNEL_IBT

CONFIG_X86_CET

Userspace can use CET even if the kernel isn't compiled with IBT, so
this exception needs handling.

> +	case X86_TRAP_CP: return exc_control_protection(regs, error_code);
> +#endif
> +	default: return fred_bad_type(regs, error_code);
> +	}
> +}
> +
> +__visible noinstr void fred_entry_from_user(struct pt_regs *regs)
> +{
> +	unsigned long error_code = regs->orig_ax;
> +
> +	/* Invalidate orig_ax so that syscall_get_nr() works correctly */
> +	regs->orig_ax = -1;
> +
> +	switch (regs->fred_ss.type) {
> +	case EVENT_TYPE_EXTINT:
> +		return fred_extint(regs);
> +	case EVENT_TYPE_NMI:
> +		return fred_exc_nmi(regs);
> +	case EVENT_TYPE_SWINT:
> +		return fred_intx(regs);
> +	case EVENT_TYPE_HWEXC:
> +	case EVENT_TYPE_SWEXC:
> +	case EVENT_TYPE_PRIV_SWEXC:
> +		return fred_exception(regs, error_code);

PRIV_SWEXC should have it's own function and not fall into fred_exception().

It is strictly only the ICEBP (INT1) instruction at the moment, so
should fall into bad_type() for any vector other than X86_TRAP_DB.

> +	case EVENT_TYPE_OTHER:
> +		return fred_other(regs);
> +	default:
> +		return fred_bad_type(regs, error_code);
> +	}
> +}

~Andrew

