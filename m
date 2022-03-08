Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D294D237A
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 22:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350504AbiCHVlo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 16:41:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244914AbiCHVln (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 16:41:43 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7399C4F447
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 13:40:46 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id o26so254490pgb.8
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 13:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1Z/+WSrvJlPnQEDsfYrE2z6OFFa/9dhUrO6bXduNfSg=;
        b=AyDJ0v3bOC/Mk6G2omvHAYDrX6WAj5QfZC8MoYvL3+8XEH5sI1J7NO+L1XE0rsQckd
         zZYkeJH9GlduD/CBk2kMv5fsuCyBQdl1x/NgnEhTq90uQ4S86uScnqE75kSM6hC2bN3m
         H5HzwDd9qM6QiINX/Whc3vDJBpdcggbdBXr4w/lgLuG+OMtJRi/TSF5qzhJMwUkDE5Mv
         zG+Fmb/KCkt+JnL+WIplJS00dBc6tfriKyvd7xt4AZomv+6Aaaj+MduVfA+5G3F1yXj/
         wPRX21Q8hMQhvpasO4aMu+BX4D71EE5o50Hm/ao/BvdQ6dlSHGO+yg7r6Oj4WZKrv4kY
         YJww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1Z/+WSrvJlPnQEDsfYrE2z6OFFa/9dhUrO6bXduNfSg=;
        b=KyAMq8UsgtGOFZCkyFUvz8LhuSRc+W6Yjg29iBtlUGEzGz+S9V32kPNAIwTRuA8hMN
         giTU8ZpPAj/VbzAFu9H4cvnWgDfU7fd03RMDU+kgW8YO1wnPYQu7ClOr3srJvt3wt/Ff
         jS55D8V9L7QkTXPWc0qSvktsY9ENC1pMg1dtcd7OnpWDqROv09feRvVXSmxcF34RXLeo
         MjaxbF0NCVJpUFPX4lkJ6moYRexbU55IOmTc66RAyB3DrMXqgS/szD3r2//GAVChe/xZ
         szXQP4xO571AiHp5fkQLO+yXIqIXN98auIBUT72jf/jRRXhobzWTgr6gGmGSWXR7qcSf
         ySxA==
X-Gm-Message-State: AOAM531oAby77TAW3k3W5eecGnXdU/gXl0YGZ+5DWOuX0/nHzqyvd0zC
        o+f1Z2yo+6Zr5dSBo4nGctz4ig==
X-Google-Smtp-Source: ABdhPJw4+9mvhobsiKk0i351hsEgJMRYsrhA3+TC2CIXaUhiq79i5G055YE4QZHDbxjWmmenW8SS8g==
X-Received: by 2002:a63:710f:0:b0:378:c35a:3c3 with SMTP id m15-20020a63710f000000b00378c35a03c3mr16059308pgc.535.1646775645858;
        Tue, 08 Mar 2022 13:40:45 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u37-20020a056a0009a500b004e1414d69besm11814pfg.151.2022.03.08.13.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 13:40:45 -0800 (PST)
Date:   Tue, 8 Mar 2022 21:40:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Rik van Riel <riel@redhat.com>,
        bgardon@google.com
Subject: Re: [PATCH RESEND 2/2] Revert "KVM: set owner of cpu and vm file
 operations"
Message-ID: <YifNWauo4cpvT1Hp@google.com>
References: <20220303183328.1499189-1-dmatlack@google.com>
 <20220303183328.1499189-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303183328.1499189-3-dmatlack@google.com>
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

On Thu, Mar 03, 2022, David Matlack wrote:
> This reverts commit 3d3aab1b973b01bd2a1aa46307e94a1380b1d802.
> 
> Now that the KVM module's lifetime is tied to kvm.users_count, there is
> no need to also tie it's lifetime to the lifetime of the VM and vCPU
> file descriptors.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
