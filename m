Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 557891A34EA
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 15:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgDINcw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 09:32:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44460 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726552AbgDINcw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 09:32:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586439172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1rsPbNYR0vQvYBWNFefGkmqQV/ZkHcmo1vgmZC2vNyk=;
        b=VokTll+qLK31CtWc91+0MNBXBvaes3IK+Q8NbWei76/4q9S69WO6FH6cp761+ppBstIhmi
        jjYtpqluICe3KyuueoPJ0KJlKlyno15cXhTFLGDRLiM4uWLCYeur9uLIbd7ZNgOBrgh8oi
        K3Gyd75MN1NcXPltEst0dHu5q224wx8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-MCxFUsmWO2u2PovlGx0EFw-1; Thu, 09 Apr 2020 09:32:49 -0400
X-MC-Unique: MCxFUsmWO2u2PovlGx0EFw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E81698017F6
        for <kvm@vger.kernel.org>; Thu,  9 Apr 2020 13:32:48 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-69.rdu2.redhat.com [10.10.113.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7317110027AC;
        Thu,  9 Apr 2020 13:32:48 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests 0/2] svm: NMI injection and HLT tests
Date:   Thu,  9 Apr 2020 09:32:45 -0400
Message-Id: <20200409133247.16653-1-cavery@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 1 is NMI injection and intercept. Patch 2 is the same test with gue=
st in
HLT.

Cathy Avery (2):
  svm: Add test cases around NMI injection
  svm: Add test cases around NMI injection with HLT

 x86/svm_tests.c | 187 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 187 insertions(+)

--=20
2.20.1

