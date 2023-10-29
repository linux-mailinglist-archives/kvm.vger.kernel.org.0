Return-Path: <kvm+bounces-17-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A58F7DACE2
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 15:55:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B26031C209B2
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 14:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C9A92596;
	Sun, 29 Oct 2023 14:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95857F9
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 14:55:25 +0000 (UTC)
Received: from 14.mo561.mail-out.ovh.net (14.mo561.mail-out.ovh.net [188.165.43.98])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4835FBC
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 07:55:23 -0700 (PDT)
Received: from director6.ghost.mail-out.ovh.net (unknown [10.109.138.131])
	by mo561.mail-out.ovh.net (Postfix) with ESMTP id 1D1AD25A8E
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 12:26:24 +0000 (UTC)
Received: from ghost-submission-6684bf9d7b-zlzdz (unknown [10.110.171.220])
	by director6.ghost.mail-out.ovh.net (Postfix) with ESMTPS id 136771FD23;
	Sun, 29 Oct 2023 12:26:23 +0000 (UTC)
Received: from RCM-web4.webmail.mail.ovh.net ([176.31.235.81])
	by ghost-submission-6684bf9d7b-zlzdz with ESMTPSA
	id CCgfA29PPmWg6QAAfL0Qcw
	(envelope-from <jose.pekkarinen@foxhound.fi>); Sun, 29 Oct 2023 12:26:23 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 29 Oct 2023 14:26:22 +0200
From: =?UTF-8?Q?Jos=C3=A9_Pekkarinen?= <jose.pekkarinen@foxhound.fi>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 skhan@linuxfoundation.org
Cc: x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] KVM: x86: cleanup unused variables
In-Reply-To: <20231029093859.138442-1-jose.pekkarinen@foxhound.fi>
References: <20231029093859.138442-1-jose.pekkarinen@foxhound.fi>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <411f0a96b86c08e85a02c7174a921138@foxhound.fi>
X-Sender: jose.pekkarinen@foxhound.fi
Organization: Foxhound Ltd.
X-Originating-IP: 192.42.116.212
X-Webmail-UserID: jose.pekkarinen@foxhound.fi
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 5724075128479131302
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrleekgdeflecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhepggffhffvvefujghffgfkgihoihgtgfesthekjhdttderjeenucfhrhhomheplfhoshorucfrvghkkhgrrhhinhgvnhcuoehjohhsvgdrphgvkhhkrghrihhnvghnsehfohighhhouhhnugdrfhhiqeenucggtffrrghtthgvrhhnpeekhfeguddufeegvdelgedtvdffgeehvddtkeevkeejvedvgeeitdefleehtdeitdenucfkphepuddvjedrtddrtddruddpudelvddrgedvrdduudeirddvuddvpddujeeirdefuddrvdefhedrkedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeojhhoshgvrdhpvghkkhgrrhhinhgvnhesfhhogihhohhunhgurdhfiheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheeiuddpmhhouggvpehsmhhtphhouhht

On 2023-10-29 11:38, José Pekkarinen wrote:
> Reported by coccinelle, the following patch will remove some
> redundant variables. This patch will address the following
> warnings:
> 
> arch/x86/kvm/emulate.c:1315:5-7: Unneeded variable: "rc". Return
> "X86EMUL_CONTINUE" on line 1330
> arch/x86/kvm/emulate.c:4557:5-7: Unneeded variable: "rc". Return
> "X86EMUL_CONTINUE" on line 4591
> arch/x86/kvm/emulate.c:1180:5-7: Unneeded variable: "rc". Return
> "X86EMUL_CONTINUE" on line 1202
> 
> Signed-off-by: José Pekkarinen <jose.pekkarinen@foxhound.fi>
> ---
>  arch/x86/kvm/emulate.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 2673cd5c46cb..c4bb03a88dfe 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1177,7 +1177,6 @@ static int decode_modrm(struct x86_emulate_ctxt 
> *ctxt,
>  {
>  	u8 sib;
>  	int index_reg, base_reg, scale;
> -	int rc = X86EMUL_CONTINUE;
>  	ulong modrm_ea = 0;
> 
>  	ctxt->modrm_reg = ((ctxt->rex_prefix << 1) & 8); /* REX.R */
> @@ -1199,16 +1198,16 @@ static int decode_modrm(struct x86_emulate_ctxt 
> *ctxt,
>  			op->bytes = 16;
>  			op->addr.xmm = ctxt->modrm_rm;
>  			kvm_read_sse_reg(ctxt->modrm_rm, &op->vec_val);
> -			return rc;
> +			return X86EMUL_CONTINUE;
>  		}
>  		if (ctxt->d & Mmx) {
>  			op->type = OP_MM;
>  			op->bytes = 8;
>  			op->addr.mm = ctxt->modrm_rm & 7;
> -			return rc;
> +			return X86EMUL_CONTINUE;
>  		}
>  		fetch_register_operand(op);
> -		return rc;
> +		return X86EMUL_CONTINUE;
>  	}
> 
>  	op->type = OP_MEM;
> @@ -1306,14 +1305,12 @@ static int decode_modrm(struct x86_emulate_ctxt 
> *ctxt,
>  		ctxt->memop.addr.mem.ea = (u32)ctxt->memop.addr.mem.ea;
> 
>  done:
> -	return rc;
> +	return X86EMUL_CONTINUE;
>  }
> 
>  static int decode_abs(struct x86_emulate_ctxt *ctxt,
>  		      struct operand *op)
>  {
> -	int rc = X86EMUL_CONTINUE;
> -
>  	op->type = OP_MEM;
>  	switch (ctxt->ad_bytes) {
>  	case 2:
> @@ -1327,7 +1324,7 @@ static int decode_abs(struct x86_emulate_ctxt 
> *ctxt,
>  		break;
>  	}
>  done:
> -	return rc;
> +	return X86EMUL_CONTINUE;
>  }
> 
>  static void fetch_bit_operand(struct x86_emulate_ctxt *ctxt)
> @@ -4554,8 +4551,6 @@ static unsigned imm_size(struct x86_emulate_ctxt 
> *ctxt)
>  static int decode_imm(struct x86_emulate_ctxt *ctxt, struct operand 
> *op,
>  		      unsigned size, bool sign_extension)
>  {
> -	int rc = X86EMUL_CONTINUE;
> -
>  	op->type = OP_IMM;
>  	op->bytes = size;
>  	op->addr.mem.ea = ctxt->_eip;
> @@ -4588,7 +4583,7 @@ static int decode_imm(struct x86_emulate_ctxt
> *ctxt, struct operand *op,
>  		}
>  	}
>  done:
> -	return rc;
> +	return X86EMUL_CONTINUE;
>  }
> 
>  static int decode_operand(struct x86_emulate_ctxt *ctxt, struct 
> operand *op,

     Sorry, this is a false positive, please skip it.

     José.

