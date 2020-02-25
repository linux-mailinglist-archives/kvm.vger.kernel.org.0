Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F28F216C0ED
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 13:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgBYMgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 07:36:46 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50926 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725851AbgBYMgq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 07:36:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582634205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hjh9ZMTm36INDHN1l9wvwIaxYIcO4tSy05tEUhgea0c=;
        b=HaF0I1F/D25UPqEwe5hh3gbznKb+Prky5KMDxKxaYFGPdtvIR6ssCSMXfMjUEWBFdJBJu/
        dbRYqi+1rvhKUoy+YxnE6x2OHDT1aFVtPwWQ/xnar3lAevoVrwVUQ/zuc70rc8QAfSMLPI
        g3OZKKdMixKa88t5SxblaaOol3nSDs8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-moV7LrWZOVWjVyrrpyN1rQ-1; Tue, 25 Feb 2020 07:36:41 -0500
X-MC-Unique: moV7LrWZOVWjVyrrpyN1rQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4F488017CC;
        Tue, 25 Feb 2020 12:36:39 +0000 (UTC)
Received: from gondolin (dhcp-192-175.str.redhat.com [10.33.192.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65EEE60E1C;
        Tue, 25 Feb 2020 12:36:35 +0000 (UTC)
Date:   Tue, 25 Feb 2020 13:36:32 +0100
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
Subject: Re: [PATCH v4 25/36] KVM: s390: protvirt: Only sync fmt4 registers
Message-ID: <20200225133632.7ae5593e.cohuck@redhat.com>
In-Reply-To: <20200224114107.4646-26-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
        <20200224114107.4646-26-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Feb 2020 06:40:56 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> A lot of the registers are controlled by the Ultravisor and never
> visible to KVM. Also some registers are overlayed, like gbea is with
> sidad, which might leak data to userspace.
> 
> Hence we sync a minimal set of registers for both SIE formats and then
> check and sync format 2 registers if necessary.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 110 +++++++++++++++++++++++++--------------
>  1 file changed, 70 insertions(+), 40 deletions(-)
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

