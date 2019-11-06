Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67540F1645
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 13:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbfKFMrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 07:47:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56543 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729960AbfKFMrc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 07:47:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573044451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pYRrDS+0x4JMzriQZzGqlme+/7LuWFuZEAXFd7mTkQ8=;
        b=am6ub5rt99aPaJwdHL8COA27NAxAD9/j+ecGcJTUMWlLiWxUOn46VQugYnKHfftHTctIuW
        lbxzY3sR+E1zAX0fzR08CkX24erpW++UNQlRIoXxxP94iP/JGU5lSbB10U/5AS2UKh40Wm
        B0YUCyMeiXqjOVPTX9HqTfzXpo6ZUnY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-OoiaJ6s-Pm-xlTdxl-6uUw-1; Wed, 06 Nov 2019 07:47:25 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A1821005500
        for <kvm@vger.kernel.org>; Wed,  6 Nov 2019 12:47:24 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8579600D5;
        Wed,  6 Nov 2019 12:47:20 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com,
        mtosatti@redhat.com
Subject: [kvm-unit-tests Patch v1 0/2] x86: Test IOAPIC physical and logical destination mode
Date:   Wed,  6 Nov 2019 07:47:07 -0500
Message-Id: <1573044429-7390-1-git-send-email-nitesh@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: OoiaJ6s-Pm-xlTdxl-6uUw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first patch adds smp configuration to ioapic unittest and
the second one adds the support to test both physical and logical destinati=
on
modes under fixed delivery mode.

Nitesh Narayan Lal (2):
  x86: ioapic: Add the smp configuration to ioapic unittest
  x86: ioapic: Test physical and logical destination mode

 x86/ioapic.c      | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++=
++++
 x86/unittests.cfg |  1 +
 2 files changed, 66 insertions(+)

