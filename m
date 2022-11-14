Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82ED56286CE
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 18:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237653AbiKNRSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 12:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237724AbiKNRSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 12:18:32 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CE1FFB
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 09:18:30 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id f3so4387327pgc.2
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 09:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GRUSa5sLz6yNeqgJTF0fl+2UL9ZnGvehQ2TBEFQaBQY=;
        b=HKEsoxZmn2O3qvMJX9DyUGB6FfyB8Js/3A1G8wrXAN6P6/7VhmTDmPc/B7FsVupXP4
         +mZ4YnfYKrjEotyGXRkofYuoDuMoUSvMm7Ox7vbEN+UJo3wU5V4M8uQq6zMTRpwwopF3
         XoQsBq/uUrZZ1hbgfpGuCLEhDE0Gdlf85IS2JiLhnSYugCPJMW2I6cI/Q2mKcFVusuan
         CbCpgL6OWzqP7mGnuz2V1mm4vaGtKfe0Bw7PmdNuaU+z1168IM8LTe6U7WDt8OaTzItI
         nABVZf3zAdXGzQGiJ8y4K+VH7xdMMMfYiNYe8F12mgqbYPc4rsvmPwyXc6ZFDlaCWymM
         JxDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GRUSa5sLz6yNeqgJTF0fl+2UL9ZnGvehQ2TBEFQaBQY=;
        b=O7tzUU3n/U1J0I0whNnwZLVH9flXxZGAOvnQo2uISPF/X8MKbE0PE4omuzZoeSMHBd
         LPZSDKSpnS/mMwY+NZKmDN610kZuUnEzfar/I1/7ntVekM6RHrhq7ieOnGeB4M6hMgqA
         ewyHc557cUIlheDTE4iYEAdBMr93b+C9X5j8tNUaH1Lh4L6FUX+qgjLROsy1569P1ttO
         S+SOiVxLNG8XPrjWG3ibe5/+hmUOF2muvpxEyGzEh7JR+ruzcNkGj1wyv1QgmGOIWjut
         l0kdxoHqdILj0IMv8qHcR1nCzlPi+Ijp/4M3xgkypfVLCSCndTx/UcTejmTdQ8n+ott1
         Hxkw==
X-Gm-Message-State: ANoB5pmM7HADZsMdXGD+rYnJPrGQjgaQmAYl+a0gbXkszHKSAMhVWLkW
        +ldfSqwQxRMB9vkl8ICbxEVweA==
X-Google-Smtp-Source: AA0mqf66O9meI8VPBHt4JF2Gq0UqRgtUgwOuYp764aPPqySRZvOBNszpSso4d56GBCJrTADm/Ox7Qw==
X-Received: by 2002:a63:717:0:b0:476:8f1c:13b3 with SMTP id 23-20020a630717000000b004768f1c13b3mr3780975pgh.458.1668446310351;
        Mon, 14 Nov 2022 09:18:30 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a30-20020aa78e9e000000b0056c702a370dsm6935729pfr.117.2022.11.14.09.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 09:18:29 -0800 (PST)
Date:   Mon, 14 Nov 2022 17:18:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     wangjianli <wangjianli@cdjrlc.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virt/kvm: Replace "unsigned" with "unsigned int"
Message-ID: <Y3J4YqiJemzz1Nrg@google.com>
References: <20221113064633.32294-1-wangjianli@cdjrlc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221113064633.32294-1-wangjianli@cdjrlc.com>
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

On Sun, Nov 13, 2022, wangjianli wrote:
> Replace "unsigned" with "unsigned int"
> 
> Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
> ---
>  virt/kvm/irqchip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> index 58e4f88b2b9f..eefea6a650fb 100644
> --- a/virt/kvm/irqchip.c
> +++ b/virt/kvm/irqchip.c
> @@ -38,7 +38,7 @@ int kvm_irq_map_gsi(struct kvm *kvm,
>  	return n;
>  }
>  
> -int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
> +int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned int irqchip, unsigned int pin)

I'm all for opportunistically cleaning these up, but IMO it's not worth churning
code just to fix use of bare unsigned.  And if we are going to fix them, fix them
_all_, and fix the prototypes, e.g. from just a few relevant declarations:

int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin);  <=====

int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
		bool line_status);
int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
		int irq_source_id, int level, bool line_status);
int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
			       struct kvm *kvm, int irq_source_id,
			       int level, bool line_status);
bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin);  <=====

void kvm_notify_acked_gsi(struct kvm *kvm, int gsi);
void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);  <=====
