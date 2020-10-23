Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C48296864
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 03:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374442AbgJWB6G convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 22 Oct 2020 21:58:06 -0400
Received: from mx21.baidu.com ([220.181.3.85]:47894 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S374108AbgJWB6G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 21:58:06 -0400
Received: from BC-Mail-Ex16.internal.baidu.com (unknown [172.31.51.56])
        by Forcepoint Email with ESMTPS id 120A4E0366D95B1BB427;
        Fri, 23 Oct 2020 09:58:00 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex16.internal.baidu.com (172.31.51.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1979.3; Fri, 23 Oct 2020 09:57:59 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.1979.006; Fri, 23 Oct 2020 09:57:59 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: RE: [PATCH][v3] KVM: x86/mmu: fix counting of rmap entries in
 pte_list_add
Thread-Topic: [PATCH][v3] KVM: x86/mmu: fix counting of rmap entries in
 pte_list_add
Thread-Index: AQHWlKp6GOVVttHQQEisdQbuk7+UL6mklifQ
Date:   Fri, 23 Oct 2020 01:57:59 +0000
Message-ID: <5acfbee6941e46118eb4479b79233368@baidu.com>
References: <1601196297-24104-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1601196297-24104-1-git-send-email-lirongqing@baidu.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.38]
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



+AD4- -----Original Message-----
+AD4- From: Li,Rongqing
+AD4- Sent: Sunday, September 27, 2020 4:45 PM
+AD4- To: Li,Rongqing +ADw-lirongqing+AEA-baidu.com+AD4AOw- kvm+AEA-vger.kernel.org+ADs-
+AD4- x86+AEA-kernel.org+ADs- sean.j.christopherson+AEA-intel.com
+AD4- Subject: +AFs-PATCH+AF0AWw-v3+AF0- KVM: x86/mmu: fix counting of rmap entries in
+AD4- pte+AF8-list+AF8-add
+AD4- 
+AD4- Fix an off-by-one style bug in pte+AF8-list+AF8-add() where it failed to account the last
+AD4- full set of SPTEs, i.e. when desc-+AD4-sptes is full and desc-+AD4-more is NULL.
+AD4- 
+AD4- Merge the two +ACI-PTE+AF8-LIST+AF8-EXT-1+ACI- checks as part of the fix to avoid an extra
+AD4- comparison.
+AD4- 
+AD4- Signed-off-by: Li RongQing +ADw-lirongqing+AEA-baidu.com+AD4-
+AD4- Reviewed-by: Sean Christopherson +ADw-sean.j.christopherson+AEA-intel.com+AD4-


Ping 


Thanks

-Li
