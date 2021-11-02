Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533CF4435E5
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 19:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhKBSqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 14:46:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33694 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230131AbhKBSqt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 14:46:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635878654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ke/apnUj6ltcvK88wrBZRr2HeoDo6T6P8MBaI3Hata4=;
        b=gd+fvoPuAm2uOcTWYHI5U4i/ORtKqALgc46l4dXgp6Wck+JAr4doEkya7v8i/wvhdVz/V3
        iZo0MKnhfpxVVwlP8jdeqMgW89ZHo1i9ow86sWXhvB7Fh8TELCcY7yMMSrHLP0mqTeNPOM
        O8JRisyJsCNhyEJspdBND8RXSDK+UV4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-cwOPeDilM2ulBzv86LCrZg-1; Tue, 02 Nov 2021 14:44:11 -0400
X-MC-Unique: cwOPeDilM2ulBzv86LCrZg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87EC61B18BC0;
        Tue,  2 Nov 2021 18:44:09 +0000 (UTC)
Received: from scv.redhat.com (unknown [10.22.11.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5453519C59;
        Tue,  2 Nov 2021 18:44:02 +0000 (UTC)
From:   John Snow <jsnow@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Darren Kenny <darren.kenny@oracle.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Alexander Bulekov <alxndr@bu.edu>,
        Markus Armbruster <armbru@redhat.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>, Bandan Das <bsd@redhat.com>,
        John Snow <jsnow@redhat.com>
Subject: [PATCH v5 0/4] docs/sphinx: change default `role` to "any"
Date:   Tue,  2 Nov 2021 14:43:56 -0400
Message-Id: <20211102184400.1168508-1-jsnow@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(Patches 1-3 can be squashed on merge, I just found it easier to tack on=0D
new changes as part of the rebase so that reviewers can easily see=0D
what's new each time.)=0D
=0D
V5: Rebased=0D
V4: Rebased=0D
V3: Removed bad rebase confetti=0D
    fixed the OSS-Fuzz link to ... actually be a link.=0D
=0D
--js=0D
=0D
John Snow (4):=0D
  docs: remove non-reference uses of single backticks=0D
  docs: (further) remove non-reference uses of single backticks=0D
  docs: (further further) remove non-reference uses of single backticks=0D
  docs/sphinx: change default role to "any"=0D
=0D
 docs/conf.py                           |  5 +++++=0D
 docs/devel/build-system.rst            | 21 +++++++++++----------=0D
 docs/devel/fuzzing.rst                 |  9 +++++----=0D
 docs/devel/tcg-plugins.rst             |  2 +-=0D
 docs/interop/live-block-operations.rst |  2 +-=0D
 docs/system/guest-loader.rst           |  2 +-=0D
 docs/system/i386/sgx.rst               |  6 +++---=0D
 qapi/block-core.json                   |  4 ++--=0D
 include/qemu/module.h                  |  6 +++---=0D
 qemu-options.hx                        |  4 ++--=0D
 10 files changed, 34 insertions(+), 27 deletions(-)=0D
=0D
-- =0D
2.31.1=0D
=0D

