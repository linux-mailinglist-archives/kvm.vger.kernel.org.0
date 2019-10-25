Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A22DE45E8
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 10:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408340AbfJYIlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 04:41:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22582 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2408333AbfJYIlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 04:41:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571992866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4XhRtr5LWhRVIyQ2MMLk4xLQroiFVaZUl3mlMaGqRoI=;
        b=T/yLNPCzJc6jPnIEXm93P9ZROaPlSa/vFqQBD4NYahb2dN5nLngQKdV95tWSiDsaiOA/2z
        GgV//HBAAM5zQwjNW4Um2HgCJs0MVj+vb5mm9pweXEbINB5trtGSWHWnpemDPv1mJCxfcP
        EPlAPsx7S3dqmjiP2RADEg6JtJwIijg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-Au9UPWCBOmCDMCvXuyThTA-1; Fri, 25 Oct 2019 04:41:03 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BD225E6;
        Fri, 25 Oct 2019 08:41:01 +0000 (UTC)
Received: from [10.36.116.205] (ovpn-116-205.ams2.redhat.com [10.36.116.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAF315D70E;
        Fri, 25 Oct 2019 08:40:59 +0000 (UTC)
Subject: Re: [RFC 06/37] s390: UV: Add import and export to UV library
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-7-frankja@linux.ibm.com>
 <32166470-43c1-f454-440f-3f660b995ca2@redhat.com>
 <ed8860e6-176a-64dd-e697-5ed80dd3c872@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <257d9326-9af9-5986-aeb0-4323fb66c81d@redhat.com>
Date:   Fri, 25 Oct 2019 10:40:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <ed8860e6-176a-64dd-e697-5ed80dd3c872@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: Au9UPWCBOmCDMCvXuyThTA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25.10.19 10:39, Janosch Frank wrote:
> On 10/25/19 10:31 AM, David Hildenbrand wrote:
>> On 24.10.19 13:40, Janosch Frank wrote:
>>> The convert to/from secure (or also "import/export") ultravisor calls
>>> are need for page management, i.e. paging, of secure execution VM.
>>>
>>> Export encrypts a secure guest's page and makes it accessible to the
>>> guest for paging.
>>
>> How does paging play along with pinning the pages (from
>> uv_convert_to_secure() -> kvm_s390_pv_pin_page()) in a follow up patch?
>> Can you paint me the bigger picture?
>=20
> That's a stale comment I should have removed before sending...
> The current patches do not support paging.

Note that once you pin you really have to disable the balloon in the=20
QEMU (inhibit it).


--=20

Thanks,

David / dhildenb

