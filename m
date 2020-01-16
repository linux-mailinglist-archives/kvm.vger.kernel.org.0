Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57F7713DCC6
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 15:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgAPOAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 09:00:06 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54869 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726527AbgAPOAG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jan 2020 09:00:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579183205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ndo8jBl/5vjQqvHdgxihw2n6mbBvaP/JOPL2jfnzFuc=;
        b=JLF0WKoCMDjeQ3Vv2Zpy1A1pVq1pwK1aftoMkS8+NZZdGeRLwUMIK87OcEumP2FI86yZOu
        9SznS6RWPYsF+qyOY/93hWKNa55U9zVeqkGaqaZBEVZrLNzunX1ZZQSzMMClfxcbDqpsx8
        a48B4nBKlognRnn0gB3ym9ERy49kigI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-REfpnkSkOBm3ymYBiMMkYQ-1; Thu, 16 Jan 2020 09:00:01 -0500
X-MC-Unique: REfpnkSkOBm3ymYBiMMkYQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E417108C22E;
        Thu, 16 Jan 2020 13:59:59 +0000 (UTC)
Received: from gondolin (unknown [10.36.117.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 985CA60F82;
        Thu, 16 Jan 2020 13:59:55 +0000 (UTC)
Date:   Thu, 16 Jan 2020 14:59:53 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 3/7] s390x: Add cpu id to interrupt
 error prints
Message-ID: <20200116145953.331ac8f5.cohuck@redhat.com>
In-Reply-To: <20200116120513.2244-4-frankja@linux.ibm.com>
References: <20200116120513.2244-1-frankja@linux.ibm.com>
        <20200116120513.2244-4-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Jan 2020 07:05:09 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> It's good to know which cpu broke the test.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/interrupt.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

With whatever formatting tweaks you choose:

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

