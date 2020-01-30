Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D33BC14DB70
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgA3NUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:20:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38079 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726996AbgA3NUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 08:20:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580390447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=+JHBG66v9eZtyfD6jCjQDZZvvUnFhotRfAzEXNyO+cc=;
        b=RgLjDloLXVoR61iDYyQDxcPgG5pmpGj1oQtOsnwORaplB9LeWeX/sAVbaltb3hZn6ifqvP
        vb7jUrw62ngPl7FE9NSWZQZl1EXPq6cwrTUYYjPKMPvU65xrSfeKCUfUkMGwMSy/omNWct
        mpL7TA7u+eMvdUocMYV70RaZye1Dlkc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-WdUVflfFNH6Z0PnSn-IhaQ-1; Thu, 30 Jan 2020 08:20:43 -0500
X-MC-Unique: WdUVflfFNH6Z0PnSn-IhaQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2AFD210054E3;
        Thu, 30 Jan 2020 13:20:42 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-117-117.ams2.redhat.com [10.36.117.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4125C86C4D;
        Thu, 30 Jan 2020 13:20:38 +0000 (UTC)
Subject: Re: [PATCH v9 2/6] KVM: s390: Cleanup initial cpu reset
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20200130123434.68129-1-frankja@linux.ibm.com>
 <20200130123434.68129-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3096ea7a-f3a9-e3f5-336c-13c01fef385e@redhat.com>
Date:   Thu, 30 Jan 2020 14:20:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200130123434.68129-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/01/2020 13.34, Janosch Frank wrote:
> The code seems to be quite old and uses lots of unneeded spaces for
> alignment, which doesn't really help with readability.
> 
> Let's:
> * Get rid of the extra spaces
> * Remove the ULs as they are not needed on 0s
> * Define constants for the CR 0 and 14 initial values
> * Use the sizeof of the gcr array to memset it to 0
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  5 +++++
>  arch/s390/kvm/kvm-s390.c         | 18 +++++++-----------
>  2 files changed, 12 insertions(+), 11 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

