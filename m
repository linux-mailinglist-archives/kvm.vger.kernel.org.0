Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C5A6B4BE2
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjCJQED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjCJQDm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:03:42 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD6BE9CCA
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 07:59:35 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id u4-20020a170902bf4400b0019e30a57694so3081756pls.20
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 07:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678463975;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NNMw7BcXY+4eoUteAKMCyRpwWW6F34CM6NbdoJtrXvg=;
        b=HxJfqAw/cNOSbH71td2XIuQmwMzdPf1kM72mCHii5Te8y5aACDn5IPmEucKsZ166Uy
         2PBu63SvPh+NFSnrFGF5j8VH7HIqn/hajxfNDpIRdwTqUnwReM8lW87EvCC0Ryiu+hJV
         v6LBA1nd5KvHtdaYOYdd6Fn5loE8xN1mK6SIBZcMpj5NFzJn50D6hXbNY4YjUo22SzgO
         PNzpB513noLHve5WtCxGJ9eBKvFc7DZ4VndbSBguq5iV0c7zS1Yv8mlhoV+UEAQqOl+H
         unyMqvMDbc+XiE2kqGes7Pm2IT9KfQJn1ZoIQ9NDk4VQCf3r/LlcTrRsbawACD2o74n4
         Nb7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678463975;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NNMw7BcXY+4eoUteAKMCyRpwWW6F34CM6NbdoJtrXvg=;
        b=CM0scV8ZIxVF657S/9a10zzaum9EpXs/KE9esm1OeLdauOSLH1FsdGIaA286MSOWKT
         naAXXWcEfcX2xEVGKv6Ows6cf/oW35JAFfvYXiGfZHvHrEJYXj0faQctEikEXqA0S3JB
         sr7IxkS08Ac7LDG67+rP3epZTFZK9rLS2PUnyql70J36llyipSYbdhgDNIDqhrSBbZ8d
         25YipfdmnGDbxLdfuDgAzfcadwegJ+guJpxJuvl8KysJ4UU7yTNhGjuFco8djqtAeFnt
         3NVUr/JkMdjIke4UZ7zquxB97e9IZeTKoVCVC8NJO6L5SbH3LGi+aCF9PFoGQEgDKtRK
         DT5g==
X-Gm-Message-State: AO0yUKUliLmtPWMqtGKxKDAQ5WmHRrOCnMlCNWltNtf7ffiEESfFqTuW
        9oRIX8D7FY4Yv72jv1SyDlL6oFXpfmk=
X-Google-Smtp-Source: AK7set88dLaJpwlCHNxB4XMNSfpy1o7txNTRUcT/WGiLUw6pc1zUSoAoU1SNuN4K+Xt8v2VdmsLE96F/vjo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:cd83:0:b0:5e5:7675:88e3 with SMTP id
 o125-20020a62cd83000000b005e5767588e3mr10594502pfg.5.1678463975255; Fri, 10
 Mar 2023 07:59:35 -0800 (PST)
Date:   Fri, 10 Mar 2023 07:59:34 -0800
In-Reply-To: <20230310125718.1442088-2-robert.hu@intel.com>
Mime-Version: 1.0
References: <20230310125718.1442088-1-robert.hu@intel.com> <20230310125718.1442088-2-robert.hu@intel.com>
Message-ID: <ZAtT5pFPqjM1Ocq0@google.com>
Subject: Re: [PATCH 1/3] KVM: VMX: Rename vmx_umip_emulated() to cpu_has_vmx_desc()
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        robert.hoo.linux@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 10, 2023, Robert Hoo wrote:
> Just rename, no functional changes intended.
> 
> vmx_umip_emulated() comes from the ancient time when there was a

No, vmx_umip_emulated() comes from the fact that "cpu_has_vmx_desc()" is
inscrutable for the relevant code.  There is zero reason to require that readers
have a priori knowledge of why intercepting descriptor table access instructions
is relevant to handing CR4.UMIP changes.

If it really bothers someone, we could do

	static inline bool cpu_has_vmx_desc(void)
	{
		return vmcs_config.cpu_based_2nd_exec_ctrl &
			SECONDARY_EXEC_DESC;
	}

	static inline bool vmx_umip_emulated(void)
	{
		return cpu_has_vmx_desc();
	}

but I don't see the point since there is no usage for SECONDARY_EXEC_DESC outside
of UMIP emulation.
