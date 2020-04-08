Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 780581A1D1A
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 10:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgDHIKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 04:10:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59338 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726525AbgDHIKY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 04:10:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586333422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ku+EAOPg4vOvWbFqhNdMl4JM7x36akNpLyA8tGgpuD8=;
        b=Zn7B5/xy1fn/ybaswuxXtYQvP86Jqv4deziAbe9isxhvPCsyg8HXRSxSKkqT33x0Yae8Kg
        ev3x+wCcJ6HbFSOGtQUIZJoZTqbumwfeQDcUSbBU1bdeoa3S+zsjsVk4u6kBWbI5FuBL6R
        OukEUIguuUp7guNS831m3BZL6rTcWDY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-raFHZzh3O6iyC_Fqr9rXIQ-1; Wed, 08 Apr 2020 04:10:20 -0400
X-MC-Unique: raFHZzh3O6iyC_Fqr9rXIQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 817BADB69;
        Wed,  8 Apr 2020 08:10:19 +0000 (UTC)
Received: from gondolin (ovpn-113-103.ams2.redhat.com [10.36.113.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 870E55E010;
        Wed,  8 Apr 2020 08:10:07 +0000 (UTC)
Date:   Wed, 8 Apr 2020 10:10:04 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+d889b59b2bb87d4047a2@syzkaller.appspotmail.com
Subject: Re: [PATCH 0/2] KVM: Fix out-of-bounds memslot access
Message-ID: <20200408101004.09b1f56d.cohuck@redhat.com>
In-Reply-To: <526247ac-4201-8b3d-0f15-d93b12a530b8@de.ibm.com>
References: <20200408064059.8957-1-sean.j.christopherson@intel.com>
        <526247ac-4201-8b3d-0f15-d93b12a530b8@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Apr 2020 09:24:27 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 08.04.20 08:40, Sean Christopherson wrote:
> > Two fixes for what are effectively the same bug.  The binary search used
> > for memslot lookup doesn't check the resolved index and can access memory
> > beyond the end of the memslot array.
> > 
> > I split the s390 specific change to a separate patch because it's subtly
> > different, and to simplify backporting.  The KVM wide fix can be applied
> > to stable trees as is, but AFAICT the s390 change would need to be paired
> > with the !used_slots check from commit 774a964ef56 ("KVM: Fix out of range  
> 
> I cannot find the commit id 774a964ef56
> 

It's 0774a964ef561b7170d8d1b1bfe6f88002b6d219 in my tree.

