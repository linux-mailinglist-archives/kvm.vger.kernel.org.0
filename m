Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B519647C
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 17:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbfHTPcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 11:32:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39282 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727246AbfHTPcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 11:32:45 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 93FC330603AA;
        Tue, 20 Aug 2019 15:32:45 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6248218F01;
        Tue, 20 Aug 2019 15:32:41 +0000 (UTC)
Date:   Tue, 20 Aug 2019 09:32:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Zhang, Tina" <tina.zhang@intel.com>
Cc:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>
Subject: Re: [PATCH v5 2/6] vfio: Introduce vGPU display irq type
Message-ID: <20190820093240.2bc1c9ba@x1.home>
In-Reply-To: <237F54289DF84E4997F34151298ABEBC876F9AD3@SHSMSX101.ccr.corp.intel.com>
References: <20190816023528.30210-1-tina.zhang@intel.com>
        <20190816023528.30210-3-tina.zhang@intel.com>
        <20190816145148.307408dc@x1.home>
        <237F54289DF84E4997F34151298ABEBC876F9AD3@SHSMSX101.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 20 Aug 2019 15:32:45 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 20 Aug 2019 02:12:10 +0000
"Zhang, Tina" <tina.zhang@intel.com> wrote:

> BTW, IIRC, we might also have one question waiting to be replied:
> - Can we just use VFIO_IRQ_TYPE_GFX w/o proposing a new sub type
> (i.e. VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ)? Well, only if we can agree
> on that we don't have any other GFX IRQ requirements in future.
> Otherwise, we might need a sub type to differentiate them.

I think you've answered your own question ;)  We already have the
infrastructure for defining type/sub-type and it allows us to
categorize and group interrupt types together consistent with how we do
for regions, so what's the overhead in this approach?  Otherwise we
tend to have an ad-hoc list.  We can't say with absolute certainty that
we won't have additional GFX related IRQs.  Thanks,

Alex
