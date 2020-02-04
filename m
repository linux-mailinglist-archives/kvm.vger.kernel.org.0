Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E68E51520A5
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 19:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgBDSvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 13:51:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37830 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727308AbgBDSvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 13:51:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580842291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1rFhYgh/smposCfjMFSoEp/7pqWycBMWZWt48BVIoyY=;
        b=D8CWQiGPc40OyKjL1Smjw/M60S1zCOEoJko4fV6/t7GcCGBvx8V6t4N4SllswWSZBJfINF
        OdXQR9fByoxYvvPpHIt5ZKpZ/PZA8Zp6jrYn4M2Q+7opLole9+GfbVmdKivAbtMTBq1iPL
        8kCKRw3keVdwBeIVX8p4SCSQZFWdHgI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-D3jW8QyuMRGV4R74ze0Bzw-1; Tue, 04 Feb 2020 13:51:26 -0500
X-MC-Unique: D3jW8QyuMRGV4R74ze0Bzw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F6BA800D5C;
        Tue,  4 Feb 2020 18:51:25 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E606381213;
        Tue,  4 Feb 2020 18:51:20 +0000 (UTC)
Date:   Tue, 4 Feb 2020 19:51:18 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 30/37] KVM: s390: protvirt: Add diag 308 subcode 8 - 10
 handling
Message-ID: <20200204195118.20a86328.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-31-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-31-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:50 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> If the host initialized the Ultravisor, we can set stfle bit 161
> (protected virtual IPL enhancements facility), which indicates, that

s/indicates,/indicates/

> the IPL subcodes 8, 9 and are valid. These subcodes are used by a

s/9 and/9, and 10/

> normal guest to set/retrieve a IPIB of type 5 and transition into

"an IPL information block of type 5 (for PVMs)" ?

> protected mode.
> 
> Once in protected mode, the Ultravisor will conceal the facility
> bit. Therefore each boot into protected mode has to go through
> non-protected. There is no secure re-ipl with subcode 10 without a

"non-protected mode"

> previous subcode 3.
> 
> In protected mode, there is no subcode 4 available, as the VM has no
> more access to its memory from non-protected mode. I.e. each IPL
> clears.

"i.e., only IPL clear is possible" ?

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/diag.c     | 6 ++++++
>  arch/s390/kvm/kvm-s390.c | 5 +++++
>  2 files changed, 11 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

