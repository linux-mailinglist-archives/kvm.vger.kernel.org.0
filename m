Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B15610D3C
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 11:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiJ1J37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 05:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiJ1J3o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 05:29:44 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365A3CE09
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 02:29:42 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id d26so11549616eje.10
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 02:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bKzHROW3HlqVHFCQVYEIAGQO/GEF/7B37Q2yOLqpTPE=;
        b=acC1NH65fUHn+22X/MVKkVYc6pCCpJTS8anQGCsKRR7fejXeE/X/BY4MQTQbrUdYrO
         /zUDL5rfOXVPoIOi8aQmru/rBDm35rwQwnz/LEPthxbjGv12PZRu6dTLUQWjHCKAKKWj
         xlHubTSrs2IyVpI4UAFd2z726R+FG7O9NVFYXgEOqGvPgy9i+TU18+pgkEviSlWRiRUU
         IaUWJ+wIL0pcMH0UvivkifftNqQ/+DwbVtbi71Sb28s8K08Tn0hb9w8hXyUDRZWWt/Ez
         /icWm4QkaL/d2N01KarCI6JZZvh0yQ/vg3bPraCUQl6fx3wropNkioqoRMYbFm0eKMGJ
         v0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bKzHROW3HlqVHFCQVYEIAGQO/GEF/7B37Q2yOLqpTPE=;
        b=HNh9sEofn8QAkXdaQGWDJ4aId3mza73svhdbjsBSu1/aq6y7KpyaxoZnEQSpOTprWh
         G8uTwMOkYmWx2CrnG+/PgoUk+ZUWViuKo7BtQW1heXxCwUAzt5/oOjL7BkWQ3prREMxf
         8dnCvK0bF/LhxLsufnv0mw+4TzPR0sfK6THnYV9BsnNuHxCzbLCRe8TypvCr9Me1InRI
         Gj2HH2SQdJm/r+5SgMB+yU3qIfRKp1HqFr4a5BJiAtpJFOQ4TyJXFNevBxTulUUkex+V
         e8xoLpEYHyk3LHgvRXoYedimmvc9TD3Hw9emJRV2+pQbhsA1B22w08xu+trqAbnB2mRX
         1V5Q==
X-Gm-Message-State: ACrzQf1SCnI6Hg9/3j5md70To2dm+/gVhIYe/ESnbyVuSshYOwKjpp9P
        umnAVnatId8AzFd1Ktj5zOAQvQ==
X-Google-Smtp-Source: AMsMyM4PKCzkFjNUPVQTRmDdJVp41feWg/IGBeQ3XOnOrubUEl8MuW8Vq2rx6HtRpjEyThZ6kj50Ng==
X-Received: by 2002:a17:907:2c75:b0:78d:c201:e9aa with SMTP id ib21-20020a1709072c7500b0078dc201e9aamr46266130ejc.235.1666949380721;
        Fri, 28 Oct 2022 02:29:40 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id r18-20020a17090609d200b0078d38cda2b1sm1819419eje.202.2022.10.28.02.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 02:29:40 -0700 (PDT)
Date:   Fri, 28 Oct 2022 09:29:37 +0000
From:   Quentin Perret <qperret@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>, Marc Zyngier <maz@kernel.org>,
        kernel-team@android.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 02/25] KVM: arm64: Allow attaching of non-coalescable
 pages to a hyp pool
Message-ID: <Y1uhAbK5EiQz58iJ@google.com>
References: <20221020133827.5541-1-will@kernel.org>
 <20221020133827.5541-3-will@kernel.org>
 <Y1sfpM3IjNvr8ckf@google.com>
 <Y1uOOGUMDlJ2tu2M@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1uOOGUMDlJ2tu2M@google.com>
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

On Friday 28 Oct 2022 at 08:09:28 (+0000), Oliver Upton wrote:
> On Fri, Oct 28, 2022 at 12:17:40AM +0000, Oliver Upton wrote:
> > Assuming this is kept as-is...
> > 
> > This check reads really odd to me, but I understand how it applies to
> > the use case here. Perhaps create a helper (to be shared with
> > __find_buddy_nocheck()) and add a nice comment atop it describing the
> > significance of pages that exist outside the boundaries of the buddy
> > allocator.
> 
> Sorry, I'm a moron. The check in __find_buddy_nocheck() is of course
> necessary and irrelevant to the comment I've made above. But maybe I've
> proved my point by tripping over it? :-)

A comment won't hurt for sure, I'll add that for the next version.

Cheers!
Quentin
