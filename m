Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC3EB16C164
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 13:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbgBYMvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 07:51:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24902 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729066AbgBYMvT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 07:51:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582635078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oJJbCrDOg362Ns9pveeSj4gViDxbtBm61qCAJmaav9I=;
        b=ABJKyTo/D8EdFIJ0lNy+ll6hoQITFFdf2EiFuYpULRrV4t0VoRIR3KesWbFVnAaspKs+bi
        jTUrtJSB47F4QP1XTiYbF3cJ47erY1br39z/ehi+HuijemWeRWT+92J4sC1/O8Tckii73i
        damca2AjlVyRKiRHTGVSb2kVLJar+3M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-B89vS0NtOhiVBmzbbtUxOA-1; Tue, 25 Feb 2020 07:51:14 -0500
X-MC-Unique: B89vS0NtOhiVBmzbbtUxOA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23349477;
        Tue, 25 Feb 2020 12:51:13 +0000 (UTC)
Received: from gondolin (dhcp-192-175.str.redhat.com [10.33.192.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 985AC909F7;
        Tue, 25 Feb 2020 12:51:08 +0000 (UTC)
Date:   Tue, 25 Feb 2020 13:51:06 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v4 27/36] KVM: s390: protvirt: UV calls in support of
 diag308 0, 1
Message-ID: <20200225135106.294aadb9.cohuck@redhat.com>
In-Reply-To: <20200224114107.4646-28-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
        <20200224114107.4646-28-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Feb 2020 06:40:58 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> diag 308 subcode 0 and 1 require several KVM and Ultravisor interactions.
> Specific to these "soft" reboots are
> 
> * The "unshare all" UVC
> * The "prepare for reset" UVC
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/uv.h |  4 ++++
>  arch/s390/kvm/kvm-s390.c   | 22 ++++++++++++++++++++++
>  include/uapi/linux/kvm.h   |  2 ++
>  3 files changed, 28 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

