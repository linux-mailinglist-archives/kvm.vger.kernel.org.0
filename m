Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24263143289
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 20:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgATTnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 14:43:20 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25135 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726607AbgATTnU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jan 2020 14:43:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579549399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TyG55MTjUoBMLEG8BW8OKgWBWAsVlRkkQJTLyAKX0ZE=;
        b=f3+8kIZ7Dh0qz1nHiPwO+ZML7rjV05JBFhkmcwbtz/j8jmmMKdSqFg8xG4Dk0EV8EiB0xk
        /6bTnh1sAyNuM11zqMAkLo/6SLh5eOcybFpKEFq3zPxqz6/S3qM2iDniFeoBN/glStJKSq
        BiyE/svW8z8IAwXZvS01F6z79ub1Gr4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-P8q-FFlsN0qNlb69DTVUNg-1; Mon, 20 Jan 2020 14:43:17 -0500
X-MC-Unique: P8q-FFlsN0qNlb69DTVUNg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83DD4804707
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2020 19:43:16 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-78.gru2.redhat.com [10.97.116.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 857F15C1BB;
        Mon, 20 Jan 2020 19:43:13 +0000 (UTC)
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com
Subject: [kvm-unit-tests v2 0/2] README: Markdown fixes and improvements
Date:   Mon, 20 Jan 2020 16:43:08 -0300
Message-Id: <20200120194310.3942-1-wainersm@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series does fix issues with formatting of the README's
markdown. On patch 02 is added a new section that describes
the test configuration file.

Changes v1 -> v2:
 - Keep markdown minimal while still fixing the formatting issues [drjone=
s]
 - Sent new content on separate patch (added patch 02) [drjones]

v1: https://lore.kernel.org/kvm/20200116212054.4041-1-wainersm@redhat.com

Wainer dos Santos Moschetta (2):
  README: Fix markdown formatting
  README: Add intro about the configuration file

 README.md | 83 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 50 insertions(+), 33 deletions(-)

--=20
2.23.0

