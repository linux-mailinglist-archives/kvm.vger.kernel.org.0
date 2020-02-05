Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCC2715371E
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 18:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgBER7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 12:59:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40687 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726822AbgBER7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 12:59:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580925587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=CLct8dLigCuQCFLSQJP+cZ3MQBISZc9MVp91MOh9iZ8=;
        b=bIb9P4tiBE8ytLX3Imev1YYY/rLuAWcp/a3J5NNHqdU95EiS5AXBOfSKxeE3N/updh54+v
        6SRMFWy9JCVspUhi/B5AQVk/GUEp404TJfhjcX2PN+pF7wlS5LswACxN3AVFUt9+n7vL+0
        6mc1E7X/ci1jg1hhmtmddXi7/mD3yFU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-bUzcbmdxPqKw_9tratf8hQ-1; Wed, 05 Feb 2020 12:59:43 -0500
X-MC-Unique: bUzcbmdxPqKw_9tratf8hQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5CA8800D54;
        Wed,  5 Feb 2020 17:59:41 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-186.ams2.redhat.com [10.36.116.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 763518CCFB;
        Wed,  5 Feb 2020 17:59:37 +0000 (UTC)
Subject: Re: [RFCv2 28/37] KVM: s390: protvirt: Add program exception
 injection
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-29-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f3d653e3-7790-628b-746b-1dcb2eed7021@redhat.com>
Date:   Wed, 5 Feb 2020 18:59:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-29-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> Only two program exceptions can be injected for a protected guest:
> specification and operand
> 
> Both have a code in offset 248 of the state description, as the lowcore
> is not accessible by KVM for such guests.

What do you mean with offset 248 here? You only touch the iictl field
here, and looking at patch 14/37, iictl is at offset 0x55 ...?

 Thomas

