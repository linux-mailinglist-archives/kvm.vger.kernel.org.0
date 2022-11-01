Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD07614850
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 12:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiKALQZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 1 Nov 2022 07:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiKALQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 07:16:23 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7A6183A7
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 04:16:22 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-148-T16JRegdN2KCP6Vv8a13JA-1; Tue, 01 Nov 2022 11:16:19 +0000
X-MC-Unique: T16JRegdN2KCP6Vv8a13JA-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 1 Nov
 2022 11:16:17 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.042; Tue, 1 Nov 2022 11:16:17 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Bo Liu' <liubo03@inspur.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] KVM: replace ternary operator with min()
Thread-Topic: [PATCH] KVM: replace ternary operator with min()
Thread-Index: AQHY7cMaIkkRYJlAy0yMrTd+ywOc6K4p6rBQ
Date:   Tue, 1 Nov 2022 11:16:17 +0000
Message-ID: <d8a518c4a4014307b30020b38022d633@AcuMS.aculab.com>
References: <20221101072513.7364-1-liubo03@inspur.com>
In-Reply-To: <20221101072513.7364-1-liubo03@inspur.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bo Liu
> Sent: 01 November 2022 07:25
> 
> Fix the following coccicheck warning:
> 
> virt/kvm/kvm_main.c:5289:10-11: WARNING opportunity for min()
...
> -	return r < 0 ? r : 0;
> +	return min(r, 0);

As has been repeatedly pointer out this is bogus.
min() should only be used for 'sizes'.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

