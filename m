Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751D77B85C8
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 18:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243547AbjJDQxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 12:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243508AbjJDQxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 12:53:31 -0400
Received: from out-190.mta0.migadu.com (out-190.mta0.migadu.com [91.218.175.190])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E787CE5
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 09:53:22 -0700 (PDT)
Date:   Wed, 4 Oct 2023 16:53:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696438400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3x/C3uN5n0ecJ753anGN387LclKbafyhiu3iWfcPQOk=;
        b=qv2CfXgUqzzcISXuh8De8e2oB88njrk6/igWX7smSRtFN+QKjjH3Bzc+hHdVmug+0EP/qQ
        8P0Q0iia1COY0c2Rr41HVVOy6Ia/8cjKDQzh8d/PMA6y9JTaxPJEmXxuuq/qGKm/GTCgch
        D0IYfpzU/pcWAkJcQe9rlZyJ3NwjjnA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v11 00/12] KVM: arm64: Enable 'writable' ID registers
Message-ID: <ZR2YfAixZgbCFnb8@linux.dev>
References: <20231003230408.3405722-1-oliver.upton@linux.dev>
 <86mswyohcy.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86mswyohcy.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 04, 2023 at 10:40:45AM +0100, Marc Zyngier wrote:
> On Wed, 04 Oct 2023 00:03:56 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Few more fixes that I threw on top:
> > 
> > v10 -> v11:
> >  - Drop the custom handling of FEAT_BC as it is now fixed on the arm64
> >    side (Kristina)
> >  - Bikeshed on the naming of the masks ioctl to keep things in the KVM_
> >    namespace
> >  - Apply more bikeshedding to the ioctl documentation, spinning off
> >    separate blocks for the 'generic' description and the Feature ID
> >    documentation
> >  - Fix referencing in the vCPU features doc
> >  - Fix use of uninitialized data in selftest
> 
> We'll probably need another bit on top to deal with Kirstina's
> FEAT_MOPS series and make that field writable.

Yep, I was planning on a one-liner to unmask MOPS once I get Kristina's
patches applied.

> The minor nitpicks I had notwithstanding:
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>

Appreciated!

-- 
Thanks,
Oliver
