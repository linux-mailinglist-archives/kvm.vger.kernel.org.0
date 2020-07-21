Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0C2228229
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 16:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgGUO23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 10:28:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56912 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728383AbgGUO23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 10:28:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595341708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=y2qvg1CvtPJ4xDtS15t2KA6QteELUamJcJY+W1McomI=;
        b=YVFOSC7kEYljkiztrhYumj3G5mwBMzOFKUE6o4HmjMd6lbKRwhfu/EYfLt+Euxlwp4qwq8
        6N5GYUgFY3sIHKCkVhSq9+jG2lz33Kx4TgeqGdDMBLHnwMwhCxWEtzVZPY4YVO2vCerO/W
        QXoB1lVRQ/bTtj8Bi/1gvmSTx3xhDxY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-2t5jKWfbPX-6To7QLwzEKA-1; Tue, 21 Jul 2020 10:28:24 -0400
X-MC-Unique: 2t5jKWfbPX-6To7QLwzEKA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 079071005504;
        Tue, 21 Jul 2020 14:28:23 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-89.ams2.redhat.com [10.36.112.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A6F37B415;
        Tue, 21 Jul 2020 14:28:18 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: skrf: Add exception new skey
 test and add test to unittests.cfg
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <20200717145813.62573-1-frankja@linux.ibm.com>
 <20200717145813.62573-3-frankja@linux.ibm.com>
 <78da93f7-118d-2c1d-582a-092232f36108@redhat.com>
 <032c1103-3020-9deb-a307-70ded3bdb55e@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <1aa0a21c-90c9-0214-1869-87cc60a46548@redhat.com>
Date:   Tue, 21 Jul 2020 16:28:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <032c1103-3020-9deb-a307-70ded3bdb55e@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/07/2020 10.52, Janosch Frank wrote:
> On 7/21/20 9:28 AM, Thomas Huth wrote:
>> On 17/07/2020 16.58, Janosch Frank wrote:
>>> If a exception new psw mask contains a key a specification exception
>>> instead of a special operation exception is presented.
>>
>> I have troubles parsing that sentence... could you write that differently?
>> (and: "s/a exception/an exception/")
> 
> How about:
> 
> When an exception psw new with a storage key in its mask is loaded from
> lowcore a specification exception is raised instead of the special
> operation exception that is normally presented when skrf is active.

Still a huge beast of a sentence. Could you maybe make two sentences out
of it? For example:

" ... is raised. This differs from the normal case where ..."

?

 Thomas

