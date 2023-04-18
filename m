Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB9D6E67B1
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 17:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbjDRPAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 11:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbjDRPAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 11:00:47 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E657930F4
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 08:00:45 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-94f6c285d92so159172466b.3
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 08:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1681830044; x=1684422044;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gso+9cGhKjaR7/vNs46c4snLBCtF6RkjI43Ml0RKEu8=;
        b=ix3MftKjRLsRMW8FRYc8xMWEXJ97hEtZS3GHbInGLhgNclB2P/PQJSb6fc4QD+AYeo
         VuzPArbmrfBHdFNrZxchbFwnCkT9PGWSgCPL9V8F9XsqeVD3aDqha1klwLnzd11KT7lY
         2zm6sjRkvve5Nq9ksySXTP2plvGq2o50E5Mb7MY/FtdCQUmK5mQx2+VrSxTi0IPuGXQq
         bQTAmRBGxkmj1+s5qWf9glwbgsCm00s5dehNztPMaGzYxBA59Q6jSNqpzIBVCRYuEqfC
         H//vm1/KUjNDLfOR7ns0cNzTxHgFN1nmWFNviF8pJRsqy+cINyVI1S0x098NdGU8oeNg
         cCxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681830044; x=1684422044;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gso+9cGhKjaR7/vNs46c4snLBCtF6RkjI43Ml0RKEu8=;
        b=QtUkbOTaJece4i27Q4k/uvLkV39qLsLCpprsyN20gRM6cLfoWdzj1Aw3xODu+yAbPk
         C9+/UX2LTOe9YHmS536jifhs7leeUnhwh5WyQmvT4v1hlCKxEOIX3tGkL/t7ekZhrDFV
         VdQW5+CKMx20vm5MMpgaWURMWVMHbVvLWAM47j4eThkwHgou1OL8K7s6wZHW+I/0EfGC
         Zbw2olOtT8RFw11hNImZXxedNsH/yyyqg7NCUYO2NLeGaQZ94RN94yCanba4CWP/aH22
         iU1uKlc3bANiNDs9YSqHFZK6okxkA6oOubVktM6pl4u3DV/8AhSyp5Y5uEW/XFpur+Lj
         nQ1w==
X-Gm-Message-State: AAQBX9eWKQJMXjCEhEjM0WJyKKB1D3qq53yMb/nnOWD1nIKO1r91e85v
        cRIE4pW0Ud+fSwBk+xabTw0zHfmjc2pq8vfeVAU=
X-Google-Smtp-Source: AKy350bTbjE+6vKylwK6xDVZLQXU7KC4bYc2Kp5maLKIT2fow3sBjEVc9p5Et6xJhdOiblJBi5XcVg==
X-Received: by 2002:aa7:cfd3:0:b0:504:ae7d:9e50 with SMTP id r19-20020aa7cfd3000000b00504ae7d9e50mr2569859edy.36.1681830044273;
        Tue, 18 Apr 2023 08:00:44 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id bo25-20020a0564020b3900b005067d129267sm6171195edb.39.2023.04.18.08.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 08:00:43 -0700 (PDT)
Date:   Tue, 18 Apr 2023 17:00:42 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Ben Dooks <ben.dooks@codethink.co.uk>
Cc:     kvm@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH kvmtool 2/2] riscv: add zicboz support
Message-ID: <ub3varg6spvwh5ihma4ossabuvbuvyxst63pra7rm2lfrkychf@4olgfsvgnij2>
References: <20230418142241.1456070-1-ben.dooks@codethink.co.uk>
 <20230418142241.1456070-3-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418142241.1456070-3-ben.dooks@codethink.co.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 18, 2023 at 03:22:41PM +0100, Ben Dooks wrote:
> Like ZICBOM, the ZICBOZ extension requires passing extra information to
> the guest. Add the control to pass the information to the guest, get it
> from the kvm ioctl and pass into the guest via the device-tree info.
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  riscv/fdt.c                         | 11 +++++++++++
>  riscv/include/asm/kvm.h             |  2 ++
>  riscv/include/kvm/kvm-config-arch.h |  3 +++
>  3 files changed, 16 insertions(+)

