Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D817992F2
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 01:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345221AbjIHX55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 19:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345234AbjIHX55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 19:57:57 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76FB133
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 16:57:50 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-26f6ed09f59so3256234a91.1
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 16:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694217470; x=1694822270; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7uIYG+nLope62BZraEl1dGlvLTb6/dt25z9HbvHirJU=;
        b=RH6Axu6Y1pjSyUp/Zw4+8evje5n4bam9iishYNEIOI4+OT7tQULSl3+Cq8nRNpF7jH
         JU5JZGAWcz/CsZtWmxcVVF3aRhUfOt+Nf+uAtLPRvN6M0dbQUEGUsTu3xyBFquS1zQMx
         SfXXhGAw69M9XvXxYrMz82s1i2aLM1xSgYT+9+GIN/fXF0JVDEagcNqUor3y3CWQ1Xbp
         xKnwrs0L9F82ou3qom5/EbMC7RHXdxQh+i3e3yTzLwWiaxWdY+jMQKgMVZszgeXPrHEq
         e14W84BBTABj0036OtXhkdQJPtre4qICgbM+a+qr80k0xp8yJrD2pqDciwZjRReJV0rV
         8KsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694217470; x=1694822270;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7uIYG+nLope62BZraEl1dGlvLTb6/dt25z9HbvHirJU=;
        b=sVKODQifKFA0nrhAbGmeu5OcwLeApiAXeL8K9osjOzIunZbCEX1WFy44G1tsDHNSFA
         RyLKla8w4xCIbsSEqhBIvkqvPsbWrBPCqfeUnZCpNBtc9c3d5q81XwUfShYdxaxKLNqy
         Z/t3Gq8N9RnEjwbGZJb2kXtOgQWtkuOcxkcd0gecpWL0VMwkDl3Kwyt5QrgvwuIEpjqc
         2tE6TejBtniAMW68HfJGLZp2655fJSdC7znH37RJcI1tFGws+BEci2YxAOQtF05KAxAK
         /Haa7mSvH5wIZZ7LpTZQYglv1dVGIRDDBNq96pGtQsiB5cb+LMGQ06zxZpeSqNqlbxiF
         UasQ==
X-Gm-Message-State: AOJu0YypPUqW5euAWoq+wU9sTu/pLwzj6ZFHegMyK93ghBQZWAtPNVKE
        QIdU1uF6lYR2Zl3v41kKhXVjdx6bJkU=
X-Google-Smtp-Source: AGHT+IGOduCypdMHrewnjkwc2pJMM36JJvakmRjZ4E49rexv6nYdn4l7KvNQRhkbNt8CfLhwBJHI+gLk6Cs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:dc05:b0:26d:ae3:f6a4 with SMTP id
 i5-20020a17090adc0500b0026d0ae3f6a4mr981180pjv.5.1694217470364; Fri, 08 Sep
 2023 16:57:50 -0700 (PDT)
Date:   Fri, 8 Sep 2023 16:57:49 -0700
In-Reply-To: <20230829132727.ne5xzb7uv2wnrjif@amd.com>
Mime-Version: 1.0
References: <cover.1689893403.git.isaku.yamahata@intel.com>
 <21e488b6ced77c08d9e6718fcf57e100af409c64.1689893403.git.isaku.yamahata@intel.com>
 <ZLqVdvsF11Ddo7Dq@google.com> <20230722003449.664x3xcu6ydi2vrz@amd.com>
 <ZN/wY53TF2aOZtLu@google.com> <20230826005941.c7gtsootdaod7ek3@amd.com> <20230829132727.ne5xzb7uv2wnrjif@amd.com>
Message-ID: <ZPu0/fxg1E0Yi4Gt@google.com>
Subject: Re: [RFC PATCH v4 07/10] KVM: x86: Add gmem hook for initializing
 private memory
From:   Sean Christopherson <seanjc@google.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>, David.Kaplan@amd.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 29, 2023, Michael Roth wrote:
> So we need to be able to deal with that even for 'well-behaved' guests.
> With RMP-init-during-mapping-time approach I had some checks that avoided
> creating the 2MB RMP entry in this mixed case which is why I didn't need
> handling for this previously. But it's just one extra #NPF(RMP) and can
> be handled cleanly since it can be distinguished from spurious cases.

Just to make sure you're not waiting on me for something, the TL;DR is that my
suggestion is viable and not too horrific?
