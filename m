Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129E06B32BD
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 01:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjCJAWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 19:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjCJAWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 19:22:43 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F11115B4D
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 16:22:42 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id v11so3862842plz.8
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 16:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678407762;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S91Q0HvdQ0d6KHM8Vz6BzGKrWTaoNy0yXwQOYOAWz3g=;
        b=VKgs1Pkbb31Zg6eMoCWc3uEZGgTbEPUKY+1fO1GbBxvxHrbe2nab6IexXipuD6+8T0
         GBfYHNlXBe/9TIXXxAwY2bqAb9Yp7E1gQ4js80OR8mL03f0epGlkqPm/Pe5alEFQuT26
         /a9LbtSQ7z5ZZHjkSOOfaqxeIaMgBMCDH9B+6TOL5HouehTgwt+wroDP8+hrbgGmqL8q
         tGYkd7a3XRsRU+FXmwvsu61kqUS4I8JVA5wr96wMSAaoL2nkyG3CVnhz9d5nluBLBwD+
         rwdzWumOMVHVwJsCpu0Ws/DTv/TEpp+H7bLQ+QmjeWrBuxpel4G9wTNOF5RyoVAIWpoH
         rXwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678407762;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S91Q0HvdQ0d6KHM8Vz6BzGKrWTaoNy0yXwQOYOAWz3g=;
        b=W7IcSCtHGIqu6cpRFvHJlK87PkTIDhj1zFKeMDOLePeMxEZi70mTNHs0/IfqTiPABI
         6IHs6q3yDRPyLZUs7jBscMQg0z6Hev1qhkMK6YJ4OBZtsAPrBjRbBKghoutL3uXXqC9+
         JITgUM6t5auW/3l7GypXTvNUpmxph68HsdjOSLYYwSOwRZC+2HGOMTHwcM71FZj+TKFr
         hbjTWzDWQm4wwRSE59oB/mLUDP7C83sPD6an/xyuIAyjZkn/zd50qZJM10HfSfFlhwTQ
         HbubB8ld4/LnMSx9aSvH2KbMBOKhjKm1g6pXs1GrWjF+5AeWVazpjXEVXBVRWdg6GrCy
         Q1Sg==
X-Gm-Message-State: AO0yUKUbFrrnY1OZPGYdBRpwLfJ4sEhL2qguVTIH9WJMnb3Ge2TUlb5n
        1r6bwVJrgP2BGhdDSpYrTaOkiQ==
X-Google-Smtp-Source: AK7set9zHC3ge5z8JWID3D9dRbVnBvOi6EYyIUMmc0x/6KG3a2crBwvMPxTR5xYptaJxHWANHYgIew==
X-Received: by 2002:a17:903:18d:b0:19a:eb93:6165 with SMTP id z13-20020a170903018d00b0019aeb936165mr31929472plg.22.1678407761494;
        Thu, 09 Mar 2023 16:22:41 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id ik14-20020a170902ab0e00b001994fc55998sm190188plb.217.2023.03.09.16.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 16:22:40 -0800 (PST)
Date:   Thu, 9 Mar 2023 16:22:37 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 03/18] KVM: x86/mmu: Track count of pages in KVM MMU
 page caches globally
Message-ID: <ZAp4Tb8MYoggn/Rb@google.com>
References: <20230306224127.1689967-1-vipinsh@google.com>
 <20230306224127.1689967-4-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306224127.1689967-4-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023 at 02:41:12PM -0800, Vipin Sharma wrote:
>
>  static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  {
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
> -	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> +	mutex_lock(&vcpu->arch.mmu_shadow_page_cache_lock);
> +	mmu_free_sp_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> +	mutex_unlock(&vcpu->arch.mmu_shadow_page_cache_lock);

Is this lock necessary (even when the shrinker is hooked up)?
mmu_free_memory_caches() is only called when KVM fails to create a vCPU
(before it has been added to vcpu_array) or during VM destruction (after
the VM has been removed from vm_list).
