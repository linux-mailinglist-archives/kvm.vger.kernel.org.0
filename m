Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB097272E2
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 01:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbjFGXYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 19:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjFGXYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 19:24:14 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F73A2125
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 16:24:13 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-653496acd69so6180788b3a.2
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 16:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686180253; x=1688772253;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iw3hlPUAwSgfp7KOkFzWzn5gmIR2sBbGleyz7LjbQYw=;
        b=c2yq4GPwtzd9tyExGf3ChnyCOpcujsyOkwcaf0H0m+BP2lEsM0AL+MLNRGiLbOT6b3
         Ow+564d0DlS7dsjajzkXeC4a8bR74QA0hRtZBkusqOvjgZYdvR7+jGnbp0WysczMcBXs
         pCInV+6LOV2mnTzgAGVPyXYy0nGnjubWac8PzLysZMvssmPUup3H+zZfPfzBPXiv8H2c
         TZRn/pck7Tnve4UC/eVx2+pzWQ0Ub8pb4ov0QhqG9wDFDf/VWuTKoKhrjxlKpDLyN6xn
         9ptOxdGpwDVAYAExFs/3GsP2c83nE+iArEHBbWiN2qK+85WbcwHJaBrf1iJeZ5JPKK8z
         dU0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686180253; x=1688772253;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iw3hlPUAwSgfp7KOkFzWzn5gmIR2sBbGleyz7LjbQYw=;
        b=b+vXVSOEDLnRJ55anT5tX6Wd6ucmLAW4AwxFb+KTcc4TLuaprVbSIGRICPj1h0C9lK
         S19g3d5yszczp5lwhVRRlE2xnhKgSpqBSR/tSt5D/FQWTYeAK9y2FFS5XLqQ0ICpldu2
         7NiUiTazBPF6FMslHZdQywK4yIaZUI/D8WIkhPMk91OW1nxhKpJaXhmqid4wwRSpGPo0
         KXcx6HpN2/UABGApqLm9sCcbyGNNEKguRcicei0tieUXtrkUW2qHdG+fWq/SlUZellxp
         gzr83fB9cAWQl219ZmSR9f68h8zdH1s4y8bSvyseYmi6PgCzaDSr85wznS6MPVc9uciK
         qiTg==
X-Gm-Message-State: AC+VfDz+1agTsFIeR7gYY4bsKA2LOFbZDwES6qTjWZCVH19ivXJ0fAhB
        xRJrsiGkkqFymqloqn2QzvRYGowoTyY=
X-Google-Smtp-Source: ACHHUZ7zxvAwEx+omO2tKCspCEv6XQGVuXc8DXI064FTkUHCXY5rVr0JQICm81LAfxPC21HeROrMlB3Rwps=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9a6:b0:654:8c9d:108d with SMTP id
 u38-20020a056a0009a600b006548c9d108dmr3042820pfg.4.1686180252782; Wed, 07 Jun
 2023 16:24:12 -0700 (PDT)
Date:   Wed, 7 Jun 2023 16:24:11 -0700
Mime-Version: 1.0
Message-ID: <ZIERmyVzarYcsWT7@google.com>
Subject: KVM x86 reviews status for 6.5
From:   Sean Christopherson <seanjc@google.com>
To:     seanjc@google.com
Cc:     Binbin Wu <binbin.wu@linux.intel.com>,
        Anish Moorthy <amoorthy@google.com>,
        Zeng Guang <guang.zeng@intel.com>,
        John Allen <john.allen@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Folks on the Cc list, you've posted series series that I haven't reviewed recently,
and may or may not review before the 6.5 merge window, but I pinky swear your
series are on my todo list.  This past month was hectic for non-work reasons and
I got behind on reviews (obviously).  I deliberately prioritized patches/series
that I thought were likely to be ready for 6.5, which meant that your series got
ignored for a while.  Sorry :-(

I have some vacations/holidays coming up, including the rest of this week, and so
reviews will likely be slower than you want for the next 3-4 weeks.  My goal is
to at least do one pass through all of your series before the end of June, though
I've no idea if that's realistic.  Again, sorry for the delays.
