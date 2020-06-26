Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE7020AEEE
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 11:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgFZJ0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 05:26:03 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:59908 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726530AbgFZJ0C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Jun 2020 05:26:02 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 26 Jun 2020 02:25:55 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id E1F92B2723;
        Fri, 26 Jun 2020 05:25:59 -0400 (EDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 0/3] x86: realmode: fixes
Date:   Fri, 26 Jun 2020 02:23:30 -0700
Message-ID: <20200626092333.2830-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: namit@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some fixes for realmode tests.

Nadav Amit (3):
  x86: realmode: initialize idtr
  x86: realmode: hlt loop as fallback on exit
  x86: realmode: fix lss test

 x86/realmode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

-- 
2.20.1

