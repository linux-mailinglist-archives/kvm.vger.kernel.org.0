Return-Path: <kvm+bounces-100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DC2B7DBE3A
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:46:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B857D281610
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 16:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C937E19442;
	Mon, 30 Oct 2023 16:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vNfOUGbl"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B6528EF
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 16:46:37 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B64A9B
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 09:46:34 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so361a12.0
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 09:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698684393; x=1699289193; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NrxTVlMdWGqN2rBi2X8dQoPS4JQYff2ykLErELYzXrQ=;
        b=vNfOUGbl9b4xXkUAXhhrcLhuodNqXISBmHhFtXuhmyhNA4RTzWXEGXARhbzlDYdlJo
         xHAcMH2xDik8wm7d2ulqHooKIgILHcvSlMelQEBVpT1z/qcLe5or7ZxDG2R2iL1xf4Qf
         AH2+GbsGXG75uDUmClNwH9lzj+TmfXd2lBxAnPDBrpoYJjjU83iYrKMT2qHIaQgYBppP
         JQZI6Cz4dPDdbmLwTHzS0852S2lucIkQCIV/ch8Eg+onN1OmUXcUemCRVO0F/QlSD5vW
         yL79hSCV+4YixLBfxOu4bdb583jaG+ESVIU0845R/pZJ01UNWjtX/zFTTCk6LVOfGJwb
         IIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698684393; x=1699289193;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NrxTVlMdWGqN2rBi2X8dQoPS4JQYff2ykLErELYzXrQ=;
        b=CNx74RWBvBN9C4c21SofSi2maoCMw1KisxOW+gbnh+ekQEt/YWGQvuVNhkAYd9Q+XU
         dna1iuRHKsDnbkDVBEgAusbAyKA3V0eQbrptwUUUvqgcBm2eX0wxBfFEym3N/Vr7H71H
         8IBh918BFNCRgHLThADuq6Ai8CoJEjuPCTg3qzyAtYYP0rl8vQ4YeHEgUy6sYt3G63q5
         fwFybCG6mo/fw0+p/1snqRFYCAJIpDrC5mZQ0oFD5xYKqSXypvc0EjZZdR0Sk+ewyJKC
         9xoV+EVVRTqubxrrk821BuQWf/TXgT+wTqowZ4RqFntjwAVQwUFSaZEKho0jYV8OcA2g
         IC7g==
X-Gm-Message-State: AOJu0YwRS+b++sTIbbsiazIUg4lJUNqlc5jU5PzcowELxtoJmkcNyZ0P
	0HN+zH3yCLU4Q79/iauQRGvMgMD9ufXy85v0LYUqAg==
X-Google-Smtp-Source: AGHT+IHMf1lGTN4TKsy2BX7REQlbfUbshdv47QNVMLsIqBvioUNoevko7CQ6eBc+hQiiteHJui2ar9dnE+Lm5mX4lcw=
X-Received: by 2002:a05:6402:1a56:b0:543:5119:2853 with SMTP id
 bf22-20020a0564021a5600b0054351192853mr60394edb.6.1698684392790; Mon, 30 Oct
 2023 09:46:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231030063652.68675-1-nikunj@amd.com> <20231030063652.68675-10-nikunj@amd.com>
In-Reply-To: <20231030063652.68675-10-nikunj@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Mon, 30 Oct 2023 09:46:19 -0700
Message-ID: <CAAH4kHbceVXo_==J7K4f5kTbCYj=SQWQNDs2CAAms3vdreG7cw@mail.gmail.com>
Subject: Re: [PATCH v5 09/14] x86/sev: Add Secure TSC support for SNP guests
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org, 
	kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 29, 2023 at 11:38=E2=80=AFPM Nikunj A Dadhania <nikunj@amd.com>=
 wrote:
