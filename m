Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5AB62601C
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 18:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbiKKRI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 12:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234308AbiKKRI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 12:08:29 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07E185451
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 09:07:49 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b11so4935426pjp.2
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 09:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LICHPg6UnYkTNsPkbQmwYKBGSoVvJ3ggmuJEwwsBdfE=;
        b=XZlbgoFLBfg1b1W761+z1PDAgEb20H2QO0ci+u5UoReXW/AglYt37kfLNyiRzXCbun
         16a/vNSD6OLG51wXjymdIRV5K9+yHSAOu082YpoTDDKE/vWKWzBoXD0ip80QsNnXeMJr
         XUiBolJ/U5H4SS51K9h10zFLgGeuRJ3ETLcS/qaSX/VswfZGD0HWGQophC9d+8et+N8D
         Rcu5KGn6L35gbiXzVxNNzg/1YqsSpk7Imvy500y3L07kqkpPLt+0VZ5sct2ejFIWJ747
         3+UH3Cce+XE9LjmMHIqul5KXKnZHUHLmRehpGUfslQ2VrfCosOP4gZwFjBB/ttBcN/Ae
         9vMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LICHPg6UnYkTNsPkbQmwYKBGSoVvJ3ggmuJEwwsBdfE=;
        b=7AtDFsU1Df43mbmIbM4o+VcgUjemjlGBTj0GaOf5kv/EH//oRIh9uIAkdNl5eOeq5I
         BPL3omIar8iQPAM8ammOtl3BsIrHo5J71lHjYFbaCqrMq0YgEa/jJhHAjeroCrjHJExL
         T23HTABWkbDL1PWa8Xn1tm74NJqem4vrYHYJJwSgrsr+FDXBHR+lC6u5IwGb0YOaFl5h
         cBq+PnKXfuBSLXPyd1QC83CdL/JmF2/ZXar28RsopCkDC1bgo5OHpgnu9kj3ABrgvaoh
         JaIVV17jWPonP0SwJ2s5EYidg3cCNugA5VZuMBmkk758Hf/95hednQMvZgmZwq6hcI20
         FP/A==
X-Gm-Message-State: ANoB5pki8LT3+TEjqBpvyGnxJUftczImXuYZPAeKjyfNGocTKSO05o77
        cBJKtYtXxI3wCyIzdk1HYto+mA==
X-Google-Smtp-Source: AA0mqf5Uo+YykjZZDEd2A/F0GfL+xhYTbei/GO+GSdCfD2x/gs2dZlHf5v1zmNbQnCxh9OBRghbP8A==
X-Received: by 2002:a17:90b:4b50:b0:213:5c5f:f440 with SMTP id mi16-20020a17090b4b5000b002135c5ff440mr2919822pjb.15.1668186460347;
        Fri, 11 Nov 2022 09:07:40 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f18-20020a63e312000000b004582e25a595sm1591902pgh.41.2022.11.11.09.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 09:07:39 -0800 (PST)
Date:   Fri, 11 Nov 2022 17:07:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, zhenyuw@linux.intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH v2 2/3] drm/i915/gvt: switch from track_flush_slot to
 track_remove_slot
Message-ID: <Y26BV9a9q8nBz/+7@google.com>
References: <20221111103247.22275-1-yan.y.zhao@intel.com>
 <20221111103436.22381-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111103436.22381-1-yan.y.zhao@intel.com>
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

On Fri, Nov 11, 2022, Yan Zhao wrote:
> KVMGT only cares about when a slot is indeed removed.
> So switch to use track_remove_slot which is called when a slot is removed.

This should capture the original motivation, i.e. that the existing
->track_flush_slot() hook is theoretically flawed.  I think it also makes sense
to call out that KVMGT undoubtedly does the wrong thing if a memslot is moved,
but that (a) KVMGT has never supported moving memslots and (b) there's no sane
use case for moving memslots that might be used by the guest for the GTT.

Bonus points if you can figure out a way to capture the restriction in the docs,
e.g. somewhere in gpu/i915.rst?

Lastly, provide a link to the original discussion which provides even more context.

Link: https://lore.kernel.org/all/20221108084416.11447-1-yan.y.zhao@intel.com

> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
