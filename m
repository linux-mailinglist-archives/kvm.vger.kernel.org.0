Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3749B16C2A3
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 14:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgBYNoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 08:44:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52386 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729142AbgBYNoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 08:44:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582638265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cGATNmipDFnh71UqOj75hrsgfb7evbo7MX7vJzGdUYY=;
        b=IAH4Aq0ENprmplefS0YUazCrUzaIPkYgRSqeHVa+0LyB5QqqfJmRXvVXLbJPx+Pfq8yIv2
        LJEsMcMqBzpfbsFYlKpCo0cd+bkOYMNhLbqhIuhC32EVcrFwaIVHEI2KjYAP2fzT/U7Kai
        mAIMK7xw995rVsztCswfxsM6XzwNSS4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-ARZN6QY6Mput5bBHhwKlrA-1; Tue, 25 Feb 2020 08:44:20 -0500
X-MC-Unique: ARZN6QY6Mput5bBHhwKlrA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE82C107ACC4;
        Tue, 25 Feb 2020 13:44:18 +0000 (UTC)
Received: from gondolin (dhcp-192-175.str.redhat.com [10.33.192.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D99C5C28C;
        Tue, 25 Feb 2020 13:44:14 +0000 (UTC)
Date:   Tue, 25 Feb 2020 14:44:12 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Ulrich.Weigand@de.ibm.com, david@redhat.com, frankja@linux.ibm.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH v4 28/36] KVM: s390: protvirt: Report CPU state to
 Ultravisor
Message-ID: <20200225144412.52250925.cohuck@redhat.com>
In-Reply-To: <20200225132106.637817-1-borntraeger@de.ibm.com>
References: <20200225140151.5e639df1.cohuck@redhat.com>
        <20200225132106.637817-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Feb 2020 08:21:06 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> VCPU states have to be reported to the ultravisor for SIGP
> interpretation, kdump, kexec and reboot.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/uv.h | 15 +++++++++++++
>  arch/s390/kvm/diag.c       |  6 +++++-
>  arch/s390/kvm/intercept.c  |  4 ++++
>  arch/s390/kvm/kvm-s390.c   | 44 +++++++++++++++++++++++++++++---------
>  arch/s390/kvm/kvm-s390.h   |  5 +++--
>  arch/s390/kvm/pv.c         | 18 ++++++++++++++++
>  6 files changed, 79 insertions(+), 13 deletions(-)

Looks good.

