Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A82C6EE2B4
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 15:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbfKDOiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 09:38:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60264 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728144AbfKDOiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 09:38:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572878298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DZfnLrfces0ZugBom8qxl+uD+Z+o+diKWfTsf6evUHo=;
        b=W6zGSRANN37pCjTApMWPzQb/u01qwNtVjdUaWXwNacXjgfSEgHZPQCV0ZfpHtZjPnc5ADh
        5hMJrRaFl4+pdluP+6M90Rcbbmsntc/9uzr2UKkX0Z8gyN1Fe6nWN4OSQwD6jzkb/40tLg
        OdfIJNfazrmuSnuqCIK5Bv0RY+ZwWyo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-Qf-LYL_hP3-HoK8Jn4FAWQ-1; Mon, 04 Nov 2019 09:38:15 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4F9E1800D53;
        Mon,  4 Nov 2019 14:38:13 +0000 (UTC)
Received: from [10.36.117.96] (ovpn-117-96.ams2.redhat.com [10.36.117.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0FBA5D70D;
        Mon,  4 Nov 2019 14:38:11 +0000 (UTC)
Subject: Re: [RFC v2] KVM: s390: protvirt: Secure memory is not mergeable
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-8-frankja@linux.ibm.com>
 <20191025082446.754-1-frankja@linux.ibm.com>
 <7918ea28-8f10-dc1c-e35b-c1b66631877e@redhat.com>
 <12ddbeda-5abb-fffa-ad1b-c2f0397c8391@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <c2562008-7306-1e7b-3bd0-c54d952b9cbc@redhat.com>
Date:   Mon, 4 Nov 2019 15:38:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <12ddbeda-5abb-fffa-ad1b-c2f0397c8391@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: Qf-LYL_hP3-HoK8Jn4FAWQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.19 15:36, Janosch Frank wrote:
> On 11/4/19 3:32 PM, David Hildenbrand wrote:
>> On 25.10.19 10:24, Janosch Frank wrote:
>>> KSM will not work on secure pages, because when the kernel reads a
>>> secure page, it will be encrypted and hence no two pages will look the
>>> same.
>>>
>>> Let's mark the guest pages as unmergeable when we transition to secure
>>> mode.
>>
>> Patch itself looks good to me, but I do wonder: Is this really needed
>> when pinning all encrypted pages currently?
>>
>> Not sure about races between KSM and the pinning/encrypting thread,
>> similar to paging, though ...
>>
>=20
> The pinning was added several months after I wrote the patch.
> Now that we have it, we really need to have another proper look at the
> whole topic.
>=20
> Thanks for your review :-)

I'd certainly prefer this patch (+some way to mlock) over pinning ;)

You can have

Reviewed-by: David Hildenbrand <david@redhat.com>

For this patch, if you end up needing it :)

--=20

Thanks,

David / dhildenb

