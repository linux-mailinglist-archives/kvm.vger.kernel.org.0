Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D28A2DF4DD
	for <lists+kvm@lfdr.de>; Sun, 20 Dec 2020 10:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgLTJmB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Dec 2020 04:42:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34293 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727159AbgLTJmA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 20 Dec 2020 04:42:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608457234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qu181/SxorcHfWdvdcSj+pkwAFVA8G1yAvMSmmXwoBY=;
        b=GEjxzgTnHySXgpBRQpBgncUNvb07Tk94QfEcODZzpk73O17hxo9oAKtdUU5nEjG8sw6j3J
        gG03r31QWajUOCLg57Jhn1O4I/ZU9rBpuZaFLgY5dwhexivfpxWbuoUoviKn/f+M0ButNN
        TeEFGf0AnKDqIx154nHGxV0UR5G52bY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-BXSYY0nONT25flmeROQzhA-1; Sun, 20 Dec 2020 04:40:30 -0500
X-MC-Unique: BXSYY0nONT25flmeROQzhA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 744291005504;
        Sun, 20 Dec 2020 09:40:29 +0000 (UTC)
Received: from [10.36.112.16] (ovpn-112-16.ams2.redhat.com [10.36.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 438AD2CD65;
        Sun, 20 Dec 2020 09:40:28 +0000 (UTC)
Subject: Re: [PATCH v1 0/4] s390/kvm: fix MVPG when in VSIE
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20201218141811.310267-1-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <5947ede7-7f9f-cdaa-b827-75a5715e4f12@redhat.com>
Date:   Sun, 20 Dec 2020 10:40:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201218141811.310267-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.12.20 15:18, Claudio Imbrenda wrote:
> The current handling of the MVPG instruction when executed in a nested
> guest is wrong, and can lead to the nested guest hanging.

Hi,

thanks for spotting and debugging! Is this related to nested guests
hanging while migrating (mentioned by Janosch at some point)?

Or can this not be reproduced with actual Linux guests?

Thanks!

> 
> This patchset fixes the behaviour to be more architecturally correct,
> and fixes the hangs observed.
> 
> Claudio Imbrenda (4):
>   s390/kvm: VSIE: stop leaking host addresses
>   s390/kvm: extend guest_translate for MVPG interpretation
>   s390/kvm: add kvm_s390_vsie_mvpg_check needed for VSIE MVPG
>   s390/kvm: VSIE: correctly handle MVPG when in VSIE
> 
>  arch/s390/kvm/gaccess.c | 88 ++++++++++++++++++++++++++++++++++++++---
>  arch/s390/kvm/gaccess.h |  3 ++
>  arch/s390/kvm/vsie.c    | 78 +++++++++++++++++++++++++++++++++---
>  3 files changed, 159 insertions(+), 10 deletions(-)
> 


-- 
Thanks,

David / dhildenb

