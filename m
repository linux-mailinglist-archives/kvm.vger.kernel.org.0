Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5032C58E08A
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 22:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344707AbiHIUAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 16:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345622AbiHIT7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 15:59:38 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712F925285
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 12:59:31 -0700 (PDT)
Date:   Tue, 9 Aug 2022 19:59:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660075169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sM5Dxj/DZYe6RsHiIz0HU39XEN9xQpMq/eMg+Z/EJxg=;
        b=U5LPb1fqQLk75DyiGkfhvbz3klE8UT+2xQknuMOqXXk08G6OWjEMyysCWoM0yU9aMgUv6H
        4qO+NxUxuEfsU2tCDtzE57oraBxpXqqLOVvVNt8kErszSexjQeT7X1ireQVv3qyZ+xoefJ
        fHL1YZY054BihN6QDHEtlgnGz3WqQ/E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 6/6] KVM: Hoist debugfs_dentry init to
 kvm_create_vm_debugfs() (again)
Message-ID: <YvK8nnCZwHtWVEua@google.com>
References: <20220720092259.3491733-1-oliver.upton@linux.dev>
 <20220720092259.3491733-7-oliver.upton@linux.dev>
 <Yu1pO/ovmMBktzpN@google.com>
 <d3e719ea-af24-a06b-6ced-274e98504d89@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3e719ea-af24-a06b-6ced-274e98504d89@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 09, 2022 at 04:56:28PM +0200, Paolo Bonzini wrote:
> On 8/5/22 21:02, Sean Christopherson wrote:
> > Heh, so this amusingly has my review, but I'd rather omit this patch and leave
> > the initialization with the pile of other code that initializes fields for which
> > zero-initialization is insufficient/incorrect.
> > 
> > Any objections to dropping this?
> 
> Yeah, I was going to say the same.  The points before and after this patch
> are far enough that I'm a bit more confident leaving it out.

Sounds reasonable to me. To be fair, I mostly threw this patch at the
end to poke fun at the original mistake :)

--
Thanks,
Oliver
