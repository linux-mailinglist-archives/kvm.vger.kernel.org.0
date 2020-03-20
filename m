Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91F8F18D9F9
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbgCTVDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:03:22 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35087 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgCTVDW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:03:22 -0400
Received: by mail-pj1-f68.google.com with SMTP id md6so46188pjb.0
        for <kvm@vger.kernel.org>; Fri, 20 Mar 2020 14:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=WYYlGXUS3P8mSLml0PfuMtkaHgB4uo3FYgrE6c+G15I=;
        b=pRH0aoVutp+j7/hs6yUmMIiksmihV0r7fS29fJRk1HmOS60I6S8F8Y00otTlC41vDa
         CDeYyh7d+RGSQ7ltUXsqLP5jY5OqH3GDt0AztZKZ5L9rSImvpoCvYSQFHZ17rpCIEpv6
         2j4cBbV+yix8EGN6Nm1m0zL/+B9Aube0W5x89jywr7JgvOELYaRZsJgPKvpK1eiqkTgx
         mauyoC1OMzZ+Xze6gfZy5s1yjQGY7t4bWMpw0QXUf2eESzKSMVF9WsF0/3gYkn6Ncyoa
         bkc7tUMdml8at3BCMInzRle5HOBXd7Cd+ItHjY883S5tG9FJlwKfGRo1h2U4OPBppcHw
         +AQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=WYYlGXUS3P8mSLml0PfuMtkaHgB4uo3FYgrE6c+G15I=;
        b=LbMLpqUWxwJPmQ50nWbw5o74dyy6Y9QTpROkkQiQRn6espDCIRrQVbBeQsygdq4XaX
         Iokohf0uNvib0gpFwVQi8TRuvY35fhXkZwsoOz8ZZNFoS/XGqcTKnV4wHPuS5kOLMUuh
         U3Ikwi+mM13HAhuCj4GZw33e1fZJtqIvoEbj0NRQv9R8ALBlLFiymVzmUXVFMim5pSuo
         cfUzEx8GAPfOuGWFFEmsvq+Wlt/bNWTQymSxv8n5jTWn9oYHMV/KQbwBlYJ03dFINmFv
         wIbMjM6rs+Bt6IXq4cjZ/p1PRHMLyBWJpmZQAlxRqtSme6gwbCXsYEHbEA3c1UbySayC
         GVNw==
X-Gm-Message-State: ANhLgQ3aDF4i05Ym6OXsJDFqc1MuhV0S8JCaD49TJsGvf/sS59Eorzhn
        J9VGwJMuvSqFw/UyNXgSb73/kA==
X-Google-Smtp-Source: ADFU+vuuP/36y96S10UPJdwP1UH04V2RRgoGTIhdrclxmmiSIlGSq1DzwE5Ciqko8aYhLbwKgyNcCQ==
X-Received: by 2002:a17:90a:950b:: with SMTP id t11mr11370990pjo.79.1584738199120;
        Fri, 20 Mar 2020 14:03:19 -0700 (PDT)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id c83sm6430364pfb.44.2020.03.20.14.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 14:03:18 -0700 (PDT)
Date:   Fri, 20 Mar 2020 14:03:17 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Joerg Roedel <joro@8bytes.org>
cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 23/70] x86/sev-es: Add support for handling IOIO
 exceptions
In-Reply-To: <20200319091407.1481-24-joro@8bytes.org>
Message-ID: <alpine.DEB.2.21.2003201402100.205664@chino.kir.corp.google.com>
References: <20200319091407.1481-1-joro@8bytes.org> <20200319091407.1481-24-joro@8bytes.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Mar 2020, Joerg Roedel wrote:

> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Add support for decoding and handling #VC exceptions for IOIO events.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> [ jroedel@suse.de: Adapted code to #VC handling framework ]
> Co-developed-by: Joerg Roedel <jroedel@suse.de>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/boot/compressed/sev-es.c |  32 +++++
>  arch/x86/kernel/sev-es-shared.c   | 202 ++++++++++++++++++++++++++++++
>  2 files changed, 234 insertions(+)
> 
> diff --git a/arch/x86/boot/compressed/sev-es.c b/arch/x86/boot/compressed/sev-es.c
> index 193c970a3379..ae5fbd371fd9 100644
> --- a/arch/x86/boot/compressed/sev-es.c
> +++ b/arch/x86/boot/compressed/sev-es.c
> @@ -18,6 +18,35 @@
>  struct ghcb boot_ghcb_page __aligned(PAGE_SIZE);
>  struct ghcb *boot_ghcb;
>  
> +/*
> + * Copy a version of this function here - insn-eval.c can't be used in
> + * pre-decompression code.
> + */
> +static bool insn_rep_prefix(struct insn *insn)
> +{
> +	int i;
> +
> +	insn_get_prefixes(insn);
> +
> +	for (i = 0; i < insn->prefixes.nbytes; i++) {
> +		insn_byte_t p = insn->prefixes.bytes[i];
> +
> +		if (p == 0xf2 || p == 0xf3)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Only a dummy for insn_get_seg_base() - Early boot-code is 64bit only and
> + * doesn't use segments.
> + */
> +static unsigned long insn_get_seg_base(struct pt_regs *regs, int seg_reg_idx)
> +{
> +	return 0UL;
> +}
> +
>  static inline u64 sev_es_rd_ghcb_msr(void)
>  {
>  	unsigned long low, high;
> @@ -117,6 +146,9 @@ void boot_vc_handler(struct pt_regs *regs, unsigned long exit_code)
>  		goto finish;
>  
>  	switch (exit_code) {
> +	case SVM_EXIT_IOIO:
> +		result = vc_handle_ioio(boot_ghcb, &ctxt);
> +		break;
>  	default:
>  		result = ES_UNSUPPORTED;
>  		break;
> diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
> index f0947ea3c601..46fc5318d1d7 100644
> --- a/arch/x86/kernel/sev-es-shared.c
> +++ b/arch/x86/kernel/sev-es-shared.c
> @@ -205,3 +205,205 @@ static enum es_result vc_insn_string_write(struct es_em_ctxt *ctxt,
>  
>  	return ret;
>  }
> +
> +#define IOIO_TYPE_STR  BIT(2)
> +#define IOIO_TYPE_IN   1
> +#define IOIO_TYPE_INS  (IOIO_TYPE_IN | IOIO_TYPE_STR)
> +#define IOIO_TYPE_OUT  0
> +#define IOIO_TYPE_OUTS (IOIO_TYPE_OUT | IOIO_TYPE_STR)
> +
> +#define IOIO_REP       BIT(3)
> +
> +#define IOIO_ADDR_64   BIT(9)
> +#define IOIO_ADDR_32   BIT(8)
> +#define IOIO_ADDR_16   BIT(7)
> +
> +#define IOIO_DATA_32   BIT(6)
> +#define IOIO_DATA_16   BIT(5)
> +#define IOIO_DATA_8    BIT(4)
> +
> +#define IOIO_SEG_ES    (0 << 10)
> +#define IOIO_SEG_DS    (3 << 10)
> +
> +static enum es_result vc_ioio_exitinfo(struct es_em_ctxt *ctxt, u64 *exitinfo)
> +{
> +	struct insn *insn = &ctxt->insn;
> +	*exitinfo = 0;
> +
> +	switch (insn->opcode.bytes[0]) {
> +	/* INS opcodes */
> +	case 0x6c:
> +	case 0x6d:
> +		*exitinfo |= IOIO_TYPE_INS;
> +		*exitinfo |= IOIO_SEG_ES;
> +		*exitinfo |= (ctxt->regs->dx & 0xffff) << 16;
> +		break;
> +
> +	/* OUTS opcodes */
> +	case 0x6e:
> +	case 0x6f:
> +		*exitinfo |= IOIO_TYPE_OUTS;
> +		*exitinfo |= IOIO_SEG_DS;
> +		*exitinfo |= (ctxt->regs->dx & 0xffff) << 16;
> +		break;
> +
> +	/* IN immediate opcodes */
> +	case 0xe4:
> +	case 0xe5:
> +		*exitinfo |= IOIO_TYPE_IN;
> +		*exitinfo |= insn->immediate.value << 16;
> +		break;
> +
> +	/* OUT immediate opcodes */
> +	case 0xe6:
> +	case 0xe7:
> +		*exitinfo |= IOIO_TYPE_OUT;
> +		*exitinfo |= insn->immediate.value << 16;
> +		break;
> +
> +	/* IN register opcodes */
> +	case 0xec:
> +	case 0xed:
> +		*exitinfo |= IOIO_TYPE_IN;
> +		*exitinfo |= (ctxt->regs->dx & 0xffff) << 16;
> +		break;
> +
> +	/* OUT register opcodes */
> +	case 0xee:
> +	case 0xef:
> +		*exitinfo |= IOIO_TYPE_OUT;
> +		*exitinfo |= (ctxt->regs->dx & 0xffff) << 16;
> +		break;
> +
> +	default:
> +		return ES_DECODE_FAILED;
> +	}
> +
> +	switch (insn->opcode.bytes[0]) {
> +	case 0x6c:
> +	case 0x6e:
> +	case 0xe4:
> +	case 0xe6:
> +	case 0xec:
> +	case 0xee:
> +		/* Single byte opcodes */
> +		*exitinfo |= IOIO_DATA_8;
> +		break;
> +	default:
> +		/* Length determined by instruction parsing */
> +		*exitinfo |= (insn->opnd_bytes == 2) ? IOIO_DATA_16
> +						     : IOIO_DATA_32;
> +	}
> +	switch (insn->addr_bytes) {
> +	case 2:
> +		*exitinfo |= IOIO_ADDR_16;
> +		break;
> +	case 4:
> +		*exitinfo |= IOIO_ADDR_32;
> +		break;
> +	case 8:
> +		*exitinfo |= IOIO_ADDR_64;
> +		break;
> +	}
> +
> +	if (insn_rep_prefix(insn))
> +		*exitinfo |= IOIO_REP;
> +
> +	return ES_OK;
> +}
> +
> +static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
> +{
> +	struct pt_regs *regs = ctxt->regs;
> +	u64 exit_info_1, exit_info_2;
> +	enum es_result ret;
> +
> +	ret = vc_ioio_exitinfo(ctxt, &exit_info_1);
> +	if (ret != ES_OK)
> +		return ret;
> +
> +	if (exit_info_1 & IOIO_TYPE_STR) {
> +		int df = (regs->flags & X86_EFLAGS_DF) ? -1 : 1;
> +		unsigned int io_bytes, exit_bytes;
> +		unsigned int ghcb_count, op_count;
> +		unsigned long es_base;
> +		u64 sw_scratch;
> +
> +		/*
> +		 * For the string variants with rep prefix the amount of in/out
> +		 * operations per #VC exception is limited so that the kernel
> +		 * has a chance to take interrupts an re-schedule while the
> +		 * instruction is emulated.
> +		 */
> +		io_bytes   = (exit_info_1 >> 4) & 0x7;
> +		ghcb_count = sizeof(ghcb->shared_buffer) / io_bytes;
> +
> +		op_count    = (exit_info_1 & IOIO_REP) ? regs->cx : 1;
> +		exit_info_2 = min(op_count, ghcb_count);
> +		exit_bytes  = exit_info_2 * io_bytes;
> +
> +		es_base = insn_get_seg_base(ctxt->regs, INAT_SEG_REG_ES);
> +
> +		if (!(exit_info_1 & IOIO_TYPE_IN)) {
> +			ret = vc_insn_string_read(ctxt,
> +					       (void *)(es_base + regs->si),
> +					       ghcb->shared_buffer, io_bytes,
> +					       exit_info_2, df);

The last argument to vc_insn_string_read() is "bool backwards" which in 
this case it appears will always be true?

> +			if (ret)
> +				return ret;
> +		}
> +
> +		sw_scratch = __pa(ghcb) + offsetof(struct ghcb, shared_buffer);
> +		ghcb_set_sw_scratch(ghcb, sw_scratch);
> +		ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_IOIO,
> +				   exit_info_1, exit_info_2);
> +		if (ret != ES_OK)
> +			return ret;
> +
> +		/* Everything went well, write back results */
> +		if (exit_info_1 & IOIO_TYPE_IN) {
> +			ret = vc_insn_string_write(ctxt,
> +						(void *)(es_base + regs->di),
> +						ghcb->shared_buffer, io_bytes,
> +						exit_info_2, df);
> +			if (ret)
> +				return ret;
> +
> +			if (df)
> +				regs->di -= exit_bytes;
> +			else
> +				regs->di += exit_bytes;
> +		} else {
> +			if (df)
> +				regs->si -= exit_bytes;
> +			else
> +				regs->si += exit_bytes;
> +		}
> +
> +		if (exit_info_1 & IOIO_REP)
> +			regs->cx -= exit_info_2;
> +
> +		ret = regs->cx ? ES_RETRY : ES_OK;
> +
> +	} else {
> +		int bits = (exit_info_1 & 0x70) >> 1;
> +		u64 rax = 0;
> +
> +		if (!(exit_info_1 & IOIO_TYPE_IN))
> +			rax = lower_bits(regs->ax, bits);
> +
> +		ghcb_set_rax(ghcb, rax);
> +
> +		ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_IOIO, exit_info_1, 0);
> +		if (ret != ES_OK)
> +			return ret;
> +
> +		if (exit_info_1 & IOIO_TYPE_IN) {
> +			if (!ghcb_is_valid_rax(ghcb))
> +				return ES_VMM_ERROR;
> +			regs->ax = lower_bits(ghcb->save.rax, bits);
> +		}
> +	}
> +
> +	return ret;
> +}
> -- 
> 2.17.1
> 
> 
