Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C469B4F40D1
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 23:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239085AbiDEOsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 10:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392123AbiDENtf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 09:49:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A25A18B17
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 05:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649163035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A5b+w65mVbXKq6dEAbOyYZM+EvVbPrS55cyS76jwFZE=;
        b=JqE4R7Yede/Zvd1xeIGmsGPR7eMnfBZqvb5HCX5jR4thS1siVOQbRUlxLSk1zVzvn9Arge
        QA7ksmQM1n+MZSRS27Gw8hQ6T5OKMQAed2+sznk2KRXL1zJwsjlRry5l1OGGNLIoE+A1Fs
        yWTl6kcMvvql9cs3udBlyr98yFHKz5I=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-8CA1z4hGOD-sQjM-unMjRA-1; Tue, 05 Apr 2022 08:50:33 -0400
X-MC-Unique: 8CA1z4hGOD-sQjM-unMjRA-1
Received: by mail-qv1-f72.google.com with SMTP id kd20-20020a056214401400b00443c252b315so7949873qvb.23
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 05:50:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=A5b+w65mVbXKq6dEAbOyYZM+EvVbPrS55cyS76jwFZE=;
        b=RktEWVEel0fQkf9/abBt1fAJDIw44rPjFZhp8uxRkTqK+YbiMgWgK0Te9Dy5Nllml2
         jpYuFDA6i6OUXS6F8bFN8GAtLEKgJennzO3jx5asLA3sSlsQBRbB02MDc8y2uujBtH3i
         +oahR2SbWXz2a/JjNU/cIyHOcy213H0dYOVYlzptXE3orgEmFPNSiiTssexmrERGGALr
         R2stkBnICmmx9DMcJSyoCnv1kS7LmT6zqoARjTSQ/BiKj19zmCq4FWTuaE3XEqNdgRAX
         ZI28bkYQ3CE0yogEzUAvZTjRGciAiixUI5c6aktumILqZK9YODh4LcuhE4Q1M9mmFEEk
         eWig==
X-Gm-Message-State: AOAM531mCHk7MEpOsDvSTQDdwJRs9q+SGirxtpG0osnOka5p1u1RxrXT
        ETW6bAcqwv6OuHPivKapbp7zIeSoKG5Ne9Y2rw/vrDTOffjOKwXXnVicpENlel3ZxUt63z83Ws2
        BwrHu4n2Sxk2D
X-Received: by 2002:a05:622a:110c:b0:2e1:fe6b:2f26 with SMTP id e12-20020a05622a110c00b002e1fe6b2f26mr2688569qty.201.1649163033058;
        Tue, 05 Apr 2022 05:50:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9rs3iZkx6SjlmcZnhmwryofOpCAR7v1nmWCw1NRcHMbAcvtV6PD8wIxzqdnAPm55RFYl7Fg==
X-Received: by 2002:a05:622a:110c:b0:2e1:fe6b:2f26 with SMTP id e12-20020a05622a110c00b002e1fe6b2f26mr2688551qty.201.1649163032773;
        Tue, 05 Apr 2022 05:50:32 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id r21-20020a37a815000000b0067d15afb9ebsm8178681qke.90.2022.04.05.05.50.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 05:50:32 -0700 (PDT)
Message-ID: <9c6e6892-7c0c-124c-b534-8b7c3c6dafb5@redhat.com>
Date:   Tue, 5 Apr 2022 14:50:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 025/104] KVM: TDX: Add place holder for TDX VM
 specific mem_enc_op ioctl
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <156ab9c6979c4b70e3d0d76e55e3aba370f58cea.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <156ab9c6979c4b70e3d0d76e55e3aba370f58cea.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add a place holder function for TDX specific VM-scoped ioctl as mem_enc_op.
> TDX specific sub-commands will be added to retrieve/pass TDX specific
> parameters.
> 
> KVM_MEMORY_ENCRYPT_OP was introduced for VM-scoped operations specific for
> guest state-protected VM.  It defined subcommands for technology-specific
> operations under KVM_MEMORY_ENCRYPT_OP.  Despite its name, the subcommands
> are not limited to memory encryption, but various technology-specific
> operations are defined.  It's natural to repurpose KVM_MEMORY_ENCRYPT_OP
> for TDX specific operations and define subcommands.
> 
> TDX requires VM-scoped, and VCPU-scoped TDX-specific operations for device
> model, for example, qemu.  Getting system-wide parameters, TDX-specific VM
> initialization, and TDX-specific vCPU initialization.  Which requires KVM
> vCPU-scoped operations in addition to the existing VM-scoped operations.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/uapi/asm/kvm.h       | 11 +++++++++++
>   arch/x86/kvm/vmx/main.c               | 10 ++++++++++
>   arch/x86/kvm/vmx/tdx.c                | 24 ++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h            |  4 ++++
>   tools/arch/x86/include/uapi/asm/kvm.h | 11 +++++++++++
>   5 files changed, 60 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 71a5851475e7..2ad61caf4e0b 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -528,4 +528,15 @@ struct kvm_pmu_event_filter {
>   #define KVM_X86_DEFAULT_VM	0
>   #define KVM_X86_TDX_VM		1
>   
> +/* Trust Domain eXtension sub-ioctl() commands. */
> +enum kvm_tdx_cmd_id {
> +	KVM_TDX_CMD_NR_MAX,
> +};
> +
> +struct kvm_tdx_cmd {
> +	__u32 id;
> +	__u32 metadata;
> +	__u64 data;
> +};

Please include some initial documentation here already, for example it 
is not clear what "metadata" is.

Also please add

	u32 error;
	u32 unused;

for two reasons: 1) consistency with kvm_sev_cmd 2) error codes should 
be returned to userspace and not just sent through pr_tdx_error.

Paolo

