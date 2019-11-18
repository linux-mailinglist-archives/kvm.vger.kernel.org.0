Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEACA1003B3
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 12:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfKRLVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 06:21:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33144 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726460AbfKRLVh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 06:21:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574076096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s3LIKc5dlqPBr4zoLHUezjYDKoI0ozQGqARqJuIeNGc=;
        b=HZY3HfQVXTw3lDT+EBa9LAgBhhdr9PEMQMi8TiIdQJALV0FxbGUgcfdPcQ247rt2kw0Qfn
        CNU15+brxfP4yToBueS1HEjtUev0nDDb0NxhNelr/uwR12fQsnjig3lzSYfevfCV6NfOj3
        gdHPOmd4EJNFUruFkl78ONL8lMjhWjM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-BzdzJlDvM2O5WdkgV4ESJw-1; Mon, 18 Nov 2019 06:21:33 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCE69107ACFA;
        Mon, 18 Nov 2019 11:21:31 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-200.ams2.redhat.com [10.36.116.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B7B8C608F6;
        Mon, 18 Nov 2019 11:21:24 +0000 (UTC)
Subject: Re: [kvm-unit-tests PULL 00/12] s390x and Travis CI updates
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20191118100719.7968-1-david@redhat.com>
 <2fa73a05-1725-d553-483b-7ad1c4c5036b@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <044f5e92-ffe2-ebaf-173f-f68ae999d991@redhat.com>
Date:   Mon, 18 Nov 2019 12:21:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <2fa73a05-1725-d553-483b-7ad1c4c5036b@de.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: BzdzJlDvM2O5WdkgV4ESJw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/11/2019 12.11, Christian Borntraeger wrote:
> For what its worth (maybe a future patch) travis has now alpha s390x buil=
d support
> https://docs.travis-ci.com/user/multi-cpu-architectures
>=20
> I think the number of instances for s390 is still limited, but it works f=
or open
> source software.

I already tried that... Unfortunately the LXD containers that they use
on s390x (and ppc64 and arm64) are rather limited - you can't use KVM
here on Travis, unlike with x86.

So the only advantage of adding a s390x build here is that we'd check
native builds instead of using the cross compiler... not sure whether
that gives us that much more of test coverage for the kvm-unit-tests...

 Thomas

