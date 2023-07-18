Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3E7758612
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 22:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjGRU3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 16:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjGRU3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 16:29:34 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0381992;
        Tue, 18 Jul 2023 13:29:32 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b8b2b60731so34661065ad.2;
        Tue, 18 Jul 2023 13:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689712172; x=1692304172;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OXp67fU1gssYO/GYvhVVlU77b44BA82+qeBTXa8Baio=;
        b=TpZ3QGEiepLb7I3elxVz60+Eo95gqY/2wXVr+tXG6Q/mcRDO8X14lQGO7uuAwchihG
         uu9GLbAwEPdNQXyVSmwBs26w5Pm1N6vViaJbOBNkex/Hv4KJa8TSYcW1MQ92i4YUADNd
         YGuKzaRUQqETLMdZcDUn4hnPC1w8KulU0ppdj6li9MwE4g0oXCqNQonSvBfckVsNd7kG
         nQwA/qN2nNHj5p+CJ93/KXlI8lWxj7g0mfiVac26BofrVYv8C9jl19sIidUSb0OxGUQy
         SlU1bW2coBqZsiRsoxqqpRJds/N5BEk6K/C6ULL8Cya1wGfWmUqv++nb/FgipqDhGNL1
         sfUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689712172; x=1692304172;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OXp67fU1gssYO/GYvhVVlU77b44BA82+qeBTXa8Baio=;
        b=fjNGeEcqaIQN1Zj3HQ9u5Ws/uRJAxH/t/p1msS2SFK/ms7ELFokb21IEJnd3Az0i/C
         /V50Gu7x+hLEKJDGBZ5OK4qLZdV8uuQmb1BiDNksBz9tBUolDJYcLh0vPKOe9fOgwkkc
         /vD5nrLNAtFa8JaryvV1qQou8MxbL7/IVX2bBLCnU2UrhjGpUSKfgeWxkZ6UNZCLjM9Y
         MxPLmXe4nKWAvmD9xWdFH8g6ewKJ0R+MshQNHJRmFHrb2XgBCWY17pWEsiZ/ECTrbp1h
         DKBRusZmGniDatlEOqpv2Q9xKN/dIkXqYo3B0Hj9+9VbLp+rwqxpMnwWyeU+9esMF595
         aKmg==
X-Gm-Message-State: ABy/qLYRGxspKb6dK2LDGKJMbUPHXN5x61MVZUdS3SBOH464T7LV59WJ
        4j5yxSUQZFaJzby0RgIcyJUR98OnuFA=
X-Google-Smtp-Source: APBJJlGDqDyZfoT8x8+QsEmTasjIUTV6ZsjrmkTeEIBgYVR3imqmVvGCnmVFOqklb2y7Xwn/+gceEA==
X-Received: by 2002:a17:903:22ca:b0:1b8:9552:ca with SMTP id y10-20020a17090322ca00b001b8955200camr17399527plg.45.1689712172031;
        Tue, 18 Jul 2023 13:29:32 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id 17-20020a170902c11100b001b9d8688956sm2278266pli.144.2023.07.18.13.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 13:29:31 -0700 (PDT)
Date:   Tue, 18 Jul 2023 13:29:30 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     isaku.yamahata@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        isaku.yamahata@gmail.com, Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>, chen.bo@intel.com,
        Sagi Shahar <sagis@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH] KVM: x86: Make struct sev_cmd common for
 KVM_MEM_ENC_OP
Message-ID: <20230718202930.GB25699@ls.amr.corp.intel.com>
References: <2f296c5a255936b92cffde5e7d6414edfb93f660.1689645293.git.isaku.yamahata@intel.com>
 <20230718193918.rgluetgaiuib662g@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230718193918.rgluetgaiuib662g@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 18, 2023 at 02:39:18PM -0500,
Michael Roth <michael.roth@amd.com> wrote:

