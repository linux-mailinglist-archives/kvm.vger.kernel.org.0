Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD83218D7E
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 18:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730906AbgGHQs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 12:48:28 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28320 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730859AbgGHQs1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 12:48:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594226906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gk5CsyRz//5rOTcoJy31fjeY07DBF9ixc4+6ZT8U4F4=;
        b=i34sZacFzW+EC1gabKUnb5/gdzv3qoeKX5J+Ril7dWXB6nte9bmNxPp0+IzbXOWsgODfVj
        LFt9tfGjxs6ldFkjE2QPUz7y+2gJA2PeON6nCCkOb5TfBomhhiUecWPc5KSBntQ78bckJg
        8p855NiYrrxJmA+vn6g+rJFGV0mGjSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-Zqn_tcRqOda6Ovb3bAYjlA-1; Wed, 08 Jul 2020 12:48:25 -0400
X-MC-Unique: Zqn_tcRqOda6Ovb3bAYjlA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2000F8F6CC7;
        Wed,  8 Jul 2020 16:48:24 +0000 (UTC)
Received: from gondolin (ovpn-112-239.ams2.redhat.com [10.36.112.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B8B4C007C;
        Wed,  8 Jul 2020 16:48:17 +0000 (UTC)
Date:   Wed, 8 Jul 2020 18:48:15 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, david@redhat.com,
        kvm@vger.kernel.org, Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [kvm-unit-tests v3 PATCH] s390x/cpumodel: The missing DFP
 facility on TCG is expected
Message-ID: <20200708184815.08072efb.cohuck@redhat.com>
In-Reply-To: <20200708150025.20631-1-thuth@redhat.com>
References: <20200708150025.20631-1-thuth@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  8 Jul 2020 17:00:25 +0200
Thomas Huth <thuth@redhat.com> wrote:

> When running the kvm-unit-tests with TCG on s390x, the cpumodel test
> always reports the error about the missing DFP (decimal floating point)
> facility. This is kind of expected, since DFP is not required for
> running Linux and thus nobody is really interested in implementing
> this facility in TCG. Thus let's mark this as an expected error instead,
> so that we can run the kvm-unit-tests also with TCG without getting
> test failures that we do not care about.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  v3:
>  - Moved the is_tcg() function to the library so that it can be used
>    later by other tests, too
>  - Make sure to call alloc_page() and stsi() only once
> 
>  v2:
>  - Rewrote the logic, introduced expected_tcg_fail flag
>  - Use manufacturer string instead of VM name to detect TCG
> 
>  lib/s390x/vm.c   | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/vm.h   | 14 ++++++++++++++
>  s390x/Makefile   |  1 +
>  s390x/cpumodel.c | 19 +++++++++++++------
>  4 files changed, 74 insertions(+), 6 deletions(-)
>  create mode 100644 lib/s390x/vm.c
>  create mode 100644 lib/s390x/vm.h

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

