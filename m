Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90BE015764F
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 13:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbgBJMu4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 07:50:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32877 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728581AbgBJMuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 07:50:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581339053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1IJRtkCDur7p0zYZGeR4JolF3EOrpqliDm1gsG8BHXs=;
        b=GCsAdsoUB3Tg+/raKlMVvuovMohnsD+iDz27HiUdmoJp/FSt8h2CtlPrEgjS32/V8ecyCm
        wh0xLU0KxXbSceprUbnGgxYy02MsrrxyGzdQLLCMKV7YoIEtzU8F4Ao9XbCgrot0AFvOtK
        uKKUqU+skAjOBlZUETh5KNfOEWqnovQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-bGAitkBlM8uj-tLxh-Nwlg-1; Mon, 10 Feb 2020 07:50:49 -0500
X-MC-Unique: bGAitkBlM8uj-tLxh-Nwlg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2287F107ACC5;
        Mon, 10 Feb 2020 12:50:48 +0000 (UTC)
Received: from gondolin (ovpn-117-244.ams2.redhat.com [10.36.117.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 070B0387;
        Mon, 10 Feb 2020 12:50:42 +0000 (UTC)
Date:   Mon, 10 Feb 2020 13:50:40 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     thuth@redhat.com, Ulrich.Weigand@de.ibm.com, aarcange@redhat.com,
        david@redhat.com, frankja@linux.ibm.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com
Subject: Re: [PATCH/RFC] KVM: s390: protvirt: pass-through rc and rrc
Message-ID: <20200210135040.24f06b8e.cohuck@redhat.com>
In-Reply-To: <a94f3d09-1474-29d2-a2d3-3118170e494e@de.ibm.com>
References: <62d5cd46-93d7-e272-f9bb-d4ec3c7a1f71@de.ibm.com>
        <20200210114526.134769-1-borntraeger@de.ibm.com>
        <a94f3d09-1474-29d2-a2d3-3118170e494e@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Feb 2020 13:06:19 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> What about the following. I will rip out RC and RRC but add 
> a 32bit flags field (which must be 0) and 3*64 bit reserved.

Probably dumb question: How are these new fields supposed to be used?

