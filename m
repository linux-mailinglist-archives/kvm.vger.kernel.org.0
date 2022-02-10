Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A154B12C6
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 17:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244207AbiBJQas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 11:30:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240006AbiBJQas (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 11:30:48 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59689104
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:30:49 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id k60-20020a17090a4cc200b001b932781f3eso2235930pjh.0
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FCP9EbLIafjzx7R6eEh9ibrAmCiN7Nkf1rKloBcoF1A=;
        b=U2+K0rEi8FzpS7Wgpg8P5ZBveDxGcJZ+AlpksYXFTxV+X7QGIvKSk2oKCbwY0e8Ohv
         b1vFjjsj3YDd/CJ7gxdW2ExSDqo6wXq/tqorohBYQFJ6FOIH/f1TAB6awL5YJKcFZo0a
         9F7HeG0wE9plg0Wh7WeUoxbC0T26aB3UHuH8CVPXpednVM2PKx2/607eLrk2JtAlXXDR
         FK93MymYkeK9cOUaIBKzn2qeqpMlumlJbnpIVahn8V3rAF0XW47a0iICwBMoodrYX5dL
         u+sQxMKXquYc83heeg80UBnM1+r8Sr+rtEqH+g7XBOFAvDRPfLailGW5fbb0VlZki3GI
         mqDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FCP9EbLIafjzx7R6eEh9ibrAmCiN7Nkf1rKloBcoF1A=;
        b=dWKalJNw2HfTGs2fkQRbrJwdDsHxY3YA5wOTXqb73MNu5YVObCndExiTcBxm8lekQi
         PTA1Wfv+0yanr823hLd89dSFIMs50DzH22nKG/YxGKvSLC+/dQJJnQ+KJqZ95o146iob
         hF3lddrtwp3SqcrdpbWZe1MRNVoqz07/k7quEF7QkrjIqAf2os4PRvBRHTIIpTw3OaFn
         Xbh9GynlOidFE7HprlmljexFdxHDL2mrFyF9a7m4OhDMko77kUiKePHj48q1sOgvZLB7
         nOhHVd8o/MIYcQCY42UXPMyj1K/uqGMDCjIqo5YLLYfF74OULJfmzHU1SfX3Wg9PNzyK
         zdOQ==
X-Gm-Message-State: AOAM532BPPPYP65aL+wEPWNYj7Rg4B7I2hI/xMWMyaNUJTWhv8eZENju
        9YPVrjHPleYoVCFq+53nioQN4A==
X-Google-Smtp-Source: ABdhPJxICxckKvyvsEho/d3cAEom107MxxsYxKaroolXYTaEmj2hvgN0Mlywx4org9fBRpLwZ5MugQ==
X-Received: by 2002:a17:90b:3146:: with SMTP id ip6mr3684694pjb.208.1644510648735;
        Thu, 10 Feb 2022 08:30:48 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id pj4sm2961045pjb.43.2022.02.10.08.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 08:30:47 -0800 (PST)
Date:   Thu, 10 Feb 2022 16:30:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zhenzhong Duan <zhenzhong.duan@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] x86 UEFI: Fix broken build for UEFI
Message-ID: <YgU9tBiSdF1u1+c7@google.com>
References: <20220210092044.18808-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210092044.18808-1-zhenzhong.duan@intel.com>
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

On Thu, Feb 10, 2022, Zhenzhong Duan wrote:
> UEFI loads EFI applications to dynamic runtime addresses, so it requires
> all applications to be compiled as PIC (position independent code).
> 
> The new introduced single-step #DB tests series bring some compile time
> absolute address, fixed it with RIP relative address.
> 
> Fixes: 9734b4236294 ("x86/debug: Add framework for single-step #DB tests")
> Fixes: 6bfb9572ec04 ("x86/debug: Test IN instead of RDMSR for single-step #DB emulation test")
> Fixes: bc0dd8bdc627 ("x86/debug: Add single-step #DB + STI/MOVSS blocking tests")
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> ---

Hrm.  It would be nice if we could enabled -fPIC by default for tests that support
it, having to compile twice is going to be annoying...

Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>
