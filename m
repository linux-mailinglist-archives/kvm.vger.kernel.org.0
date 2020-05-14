Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD45A1D2898
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 09:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgENHPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 03:15:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45224 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725925AbgENHPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 03:15:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589440546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=33Ais6DTYMUky9MuqWqgV8vT9NZDYR4vKamfmmChtk0=;
        b=g7amM8RRRsNMRV09oO3ZZ509/VEDihrb1zuXAPio0pmstdxefN/MVaDpbAgfoV1jk5RbTA
        FMZRhiDxv4CARu6IfNnhefUtLg8JnSUqwRbowwBg3CutRnLRy6fheDFU1nUWEiKlG0HdL1
        arK08zc+lry7YCh6y1HuJY+CdSAwT8Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-IQ03HJshMYSUfe3F_NPBag-1; Thu, 14 May 2020 03:15:42 -0400
X-MC-Unique: IQ03HJshMYSUfe3F_NPBag-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A1FB19200D1;
        Thu, 14 May 2020 07:15:41 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-31.ams2.redhat.com [10.36.113.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CC9356E6F4;
        Thu, 14 May 2020 07:15:34 +0000 (UTC)
Subject: Re: [PATCH v6 1/2] s390/setup: diag318: refactor struct
To:     Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <20200513221557.14366-1-walling@linux.ibm.com>
 <20200513221557.14366-2-walling@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c6fc70d4-9bb4-6651-fce3-6fc2834bd9a6@redhat.com>
Date:   Thu, 14 May 2020 09:15:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200513221557.14366-2-walling@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/05/2020 00.15, Collin Walling wrote:
> The diag318 struct introduced in include/asm/diag.h can be
> reused in KVM, so let's condense the version code fields in the
> diag318_info struct for easier usage and simplify it until we
> can determine how the data should be formatted.
> 
> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  arch/s390/include/asm/diag.h | 6 ++----
>  arch/s390/kernel/setup.c     | 3 +--
>  2 files changed, 3 insertions(+), 6 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

