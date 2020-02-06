Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3C7D1542F1
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 12:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgBFLVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 06:21:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44972 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726744AbgBFLVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 06:21:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580988095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=++VS5mmwEjvYtcrvXja/cVf5jWRGUj6gpvdJxrkCLGc=;
        b=Smo/C4L4Au2IHhIcZ64PWuyXYDsNlSSxLCqSfzEzF2KPAAjB+mZe0MHHLKN5Df6lQsRi18
        L77NVUiRIb9xfxsCut+cCGKgpcfCy096L8nMBDnQZY/GJrpz8b/GWxm7P28WjyrIYLGnQi
        ebD3Yp1bla4VcUKecpZAAlLMlt/18y4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-UrcALeyUMFa5Sm_jK_r0Bw-1; Thu, 06 Feb 2020 06:21:32 -0500
X-MC-Unique: UrcALeyUMFa5Sm_jK_r0Bw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 394EB801A11;
        Thu,  6 Feb 2020 11:21:31 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-151.ams2.redhat.com [10.36.116.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CE1E4790FD;
        Thu,  6 Feb 2020 11:21:25 +0000 (UTC)
Subject: Re: [RFCv2 33/37] KVM: s390: protvirt: Support cmd 5 operation state
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-34-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d58effd4-c084-9d75-c4ed-cfabf7ec43a5@redhat.com>
Date:   Thu, 6 Feb 2020 12:21:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-34-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> Code 5 for the set cpu state UV call tells the UV to load a PSW from
> the SE header (first IPL) or from guest location 0x0 (diag 308 subcode
> 0/1). Also it sets the cpu into operating state afterwards, so we can
> start it.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/uv.h | 1 +
>  arch/s390/kvm/kvm-s390.c   | 7 +++++++
>  include/uapi/linux/kvm.h   | 1 +
>  3 files changed, 9 insertions(+)

Reviewed-by: Thomas Huth <thuth@redhat.com>

