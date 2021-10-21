Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8807436867
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 18:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhJUQ4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 12:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbhJUQ4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 12:56:13 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C707C061764
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 09:53:57 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a15-20020a17090a688f00b001a132a1679bso3625250pjd.0
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 09:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kyOHgwN0DHuVRwh7hozPiSAKvYo27wrNY2DziVcXuFE=;
        b=ObAEjndWCrMEZyDcTVCTq7+9Uy/48+jQNaX8SknrA4CnTIBbq/Nh43UtzV/JBv9SI1
         cZgECuiRl0bVVDof23b0H25/Rgj0uAMfLoImvEpLLa0I/t1y5uSJQ4KXekkGRevsexwI
         4gQ82uePuAHJAtMMlH8+Vyc3mfLITQKAyn4CqIT1okGvgyyknfhJ90wIEpPpMJIxR7z0
         d+zMkW+1TGz6xtDwEUuzkndBtHOfZwwTMK/G8KEnCLN69dcNkkFBtErBRPszA7QoUhTy
         Zg9Br0VEm/cg7dOagFsR3wvijJ1caSw83tVbqeUOHK8vMvd5ZD5S8pjV6TOZkJN9Kvrc
         ++nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kyOHgwN0DHuVRwh7hozPiSAKvYo27wrNY2DziVcXuFE=;
        b=dps4zAe04uIdO7/DxMNHpPXoEvPUFgwxo8tl1E3gdFUqM56HMFzg5y4rD0/xHLRQjh
         IhSW4w7NJrcid5COGWNShzy22U8TIq4mhTnBMC3edHo1RJ4TqDJEnam1MloTaZV8FPo2
         m0rPO4SvaeerW3j7UGgp4OHYM7jKf8S7bBcWr1TR7EmiL94g2MgqB/SsBW5YP0M3sWXM
         YWRx+LSc3fsM3UOWHsuc71OTwWRnUVCh96kpthGI4U6z2UP8o1OH1pnuvhz0nOPeqVAt
         gaz0MhmGxpjDg7/t5zF+WtB9X9kLFiyFUt4VHQSAeunmswvaHtA8y19qjwkz1za9mVoU
         sBjA==
X-Gm-Message-State: AOAM533oeJzW76bFK3riz6uyWOagC6ex8t5yNUfButAmBJ7LVFytSMV7
        65S68re0lqzOAyUtN7hYmYHwUg==
X-Google-Smtp-Source: ABdhPJxK+lc6WPlEyEt5iufGm+pw8tpEBldLFqlqvq/OvNOKRuX56sHfdQ3bWP4qQH+grMC5q6JrxQ==
X-Received: by 2002:a17:90b:4ad2:: with SMTP id mh18mr7793988pjb.18.1634835236588;
        Thu, 21 Oct 2021 09:53:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m186sm6803444pfb.165.2021.10.21.09.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 09:53:56 -0700 (PDT)
Date:   Thu, 21 Oct 2021 16:53:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Rename slot_handle_leaf to
 slot_handle_level_4k
Message-ID: <YXGbIHAJSPgYh34g@google.com>
References: <20211019162223.3935109-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019162223.3935109-1-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 19, 2021, David Matlack wrote:
> slot_handle_leaf is a misnomer because it only operates on 4K SPTEs
> whereas "leaf" is used to describe any valid terminal SPTE (4K or
> large page). Rename slot_handle_leaf to slot_handle_level_4k to
> avoid confusion.
> 
> Making this change makes it more obvious there is a benign discrepency
> between the legacy MMU and the TDP MMU when it comes to dirty logging.
> The legacy MMU only iterates through 4K SPTEs when zapping for
> collapsing and when clearing D-bits. The TDP MMU, on the other hand,
> iterates through SPTEs on all levels.
> 
> The TDP MMU behavior of zapping SPTEs at all levels is technically
> overkill for its current dirty logging implementation, which always
> demotes to 4k SPTES, but both the TDP MMU and legacy MMU zap if and only
> if the SPTE can be replaced by a larger page, i.e. will not spuriously
> zap 2m (or larger) SPTEs. Opportunistically add comments to explain this
> discrepency in the code.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
