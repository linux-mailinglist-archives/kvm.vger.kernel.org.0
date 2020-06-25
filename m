Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FB020A2AE
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 18:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403801AbgFYQLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 12:11:38 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22093 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405929AbgFYQLh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 12:11:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593101496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LhIGYjeh1ZLiQBB1Zj+yCORUmvKtDAx28fAGiKeMIyU=;
        b=K581IProzQtZA2jWiiXsfGlrGY7KrKh4SvhlERY+Am15zuzJbxj/BsfMzt5lGzdvIz1DLN
        CRrx4n2ec2iS7LiRv+/hp9FQzahlbRUIK9a7zpRmRDVnYlMHoGJGM7d7xJW5LeHwkquaQD
        wH2KFFOWa8QH9Z1ctiFpef049tVVhj0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-0MK2I85SNWunYIiMRdd3LQ-1; Thu, 25 Jun 2020 12:11:33 -0400
X-MC-Unique: 0MK2I85SNWunYIiMRdd3LQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6066D18585A0;
        Thu, 25 Jun 2020 16:11:31 +0000 (UTC)
Received: from gondolin (ovpn-112-36.ams2.redhat.com [10.36.112.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75A9860C1D;
        Thu, 25 Jun 2020 16:11:26 +0000 (UTC)
Date:   Thu, 25 Jun 2020 18:11:24 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Collin Walling <walling@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH v2 1/2] docs: kvm: add documentation for
 KVM_CAP_S390_DIAG318
Message-ID: <20200625181124.478ddd9f.cohuck@redhat.com>
In-Reply-To: <20200625150724.10021-2-walling@linux.ibm.com>
References: <20200625150724.10021-1-walling@linux.ibm.com>
        <20200625150724.10021-2-walling@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Jun 2020 11:07:23 -0400
Collin Walling <walling@linux.ibm.com> wrote:

> Documentation for the s390 DIAGNOSE 0x318 instruction handling.
> 
> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

Still looks good to me.

