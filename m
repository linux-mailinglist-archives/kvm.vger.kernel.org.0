Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC681DBC67
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 20:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgETSMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 14:12:49 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32298 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726510AbgETSMs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 14:12:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589998367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=zrw5y7kLFs3H7gZeyqDRl7rn5ygDIp8+n8h/0YJPWVI=;
        b=B4bC87k9pmNYo0t09OHoGcbRWl3/v9ZoidSc5OpufmRCKfnseMla3PPpqlvbxuCbKFdSav
        mE6gNgI1sYTTY25nux2Wu9N/urK9E1k4dVJTpQbZMQbjZP3pJ3Cgq+962Ohv2xBc8cSGGE
        aqtk10XizqCBqOt4DgGwpoAqAimcE1o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-CrulUyWvP3-cx0zX3tnSag-1; Wed, 20 May 2020 14:12:45 -0400
X-MC-Unique: CrulUyWvP3-cx0zX3tnSag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01DD11800D42;
        Wed, 20 May 2020 18:12:44 +0000 (UTC)
Received: from starship.redhat.com (unknown [10.35.207.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2C2010640E1;
        Wed, 20 May 2020 18:12:41 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        linux-usb@vger.kernel.org (open list:THUNDERBOLT DRIVER),
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        Jiri Kosina <trivial@kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/1] RFC: Make thunderbolt NHI driver work with kexec
Date:   Wed, 20 May 2020 21:12:39 +0300
Message-Id: <20200520181240.118559-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While trying to use kexec on my desktop,=0D
which has Titan Ridge Thunderbolt add-on card,=0D
I noticed that after a kexec, system hangs=0D
for about a minute in the 'wating for udev devices=0D
to settle' phase of the boot.=0D
=0D
I found out that if I unload the thunderbolt driver=0D
prior to the kexec, then it works just fine.=0D
=0D
Looking at the code I see that the driver doeesn't=0D
implement .shutdown method, so this on-liner patch=0D
points it to the same method that is used on device removal.=0D
=0D
I don't know if this is the right solution,=0D
but it does appear to work just fine with this patch.=0D
=0D
What do you think?=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (1):=0D
  thunderbolt: add trivial .shutdown=0D
=0D
 drivers/thunderbolt/nhi.c | 1 +=0D
 1 file changed, 1 insertion(+)=0D
=0D
-- =0D
2.25.4=0D
=0D

