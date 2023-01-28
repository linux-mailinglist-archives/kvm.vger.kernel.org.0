Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA6367F29F
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 01:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbjA1AGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 19:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjA1AGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 19:06:20 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818D88717D
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 16:06:19 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id r126-20020a632b84000000b004393806c06eso2796605pgr.4
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 16:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UoBXGNyHS8VSlGwyH24PBy3LiUpM7j95hK4CPmoboMo=;
        b=gfVdO9VMiW0XGf2NY9slCD+xg6P87ql5hYRPUiwqCzX+kIVmA8+dRcjYpbFDarxq6E
         HlyjmxuG4zp/XoOhco+EMo01ah2Y6eyDor41wTZ5OreB5ZWscpF0JlaY7Yo39yI6WNJf
         m6SEFPQ2aHONs+FGaGw8OpUI9R3ErfAqvpIhSWIXX9EERsbUPAyLLZzjAnO+weGCOp6u
         01fzOLHAITB8ycwo0NUpCoLiRibEeh1Fa4UtVZkIiVX98fdrmCmcKCGsnYTsBhWyEjby
         mm5eiSRgeeOiwIfRcIfi6JzuKFRxVuU5uncSKrVAcrOYWwuiJfC+KMOEaJWagbAG9TBx
         2WrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UoBXGNyHS8VSlGwyH24PBy3LiUpM7j95hK4CPmoboMo=;
        b=hduWWqTfEWLqA4QspLhOtaRJPsWVAzYm5AdhZF+ERaSdx+9IpyRCwH/hV9cW3DTF5J
         TasLb34Avc+9vrLAqhCdl/HJQv4mYhSIYm966cWFNVQQXkJSqxcRdmCvoKr38SbxKFGP
         Z0J5ZmlHvjElXPXSY5045tWPJYq7xp/Q4TFb9osnU7m0nHwJ0/t3krrDS0Yk0fiOnwo2
         +LGrbPuvnlLDSESsmIQC9JntH+ferlkmcfvVl7xTKfSTfKarLZjM7tldtkKaI9Zlo+kM
         N1vg+ecmamBWDY+ygVoS+SIhVzeS4tRhwVGewR+ESSwjEOLTvB1/wPCSbw4FgYxdNjZJ
         ggWg==
X-Gm-Message-State: AFqh2kr6hjI/nCG4OH7BQQ5fQ6yVttfYUe7INhyrsL9NLi7X9lzVCOS5
        VtF072U3WtBzJez8PfV5srLD5oE1UV0=
X-Google-Smtp-Source: AMrXdXtUCOjJ76PKa4ftdjizrS/4JFMcUqZv8WAN2YI0XFNoFeJ9dUNzwYw+asU1JemGkWcIDZ23jsORf68=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9c0c:b0:227:213d:4564 with SMTP id
 h12-20020a17090a9c0c00b00227213d4564mr4606147pjp.50.1674864378987; Fri, 27
 Jan 2023 16:06:18 -0800 (PST)
Date:   Sat, 28 Jan 2023 00:05:51 +0000
In-Reply-To: <202211161718436948912@zte.com.cn>
Mime-Version: 1.0
References: <202211161718436948912@zte.com.cn>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <167458628707.3464739.1003587396919853689.b4-ty@google.com>
Subject: Re: [PATCH linux-next] KVM: x86: Replace IS_ERR() with IS_ERR_VALUE()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, ye.xingchen@zte.com.cn
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Wed, 16 Nov 2022 17:18:43 +0800, ye.xingchen@zte.com.cn wrote:
> Avoid type casts that are needed for IS_ERR() and use
> IS_ERR_VALUE() instead.
> 
> 

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Replace IS_ERR() with IS_ERR_VALUE()
      https://github.com/kvm-x86/linux/commit/2eb398df77a1

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
