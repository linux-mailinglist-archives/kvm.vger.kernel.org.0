Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98A7BA7D22
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 09:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbfIDHyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 03:54:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729112AbfIDHyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 03:54:55 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3288C300C72A;
        Wed,  4 Sep 2019 07:54:55 +0000 (UTC)
Received: from gondolin (ovpn-117-161.ams2.redhat.com [10.36.117.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F19F06092D;
        Wed,  4 Sep 2019 07:54:50 +0000 (UTC)
Date:   Wed, 4 Sep 2019 09:54:47 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: Disallow invalid bits in kvm_valid_regs and
 kvm_dirty_regs
Message-ID: <20190904095447.05b3b845.cohuck@redhat.com>
In-Reply-To: <20190904071308.25683-1-thuth@redhat.com>
References: <20190904071308.25683-1-thuth@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 04 Sep 2019 07:54:55 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  4 Sep 2019 09:13:08 +0200
Thomas Huth <thuth@redhat.com> wrote:

> If unknown bits are set in kvm_valid_regs or kvm_dirty_regs, this
> clearly indicates that something went wrong in the KVM userspace
> application. The x86 variant of KVM already contains a check for
> bad bits (and the corresponding kselftest checks this), so let's
> do the same on s390x now, too.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  arch/s390/include/uapi/asm/kvm.h              |  6 ++++
>  arch/s390/kvm/kvm-s390.c                      |  4 +++
>  .../selftests/kvm/s390x/sync_regs_test.c      | 30 +++++++++++++++++++
>  3 files changed, 40 insertions(+)

With splitting out the selftest,
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
