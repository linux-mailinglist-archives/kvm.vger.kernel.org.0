Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17042FEC83
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 15:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbhAUN7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 08:59:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35168 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730872AbhAUN61 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 08:58:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611237421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y1u65HCJZA7725nOWPZimtdtyPWR7xwzbel9NFd7NPQ=;
        b=A0hBj5YHDAeh55VBxSRD3NUF798Z+/L4ei2gNVDyZaCFW+YwH6DeqtmZYSeYdC3HBusvH0
        b4+HGb/clC5meSn94rtUzqocZwgmSPv6nn9m63soTenochlewJG9X7l7ZYI83RSfEGVTT3
        1NX23k5Rrq9zZSDHaeCdbxlIHYyGRx0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-wi-NZhgaO8WhDrg6meQhOg-1; Thu, 21 Jan 2021 08:56:57 -0500
X-MC-Unique: wi-NZhgaO8WhDrg6meQhOg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F2E1DF8AE;
        Thu, 21 Jan 2021 13:56:56 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-82.ams2.redhat.com [10.36.112.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D2075D6AD;
        Thu, 21 Jan 2021 13:56:54 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 2/3] s390x: define UV compatible I/O
 allocation
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com, pbonzini@redhat.com
References: <1611220392-22628-1-git-send-email-pmorel@linux.ibm.com>
 <1611220392-22628-3-git-send-email-pmorel@linux.ibm.com>
 <6c232520-dbd1-80e4-e3a3-949964df7403@linux.ibm.com>
 <3bce47db-c58c-6a2e-be72-9953f16a2dd4@linux.ibm.com>
 <0a46a299-c52d-2c7f-bb38-8d58afe053e0@redhat.com>
 <ab6a5d6d-29e1-4ccd-64dd-6e39888cb439@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <e32a6fba-0d93-3468-e180-f9b157146daf@redhat.com>
Date:   Thu, 21 Jan 2021 14:56:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <ab6a5d6d-29e1-4ccd-64dd-6e39888cb439@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/2021 14.47, Pierre Morel wrote:
[...]
> For MAINTAINERS, the Linux kernel checkpatch warns that we should use
> TABS instead of SPACES between item and names.

Interesting, I wasn't aware of that. I guess it's simply because the 
MAINTAINERS file in kvm-unit-tests is older than the patch that changed the 
checkpatch script in the kernel, and updates to the MAINTAINRS file in k-u-t 
are so seldom that nobody really noticed afterwards.

If it bothers you, feel free to send a patch to fix k-u-t's MAINTAINERS 
file, it might be nice indeed to be aligned with the kernel here again.

  Thomas