>
> Add support for Secure TSC in SNP enabled guests. Secure TSC allows
> guest to securely use RDTSC/RDTSCP instructions as the parameters
> being used cannot be changed by hypervisor once the guest is launched.
>
> During the boot-up of the secondary cpus, SecureTSC enabled guests
> need to query TSC info from AMD Security Processor. This communication
> channel is encrypted between the AMD Security Processor and the guest,
> the hypervisor is just the conduit to deliver the guest messages to
> the AMD Security Processor. Each message is protected with an
> AEAD (AES-256 GCM). Use minimal AES GCM library to encrypt/decrypt SNP
> Guest messages to communicate with the PSP.
>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/coco/core.c             |  3 ++
>  arch/x86/include/asm/sev-guest.h | 18 +++++++
>  arch/x86/include/asm/sev.h       |  2 +
>  arch/x86/include/asm/svm.h       |  6 ++-
>  arch/x86/kernel/sev.c            | 82 ++++++++++++++++++++++++++++++++
>  arch/x86/mm/mem_encrypt_amd.c    |  6 +++
>  include/linux/cc_platform.h      |  8 ++++
>  7 files changed, 123 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> index eeec9986570e..5d5d4d03c543 100644
> --- a/arch/x86/coco/core.c
> +++ b/arch/x86/coco/core.c
> @@ -89,6 +89,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr at=
tr)
>         case CC_ATTR_GUEST_SEV_SNP:
>                 return sev_status & MSR_AMD64_SEV_SNP_ENABLED;
>
> +       case CC_ATTR_GUEST_SECURE_TSC:
> +               return sev_status & MSR_AMD64_SNP_SECURE_TSC;
> +
>         default:
>                 return false;
>         }
> diff --git a/arch/x86/include/asm/sev-guest.h b/arch/x86/include/asm/sev-=
guest.h
> index e6f94208173d..58739173eba9 100644
> --- a/arch/x86/include/asm/sev-guest.h
> +++ b/arch/x86/include/asm/sev-guest.h
> @@ -39,6 +39,8 @@ enum msg_type {
>         SNP_MSG_ABSORB_RSP,
>         SNP_MSG_VMRK_REQ,
>         SNP_MSG_VMRK_RSP,
> +       SNP_MSG_TSC_INFO_REQ =3D 17,
> +       SNP_MSG_TSC_INFO_RSP,
>
>         SNP_MSG_TYPE_MAX
>  };
> @@ -111,6 +113,22 @@ struct snp_guest_req {
>         u8 msg_type;
>  };
>
> +struct snp_tsc_info_req {
> +#define SNP_TSC_INFO_REQ_SZ 128
> +       /* Must be zero filled */
> +       u8 rsvd[SNP_TSC_INFO_REQ_SZ];
> +} __packed;
> +
> +struct snp_tsc_info_resp {
> +       /* Status of TSC_INFO message */
> +       u32 status;
> +       u32 rsvd1;
> +       u64 tsc_scale;
> +       u64 tsc_offset;
> +       u32 tsc_factor;
> +       u8 rsvd2[100];
> +} __packed;
> +
>  int snp_setup_psp_messaging(struct snp_guest_dev *snp_dev);
>  int snp_send_guest_request(struct snp_guest_dev *dev, struct snp_guest_r=
eq *req,
>                            struct snp_guest_request_ioctl *rio);
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 783150458864..038a5a15d937 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -200,6 +200,7 @@ void __init __noreturn snp_abort(void);
>  void snp_accept_memory(phys_addr_t start, phys_addr_t end);
>  u64 snp_get_unsupported_features(u64 status);
>  u64 sev_get_status(void);
> +void __init snp_secure_tsc_prepare(void);
>  #else
>  static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>  static inline void sev_es_ist_exit(void) { }
> @@ -223,6 +224,7 @@ static inline void snp_abort(void) { }
>  static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end)=
 { }
