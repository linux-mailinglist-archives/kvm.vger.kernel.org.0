Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C431CFB701
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 19:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKMSGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 13:06:41 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57354 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfKMSGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 13:06:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573668399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sW3bxKekubakcaII8zSQ1CSMjxoo4vTeUozLl6kqOxQ=;
        b=VERIqmw/oXXUUzZioTfSSisFEi9XX08S3fctY8JBSLFboZIQO1IKOMVtv5ZY2gZQgHXkBk
        Vm9jOwy3e6eQ+yP4j9TVqxsDyf1xEPf7zMJL7jFA9iuhHQpSqbLoPT+dXf8CGAct1mQbjU
        g5Ai5nohtshnhZjcx68lOiOScg2tMVM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-BEMNKOWTMKmzHejaJbhmhg-1; Wed, 13 Nov 2019 13:06:36 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CEEA218A5140;
        Wed, 13 Nov 2019 18:06:35 +0000 (UTC)
Received: from [10.36.116.48] (ovpn-116-48.ams2.redhat.com [10.36.116.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8EE310841A9;
        Wed, 13 Nov 2019 18:06:34 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4] s390x: Load reset psw on diag308 reset
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com
References: <e54ce8f8-7ed5-3eee-6715-8b5051cb49fb@redhat.com>
 <20191113112403.7664-1-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <f8393e14-79a3-694e-d457-dff20b28f62a@redhat.com>
Date:   Wed, 13 Nov 2019 19:06:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191113112403.7664-1-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: BEMNKOWTMKmzHejaJbhmhg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13.11.19 12:24, Janosch Frank wrote:
> On a diag308 subcode 0 CRs will be reset, so we need a PSW mask
> without DAT. Also we need to set the short psw indication to be
> compliant with the architecture.
>=20
> Let's therefore define a reset PSW mask with 64 bit addressing and
> short PSW indication that is compliant with architecture and use it.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Queued to

https://github.com/davidhildenbrand/kvm-unit-tests.git s390x-next

I'll most probably wait a bit for the SCLP stuff to settle to send a=20
pull request!

--=20

Thanks,

David / dhildenb

