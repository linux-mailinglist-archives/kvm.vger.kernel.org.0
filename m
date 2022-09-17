Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D9A5BBAD3
	for <lists+kvm@lfdr.de>; Sun, 18 Sep 2022 00:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiIQWRI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Sep 2022 18:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiIQWRG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Sep 2022 18:17:06 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEB12A951
        for <kvm@vger.kernel.org>; Sat, 17 Sep 2022 15:17:05 -0700 (PDT)
Date:   Sat, 17 Sep 2022 22:17:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663453024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rj/6CKELmx8vxHervBV7XvLj7YZJrJGD0FTLGMcPyQo=;
        b=D/jORQXVDWWJMhTHaHw3mS0GzFVH+mrtMtFNOmhdi3DDAgviqbmqn0xi9TvfWQDK/Y0jNe
        hNhwCLCKl+aJ59Mk/4YrXMsBYm7Ao8GVQjHapBAPURUQ41FV4D7EuE/+1fVeba0806w5QH
        7aP35Q9D3Ft/5N0ketutLlXUh/9cHf4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, alexandru.elisei@arm.com, eric.auger@redhat.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v6 06/13] KVM: selftests: Stash backing_src_type in
 struct userspace_mem_region
Message-ID: <YyZHXOYOmGFm6MKu@google.com>
References: <20220906180930.230218-1-ricarkol@google.com>
 <20220906180930.230218-7-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906180930.230218-7-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 06:09:23PM +0000, Ricardo Koller wrote:
> Add the backing_src_type into struct userspace_mem_region. This struct already
> stores a lot of info about memory regions, except the backing source type.
> This info will be used by a future commit in order to determine the method for
> punching a hole.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
