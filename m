Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FFE68CAE4
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 00:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjBFX7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 18:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjBFX7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 18:59:20 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18726144AB
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 15:59:19 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id ge21-20020a17090b0e1500b002308aac5b5eso7036789pjb.4
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 15:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VgJ0cVNYo8bXFzsgph6t79HhuWm/IIHs9m1ZnHY/01U=;
        b=sqMPC8I4TKBEWXaUc8VIUZR4/aG3oQB6L14UtUogKoxYRvQKnyqkW/f8OrXKQ7OmFp
         1dTU1b853tEGID37onDY+7WbFkVzCulate0Nk8ClhxNFerF/+OMjrIWH9uL2bPeobh4v
         1yzEv8zUrfb7KZ/g4BVw0vma426u/+pb6HYIVdgNNI8yY5yFE4F0a9U5+bKdLy1TcLTz
         m/2ynIU6ZzgyqaXIDww6kwgtLr0bDlk+/NjbDP/gkT3CRII7fth6WvksaA+ZO4IWcycQ
         NgbfdfvSl48D2gyk2S4IMC0tvuaZoBNGh0kWrrQV3UyJWfGjUa3ym3GxLLSVQvs2WH3h
         fzCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VgJ0cVNYo8bXFzsgph6t79HhuWm/IIHs9m1ZnHY/01U=;
        b=fuu7B+pgwMmiXEmbzc9oUN5210Tfh5iuEArAL5/szlgKKtCFS3GOQywGFm2IwVUdOk
         fN5FzBzeg1GVvLT6TooZPLk0zkgKgo4nsu+Idb185TOhq6+6jME32cEf3x96TFbenFBH
         WCYLXvT47Qc7xLhdWNhCWu+HB0Bxu4t9S//Dyabc6UWfLE7Y7Tg+aJ/9WxjIdbEcscPY
         5pA1n8p+OqqYfVeRdI95w/8qXFXqTiMARPQEoBDJWY/oRgE8v0u9Ttx9TCtqshs6Pvix
         ZobTEdGpb+9dPRFAm4QXmIZ+LX3cKXWO2Og9c0PihvHQWdXiLkvWItydKHTIwhp6xQXI
         2V5w==
X-Gm-Message-State: AO0yUKWwhUnXW+wcT7bux9kUXjp63kDzS3/6EW3nxMliqTJodXxcaAon
        Az2EVLa8c59izWB69+qN8sHrFQ==
X-Google-Smtp-Source: AK7set/GFxUZa9+pN6v1nrcdICrPOicRXUP56G3VOaAZlV5DsSAPyPlTHwrOxDB5POP7UbhlPhDqeg==
X-Received: by 2002:a17:902:db09:b0:196:1462:3276 with SMTP id m9-20020a170902db0900b0019614623276mr664747plx.46.1675727958457;
        Mon, 06 Feb 2023 15:59:18 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id q16-20020a170902edd000b001966308ca0dsm7553082plk.167.2023.02.06.15.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 15:59:18 -0800 (PST)
Date:   Mon, 6 Feb 2023 15:59:14 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v2 4/5] KVM: x86/mmu: Remove
 handle_changed_spte_dirty_log()
Message-ID: <Y+GUUr/UE0V0WsrR@google.com>
References: <20230203192822.106773-1-vipinsh@google.com>
 <20230203192822.106773-5-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203192822.106773-5-vipinsh@google.com>
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

On Fri, Feb 03, 2023 at 11:28:21AM -0800, Vipin Sharma wrote:
> Remove handle_changed_spte_dirty_log() as there is no code flow which
> sets leaf SPTE writable and hit this path.

Heh, way too vague again. e.g. This needs to explain how make_spte()
marks pages are dirty when constructing new SPTEs for the TDP MMU.
