Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA88170599
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 18:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgBZRIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 12:08:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46112 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727905AbgBZRIf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 12:08:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582736913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RiVwEifw8zuF7zAuDeFJ0On+X58XyhYY0dWkpf+3+uQ=;
        b=jWIn8XTb1h/QZvGQwh+mtnmPPLn6AUgBGJnEXs5CnIKaVs+A8iBLZ4CZZK6Wo1SR6bQdoH
        BGR8DNsNtQnI79wJWjPArEkY5VuMdrG/gir+KzFoPaTmkXL1EHfA7nXBQvOtcy9nHRNyVb
        GDUBYBxu9VsXJrTfcereG1CXNRb4pd8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-Q7Lqt4vHN_2bd7k8ItajtQ-1; Wed, 26 Feb 2020 12:08:29 -0500
X-MC-Unique: Q7Lqt4vHN_2bd7k8ItajtQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C680800053;
        Wed, 26 Feb 2020 17:08:28 +0000 (UTC)
Received: from gondolin (ovpn-117-69.ams2.redhat.com [10.36.117.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C87F5D9CD;
        Wed, 26 Feb 2020 17:08:21 +0000 (UTC)
Date:   Wed, 26 Feb 2020 18:08:19 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Ulrich.Weigand@de.ibm.com, david@redhat.com, frankja@linux.ibm.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH v4.6 09/36] KVM: s390: protvirt: Add initial vm and cpu
 lifecycle handling
Message-ID: <20200226180819.5fd59e1e.cohuck@redhat.com>
In-Reply-To: <20200226170020.9061-1-borntraeger@de.ibm.com>
References: <20200226175428.40143164.cohuck@redhat.com>
        <20200226170020.9061-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 26 Feb 2020 12:00:20 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> This contains 3 main changes:
> 1. changes in SIE control block handling for secure guests
> 2. helper functions for create/destroy/unpack secure guests
> 3. KVM_S390_PV_COMMAND ioctl to allow userspace dealing with secure
> machines
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  24 ++-
>  arch/s390/include/asm/uv.h       |  69 ++++++++
>  arch/s390/kvm/Makefile           |   2 +-
>  arch/s390/kvm/kvm-s390.c         | 214 ++++++++++++++++++++++++-
>  arch/s390/kvm/kvm-s390.h         |  33 ++++
>  arch/s390/kvm/pv.c               | 267 +++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h         |  31 ++++
>  7 files changed, 636 insertions(+), 4 deletions(-)
>  create mode 100644 arch/s390/kvm/pv.c

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

