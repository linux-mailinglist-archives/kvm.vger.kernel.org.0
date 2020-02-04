Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB26151860
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 11:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgBDKDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 05:03:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25583 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726343AbgBDKDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 05:03:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580810609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=TLnAtNlPNa3A9DgXCAHq3io3EQGtrCKuv87uBJ26/0A=;
        b=ZWzh6Wi1r+WbawwDT7M3ZQ1aCnD8EnbLBE+q8eWARsZBvFrUt7Bhx42zB+b+U9qD8TlWq1
        J5uoiXAx1KhJ+2CwGe82Ckiz6GAZAeWSLPkgCBQ/VOd4RqvBXSb6mrunst+sboK1JzdRfr
        oEqzjOdaytiDzKywvnDvO0GUHSl9BqE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-o_QzFGNDM3mzi11_bsdjcg-1; Tue, 04 Feb 2020 05:03:25 -0500
X-MC-Unique: o_QzFGNDM3mzi11_bsdjcg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D82CD1336564;
        Tue,  4 Feb 2020 10:03:23 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-39.ams2.redhat.com [10.36.116.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 714477792B;
        Tue,  4 Feb 2020 10:03:19 +0000 (UTC)
Subject: Re: [RFCv2 03/37] s390/protvirt: add ultravisor initialization
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-4-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7d8aa3e8-e92e-d19a-415c-8636b4665bc6@redhat.com>
Date:   Tue, 4 Feb 2020 11:03:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-4-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Vasily Gorbik <gor@linux.ibm.com>
> 
> Before being able to host protected virtual machines, donate some of
> the memory to the ultravisor. Besides that the ultravisor might impose
> addressing limitations for memory used to back protected VM storage. Treat
> that limit as protected virtualization host's virtual memory limit.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/uv.h | 16 ++++++++++++
>  arch/s390/kernel/setup.c   |  3 +++
>  arch/s390/kernel/uv.c      | 53 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 72 insertions(+)

Reviewed-by: Thomas Huth <thuth@redhat.com>

