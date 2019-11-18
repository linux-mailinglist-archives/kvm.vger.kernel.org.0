Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0E3100213
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 11:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfKRKIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 05:08:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31089 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726490AbfKRKIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 05:08:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574071685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nC0AqvvWidkax+v3pzB/eWLt038JFSPeFc6EVeNhyyY=;
        b=gG0BdZP8BGVfpJBetbe+vRBncCH5ccPs0VTf3EyvBJzbprC/H+L79c8sg68ZFQWZDLF20i
        Y8ZMy8160UmFgS9ZZmi6RbbMB9otJLh8cWfhMkyMwRQ2vV11V6KgfZEeO9tGcie6kH3r/q
        14oqjQBOQu4TdNBt2ARUBm23ADm/vaw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-reG-CCP9NquAiUQ4nKFOFw-1; Mon, 18 Nov 2019 05:08:02 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3984107ACFE;
        Mon, 18 Nov 2019 10:08:00 +0000 (UTC)
Received: from t460s.redhat.com (unknown [10.36.118.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A31925090C;
        Mon, 18 Nov 2019 10:07:45 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 02/12] s390x: remove redundant defines
Date:   Mon, 18 Nov 2019 11:07:09 +0100
Message-Id: <20191118100719.7968-3-david@redhat.com>
In-Reply-To: <20191118100719.7968-1-david@redhat.com>
References: <20191118100719.7968-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: reG-CCP9NquAiUQ4nKFOFw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Message-Id: <1572023194-14370-2-git-send-email-imbrenda@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/sclp.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 4e69845..f00c3df 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -27,8 +27,6 @@
 #define SCLP_ASSIGN_STORAGE                     0x000D0001
 #define SCLP_CMD_READ_EVENT_DATA                0x00770005
 #define SCLP_CMD_WRITE_EVENT_DATA               0x00760005
-#define SCLP_CMD_READ_EVENT_DATA                0x00770005
-#define SCLP_CMD_WRITE_EVENT_DATA               0x00760005
 #define SCLP_CMD_WRITE_EVENT_MASK               0x00780005
=20
 /* SCLP Memory hotplug codes */
--=20
2.21.0

