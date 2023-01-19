Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3166743D6
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjASU7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjASU5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:57:05 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D8A50857
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:56:15 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id k16-20020a635a50000000b0042986056df6so1540370pgm.2
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zk9KJnE1A7lhWU0C7MvYLc6jOxM08TZgOey6mX4Smzg=;
        b=nZt9DAoZEySVyEixexvzeY38lvyxKBnwTFPIS6nWtSv/gDJqzuRcOmE1P6LbYrR0/9
         sMZh2AlbnvjwttNVqKwF9rbB3NKdBaQdhK23rupYIW7FSZySRmFZxS70/YUb/5DLNuF6
         pclF6GzJuOxf/ZtqzQ5TEnnwgFRf9qJpIa1S37DfeUrm4Jlx8FG6Wswz2JYhQrvuI0XF
         eG7X0nbHKkdsnF89gUHe9qhW2IubGc9N4NsjicAmrOYlNoxpK29tffx3b2eLmHXSwxhy
         j8MuAQ7O/CptGDGXmfX97i7V//eGI0LlAMBS6u1AuFGagyVa4s3wc403tmx2S5QBoVtO
         DICw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zk9KJnE1A7lhWU0C7MvYLc6jOxM08TZgOey6mX4Smzg=;
        b=bO2i0OV0wekV2t2BgQHnqkcqeBvDJM0Hpu8VuuoHi1h5tD22I97dmDqflqeiVQ7YMc
         B3yDdgMj2K6mhA122gDBudfdaWeAv7+rPoGAHD6xMKDXeVZVveOBpU0Or9k225MUweES
         srX86iCk7OD54ZPNDd+2Xg7Qs8mfbqGGKMf2viuqi7dVRMXn/WqC3XJE/raUk90H30e0
         RG4bAwCSTAhx7rgM5KGSCTOXybFYSjg/NcDzJ+ormAuq2R0TfJupx2t5PXp8XvXDFJh3
         oM1LPq1mFrybbUe+R4NwuH0RLj4MyR/MqTPV4wzqO0vZX1eoEF6INze6CY6XBtdvTHXh
         5hwg==
X-Gm-Message-State: AFqh2kqtkVNfhkN92jhKQsK0Xq+hqD9rc1Hw1N6++355qA8e/7SvlnBG
        rf7QE5d5x0VnwY6AO1NEMiePNaSBQgQ=
X-Google-Smtp-Source: AMrXdXundl4oH8jVJqUdu+8GLuF90NkPKHG4Z3K3JieInSAQW9dS7JqUMEwAjFcydOVRxQjP27p03rJ9uJY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9dc4:0:b0:58d:b0fa:b063 with SMTP id
 g4-20020aa79dc4000000b0058db0fab063mr1102878pfq.73.1674161775011; Thu, 19 Jan
 2023 12:56:15 -0800 (PST)
Date:   Thu, 19 Jan 2023 20:54:06 +0000
In-Reply-To: <20230105100204.6521-1-jiangshanlai@gmail.com>
Mime-Version: 1.0
References: <20230105100204.6521-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167408804665.2363885.5468519542988858072.b4-ty@google.com>
Subject: Re: [PATCH] kvm: x86/mmu: Rename SPTE_TDP_AD_ENABLED_MASK to SPTE_TDP_AD_ENABLED
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 05 Jan 2023 18:02:03 +0800, Lai Jiangshan wrote:
> SPTE_TDP_AD_ENABLED_MASK, SPTE_TDP_AD_DISABLED_MASK and
> SPTE_TDP_AD_WRPROT_ONLY_MASK are actual value, not mask.
> 
> Remove "MASK" from their names.
> 
> 

Applied to kvm-x86 mmu, thanks!

[1/1] kvm: x86/mmu: Rename SPTE_TDP_AD_ENABLED_MASK to SPTE_TDP_AD_ENABLED
      https://github.com/kvm-x86/linux/commit/6458637fa09a

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
