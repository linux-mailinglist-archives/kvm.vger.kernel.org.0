Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3234B00CB
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 23:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236833AbiBIW6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 17:58:04 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:41326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236875AbiBIW6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 17:58:02 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31D6E04BEAF
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 14:57:54 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id om7so3521511pjb.5
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 14:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9hlT9vQoLsVUjhpXGLlm7SvL3xA/YnfAS42BSAPz/pE=;
        b=r734V9jLiaYfgXN0U+a0+2HFTV0eBCXCPquFaY/jlvnSdXeYv8CNvRDh/k7nddphJt
         i8MOmjleXPePA6uvYMQC2S8sulBSJ8DjBef7De+Qt/G30bc1Ij6Wau47EIQHjyvzr767
         zEDwNvkCqLOmt1Jt+Z63JDDnSrNnXQyyR5s0gNfZKAqOn47bYilzIbNHWdbXFsYJhZkk
         dz01b+CjCMs7TzyfXo9oORg+cwjc4++HwDCXGps1KqbJMfg7ozkyCtGABKVvSC3lFm1n
         fC5HzenqA0xBzwiHiaG6eMG6VvXtSS42e9ELMj9likPB63B2zJzx7PaOerJbkPVJpUqw
         I2kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9hlT9vQoLsVUjhpXGLlm7SvL3xA/YnfAS42BSAPz/pE=;
        b=STufeOwWFdKIHAxD6lA8KqFDuViGeaO1KQy/PyL54zIa1qDZ0JRM9yMsCa1KFHqlmv
         8qEdvZ2M3bLCbKyPHiw0kaULrvSDM6RbFJRB3JtRtw4Tsg8sCYNSM7E5WMu3WXG0arjW
         /Xk8yj5FWZH9aO3AEQElpEzlbL9iHxk2inmnwrmhZ2Cne0B+u8tRJp4FdTDrvgffp+zB
         pQop0ZTHIv8hp7XSqKnJI3GhcReefs9xHjeivkMK6fDcgCUOB28P3YYuUOvmvzNO3Cjk
         kbnGYYdodYiNz7/LYbMNjRLhrale+ECZWFxqzLRi3zkGc8wywi5H3hQ7xdRxfFHR2pAM
         G9fA==
X-Gm-Message-State: AOAM531AyyQKWoyfLiISjWk88LfWGfT6tcg7VJamuenSUCY4sfrvI10/
        HPTlBWU/Bxr839MOGh/7+FDncQ==
X-Google-Smtp-Source: ABdhPJzxCieXiOFBmRxLOPkMpJ+lVohhiFAWUBH7GcomfK6r/tS+mSnDhcBvuqYoUy/9VfU1Cv+eLg==
X-Received: by 2002:a17:90b:3a82:: with SMTP id om2mr4731200pjb.167.1644447468162;
        Wed, 09 Feb 2022 14:57:48 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gk15sm269582pjb.3.2022.02.09.14.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 14:57:47 -0800 (PST)
Date:   Wed, 9 Feb 2022 22:57:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 04/23] KVM: MMU: constify uses of struct kvm_mmu_role_regs
Message-ID: <YgRG6GPX906Yy51b@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-5-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204115718.14934-5-pbonzini@redhat.com>
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

On Fri, Feb 04, 2022, Paolo Bonzini wrote:
> struct kvm_mmu_role_regs is computed just once and then accessed.  Use
> const to enforce this.

It's not new enforcement, just syntatic sugar (though it's tasty sugar).  All fields
in struct kvm_mmu_role_regs are const specifically to prevent such a struct from
being changed regardless of how a pointer was obtained.

struct kvm_mmu_role_regs {
	const unsigned long cr0;
	const unsigned long cr4;
	const u64 efer;
};
