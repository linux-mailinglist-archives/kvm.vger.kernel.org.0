Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6326173126C
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 10:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244977AbjFOIjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 04:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244500AbjFOIj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 04:39:28 -0400
Received: from out-40.mta1.migadu.com (out-40.mta1.migadu.com [IPv6:2001:41d0:203:375::28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3CB213F
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 01:39:26 -0700 (PDT)
Date:   Thu, 15 Jun 2023 08:39:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686818362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gz3kiTPD1i8pSYPebBODTPl6dCik1dmiIWWuoo4q9xU=;
        b=MD6laGEukKWpVKXpKSLgfCPgbCy/4H8HB11XY9lDuC687B3NTM2X5zpDjvuQV5DNZE5MoE
        zMH4vV/ALY1EPtIMPbYfEuMHIx2XvixQGjjsqG7l9OSj75lWkkD/z5mcosowAC5DWhQFeN
        yibe9YNMXZ8+XJ6iNPUkIci5SqosbX0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com
Subject: Re: [PATCH v5 0/7] KVM: arm64: Add support for FEAT_TLBIRANGE
Message-ID: <ZIrONR6cSegiK1e2@linux.dev>
References: <20230606192858.3600174-1-rananta@google.com>
 <ZImwRAuSXcVt3UPV@linux.dev>
 <CAJHc60wUSNpFLeESWcpEa5OmN4bJg9wBre-2k8803WHpn03LGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60wUSNpFLeESWcpEa5OmN4bJg9wBre-2k8803WHpn03LGw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+cc Sean

On Wed, Jun 14, 2023 at 06:57:01PM -0700, Raghavendra Rao Ananta wrote:
> On Wed, Jun 14, 2023 at 5:19 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > Hi Raghavendra,
> >
> > On Tue, Jun 06, 2023 at 07:28:51PM +0000, Raghavendra Rao Ananta wrote:
> > > The series is based off of upstream v6.4-rc2, and applied David
> > > Matlack's common API for TLB invalidations[1] on top.
> >
> > Sorry I didn't spot the dependency earlier, but this isn't helpful TBH.
> >
> > David's series was partially applied, and what remains no longer cleanly
> > applies to the base you suggest. Independent of that, my *strong*
> > preference is that you just send out a series containing your patches as
> > well as David's. Coordinating dependent efforts is the only sane thing
> > to do. Also, those patches are 5 months old at this point which is
> > ancient history.
> >
> Would you rather prefer I detach this series from David's as I'm not
> sure what his plans are for future versions?
> On the other hand, the patches seem simple enough to rebase and give
> another shot at review, but may end up delaying this series.
> WDYT?

In cases such as this you'd typically coordinate with the other
developer to pick up their changes as part of your series. Especially
for this case -- David's refactoring is _pointless_ without another
user for that code (i.e. arm64). As fun as it might be to antagonize
Sean, that series pokes x86 and I'd like an ack from on it.

So, please post a combined series that applies cleanly to an early 6.4
rc of your choosing, and cc all affected reviewers/maintainers.

-- 
Thanks,
Oliver
