Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16A2C8D90
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 18:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbfJBQBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 12:01:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37670 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfJBQBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 12:01:30 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D64A610DCCA1;
        Wed,  2 Oct 2019 16:01:29 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-198.ams2.redhat.com [10.36.117.198])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 97D3A19D70;
        Wed,  2 Oct 2019 16:01:21 +0000 (UTC)
Date:   Wed, 2 Oct 2019 18:01:20 +0200
From:   Kevin Wolf <kwolf@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>, Peter Xu <peterx@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        qemu-s390x <qemu-s390x@nongnu.org>, kvm@vger.kernel.org,
        Igor Mammedov <imammedo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Collin Walling <walling@linux.ibm.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PULL 09/12] kvm: clear dirty bitmaps from all overlapping
 memslots
Message-ID: <20191002160120.GC5819@localhost.localdomain>
References: <20190930131955.101131-1-borntraeger@de.ibm.com>
 <20190930131955.101131-10-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930131955.101131-10-borntraeger@de.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Wed, 02 Oct 2019 16:01:30 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 30.09.2019 um 15:19 hat Christian Borntraeger geschrieben:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> Currently MemoryRegionSection has 1:1 mapping to KVMSlot.
> However next patch will allow splitting MemoryRegionSection into
> several KVMSlot-s, make sure that kvm_physical_log_slot_clear()
> is able to handle such 1:N mapping.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Message-Id: <20190924144751.24149-3-imammedo@redhat.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

This broke the build for me on F29:

  CC      x86_64-softmmu/accel/kvm/kvm-all.o
/tmp/qemu/accel/kvm/kvm-all.c: In function 'kvm_log_clear':
/tmp/qemu/accel/kvm/kvm-all.c:1086:8: error: 'ret' may be used uninitialized in this function [-Werror=maybe-uninitialized]
     if (r < 0) {
        ^
cc1: all warnings being treated as errors

Kevin
