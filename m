Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39218550180
	for <lists+kvm@lfdr.de>; Sat, 18 Jun 2022 03:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383658AbiFRBAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 21:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbiFRBAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 21:00:17 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C6024F20
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 18:00:16 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t3-20020a17090a510300b001ea87ef9a3dso5482564pjh.4
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 18:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ED4T7FRniyzeEhOAGbwENSdE+eyCSBYreP74Jda3he8=;
        b=UqVccnSmV/PyRRg1w6xAUSxnxBghYiM8DZH7ETme5X10pRZGpujmvw/oruXOhVjEQ6
         x3Zu8OMdy0KwPW8FZFqpkUYOv7xVzJiu27w/GgXlnNFSGV3Ni8k/Uwd82oe83qUUQ2Lz
         rseKkK2spvrTeDs9xdPF5mlQA0q9u+NZVK1IFtItFSsbQu+SVWbSo1Vg7TP8HsynVp83
         Wu6Bl/ltHGjIyA/cCL9ToQKKbOdd6C+tjI+eXuh9CrTiEdU/GxSXuEAX/c2Z1AoPxBWO
         aI0WYtFuKH/E5XwwHiwq47l7ge7QTqOowNfOKduc+AY/Ijlq44JmpkbcAiFjWJeKySQy
         ttGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ED4T7FRniyzeEhOAGbwENSdE+eyCSBYreP74Jda3he8=;
        b=LVP6t+emyWvjNf6x6Adt0L7N4Bqm6IlOaRcKJ2RGFwcSHi+ZybzozFCVPY6eMWxc28
         KXL8HwZPgepQhC9QY150G4URVQ9Up+kW3cSCHoAeofBHRDaJlfKatLXu3MT74/oeXUxH
         CrmCMCMfbzlACT3lhNBmVsjctJSLmlIIpmgmnbkK+dFAmj8dxSO6fGP2zesIWakUNlsx
         wzaZTnF4EjnYG3Qk4F8CRSEly2C9WDlxxM1ULpdearLBugailahRlQM9u+XtGhBF1qCk
         999/7emVK7rKt6L5cw02Tm5idKJ44AyWZDm1Ch+dB1lDYBd6e/iLsQaNVWNUrI9gv8Yg
         uvLg==
X-Gm-Message-State: AJIora/aaXP5XE5FJ5LTd6RLJXODHvxgc14lCCfGsDTk/nQsWsp/+QVi
        EE/LWrAOiVgb1bP+FD4Vbh+fMg==
X-Google-Smtp-Source: AGRyM1uoMnfy3U9dOg/LLkLG+CLjVGh/0Mw8cEGB32IY3QFVv+mAxltylgZJj0QT+k9parVD9BfyZg==
X-Received: by 2002:a17:90a:880c:b0:1ea:b0a6:8385 with SMTP id s12-20020a17090a880c00b001eab0a68385mr13691160pjn.142.1655514014835;
        Fri, 17 Jun 2022 18:00:14 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902a40200b0015e8d4eb285sm4119994plq.207.2022.06.17.18.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 18:00:14 -0700 (PDT)
Date:   Fri, 17 Jun 2022 18:00:10 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 04/23] lib: Extend the definition of
 the ACPI table FADT
