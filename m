Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA7E415B6C3
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 02:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgBMBkk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 12 Feb 2020 20:40:40 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2996 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729285AbgBMBkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 20:40:40 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id AC18451B0B0C189886A8;
        Thu, 13 Feb 2020 09:40:37 +0800 (CST)
Received: from dggeme714-chm.china.huawei.com (10.1.199.110) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 13 Feb 2020 09:40:37 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme714-chm.china.huawei.com (10.1.199.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 13 Feb 2020 09:40:37 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Thu, 13 Feb 2020 09:40:37 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: enable -Werror
Thread-Topic: [PATCH] KVM: x86: enable -Werror
Thread-Index: AdXiDh8HEdzRFxtk30KOnryNxomXqA==
Date:   Thu, 13 Feb 2020 01:40:37 +0000
Message-ID: <12259a951c5e47359c46f7875e758d41@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> wrote:
>Avoid more embarrassing mistakes.  At least those that the compiler can catch.
>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>---

Never mind. It is said that "Not everybody is a sage. Who can be entirely free from error?" :)
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

