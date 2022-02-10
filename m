Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8354B18F4
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 00:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345352AbiBJXAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 18:00:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345289AbiBJXAp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 18:00:45 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33487115D
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 15:00:46 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id 10so3175091plj.1
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 15:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KEDi7BzApy9NyPhE3GwFUFpSbJpaoj+MohuY7q6ukn8=;
        b=rC0MuFpLCGX/wILsiUuPi3U1gQg31caG4BiNWRkZyARysxxOUUv8Q3LNzjO+P+Nk4y
         2r9JQXfBsPd5Ndy5bfdBm1UQStmdMFkUSa9ZuGJ2Jbx0vAGuMzkjBl0HVJzFfBHPzqRM
         oZ/+2fopYX4+xZ4Xtf3ezO+u9pX9x2tJREvwE9mVekhs4fzaFfwcbbR6EsMgKcKm92Ly
         1v5axtqmVRVRJoeblg4A+0nGSHgduY0/yBdo0gSsD1+AMMCbwQJzPItE4B27jVFD+YiP
         khM8cU5635c5J+kXgZcI4na3T/UF9GRUHOmBq0MRvWfUXPam2Lf/Sjy+0aMjN2GYOj3v
         L6sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KEDi7BzApy9NyPhE3GwFUFpSbJpaoj+MohuY7q6ukn8=;
        b=KInk6mGQgLAHpsxmruA1mJX0Z4Y6jhLx9IBMguXZx3W+7bu4yAFfadITII9PC1edgP
         8/dn0UvtHbl39DJSqIadLZEQYlc7486wKChL0rMG53vmnhFZtnvdwLi4S91Mt3dAnraO
         OP1jOuOPawj2i1cfq43sAxqoa0fNisi96DFfkgGEwEuv8k3gTqaZ1blvsrUox9uIFaBC
         cGAsxG4bwU+1jy7xxViLTIFvIKF84dYaU7WgXG9PAmI5ZGCW12cfTAIDF6TqUgFNMt+Q
         Vg3XzzW46UWMhxrBsJeTCGY7HwvL5Huzb/waTTzt2U8uB705DfyDm5R13FJTxL21Wdrh
         /iPA==
X-Gm-Message-State: AOAM530T9Zd/QrPQVEHNkcYJM+micSU018IGeZT3GPppWtE/cRjz828K
        RLksgfZ4cJZlkfK9zFCidOPowQ==
X-Google-Smtp-Source: ABdhPJyn2Ky81FVl3Upy6x198Hz9a9Q7KTbh/uhEkowKvr9pyNxCLlAHzTTAPzh5pud+RCCDx1tcXg==
X-Received: by 2002:a17:90b:3c6:: with SMTP id go6mr5136781pjb.230.1644534045516;
        Thu, 10 Feb 2022 15:00:45 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q8sm26524792pfl.143.2022.02.10.15.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 15:00:44 -0800 (PST)
Date:   Thu, 10 Feb 2022 23:00:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 02/12] KVM: MMU: move MMU role accessors to header
Message-ID: <YgWZGa9qNfc/GmA1@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209170020.1775368-3-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 09, 2022, Paolo Bonzini wrote:
> We will use is_cr0_pg to check whether a page fault can be delivered.

I strongly prefer we keep these MMU-only, the terse names were deemed safe
specifically because they are encapsulated in mmu.c.  The async #PF case can use
is_paging(vcpu).
