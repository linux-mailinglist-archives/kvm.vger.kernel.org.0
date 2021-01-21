Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3892FE684
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 10:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbhAUJif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 04:38:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728869AbhAUJhS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 04:37:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611221752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gPUS5vESvsLi05bhYcFBE1BmgsDV5MC3h4lSs3Gy4mI=;
        b=QsNhPm9bJBGFgyI1d/6CLFoKu2/uRzHcIgzXlU5CeUT25/0gc3l/3aaGjmCzWGSwhou0bC
        /wjJLuokA9rwkCieJdxlPjJMm2qjJrgbZET6cOPUtqmbu0xJ9IiI3AChl6lrWU/G/Lbx5g
        s294kwm1qbq73DKrI2lJ2EddMFhGPx4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-s2G4kChgMT2azx-0-3lhcg-1; Thu, 21 Jan 2021 04:35:50 -0500
X-MC-Unique: s2G4kChgMT2azx-0-3lhcg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75199803F47;
        Thu, 21 Jan 2021 09:35:49 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-82.ams2.redhat.com [10.36.112.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECC1B5F708;
        Thu, 21 Jan 2021 09:35:43 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 3/3] s390x: css: pv: css test adaptation
 for PV
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        drjones@redhat.com, pbonzini@redhat.com
References: <1611220392-22628-1-git-send-email-pmorel@linux.ibm.com>
 <1611220392-22628-4-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <15b91686-97a0-5811-914c-a805dda58f57@redhat.com>
Date:   Thu, 21 Jan 2021 10:35:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1611220392-22628-4-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/2021 10.13, Pierre Morel wrote:
> We want the tests to automatically work with or without protected
> virtualisation.
> To do this we need to share the I/O memory with the host.
> 
> Let's replace all static allocations with dynamic allocations
> to clearly separate shared and private memory.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/css.h     |  3 +--
>   lib/s390x/css_lib.c | 28 ++++++++--------------------
>   s390x/css.c         | 43 +++++++++++++++++++++++++++++++------------
>   3 files changed, 40 insertions(+), 34 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

