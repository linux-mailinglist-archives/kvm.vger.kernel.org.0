Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0745F2011BF
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 17:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404481AbgFSPo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:44:27 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22628 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404502AbgFSPoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 11:44:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592581464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qYyCmRniSAhtaolPB4KDJxvQUGNyX/WLZinq5HC+Wt4=;
        b=A1ZsFljKYO9AnTHTvsH8jHXXpL7ZxRpriNsha0GmYdpnT0Fbdg+CL8VC0KxSUG7eOiWC2s
        vpBH2QUamlt0FpAvPlMTfXdfMVm+Gbi/g7ahq8wUVnfBK9uTXp0hNM2Vm1kc6/7cNA8y36
        wZuMg3hdcJ4xC9JPMklPrtz2Y7Okjuk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-6_3xmcHcNmSweVVsQVgtJQ-1; Fri, 19 Jun 2020 11:44:22 -0400
X-MC-Unique: 6_3xmcHcNmSweVVsQVgtJQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBF2D80BC52;
        Fri, 19 Jun 2020 15:43:08 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB12F60BF4;
        Fri, 19 Jun 2020 15:43:06 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     vkuznets@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        Mohammed Gamal <mgamal@redhat.com>
Subject: [kvm-unit-test PATCH 0/2] access: Enable testing guest MAXPHYADDR < host MAXPHYADDR
Date:   Fri, 19 Jun 2020 17:42:54 +0200
Message-Id: <20200619154256.79216-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re-enable phys-bits=36 to test guest MAXPHYADDR < host MAXPHYADDR.
Also increase timeout for access tests since using NPT=0 may need
more time.

Mohammed Gamal (2):
  Revert "access: disable phys-bits=36 for now"
  unittests.cfg: Increase timeout for access test

 x86/unittests.cfg | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.26.2

