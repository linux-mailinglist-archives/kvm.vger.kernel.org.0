Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD4E4398BD
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 16:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbhJYOjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 10:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbhJYOiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 10:38:18 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DDCC061745
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 07:35:56 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id l203so6228856pfd.2
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 07:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=unr/hPV1LRtaLFGvElzu8J0G2Us0ndUhxKDwst/EiBY=;
        b=LAlUCiUiThQLZqtR7k3VnyoObMeALAS0ZF9AaHeUoiJS1guNshz6Ho9BFs5fGeESUF
         q2uQw8bg3OcuTvEaIKGTbCG74e1HYpHPSEZChn9Fui/OXyFCbVB6QffuLlZuyQC4/uQf
         dGmSKBnuqEZd0HOd9FWNHYt0CKXWl00V4xD0baZyEsJC9VPu3MlxhGJT2M9rNeXhmm5W
         UWGLfI/FJZIrNea7hGz9eDiHhGcAJZad6ccR6CGhZCEbW+61HPcmiywR2MfrWgoOFoet
         tTXPL9wIOxueZy8L6p1PVSiKxbew7wnvCvbqwTi/QRy9OUhSavq7f0H9GFeEPT+vkdJT
         8pbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=unr/hPV1LRtaLFGvElzu8J0G2Us0ndUhxKDwst/EiBY=;
        b=lRR8KGjxAo0b1kZhv7b7kZBxmMAltnP7LdESul44+StzXjGQsVcvemsJWOiMWH//Vo
         7VWyiihVXG4H+8OzbdZVdkvsKFlWQzRpJ+NvR9yqDSysGbI7GDeWjgFMFY/hb/HcZq6Q
         IllqnMCV5q4/7h7gRvjWdGNKq5OuC1K0Eyx+Ds0KVCEpouJCy3G1NJwQhKnR0qzvHWhQ
         aYVfwa3eq0Vfs78DFFyBaySoP/OHRjoARIFTSg4Uf6b/XDrUJElz/qq4MbbI/SAasg2e
         LkpHxbsORofD80RpD7mK4zhsOpLI7hGCo0OMQM9uSIQQuwak5R6etEbhPBHlL5oFuheO
         r21A==
X-Gm-Message-State: AOAM533LVstS0z4UjtUm4N362fF2FQGxztU3vmZcO7EX2e9O2A9vX6+a
        DuZlPMMp7pqTTQGvuB7H3k+BMQ==
X-Google-Smtp-Source: ABdhPJyb/BEP9mJoL1RpL20RH+Q8i1MKzoGl1tSo55m13uMQcZrHOrIVQIJiC/lW0QvegrL/3HqJkw==
X-Received: by 2002:a65:6a4b:: with SMTP id o11mr13582903pgu.278.1635172555538;
        Mon, 25 Oct 2021 07:35:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id cm16sm984666pjb.56.2021.10.25.07.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 07:35:54 -0700 (PDT)
Date:   Mon, 25 Oct 2021 14:35:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] KVM: x86: APICv cleanups
Message-ID: <YXbAxkf1W37m9eZp@google.com>
References: <20211022004927.1448382-1-seanjc@google.com>
 <23d9b009-2b48-d93c-3c24-711c4757ca1b@redhat.com>
 <9c159d2f23dc3957a2fda0301b25fca67aa21b30.camel@redhat.com>
 <b931906f-b38e-1cb5-c797-65ef82c8b262@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b931906f-b38e-1cb5-c797-65ef82c8b262@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 22, 2021, Paolo Bonzini wrote:
> So yeah, I think you're right.

Yep.  The alternative would be to explicitly check for a pending APICv update.
I don't have a strong opinion, I dislike both options equally :-)

Want me to type up a v3 comment?
