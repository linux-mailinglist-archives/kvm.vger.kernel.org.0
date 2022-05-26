Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1B8535561
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 23:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245289AbiEZVX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 17:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiEZVX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 17:23:57 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803254C7AA
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:23:55 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 137so2319290pgb.5
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vvPesztQ/q6dEXTjjwBXmVDKox8pNCXxacGyk70E8Dg=;
        b=O4Suc8kizeWKRTVEj00AQ1ab9tKe753MhatLcEm4PLJvR7M2irU2Jhg3tvLufHtFe2
         P372DMirqt4jci9WjNyvM9cItpc06Y1Oemg9rpCOMC1yhCL5UbaJKlCswW1LxyaJ2lcY
         3K3ZfGy4ADMSjJTrr851Wi3IOdcM/LTiR3Fegd/SfSuO5F12Md1ZGbhUh02eR+JCSAP9
         JxaYCZ/0rV2R84RitJ5hQIS9iQ5K0gdZ3+YEDqOtpzc+/itaW5VU/mX5uRK8eRCFmkTv
         5JOapOgYyLDqHAnofnwQiy1nTThhruJcCMUh6UbmhnBjqTHwn+QsuSF3ZAmtz+axA0Td
         qe7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vvPesztQ/q6dEXTjjwBXmVDKox8pNCXxacGyk70E8Dg=;
        b=3p0TSQ9gEr2vVQrZdv9jaPQmjjIeJMQNVln2DHPMO+vDIr3YCbkCaAoiuBpElUYpVo
         8kn7+GNGMF7LZF/T8UFvGEtpYIWFz+nq3uwfGwVKfMiBozjHbN/z+cnqk6KY5TvGP08L
         gZUZ77nWz4KudExlMUpzGjbTdU3KunHmrObA1M/UrQMbzCyuvPfpspOpFQQ2zczZBajU
         qr/YalLny8v4+QZ8e0LW8NAAH3Lq5ffdonA3ttm8NTXjaX7dZzqCKXOzAf2lLarKHYXC
         ZM4QTDqngeG8QBhVI5dE7FcLYNQtDh1TH49Ahj4PHYzJdREJB8fkc8/uQhKn6Xy8EQsl
         uiaw==
X-Gm-Message-State: AOAM532cmyWuPbdxUv4sqAg3cVbveyydu3sBMxYQ5F4uKVX+e11ZJ24M
        KgIDBkAF02u7ZxBdwybBp8tXQg==
X-Google-Smtp-Source: ABdhPJz9Vr7FWCttsYRDC5bTCdZ3cRPMlWGSkHHLq+nHl5wH2QNI/o0qZvP8Ms2laDVTyIDnOXLgcA==
X-Received: by 2002:a05:6a00:10cc:b0:506:e0:d6c3 with SMTP id d12-20020a056a0010cc00b0050600e0d6c3mr40747339pfu.33.1653600234842;
        Thu, 26 May 2022 14:23:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o3-20020a654583000000b003fa5b550303sm1986625pgq.68.2022.05.26.14.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 14:23:54 -0700 (PDT)
Date:   Thu, 26 May 2022 21:23:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dan Cross <cross@oxidecomputer.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] kvm-unit-tests: configure changes for illumos.
Message-ID: <Yo/v5tN8fKCb/ufB@google.com>
References: <20220526071156.yemqpnwey42nw7ue@gator>
 <20220526173949.4851-1-cross@oxidecomputer.com>
 <20220526173949.4851-3-cross@oxidecomputer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526173949.4851-3-cross@oxidecomputer.com>
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

In the future, please tag each new posting with a version number, e.g. no version
number for the first posting, than v2, v3, v4, etc... for each subsequent posting.
It took me a while to figure what was what.

On Thu, May 26, 2022, Dan Cross wrote:
> Warn, don't fail, if the check for `getopt -T` fails in the `configure`
> script.
> 
> Aside from this check, `configure` does not use `getopt`, so don't
> fail to run if `getopt -T` doesn't indicate support for  the extended
> Linux version.  Getopt is only used in `run_tests.sh`, which tests for
> extended getopt anyway, but emit a warning here.

Why not simply move the check to run_tests.sh?  I can't imaging it's performance
sensitive, and I doubt I'm the only one that builds tests on one system and runs
them on a completely different system.
