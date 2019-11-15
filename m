Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E894CFD8BD
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 10:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfKOJV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 04:21:57 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36236 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726980AbfKOJV5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 04:21:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573809715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ejn5ou+xVtsawYYNZo6bKeNtD7VyJxDt6Ce0yTz2Hhs=;
        b=V3uVDrzNzYcuAJPclQaLyBrCXOpkeEc++FEuRpGfQztmXt4mTtE378RfWs/4+OGNBaEpUF
        WcDCPxR5xeTY1O3bg+s2Hv0AYVtgMkT1KBbH8BJxhb7kAfsUFtJ9tUfadVh45Qo2aL4e89
        4RGM+ODZxm8cwYXlKcEkFTcx7tJBOJ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-0i3Rt1xxOBq1AjSwXF8PCw-1; Fri, 15 Nov 2019 04:21:52 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CB29802696;
        Fri, 15 Nov 2019 09:21:51 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-14.ams2.redhat.com [10.36.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A10766098;
        Fri, 15 Nov 2019 09:21:46 +0000 (UTC)
Subject: Re: [PATCH] Fixup sida bouncing
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com
References: <ad0f9b90-3ce4-c2d2-b661-635fe439f7e2@redhat.com>
 <20191114162153.25349-1-frankja@linux.ibm.com>
 <016cea87-9097-ca8b-2d19-9f69cdff3af6@redhat.com>
 <87488647-8a49-d555-e3fc-3b218dd022d1@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <0e660f27-db7d-0c44-9ecf-dbfeee459c4d@redhat.com>
Date:   Fri, 15 Nov 2019 10:21:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <87488647-8a49-d555-e3fc-3b218dd022d1@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 0i3Rt1xxOBq1AjSwXF8PCw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/11/2019 09.50, Janosch Frank wrote:
> On 11/15/19 9:19 AM, Thomas Huth wrote:
[...]
>> Still, is there a way you could also verify that gaddr references the
>> right page that is mirrored in the sidad?
>>
>>  Thomas
>>
>=20
> I'm not completely sure if I understand your question correctly.
> Checking that is not possible here without also looking at the
> instruction bytecode and register contents which would make this patch
> ridiculously large with no real benefit.

Yes, I was thinking about something like that. I mean, how can you be
sure that the userspace really only wants to read the contents that are
references by the sidad? It could also try to read or write e.g. the
lowcore data inbetween (assuming that there are some code paths left
which are not aware of protected virtualization yet)?

Well, it does not have to be right now and in this patch, but I still
think that's something that should be added in the future if somehow
possible...

 Thomas

