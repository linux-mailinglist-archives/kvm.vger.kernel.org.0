Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDA6508DD5
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 18:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380805AbiDTQ6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 12:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359073AbiDTQ6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 12:58:34 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077691C924
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 09:55:48 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id c64so3074296edf.11
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 09:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vUTv+50MNanSPxQdcGK+5r6sVmuK08fgNGG0Mf/jqBI=;
        b=iaqM1FoiEMcdthoIscB4EGxWnfhv/7xjyGKn4gIYpZHRrZPFYv2bhDYEqwxTUUPq3f
         MBxFAQIxeQGYEDY3oK29YT38KSDuW3cHq8JkOpdd4sAuedKILI1Ug1iJ1a1kl9I8P6mD
         Y5dRhiHuMdLNpXQOZFC1pxLJVGLOjllNv/t/zpRTHgqsu+YKyZnrtZesTx4Lnhup2nbU
         5VNDjtGqnI7R/JkhaEOkFnXoIkSP9OXMsnNzUJQ3KKLbePthP8+NBRw3HM3upPsJn1aI
         Fc7SnEGGItiNTvVn+7JEsg1baMxX5uzfKSee2UM61YtwsD/ll2+J5Jk1RFF1JsnIsliO
         ruYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vUTv+50MNanSPxQdcGK+5r6sVmuK08fgNGG0Mf/jqBI=;
        b=4JqtGa5IPwzORPClApbtX4St7H59HO1QI6XsznyguZkkcxCut5J/tH9PCZGM2L/SSv
         7jRs3NfnH73ae7E/qKj1qplvqDnREBx9NxWtKG2lEN7NGNPNkDm64ME+nFDJyJG6lth8
         7ID+3ulw71xE89poZGnKBIPWdC2lt+x30f7YmN/VLiKamLyfE9EK5qkKJxTmLHD+dNAj
         /M9ljqJ0KrdkRhp4DmNPRDXBu973Bs/PwpBj176qAlMmj1E5GbrClnyJ64GPpTkPwfBb
         a3gtBXrQIbZsKrjJbjIL7bOaFn44kSZfTpvjS51dryACsBaB72Xw0ew9xW4JjAyQ1x/H
         ITcw==
X-Gm-Message-State: AOAM531oyjg/T8FvW3Zxbsy9felk/0n2VE0zWgFGWJer2XpGPlu9MYdq
        wuE5F2RB1d2DQ0R9+9X4ajL3Dtc/8QWM8Q==
X-Google-Smtp-Source: ABdhPJwZN16RiJ3cGzzLbJpClyclGhaHPFmT1JB/AMEONy3NRQjyx8rtnJoF85sLehdmloUKBwbWAw==
X-Received: by 2002:a05:6402:2711:b0:423:ef0d:aa86 with SMTP id y17-20020a056402271100b00423ef0daa86mr15314652edd.262.1650473746365;
        Wed, 20 Apr 2022 09:55:46 -0700 (PDT)
Received: from google.com (30.171.91.34.bc.googleusercontent.com. [34.91.171.30])
        by smtp.gmail.com with ESMTPSA id s20-20020a056402015400b00418f9574a36sm10182331edu.73.2022.04.20.09.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 09:55:46 -0700 (PDT)
Date:   Wed, 20 Apr 2022 16:55:43 +0000
From:   Quentin Perret <qperret@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 06/17] KVM: arm64: Implement break-before-make
 sequence for parallel walks
Message-ID: <YmA7D7DyY7MDfli4@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-7-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415215901.1737897-7-oupton@google.com>
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

On Friday 15 Apr 2022 at 21:58:50 (+0000), Oliver Upton wrote:
> +/*
> + * Used to indicate a pte for which a 'make-before-break' sequence is in

'break-before-make' presumably :-) ?

<snip>
> +static void stage2_make_pte(kvm_pte_t *ptep, kvm_pte_t new, struct kvm_pgtable_mm_ops *mm_ops)
> +{
> +	/* Yikes! We really shouldn't install to an entry we don't own. */
> +	WARN_ON(!stage2_pte_is_locked(*ptep));
> +
> +	if (stage2_pte_is_counted(new))
> +		mm_ops->get_page(ptep);
> +
> +	if (kvm_pte_valid(new)) {
> +		WRITE_ONCE(*ptep, new);
> +		dsb(ishst);
> +	} else {
> +		smp_store_release(ptep, new);
> +	}
> +}

I'm struggling a bit to understand this pattern. We currently use
smp_store_release() to install valid mappings, which this patch seems
to change. Is the behaviour change intentional? If so, could you please
share some details about the reasoning that applies here?

Thanks,
Quentin
