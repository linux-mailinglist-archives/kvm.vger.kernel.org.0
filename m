Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8BE518297
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 12:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbiECKyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 06:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiECKys (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 06:54:48 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 03 May 2022 03:51:16 PDT
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 884333153E
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 03:51:16 -0700 (PDT)
Received: from BC-Mail-Ex14.internal.baidu.com (unknown [172.31.51.54])
        by Forcepoint Email with ESMTPS id 85B351E3AB7C7979F825;
        Tue,  3 May 2022 18:05:35 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex14.internal.baidu.com (172.31.51.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Tue, 3 May 2022 18:05:35 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Tue, 3 May 2022 18:05:35 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXVt2Ml0gS1ZNOiBWTVg6IG9wdGltaXplIHBpX3dha2V1?=
 =?gb2312?Q?p=5Fhandler?=
Thread-Topic: [PATCH][v2] KVM: VMX: optimize pi_wakeup_handler
Thread-Index: AQHYSvNqxtjlfBde+UiIS2mAZB88kK0NFIcQ
Date:   Tue, 3 May 2022 10:05:35 +0000
Message-ID: <f3d319a413074b70b4713206312052f8@baidu.com>
References: <1649244302-6777-1-git-send-email-lirongqing@baidu.com>
 <Yk+i8S1y9s8YGiST@google.com>
In-Reply-To: <Yk+i8S1y9s8YGiST@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.21.146.46]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGkgUm9uZ1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29t
Pg0KPiA+IC0tLQ0KPiANCj4gUmV2aWV3ZWQtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5q
Y0Bnb29nbGUuY29tPg0KDQoNClBpbmcNCg0KVGhhbmtzDQoNCi1MaQ0K
