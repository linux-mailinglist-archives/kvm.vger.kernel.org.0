Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EBD4817B8
	for <lists+kvm@lfdr.de>; Thu, 30 Dec 2021 00:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbhL2X3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Dec 2021 18:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbhL2X3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Dec 2021 18:29:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71FB0C061574;
        Wed, 29 Dec 2021 15:29:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FA9E61579;
        Wed, 29 Dec 2021 23:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357E5C36AEA;
        Wed, 29 Dec 2021 23:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640820547;
        bh=wBgUX6035m1YIw7zR0RD+B0c5HY2vxW7e9J5VqOu5jU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dgjY1vd7K8lc7lv/YQ8JrquQdNgcS6R5DKIxmDFx6PjJHgNm1uzvln5vba55mfq+J
         td8h/KuoTPxrMX1cqIQ6yxgb0ogN7S+QBpzrhewGsChqrts/QiFIuqucsmYmUlhBRg
         rH0n6Rrq131nlvCWaC5ywzyOVTAek1BHpvGikEZU=
Date:   Wed, 29 Dec 2021 15:29:07 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Sean Christopherson <seanjc@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        syzbot+4e697fe80a31aa7efe21@syzkaller.appspotmail.com,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] hugetlbfs: Fix off-by-one error in
 hugetlb_vmdelete_list()
Message-Id: <20211229152907.d59ee76dcf1ea28a2356a176@linux-foundation.org>
In-Reply-To: <7eb2849e-ad6d-11c5-a37d-806a1c62bb3e@oracle.com>
References: <20211228234257.1926057-1-seanjc@google.com>
        <7eb2849e-ad6d-11c5-a37d-806a1c62bb3e@oracle.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Dec 2021 19:52:37 -0800 Mike Kravetz <mike.kravetz@oracle.com> wrote:

> +Cc Andrew if he wants to take it though his tree.

Sure.

> > 
> > Not sure if this should go to stable@.  It's mostly harmless, and likely
> > nothing more than a minor performance blip when it's not harmless.
> 
> I am also unsure about the need to send to stable.  It is possible automation
> will pick it up and make that decision for us.

Automation shouldn't do that for mm/ patches because we asked.  But fs/
material might sneak through.  But it does appear that -stable
won't need this.
