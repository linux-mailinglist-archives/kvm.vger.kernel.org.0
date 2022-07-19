Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A03057A870
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 22:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240195AbiGSUpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 16:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiGSUpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 16:45:22 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E415240AF
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 13:45:22 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id g4so14583809pgc.1
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 13:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D3kFW+CNJeoH4PPSVHWiEcaf2dsQp1lSy6wc4sWrT4w=;
        b=LCHYCBm3sqQsmDrj2nWpXqZCy7rnU4/qEAqZN/bgGic9l1ZcrPjflPHTiIDdW1BsSK
         N3GFvDWDcPtAEvwq6gU6bWpfyBH9IkEaUl3mtVF1UgXjsPo2jS9aGSPYTIrGl+WbaBfV
         9RWt3g9FZH6JtfhdWEVj7fFoWuoK1JaeTLtqHrkLBqFPKfpdIVVSimDPdalbgGlIIps1
         Lzd4hpez3lwYJUsPf9sag5biXF+5AI3CTCKKRpAgNsmOyMwslWgKkQ5ZkVrHSCjc4xmO
         GtaAYeQhkRHPQGbp7qy2H7ovZmBYOMNt4btRrObew3+3knP0Q/6OKguu3Kdfx927H/7Q
         chow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D3kFW+CNJeoH4PPSVHWiEcaf2dsQp1lSy6wc4sWrT4w=;
        b=ZO9a/JNSGCo1rhFzoX/yR6hhHRGhWf5u/tqviE6ijZ/jpvcwYae7GAi8tbkFtTTTWz
         5PVK9GlstNRFNMXbQI4oj+M0tOpj3VEI4ARX9P1rUpGDPxRfd5vLW376HTsyRD0CbEgn
         kHOVhpF+xRRSbEP73KflvoZ8HJ3Wcnb9CEvuMtSScjelAK1P404NBLJkwSPW+Zw9Yzss
         V9c//TXPyjhRQ5s1NsJPqFPjP35Mf8d3hqfBlfsPs9JwtEvUV0YsNqDAX9RY68d32G7/
         X30qMNxX6QPZjOwCY0EL3CtUsHNlwosGxA+KqZ0r34Bjc0iYDF4ldlvn3ga+EUXHLfOb
         NBCw==
X-Gm-Message-State: AJIora8e/0mP/AQr7rc6+DFOgkYpWeZaidYtdVL7GnIz5atH9aQkv5Rz
        aAmvcXgFcRT4bC/suj+ApeUUTA==
X-Google-Smtp-Source: AGRyM1toqV7tYW7I+isgIZihe3Z6Dew+5gnA7WtnWu5nwkdehbcDNkPk35sFv9xxnrPEOuqnM+Q5mg==
X-Received: by 2002:a05:6a00:998:b0:52a:db4c:541b with SMTP id u24-20020a056a00099800b0052adb4c541bmr35567778pfg.35.1658263521452;
        Tue, 19 Jul 2022 13:45:21 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id g12-20020aa79f0c000000b0052531985e3esm11867788pfr.22.2022.07.19.13.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 13:45:21 -0700 (PDT)
Date:   Tue, 19 Jul 2022 20:45:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH 12/12] KVM: X86/MMU: Rename struct kvm_mmu_pages to
 struct kvm_mmu_page_vec
Message-ID: <YtcX3TK14y55FmmZ@google.com>
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
 <20220605064342.309219-13-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220605064342.309219-13-jiangshanlai@gmail.com>
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

On Sun, Jun 05, 2022, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> It is implemented as a vector and variable names for it are pvec.

Please define "it" in the changelog before referencing "it".  Avoiding dependencies
on the shortlog is trivial and really does help as it avoids having to jump back
to see what "it" refers to.

> Rename it to kvm_mmu_page_vec for better describing it.
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
