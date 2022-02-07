Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF374ACB61
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 22:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241246AbiBGVgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 16:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241184AbiBGVgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 16:36:18 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FA3C061355
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 13:36:17 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id g8so5415463pfq.9
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 13:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wVZeCDJhhyDTPT0x7WC5w4hv2fBAH3Whp6Hz12nQyhE=;
        b=LwSI+ukmyIpohp+ssw5Dp/rYmKtQAjCpcNWmjSKz7VEv2Q6MUrc3BsWKwhj+lXvHMS
         jAQP97blj3npiCBl1+qyvDTcazSWXncL1h4Hi0t2PRyumnhD6SkwFmDDp4mMXd+cZVtg
         FFdgtctJ7T2BQnAaRmip/86MxaoC/Be4SOV3PM5hR1ROCfaINsiZUmL0oUXd4e2idQcG
         9ziunh1ilhdpbeYR6S85b+qWfv+GiqWKuxxL9AdysvOxQ+4lhaijsda7dkIlZkKWKeVI
         iyzeIMMQc/H5fnM9qYaOsdGJsNA5e/tOry7DKmDLgc2aQRNhSUFDGkrER3R9bol/fSUe
         Nh9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wVZeCDJhhyDTPT0x7WC5w4hv2fBAH3Whp6Hz12nQyhE=;
        b=6lFxrERXpebBdiMjiHReuo7UI344brzs7imREM+8cXgtpmRYZsuHRl3CKZXnsJVJZG
         p3Go5z7y8SbrIVL+JeHgqYNapYIipg9fj9ill10UslDea2hJE63TFgyK7HVtVK71FAyP
         Gli06GYuwWKWEnyEKa5NczNeJus53l1jH47Cr8Mxs4y8sa5xsrhq0Poy0Wm8/BZcrGFz
         Q9qrGzTgev3ZNpIovybC2L0LVbDHo2ruVPFUgxigp/9mBpagIoxX1UVSJ4V+vzRLNwk4
         Ik2q5VysiYsQyKfaKIXVjvNSz7d+THGeCNz5W532slLZDEBXARqqDsECSQvqX5ai3i8d
         g3lg==
X-Gm-Message-State: AOAM530ZlC8Gm3v3AFmG2m33OCscm1DR8LynF4Xomr7zctlcqfPBDdhw
        2hmZktfN+kEPnfDWljjGLWWK5n0l/dN/CQ==
X-Google-Smtp-Source: ABdhPJxZTIYiAaHsOSnFl7YJ/HirXo3RBTlPz6UGkg7yh593sVyt52/LrkzAQXKZTrNaS7Jz9i+9nA==
X-Received: by 2002:a63:6e8d:: with SMTP id j135mr1016626pgc.63.1644269777024;
        Mon, 07 Feb 2022 13:36:17 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q13sm13014151pfj.44.2022.02.07.13.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 13:36:16 -0800 (PST)
Date:   Mon, 7 Feb 2022 21:36:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH 00/30] My patch queue
Message-ID: <YgGQzVMdjHfcDGCQ@google.com>
References: <20220207152847.836777-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207152847.836777-1-mlevitsk@redhat.com>
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

On Mon, Feb 07, 2022, Maxim Levitsky wrote:
> This is set of various patches that are stuck in my patch queue.
> 
> KVM_REQ_GET_NESTED_STATE_PAGES patch is mostly RFC, but it does seem
> to work for me.
> 
> Read-only APIC ID is also somewhat RFC.
> 
> Some of these patches are preparation for support for nested AVIC
> which I almost done developing, and will start testing very soon.

Please split this up into smaller series and/or standalone patches.  At a glance,
this has 10+ different unrealted series/patches rolled into one, which makes
everything far more difficult to review.  
