Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A288FDB5A
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfKOK2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:28:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30136 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727515AbfKOK2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 05:28:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573813683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XFb6f9ZD8GvCwoOpidgioSbW7JaXjek7/iHylcipBMA=;
        b=crQs6xiT9Gm3cQ2SUCJGWSuwajSWnUFt4lzOlVnwIJNbDHN0oq4qfSMbo9p1YT007BimTd
        FjhHLUFJTuukNOyjtKMz0J68CKpLjfP7E7E1IfvEprnqr7S/IEw/BJpJHWKlFUg9+iL6+1
        68qoEGk//7CYCOEQwDu+V07TghKMrDg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-QR9weNsqM3G33dWHhslCsw-1; Fri, 15 Nov 2019 05:28:00 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45F00DB21;
        Fri, 15 Nov 2019 10:27:58 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-14.ams2.redhat.com [10.36.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 72BC32D269;
        Fri, 15 Nov 2019 10:27:53 +0000 (UTC)
Subject: Re: [RFC 31/37] KVM: s390: protvirt: Add diag 308 subcode 8 - 10
 handling
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-32-frankja@linux.ibm.com>
 <a1c263ff-954e-a7c3-28b4-e9bd866eb35f@redhat.com>
 <f9ecf949-3f0d-fb64-cc77-44974a71625e@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <e8e80d38-ef63-c394-0e5d-9dbfdfc5241f@redhat.com>
Date:   Fri, 15 Nov 2019 11:27:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <f9ecf949-3f0d-fb64-cc77-44974a71625e@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: QR9weNsqM3G33dWHhslCsw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/11/2019 11.20, Janosch Frank wrote:
> On 11/15/19 11:04 AM, Thomas Huth wrote:
>> On 24/10/2019 13.40, Janosch Frank wrote:
>>> If the host initialized the Ultravisor, we can set stfle bit 161
>>> (protected virtual IPL enhancements facility), which indicates, that
>>> the IPL subcodes 8, 9 and are valid. These subcodes are used by a
>>> normal guest to set/retrieve a IPIB of type 5 and transition into
>>> protected mode.
>>>
>>> Once in protected mode, the VM will loose the facility bit, as each
>>
>> So should the bit be cleared in the host code again? ... I don't see
>> this happening in this patch?
>>
>>  Thomas
>=20
> No, KVM doesn't report stfle facilities in protected mode and we would
> need to add it again in normal mode so just clearing it would be
> pointless. In protected mode 8-10 do not intercept, so there's nothing
> we need to do.

Ah, ok, that's what I've missed. Maybe replace "the VM will loose the
facility bit" with "the ultravisor will conceal the facility bit" ?

 Thomas