>  static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
>  static inline u64 sev_get_status(void) { return 0; }
> +static inline void __init snp_secure_tsc_prepare(void) { }
>  #endif
>
>  #endif
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 3ac0ffc4f3e2..ee35c0488f56 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -414,7 +414,9 @@ struct sev_es_save_area {
>         u8 reserved_0x298[80];
>         u32 pkru;
>         u32 tsc_aux;
> -       u8 reserved_0x2f0[24];
> +       u64 tsc_scale;
> +       u64 tsc_offset;
> +       u8 reserved_0x300[8];
>         u64 rcx;
>         u64 rdx;
>         u64 rbx;
> @@ -546,7 +548,7 @@ static inline void __unused_size_checks(void)
>         BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x1c0);
>         BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x248);
>         BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x298);
> -       BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x2f0);
> +       BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x300);
>         BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x320);
>         BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x380);
>         BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x3f0);
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index fb3b1feb1b84..9468809d02c7 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -76,6 +76,10 @@ static u64 sev_hv_features __ro_after_init;
>  /* Secrets page physical address from the CC blob */
>  static u64 secrets_pa __ro_after_init;
>
> +/* Secure TSC values read using TSC_INFO SNP Guest request */
> +static u64 guest_tsc_scale __ro_after_init;
> +static u64 guest_tsc_offset __ro_after_init;
> +
>  /* #VC handler runtime per-CPU data */
>  struct sev_es_runtime_data {
>         struct ghcb ghcb_page;
> @@ -1393,6 +1397,78 @@ bool snp_assign_vmpck(struct snp_guest_dev *dev, u=
nsigned int vmpck_id)
>  }
>  EXPORT_SYMBOL_GPL(snp_assign_vmpck);
>
> +static struct snp_guest_dev tsc_snp_dev __initdata;
> +
> +static int __init snp_get_tsc_info(void)
> +{
> +       static u8 buf[SNP_TSC_INFO_REQ_SZ + AUTHTAG_LEN];
> +       struct snp_guest_request_ioctl rio;
> +       struct snp_tsc_info_resp tsc_resp;
> +       struct snp_tsc_info_req tsc_req;
> +       struct snp_guest_req req;
> +       int rc, resp_len;
> +
> +       /*
> +        * The intermediate response buffer is used while decrypting the
> +        * response payload. Make sure that it has enough space to cover =
the
> +        * authtag.
> +        */
> +       resp_len =3D sizeof(tsc_resp) + AUTHTAG_LEN;
> +       if (sizeof(buf) < resp_len)
> +               return -EINVAL;
> +
> +       memset(&tsc_req, 0, sizeof(tsc_req));
> +       memset(&req, 0, sizeof(req));
> +       memset(&rio, 0, sizeof(rio));
> +       memset(buf, 0, sizeof(buf));
> +
> +       if (!snp_assign_vmpck(&tsc_snp_dev, 0))
> +               return -EINVAL;
> +

I don't see a requirement for VMPL0 in the API docs. I just see "When
a guest creates its own VMSA, it must query the PSP for information
with the TSC_INFO message to determine the correct values to write
into GUEST_TSC_SCALE and GUEST_TSC_OFFSET". In that case, I don't see
a particular use for this request in Linux. I would expect it either
in the UEFI or in SVSM. Is this code path explicitly for direct boot
to Linux? If so, did I miss that documentation in this patch series?

> +       /* Initialize the PSP channel to send snp messages */
> +       if (snp_setup_psp_messaging(&tsc_snp_dev))
> +               sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
> +
> +       req.msg_version =3D MSG_HDR_VER;
> +       req.msg_type =3D SNP_MSG_TSC_INFO_REQ;
> +       req.vmpck_id =3D tsc_snp_dev.vmpck_id;
> +       req.req_buf =3D &tsc_req;
> +       req.req_sz =3D sizeof(tsc_req);
> +       req.resp_buf =3D buf;
> +       req.resp_sz =3D resp_len;
> +       req.exit_code =3D SVM_VMGEXIT_GUEST_REQUEST;
> +       rc =3D snp_send_guest_request(&tsc_snp_dev, &req, &rio);
> +       if (rc)
> +               goto err_req;
> +
> +       memcpy(&tsc_resp, buf, sizeof(tsc_resp));
> +       pr_debug("%s: Valid response status %x scale %llx offset %llx fac=
tor %x\n",
> +                __func__, tsc_resp.status, tsc_resp.tsc_scale, tsc_resp.=
tsc_offset,
> +                tsc_resp.tsc_factor);
> +
> +       guest_tsc_scale =3D tsc_resp.tsc_scale;
> +       guest_tsc_offset =3D tsc_resp.tsc_offset;
> +
> +err_req:
> +       /* The response buffer contains the sensitive data, explicitly cl=
ear it. */
> +       memzero_explicit(buf, sizeof(buf));
> +       memzero_explicit(&tsc_resp, sizeof(tsc_resp));
> +       memzero_explicit(&req, sizeof(req));
> +
> +       return rc;
> +}
> +
> +void __init snp_secure_tsc_prepare(void)
> +{
> +       if (!cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
> +               return;
> +
> +       if (snp_get_tsc_info())
> +               sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
> +
> +       pr_debug("SecureTSC enabled\n");
> +}
> +
>  static int wakeup_cpu_via_vmgexit(int apic_id, unsigned long start_ip)
>  {
>         struct sev_es_save_area *cur_vmsa, *vmsa;
> @@ -1493,6 +1569,12 @@ static int wakeup_cpu_via_vmgexit(int apic_id, uns=
igned long start_ip)
>         vmsa->vmpl              =3D 0;
>         vmsa->sev_features      =3D sev_status >> 2;
>
> +       /* Setting Secure TSC parameters */
> +       if (cc_platform_has(CC_ATTR_GUEST_SECURE_TSC)) {
> +               vmsa->tsc_scale =3D guest_tsc_scale;
> +               vmsa->tsc_offset =3D guest_tsc_offset;
> +       }
> +
>         /* Switch the page over to a VMSA page now that it is initialized=
 */
>         ret =3D snp_set_vmsa(vmsa, true);
>         if (ret) {
> diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.=
c
> index 6faea41e99b6..9935fc506e99 100644
> --- a/arch/x86/mm/mem_encrypt_amd.c
> +++ b/arch/x86/mm/mem_encrypt_amd.c
> @@ -215,6 +215,11 @@ void __init sme_map_bootdata(char *real_mode_data)
>         __sme_early_map_unmap_mem(__va(cmdline_paddr), COMMAND_LINE_SIZE,=
 true);
>  }
>
> +void __init amd_enc_init(void)
> +{
> +       snp_secure_tsc_prepare();
> +}
> +
>  void __init sev_setup_arch(void)
>  {
>         phys_addr_t total_mem =3D memblock_phys_mem_size();
> @@ -502,6 +507,7 @@ void __init sme_early_init(void)
>         x86_platform.guest.enc_status_change_finish  =3D amd_enc_status_c=
hange_finish;
>         x86_platform.guest.enc_tlb_flush_required    =3D amd_enc_tlb_flus=
h_required;
>         x86_platform.guest.enc_cache_flush_required  =3D amd_enc_cache_fl=
ush_required;
> +       x86_platform.guest.enc_init                  =3D amd_enc_init;
>
>         /*
>          * AMD-SEV-ES intercepts the RDMSR to read the X2APIC ID in the
> diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
> index cb0d6cd1c12f..e081ca4d5da2 100644
> --- a/include/linux/cc_platform.h
> +++ b/include/linux/cc_platform.h
> @@ -90,6 +90,14 @@ enum cc_attr {
>          * Examples include TDX Guest.
>          */
>         CC_ATTR_HOTPLUG_DISABLED,
> +
> +       /**
> +        * @CC_ATTR_GUEST_SECURE_TSC: Secure TSC is active.
> +        *
> +        * The platform/OS is running as a guest/virtual machine and acti=
vely
> +        * using AMD SEV-SNP Secure TSC feature.
> +        */
> +       CC_ATTR_GUEST_SECURE_TSC,
>  };
>
>  #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
> --
> 2.34.1
>


--=20
-Dionna Glaze, PhD (she/her)