Hi Ben,

I have a patch almost identical to this one here

https://github.com/jones-drew/kvmtool/commit/f44010451e023b204bb1ef9767de20e0f20aca1c

The differences are that I don't add the header changes in this patch
(as they'll come with a proper header update after Linux patches get
merged), and I forgot to add the disable-zicboz, which you have.

I was planning on posting after the Linux patches get merged so
I could do the proper header update first.

Thanks,
drew


> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index 3cdb95c..fa6d153 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -20,6 +20,7 @@ struct isa_ext_info isa_info_arr[] = {
>  	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
>  	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
>  	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
> +	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
>  };
>  
>  static void dump_fdt(const char *dtb_file, void *fdt)
> @@ -46,6 +47,7 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
>  	const char *valid_isa_order = "IEMAFDQCLBJTPVNSUHKORWXYZG";
>  	int arr_sz = ARRAY_SIZE(isa_info_arr);
>  	unsigned long cbom_blksz = 0;
> +	unsigned long cboz_blksz = 0;
>  
>  	_FDT(fdt_begin_node(fdt, "cpus"));
>  	_FDT(fdt_property_cell(fdt, "#address-cells", 0x1));
> @@ -95,6 +97,13 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
>  					die("KVM_GET_ONE_REG failed (config.zicbom_block_size)");
>  			}
>  
> +			if (isa_info_arr[i].ext_id == KVM_RISCV_ISA_EXT_ZICBOZ && !cboz_blksz) {
> +				reg.id = RISCV_CONFIG_REG(zicboz_block_size);
> +				reg.addr = (unsigned long)&cboz_blksz;
> +				if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> +					die("KVM_GET_ONE_REG failed (config.zicboz_block_size)");
> +			}
> +
>  			if ((strlen(isa_info_arr[i].name) + pos + 1) >= CPU_ISA_MAX_LEN) {
>  				pr_warning("Insufficient space to append ISA exension\n");
>  				break;
> @@ -116,6 +125,8 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
>  		_FDT(fdt_property_string(fdt, "riscv,isa", cpu_isa));
>  		if (cbom_blksz)
>  			_FDT(fdt_property_cell(fdt, "riscv,cbom-block-size", cbom_blksz));
> +		if (cboz_blksz)
> +			_FDT(fdt_property_cell(fdt, "riscv,cboz-block-size", cboz_blksz));
>  		_FDT(fdt_property_cell(fdt, "reg", cpu));
>  		_FDT(fdt_property_string(fdt, "status", "okay"));
>  
> diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
> index 92af6f3..e44c1e9 100644
> --- a/riscv/include/asm/kvm.h
> +++ b/riscv/include/asm/kvm.h
> @@ -52,6 +52,7 @@ struct kvm_riscv_config {
>  	unsigned long mvendorid;
>  	unsigned long marchid;
>  	unsigned long mimpid;
> +	unsigned long zicboz_block_size;
>  };
>  
>  /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> @@ -105,6 +106,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_SVINVAL,
>  	KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
>  	KVM_RISCV_ISA_EXT_ZICBOM,
> +	KVM_RISCV_ISA_EXT_ZICBOZ,
>  	KVM_RISCV_ISA_EXT_MAX,
>  };
>  
> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> index 188125c..46a774e 100644
> --- a/riscv/include/kvm/kvm-config-arch.h
> +++ b/riscv/include/kvm/kvm-config-arch.h
> @@ -24,6 +24,9 @@ struct kvm_config_arch {
>  	OPT_BOOLEAN('\0', "disable-zicbom",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOM],	\
>  		    "Disable Zicbom Extension"),			\
> +	OPT_BOOLEAN('\0', "disable-zicboz",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOZ],	\
> +		    "Disable Zicboz Extension"),			\
>  	OPT_BOOLEAN('\0', "disable-zihintpause",			\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHINTPAUSE],\
>  		    "Disable Zihintpause Extension"),
> -- 
> 2.39.2
> 
