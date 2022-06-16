Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99FC54E8C8
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 19:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbiFPRrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 13:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiFPRrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 13:47:31 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE04B70
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 10:47:30 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id g186so1902520pgc.1
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 10:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s+xYDL6GokyuWIDSk9dqiyAkvL0R7+pughdFGhd5kfw=;
        b=hsITBdVcsSHfWzgOAcnc904OYzCtPLLSewhfgSaPiUJIKqt1eJV7UDmuoS+c22Hx8I
         uh0ThDM+Sndm88Tfs6T6FSrs7JqS6Wt6b1kKFr2/XoxjhLvekqCxnxd3qml+dnj7s+45
         v/ajUVMAL0qAFKIjhy2uALKG6EhzdsYSJu3ZhZMwem9CDr9L+T1vrqfE6TepcyMCShUg
         gwIXQ26Nsjgimv8plaCSyi9P0pAr/ngh0DclG9xz5ygKeLSIMzX92fTS1fdI1PrdtV4m
         taJzL7Jg8onoYrzCNryPvo72nd5lng7flKXyJ+ccCgYXSu3otZWpjS2Sx8JEyEtTbf9M
         n5Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s+xYDL6GokyuWIDSk9dqiyAkvL0R7+pughdFGhd5kfw=;
        b=1bVfDlEMojtgkmCo9+YOGpCY/e7grSSgpCEhUWMT/6Ea2Rc+HootbFQNlPrxyu142z
         cnyAxk6RbLsaHft1lXgdFi3BnxBQZzLNjC3gOnRHj1OxuutItF2tD48A/eT0Ark7Aj/R
         gMA1EBFWf5gFyaO6+ja+rWImWxkzy/kCOGsmtI118zrXwXnVi6yTZTYRax4AUz70M2Yq
         g8/V07yRp6i9YinHN7iCVtKzkwNG10Z/oua7wiht1+hJw2v1nLE5eLM7CCy1APtFqkSF
         PPmtMpjeUZE0pRuGENqwnTsPdnO2srO1NiAwCyuoAEUDwLqu0iuKblvKe53wMMHLypxY
         iC4g==
X-Gm-Message-State: AJIora9KSWSW87k0FE/3hgCGcj78V+uduhBFUS6B0j0gmlcTwOtFAKSR
        sYG8w9mmqIGUpVf+Nozpd6M3eeIRfHyaEw==
X-Google-Smtp-Source: AGRyM1vs+GWhZhlvLQNX2HqgrFSA3tHA61UwQFSziB3v6SMT5fk1VQVq35AuocxZNgQK543DVPcy6A==
X-Received: by 2002:a63:3184:0:b0:3fc:5893:c866 with SMTP id x126-20020a633184000000b003fc5893c866mr5510725pgx.56.1655401649776;
        Thu, 16 Jun 2022 10:47:29 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id q4-20020a170902f78400b001641670d1adsm1944287pln.131.2022.06.16.10.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 10:47:28 -0700 (PDT)
Date:   Thu, 16 Jun 2022 17:47:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 2/5] KVM: Shove vcpu stats_id init into kvm_vcpu_init()
Message-ID: <YqtsrEMf2poEmBcq@google.com>
References: <20220518175811.2758661-1-oupton@google.com>
 <20220518175811.2758661-3-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518175811.2758661-3-oupton@google.com>
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

On Wed, May 18, 2022, Oliver Upton wrote:
> Initialize the field alongside other kvm_vcpu fields. No functional
> change intended.

Same complaints as the previous changelog.

> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  virt/kvm/kvm_main.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 36dc9271d039..778151333ac0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -440,6 +440,10 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
>  	vcpu->ready = false;
>  	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
>  	vcpu->last_used_slot = NULL;
> +
> +	/* Fill the stats id string for the vcpu */
> +	snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d",
> +		 task_pid_nr(current), id);
>  }
>  
>  static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
> @@ -3807,10 +3811,6 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  	if (r)
>  		goto unlock_vcpu_destroy;
>  
> -	/* Fill the stats id string for the vcpu */
> -	snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d",
> -		 task_pid_nr(current), id);
> -
>  	/* Now it's all set up, let userspace reach it */
>  	kvm_get_kvm(kvm);
>  	r = create_vcpu_fd(vcpu);
> -- 
> 2.36.1.124.g0e6072fb45-goog
> 
