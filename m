Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368391FAC84
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 11:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgFPJfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 05:35:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39046 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725911AbgFPJfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 05:35:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592300116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=4OcfCuG1vNGsZvLvoiRnSaiZvP8xLfhihUIJTYWNKxs=;
        b=JeZd360sdnXujxIIirIVX3zQ8r5koaIwinDXIX4BotET4lI/jwnFYjPRmEUU2k9thsNXeJ
        YJ/Bc+YpiOJAaHpmXwzLqRLcEdI86Ee/X9uGYivba7+gNM3sgM9/5xeyRZICFHDfwZJAhw
        CTp9cv0DXjcErBlbCRUtzZNuL8un2zs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-PmwOFWtJPtK_lRromgykUA-1; Tue, 16 Jun 2020 05:35:13 -0400
X-MC-Unique: PmwOFWtJPtK_lRromgykUA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14734107B7C9;
        Tue, 16 Jun 2020 09:35:12 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ED3C25C1C3;
        Tue, 16 Jun 2020 09:35:07 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v9 06/12] s390x: clock and delays
 caluculations
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-7-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <81557eed-ff8e-2076-44f7-2174befce7b5@redhat.com>
Date:   Tue, 16 Jun 2020 11:35:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1592213521-19390-7-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/06/2020 11.31, Pierre Morel wrote:
> The hardware gives us a good definition of the microsecond,
> let's keep this information and let the routine accessing
> the hardware keep all the information and return microseconds.
> 
> Calculate delays in microseconds and take care about wrapping
> around zero.
> 
> Define values with macros and use inlines to keep the
> milliseconds interface.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/asm/time.h | 29 +++++++++++++++++++++++++++--
>  1 file changed, 27 insertions(+), 2 deletions(-)

In case you respin, there is a typo in the title ("caluculations") ...
otherwise this can be fixed when the patch gets picked up.

Reviewed-by: Thomas Huth <thuth@redhat.com>

