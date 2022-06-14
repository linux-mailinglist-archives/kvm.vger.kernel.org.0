Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E1254A356
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 02:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbiFNA4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 20:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiFNA4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 20:56:06 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797F931344
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 17:56:05 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gc3-20020a17090b310300b001e33092c737so7616593pjb.3
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 17:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zM25P5j7I6ljpapb2NJdghZi7EF+oAA2atXWjdhgbqU=;
        b=EmCpvYAGXd48+DwFFSxtFRqmLKmNO11mM4ZuQheqGjuzckadHock5jF+A86mJnH1SH
         PN8tM2+xM8BdV7pk4jBWLWsq7novWKwN6WKknSfiXb/wfFkWQhzqLlqtfrbqO5AyBWrp
         p3O8Rym02lcZQKvvCkphYjfUvAJCre9XBYHqtBpJE9TIR8gTNEBwnpTVjGLF4VRtvRSJ
         y7P37M+l9sC/nuYLn0B8cX4NsT/VJCbHbuuLQjefy42jbGFBSZ9xgS8YkEAoJEJbjP/W
         uOHfdKdhWBS84t0tAK/tKevET7xMS6OihQFya6NdfRjVONDHcdG/2Be7mUyuONDGs5CS
         y0rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zM25P5j7I6ljpapb2NJdghZi7EF+oAA2atXWjdhgbqU=;
        b=XytI0DgBJwIj5GA8YtEzEPNpKWn7O3OOOKmEtUW7Xfx2io/+mFMylp3M7i+e2wCOSZ
         px+ivzG3FMtOuYghlvMx3qRXt8xW3MlYLMgP40sURu7F9LQheuHYQkFXqj/Af8JTWOMA
         ajue8dn/xbRksTxtCPuBhfLTlCFhJA/c3mx8uP7Gv3skicibjnLFEcU1AzmBideqgYAD
         TKNG+ucUY9jlW0WH6ovWRJNzcdpJCH/Dz0xJCL7QEjhEmRJrMqmR1VtDdN/KoQqRWGwT
         8IlJ27S4yFeYAC9DtvHwAdxsXe/nZmA+P2epfxZQiK9QUZ9z7USYAXYEFFy1eImsTe5r
         e6bw==
X-Gm-Message-State: AJIora+qK3x8Gny86+XO6E6z4IiP28k4XKIPdNnIF3ylvzGSfTcNhQ9B
        TX4J8Mg38SVvIZu5wdD28vTBeA==
X-Google-Smtp-Source: AGRyM1v4hqWo35Dq9bSSU14Eq4t+QYXwRnRiFLU+htOcGPcAFII/epQGniZ47FPQcHCrpmzqqRXR1A==
X-Received: by 2002:a17:902:edca:b0:167:ccca:30af with SMTP id q10-20020a170902edca00b00167ccca30afmr1998924plk.40.1655168164794;
        Mon, 13 Jun 2022 17:56:04 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x10-20020a627c0a000000b0050e006279bfsm6036776pfc.137.2022.06.13.17.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 17:56:04 -0700 (PDT)
Date:   Tue, 14 Jun 2022 00:56:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Shukla, Manali" <mashukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        "Shukla, Manali" <manali.shukla@amd.com>
Subject: Re: [kvm-unit-tests PATCH v4 0/8] Move npt test cases and NPT code
 improvements
Message-ID: <YqfcoSk3cTWhNBJB@google.com>
References: <20220428070851.21985-1-manali.shukla@amd.com>
 <1b1998e2-0ff9-23cc-aaff-4f1e5ae3d06b@amd.com>
 <420e1cda-61ad-e7d1-df50-0cd6907ff329@amd.com>
 <29c35f14-8941-288d-2a0a-6642bf399a32@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29c35f14-8941-288d-2a0a-6642bf399a32@amd.com>
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

On Thu, Jun 09, 2022, Shukla, Manali wrote:
> Shall I rebase and resend this series?

If you have spare bandwidth and/or it's a trivial rebase, sure.  I'm hoping to get
to this in the next few days; waiting for that may or may not save you time in the
long run (truly don't know at this point).
