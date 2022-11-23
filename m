Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D3A63689B
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 19:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239531AbiKWSWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 13:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239655AbiKWSV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 13:21:58 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C0510062
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 10:21:58 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d6so3869948pll.7
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 10:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EOflPjojb2oEhr9a1ZiX3WNyVjYu6zRCRTBjoU8oGMk=;
        b=DtWSUFddTgCLCvQhSUegEw1PtYRAMg7gVD65aZn0+4UrhSB3tMHNvK/uhjKSqWR7nV
         Vx7z3lCSNrEHnIB6P5mN0rINBqWkz6BepoWzoAadhScONPsppWrc8JO/MFQWD5yq/TNX
         sT0bLiUl88WIGGugsimy6g/jgkF9fS/1hZ8MHp0ket6lIqO9wua515LcHc0/g8WwPjfx
         6v9Q1G2IoNxz4ibebqO1nlSs+I9s/XF7Cw1bMz0nD2utxwD5QWhq6JUw/VFwBlidYeWY
         AY0yNDAFsiNWywStAQiPoK4cej5ruY1j/AilQOXeNcuOhxytU4ogGftZnWSl9O46dcBW
         jwbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EOflPjojb2oEhr9a1ZiX3WNyVjYu6zRCRTBjoU8oGMk=;
        b=D+HYbqlbhVH8gs4olI2lC8N0oPs7qo4tC7jJEBqChpTvTOqCQpnj0HgBZrsUXD5Lae
         Xd8yExYBQlUhwJ0z63GUiC7Si5asyJShKMkX2b92KE/Ezj7ottMKAWtjL9kQ9LoEXijn
         /QYyFnHBWRM+wTAoZZ7bLt3QSJJyAXf2U4QRuNSaXWvirejiCOc+W/5Dt/ISjr6sWXke
         YV3bNIhGzn+H2sxBX9lAwAiip2DslPdv5/fLP7tMp9Kpg6e7nOrxPNFyxiYyhtYryr08
         HstwfB/zvwce9olttJQGRw634LMN3aG/iPqpBR0QGHAxPEslTeoJLeFhbR4ocA/w28OT
         hfJQ==
X-Gm-Message-State: ANoB5pkfZZW9XT+y1XriETij0lydRSq+gC1nyJJVIEDxrAEjXKaZoxLH
        iaOhL/3x1F3NRf/b+YWz+zRm0w==
X-Google-Smtp-Source: AA0mqf7O8VQOdaMNISKxj4Yj2moONZC/e38RX7ElIwkKwMLmcTx8FeTTdmGvtGJ0C+fVHQzUoeSFbQ==
X-Received: by 2002:a17:90a:8904:b0:218:93e8:800f with SMTP id u4-20020a17090a890400b0021893e8800fmr23659700pjn.136.1669227717441;
        Wed, 23 Nov 2022 10:21:57 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 21-20020a17090a195500b00218b47be793sm1738317pjh.3.2022.11.23.10.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 10:21:56 -0800 (PST)
Date:   Wed, 23 Nov 2022 18:21:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        mhal@rbox.co
Subject: Re: [PATCH 2/4] KVM: x86/xen: Compatibility fixes for shared
 runstate area
Message-ID: <Y35kwZeS1pXGLNFg@google.com>
References: <20221119094659.11868-1-dwmw2@infradead.org>
 <20221119094659.11868-2-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221119094659.11868-2-dwmw2@infradead.org>
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

On Sat, Nov 19, 2022, David Woodhouse wrote:
> +		/*
> +		 * Use kvm_gpc_activate() here because if the runstate
> +		 * area was configured in 32-bit mode and only extends
> +		 * to the second page now because the guest changed to
> +		 * 64-bit mode, the second GPC won't have been set up.
> +		 */
> +		if (kvm_gpc_activate(v->kvm, gpc2, NULL, KVM_HOST_USES_PFN,
> +				     gpc1->gpa + user_len1, user_len2))

I believe kvm_gpc_activate() needs to be converted from write_lock_irq() to
write_lock_irqsave() for this to be safe.

Side topic, why do all of these flows disable IRQs?
