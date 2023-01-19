Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9DD674143
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 19:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjASSuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 13:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjASSt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 13:49:58 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A47E94CBF
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 10:49:55 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id r18so2253053pgr.12
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 10:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xNVXfWTFHPUTtkdhJd1rvFQYW6suzNo+IYrlxBerVjw=;
        b=JCfzsF2f0L14x6DnDb97ikzDMd+kmDUm+hY4g0ikovS6VCInjBWJHaf/91emjlkbvv
         7wIBq95BwSi0sYX+qpZD/SDvgq6Rh0mChGWHNsKn3x3hLmQ8FzFzJ8/ZbJBpvglwgQ4P
         DCgQbf4DC/hZmnSwoV0J3qJIQ2CUCL3azLbW7iE8ZYMMJf7aB+WsETKfdqrzzfEJ6ojU
         vsPAh6PoOnotNaQto+c0+ylg5pDTEUWQjzlqfqHA4n+xq9Aj/eYU3tjl8BclPsCxy96X
         tvpdUK9qzbs7kasSXAsdoo6MSNp8cPe7grioN6SM05rjDR6+YxuYdpreH2mSGn1YnH2i
         7GNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xNVXfWTFHPUTtkdhJd1rvFQYW6suzNo+IYrlxBerVjw=;
        b=4ObWZMRUaVsb6Ys0QOs2pSsn9fvQXFo3h4qC7ocUa5x1OJTapDV5O96IrEphe5vgE4
         ZJG0ouGOQmSEcn6J5lRufIvueDhZRo1Cs4d9Af3nK5YQMBHqpNkbhkW2o5mPBl/MSgvN
         xhq/c1uPxICPw2k1BWaWS7khOfRguoCyW/MHcVltTmCCHq306M67brsxuGPgMyAsjKs/
         tHrgZnxreFEQpNFj5RaysPdMiLJs5Jv4xgRhHM71tQ9ZPl6LVXevFrztrYycBI4QaArn
         0O997RSeaIVuCW523B7LbBHd7d1gEOIzrr5M58eCJwsbDioVDs65HGSKAGDm9Vy81uHU
         +qpw==
X-Gm-Message-State: AFqh2kq2vDaeab3UIUveU8Gbde93BFmUbu0JdenNraV+oBGTLAY883tF
        slLGy340RPuj1x7cyA1UsljImVKBRt2Nc8ArKlv/zgJy9hzq8ld4
X-Google-Smtp-Source: AMrXdXs6HTI9i0wEtQHX5RB47auesuGHCq06fYXVQ7aeMwYLK4yjX/E0p+7CcZlE0F4L6rvrtuk8H7gqPyauTnlR1T4=
X-Received: by 2002:a63:d455:0:b0:478:ae53:a299 with SMTP id
 i21-20020a63d455000000b00478ae53a299mr956491pgj.260.1674154194728; Thu, 19
 Jan 2023 10:49:54 -0800 (PST)
MIME-Version: 1.0
References: <20221214194056.161492-1-michael.roth@amd.com> <20221214194056.161492-63-michael.roth@amd.com>
In-Reply-To: <20221214194056.161492-63-michael.roth@amd.com>
From:   Dionna Amalie Glaze <dionnaglaze@google.com>
Date:   Thu, 19 Jan 2023 10:49:43 -0800
Message-ID: <CAAH4kHZVaeL57bGAzeDjJDTumsnb96iAYBdhm7cs_8TjBg+v3w@mail.gmail.com>
Subject: Re: [PATCH RFC v7 62/64] x86/sev: Add KVM commands for instance certs
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com
Content-Type: text/plain; charset="UTF-8"
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

> +
> +       /* Page-align the length */
> +       length = (params.certs_len + PAGE_SIZE - 1) & PAGE_MASK;
> +

I believe Ashish wanted this to be PAGE_ALIGN(params.certs_len)

-- 
-Dionna Glaze, PhD (she/her)
