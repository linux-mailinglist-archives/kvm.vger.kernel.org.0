Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99BD7EE294
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 15:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbfKDOcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 09:32:41 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50861 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728188AbfKDOck (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 09:32:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572877959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZaGj0cmwGXtLMocBgOE92E1O/1GJeDLx3+wtUyqAgVE=;
        b=AGa5DquEeicjziV/yOrLv1qqFjEQO6zVROnOPBMZ9VECH5vzBbXfHzcxxLLuHfMVYxnePW
        LbAHRfkLmotXbbldAjwrquaDt+t9EE/qgtcneUc3FMOwVpgTPerD6na7tnc+CBGlwILY1K
        QnrR3Hvl28mePkFdnGDE32QgtsFkx0E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-Yc-Qc-7bNoC0bKi9K22FKQ-1; Mon, 04 Nov 2019 09:32:36 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADAE01800D53;
        Mon,  4 Nov 2019 14:32:34 +0000 (UTC)
Received: from [10.36.117.96] (ovpn-117-96.ams2.redhat.com [10.36.117.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36E8F60874;
        Mon,  4 Nov 2019 14:32:26 +0000 (UTC)
Subject: Re: [RFC v2] KVM: s390: protvirt: Secure memory is not mergeable
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-8-frankja@linux.ibm.com>
 <20191025082446.754-1-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <7918ea28-8f10-dc1c-e35b-c1b66631877e@redhat.com>
Date:   Mon, 4 Nov 2019 15:32:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191025082446.754-1-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: Yc-Qc-7bNoC0bKi9K22FKQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25.10.19 10:24, Janosch Frank wrote:
> KSM will not work on secure pages, because when the kernel reads a
> secure page, it will be encrypted and hence no two pages will look the
> same.
>=20
> Let's mark the guest pages as unmergeable when we transition to secure
> mode.

Patch itself looks good to me, but I do wonder: Is this really needed=20
when pinning all encrypted pages currently?

Not sure about races between KSM and the pinning/encrypting thread,=20
similar to paging, though ...

--=20

Thanks,

David / dhildenb

