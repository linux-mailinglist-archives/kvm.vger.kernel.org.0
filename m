Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF85211412F
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 14:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbfLENFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 08:05:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23937 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729396AbfLENFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 08:05:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575551143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uhflj/+QnT6WZK8bzEkvOoIb1ZY7BNfJ99XdKdQMZ2o=;
        b=KR+bmUo9onKB2AaWE0zMdC2umdN1RvpVf8QzPhJrCDX0PXwp9uYMZO9V15foztd3Pb3w1m
        nxigyTH0PCYrPPbxSafDbmcDzwOnFRo5anml97LpJR9AaV1X4PDSLz7PYAlFf2KN+gdLEf
        uk7LmFFJrD2m3iAO9YMlPfSQOchAWBQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-hJdBcnM1NpWGOPTLjtWplg-1; Thu, 05 Dec 2019 08:05:40 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 983C91005513;
        Thu,  5 Dec 2019 13:05:39 +0000 (UTC)
Received: from gondolin (unknown [10.36.118.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E340C51C3B;
        Thu,  5 Dec 2019 13:05:34 +0000 (UTC)
Date:   Thu, 5 Dec 2019 14:05:32 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: ENOTSUPP -> EOPNOTSUPP fixups
Message-ID: <20191205140532.7760b69c.cohuck@redhat.com>
In-Reply-To: <20191205125147.229367-1-borntraeger@de.ibm.com>
References: <20191205125147.229367-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: hJdBcnM1NpWGOPTLjtWplg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  5 Dec 2019 13:51:47 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> There is no ENOTSUPP for userspace

s/userspace/userspace./

Fixes: 519783935451 ("KVM: s390: introduce ais mode modify function")
Fixes: 2c1a48f2e5ed ("KVM: S390: add new group for flic")

> 
> Reported-by: Julian Wiedmann <jwi@linux.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kvm/interrupt.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

