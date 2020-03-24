Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48E90190D27
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 13:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgCXMRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 08:17:33 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:20317 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726968AbgCXMRc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 08:17:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585052252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Fg2iU+81quK5qxNBft0sGOHtSxcJKoYxa8Ig+wK5Urk=;
        b=i9pZMveuUGkrcDeZ4a8rPv8WrudXQfEioajfzwM94drqz+3QT6zsqwqeUC3mcymP6LS+E0
        OFYU6LC30hU9BTBXsfwiIqWIE47d0SiNH1NvMzgVyaI7ewy/xj9MrckX0BIPIxaW8to38J
        yM3cMG/Umjdrr1e9zMIgSSo8hyTlJgU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-UoKbQMhiMJup6yE5wdbYqg-1; Tue, 24 Mar 2020 08:17:30 -0400
X-MC-Unique: UoKbQMhiMJup6yE5wdbYqg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9126A800D50;
        Tue, 24 Mar 2020 12:17:29 +0000 (UTC)
Received: from localhost (ovpn-113-109.ams2.redhat.com [10.36.113.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 574335C290;
        Tue, 24 Mar 2020 12:17:26 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH 0/2] kvm-unit-tests: s390x MAINTAINERS tweaks
Date:   Tue, 24 Mar 2020 13:17:20 +0100
Message-Id: <20200324121722.9776-1-cohuck@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm trying to review s390x patches, so let's reflect that.
Also, it makes sense to cc: linux-s390 on s390x patches, I guess.

Cornelia Huck (2):
  s390x: add myself as reviewer
  s390x: add linux-s390 list

 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

--=20
2.21.1

