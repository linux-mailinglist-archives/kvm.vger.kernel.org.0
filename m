Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BB567D61E
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 21:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbjAZUVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 15:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbjAZUVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 15:21:50 -0500
Received: from out-128.mta0.migadu.com (out-128.mta0.migadu.com [91.218.175.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0C647089
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 12:21:48 -0800 (PST)
Date:   Thu, 26 Jan 2023 20:21:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674764506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HCSsOa0JEOzhu3a9IEBtJokH+VBhBqNS4dXI8GM6BrQ=;
        b=i/OFi55Kk1Tj0Kbnkwfvkt5xhK41K7otXqMXHyW9PC+97eT58SMprP3IyAXkwxD+HzvAfI
        2rOsQDnYp/lYKzNBFcuBYyaUOsEO0DG6HreD7ssgJPJgzzW7fn4Jku/4QAoTmt/QyTNUey
        6xw2MuMloIX00xPGtvtk1Tw91nAIiz0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net,
        maz@kernel.org, will@kernel.org, ricarkol@google.com,
        eric.auger@redhat.com, yuzhe@nfschina.com, renzhengeek@gmail.com,
        reijiw@google.com, ardb@kernel.org, Julia.Lawall@inria.fr,
        yuzenghui@huawei.com, seanjc@google.com, shan.gavin@gmail.com
Subject: Re: [PATCH v2 0/3] Improve dirty ring warning report
Message-ID: <Y9Lg1ESUVJov0WpH@google.com>
References: <20230119234405.349644-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119234405.349644-1-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 20, 2023 at 07:44:02AM +0800, Gavin Shan wrote:
> It has been known case where no running VCPU context exists when the
> vgic/its tables are saved. There are other two unknown cases where we
> don't have the running VCPU context: (a) restore vgic3 LPI pending
> status. (b) restoring vgic3 pending tables.
> 
> PATCH[1]     adds unified helper vgic_write_guest_lock()
> PATCH[2 - 3] allows no-running-vcpu context for (a) and (b)

Besides the issue with the first patch, for the series:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
