Return-Path: <kvm+bounces-3980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E9880B0F0
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 01:27:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80E791C20C6E
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 00:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F378C62B;
	Sat,  9 Dec 2023 00:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bLCsaPQY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0691705
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 16:26:58 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-50bf37fd2bbso3454769e87.0
        for <kvm@vger.kernel.org>; Fri, 08 Dec 2023 16:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702081617; x=1702686417; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0hRzpUJt/zJ83ew9kv7GqhhWrCD4wJjJTFBUypveDRg=;
        b=bLCsaPQYUtr3zfp7MWbxGlwUlUC5xShcvU8bgHlOgJPsYAjBUfjUE94bZlVsi7e2oK
         qM6Luh0E8aBEdiRccrzFFjpvY2fTSiX4gP2fOiSkDVehzLO99V73TldD3JMpOo55N2XS
         zoE8ZY2rbY7zSM1o5ybRkIYcKzYauQWR4BnuLhi6UAnYhej5tVcKzhuhkUCGqJWdgoAI
         50fuFQrG2xmiP1LEB1CL87YLswTPVEhzqii6+nye+0n0n5l4MNVQEV462mi0EFl5Rkd3
         lxNw4hsicrk3MASWSVzWTG+ujLk5uViKs4JhWm7fYkr9GonEMSmzycx6O/vktpVIAhC6
         Uf4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702081617; x=1702686417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0hRzpUJt/zJ83ew9kv7GqhhWrCD4wJjJTFBUypveDRg=;
        b=sHo6FRAOC7oHhmEhFGifFJXrUY/paWtRkfNEPYl5uB2NlUJQ9C2LqXbzRsrviW87N9
         HGYcarqNYZZYbS1P/9fIui1vhrOrZlqvzfwla11+ba6a4qoaFxikGYPBqrocQlfMpAMf
         vefBvEeDQpJ1hd2dWotqEuPf6fhUJSs1f7rHOBC2U2QnIwXAr2yUhjLDTlmuiFA5F7qc
         AZ5aKMIOpG6hvfEi6ffm5X/YaPl9yA0cn2kWl+5CHSr8v9ujSMh9hFN48pINZB6TDQCs
         6RWpo0HmQ3tHIjDdGwAs//R4BUdFIo82Y2OG5yn69PDD3f3erPXK+cjHcFnaSyb9JA5Z
         mZ3w==
X-Gm-Message-State: AOJu0Yyp1ZDx0HmEJuZcXgWDmEez8q9R2i1sGoPHEQmnWeI+rhc2vpqy
	fNdxxtYfek6+hT5YySBv4S9RXLDmhl6G/LO12szbwQ==
X-Google-Smtp-Source: AGHT+IGUBMLMqZANgiyUhZSK/xcXmEo19ketJCC7LdaL3bhq5USFZGqOfEzCEL9b91+Th4EXw0BIs0+IJhclCMD0KO0=
X-Received: by 2002:ac2:5e89:0:b0:50c:9e1:bf7a with SMTP id
 b9-20020ac25e89000000b0050c09e1bf7amr395367lfq.69.1702081616958; Fri, 08 Dec
 2023 16:26:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1699368322.git.isaku.yamahata@intel.com> <d8b438b6be78b4dbeea5c2a0ecaddfc06bfea43c.1699368322.git.isaku.yamahata@intel.com>
In-Reply-To: <d8b438b6be78b4dbeea5c2a0ecaddfc06bfea43c.1699368322.git.isaku.yamahata@intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Fri, 8 Dec 2023 16:26:45 -0800
Message-ID: <CAAhR5DH-k8Jf6tdvpCJPPmHpck=mynvcM4a3We3iNDKzYo3RaA@mail.gmail.com>
Subject: Re: [PATCH v17 093/116] KVM: TDX: Handle TDX PV port io hypercall
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>, Kai Huang <kai.huang@intel.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com, hang.yuan@intel.com, 
	tina.zhang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 7, 2023 at 6:58=E2=80=AFAM <isaku.yamahata@intel.com> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Wire up TDX PV port IO hypercall to the KVM backend function.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 57 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 4e48989d364f..d4b09255ad32 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1140,6 +1140,61 @@ static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
>         return kvm_emulate_halt_noskip(vcpu);
>  }
>
> +static int tdx_complete_pio_in(struct kvm_vcpu *vcpu)
> +{
> +       struct x86_emulate_ctxt *ctxt =3D vcpu->arch.emulate_ctxt;
> +       unsigned long val =3D 0;
> +       int ret;
> +
> +       WARN_ON_ONCE(vcpu->arch.pio.count !=3D 1);
> +
> +       ret =3D ctxt->ops->pio_in_emulated(ctxt, vcpu->arch.pio.size,
> +                                        vcpu->arch.pio.port, &val, 1);
> +       WARN_ON_ONCE(!ret);
> +
> +       tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
> +       tdvmcall_set_return_val(vcpu, val);
> +
> +       return 1;
> +}
> +
> +static int tdx_emulate_io(struct kvm_vcpu *vcpu)
> +{
> +       struct x86_emulate_ctxt *ctxt =3D vcpu->arch.emulate_ctxt;
> +       unsigned long val =3D 0;
> +       unsigned int port;
> +       int size, ret;
> +       bool write;
> +
> +       ++vcpu->stat.io_exits;
> +
> +       size =3D tdvmcall_a0_read(vcpu);
> +       write =3D tdvmcall_a1_read(vcpu);
> +       port =3D tdvmcall_a2_read(vcpu);
> +
> +       if (size !=3D 1 && size !=3D 2 && size !=3D 4) {
> +               tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPER=
AND);
> +               return 1;
> +       }
> +
> +       if (write) {
> +               val =3D tdvmcall_a3_read(vcpu);
> +               ret =3D ctxt->ops->pio_out_emulated(ctxt, size, port, &va=
l, 1);
> +
> +               /* No need for a complete_userspace_io callback. */
> +               vcpu->arch.pio.count =3D 0;
> +       } else {
> +               ret =3D ctxt->ops->pio_in_emulated(ctxt, size, port, &val=
, 1);
> +               if (!ret)
> +                       vcpu->arch.complete_userspace_io =3D tdx_complete=
_pio_in;
> +               else
> +                       tdvmcall_set_return_val(vcpu, val);
> +       }
> +       if (ret)
> +               tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);

In the case of a write operation that needs to exit to userspace,
pio_out_emulated is going to return 0 which means that the return code
is never set by tdx_emulate_io.
The reason this code is working now is because r10 is already set to 0
by the guest as part of the call to tdvmcall and never gets written by
the host.

> +       return ret;
> +}
> +
>  static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>  {
>         if (tdvmcall_exit_type(vcpu))
> @@ -1150,6 +1205,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>                 return tdx_emulate_cpuid(vcpu);
>         case EXIT_REASON_HLT:
>                 return tdx_emulate_hlt(vcpu);
> +       case EXIT_REASON_IO_INSTRUCTION:
> +               return tdx_emulate_io(vcpu);
>         default:
>                 break;
>         }
> --
> 2.25.1
>