Message-ID: <Yq0jmuqus141FMqF@google.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-5-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-5-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:55:46PM +0100, Nikos Nikoleris wrote:
> This change add more fields in the APCI table FADT to allow for the
> discovery of the PSCI conduit in arm64 systems. The definition for
> FADT is similar to the one in include/acpi/actbl.h in Linux.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/acpi.h   | 35 ++++++++++++++++++++++++++++++-----
>  lib/acpi.c   |  2 +-
>  x86/s3.c     |  2 +-
>  x86/vmexit.c |  2 +-
>  4 files changed, 33 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index d80b983..9f27eb1 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -62,7 +62,15 @@ struct acpi_table_xsdt {
>      u64 table_offset_entry[1];
>  } __attribute__ ((packed));
>  
> -struct fadt_descriptor_rev1
> +struct acpi_generic_address {
> +    u8 space_id;            /* Address space where struct or register exists */
> +    u8 bit_width;           /* Size in bits of given register */
> +    u8 bit_offset;          /* Bit offset within the register */
> +    u8 access_width;        /* Minimum Access size (ACPI 3.0) */
> +    u64 address;            /* 64-bit address of struct or register */
> +} __attribute__ ((packed));
> +
> +struct acpi_table_fadt
>  {
>      ACPI_TABLE_HEADER_DEF     /* ACPI common table header */
>      u32 firmware_ctrl;          /* Physical address of FACS */
> @@ -100,10 +108,27 @@ struct fadt_descriptor_rev1
>      u8  day_alrm;               /* Index to day-of-month alarm in RTC CMOS RAM */
>      u8  mon_alrm;               /* Index to month-of-year alarm in RTC CMOS RAM */
>      u8  century;                /* Index to century in RTC CMOS RAM */
> -    u8  reserved4;              /* Reserved */
> -    u8  reserved4a;             /* Reserved */
> -    u8  reserved4b;             /* Reserved */
> -};
> +    u16 boot_flags;             /* IA-PC Boot Architecture Flags (see below for individual flags) */
> +    u8 reserved;                /* Reserved, must be zero */
> +    u32 flags;                  /* Miscellaneous flag bits (see below for individual flags) */
> +    struct acpi_generic_address reset_register;     /* 64-bit address of the Reset register */
> +    u8 reset_value;             /* Value to write to the reset_register port to reset the system */
> +    u16 arm_boot_flags;         /* ARM-Specific Boot Flags (see below for individual flags) (ACPI 5.1) */
> +    u8 minor_revision;          /* FADT Minor Revision (ACPI 5.1) */
> +    u64 Xfacs;                  /* 64-bit physical address of FACS */
> +    u64 Xdsdt;                  /* 64-bit physical address of DSDT */
> +    struct acpi_generic_address xpm1a_event_block;  /* 64-bit Extended Power Mgt 1a Event Reg Blk address */
> +    struct acpi_generic_address xpm1b_event_block;  /* 64-bit Extended Power Mgt 1b Event Reg Blk address */
> +    struct acpi_generic_address xpm1a_control_block;        /* 64-bit Extended Power Mgt 1a Control Reg Blk address */
> +    struct acpi_generic_address xpm1b_control_block;        /* 64-bit Extended Power Mgt 1b Control Reg Blk address */
> +    struct acpi_generic_address xpm2_control_block; /* 64-bit Extended Power Mgt 2 Control Reg Blk address */
> +    struct acpi_generic_address xpm_timer_block;    /* 64-bit Extended Power Mgt Timer Ctrl Reg Blk address */
> +    struct acpi_generic_address xgpe0_block;        /* 64-bit Extended General Purpose Event 0 Reg Blk address */
> +    struct acpi_generic_address xgpe1_block;        /* 64-bit Extended General Purpose Event 1 Reg Blk address */
> +    struct acpi_generic_address sleep_control;      /* 64-bit Sleep Control register (ACPI 5.0) */
> +    struct acpi_generic_address sleep_status;       /* 64-bit Sleep Status register (ACPI 5.0) */
> +    u64 hypervisor_id;      /* Hypervisor Vendor ID (ACPI 6.0) */
> +}  __attribute__ ((packed));
>  
>  struct facs_descriptor_rev1
>  {
> diff --git a/lib/acpi.c b/lib/acpi.c
> index 9b8700c..e8440ae 100644
> --- a/lib/acpi.c
> +++ b/lib/acpi.c
> @@ -46,7 +46,7 @@ void* find_acpi_table_addr(u32 sig)
>  
>  	/* FACS is special... */
>  	if (sig == FACS_SIGNATURE) {
> -		struct fadt_descriptor_rev1 *fadt;
> +		struct acpi_table_fadt *fadt;
>  
>  		fadt = find_acpi_table_addr(FACP_SIGNATURE);
>  		if (!fadt)
> diff --git a/x86/s3.c b/x86/s3.c
> index 89d69fc..16e79f8 100644
> --- a/x86/s3.c
> +++ b/x86/s3.c
> @@ -30,7 +30,7 @@ extern char resume_start, resume_end;
>  
>  int main(int argc, char **argv)
>  {
> -	struct fadt_descriptor_rev1 *fadt = find_acpi_table_addr(FACP_SIGNATURE);
> +	struct acpi_table_fadt *fadt = find_acpi_table_addr(FACP_SIGNATURE);
>  	struct facs_descriptor_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
>  	char *addr, *resume_vec = (void*)0x1000;
>  
> diff --git a/x86/vmexit.c b/x86/vmexit.c
> index 2bac049..fcc0760 100644
> --- a/x86/vmexit.c
> +++ b/x86/vmexit.c
> @@ -206,7 +206,7 @@ int pm_tmr_blk;
>  static void inl_pmtimer(void)
>  {
>      if (!pm_tmr_blk) {
> -	struct fadt_descriptor_rev1 *fadt;
> +	struct acpi_table_fadt *fadt;
>  
>  	fadt = find_acpi_table_addr(FACP_SIGNATURE);
>  	pm_tmr_blk = fadt->pm_tmr_blk;
> -- 
> 2.25.1
>

Reviewed-by: Ricardo Koller <ricarkol@google.com>
