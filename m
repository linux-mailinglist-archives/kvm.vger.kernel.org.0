Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B47EA15748E
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 13:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgBJM3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 07:29:24 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58071 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726796AbgBJM3Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Feb 2020 07:29:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581337763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=Ohe+OAenhotNUhazgAZQte9AY+HCibQNNx5FPueSPcs=;
        b=JEvgK4YGFsrPWXsNoxoClvbWJdbBp12HQZTRFwDWeV7z14ovk3i/UDfXtPSUi8dc6UbCv9
        98Q5+inYUEmEZE3kTfstA/EQyL8XOcU1K8FvS0WuC/2/g5qKdJ1OOloTHto4Eb0rngXHqA
        iNv4XRlVm80JiZu/4V+YbHJaar0Apr8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108--KKBmQ2hNaOnrM2Yg6RT8Q-1; Mon, 10 Feb 2020 07:29:17 -0500
X-MC-Unique: -KKBmQ2hNaOnrM2Yg6RT8Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D8BB10054E3;
        Mon, 10 Feb 2020 12:29:15 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-219.ams2.redhat.com [10.36.116.219])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FE1110013A7;
        Mon, 10 Feb 2020 12:29:10 +0000 (UTC)
Subject: Re: [PATCH/RFC] KVM: s390: protvirt: pass-through rc and rrc
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Ulrich.Weigand@de.ibm.com, aarcange@redhat.com, cohuck@redhat.com,
        david@redhat.com, frankja@linux.ibm.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com
References: <62d5cd46-93d7-e272-f9bb-d4ec3c7a1f71@de.ibm.com>
 <20200210114526.134769-1-borntraeger@de.ibm.com>
 <a94f3d09-1474-29d2-a2d3-3118170e494e@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b43e16d0-6a1c-3898-fadf-794c1e6a0044@redhat.com>
Date:   Mon, 10 Feb 2020 13:29:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a94f3d09-1474-29d2-a2d3-3118170e494e@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/02/2020 13.06, Christian Borntraeger wrote:
> What about the following. I will rip out RC and RRC but add 
> a 32bit flags field (which must be 0) and 3*64 bit reserved.

Flags and reserved always sounds good :-)

 Thomas

