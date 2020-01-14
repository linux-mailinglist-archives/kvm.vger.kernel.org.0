Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B99113B164
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 18:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgANRxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 12:53:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34022 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726053AbgANRxo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 12:53:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579024424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4syO2OJitCPZMLeT4umxdU4l89eDq19+eiMTGVFNzSg=;
        b=QcUS4L74hQgdLPEuw0QvRdZWnkNrH0U/chwPAC73ftDgRjHN7roLIFN7s0fj5KISvJigdy
        dvw6+zv15HMYFCm6sHwkuimibDnsLq6mR1tk9W31k5MSBlf2jMkEgibt6N4by6iBShFs5/
        Fo0fK6TPdeXT6ACnraJuLNJ70lENWQ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-onjmxKY8OTGVgvD3GIiXnA-1; Tue, 14 Jan 2020 12:53:40 -0500
X-MC-Unique: onjmxKY8OTGVgvD3GIiXnA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1CBF107B7D5;
        Tue, 14 Jan 2020 17:53:39 +0000 (UTC)
Received: from gondolin (ovpn-117-161.ams2.redhat.com [10.36.117.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCD6F5C290;
        Tue, 14 Jan 2020 17:53:35 +0000 (UTC)
Date:   Tue, 14 Jan 2020 18:53:33 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH 4/4] s390x: smp: Dirty fpc before initial
 reset test
Message-ID: <20200114185333.0f613089.cohuck@redhat.com>
In-Reply-To: <20200114153054.77082-5-frankja@linux.ibm.com>
References: <20200114153054.77082-1-frankja@linux.ibm.com>
        <20200114153054.77082-5-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Jan 2020 10:30:53 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's dirty the fpc, before we test if the initial reset sets it to 0.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/smp.c | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