> On Mon, Jul 17, 2023 at 06:58:54PM -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX KVM will use KVM_MEM_ENC_OP.  Make struct sev_cmd common both for
> > vendor backend, SEV and TDX, with rename.  Make the struct common uABI for
> > KVM_MEM_ENC_OP.  TDX backend wants to return 64 bit error code instead of
> > 32 bit. To keep ABI for SEV backend, use union to accommodate 64 bit
> > member.
> > 
> > Some data structures for sub-commands could be common.  The current
> > candidate would be KVM_SEV{,_ES}_INIT, KVM_SEV_LAUNCH_FINISH,
> > KVM_SEV_LAUNCH_UPDATE_VMSA, KVM_SEV_DBG_DECRYPT, and KVM_SEV_DBG_ENCRYPT.
> > 
> > Only compile tested for SEV code.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  2 +-
> >  arch/x86/include/uapi/asm/kvm.h | 22 +++++++++++
> >  arch/x86/kvm/svm/sev.c          | 68 ++++++++++++++++++---------------
> >  arch/x86/kvm/svm/svm.h          |  2 +-
> >  arch/x86/kvm/x86.c              | 16 +++++++-
> >  5 files changed, 76 insertions(+), 34 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 28bd38303d70..f14c8df707ac 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1706,7 +1706,7 @@ struct kvm_x86_ops {
> >  	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
> >  #endif
> >  
> > -	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
> > +	int (*mem_enc_ioctl)(struct kvm *kvm, struct kvm_mem_enc_cmd *cmd);
> >  	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> >  	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> >  	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index 1a6a1f987949..c458c38bb0cb 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -562,4 +562,26 @@ struct kvm_pmu_event_filter {
> >  /* x86-specific KVM_EXIT_HYPERCALL flags. */
> >  #define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
> >  
> > +struct kvm_mem_enc_cmd {
> > +	/* sub-command id of KVM_MEM_ENC_OP. */
> > +	__u32 id;
> > +	/* Auxiliary flags for sub-command. */
> > +	__u32 flags;
> 
> struct kvm_sev_cmd doesn't have this flags field, so this would break for
> older userspaces that try to pass it in instead of the struct kvm_mem_enc_cmd
> proposed by this patch. Maybe move it to the end of the struct? Or
> make it part of a TDX-specific union field.

Please notice the padding. We don't have __packed attribute.

struct kvm_sev_cmd {
        __u32 id;
        <<<<< 32bit padding here
        __u64 data;
        __u32 error;
        __u32 sev_fd;
};



> But then you might also run into issues if you copy_to_user() with
> sizeof(struct kvm_mem_enc_cmd) instead of sizeof(struct kvm_sev_cmd),
> since the former might copy an additional 4 bytes more than what userspace
> allocated.
> 
> So maybe only common bits should be copy_to_user()'d by common KVM code,
> and the platform-specific fields in the union should be separately copied
> by platform code?
> 
> E.g.
> 
>   struct kvm_mem_enc_sev_cmd {
>       __u32 error;
>       __u32 sev_fd;
>   }
> 
>   struct kvm_mem_enc_tdx_cmd {
>       __u64 error;
>       __u32 flags;
>   }
> 
>   struct kvm_mem_enc_cmd {
>       __u32 id;
>       __u64 data;
>       union {
>         struct kvm_mem_enc_sev_cmd sev_cmd;
>         struct kvm_mem_enc_tdx_cmd tdx_cmd;
>       }
>   };
> 
> But then we'd need to copy_from_user() for common header, then for
> platform-specific sub-command metadata like sev_fd, then for the
> sub-command-specific parameters themselves.
> 
> Make me wonder if this warrants a KVM_MEM_ENC_OP2 (or whatever) that
> uses the new structure from the start so that legacy constaints aren't
> an issue.

I'm fine with a new ioctl and deprecating the existing one.  I'm looking
for the least painful way to avoid unnecessary divergence.
Not only for creation/attestation, but also for debug, migration, etc in near
future.  Thoughts?
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
